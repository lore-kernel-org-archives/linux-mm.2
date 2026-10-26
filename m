Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E518E606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U97lsdiu
Received: by kanga.kvack.org (Postfix)
	id EAD5D6B05B3; Mon, 26 Oct 2026 19:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5DDE6B05B5; Mon, 26 Oct 2026 19:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74606B05C0; Mon, 26 Oct 2026 19:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADD5D6B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:20:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46FC11408A6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:20:26 +0000 (UTC)
X-FDA: 85366348452.17.967D164
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 71324180007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:20:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U97lsdiu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hyfT9UeYB82/Suh3401TnHPdPR4zRtp/VCfqHa3Pal8=;
	b=woP92KOFGQPR/Jv1+kHP8C3bEtwqbi9Pft+4QbdmdHRZt0EYpRFY89H/4mW/Wvx2EsSbEZ
	p/z52rDqYz5AyiFwQ9y/OeGpWbp1kl1pkgdPM6e46jkdTfpGQQNtW5sogR8jbiHVBsRhz9
	CfS7MOgCwfZAfq9G290+0U5EkUL7rG0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U97lsdiu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056824;
	b=RR+vt7ntM54d6FlItg63G9ByMWVT8ufXYmZLnHIkEHJaMVU/whkLiO7tMH8YIWDk6BTcla
	P1u3diZqWqDXuaZLKNpVAXL4w8MD97yQstihlQQLdLgH/hx4xLu1n+F2CdNIuQQmwPWxya
	K4rw0+UUtwjTEtC1D5U7NP3ZyV6JKzE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1822460213;
	Mon, 26 Oct 2026 23:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999B61F01828;
	Mon, 26 Oct 2026 23:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056823;
	bh=hyfT9UeYB82/Suh3401TnHPdPR4zRtp/VCfqHa3Pal8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=U97lsdiuuUuPQkUAKKTWJuTgmH9WwQHN0iCh+iz6wbLPc5h+rl05TXy57cN86b+/Q
	 FI4xdeXdn6F4RwcU+GrHn4zbLcRBGAyKA0Lp94FBikfdN8ltNLD6PqHgZ/Qn+xkRM5
	 ckNapyH5LMmD/Nv7BZRtRCk9aTWJxuFyhfp8YxDlk+ZGHwanXE/Viut+BZGtWwN+Tl
	 C/3i0Eaa6ClOJyTpfYezrhNOGzQTHbcD94eIRkISQHhuJQHkpvFsOdxrAHdvB1oYou
	 ctYbGfccTpd5kBRo6Z34hbpbaAMaG+Ij1gx1yy1hr/uPLT7j/mYnTvcQ+JcEReUht9
	 s/mnuLs9M7+pA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:28 +0100
Subject: [PATCH 08/46] mm/filemap: finish fault cleanup before dropping the
 fault lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-8-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4015; i=david@kernel.org;
 h=from:subject:message-id; bh=53xEYTkQp6IA0uXj6MOe1vM8W7peAp/MfOvPesJ6Ry0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu358cKuG90E2q9Vcd72l1E0eTh6vv8Uvc2KRaes5xD
 /e1U5/mdJSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRVQkM/0O+p3RP//jQ+0D6
 hjiOc2uW3FZ7Y//nAetjz8/HDU8uUpdkZLiUlzPnxGrjWVNvzWdXOsCVUvPzyUpVwdSczgtBD1p
 zj3ABAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 71324180007
