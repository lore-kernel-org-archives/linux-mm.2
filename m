Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E21DFD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 20:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4E166B0088; Wed, 25 Feb 2026 15:27:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC5D6B0089; Wed, 25 Feb 2026 15:27:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B39A6B008A; Wed, 25 Feb 2026 15:27:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87C086B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:27:07 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EFB31A06FB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:27:07 +0000 (UTC)
X-FDA: 84484113294.22.EA36426
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 677DF120005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 20:27:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hhCqCwfk;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772051225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnoCZpEnsiZT/nYZfVWRoHJkjSlEny21hV+TMR2IO+k=;
	b=JWMBh2PUSJaAIOwVEze8SpsPe2iBqTYmXpEcuydmBOrain8fvs9bS1R8T6+wV5oQhuTLUc
	3w5WeyeVlT/vdXmVIXrWYNw/gsTY38yGlSJd/6S2KdFHWnrPe/Y84ihoRa4PGK2reB85eL
	a/q32v0ZGmmiGbJVBKOlAZGvQx+NRw0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772051225; a=rsa-sha256;
	cv=none;
	b=CmpYhsNIcX/GoSQHxTykJAjbIlGE4hjx14lq0Lo8qkZpNCddsWL/3pR2Ah71csZf+TyNYB
	UQ0N041WXSr/6ZY2oXWg/yG0ZhRRkPOZmpNxzWM/NfzMRALCPlw4mIZAQ+GQe7/+MpyrW9
	IZcxIxyaauUoibfY797+lmHnUlzH3hY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hhCqCwfk;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d556c1a79eso10052a34.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772051224; x=1772656024; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EnoCZpEnsiZT/nYZfVWRoHJkjSlEny21hV+TMR2IO+k=;
        b=hhCqCwfkRiRO28Ny3W10RtRwlKrkaB6bglvNwUicLxHWI7BvNBAO9wqGUYxzTKLBvQ
         o8uvcqyOTc8pOhAuoqLXtVz8fgMLPA38cYkSvMWfxAsCW+PSF4bPTx6dnuJ/WYGqxbun
         r/T7cuBOVp+cDc12FMzn9isUUAdR5aMWaaSlDFDOLYdkuXJw1nfVZ5+1mCbyPZn3WfZz
         exTPUkdv/qPmJwc6xnyiG6Kcu0yB+WIhLhkVUBt/HvZ7Vgkku2hfAZUV6gjzbgwY3V/v
         6XkKoukzwzzErrHRH5YX1yTJZ79JEFinWxX3YzLBMWRF/Mk6z9LMsPQ1aTg1lsv3+9uS
         1ZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772051224; x=1772656024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EnoCZpEnsiZT/nYZfVWRoHJkjSlEny21hV+TMR2IO+k=;
        b=taykFxbY8Kn4yGENpubxSM8VxmUsG4H3AZTau+zI5LSR2Bq0HjMCfvkX9SqMnjfJVR
         k66bnTpVi08RWUJ2fIKi1TBrbYP2gnInRpBpodq8SsRiEe7E9lSnstrJnzretK+qYxk0
         e8y2YWJZD3bQpxyLNlbIe6+uiyP3mBO/u26Cgetvi/+bucpyL8MjJ4uOHEdYetdKDMpp
         sxV4IdrjJ8sEh2LBWuHuEEW9poM74dLIXO92vUhOYmDksktfk/1aAoujj8mqsoN3N8xJ
         Y6ZltP4Ner7x6WzbI7y4T2PoDu1EuLGUYXLvKGzZggvhi8i4w6Hz3S8IpymhQIfg+rci
         jbYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwcvGewYgePNCcqN4bNqdkxT4TFmn48jt3CZCgI6YI0L69Zg2KuWxO2QgHLQSWG8iIwCNdyq09ZQ==@kvack.org
X-Gm-Message-State: AOJu0YyifEgdC46dRf+MnQj5h8i6qxB9TYc1QrpUMS/HbA/oLyGJppTp
	8NSqsxjndCLIBkc4D9tKbcf3eIL1T2AcJF/3AEgM4598WSLGSIqyIArC
