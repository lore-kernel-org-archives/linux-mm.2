Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8505606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nZRqdg9F
Received: by kanga.kvack.org (Postfix)
	id DE8F26B05B2; Mon, 16 Nov 2026 05:10:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1366B05B3; Mon, 16 Nov 2026 05:10:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAFCC6B05B4; Mon, 16 Nov 2026 05:10:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D83D6B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:10:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 266C8120715
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:10:11 +0000 (UTC)
X-FDA: 85440561822.07.6BF1A40
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5FA1A40002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:10:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nZRqdg9F;
	spf=pass (imf11.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794823809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ww1H1S9hrHisj8WmixCX+JG9UibSCui1VAe7NK53FuE=;
	b=UweLp4gJEAS6z0VzZiaNfk/tl0XuL2Gd1iISAbFGz/+PV9LSHmNKnKa4XpzRnVat87wRUU
	gAGh1zgUV1RCTjUoW41pX8wkJpZUHu4G2QaHI4yHdDXXeZNXdTIVF6KrTx2Bk42tDsnOL0
	vqV7lw7XIajE47sz4X3nUiTomdbfOWU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794823809;
	b=mg+t0R7r6pOG/Ecty9k1t34zJCjMS5gfezMASnXxPvdT4xH9BDUlLYLEvPOzgDk1hQNtZt
	WvyCJNi2s6LNRPtCTSbaAmaELOxKNPyTtDgkJDIeOxOB0f/jBbRHKcaVkDZlJYqeDZsrqU
	zHvZBIupPysdvpp9QHhWq14ffXapq8c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nZRqdg9F;
	spf=pass (imf11.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so15448935e9.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794823808; x=1795428608; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ww1H1S9hrHisj8WmixCX+JG9UibSCui1VAe7NK53FuE=;
        b=nZRqdg9FYGId6wm+sFvXw+O0LLq/QWy7fz9eJhekxG9v8WjSawyINMIeWpeqFk2TjU
         I5L26X5EoeGxclADUJXJz109ubQdlZAkMkmQV5v3X8La74M9nZCJdu6M8LEy+p8Xfivt
         +BlHmCUpMHSPE5smdJXLbvBU+69A5VCJ5wH3+ttNbLk/0T2rnzqzF8hhUd0Drg1fNGKm
         nNgafTIMfhpZhDj0a2fqcfdq513/nOnJzA5nAD9CoC0hU8AsR8DRbyyanjvjSewEkwbI
         OmIXDU55pMgWkYyQWOwRGkR2iC7/d6JKN9zeOc1LTVNTb4ey+XkaJKFuaOrT76uFv/6R
         lAZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794823808; x=1795428608;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ww1H1S9hrHisj8WmixCX+JG9UibSCui1VAe7NK53FuE=;
        b=Z0bjFecBflXuKRzaDx+Uh3dPzO5QwcOBu2+3fft1K2uq4XvWofJxBDUx+5Pk75PV9G
         LCs9+wYd38hb7ggqmQtv99mj+6M8DfnAh83IbZc47kLN6Ju6bPeVrWicsdwPljFe1Lye
         BIQut0dm7SJl0YhQaC/DwPk0HZhyhvV2L7tDMhKfqrM/BMszQh87/R50Bwaib/wX93xQ
         z0MPczCZW67xqkVnJq8V0iT3uOyFnJtG+ixeM8iva3rB1PjZlErKRqYeUJ+lKjdBy/uK
         u1VZ7DtBW1dPbTleSZmUnqE+26noIloHXNrvf/MdmUTqMt8dgVDtUmyAey79WAF7BgHi
         RgWw==
X-Forwarded-Encrypted: i=1; AL+hErFYPXe2ZRjXlAbOdts7BkymNNODztg1mOs8ONTKHukAIiqW+c3VnnHdghLdXJkA5mVEBeC2IYNvKQ==@kvack.org
X-Gm-Message-State: APuU4Z/6DH+q4JETLqgCO2b0OFGrLAEue4Pc3sa0+RifvGlccwQ6MM/C
	1C79lCRi7jphln/lgdZ28oI847qfHjIJoc3WD14cZms7/Q1Grwvkfdya
X-Gm-Gg: AYBFou1EyhfrlDkjtypaQrN+yV7tMu8K6bMgTLPsh3i7DMm7Wc7nQ+rXqZLpIA2VshZ
	reSbMBhKDYRqGUpQcxGRi7XCHUIF7NPmt28EGNVI2xnUOkvurrrfb1QWb2nsNLAYZvco163gOoB
	IAb1HtCWGPltardy0iaPaydzI49Uf1zZ0gt21qirq1QsD/kiS+PAtC2l/V9uNq2gCcd4Ti1eAX1
	wDcoNchqPXk0wP8phLpmoGND5o7peeofEdrMx/D41F2OezGN8FtfLXXSgTzJvSTp5ZsGR0WlJb6
	mVnfI0IV4xHxjtOSQGlkx6iNAFDCkmMN4XtoYwNsKip4tYTiupYLOJb9Xk0od77slM+Z9knhrju
	+yiBXotOKUxzz3Nu3avx1jDPfytROgf/GlCXThxzy3od1MtZGeZrK2JSTH9ubFixltw3KC+v6DG
	IYmEUodnmazkLZ8d3SiGPbNnjXRahrBbT3xex2inzWBWOcGaGNp9lU+fv3xndcRv0FDV+JfWFkh
	WTeZVLmnA0Df4Lqe8gf94LP4hPCg/Mn1JWcy4bI70tGA9AbmYzO/9A3Vybg11205s8Ni/S2WcBP
	EdZR3nRIvmBGvOnaWBQr
X-Received: by 2002:a05:600c:544:b0:4ba:2bfc:c8b5 with SMTP id 5b1f17b1804b1-4bb55a662f9mr135927565e9.10.1794823807538;
        Mon, 16 Nov 2026 02:10:07 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5ff2cd05sm19224289f8f.31.2026.11.16.02.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 02:10:07 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Peter Xu <peterx@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH v2] Documentation/userfaultfd: document RWP behavior when the PTE is dropped
Date: Mon, 16 Nov 2026 11:09:56 +0100
Message-ID: <20261116101004.15322-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3o4rpjz1y4r54g5jptnrrkh48o8becup
X-Rspamd-Queue-Id: 5FA1A40002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794823809-33070
X-HE-Meta: U2FsdGVkX1+s8uCYvwJjJtZfNdGRbsYQM5tqYFPAhhl5zCgC90aifAKdFFfjq+rPdQKRl56GAJ5rHXucrrbDuqZwGALcNJAWbyI/JxEItAAJIqwBKW2jkvB0krrRzbtofCt1vsj1yPJZ3ziHo7woGIgvrWLV2QLxaM6iZQZgCQb1PZ0s/C5iiq9A1NVmM9ZHxSUUVu5eSKmPKknuk0bspmY8MR0fw+JzzX3seGeqBuSYxklJpE5uGeioARN2CaIKi0ORfb92TlyOw8cOg47JApa16jfzROf6lAJtJrHzUUI8lbWvE27y2/xiMNPYmWYdtcww2QP6+aWRxtpv++V4Fq87ORkwTcoayNd4dufIqDljNAdNZ7/RHFHU2ERDKfKjJM/k/mH73m8zgzyHNFDTdGAtUkPVs8hpT/rOBha1pEIdJllhdQkUpge7FHtLp7PBYL9xMwNrJ9leJLjXkl98yJXZ9QDsYQBc8AXdrHgjx72yrJ8ZH69wN/+wcNtWQOOFNRb4ZanQbnnSpZD48KtExrnRAdNM3gJg8Gamsazpe73izKtafBKyYD1CFQuKAJJ4TEZSetMmxnT6LzRVXvgp2mlFrbNaoTaPat6kTz169ywu9l70F7iwrmdpi7kxH2bHzSEdrrhnMwAksT6hdnJCstxM1mY7RYpLwd1ZF2mY8EfT+2ZORQWeoM+HI8gLVHKBk4vB7RceblQaPwLfCBid1v3lb86ALw9o6MaLa4AjczBtE+DnO2CXEwfHvlMpZGfJP4v5iifn9s2t4VVYXe+rxFbC4cn5B2oDEixmOM3R46HxVySvCaFd/aCg/gm5jVk8tSUWO3R8gCIHxYFVbYxkJgMl3X+1PL20UNRqQio+5r3VLQHARu9TdzG1O3BL6NJ+A6YGk8o8PbALof/U7TlCjBxWcL6MLlX3qgNNDOdUkqsHPS2/7pU6x9GICPSE7lVl/tcZpyRajEoHt8Sa3U2
 WFLoscs/
 XRA/lTwyY65OEcfVfdeXxeSXAJPgvfpHvcQ+P8u9RME8Z0ukaD7z+vT+7Bg2cC1T3bx/8UnYX8ZO3ztQCgwHTfHQFAg07MsK0OY5F/7vEfEQwzRfjfweKnUClYg6NIZje398D34rXAarmfaXCP1Is4mdIbCwFk1zm4/dbuIUSXPQ4ouue2TJnJUEKAPixOIm5BNHi1olyR9ysApuDO/R5Eh8Maw75qgtzqCoRr4JxyHQyLOrPWnPtRmwe4TV8G0eqI71CPM3Odndr9EZsKHdK++J4/+9yJONmiRoW/r0Qo2s2qnKqbEOQJsemDlZSaNcFQHBiQr9JBNmFoBeHOCcck/kXocM5DglGIdIpktlTiLkNXOWejG+d0hsiUBqHFyfgq+lPRbmJff0ENslIoTRDH1tFPOYCYfz0VDPOcHLNsox5g3xTjJICTxJiVjz7XsG/PvVK4bAn6DSu+T9/8jx4nYW870HG8fcHwsun
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Scope of protection" lists only the PTE drops requested by the user and
says the range has to be re-armed afterwards. On shmem the kernel can drop
the PTE at any time (page reclaim and collapse are examples), and RWP has
no marker by design: the next access is a minor or a missing fault, and
the user is expected to register for those. Document this, together with
the modes that sync and async tracking need.

The VMM example registers guest_mem with RWP and MISSING only, so a vCPU
write to an offset that is not mapped there can be lost during eviction.
Add MINOR to the registration, describe how the handler treats faults on
offsets that are being evicted, and fix the step 1 comment, since minor
faults block even in async mode.

Link: https://lore.kernel.org/linux-mm/856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org/
Link: https://lore.kernel.org/linux-mm/avWnaR7VVEGa7yNp@thinkstation/
Suggested-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
Changes in v2:
- keep the migration sentence out of the anonymous-only paragraph, it
  applies to shmem and hugetlbfs too, and say "uffd bit", not "marker"
- state the rule instead of listing the operations that drop the PTE
- say that a context switching to sync with UFFDIO_SET_MODE needs the
  sync registration, and fix the step 1 comment, since minor faults
  block in async mode
- add {} around the comment-only if body in the example
- make RWP and minor faults on any offset this pass will evict wait
  until that offset is punched

v1: https://lore.kernel.org/20261113112806.109578-1-azpijr@gmail.com

 Documentation/admin-guide/mm/userfaultfd.rst | 88 ++++++++++++++++----
 1 file changed, 70 insertions(+), 18 deletions(-)

diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
index 97daea83b7f1..8d1aeef73ac2 100644
--- a/Documentation/admin-guide/mm/userfaultfd.rst
+++ b/Documentation/admin-guide/mm/userfaultfd.rst
@@ -384,17 +384,53 @@ normal missing path (``do_anonymous_page()``, ``do_swap_page()``,
 the population itself, co-register the range with
 ``UFFDIO_REGISTER_MODE_MISSING``.
 
-Protection is preserved across page reclaim: a page swapped out while
-RWP-protected carries the marker on its swap entry, and swap-in restores
-the PROT_NONE state so the first access after swap-in still faults. The
-same applies to pages temporarily replaced by migration entries.
-
-Operations that drop the PTE entirely — ``MADV_DONTNEED`` on anonymous
-memory, hole-punch on shmem, truncation of a file mapping — also drop the
-RWP marker: the next access re-populates the range without protection.
+Protection is preserved while a page is temporarily replaced by a
+migration entry: the migration entry keeps the uffd bit, and the PROT_NONE
+state is restored when migration completes. This holds for anonymous,
+shmem and hugetlbfs memory alike.
+
+Protection of anonymous memory is also preserved across page reclaim: a
+page swapped out while RWP-protected keeps the uffd bit on its swap entry,
+and swap-in restores the PROT_NONE state so the first access after swap-in
+still faults.
+
+Any operation that drops the PTE also drops the RWP protection. On shmem
+the kernel can drop the PTE at any time while the page stays in the page
+cache or in swap; page reclaim and collapse into a huge page are examples.
 Unlike WP (which persists via ``PTE_MARKER_UFFD_WP``), there is no
-persistent RWP marker today. The user needs to re-arm the range with
-``UFFDIO_RWPROTECT`` after any operation that explicitly frees PTEs.
+persistent RWP marker, and this is intentional: once the PTE is gone, the
+next access takes a page fault that userfaultfd can deliver, and that fault
+is the notification. Which fault it is depends on what happened to the
+page:
+
+- The page is still in the page cache or in swap: the access is a minor
+  fault, delivered if the range is co-registered with
+  ``UFFDIO_REGISTER_MODE_MINOR``.
+
+- The page is gone: the access is a missing fault, delivered if the range
+  is co-registered with ``UFFDIO_REGISTER_MODE_MISSING``.
+
+WP cannot use the same scheme — a minor fault would trap reads as well as
+writes — which is why it needs a marker.
+
+Without the matching mode the page is mapped back silently and without
+protection, so what to co-register depends on the tracking mode:
+
+- Sync mode: the access would be lost. Co-register shmem and hugetlbfs
+  ranges with ``UFFDIO_REGISTER_MODE_MINOR`` (and
+  ``UFFDIO_REGISTER_MODE_MISSING`` if the file can have holes), and
+  anonymous ranges, where minor faults are not available, with
+  ``UFFDIO_REGISTER_MODE_MISSING``.
+
+- Async mode: neither is needed. A page faulted back in is mapped without
+  the uffd bit, so ``PAGEMAP_SCAN`` reports it as accessed.
+
+The registration is fixed, but the tracking mode is not: a context that
+switches to sync mode with ``UFFDIO_SET_MODE``, as the workflow below does,
+needs the sync registration. This has a cost in async mode, because minor
+faults are always synchronous: an access that takes a minor fault blocks
+until the handler resolves it, even while RWP faults are resolved by the
+kernel.
 
 **Fault Handling:**
 
@@ -484,17 +520,24 @@ never traps on its own ::
         .features = UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC,
     };
     ioctl(uffd, UFFDIO_API, &api);
-    if (!(api.features & UFFD_FEATURE_RWP))
+    if (!(api.features & UFFD_FEATURE_RWP)) {
         /* RWP unavailable on this kernel/arch -- fall back. */
+    }
+    /*
+     * MINOR: an offset in the page cache but not mapped in guest_mem
+     * would be mapped back without a fault, and a vCPU write between
+     * the pwrite() and the hole punch in step 4 would be lost.
+     */
     ioctl(uffd, UFFDIO_REGISTER, &(struct uffdio_register){
         .range = { guest_mem, guest_size },
         .mode = UFFDIO_REGISTER_MODE_RWP |
-                UFFDIO_REGISTER_MODE_MISSING,
+                UFFDIO_REGISTER_MODE_MISSING |
+                UFFDIO_REGISTER_MODE_MINOR,
     });
 
     /* Tracking loop */
     while (vm_running) {
-        /* 1. Detection phase (async -- no vCPU stalls) */
+        /* 1. Detection phase (RWP faults async, minor faults still block) */
         ioctl(uffd, UFFDIO_RWPROTECT, &(struct uffdio_rwprotect){
             .range = full_range,
             .mode = UFFDIO_RWPROTECT_MODE_RWP });
@@ -544,11 +587,20 @@ never traps on its own ::
                   .enable = UFFD_FEATURE_RWP_ASYNC });
     }
 
