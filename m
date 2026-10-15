Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E78CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE04A6B009D; Thu, 15 Oct 2026 12:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68AC6B009E; Thu, 15 Oct 2026 12:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B236B009F; Thu, 15 Oct 2026 12:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BC036B009D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:08:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D76B51C4109
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:08:09 +0000 (UTC)
X-FDA: 85325342298.06.D2A67F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 040D4100013
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:08:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZYcxpNIF;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792080488;
	b=ITY3+UmrkumsmvYgHh1vSLTCvgOc4XYJpfxVCj1rau/xSqqYVVYul6/hAtJ/xkPJuwWtmy
	cJK7UB2YV4b8PjcAHoBFYX07KnXZJZKn9gkOSNcimE3Hs/TpDyAF6bkt3BIoFkHMaE50a8
	mGKM5DdWLXcgLEtNAB8pg2isYl+lJkY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZYcxpNIF;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792080488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqtt2G7yriEeHnOR1/BbpfoTCAOmwPLLgIR0/nLFghI=;
	b=YDjQihfTD+9Qu96I3aoFMukKLwfonfLP8rH/glZrlAeZ7pNc9+4+PSHlQcGAOXy7Sp948q
	RtC3MddEHl3PbBAF6TiTIO4wStnPSnrxmbQ/5t4bZtru0CXWZp8f6/It5SgeoT+m1Ype6C
	L4kpMU25Qnfj4jtbVOfu1wgUbHKnLiE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3291F41089;
	Thu, 15 Oct 2026 16:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3A01F000CC;
	Thu, 15 Oct 2026 16:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792080487;
	bh=eqtt2G7yriEeHnOR1/BbpfoTCAOmwPLLgIR0/nLFghI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZYcxpNIFmgCQLbJ6gKyzpvUn7tozj4+2u7vUUUL+7Aqo1W3aYwEw8PGzXGi32Wvij
	 OxjNg5lRcSvx811juXHVi5R43K/h+tHrxDIlWq4X7woi2AfJUMzhFRAM2hvfFtkqAc
	 zo1PaPqXFL06M+UnAh0E10nXPAWC5GOWrIDWwCBDSEX2O+06CC6NEhnfIbS0hnieTX
	 ygopodw7SUNSJ4DHMKzIxtUJjGU0YfKJdrU5OVMPuS0ae4AEemAEMeClPSsaJvuRbS
	 clwz5u8Lqxs+Z3nIy5gK+H49YplBh0PH9ilp20xalypFnd30cBVNro5R+d4Qif+PfV
	 NzPfB0acVJLxw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 15 Oct 2026 18:07:13 +0200
Subject: [PATCH 07/10] mm/hugetlb: tolerate uffd bits set without uffd for
 PROT_NONE PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-urgent_fixes-v1-7-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
In-Reply-To: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Adam Litke <agl@us.ibm.com>, 
 Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
 Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1793; i=david@kernel.org;
 h=from:subject:message-id; bh=+A1Chphb2VITOuNoz7RmBYZYcGXcwS2W5/AbSTwZtoE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIu/DJulRZwuF5+1XCm2AsPcXa1rWLN5dPLRQr/rm6o4
 twZuNG3o5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIlEuTIybOy203dTeec342v3
 Tp8/l9aVRk/yeS9ffmqX+DW27kcHNjD8FXjetnKq72OJ1qzn277qy8govLZy/bnx1b29+vedTs5
 z4gcA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 040D4100013
