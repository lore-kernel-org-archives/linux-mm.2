Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 079C1CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45F426B009F; Thu, 25 Jun 2026 01:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40FE76B00A1; Thu, 25 Jun 2026 01:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335306B009F; Thu, 25 Jun 2026 01:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE8576B009F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:08:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 632F1120569
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:26 +0000 (UTC)
X-FDA: 84917254212.17.C8C6F34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C99E180008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FApY5yHx;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782364104;
	b=TnWhWvD1MFIRHa7ijBgJ9ua0FQBn/wBNzkDcDEfeQE7YJTl2r5Tl43kaYElSETMcl/nE5L
	a3dxs2Ci4WCT/iDGlmy9dTBCPOJi9yoMOgLOvHJZ0JYFufT/Gh+JgZPn+c6rW15lQ5cAFW
	q75KHKwix05ZdJaBu9RP5/dB3ZYZJlk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782364104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HI/zoVaSGKDNLoA6cct9QoJPib3MnUiHJc9KJcrjGCA=;
	b=QJatubMiuzUXX+SnPeKUzV5i4HNlpmoaMhHBg7hCrWgCwHta9X4oDrKOU7HZcMfxfkr0tH
	Ut7LG0O9aaFnf5a5pvEZXJ56fEGu/gGOdQ6batf2uBZGt9xS0krB+P+OUfYki9rUnMDyqw
	YOWisnk9bDTAxyUH8QyrY/bLsf2eKoQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FApY5yHx;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 299AF44256;
	Thu, 25 Jun 2026 05:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F93C1F000E9;
	Thu, 25 Jun 2026 05:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782364104;
	bh=HI/zoVaSGKDNLoA6cct9QoJPib3MnUiHJc9KJcrjGCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FApY5yHx2VnzsAikPyRXd5dYkWPEAFZ4YywL0MevrxyF38cAx2OvpYLxiGAc1EOQZ
	 70PDXKr12rbQGXnBVTXzxERN2r9ICCXqkxRISedsl1xgqWb6HzmPIDG2rx4PyXS4bE
	 lIBCt8zGPWVIaMB7T1GBawf0iE3ppioulTh6wmD6euIQDt5LGXmU1nrMw8gcsg2aWb
	 k+rcO4VsL4exG0zGAxGUeEoLQIUsV2ePvLPQUHBrOZUvYyyjmEmYurnwg6ks3XzLPi
	 I1zc+AqyuySctNk8wuxABzPQYgpVCTmMtyf9nlQfE5V/N35X6tPykoBCBRHKhwhu33
	 OCuCXMuOTqrHQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 08/11] mm/damon/core: reduce range setup in damon_commit_target_regions()
