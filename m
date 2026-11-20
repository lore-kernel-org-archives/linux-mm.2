Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E3E606B9B9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l2IjaHxA
Received: by kanga.kvack.org (Postfix)
	id 40AA86B05F0; Fri, 20 Nov 2026 13:11:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3944D6B05F1; Fri, 20 Nov 2026 13:11:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235456B05F2; Fri, 20 Nov 2026 13:11:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDB2A6B05F0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D137A0132
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:20 +0000 (UTC)
X-FDA: 85456289520.03.3CFB383
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6C52BC000F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l2IjaHxA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198278;
	b=Vqs0B8q6lvZld2ELubHxSGy8WlQGYI/LFO2DKapAyQeIzNdwUzFFkMJDXI5rrxYb0vxm+4
	7f5JQ0pdz0ExxcA7H+oqpB8+JCpEG+w2xYHrHF/NbGHjnJBqJNN8OTVshCeoPompcODHHT
	O6w1oiZ8BRyVwa4uNVn5TP3qvBHCdoE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198278;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ZIvh780Er1fFAiiG/5dzmAinodD1fFI24Yf0GcsOag=;
	b=c4on6j9fKqajiCwrVvE7mzhOX37w/rzXty9MVpBin4GfZt5KrhlKykM7hyWZOBpzPbiaGe
	4eCjcUYCQsFKAqVX5ofkcOWdOtIRsL7ZboNL4I6GBt0C5d6uY84ISMLa6Syb5XKSiDJaf1
	+ase/TQf2WzqnHkqrH3gDfQ/VImLm84=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l2IjaHxA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B83C24589B;
	Fri, 20 Nov 2026 18:11:17 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198277;
	b=ufmuwlpr1O0DkhnmAe2r6Uyu6mTUetM0RD4UbU8uGAm557cZWI8I60qFiFFPBQqZLe/R
	 jqD6kqW8Gdas/c+bDd0dMooPdDKOjZR5QYsjy7sHnMIsvM3MbgKkpJ9lk7TkGJSEYtEjy
	 2MzQCdt34uZB2ko9zVA/pL7X2kTkpWvlfK252rmNRnanOqV5Daw8s6WXu7IF4p5GWhAIq
	 ak4/YDYNnbRPkNkX+Lw3kcGO1/4L5Kci0znFMhVkdpWaIL0xzjbn9BTHFzO4Vxl3scgcF
	 HsMR8dwmYGVGSwEMu83WlkD4HqKm1W+WhW6PxAHo80wV4ysFgiqvaHDL3IJgWN58WQA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198277;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=6ZIvh780Er1fFAiiG/5dzmAinodD1fFI24Yf0GcsOag=;
	b=C4RJJCycqwPxVJF2fFLnrpvyc+oDmfosEQG7tlE85NWL6Vb7c2ZIvGrjm+9XUkCnGjrd
	 fERn45wH2ikuXo9z4P0VYaaqxF2raoh4LN9Tsy5xFrZCdfUeBsY3vdEd0Ka3VdDDOg51B
	 rJ3QLnPp8sK4P8Od1knSBnoEGZ34Q8RYlsJqIuA1kR7KZTEGpIb6+qLnNsc/CQ3QyQuSj
	 vftg2JgznPYos5HfnEGFP0sCBHm0I0UNZIymq8dkiYK3FiyIw8yR1gJIfelb5LxNHQYE6
	 Yf3TwbcWLTTGvLMIaPWADz6ddlwobqfu1DJUyDyPJCv6MUmrdRHkKphv4bc+7ABXqSg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4F6B41F00ACF;
	Fri, 20 Nov 2026 18:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198277;
	bh=6ZIvh780Er1fFAiiG/5dzmAinodD1fFI24Yf0GcsOag=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=l2IjaHxADxgRTSqpJuThjy3mx9jyEq6gZT5ykcniVqjA3/29ygGaoqZQeq2T054dN
	 dMJYAw/CIvA2PcMc2hiwmbz6PX5kIGMdoFJEZZCXqmHvauHJDCBw1Q1/89FQ9Ca9hB
	 kE+IrSN/FHdGdi4HYo6mWnnvVK4ZSSA0cc3EBCRiaVpFDdtqCwwMHPEvWYyUFMJxS9
	 DOsrJ2ZfqOejDkeEbASM6DixT98jr3IY6C2PuCfptwaD/WqScNZVLcuhIxtRPnbibz
	 JkK3cQlcDSxp5V+NVztDOCNcXCDtSOx2qhB6cPsd0WeR8OLDiGplV4yPXWobO58PHW
	 oAYn7crYsEL6w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D38034B981;
	Fri, 20 Nov 2026 18:09:22 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:39 -0500
