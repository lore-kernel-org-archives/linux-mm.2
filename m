Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B55E0C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 857346B00AC; Tue,  7 Jul 2026 03:18:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8076F6B00AF; Tue,  7 Jul 2026 03:18:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CFE96B00B0; Tue,  7 Jul 2026 03:18:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34BFC6B00AC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:18:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9F6340333
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:18:33 +0000 (UTC)
X-FDA: 84961127706.14.0916D98
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3D08D40005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:18:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="i/HavCEp";
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783408711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bx7b9iYZ9vYm18Zu21dfThw3RUT+c2jDNlVCLLvzOVg=;
	b=0FxKRNWqxYozM+tA3824qHlRt7iJDDaJ6dcn3HhIDguZhZIS3HMgmhp8GFRCEmDEgBaX2A
	eHqj3a09r5NslK+/4PooUJFx1HrdPzUn1JpBJ1sJ44nJl6a7cTwC+L09XT7NoalFTw6+WV
	thH+lBCWATNlsP3vhxSvjEBapC4COGE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="i/HavCEp";
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783408711;
	b=KCyYNmfKaNu88dTbMmrQxnOlzoSNxuStb2rmMGF9JA1vHtlpLa8fyjzftSQPx10Nlx5kdQ
	oeJHv9t5YyBAbCjB/fde9Y/W0DhOwJiN69rbMZmB/4rNE7aKExw9wPlqqyKPloI7D0JleQ
	pRuujdDVkDpRSDT5qZK9xKJSdzgHGlA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783408710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bx7b9iYZ9vYm18Zu21dfThw3RUT+c2jDNlVCLLvzOVg=;
	b=i/HavCEpATlAYUgVtXxgJ9VGiA+J5ESydaKwALvqq1vIpWDBZcycBSfl9GpXAOug4zlqPt
	KmhpWGA/6kpW53rS4yiWnbIboZzYzWMzonLUnJIfnbMYru8dMySD3melSU+uMeAjFR4gmb
	zBIplZWscmovTcyMfJ3e3t3jGVM34gw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-_Gaw8y92PM-ic3dhpjNhQQ-1; Tue, 07 Jul 2026 03:18:29 -0400
X-MC-Unique: _Gaw8y92PM-ic3dhpjNhQQ-1
X-Mimecast-MFC-AGG-ID: _Gaw8y92PM-ic3dhpjNhQQ_1783408708
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-476608a9fefso179972f8f.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 00:18:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783408708; x=1784013508;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bx7b9iYZ9vYm18Zu21dfThw3RUT+c2jDNlVCLLvzOVg=;
        b=jEibh8aPCEbsLg2+4R+toH01dt64zJcPCEnkvTPYqu+X5Uiji2ReQY0IQI9f2rhje+
         ZbfAcm9SDRGGbRBjLeJT3OF+NKbGt1VboZBsKhXj5tULNb0MqFev+FvhwvinOckCM253
         8IvVsl6Z0yzzu16Qgiur87FAv1dBL93fEtHSIuvDNRRksb27nBqp38JJ6etlLpN6S3/c
         OYujl2TCzIpRumi/n49jMvur4Qf5nP2egA2AvZ3kdhigUDdJ7/jsr9Ru4IlumtiXQpGw
         Pmd4SRqEsI1s5FDjq7XgsOEdXTnvy8T0KG4Cw25VkI0iOTc48q+hFb/KZ5c0TYziwlnF
         0dNA==
X-Forwarded-Encrypted: i=1; AHgh+RpxadDukJd6J4y8/rvZxCCz2eMCOJWZ+EZuCo72HGgv6fc0MrYEAWbr509cgThi9/vMU1924QcMsg==@kvack.org
X-Gm-Message-State: AOJu0Yzjqu2X4DZIy1/jRHF+0yvbIemRLa7pxM4F1acmhjAU7guPI76S
	hs2HDOUF7taWOnA6TjKZYvfa2TAXpm+7oTMcrLXKSbvTZPff1NxpBe5asBRaXjH5kx/bfN8I1MP
	oZdIPjU0lq7BBlt9rzDHFi0Uftob5oo8dqqk8n5tDxcXG2dbn05tD
