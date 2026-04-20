Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5473DF557E4
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 08:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBC4C6B0005; Mon, 20 Apr 2026 04:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B93BF6B0089; Mon, 20 Apr 2026 04:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAA196B008A; Mon, 20 Apr 2026 04:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9AD186B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 04:37:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 534E2BBAE9
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:37:11 +0000 (UTC)
X-FDA: 84678279462.05.EADBC25
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 33A70A0006
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:37:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PD2cCPb1;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776674229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rfbr5dN2ftUPmWLFXDX1EHLgAI3+LJ6aaULR0wZHJ4w=;
	b=mY5mm7UZPeWaXvkamajIfPLwTu5qvalUfQ0ez3UOfK+w+enJ3gmMr80x0n1Rv5xMDKqmok
	XTXMRQ/3+QOV8PfLDJ8Ij/+DxW3NHsQTuxf8cKNF8a50v6knMXl08eBRzT5WBmJSsx7R1+
	jsPqR73AeOzgHE9pgksHtkeRJl5QinE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776674229; a=rsa-sha256;
	cv=none;
	b=kxMj9zHQAB5zVFF1clPsbTfwHFFN6obM8JhTrUheYadherj0k3emB9sWsGlQ3wfDffKknF
	oNIlFfE6J6znxq9HwMCCqtiNK6lXYCU3iHP7/2cOxhvtTnmeIIanQXz6siPoQNxJeFqCEJ
	+HKlv1mdgTVFwv4LRR4lQBt6ii8IqVI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PD2cCPb1;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E6831476;
	Mon, 20 Apr 2026 01:37:02 -0700 (PDT)
Received: from [192.168.68.108] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8C933F641;
	Mon, 20 Apr 2026 01:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776674228; bh=NfY2RXyUodJ7psQ5RhNAMYUIFyhIFjYeFmaK+9gaVw4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PD2cCPb1rYLxwlA/qI8PlM794QzrL4cNfX6sTziYY6Q1EyFI0DvJtOCqP3oFcM3Y0
	 5srgWJ4dnYZWtXNn5SemTdc0mav2ayFisCmUs7jR060vG/kPtLclVgbq1Uptfhu3tq
	 zTA+eWhl7mGQfLZraTjNHzcemigCVIJ3X/A4zN38=
Message-ID: <ee6bbac9-b375-4413-a771-6d32c7afda67@arm.com>
Date: Mon, 20 Apr 2026 09:37:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/53] selftests/mm: make MM selftests more CI friendly
Content-Language: en-GB
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lance Yang <lance.yang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260406141735.2179309-1-rppt@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 33A70A0006
X-Rspamd-Server: rspam07
X-Stat-Signature: d3p8it57dj3nczj9ny9r4rbh84z8rjug
X-Rspam-User: 
X-HE-Tag: 1776674229-425913
X-HE-Meta: U2FsdGVkX187KkmIJGO31+imzJ58/VwPfIyMGzKTv4EAs64rFXD9vZHKYIrDJbJMur8dpab94DXPFwYfbvfn1zuMsAxqPh0++5UiNvude056KI8LpZks28A2WiRYThDViAl6MhhDbsuNAEVOb51VFw5n+rSXledpy1KzGn/Y8o8Aln6KtV1rCJbs6VI2SM+h1TlkwysXXWrRXQVJMcUGiorS1JdGHvmnOsTBVXpJ7OoOoHNDM89QuwLEfgGmLbDc96WHyKHxR/WPPwZXjrScGaj5FHOMxw1gq4eMdzekpfXj/RjCm3FpA6KUztaNaJirZj3wsKV6eOffdvIJbRks/dL26jXxsphI1J+tjKAoqX+znBfi9FVimV8yaNFPSXDkF3x96xLNmf+krCP/fC+0OTucJhXjkJgEjh+2asvcG/4ds8IFEk9Kz8cvBuwzCqlO5grR6yQalrgPtOclm93kJMJ93DLglIALl3dV4TGFBC4ExtN5s2IM/9FEj5nQJO1t/CO0wTiuqD9nzFj1B2AJDrUCnmtyhCFE3unURj1yqV5NAkVQpzzZgxjSgUAoiCjtqMx1/5j0fNZu0EPlF9JJ2yVd59VAmsKrI0hU1aA0qOeMgghNgfvtNbwkrgSilirI3f7UAha+Y8RQ58J4NruA8YeEJCLUdGDKlpbH+kdCnW0aKSuMtrrHuh9TUTU1cPvcOmMvA5Lct5FkMl+lLP1/FXXQPYi0hWEiT4v0f0dLbg+gDXABu4jkEXH9MDIBw7Nb3fPRukr5US5/jHROCVyqlS/yyqPo34UO1QcJ8qmw1Zzltd7Xew0iJHM9qVCFu7D18u0DFWakFk9Stjfm7u86AlDLq61uEkMLWpWx6/4RFEYzAex1PmnrJA1PFPvPOHC/pkeLBMop4Gvv825Zgkf/npYks5MZs5stty34k+GiOA+/nzoMsnIAbJSwMg7J0zMsaOdyAli94lIs425nK3H
 080nhbWk
 8pRd6j9QJVrM1aBsiDmhNShoYDfc68Ra/YvDfj9timbxqLwDsvGL1NbbhCj8VmUAl9YfnkGHeliThzThGT3iK/iKIoTXFuL8oUb9afEwqgKq6Zc7sh08Q4vZYttZliSivWsg893U9f9gqpiVwe0Gfx1/4l2BT09kf6of8C5MDW6m0IVl6EeJR486xMdAYb2NpfLARVBTH6LvzDiOnvto02eGDSwEAidObjaRTkV45Mm+zC5IY3xoqF+VqgdCOHmT6fk0k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/04/2026 15:16, Mike Rapoport wrote:
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

