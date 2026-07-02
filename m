Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 925E3C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C86A6B00FD; Thu,  2 Jul 2026 20:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1546B0106; Thu,  2 Jul 2026 20:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DFF86B0111; Thu,  2 Jul 2026 20:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39FCB6B00FD
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:42:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A84240283
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:15 +0000 (UTC)
X-FDA: 84945069510.05.5FC68DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DBDB41A000A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oIyhVAgA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783026373;
	b=BNrkuMC2J1m86VDRvywVhBBx2NNAmB+aIYYxv4eqZLwzwhtuoJ5EK7FxOfG3FaOSMeu2DF
	bh1kCobK5paWarPFWv+6PR1X+qotJZHik4kVSlyN+7ymyWqBSANPEBYq0ns6FiTQBNYpMi
	8MtnwbpgYSuA2y0sC9P7xWP4sIk6y6g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783026373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91/eIt5/uTjkLlfjnN3QJGjfo7AqpmKw2P22J/q/8zc=;
	b=yHj0TfSwwzZOVgNY2jxBYOREaBmTqeqYEhDjceBVT7oxEgYUkO18KJFMUkilF27kdHg/CA
	EHDHSIR9VWnZpJNEzCjYJ96jV4XTI/i2yLiQUDheW46sv9ribnpH0qkxcg9P1/w3Yp521/
	g5Fdk/Vrfw6jqc0UogEv+b78Tm/Y2Xc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oIyhVAgA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70F32601D5
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD471F000E9;
	Thu,  2 Jul 2026 21:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783026373;
	bh=91/eIt5/uTjkLlfjnN3QJGjfo7AqpmKw2P22J/q/8zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oIyhVAgAGPFalJ2n/92cMP1H8mLrkWYwBgwSB8E5zjbYnccJE1uH3wnyrHaBxTRQx
	 DdwZFVUHR79dS9+forn6IsKVZSxwi8zfJl6mVBkIsjiAv9MoGS3wB5cpOuQoSJIKW3
	 /JjB1p5kgoC+4ekPpCWPWH2iRQD7yGnnayT398IJ+t0GDd1OPvZGIYs5tRA6A8Oo9J
	 WChR3LvxO02xJBejePSBhi5kENBXZNcze3B4bccXZ3cI7yTwCY0evEB8aZdxXgaaAL
	 SBHfWZssMyDedeiSnOvpd0WzaQ13gysUO9QI0ICS7fO0dwN3JC/u4T49iHGVOkjP9A
	 avm16MbuYoc7Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 6/8] mm/damon: document region size validation in damon_set_regions()
Date: Thu,  2 Jul 2026 14:05:48 -0700
Message-ID: <20260702210551.95167-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702210551.95167-1-sj@kernel.org>
References: <20260702210551.95167-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DBDB41A000A
X-Stat-Signature: w9jo58rxx9ufbxzzwjw3dxbs98attdwj
X-Rspam-User: 
X-HE-Tag: 1783026373-610051
X-HE-Meta: U2FsdGVkX19Yo5YZc1GZ7pRFviPIpCDRG40Ci6pUfxfu5AP8c4zCNHkkyWPsbUFEY5RTNoY/sNBcsViHwwtbsa2B6Pdnb4nHSagaXYTVfK5ILlkmeZL/KJa5q6ETmlKbAP7xSuiB2LfslzuybEBJuPdqAxTdjOK5ZhgHkcpui1ftf1zil3+m79TB5S3Cr4FY5crPFfnHS36l3UXH/IS4aElZG87wSzlhH3a7+CadwXn8vyRmMkPpqmSUF3N6pf9i/ux6XRXMMSNsLNd+MMsyM9cso4KuvSbt6EiRBDeH6fZspZFu8rboY3y7Y6rb5IB8e+T/pW/k+iudDNADBTS9ELrdPqNjctirlMlkEqjpQsKpZ0ZkxsruFZgPHbxWFtqbR9Lz0TMd77l4USb1/m6d1WsknbKBZ2DeB9UBIA7ZVdy5HTaG2Synl9mu+G3TJq5AcLuM7LzXOvajQeAkODqsW0AnUzNQ5dxQQZ0R2zLc4HPPMUENibRSShFuk1sAJ8Ljd8YDXOk63UXG/5hBkauYVuM+68j/EDIPVvUQ6BgLgouGyanx68C0YWc+1EB4cWpM9ywLEFEQFEoNmQW93UJDPMzcUAS1BExpLx2ooBGRA+EMKaE7Ok15e8v3H2GDjhIBYwXaesb/ZhrHxAVvdbj5MoMWwA7t7ZPZoCHA1Im6pbQAiM5iOIPxBQ9JyTfSLdmjK0mTDQjmJ3ayy43w+Ns0egt5GfuMC6w5RR3Bl1iFR09XsMjh4KlrG8PX5qhgibdCyDuxlxxCS+pmk+pQYHYHRalqYlXXgTzP7HenZCqHntKzwBaUlZzO6hy/kjQK2hqKOa1U5accyomTl5gLnIBBiBp6dJ2JhjbeXC2o2GxBqe2rf8EKeXl6ljs94mRFmbVItBukcy+QMqG1eikKZ7Ch7nKagqbhpO8QycS0NgzC8qQeQ6IWV5hG1oMSi/ljrlp6LRfEOk+RN/jd86vk1B3
 ohAWwW88
 SM2R40yZm+W8qVP2Rg75Vt8d0d0pMi13MWz2GVwnSTBFMO1D/J6JjfPr+j0iHrI9B0A6c1zCk2TEaz34tjYBdrRhJT+q1SZvzPIvClMQA6zwgTIMiaWOZr/SULWQhTHtUQOCNQp/U1yKJbkRDk5Ee+dLRdeEd637PkAnzmnCfru6yvhYr/tjFP9mJMO49O8Vr34QPX6SynQpOqqIcLsGvblYFEYAZESnJ7Yj5Ehvk8GioZgo7E3xki+xHz/wdeRj2UqJAS8fOHC/d0vca4czjNWzbkDYssIzeHTjq58J50DG0YukiDHBLkkLC6ALGTsZne3t2ecgObkcZSe94xtY2UVKUk6ZFVUU6VTL1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel doc comment of damon_region clearly specifies every region
should have positive size.  But it is unclear who should verify it.
damon_set_regions() is the recommended DAMON core function for setting
regions from the callers, and has the verification.  Update the comment
to clarify the callers should be ok to pass any values for region
addresses, as long as they use damon_set_regions().

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 616bdf0954b52..2661231c0ae82 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -49,7 +49,8 @@ struct damon_size_range {
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
- * For any use case, @ar should be non-zero positive size.
+ * For any use case, @ar should be non-zero positive size.  damon_set_regions()
+ * does the validation.
  *
  * @nr_accesses is reset to zero for every &damon_attrs->aggr_interval and be
  * increased for every &damon_attrs->sample_interval if an access to the region
-- 
2.47.3

