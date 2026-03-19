Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5163108E1F8
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E35E6B048D; Thu, 19 Mar 2026 07:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06E9B6B048E; Thu, 19 Mar 2026 07:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC886B048F; Thu, 19 Mar 2026 07:50:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCD436B048D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:50:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B89FC1DEA
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:50:07 +0000 (UTC)
X-FDA: 84562644054.13.E678398
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id C4C3014000A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:50:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773921006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=0IYsh+xGMoj2vGRn2pCnCwLWCNIXZEPPlgeBjf9uH+M=;
	b=7hLtxb1f1kJQaMpRT+zi8f/i7uQvZdyR+nHN9Ihn/WGIHWJZkZHhagYJYm5XaNo2S6SDHD
	CPe3Auu9kBs9g/mjkkMqtWrKPlqQrWJQ7mvMfFUww1RPe2NeViut2U0CJejCn+9/LpfvN7
	+Kewv8xr+lghUU6jy93/SaqL3Zz/d+g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773921006; a=rsa-sha256;
	cv=none;
	b=B29VGlk2Y0tMD0ED/pxiI0hmqf2qkvVQzk0owU8uYJemeZzRqg/VIqBPamVzkftQusNLmU
	LpwlL7IzbODVHCd02+JEXoVINOBJT7jACyNTVJmFe51joUtIpSUi5z8RDD3r3jObQ7xC1N
	ahUPBJlJ5Et6QyEsrk1OYUM37wJJYEI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62F851A25;
	Thu, 19 Mar 2026 04:49:58 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2D98B3F778;
	Thu, 19 Mar 2026 04:50:00 -0700 (PDT)
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Marco Elver <elver@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Peter Collingbourne <pcc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH 0/3] KASAN: HW_TAGS: Disable tagging for stack and page-tables
Date: Thu, 19 Mar 2026 11:49:43 +0000
Message-ID: <20260319114952.3241359-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C4C3014000A
X-Stat-Signature: 7a91n7ax9k1u1tq8jx4anzcyafny31ak
X-Rspam-User: 
X-HE-Tag: 1773921005-987975
X-HE-Meta: U2FsdGVkX1+8xolMscXeZ85nk/k46DjvqnrUrVwEErqdGKJOV10/7gH8zYewJAh/csbHBylsctKpsRSYS5fSTtpkXFekwriU1LNlKR99ikLC6hoGRTEIZ84gFRuzG4O9qZ6pVr23Qr/JQrYWMOrBk6aLdrFyTXgWoC1kUEaI+JHC7hbfTXFAkBb+5SKiDAF7z/yhSYQ21fPOTY4xKkavXyzvtKR8lojEEvb6v7daewVQIcw/b+TvdslKid+KgnTlH3KT0oE4vlH7jv/y0748btZ78c9N2FhSAZLGZ/0iCJ5VUKoLa62SI26bMEcGSxszuAKYAdHJ0Z4+JqoJz7KZQpILkQWt1R9X/VoX7Q/3OcKPWVN5mx601mtVkuDhQYwbhYofa2UctClPD+Y6+awHaGxJHXbyZ7y52CQy1j2wBm15ifmioUkcNnQRsleYr+w4e6805vS6WG19/x9hnBNBRCHhfZNCXGpVOvOskA1vkCketFTPR38X49caTFbCwIOeG6oIke/rjyJWSQ/LeLpOtto2s68G1MEvhwyFS9AJsSahkQfZdnHXpnE6T/NVfgT5kJouMMj+edRVktRyfGvabFMebW7Zp7rP3ncEyB7oZekwNzWqhMqfviFTVMrnT2iBry9WOKTUC4dpSN7+Q3zdvWv3/lQIAnPUUcQDv/7HgtLhtijOpaqqwNVgNAa6AMbWMUza/qIXK4ugHUfq4BqjPLmgf6iFJWUIA2oOjgpdhTYXkG5a9r1MGicpLe+4d5oGPF53xGoyUjFEuwyDppr5uEVNLvAXBTglOUyA9cKjpZwtE2mGrjWSgg1imtkkef7/rNUVQNqJKrCaRwycyFrziAqttHFyw1LM8lkvbZOtSkwFVEaAU9hxcX7szm+Yk/nkIDkVWAgbMVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stacks and page tables are always accessed with the match‑all tag,
so assigning a new random tag every time at allocation and setting
invalid tag at deallocation time, just adds overhead without improving
the detection.

With __GFP_SKIP_KASAN the page keeps its poison tag and KASAN_TAG_KERNEL
(match-all tag) is stored in the page flags while keeping the poison tag
in the hardware. The benefit of it is that 256 tag setting instruction
per 4 kB page aren't needed at allocation and deallocation time.

Thus match‑all pointers still work, while non‑match tags (other than
poison tag) still fault.

__GFP_SKIP_KASAN only skips for KASAN_HW_TAGS mode, so coverage is
unchanged.

Benchmark:
The benchmark has two modes. In thread mode, the child process forks
and creates N threads. In pgtable mode, the parent maps and faults a
specified memory size and then forks repeatedly with children exiting
immediately.

Thread benchmark:
2000 iterations, 2000 threads:	2.575 s → 2.229 s (~13.4% faster)

The pgtable samples:
- 2048 MB, 2000 iters		19.08 s → 17.62 s (~7.6% faster)

Muhammad Usama Anjum (3):
  vmalloc: add __GFP_SKIP_KASAN support
  fork: skip MTE tagging for kernel stacks
  mm: SKIP KASAN for page table allocations

 include/asm-generic/pgalloc.h | 2 +-
 kernel/fork.c                 | 8 +++++---
 mm/vmalloc.c                  | 8 ++++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

-- 
2.47.3


