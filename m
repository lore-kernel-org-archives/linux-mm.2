Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DDB9C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140586B00A4; Mon, 27 Jul 2026 12:48:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F11E6B00A5; Mon, 27 Jul 2026 12:48:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFBA06B00A6; Mon, 27 Jul 2026 12:48:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C3F986B00A4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:48:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 42E9B120133
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:48:50 +0000 (UTC)
X-FDA: 85035140820.06.43A881F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9174C1A0010
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:48:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TlXTwoRR;
	spf=pass (imf19.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9OAlfmcYEOqu8zuQ6rlVT3ECLrmN/PLlt5u5RzJgH+o=;
	b=qaQyCg/WzWcXPilOSQ1a44A4G3++sj2B3Y4P4ReJ4m693dzkE+qEllQm/sFnvEITiqSPVl
	uhFTPZxRKiiAVa4G49sKvJRuOuoA6uGFsvQtkqjkAU/hn25KvqK5v1ZTUjxXqic0Zij4ZP
	gG6sskq58k1Yd4PGKFm22yX9F579PoQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TlXTwoRR;
	spf=pass (imf19.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170928;
	b=mCcFeXGmMQ8qLWrqusmo/e0FuPbuMLC4DCLFEWQb/CZKLVja1RgI0q5n94VjcqR/YHWdm9
	L9cHMO8e3OPuW/MrcPO4+gXsPianHeZOKji2tGa2/MgTLMyHymUvtIwZQ5fWZIt05qbHR7
	O158UxOdGdKWVy1zBarDdni/clXW2AM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6CE6176C;
	Mon, 27 Jul 2026 09:48:43 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1BF0A3F86F;
	Mon, 27 Jul 2026 09:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785170927; bh=CNlHVT/CmxBUOVY6CfuxFxYbSX5ewnbm7YL5RcchowM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlXTwoRRK0Q+V8Za5J7DYjVsZ+if5g4kXVfJnfFmctfVLxFq2SX4GBaC2bi0e8NWA
	 LRsIxqAUpqOoTQRWDck8+AFKBOsKSw/bVdMcjgbwsUa/PtG9bA/8DxKrDHKwh6kbPY
	 j6c92y4Zs0E3dmXI/jy7qtPoQSWFIvG//eGdf5FY=
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
Subject: [PATCH RFC 08/11] drm/i915: use hw_pte_t for PTE range callbacks
Date: Mon, 27 Jul 2026 17:46:59 +0100
Message-ID: <20260727164715.2866609-9-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727164715.2866609-1-usama.anjum@arm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9174C1A0010
X-Stat-Signature: 7ka19mqa1dh315ggrx567osam9smcgyr
X-HE-Tag: 1785170928-174151
X-HE-Meta: U2FsdGVkX19hqxMqE76ybvVZfK+Z6sV/5c7y8UkmQxcouqOYPR89COW/oPsG5bXbTuNVx02/radyqMR+7dwJ/usnBiFG74czHkkhLyUdN2Po+z9wfo/2/6tl9g3GQHx+nhWi/JuWIYAWK8WOa84FzCE1npJcWMACeLSc8S81akR7ImV+nC2SyLKNXqD9btRbi5Yee2/XHg2UKTpBOuZl8IicQr9Y4Yd1f1y+PD1uTIRjk1L6mdaJEldgh0XcqQyFvybUCICFBX8d5Q6/r69494tSkC4WJ0VjFwf1aVE5BrC7SnzNES8P0Neyx0egUh1/LODXfeL5DQY7Sih2rb6Gt//JcEq72SmEfTh9/L9mjJ8H6EaG4rjY+tj8bNevYHZzdqv/wb//O9nQFh9H7+Ktp5LvTyT2J3iE4KFS/P8TQL5NKna6Dn+FrdRUl568fxvqSIqenKGFpqh+xlYb4eyk6NhK8FElGAbggNwcrJdb1SxQ5/XnJ37ELusGvnD/zDORBifd459a2yO0LXMFZw7+S3Q+sZTL1qcHa/AQEA30u+eD2+rgimuCFTAlkdEpZBM99mx64zjwfGc9j6iEtkj7IZVi8ZW0v4BY6vdQRCkJ0V1Nl0XPoGZwywL6iSBhB+X+XSStGZK2fewGAe4bwcGIBXwRtzEQAnNps9Bi/47VyMd65DwelMhu0WIzP32OOA4iLJeTz+puvOurk+TntCWxgau7fsocvYkinIaRRWH1qYE5+QDXOEb1Dd7zD/Q3MBv8uROKQGoItsOYjO1cf3qFzkoYcKDuVaKls4tWeaAfRMc8V8A4HIijCOiARju+wVx0b5/v9yN0Ao9mdDnFHjeC6+kfWsFQAwRdfJ3+gzxFAc9xBIdrxrYGE9x9gt1GrtGbeAFDRHZ6RRiSyJIF5e6qtQtFoV7esfmiaYL+OC8L9LirBfffeYmbpd+amV0ojbSRStPTr6gwzhIfgMg8Rm7
 jILKE2vl
 jmJEGn0mudJt/UmB/Tx+gao/L/AK6c/m1FaCpPjJwkQK2kEWzp9i6BFj2qVfamreDRgc6vATTrYisSmjkBkxNPXNXUJPnv53myKfDqtpACNk+pwdqt5SbV2BDmZehPfDE4VJnkeerUam313AFqO+eml2NFB+YzsUCA9uyfA1Qi0SFisOXhPGwo87KIImSoTlBLZ3zBZaMpsixF4wlNeMmzI/GLHIixyHZfb1ALti0t+dVJYg3anF4O6rVBdrYir/1anFFQQHucWaAbYI1vc1hxAn1yM9VmZVlH2o+Jf+oOaX2o7D049f8V66O3XhP8OCX3G43UZtGTDa5739g6ItHqSNnd5+4/NRB8D5g2Qpkv6ZkPLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_to_page_range() now passes PTE table storage to its callback as
hw_pte_t *. Update the i915 remap and selftest callbacks to match the new
type.

Continue to use ptep_get() for logical values and set_pte_at() for updates.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
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


