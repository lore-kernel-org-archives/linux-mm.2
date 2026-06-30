Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26DACC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13156B00BA; Tue, 30 Jun 2026 00:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9106B00BD; Tue, 30 Jun 2026 00:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866E26B00BA; Tue, 30 Jun 2026 00:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30DFB6B00BB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8751912034A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:34 +0000 (UTC)
X-FDA: 84935247348.21.0326C3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 032D020002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cU3TDn8d;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792513;
	b=pefMnGIBUiLFgz2uMF56LJWLc0OvQ9WuWg/wl7wJ2Gq6jWV1hmFMPtGpB8zaW+muamVINb
	XphQ7F37cgp7a4ykt4KLKjeZn+KZRn9XcXXaWA/4LkPT1svB6KeOswDxbcUPN4QQUTvSjR
	nMt83qwHFbMHugg7wrFPl1Zg0KYb66M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKyd33wwPt+YfMdA3ISpRxLndBZ3QlqVZ2syg7ZfqQE=;
	b=3rSRFlCp9qoc1GgHtdH70hOk27gwXaolHDwX3E1QtLli/l1FE4EEQzalYja197TqPt7OYp
	NvBjNgeXCk8R8DjFh4bdayfKH6LN9pQiyaSQh4Op8Jl3KL6tGPNUL24znsaCnqPf1/uoTD
	uWgcn8vWObAONeQsSYsM6HM7j8hctGw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cU3TDn8d;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 056CE4194D;
	Tue, 30 Jun 2026 04:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27971F00A3E;
	Tue, 30 Jun 2026 04:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792511;
	bh=pKyd33wwPt+YfMdA3ISpRxLndBZ3QlqVZ2syg7ZfqQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cU3TDn8d6HhHxZPKkBRZkU0tc+DnWjph7oFfRfkN8xCLp+nzZMDjr54xh/A/JsbK4
	 9k36F0oD/ABX6Uxk/uBMWiD/QpmkyF5NaBeatqumHp7+8ebg8o0td7TAYGYGAEaxCP
	 PiF/CE19xi2EYfrRn+OOKNXYqJNkv9DwlR67Rko+S5C3jsNhBr6sbDTFexKqiAvlwO
	 Lr6WjF/iDRTqYDE7bUW8u1Akz1eKcUcIq72Cf2dP+MX1iMk6FdMmBeEAWKqjE/6qzY
	 EAqt5CWcxWBFrf+DX9a8ElXNHPeFscMsGgzqtFC6BrEgMTGPWSNzbcFjw103npe4Qf
	 rLnRZ6np3m6Yw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 18/18] mm/damon/core: remove damon_region->nr_accesses_bp
