Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F414FD5325
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 09:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60A456B00A1; Fri, 27 Feb 2026 04:44:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6976B00A2; Fri, 27 Feb 2026 04:44:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DFC66B00A3; Fri, 27 Feb 2026 04:44:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3434A6B00A1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:44:58 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CC18A1B74CE
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:44:57 +0000 (UTC)
X-FDA: 84489752634.19.8E66484
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf01.hostedemail.com (Postfix) with ESMTP id D9D0D40008
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:44:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iq7tHb7X;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772185496; a=rsa-sha256;
	cv=none;
	b=MDvF/Eh7HcTY7GYOgYkTUAqxsudRHpVw+qS7vDb3txntvhJ0RRLjQ76qPL+8+xPYoLh2hs
	Fi4TwIjLTHkPAhVP+hnVtp2YJEOj7XfFITEsnG2hogcfaYJhm8AzJHclMhbT56m0FkneRl
	NwpSN6JTJCkTXR882RGNQ7m4ofKdvNE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iq7tHb7X;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772185496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=X8e+sid83UVQcVbpwgH4NtgpV2iaHgcz/z9sPbv8Yyw=;
	b=jurLNQozJ/r9mpMgGmA/6fIqFUOZZCFX2RCXrf051iZu0I4VouTh125Gt5Gyt4DOjfRg8O
	nMKluDmZ4Jff8u4FBaNe0JxXFi0woc2H/o0ToaFeWkR6rW11D6pDFeP5Nc99ltry60NBDm
	oTsiFQm+pNJmJC6qMYCSuAR5kj6Svfc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772185491; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=X8e+sid83UVQcVbpwgH4NtgpV2iaHgcz/z9sPbv8Yyw=;
	b=iq7tHb7XH4BXDcUlMBgt85xA3FidCEhweA8N0l4i6DJ7UUCgj0qxRb4DhfKxeFBx0HYr19oe+CoOLyGpOgdy0Hpyw4GIqiT3c8Tciiu279q9/W0t43Wd5+Gz2lEANYnDZOb2M5m0hWkyD3G/WgzBU5VfzcG8VZ85feuRANNZ+0Q=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wzu.cBW_1772185489 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Feb 2026 17:44:50 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] support batched checking of the young flag for MGLRU
Date: Fri, 27 Feb 2026 17:44:34 +0800
Message-ID: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D9D0D40008
X-Stat-Signature: n5snge8t4u9hjoor9zup1m1b7i7oh3q9
X-HE-Tag: 1772185494-699056
X-HE-Meta: U2FsdGVkX1+K/v3tPYFhI1BF362NpNV84MiBl5fXqzCLpFpdcXx35ExxkZHqEsn6aoSkgEPK3m3aU8SyTf6yp62UJ1Gjc5Ni2Nl3vCvS62Rkpm+8eWz+qxNK0/ilC4grQnO16EmcfFfAbk5/3bE1dF1VtvafG6n7osm4otk5+jumt6I1lSQZUki+/Jmw64FNPMX6rSId0Xd8VHP805ztK3q0eHNNomU1QkZIPtnPvX44jJSDnkCpSXDBNU6RZh7f2V/qBRZ1Sm0Ex4H4fBScEWVw9rAmBEWohqAYFcyCtwOkCgLeongPw3SgWQVpbrv1DOkU2Sr7q5A20tRPiS74aouQ+TCE6YioGgn7tqjKPEqJ+uLN4G7B/PbpcKNQjo+z7tzGuRJAMxaZm20FyWUXGNd4ZNj8uzrV4xKMm9mH4pssL3SRU+byCA6pUSnPrYutyfvYI0nIGYz07wf+Ie1eHRWKD3vVKb+MeQANGpbg4kYspF1dbnVyatm1PgD0aHB0MVz6wzwU0k9z3KEovWHiPw5ro94kEEv13QilrIrjkkgHwPVPDEkai24LJo732zjs1ITjyfk3aUx56h/QVjWIKt3Y/So79zQJVYMnrRYM/SRNOWNRadwgbJNdQyv36grngTHV8YbrpQvgiFiZNt5hwgeK+yh/23AUNJP336RpdtcJz+N3LWuX/5XjMjKikDdaUYmd+MpppOHvTXdH2bwjoRYyxjGHlmr72f4Z+r4nUbW1m6Jyg3M+h3VMpiMr2y4hty2zXBHjJCaafmqabRL1HaVCX0cCtL8yitTodL2XrRtawR6RbqZsyrw0nWRQLk+xGw4Z+bMaFe45IBU2oYY9dJe34ATV5nGoK+NFGgAmNiHmp3JXtnIzxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a follow-up to the previous work [1], to support batched checking
of the young flag for MGLRU.

Similarly, batched checking of young flag for large folios can improve
performance during large-folio reclamation when MGLRU is enabled. I
observed noticeable performance improvements (see patch 5) on an Arm64
machine that supports contiguous PTEs. All mm-selftests are passed.

Patch 1 - 3: cleanup patches.
Patch 4: add a new generic batched PTE helper: test_and_clear_young_ptes().
Patch 5: support batched young flag checking for MGLRU.
Patch 6: implement the Arm64 arch-specific test_and_clear_young_ptes().

[1] https://lore.kernel.org/all/cover.1770645603.git.baolin.wang@linux.alibaba.com/

Changes from v1:
v1: https://lore.kernel.org/all/cover.1771897150.git.baolin.wang@linux.alibaba.com/
 - Update some commit message (per David).
 - Fix some coding style issues (per David).
 - Use VM_WARN_ON_ONCE_FOLIO() instead of VM_WARN_ON_FOLIO() (per Rik).
 - Define a generic ptep_test_and_clear_young_notify() (per David).
 - Remove redundant 'nr > 1' check in folio_referenced_one() (per David).
 - Rename some variables' to make code more clear (per David).
 - Add a new patch to rename some functions (per David).
 - Update the young counters with the batched count for MGLRU.
 - Collect reviewed tags from Rik, Barry, Alistair and David. Thanks.

Baolin Wang (6):
  mm: use inline helper functions instead of ugly macros
  mm: rename ptep/pmdp_clear_young_notify() to
    ptep/pmdp_test_and_clear_young_notify()
  mm: rmap: add a ZONE_DEVICE folio warning in folio_referenced()
  mm: add a batched helper to clear the young flag for large folios
  mm: support batched checking of the young flag for MGLRU
  arm64: mm: implement the architecture-specific
    test_and_clear_young_ptes()

 arch/arm64/include/asm/pgtable.h | 18 +++++++----
 include/linux/mmu_notifier.h     | 54 --------------------------------
 include/linux/mmzone.h           |  5 +--
 include/linux/pgtable.h          | 38 ++++++++++++++++++++++
 mm/internal.h                    | 52 ++++++++++++++++++++++++++++++
 mm/rmap.c                        | 29 ++++++++---------
 mm/vmscan.c                      | 46 ++++++++++++++++++++-------
 7 files changed, 154 insertions(+), 88 deletions(-)

-- 
2.47.3


