Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18304C624DB
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CF0C6B00CE; Thu,  3 Sep 2026 06:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F696B00D0; Thu,  3 Sep 2026 06:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195E66B00D1; Thu,  3 Sep 2026 06:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECAB46B00CE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:32:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7AC84C04B1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:32:05 +0000 (UTC)
X-FDA: 85172085810.03.AD8AF61
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id C0A8B40004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:32:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TqdJTvjS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788431523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUvUnme91PK0IEa1ZomZ80laU3/KffkEKy13dFEsfI8=;
	b=XOf5dhIlkSidn9CR2bx/gavOVV+bG8PVqY1neQGBPwqMAfTy3N4Mk2LcY89KJLsIBQ5GGa
	cKpo6erEiMWqtf1NiCqnXZ65FAQ79YIauSuKnHyFteBapA7zIm4DIxAq9oeXGyAFTvbq8S
	NGq0RWQOuh4poI4w3YPYq2PWKTpSXh4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788431523;
	b=BNj3DmgTcfQMn0xk6j7tMVa9RQoHG9EFcRHvi92Cke8R+VRXGFh80khLq0ArQW+JwPdzPc
	bH7NVtT9qa/gQ6f3KHH3Bg9428v7EMf6673NLc0HnM8FUgNVnXYsOzI3gPjd4w7X9/PxeQ
	zj+igH8sbGFlO/c02p648MP0drcriDs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TqdJTvjS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5621D165C;
	Thu,  3 Sep 2026 03:31:59 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E7E333F673;
	Thu,  3 Sep 2026 03:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788431523; bh=jnhKOvqXNxavrVkvy1TrIz2ZFbREXQCKHvvjfSTHsrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TqdJTvjSMBL/Fecpzq69xnSc8TtbMviOhHJH0tSUQhuwn0beTUse/c0M5IvEcZQBk
	 ZWuuBe3peOseXoJxaSyHvNwu+SsvzmYsY5yXAGPVWpK8KMU1ZQ4B3t4mAKW1iUi0QH
	 u2Yb1Uhkv1kKR+XFEs06dtpTzXB1MMV4rnuygP5E=
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
Subject: [PATCH v2 8/8] xen: use hw_pte_t for PTE range callbacks
Date: Thu,  3 Sep 2026 11:30:00 +0100
Message-ID: <20260903103002.1091859-9-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903103002.1091859-1-usama.anjum@arm.com>
References: <20260903103002.1091859-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C0A8B40004
X-Stat-Signature: iudc445am1njag6rx16xwapboczztsbc
X-Rspam-User: 
X-HE-Tag: 1788431523-81419
X-HE-Meta: U2FsdGVkX185IYKb/mVg2e+GW7sQqxO7zkk4VFI/S2EP4RsweTRCWs5c/8DX9XGO3LBZL9r54hxr4H85sRWljbsMFnOzeJos8borpDsi26aP4jUUJL9ob9XZgNjurRhlnU5Rm/pmkvIoJAD3U8CJtAOceTCM0MbcpO6Ru1JYg3hayDesTy2O+fC7NO7ynaHo98SQTOX+gKbljhbuyskw4rRTGcYsrRJ1SS0iypuS7lZFqTqAgdfuDzxGAkcepxFyjMYmtbDwmnBC6BYA2zSuhGh+UQmpLSEmRpJNiyWcVp8AGxFqzHfcuw/bPp7vbK72RzyXoq0v7rDz0psRSg0eCo3R+j+F9yAVtoLoyLSeZLKSwzTwraY6BfX+ooZPHh+jlNuPxTuQ5alItODTy2VS6Jbjze9yiI7CSJ6a7P6Kf0zSzA/B6PGqfXNyX8ULvNnPgZqVpWJfvHm3Ll3ZTae1fA4MdxmV6Jlymt1kZHBPQ/V41e2fiaz4XaHWnB98IgYyAT+HSmIe8DsHQSdn6Wc8AePnrpPmzrID9I3+6rA0m7cnGChgzo630/xYe7tjfwvIZ4xlo9pm6LtLSfNr4FR2+sRteNsSxA0uu/nkuzyV9/y4b0avwcKF+PHIQLjYRn95mmL+0efEktNurhdJGG0a8fUB29tlFjB1bKNayml/9ccURUrs2S0NVeu3FpPxjGTh6PRjI1iygl73Nh+3QHPNs/N3kjUrqJHiGQiFlgumeURWzmqb8AinI1FZ1cYDclsjuLxUXOcWa91bgX0R4jEC37KZ81l7SxtCoVslc7TETQt3rpfz3dTHpboygYhTKGi07itEsfUywjj3NflDDxoN+iq7DzBfqIl0CKlu8sk6zSYcHnf4nEfDdFl4l0DEwCvDsvphMs/N3H7Uyl2tfeERPZfHCpEBkh9w3K2a1lRKENS3grh2qpu2USPQFc5dcVU0txnPj9wU8vbE0WR+XI7
 3DgrCfIi
 Z9t9jtTltaTZ8gFhuFVdfWIQU7LgeAJmZNgONyHKAznuP076j4XP5bZ530X6kkiaQYrqFirBF/3GZlPgtQp5TpkCbDVxML5ACM1E9HnG5g29n2ByDYn7Av6vdKELwlBANOPK314MCEwkbh2RUcPNOb8wPD51RAb2jD139ucM9CavtVU1BP5vW2mk/G19AhmI5Y96Ww7vJb+9V5MPtWKuytvPcXydwTedLB7ruEV7DNPDnoTMWR95qK0jMdT8XXPJqxIxp3275WP5IbufQmuqn6ZXN39/zp/ZHDKuaaaZihsAUtEHaM04H3bCKzRpqAQaDRmEiq5okqkcM9X4MWdR+S4E2vclZMILGlGhSzSxJiRjjkmXpv/e+hsGVnyDzxIVaPko92viuaLabFv2vTPqM2N1sVjaa7gmkj1c9437mAIzJlv8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generic PTE range and remapping helpers now pass pointers to PTE table
