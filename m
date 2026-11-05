Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D97606A336
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YlMc4Yav
Received: by kanga.kvack.org (Postfix)
	id 81BA16B05B5; Thu,  5 Nov 2026 16:31:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2EE6B05B6; Thu,  5 Nov 2026 16:31:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708E46B05B7; Thu,  5 Nov 2026 16:31:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0B96B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:31:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D00DB40C6F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:31:58 +0000 (UTC)
X-FDA: 85402363116.24.4E94EBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 112491A000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:31:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlMc4Yav;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914317;
	b=MPMZ0fKvhkYMI7zcrhiNIut+liD8I/XoZw+d5b4XgbGGBDO7gLM0c1P/Efmn/gJKjbKaIu
	QSW/8JAFoCw4yhWWPe7dZTeKm4rfT6z8eI3lcAN90MWAyKdZ14c+wNV77K2BSsg6z/DsX5
	yzYRTUIaavJMnF903kQwwapXPkQ+PY8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlMc4Yav;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HChmTqD3l76D4xTwaDId89Adh4XK1U9R7SwaL6QQSiA=;
	b=TsvLllKeqVohzHLaEUZAafHpRwcqRvlY6FCJsFS6LEwQ4XL6c/QUIz3oFpOncpBlH+4DDh
	uvdKmtLSWcvdH2DUgggESG+70eEhywAGqufbUBZmmL8+xu+MUMqw/J+roc3WwE99Xzfftt
	9GD1MMSPquslpr+oiOIGYFxQ7glFhYc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5215D601D5;
	Thu,  5 Nov 2026 21:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C30E1F008A2;
	Thu,  5 Nov 2026 21:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914316;
	bh=HChmTqD3l76D4xTwaDId89Adh4XK1U9R7SwaL6QQSiA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YlMc4YavmcnzgGqbTg8xy48BhuWYv3UOv9e7rnmekOka0vxC7n1uK3Z1d/ertyht4
	 gCAvHw7gGAQQROPopfRHJgoy8erMLDNpeAUwUkkbW6t0RvoH48kScoLYMbrr7WpxNt
	 HxBkoPoow43LyAF0PNefCHawtW6nY6W2vaF8YTFGm+K0GzQYI3z4CQ4GKTge3YbMig
	 n/jqvmxLm3mfdHdHzkKty6LwIjif+xouTG85uifDRCDzkMDa71N4mrbtT8dOCeT1yr
	 +VCS8ipUCMfQC4Pu2gDJhnDr04M5LDYAZziTDD57o3hVj3oObrutNSWPu8zZA/B6Z1
	 iHElNiOHvDCnA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:30:52 +0000
Subject: [PATCH 01/13] mm/gup: convert GUP code to use vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-late-2026-vma-flags-v1-1-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
In-Reply-To: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
 David Rientjes <rientjes@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, damon@lists.linux.dev, 
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5850; i=ljs@kernel.org;
 h=from:subject:message-id; bh=bW54hq6rUX5mn84GnflVBnxa46MVVq7so69BlwTkM0U=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLefF16/eGzghS9c2a+/VuKG9T/c/1zfuM/o+P/mkbeg
 LgD/3/e6ihlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEmi8wMpyRDTLtTTnO0LZo
 /YpNb7yb13n0pyWu8LqqtjaoqkWbwZmR4d3GRbvaD8eunFR2tC1T5du5REvjsF4+70n2No+9xV2
 6mAE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: ui5gkdjjoxmxqmc5ra4t47m1b5o1bdk5
