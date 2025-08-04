Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9267EC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 03:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36B96B0088; Sun,  3 Aug 2025 23:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0EB16B0089; Sun,  3 Aug 2025 23:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EBB86B008C; Sun,  3 Aug 2025 23:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80C6D6B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 23:03:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30C80135F25
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 03:03:54 +0000 (UTC)
X-FDA: 83737580388.27.A98D06C
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf09.hostedemail.com (Postfix) with ESMTP id D1A6E14000E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 03:03:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf09.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754276632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=HcUZ/bMY9afRoor5xU8oke+MSZoMqvniop1N0wQ9vdw=;
	b=2UuLZNAlNi0uYXKxXpkO5bHwvYICAsH/eg4xovLzkUu7SiYgehylUsm2n0WPMq5Fz/wRBd
	aIVcsYPjWLlG5thydXoAh4nu4oTTUTOrT/bpY5k4ZJ18H4DXNvzelS7kzetfbdeR18S+l7
	H0Lg+okkyrHxgtB+MLDSd/x/fs3HD6Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754276632; a=rsa-sha256;
	cv=none;
	b=UUKcx6nKMz/SsZxRHeOQ0WarqH4FUB0OXpqLW2R+ut0llHnbtwzTLibOwwLjmFzGr99ZTs
	tIDRTEJ3OmKFmlJ3BombhAkNesLK/BkBU1fKuo4ljz7Pnw393zGrySd0wi92kuOV25w1j5
	WRRa+t/cvWs6fQJKONELdEj+QZ9A2LA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf09.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4bwLsV1wfzzYl7vf;
	Mon,  4 Aug 2025 11:00:46 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 4 Aug
 2025 11:03:46 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 4 Aug
 2025 11:03:45 +0800
From: <zhongjinji@honor.com>
To: <linux-mm@kvack.org>
CC: <akpm@linux-foundation.org>, <mhocko@suse.com>, <rientjes@google.com>,
	<shakeel.butt@linux.dev>, <npache@redhat.com>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<peterz@infradead.org>, <dvhart@infradead.org>, <dave@stgolabs.net>,
	<andrealmeid@igalia.com>, <liulu.liu@honor.com>, <feng.han@honor.com>
Subject: [PATCH v3 1/2] futex: Add check_robust_futex to verify process usage of robust_futex
Date: Mon, 4 Aug 2025 11:03:40 +0800
Message-ID: <20250804030341.18619-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: D1A6E14000E
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: kpo6aze6cbdifm1d4y133x3ot7tbwsub
X-HE-Tag: 1754276631-474782
X-HE-Meta: U2FsdGVkX1+n53PMmiEO4nffdVRaI/pTOz3OjJqZ9qWIwHzkh6bEGxa533rgXfH5xIOLL0IEALyX6XWzCbb6p/WStkyP2I4bWbZ3o7nnAwvF2QIJRht5H8eY8n825GfT9C3Tzi0WQWSwFHjSEdH9qnXxv+oXpkbkjCQLVcQdKvZIjr5yoG8KJQssni+LGwzqGLokFtmSq+hwMNapIWeVLiwrzkSYAWKUjT9ORYtohNc+bSvkrnC4msoSeSlup/rL0FO8gaj0e6ZSjRnih335AJQAuMI1lJx8Qo/whXsaJm6Zg4+V2wUyStEm7LiXHX17RmgcBMG/3BWg5y2weHckwtdbyNHRsaqqgIxOdr9nz8nz+poO+6xTdRgy1W2S6VRXWWwGvc6nL52Ze5EfhM7JCQos8IK7uAteWU68PqtT00EP/c/cKjEDjLph3hmlY8mcBB2zH3ECmN4bt/179e4Vbb7T3nPGy7px1XATx8VkAcylVBVRh6WFep+dpMYHKojteKEBKygFGswFkwDYHytGR+4iEC4bFVXA4YKs391bVEXFVlZZryS7+rDuq6jlUkyd81waXHqMjczL05QDvYuCX5Tbp8BiI8Df4ro1srPCDnSo8YafTvrNg0DhMe5CDXEHofkfD/TGBvq5aWt0Lzs2rcbS/sZ2+Mai8CoBhxGzqeGcxDbMQ9R6wXyKCiSPPWyiY7yWnuPCj2MShQZ2zXIUG9/POnOBOnqIiSQyexOfooWrqv50/IBYEz15ENb1lj9F9/3YHyW15Dht6B/hNr/2HEAr0wBKjoCvP/IYC6SvLcLzJG49p4zJnctHJbFg0hOlpWWiHA/mmXYTCjlu6tJuugKiECaToryZqVRRGfl3bcz5mj3JBTA7O6dr1koThsAhVIedWW5YMZ+1upu5EMWa6kwvlcKfZkH62Js9zV5dv2glhRRS3NXLDoFgshymTGO8X0dmsPZm9IYvHwlcCtW
 0qSmpP2t
 Ye76oUyUPebCzroFzO3GnPBavsqffoDkd7IOPmK9SUf+tGaHK+FyoCSFsqsdrDTPeP7V8rYR0i+V0btPQfjnuwVM9tfMNpt4KskCiL85F16YQv+LZji+LtCXg9AgZ3jGSmup07Tglb/n/w84OAfBik1sj3aWOj1ruSmuXS9KyG35FaBnwu3wW+1OLQ21xlu5kExeA7F99wYGN9gcPGW6t475vpeHt7Z/Hqy6k8wxwimwzHBgGppgbpmGTrfQHLS2fCUxw8F4hQkjjiEKXz2UVx8JoOdiF7rPFXEiHIaiymXb8bqs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: zhongjinji <zhongjinji@honor.com>

