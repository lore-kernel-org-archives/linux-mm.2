Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D2EFFCA192
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 21:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 939416B0088; Mon,  9 Mar 2026 17:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E6F16B0089; Mon,  9 Mar 2026 17:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8BA6B008A; Mon,  9 Mar 2026 17:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB496B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 17:25:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 12CEE1C2C7
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:25:29 +0000 (UTC)
X-FDA: 84527805978.13.5E40F2D
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 98204140018
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:25:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lvgs9JvJ;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773091527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=S4UPmqAJABaUK73z85xpd7p4z1y5KCxWljZJflvXjRo=;
	b=jFu8OO2rai19Vx2079e3B2qxDeHyNq53RorSqiAaoFNxBqnce4GYmpcXJbiZAVcofCvTqv
	cKBiVc5r7mQImzAfIUoI5DDyZPL+61iUhWIeEdtCBAarkBba/ec5cocclmmI8kRs5Tix+J
	7BoK3oY/MCY7WHH6E0z2jeYsCErxqXc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773091527; a=rsa-sha256;
	cv=none;
	b=O0y0EMLcSRd7DvuQEspw7HuFmBvkLnAyVDBg5Y941iBkC9moLVLNzdq1EYFs/kFrHwN7CE
	KINWwKTzvOqgvZSfE2476hXqqjfnwl6FOuj11b6KohE6oKje0YvveOiUNU/a0ZVtdSX+Y5
	M0fZBiOisudSUo8OuqhpLY2kYmQKPeA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lvgs9JvJ;
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773091523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S4UPmqAJABaUK73z85xpd7p4z1y5KCxWljZJflvXjRo=;
	b=lvgs9JvJj2k9QFImZ28+WWvrJ3RN9lq2IPQz0SVXjNs8UMfe0T4V7KW1vPr2Nwjyf+1iMR
	99dpCJuWyAmhsSM2l44dYmrgk2cU10UnG1Ve51vQ39cZ6PDobKXQ1++LZWM5504ltAlTQD
	aGVTDoZpWcf662p8JO5y7m1gPJDIg4E=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	npache@redhat.com,
	david@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	hannes@cmpxchg.org,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2] mm/migrate_device: document folio_get requirement before frozen PMD split
Date: Mon,  9 Mar 2026 14:25:02 -0700
Message-ID: <20260309212502.3922825-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: mwfdgj6wo5bx6kyp3tkcp8qtdj6uerah
X-Rspam-User: 
X-Rspamd-Queue-Id: 98204140018
X-Rspamd-Server: rspam12
X-HE-Tag: 1773091525-290044
X-HE-Meta: U2FsdGVkX18/dfwPwoBKTHrSWTnaLZYbXd8pJzaXCW5cTVVmidqS8Agw+EYm/sIJeyAlsLfYoGZRRLzJm7ycKJrgs0X398BgWJs5vMC08BN11BtU8HRmg45q7hwqCGy+tU+LxqHSeaS6QYauk5QqlS9UUiD2aKXvTHqjNKQtp8ypJMs2iJ9VwM9BGAAnaH4TNvczbLFWpe/fHm4nodtFNSvMk5tbbIZVozUP8crBHUQ+6e8nuIQ67pNSuiDFFVWTcxPotYfBkZxGvi8zOzLVFlXCFSNUArl8HQnGLY2tn54LlTgashEn9t86FCBxvrLQ3Z8I/lkh6P/oWNObSvrTZloczjfbfp/+XrX89nnrydag2GkTNuaDZlRC/z+9kt1B79K6rgbV7zSZ6Z1DcC5GKhEwD85/v44J1ZVZ31FTI4RaQLeWVYyJYoJZtnca+BOr61Jv/M3nDByOf1Aux/9TJZAh3/J0lmnl99gOoCiOMC1ex9Jh72PYlI6IFHzmhKnkCJnPnM888SPirDvTvRSsLI6tGckvfpCTAKJBjX4NzL4FYFPul9mx20vngM7HM3m+B4ZTFu9babAW7y5bU/PA6PxgbMDFARciNo2EahyjDqAa6o2bC/rZWofcTkVHnxLkylxbYH2u907oGZcuEfcPGeD9PcjL7UnTrLgt3Q5Wd9PFa9X+FunUCWAD1tfOUAHPci6bppbeFxuF3ocNIvFTORyq3JBibMyv+lk9+qzu+/w8eYr29yHo0J5Xkk6daOnDK+jo1pVtLn6cqneUIwv5AxFI6KK4TH6zw0Z4zv5SsdvkOc2Uwlfey/r8LlO70irirIt80q8ZHyqbHpywbPqE8IbwLOqrNa1kYobKZVmwp2laRQRClOmM68YU0zyw+rUC4zFGjwI+HZ+VRX46jyuvrlslAb3Fjcb7HhTqXyWBsldr9w3ZcBet8UNv6IvJlRu0PXeKmMs5JEuOP+i+nut
 mNvAr64d
 rgBijm0yBya+1P1zaaqUskapc6WpNDmmcNEDpA22E2P8SdtfgFb90TidKmpbVno/3NUf45oGz9gjoGjx8Hysg/jwZuatgPkEqqJDgyWtz3EJ5YgNTFWSqYixBmJF7/skJ0jjEzAotY81m/VErWH/qMAVtgm1wEYBtXcVR9SreXhOtpNS/bydOEykUYmpKeRH4/R48rVXkAp1S3bFOoEA3q+81q/CzxuufEsncfA989kS1wbBi/9f8bEL/zhm3xvZ4iIlOEDWUycglqij5QYazbZtI3GIc4sVRLHRevh8HNmfrjlxB5NwpXweO4sMn+KJP3rfRzuMPch8BEuLkvc2fqQXt1qv2DGS7F4BVlohKOUHijNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

split_huge_pmd_address() with freeze=true splits a PMD migration entry
into PTE migration entries, consuming one folio reference in the
process.  The folio_get() before it provides this reference.

Add a comment explaining this relationship. The expected folio refcount
at the start of migrate_vma_split_unmapped_folio() is 1.

Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
v1 -> v2:
- Remove warning if folio refcount !=1 at the start of
  migrate_vma_split_unmapped_folio() (David)
---
 mm/migrate_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 78c7acf02461..fbfe5715f635 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -908,6 +908,10 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 	unsigned long flags;
 	int ret = 0;
 
+	/*
+	 * take a reference, since split_huge_pmd_address() with freeze = true
+	 * drops a reference at the end.
+	 */
 	folio_get(folio);
 	split_huge_pmd_address(migrate->vma, addr, true);
 	ret = folio_split_unmapped(folio, 0);
-- 
2.47.3


