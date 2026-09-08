Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 923FAC79F9F
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DFAB6B00C0; Mon,  7 Sep 2026 23:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96BDA6B00C1; Mon,  7 Sep 2026 23:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833386B00C2; Mon,  7 Sep 2026 23:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52FB46B00C0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:04:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC13C140344
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:51 +0000 (UTC)
X-FDA: 85189102782.15.7C25F95
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 383E9180004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Pt4muwn9;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788836690;
	b=q3CDjzWBSYNaA+xtslmBOyTnnBmDQm9z+QKMLExlH27uECm03YbFpBZpkewVJHrqywuiGu
	xq2froFMjKxr5Ag7zCZcU6SWHvG8Q80ajb5Tyi3Ia61qorqr0to65F5xRrqG0Do+vkdiIV
	Bau9a/gRNoIWN2bX1JiGrw7EdhOIgXY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Pt4muwn9;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQIwuT52UGUULzXnvd9jyK7/apm1xntD2qx3gMLc028=;
	b=7vLvHjPQt6hby1p3XxQS12otY189OJa+yXK3yurBNuIFOM+y5+B+uyR9zYpHYkrQ2b5Kt1
	11seHaQWGX50sV0vjMYgOeeOmZoWPkLXn+6Iuj/HQbqmT9MOl3HufiKjXjMJbYdsuFoOaT
	DxdxKopxrjLj9DoNYHPkkfgxBrkeu5g=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-85339ed040aso3212077b3a.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788836689; x=1789441489; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IQIwuT52UGUULzXnvd9jyK7/apm1xntD2qx3gMLc028=;
        b=Pt4muwn9w7NFzbvvXEDJH+BPNbfm6rkHdMnzeZp8IqthAeD6c3Rdb8Zm4Ct86QBrYs
         iec7SXGcOIX22JZO1MiXZnJK/IHHiZlwOfeTs6Dj+SkodfLgvzMEtuDCCEoJz4IX/u5n
         HMfXEL78HPReEkSvFUyV+DAtf4PHdvSqZzIFU7LLOdB/pgpZOFDJQRquBeTghn3Gzedl
         RDzoYnc563YPdUA3KAxbHqFyEuZQxKTIj1F5LUyTpct3WRDMVkg3fs0LUmkKDBcXAty6
         cT6hKEKQ5D+H8X1qQd27hEk1oZwXh3Ev0Mt5ZVdf1CG5SKd4vw34ZOZHyuw6RMxzt9SY
         Y5Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788836689; x=1789441489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IQIwuT52UGUULzXnvd9jyK7/apm1xntD2qx3gMLc028=;
        b=VI/MZONVM/8c7JHW5JgjKeFoCCv38X2vyREMWyCheclFIWBUYzWhSW3woyaDG5BtAZ
         csrfu3lzFd35V3VmDQpfTuw1WmfIlUActZ0gU8ouyBhMLNp8RKEefdgQShfHabIzM/ja
         ehN8FJqlLMbqrXJXuZl3EEsS/gD3NcFc4QB0KgBhTLxiLIxXDpyeYwq1kBxkZ6B7InAj
         yjWaw/TkCeVDQCR24MRFkVKEZLFZcEeUEl0bCQG2YIq3D3zTxoHmnN8WzKzpWyISswF5
         h/o8ahHPHONYUWwVORIziC/iggArDCcg4iUgyQziswG61coNKyXRIDZPJYpVnuvQqpJN
         B4Hg==
X-Gm-Message-State: AFuF++nMY+1ok2Dy7003ZWxrC6bsxQP1SFxwC1pkgJrGvUXrZnqADeOG
	l6fcnztNjwzvSfrSbZgtiQydaBAckO5EGb1x9RIUf0l0IjangANR95YGH4EX4pDB6l4=
