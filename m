Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B1CCD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:40:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A04436B00B4; Fri, 22 May 2026 11:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98DA36B00B3; Fri, 22 May 2026 11:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82FDB6B00B1; Fri, 22 May 2026 11:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 606CB6B00B2
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:40:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1BD9FC3288
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:39 +0000 (UTC)
X-FDA: 84795468198.11.C412D48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 77460180002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fsRK95YA;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7YG6GjDiTDF7+hhcDJxfKB/57kZkbDeh0ESzV1mlaFU=;
	b=KZZcARwC1xSyDnT+slQhr1z9D+5VEGwB1SJevFzccYX7W8Mn8xiGxN/Wooa9DCYwGZV/ku
	Btx3qzunCz1OO4/bufNikbIO1CDgz0Xs20WYQe+PtiGN782kPA3Blmi1Y/OHkw1KhU3tcN
	yTcHdEHluajhfsbRbNNg07G4IU9iVJ0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fsRK95YA;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464437; a=rsa-sha256;
	cv=none;
	b=2S2BX5iNAwOZMYfIZb2jzr5tJovYPjmfocQY/YX5PhrNA/siweZyfLGngWTLDmZP+kygF9
	beF9kWdnMYfgrWvyLTbVMGSwhNiIZNYTJu4t0zkRXLxoj/g2GDRKJwxScxT9PO9WLDRF2q
	yADSfXhU/quS7OrdlIyzVi3+JmBipgI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B7DC400C8;
	Fri, 22 May 2026 15:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD87A1F00ADE;
	Fri, 22 May 2026 15:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464436;
	bh=7YG6GjDiTDF7+hhcDJxfKB/57kZkbDeh0ESzV1mlaFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fsRK95YAWFfmFTLX9KTNGpOXUjmYFrUP5XITKBJ6Zy/kioe4s+41wiViUR9ADrYUA
	 /bEYTKwdm97qlXr4945OsxiSBAEU8d0oIkm5AF6ksYIRs4CkHR0iPp+ocMCevAGX/C
	 o5gWmdi+6lvShm/tPw+m4Dc10lqcoRgI0RV8EA6PWkkvGcW2CBn//SrpWo7Qcs9tux
	 gBleDdtdbJ9/uJWW9WqrIKo4pkPCR+pZzl1nI8sllYBT8MU4pwN1mZRAEbMia2SA1w
	 gPkWwEiPe728JVD5t0GaQkdtD6bf9t5HEzYIDAmaPPSEqwABiQQ6OEIXBbsHDvLO/O
	 30UWotoCLPPvg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/14] mm/damon/tests/vaddr-kunit: replace damon_add_region() with damon_set_regions()
