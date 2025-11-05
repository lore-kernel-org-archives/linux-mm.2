Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FD30CCFA07
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6DE8E000A; Wed,  5 Nov 2025 04:05:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF8B8E0002; Wed,  5 Nov 2025 04:05:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29AB68E000E; Wed,  5 Nov 2025 04:05:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 050378E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:05:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B13014A48D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:34 +0000 (UTC)
X-FDA: 84075970188.27.DD8FC23
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 56A2180012
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JqN8C7wL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qp3nFStx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JqN8C7wL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qp3nFStx;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762333532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dS0i3Iby0OJwb+mg8PeOF13C4McpBxa53amtQoTdGRo=;
	b=aqOmBdZ0xDwsANgIU7FcjwRhlYesKw8gtHki7XRsa4u19MSXpiHel71gv1D8VSo8oW3oxE
	HccnAvJx2ClQrCb8wcunBbAvIMrdQGNAVFS7CkXWXA8D9+T7dcqP3uhgXBeEYswXAapOyb
	hxQX/NtuYB/8HbV4zD4rs4lNft4UclA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762333532; a=rsa-sha256;
	cv=none;
	b=WzoI6lPm/uhIk8OW5Ckcv5Anh6L77Hz2+sbJGKlpHs1h3tTu9psvHmu6sFg7HsX//NiQq9
	f6dSxJV4ekFF1TK/4pf+LUDSgqQh39/jB/ClD6JJqwA8hjGNI3v9KJvKNPR7OXNeBWWFGG
	pgiQ89gd/ESqYRx72Pq7dTnmz1Yvnbk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JqN8C7wL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qp3nFStx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JqN8C7wL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qp3nFStx;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B87E921181;
	Wed,  5 Nov 2025 09:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762333530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dS0i3Iby0OJwb+mg8PeOF13C4McpBxa53amtQoTdGRo=;
	b=JqN8C7wLBSfHWyDRgrkAOSu/ZqlR3yJqJ8KU2mHbmcLeRJR3Puhk1VkHbhS+DnYUo84Rxj
	Bp6tmt/H6vXLVTlJ9sgHP38KdoeBkJ4wsk6+6RsDMDrAFDbzB/YDGEnUdskgN1Xt4CySuV
	1i6OfYeQsJhfHbErsMnTeYmaTR8DRSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762333530;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dS0i3Iby0OJwb+mg8PeOF13C4McpBxa53amtQoTdGRo=;
	b=qp3nFStxU4c7UxtZa4zaEZis3Q2Owsk6R3hvx8A9339erKrkkHtqvwDTDHrSVq/PWep5rB
	uEB+BSnmsqmqRqDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762333530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dS0i3Iby0OJwb+mg8PeOF13C4McpBxa53amtQoTdGRo=;
	b=JqN8C7wLBSfHWyDRgrkAOSu/ZqlR3yJqJ8KU2mHbmcLeRJR3Puhk1VkHbhS+DnYUo84Rxj
	Bp6tmt/H6vXLVTlJ9sgHP38KdoeBkJ4wsk6+6RsDMDrAFDbzB/YDGEnUdskgN1Xt4CySuV
	1i6OfYeQsJhfHbErsMnTeYmaTR8DRSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762333530;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dS0i3Iby0OJwb+mg8PeOF13C4McpBxa53amtQoTdGRo=;
	b=qp3nFStxU4c7UxtZa4zaEZis3Q2Owsk6R3hvx8A9339erKrkkHtqvwDTDHrSVq/PWep5rB
	uEB+BSnmsqmqRqDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A87613A91;
	Wed,  5 Nov 2025 09:05:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AEN5JVoTC2lSBAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 05 Nov 2025 09:05:30 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 05 Nov 2025 10:05:30 +0100
Subject: [PATCH 2/5] slab: move kfence_alloc() out of internal bulk alloc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-sheaves-cleanups-v1-2-b8218e1ac7ef@suse.cz>
References: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
In-Reply-To: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>
X-Mailer: b4 0.14.3
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 56A2180012
X-Stat-Signature: zgfte8uf4esyzcwsn1xno9qpxyrj4da1
X-HE-Tag: 1762333532-998149
X-HE-Meta: U2FsdGVkX19zZex8MPhqr0FkxgzMVyEd6JLbQdufSc+F+KmqdYTAwoi+8sb1U8ddI6nzVR4zZPjRpJaikqH0tkRjSL2nc0NO8IW63anyvJUNe4jv/O11Yt/z8Ldva24Rk+5gJeZpgINmSFDUHkovmUVVNp7uEUq92xbjq/L8dcDvpZwagW9TfQ4Uy0v6CPzVYiSi9kR8+kWszyqal5p/ggFBkSBvPTE0Jh4TfdJC//KGUfJSWy+nwPAsQlkJJEAj3667cqteeGhYMJu/OEeics0AvZclzDktSrukcrwVlePXp1AMvv/AMBFifv8WkuQzmcHt0PBxpXSb7qmWsckJEtY42ipBjSJURFXmbRAv/fh08TTI2MGrqgwI2NcUnHzwC1CvXxv7weMzPxwN1vW8eizIFkfXqU3fNLDebjEQAgXoDmRa5rWE+OhtcIwMUG9WqPwXQfaOgWSeWJi1G/qv9C1oi5eIsjZG64vr46x8rQ+dnNLlNXg9ywh2T4i1T8W61EexK0jV4T8Ij/0JT2xP4evj4LutpznKQurLTjMh/INpD/ueMG+3/G4lJljfXG+q10GOuhUHtfyK4SIMuBI+u2E0Izs0QDtw6koLnFQa4nCGxtHPWYS9Zlanf6GCxRShAX7f6U1rWNxMQvMk/7oB22ggvMpUE4sULugV/HjFntPjP2xR2cztOozIxXyQwUTsrApGqbQ446TVYhh6ZVF06/jFIZCJfI+/60znnyvxp7WFiJ2YtlpxkUEVKzcRGeLOxrzBfvZS9EDaYYC0D1uEp+nvIp6dSynAOo4cyK+r0oxc/LO+o5NsrvxdKyDtVRqP5+WYKhmsmo4qeUvuTebR8Fg1lwwRDSbrx1LtocdkUb4/NcjNcmbUEmZL5yhKTEKYKOmxDN4cWo410E+LDfUVFKTlc90MHXiXNrsPtaYGpUGS233q0zvnsIaLKlfJsjr2nRBRac/DI4LJYyOFW2J
 Tb2xZ8Zs
 aA90lb2mBfSeXEpGcXkXqsirHEipYzeXKBZhJ0Rkdcof0fsC+C5lVkrELjihXQeCQs7ivi7hmaEsYSinZ4/mGhnApPDvL5ry8VlIx3TG6qXF2JPIIuZ06xwQsLfwtLQuQM9DmK1Z5ptkxBbjYoyUJRvKxW8pa8yXDEA3Q3THKfKs68kguvPaiv7yg79IFRKLyaGmMcVTVDgf0M+rlmSFsw2EN00SSo8tWFj2ovaPYF7XBkpDt4ZA77kdtsh77jx53Aj75uyagCeE7m8wUvq0StrUhtmke9u+LW4qy/PDlzbktesW/s2qpndU+rsR8OmfqiSPf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SLUB's internal bulk allocation __kmem_cache_alloc_bulk() can currently
