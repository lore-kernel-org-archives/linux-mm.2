Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F32DCC44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 03:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39CE66B00C3; Wed, 21 Jan 2026 22:40:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A506B00C5; Wed, 21 Jan 2026 22:40:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D1D6B00C6; Wed, 21 Jan 2026 22:40:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12AA56B00C3
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 22:40:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82D77D034D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:40:40 +0000 (UTC)
X-FDA: 84358197840.08.B58A2C1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id A37201C0002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 03:40:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DtGl5BuV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769053238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yrAsyPq9OkRG0Lu53Ruwu5hyyipfdn8Du1lCC3wiBJA=;
	b=BaWue2GQgm9zJH6HVnheD5uC710O59s8xxX7w6gcLsYSVhfHMKK5QSkoeiCMV/yLSd4Jsp
	U+CfR3vHr4aHU7KYRuXUF80gCOIYJNqpfivlCMg4eU+lwDvQedg7M8mTGc1m0G8cqunyMu
	bIrJAJ2aX2d4V7ecQta2VXACzaZrAuI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769053238; a=rsa-sha256;
	cv=none;
	b=tdYMdfKyuqmuCb7JDszDEGYflNC9iQFYorzFiDb+N7iVpBRLU/lU/N4RYK0WaF47Kwrt0i
	aScoxRWcHanUMV+W7U5AXInFYfog79XAmr4AHmdMgiu85hccvwm25lcotOkt0eusrt1Ua/
	pLyEGxvoK7QTp9cAUPUBIfE9n5Kb+qY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DtGl5BuV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769053238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yrAsyPq9OkRG0Lu53Ruwu5hyyipfdn8Du1lCC3wiBJA=;
	b=DtGl5BuVqblmayYhLrvJ3q56rtxe06WwZK+PRmq1Y7CWIJdkHBySDczb4tbT00WsiiQvqX
	tyNgfB2JQb+J61g6HySSjtccWucbYREoPbAjrtNVg/cavKGqX/a83zBEScPwnvawRgnGTX
	uKdQHO9p5Im33GZ5lz2+TKKlj8cjCsk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-hty7ApdLNLKHD-skSRWDNg-1; Wed,
 21 Jan 2026 22:40:34 -0500
X-MC-Unique: hty7ApdLNLKHD-skSRWDNg-1
X-Mimecast-MFC-AGG-ID: hty7ApdLNLKHD-skSRWDNg_1769053232
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 501BF195608A;
	Thu, 22 Jan 2026 03:40:32 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.89.197])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B3CCA1800665;
	Thu, 22 Jan 2026 03:40:29 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v2] mm/mm_init: Don't call cond_resched() in deferred_init_memmap_chunk() if rcu_preempt_depth() set
Date: Wed, 21 Jan 2026 22:40:17 -0500
Message-ID: <20260122034017.505589-1-longman@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: A37201C0002
X-Stat-Signature: wc7yzdmy9nbe55hayw879usds5x6hi3w
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769053238-979503
X-HE-Meta: U2FsdGVkX18YKUMvUvpIM4cfYBXbgZbZ4XntK0P+k2fo8nElLmo8ZgIfniFCHlXA0qWyVYkQI2YSupuV0BhIWTvGTvru470nXIxNNUy3KJBX2xqX8qN7SuwK2LLZr/qfJ1U3fuT7gxZ70OokLrEZD3c1qmHOfFXEUro4MpVo7bsct0w0WLSBRteJXKgOKHFcfiW8tssUdRFmS3ZCPE7d/suQNOXa3BUo/we5qc9DIR/EI32MuphymD0bkHihGr+Ez705gyzAz5FG9zk2Sa2qgNRDkSkMbeq0kkMUHhPy3C32L5wnxNMDPevEDYS6+Tm6OBNRgSsdYBbJf0QYMdHbI8sCSXE5zjQZ7Lc/xICW23dz01EZLDadJMHdMGmaJui/gUTnIeKvqqCHboK1TN265V5M9Q4MTZYUNo8CrX20PVOrjNHrFuACtYPq1EQ1lPYg0aDgpfpWo7HhE6W240kcn5q5Kazt3Wm8NoiEbnp/Jn+YtykD4JYYeAJMru1yj6tuPb/HJPsr1b4ADk03qHCLoWCVF3/laiH6DdLVfQiaPmdMBZXduFbjYQErlvdlTa+llXpfzznuPPYJr7Da71VIj7eP697FQkKU3lytWD2kDonDYHjWJaRCkQZxMDYxXniHmVJua6YPgklQGPuu/E+bmB3ruHN8Svvdw0ZXQvlE88HyDgS7SM1u/XtOqbToobqNFm06Mq/4Y/qevS82P5eeVzo1shGIyWFot4YGEpwZHPnq7PtYCmpnQvnIVOFGOSugMFviRL+AaGDyEA9HB5+7SOCSI9+eboDSL6x3dp4Na6tz6NymuT/gr2CkBk6ZDk6dYZiSw7PLkHThzcPy4rU41nl7zNewpAV3GFpIo3MCQfMZyRtDVnp6PLJ0Ug6MZr+Z3MC1dh8tEu93pnlHxsaYH8iog3erAQkccKJzqlQnKLpwbQbJswBUgjqp8jkc9bPxxkzlXhd+3DGsh/yhobR
 IQe1f6Ce
 +d5j0Lnyp35qFV/DwC6UIj2gXmUOBWV1SydjpORMeDt0A1/pQZHcclwQdKDGUSv8Eic8yjiu5Gi/v/+g89/4UeVhvGUjwwR8Jpzb/RPp2pVDwEBpT9/yU+1cddj6vCeAzZG6FZ/zKWzdS3O0KU60Ll1VqOElGkncw/zuX08oJlfiWg9aT8/mXa0kjwmqnC0DIlg26le4ZopO9WfEBcBmHrsOUTz3UsAlA68P9/ZD2cRb+zT3SjfsVYuVIbtF9n+kx5XwTFBQ1UiNqvULn4aVsfOOIOBU7yrkMFy1fWlA0kSLmsgUxP8vNFFBPnvaI40dgAjocB7DA0OaNm+tIEMaPPTfa6aLO6ibqc0tOp9HajPlCdul1Q4y4v62cqTMglwFLNAm3TUwMrRq1sZ44vMKrheXWbjt8i7V0yWDH5qtjEQ4PyEAh76CQS7E0Q2qD3ZzTorvRw/7Hyt3DcULMfFTErcddVGqm9ai7/mgxDGw4TKjkJMs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk()
