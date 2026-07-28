Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F26F2C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8E5F6B008A; Tue, 28 Jul 2026 09:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66A66B0095; Tue, 28 Jul 2026 09:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA36E6B009D; Tue, 28 Jul 2026 09:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB3586B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:24:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CC9D1603C1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:24:41 +0000 (UTC)
X-FDA: 85038255162.22.8AEF273
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B50A7120007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:24:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eKYfLsxN;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785245079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJ6nTW8uRRvGa9uxb9XpHnqlyfY+CSFnQPSaLsTQkoQ=;
	b=E0bXaYVjAd6WhtvwBQyFcuuN4Y2tjbOLwZN1G9k2+49HRj6OKpbIneVLVUm5mH5xwH1E2p
	LFFfCcqaxS5bgxr3nAEyTfcidKyrfqCDW5cxd/2zVdjaKqyi1191CSew4KKG5B5DqQOdEu
	mjoUqzkDh8ewcLivzvryIdt/uSAYngM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785245079;
	b=iOWcb9HkxI6gfv4UoNNL7djV/HxVHZMh3hVCRIV1JXn2Zm5MJYI/gJ54kUf1Xqu5vDuHpY
	s2AfnctCOgla9rwRnKglNESaLLvs/cbigXUQ9xyMhSNAwNHLwJjCJgy7CqqnPeoxlqlJMZ
	DmA2feFNgr8eFQxeQvHt2oHJ9QBIbBY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eKYfLsxN;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CCC39407B9;
	Tue, 28 Jul 2026 13:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280441F000E9;
	Tue, 28 Jul 2026 13:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785245078;
	bh=YJ6nTW8uRRvGa9uxb9XpHnqlyfY+CSFnQPSaLsTQkoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eKYfLsxNclt8oE+pNYIIZIi8pjlDWK/9foqXxg9TrlmLgmTasTk/l1juxhuMe4KFh
	 r74dVpcD0ekm6fTkX3vxpxRUSUAh3K4RXTf1L+tVK8JR0GN96XAkFaDQT25rMuh6ou
	 5sAN0XzViUQf7i6nUy6qGwGS/gAsIqvGKW/mHAmodvzWi//0Z49sIhWrnaWyMkEmPK
	 9BSwHL2jvVc+hlgpOKqq8X3dakUvPvwbBBuxc6WbwdDJbPZfhQ0g+wBrQ+Gv9zsaAZ
	 mYUkDGGsOyQYJ75sD0hP3TIDNNC3DcXG2Sla0JK2MGO6huo8htG009HntZtEXW5KHi
	 oJAC4nIm5QtLg==
Date: Tue, 28 Jul 2026 22:24:35 +0900
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 05/13] mm/slab: abstract slabobj_ext.objcg access
Message-ID: <amitGGcHyVXBdpOI@thinkpad>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-5-c29ef0f1f257@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-5-c29ef0f1f257@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B50A7120007
X-Stat-Signature: agmdua5bmu6kuw5xnihxwz4qszpc95h3
X-HE-Tag: 1785245079-392153
X-HE-Meta: U2FsdGVkX18pXb/GrruRA7hr1oe304NqJvKkBcyQr6LgWtKPZv0Qazm7FfCouz88tz6cLIg4vdiJ0cc2exkb4a6+xpkHKjhnNeOv4cmXs84kf6EV44Pf1AUgJ2LYuXnGAyCNyo4PnzxUIS/Vm3zXJDZBQMEkc2dmswiZdf/rXk9zUD09cba1R86BbLY6RQwYDXuEKMzLx6DZR1i1PsMZG31JoUGx4KbW4l/2/0vFz0Zyes9wf8bGQbTb78iEZAjiYw8e3IVRuu6SkvYTFUOZyAmITRgFn2W1EWk3KNvTQBT4jSB6MP6fCK/0cGE98166sy4jfrjSPHmaz7bml/8bhounu2eLnpU82viHQCC1cI5xQDcnVVPtjdcXe18IBHxbH5zyZIcLKWYskz+F4hl5TFkJ3fhRAPOArYuY5848ltUkb1dtGwJ+uxo/mS1IvDxM1mkvwu0YERSLzsnYZi2QxtHzTsX94TIs8uxtxXh5XyUXOFl91C5+fzQUf1gaaTfkbJpQ/Xvb98oYjRTcVpi8Eu2MV2igVdq5HfDaYhmw2vaQe1rZfUcvDkedc9KsMbGeAiNIZuvJQ88Lgeom12PhLoGO8hFN1mXV++5rchJ0jQGxmZH0JdggVSdbe3J4jmpCWCO7vMbCbMakNxfcs+4dOiC8/3o9jfAvvYUZiKTklgZOjoqqlpY8U2HSmU2L1/ysr6ljYPI0oJtt29iuBQ3BF6i5twL+ecQk95/YkWmKZPf5pxyRr/212CX0AtdJksbBApWCodNUVmCKj2uiA/xU/LjUjfOiYAmcZbFnCmwhjbzOU30Js6rGLFAHLtZ/9pWDnhFDKa3XlLJaQqnQOhc0iX74T0pxhfO2guvv1I9U14DbRa4sldiUxkT2GqdPOjp4lT41oqkeEQhhm6xIr8MyySs/2jNVvs5UJ4hjDnuphjVLq3vd8KqDs2jbtLktjYS4jozlFxGRQQ4VzQz3E10
 GJMcdi5k
 yzkeYcgUd0YMOsd/dS7qTz8IOtn/BjYf4njp7UvG5a13Js2CxmRMLmKfp+wUkc2d7TdOItsL0emP9iaCwtFKdtwOBg3+ndlEQc4UWfQdRjwiTIAjurFpEmO/6ZaENtUzZa898f3ukPc0Mr659214NuYe0TkWnZ9guAQTYFkd50fPm9BrPDZfrYxvPWTy8D4FZaeCfLEfiqKzJucr5023QwNaHadfzwVSw+DWiC22aRlOpoinlRdF5KIWo+tSFCasrXUWtRyJPAVLlah08uaVecn3KoSfMe/AyXP0RztNT/DT4klfJT2SOTH5jgRIcOqbbcobKcD9XgiG1ca3ZpSGuV263o3NbgBuRJrriQuBhTXcV0/1UhhfmsT/ErA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 02:53:59PM +0200, Vlastimil Babka (SUSE) wrote:
> In preparation for changes to the structure, abstract getting and
> setting the objcg field with slab_obj_ext_objcg() and
> slab_obj_ext_set_objcg().
> Rename the field to _objcg to make an unexpected direct access a compile
> error.
> 
> No functional change intended.
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