Subject: [PATCH 48/60] mm/madvise: restrict reclaim advice to
 reclaim-capable memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-48-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=2519;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=/7n8Y7BJF+n1w6zg34qEl4WSAk5zs5lFqc/saob4yDc=;
 b=x5v1UZjZD7NavKPzy3gZFJ4vk2PBUASf1WJMKcO8I8rh0UDg9n2rwb6VVYJJEjpdeaXC+C4/N
 8FX/kkSJcmcBGbIA1sklk5dsK0Xt7WZPXHmG0HW7LdpXEcbdkmZLRkY
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6C52BC000F
X-Stat-Signature: hg6y6hdpr1r8fmu791tzbehdjt6j34ef
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795198278-24300
X-HE-Meta: U2FsdGVkX1/kF4uviX6VoCQPkNuCdx14H4PZZOjZB0gUXrN0zVK3JLNZLVrbVohS4esK0KlUNyly6M8bZrofWpRMkw+DeP2XeKziIC+HkvWfYg8jAZCJUG0czMAX0apDq6nLX0nowbfXFtsz+rznd6T3GSyD+XGw1zHbWBYvPtYqWvrAAjxNXTW23etnvwn5wki1iABT7P+tGU4D5dI8I9ScR68ex8mfBuj2SgP9h3raEz9m5Ut+k9j9+bMkbYPfHr0OdHtwoyDEiKiPIfZYhPGmlAJcyW+d7EqMc73N+V89kKUrSGUpBnZeDJtu+FF/5iygFSRFhDZJCsJ7bBCagAZcO3SvyqNGh7ECh6SZrKb+h+hr7tNaYub4NC0sX3C6J+4bpfPr2/k948dxXznKJz5sKNZ3pZ4jzXiYd8y6BnpucSzBviWKDiZL1JVei45TZ8QsGbkHBhDOj7hPB5B4WH4bw03eHZtG8lx80FpQGgljEgO813s8Td/sVHIW4/tJOXSadducnAf7a/yoO8K+tkWCrqGAQB029VArRpRiF2VCYHWsCc9GuYrJwHuDSo1gAgSpJdNNdM3rTes40SrngBStZ7sheY3MH62Vyilnwzou9osX9VMMPs1vjRxgjGuj8vZTCNOl7SrrBIazxBdjCZ5xfB/6Zvn69JruE8TgBL8g/p2jOjFZ6T0HpqMH9fEduUORonHf+QELZsKYpESWp77fJo2S3bbs9daumon/BlncG91I/dj3Is8/FL8UzaVmX5lqYoHh7VdUvlPI2kg7S4wgwcZI6k6SvDT4FIBxkBA4RjV0XY5HECCw7AgjIfcH73BbbjwG9sgbRLWx/zeRjajjmkg7J27qxgC277Ku8FvEji6Y3eckVSpZ3cA3BePFPmtkIRmJfoCgXnL9YFcWkpq9VOqNhFbygfWUKt8C39Q1a9VaL3leYzjyMppEt/LCYAn6pFrgZIYDM0kvbGT
 Ta7eYqKz
 wVyjzWoUlEAZKIIX/VeBcOotzVoNo0Kej4CDukdjXXhIbF0jfhCdWWc7obcKo1YX39ZhvyKLx9GpE2PcK3C6gPsikOIJ1MwHWZmfTc9E8vMSBkV7Dfd0EIAgbS0jo7UTrlZqqntpVVxS493KhSLNtwfDvyDYy5ZDdPfvhvIubeTMuOs/3oOTTjPUFQQH0n45Md9wiLKJmCTkM/ctAJHjsL6TiTLFhp2f6V588ya+kgi9ObfjE96riHi2Hxs8oyDBRRNLoPD5UrsaZXOp/NKLhAhwdc0q+03NIEdkqW1YvOQy29tqA70QKi2rpBfe53/Bj31AoOFvWyiuCRbl+OrURttww/oN60AeYyNz/LI87No8GkPXLTdrjOXCLc3m6w3nY5TmyXcWiUpRuzV927Z4w2jyRGZVBZT/JFpvvIMKuyQ48T1YwhGLS10nv8K2RtCptytqLqyiRBzxHtXaXED5V34btY3bleyz/PhrjhRBmizqfequ1d265CBCOo3JPxs01G6NGoqmsvuVWDAIO/4pDfjCXlrmh9qydL01XsH7dL+3lRzM69JUl2+CBwINccg3mVDWZjA+uwXcYxf2R9K/5AK+tL38ssGdUjOzwOnHLPFxqzJXdx46/8LDLNrGFj0tHP2QsU23s9HeEQdqvp2SHvuhLn5F09KiNEdCoTIwLihWYEA8Ben2SdYKGOLXl24MPQ6qPwtQH1yJZ4zOB8sj3R0KCoYh1STs4O6fa3k9fNNWZ0KaC5khNVtMs0Z6c2D4NN3ERCcyRf3KXMWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

