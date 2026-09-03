Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94B61C624DB
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938266B00CC; Thu,  3 Sep 2026 06:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90F5F6B00CE; Thu,  3 Sep 2026 06:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 825996B00CF; Thu,  3 Sep 2026 06:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 604216B00CC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:31:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DFE70A04DA
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:31:55 +0000 (UTC)
X-FDA: 85172085390.07.605E716
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 38E3D1C0002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:31:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fCi9FIbO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788431514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kZTtlD4ocNdh4rK3HJVQ+Me9rVTI5e1QQSa9K937fHA=;
	b=al9lWM7InnFEGKTqP5EpLvpB+1KfCbUATufAvOtVY4x84vt6C2WO5Mrj0wTw1lhoREB8qc
	1twkiabIR+90H1k2vxebk27ZgtLKclkQO3dVuEkUQum6f6udvOd/MBVnk29RSIRJvDWDCN
	VhzSMJHX1Jhsi9Z+YVwJ3e85TG9Eiss=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fCi9FIbO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788431514;
	b=v35DqCSPksrAZnz40JtYK78ogtGqryELc0VFNKGiCkCbxtoldQV66PQXFXW/8AMT66nOtO
	E23XrBYlFZS5wXBnD3/k6Ym4XoLkOGPkoYsT0PWXVq/a1wLkDGw/YbniOIYsvH0mOJhINf
	8TaD4I2GCvrXthOMmv0lC7wWodk0QNI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD4A21EDB;
	Thu,  3 Sep 2026 03:31:49 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 72E5A3F673;
	Thu,  3 Sep 2026 03:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788431513; bh=w5U+egOeicWr0JE6SxpCSEkSHT/w8+Jal3XqpPBc6p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCi9FIbOxN1jAWaeu8417km2w3h5m6j38WVFLaXWNwK9oAUqbXpEZ0Y0M46SfnfHU
	 is2CQLtW+RScu0xIwHD95QlemNucqa3eQLNLFkarQYw2QAH7o1yuYnaYCycw3vrZRL
	 6/l1lRwWzVc9APR0jQ4tBwoWuIBVD/rN/qIPAsKg=
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
Subject: [PATCH v2 7/8] drm/i915: use hw_pte_t for PTE range callbacks
Date: Thu,  3 Sep 2026 11:29:59 +0100
Message-ID: <20260903103002.1091859-8-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903103002.1091859-1-usama.anjum@arm.com>
References: <20260903103002.1091859-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: c81umur7rcknt7zuyh7ps8k4f9fbrsi8
X-Rspamd-Queue-Id: 38E3D1C0002
X-HE-Tag: 1788431514-786984
X-HE-Meta: U2FsdGVkX18YM2URHiHU5Qd/1AkkXZbatlMaFc6LTSS004eMsF9qH//5rIVRmtxaQS6NRSUPrHruLZL4R/QtUGPtSyl/luEONWZi/qZl0OBGg4owS0M8ExGjcdg8LMB1ao8ehw8T7C1wwSE6sZMD33qqVHQa4rdGbIvKWXWTELmCWHRHGqT9TUyak9WbXd1cX43wI9OF5Zs5+oBYDgGQU7ihA7WvUo8IXHiAaK3tbV5n/D9Wvj0SorLrnVIYKvqsC0PJfm1/MTgT+yMl7JOYKO0+Umuy7HvR3iZ1v4rR8VXNwX+77NvoacPYBr3F2DtIEuBOdJmW5nsdDSTdFLrQ5LyNULfBBOszNpvAtYRCIUgMy8P4tZYqwGvXomLr9w+EjYh3upA4J4joPLXEx+xJAo4SGxESOhRJoRT14jcwRdw7Va2VqSaNzGdO5XIW25us42XlRmTn+GN6oOkslFEQPcJ0fs1c7xVMbnvHVuvEdJ8g5v/6nICR3JvmT9CdkWhQJ+kB0uYH+qGh5XpmwSA2tLO97rmsFg2I2qaj7GSw7QNvJhU1snsyoN0Roor0demgPdP/UGiWDSdbQ7fMzH7+CF4qveGk8zF5f/apTmPn1mwJdEETsO4Wy3Xv2p0kZ1AHg4F8p/KGEg40R0oH0kkDOt0t2b5iW3obo/0vy45gTgaf542ezSuTqAqDKEjdS2Pf6rsGMltPYpz3p8PNjd851cw6fJw/Ita35KF346lTUJJ+WA/Fc06O/B8bTmJm7DnJfUaBamIF7a+GWvrllWyx7VguczA2369QjHXEN9C31NijXV6x4oKmoKcyDkda1Xr0rAbwgWfcsAnKdexUFQ6TrDBsdHw1DlHE7s2bCrWpCN3Le6GuXWFuikosQo3vkjl7vuHLpLqzn3QafC5Uz9idShkgyj0u5z1JkRe5OpWLPvfpFGTU0H10J40i/IcJGRfJ7ow8GfoA6RiM2gMy2uV
 Aew3nxmB
 Z/JvNwrL4iyPEdPbbtEgl7U3Vl6BIFhoNWFks7DnzgSTic9LaiWti4kIIQ//wOynpy1SXXLwCJ+fiodSen2eawiO8H+Q4lzSKDwBJ7F0pFImYr1a5HFo1/wXP5HYJP3Wzae/eljR8SV/2OkEkEBE+8FBgwCWAVf85akzqL4z/l/7uMhtGw0WCPgcCXkaOBfJIMHnqbCNYd9jcjaylYG7kjcNRdICCc65QzJW7DWi+zVsIdfV1gambO0qaNynWTw2x0kqbZjpkIzYnf6DxXAD6p43W37hX32COk5D5ZVHcxjoRGxLpK17TlEbooSL8+dZmdlkx2ooSBouil/H01v71Wdh7zryi+9xMwMDvN59sWn9tDWM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_to_page_range() now passes PTE table storage to its callback as
