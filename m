Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA405C8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 08:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 052988E000A; Fri, 29 Aug 2025 04:49:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10F58E0001; Fri, 29 Aug 2025 04:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4E498E000A; Fri, 29 Aug 2025 04:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE5288E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:49:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 802DE1405F0
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:49:10 +0000 (UTC)
X-FDA: 83829170460.14.74AB367
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf21.hostedemail.com (Postfix) with ESMTP id EE5401C0002
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:49:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Cai7DSwC;
	spf=pass (imf21.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756457348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DGVuZNKow7gqHUiQ9y04pt4gI7B2F54OT2U4FO+drlo=;
	b=2cn4a/ZaG3PLCdkdVhN5aaqXYw0KmtwnTJ4dPNGRY1O68OrBZvrky33iWfF9mVf4jd8595
	WE77KwnIqwIkw3Lc8L71cTi2gUxehtDcCddY2noNPRhhJSjihbhVtZF6o1BKEYqpMoxx4T
	hIjItXH/MB5GIJcomJbApM6/++0Avlo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Cai7DSwC;
	spf=pass (imf21.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756457348; a=rsa-sha256;
	cv=none;
	b=QhHW7RSYc1WhigP2coxu6zmxUQVW7LVq+rOukD2lnpse0hb/R2apESxxVGWWaF0hxLMSfx
	4MEQpq7icEhn/e3HcYu66jZXVPCoX5n1UHQKtybiq8Q7pZJwF4v0aaX3Ah0ruTUwbkJk+F
	YKzh/gAjjrx/+nNCJq4G9PHeDM9+T5g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756457348; x=1787993348;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3ZeSzf91uyOjh61jguPp0X1bSC9p2GIQt2gbpVWnYyQ=;
  b=Cai7DSwChJZm1yhWG1DL7M/QJ+11WbLwvcCNiRee6K6/bY/wEHu3SYyT
   Re1LFlQ0uqY+Q64HdlRVjeW1/cH69+aq0earulyAX+momlmoAjYWhcEX9
   CRwlr9RrmkTd5hFUxAL4wBwXcTCGZmFDD5k6eCMOqWv2vlJoJD4/NAlDn
   oGxepcnQ5Lk7R2CT4C4EJybWzuAz+vTSsgy5rt6Gicz3bj6b9l/pKsNb5
   inPobbKIYKcHiZ8h46QEqtrAFVQSnR5y/hivjPu8VCFuKGRzj/SEqgfhM
   8hU+Aj6w2Lsav+A30O6pry6rG5fY6oX3yKpkamCgwMVL/0eQdrz9/QeE1
   A==;
X-CSE-ConnectionGUID: O9rwuRfbQsKg70RIZ0irzg==
X-CSE-MsgGUID: TZTnbQVqTG6ZVLGHzf6fng==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="58805991"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="58805991"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 01:49:06 -0700
X-CSE-ConnectionGUID: RZIjp5VgQY+PxdU9Q6gf3w==
X-CSE-MsgGUID: C6CWrXmjQye3W2SpIiLh4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170237632"
Received: from baandr0id001.iind.intel.com ([10.66.253.151])
  by fmviesa006.fm.intel.com with ESMTP; 29 Aug 2025 01:49:05 -0700
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: [PATCH] tools/mm/slabinfo.c: fix access to null terminator in string
Date: Fri, 29 Aug 2025 14:17:38 +0530
Message-Id: <20250829084738.1349383-1-kaushlendra.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EE5401C0002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bustixykmarf5niamho4d6qw3ui8s1qi
X-HE-Tag: 1756457347-160355
X-HE-Meta: U2FsdGVkX1/l6ikHtm7ohcbelfAnICuJgYRg2NLFiYsetkcLbsYznSDrYO2Y5qRgaevk/SBalLcL7mEgwxkQuOXaA91NMbNm/Ry0Um5/kgX4MgizgXeHyLKRSpqPRjpPQAKUXwzfyKlVoG1h9OUCAZaIoR3ODJXfqS3vCtpbEXJvhojoAfrH+C0BnbOHtvZiECpMh7TQLqSBrrS3sINQ6fnvXDNwbA55I3J5OzFCYjkboWPFfrcvl9cWIpdu4jWXBgGjBpgaHbvLTftZIvlgahX9ZnBkQecd3V7HzgtQLy6TWbHWxkYlyXGdI0HcMcEAgIwIupLaNBFzSPHPdm47+eUFvAAVyPB2F4D4Dca5SIUrGYl8BmzejO0pwUWTTwEqxvUsaYtSZhdfvKyxb4lx0YJg/wozURiEEq9OKsys9lyb8xXne2q33UFiAwwbtXBnaeZhqojOjhSZNod7Ra49SOXJcgCOZMgUdfiAvYVsmNGCYYVv7J38Hen1zj2tEFPs3/DgpK674xDbO71rDukoDveJGa4BXsXWVyfjK6GkaYLzFNDCfcBLvrqBq7PWTxUBdd34qSMYVBIlb7sB5fLJOxPcvw2riML24XVsUEvwcraKw9g3ETgkxHTUrrFJ5BO5x281OqhdQAqLi/7m3ylo/mNYx4haEfToY5WdcoMKjRNx3GVnouy2JANIves1xqZPn4IhllghQC2X9gRKR13Y4FDHmUe/vVafzq1HS9CJKV4U+/A+IdJ/hvYO0Gm0mBSBw11oDgNkmGYNCgcH7Uxb0jgVtuodRWZkmhFh67dLgZBsB9WuYTpqWQ5zO6av50R6bG+4V6ykqANUmEi32tlVfkgVxqWjZwG4TGfVnlC3yb/oNRA8V8v3tApPc6nQT8Cc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current code incorrectly accesses buffer[strlen(buffer)],
which points to the null terminator ('\0') at the end of the
string. This is technically out-of-bounds access since valid
string content ends at index strlen(buffer)-1.

Fix by:
1. Storing strlen() result to avoid redundant calls
2. Adding bounds check (len > 0) to handle empty strings
3. Using buffer[len-1] to correctly access the last character
before the null terminator

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
---
 tools/mm/slabinfo.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 1433eff99feb..ac0cc6c1c87e 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -165,8 +165,10 @@ static unsigned long read_obj(const char *name)
 		if (!fgets(buffer, sizeof(buffer), f))
 			buffer[0] = 0;
 		fclose(f);
-		if (buffer[strlen(buffer)] == '\n')
-			buffer[strlen(buffer)] = 0;
+		size_t len = strlen(buffer);
+
+		if (len > 0 && buffer[len - 1] == '\n')
+			buffer[len - 1] = 0;
 	}
 	return strlen(buffer);
 }
-- 
2.34.1


