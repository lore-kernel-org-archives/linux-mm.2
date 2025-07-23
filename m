Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B197CC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E91E6B008A; Wed, 23 Jul 2025 05:06:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C18B6B0093; Wed, 23 Jul 2025 05:06:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1C46B0095; Wed, 23 Jul 2025 05:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D89BB6B008A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:06:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A35E61121A4
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:06:15 +0000 (UTC)
X-FDA: 83694947910.21.1702F1E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5951E40007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:06:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A7uOK1Br;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753261573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6YlEo2/lkfaGmvegmh23EK9h8hrgWglSzLeO9LUPDo=;
	b=k0ghQTTvRBIc/EZtAsN9jUA0v/JjjckeszfiTwpSYQYjZ/YLctY013foK2f154NBBAnQOa
	F0796Lax9y489DR2EvBuVuRwaGxt/bdudMQywseC+8evSBINrFUYxiZxJdv/j/Vn6Z3TXx
	m7fbsgj4BXXj9Kn1linLLqHHyAGFsBE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753261573; a=rsa-sha256;
	cv=none;
	b=38k3lzDhO24jnG2Jngn6zOWpf0TeSGp1Vjr3Cucg9eLppsiH/Op0zweMCU/hQTfyfxaJzR
	UPdmAnSFS8aqs5PJY56naD+k6UiLADRFRfjGLwIU8IIq57qsoDUKrUzhZWBmNFr4svPItR
	NrAPoECj+t8RdSgK9/1e9MoeOuPQDNA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A7uOK1Br;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753261572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E6YlEo2/lkfaGmvegmh23EK9h8hrgWglSzLeO9LUPDo=;
	b=A7uOK1Br6aNS7X/2DTSZXgwmQBjSDOrwZ5MBt5gT/Z2LT9RVoD6OeoqGQ/QpAcO9i3HK6s
	+OIT4FITjgcf1szJ4NUA6U0jSJAdpgiOo3FRyCU1682W+wANnQVdZWRrVaWeOxXldQstl4
	37pI1+X+hz2aKofizj06Gc4IvjU9iMs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-PqGcnqE-P-OXMaRNkf_dMg-1; Wed, 23 Jul 2025 05:06:10 -0400
X-MC-Unique: PqGcnqE-P-OXMaRNkf_dMg-1
X-Mimecast-MFC-AGG-ID: PqGcnqE-P-OXMaRNkf_dMg_1753261569
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b7691b297aso421043f8f.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 02:06:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753261569; x=1753866369;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=E6YlEo2/lkfaGmvegmh23EK9h8hrgWglSzLeO9LUPDo=;
        b=Hc6/UK7nzEgk6BrmVVIKVNpe4zCJs3ZGqgMmZ89Zcbdbp7QrJblFU3FjzbVO67BSqV
         VLXSE80mn8EJn9FCl6vv8VLkHfmVR8u3M4UWvM4JfQpTE9IPtMYiZt6J+9n2Uf1PDDHi
         NzsEG1ql7hn2iEKgqQ74iLBUeyKoVBsNC+UNIoz3PcaBR51gEbzdyY1YdS+W448RaCaD
         0xfylwl13eWxLLB2+Ol7Un1BqS3ua3YtxTeqUVUshYADbdn9giTPRJnkHMEr2q42pNHg
         jLxHQHs+Bnh0YKR0u+UNPRdXqi6SQFLjByR5spNaUeiZS/qs1cu8sJ+mCKw9wK3PLijb
         OV+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWvzViJhjXMT6SHKwY7pcfWFuga89ZMifq4QpW/0L25N4VUHwPphFIpVgviHLGBfywg7B2JqS2ytg==@kvack.org
X-Gm-Message-State: AOJu0YyyAjk/Ii6wFJBZj36EyJjqomN5U2gf1u5IRKiCQQdvSGmQrvX9
	uZ7uOrGsBTbJ80f8/fn8/mZVYHx8YYdKq2pK/n9VmYBJMYB2jlM9hDxKxGeiuUh/xuheywdBq96
	+baMuX97wLAIvyTanMiLKpPoIi/5a6bSiX0HCaglxgy6PJ5sX1WkA
