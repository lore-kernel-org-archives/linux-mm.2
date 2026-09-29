Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC7C9CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4932F6B0095; Tue, 29 Sep 2026 17:53:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46C036B0096; Tue, 29 Sep 2026 17:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4426B0098; Tue, 29 Sep 2026 17:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 031AC6B0095
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7BCFAC05D4
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:22 +0000 (UTC)
X-FDA: 85268151444.07.6B83CF7
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf20.hostedemail.com (Postfix) with ESMTP id B57361C0008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T1cdr4iv;
	spf=pass (imf20.hostedemail.com: domain of 3TzO8agoKCAQrmpe2zemwlksskpi.gsqpmry1-qqozego.svk@flex--nilayvaish.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3TzO8agoKCAQrmpe2zemwlksskpi.gsqpmry1-qqozego.svk@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9oDUPam2OtyD04KoExZWYJnbuDJYbUQdofAXr0u5VE=;
	b=Gjvw39P36MCQyVmban1eN6uuegf+uClsHeMdOPKzhZov5h39+Upe/df2xJsRVFM3yCXeJI
	CJQMFT+qvkRF3qDfgf7KPg74jiEY5m4mBme6TP06SdFG9XNUqnn/ZnOOYccKTYTda8qgz+
	1qQa7+TNymcnPUEGJsePqZKQVHFndRk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718800;
	b=Le04G0EEmjW/5y2Uhg7WQlHCRZPrZa76YE9qYmcJduw5HIDXWgCltHiJzbTw+ffhJGPesm
	fTXFDHa7TGtrC39unqr0FipreQBvoc8w9K0vHCjJr0tgsr4GCeOfKq/hQ0CtbKFqkKcdsS
	l2h/gtsdpuMotxDjmc7LqERFIOzOaIc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T1cdr4iv;
	spf=pass (imf20.hostedemail.com: domain of 3TzO8agoKCAQrmpe2zemwlksskpi.gsqpmry1-qqozego.svk@flex--nilayvaish.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3TzO8agoKCAQrmpe2zemwlksskpi.gsqpmry1-qqozego.svk@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-341eff9e381so4825553eec.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718800; x=1791323600; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l9oDUPam2OtyD04KoExZWYJnbuDJYbUQdofAXr0u5VE=;
        b=T1cdr4ivzcwUg0yXW8GwIm3euLft9h/w/OFiiGMivyjUswoPJFtLj3xESXGrF3Xsmz
         uGUavnqgKAJimms36vLxu/BSBRWN0ouKiNILSPmrMEXT0WUGWRtv3KZ5UElk67HuOF9m
         l9kPFcSqiH0wFyafiMaE/WvP0Hh5V7/ElUzjtROpM1GsyUz5cD60ZzYlVx5eW8+afnIb
         9Pz/8jAo8JwoHH9tZ2spmOk027NwSl7cD9LeFqZSSHvM9PuUK+rGJhJr3NkY9AXT1sWB
         jkiLPUayE7Alk8m4Pi/p8eKyBpP9Z1yoJ+/Tu8Rf5jQZmK2pDeQmvOpEnoJ6pxVSs5/p
         zNow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718800; x=1791323600;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l9oDUPam2OtyD04KoExZWYJnbuDJYbUQdofAXr0u5VE=;
        b=NTNZTS0++0TXg2vWMNi1URhuA657vVcLCfT3mpqHcN/nRJc2mgnI/WIx5bI/9ouZtA
         yh1w05Kx7LoIiXTB6lNSJYWUB2XzjTTx1jx+JEJ0EONnpCA77+Tcb7VXVVLl4wjAQp+i
         wg8LhywJUAVien9sj+siCU7GJFbqQySFQe0vgDM7szu40+TD3+x5iJvDUfc3ViVvSbId
         odFp8EyZ83Wel5+EDBXjfJL0w799pv6ryFII9cOdE/uCrDmRqnNdc0vdz7uNoxwswJIh
         IJTGKMJ4QbankIJHJsxJNXnHCTJoprEg+4QHUItibIzX1cUiVd6r38eaGouvlU5SaD62
         J+Qg==
X-Forwarded-Encrypted: i=1; AKwUvBwW9YnrKYdlJJf/hW3GIQNPNN468TalYVaKl6CGMBouOJz82JMovXoH3z1kQhIz4dmjk1vLlNbg0A==@kvack.org
X-Gm-Message-State: AFuF++mnOvcnjkTGZxJ4AqBzdXJf13ADQnZ7Co0eufX1YpFhzv2qVzLb
	9oQInxI+XLWegBd2dDN/dLnY9zWB1Pne38cnIjkmLtN/B6pVcm6cLlNJk3/BV6hDCPk4/rS/slp
	mD42He7zoJPeO/iXgCn3M2Q==
X-Received: from dlbef6.prod.google.com ([2002:a05:7022:f46:b0:14a:9017:9767])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:3b83:b0:143:50a0:56d1 with SMTP id a92af1059eb24-14c9d9ede6fmr784069c88.17.1790718799260;
 Tue, 29 Sep 2026 14:53:19 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:51:55 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-5-nilayvaish@google.com>
Subject: [PATCH 04/15] mm/hugetlb_vmemmap: use folio_page() for vmemmap
 address arithmetic
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: szsrjkzk7w6wpk1kk3eiw4ma8tz7oqjq
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B57361C0008
X-HE-Tag: 1790718800-325894
X-HE-Meta: U2FsdGVkX18iZs086PyNwWdBg7hv0sP15CUIoSTM3+gsqqMUSrDzQ1Cz48jzO8fo7K8rM+bAs+KubcYfkLQ8QxOlYHRMTv9o7C9pY6Q+nyzVZwWD2D3Hz1Cx3jvsoZtjwzo8Vsng9li0XYk6DOvJlEo7BSYxZHX8t0C64g0cu0p81cShlbvzd5x9iN4MyUvZ/TDEG2Ltu7TaDdxMkaVdueoQoIgN4bqwKZ0/ApHn4YSEKVKNoPKaAvYDCEILwN4koDIOKHwBgDsRaf5jz5yRgIhJiIbDWgNr/Mc+tPWx3iDjQo8uZzOyHsx9pbZkxBUZ454MMsBBttkbrFUZQoPuNiAXMxGxXgCvTPzqAWESSYjsHaeS+pZx3Ul4EHDHKd2XFQjyLns9xiWYBkJS2PWzNytL2T1yAtfGiNij08RiWXahkfK18osahl8Gs8o0O4xh35H/R3qKm2X60YzrxxoxFrEAK4ex7svSrCAjHmJ4MX7nuF/GqgoPFh4/qz7lewfwl/jxtXhAc7X48sgx6a8Q94w9R2MwRt2lpRbtzLFxT2CUp6PWxBK3o5Nvl9EEgIPejy+SEAGlz2bZa1WwSY560KbK6ugYzuF1BBWoEtyigaaPSHJqTgA2xwOlruV4abSLZ2NDh9e1zlsy/4VY5o7ewVRzUzUUEDNo0+uZZTPZGY+TaAtJRiK8pdcHedORkuoS8DCiwJwPuGlw7759GCBgD8mT/o+wttQfTLX3fIM27SWRr92WJY1361W8QHrT3CRcdAt8x8j1eMf3BCYvD34UX3OjsVODPmVkezu6yZ7YCGECYRkOR6KM3E4FU5r2nIE0OjA3oPdlII1q4d0ZlqANCPFYxGqz5lq5VDMwoXQ0vaZPgYooSOnXRh2VSqvh6M6fQYyc0I3FpkJV3wwgyr+c22TSUXSnwo5gWP0r41wPFBWmpRag1TURu5fVVmlrSU/l9fIO9MkPMCTQveWk0e8
 talU7Kb3
 WTgjirUBdbD6N5jRYpjAOs1d+SHnJSZvhFH2jdNU06plnEMJodcqi/FtN6yQQPZnp86ML2IXB2F8Z1g/QsRfL7Jku6XwoihhH0agsNLsn4XqI/RnRmPH7P/A8bdOQUjSvus07WqaXkNn3IVJziNdP8kmz8amohOOAmwhPkEWVKwS9+z0DNb9scg462Vz2cdQ9gfPH0bsCi7zcR8izieT3VZsKXTxaxgPxFyWcpqoGZxwKGvdb3R/QJko+VODpj0qNfa8/ryszOGRaJx1bPAyF4D4s8iE1jGYJnk2sMohk8ZtQwF2LC94vaGRDVgKloZFmchn14Tn59C1eIvrQVV8HnmFQWhMyblI9Yr8L6xOJGu1Zc+uZyWnyYH2YBODoSkns4kXvYoEHpmbjvaMSYaCvnUDS0f1SfwgwXRPiI5r/fNN4eXln1rPhhyPEaJk3g/gkVioNpM2HI6tLMEvRTzxXDhNO47JiDUb3ldI34Am+lqXGpDQU20IyorGVf+NQlnmcelCtsJ1zAMMMXDHctssrTS5t7b9CqyoHcnTicMHBk2WN2+GqKt+C1WkIq5bHdlqFTSdVJtOHT+7wyXSrBIsi2hljWN++RLP5CKWJikiy91P4+Hq+Q8Xc9tfHK1R6RU5seO4kecUgC6LEy8am+E4xBoq7ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

Replace direct (unsigned long)&folio->page casts and the implicit folio
pointer passed to copy_page() with folio_page(folio, 0) so HugeTLB
Vmemmap Optimization (HVO) operates on the vmemmap head page rather than
the struct folio address when struct folio is separately allocated.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/hugetlb_vmemmap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 0057fa2a16a8..807c6bb23997 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -403,7 +403,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
-	vmemmap_start	= (unsigned long)&folio->page;
+	vmemmap_start	= (unsigned long)folio_page(folio, 0);
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
 	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
@@ -531,11 +531,11 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 		goto out;
 	}
 
-	copy_page(page_to_virt(vmemmap_head), folio);
+	copy_page(page_to_virt(vmemmap_head), folio_page(folio, 0));
 	list_add(&vmemmap_head->lru, vmemmap_pages);
 	memmap_pages_add(1);
 
-	vmemmap_start	= (unsigned long)&folio->page;
+	vmemmap_start	= (unsigned long)folio_page(folio, 0);
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
 	/*
@@ -578,7 +578,7 @@ static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *fol
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return 0;
 
-	vmemmap_start	= (unsigned long)&folio->page;
+	vmemmap_start	= (unsigned long)folio_page(folio, 0);
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
 	/*
@@ -610,7 +610,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			 * Already optimized by pre-HVO, just map the
 			 * mirrored tail page structs RO.
 			 */
-			spfn = (unsigned long)&folio->page;
+			spfn = (unsigned long)folio_page(folio, 0);
 			epfn = spfn + hugetlb_vmemmap_size(h);
 			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


