Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE1CC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 293706B00A4; Tue, 15 Sep 2026 06:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243756B00A5; Tue, 15 Sep 2026 06:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132C86B00A6; Tue, 15 Sep 2026 06:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DCA6A6B00A4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:28:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D0F21203AC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:28:10 +0000 (UTC)
X-FDA: 85215621540.13.9518F3A
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf21.hostedemail.com (Postfix) with ESMTP id AC4521C0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:28:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TgELkMEC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of adrianhuang0701@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789468088;
	b=vT2IWW+YTa4TQRnNpOXL9W2XsHYQcQx1K2XPD6pFyOqznC/Z87VplZwwxJx5nbuSCQq6w/
	jo1UuHmKPWeD0C12dyke74/nVEr8DuV+izWoZBIWCz4JSkulC2jNQmlgB830p5QoWPyj0t
	MuCi/fclxkfFhViNkGTGlquvFl5lCsM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TgELkMEC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of adrianhuang0701@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789468088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=I2tI49ctpjTzkTcRuvF4mjqLd2YRMswe7/M8Hsg5gl8=;
	b=j98Kz4Zvwz23f2ZmLnAkmLGTZFl6sLYba6GMHVsw9ikzssUQLufhKtEnDco712pM0NbYDP
	Q0FaelypOhxJX+jmMebiSowSSBEUsXwMIrdT9mze9Az1RzLNQp+9Fr1sJByZa+86m452NY
	fHxmgg0jFLiLDaGzBVNjRsAXI8oOMFY=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea50dc1so1731504a12.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789468087; x=1790072887; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=I2tI49ctpjTzkTcRuvF4mjqLd2YRMswe7/M8Hsg5gl8=;
        b=TgELkMECnxo25waST/b3DDcfz1D9LrDDxEtnvATR0h2magNgPNeerfClpvfByb6OHH
         8mPy5c2sTPiMnFOKhkVmkiOhqG61uTF/U9w8a403VmyyedPhgqy59b9ZFHGXLs/Cvvlp
         Ljq0lXWQNoi47y4DklWkT0WnZSyXHbCzlzDXKRAA79ybflROjATm/qXFTo92HkUTaU/J
         zNgAzjD8hAFV4fav8gCNvpFA/q3bk+GnxHYrw/BdAWYG8rm0HEVMHIXejPYpL+CqTpou
         s2e5Vekl4UGfhCx5acityWoHr9Qdjzm9sTsHm+J8ZZUaFF/oG/XCNGwB5bMAKUW3L/3J
         KfdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789468087; x=1790072887;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I2tI49ctpjTzkTcRuvF4mjqLd2YRMswe7/M8Hsg5gl8=;
        b=h06w5QZPDfuXNDmiRNzWZAlEnL2CCFgyrPkkqWeQp1cc8ad6NPe+wqVbtXzgkhx4Tw
         TUhXs3soD3qhE046qaQXv5JHLzgWotrEhRzEoOuzaYebbIaeqBJkB4bxY14+YTKLorg2
         qfqc14f8rwEiohjeISovllgkl2GrdhBNaOdIKViiUhELFcMbZ66DZyjXO/IEh1kU94Sm
         douW3WeHb8QcGplj9ioPfARKTg3yLqr8gxPa3i8Qla8+RnDVW5/FTyBcg4JUYYOh3Lw6
         UITX23kTrE2DChv3gq7a49rF34arPLVK9AhJpfffE/HelAK/A1EbIVm38WyLE6Uu+Cem
         5Tlw==
X-Forwarded-Encrypted: i=1; AKwUvBz/46VkyVTo1dQTYGpIlT/uplpIzUyz+XltRIlCg6VdPjbAK8JMpbX5OIqftloUzCX3XSnEjRaGwg==@kvack.org
X-Gm-Message-State: AFuF++leYSD5GzylMpF3whML6zZbzcOBJCp446ZGegKxfki/vliitmSF
	SuVlKfxUrvsA9gqB8hmvvcvJBQ2ZdOhaheSL6pI4FUoDAinINi0d9med
