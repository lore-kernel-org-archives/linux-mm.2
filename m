Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F17B2D3B7D1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 13:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613476B0007; Sat,  6 Dec 2025 08:20:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59D5D6B0008; Sat,  6 Dec 2025 08:20:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C336B000A; Sat,  6 Dec 2025 08:20:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 333C36B0007
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 08:20:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4A77C0536
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 13:20:13 +0000 (UTC)
X-FDA: 84189104706.08.E0FD8CF
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id C5A6B120011
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 13:20:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kar89+kY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765027211; a=rsa-sha256;
	cv=none;
	b=Zm71y/g7YZ+w9TiENDQplG4q1GmpNxeAatzyRcm4u5d5qSFQBQpixdLv5xaGYG6VXLOrsT
	TubxZGOB5kMBY8tJYVgIKiLl42fkQMo3Dlo3B8XRywRBbM3SHsbEGHyMDvSYxeM+18Rawj
	TH5ffLjkV99So/jMJozVbjScjP3o6RQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kar89+kY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765027211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1eBN/3RVqqipQQ2DO5GdrljyMWQyFdnr51hngBzFh80=;
	b=YhD1ppLRMaDGCtkdNrazMoJixh7olWuSpYPTHz5vF1D9DBHejKWxrT4zCcrLFHLaeKb0G6
	dcAun9d6NZlnpAq4CBHGA4ZT2WgnaI2nYwQbe5jM0iL/SjVcdTGxkaPAXg6Jcu8IghTmHY
	MysU4FNL/loF+B8LDiaNIr5liTQzy/M=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4779cc419b2so34163795e9.3
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 05:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765027210; x=1765632010; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1eBN/3RVqqipQQ2DO5GdrljyMWQyFdnr51hngBzFh80=;
        b=Kar89+kYrkATbdk9KNK+ojTpzMjgYktyMCou4I8myxgsVK74Nz/iN8Zn60rbnfOlVF
         NKrL9hcOcKdaYzXSsU9p+VX5pNObLLTrzHtRwxX34vjYDpZieM4cRBdnwZG66zNV3YAr
         yRL91KhzKofohXPMJmDhNLJ8GwL/AEt11uxwlTtmbSZ/uQtiRCc+8rj/NLKcisS+lOZU
         89Z3n/7POfLb6BHumhMPFQx/DAy7urrY8uLrArR6Vz+Gvwx7JQaDUf73jvg/AVJUvnOR
         FWIDTP4Vbf84diR/puwRis+x+S4wzbcHsaTUKp8ei62deazpdrg8HO5ZFaCsQy4hsJ/6
         j2/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765027210; x=1765632010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1eBN/3RVqqipQQ2DO5GdrljyMWQyFdnr51hngBzFh80=;
        b=XZmBtTa33OfSDXco+G35VtMHIy2D5SzBClWAnQgsfSPyyASJRMe8PgfRQcYfWtzKol
         OYufDxPhPjBgBckkue/rf/2hcSRaBeW9AUxuMLKJ/pghS/S5k3Hk4DxnoknGILcf2ZOi
         7K8e2vnwAidmYpr2ZzH7qaEE1FDUjc+F/TPy9AHTfY50MMg9nlS4Q+kPZkdHs0EZScdf
         OY5dYjLNFWK2RTIoVAzzeiAfCv1FzOTwju6GrMrB2SaEt56G5D4BmTTvAEtinJrrAS+G
         KXo8JzPUSOrGkSIhUh6xDeXaIXuTtKm4nZsPhDd9eE8oNCw4f4F3yj3k0z6t1LuYtl7W
         0cRA==
X-Forwarded-Encrypted: i=1; AJvYcCUrTfV8Qk4mDzxRayhgNpyQKY9KVNM0IdGWTRoLPTjSyFhdlZAB1P9r2YVJn6HLF96sICCrWZb6NA==@kvack.org
X-Gm-Message-State: AOJu0Yyn9I8j35cOAIJlWgfjiVtOeO98gMVbFYroA27RGs1isDHe+9PY
	Z3MNZRfp2frJlf1tTvQ/lrs4gDJExh4UkTFDzqDJlio36Zp96qybGZ9H
