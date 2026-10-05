Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80D41CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 06:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DA186B0088; Mon,  5 Oct 2026 02:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68B806B008C; Mon,  5 Oct 2026 02:35:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57A346B0092; Mon,  5 Oct 2026 02:35:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 263B16B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:35:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A374A0129
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:35:28 +0000 (UTC)
X-FDA: 85287611136.29.E7524B2
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf29.hostedemail.com (Postfix) with ESMTP id E6E95120005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:35:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dmnZGsSD;
	spf=pass (imf29.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791182126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Uk4knJvNCd2gZ59g/hSQzEEij2193g8fgyNRYXAesqs=;
	b=Puhmce21vRIvHq01LC6v57nLMAgvk851+oxd4tqdMjRKQCvYFdrFzakW+Q9fIBzXAv/Ypl
	0238xhpP4F0sBhbUWuvw3p4bj0vuu5PTCMGDO/YGbeE3lhc4MbV9NPvax73+hV55Rdq6if
	h8Kyi2dXS3exN3XafRPFVK1wCEJ63OA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791182126;
	b=rlJQHCfX4PAdbMgMWaOArQjxWaRsgJyY1rSxYH4h7pAdId2HP/t8G+2+Jke3x6bG8wThgP
	r2BfX5PmBhCOCOCK8oIhTrLBmrpcVDxxwxlQ6+YkAFTuvmarHhWIY/rCBw6teVzIcZ2grC
	A5Ypj73/4RZiYV03nuIdifJAjFKfk08=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dmnZGsSD;
	spf=pass (imf29.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-4a0280d4f56so7991865e9.2
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 23:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791182125; x=1791786925; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uk4knJvNCd2gZ59g/hSQzEEij2193g8fgyNRYXAesqs=;
        b=dmnZGsSDXlmuVUh0zFDiDiyX7qo8xfwhW0LpYUavD6GAo8egk88Mj6eTPY8siDGctl
         tkih440dtP9INidXfnuG2o2h65V1VOUVAo6HM0SyLPoqqYegC6L0krTjiWIL4W/fOvKF
         9YlQf67/zu4ws7BYberltuc/2K4BQLjc9MvisslT/Mt716Ej0p2iwMuzq5p6nX86xZEb
         tAkD4MWd7GAjPyyXmU1G731YAxgwK1b9BwgL1cEiMzHrHnDUw61LgjYk3wa4Ql7cvMDD
         4XqqbYTbjK4nwt/zjv9kOUAzDpDD4s2am+ar36FQQkXM+XsLa23IaspAH7khEpVlQz/r
         AcXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791182125; x=1791786925;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uk4knJvNCd2gZ59g/hSQzEEij2193g8fgyNRYXAesqs=;
        b=PmmS2M5KeyNDlVtquqpKZ7ZNJ06AMTadveEjYJjD2vQujGzJ120GtE2azYXBUpoGZo
         0vN2MrGL1FgaHakjR5HjvfiuNbHUzHk1b/8b5hmkz6JubyNduaCnAbQ/9Wrz/AU93/tX
         LmfCbHr6FfwhYZO4MixA20x6aAH6KdQYT288+/qbWsdLB8GC9ywUWr0/fdgX2x/IFMu6
         XEnt4uyOZn9csDNa4fMmbRFxVvvn78tCziQXyZNtny0RcTAM33n5VdD3YbzRbKnEyd8M
         h5ibIS+yhwntPxOsa2yRBko1yRJ6ijDHG+LfTugeUKymBGbhoFuVzCHkW4BvZVPIFEpG
         yPsA==
X-Forwarded-Encrypted: i=1; AKwUvBztjELFx1DUoxbahn4XA0iXu7ppVEN2mQFDtcub5ErNwRoOvnAi5ifmx2N6ny7TLqO3sZrZr3QBVw==@kvack.org
X-Gm-Message-State: AFuF++mk02c6849aV3HcvaP7+kdQy3VPUPzGH0GWx/KjipfRPoczK/kF
	hokV8vyWNK7CdHBF6R9hEXP37pxipW+us/Zpb0T0acVspq44IWdZqZNX
X-Gm-Gg: AYBFou2R/suCsXeYKLYjOtM9FoOuJuagDuAN3iiEL+SwUIdt4n1ESHrS2b2aLPF4UZK
	gdXBCbTM9k2kWyCnObjGIu81bkS5VYoyv/whrAsFHzcZry9pRgM2qLe8TuGCwDyGKzq8uw0HA2w
	w+Jw8PcTP/OOIm/aGA9d0kIOCM/sy232nSMfKz42bUbNDr2DMJcJHRpC01oll2DNvNQX0z+ii1x
	T4CDpdNE2D16k4A6XEojgen6oaMd0os6TviHZLz/0/Ndgj+fQ4bFUqjNZcrmNkLmk/8EnzEoJGq
	pZrSz8lxt+cpdZ2viq7UrZJ9ce13SznGLc26VjjZuNV33ALEnvCj1WZznwMTROC8lHxwcLAyNz3
	15bRZeHSjPyGSB8gixO+yrxqrGuxXP8D5vYZFoTmLRTxveds9WBUny6tWlfDJlqQIpr0DOoyjbJ
	Aqv3YrTQma8J1WT1h54D2HKgQ67To2ZGxZK84lkGghKOmazzOVJujeiGARyggwsJP7bELj9qgMA
	LvOTBrRTyLKfPeHb90xDmcgMpN0eYGC2PzSB+ZabBt1r40lK+m93JzlapODMjX8gmmjkE3HttF3
	8s0yQ741O0T9nW2QvcMC0zlDD5Qamxr6DOT0dxdxVOkYTxvMtmuR5HteutmGN92eI6Sd6fehXR5
	rsg==
X-Received: by 2002:a05:600c:4e8e:b0:49f:ce78:3561 with SMTP id 5b1f17b1804b1-4a02759b360mr175379885e9.18.1791182125208;
        Sun, 04 Oct 2026 23:35:25 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b305-2001-39fa-3d24-821a-4eae.310.pool.telefonica.de. [2a02:3100:b305:2001:39fa:3d24:821a:4eae])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a03ff106d8sm219456545e9.3.2026.10.04.23.35.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 04 Oct 2026 23:35:24 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] mm/page_alloc: skip shuffling and reporting for no-lock frees
