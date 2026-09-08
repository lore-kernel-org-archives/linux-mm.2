Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E231BC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECA366B008C; Tue,  8 Sep 2026 08:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79BA6B0092; Tue,  8 Sep 2026 08:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8FCE6B0093; Tue,  8 Sep 2026 08:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A69EE6B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A9D3120605
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:14 +0000 (UTC)
X-FDA: 85190580468.21.C70E2C3
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4B86D100004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=FSbF7xUw;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=JSRPIVXE;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871872;
	b=HobqgV7rcv0VWF0yBf+AHvFgkhOl2YEZEUJFR4jzkvLrSvSTB7YSuvnLkxwSOe+tx+ok82
	f1J6xn4yzRElPVv6HuL5uBpcW2CHi6jo7wzinwtsjmvv7t5ssTvrP11b1Ud4dCADL1oNxL
	0jAZ5aUTiabDYebR7CsnUBu8lCTmS+w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=FSbF7xUw;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=JSRPIVXE;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oAgFsu9RIiQLRU/4wtgEI9IkVPrxXlyfxCJl2MRW4aw=;
	b=qfjdFaJ9vUG8zfPif104QZxUk5kvY8u+4YZ7Mop+5sDxddzfFuINAxth+t5BS31H+MHRTo
	v5cbf2RHGpPoR6u6vhkJHp1owzAaIbhdFcfNwnBW4y8jTmwQ5uU7Ef4BONH5tm+bnMxZez
	yTtuHpPNWOwOSIcarRo3cMPxFSkl3Gc=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 93D7EEC00FA;
	Tue,  8 Sep 2026 08:51:11 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 08 Sep 2026 08:51:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1788871871; x=1788958271; bh=oAgFsu9RIi
	QLRU/4wtgEI9IkVPrxXlyfxCJl2MRW4aw=; b=FSbF7xUwf0Am+/n2y6wBYsekv1
	uaVOsWmeklsf41R4mwfVHY0wi8U/JLVLNqjLCnJa7UNbDB45iCD9+xSLa2AboPpN
	m+WuwrCrb4LgoEx31nLvWV7d09lSS6pbyY89PjQ+4Neq6Vzj6g5ImGi+aPWaASzB
	C3KzPV5POXuA8G6w2mTlAvot8mLrnqghtvrpNlgn1Xktcpcd/THo3UH48vAGYUwn
	HZWS6OgPnHmp3IRdNUortf1dYuI72osAM8JG4P5rUp/RG0+az2p7xDu228U56iGw
	72E5VCh7zkQTs1KnxCHGh4j2yThVTriH/Vf1/l0yKEBIBJ7DeHVcenJBN+yg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788871871; x=1788958271; bh=oAgFsu9RIiQLRU/4wtgEI9IkVPrxXlyfxCJ
	l2MRW4aw=; b=JSRPIVXEtYUFEVRhSEd98oYvWhf8fLcTbJQtU3iCe13GXx7B3Xp
	7OsOrtrUcFUe1jEEMWjF/fYsVz6SMcHr749YP5cdgRZr+wyidYqa8lMITsXZmyxN
	0ob32Q3zdDpFrnJz7BJ+IL2sC8PfZUcgySsXnwjSQyeika/pJxhmcCSBD+RG8POj
	YlIATjtYvYQ/KZwt8AXqFEhEdNT+RHfuN+OExoXt/BO2xAksOynJ4z3YCBbF2duH
	cVB+MJKRoua/HlNjxOgc0ocQwBay4RT+9DITW+uuyzvrxCEUZxpK8PDj0RwcgowZ
	nTDvGznvAKTabYFyqzk/qotsIuVMcR1s9xw==
