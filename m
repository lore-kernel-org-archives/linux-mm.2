Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DCD7CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4B3B6B008C; Wed, 13 May 2026 05:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FBED6B0092; Wed, 13 May 2026 05:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9101A6B0093; Wed, 13 May 2026 05:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 836366B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:24:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2AF571C0669
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:24:13 +0000 (UTC)
X-FDA: 84761860386.21.EC38665
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7A7DF40003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:24:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rVBVNUig;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778664251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dWDkc1obV0E1secbcuUEcptAkDCxAq2JxNfBYYIFECw=;
	b=oUQIVgbQ9CDY14hITAtSf03I1Nbt/Q+FrvWLgxSxKIWLUR/OxdCp4ezhsW79W+ee4KW6lh
	QnDPgnsQ6kF13dtBZSCFQ3LEK516qfEnwXzu7xKWSihiz+YLu+GYcMK6QueAkIM12FSDAQ
	rzmKODu7QSiU+3DsY7h6EkJfPeYii50=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rVBVNUig;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778664251; a=rsa-sha256;
	cv=none;
	b=lBlHyvx7imrrlE5tMxgLQ7oql1N5XgovcT3rCV8zRfogAuyX0Fa0prUJ3v9mdDxXZ/y3zT
	9raKIkEAwxRbrnYSFaBfwj6lwlGAk1Jorgv7XTM/ZGcVVEkXj/aFlH0w+5gK0oqOhKfxJo
	ybaFgUSsatGMmpZiNXQsT4OBxSmPWSQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CF2243F98;
	Wed, 13 May 2026 09:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F72EC2BCB7;
	Wed, 13 May 2026 09:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778664250;
	bh=U4cfKROV64PvlEYkhn23spLaVTZ7LHG2wwR6srRFir8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rVBVNUigUVvlNY555mAOpCIiZjUGylqsFAp5Q5aD6+5HkauJsfJ9pzXhmAu0BC3mw
	 o2bqU0D3x4NHWoPMVLd/QGgcZw3Ag/8REFdIbCixopegFo3Nkfvn8M+NxIsKK9E/Gm
	 hAeyo3LnkJ7/9vIJZDfEttrK/VrE2OVHq1ZmARv/yYRptsbUc34O73uNPvSKA9bGq/
	 yhy5WFOMW1+QUEkpHOP1ZtG5vK1veprQdFKqYdOz/0EjnjYyg2fMyWo3Ssm8ExniuW
	 3F0GTrD+0tAKZuP28fKGInIFcu5OjyiKEO4Ty9dwWr6GILe1jPama5O/i7mP5CpYUQ
	 MBIaRfZvKIGZA==
Date: Wed, 13 May 2026 10:24:04 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v3] mm/khugepaged: avoid underflow in madvise_collapse
 for sub-PMD MADV_COLLAPSE
