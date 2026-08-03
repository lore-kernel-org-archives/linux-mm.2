Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD4A8C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 14:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EAD46B0095; Mon,  3 Aug 2026 10:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99BBC6B009D; Mon,  3 Aug 2026 10:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B816B009E; Mon,  3 Aug 2026 10:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E22B6B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:55:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA02614072A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:55:57 +0000 (UTC)
X-FDA: 85060257954.23.52B72F8
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0646C18000F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:55:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dQWWikaM;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785768956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=peHvlhUw1Yu7SWf3hmHIsOYjE7R2xNdQVjGGTstXJYw=;
	b=a2ceGohWt/XGBazI9u79RlOPUFXeqTtl0SUE69HEZWVsyh9+ROLilB01MIATH8iq8p9hNB
	HZtTsTMz0Wt7/QqNgs0U1AyWPdT2HSftKeRx+WS0HOIJ8muNaPhdCxG9fmqcNt3a8YKPMV
	WaNgJZOV+dxkiDjMx20MY/mo4cHHwRw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dQWWikaM;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785768956;
	b=C/OTSQLMJrYliWci8wr7EFQzgatOc02+rcYmEIfDij3NiB+prI/gnjj+irP9V3ly+wLDGG
	+15frUgX1aRCxc5VL0YqRjoCYUtwo0qMKOAvTejaq5ngz4CE1Dp1DghBWO+wCdV3S0Odb2
	Gf87SGGnjFBQkH8jwUPVrEic8cRuS1w=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e99ef0902so173689985a.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 07:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785768955; x=1786373755; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=peHvlhUw1Yu7SWf3hmHIsOYjE7R2xNdQVjGGTstXJYw=;
        b=dQWWikaMYzZTHPAi5KsX3fyewTVc7Awfy4zu3UyQUyy9EWfxBkVFwDhm+iUnVcSih6
         NwKNY5QIuJI5abvLXHoovMpe+rK7Zjl1zO4XpSt5EVIDJJDmLT5DUUAl5xmNVXAdAqJ6
         nhXYHdUxQ1gNhklEB6wYBUtaVfDO92rQBxQTWhOVb4UCDFXZwq+fEJVmjBaLXv4AwjU0
         1Ruy3MX/WCFICTc3nCMX/gjalNUF0zWXmprH/Cx13C/n3GeNSkEMCUuXJ7WYmBgR+Lx0
         FQR8sCUf0ZANZdPCZKLZaZL5nExZd3wzlWjA4Q7lHqLYM7mE/9W0TMPUBv3QCicji3Qi
         WuOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785768955; x=1786373755;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=peHvlhUw1Yu7SWf3hmHIsOYjE7R2xNdQVjGGTstXJYw=;
        b=I0g9js52GO9y8lD0E5amOx+X3KAFkcSnpF0FmqpJ/CyqaNKV4nhwZG6aiUat7lMnl9
         r683SvTn9pp1asGpeWounWkHQBa7sULPMeqqzf8w+Y4ZH2BQ9zKDQAYUh21JMoqazXCx
         7uI56n1kzZm3NOf1sGM2xxqk5wHVkESfyWLE1oG6jHyLOm7dV9vc7a8fuPrUUEb984Ic
         hz5TS6ryoovaOuPh4dhoMcGY2Ync0O8Qeehl786ZRL1mlhavrTPNdF2bag4OZZd9QEv9
         GMO8MBLHRsOcSyNiYxlO4aaTaPewzWX8E0ydRuJp5fwWrJD1YoCGP+y1tvQZJ7GBICoO
         wIuw==
X-Forwarded-Encrypted: i=1; AHgh+RoLb13AyRvvUI7KndpOW6G9IX6O1Dw/n4u+yLFUy+c0JtcDUvz+u8GStNtehqesDjyvxy+b2z25Yg==@kvack.org
X-Gm-Message-State: AOJu0YxqX/P7RC71IYkbpWwvcHQuqdZuUC4Hr+PxLKt6d0BW5my1BLel
	OouqC/CF2m4TMy2vdTkTFfGiyB/UvigEeguKDOqlxieQDsSnu1M8U0FXnKDzUcghI+M=
