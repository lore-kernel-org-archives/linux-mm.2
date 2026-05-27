Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 947FECD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 22:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84E766B0005; Wed, 27 May 2026 18:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FEDA6B0088; Wed, 27 May 2026 18:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED5C6B008A; Wed, 27 May 2026 18:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD676B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:49:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 285C21A0741
	for <linux-mm@kvack.org>; Wed, 27 May 2026 22:49:18 +0000 (UTC)
X-FDA: 84814692396.26.A5C4868
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id EB934180005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 22:49:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WOsjrwff;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of chaithco@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779922156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bwNypzZtj0CYSMM6tcncQY6OAS/9PwcMNtbHXNOoRus=;
	b=wQlZMR192JLT7hB0HYczjAPv0bo6aG3YkO8pePfsJctLW8Bz+X4rCK7ffDrLRnYpXwErZq
	etgvEIA39s0wxiPiwubqX0qPXf9RqXhz1MmQwJ+z02xLgl9aKtLsK2r5mQ0g3IQ4zVzmVl
	ZdtFDCe5C9U6S/p/JwyVnFlsU+WRER8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WOsjrwff;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of chaithco@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779922156; a=rsa-sha256;
	cv=none;
	b=7YS9Nz+pr4f08QMDcK/0TCYpBm97vey30imtfp2k9mLx8L+P/A7BZJ7NgkE+6VSnzFo60b
	reeju4ERWWiLak8dtQiXw8T7jd+Scvzns5k0aqw3weR1E/U9O2qQC0YxL0/gDVtYgvaOrt
	ixL+GIK3YnRoXyS2EuIKKFiHHkqFlKs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779922155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bwNypzZtj0CYSMM6tcncQY6OAS/9PwcMNtbHXNOoRus=;
	b=WOsjrwffV9g15r8nymyz+txgl/ZalPdIFBBr2/B11HYwftTgqL6xeyURqMQJdXS0GLu9Bx
	2EceBqnhrETZfdJuCldJW4iQnmhk8Rrn1WwSJxNq6eA67LoirbhAkp5l9u2qP3IW6XE546
	ZLRKORHKS7H1oaJ9+wc2lTys64FFppg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-CMqwMhVYM26eGMpt77kqmQ-1; Wed, 27 May 2026 18:49:13 -0400
X-MC-Unique: CMqwMhVYM26eGMpt77kqmQ-1
X-Mimecast-MFC-AGG-ID: CMqwMhVYM26eGMpt77kqmQ_1779922153
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-516ceea1984so126270191cf.1
        for <linux-mm@kvack.org>; Wed, 27 May 2026 15:49:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779922153; x=1780526953;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bwNypzZtj0CYSMM6tcncQY6OAS/9PwcMNtbHXNOoRus=;
        b=SYC29TTShQ2/YHeQzYs/uNxmu3on8k4zVtTRLwP0X7KaXhDKWmFw2mk3+UB1+hhBcH
         PCeJSpfFNVsZBkTnxX1ehSjnpG/MXk9F7bibclC3PRYb8RHY9mE7rBDPJRK+BvaWZpCE
         pTLEnyCWCAfBhJq8YWFkWG1ibzYNzSfIkZP8FCV+K0A3b9ZyJc7UJBPErmSiIX0dnNHD
         IQYsMjwUJiQJGEzTgpLz8pgPrQ7aPJLAe56EImcCWRypaIq6quLYRsu6aLvb+4gkrmFH
         mKbMREWZ6cp+vSA78NKHwHGUK5fz3x2OQygxMSAgO56xk3vYpRUZmFz7Z3am/HnWpN2d
         EhIA==
X-Forwarded-Encrypted: i=1; AFNElJ+QqgRQR4hgPuE6KM1W2aQLS6icZmmtDBH1WzbT2SiqcomBx206xNVAoBaldPr4UaTNd3cnuV3v1g==@kvack.org
X-Gm-Message-State: AOJu0YyTsmn3mldLg6J1tE/KmW5UvhDiEeNVBsNS/pgFKWGNB9V2Bem8
	aljeoZuPf6v8kjgZ5yrKirLseIRv/UJ0gR/kn2BvwvMMtxN80nhCWFHmw+iEerpjRqAawA57jCA
	WKfiJytyZHOAX2CCZoJEcFrkkD+FVSV7FIirs7tJm5trx9zsz+7L1
