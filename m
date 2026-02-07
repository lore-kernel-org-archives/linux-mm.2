Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3177EE0AF1
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 20:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED946B008A; Sat,  7 Feb 2026 15:19:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29BCB6B0092; Sat,  7 Feb 2026 15:19:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7526B0093; Sat,  7 Feb 2026 15:19:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09ADD6B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 15:19:40 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9567DB9351
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 20:19:39 +0000 (UTC)
X-FDA: 84418776078.13.CF6D6A5
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id A1F6580005
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 20:19:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=beMN1+tU;
	spf=pass (imf30.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770495577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LmE23qjtgb2EulsiY+c7A9BQzukrzPbX/0RgHfT6JCg=;
	b=YV0EOp1ymvsUTzvHf9DY+T0bmm4UA18xXHEF0rFvmm5K9Ipev4czvQlZSuWqTue0cPtan2
	s4xJz1gthkhv02Zjvkj5BfclfYF/0qW3O/tf8UuaP13NhJXNG/AESuz9y7jWDn7wP5NEF4
	DefWzKjl0XpzbX6ScCzTqs7gOXm9nlI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770495577; a=rsa-sha256;
	cv=none;
	b=gRCd1PZa7FzLYOPGCahkA05k2l1IVeF1diNw3VJFIgFQbuZwFkPlpyGhEAqnejvz04D5r3
	3fx2X7DavnOMjIivGxn5aM+pbGHPPPH/GsI0WmV+Gml+FAfBoXotA3VRUzavSDAmdigPes
	bfmWrkXm7Qm7nnR2u10ydTgDXhLNDTo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=beMN1+tU;
	spf=pass (imf30.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4806cc07ce7so33138475e9.1
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 12:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770495576; x=1771100376; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LmE23qjtgb2EulsiY+c7A9BQzukrzPbX/0RgHfT6JCg=;
        b=beMN1+tUdw0weZ7wONs1EmGJboQOKnXfEEwayeUhMtw/CK0CcBZ+amSH85JFvWQMN+
         sGfxTJv+HycJg7aIKShSQSsQlEqcq+r2c9HedTkovGiPkNQSLv+trApXro5JEMqQQxth
         zDUUEACMCn9hXkkQUsR9tsV1/520Q2Ay+FWrQPGrVHPcZHx2ud/RicK1a04kKPY/XgTY
         lfaQ5MMGm15uGceIickMg82U7GPeGHba570r4Z/dT2PUBbIiKkOq3tz0cobJ5ooGqr9N
         dFRgka/PackM9TxB+mD+g/rXpI2lp65+MXsXfWpEUuc010SwulldGKc4PAqYbq0gPiR9
         TBaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770495576; x=1771100376;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LmE23qjtgb2EulsiY+c7A9BQzukrzPbX/0RgHfT6JCg=;
        b=oanMrtWdeU7XdocO7/P6ERPF6/BLnIxlSAeT1q2s5m8T/XDLqnTEiazrFWHnFO10vB
         VMN5KMVJT0MirywiP0co+2u+j1taQZDDaRQqR1sO96iSHLo94yi71vOZvXyviazb8/re
         k+Q1pCuW2kQuCdCn/IOQ8kmGlaXFOuqHRF1Ah1Kay05XJ8hbshQLPc1Z9Ju1k/AbLklE
         g5+5OvnZ3HrHzQH5s7bRsREpRwTBuTgTil4Nqo42QqYAS9yxE6rfRaacaCCSbxBLCQAZ
         fqU9pofuGxyLisaM1I/ElmXZtBn7z0XeL+yCN4soD20bhu4nGELkXyKvakIYJNTIKo+9
         sqaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVe3VgVnbrNIyRdxKMis2OjlQPHQIjiwRjIk19Ou0sjB8xTZGNPKc25IqX2Alngyu4eEhPVcJfaGA==@kvack.org
X-Gm-Message-State: AOJu0YyvyDPD1BaL4iBqaegYb6S2PJClOCNRB3GtOwFDkiNwvpuERd7o
	qY/yt2kD7ELMBcBcce2f8UyblVEy8s6plrSdirGGpuHm6PZh18I7dmsC
X-Gm-Gg: AZuq6aJeY0yYCDeiIuqpaqrgZP0rna9sqcnDP1X4g7kHhjvx9c8p8BuQEDKD1g8H6a3
	WQhoxw+nGzLuaYzPWbqR3IOCDm4+vsxXLa5RvMol1YCg4G0DoXzLR0eSaTP2m+gr3pwFBQ7CSIO
	rLuBnxfPwOv0yc4Rit0pvi2jZenYfoOxf1G/7TyqeaRE28STS5ltXQKl/W/uaAfuN046Bt+xQfg
	Zn0DH6IX8qe82pzDklXeHK5siTMJYy1MXWftdRYxtnrSBi2uVtNVBDlRMi1ZncVdau0h8YOhyDt
	TjZxREz7T1DtRQv8DWSFvAqwikPXg3RVO2A2GKEXaigq5nELPmlj+zsjZvckjrwQaj/lNR24F1N
	15EI8feYEhy8dFoXAzHPOy/Vkqip8FqT14CK6zgMa6Qrkyt5gcNeOCcX9kXdLXP5eNEsRmenwqP
	zqTTDvKMPY78G5/gEB8sKGz2DTjROqTLeg4AUJDzS0PDs+VIn0KBC/vHOcp/mJ04W6Dm2VELdiE
	3cdEiNtRsn+lxI=
X-Received: by 2002:a05:600c:4f8a:b0:480:3230:6c9b with SMTP id 5b1f17b1804b1-483201dd004mr94651865e9.7.1770495575929;
        Sat, 07 Feb 2026 12:19:35 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e752:9400:18cf:c773:ee86:c436? ([2a02:6b6f:e752:9400:18cf:c773:ee86:c436])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483206cc7d3sm131304355e9.5.2026.02.07.12.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Feb 2026 12:19:34 -0800 (PST)
Message-ID: <fd80736b-7b2a-4675-82a7-1902705c6361@gmail.com>
Date: Sat, 7 Feb 2026 20:19:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 07/17] mm: Rework compound_head() for power-of-2
 sizeof(struct page)
Content-Language: en-GB
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-8-kas@kernel.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20260202155634.650837-8-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A1F6580005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5samyf7nmqwjacekit1yedy6a1f4yhmm
X-HE-Tag: 1770495577-957460
X-HE-Meta: U2FsdGVkX187mOHj1pUfWJT9DUuI6/Y1moOX5FnHjhQ8NZs1NL48CtZ4zYUgpTrfqCzIjTa2FNOwqDJZzMibrpmZj0H/QBGWsNnb218MwBJcFZJ1fuqlpX65TFC87E7ZEKpQQEnUMX8Istboa84I4AMI4bXJqjHXSIpixnh3tt1GVqEmiQRyPes9+3G0KqDJ38uQObGrAE8dYkqbsp+maNda4TJ6+DrmEJI6kDBmM4BLCfh1IvDwEYCUC4mmEWAhlBqPtsCygayiehXfaFENEhkq+MLnm8AcypHKTjUWQb4wD7OPz72MhVqYH9RcWljuhEQiGfX9MGFkX432v5uprsOeObfebGHt/I3XHmDGt/fynapqp3FAkBqzTumqvCKCxmYRxxkbrWBYLcezdS3Q3nNY7/l3oz1aaLW8+uMwimh8JQLj/x+ALDxGzCqkVNGf5f6gc+zxnpk5+a4Pe3jVnKiwqxFOPeBkhf9+wq3+NOHUuQXIfyko3S8VfOs2oyiL2M3RbmvVOPEiMZCYh3RW5I0N01BvuZZk/xPeM6+d5eIcicuc1Yq8elOAmViFBMtWOO4g4GjMirpdqWveMWUwI1EpaUsKzt7SX54d/ckTqDXwILqth/oXbCCF/kE3Dy6LoLTivskJ/ywgtUdnZ8oTxPE7sRMJYhkdlM1Yk7KcEKioxlClui4crOlaBwvLnQTx0TOFUJY2EYDxosMNlOxca9gsP0xQhJWmIv0rQfIoRx+2LRajppbV0NxIX+CohUX4oKRqECRT0w2ibtLaWCqEdxFq20xIR8fkcl9OqMMZJFySps3T3H6vKLgMK1bqURVgi6FA3APwUWfKQ0Ptpnf/xQ0uIB456QP1nsNMw1vjlalwWvRsTK3h2/JhD/QdWgIL/EHc3qaFIcwKuiVRJDY96bTUrN4zwBG68tZ6pmcZ7n5TSAtAd87C8JG5FKPZ2kLu9GVV2FIfs7F+1pcqdi/
 AlGzp7D6
 7iyWDJDVZUU6G9b+Ozo08A17yR6PxvdkoDBirzns9LeOiero3xql2rO41JkhhIo/5TSTmmY62OjcnlONLgd9XChN53tX0WffXbvZaIL7YPPLb0eonVW9XDgVZkuNtUOzrbiwDHdqAwmQsHw+EPeyQeTji/uUj1F/ueGTv57jz0BlopK8+LFVLbqpY0rOX9v9PuJTDxNB475qmyAV7wT5lClIdowermfuGY5d7N3ypQyhHsTuJfCWZLQLvtPo92ktMESiMnYLAo+/2OlVFf7U8NMmiDou6VFOTY+49JtgwyY2U5GwTBgMhgXyN7jJupaimoDvaQin6XN/KEoejiK4fAxv/J9U8B36pT96GUnPybvKOEiXa0YX/4B2Sk4LoYuoa7v2mHyhoLGE4kaBCOr5KYZoArdfv0fNuT55JXYIi+TiPslElYWlqHGo1IggShDUesIlwz+U5KHWqUjKZi4oXP8GEXFKI0erfIcTVs9KrUFBoanjjAGOD+B5+i3pf6qtmGu6Hs8Mg09mDAz1jzcPJ0zoTBXerzqXLBRs4Vc38fHAsYudQKxGE6SfVkd1LkmNsR6ABIIB+KRwridC/9jqgXSUo0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/02/2026 15:56, Kiryl Shutsemau wrote:
> For tail pages, the kernel uses the 'compound_info' field to get to the
> head page. The bit 0 of the field indicates whether the page is a
> tail page, and if set, the remaining bits represent a pointer to the
> head page.
> 
> For cases when size of struct page is power-of-2, change the encoding of
> compound_info to store a mask that can be applied to the virtual address
> of the tail page in order to access the head page. It is possible
> because struct page of the head page is naturally aligned with regards
> to order of the page.
> 
> The significant impact of this modification is that all tail pages of
> the same order will now have identical 'compound_info', regardless of
> the compound page they are associated with. This paves the way for
> eliminating fake heads.
> 
> The HugeTLB Vmemmap Optimization (HVO) creates fake heads and it is only
> applied when the sizeof(struct page) is power-of-2. Having identical
> tail pages allows the same page to be mapped into the vmemmap of all
> pages, maintaining memory savings without fake heads.
> 
> If sizeof(struct page) is not power-of-2, there is no functional
> changes.
> 
> Limit mask usage to HugeTLB vmemmap optimization (HVO) where it makes
> a difference. The approach with mask would work in the wider set of
> conditions, but it requires validating that struct pages are naturally
> aligned for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> ---

Acked-by: Usama Arif <usamaarif642@gmail.com>

Small nit below:

>  include/linux/page-flags.h | 81 ++++++++++++++++++++++++++++++++++----
>  mm/slab.h                  | 16 ++++++--
>  mm/util.c                  | 16 ++++++--
>  3 files changed, 97 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index d14a17ffb55b..8f2c7fbc739b 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -198,6 +198,29 @@ enum pageflags {
>  
>  #ifndef __GENERATING_BOUNDS_H
>  
> +/*
> + * For tail pages, if the size of struct page is power-of-2 ->compound_info
> + * encodes the mask that converts the address of the tail page address to
> + * the head page address.
> + *
> + * Otherwise, ->compound_info has direct pointer to head pages.
> + */
> +static __always_inline bool compound_info_has_mask(void)
> +{
> +	/*
> +	 * Limit mask usage to HugeTLB vmemmap optimization (HVO) where it
> +	 * makes a difference.
> +	 *
> +	 * The approach with mask would work in the wider set of conditions,
> +	 * but it requires validating that struct pages are naturally aligned
> +	 * for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
> +	 */
> +	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
> +		return false;
> +
> +	return is_power_of_2(sizeof(struct page));
> +}
> +
>  #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>  DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
>  
> @@ -210,6 +233,10 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
>  	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
>  		return page;
>  
> +	/* Fake heads only exists if compound_info_has_mask() is true */
> +	if (!compound_info_has_mask())
> +		return page;
> +
>  	/*
>  	 * Only addresses aligned with PAGE_SIZE of struct page may be fake head
>  	 * struct page. The alignment check aims to avoid access the fields (
> @@ -223,10 +250,14 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
>  		 * because the @page is a compound page composed with at least
>  		 * two contiguous pages.
>  		 */
> -		unsigned long head = READ_ONCE(page[1].compound_info);
> +		unsigned long info = READ_ONCE(page[1].compound_info);
>  
> -		if (likely(head & 1))
> -			return (const struct page *)(head - 1);
> +		/* See set_compound_head() */
> +		if (likely(info & 1)) {
> +			unsigned long p = (unsigned long)page;
> +
> +			return (const struct page *)(p & info);
> +		}
>  	}
>  	return page;
>  }
> @@ -281,11 +312,26 @@ static __always_inline int page_is_fake_head(const struct page *page)
>  
>  static __always_inline unsigned long _compound_head(const struct page *page)
>  {
> -	unsigned long head = READ_ONCE(page->compound_info);
> +	unsigned long info = READ_ONCE(page->compound_info);
>  
> -	if (unlikely(head & 1))
> -		return head - 1;
> -	return (unsigned long)page_fixed_fake_head(page);
> +	/* Bit 0 encodes PageTail() */
> +	if (!(info & 1))
> +		return (unsigned long)page_fixed_fake_head(page);
> +
> +	/*
> +	 * If compound_info_has_mask() is false, the rest of compound_info is
> +	 * the pointer to the head page.
> +	 */
> +	if (!compound_info_has_mask())
> +		return info - 1;
> +
> +	/*
> +	 * If compoun_info_has_mask() is true the rest of the info encodes

s/compoun_info_has_mask/compound_info_has_mask/

