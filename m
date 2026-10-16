Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FC3ACC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 16:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A4C6B0088; Fri, 16 Oct 2026 12:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4129D6B008A; Fri, 16 Oct 2026 12:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4DE6B0095; Fri, 16 Oct 2026 12:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D65F6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:24:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F27CAA7EF0
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:24:18 +0000 (UTC)
X-FDA: 85329011796.01.FF50CBF
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf07.hostedemail.com (Postfix) with ESMTP id 83DF04000C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:24:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="WE PhCVq";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792167856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PctlGfnjnOkrY4m3yhTfahJhe981R8/UVToXJo783RI=;
	b=x/u9mX/qNwfMPzH5Xj1nivG7HTEvFR7v72RyvHdZJKwIy5uXBQpfdv54aWUoZt+uj2poqD
	6wh9nfdWFOEQYnb7eHKOCSbmqyXqm5hhumK0Yzi7TKIH0WTXejsr8Aom8CwRhqWD2YsU9E
	KKVjNxgBgIxdf5U0YtSI64miRa9rKH4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="WE PhCVq";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf07.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792167856;
	b=ojRF6lLDM4aIrmpmMzhva/9da9mtm2wjLj8ROY0PspPpsGIdmwW/YedH91LSAO9jBmHJbA
	8FC2b3ySs+Z6xvZTiKaTV+cIILzQt1SNpBqDjJ/8adiAdt9jZF+3QFqEDvJdb4ghL65p5S
	xj/0gQWx7CyzD4OE357CNm/TsQlMa+E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=PctlGfnjnOkrY4m3yhTfahJhe981R8/UVToXJo783RI=; b=WE
	PhCVq7Oo6d4nfXjLLjKaPYSJVQdKxUhUXREhIyrepDpOhSoCpKcRUMcO9htwCBev4HSTS0iXr7fEV
	XebkoZTs05aUxw8oNrhpb5pZZMk0i2p+hfxZKnarDXKrqsnWCU+n79giGrLDB/Rdu3AALOSy3ayrL
	Tl6HIyjrOVE1imjffl0ONmiGIU0eSZimzZYzKNuSVEo2FsDtpo04GN3diAlzssoyCDJBfCMPhwnVs
	1lGKt5mZXoyJlmA7PRklJ5cpHwa0up0uipiXY/cE9dnVRFp5/G7wBIqZlkhO5Li+7BQShNnmqrwQf
	heujZ5DjTacX2C74Jeh0WUQJMq6RHWOQ==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xHki5-00000008odn-34kZ;
	Fri, 16 Oct 2026 16:23:09 +0000
Date: Fri, 16 Oct 2026 12:23:04 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 fvdl@google.com, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, Baoquan He <baoquan.he@linux.dev>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain
 <dev.jain@arm.com>, stable@vger.kernel.org
Subject: [PATCH] mm/page_alloc: count guard pages as free again when their
 buddy merges
