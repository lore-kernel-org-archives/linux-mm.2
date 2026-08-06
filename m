Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D4AC56203
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6136B00B8; Thu,  6 Aug 2026 04:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D5F6B00BA; Thu,  6 Aug 2026 04:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3F06B00BB; Thu,  6 Aug 2026 04:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA1BB6B00B8
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:40:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7AB44A0448
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:40:52 +0000 (UTC)
X-FDA: 85070199144.18.7C11B3E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id D8F7140004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:40:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="t/Ynr+ej";
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=luXaZn7EL15ddUHoKiz8mpxtc1u84s/oCP+27ozC8oI=;
	b=u47hPwyUxgV+ySQYhtM3iXKiiqHAS+lSE23j8hkA4NK11JEfWQbNl+BJqu7qJK06Eu0Nzc
	nLHQ1V6AgpdCpllWRNtKISFWiBmzN+DaEtu5jJbywMpvxzFg7ck9H59Pyha02Z9q9LZzFn
	33oNk4oOrcXsKiLIDrihUYF1XTGlH7o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005650;
	b=XaaCcohveUKPqn6lqYwDythvBa8IAE+h6V3Shhq+IfPL7CEoxucPbD0CSrwRS9/XnYxB6F
	Y+7ulWLxQb7EXfaCLh4wLJ03wgvseYwd5SZAdPbhPux88YYASpaDRisxg/GXxKVwlRpETJ
	WXrGTGJbzA3InoVxHhP7u+t+DGjbxIA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="t/Ynr+ej";
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2184016F2;
	Thu,  6 Aug 2026 01:40:46 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 643063F632;
	Thu,  6 Aug 2026 01:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786005650; bh=DTTtIRekIWF5l2t5St3KvKIy8eTeym6aWT0fxyUq96k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/Ynr+ejNvl4R99JThgrl19rvWFbBsiFV4hn5i1ECdKW0th4VOZ7KbW1N62KnLaza
	 TGn2qP6Pu9ZcqkbElZvF+YoQ4TJ4dUl2ixVRmZMzHmEnq7CwFY1Ip2FbKjsKbj8QSs
	 SKPo2pQcwBYzu1+FTzMJdgVouKkCbA21MTO5pHvM=
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
Subject: [PATCH 7/9] mm/kasan: use hw_pte_t for the early shadow PTE table
Date: Thu,  6 Aug 2026 09:38:45 +0100
Message-ID: <20260806083926.1807279-8-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806083926.1807279-1-usama.anjum@arm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: gs5frpuhbtyhjqmud9hz63onfa9wkgqn
X-Rspamd-Queue-Id: D8F7140004
X-HE-Tag: 1786005650-149233
X-HE-Meta: U2FsdGVkX19jiJGzXYLsGYAceruNUh+yihKKipEmYJSCBYWrohsmSd/EQW5hTC7pxlbYWHdh88xzJzSQT5+5cZsZl5XUdp9psm1tghhbAo8K160P2mXaZ/6zj9ENquQkrUxpZ/I1yVRmDAugz2qNneQs+jEf8F+LORzi0g0fPE9T/7n96e6fAqloSxQhy51DUCArFJr9Tbmdp60XHRT/X9mcu30naahHTFddRprjkUzj0BEMJwz4qoU69fSt6PnXJU2J5no7xV9Yz1lncxnPIebQxR9RLl73cYfJuOH9V+k7te5rjzyq0leu4W5kyngcAE0nmeUtAvMnvnMRAdA1pDSDJIJBBN6SgcrClCwudegvHlgUbBYNc0/zyj07ti0KKKHhb4Wlh4Ew/11ZWmsCCjNT4n5itNbwa0dPqQdQwFQ+EVU4V7FLtwa3pyz2HK1aSU/A6ORUCfWQxrGmGvR68w/resg8JgQvu81P2KOMfiz529pJ6jnUVMptQRGfJ5gdxn6o8tdydpObGsaFa+sgH5KIYQN8vELWyrJ2x/ds42yW/ekBpcg6POx3X9X/GeR7xRDS7WDiayreUceEiOobk+E66ZroILqwPamwwLu3sAlS9dbrTWBp9iwBwrFthEY0dBIMoHXJ8niWKm6fWDZJyDVgAmZzDKJ1QMwxAL8ZNce/QOjBLCdWRNaAINAhe+HYvIzHyx/DE7gzIFzfWmPlHGr87/yj+PoZmo0PuDHzYmT8pCmSuFvTrfKbOMg8jJTkgZnarbtNxrm1waIX8OvWv0RTSKrOmk5ocuS7f8G9nASz88E8JjipSjTNV6Y9PX7MmIVlL2iRCDhXsGFMZU67TO/1n1mHtOSIwU2YJ1TcF6B07AFoDMI+rfg3D89B+o2jYxzs+08nQ0IVbvRAgMU7TqkEwSgfknybkN8p24VyWgs5Rohc9vIobeEoZsFfzrqObJrach7+FTpbjR8YD0s
 6fWqE3aK
 TL8h0jnRkrmaquMKBZPy2ZKaYIGTK0Aqg7Gdbi6+7NIE1s0/DmSkEf5ooN1Gs1fTtYhianvQVvPslktzgo2KQZa5MilfMDo8a+9nfLK2E2v+76yJlEPceurwK2OpmYVkqHxq2rLvdispsY5kDKZmXIjqTwFS5axuJ7im1EGeMXsczzv2M9Yo+33f8J8GUZxQqJECJEcnQESQANY4XEBm8wymczZWh2sSdw/zan5eOUhv1Gy7yOciXnsRRzo2f9ImJvzKWPtDE2jnMTjPsEK5aUmfrpJHDDCwK8cpJB5/nFJHzoNh4BZelfvvIdMJ43liYeHACfmQE5aBivgVLC32XgDDMqX8asPrn5MpyO029dI+4u+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_early_shadow_pte is a complete PTE table rather than a standalone
