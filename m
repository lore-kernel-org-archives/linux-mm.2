Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E4DCCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 11:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289756B01A6; Mon, 19 Oct 2026 07:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212BD6B01A8; Mon, 19 Oct 2026 07:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101D66B01A9; Mon, 19 Oct 2026 07:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8CC86B01A6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:31:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 668E840663
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:31:26 +0000 (UTC)
X-FDA: 85339160172.20.6717079
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf26.hostedemail.com (Postfix) with ESMTP id 49843140009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:31:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Lx6k4wGK;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792409484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NAWO0hPInuKz2svZuq+EEVdySP1nRs4Jci480qIc9q4=;
	b=6+mhkDV4Huja/5fwLRLNDB3dtVD6kuqJZw8Mps4ytmXbUTp47Omm0xgsktZvuV1oor8ilC
	bRh6kpSWw//4LcNMcQb/1O1ZqH5XBkVa4wHU9Uelho8+yR/2TaqO4imC8TeNOaAdEAdCY0
	YX/U1lHJkNe/wlGCrlLiT+nUqR0GZwk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Lx6k4wGK;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792409484;
	b=RYN3Q8LWjhAzVR4zo1SaUsJ4SJMh0ad8EpVlmoAeLIieN6S34016NaIjDbwQ+YF1P5WRvl
	3lzoDB6oexe8QLRkPBJsRCa826MKOCIC+P79iMIKSpbcB8015SH68LJ59zdMjz9JQyFrhF
	dobd+7KfBLA8DpO4cfhAoFQ7XedsWTg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792409478; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=NAWO0hPInuKz2svZuq+EEVdySP1nRs4Jci480qIc9q4=;
 b=Lx6k4wGKAlwP6ewF+be1ydhXjT82JEf9VbN55LkxJLHO4udT+TljPSGmZ0UjYqMXSlPZbm
 4+146W1P7EMBCLmspyuGMwhwRgNuYSIicUC0hZq+buKDz3GFCViC/SrXuKFMP9WaLHFj5N
 t7tEqFLvTTfpI5sQXZX7a4mUDAjM/9mSH4H2gsfJt+VVXbfoIQhx3MMAqd8T7x6VZQe6zk
 Ymg+l3npscgnxFhGZHUj2UBDTc0n8svXgIKlvVurrh3j7u6eahlZvuQysfGdXWNb8WXFZa
 u5x+E/oHw1Sg+Wgohgm6Q0Yw/G1hKmDM6St/7T+8gR/T/e8zsAiq75N9XMjJfg==
