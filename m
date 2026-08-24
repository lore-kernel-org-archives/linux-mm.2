Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 110B6C5DF9B
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21CB86B009F; Mon, 24 Aug 2026 10:52:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F41C6B00A1; Mon, 24 Aug 2026 10:52:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095316B00A2; Mon, 24 Aug 2026 10:52:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD8C06B009F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:52:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3605212018B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:47:29 +0000 (UTC)
X-FDA: 85136441418.28.5F153B2
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 67E09100008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:47:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tbsV4/RZ";
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787582847;
	b=qA/+0EaaWn/J6iXVJU0CJYgJzGXdhA7+FT6bJmdXhZQHEQj9t35vC7zqUW+IkNMbZFyBfJ
	YLjityPRn837IgPnYR1/QT6uuQ7XWcrU0A15ygJ9aoKNNgzqPBVFrNedlqvgE9/ruGWup/
	HamW2aVyuqKTPB8Aqyo07cSjUKNAxIE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tbsV4/RZ";
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787582847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ep6UPzJTnZmCqVomVSsdJlCYmmRG8TZidgjUjwtvIo=;
	b=IC9TMQ4kru448jwVVmaHx1CCPjjSQBVmSdmO8PLl/eZadHFla4PW71anko1oOkkEhCok/z
	U3n0H2b9lA3tVS2Y5KqmzfBS76SYKTnkp9po4aqVp2pSr4v8ZLm0qbewnChfUUPVHkQSe3
	2MM79EVsKaMOt9aI4pSv9vuN255hMOo=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-81f3b227a4aso55479177b3.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787582846; x=1788187646; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0ep6UPzJTnZmCqVomVSsdJlCYmmRG8TZidgjUjwtvIo=;
        b=tbsV4/RZ/Hyy0/P/9Cwt4SxEXNH2fBjePuezYRqh061e6co1yI1MULnWrepWL8wCFt
         lbXjmo/K22alyhs+LTo0yjXqwgwI9KS6nLgIwh9xgpt8RvPrkZNtRhDEJva5PNK+/WI3
         lmJY8A7cA0DPj7dP4fvF7/6NLnR94byb5ASRzM2rA16QjQjdmE2ho8pKKyTmB1Jb/gWM
         ckQKbdZ29WKZOz1SG+0P+hXDR6DcOxBFgp89DlfsltYIJC4Kaks07cAdZTJu62xneJTQ
         +Mqs9q6vPLE0APLWvKE7Eu2q4T0IXleBQgbmmU6tmwA1UBVFeZLWL9iaD805kV4vU7Ux
         nX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787582846; x=1788187646;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0ep6UPzJTnZmCqVomVSsdJlCYmmRG8TZidgjUjwtvIo=;
        b=e3AX0w1Rp8rDo5RzrWB9gCRGd4zaar0lMY7soYH+/JaW2iOUmmImpUGnXaMqxz9UG+
         31CcRk3CmirBLv/16v7vOJldsjmFVGeqA/t0WUkcSnJwud5B9vbZVMiT32EBCztV3kgH
         rVy0xnWGLluX/gOKuMH/nkMAx3X1OexAWCgEKOclZ5XlQjCUEvYodrIBtUz1TSEtsnlV
         Pa6MeP+rvOiFdsneL4Nbt48v45C8FEr6gO/bxjRjKZRnDRqAHeThaq4YsvGhAOthybtn
         Y6bV16hSB6+dCOTvcO+fzC1rPoLoegqKbEDta9V2/OP2uz5PAcrR8O+NjU5gpCz7zL3O
         QZvQ==
