Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9866DCA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 01:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148806B008A; Thu,  8 Oct 2026 21:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9D56B008C; Thu,  8 Oct 2026 21:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F946B0092; Thu,  8 Oct 2026 21:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0AF26B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 21:27:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 564D3401E3
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:27:44 +0000 (UTC)
X-FDA: 85301350848.16.69D8CBE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7C82480009
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:27:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=E2idgpOU;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791509262;
	b=FA3kpMRvILzF2+/pdmzejfYyJ4uc3NOSX9EbLwf68PpEzS0jUqD9jqyu6dPHmodLsQm3du
	QDEWJVcOyGkT/mofUIz9wtxur4sndGYzLd/H9U32P/jXA0IAEtCGEnGMooAcVv5e/smj7f
	nq0FtEHu2vE/Fw2htat4rDlkkqCpn9s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=E2idgpOU;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791509262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MJT5yfYEjACA5yLPzHTWmp8iHDcIZTnM+2ShP/4w3bk=;
	b=GJSTM3S/EhKfZaYbmyqEOGup8zVThvsqJoP6GL9eX1lR8f/CCMa+BP+4+p399FIH1s6g/6
	TG0S4CtogudWVBzIrWgxfcyBX5KoFEya0MXOIAXsyNf7+mfKN3R4HFKcLrCuuZ5AXlME7d
	0dXfnSkCTK1YrCMbwm4bde/1bTJIFQw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F220D1692;
	Thu,  8 Oct 2026 18:27:37 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B99CF3F8C6;
	Thu,  8 Oct 2026 18:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791509261; bh=8x92RroQAPCZvk/AEKgM+Uol5X3ZuGsDFtawbRLZB8s=;
	h=From:Subject:Date:To:Cc:From;
	b=E2idgpOU0G+B5uuUGnNecSi8PDSOzpJ3MBHxUwY6ud3X1H1pCPTZgPO8WwzQ5es6g
	 dwuJ2jTmF5wgfOKHjNXYz2xlkS6Cj9dmOULEMUmHC/owOcHvgC3Ne8He9b1NV8JKmy
	 x//bTXlviRAItQvF7ujrSaRcJ7UaBtHQULfEoj+4=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v5 0/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
Date: Fri, 09 Oct 2026 02:27:31 +0100
Message-Id: <20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAANDyGoC/2WNQQqDMBBFryKzbsqYRCFd9R6lyJCMmoWmJCW0i
 HdvlEILLt9n3psFEkfPCS7VApGzTz7MBZpTBXakeWDhXWGQKFs0aETvX934oIG7iWwMwhG2hhh
 1gxKK9YhcTvbi7V549OkZ4nt/kNW2flu1PrSyEiisIYUNYe2UuVKczjZMsJWy/rNlfbT1Zjsm3
 dvWsup/9rquHzhbegzqAAAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5712; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=8x92RroQAPCZvk/AEKgM+Uol5X3ZuGsDFtawbRLZB8s=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqyEMHBUDds7eSikvsQHqtmfCgr9Mc4CwfuqQin
 j8FJgcndZqJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCashDBwAKCRBt1cPRWsUx
 M7GpDACDrBtukB8FSlBAVb0a/XD0FqJHPulc6DD4iMHUYYpwyakKYnmFmxMxzYZI8l6oCohvlqY
 EiItEY3e7/RX41AILcPvjeAz9vVhHHnm8GDrUa/9dsiHgAeBm1hh0TOK9jrG9dLyB71m06Efe+v
 5QlepppzhMK7dMxycgizukNHhkyiRCYOTDb/c32T9Q7r92E7dZzyhh1HW9NGU2RfmCBPTNisGwL
 cNHXPgJ6caQ1831yqwmLSpE2e7VMAhl23xHS1OuQOACCgb7v7d3MAziYiEdUrYcZwtwk49RmmBB
 EGxtWgV8C/gMxrDYmlemydLccj0RrCwN+K6Q2Eko6/U2vNnm1r76+iehghVAUipzebmHXgwo0UE
 DsjyN9RM5irUrXPIKeOM5Ye8bsF4GTws4V7xh+Ksy0ezi1EU5CsmL6F6BMZMPYVVx+dQzyhmDNO
 JIDUU8JzFhwTRAB9lX9qSm40jGN7x8bL3eW7i5M7xhih+ProFO2ydBJrLmA6JsWyJ2GDU=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7C82480009
