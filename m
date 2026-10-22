Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB0A606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FDw003lB
Received: by kanga.kvack.org (Postfix)
	id 89CDD6B08A9; Thu, 22 Oct 2026 02:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874EA6B08AA; Thu, 22 Oct 2026 02:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78AF46B08AB; Thu, 22 Oct 2026 02:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6516B08A9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:25:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D92BCC0763
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:25:42 +0000 (UTC)
X-FDA: 85349276124.26.89B129F
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 286A540003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:25:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FDw003lB;
	spf=pass (imf12.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792650341;
	b=kXINMjG4Y6TVVyHvEDRUzYXkbcrzfB1R9R8vigKtD1NJ2qElesyMeqhPCyIVmZpqgSnQrw
	nkL6mKXYB0p+ohyx/K8oqNbxm5PIKnk7shznwEixnDR2DUUBg/8latsrbXQlNmQQbm1OXx
	QtwV4G3gz1CB3DOYeDm0wEpLPxWYSIU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FDw003lB;
	spf=pass (imf12.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792650341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sR/bd0HSOYC2pLXMNReGoBvqOpk6rZoUDvcX0fCnmN0=;
	b=8agZPqL/M0ebX/iJjoIvGfGn75otS2a/HZY3ZmTlHvL9n220kzFGOLhE35vAhj4iq3/gD5
	CXCXg9y+uDTXKtcDRiyAg+kLv00Pr1WMkXFchhnCQVKjnf0z81Oug6BOdenzdy0bgoY6Ku
	r3Xf0vCrUN9P4NzsJEFEgLN351TLo5E=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a2074a66beso2027025e9.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792650339; x=1793255139; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sR/bd0HSOYC2pLXMNReGoBvqOpk6rZoUDvcX0fCnmN0=;
        b=FDw003lBvWLbcyfOeeKVH19JL/UqY0bJYkHA/cWbSson0FZDWnhEbLB7ZbHIlp61Eb
         UXJsBdNslD4Bvjz5otsFb/j9+DNb4EIXpIi3Pqnd2SMzNWf4jM9Ng4OOYs94755aLbvL
         RIE1I62Tjzzdv469EzQxBEpqdHEKRCB+C1qtfnJ0h5R7cDyRabOICLK3bTbfgziYLQX+
         1gIdr0qfIzXq1fmcUoc0o8DYtWLoo3SJX4IsUQWLcsJprbjfuQzkg5mmPpmTKZRqpXxp
         bSmMA2N2K0k9sgGA0WCED8uMC5Lk/5LCcXjqJlDBEaduu2j1X4sswkj9mrzUVkY6PhMM
         547A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792650339; x=1793255139;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sR/bd0HSOYC2pLXMNReGoBvqOpk6rZoUDvcX0fCnmN0=;
        b=bN4oJUrbkObhIgs2+busLR7lPhlsIap+ZZxpNv83xE7injFMvFB8pfn4YyvktJdMUk
         pFlGEE3plv/bz2BG9FnDUxtnR/XEF8oMKbPL69cZ6nRFi7w2XcP3QM//UnmL6AEVIc1H
         K/Xlpp04sZ9xtjWbq1jLEmzgLLZx16D+6wCu3j850VZlUKXasTFCgqtqydh04grYPF/A
         qGDccpwmRXZ2Pa2pSlymrb+P91eM3m2ZGuUc/GccJrVVKvAJ0dySDkdLQON7rj3Y/S+8
         3/jT4EGNZeUWxf+pUZZTP7DefvSNoWekWJCGZQz+lAO5q6JddmPsOgzz4ZwhScadUm4z
         6nMA==
X-Forwarded-Encrypted: i=1; AKwUvBxdd3pcQ/GKJh853jRegaICxUJUcCg/cJaATPMDm+fq4/zz9Ih8xJjOn3psHTKhqoMnks+qrUE12g==@kvack.org
X-Gm-Message-State: AFq9FYLlEMzhThQTpe8Y1ptMAq5FCiMyaSBfF6asahm5WAl4ssXX+eE+
	vkHfhdy/8+KMLKbad9jteZZilxKSljRE+klHaR4YkWd7KNayLlz5P3mp
X-Gm-Gg: AYBFou0H6eLxRCjIhF2eEXaW6iDNsLRf5hSoSn3jU+CQuRZk1XN1XzpG9H5VNMVpJq8
	bVmtp9X/vj1bNs3ICsMQ6HQLAIU4DSolT9+JYXIQ4EDY+Cx2xPRsLRcoBfdwjkWGeho0JOEJajw
	kjlkW/HVUxTebnzUhyLaD2HgbBRx8BDyLQpYF8fhApwJIs3hJvJ3PMcDSoBp8zZ+v/Mj4hpc5ca
	jQFvwLbRmbOQGeMv1oosDQMDloP+63Bqw16GnBLImGLd9GvFZkwRnAlkhtEDVl0FY7eHs71/VSP
	tXQRqX4RlYiEB92IeCTx37ADYAh2G0U4KB8brBBhmBW7iItet6rVcdrnJTFb/sETf09cJdasw0r
	irTcXkPn63RWEZTx5G7sGTW4Dw0yiXCSO957EkrYTl+wy+Aobn+AVd+YZcMd8gwXOdLDvVa5Y6U
	ciWC1iEip+Vk6IWpLEujOmxasKF3OD3sbNncrXwSYOf74d6Qr8jgraC6Oi74TDC33tq40U1ey+Y
	yWKR0rw/eEs6mRLPe6L9OBe0ABQM+IHEYaNZlsp51HY0PCoIglyUJdrUPIoN6yeM/uO0K4SXGz3
	4EZJspZdMyxPWv6EN65IWfl6mL9xtDKtAil3ZIBlyeckC4Wsj20GZh+UkplyNhiZu2blxCUf7CU
	J2KVGKv4lpC0MEaNZ8pNg0x1kPxDgBA72zHg/rM+vVJmXk64qYyXMEwFheu1f7G+7
X-Received: by 2002:a05:600c:4685:b0:4a2:a1b:dc6f with SMTP id 5b1f17b1804b1-4a20a1bdcc7mr6610985e9.4.1792650339278;
        Wed, 21 Oct 2026 23:25:39 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-ad43-d501-2c28-bb72-120d-420e.310.pool.telefonica.de. [2a02:3100:ad43:d501:2c28:bb72:120d:420e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a203a447c8sm45301155e9.12.2026.10.21.23.25.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 23:25:37 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Alexander Duyck <alexanderduyck@fb.com>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/page_alloc: fix shuffling and reporting for no-lock frees
Date: Thu, 22 Oct 2026 08:25:23 +0200
Message-Id: <20261022062523.97082-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 37tsxwqyeeywx789cgufbchg6n946quk
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 286A540003
X-Rspam-User: 
X-HE-Tag: 1792650340-817366
X-HE-Meta: U2FsdGVkX19j8qxZ+YbwK7E9H97X7FOD+rTmTmdSPY6dleAhR4ek1nlEPSfJvvkf4jtMOUXlDEnGO4HBeyyC5upcUoEKRI6j8d6RfBWU73lJHt18WetATted6th1OdBNgNRxylNgbtm0x9Gxx6yYYN0pRhIptSY9X1rWQKNz+wbQhmCtHAsF5AdIEtD9jpl2W7U4uU+cJ9CkBg8SKXTWgPH2hXAB4M3l6LbSC5Lps8UWOqUdQuVzqkidKF0PdqgQNIpDWZitiTSCL3r2X8Wo8uPfVYt9DuhGt61lg5QrYH9j8VkH7D6Vv0GVqQfYNXTM3MCJSnueLrx2biHVcd/yUq6o8xjPNiOo6bsy8uXjzyIGa2i8WvcvIlumK1Om4aU2qehQhltBgcF1fF2H1ah/1u4ZljGRcBBt2bU/yo0DHjZKi3LXSyPT4+ySgtKCMcCkIf1YvDmczNcvwv3FBPscsiDvoJ7t46ic6f66h+mstIAtbmEk4UXCXggSZHUZ1hX4V+PDMamHG+eCOIlCaRbw7DHJNoBqpx3g8Hc/IzFM5uvEVRlJk4+CLLayzUOXMYpQBfsHX+/D1XkxgoAPbJGdlvoHCgk3cSxJE6dhw4eOtK75QLoIezxSpBeYCJzbrePhmTPY4diUSPxsUMtHaBRfhQspPjGD9306zuIE5FjC1IXCkgfAhgdZNcKsdyMz2wpMns9nMtA+EC7KZvYx84u2I0ToU9Xdv9ix6t+BhYC5qBs9k+sxKwLL6V0xuQ/yxiyd39AJb5Mp/R9MUi+ZavNOvfmEuupsVwDch0TRj+HARYUMvkk/kRS8N5Q1E2QXmySQq4YDHo5iBLU2YATnV7kEI8L8xB3hLlEy4foZ4rtiXn52HVK0s1H41TF235eRnbTiLta2EqP49NKh0LI3RQjqOhT8lMm0A6ZekYUwmyIl5gh4yIRdaTqgLkpEWmwa2Mc/ErtvyNKsBxF0OKPnARM
 OaIQuzXw
 wQQ2FBIl3anzKYlYpUEgGlsXEwEW6uFrqzrRGKMFqoyVqDCUXxe4NtnwlX8G/NkiifyxfvgL/bg55hil7O0G4yIYI7KYJYIOUxIz1A70Wn8BHw24kpsp1K3N86+FivfRYIk8ePzsBUdqy6Z309DkHonkrgEtBo8pQj6JSvCcQ+6bSIavGsU95J0tIBIl6cWEtkEsP5mXhaHDSlf08hdR+xLTuoJGlSTVXPrmvVGFrv+mKMS+L3rB/V/rE1TtVYI72RAw9yB8JE/4dEdPyxyVn/pAT6Mnst6j+PvZbPuw16SrL3LNtfZvckd7qUZ5mdSi1O+HNoEZy4r6nePp236RF6BscJzXeOi64DdOLdrR5n+PeEAMljW+umXtoXUzf6T1gGbGYB/J064EBV+NJFKXDAqJnL53M9M+UrD4RkZ9Pv7vn7Rv1Cp5ro7ik+5msivjGwdThZPAKR8dgsWHbThH1l0YW1DBYqALMhy15IZiK2NivZJA609fxvhDsnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

free_pages_nolock() may run from NMI context. The BPF arena also calls
it while holding arena->spinlock through raw_res_spin_lock_irqsave().
When the zone trylock succeeds, __free_one_page() still reaches page
shuffling and page reporting.

When shuffle_pick_tail() exhausts its random-bit cache, it calls
get_random_u64(). Once the CRNG is ready, this takes an rtmutex-backed
local lock on PREEMPT_RT, which cannot be acquired while a raw spinlock
is held. A test-only forced refill under a raw spinlock reported an
invalid wait context at batched_entropy_u64.lock.

page_reporting_notify_free() may call queue_delayed_work(), which is not
NMI-safe.

Pass the no-lock constraint to shuffle_pick_tail(). For no-lock frees,
use a pre-seeded per-CPU prandom state, following the slab allocator.
Keep the cached get_random_u64() path for ordinary frees. Seed all
possible CPUs before memblock memory is released to the buddy allocator.

Skip page reporting for no-lock frees. The page remains on the buddy
list for a later reporting pass.

For stable backports, FPI_NOLOCK was named FPI_TRYLOCK through v7.2.

Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
Cc: stable@vger.kernel.org # needs FPI_TRYLOCK through v7.2
Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Changes in v2:
- Preserve shuffling for no-lock frees with a pre-seeded per-CPU prandom
  state, following the slab allocator.
- Keep the cached get_random_u64() path for ordinary frees.
- Keep the page-reporting guard and explain its NMI constraint.
- Check is_shuffle_order() before the no-lock flag.

v1: https://lore.kernel.org/r/20261005063515.6312-1-kmehltretter@gmail.com/

Testing:

A temporary caller freed 65 maximum-order pages under a raw spinlock,
then repeated the workload through __free_pages(). SMP=1 and SMP=4 QEMU
TCG guests produced the same path counts:

                                  no-lock  ordinary
  shuffle decisions                    65        65
  prandom_u32_state() decisions        65         0
  cached random-bit decisions           0        65
  get_random_u64() calls                0         2
  reporting notifications               0        65

Both guests ran PREEMPT_RT with lockdep, raw-lock nesting checks, page
reporting, and page shuffling enabled. Both lanes selected the list head
and tail. Neither guest reported an invalid wait context, lockdep splat,
atomic-sleep warning, BUG, oops, or panic.

The test does not inject an NMI. The in-tree BPF arena caller establishes
the raw-lock path, while the forced refill checks the previously failing
transition.


 mm/mm_init.c    |  1 +
 mm/page_alloc.c |  6 +++---
 mm/shuffle.c    | 24 +++++++++++++++++++++++-
 mm/shuffle.h    |  9 +++++++--
 4 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1533aebafb688..01bccb23a89c2 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2643,6 +2643,7 @@ void __init mm_core_init_early(void)
 void __init mm_core_init(void)
 {
 	arch_mm_preinit();
+	shuffle_init();
 	init_zero_page_pfn();
 
 	/* Initializations relying on SMP setup */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c483..f13993bda67e1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1014,14 +1014,14 @@ static inline void __free_one_page(struct page *page,
 	if (fpi_flags & FPI_TO_TAIL)
 		to_tail = true;
 	else if (is_shuffle_order(order))
-		to_tail = shuffle_pick_tail();
+		to_tail = shuffle_pick_tail(!(fpi_flags & FPI_NOLOCK));
 	else
 		to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);
 
 	__add_to_free_list(page, zone, order, migratetype, to_tail);
 
-	/* Notify page reporting subsystem of freed page */
-	if (!(fpi_flags & FPI_SKIP_REPORT_NOTIFY))
+	/* No-lock frees may run from NMI, where delayed work cannot be queued. */
+	if (!(fpi_flags & (FPI_SKIP_REPORT_NOTIFY | FPI_NOLOCK)))
 		page_reporting_notify_free(order);
 }
 
diff --git a/mm/shuffle.c b/mm/shuffle.c
index 82a2c7725a08a..2e1f76d6bf92b 100644
--- a/mm/shuffle.c
+++ b/mm/shuffle.c
@@ -5,6 +5,7 @@
 #include <linux/init.h>
 #include <linux/mmzone.h>
 #include <linux/random.h>
+#include <linux/prandom.h>
 #include <linux/moduleparam.h>
 #include "internal.h"
 #include "page_alloc.h"
@@ -13,6 +14,7 @@
 DEFINE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
 
 static bool shuffle_param;
+static DEFINE_PER_CPU(struct rnd_state, shuffle_rnd_state);
 
 static __meminit int shuffle_param_set(const char *val,
 		const struct kernel_param *kp)
@@ -30,6 +32,12 @@ static const struct kernel_param_ops shuffle_param_ops = {
 };
 module_param_cb(shuffle, &shuffle_param_ops, &shuffle_param, 0400);
 
+void __init shuffle_init(void)
+{
+	if (static_branch_unlikely(&page_alloc_shuffle_key))
+		prandom_seed_full_state(&shuffle_rnd_state);
+}
+
 /*
  * For two pages to be swapped in the shuffle, they must be free (on a
  * 'free_area' lru), have the same order, and have the same migratetype.
@@ -159,12 +167,26 @@ void __meminit __shuffle_free_memory(pg_data_t *pgdat)
 		shuffle_zone(z);
 }
 
-bool shuffle_pick_tail(void)
+bool shuffle_pick_tail(bool allow_spin)
 {
 	static u64 rand;
 	static u8 rand_bits;
 	bool ret;
 
+	if (!allow_spin) {
+		struct rnd_state *state;
+
+		/*
+		 * An interrupt or NMI handler might interrupt and change
+		 * the state in the middle, but that's safe.
+		 */
+		state = &get_cpu_var(shuffle_rnd_state);
+		ret = prandom_u32_state(state) & 1;
+		put_cpu_var(shuffle_rnd_state);
+
+		return ret;
+	}
+
 	/*
 	 * The lack of locking is deliberate. If 2 threads race to
 	 * update the rand state it just adds to the entropy.
diff --git a/mm/shuffle.h b/mm/shuffle.h
index 11bec7521ab89..92f5e758388d9 100644
--- a/mm/shuffle.h
+++ b/mm/shuffle.h
@@ -11,7 +11,8 @@
 #ifdef CONFIG_SHUFFLE_PAGE_ALLOCATOR
 DECLARE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
 extern void __shuffle_free_memory(pg_data_t *pgdat);
-extern bool shuffle_pick_tail(void);
+void __init shuffle_init(void);
+bool shuffle_pick_tail(bool allow_spin);
 static inline void __meminit shuffle_free_memory(pg_data_t *pgdat)
 {
 	if (!static_branch_unlikely(&page_alloc_shuffle_key))
@@ -34,7 +35,11 @@ static inline bool is_shuffle_order(int order)
 	return order >= SHUFFLE_ORDER;
 }
 #else
-static inline bool shuffle_pick_tail(void)
+static inline void __init shuffle_init(void)
+{
+}
+
+static inline bool shuffle_pick_tail(bool allow_spin)
 {
 	return false;
 }
-- 
2.39.5 (Apple Git-154)


