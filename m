Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A833ECAC5BB
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 01:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE358E0005; Sun,  5 Oct 2025 21:54:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57D88E0002; Sun,  5 Oct 2025 21:54:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6DF48E0005; Sun,  5 Oct 2025 21:54:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A79B18E0002
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 21:54:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 539CB1DED49
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 01:54:32 +0000 (UTC)
X-FDA: 83966019984.22.B63633B
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8F95A120004
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 01:54:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qq6F2KCp;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759715671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rIzE1DNf7pyKHPK9V7hAuDP65Ms8fhGAUyjyUKo/y3A=;
	b=uUvtWKJXvyQyMOSabYu0+36sHrT2xmrhC52ezIIQRGRqrE0oty5SALEK9ryfzTbqNJVT6V
	f0vXaRVnsHZvDfnBuFHwGONhZ/n1kUGYbUvtsC5r509d0Ai2EZcyHYC8n7aKRPByGD8uVy
	ijD0BVgLxoijxhtlnj8q/vxJw5k1x7o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qq6F2KCp;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759715671; a=rsa-sha256;
	cv=none;
	b=QHC2Xc9EtTrJSQRhbWPSkBtbv4vGmuW/0lbYcrdvSGbvvzPhAm2LthexRZajbYI+iGfGNi
	EYVAJIyiXigGZAGHRFHvX+Qgl6ExnPQXRV/WGjJHRajewWfEgv8uoFhnG08CKu5fFmzXPB
	H7vAu8NtvLvNaI7M0T0ItSl9zd3mcfs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759715668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rIzE1DNf7pyKHPK9V7hAuDP65Ms8fhGAUyjyUKo/y3A=;
	b=qq6F2KCpVRwuzCljJJPJzXdZB9Y4q4G6zEhhvpBZH3ZZKWYBsOX7YUwGZOvJVYvPT3tkoz
	xObaXXAj8mSHKEijoyaXsVll/B/uYZPTKFt0DNie+ELpvV6C4V/rsYr/J6eX7+8ZNS0X8f
	1IeisbtIyaCUmqG1a/ASMNNumdQNOpg=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org
Subject: [PATCH v2] mm: readahead: make thp readahead conditional to mmap_miss logic
Date: Sun,  5 Oct 2025 18:54:09 -0700
Message-ID: <20251006015409.342697-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8F95A120004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6u5788g9k4xkm3u1ui4fmbfaj74nhfjk
X-HE-Tag: 1759715670-811773
X-HE-Meta: U2FsdGVkX1/ZLhVbIpqYcl+Mwjrnq50Ce8Obj06usnlngZ04iS7U7fcaswVuCdPVFFBXrtCVTFPuUPNEUavthKEH9BSOabJyY2JzMChD27mnIdDEGGRV7A59mk9qa01GVatZ8Hd9Q/czr6Sqv3/UqPm89atExMS6DQwplX1CZrkiTB8Xdm3R0AY6I3kdHzQx196esBuiGLEIvCUKoEbhE/8ymRAm1bEjEADkfinN0V6xOLzCwGanpUrZMzMojkuH6vCMzvBLRNGObR8lldsylO0mgGDHpqez+YrRojDDVfEdlEU3Js0uQBKJLtTCc9clG1UEJszuD5YxWEU8YRyS8/XnZQK+pw9G5Id3If7Hl8mXHoNrlcA6eK6FrgHu8zZsjwHD4vhTFui8S2HWiFOH7xWY0K97lfRMju+f436NkyYSdQ3SMFcMrZYLGlXoAtOWMMP7uq4sF201yhj1EUaFu2tPSWaCW5Dx1r3t+NpLvGeIqjABCgH8IqanbQMYGvQT3q4lLeqRXipNaq47StXgeAYuFUDptKRQN0MwLbJ4mjP5bWKAzHTFY4r215eN3J8UaWF57e8J4+KspB7ais3HQM7PtNYjCK9sNaMah6SzoF3WohqGZEA5C5ic0lbL+Yxk3sK9WMDHhVr8iKVT0Ji3Yhum7EMX1LdxVV/7Pd3vyHrx17JdigJaq7bMHrZvtLGqmoAfd8wGtYjUW9ZSCm7rIvih7RjDIsIvW3B6y+cs8nAUoeYU+5z+Z31/1idvzwcmoo4Sc6NixI3KbM7iksoD17EVapeBujre4kJua20/dbTQuDcEhNkktNIhRPo92YB027HCxlphSAmG7cDlmoIOjkUPlxJelpd6UUW5D6rYGRLxxWmUJPf8pXUiSY1YRs52ibnJVscKnLAW1LEsxW9PZIYWMvstDlBsLr+2Fut8+AhqaH39WOmofNWC8iS43SKcxWTW9m//PRAUM1/M2Uu
 giBsV3d5
 DMCKP8tddc4s0af1ZERsx9jUzxHE1wNEAPWbUllLqMTBYf4m3pd/+IPeMRNW8qMQHfoN4CHrxs8XkEhLz0TpJNbghl9wnRYAxCK0sIKElDXspPvuMt0BNDm/40y9jU4TusDYdtdk2FskwK/rxrYwR12espgkVwulMMB0zpuaJZ4N996cJOGzZ0FvQPPNIGs9JAeK5TaZqiEll9sxW9ldFJy1folszzpq2eBc6UjF2vy3DskbRD/YC2rZ/edh4KYlLlb6HrZa9gd/fa2CCaQPchHWs1BThdHklMQN+22x1ntXVSESwbesRXp6DvuxFqgk7KzclH7t08snJZyyuBhkPPqByOmq8ccEpbO83YQgcngwU71U6m9GmrzgrB+pzAPsqYOEA
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
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org

