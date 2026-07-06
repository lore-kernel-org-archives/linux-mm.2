Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 090F3C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 511BA6B0113; Mon,  6 Jul 2026 04:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6806B0115; Mon,  6 Jul 2026 04:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A2E6B0116; Mon,  6 Jul 2026 04:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 022A16B0113
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8118D140304
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:35 +0000 (UTC)
X-FDA: 84957725790.17.BF5AA0D
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf01.hostedemail.com (Postfix) with ESMTP id 863284000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="m VEa9Hz";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=JVu0W4tb;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3MSRUdgJ36+f5gsVOwRhBN9I6jFVzN7xCt/2Lhyc20=;
	b=5j4kWbqdJFVDsMmk897bayThwaBXYep7tHs/HYynFKWljzPtTCg+zNL/cmSjYwfnZeTcsN
	6x0qpl+O4BBpQQ6BON0flGYj/EByWSeK3H8xdDg4ok8dtZ75OEfVP79C9VMFBpveJ3XA4A
	UbhRdlx2qQI5gk2UZI8LsOn8e42g9Ws=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="m VEa9Hz";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=JVu0W4tb;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327713;
	b=EumnXj4+8OUpkibFdVphR6SyM8dFT0yWKIyzeFYs77THzmsOQJ6PI4b12sG0ZBKGLBXiF5
	XIb6H2eTZ19XMVsHOUFk5ptnSeb76WMJ5jNCUuZZjWft9BH7WhUHV9S90/myBLl8IRQJKq
	cqCTUVwlQg9spVEzaKo5jUGB4dj+Rf4=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 6A6591D00016;
	Mon,  6 Jul 2026 04:48:32 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Mon, 06 Jul 2026 04:48:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783327712; x=
	1783414112; bh=I3MSRUdgJ36+f5gsVOwRhBN9I6jFVzN7xCt/2Lhyc20=; b=m
	VEa9Hzk1vlobgYTVYCKbVAgsmkmEONVhSYjuK7KJyxgYxoyro731IEpBotoMzVGM
	IcAzKbyRjhfy9akataX5enI0spZUp3xs+Sx9jq+SAvveeEPGXEMjYVPCA1NE4mnX
	ERI/Ak3wR+RTuHTP8QgXLVzhEzUAheE+JjHY8wMQYoA4yFNQrKMKqaeZfKyIHgnq
	2tnF25Tc46XAaccCOP2fmdzwAWt44NAP5Pv4LlhpnNyFY/tFgpmY9wBcBbEqGUm5
	eSfHFnj+BgF8eaINbNd6czqKy4ZcYMH1Ms43NReYuGG+bQXsdtpx6akPWdFjSVWP
	vAjo8aALXCaAsWSFGO3Pw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783327712; x=1783414112; bh=I
	3MSRUdgJ36+f5gsVOwRhBN9I6jFVzN7xCt/2Lhyc20=; b=JVu0W4tbPKQaE0/V9
	gFbd7z7fyGs+RSh9dQrx+tMBBGINA/9i2gHx+HoKEMb1RhjTWAvZe4ah7jQUZ2JA
	cGncMZu1ogy02p1uP+19k0+XWwzHqSbvgqQhDa9bVje/zH/pq37c6qOYsBpzMWLL
	2WORwr7eNrCZYN8e2h7L7GIVYJIQT/IspluproRRPoK4/+GFHws4U6VVqNAttl13
	dF/1XS0l3HTb8DlxuSkrgWE5/cMoYxGWR3uiT+kJ0KffIvVBIZkj1Xmn6n8laged
	PsHd0vnc3eijQNGxcU58Tsx9e/JrLutiA+08GjyQ5HcV8bq8oL7/cByXzm6yQ16U
	HpkgQ==
X-ME-Sender: <xms:4GtLaqTI2M5Zh5tP8J6KHv5MMJkSBorXk5ShcoH4PEIx5yohDyFVLg>
    <xme:4GtLajsN69M3EFO3it9s3YQVC8Z7MqzLtYuuiZWyI0IXXZnwEl5rDYgESd0oucbrY
    MnJFw_cXfdeb82csCuiqwjKRmG7fheWo7jas2qbgneDg-LfbDM2HPv1>
