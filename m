Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE862CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5106F6B00B0; Tue,  9 Jun 2026 05:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9046B00B2; Tue,  9 Jun 2026 05:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425D46B00B3; Tue,  9 Jun 2026 05:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 317E86B00B0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E91558DD36
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:51 +0000 (UTC)
X-FDA: 84859824462.26.368953C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 567A78000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E5ttyo6E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1k7/eTSRSHQNvSATdJogMPt72tbv5SKy6aqMXKlQdps=;
	b=zM8L/VFUKaKN0IAGja9SieTZEmVIhK5yMWuXxgwjYF07x4DhwUrOuJbzwd9YSjXTIx1aJe
	3oz4iFUGqPM+RQuwmY53haGx/zeR3lvXApeTG50/vOtMyMga21XOgKMo8fMwit/lpeVvDx
	URaLmAqBPxv1hnCkF8/5ry9fOOoyvKw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E5ttyo6E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996730;
	b=d8i8HQVF6VfggcnVyGg3QKxAlJAUXHloG2sWkBP7/yqRr1k71L2zFICEtl1nsOojeZyFfI
	UTgjjhqKbiprhFnAQvifI5MOtfQShPfWjCzIsukrFnPbeqgTBHCe81laIBGWjmziI7oYOp
	4pFieiJMp/bybL39NfqfNnI+lEDgfcI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0D7D601DC;
	Tue,  9 Jun 2026 09:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B091F00898;
	Tue,  9 Jun 2026 09:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996729;
	bh=1k7/eTSRSHQNvSATdJogMPt72tbv5SKy6aqMXKlQdps=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=E5ttyo6EIovS3/k53exumTPWOrIocAsvVAtZsCcCAqVey/Y2FBd9f/WqJKuwQ34V7
	 kZqDaW/cdyFFmirlN+XMZ5wiwErTgpFbnVW+UyKwMOrAWfy9zdteOBHvniutyD9etH
	 mCNKy7Q3nXTcBVT9RCleh9vO5LhJyH8tnQfNuK9RcJZcGFY2YbDJt+nN9ioqA5lfil
	 SIixSHW6fPLIoKLLLyQQiH7H7krkaSQ9lIqYujeiGaDBX6QIp192Ac9jOW5f5SkPjo
	 AwgtiSNSX4MONA+8Ujv8Vst7Szur37JtBHHd2Nee6RH9bBdPDsDlO/M7dMUSaOXLbq
	 GDWZH6ix/RM1w==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:59 +0200
Subject: [PATCH RFC 14/15] mm/slab: replace __GFP_NO_OBJ_EXT with
 SLAB_ALLOC_NO_RECURSE for sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-14-2bf4a4b9b526@kernel.org>
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 567A78000C
X-Stat-Signature: o5dmpg57rzu4brhi45mxnx4hmddjpssh
X-Rspam-User: 
X-HE-Tag: 1780996730-564513
X-HE-Meta: U2FsdGVkX1/3F+Yhu/8hmdJoXWiB0Jl/pct5wZz12srdQRqkl/6zwQb4/dgSaV43nv545NuNPTjXkzLuUQbUpbenSUHUKHhfrJj3CdT8Zde7Ly5u+16sB02SoejKvsYmqAqQIyT+twShRdaACmy17DJBmsv5y+m9f3zmxQltYT0V4vZe8YtiH+5Yk46IZbXtyGck3yaqWNKTR0GDOhTQ4o24A5ev2JoroVz+1UDnYYcJaVJH2W8Ak4ux5JwMBq4SyIingCSi7tIcCUOnMqQ9a4ccXab38J3pczO1PYQR2VPA9kd3SkVdSrGe4z12sR4C5/u9PEmRPbR+bzKHEfCzI8FDb/yZEQ1CAruHNPz3as4HX6UWFqyk54JPerlhVb3ihUjd8SeJyTDDvMtT2raI67wmGK5Fc4ZwTn/1R0/PRPRjFDdQJvdpT2EP7fiiN0wzmnjFOXr+hhVLCIPqOFQ+RgtsivTSoiBQpKagdzrEZrrSO0i6lReFCzTO0x3B41peWiIDtvpnNcSYXbPZSpsv852iqoVopRpmqDnp/I12A1O1MkO4qD8md54FLApXNn4pWdfmNXgQeHaT8h4IJu9nCW0dJFfn58sigCjncP5tPIv1SrTTutqkqzMSdSNku4gRoMn8xes9GXQPr+C8B4ODziwyA4U0FORvg5yb64neUPXJYV+HdV2vs5gV7Nu2cVb0XXtAepoDVWdL8UMAQiPED3Qsb1J73QcVJRXPetm44LNu4F3rhCHrWtLjIjq0SClsBBgV6mW64yge9PcIvtuFBdd0DJu/4G2gvnQmHWrIPBlIngm6G8dn9bSGrIQfgSvuGC3NEuOg7HdMpg5NW6hz3AahJkS1/By8eSaYI6ajB+zREQa6QnEtvEnb0HliPox8DwWnmOAepICoLTZFb+wS130jAkMK/jB4lPerAB3oOBJD91aMweOxyT6I2k415oMn9tzFN7TKS4o8hz5VW3G
 dtzP2ZkA
 s/Ozx7X3QlA6uzxCvahDLZfsMTNnMVS21Bg4gh59y4oPKOApbhJhwUI4iSUF/WuggtXTcYIPi37LW11UUCo8OHhpJw4uETMv2C1xn03p/m7HhJmMJpcziSPCUyADaWAHcwjZClln3/WAvvnJbKuWkAtPsn2xm2ZhB7vMPJrAE2IH+sl4aXzT3mgA3dKJRHMUx0wE8qbMCLYU3UhyhPiF0Phad7FGDqqzdMLBzFfq0vbxfC96B+KUiNdsSE/F9k9TGOhOnozwdzwq/KLdxaqXW0SCyrFwr/5i+WY0DTKL4dRfO0ps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Finish the switch away from __GFP_NO_OBJ_EXT by replacing it with
