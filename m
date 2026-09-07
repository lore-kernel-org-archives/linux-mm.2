Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73139C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96ED76B009E; Mon,  7 Sep 2026 04:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920056B00AD; Mon,  7 Sep 2026 04:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F1F6B00AE; Mon,  7 Sep 2026 04:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62C3F6B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:19:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 009C9A481A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:19:36 +0000 (UTC)
X-FDA: 85186267152.14.E4BD36F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id F07B940002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:19:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fks87+pQ;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788769175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jOWfJqisT+i1JkQx2aTNyg1KyAvkKL3CgKDVUahZQPE=;
	b=HoJWel3PazPXP+QuXHiCVH9C/couEuMmNiC5Xaq9dxx80vpmgxDVj+9eLRCToz5YmX8EAC
	dKC2raMTwOfdMZigCpVybS3IZ4U8RIX4BxUGkdshGvcL1liSHi0luistFNOG4OI3JlHF8G
	hq+Ik1DcY6Rv46twa4rLVHIKfhBRe24=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788769175;
	b=4WSZvN9I9aLE0XuLxZMcipNXHSscsrw70+MvA39NHFRUIdxdFLoM9cpbbKcOPwxNVgghAN
	LeY8C/Z5eAkjZuqxDYZvGvgukzyJ4FTuzVbLu7Npgtp4eiTycf3lvtBx9nk2e2LmR7aw5T
	VQbksGdh3PrOiAT+uAtUWAWLO7f4fQQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fks87+pQ;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79E621477;
	Mon,  7 Sep 2026 01:19:30 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CD693F7D8;
	Mon,  7 Sep 2026 01:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788769174; bh=JS+WBqmWmrP2fdC1UeFFZUubf/2Ll0DO5dqgbi/DZMw=;
	h=From:Subject:Date:To:Cc:From;
	b=fks87+pQ8CUppKO9fEJDQS13VXKNev81oluHPjCSMNr4mO8NGp8ItPK34GYtO0XQ6
	 JeJzBZ9cnbFNsRI0pZs2+mbKZ6nUEAFsfgY2JZNsy77xya6NR819cgJwTtrbTR6NtM
	 Df3xr3hmgmQEaO4mFJrfd04jRc8Y8e4EwWQ00YZw=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v5 0/3] kselftest: mm: fix some failure of
 split_huge_page_test
Date: Mon, 07 Sep 2026 09:19:25 +0100
Message-Id: <20260907-fix_split-v5-0-822b810458bc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAI1znmoC/23MTQ7CIBCG4asY1mKmMLTUlfcwxgCCJbE/gYZom
 t5d2k1r4vKDed6JRBu8jeR8mEiwyUffd3mI44GYRnVPS/0jb8KAlSAZUOff9zi8/EgdYs1raxC
 1JPl+CDZ/rq3rLe/Gx7EPnzWdiuX1XyUVFKjSyMEIaSrjLiq0J9O3ZGkkvndy73h2vEJgTMhSo
 f51uLka2N5hdlI44DUIV+lic/M8fwHuAcm0EAEAAA==
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3502; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=JS+WBqmWmrP2fdC1UeFFZUubf/2Ll0DO5dqgbi/DZMw=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqnnOR4knPYbXph4THLv5aahxcy3nFmOr67YDBu
 Ikk6BgXFYuJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCap5zkQAKCRBt1cPRWsUx
 MxwFC/94h60W5/bgOuiN6T1eWWPcRTmyR8sgt8i3utKJkv9p33t4rzj812FPIhmNEK3/U6AQ84b
 Yuu3t3jsbi+gkNg5Cq+teedoStA9FFwluk5xsCULbr9p/wbyU2WLLTumdYRPtOYSOzBRIcV4wBW
 O8UqZ0qTBagHJ8zIkLkJOLhsejbNw5/GCIJ32g7Rwzm73GQYcMnfpFPmmV35VUok/VBQm9PhuKa
 YBrOU+ulrwhzBHTUPlCWH6p0x/lDXKyA0f9sAH5DL/NQBxpBxquD5NV45F0fdG/10c9W3DVP4ql
 8b/LMfBjJJvmjm4SzuADBuwq/yGC6SE0k2WSJEoEWMGjzSEFUnbRF2ZmYeMsF20kwoDFJ1Q9cgm
 sEyJIJUdpIPVCGkE08iSYZtcbkv48/RrJiJGU7YhRQ9sBfBZ2kTRsSRctDz0/7AXd8+Nrbw1sID
 GsDkOFDnjj7GXtIt2jKAL6xiQwCU3zd15e2p4cMHTSVX8F6JYr8kyrqWJHiCa27pta5YU=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: g4ruua6kss83rtdx5ck3kawwfnd4fbct
