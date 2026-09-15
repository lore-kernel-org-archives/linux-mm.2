Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FABCC88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2636B0098; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FBAE6B009B; Mon, 14 Sep 2026 22:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 072646B0093; Mon, 14 Sep 2026 22:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A961B6B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:09:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 224921C1CAD
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:42 +0000 (UTC)
X-FDA: 85214365404.10.739AEFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7A0BE40009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AyK2HKd1;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789438180;
	b=zXhovaO8yxbcIS1T9WEpWYH7jr1e6qvBWr0LUSmyck57KUH9z9KmJIUZ7LGLzT9e5/V+lQ
	53TxCE6Gt4n9UKlIR6kyaXmEko7ZsEx8A92kpV3qNRkJelEkHG+m5CCFQAdMVII5DxWNti
	19azitkyED52d2CV0qOMkvp8yOIYuNM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AyK2HKd1;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789438180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKHC2ohfBCTfxJBQb1w+ZA1oqxl4Tap4PnGbWDCoJ/8=;
	b=cEyPIML7RaG8LF7M/X+qfy23l2tS+k042sjY7+u4osaw30xIwWdUAEdJRLbV1MTIIooAZn
	l9uo+BC531JPQaOYJTGkUOm2G+5OL/WUd7bvShCR8Sz9kOrPCbg+bltOiXbfTkxtoiYbdz
	vdn3UYDslkr+f+doD81BflVrfjpSuvA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4334404A1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798CD1F0089C;
	Tue, 15 Sep 2026 02:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789438178;
	bh=WKHC2ohfBCTfxJBQb1w+ZA1oqxl4Tap4PnGbWDCoJ/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AyK2HKd1YKLNjnSRjH1J4RhSo6zpkPQIg09dQkCAOBw8P3HzPcfj1w/qtAdz72Z44
	 L66XXqFeGmKtUCLiG9gXh5T1FzHwo9EJZj2hZSlaZluLntVRBAiEwJHlG1309Z4sfy
	 PTrko13HJ40tR4DASi2HnFtVhuFmFccd2+L2lQSSudddXdDlDMqw+gnrSf1n7qukt9
	 VL+NpaoKcpSXxMp/zTIDIAfWf6FwEzOTCxnlr04feSZX2a9pKdyrRZ8Fd4dRoLo834
	 koKyeHI8mHhURzOrqcqBCElnZnjqkhnNVFgD/75v7nyryEXGMK6W3ipqH6UGPpZyrr
	 5mXY3Un/pU2VQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 1/8] mm/damon/api: introduce DAMON_FILTER_TYPE_HUGEPAGE_SIZE
Date: Mon, 14 Sep 2026 19:09:20 -0700
Message-ID: <20260915020929.102953-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915020929.102953-1-sj@kernel.org>
References: <20260915020929.102953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7A0BE40009
X-Stat-Signature: 7ahz9nsd7jo4ipcky5rarmih9wsx7we4
X-HE-Tag: 1789438180-143921
X-HE-Meta: U2FsdGVkX18Bj9GuKMuKVGxf9NwLnklR2EPaFCdn+DvjQX7ZVPeJTbDcVwcea18OdqgQDZZijBgO/WkILZ3Fg/3lc0bz3HmUw1Z0d2R2Dag8Mm+nx/V/iB/mgNo0H16A99lJOSHLdQ0T6nU/J0n2w3nCwAAd7bxnBmSs1TPQiPzbu1pmpVvKp6j5hOhYMyXumIKYO3ru/P5VsokFZVx5XiecCiWNhHTCQVX8vcPCmPLkO2lsM0SDG1lCXv6nuqHpT2vquzlppgrN5oD+Jy9i1Zqo/Vf7jj0aDom0VJ7P8X5zyQw2mdysV5riphVG8bCcdbjYzuT/S3WWQGbwiiyCT8ybyemTXLEyCKBrd1cHbi10VyL8sR/Wqac68LR4BqKuwXVJ0rrWjOSbLfLm3oEjljHvjIwzqTCTf7u/e4wnXOBiGHCNU+AjlwIcAi+VDc0hoH7M44HG+uTH1/+eXaNO1K0UCR5oz6egSmaCteOtLfKtJWPTLyRzRhVInKYcxvVqTkD+ZFjd972SaLQHeaR/7qufGz6uG0gxucqVzWTxHJP61UE+7nEUcc3P0ka001JpDtkPVHqvUgwZreZVRTJ6tBJB9MPqNre8/dKh7tbTNUkYryOLSruG3KKhmSdtiFbK3vpHGBymxLKLRnarWeRE/KqLRsB0f4gTIOarNLuAjv0Utsc49llyuRHel4Y6qddOvzS/0Z0U/ff4oLV6TntXjxCoThWMlXkaqmeqNIMdKtPN6SW2aC1c3aoUF2dCvckchxNtsRcGOpXSerwCgB2euaA1ILz/9v018Dim+JtlYBQ3m43cHnxmhciBWMZzgVYOl6lL5lbC4QMww9zNxbU0ffIEdDk975O2GH7IXNsyO24az15WdlJGFlMoxPLStL8cRwx26x02Ygwv07/YlNOBkgBGA5fkMQ0r5HvkfTQEj7OxYubpYmLfVWYE1Sg2C9eYQ/dutBGmURiEpXrvfci
 imXz7swe
 Wh+v58ZVqLnOXJn1SxIF+Y/8OYgVOCpPNv16IwFL5zDjsLbXTCblRJxd7zz4cwA57QXLeH4Qp7bqCAoE5IpNT81vpBfWvEe8lcT+m2eJqLEu3ZuNhWTzkfnO99EZYgm18WbsPSGOLwDHHzf03IE4jvY8ADRgIBNS1985FufBPAeaMfZwKFQk2JtEdtMPKaJxGqjdXk6aVVpDIYxIeKL5bl8QS88KY4ZuJcFYw2rOUAM//u3U9rTfQvx2IgpdR1X1IdoMONtj4n2xUdK1fJQ0i0F405sQDj3q0k7pc8EyHNNGwi/d7pans19IsD9p2imjJFlax8x2cpNMsb9EpTQt7xniQpYpO7T10TCET
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new data attribute probe filter type, hugepage_size.  It
will work for memory that is backed by a hugepage of a given size range.
Add a new damon_filter_type enum DAMON_FILTER_TYPE_HUGEPAGE_SIZE to
identify the type.  Add two new fields in the damon_filter struct for
saving the size range.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4be7d1df8e71f..bbb190b474015 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -783,12 +783,14 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
  * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
+ * @DAMON_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
 	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 	DAMON_FILTER_TYPE_PGIDLE_SET,
+	DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
 };
 
 /**
@@ -798,6 +800,8 @@ enum damon_filter_type {
  * @matching:	Whether this filter is for the type-matching ones.
  * @allow:	Whether the @type-@matching ones should pass this filter.
  * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
+ * @range_min:	Minimum value of range arguments.
+ * @range_max:	Maximum value of range arguments.
  */
 struct damon_filter {
 	enum damon_filter_type type;
@@ -805,6 +809,10 @@ struct damon_filter {
 	bool allow;
 	union {
 		u64 memcg_id;
+		struct {
+			unsigned long range_min;
+			unsigned long range_max;
+		};
 	};
 /* private: */
 	/* Siblings list. */
-- 
2.47.3

