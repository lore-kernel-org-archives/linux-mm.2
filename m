Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77641C5AD44
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 19:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2316B00D8; Sat,  8 Aug 2026 15:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C426B00D9; Sat,  8 Aug 2026 15:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8356B00DA; Sat,  8 Aug 2026 15:14:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC9626B00D8
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 15:14:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6FD8F40443
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 19:14:19 +0000 (UTC)
X-FDA: 85079053038.04.EC33EEE
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf26.hostedemail.com (Postfix) with ESMTP id D9F9A140004
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 19:14:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZId1PKDH;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf26.hostedemail.com: domain of sh_def@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=sh_def@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786216457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=q/Nn9N+TcF5PSILtONXCcDZuOZOA8yQM5ZlkYu6kinQ=;
	b=GsnGOTj7/uVm+NddTwMLp8rtca1tDvxkF7SRPfao+yXUoQoeJGjW8wPf5y1Onvhl2vkC5t
	6bquM2Z29dkqkiKSOUF+sEmLtyMaMY9D7/ZqDzmO/5FTInzCr9RHLvYL0qLbkq2fP2gUk7
	4556zXO9z5YitvkVHtpTDeZCRQEw+ck=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZId1PKDH;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf26.hostedemail.com: domain of sh_def@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=sh_def@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786216457;
	b=0GqC8UTQHP1JPdFfaF8rWul5LV3ZNCsCsxYd6M+ttLxuHkyAQO8HN0Rx5uc45X4nHXaWeB
	S+AN1lCV5fP9kOEKKGQ7+i/gMEPAv4uVDSJgKE+CtCHpZs7UddJSDZ/acY5kEYe7m2+Rsa
	338JJBDLnoqxbgoy+yngxs7M0QUIWEo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=q/
	Nn9N+TcF5PSILtONXCcDZuOZOA8yQM5ZlkYu6kinQ=; b=ZId1PKDHgexHLjjuoQ
	o9I5FEqqw/GttmS2S7MbHCGhYiGa32jLpGOHhRRhG6s3Lfu73NuEUPuVN18ls65J
	e6rCu8xpwlGnzqJ44F/lMcLCrQWB8ucdlgVPVOn5Vtd4aoHgeg+1wFUtgsepVkLC
	CrlKv/a2ZPZBlM9fRy4LSQD3s=
