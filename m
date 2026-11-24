Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E0BF606A6AC
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J/2Gr8yD
Received: by kanga.kvack.org (Postfix)
	id 433BB6B07D5; Tue, 24 Nov 2026 12:08:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4094B6B07D7; Tue, 24 Nov 2026 12:08:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320A76B07D8; Tue, 24 Nov 2026 12:08:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06B846B07D5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:08:44 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16EE640C8A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:08:44 +0000 (UTC)
X-FDA: 85470646968.01.5167FD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4AF0AC0011
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:08:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J/2Gr8yD";
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795540122;
	b=BxVtCC08bjrCZlp5vlQiGpvyfMEKyUuqhejw+a4l4C220LoduoqSX+nH2LCpDJ3R7jpro7
	Ho6m7lJ5LG3HOAtPNreuYzdDR8SbmaN8GNTW4kaotHhY+kcsFfHqggMntca8ii5AqKuHzm
	DOj2R18Ohwze1Wlbx6FQCoXtCccahNI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795540122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=djZgOn9VBYR+Q9AtYg7HKx7q4q8fX2B7R8qd2HdvUdc=;
	b=wBsysPCIOfbSuZS2+EcF5XQeEewhnL2EXknGq/6kdYtRw838+jesC/Mutvj+I4xeMVwTVv
	GTJ8Tk5bXTHNEuA4qBReZOrY3wTlcA2g4e4i+ooJimSloZ/ArpQLWcsyKftw90JgV0m9FU
	EpfP8hw4n6Uy6RIobl/nXEM3MpCAEM8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="J/2Gr8yD";
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 38D5A457D3;
	Tue, 24 Nov 2026 17:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AE71F0156C;
	Tue, 24 Nov 2026 17:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795540120;
	bh=djZgOn9VBYR+Q9AtYg7HKx7q4q8fX2B7R8qd2HdvUdc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=J/2Gr8yDo5beGxFwzhPsmkWc4NBWJPrU08XjePkaBs9Hev/Kfag2cTQiiupKETbne
	 sK2Hk/HEfq342+hSoO20KxjzaHGGZtCtKDFx2njJXQxKLWo6eb9o/MNZai5TGz+zVG
	 NXxD4OKJooIbeXWwkqP28zJ2Z/0ErhXpF/LqtsPTqg1djJDTpDfSsDCEVovFG8KRu5
	 E7PO2GK8pYj2ygIZuW4q1HzpQ4o64Zxe8BwmSIG28UAnMis7Euu8fzZJH8pa6PpWRf
	 kdm1dFW3slkoOoxAmG+5AARVEl41dtLS/gSImzOMtJ7LklBNoaMy9QgBaOH+bZLxKo
	 Uv/E9pi2T3Rfg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 17:07:53 +0000
Subject: [PATCH v2 01/11] mm/filemap: convert fault and readahead logic to
 use vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-vma-flags-v2-1-bf3fade93064@kernel.org>
References: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
In-Reply-To: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4980; i=ljs@kernel.org;
 h=from:subject:message-id; bh=WlizbylF+gqp9MHD4jo2N4UTW7koXv3iwuSfjXWzIJY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZj+R+ZRBYYpfZ891l0lXZSTubBRJj/6yfoe0q8GxNL
 MM/b9OajlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEyk+CkjwyqrhY71jw3YvxTv
 Oimnds3z7cSlRe11WT+3bLmbJaQ+05KRYbXBe7Ofjzf0Wk73y7byfqtX6nuhzHpLH9e+C5G5it8
 nMwEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4AF0AC0011
