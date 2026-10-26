Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51C4F606A328
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 08:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RCN03E1x
Received: by kanga.kvack.org (Postfix)
	id D7ABE6B05B0; Mon, 26 Oct 2026 04:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2BDB6B05B1; Mon, 26 Oct 2026 04:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41046B05B2; Mon, 26 Oct 2026 04:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1CED6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:40:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22B831606CE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:40:50 +0000 (UTC)
X-FDA: 85364131860.13.D513C2E
Received: from mta0.migadu.com (out-196.mta0.migadu.com [91.218.175.196])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8F1B41C0002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:40:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RCN03E1x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793004048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IVuwUZCiZVCcOzmALM/+anMvBSOFJqql17OFoN+/rok=;
	b=7rYqPDlf/Pu1otHl/BP4lK9nAbau/pIFRGaQiFf7KSljKMkbhnqYvwe95K1DnOrTzjy9g6
	/MuNjDwsK4K73ObqtMz/zffGV2GcklVeF0gkRCYBloofrNlsz9h+fU5h0MDrl5KgmGJFum
	JuSD/oNmBkMPsbGaqzxOXs9TVoxCBmk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RCN03E1x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793004048;
	b=O6OZEGgsSwxog/bzfz8Ua8aA8hVmOVxjvVV/aJ+TAzMs7yPrQO2fJbA2+DyKn1VhdSsvWW
	OjZkzAgP9LvVqid74Kh+PxpGNMbqzu/ha7VvqTsTZ53TuLc0QyWQVwmdp3KZzEko3ka/7a
	KDOYW1yl/TQRSoEa0wJ8pHW5Niyh9bk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/Hf66diN7HgXIle5bCAln5FJ1fGnhiHCivfIINozcnI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793004046; v=1; x=1793608846;
 b=RCN03E1xlgO4yK4Ob1U8xBojil4CjKxYZZDKnJ8RZj2Ib0zamVlG5Qwct8U35ijGvEZ0OL68
 mTxMvUY4Sx300ppEZrXXrea0VSAssc93NUJycxcoF5iqN1PgTNVfERjONz9iVP/K7K9h7V0QpKN
 IADB/tVqIzczUeGPbLtGXcSM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 126a90acec0e74e9;
	Mon, 26 Oct 2026 08:40:39 +0000
X-Mizu-Trace-ID: 126a90acec0e74e9
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
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
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v2] mm/mglru: fix a no-op lru_gen_clear_refs() call in lru_lazyfree()
Date: Mon, 26 Oct 2026 16:40:35 +0800
Message-ID: <20261026084035.535989-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8F1B41C0002
X-Rspam-User: 
X-Stat-Signature: ccppk3rsrbhmq4hbcni83cx96thxk9wi
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793004047-163997
X-HE-Meta: U2FsdGVkX1+txWVtSBnqfIwcMXKiul0llE/9kasjLv24nyq2/v38TQpkr8hMdOX5uWMIwQSfhJ9lDSI/x9brzYO76IFV09tl/wQb2lXnkqmo0JKUBbRwZwqs8rqxKIZ0Q/OX/Pq7HRjvdn5d4uvRPZ1PvCiUOeu2pY8Gn7f7VBBkndi8vP7mNYgddrMzFKun+LILJJKpsHlhnMfh0n/TjYKdcjTUHHbn2RPjq8Gf6uLJ8R81oahKOxuMiLjWZ1SMCyM9f5mivdIkHmC+UPAJe0CpUt6WMenlygYdLPhC4U5dYzY25sm5kWbn6OG9hhHQrBc7hIbzoU3VpcS2blXa5UrmC7OT1Bck8ygsqf7xdO38i2Oe92/7dQIGpg/fP3bZpfw8JOdaetQwXjhzcA6lCX58gj5xnvZPmCWPOtowFEcqQ6uv7D7ZQjLq4cjoGIXJMLmv+LMb5W8KLETz/Csnhnkb4VWmxwvDAugIMVKEfLKy46Ql/8j70hKTtKZHaC7o56T6CULZL2nA91Q/TcuwWnhcvk24TZF4m042TIiWbdT8CbuPHdt8fmVKrSNY07Ak9P+zy31FZ9bT0UC+g4zuK1QY8gu/grWo2y14FGmG7NYJwfJp1qyf3pFNoFoRJdQcF2KTbDAiN7g9c+gP37cwllR3EU9jLJyy+jAon3hP9a567eP7MqzPsR03RhvQgJlIq6MDxBXj20QjmOLT2CuLJpRBiAiV1CI4CnD+DXixwfJw1Mbqi3tW7Jk7jVxoeE4r14KnSTljeLd7HEL3t2HrRdCgtwhh41W7cW33RWx46HCqWAVe7a/KQm/J21Gjf/PpKOLr6qcNu4yZCsht4oZuFkeK3gEKQVQRmmIq03jpB8/M3q2MBCmg6X0HknhQOjwuw6blxvBbqqLn912OCj0Kxn2nI0qno+CHgmJMFPVu7QWP945a0eYMn5by59gCt6YbqGftugTw446oonTPf+P
 hU83Ks+s
 qpDTmNSEe3snz+XfiK2XIoonjCF1KXaEMj6ZM/ViKfksAG0T8LcmNxOgm9pZmR/6G3M2honGETHUYJmqRlr3GGFl7Dl7a83PJEmUU4cvt0OIh9hdPak3KTUgqX287yhjsVz+sf7xq3H4L/y+MFUSNgKsKYC4lAke/Vu6z6ieLwrPoZSjcPtEmYwjGf52HfyNL/fQYIvjhszZzu0OaMZPWwT/zrUuwDu07pngnAMrrw7SUhwF0i6+sHAW4tZzNP32MJwWOD8Mt+J+XBpWkJTizvEUh2z+VpozrlY3gLt1WAceJeg4=
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
Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
Changelog:
v2:
Call lru_gen_clear_refs() before lruvec_del_folio() instead of
open-coding the flag clears; drop the lru_gen_enabled() branch and
the comment (Barry Song).

 mm/folio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index 35e242b48870..ea3adb6a89d7 100644
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
2.53.0


