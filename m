Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA68C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09896B00DE; Mon,  6 Jul 2026 10:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9E16B00E2; Mon,  6 Jul 2026 10:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D32536B00E0; Mon,  6 Jul 2026 10:19:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A707E6B00DE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 33C561C335B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:24 +0000 (UTC)
X-FDA: 84958559448.19.DA892B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A1647140007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CB+zU6z9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347562;
	b=6mn9B+lesHzhZuuFlTWkbbrAua0zXF6Zhc5F0vaL0P0Z3O3MS8oPodz/qft3SkhUqISpaa
	2QLCGEyxa+md9c/D7f56h0ffhTd8sD4mMMbWrj1eIcedkDnJzZpKHg/I/3wqNcJHGa6sxx
	VJWR4O7sbn1zfn56Rj5DbfD7errnutc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CB+zU6z9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VN5S5Hccw7DXsJXWejcoQSP8t0XO6MZCK5dhIY4HPb4=;
	b=KTXcprYVZF41qYmbFqlX9jsA3XFSD41u+34HWZAB3SuFwddQb5Z6HDpaVspK6GdonTHEkV
	+zaYre1ZvrZ/Y40B62fd/8riQEzvJgyVVrjXh6qSdJiJjtkOQxiaYBGPdmUv3u6+vAkvds
	F3jiV2UM3CdjMpmAKBh/i+r3FssbhOI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D8026138D;
	Mon,  6 Jul 2026 14:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19E71F00ACA;
	Mon,  6 Jul 2026 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347562;
	bh=VN5S5Hccw7DXsJXWejcoQSP8t0XO6MZCK5dhIY4HPb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CB+zU6z9na5QxzyFeOVEHjm4j4++wzKU5Oklr0+5bXlWtfixPIpE3D9rUdi5jqCRe
	 FNPC8diLEl95GGpbTC7MCKVT85nM4UyO9Jy7BHuera8KbmN6z7OYS6NSAYYOpJWZGl
	 drphJyr/JQZQmsOzGaSi+XAU08o+bUBXyJ07dmxKrVl3Rl3rjSDguJ1bERpglsnHef
	 ysDSMA8uMWT5+NYEN3Vjv/yPc3Y6r5ed9OzhKhENhBqPXqrCgo7O/j69Rvw0K23jkS
	 4nMAdsG0nYkj5Nok4CqXsQt2+lF7PGsXwyacsUvjayeVEQsMSmisLYxrF71IoLi0+m
	 1RH/u3ZsRXcqA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 05/16] mm/damon/core: implement damon_probe_hits_wsum()
Date: Mon,  6 Jul 2026 07:18:59 -0700
Message-ID: <20260706141912.88445-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A1647140007
X-Rspam-User: 
X-Stat-Signature: eyf6n5gdgd8jp9ooq7nyhyx7k7msdc9x
X-Rspamd-Server: rspam03
X-HE-Tag: 1783347562-47581
X-HE-Meta: U2FsdGVkX19RCqNCm79pHnW1R/rbg8QzBIaFuFuYwzUXoc0jqx7tcd159CpdbpVW6/dK5p68vpmcsZEQWYTDrs9WLGN8GiXd8UPEjDcr3hFsnzHcFh7PPv3djkK9Bsp6k5v64khJKDQEMZL1Ts7wYziWifaaG1Lw0+GVoaf3m6R4gRjhHDujYs/Eljr6QO3BZMiSaEZqCLbCUVbwghv2PvAl9AtttiAd0ni1eyI35GSVIytgVV1Oz8uv9EfSKGX2b/C+5LaZxV/79AbcY3TwYLfKRYWFRptBVbKT3MyDXfcNwAiGtWPmy8EBhlGJJiVo4G+82ocbMuRMU/6ep+a4HQzCz1vbK8t6DW3HQtn8/vljYjgsSY0HEP45T1gPs+dFNfPOTLSHYvwcHd65q4U30ZdwDUq5UGZn5pZr5uQNZFAVVisINw+n6IlwQmt6nQIsXcEG/hGwuDHdfqg2adAZWpWJhCMPd9lxJMOPo84X+tRG6JvwfP6ZnZuc20m6wrRVDA/dZMgurBiNq4AMYcbe2khGXvZbQg2vTCG95kxcfVyy86291QDiTrxt1YDcokgRytBQX9v6UMrWky8lO77RJetQTlvaohgB4NsKECyIZF5Sy+3rYmJ35pHxTgXfE2V2OUOIqrpsWlQdOJJWGC2gd+LEHfgDSBl9NGgTwc6H5RD+G+eRLErsBkPEWoT4KvvyeVoCbJUFu0aRY2RnwsHv2Sdx4b426Y9nDV6WmWbM/Pmn47zqUjW7Q7/HbugSfX3D43WEWP5rY9FZY0fjUdsjA7CchZSihatfe3NMZujGHuRZhSOzcjBJyHRmRr1DbiD7Kn7BjF+l8XXt8P6QOz2KEAzxx8d9S7G+i9nZQjGeeiB6oMUDPyoeqHIY/rSBneeBeeShc6ClJDWpCzi7NRzxU2LJFhVr3wU8UzptdKOsvWluenCcMhtwzo10Uhc5vSJPTsalIvTwtaJM+WFboZG
 llG26XnD
 /VChIvVHy2bE7TaI0K+kTAkIxsNqFJj9cMfbpgR+xJBY6ndNU4gWobdHOMLegfTH09VslYQOXq3ppLXAjw8c/H4FE8Vfn2G1GP5n+aCIfP7zYITZteihH5sPBy3sMpX72FfsTrImwxcQ64gn5cea4F5RBlH/k8+wn2w2SL5V+l6MmXQMab3hzkXdGg9hVTA5Pv6avhCa8h2nm91dSg2Jl+fbF68Ed1JHfXYdRzFyPt0Avt8t0uGoA7yIGh+xto7isU+mNha2adpIWt1/aIFOhTpP2QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When damon_probe->weight is set, the weighted sum of probe hits will be
useful.  It will be useful for not only the users but also DAMON
internal logics like regions merging.  Implement a function for
calculating it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index e1244a06ac7e4..7ecfd72cb21a2 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1012,6 +1012,8 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 		struct damon_ctx *ctx);
 unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 		struct damon_ctx *ctx);
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index e42f512d87a11..d7d1e27d767eb 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -390,6 +390,30 @@ static bool damon_is_last_region(struct damon_region *r,
 	return list_is_last(&r->list, &t->regions_list);
 }
 
+/**
+ * damon_probe_hits_wsum() - Returns probe hits weighted sum of a region.
+ * @r:		region to get the weigted sum of.
+ * @last:	if the request is for last-window agggregated probe hits.
+ * @ctx:	context of &r.
+ *
+ * Return: the weighted sum of probe hits of the region.
+ */
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+		struct damon_ctx *ctx)
+{
+	struct damon_probe *probe;
+	unsigned int sum = 0;
+	int i = 0;
+
+	damon_for_each_probe(probe, ctx) {
+		if (last)
+			sum += r->last_probe_hits[i++] * probe->weight;
+		else
+			sum += r->probe_hits[i++] * probe->weight;
+	}
+	return sum;
+}
+
 /*
  * Check whether a region is intersecting an address range
  *
-- 
2.47.3

