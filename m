Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB102CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 16:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B736B009D; Fri, 15 May 2026 12:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313436B009E; Fri, 15 May 2026 12:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24FF96B009F; Fri, 15 May 2026 12:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 11ADE6B009D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:25:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4FD0401C4
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:25:00 +0000 (UTC)
X-FDA: 84770178360.12.BB733AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E98614000C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bsV8Qbq+;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778862299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8EfqOfYYnipgcmzRqW0udrtWcEh9Dk68Uw785Xw2sjs=;
	b=yBSMSwifPZ/za7pAUrrhUhbEoH3K4M1CdvJ5yAeHSxsZj3TRewajmwtrZizZPqCRqB3Qr4
	2f4+9gyGxqLc9+MXiWVPlypl1713JeoFpmbY34uOeGj/NJnjvhdJdCG8jEICEygf+YHsQZ
	AaqJlV6e7uRAckV/sEBLEAPd9OGeAmE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778862299; a=rsa-sha256;
	cv=none;
	b=FaxFex121Hw+vUr0j99CtSwLCvvltB55ziIvK78L09GhXLkaACiTG6mrHIp7cS5AHLJjMp
	kz5jKS0812JIPPOnzW684PM0K+8V/ZBuMZlgFH+4aw87L31UcjqSJHodgPk19KBDh6HVeM
	IoYil/+kfO8lGVd30LhEuKzyjHYqiQw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bsV8Qbq+;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 209FF445D0;
	Fri, 15 May 2026 16:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D953BC2BCC7;
	Fri, 15 May 2026 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778862298;
	bh=MxvKk95lrw+bUt79KYQQW9SxXe29lTK/BGOMUL7tjHI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bsV8Qbq+Wzb4LJDaGTkoFbx9/YBMLEM/kXBs/QqYND7k1yxN9O7Uf+kOqDvL2xYPW
	 VF1d9CLcjPR0BRFU1mYmVD1ap6Ncpj5e2nZDauBo9rH9wTqNWigE+i7t+Ru/Zabb/+
	 FoxDxOaNDgsIvmjamESQGfjXgYOlSnb8kFjcNrNoO0HIU78J13P8lP3uJC4oTOAw27
	 RJc/Mk+XyVGqpzqSRlT3V3KL3ZFo0LeaqzNsvwLGH8kjaLmyd6q9wKFZdb0yEaZYZ5
	 nXAZxoar3CJbEtH0bkb6AvKWjc6Tz3fYY7CDKsq1djM8zQvuCq7sRyvp1TTE68A3ss
	 WSIpAVpCaDCgA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Sat, 16 May 2026 01:24:31 +0900
