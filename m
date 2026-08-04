Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D410FC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 00:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C813A6B007B; Mon,  3 Aug 2026 20:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C32196B0088; Mon,  3 Aug 2026 20:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47E66B008A; Mon,  3 Aug 2026 20:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7FA116B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 20:37:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 098CC1206F9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:37:37 +0000 (UTC)
X-FDA: 85061723754.30.F29C4F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 817BE100002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:37:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GbDL8vOf;
	spf=pass (imf05.hostedemail.com: domain of luto@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=luto@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785803855;
	b=xHMAXe6vSuKkATfkmeLDxWBkb3PR5f4UeOFHJ1wsMtjuoUGEJWwq85BxqH05DkAvOCHu2U
	3zWE0PV0r4fQIU35X/mu7cGdCdCLCigRaAazO6r9aBr+kHgkQy/O9a/ACHNXm4+N0Q+fiL
	yF3ut+ZJlxzxCgMBDQ/OnpCbAWmwBhs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GbDL8vOf;
	spf=pass (imf05.hostedemail.com: domain of luto@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=luto@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785803855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=W9DygNyHW+E1VUj2JEzj3GqHGlULW7/nccPrZjgZMO0=;
	b=eigNwh0J2+AgqCwOmMOts1VpkkraGy2DBYotrvVOAPcB8jS63xfnEmZrhsg26b689EtOb2
	+I1hIq0dIYnXqsr2Pg2EmGKg3hwnHq32PFQbcOz0YcxFVijl6j00yGdq+S2h+bq1y3jOWx
	X+m6sh4PKeStW+vCKWVjBYWBfZOtpfc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF94960A59;
	Tue,  4 Aug 2026 00:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC981F000E9;
	Tue,  4 Aug 2026 00:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785803854;
	bh=W9DygNyHW+E1VUj2JEzj3GqHGlULW7/nccPrZjgZMO0=;
	h=From:To:Cc:Subject:Date;
	b=GbDL8vOf3FtW0krOJtwvRUdJj00bVX4UPXzOsLf9u6y9J14kK8XTFR80E2XLKgSRl
	 IBRZ+jSj+s15+nni9G58BlRT2xUfRPJROpqkS2gkMOsboChxiNEBB1Oh1z7/odKuD+
	 O9Ed9Yo4Nsy41UpI0IoC0oIveGEKRbsQgCeT+LDsg3krjl4sfq63hO8oJH/yW0JFyy
	 jjmQxdzN+oBadG2o3fpDgoa6CspsxhLH67diEvw2S9Rhu8KWCA2H+4TBqRD+1BazX7
	 qCACpxgDDfZMMn2FI3XLBXB/b+IJ3o4839nBKPLtiY0+BUjRh78yTPbo/a17+I1CZs
	 yR06vRXtPoHxQ==
From: luto@kernel.org
To: linux-mm@kvack.org
Cc: luto@amacapital.net,
	Andy Lutomirski <luto@kernel.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org
Subject: [PATCH] Fix incorrect flush address in direct page table reclaim
Date: Mon,  3 Aug 2026 17:37:08 -0700
Message-ID: <20260804003708.49830-1-luto@kernel.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: o86brs6dt5x3e43ft919s1pumbitoaq5
X-Rspamd-Queue-Id: 817BE100002
X-Rspamd-Server: rspam08
X-HE-Tag: 1785803855-491138
X-HE-Meta: U2FsdGVkX18hAgfffa2yqlBFtJCB6CQ7iUXtX4qaItM8wgEHCyQ7hPlVptk5Q9KoUcMVlAAIih+c1GsMDZZXjsP1zP4AftLRCmjRC4BNcvTluJbYyw/R2FDgRe9ZOWsEI0kssPqa2vJe1xYoX76InnG0fk+Ono5bR+GnFXm4syEQ7iVLKYtIveHsMaUfhX9Ha6wNMwSD1CxYe0LHj98dnzyx5tFGHioFq6tB2tg0oeOdcrcy47EbC+StlZQ+wLq04QL3Uouy8BQMrbJq8sN6PObFO/SPcbvpvxlh/mBqjlLGVXRuEI22IUAEjj4ixB9QoHLi5+PW/gG2zwYeUuS/P+UEQv92Lzi4NddWndsdqboPLi1nSLE4o5mNbZZqpfJhtWTfiE3ZEhpdbDVfLWxT8EWcWpNqI8SRmNgSTrkVc5DSuaUlsZ5x0I04S0TO7HZ9RRQoKZvpDjSp24obXJCZkRYh3ZPlVQu43/HcieRYzpUv0HFeyftDOpv73q6vEn7kE/dzzvtrAUj4CtfSwy9FRnbfGw++a7Olrn3K2AIWLytSiFVXSNRVAwhFFhJivtGF4kCyM24Cvf0Dy63NzCsJvs69rAQkuzJkAfOFyTf/cSwx5TEfXQaoyMQdLJaloZo2jCaRvi0bS/PTzd7aoOUINKlrjfZFnHiMnk84SVMLvPdXlqTg9V08s8hAbMSwhHpavpUHzYdF+Eaj27sQVX9DiydG5zP4BnQFNn0xrUII1dZGS8WHURtfkIzGxd0DzdFmn50UDV3JEGX0Gax1uGHwHlbizfh7VdwM+M2k6TTJc30AQWQvPV7bWsnuookwn8ZT3GJdNKJ2aqvhmbyJyHooR5txLLkQ7P602b/aNeqtPs95cCqClUOQGLTZNGrhNvG83/VSYG4AabyyUvLL7TkKrGG5I5YqEQGW1DriazyOkPFq43Lil9QrhNOmaDfolE4BWK8/GpGoYLyA36Q+3JM
 bRkwugED
 5Fw+EScAxbZeLTc3Bui/vXYDOzltwRo3wTpq2PwBu6cXOJ6bDHSHzf6qWc5sjZrLGbevELWJZ3nCLx99o9Qak5ekft6qrPsdT1DhdHZzFZoRexdMaXJYlJrbdFmokHAoMjdNCiP5X2omoNlCZcuCHa+aXWYwDG72y4328yXedBOr2tLM2gXq0e45nkvViW6Lrp0U2VWTQrvBDf4zCrFsPhYNSsPAer63pmvFr3trJeSlDSgV60ksvuCYBjzpAxwLsJ9ellf1pUDSxQkF2IRmCWzzQ+eE1CKs3SwWPzf9ncxB+p26zR5UfwcPOQxW2o9/KMluSobWbERYL9yGGIIxck18ytUjeNXLRSN1JS1jT/iePeJx5CtaXb4GXf/tTxIgxhCm8nkwK3v/+rD3pjkiLyCVlTB2ZfywJ8ECaVKQCFmMGC5j+ENlW2AbklIP3214b55bdJTUIaxxXyI8mOKwgVR3LfICOHhkmV1/tcmU2pQZ/H0HG844BrA9y4Lx2CDIiwlL3FsKQFQpBeqF8Dze2w58BuuT6+WtQGSZW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andy Lutomirski <luto@kernel.org>

When zap_pte_range reclaims a page table, it does:

    pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);

and this is unconditionally wrong: if this code executes, addr *always*
points one past the end of the range covered by the table.  The addr
parameter is used to flush the TLB (really the paging-structure-cache)
to drop references to the to-be-freed table, and any architecture that
cares about the parameter will flush the wrong address.  (But they'll
still free the correct page).

I think it's worth contemplating why the kernel works at all.

If we hit the offending line of code, we will first clear the PMD entry
(line 1954, zap_empty_pte_table), then we will issue pending flushes if
force_flush is set (tlb_flush_mmu_tlbonly(tlb)), then we will skip the
retry on line 1979 (phew!), and then we will do the offending
pte_free_tlb call.  *Or* we will clear the PMD entry immediately before
pte_free_tlb (line 1983, zap_pte_table_if_empty).

If we have any pending flushes (i.e. we actually zapped any last-level
entries) at the time we clear the PMD entry, then the flush really ought
to flush all references to the table (Linus certainly seems to think it
will on all architectures [0]).

The condition under which we have no accumulated flushes at the time of
the clear is very complex (the whole zap_pte_range function has absurdly
complex control flow).  If we do hit the bad case, then we will end up
clearing the PMD entry after the last time the range is flushed, and any
CPU is free to cache a reference to the (empty) page table.  If this
happens due to an ordinary read or write, it would segfault, so it would
be rare.  But the cache could be speculatively filled as well.  Then
we'll flush the wrong address and then free and possibly reuse the
table.

On x86, even flushing the wrong address works on non-KPTI Intel systems
because INVLPG flushes *all* paging-structure-caches, not just the ones
for the target address.  But INVPCID does not, and flush_tlb_one_user
will use INVPCID if it's available.  And then we're toast.  AMD systems
are more susceptible: we set the EFER.TCE bit, which makes even INVLPG
only flush the target address.

P.S. IMO zap_pte_range is a mess.  The control flow is excessively
complex.  The direct_reclaim variable itself has a confused meaning --
for the first part of the function it means, approximately, "we should
free the table if can_reclaim_pt".  But, later on, it means "we ALREADY
reclaimed the table".  And the goto retry on line 1979 is IMO just
asking for trouble if the condition ever changes such that it might
happen after clearing the PMD.

I think this might fix an issue in ripgrep reported here:
https://github.com/BurntSushi/ripgrep/issues/3494

[0] https://lore.kernel.org/all/CA+55aFzBggoXtNXQeng5d_mRoDnaMBE5Y+URs+PHR67nUpMtaw@mail.gmail.com/T/#u

Fixes: 4c640eb4181c ("mm: move pte table reclaim code to memory.c")
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>.org>
Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 86a973119bd4..13b70861c8a3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1981,7 +1981,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 
 	if (can_reclaim_pt) {
 		if (direct_reclaim || zap_pte_table_if_empty(mm, pmd, start, &pmdval)) {
-			pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
+			pte_free_tlb(tlb, pmd_pgtable(pmdval), start);
 			mm_dec_nr_ptes(mm);
 		}
 	}
-- 