storage as hw_pte_t *. Update the Xen callbacks to match those interfaces.

Keep software PTE values as pte_t and continue to access them through the
existing PTE helpers. This is required when Xen is built for an
architecture that selects the distinct hw_pte_t wrapper.

Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Use software PTE value terminology.

Changes since RFC v1:
- Clarify why the callback conversion is required after architecture
  opt-in.
---
 drivers/xen/gntdev.c               | 2 +-
 drivers/xen/privcmd.c              | 2 +-
 drivers/xen/xenbus/xenbus_client.c | 2 +-
 drivers/xen/xlate_mmu.c            | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 1dcc4675580ed..b013bcad99b5b 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -301,7 +301,7 @@ void gntdev_put_map(struct gntdev_priv *priv, struct gntdev_grant_map *map)
 
 /* ------------------------------------------------------------------ */
 
-static int find_grant_ptes(pte_t *pte, unsigned long addr, void *data)
+static int find_grant_ptes(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	struct gntdev_grant_map *map = data;
 	unsigned int pgnr = (addr - map->pages_vm_start) >> PAGE_SHIFT;
diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index 7cfc28f1bb86f..e724cc053e264 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -1658,7 +1658,7 @@ static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
  * on a per pfn/pte basis. Mapping calls that fail with ENOENT
  * can be then retried until success.
  */
-static int is_mapped_fn(pte_t *pte, unsigned long addr, void *data)
+static int is_mapped_fn(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	return pte_none(ptep_get(pte)) ? 0 : -EBUSY;
 }
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 27682cb5e58ab..387f97a555594 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -749,7 +749,7 @@ int xenbus_unmap_ring_vfree(struct xenbus_device *dev, void *vaddr)
 EXPORT_SYMBOL_GPL(xenbus_unmap_ring_vfree);
 
 #ifdef CONFIG_XEN_PV
-static int map_ring_apply(pte_t *pte, unsigned long addr, void *data)
+static int map_ring_apply(hw_pte_t *pte, unsigned long addr, void *data)
 {
 	struct map_ring_valloc *info = data;
 
diff --git a/drivers/xen/xlate_mmu.c b/drivers/xen/xlate_mmu.c
index 8efd7b55223fb..d7244f9f9a545 100644
--- a/drivers/xen/xlate_mmu.c
+++ b/drivers/xen/xlate_mmu.c
@@ -93,7 +93,7 @@ static void setup_hparams(unsigned long gfn, void *data)
 	info->fgfn++;
 }
 
-static int remap_pte_fn(pte_t *ptep, unsigned long addr, void *data)
+static int remap_pte_fn(hw_pte_t *ptep, unsigned long addr, void *data)
 {
 	struct remap_data *info = data;
 	struct page *page = info->pages[info->index++];
@@ -269,7 +269,7 @@ struct remap_pfn {
 	unsigned long i;
 };
 
-static int remap_pfn_fn(pte_t *ptep, unsigned long addr, void *data)
+static int remap_pfn_fn(hw_pte_t *ptep, unsigned long addr, void *data)
 {
 	struct remap_pfn *r = data;
 	struct page *page = r->pages[r->i];
-- 
2.47.3


