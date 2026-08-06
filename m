Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A67C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B456B00BC; Thu,  6 Aug 2026 04:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF27D6B00BE; Thu,  6 Aug 2026 04:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08BB6B00BF; Thu,  6 Aug 2026 04:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 720506B00BC
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:41:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9452CA06E3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:41:08 +0000 (UTC)
X-FDA: 85070199816.12.33AD2FF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id E2A1D120002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:41:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TTBSkLer;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIu4VrsiIHeKzpwSk8j1zdkl2YrmppxP+oUiSa63m4c=;
	b=PzQWGBiOTLMMRL+qD0vGtniPdJVRt4ZRH5s8ozstBpO+Wn02EpFqKqou7gkZy47mFlzbs6
	1vkOA47+5NlmVLrfmX8borQyM+YejdvOCPZB2A4J8/VMxXrpYBRKZtPt8RO/ztC36PoHz4
	yhXdZOod+rv+DxRAY/W+yKdrHrmG5NQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TTBSkLer;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005667;
	b=xlCGVP7Tf5EqG3A3CvsxyAHHudUgUtTopH8JVvKk5gKloJioFqs/x9672547ZDlTSsJQ4H
	YMVv//L/RgaEZD64bi75Azjf6mUeFyTkxsrR3QO/AF7sFG3QRuvhgnHcZ91RuEI820t0+6
	pb5kgFv8y2smHjNe8JMjoKBNwByZaQU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34C59153B;
	Thu,  6 Aug 2026 01:41:02 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7CABF3F632;
	Thu,  6 Aug 2026 01:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786005666; bh=26js+M9zWrHNC4a3AjcYSrQ4VRwzJZBtm9+Mxf/tKbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTBSkLercTTP8PzXx2W54PajQtmr3ocTbHrCDjoVYDyhLdl97U7CcPQ3qilKSBkf9
	 vIh9ep96aTHrl1x02wMw5yGa/VgSgdxL9PNbjwHpeKiFJfhkPl82/MnNvLvZO9B0+j
	 c9NuO4Hhw/STBkgcZsI3sprKusZaJGcpuNEKybDo=
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
Subject: [PATCH 9/9] xen: use hw_pte_t for PTE range callbacks
Date: Thu,  6 Aug 2026 09:38:47 +0100
Message-ID: <20260806083926.1807279-10-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806083926.1807279-1-usama.anjum@arm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: jpbhg6twozfcx7qx9a3owdi6ynihdisx
X-Rspamd-Queue-Id: E2A1D120002
X-HE-Tag: 1786005666-612131
X-HE-Meta: U2FsdGVkX18VUz0umtKzQWdcxqIjGHh66LfrV/TS8rGvJ2mUpYhcR4NfL313kadZO/amqSXo5L8RGmAxWIrOsCgXQkCmsvpS0HtA85DFEAQopEVezRqI0GmnZSJ8pDIfDa40thmaw5RWPW166ZRGYD1I3C/AhLUgsTPI4O8UCEOdcH+HJRoZZ9HjIdHvawMpmp8LLDGA7PPZs2Foj5SxvyROuZpBm5gxTsixd+TwjR6LVbe/NsetziND10LXEER+swCUl/bCPVXP+VlvvFk5wLt+R37+AXXr3zLV0ODSuqJ2pyqrzrlQjejrINzjjcS7Op+S+H7UX0/ZkmohZqiljCzWGO734JK87s/K+ugjTmbN/+rizdIF6qga+Ocjz57BxgCeCJfvTlf4JSodhlO3St0gNDpOYUIuPXNQemv6o+KkdldurPKzqLZHu8s5XRviqvvPDR0lf5qtbBrx2bd1ckKiH95X3JZA3OuhgwPWPdwgYBoqJ5IQWMWYbtZdxl9FmYMgx1RG3/55gXpSV71pVAKdTaxkWRqSszGGdKC05SXxJPPlF+TA1LoNBfvGv/D1yTkWovwKU5Lvlp1RXmoAHBXsIQQ+xEGF6Kmzi6D3nSU9ZUrB4HKxZDCxPvxXpJO1V3L/7nKXkMUjXrjxz5IrZiZC4DhkcRhxzlJsl1r5n5PP9R1amXmdOskACxvz+0Zgl6mEYUIPp61vW7UJQsTTTbp3sMrXSih6SVKIpKF6fgt+5Zu/6/Y49hdFw/UNySeDs/VCmtemP8K2i7Dfl8oitQuULc5pmq6i8DT8XHHdvI764ybVa2SNJDXYEa48jBp1NzeeQPzCwpLg3C/EtnZjNugFTX4eWmQWv6OX6FxL5m55Y4Bz7EfdxgXW/T/BBAAnjfEs06IL9T2j/K2kV652PQbL2PlDyrvpdsE3Dc8NwPaTyZDt+4fwPADR6U9+L6a+n4H30QPjXT530Zh1zY7
 njZftuOy
 RlAUrfj7Wvyx4BEvmW3BpONF/64M5+imB7tF3TQQc1DUbEGbU1zTkKgknEBPcRKWAkIuWlhRGGie0ipBErUTdqbY4alFkuZXIku0PcNVeUq6nu5JMbLpSQuPn2chwo1G4w69xQdqKMhX71UJ02wpZ1atSba5mMBn7bmrwrW1dJ23TEMFUy0D3LDHP4lWf1YlL248dUck0LDQO+4DK7hQjKVHj6dec5dJwCWVE3S4ZXnoU0CfckU6A+3sG1mqUBR6t31QfVmLSJVdcaIsiarBqtAq7E33GxeAdgKBiqn/NW4WRlYlHFekJi0WFZjMc7zy9NWmaK3jtmvRZM6cqUdEXwOqAyuaCRaMZdSHA4NQ4Mapugq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generic PTE range and remapping helpers now pass pointers to PTE table
storage as hw_pte_t *. Update the Xen callbacks to match those interfaces.

Keep logical PTE values as pte_t and continue to access them through the
existing PTE helpers. This is required when Xen is built for an
architecture that selects the distinct hw_pte_t wrapper.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
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
index 725a49a0eee72..b4a487dcc9ecb 100644
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


