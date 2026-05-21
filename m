Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A19CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7547C6B0096; Wed, 20 May 2026 23:54:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DCB86B0099; Wed, 20 May 2026 23:54:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494E76B0096; Wed, 20 May 2026 23:54:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3313E6B0093
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0CF5160FFA
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:03 +0000 (UTC)
X-FDA: 84790058766.22.3017A5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6EAAD4000F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KcQOjP80;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qo8ff9y7yiTQLpylSBvlVWCBzLWB5436sNPLCqpj4FA=;
	b=RBrgV2Ogb/+UUDwEWa5pQHC/oOEdv+bGSPA59Pb/WqpyOs6uxeYDpHeC7CiSRXzfC+88Qz
	eVrX4z3cX4VbrSzU9feHXDh+qzhph3KwJWaT7Hnby3Rwpay89eMYD0aKd19O8hEt3msgY+
	UpZWxY/IqCGujWGeS/r4Ypcl5os0nM8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KcQOjP80;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335642; a=rsa-sha256;
	cv=none;
	b=U4mj9VYrHyvZdAtzSpC1zro1ydq82JFlNuZrNXcyGkwDydoiYZLMEMEp3Wll+MLrmZEk1q
	u+zWplHRCb7zazGXEfPR4gVxuUTg2ZM8kt/uUcBv05JS39NHuGjyTyOFJN8SMi+8e/8c0c
	noABSez4Rz5JyaRfidvk/7DphpHM/IQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69029403B6;
	Thu, 21 May 2026 03:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD9C1F00A3E;
	Thu, 21 May 2026 03:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335641;
	bh=Qo8ff9y7yiTQLpylSBvlVWCBzLWB5436sNPLCqpj4FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KcQOjP80SJLuSv+Sj3PuAG5mkdl8+tLHGHUBswTuBU9RS7C4Wm98B9XxMTTo9lnyH
	 0+dBAGmDt+laIK2MklkzrBPJf7oNMjAw4SRNIJ0p7zALt9s2jvMtGCPjAhTtyET+sW
	 AinKZ2JznVcHTu5WRmD3UPp6YKdMBT2nWcsSy8sxx3qXlLi1+Xpl2EArRmpX0SqGck
	 IzKo9Pt9S1bY5/KFzw3d3wdXHDoZbiQ9F26iFvLHpU3BJVg+xwLjHJP0lima49whpe
	 SMzPNR4E4bVnGufJ3xYbu3OohsDYfiKvfR3vskyz7bEXIZpPXfyeYw/Q4MJz+7TWAm
	 mZfBXFtosd1aA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 04/14] mm/damon/tests/vaddr-kunit: replace damon_add_region() with damon_set_regions()
Date: Wed, 20 May 2026 20:53:38 -0700
Message-ID: <20260521035349.87565-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521035349.87565-1-sj@kernel.org>
References: <20260521035349.87565-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ax91ecbcstcsyf5qsz3whnre784koko4
X-Rspamd-Queue-Id: 6EAAD4000F
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779335642-913303
X-HE-Meta: U2FsdGVkX189W9PccDwEVgcL8VIGKSuj7YXj+6MPCrtezsSp+Q3wzTGQWaWxkU9rFaik+iXtn3zp6+CSoeUh1IhAa1AP2ssTQktKaKMrPUWIRw8HEM8ueTS9xuRSc0JVajeUm85sS9QJrOK5hqXhS+ge9fO00GLWHOMIeEukS5WTbwvCB+AKcG4k1mIkybaVq58C2WI6DTPARMNW/UcmWT/DmgH+iD/CFi9TDm0w96TaBujXwAM1vtYQHmCqCFCy0/YW5jRzUz55Dhg5DOf/onkIBpuXJcx06zS+lSbeyWNNqAaOr3f8femU2IJpjLaOgZk0hjcPI+fp3eWw5q4pCMgRbtd5qVaqty1yLGjkSHsJnZfF8hV5Y3nM1vOC0NXWSZJ+tf8ndsQE4nkI+fS8CxvSVjRuqX4PSLS/zToZHoM7EHCIdp69l9bVcyHMGW/O9liP3HSwFrHwiZFuWoJlalmL13r313gjI4AbwBnnd0ndpHoEePXrJdd2qZPdLpp0JuoJq6A85wkr5pNExHu8fVO/OhqbRRg90sv51lsDRHEXCdDRfcTNhiOeZfgW3skvMyz/rORptlTKm6BX43Bp0rI/eh0a2LHp4V3S5WupfY3b0lHG3npzgMabEnWyFNdgu90swuMZ/XrikbPTQ6Fl8zZtLN5wM0KiezIH8u13lsfnR5ofAl/+xFCcF0CGNfmJL4B5ZuUwS3NR5/d7r3BHRPxRhxaQ9mmhjuzwWh5jB6f/fuGp+qngSKNDIHhVoAX2u4Hg9I07aelPm2VxnKy+Frb+RlCn5Mm5ghEX0Ik5T1kO2We40AQmenXPAv/6zSBl1mxUUWoxWTfUQhFItJOuMxOAUBGmmxrSzdN5VsjXLMO1ccD/+c0TjthOJKCxR72c7MQVZdZlofMK4sw/iVZp0o6QCUzodOaY4NNZqhAJo3yHYh6B0SaaQ8lz1cdUqcc9c1FOHRhh4BEU8a/jqaJ
 K17OSyaN
 7pq+9sgAEGxnQgT/wIVjpVulZNAtRryLJEdaIXHLz6IKSF00A4eGAXQzWdn2SmWnjDQAizgdG0S8NXC/UHDT3pyrGuSVU4LPQhYvLJTOLnec2s6eRHkxGzHw9P12Jk4a0/COa8V3G1ifTQ7QrIT2RdqZbdDJ3F+XxvOVy1N7BJ7QEE9ivpVhpYrT58O9FGq9Y45lzQmMFmompDZjc+nKY8Zl10fgAx1OJMN2n0AlmMrVRhtAQJOZOeHNfCY1zjgAMsIe63AmpkIv20GZxdbNoDxp2Dg==
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
 mm/damon/tests/vaddr-kunit.h | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/mm/damon/tests/vaddr-kunit.h b/mm/damon/tests/vaddr-kunit.h
index 98e734d77d517..de30db9b753e5 100644
--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -132,22 +132,32 @@ static void damon_do_test_apply_three_regions(struct kunit *test,
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
+	}
+	if (damon_set_regions(t, ranges, nr_regions / 2,
+				DAMON_MIN_REGION_SZ)) {
+		kfree(ranges);
+		kunit_skip(test, "damon_set_regions() fail");
 	}
+	kfree(ranges);
 
-	damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ);
+	if (damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ))
+		kunit_skip(test, "second damon_set_regions() fail");
 
 	for (i = 0; i < nr_expected / 2; i++) {
 		r = __nth_region_of(t, i);
-- 
2.47.3

