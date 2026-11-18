Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DB7960A2606
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ca9PoyOl
Received: by kanga.kvack.org (Postfix)
	id 8FB7C6B05FD; Wed, 18 Nov 2026 16:59:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2A86B05FE; Wed, 18 Nov 2026 16:59:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0C86B05FF; Wed, 18 Nov 2026 16:59:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 326EF6B05FD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:59:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C477C0897
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:59:28 +0000 (UTC)
X-FDA: 85449606816.01.EA25954
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5A84214000D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:59:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ca9PoyOl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+harrison.crosse.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+harrison.crosse.dev@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795039166;
	b=lHu5iYVQLVR87QW0NM8c9Z/eXXLiCpDbxCmgoIjmW3KKn0K/dFqb9b6/nHij3O2m3nGjjM
	D++fiXxmmADA1LjhvFTfweow5tuoroMZheQsN2nSvQCw9vER7eTDS50oafmATzhK9p+rSk
	wjlJ2VsBlqRDSEK42XXX+DNFMoe511I=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795039166;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZCDMReGT8kdAAJEPyl/oDR55ZrAEtce0UDwaaBcFh8=;
	b=s2AxMmUZpaniHQmdUSQTf9Dl6dVfzat7CY1NpK4u44R2sy99FID6i4BvpLWmgleTB9Kvx+
	BmkZzzKNg+Wsk1qJ/LLafWrrm/G5S6AZNlRWkzySpZjmuuH/bA18nyF55sSNJUMdXiqG+x
	q+OB4vguPiP1ADM+3QsceQ1zv5osnOk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ca9PoyOl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+harrison.crosse.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+harrison.crosse.dev@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9FBC40552;
	Wed, 18 Nov 2026 21:59:25 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795039165;
	b=V5d6uCeHfdiWupTIaMf6q66dnrV7+CaXOqDPI050gifPWcRIr2K7CNSoERy38usPPWsh
	 bTvjXjAf6Nv55pfvfabJFuBIFQCVZkFEIgku8u3K05tnxoleVsBvaP9UwIUi3X4c7Gh3Q
	 0ajtVN9T2DL0nOuSZzTUZbLv2Eaz1gpcYvhHoLCCF60U8JMX9+MSO6gm31EjhddwNJFdq
	 SqaHBFjlcqBTnJLG0TSxIUGbJhAtlwAHyoiBhec9KwpslHojEUVtJtzWK2dJOxOg72iqi
	 /2Tfz5+B4mw9sizo1o7G4BUS5nD428TWWeHLt1ubUgEv8NbQuHwGCCw4C1KBNvA5lag==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795039165;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4ZCDMReGT8kdAAJEPyl/oDR55ZrAEtce0UDwaaBcFh8=;
	b=oxJznGWNLrywchLNefANwzdshLjbXpnb0prbuXOUJssNhaq40dIa7cleCH9+YOwHy5Rf
	 rq7o81h50bMwHazHdo1fx8VdXEW+N+OVE2t86BrJ3/t2YQe1oG0jZ6dxguwStHYcoM0Du
	 p+KZdV5keBpxhdNFXEzXkPU8+UNZP7tw8W0LToR5E8Qz1XTE0e4bRWHu1r6UWGzfGRPBJ
	 7cVM25si+Y3R1YUibsEUEVJmHEOXsMxGJFLhfvbWv6GKIE8vv57mBmazkUwekJCOiWtih
	 noSHNRx1v69Gq5Qkjo3OV4M5HZCEHIABwsKaMtCmCzalIYML5be9xXj/IjTs4MdHHZA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A6FAF1F000C6;
	Wed, 18 Nov 2026 21:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795039165;
	bh=4ZCDMReGT8kdAAJEPyl/oDR55ZrAEtce0UDwaaBcFh8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ca9PoyOld873CKmQmRDFGXbPargZGbRMwzpmxt3azOypNQ7n3ayvaOKdTVwAay+KH
	 dsgJoa6h68gsexv7gB4Un3olyuaVG+hS78CFvbKjVSSCh6ROZ5s8JX+dFmbwU7j32C
	 +2DuFNX25O2ZJvTogzIOjkujL6fcAAOFwjbneHmFUHIV4lt+iH2gIJIj7MBf6VB32g
	 aRIbylHfbOdrKtMVhplvDqJfb3FrGolxQA23I2/mXq/9Xa1U4K7F/fJNMU8Ltyjae/
	 NkdAZVGHTOPCUgiMZGdrhPCXbnfDcGcPa62vaSxmXSObPlLwlKYv3SGoTFEhMiOQ42
	 WOuZgarvqhs3Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2488A4AFE1;
	Wed, 18 Nov 2026 21:59:24 +0000 (UTC)
