Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FB71606A33E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gt5aVK2I
Received: by kanga.kvack.org (Postfix)
	id 8E2276B05B4; Mon, 16 Nov 2026 11:10:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B9896B05B5; Mon, 16 Nov 2026 11:10:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9526B05B6; Mon, 16 Nov 2026 11:10:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1986B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:10:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B028116015F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:10:33 +0000 (UTC)
X-FDA: 85441469946.27.8E10AE0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 634F44000C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:10:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gt5aVK2I;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794845431;
	b=UE8BbjTV7waFF+TBYM0WccThehEf8jAqbMZv+1bcpYvxipMsSy9DKRGAPomNun4JN0wjAk
	ZZT0JD9Cbp+IiN7QWRBbaHlpDjTwD0Lv1cr+WgaEP9bjsyCdmOBOaa3CawikPqELATSiOO
	60fma4ZUkm0TrI/LHo79QGD+4W7Uz7A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gt5aVK2I;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794845431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NA1C7yoroVL06quzgnLBMUHJrAMFyXt5rvTfApVfqGU=;
	b=LEHaVALc7n9puWErMpzDXkI57z9KHf6vx1PGnzFTb/pIqFcuARwuzFbdvR1Ie//obiLNTS
	U4+Bg+vJ2tIGJ6bYa2aTP/p3i0sTu9akKwLDIPZDzu+gqwk++0TQGeHivCQshmf9ABrqny
	9zgQe4jnDibrY02EEXHk7zUz90qhii4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F14443B39;
	Mon, 16 Nov 2026 16:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083081F000C9;
	Mon, 16 Nov 2026 16:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794845430;
	bh=NA1C7yoroVL06quzgnLBMUHJrAMFyXt5rvTfApVfqGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gt5aVK2Io7gyf94m4U4ixmmw6U01jBsq4wOuBkAnsn68OwFVODhWLKPjTD3NofB2P
	 JHKSVsIUDZ3NNJN2R4+MOtgqLeDSCy3f6h+uUmRQYmb/7wIbiC7Zv9RCIoltjV1AGD
	 RvvcxiqouhkQsnmZPRHozJRYgKHuuwDNZz6D8b42NJENcRYVN3Yp2vFA1/JL6f5XeY
	 65tjhUKzJLvs3rWccmUzgcMZaGVUAbRscz2cY1VB9W6BI5gMspk0tlp9Tbidw745e0
	 elrtoBKvRAta69Jc4Z1GruvLfZrKng4LNnrgkpvku1ew1K4ki6Zjn40SAVXXN6v1cT
	 XsMK62KioYMZg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id CB6BA198003A;
	Mon, 16 Nov 2026 11:10:21 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 16 Nov 2026 11:10:27 -0500
X-ME-Sender: <xms:7Sr7amEFp3rk5kS4DhQPCDN5C_AyJnjEn8SVMZhAktj3A4iaY7EpJw>
    <xme:7Sr7am4u9iieCqodw0t1Eb-RZq9Q6plVwPapUsWD9pQXYoVcIoGGAdxnSMjn8R26c
    NiRzAPXBLnIY-yu4ocBx2SZI-GQSJjUzkgEM2LQjW_1ejI77qzaN7yW>
X-ME-Received: <xmr:7Sr7akM6pC0z-xuIcebY4YkhZIWya_v8EXzeAcFnJv6Um8NCQN23H9ADXas>
X-ME-Proxy-Cause: dmFkZTF/ImuQq9XU23DBSCdicYzV1eBj/E7gxuq27UlHGpvX3pRJFOxPTG4J3QLoRiBcdw
    RQU6URnB9LLd303PYEzHQLl3dmM/e+lBoUoG7GK5Nu9rTFsJV7gBRlyQpOVWCu2jzVoIPX
    ZJvZ9T/y+PuMBH6peZtK4XbQxCnASHrnGYknJc5BsB0kD3ckjVfY4Y07pYP20q0OtB0hXF
    SMyPWjPp1ElqtMMJzVOIBEuWG8aWsirL3bThfOwzmfce1AWMbsSDPu6aVF3AVVHpGrMMFB
    bo9QkWqStmL8IWHE235Cm0++DFOOM/0uXHClf4HD7RJceyF+40JQMDQ0Uh6nM531nxwIcn
    vcmHWEHvRzJSJMg2GxNnULJMFYtvhYWSjzMrJ2OlCurAEDTnyVTeRFyDY83zgRG0Hny1tz
    S5GWqrkBbqjbLe2zDVmLP+oBYBouCvEkhnJ7CP9TM+CxXCeQBAqG4oLCviTGitzRHJvA64
    kYEzK5EUP+SJK7O+MN/dryYMEcFyjaq/rS5A+b5beRrkndRaztbAgSvEIZQoel2tEc9Kbu
    94yDwyXhXWstqJZVX5L+mvJ9cYx25vZx0aZS9CrNLPbR7ab76oMBGavzg6NqwJgdE1q5w9
    nn7ojmaCsocFooIbgh+OSCiOOTTbMmL7lBRWYr5AONBBRZ581jeCPChpHwXg
