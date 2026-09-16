Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A06C3C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472D56B00A9; Wed, 16 Sep 2026 02:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423ED6B00AA; Wed, 16 Sep 2026 02:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29D586B00AB; Wed, 16 Sep 2026 02:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D9FA06B00A9
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:44:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 29D45120623
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:47 +0000 (UTC)
X-FDA: 85218687414.01.CE92F64
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C0A9100002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eL77H97Y;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUhtpwjDYsFhZVHLtQ8dC1wt8tqWIMzZ7omgfR51vXw=;
	b=VSquE6uyFOnSuiBs2BtkOFwJTPH3ZkCDqzXwyWJN2XQIRbYrTBkKUX3/Xreoj/D+nOGlkY
	QPGLfIlTUsQV9B63Frm47gxHRULvwhzYT03r07jhD4T522TaTBB3acUeG45d5UD/9gY9zj
	UUaSWtQcuB6vNPjjuHgGFGAqruXilNs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541085;
	b=SJshr2E9TECCBPvKs5smz0klaFEnbSI+QaXSzy77j9jGxIVP8toDAdlHxhVIumW3djssZD
	Np50CVAKeuT9bsvdvXmHvjcO6AUeUMxy6JE50sJT5h/7eqr+xvgRu1EmFXwzxEVdUuYkhI
	Iap4g3+mm+TB8TPp1b75P/a483p9/1I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eL77H97Y;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd88a115ebso4665275ad.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789541084; x=1790145884; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zUhtpwjDYsFhZVHLtQ8dC1wt8tqWIMzZ7omgfR51vXw=;
        b=eL77H97YMYAdJDNdxDIqaa+2sgmlgtISc6/nYs7W397snQv0Wc8pxUdt7MMIvmpxRe
         2sDdoX71LgYqsAoob26HYYxrAkNXpsmUQlXsJ9In2Fh8TjiSS5VaWSFOeXF1CQMpvS3T
         wm4yyD/h/6V096TMod8CiTRFcQNqH0WLRiCYl84HGhB5FssaDld4n3Q1Gk+zfeixjkwi
         eRUBTa3M58/UnNrjszZDeAOcclTsnhm1SgdM/3d4LK+Q9Pex5QrSBLbXe6R4LzjlzPXk
         G7QC+kuQq0wgcgr86Mob1Hv7L2cQIX5jLmzYMYCcggjOVX5tS7c7Ekr/Ncpfb297npzZ
         o7tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789541084; x=1790145884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zUhtpwjDYsFhZVHLtQ8dC1wt8tqWIMzZ7omgfR51vXw=;
        b=h02TKyRJ8YG0eqwIp5lhTWecd5MIvfmDPLhX0jMPwOydIIH8f2bkbwsFETw9qiAMeq
         U8A+zVHQ5EegDmKH09iADfc48uxViFs2MErbFp9H3iawvg0lOKNuMbLQGq1v5kQtqsf9
         BwHGrOBHpvpDQMSJ4Ju3WpxKm8T/0EQCFLzhRNVur55LaXqHMEf88ag2sruOiYxOFiO/
         fbGwfO1yPXDVTWABjd4pfuyunUnDBkFsz7lVT7GoUj8IkzSfu0Wc3a6ZfB4eXwMccrQp
         PZVFiod0FJsmWv40RWvtAx4DFDPzLIYKikK44tlCIjrpe06WJf+tKRFNMQT/12t0n+yV
         904w==
X-Gm-Message-State: AFuF++leLpNSInFsu6LF08sGexUFJRcq8B2VJJwGxb7qZzzhQwc3B3CB
	RpzigWUYFCdVTMIKYfdRFymzvzMLLYTvbUZJeaLXsNMf+EJ/tDyMGWAaNZXP6DqZaQM=
X-Gm-Gg: AYBFou3IK05YKen+qxZwFgxQlKfDjgJj0cD9zLDU2/cyWZUcIyUzliPHde3LqGiVdmo
	PAXIgTDkPYpe+tEZ1kfdjy7ak0VGoIIusps6vJi3v2so6JN4pfEn2boLgY5GoiHc23LBw+gOEyB
	2O9r6TFfqxhFW4SrC0/644MsvwlDTzdwuG+h7HTOcTj0yAhzQ/O1i+0J5z0Wa9q9Aurvg9uUifO
	12dBLAaDFz3kg6xJjKjbKLZfNva8HPqwaCLZPP6v6HCEoYytzSScnc4D6cUW6dfzne7j4nIxx8w
	2tH0ZDhxa8xf4Y2UYWHeVUQj/yGL/6+mHNrfe/YefkmFiz1k8FB3WDIOrOQ/4twY1thweVaB7fw
	J5RrsTsWubVva90Lk3OybqAz7OgKV0l18N1fgQYbKGW1w/jDty/AbTFn/U996DAolDpupntzR2F
	pnKmsq94JedPw3bIbUl1CF2+iDyBDt3PgTm4XLDdncbkeGoizU/CENMyOItxO6gB7Ia/kPTarYR
	dw4+iGXSKDu1igoJSo=
