Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E55DBC88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D53CE6B008C; Mon, 14 Sep 2026 09:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05D06B0092; Mon, 14 Sep 2026 09:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1FD56B0093; Mon, 14 Sep 2026 09:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9F66B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:12:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B031A012F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:12:06 +0000 (UTC)
X-FDA: 85212405852.23.0D4557D
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf30.hostedemail.com (Postfix) with ESMTP id AC21A80006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:12:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VQH5GkM1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789391524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SFehRpd2rZ3Hk+RSfjBKOtJNx6as9iMcZitFgLIojdU=;
	b=Cj8hQVAKiKRebIjhVBpGw2z7jIdKyu89U6Xs8H4CHPwPsZ+JVLGmUbOnVz+fZF5zy5cgHu
	to1ok+AcF95IFioYlSIWe3suvAtDnUpKd62LKYEQWl00gGgmjYPbgDHsD0v6Al/MRmhBrf
	PifDaxf41NoKOkA4L04jR/dN3LB794s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789391524;
	b=mWqyts+XZX48LMgeQZrh2KrkI0xiLoKwdPQy2TcvpWLUveX9l9WXbzRRucwpCK6NvOzfuU
	5izfHwWLiCOUUimLJt2kFQsk/tZQKk2dqftgkhXAehBGn1zENB2DPX18Rvc0PZu7lpV39M
	jkmoC6cBDkoLn4a24YEJUzx84KMUQ5o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VQH5GkM1;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789391519; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=SFehRpd2rZ3Hk+RSfjBKOtJNx6as9iMcZitFgLIojdU=;
	b=VQH5GkM17IOZ723PkXndH5INRc3doJDzl0dculZskyZMwYP9VH9TjqDb5O6hL56li0eAn7lhnuuTw7IpOhB2tjLWcsd7GjzDDes+Tkd+PKBJl9Dcyzo3J2y6+4f0Xy6KrFqwdd30vtG3AWw6rTJHQDL9F0M85u4sO0ao9GHTi2o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XAxUaA9_1789391505;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XAxUaA9_1789391505 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 14 Sep 2026 21:11:58 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	mgorman@techsingularity.net,
	linux-mm@kvack.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-kernel@vger.kernel.org,
	Yuanhe Shu <xiangzao@linux.alibaba.com>,
	stable@vger.kernel.org,
	Henry Willard <henry.willard@oracle.com>,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH] mm/page_alloc: do not boost watermarks in kdump capture kernels
Date: Mon, 14 Sep 2026 21:11:42 +0800
Message-ID: <20260914131142.2984623-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AC21A80006
X-Stat-Signature: 3unz8zm9wiazbs5s3zur1sokhefbogmw
X-HE-Tag: 1789391522-865563
X-HE-Meta: U2FsdGVkX1+O3RDfPNaBxq9BgGUXvj7lQPEWo6meXsPewMGKd7IIB6QV9Dd26Y2tvKn+IMKRTMJWlqlTDX+8W727YaAOc9UIn143/ciRcD347GLWOUJTMlEg4gt9uu5pvTs4oaY3jkcsrcJ3lT7Jt6wPCxfZDlSk6bXd6HI+L3C+LElrtgVShbV4a/m2FYOgOkSMXNyB82CrH/MyIK+wW8GVLEsetJtG78UB8Oregi4Obv52gl67pIxhnzLgxE1fNCLKkiyPzC10+z49jbJUmAt9WhliJ4qwprmH3YdfLkmpdR7OGOr0LcRoZ3nidCzpEP8fz+oyBoswpu/gLu/5xEJTNEHShCPDLcEau95IYUTDjR/3pQuTrxeyhdYUE0Eds+UoSXP5DUczA2vRpCxksSQpuHlniT6j9D0lEeBJkTmv7wpcnLj//rIl1SawoLLuoDWsqFnzrNKcq4aXA+yfknsb50XHzkgItkk8c08zg+17Qy+W3Z4IlESi+lOnyfB78ZkBkbDA9I8V9QxTKtu8UkbEZZ9xxFPs0bb4ZitccFNie3ic4KUGYDanmrtuRPr5ZZJVJbwLSGArROkx2onbBMQuUzogq4aSDIRocaGutTkpRSOsVbv9KHtBH5B57gUETOrhuCINH9rYAZQDmMn4HKlyQI6Tz9bDjOPIs4a1VdoMggYbU81cmVJSKyRP4QMGLEsY+/VoT9zTocu5poHKC8KSs20nh9Vb/tF5n5hjCH2w6U8c3rmeASmC8kXMflVU8XdPRx7XbxiULXfErWZSnwuMJXEMLxARvxmYYvu5x/N5KOlvdyZidh/m0kW+9ffEBTdZeHVavX5KEroltgL6QcXxjVmM6jMf4GG2MacS+kC5Rthd62OisFGt9KWzODMDMX7Xy5qOcl+CcefMQNqBSmNYsw2EZgYNRoqK5ZFrUu9B6GioPoVqXdnwH58bNvut4VgXXFLkm2hORY1EqFn
 JmI1FB9D
 eHCL0FiFT2RAu3caQ5onLL9MjCbNJMTWjYPViPa/d29qSFgIogZ27zVtYnEayqEdQmBNPwv7AZfVzcz/0eDjJ1bDXNEiqHp1UGv0tqNubwFhIJqq4Oc0Dyz23NXgI+y3CJg89ZDNvmuf8vjQ3ILDzeah/X5nSrhpyDVq432Pmq/NV0x6fnUOpvES6LkOLr79lzEqp0Bqq16XrOT/gyeJGnoquKF7poGtzsTSfI+a76TIPIu2IuZ0KWGoolsxHa/gHWQfoJbOhKXT/2rz8FZ9zd0snYiSM3kIv4D+pRhhywhDh1+rI+vMTMeOIMzIpbl95C/vB5V+tJwv+X0C96LqWjCUioQlFoDrm96GN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A watermark boost is not confined to one watermark: wmark_pages() adds
