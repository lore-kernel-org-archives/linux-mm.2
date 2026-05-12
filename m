Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DD2BCD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28FC6B0092; Tue, 12 May 2026 02:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9E36B0093; Tue, 12 May 2026 02:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F01B6B0095; Tue, 12 May 2026 02:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 901C26B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:20:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D4511C0294
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:20:33 +0000 (UTC)
X-FDA: 84757768746.22.FA6CD28
Received: from outbound.ci.icloud.com (ci-2006d-snip4-2.eps.apple.com [57.103.90.163])
	by imf10.hostedemail.com (Postfix) with ESMTP id E40CDC0004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:20:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=frWUwbFM;
	spf=pass (imf10.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.90.163 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778566831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8h+7o8Bgk3l22j2rwVIvN8mIH1kXWOUMroNDLXzMIms=;
	b=ma3CKd862EUbaBAmYCfBkQJ3KOFHigaf/ozX8x2GkIivEbozCk2Qs/jAoXrHEOZOPs4zv2
	VKiOeHW6uHPlZOxup1UJRI7aNmV+ucPtQ5KVCK2Ek82vQ2P7SVSTQ5oM/84hlyeITdMVO6
	l/I9ebK86iBm7F50flMLHZIELYjQF3M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=frWUwbFM;
	spf=pass (imf10.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.90.163 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778566831; a=rsa-sha256;
	cv=none;
	b=SjXad6PSVc0HHhIe/7CvpOIgI4OEgjxw8q2TUAbNFDNWmh6V0P1KYkMLDb+By6FNeznqvy
	3SehZbWT/5LjfQ19u4686PCGBp4J09CYH0sdyH2jyMV+/IHamN3WvskUzrK8FG4ohONee3
	SQxR7QyjBE94baGRhxnKVp8My3Ukx6k=
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-4 (Postfix) with ESMTPS id 64E981800162;
	Tue, 12 May 2026 06:20:27 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwReC0sKQw5eEhVdRV8YXApUH1oNQC1eCF4fTBwdDlgGEhZdRV8YXApUH1oNQC1eCF4fTBwdDlgGEgJaRQFbFwNXHFZFXBhDCV0FVxwdDl5FWxNVF0YJGQhdHRkIRx8KMANCDlYDQwdFAC0ZHFdQXgheH0wcHQ5YBhIdUBwOUQVbAEYJTQJfGhtBGWYRXh1FRkRBFEoeX1VcVEEJHlcLVg8HME0dXQ5SBUZeWhdeUxcfSwBcRVoOWwRHFA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1778566830; x=1781158830; bh=8h+7o8Bgk3l22j2rwVIvN8mIH1kXWOUMroNDLXzMIms=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=frWUwbFMzDRZTuvIbU+SbHHZTU0jXu8FdTinTBy3KtVQZXX37b1wxAIeIbFyx9AqFfsVO9Dti9XClU1aYkbUPZ6zcQO1IPoSyQCx4P8jnungNVWUw2KeRZzk6VN9NDGAe9Id+vbuubQ6I2gEFBo4ExmqZS/ACu0Q4NyPSnkMzo85hlSB5lPCYzfStd8zLSGUkDUP2olbRHb/F/b5g/VasMM+Ha0zwB9f9JASk+qchBq6jCOzT0GCTWOfOIvY9vgLTWF85hb5jfoaE2pFagmb5FfDPm4sUV6thxBzD8o0haWaeihiXDR2UwPFtA3yTzPXKrW8P8+53rWze4OtVvhoyg==
Received: from [127.0.0.1] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-4 (Postfix) with ESMTPSA id B5847180010C;
	Tue, 12 May 2026 06:20:19 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Tue, 12 May 2026 14:19:58 +0800
Subject: [PATCH 2/6] psi: reorganize the psi members for cacheline benifits
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260512-psi_impr-v1-2-2b7f10fdfad5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778566802; l=6142;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=N5D+RIwNZxJiJH2AZyKghi8aFJucRQZRH7/vB1IusO0=;
 b=7t1U+9WAPOc6xZ2Jf+KkbhsNm38o93/Pyv5oy5BDThvnGJnPJVbvPDZyK0wSKSmmYzUWwbOhg
 XBdum8KdBkhCSyqO8oqxS6ghmUn1ubG4LxbvrSMr0zEh1mCCBvpK3bs
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Proofpoint-ORIG-GUID: 2M5e_Q70fx062IKZSDQxewmhsUgwKgQo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDA2MCBTYWx0ZWRfX6QSzkCjU11Mi
 51TXnSvJ/Is9C+tRSgrDz4C3LzwMi12qxThHTNNN3fS+UPt5chTyWEo3OvvEhLTIc6D0w1lsBj9
 rhazZSLaMZn8oAfQY9vh2Is36O3mW9+/R8E4PK+fuXHSSHZBOfwR7XNXk9dlbzHrznciRrp34uB
 swU3Ffiu6HnBj3hFIwhGymIq3MFGg8ABBcQvwSjSOFtTATM7ormp0ykSXl1hkmVUQY+ZoPWydSt
 CMlNEiNASWdeAt8n2YnmYdReWrsE9KzW8TuOBF3uoDwSBMq1SY+3OnDqRaBZ2Q8qTtxT4KmHcgT
 dLPh8sfw5e9Dm7dzR8hbz2nWZJ5Cc65ovsY7Gqv6eIlxM3ScxNt3coWFgUGYDs=
X-Proofpoint-GUID: 2M5e_Q70fx062IKZSDQxewmhsUgwKgQo
X-Authority-Info-Out: v=2.4 cv=fMA0HJae c=1 sm=1 tr=0 ts=6a02c6ac
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=cUUTUCbMLiH3-CSjQHoA:9 a=QEXdDO2ut3YA:10
X-Stat-Signature: igzw3wigjot97jj4qqbszatsm7bidhmj
X-Rspamd-Queue-Id: E40CDC0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778566830-648077
X-HE-Meta: U2FsdGVkX1/XY2ZufdfC87bTzUS+BnfstoRCVTDQEVg4V/25EKRpNeUmuOswzTLDtVdXENUsSkZjjX6ECeE4wx2qEu94aacymC88XEf+1TWTPUVwKNf3CtCdD6o3Dj0q6Sp6n18hSheDLVcKbefBAadhwtRRYuI2RnxZm6oRyCAwVCwqioQeJoEjV1CbpVLFYcg4SF+wun/nbJZGcN1j/jV1ga6976HAGOYLuQrky3LHa8pxO7ODaOHOvLr0SAoKxjXxza+ZHoTbkk0Rv40Iy0MReeoOyUtba/PCppMdQI326nCVKdM9FeaV6TLMQAvjmb6FSo1NhissWKpKQXxhoPMr3YJxgT30Yk0YWH8qbApRnwfLsw4HXZkMODV/dtuzrOsi9IQBF2dcqYzxFq/kgg49loNNTVzdADyDtgOR2JH0tBozxME3dJFYfky+rp4L1xPxO4nk168MvtjshJ+oi0XOSRrUfbl9nP2KRZJDHsfsiwhTXZK3mrQr2yuXG0s5fICDNy6uBonGoGMAHUlHubJP36zuXim5yl5Y9q+UrEG0ExU1VSbTJ3DqEEqzPFJlHNHsDI1nxck7jTjZk5kmE2+hUZd3ce87j6YHUwBBx3OXeNTNTKS3dhNjvQfzL6/Cg+bjX/EgFuI9tYMZc8nqaCkPRfnPL76HkFH1rD45RD1nRorF8iGhl4jJdri8g7NtTciHBubxFC/nfV8fUZlbXJIMBdwe8yHwvKMl3eKLbnMD0D+62bTdPmSNDySnEpGy/EGyanFOMI76lmn3ijh/CianxUbhFdZhuNPnNA7YYWJIWHz6tGKlCiG4WY9ie5UDV8IlDBkS9Tz2mpjW3ZpeCUpXXFclIt3fTkxzg3qn+kqQjuwvkYpBGKq3XmCS9QvrgzWtzQIMS9YsppX2C9p/f0EjE2F1R0tBze+keK9NWjgVYhs7Q/51QMMpIGoRkQ8Cyitp+VLLaNG6DoR9aiy
 FoaJKHQ6
 4YCwa+LGC+ALPPgeNSduPKqTvR9erQvPcnF4m0P0MFxrFeuwa0PpDM80xawvLKMKssbeqn4SwmYzh6dovMl+gAvy2pf69R64608GqfPk9sC3TJARymkDWzCE27x2AJCQkEwwCX70yowEnc+zxPVuVw3dIOhw9SclfbJ2zb5vFiw40HJXZXHdWwk/U8xl6lz2hgc9MP0k7AFSA6SZxW5MtlMNLp5JJGni90oFQeqlxr4YhpkXenTqOERXwqXgtoFP3rAH4jH49vT42K+jzQ+xtG7VLid3Wj5bKem5OzwyHMenUBreIMLkSQhZFyLQZj6sB0+xtJXrcvguw/vImwVuk1gus+ZWkzLMlgWrKJABbmDet2TNVgzxVaO8iOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

Currently, we check whether the task needs to do psi accounting by
reading task->pid, which is not cacheline aligned with other psi
variables like in_memstall. This can generate some cacheline stall
from what perf-record indicates. So we would like to merge these
variables together.

However, directly switching order of pid and restart_block may cause
other cacheline problem in other scenorios which is hard to recognize
clearly. So we added need_psi bitfield variable to indicate the same psi
thing and put it together with in_memstall. The value of need_psi will
not be changed ever since the task gets created so there is no problem
about synchronization. Also, adding one bit to the bitfield variable
of unsigned int will not enlarge the size of task_struct or change the
memory pattern of task_struct at all.

Also, we put psi_flags which only has 5 bits long together with
in_memstall and need_psi too to make them all cacheline optimized.
5 extra bits can also be stuffed into one single unsigned int so it
will also not enlarge the size of task_struct, but on the contrary,
it will shrink the task_struct since we eliminate the psi_flags that
was put there independently as a unsigned int.

We also add NR_TSK_ONCPU and NR_PSI_ALL_COUNTS into the psi_task_count
enum definition to make the semantics clearer, and move the definition
from linux/psi_types.h into linux/sched.h since we need those enums in
linux/sched.h. These two revisions do not make any actual funtional
difference to the code.

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 include/linux/psi_types.h | 20 +-------------------
 include/linux/sched.h     | 29 +++++++++++++++++++++++++----
 kernel/fork.c             | 10 ++++++++++
 kernel/sched/psi.c        |  6 +++---
 4 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index dd10c22299ab..5639dcdd90af 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -10,24 +10,6 @@
 
 #ifdef CONFIG_PSI
 
-/* Tracked task states */
-enum psi_task_count {
-	NR_IOWAIT,
-	NR_MEMSTALL,
-	NR_RUNNING,
-	/*
-	 * For IO and CPU stalls the presence of running/oncpu tasks
-	 * in the domain means a partial rather than a full stall.
-	 * For memory it's not so simple because of page reclaimers:
-	 * they are running/oncpu while representing a stall. To tell
-	 * whether a domain has productivity left or not, we need to
-	 * distinguish between regular running (i.e. productive)
-	 * threads and memstall ones.
-	 */
-	NR_MEMSTALL_RUNNING,
-	NR_PSI_TASK_COUNTS = 4,
-};
-
 /* Task state bitmasks */
 #define TSK_IOWAIT	(1 << NR_IOWAIT)
 #define TSK_MEMSTALL	(1 << NR_MEMSTALL)
@@ -35,7 +17,7 @@ enum psi_task_count {
 #define TSK_MEMSTALL_RUNNING	(1 << NR_MEMSTALL_RUNNING)
 
 /* Only one task can be scheduled, no corresponding task count */
-#define TSK_ONCPU	(1 << NR_PSI_TASK_COUNTS)
+#define TSK_ONCPU	(1 << NR_TSK_ONCPU)
 
 /* Resources that workloads could be stalled on */
 enum psi_res {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 368c7b4d7cb5..34d7f80531e7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -817,6 +817,28 @@ struct kmap_ctrl {
 #endif
 };
 
+#ifdef CONFIG_PSI
+/* Tracked task states */
+enum psi_task_count {
+	NR_IOWAIT,
+	NR_MEMSTALL,
+	NR_RUNNING,
+	/*
+	 * For IO and CPU stalls the presence of running/oncpu tasks
+	 * in the domain means a partial rather than a full stall.
+	 * For memory it's not so simple because of page reclaimers:
+	 * they are running/oncpu while representing a stall. To tell
+	 * whether a domain has productivity left or not, we need to
+	 * distinguish between regular running (i.e. productive)
+	 * threads and memstall ones.
+	 */
+	NR_MEMSTALL_RUNNING,
+	NR_PSI_TASK_COUNTS,
+	NR_TSK_ONCPU = NR_PSI_TASK_COUNTS,
+	NR_PSI_ALL_COUNTS,
+};
+#endif
+
 struct task_struct {
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 	/*
@@ -1030,6 +1052,9 @@ struct task_struct {
 #ifdef CONFIG_PSI
 	/* Stalled due to lack of memory */
 	unsigned			in_memstall:1;
+	unsigned			need_psi:1;
+	/* Pressure stall state */
+	unsigned            psi_flags:NR_PSI_ALL_COUNTS;
 #endif
 #ifdef CONFIG_PAGE_OWNER
 	/* Used by page_owner=on to detect recursion in page tracking. */
@@ -1299,10 +1324,6 @@ struct task_struct {
 	kernel_siginfo_t		*last_siginfo;
 
 	struct task_io_accounting	ioac;
-#ifdef CONFIG_PSI
-	/* Pressure stall state */
-	unsigned int			psi_flags;
-#endif
 #ifdef CONFIG_TASK_XACCT
 	/* Accumulated RSS usage: */
 	u64				acct_rss_mem1;
diff --git a/kernel/fork.c b/kernel/fork.c
index 0d97fd71d7f6..20b47c876b27 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2177,6 +2177,16 @@ __latent_entropy struct task_struct *copy_process(
 
 #ifdef CONFIG_PSI
 	p->psi_flags = 0;
+	/*
+	 * Only setup need_psi to 1 for non-idle tasks. We
+	 * also need to reset need_psi of idle tasks to 0 since
+	 * their values are copied from the init task whose
+	 * need_psi is not 0.
+	 */
+	if (pid != &init_struct_pid)
+		p->need_psi = 1;
+	else
+		p->need_psi = 0;
 #endif
 
 	task_io_accounting_init(&p->ioac);
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 27097cb0dc79..7374c05a5751 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -912,7 +912,7 @@ void psi_task_change(struct task_struct *task, int clear, int set)
 	u64 now;
 	bool curr_in_memstall;
 
-	if (!task->pid)
+	if (!task->need_psi)
 		return;
 
 	psi_flags_change(task, clear, set);
@@ -937,7 +937,7 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 	psi_write_begin(cpu);
 	now = cpu_clock(cpu);
 
-	if (next->pid) {
+	if (next->need_psi) {
 		curr_in_memstall = next->in_memstall;
 		psi_flags_change(next, 0, TSK_ONCPU);
 		/*
@@ -957,7 +957,7 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		}
 	}
 
-	if (prev->pid) {
+	if (prev->need_psi) {
 		int clear = TSK_ONCPU, set = 0;
 		bool wake_clock = true;
 

-- 
2.52.0