X-Gm-Gg: AfdE7cnlwaQ1S4af9NlU6cQTPkpE3SMgrtD33q+AMlCKct74TCUJU7aGyUhw+tbRzPr
	GjjHT2x+SUQZXLF8FMgsyvG8ARt8rm+lJJ0/FgFmbUAvCIVPvTfOPNkknT8vzWYPKsb8NrVycZa
	24cPH920vQMNDa+0wsE97dPbUIRuw20DMeG1annrnAUM5FIqadkoUgEhdMyvX5elNBZtUhYbRAY
	AE+/jms7dR+NqBZnn/4wrAx60dz7Lcha5ZcIlZZes2lcUpfS7QXWcK5ky7BFBpmFEeo8TgXx4nT
	sKcpB/T1Px67WteVCST1e7NI/4Uy4irlqThlZgtPyqEtF81FuxfIKYCLFVhRnEfirlXR+iXVdJD
	XwO0Kb8cgAp/2ntwGQCVN8Dyqthlh+nt8
X-Received: by 2002:a05:6000:43c6:20b0:474:4817:8c15 with SMTP id ffacd0b85a97d-47de9a446e0mr1123649f8f.26.1783408707973;
        Tue, 07 Jul 2026 00:18:27 -0700 (PDT)
X-Received: by 2002:a05:6000:43c6:20b0:474:4817:8c15 with SMTP id ffacd0b85a97d-47de9a446e0mr1123596f8f.26.1783408707388;
        Tue, 07 Jul 2026 00:18:27 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e3e2702sm32003544f8f.9.2026.07.07.00.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 00:18:26 -0700 (PDT)
Date: Tue, 7 Jul 2026 03:18:23 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sourav Panda <souravpanda@google.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, mhklinux@outlook.com, fvdl@google.com,
	gthelen@google.com, mike.kravetz@oracle.com,
	pasha.tatashin@soleen.com, rientjes@google.com, riel@surriel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 6/6] mm/hugetlb: support free page reporting for cached
 hugepages
Message-ID: <20260707031039-mutt-send-email-mst@kernel.org>
References: <20260707064235.1386552-1-souravpanda@google.com>
 <20260707064235.1386552-7-souravpanda@google.com>
