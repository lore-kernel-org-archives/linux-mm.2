Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFE52C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE486B07DC; Tue, 18 Aug 2026 10:12:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8476B07DE; Tue, 18 Aug 2026 10:12:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF1A6B07DF; Tue, 18 Aug 2026 10:12:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDA036B07DC
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:12:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C7EFA026D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:39 +0000 (UTC)
X-FDA: 85114580838.03.C9948D1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7B25A40005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oLpWliQ0;
	spf=pass (imf04.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4w6EA7bRfvh9u5tJeB/5AAWzZKMQnHU0PKkqyssolvk=;
	b=nWkram5d7/Z1I/ab83eqWgvT2JDHBqy6R5hwe1qu16Lke9TDyW7xzs04foe59qhkllXgfE
	tLpfW1tMlLuR65qnxN9j27nU9VbflCkW+hv+kAFYZhfCUK44RBSrsjw9lRKqV/FmEgSJmX
	jGi9J/fMc8eOxdM5XAqXWbLZV5x7xGw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062357;
	b=eYE+QX7UANCRGT9wI+29UMFh9mO6NGqiqk+D5/6MrQHJg2qpVHFqDJClnAacYINjgZvJya
	Ga2kJTa2j/ZjYtD6HtkzsGTu4reFaLS/oYYP/zoHTwIRABjH8Smz7xIEQzJdEzQUeGjdaz
	N6q8c4YaZJYs5q4z6i7gbc8GrJ+JPfI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oLpWliQ0;
	spf=pass (imf04.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D858819F6;
	Tue, 18 Aug 2026 07:12:32 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 23D763F85F;
	Tue, 18 Aug 2026 07:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062356; bh=sCntNDaoLvsM7NoPkw3s1TdENhd+CMuf6vjP+qHi6MQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=oLpWliQ0M1NNKG0njX3y2LijiY8VWcyckxo2BTxDqZ6145pdmeRs8l3WWCXR8MXoA
	 SKxMdGnhIjEbzsbJwtMduRReTgtzjxLBBXpwxSo6hjFJF1O5/K7MVpbLwJCi+GNNhr
	 /e/FPY1HsurbVPlcoLwdvVxZ4SRU09iMcm4CuDiQ=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:57 +0100
Subject: [PATCH RFC v9 15/25] mm: kpkeys: Introduce hook for protecting
 static page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-15-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=1755;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=sCntNDaoLvsM7NoPkw3s1TdENhd+CMuf6vjP+qHi6MQ=;
 b=Iu++Xy+qhdxfJQazuqSVfw66n86Uz6L0S3XrilHQKHEmVOOATMrnPKUSWAEebDavcsaSyjB0c
 b93YFQwDaeDCGwVb5SJHKOcupjCmxwRwq+2wjwiAkg/2/+VfqZDHmz0
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Stat-Signature: 3qj4h5uqzr3gtdh9ap1gxdeu9f6ewz5c
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7B25A40005
X-HE-Tag: 1787062357-269635
X-HE-Meta: U2FsdGVkX18X3+ZEIWgdFjv4hL4x8F6jDAS89sBCY8qwz1ThbNgPrwzKH3HfZl5YCSOBpfYFsmnB9aZcUYX0eOxQRPTbuOd2FR62vyUJ4LSdvKkXSItBi96rCUtidwQbvfIGfTST0zyjUmilEH6BD2vohF/5kUoThHMaIA9gdn92B5bppD/loi8udjBeJ1oB+is4pz74I+i5w+sVLKfdpGb8TdxfXAVuDyFjG65XY+S5wB5XAUiUx8kaCYADiZb0nBQGwamhm3w/Vbjt/CKfld+LkFPjpyfDQ4qXyGcrcknfuYPRa8GRr0I0RT00wYP6UHRLHzzUVlW6ZYaK+fIZa5Quw3FCVBRLmxR6lrgoe4dX7hZqh+5MmlIUH9BXCFbLEc0qI7ah6QPNR+27bC66jq/LiXvxbS31QeNKO3jsK+OSCjAYMW9TX2UOzIzp2SV3OpFVR+idVHT6p+hGd2L4Xx87HT26StbAmFiJu/8csRKOIB+MwaDYj3EdMTLLGdoATS/gRN/vDPQmgtGHmeTpPJbVvXEUTw9HgfOl/1ccFrcawZ/FOPZXJKTZX2z4+Il/LO7eCbVNMl1RqywVutvioq1biM8oyamXHHt7/HinbA1CiRPbqpiQJdd0R4ez5/EQzVVKGW/Xdt+GBzkpxzJE8JX9U1thB5hVZXGCpnE5qdlnQrNdziEEm/fUDJabo57+gemSb6vNXGPkXqkX8h4Ywd7eJ5YK4SHXi4tomjCMRk3iu5f8jAPQv5zSqDoriEGHSk4CVvqZPjAz1sLoQPupAsUCCT558evGyd3JEBpSl5Pvn2Lkd1bSKQ02QjpOu78pK0Me+CJAZw8gTuQ2QONqQ2TedN/+eamaD0r04/SV9B9kkhAPrfLhOD8FqMiwPXx8PQT7h4cbEOyc0f8YzNDdIYkzen4UMuayO5H2SDMd6yH/3e1Sqji8zO/Mm0x/My23PiM3HLIaXXMqcFDLaBs
 xwrq5Utg
 pqRNpALVyOdhfc+xbthR6cPBIb341Woexj+ea4kPRciWzKN7qYWuWG5bw73Vmex+FVMv6R5/Bl0MKc7ApfXP/TNGRZZw/yZEz3Apsf+AeHpyHWjLF7KJGyb84O9ILpgGJiaXablK7QFMuPocrPfspEpFzz0VwZs/YGdr4CSIm7+6tGPM8Y2Wo09RS8uropMoVfVA7WAlZ3zDMV4ffKC4qhROwxxEXoyDP/7wKdN+KyHHFKIlmG143AYbC4OuQIC7Hf/BE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kpkeys_hardened_pgtables infrastructure introduced so far allows
compatible architectures to protect all page table pages (PTPs)
allocated at runtime (first via memblock, then the buddy allocator).
Some PTPs are however required even earlier, before any allocator is
available. This is typically needed for mapping the kernel image
itself.

These PTPs are at least as sensitive as those allocated later on,
and should be protected by mapping them with the privileged pkey.
Exactly how these pages are obtained is entirely arch-specific, so
we introduce a hook to let architectures that implement
kpkeys_hardened_pgtables do the right thing.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/kpkeys.h        | 4 ++++
 mm/kpkeys_hardened_pgtables.c | 1 +
 2 files changed, 5 insertions(+)

diff --git a/include/linux/kpkeys.h b/include/linux/kpkeys.h
index 23526d3f9ab3..df55ec854586 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -127,6 +127,10 @@ void kpkeys_hardened_pgtables_init(void);
 
 phys_addr_t kpkeys_physmem_pgtable_alloc(void);
 
+#ifndef arch_kpkeys_protect_static_pgtables
+static inline void arch_kpkeys_protect_static_pgtables(void) {}
+#endif
+
 #else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 
 static inline bool kpkeys_hardened_pgtables_enabled(void)
diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
index 9e1e27c2cc96..c133e5896fcc 100644
--- a/mm/kpkeys_hardened_pgtables.c
+++ b/mm/kpkeys_hardened_pgtables.c
@@ -66,6 +66,7 @@ void __init kpkeys_hardened_pgtables_init(void)
 	static_branch_enable(&kpkeys_hardened_pgtables_key);
 
 	ppa_finalize();
+	arch_kpkeys_protect_static_pgtables();
 }
 
 /*

-- 
2.51.2


