Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61DFECD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99EA56B0093; Wed, 20 May 2026 23:54:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D98E6B0098; Wed, 20 May 2026 23:54:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752426B0093; Wed, 20 May 2026 23:54:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 544626B0093
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1BBBFC111D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:04 +0000 (UTC)
X-FDA: 84790058808.27.B502803
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8A3A7C000E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GS5+7yZj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFIspApNE5pg+37NC/h+0JPjyuQa8BCwW93puC6WNUA=;
	b=v0Kq9OmahKrqagcfpvuoN5pkQrs3Tqxqd86D4CI68heZ1v64BxUpUHdl9PfQlc6VOMSlUD
	xjn9uBYm5dBwTooWmZcKZGGgdK8d6e5A8pC8hhVXFAKIVUaNlAF0eORhUJWau+go1GJEV9
	Y4wb4T7jCw61lJbnfg116+lBw2n+tD4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335642; a=rsa-sha256;
	cv=none;
	b=0l6ICi0gH0NprVwJPXGTB2M0iA/gk2DfLmjO5LLMYk4PW+PJbXWiijlRABGlgFNYJbSLIZ
	P50ZlLX0VMxsddecvTuJQp7BEygidvu9KlZ92TXnWM50+3rEaP4FRAhZ1FxHLOX6TKNyQf
	Cia9Oacrid6a3lFDCVRlsNOFLprX2wo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GS5+7yZj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA36742A4F;
	Thu, 21 May 2026 03:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781701F000E9;
	Thu, 21 May 2026 03:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335641;
	bh=lFIspApNE5pg+37NC/h+0JPjyuQa8BCwW93puC6WNUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GS5+7yZjHYzX7LCTWtc/L6DB9/sG5kpJFCaI7/n5532/xEpMUQ8vgusEhPmw7T2Ma
	 gBPdS0RgSBPhffmGarsfwajErtI2+tb2ODKgAFSfcDtYQ4WMLPPr5uc3HCP/tZYZE1
	 6+3MGEsi7xrtaMlgdqYEkfRy7TyWmS4KE8osSF5a3BMXvVIbLyvZ7TmsDG2stvNLhP
	 HmnR7JOFKL5lKIQV1VaoBM41k1OK1A94XvD8NktytC3BzXx4DLMKS5mQCbJ7gD3/6S
	 brlslJnwCdkRf1omQA0OVgU1F72nIht+f6FCkgL7nPa+9vXyDL9EDwZmYEdITHqzZV
	 57NIIx8CleC9A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 05/14] mm/damon/core: hide damon_add_region()
Date: Wed, 20 May 2026 20:53:39 -0700
Message-ID: <20260521035349.87565-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521035349.87565-1-sj@kernel.org>
References: <20260521035349.87565-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A3A7C000E
X-Rspamd-Server: rspam04
X-Stat-Signature: 3paq7xczqfy11nnncbchucaz5tojq4r9
X-HE-Tag: 1779335642-677490
X-HE-Meta: U2FsdGVkX18gdoMF4gWUnS7aw4L6rercq1fRX2O/sTxCMVd3VXm/fHu0nlLkXa8Xb6Ytfh6ueVTpSbpY3x9QthksiMgUCnmiVKoJ7ms4HhZqzRmKQhPE9qWOKZU3bQ7YfXYJFrOGAZd9OJ3TBbEHV1SHDg3GeSCwBs7zYGfoMcrUd8MRyNHSmCabUNFxViVz4PDcivqjGaxZOMSIEZupjkTPAFuwfEGbPBhKlmbszIYBT/tSbiVsqnhfNpipt4X3RpY9ylCrMc2gYTJHoA/KZtQwg15E7OaTAHpKF5y0qHboW+VjOUPSfuxa+bSurZXYnaZ6E/pbjL1RSmeLxgrrG7O0WW+SWL1fInCGXph6y3SjXpfgPv9ttIXCzRyeEOSx/cZufAcCkGbPfa0/wGLESmfCHyC6BMxEX2Hh+yvTCV2jkkLagsFwoRN/Q0wODgHFjSPeUdny4d4WLk/ZDYy/zPZC45p/dncU0pZ8DiNup23Ok3FHMakyOL9D/cc7Nxd3+LCWEfDy7SG7vyPkYRksDee8xUjMK+RBxOpwsHDL9JVRMd3uZwjK4OWWO29np9uhbTM6U3GXHQxnleFuab/B3/AuVdClskuAAcvzMxVGv2j3tbA0ZILpy8qlIKhob55AWXbimNuyRF2O5qMI3020uVuZfzvoeAa5J8hyy9A7mYX7BzW56ql4vcve4M8p1rMxeXcq/uROQqU6c5vI2ruuJt+lcbdMpuFRQ+ZENnqp8WtBBgqKAm+CgeKwV/97LgALOhpKgTOop0IL+M67flryU3lLnb35fY4AunRLtWkKS/sUgQ4tDvBbQMIfDxKOr5s5QYiDXjhHgndcEAYFGAHUx+RovXBHAQtMR500SicG2v+5l2hICFBcolwQvY+zQT211FUOje3plFenCWfVJ60U2UtvV+4HN4vWSOI0LfeTS0jZCMVAwfga9nfYTj75eI/DxF0gRFby4II12Yjjffg
 qTl5YhQ6
 /j6IQfPUuFQBFrGhPMynHJHZSSUrr7La/GU0/o4jzEaIth0C+8jnEmk3GzsrXX+UL/EdFgl4JEAskY05n1Lo7XPTWB34lR0g1M+Y78VwfwHirlldaKnnG35jzy1qPt6pkj0WM26qRwPcXfm95EI4g5jtbXm/fjIMW7KuvP8qq44RsdPCMNWjBTx/bxajryJ4iS50YfWlGLJz2prKHcjTpOSQYz/8J8wQ4ce5Kjp6m1ofNFmg8jBusdYhXwcH2uCy6Y5FmeRYPi5MNbYp/hZGPJu0P6P3FZ5abaYoF7jpJdstNCg53Ex/p7magPDLmfPSD6YBl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_add_region() is being used by only DAMON core, but exposed to
DAMON API callers.  Exposing something that is not really being used by
others will only increase the maintenance cost.  Hide it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 1 -
 mm/damon/core.c       | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4014fd0d463cb..b9370c1779cba 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1024,7 +1024,6 @@ static inline void damon_insert_region(struct damon_region *r,
 	t->nr_regions++;
 }
 
-void damon_add_region(struct damon_region *r, struct damon_target *t);
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index e8cf3632115e5..7d1de6ff54eba 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -250,7 +250,7 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	return region;
 }
 
-void damon_add_region(struct damon_region *r, struct damon_target *t)
+static void damon_add_region(struct damon_region *r, struct damon_target *t)
 {
 	list_add_tail(&r->list, &t->regions_list);
 	t->nr_regions++;
-- 
2.47.3

