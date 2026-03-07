Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 914F3FC9EFE
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 14:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D504C6B008A; Sat,  7 Mar 2026 09:36:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27606B008C; Sat,  7 Mar 2026 09:36:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C537E6B0092; Sat,  7 Mar 2026 09:36:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B466D6B008A
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 09:36:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42B571C395
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:36:15 +0000 (UTC)
X-FDA: 84519517110.22.C14FF90
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7240E8000C
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:36:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QCHi+T6L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772894173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FK4cahr2Z+5GEumxXm/3Zlvde4k/k71gu3JdZggtk9Q=;
	b=ImnpWZJA1YeJCKa0KGWDTI0KL7LVuplAFlnKUHl+hSRWojzTPiRjU7IYm+x7Dm6h//6LNf
	gCYOeuUIm5ALmejfgPBw2B5ZfiglRtZulf4B+TvgHLWmseoNKaWy3bwwd0EiYpyBIWAC3e
	487h02MUWOB/oS8zXFh0EB6zxEWp7u0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772894173; a=rsa-sha256;
	cv=none;
	b=iYiaKZiAfVXEKB/ZnuhSU9tsLbxqEBAsuwFDWlKcWeQm6qy4WL8IR1uXJinphMyrifMYat
	N7vI+c3bSSdAN6iCknuP/DUNBZkYHOAR63xM696xSVGQ/LDtUgwhmBAQYIsNFxzBUASfWR
	tCU2hdEoFMcar3Y2rXGKxbKGc5dtLmI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QCHi+T6L;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2be26842fd5so2223816eec.1
        for <linux-mm@kvack.org>; Sat, 07 Mar 2026 06:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772894172; x=1773498972; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FK4cahr2Z+5GEumxXm/3Zlvde4k/k71gu3JdZggtk9Q=;
        b=QCHi+T6LyvOaHasHRYqdytIKwlHald+s0qlKZxcMMk4h6ORXCZ9QlTva7kk/h1P+gE
         D8w2GbgKGThy8ueNvS/c1P3k5P0SqLAAbfayfx+g5Bhu95xphak8Z/h3MfoPOgNr0PNR
         0/jXNUY5ys+fzyAWTjp/P645PCgJfKxM7COnib/Yf8DiUp/GQFDlr0SOBmOzyr6SF0Gm
         LDvKeOdNBJxjIY7rMEGG8dqj1A3Dnp/vHsLhnYjCIxua8Q6DYCMCL/6xX2MHPjkYosmN
         Uw1Hg8yt7PTs3GuoEr3lM/G9Qba6Ru3RjTUNYnobZAjY68iQUYlG3bXS0J+DTFgh7QHc
         yAMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772894172; x=1773498972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FK4cahr2Z+5GEumxXm/3Zlvde4k/k71gu3JdZggtk9Q=;
        b=sIeAsIgss7zvgZMaoUXpEHkC5WNYEUq0bKMpYhXd0/SIgu+jtFS8bjPque0O7PfLQe
         H2PKRzJTupZqrqyCWYC1/BdFi5bPXz0NMTNnoucyTTrnukz6nlcsQ/0NF84aZ9FactfK
         eQJoUdboo0oLnf0lx3uMyHvr32QLcBQDxEhE5D4HJbgea1ELCRJnaK7qOty9l46pfMQ/
         ZwTr7+vZvES5MNvniTdgMBi5LNSYyx7tZ4KaCrTlP1qkk1wW2ahxICk0nMhgFVkGJYtI
         EwtW7Xu9d+kCoxq7Phb5HtSqW3QU/vAwbmWc6pcBqs1SFrazpewTcOSf19tSpObhMF/t
         r3Lw==
X-Forwarded-Encrypted: i=1; AJvYcCWvYUcoNYHRIRxHr8aBRtlp7ea8ASEyW3eKtIo23fulVeSeB9hJayfjzp3dfBDYmr/VDdJtTauBJA==@kvack.org
X-Gm-Message-State: AOJu0YzcALKDaB0Aa8nEaoke894yMLhVaShxB9YOaHjKqaZAx8RkhhKR
	7piGzGpSPlRrBVS0xcDSA7VnFCtsDMrznc1iWJMMziBbMQ3mkaEoP3ar
X-Gm-Gg: ATEYQzw/tRTmTRBOxFo8ZdZCp8jftyQOtFTsiB+RjXYR1ky+B/wG+nBD7CfVXP4mKRH
	yJYHv9n4uG5eM+YOKMabH86OUf72WdKCyxB+DE6+5ZHnqvgsYX9HQyi6IWh9dchfMX5hRLAB125
	zgQ8EFjtzCqzufFY2K8NPpLAXHC2YIWQ3gwUEXylkbvoKGwMxPs75UwXxBg8somxmXObAnFojSY
	NiCJiaRLkkwEUK4hJ5/QgAezgxHH4LhI+jTK/JPeghRUD4Z5DYkCHMQeTpuD6JxxUZr6g+CV91I
	mIbJ5JQk2k993KV60Z9WVOtNixbXkPUiyHZIsos6n95J2fmOPCBXyI46+Yuiths99Z6bK8h/EcZ
	b0yQwjjAIkpWIF1GzZ1YPVHirlNnYVeVRGI538oqulO5ArjFytZlj088xNktgDlyaHZT37wFyr/
	wnD9+DiSYNJj+He9rsdg==
