Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0561C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:40:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC096B00CB; Mon, 21 Sep 2026 06:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99D036B00E1; Mon, 21 Sep 2026 06:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8649C6B00E5; Mon, 21 Sep 2026 06:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5267A6B00CB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:40:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 903DF1A0144
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:40:16 +0000 (UTC)
X-FDA: 85237424832.22.8180B4F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id C66AB180004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:40:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cxFF/tSG";
	spf=pass (imf24.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789987214;
	b=ThAajUAnitqN4lZV2meZ7HXNL3MT5UwGI/yxH0DMpwuxRrGrkExc0WlXJByxXF4lCFpFS1
	/+7AAxoAa4gjPExaxnNKhfKn9BGWK9D47UR11iGNrMSL4ufdzi5ebjJh5VSEieJR91L5dd
	0VuqtrN+S14A2owBkyvf/WCejZT6UMo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cxFF/tSG";
	spf=pass (imf24.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789987214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nGRkOBIqXQxxxsbcMwvLIJO+86RLDP2/nFzVAh93RxM=;
	b=BZtEXcAQ9+TS3CJ0S54niZvD902tseQyr94TBXI3XE+rJHgjtiRq2CHRDFNPLTzzzKchQ+
	OAHp+TNRY0eH/LfmETlGzAHlCmR5N+PHotAe6UuSrMfwx0U2KQNHAN59xgYnYDiTXlFeOz
	PKod0TNiw/zHGy/2jOWXzN0dMpE7lBE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80E08143D;
	Mon, 21 Sep 2026 03:40:10 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0873E3F86C;
	Mon, 21 Sep 2026 03:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789987214; bh=eEcKOlvZviz+OS9o/BwOzLKaVMvfJZjmjmnn1tcF9Dk=;
	h=From:Subject:Date:To:Cc:From;
	b=cxFF/tSGwTcESPt9tUIXLn3H7uhf+uCAjIwP7McoYDbOsQBDRzTAX7SmD6twC8pxs
	 1HQpTH86CFYuSSZssbRhPF3JgMYwLeueYu2ZAOR3nPTwmksvPSuWQJpuqjYi0+EprN
	 yaqf0hKMB9bhcmXvgx7E2n44EEdKKo6YC227yiw0=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v7 0/3] kselftest: mm: fix some failure of
 split_huge_page_test
Date: Mon, 21 Sep 2026 11:40:06 +0100
Message-Id: <20260921-fix_split-v7-0-d25ec991159f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAIYJsWoC/23OwW7DIAwG4FepOI/JGAPOTnuPapoChRZpbSqoo
 k5V3n2klxGpx9/298sPUWPJsYqP3UOUOOeap0sL7m0nwmm8HKPMh5YFAlpgBJny/btef/JNJqJ
 BDzEQeRbt/lpiWz679l8tn3K9TeX3WT2rdfqqZVYS5OhJQzAcXEifYzm/h+ks1o5Z9457p5vTj
 gDRsB3Jbx39uwGwd9QcmwR6AJOcV1tneud6Z1aH6FkBGfZh62znFPXONqdsPDiFmgG6P5dl+QM
 5aGsZgAEAAA==
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4056; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=eEcKOlvZviz+OS9o/BwOzLKaVMvfJZjmjmnn1tcF9Dk=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQmISXAW5/OuRPdd3iSJezNDNx8zKcSXlaZRY
 c1lFqUQpAuJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarEJiAAKCRBt1cPRWsUx
 M/pUC/4qHK7/4NifLumv1mggmsHkyq908VAh96FDwf0nywEkR8pjtcGnIf/fI2YGpxVdKtBX21L
 IpYF3NZsWt0nkk3Jgjr5HWuMtLJCkIJS14L6QUWdr5dRbOpSRMHny/zYlAhu2QYQk7XW4vJu9Fz
 LbuGyQG7Xy/41PPJAROx5cwaZbRuSj21onU4bA8HNvR4yVpU5nSSrIxshpLh6gvn37pAFaxh9q+
 1EvqLZRGrDpRRytPx1/Z3fwdAMpgkylG5vvdw0QrSYTlaMn0XYBMOkwxZ8IPbKFydq10LRd3n3X
 ORDsDjBBTcS5QgLiZaMIgNlv8zi0c62s+mUpIdL20LCdXgulKh1HlnW4tq3eohjnCI9jBwuooWK
 jL5b1SN9aOMHi0b524cXyrGyx8SfSCxkvPyazjszWXxxpiUoY6/8kELI53Y99d/sIOMsj8Yev/b
 TRWmuUI1HFUPvwZbhcJINU9BD9ariMxFN0VQjL1Rbbos3vi+6YOtk0Pxf2P1pBXQhPLTw=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C66AB180004
X-Stat-Signature: c87y873yciaqnzmp5s77k1k1ispiy1t6
X-HE-Tag: 1789987214-392736
X-HE-Meta: U2FsdGVkX19drTojD2gJiLI05cX7M1zL9NLmmQQqzZQ+H28WoD5p6+XJ7c1ZUNrH+T8UZW1ex40z4npQBLni2dQmDOdtKHImwHumb8O4urZQlqTN8sV2x3Hm4YB+NPGn2CDMOjb+nx+K3D9Ib7kIPFVS2jH+dsGAGc/ZaNFPSB0vjLg2Eql3pKrmZv4rXdZdyCeyCbJj8ma/Jn+YU8qSof0b8jUrNsREsgsttaGWnCgtjHh+184J5atdgR462IezcPafj5v5LjEVHBwfThJm/dD/P6qGvJ0e9DgNJ8yyt1NCogWkJOCcaGI70PO64AW6ylgYbd2usy7gH048zKQCBjc0ulxXbshSV7x1Pas1DcRJz+m7ttxYDresyQVHxj8htbwEoVe4LpZP+jm1V+rNG6gsk/dgUYGJ0D4pniIDYpE0oXcNKiMJzzqKZoBlu3D6+J1ruix/9kNOLCzmWex66DmcE1qPyRZPEQVFDBTzI792wQ19Nra01Mf+9nvdSBTHRruYxbpu4Ll0HHrzW/xuZyqbEj/I315J1NNBOL88tDERzkhzGaAN9d2AFsCugrH6scAUSoKKM0zP7eaRV42TbHinWEp9p8gk6aFHlx+D+0IQl8Y/GRUm2O9yQhmNJubOZtgADzj5W2k+1aQy+9bnD42v2TgSS9b9lq/a1Iy11FysrKl3l5qiVgrynAn+G6XCcnYJNqtEAeEiS1Noh3zfKyoyVZuhBhn4ZWoe9R4EHS8gZlfuqt8GmQGWNUobsAO3WQvIx9oEnTw3FeCNzb2SiBr7RoSs6UTMQumhH97PVaryGATi0Ja3p9n5iElR0cCCJnEBHPcfSspOupVitW4tIAqnUuH+t6xv/tnuFkXEZrLfBiAO9JoR5GNNXzQWAgsapsgvap9/bHtt00n2NwH2eSkqlMlTiGHBnpgr+MvOl6bsW2D41t9de+o4NbWCVGi1kF3LpgYI/cxdBKXLdX6
 vTe+yI6i
 kNtZQ7Cl2OyKGpzXFWxjU5ZWLDMevYO7Ldx+V2GiaIQ4NAM+hmZf41+iFzaX6c0WeOR5mLzbWgQxdOumrLFlj8oVhZPELOCfQtf6dCtvuKVap2dih2eCPv9P7rFqVzdG1KXGtXPiqsHa+vceeyCWdcWvQXwBxb5dHEmKZhkQNIQHYMBbclWyvbJDD92HZwjo01dfYdCstuAgJtn9LCfwIZYxp4QF0W3XvXLYLH4+kfD4Q7SgtBGOedmzwaHRMP0bA44XbsbCwNGADqwSEtaJRw5YRw8DDzDxpXQAfgHc98di4Vvpua09TxD33TkoPC/86pGcOUmQwAPBNO3djqYi2/FdiLWfro66rxFnu
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
Yeoreum Yun (3):
      kselftest: mm: prevent random failure of huge page split for khugepaged
      kselftest: mm: replace usage of /proc/self/smaps for check_huge_xxx() helper
      kselftest: mm: remove check_huge_shmem()

 tools/testing/selftests/mm/folio_split_race_test.c |   2 +-
 tools/testing/selftests/mm/khugepaged.c            |  38 +-----
 tools/testing/selftests/mm/split_huge_page_test.c  |  19 +++
 tools/testing/selftests/mm/uffd-common.c           |   4 +-
 tools/testing/selftests/mm/vm_util.c               | 134 ++++++++++++---------
 tools/testing/selftests/mm/vm_util.h               |   1 -
 6 files changed, 108 insertions(+), 90 deletions(-)
---
base-commit: 8d61431ed2607386b427752505379536eb634ce8
change-id: 20260820-fix_split-f44939ec44b8

Best regards,
-- 
Sincerely,
Yeoreum Yun


