Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A3B460A3826
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Egc0m3/R
Received: by kanga.kvack.org (Postfix)
	id 592226B05C1; Tue, 10 Nov 2026 10:05:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5685E6B05C2; Tue, 10 Nov 2026 10:05:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457B16B05C4; Tue, 10 Nov 2026 10:05:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 188726B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:05:04 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB3518092D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:05:03 +0000 (UTC)
X-FDA: 85419532086.23.69CECE3
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id C9EB7180003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:05:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Egc0m3/R";
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323101;
	b=h0Y5jhDVZJFUdS5iYDj54XEs4/qRcobjnUndINrRTOWUtBm77mzUKyPXx0ThuO+hm769Uj
	p3L3AWQgJjFc44OP1kxKEPs0EFlMWlQBIKN0JALJR19l0XL95kd7GcWSCo7aDhsxfzgDYL
	NmcQXu7CBLVro7Y372Z8sXSE0gtjfl8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Egc0m3/R";
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDkJzFh0bkGIcyIq5xVYxCRO2DZY5fQgIX/NBTvaYAc=;
	b=BX2Q/Nzm9f3qEhvfDVRzcM+rI6t2YVtJ9xQy/5R1YwCSUVyKkcdvDisdkC9ekO0WGI3YWr
	n/TOQRM2Gm3iNlMnwA1OmG3KHcRWRyLOY6xpIHLdntJEoRhlhQcjPMXKQNeQb/nZBVKWdd
	jdB0CB6uf5iJb4hYAntv8kvawT8UF3U=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91eb3fea2a9so20106286d6.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794323101; x=1794927901; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TDkJzFh0bkGIcyIq5xVYxCRO2DZY5fQgIX/NBTvaYAc=;
        b=Egc0m3/R2HNFRKfaZKlQZHphLnqlHYD/Qq5ZfFFAqLw9rfvbR18VBud5DczgSFbQBh
         jz73lgX3uvCezkjTiIplTJfdMU2HnCR+ANi69I9Y5v8CmjjW2Gp/5m5E87Zm42FYTuS7
         5U1QgtRVaGlMHL7iq4y7W8vtZD1LLhinx4XGcWQeZG861J9SrqwcZTV6CSlobMc7LP1F
         Fde/1RtIIE14xBQwR2F04zsumC9IhacFn4V5C/WMcAnKL/TReIdn5c7sbpa4E4pKom2y
         ARMiv7U75Sr0XdNgMx9OJsIjW59A7vRv40EEg/Paj33S8uZw3C9jipsGk0RMDeGNez+6
         Pk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323101; x=1794927901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TDkJzFh0bkGIcyIq5xVYxCRO2DZY5fQgIX/NBTvaYAc=;
        b=wAfnIpwKbmdORihaBF2IvPbfvLhuvlSsBQsplFetQF8SbHqau3G4h7emdRsSgycOqY
         CrQnA9kYc2HOsYGERRBbcKlA2db0EapicZXXHkI2gH7kSMOkHJCccizgR6c6nHQIv4Dl
         Yvs/kG4jfogJzPoGnnDpOYjET+EzuXUjv3/Rps1eF87hcnp2U2UUUl2BQOV62tTc9G3R
         8EovyY/TiPHXEXd3TfcIzWx6xzyk1hFoNPfTlWfwMXAlQOdGalTXjhs8HOqVhf7Caikd
         Ko2GrhzcNGsDHqrPBeBx2blFcI0E1EvoOWQbvkCoC/sM//0IZUJCMUT2K9lO+60hANaF
         ep0g==
X-Gm-Message-State: APuU4Z/fRe/1N7pfzkakAwPgEfZdg5NMVJ5UrtJL1o5wKdzspFh0GxPa
	etF1pjq83GERonxC6cI+bVLkq3z5iz2Mol7Y/KVN4KfsuK35CtzFL8ulAS3DRdaL4uZY1+BG2GV
	AvKHA