X-Received: by 2002:a05:693c:60d3:b0:2ba:a7b8:3fe9 with SMTP id 5a478bee46e88-2be3e18f4e7mr2691990eec.3.1772894171949;
        Sat, 07 Mar 2026 06:36:11 -0800 (PST)
Received: from zjh-MS-7E01.. ([2602:fbf1:b002::1032])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be4f96f64dsm3481762eec.27.2026.03.07.06.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 06:36:11 -0800 (PST)
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
	Jonas Zhou <jonaszhou@zhaoxin.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com,
	Jianhui Zhou <jianhuizzzzz@gmail.com>
Subject: [PATCH v2] mm/userfaultfd: fix hugetlb fault mutex hash calculation
Date: Sat,  7 Mar 2026 22:35:39 +0800
Message-ID: <20260307143542.179953-1-jianhuizzzzz@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
References: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7240E8000C
X-Stat-Signature: bwc15pczegikx3kujty86m88mmzto884
X-Rspam-User: 
X-HE-Tag: 1772894173-165719
X-HE-Meta: U2FsdGVkX1+iEtY8THoZQsZ+929X5Q4qiN5C2Aq8VxdC8xxfcBN55s1hJqqOjBOxISL3sS3Jaoy+JeAlyKDRG5gE10u387yI8aXm+tOGN28V8aW6s0aT5MtS31JGoXntnwxVM9YrUGZFNCRBLJYu7aTi4cgj4sxm36l8F4Lq/8MIVMNr66QPaaz7oTzTbgJofXM885gPjz0yoqXPdcPT5lOXE79ExIIzrH3zsQyLg6KBKcy1d5dht2bssW4Hj8Nm5CcmAssPxGkGsyAWES/DSogZu6CpF6Id6rPicnAHivxzKmis3cDbkt0dGPks+jmhCx3gkTTqUwtk+P9WZQHCm6LGdJQGW8ofiJoMRM2crazWoVEhxBOK415UGot06rgyGwA+2XDNfhxIko8y0FD/lULgQEQfd/l2XJw6rqvWUp87C2F6a2VlT2xcjcJxT9sCMfXBS0WwTDtxFKO67HQDBG17rmqBC63qdF70kgkJK7F0TaXS9EAjpHOW+Gvzt/X1ZIYF/Fs60xG0Dc1R35xGcRLd6F54x7suWfhA/X6xwgff4Y41ysF1440vJ58RWw9DwvLKv49Qavn+i3fhAy5ab1DKyQWD4FJKEEyycXs1LqplrgwTiBgFt3ouZil9v+T+pBpP7o4yz/neriMdjZ5AhksqrT7/m4cqId48tHgX8rvtcAcflaC+t1kAjdVSYjvsOYziYPW/Ysy6UJM7gPZ7+1HJE+P0FeFBYMuDPolr34AN2/TKD/yWRfEus0Ztgb4FgyegesnNaN+Quk5hb9UVrdkolbH6jcr7T90YH9FSkc0chi2CRL/6ZdaN4kEDecA3mWck8a3pXtrkpP598YsPZLT2ozf9sMcsDvRdbd/2JevNhtME/70gmYiDyVXHpzlqyYSpSKgHcw7bToLT1TmZYB7HDAW08+5c5hb6z4I/yekIASWZrA7JSpCUX1iqrh2CqxKIgTcwaJdMDPlxP1u
 zW37yL3t
 2iT9AobdSErsuJTZJBhnY0L95ZDsJvEMPzvRdwuGRp7KyHsRmdm6Mj4AHD+GNO5lHpbIWLXTZzOfD6vHZt38/vtAPTQ1baE7oCkMVLEadzbTWuSAuXZxz31a6mmCwNJrJcpvga+EqFRaFgDLLtC74kg4rCdblbVtRLzJCBUZ4rhqeMRRLaOlnB+PCDvQYOJ5zGxZBkP9XTdHqXoxkf1V9cDW7WEF5iBlZarry2jO9zHXrWCmfT6Q/m0OwHz2yYp8Bx2pe61558RY3EeG5zYkxl2wClgAUhlI195rYS/alujrJqV/3yCIy+xw+CvotY1+bC1pGUzat7X3UakdqAumZAwxCqwRGL4RplbkKU8nVvCFB50l7/1E8hFqQdQwbBqRkCcd1eR730X0cZPMJHVJO8yXT+2/y+BU/CTVw4fOu5wkXh1e4NDBTNcvTZ1EZv0VLQq/I7CxnfRgFvDc7l8ekI75Ysbn0A2EdYQf8Z4azALADSCSDKpb39DXT5SrZLH4FkqZNVXQAvR1TXgt/pkZ41G8z7nu6rkXFFj3sQ6Oim6mGigG5xf+p8UXu5lLqJUHHLf4Qo5loWcNkrlc5TPfA0KNejgpqy52y6dBmvSZhC91TnSU9p4QVhAbYuCaF9OcB6ASuBdQbe6mskm1S5cdi+a8ijLIfbjzTpusE2In9WR3MqIbcgkHYYJjpfm0K7aaa3V6MFGvOWMkUIZng00OpkNqo3l52/vdk1dW87cUjMnlg0NDpn/UUK/tlJDPTAhKfMV+6VvysmqvcV08=
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