X-ME-Proxy: <xmx:7Sr7av2Pe35n9oTpH4wPcAZblzTkwqyY6weHWa70rKj8JtQWoTL4sw>
    <xmx:7Sr7ahIz34DCDvEVlpGWvJrHN_4biw8sPsOs4cdxaKgb_9eBfhGF8w>
    <xmx:7Sr7avKwH9sAFIIyyXXR7X38OJHFNQRwNp2606BKozDVWVfpjbjuJw>
    <xmx:7Sr7aigaxIHYnBQdGOl9SktAKmi69OhJMcNbHT3Rdij-YUo09kXhfQ>
    <xmx:7Sr7aqR_uP6B_-4nCNVopbBpmZ2Kqts_hEKkhMZSoB6Z9VCW6a_i4MCR>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 11:10:20 -0500 (EST)
Date: Mon, 16 Nov 2026 16:10:19 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Andi Shyti <andi.shyti@linux.intel.com>
Cc: Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnd Bergmann <arnd@arndb.de>, Johannes Weiner <hannes@cmpxchg.org>, 
	Hugh Dickins <hughd@google.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Ross Zwisler <zwisler@kernel.org>, linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH v2 2/2] mm/huge_memory: flush dirty file PMDs before
 removing rmap
Message-ID: <avsn7l_QxT3rzkXI@shutemov.name>
References: <20261116-dirty_file_pmd-v2-0-571883053174@kernel.org>
 <20261116-dirty_file_pmd-v2-2-571883053174@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-dirty_file_pmd-v2-2-571883053174@kernel.org>
X-Stat-Signature: 1u7ogx56k9ad87i3a3qzz8ym9qagf956
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 634F44000C
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794845431-261644
X-HE-Meta: U2FsdGVkX1879GfEsYQ/8gRDKpVdnnptJ+E3YVFto/HZ4MII9+AfM3wBGqO6IMXnrpWPGSezxZMMX87oSrkER1q615JbSeeODIGn6KupEcoQh4nc/4x2xENMuBo0+TVfuVDh+rMgA9ONXrWyYSYgp2ADhxZiFp1QFlwlgCO4A3CgKUMkhOAlG3kgUiIF+1AxDlce785gkDWfFEyEvuffOiHcXN6mNDCZWcVlthz5koIpd8r5txrYzosviApimwEBpHC8trXC4MlP8hPn/9iFUu5EtaO4RZSWTnUbUU107etTpSHVCGdNSCo4gUPIO/zGHAccHr0ZxGNALeJH6VN6H4l/c9M5zZN0wluDOAYjeRyAT3K9963QQmmBpJJsiJ3mMjucaaXHv3xDGCq72bqoBXO0bZ0fvA9HXbZC0BeTSKXcHmRYe23t1uBPyqUy0DglGpMuRShrLd9cFRwaEcKHP+DsWQo8GE0IinaOljbBieq182qByx/n/1biFyAf/xGzmFrso0m11ZNeibV/c75Nhn6aNuGHyw/mJ++MAzm1U18gDm0tT0esYTkcHUieXNmd6SkWVJHTwdnFnqFwsv64OkMEozeW9Ea00XdS1tNZ+nGIQUyJ4ZgzdiyieSEcd5EG6c8EGiHVF+uRL/1iXryrA4zu/C9phwvvYUs3ZYgvQwzCK1kxXtHa1PpVDWdHu/EVa78ypZQxrZKa3XztuFxL053qD+1qaT00OHdIp2QriSNnKSs2KHtwJ3JVUX9DRZe1xJjECrCEF3nA4qMG0a0LBu3rDAK7Cy1X2CwldahCIp57YVJc1nO5hYL6Kjvd55eStYYMjuC9cEWtqs3C+AQCMVmT8ZlgqMjZCi+tzPRUNkizeCzt786SeqU9nV94/yCSQDn3qDBZEBFmSWlSd6YSJUu5LyXXR+yTtfRYV6oyzcIMccUGTOHNa8s219TPp6aAOdkt+u/ln3RHRbOWi9T
 Yj7s6Pgp
 onR73SclTD/DJeT5Io26NgbfCd+o2Jw75OLwrWPBVFCRlxIBrTKztsb+BQdCG6caKGmp6QeLnJL4DrpghYsm/vuCMJVmBwZWy4nkKvNEqqMi4s4JBuIIT5ZChKbhp7jkg4xViugggB//VuHa6H7QQQe2Am2KrBF8Z4rTr1Jx+/EHwX3GNAVlMBZryBZOntFbSoUgqx+Y6bBnSIdmCZL89wPQr2PsfKX11m3nQ+CIy6OlI2zt8kkd5QficwxsbMnSU34OJmUKqjeVfLITixjzmvhiGu0J/1yZDugu/tezkPdaNfnY9Szd+cQTHTaJIYvTZE8Ds0j2eVwxpf4U731doWYvFAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 04:06:59PM +0100, David Hildenbrand (Arm) wrote:
> Unmapping a file PMD can lose concurrent stores when it races with
> writeback. zap_huge_pmd() removes rmap and drops the PMD lock before the
> gather flushes the TLB. Writeback can then clean the folio while another
> thread can still write through a stale writable TLB entry. Those stores
> do not fault and dirty the folio again. Filesystem DAX has the same
> problem with its dirty tags.
> 
> Commit 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB
> has been flushed") fixed the same race for PTEs by adding delayed rmap
> removal to the mmu_gather infrastructure. The PMD path still removes
> rmap before flushing.
> 
> Flush the TLB under the PMD lock before removing rmap for dirty file
> PMDs. Skip the early flush at address-space teardown, when no users
> remain, and for mappings without writeback, including shmem and device
> DAX.

The patch looks good and you can use

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

But my LLM machinery flagged that __shmem_writeback() might need
fixing. Normal shmem doesn't have writeback, but i915 does its own, and
it is subject to the race.

+i915 folks.

Possible fix:

-- >8 --
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH] drm/i915/gem: Skip writeback of shmem folios with extra
 references

__shmem_writeback() writes out every dirty folio that is not mapped. A
folio stops being mapped when munmap() removes its rmap, but the TLB
flush comes later. Until then another thread can still store to it
through a stale TLB entry:

    CPU0 (munmap)            CPU1 (same mm)       CPU2 (i915 shrinker)
    zap_huge_pmd()
      folio_remove_rmap_pmd()
                                                  __shmem_writeback()
                                                    clear dirty
                                                    !folio_mapped()
                                                    shmem_write_folio()
                             store via stale TLB
    tlb_finish_mmu()

The store leaves the folio clean in the swap cache. Once reclaim frees
it, the object reads back from swap without that store.

The legacy mmap ioctl maps the shmem file directly, and i915 mounts it
with huge=within_size on some platforms, so the folio can be PMD-mapped.
The core mm keeps the rmap until after the flush for PTEs, but not for
shmem PMDs: shmem has no writeback, and pageout() refuses a folio with
an extra reference.

Do the same here. The unmapping side holds its reference until the TLB
is flushed, so a folio with references beyond the page cache and
writeback_iter() is left to reclaim, as a mapped one already is.

Fixes: 2d6692e642e7 ("drm/i915: Start writeback from the shrinker")
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index bf9e7480f0f5..748772c358ac 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -316,9 +316,15 @@ void __shmem_writeback(size_t size, struct address_space *mapping)
 	 * leaving only CPU mmapings around) and add those folios to the LRU
 	 * instead of invoking writeback so they are aged and paged out
 	 * as normal.
+	 *
+	 * The same goes for a folio with references beyond the page cache
+	 * and writeback_iter(). A folio that was just unmapped can still be
+	 * written through a stale TLB entry until the unmapping side flushes
+	 * the TLB and drops its reference. pageout() checks the same.
 	 */
 	while ((folio = writeback_iter(mapping, &wbc, folio, &error))) {
-		if (folio_mapped(folio))
+		if (folio_mapped(folio) ||
+		    folio_ref_count(folio) != 1 + folio_nr_pages(folio))
 			folio_redirty_for_writepage(&wbc, folio);
 		else
 			error = shmem_write_folio(folio);

--
  Kiryl Shutsemau / Kirill A. Shutemov