X-Received: by 2002:a17:902:f547:b0:2d8:df44:a5c2 with SMTP id d9443c01a7336-2dd8e766fd2mr29327755ad.20.1789541084051;
        Tue, 15 Sep 2026 23:44:44 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f0592asm6074755ad.62.2026.09.15.23.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:44:43 -0700 (PDT)
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
Subject: [PATCH v4 11/11] Documentation/mm: update DAX vmemmap deduplication docs
Date: Wed, 16 Sep 2026 14:43:41 +0800
Message-ID: <20260916064341.1825793-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916064341.1825793-1-songmuchun@bytedance.com>
References: <20260916064341.1825793-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yhaf49gs7inbcrurqiot8qeouq6p6bx8
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C0A9100002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789541085-803822
X-HE-Meta: U2FsdGVkX188YVDr6TvkDFnKWGVJSVeQVNIfvz7zmU0rnhsu9TKYFC70MI2X3XaiUX7dHtDY4qTDg7WarBwrO3L88HnKaWBpvZGLYft8f6U/h+NsOIMZVabKT6tsWB80unMIhzAQ+ROiNaMBZiTBxlgR69YLGQyIE+abCPAA/p1kxNrgCa/IkvUV6MSiqJoZAa+ViVaNcFY4ZdBN40rffgnGCEe77Oyhsli7zZSMpt5EmyLXzt2ntUYDQxIf7pTHQb+7F86U/Td8ejW4ul7Wl+Mq7ZcJmIJCgcLgFx4sVkYOnVqhQbPX7tjYMTzx9mVC3MCY04eEupJQXxCQ5bXFUBIS5KdHNVDCGTRxISI8JMeDU9pEb/7EtjJnpIKuTpvIISkYXo3Daf50GAu+xMYnEnxHr22+mZRphTAjBwPJJSfEHW1DiM9yRU4JVeiKkPevkcaX2tRJSbkbC0xIOcf48HK9ZJl+8d4LginDmbBBw+Kjn2Oa+JRw9WcuVlmEuF1qhci+dhXKsW9tadrM3ClCuksODGsU54OH+qE2PEIl/lfVhuM0jLijf0VFH3qFixbUpBJs4WuyNfMK7sk5O8baQh2g9zBgYwgQ6ChRRFlwDqIJBwpeaZWB7XPvzPaJ5pHfjUiZZAbxeaEBMkZkPfBN0o40mIQUWhiE8I/EnOB+5YvesnV3PolgoZx9nig36p62lHJrfDK7fHcKvd7UbWvbFtUDKCAiQkmgzo7FHxRX7SlblB5VZ5x0rOfkHdnHQv67enuVfIhGz8VqXnwMXW+soj/ykV/ZXASXxgCZ5QsakA8e7DgjiXjN8B3NjTGRsg0blv6kFK7Roytp9mMEUWH6GF2ne62r6J9T/qMvf7nsdS/9qqRy9/wkjDrGsL6oN62xr5E4WGT0Onk7XyI8IUMbdobFnNRdnmkNZDVZlmF2pE94ZtgW65YZZF3O21ao/8gYqgFXjLkctTh8oYdHboU
 kXqPdPGY
 0eLS3fyD8VDxNamgDIdhALFrvOhuRO9YLRzy8RthgoZfylsyMvCfl1H+2+DCJSw4gPzCYqHU1rqVQM+NIkLo/JjKrqQ/HjuVOxC+33LZPio4YaEZ2aoe4IgLXr42uNLD/fQBTYHxhEx9XSxMipJk9BzkK6bOZ8eBiGhI8ctzDLXS0JS9qQnJdNp4YMblAoKpoRBUDHaNRdUP6UtWlUDO6QofTVv6uRnf6SmzIbA58HMI3arJY57iAE9mqUQbbOIsll5c5jTJX4bDtmsGf1FPCZu2qyIu0Ck0VtebjaXdjkokEn80t08SOBO9X7g==
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
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v3:
- Collect Acked-by from Qi Zheng

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


