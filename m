Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F8C8C9832A
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 02:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ACB76B00A7; Sat, 26 Sep 2026 22:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D896B00A9; Sat, 26 Sep 2026 22:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A696B00AA; Sat, 26 Sep 2026 22:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2251B6B00A7
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:55:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9571B4036E
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:54 +0000 (UTC)
X-FDA: 85258027428.03.D0B7400
Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	by imf22.hostedemail.com (Postfix) with ESMTP id D71EDC0005
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=F8+vSrGl;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790477752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUhtpwjDYsFhZVHLtQ8dC1wt8tqWIMzZ7omgfR51vXw=;
	b=qwN6H33tdwOm1rq8cq9kS0qT2oI1158r/ssxQFIg0IWL0DDxXQKzQev6PaOD3Npw0pLoYG
	9q0JZK+D5jDPchCWQIdBRPFtbLibA5xnL4PQn3s/sPSSu/4mTpA7GCqpIOPbeBDK3Ue6qB
	I93qKwArSdtsybvM/VKW+6NNlCcC43A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790477752;
	b=DT/raRa9dztEK7H07LuWLDTx4gbXCTO3DfZaTlI7GNd3b0FqANcW19U0kVBWPUMN1LuanY
	rgAndkqU97sqwRVyLXtO20bzZTjxsToa3B/86lFLiFN0ut4vPcXP/J67nhK166Bvaqc9Og
	xg26sagTsjyFUMGo0gojLhOWEPLKUAc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=F8+vSrGl;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f40.google.com with SMTP id 98e67ed59e1d1-3a0dc47fee0so392337a91.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790477751; x=1791082551; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zUhtpwjDYsFhZVHLtQ8dC1wt8tqWIMzZ7omgfR51vXw=;
        b=F8+vSrGlfQvdWGaKoX082Z1TxnDMLJBTR6ONDBhd75wOt3DiTE7Qm4Q5eZCB9Yp3vu
         WvJ27+FTeow5MP781V+8NWewoPjFmxzyRnuKpIufEi3Xk0qNU6dy16fTQoQjrPimHN01
         fL2ZSbAb6Q7oumBqOtddmU7ASyLlgRttH43aJrP3Loyo+/xqWGpJxZjfHWpqwcqIvKWo
         xdDOYUqUAx1pADjlFVNd/ulLzuoqc88TjWfaG6Izjms8eiqemzXy6/Bkq2pzYeCjyy4t
         Ve3DAa8Hv3QqeVHZiWjM1Jv1pwIaACDYg8YhGcr+hDJwXfqCUXFmQMzptaCnvz2aylKW
         MT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790477751; x=1791082551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zUhtpwjDYsFhZVHLtQ8dC1wt8tqWIMzZ7omgfR51vXw=;
        b=GxC0p22GMXV0uRYEyPN7TA3uOtV6kmmB6K6jSD9jDxvVqNWvdTS5ytm4s2R88G6lZv
         40AgU2lVwS0mDHT/pfNHh1s3jCoDuUOoqMwlOGZB8azfdd42jagEaSi7F3ioO8Zd1KNZ
         7aryBnf3c9reJ+Z+c/8de9YJp8k1cwj2u3JVtPV9jsaG0CCWtfmQXC1jQLIcE2HQzMDt
         YteIXSLxe9uqi0mmYhzEsXxp67qJBBhkIafxsPC37VJLIS2rsyJXQE2fq+qfYblql+iq
         3gzWhQH+/az8MLYCoUnWNA5wXtd8m5aQHtpwL4Qh66KlGPYqvXh2GgF2gv3FjaGMYGI6
         sG4Q==
X-Gm-Message-State: AFq9FYKdhEO/nHArGu6e225mJwml+B4J+cT1aQcpjftG9Cwj+GSHEQzL
	NaTitNMiw8ZixmnyoICI1HezKVp2xeB3328gNWjSlUqT6mjBcvw2ygw9/n3CQOl0cas=
