Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 280A6CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 07:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C12576B0093; Tue, 23 Jun 2026 03:42:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3456B0095; Tue, 23 Jun 2026 03:42:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2866B0096; Tue, 23 Jun 2026 03:42:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4B36B0093
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:42:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D48ECC1B1E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:42:20 +0000 (UTC)
X-FDA: 84910384440.14.683985F
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1C53A40016
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:42:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TZ1kLBEG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782200539;
	b=Nn26BZIaB52hbJWiFJqP2aekhbDEuv6LoRfQu13bWEJY8o4y/QlIcuQWRuH8/iqPspjywa
	338Xl9l+zjJlCub7Iiq237IGGu8Ew7tZYLWY4xBSMycWC6JkMiZs5TEqUp/djXNdKaJ0Gq
	lgycKSgTx4Kw7hMUlxl+SDGKze/+SL4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782200539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZtWmTuyVYWDd7wNzN5g6THdg+A3Pzvxm/xjDFHxskok=;
	b=Z06iO/i78ZSwL5tBUtFGSJOSBwKuhZJSv4FDCwfZ29i9mTn+GQgSzpF3tZloaCXuxF89F/
	jb4Z0Dz1Rmt0v4DsL6yBUxd/r1qOxo6Y1+9/AStr6mldX7bM+YHjrYKNszXGa8SwsTEpZj
	mXrm+8rOSwEFzPGSmJAy747eyaleiyc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TZ1kLBEG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782200536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZtWmTuyVYWDd7wNzN5g6THdg+A3Pzvxm/xjDFHxskok=;
	b=TZ1kLBEGB+dLCB5ixHqMmNpeHMIuA4Ol+HQmZa0vTFZtbfPACoeQpe9XlH6nCkDc2RJjCY
	BJNKcHX8EN0xtNhZUfUeGNmc4Synx1Z0fwrEGbqmcgtTGXOHh9xMB/zXa56WfJwOxGAqfS
	axlxnYJl2UVS5NWXfxSNcywzkgIzLck=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R\. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] mm: avoid KCSAN false positive in page_to_nid()
Date: Tue, 23 Jun 2026 15:41:57 +0800
Message-ID: <20260623074157.578113-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1C53A40016
X-Rspam-User: 
X-Stat-Signature: aukixyekq1mpjx68xnfo1xn1ed5amnh7
X-HE-Tag: 1782200538-66440
X-HE-Meta: U2FsdGVkX18qaOrZVHpkCrOfN+qWcv37ho1n7cr5OAQ7xdHmr/EnyxjfCrcZTq0vGlLO+k0cmEHlE+k919/BLNUg/y/l1Wfa8fD6Qfvij30MCEiaQImJWCRa3pCvyeaLsMZszWyNuZYcXlAFvCeVB3sGWpiODuQ2hlRQQ+/VwQ00DEIkof4Ffqr5BQNTH100iAMvd4jTCLg84AtyoUnoL5MgolsoOOiyAJQ7jT0zjXNrIZgfx52uIj6n6KbZGHsYaMsWcKOEmfGqbVDPS8ypHOIha/vupQ4F4Jt/4mJHVF/Ho3wmMFyQHs0NIfJAJyYXQ8PO00VGbyVHXcf6tdOPvlZpnyUzX+vKEMH4oo8/SOp7HAYDAYhv99AAVbYweK+NsXr4+2ILK3jZvHStBQ0dRpMQBQUzFSmPWRQp+11qZYkYzLd+4A6MxSJIuteBVqct050kyWEoAx5x8o52W4BqDIejVqbANRGhOwn00h8wqFaRGNtHXPZfPWBUwd4wzuO5ebid0qonqC1FXCPl89e22oPi5Gqwmkj95g7pglhQrPSgvhdiQgxfMIrcf6mG83ODCvQcXJ11dyixPE1hRu3DTkQvN/QFTZSuJ21JhQEPSLwof/oN6wZK7X0Wu5xmO+pRHhIDaMIDB7rCPTmZaJ6dwRGDC9uFr2qDpjC3r07x6ouS/oT1c4lLy6ApOVYTThZu4SJynTAAln9qgo78EGtlI7C5iy3/7IpFo2jw/yrd/UcO78FYjIeK+AKoUw4G8hBdSjKtDXnW0aBYyiAPlQebfGvKD3HkazPL73TG4flmKMJBIsPv1jGtXOTv2Zxah2r+hjYrlIZ8j0iSJ9SiH9Y9KdnReSfAfcbPLMZEpjaGzk9ZCMuuhMotbOCozI2fHLmv3WtZ12JoPtqgomh+EXG5yQyCztuxASZ44cl4wH/j4upYX8fLDbcsH7eS1wfkDBoGVgm2scM+oZdZi5coPHa
 Lbaom5YA
 TaCz08zyELfuyPErrtY5uBAsiB3Ol3AyVLIyWLp5+0yiYInSatNCQGsqjoiS016NiP28+LnU60X7XxH0vcOcdFzAbxfgrN+ndlnCFmS0m8zbLG6m3GRjRz8EKjip/INw3erXDZV9kDCYJ13Lccajbrf7f4BWgXlm/y4XpKTmasAqw0osFCdCy9/TfO2XZOMY9gQ2wEAKClz0KR0tRiseTYB9v+ehykQWq0dlFvNBhAWSrCOgzWeSxoQ8m33OnABOftmmpf3llLY3pZrGEg3dJqTMPK0YrmPmw4WXki/gRRTuq3F4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

KCSAN reports a data race between page_to_nid() reading page->flags
and folio_trylock()/folio_lock() doing test_and_set_bit_lock(PG_locked,
...) on the same word from another CPU, e.g.:

  BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp

The node id occupies a fixed, high bit-range of page->flags that is
set once when the page is initialized and never modified afterwards,
so it can never overlap with the low PG_locked/PG_waiters bits touched
by the folio lock path. The race is therefore harmless: page_to_nid()
always returns a consistent value regardless of how the read
interleaves with the lock bit ops.

Wrap the flags read with data_race() to tell KCSAN this race is
intentional and benign, consistent with how page->page_type is
already annotated for similar packed-field accesses.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 include/linux/mm.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..122d3b39369f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2296,7 +2296,14 @@ static inline int memdesc_nid(memdesc_flags_t mdf)
 
 static inline int page_to_nid(const struct page *page)
 {
-	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
+	/*
+	 * The node id occupies a fixed high bit-range of page->flags
+	 * that is set once at page init and never changed afterwards.
+	 * It cannot overlap with the low PG_locked/PG_waiters bits
+	 * that folio_lock()/folio_unlock() concurrently update, so
+	 * this data race is benign.
+	 */
+	return memdesc_nid(data_race(PF_POISONED_CHECK(page)->flags));
 }
 
 static inline int folio_nid(const struct folio *folio)
-- 
2.43.0


