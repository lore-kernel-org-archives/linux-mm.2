Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02384C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F62F6B0088; Mon,  3 Aug 2026 11:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6A86B0092; Mon,  3 Aug 2026 11:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDA3A6B0093; Mon,  3 Aug 2026 11:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C16456B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:21:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 626058071B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:21:42 +0000 (UTC)
X-FDA: 85060322844.07.C6A20E3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf11.hostedemail.com (Postfix) with ESMTP id D0A9340009
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:21:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=AAasZAqa;
	spf=pass (imf11.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785770500;
	b=I7xVxjX8bGsl0D16aFlOLETXFddD6RvMVzRK2pcowRRHaegY7xTct/oMdOsTRKnXr0SXC9
	lHa4J/lSEVVrwvBr9a80dUfGJZVbjcOqezzshd6EQHobG4gNl2orWawDAaQ/h5+eOm5Tel
	cCJjR+MRP3BTLI/K8p5h2Sot5310uIg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=AAasZAqa;
	spf=pass (imf11.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785770500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0HZ3VPTvZxvGsRHuUk7OgLdwc+crIATreWznr2dWuM8=;
	b=siehgasjAZiOBAq+RN5WE7D9cjFz4nMCsZQfm0+eo2mDeS0NYBny6Lhndbiw3P3Alitw2I
	HbyHAdm073srpRtSwCMRfdETS+flwtzIP1ZDLwNhzrOy4LxVvRl7bu+CIWZIRcVXk2236l
	7Mfhrwzsli6QB1HXoiJeisa7xV4hXFA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=0H
	Z3VPTvZxvGsRHuUk7OgLdwc+crIATreWznr2dWuM8=; b=AAasZAqaKii6bFh7Hr
	Jkod7AfhNCfVU68qb4YzxxLbq3I3KXBcih9GrCAVc6CMAR4CkvLU7bnCMujefqHv
	X6NTJLlUhbHcQCPSP8C9Mtqf6pOI8U2S0pNN6eKXoKYqKMRRIICs4Bi71jk2/b0Y
	jSy53bOv6FasNUXfc7Thmao5Q=
Received: from XLL-9950X.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgAXmNjtsXBq82wZKg--.37710S2;
	Mon, 03 Aug 2026 23:21:18 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	hugh.dickins@tiscali.co.uk,
	ieidus@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH 1/1] mm/ksm: avoid missing ksmd wakeups in ksm_enter
Date: Mon,  3 Aug 2026 23:21:15 +0800
Message-ID: <20260803152115.3479919-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgAXmNjtsXBq82wZKg--.37710S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw48XrWDGw48KryruF4xCrg_yoW8Gw1DpF
	4jg3yUZr4kZr10gw47KFWUAryaq39YgF48Gw45A3s8Zr98tw4qgF4rtr1Utry5KF4kZanx
	Xa15ZayDAa98CaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j19a9UUUUU=
X-Originating-IP: [240e:46d:1800:3615:fcc9:ff1:4d75:c015]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3A5eV2pwse7c7QAA3v
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D0A9340009
X-Stat-Signature: sh75feuedps59mrms6ytdq9p3qqqehi7
X-Rspam-User: 
X-HE-Tag: 1785770498-712083
X-HE-Meta: U2FsdGVkX1+GJ8ConEdW+ZflOTlZORl9vIUTPW87vOxFl9GfinpGiiHJeTTlS03hxLXo8meDfUn5fw/U2n7Wrx+NGX+VJLuoO8XfKdb2inAgbBjkHeEMYSnkIreXiuy+NuDG268/Lv4j1msCyLwSYVviWF5HkGwiuG0NLmEh/pS5tvnUFHR/PYkgX7xdkkBY1wL0OUC5iTRFo+fu2bpHXWzRt7/UGgky1aZPe6/82GSU6mwniVNCwXkKBBOV25soW9s6JZzifN/lkXpX5e8ovs6SRw0jybYUhOJXbz6OzioPFPmn1LwAhB+Gje7wI0720shzVi1Lvmtxo4fHYZH7uNPyQn7Gn+yKPZMrxKwEwy26UKPuqGhIdXZuhyvcOCx23GXjHXmX8Dxy65ZAhSxTEKHzkGNnwc26gxQv5PUPPGEjQfw10tO11AFq1RUcSNFFZHZVC4Q03EAdFVn7OWcdID+3V72Ly6TVviQMpB75x/L8uAvt/4eCn4laN7gHjQZ0MYENRqX/6rbLXuzs9zGGBct7hbOPbBLdyRLWLQvXF77LFonKSMXL8/EnRvFfwKDZyQlrMdyKC8Z/GnDMq76hLrn5YM9fiAHMP6T5++UhuAgq8iE3Hp8aYshx+A+r4v6bjEc7h1UZEJVMj1fwyZB7n+rE1F6UMYkyy9K5KUHN4bdfAuYS/lNkBnXXWktI3o0ZZnrxwYG3jCbS+tY70YLjiA1hoFFAYmV9SHhND+krplnBnLmVAr7kg3Ck5PVkdbo6dK5kf8YvrKQQzKP++lK7EPQ46Rwi5z7JXQY4wrtgJMap23kPtXOMgMPNVo0oe4uh9GENyS7PlpwSzp7JHPULCQ7ddnSz1b1euT/UrXwUAKkKz/drQqfo/5ahXR72S3SOnpoFGGFSZ0s8x8F8V7KfHUANaddRZ/erP3qsZ3QYyrhB4fJsxS6yURxg75CBs4bim9FCnB4eDkJtGsLz4J3
 +65ZiXFq
 J5CmN3CFIByOSJYBVEj6WiTg+1q/5K5pL60yFk14sECSkd5Iruv0FNSYbNL8BFipkVWJHJYIarb7vt0B6lv2i2wkfo9Pgn2YO+ZK+mTNtI0uNKuRdz5S/h23D3yDG7zr3LEFXOOA1dAZHqNT3mHb6bGUSQjc2bW5Q4edRSwmNRxOOFdSI4OwMkaCCwT70HOw6rOnxwXnWeP6XuXWeGuYKtNODCy8Xm4cSMPGNc1PiuzkN4k1zu+0BRDOffCDAWquH6jOGgMhpKsSAX35DMMdBC7qUreB2xlQPPtpmoQnAj+LTLNFIOInzOQJd4QA8BggNT90d2eir3uJ2damaKgJaQXOTn7NuPQ7e9LnfaDx39pyu71BfnpgbJsHVmdV9gprAV2EuCJScQsB3m9sJYApX3iPRZwM7wBy2hN33/GuSNF3RVOh4RnAlDlyCDDkLnBCQyUNU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

__ksm_enter() decides whether ksmd needs a wakeup by checking if the
mm slot list is empty before inserting the new slot.

The empty check is currently outside ksm_mmlist_lock.  Another CPU can
remove the last slot and let ksmd go back to sleep after the unlocked
check, while this CPU inserts a new slot and skips the wakeup based on
the stale result.

Take ksm_mmlist_lock before checking the list so the empty-to-nonempty
transition and the insertion are observed as one critical section.

Fixes: 6e15838425ac ("ksm: keep quiet while list empty")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/ksm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..3f2f4707ca9e 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3019,7 +3019,7 @@ int __ksm_enter(struct mm_struct *mm)
 {
 	struct ksm_mm_slot *mm_slot;
 	struct mm_slot *slot;
-	int needs_wakeup;
+	bool needs_wakeup;
 
 	mm_slot = mm_slot_alloc(mm_slot_cache);
 	if (!mm_slot)
@@ -3027,10 +3027,9 @@ int __ksm_enter(struct mm_struct *mm)
 
 	slot = &mm_slot->slot;
 
+	spin_lock(&ksm_mmlist_lock);
 	/* Check ksm_run too?  Would need tighter locking */
 	needs_wakeup = list_empty(&ksm_mm_head.slot.mm_node);
-
-	spin_lock(&ksm_mmlist_lock);
 	mm_slot_insert(mm_slots_hash, mm, slot);
 	/*
 	 * When KSM_RUN_MERGE (or KSM_RUN_STOP),
-- 
2.43.0