X-Gm-Gg: ASbGncuKxdReiQ8C/Siwxv10P0HkIH9Phyc35VwcwM6c6HWn3fRMz5grqpzCjF02G5m
	J3uSoESSRdS31JqgGuwZh3XL86qH1duqBQ4Xrgvy1J+9AfeANE4YCFhP6Qe8UBwPTU3HLhMGCds
	imp33TyG60n5/lNB4Zrpih9svbKMjQeRtSXz+NMYmD/6dqMGdOSmdhpwda2prb4ytpaj+LMQL0y
	hf/tJl0OzRfjcwIcawQJMR0lcn9myIF2MVtwuBf+XX+SIGsMfOUh4R9p92XXGnK7uGi6JbFKdF7
	rxTJGH69SLUbM7PvgoLl3+Pbqj33QHwdA8wD7MR07gNSZ92zUasyhW9ckWJAFBMynSrvk6NvHDq
	m0ODEcIsvDtGOjDDuNK8ku+FlMobORsB+uKP9gEYWr9qjZgk2KYrheo7OJ4fJ4o9YYrzMkN8ACl
	sdJDpWLc1ObWfWRBFED04q8nmjfhpN+fCE5n+4dMz+C86Zu0x471pyVaHYUYc=
X-Google-Smtp-Source: AGHT+IFZb5Z0/0DighBaa19FjmR9ROw1yxaOpWzjCzR6imaY0dN30sNYVUMBs3npCCcBE6q66Cd0oA==
X-Received: by 2002:a7b:cd04:0:b0:479:3a88:de5f with SMTP id 5b1f17b1804b1-4793a88de98mr12441875e9.36.1765027210020;
        Sat, 06 Dec 2025 05:20:10 -0800 (PST)