Message-ID: <agRBJLpeDZnUh_V-@lucifer>
References: <20260513055428.1664898-1-chenwandun@lixiang.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513055428.1664898-1-chenwandun@lixiang.com>
X-Stat-Signature: c6ijc413z91djiu78th3q7wxqt67k45c
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7A7DF40003
X-Rspam-User: 
X-HE-Tag: 1778664251-630448
X-HE-Meta: U2FsdGVkX19pDCIsB7QWLJ4XMNHVhl/PHbFtDPgb4v4P6sb8Dmo3vkVaMLoQp8F22vfwBFIzQInr16waRdNDY6SlgaCPWnrdboxNpMpGj319BY+n0ku6NEIR8rMJePZyNGFgEeblJ2CmitmNPdfwFXI/DOtQErqp1NnAfnamFDaoZxRgIcWtobvrkBhhkDYdP4BjNG1RfXxJixJXW11wkpcfy9TPBSiobHt9Akw/gZcsBgVafgrYxXSpVnVs+r0EZhELwB69T/9Vdy5652v40KTzQOFK2LdXBUwTRnQxfJUiDNJOR6O6QFZe4dYXI7ZRUA32iosr8TjlU2JM4A/5BRz/oFQbSCX4L7O6Ua68x9yCQ1YRJEGZLhFSSjxkqqvpvKNjDNqGtmKS9COd239QT3xFJN+X3AlEqT9Jn5emn0zFh52KAcJhWQ1JaDkiojkerIDg4wrHuqy0627Pk/L9xVkaSRhfuZyvwLEk3xb4JtWhHSKS8fe37dC/HUCjYThC50BzzXFAboTLhqxyO0iygxqKCinBogyJ7vX/IILtUuy0Y4BJHB2hK24IFLbKPH4026CzjIeAEcy17aGBDuVgZlW6juP8ZZstoFN0OMj+SXisiF9WU/6hboMVDLZnzbeBPaVWWmn0HLKPzqHbACsG65hNRR9HMWMZMjkYGKfS5gfdkFRoOhdW5r28G6gb0TYFWkRDxZHtk3EIIpc1bv4VSO4HE/fTYchzkqr8Vp2vRaLp1zCrUIi3XHPJojuCRd72QOJphDBmglUsIJlqi0qqgjJBftAxJmT3hWA3ohOlRqKLSZWhhi8UjPQ5Rr2EOssKB7Briy4oheTM+6F63ef+tjVGYJMwmeMCRu0lSLrKYVapXPyPnSD2B54I1VULlXSxv1oFvlJQM60Ye76Go8XJWrxh4dqHF9hXB09ZpLCAlGhFuD4CnQkylXBqeAOambWmWASabErDhGuVFTCQ9XP
 kv+kyRqu
 PaQb3qxgS6VTqeJMDTzT8HJI9Lj981iBzquR6z7WYJupTuHyf9SEu+ykMwOgdk7jcbvXdvkRgnwPZOprdqhJfNqH4EkY6xi9PRfG4QV9Hi740LOqZOJQW9xeGuD+0nqPi5vNsG7hFkYXLAdbYXLgh19gvHG083oitn+EGEdUsf046o7IQKDjZ2QOzC6Dw0xV5+NWB49/plzV21VZIKayLMSZxgo/RQlRpE6O8DWwi/WKdw6CPsnqkMDM9zCOQVnxZS3Np794KD2HnECw0StYJ+Hh8+E5Ev/WlegxDwc79Vz9+6vIJhMzWh/Zz8rWzlLWoGDbGxa4BVC9FuOIU17ztJWLWcuBvyk/rsMdwSgO6ODSa9j5S4Dm0PbZzUobxRd9dAKK6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 01:54:28PM +0800, Wandun Chen wrote:
> From: Chen Wandun <chenwandun@lixiang.com>
>
> madvise_collapse() computes the THP-aligned window:
>
>     hstart = ALIGN(start, HPAGE_PMD_SIZE); 	/* round up */
>     hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);	/* round down */
>
> The following case will cause hstart > hend, and result in underflow
> in the return statement, avoid it by returning zero early when
> hstart > hend. The return value is due to input is valid to madvise(),
> and there is nothing to collapse.
>
>     madvise(PMD-aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);
>
> In addition, kmalloc_obj(), mmgrab() and lru_add_drain_all() are
> unnecessary when hstart == hend, so skip these operations by
> returning early too.
>
> Signed-off-by: Chen Wandun <chenwandun@lixiang.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Cheers, Lorenzo

> ---
> v2 --> v3:
> - Return 0 when hstart > hend, suggested by David and Lorenzo.
>
> v1 --> v2:
> - Rebase and resolve code conflict.
> - Return -EINVAL when hstart > hend, suggested by Lorenzo.
> - Drop Fixes tag, suggested by David and Lorenzo.
> - Updated commit message to be more explicit, suggested by Lorenzo.
> ---
>  mm/khugepaged.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 28a843f30b32..fd7e893c998d 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2837,6 +2837,12 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
>  		return -EINVAL;
>
> +	hstart = ALIGN(start, HPAGE_PMD_SIZE);
> +	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
> +
> +	if (hstart >= hend)
> +		return 0;
> +
>  	cc = kmalloc_obj(*cc);
>  	if (!cc)
>  		return -ENOMEM;
> @@ -2846,9 +2852,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	mmgrab(mm);
>  	lru_add_drain_all();
>
> -	hstart = ALIGN(start, HPAGE_PMD_SIZE);
> -	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
> -
>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>  		enum scan_result result = SCAN_FAIL;
>
> --
> 2.43.0
>

