Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16714CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722728E000B; Thu, 11 Sep 2025 13:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ABD78E0006; Thu, 11 Sep 2025 13:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2638E000B; Thu, 11 Sep 2025 13:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 48CCD8E0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:02:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 032FF1A0522
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:02:52 +0000 (UTC)
X-FDA: 83877589026.16.F461D4F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id CCC0D16001A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:02:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=caB69UBa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eciko9ma;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=caB69UBa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eciko9ma;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757610171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRP07fiR2IX4gxo9ENuoZTQhuQ0mAms5suV1861+oXk=;
	b=6yH4wD+Lu9XYW0LoiVtw3oVN9dnkL8dyrZ7D4pzfourcFL9jdTgRHOHPeBx6m16hFuSB7d
	tfEVHzpxbEp2us5AjxB95tMAfgf9xNylsbRVBWHr7UoDgx+UiUTf8YMWuC1WsJujBs4YQ6
	2RPOW1Np6dLom11axpzaJeIh6MiWYyk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=caB69UBa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eciko9ma;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=caB69UBa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eciko9ma;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757610171; a=rsa-sha256;
	cv=none;
	b=XHanMk/4FIV+9+fMD6zwd23156dNaTcfHdIug8wbUilVc811Ugkjl+WHlrpE4A+Dxf3lMk
	GpWT0sAq9Nsvhx7LiWaaCUSV1C/aIZ2+BfZ9yOEwsUFcDkhktnYZ5y9+hNipfZHlrO+vXm
	Oe7UxtNOQBplS065sXJtUQcv9MiTbuE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 11BE47647F;
	Thu, 11 Sep 2025 17:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757610155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRP07fiR2IX4gxo9ENuoZTQhuQ0mAms5suV1861+oXk=;
	b=caB69UBaTbJw0cyHbpwNyhsojWzldNenRQf7IxQxYYwsRwFbZdTbBFqmXnGnAGylbG5XUg
	I5a6YRc/oyJW8A5J8RVQ776dTKd4NHj4ur+OL0++IZVMvjqcxkOoHUX9zRiuO8du7yXG5E
	HxvVaXgq4LODJ7BLPbAebZN/vGYVRTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757610155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRP07fiR2IX4gxo9ENuoZTQhuQ0mAms5suV1861+oXk=;
	b=eciko9ma7alFW2z3yd0wB6yiSLgj3Fo+mGOYT5Imo3INWV5tQGVmCZaGV+oajdOCArOO+C
	Kot8xIChGaREOEAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757610155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRP07fiR2IX4gxo9ENuoZTQhuQ0mAms5suV1861+oXk=;
	b=caB69UBaTbJw0cyHbpwNyhsojWzldNenRQf7IxQxYYwsRwFbZdTbBFqmXnGnAGylbG5XUg
	I5a6YRc/oyJW8A5J8RVQ776dTKd4NHj4ur+OL0++IZVMvjqcxkOoHUX9zRiuO8du7yXG5E
	HxvVaXgq4LODJ7BLPbAebZN/vGYVRTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757610155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRP07fiR2IX4gxo9ENuoZTQhuQ0mAms5suV1861+oXk=;
	b=eciko9ma7alFW2z3yd0wB6yiSLgj3Fo+mGOYT5Imo3INWV5tQGVmCZaGV+oajdOCArOO+C
	Kot8xIChGaREOEAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F0C5C13AD6;
	Thu, 11 Sep 2025 17:02:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ECiDOqoAw2gUJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 11 Sep 2025 17:02:34 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 11 Sep 2025 19:02:35 +0200
Subject: [PATCH 2/6] slab: wrap debug slab validation in
 validate_slab_ptr()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250911-slub-slab-validation-v1-2-8b67eb3b3dc5@suse.cz>
