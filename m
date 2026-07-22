Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD35CC4452B
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 01:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8735C6B00B0; Tue, 21 Jul 2026 21:02:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823206B00B1; Tue, 21 Jul 2026 21:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7149C6B00B2; Tue, 21 Jul 2026 21:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3902B6B00B0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 21:02:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D8C580335
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 01:02:35 +0000 (UTC)
X-FDA: 85014612270.10.B642B34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B9B4940004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 01:02:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZMo9tAZL;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784682153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0i56NBqaotRJ5p3UAKMDmToLmD0VzAqE4hcOPd7uRRw=;
	b=3A/GyM2P4pFu5vEqyuKJII+R0vgSXdOxlVMCg1/hPibe8qeIRGHsQFaSxipMcGGXaELZGW
	eAxczKcamKUh01xHXKJeKlIOI/R8EiHeJwD5UH8Xgj1litrHb+craUVJ7ibhcqeS6m84Qi
	/cQ24prvt9/TkuDZ36KC4fab9lZni8U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZMo9tAZL;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784682153;
	b=vx4yQPLWITfmnVe0K7KVUspg2YPjiYXRQzifBzrnTx4zL9hasP6+Mel1/38N3v/4DICZIn
	bLXo9WOjRM2scq/jqzMvCP+eT+GjK3tvUcKg/NXgnstGBxZ0xfIKf6RRF9fowTk9zeGWsw
	35ykV6ARTP04dLaKerVbbuwz3uPQo/A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CCEBF417DE;
	Wed, 22 Jul 2026 01:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638D61F00A3A;
	Wed, 22 Jul 2026 01:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784682152;
	bh=0i56NBqaotRJ5p3UAKMDmToLmD0VzAqE4hcOPd7uRRw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZMo9tAZLQuNTT3TmXwvXaJIUZG1GspTtUXwa2bIwBcihJ4fytqb6DXR0xoIDucDDC
	 kHI/Rrs71iVP3hlYjd37QUuJXQY650p7TUVngciXpOl81fXuoY/y72B/C1WuCv7dmc
	 W2cGNfKmwEOfG6ny5BfNlShihsd86R7ys1pXtbbc=
Date: Tue, 21 Jul 2026 18:02:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/memory: use folio lock/ref helpers in do_swap_page
Message-Id: <20260721180232.0984ad6fd55ad43053b3a079@linux-foundation.org>
In-Reply-To: <20260721013347.65698-1-hongfu.li@linux.dev>
References: <20260721013347.65698-1-hongfu.li@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B9B4940004
X-Rspam-User: 
X-Stat-Signature: dzh5ept4sgeuonzrowiu8rwsb3gquqjp
X-HE-Tag: 1784682153-476234
X-HE-Meta: U2FsdGVkX19YK2PcE2N75l2d4EDaKEiJ2z2DRhJr8hI5fA4NeZ2YTxRxgukDvrZB1yH9iSlJ0v7Acm1lFvjVorKFpD3cIxDzDmWiiTMaZSFoqiwpzkvtj1dXZj+zIZAd4Os6NUofc2D3cIMRtQf7Mq8gZuXf7zn6u/8irIZYchKsogMbYukZHcBaKyUXVCHCVEqY26vSGfbmGCb61UixqbtjFHOWLiU9qnx+QgcNWcHOwhw7nb/0UtJq0hCUMAFlZ5cOnWj0o+kYzy13N/dXeX0XQk8oiV7IfwHH4GwL6MGic9F5JMEbZBF2jlpL5kILW0lT5avWoCseeHHmjE4GgEL/RKPCB6krNC3G/7GcmSOQ+NVdZ5tcEyx/nytGuXqst0LnVRba4Tf+4TbLm8Z2zaaw0Xf8J/7ztDmK5tTuTTpGvl7pMXRzL9z4NV1Ptv4aik9m/Ioq4hOi0kVdKptlGZTtDuIICVg2Y2sQsctrnHeD0BVZrWoULLhqQmGvOY1D3hdLjV4nZUqsuhc2Sz10mrdjLfEh9nqvd3kHauhIK3ZpIx5k3wgSdoSgqh+muVh5wG46NQNzimAAD8RlWJ7GdGJXrLCcZwetJGJVCj9+hCcDcYRXlPjeKmfm2r3KJeAjo2V0GE5jUic03OWQBGssDBxlwtHmQQ87No2LkoVtQ1SVCvckKC4yxFM4t9sRtKIuD3OdNMJWjO4Y67169M3AwXsHBFrSfS0aW6Ghq9U4q4k1GGv+7irAxx146D3GvVZoBC5IZbVx5t4LveCOmPlejxGalpQitWXKWwQBzh/9VvFb5kwiHElXaWd2B6c2q0/NoR9O0s8mUpHa5OlNW2kWGRmfO4ATfxOxNb2RktxxPgOR6z04eiKwPFYXipmKc/7tiUCO4aXtLCkJx+AoAAJzambU56kJC2ZS82c0zUymgnLzDEALNHECWCH/7a0jwSiBZpRDwy/ZeeU0eCZA1Rh
 vqkOgxAS
 AMvvWnzeCsxRbSjkj5mOrUuioahozoDjluoVqilXpZ37s4cbSOUEZOpsTRAlvo5776DlGqQCDZt6h1FL5wIxENpjTaKSX7/GkgTW6QtP1UUZB41nn3/VD6y/XfgXNawhy1fo4g6QPXnm7u5Kc3/osY/L5UEEwX9t4o2KPFYVLl6MYYBjgVH9iqfjlf5dCUJIkC7SW3WNnA5hYqvrcOIv6OGzceZFiFjpI1BKGOaXbqncRSRt+dy2WxI0n7Ca52tSUPleki2rytxkHutgsb1SRzR+XbWUDNWTUDjNE0jlVL3NmviBCONm2gv9UMtvJRCtkoG0pBnYcL+J6FHcFMaOmw88SHHm7vo3bwNkO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 09:33:47 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> Replace page-level lock/ref operations with their folio equivalents
> in the device_private migration path of do_swap_page().
> 
> Introduce a local fault_folio to hold page_folio(vmf->page) to avoid
> repeated page_folio() invocations.
> 
> ...
>
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4852,6 +4852,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  			vmf->page = softleaf_to_page(entry);
>  			ret = remove_device_exclusive_entry(vmf);
>  		} else if (softleaf_is_device_private(entry)) {
> +			struct folio *fault_folio;
> +
>  			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
>  				/*
>  				 * migrate_to_ram is not yet ready to operate
> @@ -4863,6 +4865,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  			}
>  
>  			vmf->page = softleaf_to_page(entry);
> +			fault_folio = page_folio(vmf->page);
>  			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
>  					vmf->address, &vmf->ptl);

AI review thinks we shouldn't be reading vmf->page until after taking
the page table lock:

	https://sashiko.dev/#/patchset/20260721013347.65698-1-hongfu.li@linux.dev