X-Stat-Signature: 5y5hnw34gztcmuq9uxgnftbub3r61zqp
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795540122-198337
X-HE-Meta: U2FsdGVkX190E/yjqycGKGbqaYw/DKDWpPxwkUbDhOpO4St51J6HJiQ2zDMC6iKVZUjXNOwqA6ss03XTBUHdV22oGoOumrMMDfFMwM/5EbpJ3frvfjylsZU8VIlcbTCOVjpxsRJmMeG2TAyRnkWm6lvKwIeK8JxzscupzWKdCGkJD9BOUZ8ylySLcm7N17wZuaQokTtdvuiq81dmldDxZqywXagfPNP5NvpC247ah9sH46j1P2+gMA201oeyG6MIj9vuYdwsp6Ei5F/eSEBA1tdiYPvd7851DClvh02BsoJfOCrxCjs3Uf0JKl7sbBp0hxSR+G7NDGgbwRMJDrhv7tpowt/IUVzvXdhSj+VD6Y7qxJZwT7Xi86xKPWNeOTwmY98PDM+8JoTVcTSmqRWXC4JC0G9NzJvfC/lpHtXbiBNk3ngjwMGUG7VS72VTtzsmmb2MeL4peEAiwoYfxp1uIakFvdkaon+HNwIcqWdFr6iPdsh/nGyPIZTf6KOhb45zvC0FFaWJSBF3xH3E/lRfmyVVDNY1mGWiyc07z7VcATaZrmXeLlQp4n1EYW2nnUXO8fCiboZNTVe/2OLXQHdalM3ldYOApWvhZIDgTUnu2kc7PC4cJcif7hPfd6s6aq0moMRzNLz8bHi57ekSQdYtHdSJrnRpkdNUK0ndi9dflYOtKazRJRtCbVhnMQkk1uDGSavCYu3s4EAoXlJubL5T0JQ08aX3uS6aWhCF6zsrQzdaKR7qhBqijY6l+Mlliw+rjJSuHIyntPnqJXa3idO8okMw453TJcSMryGSyrvUjqGpLG7sA6Vio4Byn+lzSjvqqIlWokXE2TC7hNtEj6HkRtAJ3MWP6kd5/nUTpeGQNLQJkfYrqXIZ/Zkt3oURUnAt3UhOBL6DTwskrighnroEsKGm3Baovptnq0FAEaEOfRp3O0HmFW8PFEN9yLgmNAKE23ko5Uy08jM4L4t9TsP
 Ge/tcr7w
 /W9rMb4ulP15BfeeJe81JNNy9eR64JOtt6/06qwkN1wQMTgliLGuF2itracl3uPVFlIRG5BSfyE92nUdmfedxpkL6ufniiV14MIZ+vqjA2XmQpEv86yHjWfVRV2aRWEvxUnv1GbvgIPTtEGxaIbojIHtLcLO7dC5qRFrcbwH8QJ13AwKQdgFx3Ppjk903qxnb/6nxUKi7dsJd6JuF4SyGRyVMt6Tf0ICjl3vOn6K2WmIr4gsLMVMH7JRgOXMXgpVy2hPPuGNQ0s4vJ736J1gTzWmS0FdLL334tXzwrSuOFFUB95zrsqejr9mg3I4Ty+yum9iPIIFRdW9hntbmiszMVoynIov6q1lkvCWFEcnCGVmc5S4D/Ns/XhHDWvr5Y2iHhbUm0DhoQSqPpDeqiJo9gYyHm72rbbENhmnJEapthgWfgx8QBiAAYLlOB8wHNn1di+GkYW4n+3Zto9SlO70cvb/ghNCoER3F/9IXALKJPYt4RZptbQ20msORV7o5BVWk2tcLdNDSfWMbFPAAsj9oya+gz8m6W0pvFcQp8oixmS0PssEkY9V+ByjRTJ+EdDCKaUAHmXn/4cAEKcqcCXvppp5Muw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
file fault and mmap readahead logic.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/filemap.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index acf5e562b732..ce720c4c55f0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3359,13 +3359,14 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	struct address_space *mapping = file->f_mapping;
 	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
 	struct file *fpin = NULL;
