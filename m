Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B448CD5BAB
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75B56B0098; Wed, 20 May 2026 10:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4D7B6B0099; Wed, 20 May 2026 10:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A806B009B; Wed, 20 May 2026 10:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C80736B0098
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:43:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9066D140353
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:43:41 +0000 (UTC)
X-FDA: 84788067042.19.1B6DFD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 88EBCC000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:43:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Apkg0+By;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779288219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JuwMdWYx8mUQ3Bq1/uZGlPH7/JSFCs5kyS40Eon7Ojs=;
	b=fFrH/ZhEUqLgi4A9MrYIyiGilJ156GEEnp1PYfzVD8eiiC9bnbvU269gYjggmHHBtiA4c/
	/gXAo0TA13evSSwe6qlgRwCDQSBt05/wIByjGCK81E1o/SQzgFhk24jp/8J0V5YLrVEqtV
	QK1mHa1MJvWLWP7LpmOl3eSl85jmMzQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Apkg0+By;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779288219; a=rsa-sha256;
	cv=none;
	b=QQak4vgANMe0uepgBFFbA7YzdwobNyYYJbKORGjAfHoELyUck3zoFMYKn+b0t7d6euC2lq
	gh/1llUnEeuSBOJigZ33OBekRIZ2VMz8BrENBwFgD8v/XhgJHgKwOU7VrWOTfLspSCtNpm
	BT7xmD8DMnWoUUM7PcFgd8MVxj/A+/8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36E6460008;
	Wed, 20 May 2026 14:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730B01F000E9;
	Wed, 20 May 2026 14:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779288218;
	bh=JuwMdWYx8mUQ3Bq1/uZGlPH7/JSFCs5kyS40Eon7Ojs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Apkg0+BywQ1zA7dsDMxX4JufkreKZbci45h7ws8W8KD3uLbpLQxQG7KJocUsiup9v
	 Ow7Z/2+yoG22MTsKEo9zKVoNQ7N68DC0jce5rZGZWIZ65s0o+RGlYMiWMUEaaONq2w
	 Ad9q26HddAuLPw8Uj/yy8XbbzM0br9Sgl3h+a4mze5SOEoPfzBdm9ddUso/VApNaer
	 7Mg1ok73NczKRALDWtqjjIVhJYHRe6MvdrfsMbBmV5IPqBK4fDT9HND945zI4nD4xo
	 jKp3TIConNXHz/syYD1YsfORTPy6lqcxIlSIpb0KL7CbMAuB9a3D2e36lx/HIO3Tpr
	 sTN+U5cQag/Vw==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 20 May 2026 16:42:58 +0200
Subject: [PATCH RFC v2 5/5] cred: switch dumpability lowering to
 task_exec_state
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-work-task_exec_state-v2-5-9ea88ceb09e6@kernel.org>
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
To: Jann Horn <jannh@google.com>, 
 Linus Torvalds <torvalds@linuxfoundation.org>, 
 Oleg Nesterov <oleg@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, 
 Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=4653; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5QwtkNf3Ik7mQ4Xwwl7cQ9b+5Y6we06j5+VsHvhO9oU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTxnmgW4Zi6qV5xy6x1f41fbXlrUDC59sG8/11KjcviN
 wqVRIkd7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZgItybDf6/KdNG+eTUdflcm
 q7+rOn908pt8tj/CTx+ryzTqqd6+E8DIMPe/6wvX1KKn31XD534rtD9umZuw/FKx0My/Z69Zr5C
 ZyQsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: mnnpmshhf43nqy5w9kzgxbbwujesoqne
X-Rspamd-Queue-Id: 88EBCC000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779288219-753061
X-HE-Meta: U2FsdGVkX19X7fekWsU6OIA7rXuqeLZ3VwvEFuQ67PCpBemB8FzhGX2OQmmTo1t+pJwJxJsYaFzP2O5S6sVPCngTBcOIAhlUgwuzGO1KDweZYb/MEgIcAKUbJQryh2BaKSOb25jPOZpB7Btm+f58y1i4qR8DogVvLlSEPDINn8HRTFlyO6ASeeEbORwi/60YBJjLMsaFwq21oo7A9a4Pw2Prk40hqVvBOhuP0Q05ndvL9ajvwAWOpD13dAn1f7HXjBHoUlWn045yTADOMD5iuACev+4P1seBN5HuwR01dUrBBaqgQL9los1DD7UzBtpOhfi/VGa+9cOIsTPxKIZVm+2Z9EvnqkSUMLFpHiXVNEkSAdL+EbDFjFyWYNbq71BWdwH08RcULZ7nt7JDi/kI82HIMfOxJtZgVbSxxJJblIFFwjNNm6uUFHcEOD27/h9XVShM8YCPWLigBkGjQOtnlIMDzrUJLYI3sXR+JpxMd/3lWm8xp3z8bbGxBl8oBI/am6tWiRroU6K9lCT39EN9pCv/nqdeFfDSygl3NIu0Ac4YNHg1+906UN/I8Uk8iYdVOkqmM7cM5Fov1GfpEpVm284AObQpG8mF4K/cuCDRiu9CB+rkerTLsT1PyZo/M9V3AjdCiygQaU2nbBHODii5+O9cdwwW/CLidNEWNM0qgPyX+OgqRdpiTTfHR4ZIV2VPlpQFVPzUA2g8HGvmm0GCjYyPuyv4ahEgO8qwgGa4hIu920Rbe9A9vKNq1w5bCe3td0M3f9zSuKJvvQvlYyd1fecZxu6n6uWw7MgX53dLmie4OlrXa/I4J+RBMYTgkfpcjoAHux/OUVbyiJqkFBSGatbWVnC7s0jYZPrPCzBV/68Cq17lZhj4FEKKJl/1aVme251EmWCmt2n472EhUHMBnKK4PgSn9sJe456tm/KTqHE4fX7TWsiuBwrqILkEzYQbSd1yz4a9DW7ft7Q6QgL
 hezKGCuP
 GiWKG4xGCiqxcAKcJ1AgRRHm33r8tzBbqv4F2v6tvRnWdUv57XtDc2/UiZahpOuxY0a+v8QVyiYQPRqfLdUhsB0+ellgkYpcvzmKgWW40EITVMaf8aCO1SRBbDcVFFFk3AvIUZ+ew4FX538kc10DQvLjpCtRGULlnJnL8F3bwiF6bovMspvK+fvIcXbLfh8vN+BKrYDdUACTyeW0oJofnxsVYAOHjFXs2333dj68x4VZBRIcfhaicp04mfOxm6ja63p9cw0jOo3Zg+cOI9ujb5Iv+yEzjej2WPjVv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit_creds() has historically called set_dumpable(suid_dumpable) on
