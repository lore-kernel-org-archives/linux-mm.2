Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77CD5FD88D3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 01:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91CEF6B0092; Tue, 10 Mar 2026 21:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F51B6B0093; Tue, 10 Mar 2026 21:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FE566B0095; Tue, 10 Mar 2026 21:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0686B0092
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 21:01:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9A3F13AF99
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:01:21 +0000 (UTC)
X-FDA: 84531978762.21.B0A20D2
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 123D2A0011
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:01:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TAdFKhz4;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773190880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9HsfOrfS+eqleG7h8cZbUZvSAAorR+E1jNWHkvLrQs=;
	b=UtqzexbfWNFNmzUeeEv7bTUh7JCOAIG9sKQ9FEhQfxbxPAf1Qrr/ww+3kEaMpUlwitpUTu
	zxoTeVooQif4Qt9U+I5k5YhsRoT+dDEWkzGOBFGNZTMySx/jMKjxGOgSQqPxRmqp7n1RG5
	MpKGsmZCl+s5OW0pHe1xTHNV7Kiyo2M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773190880; a=rsa-sha256;
	cv=none;
	b=un56TTPVqDrI0+ODeIOLVOrPonOKWCxgGCopqiuQFmynpM9xpCgGXHx0/bBx0Yq9LOO6V9
	Y6Ad0M+yWTX9wJXiEsXkYq9ig1Yd2Ehjm0IS+4MJf1nEk0DbS5YRhWJ1NJdrblXyzbYnpc
	zEe/MUqlvykr2jMYYDqSTdU4Trd6YWU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TAdFKhz4;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773190878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K9HsfOrfS+eqleG7h8cZbUZvSAAorR+E1jNWHkvLrQs=;
	b=TAdFKhz4AGLvyBz1IQjH0d3LhD1RTXPiZ2TQ7EZzlcgkFQvEF434gIsHRJvYntgR8tsGMw
	/waxpyhhsTwNuPUNoJhbqy1ptgdIJ350DJKpO8K6NcG2plAibuoiWLvOwomc2307tPzKWU
	F6v7NInwpaK1M5+TnPFoRUzVIuHdlwo=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] cgroup: replace global cgroup_file_kn_lock with per-cgroup_file lock
Date: Tue, 10 Mar 2026 18:01:01 -0700
Message-ID: <20260311010101.3306366-4-shakeel.butt@linux.dev>
In-Reply-To: <20260311010101.3306366-1-shakeel.butt@linux.dev>
References: <20260311010101.3306366-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: mk35pox53dheugu7kuouqjehp5gaygo1
X-Rspam-User: 
X-Rspamd-Queue-Id: 123D2A0011
X-Rspamd-Server: rspam12
X-HE-Tag: 1773190879-780927
X-HE-Meta: U2FsdGVkX1/EOKrqjQXqyhtD2+vLOBqaWvnuTKwFq0/c3WdEAZCH+BcNjzEI6zpYdsIOWcld/drnuqKFM6cnyXvGjg8rDNxypOOVXevlfQuqycFjz0pup8OOrr2itizPKUNW3Rr5kBsN0qnPHGM+FoeoEJNdujPKepFaipb5gRHyWwB1e06lND3BZ/NWscU+Th+w6KeK6OBlCXQQSqIyC/HuvQ2AscHNAbNu5/xgxZj/E2NZh7969eLgGEMLpNv3UawJMbZHUibVG+ybsfN1Fqb+gQZ/VqHTbzlzTIspc+BLPECqWN7i1sCHcc8dN//wyT9/rz24L81uyVr2yEkCzX5h40K/bIoj5QAuLNRLSpPuDHejN+m8H5PJVKkGNn/HCHnDL/tw0KjOkfLsPO2zSZ6fWZTlKr8tdp2N7QU28bg0Sg3SN4QTbBBJrtj2ZMr3wLmvRfF2evYVfYiFKVryjlafURet+kd3GsuKgzmI47FL2uY97qKdftzsifBXBLIWjtwVNNEjGU5CrS0COHySiBtkqFWRXLl6Z7+lt4Te5r3yV0WwT6lZy33znY+qFpgvNf4PEM0W0uGipU6Px64Wd+tW1SlpZ6hggDolVhUcvRGjdhPilhNqNgFGH2w6U1rmfXkIm5+uPoC7D9Fhsh6OtKqP+72pmw0yUsD60iNrDRenF+4WlJX5+UC93X72TDLbEvDO9iAU2oqqxauEv17uZydzOQonzkQtVqKlJcIPXhYjjkgHBsquO265Hk3Bui6+ShI7Z2aLA4SM+cbLWsKoS/3mz6gKhLYG/XnJqwX6OVNmT37vu/InUIu/rI6qvmzJnPA1JsQKf4CTgqOsdFOChyMrhgfo4O2jGYu0TTLqknpSM0Xh3SCLy8PeGSwCiG+h6h9W465Avj8PVaRA/pRHbNud6jTsNVHfVATV72Gq65RZZv6JNQDiMKJV8YEgLMGjiD6rDBphWntXxEfbr+f
 HFoqeq1U
 lRy5SEwn2ruZUBLZNiGqcYUwczvL/CF686KAmMuV6qupcjaHzTglHeJaWs5QRVm5Fe1hbAXsJak4VqmjER0BqIwApqYEUpInh/OcvUuDg0ogQj7Ro6Ac496/3EY0hWcKtQw0OGxCIZEAah23uCto4ltUhJZwEHB7sMGepOmLgFYxpuh13QX9/RXHMtm2n/UPL7qqmsZOO+90hEOMsxgrNxrYZfTTsJTIT4mPis0MAHQn7Rgg5mnp1b7GhUkU2Qq4shjpQXNdS7W2lLTDkWaZ6WrEw0+v364pIK8UNbZ1Mn6YYdgw0oWryiK9Xkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the global cgroup_file_kn_lock with a per-cgroup_file spinlock
