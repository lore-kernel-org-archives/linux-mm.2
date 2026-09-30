Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27841CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 184D86B00AC; Wed, 30 Sep 2026 10:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15C536B00AD; Wed, 30 Sep 2026 10:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0724C6B00AE; Wed, 30 Sep 2026 10:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABB826B00AC
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:09:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3BBAA739E
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:59 +0000 (UTC)
X-FDA: 85270609998.23.2D4FE46
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0B88410000D
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ksGfoBEH;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFs7N1zg+/ZEZHxojTsBYZG7Bu1MLCx/OGkj1iEK8Us=;
	b=nVKZIKYRVbeCV6iarebzsD1NmWmK+SCYh/+z178Mpnrj4z7uYs75WeKuIGhiaeF+z3Rihz
	wmJpw9XgO3W2xDULsUrNUFYA0/Tmm071Jql209UvpMkkumEyh7+w1QRuWKgjNzacacCHBy
	SQbSIoxaYawKT2OXKOJD1DEo1en/Q1c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ksGfoBEH;
	spf=pass (imf05.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790777338;
	b=csQZB3OmaKOKwhBwJOPiiVbIG6fBLfUYyX2qCJ0IMeltoeaju6JU1BLogg3nI336H/JtzE
	56pewNjgt84k9fEjyO3MFG2X/uwqAzwDHo9b3DP0KuasOMAIy/xx0+zYNjukywKlysxDEb
	UvsDEzBWRpSXXhtTiIN7yJKMdyyOTt8=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-3a49573b8bdso1623143a91.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790777337; x=1791382137; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wFs7N1zg+/ZEZHxojTsBYZG7Bu1MLCx/OGkj1iEK8Us=;
        b=ksGfoBEHicPVGvoc60yPcz50aNM8Qf9gxRRixfRvDukvChdIqb7zNDhvofprGC4ZUk
         TEMZB43lGQ4nvtqwEuK5QGEcVNf6X8tesvC3j/YFy7ssCMkHcLATd6gD3cDsZcpJL/Sb
         AuWG3n8YbRgYWqFAOzRur2lpt0UfHqjk0/bphTRih+lt27lQWKY2oGkJQc3cw5Z5tn/r
         6/TugkaeVGMCheFcFgF8PyHTlFE7epXMOrInrB3TYvg6dD/0wAYZ1A28Wv3S2zNBc0ZC
         5AVS+DeAVtLdCww/LdH64lEIM85lwFjoIjv2iskFb3Av2o1ClOM0dTm6jERhUn+r80Rp
         /ptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777337; x=1791382137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wFs7N1zg+/ZEZHxojTsBYZG7Bu1MLCx/OGkj1iEK8Us=;
        b=mtnxmPUaQeZym8NvgepUf2/JVbvKUQWV/DX3XxXLLtkBRzopx0ByQsLgI5acTQ3Mer
         wMfWwHLeTFwGzShGr0bLMAeOH+gXGZvMMREC9xLVVQCjAjAYnSwx5eLJg0/w1LY02wLd
         TDO3tj0y2690x1yDgHamr4RVDJZ4bF+lb86Ht9xsX8Apsa/BVMqHjHWUT1Wz82EDj51k
         TrLDZpi6Shx2d1JHN6/XYdo4g3jVpUnwdgxiD0hM6DlGMVuAokC+dNLaweZZAgjSAI9h
         bFj1VPOmlQbSAUwAHnvmFiUKsloALoNPXmHK9BhH/UhB+R6iDeMC8vrQxtaIlOvrFOOI
         /kVg==
X-Gm-Message-State: AFq9FYJ4jTH4pxk/dubmhalQyXZG/RXHaj/DebZKoUQnaC5x7/a5efD0
	FI9hyfFzLFwgjgorAi7gQHuA+jUFrTF0N5MPEDcSguMRZpKY0pFrJsAnrF4SVFTrEbI=
X-Gm-Gg: AYBFou1IRp2N+249lIQU4wVm5iob+a+xJshAwZJpM7GWtEdyZZFzdsRgT3RgyYokkDk
	2v2XxCE2LJefrT+9N1ajph80SzaAzUiLoR0kJfAIFCt/J8H0J1Mc+cDxKoYgIaQSob4fMlAE3E5
	M8qIwpnScpnZEgwNh91JCSzo++QIPsxUH69mB6t+s+6iyQJE1pDTowYNvkcnTOU2MwsI3qHgza5
	yRMxLQNDMsg+9JN17zuQ9N/3G+ra0RkROljJScxpxaAax24Gddoi9SkT/eG8XIx14tm/B7egm1K
	HjFh3ZLWRUAA4RhQLSvriMMcSbxwOlJco3PMJKut8BqEZpWyEWySYZJN29DfbRJkSpLqGKdvG4T
	gleGF7Y9nditNbVpzyfLCLj3UuFlc03EAK7oSWK3fa3YS8+nTVF/1gpUmELa7juQCsXIhJviore
	3qNCUB8b4T5nocRVIcEwxVQlKLdHtw6fiReYKe/icoDv9ivBhjgdv5qjN5HIct8z/Se1u0nVomX
	AYFkFFjsUnVzJdSoUnCeR0q
X-Received: by 2002:a17:90b:3ccb:b0:39e:6a80:b796 with SMTP id 98e67ed59e1d1-3a4d18c4d32mr1414859a91.38.1790777336778;
        Wed, 30 Sep 2026 07:08:56 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4e60ea12csm639509a91.1.2026.09.30.07.08.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 07:08:55 -0700 (PDT)
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
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 12/12] Documentation/mm: update DAX vmemmap deduplication docs
Date: Wed, 30 Sep 2026 22:06:27 +0800
Message-ID: <20260930140627.57431-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930140627.57431-1-songmuchun@bytedance.com>
References: <20260930140627.57431-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B88410000D
X-Rspam-User: 
X-Stat-Signature: uu6wb7ag3m6cz6yxfqj74y187pw8dkgm
X-HE-Tag: 1790777337-66991
X-HE-Meta: U2FsdGVkX18LyvfY8xFgJkuBcz0pdfpjkyji8xms4WKPJ1DZ103rQaOT5zy9rTubm88gSrmtPFmKIYEYzXnn5E4gJj9csKp2tgzIyRh0ozf7Z4ttPULN9F1dtSWkT3f9GsDumzJE2yFjTfnPY6il/AKqbu+YY610RocKMHr4zwK8SIxZcsgR/ZZ4d7TrdjiOuOa6ceFlk78s7oYplIMKDOFGogSSgMslZ8JQuVmtBzzWWgPa9tlKPpMJfKW2AMsBdu97zEA8LIASwSu1AUlDEwPfCpmBk/Xi39A1AvQCI7xFCJAheWvkVM4kjeYpxjq6EIaH3wDhjcT7YsdRc17NJsnubIa6UwAstIS5zegDG/BheshEUYikzoPybF/xUdRndz9j94A2BNMlibqaKdtIeEUGG67V4TQSRRyDjHLTlXT8yupKQCTbCfMCOsMNPI8BUjthF3DEWdcMNKoU/tuAhBi1/0ENPhN48BX7FZFC49D2xXs2y8qjx5viHzjM2W6cwXJuOwDClM4NWqANHVLx0qe9RkAXdaUC0eFR79gWf91V9U446vidHVT5jiMRwWwd2mUKaqgdlceap7V7RlQ7DYNCaLfd3TaUONOM7iE/5ipyfVRev/SRqAANeA5OXmQj0Bb/Zbe6y2V73s8fJLQkGrKGi+ijxaugscJ4Rv/16jq1Cmfz9bqeyiWGXLshFPya8kMPAeQgo7wy/UX2llmnVWmrcWWCydDfnDfr2bYcT+Pa46wLqC4fPkcya+3wdj3hQJbb8LvZz83EUK2KLNB9czBiU/NKEcu3SD1nNHwAYtzovwHtWstMyD2FJvX1OFWPRm/BBfJBzzqqtao0tnj7YqK8jVbCzC0VoxpYq+9zY1SDFZ8utoqQJt40jCCtEQS8WS4wW53NPbwkbi4ZU4qZf0RN+l0THUkafkDbmQMttVRrGWMnRu5VUwRCVQ2WXYKCW6VexpwSzWNcBVO1AZK
 7gfIHY1K
 /UqNGdWGgHSU9GdfHxgyOmZCmujiVKe/4zojxb2uhjkNfs7igSYFWhYK0w9b1EW3vnt3Vk5hT6x7E26zoue4s8Q5ZhIimu2x3HyWr8Zr1VMLtVqP9vWUiM1xE7Hud1gy7edzg5n5Oj5AFVkLOVXjE4Qsvla88DoCZCCrczeZjFZtj1m3jyYTs4qhLkzMlBKe5loA/JZyRHd4JeCvVbZXMIFzECCeDAzEl21dZz4+zufRYNCruNRs3hLBM93yOiN6KtjpfXOXH/cwLaq6+z8Q8OIiiTMD+xI12OqpeJ47qPM8EPmI4NuFdX/frQV/TXOR9jz7+U8dDdNnD8WMx5IfBmw+x7BsNcJcCLFMddu1swR6rcSmM+O7ZnpU1ED6ipsrKrdgoZn23qfkk0B+pDFNJ3SEZlw==
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v6:
- Collect Acked-by from David Hildenbrand

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