From: Harrison Crosse via B4 Relay <devnull+harrison.crosse.dev@kernel.org>
Date: Wed, 18 Nov 2026 16:56:41 -0500
Subject: [PATCH 1/2] mm/gup: make mlock() and MAP_POPULATE handle
 VM_FAULT_RETRY properly
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261118-mmpop-populate-v1-1-9c561d178d11@crosse.dev>
References: <20261118-mmpop-populate-v1-0-9c561d178d11@crosse.dev>
In-Reply-To: <20261118-mmpop-populate-v1-0-9c561d178d11@crosse.dev>
To: David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>, 
 Harrison Crosse <harrison@crosse.dev>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795039163; l=8262;
 i=harrison@crosse.dev; s=20261117; h=from:subject:message-id;
 bh=o68P5YM1Dim45OasWUC3bF7sN6yAaM3DW9PetPgRC/s=;
 b=wMywT4ZYui4m+Gr0BQNzKVCKGUsOs8ElQLremHykfZO3gQlEasMlfWRhgJxvo670cC69t7XUb
 CtHOhvEHU2AAP+NoMgKynw/kYmxTgANI2mN8jBocLFjhxSZWR9nw9gp
X-Developer-Key: i=harrison@crosse.dev; a=ed25519;
 pk=fwi/XME2YaW/BDBQ76FmKgF9xHZwRb+dxlVCbxuyojo=
X-Endpoint-Received: by B4 Relay for harrison@crosse.dev/20261117 with
 auth_id=1552
X-Original-From: Harrison Crosse <harrison@crosse.dev>
Reply-To: harrison@crosse.dev
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ixzuqzi1hpzip13g11q3uzs7h689moe6
X-Rspam-User:
X-Rspamd-Queue-Id: 5A84214000D
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795039166-355330
X-HE-Meta: U2FsdGVkX18aCo6JkM+GA8HbNbURM1WGMNGhIiQRgAbI9YjPgdP1Z3sg/CtsBwEZA3zfND/IO8ST/g2Qab6nmsBDASRGN0xGXaUDUjygAFi5ruFlez7xS2PWYFkqZxqOCZynVoGYf0A5HY+XqiGFkrdyZNsB1dhNdc6ZhCWgFfOv3+oEg3yFPL9g5I77NmYkdtH9y/wpgbKkcBNho9t4eY1C+WCeq3KV2zMlO5t8KrlozDxeDMSzQV11pMnQ1t+ivrzEABLIAP6tlHuMnRCbTP6Es+DTkmFjsro2fDWe0DS0ero/54S+iDSedS17t27ojJaQZ6JLuW4MVrMGvXbom5kon6S5gSgaoYKlzrY30TXydbnc4A6xnl+ZcYLIbvHhKcgUU/N3/uuw/xbQWax37Jt4tfI9qPo+FKMZGWebVudeY/wxTYFYTIz4EkDRET8n2bntPO7jaF3Xr+CZ99rqtDHW2oRKw3JrEhZsZtWan2++XPU/9EO8nLslaMrkyrEuTG6ZAHkIGj/zmA2c58l6ciz8SyxnzVy0mMXqwj8u747QxZSPJznsNXmteVZ42GZfeZJ8086RK/8naxBP2rkDBwabfQnk+tozocv7n3p9ks2AeVuRfpWueQL2Bga2vwG16GlF8f+SU6/k+mVyoGDm+9LGZfEo9ZnlfIIdWzQhXVytAy1isPK9+gEMopB4RIQBzCGHZ9Z+dbKI16v634My/9cZ/LaLNgLtBlC/BYrJpa1qAeBfF6LT4ffv1qyUBtkhHpmtMdsFnMXYvz2FpZEDl6Gq9Ru2HNGmn50OJiXJHYPwouoF/E/WYOusddXYvA/GnFjKZ9t7ktnimFGP63oY3kPwxbC0qEZ9YWJwVWFsJmv+2EZEI0Nt774lw+a49UCUisW7mVZgvZQ60BxSPBIPDMXmPSGJuZkVNd0B122B1LLxhQqn6Xipu6QUz6AFSBLRdEx3PXhsSFkWpvPgH7i
 UQXIM1Pn
 Stfkn9r2i+x3Dy6/1wnZHwKx0MfqabC1CmlBL2WfF0eG6gUfaPVJcnhoqYH5nl4XRQZ6GAsRjWmaTbHJqxJihON2P4DSz4BKVgDKl3vNy11VUHIGkjrHelsD7qcJq7/RmCt9hUZ2E4w+dSKw4pPzcA1rOWCjbuCqRJpzb0eymuUGWW6lYcXsa8Mz51ls97Rk7hAzg+wCPKDW/A/Qi3sPMmhy3mn75uVNWO3EEA75hzAzfemHqQ3A+0f4XfmI3quMbx9wdCDnooYY/QVaVrWsKXeXCNi/Ulpn2tb7XcKC6AGz4G6t1nKtk2naYN+SYi+smPrfR8pNfFdgAXZYOFrnNLLOVBU4+4+uVGmIDwEo1/rNaiNdk8KeOV7u9waHV/jLCpVN0NOQMDUBVA67geCtrx82oB6T+0RTh/gHXQCy3s+GIEtzkBSnruH6Cv5GDU3iwHD2qgQxgL9ahraM+ROXz1DNVQcXNKVLXjkU4ckAWo1538+ufWsoXJcGuIJe05hDTlkVjEFxQ7J5ozNHyfWPXAg5XWoN2i+lOPeyMAbPMMuwhiiOpZCxLyTbDMiuduUnWmONjB7L+FYTx5I7CPBujGJ9okESbvOSRz17o6IbeIHsWaq36WbyY+vZ8yig1CfGQVnpiQi/xlNOJSPAshWSrHSJzJQsk9clZAjt8q8deiGtXd+D8VSfN0deppm9u/o03RCRZyAxz+Ul/QbzYUvCLwqQ2rVy5DlHfU53NZYLkRtAU6h3uYO+im5WQ/mInVAHslFls
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Harrison Crosse <harrison@crosse.dev>