X-Gm-Gg: ASbGncv3G/83p1gLgXOf6QPBfL0u56MPCz4oRX9sWLr4CF6zszltLSrx1QTjb2mN2Ih
	hfmsNwearCoPqGLr/dc5AVIHcHq0JuCM92W5nPocxpaD5tJDnFZTImUhQnpGHKx4/2+61OGuP8l
	dT0r5/5pta9C/SV5B/HQdJQ+Z2KxlRI5TQU79iOWfMzo8w3tdVj/gIuqZmOmF0PgXCUMrmvBzGO
	sVsPNRB6j5rditGnDIZg3mgUFL9NeUeJYH9JdUfe0wsmfy/5I1mEiZLIsl8Ji7hW4UGd3OZ2ylB
	SmLWvQuEUm6wRGJtIgjNqWEmH9Q372mTzNe4VKntLemS58KKzhugi3ZDC579JnuD0W6C99/kq0/
	T4ayVpAWcsm2nbqQ7qzA6mgPLnZBKplLbWVjjHCD79+d4K9mirEefIaM8SFcCFJPfYW8=
X-Received: by 2002:a05:6000:4023:b0:3b7:6828:5f6f with SMTP id ffacd0b85a97d-3b768ef39b5mr1929288f8f.38.1753261569100;
        Wed, 23 Jul 2025 02:06:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2OQWof/I0yV5vnfzwaZsfxiMLIIVddaNwGXLzdWVllbT3Ubh1UB0eXKyXcwGhjK+VwAfogA==
X-Received: by 2002:a05:6000:4023:b0:3b7:6828:5f6f with SMTP id ffacd0b85a97d-3b768ef39b5mr1929223f8f.38.1753261568456;
        Wed, 23 Jul 2025 02:06:08 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b75baa6f78sm8848165f8f.3.2025.07.23.02.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 02:06:07 -0700 (PDT)
Message-ID: <3d935889-fcda-4345-bd57-6c7a84458493@redhat.com>
Date: Wed, 23 Jul 2025 11:06:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 2/4] mm: add static huge zero folio
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org,
 x86@kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org,
 gost.dev@samsung.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
References: <20250722094215.448132-1-kernel@pankajraghav.com>
 <20250722094215.448132-3-kernel@pankajraghav.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250722094215.448132-3-kernel@pankajraghav.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S3ZiRZnrUj5ZlRYBmUHs-bH_GVp8V67gDAWGq6HsICo_1753261569
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5951E40007
X-Stat-Signature: oqcat5jh1xhd6oxbc6u4oket8wkfr9zr
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753261573-543469
X-HE-Meta: U2FsdGVkX1/OBQrvIK798lKWeKlu75hDO5b7YkCYXb/oLO0kWUCDY87vdQhU6da5wm2wVx0X1e29QHOeBygFiaQetyjomVLL2kKrLRohQgpy08pEhCoTpjIzA7lli+XAjPaIH3jy6nxVeD5K3o+b+zItwkKMC4t9J4ib7Am8qw0Yuffy+/VfHMRcaYj33E1KtrDw9BCM/7PCezUHDJjkVAGMsLEtALv1qLDTm90djwTwouUOUcpiYpeXXriZLBLmI7kOga4kOTVefJGoq9jv4VqC/c2ML/1JtTIfCVp7rnT8F8AsTPD5WpfczAwLQhy+KDGa5cUHsNGIkXkSa/PQ90uIPAyTY8V2PMJZTAUeYv7xxPFmBQ3Tkv2epj8/Ds8FcYWmkmF1RlBDdk3Jc7oLjs7fVJ8P7omvjCm4hLcD9IMPpb8zsKgdRWyDDZTwHXk/rByRseegEJMCiiqB/L+p0tWO9/+6hOeUjDOvPMja/DXUg9LK9B+ypPtg0F2KMziSnY7tGb/0d3HNU7cXbBmQPCJxWfWpPAiQUfyfh3O/GguugLlICAmouPdFs2fVwgTtUrhEMic16xfSlFujbm2jd7POyuBE1hj/lXoclXEhyV3Popva9ErvKesLbWdfzR6KJThFC2jjFBCqlgIzZ0ldpBnd1ETedc82zeEhFK9HqXBN3kqTN0GsVKfcNqo5xVWi70PSsxxMRayK7jI+NYEfgSaRTODXSXkASMeBncmFaHJOqqL2Ex/vLHfTYrDva5+7HkgEiPhfWh0p+3BTFbYQT9tFg3FRJj6a/CoMS/bg96p/p64wKTgSGsZTYbyHj50J97GK2vy1+n0k5wX1lPRYZLNQylj+sVMhnbXVtervwvzKOQbQRaLim3+BiYD9TXyWr99zLsw9pKKIDxzzZ/IRGUhwlP332FgkaeYpksG8E5JFYKo8VOA/sphBmflrFoo58ftfHDcxMg8jCInNR9n
 csNslcew
 CtbFKXtE9WJyx65hzZLNbhHubItklMrUkWGYkBZI7Qy1URqgPIC8kzbNR92qzxVHppRS8ZHSrigeY2tpm+s9I3q3Pyn2Gke1TPO7jgBmugU791dA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.07.25 11:42, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> There are many places in the kernel where we need to zeroout larger
