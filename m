Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D03CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 04:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A59926B0011; Mon,  1 Sep 2025 00:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0A2C6B0012; Mon,  1 Sep 2025 00:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91FCA6B0022; Mon,  1 Sep 2025 00:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 807986B0011
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 00:46:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15AC1119ACE
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:46:57 +0000 (UTC)
X-FDA: 83839446474.07.54694DF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf13.hostedemail.com (Postfix) with ESMTP id A338720006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:46:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="fRqU/m8s";
	spf=pass (imf13.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756702015; a=rsa-sha256;
	cv=none;
	b=NbozByS6LgC2QfsL7Shc7ATg7dC5fLwznnrDbNNHvy7ByrtcmpCu0pls83KEV/QVFqhEEm
	OJ+xDcfOpRydjC8cnpU4P5VB8augrkHL4A3r3rSgzhbXgJwc+sgeKLqPtqAcQyARK0a6+3
	dVAhsLtsVRN5cvQUhH+Ke4RQxK79+7k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="fRqU/m8s";
	spf=pass (imf13.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756702015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LP73ps18utAybntp84+1PLZLYEttDLqr/sRpfeIOKFY=;
	b=2x/lOOmIIaNS+BRBMLKZq1saUAzMh7br74r0dc/tSv0UOHX9DHV7yyyVZzHHUM+Qk66KsM
	EWMs1f5KKPVi7fbVinsUj3xetc7hIaL5yyaTUganTmLytZou/mgy0xyZcqiZfZp3F8NN/Q
	XE/v3PQytvUt9hhspW7emrDfS6+cBPc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756702015; x=1788238015;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MuaNeTsrcCfnycE6xy3wQguRBq5NjNifBvDrfBSUaNg=;
  b=fRqU/m8sOXOhEpb5MeUWtDP3T5FPugWe2QZm51u/syiWWkqYTsezQz4l
   UJZOmGDFSEXx9FO0IkMpwtUKP66xPkb6Ecu5Qt4PmpvZJ7uft2Iog/T1N
   YBmqlB4Tbz3cg4U3FHj/UeAnMT8qp4HX0JuH3Mb8fOZlCi2lgg0GN4/bw
   IXAkw+dPaJylvVnkIG2EmRQSRPLMVn7SS3UolnEZVJNjluzg+mRfc7dEC
   VEE/r9ZI+aQnAlNt/ozaXZohMVcq/F/67dJj6xKme+FC4Ro91/JrGDVdp
   t6qYTwKqIx1M/lAtEVGAt1ZLSbOM780SlNfaSm5/Ai5Uqcr9emh3QrblG
   A==;
X-CSE-ConnectionGUID: uIhD5vPgRE2UtpO8yM68LQ==
X-CSE-MsgGUID: 2PFlKn9JRnKJo04bh3fP/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58817878"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58817878"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 21:46:53 -0700
X-CSE-ConnectionGUID: V1rgCnV3TKuV6TvMwv+u7w==
X-CSE-MsgGUID: EkbGzyauR4+E4TrS44CFXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="171257434"
Received: from baandr0id001.iind.intel.com ([10.66.253.151])
  by fmviesa008.fm.intel.com with ESMTP; 31 Aug 2025 21:46:51 -0700
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: [PATCH v3] tools/mm/slabinfo: fix access to null terminator in string boundary
Date: Mon,  1 Sep 2025 10:15:22 +0530
Message-Id: <20250901044522.3902700-1-kaushlendra.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A338720006
X-Stat-Signature: ohowm4j76me5syu78h67zyniz5hx6hmu
X-Rspam-User: 
X-HE-Tag: 1756702014-264045
X-HE-Meta: U2FsdGVkX1/VBddub4M7gFcV7thma4mZlUJGHZIxJm2PeUE3h8bX7qzE+EvH73JR9am+OlIJpgCPMVHft2lju+E94sp4VKJ0u8HkG0dSf6sAwuNWeb3G5MQ0XrnEZ4VWsKeBkUnb81nNvDm53CNDMGTzzg/EN/VHwYv6El/KkrSPOTkyeFX1YPjm4I8nlRRs3REic4oPNujCZv+GUqDofGs5yR7CLul5rTbg5h/lPFhedp1Uh8r1upmyP6ajcclgnyMKMdx63MIk46fGOaajLj2T/TLb6mh/PO5KXsIwroRSQdW7+xKzLrEL1G8dybcLl9dQmrW2DR6HYVBFr6IEFoHMErnsZpTlU42I9VM1S6JUTP02ceMzsdG4J1ud/awhG2pvMu3JkG7eksMREesrLqr8jCghu94lh5vdBYpr81J9nJu4PL5fjORl/2fbxBjgHk+gbhaAdmzPY7Fh+X7qRH7aOMQpk2+1B5hNwotCsYEQ2tDUC14Cw5Bkyv3OU2YM3cwVFuoVmY3N0josaEe+etcsKwyHy+fZ8sv1lIjgD+WqjoGAYv+iJ5J57UbxEPJmKtzDaKCu9Wgm3mN2JzkIAzVdwrCQK26+dLahARpMl9DsBKflpuhY0jzwvV7H7bskX0KhbIzSNPgo1jlYjifG1ZY3pndNxENtMejtJTFq5XxvvXnaMfYkyeBVxqTxevGvCA8A329cphLgDsOO5E1SPEJBJvQMwz5xuD6iMS2kw94KriOYh++a8fKUkxaZpRU0oOzLEetybWbfRjW2SJD8hWeAvQg1POpxTt2BK+qNmTvOGPY+TuZelAYC1DHqgwEACzLlrrVVw9EC0uKPNCXw+arHbn+jRjBJDtA/HYu3KllBVjtxzY2mJQ==
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
Changes in v2:
- Move variable declaration to function scope to avoid mixing
  declarations with statements (feedback from reviewer)

Changes in v3:
- Move changelog to comment section (feedback from reviewer)
- Remove unnecessary blank lines
---
 tools/mm/slabinfo.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 1433eff99feb..80cdbd3db82d 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -155,6 +155,7 @@ static void usage(void)
 
 static unsigned long read_obj(const char *name)
 {
+	size_t len;
 	FILE *f = fopen(name, "r");
 
 	if (!f) {
@@ -165,8 +166,10 @@ static unsigned long read_obj(const char *name)
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


