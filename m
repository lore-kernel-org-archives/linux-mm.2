Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE4FD185C6
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 11:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60F306B0092; Thu,  8 Jan 2026 06:06:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592676B0093; Thu,  8 Jan 2026 06:06:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4757C6B0095; Thu,  8 Jan 2026 06:06:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 354D06B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:06:44 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BED9D59FE6
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:06:43 +0000 (UTC)
X-FDA: 84308518686.05.67ACB18
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id DC7C44000E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:06:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wnyS3lbn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of smostafa@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767870402; a=rsa-sha256;
	cv=none;
	b=we+Oes55HDHAFyqOp2ouNHYYzliZiu0csVOWLnkA2xQnuSxe68PmXrHRp/A5rih+B3lW5r
	TRVE/cxyJ0BZ7+SM7zi6mR7qTaxdBXYxqgFzIrsGnDvl/UWx+ZKyeFlnDbONnTe2rfn0Z7
	395R6XhNdsG3bqMEFNs9e2oVd+Lk04s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wnyS3lbn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of smostafa@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=smostafa@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767870402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRRthK53UX6LOkjCTrjT1p312kfkJFJyixNlmbYAffA=;
	b=GjctlwhVxd7JWolq5yEV0sufB9rDEbqBAZs/Sf6pn8wtpu5iY58tUlRaUXBcSXN9LWBvCa
	JxxPZR53nj0kt+t1kxlCQ/TmrwXCEqkw1v0M/nMj8XrerNC3qnP+s9xjvbjnaJJy/En7kO
	S/DCrvG/9XJn/KebVxQ1w4EnieneoPE=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so129635e9.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 03:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767870400; x=1768475200; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bRRthK53UX6LOkjCTrjT1p312kfkJFJyixNlmbYAffA=;
        b=wnyS3lbnnTskLgHgmKXXWwCKFWZnDeSWpWKv89XiILcvflDTvwcmY0DPm37lKWcwq5
         YqOGq/H+oLVVbfsi0wcPVehfU8tPvuYCnnygF5FCEC10O5gUZABc0fWXKzNnhcLYgycC
         2K947kjECxPQNGvs4FEac/ZksYfqaF02V2tp9REVx4TMOF31D/VnDn5851Vm2NArkBmB
         Zdq8fumpaBtW5m5TckoMKQul5bs430ad9rdihBHbJZVLIzYlUJ8/WQfQyCYtDUESiFJL
         9HbfY84JHC/TTnJL03Uhrg3i9AkSrTwvozR+jkHIWlvHoUhdFkPV09t19Op0rBGEjR9q
         c+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767870400; x=1768475200;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bRRthK53UX6LOkjCTrjT1p312kfkJFJyixNlmbYAffA=;
        b=wb9trmsN88xNi5ChujERSuaU25SeStRB4WF67C0TBSuKr2AbBnI65L5e7WjMn2ItzN
         vjGeynSFGwtWp8XAOW4Po3NiZVzyiqYKLJ1hcy36V5L8Wdj2CWW9GjYI0Ngk7eAmQmTu
         bmqVr7wPFXxw6vIP79ceyKdWBYMGutAVO7h1XgbplcJ/n9DTsLFCIFiBryQ3DBT7N6hU
         ljsJDkh4Lv3rVIKj9F8tcOqZmTd+IgBbzZVtpyc8ST+Ftuqo6fADXC27RHCeGS5DKKfF
         OzX9dsK4CN214NbLpWRJQmfMRatjrKCW+413IdxDIRoqkepG1+ZdvfWz5+Ok0V6TMazm
         wROA==
X-Gm-Message-State: AOJu0YyHZlJ0fCPFSIsQnKMH35gD3liinUZj72vAFx94Q05lOxheNVyQ
	xlirpRsPa1yQOjVFhme0SJ05eXmfO+PUukKAg3qtDzJcMDveIwS3uDfVf9KRqVoZpMtiKcLqcPQ
	HmHHIEA==