Date: Mon,  5 Oct 2026 08:35:14 +0200
Message-Id: <20261005063515.6312-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E6E95120005
X-Stat-Signature: b4h3yh9i4c918eursn1ajrjsi88nwgbn
X-Rspam-User: 
X-HE-Tag: 1791182126-39365
X-HE-Meta: U2FsdGVkX1+f84Nffg2wWnfp6FfdMlwMdmAP4LAg6qwxA9lcHp/KjnvSbwZF93GTFhWLPNVVMM5vtYdF5nFg0ttPVUoaHbkDyiwttew13HKYToCdtZ1m1Dlf2W7s5+LmnY2opl8P9Hb1cHzYMgxQ7vTnlrZfc514TTZhMi21OgyCKLMEUntR8YBK+DmT6lFbrJt9+txkMPqmQt+V0YMg6WTOMwxD80S27bA0Gl3sm1YdaYtgx2Mxx6A0MrndB40sd2d+Xm5WLdWHnezrwrlaoI2bLIWLBTW2yALi2vR6RjWN4DyJ3qPWnuBquS6xBAB+E9bkCzewo6CDEjkqp+3+5RFYLNrhZXUjodqZX9/u/sQZOIpzly/J1K4juuF/79g4A7paBb8tjdg/nrn4SQeo4F0XxZxazWSfm5d8sRSt7F+TlP8WbqeawnuFKk0aCZCv5ZzGNXdG5wQywLKDKEznlJD70YwVYzYJbWovdzf4aGyiEVBZVX1PiScaR1EOytf9n93YN3isba0hIq8XIApyeOu0ZkC41G6itkp5dhMxU0jwGqfBSSLxN9MhVQbVpwb2J6JlMAdalXtyOP/mBBIpavpSnLK7YzA4yPKhdOObFsmGZiZ3uQiJzH0lFa+/eYMbspZdCmrtIJ5WrmNTL8JzPKbL/W/kHu4k++U1Nksa8WJZ3lSpZkREn1osE2M3XUCu18Be5DFKfeC/2emyLHgAnpULDaAABiXQ1KZkf4c4IboQMpkz6+KVOLrRbo3taBim4Bq3OFih869qqZ4u52ee9jZhBj+L5IUPYVBo6xpRfgcQedrTy3gBr1h/3FAp8VhpY0ein7O7l6C/bWdQJ6Xitjqy8CVFHc5aCbuqFQNNd10QaFiNhH/OEuo+rdE67I1LNS6G2Vl01zZkvbno++p0NW+B4hvebNLVGRwFk6ozBLCIn6Saf/byHLx4Sx+TS593ECuE0YhaKh0xbGYMqGC
 jAOlC3B3
 GSF6bI85+vQdLZHBIsXUqa5LICYvwN2IBLx7ZWxrPWlrdQQFhnrhifj/FPrZj5DgGI338WDWXq9mz8IMInomzhaKeG4NJq0NdzXPvA5zemJRn+GqdingJx9EmmOehhX50Hv45qxKK+MvuHd3FGovHhHcxwhIELUOex02Yk0ddYvfgN19RnC6pDtwG54xE0d34IS4IjQ4hf/QoaqmFrFCOHs1u+Cylp13bmH7bCAf6oIbVJYcDhwdT2IxBAxQVZw6CO07ev/WwQducHJk07jYVyZoOLPNGWw/EvVZVtJDfIV1OJ/D5SDA691fQjgJwi5NnJ1M5MhBWbVnAgtT71vzkNmDK67/VOA0VL6MP7i/5IN8O/nB2Uvs0bPD0xTEyk3wfL5nw4E6jtN6gfSq2gdPF7qsGJaDebb/vvrpEqt6fhxTQI1g3p8ZwFzPGNc+MqwLHCs83o378mDnWOxjRuSpZjiTQXqEuKe+GVE+Jd6Ndx7PpabI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_pages_nolock() may run in NMI context or while a raw spinlock is
