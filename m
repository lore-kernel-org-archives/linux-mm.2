Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A46341073CBC
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112AD6B0092; Wed,  8 Apr 2026 09:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EB4A6B0098; Wed,  8 Apr 2026 09:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027946B0099; Wed,  8 Apr 2026 09:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9F226B0092
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:43:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB4761A0119
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:43:33 +0000 (UTC)
X-FDA: 84635505906.08.7ADB09F
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id EF28E14000F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:43:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=2pjpuHjT;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775655812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nEzTFQjl9DqVOjuj8AZ7Q8vKfFlTMogz1GqqT4a5JQc=;
	b=JFL+rja90UOUgU8CpvnYz+ark7r2lOXeJNXg8g9ztZPFT6YceHfhY4gFPwuPpFUDc5/D8Q
	3NtO58nBFHd/kBqY13SffwHYJDPv6Pp4t94baxO3TX1KecKcJdxN1hE/fTyd4jqerOBGiv
	K0rujySAXOC8FEZXbtgXkMOUk73OKOM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=2pjpuHjT;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775655812; a=rsa-sha256;
	cv=none;
	b=DDTCefMad7ix8olK8/RrE4Nj9A6nZVOXRa+UZ1rtnUPw0zK+v/b0Pa+wNJ2UdqQbmmXyYw
	V2Aedoy7T/sQdt1q1GoP/iWNmWAJYjq1d6ZU7bdgck1w0ZBL1s2xzeJ14BpBd5qv01jQkB
	HmFxMeyDxkPZUNNVA3honD99wi1foIo=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 5E8CABE716;
	Wed, 08 Apr 2026 13:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775655219;
	bh=nEzTFQjl9DqVOjuj8AZ7Q8vKfFlTMogz1GqqT4a5JQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2pjpuHjTz5McVfzUin/beRPpMqPNX2JPb9m5gwSLojZPjhvqhu3AEtJoafxeecmR9
	 CJD7wS5ddB9R/2JhNy4jkxLi2OTX2JC5aTkzW2DSb29rdiPE7apXSwA+mBIeHaplFv
	 3s8KAFlG2qZHJmIKZLN4f/hcAHsvxWVHDwp32lWg=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
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
Subject: [RESEND PATCH v2 3/8] mm: use zone lock guard in unreserve_highatomic_pageblock()
Date: Wed,  8 Apr 2026 13:33:18 +0000
Message-ID: <b259aa5ea08a8f6f04b36986fa302e70f61ce7b4.1775654118.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775654118.git.d@ilvokhin.com>
References: <cover.1775654118.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yuf4b15jazirhocej4fuq6mbhyoq739b
X-Rspamd-Queue-Id: EF28E14000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1775655811-11144
X-HE-Meta: U2FsdGVkX1/Szl69qU5gbAl5018IbZH8P4X1ij0AkEdWXqddJRs3b69+3/KbY/C9WRREUpYxKgGkK7n11JSxqBCNHQzHuQqm4Gz/ogpz1AfTfoxp0tZOHIZniKiK1GxL5MjWPNe3qjRKCpKa1zAM9xOfj1kOSYI2vveZi20ZwBJiLSt9nvl8umMCkgCoPY/AmYB22JZfclyd2bXTXSH/pbUDDJpbAGzACC4bhEmcZmrAU4oowpsN22jkQb3BmfgYnbwFZtzeo23Lnnfc5ySu5O16PN6U5e4vDJuEelgoG+d8KGP8z287IQqrgIQ2/uV5YDU2r2OoKW0Bapgn6X5g1Rk5nyKYgfQEl3oqtWCNTtiGaoBAonIwNdjN6lgoyZFNW4ZbVHkLbzNit8ZBikakyw9djJi1moJazQayEY1yZQ8MUpF5rbQDqAiJNuqJ4GWWu/PgCMWUZRZpyanCvgLbEn46zgKVl1eAS1V8bs96sA1kOMNoKfAV+eE72Y14bu1P3iyvZQkkIJY+ta/riN7XRtGpUjREO1ZDz+ad6a4XdijR4tO21DNCVI8bsi9AB3mRjBr03VaIqy0kPNLx5uIFzGninzBvw3Z2B+MUYoqUa25VM2IvW8IQoGqRvXkDXBk4YUJa35fHQTngEEKc+XWrS/x68VF3SAYJiri15Fe17UA0KGCd7JdTRp79HVyRiBQluVGgxm2u6hWLrqmqIY7YN2kISBkFzGrxbMuqZcp3R1UyLLCMwTgRXekRI7MeQvebUOTVcTq89aqkq2uw+3yvUun0opfWgBKL44gzL8cmClwLwXeaN7QzkUmJ/ohLTRMf4I1ZErgegp83PkaKJzgqGx5R4moJKOstnQ9Uw4ixks9XSVQi98+uUUyQ2dEqPjT/w3s1mHah5STOXEt5i80uuPJRSsWDhtpPjgEjVUYHFVEmVa0jNyezgJ4YK6PtJNK9WE2U+K9lHElrv7nMoJG
 BNcBTF7V
 2f3D9QRViiHi9sdGPIqoDJ5lE6ia3J0V68liQfougv/4hOlkL4Niqv9VQar0ndypR0RucJnqBwr94XUrmxzCtcQeWCoD3AiSSO1aB2ab62Uk7LYAbIDxA0zcL37uLPCUccrDlc9XNxykZEaM2tWJhv3KpqfJkf9BwzXTScFbgUyN5mXrQMBSxVjvopfZbBv68304czbGhkgRrX27zRtK4wfl02dPtKpqTEmaYZsLbgGMR5ieCgHNaQ7ReKSVG0sTyWd4co/7wXB35LaNYbTOfMdttguq0oY5VPEdlOhg5SDWOLbGWx7niCl8H70sJnAl9AsUXx+KvQT3HBeZapu708z2zjIuF2GuQ28NC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in unreserve_highatomic_pageblock()
to replace the explicit lock/unlock pattern with automatic scope-based
cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3a4523c35fb6..0b9a423cbd24 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3480,7 +3480,6 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 						bool force)
 {
 	struct zonelist *zonelist = ac->zonelist;
-	unsigned long flags;
 	struct zoneref *z;
 	struct zone *zone;
 	struct page *page;
@@ -3497,7 +3496,7 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 					pageblock_nr_pages)
 			continue;
 
-		spin_lock_irqsave(&zone->lock, flags);
+		guard(spinlock_irqsave)(&zone->lock);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &(zone->free_area[order]);
 			unsigned long size;
@@ -3544,12 +3543,9 @@ static bool unreserve_highatomic_pageblock(const struct alloc_context *ac,
 			 * so this should not fail on zone boundaries.
 			 */
 			WARN_ON_ONCE(ret == -1);
-			if (ret > 0) {
-				spin_unlock_irqrestore(&zone->lock, flags);
+			if (ret > 0)
 				return ret;
-			}
 		}
-		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 
 	return false;
-- 
2.52.0


