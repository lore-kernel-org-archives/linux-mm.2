Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E25FCC982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A34A6B009D; Sun, 20 Sep 2026 03:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C956B009E; Sun, 20 Sep 2026 03:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAD026B009F; Sun, 20 Sep 2026 03:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C51E46B009D
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:21:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3ACB8A5BFE
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:29 +0000 (UTC)
X-FDA: 85233295098.28.D851239
Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	by imf28.hostedemail.com (Postfix) with ESMTP id 53B6EC0008
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:21:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9E7p/nmITTZTU7ko1i8gUOkvmM5fhb1fq8QqFrGMfJY=;
	b=akDMBAcYetsMWm6cJZ3/ORH4pfCGNo43zNOLdi9zQoXV4jY0JLmzFgbqbb3g6Ovly4z4C5
	mjZnqy75PZNB+pNrBRu2X6ymeFVxlKQR07dKoK/SDgS1PApAtPpLKWzbFV8u0v3NSbYbBf
	YfF6Qk9C70F4vycFrBa+TrMPmsJwKQ8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888887;
	b=iflPD+9QiEe0dQ81W5bGw6STFsgFkhnFQM2WxSSzutHuWX4FikkflqFZ/mbCjJdxlai3nE
	CW+eReHRLga0sY1tI+bwjzbK/McKX7F/6ex7pqQZR031J2YFLWzJPWcZutSmL16gIE/UGF
	Uw9LMIuAEspzyvtIgwAIQ4g8IjTHPW4=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 77a434c3c8b53a0d;
	Sun, 20 Sep 2026 07:21:26 +0000
X-Mizu-Trace-ID: 77a434c3c8b53a0d
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 06/17] mm, swap: fall back to disk when zswap refuses an xswap page
Date: Sun, 20 Sep 2026 15:20:32 +0800
Message-ID: <20260920072043.430390-7-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 53B6EC0008
X-Stat-Signature: 6yzc6prsi8tx6pypto3g51gewhdq7sfz
X-Rspam-User: 
X-HE-Tag: 1789888887-636708
X-HE-Meta: U2FsdGVkX19TU9I5FdiWNwBsMcIBqiCLzjqWcYgka/2e6Cq5t48fXi0WU4VYlEtWAh4BK2fJqiireS1pj4fQhdoRK4yieh+Q7NVq/n3YKn4RzVS992JPv7woBjVZLSDhTxwwySKlHLbYYp2twdysI8fx74OkKQ+nKdipKw/NfNJXXEevf13gaqmANpJFFJ/FmsOv/nWmGpT36xfZF3LNI/xT89K6odfzdnyJB9wcjSGaIvHOaQqCsLQ+zuyoGrBiMfxTguHI7MVxOKaYhCGWKe+0qf9VZdKkFCKRx6wl1JAmd3rThgGIwouC6V0bj38P16nWckSglWRTcfs7uDI7ndwteMxvbP6XVxmz2DGBumJs2uiikIyjtWokjDfmySv6xe8BNkwkrxBpnI03vQISLLMUKpL0s2S/88Iq8PTDTyW3rlGs2nXklBvYqGjlqD+P4pcmBYbPOzccGQ3FhfxqhCQHT4T0a4Qhh1EcUVnRKfC68oRTNd6TG6D7ZfCoUNdCv6YIcGG/MOZS30hEr3gWo1z0HH4YHHJzKW+FFDgo5u1ZfnWohe75zq56rYyzearuMsv6d+gKKkWVteAwLPkl14+Jq6+9bi6IAAxNOxELzDcOx73ZZWu4ubFz7IXg3/hjTvm6m7TS2qF1wGly5vcnOlkOcD9mtu0L6CnB8Az197L7sFkhactl8g26BMztDkfVTB+AHDHFVPSOaQr+IH3x0rKOSf/4mV6XkNW54Fxe9BV98HlTqhpiCGYrU9V4pto8JeEihxl6BcbKOhp1CJYDZeLo8pVBN6nlWe143qCuhzOhdhjND0Sn4UqNZkKJWrVf5ioTpoZX/6U8ikJ+UOBKItuBekYJHXQsH+76PD1lu8Ti/Wp3hFozluOBFgdkqfoI5QGmoJqu48nXZk/GufA1hMUDqeuSuS/riOkUY7FImvCFa60spW/dVGelX8/5xNQpA/9quSfrGvGvJscTxT3
 l+caEHkG
 9l02t1vqeIlDSdvNRlleVoy1UaBlXf9C2IiWt7Lk4M7J3AaUmZ2KyGCeutvXMizBnJmZZPT6Imhg7McO0utIjtQ56wkPoJb19zS9mkGzxLwh8UKuOkieOwFHQG4SNoOSv62F/IlTEApayvXywsVw+AsVxA6WZXeiqtx92sQsy15gQVfSOftbaTFNa8Mnx0q5LVaH2QAfQdiQIqC/se2l2XBj0MN+yxqa3kG5MY7D1CBsiHo4fUCAJlJYx9j4M4+BP0s7nkGtfllbqYu52UilmZWMMlP/yAxc/XOX/bB3VR1v5VLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_store() can refuse a page if the pool may be at its limit, or
the page may not compress well enough. For an xswap device there was
no way to store it, so swap_writeout() put the page back on the LRU.
Under memory pressure that turns into a livelock: reclaim keeps picking
the same page and the pool keeps refusing it.

Now that xswap slots have a physical backend, write the page out
instead. If no backend can be reserved, keep the old behaviour.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/page_io.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 32e426779dce..d521ea335df1 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -253,8 +253,18 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	 * yet, so look the device up from the entry.
 	 */
 	if (unlikely(__swap_entry_to_info(folio->swap)->flags & SWP_XSWAP)) {
-		folio_mark_dirty(folio);
-		return AOP_WRITEPAGE_ACTIVATE;
+		swp_entry_t entry = folio->swap;
+		swp_entry_t phys;
+
+		/* The pool refused it: fall back to a real swap device. */
+		phys = xswap_backend_alloc(entry);
+		if (!phys.val) {
+			folio_mark_dirty(folio);
+			return AOP_WRITEPAGE_ACTIVATE;
+		}
+
+		__swap_writeout(ctx, folio, phys);
+		return 0;
 	}
 
 	__swap_writeout(ctx, folio, folio->swap);
-- 
2.54.0


