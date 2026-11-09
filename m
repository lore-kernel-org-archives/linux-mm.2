Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6000F606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NFDf4TDr
Received: by kanga.kvack.org (Postfix)
	id 80BAB6B05B1; Sun,  8 Nov 2026 21:16:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794FD6B05B2; Sun,  8 Nov 2026 21:16:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CC46B05B3; Sun,  8 Nov 2026 21:16:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44AD76B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:16:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C91DD1A055B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:16:41 +0000 (UTC)
X-FDA: 85413967002.23.4439A40
Received: from mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id D14A280003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:16:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NFDf4TDr;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.201 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794190600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RweQvyw4NIgsuj4dNi7nK06pAit76GUtp9g8kGTqMg4=;
	b=bnNSsT3EJ4B0+ZLz+SzKBvBxL/L3/PBAoFl2yhxD8xQ8to2QBbbPhmRftPPJHLB7glwUuk
	tzzWzfvp5S/KtD3W45vJFlJklfHfABuMweRBqAcH3RN4PLfHAl+lofBsl7KiXIQTNC8y9l
	dGak72xnNUby82+CIipom3otIYXxcMk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794190600;
	b=CJiPSKAraQq7Rj3e65mCFp5KP5IlUocaeicYP1h9nOgh6USswbE6zoGW8jI2tkiL5iJsQ7
	HPYgInrsabbecapS4NiWiFryic1mXv2gt4ZlsZathMLEV5SIn6OdK9qQogPum7kDiToNFs
	KkB5RAM/YeWWYqW+JyELwHOTGzOY6Dc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NFDf4TDr;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.201 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0vqFp7/7WWiwnx+Zs/qlGOXEjprolacOHKPupS8KY24=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794190597; v=1; x=1794795397;
 b=NFDf4TDrErNLl4AlkmuT4JnT5cGbRlHkE7spyQDd057yfU25J2+yZEjD/pm9Q9Re9XIoGFJ7
 /dhV8eQb6xW4bTlmN/pH0jzJXtYuPNcQ/Yq+uvEM3TWG+1SZ+g/8h5GDLtpTIkAl28LRRZ9v7u/
 1fo5dm8vfWbISM5pXq+nR9+8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 3ba9fe655f2ef269;
	Mon, 09 Nov 2026 02:16:36 +0000
X-Mizu-Trace-ID: 3ba9fe655f2ef269
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Yu Zhao <yuzhao@google.com>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v3] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
Date: Mon,  9 Nov 2026 10:16:11 +0800
Message-ID: <20261109021611.22247-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D14A280003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: iz179ekx357r51gu7smb9np9jfpk5kt8
X-Rspam-User: 
X-HE-Tag: 1794190599-563761
X-HE-Meta: U2FsdGVkX18u63x0JZ+tf0/913n5hhH4A7jgYrASCfONJBEhn0L3fIxTQdCIn3zf0Ovj8OrQLB82KsKaqTdJy4kl9gtf8rm7A8e+iH2Ax29UEevX+Lbd3Vh36jOwHOlZ6f3bKinNaSnnDhg68tStzBKGSyXOCdQeOdP6T3GgttTQVkolNoMAdTdiuprZ1edd99QnqlV+/TBvyDaqVsz+X7YcDT/ldEAT/TWjt41lqcjBaFwNjsNvLRT1j9GPxpRpGMPUdQQuNptuK1KQ0N7+81kKKBE7CKV9M8foPiTshICP4Jto2o46x/eOxN/2/URWyED2/fpE/4q20/w2NwOM0LLZ581k4+yhSrDvypX+58J/NPW3Z3FCOYydUr8VLY4P9IKWKkjHGJ9ZcyT4IAssVebuOi2S/VyrPy8k/rokQvby8o1/5rj6hJQgrsCr6lfgwBLpZDBmY846aiI3Meusbwlqx7Fk7xzi/DRBPjBbNDX5VOfIPe+TajsUVMqGbweG7AtRaPXan3Qqm+b8TLA6L6jY7ou7RceLlNoq4RuRqnWC0kE/g/UdAPveH4F2yrpk/tebVqrpsREXG/lowSainPIDlJB/LAjOebFXRgCVN8Nsf8rxypbt9HjpWLY5NZ6lHcjvxHjnh9ek6WJTK2W5zuPdBSCsYZHfCL+qB1yH9GJPZKsIu4Rn76EDi+JYpmaHsFRmE5HAXAUhkuuQyc7V+srLhB81wOm8LJfPCWQqHD/yBT0Y5dOOYIHJZMl0I8M/Y3uedfWO68LUlFdPSUGDe7ijyQi0PI3mA/i6a/I3mDbjMGvcjcj1cURzXcUMVtQbxaIRjWrr52TId2XqEb4GxpJ/AZBAFmElA0zDqXq2ZxV1JXG2cMsALSjZN5zR7octcOB1pmwyn4iGAkJ0L0ekjB6su3iiFdrpvHyLHFDKFF3dhS/27vx9hu7KZCv76M6D541M22bEPtczd9OS92Z
 RW7D6Rzj
 8JNeM5uNr1wFRDhhg+BgEf5N+ibDkHLf7gPu1XnhejbJmd3VCrwuwEcoawys7uH9ruICaQC0BHeOYUQFII0Np3psxJJDjFFsMlaTRtRMdZln185JVZ8dNK07N4z1oB1Dut4MI6gyXKjsOTtkxIi6nuS5Q6VaWHD5DI9GdijXFF1XD5iAB6PccR30VyGQAuaWdRj47nNbdhNRex/4dJOIXAEKYRzvR1WEoh79dJt0m1vLH7VSUoWk6ln/pf4nDRCCRX9X/SDpz4L7KhtVp/WcQc25YTBndHVT0oIiCZpgGbjZ4joA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