X-Gm-Gg: AYBFou151AszM28b86pJXg7XQHTx8M04qVWU3W28ZPp3W93iv93cD7O3WTO/IME52pM
	0ESra7B+nAzbFX+86vaPTcyL4pIicOtzBujgVcYfiUmqxtHD+4s9gsbzXM0PUppU2DTGUFpQidh
	moEwh9AKWYzUCUKdehr9TOl1HgLYmtG0aBCnha/KsEe3t8Vbiv7ifSIUt5Z+sDJsbcgru57p4Zy
	rLg7qYA/LqqeYf5dTbEMOgl/pIjd0a8mEkuFfhgZ/v2Jq4yvpDS7gpMpnPavbVzaN7aXQ3Pgvle
	51Veuc0oUhJInF5cp5M10VnMKW3rvzQonIAoFqH8iZBpHWUOQI53S6qmvVBSsm2OeMC7FqFxmgo
	twmDo6mEIfa1EG4DHl0mt3sdMvDcUh9Jh9tzRoI9KUESp4bxdF4e6GFVJ2RjdvwSdYTQVMRROSG
	x+mXAqODaDixBsQ4YkkPdWvDi2tGZU9OCJ+kLHYcZBjFwkVF6JBsqWpQgQ66P/1wwfJyWLxRWPq
	nXuUSoL+mVfZrmfGHdNseLvB5h8RmkDsww=
X-Received: by 2002:a05:6a00:400e:b0:84e:e741:174f with SMTP id d2e1a72fcca58-861669c6df9mr39676733b3a.7.1788836688830;
        Mon, 07 Sep 2026 20:04:48 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152a358a2sm4868234b3a.29.2026.09.07.20.04.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Sep 2026 20:04:48 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 11/11] Documentation/mm: update DAX vmemmap deduplication docs
Date: Tue,  8 Sep 2026 11:03:35 +0800
Message-ID: <20260908030335.96549-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260908030335.96549-1-songmuchun@bytedance.com>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 383E9180004
X-Stat-Signature: 4gskc6xt6m7pspmdph74kqhdi39xg1sk
X-HE-Tag: 1788836690-612218
X-HE-Meta: U2FsdGVkX192LzFE1RAj33Fg0Hdy8EswdV5deaRHTwaDJaLOe61r6nTPy/Nw7muqctyiutfHvDGk/BD7OCJDAU5t/RMFlHetHnDybAMJF7g0c4unN4yzkjQQ13EqM12064/gzNg0ieitQydb6GMNDXnrJT8TNg96JpQX90+t6mii9o7poe170Rd4wlRQMMRIDHqq/SC07m6onZq4aMq90wW5WwCL6FPD/XdQvVq8WdA1sl/ghUqzUeCICPd1WBSIzBa6co527VGfYXCE1agp62QPF3sBo12i42k9UOITXaWyJvS1LRI9+qWLqJdo+gCqLbio79AM6NYhfsqWyN0xUjGSJALXUH7WRR2wTUFCQtREiIyczUIsDHKaD43noCo3Uk+/lER1FL1DHTklFgtvo14ZcvDTNpwjWGG9NMHY471tuAuNBR2U9jISVNnNPCaNMaErNXkyIkM0+20H2QfECNlyeYjrzU7kDTvBfgD5wEXOmnmO4wgRndQb9ABmSNQWwgQLzVGyTSfhUaXQrh4fZnKvtHxwnhsGtfKUWKuOIVep74SkJW40F4B7b9b0qccHXicJrtAkosYfNlR1amC6Qx/cCT9bCK/9ZGshfj73j3A7TFdDTUuvXlONOC5o1PWQ2t1opn/3neJ2x9HQBZ5Mb4yDDz1kRuU/msvU749Zn1S1MAm+ODYObqDf3vNmitHLVhN7tywBlWcz9I2EnDmm2aIR8CmnM3I3pavrK7ZpOq5W6ydFZcx+ANUaQxdXtF69YrfvqwYoNszWm5w+0Goc1CARW7jbjkNU8OvhldgOGYzwTAN0T08AnAl5o+IFIjU3J6XZy3z7i6TDmL2sJu58bd8Ccuao7QRXs95MazoITSeqH1o6gFsJa3Esx1tnqfj4I0IIktWpT5e045OtRkKpeck7WwvFnaDNg27nE3zz67EWoXa1CqUEw/pCRPdRYxSShFkgUR551qLTdXqDrAi
 iskOkYaC
 FNjMPrGO4DAUBBfi1T89KG4Agxn8JWh0hzHCGOiP4e5wCxKRgulT/aMp5yVGdqNAMNB5EQkiycUcdVX517a4WEshUDPk8ZngLbb4Whc3pfbMhvRWLZN4W/bmDiu9zSsN5wW13LGRH9ti4bB+z/LAtBlahpzIqF64fNFeJHRYMru235J1AZMhO5NguyumFa/dY3woHxdrgiUPT1lZLXg6DPB19UPHCd+fUPsoIm4Z7TwFfrMuPvk/KuwFKlPcNYM4+jHV/v11d0GX3pKINm5LyVyq0wA+knwg19X1ovOb2ubL+Zo76bCdVC2gSTGXAOisrDjHZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Device DAX now uses the common per-zone shared tail page for vmemmap
