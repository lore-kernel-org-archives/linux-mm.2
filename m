Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D9FC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858E36B008A; Wed,  8 Jul 2026 04:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 830566B00A4; Wed,  8 Jul 2026 04:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727726B008A; Wed,  8 Jul 2026 04:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44B156B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:01:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AAC9F90C06
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:01:24 +0000 (UTC)
X-FDA: 84964864488.07.7B815F9
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id F2A664000D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:01:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sVZtVJu+;
	spf=pass (imf17.hostedemail.com: domain of lgs201920130244@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=lgs201920130244@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783497683;
	b=pN3o0i4YtgPcXp5Mhz4XdxPd/1KH69KlClF+WYxUyBYZJIh0LIKHo84gTuu5BuKBG9ddKw
	Pca3YsK6rVg5V0wzJlqmyGJlmjJ6QZPs9JPwfurKzapUHjLW595aQacDnR/paYHz4VirSG
	8MhD2G1eLnRgFaQVmXYkr2hLcnTCdNg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sVZtVJu+;
	spf=pass (imf17.hostedemail.com: domain of lgs201920130244@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=lgs201920130244@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783497682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GSvkn80MrAt5cl0VSMEKjTET3Rwq+Bm6+Heg6Nd7va8=;
	b=G+xl1LrxUclM/qxJmwra8HMonLsDub8J+PmLRCvI+qr4z+p+ZioR89K4tmDpDBifMUNY7R
	2O+qGPnNQ/y0Br3SKMTvWKN+tyzG3z1ZpgaaU0unmLpu3aU4SqoKqg+VvbAiTaMwD6O85I
	BkYNhnw2T2RYsTQ60LFrO8SviGWZwbc=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cacb8416a1so3549605ad.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 01:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783497682; x=1784102482; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GSvkn80MrAt5cl0VSMEKjTET3Rwq+Bm6+Heg6Nd7va8=;
        b=sVZtVJu+4gggQMLKk16FgdqJrCBFXRcik46IJRmimc8p+hSTOZA/TsW1fPZtanbfEO
         c2QDJAMmn13z3PSqMUHsBzRWYh4ax8mlJQsUvvyaIFFngmUZtG7gB4/GrPrZ+P+JLFkX
         kjSZpYVEEfhqwK9m+FIS9wJGzS/wp8nJDnKyBHn49uI5G2SPqJJnEWuUnZ9FVWIz5baF
         xxVDA3KMj6ahVjNflkd1x3ARPUS1EakpVu4KzFc6EUvQeLjXVkmLyPPQep+6BO+JkuH0
         a5YmIaV0s356owcYm9pqR9ytbK2lQTkdMIPEhev99EwL5AB7u1+nii0CdHH5V5x3PU0w
         4P5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783497682; x=1784102482;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GSvkn80MrAt5cl0VSMEKjTET3Rwq+Bm6+Heg6Nd7va8=;
        b=eD3WT/S1eU4ZG/+5zu1euWN3GDhk/LdRLhQE5is7Nvy3nq88kb3yKh45o8G2I8/GJI
         QYBOcWCqunWxHDj0dfcNpRxcDsU/9wqfkco9uzpjJDSlIX8p9/vVpqNqvIKAY+Ie6H0+
         c11XTT2UsXHcO0NbsNwY2zVnx/sa8C/pipQsmmRQp5QQQecQ/p+j4psFHVCVPk44oGIy
         q7eXSPCgQtbnvGzLsxuSQJkD72xczFLVU+AsPgRagUnCzi2N1yswYYh90saAfY6jhIl3
         6xIFfwPYJLzQ7b8jOtcxpSBIQucGH6XyyMq6bnHzJw5vQrvGZpbRrDiBJXAafBCOmzD1
         r/sA==
X-Forwarded-Encrypted: i=1; AHgh+RrU7AnKiS6CSnWhBF7d7h1dFrmM2g17113KmTzO7MznX+oR2K2uWili361SH7rqcMQwDpuEzm6q9Q==@kvack.org
X-Gm-Message-State: AOJu0Yx9mQYteV6qdwCzG07GDIBYnMKE5Jx3vcjTUdQybvBAR04uqTZf
	gN/7BUwbjVS7h8p2LB0eozW9wlVH8OKibsEiQbiONPT4z9DV2RvQBD9H
X-Gm-Gg: AfdE7cllYjpM/yTmfwerx+LKQ+iNpwJ3eARQz6Vs60SWhTTAxV+eoKtRJuA90j9erh3
	Bs1OLH91oflYnesTEVrLbqJwOroXrDPU9qUZGkuxp/oJGiDZIuk+Nuw0iMl7KE2V9k2qB0HiMsr
	wFdapeW93M/dhrUE5CmeV5jb05uO6GEaq5rN0MLsRjYKT2NeXq3MSQQMxfxgrmo34KHecgZQz/J
	oPuPEXXjNrDR95d/oWlneyklU/9a3lmbU4JQYHFlORL82A0bkY19HN5JsbO3bG12tsD6Wj+n9yb
	utgzCVUa4QHEdKUeY+EpEksRIGKvw5uVTygxbc2d9XaHBV7eeZhcCOhliv3M3PiVFokfH3uHuBk
	8rfNKbIMrWcvPRNGvjyYNOqsKf1P2BORbav+CVkp+94gMEtDPEVHLljdns5PtWeR6NCLNx+Zvkq
	gEBUmuWdrT+EARhw==
X-Received: by 2002:a17:903:1247:b0:2c9:c952:6e9 with SMTP id d9443c01a7336-2ccea373186mr15894145ad.2.1783497681729;
        Wed, 08 Jul 2026 01:01:21 -0700 (PDT)
Received: from lgs.. ([152.32.214.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bf77e4sm23942245ad.22.2026.07.08.01.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 01:01:21 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] mm/damon/sysfs-schemes: fix tried_regions setup failure cleanup
Date: Wed,  8 Jul 2026 16:01:07 +0800
Message-ID: <20260708080107.727043-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F2A664000D
X-Stat-Signature: qu4skw1t35dmu4tx58i936bohrn4y7ws
X-HE-Tag: 1783497682-964215
X-HE-Meta: U2FsdGVkX1/qxfFCum5K8rwdYZoJ8+kqNYvSpMhvCudBcDy/ax+ISBx7yrq2U//ss/rZ56dcV49csKq/nCLVhnfaXjPFMpgMS2BW04PSh8w1zzkABn/qK1Ch4DfvKwPyqX2cnzG3XOwsBp1F+BORbd542U07O6LdysnscYqkRJNpPDP+oTQk057QUvLr9BXxuuqA4bpuK87mP7odSQT94T611h08sqOHtl4YfOM0niS+VM5tMKxznUf/PIWqj3upHXm0JohzQ/X0Iuj7LkF9O2k6Vzt1p7Atgp9SpfTCxouqU9UC1wRBwU25JWc5rEwR4SFh0W7K187F0kndSbvaCpuyCTyNlcMpA1ANSQxtIZ/KF7LxCUDwS/B03ezKHwUn92Jg3Ip9twuJAVd9epP/i0e1LJAZhcHnf6Qzst5yfTZDAwvq/lcFmLL+dIwMCyHY4eROkzgBgOyUEegq6gDliQtLm8j6Ian4JsMLiZkPKcIsoXPATlieiTpQR5/OO9zFIICmMXLn08PfF/UR2z4DLsH0zrywLG72FRbaACDhrqturUhKpsrHVstWIGLdhcN/2utxqxWzxJmuRQFyckDZzDBDuu8LY43OMpJbPGjOIpa42RGqcUbWxQChpmsiDllpegveUKX6idC6o0lA6W1XD/MzbIQs+XkeRprJfi/dVSX4jJM3q41tqhnTzK+r7VgNyinNmmSZcRI8fsTRwN/emlb90QyUOus2XdawE85i+4J6W3bwuLIZsfjXCXnaMQ0Q2gSn3syGZmgU0Ci76oDu6xJ/5Cje3B+1r46NOWFgUXZ4icGdVzXWa8LuwG3MNld9Af37l27q1DcscUF4PWOAprn8bA6KALbSHcuYutHIjqrM6UW89BsBnZ2uLZ/x1/KeSiOwcj1xs2TtINDthWGF1zOcpc5lzcaFoH40IzXpXf+H/S3ZW9Uh2YpYZ/cgEP4OVL2EXb8XjrliDzn9eSb
 sNU5tnkp
 +J7QnWbcNu3ov0sHn082AilHsArfoxPtRgRIYOZriEpV8moFQm8KzBuGFrs/4mFmf9LVdEqfWJfQliI9zOuuOAri/h1ghi8lo/aGeLcvHForOLt7/GrmAT5sr/F7xpYCW8J5lBY8nBxf7R9ydFokg87wrS/fQh+XzPsXcqJj4V8Zcd/D394pPR2ZdepFRkB9yA5hzQ3RR7dZf7+A+ijbuVbrdN/ZGOYfbL+NrnGjLj08PmiZHK3GE+hrQJQ6iTw9nriP9R7mdqeT8zp/G2wiTH7PNDWuonpfEuthNnG4ZUhlQWSJafDOJdUMs8wl5aMaKCrIlCh/rXiUPPQoVPTU8BqDbLmaw3V8Mq2aRAx0Okn3BPiDFwC/A85+KgEQuEwhyvEQPKa3RQTUSkJt6WLOD8GgNw1buyoPY7faYi9tW2BEwr0Jium/FRlX5f8CzI+gh0Vmbz2aOcmgVZ/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_scheme_add_dirs() sets up the tried_regions directory after
the stats directory has already been created.

If damon_sysfs_scheme_set_tried_regions() fails, scheme->tried_regions
has not been assigned. The error path nevertheless jumps to
put_tried_regions_out and dereferences scheme->tried_regions while
trying to put its kobject.

This can dereference uninitialized memory because struct
damon_sysfs_scheme is allocated with kmalloc-style allocation and
scheme->tried_regions is only assigned after tried_regions setup
succeeds.

On tried_regions setup failure, start cleanup from the last successfully
created directory, stats, instead of trying to put tried_regions.

Fixes: 5181b75f438d ("mm/damon/sysfs-schemes: implement schemes/tried_regions directory")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 mm/damon/sysfs-schemes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 329cfd0bbe9f..0668a0e53971 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2516,12 +2516,12 @@ static int damon_sysfs_scheme_add_dirs(struct damon_sysfs_scheme *scheme)
 		goto put_filters_watermarks_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_tried_regions(scheme);
 	if (err)
-		goto put_tried_regions_out;
+		goto put_stats_out;
 	return 0;
 
-put_tried_regions_out:
-	kobject_put(&scheme->tried_regions->kobj);
-	scheme->tried_regions = NULL;
+put_stats_out:
+	kobject_put(&scheme->stats->kobj);
+	scheme->stats = NULL;
 put_filters_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->ops_filters->kobj);
 	scheme->ops_filters = NULL;
-- 
2.43.0