Received: from f.. (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792afd3b31sm110871215e9.0.2025.12.06.05.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Dec 2025 05:20:09 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: oleg@redhat.com
Cc: brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v3 2/2] pid: only take pidmap_lock once on alloc
Date: Sat,  6 Dec 2025 14:19:55 +0100
Message-ID: <20251206131955.780557-3-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251206131955.780557-1-mjguzik@gmail.com>
References: <20251206131955.780557-1-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5A6B120011
X-Stat-Signature: znazykrj4ot83awjxmweh7mqfmjbsjgc
X-Rspam-User: 
X-HE-Tag: 1765027211-137780
X-HE-Meta: U2FsdGVkX19XlTRhTcElTGG+RrYW1MoP+Aof5Hk08rLJ2v0oxiPaULJnPjRC7szb1dlRei+miX4tEcn2FOpB9WSyOhI2pf+wtQ3m+uzP7u+JlgVTF0SqwEX3y0iBooVAMhN9YFOFM+W6anmHMq4Q5kdEcz6D/rJN0sX36yznQmzk2AB0ofbZbl0kAZ609VOQ1EXSPoYojUYBR7C8PisQpKwmyr5KlZbIOlYuKrOzAnvGR36szTjX7rQS2ACGVR120bijItL+U3hr/7e1j7WCBBPlyalKbE0ajqlFyDU+/zZNTxjRmP/3C9RpdnIdvXw2xcm726n014pFfZ/JDn9MiyrLkNCdh3T/BSpS6ZVsMJ/BaRVPlTLCP5HW1wgcL0zoWhkSXcXB8Sz4SAuyIOKnYUMCWU6CFdGSMGL0pU7Upg5mKcT6lLrmzTSRrqUTx3e+lQhGKlbbYlhJd9uJQ4ac/kT+oJx3Df9Ri9rwKTh5kKJagx6hd6pfEnCAHFHcVZ60l4/KEXpT/KcKi2u9iMCgoDnmfbgGLKYvhfmVUasYtGn09F6bEvplyGRijzfsvGWdT6B70dKSmbBxDTi73MPFi7uEvbkyPjw8VH8EQE/M/mE3B7Btl8C8SDxOC5B+e/OWPLSSTKq/aKOvhWrrIkH8jdV8yefVUx1uyAz15NsdPRknV9GEb/08sq16RDnMuVTP1gx57jzXur68YcI7a5FgYwEZPS9sXCxASjSe5tOhhFm69caYepx75uc9DD4xEcdnkiabIFZQyo167agKcYcGaSfR+5ZO80prQyeX7ByjcktEi+K6hs/4VU9V6T1LBbKXlFDgFCVuBdxu0owRSFTZ6F1wzrtNr/iEj/HIOANZ2C1LtOn/a6h5maPJtW1krFUezZlyKwF1pPyMHGhVFe16sIsKEZj763oolSfBSrhesibFm4Q8cA64qCtLp/Qrzmy46Zhfc+ud++2X1+YvQ/k
 mWc8HnCZ
 NFDyzfFGxYjNfVPPIiC+i88TNXmdDtjWwOPANWAD/BV2850wIYc2i+lLR7Jw1p0a2+2Ud9bNl1vN1H5a7Zs7TwPDh58wAAViehbuM2EDey5zndwnV2kjbEW4m870hTZrfg48Rkc14wA1euN6B/6Mg13jSMWVYST0mNZe3c4zLXshWgscDFxrVVXG2fFHbD6m3dCs09/5zzJmPutB1G4WkWOxwojqJp7M9/2EdEEuR+3DmLwbgvH97Cp2Fy/7jmoEVYXrJpfvhbYpUO5pq1w8r26puHQwDsnhb0B4tNFXc5qVGxBIxyuMbqDWqR0GyMaa008Cb6SI1bk5C+RNTfjMmmNJHc8KBqzs8IBX8YH47vuISvpJjd9nzyLgXlq9ADz0T9lLRUtWslMBsZKJjMBrBu/x83e4hVcvtfT7zqdz5UWyQJPTq4DFFm5Z5qX24UHR+xcPYf3hcjFzsAnBNrhxNAEiQgGwenF50pwrUCmgZYgUJRa4oAulCVy673YCthOX1Q0/6/Nnyr7skleVXC4mWuEVwyXn9OGyuRWMy/ohWEnbOzVqRXu/XvtMYCL17bkllPRY/h7NftmltpGHJIrdin7y4MIlr/SH26H24
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

The change also facilitated some cosmetic changes.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 kernel/pid.c | 134 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 86 insertions(+), 48 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index a31771bc89c1..ad4400a9f15f 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -159,65 +159,94 @@ void free_pids(struct pid **pids)
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
+	if (unlikely(arg_set_tid_size > ns->level + 1))
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * Prep before we take locks:
+	 *
+	 * 1. allocate and fill in pid struct
+	 */
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
-	if (!pid)
+	if (unlikely(!pid))
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
+	for (tmp = ns, i = ns->level; i >= 0;) {
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
+		i--;
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
 				       tid + 1, GFP_ATOMIC);
 			/*
 			 * If ENOSPC is returned it means that the PID is
-			 * alreay in use. Return EEXIST in that case.
+			 * already in use. Return EEXIST in that case.
 			 */
 			if (nr == -ENOSPC)
 				nr = -EEXIST;
@@ -235,19 +264,41 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
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
+			 * up doing several with GFP_ATOMIC. It may be the situation is salvageable with
+			 * GFP_KERNEL. But make sure to not loop indefinitely if preload did not help
+			 * (the routine unfortunately returns void, so we have no idea if it got anywhere).
+			 *
+			 * The pidmap lock can be safely dropped and picked up as historically pid allocation
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
@@ -257,25 +308,15 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
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
@@ -286,13 +327,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
 
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
@@ -303,7 +338,10 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *set_tid,
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


