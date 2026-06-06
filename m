Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4328ACD8C8E
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 15:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39B836B0005; Sat,  6 Jun 2026 11:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34C5B6B008A; Sat,  6 Jun 2026 11:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B536B008C; Sat,  6 Jun 2026 11:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6476B0005
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 11:59:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93C6AA04D4
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 15:59:04 +0000 (UTC)
X-FDA: 84849946608.21.7F89A20
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id CA1AA80006
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 15:59:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HR7mOJxe;
	spf=pass (imf30.hostedemail.com: domain of med08elkadiri@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780761542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hPAu+BAhHHXK2zlYgOPKG9XbowJkcKlbw5y7d5pIQQc=;
	b=7fg1v8RKuQWh2l+fQUNaTkdFuniuhzYxfMVthdm8xJ+TTEqGlXG/FKme9A82bxfkEW6JqB
	pWmF6pG9H9cJMKTGMjDn/cVAPdFjfqS/FDJ+aFr7qSai1p5h0GQyTSYK+LAdTtMGlfSwsy
	jfc6XRnG5pQfvLA7+jqK41wePvjNNj4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HR7mOJxe;
	spf=pass (imf30.hostedemail.com: domain of med08elkadiri@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780761542;
	b=Gg+YX1OkFo2l1GzJCYFMcqXCnLHaGKlUUFoC663T+fZLmsCQyYf98JrjGCZoT4xsRID2HX
	4XzRI1cVEjlDD/lMRuWkVom6rshUe6IoyvZKDOp4hmziO0pIWj5Cj37wR3mFfD19HUVema
	jF8yF+5/o3tawBcAu8RydkvT5pdcZZc=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4906869f0cbso34493635e9.1
        for <linux-mm@kvack.org>; Sat, 06 Jun 2026 08:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780761541; x=1781366341; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hPAu+BAhHHXK2zlYgOPKG9XbowJkcKlbw5y7d5pIQQc=;
        b=HR7mOJxe67dArLXcKdcRJ1BFEy4Yx18QIqRti1E3jAs/IfUo95Aa2xjJbKfhcqj6fY
         RbXhe5hFINjai+osoQL6oeAidomHOTA+vnVZgAUtwXo2Kr1clcjgeY3PLhWBuNQhHWnr
         Ud/T1G4jikpBm0JHyHH87uziMLAMG9+n/suQCkH0el+85j7IajTyV/fAIbdymXH7qkW+
         VJNXFcU3y4h4hWVvsp+Onra3vlNJzzXPX933WbGJNzfvq/Tv9txxQMOT7+ymb/iS+xnq
         22cMo0Brw5dnBDSm210tN6SsemAsxHfysYT7liUoG0jCLOICkmtg7jwECrM0bpv7MFhb
         xF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780761541; x=1781366341;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hPAu+BAhHHXK2zlYgOPKG9XbowJkcKlbw5y7d5pIQQc=;
        b=Q5kqInbWVjoZgO6ZCPTlO3RB8fQIY/YJOKU3yrRSubrwlWjSzqAdwwt6G16Hjr9YlV
         Eohpq9BkupaQOpVAVM7I3b57c2mZ0tCuM0ZYojBkE5ZNkdkDTER2Ka6XziVJQATtjanI
         f95ExEOaYSWaVdsBZ28YdqEuxisHmDzo45fXOirkS9kqwijUn12bQqhOckyHfVbx2Vkm
         w32QbUQBA2F2xhxR9CKtnz1IGk+GiSpMvvHyv1FpQ2TzA1IoUiB6TiHTD7c203M4ofkz
         n4r6dTCjtY10/XzNwkCyaa7aU0t7dOYmRaA6ra9mMCpmmpo0JADhCZmNs7BC6+f13RIW
         8h5w==
X-Forwarded-Encrypted: i=1; AFNElJ/NOB19HQ0GEeNEIb03Q6Nu/8MnmtT+eAr/Bs1x5smRrtH++lYzoQXIP9PXQ3c+CAlhMyxncR9ptQ==@kvack.org
X-Gm-Message-State: AOJu0Yyfds7eQA9dHxzZpP5fdrvmz0gO3DBJq204yWN6op4fuHTECtvP
	0lu+nAtZjIYCQTxrW73JEP9znQaCshkQeUZTkOd9XFpSsBALYY1pOEI=
X-Gm-Gg: Acq92OG3ROqdhJdfpQmVu4GrpSeMcHPOq1UG8RGZJ53RTBeDeXt+6VvWcqotZIhoyD0
	/Xwo0dZphkkzexbuw2cOzYmogCXSiCqH+3M3jsBgtxWMwYRDIdOBPYgBR/MPBeHJ233eTnBogvU
	2+L4UUyVCHoxN/qZ9t7WvRD+LShmWknz/BVUAfm3/KB4WxtS58B20Q3mMHgVZhaPT5kFD9AtQVa
	I3ywp10nB+jVBf5NQXko//kiDlKJl4/hgcTdlzQBp7A5zF0Ij58dkv0aCC79dQiJm0cufaJxNe2
	VG1RjZYj7yCegJXe0XzIKXy3E67t5Q+V3wayB+xsE1GM49RA51dzDoWYbbz8Cl/siOszttPPAlQ
	lDRNYm/kAVihNwuJoGM5ObY+fIyaekEIVL5ES4LGVOz8FVcP8bJ7Prxuzd99J5MpGBhc4YzH1OY
	XFYWV3ACfgVSxLRJw5kzqySITgg/X+dmCJeNIpaC/6lreXO25yYkL6funiYR4mniTzUDVCDQHyX
	9BrmpIVSzlMeMEiql3AfAQBXgFszG71IYRllBIo+F/kZMrbYI1i
X-Received: by 2002:a05:600c:1554:b0:490:7dfd:f7c2 with SMTP id 5b1f17b1804b1-490c25eaca1mr150028355e9.11.1780761541013;
        Sat, 06 Jun 2026 08:59:01 -0700 (PDT)
Received: from hp-ubuntu.. ([196.119.187.57])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3a87dasm235639805e9.7.2026.06.06.08.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 08:59:00 -0700 (PDT)
From: Mohammed EL Kadiri <med08elkadiri@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mohammed EL Kadiri <med08elkadiri@gmail.com>
Subject: [PATCH] docs/mm: document slab cache isolation with SLAB_NO_MERGE
Date: Sat,  6 Jun 2026 16:58:55 +0100
Message-ID: <20260606155856.15548-1-med08elkadiri@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CA1AA80006
X-Stat-Signature: s5im39czaw9nw5tar65oui9nctdy8yk7
X-Rspam-User: 
X-HE-Tag: 1780761542-878385
X-HE-Meta: U2FsdGVkX19IoW3a7AT9hWRBNsCEcD6JE46VRW1WvR5iFAIgZdNnhIJ4j5XOTv2nBb1JF8xnChuE6C4oYzPrxtH4b7HUB9u8C0D6I3BrSW+sHRBTCFFJaARakYLqmrEItztHdOrMR15/g0JwwU9Ot1wCC4hohuvgQkBys/0Q2ebiADj0tB+hlygpvEQ5aIVoTN4akp2AEu3z/Yw+5J+MYz6F1RVqV1yQ4I+xO+nzqC0cBDWQe9Us8FUfIlcq9IiIRfFOSvrk3EZq4d/jgwX2WNVGrC661peWEWGiVDBZ0Nonms3DckyjXRkT5B/9RyBRthrihzA5GtQrUKwoVuJgemzqX9EOT/iseANqTWd0JclNkpxdxWTwGqJsotB7xCRW2TjEeMxt+nyBCHpDG2k9EumGJlWdcM1v+dsC8GJcH64JyfDa86NZ6FYOHRHmIA8VJfjrZHoqaRESJpw11rzFOirV2oQdE4SyDkt7/dgu27/CT7t7nwaYyP+To9jU9sVeU69MZ61zkbFgYvXGeJI8OS8micXhL3AVEiG1A4IxTGSPHZ2uZ2k2VWR+0kxiNqNj+qEvMzCnUnadYiMyvwb8Vp178RnIPehml33HhDc2Mu/cQQuCfljdiaXOKYOEZW+SfvLGhGFxS/kUOo1bxByDMhDBYsIh1ye2WeyY+Or5tLykxdT+6xzOuofu+C/Bsblpe1Eer8oZw/s/MreW9BWyOcFFzdlvA/GqYV7GDF3i2uWBxNd7xyRcwPVvsdQOlkBrqF479ZcNuVdQDKscCBkJN7tJodHSfu2vcztPYd+bLiczX1cPhaoAT6pLmh+bqa55lqp2BVdXTn/HwD9r6qlDpwq34cQlwgXBxq79StJiOfxQoO2vlgAPw86buf3KxHiLOJqdCJK5W3xqIDn1/tYohHnY2QCsmyMRpPyl+kuWTnffV9b7+6N3iyCuL87pIbrHwO3CJsl0WERFlpIXZ/k
 XLYiVM1I
 A/KlhKUcpkPwQ/NUhwScTD/SySA+O8B7gNFmxIUj+bMxijfBOryq+Wched/P9L+/FWbArpAkAzUTW16JFQQueHqyega1FHpEdWUfL4dIuRSoqjjGpOvr3s0TvABNHT3YB3oIJ0eo049XUKOPo00ryVBN31BcSWOnkyIZGDiHnsWxyeks4u1//mkQuyrrPf1MduznyApizgVZSMm7OSNZE7Sk5UdpETE+LfDe7xV+FwcwOBunVPTdZDX1s20+2j9o22DxC5/c/QFx+c6/aMsGXeLo8OlagLEa3TVgx+xOgDp/egu/X3WK34ypit3L4kRuxZg1dKtPUGYzB1vEKdPV6WP4q+/ylbCrvUcj1z291eJYmVi3BoVfDm7LKKRlTcrowyGRKdfHOfLXoipTr/ZHbcD1lJcbGzruwfIeAiVuU0k1nuyTB7Akl0S0clZrWAQ+DO4DFE6OZRl7GN8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation explaining when and how to use SLAB_NO_MERGE to
protect security-critical slab caches from cross-cache heap
exploitation.

The document covers:
- Criteria for identifying caches that need isolation
- How the SLUB merge mechanism works and what prevents merging
- How to verify merge status on a running system
- The cross-cache attack class with CVE reference
- Tradeoffs (memory cost vs security benefit)
- Relationship to CONFIG_RANDOM_KMALLOC_CACHES, SLAB_TYPESAFE_BY_RCU,
  and the slab_nomerge boot parameter

This information was previously undocumented, requiring developers to
read mm/slab_common.c to understand when SLAB_NO_MERGE is appropriate.

Signed-off-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
---
 Documentation/mm/index.rst          |   1 +
 Documentation/mm/slab-isolation.rst | 113 ++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)
 create mode 100644 Documentation/mm/slab-isolation.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index fb45acba16ac..c2d5349dfc34 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -17,6 +17,7 @@ see the :doc:`admin guide <../admin-guide/mm/index>`.
    page_allocation
    vmalloc
    slab
+   slab-isolation
    highmem
    page_reclaim
    swap
diff --git a/Documentation/mm/slab-isolation.rst b/Documentation/mm/slab-isolation.rst
new file mode 100644
index 000000000000..d51472eb0c95
--- /dev/null
+++ b/Documentation/mm/slab-isolation.rst
@@ -0,0 +1,113 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================
+Slab Cache Isolation for Security
+==================================
+
+Overview
+========
+
+The SLUB allocator merges slab caches with compatible size, alignment, and
+flags to reduce memory fragmentation. While this improves memory efficiency,
+it allows objects of different types to share the same slab pages. This
+enables cross-cache heap exploitation, where a use-after-free in one object
+type can be leveraged to corrupt an unrelated type.
+
+The `SLAB_NO_MERGE` flag prevents a cache from being merged, ensuring it
+receives dedicated slab pages.
+
+When to use SLAB_NO_MERGE
+==========================
+
+`SLAB_NO_MERGE` should be considered for slab caches that meet the
+following criteria:
+
+1. *Security-critical contents*: The object holds data whose corruption
+   leads directly to privilege escalation or security bypass, such as
+   credentials, cryptographic keys, or capability sets.
+
+2. *Actually mergeable*: The cache must not already be unmergeable.
+   A cache is already unmergeable if any of the following is true:
+
+   - It has a constructor (`ctor` argument is non-NULL).
+   - It has a non-zero `usersize` (with `CONFIG_HARDENED_USERCOPY`).
+   - It already has `SLAB_NO_MERGE` or another `SLAB_NEVER_MERGE` flag.
+
+3. *Bounded allocation volume*: The cache has a predictable number of
+   active objects, so the memory cost of dedicated slab pages is
+   acceptable.
+
+How merging works
+=================
+
+When `kmem_cache_create()` is called:
+
+1. If `usersize` is non-zero, the merge path is skipped entirely.
+
+2. Otherwise, `find_mergeable()` in `mm/slab_common.c` searches for a
+   compatible existing cache. A merge is prevented if:
+
+   - The `slab_nomerge` boot parameter is set
+   - The new cache has a constructor
+   - The new cache's flags include `SLAB_NO_MERGE`
+   - No existing cache has compatible size and flags
+
+3. If a compatible cache is found, the new cache becomes an alias. Both
+   share the same slab pages.
+
+Verifying merge status
+======================
+
+To check whether a cache is merged on a running system::
+
+    # Check how many other caches share its pages
+    cat /sys/kernel/slab/<cache_name>/aliases
+
+    # aliases > 0 means other types share this cache's pages
+
+The cross-cache attack class
+=============================
+
+Cross-cache attacks exploit slab merging to achieve type confusion:
+
+1. Attacker triggers a use-after-free in object type A.
+2. Type A's cache is merged with type B (they share slab pages).
+3. The freed type A slot is reallocated as type B.
+4. Attacker uses the dangling pointer to corrupt type B.
+5. Privilege escalation.
+
+CVE-2022-29582 demonstrates this technique: an io_uring use-after-free is
+exploited via cross-cache page-level reallocation to achieve root.
+
+`SLAB_NO_MERGE` prevents step 2: dedicated pages mean a freed slot of
+one type cannot be reallocated as a different type.
+
+Tradeoffs
+=========
+
+*Memory*: Isolated caches may have partially-filled slab pages that
+cannot be used by other types. For caches with bounded allocation counts,
+this is typically a few extra pages.
+
+*Performance*: Zero impact on `kmem_cache_alloc()` and
+`kmem_cache_free()`. The only effect is at boot when the cache is
+created.
+
+Relationship to other mitigations
+==================================
+
+`CONFIG_RANDOM_KMALLOC_CACHES`
+    Creates 16 copies of each `kmalloc` size class and randomly assigns
+    allocations among them. Only affects `kmalloc()` users. Does not
+    affect named caches created with `kmem_cache_create()`.
+
+`SLAB_TYPESAFE_BY_RCU`
+    Delays freeing the slab page by an RCU grace period. Does not delay
+    object slot reuse. Does not prevent cross-cache merging. Solves a
+    different problem: safe lockless access to freed-and-reallocated
+    objects of the same type.
+
+`slab_nomerge` boot parameter
+    Disables merging for all caches globally. `SLAB_NO_MERGE` provides
+    the same protection selectively for individual caches without the
+    global memory cost.
-- 
2.43.0


