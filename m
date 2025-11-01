Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19899CCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 13:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB66A8E0070; Sat,  1 Nov 2025 09:42:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67188E0068; Sat,  1 Nov 2025 09:42:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCC3D8E0070; Sat,  1 Nov 2025 09:42:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACAC88E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 09:42:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E19F89073
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 13:42:31 +0000 (UTC)
X-FDA: 84062152902.13.55E1101
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf08.hostedemail.com (Postfix) with ESMTP id AD6E7160013
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 13:42:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762004549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=3cvApbxM4MUPbfye4oidq6VYSoxjios4V1e7shSohHA=;
	b=UX+gh0xzqy9RaH1ndbdfKesJATJJFgdUPlBHnrvpI42gqyZk9vbYwj8ok3H4rSXkzBsa6V
	9j+xQ+KOMCvadomfmW4LqordqNBTqkI1Do8LsYm5m6EptbB/LHYKWYQO/UHFdKeErGA2np
	Vi5xddAKSD0uauScxMOiHEkM5Pr9nIg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762004549; a=rsa-sha256;
	cv=none;
	b=xXK7vI9mtULbtPmpeVcci4NhVceSNK/DxRJOX7wzCoiB2RD7Q4qBCoI4DrQeLWvKjDxd0s
	6sNP141LIBRsDP8X0zcI2y0E0L3QRUqHfu//kpSjC+D1PMshZV+0YUuApcjjAyNfy0EsX/
	GmC0QfSMNApCFzm3RU5AAjsxbQeOeYo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 1 Nov 2025 22:42:21 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	youngjun.park@lge.com
Subject: [PATCH] mm: swap: remove duplicate nr_swap_pages decrement in get_swap_page_of_type()
Date: Sat,  1 Nov 2025 22:41:58 +0900
Message-Id: <20251101134158.69908-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: xj9iwmeq9ynbhqkjeqgag8zowsmw38ba
X-Rspam-User: 
X-Rspamd-Queue-Id: AD6E7160013
X-HE-Tag: 1762004546-549168
X-HE-Meta: U2FsdGVkX1+wXYViX75KyOhqMqbvTZPB7q2TNNhDwM0QRpS6ZRd02n72EoW3A3uVKdxTh5qrfo58IDgpVaGla3FoU50xrusJBi9jM2H/diwHyG91MO9V4fBTVCipeQSWGb9SZNa7jITZJAnOt81nBtarb6Ff2o0e7WGRKjwS6sE3JH8259QLSEupP9xO/seTkpIJgCKrhfpabbkEedK3gzQ/lRpo3LrKGJgfyqWSsq/TJFsWXHR2Xa0R19ztrnP/CcPT8nQsymaSeFgp02qHYfHgepN/wlZANavjh2p+Mbm8FeY5SAq8l2EQChUcWAGZpPdnfM8ee6JQK16CE6WsPpWne9KY95NMveLOdmKqj1cd74s6VKHvn1df+IIRnUhztYYSH5QHKEfK29BzjmIFqM2LNNj0YFrW+cxnKRkqjhs5c4oU1ggOaC471vaj6XgPcOkRxhIw23YNv7K+khoHmLjRTiY8v5dkXFeTxMrXanPwoCES9AJQKfTINpOtXgbc+Er8kburJwxh8Aw/116RjQH3E64zbOHkZ4+JP/v+Ec606Ns1X+U+UcL6m8gaqKN4YUp25/ndbjJ7W1Jp/DxKBk6PJjybuBXJrJPgia0SBmXxklSUkWnbO+vL6p+sHMtiIxRSlrDNdmlcG7gVf5UGt7IAA7fXXGHDZt81oFqs8klt1STWqm74OP5zwwnlA3VrYeVlY9+RdajTpwSz7a7lmsotwDNf/qsgzlhi0Re/rkdEqRCRcr2PlFIFPWDTs7CF8aLW+x+EYXd9Y8w0lT9tBoufgwG1XhGAfSts1bu70twgaNpmxcNn22N423qirRhv2njFxjiXQJRrwrbV2CJ7N2W6dE9sXYXxhrOHnS12pQLqnJBehjOOk15yYyJHaeasDZAJ0Np8nmOxLrBSybZhOy+cVT4C9yfLNi6KNelLlVEVa23//Km8ct4349rcRT3uhaKGYEcO+cUk/nhdVn2
 cpTjdnWl
 twa7WelSn5BQjDPKFRo8tWf0enKSKTvV9T40TojHe5k1FukN1Skrlv0w2ZbGoD8pwaVcqqEgoBsUbBbiswmdaK5H16pgrlrXCD/LLmxLOVuyR26nsCYP6EFcOOWEIQBoJ6M05hol1Mo4ctBbtZQAYOqoJJtjOk2NgyyKKBPde2Yzm6nSGBHydYc8Fs2/VFNBn2Mb9QRK0GoSgRPqQNJkNt0/CMnT/requbWa5OqDn2BNJC80=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After commit 4f78252da887, nr_swap_pages is decremented in
swap_range_alloc(). Since cluster_alloc_swap_entry() calls
swap_range_alloc() internally, the decrement in get_swap_page_of_type()
causes double-decrementing.

Remove the duplicate decrement.

Fixes: 4f78252da887 ("mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()")
Signed-off-by: Youngjun Park <youngjun.park@lge.com>

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 543f303f101d..66a502cd747b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2020,10 +2020,8 @@ swp_entry_t get_swap_page_of_type(int type)
 			local_lock(&percpu_swap_cluster.lock);
 			offset = cluster_alloc_swap_entry(si, 0, 1);
 			local_unlock(&percpu_swap_cluster.lock);
-			if (offset) {
+			if (offset)
 				entry = swp_entry(si->type, offset);
-				atomic_long_dec(&nr_swap_pages);
-			}
 		}
 		put_swap_device(si);
 	}
-- 
2.34.1


