Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09327C982F0
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABFE46B00D9; Mon, 21 Sep 2026 09:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A708D6B00DB; Mon, 21 Sep 2026 09:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ADA86B00DD; Mon, 21 Sep 2026 09:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 720976B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:18:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5ADBE12019E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:18:04 +0000 (UTC)
X-FDA: 85237822488.22.93FBFC3
Received: from mta1.migadu.com (out-62.mta1.migadu.com [95.215.58.62])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5D11114000A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:18:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=myA1+5KR;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.62 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789996682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlUeNXTqokj2yuZrGgcrCQUAECPD6R71OqQgjTd+Ltg=;
	b=z7MybK5Hfg1KG08sRB1zkB5FY2y+266VJ4vy7Q5osYf46iLFJ8w0ysDS7iq0Q0U5nkogId
	lGMvx2DwhJSlYKLLJYq/tPZWN4GfDouvZo9Kob0xCdqYJ8FTGeJuezX7qSlmc9ObaOV0qL
	PDzzH1oVqpbfaVbp1uO+vXvs8DYOPxA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789996682;
	b=EEuNk7WbnHstoFDVfWxxlPoUO2vx7oJzjdirR0zAr7kiW748rrnnmEO3W3NSrdWDf9pVQD
	qtnOmdR4LYl+MeZJn0xHivQTkVZ0Yr6roXt1MsueZRAQ4WcSZTT6OgIAIQvgnZXPaZj5t3
	/XBz7VSVRwDKKNxHH8llCWwJF8f2MMU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=myA1+5KR;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.62 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IN3u//Q3+OpLA8rMnVjE8v9xBIK2AikPADGADNf418I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789996681; v=1; x=1790601481;
 b=myA1+5KRkTOpFpgN9Q7qgN+XSlBivE/MVPxxYjs+yMiMagjddcNTGevuYj+9z2O5eA4TEJQt
 X0YPrWdUw+XglWLP4iIDUMuTvTxoEvNYtoUhP968mOD6fsh+JU8gbRzxTXlARXkD5e7AQkcp5M7
 5HngVexuaiONVCvxe8lRki60=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 28b20bafde2dc762;
	Mon, 21 Sep 2026 13:18:00 +0000
X-Mizu-Trace-ID: 28b20bafde2dc762
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Mon, 21 Sep 2026 21:17:23 +0800
Subject: [PATCH v2 3/3] mm/vmalloc: skip vmalloc_dump_obj for non-vmalloc
 addresses
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-vmalloc_dump_obj-v2-3-73fceb3ed1c8@linux.dev>
References: <20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev>
In-Reply-To: <20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Stat-Signature: fgokwcybi8k7ub1eywg1hmds3q3gnwmb
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D11114000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789996682-804134
X-HE-Meta: U2FsdGVkX1+TJiW2O2/t1OZ8b6wpMX/KeOzOb+19WbglHP/Fq2cTTEvCYH1Nug8SXnFCZZQOOvN6uV+UBfOi7nrakJchDHI3qKk0EzU68QOsMV8b/MgSLmUYmXUry4hax7lQXLeqXIDiuuXFX6e15peItPeW2Ld9e3UknhVYg/alVyu8eu1VdASfwwcDSKn1trn2tXF4jT7hVqBjjD0R9jE7Qmct5iC2oHtzr+4DobHPRn0BRub3xiyxUrnh4X2+BSuIDeDpMQpjXuaV3cwywbvqYRSFgto/dEnIbrzLj00Ato4AZRD8nhpIhlQ8YeA3uHJ1/BLb8J9M+M5HjYsWKfF73H2Z/xepNO7ZQmJHAD2s9ZoxfMiWj95PmZ4nWHHTV7bYxU1VvafIChOIX4E9GpN6YcPEGkdJ+7EBYsGo9QkCmBKgiRv1hK9wXty9aH7e2bdJBRRMyQPZZxRxDIs2BEnIRaZw9hTqh/LFSyEYAgaXZlp0YZmYIa5begVMkmbcCOAoSt42pQ5nLFYFoW561GfT6NnClf01CjWGUNrmPa0Clna8tHZvVPQjnnWzL4zHXKUVFymAitFeGvf5HyYqwjx5rHf0C6OSM/bgVtN6N1jiduHaw4E2Zb+7E6CIuZFrlYTDEfHMAHXHgF0pV9PcXkf6siA+CTdg0ih6kIhiYescjM/A+MSNv6605hbEdbpjXYhVYyh2tv+GITvPooC9lPlcwxsjQnzesyYMPK4il3x4wwqAZckgfYfZocSh5rOUkNCFsDdRsK1jiqsT+EpBt2u6pBoT4MiEvnTbNqUfd8Jfds/QW7PgB+pzehTpjT0YlPX9IBOWPxt1gEFfTloMBT0iywJkvhhQ/lvEQ360doFKAbnpImTLssMVDoSSQWbaz+rMS0AFdDdDw1cdE6r1N8P3xfRdE8pk9RMNkXByxPefeM6sGkPZDEgxfdLp3KHybsHBJujl64EUF9IQuhl
 DWkR3zFs
 FJHixa8ZGYiPSRnkqKFtUTZa6SmpiUCd5qGLfHIanCtULkELuFhip+Xn2m4Cur94oJxjWZO0IbHOXwbIaINLj9mEuI2+8Ikci40PiXJoI33WLl898Pc2myso5792We17dzQywFJ1xmNCdhd6LkP+mTixoXVKdwMcFWptw8KB7fPu6TAO790WTdSAHpd/X4Z16Ze/36/k1hjv4xuE7cXW6X6iKLeCkLRdq0IlIrQ8FkewkbYzbKmGtVmJuaLPDlMqEWYiUUN07M7drd2F5UWMApyBPi88EEoif+OR2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

vmalloc_dump_obj() unconditionally searches all vmap nodes even when
called with a non-vmalloc address (e.g. a slab or stack pointer from
mem_dump_obj()).  Add an is_vmalloc_or_module_addr() check at the
entry to avoid the unnecessary per-node trylock and rb-tree traversal.

Use is_vmalloc_or_module_addr() rather than is_vmalloc_addr() because
module, BPF, and execmem allocations reside in MODULES_VADDR..MODULES_END
on x86_64, arm64, and riscv -- outside VMALLOC_START..VMALLOC_END -- but
are still tracked in the same vmap_nodes rb-tree.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmalloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 30c610f678dc..d8095b558365 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5277,6 +5277,9 @@ bool vmalloc_dump_obj(void *object)
 	unsigned long addr;
 	unsigned long nr_pages;
 
+	if (!is_vmalloc_or_module_addr(object))
+		return false;
+
 	addr = PAGE_ALIGN_DOWN((unsigned long) object);
 
 	/*

-- 
2.25.1


