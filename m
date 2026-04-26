Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2473FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36D156B00A0; Sun, 26 Apr 2026 16:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271136B009F; Sun, 26 Apr 2026 16:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13FE16B00A3; Sun, 26 Apr 2026 16:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1F4F6B00A0
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B078C1605DE
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:41 +0000 (UTC)
X-FDA: 84701905722.17.97FA434
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3382FA0002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ie4ISYBB;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PPW+FBt4/oyQ+qgiab6aiflx3o7j0lrc33DaAY2POc=;
	b=armveH2mk0xq29GQV6tvHx9DRA1b+8Wrb+5uY5YXHU5QACjBCuBuczHP2ozI9oCQcneq90
	q4r7808K/a9v2xvBwKlOZq8kZseiHL3U39dumfKXltCg2ILvobfXN+56Jq2sr/2+W8G3PR
	iYwVcKhLwVLww4on6qXKYCwK9M8SAf8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ie4ISYBB;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236760; a=rsa-sha256;
	cv=none;
	b=ORBx0YHDk3EGSs5Clij4YSSfLNKaIS987yXqetmU7iKW4oHWXEPiRqDsR4uaxlFj9CpLEw
	1/q9botn6EQiozY/7nKVUWhJmbsfL3AbSk+IR9C1fFaM2CJeAm4AW0HmHgPWFyIFqEZMIu
	rG60kp53VzTjvBeOxf4xSqsJ5WgWns0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BA2F0601EE;
	Sun, 26 Apr 2026 20:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428E7C2BCB6;
	Sun, 26 Apr 2026 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236759;
	bh=YkBI5K8l4kX9GxDYWU0L93ohTAXKAjjCaL6+mqVkPmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ie4ISYBBbYbks+BRWXlN8FTrrPZPAbU077AJgFANVwD/kLYdI1OgtmoZX+j8cajXU
	 b8rTYtiHOyYBocsuvSOcK72XG9M634CHBkY7D0t8eQHTgeiVa0ISodBBRt8OipRSDN
	 3zzJvgUYWBzCz26Luodu113b196lFHXF/lyNV6jIaeXpZRnYLUFRFhdeoWCm+tcSFs
	 z73AvTRrN+na2Qbp6lsj0GUCbcodwiDNYtjPcVD32hpG/WSmDamlmRDCm8VTVwdzF4
	 WAQZa0E9do+5y+CKpKG2+JoWKlGIycRjypC0f5UVNs569nhKhuRGuZCEIi2mg309o5
	 ksNHeCcJQq6Tg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 14/19] mm/damon/sysfs: setup probes on DAMON core API parameters
Date: Sun, 26 Apr 2026 13:52:15 -0700
Message-ID: <20260426205222.93895-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: swkjagirzcwyj8hedx8p8g3fm8af5bdn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3382FA0002
X-Rspam-User: 
X-HE-Tag: 1777236760-27849
X-HE-Meta: U2FsdGVkX1+Ck1CBOi2ucHev8j8f3qC5EwDMMxgcw8uO012AHDXXIoRkKFmUxHvUL96xhefYO22tMmM+oEpV3ZdtcWOn9Fay21Nq6MGP4g9LZnMgT42iPLw92xzX/PrZiOpIaV7uzazfGIm6QTHj4ICW1aROuH6N1EZmegO3/nqWmaR29WMT4fM949I+d38V7kF/fDrNqMYMscoxfy5G7y09ZTd8WvhvQxJ1zWkc5UYpxcVWAhJrDKLCX7oFEkkCFfa2/PS7eqySiNBV9+5g40w8SVxVHRJD8FUGa7w2Wj98iybtWK7fYp/bAmG0ucOxTm7f+Nw7Lh7H17jXgewjWo9Uw/G2NLvNosxO69sekaksJiduaN+ukNPIYguXgfcfGfUKHj42jVq8LjYX3iGHPC2BcYeDhO8i9bn0Zq1R8MQiwmX2kdLAS/Ik9Do8OuHGR6+5gpozqY2l3ZMhaQXMaiwZomDDwWn44rDtKUBrbJHvZiCgRIbRd+BI0D+rVH/E4THDrCR08jr1SvJqZBzaHE38/lVizTlFL37x65hfic18nOCwXstV6AkUGZnLBL8szYuxOABPa1PVRRaPvVEeHnmbVxMdOf5CzIoZLpXUiDtZsGrIkG9DCBRK1YHg+lGON/LjyPpbymB2HRqepBgu/BpSw5KgfwnQRAH7oo24mL88Buqf1FwDnvJo0UV74Yo1YLKxVr0ULJpyAPG2SPr57cBGAFnrj/avuTur2gr6TagfRuOR7E9kDmPrsoUUwWkE5cTybKtuKlggp3aaeAj66FVaMeNZ8IKrNIci468ecDchpKPN01ofUwtOeBUrorbwQwdE/gEteS3Yja8ubEpvtPVrREGeN+yblCGdV0kKDePXt/+TkQURX2KS+oXkZxg6QXy4QcNfxVa3za8VeE1rAPRcPNNt7Q6ofeNtA4DdGWe87oVG7q32W0QTX6obGtqksK4gOkdCmWLYkvuc6gh
 kQmQrL6r
 U8E693dh3MY5Ad+uNMIfZ5UEclgTV7CkjM7gFGM4e/uglmHP/aMm1kXEo5liOqxWuVdnyEYlX1XPY2LRdKm2Ge/ZKsn6y5Q6fEf6c4qRPDVv6WXvjNOfV8YSIVTC7uQ3OVt2MRoGtOwVTFspN2TfknuH+ONywkzB6eX31mHGhqpOSsDq2JwRyy/P+Ue/LVZDxIUBtzeTrv/XQhS5/wjxaSxJVha4KLaWufUCE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add user-installed data probes to DAMON core API parameters, so that
user inputs for data probes are passed to DAMON core.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 2e0b7eca6bcbf..8007961295d3d 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1855,6 +1855,40 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
+static int damon_sysfs_set_probes(struct damon_ctx *ctx,
+		struct damon_sysfs_probes *sys_probes)
+{
+	int i;
+
+	for (i = 0; i < sys_probes->nr; i++) {
+		struct damon_sysfs_filters *sys_filters =
+			sys_probes->probes_arr[i]->filters;
+		struct damon_probe *c;
+		int j;
+
+		if (!sys_filters)
+			continue;
+		c = damon_new_probe();
+		if (!c)
+			return -ENOMEM;
+		damon_add_probe(ctx, c);
+
+		for (j = 0; j < sys_filters->nr; j++) {
+			struct damon_sysfs_filter *sys_filter =
+				sys_filters->filters_arr[j];
+			struct damon_filter *t;
+
+			t = damon_new_filter(sys_filter->type,
+					sys_filter->matching,
+					sys_filter->allow);
+			if (!t)
+				return -ENOMEM;
+			damon_add_filter(c, t);
+		}
+	}
+	return 0;
+}
+
 static int damon_sysfs_set_regions(struct damon_target *t,
 		struct damon_sysfs_regions *sysfs_regions,
 		unsigned long min_region_sz)
@@ -1967,6 +2001,9 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
 	ctx->pause = sys_ctx->pause;
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
+	if (err)
+		return err;
+	err = damon_sysfs_set_probes(ctx, sys_ctx->attrs->probes);
 	if (err)
 		return err;
 	err = damon_sysfs_add_targets(ctx, sys_ctx->targets);
-- 
2.47.3

