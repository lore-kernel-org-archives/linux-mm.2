Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE18A606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uv2N2fvQ
Received: by kanga.kvack.org (Postfix)
	id 5B8AE6B05BA; Sun, 15 Nov 2026 10:10:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5906D6B05BB; Sun, 15 Nov 2026 10:10:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6A36B05BC; Sun, 15 Nov 2026 10:10:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2584C6B05BA
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:10:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D40EC072A
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:40 +0000 (UTC)
X-FDA: 85437690240.09.38A7E09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id BC3191C0007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uv2N2fvQ;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794755439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fbpIVRiCk4avhKbwmmnYtrqYq/PlxIo76wpkvP2jGk=;
	b=bN7vWiAlXVQ0RqyBuCmeB36E6ykrZqIockvqfufTwZ8SfQOpNsp5mmyFFCqlaHWV008Sgm
	RwleO8GPuK9ONIR3ZNTFFJTflY43GO8m4oQQF9FbtzN5IOvw6i0xw5OJaisfDe7v3fjuPm
	uBYxEHM9L+/SPKY1+u4yFl/6GTBMd0E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uv2N2fvQ;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794755439;
	b=8rm1wkGkRijwWZNjO6UDoayTWLHILb5Tnf2Y4BctNEsc+KHnnSFrYNujRrPLpghbuy/OQG
	1M8YIueV7s1xiucmAxiA380rdmd78lCSw09GW29qflxH6ZSwxBTC4qlkbFFmibq16k8Qpk
	vaMSqVrZlcFHjlVQ7zOExtTuvEpFpWk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 199B243D6B;
	Sun, 15 Nov 2026 15:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B237B1F000C4;
	Sun, 15 Nov 2026 15:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755438;
	bh=3fbpIVRiCk4avhKbwmmnYtrqYq/PlxIo76wpkvP2jGk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Uv2N2fvQO0dvY9WeWOp6oelXg6agl14Zeyyfme5Hd9fHuZsOPVlBBfafNEsIMKpAw
	 mW4/g3vEo7feyp6XN/xtTCkl78QBFYXH11l3NlKooyR4T7MeAaA6TmmTV8uVI1Ngcy
	 LI7Ii0dJzxIlCJG95deRuOoX5rySwZmbD19ZTjvbflV0pGRtk+C6DmxkD6e5xgJswl
	 ZhOXy8hfgH3yPBpHjjlkvk0sBQkGQAEixBFrBQZ6RmuTnr4r8cdQDKj1Eyf3v2Dlhe
	 oorXOXCYArgsbzrGFo/yg+lRCZIzi93EcXvl169MisOGBpHvE9DuzCKKBL1C+/ya0o
	 IBlJQu6LADCbQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Sun, 15 Nov 2026 15:09:41 +0000
