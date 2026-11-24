Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFE4606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 03:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JZhKXAv5
Received: by kanga.kvack.org (Postfix)
	id CCA876B05D7; Mon, 23 Nov 2026 22:36:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA22C6B05D9; Mon, 23 Nov 2026 22:36:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8F06B05DA; Mon, 23 Nov 2026 22:36:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 850916B05D7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:36:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0B8CA0AC5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:36:01 +0000 (UTC)
X-FDA: 85468598922.11.7A756E4
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0AF15A0005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:35:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JZhKXAv5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795491360;
	b=mkIzuan+DH9b2N/pbJRKidv+X+hSbudL4k7VzOrQfAXzgwqrt7vUD6ANnFAw7m9TueoA7k
	qz1CFQXwanKM3X5NI5z/rb8lnkJGSY+5fnboEgDVqCa8alHEGkxJOIr24ZZdeefHVWTWvq
	6OSJAGwcFQbKF5F4MN5iVs97nWbtyLY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795491360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gjs/pNnX4PrWhE30CjXJcWso+ZUlIS9eqBqYEHwKrqU=;
	b=A9wHbrqsdPA2MOXsCi/V6J6aptEP8V4JfXusez8bGzsEl7m0opCOpY2qEhKZgei1OAvvQo
	ghNGKJeoQ6X7AXmEJmM7VNYfQb7GK0O5vMJuyGOjHIqSFCuK/CF8k3jnKE63nvWUJmjFZY
	6C9B2iJhiktK6AUSnYVYWSMQGkQwI1E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JZhKXAv5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b09a83d12aso2900289a91.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795491359; x=1796096159; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gjs/pNnX4PrWhE30CjXJcWso+ZUlIS9eqBqYEHwKrqU=;
        b=JZhKXAv5jHYgAu77c6kNjbItdW/c4FZlgJm3+9k4aLjTi7Wqir0IMapVueysFIjpzV
         5o4ZTCxNDq1qTbfXrv38GVRLWKe4Acja1fqDp+/ZktiNTSc6vjYhtYBbMxItdZ+MKaoX
         a+Y9/V3ZiR04Ao51CjRoFDv/fgxFR62OiotvTjhauZI3rBI2CZ0tPjasM9iZvawWwssE
         mt5fKzTb/2JLhM5HSC4M16Krn26BKf9lFz2AH2FvZFc2PfBV9IHLQK8Tbavq5zzFimLK
         WS22qMdqULLwGIOZyJdIPTs+x5CeBDX/iaTf/i99njEosxOeoOgcpmX+68+v9Gn29Qto
         wRmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795491359; x=1796096159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gjs/pNnX4PrWhE30CjXJcWso+ZUlIS9eqBqYEHwKrqU=;
        b=thKJstEtEZTPutL6Fhv6g79tipEOg3GCGWBFCAt+JKDbGDarZ07S4N8SGpBaksPBRA
         AhapRJ10XSlE5xPmY5XDKlAn9WpSK27IbA0BekqgeJDYou/n/RbEzlv3C/sonqRMGedq
         UxdBdZYWySpeLn2HuNeNF2vllTiY05wtq1agOxL1duLJMOxpT650yYmDUhZmgfCX5k9h
         pNGzbLoPVso+XTD7BWVXsBVLlKF4salfZVS3ANwlfsBNY/OJ1WMxltlD0hMObHQhnFCa
         ird7E4P+y/dIPrU4Dvnu85zAGPOd/SabUUyrENAYFzJofuqLjy9fAG2G7ofNbm/0jFVD
         G/uA==
X-Forwarded-Encrypted: i=1; AL+hErHcCR/0drSkIAueizG0jMQoICbEtmIi/R1H4J1uTTUyZF841T+lMCOTkk2kkuIQX14kDBfOGq/3VA==@kvack.org
X-Gm-Message-State: APuU4Z8pQCEVqBJN+9rSTSzE7/fSQ9NT5f0hzWiR0hqIrxlO2PanmHXk
	vHfpRFqBIytLNdMmhr8c6AxAjBaH+TmvFCHOLGdtq+hNYTMCR2y7zhsr
