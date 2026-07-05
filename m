Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28F1CC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 13:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9916B009F; Sun,  5 Jul 2026 09:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9699B6B00A0; Sun,  5 Jul 2026 09:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87E586B00A1; Sun,  5 Jul 2026 09:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 542336B009F
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 09:12:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AAF204072C
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 13:12:46 +0000 (UTC)
X-FDA: 84954762732.11.31609EE
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5C357C0004
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 13:12:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QxYPmnjm;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783257165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=loMni5jHoSKoKTYnGMM9Px3Q7ehOwibtPYphjTw/wfk=;
	b=OSUT0H/JYGO5jkloTQtkSFrj/qQFODIGmyaE+unCWJfBtc8u5ahxQQ4ZDIOps6qhxidPRk
	GX/LMKEqEc5S37HzhKlBUdyv9FvoQoewfEZvSA+5JIyGVZlmwpGZ4rPkVXvw9+goxdHA0A
	+3XeHNW3hku94+t9Pdx9xTceUNr/Oyg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QxYPmnjm;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783257165;
	b=Ab8HBoRFi6LrzBrS+Pf9knyF5XEi8yzGhgXKhfvbAsYFeBXyT/30XxrGDNhVz1MeXwzsy1
	ahPe5iIlDb7nNWMX3y2ewvpFvTb0EjL7W5QN0y5W8KX4i0wdoYnRlQpYCwD7rjm5o6lrn9
	msKdOzDaX7+1G9oEHmEUPr34927BNv4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783257161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=loMni5jHoSKoKTYnGMM9Px3Q7ehOwibtPYphjTw/wfk=;
	b=QxYPmnjmWqUc9bWzP+SAOW1YFUYgBcRnaLa5sD1BrzblhJRmCuARcLogD+3e9l2/ZyLGIp
	I93nDkr/L9h5WiOfwXJaJZ0vm+nYaCC0EGuh92ZV5wuVNrXJKYskrEB6X3gNSkV+H5U4Vp
	waURCoiae58uMAoNQKF6y8Qw+EpMZeg=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	usama.arif@linux.dev,
	ziy@nvidia.com,
	aarcange@redhat.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	riel@surriel.com,
	kernel-team@meta.com
Cc: sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH] userfaultfd: wait on source PMD during UFFDIO_MOVE
Date: Sun,  5 Jul 2026 06:12:31 -0700
Message-ID: <20260705131231.1499198-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: w71m4zmk135u77p3p5nw1fgi1jym8noo
X-Rspamd-Queue-Id: 5C357C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783257164-831871
X-HE-Meta: U2FsdGVkX19dOhMFmWWjMKXfdaNnzjqpXcFB8VNV/YMCemZWkosTzBM2d0cyPyyD0ls/6v4KtRBpGc/SFb0l65tMQ9X/Rq1xm4LIB6Ga3RyO/fAkdL3U070gnDMZT/WbTfUSdWTvSC8W8hA3daR07o9nipJUifSuLakWB4BUBHHrqFxL6pfA5z5ZpT6fbzJyrMEuzG1J1DenwHbgj5eYGPKP5vETcFNK+LLZWsk/sp/2aYX0HX4VBw9wQK/3AVaWoTT5uDsZRHvACVn/1CiqApWhbGHIMj7kO5kO1BsFUKC4VZ+o6gacKsMvruNTQkKCJ5rGjkudDo1o4tJLTEUts0r2JqXuiCSEkSaxj/1SLwhw57J3G5oQFyolhgPbCKzFpo6DpJL5qQHTJ8E6F1T4lCxPz8QGNSGaNxEpwNPR3UZ2LOcW4WAsigYmlnZDLTV4+KWn+KfQRsrqZ06oIEjv5E26dpWuyxfcJUPKDSsVoY8HKBHTGLc/8uvw4wfG0R/IaQeMVVDmjlPl+O+vaQTt2bf5n7YBlR7RhTbuR8ApUBszJ5qqgWmEvUPbDU/uCsvzh02dJiSs3vx4WaZ5kKKAHD/ONkIlqaTvWXfcPoIYDZVxTOrCxvIAo4RKv7US9kuo98lkyeN4UFYh+mf0tU4rqM2/fNFG/hFLeVY5Cnd/+Z+pL3x+KuxF4Y0/7++u8qg4oNIYdaDZZYnwwN6X5dqFGTo/hCSB9x8ZupL995y9PQM3pGcU4uIytyNjUf1A3O18+58qC2QZPOVX8ByALxkjXC5qSpAGxuux6irE5mwT0YEWgz/UIvjDmYHJ5XjduhlTnK0dLs1baNosMZ1vwps2qnT6CfJQldQgzqLP60M7iaV66VmBHbHPzs7YsV8dk45/tzs2lp/3Z1YEB7mT8A5y+aNwAyAhSWz5dLC3lF8XttEVWWGyO8anuU+CXPyYpMaqmwnrzRalPQ8nuPaJuQ6
 wSUHZXau
 Wq8l/ALgPv/7Ilfps7e0DnRme9bAlZI+sge94lbdF+TvTzJ3zSI6BLU83Cc9tk7O08Hgm+NxVty63Hkb5u7xYzqjhzeOsEPIzM2kt+6iQP3z7obYIF3vNt97QquRFT6Amr8V4rUm2/9ITeI3Oyg8uIONBlCFdtQikbWZ5bN7q3fYdoPws4KiKqzhBmGamw/XSVErx5TTjXVRiYZh/SOVcoDCgBjlfi463fg31zCrdBuLDszmHgD5jG3jSn+DIHOWI3j6BJibby2iG6AxFAC6vuo6bxqXMhkW5x76DPf/MRz9IKE5C6LjQzE4fULSF6LBgY5AXqAUxyvbiQek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_pages_huge_pmd() snapshots src_pmdval under src_ptl, drops the lock,
and, for migration entries, waits with pmd_migration_entry_wait().

Passing &src_pmdval is wrong. pmd_migration_entry_wait() must lock and
re-read the real page-table PMD; on split-PMD-lock kernels, a stack
address also resolves to the wrong lock. softleaf_entry_wait_on_locked()
then waits without a folio reference, which is safe only while serialized
against migration-entry removal by the real PT lock.

Pass src_pmd, matching __handle_mm_fault() and hmm_vma_walk_pmd().

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=8
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bdd8635922f9..c0892cc533a9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2775,7 +2775,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 	if (!pmd_trans_huge(src_pmdval)) {
 		spin_unlock(src_ptl);
 		if (pmd_is_migration_entry(src_pmdval)) {
-			pmd_migration_entry_wait(mm, &src_pmdval);
+			pmd_migration_entry_wait(mm, src_pmd);
 			return -EAGAIN;
 		}
 		return -ENOENT;
-- 
2.53.0-Meta


