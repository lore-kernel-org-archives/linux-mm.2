Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5ACFCA5FBA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082096B0093; Wed, 30 Sep 2026 07:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004A46B0095; Wed, 30 Sep 2026 07:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C386B0096; Wed, 30 Sep 2026 07:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BACE96B0093
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:22:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C8BB80774
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:20 +0000 (UTC)
X-FDA: 85270190040.10.3A0E820
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf12.hostedemail.com (Postfix) with ESMTP id 57ED040005
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Dny7A55O;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790767337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8o+T/NNspIao5W2Ou48Xi+FRL8HzoQJFnQ6vV4A9Rvg=;
	b=yU49fvAIcrKqcJ++9pb2yXnMcneMYFh+2RvvR1589zaNU83zxuNFC86vdqLhvbg0PCnFEW
	CrBoOkIDVeaeJiQZaLeXjapVDXvqNeSay1/zVEipduWSNexWQ8Uosyeer0v8SYUFMhFWQl
	6jWXX2IkVAkfFL0ms/YqT8uzah9LSDM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790767337;
	b=P2kb6KV9q7huPnOgfXriT7WvS0TSunphRWQ2/dszFJUnKQ9U63Dx/xkCr5Z/qYOgVjYKba
	dfDNU24Fvy8CMRv0aX+HTZU+saCf32r7e2bMi+8jE6Z1z8HBRqRzvTYgRTaNKXwXFKENmF
	HIvUNba0PqxNi3xqtsvd4ulbElpBQGk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Dny7A55O;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-4a003bd18e5so17956885e9.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790767336; x=1791372136; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8o+T/NNspIao5W2Ou48Xi+FRL8HzoQJFnQ6vV4A9Rvg=;
        b=Dny7A55OmFHUIfmit9TEL2CGtGfaiKwu169syOZX0/BhW+uRNvs7qW7IR3bNKEoGz3
         F7tkGDkOjFUJ32wYs+R/WLaRNmCtv312WA6v7QlQCHEx7YGjwTnoWREXIDBSVqAvK7BE
         zA07mU98yx06w+vca8bZon7EMDMNUgYDCDRj8oC6s1z2HKxASQZLtjkITdS6y7lkdlc+
         GU3tSbpxfPaMxpJxeq+IvbVKlT9LalR2mkOmkZPnM8fIWSZmoXoYzyKFPz3kJ7uCdvbb
         TwL6Z2pp/aNbw1pZG5n6POprGJWl6IHWSv2K8k9HOt+oK5vA7DrddyowwTYxPDcOUfKZ
         O+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767336; x=1791372136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8o+T/NNspIao5W2Ou48Xi+FRL8HzoQJFnQ6vV4A9Rvg=;
        b=AvDo7HA4NKwvJ70DNq1fdr/glqIDbfuoN9rj/DI/fQ54VuhAGlftcTB2mcJgSy94t2
         u1lHto/voHjGT/CiVz+CIOq62Qh2Sc2e5/ItvOyuYp8OlQJLC/FeW6Mc5EgORtII/WBD
         pjxtX+Ju9iIJIZctgP6D8VU6GKt01DkQzGFu1Zxf0vpfkF9+5xGcFLly16xj+PagyZgE
         5tb+yTpMzKXpbFQflQMqYEmng4bshEDW2/pf4WCV3jEuPRtjQOcoIz5kQ5n8dWdgylZK
         sadCEb0iiJnlnLjeXI48ZSnJrSAddqA4oS0NzNrsjMeXdtfiNz8mI9s0fvHiPJQYgH3O
         xAiA==
X-Gm-Message-State: AFuF++nigodouz4E/COeT5OQMJXAgZDeocIXjSlWCHkr/bsfkSzUnD/R
	OnWfY1pwg+mpBmiMlAJ/8LrWfoXeFreEMwCVnLNKIGzhK/0jqL98p5InBviHVFcnXvdjJ0uT0uM
	tWywtGfPNIg==
X-Gm-Gg: AYBFou0eOrAyGeDbLdg9TdffvViWp2i4Hqm4FGVHNAQRCuxSMvB33ZOxoa1e7Jg+PKg
	3q1BSH1vRyibdfxuNb1/Lxze7sK/BrFVBWoW9gB9Wd1isumhJHbfy8dynvg/0K/cfThdbnt6LDz
	sWNgkPWFClN/SQqRkmUbaQUEXEcSSUqFxyirTyYqa+6V5PFDSLfWBC3FoPSHuUJ3MApCdte96Fo
	+OOa4Gd4K53Vyhf2Z5aTSlhmg+VeumXztPCh2MzLeHmXg4m0yrIgscM1La17wltv6lpfKXVoF27
	09IavM4ZWA0X59OnfulRW7KZZqOiS74by0o8Oi9TiIcu5S9yLZTlj9N/bjH5Hg0MtQ29xPcHW0U
	m/mHUkCL79+yDmUtgSGhUHz5Tg98n1MAKN3A3WBN2rdL60zs7cseAGTpcMwXVVqclwS4BEnswCM
	QS26ptq4dgmQEGa27rXKJy2snRK2G4+N2FKa6O6XwIFvnAcqr4f1+yYG6W0RPr7Px452q12LsYO
	XWx/PfKAoeoCgpW