it to min, low and high alike, so every watermark check sees it,
including should_reclaim_retry() and the last ditch ALLOC_WMARK_HIGH
attempt in __alloc_pages_may_oom().  Once the boost exceeds the memory
still free the allocator gives up and invokes the OOM killer, and a
capture kernel that is still booting has nothing to kill: the boot
panics and the vmcore is lost.

Seen on an arm64 machine with 64K pages, CONFIG_PAGE_BLOCK_MAX_ORDER=10
(pageblock = 64M) and crashkernel=512M, running a distribution kernel
based on 7.0.14.  A high order UNMOVABLE allocation fell back to a
MOVABLE pageblock while the capture kernel was still in do_initcalls():

  Node 0 DMA free:68096kB boost:65536kB min:68160kB
  low:68800kB high:69440kB managed:479168kB
  Out of memory and no killable processes...
  Kernel panic - not syncing: System is deadlocked on memory

The zone was not short of memory.  Subtracting the boost gives
min:2624kB low:3264kB high:3904kB, so the 68096kB still free sat 17
times above the high watermark and the allocator would not even have
entered its slow path.  The boost supplied 65536kB of the 68160kB min
and by itself put the zone 64kB under water.  It is that large because
boost_watermark() clamps it with max(pageblock_nr_pages, max_boost);
watermark_boost_factor alone would have allowed 5824kB.

Commit 14f69140ff9c ("mm: limit boost_watermark on small zones") already
tried to protect capture kernels, but it infers them from the zone size
and skips the boost only below four pageblocks.  arm64 64K pageblocks
were 512M then, so the guard reached zones up to 2G;
CONFIG_PAGE_BLOCK_MAX_ORDER can cap them at 64M, which shrinks the guard
to zones under 256M and lets this 468M zone through.

kdump is a property of the kernel, not of the zone, so test for it
directly.  A capture kernel exits within seconds and never uses the
fragmentation avoidance the boost buys.  Normal kernels are unaffected:
the size based check still covers their genuinely tiny zones.

Passing sysctl.vm.watermark_boost_factor=0 to the capture kernel does
not cover this window: sysctl.* parameters are written through procfs
by do_sysctl_args(), which runs after do_initcalls() where the panic
above happened, and watermark_boost_factor has no early_param of its
own.

Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
Cc: stable@vger.kernel.org # v5.0
Cc: Henry Willard <henry.willard@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
---
Build tested with CONFIG_CRASH_DUMP=y and =n.

Tested on the affected machine with the original crashkernel=512M and
capture kernel command line.  Without this patch both capture boots
panicked at 7.9s inside do_initcalls() with a 64M boost in place.  With
it, and with boost_watermark() instrumented, every call was suppressed -
including those inside do_initcalls(), where the panics happened - free
memory came down to within 64kB of the min watermark, where a single
boost would have put it 65472kB under, and the dump completed.
---
 mm/page_alloc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..276fa7169b99 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -37,6 +37,7 @@
 #include <linux/vmstat.h>
 #include <linux/fault-inject.h>
 #include <linux/compaction.h>
+#include <linux/crash_dump.h>
 #include <trace/events/kmem.h>
 #include <trace/events/oom.h>
 #include <linux/prefetch.h>
@@ -2178,6 +2179,14 @@ static inline bool boost_watermark(struct zone *zone)
 
 	if (!watermark_boost_factor)
 		return false;
+
+	/*
+	 * A kdump capture kernel exits before a boost can pay off, while
+	 * the raised watermark can exceed the memory left for the dump.
+	 */
+	if (is_kdump_kernel())
+		return false;
+
 	/*
 	 * Don't bother in zones that are unlikely to produce results.
 	 * On small machines, including kdump capture kernels running

base-commit: 704340f1cd0dcef829eb62f5b48ae95a2ce17bdf
-- 
2.43.7


