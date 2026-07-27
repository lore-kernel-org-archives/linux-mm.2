Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E64EAC531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5C86B00AD; Mon, 27 Jul 2026 12:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EACCE6B00AF; Mon, 27 Jul 2026 12:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C5A6B00B0; Mon, 27 Jul 2026 12:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF196B00AD
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:49:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2ABA41C0026
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:49:17 +0000 (UTC)
X-FDA: 85035141954.07.11E4E00
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 89010180007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:49:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Lb/jyoKf";
	spf=pass (imf24.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHPeorp1zdnoJdhuJBuClNoQmKVDakXwSrFrOoFYv7g=;
	b=xQ5KfaWHpMK5nmgXfu5OvuxcwDv3kIZD6Qi89KDvbVFIjwd14dvIo8lqBSAI3EaXoaB2gW
	D63F13rBRWojLEPVGJuQIeEqcL7Yi1meTz0TUj2Q6ynDiHVUriWp86fXVnPXfJK6bee0ev
	h91Puwy9u+yfce/kBY97+kAwXOUSzFc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Lb/jyoKf";
	spf=pass (imf24.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170955;
	b=q9e6UeAb2UQZVkHKB+/CiLSB++FSWsrHCP0Kju2URduutAL5mYuLDXjLsCtJmidZHK8MGD
	yoopSoiPaEbgEfJy3cwtKnnpzhvFml98xWPRDSVKGNvG3EiAsNkNcXPuLGwbAsezjervbF
	cRmsJ761Tgv9TwgeKykGauSuS8DoLDk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD6F119F6;
	Mon, 27 Jul 2026 09:49:10 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 24B253F86F;
	Mon, 27 Jul 2026 09:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785170954; bh=V6zt/tVCRXmaxyFDjqVyIeLB8KQS6R6ktC8ishLU3Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lb/jyoKfMHEtn+EGInX+1ShDiDJE4SKeMR6pxvOnK3LevEvIfEqty1XGjueSJSBAs
	 G42AaQQj06YclcwbnNEF+ZIACcOyOe2ZtG+CAXJ1O24QpZxYlP92nB7MGKzzIYNXvf
	 GKb3saft/JW4/CWAMTUJrteRizHdBV+a50NOn1YA=
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
Subject: [PATCH RFC 11/11] xen: use hw_pte_t for PTE range callbacks
Date: Mon, 27 Jul 2026 17:47:02 +0100
Message-ID: <20260727164715.2866609-12-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727164715.2866609-1-usama.anjum@arm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 89010180007
X-Rspamd-Server: rspam01
X-Stat-Signature: dhuh5exigf5mcbz4749m17rrqtcg8xnk
X-HE-Tag: 1785170955-252515
X-HE-Meta: U2FsdGVkX19f7G+yudRO0ekOGOHz+rYrvbiL6JkOs2E3e8TWqGL3P4wqa8aETX3zyBKttVE5W8gzTTd77rc/hMoUIraiYGmcjpMMHF9d8vHRIyzUfEhRsTYRUwRfsisxEFh09Nx+GCQISAKX19BRtIb6cQrLfB51KJXq/nPkR6JUosVe5VTAk3AQXCScYiE4ZiaHGNiqmyPDEYcGTiEWRjpTw2h3Bi1AsbifpqZIJmswTMm73zH/TSSgXtI5R6y9UTOyis9Q2wEXQprwNMQv/94LI7BLiBRmPrmuONn/9QTxLby3dYB/gPzbPSkXY41nm8JCJ4LrE4rRFisg6CWDqFqmjQDb0H+xFFjyn+BxrMrWIC/QI+BU5NZhHRb9ZEDOaTW0WBqW/orpO3RcffOMFO6pKe06YwX663OO6+ybv6yTLwbfiRnA88lvDzidrfcqLh2RkF5UCnkv7sWQAaKgq7TVsC98n4MmwxRuHf3HtEy5LyVuqS72DfVcZA4SY1B9i54/S0kbWqTzvx4Mf2N97rTUijkJ2p0y0+2LUQdOYPYwiJKASjrGHYdJD/uPCOWVyRHnUKQixO5Mxl45GB4L3vLrrBKYO0k9u2+dvYYi8r2j7zWC+XzvQ1/MBSCvqLpNLQi8lb/1Tp+s4rLYzz9svmScZBJ96xuxhnI2HkW+M+P1uU+Fl/FanJZgJeW692CqnvLRcxxMGo1tppcuAbPXIZUoGVQgK92bFftmQrLXTxUhiyBcwFdA2Xd5faM+b8n+YX+ZLt57HyviHlGD8ZdZQ7qrY2wxxOwZruD2/bt0LoJwhifNKVUKoUufxay0mIsO8R7hk9AasE6lDdkORysQ4tSjfSQj3r+Awjq/9tOkIsR38B8UIWUuAb/SwHQsenV7vtBHwmcDVf31pN7TS0XCY6lKg6Do1emDA1tgumzII+SsjYS48SPYcivbtda+0Mx4FQO49AAWaZDpigLr/fS
 miFEMoJ1
 2J2lms2I53EQL4yuI2CANcsSCWnvCjUBYKBh3qqpNtbzVUVrK1wecaPuET7bolfvSsgew41mMaWZ5XwgC9Gr1NmiXB1bKm4tpTvEVVkyOfWrl1igbVzT5/0eh37RpU73+whtJBj3twbGrI+fnmW0MFhOkhwuv8XphIoBbJJyNu/jxbrPrmmlzjohhkas8LUSYg72oYLED+AGCmrwkrCsRR+jfqELl4545XtHQbeyWzr9OPPBFNKR++HgpvhsLwiQNIk6K/oGmbKlxTjng+IVWfCVug7lTiTly0+50O7sAOr3EX1NTx4L99MFLHieRnl+dFzqWOmcTRXryOTp9RxOEpMHojdUjMJOe9r1hhRdrmeVJk70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generic PTE range and remapping helpers now pass pointers to PTE table
storage as hw_pte_t *. Update the callbacks to match those interfaces.

Keep logical PTE values as pte_t and continue to access them through the
existing PTE helpers.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
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


