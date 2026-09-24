Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A830EC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B2826B008C; Thu, 24 Sep 2026 15:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68A4B6B0092; Thu, 24 Sep 2026 15:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A14C6B0093; Thu, 24 Sep 2026 15:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 371DF6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:11:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3F6E1A046B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:11:32 +0000 (UTC)
X-FDA: 85249599624.25.FBC6AB2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id BC620100009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:11:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="UC/myava";
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790277091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7+d8kJ4k5DFS/q9JN4s6e3hZe7sFakzkREiXr7LXHGw=;
	b=V/qMo8guB1FZXqQAcu4fIr+YkchrtTnRiKqSXRoFVXMs2OWb6bpLIEtcAYltNxC3dTy5rF
	MXs7agbas1VeoyzMRQslEoRXV46TyQoUjoYdXMyo7+ToLEZ9l9sLIOR/XPArzq/821oG/U
	6zGDq12pvbcKAU3lQdybydYl0PL/Pjs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="UC/myava";
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790277091;
	b=K63M5srDACve3x87DGj3JQNyzYheyt9xO/Xq4UpU2bD+4HTtzF0pGdiZ2OpCiukskoAEaA
	vYrG0dAW27tqqs4UJjNlZKNN/0/78A801IS2jILE7u0zXWruQJtnpYy/LDrLuK25oO8IGM
	ioi0ctyct2G9LklfzixJfGCJBDVqy/o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DCDF1E5E;
	Thu, 24 Sep 2026 12:11:26 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 377863F86F;
	Thu, 24 Sep 2026 12:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790277089; bh=MuRaI8x6GXzrvwzPsbKH9WYnwNTgr9phZb/ghgk7nkI=;
	h=From:Subject:Date:To:Cc:From;
	b=UC/myavav/0wDURi/e5uj2wHJrDw+VEwwctECMjrr5anj2mKS+Cp+xTXTVJB2nCIX
	 3B0zs4MYI65fHMkSpfEnoIhHBpmXNcWjB+5mC30jeDF+PJVWlfd3xmoX3RzB+757Ma
	 DD7B0O4vG2wzemfy3Pr9Etn//5k5NFWuqiWEQvBc=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v8 0/4] kselftest: mm: fix some failure of
 split_huge_page_test
Date: Thu, 24 Sep 2026 20:11:15 +0100
Message-Id: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIANN1tWoC/23QTWrDMBAF4KsErasyGo3+suo9SimWLDeCJg5SM
 C3Bd6+cTcelyzea7zHoLlquJTdxPNxFzUtpZb704J8OIp2Gy0eWZexZIKAFjyCn8vXerp/lJie
 ioENORNGLvn+tuT8+ul7fej6Vdpvr96N6Udv0v5ZFSZBDJA3J+OTS9DLU83Oaz2LrWDR3njvdn
 XYEiMbbgeLe0a8LgNxRd95MoAOYyUW1d4Y7x53ZHGL0Csj4mPbOMqeIO9udsnl0CrUH+HOnYw4
 Vd667EU1OIShlAvuXdV1/ALSH+g+4AQAA
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4292; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=MuRaI8x6GXzrvwzPsbKH9WYnwNTgr9phZb/ghgk7nkI=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqtXXaIiT9BwKaFmYL+IRymkn1pS2cgMwCN8AJR
 jX5E9q/5yKJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarV12gAKCRBt1cPRWsUx
 M9CCC/4uKyIQhnU8tD0YMdkYRstxqpebMFuqAgDJCdJplKeWGziBfSV2btEkq3l6IaJ7C3bVHnb
 3pDEFPHgL2O0ZT7QVQfq1qgfFJ+mf6/TiHidHnFWNwr+S77h7ltwAi3V8qzxk/x1mD2shDGGbsv
 anYESYv4f82duEtnyksxxPfYr3596oLcHCJXnSt6tUJsOcxpuOx3Vz+4HVbw03hNErKtMFZaAJu
 SQyqC338rRMCsFE1Evz/UI2geKUtW+V0UeednqsNO32cH0B7O0a6Q0Dw6tayJoMDRkrDKwUaHk7
 2TcYBZqJ4Cr5jDyWUpfhgtU2vRigVuZtxfjomXTgTsMBogNAz4AQsDj385YN7FJOBjODTovX3AE
 WnAZ5UlSSdVRQuI8RuIDkrJeYD2xTmpmNehRhJNaFI+fFa6/7y+nyCM9BhcvlpBWrzqwlBmwLnd
 i12uy3RllTdMYX57SEYZAR1OyuxUu39IpgcEiiqjSJtqf4BOzdFYMkKQa/RRb2kmiU1Sw=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BC620100009
