Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A91A7CAC587
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 02:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF3FC6B0010; Thu, 11 Sep 2025 22:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56BB6B0011; Thu, 11 Sep 2025 22:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 994226B0012; Thu, 11 Sep 2025 22:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8B05C6B0010
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:39:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C7621DF497
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:39:55 +0000 (UTC)
X-FDA: 83879043150.11.8A8DD5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 903751A0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:39:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lSFaup3y;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757644793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YukrW0BZuidvJgvF5rvbxOjyzoPtvfE+SbPdq25lrbg=;
	b=3aYDWLHtY6+MBaFzTDbwUwep23xBFB6rGPFBu9ZiUV/ywNUBx946j5u/v5B3SqDAyVzLNK
	a4JeZUV2Goacz5nG+Hfc/D/rs+rX7z75gsJiAteoTjGdrxgFH2lrzB4S+rgBwRNRl1JlRq
	FeftqjcrKh57UmUnkXa9iRVDyzx2ZeE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757644793; a=rsa-sha256;
	cv=none;
	b=DiPwXDyGIwfAZ62MUC7rc3W08DGMKE6EBwmoeyFGxqYovO+qBMRXGHCAJRoPSNVckl4ssP
	+xXRMrtV/luKKocvICU51cySo3DRX0hJ1CLfHEzSdmClJtINI7qnzpNM6REIlb8XCU9lWl
	kzwGEOzNijvqAdQM6eTroyOtCYYQa50=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lSFaup3y;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AAF6450F8;
	Fri, 12 Sep 2025 02:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA746C4CEF0;
	Fri, 12 Sep 2025 02:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757644791;
	bh=X2mkDImsPjBINJD3elmssAm/a5Bzpioz6UMPDraKGoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSFaup3yhbErLVVcQ3JyDhD3QgThJ2y/eTwsFKLs0Ew79FKwirbcC9NP6wWR0A1hv
	 td6a3pMnN00+mIowonlZID9hCkErNLHCUObHEwyl0AEtufejVPAUFsjpmhXYackAQh
	 Ets31DFr9uiO+/XuTvwzVLG+oceoOfgjEF8UDdsnVHaZOVA0rt3bD2UtW4zLmS3EZU
	 IxB1XsFYXHOFTaXEVwyH09yiN2Hp0Czb2WJpSSqYgQH8Du99cSTlkr91uN8nrAwsSz
	 IaPUyA3pamU3Z11yLLN1B9XLq4fGHxuJLCEyEWc+usaiPyNERwenytHnXtZ+Ay5Lv5
	 lUneBtoIis7Jg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/7] mm/damon/core: implement damon_initialized() function
Date: Thu, 11 Sep 2025 19:39:40 -0700
Message-Id: <20250912023946.62337-2-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250912023946.62337-1-sj@kernel.org>
References: <20250912023946.62337-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 903751A0002
X-Stat-Signature: jukfchbeyw6kjak4qp9ghrs7hnonsyjy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757644793-794401
X-HE-Meta: U2FsdGVkX19QQhtZkx/s0Zl0rgWVDHD9545smVEco6yxN8O1rh/Q+XmWkQDe9QVRUS9LZvNIs36RpU5FCWmEuIAwbS1NYSvmsqVH5DQ97RKuyNgxrQYYkt7BtFz1a1MFcb+NkNqH7NjpgnmhBaqbrb7gnW0V84n4G57a6sNiGWPr6foZ8NMdOFMwGRvl0M8xf86ZD6FDjO6U14jPaG9pQiUG52wR24N/BXH3P8YogZr8foq3GjIPUurc10YEzjlGR/WtksWpL/OF6hQZZrQkh8GYCIuYTITHGHEfTj2l/3gJezQnT6XTSZNQOjM8vQsLEyUwSOOTcjc8JXr+9Kz0HEt0TCwyLEVIzOKYp1J5Kok9Bm+5vLTfWF2noTQxwCilCPt4Xlg8HtlgYeIyf2kf6xZvQ//7bO0JK4AgPs2gJmk2KrHi/UkxwcP3kGQPOtWr6XcIKgfIPQceln7ZUMn+bT5NQy8Sjz6L46K/GMIfgsjaKVXxvo92rAcgPyK6FXQHZXS/r0VHJ3b1atRugzk8N8+SpE21Q8MIRLV61/Oe0kOTA1eTUlr8TQggVUaIjYb0j11gfWdtjHww6rsLBLoNDuEWFQT9g7LiShAXa9+ZDbl1Xg/K9iNToLhrq9CkAuEmfolBSHSzTfZRvagl6tqMT0p+EL8Qlu2Fy7BQWvALJcG3Uqd5ImQuP6hqe5JKhLqFcsotxZwS80fNlFY/i1H/niLyoaL0HLB0cPU7iJCZoBdYuaeWctwTgHLeVIBN0FzcvJB07SaA40yXgeukQQYESVLX8BtrL5EyrXt1mYkltNW6P+Q7Y/CSq6aTu41rEg7oQgmcGP2dTVLB/uvhzf7g/+C0IBkr+8FExrgN9cQ/I1MBUM1duWdbOHD8iNiFqbZaRMIxNMGfEhnEcPEVSa/11INAM4SVPV3qwFMi0JGqWST+VUaEDMtF8m2jSM+t40fY+8rqKSenpFCaRvxP2zf
 bzjm/SIr
 Ce4bitXCcjRst987lgBwswxnHtIEyjyV1pKvVbgtd6S132E5pDBWKlajlhExFlAVDI5ejrj9h6R5dRjrGWvwb213FXzQChoIv+eRVD1Y2gQWjo0UMcMniVrLeUbTx5NT/BzxO+FNArG0bct2dbL7Pzp/w/TT5qdybofa9XG+QHTGsXClCzT+vLHwGjFpK+vrS7tv3RDMd5uWzM2YtPSnsp6v/ob5np2jGHQFaCyzF3mgav68Wys/SgiP6wWgvet7hgByXnvVKzLxa/ifwg2+Obwgs4wH7i+9TZda1RYcc1YHK/6qCbcQxGRIVkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If DAMON is tried to be used when it is not yet successfully
initialized, the caller could be crashed.  DAMON core layer is not
providing a reliable way to see if it is successfully initialized and
therefore ready to be used, though.  As a result, DAMON API callers are
implementing their own hacks to see it.  The hacks simply assume DAMON
should be ready on module init time.  It is not reliable as DAMON
initialization can indeed fail if KMEM_CACHE() fails, and difficult to
maintain as those are duplicates.  Implement a core layer API function
for better reliability and maintainability to replace the hacks with
followup commits.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 484b0558f426..0f012b1e39fa 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -941,6 +941,7 @@ static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs
 }
 
 
+bool damon_initialized(void);
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 bool damon_is_running(struct damon_ctx *ctx);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index f32034973cc1..38ff417f4eb9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2880,6 +2880,16 @@ void damon_update_region_access_rate(struct damon_region *r, bool accessed,
 		r->nr_accesses++;
 }
 
+/**
+ * damon_initialized() - Return if DAMON is ready to be used.
+ *
+ * Return: true if DAMON is ready to be used, false otherwise.
+ */
+bool damon_initialized(void)
+{
+	return damon_region_cache != NULL;
+}
+
 static int __init damon_init(void)
 {
 	damon_region_cache = KMEM_CACHE(damon_region, 0);
-- 
2.39.5

