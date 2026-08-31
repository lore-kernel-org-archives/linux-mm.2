Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B97BBC624C2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B903B6B00A3; Mon, 31 Aug 2026 03:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41726B00A4; Mon, 31 Aug 2026 03:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56A76B00A5; Mon, 31 Aug 2026 03:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 793C26B00A3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:55:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF94040010
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:55:21 +0000 (UTC)
X-FDA: 85160804442.09.5B58771
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3438EC0004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:55:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jo2TUH4T;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788162920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUo/y6IjpqbcIL2TFvU1ITTKCpXfhtvRzwNLV1+yihc=;
	b=a2aiEXkDJIQgUGM6mZ5M3MyBPQHZKmq37DG+vKJNui5Lwer5V0JNWNjJNO3nBW3WEX8U1I
	MgcVNYLkI6L4kXBBCMMcxr6Mohst+HYTBXRLbx02Npi7HFUJ9rNMbzzpvorPhmq7+m4gCs
	zGBbF7ProIg34E1z8LVhKH/Cw2sjxtM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788162920;
	b=j/OCnkK3p5VSwai4YjuNYqIeTtviYtnK8DrbBSx2c3Bfk6MqZgFCSVTewyUH5EIxbLMfIZ
	V+qPYihuXP1nOSAl+bWMivJONer1xqFAhK6f4bIeR/N6/G4fKbTDYiS77z+aM7WpG/EG/U
	sg8tj3LzDEZOmLEtqFawgMLvrQJ6f14=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jo2TUH4T;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-853c07a76adso3271603b3a.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788162919; x=1788767719; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UUo/y6IjpqbcIL2TFvU1ITTKCpXfhtvRzwNLV1+yihc=;
        b=jo2TUH4TPB5c5EIOgDjn98A9SadbOhYQJO0URFnCThJjz3wFhVGtzrL7r2w8qF30HE
         D74jyBRtY/PhbG2SfRsgKlW/brjNnj0ytWnkskelIes9n4XBEfpVcQeu8oIJrUJteyqS
         hBkqRWn6tzD/nsurTaoMbR4y0km1OxXC6yqbbi4xeCrC3i6loUp17NHIoJI3Jd5WN+Mt
         VvcvsODkKieNvNqbQ1JonNYLLH/ohMDwy73BgQsU5TpZKooVki3FkjMcCu6Ye81zhKVi
         T2yT2sRQjDNE1gJbHvA2vYceqlZvdfpG3NT3jxWO9Rvz2bXQK4q5zRGcfOp93A/AYP19
         WqmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788162919; x=1788767719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UUo/y6IjpqbcIL2TFvU1ITTKCpXfhtvRzwNLV1+yihc=;
        b=qMMp6FxEWfh7lHWS1leuggLDh2WxLVcAoOpFvtldeHMzERcJb+EFRc8HFG2mBVzYu1
         +HWLt1wKVhCOAOl9T35WErffc4yKikKUPEbLy6f4wmM74+YwwxO3UH2ur0pZZ+1W+znC
         mOtAtUJ68RKWenIOOp+y3MTAcEdiSG6JLcT88FZ3Mw3wLuAOrG/kTkZInnSnYCM87AK6
         8JT9Sf2sb6iOSWHwIHmkyAlYNrRFSNw7m4qZeJWeRRZkxJR0+rJ0IpBqizSw3WeBlgGm
         +Ts4Lm+biKZWwi7D5PccEyi7EKb5D/u2AcPuC4nN7c/nQkSP5OnLjOvftzy1b4jHvdmy
         9mgA==
X-Gm-Message-State: AFuF++kf8Sz5ehJHJ347YN0OQQmctfImtihp1weiPzueOYlol4RSw2Q8
	PlmCN6GcL5ycKnJ2LO1IvOAzXusMrmOM5LxccFkoNW/vO0zx7Ft1reAGJkoXgnWLxVf/a0HHBjJ
	CRFZj
X-Gm-Gg: AR+sD13LK+H0XPW0SkrzfJGwnbdmfgt4Fj27yhlwlkx5vNi3M/odbfjTHhsGPdcKSZV
	HeyaIesP64Pfy9JZ0LvWWVJNKbr6ocU8IMuFwMnJ9GAPjaqIarOEKu49Xy9udUD9Pam7HXP+L2T
	fYmLSMsloFtce28bgscyLPQpoLjJ8kY+kot0s9OmvmOWYU9KKaVfTnRMQGlFLbiij+rEf1V97Fx
	V9FkxcK19msXWiFbUgv1LKtqYlO/IGITMOaks2eczJeC1r2VxSIQP8z8EfVAsBQvS9cvU0GzU98
	3tBfPmKW4R7S9Ve7+DsYJz3OTZbe8JShEMacQ6ok1SbOW9wglkJ6Pa3bYiaIY1NgQpZRP3pqaVv
	cRkfgsOD/J4fTpaj/mJ10lsnaewSqQI9lIqbaIJMS6kEQ1xc/qz90ofFibX52WkwPAdw/wI3tB0
	5TAxt/iChLztNtR91eITt4BUuTFRcUMAHBWLshXMmaoMHGqRXZVeV4gRaLfaioaeJEmukqHXa6J
	gmAtbCL/xfuMZeOSKhQD9mu
