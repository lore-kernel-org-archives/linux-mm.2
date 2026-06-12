Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 140BCCD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 10:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ED546B0088; Fri, 12 Jun 2026 06:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4EA6B008C; Fri, 12 Jun 2026 06:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D99A6B0092; Fri, 12 Jun 2026 06:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D1F96B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:31:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 220551A03E2
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:31:13 +0000 (UTC)
X-FDA: 84870893226.21.955C002
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4AC65180002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:31:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I/qQZpR3";
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781260270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvvTu1uVNYIh9bpNgTtcE9q3Se0t7H2bpVXEZumrRoI=;
	b=AgtVfwheCxSykh5ALQ05Uy2htMbsnpAlY7Xhk2m5KaG7gLVZgmTjLxFjkb3DhapcvxC6j9
	CNAH8sVftNFyVOLmJOvg2Ln8KOF0DTFw1QZuIMSbmrqfHONvrCCXj28jlEhYpzUaxFf2Q+
	NTfplh8BI0C3zdbw6oiSTVHM7V1eJlo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="I/qQZpR3";
	spf=pass (imf24.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781260270;
	b=EQt9GOvqf1bUl9pHYLVoQG/2U3G79uQUXB59j2152kyUCNJX7KAWVrh3nCfD3nJIle44GL
	mIWrHOLUNCOZc1XafCPmpIFSktO56EGXOF2QBG9O3clU6bOWIJDtK+Da7yfSDJdltUIvTD
	Plaup7CUqjcu183+ckscGg64cngxegU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781260269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xvvTu1uVNYIh9bpNgTtcE9q3Se0t7H2bpVXEZumrRoI=;
	b=I/qQZpR3boVpnWUsnPU6LWoONcAoaUPowtHGwSYk8kY5MmIaxuQcNOxdyhR5O2BE/xsJrD
	vdPQKv8CUDq8wuQ9fxs1zEcwZaowHr7/UwSyMF9ys9T9pbv4TH0a3gmAWSgJEiiKK3WJWu
	ouf1a+rDwVKG4Q/Nt7IAY8TjzkA5WhA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-7MwMphmDNwC0TNLlvRxTTA-1; Fri, 12 Jun 2026 06:31:08 -0400
X-MC-Unique: 7MwMphmDNwC0TNLlvRxTTA-1
X-Mimecast-MFC-AGG-ID: 7MwMphmDNwC0TNLlvRxTTA_1781260267
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490b8adf8b8so7024005e9.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:31:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781260267; x=1781865067;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xvvTu1uVNYIh9bpNgTtcE9q3Se0t7H2bpVXEZumrRoI=;
        b=X0c1EPbLXb+SRd322ZzP64luD4dtrk62an1QBtzyDUpeGeUnX6a0kTSxi+cZjcpbwv
         QvSx05CHz9XKONFBamEVXcV4mIaxEaecyNdnGTq/4UAmhWGkb28Dwj90sGMsmeDuPPEz
         bHaL2QSMCnhT6eXzhpmH6Q8V+C48N+ZEXBIP6BSno1vj0M53S298NpGpMIcxyeYE0JWI
         hkO6kyzHj9o4eIYs5/U9Hj+UOAkuIlCrTNEvXx7NhshKQm18Ia2tP9YNaPQX4v4tivfb
         sWznzPuhQDMHG0a67z2qIO8/NU189U/0UteegAEjO/tghAs+/sIAMwt4Y0RZ2RHNBapx
         cE3w==
X-Forwarded-Encrypted: i=1; AFNElJ+uNMi8eMWArc18Onh6BaG7WHNeOjLvZgJ9bLjUaW32Pe696f9Hc4FwBZIzVHCE96MGzLrdg/nbsA==@kvack.org
X-Gm-Message-State: AOJu0YxErCygtMj5A1OImFRIXqVHlmSExzaGB4/6QoZttM8ISw6auZjO
	Y/pBvfo/UHOvm1bYBpoD0B0WLUKIctZ2CMdDOi8Mb5rOQPi++exS8+k7ZGq9vWC4bxFt2vijVrM
	QwbRPAnbOCHShbZCB9PYLLj81UisITxa0xQD1z2FeaVUa2Yi+Hcht
X-Gm-Gg: Acq92OHIer3Iv4S4G7WoHDrtrFCEf3D8UBtYT+DDeJYOu8LXf35nkm5CnOUTlqYGflk
	brswYGuyD6GXkOtTVd7+pSgVbLb+yLwRiPwus2vphkMkr8YZfvTRZwcHsKIBYOHX9G5fCQt3YiE
	ggR4Mw8Z2z4LHHwk+htNiTxlFNlMNSizx2OGXzZliM4BTx9/xT2X80dBIE8Tt3XCYGTKnaXQqAT
	3c7WXV9NROmx4uBikG8IyKhIv2J7KBCGjVQAelZw9iWVIjLotGQUEm4N1L84cNy15MmgmvaBJWm
	PQrYou5NF+z5QcYlNFtGwp1oJ+Dga4xKfNjMm7Z12+JMJw2Q4boi1Z5Y1ptuTwO6l/crNDmMDyq
	mXHiChSXvxDgj1/MliK1VXGdq1S5jHdOJDogAn9xgSJqzCBrSGSeofOzysoSscXB5
X-Received: by 2002:a05:600d:844f:20b0:490:b8e2:6380 with SMTP id 5b1f17b1804b1-490ec4c3d2fmr19929495e9.12.1781260266975;
        Fri, 12 Jun 2026 03:31:06 -0700 (PDT)
X-Received: by 2002:a05:600d:844f:20b0:490:b8e2:6380 with SMTP id 5b1f17b1804b1-490ec4c3d2fmr19928745e9.12.1781260266147;
        Fri, 12 Jun 2026 03:31:06 -0700 (PDT)
Received: from [172.31.99.182] (91.red-83-48-118.staticip.rima-tde.net. [83.48.118.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c5266sm4684943f8f.29.2026.06.12.03.31.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 03:31:05 -0700 (PDT)
Message-ID: <9c424084-2223-4d69-87b9-cd21c443b396@redhat.com>
Date: Fri, 12 Jun 2026 04:32:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 08/11] selftests: mm: extend the check_huge() to
 support mTHP check
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
 <bbedc5afc56b0f7b2073324a3551159ed9cf5f9c.1781083630.git.baolin.wang@linux.alibaba.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <bbedc5afc56b0f7b2073324a3551159ed9cf5f9c.1781083630.git.baolin.wang@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: C8z5j7Tr4AalShG3oESuyiX8say94T5jQLsSy9GaDZc_1781260267
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4AC65180002
X-Stat-Signature: 3cwp9qdqajwob5813hcrnodfc677er1q
X-Rspam-User: 
X-HE-Tag: 1781260270-904874
X-HE-Meta: U2FsdGVkX19xxXmAwE4aHaiEdmUWYwIyeTL6yD3wRmzwYPqny4CWNTfp9kyvRJBMviFzabTZbNlOrFKt9uk9aeKzy/pkXy5D6kL0wB+wsZYiwLCOYP4K5J3v3ovloool4iheMKylx71byjziWO6IBShaw0GzIGhiqbHD6ivYP+6EcvNv/KU3ojM/tln92OYCFBQRM3ieemsKcEs1lrY+Lb7VW8Zp+RKWwP6ygIxkEac3kVP4BJZckIcHaYnlW52z/yVfCDb5iFev+1WRUi/AaW5CaU7v9DHoeXIDwR1EOBCxV5z6A+mDru57n9G9GuUMtfNDyqbbeAPqsYfMCffUBkBtxmsVwc4Yo06iyvrnWH4KPgQ4KEejuc16sYb9Gkt8BD7DqMEmDIm8bkNRpCwFxJPv0EufXa9tQafyEKFWQ38KOiDRDqSNHhkIlnztb3KOucKoQE+OjUgnGmF3KSg06k1LUcIEXiTxVoE7DUgLz0glQHAVRzsZmR4ciU0zHIA2WEb42PJ8Bzk2OEmh1q2FVhSqFwXrJF+5sX4ZZXZfADR5FimuAMlhqk1VwF/bhLMIRt+r9LIhw/7Mthr9CTk5/8lo67j0MYZ6FJ6OOOrOKiV3Id+5mBeJC4BAN6DGMDVx8vFkqA+oUuQvDSxdnxzS8NjK+7SRgdu9Hg4ZKtLeiJ9NpYuShcsb1267tkMGyIBxnCB+6wNZfjjg+X/clQVhciGBFXZBqW+cmHwRlpzBwAWddf1cvJvPtqS3ZaBNHCEdSi+vaaTONoa4evm/OD4c192n7ayaH7ImUyNrKnBTxy69ImsQlN+mU/wu4+iYSEMj7W8ibdvp+LWflsZgNlTAz429eFKfpeyEeVnb7AkitfSMLWdOYWXc9gL/1rocLIm790hTK1XGqoqF2tNPFq2gwmlvQZKmFo1XOxF1iS9PkRjrp2zd9BVZDXFGUhGcINDhIEXUW3YdhZjs3DQT19L
 8cHWrUxu
 iIYI/xxmoDl3fhLAYTNr2XCNRz185lRjH/RQt9kZUBfYcR/jSuSytb96meEWMlB0JGPAqLx7mV94Hxxj9Sy35SFoHrJkQqZrR5sQ9Xx9G/yIshjVn7vzMHJF138sRnHKBfQ2+2EdoTGUVvDmLXn0O4AqrrUWYybXs/E4n8L2OvCuak+Vbz7l0Nh/WRGHpVCAMjqUXFI5WZhYlP9YErdhNV22rxFloQH4rYhxkfaPvaPvvtYBcObHdYgPjKU0za7+Eqn2mVb57uXfScSFRXutStXCtyZQro5Rd6wvVS+cGSJ2+hj4qbHFP3kMIxLV8c9E5gAU34DFjxUiWJQzlE3X0INV14Zx8AswwXEdNFXVfZ3ieviQkXzY7mByBMDwz3EnGxOs2JabIycqg1gPFZ3z+wK9uowD+PjmL0R7c939bilVwk/wap7A1TxWpuy46b9mQvgej6qqNMctexlLsl6DzBSg6/IsO/QyKu8QWGN/d8WQ33MVjKyA6gc+SIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/10/26 4:29 AM, Baolin Wang wrote:
> To support checking for various sized mTHPs during mTHP collapse, extend the
> check_huge() function prototype to accept two new parameters specifying the
> address range and mTHP size, in preparation for the following patches.
> 
> No functional changes.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  .../selftests/mm/folio_split_race_test.c      |  2 +-
>  tools/testing/selftests/mm/khugepaged.c       | 66 ++++++++++---------
>  .../testing/selftests/mm/prctl_thp_disable.c  |  2 +-
>  tools/testing/selftests/mm/soft-dirty.c       |  2 +-
>  .../selftests/mm/split_huge_page_test.c       | 14 ++--
>  tools/testing/selftests/mm/uffd-common.c      |  4 +-
>  tools/testing/selftests/mm/vm_util.c          |  6 +-
>  tools/testing/selftests/mm/vm_util.h          |  6 +-
>  8 files changed, 55 insertions(+), 47 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
> index 6329e37fff4c..45b84f7b364e 100644
> --- a/tools/testing/selftests/mm/folio_split_race_test.c
> +++ b/tools/testing/selftests/mm/folio_split_race_test.c
> @@ -182,7 +182,7 @@ static uint64_t run_iteration(void)
>  	for (i = 0; i < TOTAL_PAGES; i++)
>  		fill_page(mmap_base, i);
>  
> -	if (!check_huge_shmem(mmap_base, NR_PMD_PAGE, pmd_pagesize))
> +	if (!check_huge_shmem(mmap_base, FILE_SIZE, NR_PMD_PAGE, pmd_pagesize))
>  		ksft_exit_fail_msg("No shmem THP is allocated\n");
>  
>  	if (pthread_barrier_init(&ctl.barrier, NULL, NUM_READER_THREADS + 1) != 0)
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 10e8dedcb087..f69be6be0ecd 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -51,7 +51,7 @@ struct mem_ops {
>  	void *(*setup_area)(int nr_hpages);
>  	void (*cleanup_area)(void *p, unsigned long size);
>  	void (*fault)(void *p, unsigned long start, unsigned long end);
> -	bool (*check_huge)(void *addr, int nr_hpages);
> +	bool (*check_huge)(void *addr, unsigned long size, int nr_hpages, unsigned long hpage_size);
>  	const char *name;
>  };
>  
> @@ -276,7 +276,7 @@ static void *alloc_hpage(struct mem_ops *ops)
>  	ksft_print_msg("Allocate huge page...");
>  	if (madvise_collapse_retry(p, hpage_pmd_size))
>  		ksft_exit_fail_perror("madvise(MADV_COLLAPSE)");
> -	if (!ops->check_huge(p, 1))
> +	if (!ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
>  		ksft_exit_fail_perror("madvise(MADV_COLLAPSE)");
>  	if (madvise(p, hpage_pmd_size, MADV_HUGEPAGE))
>  		ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
> @@ -310,9 +310,10 @@ static void anon_fault(void *p, unsigned long start, unsigned long end)
>  	fill_memory(p, start, end);
>  }
>  
> -static bool anon_check_huge(void *addr, int nr_hpages)
> +static bool anon_check_huge(void *addr, unsigned long size,
> +		int nr_hpages, unsigned long hpage_size)
>  {
> -	return check_huge_anon(addr, nr_hpages, hpage_pmd_size);
> +	return check_huge_anon(addr, size, nr_hpages, hpage_size);
>  }
>  
>  static void *file_setup_area_common(int nr_hpages, enum file_setup_ops setup)
> @@ -412,13 +413,14 @@ static void file_fault_write(void *p, unsigned long start, unsigned long end)
>  		ksft_exit_fail_perror("madvise(MADV_POPULATE_WRITE)");
>  }
>  
> -static bool file_check_huge(void *addr, int nr_hpages)
> +static bool file_check_huge(void *addr, unsigned long size,
> +		int nr_hpages, unsigned long hpage_size)
>  {
>  	switch (finfo.type) {
>  	case VMA_FILE:
> -		return check_huge_file(addr, nr_hpages, hpage_pmd_size);
> +		return check_huge_file(addr, size, nr_hpages, hpage_size);
>  	case VMA_SHMEM:
> -		return check_huge_shmem(addr, nr_hpages, hpage_pmd_size);
> +		return check_huge_shmem(addr, size, nr_hpages, hpage_size);
>  	default:
>  		exit(EXIT_FAILURE);
>  		return false;
> @@ -448,9 +450,10 @@ static void shmem_cleanup_area(void *p, unsigned long size)
>  	close(finfo.fd);
>  }
>  
> -static bool shmem_check_huge(void *addr, int nr_hpages)
> +static bool shmem_check_huge(void *addr, unsigned long size,
> +			int nr_hpages, unsigned long hpage_size)
>  {
> -	return check_huge_shmem(addr, nr_hpages, hpage_pmd_size);
> +	return check_huge_shmem(addr, size, nr_hpages, hpage_size);
>  }
>  
>  static struct mem_ops __anon_ops = {
> @@ -533,7 +536,7 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>  	ret = madvise_collapse_retry(p, nr_hpages * hpage_pmd_size);
>  	if (((bool)ret) == expect)
>  		fail("Fail: Bad return value");
> -	else if (!ops->check_huge(p, expect ? nr_hpages : 0))
> +	else if (!ops->check_huge(p, nr_hpages * hpage_pmd_size, expect ? nr_hpages : 0, hpage_pmd_size))
>  		fail("Fail: check_huge()");
>  	else
>  		success("OK");
> @@ -545,7 +548,7 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
>  			     struct mem_ops *ops, bool expect)
>  {
>  	/* Sanity check */
> -	if (!ops->check_huge(p, 0))
> +	if (!ops->check_huge(p, nr_hpages * hpage_pmd_size, 0, hpage_pmd_size))
>  		ksft_exit_fail_msg("Unexpected huge page\n");
>  	__madvise_collapse(msg, p, nr_hpages, ops, expect);
>  }
> @@ -554,11 +557,12 @@ static void madvise_collapse(const char *msg, char *p, int nr_hpages,
>  static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
>  			  struct mem_ops *ops)
>  {
> +	unsigned long size = nr_hpages * hpage_pmd_size;
>  	int full_scans;
>  	int timeout = 6; /* 3 seconds */
>  
>  	/* Sanity check */
> -	if (!ops->check_huge(p, 0))
> +	if (!ops->check_huge(p, size, 0, hpage_pmd_size))
>  		ksft_exit_fail_msg("Unexpected huge page\n");
>  
>  	madvise(p, nr_hpages * hpage_pmd_size, MADV_HUGEPAGE);
> @@ -568,7 +572,7 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
>  
>  	ksft_print_msg("%s...", msg);
>  	while (timeout--) {
> -		if (ops->check_huge(p, nr_hpages))
> +		if (ops->check_huge(p, size, nr_hpages, hpage_pmd_size))
>  			break;
>  		if (thp_read_num("khugepaged/full_scans") >= full_scans)
>  			break;
> @@ -582,6 +586,8 @@ static bool wait_for_scan(const char *msg, char *p, int nr_hpages,
>  static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
>  				struct mem_ops *ops, bool expect)
>  {
> +	unsigned long size = nr_hpages * hpage_pmd_size;
> +
>  	/*
>  	 * read&write file collapse fails since khugepaged does not flush
>  	 * the target dirty folios
> @@ -605,7 +611,7 @@ static void khugepaged_collapse(const char *msg, char *p, int nr_hpages,
>  	if (ops != &__anon_ops)
>  		ops->fault(p, 0, nr_hpages * hpage_pmd_size);
>  
> -	if (ops->check_huge(p, expect ? nr_hpages : 0))
> +	if (ops->check_huge(p, size, expect ? nr_hpages : 0, hpage_pmd_size))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -634,7 +640,7 @@ static void alloc_at_fault(void)
>  	p = alloc_mapping(1);
>  	*p = 1;
>  	ksft_print_msg("Allocate huge page on fault...");
> -	if (check_huge_anon(p, 1, hpage_pmd_size))
> +	if (check_huge_anon(p, hpage_pmd_size, 1, hpage_pmd_size))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -643,7 +649,7 @@ static void alloc_at_fault(void)
>  
>  	madvise(p, page_size, MADV_DONTNEED);
>  	ksft_print_msg("Split huge PMD on MADV_DONTNEED...");
> -	if (check_huge_anon(p, 0, hpage_pmd_size))
> +	if (check_huge_anon(p, hpage_pmd_size, 0, hpage_pmd_size))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -815,7 +821,7 @@ static void collapse_single_pte_entry_compound(struct collapse_context *c, struc
>  	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
>  	ksft_print_msg("Split huge page leaving single PTE mapping compound page...");
>  	madvise(p + page_size, hpage_pmd_size - page_size, MADV_DONTNEED);
> -	if (ops->check_huge(p, 0))
> +	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -836,7 +842,7 @@ static void collapse_full_of_compound(struct collapse_context *c, struct mem_ops
>  	ksft_print_msg("Split huge page leaving single PTE page table full of compound pages...");
>  	madvise(p, page_size, MADV_NOHUGEPAGE);
>  	madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
> -	if (ops->check_huge(p, 0))
> +	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -858,7 +864,7 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
>  	for (i = 0; i < hpage_pmd_nr; i++) {
>  		madvise(BASE_ADDR, hpage_pmd_size, MADV_HUGEPAGE);
>  		ops->fault(BASE_ADDR, 0, hpage_pmd_size);
> -		if (!ops->check_huge(BASE_ADDR, 1))
> +		if (!ops->check_huge(BASE_ADDR, hpage_pmd_size, 1, hpage_pmd_size))
>  			ksft_exit_fail_msg("Failed to allocate huge page\n");
>  		madvise(BASE_ADDR, hpage_pmd_size, MADV_NOHUGEPAGE);
>  
> @@ -881,7 +887,7 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
>  
>  	ops->cleanup_area(BASE_ADDR, hpage_pmd_size);
>  	ops->fault(p, 0, hpage_pmd_size);
> -	if (!ops->check_huge(p, 1))
> +	if (!ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -903,7 +909,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
>  
>  	ksft_print_msg("Allocate small page...");
>  	ops->fault(p, 0, page_size);
> -	if (ops->check_huge(p, 0))
> +	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -911,7 +917,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
>  	ksft_print_msg("Share small page over fork()...");
>  	if (!fork()) {
>  		/* Do not touch settings on child exit */
> -		if (ops->check_huge(p, 0))
> +		if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
>  			success("OK");
>  		else
>  			fail("Fail");
> @@ -929,7 +935,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
>  	exit_status = WEXITSTATUS(wstatus);
>  
>  	ksft_print_msg("Check if parent still has small page...");
> -	if (ops->check_huge(p, 0))
> +	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -947,7 +953,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
>  	ksft_print_msg("Share huge page over fork()...");
>  	if (!fork()) {
>  		/* Do not touch settings on child exit */
> -		if (ops->check_huge(p, 1))
> +		if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
>  			success("OK");
>  		else
>  			fail("Fail");
> @@ -955,7 +961,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
>  		ksft_print_msg("Split huge page PMD in child process...");
>  		madvise(p, page_size, MADV_NOHUGEPAGE);
>  		madvise(p, hpage_pmd_size, MADV_NOHUGEPAGE);
> -		if (ops->check_huge(p, 0))
> +		if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
>  			success("OK");
>  		else
>  			fail("Fail");
> @@ -976,7 +982,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
>  	exit_status = WEXITSTATUS(wstatus);
>  
>  	ksft_print_msg("Check if parent still has huge page...");
> -	if (ops->check_huge(p, 1))
> +	if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
>  		success("OK");
>  	else
>  		fail("Fail");
> @@ -995,7 +1001,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
>  	ksft_print_msg("Share huge page over fork()...");
>  	if (!fork()) {
>  		/* Do not touch settings on child exit */
> -		if (ops->check_huge(p, 1))
> +		if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
>  			success("OK");
>  		else
>  			fail("Fail");
> @@ -1003,7 +1009,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
>  		ksft_print_msg("Trigger CoW on page %d of %d...",
>  				hpage_pmd_nr - max_ptes_shared - 1, hpage_pmd_nr);
>  		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared - 1) * page_size);
> -		if (ops->check_huge(p, 0))
> +		if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
>  			success("OK");
>  		else
>  			fail("Fail");
> @@ -1016,7 +1022,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
>  			       hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
>  			ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared) *
>  				    page_size);
> -			if (ops->check_huge(p, 0))
> +			if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
>  				success("OK");
>  			else
>  				fail("Fail");
> @@ -1034,7 +1040,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
>  	exit_status = WEXITSTATUS(wstatus);
>  
>  	ksft_print_msg("Check if parent still has huge page...");
> -	if (ops->check_huge(p, 1))
> +	if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
>  		success("OK");
>  	else
>  		fail("Fail");
> diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
> index d8d9d1de57b8..82c6e96ea6eb 100644
> --- a/tools/testing/selftests/mm/prctl_thp_disable.c
> +++ b/tools/testing/selftests/mm/prctl_thp_disable.c
> @@ -67,7 +67,7 @@ static int test_mmap_thp(enum thp_collapse_type madvise_buf, size_t pmdsize)
>  	/* HACK: make sure we have a separate VMA that we can check reliably. */
>  	mprotect(mem, pmdsize, PROT_READ);
>  
> -	ret = check_huge_anon(mem, 1, pmdsize);
> +	ret = check_huge_anon(mem, pmdsize, 1, pmdsize);
>  	munmap(mmap_mem, mmap_size);
>  	return ret;
>  }
> diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
> index fb1864a68e1c..e198facf78bb 100644
> --- a/tools/testing/selftests/mm/soft-dirty.c
> +++ b/tools/testing/selftests/mm/soft-dirty.c
> @@ -103,7 +103,7 @@ static void test_hugepage(int pagemap_fd, int pagesize)
>  	for (i = 0; i < hpage_len; i++)
>  		map[i] = (char)i;
>  
> -	if (check_huge_anon(map, 1, hpage_len)) {
> +	if (check_huge_anon(map, hpage_len, 1, hpage_len)) {
>  		ksft_test_result_pass("Test %s huge page allocation\n", __func__);
>  
>  		clear_softdirty();
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 32b991472f74..4cc70873a674 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -296,7 +296,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
>  	unsigned long rss_anon_before, rss_anon_after;
>  	size_t i;
>  
> -	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
> +	if (!check_huge_anon(one_page, nr_hpages * pmd_pagesize, nr_hpages, pmd_pagesize))
>  		ksft_exit_fail_msg("No THP is allocated\n");
>  
>  	rss_anon_before = rss_anon();
> @@ -311,7 +311,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
>  		if (one_page[i] != (char)0)
>  			ksft_exit_fail_msg("%ld byte corrupted\n", i);
>  
> -	if (!check_huge_anon(one_page, 0, pmd_pagesize))
> +	if (!check_huge_anon(one_page, nr_hpages * pmd_pagesize, 0, pmd_pagesize))
>  		ksft_exit_fail_msg("Still AnonHugePages not split\n");
>  
>  	rss_anon_after = rss_anon();
> @@ -347,7 +347,7 @@ static void split_pmd_thp_to_order(int order)
>  	for (i = 0; i < len; i++)
>  		one_page[i] = (char)i;
>  
> -	if (!check_huge_anon(one_page, 4, pmd_pagesize))
> +	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 4, pmd_pagesize))
>  		ksft_exit_fail_msg("No THP is allocated\n");
>  
>  	/* split all THPs */
> @@ -366,7 +366,7 @@ static void split_pmd_thp_to_order(int order)
>  					   (pmd_order + 1)))
>  		ksft_exit_fail_msg("Unexpected THP split\n");
>  
> -	if (!check_huge_anon(one_page, 0, pmd_pagesize))
> +	if (!check_huge_anon(one_page, 4 * pmd_pagesize, 0, pmd_pagesize))
>  		ksft_exit_fail_msg("Still AnonHugePages not split\n");
>  
>  	ksft_test_result_pass("Split huge pages to order %d successful\n", order);
> @@ -393,7 +393,7 @@ static void split_pte_mapped_thp(void)
>  	for (i = 0; i < thp_area_size; i++)
>  		thp_area[i] = (char)i;
>  
> -	if (!check_huge_anon(thp_area, nr_thps, pmd_pagesize)) {
> +	if (!check_huge_anon(thp_area, nr_thps * pmd_pagesize, nr_thps, pmd_pagesize)) {
>  		ksft_test_result_skip("Not all THPs allocated\n");
>  		goto out;
>  	}
> @@ -657,7 +657,7 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
>  
>  	force_read_pages(*addr, fd_size / pmd_pagesize, pmd_pagesize);
>  
> -	if (!check_huge_file(*addr, fd_size / pmd_pagesize, pmd_pagesize)) {
> +	if (!check_huge_file(*addr, fd_size, fd_size / pmd_pagesize, pmd_pagesize)) {
>  		ksft_print_msg("No large pagecache folio generated, please provide a filesystem supporting large folio\n");
>  		munmap(*addr, fd_size);
>  		close(*fd);
> @@ -735,7 +735,7 @@ static void split_thp_in_pagecache_to_order_at(size_t fd_size,
>  		goto out;
>  	}
>  
> -	if (!check_huge_file(addr, 0, pmd_pagesize)) {
> +	if (!check_huge_file(addr, fd_size, 0, pmd_pagesize)) {
>  		ksft_print_msg("Still FilePmdMapped not split\n");
>  		err = EXIT_FAILURE;
>  		goto out;
> diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
> index edd02328f77b..777f276044e2 100644
> --- a/tools/testing/selftests/mm/uffd-common.c
> +++ b/tools/testing/selftests/mm/uffd-common.c
> @@ -194,7 +194,9 @@ static void shmem_alias_mapping(uffd_global_test_opts_t *gopts, __u64 *start,
>  
>  static void shmem_check_pmd_mapping(uffd_global_test_opts_t *gopts, void *p, int expect_nr_hpages)
>  {
> -	if (!check_huge_shmem(gopts->area_dst_alias, expect_nr_hpages,
> +	unsigned long size = expect_nr_hpages * read_pmd_pagesize();
> +
> +	if (!check_huge_shmem(gopts->area_dst_alias, size, expect_nr_hpages,
>  			      read_pmd_pagesize()))
>  		err("Did not find expected %d number of hugepages",
>  		    expect_nr_hpages);
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 311fc5b4513e..b43adfa92116 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -247,17 +247,17 @@ bool __check_huge(void *addr, char *pattern, int nr_hpages,
>  	return thp == (nr_hpages * (hpage_size >> 10));
>  }
>  
> -bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size)
> +bool check_huge_anon(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)

Whats the purpose of adding 'size' here?

>  {
>  	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
>  }
>  
> -bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size)
> +bool check_huge_file(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
>  {
>  	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);

Same?

>  }
>  
> -bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size)
> +bool check_huge_shmem(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
>  {
>  	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);

And here?

Perhaps I find out in the next patch :)

Thanks!
-- Nico

>  }
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index ea8fc8fdf0eb..40c6d8c4f1b8 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -90,9 +90,9 @@ void clear_softdirty(void);
>  bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);
>  uint64_t read_pmd_pagesize(void);
>  unsigned long rss_anon(void);
> -bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
> -bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
> -bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
> +bool check_huge_anon(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size);
> +bool check_huge_file(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size);
> +bool check_huge_shmem(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size);
>  int64_t allocate_transhuge(void *ptr, int pagemap_fd);
>  int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
>  


