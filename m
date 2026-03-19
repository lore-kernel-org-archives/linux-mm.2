Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DF4D108E1F7
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 836AA6B0490; Thu, 19 Mar 2026 07:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80E986B0492; Thu, 19 Mar 2026 07:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7248D6B0493; Thu, 19 Mar 2026 07:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61ED46B0490
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:50:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9C4C1B8170
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:50:15 +0000 (UTC)
X-FDA: 84562644390.30.69AABB1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5258716000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:50:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773921014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VriQ7r5ujDfNl4GZJbGgoiqhx040jESdP7HiC/62+Pg=;
	b=H9X2xvZ4VlI2HYStglS/IwUiPhykZ9/IvzH5jw8yhYYZjURkyqMWHilgrscHozAP5gesvv
	lQ56I74j5wdUY2wN0DvwCTdu8kGkpequiKfDy6QYFXztSFF8y3xnM2GmUDsrnLkBHXNlJS
	0gXrKXrpdWKmjTb9IsUHb2/O/S4MoAo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773921014; a=rsa-sha256;
	cv=none;
	b=deyrTteTZhyspcZHYivDF44ZxtKAM8y35ur2q/xE8BpPS38o9A0CRnIrUFyR+d2UywhRbr
	ge1febq2lNuxeEN8xyp2mdq0iNKztJsI5/kSDuc+6/1w2kEm3GDsPwMiTulq53o/cSdGm9
	MXbFx/gnKbVxGaNHyR7VBwQ/KiVxRsU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74FB82050;
	Thu, 19 Mar 2026 04:50:07 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 438E03F778;
	Thu, 19 Mar 2026 04:50:09 -0700 (PDT)
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
Subject: [PATCH 2/3] fork: skip MTE tagging for kernel stacks
Date: Thu, 19 Mar 2026 11:49:45 +0000
Message-ID: <20260319114952.3241359-3-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319114952.3241359-1-usama.anjum@arm.com>
References: <20260319114952.3241359-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5258716000E
X-Stat-Signature: efh3i4qa9ea47i88ngrgc7upkq34jggy
X-Rspam-User: 
X-HE-Tag: 1773921014-824959
X-HE-Meta: U2FsdGVkX19sUL7O3d8eRckTmttn6SVvEgOsn/kclJwQZ2Xyw7Ahot9QvJ3IXUkW9T3KTekeCiZAuMqWo6clMs5X+Wub+FZi4kQdznDbSBQ5jtMjhZQff6ZWnlGlSsog8noVb0LcbAIjbgmhwC6FNEovdK4u/9oxxYW6wM3kyc1JUKUpSUrGJnLsnoZskvSPY/aOIXQOOFCcQKJkGDCgjZS6acHfdoN0KA3JK3q6HRXW0s8rOPWW3w4MKVFjMRbiTf7REnPpDWeCsD5Kr9UKGguSaXXpr0nvVDAZd/1gAO1FB0IHtuBeO2D0NYinZ9h4QiFp/EmpXj7Vx/uG+I3w1ARtHcUhUBHBveF0eWa2lY1n8GOw9QbFu8rlvr3du4DDl0aduU7qJ/5IL+WnCLR6AE1qs1uLyWCcwoizL4xuoPhgWzxZtfC+4zr6VZjxIaTTl1K6SW16Gsee7kIRY3kflmFYIq0douok/BAd3yRK/GvJRmqKDhJdQQlCijZRQxoYYxlML1FQYOG4tdL49qQRWSROQBETExCqgGIzKrNVsEoQ1XpKdMNe7rKfbzNHO1e55PrAWD1nPjZtTtAXJZaJtx2UJS6j5f/4xauxLpOHcHcQLWf6PD219NQaz3tTtucTFrDmYFiEeffOZUqFnLXqsEPU1/xhfVv+G3bNzY2aCwwXJQo+8X8EgxZpW0hw51naxQghjbM0ZrPSkgU8Fpa0J/qVifeyIV+RV6pYpM9DpqHHKhlcJdMai0hMZUHJN/klx2piOrkQCfRdIQlBSgToeavdZBy/ogj/1AuAfISFvvMI2i8MJtqyeyI5Mcyj+Nj9DEOvqTJ8Pjk6FdURjEtSUK6/+aLKFe1843ivUPQArKqmWpaTHqvrf2y5usFNtgmSSoSbQDJ5Eqaa36fDG6UXxTjvgYFsHRP6Yqea2aftzBn7tPluesyi2wACXO2RPhx64vLux6Yvoyv/cnpXHn4
 fkb5zAl8
 7g4oMobBtCMd4hNn3SmOfHmlx2pOoHJxfHpR6B2WxeBbCL9tSBPTRMZRbx/pKl3FldmwMmHGgIMeAQULmLyCy9DdL/29Q9BBHurvzOHQ8n4tISfAI89VC87SGBzO3A+0wVEGtoCqJ/AIj6bBe/hgtp6xsygNNZkgerZmLiwY77ZEl+uOF0uLyJ4ZtowH/KCGRDPpz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The stack pointer always uses the match-all tag, so MTE never checks
tags on stack accesses. Tagging stack memory on every thread creation
is pure overhead.

- Pass __GFP_SKIP_KASAN in gfp_mask for vmalloc-backed stacks so the
  vmalloc path skips HW tag setup (see previous patch).
- For the cached VMAP reuse path, skip kasan_unpoison_range() when HW
  tags are enabled since the memory will only be accessed through the
  match-all tagged SP.
- For the normal page allocator path, pass __GFP_SKIP_KASAN directly
  to the page allocator.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 kernel/fork.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index bb0c2613a5604..2baf4db39b5a4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -345,7 +345,8 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		}
 
 		/* Reset stack metadata. */
-		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
+		if (!kasan_hw_tags_enabled())
+			kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
 
 		stack = kasan_reset_tag(vm_area->addr);
 
@@ -358,7 +359,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 	}
 
 	stack = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN,
-				     GFP_VMAP_STACK,
+				     GFP_VMAP_STACK | __GFP_SKIP_KASAN,
 				     node, __builtin_return_address(0));
 	if (!stack)
 		return -ENOMEM;
@@ -410,7 +411,8 @@ static void thread_stack_delayed_free(struct task_struct *tsk)
 
 static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 {
-	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
+	struct page *page = alloc_pages_node(node,
+					     THREADINFO_GFP | __GFP_SKIP_KASAN,
 					     THREAD_SIZE_ORDER);
 
 	if (likely(page)) {
-- 
2.47.3


