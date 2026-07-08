Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B70C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD24E6B0096; Tue,  7 Jul 2026 21:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83496B0095; Tue,  7 Jul 2026 21:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5226B0099; Tue,  7 Jul 2026 21:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AC926B0095
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:33:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C91AF4062E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:02 +0000 (UTC)
X-FDA: 84963885804.28.A600131
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3C78D14000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bW3PEjtB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783474381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYlq3Lp1htxNcYc9q0Uy+3l1xL/3ejGhpOTnhJctTfI=;
	b=acXRg/0PRVp8LncUHr7+qQukGmfVSKEyM34nGSaTj5uLoRDjGMjuEfy5ZbrSkLhHYMkawM
	YdCCOPMrqbCoTsBl41vAhIcty9mhQebbbFXOWqpteffyw9xEwfkmusq9oBYYbPhHNUVHcP
	h7ded8Rb/SGDWF0h2WwnNFyRleQ3sNg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bW3PEjtB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783474381;
	b=rCcTvAiVSqTF9r/6BwKp1Cygtz8Yl+ILIO4EjKeXiSbUGdUnTXg/n0OJDVgSq9CqtGT9z7
	p9ryn81PMcxyzvMSM/PL9fOctkw7VsIaAkw906AGblr/R4tisf8A6n0cnd/PmGxR7yNG5J
	XFdBYBT9Lg2yIRib1MasGgMos0Xwvuc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E38743E9B;
	Wed,  8 Jul 2026 01:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387831F00A3A;
	Wed,  8 Jul 2026 01:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783474380;
	bh=rYlq3Lp1htxNcYc9q0Uy+3l1xL/3ejGhpOTnhJctTfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bW3PEjtBT4pz0A2bQNhUaIn4uQ3WAuhCxVoa0X94UHBW9qmu8yEK6wpfpDSJpDlPQ
	 284ZcOeya55ctUqmu9t+NyYDTNLM7ktSHJo7xufJCNYt55NWfELpoW6coR6GmkPFAJ
	 o/sKLxWl8AXEt7Oqq9EQ809xdFlG3xONbUsB68qlPk5GJhYOwFm4iW+6Txj5x6TxXA
	 0LHrqbBV2QYBAzqF02MBw3nXrd3D5s9/Z2C+peM7slo4/xFHRTNux4lyKsUgNSQRxr
	 h36r9BWJTJTcv7974QNXuKDwwaVm+4s+HUbgZu4xeq6Py5DYcBakIHqTHJbgRJhfaI
	 87XZNTUT7ytdQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 5/7] mm/damon/core: s/nr_accesses_for_new_attrs/nr_samples_for_new_attrs/
Date: Tue,  7 Jul 2026 18:32:48 -0700
Message-ID: <20260708013252.95888-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708013252.95888-1-sj@kernel.org>
References: <20260708013252.95888-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3C78D14000A
X-Stat-Signature: n4iao53bnbk5ucw45er9wbeomigdkgjc
X-HE-Tag: 1783474381-605513
X-HE-Meta: U2FsdGVkX1+RU/7hSiaV0VRjZSjR3Tqhp/SC5dOyEXEl6clXshFaNBxgVsJlyIYsRwP5YT7j58lyFX9xmY0FwudpSTuQrV2LOz6HAHaPIgaCWwje7TH2l4MLDxsVbDzyefThAtpCebMhPtqFvkdHbiHltBsCRYFGw9M+IvTZpyz5D7vezSvcS54O9aGhsvaQ1Oc0P7Snl/cTUVyhD8GkBEpUSAuXc57eQsvuL9zRROmXvxu7Sl/n2Q/Olj60FMChNpMfj6+Fkp1wfe2yEKDdip3uiG16QpLfOgpUmE/jxEPed1HL87cHq5/D6deK7juEsMtv+Ebn0MwGtrc3+OTzWCRK4ff2++O+5xdspCWoOLcOHONIJlOOWdeZZLGPsVEWxVFu2IF2ZlnDhq3E6rK6FrW9GuCTT2JBOlOMQ9Sr0B3KpR9agE89TK+tWVh//fT96ye8ZXFw6bHef09yosNl2ipWOx8nBU7Gx6kH9nRwb3LTVsO61eCwuYucBK2cvzKRrvk34l+IhnjHfMKPGwSL4JxdrgX6WQZTeUZ6JUmfuvibh5pbWssiCZyJ0ikVdd4AAgpyK3bD/dxbsZqB0GTGqa0zvlf9EycNuIrclSpo/IutGgKhqVFgUL6NCTFU4ajN6Do3+pJ5BMkzgge23J+iotXxiybb6P4+9WI9VBQT7/md6e+gSX71oCkG6JogwqVKuw+R9DEWlpPPF3sPEJTzDtNtYHQPhBQPTpPYuH42DWaSmoIIQT0IdHw3jH3IHHQX1nidL1hhyVrCH5oGgZZqz/tJ2OU0WYwlX+GcGh3/7TzF2JmZKYiUmSmbElvedq6yNwq8mnjbRlHUxLNaNXId5jKqTIgo3X5cZUtBWfm4+3kX+bA8EI0A/oN9VUE9tMQEKPSzQccrKv2SeL09DK43qEUERZebdtVJ+CxlAXwzu8xaRUKCZwFyqBESPeNkYv73XoOfjtyCvKeWpM2DGJf
 wXTD+4WU
 tZ845TvK4MOwN2CVZZa8p+fbOyfFlLpD6XKSXB0g9bnaxPCi3NdYWlDPbXExuRKvor0kA7TM+F8LaM7N9R1oHUgwsg9YeEcchMExONTcLM9lYHz12xPI7UteKtF+fNSM7k/TzhVtZdQJahlFtfyXvD22Y9jf3WbpXaricjZieUQhKaXJGRXXMPPYN7VbnJ8pWb+FieNU5jfyq7VkFe+WoRkdhzfGN51LEfBTFBr0Xy88W1NWBWs/mrYAYXZuzkRdk18LULD6fPMhWb0oqGYnYHBMQgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_for_new_attrs() can be used for not only nr_accesses
but also any positive sample count, like probe_hits.  Rename to be able
to be used for such general uses without confusion.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 718268df27fa7..800ff6b6d2473 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -890,22 +890,21 @@ static unsigned int damon_sample_count_to_bp(
 	return mult_frac(count, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
-static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
+static unsigned int damon_nr_samples_for_new_attrs(unsigned int nr,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
 	return damon_sample_bp_to_count(
-			damon_sample_count_to_bp(nr_accesses, old_attrs),
-			new_attrs);
+			damon_sample_count_to_bp(nr, old_attrs), new_attrs);
 }
 
 static void damon_update_monitoring_result(struct damon_region *r,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
 		bool aggregating)
 {
-	r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
+	r->last_nr_accesses = damon_nr_samples_for_new_attrs(
 			r->last_nr_accesses, old_attrs, new_attrs);
 	if (!aggregating)
-		r->nr_accesses = damon_nr_accesses_for_new_attrs(
+		r->nr_accesses = damon_nr_samples_for_new_attrs(
 				r->nr_accesses, old_attrs, new_attrs);
 	else
 		/*
-- 
2.47.3

