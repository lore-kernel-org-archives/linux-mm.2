Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68BB2C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 05:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87E1C6B00A2; Fri, 11 Sep 2026 01:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807BB6B00A3; Fri, 11 Sep 2026 01:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6819B6B00A4; Fri, 11 Sep 2026 01:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F21D6B00A2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:04:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB0971406E9
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:04:23 +0000 (UTC)
X-FDA: 85200290406.06.6B03E81
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1FBB680003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:04:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hniHLSy0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789103062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUhtpwjDYsFhZVHLtQ8dC1wt8tqWIMzZ7omgfR51vXw=;
	b=ZQ/d/yB4/KKWdXBXh/7zQcx04d8Z5yFHarbNwoqXVI2CiCRFHcsoWEneeki8WH+CmHStya
	Ae2Ftchyms/01Seyg1Ix0W7Ia9BSqjciejqJgdP7tmeduR37RYcy39NxyybDc49ArIjgO6
	m3RVmn47hulPI5+gVI75Jcf3+fitxZg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789103062;
	b=N9KbMVi9AHloI1y637Nd5juQ1qfqtUlyblgUsNuyMvbYZk06xgTR4Lie5xovbp4R9iHtUc
	VBr4vVivd/12zDKUh02cAAnQyOpFiwkAUeDFQcTtz8Si04tG8kJtIHPAWlKXjRH1VpvMPM
	pxT/r+1wNULonF1MyBFQumm6nQo9HKs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hniHLSy0;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-382ef647e20so650088a91.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789103061; x=1789707861; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zUhtpwjDYsFhZVHLtQ8dC1wt8tqWIMzZ7omgfR51vXw=;
        b=hniHLSy0g+XOgmVcv77j4+sc5KhQwWEnX0GTg6fOIV92SNW7VgKxhNzLhWp/dGnXVF
         GoGl8n/jTF673O34IkZfxRJI1KLXI1Y4wM6eTqnP6to9mP5ctRzfVaEVnuPboDFwm+IA
         Jqsq6Iydf6yizfzsNYFAjvWA7PQoiGr+nA43p1QjiaqHYsd6VEO7Eb3JHVO895+9AvR0
         EjP3t48d+DIYqhdqR0zLwJW8rk0g0KySXEWGGRWur7K9tHCzVDELTIOfqU809SU7rJhg
         v3MelIq/ouhd659ONxZcMntKJbMstdUM4aOYGcFdpQa2p9r2sN8NqAH1bgxx4hVieYk8
         exfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789103061; x=1789707861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zUhtpwjDYsFhZVHLtQ8dC1wt8tqWIMzZ7omgfR51vXw=;
        b=cg68mxUD8RCPty5weYpBTLPDFKbeWv0H8GhCMKjVu4uJjYJc4w3Ht7+xvrQ0hmT7/e
         aQAObNsGuT94oaebds30aAfQgDOUbf+HpO/U9by3qjMBgkzmq5+jz98EoVGNzT2sjMYz
         BWkRfJe76Sp5TQZABUllr/JiBE7nDPnp/PPLm32Zv9RVwNJIRxI8udFy1sO1cK9yQcC6
         QEY6jJWKi9ZTtH01Jae1x0pzjSIk6AB3OLaVpPJg1GaQymJlBWiI6NTgRAsW3hdSXjmR
         ab1ZvJK3fFCYWw8VtnxmjyNrDKUee7JErXZEp1BfhWO1XQ2r8TlA5/wazvsYZqMHeVnS
         N1WQ==
X-Gm-Message-State: AFuF++kJmrYN2/HVvvv+TSSKnFns5GGPh7wNBT+wXsZkMUs7/VY3d52v
	yuS9Dli1kvg2ReMtphI1WcuivFKSjUIXVMGynHU+QhjxRML4v+sQa3TSypAWmP3caP0=
X-Gm-Gg: AYBFou2az9neax+yfF2jWTmRiEZ9mPVbEXSjQzOkpe6Lp6JL5XzGvcelm/9yhVQhrwH
	bgd4xWNS+jyAySunFfB0BwGwbFtCHO8MLukz2zzxmlA2v8gwOyVctBIer/D6oDJ4+FruOzjWnaN
	dxmb0oHv/lmpDRTxsXnZ2+gkJJPf9b6trx9lhG7VNqMfFYMtRqkT+q/9UH5e80FjGfCaJqCy1jg
	SNau4S7Ru45QbhRJNfV2ccHIQ3fRfWrH64pzL8QgFV3O1R/AXFCEXFec8wKeSeZFtMAbW1tjsjW
	D66kyZ/0amYw2BHhk7oPxMchshEtvDXAqODig14YtXy8vNAZOKkv0lDinE94flpBIgCqypggSUH
	WR+4ct7VX2JPyV576sPtXy6/eE9RfBwZQejgbZiAZEsIBdVHG+a3hLCWVWJHhIyTPMg0ICbs0Az
	0X/RxzdAvO5Gy3W9m+Igq9eAVt58li7YGlJjCwq24eaMTa5bvz2ZFE67vUGI0rESMHtThlTMO/w
	W6hhTdgdHy3cejj44vUZ5Yt/WuLopxRiXPdNLNwBoOIdjw=
