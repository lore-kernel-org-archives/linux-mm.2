Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE165CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 14:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35898E0006; Wed, 22 Oct 2025 10:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0CCE8E0002; Wed, 22 Oct 2025 10:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49D38E0006; Wed, 22 Oct 2025 10:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5A6F8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:39:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B681488D1
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:39:11 +0000 (UTC)
X-FDA: 84026007702.19.70E334D
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8909E4000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:39:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eW3saa1K;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761143949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iUx6gdNdTYzzjqltaNY50WEDVxdUw+Z6zLWtzDzW/es=;
	b=LNnjAu5RIl2Gqd46qg4QXnT/V9e82gbjVyUEKUbfOEHeOlqYv8YATAxR0szCYRI2sNffEo
	YalGOJKKYSHExrPExjC8jy+q7uXETN11YWofWRP1LuO2MCGR7KhLiVer3J5q4Ju8obCzpO
	MM3jDF3Bmu5Wxe/mXBvs468ydS/2JNs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eW3saa1K;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761143949; a=rsa-sha256;
	cv=none;
	b=Olw0kjwVLXN0wKMIcO5Chok/ghhNpg8PyZGHAMxbgni6IRtPLlaiJ6BaNQ+GSTIc67KZbS
	/ncc2YVRnMu2jCs8cR+UmNZxkZpbhBN/tr6/n1aqgFZGWog6SKUYu7kRQwORXzLlPfkKhk
	ISdiX4eZ0ZMTSj4OnKUqNFGdMLY6FCU=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-63e3804362cso3491183d50.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761143948; x=1761748748; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUx6gdNdTYzzjqltaNY50WEDVxdUw+Z6zLWtzDzW/es=;
        b=eW3saa1Kz+HD/ontC/dX8HKcqZeYI7DTLQIgsrNhb22LVHSCpYyNXD2sJuxFfOp1Ah
         QR1Lc+N62Yhe3D74A4uACe0mWbomk0JCjnlFy8XhrHjlZ2ccS9f367vg3ejX7kNuCacb
         X+QSS0NXGhFytbSnNyxnCleyGXwoStjWD1ODKY6r0+5ZY1LxhXEZfcf/SjYdA7O0t9aI
         Rer/6ZNRpu88D0JpiUs9whuGgarG6J4tvPH7CCb4M24lwLJ5IkSeT/Zj2jI9wCpKxDE7
         Dm1eNU9uxSdNq3P7QfYpjE7ZOXvBOfv58iJwXdtLALW7YAXUtcYYFnqHauAjMcnYFTeq
         5ZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761143948; x=1761748748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iUx6gdNdTYzzjqltaNY50WEDVxdUw+Z6zLWtzDzW/es=;
        b=njZ6wRM5Kfw6VkRLuImwq0MhOPsccv5HFDU7o03vXe7d9kV/npJkFEUKX9sRJha4XR
         p1mbINdf6d7zLtifiWmh+UQeF1DxquEjhiu/Jp7kzTaNIBSJ8G2eUxDt09AhfvKzi+SH
         vjNpyS/Gu6hhpJ0W9D3kDiJ86DIMpWUhnLzdZgshkjQW14XtwD/UVDIOO0WBjEsU8WUZ
         m5csmmbfqKJ4RhLXi5GsZJwx6S9NrXB4NbR+eskqXOKOEy6gGbvrmfp2moESO2aSsJJX
         ya1f05uVWMjgdCK1r1EIEeFTx2KL53lC9oUAhbw+bNjfPEakXWGUnxnTCOEgvQfRwLIh
         Yd3g==
X-Gm-Message-State: AOJu0Yxfrj0/1T80D6KzAbO7f9K90mxIqTcQoJ2U+iX3HFxPlAU06PId
	3eVuyTyreuXs6+k5folhuQESY8v4Y6bwrtkA4VSaCd1zPWGp5snK4nc9