Subject: [PATCH for-next v3 7/7] mm/slab: call debug_locks and KCSAN checks
 in kfree_nolock()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-kmalloc-nolock-fixes-v3-7-9034dd4ecaab@kernel.org>
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
X-Mailer: b4 0.16.0
X-Stat-Signature: i54qpsk97mij74fcwgdda157r9jfq8d7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BC3191C0007
X-HE-Tag: 1794755438-214906
X-HE-Meta: U2FsdGVkX1+Vm+U4PmjIeIOMVHOwtc59QtKn1TVW/0HAwI7nhl4RoMFeuasJp10SQc522dlwo4V3ukgWWCKYYKb3PI3dGtWH4WnTqPwGbEj03RRq9UW88qpxiaBV2IZ31J62aHfIsZY40GkQTpe5qUkt3CPmdQdDkrWn4ZkzEwQLSpwemt5qsG6+sfBIP/cEk5Tzk/fZFwx9c+sYlhQi8CLetxzvwRe8L/s3jFvc/4FFr5+iVh+yak/D76FsvX1HflWU7iZAPCYRilP6yhNXxVAGIAluqyGnEKM69HlABMoTKx1hOlOhFqWVADlpF1ZVulzBrlCCAY4YFbIBgTG9UZtVtK6CJpNE7azsu+YzNcse5EaiKvT9kqRFtpqHNX66QH47xsLl53HNCZCYk3601w6lv4Ho6PLrCL0GIMqWRZp2+vVtVF+vzvMdNQhdEFLP6ygBE44NxgFCvgD+Sj0iS8igxTxbmgGD5wxfHgBtAB+xr+sKyGN9QNRagFmUBYGFqhzQGThYaFdVsKlQ1E7zZjgT6sxNbUUw2s/vXwPqbYK+Rq4j/D5+RJwCRkaq/VxSO8fZxbMvRkOfbbrJS8HvtYlV6n6ARwA36sWQGm654yleVK9JZQiH0RWuF/MPgci4kIfukK+YZpOFbRoadb/e4vxfshrwHCBbPntFdJavvxGAMbfS1MkyEZysmEfeWVMFMwx7YIclxmI9j4jB062Bla7winJB/AWjSZcnZ4filC6N/85McvsfpgKUEOyrnVTzuDxJnPD1DmES8BAGl3zD+MJTw/GMhhOu8YSs0pZSZ0mYedVNU87WwjEw2aaYouSTyWgZtqS+V4+S+sUvexXPvyq+iS9K7KWISxf3HT6EHKK5DDJm3woerAHvUkSRwX9/pRTsGBqG0Zccs95lueBjTzm+pX0k4LMspvBLkwfjGU/EWdmrmpEtFYrL8dVYuNZyKZHbVvnKLjfZieMvRhi
 Y6ySN9dj
 XNHjQrK0sp8HOU2bSXGI97SeONRoyj+zkkS7DRyEhqwNWffSW7FrFKF0I1Jp5HovmHkG2/VFXKGlShUnfK8dHceRUTQ8Ojt7OdC6IB2n/YL9rQusA4Ygrka4wTWTKT1nmHx+MZODZL5bjhbsOGnPtTzEp9BU6l/oPE0Hiptv8KuwHkvGxbYxupFjo7m0dkhjGPMuAMe0/QhKEjQbx0FkaL/S0oGUHmE3k8QVhU491U5BMiHvidU4bU3idEz5ufTVybLohBM7xrvcXxFcfTPFzNeiOjLDC4zhGkaPX0fQqiP01rYg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kfree_nolock() skips free hooks that may acquire spinlocks because it
can be called from any context. debug_check_no_locks_freed() and
__kcsan_check_access() are skipped as well.

However, they acquire a spinlock only when they report a bug.
debug_check_no_locks_freed() disables interrupts and walks
current->held_locks, and reaches printk only when a held lock is inside
the freed object. KCSAN takes report_lock only when it observes a race.

Just like KASAN, take the risk of potential deadlock for bug reporting.
Call debug_check_no_locks_freed() and __kcsan_check_access() regardless
of allow_spin.

Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slub.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index fd3de3bee1de..fad19ec6af4b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2708,19 +2708,25 @@ bool slab_free_hook(struct kmem_cache *s, void *x, unsigned int free_flags)
 
 	kmsan_slab_free(s, x);
 
+	/*
+	 * debug_locks, KCSAN, KASAN may acquire a spinlock to report a bug,
+	 * but otherwise cannot deadlock. Take the risk of deadlock for
+	 * reporting.
+	 */
+	debug_check_no_locks_freed(x, s->object_size);
+
+	/* Use KCSAN to help debug racy use-after-free. */
+	if (!still_accessible)
+		__kcsan_check_access(x, s->object_size,
+				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
+
 	/* Hooks that acquire locks or kmalloc_nolock() skips alloc hook counterpart */
 	if (likely(allow_spin)) {
 		kmemleak_free_recursive(x, s->flags);
-		debug_check_no_locks_freed(x, s->object_size);
 
 		if (!(s->flags & SLAB_DEBUG_OBJECTS))
 			debug_check_no_obj_freed(x, s->object_size);
 
-		/* Use KCSAN to help debug racy use-after-free. */
-		if (!still_accessible)
-			__kcsan_check_access(x, s->object_size,
-					     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
-
 		if (kfence_free(x))
 			return false;
 	}
@@ -2728,13 +2734,6 @@ bool slab_free_hook(struct kmem_cache *s, void *x, unsigned int free_flags)
 	/*
 	 * Give KASAN a chance to notice an invalid free operation before we
 	 * modify the object.
-	 *
-	 * If KASAN finds a bug it will do kasan_report_invalid_free() which
-	 * will call raw_spin_lock_irqsave() which is technically unsafe from
-	 * NMI, but take chance and report kernel bug. The sequence of
-	 * kasan_report_invalid_free() -> raw_spin_lock_irqsave() -> NMI
-	 * -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
-	 *  is double buggy and deserves to deadlock.
 	 */
 	if (kasan_slab_pre_free(s, x))
 		return false;

-- 
2.54.0


