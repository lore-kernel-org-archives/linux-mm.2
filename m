Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24BE5CAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF708E0011; Mon, 15 Sep 2025 23:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8128E0001; Mon, 15 Sep 2025 23:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705148E0011; Mon, 15 Sep 2025 23:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2EB8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:23:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 091D4BB557
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:23:51 +0000 (UTC)
X-FDA: 83893669062.30.5E8FDD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 543221C0006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:23:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nxM200Xr;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8GrgQNMe4jZq02LkUqlva7ovR/9Q3/pfIFBd/OgBSI=;
	b=hKvhjaWZluug5xbcvaeGXnxvF//73fqhpRJyv2W8JvkvpBHcTZTH8eyX35Rw2PU5Stp2rm
	zx0bNNQDZ774SJzSO0zOkp/DxDi7JBFo24JskEnB45FxziC6fSkPi1QcWb1Ve2ql4EclYy
	v1gDkEJu+zwyFzIUGSLWb7Psd0n19io=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993029; a=rsa-sha256;
	cv=none;
	b=3IcMYQMRnkl8kpkMmeUyV+xrRMyRUEGFBnuAyR6oWqbVwufNFu6DR327u9IxUZxSD95NG2
	Xe9cN9r61i6+3qZpSnbLAn5AR9FBB+5mNZBVzqm4N5Ztc/9JYF/8xjub4RMttXYFgt8zdJ
	O98kA+I2jLoDg7SZGv71/nVXtplaUro=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nxM200Xr;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40B0243C27;
	Tue, 16 Sep 2025 03:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0910CC4CEF7;
	Tue, 16 Sep 2025 03:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757993028;
	bh=N/t9pkNAmKhqz/ieZXdyuuPFRZhjYep3A6xEPihZclg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxM200Xrc4NknLj1gtWX+oV2pwtyTatyhS2H1Vlz9g9OF2Tu8mzvB2FG34FF13Xq7
	 6jVSvEYjp7ph2Eb91fkCS3MOlYFFv2YHpbRZ5bdoNcdYqD4O3vtywWlyQW7Qc+lheO
	 jLPvKkIU15UEO4EIh7ZsZd6MFcTvJ0zTjPFEwXbyTht3JDWnXSzEEUViFNFIeOnwT4
	 //a421l2H+W6jOTmRAhCAU4LpTUgtTSaIJvDDc2Stwb+CDftA7hyIf/SOF4A7IGBJL
	 CDRosNOe+GaedyvylnHuwXVnX02mCbOQ+t2JI1D5LBvO0nckzK466iiCimykr3XB6E
	 IJrcr8pKQJy9w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: [PATCH v2 1/5] mm/damon/core: reset age if nr_accesses changes between non-zero and zero
Date: Mon, 15 Sep 2025 20:23:35 -0700
Message-Id: <20250916032339.115817-2-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916032339.115817-1-sj@kernel.org>
References: <20250916032339.115817-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 543221C0006
X-Stat-Signature: 3hc94a9k1as9so6yezxoec9s48qu36qf
X-Rspam-User: 
X-HE-Tag: 1757993029-480781
X-HE-Meta: U2FsdGVkX1/E7wQm64Zuyk+ERBSZxwcNtKOoLVlX5uqVcVd2xDYndDj7StxKyaPYinwXzCe8TWfje1yvt25ki4WMwrEzorL+nAis3dL1nMbUFHEw4eWY7HnJnMS0JAkUUjW1IIiVjLNTpJpYvEGHk6YF1xHGP/FVHtzL78p1cca7z7mD1c00ufn/J3ynNbDy1jQ3nC+LAiNAN2B2fvHWsEHLQTJLUAB4GWnlRaFhUaTHIvmIQywXvcKO3CEB88Sr96Ce+m/B16pkAZVocmLlTSuAsoJVZojahWnJa7NXUd7aNgu+oQb/bvY5S5c6mMfA71+IgAO9vM6j3v/40vtQl3buUUkoQnP9u6Q4K0Y4GcoNNOAj9EAImT4UEsH/y5899YuyyshUO+LiRRY5VoxzlsbDNpSP0o05MSTmLNaLbPsazDwa/WmhnYeMTGdKgkdJrB7oAM9omAk4/Gp9bQveF++sEaM4JqRmR0HLgPpX9ZD8RB56wTP5CvZC6n2IHrPnofLcJgWjqjYRQlOa/tATcgz4vTOs5gJbYDHFRi6KAtfr5H2HYAya/eos1fG9qS1NyWWC4CiW+Dx7hmpFcnkdoH/X0qO4Eh6BUl4N/dQVmD/OVAgAVfopDlA57cdcEN4u8dyL5dwkgOCgqE4vFlTjn687id9elRwY1oYtRapspmOp3qZoUFQ6pT8cuO8yPGo6FU66+4AhtsLXUfKoTXw3RvfYkQ4qZ1hD+BWbZlR2JaRcGB+KlRPZrxP1LEAOnbYDvvj0CZ4sycYprW4tqXmMaPZO8NCe3TonKCQC644AWATiRbfYfBGlPbLAeYr9297OrrDwSpWS+mUh7mxEOFFiFFswkrgCJGgo/9+Ls6pzwN8BLyvqF5CD7g9Y56/X8u75OeUhakgWPPkEA+7h7H4B14c8/UjgiT+NmYNnIonkxqy2+IirxwNLXhYmt15oH2YQqfHr2kA3tXuT9wG0Lim
 rTw8wFGk
 LTiyxiKaisCfPZeNL/ZCqg/GHDb5ocp8NkaS5465qmmyEkPgTmWYgSy/MWy1DVY01UTm9K3mi72yreoGsKSGscVhIAOzXI2vzjwEgRGzDaAsQhtW+ih9jqzbthXK9ZAWcxTPxONIjrtayrHUCsX5bcFXk40/nNzhG2UYNzzjhG5HnYn8eFHVZtbomhKqwsp2NIU7VmskygyKTb6wUwF9wDLpKaFVoSYQJjfN9uIpg/9XU14IRCVzrpHs9XEEd6mH1DS4rW9cpVvqWXlNkWVS3mQOJwiQOfkPWqaMqg5XfvNTdInY9GOHUPTrXaEQ6Ru0OlnYpQOIZql/b+stcFCKtvE7+rTEDvBT3pxh5MXi/az86sMdUWH85eQhJcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON resets the age of a region if its nr_accesses value has
significantly changed. Specifically, the threshold is calculated as 20%
of largest nr_accesses of the current snapshot.  This means that regions
changing the nr_accesses from zero to small non-zero value or from a
small non-zero value to zero will keep the age.  Since many users treat
zero nr_accesses regions special, this can be confusing.  Kernel code
including DAMOS' regions priority calculation and DAMON_STAT's idle time
calculation also treat zero nr_accesses regions special.  Make it
unconfusing by resetting the age when the nr_accesses changes between
zero and a non-zero value.

Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/damon/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index be5942435d78..ff2c6bb30621 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2261,6 +2261,8 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 	damon_for_each_region_safe(r, next, t) {
 		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
+		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
+			r->age = 0;
 		else
 			r->age++;
 
-- 
2.39.5

