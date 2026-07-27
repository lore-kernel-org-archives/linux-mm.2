Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14A0FC531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B44E6B0093; Mon, 27 Jul 2026 12:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13D426B0095; Mon, 27 Jul 2026 12:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23386B0096; Mon, 27 Jul 2026 12:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDEA16B0093
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:47:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8BE551C0065
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:47:47 +0000 (UTC)
X-FDA: 85035138174.27.FA648E2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8B5BD2000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:47:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cD/2EUfM";
	spf=pass (imf03.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXtBez3IYLi3/8RI2fGSq0HHGWD447JpG2FHAjWVCZg=;
	b=lQDQaTayGYsLrpBsdn+bO69YPNzOzoJCH2DFjJZPaGdlVr1kRAwXOr27TfsXXtvVwVXNVp
	wLLOSnAiO/fBJ2NIHhLyEj/nq5N6ly1SuQv+GD3AsPoeKAwB2ettQxPA9NvnRU4qeFES8e
	jLJM8TsV/P3nrtVT+b4YC8YSzq+AQdY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cD/2EUfM";
	spf=pass (imf03.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170866;
	b=S/E/4g4OpPSUCkopLDTWr01OFeVmV3lK++aLB4CO0Safyv0FK6VXnZ3pI9/jHaCc4/0rfe
	kD0a5LaqakYdNzshZMhaUH/FZ/7Krs9745dQ7DBFtK3evtgs5kgPkWc+aY6zLDpcCKafxO
	UFZp+tuARn5WJLq6nmxn9PJml9mYZvc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F79516F8;
	Mon, 27 Jul 2026 09:47:40 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CB9873F86F;
	Mon, 27 Jul 2026 09:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785170864; bh=HTxL5I80nQ3dFGJzsPYMsGaUEA0cATezEAGoZ6SZAko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cD/2EUfMuUeyBVWNFHChNrDBH7K/jYSjTJKf2AXn2R9DI+PVxfhjgfb453XXO3T00
	 wM2xtUT1X0QX+sopNRnwbQI/o96tO4ir4xNQ7qJwgqdJF5QNcWrVk4USoCTYK5iOy/
	 9Wp82ZRCjM6t4RzOb3pUepvrD42VVL0Lu3oBSBc0=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	SJ Park <sj@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	ziy@nvidia.com,
	pfalcato@suse.de,
	agordeev@linux.ibm.com,
	ryan.roberts@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-parisc@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH RFC 01/11] mm: introduce hw_pte_t for PTE table storage
Date: Mon, 27 Jul 2026 17:46:52 +0100
Message-ID: <20260727164715.2866609-2-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727164715.2866609-1-usama.anjum@arm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8B5BD2000A
X-Stat-Signature: zcq15ojr4eac9j7jd7ex9bwmqtzn8zg9
X-HE-Tag: 1785170865-844781
X-HE-Meta: U2FsdGVkX1+l0BGwvfiNShABwoIVSEnsK/uDwx3ddAaAcSdP/ZC/0M6DyKGF7O27Uzz+0N5kU361jvXtvQ2kjj/m5qlppohoOan1vSF68ndAMlgK24+ENU8iLH12Mnmqw5fva86TwoDimfQbaUzSpSWrqwZk3JRrUrPJnhzVd654xdqNa9RX070j9IhMgunMp35u7ayAV0LNE3qrVvEO36HIcGC0SGsh4g6kR0fK/zcpN4HkTaU/QwsMd59CrKsEpxXoO1UCFXxWxhf2HJ1ijBZne73nOoAkmXUNpPlmYueCBUcF8fFgr8ABOx6+z3b3ZLr+GN4hYyikFE2MiK9P/7A1aa28cTM01+6SzbjmrLu4efjNW6AspD5HV6igK8VhGMG0QvFAJ4d7l3HrygyFm3yipM3O/2mS0KHSOkIAbEz18aGkqLSzwHpGycYKfw68ERWLGtCrrGesMQJAuOICdK//zyJkELxQmB2TIpyVX711S6wjRnskgaE3NX+F7ZA7r8o7LGk62KEOa//s+UOvVVMlPOicmWdpkcXwFZ/GhQumledUBAA4ZA7aNoE+6Y+vpVCXGw2m/VEqQpBDHxRmaWCrPCx/XCNH7rCJrkyF2d29Iq10VqjhMKuZhc/LTs17oBuguQtDbGQm62py8Dl9uWMat9kNfq9FImQDrXflCvSE4ZNBdzTrTicjw42oAgH9gi3dtwG/v2NCW6WrS/aTyAn84FX0p8tEd04MGSTN44wS1+uvOOOjZMLq6ux2iIpkLlzAigbA7j8pP9v7V/EUGdzDwBZa/8RIP47Aax9GKMCowk/P2AyPFJbAqPDNbXjVdemLqN5/83wtrsJ79Ycy9JjZhYyIJdmZx4g21ubC+9072eClP5dlKCrJdXNIN2cWJGA+5UeQHJb2Cemer0zIcLf1uKF0hexnTamE5CFUftBTucAPWsf5Y1YRs9ehy5/avXmn78O3FvIzt6eKWSD
 oPn0JUL2
 t9+IoE0F9IgSO8CnjqWxFNDUd+eYn2zeggxg+CyRaqtGxuAuWJisteY+B+DUY2nCv2c781yISNkJqAag44wFfmlHBrUuWCKMt/UE5jNQcJz5EWSGVc9nfsBKNrtcJGpLyjxVvpYWbLloXNiTfmD1Mo6ZLQSNVU3bf0oBztDWzaFbu8DsIGSVJE2LfjPg+MyT3yDKPlAVwI9L5hfvRtqNBwIjDVl6d9e+Aq5ejbGSZiIwttkv6ZbAYadFXWYha8d/qXt1oMwQkzRm6TpIt99PXoR05KZggMzk22ObBGj58XDfz4vilw0kKLfkWnKRIR+AOjukCr4g6UbL08EMSD5R9P3PTYJvqE0R4Xo932N8xC6ZWmYQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pte_t is used both for logical PTE values and for entries stored in a PTE
table, so pte_t * does not distinguish a pointer to a copied value from a
pointer to table storage.

Introduce hw_pte_t as the generic name for a PTE table element. Define it
as an alias of pte_t by default so architectures retain their existing
representation and behavior until they opt in to a distinct storage type.

Include asm/page.h so pte_t is defined before the generic alias.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 MAINTAINERS                   |  1 +
 include/linux/pgtable_types.h | 11 +++++++++++
 2 files changed, 12 insertions(+)
 create mode 100644 include/linux/pgtable_types.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 15dd00c7ffec5..78aac05949829 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16981,6 +16981,7 @@ F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
 F:	include/linux/pgalloc.h
 F:	include/linux/pgtable.h
+F:	include/linux/pgtable_types.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
new file mode 100644
index 0000000000000..ed5dba42a4f8c
--- /dev/null
+++ b/include/linux/pgtable_types.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PGTABLE_TYPES_H
+#define _LINUX_PGTABLE_TYPES_H
+
+#include <asm/page.h>
+
+#ifndef __HAVE_ARCH_HW_PTE_T
+#define hw_pte_t pte_t
+#endif
+
+#endif /* _LINUX_PGTABLE_TYPES_H */
-- 
2.47.3