Subject: [PATCH RFC 7/8] mm/slab: add pcs->lock lockdep assert when
 accessing the barn
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260516-sheaves-tuning-v1-7-221aa3e1d829@kernel.org>
References: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
In-Reply-To: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E98614000C
X-Stat-Signature: fwac6rrydbk7pjsdt9oqrhf3w6nga3qd
X-Rspam-User: 
X-HE-Tag: 1778862298-903395
X-HE-Meta: U2FsdGVkX19K7SlqZAGPSVerkaDwRiyux7uWUgpjxyM4r1yxqxSaPrp+97MPmhxwCv+KEau7zF3ZVL0n9NoIHxQSsSGA6GO8oxxA4dA9ghyLQfV+S+0U8LpdF8hmSdHMDgpNjmOPCLiascDFfCjXuhS7IDNxSVxUFTPKlqEjEDfMtZKsT4dE8emWjY+WZoKkvpgkAcT7e1rJ0RCaJKiyStQZDvljkgE3VZh63RbBo+B2HjO64LXNe3CzjUDK15tKQQ7LeWCoS/WgPq5ia3xxfe4Z9EISpsr2nLYEVTkCsmE2L4hDASAE6Ga5HB8bEzAHIsPEBCPgMLUj8y/iz3coDONanhgKoxG+c+12EoThEbM61DFPL8D6lfOdHEy91UbG6JT5XRjxiYqXpfKJrd3eZw19zB1ghOnFK66mKpduhhPJxUeZJrqgdxphNhNSGRmefWB8zS/xMizTKOomExi7Z2eHJHGZlhTqTwNTbELKAGqBcbCEseF1txocrESddn97Jy/a7BiQ/AazISqMcDYLVeTrMFRn0nOcjDpOT8/jl1VImFt76w6dadzzTfGHw24JSfcbmeN4cb/6agA2Jx9Brp6EPFFC+nrkLUEdabONCGY0JuCzEBkaiwHNmu/0yYFUSG0DONZeazjVbZFN4zRhk/PAYIwac+ZrIoC0HAxatdWKWJtd+0vozZ1SBk5a3uNuv9rmob25H5Lu5DGhkjNk8albInwozT73hBtLJnQ7Gk0FLRVOQehHt7/R4/zZwGGjlt6hPBpq6dI/coYmF0kXUW0L56Nk4U9WPNsV/goyqPix+lGZ6gIYUbX85IenG5c/EyZ+wvNOD/lcnKeEOeqaubWi+xV2pn9zGmb6eMe1xngU3DDQMyaaCyi9bu4jW7/xZQcVm93QGhWFXTHNdqmQAlf60qoOg0vJZg/taGcwr18ejgW825lp1ERzZ9YiRmqFPgm+gn+mlRta6Jo8TsP
 a0pqhTRZ
 ZR0VRtCrOCdwv8n/KE+Hpp+8QbDrCkCuC9JoN2RN9lxkwWKOHooXYqFTzjPwQVMjHOZwl9GbJ5YudfQurB5oJugRWKsMsBfSaVd3KYxK6Av/gZkmi+/rfjha+X/xJmDwewiN//DJQliOmLAhmxKDA6RHIgSC/0+lEpcxzOQVRW2FK6C0xqJTOZdPG8FmZgNk4yP7Ovd1oJ3vfnf98lylfX4nlXB3tc7ojRvqxvFD1niGAgXpSbe7MNe07RA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the cache's capacity changes while a CPU is getting/putting
a sheaf from/to the barn, the writer performing the capacity change
is responsible for flushing and freeing those stale sheaves.
However, that can be done only if CPUs hold pcs->lock when accessing
the barn.

Add lockdep_assert_held() on the pcs lock whenever moving a sheaf
to/from the barn. Since struct slab_sheaf no longer has the
cache pointer, add a new parameter for the cache pointer.

