Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4329CFF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 12:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A97E6B008A; Thu, 30 Apr 2026 08:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8812D6B008C; Thu, 30 Apr 2026 08:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797076B0092; Thu, 30 Apr 2026 08:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5BB6B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:57:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A69981B96A8
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:57:12 +0000 (UTC)
X-FDA: 84715222704.15.4173164
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2D2254000F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:57:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NcwGQBbe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777553830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZZ3aQQwYdPunNFnwwJxNtofjpkArYVbGRVkNFGYFLg=;
	b=gVH5hUp9Lev+AVIWxT/VRmQ0kcQCGzU/bXt+xzVwg7FhG3TelVby93wEQxQgHJ0F+bAHIc
	WnSGowxtmwC0sPANNbEgIE9qRGHpwwTeHe8fzY6N6bq4ct/l6KzTIJUMnMRI8UfytzvD4x
	IsYQQWyzbTx9zBY8l4CDCRak1XZN6lQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777553830; a=rsa-sha256;
	cv=none;
	b=lM9DM2vTiK9QBQ9kFbPs5u8pz976QSiamXv/A6NJEG478ipy7dP2RIL+yzMje/GDdtOZPk
	AbvDorFbznCMBij6L3NZVli9ax1Id2BXRUKFkQtpMGFcuF+RPlZsV7+N7iJMzR0e6q3BZP
	OiajFX5V1VHAxg3NX1ZdARuMojda/co=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NcwGQBbe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777553829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NZZ3aQQwYdPunNFnwwJxNtofjpkArYVbGRVkNFGYFLg=;
	b=NcwGQBbedDzmgaWs7d7G6ekY7pokkE7Kl/dlgIn+8pwSN2Zxk42fp2jfnC5erjddLBaxan
	vgkqM0KSLi3B9/g0JKX39uw3v54GL8NYd8HmqnYGMz+aAGJ2y2X5hTEf0uNtOMLFOGFsd4
	umSaLW2/kHsd8i8Z/tY+Bn/a2Wllbw0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-Yq_UKJA-PTmRxmQh65f8zA-1; Thu, 30 Apr 2026 08:57:06 -0400
X-MC-Unique: Yq_UKJA-PTmRxmQh65f8zA-1
X-Mimecast-MFC-AGG-ID: Yq_UKJA-PTmRxmQh65f8zA_1777553826
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50edf01172bso19420301cf.2
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777553826; x=1778158626;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NZZ3aQQwYdPunNFnwwJxNtofjpkArYVbGRVkNFGYFLg=;
        b=i6cMtZhwfuTbe0C32cUXaXu1LCsYIGpogzw7p11PM/0JRMLMWZ1ILaBHlfBxrFhmEn
         xbwhFAB3+IL0b/cuAuy2FK/bhns0rLAMntr+GuM1fRm//el5OpukapAKseZ05JaLmDV2
         SezSpieAs33WfiHekk5EcCNYXeyHK1AS+Tx6y6/DKSUXK8CHvToLyc3PGt2aLei+WRnp
         J0VJ2//+EZrN0PaeoCbC7u0kIjLhh0EnCjWSzoe7FAWxfDofojnDieAdwFZ74MOYH/ge
         v72lGFI65yQ65sXvC13FJJs3qcorVmiMZW/FCk9vZ95MPQx6Gag8qz+TGQrv6Au5uKfi
         lvQg==
X-Forwarded-Encrypted: i=1; AFNElJ/3afbbp3s02EBglYxN/O7kwBUcKPJCTE/l6t9YpsbIGAsKT7ZbxuVQTwg4mYeUuN0FgsherBU/Sw==@kvack.org
X-Gm-Message-State: AOJu0YwM4GfFFwOlY29RS3adgmLKBJgq3dUm4z4b+zYWRMPj23fgm229
	qNOgGhKz80T1H2AA758HUxPgfoLC1aM8WkGsNJojeHsfaOSz0QxLwbgsvp/2mNqOHqq6qjsNqHs
	8dyy+DFE557q17ZcXYKECNo2qxDxbfeq0FIROxAN2PM+MrbCW4Wql
