Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C41E8C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801FD6B00A0; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78E236B00A3; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608386B00A5; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4051A6B00A3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:13:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AAEEA56EE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:37 +0000 (UTC)
X-FDA: 85216340874.06.3B5DDD7
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2DC5E4000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=nC9IA8+f;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf17.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485215;
	b=YHrW0n97urzvFpOYGaPXeY1TWsmMKV6V2+PvpHLw9ddD7bFKwxOn2KttHIhYmRJOlh19TN
	bUEU2vsQ8WaSeRU5NFhqZML/6qd4f4Z4yfxr0zJ9fJcntar+S6+qQkqzVWvbg6WjQ/fcPw
	IxUjOv5UGJYgHyj1UkiPCDr1rpnJHOk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=nC9IA8+f;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf17.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUV0qCujnR7jWHBaxK501gzxqQAOmB8+/waa59ibNAo=;
	b=vV4SbYlpVJ51M4uhGvgBVBpwss0/WvpHbPX0wLxtbvcTpgKYifc/zOXRdCIIMzHoM0sEuh
	b8uE1SaWjgjfPXPfm5c1cfigBU7ZXWj0p4I0EBtFl1a/FIBTo4jqkur5vEz+lHhChUi75c
	/zk2+1GMymwtMCk2WSMKCq/XQSTzOwc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=DU
	V0qCujnR7jWHBaxK501gzxqQAOmB8+/waa59ibNAo=; b=nC9IA8+fgnp4jEwOZJ
	DYHAny8HHu0tA3npvXPX41a8ZLTtxmknXGmZGu62lTlIXVODecETdYWEqC5ku4fr
	RKQ06VpqzER0bCTgb7FMDXqn96JNE4uGeqD/1iHUMCxXFXMbdyRYkWQu2gkt4tWY
	QLi3zXT61hqaoNImfIbpP2Cy0=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAn2xWOYKlqc0VUAw--.40469S9;
	Tue, 15 Sep 2026 23:13:22 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] mm/ksm: reuse the zero page pointer for merge tracing
Date: Tue, 15 Sep 2026 23:12:21 +0800
Message-ID: <20260915151236.5200-8-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915151236.5200-1-xialonglong2025@163.com>
References: <20260915151236.5200-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAn2xWOYKlqc0VUAw--.40469S9
X-Coremail-Antispam: 1Uf129KBjvJXoWruFWDZFWxWryDGFy8Gr43GFg_yoW8Jr45pa
	92yFWUur47JrWxZrWxZw4kZr43ta98KayxJrWUt398A3sxtry2yFWfKFW8Cr10qryfA3ya
	kF4UAF1xKr45A37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j2RRiUUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+BJBOmqpYJJV-AAA3J
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2DC5E4000B
X-Stat-Signature: tncpcbwiqd4z19sygs95ghbfzeo3ddte
X-HE-Tag: 1789485214-361465
X-HE-Meta: U2FsdGVkX18WZMPXkBTM3j97nevtTjsH2FJxWV+uaRoBXdyvodUzyy8m55M7LFq8ztho+iCowZ+TvdhShW0pbf3xZkaQFopGmPO8dZFhO45nWpF1WNu2zv/7PDIqUDVfplxeJ4XqAouF/AHh6Im0Q2GsbsH4nse6U9Yd2/0HuL/3iH2FSeM3YZvSBOP/pZzQS9/uLzyTNjmAp3H17YBZZWmgRoboOOk3flJfBPNDsd71+TsTEvZ24Rrrlp6duMrjHTofi5wPMLaU4X/25Jr0MiYT/n/5jFk0WQ6SxtXyDya8Aai65VgwHuyHS+cw/w2JWuNkydvpEbBjRhZeVT5LD1UUqdVeHnFbqSmZZy3eseYTNTVdwF9TUOaol+UtuSPO70INErS4YlQ9qm4Fe4X68GLiBrG1aNankclLLR2QNCXMTXDIu9rNAlinAtemXxM6xN0vmYdHkAcL0ozt8XWfXHcKrgfon/aEQaK4aWHcRcESOzgbfVstK/Y6hUEYOyD0fgKf/T5/Dcv5L1Q1b1hnUcqmTbpxZceB9ck+iPxaiPAcIWr0u4KOpYGfqBWiYgFG2q5F6EP2Ird2iVdIHPZzyqNanr0ydaQHRxJAeztriIa4mKFNwx9WgIMty7+RiPk9p6646jj6TeWIbyV+WVtfAOsRKi49ls2pKy6vDYlFvFai245sG4c6IfnbhjN8DhYRadQWlA6Y2TXXDwAqS/q9osJChLWGwHiq93VLntozJLcPYH1m1oMsupyiSArZS08l4BeXqqicAod5uhsKE+8JO/fEbJLKKcRvlTt/FQRDveP/TfM9VZPZq7g9K2StEn48libo4O+BCN92bLCGp16A7DyTywj9xPHg8ys2NLO8gbCgMpMzSdaDxfAv6n7jYbFfYa8tUr4kWutkAOQgbDw055q8opulSCj3BGICc6g9dcItIbC9IxIhEBYxIIsSFqm+p4ButyPQ0UdYbjBLJxC
 QaHnV6Ql
 s/Bo1ejgJbqZ7NcoXSON4EbaW9OYnfasRqGbeJMh8eGjSWLHQB4oEeE5VpUlGy4tSBFCixDr+BUw8LVKIwLfLeqt0OQUku+nsigiSlq7XSaG1X1hYbswlfSUov9fQroG6EI09M1N1SDtCya2r6HGxyxqF+6xl1C/4uKT8NqyvtPsJ69IwPZomZMCBuw3+UE2wkSLc4foK4x/t4tsQSlqbwWcasuIaCNq2fmEgMIfc2FPYJ5ea8elKNA7Sbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Cache ZERO_PAGE() in try_to_merge_with_zero_page() for use by both the
merge attempt and its tracepoint.

No functional change intended.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

---
 mm/ksm.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 78040ed99ccf..7fc9dac5d67c 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1580,15 +1580,14 @@ static int try_to_merge_with_zero_page(struct ksm_rmap_item *rmap_item,
 	 */
 	if (ksm_use_zero_pages && (rmap_item->oldchecksum == zero_checksum)) {
 		struct vm_area_struct *vma;
+		struct page *zero_page = ZERO_PAGE(rmap_item->address);
 
 		mmap_read_lock(mm);
 		vma = find_mergeable_vma(mm, rmap_item->address);
 		if (vma) {
-			err = try_to_merge_one_page(vma, page,
-					ZERO_PAGE(rmap_item->address));
-			trace_ksm_merge_one_page(
-				page_to_pfn(ZERO_PAGE(rmap_item->address)),
-				rmap_item, mm, err);
+			err = try_to_merge_one_page(vma, page, zero_page);
+			trace_ksm_merge_one_page(page_to_pfn(zero_page),
+						 rmap_item, mm, err);
 		} else {
 			/*
 			 * If the vma is out of date, we do not need to
-- 
2.43.0


