Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CA23C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05B816B009D; Mon,  7 Sep 2026 13:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F253B6B009F; Mon,  7 Sep 2026 13:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14276B009E; Mon,  7 Sep 2026 13:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE0466B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:12:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A78240259
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:29 +0000 (UTC)
X-FDA: 85187610018.13.D8FA9A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 95470A0007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S10ENAEz;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788801147;
	b=uO8zZTVTtSlpHZ+m6VAEo+yEWA4bJEJigS6k2Vj2NFyudKhTolP3r5GDvZ7KGaK0Lhmp8D
	JvSqVAbfOy1ywUubqBHNmcANmdcgn80dLB3zuF0G81A3C/pjtH98L0TC/fE1Dy5+w9R8hC
	+mm/zh0BxPsE6lJso49w1rwhMnGr/H0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S10ENAEz;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788801147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ILNnV2GNeZ514oIRb82a8/magMxY2v4d8tE00F50zJs=;
	b=nrZiDys6rXCPUJ0fak1+jB8580SVF7UKYmxXmqJC6SQ/pOpGrHNpeyTIPfwsCe1jeYy12w
	x7U2+RFrkX81Jr0D8Acp+b+1TSQ2DY6pdk7x0lF5eALXrlZDXtVdH0ln+DILzWWXtFS0Nb
	P/8KnzlTTwRrz3tdzqTf4KfIVybkQfE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E883C4149F;
	Mon,  7 Sep 2026 17:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30DB1F00AC4;
	Mon,  7 Sep 2026 17:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788801146;
	bh=ILNnV2GNeZ514oIRb82a8/magMxY2v4d8tE00F50zJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S10ENAEz+rTe0VzLVb8HlABccmpIU/BJbaBfKG1ypPbkRLmNGyWW5j3QOF4dslhwp
	 eRcQDIfY10Icfh+8+ZtdbSa/jUQDAbdVGBFsnEhVEaR6fyZ0/8ft9fDNCxo8MkqNhT
	 GLlzQPE0SmLLym6fL47jGYWCYATA3Cqpw0g1uH5Y+OwhVYyetS4+JHolbyIQpNOBEA
	 M1rNkmMjokbEugQw93ptF0ZOfp7S13iryzneWxE5Acq/0pEFzdRk4iWh98qbWh6tyj
	 Wl4Gh35D/5nvIfDB+5dUt0lJw/Cdyiz5LLT77848z9kYG6Z59bRpll6urXHjZq0Drn
	 qOcAJgmYObDJw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 4/7] mm/damon/sysfs-schemes: rename sysfs_filter->sz_range to range_{min,max}
Date: Mon,  7 Sep 2026 10:12:13 -0700
Message-ID: <20260907171218.101430-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171218.101430-1-sj@kernel.org>
References: <20260907171218.101430-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 95470A0007
X-Stat-Signature: ej6frxpczme8su3xp4juozu491cac3xk
X-HE-Tag: 1788801147-277220
X-HE-Meta: U2FsdGVkX1/2FhnGEW0Y+BZthplmGTKEAe8K3rbVDPxs/Zx4GgBDwZRk63jdEeo1tGd9+2cXa57Ji7f+JKfk4wFOmNAXQspoAIFEwVHHoyfTCQ2N0Zir5GzWXWZeKs+yHig6RJpwxSoK2iXK6JSbSdG4XIKPHOraKxtacj4t+i3VZAsCaQLxjKHWAJaIVT5NobyyE6KG/G8g2cDQYqN0GgG5f1M44vmIw52L2FatzPix9YvDl9dyZ6cNDb+a45vxsNfVamBNY3T0W1PforntO+QTEDVCVuH2Q5uvtitXA+v0+dwS9VHgtsBtWrkfXGaD0e4foLYlEXpqNj5xTjbP9c4UzIS0GU2zN6lwkxugPUpLBVRJNlIiSqE44xR2F63d9JObdG1OHEIQV1bIcsDWaXdpwgSuMjMYeP80Pn8pjYtHGjlN77ZbgtJZ0mOmloKZ57qC0uPnsxEg38tPhuHn7kNDrnIAwz5YzsVb7WqIA1WZGkwHZlCogiNVsPaEpxg77mgGNtxXxB92bHBPv+TKanGjr69DLnCVkBf9cL0U2oEcUB4VmHf/JwC1rSehN8myOkzgnWMK2TNyXNHcDh5Hr44jnQ0NDlR92bJIC120HRvZVem4JoYnsD7LyBRm/KXjjVRX0qafPz6pnNwiS3gWtWbpNrRgxNVZZkUZhioJEe0XwMDy5XAba/soEmfhDxWQMvoRBoSNqmMnRz6IHQ5ynSS8lEJAWkhS0E2gtIOGmRCtevbXbJ5vgGjQmPr0yEmCYpGpE2edLvyzBa3JFVjqTNKmX0CPvhyiM6cGykmTwgJp/amsmQBV/PhFWBDdFcFc/BTpdBHR4puGO3RwrkN9pMbvogyIjH/CQ57BPmVmZFtRLSHi3lsNNcEjIZUgpTXhOfc742pDEVs2gvkLrAu39rNY8iopmumXhNd1dGjH3KrG50UR8eiGXwXCngnxCdNZlhnt9b7gFdXTyV48Ycu
 W6E63OQc
 DVq8wdOz7nr/VjQX661xt0cRFZ27lJASpbl2evJfEjnUXKkbZDB/3eRmCpuDnSvhhtlYTrCk6cimAlQD2Wv5x160GoqBL3ZveTTAiQ8FyECkjwUTsmNq5i48PEYjfFA9nqXk+rhthTU0qklNYhyzC5WE3cOwUxYiMffif2FciHNHtKmO/Z1UFjjavGSiAQtfwNLqDk4BX4ewWMlAInXiiGSJhgoOQqodkBjFW3VM4QQ6aLnaqAYisLoVMq7m8dwR1CjfkF9lx0X22UNUbuhCXWhBVLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface provides 'min' and 'max' files under the DAMOS