SLAB_ALLOC_NO_RECURSE when allocating empty sheaves. Pass alloc_flags to
[__]alloc_empty_sheaf(). Callers that can't be part of a recursive
kmalloc() chain simply pass SLAB_ALLOC_DEFAULT. Use kmalloc_flags()
instead of kzalloc() for allocating the sheaf.

This leaves __GFP_NO_OBJ_EXT with no users, to be removed next.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8a655636dee6..26ec015efdba 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2756,7 +2756,7 @@ static inline void *setup_object(struct kmem_cache *s, void *object)
 }
 
 static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
-					      unsigned int capacity)
+				unsigned int alloc_flags, unsigned int capacity)
 {
 	struct slab_sheaf *sheaf;
 	size_t sheaf_size;
@@ -2767,10 +2767,10 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 	 * bucket)
 	 */
 	if (s->flags & SLAB_KMALLOC)
-		gfp |= __GFP_NO_OBJ_EXT;
+		alloc_flags |= SLAB_ALLOC_NO_RECURSE;
 
 	sheaf_size = struct_size(sheaf, objects, capacity);
-	sheaf = kzalloc(sheaf_size, gfp);
+	sheaf = kmalloc_flags(sheaf_size, gfp | __GFP_ZERO, alloc_flags, NUMA_NO_NODE);
 
 	if (unlikely(!sheaf))
 		return NULL;
@@ -2783,20 +2783,20 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 }
 
 static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
-						   gfp_t gfp)
+				gfp_t gfp, unsigned int alloc_flags)
 {
-	if (gfp & __GFP_NO_OBJ_EXT)
+	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
 		return NULL;
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 
-	return __alloc_empty_sheaf(s, gfp, s->sheaf_capacity);
+	return __alloc_empty_sheaf(s, gfp, alloc_flags, s->sheaf_capacity);
 }
 
 static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 {
 	/*
-	 * If the sheaf was created with __GFP_NO_OBJ_EXT flag then its
+	 * If the sheaf was created with SLAB_ALLOC_NO_RECURSE flag then its
 	 * corresponding extension is NULL and alloc_tag_sub() will throw a
 	 * warning, therefore replace NULL with CODETAG_EMPTY to indicate
 	 * that the extension for this sheaf is expected to be NULL.
@@ -4673,7 +4673,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 
 	if (!empty) {
-		empty = alloc_empty_sheaf(s, gfp);
+		empty = alloc_empty_sheaf(s, gfp, alloc_flags);
 		if (!empty)
 			return NULL;
 	}
@@ -5047,7 +5047,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 
 	if (unlikely(size > s->sheaf_capacity)) {
 
-		sheaf = __alloc_empty_sheaf(s, gfp, size);
+		sheaf = __alloc_empty_sheaf(s, gfp, SLAB_ALLOC_DEFAULT, size);
 		if (!sheaf)
 			return NULL;
 
@@ -5092,7 +5092,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 
 
 	if (!sheaf)
-		sheaf = alloc_empty_sheaf(s, gfp);
+		sheaf = alloc_empty_sheaf(s, gfp, SLAB_ALLOC_DEFAULT);
 
 	if (sheaf) {
 		sheaf->capacity = s->sheaf_capacity;
@@ -5376,8 +5376,7 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 	void *ret;
 
 	VM_WARN_ON_ONCE(alloc_flags_allow_spinning(ac->alloc_flags));
-	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
-				      __GFP_NO_OBJ_EXT));
+	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO));
 
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;
@@ -5890,7 +5889,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	if (!allow_spin)
 		return NULL;
 
-	empty = alloc_empty_sheaf(s, GFP_NOWAIT);
+	empty = alloc_empty_sheaf(s, GFP_NOWAIT, SLAB_ALLOC_DEFAULT);
 	if (empty)
 		goto got_empty;
 
@@ -6074,7 +6073,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 
 		local_unlock(&s->cpu_sheaves->lock);
 
-		empty = alloc_empty_sheaf(s, GFP_NOWAIT);
+		empty = alloc_empty_sheaf(s, GFP_NOWAIT, SLAB_ALLOC_DEFAULT);
 
 		if (!empty)
 			goto fail;
@@ -7619,7 +7618,7 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 		if (!s->sheaf_capacity)
 			pcs->main = &bootstrap_sheaf;
 		else
-			pcs->main = alloc_empty_sheaf(s, GFP_KERNEL);
+			pcs->main = alloc_empty_sheaf(s, GFP_KERNEL, SLAB_ALLOC_DEFAULT);
 
 		if (!pcs->main)
 			return -ENOMEM;
@@ -8485,7 +8484,8 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 
 		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
-		pcs->main = __alloc_empty_sheaf(s, GFP_KERNEL, capacity);
+		pcs->main = __alloc_empty_sheaf(s, GFP_KERNEL,
+				SLAB_ALLOC_DEFAULT, capacity);
 
 		if (!pcs->main) {
 			failed = true;

-- 
2.54.0