X-Forwarded-Encrypted: i=1; AHgh+RrFxTfVyw0aH1Fh01Fu0DqByfSbfnJkG3DWxpOpf9RyPLVGoEuvOLLf6QYMjYoY1fvbjbxTMZyh3Q==@kvack.org
X-Gm-Message-State: AFuF++kBEGsVhLQ8Dg4TfOw/H5X74oKKU2cCzQy5WW8t1fFBQi1pgFBD
	mW6Bj26aLSd9MfpQoaxndUChhSaHiiuwPn2NDJWfBiDJjIWsHtr2DsnUrcA/NuIXFkApCTJEuLZ
	EtM+bPTyGljo=
X-Gm-Gg: AR+sD11WgPQYZd8tWu4WBn8Ko+7SR/+EWmYyAmwQF2FQLqFJoPvqaCiONj1PcDWevCh
	IlFH6wH38vOf5ZKv9FC1AkLfgUndqbDdit+kisVhXkHvBB0uitc9QhZhJD5qbPjG8KXfnwP+4nK
	OMf9EGnGHtX6JcHEkKI+G8mtAxaS6KA+jwgvyYJ4lpkdHbpgtbTmPxlAAPQbbl2sYQwTvAPlD7h
	6iR8U8p2uYoOf5JbK6vv0ZIVpMqNRUt4YNVdrjeOJ0e5sGVNVLnusvimvFFOmZO90QCC49pySkQ
	aOHgXTtZ8zgFWyFsVdsVrjgpXDHv3sDvXXJQ3jJ2Ej3BQ9BWOlcKr05ogOcuVIgXkDdl629TVmu
	h+LTRR68tH2yoMyVX4PDYlBpo87GGntwfc2KsV9AY88PXHFQ3ST2CJYAhr6fWFAuTyZR6tzn9ME
	3Rf/EJ+i7+MD6rfcUFurLv2fRb6uW/PDPgUzsQcTyz+tVN/ugFUmqs/xAJT4BR86bmIjSE/mRRo
	hPihtHjr0eYRad/CfEEw7IM6rS8NmUqMTTFm7QD9/qU7cRq
