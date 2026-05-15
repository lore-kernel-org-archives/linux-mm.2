Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A566CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 08:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03E1A6B00A4; Fri, 15 May 2026 04:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31586B00A5; Fri, 15 May 2026 04:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E476B6B00A6; Fri, 15 May 2026 04:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D27196B00A4
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:21:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6ADE3160F41
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:21:14 +0000 (UTC)
X-FDA: 84768959268.25.8C8F4EA
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf25.hostedemail.com (Postfix) with ESMTP id 08E91A000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:21:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=UtON5KvM;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778833272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sDPgw3TE7pwHq9Vr5cZlrNhK9riXREs8CXWuvtHX3FE=;
	b=bL5cSEdBlv0N3Y9QTDUKQoqk8jaHBdPwhDE9NFXF4jfagU4Q0mhQoJl9guCcXhoJae7Uaq
	BeO7qfkK/Uh5JA4tfurJUkblyb1z9xuD1yhkijWHoOx33w/fdbEAHMc9ftNFrDpTWtUrC1
	9TollA9+5GpBc4eNx8H5HyTMTNMivnc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=UtON5KvM;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778833272; a=rsa-sha256;
	cv=none;
	b=FoxgrpRq6x7VVZXIq/L4u00joliDvmgrT1O6c88fKzRoZqBSU1+X22B93di3ysgpij7WkM
	42TKUtG4eTNsmBM4Oc56s1jge4IXAK/CgAOHvVY3cn1zrflz2WxnHpxK/goglKetoyP7Zu
	uwHrWOJ8UwfEdTScDJ/k6v7utV5Y0g0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1778833266; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=sDPgw3TE7pwHq9Vr5cZlrNhK9riXREs8CXWuvtHX3FE=;
 b=UtON5KvMYqi3JfKiKwNbkW21vv4HJkzV1TFrFVNjxEhTmIrT5uZEaCfpJWL/eMVEW/nm5r
 NBwHQ+tJ+nn/bVbYSyk7bFUqxGtLZlGMUHJhouzr5O/WMlrV2YoqAitUCu2z6q/8fI4JdA
 iWwmqGkjt5nwwhULH1Vd8Yv/n9Z1cWCYLOzOBhQNpaNvzk39ibdqB01TDB7L1kO2VOFcM7
 oO2xpmN5IfvrFulhH/+syUm9HWbXOG94G7Lat5EjtgpjzZJDoTV6HAvf/wzl+YTgg/l+ny
 vtdQ/YcxZa1JNQXkYKM0yFCEeHVNqX0ciQOdNpHmuxipx36zUbQi3jLoaWRvAQ==
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Date: Fri, 15 May 2026 16:20:41 +0800
Subject: [PATCH 0/4] mm: speed up ZONE_DEVICE memmap initialization
X-Lms-Return-Path: <lba+26a06d770+b2ede2+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20260515082045.63029-1-lizhe.67@bytedance.com>
Cc: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <arnd@arndb.de>, <rppt@kernel.org>, 
	<akpm@linux-foundation.org>, <david@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 08E91A000A
X-Rspamd-Server: rspam06
X-Stat-Signature: ht7qdepcxhoenrfygwy3f34m3n4jh837
X-HE-Tag: 1778833271-565898
X-HE-Meta: U2FsdGVkX19Z5OJ2522y5ooKvKA/axI+8pnBwKYAqF0UvZ6JsyFC8Dph/P7h16QI4xlsgq5SbG6Z3gsmKmNPENGhmuwgOgfzXFLrZUsQl7TBpKEHAK4vDxLalh4/0VDNCFiyhf0zlKC1hii/rAyeHMxfYGzaXNhCMMC9wEHnClV+iUe2RT8nvxyUFOVxIhStVG5+jEex9wOn4ZxchlxAQOmSKD6/W3CNysxGhhgxxBzqwhI9hNTs+MFybTm3O7+CN1/rTEHGgdW+CJAUehqVxZLvYk4a0oMb6cdROFgkzguJu/t6N4sZdiYlWWH1RX+aieSaI2Jq1jcS69yAZZZrI6y3jeUFC/cfOaEKtcSm+HLBntWt+l+RnCrg7FHNHi4t1POADm6lcXwBQ43h60FshanYAOnh8uqDPAPF9hvp4qjQUwaZ/nxvYT8GWdWnkkJEA/HbN4WRr8/gzMa10FXSBwabgixzKoJ4nlgxrRyFVrdWxYWk3ElOGxf36Iqo7FirT/0cRv0Kvkz4x32qKNl6Kwaj0NlfXkR7rwMq9/9poQK3Rc4cd1yhjpPh1+7HrxMf0y3vjTF/qtj+hTwZBaY1H37xbxUuXESYiPuaypM4sYWstKhA7C7uie7g7rLN7QPltjYaOFxz7m3dYRLPcaBHSEZWHyNQ9XQp/EAKWZlGYbXqpNHBUEf1UTq97u07xYHQ+Nct9odvMRGQXAXiem0i6LdXKsMewRdBhFj9vqmAymIwPcY29dfWocCk4/jWbgMVAKTZJZUjwqm+d0n7vLmOyX2efhzAHPF0PQUoErAHbDz3faaz3Od33BTQJsf4Old7AISOwriBBM/mpri43FUiavZ61hoXoK1PVwMZ+r6L9yK0a/V4T09Uj29Oy6w6Jbqf+OK8Y6/ORLuAOPB+OdGVBALmPjYaEdgG1+g5UmTND+1agWvzPcLQvksVqPzGtFhswrzjTZJbymDohvVf51+
 rbHACgmg
 5KvJysr5seuUJf9o5qPCk7JOe4QzYSo3ScZzhWbPxj9znO4CAelY961wptZ8gAv6JGs9aKS3xJ1dADLUe3N5W70bvTD3Bpd3mDo/+n1cFs9b4D4E+MApLky5+XKEWiISf3Pj1cyCzdq54vSbZepWU2aNDUS3sDNDdmx764WX6arTFPb50lmMKgtmYnR3AyQ+RGPEdOGSAvF+avUYEc+WOZvu3hKjx/e6I73I1FKPFa4oJXO0ZnxDgHmbUUaMP/fSsrJDsJN9tXPgtkynocm1RBA9RfgHbD493EYzZd0MetVzeFNsAvX9PU73tCehGuaJldm+i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() can spend a substantial amount of time