X-Stat-Signature: yb6opbmzudhdzyzehc87mz6x3rx5idm4
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793056824-222581
X-HE-Meta: U2FsdGVkX1/vfdOIIyn0OnQNpQTE/y+OtYY4iaA2Zt3wnvahEM8+Hzc0dslXSFAlnfYjlQjnWsE0HN3Gh/aonotSNekr5f16gzFf+KFcrzc+zz3/2huP3t+26skWev6lnPHqMtd31NyPQHyiFsLCqVBh3un181x/C4YJSrjXS758Ga1BiXzNhpr0bK3t0toll47eLCWv+dgaGG5ipxeiLxtnoFnEIaiKMnH6nXeaPSBJImDSJUB7VRDAUXld/pVzigm9oJgrd/fZq8z4vuT/9GbsVPVWouM7FZilsC7XGbPAMq8ybBMSm2kHmUsehQ9suD5Idi0uzb4g7z5/7rItrhLyunPwWuuvEFXdqr0S3vIQ9LjrCh5Ftd9ZZwc+9C3WJMIDdW8l1kKn/rPnLgQ2l52q/vZl18lg/3CIq7C0RqdqTNXjxcxmTK3Grn1qPZ4a03cqA+p2VpzBAfTdpelylwBXKarrDBcVmQ0+qmKCnXt7h1K5cGvHrvVM65LrtsSecRcSxRPszRGNUVWKdENJYPEApAryY13Zku55cD+HFWy/rpv3HM3MRsr4jIztoq6enaULfThS4JNmdxN046aTPSmk2sng3Judt6hBGekX6qnxWfZ4OFhNt7qgYdNpSQe1aviReweb+Obkc5lJoGL9O9/RSju8zOBYOtzLs9e9+akLUNxm+iZkWM8cMI9VjXd9PTEsLtdDMk+MQw+J4qqvqaZcw7zqjw16bP0Y80qn8/0ym6BNCRVal1kbFo/04A3zn/M7ETMYEsInF/0nm3lxR115N6v0mpe2MBXrxpWDSyi2XKxs0jJpwaR1nfqTYx1aRX5X16IxYdbXmeDGuBy8O2ZNnx4dLWnhus+yS3kn5jjRNoyVXJNGz+BtWTB9NWjryu3mgmRNOuBnTKMKYtGFYK40ybLB6RnADuBkI0KSYRXjNqHDEfvy6q6BvDtIKAY+R1kAfa0cWJgBAfPEToK
 tsOnPiQo
 tDbovr+thf6FbTaXwB/gyScwDuMO2YSB7pjNYEYOPt5FQ1BtqvAtuxYcG2eJ0thBzqrVRr7YOyMsFhEtjE/SJtbOKI7sDHgT/Q7rKVMmnv1i1NEj4kCu6REHmSpSA11ENLfLbwvYpcoYr4yoGibMzSg0iO/HeXMOCTMu6DZJpbNYUx83GObwf25SwrSIiaqhmXfZnXW2Iwc+eG5lOoA7Q4POl+4k7aRSzMzOcDzvAfT/tTjN+CEhGFi/f5mul0+fT+POsPWAmYS6FUFvUsJp/T267x/FnvM9gLgMx1ogAujh2oNqPFweffxXxEj8iGnU48xXf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On a retried fault, a fatal signal interrupting the folio lock wait
makes lock_folio_maybe_drop_mmap() drop the fault lock without pinning
the file. However, filemap_fault() may still need to release
mapping->invalidate_lock. A concurrent munmap() can release the last
file reference and free the mapping before that unlock.

Defer dropping the fault lock to filemap_fault()'s retry cleanup, after
releasing invalidate_lock. If the fault lock was already dropped for
I/O, release the existing file reference instead. Keep the fault lock
held for FAULT_FLAG_RETRY_NOWAIT as before.

Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/filemap.c | 37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 6b5e1d866a9e0..b04be64a5069f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3308,11 +3308,11 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
  * @folio - the folio to lock.
  * @fpin - the pointer to the file we may pin (or is already pinned).
  *
- * This works similar to lock_folio_or_retry in that it can drop the
- * mmap_lock.  It differs in that it actually returns the folio locked
- * if it returns 1 and 0 if it couldn't lock the folio.  If we did have
- * to drop the mmap_lock then fpin will point to the pinned file and
- * needs to be fput()'ed at a later point.
+ * Returns 1 with the folio locked, or 0 if locking failed.
+ *
+ * On both entry and return, a non-NULL *fpin means the fault lock has
+ * already been dropped and the caller must eventually fput() the file.
+ * Otherwise the fault lock is still held, including on failure.
  */
 static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
 				     struct file **fpin)
@@ -3329,21 +3329,9 @@ static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
 		return 0;
 
 	*fpin = maybe_unlock_mmap_for_io(vmf, *fpin);
-	if (vmf->flags & FAULT_FLAG_KILLABLE) {
-		if (__folio_lock_killable(folio)) {
-			/*
-			 * We didn't have the right flags to drop the
-			 * fault lock, but all fault_handlers only check
-			 * for fatal signals if we return VM_FAULT_RETRY,
-			 * so we need to drop the fault lock here and
-			 * return 0 if we don't have a fpin.
-			 */
-			if (*fpin == NULL)
-				release_fault_lock(vmf);
-			return 0;
-		}
-	} else
-		__folio_lock(folio);
+	if (vmf->flags & FAULT_FLAG_KILLABLE)
+		return !__folio_lock_killable(folio);
+	__folio_lock(folio);
 
 	return 1;
 }
@@ -3572,7 +3560,7 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
  * vma->vm_mm->mmap_lock must be held on entry.
  *
  * If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
- * may be dropped before doing I/O or by lock_folio_maybe_drop_mmap().
+ * may be dropped before doing I/O or when aborting an interrupted wait.
  *
  * If our return value does not have VM_FAULT_RETRY set, the mmap_lock
  * has not been released.
@@ -3728,9 +3716,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 
 out_retry:
 	/*
-	 * We dropped the mmap_lock, we need to return to the fault handler to
-	 * re-find the vma and come back and find our hopefully still populated
-	 * page.
+	 * With fpin set, the fault lock was already dropped. Otherwise it is
+	 * still held. Release invalidate_lock before dropping either protection.
 	 */
 	if (!IS_ERR(folio))
 		folio_put(folio);
@@ -3738,6 +3725,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		filemap_invalidate_unlock_shared(mapping);
 	if (fpin)
 		fput(fpin);
+	else if (!(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
+		release_fault_lock(vmf);
 	return ret | VM_FAULT_RETRY;
 }
 EXPORT_SYMBOL(filemap_fault);

-- 
2.43.0