every effective uid/gid/cap change, paired with an smp_wmb()/smp_rmb()
fence against __ptrace_may_access() reading the credentials.

Switch the call to task_exec_state_set_dumpable() so the dumpability
lowering targets the new per-task exec_state rather than mm->flags.
Drop the open-coded "if (task->mm)" guard - exec_state is always
allocated for any observable task - and drop the explicit
smp_wmb()/smp_rmb() pair: the new model relies on RCU acquire/release
on the cred pointer.  WRITE_ONCE() on es->dumpable inside
task_exec_state_set_dumpable() happens-before rcu_assign_pointer() of
the new cred in commit_creds(), so a reader that observes the new
cred via rcu_dereference(task->real_cred) in __ptrace_may_access() is
guaranteed to observe the new dumpable via READ_ONCE(es->dumpable).

The same-uid ptrace shedding and /proc visibility behavior that
long-running daemons launched as root (sshd, dbus-daemon, polkitd,
NetworkManager, postfix workers, ...) rely on when they setresuid()
to a service uid is preserved.  No userspace audit cycle is required.

Behavioral change: dumpability propagates across the fork subtree
=================================================================

exec_state is refcount-shared across every clone() variant - thread,
fork(), vfork(), io_uring worker - so this write is observed by every
task still sharing the same exec_state.  Pre-series, set_dumpable()
targeted mm->flags, which was per-mm: shared by CLONE_VM threads but
private to fork()-without-CLONE_VM children.

Under the new model a privilege drop in any task in the subtree
lowers dumpability for the entire subtree, including non-CLONE_VM
siblings.  This matches the model the series codifies: the entire
fork subtree of one execve shares one exec_state, and dumpability is
a property of that domain.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 kernel/cred.c   | 25 ++++++++++++-------------
 kernel/ptrace.c | 10 ----------
 2 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 51c35ac94787..335d8da1c43b 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -378,25 +378,24 @@ int commit_creds(struct cred *new)
 
 	get_cred(new); /* we will require a ref for the subj creds too */
 
-	/* dumpability changes */
+	/*
+	 * Lower dumpability on euid/egid/fsuid/fsgid/capability changes.
+	 * Long-running daemons launched as root (sshd, dbus-daemon,
+	 * polkitd, NetworkManager, postfix workers, ...) rely on this to
+	 * shed /proc visibility and same-uid ptrace exposure of
+	 * root-acquired secrets when they setresuid() to a service uid.
+	 *
+	 * exec_state is shared across the whole fork subtree of the
+	 * establishing execve(), so this write is observed by every task
+	 * still sharing the same exec_state.
+	 */
 	if (!uid_eq(old->euid, new->euid) ||
 	    !gid_eq(old->egid, new->egid) ||
 	    !uid_eq(old->fsuid, new->fsuid) ||
 	    !gid_eq(old->fsgid, new->fsgid) ||
 	    !cred_cap_issubset(old, new)) {
-		if (task->mm)
-			task_exec_state_set_dumpable(suid_dumpable);
+		task_exec_state_set_dumpable(suid_dumpable);
 		task->pdeath_signal = 0;
-		/*
-		 * If a task drops privileges and becomes nondumpable,
-		 * the dumpability change must become visible before
-		 * the credential change; otherwise, a __ptrace_may_access()
-		 * racing with this change may be able to attach to a task it
-		 * shouldn't be able to attach to (as if the task had dropped
-		 * privileges without becoming nondumpable).
-		 * Pairs with a read barrier in __ptrace_may_access().
-		 */
-		smp_wmb();
 	}
 
 	/* alter the thread keyring */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index a4932ef716c6..c340a741e76a 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -356,16 +356,6 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	return -EPERM;
 ok:
 	rcu_read_unlock();
-	/*
-	 * If a task drops privileges and becomes nondumpable (through a syscall
-	 * like setresuid()) while we are trying to access it, we must ensure
-	 * that the dumpability is read after the credentials; otherwise,
-	 * we may be able to attach to a task that we shouldn't be able to
-	 * attach to (as if the task had dropped privileges without becoming
-	 * nondumpable).
-	 * Pairs with a write barrier in commit_creds().
-	 */
-	smp_rmb();
 	if (!task_still_dumpable(task, mode))
 		return -EPERM;
 

-- 
2.47.3


