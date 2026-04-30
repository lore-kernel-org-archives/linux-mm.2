Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D693FF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 04:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 711386B0096; Thu, 30 Apr 2026 00:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C26B6B0099; Thu, 30 Apr 2026 00:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8D76B009D; Thu, 30 Apr 2026 00:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CED56B0096
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:05:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F7CCA0235
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:05:01 +0000 (UTC)
X-FDA: 84713881602.04.7210B1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 717C71C0006
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:04:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tDZQx6oM;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777521899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bf7vm9FSShse5cDViAIh5UivYdtJOMGEwi5WpcSQ7Is=;
	b=ig5WeAHv+83pgXVly3fera17oeWhSgrzO0esZjfs6C1g+ff7AciQK28FIWkPLXUiEQvOwu
	s6wesNITff9+4YlTM+iYdWsulPEl2Ic9O0qSGdCeozpRfb5IUi5rVENTyBIW4OHH9UeSHB
	TSk497ebYg9w9fZa+cCseDLxSePWKQI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tDZQx6oM;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777521899; a=rsa-sha256;
	cv=none;
	b=IsmAqMGisHWoTrLIoMXW52ink8Wm1C7uR4h0w4EzzOj/RPUEYW4HcJGJmyZyHhlXrFcuB/
	kaSLQej8SjQ87JhgTfVPyqZekK2wjkdEwUfcl4Np/t+Puy11sxwbYcVyMvGyeVZnbfAv39
	tZMYZyi/7sNqAx68A7qxfDnuSUYETcc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E5C8561141;
	Thu, 30 Apr 2026 04:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3EFC2BCC7;
	Thu, 30 Apr 2026 04:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777521898;
	bh=Bph0u8wp8/lT6x+zIK7zTGylHyQ++q1X8M3Sbba/pLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDZQx6oMyj/Pbp4oBZWlhtLtNlz20xltWaQQB7lkuzfNAsCqOFPj1LDkODNunAa/l
	 2By5McbFvCHbx4vd1YOH1CgGYWq47II+aDe8CMmYB3kuvppesXkGksqverSZ3qGPIU
	 VKF7cIFaSqdwzevlCnjgHtL/gURYNW12fE4YtXp4gq3rPI4AQcGoZQHGnEYTMVrI99
	 T88uENlzRWQhIDjN/pZcjvAfUvgg81aDjgHE6Gwn7VPmdmS8mvmNv0wWK/a+u+e/6G
	 Saw+bXv1YLhhn5fwyqZhztWdHAozVqlrG2Vsrs64/3e0lRUNv1XjbrN+Qi0mKHxbyF
	 M0Zmb6n7L2IMw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	willy@infradead.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jack@suse.cz,
	pfalcato@suse.de,
	wanglian@kylinos.cn,
	chentao@kylinos.cn,
	lianux.mm@gmail.com,
	kunwu.chan@gmail.com,
	liyangouwen1@oppo.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	Barry Song <baohua@kernel.org>
