Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 911CDCA5FCE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 21:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40FB66B0088; Thu,  1 Oct 2026 17:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0D76B008A; Thu,  1 Oct 2026 17:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B0316B008C; Thu,  1 Oct 2026 17:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01B4C6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 17:18:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8AFBF1A054E
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:18:09 +0000 (UTC)
X-FDA: 85275320298.09.CA20AB0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6D68C180006
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:18:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=m3xOepUI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790889487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nTnbkr6NV0s4UVnzHPcBxt55R6dxg+1VjK2dP33jSg0=;
	b=F4rROkO1KRREoE6mZaQWr5xPW263jA8HEa5UfmZYJxEanz3cJ/7y74Nc53uJv60tqmk84R
	8G6O5Hnqm4QdPFZbaZpznKWPpm9yr56JMoTX8RJ5RDRJyfDwoNCezfZ6/4Xj3CHBE0hK/x
	HOH58YGGPjLEGuRrotNicyP/I7JzNRE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=m3xOepUI;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790889487;
	b=N/BiZQS1TW+2T2Ogcmms2MlRBfDDN9YcF2f+9QbeRIBlI0fd7S8oRRn+ofPS7MP/Tg66Ij
	//HKbyOnJfttA+vDVWGp/GNIJJdhQ6k2CbidVPz91UQuBO0AeeFXBpg7Ike8H9pxceqoBc
	Y67Xl2aBVlTBwMFAp9aPVEX6qWN2HSo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35AA1497;
	Thu,  1 Oct 2026 14:18:03 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9EBB83F86F;
	Thu,  1 Oct 2026 14:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790889486; bh=elVZHf3wDmPU0tfGL4EH9o7DXhEwI7HvqsyNCh92HrY=;
	h=From:Subject:Date:To:Cc:From;
	b=m3xOepUIC8hdRxYywAiIF5vtRDekYWf/7c295Zg1wqeeeoAppiDD6ypWp0sWJe+df
	 QIMr1y0GfX5MbVVohQrIm7xQL2sle2zYASnzUEvqQKa8tNSMNqLvrpGMiPOO3nyzKn
	 YX0sgY3UT15ctZ5mpfB8OkFrpxs+NO5yzCV5SVsE=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v9 0/4] kselftest: mm: fix some failure of
 split_huge_page_test
