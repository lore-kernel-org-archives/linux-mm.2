Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516BC606A33B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IhOoCzdN
Received: by kanga.kvack.org (Postfix)
	id 439F56B0790; Tue, 27 Oct 2026 10:40:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBD16B0791; Tue, 27 Oct 2026 10:40:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DADD6B0792; Tue, 27 Oct 2026 10:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E64E96B0790
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:40:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED84EA0A72
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:40:27 +0000 (UTC)
X-FDA: 85368666894.05.11E0CFE
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1985C40003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:40:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IhOoCzdN;
	spf=pass (imf04.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793112026;
	b=mUUgXlUjMqZHyinQYjgOLdzExo+1DoKwcqSfdwm3lfu4rfnL/7PrsfJ8e0YlC9Gy+8D4M8
	0VpQGTJ4HfATYTf+IY6BsKGfOUKPWDLcBduNDqTKblxIcspnj7WXFZJwZS8TjOl4SVM0LB
	gZqAl9hgvUf2kM+CftZDaRVxGUIloxU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=IhOoCzdN;
	spf=pass (imf04.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793112026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=T1E/r4jGzpmWVwuykcjDGwY++XCWizWnAfM22Qf0RY4=;
	b=zhwbYfA1jGtvjeIZvv4qxcfrsTsTAEU8dZhOS9RW2tEWqihhPbq8noKcf5/WlAIVz//TLJ
	gHPJKVxHYx9wWEuBzF5ZLA1ZF51eS/V+/hKEKSggNKI/DDX6+IA/mjw8iwyulnEidavEK/
	mNHCvpq/DbicXb1eXK1ZyiRU7GAZw9A=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso611281eec.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793112025; x=1793716825; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T1E/r4jGzpmWVwuykcjDGwY++XCWizWnAfM22Qf0RY4=;
        b=IhOoCzdN9dB/3Ot2Us6zTyWWssFOikaC2OTCNoMZ7oTZQH9NYh1/Jl+itk+E4G6/po
         Uolt+Gsdvz+xbS5/sCEoPemSJsPD/F35gKlZ5uHnrvtHp5p+2Yd9rj2LKNWrsQi5+t57
         3L350hc+J8lI3xVTzPjpwyRthP84RMU3dsvGRXyfPqF5V5T5RJhxrqIH5zuVuRe3+pIm
         HWPnSD073r8LMpBZzqXN/v+i4tLSrQLzGs2pXf9zwZIv38aUgxqeZ8e9Y2Iu0EWuF610
         qWvWq03W4wk08aEXZ4fEJEf5uX9RvFDmcNdhvWLB6sboNmYMnTWZLp7EURs/HSjanMed
         tajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793112025; x=1793716825;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T1E/r4jGzpmWVwuykcjDGwY++XCWizWnAfM22Qf0RY4=;
        b=woadUX/Z4EZaNyvYxo0dfn4n9mBIngnPoDI/S20uhfjiO7pljBMipb+B4pHGhHACOq
         8gO6W4pvUpmz1xm8nm6tay0S3bOybQhR2DlM4c/pZAnn4eWIjTAfiAIdSMPRfkI3i70Q
         3y9RuEX5xt6FoM0ucfrBhRSBzknbcZLBYHKUSaMV/kgv0b1dPC7uaYM6rdEk+ab6Y1My
         +2E7AdaNo7gAbNDv8xn/5OAPhBLmQRSw1Bp763bNNUDh/m0pKfg0OzxR8tN5+xeDdnFL
         jPWLix/cFyiIEhYaozc2aZ0/7ofnqqnFz0WMBQJDZwUzTT/ir3WxM4YAR5bVG7DTz7kN
         k0gA==
X-Forwarded-Encrypted: i=1; AKwUvByTOul+Y+xKEIaRrwh9TWif0ViK9Yi40Y9boUjIPdhkj8hAK+WKbWm9A9PKqWY7P6+63Jyir0T0oA==@kvack.org
X-Gm-Message-State: AFq9FYLnPiXwjCdqDM+Bj3VeUmpEjL2BET7KpiqVr6gZeJYBbi6pTnxE
	8m51gdUr82u3L52clw6FgILLyzonVRgcIv2GW5o/SzqbHglhYAUTWs6kvR6k5g==
X-Gm-Gg: AYBFou2QJSkBh607+sn5J4EvE0qdlp6Dkthimz36NLqaK2Rze5VenTmTN0NLnAOLCye
	DzfLwKhjgXSFIger6BWUHofnuAwsuq98dNcUFs40XamEFyHLScyTklLrL7WVA8CUmv85sL0tpVk
	UkqO+tqwkWkuCLVQ/jtF2pkXGu30BT/kQalxvOE+/awxTMfTwH5RaGEl1Q+cwuZiRWLgww3bR17
	sQif/rcrsGuwprX+5DDpxULX+Mj4KOYcmbgFJiBxLiChi1vEJ+K0+n6hyIvABHWkydLjB3dIbAD
	JvM5OCYPdWXiY9zqXzFT4Z1fPx4fYKapp1+2OEnn94KjKf1DkMvq2A+YMNe7QKSWxNvRVhMTfVw
	TjgSjeZDx23AdPciR65DeScrLXcs9ApagZ/p+xReCcI/qHExXVkM2dCBp3WNBXS47U5S/ja3vY9
	oD0UsQb4ZJx2VVfkmrknLBRldZiwNAgkDeDD9f3eynjuItriWCmh+xtQkgsZYD2gnK1VzAjzSAQ
	xK8BewSAs+vLfFC70ai/ywGO0VzQHGvhbGL42unBQFVrrdCE7YFDMq3TXVsTXFZXyAmsOG98Qd7
	xBwo66QV8Hz2P0vsjA==
X-Received: by 2002:a05:7300:2301:b0:347:8d01:164f with SMTP id 5a478bee46e88-369e84b15ccmr22877138eec.19.1793112023769;
        Tue, 27 Oct 2026 07:40:23 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8db7e73sm34727318eec.20.2026.10.27.07.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 07:40:23 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@I-love.SAKURA.ne.jp,
	tj@kernel.org,
	mkoutny@suse.com,
	cui.tao@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: [PATCH v2] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Tue, 27 Oct 2026 22:40:16 +0800
Message-ID: <20261027144016.2582880-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hxtcou97em8nfqshrb46mhi3gcby8i97
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1985C40003
X-Rspam-User: 
X-HE-Tag: 1793112025-88492
X-HE-Meta: U2FsdGVkX18FJ/zWwul0UfQAqExTpfm5aGN3HLs9cIsJKZeDUR8heP2twgBmkz42IxfFqEiQfRaVKCvZ9O4CKkcmH2eH0bcBU2EEBKVYbuFohf4E53/26DqM7ObRGav0vBI589jTnhucFcyQSaUWo+TnidO/yuw9N32cFb+UI4rkgRZwrjWOtvQd/4tBpDTDIrwCUctlB+wUSWCBLmDJ1fbabDlVYn98s1rAxDb2KUWT0yJlxagMfjSd5nluVg+RcEc1MCPAdCpXOFXSjKUP3uMtRNtx1ZEDKgg0ejpJbd/itTMJi5bYEue/zOFMcT/+QshNNFSvjlpqvLpWZr3fGAi4DnJTW4YMypI4bMGlNC0gLy2IZyoKP/6xOkszezX7YI2uQj4AN2WAS3ktXvuq1ftkoYJeBOTZJ/fLyGnJff9JnFJbxvb9MYDK6CoTMNykbeCqNhJRcrtxdD9ne/CZILzWlORs3INyuWeyFDdh53HHvC3p22BquzKRsQQLXhINjZ71nDGxZnXMFMgGl8L0dSrwhxDWDmuyYdvGsoRsIhR7vI1aE4m1UQKddROhlfHLBU+j4VzwvMfwyxFZ78GAahZ90iOoZIvv/Y/eFZSAJ1T/u3NZPQJOrzqUJ++2T2aPMOmnDwdRVTxyBkfIdYk9R1M+qssOyagVwSQE/jxJs+l6Wgneg+9ns2xz3REE8aHM9cSsph1gCwQ2qXqxB6HQCp7APsatH/Z0yjJjBKEg/o4dtZfGRb1M2WcpSClmt5fkqNEseE49+EwxX58Qpc9Xq5z93sZMeYFoS8fnxLFKMbd0UcRjIaBXd/+UBEpDWmCoEVzTiHycnpoSoWiRhyvqPrRLn8t/rtSduC3h2UkngnY4usiTPiOU1sTtiN+pd+ZIt7Qn9kglVchJUkcCwzXyVses1mB/1G7SMFAjSkIN2E/Nn+uhhudsmGLGsCawUBXJU4AoVhk2ydEMW6D0p//
 +2/sjkny
 YX8T8+LiWWR+dnXvAPxyPGugoRrZ9N96Qsc4cpGrvUWXwuMkWzTeeO/fssD8d6pTweGPqaPJboKZ+AGZCL/geQc/PvwqvHKOKy73moeJMOuK4GoDzAyf+ULWJh9dh7scvj7Atnf3kFrED3DPvlppO78Y2ud4cPnOC2kjbVDhEOOcJpCqlgvBaodVZasqCwyKD1NIuzOygjtk20v6LfFUg2P1INhQ2TTjJZ3a1vRaqR+GRvQ1kq5yLWPnajfQ/tZEmOsdpPT4Kc7VWnFoaT/LhS5eFzbc2bn5TPW20NzgH9GLa6DPGNFQJWwras6di8Y3+bUWY/6BRvWL9Fab4mdkUNUddxFQWiNS1qIlRO5DfbdUtmGZhfThh8yD/23x71bXzfB/DiHDkljvuM0IsdqD19JOYBncd51umiQ4zMW1qRQVBPyeFjx/WMggNLPIJXGIiKFLw+9739s3UU4wQtC2RNFWJZIs+pzgjBkeGJccJjZrMpNyXzHudkrlHMsZ0K2jkrO1ohXvtc6hzkNsebEJxHdihAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

mem_cgroup_scan_tasks() walks with CSS_TASK_ITER_PROCS, so it sees only
thread group leaders, plus a dying leader that still has live threads.
Moving a process whose leader has exited, by writing its PID to
cgroup.procs, moves the live threads but leaves the leader behind, as
cgroup_migrate_add_task() skips exiting tasks.

The destination's OOM killer then cannot see the process.  If it is
alone there, every attempt ends with "Out of memory and no killable
processes..." and the charge is retried indefinitely, and
memory.oom.group kills nothing; otherwise another process is killed in
its place.  The source's OOM killer still finds the leader, reaches the
moved threads' mm through find_lock_task_mm(), and kills a process that
has left the memcg.

Walk all tasks and let one task of each thread group in the memcg stand
for it: the first one that is not exiting, or the first one that has not
exited yet once the whole group is exiting, so that an OOM victim stays
visible until it is gone, as the leader does today.  Exiting threads left
behind do not count while the group has live threads elsewhere.

Tested in a VM with memory.max=64M: in each case above the process using
the memory is now killed, and a process whose exited leader was not
moved, or whose leader is alive, is killed as before, with and without
memory.oom.group.

Fixes: f168a9a54ec3 ("mm: memcontrol: use CSS_TASK_ITER_PROCS at mem_cgroup_scan_tasks()")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
v2:
 - Do the whole check under RCU and walk the group through task->signal;
   v1 read task->group_leader, which a reference on a thread does not pin
 - Keep exiting threads visible while the whole group is exiting, so a
   concurrent scan still finds an OOM victim and aborts
 - Pick the representative among the tasks in the scanned memcg

Tao's Reviewed-by and Tested-by are not carried over, as the check
changed.

The walk visits every thread again, as it did before f168a9a54ec3, but
the check stops at the first thread of a group whose first thread is
live and in the scanned memcg, which is the usual case.  A group can
still be visited twice, or not at all, if the task standing for it
finishes exiting during the scan.

v1: https://lore.kernel.org/all/20261026120248.2188024-1-zhanxusheng1024@gmail.com/

 mm/memcontrol.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4d00748c8a5b..cdb8ca4d4625 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1427,6 +1427,38 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
 						dead_memcg);
 }
 