X-ME-Sender: <xms:vgSgaoqhTgVJXNkdAWB_Cgc0ufXtHEhSpg_6z1-N5dLheqraAzzmWQ>
    <xme:vgSganBcGekvNt98W7gcy1JDZWftWU4IwKNi8sIabzXLzVOTJwoOykEm0v-k1og0u
    udhnStHHTpBCb1jUbSo3QdMDpRrbXkNr6KyDgeVmNr4ngIS_qZds7IqYw>
X-ME-Received: <xmr:vgSgavZT3Yo__1vub3aHdEi5n2tS9zFfURzsL1kp-D94QerB_d3Vla-uue8>
X-ME-Proxy-Cause: dmFkZTEolKPb87hXCA/gUJ9DSFQO60GeQI9frOkRadinqpKOlnErzEs+yng6fAuOMXms2W
    +VWJBWmgpvEioiv4J7Dfpd2FwvvnuzVWMPcduM94fEl7bIOKXI+9yMIkPT6xOcdMObozMN
    8EufWbN/O7LxYkhDY/cI0ibMy6mvppBy8djBTcxF+K2UQlijBBoioHKr8tNu77DxwrK5Un
    BY/+y7ReQeF5+dCpmx5aDi8btKNnGWW/koEkLJIIl/n9bnHHIoiI9kDokoTCukv9BtG3KP
    W9K9oXzUJsvqduagwAQCnFdSci5mAe4yz0bFeQGRFgjQ/aZMNs3AiyddrvPrDDPDnrZjd3
    ln2NUi4awb5b/fE6ZcuS0sJnIP6Fpl6R6edwxF4buh+fHE8rSyzN09GlcH+yEgWuIwXtBO
    rxuXviXqw3cJHtp6x+tr4/8wyDk9ZtX4wMI09kdWjJR7WaSl3uLKg5Tjw3CCn2HYfVmpzV
    hjza2GwbTG/Q9ACSRm2zviQyW3qoESOR0CinrstluSVX1LLQpwdBGG13PsfN8oErRyt+wZ
    H17qXXm08MVH2CbbgueZ8tcXQUfy1wuB82pM04+BxRZSpdfsfMRCwXH7Oq2KFXHb0yxEoo
    MXzSYUx660NYCREPX7KvG/FVvPWLavsb2o3Sff5GqvBRnwl49fCZMRxbLQ/g
X-ME-Proxy: <xmx:vgSganv10aXHy1rGCP8OpK6zpFM46VL97bmYP0ljceOWl9JPSTTF9g>
    <xmx:vgSgap9wJ36ENur6VlGhn9yR_C6ad6xumyafRFiOh0RqygN8V3rXtg>
    <xmx:vgSgavUsnR65LHbkFzMgvCxZBrjK4gHtXPkjx98zzDBp0tth0_l37w>
    <xmx:vgSgalvsHcsEm_Qt_OOL30vs5y32u7PioXcNMQ16gugnJTKLE3lMUg>
    <xmx:vwSgalL9mheK6QHcBC9_NrMBANlSrMemnRgH_Sy5rp-D_eo6IQiYy8kS>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:09 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 00/19] selftests/mm: improve khugepaged coverage
