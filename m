Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8770C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 15:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCE716B0103; Wed, 29 Jul 2026 11:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F686B0149; Wed, 29 Jul 2026 11:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47D66B014C; Wed, 29 Jul 2026 11:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD7D6B0103
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:51:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15C161206C9
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:51:53 +0000 (UTC)
X-FDA: 85042254906.04.EA8C9BB
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6DB1E20010
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:51:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WPoMmDjJ;
	spf=pass (imf31.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785340311;
	b=kBik7M74Zb6DCtcFDyxO4noVukPcWTHSXmpGfHzYw/UwO3UBs5wxRjyCHpmmBJ855PHAFY
	HiJx2b4NQ/QgGj9LYTBuxv7Vsb08CHUBN+1i/UbNXP0GzKmXFByz4KtR0lGYJq8qz1qT6b
	roBDUblIWAA8TIRpuLRVGGTk6DDLLXg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WPoMmDjJ;
	spf=pass (imf31.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785340311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iAOEexasaDUzbN0sN0NjV64jccmoOHHoxBQS9xypSJU=;
	b=xjbF+ujltJZBxrp2zcsLp85A7gZgX8/RuiYu9wEH3uZyXqZT/ZrLd+ewbCIc/fCfgdUBcI
	5vbUByf8zbHKBK4bvcGnS16+PQZKrC8TpNvnk3NE7p+b/eoMywfQ8ypeitf+p7ZwuJT/p3
	TaKjuSz1jlzB7+5NnW7b+31oQOaNzTo=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84862b0d5f8so997191b3a.3
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785340310; x=1785945110; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iAOEexasaDUzbN0sN0NjV64jccmoOHHoxBQS9xypSJU=;
        b=WPoMmDjJNdzh7zYCeF08g7gyVBgJgPDFap4xG6895iOnbxqVmLpJ1jX3rE7c32zLPm
         Z1z10zHX8AXJ2sKgBRBjvIewTf6xdiJ7f+bv2c8mQuXKveScBEWv/pAzS6Anhm4bXPUa
         QWAGtdIVFGbvpKaY2jNEeSw5+UiYdCfXzpoJRODx6vdphAxiye1NxfJrXnxLahn+5YUi
         M8txna/HGC9ph0ZLxT2Ep/lM2fE8uAwsfXUGt+7kRiG/306/fTmDqj8+MXgSqYzPTLYq
         Ha+xIroucxZgl55vmCJY4DadvyaL9sy50P50HcL+rtdkaJvvAPrd349wuTrTXCrS6b8q
         k3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785340310; x=1785945110;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iAOEexasaDUzbN0sN0NjV64jccmoOHHoxBQS9xypSJU=;
        b=DKc8XJ8jYtxyLHgElvQ+ljIX634qyvy4/K92jts0w2X3VvfNx+5/zSE17mi5XjdpOv
         XGBAEGDvOKj6us/muELRdGRyJ0UegDOMC4oWt8XD6IdiYGSpgwOncMTo17VY/7jLzD6O
         wufp1WXhWvWowPgY5qU5/KSx4xnKFwjV6XYIeVyAWwZwK+WUk5SPTW8Sol1k45E1krhx
         tFM6vZ6PdKHhdYlhPYkuoG/GuLqb7P3jfboHrOnpUS1q1BXGYfTJA+phXsucrfvzcVX9
         BmHMD0yjHSDEIxo0ilMlyupaq8H/OlSymYPR4G3HSH8ZEvClzXEvCpFXuYsrOz4IRoo8
         8l9A==
X-Gm-Message-State: AOJu0Yxlo2RPFB7DjnSV9Zm2pi2ZKypWSYI2dPilW0hBZv2m3eno0Cv4
	bcp9ry1PnIQk8RDHrY62ciaVK3QH9dyaDoVf4VRKwBoN/4UkKcbPbehL
X-Gm-Gg: AR+sD13Fef6vpoYm62V5h5UT7qpVZnA9XlMK5L15KfXRJVMAIvd2OBaLYUuDjp6KJZd
	AF7Wjtozv9TFFLgd/qprpDtOpwr9ewDQVNYYbZV8Rnz9qndG3nsxq43cxOIhR2PRGbX3U+lCp5g
	LXINHpYWPtMCMH8CC1Ncd+FxZXCrXuk8sDwV5fDceYyXcrkOz3/Oz6VGxga+E16IbFDJhOOekgo
	Qb/gJ/rYKuu3QrStfcfziwzA/7yKbWq0QOfxtFGccqiFd8hHlMjhs+9yJ7v8YpkzbT9g4teVRk3
	rIfvP6ooV9fOAPoEcIOPzhoVw4tWpEIRGXBWO3jI33IOtQv/c1UF/WzKWtSnHRD9q7URP1aKREH
	vMXYmn1SlNo2bXXoRM810dSTqwpo7PSzQywnRA853or7JvXvI9MepajgYFHJf4N1F+XCaLp3xoP
	hQLyxaJMErn5ST8/2o4VbCUd3htBQehEdJWvcF0FwNy8Ln4Pw1sMO8reQ=
X-Received: by 2002:a05:6a00:10c3:b0:845:d274:c024 with SMTP id d2e1a72fcca58-84e932c7a28mr7581936b3a.61.1785340310097;
        Wed, 29 Jul 2026 08:51:50 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe24e6csm1619948b3a.5.2026.07.29.08.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:51:49 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [PATCH] mm/mm_init: remove unnecessary initialization of pgdat->per_cpu_nodestats
Date: Thu, 30 Jul 2026 00:51:15 +0900
Message-ID: <20260729155143.177790-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6DB1E20010
X-Stat-Signature: fmw4c86ydifu11pob7e85tu3itphu61z
X-Rspam-User: 
X-HE-Tag: 1785340311-63510
X-HE-Meta: U2FsdGVkX1+hWGf5PlcLpM0JjmOXYQtP5A78mzMY1aoeiO3SzBWeBmsGQpdSO8QlothYtb1HZeln0xbHbbb/T/k2c5ovI1+TMh43onXAHvhg2X3NwQuyndJaIMwRUy/NSnFnYH8DGVV2QWK37XUfy/1f333Z6WN03RvT5aPBbFmjjA51KxPeu22HtxiKDYqOTpaIeXzAnYx9j0PfdSM8J2LJWY4I6V5oncXT/wnYkpNF90g979kfTHP1ieiKjuauhs14cuFh2lVOGJskDe7arYvKd/qhnE7HOgMKhLGpFqS8DYH0C73+dthbFGDdUqww1x+KiOtujlH4upmHqulmET5BlN4Snz5i/FNRisTi1TDgHxr3iOkDuJIK6UBNqPzLj7xQRgg96ERorB1u2K1C7A1Iwjjc4Y8/abMd/I4Hhs4f4VHRL5DdoHY1LP1UBWn7XGBOuL/ye3iwal+i2oUkboyctSOggHWAAhun61JYy3D5iXsyfkC85rdSokw+eLTBPH0EEvMRsafLQVsNPBA56S3Z8DDLgqZ1MUnBcEKC896u7SrbRDRP6sSGRnBMFSVIeLf1Hzmoh2bVLLpsCCOEzDzs/FqF2WfxTK9qN1zY4FuLN83PpLpx0gNQw8V48KgxIkQ1P62P7Y2NLIFwHYX7uz/MIEgjO3juBitC+Ks9DZPWGjWlHJDnitDauK0NoRqI7NHmTaNZEr+0ZDfwiu6EeQXjOlOA/0Sz/qjdrpbBIp7RqnjZUiBWEMkmV2swJFmt5EXWUWy0GU8lSs6a+TgdTE3loe4S6pC3U6xaY68ETImFenk7R94FQNCd2tQJzB8M1VZ8VFtw2BX5h/dEHMF/5M+Uw9iFd0LAKxFyJxY+xIRcZ7ugQcvT30e7un7cG8TjEJuDiEsvqtgHqV6Ss4YZIBkFRrbctCSBFEcdKF18Fs3H48ycInppkV3wJUuLrZCKT4PVGjBvodiV8XjALlN
 QGeSwdyo
 CSNeYrLx2SLFw5Sqm62ipiOPGybC8O4DOJYzruU+/xJrhCTDevcMSHIstk1+8DN0jjJwRB8gaQoz8s40AzZTR4jZb3LBTdEhYVthm7IwUmvdkSmmWowEI/BTM6ArfGoFxHsUvyliKgYCEp0Gi9ZDrhB3WFsXnJE+qAHu/BmJDSwCEftINmceBnz4YPAI2pbuJNg3gPeDhH4T5E4Rz1H0ExThHPzWaMAlgqiX9z1PmSLX85zvRfLIGJtt8dYO109i0+pH55Mh4VwTqdihfePYRgfzKkAZDLYaAsBoHGpFPgdp/9hea6zBat+SlKdla128YtWWocfOTpYLH585RNMf/YhPM5IqeNvIKEOxbZqgsofkZew02QkbzcKMjQj7rAok9AZaEXq1AnkKQsmoeOgguMhb7QS/qFGIFqrHGwVSDp0ogN0VpVaEmxL76iShVzK6AxpErokPVQnHpxnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_area_init_node() sets pgdat->per_cpu_nodestats to NULL and later
calls free_area_init_core(), which unconditionally overwrites it with
&boot_nodestats. Nothing reads the field in between, so the store has
no effect.

Remove unnecessary initialization. No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/mm_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 711f821f7b3c..367b03623f89 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1722,7 +1722,6 @@ static void __init free_area_init_node(int nid)
 
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = start_pfn;
-	pgdat->per_cpu_nodestats = NULL;
 
 	if (start_pfn != end_pfn) {
 		pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
-- 
2.43.0


