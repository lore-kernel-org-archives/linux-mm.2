Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC2E2C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5826B00C5; Tue,  1 Sep 2026 02:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8D046B00C6; Tue,  1 Sep 2026 02:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3DD6B00C7; Tue,  1 Sep 2026 02:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A78A86B00C5
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:52:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13459402DB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:52:49 +0000 (UTC)
X-FDA: 85164275658.09.18EB815
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id 76FC820006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:52:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=klssIaOx;
	spf=pass (imf13.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.207.22.56 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788245567;
	b=pb7hiEhGtgjqZSWT+fYxaP6+JP34uV1/s4/6ezJIkCtACQkRUS/I2CjKz04J/gD+FY4dm/
	POAdhNYnzqCes0Nm2zG9afGCphluUt0Hu6qgUKVD2ooGuENc7Y30QM1SZnLjottlQGic9l
	lAlmSWgelJOoSEX0O6GAzNLGVrv52OY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=klssIaOx;
	spf=pass (imf13.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 54.207.22.56 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788245567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FKNpdY0y49xeNECExSigP6VaPuOeny46D+aFWqWtap0=;
	b=Wc5Lo+NjoIws+G0qONmVyUclzaYIhQutkj2TfjcKyXgNCSIEU8QrdUihfU4QWr8JZ5oy/4
	HQnumg/vOTgDjIPZFpDxrNczWgpoetXNxuh9Da63n5lpuIg61qYykhOJAhdzo4p8cxu0Aa
	V72TFPYwKtbpHs4XHy3dsppNb3sstbo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1788245525;
	bh=FKNpdY0y49xeNECExSigP6VaPuOeny46D+aFWqWtap0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=klssIaOxnQGAIvxsbgwaiB0uHbjeoodZ9Ydb1V62fz6SrAiFALLHPgdNl6J9R/G8O
	 TghtATYHvKnM3WZyPCEJL6e0AaXveAEzcVi6c5mn6KSbEJ9g8mL1wLcO7trGkHKu32
	 IhBjU3e71QCpSRFcTOZBiT+Usva/sVr8WAbFdyZE=
X-QQ-mid: zesmtpsz9t1788245519t6bfe178e
X-QQ-Originating-IP: GTVdNpFJNH4oufvYI/kV5iPVNhwkBzEpbgcvoMUGl6g=
Received: from zzz-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 01 Sep 2026 14:51:51 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15009900098412866890
EX-QQ-RecipientCnt: 13
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: [PATCH] mm/migrate_device: fix function name in kernel-doc
Date: Tue,  1 Sep 2026 14:51:31 +0800
Message-ID: <7D206FC95BDCAA0F+20260901065131.1759298-1-zhaozhengzhuo@uniontech.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MxUsbsd+F+abrwtEfkCkJqgekDuECFw+aREl2OG5bpJZj9IcXCf1GIeO
	KC1xqhezxOUfLhRFWQqzDzcrDhF0QAnCU19ufcRhfzvBWgheVfzCG22KWyPGu1ZivI23lx2
	492avRA7EclPpCOmXpRbHDLaqzmCZT4qc4XiBymLVXSq1qmOsj0PpgSVV9HYOSOsf2KM/jo
	qBaY44EeV67cof8B3wgdQZWDzjzlwNcvEP0WH1zBNDQPJyqwy6fdOhvKfjS9AkJhvy3muCi
	hESkkTONP7wHWw7FMo61YNR1AhYByjzyI9oJXX3bfEqJrYEA8iFFuvGHM+S0+1zUAFpVX+G
	mSCedA4+uIg1cSK19ikUOmjffSqhjJArdIgcLHn70vhw5eIoq4A0MrkjVfxc2g8ibZF2UR+
	CZIKnwKbMMAL/yhgjw5xlbyDms/PybK4QgIafItfE4WvOnLJZP3txmQUVTmqNgyfLIPeAlN
	rSVQT16Z0nJwtlV2Lut59a7XG2ZcKihzLyN890GCnCVSK1MlmZOviiHawxjiDgxt+CfynuV
	foyiY35mtlJHl2LS7fK5yN+2la1YVhm7V2097/8DLhIAYC1yMTMGkOvf6un3SMRbGsNpnfd
	hEpkvavVhiJ6lXwKR/BhFC41CBAeW3js6Pd09rUHOZG8xD+IcZhQuUSx4M3N6M+7RZHhVOM
	bvlwqAOC8+BCPp13l32W2zGooWH6RpFpQD3TzTC+FqvjMpVBrnTV9tY3OqJ8VIHZRK9pciT
	7GJdeR7u36P/OMLb9mHdWS4759KTD4v233sImEe97JRH95VVawIuVRFdujFBITA4bXFRal4
	oUawxpX3iLwu9I3BHqEXlDStYYi22D8gpkHye8XsDS7/s+WArIIW2naAxDYTnfxVaLJMn/M
	b4LPKyFlGcj+mfjVifDkpg0BqGJJKKB7fV/vjFGuzvEJnAGm8AjPwojbN/FGYUYzk0D5Kvn
	VL9RYzFsplymjiVMei1Lx24r+pc1xh3MNXxu0bW2Hv9cQdI5ycLCpkyxJJpYedFDz1T1yMV
	z/jbukpYl6Aum31vmHC7r00VHfkX13sRa6LZzk+g==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Stat-Signature: gpxrccjt8nkp843w7dmkm7fgfru35ewk
X-Rspamd-Queue-Id: 76FC820006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788245564-832241
X-HE-Meta: U2FsdGVkX19mT57wrwtmdLXtj74SIHU4WvXn8HQwSHbPC3oO3DEFUaJJAnqbCfEFwlsaegbRAO/Hbf+yQ2jlZzO42Vya1+pjBprix0z43b747zZraQveAPaZyqJtDO7WYYk74L7KdE6fU9YGsq6G8ykfSc8ijJtXsLcmZ/EbV2KQMo+lcXQYjg4Ro9EZTuMi98yVMeAur5ZBLdgp7DA1JyCr6xfsBChgms15moN39erohz4hy3mEFXgza+h7Z3ecJkeMDeIVsr69YxM5VqgbOA1VWu7qkD5Q8gULyaKQoPmcDczNcMnnD93rgJOnXurq97uzNVVZSivLrEVZ57Jiqp1n8k3p3sDKVYzL6zLpqrmtsB7Ldb21jINQLacgmNYl+jShPscB2q9M2igYFm1HUtmi64wfUuO1iCSdrHCCzKm5iXVjGbDIZoijICwkUPG8PRQH5aaoJcA4TRPCZ2J2u55yDJ9wvrCUa3jImJn2iDfp3gtBwhmpbA/RzTBtbLHr4RhDwqxN2LIK7v6ULFc1EqAgYmmkHfwd2/wjwlVkjLUYZNOYixY6B7XngMqnjtOrtyAim6xRkwrstIt0i0R2Xi4/fl6KqAQkbTGjrjXPPMeS5b0UdkObb+2u0B5UiQ80+JOccivgBNx8CtGAltwuTc1jKbj369RQTkRknWvii8Qllj7vQDHXnGRhw0ixv5yj/ofPetZvDBKWWhklzsWhvtnjkolUXfZdm7TdhY+msnqW3l9tdu9MSIUGSljJItIpIQaG4qu7xo9QKbzwbHEFs9YA0Cz4b49/GFoQTyt+DDKwPh4859N3/wcOSDuXTMJkvobYy7ZK3O3Afv3sIvzfEX6/+hvKJUQNLUzutBvDKtvY70l30X9AchxQBegoSIJ21CLsNlYB/D203hLGegQxvL6lnj3PrP4m0ii/voHjwW/GjPgA3CdYAT+pps3oOLgq/fu4fkNMQB933yzuzvb
 vFFv1lVP
 PfJw7p2BqZzDhfsGHM8kpKneak+GWM6laBTSQ4+3sA1ZeR/nyIInCNapoJ7F/FKcu8EMzA1J/+TZHSeDD5jf3iFyNUMhkp3p9uIJDZ7Jj16unDCs+ETClyEYctUZp+24IH5vkYSP3otqJ0CRwX1f2ko1P/uSzFhkOwzJPLZW0VzUcLOqKm4MjhKyZGUXLrw87u+zRMxZf7MEXqWetpEOxYHe5eGYgvXpPlMCf3fYrZFV/tSlZ90Sn1sFb6XU6eNyxu4f7kRrz4egcU3OgxIP8VXLqn7yiOmymUNmw6nMBNLnNpNPOLYjE598t2ynw/6W+CTqx8rO93hMBoSlMizQyz7vc7Qn0vrZELZhKHqLwFgpbsC2qwIebFn+R2ph2UjSeXdv+p9W+9TnHvLyZZJvwBfd7u5qnGMXTfxhFdjAoeGTC/LCH940NRE4AO8gsG8an8A5qB19u6aslYPikq2cJKfEtIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel-doc for migrate_device_range() says that migrate_vma_setup()
is similar to itself.  Refer to migrate_device_range() as the subject of
the comparison, making the distinction between virtual-address-based and
device-PFN-based migration clear.

Fixes: e778406b40db ("mm/migrate_device.c: add migrate_device_range()")
Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
---
 mm/migrate_device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 009bfa8b212d..4a614a3488ed 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1398,9 +1398,9 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
  * @start: starting pfn in the range to migrate.
  * @npages: number of pages to migrate.
  *
- * migrate_vma_setup() is similar in concept to migrate_vma_setup() except that
- * instead of looking up pages based on virtual address mappings a range of
- * device pfns that should be migrated to system memory is used instead.
+ * migrate_device_range() is similar in concept to migrate_vma_setup(), except
+ * that instead of looking up pages based on virtual address mappings a range
+ * of device pfns that should be migrated to system memory is used instead.
  *
  * This is useful when a driver needs to free device memory but doesn't know the
  * virtual mappings of every page that may be in device memory. For example this
-- 
2.50.1