X-Gm-Gg: AYBFou0I6jIMjPvTjVf6XBUII9lw12PkYKpJE+fLkxL7gXZtZhYDt/xj7fQiLRrxwua
	1EbtoPiIgGershWPpg+7O1gUP2sXbJknb7+GRjb1Wjp5CS7GlU/csi4t7UxhwdoSzUTc/oBP/XQ
	jbOTi3kSaA0oUFUp0wEuJwdSzypS1QYP5k00mLoAZyzEWoQ5PNFwVvg6nyLIXwRYl+SW9JpRKda
	28RyuUlb+znzTB0f+2yNntzZFCT9oYKDwtiBD2F0tUpwd1vrThSo1IyfmNf1RFaH6G6xbgqoUR9
	BchbKW21LNjTN28O6VhxAuxza4j362QeOSM4pnE9At8qe1zYCCP4MOlnecdy2JBh0ASOWMD0SOL
	B/kJ9JAjO8xtAgASnxfikHhLFyJ4hUDvL83dtu9j3MBf/ctVrscRbbiN9u80ZI/Y41z4uEO/Hj2
	q6FIVeWVi+4HuH1uMYHTO26COOJUIOe8Cqr0GXH5lmBJ0VfHJHT5FqKKOYQwZxyloHVz2eOZmMW
	SQvagIEfElRnBOryd/H
X-Received: by 2002:a17:90b:580d:b0:39e:6c69:f47e with SMTP id 98e67ed59e1d1-3a098d4ec7amr8377687a91.61.1790477751333;
        Sat, 26 Sep 2026 19:55:51 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm13461377a91.1.2026.09.26.19.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 19:55:50 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v5 12/12] Documentation/mm: update DAX vmemmap deduplication docs
Date: Sun, 27 Sep 2026 10:54:41 +0800
Message-ID: <20260927025441.741633-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260927025441.741633-1-songmuchun@bytedance.com>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D71EDC0005
X-Stat-Signature: rshq54j4y6uzictotez81j59agzrszip
X-Rspam-User: 
X-HE-Tag: 1790477752-639777
X-HE-Meta: U2FsdGVkX1+1K6KSxLdbB1NbLuLJ2AiFcL8TAm32CkSMr/f0Qi8GEug+BQIvC8SDGk/2M4LtUY9b0caGmIFJ1c/vvubs1h4JB1rW7akhE1X9US3INFwAf0vgB9+ycox9pRKT5+ofDiQEiUeDVfyXIludzWSAU2ZRrClmigcvuExmxYRuQZaoX4TtgEpkI5bCRgIGtGdM793sqMBbHqXp5vx3VJMJyx5jyS/dPREpm5PYXM8VA2v2d75Q55Hnto8qX8TM42Ig2/QMUrwofHdVThw+wpAfhZH03VApVOMBXlY/1TJERLvRCgXxczXFjiyFbBmBIf0xjj0elfrsYIn5ZIZa+YrtExOs0cid3uWftykg6HUeqFjE7Yf3t38PqtJnV6GCL99Qv+lkFH4yeVw9ZjPFatMOUiaESTopnWgZYXSlLTPK4Ig2EvWx/f7q8MjUkbpqCP3XZWSn33+fdqnhaENro2uBvR9IGht/Gzt0hD1OCk4h2NsS5BVykb5dAmL8kbYw/bGCW0DZ/d7EMLNhhRLFjDRCG29ox9NJJlKJ489vwCDYSBRNFqIlzWG1f265Ils6aYv2DcI1A/vZzM0Uxz3tDvIToTtftSOGCLRdsHBRUeQGUA4JQCBWGcVyzb3aCpLJVk8dGAM1GDhQFosX+PRa0guSWJTBPOnIB91xdB0Gno9Us73FdjfY6Ob72LSjvwlSd5V0P5XOFBJwUcUk3zEYxtAdWJ/gwYzy85YpnJISdx2/NWI26cb5omz2GymBrOx1kZ2Z4Oq8B0fA1glAxk9wVstdQ/pzVbF/1l/humXm6jcHSVEYOkyNUJe2fpzZxCo97QXI/ooCMi4lfi4yNEL+ipkWOR45xr9hquqRc1Cv1NymuHDDG2gbxjww0O6V+WJSbqxoZD/TMbF6PAeu8F71sqnttwBci/SomFMjtGaYsTXZe2KLc0Tx+zm22HzHMfHtfmR9lsXjRXYWf9n
 6n7+pvgN
 lDBrOqKR2mjFvndTkGftAZAE8qmc78pX5VaBCnq6M9QuEuOGQgucRUGyL0ml1yk6ostL0m2CUonDtgKk2rKcZAkXrcfR5axiwgEvtpKq+Jd3FbA9LJBCSjRaY3vT2Evfqoz7G8rshUqna+8BHi9TF5T9Koo/hTulpYRrbY86kJO2qujSpDW1jbCDWNhZ0732Qmc7/KNcs0R3B6qU8UYAaYOPP13BIqJraFeryGbAWEYlHXU9oVk6PoxiC3CzXSTgUPQ4Z+H70pKgVXgFpFjURKNEynGVd+4Ln9M68WJ+R2iVV2/yN8Vn2eN1CQA==
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


