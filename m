Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E889CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 07:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A19898E00F2; Tue,  4 Nov 2025 02:22:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F05B8E00E7; Tue,  4 Nov 2025 02:22:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92DC48E00F2; Tue,  4 Nov 2025 02:22:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 822158E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:22:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3303312B4AD
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:22:11 +0000 (UTC)
X-FDA: 84072080862.07.0D4E704
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 979B61A000A
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:22:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p/DXWoLb";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762240929; a=rsa-sha256;
	cv=none;
	b=DKIrmjuQD5ykWrvesgPyFxWCs5fOg1sHBts246/av9osmignOhtg2nK4wvVQq1D1hJwhoi
	rOQ3aeRC7sZwLblgFkIYYsRdRzdwghsIZn91UQQRdzvbhdd3IcYJhSD75LGCPGLr4wKMQX
	wnvE7IljHMmhITbWYhbtDYPScVFGmOw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p/DXWoLb";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762240929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FMHRJ+AQnesZPhnU5G8yj0aS4qmy4oqaebVxc3Fpzk=;
	b=SMod3xcAQyu6Xlz1APTcOWJOsl5SnerTBQVW7WrhFYyCDNpvnnh25PBeJrSQS3e+C5q3gg
	6F+hRXDW3ZMbPsoJLe928wf+41PYwa9F8Vwa+WPvwSn+P99FhB0P0CRnIB+MmayT92h2zY
	neXRW0RlTW6yyWkxaJ5ehBd2cIZbcUo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5100600B0;
	Tue,  4 Nov 2025 07:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48671C4CEF7;
	Tue,  4 Nov 2025 07:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762240928;
	bh=0CGxBEEWd8ZRsNzewMWb8+88PnWmDLN2S4IUIF6lCDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p/DXWoLbumYSZv2TUz40zBSilEpy6y/KHg352LEyk5pRGSdTXhB0BGGN/Hw3mbX0k
	 ZXfqtZ3xjM4zVXQDmilMQI26ymF9CZ/wHu/dsjxPxbZu2wzah70Nv7Tdchh4TosAId
	 J/qyRsDSJD8qyzZVICXJF5X4gOmER7ViR23bbv+KhL9ua6sapp+KSBflcMD7nfpOtu
	 YOsgoq1DL4XM0RXP2Lc9jbXzCTPrJT/+8nzWmXOf1SXnxw3p7nEbLGSFY8TAMnMpRJ
	 A4KZZjauambXuJgLdbnCk469DPrm5/bZAQBoz2ES+9Ty+7bZhnkuktjMyM7msER28B
	 gXrXA3Pv/jLow==
Date: Tue, 4 Nov 2025 09:21:58 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <aQmplrpNjvCVjWb_@kernel.org>
References: <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local>
 <aQPCwFZqNd_ZlZ0S@x1.local>
 <d0b037a6-11b9-483b-aa67-b2a8984e56e0@lucifer.local>
 <aQPU-tyo_w68cnKK@x1.local>
 <7768bbb5-f060-45f7-b584-95bd73c47146@kernel.org>
 <aQkUwbx7Z4q1qcSB@x1.local>
 <5f128cbf-7210-42d9-aca1-0a5ed20928c2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f128cbf-7210-42d9-aca1-0a5ed20928c2@kernel.org>
X-Rspamd-Queue-Id: 979B61A000A
X-Rspamd-Server: rspam07
X-Stat-Signature: wxodsm9hpgpmarfdko5qyfqkakkerz9u
X-Rspam-User: 
X-HE-Tag: 1762240929-268976
X-HE-Meta: U2FsdGVkX18+hJ/44pc0SeRVkMPB5K1J57CdRMXoc2qtLvRWMJgQCdlff/WBNaHkuCcAvPg56/CpkSJ6BaOCP65A4lwn+iglFTzvdS+lHs9fHfPNivNDRneUJ9vAiiYC6EXeHVtEhrA+GQAQzp7OAUlyd4WKQRLgthFxxbgSdS89FshTzqWPEoaktArTLM+UzCb9ynuhUVU/GcDjQS9W63K2KYKTBcdTBrUDIlTGdYyxrmL5Rfzm9Xtdalrp1BFNO9wWZY38HjkPVUZL5Dwpy+rOMjXW/UHE4W/59qNrXRGnoZuLul/3b3+3P6ltBad1A3nensKc15fqHzTeWe9JWFK5pdoDFxsTgfnt2T4ZD/YreDJA/hrOjULP7ad4Bj+mrSPawtYYkLYobWHvfoPgm1kUmwxGCbVnk5b7+4qwfDdFZAANescFz7ngR7cpE/JMmLv0RSvV/uyaJEbDwyXnjMdI05oR06Wk36srbw9KkB9onuFgq1xIDzbCKIvPTtpfW0rf7Q30WoJJX9YfvUl9yA4OJj/mia8o8zyfhF2nAI+L/3UEVqZi3bsOD1B0hb6ZDBfSeAHzX1Gtmc2PDqvHUXAgwVQUA62xqdOZ3xUIz8oa8uGau1jswpcc84T639fITb0VS/icrxKsVWAhEOPystw8lymJts6oN2n0Nq9H6YijW234GYLr0xS9zP/tW9hrTPJbwXjag72bvSjo+kpr/XVxF9yd/bgtYdPCprX9xgDxszvYVq/98hV8XTYYtQvSUK7fDf0S17QpeNlZ9E5QoYm3sk1Mg8zfrJT+56nmn0MIFAZorsKss+x7PAjxKHNJK5IB64lyyMB2iGBpA7S66lZNe8Ti6tfhE2arfoQMpOOkhrwgO89JjPVCdvUwsyRcyibFdSjmuuUydT0XmWO/Pg9YcggsgLzSotLY24EL4hxGyHH9//uWnXy6auusKLbt7O4SJ4eI8Jkt6OWQsLp
 dQFWW2b3
 e64S8qVr+Wr/qYkz2iOU1j9wnrVmBlZMSN7uTx0c4MDcgZHXlnCAOOffpXmKcJKVaoAmChpAnfsLk8jAPW9mZFGu0ofHGjnnOfNp11mlfMuVqqAV3dHqgK7zpp7TU83NHzJWI2WsFMI7TOTlxVwBb6iLnm1PH8ukygrC6Qk7dYRt93i/vPV3hvHxOxdoOz5b1QFKmo3xx0A2aLJ1XLdTnRYINB8+0gzB7qf5cUkW0PGjtRAlf/Cb1C73bFXNyIwGPte1WjT0MK8CbQNzuyuKUaohUP107RRTf750B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 10:27:05PM +0100, David Hildenbrand (Red Hat) wrote:
> 
> And maybe that's the main problem here: Liam talks about general uffd
> cleanups while you are focused on supporting guest_memfd minor mode "as
> simple as possible" (as you write below).

Hijacking for the technical part for a moment ;-)

It seems that "as simple as possible" can even avoid data members in struct
vm_uffd_ops, e.g something along these lines:

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..840986780cb5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -605,6 +605,8 @@ struct vm_fault {
 					 */
 };
 
+struct vm_uffd_ops;
+
 /*
  * These are the virtual MM functions - opening of an area, closing and
  * unmapping it (needed to keep files on disk up-to-date etc), pointer
@@ -690,6 +692,9 @@ struct vm_operations_struct {
 	struct page *(*find_normal_page)(struct vm_area_struct *vma,
 					 unsigned long addr);
 #endif /* CONFIG_FIND_NORMAL_PAGE */
+#ifdef CONFIG_USERFAULTFD
+	const struct vm_uffd_ops *uffd_ops;
+#endif
 };
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index c0e716aec26a..aac7ac616636 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -111,6 +111,11 @@ static inline uffd_flags_t uffd_flags_set_mode(uffd_flags_t flags, enum mfill_at
 /* Flags controlling behavior. These behavior changes are mode-independent. */
 #define MFILL_ATOMIC_WP MFILL_ATOMIC_FLAG(0)
 
+struct vm_uffd_ops {
+	int (*minor_get_folio)(struct inode *inode, pgoff_t pgoff,
+			       struct folio **folio);
+};
+
 extern int mfill_atomic_install_pte(pmd_t *dst_pmd,
 				    struct vm_area_struct *dst_vma,
 				    unsigned long dst_addr, struct page *page,
diff --git a/mm/shmem.c b/mm/shmem.c
index b9081b817d28..b4318ad3bdf9 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3260,6 +3260,17 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
 	shmem_inode_unacct_blocks(inode, 1);
 	return ret;
 }
+
+static int shmem_uffd_minor_get_folio(struct inode *inode, pgoff_t pgoff,
+				      struct folio **folio)
+{
+	return shmem_get_folio(inode, pgoff, 0, folio, SGP_NOALLOC);
+}
+
+static const struct vm_uffd_ops shmem_uffd_ops = {
+	.minor_get_folio = shmem_uffd_minor_get_folio,
+};
+
 #endif /* CONFIG_USERFAULTFD */
 
 #ifdef CONFIG_TMPFS
@@ -5292,6 +5303,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops	= &shmem_uffd_ops,
+#endif
 };
 
 static const struct vm_operations_struct shmem_anon_vm_ops = {
@@ -5301,6 +5315,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
 	.set_policy     = shmem_set_policy,
 	.get_policy     = shmem_get_policy,
 #endif
+#ifdef CONFIG_USERFAULTFD
+	.uffd_ops	= &shmem_uffd_ops,
+#endif
 };
 
 int shmem_init_fs_context(struct fs_context *fc)
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index af61b95c89e4..6b30a8f39f4d 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -20,6 +20,20 @@
 #include "internal.h"
 #include "swap.h"
 
+static const struct vm_uffd_ops anon_uffd_ops = {
+};
+
+static inline const struct vm_uffd_ops *vma_get_uffd_ops(struct vm_area_struct *vma)
+{
+	if (vma->vm_ops && vma->vm_ops->uffd_ops)
+		return vma->vm_ops->uffd_ops;
+
+	if (vma_is_anonymous(vma))
+		return &anon_uffd_ops;
+
+	return NULL;
+}
+
 static __always_inline
 bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
 {
@@ -382,13 +396,14 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
 				     unsigned long dst_addr,
 				     uffd_flags_t flags)
 {
+	const struct vm_uffd_ops *uffd_ops = vma_get_uffd_ops(dst_vma);
 	struct inode *inode = file_inode(dst_vma->vm_file);
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
 	struct folio *folio;
 	struct page *page;
 	int ret;
 
-	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
+	ret = uffd_ops->minor_get_folio(inode, pgoff, &folio);
 	/* Our caller expects us to return -EFAULT if we failed to find folio */
 	if (ret == -ENOENT)
 		ret = -EFAULT;
@@ -707,6 +722,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	unsigned long src_addr, dst_addr;
 	long copied;
 	struct folio *folio;
+	const struct vm_uffd_ops *uffd_ops;
 
 	/*
 	 * Sanitize the command parameters:
@@ -766,10 +782,11 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
 					     src_start, len, flags);
 
-	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
+	uffd_ops = vma_get_uffd_ops(dst_vma);
+	if (!uffd_ops)
 		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) &&
-	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE) &&
+	    !uffd_ops->minor_get_folio)
 		goto out_unlock;
 
 	while (src_addr < src_start + len) {
 
-- 
Sincerely yours,
Mike.

