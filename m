Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F269C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 17:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8769D6B0088; Wed, 30 Jul 2025 13:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8553F6B0089; Wed, 30 Jul 2025 13:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C496B008A; Wed, 30 Jul 2025 13:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63EA56B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:20:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17CCAC042B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:20:04 +0000 (UTC)
X-FDA: 83721593928.01.383962A
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2F1A28000A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:20:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ijZi0neA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753896002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQ2a6DHl3z5np980mAJ2X98cngKs2SsQ+pYCL8WCFTA=;
	b=5FckoFzkdRND5HP1jBsToDGQCyT/ICiVoAQaKWxCWpzO5iNW4YesyPNKULJFhCLEwyyehm
	RC1D6ONyOcR3EMYhoP+LpiDXaaTdU1v7zdD0hnrF05pLGlVIS9sF78JRvI/xST/heZEI1c
	OvtVbXvdtWg9T/I4q1gqfD5n0jA6RU0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753896002; a=rsa-sha256;
	cv=none;
	b=P/2f5JazdoNpHOys3JOU2Y4YLxZBFuJbrumltuepzFyjcrfRDu4HdblUckMWOSswfMRnCl
	BzSw8b0XY0TiXIbEWnD+diSvCP62cbZ+2spm4G+2BYf6F4icS6dsfHkhPiqkv04Dy58yP1
	DZYG3iZ2HLYMnT3tGuViuaLkHEpUnmg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ijZi0neA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45600581226so535435e9.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753896001; x=1754500801; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQ2a6DHl3z5np980mAJ2X98cngKs2SsQ+pYCL8WCFTA=;
        b=ijZi0neAMfkxF9KSGJII5J4LdPLaoivWwK0UiK9Gna+HYiOe44EAMkoWjYpHtqd6sK
         jOplbiHd1OPnPB3aTIuneVJYzwFlMXBgMj2ceTbKh/mN2+IevT1OpI5ERweCuKjcFqsF
         07QZ/9Ss6Ag6KDRW1rHvFGlyM/1TQ2qQk7tfeu0l7jRhCubdcOp+Ig9AHoeR/xcHrnbu
         XzWnfVJJxVFskJTBsLf6J/XrRhAf9ym4bH3dYRlMlViJiBQUsDMMz0SlNWZ/BfasDxAf
         xE5VtcjJunms8B9i50R8hGbKds0vdAqT0AbFvcfaIGFsjkOoz9QOFBMBDv5ci6uWjhi0
         +xyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753896001; x=1754500801;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BQ2a6DHl3z5np980mAJ2X98cngKs2SsQ+pYCL8WCFTA=;
        b=Dq4nUW8bWTCXa10KQfeP7R1Nw2iQkwj9knr1S8A+VDZeBc+xc9DHoxcy/itJskTDiD
         hM87LYxmnXeIyZaflDybHcCVNxlc5Kd64Rq22CU2GV9nvEJ9l4WHvUQyQZYoY6cx7xEp
         uT/YYOn8jZGrd9YJtv/93NK3obk4CUnP1rC81U3xldm+hJzGCm671X8G9TO5k5GlYZtD
         ra3o9RVrOCo3quq3pcx9OJ7b4h/2A1lRgS7i8aT9RDnhzf2KVYgSgrPVT9CV5qgk1dcV
         5ciz4M1GfUtu+wLsyg/SSAM+Fm/tfND/y6O09lf7yTST0CQcRhBT7kzB0urbctR5qXq7
         l4qw==
X-Forwarded-Encrypted: i=1; AJvYcCVovQ6RhlwzkqB29GxXKXy7eW5gpsrQoZRd5yhbhkFCJieJNO4G2J1+LDNWEwGyvEjczkTAediTKA==@kvack.org
X-Gm-Message-State: AOJu0YxFNc0Qby+GDSto7l0kPiZuTW4JnQVL56n8RnPNrfg99YIWKFEB
	N+oPKkb4Hz7mCVJYtCoik54utER17XT/j87E2NlDb5n1wX05fUPqITR4v9jIbBbwJLt1TA==
X-Gm-Gg: ASbGnctV5RuyIOj4Dua+OclvPtMHt+YqQTGy6wr9m69w81hhprTJyLKCtjA+UlmPDyC
	rdsOwt8SIoyS6uYpvQVkJkim/iRs+hzoagxvGruEzIakBfGng/oOaDRZUYdMkU13VmoKy9QKFLd
	yjJz69WHISvAGqSNVjRgqgItzI6UpWlcYYjXdP8DjEz8ve6dqdBM/oQOOz3yafhBINhoh5IjuqA
	cCIh7asFKvHGmxHbiDysO49jtHYop0TrsHHvLXIxNcX1iM0YYmQKOrFPsIw9NEt08usdCmvlC+/
	5nMsyBkmNXRIn0+tjp7T62qZBbt37bYFTcUVWeoDmHR2mQygmUuhJgwY3Z/yFN9To380HCgyLRE
	m8dDe/9qcNNz7nYA=
X-Google-Smtp-Source: AGHT+IEHjDXRiZsxpAsVevWpg7SdTkCsFSlZa/tie3LLi8D0AnSzcwlEavp7Qck5/rRCdYnNe8zb1w==
X-Received: by 2002:a05:600c:8119:b0:456:1c44:441f with SMTP id 5b1f17b1804b1-45892be164dmr40383595e9.31.1753896000435;
        Wed, 30 Jul 2025 10:20:00 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:40::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953cfcadsm37360005e9.18.2025.07.30.10.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 10:20:00 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm/damon: Move has filter to ops-common
