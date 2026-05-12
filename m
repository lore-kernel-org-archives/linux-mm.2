Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 160B2CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D616B0092; Tue, 12 May 2026 02:21:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CE706B009D; Tue, 12 May 2026 02:21:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E54F6B009E; Tue, 12 May 2026 02:21:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D04D6B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:21:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 05E5C1C028A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:21:08 +0000 (UTC)
X-FDA: 84757770216.07.1AC6664
Received: from outbound.ci.icloud.com (ci-2001b-snip4-11.eps.apple.com [57.103.91.23])
	by imf23.hostedemail.com (Postfix) with ESMTP id 018DD140009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:21:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=HnSdxRDm;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf23.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.91.23 as permitted sender) smtp.mailfrom=lukafocus@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778566866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R7WZwsOB3CgUd4zcpnHi7ylJ/W9SAO8MOHEKfoRSL5A=;
	b=sM2cNjDRoB5wZc3a0cvyvlVMUSD+mhCUc8a2iuHLjSVxkmo7MmnTJ677KTqpliIikvEeea
	x29+bvSty79K+wp3UlTqehspIA7/gd01a4MAqs0MhG6/peBPQUAI7a8uLC2mQmakznU7/8
	lhMB3/I7CzqVXbdGk0bzhrULvQ4wTj8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778566866; a=rsa-sha256;
	cv=none;
	b=eVo1wwsnWBzzeOCweuzN8/uz6LONA/n8KJ0TaraQ7SAP9bk8EWdVq6MXpUOhUUgVmOpLlx
	031cluH+zg0vzg+X1rjdBN5jkehj+HujaV+RFUUZ/DjTIB78lB9KXK0oIqrmMUDHEVXK+n
	Aq8kSSsTmmKiqdIYtVLEnJNhNglK7V4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=HnSdxRDm;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf23.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.91.23 as permitted sender) smtp.mailfrom=lukafocus@icloud.com
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-4 (Postfix) with ESMTPS id 8D51B1800169;
	Tue, 12 May 2026 06:21:00 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwReC0sKQw5eEhVdRV8YXApUH1oNQC1eCF4fTBwdDlgGEhZdRV8YXApUH1oNQC1eCF4fTBwdDlgGEgJaRQFbFwNXHFZFXBhDCV0FVxwdDl5FWxNVF0YJGQhdHRkIRx8KMANCDlYDQwdFAC0ZHFdQXgheH0wcHQ5YBhIdUBwOUQVbAEYJTQJfGhtBGWYRXh1FRkRBFE4eX1VcVEEJHlcLVg8HME0dXQ5SBUZeWhdeUxcfSwBcRVoOWwRHFA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1778566865; x=1781158865; bh=R7WZwsOB3CgUd4zcpnHi7ylJ/W9SAO8MOHEKfoRSL5A=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=HnSdxRDmyDHxxGcgB6hX4nuT6ZqDDeP7hvyGEfS4LRVQ9X+oHmi/ealchoyPYUmbiTKr99/CWKVv8ibjugU1jkchcuUvFj2ORzNxA+9Dq2zNcg1JzWZcWqMrzWo8eBOsbG1qFK0V17qWP3y3VdDeLmAHk+8V86eFSfSkxpSIewVlrn72BWgkIsvZUKv907ta1MmQUX+LeBwOgnhG/8mm83w4vvAhL1u10xGWfPVn8oF2kNdwM/SY65yanfJdRoksN/B3Ae3Tdxxj6SrT4oO1THdDJFIIIH1A77rAYzJCzIN0Fsfm6/FMNIrzTWbGiSDDMJtCyR5LVs9OHKJSDZMVPw==
Received: from [127.0.0.1] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-4 (Postfix) with ESMTPSA id 92C81180016C;
	Tue, 12 May 2026 06:20:52 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Tue, 12 May 2026 14:20:02 +0800
