Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEDB4606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=IRQgGA9d
Received: by kanga.kvack.org (Postfix)
	id 8975B6B05B1; Tue, 20 Oct 2026 22:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8495A6B05B2; Tue, 20 Oct 2026 22:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75E0D6B05B3; Tue, 20 Oct 2026 22:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0436B05B1
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:39:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEFAE40463
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:55 +0000 (UTC)
X-FDA: 85345078350.19.FE68C04
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id E725580002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:39:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IRQgGA9d;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7QVMVg0G5DwyEPbJ20bA+yPvHu9eLQ0AyyKAfGn2Dqw=;
	b=rkCuJJ9m+1hoCTsYlQ2v1qf8kZva9oMyWcbmn17wHAZ9DP7w5eVNvosOD20suH3fnyZliq
	t+kQLnGM/40nH1tL9xwB/nX2Dii3UVZ6E40XSkf/wqwX4RQ5ZDVTjKTxlsUtt27VFBzx0F
	8BVOrGi5/kXZaROjkVbtVQhQsad6Ahg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IRQgGA9d;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.48 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550393;
	b=0W6jE+bXZw1jxyyTpRHnbkDIkvgGRhEfmvmvmEz81+tW05akl/OeHMGu4/UmdHyWcZzpQP
	fWD1Dlw1OSPGnx28KAXuwjPq+cs73Qinf3i31xrJ2+uRulhFElUD0RGUBEDeJEPQRyVNtV
	LjiYl1jndVqdUefSSo2KC+C6NUNgv5E=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-91beb36fcc6so2410716d6.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792550393; x=1793155193; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7QVMVg0G5DwyEPbJ20bA+yPvHu9eLQ0AyyKAfGn2Dqw=;
        b=IRQgGA9d2ryDGgJ5xhjEdN7062PZCABrwS7mKRBNMr6bCV0+urKgix7ZNHcT9V/nP0
         T1TSuBOIqp+okQw+EM58xH+oMt8VN7EwMfdaauP+Yn3GnXp5umLckI0aca1y2pk/E5E0
         N6zHGZPmDkl7ebWRAK8N1nWZ5BTBmgAOhtWq5w7bvoqkqa1qzY7slWyMo5VtnugsGj2X
         8tY/NLA6MFtan9+6UcRn7R8GwklTEM019qb6LsVclvC27d4na4up9+LkUKC2HET3CViM
         NCgtTAmTorVaezcKuVyrhJlpPWrcYfT7ne2RaZSk2i8nq1faZlf8/5BDcYB9e8aNOgfm
         oLvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792550393; x=1793155193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7QVMVg0G5DwyEPbJ20bA+yPvHu9eLQ0AyyKAfGn2Dqw=;
        b=wM0ByYg9Olp/y9nT6maYLwUuCt8RHThn+gnFDtC+fVxm/Tpd5xONJxGm7KaAbUmvlP
         5SStAX2e7/VEZNCdig0QY/6XBhiZE3b0+8VYqswRftemSjD2QB5+7DjJ3ojozbG+c4by
         PEG8EO/ZiVJr3c00NJ/xacl71sl36gK7pXngK/0f6KYjTI/t1/jJjC4GIJt+83hkvw7w
         eHn5grTrXSB5qwBOi6wQ+sgjqBGTFiL3K76az3QXdMUCnhRIChRm1dRVN4qz5b0g74Z8
         LLJYpszlsBD1pidNGQ5qxFJLZN/yeKXURzSuqJcZpHIH04EjGqWC5RYGi2NyR3H4zNIL
         DALA==
X-Gm-Message-State: AFq9FYLfejNZFf8RcNfRMVKxhs5aVfK7KSDTB7OOwGmAM/yLj5tpEq7K
	9c+UtrlR1m2TfzID6x28EIaBBa1ei9fUL2q0gcmQcGMr+o0T0wEiyswxQFUltbeMf+vWRWiuXMh
	uOusk
X-Gm-Gg: AYBFou1IdwP13z8e86N739+ulnuNI/6x6ZiJMfO85bmQtqrQNK2XzfV2lhnKll2lJHg
	qT7KE3n37pq9MmZtpHO8+EzyGB85XWg+56TZWVcmEmRLVlYtgSRIKsfEa6enjXoc3vJqH+olvDv
	bC9lq27OkjsmJXxISt9EsW0mVwefBlVqPsMQsQNMuKEhmJYLFLQgrfTickZEI66/ueYPw/mxREE
	A3KhzFpYg93HpxanY3X6dFqkToppYqYXEFEEYXUBGYSHNBQTYtASPr8Lm9jjBgNQUI9Kk84SJNv
	tgKUN6HnE1dzZU3TXRuZZ2eWfaGB5qjZIXBrXQv3W00teOoeeHle3YbbDJiqEwFVh81oOPyZGU1
	ValnV0IlpEa5vR4nfNIvwmM4rCt+yGdwJg06n9Ffcm2w0KhwFdGZ6PRmNnlLDaWWjYSiKkX2C5L
	YB1v/y9u1WYB++nClwgA9S4z8liPvsvmxLdvPk/mSxyA9EoMYjtIkBMAO7R5rF9eJtjJqZW/95E
	+mDDLJmTl9/Ip94jIGR4MIvlIN8IV3t3hncWpzvf2uwx4E+RVDUpFsTu9AR+7tA3pLO6jM63zfK
	jDou0KUHeVJBj6NyxxHDEyKp6WkuzMvZAE85WSTkLA==
