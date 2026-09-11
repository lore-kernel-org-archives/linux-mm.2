Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B25DAC88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B238D6B0093; Fri, 11 Sep 2026 10:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4916B0096; Fri, 11 Sep 2026 10:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12076B0098; Fri, 11 Sep 2026 10:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5A36B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:29:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1829160270
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:29:20 +0000 (UTC)
X-FDA: 85201714080.28.81FBFF4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 06DBB100002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:29:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="t/n5yxpg";
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789136959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=R9s1oB20x6+qTzzhbrShaDPLsz+/7fzfVfrSH8TTQ8M=;
	b=2dUIXI9R8QWzMqvJiv3GT52TG8BdsZDV0sEGcWsD/+7riUCfu9zjpb3kdj0XJqb4N2evCG
	FmsmuY56qFvA+LzCjbnTA3eaXgP7d/+tW4ux39H4KBnBX0poLKc7WiAnL5iAqgGQZbyU3a
	9UCciYnvPRshfi9GIoQBCiMJ+SL+I7o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="t/n5yxpg";
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789136959;
	b=XKrtDLYQ9bqs+rqK/hIMWPP0ErUpFwoAumdF4EId+LojjtG5qMbQnV2wxmQJlzXnQUpsdZ
	Dis0TuFwYccvxAsspawU0Iw/u7Ie/iYz1Zt9Apu/ec/JpqJWj5aU9W2WzadRE2Jz1ZCfCx
	lDhi5ihxTGBUWHTa+lqHy9fc1R1b7fQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C58D16A3;
	Fri, 11 Sep 2026 07:29:14 -0700 (PDT)
Received: from e129823.cambridge.arm.com (unknown [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7B7053F7B4;
	Fri, 11 Sep 2026 07:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789136957; bh=goER+PRl5M+XinmIsN11F1totcROkCZg1t/jSNDQghw=;
	h=From:To:Cc:Subject:Date:From;
	b=t/n5yxpgwto6maQgmjHoXtiUDq97KYpJQIXFDb8jbIbnrKsYcMTk1zMlRHBG83OUF
	 AJteqyURsi6A95plKNueo9cdJgI6G4l8djo8i9LZwUXPCyOK7pMq/uB/dB2N4s/V7r
	 0kUqjFNQDXNUnCZ82p5tFWf3s+S65/KomICdbG9Y=
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v2] kselftest: mm: fix potential failure for merged VMA in guard-regions
Date: Fri, 11 Sep 2026 15:29:03 +0100
Message-ID: <20260911142904.1825452-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 06DBB100002
X-Stat-Signature: s1s377o5qnnat8kp9frhq8wk6gqnwq3b
X-Rspam-User: 
X-HE-Tag: 1789136958-853157
X-HE-Meta: U2FsdGVkX18NpGbmwjW/7xB60zRVBDV4R+XoTBJBUIfw7Qx9H+0orLPrK5Rr7lyvg6amNsMZOjYnI6s+Vw7819heMQ4Pg+umxoo9Ddt+c13CE+OU98RCcd3Q3NyPkie3kecwYLEURkNKpemaHmf3X3aKTVFeztf6P6bS7Wk18wACAPtp01tL5s4HfhR/tzZx3O2GyUN2IcOGGz+sM3myGMmLlrt2PkurJnGRk/BWyEAV8ynSRavzBcpRbd4yHQW8yXn6tSVHc+PJROlzgq5zgTSCPgmwQTnUraEOSenFzl+vEisF7spG1Gm1KpB3IbvrqDlDAv2DFpddxiXHXeTsy9Kb2jI8NNA4NrexWy8F9KhGmv8riKA8W6/YQgWGdtQIrPjFPukZYdX6idfGIa4AzgS/jV5NLU3IJAUBNjZcHE4EbMHGuDvPgXSjQI7+qRCS28RRBKy+VvXPD2Y5NrZvUbwonmU5Rp0LI2CJOJuXf7vN9hYu9PCGPsSstePaxE0BoAlizgsHi/o0vi5HCzR2SLaY4VI5ZAVOpNWmwgpapSfXVCXi+sb/9keqbSN2eovetZyd8TW6zAhF4SBiU1u+W45KKJdtD9F23WCrVCv8uxc9LZ1boCyotTTaBn8eWuJvc2StEfkh12LAns+6iW6kG5IPFgbvBzcOzoThRmPKXUkdMEWGjJ2frAaCR4qkeR8Zf1K1eaRlwVNoOQbGF+L4SLBPLNresP6yu07dL9gHEXdwUj10fPTgQVRE+K4d0ph7VgNfAXM7ltE3Xd2cDnWRF8RGx4ok+GVzd8q85BWbMi2MrVWkuArtkaU9RFp+3i+bRdTSed0XZZ/iwvGyi7RDYXP7o4XkKqmgGDAW3CwWcxA5Qp2fBm1K20NiLpFXlHhXxx98TWJJ8yPjBQ+eJLfFD+z0vjCOtQojKVMANdbyTDj4NPIv10ikSv2FpljO+bLILLOQSx6AUaj3+VggEPo
 q75zt69t
 FkN+L9QqpT97P554b6u5MGuTZ5cbaUgFQRBOPB4UENGvzsI/MRq3UQ1wAFa2SLc04CnO8bBnKEf/u9XYl2gBthQ1ZbarPkG1fDJOv+qscsAI9CLdg6poJZRxuQhC0nkcWwi5+B0Rvirj1K5Mt84HXZ9/J+N/uOXTLANLC7huPZj0YIeFyj5y6s9HxJDVZzpEy7vgym3hNaWvlMDwE2X/GCIEUV9MvamZDr4ty5PAjmQ7b960IWWLioGnMADfwyk2FGyy9K7NBW17DzUY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

check_vmflag_guard() uses /proc/self/smaps to retrieve the VMA flags,
but this can fail if the mapping is merged with an adjacent VMA.

To avoid this potential failure, first allocate a temporary region with
extra pages at both ends, unmap it, and then map the test region within
the temporary address range, leaving an unmapped page on each side to
prevent VMA merging.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
Change in v2:
  - change the prot as PROT_NONE for placeholder region.
  - add comment for clarification.
  - Link to v1: https://lore.kernel.org/all/20260911123534.1181501-1-yeoreum.yun@arm.com/
---
 tools/testing/selftests/mm/guard-regions.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 5c8ec3ca75d7..b724d62d2b75 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2257,8 +2257,18 @@ TEST_F(guard_regions, smaps)
 	char *ptr, *ptr2;
 	int i;
 
-	/* Map a region. */
-	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
+	/* Map then unmap placeholder to avoid adjacent merges */
+	ptr = mmap_(self, variant, NULL, 12 * page_size, PROT_NONE, 0, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ASSERT_EQ(munmap(ptr, 12 * page_size), 0);
+
+	/*
+	 * Map a region for the test. Since the preceding temporary mapping
+	 * succeeded, this mapping should also succeed without merging with
+	 * adjacent VMAs.
+	 */
+	ptr = mmap_(self, variant, ptr + page_size, 10 * page_size,
+		    PROT_READ | PROT_WRITE, MAP_FIXED, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
 	/* We shouldn't yet see a guard flag. */
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


