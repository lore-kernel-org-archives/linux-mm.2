Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF8160A262F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aSRdX3oI
Received: by kanga.kvack.org (Postfix)
	id 1D5D56B05B0; Mon, 26 Oct 2026 08:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186956B05B1; Mon, 26 Oct 2026 08:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075E06B05B2; Mon, 26 Oct 2026 08:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D29976B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:02:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74A2C1A070F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:02:59 +0000 (UTC)
X-FDA: 85364641278.11.29F0143
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id C093B20003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:02:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aSRdX3oI;
	spf=pass (imf13.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793016177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RFJJleyh4O8FR2L0iIk2GYhVD/sdkcXc7KlKPVTmZgw=;
	b=q46JCxbzcTd2CCSfctY2lvXUjo6H9xnEtVpcmOcWFDh7sB1A9vsjeWs6cM1A/zyXi428qn
	HiL6n8rM9lCO9qK6L6W4WijwOqckDpekh6+8PfCQfASX+u2eDyX3az9kJaNx/efX2Ro2US
	PwwB0geYrGg5BZIQWIAGdOpOM1QD13c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793016177;
	b=jZC70xs1KqZDWkx7nVeytwfToeqZ7cas6VZURIkUjx0MHv3cFwjuzfwJ2DTwyfty8GdOEu
	foAlrlFk4qUTcQqBPzcXahWQ/f0RDehj0SnapQe2gQepBxEsRVq43TP4WIUjD3W7sFF0+P
	NMMFybSzib3VNDCIag1mc68P6x2RVXo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aSRdX3oI;
	spf=pass (imf13.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ac77270fbfso1444229a91.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793016176; x=1793620976; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RFJJleyh4O8FR2L0iIk2GYhVD/sdkcXc7KlKPVTmZgw=;
        b=aSRdX3oIW3Lu55I45cCyCN6+kLyBWRM5NesGwl5nQeX/SvYnuo2ZiLlVBX5XNU/3dE
         6aligXRH3zvmJhR2fE9BhDGeePlqvcmPk9+roOmUxbkaUJbmalwLjQeasImL5E+cKlCV
         gBNX9j0kdvOk0Fhh6UOODMjW4zS835+8LsT2jVCDg/PDVLqabpmTc9JDNrRJ5rUHrWYR
         PlfSnDfUj+9uGgziKs1cNDCdJWeVNsYSl/r6pqABjc6SKnl4rVeUY1eI78RqT1569X1w
         qr5zI37zHNLBsu+l8kH7UuL9Y2jsRvb9dKFvZ+qw3kg0FHSut1sbxqC3Cr1e4nZCIIXH
         ku+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793016177; x=1793620977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RFJJleyh4O8FR2L0iIk2GYhVD/sdkcXc7KlKPVTmZgw=;
        b=ehvkCxJ4DVmDAtW7EPedyFf/kwo5f4ApOxvvRQmrB32iTJPs4X4l+jn1IguFTb5MJf
         5oxne0hxbP7SJaiMu/+YfR4aIHTiDNrfL5ZobSltF/h/X1A/m8eM+R2ct2SAa73MfAJQ
         iHmeN8rX1kJQneT96yQyJTekgEBky4Szb3kEYu1S2CdH6qbbdxaox0IYV1NczJdeXgYC
         vfGN2tlU8zGmEgQH3uduvGORKN1XezQd8dJ9u9A26xl9ZdpRN9YHnpz80F2t63Ol5dDa
         rNG/8+oU2w5etOpbsY2yiMpq5SzBoAtvxWUwjkoiB6Z+TLSksCP6kTT2gXTAHbLl1Vzz
         yEqw==
X-Forwarded-Encrypted: i=1; AKwUvBywiSmc7/eo4GJZiGpsWLBYw642ipnBF/LjG3/pkNHTgEzgh/+J+31hYzjxLkS/ph5zZtYILV/smg==@kvack.org
X-Gm-Message-State: AFq9FYIjcJsd3tniywmT9sD07AmoCfZs3lICOInN+uddryaNXucjCKhH
	Tes5dl+3lOPiX6D8ffgj7/ZMpi5FZwy7QlnQsTPA+rZGL0RHupoOR0u+
X-Gm-Gg: AYBFou3NmcGhM4chRelnJ4jBDJcK5ZcFS68TV2F5qjlA1bug2fk1Oa1YiWimHWIv9j+
	666Smb8ppjjsgyuIRDv9kYNwAkenVZ4X0S5iw4AeFPFny8TUJIDiFodhl6Lbj5efLWgAF0SCw8t
	AgUe+68ceyr5/kbvAzYkWuM5sr+6hLBVGEEJZKqb0craR4Dcb16QdwQAAnN/ixUUauKImnQIeK2
	1/AquYEWHL80cJLKaM7BCA9bdZ/GmOYGD6Z1JO4utSkZgAuPdfhRr4d9i8cAiNtl/gG5RXpSWo/
	y496hmp5E8RW+tHWDjzft1ecCSc5H+9s/iPYOat9jSsJsWYlLm2VTyJm4jzbbeQH1K7bHQNnhDW
	fMql01EYOfx96mTh7i7pjo7QOUCJxmkTFKbdi/1GVqpt+1w1t744aIuZYaBgSftXHc1d+GYdIx9
	7u0Whz8nJzeS1sWQmcPpzjYV4DB5xhOysj6Qevlt/Wl9Vvi+eJbK6icQ2bPgJAQSiHn7QwC7gDq
	7nDJOvUfafoD35D4wSybUh7flvDzYYPXHv7YrpLBxIi9S3wga7VzZDBn3mAfj4zEqNerbcb
X-Received: by 2002:a17:90b:164a:b0:3a4:ba6b:cc24 with SMTP id 98e67ed59e1d1-3adeb137823mr4733512a91.58.1793016176366;
        Mon, 26 Oct 2026 05:02:56 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adeba47266sm4750299a91.1.2026.10.26.05.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 05:02:55 -0700 (PDT)
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
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: [PATCH] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Mon, 26 Oct 2026 20:02:48 +0800
Message-ID: <20261026120248.2188024-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C093B20003
X-Stat-Signature: zkwcjnqkxzqib3ej9mn9n99u48ntwa5w
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793016177-146779
X-HE-Meta: U2FsdGVkX18I6rWuqlcnB433DSSp6+EwABbrRbQZOctUI658dL/jwlA/MoTJFCol9Z14dVGBHuR0PwFr0bljrnbhpyEFrkJx5RMelT7/X14uI0urPa+nS2ZoSDm7urwI4LeBUTEepFur5OKjskTPZKBg6isaOKvXGvDviRvrhM+3me5UBSVpA+szNhIaa6z5m0yioyAj8syKgCt6jFuOR3jUxG4IsAoqTpu+rb8ugO8qitP33sisfU29ymuQtOM9HJuAQ4xyIw83T4Nl2+Q+eO2eiDuHclkFf7WA0WiDnru6q+CJKIExRB4d4c2q0Co67GIQR5gRdMiDm1MBT81dW3EkqBPyb9gAQL22d99+zsSRzvmvqPXMnzVEQa1zxbWs1fPUyTnPAO84VXL73bihGE89w53GsE7SToA9Jz4hBpn5Gk9ujo7fLOZMrD9RC7SuQ2OnAz881KKcgEmqX5+kKjJlOZZjTwnQ2z7CX8BC739TbPILpoR5VIWxHkcvfuX4jeptAkbwphhKOW1BthnsBw9O+2uDG73oqRvYHg5cJqXDHapC0YhXgngU5kPxhpgfJ/4xlQCdk7lnZHB7CWT1Wv6sTJlIfgGrKPM5Q1fB0kUaYRBpYOcsnzD42VyGCHrzGocazZmy28vSF/bn4ye1fgZFdDK3gSR9ngI9D+pp8MtQijxbjdEVqU1gj2EGZe8JTac03Yugttk02i7OugxtAfwSY8layoElJUj7O/nPpsxWcyJKqcsgtadOEiH2pd0bp31dvZ0OC0YWB4KoPYBWy3QM9h2QmskmFj4rns75OWzcoEoVGC3RRdL0X7Phxbumn14v/IQNmvO/+icIXJQTYVzYZYDCpb8HVStvkdUoXecRa+jF6XXn4nD4BcYuwq2yhFP83zDQPv04vGyLW6hoZXP0SEuv7uaeUtoEIF7rPIkmFnIJ5COnJ87Miz4QlWr2KekcDLk51DfpZl8MOGC
 823Qc7+L
 L9QCeWpiWLVQEJTTDf/o0VxPdw9Sl4ymypqggDwtRFkR/tpCRlmz7muLGITaFiLghkpFQu2zEE2lRu+nS8/eh0BQB8Q+JdLdEFW7Pumhw2Eh/rXEFrGqaDgUBba03o4H4Ljx4INmuUdHqyOVrRuPpe+oeVMwPRyZaP8hlJHFkvCCNqRVIFGJlkex9yNeIcJ1vM+D9HmRw1ZBsV+ygFlljGYJdj7hsBMY1j4DQCP2WyZ6sGusGtG2Ba+c1sU5SIvc3ryWhR2Qpt+pnbKKbq5Vla3aSjSwyGyav3opH58VQNjHRH3Wx06XY28+bw5l6VPL/yUiu920xRerj+4b+jVYG3b3/lLO+TImnhsL6aLYT8u4vgCXKSozdy0QvbGS27o7auKtK8ULIkwc6DcCPHTWX/i6y2IBv2J5iZn3zJtvoDA5LwK96YdUw0zPD8V8ozUgjs425SWSTM4D+UTmR0e9+GV7Un1/5HonG5l3+C6gkLgIgOxKqT9r6iOwgcVnTxjQ1ThN6
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

Walk all tasks and take one per thread group: the leader, or the first
live thread once the leader is exiting.  Skip exiting threads, which may
belong to a group that has moved out.

Tested in a VM with memory.max=64M: in each case above the process using
the memory is now killed, and a process whose exited leader was not
moved, or whose leader is alive, is killed as before, with and without
memory.oom.group.

Fixes: f168a9a54ec3 ("mm: memcontrol: use CSS_TASK_ITER_PROCS at mem_cgroup_scan_tasks()")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 mm/memcontrol.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4d00748c8a5b..8823c549b6af 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1427,6 +1427,36 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
 						dead_memcg);
 }
 
