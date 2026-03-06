Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD65FCB61D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3966E6B0093; Fri,  6 Mar 2026 11:06:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32E1A6B00A1; Fri,  6 Mar 2026 11:06:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0A86B0093; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D570F6B009E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC159B9B55
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:28 +0000 (UTC)
X-FDA: 84516115656.19.DA8162A
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf11.hostedemail.com (Postfix) with ESMTP id EC37B40009
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=tGHmLqWR;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lC/RKPmOVVI62+gZKGXoWGLnTSSGp29jP+MVgzYIVg=;
	b=RZWvflMQypCfswznfYqxc6NtWzJn+1GLVJaCdkoGVLgwV7r3gftvSuXPN7agdSB2skHtMX
	eyVNNbCCr2tyKyzCSs3LxuPZgqCoVuqcdLumPQdv/1sFTEoa9PYhhPfsK7l2++uFMFgDXi
	ZtYI32HLyk+P2IQszCDaANyCYE6g9bQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=tGHmLqWR;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813187; a=rsa-sha256;
	cv=none;
	b=BxBRkWEivfj5z+K5IXYccffdHHvBeaxEJ8vmHNRK+3SkXdEBTJdJxUeA2cGc5p3Qmo8jFD
	P6eVCTw94Y4LHADeOfQpGRYx6yZk3JLzj9keOXaTWxAvTCksl2F2s6vimQU8Bv6xZptOvM
	AOvCQD4cbZcefgMt2U9R6HKVtT7qtUo=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 450D5B3446;
	Fri, 06 Mar 2026 16:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772813185;
	bh=5lC/RKPmOVVI62+gZKGXoWGLnTSSGp29jP+MVgzYIVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tGHmLqWRQRsEr6+QfNuAGGqpAmvSYNip2Au34RkMFR+m1MpWBBoeg9gW0iEwgnz2/
	 Qt/z/g7xtmJrvMGmRlJfc8cal+HyIPma5Pd8YLIO38E/kL6/CXIUytTwfi07Hq0SuY
	 5iKnrm+12E4wMSzt3LLLjuTstIVsbimTbd5oMe7Y=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/8] mm: use zone lock guard in set_migratetype_isolate()
Date: Fri,  6 Mar 2026 16:05:38 +0000
Message-ID: <d82f41d23937d02a0fda99f5b46265e3ff7c2947.1772811429.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772811429.git.d@ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EC37B40009
X-Stat-Signature: ot5g7bbsiai3sgj3myc9de67hqtx1gs5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772813186-416921
X-HE-Meta: U2FsdGVkX1/O9uve89guybwRVc9nrgc1GgJwKRN0L8DazlTbyqe+sKL59SBwB2REJVvg8HOIezk9zbi70ypCEEZv5POygNtQRK7IZL8i7a1YzrmbsiPE3Gyr+giW1J/sqK91oM/0hQuh+s9KyEivfVb3Gw6ZVn0I5VC35ELhYrYc+uA8r4W1DJMLu789epF/PTJ90nfOS88AIpMtcLNwvmGBQzXWIW6/IC8RyMMy/CDDdfa1r1CRKgaHMWKD61nA281Z6iEBit9TgIMOZzZwUBxD5yHV/bamuBSN+Mmv1A6kAGmNjf2m473sWrFFqnJhi4Cq81VIDAwWilBJqUA+l319ChYeydSRQxtgO/lQ7auWNnXeUuoScrQJOcrO8CtqvGOlmizI9XU0syzkDn+0oVRsNYCt/Od+sn15r4YPEw9gJpOs+pgPpcu461hANp9ZtFWyVslzrF5W5gt0u70fKoVQABrnb+65if4NNdKk+kP0BwVxXeeXa2Wt67J/L7rjSPZCLTEyePqfdjsPrkO2IakN5d8B4syGssE03BD1xM68EXinFpAT/b0EZNOetySY9s45nwpcV0nwwm24I+VgML6wCTil5gDpMXgjgg9gNRwMUleMvok/4yiYLJ23XlaiPruNriC9hXl0HcWNB0aLaf5sVYpmILMa//2afSJIchLKeA5rDIpTOPDBdbXXvd3+Jx7xz7pgwIAJBRE8rTtjUVM4efpRkpV1sutxOKvvngUc3jzUxDyjpwvcxEhmRvWyFb7bprXqfSov5buDOxNciQm266M5K+D/7dcm6AGi9bjvpX8VxZAyAj7RMKRtcs+FHB0xbtxcVfp5qlTWeZrfCEmMH0OOd0I8BLQdLZiuk8WgVp7vzosPKIna0djoOwnPUZwfhez+GZiKXTVoY81T23QrRyDDn+NAPX9gf4PlxF/oMuMX6JBGeOt6Tap4zwGQe6/dOBXogg/BwXmTu6t
 EFEpStyB
 /rj+RAshe+lw5vUSZMkwX99QHguVlyvS/kidx2bBYqUlnbondVMZpMwpSLQnCyA6MuUpb8vBFHs58r0B7Qito+PURUYb8f469e+WMY2hgpOy+ympX52HLRXkkZCJm5Fe0uq+ESVnHB+JdC5rmpMX8NTuXK3cpAd4fEyAgU0MoxgTCjL9UI3ioKeIfuInEA14RUIT/ewR/+m/2JANA0yIZcfJYygvg/1pTblvDQoa2IHHXpn03cBzQqAXReJUIos/YnipbuHtcBj7wj4iiYUMgWnIowhajoLVRtzmvrBU34IFUW79pqPCuPieohDXQFRkEhFoixR1vdxeIlO7LCLx3BjxDzYcoORJxw8bT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use zone_lock_irqsave scoped lock guard in set_migratetype_isolate() to