X-Gm-Gg: AYBFou1pHf7cS+y/Yr1WHSeIOpTl6WcmHM64KVBjgn/4N1YFujTXEntRyZpQPdn2X+w
	kGwErsrWwK/bWocVV6d9PkjMBHkwRrES4pgjioRZHY+dTUdOLSSEePrVtc/dLB78djOVwKVYH9Q
	Ww370j9rGlkyaJn6F+ev8uP3RWaJd0MBgLYruBYMTtrYlUZxG72GaD7U1Gbm0X9UMGBRsLuQnDn
	XviTvaNen9aZO+cxj2H1TDb5fTVe60bZNcovT1TLVn2vRy6ItD8qk1yZuZme4xhWZ61NJCdwc8c
	LZHH062sMdz4wr9nh6d7H2BE58voGayHcy1n9PRzP2gjqb+F7gB6dwddfbXvB85cT2YsJ43fnb0
	loilDVdLC3jv9vTkWkEOMjwVCOoZCx419z+w176H83aPyCOyDEGYkzELZDXip3XDgMMkESUw0gC
	dG/04jpJO5ffgEhCBycIt7fenYSsTHiaF5y5uTKfEaloCaq1o7eXawG1ZHi5oYokEsv2HtJDFy7
	tBn033QcHqoTRgOmBKHeSNCItSM3KM+Cdm3kd+MRS7miJAtbodu86qxXD9GEh9Gzls8JHhLlhE9
	c7w0PwyFlmGSi78l
X-Received: by 2002:a05:6a21:1014:b0:3d3:ad3c:49a7 with SMTP id adf61e73a8af0-3db4061f373mr16009374637.21.1789468087368;
        Tue, 15 Sep 2026 03:28:07 -0700 (PDT)
Received: from AHUANG12-3ZHH9X.lenovo.com (61-221-208-111.hinet-ip.hinet.net. [61.221.208.111])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c6572ecasm6465344a12.22.2026.09.15.03.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 03:28:06 -0700 (PDT)
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ahuang12@lenovo.com,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: [PATCH 1/1] mm/damon: fix typos in comments
Date: Tue, 15 Sep 2026 18:27:46 +0800
Message-Id: <20260915102746.647-1-adrianhuang0701@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AC4521C0002
X-Stat-Signature: 8fm6rsufsya1gqz7qpqh9mau3mqp9kq6
X-HE-Tag: 1789468088-197153
X-HE-Meta: U2FsdGVkX1/5MnY/COZwLwplNm0uywdgEkDT2G2ig+sFpTqCM3ZFmsluLKkxzV6fU11trAPPdla7Uu6K3BFsl5MydJmW+ZZiO1JF8+Kc7C1vWmw26+0nTjkXGNCnYPByN1pnfrjH5D/lHfFU3+4/QSHQ38acWfvqkJXSl/dc4UvPKO6fikOs4tF129d5FYPgX0rY5Rqqf5IfegefMjFHfb65ahTCK6ga+QdZaVXlZybKnB2PecEcHJpCAvhM1VWnlcldkDfJa2S/8UeC8i2gb/xsiuQB/7jyPPXZKa+mn9WEfFN6PkerpiPBAlpsgDSBGRCs6F57l4ayQe6dRyxqYeD9IdWhkAC8xwylNpeVqga5nCptd/FxzHnfvk480ylfecgyEMLx9HiNKfFzXcb5oc2lL/I6FEnGSS6AN63NXBD+cLztNds2A5YFfOMj5F1wG9pucFhmfAhqacFUBx7/nkRdl9SjQ8dyqGmmF/JHgGQ3QxpItRniJnC0l9U6+7eTfjX3jd4ujrJSsTzIm7OsD70glekGlVOqNT3Cg+NuGoDic/6dhj6A1SQXdr3fMuEv+ZI/xG1J+1T007omVICvShsuDjyX1SJufLdROX3ZsxKieKcIAbGyIAAfzRmzQqrnruJDTX9fdh4Z/y4BC12TQzlnrdfxa6vZ8R1ABYL2sBfj2RqWSDQSTRED9fe4oVgRtVSieO/Otm6bDk17UDhaAoLBpAaAYMe1Y1Avhbvh3HGjZT7Uf7yolMKHXfjT6HyQ7Mo+zc5waXqcFYiG16sYMxZLLuadGI9y52U24kW6A63Vv+FNDf1lSpi6RYC6VKanZiiOgRDVJOp4yGfjgWpc5oJrzwH4oeE90Z6J2IH60HgqQaDg1fHMs8N0PON122moGo3OzXCF0HjcfYMsJoQhk0ODeeLGlxHVTzjOpf3gwrkQOmd6fPrTkNaeGetR+z24K+xuV8zNnz4WUKm2rVA
 /TscN9pa
 hMkZ+FXd7XqeNRlnpL5RePp3XwKzU3QMNQpXNu4C1SimIjwCjKAwVTL2X9e6f6ayHVagzA6ydeJQlpVlmcAPoXsiLGwMziDEQLYFekmNLOM1Tlz0GSrzGRZ6PIIVOg6nsCDiLlrRsNYITBTf69DYIEYpqtldbuHYTj5/91oAQ/YdtbgBKbpHd+Ox96LBbllvxrO6Oe0/tdfdWXFFRgvg/2Ec/nTvx7/AbtVCNNpFsvY+plzbdHqvs44Q4KsirZR4+DlRsGxfOxsRzluUfCFI3QgbGNDlIe/4E8dwDnqls2DJe2e9A3D0g0bsWr5yoxFOvfuzf5d/uCYUEvCsLniiNwo0+8MDvQy/FpFnIQoi4Fm4X2ynm3YfQIUoVoDFgqVY3MtfR7m561A+oNpa8mzrsXxXqLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Correct spelling mistakes. No functional changes.

Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
---
 mm/damon/core.c     | 6 +++---
 mm/damon/lru_sort.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0c98f7e267d0..981a153619c0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2447,7 +2447,7 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
  * This function checks if a given region should be skipped or not for the
  * reason.  If only the starting part of the region has previously charged,
  * this function splits the region into two so that the second one covers the