held. When its zone trylock succeeds, __free_one_page() still reaches
optional work written for ordinary frees.

shuffle_pick_tail() can refill its random-bit cache through
get_random_u64(), which takes a per-CPU local lock.
page_reporting_notify_free() can queue delayed work. Both operations can
enter locking outside the trylock-or-defer mechanism used by no-lock
frees.

An instrumented PREEMPT_RT lockdep run forced a random-bit cache refill
while calling free_pages_nolock() under a raw spinlock. The unpatched
allocator reported:

    BUG: Invalid wait context

The attempted lock was batched_entropy_u64.lock in get_random_u64().
Lockdep showed the raw test lock and zone->lock both held.

Skip allocator shuffling and page-reporting notification for FPI_NOLOCK.
The freed page remains on the buddy list and can be collected by a later
reporting pass.

Trees from v6.15 through v7.2 call this flag FPI_TRYLOCK. Use
FPI_TRYLOCK in place of FPI_NOLOCK when backporting this change.

Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
Cc: <stable@vger.kernel.org> # see patch description, needs adjustments for <= 7.2
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
This was found while auditing the no-lock paths discussed at:
https://lore.kernel.org/r/20260919171443.90512-1-kmehltretter@gmail.com

Tested on base e767a4ea70a3 in four-vCPU x86-64 QEMU TCG with
PREEMPT_RT, PROVE_LOCKING, PROVE_RAW_LOCK_NESTING,
SHUFFLE_PAGE_ALLOCATOR, PAGE_REPORTING and page_alloc.shuffle=1.

A temporary initcall registered page reporting and freed 65 maximum-order
allocations with free_pages_nolock() under a raw spinlock. This exhausts
shuffle_pick_tail()'s cache and forces a refill.

                                             unpatched  patched
  free_pages_nolock() calls                          65       65
  __free_one_page() calls                           130      130
  shuffle_pick_tail() calls                          65        0
  page_reporting_notify_free() calls                130        0
  reporting work pending                              1        0
  invalid-wait-context reports                        1        0

Maximum-order splitting accounts for the 130 __free_one_page() calls.
Both guests powered off. The patched guest emitted no diagnostics. This
forced test does not measure normal frequency.

A second A/B used no test-only MM caller. A BPF arena program attached to
mm_page_free_batched requested 2,048 pages from a memcg-limited map. Partial
failures rolled allocated pages back through free_pages_nolock() while the
tracepoint held the per-CPU page-list lock. A virtio-balloon device provided
page reporting.

                                      unpatched  patched
  arena allocation attempts                  70       70
  arena allocation failures                  70       70
  shuffle calls from rollback                 9        0
  get_random_u64() calls from shuffle         1        0
  reporting notifications                    12        0
  delayed-work queues                         5        0

Both guests powered off without a diagnostic. This confirms that an in-tree
caller reaches the optional operations. It did not reproduce a deadlock or
lockdep warning.

The upstream form applies to v7.3-rc1, mainline and next-20261002. The
FPI_TRYLOCK backport applies to v6.15 through v7.2. mm/page_alloc.o builds
on v6.18 and v7.2.7. Stable backports were not runtime tested.

 mm/page_alloc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..3e21dc90b858 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -89,7 +89,10 @@ typedef int __bitwise fpi_t;
  */
 #define FPI_TO_TAIL		((__force fpi_t)BIT(1))
 
-/* Free the page without taking locks. Rely on trylock only. */
+/*
+ * Request the no-lock free path. Use trylocks and skip optional operations
+ * which can take other locks or queue work.
+ */
 #define FPI_NOLOCK		((__force fpi_t)BIT(2))
 
 /* free_pages_prepare() has already been called for page(s) being freed. */
@@ -1013,7 +1016,7 @@ static inline void __free_one_page(struct page *page,
 
 	if (fpi_flags & FPI_TO_TAIL)
 		to_tail = true;
-	else if (is_shuffle_order(order))
+	else if (!(fpi_flags & FPI_NOLOCK) && is_shuffle_order(order))
 		to_tail = shuffle_pick_tail();
 	else
 		to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);
@@ -1021,7 +1024,7 @@ static inline void __free_one_page(struct page *page,
 	__add_to_free_list(page, zone, order, migratetype, to_tail);
 
 	/* Notify page reporting subsystem of freed page */
-	if (!(fpi_flags & FPI_SKIP_REPORT_NOTIFY))
+	if (!(fpi_flags & (FPI_SKIP_REPORT_NOTIFY | FPI_NOLOCK)))
 		page_reporting_notify_free(order);
 }
 
-- 
2.53.0


