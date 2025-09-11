Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30687CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 882AB8E0010; Thu, 11 Sep 2025 13:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834048E0006; Thu, 11 Sep 2025 13:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721888E0010; Thu, 11 Sep 2025 13:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8118E0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:02:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1AAE213B2D6
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:02:59 +0000 (UTC)
X-FDA: 83877589278.12.2AC14DB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id C974340010
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:02:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zqAMFcRd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SZN5HjVQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zqAMFcRd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SZN5HjVQ;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757610177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6f2UzExln6BeKZDBJcPia3VoQR4i2uiv1uWrKQDThX8=;
	b=madiMpJT52cpjamOG40ppI/yIBOyqZpBEF1z2uDX5FZtEY+7X0R8n3xSnUeKqZXdrn+o0g
	y7juUVeFnBVhRzGS9XL+RSKgSxlMCJ6XtL324NJXO6X9EUv19E8JM6UHc6K28j/Yzx1LTj
	fdmA4zt0cvLdw5Swzyw9Lq8vJnZb3oQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zqAMFcRd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SZN5HjVQ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zqAMFcRd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SZN5HjVQ;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757610177; a=rsa-sha256;
	cv=none;
	b=e8iMQ5fn3SPKCbFzyzXJ5VDXmw3HWhKUM27MRj9ZpJ4jzuorB2l5OKlMcAAvNbEVIQFeBP
	fbPX/oHTCFiIhH4PvMhrBFPD8BJKiALxyn+wlO9+GofhD3zcI7zFOHWAz3jhkvkZ3O/ayH
	xItaWNw3Ie33ht5GPocvIH4RLHce9HE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 20C1576481;
	Thu, 11 Sep 2025 17:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757610155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6f2UzExln6BeKZDBJcPia3VoQR4i2uiv1uWrKQDThX8=;
	b=zqAMFcRd0T8/Twk0PQTF4F5+pW56BJRruI4CHexUjek9fqBJLHOK4y/l0Y8yelAOxclz6P
	i0qTDSOtItIRAyOg6JVE/j6p6EEimt7R12EP+1SWMRGxtgO6PkD16QF1MATavB8q+q3ST5
	Z407S5wPjh+yrN3hXruz1PAeL3UJxtc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757610155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6f2UzExln6BeKZDBJcPia3VoQR4i2uiv1uWrKQDThX8=;
	b=SZN5HjVQH7I6DxWuH/saAoWkOzECfWBjOFnbm+SQlrLVpYfvKgag+zQHPNs4GM6Pnv7ipm
	G/yzbj9qb1zfkZAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757610155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6f2UzExln6BeKZDBJcPia3VoQR4i2uiv1uWrKQDThX8=;
	b=zqAMFcRd0T8/Twk0PQTF4F5+pW56BJRruI4CHexUjek9fqBJLHOK4y/l0Y8yelAOxclz6P
	i0qTDSOtItIRAyOg6JVE/j6p6EEimt7R12EP+1SWMRGxtgO6PkD16QF1MATavB8q+q3ST5
	Z407S5wPjh+yrN3hXruz1PAeL3UJxtc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757610155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6f2UzExln6BeKZDBJcPia3VoQR4i2uiv1uWrKQDThX8=;
	b=SZN5HjVQH7I6DxWuH/saAoWkOzECfWBjOFnbm+SQlrLVpYfvKgag+zQHPNs4GM6Pnv7ipm
	G/yzbj9qb1zfkZAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C87A13ADB;
	Thu, 11 Sep 2025 17:02:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0PHHAqsAw2gUJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 11 Sep 2025 17:02:35 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 11 Sep 2025 19:02:36 +0200
Subject: [PATCH 3/6] slab: move validate_slab_ptr() from check_slab() to
 its callers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250911-slub-slab-validation-v1-3-8b67eb3b3dc5@suse.cz>