MIME-Version: 1.0
In-Reply-To: <20260707064235.1386552-7-souravpanda@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D_3tNOiL5rKPm-HN3TXzz4GfhheEzyatJB0IMdOngaI_1783408708
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3D08D40005
X-Stat-Signature: u11ezsp9ec1ikj1ucr5mstj1s7io7n9c
X-HE-Tag: 1783408711-293064
X-HE-Meta: U2FsdGVkX18kx4vcDkOTIk7njsyq8wKUByk/4f/w8ZT8gE2UA65WIEyq09RqVsyVOXKOVlBcAayW3XbD7wYBoORvklVn8iKoIbWWoS2DSlUjSaZtixXRN3/1aP+QvRRJhrYosJAg9rpzhfH3cpRmiATbz9S+9WC+TzsHkW0tcCj9Dc68wTG79Oj3Aa3/RfJ0zlTkVc+qBNDlODNbQQeSP5aG39GGbE7b2N+elb7V12E7/sunoZPKAvsC6/cSUZiHxqDAzZZBIqhYa2yUamJQNPUHELFUTUR3+p8FHn7QhYB+pmAePbG8xp5nNaW70CxJ8q+IwvsJC1xDiT3tdizRNYQEjfInyR+K/F17esmk81BCdp0KXxrRAyRKdCrUj4vGlC16h/GR4edz3JeMUCiBsdFumOUT+/HfqSFWVoznavttb2gxJGYO0n669yQasDr2nWxRamL4Xc9TtMnSP1e5UvPeG5oQLS53gnyANBLWCntGHtekAeX4B0YBa0rby5hfYgqqnsHAJieR/fbNSjuFJN/lVzHwY6dSUVnJz9RTeNY2owgzIwwV4qaiF1TBk/b/YpnlnGnm3buRbUBnYCofcjDQ5pvv/4hjMf9ki8P1v0TkWjghLERQJ3qTWT2WvLAdQCVgUPMEy3TVMTZc9MW2J/EMJL81GlvDP7qpjtYq5aoBlrO/xlzj69ZfYH2m1MTFEYnm/+x55inoUN7ceyVnYh5xlqoxUafHpA7euEXxe0bNWmOObMvY9n6d1l2Jfm7SgZzuJ+SSGGauGc3NTzqNTPXl9y/lTxTa0QWt0wIdQQXnGp+hjVyu3luLGf+XCSodRBU6n33Imfxlhuk7W3UEiJF7XPGFTG7QM2sAr+di8OpWlJKwH70D7pirm3BLhEEjQOM1P6DR3jFWhUlBN5Lk7nrwsmEDKxI+8l3rggBcBmH7F6ZdffEs34bE+1NADSlqmR8FJJ8kG/vU2CDQdQB
 cmujFqKo
 gLW+LTsUFECVIzKpD02eR1/ajmLjbabxTCzccLW9p/X7cE6qEixPvX2LLF0cVzmRl3m8MrvNEN9sE42cDd/9RlYUQvHMxDW9Cx/FrXcbze/wTxPZfkuM02VUbrtO8BHOmd59DSE+jaRmvdIBZqt4tj7ohCTcA0sRMGK1XRB4djxv+sC9FRKorvUI94WEwFTPpebthLSh0tD/uQoPPcWEV5PHpmzwTG7rwN95Fq+VaKh9/auBScqCHlQvkkzAXlCOJuyAd3QcriBoXFiIEWxoxtQdRSOL4Ax8oKnZX+W2+EB747sJgmOlOKuHxbkpYP7CmS4ES
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the patch! Yet something to improve:

