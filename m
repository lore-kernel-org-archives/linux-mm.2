Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C59D2F338
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 15:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16BEA6B0092; Tue, 13 Jan 2026 10:27:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A23A6B0096; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D766B0092; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF0B86B0095
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:27:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 702F4C08D5
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:34 +0000 (UTC)
X-FDA: 84327320028.24.0DF8FA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C1AED1C0007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TQwLD6Yq;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768318052; a=rsa-sha256;
	cv=none;
	b=s+yd4mtJEfWeO/8DpFLaSJwTwBj4kPpP6XNRqBWNBHzu3Tv4hgp7WsiMvx36KEsZv72opz
	odASxLA2umf6D09HXZocUMgg534HpTvr/rfL692GpbafMH/xwSskax0aGSsOD93bhcqBAS
	Vpv5JO/rMq3NwvvkfILIOxsPbKTlLWc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TQwLD6Yq;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768318052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JF0IUQ068r+1d4jlHQLBlB0OX3AiXL83Tl7dFt/sDM4=;
	b=Bsj3z7ZLnLokzmeH8v6o+tjh7AWK3nHg7dtfEgeqkoHCtLbvcuQTylhs2ht0WDkPOAiPnU
	/EB21sLcApdM59K/Pj1D4mVZKLH0T1YwKFlquLlmY4jQeoTZeu9Q66G0MRsTzlPHtK3gIT
	3QSF7FNt6MC54XkA4kcmsjvCkxtejkY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F3B5544419;
	Tue, 13 Jan 2026 15:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3778C2BC87;
	Tue, 13 Jan 2026 15:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768318051;
	bh=u9BpClkZFdNL3P8/T2nVybp/XhQM1COhsP+bLP+TFE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TQwLD6YquT6NgnNQ84Kx8u7TWgMhbpMmt3X9fEodCwRYUsC9TaiBlzVw/KmPmmtNw
	 1uII382sK4yne5J+fP75WQWpKjrs847Il9tU6TVwhj3ZkqWDU6trZ9l3kTyh6RFVZq
	 vbbSqe4dEk1gvxU4hzdxMa+eAzna3Z1H6u97Y4GII2PQoTkUBtfPxzGq485BQxg5v6
	 Ega6oOwSY7lWyVFPh42UnaMj5FH8ZKnGua+4N/yiHbsxP8nVfQoHX5COyAAUeQOpr7
	 +F6Wa14h2HHNqnQ6QnbYITbui3f1pqJa3v/SGtfPe8MpJL6zoDbGhlWgv9IwAqNkFZ
	 SGvlIBXdiA08Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/11] mm/damon/lru_sort: consider age for quota prioritization
Date: Tue, 13 Jan 2026 07:27:10 -0800
Message-ID: <20260113152717.70459-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113152717.70459-1-sj@kernel.org>
References: <20260113152717.70459-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C1AED1C0007
X-Stat-Signature: zk7it8ubiouctmqwgsrk37dqw5zd4bgk
X-Rspam-User: 
X-HE-Tag: 1768318052-405749
X-HE-Meta: U2FsdGVkX1/O0TFmEUrkBT4Z1eCPDK+nFlobKrsM7WbMtxiuL86/wNMwpJpA1IK9XN72O/7nxXCoqz55U7Xz1RM0Mu6JaBjS+vllqlNqrcQ/p2hnWO9x1ZCg8iwjOsB/R/wTWygI2U4DqZZSO1w/hVcmWCe3zRij4wgPZEVrxO1IeWtHylw0uPfsAb/ngEvsHXCHySoh57dA32A7luaNTfaJKYMBMd1QORfAkpZkYHQbTK5DHc5MXQqreDhM0p88aKkrP8KBar8lJTYt8lvwXZLUf2P8GitUxWYv5kcWySgBARa04dIZjO7la7M25p2s3oUIVsdph4VRcgMPWIDYrTc+rxPgH+MaPMgMNsjmVervagWanYJ9BRVhQQQOglzYdZ+d/ZVDmQFrIE73AwXkjSqnryB/q2+rhcoRi0lYl+9kj3F64bTVZtEhBlT4GtA1SwT2ifI8Ex0BN05+nIUojI+5I6MloICrlth7UMD1R5NWpBuNGEi5sXfZDCxmCpQjxyck48zpn968IvvBaX2SXuQBVRz5JHUvr8F+2tYs4Ts8cN/SWJN+R1LVYrCXTPkSkVBrIj88w+BgT2sqwsc8u5nkxN2DUzigltyOXedSuZe+01TwerUodz5lPUytjH+nt4r0Y1c+AbMvPreh/JsGwhlkkAeFLnErG1MzbGkZ6jDEYcTtR6AAP0RlLUx+DY3F2lMX/Py9x4bXeCYaHc3/ZyecHP+D0L9ikn7TrMJ6kQyfOn3dXmy081LdVscQ9ILWj33gCKQozGJVsYlRF/Nx+buoMylxTf2YfKICjOQtANy9CrLNplBWtEwAmuDAv3qAQLuC5aLGvFlqm2y1N7aNeGwmGNvoyCnpFv8I4Fjzt/9UKZeLAuHqocj046OJQfWbYTkBv1X1tWjF9HTrUlJgQpWVbJhhXwn6dCGDldv86DSK2aMGt8wJsGBsGXRfTCk/Q/NJosG8fz0Rbfr7DGS
 9xMBKuBp
 0zr5FqXmZs9dawK61EJ4RmXhS1w78kskm7bdbyTTYf+wH7sn3SM5g2cOhXI43K4BiyYu87sy0AxEYGWnxr1RZJ2Tl1YUwAYo/w1AHUbTJJbUmlWJ3/MgdYflWLpvslx6eQmIazIH2xE8CHz1DlGwVmkxGIy/ul79xDeUaABtAu+XoNNgjBzzWwqTcwUlKGEeJJTU2VO8IgRVC3o0VXISgcRfyBXqaviggTUfq1w16DcasbfIKPkAQ4e7gp8NU+6bZ698QB2YMJ5m8koevahVl2rZA1YvoTyLVyhTs9mUevBb7NHI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT is doing under-quota access pattern based regions
prioritization using only access frequency.  Age of regions is another
useful information for distinguishing hot and cold regions.  Use it for
prioritization, too.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 9388b091deb7..a74c4ec170a9 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -71,7 +71,7 @@ static struct damos_quota damon_lru_sort_quota = {
 	/* Within the quota, mark hotter regions accessed first. */
 	.weight_sz = 0,
 	.weight_nr_accesses = 1,
-	.weight_age = 0,
+	.weight_age = 1,
 };
 DEFINE_DAMON_MODULES_DAMOS_TIME_QUOTA(damon_lru_sort_quota);
 
-- 
2.47.3

