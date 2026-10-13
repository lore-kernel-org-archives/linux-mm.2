Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C18FCC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 10:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2806B0098; Tue, 13 Oct 2026 06:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9F16B0099; Tue, 13 Oct 2026 06:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908156B009B; Tue, 13 Oct 2026 06:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69DE06B0098
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:37:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69E9440407
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:37:24 +0000 (UTC)
X-FDA: 85317251208.15.3965213
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 93E1F120003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:37:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=O7lRj9VX;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791887842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRNgZp7SWpJGWJ66cpIUHUrLgqPlOlzic2FPa4ozTu4=;
	b=YyMlAFcIUCUxa9D7m9wM/rHVXxiy38SuYEzAseGdHbKYAuxDNbTYBf/KFdib27X61jzEQD
	CeU/UC9oatFAJ6j+F9KTdEwa1O1YXussMSsk565KRVkAwLIh7kRyfC88TsRVcLkAhG56OC
	vyJLmDvcgKMTDp5I8mD1YmpMWlXGMH8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791887842;
	b=zWWDWNwerxe/ejbfiHa3SRxky0C65xbn1HsXs1cGdWiMNOv/KikMu/IXGnAehpZnDP1Bni
	eatlRqRVHaNVXO9vla0hra3V7lygMKTCPSZ5HntLQ4LbYdE/5auTtzekJe+7YAXyCXOaD7
	28UgvQb7nuWuY2gTbVx/V5sdbHHs2IQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=O7lRj9VX;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F40C169C;
	Tue, 13 Oct 2026 03:37:18 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA5DB3F7B4;
	Tue, 13 Oct 2026 03:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791887841; bh=zlm0jggjoGcBtjF+7NJSkqsks8KqRwYRxYBdaXI2m88=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=O7lRj9VXE8HhrWghHpCesoTCpOa3V7aRgApIrDvh+G4vpyN9kUBHcyI1lhxEtlw94
	 YUPHx70ypb3+oZ3nDuN/z5PzeGIa7O99Yd+lDTkwjvJYuAoecmMhhrDMAqriWnlMcO
	 cb1EBGw0sasp4JyHpGH461ycQ4qUAKK37LhSSLrA=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Tue, 13 Oct 2026 11:37:05 +0100
Subject: [PATCH v7 3/3] kselftest: mm: introduce size_to_shift() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-fix_hpage_macro-v7-3-3d77129e0557@arm.com>
References: <20261013-fix_hpage_macro-v7-0-3d77129e0557@arm.com>
In-Reply-To: <20261013-fix_hpage_macro-v7-0-3d77129e0557@arm.com>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Sarthak Sharma <sarthak.sharma@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1845; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=zlm0jggjoGcBtjF+7NJSkqsks8KqRwYRxYBdaXI2m88=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqzgnUGsz8VkHf3mY2KQbmGhgbZWDJCNsolUO8H
 01cPlR84VSJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCas4J1AAKCRBt1cPRWsUx
 M1/MDACQ/yPt492mMgEomDBdxPrbfqQ8emxOnCQeHS79ptrnJWB8D6IXBWsMkDP0lKCYRTT/L07
 S5bPI/4B1oGOnQceTWPNgKijv32hLXOHE41QxS6HAx3oYYygOg76qW+uO/1pbAkPtqUAxj+7o+T
 yLY75ASTUOQP6MEl3McNffBU8TC9SSxfYYgQ0IO/u0fEqLx2StFMzW98W1nYqf0FlnOTtBV0Up1
 oE2dG2DXcM7RZe1jKWhV3Vp7l0Ar3GasLmWro80gjUQisxsUt3vlIhITqZSB47GNd5ZrnTR4M05
 +GqBhtoa6l/kd2OT1CwBWxyyJ27coDJXxXsT6apbS6ftJQcFjmrA8eLY/0XFCMT6FLTWbmeRVU2
 wnoo25/qOJWZK7U/lkkkarU5JKgkkNOTzR3EB97SZq9I9my7tWxx7Gz7XFEn2IhwTPAAz2cBS8l
 SLO0CfhTgIgiRnxYEoblMZ4q9Cm9J40+T2+/Ik6jYuA2g5TMnMeNhzk+vr2n4RjZ2Wlnk=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 93E1F120003
