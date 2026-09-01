Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C6DDC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC4CA6B00A0; Tue,  1 Sep 2026 19:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B75D76B00A1; Tue,  1 Sep 2026 19:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2366B00A2; Tue,  1 Sep 2026 19:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 885536B00A0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:25:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23C77C0538
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:25:00 +0000 (UTC)
X-FDA: 85166775960.09.F823EC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 73B90160003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:24:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UgcS4yZ0;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788305098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jk2RFe/XVKJiusQmuo8ChyovasaBl76wwu4zIL3Vsv4=;
	b=yjqgZ03uZDj6p5pjKHUKTDf2K+G0cTDNkgbT06YzafDuCPSdw4OFIcUMxmkqlZoi8Q4dTS
	OSLkdAUup/Ef/FWrqhhYdxIijasRNy4GsUS3S09rIrjR7urOrriX68QZ4zEnlnW3moD8ra
	jjqDhZ+RZzEJoqquqtH2SjAk6DyRkVg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788305098;
	b=BFhFmWtAF7vz6N+r8PyTj4t+kjiPryezD+/lqGBZdmGS1Jgtrb3kmXjldu7xoyttECMk0i
	27VvDCnm6twDOQt4gfZCHLE93wQ5iPk6Ugej0RrrwIROQkQW2ZrIHtctU2JtVArtc/QSC2
	fEKnnIOrsWaRvQ1E9PAtSsbeIOF3qi4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UgcS4yZ0;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1BB8434D4;
	Tue,  1 Sep 2026 23:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E0D1F000E9;
	Tue,  1 Sep 2026 23:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788305097;
	bh=jk2RFe/XVKJiusQmuo8ChyovasaBl76wwu4zIL3Vsv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UgcS4yZ06pssXbFHHgG3+Ba+Bbr3x3lwd8ymNYfhY8aNnW+fzhwjTE19IIdLf3Sbt
	 /m4VP+4uYyt8LOV1zRCYv/cYeVi4Vek0sUaMdYHVc2IlCjkRp3vS1Cjgyau25mxUY8
	 bwh7uq2MFhTrAQR+r+Zj0aO6vgdKbxMPBMc3qERLkgpyUZJytfp07A4i95Il+ODhqe
	 CM3yE2H6QZVkEGDb25z8NtTRBm9YdvWbnecC2zBCWXX7LzNZtlXn+71xRLFJPMIs1g
	 9RK51c7UNMO8stCGfu1jVeMzO9TY8zHr4C1miE8AZT/dVutp1osI9/cTZheaIrSSrj
	 tbhlffqX8dzVw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v3 7/7] mm/mglru: batch move folios to the second-oldest gen's LRU
