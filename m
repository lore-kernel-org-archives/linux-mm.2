Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01EC7CD5BAB
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 22:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E183D6B0096; Thu, 21 May 2026 18:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEFCC6B0098; Thu, 21 May 2026 18:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2CAF6B0099; Thu, 21 May 2026 18:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0D246B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 18:38:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60F43C29A9
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:38:22 +0000 (UTC)
X-FDA: 84792892044.03.C907214
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0647618000E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:38:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v9g1XUQp;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779403100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tUi5+SVB2s9OC9ZFGLX4sLcZOUGZkUOYCUsvpkjnlcM=;
	b=mKwghJUZ5asl3+vvHc2FtPKtjnspxBJACWW4RCVw1dKZDqAZ2Yz4Irdb4M5iz8DRWciS6Y
	/UAsbdItR7LZjvrcnbRdw7NgpKJ4io7Stp2gCbdgM8sumJ5q0ZsNtoRsf2xL7FvOSium0I
	byJBxmHZ65oOuVaIhSvrLV5bz+BvXzs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v9g1XUQp;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779403100; a=rsa-sha256;
	cv=none;
	b=25i/09e138LbxXNbYDmWQ72xgMDVszsGaeDJZvhcOa5l/L/iIsX7Q30a9Ve369m7XsBZA3
	jGjN1U2vbhT6WOu6UfIeDdPt4YZbk+6pzh4jWtUlfZm7UmzbRBxA4KeHj4jvW1qzc1GWBy
	qQRlnrW2TXgSyQS5YaN+IAPz9vgyEv8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779403096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tUi5+SVB2s9OC9ZFGLX4sLcZOUGZkUOYCUsvpkjnlcM=;
	b=v9g1XUQp0LjMCL5Wl+pmKwYTOD40EbXI0cC8p0Hy5ftbqmMQR7n+LPH2sK7JHitDRO9Ash
	pjlzVYFAkEAw4trzcwLdI+efv+bkiEua81mve2flffuu9mXyR5TnAtupzahMU/8vGoKNNg
	GjpSLF2YLa61lwDpo4H6YlePn7/Z4Uw=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] memcg: use round-robin victim selection in refill_stock
Date: Thu, 21 May 2026 15:37:51 -0700
Message-ID: <20260521223751.3794625-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0647618000E
X-Rspam-User: 
X-Stat-Signature: uizyoiuip1ei4jd4xxfguwizitbr3jjr
X-HE-Tag: 1779403098-917116
X-HE-Meta: U2FsdGVkX18Z0yoY3YBeQeZH0Q3wTQWcFiu8+CZWQhdtSS5+2dNq0HvdZQnDARzKWMFaKGqmoAEzZtPEumAiOfaPa7g9h3EF9Hx4TNKV4AjyVVmM5N57TFjG59oS0dqr6l7HXeCdpiAKhUe8n723menh214Umo2Psy2UZ9146I9mJT5FEYlTgRklkiy60plGM4C7p7UcNSsrTVWkC2I7zYMaJt8NcJ3b2PFpo4Mle+6zYB9OZCqLS35f8wcLnzqoUnmyThP56EFNskJsafkOlVQbXsenqQ2lbEOPToFyWAbskBWRqFoeyeRYLQl+Uz6UUgzyzDD/VNPCMbh8g35hkiSqlFafxQptzOd1HIegbXHOncUqeHT0LgmPlDd7Gky6kvrvVDwgfbSEqgtgSkdAyNvTGm0niPCv0g14wnz6g++TJFLTzT7C7LRszg38R4V2XOIKoQV8fYcSPSQqrjVoe10rf1wDu1BIUOjo5X2XJQ5bKA5tbWAt9VBJsrIh0iI9Ohme0X8D1w4OvRYUL+QpcbxjSPD+1MXmizHqVSo5fO/46DHmaztSYBa3Tvv3aQp+6UBx6zvXmPS5wOPHXmzWc5apOR1tVHXtQ3AF2a0ie9f92SKTZxwRptY0+36/ZrFcGAs9vpMenIRUK85ECsjnnG/cxmRmGLE/M4WOBUX+VLEArbtB0Hwwm/KGA1dWe8vqUUw4c71zB+h+29px+yC8gw1so0oHQbtZM2dTxq9YG0j+G5jaHLNTPUjObaUNTup9nGjpsXXYhWsn94ZucYgBewiHAXRfUh7cBdBBb+6y+J2kZexOha9iZDTh5T6JsDBceOjNVM5utUJGzAf7BoAE61J1HxKzRtYUN41y8DUhSK375rBlMglKdM9FraI5XP1Ce442C9m4rdGWjRQRiN8Q3kX+mGhyE+gfo01z2PrI5lsYr8INVE7uiM/qi9oJ1xknjqzQh2wA6A09ht91S9R
 8EGxg50N
 OBU53IZlZAi8b7lBkmcM005v+Pr5xWpp7PQA3kJG7hEqkmr0MxgjDvyWNzvAqTzbqJCWXdc4XbqyLv6Fx3ERsoo0HDmDho7kV/6/Vyv03En4BhGboBpmPWRU4lU7lRMXa8eOwhFNlNU/gaW5cmq4SR6FdeZwJHHYN5uJ7tNqmv1lL0wl5Aveigwoo8X5EqIvYbqvADKoJ/K4lGmwl3e5NA2BHNLBU2onwXmQSttVthQQNALE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry Yoo reported that get_random_u32_below() is not safe to call in
the nmi context and memcg charge draining can happen in nmi context.

More specifically get_random_u32_below() is neither reentrant- nor
NMI-safe: it acquires a per-cpu local_lock via local_lock_irqsave() on
the batched_entropy_u32 state. An NMI that lands on a CPU mid-update of
the ChaCha batch state and recurses into the random subsystem would
corrupt that state. The memcg_stock local_trylock prevents re-entry
on the percpu stock itself, but cannot protect an unrelated
subsystem's per-cpu lock.

Replace the random pick with a per-cpu round-robin counter stored in
memcg_stock_pcp and serialized by the same local_trylock that already
guards cached[] and nr_pages[]. No atomics, no random calls, no extra
locks needed.

Fixes: f735eebe55f8f ("memcg: multi-memcg percpu charge cache")
Reported-by: Harry Yoo <harry@kernel.org>
Closes: https://lore.kernel.org/4e20f643-6983-4b6e-b12d-c6c4eb20ae0c@kernel.org/
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0eb50e639f0a..6392a2704441 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2031,6 +2031,7 @@ struct memcg_stock_pcp {
 
 	struct work_struct work;
 	unsigned long flags;
+	uint8_t drain_idx;
 };
 
 static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
@@ -2214,7 +2215,9 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	if (!success) {
 		i = empty_slot;
 		if (i == -1) {
-			i = get_random_u32_below(NR_MEMCG_STOCK);
+			i = stock->drain_idx++;
+			if (stock->drain_idx == NR_MEMCG_STOCK)
+				stock->drain_idx = 0;
 			drain_stock(stock, i);
 		}
 		css_get(&memcg->css);
-- 
2.53.0-Meta


