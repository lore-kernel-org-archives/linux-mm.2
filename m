Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 570BAC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 12:35:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BF3C6B008A; Fri, 11 Sep 2026 08:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3715F6B008C; Fri, 11 Sep 2026 08:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD9B6B0095; Fri, 11 Sep 2026 08:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B09E6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:35:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94777A022F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:35:40 +0000 (UTC)
X-FDA: 85201427640.20.C21B544
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id CC5D140007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:35:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="i5EU4fj/";
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789130139;
	b=2Hx41HDclx57u7wxlcex0j8FVi83R0IIrTTg4RDKgvUP/6tGTSvdJlvyhOsHeP4DfEMW7Z
	hwOj4AUebDY9pvJblFafr6iVVSiGVPNGqjlUanJz+icTCbGbnQ125gLZ32eVD8GqIYGCO6
	Er+fTdg0rSoT/Y/DDVJTcwHoz/30JK4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="i5EU4fj/";
	spf=pass (imf11.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789130139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mpPsvux4zk6ISImwqu1pfGEmUB8gAXsQYEbIY0KWB2o=;
	b=xqCoCBChm1QRVkS4SKTlT7Loe1KGfUf08ZmsY4nBLKZbbOz3SSYV4knebkPbOUd5iCJ6Uv
	+ST1tWptiFhhxN/SH6YNVgfVzIxcCtFpv68P+9dOPCRN4h9hv2DMQ7ccaaKcthYQU7OAiB
	8LcMl/6suoL1wNRgou9l+rRxSaEmcXY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 158531655;
	Fri, 11 Sep 2026 05:35:34 -0700 (PDT)
Received: from e129823.cambridge.arm.com (unknown [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0395F3F7B4;
	Fri, 11 Sep 2026 05:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789130137; bh=zcwDMu7iEB7zmUgykeg/3B8CWbzREswfdkg2PObf10g=;
	h=From:To:Cc:Subject:Date:From;
	b=i5EU4fj/ZFSEsCwvxg14J6Cjd4C8Hotg4VBg++yf7LYJDIi8EpfGsregp7sb3c69d
	 j3k7MTqVj2GZtpHe9avSZa+FBxgyUm/pmWhD5MGWGQfDkOtolITzYZQoLCYXdFBmCU
	 BuO+kEgSXC9oBDjE/OSTgMnatQiDcMaXpKSrrtQ0=
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
Subject: [PATCH] kselftest: mm: fix potential failure for merged VMA in guard-regions
Date: Fri, 11 Sep 2026 13:35:34 +0100
Message-ID: <20260911123534.1181501-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CC5D140007
X-Rspam-User: 
X-Stat-Signature: 83x5noy33ys4eb9pysc75w3puh1p7fhg
X-HE-Tag: 1789130138-500575
X-HE-Meta: U2FsdGVkX1+rfwYVEMLAHx7oVlJBYA24knvMKB2kxJGuhjXg54DLlTvVzHQczmp/Cg5u6d8vjVpLgAzOQLmP2KhyY0TxnHZoOkWL6xslfySX8jXasLEkAOJN9KIQvl3M6QEBa+VIbtYctqHT1X4Kbi4OHZxY6Xco6vBlwqBCzcACveIxG5BfYuJ/P9+NLSECuV9PaKDuuz46APMy1YsgTki0LuaPD+EDqSOz4yxW+g5xU5JiRSwvwevIIoYObNNQDAftcGu/q81D7gImEu7j5N0SeGWqjyjVdU72VCetYpuBofUn67R2qd9eCZV5cTzM1Pp5RCC1FqzvFbEIp880z/jvqB1o1hNYdnxRt1QMOmumlu8kwvJ3PzJxDKD4Cn+Z+71RZqhWqf6DMCkVqikxXwmtvOLGV9HY28TwwK+vZNQ/Mopy7H7B8MEu8P2u00C2cA/rhImGpGLfEOZt9/ZdqLnwIgCV/DWY8YaLaj1grQWQW63toMszNT9GeBbXm8Kskw/ZYXe70NWR2JUxgl1+QyYeBJ77VDnQ+DFptsRoIVYP7fjeOkU1ITYa3TFATvy39agqaHxxNowuIw3jLZ7RtVNH1GSM+TFl1POzAipwIrCZ1jKG83u1ouwDLxPVZo7ADY1Ggdpu5wUxVWQo/TUOYInZemxsoLKKOXV+bUNEgijaPO4+rncxCVv9mSA7V2s33Ss+xl/wJGrtSxrV0CY6Frc5+idIDn0rxgZHvEAvO2ZTGSrWVlkxZmr4eGu54PkJNX/NGVVGWCF0J9O06vm2AUAZB8fP8VtS3j2glQfW6Ob/wJ9QjyiTSk6M0SiVfMJBNN08bZIv3PRD+oN68shCKP64sOUiJtam75XMJ326Fvz620bcK184lFf0swi5t60N39LxqT9M4ajjEn1CzGjRicKc4U50kEAIVbNfKt1iNcUdovx0JVyu+3Y0nw91IKYvxOEIFNQOMc0yO9uPELc
 8rLaWMzn
 1MS4eoXnijmhsOgVQdS3w9W/CzRopSi/N9VeC3kCW9G4vrVaw0tRFA8664kXbjwpQKIeC+GV1W/lHYV5o4fM0MXybrFEW68Zw6rxOSCGD/+t7Muf+87XHm418DVz4g1w90a3PDIZWhNK7SpqkviVJ3AA9jOMEefyC0JGLPKIEWR4+xjnwgOl5aDafQWt59ngFUBAjFcBgUBUMTKUul1Hh0jBJKQJr6X3nf6Yrt4xtPNKmNx+t+ClMKq5Sbw==
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
 tools/testing/selftests/mm/guard-regions.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 5c8ec3ca75d7..a28a57d34e97 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2257,8 +2257,18 @@ TEST_F(guard_regions, smaps)
 	char *ptr, *ptr2;
 	int i;
 
-	/* Map a region. */
-	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
+	/* Try to Map a region. */
+	ptr = mmap_(self, variant, NULL, 12 * page_size, PROT_READ | PROT_WRITE, 0, 0);
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


