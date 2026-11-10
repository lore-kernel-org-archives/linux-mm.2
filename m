Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0389360A6F43
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=qqOyL10H
Received: by kanga.kvack.org (Postfix)
	id 2F8A76B05C5; Tue, 10 Nov 2026 10:05:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9886B05C7; Tue, 10 Nov 2026 10:05:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF9A6B05C8; Tue, 10 Nov 2026 10:05:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF6516B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:05:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5F95A0961
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:05:07 +0000 (UTC)
X-FDA: 85419532254.04.D6D5A67
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1670140009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:05:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qqOyL10H;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcLnXutpVbgBdRb5uPCtaaSlCuask7xhgkuh3/sjzDQ=;
	b=59erXoSmXNZA+Tr1YrMMLjaAGMFGvxotjKc5C284UeLuYmndrWqldqbVOoLx6XEDx21yta
	B49yIyczyrTkH3CdBATL1+5MpbEx/iqH1Ab2D5IKRKAkM2J5tse/ljawYZ0eXlFPRSDsCW
	mWrZLG0/DoDlWdKRDCiNlm7/lj1TvSw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qqOyL10H;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323106;
	b=iTIEASzLl36x3lTEBuYsrLybANRESN7iguuEMXormEkvI9dCuY2riy1CwpsWGno+s0c/dR
	22xIq6+r/Q3qUVvrr+ml31pCbOpxlb/RhEl06um53dexNvyd1hwjpBkuqtKrfNGPsCQNqL
	afRqlqy32lwSQLvrpFNadV0d/p9ARG8=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-91e9309f171so18552956d6.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794323105; x=1794927905; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vcLnXutpVbgBdRb5uPCtaaSlCuask7xhgkuh3/sjzDQ=;
        b=qqOyL10HqBS4dy5RPo/SNWlcb6yibPx7dlurXsP+j1lk4rOehVs1C1g3emoscHcvam
         qz1ZV8Y2VyIdp1v7lo6H3w5/BTe7cllprqhnDVVb05kPye2RUlhIN0Pl1EYGzqU9Sl1m
         tbFz0WdgIG2wec2iLvhkXWaWCO9aklMrJ1/NzjhmyBTlCrgWp0+MA2TIQ1KrayHpwtml
         A4lubJJhoi+cj6wzeQLBc/QnBWz8ElgDvYTLps8eITKIcfimhQ3bX+J7zo/F1Be5PJBe
         LggZm9bSCClG6aDfTT3txolAqOkP+Pdccaiz8jr85gCszJyMNuzMVk7a5naiF2mxqQXY
         6mNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323105; x=1794927905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vcLnXutpVbgBdRb5uPCtaaSlCuask7xhgkuh3/sjzDQ=;
        b=BwwIOq016h7RmUVvcuwTWY5YrSlJbcQ6rinkasibwfJFboZga819hzCGdDtRzlO7fJ
         gLpw6HZ0SbNc23+/rOmTlC/7c/ubK39b99cpEUM9LknO395V7+7h4y+JNOlFwCRmkgPz
         E+Tt4IPWWTMCEjoPJX0kXtQaCJweHJB/Z/1nCdR+xItW8tvtoaLuj3iHoD7hMnR6+ZN4
         LVw0+CSKVwezTbJniVhMbxHktIIjgo7Ci/yyEN+B/3+/E9/I/w3QLyNYQ/rw3ktJh26Z
         PQC1HwwIKbkx4J3qdeIx9u6vC3ReCu16zcldPPI5/XpLYhSm1jtj+rXbVyQLYe8wcXbz
         DPYA==
X-Gm-Message-State: APuU4Z/L2x+aojkrFP6wAEDCktu7qnwMDtksSbWHBpot2D12EuRe4H1q
	uuzAAFE7ckPhKHix4ofXeLKwQ0hoH9k4rYEFHK7KvCuugvHpPVDNbHdVptEn7md+/w7bSdjjtCO
	bp5kZ
X-Gm-Gg: AYBFou3KhqMpB1d3xkKhbFkLG5rcBzwsqu1wqZW/nHCPuzVksIly0Hcc2E9EzqswUno
	DB6aaXrKf6xG467+TOw8Oh/S2NEvdUXvJ5N7xFxOJzYG9CJQCI6aktd63lNUYPYfaaM/R4ZW2Oc
	mQOsFxWFRBWQO0x/URwtqa3DhcieqUcbHwDqJf3F6F0aDk7p4Ez5TW87mibyZEdYniSGifAmTsU
	soNc9r9Qxv9U5D/aJPS41L/G8TgxwzYerTm0vQXPKXBeLuVBoWeTlk/V4ELKH4xRsJogsC7O6JY
	8BdWEShP/PlbT48bK2VSuuH/RthpR8LXgNXAJqh3OIfwqCaoivgS3zD4iYO8xPmWrSnUxAoxzox
	GT6tzHb8qlJoszXRpPDq0KrV9IbLhwXuFl7mgb6geZlPfImYbffwrsXMGlZ/niTUXNPC2ejuNUT
	UMEPR0IEqslOY5zwu5MqykbdZBy9cZK44LQ/Ev528Yy1u4VnZUDXkV7bd62xPT9Nr1pV2T5AKi8
	mooKv2W8fuGwvfiFWwS/YE9+kq8ER329tbxbVTy3nJ9F8oukT5eXU0rBbzaJZEdRYgmnKNuU9RJ
	dYryzavgbVtqWDLdvZUuTU1UGv3DT3avhYEvVk87Exjvxl1NtC2WG9867xDsPSxSQecLvigHL5x
	MP6ZBErxM7t+iHwUkQZdcPQigSGt2EqkcGI78
