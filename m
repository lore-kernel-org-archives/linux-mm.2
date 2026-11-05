Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA9E606D821
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ed6ednr4
Received: by kanga.kvack.org (Postfix)
	id 0E6D76B05B7; Thu,  5 Nov 2026 08:23:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0976D6B05B9; Thu,  5 Nov 2026 08:23:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEFB66B05BC; Thu,  5 Nov 2026 08:23:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D17866B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:23:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A94D1409CF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:23:04 +0000 (UTC)
X-FDA: 85401131088.11.E480EAB
Received: from mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
	by imf03.hostedemail.com (Postfix) with ESMTP id 236D920002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:23:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ed6ednr4;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.3 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOupAXTYNfoednpq0XsVSpZ+gvJVRJ03mA/cqdjPBdI=;
	b=MKmGfR/c7XRiGRmi7X6i68YmmigWw/lPEVzCYZ5K2DOQmuaZ5mVjYspznEn2lhApxqko2E
	d+0kB/g92Tzp8oBr1UWB6+Z72s4I0kAQl0XWJ+yjWqYgNBZ+fPK5K33rnRg5q5DKw8xs3q
	CkyTzvFUoLPGcSzrV+gGjDBBChdk9u0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884982;
	b=6WZTJEo/QfbsXG2JthNxEgXp4fzymbXxTZChNvq9VGry+rO6dFb6m46fic2oZ94FQprPBS
	SLOkI6KXTSi2oPDx2T8is/poFKuPWFzqe1uKw4RG3Kk9/eHsogxsgpZYBkF6ePVgNSeyHW
	a4KzW715Q1zWpYVQXT6uhIFgCcNsN94=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ed6ednr4;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.3 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gedQzs9cofqnO/3Mo6G1fafF6KlRIBhBesFXSxuBcbg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793884981; v=1; x=1794489781;
 b=Ed6ednr4nfdPMGN/KpjaFwJKHYmNrMTRbel0Q89Dd3UnLBKbi2v/fBNZYYPG0K4j1ZzG56pr
 lV9/Op4phvY9Alu9pePz3ifHmgyJMyf65D4REoemzVAV+2QjlukOVgwangNmmYHPuV5QoEw//2M
 2NwL9zNJpTliTJtF0HtMDNM8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cca60b9dfeddce6e;
	Thu, 05 Nov 2026 13:23:00 +0000
X-Mizu-Trace-ID: cca60b9dfeddce6e
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH 2/3] mm/mglru: skip the flags cmpxchg when nothing changes
Date: Thu,  5 Nov 2026 21:22:19 +0800
Message-Id: <20261105132220.2233677-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261105132220.2233677-1-ridong.chen@linux.dev>
References: <20261105132220.2233677-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 1prj79rtmfcpqy5betzpsoabri73t8wy
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 236D920002
X-Rspam-User: 
X-HE-Tag: 1793884981-378831
X-HE-Meta: U2FsdGVkX18Alsd4iWQXEbdsX/n5Cj+ojKOotO2l5AVWe05QCO/vnTtK/wbGuv9Tymj+1Ue/Pd+xfjI+b7M+UDu5KuPU0xzJbgZXjtYpZuUvlR75HkwiHgXnee5XHpVOOegGBSle7qSgotZJ9V6wTOovWqg8IWZF9rkYafi6pgas1IRy7fmbA+XeOt6W7fzpQURKd8yPHMnhntLyr6FfYA42bYDeoPfxNRrhHoZnNKll3fIzXbJh5RO4LHvZMdsuZ9hduUMDK7nSBDVnHVMGjOhWbr5j1u4h2dN+BOZkQD0nlZdEVz62KjX4KFMkGllQpybhgzR83DS3iYPx76AIaqqeI9s5o5zhMBqRj618zCA7ADqaJNXZRHqFjFc15l+wWATraPHCHCbKzNEtDSS+ooDSutY4GPGh3K8ny4D8BguobNJioMjZuGGtHoJsWlnN6bBsu6LDu7rAFcX+BsvmNdid51uujiCaZsdTbtSi5rmw1Mdkcft5E+BCPLbaUPLJysUJh9zsXm5o7hb6cq0pP6SqAQob04qfPPtARaESn/a3pk4but1CK4QmODnoolfFKEqMCcIcrEJgIrugcf8Yk99S3BeSY4np0SDtd8FnvXebVvNb1VviEuZaggaAw4R5m9tpGwgEKtePIXk/n1icPoPV0xbznrjO2YmGPo6IYBBfWDCRw5s0fOMplOBLtsP6Yt6GJrnKdFo4y+VMSHY5Ff2MNGgSrh5TAwc5aR9fWeui0qv1Omd4o7X0aSOS/q2TLvH1amr+mumEoxxiULEDdezQDVQZrF6j3KOY5tsmy3f1FlQASO//n/7WCqVAiXC5WUX/ceHa5LnYNEFGro1atO5LsCCuHt8+SM/H1K6L0lMEb01hWrdP8QsNHmTrLZREwueKf+wzAM2jSQc4qebpOzwCeV9x5bP8IPl5qQFGX8x0eAYV1TIdV0Vm0VdsFNPeWo1V50ONKMnuUf5xacp
 7DL6p+nE
 g7jqUnou+NKqPsVT8cdEB704keE5FjKYFPKkL2Y+444QttcJMu7XUv2rugglMAoWGRnw1VfLrm+0/zSxiq64GC94aJ3d5kot7bDpOXQw9Sw/a0TFIwvPXBZiYb3QpUiKS5jUnPqEad6K4V7VZyx2+e36Q4rG4mPk/Uqr5tnPbVCyGvkLLHXOqbBdRxzbRnA5Unw+HJZfavtyOnoWDbUeqZn7tu3Wd1EQuRRQ443sD8JewF1QhZnwq8ZiCYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