-	vm_flags_t vm_flags = vmf->vma->vm_flags;
+	struct vm_area_struct *vma = vmf->vma;
 	bool force_thp_readahead = false;
 	unsigned int thp_order = 0;
 	unsigned short mmap_miss;
 
 	/* Use the readahead code, even if readahead is disabled */
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    vma_test(vma, VMA_HUGEPAGE_BIT)) {
 		/*
 		 * Cap max THP order at 2MB: this is the common PMD-sized
 		 * hugepage size, and it avoids memory pressure from very
@@ -3385,20 +3386,21 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		 * If we don't want any read-ahead, don't bother.
 		 * VM_EXEC case below is already intended for random access.
 		 */
-		if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
+		if (vma_test(vma, VMA_RAND_READ_BIT) &&
+		    !vma_test(vma, VMA_EXEC_BIT))
 			return fpin;
 
 		if (!ra->ra_pages)
 			return fpin;
 
-		if (vm_flags & VM_SEQ_READ) {
+		if (vma_test(vma, VMA_SEQ_READ_BIT)) {
 			fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 			page_cache_sync_ra(&ractl, ra->ra_pages);
 			return fpin;
 		}
 	}
 
-	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {
+	if (!vma_test_any(vma, VMA_SEQ_READ_BIT, VMA_EXEC_BIT)) {
 		/* Avoid banging the cache line if not needed */
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss < MMAP_LOTSAMISS * 10)
@@ -3414,6 +3416,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 
 	if (force_thp_readahead) {
 		unsigned long folio_nr_pages = 1UL << thp_order;
+		const bool random_read = vma_test(vma, VMA_RAND_READ_BIT);
 
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		ractl._index &= ~(folio_nr_pages - 1);
@@ -3422,7 +3425,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		 * Fetch two folios so we get the chance to actually
 		 * readahead, unless we've been told not to.
 		 */
-		if (!(vm_flags & VM_RAND_READ))
+		if (!random_read)
 			ra->size *= 2;
 		ra->async_size = folio_nr_pages;
 		ra->order = thp_order;
@@ -3430,7 +3433,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		return fpin;
 	}
 
-	if (vm_flags & VM_EXEC) {
+	if (vma_test(vma, VMA_EXEC_BIT)) {
 		/*
 		 * Allow arch to request a preferred minimum folio order for
 		 * executable memory. This can often be beneficial to
@@ -3442,7 +3445,6 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		 * pad that might exist between sections, which would be a waste
 		 * of memory.
 		 */
-		struct vm_area_struct *vma = vmf->vma;
 		const unsigned long start = vma_start_pgoff(vma);
 		const unsigned long end = vma_end_pgoff(vma);
 		unsigned long ra_end;
@@ -3485,7 +3487,7 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 	unsigned short mmap_miss;
 
 	/* If we don't want any read-ahead, don't bother */
-	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
+	if (vma_test(vmf->vma, VMA_RAND_READ_BIT) || !ra->ra_pages)
 		return fpin;
 
 	/*
@@ -3499,7 +3501,7 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 	 * keep the counter symmetric.
 	 */
 	if (likely(!folio_test_locked(folio)) &&
-	    !(vmf->vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
+	    !vma_test_any(vmf->vma, VMA_SEQ_READ_BIT, VMA_EXEC_BIT)) {
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss)
 			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
@@ -3532,7 +3534,7 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
 	 * scenarios. Recheck the PTE without PT lock firstly, thereby reducing
 	 * the number of times we hold PT lock.
 	 */
-	if (!(vma->vm_flags & VM_LOCKED))
+	if (!vma_test(vma, VMA_LOCKED_BIT))
 		return 0;
 
 	if (!(vmf->flags & FAULT_FLAG_ORIG_PTE_VALID))
@@ -4018,7 +4020,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		if ((map_ret & VM_FAULT_NOPAGE) &&
 		    !(vmf->flags & FAULT_FLAG_TRIED) &&
 		    !folio_test_workingset(folio) &&
-		    !(vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
+		    !vma_test_any(vma, VMA_SEQ_READ_BIT, VMA_EXEC_BIT)) {
 			unsigned short mmap_miss;
 
 			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);

-- 
2.56.1