References: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
In-Reply-To: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Queue-Id: CCC0D16001A
X-Rspamd-Server: rspam05
X-Stat-Signature: obu7yhawe4z9zq9fns8bxcxfqrgp9o4o
X-Rspam-User: 
X-HE-Tag: 1757610170-775101
X-HE-Meta: U2FsdGVkX1/rC4GfUk4qhjbVdzrIlcRN2Q/rQTe+ZVr1CrBqTxUPbpyla02RuMLqJnOJLHgOSuEOFd/5Cz90d8XpR1uU2Azzq30G1d8sVCLJy0T2sGmW2JG+yzwchgLRKKAfVdewB6djtK+moDYoG7tv1i2Nej8GEnvyEI00XX3HJadu6CVQbOoJ6DBaCtzclTI4/dymMa5SKRo7ZxKItYusNhBStmM3Qkl4rXoYN/fj1AvtCw3QV6HCEFVfHbyjsJi3tDvn2OewBw4dgG4fRfQgB9nKnKW8skwj7Kdz/Pq4gXxS6lQXESPxvr+C4VB2ZgDDPq6G4UhU81nLGMEnLXPkNBIsJ20z4o5exoavmuyARmhhehPy9y3a2jbTKOtz5vVvuV6jXYPAr2/OjFNZ6cVyEG3eZh0VGpZV40IOvbKg6XvvhkR8aCYCuGW9NXtL1YVXReS6pjsd3ZdbhOPZ5tkF0i8xwLl9fk+kI4GklpYqsYihJBz9kiPPA9IBt+9WkK2jVZz0Upyd6fG6jaXGwhmYkVHVOWLvQeix9sFZQHi5FskqXouf1LMzfWqZL6DoaAxpkQzAUY0qfKCsJPuMvZeAoHk8fK8y2PVKs8rz7lgTbHiC3IOwySwN4v1gt62ls77tdkmYJpOUSGOPpiXAh4ucagHnJMs5IFc5ayQ99HLVcZYgF+o05ZqpD5u5WrmXQXE/wYuH3fiW6ecdizNYQB+qcImPIVWSXT/Lf63jKFAZ7TUHfJz6H7WMVzj2iJfr9fHvRdqFovxSwt5vtq6DE8kByxLsZvMgzmaOYzVwLQx2QroGhE1VvVriJNZGCPiljcK0AyoRRkE4Dk7ZB4dtNH3nNtH/NJx4/HYVfxwvUndFViVLVbj5YPumbtwgZGbxqHkk1G3uBxheahclyBZiPHExfW2bZNUU9DO64LH8gr4j70R80hc8C+9VXvGki5Le1NTT1aCDkGJNy4Mnzwk
 0y4p41Qg
 XF4WkU0ZbIS/lWclpPkxP1WBRJGoFXRodiYF0S/uFZac/6/jwoZJO03NZY6QEOP2cpwC4OkPLEwAyGOEWDUvccy9FMn3nduNZ7JLBX+bv7NjDPA2osQtQH72js/KT0Yg3WJ4Ms4WOaQfXGtKSbWND1RvmZv13s8Ejx8/ces3A9Ul4r4T0adOD7g+y6EA1DUsHAjYAY7qptKVGP+hvBOU0eWr+KBCS7GfrBFQHEW0u35VOIse7LbLXJlx9wOkiA7vXY4JTq7WCczoMWTdMQ2zwScfxqjLeyg0ZnKTw6d5CE+P+IBo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This will make it clear where we currently cast struct slab to folio
only to check the slab type, and allow to change the implementation
later with memdesc conversion.

For now use a struct page based implementation instead of struct folio
to be compatible with further upcoming changes.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 56143bfd1ae319d384981c810a5ed84af00f4afa..5bbfe4ee8d9846ec9a34584c10750388849da3b9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -821,6 +821,15 @@ static inline unsigned int get_orig_size(struct kmem_cache *s, void *object)
 	return *(unsigned int *)p;
 }
 
+/*
+ * For debugging context when we want to check if the struct slab pointer
+ * appears to be valid.
+ */
+static bool validate_slab_ptr(struct slab *slab)
+{
+	return PageSlab(slab_page(slab));
+}
+
 #ifdef CONFIG_SLUB_DEBUG
 static unsigned long object_map[BITS_TO_LONGS(MAX_OBJS_PER_PAGE)];
 static DEFINE_SPINLOCK(object_map_lock);
@@ -1453,7 +1462,7 @@ static int check_slab(struct kmem_cache *s, struct slab *slab)
 {
 	int maxobj;
 
-	if (!folio_test_slab(slab_folio(slab))) {
+	if (!validate_slab_ptr(slab)) {
 		slab_err(s, slab, "Not a valid slab page");
 		return 0;
 	}
@@ -1653,7 +1662,7 @@ static noinline bool alloc_debug_processing(struct kmem_cache *s,
 	return true;
 
 bad:
-	if (folio_test_slab(slab_folio(slab))) {
+	if (validate_slab_ptr(slab)) {
 		/*
 		 * If this is a slab page then lets do the best we can
 		 * to avoid issues in the future. Marking all objects
@@ -2818,7 +2827,7 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
 	slab->inuse++;
 
 	if (!alloc_debug_processing(s, slab, object, orig_size)) {
-		if (folio_test_slab(slab_folio(slab)))
+		if (validate_slab_ptr(slab))
 			remove_partial(n, slab);
 		return NULL;
 	}

-- 
2.51.0


