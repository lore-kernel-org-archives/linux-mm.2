Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E12F2606A32E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=MkHKRRT3
Received: by kanga.kvack.org (Postfix)
	id 1625C6B05B1; Mon,  2 Nov 2026 14:31:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113506B05B2; Mon,  2 Nov 2026 14:31:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 001516B05B3; Mon,  2 Nov 2026 14:31:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6AEB6B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:31:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5260214024E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:13 +0000 (UTC)
X-FDA: 85391172426.15.4CBDD0D
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf30.hostedemail.com (Postfix) with ESMTP id BFAEA8000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:31:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Mk HKRRT";
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793647871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YPfpT7MleReosEONdKQjTcxQoMMph5Kp2X65XVOMl18=;
	b=g3+fbLhnKNra2dw2avlJMCbDmyU87I2+lchLKmbAxR3ussxVUDQVwpa7c4mWie9N2JKVwE
	CVwCJ3QaNYoYn9PGUryAT4dKRHbMPki1xYcdxwbUxYisw5JHTrKT9ipyz8BLxWWJ+DM+Fu
	kIafd2D12DmRPEpIKz4hl91pu5lYQo8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Mk HKRRT";
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793647871;
	b=PCaMhILX2DQ6HrcGbcromCtBzFO5rmvgAGQxBSqr8xWQ0ymrMTf9YeafPqscafG65beF2l
	BItFIu/xz8j2r2rV5Wa6KekTrSYJmOWYyaS3FQDXwSO1lb2+8FdxcIyMj54fokBXeO08d3
	kutljZHn8rA/yJRfuSnVzhB1gUNJeQk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=YPfpT7MleReosEONdKQjTcxQoMMph5Kp2X65XVOMl18=; b=Mk
	HKRRT3sSGwvuIn3iZuGMA+rnNVkj1LttcKh3o223BS4OYKbwSVK6c787nn4l5ZyTvfSOhyd3rUY0L
	9PAmyYGUFaD1qYgykV4Fwfz0LTASe8HmuZlPZKLIxk6z4ekVPNE6pa7GT7yn/kttRu7oKdl0Jxllm
	wk6PTIMvuvpTnf+EUkqUtnFtkCuSlHbGAte6XyixNIHsBFIqX39c6/vMZHEQXI13piJfgUIIosXN7
	TFavLf2ayaBgRuSOYBec7YUyJG2Fq6r6sbS395DBgmGpJlKZc8HTV1GFx0SpK5WGTIXYy0M1u93OR
	qULj0zxR1fzxteONm9LnGBS+sZhaWdYQ==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xNxjk-00000001W8x-00Cc;
	Mon, 02 Nov 2026 19:30:32 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 0/8] batch lookups in follow_page_mask()