Date: Mon, 29 Jun 2026 21:08:11 -0700
Message-ID: <20260630040812.149729-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 54czrys6fkx11t9n5s8azu1hcud3ynxw
X-Rspamd-Queue-Id: 032D020002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782792512-90230
X-HE-Meta: U2FsdGVkX18nrhjNKHmvVr+6gJUYLs7hm9KDGQbhvoCQTRQMPEuz9Pmwehsdpl746sCEppI/1Y6wtqS36+VOQfbaOKEjuNiZ5MWb6pRq3kd1cBEXLSnfSYao0ofj9/yCZP/e6Phv1MvbixKJAyxgB7LCfl22zYDhPbtp0N809gJkjvDSAP9czysktz7R7LlYVDEEe6t+Id4IWhfCFpisnz7n9GW75cnqZLxR/wOw3ztdaInfItcLRQjgqDDZFgdpY9wqAxTVRyM/7sNOrUiEF1KLncRHgu6ruAWC1Pb91bal1FmiiAu3Vpd++NNpJQR56JYcTWt8FhHSv701+QulBGT8mXYPLnsVXSJJqezWiGUM/iCci7BL8eXWxYHxU0NlXMZTu6nwcGlDtoZA2Dr34xdyl6ZvgL7OrfxwXKpOg6Ntb/IhQq9p4YV4OQJgX9L3uOOAbn6C8vmvfqngXSR5f3h641MCuiFddBpY9bea4x0lju5/x0i+wsmw2SKATWMR6aIch+1amRMS3e6UFmGyzJC457sAmcmjCRZ6IwmDZMqoVfEP3Uxx3uOu/LQfiQCWe39tdI778kZS+fJkAr1oknqbjs2yoEar5An/1DIULMoaycqjWlwe9wVbgUINbC2/WLDMflzaOP1CEkkUVlob8mnsL7nlytX86v6W1aV8fPZLZmb0uXPl25aHQKzNDisgBIJfokcj2wDneeyd0yD692A1nUOoOAkjwlfCiUrfxAB4YJ9aeQC/+AzijWpJkM77nMAbvN4sQh6qW+sTxb7mbYxTPOni9Q54YPJ6kcXJvt0ShGtzWJmBCNTizz4OfoCveYuMD0wwK3f7QAdhy9zG8KmeSn4EQDSa4tpGH27AiMi5eotLIVXd5oC7DF7s+Taz0sNtuFamyLsJkRRYeoGgJ2eyCIM/zy+BN63/dqByS/gSaA9tfehAGBS2O9VA93YMsmCm0HPgfBpOZUMrQ5Q
 nLjfVAdR
 nAMwM6JXPL6bOaU6ourPymxJM+hbt9B9nSJtB6MYLsXOi2rZnNEjENuvn+TeTZuJzkWLV5TDzIRA+SNTNRFxcWUINfZbbCLruAdL7HZcd8WS8S3VYMU4shm+pwnSTSiwtpNc1RwNYzfGrq18uqoysOGVCHHMdbn2mXZSYnoL3Ksu2u0evmxA6KLal9kqN0Pgj4ke726HPIcOKmkT43dKRC+T+3usNFxrl2jxNFADE6M/CQWSGZ0ilMvjFivQJoCEHG/CCbzRUNvIAf/3jQ4Ghx0thllf85l9op5Ea
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No code touches damon_region->nr_accesses_bp field.  Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 10 ----------
 mm/damon/core.c       |  3 +--
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 02ed47c558cc2..805e089ff4f2f 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -45,8 +45,6 @@ struct damon_size_range {
  * @ar:			The address range of the region.
  * @sampling_addr:	Address of the sample for the next access check.
  * @nr_accesses:	Access frequency of this region.
- * @nr_accesses_bp:	@nr_accesses in basis point (0.01%) that updated for
- *			each sampling interval.
  * @probe_hits:		Number of probe-positive region samples.
  * @list:		List head for siblings.
  * @age:		Age of this region.
@@ -59,13 +57,6 @@ struct damon_size_range {
  * not be done with direct access but with the helper function,
  * damon_update_region_access_rate().
  *
- * @nr_accesses_bp is another representation of @nr_accesses in basis point
- * (1 in 10,000) that updated for every &damon_attrs->sample_interval in a
- * manner similar to moving sum.  By the algorithm, this value becomes
- * @nr_accesses * 10000 for every &struct damon_attrs->aggr_interval.  This can
- * be used when the aggregation interval is too huge and therefore cannot wait
- * for it before getting the access monitoring results.
- *
  * @age is initially zero, increased for each aggregation interval, and reset
  * to zero again if the access frequency is significantly changed.  If two
  * regions are merged into a new region, both @nr_accesses and @age of the new
@@ -75,7 +66,6 @@ struct damon_region {
 	struct damon_addr_range ar;
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
-	unsigned int nr_accesses_bp;
 	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 83753a53e7b98..59a91a0ab6d45 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3630,8 +3630,7 @@ static int kdamond_fn(void *data)
 				 * aggregation, and make aggregation
 				 * information reset for all regions.  Then,
 				 * following kdamond_reset_aggregated() call
-				 * will make the region information invalid,
-				 * particularly for ->nr_accesses_bp.
+				 * will make the region information invalid.
 				 *
 				 * Reset ->next_aggregation_sis to avoid that.
 				 * It will anyway correctly updated after this
-- 
2.47.3

