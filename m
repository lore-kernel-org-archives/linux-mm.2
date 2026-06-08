Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48184CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7B26B008A; Mon,  8 Jun 2026 10:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88186B008C; Mon,  8 Jun 2026 10:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5AF6B0092; Mon,  8 Jun 2026 10:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5906B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:32:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C57D4014A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:32:55 +0000 (UTC)
X-FDA: 84856987110.14.689C135
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 32C321C0012
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:32:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s8xurRHv;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780929173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NpXdeW2+VxVHgAaRthUZp9b/EfHCWgl273UAxmNpEpM=;
	b=SqYKtF+jjglUv5T101RcYTFwzo0OXRoSmWg57VwQnGK2DuFUcHLDxvYalPoMqBOdr4jx+p
	7EMABJZyRPWD+Pamf/uo6bNZBWv+mtcL/5tqs3K2QVqiNfGvsVDmjJShE9GrAL+9F+4wn7
	R1YtBOQuFIHNflolclY9k4lMwmXyM1M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s8xurRHv;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780929173;
	b=jkDQ+cOZ8mngvUJVLlgVNjCMfqX4RGJCbgI9Qg0NaTBDlNnyNC+H/swmZ5uAeWEV+mlKOj
	po1J7AHH+vcbHju9pxNc1zxL1IVC1Fp3Se+CrjG58mlfF2+lDRlBFXu/EuH2Qupaci7VX6
	X+KB4Of1b+lLFK4pjVQYnOMAscuilYA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780929170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NpXdeW2+VxVHgAaRthUZp9b/EfHCWgl273UAxmNpEpM=;
	b=s8xurRHvHU0L6YNm9y+gyEhAsd41NBJI9TC/Ly4NuPVLTeEZUCpstcnmkp7V4iuhyl4/gG
	NuUHo03QMRTKp2/xkoS04hl6TNu8BewP2c5LSxOCalRaWLtdbzczzrBoVma+2tzYnQSsxY
	p01NR11yKj15PqjsdKsOU06+Tbr9+OM=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	riel@surriel.com,
	david@kernel.org,
	baohua@kernel.org,
	baoquan.he@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] mm/swap_state: remove unnecessary lru_add_drain() from readahead
Date: Mon,  8 Jun 2026 07:32:42 -0700
Message-ID: <20260608143242.2869392-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 32C321C0012
X-Stat-Signature: 68aioj1r1eaxjdfxbxay89d3a63q98tg
X-Rspam-User: 
X-HE-Tag: 1780929173-248163
X-HE-Meta: U2FsdGVkX188i6ZYbEskgMwZ+ZorWggu904OwnYK2SrhD5h5ZmtTpgNJ47FqXiEXEJJv+rxmgYxdvd0JegvTwllwNnHRWRaF19pABEBgKJF4ujkwvSTSI3f612rKrF4rnAO3KtcnmyNaF4PUTrRJlTvC7nEIXFwVH1iIMuoD/hiMnXsYywZsTM1Ii6J9kxe+IE6jxYxTFcNFCpBJrZeV6E42V+cBAt6YmFq0woWugRvjbw7BpkrxF68Ga1iyFO/c3S02sgYtrd36CXADrmtsLmfPJwMdjJ8/pPUQkxVLoMZpD7fLweEfpAs1QRBiFK7Tnhebckav5BRSaOgwEjQiGBf0z2SfRkJ74LMk7mhK6Djv61btapAo+WHkf7/Iir0phg7pxgutoh/KeSdj0iEliGL7gccHtTSg7uuWorXqnGlwZt4Tt+IKY0bLSJlHOmPd+kWa0TZHHQxFjthcBO8dpJB8dKt4odaHCn1RDNq7Co+Eniq+yqkCyAhlfFFzBA37BTgjZly39g9AfAD5AQpiVmDCFqZq1nnjYzCQHsgf43+V4L1KO36Bd6f4B2hLjpUhXJW7ehmu+9nLBpbA2loQEaIJDFmGGR4WzVYZU/OgB5bIetgOAC5jXs5DijHnD6ywkiTlYud+WAZ9SbcHNu9a5iShvEr0PXAfNqe4gdQIpr+WvDsdTuwPp29bx9LH9gIIEBC+L81sZRUT+fQ+tcRkFoa/mfq1gGhne6KGUpPT0DA1gHcKuo0shh4DjW3K7soXQhA0c7GvpKu6P4T1VDxxGkE9VXNXQs++awbfzbnGW3T9y3kZCkqXG70W0qEMNYMWiEGEL4n1sEVzeROntSjZk/Zx58pq4ebO+Kop0CVApZAnptnoIkSffwNHfV/snhfLC5hc/ywp+M4BP857n80UW/QiusUs5p7HT/A94FBD4gwyYNLYUdTeJvfuHYRXl2dq8RrcfH3K6jGFMQRFUFB
 I3D295gD
 aAfn+adyJNERWoZsvz0Fsi2GY2qF1RS4RZyv+CFZ3sWTWnAFSwIFmWapF/9u+TwbAeuLzcfV3U7enqDfDCMSbrz6R0bznod7yMWdixPUFlI5xqAkbmE7mSDawmvbVefgzKI2OkxDxR2QQ+OiE3yGmV5SKnHn+eBel6Ikt1++kn5JcTW9Dn78b2cTptdQYStoymn6IpaUCuxDGC6m2Yk7TgVt2dK40ueGK6mXUWvZvg1PEMl903uDk3ECfnzyY27lIOUe4bHQVq6CMyFXFbIHy9aDzw9mOVoN6b7iMvyHhGSPhisR2EqYusSF3eWt84E41Y5OvXWiSRqM1egA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swap_cluster_readahead() and swap_vma_readahead() end the readahead
