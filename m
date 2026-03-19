Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6C56108E1F7
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5293D6B048E; Thu, 19 Mar 2026 07:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501566B0490; Thu, 19 Mar 2026 07:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43E836B0491; Thu, 19 Mar 2026 07:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 325F66B048E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:50:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD594C1D61
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:50:11 +0000 (UTC)
X-FDA: 84562644222.30.6C56A24
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3629E100004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:50:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773921010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xfUC+iLqsphN+dhD9fmwtK03scsyIICxJdmCbkULZpQ=;
	b=U8n88p72zS1yYhPsN447HT+2aXEEhi0LoiJOEbfv9eG2j4fQD4tvW6wOpYc6iHcTgfnqU+
	aeqcSzqDQKFNo0umShXnkhM49z3JtvvBSLUuk6+MvnrOgeYawFEmhIuk9qDcCfS68azqtm
	jh7oMbnxN3EoM2rBJCGgLYaZDMRL3s0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773921010; a=rsa-sha256;
	cv=none;
	b=NwzBhmfevv/K9dLCQD681KE6DKNZ+3++XJCUlvKUQNUubjWS9NK7RJ7hg37sF3zz8PYxN6
	lWusFn225COOdpPlyuobC5u3c0XcbnM+nLZyKinjI33sxZFaOk9FqO+V1fwmUxij7ymcua
	ZKxlwA8l+G5V7tADUOSGxLtkCT62kOU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E2FDC1BD0;
	Thu, 19 Mar 2026 04:50:02 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B3FE63F778;
	Thu, 19 Mar 2026 04:50:04 -0700 (PDT)
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
Subject: [PATCH 1/3] vmalloc: add __GFP_SKIP_KASAN support
Date: Thu, 19 Mar 2026 11:49:44 +0000
Message-ID: <20260319114952.3241359-2-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319114952.3241359-1-usama.anjum@arm.com>
References: <20260319114952.3241359-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: md61yg8cq5rxpbnygwk6ftxx7rgewmrj
X-Rspamd-Queue-Id: 3629E100004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773921010-595039
X-HE-Meta: U2FsdGVkX18xxzwqJHgzEyWHan9sGe5Vs0JPXCWaDXwFSUfKyGVEHDauVy2oTmEsiG6fTe0TAlZO+HOJ/eucys6AGKnSO/of9dAVbIXt+FYIf7goDm42M9G9M219msAdMSL6RpSKVEd4no1fM/Hv+nC3sAm+Ge5pUO+0ZT2OzVgPE+T/dig9DS1ohl2n76GjR0lF6AD6pn3W3P+TgOsroDOXLpFV28/85vrb0i5ZbXY9U2Kc4qDKuab+kbHCJ3h898Z5sEZOgjTWGpnFyFuJM3HZl7WV9POUnnRAlU9q0w4mV4EKxWiTsd/bU+r8tJMIGUg7/wWF1qzN9gTiseFRkJ816Oc9CwSX2GmF76rCetTqDmBVNCYu0Li4+i2UkKqfGF+di49ANKvkDr6E7RpP3lwrmfIpHiHa8Dw9aBjPsRvdqWn7WyrVMLp0WOoL8iQylHKf2V0vE7h3rn+msLAr64IrHBc5RXBzI8IiKiu3395LFpTb/cbsRCsPfi5dJJH2Ow4cX2S37J9Pkm1l9t+7brxB/eJC6/gpPauD0nZWompZVWgDB5VItMCzP6TpflAQw3/vb0CDrKWwDebiUYrDum5UCUnAZEJTIS8id+C+RSpveLZGl6JJBDmMp1SAMyWeN48t5rdtIcGv5L5KjVUYfOSr/WHC8WrJOdtOADxWTLqHm7RiH6raXf5zRrYXhUgR7elVGQtT0Su+0wqA6Z08vNNi/NnMl/4o9sjvgSlKNicne1skScJ6gHk2nPTbo7whvJrB84GyPBrKiXF3yFPeHW2+Dy4mdTyUyIp/0qoK6/QSU1ZQAKjn2/S11Krn7e6foCSQ/AmFskDnsMBds5jkOdFLzdNAPrjYgw/Nhjz8CAgAxcl8EoUkxArV9czrg3RVYJFRqFyMh0eDdswQlT0useJFfg7H7AZQhPfSn6rMPd3+u54wa8Oh4evSbPcyp1KsT11spFsaeABD+W6au8F
 RJs20vfc
 YFNZDm1MEjeUth3X3ccWl0NpTaN8+4XdULAaO5hH1kOIe3p9MRq7qWUyBs63aePyzi94TNz05j4FonqcKCCDn4mhNZc92ig4my2tSwOaEK51JIMCJbh68s/391Qb2S1CdbnnSbegqjwrEO4Lu78RixzGT+ehYtGmj5Q1wqtdSJ81F6FxY4Q7Pj9N+umiC4mnYwAKTrUzDNuD69+GCPSdRCj9SanCZwCXRKjJ6LsNgKMfuNxYWxjFQzGFaTlFjCWh0RgToQM7jejmww5QS9vJrNw5/Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For allocations that will be accessed only with match-all pointers
(e.g., kernel stacks), setting tags is wasted work. If the caller
already set __GFP_SKIP_KASAN, don’t skip zeroing the pages and
don’t set KASAN_VMALLOC_PROT_NORMAL so kasan_unpoison_vmalloc()
returns early without tagging.

Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc
APIs. So it wasn't being checked. Now its being checked and acted
upon. Other KASAN modes are unchanged because __GFP_SKIP_KASAN isn't
defined there.

This is a preparatory patch for optimizing kernel stack allocations.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 mm/vmalloc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c607307c657a6..1baa602a0b9bb 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4041,7 +4041,10 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 	 * kasan_unpoison_vmalloc().
 	 */
 	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
-		if (kasan_hw_tags_enabled()) {
+		bool skip_kasan = kasan_hw_tags_enabled() &&
+				  (gfp_mask & __GFP_SKIP_KASAN);
+
+		if (kasan_hw_tags_enabled() && !skip_kasan) {
 			/*
 			 * Modify protection bits to allow tagging.
 			 * This must be done before mapping.
@@ -4057,7 +4060,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		}
 
 		/* Take note that the mapping is PAGE_KERNEL. */
-		kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
+		if (!skip_kasan)
+			kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
 	}
 
 	/* Allocate physical pages and map them into vmalloc space. */
-- 
2.47.3