References: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
In-Reply-To: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Stat-Signature: 1m4goeidi5ekn9aeza34nubma6i3guxj
X-Rspam-User: 
X-Rspamd-Queue-Id: C974340010
X-Rspamd-Server: rspam04
X-HE-Tag: 1757610176-566760
X-HE-Meta: U2FsdGVkX18epKlMp/U74h411GBhPbPFznhmHi44Yu6MYiVQlQGryD1z9sMqk4q8XVSwxomJsyMflsXqTzxbvPo+GfD22kneQB9E4Qpu08A2UZYW37X2z0RrDgogicmgFg4JkhJJsSvH408ShthSxeTIixzYZV9h0/pV9uBG6HrJ5qnuC+PknmA6MrvHN41KBXITmt74IRx+yjlBCtnAwQkHWFRfXoemtLKirrSjPEOEaR+ifNsUBRgV/3lx+nBJWlNeDhtMztWcQEMJAe7R8nLXEF7QjtWdTMr7lGYhlVjgUYBd7WT59DBz3/KAi30uSXBCIpZU8vLKf6bAvZx1GFcjwYRqNZVM0kZSxfwqWtry8XRHIletu3MlEQjOXXD7JXJwYMS+bzK1eXUyHmhaMz1cK06fyHTW/hTOOKyd3zVGf/iVhONfvIaM/BbrcApIyhKJUnxWjHwpHEMKCH4YVQ9Hi4zGWHuqtuzxUNmQGPGni9mQ2wYr7sbsDLPSQsYDaODz+eOYMUJYeuEBeW5HBWazyv3eS10z5ICrrcaFoscmv4aLmjpwR1w6opcSx+4InOn+N6ZmOYXm5/okUZFOoVgrl7+rhsXU5h0+HxLJx7LLFgeNiCCrJsXzJ28V59PSTkALN9AsgRub0Ud64vVH9lVimZlmKiiUpQEp2WxyKxUWE2rvuyIiCC3mOBgeYaNm1e3phCepkzX9In7cPaeTq+Bk3Y94dYGXUBwgvDY360tfIIkEUO5DQ/ve60zs3EWDp4F7rMKo9hIbyBgj3dTdDxJH/8ENXetwsxTmW0oOsmnCyiiJYfBptyTNy5vb9TO7rCnuZbfOoIZaGcRpm2hz+C84l5MlWHebTh0fzhvLxQMsxrFV86XdKrykhGxTqAlteTdEU/uqN6liWrS/lK1jrLpHGyq8uUETUIp6mjimbdyf2usVgXomLsOsTzHoC9Au1mqv89s57wHNbbluRUg
 pLP1CGU1
 ZNcbquV6rSLMN+ysKkNjygrws8snbIfyRHmKXl2TRuHsCZCpO+5pfik0F2IONIXJCDmsnVmNCnksfJDfPG7P/GcxZYJxVg980nhAAPrMcv3iiq94wrmVMk1cw/2ucQi99/L6nNCF7F/5DhXgZSskkHmZu2S47xmxbNZTozIjEpSpTXL93ilG3vTAB52l/nzhT8HEYNiqUmBTa/QxxirE7cxtpDEPfXH/AVMfHtI5dhhVH/H2ZuvUU/pi29JXhYUKhjMMKWhExJhInIYoCH24IndzsPUaz8umLU5mW/8+/mG42BMQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We will want to do the validation earlier in some callers or remove it
completely, so extract it from check_slab() first. No functional change.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 5bbfe4ee8d9846ec9a34584c10750388849da3b9..94a089205a86f0667444484e158d307e72cd96e1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1458,15 +1458,15 @@ static int check_object(struct kmem_cache *s, struct slab *slab,
 	return ret;
 }
 
+/*
+ * Checks if the slab state looks sane. Assumes the struct slab pointer
+ * was either obtained in a way that ensures it's valid, or validated
+ * by validate_slab_ptr()
+ */
 static int check_slab(struct kmem_cache *s, struct slab *slab)
 {
 	int maxobj;
 
-	if (!validate_slab_ptr(slab)) {
-		slab_err(s, slab, "Not a valid slab page");
-		return 0;
-	}
-
 	maxobj = order_objects(slab_order(slab), s->size);
 	if (slab->objects > maxobj) {
 		slab_err(s, slab, "objects %u > max %u",
@@ -1633,6 +1633,11 @@ void setup_slab_debug(struct kmem_cache *s, struct slab *slab, void *addr)
 static inline int alloc_consistency_checks(struct kmem_cache *s,
 					struct slab *slab, void *object)
 {
+	if (!validate_slab_ptr(slab)) {
+		slab_err(s, slab, "Not a valid slab page");
+		return 0;
+	}
+
 	if (!check_slab(s, slab))
 		return 0;
 
@@ -3485,6 +3490,11 @@ static inline bool free_debug_processing(struct kmem_cache *s,
 	int cnt = 0;
 
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
+		if (!validate_slab_ptr(slab)) {
+			slab_err(s, slab, "Not a valid slab page");
+			goto out;
+		}
+
 		if (!check_slab(s, slab))
 			goto out;
 	}
@@ -6519,6 +6529,11 @@ static void validate_slab(struct kmem_cache *s, struct slab *slab,
 	void *p;
 	void *addr = slab_address(slab);
 
+	if (!validate_slab_ptr(slab)) {
+		slab_err(s, slab, "Not a valid slab page");
+		return;
+	}
+
 	if (!check_slab(s, slab) || !on_freelist(s, slab, NULL))
 		return;
 

-- 
2.51.0


