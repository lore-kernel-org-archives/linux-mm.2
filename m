Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A2DC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:51:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2CED6B01FC; Thu, 13 Aug 2026 03:51:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F052D6B01FE; Thu, 13 Aug 2026 03:51:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD086B01FF; Thu, 13 Aug 2026 03:51:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B346E6B01FC
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:51:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42011405DF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:51:05 +0000 (UTC)
X-FDA: 85095475290.26.8D1269C
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7CD7E40003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:51:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p1TsbIEs;
	spf=pass (imf11.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786607463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KIo/hskvY35I+xlwCnjLbjXGmC9TvGJPu5fGHiHuA6o=;
	b=sn5Mk7k3ETNVdsUNyKMkPFVd7co5p8uLaZ4/7tCf1PuqKe649/IQhaUQ5mZlTnauabfaxt
	InK97RSRK+BssdZ4MzXqQz2TDIUFITwMZTryn5pYV6fvPAP/z2/ZsGWnBjIo+hu4PA93dO
	OtyXAuf2p2hvfe7EHVRpGH/115eRSFw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786607463;
	b=71qOwzUOUEGLO4BnuZMAF4ikzOUFqlrvgppQkR9Q5+xDpqHcDxX4PhG6Rl2f6VtdvkaqR3
	ErRlL5Yo78N9BYwRFpPbbnXsMBsB4MMUTEX6Kdc4YVzrFCaTf6wcogd+KJivZzaM6atNAa
	Hl+D1XcXrmq+wOFzWWzbm1okvkuQ/jQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p1TsbIEs;
	spf=pass (imf11.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ccae46de39so3380335ad.3
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607462; x=1787212262; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KIo/hskvY35I+xlwCnjLbjXGmC9TvGJPu5fGHiHuA6o=;
        b=p1TsbIEsTw5lBMWCVPFFoJj2BCvV2Lt0JnoYKDVWKoxwz6b/EdMD7gRCum8X6BPqr1
         xWIXDj5Gt15OPNQ04yLVJc+aNHW6xIhWnCGQncnV9GStYm4oq3GR4QLqGEUAFlIHv3zY
         BAYKp7/OlYC5XeprYUzG/s9AVT186vrKnftTJiK8eHklvfhGou/ppS4rBHwQ+xNb0bPY
         iQ4vA79SztU5NRm29fMfDi40j753LT3ADr/+tRObB+Klz9kK5lAJE+2Rm2SlFeKhrHT0
         +oJQ+zfWy4iy8/Fp4HmK+1EbyhT4EWzdHkv8FuURT3X+YP0J3n7eFgi6x20WYw8+exoc
         0aNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607462; x=1787212262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KIo/hskvY35I+xlwCnjLbjXGmC9TvGJPu5fGHiHuA6o=;
        b=ObWyIcPIj5in7BjXLvfCEVwInRddOSxrFvq4QpISeeQXoXFDuWhsz1z0X3/+rPnVBv
         sngmLwqY5x2BKQN7Pfu2/5Glqjsq7Ot5r1ead8Ol9FOxlvaqTgbj03CZWPEUDmydjSrP
         N8gwkjPrcM00FENT3qoobl7A6TjhiUAvefUsG7X91ywSQub6hVR7xtmrdiu3GK3LhSmP
         uJrogyOHuArpRKigZz01OEuPzi3Y73Ojwi+P2asUaSXmXmHQmEP+eyjeN+3sj6p9j1+S
         JvyE8jepoupxx4t8Vc3Mk8E21DJbOTun2ajEN4nRINbOkM97IKHN3jmvFzNvfYd8Kkxw
         2VMQ==
X-Forwarded-Encrypted: i=1; AHgh+Rojv62+tHCioo47h0zK8vfFXyiKAfo2Qc6YvsypcILp+picjwBOXk/XlIwwpPRp2hRGmy+Rd2jZuA==@kvack.org
X-Gm-Message-State: AOJu0YzcSK3/7Skm7yrCUeDO4dabmWue2F9EcoyVCEgjTudJP4I7MYqF
	fF3u2zCiz6NFWhlE30Eefyme6MqoG/dv7SXVpEF/iqjYzBXL4sBetOfD
X-Gm-Gg: AR+sD114TbuJMYOBjTsZv/u6XfEuric5sY+d+eQwKN1AS5zs+bofnedVQEtp0+XIllw
	md48Rae/LL9/7zh0AnT0dYiBAcaqwsmeS29qngkRUsc3xfR93QSxWF5GtYMj0rTwXvxHnMLXveP
	Qdo51xXOQH6KekR9SChevPevIqOHCNWumbtqVgGchMYg6rE0IfqxFs4cYQRhCsqgSst7dGaaHle
	mk30e6LyzI7GNNw3pzU2T1fDI6sQ5+AE9k6X/on6Orc+bXV0IAHayRuDt3mZJI5ueMPx1EYUQu4
	D3myU1FwarvsIY5LfUjbP7F7V5/josFZ5rlmNhufwtGZrqPw6+VskRq00sLn2HM/fu+zbuNb/R1
	AM5ljW8ZUN+J84tyaQFWKa6D4x3ZRs0ebWq+9++5pNyCP1UUTRUyUGsNFcuigzGh6tkoxOFvqTl
	R3XMoWWuB2jlm7m13jOWHZBNFFwRQwzf5UKWxS2WG9DZd4BBkB1Fl+2YvSdOFF/lwtPZzqwexip
	eHSXdUYUDFGWNhwda9uohvQKCIOsRQtlqfEVv9aETIW1vKBfPxGLcm4rAOx1cb1iBqD7ZzZ2BvC
	6KVEsA==
X-Received: by 2002:a17:902:fc46:b0:2cf:9e90:8be with SMTP id d9443c01a7336-2d37efb393emr33092015ad.4.1786607462232;
        Thu, 13 Aug 2026 00:51:02 -0700 (PDT)
Received: from debian.lan (n058152058183.netvigator.com. [58.152.58.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d37c40d6b0sm5550125ad.40.2026.08.13.00.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:51:01 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	ryncsn@gmail.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v6 4/4] mm/shmem: split large folios only on -E2BIG
Date: Thu, 13 Aug 2026 15:50:25 +0800
Message-ID: <20260813075025.1406585-5-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
References: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: u3rjaugncohkx1sgrdssxuwwykjqa9ap
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7CD7E40003
X-HE-Tag: 1786607463-805800
X-HE-Meta: U2FsdGVkX1+omRJJ2m/5WPPGIk8Nfkjs6zkFfnbZ+EbEf3HAdMYO3rEMftf0ulyGQ8nElDYlxP9ZPoi3SQlSEIL8mmy7YhWHDv3sdmmcbcwR/aLevW3AER2CZyC3Ony1TZTsNkm9XrkCT3m7/6BdH+6DIXM254GHZbfDcDAJGBpNS0bUdBq1d+uYR0MrMGL6g7BYUD3WzDdumLrq4O++PxS5j9TPsc6OF1mOcWd5rxvw74KOb3Telwtf+EAcCLxeDdgZ6YXxfgO1zw0zVX4IAg8MPJ3NhziKo3c26Vp/lW42gsPaOk0b7St41mYxeOjFx4Zp9sEqYhAs85X2u0jocPlAwU9j+sl5tXU94TI/N6ehtcqwQJDSQfxg4TJStK/fGWZ7Gh7uB1Vl1Pl1dnidRWqJeyYP8ZE4znz5KOy08+Icuy+HJbfiKLgxlAIf0Mh5PMtTHYYTuByrtBN6RLlDujFCdE+feNvxxPzMJn9WJUWHejuVIE1/FauTbbyPWsbZv20Zscug1QZj1S+P1evJ0OF1WO55mTf8PM/TwCwkjal+U7KrseqtKw/ewlz86yy9VjCzc98UHZhlZa3j8w6YzqOUVRmHTemu0RaBTl8e3bNz5fdc8nX3ah6f3hZhrwuXQovBnC0aOrr4AF1dHnIQ+BMuozGFadJ5J9wPEQqa03c/s+d8Modopo9mblwFrn+0pV5pp+xzzkJTwc+Fb1Fc1UdzfsMT1F7wk1RJoZjq1nE836uCQZK5d6rc6GAt9YDWbZS2bqdTkM5XoThQOS0zEfeZ46GBKD1l95qVed1j6ps3rFPa3e4sYunyDd8s6nOA4+BtlM5kIsaFToi0J008+GQg5Vu1gjJt/6O+Bzic80zT4vxxXkjmzYlEcoEgeafwF4k7yz16ydR4o4ytp3HH+8paX5ow/lKVsK+aKu7LmIxL9hJWylNxfPl9O4WkJkmHhcrEkbkvRZ7xWc43llg
 6G2QiOTc
 P3DKM1autObkwisxfKNkSXWWqi8VLDsL/5JuELShic9FUx9JIR7CUnUyC0+IqdzBsqZ54Dwiv1rXIO5T6g6b6A3CbnGUp84F3/ojSBul2gWznjVu3cqEA409nE4QY1u3PN1uPmDvcB2+raMgiSzfjsjS3t7336iqlwDyuPB3wEpWCvPnSgi1lsgqCpC23Mrj+7XjRFd//9y91FhpQls3MTg93jLUUc2oXlX/vQeIg3c11VPNuOYbiuZ88vP5OQJKd4IGu7JLBrlzXxYL1THTQhTXiJ107yZdPm0R2GU6PeBInSVWaB915aN9gEKWnk7WUj9fJ1MlLOfpBM77oIvh1sPNmNLLqhU5/8rGSlURF4A9ABNU9Xq3ad8agvxd0bZhsQ02360faS2GPNs8Z1ji05QYd0afMyEcFIIdhrJvJ1jbCy031ROJfe8XZEhSQ0/PCrzG35ptJoQ0gCfxJe+UQL/3E0Yb5xacxS7AVxUQGEMVZo92xgnDZ++zZJceYAUcGOvQPMEh9cl8tcgHcP0nHjTllz7pzw26BHceo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_writeout() currently splits a large folio on every
folio_alloc_swap() failure. With the refined return-value contract, only
-E2BIG indicates that splitting might allow smaller folios to be swapped
out.

Enter the split fallback only for -E2BIG. For -ENOSPC and -ENOMEM,
redirty and reactivate the folio as before.

Suggested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/shmem.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 6641823bed16..eff38bb33d8a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1608,7 +1608,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	pgoff_t index;
-	int nr_pages;
+	int nr_pages, ret;
 	bool split = false;
 
 	if ((info->flags & SHMEM_F_LOCKED) || sbinfo->noswap)
@@ -1689,7 +1689,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		folio_mark_uptodate(folio);
 	}
 
-	if (!folio_alloc_swap(folio)) {
+	ret = folio_alloc_swap(folio);
+	if (!ret) {
 		bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
 		int error;
 
@@ -1742,7 +1743,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		swap_cache_del_folio(folio);
 		goto redirty;
 	}
-	if (nr_pages > 1)
+	if (nr_pages > 1 && ret == -E2BIG)
 		goto try_split;
 redirty:
 	folio_mark_dirty(folio);
-- 
2.47.3


