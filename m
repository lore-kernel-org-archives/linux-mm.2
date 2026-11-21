Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1215606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 07:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U1e4VmiB
Received: by kanga.kvack.org (Postfix)
	id 950686B00EF; Sat, 21 Nov 2026 02:32:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9A56B05B0; Sat, 21 Nov 2026 02:32:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A25F6B05B1; Sat, 21 Nov 2026 02:32:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 421ED6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 02:32:33 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4F63160382
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:32:32 +0000 (UTC)
X-FDA: 85458308544.11.2FD293F
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0B76840004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:32:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=U1e4VmiB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795246351;
	b=CrpYIErlBmmzXAU1oRNj1t+vsPRojJ/iz9sW+k2B08SQm4NAYyuY9KMYCfqvhO0MaMC/on
	aAuaH1oBAF0X0ZeXAdOweV/sgSOtxIgMX5cbOcWWsNik9jO+zsZVxW7Tp6tYR9D++Pnah7
	jXCGsInvluO5gZeXZnQyvkCwOglQuIY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795246351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vZXEIX5bRG+X47GzywXngypFAMMr6NGpMI+nKBGpwCc=;
	b=irLJluLITD8GGRp6f+H9DsIFY+MvTHFXsug5Cjro2Qy2Rv47EHnbVVOAaakl6wPllNSvu4
	EoHPOMApnxorbqp1Ykhq+hArpuB64xJfevXRfjNTSKTlUpyOqqZjMRK0rf5hIio+B08NVp
	MRCuV9KcwwIzF4dTzfYXBfiwzU9cu/w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=U1e4VmiB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2f048476ab9so10441965ad.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795246350; x=1795851150; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vZXEIX5bRG+X47GzywXngypFAMMr6NGpMI+nKBGpwCc=;
        b=U1e4VmiB0AYlVSPujTJB+S3aq5HiGNoGYBo7jzcAPRLjOExVPWEcu2UJ8J6KRLeInw
         EL1T0eNOTnMgETK8bFSahQSnhs41sFWxWCu5jYZ+c+hnHhpvdio4xxblYUUI6LnRo5ut
         gzOjLDtEemeEERUy07EVB/pTaSEFxeiZxBuX0XdCkfL7imFL/ihcD2G6dxerqPxK+Gfa
         leDG7aaKNyb5efTDkNHBAd+bQPI9fyu0tvDV+wwohMH/oTvys0zVM/PTDbQK6TVW46KV
         w91tyz4Z6mTkLuyl+bIoR5z6AicyE5QjKUcNm7aadLmCF7bylrSJp0toSIj5wnu61sVe
         e8qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795246350; x=1795851150;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vZXEIX5bRG+X47GzywXngypFAMMr6NGpMI+nKBGpwCc=;
        b=h6nzX1rhaQEGG+VmbPbsuDiPdYuYZtvzgoUIfMTPRz2+DyTsUujttovBBX0lDzIKAY
         021QEa4T/+nDDYmXMDZiJ9AlpG+LtRWXrlWF3uQVm+tZTJDosJDrYYtTLJEwfbQ02c76
         p6WiCL965ZKomOayjsKnKIut52TWIEsLSgc1YG03SDJ50ditaYM0oXsYHRDw1YFxOSRG
         k37bZP0zNODN0DfRgToPkQQwvNWktbhI7CXdjlSCRLHalCzMMDcRWnMxXE6jAj7PHcRx
         d8WHh2/BktZg6zj60d5lEHShlMGXB4qHc/hqdY687m1ATNVLdQtdPvjcwGyW9+Y0zMGp
         waNw==
X-Forwarded-Encrypted: i=1; AL+hErGJVGrFYI0u1qZeH0P7qx6ckiQeBHz+9Harrp6b2/9tZHbXIeIRkbm/UnyHGGw+tnzJ8wm82lm9Og==@kvack.org
X-Gm-Message-State: APuU4Z/EdARfEMgZflPNW1CXZ/YevnMCJ72MUgn3xDNlVJd5ca4TfRr3
	qhOBH3Y65TH2ZuX8RJa/KSkvC9xMN1Hs3mvHk6PqaJof4mzSV3nbE0nD
