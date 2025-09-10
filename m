Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41C37CAC583
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8ECB8E000B; Wed, 10 Sep 2025 07:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65EC8E0002; Wed, 10 Sep 2025 07:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E858E000B; Wed, 10 Sep 2025 07:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B65B48E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:55:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61F8AC08C0
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:15 +0000 (UTC)
X-FDA: 83873184990.23.312002D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id BEC98140008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sevB2pHo
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757505313; a=rsa-sha256;
	cv=none;
	b=bwBkXMJUUelu1/73CzRsMk9l80I0rhWxveibt0XVS9dDrIIxalJdC+4SQcVyKv7F+ark4V
	cicB/Y7GbXJAOAIaxcOrSGVL+10auoZRxxZD/wDsuZP2B8Iy7DmxhhBXYkP2QMKUhN3/26
	dJI49J9Ulf3lSKRqyRQ/U3Bm6DxLHR8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sevB2pHo;
	dmarc=none;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757505313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HImQWyPPKiU7ZesG+hNJixJMPMJWb03FvGzrBRF48SU=;
	b=6yyfiFqSRTWCk6aWhgOQY33lcbAcsPp7ApEY36QWDuW6Z6iXXstCdoT/ez86PbjpuNGFzg
	A9ED2llwZ8pm5gaMBEDnYvPGeoepBZM9Y21gAymuPFRQH/PKSt8CGmOC9AfBrKTsTWdOPA
	a7LTAbJtQJV1rqhvO2HMg9Y/dgyWN7o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=HImQWyPPKiU7ZesG+hNJixJMPMJWb03FvGzrBRF48SU=; b=sevB2pHoYbqD+w11ai6VVyH4ig
	dGxQqZVqJp1sDYPaBdR4lWvdEshBiG7T3AJuQAoj+I6egEgoRLSpMxLzTxN82m+pMC4ASCvGhMGdU
	0KZeTkpMdc+590HmnuRC5MjKfJJFTz7flcyzasE7M+5210N5hHw2tVC/uwwkuLbBr1qc68Qb1KUrS
	OPHYJ5tSF4rzrKN3+CUnp8MozWwdUTRWBjE/45f6yJKgEmfw6Ixv4KrRKhSWC0r5E6Sb8nQzq9Sou
	gANISm8MjDV2MdaoIJDzN41tbSQwJfQ2I/kGu7k8wtkwr8woFf7/99JJ7hMuKnbKn9zP0tXPJcynK
	ug/QILaQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPo-00000008MER-3rqx;
	Wed, 10 Sep 2025 11:55:08 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 02/22] slab: Remove unnecessary test from alloc_single_from_partial()
Date: Wed, 10 Sep 2025 12:54:44 +0100
Message-ID: <20250910115507.1991829-3-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BEC98140008
X-Stat-Signature: sohnserngkjjr5kgsky1sbz8sjt8puy5
X-Rspam-User: 
X-HE-Tag: 1757505313-856579
X-HE-Meta: U2FsdGVkX189lkIiLRaSuhS3mhO5mXlFjopfPHaEz71xnPwOt0/6XNMGybrrZLuMmNjc58OmjNJpKt7hH7/Tj1KRZ26k4s+PpPhfCC2yd6y8YooHB4m9D5clRDjtb5g7ayqyxYzanV0tbH9Ag5NEcEzdkxsoWJnuzeDgPPA+pDG0jDCrlmtyBQV2OhOl7UBoDN2tOUb+oTA8v43sd1RQwYLXlp9tW7UID10DPElEzLyU2O+xbAMSw7vGFdCAtgIDtb8YgZD1aABAo4zCs//G8wEJow6XHArbmGnXrnIayVP4Uq+kqJo0nye5FYzMa/mrtxCopIXs5tUeXFydBZwbYOIi8BxDGBemY7cc4m5jjyVF1TAXgVARas0cEuzivHpxToC1xrMiylUilD1p2ZblEl90nAAgAggYy1WeRpTAiXtiAP4z48ou9DSvbgCrB+7HUJKQ2VqsqHAQqb3OrQXIiS1xTwSoZQZmDjk4kcWlNsN53vWndULPyBfwyRXlYV3v2Az/exanav8XLb/QYQ3UuDPAfR3UlixWBNc2xBP/4rOYSnL2obrv9evu7TiI8BU1f6wG6/YGGMS0XHMdI/06qjA5gKKKREjDN4Rmzp+cI8gJNAprFpP9c8aZCrigmGzdULaoUWom9d+cNcAF8j1Iq0JifpKP3taWbndY6mwJfRqCKWKiOubh64pxlNmFHGU9JCNhyGiuBn57v1KxFWlopUgtu8Dv9CUFtyCFpi8xJIHFtO1dX1OAVIVpm6/4e35WdlWdMPqTLzn5PcS3JAZUQUFZp6jGbPLDDhrc3hGy5sqEAWeb3SQbYlUqy+EUrNNI01OtetQ+eoO+w4i+XuIs04VeWruj9dRv0NjMSy0wrAQPDVbeuicUR9sL7kdBNOMgEhjHk7b93z9TBE1ncolwb5w8DlnhoHoVvcRgrx1hEEu/V2zuUQf8puqUD/XgOrd29S32IPFYb5J3yEQWO14
 qNdd0XC9
 SQH9WfXNxbiOMLaZ+70etfwpl8r1z6hqoLiV3ZFn/NP9/ZIo11LgeILupMacjNHPZmiSYmcjlbF1Uv2zhGJqgZjq6QehHTiU8OhrSQVkf/G8cKO2vp5xdQV6w7wKGQmoRhsrWSoEIb7UiMn0UlZAP224sQ/WMJqhHGPs6kzDmQaSM+0U07cRlnX/2AKncQ+UmQTl6ZXEOE9oXu9kSTvHIdOxE5feXeXomP6mSSB7qjgmtF7vRTno8ozUKY1gQgciS8DX6zcPgLJGiSpCSqWmsafV5TNaOkYyfNdBd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We know this is a slab because we already modified slab->inuse
just two lines earlier.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slub.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index ddf26f00b21d..81f08891741a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3323,8 +3323,7 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
 	slab->inuse++;
 
 	if (!alloc_debug_processing(s, slab, object, orig_size)) {
-		if (folio_test_slab(slab_folio(slab)))
-			remove_partial(n, slab);
+		remove_partial(n, slab);
 		return NULL;
 	}
 
-- 
2.47.2


