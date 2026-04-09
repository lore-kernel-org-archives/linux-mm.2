Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04197EA3C22
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55DFE6B0005; Thu,  9 Apr 2026 06:09:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535846B0088; Thu,  9 Apr 2026 06:09:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472B16B008A; Thu,  9 Apr 2026 06:09:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 38BCA6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:09:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B575C13B814
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:09:47 +0000 (UTC)
X-FDA: 84638596014.04.4BE20EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0F1F04000F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:09:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W9oXowWs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775729386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gDPlLIZMDSKGp8rM/tAzo6PGs3I0TWrP9B+TqnbQOAo=;
	b=S+cUioGmgd7eBmkvLL/Rr5c2KGv23EUY/dy7ykWnTyZRZDZz/KFBrpzvI9gjnFmE6ALJXz
	aFwhND45rtn2kRUR3fh/sotSMtFDN+ZggAcXkpLVCIOiY9niv24EUhtGd2d95X8pmPPpII
	05y0ea6hsKC0uhMboKRCiit57ubOBRk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775729386; a=rsa-sha256;
	cv=none;
	b=kb1O8UTWftvJgEWmDnOlGcdjil6/+MMMztieBL3zg4774hvb7Ioa2kxZLyHBjWY2zvHylX
	zwT39oi/XXAT58ZYn/FXyJY9Wb056bP/Elzf+cplRwMif6UBiTuWUG1h5tTkDU+HbJxpaG
	hRb9H9ncNqPq3csYaQUwqiNprW7+X5U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W9oXowWs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 10B51401D7;
	Thu,  9 Apr 2026 10:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7423CC4CEF7;
	Thu,  9 Apr 2026 10:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775729384;
	bh=gDPlLIZMDSKGp8rM/tAzo6PGs3I0TWrP9B+TqnbQOAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W9oXowWsDcNR6qKBv6OzSuu7PUJ8lgPSzNRZ9EvXDexW503z3R+mYmQpn4WjK6bod
	 PSPSdApYULVQnCBbuBf1j/FQ2aMvh56o30+geHtCUKWbWJUa+yHDKmJ8pw4OYkLjdL
	 E4s75JkdufM+HYS4kt0q5CO+CRIx0g0TWwUjSDNiLa1NbiT+qaRbC1TBSzdxlBkY+1
	 Kq3xbdynzYavJjKIIPiM7nL2wEIiNNsSOSw64QeqTlVwviGgXiEbhJlhFiFW+iI4Hr
	 9/cnezW8w+8HZ54NYlI/NUb7uxvrmb5/tEkjX3Ac3l5nd9aEhwyehAziCvUZPafc5v
	 bGn6Gud98keow==
Date: Thu, 9 Apr 2026 11:09:40 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: xu.xin16@zte.com.cn
Cc: david@kernel.org, hughd@google.com, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, 
	michel@lespinasse.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
Message-ID: <add6j33HIaG2BvLZ@lucifer>
References: <addoN3ur7GtiKOFf@lucifer>
 <202604091806051535BJWZ_FTtdIm3Snk24ei_@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202604091806051535BJWZ_FTtdIm3Snk24ei_@zte.com.cn>
X-Rspamd-Queue-Id: 0F1F04000F
X-Stat-Signature: hzj4ume9wir8zrzib5jh4stwnj7wnf5u
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775729385-874163
X-HE-Meta: U2FsdGVkX1/oVeIV7ZVw0J1XMhtfmj0Dv4/k86VY8pV+DAARGs/4+NO4untPjWjhjp+CROf2v9mP84zhc1inmPE1dFHJPSON+z+RyJs3N6lF5zY2Hn3YRIr1oFGNrG7GKZ7d4QNP7IcojClBo7Fj2xhaYU15R1WIV56vBsd4PxlRx7LPqSx5aFa+ABBYp1Gch1ZOg7XRAnI4fELbtp7Cm6jA2KMS8IXIAH5CgvnItAKv9CShkdOPjmiwF9rFBK9R1OOThR4jew56mFgkyNmZebVnUgz0sGKLvxMeLF7Zd9Mq7cbbAfQF1FzyUfJF0qK3+MlGPONyi8IdmacHEmudEF3tCo5jPxC8qO2+62ITloJKEFbK9oAtTg3WJFKSZ2Fg3lVr8gcEOJVfI4Xi/wwzkLgqOdvkphVmlZlZE1I39CKIlI4fNKUM/PTVFNknC/OXMavnrisojKVdwNpG2g6FA2dxmtNluNg8M32ZTIi31PPtgTIhEQA8aaeeCXrE5Y3O0EFKwYVJmHbycw3AKHLP4bBKyUlecwWwgqP3qYYzRy84im+ssdro2F6EmNW4Azc3m943dA5Dpwi4w2AyvhddupcqwLEw898DMCnRdzdktuQ0Kg9whxNvIj4d4gLbRE7kyeLoumzdOYcrfHtFQECpGrPfurwFysM7Ffq45q7TUFtAiec0auxFagorX72gbX7gfEPOmm1n5DYxLsyVuF2L5T3nkoYZMJxCOs+iPug83hk5L3phzrcIgQCLAjpGJ+YTm9rRUzZOSRpB5+wQJ0KBBSpRRxFhZgcz6zbVAbzeKwrl4gDSELOQDYPKwJeyd9hdr9GZACDrp8YroniVvIGhGK6wMo957VhidAZM+v/MWSsjiGn8CBAxLYQsjtBmTSP3BS10ROvG/TWL8Xb4zaqPIl9I4WCbzaNzwPyNCmcyG/zgdRzEX5XLgiRe3IKN20AjIWMmR8fQDHNTxoDQ3Dd
 WwS/4BtB
 ReqdLKChF61gnoVIZF2ZEL82I4GfBRfC0xIAuO/y1gPvulMK8X7qbIx4JD98rYyG9cXm7nae6Bv3xuymyaPJ+zSuIkQeP3rZ+ajGvPAuD9y126AL7D9RR6D6LL3W8h89rWe6k8FLh8GSDEFiAnV8QPA1w37i1aJjsQ26uic7lFAIjFLqg3SNNPOp9GhlZ4vt0VHM91xrgQrDkyaMh7m5bN0a2zeU0Jo378d2ctO9S7jYOph1qzRObJKrxUNg5UYrxCHNo8rwO3vK3BAVI2rpjyK5IbOYrpX55FBcjtCqgt4G/jXbea2XPKZQezYqsN//v9geQvhMHQ/QGZ/CgByjbF3YBIdkxqNVhONw2WgHEwbZpvEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 06:06:05PM +0800, xu.xin16@zte.com.cn wrote:
> Can we just replace the stored anon_vma of "ksm_rmap_item" with the orig_vma
> when KSM merging? Then, from rmap_item->orig_vma, we can directly obtain both
> the anon_vma and the vm_pgoff, thereby enabling the location of all PTEs mapping
> this page without any ambiguity.

Please no :) that's a UAF waiting to happen, VMAs are highly dynamic objects
that can change at any given time if appropriate locks aren't held, nor are they
refcounted.

David suggested a way of storing the vm_pgoff without increasing rmap item
struct size, hopefully that's viable and then we can get the benefits here
without breaking anything!

Cheers, Lorenzo