> chunks but the maximum segment we can zeroout at a time by ZERO_PAGE
> is limited by PAGE_SIZE.
> 
> This is especially annoying in block devices and filesystems where we
> attach multiple ZERO_PAGEs to the bio in different bvecs. With multipage
> bvec support in block layer, it is much more efficient to send out
> larger zero pages as a part of single bvec.
> 
> This concern was raised during the review of adding LBS support to
> XFS[1][2].
> 
> Usually huge_zero_folio is allocated on demand, and it will be
> deallocated by the shrinker if there are no users of it left. At moment,
> huge_zero_folio infrastructure refcount is tied to the process lifetime
> that created it. This might not work for bio layer as the completions
> can be async and the process that created the huge_zero_folio might no
> longer be alive. And, one of the main point that came during discussion
> is to have something bigger than zero page as a drop-in replacement.
> 
> Add a config option STATIC_HUGE_ZERO_FOLIO that will always allocate
> the huge_zero_folio, and it will never drop the reference. This makes
> using the huge_zero_folio without having to pass any mm struct and does
> not tie the lifetime of the zero folio to anything, making it a drop-in
> replacement for ZERO_PAGE.
> 
> If STATIC_PMD_ZERO_PAGE config option is enabled, then
> mm_get_huge_zero_folio() will simply return this page instead of
> dynamically allocating a new PMD page.
> 
> This option can waste memory in small systems or systems with 64k base
> page size. So make it an opt-in and also add an option from individual
> architecture so that we don't enable this feature for larger base page
> size systems.
> 
> [1] https://lore.kernel.org/linux-xfs/20231027051847.GA7885@lst.de/
> [2] https://lore.kernel.org/linux-xfs/ZitIK5OnR7ZNY0IG@infradead.org/
> 
> Co-Developed-by: David Hildenbrand <david@redhat.com>

"Co-developed-by:"

And must be followed by

Signed-of-by: David Hildenbrand <david@redhat.com>

As mentioned to the cover letter: spaces vs. tabs.

> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>   arch/x86/Kconfig        |  1 +
>   include/linux/huge_mm.h | 16 ++++++++++++++++
>   mm/Kconfig              | 12 ++++++++++++
>   mm/huge_memory.c        | 28 ++++++++++++++++++++++++++++
>   4 files changed, 57 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 0ce86e14ab5e..8e2aa1887309 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -153,6 +153,7 @@ config X86
>   	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
>   	select ARCH_WANT_HUGETLB_VMEMMAP_PREINIT if X86_64
>   	select ARCH_WANTS_THP_SWAP		if X86_64
> +	select ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO if X86_64
>   	select ARCH_HAS_PARANOID_L1D_FLUSH
>   	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
>   	select BUILDTIME_TABLE_SORT
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 7748489fde1b..0ddd9c78f9f4 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -476,6 +476,7 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
>   
>   extern struct folio *huge_zero_folio;
>   extern unsigned long huge_zero_pfn;
> +extern atomic_t huge_zero_folio_is_static;
>   
>   static inline bool is_huge_zero_folio(const struct folio *folio)
>   {
> @@ -494,6 +495,16 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
>   
>   struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
>   void mm_put_huge_zero_folio(struct mm_struct *mm);
> +struct folio *__get_static_huge_zero_folio(void);
> +
> +static inline struct folio *get_static_huge_zero_folio(void)
> +{
> +       if (!IS_ENABLED(CONFIG_STATIC_HUGE_ZERO_FOLIO))
> +               return NULL;
> +       if (likely(atomic_read(&huge_zero_folio_is_static)))
> +               return huge_zero_folio;
 > +       return __get_static_huge_zero_folio();> +}
>   
>   static inline bool thp_migration_supported(void)
>   {
> @@ -685,6 +696,11 @@ static inline int change_huge_pud(struct mmu_gather *tlb,
>   {
>   	return 0;
>   }
> +
> +static inline struct folio *get_static_huge_zero_folio(void)
> +{
> +       return NULL;
> +}
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
>   static inline int split_folio_to_list_to_order(struct folio *folio,
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 0287e8d94aea..14721171846f 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -835,6 +835,18 @@ config ARCH_WANT_GENERAL_HUGETLB
>   config ARCH_WANTS_THP_SWAP
>   	def_bool n
>   
> +config ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO
> +	def_bool n
> +
> +config STATIC_HUGE_ZERO_FOLIO
> +	bool "Allocate a PMD sized folio for zeroing"
> +	depends on ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO
> +	help
> +	  Typically huge_zero_folio, which is a PMD page of zeroes, is allocated
> +	  on demand and deallocated when not in use. This option will
> +	  allocate huge_zero_folio but it will never free it.
> +	  Not suitable for memory constrained systems.

Maybe something like

"
Without this config enabled, the huge zero folio is allocated on demand 
and freed under memory pressure once no longer in use. To detect 
remaining users reliably, references to the huge zero folio must be 
tracked precisely, so it is commonly only available for mapping it into 
user page tables.

With this config enabled, the huge zero folio can also be used for other 
purposes that do not implement precise reference counting: it is still 
allocated on demand, but never freed, allowing for more wide-spread use,
for example, when performing I/O similar to the traditional shared 
zeropage."

Not suitable for memory constrained systems.
"

Should we make it clear that this is currently limited to THP configs?

depends on TRANSPARENT_HUGEPAGE

> +
>   config MM_ID
>   	def_bool n
>   
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 5d8365d1d3e9..6c890a1482f3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -75,6 +75,8 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>   static bool split_underused_thp = true;
>   
>   static atomic_t huge_zero_refcount;
> +static atomic_t huge_zero_static_fail_count __read_mostly;
> +atomic_t huge_zero_folio_is_static __read_mostly;
>   struct folio *huge_zero_folio __read_mostly;
>   unsigned long huge_zero_pfn __read_mostly = ~0UL;
>   unsigned long huge_anon_orders_always __read_mostly;
> @@ -266,6 +268,32 @@ void mm_put_huge_zero_folio(struct mm_struct *mm)
>   		put_huge_zero_page();
>   }
>   
> +#ifdef CONFIG_STATIC_HUGE_ZERO_FOLIO
> +struct folio *__get_static_huge_zero_folio(void)

Do we want to play safe and have a

if (unlikely(!slab_is_available()))
	return NULL;

> +{
> +       /*
> +        * If we failed to allocate a huge zero folio multiple times,
> +        * just refrain from trying.
> +        */

Hmmm, I wonder if we want to retry "some time later" again. Meaning, 
we'd base it on the jiffies, maybe?

See print_bad_pte() for an example.

> +       if (atomic_read(&huge_zero_static_fail_count) > 2)
> +               return NULL;
> +

We could make some smart decision regarding totalram_pages() and just 
disable it. A bit tricky, we can do that as a follow-up.

> +       /*
> +        * Our raised reference will prevent the shrinker from ever having
> +        * success.
> +        */
> +       if (!get_huge_zero_page()) {
> +              atomic_inc(&huge_zero_static_fail_count);
> +               return NULL;
> +       }
> +
> +       if (atomic_cmpxchg(&huge_zero_folio_is_static, 0, 1) != 0)
> +               put_huge_zero_page();
> +
> +       return huge_zero_folio;
> +}
> +#endif /* CONFIG_STATIC_HUGE_ZERO_FOLIO */
> +
>   static unsigned long shrink_huge_zero_folio_count(struct shrinker *shrink,
>   						  struct shrink_control *sc)
>   {


-- 
Cheers,

David / dhildenb


