Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 075AEFCB619
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7092E6B0096; Fri,  6 Mar 2026 11:13:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3386B009D; Fri,  6 Mar 2026 11:13:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6200E6B00B0; Fri,  6 Mar 2026 11:13:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51F856B0096
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:13:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F33F61A064B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:13:33 +0000 (UTC)
X-FDA: 84516133506.28.399E885
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4232D140010
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:13:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=1bOrNU2c;
	spf=pass (imf09.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rAeOH5IgrtG9/UsY5VOxVdlGDjQqvvwATIuVyeglsuA=;
	b=xiNULh39W2nULnfepPtXvrQ2UyApIG3Qa5dzZ0wZIiPnrksnEhfXlNsgyCoOBg44LibIQ1
	Jd/NErqFDZMv/CLGXiAhcLBtvSYSC9B53oGH4wlmYX8GM6KxmGMzMkQlR5zV8tpW2NjcYI
	uYz/UiOKnv/lmlYdD36dHXSrb87jzV4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813612; a=rsa-sha256;
	cv=none;
	b=LH2hHeVDkwWdmR2twRpwjCGqOc7lvtaWSoR1Uis3iDWYqlSKQX0lFHqKxfMjBlKgSxgvFh
	Bp8IsLlDTfIoM7TEa7ZzPvGuhYTGjsPt4trAyI3YANcYL9fadS1kCeLhrBYRkPMqC2WIrX
	Q0nG4FK3BRVC4yoFV7F7Auf2RXV5MHo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=1bOrNU2c;
	spf=pass (imf09.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id CB1C5B344D;
	Fri, 06 Mar 2026 16:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772813186;
	bh=rAeOH5IgrtG9/UsY5VOxVdlGDjQqvvwATIuVyeglsuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bOrNU2cmJL/WDIqAPD076EgHgoW/TaOlwkwVczxFJVtGhtPFQ0pXmMCIj0naFCRt
	 2zTpJP+5oBpkRdpb7ZhjuLAPiLnBv7XLrtohX+f86b3gi1eUzJ7VMQYv89YLomhWrN
	 Xum4wt3f4RVV1F7EsmK+JdLH27ULXCzK1yoaC0ek=
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
Subject: [PATCH 6/8] mm: use zone lock guard in put_page_back_buddy()
Date: Fri,  6 Mar 2026 16:05:40 +0000
Message-ID: <bc97ca32adbeed22a046764424ad9fcbb7fe8524.1772811429.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772811429.git.d@ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4g9inqm9batg7rd5y4snos5j4hgd7j6o
X-Rspamd-Queue-Id: 4232D140010
X-Rspamd-Server: rspam03
X-HE-Tag: 1772813612-318723
X-HE-Meta: U2FsdGVkX1+L7ehH5o6XfrURQVZSzeqnf+F2foW4PiGwZ6gIXDpHA4S/B32n8+CU5uXuZiZWbYQKWCdECrWfOd45YXP6ERExS49Fd3pOya5aPMNnSJcotIwaAuC3mf4SK2nZYOd7pNwu/1fbHk9F1Ps3nexsdTzLagPv3+wf4SmOS+eZhzOYtKPqkz3pQ8QrxDNjoyMhukMvya+/pwJ52lyy6UDpRmRhV0EFTI2ogw+ssa6BaBIfF3UNWJTNq6gXnigV/X08FTsW+MAk2ZuQUds7SoVuM1hU9RP96B1JK0nh+4ZQqh2OPR5J64D8X5c0jwr8SrF+fFgwSJ6T1OsQuCeYPkFk1gSPo0iPbnHYUFzDjXyoX/SwdQqlrk4DSlt4YSQyeBPPdDzMHrhMYW8SrsGSSs3GhiGAMPL0lAsmHhfpbJe3MpEZ7Mst5oL9zZk4nppUSIfomWgTu5QSt84NnTvdBCWeh7sawxjSd/u0FsblkN0GWsijTqbVsRF6AmGIbANS9Acq+Sr+emLQodjzSu8M4Hl87LvP3nPWA4GxRXC5oveIq66TkVUUZ9fYo1x29cvy5XDALEHd1SN6qr9+ghNGm8VRQ67z/V0Q0sUGikv4G1Fcmvg1PSkiHXgbQK8WIyzOfih4XX8Q+pXKmWz3yw222AuVqiqa985Dqq4IRBhwKqJraWTkMcuiGJ54O0P98S9KUAOms0pR3Y3hGK/IKcwilewtLgYckmRY1KvQMZhqFyuXXURJ8nepKPaMIGW4rS5GMkoU7nMx0yIV26/0r8wN2HombjwiZxdciKAmvyTfxwylcihKSYuFIZGpDQV+qY8gP9G/Lu4H4CiOgrSljVWCDd1vvLzP0Ecicvt7nwzXRWfmI5i4TYUpKxv6uTv378Uk6X/cvXG1Z+sRRxuU+iT8xA886eOL0HFMMeKAbTDZG6x+hPcJreUplnD4TnGYVyI+mvkoYnhcH8jkIph
 qgGFkavh
 yy8j50mjfMB/RvXiQRLTqCXFitEaxKcgVBvStDxOgcfG3yCF7PA1oTFKQR1gAN5jKhs515z2Ip19rbkDhM+8nuZ4HcVBUIv62xULzXeTPYm5vIWSUg5elxIRpxgzHOr/eL1BgxyTQ2O6kbk9nPoS/9r7UO7kBVDWF+dwXzjzUpxHJxJ6xqyz2nAK/wcsNPUVvCLlQbtqNJGa8MhanPMcXBWr5H1eiAcac+vqFACUkOgzRdQ6ST8PmdPGcOF6OjyCcwCPYrOtk3QoAat2uQwS4M/ORktPO5wTH4wupFi1OokN5D86u7/3FnsCQsS7pePKiN+lQzN6nQd5ukwzUTnJz9WZvb6BF+ruC5kHh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use zone_lock_irqsave lock guard in put_page_back_buddy() to replace the
explicit lock/unlock pattern with automatic scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 92fa922911d5..28b06baa4075 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7524,23 +7524,19 @@ bool take_page_off_buddy(struct page *page)
 bool put_page_back_buddy(struct page *page)
 {
 	struct zone *zone = page_zone(page);
-	unsigned long flags;
-	bool ret = false;
 
-	zone_lock_irqsave(zone, flags);
+	guard(zone_lock_irqsave)(zone);
 	if (put_page_testzero(page)) {
 		unsigned long pfn = page_to_pfn(page);
 		int migratetype = get_pfnblock_migratetype(page, pfn);
 
 		ClearPageHWPoisonTakenOff(page);
 		__free_one_page(page, pfn, zone, 0, migratetype, FPI_NONE);
-		if (TestClearPageHWPoison(page)) {
-			ret = true;
-		}
+		if (TestClearPageHWPoison(page))
+			return true;
 	}
-	zone_unlock_irqrestore(zone, flags);
 
-	return ret;
+	return false;
 }
 #endif
 
-- 
2.47.3


