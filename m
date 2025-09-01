Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5E5FCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 04:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82EE8E0003; Mon,  1 Sep 2025 00:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33588E0001; Mon,  1 Sep 2025 00:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70098E0003; Mon,  1 Sep 2025 00:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C65088E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 00:51:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70792C0661
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:51:29 +0000 (UTC)
X-FDA: 83839457898.25.A519876
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf24.hostedemail.com (Postfix) with ESMTP id 61809180003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:51:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UOMXXOHe;
	spf=pass (imf24.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756702287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Pfya29deBWJnXr7q5vkT6P10+mIgvx6M7RAZ02UmfkY=;
	b=J0QiYze1DRxizVABIfIu1fXYtIPQ0Q46+uj2QqOSWwmJSQtyQD3H7XxbbQjj3R219RyRYU
	tPY4dr/tEY1W/XulmgEcf7dZgv5HWXHsbjp03goJ/RP7/s4QLJ22FcpmJEc/ABanuO4588
	9SpcNWC3TUM2cKGXyQiyo3fAHwc3Dh0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UOMXXOHe;
	spf=pass (imf24.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756702287; a=rsa-sha256;
	cv=none;
	b=iG0y49pCJ6wB6PJ8jmH6JJ6Bn/FzHXlYV+6ltIjz0qM/CxbzZNuxP7kBt2yHBsK4y6EvUP
	BgoeX7m3h4GgzM/o8vRGTuKn2SRlVNtaI2LTKI9OaT505lyWXOdfhjjG5AJzx6uhj9IlDe
	XMFbeBpcoBR4OhFyMiDryfLKQdsATT8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756702288; x=1788238288;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O31L9/Ah3TfH/t5sj+uGW13Tn6JOtYT8pNeX9rYXvrc=;
  b=UOMXXOHegQX+0E/BbVCF3v7IV54E+B83S+x8zhstSIz6a4dZ2Ib4WcQA
   /Lpwp8fcj1iJWCHXT0hWl72ZOXonVEap93Z0nMzMQqbheMFT7qwbTzsv2
   dIVBc+pjepEUINNzYJdndHZd2mHFIJQEe/At1crKmTDux1LZc8GwzFMYl
   bFiyUSSPOKwnGrzXcUeztewaC9y3+kFOqRveTCSOOtP0TYQwbULp9S1fJ
   VJwz7acJHGD3DhT8G5ZfiVyvVhv2j6cMHPexkHUCU3CLfyO6GbLjdkGZc
   HOQGfh4PKQD1G4IaTff3JH+vZ258iYeleXY/LYsoCysTRN+3eFcZhqAtC
   A==;
X-CSE-ConnectionGUID: 6a0BFavcTIevi6ix6BEn7g==
X-CSE-MsgGUID: ubmFWFQtTfuJbFaAogV3WA==
X-IronPort-AV: E=McAfee;i="6800,10657,11539"; a="57917191"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="57917191"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 21:51:26 -0700
X-CSE-ConnectionGUID: aMBWSfXcTp+8UYeWcfUcFA==
X-CSE-MsgGUID: CaezSw5/QWmft3qvCwDjNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="170121117"
Received: from baandr0id001.iind.intel.com ([10.66.253.151])
  by orviesa006.jf.intel.com with ESMTP; 31 Aug 2025 21:51:25 -0700
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: [PATCH v4] tools/mm/slabinfo: fix access to null terminator in string boundary
Date: Mon,  1 Sep 2025 10:19:55 +0530
Message-Id: <20250901044955.3902815-1-kaushlendra.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 61809180003
X-Stat-Signature: d49k8z6frz71rexs3shwsh63iwk9jmpn
X-Rspam-User: 
X-HE-Tag: 1756702287-579410
X-HE-Meta: U2FsdGVkX1+WYFXqGW/i4oe7grlyd9T2H6XEceVUbtfSG0bRgo6FRecnQvpVkw0Nm9hTHYxuvGqqDYuDxnddL22aB0kT2+EEomhBv5noovzrTEuWS+5LPt1RG0rCw4MvGNFTIGEOJG9MPLjKVQW2TzopOKC07/YCl7xBcXA9Z9xD6LalipXG6pRAU1DNcWX8lS/BOzoyk38URDuRqqRM8dzUWHBpfuZ+FlzO0larXSsSNKLkdzF2wwM64INjwKViyIU0HSrP6u9BeudGMJGpcthMVpsunSwvxd108AeQEPIa41VjfzBvdvNNFPaDqNWL1i36U6QtwBJ4WY4AHgwjOK08iPcZVj3XiRW5M4nKJe3XhYxKTkgQjviW8fcbGlgUsXMfeiogS6rP9Os5vmphEI5J5mHIlKtBUDI9/dWBX1nU/tyqOa7WcuvKQ+2Ed/8tp1U7r5qyvBaET2B3VUts5SqU3DX2Vhm/e1B9tfGeASOA6heR3hNH8P7Vd29xkjLuseGO6nj/Wy/rBJD3Ue7cwI8MgGCwjZ8kwEKlIn5bO52tm2V98hnQpPy7sVrtBYioJZgYOizwgV8oFf2jYpxAI4K0eJ//8U5pNha1ma3yEHp4QqNHbKzghlou/WIUUMQyZcKZ3umBy5zN88G+f6SESAuF+5NZ6HJmsEmPd+XWCweDHoPNGkYrmApRAJcb2rY1onXH8E6qW3Axje60rPPiQdw8cuPtNb33NwsQ3nwdzHE5sASfj4kZpruTTav9AXgExLLbuwvN8U9EkGyTlf+St9trGU9SU0Ius/aaJO+IXExKD59hN0JXbNbb/E/W7UDyMdu+mUtF5sY9JsWDQ28ZOS2q2lAAjKmVw7uNR5SeFm1aLdQF45xNA7FKlpnPVAov2Ei+dQgYuFyDSWPnI1lSdJ3VM+qkmgdLosjKgeQPxl/Z8LcL875ipTwXn485lJbKR/bP1BuvBWP3CYhjnKR
 AgL2OAsx
 xeq0k4dET9rY/h2YONKXSYUTejOFeyX3FBSon4BZWdzlgRdTmpzSH71VpidiMvyqOep/uVIugdGWDJaHVwb062IRYMddCnt2Y2AdwC2xkuKId7EuL5nG/7jkKoxlKdVZclTU3ab+pfb3YW0E+9y+oC5uIl5jjIwPBGyH0hIIkKyVHwz4=
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

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
---
Changes in v2:
- Move variable declaration to function scope to avoid mixing
  declarations with statements (feedback from reviewer)

Changes in v3:
- Move changelog to comment section (feedback from reviewer)
- Remove unnecessary blank lines

Changes in v4:
- Remove changelog from comment section
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


