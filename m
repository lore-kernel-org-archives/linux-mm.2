Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2401606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 12:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=okvv/uDS
Received: by kanga.kvack.org (Postfix)
	id D0D806B092B; Thu, 22 Oct 2026 08:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC03B6B092C; Thu, 22 Oct 2026 08:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4956B092D; Thu, 22 Oct 2026 08:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9C86B092B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:45:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE21840843
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:45:24 +0000 (UTC)
X-FDA: 85350232968.29.7BB2F02
Received: from mta1.migadu.com (out-244.mta1.migadu.com [95.215.58.244])
	by imf02.hostedemail.com (Postfix) with ESMTP id C5B9780008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:45:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="okvv/uDS";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.244 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792673123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/e/DML6VhtXmgchh3D6VG9pyLDvWkm3EATTpFCuaGRU=;
	b=IYqYFuyQDQomG9zRHbUsjyAu1sHALhyP53jLRduA1OF64LS9py9oY+RTJWGX41VC/BdbDl
	r9UeNH0SaHmwxtzpTs0U9pj7S22RZAKZ1zWZ0mtcCDPCVHjHVxaz9ep9Om0Fojujsdmavd
	4LixIgEFBQOtP/j2PNw5V+zckEZCAIg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="okvv/uDS";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.244 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792673123;
	b=zPVf7RShUTRyOheRLyJGhabppss6niJfHx9YXGkV2VAPC841LAI7MjehEjatWe0RuGlqvw
	zrQTkgzAJRdTGWB+3J1x9L/EoguLjZzUM0sovDXm/u0qANnRI76JAVo8ZZMjM71t+yBoeR
	8x1XLu2QEZ+6q35xFO0DWGztTC9EvOI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=o6tCkHrPXDXhUkW2Vt2Sq4pwRH/wGrxJv76uyLTjs3U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792673121; v=1; x=1793277921;
 b=okvv/uDSMVdtUW3PVNE6GhlTCQI1AUXhJnra80miBUS03Z78F36usxu3yOBnVZIAQLPrbjO2
 Qe0VYmVCEhbtr64u5JnJnmUlW7c4WgeqS4DhoQ9YnZ8bT07CvMZVR1Kke/2Aa+t6+JtUDQu6bS7
 LNWKj1qqkvUEMLUutK83rETM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e24c385dd572482f;
	Thu, 22 Oct 2026 12:45:21 +0000
X-Mizu-Trace-ID: e24c385dd572482f
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] mm/page_alloc: remove unneeded forward declaration of __free_pages_ok()
Date: Thu, 22 Oct 2026 20:45:04 +0800
Message-ID: <20261022124504.75642-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C5B9780008
X-Stat-Signature: ben1bfpbhk6ru7b4uzdcoe3pfjsos6tr
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792673122-637359
X-HE-Meta: U2FsdGVkX1/oHe7l3ES5f/8YUe/raUmD50bn9lThJ0psd5T2jOWUpKEpAGPa/i79hCOkMwAjalMPWnYQ9FYsR/Itvlt81bOWVg9ySMxeQUwiH+WrdwS/DjiUIyC8lINp6g0+SJ6oeNeCEMxE5yLfy9eRd9p6QqB7R65zBZSxY5/2bispVREjXCHbmqkZRCwoRjtPxyEsS6Lxy3Swqto5Lnq9OAZzb5EiPkP8CPaCWMWxucjoZnkAbxj9FAn7pL5OBSTSxinnq5COccglYASSOBlNdy8yh5ZzUIqF2VefxCS8CUR2qB/rw1ZOtDuYguqjwM/hI+2mSj0k/DitKGXKkP2GSXe3qMOw2DMySovZp5LkhDaCrnGCwTp3gHAXu3D/HwFDh+DcSDSm2gWFyQkwv13mJdTa1jzXBSwkoMgyspPKrxYwSFUc30xe6fm/DtHTdYCdL9TUs8e+iymKHKY6qg3jtUCDthGEUxHe7rEtT0NUFoBNCsOwCRxGkra+zXlY2M2yPaAhpBeXm8NBNcfxHQZuapcc2ixR80LHRUmcoeu/caG6UtUkODEIECIqGRzb+DPGJOtxZQl8Lc1tHu78P4OTb/IXlBHN0o4GdV4DwhZhwPjFjWmd9Y2+CP0ar2qPvg0RpAFcB0EYsHCMjVt5NWT0O0BwIdHLaahjj5k1LujTbokw1Dh2pyPMkjOmUXMR/aCTBt64XqWGm6YFqj2AkFvKEmR+0QiSgpy/yFHW/QxCVF9C+PiaFn8ImxTg5WZNE6TKv+TgupfwQnzbiQkx4OIfGhJa2rxa7a5I1fZ3xe3ulc+Z57TuuR5gZAAfzL1fvqg1m0+/GosrRUk4JfDrRS+6zjnP0VlUhmRI4GQRTLjgo05i2VrqA9LGLQsHjtoeGNRRJ3g4W80QXBt+q7ByMmycRZ4DOmQ2dDyuw5vzBvt3XrJljN0HLhlpT5e9AfTCLA/yoyAD+t5hKib0BcH
 PYu9mbS/
 ifc7nvgw4wGwm1YHIt/awPGgivgilr4Nf8q2xyIoZQuWQHqVt8S0eYN+d7b/oENpHtX98P8IFkSGkh7VQBIrNbnXGmbGoj0fMUqAVFYoaBH7PtvP55Hsr+M+XCaN4fjHGWkyS+XITr0j3MoCvbiUUUWS/WCUNSxHag9phd8KbgPDd2RHkvrgBe0NXnfhSiUYsI5mlv9f/BGZ78McDtFS0y7M2iKdz5yRk9yfxmZkwAVVtlPF7a9V3SEiWWT4Lc8wBOrhrya/N8y15BOe1dedF47kusw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

All remaining callers of __free_pages_ok() appear after its definition, so
the forward declaration near the top of mm/page_alloc.c is no longer
needed.  Remove it.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 mm/page_alloc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0396c50b96f0..6db90e0aa929 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -216,8 +216,6 @@ gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 unsigned int pageblock_order __read_mostly;
 #endif
 
-static void __free_pages_ok(struct page *page, unsigned int order,
-			    fpi_t fpi_flags);
 static void reserve_highatomic_pageblock(struct page *page, int order,
 					 struct zone *zone);
 
-- 
2.56.0