X-ME-Received: <xmr:4GtLagXkGA4rJZkhHMJUoLwaJ0t_myrmMiEwqAp_B3d-BGjXPtiZMMc3aTjOsg>
X-ME-Proxy-Cause: dmFkZTGm4zvf16SnMlba+402kuDNV7Wdgl64ICKFgm4WgFiIVV7VeA8wcPDWq5Xfj4o/2k
    AL9Gant339m2locx3jvyKddSccxqBQsLr6Q0i/GUnrlf4oABK82DlLg3j2xgeCT2pIMDf2
    EtVlCYUP9DqYDDTCj2RsvkSCEUlvrEpukDkkZCIJ6z0TJxa4lRChPsBQztd7U57tSYq481
    50VbQZp21ihSXhrAiMGbjQDcMN1q6zTVFioy0Wof+rcVSC9sFC39kbRG/NGswHZ1MlKZra
    EVlgbc/2lzkcN7gsqWuuKarlpXUhRwTjwHQmxCnJT7oZN1F1UfWhCE493nhfIWTgjJKHFd
    /VqXriTINaXVf5OV5TYndS7MGWjbLnxd41Ju32/+Jrv1F0yL3HSZzl2P1rf3R/+pUFk2PC
    zQ63C5kt/uEbo7ffyB3jgVfmJ4F0YLdCg+uKVDMWOmliFdC+OyVv/5WW/8c1KUTx4YquxO
    6S0g/sEbXT6iqpa2c6qflRYXpSLAoSWbqqK1X+WTk7APgGnT4/zyRgVXaqS/7zpHykALRD
    yvKyOeSg4R+BnJcEW4vkN9uGA3oFexVptdDozPv0IB8jVBQyUe5C+LpHYR4nKANhR8+nDu
    cX7Kc8/r2mnC6eKXZQXnaG/NWLQBG9fsAY3MH1k3pmrtgYdw/CzViMXudGpg
X-ME-Proxy: <xmx:4GtLavmk7VnRgIIep1JPcCEWE21AqMF80RXb_99rMBM47luS3SJ2iQ>
    <xmx:4GtLarBGu562uLaL4WrzrNEEQwva9_tmeEgsLk6L-NKlA90fGwJHtw>
    <xmx:4GtLas9KyKBuB5M1Pg2-EhHer3xM5KeEB158mLezr8EC5BsiYpUdzQ>
    <xmx:4GtLalT6QjEA6Ux-qZTWNmLHFP4B4HBzmZlU7ezi_KVvrrVoOR4qUg>
    <xmx:4GtLaqRZOufxWYp98CC6FDu2GFz4YAhrK-BRlNrCUmE1w-eClHV6Haqe>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:31 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	kas@kernel.org
Subject: [PATCH v9 10/15] mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP
Date: Mon,  6 Jul 2026 09:47:59 +0100
Message-ID: <20260706084805.8400-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 863284000A
X-Stat-Signature: iowtj5a683be8bfsnxqazsxj8cqi1u5q
X-HE-Tag: 1783327713-784519
X-HE-Meta: U2FsdGVkX1/UqQhnXVnOkxKCOzj9SOrGbjs/dj1ALI5N5sEdch4lnH6ELHaaG4ukr5OV3DDcLo6Cf0UgBtfRdZGOIEye6soPkFFg6Aqk7TiSJdIUOTq3KppPTW2jo/krPH6ulAEshXV/Kd1Esno1C+7CEaIqBJ+vS1EcupW2y7yB3PWvUOYIqKH5AGHaCzXtG6w6ywJHWwfLB2+8/EAvmPjiK4UpZtJ4ZSwT+Jj/4zUx1om7l/zoURS4G0fJqlCI5Xw5AKdlghdLigAv8VSmhgyAJM8GOBX8U9IXIZQLucMFeEEQ4L4b0Xq/GJsm8s/tCvoOoRelVhxt5T4JotE2X2RpVEdUrGbUdrIzR7WTS5/SnCo/YF+keyb8uHgqcM96bdhVszO1gEAjO1fEdtr/YiMVvo8RfFpc89tCtLtkmqaHdWFU2IQCIhyCMIuxOEuHomPKluvmBQVI6fpRmzdtK5sZRFhinl8nLpbuzfdEL6KNbta24ZYPC+OuLV2UEHMMxDPes6zuFmymyDiG67vGl5prYqhMgouonLfMJAq09GS/srz5RmCZshzbezz3WKzwatk5gcHoJucuEArXmuSw8Q/H+MeAQjDjituywdBVyY9pR0gBo0/yqZjA5hZWyVJn2zEhSMwXK31mxrBE0GxPVwHvSChQdrF31kGAVAZs9duOcf3zK7i21mWq6RCa92DJv/8jm6Yvh2En+Ono/Lc5MYYcbpu44BI2sXjRllQ9WyazVlOx9bUgo28raoi+TvVXDb3oYKImEPx0LKLEly7capTQoinzkGJRQPS2ZDl41/6ww/dke3qgmAQcOTNV5B7WvgJVOer2m/i7b3SEGdYI7UGufaEX+i0hJ96J92Hg/c9+AaJiw+NFc5vE7LWQAr1CjQCTWcJTtt9zbcUnAqBFhwlRfKGu7YVpRFJtnAxXo2x8WpAyfvO2djqtL2uEP1wKLcY0FoO+Hy4IVVWe5Q6
 yF9NZtjb
 za5rpRyT/wsH//28JMCd//slHqu4ZX3qoaF2dWgfoy7xaWFphveMSMNlypShtaTv2SnvjXAGgPjOvkBNarpsw+P/SPZDKP2gStOr4XK6nbywfeb55ROV2axsvNKOs4g4jbLUHT3ASKG/UyAyxnvUNL9sN3PUIBvDcYh4Xf8pXcr6i5SWz8N+M/Qg72orsOyladR4+MX+jTBR2+bOneKeQH55dfZZjLT54qVSC3r/XkUT0juvkOwcn2wIj3QK/J6ymC8l6rm7Pkj7c7KFEglLhYdRQwniU9nwouKBwXvQrqbpxCWu2BTGFWPZj1yhqoWr3s3jb/esTAJAMd9subWTTmzRflvtEQO4hP4B0FrVyjI+98MK2sbwmSZTBuwG1lqeayAhCGjPB/cwH3VkyumHh9OJJLEbgZRoEwPYom3n5NhJlqFSF0y+7Fqd+eXj4xzQTqtY+oGLGaWcfScVWUBfKDR7aOd96eff5hTn7svgMVth18OEYf6FgOLzffzvz/cTwoFd9KXCENwx0q7NY7JBFW2ozajpHzG0GuvXK65YQo7KLz7eT7VYH3bLov288NO2dCZ1v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Wire the fault side of read-write protection tracking and turn the