X-Stat-Signature: n9zj33s6eqfzjzwip596qxeuhjs66xxe
X-HE-Tag: 1791509262-283943
X-HE-Meta: U2FsdGVkX19qkiJZ65GxfbQehPg03DzF9UuJnuhGP2V+CqJMqZUeDh/geSTT81UitRnFGb5iv3OCaIhHCx/sbTaDawoLP1tmZq1uc73sg4KzXySu6v0PikZGWIASCeL08CHEOKVfoXacFt59bD1PE0a9eor3gtUYabIV1KuDjOkho4njFXe3AHXAE0hfa2RmDzqv+VZRsGBiNqIjb1BnXOzJbdq/saLfmvE7n1t1FnJXPuX+mlYtvWYERpv1Ig87lcsAfUFv7Pu6HjVBjQY2GbaSJY14D/EP2pDpwmrwHhHK4+KNe6rMyfpIhPlhCIJfhoQzG4vsqcmgV04brw43llPiIdvDLZB0QO6Y3rt3V7QglIGDqLR/WaqaDHC5H+p1tcWAHC0BGysB7YlBoUm4H/TNeezmv2sDsvwk65FU7vpMD+4+L9aXSaHPMyEZSDSqIJa12HI5tQqKvyz5qP/BlGDxnZDxcHRULfASYSE027bU4KWX/MKVvqqtu1+AvVqLHGO946VGhmCoEeKZLmpOhNA0Zq6RBY3FNWRr4IskR6NcOX/ad4oBgqGlj36aeGpH8Xg2NsbJHkLUiTmEDwnG6LPoFdgC/FtU/YsRLbPhHIuuOciNEzigKqwZ5AeMNOJhAOrJ/ComtOOoPdO7CAS1h7wX5wd6vwJJPFjoUSToDjVatLkWlH6P4QPhP4FNup7VM4pN7dtm+57mq37PKBfD14N0r5G0BiprcleImrMgVh33/RnIyeyLsIUemi4aJeb4PBF0FM5CPOHKrbE2lzAzox7mmM5YPONc/1KWvR7F6eCvj2io1NC2bhA/l4AoEi3NmSznrX0/GPsrEMIwEyx7RofuZG0Gt6Ytd6N9x3yNsRS7a9agTHkUmYtEBx9yTnZxYvQmSP68Hg8pldsJEsUCr6lvdkak3U1OSUHcNVmb0b+UMG7xQ4z/xPq/RtIDF10hq6S3wAb+2Y8WJTMzht6
 QYnRnvGm
 a5qDGENNmL8cEdjpgMsYBA9ThqA85gsKtgX0RvwgOmcJr5avHYO1ld0SUYBHodwnbb1105emh/zF6KD3BuK8PeIlI5qByQIJ49ZF4+O5y+ipfJZTso0hmN+6Bv+7+19hHqnRQig94dyz7dix6USrrfcfKPpImhN6P/kksYdTkxEvbvTOAWWZYx+6YsvZBlKhMDOo2otrSbWl+CI8OuOW2RINfjD+xjTLeSwSj57mHXw5s/1MGOgDRMVF/43Osc3tx9TJ27z5Nua6buiJZ/hzXi6l+GNwSojSk5n6QXOSILqhXNe0p9qvvUFQ9L9blkDWuL7dThgSTwQUuiTI=
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
 tools/testing/selftests/mm/guard-regions.c         | 11 ++++--
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
 22 files changed, 120 insertions(+), 67 deletions(-)
---
base-commit: 3144b955cc32a1d4b6ed308c65f70c7de73668f6
change-id: 20260909-fix_hpage_macro-da069ae04502

Best regards,
-- 
Sincerely,
Yeoreum Yun