Received: from localhost (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgAXJfzaf3dqWP05MA--.26752S2;
	Sun, 09 Aug 2026 03:13:31 +0800 (CST)
From: Hui Su <sh_def@163.com>
To: ryabinin.a.a@gmail.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Cc: glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	linux-kernel@vger.kernel.org,
	Hui Su <sh_def@163.com>
Subject: [PATCH] kasan: avoid unnecessary quarantine lock cycling
Date: Sun,  9 Aug 2026 03:12:31 +0800
Message-ID: <20260808191230.3345930-2-sh_def@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgAXJfzaf3dqWP05MA--.26752S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZrWDXw47uw45ZrW5try8uFg_yoW8XryDpF
	9xJFy3Gw18Z348Xr4UZF15Wr1fXa93Ka4DA3y8Gws3AF15W3W2gryFyF9Fvr4jvr4SvFn0
	v3W5J340kr1jyw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piH5l8UUUUU=
X-Originating-IP: [183.192.100.171]
X-CM-SenderInfo: xvkbvvri6rljoofrz/xtbC6RuO7Wp3f9tdFwAA3i
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 58f63f17nfjpj3xw4pu7etp8a97ytuhq
X-Rspamd-Queue-Id: D9F9A140004
X-HE-Tag: 1786216455-879780
X-HE-Meta: U2FsdGVkX1/YGgEnmFLJiVkFwTJ7Ur9Hi69F1n4CysvWT8Tae3oQf8saz47CeV4ODC5hIoe4lI2xkwxkhW+3qrKeejT5neg5tCb3SffimD9uwZ1lW5sy80tbTBIV+yhuRceILkLN9DYJMUC1nBUBV8mqqYc9QQwBTbPd451gnr0TbDfRm2A9S8vMN111fIPu6osx9/I+WPBj+UzqkLI79xvS8cURqMv/ZKRbeyRZnQzVttTVAMUrr15G8hs2nXGzxNbidkJxQU8AmWee+BVZAnTbDvC1chQuoWpV8Ehj6hSPy4QPVGDgjWPx010GTRgmq2qOS2LkL2w9YrgrGeYEaGX0OyspQsQ794vkPfX4jcvL8uNJd+EhXYzDQccmRN1FlePL9I/wRFNJHZ6fteVewsUT4/VlOsQDsCY4ReFKGoh9Gc31VNYkyHVAU0AQjLQ1h9/T9ThdRrDlrEqk8LLqJ59Ohc91rIUb1wPdEJhBX/e1p8TXZ06CD251pVIK6iwOceB8sbr0svdI5W7MjhKY/YvsOVqRWvKpBlA7P4WlI3PhVmotAYEtL8n/3ul9c3agDYqFQKNWwNOe+NDZYEwVC7+xape13Ibh99JOY6SdYq5mfDO+YXZatj/cdHJfGOEVwEiXRgZroNUl1QbgVUIrgghsf9vgEdyYv92w76J4PY5ihKVaC3XTul2BJiNO4EfhxKjTeimld8grvkabP1Kz3qF258SUw/wxXp0CDP+PtIyqn7dkR7AnxvBm3fkC7mb+nx81xKE0tu/MKwgJtNkzM39q29SpQppTszZWZVpaB+hlQqBcURRqAITsXDC+EdDidorZ/tDQSSfKrCWNNTfkrlXl5Hip33O2KjzSYChAPYtDePWQqNHGTCv7j2xa/uIZmKSUGogALeIOjuc3lq2/qd25HVNeYUKSQLy/8h6pEP64Fs8hPAmsaE3w2zrf78kCJVVKDw+d/qvUFSqNpGv
 IyFADneU
 SKiRQA8Sr7D8N/lpoOl3K3qR4AifxydAJi/zzxlNtn3ngdBpjLK3rITrkT+CDFbnmsldj37Ugx+bPywnTTcu3piddGGKgA7Wm2l0wt3Jhbm/wGanXUzWAlymp1Ek51VmKxpfTOvv7avMukqoCi8IyGdFXdeIl6dOKljb9tg79P+eH8MvhxJ8c+DPacZKNbnE/OKGZ5lmTw++AYan0L1NQURnR5nbWU5XBTxQj3wO9W5WQBr8LqkzTJ5G/SE874TVOXRswM31BkKXJ0YqfTmwu0Ar4F+GiGi62088sUisNSr3h5SW8FVsZpdSjLXEFDrJBc02jFJIqgT41hU9A67IkSpS5EiYMvd9+AwcQl6MoUoNB5JL5af8x2QRZOG8Ncm2pPA+2g/WzHczBTM/cB9PHJIhC0/u0sB4LaY2usZcIv096qoIoDBbwnqXHfH02/3TiyuQ+XyIYXEOKt4qnIssXp/lR7SMRsAZzX0ffY8VeMOj144bwoHS8RbYtqMc+p7anPq2qBA8mPtR6TDx5rdCdW51JALqXWkCXi8R2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_quarantine_remove_cache() drops quarantine_lock and restores
interrupts after scanning each non-empty quarantine batch so that
cond_resched() can schedule during a long scan.

When no reschedule is pending, the unlock/IRQ restore and subsequent
IRQ save/relock cycle is unnecessary.

Check need_resched() before cycling quarantine_lock to avoid this
overhead when rescheduling is not needed.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hui Su <sh_def@163.com>
---
 mm/kasan/quarantine.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/kasan/quarantine.c b/mm/kasan/quarantine.c
index 6958aa713c67..db7170f6f1b2 100644
--- a/mm/kasan/quarantine.c
+++ b/mm/kasan/quarantine.c
@@ -368,10 +368,12 @@ void kasan_quarantine_remove_cache(struct kmem_cache *cache)
 		if (qlist_empty(&global_quarantine[i]))
 			continue;
 		qlist_move_cache(&global_quarantine[i], &to_free, cache);
-		/* Scanning whole quarantine can take a while. */
-		raw_spin_unlock_irqrestore(&quarantine_lock, flags);
-		cond_resched();
-		raw_spin_lock_irqsave(&quarantine_lock, flags);
+		if (need_resched()) {
+			/* Scanning whole quarantine can take a while. */
+			raw_spin_unlock_irqrestore(&quarantine_lock, flags);
+			cond_resched();
+			raw_spin_lock_irqsave(&quarantine_lock, flags);
+		}
 	}
 	raw_spin_unlock_irqrestore(&quarantine_lock, flags);
 
-- 
2.43.0


