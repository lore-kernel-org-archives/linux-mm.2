Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75911C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 837996B00D3; Mon, 21 Sep 2026 06:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8876B00E7; Mon, 21 Sep 2026 06:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FEE36B00E8; Mon, 21 Sep 2026 06:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B95A6B00D3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:36:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88D58A1B79
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:36:52 +0000 (UTC)
X-FDA: 85237416264.07.F02D06E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id ABF8C20004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:36:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FwdWObAE;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789987010;
	b=SOE+HOYHNgQUcHQgz6x+JC0j7tUn8d/hNzXsewO4tP2J8OJpXLSASkJSLaiTLpY9S8wkFp
	mR4zqJ2utT0XRo/rp+VH0rVRyHt2E2tlkt663RVo2avprbgX/c4TIPz29sZ2eUFv7kSm1D
	ps94aMCjq5W7eE/DrRRiXjjaLRfOEYw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FwdWObAE;
	spf=pass (imf03.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789987010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uukzI0BW5Qs7BTwau9CXvWgwQOJaSd8oCPlQDwxrV9c=;
	b=t+15Ki+pXlr58BbitKGPiU6fBGzjTCgTrOjGoVcy9tqLKFMcVl6AQbXNxAcdTaPzDlVdPZ
	GP1dcQMVt6T/vmFPdldVAkysfsoiLjq52ey6aURdw2oKs1WfibMAWLz2+PE8XNfGbXCBQu
	Cm6IrArC/UHrPvFkGn8BQHO67q94RM4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5835F143D;
	Mon, 21 Sep 2026 03:36:46 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 50F913F86C;
	Mon, 21 Sep 2026 03:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789987009; bh=MO+WSWsiYH+d9XMV7jfY1UxupADO1N/mejVI9LUtSvU=;
	h=From:Subject:Date:To:Cc:From;
	b=FwdWObAEpdOS1tW41x5E2RIWUMyXVfuXj5IpLAEsjVWngzL6RLO/9JJuNONDIo6Vq
	 MDGmHOoQk9QPbSd3+NHOivynGblc6tSKLP8AIsdn+oFT678a3drmeGYRJPefViUJlT
	 IjmWA+v0vJ4etnBpLXTBWUdLEdKoUkhbL3SBU1+k=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v4 0/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
Date: Mon, 21 Sep 2026 11:36:37 +0100
Message-Id: <20260921-fix_hpage_macro-v4-0-cdea4fc6ce3f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALUIsWoC/2WNwQqDMBBEf0X23JTVqJCe+h9FZIlbk0OMbCS0i
 P/eVHrr8Q0zb3ZILJ4T3KodhLNPPi4F2ksF1tEys/JTYWiw6dGgUU//Gt1KM4+BrEQ1EfaGGNs
 OGyirVbhUTuNjKOx82qK8z4Osv+nPVbd/rqwVKmtIY0dYT9rcScLVxgDDcRwfqx/PTawAAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5439; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=MO+WSWsiYH+d9XMV7jfY1UxupADO1N/mejVI9LUtSvU=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQi8pSMLunjVUZ4Lzs+cfoXnA7TxP+f5fh5Ae
 5W4SjL8dlOJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarEIvAAKCRBt1cPRWsUx
 M4NZC/461rHv1OET0IwYhpw+HH9X0GcGOqSwPjsoF1PTRH4PBwdWociupssWhbQ8MrQ6TBPvbK+
 51mEUuE2FMXk24dykQwY/lG4yTqGEJpVjcEe8hwVztNCGbJfhn/cd59QUzGkm9h49La/wAF+G/k
 Eaz1951C5pMao1KQn2qDDLH9/GZc/Lcr9iTUvh4qNjQbtaYR/8nUs2RLMJKiKya6gj6UShRL6wk
 9PalJK+4re4HyODIe68KxisxYhVf5F1kVLkyzDNZ2irU+3W0dGB3xqslzd0+qFMT/1saC4H4O46
 jSS3cYl2mD55Yl5iX8zohouJVDGpp577ad/EF/ii7meFOCxzWY9JD954q0txl8gNbGDUMmIJbyD
 XSHfq/++LDilN1+C/3ByyBpukTeDW0xXIMi0v1hvZFOQB15/rCurCiz3o4gIto/9/zlUG378sZV
 K6vc2RHv+gfymSubnTrIHV042vLyU3GBPBMUJFenbW3wQJSBpGSsT4QV0ldyupUuqQgi8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ABF8C20004
X-Rspam-User: 
X-Stat-Signature: 7sq9n13bszdncp8is1ff315kxghq7dos
X-HE-Tag: 1789987010-360419
X-HE-Meta: U2FsdGVkX18CoWW3rCRdjBd7iqB49I2RU9ZsoFRD3z0ZF1tIEIWa0hr8LxiHH4P9MrhG+E+wNck9NVzjo/vFA+Pjis1wi/5QAOg6qdtssr6tV2SHLB57uQz3wv9wGFeZL0h4qyk2mGjDRArHKZ+J2/0op+8sVasoNTvRHM1sVHSj3Ouc3hKNF5Ph2XE3OciPGSEtYdEnzUFa0VGo8iV3WD6Jnt538B1dQgH6lni86i++JUyu7xrlPS7jpyfkvtf4Tjyl7yxRKlni8VGTXvqE+bc3lmzDKCDGDQ8kOWECyaNBe/ipZJCN1S9zxBv9jdixiad+jUF9E/arDnB9s1IhH94qQOFYAoB4Ju4so/+txW0NMFBGkf5jl6XzkGLLUDr5xwAC/u7PTTAZgwooykzvTbzvCvZZ7gXOGTyyr09w1S/MoQUD3ctLMfQHvvhiTwPjKKgqSXzCP+fN5T4udw1wnu0JQLw5ndGoCZOusaL7gjbooxiBA3cgrnUJCZKChmKEHCDBI1wavinxePAqQs6IMGjUMIT1Gii1+8L8AEMJQUrhUP8cMHp50MbQ7vDxHr9+DW4MlfFxYekk5dJlLwYUGZ5avYkJgnZJly9C0OUdr1v4B35bWhV8JJcYsXrM/lxeY+13u9ftqByzsKnNYAKRzEkdJ7WWUhyvVftrsQMBDFjkSyUlQJP6/6RkDMujLbs/MxsQSTbkmd09EwTpdxh96IGDBhvDfXpxpzJnCkhk1uhyKri0ukzOnmHDm4YhKbsTDY7ZDBOofP/Qtw9vgWTnSFr27KLw2xkbpXtxLnQ2ogOVZEfBT5Ddk149sZ3NHek6XR17nUIl+86j48hgyJDl1E2Y9wT17MSCCUNU4xNhsEn2OPe8SRQ+9r5TTGNCoXeljALftot85MjjEP58IQAerblgwZYAbuQHQuas2gMvSGyOT2RK0AcL9Lrnx58tBNCtkkwkXWzX0wqZ8/5AnUy
 6W169m9s
 6eWz55Njm2pvv2MeiEfafOYPwcOo10gb/Q/wjbXObpUv0WMiVfu44fK4/foeXc5c0aWX8VU/55eAvzSoz6tXFrZ44ZABi1kQRas1ucXgPz9DpiSlOW6M2IM8riVd8kS4Ur52cViGdpnSrs/2jSWIhcOfd8/GPIVwfdeFlvWl9Ba1QWCmKTG8xXQ9p1285/waHStLgJUvH1cOvZ7+uqfD012Bol0axI6lEmp2kj4Ost6aavI+Z66WEQ6oYJESrC+qtdjPUnDj1bBLQ7i7BQwM10+K/2iLijFN6EIS9lr+D/lKlP3toc5FcNZJ2hRa2Gc/sC1R1h2N+isKRsP4=
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
 tools/testing/selftests/mm/guard-regions.c         | 11 +++++-
 tools/testing/selftests/mm/hmm-tests.c             | 22 +++++------
 tools/testing/selftests/mm/khugepaged.c            |  2 +-
 tools/testing/selftests/mm/ksm_tests.c             | 16 +++++---
 tools/testing/selftests/mm/migration.c             |  4 +-
 tools/testing/selftests/mm/mkdirty.c               |  2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c         |  2 +-
 tools/testing/selftests/mm/prctl_thp_disable.c     |  4 +-
 tools/testing/selftests/mm/process_madv.c          |  2 +-
 tools/testing/selftests/mm/run_vmtests.sh          |  4 +-
 tools/testing/selftests/mm/soft-dirty.c            |  2 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |  2 +-
 tools/testing/selftests/mm/transhuge-stress.c      | 25 +++++++-----
 tools/testing/selftests/mm/uffd-common.c           |  6 +--
 tools/testing/selftests/mm/uffd-unit-tests.c       |  8 ++--
 tools/testing/selftests/mm/uffd-wp-mremap.c        |  2 +-
 tools/testing/selftests/mm/vm_util.c               | 46 +++++++++++++++++-----
 tools/testing/selftests/mm/vm_util.h               | 23 +++++++----
 20 files changed, 120 insertions(+), 67 deletions(-)
---
base-commit: 8d61431ed2607386b427752505379536eb634ce8
change-id: 20260909-fix_hpage_macro-da069ae04502

Best regards,
-- 
Sincerely,
Yeoreum Yun