deduplication. The old documentation still described a DAX-specific
layout with a separately populated tail vmemmap page and half the HugeTLB
savings.

Update the generic and powerpc documentation to describe the shared layout.
In the powerpc document, keep the radix and 64K-specific details, drop the
duplicated 4K PUD arithmetic, and replace the repeated device-dax diagrams
with a single parameterized PMD/PUD diagram.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Clarify the commit message to state that the 4K PUD arithmetic is
  intentionally dropped reported by Sashiko.
---
 Documentation/arch/powerpc/vmemmap_dedup.rst | 90 ++++----------------
 Documentation/mm/vmemmap_dedup.rst           | 32 +------
 2 files changed, 21 insertions(+), 101 deletions(-)

diff --git a/Documentation/arch/powerpc/vmemmap_dedup.rst b/Documentation/arch/powerpc/vmemmap_dedup.rst
index dc4db59fdf87..8286acbca9bc 100644
--- a/Documentation/arch/powerpc/vmemmap_dedup.rst
+++ b/Documentation/arch/powerpc/vmemmap_dedup.rst
@@ -19,82 +19,28 @@ With 1G PUD level mapping, we require 16384 struct pages and a single 64K
 vmemmap page can contain 1024 struct pages (64K/sizeof(struct page)). Hence we
 require 16 64K pages in vmemmap to map the struct page for 1G PUD level mapping.
 
-Here's how things look like on device-dax after the sections are populated::
- +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- |           |                     |     0     | -------------> |     0     |
- |           |                     +-----------+                +-----------+
- |           |                     |     1     | -------------> |     1     |
- |           |                     +-----------+                +-----------+
- |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
- |           |                     +-----------+                   | | | | |
- |           |                     |     3     | ------------------+ | | | |
- |           |                     +-----------+                     | | | |
- |           |                     |     4     | --------------------+ | | |
- |    PUD    |                     +-----------+                       | | |
- |   level   |                     |     .     | ----------------------+ | |
- |  mapping  |                     +-----------+                         | |
- |           |                     |     .     | ------------------------+ |
- |           |                     +-----------+                           |
- |           |                     |     15    | --------------------------+
- |           |                     +-----------+
- |           |
- |           |
- |           |
- +-----------+
-
-
 With 4K page size, 2M PMD level mapping requires 512 struct pages and a single
 4K vmemmap page contains 64 struct pages(4K/sizeof(struct page)). Hence we
 require 8 4K pages in vmemmap to map the struct page for 2M pmd level mapping.
 