Date: Wed, 30 Jul 2025 10:19:55 -0700
Message-ID: <06734aa15198e542f9defbc1d29fc0731671c3d8.1753895066.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1753895066.git.pyyjason@gmail.com>
References: <cover.1753895066.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2F1A28000A
X-Stat-Signature: z7ckoniucyrctyznimojhatgrkm95xii
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753896001-695013
X-HE-Meta: U2FsdGVkX1+2nmWdWR754BxD4HscQZHZzHxBV6wtWus3lS2BW1oN3T6rriE4/nXDaRPOGKW+n/TRQ9bXIgJXtIlc/WBv/a471WJGqhn8iZwyXOr+4av0bx3bKNhYH/cb/Zt2Fqyor0RXzqqwcysSSuYroqsTWqByrbRmMseaqdeCBDvk328wDrsVhLFD2DZfrf+0LImE170u+vYbUzIsOwHnILVLLVrkTlYhPOXdmeGVxQGQPJuym5PbEwKQNCXf/9Q97jSU3/D53fPsz6lAuAKNXcBl4Ds01iZw9/GEdeUMi7L9zJwHXta+fv2MZBnGyDXF/fxkilv6gIWMi9lqwqkfMQoN9U1EyUdY7J004Hqpi5KOeniCNI9qYzjUUy9SrI+RmMb0zJKEpyU1ywcZvzVO5q+PzBz9CBHQFobW+BWg/+tQD9gT7UwdRCrLdGplkxxKwC9/MewRLY7AqqRrMLRkqjkArIFBQfDUWZ0bSgGALuEc2hUoypmB5MK0QhK5EAjYokT27KfUjU73XjfHPPsG8Tv1+WzUq0hwn9AQvGNbAaEmBEFeFwXjL7xjPR00tvmxpouxv+Vl49uXJzoR5x5vbqIv0J/UA7tl5ed1mqWW6hmgijd4H6PNKHFDsenAag2StM4ZD3ozMYCrFoijip6QOr8gUs46P+6aKO8L0onOKTvh390Un//u7Jtji9gRfYje7nmMKcN9M9cSojmnGDHoCe2U2pncrVHZMyxKRRh59wcSTlhAVQC0AbEVQunov8dnadkCFF39Kf/AP9y5oh5ofb9HnFYka/Oqmi2jM8evazj75EpguWZMLw8dONG57POyEu8Zt/bu1lAs8Ml81KgYpfOMHx5NIR33t7pPpUaYpwXuypq8uTLT8Xf9UWGB6rf+LeYMhcCaBueOw5mYvJRlhTVNdjcps5L4C+tSGCuF5euhTrFmfIlIlaIuOFXv2Ng2a6dY4635wwH0ciJ
 iCout/CX
 Niv5CPSbDYbFj9aTEhhJvlJknFCUzlIE5xqRFEDGXsNksfcbB3SYwzBaJvG4ozOqHGwCOaG7Qo5Hlx2rPkuJcIpK0P8/D1Wryxi2KUpYqxd8ERzo4UL89shwwte+ZaHxqn9TIwajx2VmeDIZFIQdP1e/tAzroExYUE3H7dh249UTxIAik0GPRLdyF5W/uAjpkNSGUA1wVBs9OPpukLxQFySc0mn3/hwws1wwgKtMfSyt//5Xan8qOJ7Rq6PYdXOXdVpFMy1UJsUHjMSXgt9f6PB2GqBsdHI++oGtO5f7UG4k9nFD9+Zx0k6mhMQAvxDudOo/6L0bPAFVLPVKcPr67xHgP1vHgBSA8ag+oSqONpLzAvEaPs5rA8XXSDo+HyY9hDz0M6jaPR4nXLSZUdb/CWVAnFtr/yQmSYDlGy9/SyEq+13li+ef2gCnhPICPthq/87OWAwHbrmo+hyUczm0UFgH+JA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch moves damon_pa_scheme_has_filter to ops-common. renaming
to damon_scheme_has_filter.
Doing so allows us to reuse its logic in the vaddr version
of DAMOS_STAT

Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
---
 mm/damon/ops-common.c |  9 +++++++++
 mm/damon/ops-common.h |  2 ++
 mm/damon/paddr.c      | 11 +----------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 99321ff5cb92..3ebfa356ca46 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -412,3 +412,12 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
 
 	return nr_migrated;
 }
+
+bool damon_scheme_has_filter(struct damos *s)
+{
+	struct damos_filter *f;
+
+	damos_for_each_ops_filter(f, s)
+		return true;
+	return false;
+}
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index 61ad54aaf256..8d5c5c7631ac 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -21,3 +21,5 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 
 bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio);
 unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
+
+bool damon_scheme_has_filter(struct damos *s);
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 53a55c5114fb..daeceed981a0 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -262,22 +262,13 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
 	return applied * PAGE_SIZE;
 }
 
-static bool damon_pa_scheme_has_filter(struct damos *s)
-{
-	struct damos_filter *f;
-
-	damos_for_each_ops_filter(f, s)
-		return true;
-	return false;
-}
-
 static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
 	unsigned long addr;
 	struct folio *folio;
 
-	if (!damon_pa_scheme_has_filter(s))
+	if (!damon_scheme_has_filter(s))
 		return 0;
 
 	addr = r->ar.start;
-- 
2.47.3