X-Received: by 2002:ad4:5d67:0:b0:91b:d948:c415 with SMTP id 6a1803df08f44-91c12f1de15mr12928996d6.44.1792550393065;
        Tue, 20 Oct 2026 19:39:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10a45336sm13819426d6.3.2026.10.20.19.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:39:52 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	mhocko@suse.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	stable@vger.kernel.org
Subject: [PATCH v3 5/8] mm/page_alloc: retry allocations that raced with a zonelist rebuild
Date: Tue, 20 Oct 2026 22:39:37 -0400
Message-ID: <20261021023940.1940971-6-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021023940.1940971-1-gourry@gourry.net>
References: <20261021023940.1940971-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E725580002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ng35mykw5uy7iurgm3eo3ogjud6nxzdz
X-HE-Tag: 1792550393-242620
X-HE-Meta: U2FsdGVkX1+g01VBpHBODbLTpw97f+ig/S4WCVgPC8s2lvHRWf9CswyzUWsone20e153M/WSaA13jDag07C+JwN4a+DJTGLGkmJxl+mRB2YzorWM37fgonQDhSH7TPkJCZSQMxC+oOfCRXHRjWvl3BdNGFb2GD9aZE/cCSzPFpnf/Y0VPOlIiA9qWwxL5kog5ux5F7zdVLy9SOBDYKEgIaVV5cdGM2MFBiFxikWuz+NvxzRikuA4FFddSwYwg2aSQO94leMSo9cRZDxhTIbdIzp68E2O/OC77SpERlwU1amoW7udrC3ES5EVHqqknwOP0HUC5ec+GuKSdkcCYgsMemcBC9714nM9zxCpDRE29+1hw1XzoPbTTo5jL9wA0FnQ3Q/c6VYmcT+n9cWcNorWtU0bw+DqPhZKutUbEkLZDWNF6+iNlLQuPaYmfKm2mxuLCVFeBKsvFGF/wo/jXawcF4OUS1iQ8on5p+1B829JTlop5pBYS1zjn711o1PzHsQtPoaoXS4G4TNaQIyum8ico0u8y13evN27Z5xoIRQwnj0mzDbm0CMbqG3NMj915v1x7IULXi817u75SOPQhSu8/453LXb2AZsLcUS0OheLc0VyTGJit7kLtlD64lCjuQHIPWmtzfZgmFVv+CTugX1zSKBE8W7BoKyIjwpwR4yfkV9zMWjr0jhlz+CGp06lRkG5mBYfR6UMbZenvUULDqDpM5C9ub9+CrX+AyrfvmCfFU14mAY3PtnQfCgjNl2BSc9oboi3SiKA72FaBhS+1dI70+cHiGfkcHe7wE540YNhcZM6ZpXA6MhqtMcM1rPyZVfdGfLVHUGgBs2ayOH0JTV2Jw9Nr6q2lMePoAj75dOf/J0r1DvF/uuteIeKhSRgHDWAIiyLvskygqux9iUiehd8ZWw5ASyM3gmoQi3d8H4rHMWKNLksXq0r7Zvrij2M8RR5ClG+TBnJLuREJxrMKMw
 KHm4x30T
 tNc3JXfrokEHZjXUSWqjgGGRNJJsNIalmdkTMnDsymiSZdydjHTEkc6HyuXrqZF/IuQadon+OVpVRUEo9IqJw51pK8BMn3BEYUGH6o04pQdt1e2o0PFZ4x9n6KvMctN9pLQu0XTcgtnEf541BY/fKkU+cCIeUiAJbA6yZk7wqD95AomapoeuiYZxnvHuts0+37cG6u+IjgqVpvV1Iz6MYxf05uB9Fo8pFBwxXOJIZ7oTsLRSKgeuiHm3No9ObVyDMOjkETTgLteaUr4V4fKulc1qhnNONaMIqzA995gAUnwdBJXMqKIEaoOjmyoceoDCm14HULQ0CKx5mohLK7MKf3cfjmPIdH5LukW+WpbAvVJaDDH2h1VGlm7QqGZjpQHNJppcXwnS3Cjgwkoh7yxwvhgtYHw5r2oX3A1Fp5fS5PCqMK/qpG9smK6Zg6WxFbGsTNgZP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Onlining the first block of a zone rebuilds every zonelist in place,
