Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB171CEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 004CA6B000A; Mon,  8 Dec 2025 01:29:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B826B000D; Mon,  8 Dec 2025 01:29:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6EFE6B000A; Mon,  8 Dec 2025 01:29:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C2EBA6B000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:29:55 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69710BC192
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:55 +0000 (UTC)
X-FDA: 84195328350.29.989838B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E8086140007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Gm/vBl8r";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGTTFAinzA+km0HhJSP2jFyDjR8PXWjQm9Ugds3hOu0=;
	b=gS50pVH+i/u4CTqlIXvvaUmZdY5APCbS1RryyZ7gMhGXK8KdPZTNrrpqryw1nNpXAfJjUU
	0biFkUJ3HI1x0FFj7rrGu5tHPHyFIs9+r5iz2SInwkWvlK+qFP1Qay64eHOyunRqhZOYRu
	1NJlPN9WDAyF2tzqNurud8sdKaXCsPw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Gm/vBl8r";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175393; a=rsa-sha256;
	cv=none;
	b=Jy+4T23XBOas36LornkKvAkF7FugFfs4eQbdrcmWN9NnddvVQZAwrwv9A9ZdXod4fL9o0i
	uGzYE0QDW4XpGL5tjJVa1ccyREq6l438ZwPUdbPRWPTYACy6DCqAkey18fkb7JPH125XeD
	P0GzZXstWL0beRwDjDPYmGi5qOSgukM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6335C600AC;
	Mon,  8 Dec 2025 06:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F2AC113D0;
	Mon,  8 Dec 2025 06:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175393;
	bh=j4VCJvAbCWiJF3GzXaegxyBFq9+F4EGOLszAHpMh12M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gm/vBl8ryD/sYQZKtcgb4nfb04AD2Tc1c7lyP0l4Nu/jnTmgwOeYH2cYgRSGJSjib
	 M9h6V9GsqI1I/5HLfrYo7B5zjiZF4Xq9PQwwwbcYSChC3J1YdJLhPM3U8di0CQKlxR
	 T0MJ7ooHrdBDEpMRDrL9Apg4NQq8hHiGXkdCoFXb8XYb+wCQKipI5TWxFys7CU4FG/
	 3Hf6pJAzXORV9w84y3Gew1Tmsggpxce/DuHwn7iLtacKNq3ubWy2Kg8o8jMqsd5VlG
	 PH88VLVnB304si86+tDirjCVtIvi8KEZ76LRsQi7gH466ZQcDTGxzRxBlHO0vwlv3V
	 bCNZxUC5gKuvw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 03/37] mm/damon/core: commit damon_sample_control
Date: Sun,  7 Dec 2025 22:29:07 -0800
Message-ID: <20251208062943.68824-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k1hhduruoj3fp73r179nxspunjeqq1zu
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E8086140007
X-HE-Tag: 1765175393-257444
X-HE-Meta: U2FsdGVkX18FHOUw9soH0XfW8E+S+9oKoLSIGlHKZD7JcSqJVdfQod2jPm/hF9bhPG0ixLGD09ssadsygkTHK8pwbjEZLR4pPnkMcwkH5foo2kcXbj2AlbA9wXEoEAOG58Wlxp+gLXUIsqMtLvZPgrZ0lx+p8Qoh6VaodGPX23Gpujn3ortCnkHwn8fA9kmso8dCwW7pi5G4gPbWytHDy5v4x0iiEvJFKpcyVK3iVdntseCC0RDIGTkiu98CwTXY9NftG/P7b5bUiBiI7u6Hcu12bRB60dgOu03fG+Z23BtT1Qk/C36dWmzJv+j1xaXHYy77bNc/QdjSaFAKaTwEmC4ZtHOMl9eZhgZdEpjEB94CEEhNtR1EAO3PUlRQfqLeoyT6GOb4cfGKOZu3ZoHJGObE2jiidHrtT5UpTrNy6YLNsRw7uAOPSBZiD3HDw2d7GbsGgsBkJPTww/Y3ZqazbvAeKgbh9HBKpwQFJRxU7WdZV2WcTJ3vb7Jw/8t5mu/lLJ4CwajM/WQJX10PUo4YbkyFRnr0zTx0oyjvLjdiHENsOHMF1lXgWN4OoXIbAcdSYwkGlDyqBJa1bMHnQefmF8ljIgyF4iraGKUNuK3CusFHkfDaaMiskqgvFVKAzmfizGTgLUmaDM6pxXbQZmUa0sdTFlk9TKxJaGd6vE9T71EZro1hiYhYbmY26iTJO5LY8lq0vJWlJbMvIKDhye01I72la5aEUVSqHDkY4/ABpWSyX6OJGofMuak9XY6n4td+ZE03bm25EXDaA+f4EoIdVAETer8vg2KXGwCK/cc0mDDjDeT9arry5h6qSMnG7Qif5Hz2UmLAQUf9eX9S0OpEd8D37QgO0q+hqaUqhQpBYwJ4wn1Oa0qwKU/IdP3Ccy8/j0horTcTQ6GyzWnBu9EqZBBHFHrpxgziwf09SFwqshjzNsjExr/yVpWE/rpg0UbNpxwz2r+nkJV6pCoLlMx
 Jf98Kkag
 SOp2z5h5BPm5EgMLu1i7zgujbufgz4AirF/CBrbp6AYUDeHPYDRjvs173nrO/HijtojrC9b/T7jOk9w6lzChGp2Po5mnh6Qzb3ptJsPdkR8WCfZtIKCgYKFkMYEfhnxamXFD9kobPU0oorpVUFD25i4kdS1rWRheV4Bs4rudSWLlq0mjXsJEWNZjKdkQyC0busC7YADiB4dmfKaMkIuMS5uZl7mYqSLbwjH7xBIaUHeYwpWNPk7OnQohma2vmULAvwVZTzyyBEoZTfUtiBsAPHxlU6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The parameters for sampling primitives usage control is not committed
with damon_commit_ctx().  Hence it doesn't work with online parameters
update.  Implement the functionality.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7abd8c550c60..89305d42e116 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -559,6 +559,8 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.min_nr_regions = 10;
 	ctx->attrs.max_nr_regions = 1000;
 
+	ctx->sample_control.primitives_enabled.page_table = true;
+
 	ctx->addr_unit = 1;
 	ctx->min_sz_region = DAMON_MIN_REGION;
 
@@ -1242,6 +1244,23 @@ static int damon_commit_targets(
 	return 0;
 }
 
+static bool damon_primitives_enabled_invalid(
+		struct damon_primitives_enabled *config)
+{
+	return config->page_table == config->page_fault;
+}
+
+static int damon_commit_sample_control(
+		struct damon_sample_control *dst,
+		struct damon_sample_control *src)
+{
+	if (damon_primitives_enabled_invalid(&src->primitives_enabled))
+		return -EINVAL;
+
+	dst->primitives_enabled = src->primitives_enabled;
+	return 0;
+}
+
 /**
  * damon_commit_ctx() - Commit parameters of a DAMON context to another.
  * @dst:	The commit destination DAMON context.
@@ -1278,6 +1297,8 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 			return err;
 	}
 	dst->ops = src->ops;
+	err = damon_commit_sample_control(&dst->sample_control,
+			&src->sample_control);
 	if (err)
 		return err;
 	dst->addr_unit = src->addr_unit;
-- 
2.47.3

