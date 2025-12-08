Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67EF9D3B7DD
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 09:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8BB26B0005; Mon,  8 Dec 2025 04:12:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3BF66B0007; Mon,  8 Dec 2025 04:12:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51D76B0008; Mon,  8 Dec 2025 04:12:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 943666B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:12:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D0255C055
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:12:51 +0000 (UTC)
X-FDA: 84195738942.14.13979B4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8EBC510000D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:12:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Mx5UAvzq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765185169; a=rsa-sha256;
	cv=none;
	b=Eiw0a4chB47GHqahEdwIP485hI393EKFc86N2DsYjjNbMs0KIoXW10mCwTVuQJ1s7UkCv3
	YhrkDwRwlDMSHcjxlidJQf6G4GrngONE/hCGurf76Kygz+9lFJxiMTZSEgwpKecouHwZLp
	G7dLq6+fJ4mweaDCh5gGcPZ3+1GxgoU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Mx5UAvzq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765185169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dNV09ujwV90UIPL0Dt0iMnzXsCn/ow1KknLix/jixxQ=;
	b=u2+PT4DN395yg2D6R0ZKuKQhifwyk8i0CEIR7KrlKk006rV1jq13LzRB2CkkqMJwzobbYH
	mP5JSIil43L8ZSK9/CvyIEDm+VZRATOb5vfvxi1ZQD0aE5AlfDiUQ4AEqAIK/6WytME+D3
	u3+bpAz2qpyv9TU3wn9NkOzFVc3w4E8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765185169; x=1796721169;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XCFUPIGNuKR4fx2rE/+j1YwzFyXvjLuNtBVuxrtgrjQ=;
  b=Mx5UAvzqMOx44x39f1Hp/YJXZuuJIoeZ/dwyX8bOS3Kso9c+bABHzy2d
   DoVjbwKpjxN869XHsRRThqpJfFlOe3bgON2yUdJo+UpdicTgn/iLCELwG
   lnoYiqG1/h4bjarsoQiUoMqCEqSGKHz9+7+XrgQ9Jr2dt/1Qtap6BzZNs
   vmEZhniaexbQQ/WjyuJm0OTJMaftrqSbT0S0C7E0TCRn0IK5ZvnLCK/F4
   6q4WPVeukGksqyh7DszAu+6KHqG6IHT7RTq0W6TgaiQX3WNMwuE+GmDCz
   S5AxW5sq+w5FjtXQd1rUezqNs1Cof2z3bDB/nhrNxv/Gxt3Uv0IV8yZvP
   Q==;
X-CSE-ConnectionGUID: RqljRA24SB2DQOOvrEYoUA==
X-CSE-MsgGUID: 2vtleZb6TJ+tMQmUtmxoMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67159462"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="67159462"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:12:46 -0800
X-CSE-ConnectionGUID: 4YhYLOEeQHy6B4HMp9FbOw==
X-CSE-MsgGUID: Ayc5aL68TGS6NaA64WqTYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="195164358"
Received: from baandr0id001.iind.intel.com ([10.66.253.151])
  by orviesa010.jf.intel.com with ESMTP; 08 Dec 2025 01:12:46 -0800
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: [PATCH] tools/mm/slabinfo: recognize --partial/-p option
Date: Mon,  8 Dec 2025 14:40:18 +0530
Message-Id: <20251208091018.2701315-1-kaushlendra.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8EBC510000D
X-Stat-Signature: 1ctsjxetc6i1r6cbds7ahxgkuqitz6cr
X-Rspam-User: 
X-HE-Tag: 1765185168-589786
X-HE-Meta: U2FsdGVkX19rHoLy2RUrU2qg9QMG0zGmaLLoRPze1EZsCtOJapik9dJxX/0L6EMZSuBjdpw5N7reRmFagtKVOnyYQdEhG323UcbPJmqS2ga04dyD8zUP6HORJ+LOJ6qm2nCYuXg+EgiSDhnpOAvmrMCWqpoCPZEm1KiSRr2t/aOoFiH9nYchFL2SG+neA/rSGwFD2FRg+dxEQGU7H+YDxnTl6yhR9xoKdzb0b86E0KzHhyxGHX+e0dBYzdL+nI8JJMFbXrJWevOsgTKiU8PLPptlOaR/umo1gHePDpqOWcPKtyqlis4tgkHP4E8bLYgMX0UdU8NRqDolgx0FbIDbnD2o9xew9wRQYpF2z4VMFfUIu8QDHolL7V/rMZsi0y7ETbBUEtWaNpL51jgXUWkSI+l2ZzjDQjvPGVUySHaVGl0+FzMrKdH+Pb1WQJmBV6nMBQWID+CG6FRXCUBIrxO7kmiHxGGoijld4k26YWGFVF2HopblZ4J5hvStRJfiG1n/hhRFWkZkPYVOSYgXZcLzFjJ2JeLJCezMJh74fdEfehNmiPCRFVDBOGp5+8ylKqvK9KFnwAaGitLwH1e7HDyPVKwEGao8JqpKKJXPp45EeAZsptQz3KVpCewS9WGDQnuXnVKArE6Gjz3LdL6ul6ZW1KRpIeduwUuGbq8LgcB5/boiL6hJGuMmYCpOS1Lm7XFoJ4ELWowmuQ+Pa9fDworl5xZO5jEMoVTbEgKkJpfb3OAF+wyvastWk7NU14BERyhXurhe8OH3qgZh4mXdbfmlHyEpmsobETyG8G/Cw4tc23Hs8Z+753SkZebuW17Ha0/sinnSNtzH2/66ldU07PymmlVervXchciRtqx1NVqybOX0qETcIBIZWub+3Xqdp63k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The long option "partial" maps to 'p' but the short options string
and switch handled 'P', causing -p/--partial to be rejected as invalid.
Use lowercase 'p' consistently in the getopt short string and the switch
to enable sorting by partial slabs.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
---
 tools/mm/slabinfo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 7c51d283504d..7f239da26ed2 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -125,7 +125,7 @@ static void usage(void)
 		"-n|--numa              Show NUMA information\n"
 		"-N|--lines=K           Show the first K slabs\n"
 		"-o|--ops               Show kmem_cache_ops\n"
-		"-P|--partial           Sort by number of partial slabs\n"
+		"-p|--partial           Sort by number of partial slabs\n"
 		"-r|--report            Detailed report on single slabs\n"
 		"-s|--shrink            Shrink slabs\n"
 		"-S|--Size              Sort by size\n"
@@ -1427,7 +1427,7 @@ int main(int argc, char *argv[])
 
 	page_size = getpagesize();
 
-	while ((c = getopt_long(argc, argv, "aABd::DefhilLnN:oPrsStTUvXz1",
+	while ((c = getopt_long(argc, argv, "aABd::DefhilLnN:oprsStTUvXz1",
 						opts, NULL)) != -1)
 		switch (c) {
 		case 'a':
@@ -1481,7 +1481,7 @@ int main(int argc, char *argv[])
 		case 'r':
 			show_report = 1;
 			break;
-		case 'P':
+		case 'p':
 			sort_partial = 1;
 			break;
 		case 's':
-- 
2.34.1