folio_update_gen() and folio_set_lru_refs() always end with a
try_cmpxchg() on folio->flags, even when the new value equals the old
one. The locked instruction still takes the struct page cacheline in
exclusive state.

That is common in practice: a folio mapped by many processes is visited
once per mm during a page table walk, and after the first visit it is
already in the youngest generation with refs cleared and PG_workingset
set. isolate_folio() and the eviction paths also call
folio_set_lru_refs(folio, 0) on folios whose refs are already zero.

Break out of the loop when the flags would not change. The result is
the same as a successful no-op cmpxchg. The only difference is that the
full barrier implied by the locked instruction is gone on that path.
No caller relies on it: the eviction and isolation callers run under
the LRU lock, and the others (page table walks, folio_mark_accessed(),
lru_gen_clear_refs()) only care about the resulting flags value, which
is already in place. Note that lru_gen_inc_refs() already returns
without any atomic when refs is at LRU_REFS_MAX and the folio is in
the workingset.

Tested on an i7-13700HX with turbo disabled and the performance
governor. N processes map the same 2GiB tmpfs file (huge=never) and
read every page, then one aging pass is triggered on their memcg
through /sys/kernel/debug/lru_gen ("+ <memcg_id> 0 <max_seq> 200 1").
Time per aging pass in ms, median of 5 runs of 10 passes each, averaged
over 2 boots of each kernel:

  processes    base   patched
          1    32.9      31.7   -3.5%
          8   195.1     160.2  -17.9%
         32   755.8     592.2  -21.7%
         64  1597.2    1260.6  -21.1%

With one process, every visit changes the generation, so there is
nothing to skip. Before the patch, perf annotate attributes 53-58% of
the walk_update_folio() samples to the lock cmpxchg in the inlined
folio_update_gen() in this test.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/mm_inline.h | 2 ++
 mm/vmscan.c               | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index b3d85fe91385..4ba9079f4dc8 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -244,6 +244,8 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
 	do {
 		new_flags = old_flags;
 		lru_set_refs_flags(&new_flags, refs);
+		if (new_flags == old_flags)
+			break;
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 50c352e9ffef..3fa76715382d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3398,6 +3398,8 @@ static int folio_update_gen(struct folio *folio, int new_gen, int *type,
 		lru_set_gen_flags(&new_flags, new_gen);
 		lru_set_refs_flags(&new_flags, 0);
 		new_flags |= BIT(PG_workingset);
+		if (new_flags == old_flags)
+			break;
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
 	*type = folio_flags_is_file_lru(&old_flags);
-- 
2.34.1