replace the explicit lock/unlock pattern with automatic scope-based
cleanup. The scoped variant is used to keep dump_page() outside the
locked section to avoid a lockdep splat.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_isolation.c | 60 ++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 34 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index dc1e18124228..e7f006e8870c 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -168,48 +168,40 @@ static int set_migratetype_isolate(struct page *page, enum pb_isolate_mode mode,
 {
 	struct zone *zone = page_zone(page);
 	struct page *unmovable;
-	unsigned long flags;
 	unsigned long check_unmovable_start, check_unmovable_end;
 
 	if (PageUnaccepted(page))
 		accept_page(page);
 
-	zone_lock_irqsave(zone, flags);
-
-	/*
-	 * We assume the caller intended to SET migrate type to isolate.
-	 * If it is already set, then someone else must have raced and
-	 * set it before us.
-	 */
-	if (is_migrate_isolate_page(page)) {
-		zone_unlock_irqrestore(zone, flags);
-		return -EBUSY;
-	}
-
-	/*
-	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
-	 * We just check MOVABLE pages.
-	 *
-	 * Pass the intersection of [start_pfn, end_pfn) and the page's pageblock
-	 * to avoid redundant checks.
-	 */
-	check_unmovable_start = max(page_to_pfn(page), start_pfn);
-	check_unmovable_end = min(pageblock_end_pfn(page_to_pfn(page)),
-				  end_pfn);
-
-	unmovable = has_unmovable_pages(check_unmovable_start, check_unmovable_end,
-			mode);
-	if (!unmovable) {
-		if (!pageblock_isolate_and_move_free_pages(zone, page)) {
-			zone_unlock_irqrestore(zone, flags);
+	scoped_guard(zone_lock_irqsave, zone) {
+		/*
+		 * We assume the caller intended to SET migrate type to
+		 * isolate. If it is already set, then someone else must have
+		 * raced and set it before us.
+		 */
+		if (is_migrate_isolate_page(page))
 			return -EBUSY;
+
+		/*
+		 * FIXME: Now, memory hotplug doesn't call shrink_slab() by
+		 * itself. We just check MOVABLE pages.
+		 *
+		 * Pass the intersection of [start_pfn, end_pfn) and the page's
+		 * pageblock to avoid redundant checks.
+		 */
+		check_unmovable_start = max(page_to_pfn(page), start_pfn);
+		check_unmovable_end = min(pageblock_end_pfn(page_to_pfn(page)),
+					  end_pfn);
+
+		unmovable = has_unmovable_pages(check_unmovable_start,
+				check_unmovable_end, mode);
+		if (!unmovable) {
+			if (!pageblock_isolate_and_move_free_pages(zone, page))
+				return -EBUSY;
+			zone->nr_isolate_pageblock++;
+			return 0;
 		}
-		zone->nr_isolate_pageblock++;
-		zone_unlock_irqrestore(zone, flags);
-		return 0;
 	}
-
-	zone_unlock_irqrestore(zone, flags);
 	if (mode == PB_ISOLATE_MODE_MEM_OFFLINE) {
 		/*
 		 * printk() with zone lock held will likely trigger a
-- 
2.47.3


