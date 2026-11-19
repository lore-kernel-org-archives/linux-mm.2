Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB9F606A338
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 09:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=fNpIs9MS
Received: by kanga.kvack.org (Postfix)
	id DE73D6B05FC; Thu, 19 Nov 2026 04:50:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98696B05FD; Thu, 19 Nov 2026 04:50:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60136B05FE; Thu, 19 Nov 2026 04:50:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A0A256B05FC
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:50:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 455CCA09A9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:50:03 +0000 (UTC)
X-FDA: 85451397486.25.DD366F4
Received: from mta1.migadu.com (out-224.mta1.migadu.com [95.215.58.224])
	by imf24.hostedemail.com (Postfix) with ESMTP id DE0E7180006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:50:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fNpIs9MS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.224 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795081801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uMV/YbC1T9wZCTexlk+7aUQd9lga1zoOzARqeGciJEo=;
	b=Rtv0YBHiewuEYgVOFIGi5t7W4XsFHwQKlEBE2ThNTCssikFdbg9aXrpk6jZULWVcucEBkI
	MQbdD3TcdfHwIg2GOtNLaN7e/SlbeEKR/ofs8yUeH51ahM9D6UlMCzVV7Zct/0Dkp5CWuX
	TZqtkAfaaq8MsfQuYRElo0wax3cH0iA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fNpIs9MS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.224 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795081801;
	b=HwEbj5J0WjRzMVmft6gQzeG7gj/UEctSSK7ugRdZqp2SU+ftvdCdOnoZUZQoKhQsRMsAYX
	RzlwLdX44EDom1wtX/X3sf1ZypzXX6jkmn0g5CkKbd5AntHQEFj/mJXx3VyzDsLLSpwiw+
	jQrBnBaeuE1JcY12vmgI3fRhsNUjPD8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zkskeSdhW3TcS/2san0Si9bwLAdnX8f9uTPSC2iFSPY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795081799; v=1; x=1795686599;
 b=fNpIs9MSy//LBNQGej4oODQkKsE1OiQfzd+WZhn+PTGJ3May0gdPLRqz8obK1HeKsJjno9/K
 ZYAx2OY9jXd/iMXHmarqUP4w6WALdRneZR8EiyVzeynEcu2d6T+nEY+ceobh1CfeMkwOdxSkNHQ
 XejDei0ltUFEvs2IHF4JVwYI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 38b48c34a8ee2f37;
	Thu, 19 Nov 2026 09:49:59 +0000
X-Mizu-Trace-ID: 38b48c34a8ee2f37
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Thu, 19 Nov 2026 17:49:45 +0800
Subject: [PATCH v2] mm/memfd: drop redundant hugetlb allocation mask
 narrowing
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-for-memfd-v2-1-59f2d8c9752d@kylinos.cn>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NQQ6CMBAAv0L2bA0L0hpP/sNwwHYrq9KaFomE9
 O9SvHqcZDKzQKTAFOFULBBo4sjerVDtCtB9524k2KwMVVlJRFTC+iAGGqwRhChVQ8aSbGD1X4E
 sf7bWpf1xfF/vpMccyEbPcfRh3mYTZu9fd0JRCtvJoz3UNSqk82N+svNxrx20KaUvcEYrRrUAA
 AA=
