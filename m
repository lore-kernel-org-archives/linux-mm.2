Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDBD6606A7B3
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EK0/vsNV
Received: by kanga.kvack.org (Postfix)
	id F31766B05B5; Tue,  3 Nov 2026 09:48:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2356B05B6; Tue,  3 Nov 2026 09:48:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD2346B05B7; Tue,  3 Nov 2026 09:48:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACC226B05B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:48:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 21CDB8047A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:19 +0000 (UTC)
X-FDA: 85394088318.01.1E26CE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7F67F40004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EK0/vsNV";
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Td4JZi2w+id+C91r1df/3sYplbTy8QIwHQVkHMEd4Y=;
	b=JdyJtO2oYNXd3+HLKBWUHfwmISfaX0AaFHv0iuFBoxy1sz7I6GHnfq0uHVPpmFMnPyxPtG
	0Ba1LPb3bdY54h39SMrnnq8G7FJu1dDH/j5xHlQyRmz4PwcSTbGyh6AW1Mq8SOhNhKRzS5
	b9JCELdKsYo8M3OqoaAuclgqcKeV5sQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717297;
	b=7Gk5f9vCOGXoFF24g6cGiNab6M2fZc1pCYfWPEcnNiemqg/jf0is1hwHkGy38p/S8iMtVM
	oTdmbQ+Q1cnkbt69SuJQJrIx2enAPzMtSmlqTPUCm7GbMGZ3rCAJIxdvZTGhexhyGwnZ29
	fwfVqELfSvpQWQo/doAmtk3ldGAZoaw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EK0/vsNV";
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5E6D4389D;
	Tue,  3 Nov 2026 14:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7231D1F00919;
	Tue,  3 Nov 2026 14:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717296;
	bh=0Td4JZi2w+id+C91r1df/3sYplbTy8QIwHQVkHMEd4Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EK0/vsNVB13SfzCl1rZBecIZcse/4JBWehfYgBqwpmG5oqD+xXe18TpP62x6fmfzH
	 hgIHV7c4uDapudMzSLqh8RVyG6f56qZJG58wnGntIv/hoPlUX1DrgfV0UrzJukmklC
	 KgCKk0m1/PdVRvYiFKdcdEaYieBaFf8F8jlGNkaAAoGATsVZWVu1OqmuzQgMY4s332
	 1sVrRaptCMgkDW7+sQN1y6UQh7XiYnQ8cYcGXCdRWzrzFO+FauFx2r7FxlUvV7cB+C
	 SXapQUyyOAVlBK+Av20/qX3mpbtsU1AYwwpMjnZfBWq8IKxDoLJNSKqjtWQYBzEG5G
	 8Y81ok+NYe1hA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Tue, 03 Nov 2026 14:47:52 +0000
Subject: [PATCH for-next-fixes v2 3/5] mm/slab: call debug_locks and KCSAN
 checks in kfree_nolock()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-kmalloc-nolock-fixes-v2-3-19167cfe4779@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
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
X-Rspamd-Server: rspam06
X-Stat-Signature: 99ei7dw7wcjumsgtft9ktyauamdd56di
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7F67F40004
X-Rspam-User: 
X-HE-Tag: 1793717297-819338
X-HE-Meta: U2FsdGVkX1+JBSkqc6CoFafQV86F4n23ik/IZW0WnSg8ZXdkmwKRojTIB9x1FEYlhWF70sCi8N1ieUFnOPnz+jkii9Eujzd6/I5/nmjdn0X7vK3qPUnYGbmKsqgMXWSmilju0FvxPpIJu6RrdcBAfuLNL47/Soo9ex+Xg6UqJ9ZxAk9bKYiaDcvThkCLMOVb+g6kllVDme3/3bihmSmf3Nt0yWw0Ide6KtB7y7mjpA8z4rcgUPOk86CQ3IIFklmZXSAS3LssZgCssqFdfDqbb9iilwq1UFIe4Pf22KtFgLLk66d6wZ/gma3p3F9WbXsOQDsXVVpAn5dFctQMffcmgXgr3VHRV9AFstSwX/18XAzlJINdcnN20KAgbKqXH7f2mtvYMPBPKBgvpzgNOcBvVMaAR5RjfjJ/tHJq13z1t0RoIq37V3wLRL7vHRAZwo2r3k3rIopo4YSRqLP9AU/YHn87XowI4JPT0bcOw6Bc+e6eWZVQIeZwO/9koI+G6ZZdWk93s9gZ+izb8sBX6nJGcfuXDIpbQpdZFELvDNXTc6SWUCFT90jZQQqpoSJnYtHo2gMjuu9CX6ZbugjaJmnpeFd7nX1dqql1AYgUp+R65Ihgou09N9xQmJhoNyaVwg+m3GMnfHAyOxG8YTqqHUPzAb+/guR4093ic9gd5BiOezb+xAtuWnHhyxQt7a7ZlLv/X+asZZTTUveokw9+CcjaqwZ7ZVaUqq4W0ht4e413pN8oruJL2tBAjG2GtZ0FBAkzJG+yZqC05SSTDNqJPbc5pRPx7Jj6MDwDWoZ7ZvcGIwlZvNSWV33YgYZBUqmHopgDKHwP2Mf+9EQT0rZNxeOMRyvJBaL3EZrLXBQKy8Ih4UuAGa9NAVlBjKmYA6kyHqasj2kA1rLe9M2oeTgmf+Z3R1DSxOblQaT5LyabogkkX/vmUM3zxkP5ATEnTNazjQDRQ/vjUkCg768Cv1rTJgR
 pPUk2Jgk
 9PzE9dBNxvM1ffKsZjMU4jRpLw4/iWwOL+BuLcM9VMHvZfnsuXqvogjH4lB2Rd8E9p/rTBBTwCGfCWME5jbTblqhijTEQA7jmAv7UL16aL3iOR8q/bUuE/DzF5a8dbcwelVXU4TokvQgw1LHb9nK0KAkkUkO/SMRYiQKzYrQFGs+XbBJeJP7ozH1y3uHyKJhc7gmz+Fawnvb8dmG+wQeC2KTH7slo8dTvk/wvecBTjT3xFxaLsqQap5O2e+mGxxeMb6+v8Re0RTeTj4PSn30SO6lXyHMu1HSVi1IabVOKh1rBz+U=
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
index 36e7bb93418a..48415f24e115 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2707,19 +2707,25 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
 
 	kmsan_slab_free(s, x);
 
+	/*
+	 * debug_locks, KCSAN, KASAN may acquire a spinlock to report a bug,
+	 * but otherwise don't acquire any lock. Take the risk of deadlock
+	 * for reporting.
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
@@ -2727,13 +2733,6 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
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


