Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46CBE606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 03:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=GJNsFPGG
Received: by kanga.kvack.org (Postfix)
	id 4DEE76B0289; Wed, 21 Oct 2026 23:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B4AB6B0864; Wed, 21 Oct 2026 23:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F31D6B0865; Wed, 21 Oct 2026 23:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20F016B0289
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:47:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3090AA03CB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:47:08 +0000 (UTC)
X-FDA: 85348876536.28.C537B18
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf23.hostedemail.com (Postfix) with ESMTP id C155D140005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:47:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GJNsFPGG;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792640826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EL4zKSYauXV7QL1vcktxiMTY6CZlzl+ylN8VKzLTC2Q=;
	b=5RvsW/ullIQ/bGInaLBwW8zWSIritZ03SYvg4eTgPZXKpgMH5uIBz6skeWEuXkmQHOuY/K
	Yl77zzWx4wR6cjG2DTTzQlgK1hjzyqNwQN71HjsSjNYbvruKKVMhwWUSyJXb4JXe7NCtbi
	KJ+ac1GqO3Ak6MprI9V/yR1d+H61Aqg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GJNsFPGG;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792640826;
	b=5c0v2vVfREiFw2yNW24D8iCUKiFi0aAfKLacFbljBsQMls+VIX0w5YTMtpthxxY2g2kaz+
	ePFzQcUdC44IKKUaYKDZVPiVauQ8Klf1xNtyc4ZU0wpvRjBkIp+TGHVd2bsrzCI6dxxcos
	2Rkd8FMBr6FzB90/rQYDCqBC4E96JEg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792640819; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=EL4zKSYauXV7QL1vcktxiMTY6CZlzl+ylN8VKzLTC2Q=;
 b=GJNsFPGGRbBeUG9nK3BxJDmzuEhwTQcdL9nmtmffA/UmxdO1u5J6Ehaf+iWNpaMXiOI8aI
 koQIsE5QWL/9psnbFJYZqD/UoV6a5YTuGz7oySMJPDJA6X2lyPqGgK5Xzr9NhsujoRZDiO
 9oZebLi2Bp5dHmeH2Mz3Iy9L7kOU9ovdpwxt6Xz7IhHas8Ob1tsO0B4AtCLqd6C80yLFD5
 TTnNo4UPMy2RxGseWwoYazwiF9s8PmmJYT+0VUbi7g4b7ECe8MJR7ZSmnStkFpa4LI36Cu
 xl0eoj5rC8VqqbRQX+1VfvNPXIGl2/wKenX5oWfv1Vois5KE7s4sMuVVwzrKBw==
Message-Id: <20261022034543.51226-2-lizhe.67@bytedance.com>
References: <20261022034543.51226-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>, <stable@vger.kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Thu, 22 Oct 2026 11:45:41 +0800
In-Reply-To: <20261022034543.51226-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ad98731+751443+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <david@kernel.org>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <peterx@redhat.com>, <rppt@kernel.org>, 
	<azpijr@gmail.com>
