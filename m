Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70291606A330
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=K0rI0UM2
Received: by kanga.kvack.org (Postfix)
	id 6E5FE6B05E4; Thu,  5 Nov 2026 13:42:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD306B05E5; Thu,  5 Nov 2026 13:42:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AD426B05E6; Thu,  5 Nov 2026 13:42:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 423326B05E4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:42:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CDB9B80A68
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:24 +0000 (UTC)
X-FDA: 85401935808.15.14B3C5E
Received: from mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id E7D05120007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K0rI0UM2;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3rveXys3ZDi6PVgA/epR1hrpD6HRU61mHGBa3cRD2j0=;
	b=Qz4S0+A41/4tIISOgKzuWyaB4VWqrzU4cUAE5VkoaX6Ad6a3MZnNO3eh1+wk5jtPIowDB2
	WySOQv/1hxFVbvcvQFw4RN8toprXWHyyEpzlCEIDCXOhjksZoHyFXIZdagc3Mu5V52jSQS
	QXCfW3nVBLyIPtsjrOhuKGzFWOcZ2nQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K0rI0UM2;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904143;
	b=hPgfD85kVVsGGObeAAi+TGWTBgQiNfMI2n526cqyOi4NqWkXlNc/yKEIYwhkBO2lyaFS2H
	JXz/G/EmOToopLJ+QLdnQ/8Xhx9fNjk2V8877wwbImKrXijHV2DQTDiS5peMtl7+NoYBh8
	NKffrKp8NlcaXaSx/9sNJKoGVcpGBTs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VFZ2vxQ1RyBM+AHfk9Z1D4P0na8AkP2wtBSDmYtWTbM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904141; v=1; x=1794508941;
 b=K0rI0UM27/1GSwUGbyRi5b3mKDlk95uXE0g7uVRcIJd1xFApXnGo9OXqD5gQkUQhKXXXFfc+
 Vr2rGNxiAFYlXu510cE7UoP1JpuCv2PPXg2M1xgGVdWH0JHANZ8/bVpqCWqYQRpYKCHzlVbBJ+v
 s/K60K7Srf4LhQazh2voI3sk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 09cff266752e68e4;
	Thu, 05 Nov 2026 18:42:21 +0000
X-Mizu-Trace-ID: 09cff266752e68e4
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v9 29/32] mm: don't PTE-batch a swap-in over a hardware-poisoned subpage
Date: Thu,  5 Nov 2026 10:39:13 -0800
Message-ID: <20261105183940.2236717-30-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p9j7gc74zykxwsyx8uzmgn3bo7nbo1ah
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E7D05120007
X-HE-Tag: 1793904142-520434
X-HE-Meta: U2FsdGVkX194BIxBvwRIOL2KJKzxPbaJ3CJEf4+cEocO1esKVXxlV/mzwGHNe1MXhfiQ/dQI/QHNnVCi9PgK92lVlvHVEL8mbKkU5xWahwNdr5gWHRcrEzASPQ4F1dlYZ3BZ6wNpvPr2VWT1dYHd/mprSyyBFsB6dn48kNtO/2fsVVbeEV7O60UIR7We+syKwRzxbgMrPeWvohvrkphCmRjyt52cQjoyTUDpQJzUjEf4QSltXDqiBO3DbQ9pZPXOGlmavcR3jUvxtR/aCQzt7FDjWAPX0J6i/2iOvfC0geG38sv1+XtaILv9tV9GmSyPfGS/jhApVOiYBra9IqXztrs1UL2SwnlBsKiJcRtQSDLTM9kt58QJHZG0HiD0dKA42Z/VVKge1IQOSFC4AMrBlfpxGdnT7HXahS3faSAIhW7sQjDS9gTOJQ71cHUQuw00S/wb+f79yjHx+pGnKFQEA8vsEZdthbE8u9RMM2sNezIuj/SavRP9ixjJriPyyTgMpZN4/xCRUUxHDiSwwgtn4aU4+c2C9C/xI1Gtop2PvfIg5A4kDxprK8aiLE6FkocBPdcBW6m3+hKUwdbB/UgjEjFTwNIC3I7AP4Dr4ryagWl8fTT5pfzt5MfBTHCR1wisU46dY4hzjFIdHWpvaKiVSHegyNzPCoAaiq7/s6jFKfpiitinmojlm6w4FvDESNEeKqNjeSTYTEd/8JZNcso71yVpcYL8/lQuLec2n1GTv9G/sEgqtKUQF2127ONWdEHS/DybFEKeNAAL5E/DgiOGHRj/jY/vICkT+r53wd1gtWwJ1qomy8xwsJA1DH43v71kka5ViMtZRqhFGN48s2pMDcNVL5xB9vV7xOboMwP49Ak2pWjRbPQ3bWXCoj07ycg4rhwOTyzLMHQzzHrLrMdo5jBRQiFZ/zRdGnT00Hl5cKVswv8eBjfjfZRHIQaDjPD9UNtHLguU1qXzQMGNYl9
 nmaUEqJX
 alVChPkDQu7aGHGC8NLPVu4OvsFlF9S4FoIk4WpEAgi3JTGLzpG/fUXl1v7VU6xguhIrggxMFXzbiyOxnNB3UuKVkkWDuMNE8OGgkRok+sc4XXzDfjOWYj75RaBzY1fjwP1quAm2kk7aZIe8N3IQ6TzWXFY6/KPhkcoS6i6ATyBfTY4EasnygukpjQCq9DFeA0YDMXLpC+5JzQi5eG7kjGB9PI1Qt20gli/g22Rx/IDlLUrk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_swap_page() checks PageHWPoison() on the faulting page, but the
large-folio batching path then maps the rest of the folio without looking
at the other subpages. A poisoned subpage that is not the one being faulted
gets mapped anyway, and the fault that would have reported it never
happens.

Skip batching for such a folio and let each page take its own fault, where
the existing check catches it. Test every subpage rather than the
folio-level PG_has_hwpoisoned: memory_failure() sets PageHWPoison() on the
subpage before it acquires the folio lock, which we hold here.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/memory.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index dedcec3cfca6e..47bba4695d855 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5143,7 +5143,14 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	page_idx = 0;
 	address = vmf->address;
 	ptep = vmf->pte;
-	if (folio_test_large(folio) && folio_test_swapcache(folio)) {
+	/*
+	 * Scan every subpage rather than testing the folio-level
+	 * PG_has_hwpoisoned: memory_failure() sets PageHWPoison on the subpage
+	 * before it takes the folio lock, and we hold that lock, so the
+	 * folio-level flag can still be clear here.
+	 */
+	if (folio_test_large(folio) && folio_test_swapcache(folio) &&
+	    !folio_has_any_hwpoisoned_page(folio)) {
 		const int nr = folio_nr_pages(folio);
 		const unsigned long idx = folio_page_idx(folio, page);
 		unsigned long folio_start, folio_end;
-- 
2.53.0-Meta


