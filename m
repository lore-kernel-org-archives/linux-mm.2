Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1160FC88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 09:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E55E76B0092; Mon, 14 Sep 2026 05:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E07E66B0093; Mon, 14 Sep 2026 05:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1FF26B0095; Mon, 14 Sep 2026 05:33:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A91AE6B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:33:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8194BC0187
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:33:36 +0000 (UTC)
X-FDA: 85211855232.26.3F5E34B
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by imf20.hostedemail.com (Postfix) with ESMTP id 07E251C0007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:33:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of huangshaobo3@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=huangshaobo3@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789378414;
	b=rfM3lOaJOysVvrwqAGCaGz3ScOBHiaESIeFuEIlQBgOiZ6ysw02GxGUpNNd2dIhPwD5X04
	+tdd+LzAs3+93Yp4M3KnT3ZqgUU+oJIJbF15VJ5HF4K4HUJw4JQocok3N/k9nYV8Df4gFL
	/U+/7qigeJQLCSeJh1HLZzayMASvNVo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of huangshaobo3@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=huangshaobo3@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789378414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4VikIvKfeQ8vw1D6r12WeiLQWEm6u1AVM7Hx3QExrsg=;
	b=E/grgCVRwaOn40rltYd8gOaPrDMQT2TBCNod3stbjlflZhYspE5jd9yPXMeepuJS8BI8qf
	6B8/gHfepfCGAT6c0IvdG7iuITdN7Ku7t69FxKZ6QWWWW9kO7q/3Ieat8sSXK7zIrY43cX
	vpo1rRyML0GTm7q1EO8nd3GDHHDPLGM=
X-CSE-ConnectionGUID: Qc3q4jFGQ7y2DW8PmcmMNg==
X-CSE-MsgGUID: rwwjmufCQzm4aMbGEXdxvw==
X-IronPort-AV: E=Sophos;i="6.27,102,1786982400"; 
   d="scan'208";a="162550230"
From: Shaobo Huang <huangshaobo3@xiaomi.com>
To: <mingo@redhat.com>, <peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <kees@kernel.org>
CC: <dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <kprateek.nayak@amd.com>,
	<ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<ryabinin.a.a@gmail.com>, <glider@google.com>, <andreyknvl@gmail.com>,
	<dvyukov@google.com>, <vincenzo.frascino@arm.com>,
	<kasan-dev@googlegroups.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, Shaobo Huang
	<huangshaobo3@xiaomi.com>
Subject: [PATCH v2] fork: reset pointer tag of vmapped thread stack before vfree
Date: Mon, 14 Sep 2026 17:33:00 +0800
Message-ID: <20260914093300.100495-1-huangshaobo3@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806123020.90869-1-huangshaobo3@xiaomi.com>
References: <20260806123020.90869-1-huangshaobo3@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.237.8.167]
X-ClientProxiedBy: BJ-MBX17.mioffice.cn (10.237.8.137) To BJ-MBX01.mioffice.cn
 (10.237.8.121)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 07E251C0007
