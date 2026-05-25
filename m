Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44CFBCD5BD2
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 14:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A822B6B008C; Mon, 25 May 2026 10:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A597F6B0093; Mon, 25 May 2026 10:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9965D6B0095; Mon, 25 May 2026 10:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1746B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:57:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26A69A011B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:57:49 +0000 (UTC)
X-FDA: 84806246658.03.7BD7884
Received: from outbound.pv.icloud.com (pv-2002f-snip4-10.eps.apple.com [57.103.64.230])
	by imf25.hostedemail.com (Postfix) with ESMTP id 20E63A000C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:57:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=QQ3lp85W;
	spf=pass (imf25.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.64.230 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779721067; a=rsa-sha256;
	cv=none;
	b=OrfDFbcjr/Fnk4pMH7FSpKVlEh0qL1BdnTtkg/4XBiiWTQzT+VDltk+anqXvQC4KRNxlpe
	NN41KfvEPEZScF6sOMLZKDNR/AIXNIa76yEcR3kIG6G9JLeHUPikKbnA3sGckxYLKelGX/
	LsHRXWFMQvHN/3qucOcc9Vn6iqT2CUQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=QQ3lp85W;
	spf=pass (imf25.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.64.230 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779721067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=chMMFqiAX+0eAksNcyz+zUnXu+Fqgx3Fcq9dvFyHmY4=;
	b=H5kLUyj0iIU77HGg6L7GrpQnq0wFCbZUf3Uzp2/qex9LEwGUYSlxvgOm9M6bPgkAK7rnXG
	wFEjvYPQRHZ4BD9j0ytie9AR+dofvsMuNgSCUsRHC9/mxvJcKid/r6io+ZeX6NCtvkGnjN
	UpkqhT3H+Yjh64HhcIRklzV7wBjXNDo=
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-11 (Postfix) with ESMTPS id 3080818000BB;
	Mon, 25 May 2026 14:57:45 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhMHV8FRQNBF0kFWBcOVk1DEUMdUhlfH1cTVhR3AlEcVg1XQ1QEX1BfHA4EVAddBV1WUAJaS0ATBEoDTV8OXh8EF0YZVQRHHl1WQxsZAlEcVg1XQ1QEX1BJDEFQbFoARxdIHV0ZWW9QXRwOBFQHXQVdVlACWktfGV1FD18HWQRADEoGQFUKRhNRVUcBVUZUHEwLW0BBXx9CFEAAWg9SVkZYGlBdBytbE1UXRgkZCF0dB1hHFEcODxlaFFwYUw==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1779721066; x=1782313066; bh=chMMFqiAX+0eAksNcyz+zUnXu+Fqgx3Fcq9dvFyHmY4=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=QQ3lp85WY53uuN6kbUZGFmk6IxqDMTgzDK7YAS/YZRsvywM8kpAXoWK9w+mdn3exgZwfA/gXfi0XOtKVYA1MnJU92SoGNUpHI5PslxNYyXU0C8HHfQkB6GKEiC4AOenqpmbrQeF23Z214mg7KES84H58tVFkqTRHIV9k5QlBu+HOWoMopMG2c3cKP4G20BnYJ4xH1OEJPz9cJSWiORerLR/hKsDioahhZv/9KtIMbqTki11WkQKOIEQBDuHFCS7g/yFJczJ5GYlliAD3fo5bOSKJqM1LmOYWrL9cvqlDRkO2lb5BEMbVNtyIxME8KvoAtLolvSffwRvdL4lPN+KyAA==
Received: from [21.6.122.162] (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-11 (Postfix) with ESMTPSA id E887918000DB;
	Mon, 25 May 2026 14:57:38 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Mon, 25 May 2026 22:57:18 +0800
Subject: [PATCH v4 2/5] mm/vmscan: extract folio_free() from
 shrink_folio_list()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260525-batch-tlb-flush-v4-2-83789d6abc00@icloud.com>
References: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
In-Reply-To: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779721049; l=6819;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=kd9gqAtp/kJZkK6P5AqapN72rGvPeTsc9D8R3n39rXs=;
 b=+LpkzWE9ldHr1mVXISTt16iZ0PMNxzd8bT9XBIfGZ5f89akwrd71EcrdSCXGSF1GCKezxqjhs
 7mkpPWUywttCuwrhk2dPQx+IMlmK44qDC34rsHuAqcP23/LwYYldhoo
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Authority-Info-Out: v=2.4 cv=TNVIilla c=1 sm=1 tr=0 ts=6a146369
 cx=c_apl:c_pps:t_out a=azHRBMxVc17uSn+fyuI/eg==:117
 a=azHRBMxVc17uSn+fyuI/eg==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=Zr1499PEZckTeUg_TBoA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-GUID: u0GiH-pfi0-xcLmt_2s3b48XfcL4rHnc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDE1MyBTYWx0ZWRfX12gJl+clwFBM
 zMk8+uH5IscvOa+J/i415R784OESsJ9JDpm95Cw+4s0PEOcR9EsC0cD1/UzWa3sHzSIdzP8I0RN
 gBw8G5AaZMTHXJgdFTv7PlVfenkPx+Pv1ELdhU4M4SaM2tTVbZsXsdFXDuc3O537HYnVpKpenW/
 nn55SVapPB+Ea2+mary8i/+GcGG9kEQW8iMpIKw1/jSe6xqOmJ0Th75IFKc0N7SJoiujcYrUwi1
 /nffsSOuDB+VCap8FJcxrOt44uawRpi8l0pqKRYeL+/MkPtPMcpikqS1e8Slm40YRM9FsKvdXsw
 aASumbr5qbD/LNg1L3s5y/XRfOEEvaMY8j1TnynJ5UU8i4yjSuBZAk/Hqk1HXk=
X-Proofpoint-ORIG-GUID: u0GiH-pfi0-xcLmt_2s3b48XfcL4rHnc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 20E63A000C
X-Stat-Signature: iy9jykn7ibbcrcc16qyu6fz643z71knu
X-HE-Tag: 1779721066-638230
X-HE-Meta: U2FsdGVkX187apT9pm82cW0hvvhiBasTrR4HnNwni5+jAC9Dd8/JDwUXet4ccaOAI0Gr1Ih4vIyjP/NISLVOAzBhO3j5dBzSX1v3lYsY7o+wEfdQJ2JdOShNkXqL6q4vSyF+ynp6UleUr3tYLKrd92ihuUglhxAGZHhmKbgwZR6SQDVNVqRf+X2GDAx2wQReb4t0hTiWUdQ6WF5OJsxJpHXVnMFD1W6XjoJ8ifS/Zh+TXOB5zQptdIYs1V5oBztJzVb1FVhYAUmLzYSf2fzyBPmZLJCVOfn1iiI12z0P1eJfqXP42ffXETpi1++qvk8HhZXkJNHUvL7jVXPcibtsWYwIa/bJIBFg10emqpDVJZvmYnnlGdKlvx+x//CMZt+dAUIszZloIR7UniE5TEsiNYf2KS4X0Y5oaHcimR7vj3Yp6MYntzwAgX4AJKuaASLCPP8H1gsdW9hughLTnTNOb7XAtr0OygwvYdXJAtJAK2Km510sfDmrzbh8mA1boUhl7txeZZej8pguORbWd4hjsFrx8SZpNG07l+oJEHh7oS7CR24jD2ApbJUV8vVYmWqj3ucymQUmycQg8bFV34Siae48J5d9ZDHaegN0HfJ0QPP44n9n9RxP4ie8XlQceQl6GKHgXKAQo0gN1XAPc7hxgmVkjzPoJ3t3BLa+9UDwlo+ZKtOx2sTJCksJTBWuxPW/Fb2GDXifXnjXG5y9vZ2dusR/GXJB6qEsgJiflBNMAGLKY3DU+sH7meCtj25utbQwFTnFhow3vM1SAjh0NOQv8a0/DVp+UHvE8lsGLb7lMT0uuDeUn1Nit6IfEcc/vulD7VXyPJ53imi6hHJUa5jCWjRhBjEnVzpSIPLLtv0+clUYjwT9hkUsBGhD2AYa2TSVQihIs5Yj/yeW47cnoc2YUYpTrrWtA7TdPg7SdrvbS+y2IctTUZOt+WJ3PCRwC1rO37UvBaxId8r0BIFLBN4
 HoTzbPBN
 JbXLZiEAyo0FRov5dwDGsIrCFaQZymG0pedVjXE5cD+sZJLoqxjH/+ypRDqHrjP4LMz/2rvVObcGq7ptf2DjTbiSI+p41qGXTRcROrg6Ie2t+mRgXOealZ+ICfI06If28AM27j8yRTBtCvVFYK860330f+ELM0F4Vy6dLLp67TlA4IYtXPwDWzz4IPI2Tk9bE8S2J/uC12yN2BSEXLMKZwyGGzhYO7THIAYKzv/lZG84txkp501CWA+xf/QVAEJqp/ruh1iifViw9IIN0XV2zz8FxoARqnzjWgMu5s/O8bu1CRJyrgOAQ6e24KWnwLa+fBhJm/Dp7RFEKYxj7zNqVmDS/TunIegCNklEV6E5aNlKqw2NVsA36RUGKPptU1kKhfygc3mIx4kQQU9yVy37IzdcxK0M4SbWFQnBkxyHfszttrfoOHsY8OfKN6kfa6ZXAqm3tJHgBmlRaR+GLeeIwHjyRkm5zYayM2S+715QdzNxCZL9zsprkRSJkEjAeFnmaN8/WSUvpSkxSqrCuKmUCxuiU7mmh6flFvpbh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shrink_folio_list() contains a self-contained folio-freeing section:
buffer release, lazyfree, __remove_mapping, and folio_batch drain.
Extract it into folio_free() to reduce the size of shrink_folio_list()
and make the freeing step independently readable.

No functional change.

Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 168 +++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 92 insertions(+), 76 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 886d8b4843aa..b31f67801836 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1072,6 +1072,95 @@ static void folio_activate_locked(struct folio *folio,
 	}
 }
 
+static bool folio_free(struct folio *folio, struct folio_batch *free_folios,
+		struct scan_control *sc, struct reclaim_stat *stat,
+		unsigned int *nr_reclaimed)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+	struct address_space *mapping = folio_mapping(folio);
+
+	/*
+	 * If the folio has buffers, try to free the buffer
+	 * mappings associated with this folio. If we succeed
+	 * we try to free the folio as well.
+	 *
+	 * We do this even if the folio is dirty.
+	 * filemap_release_folio() does not perform I/O, but it
+	 * is possible for a folio to have the dirty flag set,
+	 * but it is actually clean (all its buffers are clean).
+	 * This happens if the buffers were written out directly,
+	 * with submit_bh(). ext3 will do this, as well as
+	 * the blockdev mapping.  filemap_release_folio() will
+	 * discover that cleanness and will drop the buffers
+	 * and mark the folio clean - it can be freed.
+	 *
+	 * Rarely, folios can have buffers and no ->mapping.
+	 * These are the folios which were not successfully
+	 * invalidated in truncate_cleanup_folio().  We try to
+	 * drop those buffers here and if that worked, and the
+	 * folio is no longer mapped into process address space
+	 * (refcount == 1) it can be freed.  Otherwise, leave
+	 * the folio on the LRU so it is swappable.
+	 */
+	if (folio_needs_release(folio)) {
+		if (!filemap_release_folio(folio, sc->gfp_mask)) {
+			folio_activate_locked(folio, stat, nr_pages);
+			return false;
+		}
+
+		if (!mapping && folio_ref_count(folio) == 1) {
+			folio_unlock(folio);
+			if (folio_put_testzero(folio))
+				goto free_it;
+			else {
+				/*
+				 * rare race with speculative reference.
+				 * the speculative reference will free
+				 * this folio shortly, so we may
+				 * increment nr_reclaimed here (and
+				 * leave it off the LRU).
+				 */
+				*nr_reclaimed += nr_pages;
+				return true;
+			}
+		}
+	}
+
+	if (folio_test_lazyfree(folio)) {
+		/* follow __remove_mapping for reference */
+		if (!folio_ref_freeze(folio, 1))
+			return false;
+		/*
+		 * The folio has only one reference left, which is
+		 * from the isolation. After the caller puts the
+		 * folio back on the lru and drops the reference, the
+		 * folio will be freed anyway. It doesn't matter
+		 * which lru it goes on. So we don't bother checking
+		 * the dirty flag here.
+		 */
+		count_vm_events(PGLAZYFREED, nr_pages);
+		count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
+	} else if (!mapping || !__remove_mapping(mapping, folio, true,
+							sc->target_mem_cgroup))
+		return false;
+
+	folio_unlock(folio);
+free_it:
+	/*
+	 * Folio may get swapped out as a whole, need to account
+	 * all pages in it.
+	 */
+	*nr_reclaimed += nr_pages;
+
+	folio_unqueue_deferred_split(folio);
+	if (folio_batch_add(free_folios, folio) == 0) {
+		mem_cgroup_uncharge_folios(free_folios);
+		try_to_unmap_flush();
+		free_unref_folios(free_folios);
+	}
+	return true;
+}
+
 /*
  * shrink_folio_list() returns the number of reclaimed pages
  */
@@ -1459,83 +1548,10 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			}
 		}
 
