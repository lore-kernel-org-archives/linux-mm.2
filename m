Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CAE6CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06B008E000C; Thu, 11 Sep 2025 13:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B468E000B; Thu, 11 Sep 2025 13:02:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73AD8E000C; Thu, 11 Sep 2025 13:02:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D65948E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:02:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8722011A4E7
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:02:40 +0000 (UTC)
X-FDA: 83877588480.10.0E54CBA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id A592C160007
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:02:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3NUsIjTT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WTl41xxS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3NUsIjTT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WTl41xxS;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757610158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16JtMs2N3c8BfxyIy3mN0WoRRH25v+rdskgyAm89Lvk=;
	b=EqcoyulEoTwVmlGvE1lvcI0ScMfQFRK09wxjRLpVc5Ml/ezqfvrsYAyrJ9Veh9aSQykgjb
	AgJ9KSSh+9ZSeih2j6NePUO1FKcCpqxqQiUTcGPExHx+PYG/RQ4AihtrB3opY9WrBoPYwg
	gZ4Q45l4doJvsEN9oM2pKUdu2DFjvjg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757610158; a=rsa-sha256;
	cv=none;
	b=JnI1eUiZj8ZIcXCM4z7LQ8SCAmd7ywqKTXT281bKKnKbtyZienGf+qqfE7fuBmK7Eouq3k
	UordVbb3ru0aI58suSwJ/055tCam4LEKoL9X+PGVi2tmbFiy/mwomwWQcgHTc0mgk8m1x4
	aF6TTYQGmj9dxXubrRy1YUXOOsk9Aks=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3NUsIjTT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WTl41xxS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3NUsIjTT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WTl41xxS;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 306B476482;
	Thu, 11 Sep 2025 17:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757610155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=16JtMs2N3c8BfxyIy3mN0WoRRH25v+rdskgyAm89Lvk=;
	b=3NUsIjTTN3qASJMnexCA5e+92cBKzdrKYdjG2TFhAVDAXH3TfeGX85tKlNJ8azYupkjf8f
	k/uf/IJmJhEWgr54gKCtB+pSWTdd4UTPVhd+5bS2ehkgjl0kWnoyGrsU/m1nWeEg041mRl
	l7BcPPatZvfSxnz63//p00cKbK7HEqk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757610155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=16JtMs2N3c8BfxyIy3mN0WoRRH25v+rdskgyAm89Lvk=;
	b=WTl41xxSWFezDL6Yh/s1NTrX3RQSSzNglUw5tHGaNCTp1IQCnZ1OsWN8CyNn+e4ahIzxtj
	ywruhUuWBJsszNAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757610155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=16JtMs2N3c8BfxyIy3mN0WoRRH25v+rdskgyAm89Lvk=;
	b=3NUsIjTTN3qASJMnexCA5e+92cBKzdrKYdjG2TFhAVDAXH3TfeGX85tKlNJ8azYupkjf8f
	k/uf/IJmJhEWgr54gKCtB+pSWTdd4UTPVhd+5bS2ehkgjl0kWnoyGrsU/m1nWeEg041mRl
	l7BcPPatZvfSxnz63//p00cKbK7HEqk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757610155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=16JtMs2N3c8BfxyIy3mN0WoRRH25v+rdskgyAm89Lvk=;
	b=WTl41xxSWFezDL6Yh/s1NTrX3RQSSzNglUw5tHGaNCTp1IQCnZ1OsWN8CyNn+e4ahIzxtj
	ywruhUuWBJsszNAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1B7F713AE0;
	Thu, 11 Sep 2025 17:02:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wGJtBqsAw2gUJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 11 Sep 2025 17:02:35 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 11 Sep 2025 19:02:37 +0200