X-Gm-Gg: AYBFou1mer/N5oQ7o8v326raJyIj3Wy0lOTOVK/riAWItvQ/kBVq5BBTpIDjEFMNYNx
	izAcLd/ISo22W+gwNceyU5NGsygJ0qRD/Ooz3LhEmsj4r/cdk7dC8d8jmM+fwTRjkVSAuNYm3pS
	m2gdhRtPjpSQA3seFNM1Q/FTZSQTPlC8T7k1f/GJyPz8W1/wc0o1JqFlt6bGJXOdMrOecoKm3cG
	UoxvlBhdS019vxZariarS0tGrIV6mQXCVlPZPQqgWR+tdOsZC9obH6lKGrjL4i6akgV+fYhwRrE
	kM50aqOa8Ks4OJ4rFXVgnXwWEQKk1AG4di4LRrGFIMViEHKTYZMHXnSd8UM3HNDqAIy7gJhHY2T
	5NTIy3hTXPKei/gwY3+nNYNmFNDt2Ql2CwlqlsMwSvQQkPyD6WSRJzMqIlt/lbayHQF9Lud+wc8
	y8Ooy1ipvvVagY75QQEcf2RIaKd3gMkzC78xfHRzTA+THzyjRNcgQXW3an+WwoWWM/scDI0T03J
	GomeczRF+Llc5LRrI+LhLoa+5yvz2hoZC4GoGhr4YVmZXMVB5/peeDo5oqtQX2eclHtu4pGtddu
	9MoqlzA3HAK2bBTRNLczz4rTyzXstdMMcn/UrEGzk9XiVbgYxrtmnE7l6K1KVAPU32pPHWXTqo2
	ivQh1CcrOjWVLwaU=