X-Gm-Gg: Acq92OFaeS6rs3VKH9ttxHmPDPDaFQo8vLFAjHboFIXfl5QbifRQ5JQFZrI3zkQY2/7
	7zYcSYhxJsaDjIm17t/8bmkaClt5WhtZTgZ5TKjO+j4+3EqJdKT5G9p70ygQ4Msa21p8RKRvfGO
	TMKNYCX8Pe00EXdvWvpSMvXQOFkebj/cbuq+U2E7Y9BQl2hLAK48tWErGL9/1IROwEYVaby3izo
	lhznETz8R+oVpeu5AqjKXScBZd/p1rfl+GJ92XyrIF7wULEj+BWthCsLXev0QdGeV8XVUwOl2LB
	KoRq39YgLJODpRbxczCplWe47BmZlJMRfvPDp5rW+w9NImV/sDmU+q0kythOSRyPumrASZM8AFu
	96X5x0bglvmwDM3psqsW7oKdnjO4VrNbgGvi9BciXyQd7NMMZhIF8K/5gLuGHnIqr00hrY/M4r2
	V0nszYhcXvW429j1BCTsbFnw==
X-Received: by 2002:ac8:7e91:0:b0:50d:597e:4b50 with SMTP id d75a77b69052e-516d42e07a9mr373458641cf.13.1779922153273;
        Wed, 27 May 2026 15:49:13 -0700 (PDT)
X-Received: by 2002:ac8:7e91:0:b0:50d:597e:4b50 with SMTP id d75a77b69052e-516d42e07a9mr373458301cf.13.1779922152814;
        Wed, 27 May 2026 15:49:12 -0700 (PDT)
Received: from chaithco-thinkpadp16vgen1.redhat.corp (174-16-146-173.hlrn.qwest.net. [174.16.146.173])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc80dcec8esm181079486d6.7.2026.05.27.15.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 15:49:12 -0700 (PDT)
From: Charles Haithcock <chaithco@redhat.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: Charles Haithcock <chaithco@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Respect mempolicy when calculating surplus huge pages.
Date: Wed, 27 May 2026 16:48:46 -0600
Message-ID: <20260527224848.1753560-1-chaithco@redhat.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pjOa5ngrfi1Re1uaU6hP-kfp4bFxj0ON67nq9l-Y9Vg_1779922153
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EB934180005
X-Stat-Signature: cg8gtciyhek47oyuz7f8jw9aqdsfhh7g
X-Rspam-User: 
X-HE-Tag: 1779922155-25086
X-HE-Meta: U2FsdGVkX1+dTty89Jl5q2SKxGNFl4wElUcbj8owMB6+W5enYJs/50ZRW3kdg/gGdIhKm4H0QPd3pWueiTQd14GSbFgc6RyMkily4HfUm3jtoIY0fyTLXoCD3zOwySqU2XVs4awuLEQBb13KgwXWkZjBemUqQ8jRupZBlUUTP4UyShWTdbYeyo6mEDFyHY6Mlw0U76noeOs0Lj/av3ZVeF+kRhk+Q/VYGLbbfQho2TYuqoy5IKNQrnWSCelVTDZqC3CU8raaFr50O9mm26dvq80JrX8cpOFQicoUAgw7Kwpobl5MDm2GKM/TwlLo1UBFMvEls4TGZGZtsBK1V9SByFtIoYZ9BPpOBoMlg79rdvuLnwzKUfmEEa2l7UicKtC9SkoGEIT5ECjer2rnOaBSuh8Ip6pGtIJy6GWl0Df2n+hnKQUD+W80Nym4DlGOiU5eUTvmQy87pevG34oRFVvmVONQs7E3sPWQX7bI/NchoF2VvgYVajOd8xbo+tfxExk2A8jBRClJeX6b25qw3LHmrgRlFlmhoROvNQryKSGiNUA8yfJ4E29WDmgKscE9/+zocXaAQKsEqRRgIgT8+Rkr8sdmWfo6uRxU/mv2y8T5Y3ZESQ+hPt04rSs5pl9lso1sPkUG4n+YPxtxSskm1tyBpKTykCLF6GoHtEDuBQ/k3VA+kfV/SEPVNd+c/a3TB0+uTy87g8oi9fmzYJhjfGakmo8sP5dI2LGarpyeP01hGnIIwc9Lfb6nqADtSulIA/SvtPOErGbaFM1obzT+kVxpl3Vafyr+EhbGK4nbd9p8eZ7egGeA40CGXLAPEdAijLrrte6kMW0u7J6IHbFzQSsIEU26ngYlvFMV5gSWbdX2cLQ+6aai7KxNvli+PjwqcpcatTwC4jOLMBqhwaCvE2eYnM6jK8hnio3iA47RVJXWqPR+juuoiN3Im3Khb3wQJUSd3F9Ky5MyQVqknXUTV1L
 /q3NuvAg
 g75v1Hd3sYWjfDvPmF3tSFKEw/T1rguSyNR0uzEhGfGrXCE1MDdTUkdn8bLMEsW5z/7/F8sXCxrfSni5+wAvXST/q6SvEXegVzY1V56u9RKcLeRFwCA8scqUh6YDH2bT6O2aN+eQEGn7I590rcK17oYtZBxyYXfXRK8a2iYR4sd6qbV4EYPDoP3BqYHzfoGMn+150mbeCopijItGC7wFP8MdPjjK7dZ69x/QEstduHhKc19CtrIIA5reVXroY1fKOzcem4RZanyBZJnDryrPnPyMZqrMfO2PhowRbt/Jeg3arRiwJJk0Rpji7V4cE+k/FQMKVkVZGhdYXUT0rh3JqwqL6HaCKgrHM3YTuXrgJfi/+8HwMs09lmsjV5wChVDztSyTWhI6FZGsi7ugJ044097a8hJ3RhHDCDWuj9lc36XjrTBwyClHQ/b8PPDzI6df9Rm1C3bk8h3kWkEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Presently, when calculating how many huge pages are needed when
