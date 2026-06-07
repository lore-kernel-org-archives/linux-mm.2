Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0F8FCD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 07:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD1416B0088; Sun,  7 Jun 2026 03:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81F16B008A; Sun,  7 Jun 2026 03:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97726B008C; Sun,  7 Jun 2026 03:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BA6F6B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 03:06:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD38E40652
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 07:06:54 +0000 (UTC)
X-FDA: 84852234348.06.063BA9E
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id EE00840004
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 07:06:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NBD8bKNz;
	spf=pass (imf12.hostedemail.com: domain of med08elkadiri@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780816013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjFCfZnGIYF5PioRnZOk1Y+cKLSfcfAJ9sx8UaHZ3lQ=;
	b=CVkKkQEw3hqLTqxc6XNNUj8YuvEz3TM99jqbXdoc4S/RIAa6dIvboMaPWLJIrTj+DVi2Nv
	uiR0xsYbymQn0kA6NiqT4+Ri3RYUj3ah+Ou3i2GGBLS0pBwNB7N3mg7prSxriww/sfbRxs
	MOGbmHFSrml/QFShIXk2NMteUAtb/GY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NBD8bKNz;
	spf=pass (imf12.hostedemail.com: domain of med08elkadiri@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780816013;
	b=uRuS3ZlseRnLSTmEVB2gsUw7O59/Vi20M4dGBnlfGx8rweoIrC6YE+lghLF5G9ntsANRZs
	62vSBmrkDCaoBK3mKrI0qbDqeCQPYT/Bp4eXc8Qyz8Ck9yGe0UjLJaR/WnjCOm4rven8Ck
	ehe4qWLDHYk/2t2kotUNP/KC5L4DOrI=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490b7866869so38403245e9.2
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 00:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780816011; x=1781420811; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EjFCfZnGIYF5PioRnZOk1Y+cKLSfcfAJ9sx8UaHZ3lQ=;
        b=NBD8bKNzwJ0kPmqaWLb882R4Gb5xkhOMPyclkJW75dwtrS6ZqdFHPpnGhv03ITyS44
         bL3QHLxx4yrx97Q/NC4ynSDos7V79XgaIBaRd0yYLS33kRPhB65Sg6KoaOizLwbih/QF
         12U59gngIFrszFgsY5e91B4xCXMt3lQB3JgNWGPk1hNYi/2sWEI8rBNaZ5vDKPgDc/QC
         J64znSinwZIhT6tymc41UKY1RwKGSpMVqvJ+btaI1ePONPTDvzPT2hejr1JdzpCnTp/X
         njqsTtck99BQ5Ye6Gg9KENZIx7xaQBMhToR34dkaI/mewWoaXmbUzh0iRv0NYRRlEoE2
         ovZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780816011; x=1781420811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EjFCfZnGIYF5PioRnZOk1Y+cKLSfcfAJ9sx8UaHZ3lQ=;
        b=hjPm7gLn0ONM/nlizggEqmr6oQX0Nvc5EZHMgH9nk05oohVFF1j5WO0owXSssX/+IA
         5mXJ/21aU91J6/k7Oifz13JETVtfnsZq6fGQRTH79Lkh6aoEQg5C1JoA16GNGrvHFNRh
         r/U5CFWqnFZOTqIyzFX8hr4wscoTDmaN7l42zMEnJTlu/n47gSl1/V/1M/O6g4Dlxrcj
         PPBApldNGg1wSulWeG3ysHJJemSEt+Ps81Kir7UXKbMywezb6MoCO4sS+lkL5bUzpuUo
         aaT0kiS+k6BjVzkeCp2cXfBUQpBgvv72NbdL7UYEowqFa5GnF5V1IrAhX+MUA+3J1y0N
         YL1w==
X-Forwarded-Encrypted: i=1; AFNElJ8hJc6z101QA8Twn9iRupxK38XRy2hAa8717NJIvBLfjfWjejU08xjYBRKmgm3ipKxrL3hRHhyGtw==@kvack.org
X-Gm-Message-State: AOJu0Yz2H383hn9+5KaKEK/0zRGH4JQ2Ba0tGOJl1HJiUMVCXM3rgVrJ
	fiyADaUSQp4UiJGfygWgUkJGlwXEnEOHduGcx/00vTLioj2mF3ov+DM=
X-Gm-Gg: Acq92OHDchI4yVuxcStRK8NUyzYImAw6BhD9RMyRy28M5r0Qfl/ujqZy9fHIi1pdTEN
	wpVyDH1nyOnt1Hu9EofT5v6qW3DL4p+Smq2lWrpb3434vaB1NbIJwTVroaTXpoGVIj07+SVp61t
	kVptHEw83u6WwyDJXAAJGHPCpOkvOV5lila3Vek2Afr05OcMtq6B0Enwcf0OCCo6tfmqrszr4wm
	vnoN8aLjH7eRNqDiObADHTYLjOwUQ6heapadxqGyzbR9VvYfCZCvazmRmYUAHJVMZG942Pm/4ra
	qI8T6Q1uzkm8rAi6Pfbqhrhjx2VubKx2zWzsjKPMRmwsMreKH3c5mZz6SopwWWGt39q8oWN27CD
	llQhD6/Rp8XKgxXni92nJf1BO/PWluJLC5QNd8w+ZJhpuM5Tt9TYWWoZjmtJU9AIbGmcGap5jPJ
	22UOEj0CqCXBeHLVoTiSZ4kJcYoUZGSgS20tlVuOOclpoi6yRMXrP836DQDQ9MWxd6vIiqj27gd
	oxC9DbrubvhQanh8W+zxk6uzouCuSVJjklFP9zvjQ==
X-Received: by 2002:a05:600c:34c9:b0:490:688b:f10d with SMTP id 5b1f17b1804b1-490c25b3549mr184516635e9.7.1780816011186;
        Sun, 07 Jun 2026 00:06:51 -0700 (PDT)
Received: from hp-ubuntu.. ([41.248.186.206])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f344762sm44225082f8f.23.2026.06.07.00.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 00:06:50 -0700 (PDT)
From: Mohammed EL Kadiri <med08elkadiri@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mohammed EL Kadiri <med08elkadiri@gmail.com>
Subject: [PATCH v2] docs/mm/slab: document cache isolation with SLAB_NO_MERGE
Date: Sun,  7 Jun 2026 08:06:45 +0100
Message-ID: <20260607070645.9559-1-med08elkadiri@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260606155856.15548-1-med08elkadiri@gmail.com>
References: <20260606155856.15548-1-med08elkadiri@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EE00840004
X-Stat-Signature: fr3snd1ya59w7j3kcuwtef6xwtdpns7j
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780816012-552180
X-HE-Meta: U2FsdGVkX19dRL49SJRkvLe9yNy7wmV2u2DdOqYRhz3gwP3sfQhUsQyPWqdK3F/LJ+ewpMm0/0rCnU5EhqKumfoWlthmyepfWPj9N5lyyEjHB87uskDEnxA8GE8J97mSw3ZsjA9Lq1jwYt7B2C+PNLjfFUXxBGy4Kf+Agel0mGSV1SCg4VyE8DGyy74n8Bn0r+kTc1prDDy63NTabIhwQA5C+mgMEvtFzqIb/gDkHcoh0AGo5ik+cJm1E6aikPRK5DbWpRoFO77B/3r0ZO3yTYrrWw8sxsGBddN+ZOW7++rp2/HYr7IfhG8PsouQCz497hfSbGyyZN+nPy0VCKJo+JBtO7GsGA8YBtwTPhNxle9aQfe0AsGDKrRjhun0CrPSM3i8yCWPhl4vdL2NQCPfTaybqKWAiOufRb1G+6LvS0jaIQXMe1f4wWvXYSVxQspkGKvHOlkOOdQb120CiQjFmmR4eXzXU5KqOfNB31OWDFjBdMRpk/1JpMFYUuhGlXYAtI2PNzNLREV3hODKsCDKi4l7JN6ofMHxA7afGvYcaczWNSnz/llXi9TKrZtK1lxMVoGExtjeJgVbk7ZYiQtBGvcH0nq2SY7wJIIq8yVa0mmZ4a6cc9/hyYeIclLGUHLFd2Uc1K3sordygP8ttKFoMkVT15LAD7Dr7aV9jcGTjaqEMbaZUNaYlE+lNvGXb6QmAkXwtTOJjI0YO118IeaeU72ipJm9X9puuIZQmRKY5WXH6pNMzaA38OTlNtO6DPPPFzcWyfVXtS8n3TelAT9PArkEExSyX0IFVbiub+AxhagEuJS094jyCiv0Sw2DqXa0W1XND7tD48NlOMSPE6ki17KcOZjyFf/3jLK3iKG6gak8kLOx8k7I1++S26EIOPkiCBD4KzTu4QjQG6kQS2TcSP0veGS4u6NKnd0sVHqq9Uu4+M68jJy1b6dOxaTcLEyFS01BCoXXBFIMVKnnE0R
 fyaeJ2Cg
 sY1AEcM47JotD6WIyZqf5lFKWxpPMwdOEme0o5M25bimedQ8iWVljztE3efdlGjDXFeR58GVhKsZlZgUWqAIC/BZ1/YLZAF7kcULtrX9gcysSvOftG6y6C5PQ1RITMNc+3kceCV0bfXDMgCJ8FfuP0S29gxVcFYdiCOCH71aywBYPO3ixOhoUSe143nMYWIvni0x9f9FkylLn3SwEz5nym1mlVdW2r5eIcl68Zu2TLnFHuzRCJlmDoYDQt/Q2CNAIekDUhGURB6YcvjillVrki1xb/i8kRQnTUop3P4C4Bk/l43/2qvbBslMt+5/6uIEsFsB0K33JpgkBC2NgX0HlTHKKGNSpsdI3qQfzOQ1vWnhgXR4gQ0AlVlz1yTmTDy7Fh4HTBZGvpVZgbXOXXME8AEpRE7CTlo1GHZMW43w8dETK+/fqviMFYbP45bQ0ZlriheNHB5Otij+bT4lA0utFvXZpUyynS6yhEIF5Upm66h3+17Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation to slab.rst explaining when and how to use
SLAB_NO_MERGE to protect security-critical slab caches from
cross-cache heap exploitation.

The document covers:
- When to use SLAB_NO_MERGE and what it communicates
- How to verify merge status on a running system
- Tradeoffs (memory cost vs performance)
- Relationship to CONFIG_RANDOM_KMALLOC_CACHES, SLAB_TYPESAFE_BY_RCU,
  and the slab_nomerge boot parameter

Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
---
Changes in v2 (per Jonathan Corbet and Matthew Wilcox feedback):
- Add content to existing slab.rst instead of creating new file
- Fix markup: use plain function() without additional formatting
- Use slab terminology consistently, not SLUB
- Remove How merging works section (implementation internals)
- Remove cross-cache attack class section (redundant)
- Remove Bounded allocation volume criteria
- Rephrase unmergeability guidance per Matthew Wilcox suggestion
- Add Assisted-by tag per coding-assistants.rst
 Documentation/mm/slab.rst | 60 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/Documentation/mm/slab.rst b/Documentation/mm/slab.rst
index 2bcc58ada302..c485bd257c44 100644
--- a/Documentation/mm/slab.rst
+++ b/Documentation/mm/slab.rst
@@ -4,6 +4,66 @@
 Slab Allocation
 ===============
 
+Cache isolation with SLAB_NO_MERGE
+===================================
+
+The slab allocator merges caches with compatible size, alignment, and flags
+to reduce memory fragmentation. While this improves memory efficiency, it
+allows objects of different types to share the same slab. This enables
+cross-cache heap exploitation, where a use-after-free in one object type can
+be leveraged to corrupt an unrelated type.
+
+SLAB_NO_MERGE prevents a cache from being merged, ensuring it receives a
+dedicated slab. A freed slot in an isolated cache can only be reallocated as
+the same object type.
+
+When to use SLAB_NO_MERGE
+--------------------------
+
+SLAB_NO_MERGE should be considered for caches holding security-critical
+objects whose corruption leads directly to privilege escalation, such as
+credentials, cryptographic keys, or capability sets.
+
+It is harmless to specify SLAB_NO_MERGE even if the cache is already
+unmergeable for other reasons (e.g., it has a constructor or a non-zero
+usersize). The flag communicates intent and ensures the cache remains
+isolated if those other properties change in the future.
+
+Verifying merge status
+-----------------------
+
+To check whether a cache is merged on a running system::
+
+    # Check how many other caches share its slab
+    cat /sys/kernel/slab/<cache_name>/aliases
+
+    # aliases > 0 means other types share this cache's slab
+
+Tradeoffs
+----------
+
+**Memory**: Isolated caches may have partially-filled slabs that cannot be
+used by other types. The overhead is typically a few extra pages.
+
+**Performance**: Zero impact on kmem_cache_alloc() and kmem_cache_free().
+The only effect is at boot when the cache is created.
+
+Relationship to other mitigations
+----------------------------------
+
+CONFIG_RANDOM_KMALLOC_CACHES creates multiple copies of each kmalloc size
+class and randomly assigns allocations among them. It only affects kmalloc()
+users and does not affect named caches created with kmem_cache_create().
+
+SLAB_TYPESAFE_BY_RCU delays freeing the slab by an RCU grace period. It
+does not delay object slot reuse and does not prevent cross-cache merging.
+It solves a different problem: safe lockless access to freed-and-reallocated
+objects of the same type.
+
+The slab_nomerge boot parameter disables merging for all caches globally.
+SLAB_NO_MERGE provides the same protection selectively for individual caches
+without the global memory cost.
+
 Functions and structures
 ========================
 
-- 
2.43.0


