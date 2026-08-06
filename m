Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DE46C56203
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43AF16B00A1; Thu,  6 Aug 2026 04:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412336B00AD; Thu,  6 Aug 2026 04:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300F76B00AE; Thu,  6 Aug 2026 04:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5FC6B00A1
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:40:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 812A5A1C92
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:40:04 +0000 (UTC)
X-FDA: 85070197128.25.E3AAC66
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 776FD40004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:40:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PZG9EdTY;
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OMWGRlmOWiapY/qCSf9UucZM7zjDsu+cNKzSxuggiw=;
	b=RcsXaPbUslkzl3tw7BlzP4Dc41S1kBJp6hUYUjvlAeEK4AjrM/26mAQ3pbbBpdJbJb+T18
	4B+lKgzj6j2mIv6ZAxeS+Lc9NTrZx3Z9b11nAwA+Q6UAzNh5dBbAlZ0V/6i7np8Lc3fR6X
	TfL4vma9PNPs8a5c0w0zivdGIwPEat0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PZG9EdTY;
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005603;
	b=Oat1bHiKf9L2Fo1Jm+YxJyEL1wJ9EEr11XIBwWt8nnhb4qrGH8v7GRw8ucKr6S8jE1XALv
	HhGzKACYyBi6EC8OkWOupcpCod2qR+3PuPmCiSzJpa+jibC8Z7a8/JamzZX5yvKwn2BXCJ
	kbvbRqCvn3+4caJJNsKgeIuMUr2daE8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91F4019F0;
	Thu,  6 Aug 2026 01:39:57 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D66C63F632;
	Thu,  6 Aug 2026 01:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786005601; bh=iynuOAJCPNuRyHhHF6oGom9ZpKtzcvQOC1dJwzRcJvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZG9EdTY1k5yypy3196H+wqk2/KNoPtVM/b9UYaFI6ZI3d24qfuLCJzRICQkyCkLc
	 sFKziULNcmx7SYfTqR1bq57rbn7/KNqG7/Xk/gSlWU94DTBYVqXEPKUndhrDA8EsJE
	 22M3TfK+4A1Hh9u1/kuRYdSEUGb4ZkLFgLd50Kg4=
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
Subject: [PATCH 1/9] mm: introduce hw_pte_t for PTE table storage
Date: Thu,  6 Aug 2026 09:38:39 +0100
Message-ID: <20260806083926.1807279-2-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806083926.1807279-1-usama.anjum@arm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mwteyysguy4kccdtqmx9ifbmzt8d9u74
X-Rspamd-Queue-Id: 776FD40004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786005602-282846
X-HE-Meta: U2FsdGVkX1+XfFgpQOkAknfouZXGH3fknjDWoszxUNkTLt/4aAcYCOG3sVvvQsta9lHxQMTfuPaTXCCnChSF5s1HiHW7hZhCIy5okCO/xCvTrD91Lp9JXIVXHW0qv/9S5BZcTgJFhAEQ8EhYnOyUAhan1lwRDfUFRT+kAcrkF8r+E1H2NNxVvVOj9eTwUCuXpo+BldkpUol3oY9/vm22no+mqomXZjek4ZXhlkfL/IGeXD8zNg7HmG4HhdwsCoSsZjf3plCTbob3H3vSaJTjAbEe9271KLrNxSOzv4TSO7ZlTfhCsJS9l9LjGt6cikFO5BoWxF0KJptxKa0jCnuxSVlvH+g6cqks3ph2EfoJJrqVjXv0K+5WCYW148y9oqcHNYY0SQQMq/OUvL2s5KCF8tjbEwue3WjaLUHFSjd+ykEuFtl0zPXDNUWJKQZsbXX63fn2ij0/U5ArS7L0RbCUAU9ASWH3Tm56eJU0S5n4uZzxXHOjxO7cm7bOMVXzeTlGXZmvYTM+sHlQIkGMG6yAwyGcJIXcBrv6B+WYaRUDYW9X12pN3ZjX6r2kbJ0+OIt6Tqbjh2aU7XRq5kPrQvI6Pz7YLoswEi4UAcYbKdqUJY82tCwYhtpSJkTkuF4mcgIxFRPgCHiDUw6rV9YCtfKazECYv2uSiirKduY4tcUmo+KkDDsHNXXQf5AR4XMTN49AhTiLf45kF9Y5yWTSKSoukGcszkXAO8Jd0n/+BV+Q7fjhl1kjJEe7G8XkYMcI8C3xSfIY9rk0N1//K89dNhJ3tJNF79C/CWBS0lwYPdf6IwQcTNygUySPdEX7XSASJKOggflf66jzpXWkG3gXWDXAKtINFd5wz5wq1Pj7btlsLLGx0Qb+j+Y6vnjsKIp/ZavGL/8bUmEaY6lt6heU2HwSBhT2AYrdbgYI+GRk/kLWGqosJ6ZGF28sb1e50p/X4E6cGq4HKd7TOVTujbCO8ei
 xBhkk+AI
 MkNz9K6F7p48mLYluJAwuzRB8+tNdZegUi1JLlBLM/t0rwI6CS7JHOIDeuRWb5oTphqyeLTy00vVatgd4chqk41o6e2asbabPWsSJMNskjLwwo/ajrzoONYL7l8SRGSbarASmxFKzqy4KdETwEDSdu/KNhmvQ3UjNPnsaCF/rlhvYr+i1SRWK0xu0op33+6LnUUssW9Dkxbp832Dpq+S0lu+wzmA7BjiSX+l/TyySQrFaXb1blqy+bh3d1+vEJB5nTNW8XxIE5aHL54f3RgyoVzrEmYtKi1nd3z0NvIzEKER7d5Mq1ueMcW4VWobe7keMHcgBgKwd0h+SPignvJjjnP2tpmRFEntcopgF9xYcs4dlf0E=
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
as a macro alias of pte_t by default. When an architecture selects
ARCH_HAS_HW_PTE_T, define it as a structure containing a pte_t instead.
This preserves the representation while allowing converted architectures
to enforce the distinction at compile time.

Keep the C type definitions behind an __ASSEMBLY__ check because
architecture assembly sources can include this header indirectly. Include
asm/page.h so consumers such as linux/vmalloc.h retain the page definitions
they previously obtained from that header.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
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
index e9c8567308a75..7169bea968cf5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16982,6 +16982,7 @@ F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
 F:	include/linux/pgalloc.h
 F:	include/linux/pgtable.h
+F:	include/linux/pgtable_types.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
new file mode 100644
index 0000000000000..70c3edd00a01b
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
+typedef struct { pte_t __pte; } hw_pte_t;
+#else
+#define hw_pte_t pte_t
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _LINUX_PGTABLE_TYPES_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 331daf7fcfab5..31ba9ebf4aafd 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1316,6 +1316,9 @@ comment "GUP_TEST needs to have DEBUG_FS enabled"
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


