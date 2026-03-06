Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 551F9F01835
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 13:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971EF6B0005; Fri,  6 Mar 2026 08:59:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920636B008A; Fri,  6 Mar 2026 08:59:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8565D6B008C; Fri,  6 Mar 2026 08:59:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76A986B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:59:47 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29D5C1A05BD
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:59:47 +0000 (UTC)
X-FDA: 84515796414.22.F760791
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	by imf26.hostedemail.com (Postfix) with ESMTP id 86E9514000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:59:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=H6P4ao8N;
	spf=pass (imf26.hostedemail.com: domain of jianhuizz@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=jianhuizz@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772805584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EO4E4RR2NMVQkuWMb7xivQNzUGAZ+NqsTaP5UMh4SU4=;
	b=hgRTAAEt7UIBfh/11GmiUJdTyBuw8GiJB++m1vMRpMGfTqcy3F7UeogolNtw0Vokaqpf0I
	SCTfQYf6AbxIJfxZduDR2ktqBUuBm5G4xumQHNGPyOmAR0HQ2n53rSx/7bwO6ynyy+Wki0
	q5c/9tCxf7wFVJaULgi1OoxNvilDInw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=H6P4ao8N;
	spf=pass (imf26.hostedemail.com: domain of jianhuizz@qq.com designates 162.62.57.210 as permitted sender) smtp.mailfrom=jianhuizz@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772805584; a=rsa-sha256;
	cv=none;
	b=489skeWrvxqfklpQ7rlLj2o9Q9FyOE3ppASlGBpA2Ovj5sO8Ft+cE8XKMaa3jmPVdmMFbH
	NqLJ5vHh+UNQjze9eLSgQca0oPHnH0RgaHqk4F6BZy34xolo7IXLXoaN3bdelUgfuwRA9M
	eq5zodwGFViJnN4MgH0+JQr3hFTXeF8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1772805575; bh=EO4E4RR2NMVQkuWMb7xivQNzUGAZ+NqsTaP5UMh4SU4=;
	h=From:To:Cc:Subject:Date;
	b=H6P4ao8NfdT/AZyoYXiS2Fc0QrPpgTITtyu0tOwcc6hjcJnYfSB1zADWBfCj+KlVS
	 ttPQxgwHKu5p+BNWXTse/6vFphtGXE3dAlpgkGL4coN2NDqZpMDMbbo6aWmT6pobuB
	 DqeLLj6OTZLV/uXoWriZATn+3gnvyF4LJx/YHVDQ=
Received: from zjh-os.zhaoxin.com ([2407:cdc0:d002::1061])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id EDCACC70; Fri, 06 Mar 2026 21:59:28 +0800
X-QQ-mid: xmsmtpt1772805568tvj671ho7
Message-ID: <tencent_F70AFD1D8067E3D2409764BC1A199DA6AF0A@qq.com>
X-QQ-XMAILINFO: MllZffuBkEb56bAAPd7juxWrgPh++Gjl/gJCYRApNRUup2ECelGqd86l2Z+tAw
	 TZoCbzo3M+9D6TOn7IHUbhmMD37MmH5s8nL5fRdGDbUd0B/cNfv9ZJEtPBIOqAyEwWlOD3BDjaW8
	 SZtfTZviILef/JRGHoWRcJJhu3nuptb2cP0eCO0WjFzOjIJsw/fsozpP1GlOec5VdGFwgGEA1YYy
	 cYl4f1pHa7RIFWIV7W0aYDtp8+gdaA3PynLrX1uNUDCPWZng9oqDNz+8/UA+eQXiUXRAe8/XMiyI
	 mC3JyNWxeSGOLYTgBUXKxHojLiEder0y5fYnrRvgBbSb7Lqh1mZ6FZlm2s7QBIGJycyoWl81hCAy
	 uEes/aCAMz6tZOdkUry9oZBQMADdRrRLITl5k94IxQmnSMHqp9o0IAa7JN4fVvXJaxmT1hoXcUgS
	 o9mXq0kmAKNot2vXg0Qjjn8FjIl1ZJlQUl0k0V3VIgilx1mp7sxT1ImgJd7iqa5LhT2wIyiIb5I5
	 bscaYR/JipocAH8ANcPVVvea51jzyvWq/aI1RoTPvW7pIW03ne3jKhASEbDdWVovu1Y/KsISVxx5
	 8UairAnz8fv8KYr7W1zbpj73Oddy87EpLieQ2GjgnZGipnMIis7jCh6TcQLC0c8g8UKCLipQvLal
	 vikHR2u5gT5Tn8oBSGZCM9R0NDql8tDaRrcUYGzfORj1xZVuPd19DHtwBZEQ99KCzQTIcxUh9uVq
	 rQI1m4lg9s/Wdbl9B4BRXtLB2DTk5hKevSunsuKm48fqIMMNrQnQxs2r5KMR38UdihSq8mbIHzvs
	 iiOENGd9yKbu6pavWV/fkUuYplQv6bnBdJsrEEDlsO1lerIgUytEszjvNoE0Aohg+sd2t6SCvp1E
	 1UN3Ulj2+/tkVlFaThdn5yu9jcIZsqEIpjtkkD8XAKSj54Y1weAHE08wkGIpIx0v+15tj5B/WHvv
	 B9TxhPvHVklU0h+vOOapetmh3RVKCzyZTUAnwU+DG+AWdiUaQtZ8kOF/SDY+7cQ09yGQ+cZW9LSf
	 JmiYyMtXQX2m1pjjMV5esfxKBEQKSqsqNOBEXisg5SKDHdkuu5JcynTsjflAKKS4GR0y71F4KnbZ
	 nPa4sLaY/VFs7j+4GpsS0WNLWwCnmdJvKirhBB
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Jianhui Zhou <jianhuizz@qq.com>
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
Date: Fri,  6 Mar 2026 21:59:26 +0800
X-OQ-MSGID: <20260306135926.169662-1-jianhuizz@qq.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 86E9514000B
X-Stat-Signature: cizzp4w4styy9xu6jw94wmhskwpukbgy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772805583-403171
X-HE-Meta: U2FsdGVkX18BmtpfXabcbcIfvPFm6WqcssaN6RfBA0GuBdtuqEowCuggvQiRgsv5X7a4Rkwg5MCsOJ7bJE5sfjS25qegLWBuUgAgeUEbo9zEPefULvyC5bCROnhev1IVh/WPfnodKiTN4BrgC2lzaXKIOsuCN0MFI2Tz55D/4CMukJuHdqjQjRDEf957KYJr96iCiwl6MrrPe3ZT6eOHVGdca9Zy5o2AcOiNOIyacTwPGYHRSrsxtVQ4XMM/Dep5PQCDmFW3w1vywP5hiSGcLE5O+qC6oIe2uUMDUQ1jdSI0T8XKtx3MqLfJ4JPBCNz6Axoi+AE+1Wlf1XZXx2rL1TtUOXG46UNz/QGEoWPOFtZQZ+Jra/o1eXEeBe+OdfJpfu//VaiSZf15OblUTHdbCmHKyruWxnW9QpT5mP916jWWIqmcJ2OKmaM7qVaG3hYrvuO6mXXckjLetjOU5mKyx9QFJlHodFdtJZK2W+iRgCzrhA2UYFrK8qNt4+iRfkIdzYfiRmrGJpjXX0mI14zqGAwnL0RbeYs0RYnS15jyZ3QHsWE/mtbKI9NjLycMQy0OLfti9rwLzxnXd6V2QbVMkNw5J8y5M/7/CrdU5uDuKQ7AZAt0CGonWKSiKONG4/TNHw2LK1K4r9ti7Dejh1nMiuP68/Z0tWnN0AFPfHkEU+9UdIeEMRxFCE1VV5clbNJaURLgabVNS1Ps7zSdo7IzFcC0kk4nrAKf/YvwEzQZ0upYN+R2S3VcZT8ZUPLveJVqlbc/XDvLHsjEcVd5SHcp8ysA47VJ6bj+P4NvEINV7Jzzl5vakMs27349yn1k5dflN4RAB3ljzIXnZ0WEE24nlVroFZFgma0jI7UFZmKKYLOFkOzQ4g5SdZoncc9UcaDuw1uphIzIDGKEYd0hugjWMeNg80zpAjPWfZex2F4nO3zt+njwQV01R3XOVqQhTlBEeb56YskXN8L89JNEdJH
 89G4+8mg
 3M6NCH9vsIyDfuSTv6ABKshIACOQrv5oFBhBLy69Taqu5IB7aDbgG9W3h6gjxbT+ngNBUnhI7sBTaPrhOF0fy0Z1WYL4nXACYk6hZHJeVJf9tzD4smQ0vcGZn98o0DCA5bXOsneri96DMe/AJkmhHiGtaauyEtBYS01+uncaBnEWQN4nzRM74+4sVzBaWPF92hVzWVe/b43Zn6vae7JkjSdv8Hddb7Qt2hBbGa9AEs/lZ/VcekNhpEmdzldvezU4M0a+CzXkJ6zZbS0wdDffuiFt8qjXW/g1MC0Fac7U0xTn5ch3yUGvdBqOncdFyV+G4pCM+E/GxG6pqjBetQhNVXgseUCWbFhlINUIVtz2GDVuT8lQtZq4kyPXKpKZGpoqsR906Qr1CMsTjzoeUydOOnCj1GNNieibXwjZxVN/wTzjIXotLhTQRrLQ/Yf8xu08HFkt/ehBXqTBvQ8s6qxQo/VmkcWLlas+3bgIgbwJ3ev74sKnjmJldEw3mPTlWHiQfRUXtt2ih4Xz/99Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jianhui Zhou <jianhuizzzzz@gmail.com>

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


