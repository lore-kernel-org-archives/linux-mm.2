Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A842C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30C5F6B00B1; Mon, 27 Jul 2026 10:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26F046B00B3; Mon, 27 Jul 2026 10:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10FEA6B00B2; Mon, 27 Jul 2026 10:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D81F56B00AF
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C2A3140751
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:35 +0000 (UTC)
X-FDA: 85034812590.04.289E301
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C41A840006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=befYxMiy;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZDCgXboPWDjpqLBgpT6yf0F7vtlbLEb3w3NI8ROd0U=;
	b=QpmksoxpLHs5f6I4vbTfCOIjPcaJlieJ6pt36O8pZxyDybiLpRNi7Il4Fcf0ewv5ber7aS
	CivtkSWoSzxrNAFjEV9bTlJiF6tCkbZPIl38rD/+q9SxBFGU7oDfJ5LW2vHukNmYZg+IAc
	WKSm8ppj3xJ8yu/z/AcowecH3FpYFdY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=befYxMiy;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163113;
	b=najefmcjjWkhpsMcSJJH9q5gB6UEkqN8TDZdie2L6PxQ6A7nBIlqVPu23F4AqFuIoR0vie
	TPD/im9nyuiUQ+6HDN7ctDTlhxMWk4B2sHniYMpx5AHvxcOIxWMaO1siaZSWL7nepYlgpe
	loytyfxxWPk57QGF81/neivvSRt8ivQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DE2CE43CAA
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A438A1F00A3A;
	Mon, 27 Jul 2026 14:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163112;
	bh=GZDCgXboPWDjpqLBgpT6yf0F7vtlbLEb3w3NI8ROd0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=befYxMiy6AyURSIp+XkQKBehuQc3Jwld2EV7aKfBQsYpX+808ukS5GlaFV5o/Klj9
	 DrO9OWz35Rk/heMaMmAAUs8KePMFg2bvABfsC1TEDQZYcEb5eqb+0IOoCyHSd2MGBL
	 nRVWmc0sYcLzhPdwl9EP6LZUZHs6XpXR7ET4K9Tb+xfZIVmaD1KFx6BxF0Lk/Q/dxk
	 PF31RVYx7SlbA//hx1g8cS84eJXV0l9fMF2cgFnO65a2w+x6fuEdYu9qUD/RTbp+vK
	 Av29OKb/5I8NLZGGQyYrohyFjzKM59DpSvnGVHoza2cJ/J1RRuzIe8mVWkuyzF/n3y
	 y1xtRIhlQiN5A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 01/17] mm/damon/core: introduce DAMON_FILTER_TYPE_PGIDLE_UNSET
Date: Mon, 27 Jul 2026 07:38:10 -0700
Message-ID: <20260727143829.86236-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C41A840006
X-Stat-Signature: khqytyb75yycr8zxct8u7gae54hrmhq1
X-HE-Tag: 1785163113-927118
X-HE-Meta: U2FsdGVkX1+uLwJWP+2aRw3T1t7/yWWqUDDVS1VtJyn0Do4l8qzsUXlfC80GoHDVjaadCYJZcaCxmpoKPTH+Fw7uv/7Vqkj3uNVGaYfDcsGnke5wnxbzgM82BpyD/US0PTowKZ4p3cKGLku3EftTJxsXFY/oZ5g6jzXD8Bn5pMEWJoltOVzEEubpXb56yjgiTszgtis7xeFwVMzUnAZwYE3FjbthMjt6wJnqF0C/eNmmjFaZR/RADeSXNOYFTTi0pHs7bADzgEDTgY5BtNeG7HhRh6lQgpmLc0m23TB5YrI4Hdml92JwyyOmc3sgVC6twTDJP8dBqyhmPkKH0KYbIrfq2ruICyUcwEwu9SRMXD7ffEUmvUpHMzVf/6ZH40aNnssG4oZb0LnJu1uvZZro2j9214U2tPNSoUTNVUjZubhEWfhP5PCrFXb8kdAtV+ZhvMdjsWHC1pNKKVGKnvifmw0lmanYz1ApdM8XFzVVJkvp+A60tEsMTe7xRDGV4LqwkIilFQBi65g3QU5BzVjby+yoYSuPliHEnRgABeQe/R9MYasasYzU884MxQFx7ficcMF0RSK2qWsLaWkUAD3y4DZTDGTwVulZTL5fymBRWykli/NWIaSgLXih2AiCeRWK6ZLe5PuXr6Rr3OASgqY3kBcDPEVJJQvJZAlbe0LjnzDrperTR+oEvFhLhUhjrtIKdszRkp5Cm9pQ+KgHOq4NZN0vqZ8yOHxKvyLuKk/V9jdiOSLu6WLmNijUW0MO71ySv/aekmcSSADmTmRkMtUTdPUghKS0T7pvKsgk1kMenqtrBdLv4ByBn7mSfp+Mmepg6Div/7Xy2kOL/b1syxHzC8ujH9L01JX9gVqmRdSaiMkLPDirusenC0CJ3p9pX0A+nhtPPdNsOeQBYazLE0aTYI6KUkV4wLiO+ME753vtWA3FOAokBV4Tps3zFR6V6lTTo9j2KhN99Slz0QweGvP
 hQASLvxV
 wAe7gnnIglvahrL0mOQ/EuCaw/rxKRQ0Qu4VIKdP7ZjWMU5Jkz9bpvC4oiDJnE89pSKD5p2P2ID5q2xxQWeEMibioE1Gfsjz/QLU9vOYCYCSiR1xWgnSBjecb1tq6BSPE2ZNbHvnYSoXZMFCKOtfyuf/Gt3o4RMsrkCMXrwlH/0IbguX/wygZHLGpTxMRHpxCNbXF0m8OR0bFQtlwJpaCcZKIZoXDjM6+qLkEHnskJlGpKjvESG0hDG+18ETr5ZUAsNbBP5OwfD4GXgx8lS2WxmJRydBsbgsKDh3j+xAtHTP57NgAiHjWehqELU09dqlgKZsM/jNfWsk1XA42r4KKEc7O4WqSW9TdPppK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new DAMON filter type, pgidle_unset.  It will match pages
that have their PG_Idle flag unset, or the page table accessed bit set.
In other words, it says if the page is accessed.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 8ad6ef2e063de..cee4b74761081 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -744,12 +744,14 @@ struct damon_intervals_goal {
 /**
  * enum damon_filter_type - Type of &struct damon_filter
  *
- * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
- * @DAMON_FILTER_TYPE_MEMCG:	Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_ANON:		Anonymous pages.
+ * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
+ * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
+	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 };
 
 /**
-- 
2.47.3