X-Gm-Gg: ASbGncvTPqZhW15T5ug7cniR29Png+EWQz82rep+t577rQQuB1OlW4fTzzm5e4tMyCD
	LBWHNlHCGAYhJ/fjziuw003ZXaraWd/walE46bSmE0YcK/P3lVRdL5jsZ31Uw+0W69J5dSk4oTL
	QsmvPnD88WPTYynEEXDFXnT21w8wsbNVGRtqCdYgP4P/reLu6+Y4evJxx7RRABN1wcP6cd+A/0D
	K+iunOlefx5NFxtzwJXXHJeJboAJREb5UpvIENgP9s5o9wH4pGC0LT1SFz0RJPuUHY+PuP3HAGd
	oMhwscHtRC2zPXtGxvaad17sMC5LsIm8X5dok1kRnZRM49T8iL8zi9sGidnKKIV2+3pCw3yUYmb
	I64Agag3Fi+YWWN2lIozsPonIMLQInS4V5xa1OXdNs3QgH3vHExok5dK7mXp+35px+ShbXbDBQF
	4rHV1dZjjLbiw2mkzIwUsKHrCY7WYc9nKeK/IVdgSIDZ3Lhgg4YiMB5g==
X-Google-Smtp-Source: AGHT+IGbdjGLYpbL0qlMetPGFIIVPkWMLPYZ5C7pSeuTMnOttPQxgvRO/yT23wLL3ahh/7calwEKmg==
X-Received: by 2002:a05:690c:2c01:b0:784:94d5:847b with SMTP id 00721157ae682-78494d58aa3mr158818427b3.20.1761143948445;
        Wed, 22 Oct 2025 07:39:08 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:4e::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63e2680dcb5sm4073067d50.25.2025.10.22.07.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 07:39:08 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shameer Kolothum <skolothumtho@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	vivek.kasireddy@intel.com,
	jgg@nvidia.com,
	nicolinc@nvidia.com,
	nathanc@nvidia.com,
	mochs@nvidia.com