Subject: [PATCH v3 1/3] mm/hugetlb: fix mremap move length truncation
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C155D140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zzknot6nzxfiw9u179q1ztsdosz6bxxo
X-HE-Tag: 1792640825-343747
X-HE-Meta: U2FsdGVkX1+2c1VD5aRyDGDOOE9/VtwyUd1aCh2/A6ubgmGJE3+CkvZb4sXjRXQCptnU8LE/92zE2q78g5qiI7VFmLN8MxbnguoI4H2B5LgM041pv5No/N8aVJs19O6fRMpWze2sRtVxuwYmsoiJYXSm3KquWnRaRJw0rTs9jAxlDy3/j+lasu4yAKcm4qdADDgl2rU0Pj6+pClRi1GsR2ZipPzHBBnwYxi1fzYXiePQ2wzURddfZQ2Zcmiq3/prYMDu5LYJSu1LL7t7UZ3SiF29D2c/wCtffJ8IvspbQ+qmM4dTw0BWp7dbSWnRmLJH4k4PQbMXZxvZ04QJZYYVGZhbvTVrzUK9xmpvfisqCtlQ5V4UdqZ+8UGHDg7Rso5VrA8JB3svz5E9Oj+3mAPgdH6yNrnk8HsdTx43+eNGSrUdBVCjQjOKvuaP9+BNR2svHOq19Y93hScyq3Hq1McskIUsYWCbNAn4ik7IAAFJVn68rMf79IlEtBpFj/CcWu+oevXyae7lmdJV/Tpm8Dbe5W68urU68KyQsCbhOf6q0eDfQcRPi44aJ6IPlLgfmsKHzZFHC8ijNxJAxv/rQ874fZFx29+9Z6gIE702cNuZ7AWIYH4OJXd4hxEB/yQUEJzNGpinrsFQ+qBJ11+6yHINVnIdIGgmkS3AB7omp6d3ZLf4E+Udk5y+B3qCRRWGE6MOf1xpNxKwup6Rbdh4hklNleJQIcrwsPEH+8oZwJMycAAcyvRbcdhUHu6/b6AXBRfy8EpPpmx5qVweM+HwhSceevGOqgxkTHPMOdnoZpCZxcfULiksuxZLfE3QaONA0MJsFfvXRMyLtl2sviZve0VmT7aNEJxeVZulch3Ym0FEZ4Cf335Jzgo5F+cxsxJaagZT9SmrOoXT0AWtzQF8f9DXROzgtZbWVqSWjyaWd5LAbDBa4WQIBMXacgD65yMwPKifGEQyU8HKq40dpjzMwIx
 SMlqKqU9
 NCHhdTLYQbl52DwCI+IShAOsT8ddxhxcqToFLIU71ObS30A0hjWh8LkNDQnYHpXnm/d+OjfZP+TE2i+02BEXXJs1G+S/6rVUovkXWE7O83S0JJ93h9XyubbQ3BuX6HZbCAHAWboMH9q2Nyrv2yfiYOwwuvZZz6pNJB6ogqNpliTqYZCVPnOu/FL9D6auWGDrOpV6u5bIRVILFJ1+K2T5tR09ViL8N118/jSvhIf+GmcY2WYofZqGBjnF2tmg9dgBwsuseqMNZn+iIpj9/eHQMwfZ5/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_hugetlb_page_tables() returns the number of bytes moved, but
its return type is int while the generic move_page_tables() path uses
unsigned long lengths.

A hugetlb mremap() move length above INT_MAX can therefore be
misreported to copy_vma_and_data(). The out-of-range conversion to int
is implementation-defined; on common 64-bit builds, for example, a
4 GiB move can be reported as zero, making the caller treat the move as
a failure and use the wrong length for rollback.

Return unsigned long from move_hugetlb_page_tables(), matching
move_page_tables() and preserving the full byte count.

Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Cc: stable@vger.kernel.org
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb.h | 15 ++++++---------
 mm/hugetlb.c            |  7 +++----
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 16c4c4caa126c..d73e3cf7adf9f 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -121,10 +121,9 @@ void hugepage_put_subpool(struct hugepage_subpool *spool);
 
 void hugetlb_dup_vma_private(struct vm_area_struct *vma);
 void clear_vma_resv_huge_pages(struct vm_area_struct *vma);
-int move_hugetlb_page_tables(struct vm_area_struct *vma,
-			     struct vm_area_struct *new_vma,
-			     unsigned long old_addr, unsigned long new_addr,
-			     unsigned long len);
+unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
+		struct vm_area_struct *new_vma, unsigned long old_addr,
+		unsigned long new_addr, unsigned long len);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *,
 			    struct vm_area_struct *, struct vm_area_struct *);
 void unmap_hugepage_range(struct vm_area_struct *,
@@ -339,11 +338,9 @@ static inline int copy_hugetlb_page_range(struct mm_struct *dst,
 	return 0;
 }
 
-static inline int move_hugetlb_page_tables(struct vm_area_struct *vma,
-					   struct vm_area_struct *new_vma,
-					   unsigned long old_addr,
-					   unsigned long new_addr,
-					   unsigned long len)
+static inline unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
+		struct vm_area_struct *new_vma, unsigned long old_addr,
+		unsigned long new_addr, unsigned long len)
 {
 	BUG();
 	return 0;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cea25773a6c95..4a70716deaa41 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5139,10 +5139,9 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 	spin_unlock(dst_ptl);
 }
 
-int move_hugetlb_page_tables(struct vm_area_struct *vma,
-			     struct vm_area_struct *new_vma,
-			     unsigned long old_addr, unsigned long new_addr,
-			     unsigned long len)
+unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
+		struct vm_area_struct *new_vma, unsigned long old_addr,
+		unsigned long new_addr, unsigned long len)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping = vma->vm_file->f_mapping;
-- 
2.20.1