Subject: [PATCH v2 1/5] mm/filemap: Retry fault by VMA lock if the lock was released for I/O
Date: Thu, 30 Apr 2026 12:04:23 +0800
Message-Id: <20260430040427.4672-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260430040427.4672-1-baohua@kernel.org>
References: <20260430040427.4672-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 717C71C0006
X-Rspam-User: 
X-Stat-Signature: 15cypqp4m1a7maifw6nuroxwn3wbu9gh
X-HE-Tag: 1777521899-192208
X-HE-Meta: U2FsdGVkX1+32Q5nTeDEKrx3XL4yZUYPCj6okiM/F1+6a+hC8/EcOTlcUe2ohBNEv+3eRRn18rrQ0UYTh6796RduqiaFF5rYxgU4kSiTJ4uj3YyD1I+iTLy96Q10w4GFnpQAJw9Pfv0dTVPb2e4YWQy5LPG6pkcTnZjqNWkQWHnPgx5XSGqRa1wBHEb1PaLFA1USx4JG9UeyrwL3Xl7Yxkn83hnbqC6W4T7aPCRidGXu7vvUVUvaInPxmyT6CRsG0Bqa8BNSxuk3mbSE+2rPLnOaaRiCxxChjZVSrzVyTR1IsCxjOizd7DWQYs/DpydyVmX5SSXqQFp8iEhgvNu66Iw82wNbsvPDgJzk7DdsQzUMf9GyiHne1L84ybAmE35k4SNnY1QPDF0bHri5k76t5BOOCg2oot5ZYeMiTrA0eFU1ylZzHbGyO7Ab4MI29Vg5B/pzW/kaKFCJbzeKAGPWlMkcMK8WkUIEU07I9gPb8Q02aOpHzsQlO7T+uDZwpV6f5i/yDFtyGmQ7uZGWN7ASPScdyiXDK12X5c/mGDIHqd6bpFwZyVRGAPsfgrCb48vLuwSUam1QrBwhs/rdQ3Eb608Ns7Q/H4ugnZN4aySUQgzckU0ag5/aKwH32yfsReTOFXAxlhK9p3hb3SNdaZYE2hmTesxSA/T8uWNtRKQTRDk66bRvpKZLRiqMyFQKAK710mhgcS+CJjVvPuYYRJRNQwV+17VBm8GTvxnnVGVXFUr3h3JV9GX+pr81WEtc/2Mn3tuaVEIP2p3N7gXr4sHPsRMoV07yjLsAMnTgbIcyFEZg9/w6XUquxOe00M2faE57RTlKhVSizvIwjw2nT9/51gtlbcl/FWHVV5XV0uUVzyZrjaFvdDDd2iZij6BetAdHdzkrIvbsS9ic1nHSK9mtrJv3wOXCSaljYztO2jEz7FGCyuvtsFrVG635NhVbQepqC59+QuS/QGVqfDe8BaW
 GAZSi7Gq
 aDYrMWrbM2FXzNw+wxRvcuaj0Z6xrNdofZS4h+hv7wOkuLRc7aO6Jkh513C/z0mgjLDBT+vVUZhYPbBkYqlOnbhGzj/qS1nJWjIUxI5b+F59IH6mnOCSbqeH7/Ox06KSwFrH1PGOfW+ZO6Wg2nlEuTtqdqyKa2YHv0Ury1520a5WkTBjR50a3CdO984sVCOt888mq14YOki3zvTIisYJSKME3pjHkEycucuIbYaqnu+CI0C+P8I3FR0cKxJ95vPZox2xs3WyluOsAJBm4GKUdw0KcsbG+EBSQhQCdI7Vsz36qjDCGW53ToLPdw08+oMFpNxzZibFZ5lt555ai0hK2rRaHMjG3LiWIoeJN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Oven Liyang <liyangouwen1@oppo.com>

If the current page fault is using the per-VMA lock, and we only released
the lock to wait for I/O completion (e.g., using folio_lock()), then when
the fault is retried after the I/O completes, it should still qualify for
the per-VMA-lock path.

Acked-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Wang Lian <wanglian@kylinos.cn>
Tested-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: Wang Lian <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Oven Liyang <liyangouwen1@oppo.com>
Co-developed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Barry Song <baohua@kernel.org>
---
 arch/arm/mm/fault.c       | 5 +++++
 arch/arm64/mm/fault.c     | 5 +++++
 arch/loongarch/mm/fault.c | 4 ++++
 arch/powerpc/mm/fault.c   | 5 ++++-
 arch/riscv/mm/fault.c     | 4 ++++
 arch/s390/mm/fault.c      | 4 ++++
 arch/x86/mm/fault.c       | 4 ++++
 include/linux/mm_types.h  | 9 +++++----
 mm/filemap.c              | 5 ++++-
 9 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index e62cc4be5adf..5971e02845f7 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -391,6 +391,7 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, addr);
 	if (!vma)
 		goto lock_mmap;
@@ -420,6 +421,10 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 			goto no_context;
 		return 0;
 	}
+
+	/* If the first try is only about waiting for the I/O to complete */
+	if (fault & VM_FAULT_RETRY_VMA)
+		goto retry_vma;
 lock_mmap:
 
 retry:
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 739800835920..d0362a3e11b7 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -673,6 +673,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 	if (!(mm_flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, addr);
 	if (!vma)
 		goto lock_mmap;
@@ -719,6 +720,10 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
 			goto no_context;
 		return 0;
 	}
+
+	/* If the first try is only about waiting for the I/O to complete */
+	if (fault & VM_FAULT_RETRY_VMA)
+		goto retry_vma;
 lock_mmap:
 
 retry:
diff --git a/arch/loongarch/mm/fault.c b/arch/loongarch/mm/fault.c
index 2c93d33356e5..738f495560c0 100644
--- a/arch/loongarch/mm/fault.c
+++ b/arch/loongarch/mm/fault.c
@@ -219,6 +219,7 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -265,6 +266,9 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
 			no_context(regs, write, address);
 		return;
 	}
