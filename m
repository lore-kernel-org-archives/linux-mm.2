Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 137B9C98307
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00746B00A5; Tue, 22 Sep 2026 14:29:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D80B6B00A6; Tue, 22 Sep 2026 14:29:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89FB66B00A7; Tue, 22 Sep 2026 14:29:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68B206B00A5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:29:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E04780579
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:47 +0000 (UTC)
X-FDA: 85242236814.16.FEBF4B2
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf21.hostedemail.com (Postfix) with ESMTP id A8BBF1C000A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=X+qdUwRS;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790101785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IEBH2G+jGtGbGG4yhB6a6/Qs6IdlZYnf6Lv/AMN6/lM=;
	b=Dn0AB/iCfpTANClP5x8BftZrznPrcS7sOSZq8h0EVwTxN6FhHoTBkLo7kUmbH4uta8/EX4
	cAK7jXEzokgUePiTVMHiD2ssphJrhQblQeRcaMxuGVFOqdEPGCHXCmHeLrgfHw99R3qBVZ
	BsQ5ZG+4eOGNN7LJM6tSJAbT2dBB14c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=X+qdUwRS;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790101785;
	b=dk0sQKMGTHNS3VVw3YbQX3wfi1jRxw+NbocVRTr/IOgzJLkHdfeNv72171FibxJdbTjdPf
	VuGfxA2xJAJfCQacoOygmvEXGbRpJJWFNK56WAS0x2c1AGMlSf1vO0t5xmGR6A7vzeu9kv
	abUDNSt53utGvN6VMDjShZP04ysFRmo=
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910cadeb0so14592785a.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790101785; x=1790706585; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IEBH2G+jGtGbGG4yhB6a6/Qs6IdlZYnf6Lv/AMN6/lM=;
        b=X+qdUwRSXyJ6x9pvzAK5USCzBdxAUiKXexyUrKXC75ufppYyJ2cXjw7WyjkRsFamYa
         cMh966maeZx3LgBh6cC9wBCsgpTGT7tC0+E6RCEK5DDVPYO1z2PYoVmL7O0PBz0C8526
         mYtNo2OnngnUiret2R03bBzRxD/yjN5Es8utNaBUj4KXBwreuQ80spYc/htWSVEEmiV8
         KYm+wibTIDfEuwrfmtyR+tnRdrD6ba1MsdWt6FBYlkj4YFYJZdeZUYUmUXL2dfVTi5MZ
         YsBKg3D9RoasgMH518+mfNEkTiOGTz27CqVKtMM+l0ku7gdqcsm/PH/27mnqDNIoxps5
         AnJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790101785; x=1790706585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IEBH2G+jGtGbGG4yhB6a6/Qs6IdlZYnf6Lv/AMN6/lM=;
        b=MquQDZETgru6lUAaYx6HUaQ3wEbWJkgTZEY3iWeYUZu4+piTMref96EF1zwZXwDHDD
         eE8p7eRvULA4YcfNxZZzFViUWbn8rHVB0IInNhvJfIq14lJUQjonLHoeOnoe2anMKVNm
         E0DG+XXxk0N+PzUB1yhccEamyUZDra6yvzp8uw500yw5x6E/oxQSBig/G/i/ydJ31oS+
         AWqUBnG1NojRIb/G0v8Lz91gOoPFhHVE2GHOiKS790S1kzCdSagXWqyTg7Nd/CsfYlp8
         eI+IuC/fKmmoDtXGayTykOgFoaYcI30bSf/LE+hIGGxkYUWvmJfmVzyCJ3YkWjeZif7A
         rwyA==
X-Gm-Message-State: AFuF++nGh8yrB2hWq9owHEVpdmkunG1DCuDzAdoqC5lNkyu62etiNSX+
	ynjQKDMv3c8uGd+1JbQw9luqZ19kNpmZT74CvSG1dkehnXDWq5Jh+Y4FRHtlMNfts4HGU7KR4wR
	rW396P/A=
X-Gm-Gg: AYBFou1gntvhkNDCl9yxOp6gTaUiOQ5QSdvhSNo9M+XjEANBhwGEY2PFRfyq8OoQa1u
	D0RS5AdyqDILX/rnVwmmmDPb/1CjA7f8N9cW0dWeGFaXsuf1/DpNbeREXmyjQfJRdDcx9Ow00ba
	K/3fl9jzwbQRTyEozzRWZ+J4WTzmjcbS/AUtiFkdX0OUEcvS9IvAPNtFtKXm8Mp10Lheiz8juQt
	5FMrQVU4tl717tJ8LFmOIfGAdrXkVnCo7MiCxRCFg5o0eyvNTuyLbX/DlHWLOl3shNYtLDt3ICk
	PsvXP3Dl4HLP9yFwUt1VlhTi7+J9ynFQDIIqabjEJzbdcKDDCaxW+P7jHOmebUQ4xvjZ1QsQnYN
	2hB8PDchOpyFTOjGzQrbJg9y44UsE6KWdMuXfJ4heQgTBHDnAcbtbRJqwfJZu6Ywd5kMQpO7fwp
	0mU1Z0GURBMN4FmBkctRyUgJtjKGat11yJE/KtqTgvAiFDOutslW8QFhXz3YqSRpUMh7UEMCIXC
	4L2s3e8GcMts/okp7G9IKZtl3D/bKDZe+iZYs6QjgfM6FAJDjcgxy3pERth
X-Received: by 2002:a05:620a:29c8:b0:939:2c5c:7977 with SMTP id af79cd13be357-93c250a3567mr41425285a.20.1790101784800;
        Tue, 22 Sep 2026 11:29:44 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c24889ac9sm37130085a.27.2026.09.22.11.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 11:29:44 -0700 (PDT)
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
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	shy828301@gmail.com,
	raghavendra.kt@amd.com