X-Received: by 2002:a05:6a00:f0a:b0:848:4859:a45 with SMTP id d2e1a72fcca58-85628988a7cmr40655921b3a.2.1788162918893;
        Mon, 31 Aug 2026 00:55:18 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f330f88csm3590256a12.10.2026.08.31.00.55.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 00:55:18 -0700 (PDT)
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
Subject: [PATCH 11/11] Documentation/mm: update DAX vmemmap deduplication docs
Date: Mon, 31 Aug 2026 15:53:42 +0800
Message-ID: <20260831075342.57563-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831075342.57563-1-songmuchun@bytedance.com>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: js3docs9rn5zmju76ppkd8tqfhtgmpty
X-Rspamd-Queue-Id: 3438EC0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788162920-644607
X-HE-Meta: U2FsdGVkX1/QSzt7vLDp1pypeOduRTBBY4czEh6t0DRvmS9E1kPyiLcnYUrdV8XgI9OAS89qc84VQ0uHf6yve1xy1jEFE29XJOuwA5DtV2d0HPvUirC3SqzaPLgYJKqnEjgOjJFaBxY3B4F8EMjmpDtw1QXn7AanGZhrCmCv/91koFyj1/ZhB735N6TsUYI2b6+vAnKLQ3ODWuoF9fV21MzpSlUfEfRCUIAhYICDA81zTgqRdvtKi9tKFxRCR9tif8W+lI/+y2lzvWXqBOi5lDtFGhAFaZnzfhPGECMO23x2W3gsK7U5y5nq26oqFtB19fLRVG7bteDPRHqYD3ipzLFz3Z/cwkl/olwLUUq2tZU6Zvuf84nZezmh3COxbXjrZ2+yJPg8rfPxA9qtibVZuCcxcqsN9F+IVgEARZ0A6HHzINIk3/YdTPqF34c/Kb0gy9FpTxQS4rTHnDNpukUZagK9BrhpU2/F6AvxWpipQkrXcif/6Y91AraORDBC44NIIQcMWEdlxHA9ZYQQJ7PLbygEbTKpjZqFlYO4H7pyOPQ/NWkQI8so9ASQKLdLMavxsS8yF8Y/2dXO5F6sH90aQbhteCSQWZE2zUqVGlGGnxYGxA2bwOY9Hj62hBfG4/3ZwP8nuFj9/UB7kXOrTlp/w4xuSzMQ3X+inBGwTxtmFyeSG0INdkZLCwhJmOWafO1PaiCQH4RcOlBVnAFYYzww56NtYp87vfySDyFmysZjb+jvGuq+GCtH8Mxb2HOMlX5CEFagQiqKppa5oKrgjiagvWiiri45Q2Lf6RQ8JQpDSO1TOW02ikPXcP7ftBgolWXfGHV4w/AI3l5VBmJycCr5TyR8U+UpBwq/gAoGmYMZmS5PGd4wpap3Kr9KoIUBalX7qbw2pCfC3prWqmGdD80JRyYKs8rT7YKTCqrzfHDzFarOPZvyBmZWRyVXMGZIVexukT0SpixLvg/MYpNdj+2
 4uC7lmZg
 q0f3tZ3gSUZeo9wr3cxKEg6NFQga0DjBdZHZNOZl4a+DpUr6cY1h9Dl828G5jVzoBsbDlqjNUHd9kuctq6/stJCoGYp9trbvk9BYTBIeXy9UoduaO3LotBt6JU5fD1kma1xMa62lZcU93SCwAG8M8ZEjgs+QQ8LvGDpaJCgtHecxid0z5r+acLIvxq9TwB7Zdhd9fekPRtiCb5QD7Z66PfVKhQP6MQJOLhk43lgbQBsElRtpNmaf1TxV2tL1rLzvqt7xf6feRVDzJuFrDrFVbKIajmJrRwFWQyna4ro/zj76z88ONy06dUuojiw==
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

Update the generic and powerpc documentation to describe the shared layout
and keep the powerpc-specific size calculations while avoiding duplicate
diagrams.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
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


