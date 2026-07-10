Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43389C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81EF26B0093; Thu,  9 Jul 2026 20:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0266B0095; Thu,  9 Jul 2026 20:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BDFB6B0096; Thu,  9 Jul 2026 20:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38B546B0095
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 950091C87C8
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:02 +0000 (UTC)
X-FDA: 84970969524.03.8CBD4A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0F1EC100004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HSUTkoOH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643041;
	b=JmS1Ubbc1/2S6F09ev/233uthrHhACDZhrIi/SE4VBFMPRIFA2SYdLMT0neGNbsxEj49Rj
	Di5g+8DbhhuuWQaK1rR7v2Hq8bg1il6OMhm/VeWJlxCgxg1lr8RpeLgSZQqef+SIREdCVh
	NrmB9dJnIiMojLaZcMBnzy1LWGlIKjE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HSUTkoOH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IV0EL5uoIkcnMjmKSre6/DXBTN2a0ADkNneX2xN/Zgw=;
	b=J2VoDFRtkFsZqwps39v10oKBaKtReJWCp29n2DnyPt7FYEuAQHqHgWT4lNde9cwQaeLefK
	RI/Ix9Vie5KEXgCYYf0Ebf3TsMYMgKjmPt4GL18cdYOzrzWwZEFuQ8iOmQBNjgctvNkMpR
	i9krTE2yJlPbsMUl1yt+2rcpeOngODQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A751E61833;
	Fri, 10 Jul 2026 00:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4081F000E9;
	Fri, 10 Jul 2026 00:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643040;
	bh=IV0EL5uoIkcnMjmKSre6/DXBTN2a0ADkNneX2xN/Zgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSUTkoOH9HSk9Svfer6M1HuF05EItvDkO1cPTc/KGhCoJlkDDlXgx5Kf6Rj6xO0FT
	 WkXLc3JkLt1bIL7i2KL29tc5DRxQ2tALQsqIlwfuzymvzeL2al4Kfs7fyaQhTouiO5
	 BpQAGujo5qq/MDnsJvvSvga2grou7oKWIMRXz2oy8tE9MBa7MI7mCjnsytXGPX0xS4
	 3K8gl6LSXiy0IUFsFWiFkNJU4zVe676PpJlYsUvcwr78hepYD++YdG9bmh6w8zjThW
	 +QmevC/BQqskyc1RyT2zrEYPE/tmkc70HeJMCD7AHi9G+Yr5iTbNhxyDnn2jotGFTZ
	 MjcC5p9TnSHOw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 05/19] mm/damon/core: implement damon_probe_hits_wsum()
Date: Thu,  9 Jul 2026 17:23:31 -0700
Message-ID: <20260710002349.111414-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F1EC100004
X-Rspam-User: 
X-Stat-Signature: p6frd9bniod4x9xtd4r5e5wf647fzsta
X-Rspamd-Server: rspam03
X-HE-Tag: 1783643040-454600
X-HE-Meta: U2FsdGVkX1+ZH68XEezBAiom7E741U06CUjqw3E+5bsyb6+shkHybQuAb5USNbotDysZR7AZwfHWqSwDR//pa4F7prqlegCAy3uUA+b7CARf0PnFgUm5pnIEJt6c6ZzHXiMs94tfKR78sUcSYsb8zl3KOatPRP2EH+WjqYHV6f7XUh42NxxUIC4IaejjElShJqBolt6yHHagctZAfphJFZI6bQg6QcgClXv9pyTtsRPiP2HrVByjAJG0y+V1yDPZERwiSas+sqbZZujeJ3TiPpFqJbpbdE4FhJVU+xauoRJa7aGeRkRcHXd27W2wPm/p2tuRkTIqq6YnTUrBCGV+TN1BM8yZY6bKEv5WJoCULtF8FepALBsmP0RkJAFG6WAYbMQPMJxoC8ZP4YSE5NIOaJ7KeWbVF3RjwxeratNisa3lWmtsr9tYyJuSA1eI0fl0kTG+6tSGQP+UasuHdOzm9J1ehjilIJFAFm9fRTNEolIhUboCM27oXvnaYfLrd7AwpEtzTLtIgmzu9hlgELRLfDYuivR5+mj6Y2IkFc8/gjRSS+e1q6zbZpuMKG729Epr9udkHioRtIanC3YLH3ERb6/ID8/83WqpzGnhHOygEkXxfn2LBNiP8se1zG+bLNDpqykxgwmecfQK3roku/Tu79KPqjldvEGeGIkabp3RHKdgFxTS0a2hmo3k6n4o/bPfYhbBVvENv2fekgXbmdD/z1FgCnSjClTxr/tiAhfS5rwF9UWFzC2l33AgdgU2DIO/OTWTel8sO78kyO0LXFP3ofwuooy1GE+ACDUrzn1Nv76SK5t9f0Veifu5O1ED+1CBIN/heI+mTxqif/fJpw51MgagynKfTmbvpsCQ7x8R1ZV721eF+RSoprPynwHllLbyMVngrxjpAFz0ohXnP6xx1u6foptKHvjmFpyn8iZyVluPuamjibqgo9T0pcpCafQS3jyMlFSDYmohTgdVNT5
 E4aXzQJ9
 Upi72V2enUJ0YrdDaTxdGaF8/W/i+dqZ3sFkai711Zys1OhkkzQsrD3S2cKJzpEb2GbYTaYZxwUH21TNRZ10hqgUnGsKrpmt8hk87uM3nyE+pEQICOMvAevFY5T3TLZkxzoiir00OUq4ULocP/4vy16ElgfeMPPr99jSHxlRM6wiWOlup80fm4WIQmsAgZADNd7CXyM/P3Qv3w/ZMO6WudOuwmWWtwm2A/4ukU+y8BC5R7OPgVxaV0l/OvdHRn5v6YDzKjkmVFfW3jnSiWwx5ieU22w==
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
index e7acd8e610a64..f69442a9d4312 100644
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
index 9f6cdd810bd8a..fea97399b5754 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -393,6 +393,30 @@ static bool damon_is_last_region(struct damon_region *r,
 	return list_is_last(&r->list, &t->regions_list);
 }
 
+/**
+ * damon_probe_hits_wsum() - Returns probe hits weighted sum of a region.
+ * @r:		region to get the weighted sum of.
+ * @last:	if the request is for last-window aggregated probe hits.
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