X-Gm-Gg: AY/fxX5VaiCeKv/mUaPQYQTiextjhcs0Q6Azxn2x7pUhcwLgaLb7I8NAiwNZ13Xbond
	rBG2WvtyCubaOkb2XDStcbOcAAp7Hzu42ouRb2dlKY7IPzmCpi6pKSsl+iZwW2pdBFjifMQuyTA
	W7sa/42SyHCfcRVRUYq51OV/FbFq3djPSipeHslKxTjh8ssmJwLrLQtgtFhAWRNjSBErPcDYVb9
	1hcR5EPOImz93Xsmy/T/I14iWtJsT/7KoIo1t6S2CJrfexWyt8AuqiHUTfe+Ax4HPfTRqDLYIOg
	2sa6W6Xq1h6CPLMG5lkBsqh2VUx6hKGLhr/YU+mZ7+frkaIIeFa4QOuq1NmB93uxeQn3z9MTxHm
	G2MuZy9aM7mkbWy1UGVc+n+29x3KK5tr+Rp2UwBxZhYQDMlfE1hmRpdWeQu3GSev3NaZAMUkAFD
	m/DekmNPqK79OFQ+ViTeZO1z7kFg/YqdVI774paonc/2VT3bGDtHienF+bts1jiVM=
X-Received: by 2002:a7b:c003:0:b0:477:95a8:2563 with SMTP id 5b1f17b1804b1-47d8ac3e453mr325285e9.14.1767870400033;
        Thu, 08 Jan 2026 03:06:40 -0800 (PST)
