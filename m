Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9561C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C83D06B0099; Wed,  9 Sep 2026 06:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5BAD6B009E; Wed,  9 Sep 2026 06:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4A7F6B009F; Wed,  9 Sep 2026 06:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 969756B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:31:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 914CD120160
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:31:00 +0000 (UTC)
X-FDA: 85193855880.26.39C11DC
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id C9A0B180012
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:30:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QZ0PRJ4e;
	spf=pass (imf06.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788949858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xikkFdSddcZk7EZo4mTtVn7i5ie1aP6lqhxPtSw7MtA=;
	b=2Z17qgC1Fe2V8ByMEoUltOrNO9va7TL9e3qR6uu9+OIKqs5xOWHEe9j9hqTVpHGWbiviuQ
	FAVUMVETkvkaVEsoqLluveW2IiJRonTtZRcwftnXa6ebvvlsh081x15IIm1FHHgU+e8c/h
	8GmFPaeTHiHlgQ2Ant+f22quXFfSaUQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QZ0PRJ4e;
	spf=pass (imf06.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788949858;
	b=qdsKGh/AwNuNp8WInzUMY3M6YzfniWSgS78AvUZPAbIZN0IVH0Hgu6Ax/d6lneiL93tJRc
	aXpJW9V3q0fqjXPgCjhft4WAY2DP9/14K76gKzjseuzDscrJtFP1g16H88Q2KULhc5rWgM
	XC6tXO7ZYcNX/YqJ0VM8FSa4KICJS4c=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-861a2ae9c51so67039487b3.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788949858; x=1789554658; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xikkFdSddcZk7EZo4mTtVn7i5ie1aP6lqhxPtSw7MtA=;
        b=QZ0PRJ4eGC46P6CnmvubDfXDmO+Coq7XSX33p1PacfLtV1ksi3bXhnUULwk4BD/1X/
         7vwYlzrnQZR8CCCQmNN/toKnpJaXWP+BsDtxH1F3LzW77uxt4B7NZxWEFpgGmgbD3r82
         7kOqFIEppn0Qwjah4GSRN9WeZ/N+yr+ToSoDrqE19VxlFIW5t5n74KlPwVYzkydVx/4Y
         AE0yzleV8KDNJTPJoFfJy6rSw60fR/rgtqT2C9mXcHoaVuvJlTl+cnRy6KhGNT0I+6Ct
         jxq0l+ud6UMdvsdN/ts8GJLtV4mbsjxCnZADU4jcAyEavZ64a3jfvoPJWhPhruYfu9Bb
         Ou1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788949858; x=1789554658;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xikkFdSddcZk7EZo4mTtVn7i5ie1aP6lqhxPtSw7MtA=;
        b=fnVtWidn3Zhc56w7bvmuenuysP7T5HD0HioT7/v77ne6wRG4vAWqza100ZATw0vjHY
         u4BrJw6CcPMJCoe2/a+F5iv/GLqzSn1OVEmQZ5G+WVMJqjjSA9rr5PWvSFaFo46TMNo8
         QpX1cMIPAU5CdrsIggK6bSZIYQFUPBtBFPV2uptjcQ45VHKm1l+NGroGygPXAxRaEgnV
         n3pjocCvKGUX8R1wayKbEN0Lqu4DC/O9LYcfAafpckD1QB6oHP9UI9L5xnfAfNBSzW9U
         NAvK+bNgR/uZAklnCNUze4Fw5rMy2yWgsbsauXJV8ybse6rp/+27vMch4hJblUdM9MG4
         WR0A==
X-Forwarded-Encrypted: i=1; AKwUvBxPNvIMbbFcCko11o4HOZUpyD0L+kwfA486nzN8cKR1anhA/mQ4M17SOMfeADhydud1q7W2jR2h6Q==@kvack.org
X-Gm-Message-State: AFuF++kWOv/FirORsGH9iO7iVoCyauNJaetMakIPbuxYbbrRJSsna0GH
	/DpREX3KEN9owo9bqTySrQ1RgwYT3x5UY5rXX28VcoF689be9GZYAAmFsinL8XIuQQ==
X-Gm-Gg: AYBFou2almLqyUvH/5EcH5Chm1nLBNn8YkSWiQcuLlFMUByIkkhQq776rYzYxGnVR7N
	gJ7pqeiywUy+0HzuD+ndhBOBH2WqtoNN158gY9BmZESBQ3bLH5dCzmCpJpZPn4xSrOIgzWi90A4
	YFgcQHzQ4bxhLna9Eth/gpn/H7AH69KBnYnW7FQ09VfAgeXj5K3FGsGwBu3Ho8gPUrj+xGOIdvr
	t7ht8Ku5qY5Iy7S32BegLBhLXQDAfpoa9raQoOJrivwG8EoXWcAfdrKJMGvcmI3YCaHuBc5D38y
	SI6exLVmGqBqTSV4aj049Lc33aiCR0Q7HIm6CPJ7P9dbTteu1xcYTifAVvmIgfshTeF1u708FbM
	NtnIWMxDPakP8oNgtHzZSLD/KIUpyYD5zrzHuJJ17qPxu0uLlFCCRfN68tyVKdhMzFQlvWvZWxH
	qvmcKL6pfEucF+Lmza15E7hnJhV8nVtK76M0D/w8VJV3br71cKSi3I+889PsatEKz1JZ97fxs0j
	QRNMYT39xjjN9mhck7HGekpACd6j936z6RgdRXLgKV74x4xV+WOEQ==
X-Received: by 2002:a05:690c:c047:b0:845:1064:5c03 with SMTP id 00721157ae682-8712b59ce6dmr98838127b3.23.1788949857100;
        Wed, 09 Sep 2026 03:30:57 -0700 (PDT)
Received: from [192.168.1.242] (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714b52f641sm106441207b3.37.2026.09.09.03.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:30:56 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:30:51 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
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
Subject: [PATCH v2 23/26] fs,mm/fbatch: use invalidate_bh_lrus() not
 invalidate_bh_lrus_cpu()
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <56a1dba3-1dd4-e4dd-a38b-3fdee74a690e@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C9A0B180012
X-Stat-Signature: 46hq6aaj9kn4jfxza4zmew4wkmm9z13m
X-Rspam-User: 
X-HE-Tag: 1788949858-315747
X-HE-Meta: U2FsdGVkX19FxDXTo4vR/8TQkrvo2aGTwA5IrMjUexZhB/PlJS1W9xNIBhafYs1tZ3PClEhSSScaeIpzhRNW2ojODsjTzerTdO0Qx1De0GXgPhEpFbs8ZcvWfUE3gCJwS7GTw6bLZdvA4fe88OPQ9DCWy7rtl3E+TpYqWZQ9Zj79bale6fxb265YcyUA/PRgIWzCkyBi/xcjCttC8qv1HR3l89hXIyMxnl54bHzVUMuvhsoeMKAqmYr68z4WKN2K3iPqgDWsyqZInzBx5x5qLrIlNzyd8D19FOxs3npco3jc+eVrrFex0asa19C0WfNiiFycVc85Gc0/vrmDTnojZZijxKntJNCy2hhvGxv2I7ajI9vXRjWPVSHlVoDlYDvNDXg8lc587PmdIt2M7utEQGaaWxwUJQIOF3UWcDYPPFSfKTcuplyNkquD1zHXK9YUcxq9Mrsv/jKcIWqkUUEMaNkR0gLWfbhB5xfrhw+JAghaXFlYJKY8URNfhLhRTp+TnCnaHkaP7+rcd35XvJ0zThlSGoNzFVFQUottp2P0elZgOVJPUPo9c883/a4Mr/nhBJyOUSIkr5lINeD299E+o+ziU5uKOVzu+4K8mEg0P1etlD9aKWw22F7Bo3M3YynUUH7Zv7ZdIFSzemrU5CwTDlRDym45wpEC2uit0JlbWT0dAGz+PRV4gTOHJtpB7rW7hQUx/AR2dJqaBPuWRfDW8As8G4KT7YMlSeSHd/gYunlBezIyZ0fUCoDk4/MCFFbTixBBBMnVjk+Z+fUmE6GS4cxJCvgvQldSe39S4pdvl2FhJxzWWEIplUCveSk4iWssOJxT+Pxq05ZrDjcMi/eOm1l+/ptyztV4nEveuQgUcUvC4jOwedYVc0Pv9us+pmp8pEUvnoHQDLg5NhTJFKrcneEoIy52l1904WNtG0Qt5iKXr6UarY12NwLcz+Dx7w278/ijyT9l10akTTVA4+t
 qmF1qGM2
 2wrDA4Yln48V+AB6uDDN9LDmX/dLrZHZ1MaTmSWvlMGr9VeJ/qYLdT+f3hOT8f2cf68f/lqf+r1/Yh8j/OyDfE7TJQPj16a+omBimK3PGHvE1ZMKV0iMlVwlDzUFgMwItL9I+RuNnLCPfZynde75mGWXoGgxJnII3yiGOVG4n6ETAUIb5+NHwb7VPBUHTNcTWpxTwe6uBm/OJYeiS+uzLKSwNkMo32jS8F2JTfStQUQK7dMpIknhxvmYpkz/dTyT+aUsQTW40H9yZBIA6fdFWCahRj2IcGsWmO95u7QVSF7pIHr/6e2Kgz1HVmeqhp+dsObhMUWpsB2fsiZLHaE+Y2qOs/J/hwxAxIVu2snT4O/qlsDWnnFhM7VFSK1MCpiUATAtoy0mGObQcGrI5pa43+yXimgnaGXelSsRN5wE5eVienhbvaTMwohZE0lyOqWc6xTf3+pZI/0bIshxJtPheQw2VfrXoT/3yMNtb
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
index d66aa2469e86..dbad66e805e2 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -681,21 +681,6 @@ void lru_add_drain(void)
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
@@ -711,7 +696,7 @@ static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
 
 static void lru_add_drain_per_cpu(struct work_struct *dummy)
 {
-	lru_add_and_bh_lrus_drain();
+	lru_add_drain();
 }
 
 static bool cpu_needs_drain(unsigned int cpu)
@@ -724,8 +709,7 @@ static bool cpu_needs_drain(unsigned int cpu)
 			 folio_batch_count(&fbatches->lru_move_tail) ||
 			 folio_batch_count(&fbatches->lru_deactivate_file) ||
 			 folio_batch_count(&fbatches->lru_deactivate) ||
-			 need_mlock_drain(cpu)) ||
-		has_bh_in_lru(cpu, NULL);
+			 need_mlock_drain(cpu));
 }
 
 /*
@@ -824,6 +808,8 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 		}
 	}
 
+	invalidate_bh_lrus();
+
 	for_each_cpu(cpu, &has_work)
 		flush_work(&per_cpu(lru_add_drain_work, cpu));
 
@@ -839,6 +825,7 @@ void lru_add_drain_all(void)
 void lru_add_drain_all(void)
 {
 	lru_add_drain();
+	invalidate_bh_lrus();
 }
 #endif /* CONFIG_SMP */
 
@@ -872,7 +859,7 @@ void lru_cache_disable(void)
 #ifdef CONFIG_SMP
 	__lru_add_drain_all(true);
 #else
-	lru_add_and_bh_lrus_drain();
+	lru_add_drain_all();
 #endif
 }
 
-- 
2.51.0


