Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 621B8CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB8E16B00C3; Fri, 22 May 2026 12:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C903A6B00C5; Fri, 22 May 2026 12:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD146B00C6; Fri, 22 May 2026 12:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A80376B00C3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:24:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5505A1C2002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:48 +0000 (UTC)
X-FDA: 84795579456.20.2CFDC7E
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id BC54C2000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ibg5Vx7A;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779467086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PicG0VGaxNfqAf+Vsr+MRf2Lg77IxoCYcktKo6m1Qck=;
	b=6rkGAmGA5vqTWKa5YwHmMVPVtc8u1AvzhRaSD5LfBZiSui2b6mO2sbesKANoEDfQ/ug9kK
	3bgisHi6Ym/lPym4fHQcmHOjX7pAqyPL/1OEsEUgjgstPhw+n83IjsYTi6YV82BTnrkv5z
	gCT6ne77u1Nf3DTIYcXv1/vnSTnUbJg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779467086; a=rsa-sha256;
	cv=none;
	b=mSq6702fD1CeTPf4V7P5BIeQoOCQWU72G+wUNr+XXJElKSJEIkfaAzSDvbecNXOnkBnGar
	jKLLaMLa/5VePRXGyzgvFVP91mkzXNHNBh+l0wdP6iaxj/XrJopUSrlNxCKOG1jyF3W2Pa
	kN0nNe7Ibk+r4nq5a3dSpvPROWe63y8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ibg5Vx7A;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779467085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PicG0VGaxNfqAf+Vsr+MRf2Lg77IxoCYcktKo6m1Qck=;
	b=ibg5Vx7A+wVts3v0jvELrcgu35RAsfd9NMBDgdHVI2I4/3psC/DFKMs3uVXAeo8KquzM+C
	nx5ARqZbgApa9UptBR7iV3upH3Z43LfvtMI68/Pdozxl84IsBvqwCoQSWYDOgg+Xccwa0C
	8LNgGzd8ZjTQt+8DYDpl683S3yYyUwg=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	willy@infradead.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org
Cc: r@hev.cc, jack@suse.cz,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev,
	Liam R.Howlett <liam@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
	npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
	rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@kvack.org,
	"linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	kernel-team@meta.com, Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v5 2/2] mm: use mapping_max_folio_order() for force_thp_readahead order
Date: Fri, 22 May 2026 09:23:48 -0700
Message-ID: <20260522162422.3856502-3-usama.arif@linux.dev>
In-Reply-To: <20260522162422.3856502-1-usama.arif@linux.dev>
References: <20260522162422.3856502-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: draisbyiur7hfc81c4a5paufi8qmrwen
X-Rspamd-Queue-Id: BC54C2000B
X-Rspam-User: 
X-HE-Tag: 1779467086-642270
X-HE-Meta: U2FsdGVkX19zMV54y+Cv51w1DnxXzJvypc1zIASre8Q9I2b7Mz3hd2Jx86FHL1kIC7NcSVx7r1UOjuvfwofV3YvGhqaQUZ7aCeeSzwc5c9r7uVUbXG7GVJwDVJV62+vAIs4F8JOvVqGJ5qroFTgX7OAkPPSQBO5m/pCZAHcHli4fvXy+NoiQyb+8t/fzYkNtCpNTPJOHLrJeJmYyu7iXHPK7sIuruCC1aa0p2CeuV64YioocnQm8oJ1hTmIq7WllymV1Z1VGT23Lj9JgUIm+iyFAy+UdC08E1Grpka9cF27As2MEhGFlTSkcVDoDjvQ9Yrc+wtTN7rYSoRRPhUcoO7wk9CSLg7j1dQh9PTHMKXAAxxA4elI63SRg3y3wMio57JO02g5XNx/xC/I9H2JWpnmKX4I8s2U4CSYqMomBMF6mGS5eLNM8GYiUs/F1o0wzVIixzr14rmHtHi6q9CKBFRNxOnQqJ/gf5w5Ch2rFExsxyMHaXldAIOabPJ6fGn8KgHukoz6m4TKjHQAOx0ekQre0NvRznqPbNL0887iP/FFlSkuqlPhd869ixWfMtvgBSxUwn+mFZqn76Y1M5RRxct0sbcim8go7t41dlEbVqF6lmtuYDvaMudojAnUL4BuBnuS0wGitNMJ9Y7dH769EAIZaOgGGR44dHfXx+bvkW+WvyS31cREkqNxd9ayqUVzR9IDD4Gk+HUMp9YGYvRNyajuCgRIRivZq8bJ7TXlu8s9TLEmoFqkBXp2/HEvXBuXhCfD7lTe5LEFrM4ByjAY3YrOoUam4Ai0SNgtBdbBZ0+TtIubB9Ma7g4WTFCWicK8ftNl0spY95waGonk58n/7IEXxP0jG6nzVQ5f5W6YWruMuIw/Yst/pQ8OiIoo6G3ZWAVvEzvykshB4RrStemqb5Yk35chSNpUqQ4t7/Sjd9Hu0s/rDypy+qnpMNorN0/JaW877QSy7kdZiDYwsnvG
 N8wu2Ngt
 KkfFb/M1lyAwcgNJLpKfAzwCXZR70477910W02PmJJzvR+qH0vHH3OP/JdvFEDqdh0kE1A29hOlsyU5Nx72UOOfzgeiSxpAyUdnR+gVkTL6o4JXfU8Tk0YDkqEIxOSmfcY4bfIXVp1IgRAPpDbE9uki4MP5tNgaqD4afcfYJ9b1UT9uWnc+KB3O/NVJkmAOLCfqUiFuayExr1Nyme888IC68XEgVIAw83HlLA6txl/S6EPCL+FOb2XtlOf8J4/io90YsFrpW670WbsajSRSqKWR1etA1GI+h/2DyA+iWl9Ie1gN6DKATmYxmLMGaMjLtAFeB5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The force_thp_readahead path in do_sync_mmap_readahead() was gated on
