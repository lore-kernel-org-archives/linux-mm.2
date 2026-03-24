Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A033AF54AB3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 187E16B0089; Tue, 24 Mar 2026 09:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F536B008A; Tue, 24 Mar 2026 09:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C0D6B008C; Tue, 24 Mar 2026 09:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECCC36B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:27:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AAE18BF755
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:27:00 +0000 (UTC)
X-FDA: 84581032200.18.3F73A05
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id DC45580005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:26:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Lay9mLSy;
	spf=pass (imf30.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774358819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pl7V8WZ4+4EkuBa8SHgtqFusaJ7NmYNu+zD484Ca5KI=;
	b=1Qqv/U8YaQfrA6xb+6boIus6DShAW5NVwl+5Kox90g06+qHmvTLS52Q4xA59GbjWz9yb2U
	TJ3lF45G2uUu4HXZyduRZkSyOZ6Yp99wJYjR86tmHa9v0ZGxklmDV2F4lTjQENnkCZj752
	iHy/5mHA0ucsPlBO00bvFO2zFE/JuSc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Lay9mLSy;
	spf=pass (imf30.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774358819; a=rsa-sha256;
	cv=none;
	b=25CicN8+sxhDBYlHPivftHVII23rVPvfzTJPvtu9bm/XNrTl/OsrP7r8ZPooJSuf2zZQog
	j1oJEbf9zeu0wW7WdfZX6g/cm6WdqL7rVONsclAmGDw5/VdT78LLPe1/dcBOpUzIRRWtip
	PbYn2TjHH53W2BNcNuiGxF5zL2pnO9E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 10331153B;
	Tue, 24 Mar 2026 06:26:52 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BD88D3FAF5;
	Tue, 24 Mar 2026 06:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774358818; bh=VhBd0SXQdStB06Ok11/K+KdOFOf0X6cWYTl++e9UdAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lay9mLSy/mKrnA78g3qAMj48V6DZbVTZSKlQxfMcJT4P58/f6HDrxW5nnkZWA7i8v
	 N4bdPcm3lyqUJky+4QOxQgv/m7/DvVhfe7M0UEBh86twBM/C8F7Ld4W4yjKhXniipe
	 nOYfehEH0YKbdvhLs6jdw2/ti3BtLFWLvp1/FCCE=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Peter Collingbourne <pcc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v2 2/3] kasan: skip HW tagging for all kernel thread stacks
Date: Tue, 24 Mar 2026 13:26:28 +0000
Message-ID: <20260324132631.482520-3-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260324132631.482520-1-usama.anjum@arm.com>
References: <20260324132631.482520-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC45580005
X-Stat-Signature: pzmm5uieemu6ez6oa578unj1ec3utn8c
X-Rspam-User: 
X-HE-Tag: 1774358818-876484
X-HE-Meta: U2FsdGVkX18bzvksBj3JQJEiwBDwNyBvd16a/LvKZ6yYIwDaAvfMdWNAL+sEVDUGd2jEmPoHhbR3/NVSTYgc0/Hce8sPIoNFFeFp5w8we57P5UCoh+2IhyqyRSUUnNUBYwardNnOSgq/B/JXCd+f4zIuv568u5v4uWA8Iqj+fFmq1M6fDFyDWMOuiB9p0PS6lhGT8gUIldZLTHYaoow59qRqDiSlPPqGvC0u0tkhCUSK1blMQNEqj+gkMTIMK+fo/+9cVwu6jy4vXCpbfXbCV0EaMHjjkLahT+eqQ6NYYukDoy07kdaNwg7LX2UQCayoathh/AQo5D4k7Y/8g6TJ39fE0kZcT7Mk6raYTgl4FCDZgBJAp+7niioGPSG6BtYMrGR+UuekaB/YuwtMQ5YDmaNcR8BqSDfWBP3XzpioGkn4hvjPsNcGWu/7eTnhdRDIQLxTO9tfJFRZi21hNciNh/WVlZP1eGZuUHke1x9SQO9OO5l8GlTX85DpqNrm9sDw6SXUwYiUe3jKrt0QRjTLP/Pizt0ywlnCdbykqBg4Zt0d4+XU9PPGAYcNL72zNIxZd1KAflZeJRG5ttDdpPEfingEuOV4x03pJ2vJMsJCr06/aXbdR3JFy2ROhiST0gPL+kf4riE8cfFexk2RE9lIVxceF3MMQ8iPewEOG5mHoi7xSOYjXZ4gQ4k5ht59tLjjCegbHG6U4Ah/7OJHz6CkEc1E1ci+BHd+GyFBzTV6y7FDp5getYWHw0F5flKHeYUPz0sno0v1bS7NA01cC89Opxi9ntoIzVsgI0qYN3HaDA8M1/w+fyfxtW5W2S1cVYVanaXeHfHnE/Owyx/R8aT/MqhV+6Ho+tW8wrDTg9iSqUTKBlMk2h4KQadenTToPu+lOUzA3VejHlmRvKtEI4DNx7V+nQINLn/lCDSVOKIgTjf/z0RHanephTRUQZxNKXtGIPv+0k6QhjRCq8fuNPp
 d73lllRZ
 Oe0JA3LUQfwI4zAey1ks8WceFbns/DaJDcA5/NYZhwLQzMfs2v2U9kcBQ/Z80tF+dtAp/pwmmU3QjktopqNdyTlVf1EtMvSc0tg+VI+ZCv4bM16jorom5lfSXhC9GE3mglEgOxzM/y0j6cWckiBcyq0i2k17ZjRP1lkiefPKkOeAwFWTMB8g8gy/qg0BjA87BaYjZiphs8y6lGKm5r70InCERfiqlw8MTibuvpwh5TvTipFaJllr9T5jPqU39hNBkZ7t0ok22bY4tePpj2laxQoHt4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HW-tag KASAN never checks kernel stacks because stack pointers carry the
match-all tag, so setting/poisoning tags is pure overhead.

- Add __GFP_SKIP_KASAN to THREADINFO_GFP so every stack allocator that
  uses it skips tagging (fork path plus arch users)
- Add __GFP_SKIP_KASAN to GFP_VMAP_STACK for the fork-specific vmap
  stacks.
- When reusing cached vmap stacks, skip kasan_unpoison_range() if HW tags
  are enabled.

Software KASAN is unchanged; this only affects tag-based KASAN.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Specify _GFP_SKIP_KASAN in THREADINFO_GFP and GFP_VMAP_STACK to use
  it everywhere and cover the missed locations
- Update description
---
 include/linux/thread_info.h | 2 +-
 kernel/fork.c               | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 051e429026904..307b8390fc670 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -92,7 +92,7 @@ static inline long set_restart_fn(struct restart_block *restart,
 #define THREAD_ALIGN	THREAD_SIZE
 #endif
 
-#define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_ZERO)
+#define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_SKIP_KASAN)
 
 /*
  * flag set/clear/test wrappers
diff --git a/kernel/fork.c b/kernel/fork.c
index bb0c2613a5604..4bc7a03662109 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -207,7 +207,7 @@ static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
  * accounting is performed by the code assigning/releasing stacks to tasks.
  * We need a zeroed memory without __GFP_ACCOUNT.
  */
-#define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO)
+#define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
 
 struct vm_stack {
 	struct rcu_head rcu;
@@ -345,7 +345,8 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		}
 
 		/* Reset stack metadata. */
-		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
+		if (!kasan_hw_tags_enabled())
+			kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
 
 		stack = kasan_reset_tag(vm_area->addr);
 
-- 
2.47.3