X-Rspamd-Queue-Id: 112491A000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793914316-10705
X-HE-Meta: U2FsdGVkX18boBJh0BfYxH3vnaLWJ2laSk0XjRfe/zC27GgCzc1bcvEVso94c/w4gCYAo6FZP0usY0U3qaJWvl5gTcWeUtHuPtbYPeKu9qH+IMhxQtOYyJCmCpKCdZj2gjeIu8gRbrtiEm4z6QMLZVItDp+ZZSntqH4jsqhdNsv5nxS79FzMXsBpzjtI2x5vkJrUsI1o13EtJfI/DAGty5ZyTmltOA5rn5j6OH1OpcOjMdwahLaqNiGd6SrAuwfNHrVvL6IQowu9DB0ZmoW0z5S4QyQoQfbXsPDAoeEOU9DI0MDmG8P/uLCttv7SXRHCAkOeMn6AdVpyRSRB7Y4ZRHT48tcJLu+XWrdmji64apNJGTQF+wDBIGTtwMObnq2RWZkdd2AL9YN/hIQNqPIioa97ahGmu6N52MafUqznNjR4Ly7dwIjfSkOKliQRis+OykEwvVwZ2gLDNLIBBCJzZYvbVS1eq/Z2SHmN2LT+dDiIhVMHYkH4kJRNDmJoPto+xxfLOp51pukR3uwg3NzES1WBhvVS/mvXH0k1f1mvz+yOz0AhqJTabXEaqfrjx8LOogsyEB9l11IlvEp0PyyBhXjiWpkCW+X1n2xs9g7thXR+8d7/ouylU1bphbPyYomjBDosO7XGCgtR038gPJFS8vvs5Rzwm0eVwcCqESF8f4WD5OuXS6wFki5fDWNyddVoy1mzDZWUudVFSdv0aHy+Gvk2J2/lkAUQtxiqVbP/dOtDfaZdVJ5BhFmWFwAaTdRyQghaoPmK4aaQKwF5wLagFmPa2LlbtktuanmP0Yh89DtFpiYLGfTMj6Vm064JVOtog+V9LoJ/m8EIng183z1712pcYvWjOIYW1fFTiA7gAGaQuM2bXZRTDqzh3ij7S9+JdsV9EHfPaGAce5nhsOWbc9tMCO2pKRuEObeS8dtVLwBFERXhDzlmTHZZwr1jDIxeg4vbFRcBoXJT9RQswk5
 1OO6qTU9
 ufCTDLmU5fRE3BCndHEmUOBMH8BA8EXqkz4Dao6ggymGxgi8cYfxgmw2Y2UjB1GjFpvS19M550osDs1lhzDZRUKIRdkgeYAV02v8B9U4bfKKT5AKHyLb0doc/1J4ccpdw4BPXqRacA4ffcU/EnhZkGHPKi/8ljY26CX7eQs7m7uOawzLJfQDL3ub/ZZ8iPFiEo0hoIfCLADSK4LOE0vr6PA5lnBkjdRxaXxRtfjBob0K9peYcl1yT+Ex4iLsfMDhU6epFiz/ziAv3MVPgGhEDN2sdHlXf1GsDO4VgVC9gMg6BsgN59VwhDKN/e/NYF60DBYXjgdOH3X+T5+1pb/wkD+dMY06jWGowpYWz3Jc3lYdMQmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values
throughout the GUP logic, both for the MMU and nommu variants.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/gup.c | 45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 7d43ce717b24..dc232117b1ce 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -590,15 +590,15 @@ static inline bool can_follow_write_common(struct page *page,
 		return false;
 
 	/* But FOLL_FORCE has no effect on shared mappings */
-	if (vma->vm_flags & (VM_MAYSHARE | VM_SHARED))
+	if (vma_test_any(vma, VMA_MAYSHARE_BIT, VMA_SHARED_BIT))
 		return false;
 
 	/* ... or read-only private ones */
-	if (!(vma->vm_flags & VM_MAYWRITE))
+	if (!vma_test(vma, VMA_MAYWRITE_BIT))
 		return false;
 
 	/* ... or already writable ones that just need to take a write fault */
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_test(vma, VMA_WRITE_BIT))
 		return false;
 
 	/*
@@ -1199,12 +1199,11 @@ static bool writable_file_mapping_allowed(struct vm_area_struct *vma,
 
 static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 {
-	vm_flags_t vm_flags = vma->vm_flags;
 	int write = (gup_flags & FOLL_WRITE);
 	int foreign = (gup_flags & FOLL_REMOTE);
 	bool vma_anon = vma_is_anonymous(vma);
 
-	if (vm_flags & (VM_IO | VM_PFNMAP))
+	if (vma_test_any(vma, VMA_IO_BIT, VMA_PFNMAP_BIT))
 		return -EFAULT;
 
 	if ((gup_flags & FOLL_ANON) && !vma_anon)
@@ -1224,7 +1223,8 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 		    !writable_file_mapping_allowed(vma, gup_flags))
 			return -EFAULT;
 
-		if (!(vm_flags & VM_WRITE) || (vm_flags & VM_SHADOW_STACK)) {
+		if (!vma_test(vma, VMA_WRITE_BIT) ||
+		    vma_test_single_mask(vma, VMA_SHADOW_STACK)) {
 			if (!(gup_flags & FOLL_FORCE))
 				return -EFAULT;
 			/*
@@ -1239,14 +1239,14 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 			if (!vma_is_cow_mapping(vma))
 				return -EFAULT;
 		}
-	} else if (!(vm_flags & VM_READ)) {
+	} else if (!vma_test(vma, VMA_READ_BIT)) {
 		if (!(gup_flags & FOLL_FORCE))
 			return -EFAULT;
 		/*
 		 * Is there actually any vma we can reach here which does not
 		 * have VM_MAYREAD set?
 		 */
