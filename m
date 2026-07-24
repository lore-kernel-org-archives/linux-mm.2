Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E8DC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A719C6B009D; Fri, 24 Jul 2026 18:30:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A23B86B009E; Fri, 24 Jul 2026 18:30:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9398E6B00A0; Fri, 24 Jul 2026 18:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A6146B009D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:30:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E26361C014B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:19 +0000 (UTC)
X-FDA: 85025114958.25.A31C978
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1C9AA40003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=MS9beTn9;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784932218;
	b=EVuIsWD64ELhQnNLnL6yMWps4B+Q8QNqdXiDqPlEOwmXK+ok02rznF7mWbZCb97bGOHRcN
	wPK0/yzqRDQ+eans/hB3l1rKskPHhbe2qxi+JwtKhUgmpal4kls/8HBMVLsisZk7HmyWVe
	UEwlwuo3R3oaaw1qB//GzXzRnGpQQ3Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=MS9beTn9;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784932218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=laFb2+2OJHBjt42yZcZ3hsZQhNcm9lH5QpuUTZr6hlo=;
	b=lsigybAxBDFXnHIE4NZhVttEMarP0N968kPYexgdahFZoSir5jgJy4sDaC+EtHDVZi8wpp
	yvh1PlYeqLgX0c0QpuLkYBztD2LXMOviJQsY1d+TJ+ljgdjpezZ+W//nMmIMI+GR9UVnUG
	oasBZY5e7oEi4/DP1N0QGMhxZAixHSY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=laFb2+2OJHBjt42yZcZ3hsZQhNcm9lH5QpuUTZr6hlo=; b=MS9beTn9E8RTJJ4e2NxUs4APQF
	lAXN0Zcyhkx0y+7Mtv/RePRaBeHwPGyHKX5pv22oE72E+K3e2CemBHeOJQ9PfLCo/p58tVLwnJIAf
	rV4awksMHY2ke6Lar0t7F7nBQEmsaHCdS4g0vM7Jm8fSYiL9FSVy8o6AWz03JvGdI93FHR8NU6YK9
	PgHLj0T4iLAF9pqDWeSR/4GWTTlGKBm7U70OsI6A75EWGs7LGXi0x4MRr/g4r6Fus+Cfsi3RujiBg
	BE1K/icV7oT4ieExMWcBru/LRH81jK04qt/z40d1zgRltnZXmSiMAEp2LBrmvW4kg0HpsyfNRtfR/
	BoUcWQYQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wnOOs-0000000027h-1eMx;
	Fri, 24 Jul 2026 18:29:50 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Rik van Riel <riel@surriel.com>,
	bpf@vger.kernel.org
