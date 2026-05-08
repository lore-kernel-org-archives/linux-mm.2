Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E7A7CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 09:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8696B0133; Fri,  8 May 2026 05:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888DF6B0134; Fri,  8 May 2026 05:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C61A6B0135; Fri,  8 May 2026 05:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5306B0133
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:49:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1149B1207A8
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:49:17 +0000 (UTC)
X-FDA: 84743779554.04.FD26B4D
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3BA9380003
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:49:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778233755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=+jTsSCV5y6DkCst7wTY37QGF77rXtpOpDjfTSX9+nqg=;
	b=cld+MHRnR3HdYy+VgRUk5f2Gcfj6VQv9DlQETslkt6oaIbFx43Rs+gDopxUj6z2ACPSyng
	puteG1jpd4hOW1+zMjT6xFZANkl5zgOj1sHBKY3WSixKTQXKS1grVDKAd3ML5PrcnoH3Dk
	J3dmN4uD+zqQb3I7FkXdqW3xRmbKGl4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778233755; a=rsa-sha256;
	cv=none;
	b=ZTmpC8A03rkzqCoK63WuN/69cQWHykyUdfFdnBsFMsAi7pPA4qmvsxg6Kaj/TzdOYyYDRb
	goDpLGcH+6VS8kly7/eYD3lM0IgU0hAIQbBrDAhGjExjZb0QNFEeUMDr0WfMKZeAH48bvR
	/nba8MUHoJ900KFcHAQZ57HEJxQj1nk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v2] mm/balloon: expose per-node balloon pages in node meminfo
Date: Fri,  8 May 2026 17:47:36 +0800
Message-Id: <20260508094736.142467-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3BA9380003
X-Stat-Signature: 14hz55xgc6mmjfs9ujd95jaqmmsz7sat
X-Rspam-User: 
X-HE-Tag: 1778233754-45148
X-HE-Meta: U2FsdGVkX19BoJvh0Qe0FI7iLayMwRk5EA+IoDsx69HlZ9f3fsocMeNC4jVh2EbDBXicg2P0OKghLH/byX8rxstvpVypA/3YEahKkiG3D4b9GFmDFa5uttl32IM2EQw5jAqF2qHX59o1aLDsE4RQIUF6x0jFdl+/UEw8b2isNk789my17RfARseBpgopucBTEZRitru12blNdzej8op+oaaveK7Sh96O2LTOY/M3e9/fOJrvGYSs3el5JaZO5e0BojvTuPOcSQtOB+Jy1X9fxcRD6hFkn159h5Nsc2DQ5Wz2XtNH786TmJD+ks5d3tDPtrzre/+w9gSon9DZTy0x7GghFT7X9V7MsPcEJFFnOl6KOYYPfd8tURv2yC5vn7U4m40ntSaGhKr6m2fd5DfJoXQSQfPEk5BpqkC3jBXKonTMuO4uxNJXTbeL0j8fiF8kCMMsWZdLqlYnjXUwTDZWOsZEr3IXSURASfjQsQrubbiA17SCjBrloSYHkfcu621nssIrYgDUufOz/E3E0OALUyIP82gow97eZvvpGSN8fHqgQtwudSuQEvyydZiwa3pn6D98r4YbeL4G5a9iJL2NtcWMvMnw0t4/EOvefq538I1kXPdQ6DY0icfnFOvcRRuFUZErWqI3RSbJsuEd7a+g12lXpXIBz5MVnFB03GvDBplEnjNewfsff0VWtzCle3ZmOOELzJqfSbvs99UTQEGtP+mnmjWjWlHHEuHM//55gHjcpG/TWYoFLa+IKgJLnqhQCJwRefEPx1X5xvdUMDwnWeimbO/8/45QBRq16XUyICcu3A1fsW9vhMHObGE67pPG5sk5lJVQiUWTnC+d8bFqwevAsG/jBVXWqkCO4PvC6MkPtz07In0oZE6INkda9K5/1jX1Y3LRixdMlmH2Y11HpoW5e2DZ7/hMac/xB5IDHknT28HLws7RRocz0aixm9CDwcIuRFeGg3cfsTuqwH7
 vRe3jfDc
 /6D4MrEo5d/xPE71BFFTPuSi2W73TMJtp2odkl/urnPUcAgDdjtohS08/k9bDkTR/svfbhNEhcHuAGgXzHixKxnksDnWDf7kAlaZR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 835de37603ef ("meminfo: add a per node counter for balloon
drivers") added NR_BALLOON_PAGES and exposed it in /proc/meminfo.
However, the per-node view at /sys/devices/system/node/nodeX/meminfo
was not updated, even though the counter is already tracked per-node.

Add it to node_read_meminfo() so users can see balloon usage per
NUMA node without having to parse the raw vmstat file.

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
v2: Move Balloon field after Unaccepted to match /proc/meminfo ordering
    (suggested by David Hildenbrand)
---
 drivers/base/node.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index d7647d077b66..85c20aa3c7f2 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -523,6 +523,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 #ifdef CONFIG_UNACCEPTED_MEMORY
 			     "Node %d Unaccepted:     %8lu kB\n"
 #endif
+			     "Node %d Balloon:        %8lu kB\n"
 			     ,
 			     nid, K(node_page_state(pgdat, NR_FILE_DIRTY)),
 			     nid, K(node_page_state(pgdat, NR_WRITEBACK)),
@@ -556,6 +557,8 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     ,
 			     nid, K(sum_zone_node_page_state(nid, NR_UNACCEPTED))
 #endif
+			     ,
+			     nid, K(node_page_state(pgdat, NR_BALLOON_PAGES))
 			    );
 	len += hugetlb_report_node_meminfo(buf, len, nid);
 	return len;
-- 
2.25.1