Date: Mon,  2 Nov 2026 14:30:18 -0500
Message-ID: <20261102193026.3860700-1-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p68hyhgm8fjk5wbdes8kxjpzqfaqca9i
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: BFAEA8000C
X-HE-Tag: 1793647870-143724
X-HE-Meta: U2FsdGVkX1957hQfTGTIb/n6+CFoxSNqT05otOfPLI2LHd49Ead82mh14Cf2YqbCjnfjZCH8Dl2+2FDuJU75OmQPODRMusAuG954ueaMMlEPEEGaRBei0iaS2T5HZRo4NuzqlNqD2IhYeVUi/F+rbQP0pP+jba59E84f+vZh5zZ2xqfFiiTYBxw3zb7uEzD/kfyFGVJAom6RawMLVRp5bTMjE4W0a3sZZ3cOnwWe1aSSiKzLfaeeiOfPxYKEZbiVzy9Eov9B98bbL4IM2uklgHFjSExm6cOz+7HS55gwL/+3STv4s9NLC0jvhIIHNUe1Bfdrs9fY4htaD83Jai0aHWBe7YVxOfmu9rt+0Gip8HlOpmTGqL5ZWWK9g0z99O2GCNu2Iu2sgvfKk9q/0WqcHlymezSf4QKDBo18maMRPc+gWx07kCYGX40dqGwoE/O7pMh6Q1GYH40Bi+TU/6qdv2DIUnC9FFIYDPsP0Pc9JmKL3Fcvuuh0C04yhX0PlFE8Ivsn/WPAQ8z80sMrHh2eO2ZqNoGYxIzsKHIp1wUhNYvKZ9b4OtZNFez+xVQyBfaj7VQtOCT08hLPbsvUsUVlKW7It9joCFw5CCDXLQ5vIDiI8C4dLuK5yHjJjaZP5LM6RUhJOuZPDnc7mGMqTJs6KNwBsVTsdqcY5mienJMZISdWgWvP0YtakIFSC9oNv9myeTykHAaIYj/UKNrmzXj+Prdy2hjO4kTVO6XMsDjO2t+QVF+EXeF9soxDLXp+wgKrluLFCPKTcCM1Xo6vD4ok24PQSwcjn93+xK/Y0Kwm9cJyID9pAqU/QnOeWsbXaWScnXXJ5owY6JSOKFefx6vEpVmnQ8i5ZwZv8ZteYUrLJl5If+2hwyrcjHwmA+jNDFsE56KOXPXkYCB7qM0JA7Zb13rNn3GodK7IdSP5t31qKCDcojBWqKATR35pQdcAnMOs+gPuqwRcoti+ff+qKDg
 fzPx/IIS
 wa/Ee/2mySRVJEZ+NMTecXLKk7cPcev1foM+KJh7BP1uhCgoI/iLZblFxdUtSoz3M7hzG4t3HU7uDTAIavtaVGRnpU31zhEJsLn+WBngntS5gF0+4vtyuaGnXvp95laTfBBhgAmUQ3inBhZU1oAU+pPpSGNeOz7D80KjEjYbSde0Q3PJyzMh6GZtLMb6fhooglFNKPxKPafY8SckbRa+Uc0uZ0WOdk/QllXYIzlBYkG//txSvslNDJBpUzLLTYL+CaC5RY9nfidEeu9Nflb3O4mVGXTXT1wlN7p/VtE4N8oU6RwqD1eOEm1XOlxHPtn2CHLT2Wkwr6YuAYcnIaI5s+sZ8VlJBJzQwPJPUIagC1/DMTEJ42q8gkS3AixUDJMrVnfgXXldEkPjgED5/OUoo6ojOD+jipzQZ3z/gZ2sZ717FMUNSxoOkN3/KkpJ0GEzzmg+mZ/n4T9jFDBufjySmHWT3Fd/eFHaUTg7WVKWOhfBfd4qRJvsgmOwYIaxm09404sIyvafp8Hx57+SIcyowg1i2AcaM0+8wKbYED+lTGw9ZvVeSorevB8z3a8KFL/E9p/8V5//QE6Ptg2IxUZZ7xbD1GQGElVN4vupSNFNcI+PXsrQHb+9YqmZU/BWy1kgJNViE60IRyEyppf5mnqGs2soWtNZERwlk9LdLIHb8iN+VPS8ms/a9p5c8ptwVr39Cb24V7hQNAFO08fQQ4Ciek9U5MfMbE3PznL/l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

follow_page_mask() walks the page tables one page at a time, even when the
caller asked for a whole run of contiguous pages. Every page of a large folio
re-enters the pmd/pud/pte walk and re-takes the page table lock.

This series changes follow_page_mask() to return a page count and fill an
array of pages, instead of a single struct page, so a walker can hand back
more than one page per call.