On Tue, Jul 07, 2026 at 06:42:35AM +0000, Sourav Panda wrote:
> Implement free page reporting for the HugeTLB dynamic cache.
> 
> Register HugeTLB hstates with the page reporting framework if they
> support caching.
> 
> When pages are added to the cache (either via recycling in
> free_huge_folio or direct population via sysfs nr_cached_hugepages),
> trigger a page reporting cycle.
> 
> Page reporting isolates pages from the cache list, reports them to the
> hypervisor via virtio-balloon, and then drains them back to the cache
> list, marking them as reported (HPG_reported).
> 
> If a page is allocated from the cache, or reclaimed, clear the reported
> flag.
> 
> Signed-off-by: Sourav Panda <souravpanda@google.com>
> ---
>  include/linux/hugetlb.h        |  27 +++++++
>  include/linux/page_reporting.h |   1 +
>  mm/hugetlb.c                   | 125 +++++++++++++++++++++++++++++++++
>  mm/page_reporting.c            |  10 ++-
>  mm/page_reporting.h            |   6 ++
>  5 files changed, 163 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index e882c99780b6..bde23edcb803 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -587,6 +587,7 @@ enum hugetlb_page_flags {
>  	HPG_cma,
>  #ifdef CONFIG_HUGETLB_CACHE
>  	HPG_cached,
> +	HPG_reported,
>  #endif
>  	__NR_HPAGEFLAGS,
>  };
> @@ -650,10 +651,14 @@ HPAGEFLAG(RawHwpUnreliable, raw_hwp_unreliable)
>  HPAGEFLAG(Cma, cma)
>  #ifdef CONFIG_HUGETLB_CACHE
>  HPAGEFLAG(Cached, cached)
> +HPAGEFLAG(Reported, reported)
>  #else
>  static inline bool folio_test_hugetlb_cached(const struct folio *folio) { return false; }
>  static inline void folio_clear_hugetlb_cached(struct folio *folio) { }
>  static inline void folio_set_hugetlb_cached(struct folio *folio) { }
> +static inline bool folio_test_hugetlb_reported(const struct folio *folio) { return false; }
> +static inline void folio_clear_hugetlb_reported(struct folio *folio) { }
> +static inline void folio_set_hugetlb_reported(struct folio *folio) { }
>  #endif
>  
>  #ifdef CONFIG_HUGETLB_PAGE
> @@ -1093,6 +1098,20 @@ void hugetlb_unregister_node(struct node *node);
>   */
>  bool is_raw_hwpoison_page_in_hugepage(struct page *page);
>  
> +#ifdef CONFIG_HUGETLB_CACHE
> +struct page_reporting_dev_info;
> +int hugetlb_page_reporting(struct page_reporting_dev_info *prdev,
> +			   struct scatterlist *sgl);
> +#else /* !CONFIG_HUGETLB_CACHE */
> +struct page_reporting_dev_info;
> +struct scatterlist;
> +static inline int hugetlb_page_reporting(struct page_reporting_dev_info *prdev,
> +					 struct scatterlist *sgl)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_HUGETLB_CACHE */
> +
>  static inline unsigned long huge_page_mask_align(struct file *file)
>  {
>  	return PAGE_MASK & ~huge_page_mask(hstate_file(file));
> @@ -1311,6 +1330,14 @@ static inline bool hugetlbfs_pagecache_present(
>  static inline void hugetlb_bootmem_alloc(void)
>  {
>  }
> +
> +struct page_reporting_dev_info;
> +struct scatterlist;
> +static inline int hugetlb_page_reporting(struct page_reporting_dev_info *prdev,
> +					 struct scatterlist *sgl)
> +{
> +	return 0;
> +}
>  #endif	/* CONFIG_HUGETLB_PAGE */
>  

why are there twice the stubs? And should this not depend on CONFIG_PAGE_REPORTING too?


>  static inline spinlock_t *huge_pte_lock(struct hstate *h,
> diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
> index 9d4ca5c218a0..bd5a5a293dc3 100644
> --- a/include/linux/page_reporting.h
> +++ b/include/linux/page_reporting.h
> @@ -27,4 +27,5 @@ struct page_reporting_dev_info {
>  /* Tear-down and bring-up for page reporting devices */
>  void page_reporting_unregister(struct page_reporting_dev_info *prdev);
>  int page_reporting_register(struct page_reporting_dev_info *prdev);
> +extern unsigned int page_reporting_order;

again why twice.


>  #endif /*_LINUX_PAGE_REPORTING_H */
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 1bc0198a695c..110c566efc3b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -46,7 +46,9 @@
>  #include <linux/io.h>
>  #include <linux/node.h>
>  #include <linux/page_owner.h>
> +#include <linux/page_reporting.h>
>  #include "internal.h"
> +#include "page_reporting.h"
>  #include "hugetlb_vmemmap.h"
>  #include "hugetlb_cma.h"
>  #include "hugetlb_internal.h"
> @@ -1414,6 +1416,7 @@ static void hugetlb_cache_remove(struct hstate *h, struct folio *folio, bool to_
>  	list_del_init(&folio->lru);
>  	folio_clear_hugetlb_freed(folio);
>  	folio_clear_hugetlb_cached(folio);
> +	folio_clear_hugetlb_reported(folio);
>  	h->nr_cached_hugepages--;
>  	h->nr_cached_hugepages_node[nid]--;
>  	if (to_surplus) {
> @@ -1806,6 +1809,7 @@ void free_huge_folio(struct folio *folio)
>  		    !folio_test_hwpoison(folio)) {
>  			arch_clear_hugetlb_flags(folio);
>  			hugetlb_cache_add(h, folio, true);
> +			page_reporting_notify_free(h->order);
>  			spin_unlock_irqrestore(&hugetlb_lock, flags);
>  			return;
>  		}
> @@ -4231,6 +4235,7 @@ static int adjust_cached_huge_pages(struct hstate *h, long count, bool is_delta,
>  			account_new_hugetlb_folio(h, folio);
>  
>  			hugetlb_cache_add(h, folio, false);
> +			page_reporting_notify_free(h->order);
>  			spin_unlock_irq(&hugetlb_lock);
>  			cond_resched();
>  		}
> @@ -4310,6 +4315,7 @@ static int adjust_cached_huge_pages(struct hstate *h, long count, bool is_delta,
>  			account_new_hugetlb_folio(h, folio);
>  
>  			hugetlb_cache_add(h, folio, false);
> +			page_reporting_notify_free(h->order);
>  			spin_unlock_irq(&hugetlb_lock);
>  			cond_resched();
>  		}
> @@ -7763,3 +7769,122 @@ void fixup_hugetlb_reservations(struct vm_area_struct *vma)
>  	if (is_vm_hugetlb_page(vma))
>  		clear_vma_resv_huge_pages(vma);
>  }
> +
> +#ifdef CONFIG_HUGETLB_CACHE
> +static void page_reporting_drain_hugetlb(struct hstate *h,
> +					 struct scatterlist *sgl, unsigned int nents, bool reported)
> +{
> +	struct scatterlist *sg = sgl;
> +	unsigned int left = nents;
> +
> +	spin_lock_irq(&hugetlb_lock);
> +	do {
> +		struct page *page = sg_page(sg);
> +		struct folio *folio = page_folio(page);
> +
> +		hugetlb_cache_add(h, folio, false);
> +
> +		if (reported)
> +			folio_set_hugetlb_reported(folio);
> +	} while (--left && (sg = sg_next(sg)));
> +	spin_unlock_irq(&hugetlb_lock);
> +
> +	sg_init_table(sgl, nents);
> +}
> +
> +static int hugetlb_page_reporting_cycle(struct page_reporting_dev_info *prdev,
> +					struct hstate *h, int nid,
> +					struct scatterlist *sgl, unsigned int *offset)
> +{
> +	struct list_head *list = &h->hugepage_cache_lists[nid];
> +	unsigned int page_len = huge_page_size(h);
> +	struct folio *folio, *next;
> +	long budget = 100; /* Limit */

why 100? and "Limit"? What kind of comment is this?


> +	int err = 0;
> +
> +	if (list_empty(list))
> +		return err;
> +
> +	spin_lock_irq(&hugetlb_lock);
> +
> +	list_for_each_entry_safe(folio, next, list, lru) {
> +		if (folio_test_hugetlb_reported(folio))
> +			continue;
> +
> +		if (budget < 0) {
> +			atomic_set(&prdev->state, PAGE_REPORTING_REQUESTED);
> +			break;
> +		}
> +
> +		if (*offset) {
> +			/* Isolate */
> +			hugetlb_cache_remove(h, folio, false);

are you sure this is right? in patch 2 it is:
       if (folio_test_hugetlb_cached(folio) && list_empty(&folio->lru))
           return -EBUSY;
and hugetlb_cache_remove clears HPG_cached.


> +
> +			--(*offset);
> +			sg_set_page(&sgl[*offset], &folio->page, page_len, 0);
> +			continue;
> +		}
> +
> +		spin_unlock_irq(&hugetlb_lock);
> +
> +		err = prdev->report(prdev, sgl, PAGE_REPORTING_CAPACITY);
> +		if (!err) {
> +			pr_info("HugeTLB page reporting: reported %u pages of size %luKB\n",
> +				PAGE_REPORTING_CAPACITY, huge_page_size(h) / 1024);

seriously?

> +		}
> +
> +		*offset = PAGE_REPORTING_CAPACITY;
> +		budget--;
> +
> +		page_reporting_drain_hugetlb(h, sgl, PAGE_REPORTING_CAPACITY, !err);
> +
> +		spin_lock_irq(&hugetlb_lock);
> +
> +		if (list_empty(list))
> +			break;
> +		next = list_first_entry(list, struct folio, lru);
> +
> +		if (err)
> +			break;
> +	}
> +
> +	spin_unlock_irq(&hugetlb_lock);
> +	return err;
> +}
> +
> +int hugetlb_page_reporting(struct page_reporting_dev_info *prdev,
> +			   struct scatterlist *sgl)
> +{
> +	struct hstate *h;
> +	int err = 0;
> +	int nid;
> +
> +	for_each_hstate(h) {
> +		if (h->order < page_reporting_order)
> +			continue;
> +
> +		for_each_online_node(nid) {
> +			unsigned int offset = PAGE_REPORTING_CAPACITY;
> +
> +			err = hugetlb_page_reporting_cycle(prdev, h, nid, sgl, &offset);
> +			if (err)
> +				return err;
> +
> +			/* Report leftovers */
> +			unsigned int leftover = PAGE_REPORTING_CAPACITY - offset;
> +
> +			if (leftover) {
> +				struct scatterlist *sg = &sgl[offset];
> +
> +				err = prdev->report(prdev, sg, leftover);
> +				page_reporting_drain_hugetlb(h, sg, leftover, !err);
> +				if (err)
> +					return err;
> +				pr_info("HugeTLB page reporting: reported %u pages of size %luKB\n",
> +					leftover, huge_page_size(h) / 1024);

again

> +			}
> +		}
> +	}
> +	return 0;
> +}
> +#endif
> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> index 7418f2e500bb..882496b8b2c9 100644
> --- a/mm/page_reporting.c
> +++ b/mm/page_reporting.c
> @@ -2,6 +2,7 @@
>  #include <linux/mm.h>
>  #include <linux/mmzone.h>
>  #include <linux/page_reporting.h>
> +#include <linux/hugetlb.h>
>  #include <linux/gfp.h>
>  #include <linux/export.h>
>  #include <linux/module.h>
> @@ -50,12 +51,6 @@ EXPORT_SYMBOL_GPL(page_reporting_order);
>  #define PAGE_REPORTING_DELAY	(2 * HZ)
>  static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
>  
> -enum {
> -	PAGE_REPORTING_IDLE = 0,
> -	PAGE_REPORTING_REQUESTED,
> -	PAGE_REPORTING_ACTIVE
> -};
> -
>  /* request page reporting */
>  static void
>  __page_reporting_request(struct page_reporting_dev_info *prdev)
> @@ -334,6 +329,9 @@ static void page_reporting_process(struct work_struct *work)
>  			break;
>  	}
>  
> +	if (!err)
> +		err = hugetlb_page_reporting(prdev, sgl);
> +
>  	kfree(sgl);
>  err_out:
>  	/*
> diff --git a/mm/page_reporting.h b/mm/page_reporting.h
> index c51dbc228b94..74e05af4bac1 100644
> --- a/mm/page_reporting.h
> +++ b/mm/page_reporting.h
> @@ -11,6 +11,12 @@
>  #include <linux/scatterlist.h>
>  
>  #ifdef CONFIG_PAGE_REPORTING
> +enum {
> +	PAGE_REPORTING_IDLE = 0,
> +	PAGE_REPORTING_REQUESTED,
> +	PAGE_REPORTING_ACTIVE
> +};
> +
>  DECLARE_STATIC_KEY_FALSE(page_reporting_enabled);
>  extern unsigned int page_reporting_order;
>  void __page_reporting_notify(void);
> -- 
> 2.55.0.rc0.799.gd6f94ed593-goog


