Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C2AFEFB70
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7C1C6B00B7; Fri, 27 Feb 2026 12:57:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F676B00B9; Fri, 27 Feb 2026 12:57:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58E66B00BA; Fri, 27 Feb 2026 12:57:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7C36B00B7
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:57:15 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F37C1407D9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:15 +0000 (UTC)
X-FDA: 84490993230.24.5F646C0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id A3CDF1C000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZX8I/q1t8yqJeNG06r60YCkcLH88/apttDYAFu7OYyY=;
	b=J+qkN7Hc8mX8398QUMW1EgwAp64EWyUHNCZxtxr83pP7MwFPX3DkXrPC0UkUZuuZMc9APd
	O7aLnfhkrepO1XPfcTPoaTMuFXC9Vl1z3QgVR7hbYlQrkAgzhMyoROBZc+lj/nl+aWUKY8
	hjORldTbfdqjWJjISaAgaPhAqZ7PjLo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215033; a=rsa-sha256;
	cv=none;
	b=MU0pyoKj+//vneXdcZ/YWBbahOmPkNyNtVjz2OWmIGgD1YI4Jy/S4yzvUj0VXYZ4Xfysq6
	vOM+zBe4VDTiUH3B3iyoihAijfv+yoqEHjQoEW8hofTO7OOsK3BovTRnd/X68w+9YuIX14
	v2IQPyXKy8zVzRe57wDVxmeOK/yMCaM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 621D814BF;
	Fri, 27 Feb 2026 09:57:06 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C5903F73B;
	Fri, 27 Feb 2026 09:57:08 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 19/30] mm: kpkeys: Introduce hook for protecting static page tables
Date: Fri, 27 Feb 2026 17:55:07 +0000
Message-ID: <20260227175518.3728055-20-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A3CDF1C000A
X-Stat-Signature: 4bgt8g63k4pe3kdrqt6m4zgmqb8magr3
X-Rspam-User: 
X-HE-Tag: 1772215033-784708
X-HE-Meta: U2FsdGVkX1/HeaEnrOUUjII7harbqZLnArqDqKifdUCfjcZJODN/sKCkBnaVir/qJ1l5VAlJvP4WQsOHzIHqKk2KNpbPZVj98kh6LXX4KGJ4lAQ0mVwtzF4MplNDc5SRPwjX/FrJX9jixcuGf6nLwSANfby6i4GWv874WfFEDd33Tp6BU0t5LztmA5MGT3dfjnmfACgDPGdplhuuLK40uy1VrNGVuLX4Y/gshY0cdsprtMiE2aF7+3BQNODFpikwaD0rNGXulUXeph7UQDmT5n71RsNVLrKBRLy87MYS4BpCO8gwUUKh83wii8lRC/wml6Cu0G9pgRurD0okhwyl8PEGww4OjJLu+vJ81vvO0H2fn1OH5n4pWBKQws4bKJfv8gCyqOsrLqkN+uTWpOW4olrkpX3HIp56DGLYF/959mGwlMzQhD3x2fJzwFN6rdxn9m+7WD5EoDN1X1Nqp4907c+GrLt+40EX9HP7nSpmTo5s8MFFdaIBAkYbkiBKcjpJb8OYsJ/i5nKRUiWw6Fb8uXkF3zVps0UhgPAE4dZzmX0+BGAtD6eWRysgYHlaQvPpOE2GJW0KO6/ACAv2AoI8RrOLMgICtGePVEjMAqQRVO58JINcPUwE2nntYchUwT4Z25pTnh8cbywfiacipIVG35I0PxaGmYRqPj3b+y2U35/IIq2iYGrnRF5wfnGpq4ow7peixyTfFxOoqtmiWDQWNlushnxURatM+8tqlSI9/RMClBVKOzzAeHxCIEEJMiG30rFPmT9/QlkrruGBRiDf3AFgPDYgHt+WAL8Nn5TFU+vmDoKxl9oAQAPL/YZgtABuO28xqC0GyL0+jo7Gd0bnXFwrQ3Sb4nRP2VR/jHopls4u1aqkbRLbdwIKY2jQWrWlhnpcP5gg3F91G6e96tI7RjHqgVClqERc6SUiXrI0WWZJNzVNBTai+O31SecSPK9kX2zl56DjdD0RjmNJHnr
 0bxJNI60
 KC8zBTZcOer4EsVakI4KG0aIX5jvtiHCOEhlBhM5xn5HlbK0iaC1n6GCyJTn5guGcaIMQEM3bfXqoa5UbgkrQW5blW7tQsntS6zRQUpy/UjGTmiej3lrhAv26ZpryhrcjAP7r/mOHI/K6zhkgntrTAcFF6spTSy2mrVi0GoKOut9auiU24ZHuPeBapmHFyHZ2Zfp5
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
index 73b456ecec65..cf2f7735ce03 100644
--- a/include/linux/kpkeys.h
+++ b/include/linux/kpkeys.h
@@ -141,6 +141,10 @@ void kpkeys_hardened_pgtables_init_late(void);
 
 phys_addr_t kpkeys_physmem_pgtable_alloc(void);
 
+#ifndef arch_kpkeys_protect_static_pgtables
+static inline void arch_kpkeys_protect_static_pgtables(void) {}
+#endif
+
 #else /* CONFIG_KPKEYS_HARDENED_PGTABLES */
 
 static inline bool kpkeys_hardened_pgtables_enabled(void)
diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
index 1b649812f474..cc1dc44335c3 100644
--- a/mm/kpkeys_hardened_pgtables.c
+++ b/mm/kpkeys_hardened_pgtables.c
@@ -125,6 +125,7 @@ void __init kpkeys_hardened_pgtables_init_late(void)
 		pba_init_late();
 
 	ppa_finalize();
+	arch_kpkeys_protect_static_pgtables();
 }
 
 /*
-- 
2.51.2