-		if (!(vm_flags & VM_MAYREAD))
+		if (!vma_test(vma, VMA_MAYREAD_BIT))
 			return -EFAULT;
 	}
 	/*
@@ -1277,7 +1277,7 @@ static struct vm_area_struct *gup_vma_lookup(struct mm_struct *mm,
 		return vma;
 
 	/* Only warn for half-way relevant accesses */
-	if (!(vma->vm_flags & VM_GROWSDOWN))
+	if (!vma_test(vma, VMA_GROWSDOWN_BIT))
 		return NULL;
 	if (vma->vm_start - addr > 65536)
 		return NULL;
@@ -1514,9 +1514,8 @@ static bool vma_permits_fault(struct vm_area_struct *vma,
 {
 	bool write   = !!(fault_flags & FAULT_FLAG_WRITE);
 	bool foreign = !!(fault_flags & FAULT_FLAG_REMOTE);
-	vm_flags_t vm_flags = write ? VM_WRITE : VM_READ;
 
-	if (!(vm_flags & vma->vm_flags))
+	if (!vma_test(vma, write ? VMA_WRITE_BIT : VMA_READ_BIT))
 		return false;
 
 	/*
@@ -1829,7 +1828,7 @@ long populate_vma_page_range(struct vm_area_struct *vma,
 	 * Rightly or wrongly, the VM_LOCKONFAULT case has never used
 	 * faultin_page() to break COW, so it has no work to do here.
 	 */
-	if (vma->vm_flags & VM_LOCKONFAULT)
+	if (vma_test(vma, VMA_LOCKONFAULT_BIT))
 		return nr_pages;
 
 	/* ... similarly, we've never faulted in PROT_NONE pages */
@@ -1849,7 +1848,7 @@ long populate_vma_page_range(struct vm_area_struct *vma,
 	 * Otherwise, do a read fault, and use FOLL_FORCE in case it's not
 	 * readable (ie write-only or executable).
 	 */
-	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
+	if (vma_test(vma, VMA_WRITE_BIT) && !vma_test(vma, VMA_SHARED_BIT))
 		gup_flags |= FOLL_WRITE;
 	else
 		gup_flags |= FOLL_FORCE;
@@ -1955,7 +1954,7 @@ int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 		 * range with the first VMA. Also, skip undesirable VMA types.
 		 */
 		nend = min(end, vma->vm_end);
-		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+		if (vma_test_any(vma, VMA_IO_BIT, VMA_PFNMAP_BIT))
 			continue;
 		if (nstart < vma->vm_start)
 			nstart = vma->vm_start;
@@ -1986,7 +1985,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 {
 	struct vm_area_struct *vma;
 	bool must_unlock = false;
-	vm_flags_t vm_flags;
+	vma_flags_t vma_flags;
 	int ret, err = -EFAULT;
 	long i;
 
@@ -2011,10 +2010,14 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 	/* calculate required read or write permissions.
 	 * If FOLL_FORCE is set, we only require the "MAY" flags.
 	 */
-	vm_flags  = (foll_flags & FOLL_WRITE) ?
-			(VM_WRITE | VM_MAYWRITE) : (VM_READ | VM_MAYREAD);
-	vm_flags &= (foll_flags & FOLL_FORCE) ?
-			(VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
+	if (foll_flags & FOLL_WRITE)
+		vma_flags = mk_vma_flags(VMA_WRITE_BIT, VMA_MAYWRITE_BIT);
+	else
+		vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_MAYREAD_BIT);
+	if (foll_flags & FOLL_FORCE)
+		vma_flags_clear(&vma_flags, VMA_READ_BIT, VMA_WRITE_BIT);
+	else
+		vma_flags_clear(&vma_flags, VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT);
 
 	for (i = 0; i < nr_pages; i++) {
 		vma = find_vma(mm, start);
@@ -2022,8 +2025,8 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 			break;
 
 		/* protect what we can, including chardevs */
-		if ((vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
-		    !(vm_flags & vma->vm_flags))
+		if (vma_test_any(vma, VMA_IO_BIT, VMA_PFNMAP_BIT) ||
+		    !vma_test_any_mask(vma, vma_flags))
 			break;
 
 		if (pages) {

-- 
2.56.0