Subject: [PATCH RFC v4 07/12] mm: read remote strings under the per-VMA lock
Date: Fri, 24 Jul 2026 18:29:29 -0400
Message-ID: <20260724222934.1463812-8-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724222934.1463812-1-riel@surriel.com>
References: <20260724222934.1463812-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1C9AA40003
X-Stat-Signature: w3ih576748hr36hp1x45zpgk1x6abek5
X-Rspam-User: 
X-HE-Tag: 1784932218-998140
X-HE-Meta: U2FsdGVkX1/29eldx0QxjtecUbXrTmojANs31XFEiErHF4KuqVKYEJqth8E+1+8R/GFRyzehUGjzEMr1S8cMv5shQ060VMaSmFmm89O8KVEYbZc90/bW3hViGM0ZoddCneG7iIxY4132/9iFmGoygDgG3HeV2aKN3k4alLqDpJXzhv4GhKhRNe6dunwizu+Vfnx4egh0UctxV3dxeV6I4ESwp4NzSb2kzOLtPPA0GYI51AgzKw3shFQBhnK/L1wWUpbWOBXPYxRtibGpvXF9mA7QJIyye5Z6ei8lfaf5EUVMeEgSwZL0bu7ZNB77V5XGYAJRG3pndDFOMXrHS2EuqNzZ3se8ttd03rYYzfEN4kBLV4xxL6V4fb9Dg2T0lil6LoeFArwfxNGzcKq8ZJjBRminsf39YFeSttRtz+y2o2GLUqaXtguDeVXz1Lt85c6Q/rCCxL57FMiEM7fbf235NjNeqN0odMNt5vKJuUhig1ZvjrczpP2C2EuHKO/cMV3pjF2L0Gv4sBvzO+3Vr1wxjBlLUQj29AwedUjCi7fmZuQPwFxNEO06IepCpkntJG92y7km6u0rMwMHkN95Nl4WY4EpnkctW+h4JHVycwW/c4VlpS9CcVFjLnQUGg7XWIVPX3oqN7n/+2jLTFlTYGiyJXpoCzmgBUrp6XNvILkj+c/8myhfn0UY5HzAKjtmlg8GGST07eLRtdaDx5A8CZ2U70MGXIAlPyvVzDtVMsG7lyujsHJQye5xtcEtS6VAtFORHQPZTPa8xr2ahaAWSExgrV8jPYhfQygvJqvKa75bsbpwQRjPpeaEiBRoU5mBX7wKiZbAzk0hBiMStfIpUOHiBP1H2Pgvjwp+q5Nf3iA/ziXjwXvuosy+mDB3QyUO0fp8iiMUpDFVUdVSM4OSrLg5ImG/2L4tDAQ2HDqZZIfdRicNU4VzIxS5WxPply9Py3qRxmeZsfFDsOO/XaIfSL/
 N6DDY8Ku
 BOph6t1odd1LiEqAxoctnS9EocjVMifTHy3jfaXM6xAajwSFECWymBUODvyUSFx9h6YrqV4UokYYHZHxert1tBx3eUxuWOpHTOwiifRnxS6NqZ597gvNSiZ7SnNm2ZFp7sZQKIviFsWlvjGmvlpknOfmFm+AEecegxix/9sIYPC9Vvkq0dlCRrWie60nnyhsd6ursyT/qKewJXUbKPc3Dl7n4BVAJszp4DVixgX0gIhSB9Y/lqDLa7Kzu76Ifql/dZ4cske7rTabi/+3MExUYEB7cmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__copy_remote_vm_str() reads another process's memory under the mmap read
lock for the whole copy, and looks the VMA up again for every page through
get_user_page_lookup_vma().

This is the mmap-lock-only form that __access_remote_vm() used before it
moved to the per-VMA lock, and it shares the same contention: an mmap() or
munmap() stalls a bpf_copy_from_user_task_str() reader even though the
string is resident.

Read the string through remote_vm_walk(), the walk __access_remote_vm()
already uses, with a copy_vm_str() action that strscpy()s each page and
stops at the NUL. Bounding the copy by its maximum length keeps the per-VMA
path inside a single VMA, so no VMA is looked up again while that lock is
held.

A copy the per-VMA lock cannot finish falls back to the mmap lock: a fault
that dropped the lock, or a string running past the VMA. Memory with no
struct page (VM_IO/VM_PFNMAP) and stack expansion stay on the mmap lock
path and still return -EFAULT, as before; ->access() support is left for
later.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/memory.c | 111 ++++++++++++++++++++++------------------------------
 1 file changed, 47 insertions(+), 64 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 273dfe12bc6d..aaf620017f34 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7296,84 +7296,67 @@ EXPORT_SYMBOL_GPL(access_process_vm);
 
 #ifdef CONFIG_BPF_SYSCALL
 /*
- * Copy a string from another process's address space as given in mm.
- * If there is any error return -EFAULT.
+ * Copy a NUL-terminated string from @addr into *@buf, up to @len bytes,
+ * stopping at the NUL. strscpy() always NUL terminates, so recopy the last
+ * byte of a page when more pages follow. A string is never read from
+ * struct-page-less VM_IO / VM_PFNMAP memory.
  */