Subject: [PATCH v3 7/7] mm: use VMA flag helpers in NUMA balancing
Date: Tue, 22 Sep 2026 14:29:28 -0400
Message-ID: <20260922182928.2199090-8-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922182928.2199090-1-gourry@gourry.net>
References: <20260922182928.2199090-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: izagatr3j96sphuae6aczihu9ftq4mk4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A8BBF1C000A
X-HE-Tag: 1790101785-841167
X-HE-Meta: U2FsdGVkX18i+d8SdujCbe3j3fp3TF2fIep9FbmJdBpMTn8/yffOV42H+3Z+Y6kljUoj7i1FEEp2/n2JOgNSNGrjOlO4nsdWYWM7smaLVFSv7tE4B4GDEqColr3X4cbhHGd5NTnzLqp8uOedIvXFaAjMsbmGjXE+hjvepPDfy84HHrWORh6YNNS6IgVtsB6kuoFb/ZGMpo/fLX3PjYavofij5bhJrcZW/bAXV2kIxPnrlihVOulU5zBEf/uUxTdlS8UV1JUhAK5B1oEfQBhXRxPiS8LdWAo/z9Lpljw8Co9IktVTigZoEVvMMgXKslZpgexJT7PkKHXcxTcu7lO6cllbEl3J2Du62E7lTTVdjphB73j6SY9sNyVoWrC+R4DRvfXJPah4vZ89ljNRC8XNOi50lOWW1EBK+H2+ngHGqUw+eia8IugJ+iscgIMZ8qh3BFqDz0mGiRBl6qW6CD6azssL7TqOFvoF12qUzDFBfPXVHNmLiBeokUZoz1B4R+S04sqdcvVhqeZbsHFifBTSLC6FnQFwEgjpjEZKYIpm3RR6y+vQmWQCXJiJ9JqFpZsgc0wpWQXUEDeQaGnhraamyvyCLquV0ONeMt3XU4d6zpNA3afMORvUNMKoGe4i7dZ8z/tMiBaLAdhnKFIX4aTmLZSx52bI4p3ucIKVbQQiOqxj9eiowpZyU8uP/eXdhhvTFqMnhXBDDBvdu6wTy+/RudsLAnW+PDoCGOE5+1HD+PnJ1jaXjI6W9bntyGPm7L3b6HEttJdhklpYTcfX9c/+AI/P+OwOt/m5MenGyWUziPtX0pOBu4G9msQvE+bMh/CdeULMK98cakZ6ymDz8IKd2M7xz3XmN2y+DNWE1sWu7Hzuv4zcwZGXwsbDO4ZH7yMvBuegrggM+4km3gEG1Tymvpc+19j9CdoK5XBQzv4RAhG2gkhTLtLEwFOs8AqKWSglDal/ivczFZ/iC+itAun
 YXUrvKxv
 HPEIwTzUl4lH/tOyIWzXVKdsfXPU0sdJ6G2KZtWBkx7B+FOMt0hhAYlA6HnnbkjMXQ9KDTS3OgbjU661GbCA1SyvHjZl2LR4yxPOO5+NecYT1vf2/+VXLtjtc2AVyBkqNLOEIcdSJX8Fx0a7cVR2Eb7JgaXON7dQe/bRafuZebBDztmq66Fu8Gyk93Rlqb2uFCz5vBytGykZ9WuN2yDYdHRFYxkl9QanZkg4qtxAXre5DBlU2ALFasWc4BJR7oXyDrJhgj8WamEq+zBAggQoKOF4nbi/fT8CgwzwQ0f+HUcUOPWEzJM9Sk3raVSDhPff9+hzvGuWvige30L4BjOmwLnrsKnJO6NV8mA3+hiiBFlYRSyHGo7BjS5KkJBD1mmHr8J8LbKYvnN+yWHHR93TXJYEHUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Gregory Price (Meta)" <gourry@gourry.net>

Use vma_test() instead of accessing vm_flags directly in the NUMA
balancing code touched by the preceding fixes. Keep the existing flag
predicates unchanged.

No functional change intended.

Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Link: https://lore.kernel.org/r/aq1FDhy00epXXtgd@gremlin
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/sched/fair.c | 3 ++-
 mm/internal.h       | 2 +-
 mm/migrate.c        | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 412c72084a63d..0d48d595740bf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4224,7 +4224,8 @@ static void task_numa_work(struct callback_head *work)
 		 * under cache pressure can drive considerable bandwidth.
 		 */
 		placement_scan = !(vma->vm_file &&
-			(vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ);
+		    vma_test(vma, VMA_READ_BIT) &&
+		    !vma_test(vma, VMA_WRITE_BIT));
 
 		if (!vma->vm_mm || (!placement_scan && !tiering)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_SHARED_RO);
diff --git a/mm/internal.h b/mm/internal.h
index cbeaf1fc38cfc..560406c36a757 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1240,7 +1240,7 @@ size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
 
 static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_test(vma, VMA_SHARED_BIT))
 		return false;
 
 	return atomic_read(&vma->vm_mm->mm_users) == 1;
diff --git a/mm/migrate.c b/mm/migrate.c
index 6a08690cfe219..8e1e5ff1cb580 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2705,7 +2705,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 		 * See folio_maybe_mapped_shared() on possible imprecision
 		 * when we cannot easily detect if a folio is shared.
 		 */
-		if ((vma->vm_flags & VM_EXEC) &&
+		if (vma_test(vma, VMA_EXEC_BIT) &&
 		    folio_maybe_mapped_shared(folio) &&
 		    (!folio_in_lowtier(folio) || !node_is_toptier(node)))
 			return -EACCES;
-- 
2.53.0-Meta


