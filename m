Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB679C624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8FB6B00BE; Thu,  3 Sep 2026 06:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1216B00BF; Thu,  3 Sep 2026 06:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E78A6B00C0; Thu,  3 Sep 2026 06:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69AA46B00BE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:30:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE7DA1404A7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:30:58 +0000 (UTC)
X-FDA: 85172082996.09.90F8A9E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 26FC940003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:30:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OCqN0IM7;
	spf=pass (imf12.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788431457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=boIbdWY3njDuq8O0ZC5c3wai0+LDy2ZAyOHaVP6lhx4=;
	b=osEBy+8/tSblQ/HQOMah30kv/kX2+PezCxXPLO2+Asn7dIoCKCNkM8Rjjk8jSOZMr7WpQS
	TnWc+tq7rQ6jpo3t3Qe0KoJS39sd1N+JEeFIhN0cu6fbmm29El/EHqn4NFrI6ZAevMEjdo
	rerSXtFdtCe1pq8sQiItbseVlPPhJHc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788431457;
	b=MsgAgNeJbmWNO3GoL+ud9D/gepv9a7LkswBvzwd0/IyaEFqO5mMM6alDYqse0e4NkwUWeM
	WdDeeXOaDcg4bmUN0kjDtajqijajKNwJCi/5HGFxbXjzF+/xt2HRquv0FqXp0/kNjQMy0E
	aoam1To167q7QurtZt4XbrO/aC11Jg0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OCqN0IM7;
	spf=pass (imf12.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 993991F02;
	Thu,  3 Sep 2026 03:30:52 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3AE423F673;
	Thu,  3 Sep 2026 03:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788431456; bh=DEt3KlUchGpFfzI7cFYM3vauHOwXVIVRP1eSVCB1rgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCqN0IM73DlVeIFEnlcCIuqR18FAoouHSGHhXNucYr8rONtG/PWo24UoFAmagMzIb
	 8r48Ezf7p4wr9UIjQ4++anmaFeiCydvVPqtUevaAhHfgY9il6/+hvRvy7PKAcpAA/e
	 wapcW/7pqB0l6aY7tSwko5ZNforUusnJFwU24SHs=
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
Subject: [PATCH v2 1/8] mm: introduce hw_pte_t for PTE table storage
Date: Thu,  3 Sep 2026 11:29:53 +0100
Message-ID: <20260903103002.1091859-2-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903103002.1091859-1-usama.anjum@arm.com>
References: <20260903103002.1091859-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: so5h3ubinqk9ju1fpjtkugquz4zjmp3i
X-Rspamd-Queue-Id: 26FC940003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788431457-74708
X-HE-Meta: U2FsdGVkX1/4kFXuN+kENhjNjXHk0hHleJLUwgab0CNwN0la2S8rmOY1viOnNImUjegZEND9gm3DLEQ4B9HDIOdv1M3w6aWULqWQNwSA/sqKyvlVTeVE9SeigcZn3YyPp4LZmuGrFea84KZ8Fj8V7dXtWHMKQW8LcrjJvVmVHZ80qttit330LUv+UL1B9mO04Hrf3Z5Gx/ix0QpEg8HMWtqiCF9y8trOyNhQCCDhRoeO8ghDHe1bqxGGgKuQnX+haSTaObSUN1M5uOQn2o6KWjdXA7nAZRM+2bJMsrci+CIVFGQBZhnW7q7fnFxQe/DfLYxW9L65o8dHrpkTNWqTCx+SrIp5QHSG3KJE4az555zjat4kCAJvHOnx6LhLQNDQh/d2oA7gP8GKB7KHdnlwYenF4LhDByw89U6C/E5f/lJO1CZyglKY8SxEkyEnkEwgbTgQ3KqP+7opsgLDLr1K3TdR82YZML3Jld5tVGGML8HOtgjMKe2j8kVefzKkFX++RniuudeLVC5U3Mmn5gcTC+AfNYokeRvK+asRrvhoGoFUJ4F6F8NqWhZx9J74klq93MpKPVMhxzkeZaWbfoZec5GIPJ+c6ZEFaopeTW0Cq1YfM+lyIwANlFoAW1C/1R5x/GgOJCajqm7ryQOWd3Ladyx+5MHJchzpN4p1X1SH3JSNB3pLZvKhfd4dopA1aGkLqEnwe4tNCXiJndO3sqQRMk+flsCbye6rnnN/z9cw4gwjHpRrDwrSvqNB56kOPLOf0n65RRVgQYjBS1qhuymCA1bU6QM90outq8r29+n2XvhEECX2WTMXN5Cn4b3fpV0M1Y8H5vJWO8KS95v2CCSpMbZFewf6BKT7PjmMrwwm31wm3y2Sz5RHXofPbLQ42UQLr3u0UuVqSAUERJoPvMffs/cSuaeCpEsxUEE85J30rtDawN209tLEwlZZiHpKtncGKjSNakCboT34MMWdmM4
 6t/fbaBT
 EnOjmzJx1H6IDRZToJJgcaneVol2XGBd38/pjXq5ltQ4QwNF3aaLZ2F11XPMQUsXtU9hZpvSWM2XF5izzHypKWef7xj66ixuTQNz+gyHg5luvqHdTwJqDXof6ts2F+0kR2c5ujyIlFq6sOIK6udy6J3ux/fOT0LEXs413Ck7KyM4AADTitM3N9njt1QRWAdPzu+VTvG1FAoeYougv4z8oruR9GgTb62ZuUwDM3yPtZPrHjtfRUIms33jrTG196O77NZ3U/PK1wAVyfu5TL+ENg3NeIg8x8ofBY51juUg+3clXN1T8tcVzbhPMTKOyYmFE6eK4/tcO6/3kO/qXtCTQr0RO7yh55B4wE++SxaZGhINjOv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pte_t is used both for software PTE values and for entries stored in a PTE
table, so pte_t * does not distinguish a pointer to a software PTE
value from a pointer to table storage.

Introduce hw_pte_t as the generic name for a PTE table element. Define it
as a macro alias of pte_t by default. When an architecture selects
ARCH_HAS_HW_PTE_T, define it as a structure containing a pte_t instead.
This preserves the representation while allowing converted architectures
to enforce the distinction at compile time.

Name the generic wrapper structure __hw_pte_t so architectures can
forward-declare it when pgtable_t must be defined before the generic
hw_pte_t typedef is visible. This avoids header-order dependencies.

Keep the C type definitions behind an __ASSEMBLY__ check because
architecture assembly sources can include this header indirectly. Include
asm/page.h so consumers such as linux/vmalloc.h retain the page definitions
they previously obtained from that header.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Name the generic wrapper structure __hw_pte_t so architectures can
  forward-declare it, and explain why this is required.
- Use software PTE value terminology.

Changes since RFC v1:
- Add the ARCH_HAS_HW_PTE_T opt-in and generic wrapper definition.
- Exclude the C type definitions from assembly sources.
- Update the description for the new opt-in model.
---
 MAINTAINERS                   |  1 +
 include/linux/pgtable_types.h | 17 +++++++++++++++++
 mm/Kconfig                    |  3 +++
 3 files changed, 21 insertions(+)
 create mode 100644 include/linux/pgtable_types.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 2133aec4a2004..da60a8bdcddb5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17140,6 +17140,7 @@ F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
 F:	include/linux/pgalloc.h
 F:	include/linux/pgtable.h
+F:	include/linux/pgtable_types.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
new file mode 100644
index 0000000000000..07da05d375c2c
--- /dev/null
+++ b/include/linux/pgtable_types.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PGTABLE_TYPES_H
+#define _LINUX_PGTABLE_TYPES_H
+
+#include <asm/page.h>
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_ARCH_HAS_HW_PTE_T
+typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
+#else
+#define hw_pte_t pte_t
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _LINUX_PGTABLE_TYPES_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index c1ddf59c0d71a..5f462ec6fa5e5 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1312,6 +1312,9 @@ comment "GUP_TEST needs to have DEBUG_FS enabled"
 config GUP_GET_PXX_LOW_HIGH
 	bool
 
+config ARCH_HAS_HW_PTE_T
+	bool
+
 config DMAPOOL_TEST
 	tristate "Enable a module to run time tests on dma_pool"
 	depends on HAS_DMA
-- 
2.47.3