reserving surplus huge pages, the global count of free huge pages
are used. When reserving with a mempolicy, the global count of free huge
pages is used even if some/all of those free huge pages are on numa
nodes outside of the mempolicy. Fix it so free huge pages only on nodes
within the mempolicy are considered.

Signed-off-by: Charles Haithcock <chaithco@redhat.com>
---
 mm/hugetlb.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f24bf49be0..02752ce735 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2255,6 +2255,23 @@ static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
 	return NULL;
 }
 
+static unsigned int allowed_mems_nr(struct hstate *h)
+{
+	int node;
+	unsigned int nr = 0;
+	nodemask_t *mbind_nodemask;
+	unsigned int *array = h->free_huge_pages_node;
+	gfp_t gfp_mask = htlb_alloc_mask(h);
+
+	mbind_nodemask = policy_mbind_nodemask(gfp_mask);
+	for_each_node_mask(node, cpuset_current_mems_allowed) {
+		if (!mbind_nodemask || node_isset(node, *mbind_nodemask))
+			nr += array[node];
+	}
+
+	return nr;
+}
+
 /*
  * Increase the hugetlb pool such that it can accommodate a reservation
  * of size 'delta'.
@@ -2277,7 +2294,7 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		alloc_nodemask = cpuset_current_mems_allowed;
 
 	lockdep_assert_held(&hugetlb_lock);
-	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
+	needed = (h->resv_huge_pages + delta) - allowed_mems_nr(h);
 	if (needed <= 0) {
 		h->resv_huge_pages += delta;
 		return 0;
@@ -2312,7 +2329,7 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	 */
 	spin_lock_irq(&hugetlb_lock);
 	needed = (h->resv_huge_pages + delta) -
-			(h->free_huge_pages + allocated);
+			(allowed_mems_nr(h) + allocated);
 	if (needed > 0) {
 		if (alloc_ok)
 			goto retry;
@@ -4513,23 +4530,6 @@ static int __init hugepage_alloc_threads_setup(char *s)
 }
 __setup("hugepage_alloc_threads=", hugepage_alloc_threads_setup);
 
-static unsigned int allowed_mems_nr(struct hstate *h)
-{
-	int node;
-	unsigned int nr = 0;
-	nodemask_t *mbind_nodemask;
-	unsigned int *array = h->free_huge_pages_node;
-	gfp_t gfp_mask = htlb_alloc_mask(h);
-
-	mbind_nodemask = policy_mbind_nodemask(gfp_mask);
-	for_each_node_mask(node, cpuset_current_mems_allowed) {
-		if (!mbind_nodemask || node_isset(node, *mbind_nodemask))
-			nr += array[node];
-	}
-
-	return nr;
-}
-
 void hugetlb_report_meminfo(struct seq_file *m)
 {
 	struct hstate *h;
-- 
2.54.0


