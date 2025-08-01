Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A908C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 06:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C272C6B0088; Fri,  1 Aug 2025 02:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7B76B00B5; Fri,  1 Aug 2025 02:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEE5D6B00B6; Fri,  1 Aug 2025 02:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4456B0088
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 02:51:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F53C135D2F
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 06:51:41 +0000 (UTC)
X-FDA: 83727268002.27.86DB313
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5E58480002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 06:51:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=aBFgvr4f;
	spf=pass (imf30.hostedemail.com: domain of yangshiguang1011@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754031099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=js/8QZDGKgtadLXZ3mlum2mHnTfG3CZHtOq4kKZ2v1A=;
	b=qYFvgwTZ8qS/MXnl+8Q+BQWbRYckLEL824q/lEovrmjYPY521D9of3wLD74H0zuSdVyix1
	R0XxEDJnUTmoX/4v4i3zjxhU5mAOKSwa4wAj1uwvIkM2jUn9CmHeKVZEAhhS0SZKfo2sQI
	aauwXz+qwggIl7j3DEsVrqZFchWsEkA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754031099; a=rsa-sha256;
	cv=none;
	b=3FmHJyrpWJ9ysSnCQbZBDylPPqTADG/QLIudiJVQxqMJ5jMjsWdeZOT8X0rg1TAC/pOeVh
	pkirTLRf7eLG7qE9LaQU51/c+QZS69VbOxppyXDQTdDW3q+sv01JjDSxiAIoA4NBMgMX5i
	rxOTc6S66+3Np88E2Lw0/sP/+VCcGp4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=aBFgvr4f;
	spf=pass (imf30.hostedemail.com: domain of yangshiguang1011@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=js
	/8QZDGKgtadLXZ3mlum2mHnTfG3CZHtOq4kKZ2v1A=; b=aBFgvr4fOy4rJTRTRy
	Abzl01VLmPxlgb3nqGr6DppvoCm5+5DSPwh4jdFQcgtPDeLVJnavZd9lVp/FVP++
	oBuXOVeee1pCezqbVmBAGy0djMgldCHfVLwNY9ijOqnvyx1+3QEFIjK8GCOzmnta
	9v1N97pWolZ0idUV6BJRkjAxg=
Received: from mi-work.mioffice.cn (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wBnM9DpY4xoi5QmJQ--.50286S4;
	Fri, 01 Aug 2025 14:51:24 +0800 (CST)
From: yangshiguang1011@163.com
To: vbabka@suse.cz
Cc: akpm@linux-foundation.org,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yangshiguang <yangshiguang1011@163.com>
Subject: [PATCH] mm:slub:avoid wake up kswapd in set_track_prepare
Date: Fri,  1 Aug 2025 14:51:21 +0800
Message-ID: <20250801065121.876793-1-yangshiguang1011@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnM9DpY4xoi5QmJQ--.50286S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7CrWkAry7GFyfAryUAr4DCFg_yoW8tF4rpa
	y7WryftFW8J34YvFWjkr1vkr1Du3ySg3y8GF4fJFyF9F17XrW0gFWDtFyvgayrAF1kua1D
	KryvvFZxWw45JaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U-6pLUUUUU=
X-Originating-IP: [2408:8607:1b00:8:9e7b:efff:fe4e:6d16]
X-CM-SenderInfo: 51dqw25klj3ttqjriiqr6rljoofrz/1tbiEAuc5WiMYJUB1wABsk
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5E58480002
X-Stat-Signature: 64ato3pdftcphtnkp14hsb3y4eyqh3ch
X-Rspam-User: 
X-HE-Tag: 1754031097-163008
X-HE-Meta: U2FsdGVkX19YfUZdzbqbDPCYWD3uSyHDJTsZIkq9WKYetiYbwELhd7ICAXK5Buw5a+UJ4AnwUlswtL8cKY7pY3AkrjGOL27XHp2pjoH7M52G+ZQhqWAfmecSpnN/7xhb3tjyu7VlMK5CJpnFiMJQIYWOVbU8AJs39jF1IjsvyKwPKOR3xKN5TcdG1DGJyIBLGaNmYq7WqHmND70XGbdB5Kutgw+mGcg4x2qZsmwXKMOcEsG4y6jQPwPRajZ+Cynvk7YTasP8kRQ+KXu3/0azD1EbtqAKf94tydF4FC/othbztD1PKaGYc4A+L5FpesBaanfvUZGaBeH74E/sUyLoLNNuWhsQGVkyvwH+TmqOe7uVGqPMwYxkITYOOVaheFLRZbChiOghXP4P/kONNe+GkUgNWliC5tG0WIDcch1Lk33k1U0/JsueI6zbDaeydYdWSC+sn+/6W+fIS86eqPPliI5kvw9B4zGg+upuaDucxfrFd0XhcZRq8RmnSTC9rxqI9HKo1uh+WiwJUyVFIv/MgQsOiVmUbI/ro1fLyXFIzR0buAY4WoJdr2knlQSHDefQyAkF3UYu8WwOMqfQii/d3JbOiiQMDxhD1DI3Z8kCgV77BjxXPIPf+P/bnRKToXm5CQdmQjXi49gERDSu+KGn3BxAc0Olv8YaftOuMs104Gtw/O+CDI4KCc4CNTo24rmJ7XylQU+mE/bDvswi6YozJyn9kDy4bKvXea70RUpiaycG7Q0aWgisUD3bTTQ1IJw1T3wYjlwOapv6utubUfy7Bs/KnBrXHxldyy0cRLgbNPlSrajD44y2xZLGccN4fFkK/1wK4PvCPLCogGXkqL7F2uJ2piVdsfq3mQXgNuejUfdHzvhs9WbVYLKavxlqHgNVlqzzW/JCi+fO9ef7/8S0qCMEaHVj9gZp7kF1bf7/8pQzU3mBRId2CS5rvk8sHbWVAGLXEtRVsr2YMcnKYVa
 9OThn3pU
 VSGFY07OxcdXXuWGZRGeGLcCgpVgdB4Y593QsJvdELOtM6JK+ykELlvO2SnjqSb/82MvkoCE9D3y705Bd1MXE1pg4xmiipaWDdZboOhfb/9mHj2RrPQN77sJkz5TBxdib28l86Xk/l7nk0T124rdV+kJJyO9xC6Z0Eb0OeOvzDTh+QqEiE6o3dt6xRCE5HtaKpediTOb96JGaaOSgb226XITpc8uDEEzcaJIzLiiXtj4yEuuzKEFXF9CyrVhiXvtzMnzGfUBd8YrKQTTjVwJVvJJSpUBRdPP+VoFfkIhPh2Qtw69liF2yt+ch4IOQ6e7VNyU2bpi/JclkMmmQDkEUAGOsuTs+AazFyYT8Ban0BPa/yZjRApGnnIyIFEU75TDvK3un14m1NnG0Sox5GU1ozymmILOCw3oYQr/JDQNWdX8P0HXnJikqrQUGgqR1Ggf0zkYC4ZHJRMKXs+Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: yangshiguang <yangshiguang1011@163.com>

set_track_prepare() can incur lock recursion.
The issue is that it is called from hrtimer_start_range_ns
holding the per_cpu(hrtimer_bases)[n].lock, but when enabled
CONFIG_DEBUG_OBJECTS_TIMERS, may wake up kswapd in set_track_prepare,
and try to hold the per_cpu(hrtimer_bases)[n].lock.

So avoid waking up kswapd.The oops looks something like:

BUG: spinlock recursion on CPU#3, swapper/3/0
 lock: 0xffffff8a4bf29c80, .magic: dead4ead, .owner: swapper/3/0, .owner_cpu: 3
Hardware name: Qualcomm Technologies, Inc. Popsicle based on SM8850 (DT)
Call trace:
spin_bug+0x0
_raw_spin_lock_irqsave+0x80
hrtimer_try_to_cancel+0x94
task_contending+0x10c
enqueue_dl_entity+0x2a4
dl_server_start+0x74
enqueue_task_fair+0x568
enqueue_task+0xac
do_activate_task+0x14c
ttwu_do_activate+0xcc
try_to_wake_up+0x6c8
default_wake_function+0x20
autoremove_wake_function+0x1c
__wake_up+0xac
wakeup_kswapd+0x19c
wake_all_kswapds+0x78
__alloc_pages_slowpath+0x1ac
__alloc_pages_noprof+0x298
stack_depot_save_flags+0x6b0
stack_depot_save+0x14
set_track_prepare+0x5c
___slab_alloc+0xccc
__kmalloc_cache_noprof+0x470
__set_page_owner+0x2bc
post_alloc_hook[jt]+0x1b8
prep_new_page+0x28
get_page_from_freelist+0x1edc
__alloc_pages_noprof+0x13c
alloc_slab_page+0x244
allocate_slab+0x7c
___slab_alloc+0x8e8
kmem_cache_alloc_noprof+0x450
debug_objects_fill_pool+0x22c
debug_object_activate+0x40
enqueue_hrtimer[jt]+0xdc
hrtimer_start_range_ns+0x5f8
...

Signed-off-by: yangshiguang <yangshiguang1011@163.com>
---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index cf7c6032d5fd..14e3bac0c6ad 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -969,7 +969,7 @@ static noinline depot_stack_handle_t set_track_prepare(void)
 	unsigned int nr_entries;
 
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 3);
-	handle = stack_depot_save(entries, nr_entries, GFP_NOWAIT);
+	handle = stack_depot_save(entries, nr_entries, __GFP_NOWARN);
 
 	return handle;
 }
-- 
2.43.0


