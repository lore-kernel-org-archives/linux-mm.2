Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20673E9D814
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 01:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401C66B0088; Sun,  5 Apr 2026 21:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3166B0089; Sun,  5 Apr 2026 21:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C8DF6B008A; Sun,  5 Apr 2026 21:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9666B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 21:57:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B703E041B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 01:57:27 +0000 (UTC)
X-FDA: 84626468934.18.749B439
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id F3E8A140006
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 01:57:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TGqJbu8J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775440646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQPcHeRYPxGNonVpdLzAgw5skiFBr6/vrOGtJ0U0oKE=;
	b=jwjp001I9wLMuOlVhD+0sIyKQIj1z7LqqkvhMbwWzZ9A2RUK0z/9NTtllrF2dzou1i0VdC
	RWJ+Hj5Oy2O9ILY+mUM7qKvnXQiOY2iJGtxyx3O2+yOKI70vHK0S1mduA0Ewvh964RQp12
	r8Zd+7UUq2IlhyuNjTXbDk2zYio+L9s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775440646; a=rsa-sha256;
	cv=none;
	b=nN5ufaf5slQayEfoWgv+ctO12LnTy/j8YKM9y3R1gJ2of8tXjkX8dHsiNpaXDt8P+MjPFL
	fBBze22jc0Z1yTtvawhilzbvfG1LEITytUZ4BSkkDmTG/J3Ode4QT1gzxkITLvIkkSgnt9
	Z3l3I8AScTv5ILcyk67aA2qjAwopXAo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TGqJbu8J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 57A95600AC;
	Mon,  6 Apr 2026 01:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77631C116C6;
	Mon,  6 Apr 2026 01:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775440644;
	bh=nN6LiSaJDmaX3AIKdlv3OdZUJN6OsquxMb79cgLmeAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TGqJbu8JaC83GOpFcRjTbZBckqldmJUEeDBTvTjZMrJwxZ5ShUt7YTqs1tMSbx57a
	 L5RikvhG0u+Kt0lWYH8bq92WFwEXvmZOEfGCf8VeEY6CKy/+33d3AqUV4112PaN6Zo
	 zQXk5XgNWLVKlYHik86SCasM9J53RcfXUxee2LIJ3bmWnSzA0bWCruicJTIQQRAJsM
	 jlAA86i6mbIKsm+C4csw08zDqeRcO0bLpqJRYtjhhhYdAaa/f6cVLnZfGc9HbQtJ2A
	 Ug8sq5cUX4dd8FFqILYTbUesmQbI0KMzLr+qpZMpuzIcN8VVj+rD668YEwS/LtmkAO
	 UR2Ry4GwIvZDQ==
Date: Mon, 6 Apr 2026 10:57:23 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, akpm@linux-foundation.org, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: use N_NORMAL_MEMORY in can_free_to_pcs to handle
 remote frees
Message-ID: <adMTAxEuUVlc-dhv@hyeyoo>
References: <20260403073958.8722-1-hao.li@linux.dev>
 <ac-qJ7tYQ-ybegOw@hyeyoo>
 <6c90c152-3341-4a46-bffa-3cfaca66fdd1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c90c152-3341-4a46-bffa-3cfaca66fdd1@kernel.org>