-		/*
-		 * If the folio has buffers, try to free the buffer
-		 * mappings associated with this folio. If we succeed
-		 * we try to free the folio as well.
-		 *
-		 * We do this even if the folio is dirty.
-		 * filemap_release_folio() does not perform I/O, but it
-		 * is possible for a folio to have the dirty flag set,
-		 * but it is actually clean (all its buffers are clean).
-		 * This happens if the buffers were written out directly,
-		 * with submit_bh(). ext3 will do this, as well as
-		 * the blockdev mapping.  filemap_release_folio() will
-		 * discover that cleanness and will drop the buffers
-		 * and mark the folio clean - it can be freed.
-		 *
-		 * Rarely, folios can have buffers and no ->mapping.
-		 * These are the folios which were not successfully
-		 * invalidated in truncate_cleanup_folio().  We try to
-		 * drop those buffers here and if that worked, and the
-		 * folio is no longer mapped into process address space
-		 * (refcount == 1) it can be freed.  Otherwise, leave
-		 * the folio on the LRU so it is swappable.
-		 */
-		if (folio_needs_release(folio)) {
-			if (!filemap_release_folio(folio, sc->gfp_mask))
-				goto activate_locked;
-			if (!mapping && folio_ref_count(folio) == 1) {
-				folio_unlock(folio);
-				if (folio_put_testzero(folio))
-					goto free_it;
-				else {
-					/*
-					 * rare race with speculative reference.
-					 * the speculative reference will free
-					 * this folio shortly, so we may
-					 * increment nr_reclaimed here (and
-					 * leave it off the LRU).
-					 */
-					nr_reclaimed += nr_pages;
-					continue;
-				}
-			}
-		}
-
-		if (folio_test_lazyfree(folio)) {
-			/* follow __remove_mapping for reference */
-			if (!folio_ref_freeze(folio, 1))
-				goto keep_locked;
-			/*
-			 * The folio has only one reference left, which is
-			 * from the isolation. After the caller puts the
-			 * folio back on the lru and drops the reference, the
-			 * folio will be freed anyway. It doesn't matter
-			 * which lru it goes on. So we don't bother checking
-			 * the dirty flag here.
-			 */
-			count_vm_events(PGLAZYFREED, nr_pages);
-			count_memcg_folio_events(folio, PGLAZYFREED, nr_pages);
-		} else if (!mapping || !__remove_mapping(mapping, folio, true,
-							 sc->target_mem_cgroup))
+		if (!folio_free(folio, &free_folios, sc, stat, &nr_reclaimed))
 			goto keep_locked;
-
-		folio_unlock(folio);
-free_it:
-		/*
-		 * Folio may get swapped out as a whole, need to account
-		 * all pages in it.
-		 */
-		nr_reclaimed += nr_pages;
-
-		folio_unqueue_deferred_split(folio);
-		if (folio_batch_add(&free_folios, folio) == 0) {
-			mem_cgroup_uncharge_folios(&free_folios);
-			try_to_unmap_flush();
-			free_unref_folios(&free_folios);
-		}
-		continue;
+		else
+			continue;
 
 activate_locked_split:
 		/*

-- 
2.43.7


