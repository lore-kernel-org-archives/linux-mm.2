Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67443C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 11:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869C06B008A; Wed, 30 Jul 2025 07:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 841516B008C; Wed, 30 Jul 2025 07:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757126B0092; Wed, 30 Jul 2025 07:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 642106B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:17:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 096078047A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:17:04 +0000 (UTC)
X-FDA: 83720679168.15.1E2DB2A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9AE6C40003
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:17:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YEryixHC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753874221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvUZl8UsRxarX+a47kb4o3MCQM4rqegqmRJ5/HY1RYM=;
	b=z+kvKKH8uhAsXf0oDucK79eq0NXqNWlj9flBBXFf337zDDQgPZFASq6YHaQu3g5wXpJgCP
	A+CFLDZ6gQSQ+rB+J0N13+Yfrm9q+u4saskfhO/UU3nsb94DvDODEqG4RtMFoQXQjPIlUf
	TRYN7GltLrt4BnmE1c7Kiq4VNN06ago=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753874221; a=rsa-sha256;
	cv=none;
	b=zYDrbn1Iszki8lNEqu1iJmCFzciasEjeIb5DxkDVFNbBtJcDKO5USQFjlbUUlyuLZOoDeB
	33K22Jnu9uxieu5aC7akq1FB3S/WMqPzwSyuw1BNTnW04fQUQ6DHo24Po2VZZGzHf3bque
	Yf29zF5gyZyLFLiCKTWCDhdYVn22OPM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YEryixHC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753874221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kvUZl8UsRxarX+a47kb4o3MCQM4rqegqmRJ5/HY1RYM=;
	b=YEryixHC9snvT9KTZAl+mCrzRjPFUaEdkuEHls921Bnrg5SBfctcWFy+LgnYOvcf5uWBAw
	v6eeo5yXkTvFw1qEvP7IU1qfjldnWEUSpsS6rIwchlTlQQAMIbhasf34CKtKla48P4Ox+1
	vG4PCFABNnrRSlKMKp1GlKWVo6yx4rE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-RmRTG12pPpOVVW7V47k7-A-1; Wed, 30 Jul 2025 07:16:59 -0400
X-MC-Unique: RmRTG12pPpOVVW7V47k7-A-1
X-Mimecast-MFC-AGG-ID: RmRTG12pPpOVVW7V47k7-A_1753874218
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-553b94b73d6so3893260e87.2
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 04:16:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753874217; x=1754479017;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kvUZl8UsRxarX+a47kb4o3MCQM4rqegqmRJ5/HY1RYM=;
        b=B8aCIHDZ6NxhPlp5dmzCY6imtsqKF6oT3QiDzdp9hyh3Y90nUfE/gPjBKcQVi/lnB+
         m3nDs+/kJXzu7JAnCxXEfOqn8m4dRIOqKKNKexltdkIKfBTi0g1j+6IRb+cHqEHq/2LL
         d20Fr+N2Cln6jVC6hDWq/FObVCDJeCz2+CBX4Hl6NsKxxWo7mVuNlcZPOr1BN0owHbAj
         fUY9egRUAYmrIdt6SFiDdtLsszWlD/hKk35YJfOF83XRX3gowpXE9BlBcm7V5afv1CZS
         qxe52zO7jGiav4b+MDclzxB28pzLwCLQY023Z0RkPaiJaqnULqN7YOr9x8h9G1Phvw5f
         /Rvw==
X-Forwarded-Encrypted: i=1; AJvYcCUsCDWXt61vynjmvCHdr7tBDiUNHsFdYUeoSRSSSWtZkRbbOoNhn5Jqi5LamWd5IiTIU5vKOZ1XnA==@kvack.org
X-Gm-Message-State: AOJu0YyzIJXTvv6794qGlE2ErBQ+lpMkY/9a36PsHZ/iNAeSIC9ygEVg
	x6wEg9/5dQH9eTkrsHEFxpUZPP96vJsO85rF4For3hKtuzLG6INr8kTueEZyChoO0NJ4tOL5waq
	pePYNy+cPXrgP0/3CSMxGgKJkp9LnPq4I0NQtuz3FZKQTYkW+CJg=
