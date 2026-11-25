Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A7E8606A33D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BI6lcMAJ
Received: by kanga.kvack.org (Postfix)
	id 507D26B0A5B; Wed, 25 Nov 2026 10:49:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8486B0A5D; Wed, 25 Nov 2026 10:49:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6CB6B0A5E; Wed, 25 Nov 2026 10:49:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CC4A6B0A5B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:49:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9552FA8E39
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:49:22 +0000 (UTC)
X-FDA: 85474075764.14.46ED5D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id BE6E0C0003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:49:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BI6lcMAJ;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795621760;
	b=mEvELaXle8owaBF+V2JR31KMBhZwbl5uFxyqMtvFns0r4KeYoP7vK7dRAH4un2jXRaHCJ9
	/q+wrXJR/CEId4nLo5wPAG6eoUKU4kuOG8QjcGDxqm6h4qCEv5Xj6oK7Q6n9LQnDQPUlFn
	crwA8mjhPtBjQykC2hkSq/dXKWcdvCY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795621760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sDx1EaCG9SAUlKmWDDkbKWTFEgseySI6tJV6lu+7Y9c=;
	b=GjxNRZpsfeD5hpMYCZscJpId0JnwQ0USjfG5DUaUmc2TQOOlScO41p58LC1pqf12kjitBc
	knQrbeqxFdp4IFOEq8ruSupsrVaVUriYJqVibc0B+6qTCWZBVFjtzu/KwSS/t7zG6gYK/J
	nvCs9t15vDaDmfszfNLNNFMwT4sbY1U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BI6lcMAJ;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6286263306;
	Wed, 25 Nov 2026 15:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5671F000C4;
	Wed, 25 Nov 2026 15:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795621760;
	bh=sDx1EaCG9SAUlKmWDDkbKWTFEgseySI6tJV6lu+7Y9c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BI6lcMAJK+z4+jOwnc56rOoUO8jBakLT/7PUogwG0V3yAY2G/K7WTUfHorsUEh67z
	 zc5x8PIDs/F3kpWCgchS7hG6/ga92X0LA8WvdWZtLMjoaZm+3113BD6Q0xmg1S0PvU
	 K6IgP2eSUZgP3jkr3gI/aj23MjDnMBMD/UseiUdatf0/Whpf4jeI6e9foZCEmR/pNp
	 rwCEHivjxYBwXbl5dM+rliS13kQGjNFhoOk8iIU9rDzkddTe8GVrP5z6juqv9Gyw1m
	 Rv4GlQqG7dEjJXJW89ooZhubnQggEw5C/fLJDPcSjwvTrIWkiSNExGLpaG8XgUc0SS
	 oLTY3dKadO8xw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 25 Nov 2026 15:48:50 +0000
Subject: [PATCH v3 2/4] mm/memory: remove racy huge PMD assertion from
 walk_to_pmd()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-huge-pfnmap-fault-races-v3-2-bbc44489341b@kernel.org>
References: <20261125-huge-pfnmap-fault-races-v3-0-bbc44489341b@kernel.org>
In-Reply-To: <20261125-huge-pfnmap-fault-races-v3-0-bbc44489341b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 "Gregory Price (Meta)" <gourry@gourry.net>, 
 "T.J. Mercier" <tjmercier@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1972; i=ljs@kernel.org;
 h=from:subject:message-id; bh=R1bkWj/29/9Nl0sxgBuwqKyQpRPzTms8rnWDR6qzfWc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLZmTNr2OKuZ1QoZzslB1R/KXi5Kupy656bL5m+5rzaN
 Isj4a90RykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACbyX4PhD0/g/c8bDN6KbDg0
 r+0Yk4zh/IUdUx/3nd0qNmP2VHlrVgOGf2pXhNiFV61hONYidF9KzeF/aea1xb4bv4tGb/w8u/J
 iGwMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User:
X-Rspamd-Queue-Id: BE6E0C0003
X-Stat-Signature: iwkc5wdfc7zxmwgp56m1dhpb5ejkqk7x
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795621760-812518
X-HE-Meta: U2FsdGVkX195Ow99UeBdC3C2CCuz97w9kcAbITjXBSr8/EKdrbxGwEmibucaO+HD0QHDnT6hE95DQFyD8jvdiALlFM7Yodu/A5gdVqEuFbfcgSy05gWJK9R5Zhr4/AuPuoQBH50R4Fn4k22B0JZ+PyqEjSaoKQ2siCLtGOiHE9aGG2LWvRWO9XpFiUXlQv3lPFD5m28hrn9+8p/1zW90voXHiocNicT1Zf/YURLzMcElEct8l2PmF3ly2Tj7tmiEXQY3f5CExQB247tk1J0OYaxq9i4mlCHO8B65r81n5lLLrKS2JrSGaWMtPH7w3f0iMoDx8LyShXrxNqaVEzHtjr8A+lPkKT5dz5kZHvQFyYx6WfQR81+EXea3Mi/EjaHudWrmPAErIehqz+fk7rOeJEOOGUCA2veNf00ht5/wnEf709/TfZeiHe88u4GNdpCz6NSpzq54dfo7EUvtK3UvwYiLHT7h/NNk77wkIzzIiC6dTFexEkhBIpTL5kf/Jg8eSAwo+kQ0DBUaBPDoHEVTzSj6hRLf/Akoj24Jhv5GEp8IELZ9HdeBUQAtupJKHNzRlVq/hMJxA4M/1Y6FDt1rdOTP4Ivmv3dohP8nVhNntIFaTo15BmdC006sIkEwh6vdrUreZS5icf42j283QLqAiuubMgU8vzBEtPzXNxONQqzOEkLn0/vZLGPxRV6HeEhsKkKp/+vOQ7v3Jln9HTobSzH6WRM9+58BXTke+FsDPc3MOl+ijDVN6o6yU42bJmcJNf9PgqFGpm0FSuCxs4jcQGmTWFtQ103sJZqHom4WKoOV5XFkgmh/oVWWHw7bN6O802ImFgvD7Wnceps68/BIGTijIBAk+nj1avjdfyUXhSxFKJF+XqTSQJipxDBZFQl7565paxHlBmnaYUB11ZGBNB4wmohs5wtDf5SU43Usmhalh/Us2Iey8eB1RMbm7MqqtVM+BxYpA6cu34t5Wq3
 YruYEYnC
 9sDrKg92T7MmsLpqPfOttEXPnIhibnFkpbxkpJUgXuf9nkAN6ls+rcL/lJkkVmyd3oPYylNz9CxYEFloT7sK57BDtbfC+rkj1cEx63GF5YXInxXuG/+QgMx7SYwXI6XLUzFFlttjslT1aje/KcoP4dcqP/s4DAk+mkH4+M6Dr6+A4Pd9X2EUoZYrNvT3/B+Rt/1UPwJ9YZK//v0D0jpwgS43806JprJy5xGWgkjffvvIMJGt3mWYvqz5tJikGUr0vBzMvh/ex4/aabX2X9EwUVQJbKb/jRReiHExIeRJnRMLQMd1B+DU58W87OSElonjHmvy2ohS5ZH3vN/A+m8zNYNvzQbDS16BqMr/6CHiAUzzl7E7uE9Y+Sj7TBT6o7Xd9ehsxmezyAySmH9d80K3UudIFDiFlvI7r1wMkn6HAy42oA48F2umLJNNPjbGFPJ7wvqzWrlBQr4BsV6eh+pMJXBIlVxSycP6XpWFs/nQX1bZKlO257mdPb4Dv6/eDIHwZuMlE8o8lG0N4L30U1A5URVGGXk62WK//KsfWfjwpYpI9ZXtbkxVRYLcKSR7NON+MXaHtPHj0F+WBAgpPT52DvHBDEhs3qUNXxFQWlIOaWOAL7q4zWaELzSbw8U46S0mD0eOD2t0HLM/KBNjxwQjOUP2pTA5+5mB/urI3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Eliav Farber <farbere@amazon.com>

walk_to_pmd() asserts that the PMD entry it returns is not huge, but does
so without holding the PMD lock, so the assertion is only valid if nothing
can concurrently install a huge PMD entry in the range.

This is not the case for a VMA whose driver implements both ->fault and
->huge_fault and which invokes vmf_insert_pfn() from the former.

The existence of prctl(PR_SET_THP_DISABLE) is problematic here, as it only
takes the mmap write lock and faults taken under the VMA lock are
unaffected by this.

This can result in two concurrent threads faulting the same thing
disagreeing as to whether to attempt a huge fault and thus ->fault and
->huge_fault running at the same time and triggering this assertion.

So just remove the assert.

Target the commit which introduced the first driver able to do this for the
fix - vfio-pci. DAX also mixes fault orders within a VMA, but serialises
them using its own mapping entry lock.

Link: https://lore.kernel.org/all/20261112051440.16140-2-farbere@amazon.com/
Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
Cc: stable@vger.kernel.org
Signed-off-by: Eliav Farber <farbere@amazon.com>
[ ljs: rewrote commit message ]
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 67ee25215ca5..20b818bcdfbc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2384,7 +2384,6 @@ static int walk_to_pmd(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
 	if (!pmd)
 		return -ENOMEM;
 
-	VM_BUG_ON(pmd_trans_huge(*pmd));
 	*pmdp = pmd;
 	return 0;
 }

-- 
2.56.1


