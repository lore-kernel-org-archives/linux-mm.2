Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0212AD12691
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59D1F6B0096; Wed,  3 Dec 2025 04:29:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D4F6B0098; Wed,  3 Dec 2025 04:29:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39FC96B0099; Wed,  3 Dec 2025 04:29:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23F0A6B0096
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:29:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D525458DD7
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:29:08 +0000 (UTC)
X-FDA: 84177635976.09.35C9E05
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 00A46A000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:29:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aTcOO1GU;
	spf=pass (imf15.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764754147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QdTv6wkSHwAMSOll3YwLh5RVP5GPGXPQVcJa4xCpXQ8=;
	b=Q1bvMQAj0U8vqQ0vRBDmJ5IPAr90TYTMkVA/BhNwUc2jNXhboD8A36K+/iLe3BWLQd4vVV
	U9uCU+q8SZqrqhAxU38ukWo5Vk2A2rnPVafS1yj3Uu61wp9Mh+N843XnWI8seBdhDUQF/s
	Wun5At5f/ik+G4HmOhlVr8vBkcRApvU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764754147; a=rsa-sha256;
	cv=none;
	b=SwsD88GUJUGupA342c4I+S6L8XNlI2SaxxU5x1dvYsuhGCtKhT2uNP4pRwg75i/8YP4CWn
	quPkiGYaFaP90Al2xLahHQ8+5WquzCvx7GuOna98nV2xusIny9S1P00r9T4eR6m/yWFYY/
	6DA1mPPBx1W54sO/S7DWJnmjE1xgYn8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aTcOO1GU;
	spf=pass (imf15.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-640aa1445c3so9884564a12.1
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 01:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764754145; x=1765358945; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QdTv6wkSHwAMSOll3YwLh5RVP5GPGXPQVcJa4xCpXQ8=;
        b=aTcOO1GUyZVdM5IlnXfwsKPOVTGhbBt+iLkLBfUAgK8+4btDZVZxf+dEbLC7Gu0kzh
         KD4vJS+M0kpbiYDr3YkZOr7p9fUJL50eCQSxo4nL5IPPqGJNiTeMXjb46HdRC6ygOSt0
         jAAf+TgqWPYJbY57KifG5kDv3qWvYUMedKcaGtD5iQwatBo58Xkue6tc627oNgghCx8r
         81yxOQwdSCb0BjBlmKixLtuYqiUx7B1fwdEMxIAvQKuzLyOkwbvMNmOZ+4Ms7OFp2Nrp
         sTrHIXZd+3hY7+/vl+yQfw36IPMjfqceJ4wADSe3Ye3I8vdeUhF7bY+MGoAEk0gWEynl
         p8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764754145; x=1765358945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QdTv6wkSHwAMSOll3YwLh5RVP5GPGXPQVcJa4xCpXQ8=;
        b=f98HynD0xLNfVDcurfoj1XPCJ6d25aezzjfECP0V+zL1WRO+/QLiY2TvDesBP1lDnN
         OEPmeHRVKvLRb7QX31DOl7Bn3v6TVUmG1/MjfiyaRiQEmvdpbBSP2glSCu1BKfygVfdr
         /BCxRQtNHE7iEZj0lOG+nP4g9x990iBSqTpN63k2B8+h/EErjsjQNqhbS4B5XOJZpzUk
         jWVIIkWuAv5iXfQZPq/dHRIPDZD5NvRUC45oBq5ttY8mcqafFoi03d4N9HYUSNH8qWyC
         BNN/MYZdo+YIKxTMkKxT+VWMsd5fgt714UOGsmfV6U+qPZmo0n/zRTY0QaFE5oCntTer
         b/bw==
X-Forwarded-Encrypted: i=1; AJvYcCUlw3J4gOc7S4WZgLXlLzfGylUcM2XHELaLfWKI3/kQ/gEW1YF19DM44fpJzkGo+U053Qm2p2aK9Q==@kvack.org
X-Gm-Message-State: AOJu0YxQM2W+EqdhZVpLaYbEazwvjjAI9AqxtdJry3u/0ZChfAUOi6k1
	BxGZdSE9zRghpaHeiqUKZ2e6g3+P8HWrRUZfVFM42q748VHctfGfas/I
X-Gm-Gg: ASbGncsaHfUdl8bInJrgPtk5b4W5wjZj8WlVxvQJBxWf5X0a/brY5zVsk93mKBnoS/A
	9l5VFywHI4bA7QNDe9YqUqjKo3h/dCsxbcNBgrjzdrD85TRbglsRPzLljQ/P63jr2tqpuH5l7ZV
	X8HzBApmo9gMTKvKB7OBhMqvB4aoJC+xtWn/UhDJMZRAm0IA+fvQVhXV1BWWuE3LDSgNFElG+Do
	T1K8cSnCg4wo9tH0JgctjqMWeD1taV0YNsMvup59kpZGYAiZt9tnuWkqGvPlVMgPvDpq7MdDJYA
	WjNofq+O8s2X4QN7tXvvfQO2pl9q4pYqQqZQMaky2nVt8MiIe3so1VKunT9YJhROtI2sst936oV
	J5KC5CQt26ZG5GwowQHVmt2VXwCtHRCaxhskc4lSZyrfy9bAYZ079u++UIfbKm12VO+eRG364M8
	J+esq/yjH1408yLGvXEcdN94qIw2fsUCzhl1LYNeI7DTwx5B0i0R/mHpqQP38=
X-Google-Smtp-Source: AGHT+IGafodK6wrQHJ3egSmEyL5fp27hY/MK2pNcmMmGZDlnu9hdJtMQDjyaHTeG4cmC0C2KG74s0Q==
X-Received: by 2002:a05:6402:1468:b0:647:7b37:2bc5 with SMTP id 4fb4d7f45d1cf-6479c4b2a3bmr1126107a12.31.1764754145323;
        Wed, 03 Dec 2025 01:29:05 -0800 (PST)
Received: from f.. (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64750a90d14sm17859981a12.10.2025.12.03.01.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 01:29:04 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: oleg@redhat.com
Cc: brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v2 2/2] pid: only take pidmap_lock once on alloc
Date: Wed,  3 Dec 2025 10:28:51 +0100
Message-ID: <20251203092851.287617-3-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251203092851.287617-1-mjguzik@gmail.com>
References: <20251203092851.287617-1-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 00A46A000A
X-Stat-Signature: 9ijqfnrtzyeccigm8mmiraqkd6djde5f
X-Rspam-User: 
X-HE-Tag: 1764754146-875336
X-HE-Meta: U2FsdGVkX19JU9v1GT09ItbxsvFh3L9ifmdUnhlt2vZeEP/+KT8mm1QXKGJnZPzdd0BCP6YaiSPBMBlc+EAMkgN/UYja5tNHnn0OJ3JirhoBXRmSLwoRaLefWqpnS7eOiCMz2lnVe05KJgoTnSj36+AjGry1uooVTsJ/psZz7zI3OvCTM6rAZ0h6G3uBUMEqkdkr8R8R9LyinH5GfGccYtIe6SlECDmLvujR9jmNQJocnexPL6tcctB4sbzsfF4TQQoyYB1ALDTWNKA1T6ng8JA9kkG3svdXACvWQj+LxBg+6G46cO48CQLcpSAwhgDxhA9SB5+sPixYSqKOpoTCcA7UntcfOT+ZF6C3u7xqrYLSASUgH9A9ye4KKRUdG+Hi88gUw9hQYSCW3xtO2cfAEvwrAm6oLnsWqka+MC3a2BoiCRLIKSGngwrRgDmiqPd8QRmVSQTykuaTxXUqUy2nES2Hjt4F5hE5soT8P222ytqz3taVMjrl8Sqj+t+GqZSL35FknW8izE6TKyH6hrbwsU4fa7o4rUiuDtz83qjE0EnfEoZzo9Zl8Au8FhRGoh9hJoJRwWUXoWXkQ6oELU/jXiDPJPICcS5Vg8CxIk+xb6W/82j3+Xce0l7LLPkVSrDEPe1ItelOLJP9J/BKfAfxbCtYF5OBh8gTrew617fJ3rnFoIyaDgUp5PvgDj8briZ6QL+tTxqm54rNcF8i5UyQKOHLYXcRG1261Yz0taNnWl7AaDyqby9ITnd0t0x9jqwoQ+Fi9fNEON6QPr2c1jshw7gLYRYPW+xU2AllvN0UZL7zJu0pcA6Eg+JO1ORKvNMsq1GPbbtE+AQGbIbGtbQyMi4B6oBl+9LJ2x9rBZQSX1y/yQwEnMcwA4fjw0mlY/6HyaZjFNG3jjawy7GKOi+mRv66ZHpha1zWIIaBYnt1D8e3t2Wd5SdPZnF6KISq32ZfKrX4yMcgSWcPBQEkesO
 cpaOXQ3R
 fd0f7cQ/X8aSCQ7kqX/JTKLNb7SjB2BIlgCUmgJgnYjf9e6MMI9Z6b0hDzKXpgWJ+n99Rqe1ARK1LI6XaBXB3WkYAY20/I0nOJ74p0GFWf30aH2dw/KYl4c4mfPxEjNXMbMjABDvQTc4sQutjgj+hfmqXAk+PepBgv2u7V+1HAiuYGH7lCO87T0+2U9KM5OPiNJKl5z22389dvsXOKqABDlQ5lOQV1cOSo3IPFipHd/1rVFq+d3NO+TdTqSet3C/JsBpcIQ8I7uDZLJcsHjaKz59lPmm3N9BqYxwgZKOukqLwEyZgWj0kExSEyRm2kwl7EkTZ0VqUtdKacySl/QDrHlXVii/GoY5ilD0GmWpe9Eqs/73GHzKK2hpD9yNm/8JB7xSRgL2phoH7+gZcgyS/p1XOWzZMnBVJG73EuAyea52uyz3yc051VqQJDDHTR8qKlz/nfm1EG1Dqvck=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When spawning and killing threads in separate processes in parallel the
primary bottleneck on the stock kernel is pidmap_lock, largely because
of a back-to-back acquire in the common case. This aspect is fixed with
the patch.

Performance improvement varies between reboots. When benchmarking with
20 processes creating and killing threads in a loop, the unpatched
baseline hovers around 465k ops/s, while patched is anything between
~510k ops/s and ~560k depending on false-sharing (which I only minimally
sanitized). So this is at least 10% if you are unlucky.

The change also facilitated some cosmetic fixes.

It has an unintentional side effect of no longer issuing spurious
idr_preload() around idr_replace().

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 kernel/pid.c | 131 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 85 insertions(+), 46 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index a31771bc89c1..f45ae56db7da 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -159,58 +159,86 @@ void free_pids(struct pid **pids)
 			free_pid(pids[tmp]);
 }
 
-struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
-		      size_t set_tid_size)
+struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
+		      size_t arg_set_tid_size)
 {
+	int set_tid[MAX_PID_NS_LEVEL + 1] = {};
+	int pid_max[MAX_PID_NS_LEVEL + 1] = {};
 	struct pid *pid;
 	enum pid_type type;
 	int i, nr;
 	struct pid_namespace *tmp;
 	struct upid *upid;
 	int retval = -ENOMEM;
+	bool retried_preload;
 
 	/*
-	 * set_tid_size contains the size of the set_tid array. Starting at
+	 * arg_set_tid_size contains the size of the arg_set_tid array. Starting at
 	 * the most nested currently active PID namespace it tells alloc_pid()
 	 * which PID to set for a process in that most nested PID namespace
-	 * up to set_tid_size PID namespaces. It does not have to set the PID
-	 * for a process in all nested PID namespaces but set_tid_size must
+	 * up to arg_set_tid_size PID namespaces. It does not have to set the PID
+	 * for a process in all nested PID namespaces but arg_set_tid_size must
 	 * never be greater than the current ns->level + 1.
 	 */
-	if (set_tid_size > ns->level + 1)
+	if (arg_set_tid_size > ns->level + 1)
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * Prep before we take locks:
+	 *
+	 * 1. allocate and fill in pid struct
+	 */
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
 	if (!pid)
 		return ERR_PTR(retval);
 
-	tmp = ns;
+	get_pid_ns(ns);
 	pid->level = ns->level;
+	refcount_set(&pid->count, 1);
+	spin_lock_init(&pid->lock);
+	for (type = 0; type < PIDTYPE_MAX; ++type)
+		INIT_HLIST_HEAD(&pid->tasks[type]);
+	init_waitqueue_head(&pid->wait_pidfd);
+	INIT_HLIST_HEAD(&pid->inodes);
 
-	for (i = ns->level; i >= 0; i--) {
-		int tid = 0;
-		int pid_max = READ_ONCE(tmp->pid_max);
+	/*
+	 * 2. perm check checkpoint_restore_ns_capable()
+	 *
+	 * This stores found pid_max to make sure the used value is the same should
+	 * later code need it.
+	 */
+	for (tmp = ns, i = ns->level; i >= 0; i--) {
+		pid_max[ns->level - i] = READ_ONCE(tmp->pid_max);
 
-		if (set_tid_size) {
-			tid = set_tid[ns->level - i];
+		if (arg_set_tid_size) {
+			int tid = set_tid[ns->level - i] = arg_set_tid[ns->level - i];
 
 			retval = -EINVAL;
-			if (tid < 1 || tid >= pid_max)
-				goto out_free;
+			if (tid < 1 || tid >= pid_max[ns->level - i])
+				goto out_abort;
 			/*
 			 * Also fail if a PID != 1 is requested and
 			 * no PID 1 exists.
 			 */
 			if (tid != 1 && !tmp->child_reaper)
-				goto out_free;
+				goto out_abort;
 			retval = -EPERM;
 			if (!checkpoint_restore_ns_capable(tmp->user_ns))
-				goto out_free;
-			set_tid_size--;
+				goto out_abort;
+			arg_set_tid_size--;
 		}
 
-		idr_preload(GFP_KERNEL);
-		spin_lock(&pidmap_lock);
+		tmp = tmp->parent;
+	}
+
+	/*
+	 * Prep is done, id allocation goes here:
+	 */
+	retried_preload = false;
+	idr_preload(GFP_KERNEL);
+	spin_lock(&pidmap_lock);
+	for (tmp = ns, i = ns->level; i >= 0;) {
+		int tid = set_tid[ns->level - i];
 
 		if (tid) {
 			nr = idr_alloc(&tmp->idr, NULL, tid,
@@ -220,6 +248,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
 			 * alreay in use. Return EEXIST in that case.
 			 */
 			if (nr == -ENOSPC)
+
 				nr = -EEXIST;
 		} else {
 			int pid_min = 1;
@@ -235,19 +264,42 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
 			 * a partially initialized PID (see below).
 			 */
 			nr = idr_alloc_cyclic(&tmp->idr, NULL, pid_min,
-					      pid_max, GFP_ATOMIC);
+					      pid_max[ns->level - i], GFP_ATOMIC);
+			if (nr == -ENOSPC)
+				nr = -EAGAIN;
 		}
-		spin_unlock(&pidmap_lock);
-		idr_preload_end();
 
-		if (nr < 0) {
-			retval = (nr == -ENOSPC) ? -EAGAIN : nr;
+		if (unlikely(nr < 0)) {
+			/*
+			 * Preload more memory if idr_alloc{,cyclic} failed with -ENOMEM.
+			 *
+			 * The IDR API only allows us to preload memory for one call, while we may end
+			 * up doing several under pidmap_lock with GFP_ATOMIC. The situation may be
+			 * salvageable with GFP_KERNEL. But make sure to not loop indefinitely if preload
+			 * did not help (the routine unfortunately returns void, so we have no idea
+			 * if it got anywhere).
+			 *
+			 * The lock can be safely dropped and picked up as historically pid allocation
+			 * for different namespaces was *not* atomic -- we try to hold on to it the
+			 * entire time only for performance reasons.
+			 */
+			if (nr == -ENOMEM && !retried_preload) {
+				spin_unlock(&pidmap_lock);
+				idr_preload_end();
+				retried_preload = true;
+				idr_preload(GFP_KERNEL);
+				spin_lock(&pidmap_lock);
+				continue;
+			}
+			retval = nr;
 			goto out_free;
 		}
 
 		pid->numbers[i].nr = nr;
 		pid->numbers[i].ns = tmp;
 		tmp = tmp->parent;
+		i--;
+		retried_preload = false;
 	}
 
 	/*
@@ -257,25 +309,15 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
 	 * is what we have exposed to userspace for a long time and it is
 	 * documented behavior for pid namespaces. So we can't easily
 	 * change it even if there were an error code better suited.
+	 *
+	 * This can't be done earlier because we need to preserve other
+	 * error conditions.
 	 */
 	retval = -ENOMEM;
-
-	get_pid_ns(ns);
-	refcount_set(&pid->count, 1);
-	spin_lock_init(&pid->lock);
-	for (type = 0; type < PIDTYPE_MAX; ++type)
-		INIT_HLIST_HEAD(&pid->tasks[type]);
-
-	init_waitqueue_head(&pid->wait_pidfd);
-	INIT_HLIST_HEAD(&pid->inodes);
-
-	upid = pid->numbers + ns->level;
-	idr_preload(GFP_KERNEL);
-	spin_lock(&pidmap_lock);
-	if (!(ns->pid_allocated & PIDNS_ADDING))
-		goto out_unlock;
+	if (unlikely(!(ns->pid_allocated & PIDNS_ADDING)))
+		goto out_free;
 	pidfs_add_pid(pid);
-	for ( ; upid >= pid->numbers; --upid) {
+	for (upid = pid->numbers + ns->level; upid >= pid->numbers; --upid) {
 		/* Make the PID visible to find_pid_ns. */
 		idr_replace(&upid->ns->idr, pid, upid->nr);
 		upid->ns->pid_allocated++;
@@ -286,13 +328,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
 
 	return pid;
 
-out_unlock:
-	spin_unlock(&pidmap_lock);
-	idr_preload_end();
-	put_pid_ns(ns);
-
 out_free:
-	spin_lock(&pidmap_lock);
 	while (++i <= ns->level) {
 		upid = pid->numbers + i;
 		idr_remove(&upid->ns->idr, upid->nr);
@@ -303,7 +339,10 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
 		idr_set_cursor(&ns->idr, 0);
 
 	spin_unlock(&pidmap_lock);
+	idr_preload_end();
 
+out_abort:
+	put_pid_ns(ns);
 	kmem_cache_free(ns->pid_cachep, pid);
 	return ERR_PTR(retval);
 }
-- 
2.48.1


