Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC980EA8542
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 03:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51E4B6B008A; Sun,  8 Mar 2026 23:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508D26B008C; Sun,  8 Mar 2026 23:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41ECD6B0092; Sun,  8 Mar 2026 23:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31B3C6B008A
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 23:31:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1C32C3D87
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:31:28 +0000 (UTC)
X-FDA: 84525099456.26.3E59E1E
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id E77081C000C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:31:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ed60hBjl;
	spf=pass (imf18.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773027087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KRG8W6zvaeyPSQPZSzI9vt2gCkqaLRuFzjk0nW6pVNs=;
	b=S2un3jzu+Mm4QuE7K2qaTs8wZ8X8pCnYuuCwRGY2qTh4ApplDNAg+OmnjohsBJ3YxOtwB5
	MWTlCxCKzeOSidcAx7sRKK+fKRsq5N0B+X4riZWGcbS7bMKB/58misp9PebQQpKyi0etIn
	3Dd3sYWa/cbvcXe3SVyvQzPu1EHTRBU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773027087; a=rsa-sha256;
	cv=none;
	b=uYFReJb9ncggPsv+7lxmYCDGVg16X0DQHCUj0ZUNkmyMYEHxhwB9qmWFWGq0WA4btkuiYW
	Yx9ESPQMWcM5Pg+aWnuCKVMlPdA7xwP2ymnDgNeHYiBWaKiNZ/wUfW1dk6aEpa8D4N3E3h
	4rrfYLhKU7Df8RXZ4kRk6WkIQwO8X6c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ed60hBjl;
	spf=pass (imf18.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ad9a9be502so73302345ad.0
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 20:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773027086; x=1773631886; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KRG8W6zvaeyPSQPZSzI9vt2gCkqaLRuFzjk0nW6pVNs=;
        b=Ed60hBjllqUDkrcf+BeTi60SOvDcptxMoJaeO5Nie/j4wLLBf8QNLipxYv5h/yfzlX
         bAj66S7LkzB1C9nrqqCIgfgKmsjZRFvnPnzc6l6IR4KTgCbhLYGamTL+zm7huRHTXHPA
         MPTST3On5OXM0/w5wmHWgCPthATgi+O1PZBOenqHUhA3R3R3oH8NvO86Mrc7RS/egvtg
         H0A7fWJBBryff445fR2b4Zyi6NKtWUKKnywUfrym1fl4OBBltFPx7hYPVUdfoijJc4y2
         tAcmjY8h0bXtoPQZxg89r/wc+B1duL/R/QcWdHreD2GTWNH9qGv1vJuBo4eMjmBrfHyA
         SZHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773027086; x=1773631886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KRG8W6zvaeyPSQPZSzI9vt2gCkqaLRuFzjk0nW6pVNs=;
        b=pxmvE8tLzeehVPJ3jQdBJqu9di2XLSDQmXUcl9mllHK2jP27FhoumsndR/HD3qiRqQ
         xFyGla4lSnuCv43bK3QsOXfWBRFff2ebjeCTCHYGyFsAN1TyYcH6hzW6H1gYSAiPVeav
         uUUf8nba4Uj4ZupyAbZVTe/OE5P+SrLcxTgTlQiREb2i9ZRY6EQOex2p7ttPYbXaZ/nm
         IZLOr+iS8S+QA8+NwP3A7YhSkJ7qrtaUSj8SBBJ9mC9h9+Qm7wBbW+FQqGSswmNIJfNr
         V8RH0RgXPw/3Oarq3sLAOlnORruIIfxHaytNUAnOMubmYVJ13regtAOrch2Yt3XcSQDv
         PtCw==
X-Forwarded-Encrypted: i=1; AJvYcCU6GaVBII70OM+n5lKQzVl5xK5WZuar8Kl05e85CkF9sNceY+B+/eL8o7z5V7l7HWR2SCmUfZB9Ww==@kvack.org
X-Gm-Message-State: AOJu0Yy1ipyFfTO4OPuWoJJlqcJTwQjT8Wv+XW7sARs5mAu47nEzaSNB
	WVfiL8gDx3mEw06Q0py1qjLCVo0mUU/DRE2w8d2BUjADq6rx8T6hFHqL
X-Gm-Gg: ATEYQzybB3zYG+O+hyX7ZAhbqibwl9Zt2CBfEgzSwUpJRno9igpMdhxwXs/W1zZtop3
	YQXiAjEZePqztORMD42vXRSbeZHoJIHA7hwvfLJwtp44LCoPVZzzjTCeiUPQOIj9F9m/cKjjreH
	G0BA32R3vyXEp5pEKhur4zdd5pMcRGIzspBxGn4bCZhLQoC2qUl1CtroL0Hjp0+C93LFvFlsoZM
	yljHJdgsNNAB4m78KQfIMGzmgXNuuU/Il1MdDZrXgFRAxpMdskeM8rOsKBb5b0YQB0BgE1xd5bk
	3iSPQ8jKIrrtKfEEKLc2XjdL9C/fR0UCuVwoIfSf94yqh9MvZuZXJQed/nU8an1gxiYntS+L2oJ
	+FzdvS73jjFeWoyg0vAIZgvicXkmTNyjdahy9s+Ph0BABDAhmPQKsBP+QJPxhOMpeBBzSkvJBx/
	PgRKgH3ZQwTbiURnRw7sleGoJUZBz+pES9YeWq5Q==
X-Received: by 2002:a17:903:32c9:b0:2ad:d5ea:4c89 with SMTP id d9443c01a7336-2ae823a296emr93888925ad.22.1773027085592;
        Sun, 08 Mar 2026 20:31:25 -0700 (PDT)
Received: from zjh-os.zhaoxin.com ([2404:7ac0:6c91:c65e:191e:9b9a:a3e:cb03])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae840ccb6csm123370615ad.92.2026.03.08.20.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 20:31:25 -0700 (PDT)
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	SeongJae Park <sj@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Jonas Zhou <jonaszhou@zhaoxin.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com,
	Jianhui Zhou <jianhuizzzzz@gmail.com>
Subject: [PATCH v3] mm/userfaultfd: fix hugetlb fault mutex hash calculation
Date: Mon,  9 Mar 2026 11:30:53 +0800
Message-ID: <20260309033053.220012-1-jianhuizzzzz@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E77081C000C
X-Stat-Signature: 5t5fh6ewxmnatypk96ppzaq53ubufrqd
X-HE-Tag: 1773027086-87074
X-HE-Meta: U2FsdGVkX191A049a8S14vjJCiCI9BVUCddCB95OPY5n+iLEExnIwfZBaI8BOyqsN9sFA0zt+3+/LniwMwUnv7uMyLi81dFDdYuygVvUXcjoZwcVi9P5YDNbjcVT7P4IbKQW0KolAfmIIT8cmaWQH5ntx+tmiztQs04PeTQsYDpq0VyUCoQfzbGy2yGK1M3SSwZFKEBXH6r6+0utGeeWwfuuUWGM2UpkVdCkl9I0JgCQBoTG613JxAUoas1wj94+q3jNBzmZAh0kZyvmq3vfsq0OoCsuZ0Bfz3txp5h0g/g5Y0Pt8p293wuiyBR3VdtXAZMV8ZBzu0eA7etPAAF3jrHUNIZpoNbo7l9zRBY6ecex6jP2LJ1XG9xi61+deWD0QhZ20dt71GqHxsiHPSE9GsRocmwveq7qhtFKRKGuUKY+2ODklCMmtf0lQFj3A0hYa6Shvj0wPBHU1cgR75+Hhfxg7RYp51L9PgM3YTQNGcVcOYawnoPimM65WLuACYeQCvFWOZngXTlwi7f7TCD5A4yQLOuWEME3FJ2/KqFplrmFcNsEGviHeso5eOuoFc0fIe00dufrm2SkXwMDbel1NdAwoYTOzJFWo4KBrj9pRFAWBj+62eDGwYZT61+wCmYxS6AFFS58mecfuVfkpwn4WHOQCyAifZne3Rhdb6d9cP73mSXCH42mJkmJKVk819glzlGkI3VjM0XQ3YV84ZGJi0I5+9qy7u1VXssb0tFSJTC+C0gEyshxQDaWQzOzO5C8GuEWxDRBLCIeEG20MLGiCYRGO9S05BYGm6J6w7273g9nzEqo+kg/Mis0SgWpNE3UCA2YHVtUWTDmc7FHCpEnFCWbDT7e3AoafFg76XetPPb5uVHjQspkDnQxBXg45dczHueg+gqfqa8HV+2qdu2JOWx5/YQH0yV1MoUjvYk2sqVObMtqoDIUydE/CX/10VYyJBER9yTc27AX6dlwAtB
 4Xknrvti
 JVDn4D3lar7P4oeiQrG2nIleyjetmAFdqARtypdIFRGsctO20lAjADGDFK2nyVDIgK7yFAsfBSYLxOAvXYRz+R/3fY5/bPD/2KiqZ3YrSQvC1jfYKu+Y6RJH33tS+OX0rWLxwQyycYURTt1b7u6jgi+riOS3Pr+AdbIrgPvOq/RCsDIAw5kvXawIkoQ9pgam3Qhug2pYSYrxorO5T9anGZpcK2ORcNzD5XzeJQMFkd2aJXURH/83f0x3RuBBiil/Hjp6IQjmeZchPOvSGDO9KRvi/Tsy/tqbfeFP/Uf8KcUaV3k2J9lhIHlQGly+qm6kBFxu9UweP68D6z1DoHP/fAJnKXhcOQGgEbldCWQpAS/0AKxdWNdfNWkm8Q/GDof//ho7A0Jn+9XTjFE54fZPjMsVeVtevvr/YIGyOp31OYUOAeA0sjTncNWHCwnr0SKTNuuMG8Wx4Wko3EJDiFczFZSDMMt3wniO3fJGnJWnpV3/tHbyTZMET5iUSxF1JHIwNIWwOZh1AdtG/n/MVXy73egewMj4O9RL2hz51NV6wo4yixjuGyUP49GZig99+LbFdQDIhHdFGcROqGcSi7SvaEp1cqfRSr8xlYnFejI6T0IJ6mc+CKgmAUeoKBw3J6f7j7qkWRtmQbctI1U2xWtJKZMW5oDATd6SLMpeK0eye40I907P9h49BG5qswbK+Z2aWaM+pNIW4UFdQgAexAriaOzZEnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mfill_atomic_hugetlb(), linear_page_index() is used to calculate the
page index for hugetlb_fault_mutex_hash(). However, linear_page_index()
returns the index in PAGE_SIZE units, while hugetlb_fault_mutex_hash()
expects the index in huge page units (as calculated by
vma_hugecache_offset()). This mismatch means that different addresses
within the same huge page can produce different hash values, leading to
the use of different mutexes for the same huge page. This can cause
races between faulting threads, which can corrupt the reservation map
and trigger the BUG_ON in resv_map_release().

Fix this by replacing linear_page_index() with vma_hugecache_offset()
and applying huge_page_mask() to align the address properly. To make
vma_hugecache_offset() available outside of mm/hugetlb.c, move it to
include/linux/hugetlb.h as a static inline function.

Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
Reported-by: syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f525fd79634858f478e7
Cc: stable@vger.kernel.org
Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
---
v3:
- Fix Fixes tag to a08c7193e4f1 (Hugh Dickins)

v2:
- Remove unnecessary !CONFIG_HUGETLB_PAGE stub for vma_hugecache_offset()
  (Peter Xu, SeongJae Park)

 include/linux/hugetlb.h | 11 +++++++++++
 mm/hugetlb.c            | 11 -----------
 mm/userfaultfd.c        |  5 ++++-
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 65910437be1c..f003afe0cc91 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -796,6 +796,17 @@ static inline unsigned huge_page_shift(struct hstate *h)
 	return h->order + PAGE_SHIFT;
 }
 
+/*
+ * Convert the address within this vma to the page offset within
+ * the mapping, huge page units here.
+ */
+static inline pgoff_t vma_hugecache_offset(struct hstate *h,
+		struct vm_area_struct *vma, unsigned long address)
+{
+	return ((address - vma->vm_start) >> huge_page_shift(h)) +
+		(vma->vm_pgoff >> huge_page_order(h));
+}
+
 static inline bool order_is_gigantic(unsigned int order)
 {
 	return order > MAX_PAGE_ORDER;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0beb6e22bc26..b87ed652c748 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1006,17 +1006,6 @@ static long region_count(struct resv_map *resv, long f, long t)
 	return chg;
 }
 
-/*
- * Convert the address within this vma to the page offset within
- * the mapping, huge page units here.
- */
-static pgoff_t vma_hugecache_offset(struct hstate *h,
-			struct vm_area_struct *vma, unsigned long address)
-{
-	return ((address - vma->vm_start) >> huge_page_shift(h)) +
-			(vma->vm_pgoff >> huge_page_order(h));
-}
-
 /**
  * vma_kernel_pagesize - Page size granularity for this VMA.
  * @vma: The user mapping.
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 927086bb4a3c..8efebc47a410 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -507,6 +507,7 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 	pgoff_t idx;
 	u32 hash;
 	struct address_space *mapping;
+	struct hstate *h;
 
 	/*
 	 * There is no default zero huge page for all huge page sizes as
@@ -564,6 +565,8 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 			goto out_unlock;
 	}
 
+	h = hstate_vma(dst_vma);
+
 	while (src_addr < src_start + len) {
 		VM_WARN_ON_ONCE(dst_addr >= dst_start + len);
 
@@ -573,7 +576,7 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 		 * in the case of shared pmds.  fault mutex prevents
 		 * races with other faulting threads.
 		 */
-		idx = linear_page_index(dst_vma, dst_addr);
+		idx = vma_hugecache_offset(h, dst_vma, dst_addr & huge_page_mask(h));
 		mapping = dst_vma->vm_file->f_mapping;
 		hash = hugetlb_fault_mutex_hash(mapping, idx);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
-- 
2.43.0


