Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE504CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 126188E0020; Mon, 15 Sep 2025 09:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AFBA8E000C; Mon, 15 Sep 2025 09:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9F18E0020; Mon, 15 Sep 2025 09:55:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0DE48E000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:55:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8CEB7C068C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:55:21 +0000 (UTC)
X-FDA: 83891631642.30.BA0A110
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 61867A0013
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:55:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="U/aOyTJI";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/yrH6ds7";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="U/aOyTJI";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/yrH6ds7";
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sp7wX8LAIXoZv2g9Und0rpOnfEG/AgSUWiifNHh6/Uk=;
	b=LbFV53EHZ/Hlfnx2IgKaUQunSC6u96+UvMCJvjUmuOI2UGu68F6gDiN4bn5rQhTlVnKy0J
	5b7Jn05A3mZttrv9n6Z+ujv0/J0Tlzg/9xlpYoh255xHIK9HJav2M1esOJBsHykDq8V3AG
	8x/1l93v9bvEIU4H2GfM3s6ttPnQgew=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="U/aOyTJI";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/yrH6ds7";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="U/aOyTJI";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/yrH6ds7";
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757944519; a=rsa-sha256;
	cv=none;
	b=kJEMq7ljkdQwZwCVTIiYYdOk2okBgN5fWdvRvHKt2PsnMXPDVeDwgqO44qW231dy0d04hS
	Nf8VRNtNdMPTPf52UqICBJZsAJxzGSMkyAEcuGpAztRKMPSoiT6pPq16dwpeQMZVh/HO1b
	7y9KjcO0yVuIq/Kk1KW1zyRVWrSJxLY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6C7791FB5D;
	Mon, 15 Sep 2025 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757944510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sp7wX8LAIXoZv2g9Und0rpOnfEG/AgSUWiifNHh6/Uk=;
	b=U/aOyTJI6mxu4J16SBnq/1byPaGnjFtJsTlF2NhS3H4xcEqUbM8FkYVH2RtVqcVzoX10mW
	12tJji+v2+yQzx08Gra5MkZaiFqX+/C9GTExEuk/kNk6OBhXngqJr6pX8/hPa9hLmJa9wW
	is9SXYO/2EsE5xZKaRCJ5Qxyil6yfTg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757944510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sp7wX8LAIXoZv2g9Und0rpOnfEG/AgSUWiifNHh6/Uk=;
	b=/yrH6ds7EBlnmdP5IBLvOaCOWGPjtPBTN2rF1GRimxvA2gpsTm08ynSqzZYg8gCybmVaBB
	4jHIdlXjJEYcG4Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757944510; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sp7wX8LAIXoZv2g9Und0rpOnfEG/AgSUWiifNHh6/Uk=;
	b=U/aOyTJI6mxu4J16SBnq/1byPaGnjFtJsTlF2NhS3H4xcEqUbM8FkYVH2RtVqcVzoX10mW
	12tJji+v2+yQzx08Gra5MkZaiFqX+/C9GTExEuk/kNk6OBhXngqJr6pX8/hPa9hLmJa9wW
	is9SXYO/2EsE5xZKaRCJ5Qxyil6yfTg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757944510;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sp7wX8LAIXoZv2g9Und0rpOnfEG/AgSUWiifNHh6/Uk=;
	b=/yrH6ds7EBlnmdP5IBLvOaCOWGPjtPBTN2rF1GRimxvA2gpsTm08ynSqzZYg8gCybmVaBB
	4jHIdlXjJEYcG4Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 56FCB13AB2;
	Mon, 15 Sep 2025 13:55:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sFT6FL4ayGhnVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 15 Sep 2025 13:55:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 15 Sep 2025 15:55:10 +0200
Subject: [PATCH v2 3/6] slab: move validate_slab_ptr() from check_slab() to
 its callers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250915-slub-slab-validation-v2-3-314690fc1532@suse.cz>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 61867A0013
X-Stat-Signature: d68xhm9bi8sfw6uy97rn9ozfumpgmpwm
X-HE-Tag: 1757944519-592581
X-HE-Meta: U2FsdGVkX19ENobO4SdQJz87uO2InkI9+M8xWXqciRzgL0Mm8FsIxO6VkeF5S8rS4mnJ8x2DeN/yf9ZJQPr9Ov52p6LYe80iD1qkRmjQ6zN4TJ1SOJSem5sCpCsYvNLKdTJ4LfjIOZyI8f25g36VzGAdj+jnKaU8733PV5oz9V4F18N09CjfJojfyrXPbMVHLttkJFIFmbAcLM8rdGm2ZlMHl3FtK7tEHQHWBGg/rebdK23pNisykoOwfd147xxsnxSyKz+kBwwgN/OtRqXn20jZ6s/MxWxU5RLvrfVKSW9pg2yBEVlFu6JFtywY2ZNI+CembhYs398lvvq4WcGsIWndIsGVGZ9U2G3r26iP9MV8qFFrgvIMCEvYqBjafCi/x6gfi5tVWS2wYKrsoNu2YObgGEkdtWvNmfNcKazT1Et3dBoB9XhKWKxcg0IDmUZlSHGNeenFQ2fOQqiqwAX8BHwOCTiDUbu8oA3JB4u39NPNRc0+uum0SrlY1f8QYWfmMt6C2AUWXIXIcjZaqtpFU5YPRWw3uWQYyGSjhNldJGOVgbIQ1RV9Ycr2dADl8/oYZFUCjD9oXSbs6HHby7Stgb3rRRBddQPnfPVxqQc4SvlV91ooHZw1qBVL7aX2On/TcWsHYYwwAP2HPiJd9Epb37RTD+g/QWAyaN4kJHgaxeBLx62tuPZ0arUxkQiyNJt5syHbERv7+yF4an2G7HZ+WHr3pLRaTLXXTtlnIgBqEZLAZSsLoEnZ2Hf05wWyjlPw615JoQoGaAgx4++uHYlf/DNS1kHTrtsV//iOnjgiIkdCFupMz6zrb/pEib0FuXsoa9bBcNebJ/ywifF5QJ5E5noQA3iqzeH2FcKID8Igh0SI9NjUzqTvYGNELSw4kiznY0g00oDdEpyWDEoWLneDtcV2R6rv/SDIARg4TeJoSeXCQhZdEsmsrOyp5NGXgc43FvDwi7B7nQ+/Tr63wNm
 szdMZ2Pm
 eSZrOZ4RXxRGRSnl8L+embXywyktFBVzZ5rfjO30RuPXGpe5jHZHHQeHHvd4R/Vt9V0VQxuMGWDGBonAFdxy7nRv5U/DqZLC8OzKIxeS0lK+TV7kLQMa7Dq7/PnDraU5ZKod5E8HNe4dcHe6VKqBdYydkLR0P07z9wndIVkslR/NGylrZJQtM+O2kLgveslUgaRRd0e1xMTW9KBY+Fr2qqaNWJGiKBXmgwbt20cpLTpAT3PQV08iTvGKnMwqXyjZUzaIde+Go3TL0HAfyqK4W1GdvGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We will want to do the validation earlier in some callers or remove it
completely, so extract it from check_slab() first. No functional change.

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 75e4388d507d1abcbce8c7d5d2581381de46cf4d..6fb24010c17019ed304b4ef61f402212dd634efb 100644
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


