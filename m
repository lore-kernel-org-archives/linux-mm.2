Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFACCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 09:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B35290011F; Thu, 14 Aug 2025 05:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86533900088; Thu, 14 Aug 2025 05:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A14E90011F; Thu, 14 Aug 2025 05:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 653A0900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:26:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EFB1859A80
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:26:36 +0000 (UTC)
X-FDA: 83774832792.07.0EFAE04
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1B17980009
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:26:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wBoreqTo;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755163595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=emoZ3W5xNYAUC7dXv43Gaqg/G8nzxOmyJkag+iQ4tUs=;
	b=RNtlgnG8d/6viQ1WJPB/HvWAGLiU52efeaidVkbxYtq9r6mQTHAxM1ZBK977enZi6TIt5w
	NNNtAPIXWGKx4P+2vndpOgaL38nYWpcfrtE5xKbl7YFrDaGWIhJZxQ8NhaNwfMwDFLELMf
	wfW/ibz8GOrXtCxObqTygtX35CVBbhU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wBoreqTo;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755163595; a=rsa-sha256;
	cv=none;
	b=pvFymLIuHC/aQreckoO/21LrZQegwX0Orh52H93iEMzdFkTMriBCrlSVEHArnt1WuHlY/F
	0Q2uISEeSEEabhWMX92dPTTQuhKX1jcsXYy7+iE45KKw45My7UkBk/ppHTPjd4/5D36kPr
	y/282NjQRCAAqXS5ej0wQGfmyFZ2DPE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755163592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=emoZ3W5xNYAUC7dXv43Gaqg/G8nzxOmyJkag+iQ4tUs=;
	b=wBoreqTocFVCkZD7H3eAFcewnm7j4CNzyw59FQkyLESMCXnuBd7EFhzr7sD8+iDzHdPPF4
	cc9nmPH3bPDDWpx3gjOA/rAbCe2aqzzED62rdLaFRVTpmokSw9hqxgpqByOXMPB/uQR5D6
	5bXnhujnE14Nu55BQZgDgZPxqBorMKo=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Ye Liu <liuye@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/show_mem: Print totalreserve_pages in show_mem output
Date: Thu, 14 Aug 2025 17:26:21 +0800
Message-ID: <20250814092622.24535-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tk4npomj9d3fjm59478zuybo6d8ezzas
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B17980009
X-Rspamd-Server: rspam05
X-HE-Tag: 1755163594-625027
X-HE-Meta: U2FsdGVkX1/REGZYiwxy63sXWXJsrJizZAUInBcoCwxfC7Y0oT++rQSz7XVo8xOJ9Fvw7AiUwQqhnvZ3dpELhmX+JQDaQxqoQ/JM+vEi8TxHm0iOmTTrJTzNz/k0maExGWX4SHQJeoDd9slAFMMpK/Vm5DS80A70lpJCA/Od62WvQ0hH75/VJrG62ONyNVtrBIzIqALJUapLLO5WJCMcezmzgcfMOma299iMHlqivB+Vbx6s3DkrP3CgVduu6YmGlRVTXE6C9RmZM2Bim+j2xJ4mKKQ0I+PYNU8uPX080WMjUCH6RzURpVdw/DUUsSqe6iddj92UeeucgBKusMhL62Zx1cPlWb7ADWc9Ets251GEdDMuNvnI09hIaq2ParvGTqiDXjfnkLhNa/hUqh7zOM77tzY5oA/c3Kohy6by4/oGN7t0LQHX+oodlDmFqqTOLvGGKgXGASY2Vj7Q+TWCUiOefEwcrAV30QXLsBEBvv/Alot3j7Vppw4eyb3fJlE3WH9HnqY/ZL3koevtz9mpzRCouWikufBxnW8SS1teMSHtX7apQUG+aM326n+bXgJnAzr7//ebOFWd6yuVn0pJNzb7LKJvKMzNtjCAhhzSBZjF1qNGOeXEgVzpaVYx+nsV8tGOLif7fZdrQMtXB1DHrhQmNrPrbk+Ib95gb/4mD6jAW+e5v8BNNYiCwXaHsYSIhjhMjBrH9qRaANgNnPddJiA4c7YwpsnhATiulMOHtDDJ1ZSdPCH2/smMqJycXeI5pb6R5iGc+DVGSSXBJ//aSW9NUmLpRMvLOCPOutKJFw8nadKsx7ReQDTegPObEETU84x7WDBQJkByfuLhjGYZe53q/aUghRBGUq9G2fKhRsVrlh7ylTomKJUmk7ENM7wDBx6qd26xtE80Mtbo6KZ+8F8FDnTkwjAjKPN3pjlRfkkAVGeIzldD+0LcVsV0VPoaslDZHL1NBHHVNmB7tAI
 PdrKaL39
 xmA3h29/jNtrf6WL3IwTUcDNP3+KyK0UJy8bHDINcIv8ny2PVJLLUo4vMndy/ORmb6YSDyyBmnqqHqRdOqF/LjsOB1kSrEUCYEknAh8FZMDk4VD+H+ZRvTtjnb8KeJy0j8YYdXuuJoAkB+0TRUr21V018NW+rEnabK99wM9B5rvD3NT+S8PxePd5jREfsBVWTQjPX7/2nkL7brDrhlEkplfhjwMFXeUhpsNiIDtT0JtlF7KphKVya62epAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Add totalreserve_pages to the main show_mem output line for easier
debugging and memory analysis. This helps developers and
administrators quickly see how many pages are reserved by the kernel
and not available for user allocations.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/show_mem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index 41999e94a56d..c56d5599de45 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -201,7 +201,8 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 		" mapped:%lu shmem:%lu pagetables:%lu\n"
 		" sec_pagetables:%lu bounce:%lu\n"
 		" kernel_misc_reclaimable:%lu\n"
-		" free:%lu free_pcp:%lu free_cma:%lu\n",
+		" free:%lu free_pcp:%lu free_cma:%lu\n"
+		" totalreserve_pages:%lu\n",
 		global_node_page_state(NR_ACTIVE_ANON),
 		global_node_page_state(NR_INACTIVE_ANON),
 		global_node_page_state(NR_ISOLATED_ANON),
@@ -221,7 +222,8 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 		global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE),
 		global_zone_page_state(NR_FREE_PAGES),
 		free_pcp,
-		global_zone_page_state(NR_FREE_CMA_PAGES));
+		global_zone_page_state(NR_FREE_CMA_PAGES),
+		totalreserve_pages);
 
 	for_each_online_pgdat(pgdat) {
 		if (show_mem_node_skip(filter, pgdat->node_id, nodemask))
-- 
2.43.0


