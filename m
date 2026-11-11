Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CFA60A261E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=WXS57Daz
Received: by kanga.kvack.org (Postfix)
	id 751B66B05B0; Wed, 11 Nov 2026 04:38:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 729BD6B05DA; Wed, 11 Nov 2026 04:38:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63F9D6B05DB; Wed, 11 Nov 2026 04:38:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 344AA6B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:38:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96F8514024F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:38:09 +0000 (UTC)
X-FDA: 85422337098.04.CD37641
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id A567540004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:38:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WXS57Daz;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389887;
	b=NtWieqRJfIDAhaHe2tCdtCUON/odA0ktZhVZrSHWy8A1iPNjoeBjguin9Pq95mGcd0eLiF
	PgPPSdXY0OGnk4dEtM7nIpifoPIoGovuS5UyPk7ItbRQedYaGJTL4pCMcmCqQBDx8NZx1P
	ilbjaxyOW+jbUFoYztAdxZlRIkqU/zs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WXS57Daz;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlI2hSgARAsESdSujlJ/ayVkPK6G1sKTaez08nG/rjk=;
	b=NdJ2J7PNlELQk86EkWKE43/enKKnIp45Yy7hPqlqRTX50myAzBATuNL7TTuEnKGrQVP7nX
	+7D0IE0dI+oo5LQOJ8XELVK8w5uw+V8b1dnG6mswSWaWiINDWJq1h1bprRrwH01APMIDSz
	ffdkVi8ZdKHFbxn00E/1gVolG4YsAwg=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-36fc0a3fe93so5859653eec.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794389884; x=1794994684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mlI2hSgARAsESdSujlJ/ayVkPK6G1sKTaez08nG/rjk=;
        b=WXS57DazzKPdKLEBdQ6NtyFObxVKE0y/j8bzX7Ro8muTNPaAplvhDZquktgHAFnRLF
         R1qa4O6NvBrYpclSGKUw+jUibJA1TFDhsIvVQ4FfECoccnIugscWSArcpte3RWqfn8ZF
         45B+n++3FYTSUJcdWDuoLjyws+Ro6MgtLVW+eSI454+gN5TO5TD4fLCL/lXqawOnMaYS
         3VefO+sAbuAbcxVZqCcjwo+t1cOS/K4FtlfqsnVX1ZQ69FZrdMAmn1E/bVkQJQSeB6pm
         8OMsT2zQuo4N7vM2Iu+oY2pbDmi9gbqOsvHqQ6FkvFvXjzJvQNbc7zZ61GVh90Ukj1iA
         YaOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794389884; x=1794994684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mlI2hSgARAsESdSujlJ/ayVkPK6G1sKTaez08nG/rjk=;
        b=ygl8pX/XScSE//KvWLJdqewQjHdCcROU6t08HXyQZwa6NBUZDAop3nE9Mep69zLm9R
         SRQQyQ1nV7xCHBob7bmk01eRWUyXeK7A2tV6oqzK5r4Fk9AyRelUCG0xb2LHgXRwyUv6
         9J7thBkvcnXeUGM6HLTF1eceVOGwdpo04nbxIEQ2TX8N0qm7sSAAuLWTDWRMzJpXFtD6
         vVSddm0MCRkZbtkUpvO1ryNZmxCOq2JgLo5VfzazutuMHOlIHv3wjlKIBeghfEUrk/hj
         Eq/JofVlzov76VT3TP1L5f1DDdKEqXHaFg3qnVJsFX0J+y+9E/Y4KSa0xTr9tYaT1mKQ
         Bi6Q==
X-Forwarded-Encrypted: i=1; AL+hErG4FVNTwbXSkLDd/60GTU+Av1je2brdvw9S+6cokinIltufX0eIk5Vf4nYJZGT0wq2AirGthpkNmw==@kvack.org
X-Gm-Message-State: APuU4Z9SDQ8eC9jrGe5JjrYp1y0bZloVo8d6xv+xVd7uYiR9SKfW91YF
	5IXeCAprKsEfZlkW4QYZZIOX4zt2u80+z4pqCAEjHlt5IU4c34aPRL7OKwQrCqieeeA=
