Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACD70C61DC4
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D4E06B009D; Thu, 27 Aug 2026 21:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8856D6B009E; Thu, 27 Aug 2026 21:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2036B009F; Thu, 27 Aug 2026 21:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 509786B009D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:55:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C133C120240
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:55:57 +0000 (UTC)
X-FDA: 85149012354.02.00F0685
Received: from lobo.ruivo.org (lobo.ruivo.org [173.14.175.98])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0A89B40005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:55:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=Uy3wNEo7;
	dkim=pass header.d=ruivo.org header.s=mail header.b=Vqyq8QAj;
	spf=pass (imf11.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787882156;
	b=ynoyNImRUAH1HdtsSng1fLMADYUf+uh9TBrVXH8NksWyTlK4pg46AbkRa/UaWghOyxPoJ8
	qsony6/50lQhX+BTDOHaUrEF+Xa2DzmuGC1Wp/qHTvAex5OEbo4eHlWuOF9n8qiBlx5yHj
	vZ2LFPpeuhZXfQqkzT7Cj5KwDxgXaSU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=Uy3wNEo7;
	dkim=pass header.d=ruivo.org header.s=mail header.b=Vqyq8QAj;
	spf=pass (imf11.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787882156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=o4QAi7fBeb6I9wGrT2VJ9NIYmAVe4mq/cp6pnEkzVRM=;
	b=PQpaNPHodMWekeonjplecZUFN3/jIeMlZN4G4BkOEJ/RBbtI8mRQJ6Ar7WTczSFVRrmqiS
	qfe84bcfcGP9ai/SCjRGiOf5Ch47dPiF6Uif3tawYAjkQc46Cd8wTdngoRG2IYM8Mml5ud
	2dleMyNgxPWe4yr7oQ53qVtVni08ob0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1787882155; bh=0XtezHN7lbvhYPS5ZgcLDlQAUboNr9z2+QlaNxwWf/s=;
	h=Date:From:To:Cc:Subject:References:From;
	b=Uy3wNEo7E5wiavk3j8AucbYZHHg5g72oDlAE9+OY4ELqJOtJ4IhU/HUdpV9v9CuyZ
	 WDdEvodZysQQa3iLNdxm82nMKShmZ0pnY6fHZVSWKVvu3eyX/1Gp/B9kuY1R7NnvPO
	 dVUiVYz4SzmkTy1yyP+W9wRrOzUhD9SjKHhGSdcI=
Received: by lobo.ruivo.org (Postfix, from userid 1011)
	id 600A853345; Thu, 27 Aug 2026 21:55:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1787882142; bh=0XtezHN7lbvhYPS5ZgcLDlQAUboNr9z2+QlaNxwWf/s=;
	h=Date:From:To:Cc:Subject:References:From;
	b=Vqyq8QAjfYjcS9Mnctk8SoDT1D3jLlqykxyF2/Us3cQQJOIOsHEu0mPcIaBI3eNrt
	 /sLTB5a75kCp+O3GjNYGPUSx1UOnYj4MQbSO2kLfFH/yLHll+WHeXWgeLzGWw5JNwM
	 oroDuQZ5VSzXkvi9is+8q/plkAFhGG+TUvbcnCRM=
Received: from helbrecht.local (bob.qemu.ruivo [192.168.72.19])
	by lobo.ruivo.org (Postfix) with ESMTPSA id 710AC53049;
	Thu, 27 Aug 2026 21:55:42 -0400 (EDT)
Received: from aris by helbrecht.local with local (Exim 4.100-RC3)
	(envelope-from <aris@ruivo.org>)
	id 1wzlok-00000008ORR-1G2Q;
	Thu, 27 Aug 2026 21:55:42 -0400
Message-ID: <20260828015542.245315718@ruivo.org>
User-Agent: quilt/0.69
Date: Thu, 27 Aug 2026 21:55:43 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
Subject: [PATCH v3 1/2] mm: gup: move pmd_protnone() into gup_fast_pmd_leaf()
References: <20260828015542.125576330@ruivo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0A89B40005
X-Stat-Signature: cbw65erfm3ub8qztr4se5785itdbfxms
X-Rspam-User: 
X-HE-Tag: 1787882155-634857
X-HE-Meta: U2FsdGVkX18CcZCGFXcyQH6db7+13U/ffO+10EwU9gki1VZAk3Gr4bBAsZa0+01+GAB+DE5f0LAXxVP7A3izVqt5uV+jQhtiLoM7ZCdNi7kZhCHvbinDOD38B3GaY0wnX7JqGpDC806yz491iV6i3upwAPODz/oxRvU19ZrD+p8uB3JwkvOeD03DNb9GC38pLtupm+r2QIsin7t8JZoJ5Pm1vOf3CCl020W6pdnHgbXLkiz6cQ+cEx83oPyKEdjwvpKndzewwlQqng34B80E2L0pgMroIgdbXMZkF+Xm129BpvXNK7vHRfuADavFym3sJS4/ENZqu9k8q8Cigo/rl/RgSUKDAWgWoOY9E10v2XkgAd9R0K/joFYqviBMNIk709SApTMXT6Tj4Ae8UMaqLmZcuBwzQL/AjrYx6l/yNDWRn5EGHdaRKMwOOuI65yniPDg2OzrSO+N6iw9Nd0TxpfIZfJ4pVJGOpwrSH1LNnuPj3Ma9oWyLMyYmY2igjlV9vblqMs9kBML9IIRLIFfi4ez8MmFGaewhYoTcQcZTTe2HPoWztKXk0i4wG+StW1uHz7O0C3rXjT0IjhPtFqhSxfXxkDPkRgYW1/ju+QVXCertHztDbLs8S76Zp8ADVmA0tSUQAEHzu1/+UEz4zQ8wWLQUoB5xg/V8lU4AxzeNV8L756LxdYtrCg5Rsw1WVcfZBiqd5kRMfuhNvKUty+TgEBAhawYoSxv4Fl7snMP5+gpy17h59oQNATWLqygJ+PT44dfZJskSh/PKKBhL+nSkC3ObloPlc5ajXndmHTjh0bUg+9ZpP06NFux4toJHFup0+r2hwH1BmHhm1BkTMiSblPaFV2Oo5VOvsFoapbO//YL5mBtMg1fs0JgR+XQ8VFjILox1PQw0lX6zGmN6iTMKt7KZR7ma//PrrBPAxROhVY63Fkpd8qrTEsbeu/W/vPJQJmTYq4gn/+70ms0uSOm
 tOLhtnbJ
 /w+hOuKKJVEFWWABp4NJXkvwmcW7miOxeN6kPJUEqeasUn3Ip7/sFJA09jxPoPFQ8EvjFt5JzyCK/CNIN5FUFmRsuNJKR2G9Ai+WzGqbQjqyTnirA3swCgIjXe2PLqKhlQTXebdjInkJSn2fw/SNvI6jBwqXETGoIOJxf9amfV9qG0YoxaP2D1aSXJue3ka13Ws5YprYSWA1MJl47KMd5NzSJxf1xPAxhdguVWdi6U/YJ2QCexrAk/x9VwklgOUnkZIS0YgVgcxg4JsvkGc+aR2u1KBMKkoOVe/KEsj2bbN6FfsNzewEgV1Zty3J7dTPRDLsFkp1Vm3g+3AQgP4i7PfS4JA0olSfqJoCMD+oyJDHO5PgSSGuPjbpp0TX2Kc9urWsxL7H4TxDvt+SqIeYzTdYgBQXWqHTRThvR54igx8YFO0vkinXpUe22BnGP1XraUqLmajl3RRa/eyjTPmuT2Aw9uxPHYNCMC+jJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make pmd handling match pud handling by calling pmd_protnone()
inside gup_fast_pmd_leaf().

Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Aristeu Rozanski <aris@ruivo.org>

---
 mm/gup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/gup.c	2026-02-17 23:14:22.288234753 -0500
+++ b/mm/gup.c	2026-02-17 23:31:36.522625385 -0500
@@ -2929,6 +2929,10 @@ static int gup_fast_pmd_leaf(pmd_t orig,
 	struct folio *folio;
 	int refs;
 
+	/* See gup_fast_pte_range() */
+	if (pmd_protnone(orig))
+		return 0;
+
 	if (!pmd_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
 
@@ -3024,10 +3028,6 @@ static int gup_fast_pmd_range(pud_t *pud
 			return 0;
 
 		if (unlikely(pmd_leaf(pmd))) {
-			/* See gup_fast_pte_range() */
-			if (pmd_protnone(pmd))
-				return 0;
-
 			if (!gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags,
 				pages, nr))
 				return 0;