Date: Tue,  8 Sep 2026 13:50:46 +0100
Message-ID: <20260908125105.1510704-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4B86D100004
X-Stat-Signature: cuwoci5seeq7e7ei7xeohgwk66mt397r
X-HE-Tag: 1788871872-14302
X-HE-Meta: U2FsdGVkX1/2acoHqU1igM338Wvq79yxgq0i0v9dYnT/6KHJZakm5M+vcZIbzneOAlzufuGtP31bjCF+aOqc25ROywlnvsYgh1DWkcuZv21uQZgvTOoP6bXBIbX3WJ8lIupNGgu75XWT/EZTTlfa2S2LuWWD6HlwcVLVtPW5LxQQGj6fb1rvNjNjydchD9FxYhuY0C+5PpqeVHIvFWkFLA60nWe1qIqgzUmusqkQ6BQuGNgZR7iRHQhdy2kgW9SemVU6olRD+zyFxMBUGiXpX9/K+dPjp2mF+sh6WcdbfaJ+fUfEmEwI/G/MR7r7H25giGQjk7AjWi+df7jECajzL86bTL7MXhbtjN1LxgRDiQxD5wwxsiQeKZwYIZWsAldRCddTh43U4nQ2wz5Wvyo99y7tRlDw+8N7c1KN2Xuof6HHpZ2a/2u/U+7IWPwpwKhPdigNkBo9emXszLKyIUSvpBZQdgTpd0oTxqREGx4wMuslHOZYUGCXSSBkey7F+1+XE+Ha3Doig4FkHg+JIH4ytoVVWLCLX5Ops9+pNQ6Cp69N3pq6P9vBnKywUtu2TiouB3o/fh9q/97Wnx9rGoVBLQ6KOIjX5FlpFtAW+2DenY0sqZ6J40aWUyXLuWXfC50XFhQ1udEKskUpKu2rWJ3FxJAyY0Hv0QgbYhMoZlF//UukC74MedLlpP7gHiVodZ77b+hLX/6L/pjPUlVcn7EJGSYzEtkWJuzfK47dm3soYeeDObEAPV1VQIPc6M1kjQ5LDGtbwsM1B9aZv2lr+UhvJWGYRiiifnuXj7XgUNp2atuQXXcdc6I/rHAVI9Q2UnetT+sZkKmnlMP1rZ0txCjMkYYmG8OhxB/qZQkC0vB0ngUpvPEbqZ6zswtT9L5C338iOr1PMrzDkm6r+cw3fKCBZ9oDYBNzS9huBqDNoLvCJxkelxWiol8804eY7A07JijAW5uL3h9F7XvqKA5QPNI
 G52r9LDB
 Tgc1oFu8fL1gL5N2x1Wl8DX+IbsaxsGeacCCnxIKpKTA3HzONDz48tJwTgJhNoUyX/p5q6ws7Rvax4vVIVNTyT2Yg15UV2nY7N+UvQrdKPO9oRUhXita36lt3E5eo1N3Ji127HRBdQFU+lZ1xpoYwLbmbgq6x+amF8dsfP6t5Uq1oqkwosanfoqet1wIuC9EjTiLxEUFSB3ZlrJJ/pJLsQsl52JH5188HXvIp+lQ+psMIeP0trfIictBI5BezZfXqX6KHUUnKlXEBzH12HE+gZegGlySYRbxAXvlLdqF5qiSh51DaEB5koShS1n+mIo9ao4p2YR0gxX6LRlBvyyU2ja+BQL3W4dSF6P+wfbEK63j/4+AVvlpwolP5svOlZlMRs0xO+0rqpF5+snrRjIf7kVeNAhe8zpVqUdzeL0zgoJjDQ9Wva6s5T3FYjgTyuUXaI1bBvmWUnPpSU6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

khugepaged collapses to mTHP orders since 7.2, and 7.3 added three
selftest cases for it: the generic collapse cases run at one order named
by -c, with the result detected by counting folios of that order.

That leaves the collapse path largely untested.  The suite does not run
where a PMD is 512M.  A folio count cannot say where a collapse landed.
Fixed sleeps cannot tell "not collapsed" from "not scanned yet".  And
nothing exercises collapse under contention.

Close those gaps in order:

 - Make the suite run at a 512M PMD: scale the collapse wait with the PMD
   size, skip what such a PMD cannot serve, make the swapout the swap
   cases depend on deterministic, and keep khugepaged out of the
   MADV_COLLAPSE cases.

 - Detect results per window rather than by count, with folio-order
   helpers in vm_util that are checked against the kernel before any
   collapse test trusts them.

 - Drive khugepaged deterministically: a completion barrier that wakes the
   daemon and waits for a full pass, and a check that one pass yields one
   attributed collapse.

 - Cover collapse at every supported order by default: which window
   collapses, occupancy at both limits, sources that are already large
   folios, and a fork-shared source under concurrent writes.

 - Race collapse against everything that can touch its sources, at both
   occupancy limits and over whole-table zaps, checked by content and by
   the kernel's own assertions.