Date: Mon, 19 Oct 2026 19:30:32 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26ad5ff84+8bd397+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH V2 1/3] mm/hugetlb: fix mremap move length truncation
Mime-Version: 1.0
References: <20261019113034.97690-1-lizhe.67@bytedance.com>
In-Reply-To: <20261019113034.97690-1-lizhe.67@bytedance.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <rppt@kernel.org>, <peterx@redhat.com>
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261019113034.97690-2-lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: 49843140009
X-Stat-Signature: 3j6f5o1catqwse9ycy594q5gxc9ahzqj
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792409483-595547
X-HE-Meta: U2FsdGVkX18/isFZf6qKV6Ig5oKsqrAUfOG+AHeVu39R5qAUWTZ2wBfscPKpSn2PtZ3Nb7RREhnCeuBZQiA2XK/dl7ZZRNO4mYTkwO1rb+j0L6kt1bzUl2ziy8cCDHYGxNtxnS2h9kHUxR5HN6RRCEQQ36RqbcvJSGcPXBhtKJJxdv4kbRe3LxJuJLHMgK6yg+L1cokds3TCfN5gv/oR1ebPSins4c5TbXhwGjtqQ6KuvxKWQ+7jG+AoLROJNozLDMhDnmiAS96N8d7M/lHFAmZQzV/M5gbqeWs6z/YlpuTWBb7EHxmHYYnrstNJO4dMt5ortoqwpVML/RddxTExsuklH9MT9YCP/K+MIWWfjW4z0kmLY9YGI18r6syFc5GDNEuX8/7logVPtncN8h+CNmsSYu/Cxtvvn4k2Va/xcrb+FV8IyIIZpl4irtSGiIq4v+QAGO0ybQPPC1VwT9GeTUhRSoUUIM7HLpWj3/zqc32F3VMF62/TlibkpWeKoj7dagpNh/dO1meOk4QlmcuQY3cbqyigzEmONk04hgdxWRZSigNedaJqV2y7T4GMWXPxlZpwyvXoxM9LuHy+X296O+Xi8hL6/qd3ERRmFTPs0/BF4hjW0FHc6n+12uuCEuzmRBR9s6FK6ZK8xE/JLLcI3Lhb0LcT6jSCzPD8N+mxvy/nAJHUl0xiSZ7Y0tZPz3LfkjyHhxj3MpKktvRhLBQg9qugeiT7n/475R0ArsJOot7R2IOEAz1qIR9bj4MCQbgOwyfLDK019FDgvXgqdIRWJd49BagNKV+BtpRiWIMQkzEkFy56S5/T1sGf4AA3KDUueJl+ZWX3n2/NCoDstCs3Pp9slB7QlkY2OP6/O24RgUV6VZ+dPbjxPPnyem2UQLEgTif++4fqmYUQItijCoge+mpa4l7whmCWZoBgl1RWSa2S/AtTqvJ3T0yLRlMmir1ZfPaFg9NA/zaVBM0Kt7I
 kf3edgJk
 VnzJGxvE9oZ1TYVyfgTuJibnkoJH9RvnLMmOGyfTD2Tf0Tm9bpZ1v0KCFG7uiFFUta7K/jCnmmKCo2B42wp4t0imEkY44841MuNkVv58bI/+CLy++ZOWVBjYnT4oYIWWzc8NX7e5klxM6T6t91VJDQnzNpPysErsgCXsRkaVOaZRuLKSM+zlpkgqca+TIaY3IczBOEeNd4xSCv0V6y/ZjKrherKDlo9/rLSLseDsjp+UPQo3PPs6nRpfNQdYkOW3vYnYv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 include/linux/hugetlb.h | 18 +++++++++---------
 mm/hugetlb.c            |  8 ++++----
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 16c4c4caa126..cc12040e4032 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -121,10 +121,10 @@ void hugepage_put_subpool(struct hugepage_subpool *spool);
 
 void hugetlb_dup_vma_private(struct vm_area_struct *vma);
 void clear_vma_resv_huge_pages(struct vm_area_struct *vma);
-int move_hugetlb_page_tables(struct vm_area_struct *vma,
-			     struct vm_area_struct *new_vma,
-			     unsigned long old_addr, unsigned long new_addr,
-			     unsigned long len);
+unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
+				       struct vm_area_struct *new_vma,
+				       unsigned long old_addr, unsigned long new_addr,
+				       unsigned long len);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *,
 			    struct vm_area_struct *, struct vm_area_struct *);
 void unmap_hugepage_range(struct vm_area_struct *,
@@ -339,11 +339,11 @@ static inline int copy_hugetlb_page_range(struct mm_struct *dst,
 	return 0;
 }
 
-static inline int move_hugetlb_page_tables(struct vm_area_struct *vma,
-					   struct vm_area_struct *new_vma,
-					   unsigned long old_addr,
-					   unsigned long new_addr,
-					   unsigned long len)
+static inline unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
+						     struct vm_area_struct *new_vma,
+						     unsigned long old_addr,
+						     unsigned long new_addr,
+						     unsigned long len)
 {
 	BUG();
 	return 0;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cea25773a6c9..2c64ca985dfa 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5139,10 +5139,10 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 	spin_unlock(dst_ptl);
 }
 
-int move_hugetlb_page_tables(struct vm_area_struct *vma,
-			     struct vm_area_struct *new_vma,
-			     unsigned long old_addr, unsigned long new_addr,
-			     unsigned long len)
+unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
+				       struct vm_area_struct *new_vma,
+				       unsigned long old_addr, unsigned long new_addr,
+				       unsigned long len)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping = vma->vm_file->f_mapping;
-- 
2.20.1