When lockdep is disabled, the assert is a no-op and the compiler can
optimize away the unused parameter (since these helpers are static).

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slub.c | 70 +++++++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7def24fdfae6..856639d3d3f0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3142,12 +3142,15 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
-static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
+static struct slab_sheaf *barn_get_empty_sheaf(struct kmem_cache *s,
+					       struct node_barn *barn,
 					       bool allow_spin)
 {
 	struct slab_sheaf *empty = NULL;
 	unsigned long flags;
 
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+
 	if (!data_race(barn->nr_empty))
 		return NULL;
 
@@ -3174,10 +3177,13 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
  * empty or full sheaf limits for simplicity.
  */
 
-static void barn_put_empty_sheaf(struct node_barn *barn, struct slab_sheaf *sheaf)
+static void barn_put_empty_sheaf(struct kmem_cache *s, struct node_barn *barn,
+				 struct slab_sheaf *sheaf)
 {
 	unsigned long flags;
 
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+
 	spin_lock_irqsave(&barn->lock, flags);
 
 	list_add(&sheaf->barn_list, &barn->sheaves_empty);
@@ -3186,10 +3192,13 @@ static void barn_put_empty_sheaf(struct node_barn *barn, struct slab_sheaf *shea
 	spin_unlock_irqrestore(&barn->lock, flags);
 }
 
-static void barn_put_full_sheaf(struct node_barn *barn, struct slab_sheaf *sheaf)
+static void barn_put_full_sheaf(struct kmem_cache *s, struct node_barn *barn,
+				struct slab_sheaf *sheaf)
 {
 	unsigned long flags;
 
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+
 	spin_lock_irqsave(&barn->lock, flags);
 
 	list_add(&sheaf->barn_list, &barn->sheaves_full);
@@ -3198,11 +3207,14 @@ static void barn_put_full_sheaf(struct node_barn *barn, struct slab_sheaf *sheaf
 	spin_unlock_irqrestore(&barn->lock, flags);
 }
 
-static struct slab_sheaf *barn_get_full_or_empty_sheaf(struct node_barn *barn)
+static struct slab_sheaf *barn_get_full_or_empty_sheaf(struct kmem_cache *s,
+						       struct node_barn *barn)
 {
 	struct slab_sheaf *sheaf = NULL;
 	unsigned long flags;
 
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+
 	if (!data_race(barn->nr_full) && !data_race(barn->nr_empty))
 		return NULL;
 
@@ -3231,12 +3243,14 @@ static struct slab_sheaf *barn_get_full_or_empty_sheaf(struct node_barn *barn)
  * change.
  */
 static struct slab_sheaf *
-barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty,
-			 bool allow_spin)
+barn_replace_empty_sheaf(struct kmem_cache *s, struct node_barn *barn,
+			 struct slab_sheaf *empty, bool allow_spin)
 {
 	struct slab_sheaf *full = NULL;
 	unsigned long flags;
 
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+
 	if (!data_race(barn->nr_full))
 		return NULL;
 
@@ -3264,12 +3278,14 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty,
  * barn. But if there are too many full sheaves, reject this with -E2BIG.
  */
 static struct slab_sheaf *
-barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full,
-			bool allow_spin)
+barn_replace_full_sheaf(struct kmem_cache *s, struct node_barn *barn,
+			struct slab_sheaf *full, bool allow_spin)
 {
 	struct slab_sheaf *empty;
 	unsigned long flags;
 
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+
 	/* we don't repeat this check under barn->lock as it's not critical */
 	if (data_race(barn->nr_full) >= MAX_FULL_SHEAVES)
 		return ERR_PTR(-E2BIG);
@@ -4732,7 +4748,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 
 	allow_spin = gfpflags_allow_spinning(gfp);
 
-	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
+	full = barn_replace_empty_sheaf(s, barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
@@ -4747,7 +4763,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 			empty = pcs->spare;
 			pcs->spare = NULL;
 		} else {
-			empty = barn_get_empty_sheaf(barn, true);
+			empty = barn_get_empty_sheaf(s, barn, true);
 		}
 	}
 
@@ -4803,7 +4819,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		if (!pcs->spare)
 			pcs->spare = pcs->main;
 		else
-			barn_put_empty_sheaf(barn, pcs->main);
+			barn_put_empty_sheaf(s, barn, pcs->main);
 		pcs->main = full;
 		return pcs;
 	}
@@ -4814,12 +4830,12 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	}
 
 	if (pcs->spare->size == 0) {
-		barn_put_empty_sheaf(barn, pcs->spare);
+		barn_put_empty_sheaf(s, barn, pcs->spare);
 		pcs->spare = full;
 		return pcs;
 	}
 
-	barn_put_full_sheaf(barn, full);
+	barn_put_full_sheaf(s, barn, full);
 	stat(s, BARN_PUT);
 
 	return pcs;
@@ -4936,7 +4952,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
 			return allocated;
 		}
 
-		full = barn_replace_empty_sheaf(barn, pcs->main,
+		full = barn_replace_empty_sheaf(s, barn, pcs->main,
 						gfpflags_allow_spinning(gfp));
 
 		if (full) {
@@ -5139,7 +5155,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned short size)
 
 		stat(s, SHEAF_PREFILL_SLOW);
 		if (barn)
-			sheaf = barn_get_full_or_empty_sheaf(barn);
+			sheaf = barn_get_full_or_empty_sheaf(s, barn);
 		if (sheaf && sheaf->size)
 			stat(s, BARN_GET);
 		else
@@ -5253,7 +5269,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 		goto free_sheaf;
 	}
 