userspace interface on.

An RWP-protected PTE is PAGE_NONE with the uffd bit set. The
PROT_NONE triggers a fault on any access; the uffd bit distinguishes
it from plain mprotect(PROT_NONE) or NUMA hinting.

Fault dispatch, per level:

  PTE     handle_pte_fault()    -> do_uffd_rwp()
  PMD     __handle_mm_fault()   -> do_huge_pmd_uffd_rwp()
  hugetlb hugetlb_fault()       -> hugetlb_handle_userfault()

The RWP branches gate on userfaultfd_pte_rwp() / userfaultfd_huge_pmd_rwp()
(VM_UFFD_RWP plus the uffd bit) and fall through to do_numa_page() /
do_huge_pmd_numa_page() otherwise. Each delivers a
UFFD_PAGEFAULT_FLAG_RWP message through handle_userfault(); the handler
resolves it with UFFDIO_RWPROTECT clearing MODE_RWP.

userfaultfd_must_wait() and userfaultfd_huge_must_wait() add matching
protnone+uffd waiters so sync-mode fault handlers block correctly.

Expose the UAPI:

  UFFDIO_REGISTER_MODE_RWP   -> UFFD_API_REGISTER_MODES
  UFFD_FEATURE_RWP           -> UFFD_API_FEATURES
  _UFFDIO_RWPROTECT          -> UFFD_API_RANGE_IOCTLS
                                UFFD_API_RANGE_IOCTLS_BASIC

UFFD_FEATURE_RWP is masked out at UFFDIO_API time when PROT_NONE is
not available or VM_UFFD_RWP aliases VM_NONE (32-bit), so userspace
never sees an advertised-but-broken feature.

Works on anonymous, shmem, and hugetlb memory.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/huge_mm.h          |  7 +++++++
 include/linux/userfaultfd_k.h    | 24 ++++++++++++++++++++++++
 include/uapi/linux/userfaultfd.h | 12 ++++++++----
 mm/huge_memory.c                 |  5 +++++
 mm/hugetlb.c                     | 11 +++++++++++
 mm/memory.c                      | 31 +++++++++++++++++++++++++++++--
 mm/userfaultfd.c                 | 32 ++++++++++++++++++++++++++++++--
 7 files changed, 114 insertions(+), 8 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ad20f7f8c179..9c4ebf0fc227 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -529,6 +529,8 @@ static inline bool folio_test_pmd_mappable(struct folio *folio)
 
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
+vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf);
+
 vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
 
 extern struct folio *huge_zero_folio;
@@ -723,6 +725,11 @@ static inline spinlock_t *pud_trans_huge_lock(pud_t *pud,
 	return NULL;
 }
 