+/*
+ * Take one task per thread group: the leader, or the first live thread once
+ * the leader is exiting, since migrating the group leaves an exiting leader
+ * behind.  Exiting threads are skipped, as one left behind may belong to a
+ * group that has moved out.
+ */
+static bool mem_cgroup_scan_skip(struct task_struct *task)
+{
+	struct task_struct *leader = task->group_leader;
+	struct task_struct *t;
+	bool skip = true;
+
+	if (READ_ONCE(task->flags) & PF_EXITING)
+		return true;
+	if (task == leader)
+		return false;
+	if (!(READ_ONCE(leader->flags) & PF_EXITING))
+		return true;
+
+	rcu_read_lock();
+	for_each_thread(leader, t) {
+		if (!(READ_ONCE(t->flags) & PF_EXITING)) {
+			skip = t != task;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return skip;
+}
+
 /**
  * mem_cgroup_scan_tasks - iterate over tasks of a memory cgroup hierarchy
  * @memcg: hierarchy root
@@ -1452,9 +1482,10 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 		struct css_task_iter it;
 		struct task_struct *task;
 
-		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
+		css_task_iter_start(&iter->css, 0, &it);
 		while (!ret && (task = css_task_iter_next(&it))) {
-			ret = fn(task, arg);
+			if (!mem_cgroup_scan_skip(task))
+				ret = fn(task, arg);
 			/* Avoid potential softlockup warning */
 			cond_resched();
 		}

base-commit: 6b4b543fa18757297ac756a6fe6e64f506b7844a
-- 
2.43.0