X-Rspam-User: 
X-Stat-Signature: 9h8yojstscjb5jhqhckypxahyho7sce5
X-HE-Tag: 1790277090-725566
X-HE-Meta: U2FsdGVkX19iP4W2CKiPykdG4irBtyydvpxJpDwWl78lOkn2s/FH4Z3xhDyZgmA0L+g4Sj22pyZxJ+Hdi6IyhnSvNkIe6lhT3Rpxw7UHtevqAKdgz/6rP+Xa1DzRYAW9Jehc76FDGjzAtCWfNcMGq+dMwh6sZrKHhtGN8hEnOT70thtgxPo34YKwsrbKpyfj0PIYteRLq8tSco08FLiQD/Ro/Riy+/JyAG6Xv+ZM27Yf4fMA60maad5v89qLe0jiekk70z8YIxkXtPiOhN3gax7Sxp2EpbgqwUnKpaYL/coP+po+0GLESHQF5TmGtla6eHXb0HYXf591GwtlYgPthXmEdFbG891kSDlLDRhbZRa8ax54WhZFdJudKPrezehm5D+b/fE24TZjWS9lfAQybP3IF+ISutaLWZMehcRaCBf70OXziRm1eSAQ0emCh24WwEOxzEGInKJWCH7tTFzk71KRm1zSYyFAx2SgEnW2VjBTfcHeUmiLI2uVpgqo7ZcSgwyUeaYCDiRAORyFoWTfIjM9wGbQxCd7A2SAL0zRlExHYJ2y1X6UpwT8BkmuZDtQJ9lrIrPMaSA+T62wQYiXph1sw9RIdnso+71375ha0Db6yxufOKg79hFkaFjJV3D8oJO7nrnXdo0jWRsKDmpj0KFjlPG6KK+SoU2HLf+GfdbqqtUlSflQLd8h3d5SrSmn5A0VmhyC6GUyVDJedGc30Z3mBylANC699mqolfqZgng3IiIEjZaFa74wuFXx1xLEHiicDsyk1OQpV+k4udeHzdlvKEw7m9jPtZC/i/gmBaG5JcHmuUb+gkBVHlTWqJ0Cqumr0z9ZLBIoZUTyxWLEfPF5Cqek8L51fXnqHQO7tq9/n/z9eY1AhGSdQ75mgGWLMvpfujU2HEi3whR2oQ3aTZEnMDxcNksgwxwJowG61JPLY1yyMXrVSJIe1NnATKDYnJa1aep8S0GinxSHwsi
 GeYSys6I
 sgz9gL89kjdBIp949yCXr/HnvC7hVhB+pU33VLflsjw0W82GWwHAqwyVrkNLK+U4PZKf3WOwvvmAu96eNenCfInMC5sjJOWFrSJqAeekpcWLWrgGxgvEIutkT2ZRuK/e08dpmyKhKEAKR4Y3pgWAlZrf/AoBEdd+GPlXtoR9Y8PptpZhBXxX2k8uCnX/AcFgiBeoEKYXq9gua5Qrl2UinUNhHAu10dPNVOXTkP+xzV4M3qkScilsv7pltaFM9YaPWzs5cxk5PX/dDApl9+duWeI6pJfmDWpFeNVzrm4crEZH9B4J5ZWucZgdq6R5ImhnHlD9gyDuvj+bu6gUEGbpGfXumtD3Wmvrcg/q+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

