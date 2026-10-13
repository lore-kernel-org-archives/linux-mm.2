Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461F7CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444A06B0092; Tue, 13 Oct 2026 05:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41BDD6B0095; Tue, 13 Oct 2026 05:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3320F6B0096; Tue, 13 Oct 2026 05:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 028546B0092
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:46:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95DCEA03FE
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:46:21 +0000 (UTC)
X-FDA: 85317122562.10.B980EA3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8F616100002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:46:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fpMCc4pA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791884779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FfPfP4QhJKseagvaZpxGKoAqLTYasLWQKV06zw0c7eU=;
	b=d9Bi7349EUfEHgYvRPi/J3dU6tls0L/wdEBHg1EDOj7Y+xy2apZz5A6qDZbrlpk8DlCo9f
	cWA5N0XWX+cQYqT3g8VPgBAdVuOzWaMeVlWmAX+oshrTCl99W1j30PKlZ8i5PPU1dQYPjw
	ZGG+TcYJZN1bqrMMjbdYqatise+t7P8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fpMCc4pA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791884779;
	b=gZprJFme7WOB7oin+7t5xuf6270F+Q3c/dRQNi+NzNDqEroZg4LEYqwaIK3qvtoZ1ylKbP
	iGyG02iiqOCyQUzVEc64U9khVxG1zaB0+n5gWmjxfZ+U0T0NwSHlmrY+Hz05xnAhRUC1WY
	WnFVcja27jKS7IzVEADWPRq39ZCTNoY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75711169C;
	Tue, 13 Oct 2026 02:46:15 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 35DA83F7B4;
	Tue, 13 Oct 2026 02:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791884778; bh=Dvxi4UcnV8EfMkMwlagrsaj+FJ236sNPUc/9icWdcFk=;
	h=From:Subject:Date:To:Cc:From;
	b=fpMCc4pADCI0HrdE+ZF9uvoVHRBECnNlp2ZP7hfrVwJxvzQOaG4GipyUglyz/Smk8
	 wGcZ1FdG7swfYPiEJe1TGJYfewAT5qP2vAN91b8fcSHQahPB+wkvpE5U+Y/NMrZQLr
	 q4iIkQLF47fM4CHscSQglHFA8C7l2ZMktS7Fm8I0=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v6 0/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
