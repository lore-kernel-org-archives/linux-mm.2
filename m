Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8CFE606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cnFG75xq
Received: by kanga.kvack.org (Postfix)
	id E2DA66B07C9; Tue, 27 Oct 2026 11:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE616B07CB; Tue, 27 Oct 2026 11:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCC2A6B07CC; Tue, 27 Oct 2026 11:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7686B07C9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:46:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDA19120382
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:39 +0000 (UTC)
X-FDA: 85368833718.22.1DFAE63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 303F4100002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cnFG75xq;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793115998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TkajPyN/GH0NQa9nfHgSYQX1lDjcrGhWefwdVdOd9cw=;
	b=Z0MNEDgVsGRdUez41cR0LrdI5ZxDQkPRrh7AAz/CvrECIkHbw7M6GYMr39Dl9C6OSU0WRh
	GsxKWtsGLgfPUclxSKdhKh3EPm7EEWyX0PAIwfCYOYpZYDwOT4xd/2cqEAB/WTBD1kMLoK
	/f93fvtwzlaLG7fYBuENTFCs3a9SeWE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793115998;
	b=3NiEglRMXGjesayhNPx4Klkshw3cRtGCDDmIDzXlGSGXqFn0VxhXmFgX5w1DDep6Ol7JH1
	iEw8EYReGeuzeomRfbKCCWqsrtrURI9aOePg0oNsekT8SPu8NWzNNemwL1dHf7mAKhLIcK
	win5/R5f3ngd0xzezh3JyLf+2StBD6g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cnFG75xq;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D6F543BF4;
	Tue, 27 Oct 2026 15:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D06E1F01828;
	Tue, 27 Oct 2026 15:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793115997;
	bh=TkajPyN/GH0NQa9nfHgSYQX1lDjcrGhWefwdVdOd9cw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cnFG75xqYOPouaLfdO1n3+9x3mvKVPPbTb75zL0Ve7ybnZEI0um1yk8fTdE8c0aTO
	 OchixKsbFVVX9pkhfU8QMXnYDWso5w6BCnYha1Sc5cjQItWdP9kCGEJkuxqUSqePjL
	 8uU4jMMYQTDh78EtXMcWaOSkSScCWe82+YcgniY0LjTDdjXyI1E/hCu0k06rsimkpT
	 elPFWaqr76SXEb3wdjqlKb+VHRwzdYLtCJHhySzu2ULW+0xXwC2q5cW86ssKv6nXWb
	 tCxzDMabgmXHRPakFeCLbHumw2TLgD2ng4t9qmDjk4xTEUCqm85kercIRwu0+TqsEW
	 rS9xwAW23dcUQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 27 Oct 2026 16:46:27 +0100
Subject: [PATCH 1/9] mm/page_alloc: don't undo a racing
 start_isolate_page_range()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-pgalloc-ai-hotfixes-v1-1-9c7d1aca801e@kernel.org>
