Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66D9ECAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA4D8E0021; Mon, 15 Sep 2025 09:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A3C8E000C; Mon, 15 Sep 2025 09:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989D88E0021; Mon, 15 Sep 2025 09:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8501E8E000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:55:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6089C1406DB
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:55:27 +0000 (UTC)
X-FDA: 83891631894.03.651D61E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 21EE6180003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:55:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TBB0SvGp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F3t0KNuU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TBB0SvGp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F3t0KNuU;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3aFYCuHm05s73tMXYFeBnQKfhnxCSiN8/Pi6EDb3yRQ=;
	b=aKKC9zSyLdocxdRdhMOZSL/PNbxBxAm9qkFg/m0x5wr6d4i2M4CuFhKjMdI/D9K6VVjrhN
	Wy6gpISdBHnl0q+xx5evAbeLMKL69IP9UL46RTa5ocv2olj7qkPyMS1Skb5sX1d4HMLfS+
	pn/Aag5t/VhDsyIHSq/sJGqHQw0qf+Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TBB0SvGp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F3t0KNuU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TBB0SvGp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F3t0KNuU;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757944525; a=rsa-sha256;
	cv=none;
	b=KkBbd3EDXeB1aiDO8wYB6wWSk8C5syKmkz08TV4wdyLvtSVvzTcuFrqAgMI4eZhgCrZbT/
	4mIa2u8hEKNSoLuBuMW8Te0w71v6R8i0sJxu9Jigf+1INp8qtot+vIxCs0brTYwMjXluKq
	TOGQP6MkTvslodoSHkAGOarQzpDJv7E=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A5253373F;
	Mon, 15 Sep 2025 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757944510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3aFYCuHm05s73tMXYFeBnQKfhnxCSiN8/Pi6EDb3yRQ=;
	b=TBB0SvGprSGr7Hp+nsaLYIP/LhraF6DmpBLL7FcPjr3SGa+RfMhT+olWwvqPyo5VqJM4RY
	bVk90WcY4QDIytc7Gx+oI7ALh0Lb5tPUVcTefMk5bBTiEZw9PYOhh2bAKCZ+S+UMX1kkHX
	IZVj55dEr98aGBcIaUMW8ALgEm+SmCQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757944510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3aFYCuHm05s73tMXYFeBnQKfhnxCSiN8/Pi6EDb3yRQ=;
	b=F3t0KNuUsvKacjdIp1+wuU530xZy7vYnSiQtPx7FAjudLq/0JFanw/HYHxROGDYlrQMA4x
	/f8HlOL1acJp9TAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757944510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3aFYCuHm05s73tMXYFeBnQKfhnxCSiN8/Pi6EDb3yRQ=;
	b=TBB0SvGprSGr7Hp+nsaLYIP/LhraF6DmpBLL7FcPjr3SGa+RfMhT+olWwvqPyo5VqJM4RY
	bVk90WcY4QDIytc7Gx+oI7ALh0Lb5tPUVcTefMk5bBTiEZw9PYOhh2bAKCZ+S+UMX1kkHX
	IZVj55dEr98aGBcIaUMW8ALgEm+SmCQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757944510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3aFYCuHm05s73tMXYFeBnQKfhnxCSiN8/Pi6EDb3yRQ=;
	b=F3t0KNuUsvKacjdIp1+wuU530xZy7vYnSiQtPx7FAjudLq/0JFanw/HYHxROGDYlrQMA4x
	/f8HlOL1acJp9TAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7567313ADB;
	Mon, 15 Sep 2025 13:55:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6FZZHL4ayGhnVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Sep 2025 13:55:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 15 Sep 2025 15:55:12 +0200
Subject: [PATCH v2 5/6] slab: validate slab before using it in
 alloc_single_from_partial()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250915-slub-slab-validation-v2-5-314690fc1532@suse.cz>