X-Gm-Gg: AeBDietGxcjwGIdFfY4U6AwI86IoL/2Tp54QVdTCNWz/j46lgsbLIEbZdHYZbmZppeE
	8EIFH04CDNokxL17+Vo6/0aBkujIjn8xcBFbWs3C6USE09QMy5+MFtn5Zd5TJyh/qL/uUFIFoaq
	suH7XstyFBl8khAhiA6iQ9bKxORPqGq4Kt1cJMHc+pJX4cMChS0Lqm8RmV7xuTpPzhkcyy+KN3b
	Ajso1lYyT6kpcyV8BAetBQqYkNxM2wrsDrPAIxxVc5FmhaUutj4dEby2bE1CBtn8bp7YYJVzTqG
	j9kZYvuWEtbE7ThIeFXX4cOPK2O8MsblQDYCdkSiWm1NJK5derd+LqVVECDvRxtRWJaHPiugcdc
	2lfnmYT4Uj9oCOc1j3Gv8Pk6jNJuv189jEU0=
X-Received: by 2002:a05:622a:408e:b0:50d:597e:4b50 with SMTP id d75a77b69052e-5102ab23012mr41255891cf.13.1777553825551;
        Thu, 30 Apr 2026 05:57:05 -0700 (PDT)
X-Received: by 2002:a05:622a:408e:b0:50d:597e:4b50 with SMTP id d75a77b69052e-5102ab23012mr41254981cf.13.1777553825018;
        Thu, 30 Apr 2026 05:57:05 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b3ff301dd3sm17442166d6.7.2026.04.30.05.57.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 05:57:04 -0700 (PDT)
Message-ID: <749c836e-30e0-44b9-a85a-34c6575bde18@redhat.com>
Date: Thu, 30 Apr 2026 08:56:48 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/54] make MM selftests more CI friendly
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sarthak Sharma
 <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UyOw5Xhlytm8F-QMyX1zMgTnbWDC6mkeEP5F1_UHHdc_1777553826
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D2254000F
X-Rspamd-Server: rspam04
X-Stat-Signature: ygkh9cmee7rqpnxutpn5wsfxch4hcfka
X-HE-Tag: 1777553829-661282
X-HE-Meta: U2FsdGVkX1+68t6Ia5ov/MQ6HRs9Av7VGYJNtKcqHPjwa2lGQB6aYVG2At5BJzonROm6GeVFhjwMhcCEjOvMbhE5q9VZY7Ix500u62kjvEJ0Iuj5zytPWcmMi8NFwZfmrZJKP5D23QupVZhd8nBKnDF/z5fSCh16EOSFtPQIJw5YgUrBcdG9fvuUhNAyp3B537q9Z+976lP7V52sJrRtzJoG2jOI5AFku7am5jZa8DCTzRnuSS1TZi9wmcNMJWFCPFndsWq18jUj8GEV0OGAFkDlsC5OfSOJN7ibJqSSPPcCcUSbvuksoZOHJdX8YsVCMI9cCgAEZRzJWtp92ygFvHt2ufYI+IVq52flibKDNWPstTxbMiHgDape9J5yRN9YlEwHtI6Nba87PHzkNXOFkYuUMUB4pLWa6nGmjmpImoS/XAEQ7GxsSDuu7qvslZ0PmQ8XkRInRFQeFxRjHoG/bFUwUpRq4IXxJ0g2YfXqV/thb15iLmZAXGTRX4TmZZIGNZJBXvqkVm/rd+nUUqkvhvV6TUMrP8NVLvvgQlmSK8g0Qs03DwM5B3USy9eNH29FgG1epIYQfv0uZsfGaIgXE2Od0ZeNMUgS+4FaGGuWodZBS3/yfO9qeMSVj/NdRRanOt7w/SsKiOvvEfYxHG8xh1RCipEoyLjFb26s68E1/zdTxJzsPSovqmi2tGJtu1g2mOu9jiHBtNVaXrjzYe3Lpcb+5i4Df3OLTEgMySmcIQYH9zoWKj00Hlq+MGC0vskkRFH9BCDuauHQvNNA+7ZFFpcFhZJziPdfXCnzNR6DG0JDcV/ynA4PG8SvltbaeYKUK4JM8RIgJkNv4y+yvF33TX/XAwKEybtbdiAF5J4egBx3R8SlJZwXrpZACiWX8v9Oeaf6PKDWZoAbxtQa5Q81DBxeX2M46vusmBD3PwxmwrO84GAMf1A4CJb6DsSyNmpR+2R5CpVRzHqHZHcvHWK
 URFiVlL/
 9RfKXT1yWp2s2+txycmqJuVWfgVA0g9NrL1YtM1odXodKxT5bsitpv82kbxE5CG9K+XEBgoNYXP7Njx6K4Yl/nH9LkBZOs7XVtrQfmAqmoddQ8D2Pyi5TBxsDC8zyQ+NCDGelcw9xmNYwSgVZCD+9T0dXvnMks7RkHs128+HGGPJCr1u4KMe761l2EMXUQz0NDUljAkzstgPbeifzDYu/Ki7kOIe0HD3Ce43XNVvcbxAMbArtMpmUPGQ90HTSaHGhIE98d6nR6EYzEN2wk9+sxSW/Eshzyj3y+b/srvfB9dWzlrWDDQRCOZW9Z5hcVcHa8ezhbelrKd00NxGk1Ji0RIp8efU+WHsBHLBoplsvBY/7nh3sC4tindBD9Wx/+mX+/Cd+AEsGm6R7tGmkAa6i/U7HPWs3xTmBF2GbzHI38ih23odWgTYtPTu82fPwUsXppplSPZ9DKnkWy41xv0gZp6Lr0XTYfFsBRnYK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 16:41, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> There's a lot of dancing around HugeTLB settings in run_vmtests.sh.