If every read of a page of a file mapping fails, mmap(MAP_POPULATE)
and mlock() of that mapping do not return: the task spins in
__mm_populate(), submitting a new read of the page on each iteration,
until it gets a fatal signal. Touching the same page gets SIGBUS, and
madvise(MADV_POPULATE_READ) fails with -EFAULT.

The first fault on the page reaches filemap_fault() with
FAULT_FLAG_ALLOW_RETRY and without FAULT_FLAG_TRIED. filemap_fault()
releases the mmap_lock to read the page and, because it released the
lock, returns VM_FAULT_RETRY before it looks at the result of the read.
It cannot report the error then: a fault that has released the lock
returns VM_FAULT_RETRY or VM_FAULT_COMPLETED, and neither carries an
error. faultin_page() turns VM_FAULT_RETRY into -EBUSY, so
__get_user_pages() stops at that page without an error, and
__mm_populate() calls populate_vma_page_range() again at that address,
again without FOLL_TRIED. The page fault handlers and
__get_user_pages_locked() retry with FAULT_FLAG_TRIED instead, and on
that attempt filemap_fault() reads the page with the lock held and
returns VM_FAULT_SIGBUS if the read fails.

Commit 631426ba1d45 ("mm/madvise: make MADV_POPULATE_(READ|WRITE) handle
VM_FAULT_RETRY properly") fixed the same loop for MADV_POPULATE_* by
calling __get_user_pages_locked(). That does not fit here:
__get_user_pages_locked() retakes the mmap_lock itself and carries on
with the GUP flags it was given, while populate_vma_page_range()
derives those flags from the VMA that __mm_populate() looks up again,
and may skip, after each unlock. Retrying with a NULL locked instead
would drop FAULT_FLAG_ALLOW_RETRY and FAULT_FLAG_KILLABLE, so a
userfaultfd range would fail rather than wait, and folio lock waits
would not be killable.

Instead, have __mm_populate() remember the address of the page whose
fault released the mmap_lock. When the next iteration starts at that
address, fault in that page alone with FOLL_TRIED, as
__get_user_pages_locked() does, then continue with the rest of the
range as before. The retry reads the page with the mmap_lock held, as
filemap_fault() did for a page that was not uptodate before v5.1, and
as the other GUP retries do. With a persistent read error the retry
fails with -EFAULT: mlock() returns -ENOMEM
(__mlock_posix_error_return() maps -EFAULT to it), and MAP_POPULATE,
which ignores populate errors, returns the mapping. A fatal signal
still ends the loop, with -EINTR from __get_user_pages() or, if it
interrupts the FOLL_TRIED read, with -EFAULT. The other callers of
populate_vma_page_range() pass a NULL locked, so they cannot get
VM_FAULT_RETRY and are unchanged.

Reproduced with ext4 on dm-linear over a loop device, with the eight
sectors of one page of a file mapped to the dm "error" target, on arm64
(Debian's 6.12.116 and v7.4-rc3) and x86_64 (v7.4-rc3): mmap(MAP_POPULATE)
and mlock() of the file were still running in the kernel after 5 seconds
and ended when sent SIGKILL. On 6.12.116, the block layer tracepoints
showed about 280,000 bios a second being submitted and failed.

The analysis, the patch and this changelog were prepared with the help
of an AI coding assistant (Claude).

Fixes: 6b4c9f446981 ("filemap: drop the mmap_sem for all blocking operations")
Link: https://lore.kernel.org/all/20191105182211.GA33242@cmpxchg.org/
Link: https://lore.kernel.org/all/20240314161300.382526-1-david@redhat.com/
Cc: stable@vger.kernel.org
Signed-off-by: Harrison Crosse <harrison@crosse.dev>
---
Tested on x86_64 v7.4-rc3 under QEMU (TCG): with the error page,
mmap(MAP_POPULATE) returns the mapping and mlock() fails with ENOMEM,
MADV_POPULATE_READ still fails with EFAULT and touching the page still
gets SIGBUS. With reads of that page delayed by 1 s with dm-delay,
SIGKILL during the read ends the task within 2 ms. Without a read
error, MAP_POPULATE, MAP_LOCKED, mlock() and mlockall() map every page,
and the map_populate, mlock2-tests, mlock-random-test, madv_populate,
mremap_dontunmap, on-fault-limit and guard-regions selftests have no
failures, nor does populate_eio from the next patch. On arm64 v7.4-rc3
under QEMU (TCG), populate_eio fails its mmap(MAP_POPULATE) and mlock()
checks without this patch and passes all three with it.

Not tested: the other checks above on arm64, page sizes other than 4K,
transient read errors, userfaultfd ranges, file systems other than ext4
and FUSE, real disks, non-fatal signals, and the rest of the mm
selftests.
---
 mm/gup.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 2b405cce2..e666761ed 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1795,11 +1795,12 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 }
 
 /**
- * populate_vma_page_range() -  populate a range of pages in the vma.
+ * __populate_vma_page_range() -  populate a range of pages in the vma.
  * @vma:   target vma
  * @start: start address
  * @end:   end address
  * @locked: whether the mmap_lock is still held
+ * @tried: whether this retries a fault that released the mmap_lock
  *
  * This takes care of mlocking the pages too if VM_LOCKED is set.
  *
@@ -1814,8 +1815,9 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
  * If @locked is non-NULL, it must held for read only and may be
  * released.  If it's released, *@locked will be set to 0.
  */
-long populate_vma_page_range(struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, int *locked)
+static long __populate_vma_page_range(struct vm_area_struct *vma,
+				      unsigned long start, unsigned long end,
+				      int *locked, bool tried)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long nr_pages = (end - start) / PAGE_SIZE;
@@ -1860,6 +1862,8 @@ long populate_vma_page_range(struct vm_area_struct *vma,
 
 	if (locked)
 		gup_flags |= FOLL_UNLOCKABLE;
+	if (tried)
+		gup_flags |= FOLL_TRIED;
 
 	/*
 	 * We made sure addr is within a VMA, so the following will
@@ -1871,6 +1875,13 @@ long populate_vma_page_range(struct vm_area_struct *vma,
 	return ret;
 }
 
+long populate_vma_page_range(struct vm_area_struct *vma,
+			     unsigned long start, unsigned long end,
+			     int *locked)
+{
+	return __populate_vma_page_range(vma, start, end, locked, false);
+}
+
 /*
  * faultin_page_range() - populate (prefault) page tables inside the
  *			  given range readable/writable
@@ -1934,7 +1945,9 @@ int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long end, nstart, nend;
+	unsigned long retry_addr = 0;
 	struct vm_area_struct *vma = NULL;
+	bool retry = false, tried;
 	int locked = 0;
 	long ret = 0;
 
@@ -1967,8 +1980,21 @@ int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 		 * Now fault in a range of pages. populate_vma_page_range()
 		 * double checks the vma flags, so that it won't mlock pages
 		 * if the vma was already munlocked.
+		 *
+		 * filemap_fault() reports a read error only when
+		 * FAULT_FLAG_TRIED is set: on a first attempt it releases the
+		 * mmap_lock for the read and returns VM_FAULT_RETRY whatever
+		 * the result. So when the last call released the lock at
+		 * nstart, retry that page with FOLL_TRIED, and only that page,
+		 * so that later pages still get a first attempt that releases
+		 * the lock for the read. Compare the address because nstart
+		 * moves past that page if it is no longer mapped, or its VMA
+		 * is skipped, when the lock is retaken.
 		 */
-		ret = populate_vma_page_range(vma, nstart, nend, &locked);
+		tried = retry && nstart == retry_addr;
+		ret = __populate_vma_page_range(vma, nstart,
+						tried ? nstart + PAGE_SIZE : nend,
+						&locked, tried);
 		if (ret < 0) {
 			if (ignore_errors) {
 				ret = 0;
@@ -1977,6 +2003,8 @@ int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 			break;
 		}
 		nend = nstart + ret * PAGE_SIZE;
+		retry = !locked;
+		retry_addr = nend;
 		ret = 0;
 	}
 	if (locked)

-- 
2.56.1