+	/* If the first try is only about waiting for the I/O to complete */
+	if (fault & VM_FAULT_RETRY_VMA)
+		goto retry_vma;
 lock_mmap:
 
 retry:
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 806c74e0d5ab..cb7ffc20c760 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -487,6 +487,7 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -516,7 +517,9 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
 
 	if (fault_signal_pending(fault, regs))
 		return user_mode(regs) ? 0 : SIGBUS;
-
+	/* If the first try is only about waiting for the I/O to complete */
+	if (fault & VM_FAULT_RETRY_VMA)
+		goto retry_vma;
 lock_mmap:
 
 	/* When running in the kernel we expect faults to occur only to
diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 04ed6f8acae4..b94cf57c2b9a 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -347,6 +347,7 @@ void handle_page_fault(struct pt_regs *regs)
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, addr);
 	if (!vma)
 		goto lock_mmap;
@@ -376,6 +377,9 @@ void handle_page_fault(struct pt_regs *regs)
 			no_context(regs, addr);
 		return;
 	}
+	/* If the first try is only about waiting for the I/O to complete */
+	if (fault & VM_FAULT_RETRY_VMA)
+		goto retry_vma;
 lock_mmap:
 
 retry:
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 191cc53caead..e0576e629f65 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -294,6 +294,7 @@ static void do_exception(struct pt_regs *regs, int access)
 		flags |= FAULT_FLAG_WRITE;
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
+retry_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -318,6 +319,9 @@ static void do_exception(struct pt_regs *regs, int access)
 			handle_fault_error_nolock(regs, 0);
 		return;
 	}
+	/* If the first try is only about waiting for the I/O to complete */
+	if (fault & VM_FAULT_RETRY_VMA)
+		goto retry_vma;
 lock_mmap:
 retry:
 	vma = lock_mm_and_find_vma(mm, address, regs);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f0e77e084482..0589fc693eea 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1322,6 +1322,7 @@ void do_user_addr_fault(struct pt_regs *regs,
 	if (!(flags & FAULT_FLAG_USER))
 		goto lock_mmap;
 
+retry_vma:
 	vma = lock_vma_under_rcu(mm, address);
 	if (!vma)
 		goto lock_mmap;
@@ -1351,6 +1352,9 @@ void do_user_addr_fault(struct pt_regs *regs,
 						 ARCH_DEFAULT_PKEY);
 		return;
 	}
+	/* If the first try is only about waiting for the I/O to complete */
+	if (fault & VM_FAULT_RETRY_VMA)
+		goto retry_vma;
 lock_mmap:
 
 retry:
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..5907200ea587 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1678,10 +1678,11 @@ enum vm_fault_reason {
 	VM_FAULT_NOPAGE         = (__force vm_fault_t)0x000100,
 	VM_FAULT_LOCKED         = (__force vm_fault_t)0x000200,
 	VM_FAULT_RETRY          = (__force vm_fault_t)0x000400,
-	VM_FAULT_FALLBACK       = (__force vm_fault_t)0x000800,
-	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
-	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
-	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
+	VM_FAULT_RETRY_VMA      = (__force vm_fault_t)0x000800,
+	VM_FAULT_FALLBACK       = (__force vm_fault_t)0x001000,
+	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x002000,
+	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x004000,
+	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x008000,
 	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
 };
 
diff --git a/mm/filemap.c b/mm/filemap.c
index ab34cab2416a..a045b771e8de 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3525,6 +3525,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	struct folio *folio;
 	vm_fault_t ret = 0;
 	bool mapping_locked = false;
+	bool retry_by_vma_lock = false;
 
 	max_idx = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
 	if (unlikely(index >= max_idx))
@@ -3621,6 +3622,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	 */
 	if (fpin) {
 		folio_unlock(folio);
+		if (vmf->flags & FAULT_FLAG_VMA_LOCK)
+			retry_by_vma_lock = true;
 		goto out_retry;
 	}
 	if (mapping_locked)
@@ -3671,7 +3674,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		filemap_invalidate_unlock_shared(mapping);
 	if (fpin)
 		fput(fpin);
-	return ret | VM_FAULT_RETRY;
+	return ret | VM_FAULT_RETRY | (retry_by_vma_lock ? VM_FAULT_RETRY_VMA : 0);
 }
 EXPORT_SYMBOL(filemap_fault);
 
-- 
2.39.3 (Apple Git-146)


