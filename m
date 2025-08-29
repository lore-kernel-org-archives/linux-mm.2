Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA89CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 19:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF178E0003; Fri, 29 Aug 2025 15:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA68B8E0001; Fri, 29 Aug 2025 15:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E3DA8E0003; Fri, 29 Aug 2025 15:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 859CF8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:10:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 307B31198D6
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:10:33 +0000 (UTC)
X-FDA: 83830736346.26.E2915C3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7B69318000A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:10:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NohcFLsE
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756494631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGUHU4pR/Dz/5IY8zYJRFulEeQTx+8P+RklsGlaCcTo=;
	b=RVzrvf2KaCx9KctEw0620BspIBPngCotXXoc9gQFSH3WU1UE60dRRRUz3duTNCSAsqqY4T
	CzsymwrDNtbhF8fy1JB4RMp4Rw2nsImgRfAWeM0IWntj832cVdglvkzRAhP0bzyrSIhU5h
	pFcvbGYuqA3sHVKbs1QP5qeUTnfFbCs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=NohcFLsE;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756494631; a=rsa-sha256;
	cv=none;
	b=Fvpupr6Hv2r/YvBe5MxkD5s375355EtgWno4tx+MOyRhQzo6ElK3ZDhBUfYT4CHKillLo0
	qf/LZWE5oQbqlCoBLjKXqy4/dKVDzNYARsj2fuaqyvN0O/nnVoxUEtuexviIs3kFFhJFEU
	ybeZV09BiODR1QgV8HlghRtnr2DAS/8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=KGUHU4pR/Dz/5IY8zYJRFulEeQTx+8P+RklsGlaCcTo=; b=NohcFLsE73NRvTTFYWOEndbfM1
	BjdyamBLGWzWSV0MNttVXyfY6iTfF+4eW03nvQpHuatfcErrlr4BcbKATBIo/VyBYSW7/5GDJXe+/
	epgxKJg7Hl51fh4tABf/60JyNSXUO7AyI9h5yMcPflCJl5TnDIZXj9nwQFzpHtwkvrN65+VuOCPpS
	pY30nmrMNkB/YkdewGdznYNfCGrxEVQGjlBzDuCd23lNSix/3v52TybcOL4v/2mumvfA54Q0ZDyHq
	1fc3Ga6KcnVjXO+8VAt6SK7f1kU4uQtK/Xr+KhmHC8DcokxAzncvrcplqjdr1qPuw3nMQLZNJbf7V
	tl+SRkYg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K6-0000000EFvv-2aOi;
	Fri, 29 Aug 2025 15:47:30 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 01/22] slab: Remove unnecessary test from alloc_debug_processing()
Date: Fri, 29 Aug 2025 16:47:05 +0100
Message-ID: <20250829154728.3397606-2-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B69318000A
X-Stat-Signature: m7fx4jsfiw87a5sdd3urdms13ojucuf7
X-Rspam-User: 
X-HE-Tag: 1756494631-610257
X-HE-Meta: U2FsdGVkX1/aw/jmvV+EXjYatvsWveUnPllQJ4p+esPjvOhy0wYMdx3jtA0MDPGogHfzUn7CgTIsPbQatwuclVVqsD8iWqQNe2ECaHsc3fSBdnaF9afUFVTBGGNQLvuwaIYhOCf+6cTAJXAFqD0XshKqhA0ua57W7RB5VIMpMhlnEsrHdlHdYo0rlrDfqe1zP8bn0Yo+imTg1hewXD0yvBGEcONdyyyN3vaL3PatOHvVi506ZWyoLo+tkM8PRuN1Bv2Xpeo59uNu9Oi/nYwhk1xB4WGQ8hUuoDdAwSEkui9CP1nLgDai+WL/OyeZkMr56E/rl3X+BHNAAPQIAXvLji8SUCLWHEMmyvm6V9MS/fo4BdvR8Tk5bOKpRFdkN5HEsQoBv70gl1jfA8zjWKOle6Dxk4zPbwj3JaxVIeQgXbNfoWniAeDiV8w1x7bJPEUUCNM1PEtTcVBw1o6BDhbLj3ZpxYgJ5T1zekjnSjZn/cozqJljhp5hLA4ekcUo/IFQEAZRStewQZWmJ19VUmPGXTApWzGeeaI+RXvAPRKdcbw1aic7SXRzwcb1v76CWbctUi69dfRQw3FuKWpaIVj6JV/ENnGXhOvSo6vpL/UCBMu9F7IzLBq0lKQUc54oCEBCyZgw+yNp4Ie8zCPzl8WwtI72TcHBxvCkhex5ilZsmwNqFmYg2catwbZoRbenVNQYxscp2L4no34xasmxIe3mP7X7sDYzpo5iv6cpSYlDnKZ4st7vf2u9B51PkwndymXdphvaabjwrLSKy3N2xwIlP39J+tnlo5loGzy6s7nvoOWQ6RT0h7CRrl0Nx9kA8VnMwNEHs7ZJyDBnhKxLFfwaVcWpY4ecmAnKiKi6VEgB22qL9AL634CSannNzIbEyES2xcNBbTdt9MZ7Z6CfoEFkWri0ZcEJNqqdw995MvWrLAK/jgDUwsGLnZk1QJ7DPU2sNPuVEeLiXllFTFIVE4Y
 lm5wfaKo
 Zygcx0sHXPWYgIyKOiYfA+wKNWZKBInROQP1dLVET8/jPv98Wi8G/Txp74q3eIRKFjR6pI/7nmAxm2WbvBWK8v6RsJWj/l/llCJxMyp+mII1AMoZHCF/dYym+LTRazHki43WVsV33l8zW08G9RmFxInZQ8YVKP4OM1gkXPl/3lNEr0ZvYrBt09qhxkyQhzJP550VEeQ+uehxFA8ioWJue4gwEUUIWnxG2K4MypChhcRWeRvQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In alloc_debug_processing() we know that the slab pointer passed in
really is a pointer to a slab.  Both callers modify members of the slab
data structure.  So we can remove this check.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2138fecc8d37..f737b85a326f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1710,17 +1710,15 @@ static noinline bool alloc_debug_processing(struct kmem_cache *s,
 	return true;
 
 bad:
-	if (folio_test_slab(slab_folio(slab))) {
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
+	 * Lets do the best we can to avoid issues in the future. Marking
+	 * all objects as used avoids touching the remaining objects.
+	 */
+	slab_fix(s, "Marking all objects used");
+	slab->inuse = slab->objects;
+	slab->freelist = NULL;
+	slab->frozen = 1; /* mark consistency-failed slab as frozen */
+
 	return false;
 }
 
-- 
2.47.2