shifting the slots after the new zone. A GFP_KERNEL request can then
land in ZONE_MOVABLE, and a nodemask request can land on a node outside
its mask.

The iterator approves a slot by its zone index and node, and the
allocator loads the zone from the slot afterwards:

  CPU 0                             CPU 1
  prepare_alloc_pages()
    first_zones_zonelist(nodemask {1})
      slot 0 (NORMAL1) approved
                                    online_pages()
                                      build_all_zonelists()
                                        [NORMAL1, NORMAL2, ...]
                                        -> [MOVABLE1, NORMAL1, ...]
  get_page_from_freelist()
    zone = zonelist_zone(slot 0)    /* MOVABLE1 */
    allocates from MOVABLE1

zonelist_update_seq detects the rebuild, but only the slowpath's failure
exits check it, and this race ends in a successful allocation.

Check the count whenever an allocation succeeds, and free the page and
retry if it changed, as the memcg charge failure path already frees a
fresh page.

The fast and bulk paths sample the count without waiting for a writer: a
sample taken during a write only costs a retry, and a fastpath
ALLOC_NOLOCK caller can be an NMI that interrupted the writer. They read
the seqcount inside the seqlock, because on PREEMPT_RT the seqlock
accessor takes the spinlock while a write is in progress, which
ALLOC_NOLOCK cannot do.

check_retry_zonelist() now returns 0 when the check is compiled out, so
a backport without the hot-add change stays harmless.

With kprobes holding the walk across the online, the base kernel
misplaced the page in all 18 runs, through the fast path, the slowpath
and the bulk allocator, and none was misplaced with this change. The
check adds 5 instructions to an order-0 allocation on x86.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1bb308296fcdc..dd8c9046f9a06 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4419,12 +4419,25 @@ static unsigned int zonelist_iter_begin(void)
 	return 0;
 }
 
+/*
+ * Never wait for the writer, which an ALLOC_NOLOCK caller in NMI may have
+ * interrupted. Read the raw seqcount: on PREEMPT_RT the seqlock accessor takes
+ * the spinlock while a write is in progress.
+ */
+static unsigned int zonelist_iter_sample(void)
+{
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
+		return raw_seqcount_begin(&zonelist_update_seq.seqcount.seqcount);
+
+	return 0;
+}
+
 static unsigned int check_retry_zonelist(unsigned int seq)
 {
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqretry(&zonelist_update_seq, seq);
 
-	return seq;
+	return 0;
 }
 
 /* Perform direct synchronous page reclaim */
@@ -5114,6 +5127,12 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	warn_alloc(gfp_mask, ac->nodemask,
 			"page allocation failure: order:%u", order);
 got_pg:
+	/* A rebuild during the walk may have handed out an ineligible zone. */
+	if (page && check_retry_zonelist(zonelist_iter_cookie)) {
+		__free_frozen_pages(page, order, FPI_NONE);
+		page = NULL;
+		goto restart;
+	}
 	return page;
 }
 
@@ -5198,6 +5217,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct list_head *pcp_list;
 	struct alloc_context ac;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	unsigned int zonelist_iter_cookie;
 	int nr_populated = 0, nr_account = 0;
 
 	/*
@@ -5238,6 +5258,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
 	gfp = current_gfp_context(gfp);
+	zonelist_iter_cookie = zonelist_iter_sample();
 	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
 		goto out;
 
@@ -5287,6 +5308,10 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	if (unlikely(!zone))
 		goto failed;
 
+	/* The zone was chosen from a zonelist that a rebuild may have changed. */
+	if (unlikely(check_retry_zonelist(zonelist_iter_cookie)))
+		goto failed;
+
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (!pcp)
@@ -5427,6 +5452,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		.alloc_flags = alloc_flags,
 	};
 	unsigned int fastpath_alloc_flags = alloc_flags;
+	unsigned int zonelist_iter_cookie;
 
 	/* Other flags could be supported later if needed. */
 	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
@@ -5456,6 +5482,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	 */
 	gfp = current_gfp_context(gfp);
 	alloc_gfp = gfp;
+	zonelist_iter_cookie = zonelist_iter_sample();
 	if (!prepare_alloc_pages(gfp, order, preferred_nid, nodemask, &ac,
 			&alloc_gfp, &fastpath_alloc_flags))
 		return NULL;
@@ -5472,6 +5499,11 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 
 	/* First allocation attempt (or, for nolock, only attempt) */
 	page = get_page_from_freelist(alloc_gfp, order, fastpath_alloc_flags, &ac);
+	if (likely(page) && unlikely(check_retry_zonelist(zonelist_iter_cookie))) {
+		__free_frozen_pages(page, order,
+				    alloc_flags & ALLOC_NOLOCK ? FPI_NOLOCK : 0);
+		page = NULL;
+	}
 	if (likely(page) || (alloc_flags & ALLOC_NOLOCK))
 		goto out;
 
-- 
2.53.0-Meta