Subject: Re: [PATCH] mm/hugetlb: Fix incorrect error return from hugetlb_reserve_pages()
Date: Wed, 22 Oct 2025 07:39:05 -0700
Message-ID: <20251022143906.2780172-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251022102956.245736-1-skolothumtho@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8909E4000D
X-Rspamd-Server: rspam03
X-Stat-Signature: 3t9jqpe13q3mr6hbyh9ozxngcq6rtbwb
X-HE-Tag: 1761143949-421608
X-HE-Meta: U2FsdGVkX18ngcmMOThb2C5JFdnD9Dn/Js7BW1k7vo13hmH+9KrwUt1O2o0lmkKeac/FmMaUpvl8mQjxPAztuDi++2XIjDSY3rtvJuzbljCzhzZ8j1w2lnlzyVKNsWoXxkmPDvEY4T2qY0QM0oU/jCODz2TFQ+RksAQc5uLht0uNc/c99bqscq1S/Lkx1xMZoDCwFryy38vZ4HQ3szpSK41cKVROB2b3B2PdEhPO/09o1xHWx/VF7np/SMwR/p41hz+NWWHDGSihixZpprKOs5UA+Tj4TXBNqyOEqNgPvC9fjR6brGJIA1xO6Uxb7axH1g38eT52casE+/wTMaEyTVnhrMqzjdrew3LS23/AXT+HVNwms5wTNBrVWgyzz3PTDhJ3jLr5nWXvI8IXxuKls8uCX5q8+RiHjSFyBk9DFIt1pklrnJHT9UyUhxK9Z2IHNVXuGKrLMRdNzCXiiYaMZwOQw1ba3wAB1f1TaH53Ctwwvmrr3uU2aMr8V++wk8/r5utglY5pt3ydXyi2EBaXfQR78elRMpCT1VkZgnWVg/BMvRmMgybxoPFUb3YMRGvl+5fKS0SYCqExOiYQGOGtEYXKYVd2UWRtHuXzabjyLi0RUMFomrhBUDNFnt424/m82M5RNvpYjh8l0N0GQdMxiBgTEMuTwGi3vm/bVxXyN9m2/dozkuH9ARf6POBShAYfiO06ZJhZTMfQFnzpx7bFSpOuPMJhpqooBZFF5nZm1Vv0Ti3iG6ni5LMXP9mlG7pRWR39p2p2GFYuRt0AXk8WiWIAd0Mz694y0J2gMsl4M++CWnUxhNh4kjCwBFgC+giw8gEkWAS7eRbcDkzLA4j3y1fi3tpzSVMJR0rLD1pjcLqJxpPPaAkgJHiYIxaRIEn4QGDRL+oZT+mMMomzwRX9Xg5v0b2WCKFRnatUVJ04CZxCrkqecSkZbXVnEtIVjKA8kh+hhdyXqeaNqYzFrXF
 GR6wMTrp
 4315+9pa17qbh6rPAsua0Yv4dcWb+dOVnki6YoE/85anR0xE9RdTla4uH7dP2gwGAmTou3ft6+FZ0hx+vl/8W3ssLbTlOOQNONFFZ/B4wcd+1Bay9cYmCJ8XNelhF0qj5YeD71RMEz6oq1BQnkqqdJDgW9kAsMAcBscff6VbrB7PGp0upTOPIdD6eLRI68GG4plFpAY1fbR1lJEdDadvUjUH8xQ5mrnACz1n9awYjkMduxXTsi6cqZOtLm9Pv+eaUZHLbcpwHGxZzsvD3KaEqu700anJt6Da219SnX0YCwe8dyPOd2kUj1dpaiOZfXGAHSmRjjOVPMbvtLu5QsIoGqLybvrnSZLuW19xzwvzvxbLF5nViXgy9eh4dp0873xYvZ2zHXbSZc6+xATa34SI6xgXU75AxTJGbagBg40GeqxnsB/fNu6kWK5MHlIdHScrlzpBCVgCSQ20hpzwzF51UZNvKLIyySrpOA+pSKdUhkotcFGlP0Ge2WrpE8mPtZgchSRxfdk+AYItVRsANzcBwYp3LLJoRbDesYoqhzAgDOMQJGYBocKGPPVKkMngVMpeAmAYgZF2sL0X5+yk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 11:29:56 +0100 Shameer Kolothum <skolothumtho@nvidia.com> wrote:

> The function hugetlb_reserve_pages() returns the number of pages added
> to the reservation map on success and a negative error code on failure
> (e.g. -EINVAL, -ENOMEM). However, in some error paths, it may return -1
> directly.
> 
> For example, a failure at:
> 
>     if (hugetlb_acct_memory(h, gbl_reserve) < 0)
>         goto out_put_pages;
> 
> results in returning -1 (since add = -1), which may be misinterpreted
> in userspace as -EPERM.
> 
> Fix this by explicitly capturing and propagating the return values from
> helper functions, and using -EINVAL for all other failure cases.

Hello Shameer,

Thank you for the patch! The goal of this patch makes a lot of sense to me.
I just have a few comments:

