Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 704BCC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69DFC6B00B8; Thu,  3 Sep 2026 06:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 675C96B00BF; Thu,  3 Sep 2026 06:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58BE76B00C1; Thu,  3 Sep 2026 06:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEE26B00B8
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:31:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89764C048A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:31:08 +0000 (UTC)
X-FDA: 85172083416.13.168685E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id C6A7D100007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:31:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aEI5eI1Z;
	spf=pass (imf05.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788431467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLTSzulnCarGYZsfiK6VZepBPuGvEEqlR3S5HBAbRdE=;
	b=oem1zK/m/kcNIPyZj/48DdEhMb5sx2v2G0DEUN3Sbuh45et1hTjnqXxbocur++1k/dmgFi
	+zA/M0AZP7C0Sb/o31pedDGk+Gz84EOwS/FZ8xPOBomD1XsZFWnchC3aFU245UwNqGE9dX
	JEYXDPOh9MpIdeqHuQb2PbhInxIrCX4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788431467;
	b=R+TgLQ1Nim9F7UyBLfWzXeCmkpXuWn5xm1AstVzGz3kYWMHYki7OaAmV8Jbb08CPP5KYjO
	noOAab4Yd6rd9MyH1GG4aVcinLLP+iaD6jKwmJWvgxwX1isS9OTV/pZu+Co5CuivVhM8P3
	ArKWWOufuQkQOa2/+gOYeJXgFEtxAsA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aEI5eI1Z;
	spf=pass (imf05.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22B9C1F37;
	Thu,  3 Sep 2026 03:31:02 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B04F83F673;
	Thu,  3 Sep 2026 03:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788431465; bh=iZ0UxDW+PGfZPY4n2x5quNoQFlhhWYff8wQolJj8CQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEI5eI1ZDdVq2m64EA9ImU65GZFhZiL0ZK/lLsHlinaxtNpnT2nFBXA1JkEFJ2dA5
	 GAImWCHFC6p4QBtqqRBlk66RPeHRj2Ei0OGOPqGAPPTqssaugxDn76YWiAfBhwdKz2
	 oxnCSs2C9wVP4R71Kj0L4+hylcBhUUG7uFZhGTMI=
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
Subject: [PATCH v2 2/8] mm: rename pointers to software PTE values as ptentp
Date: Thu,  3 Sep 2026 11:29:54 +0100
Message-ID: <20260903103002.1091859-3-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903103002.1091859-1-usama.anjum@arm.com>
References: <20260903103002.1091859-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C6A7D100007
X-Stat-Signature: h8gt3y6pa6zze8rf8ybbt8uzn6g9ouhp
X-HE-Tag: 1788431466-443827
X-HE-Meta: U2FsdGVkX1/cBc61er0QVO2b/JWmyP55TcTPXsh7w5Luniyy6VMBN1UEmRDjwVIcgXkzmNkUYc/QHnjYW2W39WpiSqrGiiBauHdZIXT1sUzXf3j0ZfTyqNjDaLIDBigNvzIIhyOpcq72UN4B75RdLiNmStxKIpdcFE601NCpmySkKYsGCQYJ8sOnk3g464wpVuWJ7TyL2fWPS3qOe81jvVnKDHDMDAQow7rnJDK0VHF2tM9gzI+Phem5h6qHeteHH/AgBF2wevhggGU+VdPZFl3RRXMHGzpWMZENCqs/fbeDpH81BQgtmjvnuK7bwYoLSGAkERToq+u8Ql/1r4Yi8TJJkwSFBXHhCYofgjOGIIobCOLPPTNs+HocnDjLUFaTWjb8832aUedQGPCCh8I0MvFais1YwMw+t3dVCUg2FpCefDNJd0vwOjlsB420qb8NmDBonm6epYPPvZrRnJSFUiSh2khPc0zoWHAmXqzrmLk3MNfI+C04UR4ITAUGBnMDzwsyzlyO3Co0yCQsT/wNnnkuD1rLk9lxS2K920XFqZF62OBhBrAedWhmXy62+986DNwsFcoisYdGwqQjrtReHNNud0GX780S38+ivDZaqgL/mtQHvPdPFWwuBXKXiIZaxy1Pg5ET4kwUHnCVKXYfrJtnEMvFlDXBQ96Qzat5fmyY3lLfBauNryeY0Gjhl8cepVeUupJK2B7inQyOPPMT4aU5TpZojZQs3RvMf+FDwPd1UpjSiMFVCOqxKxrkb4I4sMt4QrOlnJfLyXDLQGabMjAQMIL+BlKYNp1Mbebnf3dXGv6FbBh9ulI5iU2cuCoFsjwcTpqY7n6on2txo/mdT56HFix+nTlFL6klusVxaJtc7qFcUyowg3MrFUuHYPvzShFKByPf97ZsHNdScusewQghck8Reu0u87u/gzCFoV/s4zjVzt+ECmsitCx8NnfGSs75vTVPkhb88JIcTjE
 BizfmGRb
 4sejyRIHu9axxHWwZ6MSEvVexPOTI/FMx2ETwW9shu6wLOcA1KIrpOzYc5kJWKa7Y2E2G07EvSGVJjSc3BbzuNp03mzsOUgeia8YMESsSdfU51WXZtihOF5t7QSFkIn2UufaNerOBCdyIZ0q6wyHww474jJMwm1mp4SEkyuCVtijyahfov3RoFBT5idL3c9qjTns8leJvaS1Tri8wMKMISaXtuMwTswB588cfsY7kDqS5YyrAnIcN2mk7qruQfVlXFLKL1sCGFXuAgguzGAAwtkr8Hg3atNj88e1cYgJViLRLsagQYyUI/X/xECdghW8jJTXZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some interfaces use pte_t * for a software PTE value rather than for an
entry stored in a PTE table. These pointers must remain pte_t * when
pointers to PTE table storage are converted to hw_pte_t *.

Rename these parameters in the install_pte callback,
write_protect_page(), and guard_install_set_pte() to ptentp. The later
Coccinelle conversion skips pointers named ptentp, allowing it to convert
the remaining PTE table pointers without changing these interfaces.

Some functions already use ptentp for such pointers, including:
- madvise_folio_pte_batch()
- folio_pte_batch_flags()
No need to rename them.

This patch only renames parameters and makes no functional change.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Rewrite the subject and description to distinguish software PTE
  values from PTE table storage.

Changes since RFC v1:
- Update the description for the architecture opt-in conversion.
---
 include/linux/pagewalk.h | 2 +-
 mm/ksm.c                 | 4 ++--
 mm/madvise.c             | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index b41d7265c01bc..c34d826c5e4a2 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -89,7 +89,7 @@ struct mm_walk_ops {
 		       struct mm_walk *walk);
 	void (*post_vma)(struct mm_walk *walk);
 	int (*install_pte)(unsigned long addr, unsigned long next,
-			   pte_t *ptep, struct mm_walk *walk);
+			   pte_t *ptentp, struct mm_walk *walk);
 	enum page_walk_lock walk_lock;
 };
 