Everything passes on an unmodified kernel.

Changes since v4:

 - Comments and changelogs rewritten: why, not what (Lorenzo Stoakes,
   Mike Rapoport).
 - Helper names say what they check, one pass budget across the new
   tests, and the review nits taken.
 - The raised collapse wait is measured: a passing run costs the same
   with either budget.
 - Rebased onto mm-unstable; Assisted-by per coding-assistants.rst.

Tested on mm-unstable 20cab322c95c with KASAN, lockdep, DEBUG_VM and
page_table_check, in 16G guests:

  x86-64/4K   khugepaged all:all  104 pass, 11 skip, 0 fail
  arm64/64K   khugepaged all:all  102 pass,  3 skip, 0 fail

folio_order_check, khugepaged_sync_check and khugepaged_race pass on both.

The skips are structural: tmpfs cannot host some file cases, and mixed
sources has no order below the smallest.  arm64 never registers the file
and shmem contexts, having no PMD-order page cache folio.  The default
./khugepaged run there takes about 220 seconds under TCG.

Kiryl Shutsemau (Meta) (19):
  selftests/mm: raise the khugepaged test-case cap
  selftests/mm: skip collapse_compound_extreme() where the PMD is too
    large
  selftests/mm: scale khugepaged's collapse wait with the PMD size
  selftests/mm: skip khugepaged page cache cases without a PMD folio
  selftests/mm: make the swap cases' swapout reliable
  selftests/mm: stop khugepaged during the MADV_COLLAPSE cases
  selftests/mm: move is_backed_by_folio() into vm_util
  selftests/mm: add folio-order check for address ranges
  selftests/mm: add folio-order detection self-check
  selftests/mm: add khugepaged completion barrier helper
  selftests/mm: add order-parameterized khugepaged collapse cases
  selftests/mm: parameterize the mixed-source collapse case by source
    order
  selftests/mm: cover a shared-source collapse write race
  selftests/mm: run every supported collapse order by default
  selftests/mm: check that one khugepaged pass collapses one window
  selftests/mm: add khugepaged race harness
  selftests/mm: race the collapse of windows with holes
  selftests/mm: add memory-pressure threads to the khugepaged race
    harness
  selftests/mm: zap whole PTE tables in the khugepaged race harness

 tools/testing/selftests/mm/Makefile           |   3 +
 .../testing/selftests/mm/folio_order_check.c  | 122 ++++
 tools/testing/selftests/mm/hmm-tests.c        |   1 -
 .../testing/selftests/mm/hugepage_settings.c  |  60 +-
 .../testing/selftests/mm/hugepage_settings.h  |  11 +
 tools/testing/selftests/mm/khugepaged.c       | 485 +++++++++++++++-
 tools/testing/selftests/mm/khugepaged_race.c  | 533 ++++++++++++++++++
 .../selftests/mm/khugepaged_sync_check.c      | 179 ++++++
 tools/testing/selftests/mm/migration.c        |   1 -
 tools/testing/selftests/mm/run_vmtests.sh     |   8 +-
 .../selftests/mm/split_huge_page_test.c       |  62 --
 tools/testing/selftests/mm/vm_util.c          | 147 +++++
 tools/testing/selftests/mm/vm_util.h          |  10 +
 13 files changed, 1519 insertions(+), 103 deletions(-)
 create mode 100644 tools/testing/selftests/mm/folio_order_check.c
 create mode 100644 tools/testing/selftests/mm/khugepaged_race.c
 create mode 100644 tools/testing/selftests/mm/khugepaged_sync_check.c


base-commit: 20cab322c95cea0327215bb81a05df69336032dd
-- 
2.54.0