The check_robust_futex function is added to detect whether a process uses
robust_futex.

According to the patch discussion
(https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u),
executing the OOM reaper too early on processes using robust_futex may cause
the lock holder to wait indefinitely.

Therefore, this patch introduces check_robust_futex to identify such
processes during OOM reaper execution, and delays the OOM reaper specifically
for processes using robust_futex.

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 include/linux/futex.h | 11 ++++++++++-
 kernel/futex/core.c   | 25 +++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 9e9750f04980..c879300d4ff8 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -81,7 +81,8 @@ void futex_exec_release(struct task_struct *tsk);
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 int futex_hash_prctl(unsigned long arg2, unsigned long arg3, unsigned long arg4);
-
+bool check_robust_futex(struct task_struct *p);
+bool check_robust_futex_rcu(struct task_struct *p);
 #ifdef CONFIG_FUTEX_PRIVATE_HASH
 int futex_hash_allocate_default(void);
 void futex_hash_free(struct mm_struct *mm);
@@ -108,6 +109,14 @@ static inline int futex_hash_prctl(unsigned long arg2, unsigned long arg3, unsig
 {
 	return -EINVAL;
 }
+static inline bool check_robust_futex(struct task_struct *p)
+{
+	return false;
+}
+static inline bool check_robust_futex_rcu(struct task_struct *p)
+{
+	return false;
+}
 static inline int futex_hash_allocate_default(void)
 {
 	return 0;
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index d9bb5567af0c..c9d8a1947bf1 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1513,6 +1513,31 @@ void futex_exit_release(struct task_struct *tsk)
 	futex_cleanup_end(tsk, FUTEX_STATE_DEAD);
 }
 
+bool check_robust_futex(struct task_struct *p)
+{
+	struct task_struct *t;
+
+	for_each_thread(p, t) {
+		if (unlikely(t->robust_list))
+			return true;
+#ifdef CONFIG_COMPAT
+		if (unlikely(t->compat_robust_list))
+			return true;
+#endif
+	}
+	return false;
+}
+
+bool check_robust_futex_rcu(struct task_struct *p)
+{
+	bool has_robust;
+
+	rcu_read_lock();
+	has_robust = check_robust_futex(p);
+	rcu_read_unlock();
+	return has_robust;
+}
+
 static void futex_hash_bucket_init(struct futex_hash_bucket *fhb,
 				   struct futex_private_hash *fph)
 {
-- 
2.17.1


