Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30AA2C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6A56B0088; Mon, 14 Sep 2026 03:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 298766B0096; Mon, 14 Sep 2026 03:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AD846B0098; Mon, 14 Sep 2026 03:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF0306B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:30:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5B7A8118D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:30:20 +0000 (UTC)
X-FDA: 85211544600.25.5939F21
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9FCE1C0008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:30:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=N3xSMdb+;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789371019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SCTlPZycYRoXGa8QsfF7eGRC2Nd3bmuilMiOBHpLlYw=;
	b=iEWlbAvw/1G1rjSCEDx+98lNF39O4HI2nPn5a4IoPln6MHMYEvkeGvTY5GFvh/sGVpZkki
	BGoaab3if1ab2QIFeJkiABv8OYGGnNFg8NzfYlJdZJUc4Fw9JMjz8nIaUjNHkDu2m4xZ4u
	UumLnrPSh4Nq6z/34L3OO3cee6x4cAw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=N3xSMdb+;
	spf=pass (imf10.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789371019;
	b=yNgIWru6X++glYIoMGmnrzuwIwF682T8gw6XrSdBaCMU1B1xUCzVJ6yzcQY47XFOraRmGl
	+aFqXaeTxtSOThNG5KDKnC1kkMYM9HWnS4y1XUgcZGdycM1tG4mp8sPGwIPwbqbQ8JZQ+V
	/AbH1vN/aRIkKLqVmoYPfw/B3SenzKE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA36B143D;
	Mon, 14 Sep 2026 00:30:13 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 812AE3F59E;
	Mon, 14 Sep 2026 00:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789371017; bh=LxmCXA3B9Y6uXrZwwE08LbuQHc/4/4X46xSVGb8t8X0=;
	h=From:Subject:Date:To:Cc:From;
	b=N3xSMdb+3BwjgM2FHnfqYzCWor8DPttq4JP+sdIOSYxMOSnrpWpx8gURJYCQs9MYd
	 026u2o6ZTV10eOJZLUlbdiwdlCu1y+q8CBUSQdzBdUstfr1++zEVsrj6GvBQT8w8cJ
	 8Zm5tb/4k4MWoIAVx1KYapXtQuziVEQ63lXaHu3A=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v6 0/3] kselftest: mm: fix some failure of
 split_huge_page_test
Date: Mon, 14 Sep 2026 08:30:09 +0100
Message-Id: <20260914-fix_split-v6-0-16ed7123800b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAIGip2oC/23MTQ6DIBCG4asY1qUZYVDsqvdomkYoVJL6EzCmj
 fHuRTdi0uUH87wzCcY7E8glm4k3kwuu7+IoThnRTd29DHXPuAkDVoBkQK37PMLwdiO1iBWvjEZ
 UksT7wZv4ubVu97gbF8bef7f0lK+v/ypTToHWCjloIXWp7bX27Vn3LVkbE0+dTB2PjpcIjAlZ1
 KiODndXAUsdRieFBV6BsKXKj06krkydWB1jSuaAQiq9u2VZfj9leNtIAQAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3902; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=LxmCXA3B9Y6uXrZwwE08LbuQHc/4/4X46xSVGb8t8X0=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqp6KE6oDgS3nL0RCwPvgtF3ebGpW3grQBMtuz8
 /kV3r9amu2JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaqeihAAKCRBt1cPRWsUx
 MwTcDACuCkl+GS9Z6IJhWqt/uoF9a1l8VbBSsChbNS6udnHWgneWZ5DoQLXamd+6WoPxxZijjY4
 faYkEFObwG9Hs9TTusECQ7fYCjpjckMBQq0HJLP1K9LpvV7zGj+AhHH+Ga1xVAaL+qT4rC/eGOc
 Hu9yCPmdeO9VJlcxJZp1reKM0DLvjs9GQTVXduRgnN8KBpdfLqvBEZaFk6sucmCZEZ7AKcszLYf
 wMlmhqsQQV9SMRLb8St+zC7w5aQx+scbmXCZk1+l2Q6FBej91mKEyNxCpbNw99+UTYXJoNQ7Woy
 Nlw/PdQXF2bXB3koHGxnd3ndhPWbMX35X6b8lWjjhtA/F+832UHc3ZnEELUXz1LoBtKdJ5yRUBk
 8XXMmWx9OYEqqUck0mqHHLF86fQ5X5caD/3ZVEx2KjL8t+qXcDWqJjo2LCILUAbABcLFLbcakst
 mdqSaMUzYKcFk5Qe5BU+2bX2c6W1NJbCwkRA0rUHd6Dm2Bf0Go0RJI536LrGfDj73usGg=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9FCE1C0008
