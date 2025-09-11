Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 005F4CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9918E000D; Thu, 11 Sep 2025 13:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C13A8E000B; Thu, 11 Sep 2025 13:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7408E000D; Thu, 11 Sep 2025 13:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5658E000B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:02:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3F1513A7B4
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:02:46 +0000 (UTC)
X-FDA: 83877588732.18.1F498D8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id A16BB180017
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:02:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QF7gdNKw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZzFRLsT1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QF7gdNKw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZzFRLsT1;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757610165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Pv1HSdC4mXzEJtFV99nSHn9ZZRv54mCokp/t2JPr4o=;
	b=JxRWFFCDHJ4IE8ru6OWG8UJ9vkzacO9n04vhnnCbhlEe0+99YEdS4QtDF2fnuEk3SApq2v
	ZETU4VhviIhm6M1hasYJcvug8cOa5WTonWbGm+qUnyISQtWeVTgUWEDcR89J44leJzW4v6
	Noaz7d6YOTdJSCNuOWGaqI+gJ4tQ2vE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757610165; a=rsa-sha256;
	cv=none;
	b=3lF7Lzr13TuVpLi7QHStudNwAhmzL2jJQsh480wzFiuk6vVpMwqLMGaQRXyfh411XDfaCE
	PQM/7+ZyBNs9+nbRt0120lqexFxTo9dCwfVeqElMnheiBPeGEhKlCL7eiuS5pSpkZbg30Y
	EeW7JHIYqSdqsFmAQsuz/sw8V9N6FW0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QF7gdNKw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZzFRLsT1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QF7gdNKw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZzFRLsT1;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 485AC76483;
	Thu, 11 Sep 2025 17:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757610155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Pv1HSdC4mXzEJtFV99nSHn9ZZRv54mCokp/t2JPr4o=;
	b=QF7gdNKwdu0/USHXbl4y1V8/yJbhvLhl97mMfX04Ke9OmFeWQkWbXSDP5Dr6YGfiyUTuxa
	ZqdMklKHmoXCPwjCIkQm3Oz1lSQbfVOAOM3ID9xPRcBiCdXZWLXb05Q90q65Of6QkXxd8r
	MMGbQUc1Unp+j/QoySvE+aZckuUPyn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757610155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Pv1HSdC4mXzEJtFV99nSHn9ZZRv54mCokp/t2JPr4o=;
	b=ZzFRLsT1OyihjWkvvWzckDLpxpzhTnothsrLr4f3UrldTZP1Dig0fGl2EZCo6SvvRPmYhc
	qfkdAyNx5hihfrDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757610155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Pv1HSdC4mXzEJtFV99nSHn9ZZRv54mCokp/t2JPr4o=;
	b=QF7gdNKwdu0/USHXbl4y1V8/yJbhvLhl97mMfX04Ke9OmFeWQkWbXSDP5Dr6YGfiyUTuxa
	ZqdMklKHmoXCPwjCIkQm3Oz1lSQbfVOAOM3ID9xPRcBiCdXZWLXb05Q90q65Of6QkXxd8r
	MMGbQUc1Unp+j/QoySvE+aZckuUPyn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757610155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Pv1HSdC4mXzEJtFV99nSHn9ZZRv54mCokp/t2JPr4o=;
	b=ZzFRLsT1OyihjWkvvWzckDLpxpzhTnothsrLr4f3UrldTZP1Dig0fGl2EZCo6SvvRPmYhc
	qfkdAyNx5hihfrDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2A90513AF8;
	Thu, 11 Sep 2025 17:02:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qOAXCqsAw2gUJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 11 Sep 2025 17:02:35 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 11 Sep 2025 19:02:38 +0200
Subject: [PATCH 5/6] slab: validate slab before using it in
 alloc_single_from_partial()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250911-slub-slab-validation-v1-5-8b67eb3b3dc5@suse.cz>
