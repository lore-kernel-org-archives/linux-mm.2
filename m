Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DDACC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 05:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CEA96B0092; Mon, 20 Jul 2026 01:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6936B0093; Mon, 20 Jul 2026 01:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BBB16B0095; Mon, 20 Jul 2026 01:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 306EB6B0092
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:08:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E2921C0A00
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:08:07 +0000 (UTC)
X-FDA: 85007973414.19.CAD8C5C
Received: from outbound.qs.icloud.com (qs-2001e-snip4-2.eps.apple.com [57.103.87.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id A0B04A0007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:08:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=1LuCG8cT;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf25.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.87.45 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784524085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8aZQYm37v3YWegSE0f/522iUhXwfG0dV8XiPNn7/zA=;
	b=lHIXNnPBOZwHVajcFW6MkJGuYLOgWT5vc6KBTheT9SFigHhZg6JzRg7+0czVlBiMRWa6nm
	yQpIMGxu5atAnv+mL/n5hbxrAn3tcyVsKqMPu8s2T8XzA8yR5UXvCrGUA5PZ66U1AsMa4l
	5BVT3gF/IrC+aO15yO3490v7zeWqEHk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=1LuCG8cT;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf25.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.87.45 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784524085;
	b=r3D8rIATK0QTWlRswpUhDkSXb6UGoVodH15j+sOslLhsKAOn/y6mmRabt1yBGWfN5eFH7U
	tMCNN2qye6rMgVE2zMiznpAXondiK+V60H4lOptpvAXITxCgbvuGkUHZ7CZu1mwxYkOk9y
	PqC3z7eNayBzge6LQMMRlzDpA4h4QZw=
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-7 (Postfix) with ESMTPS id 2B5771800142;
	Mon, 20 Jul 2026 05:08:02 +0000 (UTC)
X-ICL-RepId: 019f7dec-8f5b-7282-86be-ea88f13742cf
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhMHVwGXRxCCkEdXgBLVxQEAlodRw5AHVYWWAhOK1sTVRdGCRkIXR0ZHldQXgheH0wcHQ5YBhICWkUBXRcDVxxWRVwYQwldBVccHRxERVsTVRdGCRkIXR0ZCEcfCjADQg5WA0MHRQAtGRxXUF4IXh9MHB0OWAYSHVAcDlEFWwBGCU8BXRoJUwRaEB4ZWwkfFlUNQAUaHQddC1VXDw5fAREJHAMJAQlyGVoUXBhTRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1784524085; x=1787116085; bh=r8aZQYm37v3YWegSE0f/522iUhXwfG0dV8XiPNn7/zA=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=1LuCG8cTW02fWgPcouVYMSt/nzspcCwjz8cBq9KFVAXIBqTng9tCvRTn2dCAnZzYQFsu8X2ti+c3ZnV9NtPM+N7T25BeOEs2Tudu8un+4Zjos0vfjGlyzgLiYAk2rG1tCHBraDZzKpWBv8on5BivMhdm66hbpF67YFCZb8vDd8gR5eykWimuxJ/DJrI2iQ+xnuWbvzeNPJpat6UbVTHrkAX+8vviAtWQ54Y4KA6BiJTJYaiIGmENrWF0TQyFT5jvdYuHY6FhF0xDU4MAWXrHKYSKOlJyLDh06clYHN/LMDblWVjCdarKt4ARPPn5vGCti3y/e641H3iLHoukXxm8pw==
Received: from [21.6.122.162] (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-7 (Postfix) with ESMTPSA id A8A6A180014F;
	Mon, 20 Jul 2026 05:07:57 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Mon, 20 Jul 2026 13:07:39 +0800
Subject: [PATCH v5 2/5] mm/vmscan: extract folio_free() from
 shrink_folio_list()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-batch-tlb-flush-v5-2-db943a0d0d6b@icloud.com>
References: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
In-Reply-To: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784524064; l=6784;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=3E2ywKByDNomV6rtuYwrWIJ7KWxsBoMRkdyyYPY6J20=;
 b=xwLl6qIZQKNcuhsChppd92HF64KnsIhpGCL3RSjuWjDbfuuywcAeINyOZGLuqw21yHt4lJDb3
 pmdrUVoASFpB7EEMrB8fI9pnl2tna6V9T/qRQxbTy923iTqsnu9AQp5
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-GUID: S0J1xPK0SItHssd-vov55hLNs4bFa7L1
X-Proofpoint-ORIG-GUID: S0J1xPK0SItHssd-vov55hLNs4bFa7L1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA1NCBTYWx0ZWRfX4w7MkmROKZPX
 ShHbKgcSO4k4EoMq9RR4TnRAan8uFln4NGYmXZUbrCC8edrwzkW7A+e6EjmB7r/nsllO0aMVBmt
 BGM85RqenWX1Ak0Ugjd8tH57hIGC/Q7bsa9ahUuRG+leIagFrP3YxLl5NZICMtjKZARYLqJqqAn
 NdwubE7x2XEVovL4nvUvomWRLsKyknQ1KEaddr/z2LVup4uts9L5GCl4UUg3rqd2RJuqMO/GIcP
 zbQDNG/J/Rb5DNO9At2fBazqvPAlQ/v96i+oES0BqJkPMvqLCjOnfcn5LMuODdxu7t+Q0weuyUO
 Hyozsts2ySvEPNUhM5V
X-Stat-Signature: qnakc4ng4srgpjda6for1meceyskm661
X-Rspamd-Queue-Id: A0B04A0007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784524085-605727
X-HE-Meta: U2FsdGVkX1+1/f8RUuv5Rwz+Sp30OdfFGiy539jViO/jR1+tUecdog/UAGFvDyLts2DnDztj86e6a0eZXukEgau+0DKzH7UNYIVSDVFWkTEOrldh7cxD4YMQESa1Vmz5QrJcD2afFl0UEUrz+ROcj9FR+f7Ya33SySEPeMTV1zrApiIZWk8H6hUdfYVUtA6ZpJytJUoeqGVfdhpDIsBdZB58t8v3aE63Q0Kdi8KuZnUYAbpZnCqpG5fcswS2x3SFKWe5Zf4O84BVLDOnC+Pucdr/MBem8uZ1oReNBVRCHUAMeYW/f8Nc9sRh5WFelY1PoamiVgF7NVlm/O/z0xTbQRw2hdC4/dRk8UV2ivkqPsINQtc2KUD0qyYYSk59yedW9Hu9PEXE3Eb7vNsW6/3kZR4HEBmzC8pval73nySA03JIdrGHAFBdTfYKogr/vo39e8zWJJ0XdT5NJ8AFrl3+sjL1aehgQk35dgu4gihFk6C5lJRFaQC/9phJCPjx+6QcWdGMg1QkkQ4NlUrs26al1RomT2YiGCSNVdP+Paie7WjdOcv/riN1zuEZ2cHisEZ2WiiWzWEwZkzFBmJUxxbjjBSOMjP6HNuGHSlXAqffJwr8oKPvTtWZIR/kHdF/KF4sZCQ84KHj0lDgB4gs/9kH++f9iBWfW6Jk7IGNILJ9VAanw6mAdwaw3oFTH++fuhTRCZhlUIaVF8H5pEXanx8iTb66h165xJ6s84QxQZFcpamVUT6cAToKjhrl2amDECEOKNznCxVwflFVUx0sATsswys/Huvry20J4Y8r4CONBylkuqRFfQ/JcsZ2SuswLDABRRgL8SElnkX3D9ce8DZWSWbiqIHqWHICFk0pQlkrGc6LtYSHXKAocZrLwrw5SbZbmp8HFmefBTKEU0p7n0LsGOJPg7o8TrxfEvK/DssLtCfTLnbu+1sZjj8jb3pSgGEG3+NI1DlcJnttkVt+4CM
 2YOpI1R3
 qNNNPNlcfC+fKlrL+bB2diM8EveCvbB5K+sfXiD2yV76IwjifBNg6OTbbzHG8Y3q9JtMcIoxUsddm5eHkp2VIG723fIXS1y9UXmvG7rfDZMutBapEyTELeY19xNgzQOvyg/INV2wY9TBVszXkugxkG5uqQFDYHnFyAZa+4QHzJ11IQ198KeIVJZIccrnwiRXZkQuPtBgPkg6mZMcDvg3PlIyNtLzVlS76x3xyEGRnZRgM/RlkD+LgBi3XstRoNx2sd1P0mg6Ien2rrB3qsEfmXOxuTyi9/sVKenOXQN8TcyHOH1D93numbxtg+sXeoua/3IxvZfDQw0e1ogKbB4hJkSBy3S2gJWjbEKD3HI9ff6wZutD+Vhq/I/r7pXF2EtJOx0GXt4z2QD6DP3ebva9TZctviiottA1PNzMkMSSwbHECoSAIeil+EQlef89P0ZTnzzgE
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
 mm/vmscan.c | 164 +++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 89 insertions(+), 75 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5ba880dce21e..a0807dd01c5a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1076,6 +1076,93 @@ static void folio_activate_locked(struct folio *folio,
 	}
 }
 
+static bool folio_try_reclaim_free(struct folio *folio,
+		struct folio_batch *free_folios,
+		struct scan_control *sc, struct reclaim_stat *stat,
+		unsigned int *nr_reclaimed)
+{
+	const unsigned int nr_pages = folio_nr_pages(folio);
+	struct address_space *mapping = folio_mapping(folio);
+
+	/*
+	 * If the folio has buffers, try to free the buffer mappings
+	 * associated with this folio. If we succeed we try to free
+	 * the folio as well.
+	 *
+	 * We do this even if the folio is dirty.
+	 * filemap_release_folio() does not perform I/O, but it is
+	 * possible for a folio to have the dirty flag set, but it
+	 * is actually clean (all its buffers are clean).  This
+	 * happens if the buffers were written out directly, with
+	 * submit_bh(). ext3 will do this, as well as the blockdev
+	 * mapping.  filemap_release_folio() will discover that
+	 * cleanness and will drop the buffers and mark the folio
+	 * clean - it can be freed.
+	 *
+	 * Rarely, folios can have buffers and no ->mapping.  These
+	 * are the folios which were not successfully invalidated in
+	 * truncate_cleanup_folio().  We try to drop those buffers
+	 * here and if that worked, and the folio is no longer
+	 * mapped into process address space (refcount == 1) it can
+	 * be freed.  Otherwise, leave the folio on the LRU so it is
+	 * swappable.
+	 */
+	if (folio_needs_release(folio)) {
+		if (!filemap_release_folio(folio, sc->gfp_mask)) {
+			folio_activate_locked(folio, stat);
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
+	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
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
@@ -1463,82 +1550,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
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
+		if (!folio_try_reclaim_free(folio, &free_folios, sc, stat,
+					   &nr_reclaimed))
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
 		continue;
 
 activate_locked_split:

-- 
2.43.7


