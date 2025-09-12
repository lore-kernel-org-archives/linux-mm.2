Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED736CAC587
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 02:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1746B0022; Thu, 11 Sep 2025 22:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9B26B0023; Thu, 11 Sep 2025 22:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BF7B6B0024; Thu, 11 Sep 2025 22:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 65A086B0022
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:39:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 294F913B18D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:39:59 +0000 (UTC)
X-FDA: 83879043318.02.45E0D6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9ABF640002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:39:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pIZejVwd;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757644797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AJ9xwY17HDI2crilk6IGqE7MQDPUgj3jKw/933aNvY=;
	b=Lr421uGm3guUavHgojxUXEpXWXbe/BEKRfHhH24+OXjlmJNhnDCpZ1Nqbyn+mCkXInF6s0
	OqRIMqpXpi16mP4sRU33KDRnDrwMCoCUJYkzvTI8Yp9cwrJnqutUsdsVoXjHGpAj2HybQR
	VnakrcL3sMxbegIDOM8WQnwPJIs1VBA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757644797; a=rsa-sha256;
	cv=none;
	b=Zkp9VWXtLdVVB6MRt4Sb3zj5r1n2M+XrroutnbTtz8rYv5o0C8QMFQkMHhRhmLbP8vCwDZ
	PnePxeSeuYIckjN64lSDwYUD2NDpCpqrxwTNancxYHqgGD9p401A+NKv+6K6JobIbt32Jx
	ENMkjJjT1lm447OmXw3QiKe60CFc+Bk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pIZejVwd;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 23D3B60258;
	Fri, 12 Sep 2025 02:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C407EC4CEF5;
	Fri, 12 Sep 2025 02:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757644796;
	bh=jSyChxhp2q57cPUh41M0fEVHkYfztaaT3v+fVBcDkyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIZejVwd7XS4Ox9Am4KGnyKBX3HhSNWV+MeIMCEHwd+JisNA8vBa+ZoK/xxPCS566
	 NtoaYCUPFFoYgYs7gkzrx4XBtTfEjQYdXf+O5Zj85rWQBJk2nnEmQAIV0qvmMS1NhW
	 YhYLy1w4PGuqxbyn1HyR2OA6DoKZdie75UduINMCXVwfpKZ6jh3vVBHWQkPcLFXJoS
	 exO532i/QkVnkBu/8B1xOeYqKqZFUiHlvfVzHQevIw5WSuFdinlIjwDDQsuclhYPgT
	 otf7PQvW9yeN4NGD6cCozpavPfP7/QLxd9OmlMIbPdq20xiMfsvoK14UxlfPRAysex
	 2PyMn7solWsag==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/7] mm/damon/lru_sort: use damon_initialized()
Date: Thu, 11 Sep 2025 19:39:43 -0700
Message-Id: <20250912023946.62337-5-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250912023946.62337-1-sj@kernel.org>
References: <20250912023946.62337-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9ABF640002
X-Stat-Signature: owy8yama67u5mgfn6ccez9c4iguc8xha
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757644797-723236
X-HE-Meta: U2FsdGVkX1+W9MnH7LoKvqsiAkWnKRqzbaOW0repGayLic3D8Dx9k1aEii9AiMBNfIv7L/wqI2WMyxF5d9ptkv1tVXQJWheB/bOmf0GlTPczgQZiNTelx/vT0WiP6lSGpjfQYuqMo16iVI+Amjvd2yUG7Fddk3l5AX9QxE1TPHJfcomvXDbQN0zTnZF7ZX+RZQKC+33yofQIzlh1gGsTPdHr5/+K83mTwMZbVVflTzqd5LH3WDT2ZLXIWZUqHId8GHJ1sqffU68tDfQlFQc+GlTdDf5HhM8sCHjCzVCnMF1vP4IYpiFtOINYkKghqeLFQCXehQyH8t3O6O1dq+qiyG+IGBYIkmSL5aI2iZEzKbZTNSa5h0GdovFqyuN+1s/FavnEQqSyDz78YcKY/Vwm12p8Uo5KDtSv46Q/5aPuxjNuRX2VlLvG3E56/g/D7nqQZd1m2Vx2+9hizsYFXmZTS83yaEEjEMjORzefNpk4F4fo582DDBlW65jH8q3r9q37vfogttAt94pJftZe8eOElcPKc5DQ6kcKUpoWiy5AcBECuTlCFXH07wiFmdERbWbvL+bLT6gqbVqz2thO28Iuh3XeTTQvi6LogRnIEdq41jDQTNUfnyGfuod25g+TcbEPJlFAq+yGhFD51MeF2rybGrKmtAp31FDfWQ/TzsnFBlU4MSA8d96wgt/tDEP3bcavFg7332jzhYaPQENxFfInQeK0NsJr/HxTE2Y2aukvwzevPtOHIWwegP/+TmqMNpc4f2cHuUeEPkpXJkpFE3gyecGW9Fr6dbYkkIpw0z9xjSvBKhQSJHaoHzXwOMjHp2FTky6e0h+ga5PH7kY2jS8vZvhPfo+WPJN6m2u5JVA50W1IBck38hlVvOwyjtv7VsWtZXS6ZkzPSFUWOBuqgxA2xWPG5fDfYir/S644JWNYphNgU4FWukPkpBsdU7uu7X9PcEHDhx2P2yvWe6LatHm
 T+/6FOTr
 /4XjFCaDo2Ubr6g9e9MHK2Q2UmRIVWl6d8BftnyY6IljRrHmm3FMyc/SKIDGV4OwxNwc50DSAedTEdCSM+hhONGJ/XIIqbCNmoASGf542ZStV1dG2sUxFE1pG4eShrBwszqiCYMi/ECQBZekNcSmBbIuo5Db6qQ4uZcUZ/042F8P+tJhIXa2LGLLzqZSq/2Mv+p6TRgUei6eBZkCGXpXFJ7W+jBA2sOJZYuQQSu5y31XzgEG/EAE4anqCisdJg62Ey0Gf+Dsg19Le/pZOmsgW69xlfw==
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