-During step 4, a vCPU that accesses a ``guest_mem`` offset being evicted
-blocks with a ``UFFD_PAGEFAULT_FLAG_RWP`` fault while the eviction is in
-progress. After ``fallocate()`` punches the page out and ``UFFDIO_WAKE``
-fires, the vCPU retries the access, faults as ``MISSING``, and the
-handler resolves it with ``UFFDIO_COPY`` from storage.
+During step 4, a vCPU that accesses an offset this pass will evict blocks
+with a ``UFFD_PAGEFAULT_FLAG_RWP`` fault, or with a
+``UFFD_PAGEFAULT_FLAG_MINOR`` fault if the offset is not mapped in
+``guest_mem``. The handler leaves the fault pending until that offset has
+been punched out, even if step 4 has not reached it yet: resolving it
+earlier would let a vCPU write land between the ``pwrite()`` and the hole
+punch, and the write would be lost. After ``fallocate()`` punches the page
+out and ``UFFDIO_WAKE`` fires, the vCPU retries the access, faults as
+``MISSING``, and the handler resolves it with ``UFFDIO_COPY`` from storage.
+
+Faults on any other offset are resolved right away: RWP faults with
+``UFFDIO_RWPROTECT``, minor faults with ``UFFDIO_CONTINUE``. A page mapped
+by ``UFFDIO_CONTINUE`` does not carry the uffd bit, so the next scan reports
+it as accessed.
 
 This workflow targets shmem and hugetlbfs (both support a private
 ``io_mem`` mapping over the same fd). Anonymous-memory backings need a
-- 
2.56.0