Date: Thu, 01 Oct 2026 22:17:50 +0100
Message-Id: <20261001-fix_split-v9-0-0f4ba8bbdbdf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAP7NvmoC/23QQW7DIBAF0KtErOtqGAYzZNV7VFEFGDdITRxBZ
 KWKfPfibIKjLj/w/oy4ixJzikXsd3eR45xKms412LedCEd3/o5dGmoWCNgDI3Rjun2Vy0+6diO
 RVTYGIs+ivr/kWC8fXZ+Hmo+pXKf8+6ie5Xr6X8ssO+icJwVBczBh/HD59B6mk1g7ZtU6bp2qT
 hkCRM29I7919HQWsHVUHesRlAU9Gi+3TrfOtE6vDtGzBNLsw9b1jZPUur462cfBSFQM8LKnaRz
 K1pnqBtQxWCulti//wq3bzOPqgndGaTswo3u6ZVn+AFmT7f3wAQAA
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
 linux-kernel@vger.kernel.org, Sarthak Sharma <sarthak.sharma@arm.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4504; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=elVZHf3wDmPU0tfGL4EH9o7DXhEwI7HvqsyNCh92HrY=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqvs4J9kNPaSxDmOGK6cAuegoeJSlB/nC6jvHsp
 92wNFXht1OJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCar7OCQAKCRBt1cPRWsUx
 M1JfC/sFJzOYGspJBLB/MTgJIVH2alzwBjlzkrTRTPo4Zh0NKFh/Nx66ovKfSxWpLsll9rhdbFL
 i2e2ZA5IJbS57pbkyea0YnCXEwF4jQ1/K+CZf+jdzNZrZntfzLBdzx98s8m3+01437QXeyvYama
 BsnN9PNwvB6e+hs+q3XaLkw5YUP9e7izGSGOBSxE+luNEXaz3bBLrYx9cuGInQ8ptiAaTJ4yHEr
 FEE7vDFaQIJt5EJOXJ3uwmdzrM2F3Mzxx6R+rH+VOGLwu3VoJwhaViBAtbFV7KES6yvBzg7CsGb
 0U2hro+rZVBHL5CqEl6P059jEzIeV3kx4/0KDH6DKdpC8RvjlG59u5EjQgTZUmBeHIIU20G/kPr
 JkrND+KuRU+OOne1rp7qs5Ns4lJ/uIvjxwwJgSwrmxLYVApNM7WG4f8Q4Uzrvsc8Vmo9Ob4RKRh
 k/ruWgOh5dFPivdwV25w/qHVHEQXTrgGmKw+nXduP/S3VOA/JGy6Q471pC1YdiwBuuvO0=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: g8d11khugf4w88b7zzphmpnis3rbc7ct
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D68C180006
X-HE-Tag: 1790889487-577190
X-HE-Meta: U2FsdGVkX1+qujwV23mJ6dbaMu2W0FW38pVLD9WZWXCUwpOslxImb8R10UvXGs1it7qmtWeZ9e7EhkQ81oA87vEB1BL26fchsbFqRTAJ4Q6427pa5HHgRu0CJC8dz7RAGDPVDtyVVAGQ5iEmfJxiiMUxMmLRkE/LkLz4nWWUkDNE5/MVp5he2UHT3jSYVAqMvPl+GIKm5vVS3iF/8daxrxF2TrcU1hLqTrylMQbrjuI/iDz2N3DNZkTnC4Rrl0V29fdkOLv8P4fY8IK+t5L9adUmaMalWSql4LCnptjblmgUmnmCUMy6PQ/+4iPkYq0xnpbpk8MnUfiH8e+Ra+ORq+0FwJ947MR12kd45tr3RpjvaJt5rbxXkTCFaKRT2f2iZxZv8DP2TmRm6/VVMUSF49MJpRGJ5gkhFNxLUn3WO7AGNgH8F+c1/jqc5N4ongoUc8C7pTkdjxJFluccspwg9kiTosCFyQ1xkAiI2hKQJ+GqVFHqMIK96ede7cUqH5jg7YN+wcFZY0GLmGhxo+JzSXhr+N1XKUUOmt2uItfPqFWJ3+ESWpkdG2GRBhLHA9VjKk6H7aYSKUayviJk+GfLNSKPKkB/lzs+vcOUqpbHJCcBudVNBkYyEbPwJy6q0irt3e9klVCaN85B4hgABgbyjJAcWJc2PvmSldDzBNgLA2fdw9zP+KBqvG6AuFkr50au2IELgFCEnvjfFYwWcBgzg48MpvW+gLDuPLdrfImtiL1VSVSWA2Z6DkVkFXk5BEih2DTzg+jHdbe3pRQi6RGuObVjvWS6TJYFoQNcsdzmhnEM0aaKH3Q38qCl6KiTdhHECkx2CsLDyhj+OAY5rn8BX9vDg73gX5rU/DlLwcqnDlk0S9t5AEW8a7UPgWazQrgUXCSEFkGBVe1P6HqKkGxAvizfQ21UnSYc5A25+p3FGMFQjFY3KGlLYpnURQ5hefkk8TnOfSMHCnofK9qoVlS
 Nvk5wL8W
 mQ3UIlm0dNVoNUZFimDyseEVD26vWB8FQevtFPSxgA41ETijyCz5Dq7NHaFixOh5ozJ873V8khPvGGKsLkfF/C4hmvORPJxwPcHlCY4ocoJ/ubNKaFuIGDVlGcl07A6Tyg7brYKSHsLTGdQ/dM4Ji5FCV9Zgq0oxOZG8RPEu9bImh375WIxjysRQhW7eDUQ4pnlksfbT8gBQMIdCSnXR80LzKV/vp5uNwl52O5+I06VnZkDx91pyH74a+yb40UaA/7Zfv8UHB/OEWfW0q3WRfYz6sha+DtLWpWHImQVRINEzBJ7pbt33fFcD3WwKabPl/5lxNFY4Avf9du6vAa0jDjlFz44IKls4fIbdj
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
Changes in v9:
  - fix some typos in comment and Fixes tag.
  - separating huge and type checking.
  - add r-b tags.
  - Link to v8: https://lore.kernel.org/r/20260924-fix_split-v8-0-cba7359d882a@arm.com

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
 tools/testing/selftests/mm/khugepaged.c            |  38 ++-----
 tools/testing/selftests/mm/split_huge_page_test.c  |  16 +++
 tools/testing/selftests/mm/uffd-common.c           |   4 +-
 tools/testing/selftests/mm/vm_util.c               | 113 ++++++++++++++-------
 tools/testing/selftests/mm/vm_util.h               |   1 -
 6 files changed, 100 insertions(+), 74 deletions(-)
---
base-commit: e8d0f6a1b2a447d02845984fa6288787543cb03c
change-id: 20260820-fix_split-f44939ec44b8

Best regards,
-- 
Sincerely,
Yeoreum Yun