X-Received: by 2002:a05:690c:e013:10b0:7fd:a7b6:8d87 with SMTP id 00721157ae682-849f5a102b1mr80844207b3.25.1787582845685;
        Mon, 24 Aug 2026 07:47:25 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84caabb9e88sm34369867b3.29.2026.08.24.07.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:47:24 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:47:20 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 23/25] fs,mm/fbatch: use invalidate_bh_lrus() not
 invalidate_bh_lrus_cpu()
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <bcf84f86-66ff-39ef-10ce-eaa133404b50@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 67E09100008
X-Rspam-User: 
X-Stat-Signature: ydo3b3qxjdsccy59u7rg31kx8k9bjebz
X-Rspamd-Server: rspam06
X-HE-Tag: 1787582847-811122
X-HE-Meta: U2FsdGVkX18Ux7uUJL35kdjBYnwyfsvWhW4IabiIVj5WU73uTrqzvRImBwgwgGhTOJOu5OBO5MP2VyFJTEGB1YeE+PGmYwmAkZ5WCIx1qKKxi/PJ9T8fYInFNjex2m87Az+Uk9wyDw3ZiDGOh76kNLdI152k5oYRkosvQkOcGmRMOqH7RlQEuhPoFesk8KY6oZd2ndd3NR2FJ7fNsjeHdeHKu1AB8nmWkBZxiNplMMXGF4cNZoVcHxcv9/IYX09rmoTrc5HyV2Q+DHYnoG2Uo48H2h2a7cD+WE9m69NgBFUaRlcGsTL/VqOYrdMB2BdwhD52uzcLRzgunXuwZspEpNQxr6QkasIwBiZzRBy3OoxXILoRE3Ypa4x2/+VkAKPUU8rNY3RqJVtAIkAMw8qxqky/P//GY54WRLqx5I9i9sg0zN7F8aHbBGWlaaUl+Ap8fkj1jjz1CsICb2UX4EUssxCx44QMN5f3ksrc4JHx2edw6n7/gK4NragcUsz2K3m6quVuMF43jJyBC20gKgy0Rix8eIzRzxQ6QSfMOnCImTNKJlQRwCgBcc+14xAhvYqvgyGYbCGl1otWqkpb6oqkZNuAdXxKJcx8NtgKw7U8O59ig7/7gGk0UW1wQy6P533HKg8cCIbGq2HB4M5Xdxa0JEuPueIE9VMbCgE+BJFNLEzz11iu/ZC8tt09+3fcgzRD4sj0gBj8H/hQsGGqFIhF4uP16irX8SGQ35KqvnexGCPHOzdd4edQxeJksSbAZuc0f/DaCv0ZEY6/qwj2OfNsJNEE4PLlvlkQKztGAslIt3XQ8EDfUVtwkL0rrFGeFnmI0ubriUC2Ff77zjr446eK8taAdzLW4IwzHu8/eol7PvNmGyxB0iR8SxQz+22JXj8hy21AixeayQb6ASNRFJAdMmvXlfds7vTyztVtOU9hvmN78lq0ZXMThY1T4wxEh8nLkheQbmtAiNfY3vf+5cI
 0R5G2LJ1
 7pqQjAg4mrXfkumeZweMDeBRuEdMklMvnG3hwuc40C/6irmE/tpquF9pzUGFWtoUsZQw5iBE9KM6i3FxC7d9vrsKtFEE2r9xIAQ1mZsfAgLBzY47Hti75aVR8Sb2LGB68y3P/Lszs7T9uzNVxv6Z+1B5tKsBHT0NXqY+souyWoJELG2g2TeVrnmZ3fGYw/7kYR2Vq56UJPCc5a/QRyaK37oQJr+5cdB5KszQpBSb7Zy5R97kAJuYlcVayvzkzt1jpf+mvEwYiPegiTCVoFRtwa6++2s+AjptBmUQ+LRFFQLE4/iBO4MiugbzWXMOUt5Ytd7cfO5Z5TQGgiLjCxl8Lpq+a3WTrg54SeUug4jds/dypyQNzB7THtxLkdUYQ6XgIAP7zHVyBef7s+sn5GXD2Eo5PjTIfqiEDmWY0VcY293ugXDatqKbR/rlVD32UFSAEa5hMNfkoJw7wfVb6hrvF/GmOtpFQ9kPMobfd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Whilst there can be a case for including an invalidate_bh_lrus_cpu() in
lru_add_drain_all()'s workqueued visits to remote CPUs, wouldn't it now
be a preferable cleanup to remove that alternative, and stick with the
smp_call_function_many_cond()-based invalidate_bh_lrus() throughout?

And fix the UP lru_add_drain_all() to include an invalidate_bh_lrus(),
which went missing when 5.15 commit 243418e3925d ("mm: fs: invalidate
bh_lrus for only cold path") took that out of lru_add_drain().

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 fs/buffer.c                 | 16 +---------------
 include/linux/buffer_head.h |  4 ----
 mm/folio.c                  | 25 ++++++-------------------
 3 files changed, 7 insertions(+), 38 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index ed966fa73b1b..7d114e5b9c62 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1427,7 +1427,7 @@ static void invalidate_bh_lru(void *arg)
 	put_cpu_var(bh_lrus);
 }
 
-bool has_bh_in_lru(int cpu, void *dummy)
+static bool has_bh_in_lru(int cpu, void *dummy)
 {
 	struct bh_lru *b = per_cpu_ptr(&bh_lrus, cpu);
 	int i;
@@ -1446,20 +1446,6 @@ void invalidate_bh_lrus(void)
 }
 EXPORT_SYMBOL_GPL(invalidate_bh_lrus);
 
