Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78AE606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lww+V+Uc
Received: by kanga.kvack.org (Postfix)
	id EE7AF6B05BB; Tue,  3 Nov 2026 03:28:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96B46B05C0; Tue,  3 Nov 2026 03:28:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D862B6B05C1; Tue,  3 Nov 2026 03:28:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A71A86B05BB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:28:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB7FD120333
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:28:28 +0000 (UTC)
X-FDA: 85393131096.14.6564794
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 30BBF1A000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:28:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lww+V+Uc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=syysjtWhfrzlfEaldEsTM26pEEl0o8azDUYhhDNzYQk=;
	b=wqOUVcaMKg2dVk+enW2UEyiLVHQjhs/I/xCZlCpBvrLQtvcarClSrb7BPJd0dWxOuMDAIJ
	c9IeHM60nkG+UG2SvsoW5xGJIyy1c98tzEf2MQ67VH/fv6pIloVNkE/jZK//IdCeFK6gcG
	BNjRzRMItM/QxDxyebhzU7oRG9sXH9c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lww+V+Uc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694507;
	b=y9kM81ymwCt2nJf6tPGC47TCNFfbz6jfgo96/XanhRc55mll2J7cjgw987SCbnVFQ5+0i3
	X70ir5g1GNu2mkJeL/1gtG9aW3xwUiJCwZrnsfKlwMehYwM739nvG3N2iMyPZU5vN4Ix8F
	hsXdJqYkeT+CXVaA/mCJUXHcXXAPolw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78B3E43EE6;
	Tue,  3 Nov 2026 08:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B2F1F00A15;
	Tue,  3 Nov 2026 08:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694506;
	bh=syysjtWhfrzlfEaldEsTM26pEEl0o8azDUYhhDNzYQk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Lww+V+Uc0HnDEMnlaPNGK3FmZK2Wnvx+sTOFI0bhrUqedqS0E/A0WpmuXi/Dfb6X5
	 bwKWFdt/R6ToGf3lwLiEyRLjZCzQcisgulT3d0c2vrmJNw7vKlhbX6QAiIIKcm6UEy
	 Fa/xbMH2eLwCFtpeE6fDPW4ceKZeaWhv7vINA+DqB/1Gx+fTixflTB6NGWvcDWGNOB
	 wHsTp6tH8WC46WwQ6qu+a5wSXNryqO6BX/EUINPYInua8QLpUDce6s+KNl3fnaDTOA
	 nOBkdr4yc1IjgCHHU/FZP0CcI74qSbOppjVpZC5skjUQtdpo8rId3LS9ViUZmkR82p
	 mV8vrx9PwAzTA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 03 Nov 2026 08:27:44 +0000
Subject: [PATCH 3/5] locking/rwsem: add down_read[_killable]_nosteal()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-khugepaged-latency-fix-v1-3-a07ab16ac860@kernel.org>
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
In-Reply-To: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Waiman Long <longman@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Yonghong Song <yonghong.song@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=7465; i=ljs@kernel.org;
 h=from:subject:message-id; bh=xtvSRfFhxlbNSRroaUFE9M6KTB+D22EsX7i6cFBQZL0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJezub5/9PB9+MNEfPOmi3q32b+565bpTJjuYhysUMdp
 +n9RX6rOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRlUmMDI8POjeq85rmRQn5
 zgz7E3Ev91+B7sPupdEH2JvUc9bt+cTwv95OP7WoI2nxt1kMizfePH/WbM3nJu32fbecG7bVfbH
 dywwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 30BBF1A000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mhd8mjnp1i6fuhtiob7or3xbj77xnhby
