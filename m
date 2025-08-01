Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837DAC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 15:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24D4B8E0002; Fri,  1 Aug 2025 11:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE6D8E0001; Fri,  1 Aug 2025 11:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13BB68E0002; Fri,  1 Aug 2025 11:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 033DC8E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:37:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 78A4F56F00
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:37:03 +0000 (UTC)
X-FDA: 83728591926.15.59560D5
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf19.hostedemail.com (Postfix) with ESMTP id 63F911A0007
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:36:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf19.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754062620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=4LF00MadK2jy+fudvTazEQxlx/1p6BYXH7X504W6Khw=;
	b=eLeGT4/B6jbSz6Twu1OEZAMbaW+iugccksECFD2+JvnsJbiYRYJ6Z+cnuJ1nyV7rm/CPn0
	3ZJfXiMuL5D8alYyARJfNQTkD8c+Mti6BpZzfj8x0j4ylBy8r8w0j4SJTtgTXCoVudh8DY
	vXVYjUhnxG64KO5dRHdxRGbDhz97HdQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754062620; a=rsa-sha256;
	cv=none;
	b=WICbD+HU4zVLzZQF8DbqWXrkuAr7wINXKIRBVJW0jqyhk0fDr2eq7Vj49uzBwKge6pDWyQ
	YeWgudHqmx9BXhgjKUFeF9EbNqN3KidPWu1KrlXVPpdo+D+V/Ms1P6qVuJatterE5dsoUe
	7ICsV1d7ywCvW/k+uJF5O5dDzy1bF88=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf19.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4btqkB3KDJzYm1CN;
	Fri,  1 Aug 2025 23:34:10 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 1 Aug
 2025 23:36:53 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 1 Aug
 2025 23:36:53 +0800
From: <zhongjinji@honor.com>
To: <linux-mm@kvack.org>
CC: <akpm@linux-foundation.org>, <mhocko@suse.com>, <rientjes@google.com>,
	<shakeel.butt@linux.dev>, <npache@redhat.com>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<peterz@infradead.org>, <dvhart@infradead.org>, <dave@stgolabs.net>,
	<andrealmeid@igalia.com>, <liulu.liu@honor.com>, <feng.han@honor.com>
Subject: [[PATCH v2] 1/2] futex: Add check_robust_futex to verify process usage of robust_futex
Date: Fri, 1 Aug 2025 23:36:48 +0800
Message-ID: <20250801153649.23244-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To a018.hihonor.com
 (10.68.17.250)
X-Stat-Signature: rrazwuwfh1kg9pb4nnr8gk54qp9pm51q
X-Rspamd-Queue-Id: 63F911A0007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754062619-754908
X-HE-Meta: U2FsdGVkX19pe5ffxpxFHZHIF4hlHxVU8H1l5UmxXroGo4+E9Xl3diiHMxfz7VvhqNe5jtHR7Ivw2GN6WB3aJE7REU0mWEVRtgKHOwVFK5dHS1p+Ew9rkOc6iN1/ZgQ2HpL0eYVaMzqbKSAoJixm9MuXBKJw08qKC++YBLtA/C2E9SSTgoRqs3BJ22ztqBzrpSgY/U8Lcmsn7E6dUrNK5DVz682blV5Az+m9bPJJisMs5YY8APFBQM50GQO1/1xqQf7d8gzEeNYnbj5y7OCZaG6Yxi4yRYnYmxRjihxMkg+yZtLMCXZ4PttbGEUOcIFIQtol/7O+I9xX3lvVbMgJJZczmiak89TW3WC3yxZHnZ0Y9+zYyvg0Pbu8eeTvXlMTeCVpPPoTPv12pbrbshqO/d8I/vy5NpptsIUr9oxei01qAnjyjIthltqG5yLTYWaAj+eugtQ/oufg+i8zgoQdMvv0YZB3M0PMC25hxhzNR97bnCRGJ5gU7+UyF7XyUD14dxSOQ5bCk9oq0lnR/yAeqhimov6s1eqbLDytPQiCyllczxO/YgkVqEbg8h2q6ecATbVtKN89krE1ML47k/ojzOEkjrWzmlMKMYj4hF8kHF5yfJactB0Iq+4H0bMAtIJmNLmjQdL/wWmq7kM2phMw/Xilsm9dn0oze6WR5onIwTQ7EqPrp4Nu0D6sokoYQrbyiiK/lRD98kYo2IxelN0N7fBp2ucmFlJqJzSp/SiYNR3Sp4UuNAfdykL2518i3Hxhahu1MBuLhKsvZd6pYiKogVvPxQa/sZx1FOv3fEWVKBAYiPIximY++JWtPDUVdbCmvp5xBT7bR1eiJI6RxFQijMWeNUvDSxDRpqjUGKGjL0vSiEe4yxYhlD4jPr9xjMtJnnenWEZihuk3UmjCq2EVOYlRPPC3r438zTIhKXnL+wmKESDpW6hzm9jhXPAl68TGrgtWzW5CRGTXnpLYJlj
 gSpK7H4f
 A4ftWVrQeqXBaDMBWgtL5sXL3cbsKk/XpyySMXTd6K7dKb7Uajqc6iaCCJbKyBA9qEr6LhjuiQD3lU5Duitnyq0lWAvC3sQ5RB89cP21UUujNgkrrPuMVDH6eUIAxnCrjs1hAMEPdx0GJ+6SiqG951pylQySZ8KYIctOpZlISTEKVqRK7vfpgZCC7uGme4dwH3Q5/qiIlzdAKqEP+/sqRexumSpecTIDHeFJygIbCsBo9tDnYGoK8zdILnrsivGaWRSnGLAFArV5aNVvmEnkcGDobanDWkjF0Gw+Sb2R/O8/kvds=
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
index 9e9750f04980..b3ce7424609d 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -81,7 +81,8 @@ void futex_exec_release(struct task_struct *tsk);
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 int futex_hash_prctl(unsigned long arg2, unsigned long arg3, unsigned long arg4);
-
+bool check_robust_futex(struct task_struct *p);
+bool __check_robust_futex(struct task_struct *p);
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
+static inline bool __check_robust_futex(struct task_struct *p)
+{
+	return false;
+}
 static inline int futex_hash_allocate_default(void)
 {
 	return 0;
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index d9bb5567af0c..6cd385a62455 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1513,6 +1513,31 @@ void futex_exit_release(struct task_struct *tsk)
 	futex_cleanup_end(tsk, FUTEX_STATE_DEAD);
 }
 
+bool __check_robust_futex(struct task_struct *p)
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
+bool check_robust_futex(struct task_struct *p)
+{
+	bool has_robust;
+
+	rcu_read_lock();
+	has_robust = __check_robust_futex(p);
+	rcu_read_unlock();
+	return has_robust;
+}
+
 static void futex_hash_bucket_init(struct futex_hash_bucket *fhb,
 				   struct futex_private_hash *fph)
 {
-- 
2.17.1


