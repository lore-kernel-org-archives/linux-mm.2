Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BB76C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C786B00A2; Mon, 27 Jul 2026 12:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02D236B00A3; Mon, 27 Jul 2026 12:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5E536B00A4; Mon, 27 Jul 2026 12:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A70FE6B00A2
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:48:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3558BA00F1
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:48:32 +0000 (UTC)
X-FDA: 85035140064.14.7D5061A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8BABE4000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:48:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cGls7zQn;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XXtx/STC1ItJT7X1zKb/TkgEEi5NbudfmtL5JqkQjY=;
	b=I4C18VF4/CTB8dwP3dIEhg7RBPy0vTsJGN1YBAXvwblO3jKvHiH/RaELEvNoDui9An08YL
	TWFdDC40lsZgpCs8rIV9z9u2wX+qHz8aUzmzPfpP6/uemx1DjK1VcmKYqqQPwHJWZp5kj3
	rrX7MZ7q/Ll6LO1Qad3BcI4sEHnH5hg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cGls7zQn;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170910;
	b=goSXMUuwrPmoKVp3TIeTrGszbtr86S+qTZ4SESxEBeTL/qJNjC/jFU9i+8UYUiojv/gvvb
	SgfNHoPyLKRd0xMELVWcji/irRIFFx1z3IcZldjWsE3XStYihJ8AcI8ahkxTomqW6u79sp
	EclusvW4DF4dWrwJljuxuKlLsp6Ns+A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAB971762;
	Mon, 27 Jul 2026 09:48:25 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1D0C13F86F;
	Mon, 27 Jul 2026 09:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785170909; bh=qlMBEgSYanOpxaG5+GObNIcpflrmglgvjw2BYgGRiAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGls7zQnlsACMOdTrPwDBJKOvhD8kH8mv7YPFdOjvjhXwbN8u4sgWSL3YZNOD0Pml
	 XyFgMqudxOPDpAUOdEAXMsBPUM1LKrruj30a0mmvs9giDguNXB6O7JxdB2zaKUWPNm
	 8j3C5nbVhGELOQy1dslFMHRX+rphcvgUZy5T3uvw=
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
Subject: [PATCH RFC 06/11] mm/kasan: use hw_pte_t for the early shadow PTE table
Date: Mon, 27 Jul 2026 17:46:57 +0100
Message-ID: <20260727164715.2866609-7-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727164715.2866609-1-usama.anjum@arm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8BABE4000D
X-Rspam-User: 
X-Stat-Signature: xu3pz1o6kkd7eucihthrp6sz9jjsfb7x
X-HE-Tag: 1785170910-682088
X-HE-Meta: U2FsdGVkX19YNgqjfVUi9ncRlQL83qM2GOQR9lqbWCKIpC1N6C+IXerTB8tk0z57XNzZ9995GAQuSj0f8x+9qQoNNQKGkkXgw5Y5jVwuLIIB8cIK8xHXwfetBBghesPl8xJ6Vkweo6wPj7fOaJg2F8W3o2f488bI7qZk9hCvn5gXTC/xXu33y0x5M9WDoTXACFT/xxDyiWdw41WSf7atQVqxqye7tPH0hfhHL9cac5I7XbO0iLLD/WEcEZVqFwl+WxcC4J4Chq9QOgJWTB7XKcoTkSkKeH8xnKCo86un3wB7GbJkfUFRRRXSreMxAp4NU/86aU7KSNITm1t0CRrhY0qi46jw5dXFMyVHpfzSW0nECSbNiCHkkn6GgtdkItIVQYqx4wj5gflRy7HteHkSKom+W/UWHOvV01TKpbCpxNNQKDqMwJl3/80ljBdQ/6AyiRyrNeqVRqNi2bFUKG09X98F03jZc8wJwI9XjIQIDMvLIoBDogk1b5tZfZiPD32bCa/+bF1SZf42MzCkzLcCHTEOPTqwvKnKVwkH6Z5zfbX+tyaH1KbjlTBP0yEURXr0gmj6Sw7puFWBLoZhcqGahiONT+Eipnl+0TXHEAyqgmeAMY7FosjGUq9w9K9lN+k+2m0CH8bT0mGwJXAldR6avteRF+IxqOavafl1H33EQKgm0AsA5v+VF4wJ3a1MU1fFBUAehhsGpkaR+x/1xU7T7Qk4hz37iiuebywEqhkd85+OBi2Dv1Nia6ag0sXdrcr+ZKWL/t3LCQGCQGKIBaGxBxfR0PMDxqsqYriy6WSR18hfOnY4N2oWDtTOfS1rFDMoqBPRc6JwVahfX4xw+9+Nivk25bvQNGSiMclPU8N5McxuGsBNMCgpV9gcQkkYjXl9KrjEEMo7D0+xMNjsgbpzxWgbdFezFOUs90orYrOOeN9d72tUfxCUZipbK0S3+SQ77z0Dhi1SyFYNz0mXOXR
 B3R3Rj3o
 Xqg8dHDfGnHNhTBpJHvR19vVfglXTnJaPhDWlCFwlDUOzGrybStaCDSWsgrKQm9de4kOWMwzWCY+4K6DWpy/7Hh3FpWtdvilhsoMaJx81Q2OsVW55kgKMI3qAISgHux6lnfhuqq0J9d/j7smMQ+lKRh58fP9DDf2O4FClkhSSPeZCXqG0ZNdgViL6bodMlewJPXrL7vBuFDsucMHTWnW04+Vo89Vd5L5pnZW2GezQ92pf4df4tp9bqOeuWz12xbbApfKz44mJJNyCR+N2jd2q+rcwG3dwBZrh5RgXPyWCbBdt+5+z5vA/javo7Whea2dwBP7ew7L4yydWbQUOx1cnQarj7pGJzpmTBpku37zrYfNU6bU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_early_shadow_pte is a complete PTE table rather than a
standalone PTE value. Declare and define its elements as hw_pte_t so
the object uses the PTE table storage type.

Read the first element through ptep_get(), which returns the logical
pte_t value expected by note_page_pte(), instead of accessing hw_pte_t
storage directly. This also uses the accessor selected by the
architecture.

The generic hw_pte_t remains an alias of pte_t, so the storage
representation is unchanged.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
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


