Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F4DC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2826B009D; Tue,  1 Sep 2026 14:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93146B009E; Tue,  1 Sep 2026 14:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5A966B009F; Tue,  1 Sep 2026 14:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97EF66B009D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:29:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 921B9A049A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:29:14 +0000 (UTC)
X-FDA: 85166030628.27.1B66E2D
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id E076E40007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:29:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=FNSSxZHa;
	spf=pass (imf11.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788287352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVIkjcqq74IZZNU1n5Q5hTuCbDzAa7ExJXxmdI4hdXI=;
	b=t/YGLFD75thvlc0spjCsi/H4ZrkWkZOdydN9hY29T2nLKGjDFTwJ77OD9KLZGI8vsvPTdd
	TwnPfYAz6wsyHUgY3UyNVs7andNn9AwJT1Rmrz6RltRWIVhiexoKxcs/++X8wvER7wID9R
	MZ64FLKyfx7HfaojGFUlTQaue2xvFfI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=FNSSxZHa;
	spf=pass (imf11.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788287352;
	b=aY2JlKFreVOeLsK/Uk8MIztfoh7COHQ0O3tn5lgKYq1VJvQl1TDa6MvKpyOjSBggGX/29l
	4QWj0agGM+0cseZ9K2UZzhdTfBBvzrhi74zo3XfmL2/w0JNl/zm4+c25EOyZbjo8GqEynb
	+mjzd6O1Kr+jZEbJ5e0BYdwWEJBBzT0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1788287350;
	bh=MVIkjcqq74IZZNU1n5Q5hTuCbDzAa7ExJXxmdI4hdXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNSSxZHa5FtuOKibtrS9mmnbzAdIGiGFwDVNJJu4Gy1huXHzsDX+deS22Nh88XhmW
	 zIx7o38HaJgbKJWIeUrU8U1JFgBsq8rh92gT/IkrUWKQPrrkTjfjIksnxwAiky0atk
	 GMoQTkYHJh6yqZCZNytGeyGOmoSAxRrBq/3jYe+qdW/ib8GuKj69hZkzFRU4oLFn8/
	 DJ061TyjoawwTY2GAjq6TxrjQeV+S0VVOKGiuzGwj6Tm6kupgbYleOKpljDtTIE/VZ
	 OwZw8BCTpwAVwjnCzsYwDjjqBMrSPUoGeQWP89Ykz2Sox6M8aWz2JV8csPyp9oAGmn
	 8Ic3jJsgihd/Q==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4hZDsL625lzWP7;
	Tue, 01 Sep 2026 14:29:10 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	David Carlier <devnexen@gmail.com>,
	Josh Law <objecting@objecting.org>,
	linux-mm@kvack.org
Subject: [PATCH v21 5/6] init: move percpu_counter_tree_subsystem_init() earlier in boot
Date: Tue,  1 Sep 2026 14:28:50 -0400
Message-ID: <20260901182857.26690-6-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
References: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kdm44ejsit8zkgnurjzj58sdtmnd9qtr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E076E40007
X-Rspam-User: 
X-HE-Tag: 1788287352-410489
X-HE-Meta: U2FsdGVkX1+u0RrJsSd3zu+Oy/uIn7yjZoGYhOYDoNF2foIwt0vpWizhvsnfzY0xDSBcYoUoS4bh+py/71QO2ujyGiFf5QppBSpXvwRMLQ83ADfd3nXqEhDzgRGctKkNXAmHgxbB4JCPL2KpCK7ZerbsNOiQ3KPS7zas3ioKLU3rewISwng2klpHzdCEOG3PL6SK9YgweiFPnHIPlpQYTd5CLIuTXE9BVeuJAeywduYZdkXhG4Sk6vk3Z5mkbRYiH9NaQvdG9B0L5aNEvhTZZe++U+xBm2RlSZb5G4itaxYjns1h9kGpR/YLgGkRlVnlAGIcotiYn3UdWbnFvliZUyHGcwR2m+z4ZF0HfyYKzheOoZ34/SGGpDCfWHMTSPdARQ6TYa7e1V63W/n9PEWceDJezj0B9SsfySbF+FIwDiwKpERJFmbRQ59eoml83ZEqOK/TLTY2x7w4EByKVouiQkKOUG/8Ka65PedE6qh8yi6ucZ5ywWOJxDK+zJQwUgHHYnMRSAdIHCX1bn6FQyPyP5MvxonyOJMrhDxwW73GDIYj64RUFvgWMS/SDR0Pn8aZgYlisNX980c+/35ATBWYSTNSKonMbtk2qHsYv1+8lWDt1snDQERvDLswbBYHg1ltBHDN76pd14OqNZSDEKx4u4ax7CiNqkUnhiEMI/xjNOTjLSnSqek6rXu/K0QJMtt2mrKPsgD2B6lzRKwPRABGDWL3pJQdeNbbqC4jLBHgovrSX1FLZr3dAxYlW29qYRpvu2nknckem88guCqMVq3StLX8qJagy3NB+QS6m3Rz5nqZMnI0QaVYesP6Bs0F3ZhhDFWAZJYkWLteAgMvEdSBGO16YvOjCiEbtVbmdrElf43Ona2VJhYwajlK2nnLPNJwwW4aU4VksDyW/ckQsAd9Yq5unIxVwfcuqTaIGPzcMkHb26OzaRSCC+vTz0EqSIbazOFG/y68vSRg0VsabbI
 4GD5brnk
 HfZCYWf4YFQYC4eGFF/qS7t3UTO8f56wl4DAg6OLj5kEw+01AlAZGZDjZaKzMu81+yB6Si5PSdP98GsbbjDNAePj49AH3WWxtKJiFV53MQtXCSvKjhhCagIAAbsrO1fHwteyEvY5NGRKNam2xBwPf5k1fv7dCaT6747HSSqbwu+Yf2gkVRLy8EkP1SZkcLd114Mrzd3VlJTWxb7wSr7euUbftN8OVzNouV9S2SwqGJdcrr2wbtp6W9jMrTBH8edFyrW/zgjLk/Nev1x0pnd6rIbmjvAcXi/LUgRaJ/vW2Wq1Ysos+tlU2lB/5r+4EhzjGioHpVrKal4hqu00+2b8pTRKTM0kFWI0kXPjtSRRBaasMk7r1T3l+tE8eSaPHOPF0OuLs+g1lCBR4EpKE8ihJe77ZtiEb+5QlROIdAN7vqV+djOoPs9Qr/YZ/9qdW8OOQgTtjAxHvnmSq6IEBZvCmGVBFPF7Ac4DtxbsK6tfjXOsLnspHPpbSTuIq11/xtlcG0GnlIphp7ZwkTUN3bxMWi8MVyC4Scus1MX5xePWA4tTUQjx94/mpof/Xso7ley6gn5tV02W/pdT2HjzDEqFz14xmsBXnka4WJQJ2WTXa/CYMWX9W4MTQdVrq1NwXQXNLbz8Rr3H0qki7lipATSLThXRBW9pcS7NpCe26AYuDmYsFJmn5YcRvliXNjX26ucsuEQQF4SS7t7uhtYpYYrU9XxcUAtdw1AYLljg45X3BMkL7vdASTM75L7aGd9tdI7jMdkPwnKzKMDcb/MLIRTFWhdXnAxLzUBqHslJjT+31hGPuaWx8/esu7jExH4RtqQzqfKbSRrWgj05hTajcSk5/Dkx9PYe8MF4ydbSc4RnsU6RARrAeXtVx+FmDHC6GppTVb5CVeJh4XUcB9guq+nswGiN8jkAL6XiD9lHBqLD+I7jL5VnHzWZpv3iL7KfMnDAG5gjKyppbjfd4rq3SB2TEKc8qVchy
 b+PcpaRt
 Rp3QfWLuFqae96y373U7diwafLGL/m02DW74OuuAaD1HtO/t/oyauv5qwTXyQGBqxKdBMkqPH+af1eiT6Bjpdf723PEP88xP2TQ1saYvuLEShMDHcRYUB3TAqQJJ8OwGOlwGB/l26Ss0o59YssLVoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move percpu_counter_tree_subsystem_init() from after trap_init() to
immediately after setup_nr_cpu_ids() in start_kernel().

The function's only dependency is nr_cpu_ids: it calls
get_count_order(nr_cpu_ids), indexes into a const configuration table,
and performs arithmetic to derive accuracy parameters. It requires no
memory allocator, percpu areas, or other infrastructure.

Initialize the subsystem as soon as its dependency is available rather
than deferring until later in the boot sequence. This ensures
percpu_counter_tree_items_size() returns the correct value well before
its first use in mm_cache_init().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: Josh Law <objecting@objecting.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
---
 init/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index eda2170bb21f..845cb57e9096 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1011,6 +1011,7 @@ void start_kernel(void)
 	setup_boot_config();
 	setup_command_line(command_line);
 	setup_nr_cpu_ids();
+	percpu_counter_tree_subsystem_init();
 	setup_per_cpu_areas();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 	early_numa_node_init();
@@ -1042,7 +1043,6 @@ void start_kernel(void)
 	vfs_caches_init_early();
 	sort_main_extable();
 	trap_init();
-	percpu_counter_tree_subsystem_init();
 	mm_core_init();
 	maple_tree_init();
 	poking_init();
-- 
2.43.0


