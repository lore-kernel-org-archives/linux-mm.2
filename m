Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2F4F606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AW/LeRbH
Received: by kanga.kvack.org (Postfix)
	id CDB7D6B05B1; Tue, 17 Nov 2026 16:04:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B7C6B05B2; Tue, 17 Nov 2026 16:04:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7CB36B05B3; Tue, 17 Nov 2026 16:04:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC1C6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:04:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3ADD1205AB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:04:30 +0000 (UTC)
X-FDA: 85445839500.21.7B6AE8B
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 28A34A0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:04:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="AW/LeRbH";
	spf=pass (imf25.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794949469;
	b=B9+d4KSFKJW27GFeAZG9iizc0zcwkCNDTpfRTpIA0g96xCHVSZOLbN65cl2M8K+ApA/fGT
	NnHjsdzfmTjv5R7AS0UWYSgna92IBE6r3OgXPDooI06TYNCz9+GnISH7qzIHKrRHMekdzY
	xRIgNEJOdl3p0/cRSelmRz33UJt8nm4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="AW/LeRbH";
	spf=pass (imf25.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794949469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DClN/PQCUc+e7hhJbYiQYreXFIiImxiZvex/Oaj/4wo=;
	b=AaLIhoSxp4v1MB4/Px/tyEdBp9qldwKcTFxzsCqEtXwi7+lcz1zXVnKzI2VO9pxXaH4OIg
	qy0qInxqBA4v/itjbXW+0kI+c98sasUlOI6kOPhNseCDLxQ+4q9ceolR1CPet8P4UvF226
	KGGqvdyuS1MFXYAG5LbHcFMhtlNOUZs=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so2418645e9.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794949467; x=1795554267; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DClN/PQCUc+e7hhJbYiQYreXFIiImxiZvex/Oaj/4wo=;
        b=AW/LeRbHzfuRGmwhfTMLydScAJJdakIXnrxJdBNULwkcMhcXalN2/aVwLRE5bmQwbO
         tS0um7kwhUMe/ret0uyNTmOPV56LdkWDnu3L1z3v6bxg9x26h1TQ9x+yyFgYjBoNV4SQ
         MFdl2FBpx/x774h4FOtPHplDobyuMztA+0hsaVytq36w7b1IREnnCtWK/2VdodBzsOQP
         bAaJkcyYhqgY3JnERv/+6th72dW8dz+E70wYESgdD2FIZLmmuer2zdw1uXi69TnAhvof
         jgARjREFJnB/sw4LM+5w/HIFwbkU9ETgBYZ+5/noJv+fLlX4PP6gmuxuNzU8F3f5L6qV
         6++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794949467; x=1795554267;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DClN/PQCUc+e7hhJbYiQYreXFIiImxiZvex/Oaj/4wo=;
        b=csbNrPspJWA5LpE5zTQxLVHdluuZPXFNwrfBTUFojYpGDRp6fwBvPKZ7fbRPzQhwA+
         7ua9ez4iyeSpO5Bs1+brslcgVWm/uBam/53Wfn+5yBkIE1JU14cnMxzzUoKThlmU+bRf
         53v/x/aPl/Y56IXAXDGXX3ff2tbhfO/PV+gPKvBdHnwhUGelDzIddIYbHHVbNuwpzQN0
         75SxBHDaWIfn421QXqH7lyPzFLSG4K9d26wlCIfrElYrkPJwBkEE4gohsEQeykfWLF6d
         t1QPC1cQRSQcZP4j38wbyhCTkuAUkJDpUtUh+gP37/pyJ95k9k+U7UAmQvuRW5R6p2Yd
         QnRg==
X-Forwarded-Encrypted: i=1; AL+hErETtlK2hFdfcebMmqI42kLdQTSefjcUulzg5DQd/BgEGX2sKcdhZ6yHEu6p8d/nstp7bsoaEKYHpg==@kvack.org
X-Gm-Message-State: APuU4Z9NPCZNJN0IuQ+89hW681z51gYw8x1u4oC6rPaM4tdiKvq2qDL/
	mhb8sI2SSmn4WXTmXPEgV7OmXaE5TFVme3yYdGeTSE7omWOmpum97Us5
X-Gm-Gg: AYBFou0oEpGQAAApApswHagZmB1ZRu79pT8eAwN1wqt0T81ECq3WOyU/3TKU7HIWlyp
	kNc6+s3w3Un8zaRroEt50k92S+ZJAAJPaIbs+JaA6X3DFKuMfotKwai2B0UPfLOkgP1/t2LX1Go
	q9ZFh4Kzirw+9tstvh8LViJWkpSgdyAId9ab3szfdRqZ6Ug0DLz6oI+/0greV2zHNgvG83Rx1eq
	ncoWiCQvgdFMDJbhgAK4q0DtaR2JsXesPpJ1/Zeg3mRiVKYP3gt+eZ43Kp0iEK+OuLCRCctYp0/
	S9qHR4I4skw3q6IYmEkxk93l+YmT2jV/K0jyU/wH1XMPkwzIHE/e49SMD4ngkJRFvcifjV0epd0
	uvQ0jLw0IXV69+kaKFxFzdPIfashTdGHmvMro2tCif4ySOJuK0TTAY1lJcot2hCWkdvBph1mEhr
	b4L2nsXkXKj83+9tsaVv8JapboSyf7YSXf8VJz9QD1rnqRlVoRKLJUJoo+lmVZvGRGbPiBEkwQ1
	fZs2TexOLzkn5ZAcUzyHiRAinjXuTJID/ut2gOaCvPMnl8VSSqkBXBJyuU5Aw0aXlN6VyzOsRcN
	5DCHZKGYmAjwEaQ2BRjaRJo6AECfBtQKDZU=
X-Received: by 2002:a05:600c:6208:b0:4a1:da58:1ee with SMTP id 5b1f17b1804b1-4bb7da46178mr7111145e9.31.1794949467262;
        Tue, 17 Nov 2026 13:04:27 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7ddd4614sm3902895e9.6.2026.11.17.13.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 13:04:26 -0800 (PST)
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
Subject: [PATCH v3] Documentation/userfaultfd: document RWP behavior when the PTE is dropped
Date: Tue, 17 Nov 2026 22:04:10 +0100
Message-ID: <20261117210423.11598-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 28A34A0006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: k8otxj67w513hgq94zhamiux14wpx7gs
X-Rspam-User: 
X-HE-Tag: 1794949468-458773
X-HE-Meta: U2FsdGVkX19lXiub3A1HLH0Xf+RaNDxHDcSUiTdvPfqPbClgb+eDQAo8ic1V2a1tlO2xm5kwZDuahoaXOxCae/Gtt2v8yVO7mwazU6A4KAb5BO1mLw1bIpDmKo0m8RpUu8O92LHw2fMmqo9ngyqMNfasB+AiFZaep8I1FqEYG5XpLb3vmgO9QjqyLWAjJ68om3dwFsXgPVHbEHar7DDUEJrP4cS6DWvIGygwvIIfZUh8QxiXoTu/m/1GEM33C9Tl5Qu7WSC75BYnB7zTA5vpnmNPrencIhKOIU32mE0dvOHR9z/zXHVGmlvU+eU5IoyR/jcViYtPK6MNgMCTq3XZpdWqc2eP9Lqnf8kNsNMu4Sw1tPDQSj8oTduTzMQgLUdYMAwrnZGqncS+fNqCDIBRzgyyRbmKKukysamQXWHhffjzIATo9+SacM67DS+9diVzbMiJy/uqrHRa+Yua8YOIk/xumNKJfgHw5XaaXt+0hgbX1gOFuaTMVtSjD5huY+KYNxlhtv4tDk8Oqg7JUnCqwuXGTAT23tEyTXkLJcTqAUZcq67IJx3jNNKeW9ZOUaBub/0Ikr/BYbHc46IsC8TAFFjEWxyfFgIG0pKj3s5rGSQ2TlINTmFzR/7nbwZL3p/OfNlOsww1IEFt58lZA3yggDI0FmLD+X1bAsAc/BfSrFZwXFNDXZVufOD/wsZtybSLYkZQGuVo1uSHp0D1XqnE6HTOUW6UMxAi2RSWEnqrI9yypynosvUdH93KH1CB4s/adPYZclEEERDzv5chD9JuGlDjg3kYHA9d9pKflImR9H4xrygsZDm7jC+duSb0eEErQ9k3zpHhQ+678YC9+n0Qo0t7wJ2rbZGHRRHUzYGRNM5nNrp/uGjPDW6tjEs9Bi6bup+LmXK3AYvU51rkXD2uD1nvCjpvdNIvl68KregyO/pxtgX1/kPzxkhCwtVpmG+V0sJEwxzJgbSRz/+NTfR
 nQZ+kyJx
 JEBvYODBTLx0GZdeqU8DDs5sRj59XGQtGGpMvxbFwc57xt8pqW4Mc9HH2lZe6yNYNVXXdr57w1GvE8StBh7nIuSqK0u4wQJ2Pxm03aX+XkyCTVcexHJsVIH9gXxZXOD5NVIjhkTO73tMR0ZFVld4UQ7FAsjKaT0LxXXb41NM6en99FXAAO3uPvT47pfAF5cG5wK6bpvNtzuMQ7oQFUacyAXW08uhTMeI8Qe0qnz70bv4w4XVKmKWHLrvH2hjCUmgXuI8x5w7IsiGWt3TK2EMmV8HPwKOqHrFiKlmcY4tLifFeXY9+ZQM++KqsMDAeDmjwZaEmiMiKvtAulWoXchrhKwGuDq5BvOc32QH5idW/bAX7Q6N051ckTdUae6wkYYYWJl2YL4l66DY1jAhULnzKex6ig1HzE2OJgDhEWloGvlZN8ple6l3CG5HaEbQ2Aw6s2D7Gc2m9P3u+9uu/XOeohild6gQJLNKLaTOd
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
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
Changes in v3:
- registration is not fixed. MINOR can be added before switching to
  sync and dropped after switching back

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

v2: https://lore.kernel.org/20261116101004.15322-1-azpijr@gmail.com
v1: https://lore.kernel.org/20261113112806.109578-1-azpijr@gmail.com

 Documentation/admin-guide/mm/userfaultfd.rst | 89 ++++++++++++++++----
 1 file changed, 71 insertions(+), 18 deletions(-)

diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
index 97daea83b7f1..cdc92b40aa65 100644
--- a/Documentation/admin-guide/mm/userfaultfd.rst
+++ b/Documentation/admin-guide/mm/userfaultfd.rst
@@ -384,17 +384,54 @@ normal missing path (``do_anonymous_page()``, ``do_swap_page()``,
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
+The registration does not follow the tracking mode: a context that
+switches to sync mode with ``UFFDIO_SET_MODE``, as the workflow below
+does, needs ``UFFDIO_REGISTER_MODE_MINOR`` while it is in sync mode.
+Minor faults are always synchronous, so keeping it registered makes
+them block in async mode as well. Re-registering the range to add
+``UFFDIO_REGISTER_MODE_MINOR`` before switching to sync, and to drop
+it after switching back, avoids that.

 **Fault Handling:**

@@ -484,17 +521,24 @@ never traps on its own ::
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
@@ -544,11 +588,20 @@ never traps on its own ::
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


