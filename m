Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9CAACA9EBB
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 02:41:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA426B008A; Fri,  9 Oct 2026 22:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9A6C6B008C; Fri,  9 Oct 2026 22:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0676B0095; Fri,  9 Oct 2026 22:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8BED36B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 22:41:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C545A06ED
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:41:28 +0000 (UTC)
X-FDA: 85305165456.16.7770CD1
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7E84E40003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:41:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=K9Z8LsAK;
	spf=pass (imf27.hostedemail.com: domain of albin_yang@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=albin_yang@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791600086;
	b=ohSHkAcwqDbbvJfaO3oOdtzvXxGpet5P7kzJlPl/A6sWLI6U8YsmE2V4xeKGZMfoCQAqqQ
	3kGACso0aiLflNQhZJs2JS7G7pGNVYe+A0g/yOnPLHkulAfApcjQaZGOM3vBDJTl6MkUMQ
	ugl8r4GPNdroPngUoZOTWu9vqXTB1Gc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=K9Z8LsAK;
	spf=pass (imf27.hostedemail.com: domain of albin_yang@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=albin_yang@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791600086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IuppudWlzPNdUG29j/pvz4NISV5lfrtSEL30qww+9r8=;
	b=iKmytACRshUBmEeX1HATH3kycm+//4f2LytkN1myBCgHD2Lmpppdanc47q6Tvu2jQbQp4a
	XMi36joIhnXHuKUK24EVQ4cod91iZ4vXg/9qA17epIK8eSbXtGe9Ut+Gy174dio+wT3Yaf
	Bc3scg8A22g9xI5EsMgjcQggMGatA8Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Iu
	ppudWlzPNdUG29j/pvz4NISV5lfrtSEL30qww+9r8=; b=K9Z8LsAKfojwsrNXaT
	eFa4/Yv2HD697ySbGv8vdh1+TucpFf20MIc4aPChDUZN3XN+z/f6/Qwvc/RfFEWv
	037yg0Q6gDv7EKUHa+XxHNOaQJIQnpvgx2i/dWRzhoEfDjV++w/TsmhPRqijTrNb
	gr9XoRhXQCrJPLs5+yBPVMxuI=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3v3uupclqOD5oDQ--.45093S2;
	Sat, 10 Oct 2026 10:40:47 +0800 (CST)
From: albin_yang@163.com
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org
Cc: vbabka@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	albin_yang@163.com,
	albinwyang@tencent.com
Subject: [PATCH] mm/madvise: add cond_resched() in THP branch of madvise_cold_or_pageout_pte_range()
Date: Sat, 10 Oct 2026 10:40:42 +0800
Message-ID: <20261010024042.4070048-1-albin_yang@163.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3v3uupclqOD5oDQ--.45093S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJw43JrykGr4kJryfXFWkWFg_yoW5GFyxpa
	98Kay7tr4UXrs8XFWxuFWkZFyjvw4fKrZ7XFWkJrZ8AFsxJr1aqr4akay8KF4UGws3t3sx
	ZFWjg343Z3Wqvw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRd-BZUUUUU=
X-CM-SenderInfo: pdoex0xb1d0wi6rwjhhfrp/xtbC8A+hRGrJpa+uHgAA3D
X-Stat-Signature: gisgc7n775u87yrmtks9kr1dtyqyzchg
X-Rspamd-Queue-Id: 7E84E40003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791600085-550240
X-HE-Meta: U2FsdGVkX1914hBIiMVLh9zTHTeBnRBSWklghTVDdYFojQY1ILDIlUGc2ly821RGdT4H4iJsVQHZRMFG7wy9CPK2jjR2SoCpUYsN8I+kUdjgpcEiLA2DVvpkN3JKWSqSwr4gR/hRHv4IMJ9Vl3HBLhUZdST5PO94DR2ZNR1hzS2ZSQiBvABgkFB9d27IOEvzYGeoZjsvguDs3Fu9k2SErhMoaHKCra7cBWbylScfgG/KD3Z00d29rovy7FmcDu/31LBdLQZtB3tjh1shK6kBFggDEIvamur8wOHsjXjYc1TbSX5Rdt6vwfR9vz8JsaEa/3Cp5sx4C46QGbFaa1XxNSoyxjUM7b8i+4In54Gply9rVMEQeWAIN3kwp/LEqwLS2A7A5M0tdJX9DwLnuWStf0n2td4gmbR/2iR7bcIgcPd7+5t7fRValMJoM5xdLlCUuDO2v+gUNHA40sN/0gQI2je81EkzUM96kxmxhzkuGFIGkrEPKMkGEg8QHcrziE4q5VaZ0l1nC3V5TqED/tAs6DzeY40WnQtBamXK/TTzD15vGZJTdlucQssQzruvUEV94fYVNg35x4XTneyiD/6mEZa0GdAqIy+Lb6+0bDTL6BvYZQXHnf+fqL/cCKcLIQAex/uyhZ3hg930F41ENEKCMJmY49Wt7BwktmM5iHaDKTRTntWaH4VuAE5SMa4gB+HDG9y/Q+oaP7l9GapSYJhKQ3RJ/HeUnbjkmaTyAbP5RhZjAyoa9xva8igu/QE4chn6MQa9gU/4f4o3NOXP8SCXM/GtLPIwZZSAOO12nW321wEoL+KxOnz+iUIiglwwvP0jz3JvPvbCfcogZGBRQRS/zP5MOXsSrhaSquBf5memsmbuQLmGcrxLBlWgja89IDTHPE8t4/JgMf0+zPX6q5mAbl4CosoDAn2elDgWlwx6Qu0zF9JXpmZfwwThrNuSGP62s/2vvl34WZztcAmcR4o
 AvAKOBwV
 mtL3UdBXqoW3Kt0UZTIfkrO7yPAE4zOYYl1NH2wGAo7cIcFw31e2kT1wci5rSoyz4ZHyY19i5PbLPDT3p+7WlaW7CBJjItHL3+sV5s6BPsJuRU/idtzkHCMS6IGODT3e1P228IHehD5/8AU54Wf8nWcBJQcIIBDk2IXlmCOAiSt8ND8gpZ2069+cTtOsRs6ynpPGbaCSjz1swTm+Q8ZbEvWCnvRoQKJ59EtAvgUR+mf3sQ7i+AxD2QRxYMDfdaGEyz+D8dHeYzWVwA870juVlb5pHLWk+gpQgH+nptvBNkp+QVifGgvJz+MvGRu8KuVw7eLxRNGO5kAFrf/c3MyzalncNHrScBBJILYPwMvFowG9cg1Sx/2yDp7w8H79FMRZDjh9EpMou2vbQ6XE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wei Yang <albinwyang@tencent.com>

During stress testing with stress-ng on a 256-CPU system, a softlockup
was observed when madvise(MADV_COLD) was called on a 31GB memory region
backed by transparent hugepages. The region contains 15935 THP PMD
entries, and the softlockup was triggered after 14485 of them had been
processed.

The THP branch of madvise_cold_or_pageout_pte_range() has no scheduling
point. walk_pmd_range() invokes it once per 2MB PMD entry with no
cond_resched() anywhere in the loop. Each iteration calls
pmdp_invalidate() which issues a synchronous TLB shootdown (dsb ish)
waiting for all CPUs to acknowledge. This operation can be
time-consuming under heavy system load, causing the accumulated time
across all PMD entries to exceed the softlockup threshold (20s) and
panic when softlockup_panic=1. On a CONFIG_PREEMPT_NONE=y kernel, there
is no other opportunity to reschedule during this entire traversal.

The regular PTE path already has an unconditional cond_resched() at the
function tail (introduced by commit 9c276cc65a58 ("mm: introduce
MADV_COLD") and commit 1a4e58cce84e ("mm: introduce MADV_PAGEOUT") when
MADV_COLD and MADV_PAGEOUT were first introduced) and a conditional one
inside the loop (commit b2f557a21bc8 ("mm/madvise: add cond_resched()
in madvise_cold_or_pageout_pte_range()")). The THP branch never
received equivalent treatment.

Fix by adding cond_resched() at the huge_unlock exit path after
spin_unlock(ptl) and reclaim_pages(), which is the single exit point
for all goto paths in the THP branch.

Crash log:
  watchdog: BUG: soft lockup - CPU#63 stuck for 23s! [stress-ng-vm:1665914]
  ...
  Call trace:
  pmdp_invalidate+0x48/0x68
  madvise_cold_or_pageout_pte_range+0x84c/0xb00
  walk_pmd_range.isra.0+0x1ac/0x3b0
  walk_pud_range+0x120/0x190
  walk_pgd_range+0x170/0x1b8
  __walk_page_range+0x184/0x198
  walk_page_range_vma+0x94/0x128
  madvise_cold+0xd8/0x198
  madvise_vma_behavior+0x234/0x638
  madvise_walk_vmas.constprop.0+0xdc/0x210
  madvise_do_behavior+0xa8/0x328
  do_madvise+0xd8/0x140
  __arm64_sys_madvise+0x2c/0xe0

Signed-off-by: Wei Yang <albinwyang@tencent.com>
---
 mm/madvise.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index eeee82cf2b3f..0755e6d99757 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -450,6 +450,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		spin_unlock(ptl);
 		if (pageout)
 			reclaim_pages(&folio_list);
+		cond_resched();
 		return 0;
 	}
 
-- 
2.43.5