diff --git a/mm/ksm.c b/mm/ksm.c
index 624f37975e129..2a4f19fe0f696 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1292,7 +1292,7 @@ static u32 calc_checksum(struct page *page)
 }
 
 static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
-			      pte_t *orig_pte)
+			      pte_t *ptentp)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, 0, 0);
@@ -1371,7 +1371,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
 
 		set_pte_at(mm, pvmw.address, pvmw.pte, entry);
 	}
-	*orig_pte = entry;
+	*ptentp = entry;
 	err = 0;
 
 out_unlock:
diff --git a/mm/madvise.c b/mm/madvise.c
index 73c2901b9adbf..dd75a673e108f 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1113,12 +1113,12 @@ static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
 }
 
 static int guard_install_set_pte(unsigned long addr, unsigned long next,
-				 pte_t *ptep, struct mm_walk *walk)
+				 pte_t *ptentp, struct mm_walk *walk)
 {
 	unsigned long *nr_pages = (unsigned long *)walk->private;
 
 	/* Simply install a PTE marker, this causes segfault on access. */
-	*ptep = make_pte_marker(PTE_MARKER_GUARD);
+	*ptentp = make_pte_marker(PTE_MARKER_GUARD);
 	(*nr_pages)++;
 
 	return 0;
-- 
2.47.3


