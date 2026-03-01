Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F7CFD0045
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DDCA6B008A; Sat, 28 Feb 2026 20:44:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4927D6B008C; Sat, 28 Feb 2026 20:44:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8586B0092; Sat, 28 Feb 2026 20:44:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B02A6B008A
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:44:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3BDF1403EB
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:44:03 +0000 (UTC)
X-FDA: 84495798366.17.3B1EECA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 58F8E140004
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:44:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n0zrOea4;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772329442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EkqByFFAs9m9qqH28dsuxFQcy77o19Eg8F7Op2FWyks=;
	b=O/QMX27rMxM/Gu7DvVhU7pb6WRRaKecbH+EZmBxn+mz+TzetvjefdcXD5sEWnxZkYFl+Oi
	9DwAIwrUKZ6ezwsF/GOOXPW6pK59lIHz70A3vmyYS6237JIu/Dw2EEDFr0PuTBJ6xLcor8
	+uadeAAFEBmhDS8EpPcfwCfqdIYOOfs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772329442; a=rsa-sha256;
	cv=none;
	b=ST4VASvlykCHm/8ydAOx7S09lLeuseWjp7WeDJd4l8U0/d1bJKPt2pHZ60mEY5YekXiEGk
	8RNJf3pimAr506dl3hAPaIPXR1B6O23ny7pZBsJyjIryH4p5bWYE9QEn3L/pfk3VW7+Beq
	Luiw1ImhYhJ0EoKKSvXGOotuJCdxH68=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n0zrOea4;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C72AF60123;
	Sun,  1 Mar 2026 01:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC180C19421;
	Sun,  1 Mar 2026 01:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329441;
	bh=BD3vIuhqmYcQWLzqKsBrANaPfNkObiKWmnF5V79hJrI=;
	h=From:To:Cc:Subject:Date:From;
	b=n0zrOea4zxRr81GoybntTMpngg5CY97+QGQjJXCW15fLLvmN2WSpglK+GKEGxD8G6
	 cUN47XBfih/jGC5YaGdOl6t+n3NVDDxAJIwXyZlKrJe5imQdMwt4ZJ71aTnFNAvWml
	 kgK84Q1a8EJg820kHD0M1dB627WZLDCgO5mCk1OxwWNIUpwW7/JLLJ34a7f+JjCwHt
	 IOxwOWdEcGQVaOAOE857vQ+nbbPuk72dBuAFjMrz1p+tgJ11NMqPaFtyBtaznCVrpp
	 yyvtUAUtwbh00bJXU8wpo3Cd3+b00yU/aYtc7dtcu0R12fgQb+tl4Hac0TRP6FPJRw
	 FPOZN1IGKEfSA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	kartikey406@gmail.com
Cc: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com,
	Uladzislau Rezki <urezki@gmail.com>,
	Hillf Danton <hdanton@sina.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:43:59 -0500
Message-ID: <20260301014359.1706097-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 58F8E140004
X-Stat-Signature: nyfmnekdbmictps3ery68ak8ozmu83s3
X-Rspam-User: 
X-HE-Tag: 1772329442-676880
X-HE-Meta: U2FsdGVkX19hAVcW1Hsf8gB04+4oQydAl1jrDqpUfiJNTz9rLgAWTQd9UXpQi8xaDLxcj+I/PXLb5/jgPerhrK7ijpyX/e5Lyh5IgUFuJbbjOAfoky75cri9MwPrehQ8UXA55X+lxI1vJKRjJxgZPFpl34XtXz5ryZkZmrzylHja/WepFFAMXhxXEghZnP3gof/DsxicoXApnjcU9HpTbQFtUGgcjbjx5BfgWapBeJjd9RINo/aW8GykB6QxVVVotQJzhiIuqM5GA0++hBxIayIEbSI0EUAYhlFDzXpXrAoPzF/R2vO6azkB8vAOScfIDmb//wM49v5FncYnFbQTBblryhLkwyfmD38H04VTi+XrehmkT2Fbojjd2oAwO+/YdMa8JnLCh5a03IGFE7aWtMoaUbsPQwA9uVawtYNnJPSO3yZ5j+QjO1yoQOPxqRV/Bg7vsNKRKRs/Vss+5j1QCehJxj5YogxQinXZ7hp9/h7bNucBpacK5bEzLTK/wnftjNpLsuPjqGh7VPqhkPYL+iZsnMftBjnBVHD+hOTao7AKHPCwYklJwUN58w1VPWkk37RiA7P2dcDiqGeaWyzScyUL3Ijnk9j/DR0yjnHPPIM4LMTVw1HMw0pYj0teivsXLeVpVF1GGQnnBADnusZbJ93WrbzzaJzzC5ntDr42pqLy5l7FF+t5YDEbKew1Hu5ajOlPWyr3ixodNkGarY1CLqhhuJdzNsihzgrVsV6u7lxyFtiAHm7HVIvEGOmiIun9PUUduVC73OU65oh1snIStb1UozNcLxhPY5IdjFKyG+3q0AwWgXMc4ktejY/NC6ISPRapSXQag17FrRq1yH99tuCSgoKx9dWm0u7DMXiLOA+8mu1ztFbcf1BQ4fU59Hq/YZpMTNwbh+3+GvqxZENh2YBNXXPj81taQn7M5MVuydUEplk5Fax+pyhBhLW2LFlxerbYTyg3SAZHfOBUenw
 bWnHENg4
 JNlT7aVSt75yVyAX+qYzgiZtvWZMt1dhjxhVo83JNR2tvhIspzL0NLu5kJJx9Co9zCMRV+6RT7/zkngkXFGq0lqVeSTYPXxIVvKmon27wpnWDTBLXlSjbgohgc8yw6sVplNnr3rWjvX56uh5F2Wt50UYmU2MjEzgceqYCvDeAZ2PrSORw6Eyz8VCsB3RSHMD4eUXB15L0/F7eMzjE0QWtJQVY7S6eChxc/ROLb0exr2htt1cMGUDMcRNzGH6Ix8fi5LPJrJmjOD5xh8jLZJAFaQ1qnXkUTMk87YdUf52o+j2qf034oUGr5YRHDIt2dLKmMr09O32qcnT9NLVrVPJpCbWq3DYm8WXVNGzLP5b4N9SLkwrbFOhHtd1cfpN0zsAthZsmbBvjdEEUYiIfaVWWltPybR7mFWWd/wfTTCv/unUvZHOWtVE1hcQN9WmZMXqCEuvvDzu7ggmY1UMQfMJ5UV2ZkmhxRMTHyKwowTYRmeXKfk6j9pvdNRy1EZgMYc8NTIAbVWCcC4+Ec/xL1JYywiLKhsjBmnWRw6cS6BWEbMkCIpFhzcHYLZVdizIr6/MPk9YtTxWMoziMEyziWMisYfYAcXg7kJL/i04Pwj+XJfgPZtA4n3TE023M2frSUz+CAowGTX54O0CJGgI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 5747435e0fd474c24530ef1a6822f47e7d264b27 Mon Sep 17 00:00:00 2001
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 12 Jan 2026 16:06:12 +0530
Subject: [PATCH] mm/vmalloc: prevent RCU stalls in kasan_release_vmalloc_node

