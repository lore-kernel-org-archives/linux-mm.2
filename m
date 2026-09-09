Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D427BC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1D236B00A0; Wed,  9 Sep 2026 09:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCCC26B00A1; Wed,  9 Sep 2026 09:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0BBD6B00A2; Wed,  9 Sep 2026 09:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A43C06B00A0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:34:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47DDB401B8
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:34:42 +0000 (UTC)
X-FDA: 85194318804.29.C4D6E41
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7830B10000F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:34:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D/t+Mmy8";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960880;
	b=OyNXvex4cK/2Bkob8h+8s7B+NDUm80Kuqp5sjMRQkGgea2OAe44G4B6PXkkvQeRRHlq2nE
	jlDt2VQw8kggxNGmoeSGNZ3PQ04Gm29cj0PpG/VbmbvZeRUEGJ7X5k+hTVPLSQZAbL/EIL
	FCTEWBUklBo9lGF5NAI4jWw5HquoZCs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D/t+Mmy8";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2s0CTmVngAhgAN93TX2cVOhQyycESM96yPxbLZkJZRo=;
	b=wS+Gm4488hUWLpvIcwAQu/MC/XxJ9zoHtKkPkYaIk4K3P2a7PGoT2qEN56uGyCv5pvai2i
	Ukg4fUVsnfomRAzaT29JaY2s/FoQT7iOVN6Jdjjvy2FANg6n5CxqdS/D4MZXNaWaUPYojP
	/rWY64QxkehwoehuHCp+u+FqgnGHvic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E77C360211;
	Wed,  9 Sep 2026 13:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195531F00A3F;
	Wed,  9 Sep 2026 13:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960879;
	bh=2s0CTmVngAhgAN93TX2cVOhQyycESM96yPxbLZkJZRo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=D/t+Mmy8CiNwGSg0cWFN3moAPhAPZ9DE8Ga8Htq8mAEHixxrpYy6ZOeKpVtXYEOax
	 e9wfbI97DnTzPswN6LtpD2OvZ8VxEny1EOowANRDN5AMSj6mC3N41CTGuuBv1DZXJ1
	 JVZc0UTkSwh+tW379Q+rDff8oeohBos5A2I1nVxy6ij+mKswZVHoCx781LFZXjgL+a
	 UHxG3MCcZ2Z8UFWRl1xiTSiX+Vp085FS0BihF48mdBS97GEHOBaXk/u/QF3yylZRw9
	 g3gzJF+e65Q4kTli/43aExcpWz+ZFC8ug6DvycHV4ScHn8b1Rw2a585t676cE3EEFA
	 VfnKlPO7nTJtw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 09 Sep 2026 15:32:58 +0200
Subject: [PATCH 05/12] mm/sparse: cleanup sparse_init_one_section()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-b4-sparsemem_cleanups-v1-5-008fc8d579fe@kernel.org>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1155; i=david@kernel.org;
 h=from:subject:message-id; bh=Z7WiH4a0eM1yPjwlViyGW7AlVy9OebQyIjLQp6z8KDo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIWJhjsOtzKtPNH/67rxXoq8S2fL/FvXG3l3rXhBKN6m
 Ldyy9RzHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExESYfhr3h+9fyk4vchfZeC
 L+cHLDA1V7zKqjU799hSl9Cy00FOygz/43kCvjQdN7VIkCjau+5EcV2Nec/396s3NsR6u9t+bjL
 jAwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7830B10000F
X-Stat-Signature: eckr3knsxjdc9xxc5wzpzaqteqf1ghxr
X-HE-Tag: 1788960880-187970
X-HE-Meta: U2FsdGVkX19/f4Bp6hROEWYwt7PLL6I68T7u0/j+Vs9lrltonLNkd12znmCV7ei3MO2u0ucx3O3W5PCo/W+OI13grjZJZmIFo2fAo8DESldRnuzpXeG4F/9XYAELpJTDGN3cwq1o9SAOq4Puxl1KCLq4IbJVWfQYDFqlvHCBG1TSyQTOHVljiwyEv1Ss6Jk5oGjtGCVBBp2yHwpvg/fhgGhNYSD9qiC97z0e5oW1QyQtPID5nbmURm9we2TsWCQrM7/I/V1bwchqa7LqKxkLgaZx6etKPKg/LkQk6O9rq8lB95Ohnrx0KjLczMuREIPhwTGUFk94L7XWowJbRT8Vm01O6xlCwWMIw3O0E0lmwrorG6N9LPV9uuhxv4yNKA6Y78ClwXOtxA3rVETkM538Gmo+txpohNNnMbz2hwvRNkfPIwyjSx4FVbwrilEBNOAW4tOJtrl9j0H3CH81Fin8Kr/377nwkxMNsBCz6tGUIezuf3oO/WMTC+pZ5NC4mqw0JWh2NRvUKvxdO+NyYapJezuUx5tGoKRNKgDEc43rB9u/0I4is8fEf+t+LsI4S8iTzSET9AB/6f0rdYFcZuOYts4vBSdmZm/wx8kXImZK0Q4noDxSWK5l9AsHdXO9zE9bselJ1Waw4VPWtaFexHunhOSEKCUhdT41lspbQm5QsvxEMpnoxXeqqOly/s1olHV3ScnXJRLDXQ6T7FyMhn7D4PbBuFjKKNYtiK0Tl109OJrbtqDGhEktqjuMLa70z93FOZD6Bk14h0nGSFsykLfLKg24DJNj6CBJq0EsIZH/qdAXuA2K0aF8LFJNpXV91ClG52dzjyCYpaVry4QLoN+9KxYsuCrc4E5Tj5fYFeUAs7PiX38m6XabBa8zQH3XDQDtn8TxayMi6lslPK7dO7XzMDEcQufe2Nx4Jkw3lnKaIz07iBmq7h8aRacQFxRxxYLYx4KFVqokYMpxqiUTVxo
 snt50H3y
 rSBwNF/ciqnBZcw50YEHwOxsozKtx6ZSPUEtj6ZjG6JwfwZjzft4xCe2ingHSmIJwVFTUUivUmnaPz49FNli9FQ87kdduj6aydGHxu5Dkh3hwa0lzBOv1QEbGxsM2YpakXdV0F7SiO6R1OTUXaRb3FRltikLR1v7iyNu6eIQZohlYqTD+6LJZCcISFeh7llZQww82CWflwHNKSkds4GYJbtmL62cmK8G4TVDGBprxBGO1SylJUUgPi8S5KhWIx0dH4K3mRSOSQHByBSNup82O2Qot8qIkY2LMtWRl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's avoid the "pnum" terminology.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/sparse.h b/mm/sparse.h
index 049272aba84e5..744ae29002f5e 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -90,7 +90,7 @@ void sparse_sections_init(void);
 int sparse_index_init(unsigned long section_nr, int nid);
 
 static inline void sparse_init_one_section(struct mem_section *ms,
-		unsigned long pnum, struct page *mem_map,
+		unsigned long section_nr, struct page *mem_map,
 		struct mem_section_usage *usage, unsigned long flags)
 {
 	unsigned long coded_mem_map;
@@ -102,7 +102,7 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
 	 * from the page pointer to obtain the PFN.
 	 */
-	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
+	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(section_nr));
 	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;

-- 
2.43.0


