Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58211CA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 10:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FA4E6B0088; Tue, 13 Oct 2026 06:37:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D20C6B0092; Tue, 13 Oct 2026 06:37:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50E9B6B0095; Tue, 13 Oct 2026 06:37:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 210616B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:37:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42616A897C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:37:15 +0000 (UTC)
X-FDA: 85317250830.14.079ECCB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0E80D40007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:37:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KULdfHx0;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791887833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8Z53elo8aprPC88WczpZliO+t5ab0+pOR4X/jtRT/X0=;
	b=B+u7AyPLJibalDx4DBmub4JSToDrgN006oUwgX7g3oCw6RoIplCFIzsjKxF0ETSAhiiL+3
	3NylSwTdpZECA6YbMYGICz0eQ+nKKPVyTbzNvSHmiAhkbYLCAa4/wlkpdeC1oFKXJxq2wT
	jxbyeQ8oOiQugyHVQ+nmQwzp9H6ovl8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KULdfHx0;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791887833;
	b=pBmKoYGwamHjdXBHq4vk0fEgjyGxQyqLHZ2fvuiICZpBiDTpfwEYnIUf+tbA6UYt0Z0d2U
	8PtrhztIlBHPA14X9BO/gcNAxBLRRmo6ie/+fewl2125uCgLjeGB8oHD8zAJ+93RFm+pQs
	9iMjL1r5i0IB+BVFPEhD4FcR0EUor/o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96258169C;
	Tue, 13 Oct 2026 03:37:08 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E26BE3F7B4;
	Tue, 13 Oct 2026 03:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791887831; bh=0uN78WI1mvBBoBWP93Cgm5INI0kkPY9Q4xYy22OfXx0=;
	h=From:Subject:Date:To:Cc:From;
	b=KULdfHx00SBvxeB+Vn2e1gJ/ULQ0G21brr+mA1Wq84unD6dNiz6LMerJrOdhdLIDc
	 oH3+57fiy9WaJPjZzjSRzFeW1SjfcltZ6F6bZpQFX7yueFQhzKoIOSlSN9sJpLO2Sn
	 91k5RmNg6f3AfejFbQd7Lf40WT6YKQ+towxmY6EA=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v7 0/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
Date: Tue, 13 Oct 2026 11:37:02 +0100
Message-Id: <20261013-fix_hpage_macro-v7-0-3d77129e0557@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAM4JzmoC/23PwYrCMBAG4FeRnDfLJJlEsyffQ0SGZGpzqJV0C
 Yr03U2LuJXu8R/m+4d5iIFz4kH8bB4ic0lD6i81bL82IrR0ObNMsWahQTvw4GWTbqf2Smc+dRR
 yLyOB88SAFrSo6pq5rsyNh2PNbRp++3yfDxQzTV9dClddxUiQwZMBS6Ci8XvK3XfoOzE1FVxor
 dYaJx2ZsAkusGk+tX1rBf/8UWzVFs12R4yWYvzUbqGVWWtXtQ5WR8AdRjZ/ehzHJy/ItElmAQA
 A
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6000; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=0uN78WI1mvBBoBWP93Cgm5INI0kkPY9Q4xYy22OfXx0=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqzgnSDLIn5dW3u16QersuEpPlHNauoCsiaSxHa
 mjr1PIrb32JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCas4J0gAKCRBt1cPRWsUx
 M4sVDACpUSDrd9g+fkwNpcYHsaBnVRJd+tUCdMDBDKbIQ6N1rUVeEgzCC9YoM4Qol/BUaBQhJfC
 469D+uhlMiIPlvn26YIDs/tG7Ke9cKAFI/bPxlMndpFXoU+20XjF6GqqTVA5AOKy39WTY8Lcl2R
 nue1lotxHxTfeeAFqFLG6k0Ou/U+kV0qbUaPH9TPF8qFoKlWTwlwdqoYgrGZYk44EOac+BUg1lw
 BeFKE0PzO6cIUR5AorTywE8siwS4eZlaRzqm3fKfuZIL93QkkdxUqtoedkRYR0Kc6bK1O79rSCZ
 mQEUfqXObt2RUrglBv1ArkjdnlvPRGG65/8rXXv3Olh0UtYxCaMNM/mbIF3YOWbR1FYjXj06eSL
 Y5EKxsrYhw12ELZFy2Fyo10RGcfnuK2FglMQ6Z+C7iUaLSQEloJnxumfi9uoxKLpBQdmEW35nTJ
 mse+V3Y91jmscn76jNNLYGFA1n7zq+vEcas/qLwLdTtdfu82r+KKtK3ZYRuREBoidQoWE=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0E80D40007