> Fixes: 986f5f2b4be3 ("mm/hugetlb: make hugetlb_reserve_pages() return nr of entries updated")
> Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>
> ---
>  mm/hugetlb.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 795ee393eac0..1767f7599f91 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -7269,6 +7269,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	struct resv_map *resv_map;
>  	struct hugetlb_cgroup *h_cg = NULL;
>  	long gbl_reserve, regions_needed = 0;
> +	int ret;
>  
>  	/* This should never happen */
>  	if (from > to) {
> @@ -7308,8 +7309,10 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	} else {
>  		/* Private mapping. */
>  		resv_map = resv_map_alloc();
> -		if (!resv_map)
> +		if (!resv_map) {
> +			ret = -EINVAL;
>  			goto out_err;

NIT: What if we just initialize ret = -EINVAL in the declaration? Then we
can just preserve the original code and goto out_err here.

> +		}
>  
>  		chg = to - from;
>  
> @@ -7317,11 +7320,15 @@ long hugetlb_reserve_pages(struct inode *inode,
>  		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
>  	}
>  
> -	if (chg < 0)
> +	if (chg < 0) {
> +		ret = -EINVAL;

Is there a reason we set ret = -EINVAL here? I think it makes sense to
preserve what chg would have been returned here. There are two ways this value
gets set; for shared mappings, we have chg = region_chg(), and for private
mappings we have chg = to - from.

For shared mappings, region_chg() may return -ENOMEM, and I think this is
something that we would like to propagate, as the commit message of this
patch suggests. For private mappings, it does make sense to set it to 
-EINVAL, since we don't want to return a random negative value there. 

So maybe something like this? (Including the initialization of ret to -EINVAL
from above)

if (chg < 0) {
	if (chg == -ENOMEM)
		ret = -ENOMEM;
	goto out_err;
}

I'm sure there is also a more elegant way to handle this : -)

Although, there is a rare case that region_chg returns -ENOMEM because
add_reservation_in_range returns a negative value equal to -ENOMEM. In that
case we want to overwrite it with -EINVAL but will return -ENOMEM instead.

But this seems too rare : -) Maybe it makes sense to change region_chg or
add_reservation_in_range to check for a negative chg, and return -EINVAL
there instead as well. 

>  		goto out_err;
> +	}
>  
> -	if (hugetlb_cgroup_charge_cgroup_rsvd(hstate_index(h),
> -				chg * pages_per_huge_page(h), &h_cg) < 0)
> +	ret = hugetlb_cgroup_charge_cgroup_rsvd(hstate_index(h),
> +						chg * pages_per_huge_page(h),

NIT: Should we just unindent this line once and include &h_cg on the same
line? It seems like the original line also pushed the chg * pages... to
before the open parenthesis in the first line anyways.

> +						&h_cg);
> +	if (ret < 0)
>  		goto out_err;
>  
>  	if (vma && !(vma->vm_flags & VM_MAYSHARE) && h_cg) {
> @@ -7337,14 +7344,17 @@ long hugetlb_reserve_pages(struct inode *inode,
>  	 * reservations already in place (gbl_reserve).
>  	 */
>  	gbl_reserve = hugepage_subpool_get_pages(spool, chg);
> -	if (gbl_reserve < 0)
> +	if (gbl_reserve < 0) {
> +		ret = gbl_reserve;
>  		goto out_uncharge_cgroup;
> +	}
>  
>  	/*
>  	 * Check enough hugepages are available for the reservation.
>  	 * Hand the pages back to the subpool if there are not
>  	 */
> -	if (hugetlb_acct_memory(h, gbl_reserve) < 0)
> +	ret = hugetlb_acct_memory(h, gbl_reserve);
> +	if (ret < 0)
>  		goto out_put_pages;
>  
>  	/*
> @@ -7363,6 +7373,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  
>  		if (unlikely(add < 0)) {
>  			hugetlb_acct_memory(h, -gbl_reserve);
> +			ret = -EINVAL;
>  			goto out_put_pages;
>  		} else if (unlikely(chg > add)) {
>  			/*
> @@ -7423,7 +7434,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>  		kref_put(&resv_map->refs, resv_map_release);
>  		set_vma_resv_map(vma, NULL);
>  	}
> -	return chg < 0 ? chg : add < 0 ? add : -EINVAL;
> +	return ret;

We only return ret in the error case. If I understand the function correctly,
this part is only reached if there is an error somewhere. Should we rename
the 'ret' variable to 'err' instead? I think that will actually
add some clarity to this code path, since it's not immediately obvious that
this portion is just error handling & propagation otherwise.

I hope all of my comments make sense. Please feel free to correct me if
I've misunderstood any of the code or your intent with the patch as well : -)
Have a great day!

Joshua

