Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32C89CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEE1E8E0030; Thu, 23 Oct 2025 09:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9F5C8E0002; Thu, 23 Oct 2025 09:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19178E0030; Thu, 23 Oct 2025 09:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A70CB8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:53:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6BA37129B5A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:13 +0000 (UTC)
X-FDA: 84029520666.11.5A765D0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 35BCBC0005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Mdy9BKbL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+uOlwOB7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EPf6Y90J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="P0Lui0/h";
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761227591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BMsUktfL5WtFwPCNB5fqm7HAiF7pw4pM7Su8oc/8OIE=;
	b=kEfW2gD1Uq/P/jbMjzrNVntyQtLzEB31F2lf9FFJsKfnu8sV2CKIbMbi8+omd6EddP40yu
	+vNErgNiyZqJJTM+/548p1P310Et82AKD/XVFq4X4zobvecwOBWE8xx97celYgzkWejvY8
	Y6Sq+q9+zeIBC8rQnPhjofhTWruECC4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Mdy9BKbL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+uOlwOB7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EPf6Y90J;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="P0Lui0/h";
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761227591; a=rsa-sha256;
	cv=none;
	b=BKAU+cqj12GnOcXkRKe3DxwZJVstZPjOLkJV9TuZjCPXpt4xZBQT+KhP1ziQa9qCohGvX3
	xiXcLEUZ/Pe0y2yuJQ0TBPM2xjwA5hEcruoN8Dg9TOntZuIfzLReWmXgPL8C5UitkbTc0Z
	kJBxpqTqn6x7o9tSPw0qPT/QY9qSwPg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 356491F7E1;
	Thu, 23 Oct 2025 13:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BMsUktfL5WtFwPCNB5fqm7HAiF7pw4pM7Su8oc/8OIE=;
	b=Mdy9BKbLm2lN1RACuTP3IEWpgAFVa7Fshte+HriO9fKIlEuuHazko/HNUO+TrJCgysS6DP
	qbMkOSPnAP/Vc0fvnG7qJZY442AWC0MLCqAkwZuFx2sHw/wyTOc+6YgPhSLN2lLdrUj0Ip
	gGDRhrZlP/wqYtKY9DGJUZXjMoYobRQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BMsUktfL5WtFwPCNB5fqm7HAiF7pw4pM7Su8oc/8OIE=;
	b=+uOlwOB7G6UnQ7VofjGwWpSWB1tS3X/MTsf0Mh39EL30Li3sFkbLqfoTr0+SKSACmSseLj
	v75xnLK2L6+NXeCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BMsUktfL5WtFwPCNB5fqm7HAiF7pw4pM7Su8oc/8OIE=;
	b=EPf6Y90JOImCC0jua9VvOIFRXsPvKG0JuNSvVby2rlaB3k8Xbx7Jhme7+aJ2qa/lBKSjDQ
	mZokjHpOlgVfrSoTzRwMAY7Hs+WayoqduU/NJiVdK1sSb+gGEm0ZveoYdySE3r2ODfmuDS
	ThembSqD8ecUvAKO2Y+xRGATadJj/yg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BMsUktfL5WtFwPCNB5fqm7HAiF7pw4pM7Su8oc/8OIE=;
	b=P0Lui0/h5SvlSmXMW6h8A4EhWC9Ya74OAhUoHOBv352Z7+wG0GrnqfP5cCtHxbpB0f+Jg1
	IO7ol//+pdxU3YDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11D48139D2;
	Thu, 23 Oct 2025 13:52:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6O8UBDUz+mjvQQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 23 Oct 2025 13:52:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 23 Oct 2025 15:52:23 +0200
Subject: [PATCH RFC 01/19] slab: move kfence_alloc() out of internal bulk
 alloc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-sheaves-for-all-v1-1-6ffa2c9941c0@suse.cz>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