X-Received: by 2002:a05:6214:858c:10b0:91e:73ca:c74d with SMTP id 6a1803df08f44-91eef82dc27mr36514096d6.38.1794323104914;
        Tue, 10 Nov 2026 07:05:04 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef031c7dasm22902406d6.1.2026.11.10.07.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 07:05:04 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@techsingularity.net,
	mingo@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	osalvador@suse.de,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: [PATCH v5 5/7] sched/numa: scan PID-inactive VMAs for promotion
Date: Tue, 10 Nov 2026 10:04:44 -0500
Message-ID: <20261110150446.2452975-6-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110150446.2452975-1-gourry@gourry.net>
References: <20261110150446.2452975-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1670140009
X-Stat-Signature: 1a51rhzj9r8fzus1iuj1zh97iobs76ny
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794323105-433883
X-HE-Meta: U2FsdGVkX18jxmd3s5ctX7jPTGto5ricdblrUw7dginnQTYJGGAVukvPqgSWUyzpuLFkz+djvRPLzpkTJW93woMcvUhOX0NYtWW2THcqx/zy72E314ath2jukDKggIXeVKgldKYlYXEFJDmijgudVb5pywR+bjQL82214SoYSxP5LzmHwKnfxffhaA9v5mLBM70mCfMKJ44M9q79d4CNfiraYYsS7UQqTxqk1QNLaSH9lz9mzSaMDZbAWkD3sMjxvbg4M1L/8vw3d8uamliuHBQ5WlPPDN6sbaIndLLR9UW5KtRkzQUqDvNb46iUQvjbtISiE9i/Q7plbCBq/leDZvFSuuQJNRcd5RiKSbVJlDj/sk9ZCY/3Gx7Z9no7g9Ek1yxMyMY+85E/cF6hRQ33WGTSEndo4ZYwdQsRd2OpgzOw7oMekZDee6zFbb2ndNDYVKMQJJ9WXrFvy1MdNaQFc8TfcUilfFgSGzI8+03MpFdbZaXlvNe1X4wIBxytT9JWy4C4C2Zz556pqwnXVRlMiybrUqCtZQWhIk6fJ9f+nXqTed5jZwocK5xCGkEqkeWqFlBhUH/sL8GH92QTxIRr6J1SZSpla1eJBDtkLgTwaG0DRxVW0wFeQ/ZygudKroJ82yLp8jYMqymRvwTN8Fyjyt2jPXiW4xjhOidmmZBVG6auNJILgGtH/F3mBhwuSrT07gplFDKOUjW/HxYEvwoa9aQQJ5XtaMGDS26B1YxlPwvSjVhw5JGUbEc5ukTBkVzrIUwwJptEealQaOzJpZ2SaZQm3G48lCFub8uj2Id24Hs95c5mLDxsk0C2GJmQcpXhhhy7qnXv/tSAxUjrNW80RMKcX8gKA0Jz9lgpOiV/l9rE8s0xp3UVn32sI1pYrKJSm0z3S3F+sJpYusfcEN4mD970y8H2rq+WA4khOKYRMuqPTssWmvKgbzPYOLWm8mB85JOnmcDm0JPiWeHvMGW
 HGOxB01E
 sOfs6aWZFjnIS9ZOSQYheOTNYHyqYu1Xt53K1L0p51FvvpePw/JPQ02+y0hL7F8bU2ereBbxW7tltPUqVV7D4xR5LowV3EanSXh0UPPYSECpLRqdMzI4CI7DILAakF7ImmNSLI4Xjs+3PRcrx++gvL/fTGc6zXdY1rKDh+axWAIyJd4JgvMuwBv8gdFngHLWyLWUjdqyeuf7BnYVCGZkoUjhTN0S03F7qWcUZXXRzz6KQ93fnXizaD0Bq3fD3Iaj6irTxafWWsKcDp0Ew8BWoL0RI6Rcg7DMPfG7ZI2I1PENtQgoKWflb8FPFH0gZglkSnkGUC54bxRUGuJnunYMHi6U4vTiFjkm/u0xpBhmaev7DWmWyaHClzd/Z5P2KDaPbmBkByIcmSkJq2v4op1slJTAiqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit fc137c0ddab2 ("sched/numa: enhance vma scanning logic") skips
VMAs without recent PID activity. Since only NUMA hint faults record
that activity, the filter can suppress the fault needed to promote hot
slow-tier memory.

Let memory tiering bypass the PID scan filter. In combined mode, use the
placement decision to restrict top-tier sampling to VMAs that need it,
while inactive VMAs still receive promotion-only scans.

