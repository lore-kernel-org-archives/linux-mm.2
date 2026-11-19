Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DFDA60A2633
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hq/Vi7SU
Received: by kanga.kvack.org (Postfix)
	id 479506B0652; Thu, 19 Nov 2026 08:42:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429BE6B0653; Thu, 19 Nov 2026 08:42:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2146B0654; Thu, 19 Nov 2026 08:42:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 037F66B0652
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:42:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87F5A80ADE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:42:53 +0000 (UTC)
X-FDA: 85451984226.28.6419187
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 930F51C0002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:42:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Hq/Vi7SU";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795095771;
	b=fFT+f4230DZC6kqULVV2U5x3LGln1NdKDOl/JzHQnqMUFZeRBn8pCW7VQvfFG5D4xJ3GUS
	CkKGFAhS3KfhBRCl9RV0mK4s+6wunYRiy1xd/EFRllybcTLWgTEKOm1whrT0/zqj6waIuI
	yuJ+8UE46eu6+bOIByelkIbseMDrPIo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795095771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6ACBWYhco6iUyk86M6ZeVBft2fDb7VqeF5xQEolIGhw=;
	b=4a8IMYyMRV6AEgRMlueo3XT9uE1nJRiduT+7w0ZjR2oJ5ak5oIz17FNtiXx6UH2iroPU6i
	uUf3B8DlFSOfD+i7Jada6HqGktPJ6TyRDBslP1wdB4IQAPRQIcZp+L9i8lJuBtmoePReCS
	TxHB6DV/GSdF7UHxJlT+eOiYkt1SX1Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Hq/Vi7SU";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1E39458B0;
	Thu, 19 Nov 2026 13:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7502D1F000C8;
	Thu, 19 Nov 2026 13:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795095770;
	bh=6ACBWYhco6iUyk86M6ZeVBft2fDb7VqeF5xQEolIGhw=;
	h=From:To:Cc:Subject:Date;
	b=Hq/Vi7SURRQ4G0CFNT6KNjDS4l9SdlvxkpT8g0q5tQKl7S0JSbJwXwm3qiNqj2pH1
	 pr8RY47z4+iwOFncXy+4enYCcDES/++ypN+1SPfagDseZztJiiyq4UEw9PGZyOzXEC
	 oIJeWwI0zhKmpd+5fKTwOMIG5co5LhUACmU4eJE5RZmd8ADu8aPsTyAwCLPsnovGpv
	 /9r4WKGGlQf2bw1XIqDdP/ZXAH/9nVkMzPGkWFGpucFwsUWAi+Tpywksm2/Su6ZrmP
	 FxrjO+DCxprHcytRiY2x3gR8X4P3w6OBcg4IUmMrnlgtM/WWnaVSkUh84xO0ipQdQ8
	 Br8XCiUVKpjZA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9F7AF198003A;
	Thu, 19 Nov 2026 08:42:46 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 19 Nov 2026 08:42:48 -0500
X-ME-Sender: <xms:1vz-arAWbA3JNCA5qRsM1QaX5aSLpDW1bhNL-e5w0Yop4BI74SI4Yw>
    <xme:1vz-at2SKQvAQAcNroSohzSmIRgZSM8dwvqXOm7EuaHE49RCSwbFOFzZoqT4o9T8Q
    vLGFZzXrDAAs2XqVc9F6yY7HRaCYA5d1d8c_X-9pPxMdo63FN43NR-A>
X-ME-Received: <xmr:1vz-aoO4V94YCmqMyAziKoVD06qGXjCrnuMVgnisbRMNFa8yO9nbWSGkiVU>
X-ME-Proxy-Cause: dmFkZTE00JGDJwFuizNjyrkcP9E3XGTxdCScKzw0WQL1sclgiRqNMY2HriNnib5wcvvs22
    Rrwbz4qEEZ+3QOrWPBhBhkiA0pSYhuImPR+ZEfxUIsofjgQp2nAaPLgDDTLlSOEqBYYsJA
    QlC0VKBofHq11WhrU/5P8ZCgqaTV9Uj2UsJVuePZ86Q53AhiOcFYtEL42tSN+l/MAgMYUa
    gFRgiJbEMWKVciOs6z+FFSTI8EVWt5U88cq68qk0KksjbbSZqGaRHTOaast1of5wy4Yk9W
    gNEcgL51Z9xmnevSNhZCPjykNnfq9g5zBEfIzSNVPky8JfYH3TmkT2L+QSY6LoQe/WuxQk
    mvJFZpqgfCMtDVAw7H6mrjKYz6/YeRSrmY5DRLfUEeXmZ9SfcKLkOCWJGsoycmlRSGzddu
    +AkDV2HRe2mL8Mx/toLDoH2Bgpxs0j3W/sgQKfz7PbRdYqb8N0Erpzx36Zz3fHZE2XYpk0
    DlPbh2JlWc3pUEJPfaZaDfHjn3aMUuFO+1HwGTCj1E3gGGcOJIuIQYXDezGiQZ5zyYjFqH
    SihlIF5hY4H67V4SRUGqtdozY5Yp5QefAziPge9ODLU87eABw/FZOCu55V0QJragBgvSXY
    ku4Q0VQ4oeNfrpECsNH03dyCZPVbj5wpNjUUkmhdopjxIJDzIyqJFpv9P7Iw