Message-ID: <20261016122304.5b1eba8e@fangorn>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 83DF04000C
X-Stat-Signature: k565p4ugfxkaonuq34t5n5kquhzda5wc
X-Rspam-User: 
X-HE-Tag: 1792167856-629357
X-HE-Meta: U2FsdGVkX182IkP+EhzVXGhm8G0jKCWhQGVsloKQGWDhJZFIsmUkufqqdT5K00NyHIJU51PodiLkq8SdxKuvcw0JCb4mv6TliNaeul+2ZIHmqUNzpef3d7dqgX3sJXlxgH7NoRFnP+r+FtPOLTgq/R19KFyD4MfBbUkV7SpSQuAchTwNbJ554LfGytpnnv+9rTiTUuwCpyMAxhK3O2GgpWYYdaeWGEVemCafJRa2eleQF+ZTSml4nozGAar/ErThJsjLkpnkO0H8AZhPomW9xmo/hAOT6y53gCKxuPcRRpw9AFbyP+WZ46rGocs3O5VqOYO5hBalZfb+K/XJtzr4F8uc5eOnPQ3TjnmYMGUhajApFoCjFrAEIA/jADEyWUyq99iJQYwihMhRoSOo92p3QLzty9RRhXX1Fp65JK1aTeJz92DpHAXE9xIp2e3yjFJbQeI2Ysn2bEciZR4R9cnW4MWeaDqOF0NLoGNmVgC1mSX9rXt4u1cBcHt53DkJ/dNwGJZ+D2ZlYqaOuI+chNFmulE42yioACTcjb+V8NdSoB7p7iLSC5Q4TXVgkPvvxP+Rnh6QM5JR0zBFfQRsihrdKfAmkQ7N0Ut60uTdELV1KaCP50TrJHmp0Xtf3QNxZi6hQuRN94+Smjsp2WJHdKDymH2FHrZz8GiSPY8Tan9EGugZouizWeqTBvwpK8EEipv6YmcTIZYrNEf149I77abZVvvRJWWXJRksw5Lgk0dhHJcl47O8zoJkPR1Ww/wjwha8sbupyrgp7l+B6AEPUWOqjhj2CnZq2/pWD8TJ27qUhq5I7uf/FDdPPi4NKVVMduCePW3n5YHe/VBg22zkdapXxvSOnNdSahv6wFZoKWZkvUJpna2bAPcJww3hwiW4qVkQQKb33XN3FYO7wcoktvWTk+ILh7hcB9zyyAaZG9ghtw/XANkiqPTeqSl/2V87cHOSdBi9nmSqachAydPL+0d
 JEfovdYy
 gEhyGkGmVrxCk4zNoE40z7kW2pGRjLAoA+hxv90guSBWvJ5bdqim/a1TnZvoWFDw/DVKY6wNCSfxHtQet6BJpav4bvW2TGEh9XFkde3ft3ja+kxfBWfaJfwQpkeV5gAdb8uvVXUoH0m6srga3uc4B9LWaFqVzukUhGPkLl6YdDyBazs5BPeBagwD+gMC90jtAhV9A0DIPgjEUcMkPZUWkvPT6xm7/N7TCQkGQ5Xo15P86HJF4crKlxh3/ja3pSzxMV7t75VdSItMr8DVfhHvc1LHVpXoNM9q4zxL++d3OwFHkug35gZKgef2ZjOFi2lVmx1LW1NGRuf9v5LmjZz9brUn2RYBFBSg/8WEsbHDsJnjACb35nNfC/ghPTvZrnclEKILiTBtOXZf2Anrd2EH6Ma0zg8bc/7diT2+nVwAenetwXDG5Gr1UVX3O5T0gSnPX5W3wH1n8r9TOFpavMElIYUV91P6TyF/S579MvEGjnFOHdVY+Da/ean2Cluwys8LbgxDF2HEh2WzvOudnLw4Q1Pr+UWRjXqSIdF+4md7/L/ONhHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With debug_guardpage_minorder set, expand() turns the unused halves of a
split into guard pages, which page_del_and_expand() leaves out of the free
counts. Freeing the allocated half credits only that half, and
__free_one_page() then merges the guard buddy with clear_page_guard(),
which no longer touches the counters.

The merged block goes on a free list with the guard pages never counted,
so NR_FREE_PAGES falls behind the free lists by every guard that merges.
Before commit e0932b6c1f94 ("mm: page_alloc: consolidate free page
accounting"), __set_page_guard() and __clear_page_guard() adjusted the
counts themselves; that commit dropped both adjustments but kept the
subtraction implicit in expand().

Count the guard pages under the merged block's migratetype when the
buddy is cleared. account_freepages() skips an isolated block as it does
for every other free page, and moving the block off the isolated list
counts it then.

Booting a 16GB VM with debug_pagealloc=on debug_guardpage_minorder=1,
check the difference in free pages reported between /proc/vmstat
and /proc/buddyinfo.

At three points (idle, after a read and file-creation load, after
a second load), check the difference between nr_free_pages and the
buddyinfo numbers in the normal zone, as a number of pages:

                idle   after load   after second load
    unpatched   -130        79205               99121
    patched      -16           45                   0

The small remaining difference seems to be due to the numbers
not being read at exactly the same time, and is also seen
without guard pages.

Fixes: e0932b6c1f94 ("mm: page_alloc: consolidate free page accounting")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/page_alloc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c483..4658af97be010 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -988,10 +988,12 @@ static inline void __free_one_page(struct page *page,
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
 		 */
-		if (page_is_guard(buddy))
+		if (page_is_guard(buddy)) {
 			clear_page_guard(zone, buddy, order);
-		else
+			account_freepages(zone, 1 << order, migratetype);
+		} else {
 			__del_page_from_free_list(buddy, zone, order, buddy_mt);
+		}

 		if (unlikely(buddy_mt != migratetype)) {
 			/*