Subject: [PATCH 4/6] slab: move validate_slab_ptr() from
 alloc_consistency_checks() to its caller
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250911-slub-slab-validation-v1-4-8b67eb3b3dc5@suse.cz>
References: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
In-Reply-To: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Stat-Signature: cqrgomdfppkobzxthw3rb348pn7qcan6
X-Rspam-User: 
X-Rspamd-Queue-Id: A592C160007
X-Rspamd-Server: rspam10
X-HE-Tag: 1757610157-639110
X-HE-Meta: U2FsdGVkX1+m3IhXp1OhsJy2zuHuwWRLto47tnG64iOwZfkeyw47luYNE/WssDfrzV6Y1q5PNat3ZvRP8b+E6cwOF4jQkZfNCUFD8yrbiRBgp8ovfSeDrqyTrZkptEmnQEDRVJKMwY1HfqWlzBCLimn8/ddJLNMagFgkUHOznrpglyEuPCb/j6HbNQ33Qp/WtCNNUS8foThe7jvufrACTxkJ1jBj1CyR6Y7mumzwUoTCbK84LsiwNwJeQ5yrz5S0vqVBpwF1PmcYu1fpPKLBv17zQgdEPDCCtvIX411LQjfEOKw+V32AzESnZmMH8zdVAlxUNE8OIrdS1anOayobYa5d7iitjd167Ib+bmMS+WtQhE65NRr70vZLKE9+e7oxwqeHDDaUuDF50cWqrTqKgV2LrFM13++13kr4V7u+fWCIuRDmOc4faQFNnEQ+psQDmlJzS1K+kYfkTKx5Jf3uIvY73oLokF/0FlshqCu3ujagHLOiaQkiEVZd1WGODkmafxAkEPXnLYdVF3XODUOI5gfS6OFyRH37kaR6OHK/PfYmZxlOfFoTERIGiNLK3WeZWT4uABGWA/ECq699BdeXORZrJf2ZVG6xCFtSCDKR0Lwkrg9Sl3HsyO9/YpPgTcYSuJAt6FGp1SqT0YIGbO6K8FjVmSWbRxjRsND2O30JToAeOYal40DnLwCWO15YxaKblzJ+dV6hBhErsU9Ph+Xb2cfmt6sNvWkJGZvQw5rixY/+b76qoDClRM0c/HjK3z6o07J/sdYmhk8jqug5GkzGLN/FEoELKZHy6GV4dqIkbt+pfRrFxelVCST3coaWKylYVFJu4/zcybDmJh9U+KOYbHAI5mfNbD4DiLmjGVhy52Who8HSLsm+3ttW8gMD8VqvDz1Tl2LssfDnyHI4Z1dkyn7PecNVSrWLAmTzqhWMiPp4wzlpV3CC8uy59xj1lufUwMBiO1GgEo7FRu2F0e3
 HxbzRykL
 pWmoSFNeAqdSYjrk8f8gRCBfQrEU/luMxL0bnky33H6OoWCWsx2A/M8PW0n3pkpSYT6XK4094Ncl56+gsPtYnF0jDEW8VYXBERwqIcRD4dPXIUBuWOLVo6mFiTjEl/UXuEIudLgKZcOzbVzgBCzw/00Y/PFDxN992Ga1TIVp09K+snT+qlBM4zwY/1mjyShhAvIRe4mBPvufCWOIuftLapDrQzbAX7nqdof3e0Igd5Mdx6Pc1UuVJgucQjuaj5KCz2z3+q1T+FlxzIJiIOaf4/QRQznId9SIVHbUgkH8xkTNqlRvvhCOOXL65ILJH/SfHpdQay/r2wzsJsfg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In alloc_debug_processing() we can call validate_slab_ptr() upfront and
then don't need to recheck when alloc_consistency_checks() fails for
other reasons.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 94a089205a86f0667444484e158d307e72cd96e1..909c71372a2f542b6e0d67c12ea683133b246b66 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1633,11 +1633,6 @@ void setup_slab_debug(struct kmem_cache *s, struct slab *slab, void *addr)
 static inline int alloc_consistency_checks(struct kmem_cache *s,
 					struct slab *slab, void *object)
 {
-	if (!validate_slab_ptr(slab)) {
-		slab_err(s, slab, "Not a valid slab page");
-		return 0;
-	}
-
 	if (!check_slab(s, slab))
 		return 0;
 
@@ -1656,6 +1651,11 @@ static noinline bool alloc_debug_processing(struct kmem_cache *s,
 			struct slab *slab, void *object, int orig_size)
 {
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
+		if (!validate_slab_ptr(slab)) {
+			slab_err(s, slab, "Not a valid slab page");
+			return false;
+		}
+
 		if (!alloc_consistency_checks(s, slab, object))
 			goto bad;
 	}
@@ -1667,17 +1667,15 @@ static noinline bool alloc_debug_processing(struct kmem_cache *s,
 	return true;
 
 bad:
-	if (validate_slab_ptr(slab)) {
-		/*
-		 * If this is a slab page then lets do the best we can
-		 * to avoid issues in the future. Marking all objects
-		 * as used avoids touching the remaining objects.
-		 */
-		slab_fix(s, "Marking all objects used");
-		slab->inuse = slab->objects;
-		slab->freelist = NULL;
-		slab->frozen = 1; /* mark consistency-failed slab as frozen */
-	}
+	/*
+	 * Let's do the best we can to avoid issues in the future. Marking all
+	 * objects as used avoids touching the remaining objects.
+	 */
+	slab_fix(s, "Marking all objects used");
+	slab->inuse = slab->objects;
+	slab->freelist = NULL;
+	slab->frozen = 1; /* mark consistency-failed slab as frozen */
+
 	return false;
 }
 

-- 
2.51.0