-static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
-				void *buf, int len, unsigned int gup_flags)
+static int copy_vm_str(struct vm_area_struct *vma, struct page *page,
+		       unsigned long addr, void **buf, int len, int write)
 {
-	void *old_buf = buf;
-	int err = 0;
-
-	*(char *)buf = '\0';
+	struct folio *folio;
+	int bytes, offset, retval;
+	void *maddr;
 
-	if (mmap_read_lock_killable(mm))
+	if (!page)
 		return -EFAULT;
 
-	addr = untagged_addr_remote(mm, addr);
+	bytes = len;
+	offset = addr & (PAGE_SIZE - 1);
+	if (bytes > PAGE_SIZE - offset)
+		bytes = PAGE_SIZE - offset;
 
-	/* Avoid triggering the temporary warning in __get_user_pages */
-	if (!vma_lookup(mm, addr)) {
-		err = -EFAULT;
-		goto out;
+	folio = page_folio(page);
+	maddr = kmap_local_folio(folio, folio_page_idx(folio, page) * PAGE_SIZE);
+	retval = strscpy(*buf, maddr + offset, bytes);
+	if (retval >= 0) {
+		/* Found the end of the string. */
+		*buf += retval;
+		folio_release_kmap(folio, maddr);
+		return 0;
 	}
 
-	while (len) {
-		int bytes, offset, retval;
-		void *maddr;
-		struct folio *folio;
-		struct page *page;
-		struct vm_area_struct *vma = NULL;
+	*buf += bytes - 1;
+	if (bytes != len) {
+		copy_from_user_page(vma, page, addr + bytes - 1, *buf,
+				    maddr + (PAGE_SIZE - 1), 1);
+		*buf += 1;
+	}
+	folio_release_kmap(folio, maddr);
 
-		page = get_user_page_lookup_vma(mm, addr, gup_flags, &vma);
-		if (IS_ERR(page)) {
-			/*
-			 * Treat as a total failure for now until we decide how
-			 * to handle the CONFIG_HAVE_IOREMAP_PROT case and
-			 * stack expansion.
-			 */
-			*(char *)buf = '\0';
-			err = -EFAULT;
-			goto out;
-		}
+	return bytes;
+}
 
-		folio = page_folio(page);
-		bytes = len;
-		offset = addr & (PAGE_SIZE - 1);
-		if (bytes > PAGE_SIZE - offset)
-			bytes = PAGE_SIZE - offset;
-
-		maddr = kmap_local_folio(folio, folio_page_idx(folio, page) * PAGE_SIZE);
-		retval = strscpy(buf, maddr + offset, bytes);
-		if (retval >= 0) {
-			/* Found the end of the string */
-			buf += retval;
-			folio_release_kmap(folio, maddr);
-			break;
-		}
+/*
+ * Copy a string from another process's address space as given in mm.
+ * If there is any error return -EFAULT.
+ */
+static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
+				void *buf, int len, unsigned int gup_flags)
+{
+	int bytes, err;
 
-		buf += bytes - 1;
-		/*
-		 * Because strscpy always NUL terminates we need to
-		 * copy the last byte in the page if we are going to
-		 * load more pages
-		 */
-		if (bytes != len) {
-			addr += bytes - 1;
-			copy_from_user_page(vma, page, addr, buf, maddr + (PAGE_SIZE - 1), 1);
-			buf += 1;
-			addr += 1;
-		}
-		len -= bytes;
+	*(char *)buf = '\0';
 
-		folio_release_kmap(folio, maddr);
+	bytes = remote_vm_walk(mm, addr, buf, len, gup_flags, false,
+			       copy_vm_str, &err);
+	if (err) {
+		/* The contract guarantees a terminated buffer even on error. */
+		((char *)buf)[bytes] = '\0';
+		return err;
 	}
 
-out:
-	mmap_read_unlock(mm);
-	if (err)
-		return err;
-	return buf - old_buf;
+	return bytes;
 }
 
 /**
-- 
2.53.0-Meta


