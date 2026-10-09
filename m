Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91060CA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E89656B009B; Fri,  9 Oct 2026 16:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39EA6B009D; Fri,  9 Oct 2026 16:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29306B009E; Fri,  9 Oct 2026 16:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A70946B009B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:30:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 308CBA8035
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:30:56 +0000 (UTC)
X-FDA: 85304231712.17.C5E17D5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id EF6EE80011
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:30:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZLNlV5rG;
	spf=pass (imf02.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791577854;
	b=q49mORPGFV50zTyecwHbek0TK0Np44HO3hNDuQrnnAhhlCYOPPkydhJNl2in57iW0Ekzm9
	9lAPny0nwTHD5us45qxnYier+zfgI9ARWseOSW+qepCicKoe7QhPnxyO045EzUexTQ47iu
	NS25jjijaoL5/Kd5Ddz0LOlKodCIpRU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZLNlV5rG;
	spf=pass (imf02.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791577854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WODW0p6GsbEKy/nakv5plADd7FbhJuhpE8HmmcgmUp8=;
	b=kxMjm8TQyutEUCkm1QQY/ChpekD3afM/SMWw0JIKeTEm6ieTYvGFfWL/kDjRPnujHn0CpN
	RMLYTE1GLtIT6+Enlm8C753wWXjLRWxFMMGmuuhfVxf7INfi9MydHgAxUtl2HeoMonGyrl
	kCXl+vo6weoDPIe4S1n+50KFNrFX//k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791577854; x=1823113854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2saYmihXk4D+WDUzsfdgdw4WIv25gjM4R9HleabuRsc=;
  b=ZLNlV5rGLPP0uLdw1GVBJDr8012WWdoryucx4Ezkzj/tJmCM/X9T75GD
   4Tch7kVz04F3sZEo3Rf3weAL/dKDA7spaEIowqINLQXg2kBGRe7apSbpe
   lrI9iTSEviFkCF54rmk0zhJ1iG1sv1TOKbMkLaYCO1RouHRvgXSjHGjwv
   l9dH51EahEKMpvCwj/OpG/QNFAd6wJgRxxVV9krXVJfw+GGNfR/QJ0SZE
   aIJQvwQYQ08VObbST95xAtn8Znlr9dEJjxyDCvHc+7pvdXY9P9JORZgMJ
   2KiPwfe+0pNEm8RakTKQubTpqrTYJECbjtG95pQnpfjBVqTRz4futQsYU
   g==;
X-CSE-ConnectionGUID: MEibHognT4SiY+L/KFNvng==
X-CSE-MsgGUID: jMDYtj7YR5SlWLe07waxAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="284606"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="284606"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 13:30:53 -0700
X-CSE-ConnectionGUID: MrsSyLoKRm2Bl/uDAFMiUg==
X-CSE-MsgGUID: VtdBHi3UQluX76iKLi18gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="2193215"
Received: from jf.intel.com ([10.165.154.102])
  by fmviesa012.fm.intel.com with ESMTP; 09 Oct 2026 13:30:52 -0700
From: Ehab Ababneh <ehab.ababneh@intel.com>
To: ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: buddy.lumpkin@oracle.com,
	akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	Ehab Ababneh <ehab.ababneh@intel.com>
Subject: [RFC PATCH v2 5/5] mm/vmscan: scale hopeless threshold for kswapd workers
Date: Fri,  9 Oct 2026 13:33:04 -0700
Message-ID: <ee792198db686d202c311e05c61cf5f45fcd8d86.1791577417.git.ehab.ababneh@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791577417.git.ehab.ababneh@intel.com>
References: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com> <cover.1791577417.git.ehab.ababneh@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kjn31tsxikwxc3iytxn7wscyy7zspzmf
X-Rspamd-Queue-Id: EF6EE80011
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791577853-907875
X-HE-Meta: U2FsdGVkX18Ev9HDkbejXInfEvGeAIfvBOsq9Jh99XjoJyj9SG4SZTRMD3wXOgjN+d4zFFtrM9D4lGE+oIjRFBuBsLc9aSOZeE+QdLNAojLrtrc9PghxUIYEcqRbv7U3R3VtrchVAvn8TBeRiDCiR/XkuFJB+ZXNN6Uept9/CAyJ6D9S5BhIPSBELINGUajMjEX8R8PR8lV1iznm5qZuGNIefd3rJrXH9jr2SNnBaa4Hs0Xyx9PXgr/v+J5EGS4WGXZa3kiTLofu2JWAIiqJv9YHEueetKKStFHJOWye6xhXP62gUg5ZcgeajLx+GtVZtBo6iHYfHYBYGgLVPGisnZRR0R/DkjyCaXzxrGmkBlLIaikxgLQpIBIgsOKOJfsne7YS0tndwej+oT9fM71G5TuaxSL8hF+0TWw49Dn/Rp7WYZQxbGK6KLQm96QRkTst4znn0azfX64Eu7iFmYDFJuVd3zny31ooffQEkV1kFE990UoJoLEYK5ZxVcrxEdh+J1+4+8GbPnLCT4/08phB4lyD3QXcEQxd4b7/9vwh3yM/UPWUmIJ166SECENEfOUFfe7va5wunzuo4psfSKprZejAVH92BjpoX6A3hJKkAmYi+/rGmZeQ5lgU92q9tScyxaJ9M/MM7JzI2Dnkr5oVY2RJL40Ud8VxYQd84stlERLOTbujBcjEcDbvwJimV0lGMDzI1rMCXkh111APAUQ0QPYP28aZOXyYESRHWR1c4ukIuQCQ2pjrRCYLOfhVUo/PNf3rstQTrZ3+65Dkive4zWInNnNLO2YDPC7Rn5lOn1Y7jvqdcNQFnNe3x4ZHASRhrfXhM4ii8MYN14l7Fnl56SibuCotkeVYK8oTwj8+OhZVG+/KolgahR1o94u2+Po8ySU1HpuTvDtgFIvTR2bsIWEBq7FnwXdw/Ym+bHHk5uYDU9dyp0PvCpR15yeOqjQMVsqtHBrVNva076COOUC
 4SxqF5EJ
 PMgzNvhEk3AbdQJ02Vb/xFkHcyOKWkZfqwtkB1Z7/Mnk0i8SZ9C4cbDmYAEfY0COYb8QTPMfKNEoMpJNOprIoPQs8hEMSMuYx4wKMwqC/1ZIs06j1onXQKQCan6RfjbyrMCkOaWDyoDmaWzYg/5W9DBLszNROWn5a99dnaov/tQuNM1mSg/PG/rf+Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The per-node failure counter advances once per worker balance pass
that makes no reclaim progress. With multiple kswapd workers, it can
reach MAX_RECLAIM_RETRIES while others are still reclaiming, marking
the node hopeless prematurely.

Scale the threshold by the active kswapd worker count so each worker
keeps the existing retry budget.

Signed-off-by: Ehab Ababneh <ehab.ababneh@intel.com>
---
 mm/vmscan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9e051aac2203..61d46a376eb9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7940,7 +7940,8 @@ void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
 
 bool kswapd_test_hopeless(pg_data_t *pgdat)
 {
-	return atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES;
+	return atomic_read(&pgdat->kswapd_failures) >=
+		MAX_RECLAIM_RETRIES * READ_ONCE(current_kswapds_per_node);
 }
 
 #ifdef CONFIG_HIBERNATION
-- 
2.43.0