X-Rspam-User: 
X-Stat-Signature: cy5qd66fmagjuxnpbyidx5xckp8pmfwt
X-HE-Tag: 1792080487-708306
X-HE-Meta: U2FsdGVkX187s8x10JWx/HP+WXvEglWfyDL+Bj7RbIw8MAVh5KEVgFP7pMROq9vg2KJGaJpz7GancFtzM4TN+mr/nlDmyibfDg0mncdCMF2AnjDk/vMEwd2KVyqdk6UH4n5KPtTvRJu5sqhH/PURhGBKssn9YJ8BDQuToG5epR2uiN401Cmezdau73HGQwWvajuXhzrd3dZ50z1LekBeDER6Wyp5aeJ4F0NUXj/4FEzJ1d9P3cr1hPcaTtSqnjWgVpTtew+8fi/X7Yt/SVboqSj52t56BkfsGfMPJlabGcBy9rtyT5HE3lUfgUkdhbs6k3PBUnVWt4JljYHwzN5nMCP2kmunlvI7N6N6H2yrw/dU/k3DYvH71MmQ0PZGmzUqRftPiIrSKfpuZLbcur95ssA+7lbVdKY3Vu+Pip3fZvO869cNFg0uI859eLNXfpvtlajY1XLRWqGUr2XczRwkiyC+7pQlD3xk2YaLbZF3pbxbvMSqkPUPj3dXHxkG/8Bbk0QTz56JD65tz7Kxe5Y/WFyhmb9yjGLISvY/WJUCjru7EN6+/p8pNuxh51pZuYvUKXC+dQzqQS+QEHQpmIreW+r2Epjkv8lbM5F4RsjPH/gwJLY4h+scQTD0vHV5PJp4W0FcHO3ArJH7smgWQeqOlYhB5T1QieHV41apWhzukrojwGl9YDHuiuRG8VuPstc2FN4RXwMHewQThsLYfEvbWqqfG5zAuDF1Er4eDsbYQG3UDtamJb5vztwlGU7QPk2KvlAZtrUK8Ni4AnEUZfGO5YYUtpbRTDcK4A4f4g+R8mv1e5bqQZ3gpQ2L/YS59YsO6/+tnMgTJ6rDfo9jgOpqN7zKDxcIZnYRnGW0oDzUGML0LlOyMZJZzNduGYPA6cxSH0O9p13mCyy1L2ntIP2xCVdx1O3QVm6TtB2pAFeUnRw4qUqUFlkL80fnTUegjS2aRYW4W+5RpGpQEi/WMqG
 lsN1L2kv
 Paf5mA3sp9RDHqQMkq/pDbqVocxgnYeybTPgJ4ABwMmljr8wgI5mclZcOOX8dtUak0oJvqIhJi0n6tnhE9+CcOFUvl5RZiONKR5iSOf1ECjJr/7hnlg1UqVLQ4EkADz/CgNgL5i410eLGW5GJUDOi7+SlEWAB4JyTypXw44xFox3EWWD15lpe1QAzLauHNjG0OQnaqwoqLlQ+d8VzfMdIME4ONy+CJOLSOj0vKtMBQkb5BTxQkfjL6J0+eCTWaUQB9Q1sMl8f1+0hDClBXpxdKcvcHShgjcbTp1MaTseV3JgRE9gmH6kuPQvhhD+FqhtQhQdFGbKk5jgLeL4tBNQ9CLHL6jxST1PHbn09CXjgkgVafCOGQEWQyMs1wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The whole uffd handling when a VMA is unregistered from UFFD is shaky:
there are still some scenarios where we might have stale uffd PTE bits
in VMAs no longer registered for UFFD, which confuses other code.

Let's just tolerate that for now and simply clear the PTE bit. Add a
TODO to really clean up any uffd leftovers when unregistering a VMA from
userfaultfd.

The handling is now more similar to what we have in handle_pte_fault().

Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c3823f1958568..ba6860b9b7f4c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6127,16 +6127,20 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * NUMA hinting), so let normal hugetlb fault handling proceed.
 	 */
 	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma) &&
-	    userfaultfd_rwp(vma) && huge_pte_uffd(vmf.orig_pte)) {
+	    huge_pte_uffd(vmf.orig_pte)) {
 		spinlock_t *ptl;
 		pte_t pte;
 
 		/* Sync: drop hugetlb locks before blocking in handle_userfault() */
-		if (!userfaultfd_rwp_async(vma))
+		if (userfaultfd_rwp(vma) && !userfaultfd_rwp_async(vma))
 			return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
 
 		ptl = huge_pte_lock(h, mm, vmf.pte);
 		pte = huge_ptep_get(mm, vmf.address, vmf.pte);
+		/*
+		 * TODO: fix all cases where uffd PTE bits remain in VMAs that
+		 * are no longer registered with uffd.
+		 */
 		if (pte_protnone(pte) && huge_pte_uffd(pte)) {
 			unsigned int shift = huge_page_shift(h);
 

-- 
2.43.0