- * area that not charged in the previous charge widnow, and return true.  The
+ * area that not charged in the previous charge window, and return true.  The
  * caller can see the second one on the next iteration of the region walk.
  * Note that this means the caller should use damon_for_each_region() instead
  * of damon_for_each_region_safe().  If damon_for_each_region_safe() is used,
@@ -2613,7 +2613,7 @@ static void damos_walk_call_walk(struct damon_ctx *ctx, struct damon_target *t,
  * This function is called when kdamond finished applying the action of a DAMOS
  * scheme to all regions that eligible for the given &damos->apply_interval_us.
  * If every scheme of @ctx including @s now finished walking for at least one
- * &damos->apply_interval_us, this function makrs the handling of the given
+ * &damos->apply_interval_us, this function marks the handling of the given
  * DAMOS walk request is done, so that damos_walk() can wake up and return.
  */
 static void damos_walk_complete(struct damon_ctx *ctx, struct damos *s)
@@ -4143,7 +4143,7 @@ static bool damon_find_system_rams_range(unsigned long *start,
  * This function sets the region of @t as requested by @start and @end.  If the
  * values of @start and @end are zero, however, this function finds 'System
  * RAM' resources and sets the region to cover all the resource.  In the latter
- * case, this function saves the start and the end addresseses of the first and
+ * case, this function saves the start and the end addresses of the first and
  * the last resources in @start and @end, respectively.
  *
  * Return: 0 on success, negative error code otherwise.
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index ad8e86dd3a93..273efa3c913e 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -260,7 +260,7 @@ static int damon_lru_sort_add_filters(struct damos *hot_scheme,
 		return -ENOMEM;
 	damos_add_filter(hot_scheme, filter);
 
-	/* disabllow de-prioritizing young pages */
+	/* disallow de-prioritizing young pages */
 	filter = damos_new_filter(DAMOS_FILTER_TYPE_YOUNG, true, false);
 	if (!filter)
 		return -ENOMEM;
-- 
2.43.0


