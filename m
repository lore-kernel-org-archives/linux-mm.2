Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BAEFFC5930
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DF586B00BB; Thu, 26 Feb 2026 06:35:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3B46B00BD; Thu, 26 Feb 2026 06:35:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BFD56B00BE; Thu, 26 Feb 2026 06:35:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 758256B00BB
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:35:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37145BD186
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:35:15 +0000 (UTC)
X-FDA: 84486401790.02.236BB14
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7CDB9180006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:35:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KI9SLjRO;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNFcsrTCJuN3pq1P0jDB1SWfqOIjrkZR0u7eCL/hrlc=;
	b=vJuGOitRlH4TgE2Cxyoq1DRb76K/sKq8aOgju+/3SCuT0zO/+YE3TDntG37SGcF2GVyigN
	Xlx+X9vjApFThIwsL+BJGFN3ob9dHH/mtQkxznc2b+pac5OmchElTLcwrqNqVvWDdL3aNG
	aRnQDVrsCdwuX9nWJBmNd3RZIlC+3NU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KI9SLjRO;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105713; a=rsa-sha256;
	cv=none;
	b=O1ablVTehFlDELUiBlh9dqpsvh97mIkhsX8xI4ERPmW8mdT0mehSSwNhVXqmLFLuzjliki
	JZLAiQMf80nR9Y0FCKMbGjgBvOBARxFFXPNwyW8iaa2UnG+M5fiTzdZBNCHVCivCSdaTyC
	kc15JVftj3sZqzcUTwQ/HtVQ76bScsQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NNFcsrTCJuN3pq1P0jDB1SWfqOIjrkZR0u7eCL/hrlc=;
	b=KI9SLjROFcSirL2mTS5OuZAfOP+ehi28WMw/ahTS4caHqgegRKvYlaWKxelk0oDyR0nsl5
	/QixN5IwhA0UcIZAWfR1y/OvtYWnl7Ph+KBswIu2u7tJvUJmFOgV/00DoRlyspgzic/ovd
	xV36dvYGWz99ZyLasi42ArQFEIfukOw=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC v2 21/21] selftests/mm: add madv_dontneed_partial test
Date: Thu, 26 Feb 2026 03:23:50 -0800
Message-ID: <20260226113233.3987674-22-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7CDB9180006
X-Rspamd-Server: rspam02
X-Stat-Signature: 3u6oforjz6c3k8ukjt6tqo43qyusys9d
X-HE-Tag: 1772105713-219832
X-HE-Meta: U2FsdGVkX18rmSfPW1E7kLZv+XPtvqWHF1Me1B86fdJ9gm/NbA2XEIJ/tB04PuRI7WBQb16/BCiv//rvl3cqZaYUwUlqyJobN88bF54NUWqxA4lk76VuHm1eQI8WWj24DyBvmm/6PqpgV+OZnDAYSZaQd7pMyFGNC6CGsuyxN3ITl9fHgIVMgfU0jHqFDYi++VLpRKMBGnwe7KeRPZ505nfp6eJpNIurSVMOlpgRVKPgeUP486LbAKD1YG5Wha2SuAaKX8rUufxtRaofSd9B3CcAKNjcPIcG+FPnFBDk/MKP+xEoJs9BBjMn8SlVp0xvVVBPk4R9nhCkaMtQd5Hp0AMn227Dd3COtXnSg+7ER4UeYkLskq5f74l7ieYMOK0hdGtk1FBw+PLyTWP6xoFZmjKPBZSI0r16YnE+Ei+R0ab5zKC3MquXz/0TlDB1JbVdI3CwO4WYdFNHRfeiT86EyID+mfQqSUumxjkZ5HbW5PWPDPs+R7YA9hy0XFX6j1gDfpe2n3Uf4jhIigy6a9HbPS/eHPBiovPe7WKPkQc57KICfVtlo5DdV/sN48SPebi5Rkhmgge758Lo0JLEg+aGju2Xollj0i0WtdFUibNbqatUaCgl7VHr8OcWxTNr+lui1fZng/RXsYsfpDukjjYIYd4dtLGlZel+jCrfwlNmDAxAd4mrjlny6C3Ad3whjABVC+C2oW8PTx7YB5UyZL9Ky1T5iA65IJzL+f8I7XHKrN0Lx8hf3b1fAWwDArjk/OhKTObDixGiX1woUz1ZKoM5Bz0HYA0PE5/c9ko2t8ovp4sLCVWABDrDxKw8R2ifqr6orrxxqvZUwC/9WcvQukLxesje9wZcOauTS82NsJS2krq3mHpTfi/TzZF/U+1a96CR/lj5JAGbJSAdHJuP4SNavpPyX2NgGyFDQgDxWuSDcS67gTjKno6zbM9kozHlIRNR1DxNMfbwIWe1Yk5hU40
 vib325TK
 wXosa87psl9YJvNGCu/7sC4EEP/l5r3lclf5eM2VISGHI3UPNWzkLwJ+VoS0dKWOU/58vLZAgKBS7TT96Fgmw5qUp1oyvEhTlneGO4ztjxjn9hun0oywSC8RQ5vOdv8rU2/GVsfzo0K+1TOLi5xOHGGfvburtD3EYykbsOWoO0KxBlmT05ySGsPL0WCqsR5xcKnrZbZ4HxMXEX0kKTggJQCNBHvF/WYVo0qbLKTeGE5pTXDiQxybAoFkh+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test for partial MADV_DONTNEED on THP. This verifies that
MADV_DONTNEED correctly triggers a PMD split, discards only the
requested page (which becomes zero-filled), and preserves data
in the surrounding pages.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 .../testing/selftests/mm/thp_pmd_split_test.c | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/mm/thp_pmd_split_test.c b/tools/testing/selftests/mm/thp_pmd_split_test.c
index 1f29296759a5b..060ca1e341b75 100644
--- a/tools/testing/selftests/mm/thp_pmd_split_test.c
+++ b/tools/testing/selftests/mm/thp_pmd_split_test.c
@@ -253,4 +253,38 @@ TEST_F(thp_pmd_split, partial_mremap)
 		self->split_pmd_failed_before);
 }
 
+/*
+ * MADV_DONTNEED on THP
+ *
+ * Tests that MADV_DONTNEED on a partial THP correctly handles
+ * the PMD split and discards only the requested pages.
+ */
+TEST_F(thp_pmd_split, partial_madv_dontneed)
+{
+	volatile unsigned char *ptr = (volatile unsigned char *)self->aligned;
+	int ret;
+
+	ret = allocate_thp(self->aligned, self->pmdsize);
+	if (ret)
+		SKIP(return, "Failed to allocate THP");
+
+	/* Write pattern */
+	memset(self->aligned, 0xDD, self->pmdsize);
+
+	/* Partial MADV_DONTNEED - discard middle page */
+	ret = madvise((char *)self->aligned + self->pagesize, self->pagesize, MADV_DONTNEED);
+	ASSERT_EQ(ret, 0);
+
+	/* Verify non-discarded pages still have data */
+	ASSERT_EQ(ptr[0], (unsigned char)0xDD);
+	ASSERT_EQ(ptr[2 * self->pagesize], (unsigned char)0xDD);
+	ASSERT_EQ(ptr[self->pmdsize - 1], (unsigned char)0xDD);
+
+	/* Discarded page should be zero */
+	ASSERT_EQ(ptr[self->pagesize], (unsigned char)0x00);
+
+	log_and_check_pmd_split(_metadata, self->split_pmd_before,
+		self->split_pmd_failed_before);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