X-Gm-Gg: ASbGnctHBcKIKO6sXm8ciVI3ELk7q5ELlsgzQGHo+lapFr95MHGvZHKisug7SfHLZQy
	Q1vUAudO5sqNuKlbuJZrv9u2LW4kMWlXXXg0UTpO5hr0M/xLyZYfG1Myrx68NoaRpXTcS7Fm7Na
	wdYsafVnG0UlwcsG/p6jMBNmhQNP4XlUblwbmKOR1O9ifWmKZXYX7AJVoOwyFlStYNOsxnxmsWG
	dWxcEKBPx3XUv21qx1s5+MOS/EfNV+EnaNBQonYBfGV5TevxIJpF8giQBQpKb3DYo4coxZKW9cC
	l8ceINiDRJl+/UnS1YE+2Z1GW+UdLrTOnnWkd2Wv2422fBHte9nijFS/FexJLIs4fw==
X-Received: by 2002:a05:6512:4154:b0:55a:c9f0:a01c with SMTP id 2adb3069b0e04-55b7c0a5bf9mr547846e87.53.1753874217294;
        Wed, 30 Jul 2025 04:16:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHn9i5LR+L5e7rVqqc3z2wJjWwtz+exUpZ3SHaIfX3F/NhAiWhrcRtNvN2AldXvieg3Lp906A==
X-Received: by 2002:a05:6512:4154:b0:55a:c9f0:a01c with SMTP id 2adb3069b0e04-55b7c0a5bf9mr547830e87.53.1753874216740;
        Wed, 30 Jul 2025 04:16:56 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b6317ba40sm2084515e87.46.2025.07.30.04.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 04:16:56 -0700 (PDT)
