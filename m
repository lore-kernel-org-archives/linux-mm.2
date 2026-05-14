Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CE29CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AD296B008A; Thu, 14 May 2026 10:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2849F6B0092; Thu, 14 May 2026 10:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1BC6B0093; Thu, 14 May 2026 10:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 10E846B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:07:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A70EE1605F2
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:07:22 +0000 (UTC)
X-FDA: 84766202724.19.25999A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C83E3140006
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:07:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=giN1vQ0J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rostedt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rostedt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7lMIgdVYcJIvsyfsSYHB7hJzdmhvCjxPHzrgxeHgew=;
	b=UiMfztXhXXJ4wYLOkX9Cl6CJYI2DcB2y9tlRBPt9RjS+kzXCVPE34JlZPpdvk9YE69I8iC
	2ufxCdE72afkyVEjt4VIEtorcNQV6SN3f4MD/qmTBpFwt0eIiHSv+r5YynZclnut6YeeRz
	pJSUSC02b9vmFqdfPjNCiQTrWtO4q04=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767640; a=rsa-sha256;
	cv=none;
	b=494jbpmc+zfels53GerIAYjY+i1yShfSpzyszkLHtJTVY94lPVUTn148aJwkijhLW2XDUm
	t7lcan3UF02nm90nznFcfCXAIUrUeUP+OjwRa2rp08O4wxqo7fawOmXNqcejGdqEjWg6k/
	7eC33snhY7rGjdJQqOe/1yrdPYjMexY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=giN1vQ0J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rostedt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rostedt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E7F960132;
	Thu, 14 May 2026 14:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B296BC2BCB3;
	Thu, 14 May 2026 14:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767639;
	bh=SljYy922EKprhVLw58TOfj61Tmqw0lsczsezaC5udbo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=giN1vQ0JtHDc/Q5fJKc91E6BJcGYXEgQcA+7YOPGUa1bluOJN1ffxMOTLu8JbU0ai
	 Ovc44SysZiV2+D48OKSnsErvicN/SeoQhStSSmR0nrRoSv/EIecMrmPxW2PveQd/Un
	 XPqyDhURqziK5eEbndTHb7wDvsISii5DppMUwJWK/l6IX5wCCoz096ZDEWZJZpqb1c
	 4svXDyPLbNS4PlsrhXCoM+kLuTSQ5GXBoYLothoJo9sPF+FUHz5hfc1gFOaJ0LSVJJ
	 013j8Y4i0EO+IQ5C3Ew8r84joM7ekMHLZpylxguHpiy64+j0fqNZ+u47DOtilRPzGt
	 k6S/Y7Bl+k+fQ==
Date: Thu, 14 May 2026 10:07:23 -0400
From: Steven Rostedt <rostedt@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, LKML
 <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Alice Ryhl
 <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>,
 maple-tree@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] maple_tree: document that "last" in
 mtree_insert_range() is inclusive
Message-ID: <20260514100723.4af0d7ba@gandalf.local.home>
In-Reply-To: <20260514014205.149093-1-sj@kernel.org>
References: <20260512175623.4c5ca8d2@gandalf.local.home>
	<20260514014205.149093-1-sj@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C83E3140006
X-Stat-Signature: 78rjcxsku7fbqpfrd7yfeko11y538tjq
X-Rspam-User: 
X-HE-Tag: 1778767640-771694
X-HE-Meta: U2FsdGVkX1+/4C6ds/kiMq1jDOFyazdMo+lReBcNdxcNDaqCXAPfptTN13tIgnOmcxPgWXpWvfEpnwpmlXAg7wzpcf3ptqRv/q0++idOPZfJQJOdOO99NIsckJ4l+/TMjREsJbo6Uav+g/tjIZ9SI6AFJ6cB1bPoAGbSmNKZqAyPosiiWYizfijX7xif45xBOLLHD11ax29cot4zdUj3al8WvU64Lvx++wUjTnlAumv5qVn6zRIKMOlzMMsfz6pEkpPmAEJL+TIzHhHwBr+S+5EkixFsgqX9O+JCx8MUEU1QoPbqN1GLwOlp77xf/oWouV+29WZrTcINL/+eiofyiOo2NrggIA7ptofZiYvrDRkpFTlvokYT3ufb0Gijl+HagsQMtHXmvvDQrv5IJ5QWolv56OsymKO5npY2sD+S3rhe7n0LsGuekGtebpjkJMiABry2KUTG+Gd9NcyQZr+boH5/TZAKNPKWXPauca8ZSn5jl/2wuFy0IEf8yjFR8ZFX9Hhaj0uvQN/o9TN3vMDgwOxFh+IrxTTkxWzqXFO4kl4Kz/CWTXHIKwBDtI0uoTzXjb7nAbMxri3e66yrqTzbFfZx7II6OI4VXYPvWzj0f5DxgXV99Ei4DHODmz+M/oBaje1pukZ/LjAo4VISS91LIBuVvA2JnXDrhnvFThMMHiVwwEuOZVvmvrPlI7PU6uaBZESKCF2bYpeIvgefozBGGlvOQm5BbctDFQaqaVWxhFBUvkAJ3qZLkIkzWsjVtJ3/49CnGshHw/2Zy/uvmNdPI+4EY2ZUt8NLbJJXRS3TIgVGOJavFU0krtPdSJCbxOuZfYjnEocz80tPXObrcHmgf1uDqhVscEfDeCW23KT8coGpUx1dV5hVwjdU6rZazp748TShuVQAcyQ+y+onhD8RD/ODcCojR0Y2LHCthBqVi/S9lE56qVjaD7hURKS0q/Of5PXwk+I0EZSgyKB5H2u
 HV5dn+rF
 YIyQnlvyIzWHJ9isL+V0Mo44fj1RKA5Gs9JumetZ8LI60tr7OU97M6LMIxrw5mvbCuWpW1Hw/p5elMt3Cu5327lg6YnhwU7Wl8VPvb3T12L0tO/RHXeWqOIQBZXy/dwQ4/zgY0fW/4haiW5gRdKalvdVPQ4W/e/MyAKQOVfqXrGu8Y/MFgKaCFz8jf10f5Ua5YtUCuQ1RNZy1Kq5IHrM3ArBdmxdsdc+jPP/N1l5dGe/M3Cag1kWFU/8NcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 18:42:04 -0700
SeongJae Park <sj@kernel.org> wrote:

> >  /**
> > - * mtree_insert_range() - Insert an entry at a given range if there is no value.
> > + * mtree_insert_range() - Insert an entry from [first, last] at a given range
> > + *                        if there is no value.  
> 
> It feels "at a given range" bit repetitive to me.  s/at a given range// ?
> 

I just added what Liam suggested. Should I send a v3?

-- Steve

