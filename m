Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 786BCFF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 07:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A064E6B0005; Sat, 25 Apr 2026 03:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6E16B008A; Sat, 25 Apr 2026 03:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC6F6B008C; Sat, 25 Apr 2026 03:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7AC8D6B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 03:07:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C16BC1371
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 07:07:26 +0000 (UTC)
X-FDA: 84696197292.03.6638925
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4390D10000E
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 07:07:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=stu.xidian.edu.cn header.s=dkim header.b=u0CJDgFM;
	spf=pass (imf05.hostedemail.com: domain of 25181214217@stu.xidian.edu.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=25181214217@stu.xidian.edu.cn;
	dmarc=pass (policy=quarantine) header.from=xidian.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777100844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Wq+g7VMXuN3cNKdQxZ/XBxYNAEgVEoQ0dq8X+4OPGLY=;
	b=xyLVjYnvfYmYKWrGTS6wIpGnmTQmtQ48UuOBP+hcIzv2/tdFfB6Z9I/rtmHoPyZmb22ey2
	L3Zb6V26h5vNoEu/wdMpR5h+cE/JEov7pn4Fiq9ri7XHFUK51cn12gIiqmub07ML9cUOlp
	uJj9malhlAQvP8fbuwju+IDbWGJF6BQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777100844; a=rsa-sha256;
	cv=none;
	b=RJXLdpGX2NTt2YxkMRfWmjUOWojaxGebcWC/0hQLfMLFuThYa5G6Q550avve2lgKt/ZZ9c
	yCzWzCy7j0plcezGpB+rBGhfh+EplH1g+hToTHmMpOldkJu+NcpBHDDIGSvaPcBXqp12rm
	kVbqmfGUqKWHvgYPc37VYrG1J/d7POk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=stu.xidian.edu.cn header.s=dkim header.b=u0CJDgFM;
	spf=pass (imf05.hostedemail.com: domain of 25181214217@stu.xidian.edu.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=25181214217@stu.xidian.edu.cn;
	dmarc=pass (policy=quarantine) header.from=xidian.edu.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=stu.xidian.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-Id:MIME-Version:Content-Transfer-Encoding; bh=Wq+g7VMXuN
	3cNKdQxZ/XBxYNAEgVEoQ0dq8X+4OPGLY=; b=u0CJDgFMk4XlIu2yAedGYJmku8
	eytSrNL8+QuuTsh3bP6gavj9cci5OJjC3reD+lGfm+pOmr9qsU2hLqfVrqYHIinU
	SLi1o+KParn9KF0DC+iWZwF+WHzH5ZRAHLYQMkvTXyVpR8hHq0voLJgiSOqmeT3k
	0mTw25to/rZdAtN8w=
Received: from wmy.localdomain (unknown [113.200.174.100])
	by hzbj-edu-front-3.icoremail.net (Coremail) with SMTP id BbQMCkAWNjAXaOxpxp7AAQ--.17089S2;
	Sat, 25 Apr 2026 15:07:13 +0800 (CST)
From: Mingyu Wang <25181214217@stu.xidian.edu.cn>
To: muchun.song@linux.dev
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>
Subject: [RFC PATCH] mm/hugetlb: fix resv_map memory leak in __mmap_region error path
Date: Sat, 25 Apr 2026 15:07:00 +0800
Message-Id: <20260425070700.562229-1-25181214217@stu.xidian.edu.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:BbQMCkAWNjAXaOxpxp7AAQ--.17089S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWxCF1UCFy5tFy5Zr15XFb_yoWrGr47pF
	s8Ww45Gr4kJ3sI9ws7Aw4DXr1Ykrs2gFWUKryrKw4fXrW3G3Z2kF4rXFWjvr45Ars2v3W2
	vr4j93y7X3WjvFDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9C14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r1j
	6r4UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
	Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
	W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI2
	0VAGYxC7MxkF7I0En4kS14v26r4a6rW5MxkIecxEwVAFwVW8CwCF04k20xvY0x0EwIxGrw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRwXocUUUUU=
X-CM-SenderInfo: qsvrmiqsrujiux6v33wo0lvxldqovvfxof0/1tbiAQUOEWnriVmBUwABsa
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4390D10000E
X-Rspam-User: 
X-Stat-Signature: ko6ngb3az6u1mksxpdgu6e8yrbz1mnkz
X-HE-Tag: 1777100842-280859
X-HE-Meta: U2FsdGVkX18SVySKqWV1v/IqzxNJlkrJudfLQ1z5/6/ghSInE9dRMeDu/hJC79CVbAVUv/KZ68WQeJsAgzIDsdIEKdoLokVJb+GWoBOjDkygdsywriKCBzffxpY1Ge8Mz0p73/AsCaEFmXrp8EDmvMLJ9ifwf0TYkn/ATLif53Rn1LqFLmcJAqcVMK5wD8H3nnP6TaB1AdUzk28/bXLs92tM8UVI5scxRbGYBnXi6yKCJcGrRAHCUrFilJvJhhELbfWKRH68/dDmGtexVRGjsPVVzxfKWlRi3zka8WgxzSRbIG+uOoZVrGqTYS30fgrYANGVwZEVmMmTduVsI8SxCNxi/fnGOgCM9A1Pv/a6UdK7VJbF8vIvuOVQD2geQumD5ShX/fKCpybF27KSjTdCTjIevABWyXi08YAy1Vfd1QI4zLSCN00GJ/Vbx7fk2iugMWD+ev1bFzyt24xxt7k416MIA+BA5Rknv6z7N566B8Qr0/zwjs/fGIlRPimxOE7AT5uaItmx6HhdANX8hY8V5H8Y1GUNJb+xGCXtKB5p7jX1pEsW2wnsdAQzWkxmNhtjphaTz7i7VON7GN/rAHQ3aLqjfh1atM/woiL+g1pNB6FScBdXMFmjDitgf0vW061uZavWY9ZqvfcNd5gPurCqRB9mnYZpUdLYSESnppt9Mmi/YZEnRXPrVYasAqsj/RwD06Nl5SxPPhF34EAJNH/XAtJlEy7KM++4YUzs53V82JNhya6nBaeobWagxbj1mMKkXiEa5IL0q74TAya7OdZR8UCj2qxkDEwli42QGbs7PTsSfC5emMlU1j+L/EprN2iBFxKXVwypw+6y0RXGvdHR5uBSBnjZsvMhrTY22xyC4trvnT+bUqE91UOFaWdrmb3qiCHaGFpfYUierSDub/lHnCQy02h8aWJnTCtatbsElwQ447ONPfQ0LQD8Y3IKAoyKCHi9J6VcT1vDPDarloV
 k2PD64ci
 8LigEGDUFg1mqptlY4TIQkKjuSsnT8KMzcG2sTkCD4lsZlQ6OYxCK1oP+8X6M8fjJ+gevQil9mpS6VgasCjNvTYdl5SsyaDsg3e6UqPfc1VAZhSrk9g55h03aRzZ0phA6lCX2dSNqfQ/Y6YFHlYD6msRJWdSXpf90iGmqAy2HlfIyE9RRp1vZ3BcczCppfR7D0/VLpfrGvjl+aoLT0vVOYQHHOGwRICfEHnN2XXuAwkL3m+v7HyadZ+XJsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While fuzzing with Syzkaller and fault injection (failslab) enabled,
I observed a persistent resv_map memory leak in the hugetlb mmap error path.

BUG: memory leak
unreferenced object 0xffff888110b92400 (size 512):
  comm "syz.0.5386", pid 20390, jiffies 4298157188
  backtrace:
    __kmalloc_cache_noprof+0x509/0x6e0
    resv_map_alloc+0x47/0x3a0
    hugetlb_reserve_pages+0x758/0x1220
    hugetlbfs_file_mmap_prepare+0x492/0x790
    __mmap_region+0x1ae6/0x29f0

This is a regression introduced by the recent VMA iterator and mmap region
refactoring, which decoupled mmap preparation from VMA completion.

In `__mmap_region()`, `call_mmap_prepare()` triggers `hugetlbfs_file_mmap_prepare()`,
which successfully allocates the `resv_map` and registers a `success_hook`
in `desc->action`.

If `__mmap_new_vma()` subsequently fails (e.g., `vma_iter_prealloc()`
returns -ENOMEM due to failslab), the code jumps to `abort_munmap`.
However, the `desc` structure is completely discarded without invoking
any cleanup. The newly allocated empty VMA is freed, but since
`set_vma_user_defined_fields()` was never reached, `vm_area_free()`
doesn't call `hugetlb_vm_close()`. Thus, the `resv_map` is permanently leaked.

This RFC proposes adding an `abort_hook` to `struct mmap_action`
so that subsystems can properly clean up resources allocated during the
`mmap_prepare` phase if VMA creation fails.

Any feedback on whether this architectural approach is correct, or how to 
properly implement the hugetlb unreserve rollback, would be highly appreciated.

Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
---
 fs/hugetlbfs/inode.c     | 9 +++++++++
 include/linux/mm_types.h | 2 ++
 mm/vma.c                 | 4 ++++
 3 files changed, 15 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 8b05bec08e04..002bb6d9ca23 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -102,6 +102,14 @@ static int hugetlb_file_mmap_prepare_success(const struct vm_area_struct *vma)
 	return hugetlb_vma_lock_alloc((struct vm_area_struct *)vma);
 }
 
+static void hugetlb_file_mmap_prepare_abort(struct vm_area_desc *desc)
+{
+	/*
+	 * TODO: Implement the proper rollback for hugetlb_reserve_pages()
+	 * and drop the resv_map reference held in the desc here.
+	 */
+}
+
 static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
 {
 	struct file *file = desc->file;
@@ -172,6 +180,7 @@ static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
 	if (!ret) {
 		/* Allocate the VMA lock after we set it up. */
 		desc->action.success_hook = hugetlb_file_mmap_prepare_success;
+		desc->action.abort_hook = hugetlb_file_mmap_prepare_abort;
 		/*
 		 * We cannot permit the rmap finding this VMA in the time
 		 * between the VMA being inserted into the VMA tree and the
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..9320f6699fa9 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -861,6 +861,8 @@ struct mmap_action {
 	 * it is not valid to clear the error here.
 	 */
 	int (*error_hook)(int err);
+	
+	void (*abort_hook)(struct vm_area_desc *desc);
 
 	/*
 	 * This should be set in rare instances where the operation required
diff --git a/mm/vma.c b/mm/vma.c
index 377321b48734..d64cea5b4335 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2799,6 +2799,10 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	 */
 	if (map.file_doesnt_need_get)
 		fput(map.file);
+	
+	if (have_mmap_prepare && desc.action.abort_hook)
+		desc.action.abort_hook(&desc);
+	
 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
 	return error;
 }
-- 
2.34.1


