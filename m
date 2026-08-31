Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24B55C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6536B009D; Mon, 31 Aug 2026 10:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2CD06B009E; Mon, 31 Aug 2026 10:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69326B009F; Mon, 31 Aug 2026 10:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 755986B009D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:03:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02F01C0145
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:07 +0000 (UTC)
X-FDA: 85161731256.23.043E218
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4C04820004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=erWnS5qg;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788184986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4ZULCHKs962Ql2lXNfqffyY3ieZ1mpdjWXyoNcHe50=;
	b=t0li0kvol73GfzWxkXa2piPQVbJVK51idXrbjamvybDGYIfNP8D3la2Fa8LUR8QPug8OWr
	HuAPN6CCH7RHPN7n8pdm8hzYCXUxkvFCM0T0Umzegi2uaTpVoqGMtV+DDd7Hyo883xZjpH
	8DkOk9ZbKbZ5Rz5oLFEZmh3hk8Li05s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788184986;
	b=3hoJqwgPDACwuhPv2T4V7tEpn9PdB5Ya9SVKvS3NfPZ0N0cdsFl9EzjU2y4lwq+i1ukDHd
	lqpC55b3R+f7/BFg/H3zeiD7ngxTG874kSSOKA5CkBvHS9AQy9/KCFqaTE1KCXTVAIOIRt
	trfnuQs8+/H1blcu/cardUTjxKiZrVg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=erWnS5qg;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 93D784071A;
	Mon, 31 Aug 2026 14:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B32B1F00ACA;
	Mon, 31 Aug 2026 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184985;
	bh=W4ZULCHKs962Ql2lXNfqffyY3ieZ1mpdjWXyoNcHe50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=erWnS5qgR382J6JC8z3nVk1ADCqsV8VhofU2Ph+h8YZCbWmv4FeaOqyakgTD3sVT6
	 SCDWU3vMlqX54v/PG7m1wVOXEswl6nXm00wz0VJf1/lwCiwoCY6x84Nr8suHAxrml1
	 HYX2AqXO5O0XBw0XgDnmhCcAsrFQG6jZCOXpgTM7chqvOzAfbTmkPZRdUFtgHqupVn
	 KFECZgtDxf1hYRvQLoN0g0494AS6/lMMnnPUqTbS1HlN3doLwddGJzAqXf8UQr5gMo
	 Wo5XQy6dUpXn7VLZLO5JQ+v4igVQ51FDFI8oDOcG+r5CGMMu3QBHsVi/DP4Xbz3rs4
	 5HnIhItzFoL/Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 8/8] mm/damon/core: handle extreme memory state in get_in_active_mem_bp()
Date: Mon, 31 Aug 2026 07:02:47 -0700
Message-ID: <20260831140254.72004-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831140254.72004-1-sj@kernel.org>
References: <20260831140254.72004-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4C04820004
X-Stat-Signature: 9opkcpywz37gtx7xsu1t96gn936ccy47
X-HE-Tag: 1788184986-761295
X-HE-Meta: U2FsdGVkX18T1u4XI3WtEK+LeTyMMlgWRkwSNJS5GTG7YpcEQ/aOqUvuMF9hLfFx/GL6qwzLNdiVgy2Op4MBiL3G49R9euYxe/hkcuOJSBPXkskFcgcb0+cwcziaHC9sEXqoKWxNKsumABElHfJ87SO5m1tJ8bSlx6dF4q+Thn+17J/J51coht4JaB79wxrJvI3jv1X/0lTrCc1aOTbQHTLf4FcVYYljuk3liQTu08YDpMq4TTX/SmHhp3ofLSZEGrg5Qt4+FzmmQokdYRGTPjqvHzRtnNnnSwLdKaBs9kRcAhPDje0k/fBpIgBqmaEtSo45Od5O98VwtFZFSOqxoJcrTdtJTe8T5qb1M8n/N6el4VPXV54QEJZTaY93C5q8VqBVRG7hRWH6ofaX7YMets3socW67YTxj5q9Q2zeN5L6xpB4DwTn//P6nl4nI9N7ZiXXc0nLKc89SnkuZ0MqKOlVq84ZZgBbpyXhZRm00lTUpxWjeQaNKx2ehRCh/VImLGaJMZZwWRHWxXK9bqF2of9EhNoTIlS2koT48UjrD0ymsvoZoBdc83I9OJINL7+p1v/sBGbIB9/7HZlkYNVXVa5onM6eQaCkn/WeZK1S5aNLh8Aen9jXF4zAQjgem+s45t8w18otFMEE88ylCSm5Vh7gOLIUj4w5hMvhXabENl4jBco2fsaAFpzpdI+xWXYfm8GFvqghXLlLtMRGnAzkoKLsHUp5tAPARoduVY9xfa3gTZz4f3qWJxzCGiJyzmxz0qDIFpXl9V8vn8FKK8V6IaurjceBbz+vl5AqDWI1qX8oJPGpA6MdORf4EEfcCUjBtR2kGnX6zs5r9uQebv5yP/le8A2MS2K1i/dfZwsbKMW3IONyLmf10xw+K4ZEmIIWdZYWQUv44th0K19EWzvwDanssanw3beaYZAglwSJ+Hw7OifLvrsqwsm89Cn5gZ7SjhOqTt7chXGqxOaCNQz
 eKJqKJzh
 efBeRNycBVRMrCrsibEu6vgrHFeKCD6QQJXnhyLXsTbKXIwjDeLpakWBAcwR3YPURAbjEPlNIHPyd9tn0ceozKsF0yURTafKr4GvToc0j8mBgvYq9Z2GuJKUrtXQV51zU1VLM6MkIotm/Igs2QwzX7BIbKuXvIZDaJ4BBgI8vbNsl5gETu5N1LTQSe9alivyVgt8pb1xpaXkRcbbuAMDBSAoVCZUt7CADcKQwVc8MVxIB0WXOfTDC/9piAEIIBkVPgaX3Goe5qvZocXwJy25QEENuRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_get_in_active_mem_bp() uses the sum of the active and inactive
memory amount as a denominator.  In an extreme and unlikely environment,
active and inactive memory might be zero.  In this case, hence, it
results in a divide by zero problem.  Avoid it by changing the
denominator to one if it is zero, before it is being used.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260721034756.147011-1-sj@kernel.org

Fixes: 4835e2871321 ("mm/damon/core: introduce [in]active memory ratio damos quota goal metric")
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3779a04753061..f8dddbff74a77 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3015,7 +3015,7 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 		global_node_page_state(NR_LRU_BASE + LRU_ACTIVE_FILE);
 	inactive = global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_ANON) +
 		global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_FILE);
-	total = active + inactive;
+	total = max(active + inactive, 1);
 	if (active_ratio)
 		return mult_frac(active, 10000, total);
 	return mult_frac(inactive, 10000, total);
-- 
2.47.3

