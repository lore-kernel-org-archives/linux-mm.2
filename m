Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77805CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D12AE8E001C; Wed, 10 Sep 2025 10:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEA3F8E000C; Wed, 10 Sep 2025 10:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27608E001C; Wed, 10 Sep 2025 10:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B05748E000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:11:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43F435BC5B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:11:24 +0000 (UTC)
X-FDA: 83873528088.02.E8BE16F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7307C40008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:11:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PZhLea6O
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757513482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93sM2HZKgc2E9g/LAqKCIWOIDEP+bApcJh+wvOO0Dt8=;
	b=AGNqLIvkH+/+TdvvnSFxobqAgXQ9pGlwN2U373OUrDtLwNdv56U1k6MsWU47WGJKoRPh+X
	j7Qxnk/m98LZqveNrmCrEPM09BAVE1vg/fcxq9XMGBfu6UVdgy2ZhROQ87O1LACes9TRFy
	bQg6t7AsN584Qd00uV8hIvPXPReC/is=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PZhLea6O;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757513482; a=rsa-sha256;
	cv=none;
	b=Dcqu9xncSkrPoTo0WIlZUuswe+BrFaUveel5TKij6gHXlpkZzhqdSvlwXvJWuCKZp2TuyB
	xT4wRB67enkGC+u5Q82pJ0cG/hkyiqxPcTaC1laCNCFxn/nrD+9LI7ocnhBWqQB/wpnqfG
	WLTOIHEHnWojQ/q1gBpfYhgFteyOFRA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=93sM2HZKgc2E9g/LAqKCIWOIDEP+bApcJh+wvOO0Dt8=; b=PZhLea6OOpvdLuZNPsib7YloCn
	NeSu396uv5dQ/OWWdhwQxmj8i+GsMIvsSKowQzMMKa2dWkvattFkigLStInuO86KRzXPsuWEITK/h
	qZt7imZrGEe/MXa1NfIpJNDdK9kFXIApN6FfEL8K2RRNrpBedKC0sqzSPcNoY4lGRqqjYAmlLRKqc
	JePNSKNGmW1joPWIKCG0ueLU9mOlWMz6IM7UxJgs7TWYJF9JdpChm270aBTrcCRtlG6LE2zSqaLTo
	YJLimBjZ2CL4a2XCnBTDdOtimO//PlcgVkzQEsX2XxQOiH75x2noqlctRmsPJeBxP2J724fwWUCyn
	JqxIV+3Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPq-00000008MFM-16bq;
	Wed, 10 Sep 2025 11:55:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 15/22] slab: Remove folio references from build_detached_freelist()
Date: Wed, 10 Sep 2025 12:54:57 +0100
Message-ID: <20250910115507.1991829-16-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7307C40008
X-Stat-Signature: rpcjafyrjy4qapbxsha7kur9odtd4f8n
X-HE-Tag: 1757513482-132997
X-HE-Meta: U2FsdGVkX19JwKtmGq0gVu76dvgwcckV0uQq8KFuUU0AcwrgJwHxK6WChTsirlxQXnpFzS4R4JOQTGaZkhg7yHu6lshMNlHwJwLfWpMWmRDWogSPlo6I78gIeEvwG7rCX8AojtctsciGcgSBSfBMLSk2y8DcrzJXjkaS+MEpmGq2HZJ4aKx9EWH0yHAE+ODMhzgvJ5nh7kp2XTOPNRDRO00XK0qCC6yThe8Ifyeu2RzhlIhCAywfXzT+VKutUYm1MDuqjQ5RAtdSWh+HGSjwNJqF4BDgaBk24Yu30d1LX4Br/MLuCSXuFKHtzsug8ozhzr51RTy2A771Arl5q+H2jjLCIH15Zr1GUUCzbTD9CmnvuJOY/uq651POYrFT8Od0NlOMc09WknYhDHsHkkW3App+Ly6D+/+n9BkaRZ5EKyEdESAqTmJzsBqq+C9Y9WFEPoJaxIyV3u/sxQw4E9IDSYgM4tk/J0QhQJ1ONowcIhZpgecZ0rZaeRYusdOMTDtPA1qsBTCNkgcE9qpO+6q7pSu917a6eIIfLu612i4kAGJxhlE/Ex+J1hZ2h/3ONRpq+EukCUabIxsKMf1WvG7gs0mdLZz3i2CzQzVO0lhvoJ7quTVXBWah5KHuklKbO/sP3NSnRBtGM3nFmGv8VUyGO8oHdvoAzwxai3HiY05oHW/xc082xR9x6bRX2ikkCrN53cA7ZFqcBZiGMvq9uWAiLni7EvC6WOOzxWwHtaztsduOPZb/pMVisE3OWBb12mInsvDsVJu4IpB8Xt21G6Y/nMClS/CAYxzkvXJIGsi+r4dQOkSnMgKG3fVEUjx3fl+jEtfunXTJytJStxKW0AMq7Nfl1Nbr3K7UUS7q0PBzXMvs1o39xl3/F2ZCsDA4rCYGDxCiZOsUcpD7LHRLE5FlSG9FyMYaVzX5kzuRsC6MEO6on6SvCkzaF8loEB+n99Ns3OZJaITMRDr0Ausk9Rb
 idB9i2Sm
 gmCPqPGzYmTBNBc6Hsx+bf31iMdUMyr8o3N3BlgGzgPWoZAHWqu0CPIJd18fbVjprFwYS9Zt9Mv7Fg0XA27djQ0zpbOPIyoEZSbNsmcNWMRfZrNA538FscQQCzUj7izwSKItHmPBACuiuruUP2TPjebC8+LP49gRWJ13wRdkGkuwQZtP2bP879E7/xMZ6Kjr3twiQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As with memcg_slab_post_charge(), we save a call to compound_head() for
large kmallocs.  This has a slight change of behaviour in that non-slab,
non-kmalloc pointers will now cause a NULL pointer dereference rather
than a warning.  We could add that back if really needed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 398dfecebb75..0f4e7a2a5887 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6661,23 +6661,23 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
 {
 	int lookahead = 3;
 	void *object;
-	struct folio *folio;
+	struct page *page;
 	size_t same;
 
 	object = p[--size];
-	folio = virt_to_folio(object);
+	page = virt_to_page(object);
 	if (!s) {
 		/* Handle kalloc'ed objects */
-		if (unlikely(!folio_test_slab(folio))) {
-			free_large_kmalloc(&folio->page, object);
+		if (unlikely(PageLargeKmalloc(page))) {
+			free_large_kmalloc(page, object);
 			df->slab = NULL;
 			return size;
 		}
 		/* Derive kmem_cache from object */
-		df->slab = folio_slab(folio);
+		df->slab = page_slab(page);
 		df->s = df->slab->slab_cache;
 	} else {
-		df->slab = folio_slab(folio);
+		df->slab = page_slab(page);
 		df->s = cache_from_obj(s, object); /* Support for memcg */
 	}
 
-- 
2.47.2


