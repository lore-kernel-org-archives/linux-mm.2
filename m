Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E10CCCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 17:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A8C8E0005; Mon,  6 Oct 2025 13:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B598E0002; Mon,  6 Oct 2025 13:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B212A8E0005; Mon,  6 Oct 2025 13:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EDB48E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:51:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AFBA87BEB
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 17:51:25 +0000 (UTC)
X-FDA: 83968431330.10.5F6AFFC
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 72D28140011
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 17:51:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NAg+ao8U;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759773083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qleRauGEj+bb9sgaaA3graHFC3gh/W99qbG2F0J96jE=;
	b=Tn8G/ywhC43Set8Iq2h6LCel7to8xJckbnwQ0kB2QFP6wJrXPdVJzPmj1d9B2QeYAAYZDU
	8VXjV3kaEQM/omgKEWZP2HQ2YWEMGFp8CC9TUw5mfJcusHPGAF8tuvEINQ+ovudFuE55k2
	8ZJrO4Qz++ok8ba6+SUcbGH8dREB/+Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NAg+ao8U;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759773083; a=rsa-sha256;
	cv=none;
	b=v+7b1ePOOCVtUwz2gmrmAqKY2MgTJjaIt/D4E4jaiwihiNpEeudYVBqIaIQlWvjpXRKbdg
	6iE8FS1kyqM+ceVRQqHRTSvIkK08/CN8vpbNJKUrUvfgRkiihw8TkIIrPVsKPCcoufV82E
	5gd6w9/A/vk7wJasJgXKt+m1xFLWU4Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759773081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qleRauGEj+bb9sgaaA3graHFC3gh/W99qbG2F0J96jE=;
	b=NAg+ao8U/6KBCPsnfzZcwwdqcMtsZXjQyFTJxdE789iThOvflZWEQU3w522WKFskq38XKO
	J0Hi/whc6xsJ9GIbFJUnywtlB+zqXnGhEQU5665RzuZZSAw6U85NOhf/OGZwPmc0uO4Rb2
	pjXTZj8TdAkUNpQgPF4cotBJHjDl41A=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org
Subject: [PATCH v3] mm: readahead: make thp readahead conditional to mmap_miss logic
Date: Mon,  6 Oct 2025 10:51:06 -0700
Message-ID: <20251006175106.377411-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 72D28140011
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: t4mr7wz6a8xkpgfpuxfw5ezjxh19snhp
X-HE-Tag: 1759773083-916936
X-HE-Meta: U2FsdGVkX18Kw1bgceDhPWGM4lGr6yu9sQFutJCZIf97q8LxsPWki8JvV5xS/bohV5C+UBds52NIHa4AhHSZFod7F8Vv9cjEGk/UAL+tK3ICqHOKYOw4bityBdTfegeVqPXxReEZYJ2ljI1QJn1YYGToEbogPkPB5Co4tDFty6HpW+Xc42dAKJz3CQDt8As7tMNhXX78mUvVyvLTa9pJovgjwDkEK9IcFNaG1e7o0psRf52oFb5qATxi4ornaFTKvqjV+yR3MigipAAdxjh42jiIQu+2NpOZdobagKBRggpGOq85EP1F4VC91+vzz7GGOFlZP4V4irVGr6Sp+gN02aS0i9W9TJORHWwZXxOpZFOPJ+FKLVGpTj8ZTtm9Pg45eA4lcQTFQdWiQ7P4nDPlJacwojxVUPdgyob9QUhvZKV4/oWwVm0U/dICvgFtox+0gZeTotUlbv7h71RxVfEVwkwWBNZ1mjZvaEwX14wP9DT2olwFYmbV+71xh4anexGh6GNGOWrA64k6AIuaq9XZUvQJVa14ZikVnBYkalAlEbmMQphV1W8w87HFPcefmnX6srTgue+UrHzdMoripsYmumxLnJDoQqyQuJWFLJt5aK7XUh1QLKYuQ4N+jgDRaVUuKkT+5jwhcTxrA33MqVO8xLAckKBdwZKjFVWHEFUht3ORVW1AuVlOWsVQAB3X4rVXvVzXLzARa1HRP32mD01KbH/eKaWvhvg/waXTb5R8x9S2b/Mhu2DnPNfbB3KydiVUjfSA0Ypgc3xUdBKqVXQy92zf8a3bubcWnCw3f9wwAnyU5K6cfQjixhlkE+nf5j1fTqnF6S6ApwT0AKATSpdG6xCmei6a+fcEeRdZMB2idMrzezGKnDhegirK+PqgCUXROkaV00oUWViJw8bLXMHjE1i7fc/mdelaFPPU15PL9A08cqDrySFRbHXw1iHntXUQPsj+oSlYZUphgdlLy51
 B6MJ4EMH
 K8cZ65biIaaqsik2nbkHugWTS3ahnAvdPH50H9JB54zr8YfDnv5WrAkNBGEPKreDVkhLIlm6G/ROmhghOSAtlOX8689Vdee13OH6VVtpZEqOdzrhTA1tMrFww9ZyQB18UwkfqktJdntmQNOws/YzyZxAF4Of4yDsh2RuuBdg+9O84MPXwWxyX0d36fmIqDWg5Y0lyumF5r1bFvej5OPYZ+nOqn8gbjhFVPqb2HjnSZEZFaXqxyjaL38PbO9FfUoRdpEqPicMU9pCbs84ketor7eg1VoyOCjnJJSdFLlunJnEq+GiQk58Di6FJMgZKgeHvO20xbDPPK2lqPlHUp3Llwtynbu6HUZCrtz4L0sWYdKrToqo1ifkX2R/B4+y+If2Cawbl30qTuSV8QMCMCWvNbyfGKKRvQFNC/AqVSZlq6NYehLE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
