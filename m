Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D38360A44EC
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QswZGkVT
Received: by kanga.kvack.org (Postfix)
	id 915466B05D7; Mon,  2 Nov 2026 10:08:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EA7B6B05D8; Mon,  2 Nov 2026 10:08:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802346B05D9; Mon,  2 Nov 2026 10:08:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 653B26B05D7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED5A3C013E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:07 +0000 (UTC)
X-FDA: 85390509414.10.A3A9FF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1C27B4001F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QswZGkVT;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjesFWiEFML4rVzuVYdu4iAghuO52PLQ0oTZPIBhKvg=;
	b=lULnUxpkb8FDbFYcJWKJBbRpgQqux2L95+xy0z1zSxHWe5oLYM4mn92auI+Kz+kllfP8mB
	/FqGBBPZHsn/ywY+FnE2aGt1noEcsAEKVAux1bhMXzqVVkA2j8eDz3WdE9I88Uu1H6z89V
	5ufTrOck9UgJ8gAg0M1vSGJkDeiKwOk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632086;
	b=vSWmfCy5jC+7/m/x1bMmwHtpdrCoFnVi7qROwSV6/gcIZz5RgAqxtrgzp846nAc2o64wuS
	H1r6ugPhsk6w9K49BEpcmFYu1NQlhdT+LPRL/0qc8mt+6DuQ8m558VQ/h8Fp/+4+fFyZwf
	WYQqYkVOggBQp+kdVGLOHFrkwA8PMQE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QswZGkVT;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD62360233;
	Mon,  2 Nov 2026 15:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357CF1F00A1A;
	Mon,  2 Nov 2026 15:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632085;
	bh=kjesFWiEFML4rVzuVYdu4iAghuO52PLQ0oTZPIBhKvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QswZGkVT5q5HQbBhg/cqAiBnSytNeCEt+MzKd4t2XsL+eH2BBH193OMepSCFiwW6h
	 EIGw5vCs85k9wFPzoFOIC8Mb3eYr3dw9kPQC7uDZVHdhs0BPC4qKHVOPChCbrB708p
	 9tUXS+9K3vrRx4ZWBZCM7geTQi/cukQtxSH0wp3D4vtnn81F1/wd59Pcu0gaj2pfQK
	 wLFrHo0LyE2Pm/WuaBI2neaOEYisozxX2kGss6J0kSShJWs7q0fDFl8cqDyAbX48QI
	 uTWBa+hxWg8xcJmgg2+ybj8mQuTcpTy8WzaLFhhMknmLlPz0I64Xmj/EeE5vMIHdEi
	 K41fs/H3P3cxA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/9] mm/damon/core: remove unnecessary zero-initialization in damon_new_ctx()
Date: Mon,  2 Nov 2026 07:07:48 -0800
Message-ID: <20261102150757.93058-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102150757.93058-1-sj@kernel.org>
References: <20261102150757.93058-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1C27B4001F
X-Stat-Signature: y3gpbthexy5kbzmw9e9cspqfi8a69cts
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793632085-524418
X-HE-Meta: U2FsdGVkX1/zYJ00M7fxWyA6b3bqupif6IO7AkeGjh1le56+DRjDoQ2N/AmAziWmjxEha2EmIJEyowKCGI5FlKbEyr7Fhy9bKfoQHy4USBw8mHbyjGFEu4TiGnvuqjEU5tQidlPjva47LUOY6GPDLJ9H4SIJ52T7bc82pPFs5opVdlWZS7zMwHVTAQkvWXyRD73eOFWK/sY8m6Xd04zJUFlzpAPqsH/gfKb7qXTs2WDxTPAr1aXKdN3xSF/GsPYQEvzfp7xzGahky/OCyPY3ucVLpupZWnJkulSv2T1cR3c/lq0apICunFKwHRiKn1QpybLSWlzy6DCgwirAem4I1One6ADCGb5FoW3II8FK8Xy3/EzyZWUV4mJRJlWkdMosxZkB2KpxXLFtMsrQjur42BLBcpmk5bA7KKdAT4ymOBwjyw2LvqnBJ89H994kGXmVLKR828EacAEKVrftqfgzfNwPoSNLS4jUOe+/m+aaiR+uHrMDdDqZ627R1qzUNSa2CRmHtENlyBmWuwLhFljuE5JV7JUgeH7dc6hoDNU5IsphPdYIgRpDyx9kVwt0oXrzF01wRU/9NePcNWUGFeIyyVzB/BTIimMIP3G6Hh5hyZY3g2trlZx/B2ONTwTyiwwwQ0XralzUSwN3j+HhBvTyQj+uzLZP7ztjL2IZxOL+v0bbKiaWN8JGCh0IH06nfgDspVuXcvFdNMB3LmvdBEd4Bortl1hZVdxA5fBOPfRrlKAq0EXmPlReq3dXK3549DMoQfETzP8BbsNhbNg60evF88fFhnIgrYRL/WZqjS0oDxYg70SF49jNDuPc2Cgo3OmKPXJj8k5Mq6FVHFNYbF3/50HsrLiDkK7W3Lujm5nab5DrZnyVW015d1LBQnkJZa8Osj6TeVLSiLX1KBXrBrceCgLmJBkCQU0MW1X2trL8KzL1np4pDXNBFNR0umdLKg3TCz/I4A5g2i0mzQuqFJx
 jTyCquxv
 jmWH5kR2gJITCfpNwLu4DyhNc5hWEZRlpbCdGAqTgqC7sFYlzsorJQllu09adJUu9K4rd8Akwfa8hoZc9xna3eLid/yGs2mvRxVARxz+Xv2MwOWuPWe4UPU5MuvWlqM0iuhBQcB2rV3e+932QYLXPdWkBDMDqFUg41fhYDSLSHFAyAoG+Xz6fHQ0yi808ohwVP3YfCCRke4tKGExZyK7JHUStvQf5ULUMMlRz4o/yM6QSayVpcPD3HZCKDC6UNZoUIwvDzN06nU57xpGwsrn1ZQt2dnSOjvDWsVIU5q3JMZIm7Ptn5btfbnq2qMY2K07I9XRL7UWZ0H91pn4JWVW0CHhp16TDObDkRw7k66vZrh6fe78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>

damon_new_ctx() allocates the context structure using kzalloc(),
which already initializes all fields to zero.

The explicit initialization of passed_sample_intervals,
next_aggregation_sis, and next_ops_update_sis is therefore redundant.
In addition, they are later initialized by kdamond_init_ctx() before use.

Remove the unnecessary assignments to simplify the code.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261016143733.320-1-adrianhuang0701@gmail.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 mm/damon/core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7441cdea57dc5..9d54899004026 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -918,11 +918,6 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.aggr_interval = 100 * 1000;
 	ctx->attrs.ops_update_interval = 60 * 1000 * 1000;
 
-	ctx->passed_sample_intervals = 0;
-	/* These will be set from kdamond_init_ctx() */
-	ctx->next_aggregation_sis = 0;
-	ctx->next_ops_update_sis = 0;
-
 	mutex_init(&ctx->kdamond_lock);
 	INIT_LIST_HEAD(&ctx->call_controls);
 	mutex_init(&ctx->call_controls_lock);
-- 
2.47.3

