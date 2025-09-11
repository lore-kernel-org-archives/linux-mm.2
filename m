Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 183B6CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23ED78E000F; Thu, 11 Sep 2025 13:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17C4F8E000B; Thu, 11 Sep 2025 13:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042CC8E000F; Thu, 11 Sep 2025 13:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E6DB68E000B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:02:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0731160531
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:02:47 +0000 (UTC)
X-FDA: 83877588774.12.8DF6E35
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0D9D020008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:02:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UlRLIenv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="oGn/PNUn";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UlRLIenv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="oGn/PNUn";
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757610165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gU8uzwxAYobW2SW2rVaJMdcJbOZvC5xNrUDaVXNRGxg=;
	b=0OJP0x8gU8a2pvqCDUXW4ygny5WVY5zgSPKyI/+8Rej8U13jxwV9ZauzVQBMWISHZjWFvL
	AIwnHQ05oCyHf+r2n3skWJZg+BqKTfwEOEpItFKk1hjh6xRlMJELbkF9t7EVphmZ/7I18W
	es5dCxswhEZ5ivSP9ZX3kF7ZP09JgQI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UlRLIenv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="oGn/PNUn";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UlRLIenv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="oGn/PNUn";
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757610165; a=rsa-sha256;
	cv=none;
	b=7/0fqBcoCErbnCt6SQJj4KuGruH0e4TwshbVsB7jeR04bVnIaiaANiPwSROdDrh5yJUBZ5
	I+u19OMeXLaS5VFdsmtg5khPXuhrSxSOpbDBulSJyYM52TlKXgKz0xgaADf1xC/IVoKfRw
	CbWderEhJE5l8t4RNYbjuIwC/L5ZmOY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4B129385FB;
	Thu, 11 Sep 2025 17:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757610155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gU8uzwxAYobW2SW2rVaJMdcJbOZvC5xNrUDaVXNRGxg=;
	b=UlRLIenv1BNmXoAJVTeMxpBMoAOaKHc+pxyu8MYuMXV9fqIzZ772TMdMW3aU9SyOhqvpu8
	R2akgspt2OlhZShcE7t4dWKxIt5YhY8i24bHvKqb7c5INKHxKjJ0O+qvtYZPfNYp8VD06D
	5JRoTmIMTR0olrImNVE8InGeFX+Jc2M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757610155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gU8uzwxAYobW2SW2rVaJMdcJbOZvC5xNrUDaVXNRGxg=;
	b=oGn/PNUniXADceo50TVabUOMevpYbP0N9zyRD3gLNzAzq1D7glDcZHWggPBOKsv2PZAEqQ
	JVylQibCsPAR0iDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757610155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gU8uzwxAYobW2SW2rVaJMdcJbOZvC5xNrUDaVXNRGxg=;
	b=UlRLIenv1BNmXoAJVTeMxpBMoAOaKHc+pxyu8MYuMXV9fqIzZ772TMdMW3aU9SyOhqvpu8
	R2akgspt2OlhZShcE7t4dWKxIt5YhY8i24bHvKqb7c5INKHxKjJ0O+qvtYZPfNYp8VD06D
	5JRoTmIMTR0olrImNVE8InGeFX+Jc2M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757610155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gU8uzwxAYobW2SW2rVaJMdcJbOZvC5xNrUDaVXNRGxg=;
	b=oGn/PNUniXADceo50TVabUOMevpYbP0N9zyRD3gLNzAzq1D7glDcZHWggPBOKsv2PZAEqQ
	JVylQibCsPAR0iDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3A2C413AD6;
	Thu, 11 Sep 2025 17:02:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KKnpDasAw2gUJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 11 Sep 2025 17:02:35 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 11 Sep 2025 19:02:39 +0200
Subject: [PATCH 6/6] slab: don't validate slab pointer in
 free_debug_processing()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250911-slub-slab-validation-v1-6-8b67eb3b3dc5@suse.cz>
