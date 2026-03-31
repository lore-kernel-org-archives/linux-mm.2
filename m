Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 252F810F9306
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 22:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0076B0092; Tue, 31 Mar 2026 18:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597996B0095; Tue, 31 Mar 2026 18:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D95A6B0096; Tue, 31 Mar 2026 18:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DCC16B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:24:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2B88E046D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:24:36 +0000 (UTC)
X-FDA: 84607788552.25.BBC41BD
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1B29A12000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:24:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=jnOfoCQ4;
	spf=pass (imf29.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774995875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Gk6gK2g/iUCDplXURqYnZlRZrUKX5MMD32teE9LYFVY=;
	b=5XDO8vuKx2QcJy9+cJ5x7iuqniswRw2kkZJ/+aviXeXoR6KPYH44A0PzXTqgnFbY0crvjg
	Epcvt9MK/k+oPMj677GlGPwuD4Z+ecVtIwu4DML25nNW542aRVKcJxXg5qP7XmPiK7Irlp
	sWrxmdS+h6Go64I9taF6wu8YenJ98K8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774995875; a=rsa-sha256;
	cv=none;
	b=aM6X0kG2ZPOsVd5X4D5Veq5zhEccsDIJnr/S6Nqqq6CxF1h31hV00oG8egjKagkt8b+uEb
	P634wV7Okhyd0fnatZtwsOH3NWxtVaoikeC+UG28r3RXH4hnTyX7Hezm3a+tHdleDV9shD
	YHJ/wNtrO8JWx0xac/fmKdjhV/IdwgY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=jnOfoCQ4;
	spf=pass (imf29.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from skinsburskii-cloud-desktop.internal.cloudapp.net (unknown [4.155.116.186])
	by linux.microsoft.com (Postfix) with ESMTPSA id CDA1120B710C;
	Tue, 31 Mar 2026 15:24:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CDA1120B710C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1774995873;
	bh=Gk6gK2g/iUCDplXURqYnZlRZrUKX5MMD32teE9LYFVY=;
	h=Subject:From:To:Cc:Date:From;
	b=jnOfoCQ4KDTTeJ/mrmxhv1a/aDYF85mLq1D0RHXAv/zNXsJHUtociJ3WSdtkoz2Le
	 xPOC2todCsYSOOwg0oUN5KZHkiPAwEHItUVOD336ISvWKQ/hQiIOTIR3txQBoeCfzb
	 TbVuPwOhSuQE6DOoZCeFVrvHGGA8ELYMFYaIdCvc=
Subject: [RFC PATCH] mm/hmm: Add userfaultfd support to fault handling
From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
To: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2026 22:24:33 +0000
Message-ID: 
 <177499585916.169073.8313365481186071940.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: aonq3mb8ejprtaszpoe3ecome54zx49y
X-Rspamd-Queue-Id: 1B29A12000B
X-Rspam-User: 
X-HE-Tag: 1774995874-979265
X-HE-Meta: U2FsdGVkX1/HoLXKIcL2jatU3KjJy5U1+7ulKykgzVM9lmByPb/h/bXZQcBzwxrql8nO40Hpwz5rGDjRFZicEh4u0gIrInOIpf3Nkiyy8+vC7kdO1X7btqHjoZPb8giiBwm0iMpKsC4UlbKtbwmdl1ejYloZAxBtj487n0SHCIMMHXzCxFrVYIEDnLR5IxCsvuLmDnwygvSSIypN8wk5akWcF/fheNKHrP+HmxEZfmyS8wVOaLBUaJKqrC8clRGeUNLHuTfgO2yRtdiwu+G2lc+tKHxqKlRuHoQdMvruhq8+dskGgXnvtS++Ny14OC+cz+8azlUyiX7ylfV8110PY2zN1sPtPa3fMa23mUpDDIYdjA4Nbm0iOlKiua7avRyw6/BnKrFMylcMqMraeyFkNRxuOuT6IZ+5YLA8eLZIzmKKxwkONvfzY8gZG1vrNTHPM3QEjKh1dlAfDUkY15Yid9FUXwsWnGjBXiS3KzppdCvmR6BMC8Da6wa5zEixmfNPyMbzrd5XCUbZ4zxzdtHnRKQqdHD2VgyLW59zamm97M/zY8nFswzBwNU/V/7OPsnsy7H8O8sXhOP1MbIuYoq2TRVmljhqy6j7N6BxCtJsn+RoJOq2pm8Yw6DUNTBdTfN+KR5fCKcybjofiPu3ZAK6vucBVh8ODRWL7bh5oHZuy152gkyMTUIGFun6y61cuoBebtZ93BIddvdwj+Y7Da08a7fymG1Wjyr2KcgG2/X17iQhe7CZiIK7j0BkMS0r8Ap6Qc7kG/bb38czvIDB4oD3T7cK/p5s4j2gOG2sEs+Tz1DGVeCztx2lxHp7dzyMjly99Eh9Zp5b3vUOPH6qkv2P+pe+ZV3ys/kinlGVBnPJ98gSShuk4muYmbxEto6ySkSc4QABK0S7MZOeCGI9D+6CyuP1eUW6H/xsTbi5fX697kQxQyU5oaCNCLsMOk6ZlimuGylSpaH5QmFc8ksYR08
 cv2CHPxd
 FhlBE1DIWNH0dWHzuUworCmEDOXK5xYqALvZPOlUWDzUbycBSj9QqWMB7X9Crm3nM0Rqy4AOcM8jtWR6qUDqkCnMRNYyDtdz2dDV1qoiHlItcvts+aZMHpBCnR3XNo0ApAeUkIgwqQEFUtypV1G+sxE6t/1hXN3wDe5xlxxe70GTMQtnj0bUsE9Eun8SNtCp7AX+p8WpASR8q2v82bL2hfFN5iEPS0bmkkJMcvf7WOKM5o8lkE7sOJF8BZRLguA/WbZhd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for userfaultfd-enabled VMAs to the HMM framework.

Extract fault handling logic into hmm_handle_mm_fault() to handle both
regular and userfaultfd-backed mappings. The implementation follows
fixup_user_fault() for handling VM_FAULT_RETRY and VM_FAULT_COMPLETED, with
a key difference: instead of retrying or moving forward respectively,
return -EBUSY after reacquiring mmap_read_lock. Since the lock was
released, the VMA could have changed, so defer retry logic to the caller.

This approach is inefficient for userfaultfd-backed VMAs, as HMM can only
populate one page at a time, but keeps the framework simple by avoiding
complex retry logic within HMM itself.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
---
 mm/hmm.c |   40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index f6c4ddff4bd6..d04d68e21473 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -59,6 +59,35 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 	return 0;
 }
 
+static int hmm_handle_mm_fault(struct vm_area_struct *vma,
+			       unsigned long addr,
+			       unsigned int fault_flags)
+{
+	int ret;
+
+	if (userfaultfd_missing(vma)) {
+		struct mm_struct *mm = vma->vm_mm;
+
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY |
+			       FAULT_FLAG_USER;
+
+		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
+
+		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
+			mmap_read_lock(mm);
+			return -EBUSY;
+		}
+
+		if (ret & VM_FAULT_ERROR)
+			return vm_fault_to_errno(ret, 0);
+	} else {
+		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
+		if (ret & VM_FAULT_ERROR)
+			return vm_fault_to_errno(ret, 0);
+	}
+	return 0;
+}
+
 /*
  * hmm_vma_fault() - fault in a range lacking valid pmd or pte(s)
  * @addr: range virtual start address (inclusive)
@@ -86,10 +115,13 @@ static int hmm_vma_fault(unsigned long addr, unsigned long end,
 		fault_flags |= FAULT_FLAG_WRITE;
 	}
 
-	for (; addr < end; addr += PAGE_SIZE)
-		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
-		    VM_FAULT_ERROR)
-			return -EFAULT;
+	for (; addr < end; addr += PAGE_SIZE) {
+		int ret;
+
+		ret = hmm_handle_mm_fault(vma, addr, fault_flags);
+		if (ret)
+			return ret;
+	}
 	return -EBUSY;
 }
 



