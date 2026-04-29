Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47F8AFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 10:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16436B0095; Wed, 29 Apr 2026 06:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE196B0096; Wed, 29 Apr 2026 06:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B5846B0098; Wed, 29 Apr 2026 06:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 891EB6B0095
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:28:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DCEF1B6BF5
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:28:14 +0000 (UTC)
X-FDA: 84711218508.23.2996EE7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8A1544000A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:28:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ESGGwOF8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777458492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mEwHRUv1RtjEabejin4TyDWYfKEzhwAG2maP6uou63E=;
	b=rV7k/hVNNgo1lC/gGUFazTCU7a9+DsWUy0iaKjNZ9A//DsQSGl6AmJ1gUpev4Cp6WsDDhQ
	ugcbok2B2+/XkH1HGbeKpTsDi6km+WKnkK3JOg77Bsdbs/lIBW0I2Kf4Kf9d7rVg/B/Tnr
	EX9u0UGEoBN5Majt0PjEoyooqblSmtw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777458492; a=rsa-sha256;
	cv=none;
	b=CONovReOuBgB64nHzX0wh+Ar9Zk7hQ1DBYhRCwqKRoAlBa3ncjy7yC/IyfswQKJGpP30DS
	5NX3hsLFhlKmk0baK4fE/ucM9yu+yHjMq4hsSulWnRhq70ya0HQi+uyaGnRON62Vc34SbO
	WVX0WHZIWpVvqoARA63Fbe4j9/aa3gA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ESGGwOF8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F315C2A68;
	Wed, 29 Apr 2026 03:28:05 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 27B373F763;
	Wed, 29 Apr 2026 03:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777458491; bh=orXsq89dfQMCSKEE6gPmHluNEOO7CXeI2G3nz7AJ8FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESGGwOF8xqj5DfideHRgMZPn34oyBQ6v/NvyCJ/O6ZI8vg7vKVveDC/MpnPb6fhwj
	 aw3fI5JsSJb1H0svna9O1P6MJOvk+cOzwAzkiPO5rCLHD8VxJuCWDKgok+U8ys1LOi
	 YzxVjTJulqfYNz6cPeW/GcShU6dm60uDJwDqghz4=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	arnd@arndb.de
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	tglx@kernel.org,
	mathieu.desnoyers@efficios.com,
	linux-arch@vger.kernel.org,
	ryan.roberts@arm.com,
	catalin.marinas@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v4 2/3] kasan: skip HW tagging for all kernel thread stacks
Date: Wed, 29 Apr 2026 15:57:03 +0530
Message-Id: <20260429102704.680174-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260429102704.680174-1-dev.jain@arm.com>
References: <20260429102704.680174-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8A1544000A
X-Stat-Signature: 1hb7mxd9adjsed4tt1xa5699exgysxb7
X-Rspam-User: 
X-HE-Tag: 1777458492-818515
X-HE-Meta: U2FsdGVkX1+FjkyBW9lrytg3fstQMfp6OCzUpmYVmLDy6k0epaWcedd0P5n37LentZ3rSwI27m5fwRd6yepSk1WuxVW5MZZ0huhFGlnCsolmEg031PD6uzoRuATh8pJGrNYYQNgEgftYjAAvgCOpk73yHWaGiKiBHVa53NTSjpYefek2D9HGfFVUXTo6MZIQxKC74j8eKO4l+c2A/v6WI9J7I5UbriW2Nz/ot/WiWRZlT+Ik7V6cC14RemCbxHDOtDslg8ppA4syIOqIJN6ieH52ZBk3w0mtEEjpcnYhgHAcTSEkBvcGutkAIEyem3WQPExjad9mPzICYme7+sA2HgSL4RjVW32ugNg2FaRHy8JAZoWavwZ5bhiOFFTKendMWo+lOtO0B1OXTmHskUezeuTXmL6QrMHwK4mS8LyAYcS8ButF+pZ+GGAKNkyW28DvxLEvM7LWoRMtBA3uRczcDYi6ivftf8ap+d4Xu6duUdKqjPl+B6bnOFHBnREe2e+KEbOs7dQgnkzRAedptJTj66q7VPFi4jP6/fR2LKG57zboJP0ZRBejsLbmHBHRDNlLWTJyMo+jVBLtC3B0TNSYjm8qIyurAiSza2HLAt+zZOarV4GVJ4t4o++hcuC+5dul+QdXbINZtgNJZfP4ksiADtHrzuHehysq36jP063V1jO7anX2WdtaYWGU51Csyg6OmRm3CqKSZMrZ4dJ+kWtF79NWKzpLED95InrQw6UdKrZM9pkJRsqxoqFaOn8wTIptAoz0O5b6J/rf0LBXV5n6avzWDgrGlMT2wfDaL7eQKcpzyHSLYuF32uf2FhG196p4kezVQ8zmZh6FAmvVKHxXHvb0RAH3CuQghdo/y3AT5sIcVRbhDCIt6BGHMK8Qmz2VvFWSRXgKzjLTuHSUYrNVa73R1waOr6xZEev8HpPufFGWvHkhKT8nESwskVuw9r7ZD+8yVzBEgnh0QoS5T5o
 gVPErO1H
 sko1guCOGIZ0t/IH13tyUZ4C77f2G+jkO6BxjyLTG9IrmbzkLfqsYv0TxXQ98GWEz2VSjlHl5J7BBnBhAox8HUn1GL+imPbluFZwheFta2H7YTY389Dhi98KOz4ZLeinGdZxKNuiFMaRibojVkocknxVADJSoPuoxYLqqym0JWEfcfCbagimZwFNk7DRN6kANV+sVKuw0RYrL6BjPoNA7iabVb4N5hR1n0kiEbscbbT1/8tARB4JKD95DdOfeplIKt7Q7s/7PtVuPIvp9zxA754u90g==
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
Signed-off-by: Dev Jain <dev.jain@arm.com>
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
index f1ad69c6dc2d4..0d97fd71d7f60 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -204,7 +204,7 @@ static DEFINE_PER_CPU(struct vm_struct *, cached_stacks[NR_CACHED_STACKS]);
  * accounting is performed by the code assigning/releasing stacks to tasks.
  * We need a zeroed memory without __GFP_ACCOUNT.
  */
-#define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO)
+#define GFP_VMAP_STACK (GFP_KERNEL | __GFP_ZERO | __GFP_SKIP_KASAN)
 
 struct vm_stack {
 	struct rcu_head rcu;
@@ -342,7 +342,8 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		}
 
 		/* Reset stack metadata. */
-		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
+		if (!kasan_hw_tags_enabled())
+			kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
 
 		stack = kasan_reset_tag(vm_area->addr);
 
-- 
2.34.1