+static inline vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf)
+{
+	return 0;
+}
+
 static inline vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 {
 	return 0;
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index d31648ba898d..6f7245609bd4 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -241,6 +241,18 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 	return userfaultfd_wp(vma) && pmd_uffd(pmd);
 }
 
+static inline bool userfaultfd_pte_rwp(struct vm_area_struct *vma,
+				       pte_t pte)
+{
+	return userfaultfd_rwp(vma) && pte_uffd(pte);
+}
+
+static inline bool userfaultfd_huge_pmd_rwp(struct vm_area_struct *vma,
+					    pmd_t pmd)
+{
+	return userfaultfd_rwp(vma) && pmd_uffd(pmd);
+}
+
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return vma_test_any_mask(vma, __VMA_UFFD_FLAGS);
@@ -371,6 +383,18 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
 	return false;
 }
 
+static inline bool userfaultfd_pte_rwp(struct vm_area_struct *vma,
+				       pte_t pte)
+{
+	return false;
+}
+
+static inline bool userfaultfd_huge_pmd_rwp(struct vm_area_struct *vma,
+					    pmd_t pmd)
+{
+	return false;
+}
+
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index 7b78aa3b5318..d803e76d47ad 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -25,7 +25,8 @@
 #define UFFD_API ((__u64)0xAA)
 #define UFFD_API_REGISTER_MODES (UFFDIO_REGISTER_MODE_MISSING |	\
 				 UFFDIO_REGISTER_MODE_WP |	\
-				 UFFDIO_REGISTER_MODE_MINOR)
+				 UFFDIO_REGISTER_MODE_MINOR |	\
+				 UFFDIO_REGISTER_MODE_RWP)
 #define UFFD_API_FEATURES (UFFD_FEATURE_PAGEFAULT_FLAG_WP |	\
 			   UFFD_FEATURE_EVENT_FORK |		\
 			   UFFD_FEATURE_EVENT_REMAP |		\
@@ -42,7 +43,8 @@
 			   UFFD_FEATURE_WP_UNPOPULATED |	\
 			   UFFD_FEATURE_POISON |		\
 			   UFFD_FEATURE_WP_ASYNC |		\
-			   UFFD_FEATURE_MOVE)
+			   UFFD_FEATURE_MOVE |			\
+			   UFFD_FEATURE_RWP)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -54,13 +56,15 @@
 	 (__u64)1 << _UFFDIO_MOVE |		\
 	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
 	 (__u64)1 << _UFFDIO_CONTINUE |		\
-	 (__u64)1 << _UFFDIO_POISON)
+	 (__u64)1 << _UFFDIO_POISON |		\
+	 (__u64)1 << _UFFDIO_RWPROTECT)
 #define UFFD_API_RANGE_IOCTLS_BASIC		\
 	((__u64)1 << _UFFDIO_WAKE |		\
 	 (__u64)1 << _UFFDIO_COPY |		\
 	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
 	 (__u64)1 << _UFFDIO_CONTINUE |		\
-	 (__u64)1 << _UFFDIO_POISON)
+	 (__u64)1 << _UFFDIO_POISON |		\
+	 (__u64)1 << _UFFDIO_RWPROTECT)
 
 /*
  * Valid ioctl command number range with this API is from 0x00 to
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7ee7651202e2..02ee8abed198 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2202,6 +2202,11 @@ static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
 	return pmd_dirty(pmd);
 }
 
+vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf)
+{
+	return handle_userfault(vmf, VM_UFFD_RWP);
+}
+
 /* NUMA hinting page fault entry point for trans huge pmds */
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4d0b6d7d9842..f0ce2e9d4ba2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6063,6 +6063,17 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto out_mutex;
 	}
 
+	/*
+	 * Protnone hugetlb PTEs with the uffd bit are used by
+	 * userfaultfd RWP for access tracking. Plain PROT_NONE (without the
+	 * marker) is not an RWP fault and is not expected on hugetlb (no
+	 * NUMA hinting), so let normal hugetlb fault handling proceed.
+	 */
+	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma) &&
+	    userfaultfd_rwp(vma) && huge_pte_uffd(vmf.orig_pte)) {
+		return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
+	}
+
 	/*
 	 * If we are going to COW/unshare the mapping later, we examine the
 	 * pending reservations for this page now. This will ensure that any
diff --git a/mm/memory.c b/mm/memory.c
index c1f79a3dfd6a..fe1d605a4d66 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6139,6 +6139,16 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 		if (!pte_present(ptent) || !pte_protnone(ptent))
 			continue;
 
+		/*
+		 * RWP-armed PTEs are also protnone but carry _PAGE_UFFD as a
+		 * marker. Leave them alone -- rewriting to vm_page_prot would
+		 * stop the RWP trap. Gate on userfaultfd_rwp(vma) too:
+		 * NUMA balancing preserves _PAGE_UFFD on UFFD_WP-marked PTEs
+		 * when applying PROT_NONE, and those still need rebuilding.
+		 */
+		if (userfaultfd_rwp(vma) && pte_uffd(ptent))
+			continue;
+
 		if (pfn_folio(pte_pfn(ptent)) != folio)
 			continue;
 