X-Rspamd-Queue-Id: F07B940002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788769174-43483
X-HE-Meta: U2FsdGVkX1+awM16ZF1kJGD/XtY+T4+sKU9IjSeA+hh0xDlujpIZUnB0HUKrHFW4eqGwinpn6jdWih2YSEZq30RjL7HgrUK0PNy55DHrS5cgmam7v2vIQ+GzEA+K+A8X4OcZcbJ6QHu4buhlShOd4vyXMQWiB6H+ChE9mm675F3SOTiBsF34pW/nyZMzJ+dCI+GI2EjebD8wB3huowZKJszEPmMeuaIzsc1JZBa05mBqVj6zUSYem7pUsHcex5F3NtAS2/o2OCDNtEj+eDSpm68tydEq/iY732MaqAnwdAvsGwpJ1wx3qtcrc9dD6SolOfQd6ddm97z7aQIGmxckuVLvZREY/SNv2wPB4fpqrw41wBzO41r8Y1e7B9Zx3A142e12e/77h1YbWqcMHIpjqICN/o1hInmtXQK87bqaHMnBXFtDFaEfh3BLAm78unkV/dgMB2MEAMyL3eX4xXleoYcjMPEMYyWr09JXXGj1KXFikHxdh1HDiQbKMtwH/IT0YeofjloMvY0JPd7K/V9yhPu94397oGiCGHo6lwPJ2NCjveOPVSFyObW0HGHrG+6cIy67oJWyxFEnlKc7Uu9LpplKi9dawTgXj5D3b1+mr3K94pshNjpyx+YyL+bVcWPZyQ35AwSSG8Ig4mromW5kg4+zXkMppc6FRkX7uCL20FDOPPeRN7U+yiiZHLzcQbrkNKLI7lV56eGUhlO2kV11G5SrLCAjicwyhkd/rpuU/DffPMGm2oi7loIuvdBduK3h9Qf+i8cJzdOL8yNzii/Scg0xF8NnARR/Ebe9RX4ZWxR0NsrimzK1edKGyo+u+ZBpyL8tt7r4LyCQ/PfUBAptXUkSi0CSwmUFGjFEtboE4vm0hxNVWa6rc2g/kb0NnYtOqU+Gz16qT5xLxyoQreGj2SrU5BtsRlFNS3dtXN1o+trVqSFZ13D8UqezxsIdsaNAVFvbicRnVEkV2N5uxia
 +gQqB8X7
 Bf6Y/8TdU2eHwA+CXIy/3wKmDfpi1/5bBU9B8iNbFuCqkFaxKUFA/d9HSlBvXrbcCgfRIfluU1DFC1DqNtemQb1Io0Ps0MUiIj7G5dOnwXGv0K2dtNM08vWS4oEKMC4r0m7au1s2Hh1Tm42E8U+KwrUHajgXx9qDkcQzvZe/hRlW0tp2R3L1ZTmIVpJaeWpLsSM/CNwgHvrCx/+XWOKNLsMzYBHqfHQjFVrJzHtao/W/yqLMWbcLtC6zpUibZ97MdrKCypwByfbTG+X9tAroe6gcgQ0tPkFZq6af093oKH68DvOtdVN0J17u5RvISsPQriT2UE4pnrlK7+n3T3M/Zxz+BBZC7o3pW2W2e
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

Also, current usage of memalign() would result memory area may
unexpectedly merge with an adjacent VMA, causing tests
that inspect it through /proc/self/smaps to fail.

Eliminate this potential source of test flakiness by introducing
alloc_isolated_mem(), which places guard regions before and after the
allocated area to prevent unexpected VMA merging.

This patch based on mm-unstable

---
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
Yeoreum Yun (3):
      kselftest: mm: prevent random failure of huge page split for khugepaged
      kselftest: mm: replace usage of /proc/self/smaps for check_huge_xxx() helper
      kselftest: mm: introduce alloc_isolated_mem()

 tools/testing/selftests/mm/pagemap_ioctl.c        |  18 +-
 tools/testing/selftests/mm/soft-dirty.c           |   6 +-
 tools/testing/selftests/mm/split_huge_page_test.c |  27 ++-
 tools/testing/selftests/mm/vm_util.c              | 212 ++++++++++++++++------
 tools/testing/selftests/mm/vm_util.h              |   3 +
 5 files changed, 192 insertions(+), 74 deletions(-)
---
base-commit: d118502628f8b673be9023db8bdf878f64a7ed45
change-id: 20260820-fix_split-f44939ec44b8

Best regards,
-- 
Sincerely,
Yeoreum Yun


