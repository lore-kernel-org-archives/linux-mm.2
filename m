Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11BB6606A335
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uv5iaGNg
Received: by kanga.kvack.org (Postfix)
	id 2D40F6B05B8; Mon, 16 Nov 2026 06:04:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ABD26B05B9; Mon, 16 Nov 2026 06:04:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19AFD6B05BA; Mon, 16 Nov 2026 06:04:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA9DA6B05B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:04:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 65B7E80913
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:04:01 +0000 (UTC)
X-FDA: 85440697482.08.278F215
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8EC4820008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:03:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uv5iaGNg;
	spf=pass (imf03.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UIkIhG57Zfabw+sAXRL6qLfJWwSmpp1hPN2U2EZ5wCc=;
	b=g8rFIk8owPUI8Ebdd2JGFe0WbZwsL43iuP8A/meIr4fmMgMtv+6WbReRGtX3Rzau3xe0oo
	Btoy6P6JiQ4wT65Ff6UsTxcMDG5J1Pzl+BoK+B0ulNvPXt7GjO04mZQvgb/UXFkuQG0RH0
	KLFVzpCDlGlSU7HBzFZVcLeZ1X3u7TA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827039;
	b=YnMZFxS68IOSZJax+/Q+6iJPN9VbvlD/31ihagCJQUz6QE7m2WsKp0oizDlBnAGPwN7y/b
	koPQx9+jhTIVr6PnphIQdJmX/ddQL30Rl8ZULHy3OAZda4/w+wt/WZRLttW/4gNsgl0ZdI
	9rKoytFMVxYZj1FcON1LRVDOxI/TY1g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uv5iaGNg;
	spf=pass (imf03.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1b3b4944a0eso1338309c88.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827038; x=1795431838; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UIkIhG57Zfabw+sAXRL6qLfJWwSmpp1hPN2U2EZ5wCc=;
        b=uv5iaGNgs+Y0m25UPWKsCXoE6PY2n8N03PF8JnsD+A++Ahmgh6T/CLhg/byDJ7/3Ca
         xWwe8jy1ljtG7Qxk3fXWfsfDNn5aB7fUop/6gx2xDctbTRp48JttygLYES+WRhWHRc5M
         MU4aoLBM5L/ALnqievSlehYTgwoO7+xLzdTItNwshlIFSTlm8CTeYnIs9YwY74nr/D+N
         aObUeeuyi59GGgT1zJsZAZu8X+GqQtsep4CR8IHePvoKcVCIf7MSdVACqsz4a4r0jLMK
         CG0KTJkzcOco9DMr1HMRnzPTLLIz2OF5gLJIi0O3PeYW2/+FrxKOsitKhgL3cTAtwlJb
         9KjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827038; x=1795431838;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UIkIhG57Zfabw+sAXRL6qLfJWwSmpp1hPN2U2EZ5wCc=;
        b=iiNkrgKJRbOdVgp+ly02fDAdUMS316eIYoF+Aw9ubLubuhDwpjOBk5OL6UtYnOsyUi
         bkUeTbS8WRPqAhIz5ypp3tVr82n5d06lIaQcwrfRbhXlCUrVbqR48OIXOmzyW/AGLi27
         rev80XZ/8kuGFlX3OtjNXc/oyUJyVytGGZjsZbnyTsofw8Ts8nCEyhQMWtG9s9pvi2BL
         jQIouRObcux0QA8Qk1vcQTIijJLCIxMsaWo3uIt+o46lc/JKZPC8Ric00G4K5Ldf9S8g
         PIIEuWujz4B7D6TeMPMXKsvUVKqHS7BUMT3D5gu0dYJ9DvNT33p3ahW/deruqoYk22Za
         xmsA==
X-Gm-Message-State: APuU4Z8GL/5jZhJMrKw4DGTCLvbUJAf988iMVroyBJ6lPBo2jk6ROyi+
	LlzLwL+vlzx6cpKJf6N5EwLqppno8dCDFA688HFWNXqN0ejovTdo6baEWeRk4yvDxL2kNUqG
X-Gm-Gg: AYBFou3CwGQGCZXKFkUeUmkSbWLbvtUnK/1dWd1HVHYRPRy5meAakaW+Wp6smJ808wQ
	R+Xr1S7qEycuMB5O4OFP+GTt98zCaCcPOG6qAcbpiMNDBYr1YA3UIjg+yPB0y+ueq1mu4PWACht
	JihKQdLmtL0iRxJCEQjtJO3zBCPa3g8eskcL66PFqz1ALh17ogeFql5Qc44Ar7XJTM6LCrl370D
	49dHM4Pk3iVvaorbbsa461z8Y5VomWFRuwPYLPzCFhFszZlevRwW7nERv5aN3TFTeTknzInd7BW
	F19K7AWGXV9o4IykuB3Q0GUST/QLpovE56Z90opHfWThChNiqNv+1TKFQLNjlGuOsQq0P5vWeco
	Xf+r9LXRAPbw9RZPhJwBsbCG4P7dxPLwpkr9/w/wf0vsmYNMHcYuzScinHss0LlVBOVxKrX9fxc
	UiVtU9eWHAJrA4fSWb2R/faW3mvdNSL4gSvT1syIGnddVk+jKGYhCZ0tGg+U29VfOcYoaq7ydSq
	283ZyErSPzkVNrLc73GWj5ZwAxZa3QVrazM3uwJKok9LwbT5LY1uUm6WnUMpiQVZC1BEvhODHe5
	vbopSn+xHFJCfXH7qsAJLihHYBTnz86oOPULX5R4ADXT07c=
X-Received: by 2002:a05:7022:282:20b0:149:1feb:6da4 with SMTP id a92af1059eb24-1b5031244a9mr9354527c88.32.1794827038262;
        Mon, 16 Nov 2026 03:03:58 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:03:57 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 04/16] mm: userfaultfd: let UFFDIO_MOVE move memcomp entries
Date: Mon, 16 Nov 2026 19:01:10 +0800
Message-ID: <20261116110122.309748-5-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8EC4820008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: tap61fzm3grjze3q5mecmu3p37354mgk
X-Rspam-User: 
X-HE-Tag: 1794827039-448674
X-HE-Meta: U2FsdGVkX1+DjZZUp3QIq/ZKzSxzEUdKDmqxS2KIE07hJY9ji3lEIiXgvI5GTpVhBnjoPX55wzekCHU+5TRmUJ35an5pgSucdrbC8gulZhY7TtrmAbp6Pw1wE3AV8YdGc7kN/0ZJ3/V2jWcL8i6aYJld02h/mL2LIvz6lV12C5X6DbYwCeTTeD515p2F6W1tRQzXX0Pa53Umhe/47WGXS26dn3OTVVy/hug4xxPBuHZa2pp7fno7ZZjfcl1VP5COnBFJ7InP7zx301xmTrDdpyZIemM9ErhHDsTeb7iSkbz/WQgFZq+dHIBVQqhVbkyL8ViyVy1O+Y3ehs5WyzZNEYwrp88y532clIBLW8FumpoKww+uDtDrd/tf5jPhAYqG0UkANcwiz0Sp06CWk6eMl2sXOIuc7NzVUVizdkhocN5grybxDBIWEFrDTtm7wHanv8b6tjhxyK53LJJGUtJH1p6t77zciC9ZbhQglhOF5NUl/kJMF7KPkCTn/wH1rfSfPWHawK10fayaE7zXMQTsDmr2903sCcwUxoKis+tC3h8B3z0pc+7jU1DhTXCe4/McWiMudgGSnctJYkL0p1O22MDKjexah+9g8t18R1FLz6HRAy0okJET73ScHN9uSH5QS6GHntz9Ckk7J4EmI4RH+UOpvkhkDNb+9PzzIp5ObzVqV5FfQmnfnDqKYo1SwGyGJuP/7t6eeo4nOCmP/8tt3lk3o50zG466uw49f6vr2kEuNT6btFo+v4yBgklyo2pDtEMWkTOtX6ZRMwmry0dYXlV7/JvmgNd6lHjXjjmZ2R6honz79ZKgRU5lJB1OChEe3FLEOHToucas8F7T1J9Zokzc2OKthrFOagV8IlqV1L8cgoqTJ0/LBKlS2RR5P+77liv/WJDQUFHp++gmEgnp8+uN7plNO2Z0kKDjk35rB0JQnoh0JBHOySeuq80wLu32h0/MM2VpD5/tcBiZR7q
 OoRLttHd
 UwxTZo/UOWuj55DZkIvHmtsQ91+riIsW2PIFKXh4ORdKE2aYuatOFzPpLLf2AnhAhs4Hwdn3fJkg89DhmZNSwfRHabRnqRwLqWlzDqPJRDfDER9on7+SLFKdhNOI7+tDY/nuczS5az7OANA9pjNud8NYXRORMHQpV3JC3XmNN+h1KZm7gTseLSAg66+e3p3idnd2V6GRoHa/DYE1dgvHo7lV/fB/cQ7p6RMTY1rvv9bRT8sEaDqGOD8+Fq1u6uZN+W/TakkKSVBTA+f0pjDuPb+EDxz4u4imY1/boxuvuVwb76L3ztxDH0G/ddihDeutI6LOxbBVs9eILM7vk+Pmo0iZwQDy+pxoyEQWO9Afxa+O29lZqo2GS1SS4OAw5FF1iK1TjOmc9OfjHlxPPxfHH4KOmFDKgGM8fXp8+PzA9plgxQh0q/BxWoIBLwCISlY7BFaUyF8+ZBBUE/OQXdxC1unLSWR/BjXV++etXgcZ8eK4ucpwpunt0NUunrdOxbMb3wT9Ow2RIgHxY6tc/rh5114RHKNpKlHXIO+elmTLYjOUbI1c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

UFFDIO_MOVE rejects memcomp entries as unsupported non-swap entries.
Support moving them without requiring the memory-cgroup, shmem,
writeback or asynchronous-compression paths.

Move nonresident tokens like swap entries while keeping a lookup
reference across PTE revalidation. The reference prevents token reuse
from changing the backing whose resident state was checked. Return
-EAGAIN for a busy entry or a stale token rather than moving it without
a stable handle. Keep zero-token movement neutral to zero ownership.

A resident pending token still names a folio whose anonymous rmap points
to the source address. Restore that folio there, then retry through the
present-PTE move path instead of moving the resident token directly.
Drop both RCU PTE mappings before the token-lock lookup and preserve the
existing PTE and exclusivity checks.

Rollback of memcomp entries makes partially unmapped large folios more
common. The per-page exclusivity check also covers that state without
treating the first page's flag as the flag of every mapped subpage.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 mm/userfaultfd.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d8a699981d097ae393a981a33cede5f5ce6e2725..0ed91fdd2e80a89073ce2f165e0d557a55218e55 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -15,6 +15,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/hugetlb.h>
 #include <linux/shmem_fs.h>
+#include <linux/memcomp.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include "internal.h"
@@ -1150,6 +1151,9 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 	struct anon_vma *src_anon_vma = NULL;
 	struct mmu_notifier_range range;
 	int err = 0;
+	swp_entry_t memcomp_checked_entry = { };
+	bool memcomp_token_checked = false;
+	struct memcomp_ref memcomp_checked_ref = { };
 
 	flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
@@ -1338,6 +1342,77 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 		struct folio *folio = NULL;
 
 		entry = pte_to_swp_entry(orig_src_pte);
+		if (is_memcomp_entry(entry)) {
+			int resident;
+
+			if (!pte_swp_exclusive(orig_src_pte)) {
+				err = -EBUSY;
+				goto out;
+			}
+			/*
+			 * A resident token must be faulted back where its
+			 * folio's rmap expects it; the present-pte path then
+			 * moves the folio.  Any other token carries no
+			 * address and moves like a swap entry.
+			 *
+			 * pte_offset_map_nolock() leaves us in an RCU read-side
+			 * section.  Drop both mappings before querying the token:
+			 * memcomp_entry_resident_get() may take the token mutex when
+			 * it wins its trylock, and lockdep quite correctly rejects
+			 * even that conditional mutex acquisition in this context.
+			 * The PTEs are revalidated by retry before either move path.
+			 */
+			/* Zero is a pure value: MOVE keeps its logical owner count. */
+			if (!swp_offset(entry)) {
+				err = move_swap_pte(mm, dst_vma, dst_addr, src_addr,
+						    dst_pte, src_pte, orig_dst_pte,
+						    orig_src_pte, dst_ptl, src_ptl, NULL);
+				goto out;
+			}
+			if (!memcomp_token_checked ||
+			    memcomp_checked_entry.val != entry.val) {
+				if (memcomp_checked_ref.slot)
+					memcomp_entry_resident_put(&memcomp_checked_ref);
+				pte_unmap(src_pte);
+				pte_unmap(dst_pte);
+				dst_pte = NULL;
+				src_pte = NULL;
+				resident = memcomp_entry_resident_get(swp_offset(entry),
+								      &memcomp_checked_ref);
+				if (resident < 0) {
+					err = resident;
+					goto out;
+				}
+				if (resident) {
+					struct vm_fault vmf = {
+						.vma = src_vma,
+						.address = src_addr,
+						.pgoff = linear_page_index(src_vma, src_addr),
+						.pmd = src_pmd,
+						.orig_pte = orig_src_pte,
+					};
+
+					err = memcomp_restore_resident(&vmf,
+								       &memcomp_checked_ref);
+					memcomp_token_checked = false;
+					if (!err)
+						goto retry;
+					goto out;
+				}
+				if (!memcomp_checked_ref.slot) {
+					/* Do not move a stale token without a stable entry. */
+					err = -EAGAIN;
+					goto out;
+				}
+				memcomp_checked_entry = entry;
+				memcomp_token_checked = true;
+				goto retry;
+			}
+			err = move_swap_pte(mm, dst_vma, dst_addr, src_addr,
+					    dst_pte, src_pte, orig_dst_pte,
+					    orig_src_pte, dst_ptl, src_ptl, NULL);
+			goto out;
+		}
 		if (non_swap_entry(entry)) {
 			if (is_migration_entry(entry)) {
 				pte_unmap(src_pte);
@@ -1400,6 +1475,8 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 	}
 
 out:
+	if (memcomp_checked_ref.slot)
+		memcomp_entry_resident_put(&memcomp_checked_ref);
 	if (src_anon_vma) {
 		anon_vma_unlock_write(src_anon_vma);
 		put_anon_vma(src_anon_vma);