X-Gm-Gg: AZFdTZfpTFWnWtQ7mK/vKZ3H2WEBQ9Ovc8wB+SjUzFprR7zNtA43pjI7Jut05aSOmIj
	FxcJ8cZfWfDsD/Xcr7zHgS8l6ONSCGeOqoeJro5fPHE0kogYaleNRIc0GMEbM0As4tbQ7q3q1lJ
	jPIk4BLIl6+xo9Yy7NJ0j+B+8CPili65fUI5m4w+LCVhuKRy/lOhRZnWgMp7hzTc+SCEmstzX8i
	ZVl2pvvTrR773E3ELZiVu68eCRbaZrJtygwN2RQ9qcfajnSZF6FSZcCvr6PN+bP34JUbBxCRt22
	We2Q9ywHDOtN/YemVBXapq5z6hWycbw5stqKHVuWbW1bXzB9T9AhzqIfYyrzoNuTDj1ahxKyLUJ
	afVwY2Io5d0xHgsYTgXXe1k8T9b7WYAhmaieZYNq7rVgLjGSEoWJ0IyqqfrDXQf5AET+kcZ3DBG
	5H235bOjET+CgpF5SXffzGx5fClG5XHO81muutOb+cHeyRh/zFGXoOdLzAIlQ/Qekdp3Brac2rk
	swK6D4rYuWoPmqasD0xue2tES4IwoC/UEvAhw4Y/aomrAR6PaerIXV9KgZoZ2B5H5TTjOO5Dp6v
	/58XXUT6DqkMXDTRtQiuR+l54mZxdWX5qIxZ+d6DFR6PbA==
X-Received: by 2002:a17:902:dacc:b0:2ef:d54b:fb64 with SMTP id d9443c01a7336-2f03f16ca9amr57805835ad.47.1795246349410;
        Fri, 20 Nov 2026 23:32:29 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0ddf40sm23423465ad.37.2026.11.20.23.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 23:32:28 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp,
	tj@kernel.org,
	mkoutny@suse.com,
	chris@chrisdown.name,
	cui.tao@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH v3] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Sat, 21 Nov 2026 15:32:22 +0800
Message-ID: <20261121073222.834282-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h4bfuzfuzatipdkz4aamd38n6g586yrc
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0B76840004
X-HE-Tag: 1795246350-52238
X-HE-Meta: U2FsdGVkX1/xCjf0TO1H4GZDa19WNvZoe5YRpFkSnvnksxo0JVZ7/AVNiY6g/7HOmtRLKIXU9+cwAibQ402r10jnMTD/jpPLid2BrXfhREVTkeQHRsse7ss5Fwz7lPUc1o0umxItUNs8GF0mgzb1uDd7PUroyAskkUf+M4yEgRbe1NADdUsOWdwYJ9urbMtWcYYtsWBBZ0ZE/MKTlaSRRnTSxRAUEayK0U41CLmDenl/LgSHsPgGqrRk/Oz1mUbTzXxQJKzr6Pj5LIvQPrsZu7BcmqveEjSvDn/HMXQn9oPT49uxWQkLqq6FGPHuR+kYJY+9s/oc8707+rsoUHg77odIeWbni1lz1V/etdL4w5zD2twWE0Fx0BxeqGPoDr/w/a7TufSlR/2XKsBfihHFn5dDOXAKKNuwcBaqNmloD/dhHNGHFEqCPwGAVuv5Z17DS0gVUO6/QWsSdjMedT9NUjqCnLyrkKvR+ERGRF12dAlB9rygd00QfmDkqeCCRBnjrvA+UzrVHjbmBEAKOZSZkWd6aVdm+nJaHrjfv9DmnUWgM+LwPQJhYIEgMAfnheTO/jutbGb+zPD/j16S9AMIHU1Dn5Wu+jCcB+25wcCMCmLwQlhHhOR8lbsL3/I0WA9nqgaqRtCt3VSLIK3YWoj9eFJ1jO1Vtv66TeAesSIoxPHp5ujzKY2t8E0TQ/RGcK+HtDo1DG85S//aoRfHVoypBXXpPUg1ylaOgqnwKKLQbn30MJLy/bPzIAVI7+Xjw1se2eWbNvMJMl+2VgiPPnV5nc+YTf8LzsETgaf/CvxPUpR/VmZElgp0vmwrJIA4OsVLAzAtwOSFSfVKhNzfxAFe6Y3OhL9MyoEaGwV3UQYdXmV8bcEY4n9fMXRxqJ7vRsGTOEU80IHbiCL4BIjkUKOax1f3myJle1RPs+S+xSJETp1WlOT3B/iH9r2KNo0v1sHRq19Iyk27vL2mmbE+IYJ
 rfLpCqaD
 GZ5C6D8xmNjTJGrWtTm1LteGD7Zb7UsFb2FIgO6lSWRoLoGMIyaaVL3A9iImGIfXqdI6n6FrxoUO75WDf2nAnTtkfIzKzW50jFxPs1JOK2JVTdZxMsGWRSh7DMyaxofjPYySt54bS8Qo8ydmoqvUjLkafHXXDCZfn8CnHZbqRT/f3UtPwP3PH/fq4veygfercodUlGUe/vcJxdcaQQ6CyvDTRgq/engL56s1OTneSB1nqVOb348RSGTDvXm37Ep4Aovfjkr9rn6cVooVj5Lcvd4rsP9c3UT+zPs7LnzT46MnsXqXUZTE6HHbdeADHit40njA5tt5knSYMolCOQpvRD1kauGKU3OSjcN3Mni9F9rMdUCA0yMdsHK13FqMH1LBpznFWR+Q9UbqnlUg1I6HRIqWgWJITpU/N2EwOfdAGtaA4KRj1VZyXoxbEKTkSv4jJ79s4wf4Pfre+cOVPf8tu1GFktqQMYq9uJuEBJ6OSMfAUl4BQi20tnlOz0FMzq7UMB6aBFd0123SzU/Ijk91OIsJN4xwAC4vsgshmU2rkLLybHIYZ+6lAzhOF0+7Mc2TRGvBlKA1/CUJYwucrvG8PyMjXbyzSu5yVsAc1WaP1DASCsk40RrW+OQBCbcRzEoxNCTF3NET4GRE3Qws=
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
for it: the first one that is not exiting, the first one that has not
exited yet once the whole group is exiting, or the leader once every
thread has exited, so that an OOM victim stays visible until it is gone,
as the leader does today.  Exiting threads left behind do not count
while the group has live threads elsewhere.