X-Stat-Signature: m4njwdjcmd1bjd9ejeek14d183xxj1w7
X-Rspam-User: 
X-HE-Tag: 1789371018-307979
X-HE-Meta: U2FsdGVkX18urbPPMd5vuxXMn9Txd+MoobuKASpYduIZ8TzwVVIPs3RXsXUqtLO6FJOwAVemiSZkMA70bsZxZPpxDZoVcMR/iP6ueVXTJn04SlMgrCm9aGp23qui7WuYh/+3ZrNCkb5lUS7XMU7Sn5E4TLCYefXZyXrx++7nvYBg6Rh0ZZSD6fH9luMzIGis4QyDPvTEPBgKPl4PucO9/YmN3nPz9JMvSHWaGIq96b8sSJ3AnccWNOOn4odkS2i92/u67IAGctPvf3va6YsvxzQCH1vIW4JjBQ/u8HyA6YeZS0OADPPWjUthlIMhkWJ78632KfB+YE4Sjb7NlqYtfmOM2y3IT/G/t5KZJ8gKQ3bJrCFJWl9A+X2GyC6nzCbSckFBSiZ2b9suXQokJnUuuSiICU7FzjSRaJMldv0/gHrRKuT6q0lOUwNlX9bZGj7UarmwAoWt+DazfnvrasrsMtyISZiP+ioMie4igeIC/9UHm014uGKuQhOmeiAnbmnBgH29ML528tSPxQaCwYvhqYWJSLrMbMlS4V2Jf6L8ByZVZhQlHJ215S3iG/2iDHhyZ6NfvtaKojqYCFN0prPgmuHtqO6hdlNXOMp35iWXZcruqs+8LUmfkA4A+zJoQ/7q909ryUsDMHmQQYtlA4pOTKDfQZs13T8aRCe4Agwe4xNH3Muz92rZ9z2CDMrNIM0Vrd0J3u1YhitF5YNBap2B6tav1e8t5EwqeHCm2jAjVUMcVEkUinHzdKk34sQ5kWRDDohZIDjOCsd08wv94vO9g0elx9xPjtWA4XS1AHzOrtImGjg2SVTqRYuNbJ3IHjDy5cih/OqkfVNChwzLc4At+uCoUBszlQSHsrPgT9Xl2B+nm35skEK/JFNIws2O0YR4o1RDnzEaYe7UvCaflS48sGc90ffnQ43+i2Fx2sDmK7W4PEw34qahPV6eREbNopbxk7xAjisR9kHhEhcx+aw
 ptJiOiMK
 83E+MzCy3CZGCPJGqt9ytj6q8ndlQTYv/1MLlBgSsLhPxqxBRFKG7HikvEwg4wwZEGBZ5A2W6U/QpkcSlhm/7oodGaCZzrmrv+cHD+obeqIMLx8otTeO3zUs09/4pw1/RENS+/gPhQ1WBjgHUREDKmY1BXEDMQD9Yb6bM0pKwzENACEEW6co1vBBUghb/8/TBIvr79mOy5uDh7po8b/cuYPg8YmNsfCNKBmlCDJo+YrNcM5k1BJDtWtDmKVML8YT2RQ0Q/NQSZ5sDeBw6T8Jwk8KNIlgymSWH6E2YD/Dbz+GtzKJz76VMTigaPkJkBRHI+X6GvCbeZJWntOEVr4gqSdIG5PvFeFEhbIxN
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
 tools/testing/selftests/mm/khugepaged.c            |   5 +-
 tools/testing/selftests/mm/split_huge_page_test.c  |  19 +++
 tools/testing/selftests/mm/uffd-common.c           |   4 +-
 tools/testing/selftests/mm/vm_util.c               | 134 ++++++++++++---------
 tools/testing/selftests/mm/vm_util.h               |   1 -
 6 files changed, 104 insertions(+), 61 deletions(-)
---
base-commit: 6b41451631cabf9ea3b384c2a099088e1598f963
change-id: 20260820-fix_split-f44939ec44b8

Best regards,
-- 
Sincerely,
Yeoreum Yun