References: <20250915-slub-slab-validation-v2-0-314690fc1532@suse.cz>
In-Reply-To: <20250915-slub-slab-validation-v2-0-314690fc1532@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 21EE6180003
X-Stat-Signature: drfqib1gb147exq9r516a4y8q6qs46o6
X-HE-Tag: 1757944524-546997
X-HE-Meta: U2FsdGVkX19GHnKNtk7bf+6ne6EkzzZwuX38S3fBLBci/2XqPXk3iL3jPHzGdkokNDHOmleo8K5QxrXu0tJ1btKmmO5DNv09hifmI3GkwYEx75vKfsumUO4rMhJ7/rLINgROJT0Z2KUn243pzYaMvVQFkY+3DI4st6DU9OuPTC3I7p3ss0LI/x72p7dl4Odm9hwaeI2ttS5FpE19ykEE+/khAqkOxxdF7ahl5JxOKBqYeHrVJgqHkr4N2WnbBCxVk4VAaSA0prSZsiwm4jyKKCa5BCn+127pNtk+95BchY5iPtYgbmsnzeVOFpDc6vUMzLU8QaCI0/k+vOBMtHiUmC7V6VZzB31FdHCmE7LEtd+x+JIdNEhhTXe9wfhnKU2HyU3wCfqpLttz3Ngtl1xIffHRgNMRrYl5cup2WRhlCWaL/8tyHDOZDRcfJ8/IWwTxFOm0JNY29McxNIg/VT+4eAy8iN2GMU6wVsTGcEdpPDOyR21b9xtBHnMwx/glTDbxnpOR6fIJQOXw1m4wisgic/4hjkUT+HieaaWYxePGJbbZot+PPAyMByDXELfsF47meGqqRrY22K/N6G2OdE24hxMSHoKqeo6VQIWOkNlQAhMbob9aPmaZN54OMBzwN3dtwOKAp7+RcPYVXLb9du3SEhGTndt8a8qjIK1PVt0PL0vEEQnCzGu586JtUdtEQXaRKB5NxbRA81Sp/82F5fTbLzudFp2YSzNxBN4bk44GsJZ44IN+KZE419wvXKcwg3JJn439mM+HZKLGEP+NC1TEqjghWLW4MPxjZQ7K070v0M/L9vSNGMoLG6ilrsiLWLXuYW+FktZZAAvfgU8oVi9EGQAAa8Aw5nXnFgP5TJEw1lAurT22sY+vpinDNk+6nsABHeruMxQFzKxLqkNwoayYrWIXhRN4iwBLztlwvouSpc6gBm4ZJdD+om5+7neo0mAgw6vem4v2S9ef3SwyOnQ
 E2ZAevmf
 w4tijLB6LkidPlp7eMO6mNhJoD6zhavw7BEaK90E0/O3aCsLl4yp/Psp1QZlAqH5kI1uG9wLnNfaLYR1S/7EYZAoRfxKCWdUUjss5xrADApH8AaAXVR9gAFhHFZZ+l3kOOtXa+GtFPO5/EaInZn5Z3ni7NYilKGMB/RGI/c2znnxkgrjLsp0wRHiaGJZhJCHBkl46RtyXfiKGdCUX6zuF0LNbhOEKur4EiN4TuCEhjvr1tzg52LFO249/7s2iwIz8SVEKUzVIRKfrqkRHUbTKE+zuvZhJzcMkI8Yc9cepiZqqrKw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We touch slab->freelist and slab->inuse before checking the slab pointer
is actually sane. Do that validation first, which will be safer. We can
thus also remove the check from alloc_debug_processing().

This adds a new "s->flags & SLAB_CONSISTENCY_CHECKS" test but
alloc_single_from_partial() is only called for caches with debugging
enabled so it's acceptable.

In alloc_single_from_new_slab() we just created the struct slab and call
alloc_debug_processing() to mainly set up redzones, tracking etc, while
not really expecting the consistency checks to fail. Thus don't validate
it there.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 12ad42f3d2e066b02340f2c30a85422583af3c5d..e5b53d1debddd3fe0f941f579a1043a5b976e50b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -821,6 +821,8 @@ static inline unsigned int get_orig_size(struct kmem_cache *s, void *object)
 	return *(unsigned int *)p;
 }
 
+#ifdef CONFIG_SLUB_DEBUG
+
 /*
  * For debugging context when we want to check if the struct slab pointer
  * appears to be valid.
@@ -830,7 +832,6 @@ static inline bool validate_slab_ptr(struct slab *slab)
 	return PageSlab(slab_page(slab));
 }
 
-#ifdef CONFIG_SLUB_DEBUG
 static unsigned long object_map[BITS_TO_LONGS(MAX_OBJS_PER_PAGE)];
 static DEFINE_SPINLOCK(object_map_lock);
 
@@ -1651,11 +1652,6 @@ static noinline bool alloc_debug_processing(struct kmem_cache *s,
 			struct slab *slab, void *object, int orig_size)
 {
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
-		if (!validate_slab_ptr(slab)) {
-			slab_err(s, slab, "Not a valid slab page");
-			return false;
-		}
-
 		if (!alloc_consistency_checks(s, slab, object))
 			goto bad;
 	}
@@ -2825,13 +2821,21 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
 
 	lockdep_assert_held(&n->list_lock);
 
+#ifdef SLUB_DEBUG
+	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
+		if (!validate_slab_ptr(slab)) {
+			slab_err(s, slab, "Not a valid slab page");
+			return NULL;
+		}
+	}
+#endif
+
 	object = slab->freelist;
 	slab->freelist = get_freepointer(s, object);
 	slab->inuse++;
 
 	if (!alloc_debug_processing(s, slab, object, orig_size)) {
-		if (validate_slab_ptr(slab))
-			remove_partial(n, slab);
+		remove_partial(n, slab);
 		return NULL;
 	}
 

-- 
2.51.0