Make this decision only when a VMA scan starts. placement_due is
evaluated for the current task, and a partially scanned VMA is usually
resumed by a different thread, so re-evaluating it for each chunk would
demote in-progress placement scans and starve large VMAs of placement
sampling in multi-threaded processes.

Track the last completed placement scan separately from scans of any
kind. Promotion-only scans still update prev_scan_seq, but do not
advance the placement-starvation horizon.

On a host with 768 GB of DRAM and 256 GB of CXL memory, one large shmem
VMA consumed most scanning activity, while 2,537 other VMAs covering
84 GB were skipped as inactive. One stand-out result: a hot 20 GB hash
table ended up trapped entirely on CXL and drove CXL bandwidth
utilization beyond sustainable levels - resulting in a large regression.

With this series, the hot hash table ends up split evenly between DRAM
and CXL, tier residency tracks runtime load, and CXL bandwidth
utilization drops from 45GB/s (maxed) to 5-10GB/s, while DRAM bandwidth
utilization increases from ~200GB/s to 250GB/s+, resulting in major
throughput improvements for the database workload.

Fixes: fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mm_types.h |  7 +++++++
 kernel/sched/fair.c      | 31 +++++++++++++++++++++++++------
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 045b47f4b0463..94350132d1803 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -804,6 +804,13 @@ struct vma_numab_state {
 	 */
 	int prev_scan_seq;
 
+	/*
+	 * MM scan sequence ID when the VMA was last scanned for placement.
+	 * The starvation horizon in vma_needs_placement_scan() counts against
+	 * this, so promotion-only scans cannot postpone placement indefinitely.
+	 */
+	int prev_placement_scan_seq;
+
 	/*
 	 * The in-progress scan of this VMA is promotion-only.
 	 * Resumed scans finish with the policy they started with.
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 778ba0ed34fe8..279bf12b74b64 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4249,7 +4249,7 @@ static bool vma_needs_placement_scan(struct vm_area_struct *vma)
 	 * threads can help scan this vma, force a vma scan.
 	 */
 	if (READ_ONCE(mm->numa_scan_seq) >
-	   (vma->numab_state->prev_scan_seq + get_nr_threads(current)))
+	   (vma->numab_state->prev_placement_scan_seq + get_nr_threads(current)))
 		return true;
 
 	return false;
@@ -4423,7 +4423,8 @@ static void task_numa_work(struct callback_head *work)
 			 * to prevent VMAs being skipped prematurely on the
 			 * first scan:
 			 */
-			 vma->numab_state->prev_scan_seq = mm->numa_scan_seq - 1;
+			vma->numab_state->prev_scan_seq = mm->numa_scan_seq - 1;
+			vma->numab_state->prev_placement_scan_seq = mm->numa_scan_seq - 1;
 		}
 
 		/*
@@ -4456,10 +4457,13 @@ static void task_numa_work(struct callback_head *work)
 		 * Do not scan the VMA if a task has not accessed it, unless no other
 		 * VMA candidate exists. If a scan is already in-progress, finish it,
 		 * but track continuation separately from starting a new one.
+		 *
+		 * The PID filter must not gate promotion. Allow PID-inactive VMAs
+		 * to proceed when memory tiering is enabled.
 		 */
 		placement_due = vma_needs_placement_scan(vma);
 		scan_started = mm->numa_scan_offset > vma->vm_start;
-		pid_scan_allowed = vma_pids_forced || placement_due;
+		pid_scan_allowed = tiering || vma_pids_forced || placement_due;
 
 		if (!pid_scan_allowed) {
 			if (scan_started) {
@@ -4471,9 +4475,18 @@ static void task_numa_work(struct callback_head *work)
 			}
 		}
 
-		/* Keep scan policy stable while processing a VMA in chunks. */
-		if (scan_started && vma->numab_state->promo_only)
+		/*
+		 * Keep scan policy stable while processing a VMA in chunks.
+		 * placement_due is evaluated for the current task, and a
+		 * different thread will usually resume the scan. Finish an
+		 * in-progress scan with the policy it started with.
+		 */
+		if (scan_started) {
+			if (vma->numab_state->promo_only)
+				placement_scan = false;
+		} else if (tiering && !placement_due) {
 			placement_scan = false;
+		}
 
 		vma->numab_state->promo_only = !placement_scan;
 		cp_flags = MM_CP_PROT_NUMA;
@@ -4506,8 +4519,14 @@ static void task_numa_work(struct callback_head *work)
 			cond_resched();
 		} while (end != vma->vm_end);
 
-		/* VMA scan is complete, do not scan until next sequence. */
+		/*
+		 * VMA scan is complete, do not scan until next sequence.
+		 * A promotion-only scan did not cover top-tier folios, so it
+		 * does not count towards the placement-scan starvation check.
+		 */
 		vma->numab_state->prev_scan_seq = mm->numa_scan_seq;
+		if (placement_scan)
+			vma->numab_state->prev_placement_scan_seq = mm->numa_scan_seq;
 		vma->numab_state->promo_only = false;
 
 		/*
-- 
2.53.0-Meta