Date: Tue, 13 Oct 2026 10:46:03 +0100
Message-Id: <20261013-fix_hpage_macro-v6-0-2c52d0484de3@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANv9zWoC/23PywrCMBAF0F8pWRuZNkk1rvwPkTIk0zaLPkgkK
 KX/blrEB3V5hzl3mIkF8o4CO2UT8xRdcEOfQrnLmGmxb4g7mzIroChBg+a1u1ftiA1VHRo/cIt
 QaiSQCgqW1OgprayNl2vKrQu3wT/WA1Es01dXLjddUXDgRqMAhZBboc/ou70ZOrY0Rfmli3yr5
 aItoaxNaUjUv1q9dQ5//ogqaSXF4YgkFVr70fM8PwEGfqPsKAEAAA==
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Sarthak Sharma <sarthak.sharma@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5863; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=Dvxi4UcnV8EfMkMwlagrsaj+FJ236sNPUc/9icWdcFk=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqzf3k5yZXNxhcjn69gl72vzxL2PDv8otU5cYDj
 pJUiOBTpKWJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCas395AAKCRBt1cPRWsUx
 M1glC/9Senkz41a/iONu85NMt4pbyr3nsZaJ1YqwpUDkc8RJPaX3JXZvXWqkSyGQFDscQq8fR7s
 GiMDFWQNqEcHKhKUbPOgMAbJKWChoGTpGg+Vorvor2Yn0u7k4htFeGX/AJAUGlezOEy6y/BCKjd
 5SI8H5sYvALoDb2ZhhC87xcgFvkc7I9WHs4qvjhwO88Y4PRffkuPGWBHix41o1rMTMNXE0pumni
 sLUA3vOm8pNMWWNlp7puZZonQhCeySD5tUdCRLr1/JpNcPpDeF4H0BYHHd8Dy6bUF45lII27y7E
 cYitYQmOvoptgSpEqSJ2HFURKDDnB4hZU4VO0uJD2gUxM2pyUDjqfXLa6fXXIQjUeubeckKZRz1
 gDhKeqy+lEkvX935rxXjv2GWWoYOelcDn8ESXWrA4rSOboQnJKcPPyZQupv0UDphAsbl+b1426a
 M9BVMwlze4wiMSZ1bB+ai5LJSrTpll7GcuVY4J60kHoZYokPHSJQYuSX08sreCpcQoG6Q=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: a8cuw7ofzjpdepzybc6asne6sergw9xr
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F616100002
X-Rspamd-Server: rspam08
X-HE-Tag: 1791884779-590462
X-HE-Meta: U2FsdGVkX18/FHOCS9wVUDx8rFIvgC+C5bnXUO4WvuS5X+9PiXJV6V/LHx+XjU/j9XBNsAAVZJ05t4J8hGhErTfcIpAKuF1X5meuJwMyrmx/eP+fQP6kZUZ78sRBUZ2p8IvL8xs6/IOylU9ak0vEOJRsqa7vz9kc8I4+vguIln5bXDRuANpZKnSdFMIkpRQUgTfAFUTo8y67M/tZnaOP4as/G+BcZm4zIN1jTw+h15zeuOb6bKRjsFJ06ZE1sHKUgeo2ToMC4F44WyZKmNRX3oj1p1espQjSYPafxUb3kpu0o6mdw3nTeIj3YqDUInfqWAX0l06oEs/Uhp9TpQpL3RAL4GTDubI003/ZalSyF2wPzDcfYWNNA2gw+IbcjmkT8ZQCmjTMA17vOOoXo5OLurCLLUxQnIibPO4Mc3dDlp0Gwx2r0rE+swlViNrqRgiN0CSvdsBhLqLM6ealrcZwgyx/re8Jws8Jqxlp+gwM1KPrZIp6VBnhQUDLx1oyRUBrZJxREMEamSuabie0bDlOTUe4zpbwOTwDoMAkuAtaGTnwxRAcVA/DGYjJZ9VOQyyEwf8ORotQRVVG/xlhh95nj4Q3CKvD8236n9SDqswiV3AeJiFhwi9VSClaWQ/DVqMtsbhsClygbuhKUnOYFwmVMyjHgPRfpT7iqGIQgKGkIASTYoVp4QE8EEvdXPIIa2RQXdNXksQR10Q8RYjCLFtmy0u5y7R8T4V7AYomvFqy9iQJHW4sRmNdLxTAEk68AeLEPqA1WgXo1rVz5mV6Fph6KADvJ6OpedlqGzpnKxzSiQllBA3gEzEG7nrOvwA8C1/oOBKrs9k2M5W95DzronkOA9l8IuSJt/1e3vmCsSLp2ikesbAsrafliviTY3m/JDdmxxHKOfTWiKi1qkVQ2s1habXM1w/scVFd1gRBPGFdRiQlu3S/4qEGwUlqmAW1zp+CMDR4sbZE5SOL3JC3gbt
 L5nfnQSK
 Ya7xoM3IUnxVBjzienngDK8b9IReYpm4MXdYwh3KuVhsSEj338obJvdnGl/9BUrU3ixOeRFF9lkbFouXRBzAEFdQigoLnNxq8Rm6XXb1QxwyxC6rDCMSPdH06o2nS/xU3FBLz4yqkOiERJ7bb5FQShzerLPcgfD542BRiICUnCJEc9d/ZFpd7W4nf5N3tysgE8DYgAuiVKdik+yZbkLAoBH3GdhOMUFHdRDWyCVC+oTDddhRdrKpP1GyIu+tEp3FYeBTX1KiQ8DoZoVYD91qh3P+8eeOtCeMOEiwxgQxmx/tppr7+k0rdEcmzh9UhZstA0g/H8SaMjfqVUyY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
When this macro is used in some test, test result would be strange in
the system where PAGE_SIZE is more then 4KB.

Here is the example with transhuge-stress test with 16KB PAGE_SIZE:

  transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
    3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s       2566 succeed, 58507 failed, 2566 different pages
    0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s          0 succeed, 61073 failed,    0 different pages
    0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s          0 succeed, 61073 failed,    0 different pages
    3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s       2566 succeed, 58507 failed, 2566 different pages
    0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s          0 succeed, 61073 failed,    0 different pages
    0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s          0 succeed, 61073 failed,    0 different pages
    0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s          0 succeed, 61073 failed,    0 different pages
    0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s          0 succeed, 61073 failed,    0 different pages
    0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s          0 succeed, 61073 failed,    0 different pages
    0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s          0 succeed, 61073 failed,    0 different pages
    ...
  ok 1 Completed