MADV_COLD, MADV_PAGEOUT and MADV_FREE reclaim or age folios directly,
bypassing the node filter reclaim uses, so they act only on common
memory.

Add folio_allows_reclaim(), which requires the folio's node to permit
reclaim, and use it instead for those advices, including their
huge-page paths.

No behavior change to common nodes.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/huge_memory.c | 2 +-
 mm/internal.h    | 7 +++++++
 mm/madvise.c     | 6 +++---
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index cae28513b121..00c72b91ed30 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2452,7 +2452,7 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	folio = pmd_folio(orig_pmd);
 
-	if (!folio_is_common_memory(folio))
+	if (!folio_allows_reclaim(folio))
 		goto out;
 
 	/*
diff --git a/mm/internal.h b/mm/internal.h
index 9c162ded5305..fa1ae221564e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -80,6 +80,13 @@ static inline bool page_is_common_memory(struct page *page)
 	return folio_is_common_memory(page_folio(page));
 }
 
+/* May reclaim act on this folio's memory? */
+static inline bool folio_allows_reclaim(struct folio *folio)
+{
+	return !folio_is_zone_device(folio) &&
+	       node_state(folio_nid(folio), N_MEMORY_RECLAIM);
+}
+
 /* mm/vmscan.c */
 unsigned long zone_reclaimable_pages(struct zone *zone);
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
diff --git a/mm/madvise.c b/mm/madvise.c
index 0f1648526f15..a5fa3b948a20 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -404,7 +404,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		if (!folio)
 			goto huge_unlock;
 
-		if (!folio_is_common_memory(folio))
+		if (!folio_allows_reclaim(folio))
 			goto huge_unlock;
 
 		/* Do not interfere with other mappings of this folio */
@@ -485,7 +485,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			continue;
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || !folio_is_common_memory(folio))
+		if (!folio || !folio_allows_reclaim(folio))
 			continue;
 
 		/*
@@ -715,7 +715,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		}
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || !folio_is_common_memory(folio))
+		if (!folio || !folio_allows_reclaim(folio))
 			continue;
 
 		/*

-- 
2.56.1