References: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
In-Reply-To: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A16BB180017
X-Stat-Signature: fzgebidsjqwj617bqph7jyj9f9qnptxn
X-Rspam-User: 
X-HE-Tag: 1757610164-389456
X-HE-Meta: U2FsdGVkX1/6fD+isjyF0IcajcpNWcqKJdx5dwevDsV4F68Zy9vRtyJ2qgrQts4QEspng3u+TnSWdLESPYTnezNxL6ToFPXuWpN2xVwBnfDrUj9bmT6fUaPpzqxkXST2udTP1p+o8aLVIj3EoNMIRm5G3jTgcp6L5LmZI5eQhCfpP6iPPE/G7A36zFHw+VAu+j616FswlcnCnDjnF0tAlkI5WK3iIEu4EjlZ3iQieQ6vVFNj4lSfZ2KuaLHFO89OGsS5XW28jVx+QLexh0ORukZXfWfsO6VS9snpNW5rd4xF8p/W60/CGWsLuU9qHgwxVFp4+UAcBV8pIF6ycyhEci4woHDw6Lr0tG1CtoOOM+rM/h3B3NI9G4bSIMOwn1uEspDuLhw8NhE9RyasD/QODKCJaNBj6uwv9mxvFVZMeC9Dlcxn4BdJvHnqQ08pNBLN6WiVZyxe7c6VMZfAKQhGJkfhRpGmF1y/fbBD4bsywi54oAmsTN+zIJj+FUAM0xwIGo5VJ+PHikQf2lR0joe861kyUpDZbuM6zJ68QfO98LcYCY6pUwZwnOsyBKvPKUa4SDJmwiWhGVDLVDDvJurcW3yW3sPqJfNCg2c0aMLr/+BdVBnteazBjcCpJ8dTshNWsplCvjbQ932dxeuTkUsPm18AhrHH6rWbWJSIibHA15ibzPphyQjIf6thx92AyaRvjl6kWMAnNxQGHYRhfEvShBdf8QxGw5oKdrT+0zs3PIHdsc1OxXEpY2E9CtKFqT/SqSF6SiIAS137tYkMZ4d9/83mwXGPvJDGMlKoITOcBu0lgVIi4LYj28u0K33U5pNwj77BfydDnPb3bvlRHRKBAEei7V6DUoMg2Hh84NqpYejbRt5Ni/7F7dKKDSi0InduPRBDXV3cJXeXwEHAQTEgOqLEJFTiBycG1NA+m3ldKWd3EPXei1UpNycxoDukQAPvAbhcP4FxQBPo3p6I7lm
 5cRH7zau
 WwWxjEX6m+uGF3hlTYV7U16McU2UukC/xqW2aPG5MH8AuwAWpcQyuj42Akdj5UUI4nyQnnJr21G8BPo/MH3Hl5g50wZah445LGoWdEF+iIcwsraMgSLinXGhw8TDXbXN3mP8SFDio8uM/AHgj86GT+w1ePgMxWLuuuTq1J62oDeM4EtBkAQ9al0FqiSjARtd2Rq/2exqvh8AFxJ1MrEQO5b2c/C59b5G7wUQg+Hxr44JvcHaRPM5oUXkMPDzM6sXnu2h4GD93n++695NWXagZRFMSjx9CoQRMkTv4m6vix4RimAQ=
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
 mm/slub.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 909c71372a2f542b6e0d67c12ea683133b246b66..93df6e82af37c798c3fa5574c9d825f0f4a83013 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1651,11 +1651,6 @@ static noinline bool alloc_debug_processing(struct kmem_cache *s,
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
@@ -2825,15 +2820,19 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
 
 	lockdep_assert_held(&n->list_lock);
 
+	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
+		if (!validate_slab_ptr(slab)) {
+			slab_err(s, slab, "Not a valid slab page");
+			return NULL;
+		}
+	}
+
 	object = slab->freelist;
 	slab->freelist = get_freepointer(s, object);
 	slab->inuse++;
 
-	if (!alloc_debug_processing(s, slab, object, orig_size)) {
-		if (validate_slab_ptr(slab))
-			remove_partial(n, slab);
+	if (!alloc_debug_processing(s, slab, object, orig_size))
 		return NULL;
-	}
 
 	if (slab->inuse == slab->objects) {
 		remove_partial(n, slab);

-- 
2.51.0


