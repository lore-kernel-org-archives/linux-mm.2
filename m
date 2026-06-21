Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77213CD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CB7B6B00A6; Sun, 21 Jun 2026 11:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E006B00A7; Sun, 21 Jun 2026 11:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497A06B00A8; Sun, 21 Jun 2026 11:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B45B6B00A6
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8AF9B8E1BA
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:47 +0000 (UTC)
X-FDA: 84904375374.28.F03536B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id F3FFD180003
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=edHHNkAl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azqsIyPcBSXEM0jexqRTWeoPRmDH/XuigFj32Ye/QlY=;
	b=vgwyxTW9iRjEka1C1Wkbym25S0O0DOJ06r99JK+jXJdt8b++ZPJssT5ufBLfwigKbz9ZSQ
	4QOsODoqocsu19kPzk+QbGGOrMT4QUmgaq8vMihCQUXrDMe9y++m8Dy18AGCVkRIDOF237
	qhSVXe5rp3acP+rCGfTxjgom4SUi4oo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057466;
	b=jkBmC1HTiczgVKBg6XtVU/DE/ZEoMQkX8riM5i/rbRHyPMKZjUTXH/W75cVLTBPsFtqCX8
	OzCgMLPwmjbPXbPsd15uhkPfvJX++MDJ7F2yBl8TsKNqwv5V7u7HaqnZar2a5duVyl0dkT
	gBakloo9yxlEiQ5TUlTL0zMWLs1kd5c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=edHHNkAl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 55F644443A;
	Sun, 21 Jun 2026 15:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C021F00A3D;
	Sun, 21 Jun 2026 15:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057465;
	bh=azqsIyPcBSXEM0jexqRTWeoPRmDH/XuigFj32Ye/QlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=edHHNkAlFNSvSaPLtTiXE7cecwcR4T2dh7V8JGEnT9YrHTRXcVklh362/8j99fclX
	 ddEyALknb/I7emPxDA3QomMcJIZuzI85Eg2uCGCYHNsXy7JmL/guNFnz+IUOBnzrgo
	 CKGm7MtgbxtgUc8/QAIfao9HtfsOATQXkIZEzKZeCqTjf6FxAkixRFXisWm1do5ya1
	 F1kgmG2pGuyx7SJnB5dW4IYzlOERZYly61Ag0xjUWzIvg6RUr3VOu24okIr1F5Z/9c
	 6dKV/j6MQNet8YNlniDbPWy3xRnSpW5N7nieA/7B7DGDApyLnTmGDFzu3nRp69KaF6
	 +4yxILtuEzInw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 17/17] mm/damon: remove damon_region->nr_accesses_bp
Date: Sun, 21 Jun 2026 08:57:13 -0700
Message-ID: <20260621155715.87932-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: b9h86sp57wjk6ok7bwnw8dreeaanx5ud
X-Rspamd-Queue-Id: F3FFD180003
X-Rspam-User: 
X-HE-Tag: 1782057465-189250
X-HE-Meta: U2FsdGVkX19tv1Ka1MKZkbAchrFQT794vyGlEt0TMC+dWN4ZGQg1tNQk+8Uzn3c3eemfupjF5UMmTX8N+HtaqeI7MeZblvmSw7eySNBk5nlGoHNE0CAVnnN3occ7olPd9NEItJw02Uw+psADv3qnAf5z3wRAYAzX2bt9IL20Zjbw0jM2tSoLV55CdtzGuaRSj9Hw+zglR0rvnhpnqi6Z0h5+nozS1TPZvjAzmDL7MLfN1Xe8unxrrMX3ezCho1jI+D+tV6ZlChrDbpVJwUCIE6cXRB8gH1p1e2dlER0S8e1I4Pswc6lbNw0aOFgLZ4iNWUq7N0hvepdxxAqyEZInrj5s8wJs6dKnxdPd0XIf8gksdrcntQUQA7rIH/MXYNaWPxBYskm95x10Rfsw0HTJeC//bhStcwBnN2GoAfdzzcnAZaOWlT7kokPuP6xlSn3CCyWbp42NhQaTtSmyep1PjAe/LlK1eE4UJ1vElO5kngLOonh/O8YjzanHpT08h0Vc6qdgqPVEq3WUqhrf03lHJYDOX8USQXF7S8wMH/uwOjSBMroVWOcnUfsnbmkA8DYOoW/zZ8DU9EtsB/xHxDiY4O+mNIT3ye4AQp/RxeG3hcsj8Td87hXw/9wY6PCkqQvd0tT/ZCZbs/uyJavS+GYxglyFd2sPumc3JTbhBMKTxmezu0+pZQCBOn5oJXPgPJNOUsuq3RCGQE5Nf+t58MiOMa5buQPIs8o0AGn28QX4vIpxQXm/awhcMpNPbZhjFzlF/1QKl6YqC4OGV4ZUg2HK/hAwKYw6BELfVRo5drVppagLnOlZpU1Cc2WGewkWmAVohlTLZ+DWS0W0Ah6HhQP+NiY7+PxAObvmqJp8LaKzDVkitIyFwHH+3vwbGwSYqaT577ynW6yoNgEYIENZlneGYyw58TpfFC/FUAJMNzr+ZhVcyOtM57VsLWpdVhU8X78/u0JR24jFaEAEQi4uWv+
 eoaYD8Oc
 3fggnneBQWDw+Iczfm02pGi3vWOW7bimLk4i64ndBPhtIz+cqPEc7LkQ/Y9+cl51SvdfdEpUXV+QyYKBUVey1VkuYZGB0zyt5oiwp89JM7bBfv787azOhyHlLUBF+Iu/5d7059Qs8E/RBmSdXenry9XBfXG7z0UI/2pTuBOc2WJLTX3F/ICP+symYAyishlV8+H5LlOLR6UZwxR6673CDzddEi7JwzXdQNjuAzTwOT5llJ8ypmRgYeOzeiJ6nIeN9h5n5GEuGxYQyIKv4mypqQMJdcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No code touches damon_region->nr_accesses_bp field.  Remove it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 10 ----------
 mm/damon/core.c       |  3 +--
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index a09ee8a09b5af..fc3d467dc2e34 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -47,8 +47,6 @@ struct damon_size_range {
  * @ar:			The address range of the region.
  * @sampling_addr:	Address of the sample for the next access check.
  * @nr_accesses:	Access frequency of this region.
- * @nr_accesses_bp:	@nr_accesses in basis point (0.01%) that updated for
- *			each sampling interval.
  * @probe_hits:		Number of probe-positive region samples.
  * @list:		List head for siblings.
  * @age:		Age of this region.
@@ -61,13 +59,6 @@ struct damon_size_range {
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
@@ -77,7 +68,6 @@ struct damon_region {
 	struct damon_addr_range ar;
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
-	unsigned int nr_accesses_bp;
 	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6542ebf13d4d8..8d3b720f774f6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3584,8 +3584,7 @@ static int kdamond_fn(void *data)
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