to eliminate cross-cgroup contention as it is not really protecting
data shared between different cgroups.

The lock is initialized in cgroup_add_file() alongside timer_setup().
No lock acquisition is needed during initialization since the cgroup
directory is being populated under cgroup_mutex and no concurrent
accessors exist at that point.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
Changes since v1:
- N/A

 include/linux/cgroup-defs.h |  1 +
 kernel/cgroup/cgroup.c      | 24 ++++++++----------------
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index bb92f5c169ca..ba26b5d05ce3 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -167,6 +167,7 @@ struct cgroup_file {
 	struct kernfs_node *kn;
 	unsigned long notified_at;
 	struct timer_list notify_timer;
+	spinlock_t lock;
 };
 
 /*
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b00f4c3242e0..d899bb2aef2f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -107,12 +107,6 @@ static bool cgroup_debug __read_mostly;
  */
 static DEFINE_SPINLOCK(cgroup_idr_lock);
 
-/*
- * Protects cgroup_file->kn for !self csses.  It synchronizes notifications
- * against file removal/re-creation across css hiding.
- */
-static DEFINE_SPINLOCK(cgroup_file_kn_lock);
-
 DEFINE_PERCPU_RWSEM(cgroup_threadgroup_rwsem);
 
 #define cgroup_assert_mutex_or_rcu_locked()				\
@@ -1748,9 +1742,9 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
 		struct cgroup_subsys_state *css = cgroup_css(cgrp, cft->ss);
 		struct cgroup_file *cfile = (void *)css + cft->file_offset;
 
-		spin_lock_irq(&cgroup_file_kn_lock);
+		spin_lock_irq(&cfile->lock);
 		WRITE_ONCE(cfile->kn, NULL);
-		spin_unlock_irq(&cgroup_file_kn_lock);
+		spin_unlock_irq(&cfile->lock);
 
 		timer_delete_sync(&cfile->notify_timer);
 	}
@@ -4427,10 +4421,8 @@ static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
 		struct cgroup_file *cfile = (void *)css + cft->file_offset;
 
 		timer_setup(&cfile->notify_timer, cgroup_file_notify_timer, 0);
-
-		spin_lock_irq(&cgroup_file_kn_lock);
-		WRITE_ONCE(cfile->kn, kn);
-		spin_unlock_irq(&cgroup_file_kn_lock);
+		spin_lock_init(&cfile->lock);
+		cfile->kn = kn;
 	}
 
 	return 0;
@@ -4699,13 +4691,13 @@ void cgroup_file_notify(struct cgroup_file *cfile)
 			return;
 	}
 
-	spin_lock_irqsave(&cgroup_file_kn_lock, flags);
+	spin_lock_irqsave(&cfile->lock, flags);
 	if (cfile->kn) {
 		kn = cfile->kn;
 		kernfs_get(kn);
 		WRITE_ONCE(cfile->notified_at, jiffies);
 	}
-	spin_unlock_irqrestore(&cgroup_file_kn_lock, flags);
+	spin_unlock_irqrestore(&cfile->lock, flags);
 
 	if (kn) {
 		kernfs_notify(kn);
@@ -4723,10 +4715,10 @@ void cgroup_file_show(struct cgroup_file *cfile, bool show)
 {
 	struct kernfs_node *kn;
 
-	spin_lock_irq(&cgroup_file_kn_lock);
+	spin_lock_irq(&cfile->lock);
 	kn = cfile->kn;
 	kernfs_get(kn);
-	spin_unlock_irq(&cgroup_file_kn_lock);
+	spin_unlock_irq(&cfile->lock);
 
 	if (kn)
 		kernfs_show(kn, show);
-- 
2.52.0