X-Received: by 2002:a05:600c:1d2a:b0:49f:faa3:3ca2 with SMTP id 5b1f17b1804b1-4a01afebf68mr23163465e9.13.1790767335641;
        Wed, 30 Sep 2026 04:22:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.thefacebook.com ([2620:10d:c092:500::6:13b8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a019740c34sm34097095e9.9.2026.09.30.04.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 04:22:15 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
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
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
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
	shy828301@gmail.com,
	osalvador@suse.de,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: [PATCH v4 3/7] sched/numa: scan read-only file mappings in tiering mode
Date: Wed, 30 Sep 2026 07:22:02 -0400
Message-ID: <20260930112206.205083-4-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930112206.205083-1-gourry@gourry.net>
References: <20260930112206.205083-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 57ED040005
X-Stat-Signature: a47s8ea567m9nuthxq4bwgc5gr4zx9om
X-Rspam-User: 
X-HE-Tag: 1790767337-780274
X-HE-Meta: U2FsdGVkX1+ctYAIiLhGt8uwREd4p5BiJ8xtt8c+IKzv1wQSHRhWrny3SqN77klYdMM/4h3sIcQj/AKkcZXM2OZ9Vi4hw0P8wKtyMz3rEMdGXJKMz8033WUCJXp56hnCgXGW8AA3q6oJV3m7KkqI+eNQ/Lu+Xmi2oIJgaEnNlsn5sfF1Pt4N4KrRWsx7eTwFAFoWuwIEBkyEif3UNODNdsJobiZm4mBDH4peDFPin2BxC4IAHXj26aieKdwS4iaqq1VaIE0T7oGSg50CyfxbFRbNXkfsxl+tUv4CJ7LSw6yBWzgLIU61cQqYi4m790IQAGZJNANQw7qGg0cKymQGrMb6BkhvirpqTCaSbr1zG1ghlcvZFvhJ/GjdbbdZI3IsLYEek6PBgWeliZkz69EVI+5z7m5GwfFl3N3mZTV2PMlKvL3BjoWaW/o8+2CyYb59mLBXkKNpb51emndsZpDVCunCrcg1EQ18jrxvs+a9I5kX16kyyguht42RgoWbFDvad1BjFiFltyAm90Fb58kRrBKikoyNk25ha4MzkPUv5/37+nuCpe30X9FhLwdoLtD+fa30xZT5a9s50v91H4R2oxxK7D2MIjwRRxYs3AQLnFAYi3KG/6a52Yvt1kY9peG0bdvCBgSj0b1WoVC7e2a5fBouHMy9Kad9JE/ka2S3PwKgsrCjGi5TmZ2ngG+T7wqL2YdKts7efLYkoBdo5vxg91jObyOnR8kGiyBxHFN/tk4jqILPxvoxizWtWjDptWgkaiAuONxNiU+gsmkL2/tw2VAN6JkrJFRdILMVD5d+tmsn+NRmsjXjRZgWSoy/3EPdelV3jZgavfJN0yOzT2GglAtFEyxpY5YYlx5UVUxzLr84+NIBcVNAi4NSM9mY0iGePokHPnNKAbrOpQY0dnIpLK+vCVLc+gY1w2+j5pVtrdJUg89fE5XmDlVr/myF1Z38DdVOy4JJSCOdfech6HX
 mOet8U9K
 9SJTuYAEBKPDk4To9RNa95+lAjhpf4Z2/8PYGZat+xtv6NUnrAKZT2hwrm9fXjCS9DAIkHb4QNruP0Th1SqJ7mU1rcaA8UnR7QE1V4TT1rAACxz47U7Wqfc48EEqYGDtPItpM7x0k/nSRpW8bT7nRjcPNQqFJt21YaFaXGc/dFESdrHoaIMuiK4VaRS6IGvSGCOpp+d32zj8LjKUtGKKzE8tCW1o0RUk0+IPtR+95vV1kpW3Yn4HHfPc5AeZVELQ0qpdGGoTnsUUBSDZ+jXqjECZ4KEhw0HXcR5Fv4KPJuOr/43rXYXIVjWBE/zX53qn2zpMRX4o4ouZ6v7iJ952isxmFbMBgeMzHOL9RHaEfSiDaUyEVDgYzo1skW41C9eupl2rZWMQzm0Gbeg+lt5qhWl4+Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Gregory Price (Meta)" <gourry@gourry.net>

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
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/sched/fair.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3be18cf10eca..ab9afd3ad49b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4128,22 +4128,21 @@ static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
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
 
@@ -4231,13 +4230,22 @@ static void task_numa_work(struct callback_head *work)
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
@@ -4317,6 +4325,10 @@ static void task_numa_work(struct callback_head *work)
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
2.55.0