allocate some objects from KFENCE, i.e. when refilling a sheaf. It works
but it's conceptually the wrong layer, as KFENCE allocations should only
happen when objects are actually handed out from slab to its users.

Currently for sheaf-enabled caches, slab_alloc_node() can return KFENCE
object via kfence_alloc(), but also via alloc_from_pcs() when a sheaf
was refilled with KFENCE objects. Continuing like this would also
complicate the upcoming sheaf refill changes.

Thus remove KFENCE allocation from __kmem_cache_alloc_bulk() and move it
to the places that return slab objects to users. slab_alloc_node() is
already covered (see above). Add kfence_alloc() to
kmem_cache_alloc_from_sheaf() to handle KFENCE allocations from
prefilled sheafs, with a comment that the caller should not expect the
sheaf size to decrease after every allocation because of this
possibility.

For kmem_cache_alloc_bulk() implement a different strategy to handle
KFENCE upfront and rely on internal batched operations afterwards.
Assume there will be at most once KFENCE allocation per bulk allocation
and then assign its index in the array of objects randomly.

Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 44 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 074abe8e79f8..0237a329d4e5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5540,6 +5540,9 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
  *
  * The gfp parameter is meant only to specify __GFP_ZERO or __GFP_ACCOUNT
  * memcg charging is forced over limit if necessary, to avoid failure.
+ *
+ * It is possible that the allocation comes from kfence and then the sheaf
+ * size is not decreased.
  */
 void *
 kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
@@ -5551,7 +5554,10 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 	if (sheaf->size == 0)
 		goto out;
 
-	ret = sheaf->objects[--sheaf->size];
+	ret = kfence_alloc(s, s->object_size, gfp);
+
+	if (likely(!ret))
+		ret = sheaf->objects[--sheaf->size];
 
 	init = slab_want_init_on_alloc(gfp, s);
 
@@ -7399,14 +7405,8 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 	local_lock_irqsave(&s->cpu_slab->lock, irqflags);
 
 	for (i = 0; i < size; i++) {
-		void *object = kfence_alloc(s, s->object_size, flags);
-
-		if (unlikely(object)) {
-			p[i] = object;
-			continue;
-		}
+		void *object = c->freelist;
 
-		object = c->freelist;
 		if (unlikely(!object)) {
 			/*
 			 * We may have removed an object from c->freelist using
@@ -7487,6 +7487,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
 				 void **p)
 {
 	unsigned int i = 0;
+	void *kfence_obj;
 
 	if (!size)
 		return 0;
@@ -7495,6 +7496,20 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
 	if (unlikely(!s))
 		return 0;
 
+	/*
+	 * to make things simpler, only assume at most once kfence allocated
+	 * object per bulk allocation and choose its index randomly
+	 */
+	kfence_obj = kfence_alloc(s, s->object_size, flags);
+
+	if (unlikely(kfence_obj)) {
+		if (unlikely(size == 1)) {
+			p[0] = kfence_obj;
+			goto out;
+		}
+		size--;
+	}
+
 	if (s->cpu_sheaves)
 		i = alloc_from_pcs_bulk(s, size, p);
 
@@ -7506,10 +7521,23 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
 		if (unlikely(__kmem_cache_alloc_bulk(s, flags, size - i, p + i) == 0)) {
 			if (i > 0)
 				__kmem_cache_free_bulk(s, i, p);
+			if (kfence_obj)
+				__kfence_free(kfence_obj);
 			return 0;
 		}
 	}
 
+	if (unlikely(kfence_obj)) {
+		int idx = get_random_u32_below(size + 1);
+
+		if (idx != size)
+			p[size] = p[idx];
+		p[idx] = kfence_obj;
+
+		size++;
+	}
+
+out:
 	/*
 	 * memcg and kmem_cache debug support and memory initialization.
 	 * Done outside of the IRQ disabled fastpath loop.

-- 
2.51.1


