Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBF51CA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 17:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF4CE8E0003; Sat, 30 Aug 2025 13:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCAC18E0001; Sat, 30 Aug 2025 13:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0738E0003; Sat, 30 Aug 2025 13:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA4318E0001
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 13:21:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65B12140178
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 17:21:55 +0000 (UTC)
X-FDA: 83834091390.19.6638A61
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf08.hostedemail.com (Postfix) with ESMTP id D6C50160014
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 17:21:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LRxkmCly;
	spf=pass (imf08.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756574513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6k3+B02e3odMmhUwmh0jFXp9oc5stRoyg/+si6Tj6Qo=;
	b=wAIL+a3HrIdPNLmsNOJyzlHdnjZLAjxbqe8QquHEfw+G86hBk69OjR1V17ynPcpk3SjgMn
	oMTs099d+J8+ZgFLIlnBi7NnwX+rfE9SH6UT1Otj6uTqobtj7RTfaEFgPeLnI/uHJ6k8gy
	ikqBtkLyMzbAPxRtZje3f8Uc/41SWDY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756574513; a=rsa-sha256;
	cv=none;
	b=Mf2Rk1y9kMcOq7dTKSsOeBI1Wo/XomHBfVkrm+MykNVu+/LNiyXbYxBIY10lvzKa/p+PN3
	bY46C0rzt7Zs+vOGZfOq8ZVZiT7MjdnaOo2G1hd3tUT2FuuxuheCjxVOa7/hKu063WLP/x
	FOAhTiUkAVv+Z6PmSN3nGKc7255rSkw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LRxkmCly;
	spf=pass (imf08.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756574513; x=1788110513;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SjSHcjvCde3zJDQywKyM3uK1xuv3N4Cpc+Gnd/ago6s=;
  b=LRxkmClyPvgYeBCbTV+5NaafMDgPsOnYhTN5+LidUjZru5G7FP5YKRAU
   6e/KFRs0m03HM83FFRWrDioz6EtPUXqKn6uj2yFKNWiFQXH7HothuYCmZ
   EYCKqcVEf10g1wDGnkxM32a/XKttk/jDfaZ5r5okOW/ZXO4Oono+pNsym
   SRm9zPVoDNyMq86r5CX/I6GIj0qVsXpdLbdvnlNTBwr7by3S6EQuDplay
   ALDqH2vMgliGK8wKG11+s7/bTkcQlN/xMX40ULTZRxYsg/Dj6jlIvh2T4
   g2XTNjVHjW66lF4qLOBr2K/AbUdafgWr5kUERWikcJ48+w0P3/4s2S8Vg
   w==;
X-CSE-ConnectionGUID: 5NcFcmAwSh+bG6qW5lb2GQ==
X-CSE-MsgGUID: pd8DuHJFS+aleHQX5/LW2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62667497"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62667497"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2025 10:21:52 -0700
X-CSE-ConnectionGUID: Jfuuo0EHR4Wm5UB3Y/DJpA==
X-CSE-MsgGUID: DmgXPHlHSZ6zLrCKKM2ztA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="201524084"
Received: from baandr0id001.iind.intel.com ([10.66.253.151])
  by fmviesa001.fm.intel.com with ESMTP; 30 Aug 2025 10:21:50 -0700
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: [PATCH v2] tools/mm/slabinfo: fix access to null terminator in string boundary
Date: Sat, 30 Aug 2025 22:50:22 +0530
Message-Id: <20250830172022.1927448-1-kaushlendra.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6C50160014
X-Stat-Signature: 359hqbc137h5ggqk7857pog4j16j8ix4
X-HE-Tag: 1756574512-565388
X-HE-Meta: U2FsdGVkX18s+fW2h77Q02223x2U8+opJzjstrOgGzhRqEFewEs7CASQm/qeL9ryXOWjc5+cuqiCzHecHzPw0/3rcOUMYzOzyMlBa3NXHW+5Mlyf1eWdvjcjkDRfEbGMrBWitvoLhU49YDsirEXNR0YX0eUc1HnuyepnzmaHJURuI+dgz0vtoE5cIk4rJun8VTYkOCer2W47zvRHioZQ/e5A35wTUX/ZeSXZ9H8VCl9qb2vMuT+7vpXzVFOM2jPX0oACQoZODA3K8WwprL9Fk5pPVTZWMsejdC4XiAxeG7uQAFY91ZuC92iNHPOzeEn1NujeyiafRWSCoeIl5Cp1D41OKixKazYLg0abeRstt2wQNthTp9hf5sVeKwFgRU5kvayNS+XYJ9EmiLZR2X3r25lWV6cTxcOTQbyFNvKKYiN5CH89AGsgTaW0qTlKwxbrtkwPNuHJngNM/L8Ifp4pv8y4DtWtHJ13Ka+WzNbiKyXtJINti1AvQpXkxEO+2IW/iv5uIuFqVhpdAIUHArGThWeBZUzwf15KfkXUDR4Lcle930qJ1jGY3sAj3To6WfaIT9fd3ACiRbxumMHW05ILTeTO/hI3kqAoZhJAEv2xZww50eO/ZsOQaK/77DRQzK/0m23QSnUKrJrLuRUAx6fiTvAWinMfitTGGvmG+ENtfYUvS3LhK3mytl7NWIouDuJkeNKTdtbsDw4/rH0Nz5INVjJU7r+dsWj+BVaBnD0FrpR/9/KHcbMitwQknjDbK3eYfAzLw2GP10bVv4sqwqqD3MGAB4Pd5V/D67YrGql8ijrCTm4AjQUA93SJwog8K/mT9smAniEeYNjmKmsNU+s7k7WfRM91Ln1Z3V2YZlOruvUpj2L92CI5tKIvHAj7V3UqEEazpOB3MvRGOzIQmfcHpq5COSNs90VnTzUuXjXGGajNCf1P9FzL6WR8YInW+qmapL1++psR3cGRazpFFYy
 9cohOLNO
 C1ZT6c154ls9g5Hj1ZNGs9pQwEG/WP92uIPs2/sfvGWW3AUR3tkLn7+4OH5u18UHiet7UDbZeiDHNS6pgZaQ3EY7NYdqMPt1JaycqfitBq6pCMRA59opoQEIVGJ4JYzlpWmMZopCvyqHCsRWlOKn0BULrrcKz/elgyoiMEDoIJq9MCGQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current code incorrectly accesses buffer[strlen(buffer)], which
points to the null terminator ('\0') at the end of the string. This is
technically out-of-bounds access since valid string content ends at
index strlen(buffer)-1.

Fix by:
1. Declaring strlen() result variable at function scope
2. Adding bounds check (len > 0) to handle empty strings
3. Using buffer[len-1] to correctly access the last character before
   the null terminator

v2: Move variable declaration to function scope to avoid mixing
    declarations with statements (feedback from reviewer)

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
---
 tools/mm/slabinfo.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 1433eff99feb..d2e5b4e232b1 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -155,6 +155,8 @@ static void usage(void)
 
 static unsigned long read_obj(const char *name)
 {
+	size_t len;
+
 	FILE *f = fopen(name, "r");
 
 	if (!f) {
@@ -165,8 +167,10 @@ static unsigned long read_obj(const char *name)
 		if (!fgets(buffer, sizeof(buffer), f))
 			buffer[0] = 0;
 		fclose(f);
-		if (buffer[strlen(buffer)] == '\n')
-			buffer[strlen(buffer)] = 0;
+		len = strlen(buffer);
+
+		if (len > 0 && buffer[len - 1] == '\n')
+			buffer[len - 1] = 0;
 	}
 	return strlen(buffer);
 }
-- 
2.34.1


