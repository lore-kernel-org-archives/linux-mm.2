Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F156FED3C5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079E46B0092; Fri, 24 Apr 2026 09:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051586B0096; Fri, 24 Apr 2026 09:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1446B0098; Fri, 24 Apr 2026 09:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE7B56B0092
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:02:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 521C016015D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:02:34 +0000 (UTC)
X-FDA: 84693463428.07.26CDB35
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2A4304001A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:02:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cnyc3BZB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777035752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2gULMXl8OBHy08caKCTqeMyJqWw2dcMC95j5DoOyWQ=;
	b=goJzZVmZZD7jvSoaWWlcXhgmJ7wdMUp2pWpnFTNRjKXIj48LKhndJHBfl0IVu0usaR+hlU
	x3w++zj9kBDIgA7kXTOhaNI5YKdjYUXtTwlWwB9+E0GZ/m0RxcegqHdxkxMENhoHMbiwJ+
	ePEIDiVfb3NoInsOyhJjQyVscNthHZQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cnyc3BZB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777035752; a=rsa-sha256;
	cv=none;
	b=buwtgRR5CTR8f9/J7K2giXN3cJHArEA3pCS40yAWUfmPahatn5GY5HV95WdElrV0R3M5jH
	3B/HegACGn5ho9bGnV4+UXVDopbP4Z2ZZEvsX7cuGYjQ/RqxMjGejgSb7NkD6AZ4jJRinQ
	VlGgH7gJv1KmT7MKNIM/txatVE2D9d0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AFDAD1BB2;
	Fri, 24 Apr 2026 06:02:25 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B82C73F641;
	Fri, 24 Apr 2026 06:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777035751; bh=D5X8BJo1eAEFDfHp+6/7s8DHory+FJuzYWqDtfEml9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnyc3BZB7O71ynREGNf8/mo1oBmy01E7og062JAqbqLMBgR0ll2SwQ1Ir4hR3vbo4
	 uQbijEIjNYmKrks9VDj1noDm2aOzJMvl1ZBpaEEfHD+ZDaeHALsPThR7hZ8IQLtzy0
	 x989bATNcafg3pXnY5auXxZzSo1+thLH4tTnUHjk=
From: Dev Jain <dev.jain@arm.com>
To: arnd@arndb.de,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com
Cc: dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	tglx@kernel.org,
	usama.anjum@arm.com,
	mathieu.desnoyers@efficios.com,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 2/3] kasan: skip HW tagging for all kernel thread stacks
Date: Fri, 24 Apr 2026 18:31:56 +0530
Message-Id: <20260424130157.3163009-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260424130157.3163009-1-dev.jain@arm.com>
References: <20260424130157.3163009-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2A4304001A
X-Stat-Signature: gsuhakrqwxxd5kem7mgqn9dkkg4ruqnk
X-HE-Tag: 1777035751-122521
X-HE-Meta: U2FsdGVkX1/HOU13PoQVb4lBCkhX/95CLvCZ73h2K1bAApnyS3+aoKFdzJMtYMrE+KyEpcGYTQXbNEy9j1BVKymlnbapvMHCZPLOxbyziIO7aW/ZC3QGmj16E4ZMOsucaFuqNVatAAbeZroE39IzVlaPFaWrY8mnGiUHQXUSw0PCQbjEccOGiivV5CdZPKjjpZfYJQDZ4q66OqcIQfT1Wt+LlbScuJnjUuI1WkUG6VDaYHUK++xdxwszDLfd4uz7EEWr2K58Zv5A1VIJjofZOuV5FkJCPoPTPaRCFvOKOr2h8OQVqGWAdvIGOtqR45ui/tQr/IL29KRnIXPM7nFwIBfpLgGh/H7Sdw8BPzze94qvNTvwWMAOhVZ4oa6bYNS7+DJSFi2wm2igcDYeVxaVDHjACZyRqy/IjhZK5lH8VLl+WjO9Y7qYx73P88B/F0E+64Cgo+NjeknGRW5pfSoSc34SosaUSYhNmRcgJhrQJR+MGpzls4v/VOXXlY9tAEICphNeEywyjV+YYnGBQROBkzLAhUGEkXpnC8M09OR8ldUMsxwkWXVn/u6HFqybe6Eu3/vHqbur05nofm11n3qevBj46chSvJjjeHFyuMWYVxNjfF6MazmRopO+NkyvQXCZr4Y0CJmHcEdPmIFY2tX6v1rbheOh8egAM4Zg1Ed7XIfFY83lYGJyVw+zUOKLr6g+qdJ2OVCkoPzc59VGUOCbwa+U+c+2czhIcQaFtEWGKQImjTOHtmyn1OUE44KQvF3Egsq6EL+ZOORQ/uztD4x3nlKhWKMRPNVjPRJ5rUAv5aSc2qg2AAzmB9OIQ3XEFxFQNwjg8jS9OdWVAS5Rd5XB7/mT4iaxoBwzdWkIBuHx7hlMTCFYqFm9DLrurUhRRQfMulXJ1LFVwK7+wP/DlFKmb602ixFSoPhvYV5R277Wrb9X/WBjH4PPCA3gHGG0dnoBDnrotOzvRjW245h/WOY
 k1VYqae0
 2tGJedF2R5GUp9I9NbZWdsCv9RYsO3pMMbaEYpw5GxjZ1CvPfAENr0oMJpLjXFyatHYtHpURGi+57A1PCOLpttII1bbE4NRojDDRUZd+ZiPC/NCQOZWbaVc/hn2YApSjiO+V3EYqIxObJLxn7RYA222RfcnigH78qmG9X86h1+TOHeLh0qT1Ji0zRIS8vfglNCLwQO2RE3JktNRfybgbtvDREMOurLCVS93QGOeV/Go9pkdfefEgzN7NXH+SJE1dPzM0Ff/nXEaaEVJ5ig433CogS/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muhammad Usama Anjum <usama.anjum@arm.com>

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
index bc2bf58b93b65..2fc3b121962cb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -202,7 +202,7 @@ static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
  * accounting is performed by the code assigning/releasing stacks to tasks.
  * We need a zeroed memory without __GFP_ACCOUNT.
  */
-#define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO)
+#define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
 
 struct vm_stack {
 	struct rcu_head rcu;
@@ -340,7 +340,8 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		}
 
 		/* Reset stack metadata. */
-		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
+		if (!kasan_hw_tags_enabled())
+			kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
 
 		stack = kasan_reset_tag(vm_area->addr);
 
-- 
2.34.1


