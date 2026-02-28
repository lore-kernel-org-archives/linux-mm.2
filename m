Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80FDCFEE4C9
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 14:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA8436B008A; Sat, 28 Feb 2026 09:20:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5FDB6B008C; Sat, 28 Feb 2026 09:20:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96AE6B0092; Sat, 28 Feb 2026 09:20:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C40D96B008A
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 09:20:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76A6B139E2E
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 14:20:51 +0000 (UTC)
X-FDA: 84494076702.11.2894254
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id B2BCE140010
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 14:20:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JcI/7Imt";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772288449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cngsu4QC/s/LsygBwa0X1EgXCc0toiqGLgWGzEjWZ30=;
	b=TGux9wbF6Tm47TAOlX2HPHMhMMomtBmqFDAbcTTkMeb7uCy1xgR/BnWg+fV+32ASaTOc/q
	djlDL9SuSz4kaVyiQBl6H/dvtHbjRL/7Np916IIVl0dgW2QZ89lzj1qw9/xOc56X3x2PGQ
	Bi1uzzYznMZsw8+vEnGGXCw8aCLUIKI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="JcI/7Imt";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772288449; a=rsa-sha256;
	cv=none;
	b=6qBiesu6oM2YaTxK1DrmF8+RcFCqYHRZivDBcL9gxVzGOL+ZP/XUrp8CgGIK70jPqo2ujQ
	obZ7d/ZDSAzQR0Ert3/jH+SePc9d15N8+BvwknbAcxPTK+HDQdapJ43b2lbKF6bojn6OXw
	Kec1lbZKrEVv43pxJVSuitUwU2YG7KY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772288448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cngsu4QC/s/LsygBwa0X1EgXCc0toiqGLgWGzEjWZ30=;
	b=JcI/7ImtJYPNViw4hRAStRxiuwGD/K2BPN2nAe3Qmvd6t5RC1XpXCbi6w+EM62Bo875+l4
	5tDwOAflDGo6MkCtOuMzbje/vhPK9w/h+fiw6v7rup3BxR94zCBkD1jBGwdz45EHLE8ITp
	x150gwG5DGtZHS+kNuAC8Jjzi8/vgj4=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Daniel Sedlak <daniel.sedlak@cdn77.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 3/3] cgroup: replace global cgroup_file_kn_lock with per-cgroup_file lock
Date: Sat, 28 Feb 2026 06:20:18 -0800
Message-ID: <20260228142018.3178529-4-shakeel.butt@linux.dev>
In-Reply-To: <20260228142018.3178529-1-shakeel.butt@linux.dev>
References: <20260228142018.3178529-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B2BCE140010
X-Stat-Signature: 6rcaccrmijueusen8oobjtziwhs8c9sh
X-Rspam-User: 
X-HE-Tag: 1772288449-354613
X-HE-Meta: U2FsdGVkX19PaWWgS72u+Q3cj2INE5JVLHQDHURXVB4CqngUtS7d89bqc4fGGQKiR10TnAIY8od/Zx/PGdxb4aJ8oLG/UXJDoyaWsc7CxeRlIoN4kpG6NcppJqRzNhMxRNOZpvE957YsnVONP+AvUct1s70ghWiexEE1rZRVs9M7/7LP4euo4huwTH1PpuGpSXKN7llNVDgWky7fCHNvm+I/QFdIt/YwBAooTj9Ke9Zow6/9hDXBbaltL9ANQl172qcADlve87NX5/uZ4UBZFjlsUNwy4Q0gdsn5Q7xdMaNJbNNUNRFkYsL8L/nlnzNBLQQDyXwj/Q7m038f+06TK48YoSMQNxeuxlnmc8pcFFSLHpgfJa4I01aYJc5osHdoWqvXcM0p9AGvjs4BkN2cOM8I+HAFbPexLgW2+L3Yf+/7xzqwTmF6DRXG4lcxKi/G2dpuyQ8ad+NEPMqsSkgddokndYQOk8Z5RoykWf9iXyQLiMrMatOkg8LOI1VbTKc/eAvy/+XzLBQzoBnED2nvIR1B3UUGwuei0HqaidLZPzGuEe3y+c5vK4g68RW3ky5TlayJ/f7njzjesYLMnh0Vwd+OMMoldObdVSqI/DzKpQwEZcDGRFXRSk7GXfFEnbPfe6Qt/AlIGCTT8VNVXgUGGr0W0Yxf5vBHJW7lAwZueyEniDtt+Y3DKWinIJ9B+p8Rx6NEH5APFxYPfRLClieoLgRnb/BQFIHYXMqN9NIXbY4ArPlVLd4vVCIoA1QBPVLmh0DjVWZO5RaKMTpAP9DJxxzen5AEYs1ahZw7p6b/wHANSrFt8viwqy1mxpjWMdYjs04qi0Wvc5z90NUG5u6o7dAfBGRstdmq03S4r5jXSIwvWURBCJiRIdAB7/MeLVJeuVdRLWkKM74jEuyaxVxdWXCE2s8JoCRwSJvOnoboKgoKXP8C6UOObggMo0QqJ9D9lXPXV2IgA8wpSvr+wbE
 3JNtDDkL
 78at89Up9ICLcCafsuCvSPxIi0iAUyhuVRcisr7x1Fn43eOJj9tCipVgzk2OuiDXMV4gD43RlHu2CwmludWZZgxXDW+4HiecNbBtiR47/SC9vbRVpBp93s/telhFjY8f+KFCdniIdmbVWJ1HZ50anP+Ex+6nR2Lpf8AUdVgZVPeuk5kZMHZhIBAUt7M/nR9tP+SeNvmArIUulUq9sB+8LlVKaYkgNe/HBpTVVhMMf9iuhHnrV6MAIkyco3oy6KoEnmGCRYOAX7b+TeZ4qgmFvcO5DCPZLEh5LFc/YBxPRMI9C5UI42X8gfuEtcQ==
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

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Jakub Kicinski <kuba@kernel.org>
---
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
index 5473ebd0f6c1..b502acad3c5c 100644
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
@@ -4428,10 +4422,8 @@ static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
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
@@ -4696,7 +4688,7 @@ void cgroup_file_notify(struct cgroup_file *cfile)
 	if (time_before_eq(jiffies, last + CGROUP_FILE_NOTIFY_MIN_INTV))
 		return;
 
-	spin_lock_irqsave(&cgroup_file_kn_lock, flags);
+	spin_lock_irqsave(&cfile->lock, flags);
 	if (cfile->kn) {
 		last = cfile->notified_at;
 		next = last + CGROUP_FILE_NOTIFY_MIN_INTV;
@@ -4709,7 +4701,7 @@ void cgroup_file_notify(struct cgroup_file *cfile)
 			WRITE_ONCE(cfile->notified_at, jiffies);
 		}
 	}
-	spin_unlock_irqrestore(&cgroup_file_kn_lock, flags);
+	spin_unlock_irqrestore(&cfile->lock, flags);
 
 	if (kn) {
 		kernfs_notify(kn);
@@ -4727,10 +4719,10 @@ void cgroup_file_show(struct cgroup_file *cfile, bool show)
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
2.47.3