X-ME-Proxy: <xmx:1vz-aq4AKHexI-K2Vhw2nq5VD7A344l0jed_dTBA2npOSMeTwdtq2A>
    <xmx:1vz-alY67vPB10Agk-LdVuEHe3DhxQ5OHhgHPCd4PmaTIqy3yfoZig>
    <xmx:1vz-anHzxWK_8KjZxZJ1Q60h7pGPvvw4_tuj49EWLIR_REf1XhFdQg>
    <xmx:1vz-aunf613BeKx1fSsraxwz3ds3ntkswBWT_g3B0H5TCtFiIaOKwQ>
    <xmx:1vz-aulHjv7xH2_MzrzR_X3w90D0VWjzOxSqQwCt-xB1qQdTLq_u4c0f>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Nov 2026 08:42:45 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] drm/i915/gem: Skip writeback of shmem folios with extra references
Date: Thu, 19 Nov 2026 13:42:41 +0000
Message-ID: <20261119134243.3745282-1-kas@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 930F51C0002
X-Stat-Signature: y6sytpyxei8u176xf4d114ii8u94u1yb
X-HE-Tag: 1795095771-254586
X-HE-Meta: U2FsdGVkX18x4W4bRb4WVRDrR93cJSln7K6VMvs1hUu0wSr577FBpaCKkIQy0/lUCUsN3G+yEGn5fIGMtuuOizv8Vis1NKasShYQipXJIDVAnxyiBLbeSuIgpqCjevJKzCJyigYd1Vdl+PfcqsbDi41HwkWCoIbpBC4M+qQl/pA3OP0038v2ZKwbVnIcz7+v9EqDOu/gXjt7B2tUHMEGnTDnjq8F5HE2KmXW6P3eCQwSx6QKTk8sFb6XKCFsgvEHGQfkynj6aATy4qL9iHx7GFpbnVUy/rYUrulaoSVs2fRAOmVGlpauPZroQ4R7xtePCxS5BcaTo9uu3fqv6t+9ZZbLaJv+hy+wWcVwV0UTpYs9kxEz/+D01sKWoYiNEU6l1nVKpYROe5qHh0WLxFFrQodO/OhD2r59vvOqrTKVHg2f1W+vy7OKnMkaSYaEmqOSPZUGUQn/DDWq6uSA7+YObXGhWZe9K6Go/3hY+puf2pUgvH/dc5nbo3mWLjzkgk5hbbOFkRaZWUWzZDe03MGESE3leNS8eTuNafeygFqtYDuwnx3CIF83s6GBwTcPSSm8+Nef7yKvhj4A4c4GCbMvmgikUmrIA3cmq6NjAb/Tj4H3vB8pd2bKMCE9aTOzyhQdFvV8DIlqgIAO59iHS9vAlbOjdik/MpxarBDL/CNY7onSpQpwFxfCMZPbKnubkjpSSMTUYYkdl+tA2KXZaZii1KkgmcU/7woQGTvW+Ut6dMXxWAA430q2qc7B/CcDzw29OJQuuB1/X4ceMsme5m028fy5xQ37MHt+//NeU1r7wfqaUkmGEWoBmFDhEvGpvWm1pzIcMZZTmBSku50tZpvWD4FwYR09twAgoxoYrGUf4DsbQZFX06vl5pCTMJ95SY+Nnphl0T33O3ogvUhknpQIkLwVJVQDVvG8z3+XNMevwYOGoUW0VhcCdYzQILkz6mbZ4JfH8vGqblLQg1nXdu7
 YPWK64xu
 5pyLhHAKZrDS0VEk2/5uWEPvrhhdKcNNyIhIjhBlFYtsTgRmt1xkmR5GzJACeQFQu00I6wfewIF/ptdoocyAieEA3pdYTy5b2c6Oqc12rA9PA/ruGHwE2PMAwuLnaXwPcqcv1iP5146aF0tvrMaXJRmF7jpvST8RWGWriwOLS4sUR6ANrnPRZQprMZD6QbzMdGg2/buDKVipFLeOTuULADYorACnK51PyCfoEkT5qU20x6W4FCppITtMlPuYQhy7+yZ80pa0iAPMzysdWBLKgpkRKAu+RUpI+jWZ7DvQMO1h1xRCWcIt2KNQ+c89NZFlzrhD4UlTi+WIx8UwmFMyatgdcnCHoeF0E9psrUnoXS19C+Dr0m6QglRNjzP0qSktKqldKSNhJvlXwPTaPTfUyoe77fKrfabvhjhmZYmSed9e7sXG7jnPgtCGWEGs7zsJz4Zl+wuoPJNMK3S6uzgzCGVh8BSnnLkPwE0AAsjwaFACrPpjY4WXcDPNYrJ72gmm40l2X5FoKsY/f+DLLAoNYs8yrawIWXEH94RoYKep6A3exsNuiXU/1Wnke8nEasLNl0fIr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Found while reviewing David's fix for the same race on file PMDs, which
leaves shmem out because shmem has no writeback:
https://patch.msgid.link/20261116-dirty_file_pmd-v2-2-571883053174@kernel.org

Build-tested only.

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

base-commit: 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
-- 
2.54.0