X-Gm-Gg: AZFdTZdnVerz74BoYnWFSZ5xmkjUsOIJukvfrd55rnVy86c2WgvqS0LSZjS5zVClMo9
	YxvYEIb97nD4TZb2mJLs/BIlb3mXYkReyHnW8MDnA9VfrWD8zB5+Zh4lWeqT4CqAnJ/xESyKHTE
	ah9LaQ/0XGc37EsGpvjH0P7Cjt+CwrflzMlA+VyOaXS9CccpOTcTV+/eUEJ/gh4kNcdgWJTwpwa
	bENR46bNnzPSv38DRZThX/PYkaLdb3y9EfJtuVDXV+DGSHm6CMEUTovfoYZ3wk8Uwr1fY9i58CW
	QIKkt4mcZWnvKjRjXdmA2TrcjBHg1rlVn2RDPCovskAW8BBYCEht/PpsfiOhwgqwqKJVbq8IKy1
	qRFqVlk9klGG8xeD6Ogtgwft1XDfAYfe1oRiw6eMDYnRSY9H2jE4sTQGIKSTk2ouk5n0aAyfvAQ
	H4F6kjptljblHmGMab3xdoIuvIGrRAXF8ko1PZPpZPqxfweksKYqkOvrRhYQ6HAguhE9gCknfIa
	uCY4JXtiEcwd16aSusm6bmC1TtmpZf5rM4PwDzJQ2ZAfVZw0k1ihaCe+cZym5IlhVQuk6V4isXL
	6I5R/1iu/452XYwWcwncEvmA6R8y5RW3ILVziATE3cu4YQ==
X-Received: by 2002:a17:90a:e70c:b0:3ac:9df3:6b07 with SMTP id 98e67ed59e1d1-3b41c9234b2mr13368244a91.24.1795491358812;
        Mon, 23 Nov 2026 19:35:58 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecb486sm23397939a91.16.2026.11.23.19.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 19:35:58 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: tj@kernel.org
Cc: hannes@cmpxchg.org,
	mkoutny@suse.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	kolyshkin@gmail.com,
	chris@chrisdown.name,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: [PATCH 1/2] cgroup: list a process whose leader has exited where its threads are
Date: Tue, 24 Nov 2026 11:35:46 +0800
Message-ID: <20261124033547.2373352-2-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124033547.2373352-1-zhanxusheng1024@gmail.com>
References: <20261124033547.2373352-1-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 0AF15A0005
X-Stat-Signature: q1z6ddac395kwhdxcqs5dz1hotikq5zm
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795491359-226769
X-HE-Meta: U2FsdGVkX19KkTKKZXZPoVpoy6RT26KXfiBTauEWNBn9iLRP3vPxDrgl9FfobYATEv/q6fhktFbquGGnWyTJzGhcqb/Qc3oV2Pfp8JDNBAMfbYJ2uOhrOHFSVJq9tcg5/m62IH00zkb6eIOLuKD6XC1ALomimnUBY8unW9eT65lZwnfuDgl3omzGTZfHFE/VsI6U9kw5r5lgzUYgir+kSFb6oVJuDFzumLghA109u3twjXr1ssvqcQfZdF8zXo1STjdTfEWWNzGx+RnBFxoki9y2PNh1SlOB7InuO2HLH8H84tDOSdm5M/16AFt8yPnoi5NadKGelZ+RFRXiIKhpofcRcpO13WzGi9pyIR8HJ75mnPCfoS318Jb5GwXiHjfStZcmqqyCabxjGAsIcL0sqqmyvZ1PJnC2ft9ULudm5fUeG5XFwfFUq9ml2AxoclvBkWTGH2iMUlSbQ2R6KxMi6ye18rRdVV5G0GyOgPhDPPA48WtaZbzcGmOSz1nCe/FYqHwB9j19kdhGLlpMuPXCbt0pOqehIIUt9vohjIpurnWhRfH1Lfrm0pkA9UC7hqDl3dUP679e331+jvx1Pn1Y+2W7u5baJQxY4geYuY1lUffaJgiq/LUvNQqZn1NiMLmMkyC7q7sqKZ5buvoyi37g5ONuBOScSIcm9UNN6HhaAuIOwx40DnDoCnTf51wYga6DoUMsLruAnv8H8pb8Us4pNNsp9HoX7MSJBPzOg+m50mIGs+XTNxCLAL1c3VrdKEXb5udIEDIXymuMI34Nk7DYCfsop5vZGu4uAN+EMVshJc8AlWO1sfhk7UrNmKnjmotL0dGMVKeOAS8DuySvdLSKO+br1V77rdMFe9abRJyTT0ZbKALy8Ew45gbY/zG1iPqRpJsiE/2Wa4izttxG0WEcp5xuuDHwuCf4MIHs0/u6sDzvjkjKYZDYjA/uxS4pHa1unDKwfsb69eP6HDK7W2m
 UEU0sm1s
 TiZ0YVJUR0nT18R1dPFuSzEJzmlecyZ8TPvSXkGz1cruujqkEyKST7YJzcudw0Z9zgNVzoA8I7gWWupoiu8F0silrugK3Y683vsUSiDbuvbZFI66C0Flfz5ZrM0V2wpxPmLzD/l0ier97VPy1dfKTfR8kTwkhDS6Tw0khHoMOiVH3IDh/7/z/Pj2A1439vXKxaQfqNm2R1nbWFzK0K8XICot/kYiALd104LxWpG30h3zda1tF6O7ngalnEBIchdfy57QGbfgJnvjLXzxjlTXFdehCOi5y5cv9hHyx33o63fdJd3TZuBDKStpT+j/BCWtZOWAXu3eXo3OfmiteIev2laKGpD3keLuraRhGnvMoiUHAjVUTRmE7tMGh3z1lCwKGlb+hqDoOSYMA3sWFVrXEvwTbbFQxAhbIdV0DVyRaBomrQJ+XuePtqqTm1oHgQ5O3gfIxrYoIdlgpE2BCGJl9ykEte2GlinHN19nrY1sTG3X+8oKZebYNLyYZY0sJtwIzBO1TI5WrdbpdmEhco7QRM3AW2ZHVAiz/i3trkhWP+vw141m3poGNWxV3cMrN1C1FN0Q02CTLDo7YxYR3t0XxozGpwvqySRxq+EF5m2P8RsRVo0w9WX0oYG+e77FM9yzkR9na2fIu5QzIgKNUTji8FtsNcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

