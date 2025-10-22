Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22EE6CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 17:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78CBC8E000A; Wed, 22 Oct 2025 13:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715AA8E0003; Wed, 22 Oct 2025 13:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6F38E000A; Wed, 22 Oct 2025 13:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 473E98E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:23:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C26DB13BAA4
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:23:33 +0000 (UTC)
X-FDA: 84026421906.11.B7DBF82
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3518EA0009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:23:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yVBSxjfS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="NQZPIom/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PhYuuFXQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=belS6VmZ;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761153811; a=rsa-sha256;
	cv=none;
	b=vPGd5onQjnw3wsGAgd4w3r3Q7GUls7FPxXOmkvOR+mpZ8BX8+upJ0qBWSR5ylkrK6SWUs9
	/susAr6dRXD/MqzxpHPg6tpMg/B9+eTGKWwhhblHyq6JSUfYHWvrgKGVnM+SCyEnhzuPM8
	+FEfnHjEO6mjBsmqGRsxvNhCSxu8DZQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yVBSxjfS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="NQZPIom/";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PhYuuFXQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=belS6VmZ;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761153811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kVnlSRM+u7M2JbzO+iE6nuKFeIyJgHgIeVpcpBnG6as=;
	b=4M/s8KS8O12zrBJtXTCZiZ4Ey722bbRe4r34QBE68luIK+Q04F3t3uaOuh3IuZZt/Z8I/5
	DxxmVAXu6AgfrnGJ0N6fLRUrmBlAWIhLjxWbB/abJMw4sBIp/WDiwhyEvuUZgwj/NrjXRO
	DNsyqRYg8HXtyVb+Qpk43Ptgxh23DzU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1ED08211A9;
	Wed, 22 Oct 2025 17:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761153805; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kVnlSRM+u7M2JbzO+iE6nuKFeIyJgHgIeVpcpBnG6as=;
	b=yVBSxjfSKjf8/n8/R6swNQZcAHfZqKcRrr2Aso+r+VF6VPkqcDVWVNezasm9hMKi9pUy3k
	wesSnpzT9sy4KjlRRnXhiGiysu7wAD+0rhSlcDAcrID5l/urLeN00tFBJFY/Ot1Kll2D00
	wfU8HFp0NG3OzQCnH2IrgnEGy+0h9MM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761153805;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kVnlSRM+u7M2JbzO+iE6nuKFeIyJgHgIeVpcpBnG6as=;
	b=NQZPIom/d30d9j58TNh4qABJN7/QCn1vTxX4knSyeEYvgRkKCZmlquMegMD5L1xnbR1UmU
	orZD661xfs6a4EAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761153801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kVnlSRM+u7M2JbzO+iE6nuKFeIyJgHgIeVpcpBnG6as=;
	b=PhYuuFXQecljfIafTw8nWYru+Ujmf9dpdUwYeifYKoEuEaqiPfgHEvf9hiGwtAxwwnknXa
	w8MtWDsDQ7qk2H9QiJyoq5su98IgvEsaWJ0coouOGzszjAg7KxLA89Q97DXFTXS45gqLpL
	CY3mYWncbnBXk1HZcewU1YVyMA46hBw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761153801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kVnlSRM+u7M2JbzO+iE6nuKFeIyJgHgIeVpcpBnG6as=;
	b=belS6VmZBauqGJMHXhrM3Jrp9gfkini7Tda9BGTAqRfh2OFKrjlBhT0XPaSALWU12WU0Fo
	6gzdZSlgv2Pk0HDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8B4813A29;
	Wed, 22 Oct 2025 17:23:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TyhgMAgT+WgoSgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 22 Oct 2025 17:23:20 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 22 Oct 2025 19:23:11 +0200
Subject: [PATCH] slab: perform inc_slabs_node() as part of new_slab()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-fix-slab-accounting-v1-1-27870ec363ce@suse.cz>
X-B4-Tracking: v=1; b=H4sIAP4S+WgC/x2MQQqAIBAAvxJ7bkGFIvpKdFhttYXQ0Iog+nvSc
 WBmHiichQuMzQOZLymSYgXdNuBWioFRlspglOm0Mga93Fg2skjOpTMeEgN6RdYuNFDvPdRyz1y
 1/zrN7/sBFSnOcmUAAAA=