Date: Wed, 24 Jun 2026 22:07:51 -0700
Message-ID: <20260625050756.91115-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625050756.91115-1-sj@kernel.org>
References: <20260625050756.91115-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: rksp3ptjr6bz5we597t6zptuspgatfwo
X-Rspamd-Queue-Id: C99E180008
X-Rspamd-Server: rspam06
X-HE-Tag: 1782364104-472844
X-HE-Meta: U2FsdGVkX1+tkQ25wv64zwZhs7eepGuzqK8PzH1kll4uiB8umnilJG1FVmyMRwZGEHXA7mbiFIRNn3HyWes+fru9tizi7bq0KrZn/A9H3dQCW3d3hAWSNs7gH6/t/HfGyoXxRnXUL/IMc6V9QbGd7mheOCHbcp41m+ZCHoFAXXTmAkMv770LCLWh5D0ccTR5JBoQx7xdyg3pcL0LAFkCHvcs/CYlAN0g9IhoCRPZvOwbBmwMt3dHMF5O1SjqYPffouFmVRs97yQd/Q73NKr3U83kGCyvpV1KDqI430SzTptdaDPj9cSBuM0POp7BO7hBRpwKKYz/WMnqh4COFauwOTo7zfJGBbS4sODz+EoP4/U1N7He+L2HYi64mWDMIy7BwKwJgAjKO8H1BIOcGlMzjeZQEENOk2dPHXFfV0ThGFF/6M641rI7SJo/PO/PH7C1eLIZ9MIMv8//XG0HH5Tich47ybO9f2w9IOcCxLsdihW+ShpK1Fp1bEtW6oc1JubdTdXOllmETT+YBSXHPlXQzWoOQ+odD2tTUt2mPO8s4My81IiW4KgrlSz+7HszD/jtmZ3DJKkWFrjFlhi5Kn3rKZS1ebYV1AMcMerFfRnbUJ3FlzuiMa/AuZnDZSssxHJNiLkFkOffFeBLqjFva+bGrkOOyjn8ZakeGScomxD8UKpCVjDb7fUtlF8zgU8V6EwmNAe4ZfC8VqqtRNwSJyyJrw821p6+eCjN/N0WfF7JrNylCfzxk1E0KJNBEion6DPBzGxmqqVa2SOxiY1hqPXZdcaQXXAwTPthFDS2guwHA7OPvshQO22W+Z/i8E4kaZHFcP4GUqZ1Qojfd/DRYwkR2lDYXYozgpdlOvW6y1q0zXbbZAaW3OoEeAKNap435XqPRGtuhVxvYtPlJItHsIe2IAB1ylVbnIG0hGAg66HSuTBbNjcnTWExBVc2wnaUHWkpibBQuRC8dK27qOeiJ0x
 jEk298MP
 f117zrAgB3sX/l5Jv9M7t/l7VsNvQ8Ee1fFRIYQeOfKLQgWllVZZnQs+ODcrNhXwT0uFulpsaV4xhofvVtlpgE4w45rzQBdJmOh8npaMUs0ZhQeHADAZ1SDpiqTZKwFje+DrSHd2uiObZeK7/iaagkgG/T+Y+hj0v3LjHgKQ1IeO8pnacbFgDCAluTrFPF4wM00r03p2ZRurLWEeLC9tJng/BYTkyAHDuwv3BVDoF5CVkhsAYA90Q80WXUEDEQxEw6K1VrWb9tzLYxTBSP8bEm5GBupAfP5gLjJTqCJGlqUgcomg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_target_regions() calls damon_set_regions() for updating the
destination target's monitoring target region boundaries.  It sets the
boundaries same to source target's monitoring regions, even if they are
adjacent.  Meanwhile, damon_set_region() sets the destination target
regions exactly the same to the source, only when the target regions are
empty.  When there are existing target regions, only a few regions are
expanded or shrunk to fit on only the boundaries for disjoint regions in
the source.  Hence the adjacent source ranges mean nothing in common
cases.  When there are many regions, such adjacent range setup is only a
waste of time and space.  We recently found [1] it is actually causing
memory overhead.  Setup the ranges for only distinct ranges.

[1] https://lore.kernel.org/20260603112306.58490-1-akinobu.mita@gmail.com

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7e4b9affc5b06..ce5294cb1b4f3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1349,21 +1349,33 @@ static struct damon_target *damon_nth_target(int n, struct damon_ctx *ctx)
 static int damon_commit_target_regions(struct damon_target *dst,
 		struct damon_target *src, unsigned long src_min_region_sz)
 {
-	struct damon_region *src_region;
+	struct damon_region *src_region, *prev = NULL;
 	struct damon_addr_range *ranges;
 	int i = 0, err;
 
-	damon_for_each_region(src_region, src)
-		i++;
+	damon_for_each_region(src_region, src) {
+		if (!prev || prev->ar.end != src_region->ar.start)
+			i++;
+		prev = src_region;
+	}
 	if (!i)
 		return 0;
 
 	ranges = kmalloc_objs(*ranges, i, GFP_KERNEL | __GFP_NOWARN);
 	if (!ranges)
 		return -ENOMEM;
+	prev = NULL;
 	i = 0;
-	damon_for_each_region(src_region, src)
-		ranges[i++] = src_region->ar;
+	damon_for_each_region(src_region, src) {
+		if (!prev) {
+			ranges[i].start = src_region->ar.start;
+		} else if (prev->ar.end != src_region->ar.start) {
+			ranges[i++].end = prev->ar.end;
+			ranges[i].start = src_region->ar.start;
+		}
+		prev = src_region;
+	}
+	ranges[i++].end = damon_last_region(src)->ar.end;
 	err = damon_set_regions(dst, ranges, i, src_min_region_sz);
 	kfree(ranges);
 	return err;
-- 
2.47.3