Date: Fri, 22 May 2026 08:40:15 -0700
Message-ID: <20260522154026.80546-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 77460180002
X-Rspam-User: 
X-Stat-Signature: h95tow4qfmn7o84mynjcjmmt151co1c5
X-HE-Tag: 1779464437-399802
X-HE-Meta: U2FsdGVkX19HJ1q3A1lzdmXLgy4h7WJIVCKzWUDLNaQauCDb908lrGtszVNovRVzBgLCHUgv3P8yLsKcWfVQ6ynE9lgok9xdzhtNztX505W9cKJDW5DVKFv8l89YRLEZS4KsYvGS0zAEVr0CWgZgf2yt3RWAMzmwNtTgZ0Ro4wHz9f0CkfNp5ovWNXL+0faW5IJGIHw54op+w+8fwXPs97pkaFVJpshMfLJ6D+TLFmpiWPKpGlGPjOLvaEmH+gvG5Hvfx/PJhUNCzuNuaRtoKXHMLMzlIk3tCuWIpe74ZY7X70v6gahI+JhfqBBgG256WhHg1Uftw57ajlGTKzjOdw5IhTGvlLKTRR0bWMPYRFnoCvS2/UmwZQvqNyU0kaigxf9ZIUPYC/53oHvN8lZ84r+zsDpmgcifALhEx08mWaBoES315by1VzspZEGtiGSuKI0f9Q/T1mIO6oFLesRJ6GaRaXisuk2OYlbhN7mvqFAJBRb6BN85LsNeq3LYPl3XMrr6aQj1H8EHiW2A4gL67DUevnmg9I2Xcbnw5emAMmrDD/5jMFfvYgg16/HQisgkRTfueZt+xyDCVaP7GadccFNt3ppzTir9IDflo3b+lyoCjuFkd5eqmi0nUDCWohyfOaIS5mfv/HcX8i5AEspg0vYmwT9o02WdkHCLlOtiTyj3Lbe7qgFJg+wUHl5+sHqFM22D40p+AlD47wgVOaD5cOZc/4S1BmMpvkT0WqsssCznKi5FGNiiqFPKsSjmuSokVfW1qgD63NdmaRtzbQIrwkt73Hjnp3Efedhji9TIAE0ntu2wNUYMbVIrlwPjGZ/qrRQAly9Pbha1lchN0bcNF0XmSq+G1Y/HBA02Q0sOXfDavY1AGfUxMJ/dJHZJcwx5wBylEx+yHPwmt/Ko66JX/izM167PHnLT+74Dp0ir1opm73gY5MG2ESdDby2Uc2jXLkkv4DYCI5gSBfY0xwx
 xHFHATvJ
 zC5s7ZEf4Ca/rYpFThSWF37c8x7FpSlquxolRGaJKeze/SnxnQE+j5wrNW2OMSdlXkeeOB9rNJ5INDAPdzRq4eOiBgRcFYk+3CWunMOOc6Kp5POZICZ0Zi6xjSaSBHIBskkchD1WGeyqTeZXp+RBeunZo65+KH5A9FlKT52q8JTx1uBC6ue99sFuAE3Iz4zqek8MibVHmDucu1Zdzyli0UpU0dgUbM5NdrWuTgArLCI+cqJtdkQF01wG+FmyQFl+3bfUdq6au3hfROlpfphrmAKNB2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON virtual address operation set (vaddr) unit tests is using
damon_add_region() for setup of DAMON monitoring target region
boundaries setup.  But, damon_set_regions() is designed for exactly the
purpose.  All other DAMON API callers use the function for the purpose.
Replace damon_add_region() usage in the unit tests with
damon_set_regions(), for unifying the use case and reducing the
maintenance cost.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/vaddr-kunit.h | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/mm/damon/tests/vaddr-kunit.h b/mm/damon/tests/vaddr-kunit.h
index 98e734d77d517..563fbc7e3f448 100644
--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -132,22 +132,35 @@ static void damon_do_test_apply_three_regions(struct kunit *test,
 				unsigned long *expected, int nr_expected)
 {
 	struct damon_target *t;
+	struct damon_addr_range *ranges;
 	struct damon_region *r;
 	int i;
 
 	t = damon_new_target();
 	if (!t)
 		kunit_skip(test, "target alloc fail");
+
+	ranges = kmalloc_array(nr_regions / 2, sizeof(*ranges), GFP_KERNEL);
+	if (!ranges) {
+		damon_destroy_target(t, NULL);
+		kunit_skip(test, "ranges alloc fail");
+	}
 	for (i = 0; i < nr_regions / 2; i++) {
-		r = damon_new_region(regions[i * 2], regions[i * 2 + 1]);
-		if (!r) {
-			damon_destroy_target(t, NULL);
-			kunit_skip(test, "region alloc fail");
-		}
-		damon_add_region(r, t);
+		ranges[i].start = regions[i * 2];
+		ranges[i].end = regions[i * 2 + 1];
 	}
+	if (damon_set_regions(t, ranges, nr_regions / 2,
+				DAMON_MIN_REGION_SZ)) {
+		kfree(ranges);
+		damon_destroy_target(t, NULL);
+		kunit_skip(test, "damon_set_regions() fail");
+	}
+	kfree(ranges);
 
-	damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ);
+	if (damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ)) {
+		damon_destroy_target(t, NULL);
+		kunit_skip(test, "second damon_set_regions() fail");
+	}
 
 	for (i = 0; i < nr_expected / 2; i++) {
 		r = __nth_region_of(t, i);
-- 
2.47.3