A cgroup.procs migration skips exiting tasks.  If the thread group
leader of a process has exited, writing the ID of one of its threads to
cgroup.procs moves the live threads and leaves the zombie leader behind.
CSS_TASK_ITER_PROCS walks only visit leaders, so the process stays in
the old cgroup's cgroup.procs and is missing from the new one's.

With a process whose main thread has called pthread_exit() and whose
other threads allocate memory:

  # echo $TID > dst/cgroup.procs
  # cat src/cgroup.procs
  $PID
  # cat dst/cgroup.procs
  #

When dst reaches memory.max, the memcg OOM killer finds no process in
dst and kills nothing: 5453 oom events and no oom_kill in 10 seconds.
An OOM in src picks the moved process instead.

Keep the leader on its css_set, and make PROCS walks visit it at the
first live thread of the process when that thread is on another
css_set.  Update test_cgkill_exited_leader_migrated, which expected
dst's cgroup.procs to be empty.

Suggested-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/all/305c5803b904a57c188b505d6ed9e1e4@kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 include/linux/sched.h                      |  2 +
 kernel/cgroup/cgroup.c                     | 55 +++++++++++++++++++++-
 tools/testing/selftests/cgroup/test_kill.c | 16 +++++--
 3 files changed, 66 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8b3d47a325cc..04fe82aea0e1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1352,6 +1352,8 @@ struct task_struct {
 	struct css_set __rcu		*cgroups;
 	/* cg_list protected by css_set_lock and tsk->alloc_lock: */
 	struct list_head		cg_list;
+	/* exiting leader left behind by a cgroup.procs migration */
+	bool				cg_leader_left;
 #ifdef CONFIG_PREEMPT_RT
 	struct llist_node		cg_dead_lnode;
 #endif	/* CONFIG_PREEMPT_RT */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b3657e72db99..ab442f94e29d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3081,6 +3081,9 @@ int cgroup_migrate(struct task_struct *leader, bool threadgroup,
 		if (!threadgroup)
 			break;
 	} while_each_thread(leader, task);
+	/* see procs_live_thread() */
+	if (threadgroup && (leader->flags & PF_EXITING))
+		WRITE_ONCE(leader->cg_leader_left, true);
 	spin_unlock_irq(&css_set_lock);
 
 	return cgroup_migrate_execute(mgctx);
@@ -5200,6 +5203,40 @@ static void css_task_iter_skip(struct css_task_iter *it,
 	}
 }
 