In-Reply-To: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>, Alexander Potapenko <glider@google.com>, 
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 35BCBC0005
X-Stat-Signature: km6bsgjwf6xq77yxcccf4go489befpw9
X-Rspam-User: 
X-HE-Tag: 1761227590-945749
X-HE-Meta: U2FsdGVkX1/iRvCcYWtELWIifjgMjpgrcPxrYFOD/9ej4lSR92CLzOVX+xV0SjGVcTHm7XtV0Vm6EgBY7tfKUQ1NpEaGkZ+nBYn+62s3MsmIBpKhDoRCWjHmojWL6U/CxzUrNWleBdP7S+C0J1YbeP8txIuIZm8oVK1dwFKl+djR23XeW0kjoSvrd+i2NVA4iUjmAPQpfr2JJIbPurD99Aiy7r4PCntaDcld87jMnTtjktYWFEpnbaDdKtHXhWrAqwLIrU4+SpWJ84IywHoD3mdpzjCUphaXDa2N3rPmFsWY60rBkiihoRSB7Nf35BEyFRtOrD/iSlT53IFSrSn+/8Va7YfxeU8sPXSVabX4YzuobGzhhL+U5L8jNTtwRxivXCMMezKnKjnVsKZXxA6TCH9WOuSoRMnpSDDp3UcDpuzrG29g6BLVxxDERR4ScJyWiQzUhKvO3iKo3UUAocHei/OgA7JMgH+8dwnfkRcH0Xhw/ZbcfM3KVZ/3pava4wvtfZSC4ZlrNYXLdiYJGtkqxDlEvIji7LvOwvN1aPiE6uuweCiNP7ECSv7JJcJSzWMnNGCryAZG4H8lvSHIOcGVhxJcwwlrmlcHa1SXqPGRCl2/9/ZYVJ24uY2P1OfjaTN1wdktye4B0tX1wM3wyOM2RY/GtoZcYkrh5cgUI/nxpZWCfD+BoT6ZGZJpY6B6hSbAbdfK3+XZhsd+9p/rkPWsCbTTLoHcpSb1Ty/39t1rxAYgpY3lmMah8eqUz+Ov9fKq5tUvg5CgnY3LY7lNj6pjQ6SImE9sks88H9lYMFPulvGqjkHUteSwvpMhCsg+VK7+AdloHS5bBGC3hjp6w0a2WmnQAnvxuGD3lfzsuXZ+CIKV1nC52BWKMDHlYUQGjGkm8tYNAF8nysK2ULSg0fxugB7BbIJV9nyqbKFKXddShlk6B6pTJG1aSxgyGAjUMaQHa9QYvKNhCRnksqwxuhb
 MKPIrXlZ
 Kmqt4YPwl6Ym6lS0HG2Cp7s64SyhXlVslfvFGqh4X1/akBHECSr9pvmIT7dSVuvuXduSA0vLjTI7elMC9d7a7RfLLItj6IODU1T1MJip8xgt2+/0aOWR96pbOT+Zk105e7KcEQ/5jQykjbe4cMu6ytgNld/4BnFNKXJNn13YlWNPJ9+ver0idItJFQ4/tkvxKT+xyUOzJcfNt5YcwlqrOgqp1A7ddo1eMtDLBxkxjxUlrGUDnA9usCXQcg7Vatr1kNjIxZuzzukauX4+di/U1fmE3yvbgpmAOdcCKlEY9cDEaDLoU3DKwzVFn/WG6KX9rVErQ
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
index 87a1d2f9de0d..4731b9e461c2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5530,6 +5530,9 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
  *
  * The gfp parameter is meant only to specify __GFP_ZERO or __GFP_ACCOUNT
  * memcg charging is forced over limit if necessary, to avoid failure.
+ *
+ * It is possible that the allocation comes from kfence and then the sheaf
+ * size is not decreased.
  */
 void *
 kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
@@ -5541,7 +5544,10 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 	if (sheaf->size == 0)
 		goto out;
 
-	ret = sheaf->objects[--sheaf->size];
+	ret = kfence_alloc(s, s->object_size, gfp);
+
+	if (likely(!ret))
+		ret = sheaf->objects[--sheaf->size];
 
 	init = slab_want_init_on_alloc(gfp, s);
 
@@ -7361,14 +7367,8 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
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
@@ -7449,6 +7449,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
 				 void **p)
 {
 	unsigned int i = 0;
+	void *kfence_obj;
 
 	if (!size)
 		return 0;
@@ -7457,6 +7458,20 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
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
 
@@ -7468,10 +7483,23 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
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