Date: Wed,  2 Sep 2026 07:24:21 +0800
Message-Id: <20260901232421.40157-8-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260901232421.40157-1-baohua@kernel.org>
References: <20260901232421.40157-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 73B90160003
X-Stat-Signature: g41dyu3cyjqnxkmyumfgxue1d9r4ef3m
X-HE-Tag: 1788305098-923421
X-HE-Meta: U2FsdGVkX19wMGziFA49WwxbPPbd2oYHaxOTJW82uGM71FmbZ8u5lxENb0iEJvtM3Vtwd6pGj8RjORalBdW+uPCJW9wHnocNmrFD143tstM6Wc+G2zgTRYMR+6CsYNLO/0fTNUkZNgYQvqPHrzL294VFq2/gKNT0TW9GyxuKvpl66RofIAm9swIUN8zfsY7xd3hoM+SGBtgeIACxOTQhs5l4KTMjdLIMLnnV1Us1q9bhxS0fl0A6DAVODjDwEBgjj790k1yxaGNyRnMvrFauv1bujL92Be8mMoalgIPKqOkq5ADREP4FhKqWXY0E7OTF4q44QOrJIVtofItL5tSI++QxNX1f8Q/SYgjHF1OFLlZxXuU5Qt3IoHRylA3kzJ6oafEgq0SJ6t/UN+duOs0xDTrcrQ5wav6MFU+q/xOeS4SJE0efD3w8N+EEKsH9HfjehRqa1Z4nGJLrRfr6Lg1Af+NgUUhZPW3hMwdj7F0NS1DpJm4BlYBQPS1a4RDjZ1Lp34od+R3LnQAHI0Kf+DInPiR0HXmciTynb3/tq8p6z9/8sCPOZbEg5g1qUOn2zrmTlLhUGs8wAZ3PuwLId7Wd7K17RXhSoMNfF7gQ6ZKt1rJkdvXg8YIdsaBkV5ZodVFriFgd0pmleSpk1I5g/xuyJWdgbpWofMZ2pfxMUHM7P/XahTNDZlNhXf2Pm5d2ayXjNE21sXWklt8EZIbPNuVV7WIRAbxgBNli+MA5hlKhjfddjZQ73Ie+9qpBhcu/0+9NOZi7pZLRiUH/C+GRHTrWT7NnSuO7hxc0iY+GcwLen/uH5ZuHjGvcks7SctnZxka/wzse+YvYEkmfRrN3oC+Tao+AU19KC8wFV0axD8Q4af4heqklTNdpzBxF9vAz5TAaSiESQadeLIg/1Ro4FoZB0Jp9nVIfKfr7Yi5LXpcO3Hfgv2tOUH9h+GcQze3zpI1ufvhKQMvcJnZyoFwYSsF
 l7vc+swZ
 Ac2kDzWMwtlnhbyH8TgiPB+0k4nXkwXCXXQNhMOE1Pta97to+wcIoF1xaYp+bej9FlCoe3nk53td6SeobnFXsOSkkIHeFZIwg1hqDYkCYATlPNHwiZe3a0DOK4l0osASxwYfNwfTu3r5jjhSHeHL3Hv0pZMT+vAKK6XVNplk/7y+MTNjHnvarikeaHo1x/JKKw4ImS5+mfQLfcH56l/hYrvDy1xoKIeiXVcmxq7HLdR1IZnNxVUS8rCFV7bkExRWQgs0H0ax+EEdrTOXeMZmQ2yPhEtSpaf4H/abzi3kgI4cdGFDx1GVBSnoKfi322P/5TwM6vSzrTbgkPJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Detect folios that need to move from the oldest generation to
the second-oldest generation, and batch-move them together.
This can significantly reduce the sys time of inc_min_seq(),
especially when the other type is significantly behind the
preferred type.

Assisted-by: gemini:gemini-3.6-flash
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/vmscan.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 76dfa9575852..79defbb44c6e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3931,6 +3931,19 @@ static void clear_mm_walk(void)
 		kfree(walk);
 }
 
+static inline void flush_lru_batch(struct list_head *head, struct list_head **batch_end,
+				   struct list_head *dst)
+{
+	LIST_HEAD(movable);
+
+	if (!*batch_end)
+		return;
+
+	list_cut_position(&movable, head, *batch_end);
+	list_splice_tail_init(&movable, dst);
+	*batch_end = NULL;
+}
+
 static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 {
 	int zone;
@@ -3953,8 +3966,10 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			lru_gen_is_active(lruvec, target_gen));
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
+		struct list_head *target_list = &lrugen->folios[target_gen][type][zone];
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
 		struct list_head *pos = head->next;
+		struct list_head *batch_end = NULL;
 		long delta = 0;
 
 		while (pos != head) {
@@ -3979,7 +3994,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			 */
 			if (gen_increased) {
 				delta += nr_pages;
-				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+				batch_end = &folio->lru;
 
 				/* don't count the workingset being lazily promoted */
 				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
@@ -3989,11 +4004,14 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 						   lrugen->protected[hist][type][tier] + nr_pages);
 				}
 			} else {
+				flush_lru_batch(head, &batch_end, target_list);
 				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 			}
 			if (!--remaining)
 				break;
 		}
+		flush_lru_batch(head, &batch_end, target_list);
+
 		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
 			   lrugen->nr_pages[old_gen][type][zone] - delta);
 		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
-- 
2.34.1


