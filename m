Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0710FC88E63
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0BB6B00A7; Sun, 13 Sep 2026 13:17:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1782F6B00A9; Sun, 13 Sep 2026 13:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5346B00AA; Sun, 13 Sep 2026 13:17:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7A6D6B00A7
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:17:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1C4DC08AC
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:18 +0000 (UTC)
X-FDA: 85209394956.06.54E6A76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6286412000E
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i3theO8w;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBpdI9GABjSpbOSBeiuA8iViUPE/b+K1BLYoiHpgDDA=;
	b=KaCCuPB447JSu0f9G8iidtMSAxPdt0X7vYRceubE2DVMxzxNb54YpU7yYtmgKLURRPETBe
	YbGEv3SMCawV+xeI117xb2EeOSfVseizG0Z2Wv042UGCgGGEK5Wpb46Fywf5KDo1xl3KP/
	Inn8mzJuZBcY1eGMrzpD1TDMGgC6YiU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i3theO8w;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319837;
	b=PTENSzF4987yLBZAaV9NhVUzvA9EL2SUbqVFY9GR/99PDR3dsFId3fx3xr/wEBorgP7w56
	yGIgtXiPOOmvnWDdWaGrvuGD8EoogvzO65q8me6DeNbiSRcrqszmHVi1yzD0Bj7XGh9bAq
	4yCALlfA4qZDhKQ1vloc5KuhoRsO2hI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0339C60ED1;
	Sun, 13 Sep 2026 17:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DE61F00893;
	Sun, 13 Sep 2026 17:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319836;
	bh=MBpdI9GABjSpbOSBeiuA8iViUPE/b+K1BLYoiHpgDDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3theO8w1YobTHF6s/PdgEDvl2RO1oiaxzM5QTabU5Q5f4hgM09YO48RE+xK2BhS/
	 2PuETBuVcH7ddsdPJ1zFedK/5ncsVlKrMQiXz/YjPXq+9/OhhyEePrnBb6U7O1G6r2
	 /evjeSjdmRNl6b7X6sQrbgFIJubDAmmsb9H4YoE7p5O1VtOHLURdIP/G6TY3LLyhU3
	 IVeWc3L1J3huFBK7uzwLqnSPOt6arTQqBW53DKUxnjmgiH1BWhxYMhKMowA9UZ5SsL
	 hJG+jWq5t3qz2S0bWlbnDlrUntTv44zOf2oskBEz8Qn8dAtyqJR7XAVcY3kKa7lM5P
	 GMUHq6z+wFD9w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 6/8] mm/damon/sysfs-schemes: use switch-case in add_scheme_filters()
Date: Sun, 13 Sep 2026 10:17:03 -0700
Message-ID: <20260913171706.103052-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171706.103052-1-sj@kernel.org>
References: <20260913171706.103052-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6286412000E
X-Stat-Signature: 9qhnibxxu8rbfhmff47ks6jxckmo7sg4
X-Rspam-User: 
X-HE-Tag: 1789319837-526918
X-HE-Meta: U2FsdGVkX19/iUpUlpEVnkvHXtpoRMkbRHGU8rEeFIqf7KNEPlmV3KHLbmYp3JNgAo2e3EgPzJR/APrBdqLx/PYs8jnBhSPinFXsAfrIO+Bl3i9Hqu6RvDAy5MA5yQEbCEXPNFInad6N/jIsDSDLgRWn7A2IBeNwPqIlQ3Hrk/KwiDWXBTIwAQYKWg0t0L5Qp54BeYsXaJZ9nmJXRiJVxcWdLPZwUQ9XsxE097aP44RfBGvva/ymt4JC7JkmXEa+1WoUFfYMwn8+1pp2ADCz3cdU7JN0410jp7acxSjd53oj16wM+OS1DikT98g/01P1jlXEEMQPZfH7fZeeBmBYpSaQtxK7geHWjWgomEkQkMsQo5cBibxu/BkPuzAZvsFlhEL0CEFNYUyeUbSTZO1+xva7tjMpwqSgPpfW1p3uxvQlWyXEfLL9fB79CPXlKO05Vvi9QkJrRDoiO3HyFiYHKghp0b+EUG3NNcYIxbPDVfa9cJGPPKSUh+hJ5ZvcMzGnVttqBjRKtcaJ61ulFRqEhEqnXFlkBLjE4947g3dy8flhMMKcVM2Nes9GoVDWPckY5UZpDM7R7Oi2EaeQ9LxSm6k6TtA4U9kbHmQ4OV53vAW75QGKZiW9vgpy6Z2b4H6C3QDAJkIg+q/dJ/B+PJ58kFp6XRPJKMHc4RTsSJlk+XkGtnW9EabJon7X1lwuqc2WiSK3Z3KKueCn+B114WTIfEyd44abqGk0RGWaOfpWhlFOUcd9MZl4R8kkG7uaQUyTH6/2b0+A1Ca2nsvfM+iKsqEiyjaKfnHWFkTRWGW5WKOFFXhJhNzOhxEz8NlpdM2l8t9AfiokKAJXWcEOr5DmLrbWWL9oyB9gYKZnmfn9DhCsTeCXlbvaRVndknAvXmwIWoZ9PJyBYWWH14qEmgV76CdvBC6Y7nqsWZMmeAq5WM2JtN8DF2iyduGU+3wtPdy8HlsT4Rf0juPtCb18lJ4
 fLcNVQL2
 2O9mow1mF/4I2/fnpIsUVhdBVEA26JpP/IK3ffhh0hHJJnfOSHiEQxsvF8784u64l2ErqHvBMvmFFEWK14kKptVW3xMT7uo+r38V0gXco4HeWeG5UsXpAkLJAfVj64SbCH++8NUJuMdjsdgQTZTEekaBQyrIzfmDgQxVxqPmBY+OmS8pZydreqpJYcVcecj+nna745QqPuXNmolRTfKDSnUq/9GcNne9AxSlhWMaoca1t/EJw7tZTJm+ruIB/xsIZNM4U2BduPo78zvot3Da4EnhsDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_add_scheeme_filters() has long if-else chains for DAMOS
filter types.  Convert the code to use switch-case, which would be
cleaner and more efficient.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index a4ec5d54cfbd1..bfb6f0bc3f213 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2822,7 +2822,8 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 
 		if (!filter)
 			return -ENOMEM;
-		if (filter->type == DAMOS_FILTER_TYPE_MEMCG) {
+		switch (filter->type) {
+		case DAMOS_FILTER_TYPE_MEMCG:
 			err = damon_sysfs_memcg_path_to_id(
 					sysfs_filter->memcg_path,
 					&filter->memcg_id);
@@ -2830,16 +2831,23 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 				damos_destroy_filter(filter);
 				return err;
 			}
-		} else if (filter->type == DAMOS_FILTER_TYPE_ADDR) {
+			break;
+		case DAMOS_FILTER_TYPE_ADDR:
 			filter->addr_range = sysfs_filter->addr_range;
-		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
+			break;
+		case DAMOS_FILTER_TYPE_TARGET:
 			filter->target_idx = sysfs_filter->target_idx;
-		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
+			break;
+		case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
 			filter->sz_range.min = sysfs_filter->range_min;
 			filter->sz_range.max = sysfs_filter->range_max;
-		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
+			break;
+		case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
+			break;
+		default:
+			break;
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