Subject: [PATCH 6/6] psi: remove psi_bug and moves checking of NR_RUNNING
 ahead.
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260512-psi_impr-v1-6-2b7f10fdfad5@tencent.com>
References: <20260512-psi_impr-v1-0-2b7f10fdfad5@tencent.com>
In-Reply-To: <20260512-psi_impr-v1-0-2b7f10fdfad5@tencent.com>
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Peter Ziljstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Kees Cook <kees@kernel.org>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Luka Bai <lukabai@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778566802; l=2880;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=6q4L4uq69DKt/CZJ1lu/3JvGNmB9tf3m8tlVZoTYSQg=;
 b=slephPrnVgdHjw/+xnQlaJ5+kdbd2sfsfq2sIgLIGUkwgJZ4dCV4BuiON5JrJgQGV1sEI/IsO
 dEiXPb8JBCQDoJYucm0uqyKoAMhhKAu3MZtlXNAg3A89RU8wTfqQfBV
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Authority-Info-Out: v=2.4 cv=GMUF0+NK c=1 sm=1 tr=0 ts=6a02c6cf
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=Ee36wLBZbuEWgZn7rsAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: g4Q5OHPjTgqPAB5qPTQmBZ7cS488dJIr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDA2MCBTYWx0ZWRfX/akZhom3E3Mp
 ZK3GJGTPs0Dt81nwy1vbFDzb9wORUetUdzgi/h13hsgnrPxZadwvVbQe9k1gZS2uNoRh5uCbwHG
 IpoU6N9uKnSOeeL2cqA5feDS7PPT0/P1VY0A+nlayNV6c5+nShOLlVQDZSEEdqqVvGINfATawDM
 zlBZOHti0EVgG5zro2PpOvkqJjwmdqQrgyQTL0b4w7eRtdsb/YYOB9bnWWSwyvujPtjnMvqpa4m
 o0Ydn0eYnDV+3Ng+A0C6bBhg3uMK/jvdng0P2X4oakv0V2nHTGUEAZSdSdU8MMSulVVhSzpOH+M
 dqZe0HZPDGFgFgxfgKfblSR7yvzznD3RjnfH6+2keJEgDUdQTWnRNYJqQvlvnc=
X-Proofpoint-ORIG-GUID: g4Q5OHPjTgqPAB5qPTQmBZ7cS488dJIr
X-Rspam-User: 
X-Rspamd-Queue-Id: 018DD140009
X-Rspamd-Server: rspam04
X-Stat-Signature: 3ksyhtfomtn9n1w1qenybtpkosynciet
X-HE-Tag: 1778566865-946795
X-HE-Meta: U2FsdGVkX18lhiGjatCNI1hYD3N/mIuGjFis5mclS+Q+/oAq+3sFOPoZ2ksp7DzH7hAory+N5SdAn0uNQc28O5H0IdJKX8vt1HiDOXwJRRZKV8E+BDHhzCSzDWHAqyKHfVaoNWDubzPRvNGkJMGIIsikTaToawaAVjUr7c93jQPIhNc/fQ1SuPkPk7rWzwgjIBAVSmI4htrQfxFUNyqV7qz8ohrh81DOkQdAROlzFbLdJu5oBL/gVBfQIRYuXbX5RVHOB2szGAiiRDWc3s5DaBgL14Jv8/NqnYaZ8gMakd4zu1WnG+lnnOzBCkV8pDAS2QYrNi8uIvwEc4+ZjxTFZG3PACX3PvSsyF39FDNiDQSitVRx8AaqeZP/yJnNv/Mba69O9+QvqYu5G/krS7VqPS3T4g6sfDQCvaokogAvY84NJpOoEWZOy+uK8K4Et3SPzdDZ/PscbkUpoJrz7XX7xdmv1x75zrXHgkfYjsr5kAcLk2PV0Bx6X4BjfvZlB77jBhisVWpNQ+tSliFchBEMW/AHDT2XwFfmZP08NQksDL1T8X/hec5j/wcVMx8UjVFlRfjkreEiHO0i6APbL5g4WabwGJi+aMs9vsurA5vOb4RbGx1UjMIexLqZBOLDgmrnZANylSs8QyPgrHSGGLfGnufH4foE3GCSTwhBhnzIZQ9ebOauLmOvVQbLkNKjfBOeQvEkrjuEfzULqDcVZDg8a8xCV/8Yd8wJ+D3rNFemrImv4hveQh62XwnP2lHiUetUFxJJpPppViCwrTZQUUMFTL9E1QRhZigG1KYkQVC6fhzebq2dTQORJs9feMmC/RdhmwTV7Wm2DzCRXCMWMOwZrM28LFM06ErYIiAulLlnQZFlAGvTiALA9SmOxk0xIUBn1KDs7ZaQ6TSuQTtKwtt/87nKHXpYr8KAJzsAGijJUU9BRQ5moUFRa8cUkcttxkEi6fe5TfB7jLZWW1aQoFa
 xMSLsaBL
 r83sy+mnIm2eCQrLOd0strugEMDAymKuvonr9M6SO3h596zsGw7FtKqnGvIf/qpBTdQmkAdeLRHPU0coY1nS01/OoFBxP0RTMY+T0scrsPVbqVKTBi5wOTDhYtVb1qS0A/pdVVWTnGVKNFVvwquaUVngYmgKpATlOMLu15kGHAHE7Vp0SZSBfMxTzV7VYYkuVjtYUNGzb3xE0Djjy9h73zgPiH68SLVLu/bgAPiA72drG8X5WhazRObIQXUX2MkwOyah6gIdWBzGGiArtTEGwWAiqFvLTVhXQZ1oVfXm/Eod5BwvalgMSFPYp/8frqOC3+M80immGZgSjUnNiQeb4qWP5WHwLBiQVxzMql8pRM0ORqa1nR2AprgkbdadXaN3dFfUTPMp8bSgAklzD67560/735FsRMsdDCZFROudmN/DadZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