+/*
+ * Let one task of each thread group in @memcg stand for the group: the
+ * first one that is not exiting, or, once the whole group is exiting, the
+ * first one that has not exited yet, so that an OOM victim stays visible.
+ * The leader is not enough: a group whose leader has exited can be moved
+ * without it.  Exiting threads left behind in @memcg do not count while the
+ * group has live threads elsewhere.
+ */
+static bool mem_cgroup_scan_skip(struct mem_cgroup *memcg,
+				 struct task_struct *task)
+{
+	struct task_struct *t, *dying = NULL;
+	bool live_elsewhere = false;
+
+	guard(rcu)();
+	__for_each_thread(task->signal, t) {
+		bool here;
+
+		if (READ_ONCE(t->exit_state))
+			continue;
+		here = mem_cgroup_from_task(t) == memcg;
+		if (!(READ_ONCE(t->flags) & PF_EXITING)) {
+			if (here)
+				return t != task;
+			live_elsewhere = true;
+		} else if (here && !dying) {
+			dying = t;
+		}
+	}
+	return live_elsewhere || dying != task;
+}
+
 /**
  * mem_cgroup_scan_tasks - iterate over tasks of a memory cgroup hierarchy
  * @memcg: hierarchy root
@@ -1452,9 +1484,10 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 		struct css_task_iter it;
 		struct task_struct *task;
 
-		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
+		css_task_iter_start(&iter->css, 0, &it);
 		while (!ret && (task = css_task_iter_next(&it))) {
-			ret = fn(task, arg);
+			if (!mem_cgroup_scan_skip(iter, task))
+				ret = fn(task, arg);
 			/* Avoid potential softlockup warning */
 			cond_resched();
 		}

base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
-- 
2.43.0