split_huge_page_test can fail for the following reasons:

  1. During the test, khugepaged may collapse previously split pages again,
     causing intermittent failures.

  2. Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
     glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
     made by memalign(). The underlying VMA may start at a different address
     from the aligned address returned by memalign(). Moreover, a subsequent
     madvise(MADV_HUGEPAGE) call does not split the VMA because it already
     has the same advice.

     This causes the test to fail because the check_huge_xxx() helpers
     incorrectly require the address returned by memalign() to match the
     VMA start address reported in /proc/self/smaps.

Address these issues by applying MADV_NOHUGEPAGE after faulting in the
huge page, preventing khugepaged from collapsing it again, and instead of
relying on /proc/self/smaps, use /proc/self/pagemap and
/proc/kpageflags to detect huge-page mappings and large folios:

  1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
     using check_large_folios(), since only the mapping type matters.
     This identifies PMD-mapped huge pages.
  2. Otherwise, use check_large_folios() to detect large folios. This
     covers mTHP cases.
  3. Check the folio flags according to the type of huge page.

Since check_huge_shmem() was required to distinguish shmem huge pages
because /proc/self/smaps reports them using a dedicated “ShmemPmdMapped”
entry, as opposed to “FilePmdMapped” for file-backed huge pages.

Now that /proc/self/smaps is no longer used to detect huge pages and
/proc/kpageflags is used instead, it is sufficient to distinguish
 between file-backed and anonymous pages since the ShmemPmdMapped is also
kind of file-backed.

Therefore, remove check_huge_shmem() and use check_huge_file() instead.

This patch based on mm-unstable

---
Changes in v8:
  - add intermediate patch for __check_pmd_huge().
  - add r-b, a-b tags.
  - Link to v7: https://lore.kernel.org/r/20260921-fix_split-v7-0-d25ec991159f@arm.com

Changes in v7:
  - change khugepaged's check_huge() callback.
  - Link to v6: https://lore.kernel.org/r/20260914-fix_split-v6-0-16ed7123800b@arm.com

Changes in v6:
  - drop alloc_isolated_mem() patch.
  - remove check_huge_shmem().
  - Link to v5: https://lore.kernel.org/r/20260907-fix_split-v5-0-822b810458bc@arm.com

Changes in v5:
  - rename madv_nohuge() to disable_khugepaged().
  - Link to v4: https://lore.kernel.org/r/20260902-fix_split-v4-0-85f03905f7b1@arm.com

Changes in v4:
  - reparse commit message.
  - introduce alloc_isolated_mem().
  - make madv_nohuge() helper according to suggestion.
  - Link to v3: https://lore.kernel.org/r/20260828-fix_split-v3-0-374022586a4b@arm.com

Changes in v3:
  - change  message in case of failure of madvise() with MADV_NOHUGEPAGE.
  - fix collapse_single_mthp (mthp_khugepaged:anon) test case failure.
  - Link to v2: https://lore.kernel.org/all/20260826-fix_split-v2-0-71153c7f579a@arm.com/

Changes in v2:
  - rebase to mm-unstable.
  - add message in case of failure of madvise() with MADV_NOHUGEPAGE.
  - fix wrong setup expected_huge in check_huge_shmem().
  - Link to v1: https://lore.kernel.org/r/20260820-fix_split-v1-0-ab430c58c7cf@arm.com

---
Yeoreum Yun (4):
      kselftest: mm: prevent random failure of huge page split for khugepaged
      kselftest: mm: replace usage of /proc/self/smaps for __check_pmd_huge()
      kselftest: mm: integrate huge page checks
      kselftest: mm: remove check_huge_shmem()

 tools/testing/selftests/mm/folio_split_race_test.c |   2 +-
 tools/testing/selftests/mm/khugepaged.c            |  38 +-----
 tools/testing/selftests/mm/split_huge_page_test.c  |  19 +++
 tools/testing/selftests/mm/uffd-common.c           |   4 +-
 tools/testing/selftests/mm/vm_util.c               | 127 ++++++++++++---------
 tools/testing/selftests/mm/vm_util.h               |   1 -
 6 files changed, 102 insertions(+), 89 deletions(-)
---
base-commit: fff9c87241bb46aa09ed3a91d6002cba966d7776
change-id: 20260820-fix_split-f44939ec44b8

Best regards,
-- 
Sincerely,
Yeoreum Yun


