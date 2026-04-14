Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51524ED7B8B
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88776B0096; Tue, 14 Apr 2026 05:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11AE6B0099; Tue, 14 Apr 2026 05:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00D26B009B; Tue, 14 Apr 2026 05:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4706B0096
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:16:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 554B01A04E9
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:16:27 +0000 (UTC)
X-FDA: 84656605614.01.0192A33
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf03.hostedemail.com (Postfix) with ESMTP id 88D5E2000A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:16:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=buF2bIC9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776158185; a=rsa-sha256;
	cv=none;
	b=WjxFzKxQyjP1s7x6cRKF/TYFW13iAodTftKSbswZlJdC80C0kJrdRNgAa59KnsiRfwTk4W
	a8YJ4DNBFTsPqbLlldRaN7HJBkMnL3uC/Bza1TmrQrb0jll6MkLSQg3Tlgs1FM2Jy73nl6
	tHyZW7lYhRXvfAnxtAPZywMixyCLnyY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=buF2bIC9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776158185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cl11sG7u/+NHktUdM96cUoh+7Wg6iuNjhJ6suVzR84k=;
	b=1451UOUAuZ0HGXp17PwK+YJPLdyWFwBEpDMud+CxvR+74rANT8lOkJ7bhPTVdxUwfWlQ+f
	w9vdSUZtZbhz+PJq0FSJSuzVb+XslJ9xxVp/jcqQhgBYhciZJgZXtn2q5WZHc2Ctx9PMF+
	whpvrCbvRSlCDY8Osu3pFA6bIrol2x8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776158184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cl11sG7u/+NHktUdM96cUoh+7Wg6iuNjhJ6suVzR84k=;
	b=buF2bIC9KmRd4kn31/Rusxq2pS4W/UeA2oA4o3ZAcUXos0LYlUrzpsYxwtDnmudQT50ba5
	59iTe9p7v/FvolvAKJV66cbFhFktzN3bnXnbLv+bl1tgWVVyyd/HUkkn20vie8g7RIKo04
	xFd4cDpi6wgUFlos4LqRyj+2SluPsLU=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/4] mm/vmstat: remove unused __node_stat_* wrappers
Date: Tue, 14 Apr 2026 17:15:20 +0800
Message-ID: <20260414091527.2970844-4-ye.liu@linux.dev>
In-Reply-To: <20260414091527.2970844-1-ye.liu@linux.dev>
References: <20260414091527.2970844-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 88D5E2000A
X-Stat-Signature: pyu7co33oqt1mdfa6cy1hpzkdfqtqqhq
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776158185-395388
X-HE-Meta: U2FsdGVkX1/tN0m32pkB+DM6yHYm0aVahSHS7KX/BKNUjxmli3GN+8gxirEPw0ZNfgld+iDmd/KU/HDlMNwHVMrXW4HFMYI2uxHKW/zqHb0AP01XXIQbY7x4k+ZMzvv1FphjiOxMBfNLxuFiWisvhx2Vu0AH88oaeaqobISzU0L82wWxKKoFe7DhYfs4vR0Ij6jbR89tqEyC4hlrXOpf6avRlYpEGQ1uekHgXE9wlR5HCbVEHwPZY0aBC6BdjKfgNu+kZpXd5qFeqXVdv1QKWq7tfZLHgFsWbiXtvSuQj2O7P8NcNsMrzyR8lPQ/RgaSAaHqcxEJbj+5hTF6R9KHYUJOCfj1Mujtx98iGb6y5r6d+PDwO34RORuBYkAXRbWW8PuDi3MVA4ldZKV2HIIN2hPqeTQwwJGQ49uyc3+06KL2mibzC77VB5hQJ5QM+CapwoJHVtERwxZGuCi/FNLtzCw0rF7GsrOnpFWF6R0c5ot2SmFfo+e67ZAo+PZxSX2xpLWW09zyKtBzjexND25cWdB39i1Sr2d95NYWbWL7M3cWsOtlFSImYYcXYp7VWqSDrGqZ1lofyUQDSEk7uLMmdZRXdHPAPmZvbMRwY7AifTumYab54K7RSscNyp72UESsgqXEzgnjHalXcFTpzFUGNudpmPEqVFM7fvchabcBDdfNWg9lM2aeGA18JEPz1lI5qI7sz22l8jCVgqpXbf9K72WaSwzMJRtHl8qDwbdQHwVrPR/ejVVBWtRI1xldcw2De25nvrn2Lcl5Y4G3PR+5UYgf39C5A+3up2XYfYzIiwL6XTXIya7A4Vv1Fe1WV+577vSCa/9ATml6iCm5uAK6f1Sao5jPolKdY/xMAefsSWHs05TXCfT8YLHtISelkIj5vF2tg+ZqPRU5wDtYhO/X0J2cvP/6C6233VlyuNxxY++zx2N/F1u9UEhiCxX8PvKYCt4m1LFgmmGEtGb5aeB
 nFWwaG0d
 O8Kif3qEp9u7XHg5nRr/XQfjnOf7aOBxKjeZYBa9o8lEkJB4OF8zGSXsjNxrwgHzU+SQUsSAZCtR6BFhZedG4Jdlyu0fnLWnGsqLSsB/Q1JXTgpOorCXl9BqizcIZIhgJj2TZ91neZOJziLz8s6eSLZGLY8T2GQ6MZ/lXGxkvx98Y/DXizEGSI3xEJyx4L2HlB4Y3KTO67KJqmmYS30bXd2MiC6gCPIxhd3ysk7EJsIiO6HlXR42HUmCRB04+7tWZKihSEHgAEf0SMVSxM3es7vLi7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the single call to __node_stat_mod_folio()
with node_stat_mod_folio(), and remove the dead inline __node_stat_*
wrapper definitions from include/linux/vmstat.h.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 include/linux/vmstat.h | 18 ------------------
 mm/page-writeback.c    |  2 +-
 2 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3c9c266cf782..54da7d820f78 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -440,24 +440,6 @@ static inline void zone_stat_sub_folio(struct folio *folio,
 	mod_zone_page_state(folio_zone(folio), item, -folio_nr_pages(folio));
 }
 
-static inline void __node_stat_mod_folio(struct folio *folio,
-		enum node_stat_item item, long nr)
-{
-	__mod_node_page_state(folio_pgdat(folio), item, nr);
-}
-
-static inline void __node_stat_add_folio(struct folio *folio,
-		enum node_stat_item item)
-{
-	__mod_node_page_state(folio_pgdat(folio), item, folio_nr_pages(folio));
-}
-
-static inline void __node_stat_sub_folio(struct folio *folio,
-		enum node_stat_item item)
-{
-	__mod_node_page_state(folio_pgdat(folio), item, -folio_nr_pages(folio));
-}
-
 static inline void node_stat_mod_folio(struct folio *folio,
 		enum node_stat_item item, long nr)
 {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 6f9b7b081ab7..ed3301753e89 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2627,7 +2627,7 @@ static void folio_account_dirtied(struct folio *folio,
 
 		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
 		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
-		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
+		node_stat_mod_folio(folio, NR_DIRTIED, nr);
 		wb_stat_mod(wb, WB_RECLAIMABLE, nr);
 		wb_stat_mod(wb, WB_DIRTIED, nr);
 		task_io_account_write(nr * PAGE_SIZE);
-- 
2.43.0