Hi Mike,

I haven't had a chance to review this series properly, but the intent certainly
seems extremely valuable!

I thought I'd share some configuration magic that I always use when running on
arm64. Appologies if I'm teaching you to suck eggs...

arm64 supports multiple hugetlb sizes and (at least in the past) the magic in
run_vmtests.sh only reserves for the default size. As a consequence, whenever I
run these tests on arm64, I always boot with:

hugepagesz=1G hugepages=0:2,1:2
hugepagesz=32M hugepages=0:2,1:2
default_hugepagesz=2M hugepages=0:64,1:64
hugepagesz=64K hugepages=0:2,1:2

Which reserves 2 pages of each supported non-default size in each of 2 NUMA
nodes, and 64 of the default size in each NUMA node. (This would need adjusting
if using a different base page size).

My recollection is that this effectively overrides what the script was doing and
is sufficient to make all hugetlb tests run for all hugepage sizes.

If it's possible to get this non-default hugepage size reservation logic into
the tests themselves, this will make the mm selftests much easier to run on
arm64 with full coverage.

Another observation is that "secretmem.enable" is currently needed on the
cmdline to enable secretmem so that the associated tests run. Not sure what can
be done to make that simpler?

And there are tests that depend on having more than 1 NUMA node; I always run
under QEMU with 2 emulated NUMA nodes. I guess that's really just a property of
the HW, so nothing to be done from the test harness.

Thanks,
Ryan