the compile-time check HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and
always drove the readahead at HPAGE_PMD_ORDER / HPAGE_PMD_NR. On
configurations where HPAGE_PMD_ORDER exceeds MAX_PAGECACHE_ORDER --
notably arm64 with a 64K base page size, where HPAGE_PMD_ORDER is 13
(512MB) -- VM_HUGEPAGE mappings could never reach this path and fell
back to base-page readahead, even when the mapping itself could serve
usefully large folios well below the cap.

Widen the gate to

  min(HPAGE_PMD_ORDER, mapping_max_folio_order(mapping))
      <= MAX_PAGECACHE_ORDER

so force_thp_readahead engages whenever either order fits, and pick
ra->order accordingly:

  - HPAGE_PMD_ORDER when it fits (existing behaviour);
  - otherwise min(mapping_max_folio_order(mapping), get_order(SZ_2M)),
    capping the readahead folio at 2MB regardless of what the mapping
    advertises.

Size and align the readahead window from (1UL << ra->order) instead
of the hardcoded HPAGE_PMD_NR / HPAGE_PMD_ORDER so the chosen order
is honoured end-to-end.

On arm64 with a 64K base page size this lets VM_HUGEPAGE mappings get
large-folio readahead at the mapping's supported order (capped at
2MB) rather than dropping back to base pages. 2MB is also the size of
an arm64 contiguous-PTE (contpte) block on a 64K base, so the
resulting folios coalesce into a single TLB entry and reduce TLB
pressure on the readahead path.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/filemap.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index f45a1b74870d..56fa715d66cd 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3317,9 +3317,16 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
 
 	/* Use the readahead code, even if readahead is disabled */
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE) &&
+	    min(HPAGE_PMD_ORDER, mapping_max_folio_order(mapping)) <= MAX_PAGECACHE_ORDER) {
 		force_thp_readahead = true;
+		if (HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
+			ra->order = HPAGE_PMD_ORDER;
+		else
+			ra->order = min_t(unsigned int,
+					  mapping_max_folio_order(mapping),
+					  get_order(SZ_2M));
+	}
 
 	if (!force_thp_readahead) {
 		/*
@@ -3354,17 +3361,18 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	}
 
 	if (force_thp_readahead) {
+		unsigned long folio_nr_pages = 1UL << ra->order;
+
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
-		ra->size = HPAGE_PMD_NR;
+		ractl._index &= ~(folio_nr_pages - 1);
+		ra->size = folio_nr_pages;
 		/*
-		 * Fetch two PMD folios, so we get the chance to actually
+		 * Fetch two folios so we get the chance to actually
 		 * readahead, unless we've been told not to.
 		 */
 		if (!(vm_flags & VM_RAND_READ))
 			ra->size *= 2;
-		ra->async_size = HPAGE_PMD_NR;
-		ra->order = HPAGE_PMD_ORDER;
+		ra->async_size = folio_nr_pages;
 		page_cache_ra_order(&ractl, ra);
 		return fpin;
 	}
-- 
2.52.0