in deferred_grow_zone()") made deferred_grow_zone() call
deferred_init_memmap_chunk() within a pgdat_resize_lock() critical
section with irqs disabled. It did check for irqs_disabled() in
deferred_init_memmap_chunk() to avoid calling cond_resched(). For a
PREEMPT_RT kernel build, however, spin_lock_irqsave() does not disable
interrupt but rcu_read_lock() is called. This leads to the following
bug report.

  BUG: sleeping function called from invalid context at mm/mm_init.c:2091
  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
  preempt_count: 0, expected: 0
  RCU nest depth: 1, expected: 0
  3 locks held by swapper/0/1:
   #0: ffff80008471b7a0 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x28/0x40
   #1: ffff003bdfffef48 (&pgdat->node_size_lock){+.+.}-{3:3}, at: deferred_grow_zone+0x140/0x278
   #2: ffff800084acf600 (rcu_read_lock){....}-{1:3}, at: rt_spin_lock+0x1b4/0x408
  CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.19.0-rc6-test #1 PREEMPT_{RT,(full)
}
  Tainted: [W]=WARN
  Call trace:
   show_stack+0x20/0x38 (C)
   dump_stack_lvl+0xdc/0xf8
   dump_stack+0x1c/0x28
   __might_resched+0x384/0x530
   deferred_init_memmap_chunk+0x560/0x688
   deferred_grow_zone+0x190/0x278
   _deferred_grow_zone+0x18/0x30
   get_page_from_freelist+0x780/0xf78
   __alloc_frozen_pages_noprof+0x1dc/0x348
   alloc_slab_page+0x30/0x110
   allocate_slab+0x98/0x2a0
   new_slab+0x4c/0x80
   ___slab_alloc+0x5a4/0x770
   __slab_alloc.constprop.0+0x88/0x1e0
   __kmalloc_node_noprof+0x2c0/0x598
   __sdt_alloc+0x3b8/0x728
   build_sched_domains+0xe0/0x1260
   sched_init_domains+0x14c/0x1c8
   sched_init_smp+0x9c/0x1d0
   kernel_init_freeable+0x218/0x358
   kernel_init+0x28/0x208
   ret_from_fork+0x10/0x20

Fix it by checking rcu_preempt_depth() too before calling
cond_resched(). Note that rcu_preempt_depth() is a helper defined
in the public rcupdate.h header file and is defined whether or not
CONFIG_PREEMPT_RCU is defined. By default, CONFIG_PREEMPT_RCU is enabled
in the PREEMPT_RT kernel.

Fixes: 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()")
Signed-off-by: Waiman Long <longman@redhat.com>

 [v2]: Add "linux/rcupdate.h" include.

---
 mm/mm_init.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index fc2a6f1e518f..ba0b476c2d45 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -32,6 +32,7 @@
 #include <linux/vmstat.h>
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
+#include <linux/rcupdate.h>
 #include "internal.h"
 #include "slab.h"
 #include "shuffle.h"
@@ -2085,7 +2086,12 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 
 			spfn = chunk_end;
 
-			if (irqs_disabled())
+			/*
+			 * pgdat_resize_lock() only disables irqs in non-RT
+			 * kernels but implies rcu_read_lock() in a PREEMPT_RT
+			 * kernel.
+			 */
+			if (irqs_disabled() || rcu_preempt_depth())
 				touch_nmi_watchdog();
 			else
 				cond_resched();
-- 
2.52.0