Message-ID: <c2f2fe52-a358-489e-a1f2-5c0a6f5b4db5@redhat.com>
Date: Wed, 30 Jul 2025 14:16:55 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@redhat.com>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, Jane Chu <jane.chu@oracle.com>,
 Alistair Popple <apopple@nvidia.com>, Donet Tom <donettom@linux.ibm.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <20250730092139.3890844-3-balbirs@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20250730092139.3890844-3-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OANOuuP2PRUqKwO8zOA_KUbnzG7Fbr56ZklrrHh4F3Q_1753874218
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9AE6C40003
X-Stat-Signature: taq8d7dfbu6z3cq911mobk6ai6pztict
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753874221-586355
X-HE-Meta: U2FsdGVkX19gfiSUR4GzBV3QoenwxeAjqhrB2xaFxTJm4P+qvHeGfBiO2kiHteOCwHvxZqAuD11IsCp6VpkHr7Xk/PmBjyQAMMtcxXPXWWnZDI7MBUYBv8WMqbB5/d5u9RrPkm/40/KKYsSnT7m2FKJVqe6JdxfOABhgb/kYFKjvBhngBG7l7pHrJXLvqgloGrGSkMNiemDnGu0BUZ3T9QXVzHtKxVz3vvv9QoIhhs9QWYLic903vFcTLa8NVnm52oGb9pTMyWXCpjUbqEkJ/ax9RMUkKp1N0NmBYPfllt181Of60ObJjwm8T/uKSFjc9GHzHs35OD6gKHhlsLBF7s0umWgJU9FUTsdn/iWkfLTiLq5GnREmekIaZHb5vmXOWvrOudX3cUM0/eX6T3lPffnK2l3ytAtNF/z/P9XvI1NaE00D1WKEBDAd0bDaWPrCpvWvdFZYJtDuKTQZlcPJimZyPIV3PWYarXWelEBjMCA+acobn5TYxLlPiNseUDPTTBPqa8H5wyDR1E7qcdfbNkgISdyv2SdDeW+qtVjHVje22tswljfmOPBRfdR9PC9yTXwdlTiAioLa1EMGkKKOslwOWPZqbEXGsCX87FpSjElqIrqElOUOeXeSSTjGRUXwiTZUarl0noj1shY7lMhM8VWcd6RxRul9PNcTty4N/JmpalB3XzA4LYLtpqUT6Sss8fPN5IA4GT5T0wcFK0E5+hCNb+Nn5pbZEFMxLpk6wTnFzfK2K1srrkG7HNnRem1pxsbmqv6sV48z0XCaok6sqxfVAKJEZ68aN6Nx6f8jgG+70leA7RD6d9BVJudQ5T+eHX633s32Rh8FCAnYGZCY41D/QTc9YDlwNnW9qTPeZIXq9DVqvQvExGVIutedTOEk9fE8IgjqbsgegXHDWE91hU9p7bDVw2cGehgcZpGumJ0UkUHDcZsTLnkNijcR8oPiVV8pF8Vz5W1cy76SF9o
 bKNVSwgf
 vt1g623e9OCjmqYmo3UCnW7nqD1wMRYXhSnHZrziOpxF5Ezbd+rv6oCOy3vLti25MTdDKKin3Ede6N+pOPtNta0nyaofk8PnOjoVYhMltw/WRWFpPHE4FAUpXeK62eUqRkbvu0i4vAAbbcGcR2VhUClNOzk7z1Nve2+AtgnTkkxogpj+IuPVnm9WavuSzA2SXA1hIPBtl6JSlFcQBNIpMCryuh25NX4CyXqhnNEFXejSZzKr0zn8IDh7n5/HBy2jSN0W7R0kUCsOgSygEHRNwc/IKUHkE3Vspv40mG1wwhGS99LNVqVfVHQM8Uo9SZ3ITkQnsdCOQiMB4lOGKGlh3L47xL+tVVJK2CIgt2C3LFUpBMRfAhzwlcxrPC3IedQAYItswy/zTy1ssDaO/6kHPcJ0Utrkpxdq2lD7YkXqxbM3yc4rUtt73lZPptOWWUMINncWNI3poM2eJ0vvxJial/mFOhKQtBa3S3TxSQm92oVIZYt9KFkL3JqhAqnIEG8zIgmy6q6UuZqwzmh7OSwacEMH+4bv0evj9L0Klw+k6W2EawzlJC7AnikwVvzVzo2FBxi1HT00o4U61Zzrj6m4+/cYFpGuQV8NaD6oKsPIiO8cNEMYZSoLfbJ6G27Ag/slS7Y+sAFQNJSFBatzbehaq7pMeDlbHtAZ75McwcNnzZ6oUT2Fpt4m0VLof8vhzG7IYXk/0erdfi9Vj8Xj2XCTa3ljycSE4DAjXcMW9SWr1A0XTGdgMq+4dZS+Zggtg8ezMEqJTJ6VEZJ6yclG4ovGT4s9e0km3eBcurfdUfPH2BoFXx2w+IFVOS0lKC5q7bnSRJusk90MKYBs6BojGHIcuwP8bPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 7/30/25 12:21, Balbir Singh wrote:
> Make THP handling code in the mm subsystem for THP pages aware of zone
> device pages. Although the code is designed to be generic when it comes
> to handling splitting of pages, the code is designed to work for THP
> page sizes corresponding to HPAGE_PMD_NR.
>
> Modify page_vma_mapped_walk() to return true when a zone device huge
> entry is present, enabling try_to_migrate() and other code migration
> paths to appropriately process the entry. page_vma_mapped_walk() will
> return true for zone device private large folios only when
> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
> not zone device private pages from having to add awareness. The key
> callback that needs this flag is try_to_migrate_one(). The other
> callbacks page idle, damon use it for setting young/dirty bits, which is
> not significant when it comes to pmd level bit harvesting.
>
> pmd_pfn() does not work well with zone device entries, use
> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
> entries.
>
> Zone device private entries when split via munmap go through pmd split,
> but need to go through a folio split, deferred split does not work if a
> fault is encountered because fault handling involves migration entries
> (via folio_migrate_mapping) and the folio sizes are expected to be the
> same there. This introduces the need to split the folio while handling
> the pmd split. Because the folio is still mapped, but calling
> folio_split() will cause lock recursion, the __split_unmapped_folio()
> code is used with a new helper to wrap the code
> split_device_private_folio(), which skips the checks around
> folio->mapping, swapcache and the need to go through unmap and remap
> folio.
>
> Cc: Karol Herbst <kherbst@redhat.com>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: "Jérôme Glisse" <jglisse@redhat.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Jane Chu <jane.chu@oracle.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Donet Tom <donettom@linux.ibm.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
>
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>  include/linux/huge_mm.h |   1 +
>  include/linux/rmap.h    |   2 +
>  include/linux/swapops.h |  17 +++
>  mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>  mm/page_vma_mapped.c    |  13 +-
>  mm/pgtable-generic.c    |   6 +
>  mm/rmap.c               |  22 +++-
>  7 files changed, 278 insertions(+), 51 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 7748489fde1b..2a6f5ff7bca3 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -345,6 +345,7 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>  int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>  		unsigned int new_order);
> +int split_device_private_folio(struct folio *folio);
>  int min_order_for_split(struct folio *folio);
>  int split_folio_to_list(struct folio *folio, struct list_head *list);
>  bool uniform_split_supported(struct folio *folio, unsigned int new_order,
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 20803fcb49a7..625f36dcc121 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -905,6 +905,8 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
>  #define PVMW_SYNC		(1 << 0)
>  /* Look for migration entries rather than present PTEs */
>  #define PVMW_MIGRATION		(1 << 1)
> +/* Look for device private THP entries */
> +#define PVMW_THP_DEVICE_PRIVATE	(1 << 2)
>  
>  struct page_vma_mapped_walk {
>  	unsigned long pfn;
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index 64ea151a7ae3..2641c01bd5d2 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -563,6 +563,7 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
>  {
>  	return is_swap_pmd(pmd) && is_migration_entry(pmd_to_swp_entry(pmd));
>  }
> +
>  #else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>  static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>  		struct page *page)
> @@ -594,6 +595,22 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
>  }
>  #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
>  
> +#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
> +
> +static inline int is_pmd_device_private_entry(pmd_t pmd)
> +{
> +	return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
> +}
> +
> +#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
> +
> +static inline int is_pmd_device_private_entry(pmd_t pmd)
> +{
> +	return 0;
> +}
> +
> +#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
> +
>  static inline int non_swap_entry(swp_entry_t entry)
>  {
>  	return swp_type(entry) >= MAX_SWAPFILES;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9c38a95e9f09..e373c6578894 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -72,6 +72,10 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>  					  struct shrink_control *sc);
>  static unsigned long deferred_split_scan(struct shrinker *shrink,
>  					 struct shrink_control *sc);
> +static int __split_unmapped_folio(struct folio *folio, int new_order,
> +		struct page *split_at, struct xa_state *xas,
> +		struct address_space *mapping, bool uniform_split);
> +
>  static bool split_underused_thp = true;
>  
>  static atomic_t huge_zero_refcount;
> @@ -1711,8 +1715,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	if (unlikely(is_swap_pmd(pmd))) {
>  		swp_entry_t entry = pmd_to_swp_entry(pmd);
>  
> -		VM_BUG_ON(!is_pmd_migration_entry(pmd));
> -		if (!is_readable_migration_entry(entry)) {
> +		VM_WARN_ON(!is_pmd_migration_entry(pmd) &&
> +				!is_pmd_device_private_entry(pmd));
> +
> +		if (is_migration_entry(entry) &&
> +			is_writable_migration_entry(entry)) {
>  			entry = make_readable_migration_entry(
>  							swp_offset(entry));
>  			pmd = swp_entry_to_pmd(entry);
> @@ -1722,6 +1729,32 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  				pmd = pmd_swp_mkuffd_wp(pmd);
>  			set_pmd_at(src_mm, addr, src_pmd, pmd);
>  		}
> +
> +		if (is_device_private_entry(entry)) {
> +			if (is_writable_device_private_entry(entry)) {
> +				entry = make_readable_device_private_entry(
> +					swp_offset(entry));
> +				pmd = swp_entry_to_pmd(entry);
> +
> +				if (pmd_swp_soft_dirty(*src_pmd))
> +					pmd = pmd_swp_mksoft_dirty(pmd);
> +				if (pmd_swp_uffd_wp(*src_pmd))
> +					pmd = pmd_swp_mkuffd_wp(pmd);
> +				set_pmd_at(src_mm, addr, src_pmd, pmd);
> +			}
> +
> +			src_folio = pfn_swap_entry_folio(entry);
> +			VM_WARN_ON(!folio_test_large(src_folio));
> +
> +			folio_get(src_folio);
> +			/*
> +			 * folio_try_dup_anon_rmap_pmd does not fail for
> +			 * device private entries.
> +			 */
> +			VM_WARN_ON(folio_try_dup_anon_rmap_pmd(src_folio,
> +					  &src_folio->page, dst_vma, src_vma));
> +		}
> +
>  		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>  		mm_inc_nr_ptes(dst_mm);
>  		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
> @@ -2219,15 +2252,22 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  			folio_remove_rmap_pmd(folio, page, vma);
>  			WARN_ON_ONCE(folio_mapcount(folio) < 0);
>  			VM_BUG_ON_PAGE(!PageHead(page), page);
> -		} else if (thp_migration_supported()) {
> +		} else if (is_pmd_migration_entry(orig_pmd) ||
> +				is_pmd_device_private_entry(orig_pmd)) {
>  			swp_entry_t entry;
>  
> -			VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
>  			entry = pmd_to_swp_entry(orig_pmd);
>  			folio = pfn_swap_entry_folio(entry);
>  			flush_needed = 0;
> -		} else
> -			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> +
> +			if (!thp_migration_supported())
> +				WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> +
> +			if (is_pmd_device_private_entry(orig_pmd)) {
> +				folio_remove_rmap_pmd(folio, &folio->page, vma);
> +				WARN_ON_ONCE(folio_mapcount(folio) < 0);
> +			}
> +		}
>  
>  		if (folio_test_anon(folio)) {
>  			zap_deposited_table(tlb->mm, pmd);
> @@ -2247,6 +2287,15 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  				folio_mark_accessed(folio);
>  		}
>  
> +		/*
> +		 * Do a folio put on zone device private pages after
> +		 * changes to mm_counter, because the folio_put() will
> +		 * clean folio->mapping and the folio_test_anon() check
> +		 * will not be usable.
> +		 */
> +		if (folio_is_device_private(folio))
> +			folio_put(folio);
> +
>  		spin_unlock(ptl);
>  		if (flush_needed)
>  			tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
> @@ -2375,7 +2424,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		struct folio *folio = pfn_swap_entry_folio(entry);
>  		pmd_t newpmd;
>  
> -		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
> +		VM_WARN_ON(!is_pmd_migration_entry(*pmd) &&
> +			   !folio_is_device_private(folio));
>  		if (is_writable_migration_entry(entry)) {
>  			/*
>  			 * A protection check is difficult so
> @@ -2388,6 +2438,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  			newpmd = swp_entry_to_pmd(entry);
>  			if (pmd_swp_soft_dirty(*pmd))
>  				newpmd = pmd_swp_mksoft_dirty(newpmd);
> +		} else if (is_writable_device_private_entry(entry)) {
> +			entry = make_readable_device_private_entry(
> +							swp_offset(entry));
> +			newpmd = swp_entry_to_pmd(entry);
>  		} else {
>  			newpmd = *pmd;
>  		}
> @@ -2834,6 +2888,44 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
>  	pmd_populate(mm, pmd, pgtable);
>  }
>  
> +/**
> + * split_huge_device_private_folio - split a huge device private folio into
> + * smaller pages (of order 0), currently used by migrate_device logic to
> + * split folios for pages that are partially mapped
> + *
> + * @folio: the folio to split
> + *
> + * The caller has to hold the folio_lock and a reference via folio_get
> + */
> +int split_device_private_folio(struct folio *folio)
> +{
> +	struct folio *end_folio = folio_next(folio);
> +	struct folio *new_folio;
> +	int ret = 0;
> +
> +	/*
> +	 * Split the folio now. In the case of device
> +	 * private pages, this path is executed when
> +	 * the pmd is split and since freeze is not true
> +	 * it is likely the folio will be deferred_split.
> +	 *
> +	 * With device private pages, deferred splits of
> +	 * folios should be handled here to prevent partial
> +	 * unmaps from causing issues later on in migration
> +	 * and fault handling flows.
> +	 */
> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));

Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?

> +	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);

Confusing to  __split_unmapped_folio() if folio is mapped...

--Mika