initializing large ZONE_DEVICE ranges because it repeats nearly
identical struct page setup for every PFN.

This series reduces that overhead in four steps.

The first patch factors the reusable pieces out of
__init_zone_device_page() so later patches can share the same logic
without changing the existing slow path.

The second patch adds a template-based fast path for zone-device head
pages on 64-bit builds. Instead of rebuilding the same struct page state
for every PFN, it prepares a reusable page template once and copies it
to each destination page.

The third patch extends the same template-based approach to compound
tails, so pfns_per_compound > 1 can also benefit from the fast path.

The last patch introduces arch_optimize_store_u64() and
arch_optimize_store_drain(), with a generic fallback and an x86-64
MOVNTI/SFENCE implementation, and uses them in the template-copy hot
path. It also refreshes the PFN-dependent fields in the reusable
template before each copy, so the hot path remains a fixed-offset store
sequence without post-copy normal stores to the destination page.

The optimized path is intentionally limited to 64-bit builds for now.
The current fast path copies struct page as a sequence of fixed-offset
u64 stores and relies on the set of struct page layouts used by current
64-bit configurations. Extending the same optimization to 32-bit builds
would need a separate store layout scheme and its own validation, so
this series keeps 32-bit on the existing slow path.

The helper interface is also meant to leave room for other
architecture-specific backends. This series only adds an x86-64
implementation because that is the only platform I was able to measure.
Other architectures, including arm64, may be able to add their own
optimized backend in follow-up work. But I do not currently have arm64
hardware available to validate that.

To preserve observability, the optimized path is disabled when the
page_ref_set tracepoint is enabled, because the template-copy path
bypasses set_page_count() and would otherwise hide that trace event.

Patch summary:
  1. mm: factor zone-device page init helpers out of __init_zone_device_page
  2. mm: add a template-based fast path for zone-device page init
  3. mm: extend the template fast path to zone-device compound tails
  4. mm: use arch store helpers in zone-device template copies

Testing
=======

Tests were run in a VM on an Intel Ice Lake server.

Two PMEM configurations were used:
  - a 100 GB fsdax namespace configured with map=dev, which exercises
    the nd_pmem rebind path (pfns_per_compound == 1)
  - a 100 GB devdax namespace configured with align=2097152, which
    exercises the dax_pmem rebind path (pfns_per_compound > 1)

For each configuration, the corresponding driver was unbound and
rebound 30 times. Memmap initialization latency was collected from the
pr_debug() output of memmap_init_zone_device().

The first bind is reported separately, and the average of subsequent
rebinds is used as the steady-state result.

Performance
===========
nd_pmem rebind, 100 GB fsdax namespace, map=dev
  Base(v7.1-rc3):
    First binding: 1486 ms
    Average of subsequent rebinds: 273.52 ms
  Full series:
    First binding: 1272 ms
    Average of subsequent rebinds: 104.59 ms

dax_pmem rebind, 100 GB devdax namespace, align=2097152
  Base(v7.1-rc3):
    First binding: 1515 ms
    Average of subsequent rebinds: 313.45 ms
  Full series:
    First binding: 1286 ms
    Average of subsequent rebinds: 116.93 ms

Li Zhe (4):
  mm: factor zone-device page init helpers out of
    __init_zone_device_page
  mm: add a template-based fast path for zone-device page init
  mm: extend the template fast path to zone-device compound tails
  mm: use arch store helpers in zone-device template copies

 arch/x86/include/asm/struct_page_init.h |  28 +++
 include/asm-generic/Kbuild              |   1 +
 include/asm-generic/struct_page_init.h  |  17 ++
 mm/mm_init.c                            | 260 +++++++++++++++++++++---
 4 files changed, 280 insertions(+), 26 deletions(-)
 create mode 100644 arch/x86/include/asm/struct_page_init.h
 create mode 100644 include/asm-generic/struct_page_init.h

-- 
2.20.1

