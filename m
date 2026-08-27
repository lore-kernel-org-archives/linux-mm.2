Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79641C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3FA96B00A4; Thu, 27 Aug 2026 19:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19516B00A5; Thu, 27 Aug 2026 19:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A07666B00A6; Thu, 27 Aug 2026 19:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE026B00A4
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:47:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E457A1C0B15
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:43 +0000 (UTC)
X-FDA: 85148689206.06.3985BC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 46702140010
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:47:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vjf35Uvk;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787874462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qItSZf2IMrcadC3doUN+qm71ZNZWkB8tfnyRrPNJHJY=;
	b=mPnyS3onuktDSuBbzsL1TtueYDLUSexUyNQqJuWinSoiU1udPo3PWpZI5GT+ZLu5TRzc6U
	WfcEDovTuZsJItMSe9pVuOXQxuZtvjMrBHQzWHbEyNpn1mJbY3g44RwxMQSFDCqGABNvmi
	5pVvmSkDYQU3EQSLfltkA0htT+WowSg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787874462;
	b=aDyubP9Rsnrm33e+p0x+3bBjpSCmVb7JC6Ea8OApyjok2muUQ6n+KO87kr57pC65fva2TH
	MDwRvkrUJFIAoFIPwyxKei9ZjnaoRQ/1NtSSB/gvdWTFc2KUdCs6w+zowPJF/wxwzFzS47
	+3qiSo5Tv+SsafbgBjrDsdZ9k0mj6Vs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vjf35Uvk;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 960C541830;
	Thu, 27 Aug 2026 23:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAA61F00A3D;
	Thu, 27 Aug 2026 23:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787874461;
	bh=qItSZf2IMrcadC3doUN+qm71ZNZWkB8tfnyRrPNJHJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vjf35UvktgdHiWQIABTxMqaWim3kr4E58NO+7gveoHzr9gSUuODU+e/oPsz6xDDHU
	 d6molKBbiRPKf84hwQk5MKnfAuzKDUvOceSBI8UxSANtm2F+olNrsbn5M7PiwmhDF4
	 1kKleza67ZT3+22y7hBv665q2bHi7AxrnTMwcJ4denIPhChL6ThTf0gCjWYRftQ07V
	 6neNqlatpZ5vqdsoIPzu+ElSTTYbCqaIJy0yQceQLtwjMRP4rUSfNMSOMd6BiyFW1r
	 fWy8QvSUkhZ5kR2k0z0bhGFCEUppN14Hvwa8EoskbbyiCtYlmsixo0qaEdRzsuzG2M
	 f8+Xe0GMMdlrA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	lianux.mm@gmail.com
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
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
Subject: [PATCH v2 7/7] mm/mglru: batch move folios to the second-oldest gen's LRU
Date: Fri, 28 Aug 2026 07:47:04 +0800
Message-Id: <20260827234704.63163-8-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260827234704.63163-1-baohua@kernel.org>
References: <20260827234704.63163-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bywedyf4nc91szxsteu4gfx8h5gcrkyq
X-Rspamd-Queue-Id: 46702140010
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787874462-517694
X-HE-Meta: U2FsdGVkX1/4e+d4T2znig+EhRF6zZ2OavjRs3EttGHCMg5fq9YelrTduQnvUwiGi2F902NzPtG3CZ6Alo6D4MYfd2rINOznIcZ4V4m9xnfBqN7GyBlkkZe1X1eFraGyhLUPnQt0A596/uCIzsf5yIVWKBTczg8Ky0+lEZOZVAV2V6wi8fUGjpVTMJerycj681f6XKmy+78NWQObR8GjgmwTA1CvEta8rKPPUVi4A1XoxJKS5FmPWNIg0KxfOqEYzlCKVTteD/zVEIDm8+odnHT82iiggTeaJ80t+o+bXrAMGi3aJUKY38xGU4PM1jl2ZIXI3loY6zaCrRIZOKz5eRAFWncwcV7xN62EiSytuj6SCHVEtY391TfVk/8Hd+/VR2/Y7E3J94BLnAdGg+v6vjbRJ07ampGUdQYq1BUDMBM14n5MnK29XLd6tsetMCPKz9iMHY2bm2TTCIThmWHBqytrnTejlKTN3nDzFwz0ItaSUb3/5Z+uRjNeVl46aVgyASIPVs2jjPwiL299gFy9GCrgzB/V9UffqYHh0u2TjzYnQKqRAXJfa0rVJifFFa2fie+EN5svxUAff4b5o7IWyZ1ZE2QKERCmp0IXXeCji9aiu4+Joa5KD3p4h9lAw0fzyIMBIX54HgOrCKx1bIj1o/hN9UTnuzm3Cg97RQbaMFRe20igo687hh78ZzHj6mTclH11c1rIV0EkQOPf0wIjzfOkmpckyERxrUy+9nENbLwU+ZtRzl0i3YZWu8OI29QF1zPn09B3d+/vLnTXFrNcNTtU9bNzi2LlkzNDtAdKULZO2RDjGMntOXM1MDzjnlJXKLS3oFOPHyqai5C0M8BmDD6vW6ULYnhrF6+Y/unbNUHLitD+AHFOs80paXmFtyxC22kb4PgW5FVo0PeoiLyEm9gNieZN2g+MvPM/YQkP+ixEHGLLsw7ADaA7c+mOYIt1ZOENc6ymBuOAzTvb5OC
 oHpjCL5/
 ERK2v78dzZmw6tR3wtT98e1n8ZEPNBhGCyF0nOpVV/LAex8JPj0h8AEQ0YafPZyhknyvknbVnb1Wb59GcmLVQoBobcGkpOyRN7Mv3pwBCRKyH/65vnxCHXPJZTnJwVXJTymiLTs8+/ROThN/oWZYvXeOSajhKEFDy8BMMOzIW70z+ToQjTsAnrx8nSrBp8vqIjrhLSGCOr36pa0PYBDvRCSCG6IWqEYPDRUxhAgV/MXFXKjHnhDp7dUwuECBnHMfnai72sIWPVvCjY7Ijs28LAA5D45OecROApUGjOUqKaqSp4Q1ZoHj9VnOCz/CyZgfAt+SZ7CqvnOZrAk2bnyFd837DKg==
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
---
 mm/vmscan.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 17524e96fe64..2b6f3f05ce60 100644
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
@@ -3974,7 +3989,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
 			if (gen_increased) {
 				delta += nr_pages;
-				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+				batch_end = &folio->lru;
 
 				/* don't count the workingset being lazily promoted */
 				if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
@@ -3984,11 +3999,14 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
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


