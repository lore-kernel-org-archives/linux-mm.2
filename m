Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2216D606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pLX5RKw6
Received: by kanga.kvack.org (Postfix)
	id 214036B06D5; Fri, 13 Nov 2026 06:28:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014406B06D7; Fri, 13 Nov 2026 06:28:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6CEE6B06D8; Fri, 13 Nov 2026 06:28:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC5906B06D5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:28:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50E1C12052B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:28:15 +0000 (UTC)
X-FDA: 85429872150.10.3F9D138
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 884031C0004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:28:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pLX5RKw6;
	spf=pass (imf21.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794569293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/0hFdLUUBMubQi9ZZLh74tQ0C+rY0zzfWhh+F7mlSYU=;
	b=1mU2AbEf583S1eOy40+AMNJXtHtagxfY999oyG8US43pbXcwOTYwUbOD3CS5kovpDhlUtJ
	OAQY7eBCsMIybMsNjsMI2SE5F6lqFQJGIShbk8fv0Q8zdiMNEYNbr9L7DE8U0lN+792KRH
	2jdMM8UmvnNOohMS+yOcWm/J3//lZ4Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794569293;
	b=e7PNodmjSATrcrzavnF/NiDzE2dnx0hwkayUr9NWimhCMNCVR+cGzKZOzFU1Pg5Qb32XEj
	Fyf+VGMz37yxdyIApz35Jyy9SE00vLV0HGOj6dxQzI6JAuNijTq3wwEl74a6Br8IyeeFq/
	yVsFuq/YuXdw7lKO7RRcrbGRxjXBy0E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pLX5RKw6;
	spf=pass (imf21.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so5641875e9.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794569292; x=1795174092; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/0hFdLUUBMubQi9ZZLh74tQ0C+rY0zzfWhh+F7mlSYU=;
        b=pLX5RKw6J8PXOdh7BAa8WFFj83+UCtaLm7e2fVwS+RyjcuWgTNHfcgKtrIoJVXbe9l
         fAwDoxOsxUSE6XRl6+ReXwkq8rem6idOK/UZPbLlAtlYqS0vbi1Ir35xxjA63nF2RDWM
         T/rbaMTSBB40+5jKMcQajx/WMhgAoDOKYKobhoNSCDnhtJNTB/uCOJBQcql3yHU4dKaj
         3cefSyVfufkEJhGXx+RBXGzf5pNTbh/iMavsanOQbu8Va4xh5XHKRbfthFpobRc60onL
         qIMy1IAW4XayRSXrTfpv5D5XocZjEdVjNc4zcJ8Z4A+7ASSVD21cxOMatAKg+Ra7x9Ip
         r23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794569292; x=1795174092;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/0hFdLUUBMubQi9ZZLh74tQ0C+rY0zzfWhh+F7mlSYU=;
        b=UStaAND5SL8mJArUjbykaY1Jjb1afphsAX0rYRnR55q+s85v0x1e8gYi0Vm6C9dPDT
         q+OYTXBUqKbCEGkaCphxQVtUF2toq6/WFGAXbKMeVryNec7CvAHlhuGY6GdMTrJQCcq1
         obqhi6ioPOtS41s70ctTET+Wk0QB3zYAh02d0Zlcv/GwVMtIvA7Jci/Vln4jbc00Ifa4
         U8CQ7r4vtqwB9SqTm3r/fHAfaqisStDNcUU0iDSHik4Y1pUFLZgyCxUjan6ppzcN6oKO
         RXlECMsarAL+uuMY09hnAOyx5U5ZXkuIIG36QF04D6kfq2M69rf3eccYOWWGzC6ETe72
         1L8w==
X-Forwarded-Encrypted: i=1; AL+hErFtwYWpIJCfKqwihDQnpg9+flKNB00FkJz6hunh59E0SEJXJNj+iAI/aTz34SM3BQ4L09Nmxg4UXw==@kvack.org
X-Gm-Message-State: APuU4Z+3mwhhTnEgJIms6Vh+e0IQAhAsUU5/ihXYnlEOtbjBkhC6ptuX
	QbK4YngSI6nd1IyjEmCMgiWKSHK3aRzQI4FPcAdyqvTz8eTay0Sri+u1
X-Gm-Gg: AYBFou0axy4T0icDOMnckC9yWg2VQp3r+FCclZkh9tN4KQOrLF0jXlAswlyGSsAOXAj
	00FmV309Hm7/2mIx6eMJ+pGUl8USL64m55hJ5tQkwPZRy2SgujDbSh7i+hGy3lCaHURtpT7G6aU
	JxJmszShkVlGCqtJQ68wIIiB9QGKqJdM05XIF+O/h27fTuFlobBgHpKvtyOKVvKhkLphD8WMk3R
	YJENoK1tawtpFTCJkX6Sd92FjQhjgV8tXX5yfD3F0pNw4jacHaAng1UMUHMa5bSBBCjiQ99bh3W
	YV5ek2IKQLkbIYCLDQweYY/QOEjwyijJfAGR3AGscZeXHjsQZlHf9oc8dv5VIs1o69i9at9nPVP
	cvoo9sz6mI3Xk0GvJq75+D3vYu0on3o1qQbNxWlpLbFuwATk1PcJ+45anR7OL/HHIVevFawg332
	QhsrZlLTZbsgnz/6NLHbDFlwl8smZVWgmD1/S0WWcCNmaadY5jzo7SOpdJsdxqSFQ9FNzGKtE7s
	7bipsziCL71dlKxo0i90hu7rwsjyuTw1ib+yuibwkShjDKBIVLaKQEjz9Riy04P0U3DuUAPl1xW
	h2yo/tP2UpEWcA==
X-Received: by 2002:a05:600c:3e17:b0:4bb:53e4:a7c8 with SMTP id 5b1f17b1804b1-4bb55aa27cfmr44169585e9.22.1794569291720;
        Fri, 13 Nov 2026 03:28:11 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb56680ea9sm35107545e9.0.2026.11.13.03.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 03:28:11 -0800 (PST)
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
Subject: [PATCH] Documentation/userfaultfd: document RWP behavior when the PTE is dropped
Date: Fri, 13 Nov 2026 12:27:42 +0100
Message-ID: <20261113112806.109578-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 884031C0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1rcb7kbd7rc5twj7ibtehq5e6extn8ka
X-Rspam-User: 
X-HE-Tag: 1794569293-752608
X-HE-Meta: U2FsdGVkX18ECYHynmwLkLnAFDL6vXJnnzgs1dILlWWK/Xn6OJM2Iu/jgyq25vbW3IDrRKWdMtNNscnyGHXj7LJDRAnGT31AEsn0clChCGPPoLTCmKr2gjWmf5fem9B1ONTDwbjSa6/ZUrkjvByF78Anx2PrXbiiIHJHdmuL5BBDX3GMaMANvJi+FVRYN5DOJ/QjlkPgkotLv6lxLO+Q3QToUT9rK8Jm7mSSiCxuZwKwu9TT3HZVX/jPPRtEO94V/C0BBT1iXbqZah9F4ZfuPls9Rfyma9vDLk7GRF79PDTS8A5/u7LN01/NKocOoVLjYzZ6psASLCGEbwpSrGKq+PZwz3tlmCv35KMCxti4hMosvV4yMtQ0b6+2AV7eRTzksz9zfiOJ94i6+9kSeVvJ0lDSWKSAUJd1jUGOTsAGhPR7CVbXIpzSjZZkIO3D5eQfQgtvQBPk+tnEtHeAms/dKzbJ/F6AIXWo9LZ3esIsmzQLRI7NIJVCWFUFUP8VttdQTWk7ZL9v6ELA1zGEG25e4idHaa1HY6hfkPNTL4bqaPH3RK8+jSu1Ybwjd6PH5jL9+SaEWc621ql/Sg5aB2o5mXz/AyxAW9nVpvT6ZM2+2rFCqw+XrrgvN4VZ2jFvyVu9Z0yAojuuhk14a7OfXNc2oxLwWlJFByFiLskvsOdNUNhB4zUZVX5Y1oieP2MhBc6LV8Pd0FJH6DweuQR0FbjYCinVzRqEfEMMnHiY4TNB4oWqah2yYPRXHKewCRjRhcZ/kIvgTHdxtj1dq0ocreiCUtaAmZuIROnzJjCbaGon8yRK8taqCShuI5DWnkP3x8iNQpEeZFNb7fwh/8cF8L3689epAVMg6UdQcKGZglpCjdraelS+ofpX1nlozsE+Wk8HsG0vYss4+B1plprS1qtsJKNhc3EGb4FFV4fjLiCVwGUSBlt7v0+AxSa9DpYgua+jsceXb3hS7K3pFyKXs7T
 h5Ol7+9R
 eokYODbkXW/rPHQMyOBIMGntlMB7Mbo9R1Abh9vAw1wePDR8FMUtwC3G9bQZneZoGIf+KHBlzSARl/lHcrsI4uBy4u0Ol2+h0EW04oz51uDNwdlILcF8S3HF+c+7UPjuFRgJKopfG7NO+Q7MlRMCHedX882IHX2xl9JhGOcipgrp9jU5BsGg+jj6MoFiYb958RauJs821ERnel7XLM45P7KGgvLuAkQPL628NvF+2DYC8SKuXlm94RcVrWdbJM2Zh8klsefnW9QwNfnwNNbL22Dx2BIc55MOeRM8VP5Q4JDBItnnzAT7bQXyEQ2a9xwAb+t4apjRJMMKfZ7f1VSbSXYfE/QPlHzqVG3cwI6QGYi58J5elLjHKJz5dQzET7H/k5UQ11P7Kj5M5Oyf8vnBhOCN/pvr9UFBaW3C1Du24l+Bv7Plw8WFjkztfBZbRwVBcEaNri2JRaC1b8LR1X4F4PBXl0yE0jPd9im1v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"Scope of protection" lists only the PTE drops requested by the user and
says the range has to be re-armed afterwards. On shmem the kernel drops
the PTE as well (page reclaim, collapse), and RWP has no marker by design:
the next access is a minor or a missing fault, and the user is expected to
register for those. Document this, together with the modes that sync and
async tracking need.

The VMM example registers guest_mem with RWP and MISSING only, so a vCPU
write to an offset that is not mapped there can be lost during eviction.
Add MINOR to the registration and describe how the handler treats minor
faults.

Link: https://lore.kernel.org/linux-mm/856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org/
Link: https://lore.kernel.org/linux-mm/avWnaR7VVEGa7yNp@thinkstation/
Suggested-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
this is the first time I'm writing documentation, so I accept any
suggestions to improve it :) and I tried to follow the documentation's
own style.

 Documentation/admin-guide/mm/userfaultfd.rst | 65 ++++++++++++++++----
 1 file changed, 53 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
index 97daea83b7f1..19bdac668f93 100644
--- a/Documentation/admin-guide/mm/userfaultfd.rst
+++ b/Documentation/admin-guide/mm/userfaultfd.rst
@@ -384,17 +384,45 @@ normal missing path (``do_anonymous_page()``, ``do_swap_page()``,
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
-Unlike WP (which persists via ``PTE_MARKER_UFFD_WP``), there is no
-persistent RWP marker today. The user needs to re-arm the range with
-``UFFDIO_RWPROTECT`` after any operation that explicitly frees PTEs.
+Protection of anonymous memory is preserved across page reclaim: a page
+swapped out while RWP-protected carries the marker on its swap entry, and
+swap-in restores the PROT_NONE state so the first access after swap-in
+still faults. The same applies to pages temporarily replaced by migration
+entries. Shmem is different: reclaiming a shmem page leaves the PTE empty
+rather than installing a swap entry, so the protection is dropped along
+with the PTE.
+
+Operations that drop the PTE entirely also drop the RWP protection. Some
+are requested by the user — ``MADV_DONTNEED``, hole-punch on shmem,
+truncation of a file mapping — and some are initiated by the kernel on
+shmem: page reclaim, and collapse into a huge page by khugepaged or
+``MADV_COLLAPSE``. Unlike WP (which persists via ``PTE_MARKER_UFFD_WP``),
+there is no persistent RWP marker, and this is intentional: once the PTE is
+gone, the next access takes a page fault that userfaultfd can deliver, and
+that fault is the notification. Which fault it is depends on what happened
+to the page:
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
 
 **Fault Handling:**
 
@@ -486,10 +514,16 @@ never traps on its own ::
     ioctl(uffd, UFFDIO_API, &api);
     if (!(api.features & UFFD_FEATURE_RWP))
         /* RWP unavailable on this kernel/arch -- fall back. */
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
@@ -550,6 +584,13 @@ progress. After ``fallocate()`` punches the page out and ``UFFDIO_WAKE``
 fires, the vCPU retries the access, faults as ``MISSING``, and the
 handler resolves it with ``UFFDIO_COPY`` from storage.
 
+The same holds for an offset being evicted that is not mapped in
+``guest_mem``, except that the vCPU blocks with a
+``UFFD_PAGEFAULT_FLAG_MINOR`` fault, which the handler leaves pending until
+the page has been punched out. Minor faults on any other offset are
+resolved with ``UFFDIO_CONTINUE``: the page is mapped without RWP
+protection, so the next scan reports it as accessed.
+
 This workflow targets shmem and hugetlbfs (both support a private
 ``io_mem`` mapping over the same fd). Anonymous-memory backings need a
 different inner-loop strategy because the VMM has no way to read the

base-commit: 31a696f9c37defab0f28f774e00ac7f135889ec3
-- 
2.56.0


