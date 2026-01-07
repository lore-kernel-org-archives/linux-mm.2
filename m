Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7572BCFD652
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 15:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2DF6B0095; Wed,  7 Jan 2026 10:21:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C709B6B0096; Wed,  7 Jan 2026 10:21:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98D36B0098; Wed,  7 Jan 2026 10:21:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A7C116B0095
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:21:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22ED3160426
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:21:53 +0000 (UTC)
X-FDA: 84305532906.15.A74FFA3
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4353E40003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:21:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c+w26wzo;
	spf=pass (imf11.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767799311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=av5/MRE4yF0I2OFo4G0L4h2O1Biqj9eGUDHDZYxFrTQ=;
	b=LI5wQ1VggbnqiwwIeufro7zHOj3HpwaIMbTegPt7Uaq9atrj44CqoJMEhLh7QKNLq1plko
	0Y70R4DYisMB3qVlR+s/ALBqP1PcA2enbbskcBlv0jSPtXpK83Tfr85i/QcUZ0EWBliohh
	jcqBQj5tWgyM0BeDVeaZwzWLBOmptw4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767799311; a=rsa-sha256;
	cv=none;
	b=d1Ew4zPnGWNUlZ8yaZ3y6YCS3C7NMTkkIdjQC47dAc/dXNBplg0BO/Tk0ncjDh35E5m3Y+
	wmCItTItkA/HcAjiEkJ/fJOvFuibc3IA/a8CflRQaGvcCtxmrPHGU+c3FG4I6JTWqo1hse
	9khvcGK3J51bnl3gP3hF5+fHZB2BnzU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=c+w26wzo;
	spf=pass (imf11.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a35ae38bdfso72285ad.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 07:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767799310; x=1768404110; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=av5/MRE4yF0I2OFo4G0L4h2O1Biqj9eGUDHDZYxFrTQ=;
        b=c+w26wzooO4MC4eaNz6tW+Q1PTsOW8tnRX9TehyZ6YLWZjWit518i3uGzoh2mlMfVb
         pB9hlWQt1Jf+LMbdxSAOHoi1GeyNetcYIunytsH6OAtD13AF0KZCp3ueO+QRICKR6Xkf
         sqE7tJcg9rOcr78TKcRkcDN7VWNYsaKpBtBJHG/WuLQLh0iYzy++KC/7I1uX4eGwmzn9
         oU6FvdQ1AhtZ5mE3x0/u6CW7BfCMFxQ6/AIrRQX49FIHxfsAw9Cqgy7r7vTzc+XSEd5+
         fdSkxElEAaBnQRo0sySbTn4FMErknqI/fnAeVH075yBneVEWjJoshJb1tthsOykuzMNo
         GATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767799310; x=1768404110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=av5/MRE4yF0I2OFo4G0L4h2O1Biqj9eGUDHDZYxFrTQ=;
        b=VBsULvMJMVIFTqwyuI12isgtPsvnWO6xOgp6NdKmWX8Vz4hYCiQgfd+rm9hbq585g8
         aGBwuKzGGPwtkSxSSHMkHBqZS+MicPxUrIJRBROqLfmoqINgQ21UQ2BEDiVusPvYhmhn
         7FPwWoYwg8Ko/vOlo2QQDrf4LR5t8iJK543/p3c8PZkqFPchvZ3a2AR4no5sDehz4YrO
         5JrpzqxqvFRfwFtK0h286r+Jki8SLrl7rAK3S3P99Q+GnRQI7z7XkUQT7X60FDvWcyyK
         SXwN4Uz3lkPxxMJplC/FWO+UJnVHto+1nO9517EUK7OciauowSKEsucIe0KGjymVXOvB
         yn9w==
X-Gm-Message-State: AOJu0YyNPExbzoL0Wca3gVK/f7ZhlR0OfIcJ0MQsRfgDZ1SWalAmPZb5
	Gfz4YiorGzHBaiZAvhJ5Ziygov3t/bowGcWLDcmD6EcLBFcorDmg9QvJnFFodrS4KQ==
X-Gm-Gg: AY/fxX6e8NQnuc43Bh46kuGAJYe8RtW+w/kCpUjD/ZVYWHiLOiGAaeoBktOVRAYK/yS
	jAVo/YzHNPmES4F5D3rxmKMQ2qnm1jdaudaSJgtqbndhZ7YdZPWUJ4YEV/I9VZCYphVRFH869hw
	cRTMHHIlxIALHHleUddDIXphzTvLY+FLChpH9N9JFGI08nREvF2K4vtmxgAg1R/qjL++f+E3iwp
	2B2KPj72RdesF9PCHRuaj9MZf87IAdmKE27W+q1UMkemr88FartrGpkdT5kMPomxjkrKbQv1b6b
	NxaiWSc1mE+SuNkPjY6w2LV70SRPvNQAzG9jyHR43i9PC0AmB3ASWB0/dU5VUXgzlAMkOSs8fL0
	Z1CGpG00Y2TVOj/Z0NuwFcZ0X3lwHC2vJnEebs9e2bTkIG8vPYd15l8pTtkvQYa0Sq3Vnvb4eQF
	yo4oohcJG4xSAMPCtAj8EuZXB2JK2EaUleK90BQ4llird7LgQS
X-Received: by 2002:a17:903:2c9:b0:298:45b1:6ef4 with SMTP id d9443c01a7336-2a3edbbee8fmr2891085ad.12.1767799309447;
        Wed, 07 Jan 2026 07:21:49 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c47221sm53772985ad.23.2026.01.07.07.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 07:21:48 -0800 (PST)
Date: Wed, 7 Jan 2026 15:21:41 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
	baolu.lu@linux.intel.com, rdunlap@infradead.org
Subject: Re: [PATCH v5 3/4] iommu: debug-pagealloc: Track IOMMU pages
Message-ID: <aV56BWisUQTMK2Gk@google.com>
References: <20260106162200.2223655-1-smostafa@google.com>
 <20260106162200.2223655-4-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106162200.2223655-4-smostafa@google.com>
X-Stat-Signature: 7g9nrexxe969pg9i5iipfuqbjk6qir67
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4353E40003
X-Rspam-User: 
X-HE-Tag: 1767799311-75046
X-HE-Meta: U2FsdGVkX18ORx3HVa8XZAvMTRUgyu8xUZnNT0Fcq05wbSryIUyY5DoCYAQkaSARUb5mTXJkIQLPLQEwoVPaWfl6ixJeBlCWfqJ58dKJ6YIAal+S/UvF7vSmYCERAfHUBBTeEOewbm6qYq0tiWc+fBxru6HhFzeCMjwiFvwOEnEJsOxvax4madsookMyJiy4s7nDWjabWOx/Ln8kxGzVz1r56VaX6fx2WY22h6FRw8XrzZEEJlX2flccgHEGEaVhgUXhFKjHuu+81hzOfdwlsbyIorkjzhdY06SIiBvmXcir8RBf9f1fEgkFs1FrPKrh9oeeCuK2RYFkK0mC13eqjOkrxa0njOnnQBiosXklBfCMZI1phggHRZMRNHQEMBQsSs5d2/256GF7zlS2QInAP2WZxcDUmHhVSBuAke2SlH6itLkZSYjh587RmOYlhaQuolYFARSl16avdmz7+ZgMeH9zfsybIojKhptQX8xR19OHV3jMHeK1F3Yobpq2QTKyIy8BI8l/bw2Pv4qya5KoBNPkhTCKaaha5GSxFb8x3Ps1izLjKiyysXu4McT6OqL7yU03EBaNTZ41sg79groiWx1OdXUhJ2XXa/Hkisf9e3GCsrDJpwuGAS/hwHJDFJG1SIjsvzSbWS8peItDroLrpX+g2Q5NRqwT/pTy/JduAhMW9ISfedZV5nC6ZYx/IKO3pOwYZQuZg7Kw331OxZJNcisdQDTHSGvFcalGKOTfVOpq7Snu1yg6SuycZSSoPMEeMDZVIM8qBJwRv8qqHkMpH6TDjMM6E8f2jUq1FTyxWH6/+GwjKGqnuDwIsO6zcidroMO2L4tKBqmjhryV8nZh7Lp7zsGboZlkva+7cQv8EBtPQY/8PmSodXUpUQYF0p+MmmrsFpM0UxPpfwE07vNS2bEmsx+yJgqeZCx+g/SvAVgKb9mmQK6nS4bB13qKMQr8UGkF0K5qCN5xZhy07hA
 iw/sqJ8W
 RkJrV+wMOBNiCthUGLJm7/u0JzebnlRJ0BzcTRBI4+mmXQ5rxmhqhwzJekiuam7T96OfxW7JZQ1hmCAByYNyGuW2J3htVY9puAzPg4tknFEOVQ0j7p0fTcqG7ipqJoT3WJpOfr3dT/Pig2dZUv+6U2ZYJfgw1o8yNRkkW80xxEcDxCb/+qgdV62exYo9gfSHvTZg/dwLg9weipEY6PIanO7xfz9o/Y6zUZThjN3DYvZ6xHxeLzkgpzy/zdCO2/VZy/UuKM9U3sR6x/7GzECOrNicyZV6ctw7G/Vnnyc/tahl51drrCMgcg6lflGms+yOfGGRHpR6JjOd4QggdtuZbbUcM8KGA0vxcyN8byc9CC9eHQwXfhi92e+Ak89O2Lz2QSeAiCxpBDhPGSrp4mGDHJO2SH7ODZNE8TY7c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 04:21:59PM +0000, Mostafa Saleh wrote:
> Using the new calls, use an atomic refcount to track how many times
> a page is mapped in any of the IOMMUs.
> 
> For unmap we need to use iova_to_phys() to get the physical address
> of the pages.
> 
> We use the smallest supported page size as the granularity of tracking
> per domain.
> This is important as it is possible to map pages and unmap them with
> larger sizes (as in map_sg()) cases.
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/iommu/iommu-debug-pagealloc.c | 91 +++++++++++++++++++++++++++
>  1 file changed, 91 insertions(+)
> 
> diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> index 1d343421da98..86ccb310a4a8 100644
> --- a/drivers/iommu/iommu-debug-pagealloc.c
> +++ b/drivers/iommu/iommu-debug-pagealloc.c
> @@ -29,19 +29,110 @@ struct page_ext_operations page_iommu_debug_ops = {
>  	.need = need_iommu_debug,
>  };
>  
> +static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
> +{
> +	struct page *page = phys_to_page(phys);
> +	struct page_ext *page_ext = page_ext_get(page);
> +
> +	return page_ext;
> +}
> +
> +static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page_ext)
> +{
> +	return page_ext_data(page_ext, &page_iommu_debug_ops);
> +}
> +
> +static void iommu_debug_inc_page(phys_addr_t phys)
> +{
> +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> +	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
> +
> +	WARN_ON(atomic_inc_return_relaxed(&d->ref) <= 0);
> +	page_ext_put(page_ext);
> +}
> +
> +static void iommu_debug_dec_page(phys_addr_t phys)
> +{
> +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> +	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
> +
> +	WARN_ON(atomic_dec_return_relaxed(&d->ref) < 0);
> +	page_ext_put(page_ext);
> +}
> +
> +/*
> + * IOMMU page size doesn't have to match the CPU page size. So, we use
> + * the smallest IOMMU page size to refcount the pages in the vmemmap.
> + * That is important as both map and unmap has to use the same page size
> + * to update the refcount to avoid double counting the same page.
> + * And as we can't know from iommu_unmap() what was the original page size
> + * used for map, we just use the minimum supported one for both.
> + */
> +static size_t iommu_debug_page_size(struct iommu_domain *domain)
> +{
> +	return 1UL << __ffs(domain->pgsize_bitmap);
> +}
> +
>  void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
>  {
> +	size_t off, end;
> +	size_t page_size = iommu_debug_page_size(domain);
> +
> +	if (WARN_ON(!phys || check_add_overflow(phys, size, &end)))
> +		return;
> +
> +	for (off = 0 ; off < size ; off += page_size) {
> +		if (!pfn_valid(__phys_to_pfn(phys + off)))
> +			continue;
> +		iommu_debug_inc_page(phys + off);
> +	}
> +}
> +
> +static void __iommu_debug_update_iova(struct iommu_domain *domain,
> +				      unsigned long iova, size_t size, bool inc)
> +{
> +	size_t off, end;
> +	size_t page_size = iommu_debug_page_size(domain);
> +
> +	if (WARN_ON(check_add_overflow(iova, size, &end)))
> +		return;
> +
> +	for (off = 0 ; off < size ; off += page_size) {
> +		phys_addr_t phys = iommu_iova_to_phys(domain, iova + off);
> +
> +		if (!phys || !pfn_valid(__phys_to_pfn(phys)))
> +			continue;
> +
> +		if (inc)
> +			iommu_debug_inc_page(phys);
> +		else
> +			iommu_debug_dec_page(phys);
> +	}

This might loop for too long when we're unmapping a big buffer (say 1GB)
which is backed by multiple 4K mappings (i.e. not mapped using large
mappings) it may hold the CPU for too long, per the above example:

1,073,741,824 / 4096 = 262,144 iterations each with an iova_to_phys walk
in a tight loop, could hold the CPU for a little too long and could
potentially result in soft lockups (painful to see in a debug kernel).
Since, iommu_unmap can be called in atomic contexts (i.e. interrupts,
spinlocks with pre-emption disabled) we cannot simply add cond_resched()
here as well.

Maybe we can cross that bridge once we get there, but if we can't solve
the latency now, it'd be nice to explicitly document this risk
(potential soft lockups on large unmaps) in the Kconfig or cmdline help text?

>  }
>  
>  void __iommu_debug_unmap_begin(struct iommu_domain *domain,
>  			       unsigned long iova, size_t size)
>  {
> +	__iommu_debug_update_iova(domain, iova, size, false);
>  }
>  
>  void __iommu_debug_unmap_end(struct iommu_domain *domain,
>  			     unsigned long iova, size_t size,
>  			     size_t unmapped)
>  {
> +	if (unmapped == size)
> +		return;
> +
> +	/*
> +	 * If unmap failed, re-increment the refcount, but if it unmapped
> +	 * larger size, decrement the extra part.
> +	 */
> +	if (unmapped < size)
> +		__iommu_debug_update_iova(domain, iova + unmapped,
> +					  size - unmapped, true);
> +	else
> +		__iommu_debug_update_iova(domain, iova + size,
> +					  unmapped - size, false);
>  }

I'm a little concerned about this part, when we unmap more than requested,
the __iommu_debug_update_iova relies on 
iommu_iova_to_phys(domain, iova + off) to find the physical page to
decrement. However, since __iommu_debug_unmap_end is called *after* the
IOMMU driver has removed the mapping (in __iommu_unmap). Thus, the
iommu_iova_to_phys return 0 (fail) causing the loop in update_iova:
`if (!phys ...)` to silently continue.

Since the refcounts for the physical pages in the range:
[iova + size, iova + unmapped] are never decremented. Won't this result
in false positives (warnings about page leaks) when those pages are
eventually freed?

For example:

- A driver maps a 2MB region (512 x 4KB). All 512 pgs have refcount = 1.

- A driver / IOMMU-client calls iommu_unmap(iova, 4KB)

- unmap_begin(4KB) calls iova_to_phys, succeeds, and decrements the
  refcount for the 1st page to 0.

- __iommu_unmap calls the IOMMU driver. The driver (unable to split the
  block) zaps the entire 2MB range and returns unmapped = 2MB.

- unmap_end(size=4KB, unmapped=2MB) sees that more was unmapped than
  requested & attempts to decrement refcounts for the remaining 511 pgs

- __iommu_debug_update_iova is called for the remaining range, which
  ends up calling iommu_iova_to_phys. Since the mapping was destroyed,
  iova_to_phys returns 0.

- The loop skips the decrement causing the remaining 511 pages to leak
  with refcount = 1.

Thanks,
Praan