PTE value. Declare and define its elements as hw_pte_t so the object uses
the PTE table storage type.

Read the first element through ptep_get(), which returns the logical pte_t
value expected by note_page_pte(), instead of accessing hw_pte_t storage
directly. This also uses the accessor selected by the architecture.

No architecture selects ARCH_HAS_HW_PTE_T at this point, so the storage
representation remains unchanged.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since RFC v1:
- Update the description for the architecture opt-in model.
---
 include/linux/kasan.h | 2 +-
 mm/kasan/init.c       | 2 +-
 mm/ptdump.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index bf233bde68c7e..ff41949c0ac08 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -51,7 +51,7 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
 #endif
 
 extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
-extern pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS];
+extern hw_pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS];
 extern pmd_t kasan_early_shadow_pmd[MAX_PTRS_PER_PMD];
 extern pud_t kasan_early_shadow_pud[MAX_PTRS_PER_PUD];
 extern p4d_t kasan_early_shadow_p4d[MAX_PTRS_PER_P4D];
diff --git a/mm/kasan/init.c b/mm/kasan/init.c
index 30c5266eaf37e..9bbc2a41d23f0 100644
--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -64,7 +64,7 @@ static inline bool kasan_pmd_table(pud_t pud)
 	return false;
 }
 #endif
-pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS]
+hw_pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS]
 	__bss_pgtbl;
 
 static inline bool kasan_pte_table(pmd_t pmd)
diff --git a/mm/ptdump.c b/mm/ptdump.c
index 376880071ca2a..8f19f20be3c44 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -19,7 +19,7 @@ static inline int note_kasan_page_table(struct mm_walk *walk,
 {
 	struct ptdump_state *st = walk->private;
 
-	st->note_page_pte(st, addr, kasan_early_shadow_pte[0]);
+	st->note_page_pte(st, addr, ptep_get(kasan_early_shadow_pte));
 
 	walk->action = ACTION_CONTINUE;
 
-- 
2.47.3


