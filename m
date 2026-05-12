Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F725CD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C7D6B008C; Tue, 12 May 2026 02:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A645E6B0092; Tue, 12 May 2026 02:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 953BB6B0093; Tue, 12 May 2026 02:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 819686B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:20:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38FD61C0294
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:20:25 +0000 (UTC)
X-FDA: 84757768410.26.2198541
Received: from outbound.ci.icloud.com (ci-2006j-snip4-6.eps.apple.com [57.103.90.227])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4C05F40005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:20:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=HfaoTKTf;
	spf=pass (imf04.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.90.227 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778566823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUEYIksx/MlqHH0kLnIe3V1vih+q7HfXEtcMMIeWBLQ=;
	b=L4GNAozGfvG5jA2tPJyVrmnsgusPAr4/HeGmkLPTBI0+BA/hb0Y73DVX6plCWtSP6B588A
	jTbegl+K+52cgjGyX3B/ZIfv9pJ/Ugw3v0AdqFDeD/FVRJowzllrCPEU5h1ntmxat6CV63
	TwhvEHdF470/1EFPfALTn/SzjEnEC98=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=HfaoTKTf;
	spf=pass (imf04.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.90.227 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778566823; a=rsa-sha256;
	cv=none;
	b=5KmkthEV4NJde9i2CjxSuWX+g7vtylGyZDSJXorqPxhAb6H02Ry+8QNFOycE6jWPc9Whcg
	85AVzGQhi2SGBYvuZzht+4LYNMzUuY5tkcbJIneVCC/E7kl75f3z2UwwE7MzxoIM520QLp
	uKMb0muA6pRW/oKIMkWpJXnRdEDWZg0=
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-4 (Postfix) with ESMTPS id 92D92180009B;
	Tue, 12 May 2026 06:20:19 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwReC0sKQw5eEhVdRV8YXApUH1oNQC1eCF4fTBwdDlgGEhZdRV8YXApUH1oNQC1eCF4fTBwdDlgGEgJaRQFbFwNXHFZFXBhDCV0FVxwdDl5FWxNVF0YJGQhdHRkIRx8KMANCDlYDQwdFAC0ZHFdQXgheH0wcHQ5YBhIdUBwOUQVbAEYJTQJfGhtBGWYRXh1FRkRBFEkeX1VcVEEJHlcLVg8HME0dXQ5SBUZeWhdeUxcfSwBcRVoOWwRHFA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1778566822; x=1781158822; bh=RUEYIksx/MlqHH0kLnIe3V1vih+q7HfXEtcMMIeWBLQ=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=HfaoTKTf4WS//AWsDfHkLLUWt6/WCC8m/JNJc0O5DPd0B0E6YvGHkXfHZngCaIJL/MIGbo39qbHgzCO0byXmEMeHM1Z5Zl2mASItHJvvwhIvFWFVv07dfV3rfyMGj+X+p0YrIu3UDpRrzncSKWDPbEqbEWCQXoy0pJIGHfsTrcRzizMt+TfeIVPaTpMRhU4Q13ax8UKToX2cQkMlT7b6fjPOLpGs7Unlu9xQs/xmygN02G6gEpxoglCc6OLueLm9/E7h/UDJm8tbw2UPPehLRrU/f81Np8xaSlohHFu/E2xJ0TJo32TB/ao3HrSvlFUPjBmPmGzXypaTH28v235JCA==
Received: from [127.0.0.1] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-4 (Postfix) with ESMTPSA id 37E531800145;
	Tue, 12 May 2026 06:20:10 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Tue, 12 May 2026 14:19:57 +0800
Subject: [PATCH 1/6] psi: move curr_in_memstall out of psi_group_change
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260512-psi_impr-v1-1-2b7f10fdfad5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778566802; l=4239;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=N4v4fH+hkrlYsmcPnl7s6h0mPozXQxvFn8vL46xw/7k=;
 b=+Cqj7ZBgNI/G1fXPJkGX4nB/hX2z3e7OsHKJnqqjWDms6s/Img1NG6X3IFhvCChxfTwXzVw7g
 cttC2Nf+welDlxy4aJqInL3IKbZeDZQzvz0cA1lGqA9n9dHV8YQJ5J7
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Proofpoint-GUID: Q22Xmb8so1l12T3yi4ezHpMO8PEOt5Rc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDA2MCBTYWx0ZWRfX0TXVU+7TkLnZ
 QcvYmzqmWJbm61P+lopHzA418qFOuOshWgjJYF5QpxPzVU6TYZMLE1ygDjtDOR2QBZ9RhhCsStT
 BCqZVnBxiA75onTrihHRg8QgxmDcVeRJ5HbQBHMykUiigsyuwLKOxrbyMJsaHsrQvxPQZE5YRcp
 +G2FS2MAy+YLY9vzEtJA0jtbFzdRIe3oePpQRegYh8Kp4zvXFIgQX0MIgxKVM78UjvdYrU8RgIB
 C/ko+TQrAZUYNkf0Si90laaVmToUH1ikjlkzUYrF6JsaohyeOpJChQx/4n/Ty1EI5qTReFYHW7y
 Ffmuf7JBYnSn9UCPcMLyXKBzEhGXGJKiItGUx5goBpPE3SJ7vp1GcsV7518p+0=
X-Proofpoint-ORIG-GUID: Q22Xmb8so1l12T3yi4ezHpMO8PEOt5Rc
X-Authority-Info-Out: v=2.4 cv=f8FFxeyM c=1 sm=1 tr=0 ts=6a02c6a5
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=geQMgLTJ2Pn_Frh0vGQA:9 a=QEXdDO2ut3YA:10
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C05F40005
X-Stat-Signature: utpcigzxdpc1tkr95pjmf1map3miamx1
X-HE-Tag: 1778566823-531586
X-HE-Meta: U2FsdGVkX18LSWNSQ8GBlNGrqTaB65WcPhDLyNt4Kf+Az18SOs8xOCz27HIKhYH0ahYKiqbOElk+nXZMAoLzRgBvsIy5zEiSXy95Q4c5GUgPIlhZbwLsu7r1ObaqogQrqHrwrJfySefnGcdZn+b9nYJCavL1NzcT7yVTRxLIHwGpJNOJ8JlkLssUQ76IzQKFfPTdiFDHSBn27XYr3eMC3m3QzYks5RAjm3YKZNM2/X+5NKeURjAXhrNOt7YcO434WMENeujPpXbTYiFcywZ6OQvXnLZa5L1zIzxcF496rll2RH7YSAzj+f+jiet2ZieaHux37tx81dtvCKWImWrJh/UeyXnit/afBxgGLYu+RrBTUpZ/BTd7MRkdTzw7FBIW/bKX3oj1zGf2OcvCUk4xCf/FqFHqAqtTEyVYIIKjzf/YDdHJ4AbVjJG9iULwl4thyslzVBlWhRRebc2vqHyXq3DOQKFOw/EgRgbpmwMPQTv7IMrfPyLj34AVpYEc2ANxVcT5qUQ1GzBrVVljhdzYbGBBLhwLx+YSn/YiHuoG1OmoeLZmzdWb5qf/iTyIrt7aPUlK0OeYtM6+KTvlpUWiStft+BlmOjggqoVeX5rZ9CJA0y3f+wRAEmshCjPdWADtSF6jPddfpcrwqIhGHVnMdSNqhmxfzFDstLa74vtIcToqKEGsamWDoefjvKbjzGFNIJfuaPcyMG9Nzz69RHituC3TxEN7BB33HY1h3znWSvD9I8i9kycMMKx55S4rVKhz2e4DUBBK+2drpyGrthgZHGOQKD9jstSB21F+DvSe/c37Aio13SxyHTLD8xWYl89LMS2AVMtLNsz2fXoLTC5DiblDE7or9TSl9VUlbiW+jLoirYuaYJmVtMikZKQTph0tiO40ex5edHpRYngL3x3M7fw03lN7VaD9UIDKjdTkcdpVzxAg+0FtC/O5TUYjxDAWF2AFzTiabq04zixidCL
 HpxbSjJL
 tpDy8s5tpRlc9szFNOH11WQADrcb3/5gmPF8fj1P2jkY41C5WNvn3VBz3mv6jw5MqzsdSOZeR4rHpAtUJI0iAkeZWEXpE+t8NglTt30I3Fd2/7Uu4KkogQQZRCGO2WiaocsrVX6Rb+AJZCPg1ld+xHBb/WIJSD1tbUgny6hZCytSZSzkMAuGrGWrSyYHRr7mHSbZqGCein1b4XatYhKJZT/efk62WkhIOc6ntBU4/1frdhx+BYHB7PxpCkCCbu6o/kNHrL0s5wgvcZeAjzGt/VKHTAXYgbl76MDsL9ouP5qcZYZL/Ou5kvgP4PGS+VRIE6aUnM32w3gYGVo/Sq9+muihpW6DC6GMrbdBv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

Variable curr_in_memstall is currently judged by accessing the
in_memstall of cpu_curr(cpu), which contains multiple times of
memory accessing. And it is now located in psi_group_change()
that will be called for each parent cgroup and it is redundant
sometimes since its value will not change for all these parent
cgroups.

So we move the variable outside for two reasons:
1. We save the extra calling for each parent cgroup so we avoid
   these possible uncessary cacheline stall.
2. For function like psi_task_switch, we don't need to call the
   cpu_curr(cpu) to get the task that is currently running in
   the cpu runqueue. Under that context, "next" is absolutely the
   running task so we can save some costly calling.

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 kernel/sched/psi.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index d9c9d9480a45..27097cb0dc79 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -795,7 +795,7 @@ static void record_times(struct psi_group_cpu *groupc, u64 now)
 
 static void psi_group_change(struct psi_group *group, int cpu,
 			     unsigned int clear, unsigned int set,
-			     u64 now, bool wake_clock)
+			     u64 now, bool wake_clock, bool curr_in_memstall)
 {
 	struct psi_group_cpu *groupc;
 	unsigned int t, m;
@@ -868,7 +868,7 @@ static void psi_group_change(struct psi_group *group, int cpu,
 	 * task in a cgroup is in_memstall, the corresponding groupc
 	 * on that cpu is in PSI_MEM_FULL state.
 	 */
-	if (unlikely((state_mask & PSI_ONCPU) && cpu_curr(cpu)->in_memstall))
+	if (unlikely((state_mask & PSI_ONCPU) && curr_in_memstall))
 		state_mask |= (1 << PSI_MEM_FULL);
 
 	record_times(groupc, now);
@@ -910,6 +910,7 @@ void psi_task_change(struct task_struct *task, int clear, int set)
 {
 	int cpu = task_cpu(task);
 	u64 now;
+	bool curr_in_memstall;
 
 	if (!task->pid)
 		return;
@@ -917,9 +918,11 @@ void psi_task_change(struct task_struct *task, int clear, int set)
 	psi_flags_change(task, clear, set);
 
 	psi_write_begin(cpu);
+	curr_in_memstall = cpu_curr(cpu)->in_memstall;
 	now = cpu_clock(cpu);
 	for_each_group(group, task_psi_group(task))
-		psi_group_change(group, cpu, clear, set, now, true);
+		psi_group_change(group, cpu, clear, set, now, true,
+			curr_in_memstall);
 	psi_write_end(cpu);
 }
 
@@ -929,11 +932,13 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 	struct psi_group *common = NULL;
 	int cpu = task_cpu(prev);
 	u64 now;
+	bool curr_in_memstall = false;
 
 	psi_write_begin(cpu);
 	now = cpu_clock(cpu);
 
 	if (next->pid) {
+		curr_in_memstall = next->in_memstall;
 		psi_flags_change(next, 0, TSK_ONCPU);
 		/*
 		 * Set TSK_ONCPU on @next's cgroups. If @next shares any
@@ -947,7 +952,8 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 				common = group;
 				break;
 			}
-			psi_group_change(group, cpu, 0, TSK_ONCPU, now, true);
+			psi_group_change(group, cpu, 0, TSK_ONCPU, now, true,
+				curr_in_memstall);
 		}
 	}
 
@@ -984,7 +990,8 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		for_each_group(group, task_psi_group(prev)) {
 			if (group == common)
 				break;
-			psi_group_change(group, cpu, clear, set, now, wake_clock);
+			psi_group_change(group, cpu, clear, set, now, wake_clock,
+				curr_in_memstall);
 		}
 
 		/*
@@ -996,7 +1003,8 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		if ((prev->psi_flags ^ next->psi_flags) & ~TSK_ONCPU) {
 			clear &= ~TSK_ONCPU;
 			for_each_group(group, common)
-				psi_group_change(group, cpu, clear, set, now, wake_clock);
+				psi_group_change(group, cpu, clear, set, now, wake_clock,
+					curr_in_memstall);
 		}
 	}
 	psi_write_end(cpu);
@@ -1236,7 +1244,8 @@ void psi_cgroup_restart(struct psi_group *group)
 
 		psi_write_begin(cpu);
 		now = cpu_clock(cpu);
-		psi_group_change(group, cpu, 0, 0, now, true);
+		psi_group_change(group, cpu, 0, 0, now, true,
+			cpu_curr(cpu)->in_memstall);
 		psi_write_end(cpu);
 	}
 }

-- 
2.52.0