X-Stat-Signature: wytg9jsrgwogj5kg7534fxojafataz86
X-Rspam-User: 
X-HE-Tag: 1789378413-25342
X-HE-Meta: U2FsdGVkX19XogX4+4lTNeUR2qdCot0mVME9yTNi4dmfmNCLccOl67wqlnjelBWX3Lna/U+RNfQdqtBOYHvLORlOjRMC933oULGiD6CAJw0IRS/87V/ykN2bHA7p+AB4KB4g1thxgrKxoMCAwM8uv9NYSzxrGIgV4MBu6B4GNH79Q8TLDuyfqfM5LFRhhNu8iqMgDkrEHLuwITgJkY3O3qZInHzyKC+1jpqoSqLIOtYsWMmez3PexC2czYk4Qg2rsCkDmCnD8hjpIf6RGT8qUJLRXFkP763CPYU3zYQWZSadfwkub+wJPqlpNunBQ2qfpuImyZbSDyRefhQ0wucr4ExdJYcBcioxQlykSorAj+9qArSM2QdiUUH+9gjgiy8TO4mRDuMafUl/13+a/k6UMjfQmQgNOAdNj9I77S0ZdG+c3tY0gnVJ58GXnZnWWFc/0Hq4eOhJ0aJ3xQ6LKyfsixxR5HyBuaImgPDcQf4a7GVdqt6x/1p0LXrjxP09W6Q24YPFPIVwXD8MXSZpTQkDeZmAWAO+sBADCwJhr+z36hLiBJ0lpUHGBgjb98UfCAfoqlYQ0TOrPmjyxwPej0KGaztT78G/QUnw/Fer7zZ94fxtH+8JeAvOOYHJSlHnaR7vmh8GY41vSdCzL0YrICbDvIUS0m+R+x6ZIJiE7DcxolESkE/xBl3vfD+wQFA+m6H6OT3gJsqkqQfyMVMOZykxuHFY+x8HgwUJXo/P05bPuCHKj+NMxKJir6BVUKPj4Oa0ye8IAz9tQ5xc9NVz5vIoAqHSJEaoTX0GyxBxkjnY0Q5YqDzH3yofLLJLI0UiaIZz7HsGwpe9uqA+aFXTIknpN5StU6YAvPX9u8JUYZSEb5bP5UXfpbgg9DdKLRB3G3+/iiLdJUeeXxNSOxl9pR8F5Iu/JMicbJt6NWwEeftkelx/ydbP84idDqSVxJ1+DV2MGx0e5qjEifSFDncqGiC
 aO1Om2GJ
 jj9usBUT1VNpoLllzD3gXghQ282hVr+9/p6HhUz6GqO2sjm8x20FonBPN0ufDCOxOC3DXM/rbTU+HCMiaUfiefoFUFVbesSyzB+csATem9v9XmgjdOWfGUcDga603IZv8brBYmfKeTrcjrjrzDMG+p0NH1ipZIDqgzb02VZLMZeXwKZlGg4XgdQ99uSCZgGhvChxyEDy0L6VdiELA5JiOdJE7qCSVGStxjWte
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

thread_stack_free_rcu() frees the vmalloc'd thread stack via
vfree(vm_area->addr).  In RCU callback context, vfree() routes to
vfree_atomic(), which calls llist_add((struct llist_node *)addr, ...)
and writes 8 bytes to the base of the region being freed.

With KASAN_SW_TAGS, vm_area->addr carries a random tag.  If
kasan_unpoison_task_stack_below() has rewritten the shadow covering
[base, sp] to KASAN_TAG_KERNEL (0xff) -- which it does on every CPU
resume for the current task's stack -- the llist_add store checks
shadow[base] (0xff) against the pointer tag (random) and reports an
invalid-access, although writing to the base of a stack queued for
deferred free is legitimate.

Reset the pointer tag to KASAN_TAG_KERNEL before vfree() so that
kasan_check_range() short-circuits the check, the same way the task
accesses its own stack at runtime via sp.  The vmalloc lookup is safe:
__find_vmap_area() resets the tag before comparing against va_start.

Fixes: 9f7d416c3612 ("kprobes: Unpoison stack in jprobe_return() for KASAN")
Cc: stable@vger.kernel.org
Assisted-by: zhipuai:glm-5.2
Signed-off-by: Shaobo Huang <huangshaobo3@xiaomi.com>
---
Changes since v1:
- Drop the 12-line comment; keep just the one-line fix.
- Fix the Fixes: tag to point to the commit that introduced
  kasan_unpoison_task_stack_below (9f7d416c3612), which added
  both the function definition and the _cpu_resume call site, not
  the 2016 vfree_atomic commit.
- Add Assisted-by tag per Documentation/process/coding-assistants.rst.
- Use real name (Shaobo Huang) instead of "sparkhuang".
- Trim the commit message; remove the full KASAN dump.
v1:
  https://lore.kernel.org/all/20260806123020.90869-1-huangshaobo3@xiaomi.com/
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 45300f59cf2c..9a66b10749de 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -238,7 +238,7 @@ static void thread_stack_free_rcu(struct rcu_head *rh)
 	if (try_release_thread_stack_to_cache(vm_stack->stack_vm_area))
 		return;
 
-	vfree(vm_area->addr);
+	vfree(kasan_reset_tag(vm_area->addr));
 }
 
 static void thread_stack_delayed_free(struct task_struct *tsk)
-- 
2.34.1