X-Change-ID: 20251022-fix-slab-accounting-f0abbda8a6ff
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
 Alexei Starovoitov <ast@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3629; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=lvP1zUvr7+W9aflgEwbNBpEd2W2lGAnG76Ysu0c45jw=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWT8FGbdEJ7NVOh+6N6t7A9PGNW1C+yrbSwXizo8u6la5
 F/m08DUyejPwsDIwWAppshSvfuEo+hMZY9pHr4fYQaxMoFMkRZpYAACFga+3MS8UiMdIz1TbUM9
 Q0MdIJOBi1MApjrkFvv/1PlF666qrXnyWp9f9qTIgnkbz/P7PGmLfrXwy4qrDxalumc2+U0KCPL
 WZJ630T6MO+elxlyv2SVSH7mCRFO+e5RZX1AL/v3M8rW4sPapR4cO6olke3p/W/v/iFn6bD+N54
 nTnb72FrzZ1bV+8QyWy19LHvHZrFpg/OMl4/Z39xyyMzxqrxYJf35WUs4j/Px2xquJUdmvhW5WP
 g5SDuT5tvF4scVkB75pjhpzHdg0TNP5E2ZoyU9tua8r+4dJsJxvojDD44SScxd/25zzkTu0zX2i
 VYC6ge7rPVfn9Ww/YTRj/l+pjb7GuiITMqLF25bYdwb0WiVqXmlXLu0oVflwcoKOim1Jjc7+sGM
 5ZYEA
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Action: no action
X-Stat-Signature: p9fgcnubuowsdhxp5t5pb8i8sjrqwzjt
X-Rspamd-Queue-Id: 3518EA0009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761153810-429216
X-HE-Meta: U2FsdGVkX188TGcokySFcq/mgCWzEYK87/EMp1ydvb1BvEJXywGDpVz4fq9JORl022QHT+jnB0nt/YJuemUaaoNBceEYSzCibn/9/OMzfZuO2hXbNUjDf7e51mjFsUH52MMfjT5xnopI3f3VvcIpe1wBVJmoz19Vwxa23wFQWFdmTMdm1M3sFiO95wObtYtGuXrHqiF4HaI3bKv947J/+D02NPA1ZUTKZENGikDV/JpIrX9hasSi6vyxi2Enrg1EkkBtCR3qFFDZ/TNyx4P00yE9x6lEN1ArvYt9wZxRSeMQF9h/Wi+xiR1fW1P0NKIUAFjtqMxSksX0DWScH3ljsBGf19pRBJWyEnbDE+RTRg1CeECe2ZjoMBokZ+ERRMHHrhFuqLnQ5XVaVW75YK/OP7MeNE6/+t7jjizh4lIXB+J3uLn9DRo5uwtONldib3i8/HSsOma9WcttrmXMQxSpGbSkumo1/m0TsDe0jk/vpmcI93ANsBP6X/eL1wFKJTQ9aRW2fGyCTpgz2F51wSJRLAd1ocfezceJjDgcJ71TqEKBXbofCErChMMD6787M/U4xxog3kgBaVJANafWxEK6dnWLfXsmgciA8/qItUsiDfFGQ9Qr0sRvs6ORaBym2bGMhrgg0CFF3k6chP5NKXnLGrBlfJk11EO1Kz/c+THea53Nb6vpWNbluVbE/uTTWWGFfZ2dyNnbIDsM66XdhqIeA5G8zpvW0OnNfJH6zKQ3ue6yOqzInGc6jkp7HmxDnJRVFUpEc5z4AAAQj0kAAoG8hxbktPg8hfjBKN4nD9GgoWxCyk1VwLR0DSxtFismKhZAFPnVa9JssGFsnS1iX/VvHadF3h1mlFlhnjDq9TyIhJQb1h/0NfcTeOdzYf6L2n1rV8SLdK3fkelhBpS0Tn7sbkuYpM25BFGIlLbfcvTb5g3Nek997CI8wC6LItvvKiJyrr0uSDR7h32gjHX9WZU
 ceptml2E
 EDGf4KefCDS1vjB15hCa9xl5r0FMXLammGZo7tna+ertsIH198eLLUj1mH/CZJ82NgTHNSbFqyOt/NhX1XRsWydAiFPqSLzrJNOvIkYVjnPjZubylX9pAiGBHyBbC3zNwzuXeba7o7jRSy66meuMgouwWcP9iGD5VxiNIqNFOmaZlj6OCg/D/m1dixw+aKaXKHL4GNF/hAy5ZMff/f8lr5YL8TJpB1rHJBwFoZ8oBWZnVXu0PZE4rE17F/ZeH3SYo6dR4h7VE+sZ6aZhE1ml2k/Hbbrbk6i2Z7+hI0Leq3+fiP/3XwOb06EcOO3A47V6C80xmdvLl3lhYmxY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit af92793e52c3 ("slab: Introduce kmalloc_nolock() and
kfree_nolock().") there's a possibility in alloc_single_from_new_slab()
that we discard the newly allocated slab if we can't spin and we fail to
trylock. As a result we don't perform inc_slabs_node() later in the
function. Instead we perform a deferred deactivate_slab() which can
either put the unacounted slab on partial list, or discard it
immediately while performing dec_slabs_node(). Either way will cause an
accounting imbalance.

Fix this and also make the code more robust by performing
inc_slabs_node() in new_slab() itself, and removing it from its callers.
As a side effect, in the theoretical case where the new slab is
immediately leaked due to debugging consistency check failure, it will
be accounted (as full) in /proc/slabinfo anyway, which is not wrong.

The exceptional caller is early_kmem_cache_node_alloc() where the node
for stats is not yet initialized. We can handle it by using
allocate_slab() there as the gfp flags are known and fixed and we don't
need need new_slab()'s fixups.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 23d8f54e9486..dd4c85ea1038 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3268,13 +3268,21 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 
 static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
+	struct slab *slab;
+
 	if (unlikely(flags & GFP_SLAB_BUG_MASK))
 		flags = kmalloc_fix_flags(flags);
 
 	WARN_ON_ONCE(s->ctor && (flags & __GFP_ZERO));
 
-	return allocate_slab(s,
-		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
+	flags &= GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK;
+
+	slab = allocate_slab(s, flags, node);
+
+	if (likely(slab))
+		inc_slabs_node(s, slab_nid(slab), slab->objects);
+
+	return slab;
 }
 
 static void __free_slab(struct kmem_cache *s, struct slab *slab)
@@ -3415,8 +3423,7 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
 					int orig_size, gfp_t gfpflags)
 {
 	bool allow_spin = gfpflags_allow_spinning(gfpflags);
-	int nid = slab_nid(slab);
-	struct kmem_cache_node *n = get_node(s, nid);
+	struct kmem_cache_node *n = get_node(s, slab_nid(slab));
 	unsigned long flags;
 	void *object;
 
@@ -3451,7 +3458,6 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
 	else
 		add_partial(n, slab, DEACTIVATE_TO_HEAD);
 
-	inc_slabs_node(s, nid, slab->objects);
 	spin_unlock_irqrestore(&n->list_lock, flags);
 
 	return object;
@@ -4680,8 +4686,6 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	slab->inuse = slab->objects;
 	slab->frozen = 1;
 
-	inc_slabs_node(s, slab_nid(slab), slab->objects);
-
 	if (unlikely(!pfmemalloc_match(slab, gfpflags) && allow_spin)) {
 		/*
 		 * For !pfmemalloc_match() case we don't load freelist so that
@@ -7697,7 +7701,7 @@ static void early_kmem_cache_node_alloc(int node)
 
 	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));
 
-	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node);
+	slab = allocate_slab(kmem_cache_node, GFP_NOWAIT, node);
 
 	BUG_ON(!slab);
 	if (slab_nid(slab) != node) {

---
base-commit: 6ed8bfd24ce1cb31742b09a3eb557cd008533eec
change-id: 20251022-fix-slab-accounting-f0abbda8a6ff

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