-Here's how things look like on device-dax after the sections are populated::
-
- +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- |           |                     |     0     | -------------> |     0     |
- |           |                     +-----------+                +-----------+
- |           |                     |     1     | -------------> |     1     |
- |           |                     +-----------+                +-----------+
- |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
- |           |                     +-----------+                   | | | | |
- |           |                     |     3     | ------------------+ | | | |
- |           |                     +-----------+                     | | | |
- |           |                     |     4     | --------------------+ | | |
- |    PMD    |                     +-----------+                       | | |
- |   level   |                     |     5     | ----------------------+ | |
- |  mapping  |                     +-----------+                         | |
- |           |                     |     6     | ------------------------+ |
- |           |                     +-----------+                           |
- |           |                     |     7     | --------------------------+
- |           |                     +-----------+
- |           |
- |           |
- |           |
- +-----------+
-
-With 1G PUD level mapping, we require 262144 struct pages and a single 4K
-vmemmap page can contain 64 struct pages (4K/sizeof(struct page)). Hence we
-require 4096 4K pages in vmemmap to map the struct pages for 1G PUD level
-mapping.
-
-Here's how things look like on device-dax after the sections are populated::
-
- +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- |           |                     |     0     | -------------> |     0     |
- |           |                     +-----------+                +-----------+
- |           |                     |     1     | -------------> |     1     |
- |           |                     +-----------+                +-----------+
- |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
- |           |                     +-----------+                   | | | | |
- |           |                     |     3     | ------------------+ | | | |
- |           |                     +-----------+                     | | | |
- |           |                     |     4     | --------------------+ | | |
- |    PUD    |                     +-----------+                       | | |
- |   level   |                     |     .     | ----------------------+ | |
- |  mapping  |                     +-----------+                         | |
- |           |                     |     .     | ------------------------+ |
- |           |                     +-----------+                           |
- |           |                     |   4095    | --------------------------+
- |           |                     +-----------+
+Here's how things look on device-dax after vmemmap-optimized sections are
+populated. ``N`` is the number of vmemmap pages required by the DAX mapping
+above::
+
+  Device DAX                  vmemmap pages (N pages)         backing page frames
+ +-----------+ ---virt_to_page---> +-----------+   mapping to   +-------------+
+ |           |                     |     0     | -------------> |      0      |
+ |           |                     +-----------+                +-------------+
+ |           |                     |     1     | ------+
+ |           |                     +-----------+       |
+ |           |                     |     2     | ------+
+ |           |                     +-----------+       |
+ |           |                     |     .     | ------+        +-------------+
+ |  PMD/PUD  |                     +-----------+       |        | A single,   |
+ |   level   |                     |     .     | ------+------> | per-zone    |
+ |  mapping  |                     +-----------+       |        | shared tail |
+ |           |                     |   N - 1   | ------+        | page        |
+ |           |                     +-----------+                +-------------+
  |           |
  |           |
  |           |
diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
index 9fa8642ded48..8c287ae3f86c 100644
--- a/Documentation/mm/vmemmap_dedup.rst
+++ b/Documentation/mm/vmemmap_dedup.rst
@@ -1,4 +1,3 @@
-
 .. SPDX-License-Identifier: GPL-2.0
 
 =========================================
@@ -192,32 +191,7 @@ to 4 on HugeTLB pages.
 
 There's no remapping of vmemmap given that device-dax memory is not part of
 System RAM ranges initialized at boot. Thus the tail page deduplication
-happens at a later stage when we populate the sections. HugeTLB reuses the
-the head vmemmap page representing, whereas device-dax reuses the tail
-vmemmap page. This results in only half of the savings compared to HugeTLB.
-
-Deduplicated tail pages are not mapped read-only.
+happens at a later stage when we populate the sections.
 
-Here's how things look like on device-dax after the sections are populated::
-
- +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- |           |                     |     0     | -------------> |     0     |
- |           |                     +-----------+                +-----------+
- |           |                     |     1     | -------------> |     1     |
- |           |                     +-----------+                +-----------+
- |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^
- |           |                     +-----------+                   | | | | |
- |           |                     |     3     | ------------------+ | | | |
- |           |                     +-----------+                     | | | |
- |           |                     |     4     | --------------------+ | | |
- |    PMD    |                     +-----------+                       | | |
- |   level   |                     |     5     | ----------------------+ | |
- |  mapping  |                     +-----------+                         | |
- |           |                     |     6     | ------------------------+ |
- |           |                     +-----------+                           |
- |           |                     |     7     | --------------------------+
- |           |                     +-----------+
- |           |
- |           |
- |           |
- +-----------+
+Deduplicated tail pages are not mapped read-only. The mapping layout is the same
+as HugeTLB.
-- 
2.54.0


