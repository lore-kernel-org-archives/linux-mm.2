Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F628F45A1D
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 06:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD65B6B0089; Sat, 11 Apr 2026 02:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87F26B008A; Sat, 11 Apr 2026 02:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9D516B0092; Sat, 11 Apr 2026 02:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA0AB6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 02:22:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 414818BD80
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 06:22:13 +0000 (UTC)
X-FDA: 84645280146.26.9F75950
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 81EF440004
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 06:22:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UgwcDUZi;
	spf=pass (imf27.hostedemail.com: domain of lgs201920130244@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=lgs201920130244@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775888531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rjzGaFEIwJAqPl0XoclvOseGR/HD6ox/UHRHYtHUC04=;
	b=DCfzBf26GfSFB9e7bgImq4MIbxpX9lcDeqISkt0J5oqB0c9S/jV6taXh+YE3xjwYoAQ4Nz
	X8bKo4oshUeWKvoTVLLNhIQKAKAvI4lCcr4TLbSnZ5nCww/Ldmz+ol2/Pj+Y1PyYNHLvLk
	4Z/r5POprOSQZSmuKqhXtm3mxvHFZ1s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775888531; a=rsa-sha256;
	cv=none;
	b=K4fx1JhaklFEYjRUY6m2ctBhAECG6SumRUd07o6mi7wQ7j+LipTjXEk3W8m8jAupzp0cWH
	gj3bwDSTjI+oYPzTJc6fv/TjF0Cp5ObMohi+i76NuidIUms19yf5gzbskOv8miPdx+nl90
	s6gigdIDg3G7MZ68JvEZmSH4ZJ5qFD0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UgwcDUZi;
	spf=pass (imf27.hostedemail.com: domain of lgs201920130244@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=lgs201920130244@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35d9c7bf9a1so2603803a91.3
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775888530; x=1776493330; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rjzGaFEIwJAqPl0XoclvOseGR/HD6ox/UHRHYtHUC04=;
        b=UgwcDUZiX9I2rnuv1W4368dRbFbZJjFbCADpaiL/iXJE+2GksXCChgGhTnujuCEXWm
         CTMz0cCoAOILYxQVMfCMitJMhaq3ARMleJE2HIpuuC+msqbZ8ROwzolkCRMRk/pq0qRt
         iIEmg7W1gG4XLPJiitnSjUhUzzWogYtzg/e3wIEKqt8CcrfPbeo8wLeUCVa2Kv3s5Gy1
         PedS1BaqY33Pzmq4UI4owg7bQ/yE+z0sXNBIPcmbmLSwnY2hdke3ShZHD1v4iAaThBao
         BBiQBANkXE0JFonI+FMSqZrocfw4hw7rc9C8knBim3A/xKSgBkwi5wEd2tCWg4oxpuzN
         FFCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775888530; x=1776493330;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rjzGaFEIwJAqPl0XoclvOseGR/HD6ox/UHRHYtHUC04=;
        b=aZ+QaLD5gj08Mp96W9kUF/aVsG6hdM8jAN44fA8v1QerywBKtcA51cP189BQ99A4Eg
         jKvlqbz1N1BIygYv/+2CKY5P+EBgr70IiChtUFnw0HHhmtqo3tWLTEPnCCIquX6pXCcn
         tmZKpeXjARHcVEWwY1/9oC1ZQLAHGOnIlz3jBu409LkUHaAvsBMtPlfgQMQZaREJ4y7m
         zMFxRScxSuAKn9FvVI+u+HuzwCEZaotXsGoVbQVno2LkiJ0kvB63z/DxjwV83LVPaKFq
         9PXZ4cewXNvMN2K84hLd3a7iXLX+dM0qZqZ/xtgOqXR/VsEu42mMMyuRDVpqIPUraShe
         /Bsg==
X-Forwarded-Encrypted: i=1; AJvYcCWFChZOJDCZ9uOHBTUQEkICJ51lYsq5Vp0zyTo5VD+X50GU4pLgqhMK9iFG+ktt+fUCvdEnJ0Jb8g==@kvack.org
X-Gm-Message-State: AOJu0Yws1wQhSQAu1mHUU2+1TguYXykN/RdYu2gFENYgn99jGWxqP/ZL
	QxIV2lnQuvu1+NNDntZm7FfBpDJYuPDdZqaR+5Rb2RGQEQRM+RP1xN0i
X-Gm-Gg: AeBDievBZi2gJsoejjkDJdpR/JDm1m2SjPNLAmSW/SmXgOan64xnF66Z6jgMkA2eBs/
	yqQdhX/hFGt0QI9JP0KufkaTNdxMT0cRj/jaY4oXhWZtNe//pnz0DkDomKb+tnPLewYgO+BaCLU
	VIBThBDkWG6xk4iGSeY7ruZp2YIMsK7dDhFMpwLhyaQmrgG96f1OS5F8jh5Vcf1yZ8eba3qSrwL
	I4wOx04h0hZYugpxWzE9pP0lCzWu+H2dkC25pTifQy/ALwebSzfYXNYwu+SagoxIhz5rGFTwMI5
	a61weNLnWUEdZM0GGtejyN2k6vFOaR1ZFs/5lTiyrBrqoVQlFnPdNlcepply9fsIwoh0Dvu32vf
	7Rt+9rG1Rl9IJyhCx6yvu4ReYTVTU5bIV4yo96aQ0EUa0AvAbYzouTX3qM0YMQg2e4qLPYRlju8
	OpX3x968Yb0InLGA==
X-Received: by 2002:a17:90a:e7cf:b0:34c:fe57:2793 with SMTP id 98e67ed59e1d1-35e42881e54mr6189487a91.20.1775888530399;
        Fri, 10 Apr 2026 23:22:10 -0700 (PDT)
Received: from lgs.. ([101.32.189.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e41345f63sm5345346a91.16.2026.04.10.23.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 23:22:10 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm: thp: Fix refcount leak in thpsize_create() error path
Date: Sat, 11 Apr 2026 14:21:52 +0800
Message-ID: <20260411062152.2092967-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: u5r8e148oqjozokeb4z3xnnyedow6btn
X-Rspamd-Queue-Id: 81EF440004
X-Rspam-User: 
X-HE-Tag: 1775888531-213225
X-HE-Meta: U2FsdGVkX18BO2ZBPjGfebT9l+Th1GEeguy0cPin0jkV2J//VzYKeRSjzxG73GezpZNjrrXry/nUYpfk4WcEkeXsoErR68ll9D4siwugUIt9bfCPcy8MpnP7P0PY0JuF4IVFkGWQjZd2g3lti8VFneE//6ZJQzX9Z7QEoFSbWtypdwUqQdFmH15DC4FO5S27jTqFv6k2c3ApGB8IwukypYH4uIiFO4F7iCS8ZBHHZDjq2N7nLdb9d8CosNttp6CF67H0LHvt34Gc7utnlvJv6aj3WhRiDzdJrSicNg5F7HxkoL0kQ02kuybO8at4AyuAhR+vdqBZMQVXePS579rQxAMKX2JsppZx46ny6Yb9PmR6cLTnum/WUcW1cKy6OqsgjOxpxsa4FaFj0soSSlppeFmtBlsn1ADZCCB/whSXhNQG/rUsCJrKYZAtdPm+R/RrKj2CYe3e5D4JCvo67YXmS55hCVFJR3f5XyESSCb3dNeKNTNP+80xMwTgcCAEWTwdrcz7LSs4lOb1SmiTlDNhlzkQqQUX1au3bDPyD/3uQRnkka0t33UuG24wnmwW8R/9c2BgyfwXNN4zA2t8r0N0S7+w6eUGNRgvdrxVP+9p+Qej90lIzAdAltSERxSXJzd1SY6IDHNdklx7N8Wk4wNq5stSjBnHcgGDLB6OZK3M5DBvOuuG1sl8Ol9T9vKHn4a+2HcFBixeASgL+aOondpwiQLrnL5lNy3LJMBTD0LnUOH6jdJLS8yCt9FkYGJ7UrOVjLqXLGouMwQAmSGxuzX2c68c6QyNUIqzYu6fiuAu4AOIPZxJBNKwjD059jRZHCchQ/jCmIkS4sgqn8+C+2/v3pmiAfSGqcmcwHSkchs8GBj8iNpU/Zg93mT6TEYBlA/VAdVTerzoFnM8r1k+P8zswQwcFdA85qVEW32YhfjnHs0pWHS1mEo/hGqgX+1VpbrRhxvV/syDvvCAvS6aoxg
 D84GznQ6
 UZNcrn+WU/fIn3yGMhFnLLEZl88rRB/Xv8vjJ6jS8YL9lfVrL60+4m+/nqbpXQASCKOuqHI3cSYlUQ0VmBZE/EXYfu9vLzeE2qMCKxsIdCXzo6JVtrhtCggdHwSppprQq0BQvOVkc2+/AIOLXsO8nuA1xBBuhEQM1aV+RMDs67PCZYDHGfGc3ML0AGi0NQ4fXZiPHY4LVKlTisKuVYjwAksjqagfUJk0Bs+wu5DKqnw5fZX9TR1Q57Z+DbdajGL338MPfinQg6UrDuhRj+J/3hDz1tSs+rUvZOpxDG46hBlRnIukAmOv1HBDfr+55eqOxNC9wTITD6gmqk201R6zpGfsUS7Gzr3i7SOJjHoBtOXh0st/E84ru5AZERNOOC6BMzgtISP9x7ITLf7nrj/Q9rQmgxZs8LG6qlLsyLWYSfb4iIj31Stdw4rJKvbesOZrIq402gzU74DX10kzdTgVty60qaEggltioL457knFfdRxtQhY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After kobject_init_and_add(), the lifetime of the embedded struct
kobject is expected to be managed through the kobject core reference
counting.

In thpsize_create(), if kobject_init_and_add() fails, thpsize is freed
directly with kfree() rather than releasing the kobject reference with
kobject_put(). This may leave the reference count of the embedded struct
kobject unbalanced, resulting in a refcount leak and potentially leading
to a use-after-free.

Fix this by using kobject_put(&thpsize->kobj) in the failure path and
letting thpsize_release() handle the final cleanup.

Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 mm/huge_memory.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..ae6ed483cd53 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -726,11 +726,8 @@ static struct thpsize *thpsize_create(int order, struct kobject *parent)
 
 	ret = kobject_init_and_add(&thpsize->kobj, &thpsize_ktype, parent,
 				   "hugepages-%lukB", size);
-	if (ret) {
-		kfree(thpsize);
-		goto err;
-	}
-
+	if (ret)
+		goto err_put;
 
 	ret = sysfs_add_group(&thpsize->kobj, &any_ctrl_attr_grp);
 	if (ret)
-- 
2.43.0