> 
> There are already convenient helpers that allow easy reading and writing of
> /proc and /sysfs, so adding a few APIs that will detect and update HugeTLB
> settings shouldn't be a big deal. But these nice helpers use kselftest
> framework, and many of HugeTLB (and even THP) test don't, so as a result this
> patchset also includes a lot of churn for conversion of those tests to
> kselftest framework (patches 7-19).
> 
> And there were a few small things I fixed on the way.
> 
> I don't mean for this set to land in 7.1-rc1, except perhaps the small fixes in
> the beginning of the series (patches 1-4).
> 
> But after staring at this code for some time I realized that I won't spot any
> new issues in these patches and an extra pair(s) of eyes would be helpful.
> 
> The extension of thp_settings to hugepage_settings that also include HugeTLB
> helpers is implemented by patches 20-26.
> 
> Patches 27-28 are there to allow setting up SHM limits in hugetlb-shm and
> thuge-gen tests.
> 
> Patches 29-51 integrate the new APIs in all the tests that use HugeTLB.
> 
> And at last patches 52-53 drop HugeTLB setup from run_vmtests.sh
> 
> Happy Easter to those who celebrate!
> 
> Mike Rapoport (Microsoft) (53):
>   selftests/mm: hugetlb-read-hwpoison: add SIGBUS handler
>   selftests/mm: khugepaged: enable collapse_single_pte_entry_compound for shmem
>   selftests/mm: migration: don't assume hupe page is TWOMEG
>   selftests/mm: run_vmtests.sh: don't gate THP and KSM tests on HAVE_HUGEPAGES
>   selftests/mm: merge map_hugetlb into hugepage-mmap
>   selftests/mm: rename hugepage-* tests to hugetlb-*
>   selftests/mm: hugetlb-shm: use kselftest framework
>   selftests/mm: hugetlb-vmemmap: use kselftest framework
>   selftests/mm: hugetlb-madvise: use kselftest framework
>   selftests/mm: hugetlb_madv_vs_map: use kselftest framework
>   selftests/mm: hugetlb-read-hwpoison: use kselftest framework
>   selftests/mm: khugepaged: group tests in an array
>   selftests/mm: khugepaged: use ksefltest framework
>   selftests/mm: ksm_tests: use kselftest framework
>   selftests/mm: protection_keys: use descriptive test names in TAP output
>   selftests/mm: protection_keys: use kselftest framework
>   selftests/mm: uffd-stress: use kselftest framework
>   selftests/mm: uffd-unit-tests: use kselftest framework
>   selftests/mm: va_high_addr_switch: use kselftest framework
>   selftests/mm: add atexit() and signal handlers to thp_settings
>   selftests/mm: rename thp_settings.[ch] to  hugepage_settings.[ch]
>   selftests/mm: move HugeTLB helpers to hugepage_settings
>   selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size
>   selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages
>   selftests/mm: hugepage_settings: rename get_free_hugepages()
>   selftests/mm: hugepage_settings: add APIs for HugeTLB setup and teardown
>   selftests/mm: move read_file(), read_num() and write_num() to vm_util
>   selftests/mm: vm_util: add helpers to set and restore shm limits
>   selftests/mm: compaction_test: use HugeTLB helpers ...
>   selftests/mm: cow: add setup of HugeTLB pages
>   selftests/mm: gup_longterm: add setup of HugeTLB pages
>   selftests/mm: gup_test: add setup of HugeTLB pages
>   selftests/mm: hmm-tests: add setup of HugeTLB pages
>   selftests/mm: hugepage_dio: add setup of HugeTLB pages
>   selftests/mm: hugetlb_fault_after_madv: add setup of HugeTLB pages
>   selftests/mm: hugetlb-madvise: add setup of HugeTLB pages
>   selftests/mm: hugetlb_madv_vs_map: add setup of HugeTLB pages
>   selftests/mm: hugetlb-mmap: add setup of HugeTLB pages
>   selftests/mm: hugetlb-mremap: add setup of HugeTLB pages
>   selftests/mm: hugetlb-shm: add setup of HugeTLB pages
>   selftests/mm: hugetlb-soft-online: add setup of HugeTLB pages
>   selftests/mm: hugetlb-vmemmap: add setup of HugeTLB pages
>   selftests/mm: migration: add setup of HugeTLB pages
>   selftests/mm: pagemap_ioctl: add setup of HugeTLB pages
>   selftests/mm: protection_keys: use library code for HugeTLB setup
>   selftests/mm: thuge-gen: add setup of HugeTLB pages
>   selftests/mm: uffd-stress: use hugetlb_save and alloc huge pages
>   selftests/mm: uffd-unit-tests: add setup of HugeTLB pages
>   selftests/mm: uffd-wp-mremap: add setup of HugeTLB pages
>   selftests/mm: va_high_addr_switch: add setup of HugeTLB pages
>   selftests/mm: va_high_addr_switch.sh: drop huge pages setup
>   selftests/mm: run_vmtests.sh: free memory if available memory is low
>   selftests/mm: run_vmtests.sh: drop detection and setup of HugeTLB
> 
>  tools/testing/selftests/mm/.gitignore         |   4 +
>  tools/testing/selftests/mm/Makefile           |  13 +-
>  tools/testing/selftests/mm/compaction_test.c  | 113 +----
>  tools/testing/selftests/mm/cow.c              |  29 +-
>  .../selftests/mm/folio_split_race_test.c      |   2 +-
>  tools/testing/selftests/mm/guard-regions.c    |   2 +-
>  tools/testing/selftests/mm/gup_longterm.c     |   3 +-
>  tools/testing/selftests/mm/gup_test.c         |  12 +
>  tools/testing/selftests/mm/hmm-tests.c        |  24 +-
>  tools/testing/selftests/mm/hugepage-mmap.c    |  78 ----
>  .../{thp_settings.c => hugepage_settings.c}   | 284 +++++++++++--
>  .../{thp_settings.h => hugepage_settings.h}   |  75 +++-
>  tools/testing/selftests/mm/hugetlb-madvise.c  | 209 ++++------
>  tools/testing/selftests/mm/hugetlb-mmap.c     | 141 +++++++
>  .../{hugepage-mremap.c => hugetlb-mremap.c}   |  13 +-
>  .../selftests/mm/hugetlb-read-hwpoison.c      | 123 +++---
>  .../mm/{hugepage-shm.c => hugetlb-shm.c}      |  65 ++-
>  .../selftests/mm/hugetlb-soft-offline.c       |  45 +-
>  .../{hugepage-vmemmap.c => hugetlb-vmemmap.c} |  46 +-
>  tools/testing/selftests/mm/hugetlb_dio.c      |  15 +-
>  .../selftests/mm/hugetlb_fault_after_madv.c   |   7 +-
>  .../selftests/mm/hugetlb_madv_vs_map.c        |  22 +-
>  tools/testing/selftests/mm/khugepaged.c       | 394 ++++++++----------
>  tools/testing/selftests/mm/ksm_tests.c        | 182 ++++----
>  tools/testing/selftests/mm/map_hugetlb.c      |  88 ----
>  tools/testing/selftests/mm/migration.c        |  54 ++-
>  tools/testing/selftests/mm/pagemap_ioctl.c    |  13 +-
>  tools/testing/selftests/mm/pkey-helpers.h     |   6 +-
>  .../testing/selftests/mm/prctl_thp_disable.c  |   2 +-
>  tools/testing/selftests/mm/protection_keys.c  | 131 +++---
>  tools/testing/selftests/mm/run_vmtests.sh     | 177 ++------
>  tools/testing/selftests/mm/soft-dirty.c       |   2 +-
>  .../selftests/mm/split_huge_page_test.c       |   2 +-
>  tools/testing/selftests/mm/thuge-gen.c        |  80 +---
>  tools/testing/selftests/mm/transhuge-stress.c |   2 +-
>  tools/testing/selftests/mm/uffd-common.h      |   1 +
>  tools/testing/selftests/mm/uffd-stress.c      |  44 +-
>  tools/testing/selftests/mm/uffd-unit-tests.c  | 110 +++--
>  tools/testing/selftests/mm/uffd-wp-mremap.c   |  12 +-
>  .../selftests/mm/va_high_addr_switch.c        |  40 +-
>  .../selftests/mm/va_high_addr_switch.sh       |  39 +-
>  tools/testing/selftests/mm/vm_util.c          | 133 +++---
>  tools/testing/selftests/mm/vm_util.h          |  15 +-
>  43 files changed, 1377 insertions(+), 1475 deletions(-)
>  delete mode 100644 tools/testing/selftests/mm/hugepage-mmap.c
>  rename tools/testing/selftests/mm/{thp_settings.c => hugepage_settings.c} (60%)
>  rename tools/testing/selftests/mm/{thp_settings.h => hugepage_settings.h} (55%)
>  create mode 100644 tools/testing/selftests/mm/hugetlb-mmap.c
>  rename tools/testing/selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c} (94%)
>  rename tools/testing/selftests/mm/{hugepage-shm.c => hugetlb-shm.c} (56%)
>  rename tools/testing/selftests/mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c} (76%)
>  delete mode 100644 tools/testing/selftests/mm/map_hugetlb.c
> 
> 
> base-commit: 9a5c21a0791faf7967feea87f8f345419330bd2f
> --
> 2.53.0