X-HE-Tag: 1793694507-655953
X-HE-Meta: U2FsdGVkX18cTPb+SrOo6y5YmsFEAyOu//ltOC8jWSzWW3mCDuPAh617TM2KtRO3GqyxRo+IRII6VyWQAQXnlhdN6roukhNjcgk+2IcDWEjFnb8rgmC1I6v9U+iZd58tzfkHmsuXRp0j03gDP1vEBD+M4Gx/ITZmPyYyQ/FAhf+cwlqqYNOnTUlfDpsY5Lhx6IZkLxJvoKWMtR7eUonkJoNg6587jzkdQlxxIMiSfkZq0K4GCmPefkI3o6MWIV+FFK7jCIJ+I7+LAamZtY0SyzexUPLW5Yuuwn6OSjHXhL7X0vAm1PQi1GvVf060a4+y3CXQGquQVz6ZQ+AItum+ID59kAtZBfzOnsold/xPJuc8bbKJKRfoo25PWCI+wu/Lshk+QLZ5JDSctyUFFjAHoKu8DrPze8EunugjvAPOlAz64miIAFOSNT3YaV5C+8ETFKZ5ahGtJN9nigbXehfzWVDuKB13C/kfVi1LmHvPtA+m5PQvNgW+OVRrAuuLgd+kH5Ez/+BtMWq71ypZaYJCkxbReOSBSKsXy6WosHXK//VIYSrbGKWHCJ0/HjvijObXRhJB2uMj+im1ZpctHs+vftMU+GFvAVkO/TGkabVSlwmi6MO8b+Hh9cF69nxxp7Lt0Y4zMfKqcif8LguTE12Ldv3/ThEhhRnsjoMqvTSn9o/snaj8pB/7m33qHPK7Y7fAguDTVU8X1/ZN+5IqK/SN02fk4WWknvx0DQB57Vejn9WIsbi4fh+JoARuBNh9RlnuvYovo5Ekruc7bI+nvErqv9QuKIDK856bRa4hatPw4PxPZIGTtwRJFzydW8epKxoyHkDybe7u2ZvcFfdwjbKko/DKRfW/h8bMpo7TJgKz+r8np6pou/Zki86yOr52utwQt20S7F6IVB0QD9spmH/BmQ0KrEV1SJ4zdki52meVOx/Igl4s4AYuEzIYwsPg/b5j3OB8SsGN+AitxXqpl+J
 XKnerfaa
 mXr4Xg/8VLX1ln6bWz+d7VuRqiett2/KCtukpBRTkiNh7jtR1EXR/Cvp9Ye7z592c9cGqi/ypJ/fC0BeW8G2MNLtwYgYxdaO/+Wky+tBhWjAP16nj9041K7/T/KNWexnLdvgFx+LZOCkJUNk/2Iei8TGQc6ptUoZGNqsg3bHQHdVUJW76AWPGOG8YjdEDyDelo6VQgeSC2VcnnA9c10AmAGZYiGlYQ0yLWfTVDlNYgSxR9V/He+crJ7jzbNiPhsNeQ2o4wfXYCq2lyX/xhmwGYQj9rqgRsKsa4+wsQEberOkVhtY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 1a728dff855a ("locking/rwsem: Enable reader optimistic lock
stealing") a sleeping, queued writer whose handoff timeout hasn't expired
can have its lock stolen by a read lock issued before a woken queued writer
was able to acquire a lock.

To avoid write lock starvation, this is only permitted if no other read
locks are held.

However, this behaviour defeats the purpose of a reader periodically
dropping the lock to allow writers in, as doing so only works if the write
lock is acquired first, another read lock is held, or a queued writer's
handoff timeout has expired.

Provide a means of indicating this intent via down_read_nosteal() and
down_read_killable_nosteal().

Implement it by exposing a steal parameter to rwsem_down_read_slowpath(),
update the starvation logic to modify this parameter and modify the steal
branch to check it first.

Also drop the duplicated RWSEM_WRITER_LOCKED check and remove the
goto as the steal condition makes this redundant.

Exposing this function is safe as it only makes the lock more pessimistic,
so does not impact lock contention.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/rwsem.h  |  2 ++
 kernel/locking/rwsem.c | 71 +++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 6a1a7bae5f81..66ab6fad5e24 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -227,8 +227,10 @@ static inline void rwsem_assert_held_write(const struct rw_semaphore *sem)
  * lock for reading
  */
 extern void down_read(struct rw_semaphore *sem) __acquires_shared(sem);
+void down_read_nosteal(struct rw_semaphore *sem) __acquires_shared(sem);
 extern int __must_check down_read_interruptible(struct rw_semaphore *sem) __cond_acquires_shared(0, sem);
 extern int __must_check down_read_killable(struct rw_semaphore *sem) __cond_acquires_shared(0, sem);
+int __must_check down_read_killable_nosteal(struct rw_semaphore *sem) __cond_acquires_shared(0, sem);
 
 /*
  * trylock for reading -- returns 1 if successful, 0 if contention
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index b9c180ac1eee..75fa9fcdee91 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1014,7 +1014,8 @@ static inline void rwsem_cond_wake_waiter(struct rw_semaphore *sem, long count,
  * Wait for the read lock to be granted
  */
 static struct rw_semaphore __sched *
-rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, unsigned int state)
+rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, unsigned int state,
+			 bool steal)
 {
 	long adjustment = -RWSEM_READER_BIAS;
 	long rcnt = (count >> RWSEM_READER_SHIFT);
@@ -1023,17 +1024,16 @@ rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, unsigned int stat
 
 	/*
 	 * To prevent a constant stream of readers from starving a sleeping
-	 * writer, don't attempt optimistic lock stealing if the lock is
-	 * very likely owned by readers.
+	 * writer, only attempt optimistic lock stealing if the lock is
+	 * unlikely to be owned by readers.
 	 */
-	if ((atomic_long_read(&sem->owner) & RWSEM_READER_OWNED) &&
-	    (rcnt > 1) && !(count & RWSEM_WRITER_LOCKED))
-		goto queue;
+	steal &= !(atomic_long_read(&sem->owner) & RWSEM_READER_OWNED) ||
+		rcnt <= 1;
 
 	/*
 	 * Reader optimistic lock stealing.
 	 */
-	if (!(count & (RWSEM_WRITER_LOCKED | RWSEM_FLAG_HANDOFF))) {
+	if (steal && !(count & (RWSEM_WRITER_LOCKED | RWSEM_FLAG_HANDOFF))) {
 		rwsem_set_reader_owned(sem);
 		lockevent_inc(rwsem_rlock_steal);
 
@@ -1052,7 +1052,6 @@ rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, unsigned int stat
 		return sem;
 	}
 
-queue:
 	waiter.task = current;
 	waiter.type = RWSEM_WAITING_FOR_READ;
 	waiter.timeout = jiffies + RWSEM_WAIT_TIMEOUT;
@@ -1281,14 +1280,15 @@ static struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 /*
  * lock for reading
  */
-static __always_inline int __down_read_common(struct rw_semaphore *sem, int state)
+static __always_inline int __down_read_common(struct rw_semaphore *sem, int state,
+					      bool steal)
 {
 	int ret = 0;
 	long count;
 
 	preempt_disable();
 	if (!rwsem_read_trylock(sem, &count)) {
-		if (IS_ERR(rwsem_down_read_slowpath(sem, count, state))) {
+		if (IS_ERR(rwsem_down_read_slowpath(sem, count, state, steal))) {
 			ret = -EINTR;
 			goto out;
 		}
@@ -1301,17 +1301,27 @@ static __always_inline int __down_read_common(struct rw_semaphore *sem, int stat
 
 static __always_inline void __down_read(struct rw_semaphore *sem)
 {
-	__down_read_common(sem, TASK_UNINTERRUPTIBLE);
+	__down_read_common(sem, TASK_UNINTERRUPTIBLE, true);
+}
+
+static __always_inline void __down_read_nosteal(struct rw_semaphore *sem)
+{
+	__down_read_common(sem, TASK_UNINTERRUPTIBLE, false);
 }
 
 static __always_inline int __down_read_interruptible(struct rw_semaphore *sem)
 {
-	return __down_read_common(sem, TASK_INTERRUPTIBLE);
+	return __down_read_common(sem, TASK_INTERRUPTIBLE, true);
 }
 
 static __always_inline int __down_read_killable(struct rw_semaphore *sem)
 {
-	return __down_read_common(sem, TASK_KILLABLE);
+	return __down_read_common(sem, TASK_KILLABLE, true);
+}
+
+static __always_inline int __down_read_killable_nosteal(struct rw_semaphore *sem)
+{
+	return __down_read_common(sem, TASK_KILLABLE, false);
 }
 
 static inline int __down_read_trylock(struct rw_semaphore *sem)
@@ -1502,6 +1512,11 @@ static inline void __down_read(struct rw_semaphore *sem)
 	rwbase_read_lock(&sem->rwbase, TASK_UNINTERRUPTIBLE);
 }
 
+static inline void __down_read_nosteal(struct rw_semaphore *sem)
+{
+	__down_read(sem);
+}
+
 static inline int __down_read_interruptible(struct rw_semaphore *sem)
 {
 	return rwbase_read_lock(&sem->rwbase, TASK_INTERRUPTIBLE);
@@ -1512,6 +1527,11 @@ static inline int __down_read_killable(struct rw_semaphore *sem)
 	return rwbase_read_lock(&sem->rwbase, TASK_KILLABLE);
 }
 
+static inline int __down_read_killable_nosteal(struct rw_semaphore *sem)
+{
+	return __down_read_killable(sem);
+}
+
 static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
 	return rwbase_read_trylock(&sem->rwbase);
@@ -1577,6 +1597,16 @@ void __sched down_read(struct rw_semaphore *sem)
 }
 EXPORT_SYMBOL(down_read);
 
+void __sched down_read_nosteal(struct rw_semaphore *sem)
+	__no_context_analysis
+{
+	might_sleep();
+	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
+
+	LOCK_CONTENDED(sem, __down_read_trylock, __down_read_nosteal);
+}
+EXPORT_SYMBOL(down_read_nosteal);
+
 int __sched down_read_interruptible(struct rw_semaphore *sem)
 	__no_context_analysis
 {
@@ -1607,6 +1637,21 @@ int __sched down_read_killable(struct rw_semaphore *sem)
 }
 EXPORT_SYMBOL(down_read_killable);
 
+int __sched down_read_killable_nosteal(struct rw_semaphore *sem)
+	__no_context_analysis
+{
+	might_sleep();
+	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
+
+	if (LOCK_CONTENDED_RETURN(sem, __down_read_trylock, __down_read_killable_nosteal)) {
+		rwsem_release(&sem->dep_map, _RET_IP_);
+		return -EINTR;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(down_read_killable_nosteal);
+
 /*
  * trylock for reading -- returns 1 if successful, 0 if contention
  */

-- 
2.56.0