-/*
- * It's called from workqueue context so we need a bh_lru_lock to close
- * the race with preemption/irq.
- */
-void invalidate_bh_lrus_cpu(void)
-{
-	struct bh_lru *b;
-
-	bh_lru_lock();
-	b = this_cpu_ptr(&bh_lrus);
-	__invalidate_bh_lrus(b);
-	bh_lru_unlock();
-}
-
 void folio_set_bh(struct buffer_head *bh, struct folio *folio,
 		  unsigned long offset)
 {
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index fd2c7115c054..f19f9e80be8f 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -518,8 +518,6 @@ bool mmb_has_buffers(struct mapping_metadata_bhs *mmb);
 void mmb_invalidate(struct mapping_metadata_bhs *mmb);
 int mmb_sync(struct mapping_metadata_bhs *mmb);
 void invalidate_bh_lrus(void);
-void invalidate_bh_lrus_cpu(void);
-bool has_bh_in_lru(int cpu, void *dummy);
 extern int buffer_heads_over_limit;
 
 #else /* CONFIG_BUFFER_HEAD */
@@ -528,8 +526,6 @@ static inline void buffer_init(void) {}
 static inline bool try_to_free_buffers(struct folio *folio) { return true; }
 static inline int mmb_sync(struct mapping_metadata_bhs *mmb) { return 0; }
 static inline void invalidate_bh_lrus(void) {}
-static inline void invalidate_bh_lrus_cpu(void) {}
-static inline bool has_bh_in_lru(int cpu, void *dummy) { return false; }
 #define buffer_heads_over_limit 0
 
 #endif /* CONFIG_BUFFER_HEAD */
diff --git a/mm/folio.c b/mm/folio.c
index 782b8245d213..3212c7a58623 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -748,21 +748,6 @@ void lru_add_drain(void)
 	mlock_drain_local();
 }
 
-/*
- * It's called from per-cpu workqueue context in SMP case so
- * lru_add_drain_cpu and invalidate_bh_lrus_cpu should run on
- * the same cpu. It shouldn't be a problem in !SMP case since
- * the core is only one and the locks will disable preemption.
- */
-static void lru_add_and_bh_lrus_drain(void)
-{
-	local_lock(&cpu_fbatches.lock);
-	lru_add_drain_cpu(smp_processor_id());
-	local_unlock(&cpu_fbatches.lock);
-	invalidate_bh_lrus_cpu();
-	mlock_drain_local();
-}
-
 void lru_add_drain_cpu_zone(struct zone *zone)
 {
 	local_lock(&cpu_fbatches.lock);
@@ -778,7 +763,7 @@ static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
 
 static void lru_add_drain_per_cpu(struct work_struct *dummy)
 {
-	lru_add_and_bh_lrus_drain();
+	lru_add_drain();
 }
 
 static bool cpu_needs_drain(unsigned int cpu)
@@ -791,8 +776,7 @@ static bool cpu_needs_drain(unsigned int cpu)
 			 folio_batch_count(&fbatches->lru_move_tail) ||
 			 folio_batch_count(&fbatches->lru_deactivate_file) ||
 			 folio_batch_count(&fbatches->lru_deactivate) ||
-			 need_mlock_drain(cpu)) ||
-		has_bh_in_lru(cpu, NULL);
+			 need_mlock_drain(cpu));
 }
 
 /*
@@ -891,6 +875,8 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 		}
 	}
 
+	invalidate_bh_lrus();
+
 	for_each_cpu(cpu, &has_work)
 		flush_work(&per_cpu(lru_add_drain_work, cpu));
 
@@ -906,6 +892,7 @@ void lru_add_drain_all(void)
 void lru_add_drain_all(void)
 {
 	lru_add_drain();
+	invalidate_bh_lrus();
 }
 #endif /* CONFIG_SMP */
 
@@ -939,7 +926,7 @@ void lru_cache_disable(void)
 #ifdef CONFIG_SMP
 	__lru_add_drain_all(true);
 #else
-	lru_add_and_bh_lrus_drain();
+	lru_add_drain_all();
 #endif
 }
 
-- 
2.51.0


