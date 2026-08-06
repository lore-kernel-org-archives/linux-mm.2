Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 976A0C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 12:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77CCC6B007B; Thu,  6 Aug 2026 08:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E056B0092; Thu,  6 Aug 2026 08:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643FB6B0093; Thu,  6 Aug 2026 08:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 374586B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:11:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7BEA1A0726
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:11:09 +0000 (UTC)
X-FDA: 85070729058.10.B1026B5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id DB825140004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:11:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FbIcEyC+;
	spf=pass (imf23.hostedemail.com: domain of sh_def@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786018268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YulkwmZf7EblPg7Hft79CTPkVdGunT1fPQenhuXXzJc=;
	b=PPq1E1pLggv/lAH99BXkYNYPBw4zpZjFKsSE9l5vHCiuya9F1vORFMbrClNp/bkld52afQ
	EmWp30HoBbNuYebooT3a7CD7py4D2hTKBYDSwrQ9g/7zTY15+csFIhhGOqNfgUWDHLHwyR
	tDH6Vp58pwN8fY2cMP65MdxH1pKbXZE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786018268;
	b=QeKpmmw3+9CAyfCqwmxDN5LJkOaEzAABm2f8yFOF7BzWHJbDVeKW8ENKO0zOGswth3YBp8
	0SVt1e2pyu6mTOZ2uri8jLDfTCmwRkpBUIxwUuqRtjHAJbLKpfYntM7n81CkzTvWvqJO0l
	pRY/2GzeEjQiRYEVUDcLg95rBl1Yv6o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FbIcEyC+;
	spf=pass (imf23.hostedemail.com: domain of sh_def@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=sh_def@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Yu
	lkwmZf7EblPg7Hft79CTPkVdGunT1fPQenhuXXzJc=; b=FbIcEyC+O8ejRiNe4b
	E4Sjml9pa/2OS4W3ZuitNK0mdII8KP9DS7QoCnfN+EU52bSMnoDByBq+gULyQD16
	JhvsferQOfIjTB4Rq0SO3PhMi3JLWOWgA8DiBu7nWUG9nBfskzrsKRD7M4UqMWLj
	0PY35HxwhgZtpJCKXbIjUDn40=
Received: from localhost (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDntYa2eXRqDR_9MA--.2495S2;
	Thu, 06 Aug 2026 20:10:32 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Zqiang <qiang1.zhang@intel.com>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hui Su <sh_def@163.com>,
	stable@vger.kernel.org
Subject: [PATCH] kasan: fix cache shrink race with CPU hotplug
Date: Thu,  6 Aug 2026 20:10:06 +0800
Message-ID: <20260806121006.1642946-1-sh_def@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDntYa2eXRqDR_9MA--.2495S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uryDCF15WF1DWw47ZrWkWFg_yoW8try7pF
	y3Ga43Gw4vvr1kXw17Ja15WryrAFZ0ya43Aw4agrsYyF1ruw1kWry3trZYvFWYgryrXanF
	vr95AFy5uF4UAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piHa0PUUUUU=
X-Originating-IP: [183.192.100.171]
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbCwRhEo2p0ebizZwAA31
X-Rspamd-Queue-Id: DB825140004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: aouny8hdcx7nd8c1dsir5ae7qjn7ypwn
X-HE-Tag: 1786018266-836184
X-HE-Meta: U2FsdGVkX1+WcfOa1noQqaDly1i6zvrvf2TophezNv0JKOs+8yOB5QkHpbZ+CtxefQaqqBKw8zAXIlV3mRC1vezW6C4QkokzCFLbKvqdpsW8bbAJqELxjoQvoKRNqN3OiwyBBv9GQ77Rlhl7jyWzpZIloHjASXpoxWqAii1AwRapZ8EVWQg1wnQBF2GYvBrAYzu4atSbRlFD9pmA5WRrv8C7kP60Ux6MhU4EltYCxEVAF+tBvNTXGlkxgeN/Rut9Trmmp2y8ECP65J1IEl2riLYnY6vjhNY8yfc+jnrftpEiGsG8PjG8JAGsf8h9+spJRU3M6PcTGhW0ZU0dpLknSB+HMmEks6yA7Oc6PB+K7GrkRUrYDqwIUl3CozvwZO5T+qjhKNyD0w+mLKxQdAZcxZBARP+NC7LWLgXEzB7G6dBAGlWnPnpGWH2kfv5CQNJ/FVOxF3og+k2GgZbMxY7bi0g8SQcW3XvGTcS1kWcg17n4wpWv5Xz4rlOV7zV7NU/IKSy/2/WSb279kS6299wN+vxCamF6M4pkWgTC/L3+EDgW653/JvsGB4Cz+iaA6ElKxYLDJRHzJLV/X/JtNKuiVM8LwR3qbxHBxlRASrSV5CDS70gcSOe72+l5aY4WJoYGsHpwpexnSiVdGDkR5MhyOt+I6C0XRqn6OvcQ+p4/46VNh9g7k3e6pnTDtBGtqpe1vwgsh2eAa1VeMkkr57855fM7YT54ZVZImWCFoq74cDcU5EuXYGDJd7W9vNFPv3BgrVI/uXUyd4pSYSWf0J8WkhQdW/gZGtUpgvyC9tARM/HjSwp6WmH2O9DDwCmYz0y61aAoxvD4YRgqBg4g0o4fpPccVg1P36EgooRSeuFG2JjAJPMpA1CtlLpqad+SyQ1LXAjNG43p/pdgarkyedUeOqSM9yMXrp0mUuxiKVi47Sj67v4KbRoExDm0iCzuMdvSBncHzO43WgR4h64hmx1
 XrzVLj83
 AgDTpDhVg3j85zeSC6r5t17ULhl9MIJPM7vtJCGWjjaEmBHT5UAkhHmwsL7JlvM7OWDKLevhm0FQNAVzuRhiMkneu3mfinhty7F6B+CaMXwEk6SxG3REVzf+hgT835YJx0JU+QhcPJ6MZ0MaKVNqHDu8k00UJghhlMLt/RU0C+FAink+U58IApkyq9rd5/Ou6g5NAESKQZ5JrTwdYxs1ORcKCbveCTv8gDJy9nOfUDws+38shw461cgN+18Th0h+BR/JFZEESbGKucy7GaGE8astLtBFO+KvMyfrc4OUnEYWGzQBNGDAM7/Xqx0iDs0hqTq1Yp+uS2hY/3jlko+YbgCDQBepgihYQVXQs8fBp4i9RoJNEuanty0YjfyhgDQSXphUNSyczYvme8kXmqUfwlKOJD3tvDxX6xFeunl2BNyR1ttuQjjyMb44GiHn3m8RDXxL/OU87Jio/3vGKaL2TRvKTKljCcYmL4dcfsBGSdWfeuuVnK/mXSnu+Km1tSeKavSEH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_quarantine_remove_cache() first invokes per_cpu_remove_cache() on
all online CPUs. Each callback moves objects belonging to the cache from
cpu_quarantine to the CPU's shrink_qlist, where they can later be freed
from task context.

kmem_cache_destroy() invokes the quarantine removal path while holding
cpus_read_lock(), but kmem_cache_shrink() does not. The latter can
therefore race with CPU offlining as follows:

  kmem_cache_shrink()             CPU hotplug
  -------------------             -----------
  on_each_cpu()
    CPU1 moves objects to
    CPU1's shrink_qlist
  on_each_cpu() returns
                                  CPU1 goes offline
                                  kasan_cpu_offline()
                                    drains cpu_quarantine
                                    leaves shrink_qlist untouched
  for_each_online_cpu()
    skips CPU1

The objects left on CPU1's shrink_qlist are not returned to the slab
allocator. This may prevent kmem_cache_shrink() from releasing slabs
that would otherwise become empty. If CPU1 remains offline, a later
kmem_cache_destroy() also skips the list and can report that the cache
still contains objects.

Per-CPU shrink_qlist storage exists for every possible CPU, and each
list is protected by its own raw spinlock. Iterate over possible CPUs
so that a list populated before its CPU went offline is drained as well.

Fixes: 07d067e4f2ce ("kasan: fix sleeping function called from invalid context on RT kernel")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Su <sh_def@163.com>
---
 mm/kasan/quarantine.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index 6958aa713c67..16f4e67beee8 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -355,7 +355,12 @@ void kasan_quarantine_remove_cache(struct kmem_cache *cache)
 	 */
 	on_each_cpu(per_cpu_remove_cache, cache, 1);
 
-	for_each_online_cpu(cpu) {
+	/*
+	 * A CPU can go offline after on_each_cpu() returns, leaving cache
+	 * objects on that CPU's shrink list. Scan all possible CPUs to
+	 * drain those lists.
+	 */
+	for_each_possible_cpu(cpu) {
 		sq = per_cpu_ptr(&shrink_qlist, cpu);
 		raw_spin_lock_irqsave(&sq->lock, flags);
 		qlist_move_cache(&sq->qlist, &to_free, cache);
-- 
2.43.0