> Some test need just a few default huge pages, some require at least 256 MB, and
> some just skip lots of tests if huge pages of all supported sizes are not
> available.
> 
> The goal of this set is to make tests deal with HugeTLB setup and teardown.
> 
> There are already convenient helpers that allow easy reading and writing of
> /proc and /sysfs, so adding a few APIs that will detect and update HugeTLB
> settings shouldn't be a big deal. But these nice helpers use kselftest
> framework, and many of HugeTLB (and even THP) test don't, so as a result this
> patchset also includes a lot of churn for conversion of those tests to
> kselftest framework (patches 7-19).
> 
> The series break out:
> patches 1-5:   small fixes
> patch 6:       merge of hugetlb mmap tests
> patch 7:       renaming of hugepage-* to hugetlb-*
> patches 8-20:  mechanical conversion to kselftest framework
> patches 21-27: extension of thp_settings to hugepage_settings to also include
>                 HugeTLB helpers
> patches 28-29: add helpers for setting up SHM limits in hugetlb-shm and
>                 thuge-gen tests
> patches 30-52: integrate the new APIs in all the tests that use HugeTLB
> patches 53-54: drop HugeTLB setup from run_vmtests.sh
> 
> v3 changes:
> * add patches that fix cleanup of fork()ed processes in migration test
> * drop MADV_REMOVE changes to khugepage test
> * properly setup memfd for non-default hugepages in hugetlb-mmap test
> * add forgotten hugetlb_save_settings() to hugetlb_setup()
> * fixes for ksft reporting
> * rebase on v7.1-rc1
> * add more tags, thanks everyone!

I reran my testing that previously reveled some of the bugs I reported
for v2, they pass now. I ran them on an x86-64 guest with 88 vCPUs and
also on a small s390 guest. The suite as a whole works as before (I also
checked the HugeTLB state gets restored for each test).

I'll be reviewing some of the individual patches, but for the suite as
whole:

Tested-by: Luiz Capitulino <luizcap@redhat.com>