X-Rspamd-Queue-Id: F3E8A140006
X-Stat-Signature: sa8c5hjqrryqidno87kz9iodcx7u89yf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775440645-694743
X-HE-Meta: U2FsdGVkX18z/j4fVAObRA0swuHwLCDmpSV4p7nN/IwLImIng/VEeN/oeYP3ANITZgZ8srjsWs9k/yD5OF6TfImmoRcvOfquYdnMu7vmOLvGyyCTTVIYxiMewNst1Kno65QboC9cgV36iFsfIcdmAH5cw+Pk2y0zZstOVP+Qpl43sOayGcH4u/qn3MsZBl8i9/ptutETSML+ocvt1uAQIKQcCHRsW1YZGfPDju0COS9Kt8EmqNvRDNf/5Mb49V5VxDCNEJkr/tDBHhX9qeAMoPGQlC5IiEeai9A+qH7ogLLJQn8x2zTlNdUdWy/Cw7ttJGxPe/WygYIVFvQNDmX5ulXcG3mlOLpHqAI+vS4WvqwV3sWtVRbGXTsGpMVJsHXLa3od9rE44Jop/5G5oPjR06bVqZ4ztR/qH0wPTpmgxzKMNgT1/9pqzqyRZxCzfOQRUz48gk6THNELnvn6d1SKpyMN6NIgMxfGxaOMorTl75LlU1cxDa27TkNxtzXXkeQTXIL9MNNygc+R37twFcTk2Gju5j45QwwNliTObqhJCxi/k/qb3Ks3JTMWh/aD46/IWEKns1ek/e6uF7eHN8x6d04k6YsK54OCxwIgdNgSeJAUy4/2ELchx3roXegimLPEFrCejqKBvtzJXEYyZG5n0ei3I5C6O3Y8t45g3MoYUE4EvM6lDuKDT+xhZu6O+RmxvcQs31wesCoVE8figuHw7o4DoyxGHsb0xVeN4XBEFuPtf149oidfMBIFjgl2p4yVN/AB01FWHYzlohpfkN88GNcRvgvV7SbpbDvS/joEyZtfN93JBR1XXDEnWOJin+DK0WPYofsTILPVO3k/9TAX5lITHwsbG6YK98Bk0FKcq0KNhfetyLqCd9IF2JN30/JuibOtrSmyVIrRE0l7oxKPV5HID3FrVeWoR7BaPPOqByuDPAWMZIqLsZU/cakdEVTlBk+TiVCpOGs+RT8qMnV
 Z8finD9K
 qIXS+IfEXbIsEMu3fNfmPoLf4NyqOQfG33w/oYWNIjHF5NM9kp54CfZxYp5ZSg0IWoU9J1VVzh9o33QeiJpYbuSJCDx7A1TCdMlhpbmOOde6K+elC6RUaVKpKimjJIJZwP7VEAQK3timsZGR4X3pRyubSfc6HO0bo2ZxhzlafCqgkeMmeKjP4STo6sgLkMMwTyHxIowwdItLoPi5rLAnI6qKnk5XzN4kYLkZDSoT5gByvRhpjO4uj1oFqSiAM6hKeT243WyN8E6uzfshYxUFvoYKhJ+Tm12TGxOqufeAd7D/jAVnCFAiyKDFTSnjQcWBzYdGd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 08:14:11PM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/3/26 14:02, Harry Yoo (Oracle) wrote:
> > On Fri, Apr 03, 2026 at 03:37:36PM +0800, Hao Li wrote:
> >> Memory hotplug now keeps N_NORMAL_MEMORY up to date correctly, so make
> >> can_free_to_pcs() use it.
> >> 
> >> As a result, when freeing objects on memoryless nodes, or on nodes that
> >> have memory but only in ZONE_MOVABLE, the objects can be freed to the
> >> sheaf instead of going through the slow path.
> >> 
> >> Signed-off-by: Hao Li <hao.li@linux.dev>
> >> ---
> > 
> > Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
> > 
> >> Hi Vlastimil, this patch depends on a prerequisite patch[1] from a few days
> >> ago. I'm not sure how this should be handled.
> > 
> >> I wonder if Andrew might put them in the same tree.
> 
> > But it also depends on the patch series
> > "[PATCH 0/3] slab: support memoryless nodes with sheaves".
> > 
> > So perhaps better send it to Linus after 7.1-rc1?
> 
> [1] is in mm-hotfixes so it should get to mainline before 7.0 final,

Right.

> so then it's fine to add this to slab updates PR for 7.1-rc1

Sounds great!

> >> [1] https://lore.kernel.org/linux-mm/20260330035941.518186-1-hao.li@linux.dev/
> > 

-- 
Cheers,
Harry / Hyeonggon