X-Gm-Gg: AYBFou2Ys5+6zPDe8etdHETja267oWpFB3l4GPwJs++d5FutuODaZbboTBJuqtfGgn6
	oE3lgcRVWsRLku770TDPxjKYHIooc7v89MaYWSg5gefGO05Tl69LnAZStiDsbhBf3ujwrUO3aW3
	o/f6fm+IUfMvxyvlQmP5+k+Wr7OmEbCoYEAzJtV56hrtRa++D8XAkUBpXkquyHNhJCn5nsL5tYw
	oKJaPFTv9Sjq/w4HWS1Q3MPub2Sl/ImRdFQyYLXuhcL0H5qu9dS3am7InDxc3zgTEcZzh60kzbW
	54v/QUYh9lx+N1v7FkjLFBByLsKk73EySK4NdtV6pvU05Asbn+8c7VJa9GWGpIPtEv/lsOjuyMH
	J/bumoiOaBo59BfvwCEyvdPIloO6H/Lqbi+FWyOx70mLUSH7aB/BVRW74gaUdIudH/65iJz0bTA
	YYgp2/IkGeRyOIGjURBJlM7NIa/pVyDTo7Qi4XnDXs7zMkfgJklTSUWqS8ovKK42JOC4QwHtkO6
	SvcmQF7IBRjs8rhdnYETRIc/DgyFLLW+hULRGHdUEoE7ZgtXsoy2koLxN3GzwlRMFrLq50FkxTt
	vV/1FzZbxPzHje/KkQ7PEU+k60B5eX/j4Iy8wVI46hz4tvRANL+pXe45tuQhkNA=
X-Received: by 2002:a05:7301:dcd:b0:370:d7fe:6585 with SMTP id 5a478bee46e88-37685c7a46dmr2269843eec.11.1794389884220;
        Wed, 11 Nov 2026 01:38:04 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-375212e9e03sm29016749eec.23.2026.11.11.01.38.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Nov 2026 01:38:03 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Sashiko <sashiko-bot@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/3] mm/hugetlb_vmemmap: fix PMD split TLB flush race
Date: Wed, 11 Nov 2026 17:37:45 +0800
Message-ID: <20261111093747.50048-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261111093747.50048-1-songmuchun@bytedance.com>
References: <20261111093747.50048-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 16dhxeiquk4e7j3u78bz7g899bssooqu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A567540004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794389885-362005
X-HE-Meta: U2FsdGVkX19dzWbV+7Cj540F5zv75htoVENXOc7Qm4q64aO0wgw9RcY06vBuOu74MoeKw1I7Vb3TG535ELhFk58QhI/CMN7QAby6z6xRog+BVud3MuBZrBJ+F4AEMRP0I1VRK7lYoXM2yBGFhpLn57MUqzIth8VGGbp8k/0CJgl+0v0vQV0+7+gJfiR4VAWZQRS5aH9xx/NQApN4yJGrGwjkhICaTHuZXIXUV0/EWh8LG2l4HadG4CfpammMmLCRsLsoEszsiRJgxkdDQua2w+1lnTqLX2321GEWtkKhEKd2Q0pbnvwh+5dVonC6YWXT3RG5wuVWdzNNJO+xiFsWCRhEaOJmGbnAXNX0I4iLpX9fB3gsLMg/FMHPZrKHiOsxCmcpIDCwtZnNk3eloKvIR6sClYzlMNhNia9B+vVh4tY2P+pMkmwgEuf8M9BP8bNmKrwJqU7t7scABnF7KXZZ5G+uBFNtufH7f/Juu/A8VQ1gQPQHrilBlQduEtzfRQ9xGG7Mw2KWVl+GAjwbWCF1433uLGlOab8aWhJHmgJT5EWeDlCirxSD7hmETAxSbSYNodpFGD6xNHkZxv/ZsL+BZ5osSvfo/xdN2oZEKyGHqPScdtm/5qEtHowFQn9CgpfrOydvR/i1JGEN84AvJug6daXKwieExlEtllkeKeUq1quCCaXZ71bNw/ZB4Peo5DRuoGNiPZceRuuqGHkABqh0tPTBY78jUfy7uWeChLfFSIYZBCMPcEQCvXA7EoxAbuX97l4akPsjVOJzR4Od/7IC2OJIrh8JCjtL024GpQhQZL9IMORhXBO68nsFKbpPNhwQcbhXOSGu5AW1QAfg/b+CAyirZLx2uhJAfbNe7yerURFpnsqhSjjpRUWLau2BTyAJ1t1LrJk7GGKrVVpWj2Wa5JSNvNALi9KCFtRktf1rRHAiac3DS/m7H0Jer6HIGGZwrVsRqRZSB5K7UcM2yuw
 iPopPr0l
 Fr0TUwFwsfJAmcKpK5ojM8d+UnoF5lLnkMhJk58I/unK9VLauwh+uIrnmmnjnO3PMG/67V4X/Wa5ZnrIIM4aEwLbMTWKupWRYivMkAmMHSleAHxAiecUfGXLZXLa+7KpGlps3Q/pMWRMSTrEAmkvRQI3SL25XqG0eUkAukM5kwk5BLHEqOgi0AJ1KmdOAKUgwoO1Y6DWNQCFviSZnTO4s0/EeTF6d69IzNv7ujF4JuaQTj+kPx+Z+hs71k2Nw58kVH2BUTrho3uZHIjQrJrvlhb8hB2atENt8tRkNi4GEQJD4fQ6Y0ca2RZGJsq9Sh75S5PhiuRb3e6eWf7HgOZelmpQhRGbsiEs6we9DuAiwm6/O4LSwG2QITSTveaT3HmUWVcFEi+SFjqoJh9hM8TcnJT3niwqC2vAlooWeWKWIc4RUeNNXlQfxImKXNdqI4r5nDlwXUpSMN8tXpJyu0PZcv+1LQDMTwV1FWY6yTCBXUPLEbZJLEtx0fAc2z+U0TIUoVLag
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Bulk HVO optimization converts vmemmap PMDs for a list of folios into
PTE tables before issuing a single global TLB flush. After publishing
a PTE table, a concurrent single-folio optimization can observe it and
remap its PTEs before the deferred flush:

CPU0                             CPU1
hugetlb_vmemmap_optimize_folios()
  hugetlb_vmemmap_pteify_folio()
    vmemmap_split_pmd()
      pmd_populate_kernel()
      /* TLB flush deferred */
                                 hugetlb_vmemmap_optimize_folio()
                                   vmemmap_pmd_entry()
                                   /* sees a PTE table */
                                   vmemmap_optimize_pte()
                                     set_pte_at()
  flush_tlb_all()

Modern MMUs permit overlapping TLB entries with different mapping
granularities only when they translate to the same physical address. In
this race, the stale PMD translation still points at the original vmemmap
backing range while the new PTE can point at a shared or replacement
vmemmap page for the same virtual address.

Serialize deferred PMD splitting against PTE remapping with the HVO
rwsem. Hold it for write across the split-only pteify batch and its TLB
flush, then downgrade it before remapping the folios' vmemmap pages.
This guarantees that no PTE remapper can observe a newly split PMD until
the stale PMD translations have been invalidated.

Fixes: f4b7e3efaddb ("hugetlb: batch PMD split for bulk vmemmap dedup")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-fbdc3410-a4cf-457e-88e6-684380fbadfe
---
 mm/hugetlb_vmemmap.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 79ca68dff635..6fba3184356c 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -311,6 +311,9 @@ static inline int vmemmap_restore_range(unsigned long start, unsigned long end,
  * is skipped, the caller must flush TLBs after all pteify operations are complete
  * before remapping the folio's vmemmap pages.
  *
+ * Note: The caller must hold vmemmap_remap_rwsem for write from the first
+ * pteify operation through the final TLB flush.
+ *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
@@ -321,6 +324,8 @@ static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
 		.flags		= flags,
 	};
 
+	rwsem_assert_held_write(&vmemmap_remap_rwsem);
+
 	return vmemmap_remap_range(start, end, &walk);
 }
 
@@ -400,6 +405,7 @@ static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 	if (ret)
 		return ret;
 
+	guard(rwsem_read)(&vmemmap_remap_rwsem);
 	return vmemmap_restore_range(start, end, &vmemmap_pages, flags);
 }
 
@@ -568,6 +574,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 	if (list_empty(folio_list))
 		return;
 
+	down_write(&vmemmap_remap_rwsem);
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
 
@@ -592,12 +599,14 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 			break;
 	}
 
-	if (!nr_to_optimize)
+	if (!nr_to_optimize) {
+		up_write(&vmemmap_remap_rwsem);
 		return;
+	}
 
 	flush_tlb_all();
+	downgrade_write(&vmemmap_remap_rwsem);
 
-	guard(rwsem_read)(&vmemmap_remap_rwsem);
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
 
@@ -620,6 +629,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 	}
 
 	flush_tlb_all();
+	up_read(&vmemmap_remap_rwsem);
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
-- 
2.54.0