Received: from google.com (171.85.155.104.bc.googleusercontent.com. [104.155.85.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5df9afsm17122474f8f.24.2026.01.08.03.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 03:06:39 -0800 (PST)
Date: Thu, 8 Jan 2026 11:06:36 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
	baolu.lu@linux.intel.com, rdunlap@infradead.org
Subject: Re: [PATCH v5 3/4] iommu: debug-pagealloc: Track IOMMU pages
Message-ID: <aV-PvBqQ0Ktiha8e@google.com>
References: <20260106162200.2223655-1-smostafa@google.com>
 <20260106162200.2223655-4-smostafa@google.com>
 <aV56BWisUQTMK2Gk@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aV56BWisUQTMK2Gk@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DC7C44000E
X-Stat-Signature: 3zojj5ds66gyo1c7m8oxa61yoxacsb1o
X-HE-Tag: 1767870401-290707
X-HE-Meta: U2FsdGVkX182AqcfNdBO+xAXvl6gPwfjWUjCM9gl0QlwAFtieScCZYCIvQ3CFhmJVNZDcmmNN2LaeSQ0FvmnpPtB1XQ+lu1njnWKqYDDqaBH9/bduNpyCQ7Dnwgr0SrfU49UVFwMoCE4IElYzw+covyGk4yk/dd/R0YwIn3u36WYsaSS6678+fZawJP7mc/6wNbY3bq6wtwetoULfFrEwpNTh/+3MJyrGO4kzJqkpMNXBnu5A9hkSv6/r/SOBHRVyJZYeNzQlSMRrYxiWkDoJLWyaasucW410L6N2UpeddWSHsrTU3bHQssGcOJiKEWv1LTgsyK09No/aJbF74o16lyt8o08V0Rbnb4GPM8IZwtuwWE2IimSgS+JXg7xIH0g85vtBEBcl4dWkYUrA2WpHPr+F7Cu8xTQg6lEjh8C8X/u2t2sOoXHqlc543PDUepO1po/bEgFLFby8xqX+nG0UkLScJJRNNuXxaTn9zisOyf9l9yBbpNOkhcFaCpJw+qHOhiUIBRSKg4/EQzewj9Ko2SL+40LLJvP0bbjwVEFNDIBxI06GDSqzvVtOdac/YkhhROy1b/Zl6zTCjAkE0sZAd5ohigcfgXQRouSaGOQz9ZzFYn6nYug3+EPqGlETPwlZYFvqjea0sW9NRE973Tn7n14WPdUjc3zZyDzYDNBIUhH5VyniiAvsSVscIq7RdAjV76lpccUZdSXd1GZTQQ70nQYTk9SzZpLwCwTYDLGOeY0hPjh4NoAc6hZBF3BwiDHzeZS6/n6jJ8G4LFDK4OyLnSB4ruxVTCyXT2NleM/iO57r72L9FO67b2O5gBKcKUckdtc6K7Yeo7qY1wel7P1c5XMVTHo88C5ooErngPwLQgZ6VTITnKBvS1QOQRYspo5m0MY4BYfWNwYjGpjSwkOGhkU6NvBdjP7NonHw6zoBrOz6NCtXPOokcnr32ZL+qT4120vXdaI00yT30+HohK
 gAtxFlvc
 B+X+xsnIY5dswFJ/hIqZxmuAj48A/i9Pq4FWhdo0cKFwKIRNHteThndyOC4+Fo/aIlQL9XanAmn0bQNttehTeuY5vsi1tfeRhMJ8dyamfF0v0fidQv8WAu89A9EWwdveQera/a4hAbyh94GxdSrbqQ25dT2OphfvaUfWFBhyQJ//gpFgPCBf3VYGbr2CgphtJv2TehKBLKnRkYTu925bb1DCp5Ts/VqvR3CSTgg8T6QcwCMsyOZClHAmDJHsdKHZfYGIfLRsaoXU6ynyhnX50nY9jtbSnuMl3UjmVGcxYTDUIPXMdTnnuVpLWvhox6EXaAVNMQTysffys2FqGMb61pROyjll5rJxVXzRYmLJ/QOTeCWDoAodqGekV+ZGIitKvazPcw9tppIUOCNkX+NHra9WqV+IzMA3D28z31GQvA1r4s1A7pARyt2+f5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 03:21:41PM +0000, Pranjal Shrivastava wrote:
> On Tue, Jan 06, 2026 at 04:21:59PM +0000, Mostafa Saleh wrote:
> > Using the new calls, use an atomic refcount to track how many times
> > a page is mapped in any of the IOMMUs.
> > 
> > For unmap we need to use iova_to_phys() to get the physical address
> > of the pages.
> > 
> > We use the smallest supported page size as the granularity of tracking
> > per domain.
> > This is important as it is possible to map pages and unmap them with
> > larger sizes (as in map_sg()) cases.
> > 
> > Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >  drivers/iommu/iommu-debug-pagealloc.c | 91 +++++++++++++++++++++++++++
> >  1 file changed, 91 insertions(+)
> > 
> > diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> > index 1d343421da98..86ccb310a4a8 100644
> > --- a/drivers/iommu/iommu-debug-pagealloc.c
> > +++ b/drivers/iommu/iommu-debug-pagealloc.c
> > @@ -29,19 +29,110 @@ struct page_ext_operations page_iommu_debug_ops = {
> >  	.need = need_iommu_debug,
> >  };
> >  
> > +static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
> > +{
> > +	struct page *page = phys_to_page(phys);
> > +	struct page_ext *page_ext = page_ext_get(page);
> > +
> > +	return page_ext;
> > +}
> > +
> > +static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page_ext)
> > +{
> > +	return page_ext_data(page_ext, &page_iommu_debug_ops);
> > +}
> > +
> > +static void iommu_debug_inc_page(phys_addr_t phys)
> > +{
> > +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> > +	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
> > +
> > +	WARN_ON(atomic_inc_return_relaxed(&d->ref) <= 0);
> > +	page_ext_put(page_ext);
> > +}
> > +
> > +static void iommu_debug_dec_page(phys_addr_t phys)
> > +{
> > +	struct page_ext *page_ext = get_iommu_page_ext(phys);
> > +	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
> > +
> > +	WARN_ON(atomic_dec_return_relaxed(&d->ref) < 0);
> > +	page_ext_put(page_ext);
> > +}
> > +
> > +/*
> > + * IOMMU page size doesn't have to match the CPU page size. So, we use
> > + * the smallest IOMMU page size to refcount the pages in the vmemmap.
> > + * That is important as both map and unmap has to use the same page size
> > + * to update the refcount to avoid double counting the same page.
> > + * And as we can't know from iommu_unmap() what was the original page size
> > + * used for map, we just use the minimum supported one for both.
> > + */
> > +static size_t iommu_debug_page_size(struct iommu_domain *domain)
> > +{
> > +	return 1UL << __ffs(domain->pgsize_bitmap);
> > +}
> > +
> >  void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
> >  {
> > +	size_t off, end;
> > +	size_t page_size = iommu_debug_page_size(domain);
> > +
> > +	if (WARN_ON(!phys || check_add_overflow(phys, size, &end)))
> > +		return;
> > +
> > +	for (off = 0 ; off < size ; off += page_size) {
> > +		if (!pfn_valid(__phys_to_pfn(phys + off)))
> > +			continue;
> > +		iommu_debug_inc_page(phys + off);
> > +	}
> > +}
> > +
> > +static void __iommu_debug_update_iova(struct iommu_domain *domain,
> > +				      unsigned long iova, size_t size, bool inc)
> > +{
> > +	size_t off, end;
> > +	size_t page_size = iommu_debug_page_size(domain);
> > +
> > +	if (WARN_ON(check_add_overflow(iova, size, &end)))
> > +		return;
> > +
> > +	for (off = 0 ; off < size ; off += page_size) {
> > +		phys_addr_t phys = iommu_iova_to_phys(domain, iova + off);
> > +
> > +		if (!phys || !pfn_valid(__phys_to_pfn(phys)))
> > +			continue;
> > +
> > +		if (inc)
> > +			iommu_debug_inc_page(phys);
> > +		else
> > +			iommu_debug_dec_page(phys);
> > +	}
> 
> This might loop for too long when we're unmapping a big buffer (say 1GB)
> which is backed by multiple 4K mappings (i.e. not mapped using large
> mappings) it may hold the CPU for too long, per the above example:
> 
> 1,073,741,824 / 4096 = 262,144 iterations each with an iova_to_phys walk
> in a tight loop, could hold the CPU for a little too long and could
> potentially result in soft lockups (painful to see in a debug kernel).
> Since, iommu_unmap can be called in atomic contexts (i.e. interrupts,
> spinlocks with pre-emption disabled) we cannot simply add cond_resched()
> here as well.
> 
> Maybe we can cross that bridge once we get there, but if we can't solve
> the latency now, it'd be nice to explicitly document this risk
> (potential soft lockups on large unmaps) in the Kconfig or cmdline help text?
> 

Yes, I am not sure how bad that would be, looking at the code, the closest
pattern I see in that path is for SWIOTLB, when it’s enabled it will do a
lot of per-page operations on unmap.
There is a disclaimer already in dmesg and the Kconfig about the performance
overhead, and you would need to enable a config + cmdline to get this, so
I’d expect someone enabling it to have some expectations of what they are
doing. But I can add more info to Kconfig if that makes sense.

> >  }
> >  
> >  void __iommu_debug_unmap_begin(struct iommu_domain *domain,
> >  			       unsigned long iova, size_t size)
> >  {
> > +	__iommu_debug_update_iova(domain, iova, size, false);
> >  }
> >  
> >  void __iommu_debug_unmap_end(struct iommu_domain *domain,
> >  			     unsigned long iova, size_t size,
> >  			     size_t unmapped)
> >  {
> > +	if (unmapped == size)
> > +		return;
> > +
> > +	/*
> > +	 * If unmap failed, re-increment the refcount, but if it unmapped
> > +	 * larger size, decrement the extra part.
> > +	 */
> > +	if (unmapped < size)
> > +		__iommu_debug_update_iova(domain, iova + unmapped,
> > +					  size - unmapped, true);
> > +	else
> > +		__iommu_debug_update_iova(domain, iova + size,
> > +					  unmapped - size, false);
> >  }
> 
> I'm a little concerned about this part, when we unmap more than requested,
> the __iommu_debug_update_iova relies on 
> iommu_iova_to_phys(domain, iova + off) to find the physical page to
> decrement. However, since __iommu_debug_unmap_end is called *after* the
> IOMMU driver has removed the mapping (in __iommu_unmap). Thus, the
> iommu_iova_to_phys return 0 (fail) causing the loop in update_iova:
> `if (!phys ...)` to silently continue.
> 
> Since the refcounts for the physical pages in the range:
> [iova + size, iova + unmapped] are never decremented. Won't this result
> in false positives (warnings about page leaks) when those pages are
> eventually freed?
> 
> For example:
> 
> - A driver maps a 2MB region (512 x 4KB). All 512 pgs have refcount = 1.
> 
> - A driver / IOMMU-client calls iommu_unmap(iova, 4KB)
> 
> - unmap_begin(4KB) calls iova_to_phys, succeeds, and decrements the
>   refcount for the 1st page to 0.
> 
> - __iommu_unmap calls the IOMMU driver. The driver (unable to split the
>   block) zaps the entire 2MB range and returns unmapped = 2MB.
> 
> - unmap_end(size=4KB, unmapped=2MB) sees that more was unmapped than
>   requested & attempts to decrement refcounts for the remaining 511 pgs
> 
> - __iommu_debug_update_iova is called for the remaining range, which
>   ends up calling iommu_iova_to_phys. Since the mapping was destroyed,
>   iova_to_phys returns 0.
> 
> - The loop skips the decrement causing the remaining 511 pages to leak
>   with refcount = 1.
> 

Agh, yes, iova_to_phys will always return zero, so the
__iommu_debug_update_iova() will do nothing in that case.

I am not aware which drivers are doing this, I added this logic
because I saw the IOMMU core allow it. I vaguely remember that
had something about splitting blocks which might be related to VFIO,
but I don't think that is needed anymore.

I am happy just to drop it or even preemptively warn in that case, as
it is impossible to retrieve the old addresses.

And maybe, that's a chance to re-evaluate we allow this behviour.

Thanks,
Mostafa

> Thanks,
> Praan