+/*
+ * A cgroup.procs migration skips a leader that is already exiting, as the
+ * controllers don't deal with exiting tasks, so the leader stays on its
+ * css_set while the rest of its process moves.  CSS_TASK_ITER_PROCS walks
+ * visit such a leader at the first live thread of the process instead, if
+ * that thread is on a different css_set.
+ *
+ * PF_EXITING isn't set under css_set_lock, so a walk that races with a
+ * thread starting to exit may visit the process twice or miss it.
+ */
+static struct task_struct *procs_live_thread(struct task_struct *leader)
+{
+	struct task_struct *t;
+
+	if (!READ_ONCE(leader->cg_leader_left))
+		return leader;
+
+	for_each_thread(leader, t) {
+		if (!(t->flags & PF_EXITING)) {
+			if (task_css_set(t) == task_css_set(leader))
+				return leader;
+			return t;
+		}
+	}
+	return leader;
+}
+
+static bool procs_stand_in(struct task_struct *task)
+{
+	struct task_struct *leader = task->group_leader;
+
+	return leader != task && procs_live_thread(leader) == task;
+}
+
 static void css_task_iter_advance(struct css_task_iter *it)
 {
 	struct task_struct *task;
@@ -5246,8 +5283,18 @@ static void css_task_iter_advance(struct css_task_iter *it)
 		goto repeat;
 
 	if (it->flags & CSS_TASK_ITER_PROCS) {
-		/* if PROCS, skip over tasks which aren't group leaders */
-		if (!thread_group_leader(task))
+		/*
+		 * If PROCS, skip over tasks which aren't group leaders, except
+		 * for the thread a left-behind leader is visited at.
+		 */
+		if (!thread_group_leader(task)) {
+			if (!procs_stand_in(task))
+				goto repeat;
+			return;
+		}
+
+		/* and leaders visited at another thread */
+		if (procs_live_thread(task) != task)
 			goto repeat;
 
 		/* and dying leaders w/o live member threads */
@@ -5322,6 +5369,9 @@ struct task_struct *css_task_iter_next(struct css_task_iter *it)
 	while (it->task_pos && !it->cur_task) {
 		it->cur_task = list_entry(it->task_pos, struct task_struct,
 					  cg_list);
+		/* a left-behind leader is visited at a live thread */
+		if (it->flags & CSS_TASK_ITER_PROCS)
+			it->cur_task = it->cur_task->group_leader;
 		/* a task on dying_tasks with zero refcount is only valid for
 		 * RCU readers, not even interesting for
 		 * CSS_TASK_ITER_WITH_DEAD, find another one */
@@ -6841,6 +6891,7 @@ void cgroup_fork(struct task_struct *child)
 {
 	RCU_INIT_POINTER(child->cgroups, &init_css_set);
 	INIT_LIST_HEAD(&child->cg_list);
+	child->cg_leader_left = false;
 }
 
 /**
diff --git a/tools/testing/selftests/cgroup/test_kill.c b/tools/testing/selftests/cgroup/test_kill.c
index 756bc7193d4b..102255b9559a 100644
--- a/tools/testing/selftests/cgroup/test_kill.c
+++ b/tools/testing/selftests/cgroup/test_kill.c
@@ -406,15 +406,16 @@ static int test_cgkill_exited_leader(const char *root)
 }
 
 /*
- * Test that cgroup.kill kills the threads of a process that were migrated
- * to the cgroup after their thread group leader had exited, and so are
- * not listed in its cgroup.procs.
+ * Test that a process whose thread group leader has exited is listed in the
+ * cgroup.procs of the cgroup its threads were migrated to, and that
+ * cgroup.kill there kills it.
  */
 static int test_cgkill_exited_leader_migrated(const char *root)
 {
 	char *parent = NULL, *src = NULL, *dst = NULL;
 	int ret = KSFT_FAIL;
 	pid_t pid = -ESRCH;
+	char buf[32];
 
 	parent = cg_name(root, "cg_test_exited_leader_migrated");
 	if (!parent)
@@ -438,12 +439,17 @@ static int test_cgkill_exited_leader_migrated(const char *root)
 	if (wait_for_zombie_leader(pid))
 		goto cleanup;
 
-	/* The exiting leader stays behind, only the live thread is moved. */
+	/*
+	 * Only the live thread is moved, but the process is listed where the
+	 * thread is.
+	 */
 	if (cg_enter(dst, pid))
 		goto cleanup;
 
+	snprintf(buf, sizeof(buf), "%d\n", pid);
 	if (cg_read_strcmp(dst, "cgroup.events", "populated 1\n") ||
-	    cg_read_strcmp(dst, "cgroup.procs", ""))
+	    cg_read_strcmp(dst, "cgroup.procs", buf) ||
+	    cg_read_strcmp(src, "cgroup.procs", ""))
 		goto cleanup;
 
 	if (cg_write(dst, "cgroup.kill", "1"))
-- 
2.43.0