X-Gm-Gg: AR+sD13pyXzpQ78+9zzYFxiTsCTB1z0diKIK8OoCxfDHVlRjFwvRFeHdx58Yu0ANtgg
	da3NuAvKCCB12Yrtk1AVyvfxZy/q/0lS7MF/9IdRgIaDz0X9Z5V0TFh0sHqlc3BjZ+RMDWRrzqO
	oFeS6aL32Lj5hbYpWq4fepwyXSPJhazuNeGo6r4TQBH45FKn/kwu9FIHAb54wjNEiHBVh2R8sDu
	igOFlfcUa4hDKtJNPE3a5RIzTBaJGD6h4RolFQHQATxRQyqbs85UfZhjw1PJ96bYdef64pjk/h/
	vCy2wt5eGv8YiV+Tdv1F+uSz2OC8FLN2kAMKs5RNNqOQQRfOnjvgzQ0zK18bAiCktIPy1uUVNBN
	9aG443f4NJqtJF/5SNKED7IpsduJBoja/sIcuUokQNOSa//ch922WNhxd45SjjNrYa7xS7KgyRd
	j4rZfRjgTWKejILYOpQ2qip1cMneGdVE4IN++cSPigO7xCTH17iouu+xeHwNmgMBhAYsGwUpZMQ
	PYhT12mE4oqtOtjIULJNT+AwW8Zo7+kjSrP14Gkl9z8
X-Received: by 2002:a05:620a:4e83:b0:916:14f5:8866 with SMTP id af79cd13be357-934a07a61d1mr1708987985a.16.1785768955096;
        Mon, 03 Aug 2026 07:55:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9349c206b00sm683232185a.46.2026.08.03.07.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 07:55:54 -0700 (PDT)
Date: Mon, 3 Aug 2026 10:55:52 -0400
From: Gregory Price <gourry@gourry.net>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Byungchul Park <byungchul@sk.com>, 
	David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Matthew Brost <matthew.brost@intel.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, erdemaktas@google.com, fvdl@google.com, 
	jiaqiyan@google.com, jthoughton@google.com, mhocko@kernel.org, michael.roth@amd.com, 
	pasha.tatashin@soleen.com, pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, seanjc@google.com, 
	shakeel.butt@linux.dev, shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 2/3] mm: hugetlb: Move mpol interpretation out of
 alloc_buddy_hugetlb_folio_with_mpol()
Message-ID: <anCqmhFw_D29uiuo@gourry-fedora-PF4VCD3F>
References: <20260803-hugetlb-mpol-interpretation-v5-0-af2b7089f8a9@google.com>
 <20260803-hugetlb-mpol-interpretation-v5-2-af2b7089f8a9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803-hugetlb-mpol-interpretation-v5-2-af2b7089f8a9@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0646C18000F
X-Stat-Signature: oaz51qhoh5ikna6izexz386459epmm3s
X-HE-Tag: 1785768955-558057
X-HE-Meta: U2FsdGVkX19KFRzoyCJeot8DUEoy9kXHUixIyTSH/26O807Yw89SRmk6z+91ESCZUy43Myc4blM12bE+JW6dlml8n7iYS1Ubd+IlAiye6rVsXuO0/HOqxdTeWzvJHS8kMXzJVgMsQ4qO0OM4DKh3VGsHA2XZjvbuB33ormnShuQzaQomM4xAafQLBsLWNSqNzlJYUcT9ssQx719pk3B7vIkmVPJsQ1spPvthzy75y4IA09nERHb+RDge8T+MbufNuei+zBisAjVkN1U7tL/cicAgnaXSdZwkNz3yEviRn6PoPTPLwlf2siUokG55alX81vJ/aXW9BvZqa7vVq8gELKCMVnLnnMEG+X1UFrIJR3OnGvME1MCyNsx/CPcWIX6yYN5z7xyTfnGQP4RFYjfNMlg7qgLCe4wjM9a14Vph02/8B2wBcI+rc8zDReD0Z3eVVbhctJY8woR46fgh+qvdEtJZr/ac2F+eUPqNsJBl+x7kRoaWoEfmFPj/FQS6D5/RNCSvjAb4hwBFsjuOCurF4ze912cAr2GE0x/n+iEVgxyGO5QE1FKwZg+g7Dr1zT+Ftfrrcj6ZngU3vPE4l2G+Kkmm5fzDfSq69ZtVv7dDi4fF/4QxBxfjndSzob7X/7sx7jeGoslFaK7pdV1JRPZouAxT7NGKdaHZM7eNhHVGH7yZ37hzB8281WOqyERqNsogqgh8dhOE+hqA7K+vPfBYuwue3kg8X5HKb1+hJ5vIEib92lXF7a/SgWZbHq9Ubvj4SqLVawrL/oJD6B/9/JdHyy6SVMoetdniWFaOer38bCsnPQNGA/iMHaJYpdbKkq/hSpFV6IStujfJdNG4pGRDDol5u/fS3zIKw4IC40ejUVKz3tJ+39yrZqAZ4FNiAtIKjU+T1jAgLjM/Su3uecpUlQILXiWz0hNE0HIvOXPjIMFbIePJeRI8C1mkijL4ewrbjiXM7b0JtF3nekFp97U
 XSyy2Ahx
 0/s1BvW0gLAAn6+gCoqUshtlFBJRdA/ccBN2g6rZ7+bylDis98ChSNNieIUQwlM58H1q1RuMSIwidFcXCs/0ilVyKZityYdAp7NDZiz1BQFQibtQtGrnaN6rJWpFklteivK9fMWdTUsaxTIV7Qm4JT8vmB7cCWvswDThuIIVXmU7+YaBHzVLdZC7eSJYK5KngZ8jStOjPPBd0xEbpFhQbr+FauMLDTKIgYTdRX9CEmd3G0AScqRkbZum25xSzzaCPmGg9Ek5EUI1Xs9Z5EL60sh7/ejFzYqHtU63vmyvsrQ4DjnTfXeEwpeUYjEpHG2yTtoEFzyjxk3zoAjNXBITpcXaFmnKmw2bJeuSzMHq2Vjxm7q2R0davKAX69KcLY9DMzooOZIh5B/EPxd9Ie2yfaCWf/3d0hFOuP705Sn1QeV5kkgX33lqBsfiu8fsSIUsyuf3UIKi8Giy/rSX9GCVJGLyo4eGMuFaUFr8/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 06:37:59AM -0700, Ackerley Tng wrote:
> Move memory policy interpretation out of
> alloc_buddy_hugetlb_folio_with_mpol() and into alloc_hugetlb_folio() to
> separate reading and interpretation of memory policy from actual
> allocation.
> 
> This will later allow memory policy to be interpreted outside of the
> process of allocating a hugetlb folio entirely. This opens doors for other
> callers of the HugeTLB folio allocation function, such as guest_memfd,
> where memory may not always be mapped and hence may not have an associated
> vma.
> 
> Introduce struct mempolicy_interpreted to hold all the components of an
> interpreted memory policy.
> 
> Rename alloc_buddy_hugetlb_folio_with_mpol() to alloc_buddy_hugetlb_folio()
> since the function no longer interprets memory policy.
> 
> No functional change intended.
> 
> Reviewed-by: James Houghton <jthoughton@google.com>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  include/uapi/linux/mempolicy.h |  2 +-
>  mm/hugetlb.c                   | 54 ++++++++++++++++++++++++++++--------------
>  2 files changed, 37 insertions(+), 19 deletions(-)
> 
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1317,6 +1317,12 @@ static unsigned long available_huge_pages(struct hstate *h)
>  	return h->free_huge_pages - h->resv_huge_pages;
>  }
>  
> +struct mempolicy_interpreted {
> +	int nid;
> +	nodemask_t *nodemask;
        ^^ const please (mempolicy owns it, it should never change)

> +	enum mempolicy_mode mode;
> +};
> +

Is this intended to be an ephemeral struct that will eventually be
removed?  Because it feels like mempolicy.c should just be handling this
directly instead of needing this cached structure.

>  static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
>  				struct vm_area_struct *vma,
>  				unsigned long address)
> @@ -2138,32 +2144,28 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
>  	return folio;
>  }
>  
... snip ...
> @@ -2926,8 +2928,24 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
>  
>  	if (!folio) {
> +		struct mempolicy_interpreted mpoli;
> +		struct mempolicy *mpol;
> +		nodemask_t *nodemask;
> +		int nid;
> +
>  		spin_unlock_irq(&hugetlb_lock);
> -		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
> +		nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
> +		mpoli = (struct mempolicy_interpreted){
> +			.nid = nid,
> +#ifdef CONFIG_NUMA
> +			.mode = mpol ? mpol->mode : MPOL_DEFAULT,
> +#else
> +			.mode = MPOL_DEFAULT,
> +#endif

This is not great, and tells me this interaction should probably
be sunk into mempolicy instead of pulling ifdef/else into hugetlb.

> +			.nodemask = nodemask,
> +		};
> +		folio = alloc_buddy_hugetlb_folio(h, gfp, &mpoli);
> +		mpol_cond_put(mpol);
>  		if (!folio)
>  			goto out_uncharge_cgroup;
>  		spin_lock_irq(&hugetlb_lock);