X-Received: by 2002:a05:6214:3d07:b0:91c:78cd:3496 with SMTP id 6a1803df08f44-91eef963041mr42647946d6.30.1794323100558;
        Tue, 10 Nov 2026 07:05:00 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef031c7dasm22902406d6.1.2026.11.10.07.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 07:04:59 -0800 (PST)
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
Subject: [PATCH v5 3/7] sched/numa: scan read-only file mappings in tiering mode
Date: Tue, 10 Nov 2026 10:04:42 -0500
Message-ID: <20261110150446.2452975-4-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110150446.2452975-1-gourry@gourry.net>
References: <20261110150446.2452975-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fnz511yba9dfdt8ecbcowqg4dc7dqn1j
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C9EB7180003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794323101-187704
X-HE-Meta: U2FsdGVkX1+f0tYeQTYMnX/YrmRff5rF09G35nraG0GxFO5KNRo+tBc57FcQpjsWJvKqBuFDpvhIdKgwNoLkALB+qMn3legxAiIYJgeHE3UeLiMtclECwv95mhH8iwVEUiTjNgpiczO/zp4aIdcYR+ZC07owSaHAL8SHVaMZEuQGNnwK9FDxoAm8NZ8QvGK7B/a9hDTnb9Zb9M3l/Ao5daie/ffiJW+UAuIx3VrF9qk7WdzLmfZLD8DhpyKTAL7Wr1g+OsA/VQZV64Uzi/eNsTLjPw+3Bl8Y1SO/84EvYfh1eipIAMPai+ALp7l42sA8mDLIfMOgDwIm7X/9Zgcj1wZSOXg0o04ltA8c+Nz/oof2/6TAx0w/MKImq/huJSW7igf9ubZU/cyjBZwdXdpE5G86mJuPhfPkG+TZ22/sFfq+6G3Ups6/TRiTXRDzAURvDVn9MExxrnWV+6NrppiMq9pB8W3rEu5bwKaqYKL5XwJkwaPOl4cYwJEuaKZzR1aEL8Kcq1jgJnHCXMT2IaDiiJeCQ6Xk4+EJB8RzEtJJfH4hhG4W0OJr9ZLLCaXSDg/WCWZkq/qACXYV0X3Qj149a8SB2CCfItfQH4TJrAa/qc1UtWJIXKc/CCD1r1bONeGbOskciAHAEsrK8XtFg2UM1PxHw5FZw61cKAHFc93qJcEVMIK3oJpx6pCs4GAmazzkpUhzFWujMIgWaE5ZdJZU8jrLDiH/8xkkslxgkA8rGVQGqWzQLopnuoRYMPSJa+eJc6zw+Q6AhN1h1Dr6vZWCb5+Ok51+M1oi7uklJxL98bpINWv7yK+pQMYfdAOcyreycRmUmD7AU+jneV9E/ry/onRIAnVoQTD86QzcUN0raRuaph5KvCF6wCV04TQc9J2FKMPoTULVl6MHTjoKmeCFsY+fhSd8Ogimyc2aY+fanbmXiNLhz/xt7MxC6vSHOx+ZNHJdta9uDfZiOwMov/B
 31DS2+hn
 UOGFD1AkEMyRX9LdYuIc9Y8oOtIY+bxDKJ6aGLnEzavy2B33Qi+gU04vTZLS+UMBz4pmhqek9Ys3qRq3zO8FNMafgolkqsZOHSa+RlzO0GWCPi/3kv8F/8pHhhMmRnyA8i2HNW5YoVh9Cgk0T0p0soHmlkIGSv5jH31aN9ZVW18gi0DAMI0Svf94OmwKpSaDa3F33F8sbBcJBniVQ6ZvG5+/c5RvYSU2rzVLKqFd7ikQuhFJwjo/OJDgeV/rsVmXFSfPLhPLytUD+OeZRNXvFwI9RyRi3G5057Oq/l7EaXkA/RHlMMRbBNpRLBJp2mH63viPASIbpi4z9togTlhAILfpydaok9Murumr0tUItEIWGhhfHFF2cBL9yIB54CbivMsWeuX7u9H2e5yRsDqGVD3mgtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 4591ce4f2d22 ("sched/numa: Do not trap hinting faults for
shared libraries") excludes file-backed read-only VMAs from NUMA
hint faulting to prevent east-west placement bouncing.

This filter hides hot file folios on slow memory from promotion.

Scan those VMAs when tiering is enabled, but make their scans promotion
only to retain the existing restriction. Keep the historical VMA
predicate unchanged for backport-ability.

Decide the walk type for each VMA from the balancing-mode snapshot
taken in task_numa_work(). A VMA gets a placement scan only when normal
balancing is enabled and it is not a read-only file mapping. Otherwise
the walk is promotion-only, and without tiering the VMA is skipped as
before.

On a host with 768 GB of DRAM and 256 GB of CXL memory running two
database services using ~430GB each, 169 MB of their shared 185 MB
main binary accumulated on CXL and was permanently stuck there.

With the change, the binary tier residency tracks its runtime hotness.

Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/sched/fair.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e353d3d3012ea..c0b7271f1bce8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4272,22 +4272,21 @@ static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
 static void task_numa_work(struct callback_head *work)
 {
 	const unsigned int numab_mode = READ_ONCE(sysctl_numa_balancing_mode);
+	const bool tiering = numab_mode & NUMA_BALANCING_MEMORY_TIERING;
 	const bool balancing = numab_mode & NUMA_BALANCING_NORMAL;
 	unsigned long migrate, next_scan, now = jiffies;
 	struct task_struct *p = current;
 	struct mm_struct *mm = p->mm;
 	u64 runtime = p->se.sum_exec_runtime;
 	struct vm_area_struct *vma;
-	unsigned long cp_flags = MM_CP_PROT_NUMA;
+	unsigned long cp_flags;
 	unsigned long start, end;
 	unsigned long nr_pte_updates = 0;
 	long pages, virtpages;
 	struct vma_iterator vmi;
 	bool vma_pids_skipped;
 	bool vma_pids_forced = false;
-
-	if (!balancing)
-		cp_flags |= MM_CP_PROT_NUMA_PROMO_ONLY;
+	bool placement_scan;
 
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
 
@@ -4375,13 +4374,22 @@ static void task_numa_work(struct callback_head *work)
 		}
 
 		/*
-		 * Shared library pages mapped by multiple processes are not
-		 * migrated as it is expected they are cache replicated. Avoid
-		 * hinting faults in read-only file-backed mappings or the vDSO
-		 * as migrating the pages will be of marginal benefit.
+		 * Shared library pages mapped by multiple processes are limited
+		 * to south->north migrations as it is expected they are cache
+		 * replicated. The benefit of east-west migration in this case
+		 * is at best marginal and may be harmful due to TLB/cache
+		 * invalidation.
+		 *
+		 * Allow promotion as a cold page incurring many cache-misses
+		 * under cache pressure can drive considerable bandwidth.
 		 */
-		if (!vma->vm_mm ||
-		    (vma->vm_file && (vma->vm_flags & (VM_READ|VM_WRITE)) == (VM_READ))) {
+		placement_scan = balancing;
+		if (placement_scan && vma->vm_file) {
+			if ((vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ)
+				placement_scan = false;
+		}
+
+		if (!vma->vm_mm || (!placement_scan && !tiering)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_SHARED_RO);
 			continue;
 		}
@@ -4461,6 +4469,10 @@ static void task_numa_work(struct callback_head *work)
 			continue;
 		}
 
+		cp_flags = MM_CP_PROT_NUMA;
+		if (!placement_scan)
+			cp_flags |= MM_CP_PROT_NUMA_PROMO_ONLY;
+
 		do {
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
-- 
2.53.0-Meta