lru_lazyfree() calls lru_gen_clear_refs() after lruvec_del_folio(), but
lru_gen_del_folio() has already cleared LRU_GEN_MASK, so folio_lru_gen()
returns -1 and lru_gen_clear_refs() exits at its "gen < 0" check without
clearing the refs or PG_workingset.

A MADV_FREE folio therefore keeps the state it had before madvise(2),
even though madvise_free_pte_range() has already cleared the accessed and
dirty bits of its PTEs.  lru_gen_folio_seq() places it one generation
younger, and PG_workingset puts it in the last tier, so sort_folio()
promotes and protects it instead of evicting it and charges it to
lrugen->protected[], which read_ctrl_pos() uses to balance anon against
file reclaim.  __folio_inc_gen() clears the refs but not PG_workingset,
so this repeats every time the folio reaches the oldest generation.  If
the folio is redirtied first, ttu_anon_lazyfree_folio() keeps it and
lru_gen_eviction() packs the stale state into the shadow entry, so a
later refault is promoted to the youngest generation.

Call lru_gen_clear_refs() while the folio is still on the generation
list, as deactivate_file_folio() and folio_deactivate() already do.  Its
return value only says whether the folio is in the oldest generation,
which lru_lazyfree() does not need because it re-adds the folio below.
Keep folio_clear_referenced() unconditional: the classic LRU needs it,
and it also covers the folios that lru_gen_clear_refs() skips.

Fixes: cc8ec7be78ff ("mm/mglru: optimize deactivation")
Cc: stable@vger.kernel.org
Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Barry Song <baohua@kernel.org>
---
Changelog:
v3:
Add Cc: stable@vger.kernel.org and pick up Barry's Reviewed-by.
No code change compared to v2.
Per the thread discussion, the __lru_gen_clear_refs() refactor will be
sent as a separate cleanup after this fix lands.
v2:
Call lru_gen_clear_refs() before lruvec_del_folio() instead of
open-coding the flag clears; drop the lru_gen_enabled() branch and
the comment (Barry Song).

 mm/folio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 35e242b48870b..ea3adb6a89d75 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -597,12 +597,10 @@ static void lru_lazyfree(struct lruvec *lruvec, struct folio *folio)
 	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
 		return;
 
+	lru_gen_clear_refs(folio);
 	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
-	if (lru_gen_enabled())
-		lru_gen_clear_refs(folio);
-	else
-		folio_clear_referenced(folio);
+	folio_clear_referenced(folio);
 	/*
 	 * Lazyfree folios are clean anonymous folios.  They have
 	 * the swapbacked flag cleared, to distinguish them from normal
-- 
2.43.0