X-Rspam-User: 
X-Stat-Signature: 6k6mmdi5usdhy7tt8t5r7bpfusyn5kqb
X-HE-Tag: 1791887832-209517
X-HE-Meta: U2FsdGVkX1+oS9R5vLuwiF5Hsjjl5+RtUJlM7dfdek5ulkvAHDxb/aJXdm4E01Hjda2WLiGpsJMoVmUZ4sDxI/fDpYy2ClSajIY4jsxFoWj7Fz79s5AtckIyidZ8ix8jqGMHVj13CbK6BuqogQIU/sUi2qj0H7n0UkGFhmHmajtsEJucMTkbMeq9imA80vnvgjeTrhHKrRLyn1AXpWuTM/uYCmprW88w0G4LAilTnNYLw6wf6LJrSSdzlML/6RlqFPPIs6pye8atLDsMkzSDRNCMyy+2sHSCRyWEluOyRNuiGrOVpFkM0yPrvAMxKJPT1P47liTn03c7qSBZTOUkgbPy5SM+cZ6BpMAOM9ijYPRMHFFH9LieyAFMMykizr/aW3J6/a3LuJqk0iVJnT2GMv+9eCC9qMLR8bfhU00rqE0DloeQga8gUgnk3GSloQNXZezx4vMLuyRmK52ncjtyyO0UPXRNOIJ6tbMg4cPNjE436cTl4qoltDdYy4UEJScwa7Vgo6Mh5LCqdZh5tV5g8+dn1IR9wSLmiVXCbmO2G0uE8H2Cm+haHadyG7wKvihcQ6I9M+1c+8Po8XaKanJY2nvFvcq5VH2vwm3KDhrUV9lKGKmyukuF1IAXFwZdoX7YF5hl8j+plIml/31tGWiN9sy38lfnp0kIRo1gTbTYV2s8/haF3/5+ValeYaBpdBA1tkX3JXsodASIu0GO6lsU/VpiMOaDZqBXcrz/VkkYRNK0it+nVfstbR2WR9sPrkDdD2VE5lDqdSks7wGiJqdDPUo3I33vLYfKrhOYJaw6749EfM4AzioaFEOJhrebnL+A8Pca+1nBmTfJQr1Ahwam8Hk1kevwozcWeWw1cj/x+Rwb4lg6F18SR3uwLxe/+TO9nYJBpZ+3GPwaNKKWmZ5uYdRmamKRBdWDufEyj39Dyl1Ce5/lO7udYiHOg0kP5Y1Q8Tzb7M+flPEXxv8Cp+8
 CG9hao91
 f4MdBv+TUCNQzvwAq+/+2eP7DdIpMtit+s1tqNK11zprf9RO3lDE1ktTs4UURa45lSsVCzsiDeRDH0b8XF2AFMOLdSSPM9bixQYcpZvYnONV29boLehD7DTAYYQsQSIz5f1ufefjtj2kU1jbx1vkBh/B56gUeazJFWiO8HJhXwhOClOyqs30+LcuWjWwqqcfxPX1YjB3TI3Q9LbjDIayRHKQS2seyYP2Cl0iHJCb6FJNpP6mhK808RwGi/KjKb7XnoGatUDDApABPJmhN9SX9GiU12kUGg+eXkrzFbGGPJmt4GnRQzV9nLqNmbeSI5GLz77SeGfwLUk3Z/lw=
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
Changes in v7:
- fix inverted condition.
- Link to v6: https://lore.kernel.org/r/20261013-fix_hpage_macro-v6-0-2c52d0484de3@arm.com

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