References: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
In-Reply-To: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Queue-Id: 0D9D020008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: b9cm79y6aubh4j6wwtwpdt5u66t96wya
X-HE-Tag: 1757610164-794231
X-HE-Meta: U2FsdGVkX1/LwgKVDwpdm9O2x+Gmwqss1dEDgJ1qw2xhZKTJJ7hPuP4KXAP3WGq3XZXtxtuQ19bEzpPY+XgSqaObXj+Rmb/u4AfueTLXXw0XglhtLiXMytGP58jxDcGma4rfksoR5oORwCu4fSpS3nDn0+xrvxeZJXkbQ6NLSkWkXD+AJRPVkBM94sBPq4Gy8eof0zsXcN7tdn5WoVpv5sko7gKyhHPHaWp5UenLNPvpEzRxV9H4KZ/5ztAPnjWiq4UYwvJPDWUyAbveg0LEBaptfLOfyXGPaYP86tZf+Ni2GtANPqNyr2aWDZekXudXW+Pu5QBI/gWBf6BvdmrRrZue+RZIdC9CG4yXbz9xxLVN29WgAfdPq0FWP3LtgQQMnDN4wTmQ2aVq0dpbaMHZyNxaKU+yrES2naDOOI6vV6d9oA/MQrAV5yEaIGlki9jA8/rk86UvCeo5AR2HFebQTqV62i6Y94vYbi+GdFc29206pKHzVTCgebdTDiq3iMOeAKxUvJFEoPaFg7P6z/+1TuISCrP2R3vAkLKv60mm81aD30fdDmI0/rokdigRjFGpHtGIWG4gLBUq/4OLlsQ5BbIQ9qJBEeRPmFIk6CwnFC/cQzE1exXZxy7pTvYH9q1k2O7OLlE4wRqIX1jp51N0aXeEBUH9crxFWHyD9TlURr7CIMMch2nWZwnUsQ7/TXRhsDOrmLY6fIudmnPrjwGLs89+GTW3vxXDba0cwVpJ5vlXLg7ueKdjXp/YUN2dyLOV6kjAbte5vWUY9Qp+DIYeFdNojzwXJc8XNX+tLY1+0M3nbKPE8kJXZyhl/7KYl5CYG6ZOY/Ww72oev7jGYa2uEfpgiVEhzBV1appxvrl7zITYGH8KECGxnhT0W5zlaKPOSaFZ3PdYvU+JaAFbETA7Zr8gxXFXWB3u2/RSOfb6Y5v5NEh5HtMGw9bKfgHEUFqOve1ogt2dqVIlPf8u1B+
 g0N1Qa8i
 ycUWx1hoAdA7GQD2yapUJeT/Qrq7evabub5sANW7GmyhzYEygrGPvg0k7etwr7IJ6nuqml4GjGNShIndQJGM9ZLs8SSfWbOCMxyF14Bj/nfVSqqImybCtYe+c+Hf7oE83Tt87oeWBgq+jleCR3wZyxn2fd3B9+NHQZTNpMTAieJtZM26tn9bTBtyHS0FZKdpdVf9ipHGl08ASB2rQT1YW87Uc89OrD2SpDhYdwtmH6OVCezjcrqtETW+1uUQwlzzu7Tjw3EJVf75aP/De3rl1i6wKsdjvtLTS7TGzkzYUYJ0yr/Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The struct slab pointer has been obtained one from the object being
freed on all the paths that lead to this function. In all cases this
already includes the test for slab type of the struct page which struct
slab is overlaying. Thus we would not reach this function if it was
not a valid slab pointer in the first place.

One less obvious case is that kmem_cache_free() trusts virt_to_slab()
blindly so it may be NULL if the slab type check is false. But with
SLAB_CONSISTENCY_CHECKS, cache_from_obj() called also from
kmem_cache_free() catches this and returns NULL, which terminates
freeing immediately.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 93df6e82af37c798c3fa5574c9d825f0f4a83013..106dbce64acdf32c1d271ec130c35c0ec0e15630 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3487,11 +3487,6 @@ static inline bool free_debug_processing(struct kmem_cache *s,
 	int cnt = 0;
 
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
-		if (!validate_slab_ptr(slab)) {
-			slab_err(s, slab, "Not a valid slab page");
-			goto out;
-		}
-
 		if (!check_slab(s, slab))
 			goto out;
 	}

-- 
2.51.0


