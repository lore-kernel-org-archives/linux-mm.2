Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11E6BCFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 06:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44D9E6B00AA; Sun, 23 Nov 2025 01:31:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4AE6B00AC; Sun, 23 Nov 2025 01:31:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275EA6B00AE; Sun, 23 Nov 2025 01:31:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09F9A6B00AA
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:31:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A10A3140AEC
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 06:31:15 +0000 (UTC)
X-FDA: 84140899710.01.677B97D
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id B0D5480009
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 06:31:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iEvjj7wi;
	spf=pass (imf30.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763879473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzeVFSUzIu035ZBi7H1TZb6fE+64VF6oJ8fhy8LFjfw=;
	b=Np1y16j+HhlnVwPw35YhSKENvE/ABdZXC3rEBlrtPBvogzsaCKzvdYKsFDrV+6crTFdtfC
	bsWpxC9kuZJ3Glfp22anXozYYVcLnBm/oryGe7xfHdpKgb9JcMcHJcavvUR6RI0LX8cXBP
	T5z+wb3tosa/Oz6LID4uvbadQJRyWDE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iEvjj7wi;
	spf=pass (imf30.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763879473; a=rsa-sha256;
	cv=none;
	b=252zgMYmlQ5WFnygpjsNbYMBIBYGBLc6cltYnOb+ZhcE0vWFVdong344kJHSn5own2iPSV
	C6aGwOJU3y9nfp0DWbXc4kRPZhHOIzuHy35PvIzhBHrTK9T0qGPXIhQosx86WC762dk1NH
	C0UGybioaa/vhoN9cqfB7bDn8tHwtb0=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-640a0812658so5397740a12.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763879472; x=1764484272; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fzeVFSUzIu035ZBi7H1TZb6fE+64VF6oJ8fhy8LFjfw=;
        b=iEvjj7wivjPm5x0hMuYvfhutpXLhb8v8uwXMPhjQAKuF71frzMB1REEi7bBOlZ82WR
         tRy2Ao8+jheLMctnhPpQ2JbfeplmOY8mPVtP6C2QO1c5jmmWBExittWtpakQda53Nefi
         D+RkTgjgZ2Oc1+Kydkhej4yBf9O5Pxvfvce48dB26iZsxD8xCJpOL7MOy+z12ItLFM0w
         cnt6EkuGNLtyN2NwzUuGim8n3e+i7iZV9zmQqazchAjajVo11YR4AcTyrOt17tKdxNEA
         5lWl+zbrflMBIFWlLgNc/aknSybImtx7tqyAwdSG3ZXE3FATVAXcXdJGaeRt3J91oeR8
         7MPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763879472; x=1764484272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fzeVFSUzIu035ZBi7H1TZb6fE+64VF6oJ8fhy8LFjfw=;
        b=Wxhj4c2X5oKADHjwV1isfh95VoSYrDvCR7rSqe9PKmp216F6wCpjidqmY3g/P+QVhT
         vtHYscmID/amdmb8lfap/NpC3BIbBLdyK2h+cqVbmK1byZiguXDTDHbaJWWMXfB8tTT6
         iRZQeEMASqOrlyFLY6SgudSfNaBeq0l3r5f0JNQxQbHDmJQ5gXIlv0LgzbT1KOYwlUcI
         4eIJWCHCtnX0wndSdLwLU500mvdS/FQWy1maO8KDaUvocqpELsljQdSEIUB763haRBUI
         WiGT2u5JEhGgyBW1DXrSgSpWG9e91X6nXJlMAWu8yMoYs9rB8J/ngMeaJBq0QJe9q5DM
         ZjTg==
X-Forwarded-Encrypted: i=1; AJvYcCVgtQf7wqec4RLmCmr1YYiufpxIILsEX7Yvd3Q8PXyYgbcrDxbwZpkCsARWpyC+x+tFM76jqgqZLg==@kvack.org
X-Gm-Message-State: AOJu0YxygqhXCwJ3NiXhHZMdMCEvyYUE17jzmlSTXK7oBcT1EXe1Oy0A
	1Z07RO666QF+an9J0wHpr4Y+FRKhB6LgakSQfWMKiizucDlUQq/XxY5y
X-Gm-Gg: ASbGncspRx2GM023ND91ugNOdynCyRwvXOba4p5WeqMDukdekxU+tiDdh0PegBU9OpS
	02Phfvvd6+pnuyI8B1suSY4KgiAq+iNKa24mDmZh9u3/5Z8/Fcd/xLT6F0riJwi1eqpIB2yVFoD
	6WcU07MZFy1WWlEYcRaJBducIradt5ThIx5XABzPQy8E3FNzfsdyCNsXD+wlEQEOGFWwVNajsTR
	8iBtwANJbF90p+p7jDerpxlrxmDTFU7k0BFX1etoIK7gsNGtylD9b3xTdSYb2TO/CkDgdrB1ZNK
	2wcSy98g86nx+ARfghJ0IjF2PcDWk4BPmbPRb07jSv8jNAxckR989gduUs5dfz25L+cjU8Yy5pw
	uCdA1oYYMGz8N1NroLmlJQjKJTR8IDsVDZp/kR3RTlC5WrAj1lE2uya8EeJxW2NqOeMZGsnOQWW
	1x6ubFutwacwZp38UfnXUaFCLCTJW5564n9oCgr/4IH4pWfUGTP2pqGGRRIMg=
X-Google-Smtp-Source: AGHT+IG3sZ0KYmhLtFy9FEoE/ix2RTytRA6o14m8ny/qtVDn43naSDP8Y8a8Os47AAL1eliyOZzjSw==
X-Received: by 2002:a17:907:940b:b0:b73:806c:bab7 with SMTP id a640c23a62f3a-b76715723ffmr788343166b.19.1763879472026;
        Sat, 22 Nov 2025 22:31:12 -0800 (PST)
Received: from f.. (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cf0435sm929432866b.4.2025.11.22.22.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 22:31:11 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: oleg@redhat.com
Cc: brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH 3/3] pid: only take pidmap_lock once on alloc
Date: Sun, 23 Nov 2025 07:30:54 +0100
Message-ID: <20251123063054.3502938-4-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251123063054.3502938-1-mjguzik@gmail.com>
References: <20251123063054.3502938-1-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B0D5480009
X-Stat-Signature: 16ec87sopc358e6fz68odg7ya9xa3zw1
X-Rspam-User: 
X-HE-Tag: 1763879473-46690
X-HE-Meta: U2FsdGVkX182zIjWzQ3l5J19Ry5c8fNiWC8gkIUoMXjc0TR6Y56D0wSaAToDhAWlUimLmH3W9aNd3F/1NNdBA8zcW2/TLtkJ1EW3JnkdY6NE1/irvHOq3+3bgEOXuybzHn90stXr30ItnJo0CjBlp0zugLX0Reijq62/37Ws64E0MDzLpVOYFSpG8iICc9GvL2rSQ6HKzuhd98jZuKQM0H2yD2D+ioXsPxtun56IyuUVd9FhxrAJNqSfdgtzJ+gW0HVv8eiCubJnhTQ2VO7WVl5646hnPUIblOywM5kxHm5vokn/FoC+YivhD8dE3Kz2UxjrLDQ8Ya38Q25WFAtxkyWcVIC7ibOlhFeQLspTe+IXEaKACk2Ax5qSMrTU6Lw5DpbqYf0uokaiCJ3DOsRRgHYVk9HYUxWjuAdGdKKyXrNsklRlGAuZZueyf2ajHnZdz9O63tkQ/6BHaUddzzQPW2Vmz4f3OxJpNRTIOVX+6/ORndb8fPsX8WwFiN0PbTko4z9Su2TQbd04tItOs7qVK7faRtfoXLsyLgpHVWa4NCJJDgDhyp09n6yXR2kqk19H9PaX9Ib3jm0aO23ar4KqWdSrUsgQAVcnZ1YewW0kyH66iMfDMjdEJVS2lb8OL6i/eAY9RIBYcO1woLARs0j0Vzw8mpQGT4BYHVWcE7K6WBuFaVsXo8FI7nZIs4wSUE9bVbybuQBhcpRJPkdaozAUQd1S3WCNPRRobRrsPMWHEZQNi/qp6wiajUoklFr5z7rt2RPM/r5JvWgi0YozRruTzzs1owlWv0vBdX0qg9+zPh+zNaG6HGUDq++1Q+COFbBA4wjqToQ5fe32t1/W2AhWpjuRepz9c/D/hFN3fBInW/obW4j/t3TOTO3H/YnX7+j4wGPCG4INfr9qj2+Hvg8lBO2HXhaklIra8A4eYx6TIwMeFogqqP9gL4mrNevFv1BlIYm9mMkPYo8eLGj8iSD
 9PZBJ2pq
 FEqwxr3VjQaJYEf8FWXddphylYdmzPIEipvS5l2vddLwCaewUWVlUKZVsm8JkGKvQIeOjqxy7aa9xtthn/jedrHl8uuIcDsqoZg3GHV8TKE38zTGEX59FqQYYl9Yfulfs/Ah5o1P2kk9FMNAfPRPrSvrBA0HSfvr1PV9Dpz/WCrzC95ip3syB7heVj6PxBraGQzzsxUL4ufEGlwZTMtUdDDRuLAOMzAUET+otK5ukZYOem8RmYBUQV9lEIDPcT6h/QSjOtuCc+Ijn/QgT0GLUAdS3ALqiXZGanEOsNCHSLZnOxJJ9xJPLmULXrnjvVQubtMBps8xNSMJaQtomuzPICvwHBvnv/t+3RI4auskAfDlVwLjid3DJqolovpiS4KzeUCEbZbx52Ya1GCqH6Cdowivt1N7ejV/YTouU1VXuT0lz/7lR1vVimi2EGiigjsNwa4RxSN6Ft1Br9qI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reduces contention on the lock during parallel clone/exit.

It remains the primary bottleneck in such a case.

While here tidy up the code.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 kernel/pid.c | 99 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 55 insertions(+), 44 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index a31771bc89c1..6a87ce5a6040 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -159,9 +159,11 @@ void free_pids(struct pid **pids)
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
@@ -170,47 +172,71 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
 	int retval = -ENOMEM;
 
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
+	idr_preload_many(ns->level + 1, GFP_KERNEL);
+	spin_lock(&pidmap_lock);
+	for (tmp = ns, i = ns->level; i >= 0; i--) {
+		int tid = set_tid[ns->level - i];
 
 		if (tid) {
 			nr = idr_alloc(&tmp->idr, NULL, tid,
@@ -235,10 +261,8 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
 			 * a partially initialized PID (see below).
 			 */
 			nr = idr_alloc_cyclic(&tmp->idr, NULL, pid_min,
-					      pid_max, GFP_ATOMIC);
+					      pid_max[ns->level - i], GFP_ATOMIC);
 		}
-		spin_unlock(&pidmap_lock);
-		idr_preload_end();
 
 		if (nr < 0) {
 			retval = (nr == -ENOSPC) ? -EAGAIN : nr;
@@ -257,25 +281,15 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
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
@@ -286,13 +300,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
 
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
@@ -303,7 +311,10 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
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