--

v2: fixed VM_SEQ_READ handling (by Dev Jain)
---
 mm/filemap.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a52dd38d2b4a..446e591d57e5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3235,37 +3235,23 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
 	struct file *fpin = NULL;
 	vm_flags_t vm_flags = vmf->vma->vm_flags;
+	bool force_thp_readahead = false;
 	unsigned short mmap_miss;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	/* Use the readahead code, even if readahead is disabled */
-	if ((vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
-		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
-		ra->size = HPAGE_PMD_NR;
-		/*
-		 * Fetch two PMD folios, so we get the chance to actually
-		 * readahead, unless we've been told not to.
-		 */
-		if (!(vm_flags & VM_RAND_READ))
-			ra->size *= 2;
-		ra->async_size = HPAGE_PMD_NR;
-		ra->order = HPAGE_PMD_ORDER;
-		page_cache_ra_order(&ractl, ra);
-		return fpin;
-	}
-#endif
-
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
+		force_thp_readahead = true;
 	/*
 	 * If we don't want any read-ahead, don't bother. VM_EXEC case below is
 	 * already intended for random access.
 	 */
 	if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
 		return fpin;
-	if (!ra->ra_pages)
+	if (!ra->ra_pages && !force_thp_readahead)
 		return fpin;
 
-	if (vm_flags & VM_SEQ_READ) {
+	if ((vm_flags & VM_SEQ_READ) && !force_thp_readahead) {
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		page_cache_sync_ra(&ractl, ra->ra_pages);
 		return fpin;
@@ -3283,6 +3269,22 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	if (mmap_miss > MMAP_LOTSAMISS)
 		return fpin;
 
+	if (force_thp_readahead) {
+		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
+		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
+		ra->size = HPAGE_PMD_NR;
+		/*
+		 * Fetch two PMD folios, so we get the chance to actually
+		 * readahead, unless we've been told not to.
+		 */
+		if (!(vm_flags & VM_RAND_READ))
+			ra->size *= 2;
+		ra->async_size = HPAGE_PMD_NR;
+		ra->order = HPAGE_PMD_ORDER;
+		page_cache_ra_order(&ractl, ra);
+		return fpin;
+	}
+
 	if (vm_flags & VM_EXEC) {
 		/*
 		 * Allow arch to request a preferred minimum folio order for
-- 
2.51.0