X-Change-ID: 20261117-for-memfd-e11675edfe65
To: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: hongfu.li@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795081791; l=3005;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=I6EXz3yTFi+5DiIhQ6bxj5zpp5g3cWn4Qhu2YkBihlA=;
 b=KvGioQFIbxMHLTERdkukEbgP2tq2kNvdz9SAcw7BzrXSwvd2RA1bjZJf0q3c/+4z9ayNU9w0v
 Is6mz8fNveNDR0DPgG7CEsfS9XgEk5wjLIfSfFYrfoiqsUrZzH6vR+o
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspamd-Queue-Id: DE0E7180006
X-Stat-Signature: tjy6f19ufr8egqejexc7sepnj95795jd
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795081800-36803
X-HE-Meta: U2FsdGVkX1+tddGup2TCYVZAZX6gBUO/p67cAb7a7FVVYWVJxv4/1qT2ST1WidoikrOTz5aGd5L7oNICDKCWPA8mCAVL/5NzH7l0bxK3nMGaMtvGQFqtFaoI5zKlzWLYjg5QpKe4AFtB/PEIWxQwbt8V628F+a3LVABNfGlTloZidWSKJIeedPAIY8s9OzvKVXX5N7hlVpOgL1lXN/fAuesNpCpSMzTEOU7y12aGypBH0UvZ0VKY9ggdziQma8E4/Jq2QAVR1tsW1O8bcHg0bIpg5hyO2d2Umz9QjCTIhzuj3bFMEbHjM4bTw4iNCXz75YsVs1Kjev8izcjF4pGWApEiCbwhb008iPrNsahCh130EcUhLq2rF7rTq4ZurvEM0KJYYcK8pbzDfxzRrQmvd5rUdkXwWkG0Osf3W4NuR4154mV2KjJ4+ky2lt8LoZqej82+4lO3neGDXT0sYkmQ4jSCiocs/Il2zwJ2oFDF2Vf1v9VBeXQy+qeZidNvcsv0TZUiJ9OczvKrs4JiUS4GurDBofGD+5qr+3vR2CA5a99GGy5f6m6ZHLgriUpR9j32zA8Oba379diDO/l471XF4QamqOfPF/lCNhk1lt4gW8/LUx3RKaR+H1+/TqbklXuYV0e5SeB9nu28mRD9e2yNhqxP1fSSAI1R8/q7kSsheJpdWmvVEFaLMM5W17YjMf0aaskDxfPyryilO5y5FhmQS17rOqb4aP39aX/xeeeoqxcSb6wbAe9u1FndnfTOIQeletxMIHls9UEuwteoIcM09zIVHWb5X2kUm3zKrvdehjd2ShXvSwRzRXu0nv+VsF/yeluB7tDhP1ZSQr3NJCocQp+Q0TIClLN9468J/dEVq2UqC7TVEinHfaFEoMgqK/yMUEpOKbIH+kzDE7rCb0qwnR/Y/iFR7/ll6CW4g04HbOmR+5WEt+xG4Jaajmzg0UEgzxiRXtg7qho0KEpjqgl
 k0KmG5fE
 YAPxU7hU48u9llEqm2xacCdKtBlvUrJZbhRuGmCIAnvQVDmZUbXegGnlSKp8xb+uetjSt2b/kdqb2sSF/3CGXbss3OX6GjIvXDS8ypY1kxy/LFptzjObzeLruXMl/sqzMV8M7sKkC4RXzYGmIzSNdntqPsNHA/JMVMQRJNrv4NSuaH7Mo3/onafm36yu+5RwdU7426YPBZqF0rU1+pb33TPvmTK1jv40rVDQCv1P0zDY1a8kVENRmGqDgcyPteYpzRdSwbG74ADGmLjJZG6AuMfaU2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hongfu Li <lihongfu@kylinos.cn>

memfd_alloc_folio() derives its allocation mask from htlb_alloc_mask()
and then clears __GFP_HIGHMEM and __GFP_MOVABLE. This mask handling was
introduced by commit 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios()
for pinning memfd folios"), when the fallback path in
alloc_hugetlb_folio_nodemask() could still call
alloc_migrate_hugetlb_folio() and reach the buddy allocator, so the mask
decided the zone and migratetype of freshly allocated pages.

Since commit 26a8ea80929c ("mm/hugetlb: fix memfd_pin_folios
resv_huge_pages leak"), this call site uses alloc_hugetlb_folio_reserve(),
which only dequeues folios from the existing hugetlb pool and never falls
back to the buddy allocator. The mask therefore no longer decides where
any page comes from.

Long-term pinning safety no longer depends on the mask either:
memfd_pin_folios() obtains its folios (dequeued from the pool, or freshly
allocated) under memalloc_pin_save(), so PF_MEMALLOC_PIN makes
dequeue_hugetlb_folio_node_exact() skip any folio that fails
folio_is_longterm_pinnable(), and current_gfp_context() already clears
__GFP_MOVABLE from any page allocator request made under PF_MEMALLOC_PIN.

Clearing __GFP_HIGHMEM was a lowmem constraint for these folios, which
were meant to be accessed by a DMA driver. It is not required any more:
the users of memfd_pin_folios() work on pages and scatterlists, which
support highmem, as does the shmem path with its default
GFP_HIGHUSER_MOVABLE mask.

Drop the narrowing, which has had no effect since 26a8ea80929c.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
Changes in v2:
- Drop patch 2.
- Remove the now stale comment about the zone and migration constraints
  in patch 1.
- Update the commit message to explain why __GFP_HIGHMEM can be removed
  in patch 1.
- Link to v1: https://patch.msgid.link/20261117-for-memfd-v1-0-fa68f433171e@kylinos.cn
---
 mm/memfd.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/mm/memfd.c b/mm/memfd.c
index 0e3ff3eebfa8..4c359d0fa923 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -72,12 +72,6 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 	gfp_t gfp_mask;
 
 	if (is_file_hugepages(memfd)) {
-		/*
-		 * The folio would most likely be accessed by a DMA driver,
-		 * therefore, we have zone memory constraints where we can
-		 * alloc from. Also, the folio will be pinned for an indefinite
-		 * amount of time, so it is not expected to be migrated away.
-		 */
 		struct inode *inode = file_inode(memfd);
 		struct hstate *h = hstate_file(memfd);
 		int err = -ENOMEM;
@@ -85,7 +79,6 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		u32 hash;
 
 		gfp_mask = htlb_alloc_mask(h);
-		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
 		idx >>= huge_page_order(h);
 
 		/*

---
base-commit: 0bce4c3c7589a80b09a4f21fcb41811cca5153a1
change-id: 20261117-for-memfd-e11675edfe65

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