-	barn_put_full_sheaf(barn, sheaf);
+	barn_put_full_sheaf(s, barn, sheaf);
 	local_unlock(&s->cpu_sheaves->lock);
 	stat(s, BARN_PUT);
 	return;
@@ -5820,14 +5836,14 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
 	 * freed to it. Get rid of our empty sheaf.
 	 */
 	if (pcs->main->size < pcs->main->capacity) {
-		barn_put_empty_sheaf(barn, empty);
+		barn_put_empty_sheaf(s, barn, empty);
 		return;
 	}
 
 	/* Also unlikely for the same reason */
 	if (pcs->spare->size < pcs->spare->capacity) {
 		swap(pcs->main, pcs->spare);
-		barn_put_empty_sheaf(barn, empty);
+		barn_put_empty_sheaf(s, barn, empty);
 		return;
 	}
 
@@ -5835,7 +5851,7 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
 	 * We probably failed barn_replace_full_sheaf() due to no empty sheaf
 	 * available there, but we allocated one, so finish the job.
 	 */
-	barn_put_full_sheaf(barn, pcs->main);
+	barn_put_full_sheaf(s, barn, pcs->main);
 	stat(s, BARN_PUT);
 	pcs->main = empty;
 }
@@ -5874,7 +5890,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	put_fail = false;
 
 	if (!pcs->spare) {
-		empty = barn_get_empty_sheaf(barn, allow_spin);
+		empty = barn_get_empty_sheaf(s, barn, allow_spin);
 		if (empty) {
 			pcs->spare = pcs->main;
 			pcs->main = empty;
@@ -5888,7 +5904,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return pcs;
 	}
 
-	empty = barn_replace_full_sheaf(barn, pcs->main, allow_spin);
+	empty = barn_replace_full_sheaf(s, barn, pcs->main, allow_spin);
 
 	if (!IS_ERR(empty)) {
 		stat(s, BARN_PUT);
@@ -6058,7 +6074,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
 
 	if (data_race(barn->nr_full) < MAX_FULL_SHEAVES) {
 		stat(s, BARN_PUT);
-		barn_put_full_sheaf(barn, sheaf);
+		barn_put_full_sheaf(s, barn, sheaf);
 		local_unlock(&s->cpu_sheaves->lock);
 		return;
 	}
@@ -6068,7 +6084,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
 
 empty:
 	if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES) {
-		barn_put_empty_sheaf(barn, sheaf);
+		barn_put_empty_sheaf(s, barn, sheaf);
 		local_unlock(&s->cpu_sheaves->lock);
 		return;
 	}
@@ -6134,7 +6150,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 			goto fail;
 		}
 
-		empty = barn_get_empty_sheaf(barn, true);
+		empty = barn_get_empty_sheaf(s, barn, true);
 
 		if (empty) {
 			pcs->rcu_free = empty;
@@ -6162,7 +6178,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 		}
 
 		if (unlikely(pcs->rcu_free))
-			barn_put_empty_sheaf(barn, empty);
+			barn_put_empty_sheaf(s, barn, empty);
 		else
 			pcs->rcu_free = empty;
 	}
@@ -6314,7 +6330,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		goto no_empty;
 
 	if (!pcs->spare) {
-		empty = barn_get_empty_sheaf(barn, true);
+		empty = barn_get_empty_sheaf(s, barn, true);
 		if (!empty)
 			goto no_empty;
 
@@ -6328,7 +6344,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		goto do_free;
 	}
 
-	empty = barn_replace_full_sheaf(barn, pcs->main, true);
+	empty = barn_replace_full_sheaf(s, barn, pcs->main, true);
 	if (IS_ERR(empty)) {
 		stat(s, BARN_PUT_FAIL);
 		goto no_empty;

-- 
2.43.0


