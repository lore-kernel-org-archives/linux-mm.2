Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F72CF0183A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 14:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65766B0005; Fri,  6 Mar 2026 09:06:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12DB6B0089; Fri,  6 Mar 2026 09:06:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF50B6B008A; Fri,  6 Mar 2026 09:06:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FBA96B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:06:35 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4028613B2D6
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:06:35 +0000 (UTC)
X-FDA: 84515813550.07.A98771D
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4FD86C0003
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:06:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JsnbHz2N;
	spf=pass (imf22.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772805993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=W13+CBFURjvfUajrgf80QK1S6lJ7DWAdvvvI450YWW4=;
	b=esgMyON1g7znNWooclEP3xj3lpP3fkrxpPgzmgd3M2oM8Ncdcebaic5F3BbA1GkorOdOeX
	4PrhB0KhlYIiJv7gmvAI/bSjyN1l83du6sxGGt2TzQP3EuWqqLKKUEvzz9d+U8AmlRsW+g
	tSqWPe0nwISa8WyfTQXl63Njl5Q0RZQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JsnbHz2N;
	spf=pass (imf22.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772805993; a=rsa-sha256;
	cv=none;
	b=A2E6roOwvrnPTF7SGlBMqk/lbOtt4pnwcfwbDCOvtJ0WzR9YPCuNhdpkHXxc3fD1IswF9G
	N5zLG7PNzfeZOw0Rf3v8XGG4ge/tGMGecDu9QCUFnxRX/rySf5/E+CQnIT/40rlnNgc8rm
	WDYZmo0zawqcFdomkU8D+ONrtiGK52Q=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c6e2355739dso3798706a12.2
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 06:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772805992; x=1773410792; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W13+CBFURjvfUajrgf80QK1S6lJ7DWAdvvvI450YWW4=;
        b=JsnbHz2Nnn2imI4cwSs7mYM4vducG/+OBS7E3Z57pFWb6Ky8VW5ua0pnNq8bavK0C/
         xTe6PycI/rxOAXVjNOQXehED1HQQdAkW5S31nQk+qRuT4ECxC3Gtm3uhWJvOu0ItVbjA
         Zwg7T+txI7x86ppquRkrx7fSlA8RmbByMH3/EJkMD73IWP2a//uFqIxiWrzxd/PNd9Ju
         V362bCwB5kGKvjfMDs7ZAQgUQY+LUpbSI7DH6smQNVrE6kEgL8x0ubEnV7jp1BsDe95E
         BLxQODo6bsbrk9u5wTjU5Ws7bzty2P+pZNNlMFgUHz88xh5ftTsQhchumy2XZO6lRuzy
         rYiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805992; x=1773410792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W13+CBFURjvfUajrgf80QK1S6lJ7DWAdvvvI450YWW4=;
        b=BU13IuIKQtXsCJDhPLKRwNBUkaBa7XBe/Yhn+BXSi84EppH8tUovA+eH34zNpnVdxv
         UMkGA4y+gSzRqZ2tmX9uUGz/aHBD2HMN10pqmfGPflt047KwchPiZXRfmB4jo0uHKICM
         kmdKfFiiyVmgWQ/jxayGjjJ8VmRDGqGL+tt6f2j7C55j+h8o2/BbjswC1ndYPwvbphOU
         7ZJIGvxUWIs8yPCGS1uwMBjsbH2h3y8w+lZ1BBuCmNaHRe8CJ1dxrIjHqhk48TMBVYeX
         iEmxXwVHMbU/28W8yyTmg5i+on7zAwGq4WcAl8q2Puhgujnepps8CAhonIXh60h33fGj
         R0Vw==
X-Forwarded-Encrypted: i=1; AJvYcCWg26zxmu+CJFFfuSpqWvhBpnwAUyzlzqHSX4Loe1+ajr4657W97H6enU8BaikD+SFiSBMqjysdFQ==@kvack.org
X-Gm-Message-State: AOJu0Yzp28l9cyOG9jguFQtHy+dTkDd71GFGvCi+QFmfWbR/BY5GnsVH
	N5XvUpa9ODu1U6pFD+zEeHmHjN9WeVOFj0tgXY3lqlFnodQE1JH2RtAn
X-Gm-Gg: ATEYQzzJaMHGBnpE5NwoBK8Uw1LBZh2kp6X8Hbw7qJQYn+UtdUMzMUGix57prQG9qyz
	G1wD6h6dSMHpZiJMFVXXHB116ik8QzHlOV8HKuDdEg2WCUfOuo8sP2Wat0vQ7GC1dcPrfBaVvWy
	od+HBsWPvN8DmES5IzvDav6Tlsf+lksEGtZWyrJhkzW65l2EuhhCDHya1rzmKoa1f2GP9QiD/Xb
	4Of3XjzP+yiLx5c09WTPPdEZ82ZEuRXv3MaGFINz7GGuviOl9JGefKgMYme1AJTMSGuq/LcMyUz
	ghRIkkLFKwd+8NCHvfbBBB93cEqzWqagdjPKvmg8P6czqlXRMlh9qlScCyfzD8xloW6at8Vhp6U
	Js2RHWfi0J+Hpw7KRUfpxATDtQNsjrHmMhyqpKK8azGbIDyvr3y1X3DL58r118Kw6Hsadbig/Sy
	6wNRD0aDRoR2+WJqXeuKLiKhvecpXmqfOFa+YZ8Zg=
X-Received: by 2002:a05:6a21:514:b0:395:3677:2be4 with SMTP id adf61e73a8af0-39858e02140mr2687015637.0.1772805991793;
        Fri, 06 Mar 2026 06:06:31 -0800 (PST)
Received: from zjh-os.zhaoxin.com ([2404:7ac0:642d:3126:54a4:fbcc:e0a0:ce02])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e16cebbsm1786713a12.16.2026.03.06.06.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 06:06:31 -0800 (PST)
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jonas Zhou <jonaszhou@zhaoxin.com>,
	Jianhui Zhou <jianhuizzzzz@gmail.com>,
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] mm/userfaultfd: fix hugetlb fault mutex hash calculation
Date: Fri,  6 Mar 2026 22:03:32 +0800
Message-ID: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4FD86C0003
X-Rspamd-Server: rspam07
X-Stat-Signature: r35hgbmmspysz8rqqrzd8f6asrs931dt
X-Rspam-User: 
X-HE-Tag: 1772805993-709406
X-HE-Meta: U2FsdGVkX1/PQs04ZRA1CJnKKkMKRGDSqhZCcksB1v4wTbYy4kC6Wknbk1W5pzXffloRteqMVVpVSKbfxs0X5w1432oLE/0uutwEog5Kni4DK1SDJmzvghPPIr62LQ5AJ8Nr+y6FjMRQT1ui64eRyU0gi5gIeE7oOuXxtXOkIJa+J6Df+rzj09d9k9WOzJq0wVi6yveVErfrlPHj5x8TcbuWU/Ttk6lfU1zVI6kN33DB6TAkwhvD5mvC14VByM3uB3VzkHknUTFJNC4dP+Av5si7BW61/2baxZSzMZpWuv4Fyj9kL7IIrMVs0XJ2XubGK0XE/Z4LBxvCxInIrm6fx+WjKPWEvD4rhDFfnWlhmngRjYeAvsZ91uOAMg1bmG4r0xkA404yS3IjhVt+wUDyGD+yLWju1skI0OO2ECNSvIf/nJD0sXMgKw/iFtE/gVHKJ4dqbUMRaDAgrAl9DCZxQCm5MEzs4tQG7D0ww0kehzZRHBFM3tFgEpx5kVo1adWmeFMuvt8S6aAgiq4mpxeiExS5RccoPkt7jcdRkfcf2awKFdL+kyyoy1dPaOwkRm9mRaZ/seoVUpN60guNK1ryjZfQb/qZncfCbXIwvX1gQQjLuoEYDRItu9raylkf6Iq0qfgFsIWxtvA/IhvX819Bf9MnpIb4HfNnS9+1CbCf1Zu7EPr7tsUTRZnnAPxoy/ctI7LOUw3TPQZIJsKnoB2cdsfAJ4utPKN1FexF0YpKRX0E8bQQ4VN1apKvtjY9eJ3ia8Pj9WCKgGfPD9eBllvssRZ0OtXkyXGgrkpjTUUvz+WkWq6qST8rSam+Gl7VePrSMfXGIjbkIvqfrc1TfZ5hkeuEbLt9mHXDfJGu493BricV1PYh/I1U101ZXAH/jz8fvSn9rRddwss/4T0n09OeRs8P5Hgen72h+DTHDwzarLth2dvrxzILwI7kr0gJVDMuZALjlhfbMnW8rQu5fe1
 oUF9nmIH
 JrPUXpFNlbVyJMqpF0ai2fYVgoieHuTSwz4xF3+RDQYBP4g8cReeAtyaw++Jp8Qjah7Gm46PiKiTLBC95WV1y4h08P+n/Imb/eeHcSskqQmJSUC+iRRjg1YF9nlDLH3EkVWN32tL2sagF9Gj353gtLohdR/fVKqnFk4YGdi/3pVuZnqqL4TXWc5YlyHEFVaUiUJuH+LU/zoHaZNcWqAnobD4bl44ZDPXI/3puaiT7/7iIYIPwEkJjaguRvJQJNi18ydMjJwbpnUQFizhMpAJs+2jc/zghQ8MXGNkQLLOCAmHyqYcmvMAfPMuU8ZfqDdxtHhSupOpaoDx+Zyh+pkOSdZZc6504Ub6Nqz1w09fOwMnsr2JVqEF1ueyi7A8pJvcnt4c5HkXtPfhFK1R8ywxDlg4UhaXuAA/LHGx02XJAokisiAqn4MU3gP/4JlkfDSZL9QzGe0d28wVBglrg6dtSp47SCfHZlBRwFPXi0ZLbzKphTi2gPVlZrVRxLr9e7eU3s9tavm1yQ2j6iyPLRKRea/0tcTY5bUCUFCz1hBV4vo8a25XLymFAh02ajovLK5XQoQGI+eK3h3eHVwp9Nv1RfRgaEvTYfllbXhbMtVCITgwbgDsVIiCb/fWZa6q4YspZ0NXzN6gh9djVJarRFOpHw+b2CVzA58ZO39/bHqHbE8eoH77ZNySXq2R19GUkYU100ZAekGBHSgYQsSWo47bhQlLeag==
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

Fixes: 60d4d2d2b40e ("userfaultfd: hugetlbfs: add __mcopy_atomic_hugetlb for huge page UFFDIO_COPY")
Reported-by: syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f525fd79634858f478e7
Cc: stable@vger.kernel.org
Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
---
 include/linux/hugetlb.h | 17 +++++++++++++++++
 mm/hugetlb.c            | 11 -----------
 mm/userfaultfd.c        |  5 ++++-
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 65910437be1c..3f994f3e839c 100644
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
@@ -1197,6 +1208,12 @@ static inline unsigned int huge_page_shift(struct hstate *h)
 	return PAGE_SHIFT;
 }
 
+static inline pgoff_t vma_hugecache_offset(struct hstate *h,
+		struct vm_area_struct *vma, unsigned long address)
+{
+	return linear_page_index(vma, address);
+}
+
 static inline bool hstate_is_gigantic(struct hstate *h)
 {
 	return false;
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