loop with an explicit lru_add_drain() call. That drain is a leftover
from 2.6.12 era code and serves no functional purpose for the callers:

- do_swap_page() ignores LRU residency for the readahead folios;
  it only needs the target folio it called swapin_readahead() for,
  and if the write-fault path needs the target folio on the LRU to count
  references accurately, it runs its own lru_add_drain() at the
  wp_can_reuse_anon_folio() and do_swap_page() sites.

- shmem_swapin_cluster() immediately locks the  returned folio, waits
  for writeback, then operates on it - LRU residency of either the target
  or the readahead folios is irrelevant.

- try_to_unuse() likewise locks the folio and calls unuse_pte() without
  depending on LRU presence.

Folios newly added to the swap cache by the readahead loop sit in
the per-CPU LRU folio_batch and will be drained naturally as the
batch fills (FOLIO_BATCH_SIZE),by the next reclaim/compaction
lru_add_drain_all() and so on.  The unconditional drain only
synchronously flushes a partial batch and forces contention on
lruvec_lock.

On a 176-CPU production host running a memory-pressured workload, this
path was observed to call folio_batch_move_lru() from
swap_cluster_readahead() ~28K/min, a very large source of LRU lock
traffic.

This is a direct continuation of the cleanup started in commit
1aa43598c03b ("mm: remove unnecessary calls to lru_add_drain") which
removed the equivalent drain from free_pages_and_swap_cache() with
the same rationale. A detailed reasoning for this is present in [1].

Remove both drains.

[1] https://lore.kernel.org/all/dca2824e8e88e826c6b260a831d79089b5b9c79d.camel@surriel.com/T/#u

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/swap_state.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 9c3a5cf99778..6fd6e3415b71 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -836,7 +836,6 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	}
 	blk_finish_plug(&plug);
 	swap_read_unplug(splug);
-	lru_add_drain();	/* Push any new pages onto the LRU now */
 skip:
 	/* The page was likely read above, so no need for plugging here */
 	return swap_cache_read_folio(entry, gfp_mask, mpol, ilx, NULL, false);
@@ -951,7 +950,6 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		pte_unmap(pte);
 	blk_finish_plug(&plug);
 	swap_read_unplug(splug);
-	lru_add_drain();
 skip:
 	/* The folio was likely read above, so no need for plugging here */
 	folio = swap_cache_read_folio(targ_entry, gfp_mask, mpol, targ_ilx,
-- 
2.52.0