References: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
In-Reply-To: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 303F4100002
X-Stat-Signature: m4nqp4nq3ni97e8jy6gi8biq5kst9twa
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793115998-122884
X-HE-Meta: U2FsdGVkX18kThV2sZSEeGx6iSBN418grpJMJnH4FWNjBz13qobjJykawGxj4jBymYgn/UotHOmkLPnBRwF4f4DVjWAeFPMpRHi7utvWuEC++cVcCjtPdXB3WP/AZYTtAsH+kWj0c64AD6o40sr8De9WOjKsgG0SWX/sWOFT0uQHeu6xWq3kK7Ac6E0no7Zg+wNihe30pDYQGmScQu6grH4HTtRDRm/IQt+XK8u8Sq8C5f8rXl+WqT2Cqfu6MJeTXi5IVsUxq2RGDdPSl0rKtvjnTtW/78uer0oqQPrWSV+Kn/P5Izh/9+KvAGoq67T3Iec6I4zK+OJ/s326CeZ8KFrIjaj4A/p6gv8fO8zikoC8jWk9Cz1YxiJ/5nv8HgwqxkuC2J8n05ow/6nF2gAQe4U6K977ZENX9Np+eSiIMrGJs6u82zAJvJJ9gSpowb54ZHkWBufWCboUh3TZdk9B/hNU5K8BwbgyiLaYpV5rZfA8kiXd4B0pFraAYh3RrKhZ6sH2WFuuQs8lNMyLpgxxNfrohOoMZsOrbKr+S1buOia9h83bfp8/cE2B0Dw8WXJVWzkGZuSG+PwBQt6n8DflDKlQeXjjdsj+1icvLBgNcN873RlCNPrhl4Mp20LbIuyAJN4SZXkah6WGelzda9jdiB7Ub4ZKngbV/Do0o77WfWGHWp1lZdxBeiJoQyrBD/Kdwc0/ulo4my3FtU/6StZ9G6PgvTjMJmT3cOwcMadLjMHjnlqD7FgDaBWAGYZSKxTcvEKOsN6B1IujRRKJvxg4VDYo2lBTkBpgnSyeFX/rETM/Xr3yYJjA4gIYvqITB04fK4twzE16FZzPdbrY4B3DwnMapas9ayx5eTu2/zuo2jWozg+6MSS0U0c3VCdaaj542cPsNtJVZQQM38q8EyBRBwCudjgh2z3Cvm9vgrEQ3E8O7C4El+8jvXIHPiNPgUljP5UMj8Y0btQIR2xlo+p
 kJpvx8I/
 cWj9FPifRZfBMljdDx2B9Wnje7/6A/E5pw9TL48AtYV1qbdidg+xFy9R+acN5SaqfK4exEPWIVIOkq23RmxkfMaTKfV2NQhrOVxnEYcxUT/AdU0NxcfRF8I5RoJXGBUoBxgGmPdL5cgEMKrs7/XCA6hiW997Ii2o9az8bnB5zMim08ytCqW5ivSNLwE9lk3qJGl3wzpGd8ZWcBSph07qEOrNjp1VXITQnbqVNwrMVv1DudDXjy75Aip1il50gTG2o3glxqDFSFwyqL2ciKDHwLYej0sMbngCJqa0vaj3NjfdwImtVkwXoOihGrj9YwRbSaU28aDpTnSNoPdUFtqjvAoHUVC0jQB3XIOmT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

start_isolate_page_range() fails with -EBUSY if one of the pageblocks is
already isolated, i.e. if somebody else is working on it. It restores
the pageblocks which it has isolated itself before it returns, as its
kernel-doc says:

  We then clean up by restoring the migration type on pageblocks we may
  have modified and return -EBUSY to caller. This prevents two threads
  from simultaneously working on overlapping ranges.

alloc_contig_frozen_range() nevertheless calls undo_isolate_page_range()
for the whole range in this case, which clears every isolated pageblock
it finds. The only ones left at this point belong to the other user of
the range:

  CPU0 offline_pages()                CPU1 alloc_contig_frozen_range()
  start_isolate_page_range(A)
    pageblock X: isolated
  migrate ...
                                      start_isolate_page_range(B)
                                        X is isolated: -EBUSY
                                        (own pageblocks restored)
                                      undo_isolate_page_range(B)
                                        X: not isolated any more
  test_pages_isolated(A): -EBUSY
  (again and again)

offline_pages() repeats the migration and test_pages_isolated() until the
latter succeeds, which is now impossible and the task spins until it gets
a signal, while the free pages of X are handed out by the allocator again.

If X is released after the last test_pages_isolated(),
__offline_isolated_pages() takes pages which are accounted as free off
the free lists as MIGRATE_ISOLATE. Thus NR_FREE_PAGES stays too high, or
hits BUG_ON(!PageBuddy(page)) if one of them has been allocated.

For another alloc_contig_frozen_range() or cma_alloc() the result is a
spurious -EBUSY.

Return the error, like the function did until it was reworked.

Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 36079e092875..ee013db45ed1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7329,7 +7329,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 
 	ret = start_isolate_page_range(start, end, mode);
 	if (ret)
-		goto done;
+		return ret;
 
 	drain_all_pages(cc.zone);
 

-- 
2.56.0