introduced a special handling for VM_HUGEPAGE mappings: even if the
readahead is disabled, 1 or 2 HPAGE_PMD_ORDER pages are
allocated.

This change causes a significant regression for containers with a
tight memory.max limit, if VM_HUGEPAGE is widely used. Prior to this
commit, mmap_miss logic would eventually lead to the readahead
disablement, effectively reducing the memory pressure in the
cgroup. With this change the kernel is trying to allocate 1-2 huge
pages for each fault, no matter if these pages are used or not
before being evicted, increasing the memory pressure multi-fold.

To fix the regression, let's make the new VM_HUGEPAGE conditional
to the mmap_miss check, but keep independent from the ra->ra_pages.
This way the main intention of commit 4687fdbb805a ("mm/filemap:
Support VM_HUGEPAGE for file mappings") stays intact, but the
regression is resolved.

The logic behind this changes is simple: even if a user explicitly
requests using huge pages to back the file mapping (using VM_HUGEPAGE
flag), under a very strong memory pressure it's better to fall back
to ordinary pages.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org

--

v3: fixed VM_SEQ_READ handling for the THP case (by Jan Kara)
v2: fixed VM_SEQ_READ handling (by Dev Jain)
---
 mm/filemap.c | 68 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a52dd38d2b4a..ec731ac05551 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3235,11 +3235,47 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
 	struct file *fpin = NULL;
 	vm_flags_t vm_flags = vmf->vma->vm_flags;
+	bool force_thp_readahead = false;
 	unsigned short mmap_miss;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	/* Use the readahead code, even if readahead is disabled */
-	if ((vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
+		force_thp_readahead = true;
+
+	if (!force_thp_readahead) {
+		/*
+		 * If we don't want any read-ahead, don't bother.
+		 * VM_EXEC case below is already intended for random access.
+		 */
+		if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
+			return fpin;
+
+		if (!ra->ra_pages)
+			return fpin;
+
+		if (vm_flags & VM_SEQ_READ) {
+			fpin = maybe_unlock_mmap_for_io(vmf, fpin);
+			page_cache_sync_ra(&ractl, ra->ra_pages);
+			return fpin;
+		}
+	}
+
+	if (!(vm_flags & VM_SEQ_READ)) {
+		/* Avoid banging the cache line if not needed */
+		mmap_miss = READ_ONCE(ra->mmap_miss);
+		if (mmap_miss < MMAP_LOTSAMISS * 10)
+			WRITE_ONCE(ra->mmap_miss, ++mmap_miss);
+
+		/*
+		 * Do we miss much more than hit in this file? If so,
+		 * stop bothering with read-ahead. It will only hurt.
+		 */
+		if (mmap_miss > MMAP_LOTSAMISS)
+			return fpin;
+	}
+
+	if (force_thp_readahead) {
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
 		ra->size = HPAGE_PMD_NR;
@@ -3254,34 +3290,6 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		page_cache_ra_order(&ractl, ra);
 		return fpin;
 	}
-#endif
-
-	/*
-	 * If we don't want any read-ahead, don't bother. VM_EXEC case below is
-	 * already intended for random access.
-	 */
-	if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
-		return fpin;
-	if (!ra->ra_pages)
-		return fpin;
-
-	if (vm_flags & VM_SEQ_READ) {
-		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-		page_cache_sync_ra(&ractl, ra->ra_pages);
-		return fpin;
-	}
-
-	/* Avoid banging the cache line if not needed */
-	mmap_miss = READ_ONCE(ra->mmap_miss);
-	if (mmap_miss < MMAP_LOTSAMISS * 10)
-		WRITE_ONCE(ra->mmap_miss, ++mmap_miss);
-
-	/*
-	 * Do we miss much more than hit in this file? If so,
-	 * stop bothering with read-ahead. It will only hurt.
-	 */
-	if (mmap_miss > MMAP_LOTSAMISS)
-		return fpin;
 
 	if (vm_flags & VM_EXEC) {
 		/*
-- 
2.51.0


