Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 702D1CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFBF88E0039; Mon, 13 Oct 2025 08:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAC588E0037; Mon, 13 Oct 2025 08:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE96C8E0039; Mon, 13 Oct 2025 08:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B96FA8E0037
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:21:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 794BF13AD9D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:21:29 +0000 (UTC)
X-FDA: 83993001498.03.E77DD80
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf26.hostedemail.com (Postfix) with ESMTP id 452AE140015
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:21:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=feI7kDLa;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760358087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ZYme18sETK1K7GUExeAzS439Fq52P5lo1OFNmk1Dg4=;
	b=TxK9aKuSbkm7JkqErBTL/89WP9UUxE1fe92Y0CywI1WVNmFUNqOw7GrhHnWHh9xiyc11VF
	l1fo1aGYFoMRaPtb2hFfC2/vs9Sy+aYOtbeQNlN/7MrJq9Arpc6oY2VCasA6W2cr3LWTZj
	iQXGmbQrPv8wh2eRmYjKKxGChz+hR8U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=feI7kDLa;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760358087; a=rsa-sha256;
	cv=none;
	b=nSoKhUjafO7a9grNEotK2xeo9gWDTgNHzqze+82Zz/GyuFzNKM7u+tlC8j2fIj27pBeWAO
	Ycz74SFX3LRy4Vu0hv471YAVNYVIJyEBGy4JvG/ugsLZWcXBrw1CqPkTK7cTHZui/GPuae
	za4WzIN7nuxKXisb8ecQGY8SOmg1RnM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3ZYme18sETK1K7GUExeAzS439Fq52P5lo1OFNmk1Dg4=;
	b=feI7kDLaw6UTznXduMF5SyzlvlGSHqYZbWM9Rk0Zp45grfEBaxm9fUqpLfybzXkiBGQEKnKQQ
	Afh5JmOkWcywNvsNDF+jdMLYdld8HPHEonJbUnnquch+wbGSpU5qy9SFf3aIqsMtI0C2ZhPcKeb
	6xsMBtTdJ8b+wYDBHxD2RE8=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4clbzC1HXyz1T4G2;
	Mon, 13 Oct 2025 20:20:39 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 1A0DE180489;
	Mon, 13 Oct 2025 20:21:21 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Oct 2025 20:21:20 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 1/3] mm: mprotect: always skip dma pinned folio in prot_numa_skip()
Date: Mon, 13 Oct 2025 20:15:34 +0800
Message-ID: <20251013121536.2373249-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: z4nf4ctenuq16tsg65r5xa5efwnprmmh
X-Rspamd-Queue-Id: 452AE140015
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760358086-56002
X-HE-Meta: U2FsdGVkX1/MkyN7yheZ05/fG9/FeFYo3FD4lYJpqlZB4ErhuBx0F1rL+m7FWpmQXKwxF/m++NsWOy8h1Pe4I3SGN0DQ/pj+VjacPJdX/DbPcrfYSEsfxBFm6NaUuIimFdm1yudeHGBoF4sG7qCl3Je2XoiH2H8jttjyO4jNanWPOXanYtMsvyoXM59GdQ8UrCdYpG/8I/AKYbvuIt6lHImMhRjaezcbxTTYqbld83nxiWMxAMe+Mi0lo9eNG5b0FeiDbOhJF9+lCFCFae5kek/wXUi17JykTcrQihePDaiKy7zTkBweIkakdjK0g3sBZNPTTHdURwYU5ASR7Dyd1al0sByLrDD6xIGYl8EtLMbDfp5nD5SYg8ZiSLQMtrRFOH6eM+uxZmwa01poC28HnAnCNrJ7UnUwV711MDx1UifgUn2QXvHDvGi1tBwh45YoVQjqv2XT246VJCWHJdrCxUQo+DpzwvlWq8NP5ifmtB10uuNWG00vPwOfY2yS0p6qbd6QuWHhI/Wm4n2zR/LrhGic7t121p3v2TGJFv932uMWtv+x4QC4L4k9B6/rCQqYCe88SpcDbN6mEccfzQrLtYFYsNmY1+f4pYiVJ2sQEOLW6rMuFYvLK5Na39k2mkN59BQZAiE9Uskmzg2Kgu5CBddyeBKMgOuRTppOekYuluXnU4JV283JQulg4ANUNmv/qQN5Hb7R1nZ0xrEJbsqU/D0nNBM/QudTQ5Mz9aEitTWa1A9in2NKLomUpDxhPWIzOY1F1sqOWKGQdsI12aCrL+TIf3RHzAsbA1Q/u8GfHdvOXVGuXxTWMMmXoY19vnxcsjmcbg2suARzupDowsC6hzz0gPe/M8uVyWIDRflmvOwpVgEeNMoPHJQtiJS9qPSuKn+r8kN0yUZaGJPskzkPowucpBF2CXdlV5s7QThcSBOok75o/o91hnpeTkkBElKgXV1A2NthW6/nsuSK53I
 39z6874e
 4kwNTe1+t6h8+1yQrvNi1XAaW/gldIYc2wDeXDoNFDUPkV57cklCro7aw/jTxfS1PDL1kStANnRW6ytPE2sxq3Q0Yec7s80QyIXy9VipiM2F++MyfuFP1d6Qv74d/rCBrYmQQbTVt+Bvn6Xjoe+Iys5rvmRCociX3EWrq4aeyNRj9PBNIQMo1s34kYOwEd+zmF0Vo5odUtBEvPzpGD3iJn8msW9zH1esxcxQzPEXJZ/QCJnbfQOEw94maIVVDcT5FisYdQZX6SNY6IaBXEeQ8SAj8MCGSoFsYrMBZhQTHV8uTjvJsbjokQS/SrIw58LYyf2Np
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the folio(even not CoW folio) is dma pinned, it can't be
migrated, so always skip pinned folio to avoid a waste of cycles
when folios migration.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mprotect.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 113b48985834..51a28781de9d 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -136,9 +136,12 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
 	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
 		goto skip;
 
-	/* Also skip shared copy-on-write pages */
-	if (is_cow_mapping(vma->vm_flags) &&
-	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
+	/* Also skip shared copy-on-write folios */
+	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
+		goto skip;
+
+	/* Folios are pinned and can't be migrated */
+	if (folio_maybe_dma_pinned(folio))
 		goto skip;
 
 	/*
-- 
2.43.0