Tested in a VM with memory.max=64M: in each case above the process using
the memory is now killed, and a process whose exited leader was not
moved, or whose leader is alive, is killed as before, with and without
memory.oom.group.

Fixes: f168a9a54ec3 ("mm: memcontrol: use CSS_TASK_ITER_PROCS at mem_cgroup_scan_tasks()")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
v3:
 - Rebase on "mm: memcontrol: don't lose track of exiting OOM victims"
   in mm-hotfixes-unstable and keep CSS_TASK_ITER_WITH_DEAD
 - Let the leader stand for the group once every thread has exited, so
   such a victim stays visible as it does with that patch alone

Moving the exited leader along with its threads came up on v1, and
there has been no answer from the cgroup side.  cgroup.kill had the
same case: da13e0e72a73 ("cgroup: fix cgroup.kill for exited thread
group leader") walks all threads instead of the leaders, and
5f4a3f743acc ("cgroup: don't kill migrated processes through their
exiting threads") then had to keep an exiting thread left behind from
standing for a process that has moved out.  This patch does the same
for the memcg scan; the second case is what the live_elsewhere check
covers.

Retested on mm-hotfixes-unstable 2ba4d2c9ae3c: the cases in the
changelog behave as described, and with the reproducer from the review
of Chris's patch, memory.max=400M, 10 runs, oom_kill is 1 in every run
with and without this patch.

v2: https://lore.kernel.org/all/20261027144016.2582880-1-zhanxusheng1024@gmail.com/
v1: https://lore.kernel.org/all/20261026120248.2188024-1-zhanxusheng1024@gmail.com/

 mm/memcontrol.c | 44 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index afbb638e7e1c..3355341666db 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1426,6 +1426,44 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
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
+	/*
+	 * Once every thread has exited, the leader stands for the group until
+	 * it is gone, as with CSS_TASK_ITER_PROCS.
+	 */
+	if (!dying)
+		return live_elsewhere || !thread_group_leader(task);
+	return live_elsewhere || dying != task;
+}
+
 /**
  * mem_cgroup_scan_tasks - iterate over tasks of a memory cgroup hierarchy
  * @memcg: hierarchy root
@@ -1456,10 +1494,10 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 		 * torn down. Keep it visible so oom_evaluate_task() can
 		 * back off while there's still memory to free.
 		 */
-		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS |
-				    CSS_TASK_ITER_WITH_DEAD, &it);
+		css_task_iter_start(&iter->css, CSS_TASK_ITER_WITH_DEAD, &it);
 		while (!ret && (task = css_task_iter_next(&it))) {
-			ret = fn(task, arg);
+			if (!mem_cgroup_scan_skip(iter, task))
+				ret = fn(task, arg);
 			/* Avoid potential softlockup warning */
 			cond_resched();
 		}

base-commit: 2ba4d2c9ae3cfdad96ee925c92b14d7acd886954
-- 
2.43.0


