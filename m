Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE505FED9E8
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666356B0092; Tue, 17 Mar 2026 12:57:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF836B0093; Tue, 17 Mar 2026 12:57:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF096B0095; Tue, 17 Mar 2026 12:57:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38B0B6B0092
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:57:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA153B70BF
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:19 +0000 (UTC)
X-FDA: 84556160598.27.087503D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4B82710000D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kYLjGDyg;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2Wi59pFWuonk6QVCe4wMivcllOZGJDpOnCIhiJ8kK0=;
	b=pAWRABkrjc1oyneIyFbWL65ArtDetIUwEf2chXVab9uGxCpABRG2MDd822dBXWM4MMBDid
	pTJACglt2kNlxzIVd/e2qQU1Qh/e/RRddn4dnGWuLHJFgzwB1L/DkrZVOwLh1t3Z3H+Hxj
	D2eaGjFLeQlz6GOt25175vwiK6hU4zs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kYLjGDyg;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766638; a=rsa-sha256;
	cv=none;
	b=IV2Ss4IkoeCS/JHXLIL852tA6+mJo7WSvIm3INB4Y2lYKfKR1NO/I3Dveg9gPdpBoOaihU
	EE1ChAC+nkmcKlOcntEUwLnAFwBcR82vVXr6O2eI2L7pAoFDqmr81f00rquNh2eQ0MG2U0
	5sj2u54Eu+FUYRGnUgrE5+kVnLqp7zs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 997AB60126;
	Tue, 17 Mar 2026 16:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC353C4CEF7;
	Tue, 17 Mar 2026 16:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766637;
	bh=BWzG9/0Rza56pImCpceClbjm8voSGno8HwPH5Rkh+Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYLjGDyg61omCXDRJEGsUHy/Y8yhVjt3XBOFEWT5DvBNW6/wOkTN2nrQp//iiamco
	 J45Glob8YuJJh248GDDrl9TvvXrChdoD7QW45DlK+jNseB10iVb6OnmzEJ7xSGuzz9
	 MNqe9qt+Qb7aId7UG9ql6sLsx41tmjPUF2m9Gyb6H+0oKPeelgHh5uMD4f3yUA+N3s
	 pXJsbZj69JuOo6hD01OFutFh7AwX5KIzlGFK2VNDQL+Oya5JE+s6s+UNqy8JNSaPp3
	 fPz4UJpOsugVgQRAEXpxCWnwEi6NWKzIdnWUHVOV6XH4J7B38d6Z6oTtR/T8AdgX4d
	 rF7Vq6exNhoMw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 04/14] mm/memory_hotplug: simplify check_pfn_span()
Date: Tue, 17 Mar 2026 17:56:42 +0100
Message-ID: <20260317165652.99114-5-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317165652.99114-1-david@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B82710000D
X-Stat-Signature: o7pedb5w1736wm84ar4frsu9yquzcra6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773766638-586574
X-HE-Meta: U2FsdGVkX1+KBZkhwvokrYeCZ1oGfUUXOhAa02NqZq7FUR1nPaSd2AHGu9bZEpzo44ytIB1dnwWAtzBq/F9xQzu52btczZ1bB2w+FznKN0lf0RFnLHMHlZB1NmQtvrTiXi+OijY9ffO/tU3RF9FXo2pICu4N0HCyznct0DUiJZzd0EPnTILPVjnzKBzkW58nfXlqJNcBq5XfUvNvrLxrFf+22/n00nZAYwc7vqYyGhBPWChh9oQu8j+O7A+I0Y+sdckNMGRjnzYawYf3BxRfEIrvIWcBE5xgKgO3ned3s4kw6P6W1qp2PwUepCJ5g8QIxBkS5mABdzJfG84R699lCCR4N9R+SKIEG9nmrnzsvcQsLfUEqGky4dUxvIV0gPEfJyTbi3ROgQ0JBsz5YpZ/aUl8HUUy2gPI6dOxJBobaH0WVpfqjpYbFPrA/FE6oui8ENsAsXQi1/0xoDZieTwIJvyCdSCzQzQPFSz+QgiTRlvt96t1v15E3HYhbc0SxWi4ng8Qp582m0M/nBxu4WW1jM6ZAOStnbZkLYpxGkLCRFckBQL8/Xzv3WpFs1YfOJvqiaz1xPbndwe8u3XoHuePJHIIL2z8a5mJi+nQZ0yvw3PTFWDy2iXnCC6aCFzbakwLDlgdwXtOh0q3XSjjA7NRj0n0XVpg+YPBKcr0+7o3R3Ibnl/UxI2n5bijhh+Us0M74TSt3PKs0AzYlR2rJCXk4D25DlbUZ9Em+UvLi+bSI0Yf/JZhYCHisdobRKdzEprGX6G2EwuHcIpQGtdFi0osFzfkK/VwlByH8S5+LXNEYw7DDI7ALjeKuogCPCEt6Vdayj3h4zg4g+lKwiEg/Fh1hiw6UvNnsYXYPYCWDlQ6vkSZysfDHCN67v4rICQY4rA/fEu1qeP/ScJ4KayiyK6hLnLT7lZDsdZutfrEnQkAu3Xn8HDbcHRLHwjoffpXlGEOmZ8h38dlIU8xOK9tu3I
 2jRV+iOG
 OCfaQEkqWw1U5i/bhwMyArPh2W7ev/xIrt9DeRBUF3daqIBdtSga8hpBimslwz+KzfLkWOL4c3CE3q88Qysl8zkONWj+y6qVy90epd557pitcHFrdcSb+hhxyKEyU0A2bzIvDDN7C6MXyTqfq/yRJCY4BM7UHxWifLCN0vt3sepjSaNZy/fJFMWeR2oQ7CqGmyCUjOc1B4ddU2zaTotTWCN4j5seDScSrBjQzxxQKLqP5JM19ObrVJYwyGbEfsFoYGUG0qlDKduMoM4ULOT6+gm2wu64ZefxC/q2y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We now always have CONFIG_SPARSEMEM_VMEMMAP, so remove the dead code.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory_hotplug.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 3495d94587e7..70e620496cec 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -320,21 +320,13 @@ static void release_memory_resource(struct resource *res)
 static int check_pfn_span(unsigned long pfn, unsigned long nr_pages)
 {
 	/*
-	 * Disallow all operations smaller than a sub-section and only
-	 * allow operations smaller than a section for
-	 * SPARSEMEM_VMEMMAP. Note that check_hotplug_memory_range()
-	 * enforces a larger memory_block_size_bytes() granularity for
-	 * memory that will be marked online, so this check should only
-	 * fire for direct arch_{add,remove}_memory() users outside of
-	 * add_memory_resource().
+	 * Disallow all operations smaller than a sub-section.
+	 * Note that check_hotplug_memory_range() enforces a larger
+	 * memory_block_size_bytes() granularity for memory that will be marked
+	 * online, so this check should only fire for direct
+	 * arch_{add,remove}_memory() users outside of add_memory_resource().
 	 */
-	unsigned long min_align;
-
-	if (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP))
-		min_align = PAGES_PER_SUBSECTION;
-	else
-		min_align = PAGES_PER_SECTION;
-	if (!IS_ALIGNED(pfn | nr_pages, min_align))
+	if (!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION))
 		return -EINVAL;
 	return 0;
 }
-- 
2.43.0


