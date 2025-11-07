Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B78CFCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 13:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2128E000A; Fri,  7 Nov 2025 08:51:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 062728E0009; Fri,  7 Nov 2025 08:51:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23E98E000A; Fri,  7 Nov 2025 08:51:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D0D448E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:51:50 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68F4D1A04CF
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:51:50 +0000 (UTC)
X-FDA: 84083949180.18.9BED69C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2AA7940012
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:51:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762523508; a=rsa-sha256;
	cv=none;
	b=PdcBCffNTz93lg/pXcHa0FUkpwEOXiP3mfx8/Xor7riWfxpTuBvaubCyNZZb7fGLyk6xGN
	ZjWZnuk0PkIsV0E4UpuVulNRHunTRdhzdc+YmB3KS9ruoF21QPZ7EbdlKVko3EnlKAuLyW
	EA+O+KSozEORhwvYhFQWrZyQmft9eV0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762523508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zqIoRc5stajNENqR8NCk+Ip3BWZNgGLDhFHC7y1USAQ=;
	b=fXSUCA86UXS1f86z09b6ee/UDQv/B7RpBP+olbiqi8N+feee2zYbrl68JJmzSb01lioGpA
	4GqWOLFIW9b+mVoJ8SUa06+Nl1ef0QfrC5N0C/d7qkYZQ2bdAkJ0wvWymm5EhCrqZgp7cm
	J7byL21pdCHMkKl1Hi1q27N0JIL55E0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B2AC9211D6;
	Fri,  7 Nov 2025 13:51:46 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D1CB13A88;
	Fri,  7 Nov 2025 13:51:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IH4OJnL5DWlFCwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 07 Nov 2025 13:51:46 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 07 Nov 2025 14:51:25 +0100
Subject: [PATCH 3/4] slab: use struct freelist_counters for local variables
 instead of struct slab
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251107-slab-fms-cleanup-v1-3-650b1491ac9e@suse.cz>
References: <20251107-slab-fms-cleanup-v1-0-650b1491ac9e@suse.cz>
In-Reply-To: <20251107-slab-fms-cleanup-v1-0-650b1491ac9e@suse.cz>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2AA7940012
X-Stat-Signature: s5max54ah8d1pc8nezbhdq9ztkh9fa31
X-Rspam-User: 
X-HE-Tag: 1762523507-919396
X-HE-Meta: U2FsdGVkX18dWuXWfwpbiN6STdzfo59X/XsYQ3Mc7pa0sojGpuspO1D5QatRF+S62ZzZP8BjVfMXVp8ust0Zf8xPHASr4whfaQAkCaeKuEkbblc/1uCopCrhDaNtPyqkf62ofgg8hxDJERR5gzR32/l0YLWmzGVvC5drc3rZgHE3PC1DoJlLYNdNIgVg2HdEnrWyqHNvkcdOBYW2HyRZZRMCyHOtzwRNM4FyHt9WLEehgjZKOstS7iQSkWAcTi7keLK7W0jwiFvXoWv9cn8uLRbTPvlcEDj7A9/0OIxPy2K+2gprx/DTxLeV66cac0bE5Var1UA0XnLOm7urqn0AMKo3Vvo3uKUsPnisrud3S4gCJsopBqAjh+UxFGqN6pHeONZdovORLSI2j54kKZQwwu0kd6yWMqyySoO6IqnVYCiEffVLRkeHhyU5OwLg1PxIOEhl7cu5ekIfC1WAi6wbdkihKiSZZC0d5Glr1BIKabHA10DxH2iVQeam/dNrPcpi3nFW3NjWnrRVFMqKgGfqoPhGP1FGktkSY+3LzuPTxRVK7QvrCyiXdM0jYicPTcqtvEZ0DYXSup4Y3roA4M/vGzKuiSEY9qxm8vNsciWFQlUywAMuLWzJb6A0G4RFJRhPThZiZsPJNB3Bv6ALbERBoo0pbM0MNTKW47cKSo9SlKL9j8IRNBkW7qLN+JFvjzicdwkkhYdneDfIokOd+ZiT7MnLYOM4Q9Qf+ou2NMHGoFfw+gA6OdINy9on6SGnOuCm03lRyAF1znQmE5K7KeD5ETKD1/adBPCynzL3EWQr9dW6TXCZ2H5BrYlMC60CtYYqqIAUR+Kb2cmOYy75hvSZfbeBd2hSe8C3GcUXd9cJkLfG6Je4JX5YHPkg2+qrQBPLCl2O/r8tWzN7km6XOOkfPtnoSqEh7tkwca/SUXuLLZ0lRoebpyMXYitajgCvVnT4qV2m6Jcs6v0bil929Q+
 EMIDmV++
 dVdn0zh4YAWCkfUgTow62eVn1zhJgrhG17rrkkAb1InfIq+PZg9qTYr+fYVYb7F6U4ONiq3L0GNWXtyyo8mh3BKcXzdfYrW6ASZkq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In several functions we declare local struct slab variables so we can
work with the freelist and counters fields (including the sub-counters
that are in the union) comfortably.

With struct freelist_counters containing the full counters definition,
we can now reduce the local variables to that type as we don't need the
other fields in struct slab.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8330e4f8b3b2..a55e0af26ec7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3725,8 +3725,7 @@ static void deactivate_slab(struct kmem_cache *s, struct slab *slab,
 	void *nextfree, *freelist_iter, *freelist_tail;
 	int tail = DEACTIVATE_TO_HEAD;
 	unsigned long flags = 0;
-	struct slab new;
-	struct slab old;
+	struct freelist_counters old, new;
 
 	if (READ_ONCE(slab->freelist)) {
 		stat(s, DEACTIVATE_REMOTE_FREES);
@@ -4390,7 +4389,7 @@ __update_cpu_freelist_fast(struct kmem_cache *s,
  */
 static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
 {
-	struct slab new;
+	struct freelist_counters new;
 	unsigned long counters;
 	void *freelist;
 
@@ -4418,7 +4417,7 @@ static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
  */
 static inline void *freeze_slab(struct kmem_cache *s, struct slab *slab)
 {
-	struct slab new;
+	struct freelist_counters new;
 	unsigned long counters;
 	void *freelist;
 
@@ -5867,7 +5866,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 {
 	void *old_head;
 	bool was_frozen, was_full;
-	struct slab new;
+	struct freelist_counters new;
 	unsigned long counters;
 	struct kmem_cache_node *n = NULL;
 	unsigned long flags;

-- 
2.51.1