filter directory.  The purpose is setting the general range arguments
for hugepage_size like filters that require range arguments.  So far,
hugepage_size was the only filter using it.  Hence sz_range field of
damon_sysfs_scheme_filter struct was connected to the files.

In future, we could add a new filter that can reuse the 'min' and 'max'
files.  And the filter might use a range of a type that is not size. For
example, probe_hits weighted sum.  In this case, simply reusing the
sz_range field would make it a little confusing.  Rename sz_range to
range_{min,max} to avoid such confusion.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index d9b81d7b5910e..4d9147d2a269e 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -534,7 +534,8 @@ struct damon_sysfs_scheme_filter {
 	bool allow;
 	char *memcg_path;
 	struct damon_addr_range addr_range;
-	struct damon_size_range sz_range;
+	unsigned long range_min;
+	unsigned long range_max;
 	int target_idx;
 };
 
@@ -588,6 +589,7 @@ damos_sysfs_filter_type_names[] = {
 		.type = DAMOS_FILTER_TYPE_TARGET,
 		.name = "target",
 	},
+
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -778,7 +780,7 @@ static ssize_t min_show(struct kobject *kobj,
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
 
-	return sysfs_emit(buf, "%lu\n", filter->sz_range.min);
+	return sysfs_emit(buf, "%lu\n", filter->range_min);
 }
 
 static ssize_t min_store(struct kobject *kobj,
@@ -786,7 +788,7 @@ static ssize_t min_store(struct kobject *kobj,
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
-	int err = kstrtoul(buf, 0, &filter->sz_range.min);
+	int err = kstrtoul(buf, 0, &filter->range_min);
 
 	return err ? err : count;
 }
@@ -797,7 +799,7 @@ static ssize_t max_show(struct kobject *kobj,
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
 
-	return sysfs_emit(buf, "%lu\n", filter->sz_range.max);
+	return sysfs_emit(buf, "%lu\n", filter->range_max);
 }
 
 static ssize_t max_store(struct kobject *kobj,
@@ -805,7 +807,7 @@ static ssize_t max_store(struct kobject *kobj,
 {
 	struct damon_sysfs_scheme_filter *filter = container_of(kobj,
 			struct damon_sysfs_scheme_filter, kobj);
-	int err = kstrtoul(buf, 0, &filter->sz_range.max);
+	int err = kstrtoul(buf, 0, &filter->range_max);
 
 	return err ? err : count;
 }
@@ -2835,12 +2837,13 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
-			if (sysfs_filter->sz_range.min >
-					sysfs_filter->sz_range.max) {
+			if (sysfs_filter->range_min >
+					sysfs_filter->range_max) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->sz_range = sysfs_filter->sz_range;
+			filter->sz_range.min = sysfs_filter->range_min;
+			filter->sz_range.max = sysfs_filter->range_max;
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

