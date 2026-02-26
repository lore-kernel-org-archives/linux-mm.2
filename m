Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B87CFC5933
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F46F6B0096; Thu, 26 Feb 2026 06:33:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6046B0098; Thu, 26 Feb 2026 06:33:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D84B6B0099; Thu, 26 Feb 2026 06:33:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AFA46B0096
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:33:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 032B3140B4E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:33 +0000 (UTC)
X-FDA: 84486397548.03.ED86C4B
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 57E19100009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hUNYtyZh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105612; a=rsa-sha256;
	cv=none;
	b=7iCDeJjGOLpdqM4O4fppk687WdAPMX8x8xPK+JlCt9xHeuUXgDkpYaWAC4OOwJ362C0NVm
	zTlr4mc520R9kpVxIVkr2qFHQT/iIaUdktQJ3t/1/qGI0lSBovfcjA2n7gi1iCZtfk+NCn
	BIXXGc7gNUMa6j4ZuewpcAed23Irl/g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hUNYtyZh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcjsQV50nDatk8NFhsm3n/z/wAZY5b80YB+EzBptEz0=;
	b=row3Ot4Tf/jYnVn0ac/ZnOM9fZ3gXxqCZNNuv1i+9NXN77OyBEEKKgzpuSvgYIn7+w/X/I
	EHVh/VzC1xSt9PJaR2vudm09I7rD3rWzmyjtgV5U372sNqzTi2V3u8EkmY9TZ/fRsMvwgr
	9MeXyJgfxgpUbD+bF3vmb8MLLLg3Lu8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HcjsQV50nDatk8NFhsm3n/z/wAZY5b80YB+EzBptEz0=;
	b=hUNYtyZhaqlksnd9AfSZRt096lmVApHmXGQuSN2BpnlEr3x8YHG94GOzMTUoa/3r7gWEkq
	45emp28Vxqc7n2wBQVg1LWyfVHtjlcaJ4w3bF7QR+JjA9SJu1LjAHrKEC+xPZYvhAhbt9r
	GhTu0cvDNKxZfXQZTdIFSvNtBxE363I=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC v2 05/21] mm: thp: handle split failure in zap_pmd_range()
Date: Thu, 26 Feb 2026 03:23:34 -0800
Message-ID: <20260226113233.3987674-6-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 57E19100009
X-Stat-Signature: jysczmdp8f9se3pitfhitny1xmnbmz18
X-HE-Tag: 1772105612-276908
X-HE-Meta: U2FsdGVkX183tv26SxmFyrtp1nJav9vqqL05q3VefFktuU5y2W7qC1ER3rHuKvmvPNFJ/U/rwrgJF7Lwm8DPcqsnXvwcWw1XNyDjOPuqzjfeGFpK4WPRBeImFphWiPORsA8WZyA328w3yn2brGxcK4X5BjHLJ7npVpSi15w61xYtZJu6FSiC/rjTaXzu4OBVYMukus3mEJqlTueSzsh+GIbe/L6JcoeY/UJhzMdFmCA/Nta0MY6bJIs+VpIWl7GKOrzOZmfy8xvtixYdE76vF5aNeticAFPbtUcyDZti5Enc3DHPXSTu/k9huP47tbABv+5OI9BrPoY2BkShRZFL8mLrhZFUdMo2N1jddEEu3R91Ne8ZtTJ/J7SEw9hwicMVTnrovdN+tBqiW20WQMyelWQz3rLObl7/REfLpoyzYJPhKAPd4BMqvYeTAmtHl8tyYotohBwFp/LAmH9uTU7N7x2Xw98mZST7Zdg2F4xFyqLrH/NJW50TmbMvsInCpTvzQq3zmx5UlT9X5sq56uSem7XB/J9MxRNyH/6KgVzyTq587iIujA/7iOcZoOBpZOGUWpPcM8sOOJG7oQUd6MtJDovjJyEDpAZzDH9xFl4moo54EqQocsODXL6RwDkS+0jrkmiKtFu8grJTmWOPbD8VsiOhwTpYPkeoQKlvS099gJKY7Fiyk/0h0V/sqe+AYC/EUFwbgaRmDjAQNd3txZl97il9MVT56IsIBiJpCREiXJfjofqErcfE0jkC0bv5tQhK1GbGV6P+l/lUujkbh4Y7QjLIme3QtER3ntcLyte3x9rN1QOqEvQL/uvrueii15F3vvWSnmKfpuq4HxDMhLnYw+N9bPU0YAgP9cmh4KOROIfD9UcrTnNh19KhLSdxoRPgChzqrYm67u9L0LqkYayi1JKAy6x0WuvTiml+rGB9KtLVvc/VfQKuRbvQjUId/fH43e8BkLns42CmGtVR9vm
 Z7bmxEu9
 tvanGaUfJDLSlbNzMY8ivtJX8Z37BNJuyhUFn3jrPNy0254DDoPC3cZLGfcik4pUeCKYwUkXQU/b1st2ZhP4GrENrOc89LQnC4WUSlKjvPIiSPLmK531L0AQSYMjqMMWnWIJdANXWvxDZ4KAmCC+z0+7WXOQszJc0uzp2AlYQiWaXSl1hAvFsIyZLhnwlDmwLktNRcgV634FPDB82yWS5gXAwwc44Wt9MLrPLfJQA5swGROeMwIaXjhKGG2kAQqw7b6iJ6xheZOwgt7OuyzkQwbncvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zap_pmd_range() splits a huge PMD when the zap range doesn't cover the
full PMD (partial unmap).  If the split fails, the PMD stays huge.
Falling through to zap_pte_range() would dereference the huge PMD entry
as a PTE page table pointer.

Skip the range covered by the PMD on split failure instead.

The skip is safe across all call paths into zap_pmd_range():

- exit_mmap() and OOM reaper: the zap range covers entire VMAs, so
  every PMD is fully covered (next - addr == HPAGE_PMD_SIZE).  The
  zap_huge_pmd() branch handles these without splitting.  The split
  failure path is unreachable.

- munmap / mmap overlay: vma_adjust_trans_huge() (called from
  __split_vma) splits any PMD straddling the VMA boundary before the
  VMA is split.  If that PMD split fails, __split_vma() returns
  -ENOMEM and the munmap is aborted before reaching zap_pmd_range().
  The split failure path is unreachable.

- MADV_DONTNEED: advisory hint, the kernel is allowed to ignore it.
  The pages remain valid and accessible.  A subsequent access returns
  existing data without faulting.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/memory.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9385842c35034..7ba1221c63792 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1983,9 +1983,18 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 	do {
 		next = pmd_addr_end(addr, end);
 		if (pmd_is_huge(*pmd)) {
-			if (next - addr != HPAGE_PMD_SIZE)
-				__split_huge_pmd(vma, pmd, addr, false);
-			else if (zap_huge_pmd(tlb, vma, pmd, addr)) {
+			if (next - addr != HPAGE_PMD_SIZE) {
+				/*
+				 * If split fails, the PMD stays huge.
+				 * Skip the range to avoid falling through
+				 * to zap_pte_range, which would treat the
+				 * huge PMD entry as a page table pointer.
+				 */
+				if (__split_huge_pmd(vma, pmd, addr, false)) {
+					addr = next;
+					continue;
+				}
+			} else if (zap_huge_pmd(tlb, vma, pmd, addr)) {
 				addr = next;
 				continue;
 			}
-- 
2.47.3


