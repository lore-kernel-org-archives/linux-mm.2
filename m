Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B23D1099B40
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7015B6B00D8; Fri, 20 Mar 2026 18:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2E26B00DB; Fri, 20 Mar 2026 18:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EF646B00DC; Fri, 20 Mar 2026 18:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 494BE6B00D8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:13:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA4EE16026B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:13:54 +0000 (UTC)
X-FDA: 84567844788.16.0BFDBF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3B06D18000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:13:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tInuY984;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhNg8IoEaA51vVYq3cX6v/CBT5rDu1UXXIcSpmQtMQo=;
	b=a/hkwHNZ7VYzymKHWaocy1WvTtp7YocH7k8rYUq9HP+x1CodXEQw6AQZKQ6ZBGnLluXm63
	tRDHdzxB5BRf4BIvTI5rDmy6IMNLA/2VzqmfPNGVfy8Ol5PI9v94aTCRynS1ImmQwbdYA5
	oCX7jAv6R+OHYWyb6ArO8TJWmw+y/L4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044833; a=rsa-sha256;
	cv=none;
	b=CqRCqEaLA05LX4lf6u2JiC92rzo+vbcl9FDsDkYXSJTzsVSKeasubdmyWS4Mr4tTWvA7Ce
	sdPeCJrNBvNcc/ixGNJPG0+skgZxDgtn4QKYWgUFEnwZajqJKaDRPGVYxs+IynNqjHk9r8
	5QAcS2crNCMuej85v36eitMb83RxwOc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tInuY984;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A993E60126;
	Fri, 20 Mar 2026 22:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECA5C2BC87;
	Fri, 20 Mar 2026 22:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044832;
	bh=XBR2EPoKpXeNjq1txkLBTh/DgkCJHtoC1PlnginQxtA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tInuY984yzdIEuaZJXpPPAPu/jx6o88MxmPXqoEhhmH9XAKSJMbP9JmVw7KDYMdYI
	 cYFzrC3mXShUxMELrJRAOb8iFHCYRFYnMXADOypUly2tPI5LhdRJAlx6Y7vIsodwEE
	 Tb8WTg9dueCXRj24fln2u12nVVjS4oL3Ny2O8BgKFv5WAfttURT/QkCV02wu1LukEt
	 +WqU5eLPOYBtokHGt2yPjG/XvcY29bKMFzXiTW0vweT3cJdrcDYhDTgUwEXHa4yEL4
	 Ov9DFUt9eHboVve5zoTrH8Bv9mnM+yD+kzQ6+YJzB4D+h8DGu8XFoU9yIoZlUTet3N
	 5V0hxSVsZnYcA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:34 +0100
Subject: [PATCH v2 02/15] mm/memory_hotplug: remove for_each_valid_pfn()
 usage
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-2-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B06D18000D
X-Stat-Signature: 5aiwe8wmhgkug5q4t5ht3q4nx1bepkzz
X-HE-Tag: 1774044833-300292
X-HE-Meta: U2FsdGVkX1/baT4ewqH5tsbJs5hPFMADXIMOe+vege08It3nfJQcbAOMQlpnIDrjaIstBZ+9zkiVNnw3hIHCoVUxLZWxU8L2bNuR6hm0YyCP4w8UVXz7UNfzB9A5NYuxSK1INnm/8y2o6NR++zrcQ0iWWmyXwsc/rEEJT50f5wJINGfPWGX/tMF9wJlNJ//pthgbWbegvwn+X0381q5UkZzqxU7BpPfQbZ7X7U6mBL9ysALz5xWuNpIR94ZUCTglItlRz7++poqit5YQHw7TzZC76336aR2GA6d81hEp/U7zfq0vyNwHy5KEQ1mWFjKU8oUWv/TuFSAiUA5mJLABaOJHIjaaqzC3/KzuJlfepE6kAS/c5O7Gp0rJdjCfcMO5p/g0QXMjR4ZQB8NpS7NYsAZrAuTQ/bbWnkm2vO/taeQxk8h7SRcujGvSyVWrO4qlz0ygwmoY77n+JqLqixgiT680/BPd3MMKfW3NJWZYVFHjuJlhElX2n46WRlNq+uhxY0cVqwgZE/25KHHIzbsZZlWcbb7RCdyuIm00exdp0s7cbkgZbxyG5K5DX6/p89Mp+6P6wiAhE4OK3c+2eN8Edz5xjpYH4JHtdD68zyVmTO8L8KbrnBC6wKfY84/Hr9wAnizVzRkERP51KYB08a8bdKdB1RNOatQbIlVRsbt6jRqYgJRU+XexsVpIC1RCnY4o2JHaTsBEld0QvFw57w/bceXxgR9MZ/cEGb3+jobxRzgw6LvQod70JRIrlYQm8pPg60HtBY+Z+5PxYcgDFawU6Ozr+nl1TJ8mTAXiRqJQ8aShAzPqoL/w+y9OBohVGmeYElcHAnkJ2WtzP/qJUO/9NfhyPmBYml+pBLnXi6QQpavGQAgZoOWoWD0eHg8XRwXhxOwmxxdV1dojCfntxMl9wj8XMXmWoe+qw7M2a/T1GCtJTAshLTk7CSolvwSLxcyczvbUGbVEwmC0Iem+y/c
 2ualqu25
 QXzf25Uwo3WsxFtjr5CaPcChjcOSqLZftTL4Gk1WybEidArKFzEMrPFzAe1e0kup+5blUtahwQCUMr3S9vCBwWGXZooWT/nT57KKzz7a8bLD8zA1CAfygTtSXTVSI985RSX2S5dblrAjCZA++XEwfPVxibp75uSV3dttVbodMs3UEG60R0g5dT5JTJgQ5sFpUswR7coYDm8H9kaXuGzaoTkwRhVJUzVbo3uy/TJFlwOnxJT/6Ibh+BZp7keLq2JrxUUpXg2fe6Eb8FUEcIDI8wqCmjUj1Ji01CmvX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When offlining memory, we know that the memory range has no holes.
Checking for valid pfns is not required.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory_hotplug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 969cd7ddf68f..0c26b1f2be6e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1746,7 +1746,7 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
 {
 	unsigned long pfn;
 
-	for_each_valid_pfn(pfn, start, end) {
+	for (pfn = start; pfn < end; pfn++) {
 		unsigned long nr_pages;
 		struct page *page;
 		struct folio *folio;
@@ -1796,7 +1796,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 	static DEFINE_RATELIMIT_STATE(migrate_rs, DEFAULT_RATELIMIT_INTERVAL,
 				      DEFAULT_RATELIMIT_BURST);
 
-	for_each_valid_pfn(pfn, start_pfn, end_pfn) {
+	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		struct page *page;
 
 		page = pfn_to_page(pfn);

-- 
2.43.0