When CONFIG_PAGE_OWNER is enabled, freeing KASAN shadow pages during
vmalloc cleanup triggers expensive stack unwinding that acquires RCU read
locks.  Processing a large purge_list without rescheduling can cause the
task to hold CPU for extended periods (10+ seconds), leading to RCU stalls
and potential OOM conditions.

The issue manifests in purge_vmap_node() -> kasan_release_vmalloc_node()
where iterating through hundreds or thousands of vmap_area entries and
freeing their associated shadow pages causes:

  rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
  rcu: Tasks blocked on level-0 rcu_node (CPUs 0-1): P6229/1:b..l
  ...
  task:kworker/0:17 state:R running task stack:28840 pid:6229
  ...
  kasan_release_vmalloc_node+0x1ba/0xad0 mm/vmalloc.c:2299
  purge_vmap_node+0x1ba/0xad0 mm/vmalloc.c:2299

Each call to kasan_release_vmalloc() can free many pages, and with
page_owner tracking, each free triggers save_stack() which performs stack
unwinding under RCU read lock.  Without yielding, this creates an
unbounded RCU critical section.

Add periodic cond_resched() calls within the loop to allow:
- RCU grace periods to complete
- Other tasks to run
- Scheduler to preempt when needed

The fix uses need_resched() for immediate response under load, with a
batch count of 32 as a guaranteed upper bound to prevent worst-case stalls
even under light load.

Link: https://lkml.kernel.org/r/20260112103612.627247-1-kartikey406@gmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+d8d4c31d40f868eaea30@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d8d4c31d40f868eaea30
Link: https://lore.kernel.org/all/20260112084723.622910-1-kartikey406@gmail.com/T/ [v1]
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/vmalloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 32d6ee92d4ff8..ca4c653286870 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2273,11 +2273,14 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
 	reclaim_list_global(&decay_list);
 }
 
+#define KASAN_RELEASE_BATCH_SIZE 32
+
 static void
 kasan_release_vmalloc_node(struct vmap_node *vn)
 {
 	struct vmap_area *va;
 	unsigned long start, end;
+	unsigned int batch_count = 0;
 
 	start = list_first_entry(&vn->purge_list, struct vmap_area, list)->va_start;
 	end = list_last_entry(&vn->purge_list, struct vmap_area, list)->va_end;
@@ -2287,6 +2290,11 @@ kasan_release_vmalloc_node(struct vmap_node *vn)
 			kasan_release_vmalloc(va->va_start, va->va_end,
 				va->va_start, va->va_end,
 				KASAN_VMALLOC_PAGE_RANGE);
+
+		if (need_resched() || (++batch_count >= KASAN_RELEASE_BATCH_SIZE)) {
+			cond_resched();
+			batch_count = 0;
+		}
 	}
 
 	kasan_release_vmalloc(start, end, start, end, KASAN_VMALLOC_TLB_FLUSH);
-- 
2.51.0





