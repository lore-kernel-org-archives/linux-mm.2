Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F70CAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6589F8E001B; Mon, 15 Sep 2025 23:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 630768E0001; Mon, 15 Sep 2025 23:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8AF8E001B; Mon, 15 Sep 2025 23:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5168E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:35:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C2E31407E7
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:24 +0000 (UTC)
X-FDA: 83893698168.25.3A49027
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 54BFD180004
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=orfNy6DZ;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AJ9xwY17HDI2crilk6IGqE7MQDPUgj3jKw/933aNvY=;
	b=xSAsleN27wjPzMx/KR2Y8cz3qL+rwdjfD9DdxifLXbF8GIGKrg0a2uJlnMqSequYVv4hWX
	59ABh6s34itNEZrlhwLNGBRomzC1wM4EIX3NsAhwgEB+ii0atX6HRpMDUCK42w0YBir8IH
	i9rPQgYzAo/UGDlXIXkkSWUjQyhg2qE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=orfNy6DZ;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993722; a=rsa-sha256;
	cv=none;
	b=qpF3mMYveV+F23Wj441M2SZfNOloJkgYpPDuFrjCd+3VYqt9o8fH0QP2hKKOQucZOuz1mE
	sYfCbXEik486yvD4Nds1VPMLO52aRQLWVmaQbXBwFT9xtbJyx09ImjDWHnHhXRG5htitk5
	+Pqf1ELUS0c+v/jiq0+v84SdthVkEhE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A19944386;
	Tue, 16 Sep 2025 03:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF489C4CEFE;
	Tue, 16 Sep 2025 03:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757993721;
	bh=jSyChxhp2q57cPUh41M0fEVHkYfztaaT3v+fVBcDkyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=orfNy6DZUAp3GECznrx4oiXg/9pB061b0r3o27o0f0ZJscgUtwEI5JqwK4Co/KrXy
	 yaNtCi+UpfwZqqW7g3XqYNHTSYdu+FGDETrxw20d1UMeMJjxTp7aRn+0SFeJKcyBNT
	 DzbDAeK1n0Tq9I1owIgh9eRtfJeUI0CjWVO7mCBs8sW+pob8csaBqTczIPe6SA93UB
	 ioAz63GmsdAXpimgbDXPlAXHFU/YXLarYZFB/fv6SKznE9dmDVSbXqaeHZz6dflQBC
	 rxZe4GjdLtA4AyGOqR48dJqjpz4nsBl9+DWt/U4ckeQDw7H0iLIIxlq4CRFaBKw4uJ
	 9pycIiU9R1Ilg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/7] mm/damon/lru_sort: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:08 -0700
Message-Id: <20250916033511.116366-5-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916033511.116366-1-sj@kernel.org>
References: <20250916033511.116366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 54BFD180004
X-Stat-Signature: zins63orrgk7owxb4zuadwbaeoy6aiyz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757993722-858842
X-HE-Meta: U2FsdGVkX188Hm7CMPOqqEjzTv9qFfZ5cR7Tdk8/KjCVkuAXLvthSe9PJQeZMpj9+io2f5J64DWhBx2NSf/dvBhrvL/+x9Uj0vQlhCMPziEwPE6QMKbyhrBdRv3/wV3bQf8IvW+VxcPhgCOT6S8yfDhPyMiFEcd3WwrSfAgiffvDlAqPWcLeuOJvCZeG5voJnAobPWquMSQBco+J+sn10x0Nt4kkUW/UolJKlHRRf/UAhMKva98+gEOKMumrWPdeQGTzdEFOplDOtKPo8+p99dyQMEwSedXihwdNyDPIv+KkBTh8zpKMNgjfKa7zrLoqltLonZyRV5xdWyMujmPyxT6fD6zvys7Ziz/JhFA18/jl1ad26DQjVW3WNN6w1kw2ZImTlT/xjrVvGApI2e3+RFi3i5ak7iegEOvjsde7hEZOL3jCCYo3qv6YBQwpGJcoty9/ZOsQAD63J1ZPdvLNvcITIHCeanF5HPnilZwnY02MWtzd/vNIR6+wSpy6hjwpKPTyKbDDC2gg+K3DKvLi1iguBQ9mkVDpJgmaWJiOTbHs/TPr+3XPpzK6q/ympdx7nHdFvOEveG8vJvJQ1pRmNb2pSnM0eEJRo89kUA8vfjJj+vIhqZH6d1Vz3Yb/VE4Pm35d0NbhLWcEPpto5GALWKztejmAKwKrgvruZj7R3Kw1gfO+3U7gOtGZmcg9DjXbSGnXceYI/mPS23qyb1VxK6r4460LN69TabO05/0nGC8+MhVMamPb0Qe91/ymDLDAn3e2TrMgQChaEvUOknmfpDe+LTOoBTrpffBijtXxMk8w/3uhI+fVf4UV7KKKRnzqU8DzhG4VFlL0LFpeDISWtvnYSEGLo543adztcWSBkl+1JLnM0bkm9lEZVAuXGFCU7nX93C5SMG/+rAfM23TK4DXVom9EnkO4pu0VB6hLZRvBljmlD8UGZeHU3DVrLZIj3VI4D0RKYTv/H1O52tP
 SJWhDTZt
 GV6sKf7ScfAyvEMaGVB8/Im0dYES5/hxE4PxvFaK/FTo5v6fyfa88HGUxZ4Ei9FZoyIgZX4IHFZcoHBMIfwZH8BD/ROssEzCJESDkdImW3+95j4ToGFyEFF2IZwo46r3FD1HKybYAdz7dzwartw5mviImrrILArP7dDl6p9yCMgwBn01bkQj7e5BZob77oO0nukmhqWTEza++GT/7/PTke1mPrAiDJwOtQaKc4SVERPrFgD4zJRW0YoZRPakz0RSmHz+3rko7ppyL+H8sBRJQgvfo2ZSEHyKdzYINdzB0xfio6HXSYom6hlUODA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT is assuming DAMON is ready to use in module_init time,
and uses its own hack to see if it is the time.  Use
damon_initialized(), which is a way for seeing if DAMON is ready to be
used that is more reliable and better to maintain instead of the hack.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index ab6173a646bd..42b9a656f9de 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -345,7 +345,7 @@ static int damon_lru_sort_enabled_store(const char *val,
 		return 0;
 
 	/* Called before init function.  The function will handle this. */
-	if (!ctx)
+	if (!damon_initialized())
 		goto set_param_out;
 
 	err = damon_lru_sort_turn(enable);
@@ -368,8 +368,13 @@ MODULE_PARM_DESC(enabled,
 
 static int __init damon_lru_sort_init(void)
 {
-	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
+	int err;
 
+	if (!damon_initialized()) {
+		err = -ENOMEM;
+		goto out;
+	}
+	err = damon_modules_new_paddr_ctx_target(&ctx, &target);
 	if (err)
 		goto out;
 
-- 
2.39.5

