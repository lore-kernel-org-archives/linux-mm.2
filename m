Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10C9BC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 09:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3F216B0095; Mon, 24 Aug 2026 05:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEFD46B0096; Mon, 24 Aug 2026 05:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05D26B0099; Mon, 24 Aug 2026 05:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCBA06B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:20:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 424971603FB
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:20:03 +0000 (UTC)
X-FDA: 85135616286.14.EC146CF
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id A04601A0007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:20:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=bL+PHrQM;
	spf=pass (imf19.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787563201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qq6CTw9aog03XEKs9hMeWAiZoyfqTL2ZWlIAp3UfVfQ=;
	b=7WPSKhpGNQWiMOBqNHOlzCJ/n+THpFHcjNjWgUPREkZK/TKx0kDoG8ARc/psEM925bKg55
	BSI2ql28kG0X+KXSPAF3/hJQ5kSXqpQ4qPTvCsMXz6Xzn2/HXn92nvINirBgzwGVpE2fWr
	rC6GQahu8yC+vCURsnEfVEwTXkaemRU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=bL+PHrQM;
	spf=pass (imf19.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787563201;
	b=SujlgoC+NLhmIeMMUOr4tBgzUsy3qrjtFaB+0m5BsRduiy2zshog9af59iLSIfxp2Ept59
	cuPia0FRwxEUMLdgSJciGukBFiqHdV7yY16Mopp9vRiLgKM08btFpPe+nmrooFkqfLQo0Z
	tL0M0l1zr41HUSV0g9MWBPatZvbQa0Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=qq
	6CTw9aog03XEKs9hMeWAiZoyfqTL2ZWlIAp3UfVfQ=; b=bL+PHrQMD9HvsXVgg5
	g+gdvFry3YQw2ywvp8Mdl8PkXAhC9IIP9Q0LYDe9HOzofOJfgYVZadOHLdqmN/Bt
	DKmMIL+pHoFhtkdYAkntcLbVKYNgV00fl84Q1GvxTdqY2CUIgPAWYomC3QWf406V
	dcGGnaKrvclWOZ5cETz+iWf08=
Received: from XLL-9950X.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgAnWPeZDIxq17gxMw--.50121S2;
	Mon, 24 Aug 2026 17:19:23 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	paulmck@kernel.org,
	rcu@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH 1/1] mm/slab_common: fix shrink budget underflow in kfree_rcu_shrink_scan
Date: Mon, 24 Aug 2026 17:18:38 +0800
Message-ID: <20260824091838.1692153-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgAnWPeZDIxq17gxMw--.50121S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr18JF4rKr4xGF43tw47urg_yoW8JFyxpF
	WjkFyUKr48XF4UZr4kA3W8Xay5X3ySyFZ7GrWqkw43Jwn8Xw1fta4xJry29Fy5Ka48Xaya
	vrnF93WUZa4jkFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jbAwsUUUUU=
X-Originating-IP: [39.144.46.203]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3Bvm32qMDJuUSQAA3S
X-Stat-Signature: 9ggotnommtd9e9kg416dj4yj7jcjupz8
X-Rspamd-Queue-Id: A04601A0007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787563200-377319
X-HE-Meta: U2FsdGVkX18YYKIfxN0Ab3npsPbI6hlT6ap2/KKJlnKyj0770BrmScInJi7oUdkHF2y5XNrLuWfVaOB8H5Tx+IZc5pCmia/vwD1S36qYMMEol9AFuwjN47kRQwHSv0a4MryEdHtzxvUJLSQQeOIqM8jfYcGxyCrJRR/2UohgoAlbRzlEjV3Yg8yL0czjHrKd0KnemDcBrYTANU3cxo9H4tzsP63GpHF9RNenYMIihzafnOxYupoDYp30aiPX7bKDtHLIkWmB86tGNfLUGo99L6kjtcmpX0dLgsUhHcYdovv4PrXS9bnlAyymk/YOnkyLCrVp1AfExCLKgQji31LagUJCgDlh6Rs9/DcmXlBfq8hvyL/Rck//Y1vT6T1dabXkHZ/gNwFKGmLCz3tIMXLLkOhj1Qd+5U4TluM34RPqQ+4pXQg5q7MiC0PiFk+H30cXtse+oLOE4xLx0TZ5kx7jPgYH6O7rsqwsJQufVI/srMceJdBjsXdhFs//60FALlANIQZbzazHHcE8Uj7JDw8mnMlzxjKNyO1buG6Cdwgrc0Fg/Fv0FRirgMRWCMaD58bArJ/o96zF2qjCqtxJ5GkAofnY2LpC6x+YVog9nmf9d3FQ35wAvoRLoK6l2hHz/aW9pSD1hp4O4ZQmdiDQRpzBOTkh7lCWe2bCqWbhyRrJuuqMFTRT67nQjh49l90DmvCYa6NQ5g6UAgNR71Op6Zjtu0ZvUXkxMgF8eairPF+3e3QBR576htNNweADuzF8ZNG8MymmbjGJcJLA1VVQEOeeX4hLgDRfOI3YmrW8WqrUQWLWtM03/QqbaoHo7MVvzM2E9wQzpycHwJ714CSY8PVS/Dh0+rfsLxHPoZ47hvHQnkaeCGihmuejHRmEGRrtgq/oQb2NDOFR4oFpmnOVmpD1ssHUYJ3+KSwT/N7sMhWPT3s0z/1oMGUt9cxpQkc3mylMXmllFtYuOCPr2lU5zSl
 aJHPao6z
 1jmZYMAEwafVLU3wz4Xzqj6v+zeYbiSWwv0vL4sFZj71+Cq8+3+2WAj9QbKgXUErnYQCa+pQ/kLJxr3XE/ZeE8PuW+81czpWabZw8cgjgXOaD9L1uTP2UTbK8oGdnwWUzidZhFTTzsAYDgKgtMsdEdU/8vhbsy2qDvflRdgKM4rwjKtr+rfay3ygS+rnoWKlzEu+oMWtDYdv1md+2FVQX3V1zb4tpC8u8RoqILYRKUPvDCbfZiecAk2wDOz/ktfnDbZlkF8s+V4v5pzddj20UKiXNEAZLzF/g7rsJZweynpyjoLUPK7oB/IzKq/05C2XBtlN2tWhJLJmmMOCqbYg9hoZ+OCoChLsZG9Gq0gASUiwSB6udnMf3d++Y/6hWm8IIEnzml8LkCMHJq3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

The kfree_rcu shrinker decremented sc->nr_to_scan (unsigned long)
and then tested the result with <= 0. When a single CPU's object
count exceeds the remaining budget, the subtraction wraps to a large
positive value and the <= 0 comparison, which is equivalent to == 0
for an unsigned type, never fires again. The scan loop then iterates
through every possible CPU instead of honouring the reclaim budget.

Reorder the logic to compare count against nr_to_scan before
subtracting, so the loop exits as soon as the budget is met.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/slab_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 657fd75776ea..95ddbab290d4 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2172,11 +2172,11 @@ kfree_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		count += drain_page_cache(krcp);
 		kfree_rcu_monitor(&krcp->monitor_work.work);
 
-		sc->nr_to_scan -= count;
 		freed += count;
 
-		if (sc->nr_to_scan <= 0)
+		if (count >= sc->nr_to_scan)
 			break;
+		sc->nr_to_scan -= count;
 	}
 
 	return freed == 0 ? SHRINK_STOP : freed;
-- 
2.43.0