> v2: https://lore.kernel.org/all/20260418105539.1261536-1-rppt@kernel.org
> * fix hugetlb mmap tests to actually test file mappings
> * increase maximal tests number in khugepaged
> * add tags, thanks everyone!
> 
> v1: https://lore.kernel.org/all/20260406141735.2179309-1-rppt@kernel.org
> 
> Mike Rapoport (Microsoft) (54):
>    selftests/mm: hugetlb-read-hwpoison: add SIGBUS handler
>    selftests/mm: migration: don't assume hupe page is TWOMEG
>    selftests/mm: migration: make nthreads represent number of working threads
>    selftests/mm: migration: properly cleanup fork()ed processes
>    selftests/mm: run_vmtests.sh: don't gate THP and KSM tests on HAVE_HUGEPAGES
>    selftests/mm: merge map_hugetlb into hugepage-mmap
>    selftests/mm: rename hugepage-* tests to hugetlb-*
>    selftests/mm: hugetlb-shm: use kselftest framework
>    selftests/mm: hugetlb-vmemmap: use kselftest framework
>    selftests/mm: hugetlb-madvise: use kselftest framework
>    selftests/mm: hugetlb_madv_vs_map: use kselftest framework
>    selftests/mm: hugetlb-read-hwpoison: use kselftest framework
>    selftests/mm: khugepaged: group tests in an array
>    selftests/mm: khugepaged: use ksefltest framework
>    selftests/mm: ksm_tests: use kselftest framework
>    selftests/mm: protection_keys: use descriptive test names in TAP output
>    selftests/mm: protection_keys: use kselftest framework
>    selftests/mm: uffd-stress: use kselftest framework
>    selftests/mm: uffd-unit-tests: use kselftest framework
>    selftests/mm: va_high_addr_switch: use kselftest framework
>    selftests/mm: add atexit() and signal handlers to thp_settings
>    selftests/mm: rename thp_settings.[ch] to hugepage_settings.[ch]
>    selftests/mm: move HugeTLB helpers to hugepage_settings
>    selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size
>    selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages
>    selftests/mm: hugepage_settings: rename get_free_hugepages()
>    selftests/mm: hugepage_settings: add APIs for HugeTLB setup and teardown
>    selftests/mm: move read_file(), read_num() and write_num() to vm_util
>    selftests/mm: vm_util: add helpers to set and restore shm limits
>    selftests/mm: compaction_test: use HugeTLB helpers ...
>    selftests/mm: cow: add setup of HugeTLB pages
>    selftests/mm: gup_longterm: add setup of HugeTLB pages
>    selftests/mm: gup_test: add setup of HugeTLB pages
>    selftests/mm: hmm-tests: add setup of HugeTLB pages
>    selftests/mm: hugepage_dio: add setup of HugeTLB pages
>    selftests/mm: hugetlb_fault_after_madv: add setup of HugeTLB pages
>    selftests/mm: hugetlb-madvise: add setup of HugeTLB pages
>    selftests/mm: hugetlb_madv_vs_map: add setup of HugeTLB pages
>    selftests/mm: hugetlb-mmap: add setup of HugeTLB pages
>    selftests/mm: hugetlb-mremap: add setup of HugeTLB pages
>    selftests/mm: hugetlb-shm: add setup of HugeTLB pages
>    selftests/mm: hugetlb-soft-online: add setup of HugeTLB pages
>    selftests/mm: hugetlb-vmemmap: add setup of HugeTLB pages
>    selftests/mm: migration: add setup of HugeTLB pages
>    selftests/mm: pagemap_ioctl: add setup of HugeTLB pages
>    selftests/mm: protection_keys: use library code for HugeTLB setup
>    selftests/mm: thuge-gen: add setup of HugeTLB pages
>    selftests/mm: uffd-stress: use hugetlb_save and alloc huge pages
>    selftests/mm: uffd-unit-tests: add setup of HugeTLB pages
>    selftests/mm: uffd-wp-mremap: add setup of HugeTLB pages
>    selftests/mm: va_high_addr_switch: add setup of HugeTLB pages
>    selftests/mm: va_high_addr_switch.sh: drop huge pages setup
>    selftests/mm: run_vmtests.sh: free memory if available memory is low
>    selftests/mm: run_vmtests.sh: drop detection and setup of HugeTLB
> 
>   tools/testing/selftests/mm/.gitignore         |   4 +
>   tools/testing/selftests/mm/Makefile           |  13 +-
>   tools/testing/selftests/mm/compaction_test.c  | 113 +-----
>   tools/testing/selftests/mm/cow.c              |  29 +-
>   .../selftests/mm/folio_split_race_test.c      |   2 +-
>   tools/testing/selftests/mm/guard-regions.c    |   2 +-
>   tools/testing/selftests/mm/gup_longterm.c     |   3 +-
>   tools/testing/selftests/mm/gup_test.c         |  12 +
>   tools/testing/selftests/mm/hmm-tests.c        |  24 +-
>   tools/testing/selftests/mm/hugepage-mmap.c    |  78 ----
>   .../{thp_settings.c => hugepage_settings.c}   | 286 +++++++++++--
>   .../{thp_settings.h => hugepage_settings.h}   |  75 +++-
>   tools/testing/selftests/mm/hugetlb-madvise.c  | 209 ++++------
>   tools/testing/selftests/mm/hugetlb-mmap.c     | 145 +++++++
>   .../{hugepage-mremap.c => hugetlb-mremap.c}   |  13 +-
>   .../selftests/mm/hugetlb-read-hwpoison.c      | 123 +++---
>   .../mm/{hugepage-shm.c => hugetlb-shm.c}      |  64 +--
>   .../selftests/mm/hugetlb-soft-offline.c       |  45 +--
>   .../{hugepage-vmemmap.c => hugetlb-vmemmap.c} |  46 +--
>   tools/testing/selftests/mm/hugetlb_dio.c      |  15 +-
>   .../selftests/mm/hugetlb_fault_after_madv.c   |   7 +-
>   .../selftests/mm/hugetlb_madv_vs_map.c        |  22 +-
>   tools/testing/selftests/mm/khugepaged.c       | 380 ++++++++----------
>   tools/testing/selftests/mm/ksm_tests.c        | 182 ++++-----
>   tools/testing/selftests/mm/map_hugetlb.c      |  88 ----
>   tools/testing/selftests/mm/migration.c        | 152 ++++---
>   tools/testing/selftests/mm/pagemap_ioctl.c    |  13 +-
>   tools/testing/selftests/mm/pkey-helpers.h     |   6 +-
>   .../testing/selftests/mm/prctl_thp_disable.c  |   2 +-
>   tools/testing/selftests/mm/protection_keys.c  | 130 +++---
>   tools/testing/selftests/mm/run_vmtests.sh     | 177 ++------
>   tools/testing/selftests/mm/soft-dirty.c       |   2 +-
>   .../selftests/mm/split_huge_page_test.c       |   2 +-
>   tools/testing/selftests/mm/thuge-gen.c        |  80 +---
>   tools/testing/selftests/mm/transhuge-stress.c |   2 +-
>   tools/testing/selftests/mm/uffd-common.h      |   1 +
>   tools/testing/selftests/mm/uffd-stress.c      |  44 +-
>   tools/testing/selftests/mm/uffd-unit-tests.c  | 110 +++--
>   tools/testing/selftests/mm/uffd-wp-mremap.c   |  12 +-
>   .../selftests/mm/va_high_addr_switch.c        |  42 +-
>   .../selftests/mm/va_high_addr_switch.sh       |  41 +-
>   tools/testing/selftests/mm/vm_util.c          | 133 +++---
>   tools/testing/selftests/mm/vm_util.h          |  15 +-
>   43 files changed, 1424 insertions(+), 1520 deletions(-)
>   delete mode 100644 tools/testing/selftests/mm/hugepage-mmap.c
>   rename tools/testing/selftests/mm/{thp_settings.c => hugepage_settings.c} (60%)
>   rename tools/testing/selftests/mm/{thp_settings.h => hugepage_settings.h} (55%)
>   create mode 100644 tools/testing/selftests/mm/hugetlb-mmap.c
>   rename tools/testing/selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c} (94%)
>   rename tools/testing/selftests/mm/{hugepage-shm.c => hugetlb-shm.c} (57%)
>   rename tools/testing/selftests/mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c} (76%)
>   delete mode 100644 tools/testing/selftests/mm/map_hugetlb.c
> 
> 
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
> --
> 2.53.0
> 