To address this, remove the HPAGE_SIZE and HPAGE_SHIFT macro,
introduce pmd_pshift() and rename read_pmd_pagesize() to pmd_psize()
to keep consistency with psize() and pshift().

Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
PMD-sized units, the test may fail with the previous size of 100 MiB,
which is not a multiple of the PMD size when the base page size is
16 KiB or 64 KiB.

After this patch, output of transhuge-stress:

  transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
    2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s       2585 succeed, 1232 failed, 2585 different pages
    2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s       2585 succeed, 1232 failed, 2585 different pages
    2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s       2585 succeed, 1232 failed, 2585 different pages
    2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s       2616 succeed, 1201 failed, 2616 different pages
    2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s       2627 succeed, 1190 failed, 2627 different pages
    2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s       2628 succeed, 1189 failed, 2628 different pages
    2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s       2630 succeed, 1187 failed, 2630 different pages
    2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s       2631 succeed, 1186 failed, 2631 different pages
    ...
  ok 1 Completed

Additionally, introduce size_to_shift() for future users that need to
obtain shift of a huge-page which is other than pmd_psize().

Patch History
=============
Changes in v6:
- add r-b tags.
- small change for declaration order.
- Link to v5: https://lore.kernel.org/r/20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com

Changes in v5:
- rebase to mm/mm-unstable
- Link to v4: https://lore.kernel.org/r/20260921-fix_hpage_macro-v4-0-cdea4fc6ce3f@arm.com

Changes in v4:
- make size_to_shift() as inline function.
- initialise __pmd_psize and __pmd_pshift with -1ull.
- Link to v3: https://lore.kernel.org/r/20260914-fix_hpage_macro-v3-0-c9a305a01d39@arm.com

Change in v3:
- rename read_pmd_pagesize() to pmd_psize()
- introduce size_to_shift()
- Link to v2: https://lore.kernel.org/all/20260907081509.924979-1-yeoreum.yun@arm.com/

Chnage in v2:
- rename hpage_* to pmd_page_*
- Link to v1: https://lore.kernel.org/all/20260902175611.1241118-1-yeoreum.yun@arm.com/#t

---
Yeoreum Yun (3):
      kselftest: mm: rename read_pmd_pagesize() to pmd_psize()
      kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
      kselftest: mm: introduce size_to_shift() helper

 tools/testing/selftests/mm/cow.c                   |  2 +-
 tools/testing/selftests/mm/folio_split_race_test.c |  2 +-
 tools/testing/selftests/mm/guard-regions.c         | 10 ++++--
 tools/testing/selftests/mm/hmm-tests.c             | 22 ++++++------
 tools/testing/selftests/mm/khugepaged.c            |  2 +-
 tools/testing/selftests/mm/khugepaged_race.c       |  2 +-
 tools/testing/selftests/mm/khugepaged_sync_check.c |  2 +-
 tools/testing/selftests/mm/ksm_tests.c             | 16 +++++----
 tools/testing/selftests/mm/migration.c             |  4 +--
 tools/testing/selftests/mm/mkdirty.c               |  2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |  2 +-
 tools/testing/selftests/mm/prctl_thp_disable.c     |  4 +--
 tools/testing/selftests/mm/process_madv.c          |  2 +-
 tools/testing/selftests/mm/run_vmtests.sh          |  4 +--
 tools/testing/selftests/mm/soft-dirty.c            |  2 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |  2 +-
 tools/testing/selftests/mm/transhuge-stress.c      | 25 +++++++------
 tools/testing/selftests/mm/uffd-common.c           |  6 ++--
 tools/testing/selftests/mm/uffd-unit-tests.c       |  8 ++---
 tools/testing/selftests/mm/uffd-wp-mremap.c        |  2 +-
 tools/testing/selftests/mm/vm_util.c               | 42 ++++++++++++++++++----
 tools/testing/selftests/mm/vm_util.h               | 23 ++++++++----
 22 files changed, 119 insertions(+), 67 deletions(-)
---
base-commit: 7186f1bd21b9094cc063c10f8492fd135522d3cb
change-id: 20260909-fix_hpage_macro-da069ae04502

Best regards,
-- 
Sincerely,
Yeoreum Yun


