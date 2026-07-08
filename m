Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68060C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 04:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7186B008A; Wed,  8 Jul 2026 00:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8E06B008C; Wed,  8 Jul 2026 00:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE6A6B0092; Wed,  8 Jul 2026 00:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A70F6B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:13:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF4DA1A0651
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:13:07 +0000 (UTC)
X-FDA: 84964289214.20.BB5A0DF
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id AA12D20003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:13:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XisPliXw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783483986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZiJokuQxVfAJpsiEey7YS1EwQOtYiv53Kf+q+DJltM=;
	b=0RzVD7I1e6FDUpxyToIbm/sF3kLSdMpdeqcNRzYIFzrvAbFilMOG1PYf/BW3h8PHFA9X/F
	ES9Qolh/dyzPYM/GcKUinSV38GFdOkNbzFwyXONsVoNLqNhOm3d44B6rMYXvtkIraAsC2i
	cYehfbzJHzMsq4fCLDb0biWNHsnB6PI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XisPliXw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783483986;
	b=LMN8LwSvoKs66keeEjmTk9D4M5c8dpkI2JTstuW8cI4+XcIq9viRz/XXF3dzt0CPRJu5/T
	ulZDhEq7J/fyOHhnck7W+TalArThG5uNE1/DRvEbRdoJ2dgjHowm/mP2OnTeFM81iEQcl6
	sYvEvD5YOxzEJkUpu5iwAudufptE500=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783483984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fZiJokuQxVfAJpsiEey7YS1EwQOtYiv53Kf+q+DJltM=;
	b=XisPliXwGD7r66MNwvPo8dSl731WjYnm5BjYbglvCteLzzHzH5d1qjVh9eQS4X15YMjBhM
	64gnefgI5wpz5YxhmYkD5x1FyM+ODovvIXiDd2n7JN7P6wXidzuCR0znVXjuL7xkg86x+W
	xeBYOSsVL6joY35x6HATZ7OiThyCsV8=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: stable@vger.kernel.org,
	linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com,
	jiayuan.chen@linux.dev,
	yingfu.zhou@shopee.com,
	willy@infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Huang Ying <ying.huang@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5.15.y 6.1.y 6.6.y 1/1] mm/vmscan: flush deferred TLB before freeing large folios
Date: Wed,  8 Jul 2026 12:12:36 +0800
Message-ID: <20260708041237.289026-2-jiayuan.chen@linux.dev>
In-Reply-To: <20260708041237.289026-1-jiayuan.chen@linux.dev>
References: <20260708041237.289026-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AA12D20003
X-Stat-Signature: nw4b9qx6zm9wcemkxgmsik6ymxy65ywx
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783483985-669163
X-HE-Meta: U2FsdGVkX1/Fmuz82QzkQeaHcgkV5ZPa9siHFH0/iqAi6KRyJT0SY2IG9vUq2mqDEZXwlrIH8Da1OeM6O1/JCxFiseIEDEsjQ4TKLxGVYt1YFa89Z4CX5HTqYol+uYmGFSf7fQCUEhJ+4RAsUvQg7YPMqsL4qxi5v+uueyFpCw7S2oO5W1fKW/07fJmEQJBw6WQPGmcTxF/atg2XBUwZIpWpHpo0J6HNLizqyT5S4XIiUcjmh0y4QOpxz30IsmnPjNfYR6dmk6j3u3P7uVN1HFhEpGZhc1mm3RaYejzwuVymX5JlydDYJDtOyTVXVyte719+XS3A9X8vJjqPr5PyPiycicHD/3RCka9dHW8pFows137TO2kQzd4Ne7rVGDE9XXU0+Y2tYKSx+eNqABFqvVbI5EnAwExGemJIDE1xKBz/RJTzt4iF9xEdsEsVvcj2geUra/PsjlS4Z0XomJnbk5OIdd6WeXk+ySBZzXRGmCD9Rl0NhfRDl/jpDxMYqsJXfKzdBywkBNdo0ALxDAPjfXno5VOWvByERM4akWv9KqoZ84GHvctRayrRPW5qBEhGz8V7wQXlCUKfyhmirg+UsFQkASm2hv+zS0L/3uPOvk9Ezd4DW/Az2VMBQOqJTyiDt0CxWfDgJ/JEa2eom22sEtf+ltpaTF+WdvLzfjz73XomaR8tFomxxDi8ig4KwjLyGp0FnkSeo880GafrODvIyjw6sV+5KSnonOxt18Xcw/oFRUZxg3zTxQjwxqNyOuhIdw6ZfZxIYNbbxwRpZ9azZKvwoMr27/lKbvd0OXNzIesePGas7zIH/TJmgw9Tp0hlC09oymUjHtkMCh13aPyCRYATEmV8yhZLTwHRFbE/19ZIQ0GvW5n7c8Mfz+dvNTz/socFWqweB8yJrcQjwc4CJf21epKY+q1aFLnUmrp+ItvYN0hLZGc4yCIOeiKbLFOCOQSxH2bGhOc2xNRHD9w
 hIbjmWhZ
 r3tooFUQBb9JPSN0DPnw7INYhtuHvOzBfH+RuCpYfahJjjWjlFS+Dpr1goSeydrD517Dte/WYvwU0sxB4dJvDIy3lzqP5fiEDq7eKLEACo+MZEPQ0WNTfe9R1sNzrOKnjQOl3aslOYj2hMWcE4jhYpUipzKyQr67pDpK5283IXA2nHco0g1fCXMXJoSKREt+jYX/Y7l3ctpe7ru6IcC3nmE2bn3iAcm9L2fM9sIfOIGt29kyGDqF/CU4lAFgVMwCc288qYeqkIrAaUcz5Jdtrbn4Bwv/ED93PVUpxRLyOOwnzkN4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

In reclaim, shrink_folio_list() unmaps PTEs with a deferred, batched TLB
flush. The batch is only flushed by try_to_unmap_flush() near the end of
the function, just before the order-0 folios collected in @free_folios are
handed back to the allocator.

Large folios don't go through @free_folios -- they're freed inline at the
free_it label via destroy_large_folio(), which runs before that flush. So
a large folio's pages can be returned to the buddy allocator and reused
while another CPU still holds a stale TLB entry for them, and that CPU then
reads or executes through the stale translation into the reused page. For
file-backed large folios (e.g. executable text) this shows up as random
SIGSEGV/SIGILL in user space, with fault addresses that don't match the
code being run.

Flush the deferred batch before freeing a large folio inline, the same way
the order-0 path already waits for the flush.

Upstream this is fixed as a side effect of commit bc2ff4cbc329 ("mm: free
folios in a batch in shrink_folio_list()"), which is a larger change; this
is the minimal fix for -stable.

Reported-by: Yingfu Zhou <yingfu.zhou@shopee.com>
Fixes: bd4c82c22c36 ("mm, THP, swap: delay splitting THP after swapped out")
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
destroy_compound_page was recently renamed to destroy_large_folio.
So it would be conflict when this patch was applied to 5.15/6.1
---
 mm/vmscan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index aba757e5c597..8eb498351d9b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2123,10 +2123,12 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 * Is there need to periodically free_folio_list? It would
 		 * appear not as the counts should be low
 		 */
-		if (unlikely(folio_test_large(folio)))
+		if (unlikely(folio_test_large(folio))) {
+			try_to_unmap_flush();
 			destroy_large_folio(folio);
-		else
+		} else {
 			list_add(&folio->lru, &free_folios);
+		}
 		continue;
 
 activate_locked_split:
-- 
2.43.0