@@ -6154,6 +6164,12 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 	}
 }
 
+static vm_fault_t do_uffd_rwp(struct vm_fault *vmf)
+{
+	pte_unmap(vmf->pte);
+	return handle_userfault(vmf, VM_UFFD_RWP);
+}
+
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
@@ -6429,8 +6445,16 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 	if (!pte_present(vmf->orig_pte))
 		return do_swap_page(vmf);
 
-	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
+	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma)) {
+		/*
+		 * RWP-protected PTEs are protnone plus the uffd bit. On a
+		 * VM_UFFD_RWP VMA, a protnone PTE without the uffd bit is
+		 * NUMA hinting and must still fall through to do_numa_page().
+		 */
+		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte))
+			return do_uffd_rwp(vmf);
 		return do_numa_page(vmf);
+	}
 
 	spin_lock(vmf->ptl);
 	entry = vmf->orig_pte;
@@ -6544,8 +6568,11 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 		return 0;
 	}
 	if (pmd_trans_huge(vmf.orig_pmd)) {
-		if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma))
+		if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma)) {
+			if (userfaultfd_huge_pmd_rwp(vma, vmf.orig_pmd))
+				return do_huge_pmd_uffd_rwp(&vmf);
 			return do_huge_pmd_numa_page(&vmf);
+		}
 
 		if ((flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) &&
 		    !pmd_write(vmf.orig_pmd)) {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index ff593b5d6eed..df3cbbc3cf52 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2666,6 +2666,12 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
 	 */
 	if (!huge_pte_write(pte) && (reason & VM_UFFD_WP))
 		return true;
+	/*
+	 * PTE is still RW-protected (protnone with uffd bit), wait for
+	 * resolution. Plain PROT_NONE without the marker is not an RWP fault.
+	 */
+	if (pte_protnone(pte) && huge_pte_uffd(pte) && (reason & VM_UFFD_RWP))
+		return true;
 
 	return false;
 }
@@ -2726,8 +2732,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	if (!pmd_present(_pmd))
 		return false;
 
-	if (pmd_trans_huge(_pmd))
-		return !pmd_write(_pmd) && (reason & VM_UFFD_WP);
+	if (pmd_trans_huge(_pmd)) {
+		if (!pmd_write(_pmd) && (reason & VM_UFFD_WP))
+			return true;
+		if (pmd_protnone(_pmd) && pmd_uffd(_pmd) &&
+		    (reason & VM_UFFD_RWP))
+			return true;
+		return false;
+	}
 
 	pte = pte_offset_map(pmd, address);
 	if (!pte)
@@ -2763,6 +2775,13 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	 */
 	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
 		goto out;
+	/*
+	 * PTE is still RW-protected (protnone with uffd bit), wait for
+	 * userspace to resolve. Plain PROT_NONE without the marker is not
+	 * an RWP fault.
+	 */
+	if (pte_protnone(ptent) && pte_uffd(ptent) && (reason & VM_UFFD_RWP))
+		goto out;
 
 	ret = false;
 out:
@@ -4515,6 +4534,15 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 		uffdio_api.features &= ~UFFD_FEATURE_WP_UNPOPULATED;
 		uffdio_api.features &= ~UFFD_FEATURE_WP_ASYNC;
 	}
+	/*
+	 * RWP needs both PROT_NONE support and the uffd-wp PTE bit. The
+	 * VM_UFFD_RWP check covers compile-time unavailability; the
+	 * pgtable_supports_uffd() check covers runtime (e.g. riscv
+	 * without the SVRSW60T59B extension) where the PTE bit is declared
+	 * but not actually usable.
+	 */
+	if (VM_UFFD_RWP == VM_NONE || !pgtable_supports_uffd())
+		uffdio_api.features &= ~UFFD_FEATURE_RWP;
 
 	ret = -EINVAL;
 	if (features & ~uffdio_api.features)
-- 
2.54.0