X-Gm-Gg: ATEYQzx94RJnkB3X/wpA5PAZeYOrOumztcEpMQwSHdkn1PhSgl77tvhzAZBKjAMHGfW
	yaspzAHn5TPhzsn5tcAOnTGm4TPdoxzh6jSRrheOxl3e0S8eBiQbGeVxtJq+cgig559W/Ghe/fx
	9s70/OJuFDykO4dlWuy/X4EbKHfpn71vLSGdD99OXJGh9tpkvq+EKPJrp2lyUa/fVyhZF1P+WH4
	+dR5E0qZq5EKMVbyqkLwxoeZhDWeD0+Fj56of+hSR25OLJMZbPivqDbq2IRbqCnDj/cLNczgZqH
	oM0XjHGg3LCitYR//lnrWRWZkusAuelQ2qySq65enDjSAP0TGyK4VnC6MWFZVUpMRBPF4JqOSrQ
	Rdfq/7Xk3Q97Msgx3450KQvTVF64v4dCCkvFEtdAGj5uTfeFLbcqD4F8BpRRy3v+9ZQXo2ViWzF
	yukh41a6zP7LaiAfPLcpf0
X-Received: by 2002:a05:6830:6c07:b0:7cf:e4a1:8b6b with SMTP id 46e09a7af769-7d52bdf6e7fmr9810731a34.4.1772051224348;
        Wed, 25 Feb 2026 12:27:04 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:2::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d58644edf0sm8089a34.2.2026.02.25.12.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 12:27:02 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: akpm@linux-foundation.org,
	dan.j.williams@intel.com,
	david@kernel.org,
	fvdl@google.com,
	hannes@cmpxchg.org,
	jgg@nvidia.com,
	jiaqiyan@google.com,
	jthoughton@google.com,
	kalyazin@amazon.com,
	mhocko@kernel.org,
	michael.roth@amd.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	pasha.tatashin@soleen.com,
	pbonzini@redhat.com,
	peterx@redhat.com,
	pratyush@kernel.org,
	rick.p.edgecombe@intel.com,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	seanjc@google.com,
	shakeel.butt@linux.dev,
	shivankg@amd.com,
	vannapurve@google.com,
	yan.y.zhao@intel.com,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 1/7] mm: hugetlb: Consolidate interpretation of gbl_chg within alloc_hugetlb_folio()
Date: Wed, 25 Feb 2026 12:27:00 -0800
Message-ID: <20260225202701.4104505-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <fa4172f57caf8fd3013d13d96211de6bb8cf6d38.1770854662.git.ackerleytng@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: exu51yoyaneny3uwg5d9rtk8c1xo9dk3
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 677DF120005
X-HE-Tag: 1772051225-399276
X-HE-Meta: U2FsdGVkX193kgafQqlcrSIYjiFeMyaRdTeXmkn93XXUkMK0ZZF1sBc2FgCalP9H4FDTugJkZPyIIISvV8+eaRIwBwSMaYhGVTuQQJhgHGhbPo5Nc9rdPMTtdmgAiuRkPNeuHAn29yviIqH99EYXqvG/wmD6huMEYTAYw80CIoj00OIsGX5LdOEg0YUdiQj/piT8/ihVhKpweXcCAWuPkSTujMdl2t1IDjshD5uCzmIwwK0OMd9Qylh6WrsFZBbAjk/g19JFdCGlgmuqbqc+ubwnHnDOlKA+UTwWTn7I62kkLBg88PizNN5JWBA0JE3o1bs5X1AyDgK9n3ewGSw02b78jd0m1cdNCP/rMf8ZPVu2FvoogUMv+/Smzsh+QFUvumUpU1WYFI1EAZEPnF8vsFPSZ0xMJKPB26f7AOO2J+SqFvEE76kH+CwQfxapVh2Sy1K+bQ+oHj6yZo7YSGyD6dAukRl/+Bj9E42S2e9EQEWIx50IUyPJEmentMld5vUqyREhUufKrHknDx1OxbvWSX0NEas1cwJg9pjNc+th7n1uWAk9x7vBKW/YgKTzdbgRPI8H0s4fiU8TxGyLOMR+zm3SUJ4+yPLFABuXfOn+eYK32icD/tbaJEDOdssDrvZyM30m92QwRd3/aVK2zFaL4B4uKSU/9lOCDj/LdEmHzyFIyDFsBYneEcxqOXYVZMK72ywYL2A+T6qHd1U7C3tBWBiEJ62wZs6lnwBHjZytVRrcB58vUtxWnt9d6uIYAeBgrs9JCsZ4DW0s45nX5wJj1NeewD/+nB8vSvcsC7DPEcE2x9GxBhSX5mFg+TTpQ981WALT92QhAjIsxUTtRgw0/GKSf3krp68T3u9Vs17jcdUhjRiRusvdYxIrd5uksYtJ4YphdDojj8rjDyf5cVLH4yjGWR6CLBhu4aDtxJpx52yKkJ0grJr+yQRAvAsGdX0mA6+k86y4iVxOekaLdHA
 o/uvdHWR
 PrToTmziTiG/rMrHXb2ZK5ypPCIFnK2+4uhKA66YpJ8F8jH61B0egpE7ROQ5fKDtPILGZsKDLuQRW/4RoDSeKQ668oPjmTPaU803JwSXHo7+Xj4FvqpYP/XCXBLKuWmEX253g+6lbFT+nbTqFGjQDLomlYkxp2PcHv/GBFwt0qjINd8o/SosBmKpyVbmS+YLrO/1XrxKLDE7o8yjqWASxdbl9/fgy4SuXyh44zWIuBIA0B6OWx0puGe82x5b3O66GTv+OK596xjGGP8E27MzHmWYFnQN9s3rk0NXMoAADjCG4J57AqSQugMW4a7ZC4n9GJoWaKdyVeUjXKyyKWXs+cRc4uyndCCQqeNud3NoudCJcG0mg5q/W0erS2L76bKrHNLOt+4z4Z6xJJ71sf42MTwu4gRbHGIUYqosWoksmS5Tmz/o2YO1n5OPYXc4e7Sd2UeZ+51fvft1vQ2oC27lzx+hCWteiOaD3ShscccxTcSTak9llWDoqDOl7qbbMowQgDwXVPdLm3BrQWTcR5bQcQv6R1dKl0wOzttfyCbXVDV/e7jhhBTIkPE1OQkIguwULtQHF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Feb 2026 16:37:12 -0800 Ackerley Tng <ackerleytng@google.com> wrote:

> Previously, gbl_chg was passed from alloc_hugetlb_folio() into
> dequeue_hugetlb_folio_vma(), leaking the concept of gbl_chg into
> dequeue_hugetlb_folio_vma().
> 
> This patch consolidates the interpretation of gbl_chg into
> alloc_hugetlb_folio(), also renaming dequeue_hugetlb_folio_vma() to
> dequeue_hugetlb_folio() so dequeue_hugetlb_folio() can just focus on
> dequeuing a folio.
> 
> No functional change intended.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: James Houghton <jthoughton@google.com>

Makes sense to me, this seems like a reasonable semantic change even
without factoring out hugetlb_alloc_folio. Thank you!

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> ---
>  mm/hugetlb.c | 24 +++++++++---------------
>  1 file changed, 9 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a1832da0f6236..fd067bd394ee0 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1380,7 +1380,7 @@ static unsigned long available_huge_pages(struct hstate *h)
>  
>  static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
>  				struct vm_area_struct *vma,
> -				unsigned long address, long gbl_chg)
> +				unsigned long address)
>  {
>  	struct folio *folio = NULL;
>  	struct mempolicy *mpol;
> @@ -1388,13 +1388,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
>  	nodemask_t *nodemask;
>  	int nid;
>  
> -	/*
> -	 * gbl_chg==1 means the allocation requires a new page that was not
> -	 * reserved before.  Making sure there's at least one free page.
> -	 */
> -	if (gbl_chg && !available_huge_pages(h))
> -		goto err;
> -
>  	gfp_mask = htlb_alloc_mask(h);
>  	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
>  
> @@ -1412,9 +1405,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
>  
>  	mpol_cond_put(mpol);
>  	return folio;
> -
> -err:
> -	return NULL;
>  }
>  
>  #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> @@ -2962,12 +2952,16 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  		goto out_uncharge_cgroup_reservation;
>  
>  	spin_lock_irq(&hugetlb_lock);
> +
>  	/*
> -	 * glb_chg is passed to indicate whether or not a page must be taken
> -	 * from the global free pool (global change).  gbl_chg == 0 indicates
> -	 * a reservation exists for the allocation.
> +	 * gbl_chg == 0 indicates a reservation exists for the allocation - so
> +	 * try dequeuing a page. If there are available_huge_pages(), try using
> +	 * them!
>  	 */
> -	folio = dequeue_hugetlb_folio_vma(h, vma, addr, gbl_chg);
> +	folio = NULL;
> +	if (!gbl_chg || available_huge_pages(h))
> +		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
> +
>  	if (!folio) {
>  		spin_unlock_irq(&hugetlb_lock);
>  		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
> -- 
> 2.53.0.310.g728cabbaf7-goog
> 
> 