X-Received: by 2002:a17:90b:2549:b0:398:dcfe:967a with SMTP id 98e67ed59e1d1-39d9c227fc1mr3740017a91.17.1789103060720;
        Thu, 10 Sep 2026 22:04:20 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d99531b16sm2651561a91.14.2026.09.10.22.04.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 22:04:20 -0700 (PDT)
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
Subject: [PATCH v3 11/11] Documentation/mm: update DAX vmemmap deduplication docs
Date: Fri, 11 Sep 2026 13:02:28 +0800
Message-ID: <20260911050228.58884-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911050228.58884-1-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1FBB680003
X-Stat-Signature: qg5tjjq455xzr8iezy9uk77yh7pudgs5
X-HE-Tag: 1789103061-762941
X-HE-Meta: U2FsdGVkX19MxV6HsIfUee2eH8lylHqw1bgKwuk+dpdic2/1h/BeVdP9Xrozu/syT7slkbRWbQACwTWUgEguQQqF/BJ8gRYP47Hk0Vt/IeOoYlPszTcPoCLWifFtTQpbGL5yxnOqm9JiyBq6iUxpqJQhg59YddpeUUnlryWSGZ4nsAzhRe8KYC3mPFi3XsUhbjIUG/vbrd6jvA9SFoQ84JmBycegacMHwxUKJvIPTnnNDLtMMHSBSNyYkUVK2UXjr17Ubn6cTNnvt8W/aeFSeoJJGpaueyFpZF4ERssxAHbTEkFItKhdCLmEsdBzH+YfuX9hUKfsrnZXp0+IH4La+P220DKu4t7MWDPPKBTux+OXteCPJAO4qLo85oHE8leuZyD11S8Ktn3u+Lx0T54NcRwO46fYEf8R2lj87gzxio9hxaxG5ytUSuFZX1GiB9WyBnv+YcHEB1ZwHywCaL4ESzGudnqyD6rxwGn3GGjcDveWAsnjAmuc5TstOK5dg5LQ8zWklwpyOGGeq6aGP2NQASguSgzS/93qq5W/kcQGSZjia1H/uqCenYx1kQGn+J4a0qewudGCzseSNOQlXyenOLH7fDuXHU4JhxmspcrvkYatdReeORQaXOLfNe9zBetJsZozAWThdDIAmDVdMMZvaWJ6YKBla2vhSdRSU4wKIgbX7lRUTKNYQTZ3iLX1b1U9dYv/s4JU7kdLc3Sd5vUFVzigbelcoyHkmfnAHi2B0nZKcf6tHZy/8uIg1GWcOzslAGGozU/04tk3rQW5FqhSs/vk00fraoJBGrpt+hSLC975wK1DAR9iYX9YVc7MkeK3KvlyJczYgCW4LgQGy/hbL0RuSq5Smj3O/I/Ca11z3zKRP4WVVQe1pfe3YAg+eQWNRhZ39YFLWWtPlajVp1PAar60nroWFrcfXKxv34GYWo08NeBygsEOGD2TlLMK7JhOaOQSx659TNw7mpTI2mb
 XisUaoME
 dDLT66LF4uE+XuaAvqa2WuydWwWyUFeiYiOZCBMFd3hPEGd+JvvR1ZkmFiiIvNf98i9K2MTgm36cQah3Qw0rtJWHDxSbbRAtpn3ZZMsm6iM6DPjOWU6lR5epeu4J8VeYBy4Y/iKdvymwOn+W+LJNlA7TqGN3pN4J2GEXhmCUpPlr0wMsJe6/8MOUYfnCPUW7y6Sr1eiOXXkKdixT73Pes2VOAGijQeqERFc6WDdwKMy/PELJNDcZUC5CfDfmUdylHuBrM94KF/aV/ORMY2HgLevAf+Lvw4bN1CVXW8iT+Q2oSZ5S3JWMgCMgEbg==
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


