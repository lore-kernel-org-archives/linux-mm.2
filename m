Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F95CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8CC26B00AB; Mon, 18 May 2026 19:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEFEC6B00AD; Mon, 18 May 2026 19:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACE746B00AC; Mon, 18 May 2026 19:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8BFA76B00A9
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 46E7740B1C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:28 +0000 (UTC)
X-FDA: 84782164656.01.60AE83E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id BBADEA0007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LzT2B5OG;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmjaAJeRfYO4mokx4srusYqLbaN5bJvfTqZq/exAgx4=;
	b=HV1K6AVw2gIrPNZeTIg9RSiMa7FUz5Po6mZYU07fqTqyGXHPW/TFvr0UWQTkjQ7iT2uuB3
	Blz23j0dy9kCwqQzJfMjxhJ9mX1Z0J1JbFNvBk0+wZrhseNlz8DPfWQjqmX/omy+d+a7lX
	JebvFym8MHaRsP9EOzMcI3AlHhmo5LI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LzT2B5OG;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147686; a=rsa-sha256;
	cv=none;
	b=TxC34TJd73xVi8MFT0u4lOAOJpXwAlS0JwK37J1/f4esbwuupXybjjaWE6UWAie5qMBY6R
	vkzll1xLlP7d7weY988FD4rtH1mYKjBCjhriU4EvQhaamALvUaussggOxYaiQWyJuK3L1A
	8i8tv2mDpn2joZZB+vGZ1iIrOWzeX2M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 450E2601E2;
	Mon, 18 May 2026 23:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EEDC2BCB7;
	Mon, 18 May 2026 23:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147686;
	bh=bFwyAkRlbSFnPcn2Zfz8Cw3kNquyafjVVoSte7BT/A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzT2B5OGWVhM6vAI/ZvXSIwb2csxeZ0L+L4eExWE8BlEiYxpultu72EMZcoLHfd6g
	 te6ZppepUwfP+VkZrELQpy+niKvkH3KjJjkt4dw55AUPuOSLiNn/hoYK3hjl0gRYJP
	 K1jvrYUASEWvFUOyCEg1keJE/akizF5DKo2bjW2SPClb/91IA9OGZ1SzHFFGAPYplb
	 fj4OpGpGQkMSwpPLZhZBe097JRS/uFj5TbQ/uGOSPddNkOmYsRGACqEbCVjkKUpE+/
	 auWI5dwWoSyYPF3aphwlI/gwp9CemEpe8IpvcDe3de6MRbjl0gsSfN2znMFAzOcbmT
	 yx4EbJItohhxg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/28] mm/damon/core: introduce damon_ops->apply_probes
Date: Mon, 18 May 2026 16:40:54 -0700
Message-ID: <20260518234119.97569-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BBADEA0007
X-Rspamd-Server: rspam06
X-Stat-Signature: uyem1oki6xqj8e1sfxq4j7o3nfgniyju
X-HE-Tag: 1779147686-143465
X-HE-Meta: U2FsdGVkX19LgCOeVweR3uxd9SGNP/LdUtTUYbQuGEfTIDj7m+Y/ESciJtyz5tZz65Db8kOogTG+eTmqPM9Hgv31oz0I7toesWVAz8/CgiyhgPL9LjPAduBL6AvI1oeNliuW2IzD3ERjI1zhMI6NgUyBlmaZzHmkWycDoDKZUPmpgnAu91num/G0t/zrL3O2vK/jWjehho/0lENonYGYhodttRIlABgPFr5J9hbXzN4ZTmvgqHU+SuXS5vQsjvvtuxJxseIOHrxGKzXw0j1f+A2pdjANsqw/axqI0P17uWC1MOB4X9x4ZcXXa+QddYAPmkmeBzgl4iFIs9tFS964nZ4M5ZlHdbkqYG7Qe/jChAiW4Tix8o3oOj2kCsRiybwkFSUVuR8f0UV/gnjq6KwYyZdNJreQgnX/njrzK84fuzWFHpZbITqNnUxUC+A2A57kYutFFr3NbNeto4+4nXCF0Z2l/wZqsjHIlvo76ffqUDoIUsByv2VF+lu41NaiPAFS7Y7diKAvxap8HxbHcdVUBzClbNHyCJwnUdZ2A84bF90Zf5TVo8Tk0RyiIBKys9zOIj8P+lsVWt4zMXOjHTQ/P+BHCEDG8ITyR2lrC+i0k56S3RQh4aGsap+emwUqZAEDaqltlFgX/savjeMhpHR4w7HQcF6kPHOGY1Jb2a6afxmMPyotueUXAQisdHE5i1N3ujLd9vonkvJCH0N96zAlS2UogzFE0gX6rfILGR/l6GmSN0fwUMQWqtidXh9AdljR473L5zdstJcS5pXdhNCpySkh34wao+CQjn6mGmyCB7BtQu2AFK5ZWMMJIciOtOdvPnHIP3PYJ+fvhC9Pst1OH42ic4ofTdKVa1Q+uqETK4tA2nAizPpF7nYF0nbnbskSpkEUvVKfIYmCrvhlHScFO4ixPompkRMSxL8snY3n+m83J7gY3cJdBuOnOWhfkUpNZSeHYAzaXH3KduQzDm8
 g5IwEyLN
 ib27vQjIND0i5FvtEaKS/i7MwxB5QUbWOFpY17I2h1gU2Kb90WczBjhngOoAqxr9uwqLP4+4U14x42Gw10/T9G1rh0jrEO58TAcQnnBa+vIvDUfHz59PrEEm+WHCnEqPSdZHOeATnaLFmlNKqivyYDlO9Ug7D/wI4I+jzpFnABmMz0FxoGHR9uxNP1t2SrIwg1gzooxfG6r1FaAFefRROrmUUuS58bCoze17aDcMPb0cskB5wXCyhpUanD870QSHc5+Tq1CWukAgC+SKeHJ4vHZA6tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damon_operations struct with a new callback, namely apply_probes.
The callback will be invoked for data attributes monitoring.  More
specifically, the callback will apply damon_probe objects to each region
and update the per-region per-probe counters for the number of
encountered probe-positive samples.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3a30af119ac6e..1fb271a35e98f 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -630,6 +630,7 @@ enum damon_ops_id {
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
+ * @apply_probes:		Apply probes for each region.
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
@@ -656,6 +657,8 @@ enum damon_ops_id {
  * last preparation and update the number of observed accesses of each region.
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
+ * @apply_probes should apply the data attribute probes to each region and
+ * accordingly update the probe hits counter of the region.
  * @get_scheme_score should return the priority score of a region for a scheme
  * as an integer in [0, &DAMOS_MAX_SCORE].
  * @apply_scheme is called from @kdamond when a region for user provided
@@ -673,6 +676,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
+	void (*apply_probes)(struct damon_ctx *context);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
-- 
2.47.3