During the accounting of psi states we'd like to do some bug detection
to make it more maintainable. And we use the variable psi_bug to make
it print once. We would like to use printk_deferred_once to replace the
usage of psi_bug since their effect are similar, and this can also
increase the readability.

Also, use likely and unlikely in these bug detection branches.

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 kernel/sched/psi.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 4c4bd134c785..70dd642af5e0 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -141,8 +141,6 @@
 #include <linux/psi.h>
 #include "sched.h"
 
-static int psi_bug __read_mostly;
-
 DEFINE_STATIC_KEY_FALSE(psi_disabled);
 static DEFINE_STATIC_KEY_TRUE(psi_cgroups_enabled);
 
@@ -262,7 +260,7 @@ static u32 test_states(unsigned int *tasks, u32 state_mask)
 	if (tasks[NR_RUNNING] && !oncpu)
 		state_mask |= BIT(PSI_CPU_FULL);
 
-	if (tasks[NR_IOWAIT] || tasks[NR_MEMSTALL] || tasks[NR_RUNNING])
+	if (tasks[NR_RUNNING] || tasks[NR_MEMSTALL] || tasks[NR_IOWAIT])
 		state_mask |= BIT(PSI_NONIDLE);
 
 	return state_mask;
@@ -836,14 +834,13 @@ static void psi_group_change(struct psi_group *group, int cpu,
 	for (t = 0, m = clear; m; m &= ~(1 << t), t++) {
 		if (!(m & (1 << t)))
 			continue;
-		if (groupc->tasks[t]) {
+		if (likely(groupc->tasks[t])) {
 			groupc->tasks[t]--;
-		} else if (!psi_bug) {
-			printk_deferred(KERN_ERR "psi: task underflow! cpu=%d t=%d tasks=[%u %u %u %u] clear=%x set=%x\n",
+		} else {
+			printk_deferred_once("psi: task underflow! cpu=%d t=%d tasks=[%u %u %u %u] clear=%x set=%x\n",
 					cpu, t, groupc->tasks[0],
 					groupc->tasks[1], groupc->tasks[2],
 					groupc->tasks[3], clear, set);
-			psi_bug = 1;
 		}
 	}
 
@@ -908,13 +905,11 @@ static inline struct psi_group *task_psi_group(struct task_struct *task)
 
 static void psi_flags_change(struct task_struct *task, int clear, int set)
 {
-	if (((task->psi_flags & set) ||
-	     (task->psi_flags & clear) != clear) &&
-	    !psi_bug) {
-		printk_deferred(KERN_ERR "psi: inconsistent task state! task=%d:%s cpu=%d psi_flags=%x clear=%x set=%x\n",
+	if (unlikely(((task->psi_flags & set) ||
+	     (task->psi_flags & clear) != clear))) {
+		printk_deferred_once("psi: inconsistent task state! task=%d:%s cpu=%d psi_flags=%x clear=%x set=%x\n",
 				task->pid, task->comm, task_cpu(task),
 				task->psi_flags, clear, set);
-		psi_bug = 1;
 	}
 
 	task->psi_flags &= ~clear;
@@ -927,7 +922,7 @@ void psi_task_change(struct task_struct *task, int clear, int set)
 	u64 now;
 	bool curr_in_memstall;
 
-	if (!task->need_psi)
+	if (unlikely(!task->need_psi))
 		return;
 
 	psi_flags_change(task, clear, set);

-- 
2.52.0