Patches 1 to 4 are preparation, no functional change:

  1: move __get_user_pages()'s open-coded pages[] fill and cache flush into a
     gup_fill_pages() helper, which the rest of the series reuses.
  2: convert the follow_page_mask()/follow_p4d_mask()/follow_pud_mask()/
     follow_pmd_mask()/follow_page_pte() call chain to return a long instead of
     a struct page pointer or ERR_PTR(). Every path still handles one page.
  3: split the "grab a folio reference and store the pages" tail of
     follow_page_pte() into gup_grab_folio_pages(). Storing runs under the
     lock; the cache flushes run after it, via gup_flush_pages().
  4: split the "work out which page this PTE maps" half of follow_page_pte()
     into gup_lookup_pte(), leaving one unlock and one exit.

Patch 5 has the huge page paths store the page and leave the array fill to
follow_pud_mask()/follow_pmd_mask() after they unlock, so the cache flushes
happen outside the pud/pmd critical section.

Patch 6 has follow_huge_pud()/follow_huge_pmd() report the huge page's real
subpage count instead of a separate *page_mask output, and retires *page_mask
and __get_user_pages()'s try_grab_folio() call and subpage loop.

Patch 7 walks every PTE in a page table in one follow_page_pte() call instead
of one per page. The slots are stored under the lock and flushed after it is
dropped, so a whole-table hold does no cache maintenance under the spinlock.

Patch 8 adds gup_pte_batch_len() so a contiguous same-folio run is committed
with one refcount grab. This is the only patch whose benefit depends on folio
size; patch 7 alone covers plain base pages.

Patches 7 and 8 carry their own benchmark tables, both measured against the
base of the series, so the split between the two mechanisms is visible: the
single-call walk is worth 2.3x on base pages and 2.2x on 64 kB mTHP, and
refcount batching adds a further 5.9x on the mTHP case.

Yuan-Hao Hsu ran the v3 series through mm selftests (DEBUG_VM, PROVE_LOCKING),
a GUP-vs-mprotect/MADV_DONTNEED/MADV_COLLAPSE/fork race test, a mixed-mapping
core dump test, W=1/sparse and arm64/i386/ARM builds, all clean, and confirmed
the wins with pin_user_pages(FOLL_LONGTERM): 64 kB mTHP at 256 MB goes from
2318 to 249 us, 4 kB pages from 2361 to 1065 us, 2 MB THP unchanged.

v5:
 - rename the new helpers to gup_lookup_pte(), gup_pte_batch_len(), and
   gup_grab_folio_pages() (David)
 - rebase to 7.4-rc1
 - document that folio_mark_accessed() now runs once per run,
   leaving a freshly faulted large folio referenced but inactive after
   the first call (Yuan-Hao's measurement)
 - note (in patch 4) why the recorded no_page_table() call cannot newly trigger
   on a FOLL_WRITE failure (Suren's question; answered in changelog)
 - add Suren's Reviewed-by tags on patches 1, 2 and 5

Not in this series: a single bio_vec straight through pin_user_pages_fast
for iov_iter_extract_bvecs (Christoph's idea) stays separate work, as David
suggested. The series does not change dirty-marking semantics -- a batch
only gathers the dirty bits its PTEs already had -- so the wider question
of whether GUP should mark folios dirty at all stays where it was
(John Hubbard pointed out the balrog in the room).

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yuan-Hao Hsu <aa9736195201@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org
Link: https://lore.kernel.org/r/20260811025157.1632867-1-riel@surriel.com/ [RFC v3]
Link: https://lore.kernel.org/r/20260801031540.2742891-1-riel@surriel.com/ [RFC v2]
Link: https://lore.kernel.org/r/20260730035350.1fc95dd8@fangorn/ [RFC]
Suggested-by: David Hildenbrand <david@kernel.org>

Rik van Riel (8):
  mm/gup: break out gup_fill_pages() helper
  mm/gup: convert follow_page_mask() to return a long
  mm/gup: split out folio grab-and-store helper
  mm/gup: break out gup_lookup_pte() helper
  mm/gup: fill the pages array outside the pud/pmd lock
  mm/gup: return a huge page's full count from follow_page_mask()
  mm/gup: walk multiple PTEs per follow_page_pte() call
  mm/gup: batch contiguous same-folio PTEs into one refcount grab