hw_pte_t *. Update the i915 remap and selftest callbacks to match the new
type.

Continue to use ptep_get() for software PTE values and set_pte_at() for
updates.
The type remains an alias of pte_t on x86 until that architecture opts in.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Use software PTE value terminology.

Changes since RFC v1:
- Clarify the effect on architectures that have not opted in.
---
 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c | 4 ++--
 drivers/gpu/drm/i915/i915_mm.c                     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
index d01acfb7d93d0..056faf4a3618b 100644
--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
@@ -1690,7 +1690,7 @@ static int igt_mmap_gpu(void *arg)
 	return 0;
 }
 
-static int check_present_pte(pte_t *pte, unsigned long addr, void *data)
+static int check_present_pte(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	pte_t ptent = ptep_get(pte);
 
@@ -1703,7 +1703,7 @@ static int check_present_pte(pte_t *pte, unsigned long addr, void *data)
 	return 0;
 }
 
-static int check_absent_pte(pte_t *pte, unsigned long addr, void *data)
+static int check_absent_pte(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	pte_t ptent = ptep_get(pte);
 
diff --git a/drivers/gpu/drm/i915/i915_mm.c b/drivers/gpu/drm/i915/i915_mm.c
index fd89e7c7d8d6f..aab88e8edf946 100644
--- a/drivers/gpu/drm/i915/i915_mm.c
+++ b/drivers/gpu/drm/i915/i915_mm.c
@@ -48,7 +48,7 @@ static inline unsigned long sgt_pfn(const struct remap_pfn *r)
 		return r->sgt.pfn + (r->sgt.curr >> PAGE_SHIFT);
 }
 
-static int remap_sg(pte_t *pte, unsigned long addr, void *data)
+static int remap_sg(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	struct remap_pfn *r = data;
 
@@ -70,7 +70,7 @@ static int remap_sg(pte_t *pte, unsigned long addr, void *data)
 #define EXPECTED_FLAGS (VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP)
 
 #if IS_ENABLED(CONFIG_X86)
-static int remap_pfn(pte_t *pte, unsigned long addr, void *data)
+static int remap_pfn(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	struct remap_pfn *r = data;
 
-- 
2.47.3