X-Stat-Signature: 4n7g9b443qonkd5ejczippmemzghanyr
X-HE-Tag: 1791887842-416627
X-HE-Meta: U2FsdGVkX19/9Tj/cecRcMnrky0q67WqrvF4rrWr9SNpKr05slJxkoyRCo5WK0qLYSyYBIaoVnsU9i178ZwHebi+QLm+EpGC22yS0Tkf/HFE1Z6yDPIHKgHPler8blBt66ZLYXxqeMjCllDhUOn+sEZaafQCMcneQsy7sW7i2weq64ZgiikCEPksXlIeCwLNiX7WGd4AqQYc8Af24H60Pd3YD+0xbnZEERp7JIpgKEytm/+vgTMJenqetTDvGpNlhKnjgBedh3sSaepAqtA5X7yjRd21W0XWFFVNXRCC4UDq72W2fjc9TAA26iLTHiqRYwjvaoIHId7e39YAWHtkzgtBomU22xJjWc/veX+Zi9tTGBRbgQTXVvjVdh8ZjXvQSGM2urkaGCMkPTO5oB5mrcSmWAQ8nK3AQR7Nlpcuu0hPcU7upnDqufHi4yzd5sYzil58mthGySfPosZ2HoufZSIO/y0Wwe79w2wD0jFWEMp2JAblM7f8Ovfr0mMGi8K77VSf9OfVZHR6Z18W75tvQtIEK7+IBaeMsX86OQGNT9GtipUJcpJZHjLq3uBSMkmLLkfLM7O0W70MwPInYKRTelNdhFe8Ji5X2muyqLu7G1lfvmEZRccSzWdGh6IuKIgLEywAq3eDJvn3u+VLk1fG5iWvWlzn4I+tCYbfpqpSDPFptCh0CQuG+4N3RMCadFAXou8NVSkCZCzHxB7Gzb78MA2dRfHkee1Hm/h2e0W67x+ZaBvojJ9uxVmBNrtC6Qqx66KVVxd/PEFH+qrEG0hEdHrrrxqBm9k1FwQ9PvhrYK4nbQ3VzoZv7pGyKARx1DF1AYCW330gnqiZXpc+5WWCihS4wwBWGzH3c7zXcohMo0IrjkIU2eocXMR+Bu3puhqesOPmknpHwutBtqfVp5RhO/DfDs67IxX4azDbn9JQPPw2t9iSG9+rsY7a2qVOx9qbCkiPMQ2hvTllhFO3ZXz
 G4P7AsG+
 CzWFCAP69CDolj1r98BZxUGBlhiNLTO1ee+m5XIE/v/qiz0nVAYZim10zHvLYitYG2aMQhfAKMraozQ5KYtzpbVhBANzdIk4jndCrjWGDOO3dfdS2WVQevC5H12/K1hhBUvdpBl3i5rOXpv9BBrVKtgXu5niHsNWP+rhuZmZgO4z7Uafkmskh0DbPmn9CB7to2dLNZxT++mRvPLZ9YSR09v1Q47owAJPwl4mNg4+dmom6cCPzGRpyrZF408/3RMmTRHNLzwvjaplLldx5st+SmBZhFeb25bGGvjXkZ6tO7NQhcVUVQgTLt8FAdUjP8dGUYWU5iAxku+mJ8Po=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce size_to_shift() for future users that need to
obtain shift of a huge-page which is other than pmd_psize().

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 tools/testing/selftests/mm/vm_util.c |  2 +-
 tools/testing/selftests/mm/vm_util.h | 12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 3b42cbdec7a2f..8ef226107d788 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -194,7 +194,7 @@ uint64_t pmd_pshift(void)
 	if (__pmd_psize == -1ull)
 		__pmd_psize = pmd_psize();
 
-	__pmd_pshift = (__pmd_psize > 0) ? ffsl(__pmd_psize) - 1 : 0;
+	__pmd_pshift = size_to_shift(__pmd_psize);
 
 	return __pmd_pshift;
 }
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ff51c61636505..67ff4bba5707a 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -159,6 +159,18 @@ static inline int sz2ord(size_t size, size_t pagesize)
 	return __builtin_ctzll(size / pagesize);
 }
 
+static inline uint64_t size_to_shift(uint64_t size)
+{
+	/*
+	 * The function returns the corresponding shift only when the size
+	 * is a power of two; otherwise, it returns 0.
+	 */
+	if (!size || (size & (size - 1)))
+		return 0;
+
+	return ffsl(size) - 1;
+}
+
 void *sys_mremap(void *old_address, unsigned long old_size,
 		 unsigned long new_size, int flags, void *new_address);
 

-- 
2.43.0


