Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53486C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6A26B0088; Mon, 29 Jun 2026 08:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8FAD6B008A; Mon, 29 Jun 2026 08:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4486B0092; Mon, 29 Jun 2026 08:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1AC6B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:07:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 868C21C6D26
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:07:56 +0000 (UTC)
X-FDA: 84932826552.12.1AB29F7
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9C49D10000F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:07:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="l 3QM2Xg";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Lo9d2zIC;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782734874;
	b=IU0eGQeaWd4cGazO/8m0GcYKq5aErY653v1mjWy0V6msJu74tmmHCXQgZiJxo+7LRDCCLD
	wxIUhXt4K1xFpH1KyFatHH9VpD/EwN7ZgrbdqR5g8yHfS8OAZfVTte+XqEecYD2jDiwWJM
	miaF+JwyEDvfMAgSowPhSCl1rHLid1E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782734874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bi6ZCi9/zUIsKmhwfb8Lt5NG7YE3vAzXLT8nxhhcSmo=;
	b=RlJOuyEXrFGJP5Dtfa6ez3F07K8CP/kfdwH0M+gwqxlpSsMYhOkp3y0DQYdTxmA4htj95w
	8ENTGxHJF4og4IxGk8LokTnjIbKAzr/7CGBK/3S+nWHox6mknv2tD2g95UL/1FjV+2EacZ
	50d070XzideFWIOhJjb4BgewH+gf6o0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="l 3QM2Xg";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=Lo9d2zIC;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id 25BF3EC013B;
	Mon, 29 Jun 2026 08:07:54 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Mon, 29 Jun 2026 08:07:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1782734874; x=
	1782821274; bh=Bi6ZCi9/zUIsKmhwfb8Lt5NG7YE3vAzXLT8nxhhcSmo=; b=l
	3QM2XgwHgomoBQgqxWSMaOWRCXcCide7CHiPnPupUjv19o/menCd0kg4R1Nq31OM
	HVbTPEJkIK3Po3sU9yCFvhc7ZDRMIjQJQpQyekp6bosmr1NKYKHf8EwO4K54af6P
	Qv6u0HmansdEFxwNDzHW2x2oLt9hy5VpA6B1e3OPumixA3rLfQeQVfbnt6HePGfR
	MkwRacUnOhT0awnCd9O+aEBdGsLYT2D02ZD43DhSk6He06sj/0Qj9mexjbQA8jSr
	k1LxkvKUfeUkSTi6vhz6xUnAY1U4SO3ADp4GEW3CSQL7BYKv8Y4vGVvFGHjEO1sQ
	fwd/zp6zw9WpYA3rpYb1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1782734874; x=1782821274; bh=B
	i6ZCi9/zUIsKmhwfb8Lt5NG7YE3vAzXLT8nxhhcSmo=; b=Lo9d2zICXeR+cjNgs
	261AyoQ6sS7y3HTmeWssILw2PuOn48xskYIoimhRJiXZIV5WwRSy4FcRQ7l0SgC4
	GoptpZmGaLMi42a/TegH7SoVYnCRPWeQIpeJi6q+EBIKg+jHcWcyfFhEUgdsoVLZ
	QYsSWX4mBIaTRAJ3WKiY8C04ntZB7GTlharlLFHcE/OZU2Rk/WhkFVLon2kSaikR
	ZTxWloVStvaA5qaz3PO43o0LVCgHaJSrs6Z7ulSnMwnevChfgdDz7/5d6jXPmqEW
	O8XZX9zZh0ywVXr+wmrguATTiOx6xkPa2sP+Y/xxrmw8Z9vtLau38Zk7FyTh9qf3
	DqK8Q==
X-ME-Sender: <xms:GWBCaojN1CwDVyZ_W0FXZ0mxmF8qKy8PYQA2sax-aTyDuRscYQS0TA>
    <xme:GWBCak_6zX6XLpSwPS_jsfIv8A1B_i8_z46Pei6Ue5Fugxg-Wfs7xG-WMq7NNq0ft
    EnjZAPwUJZmE3K5NNu7Clg_9G2EKi4N514zmLbgX6t-xBWJTXo1O_lc>
X-ME-Received: <xmr:GWBCaonNJ5jDgw-2m_QxGIM7p9QG1oArHj_ocdSqxVQ49xze8eSZ5F58kPNr0w>
X-ME-Proxy-Cause: dmFkZTFY6shGePvmxOMh2n7JXpRvMYayhSPkReA/qp2Kk9FFh7qIwqznFdabTWQQmbT6np
    orb7nZimraCt1e9FjxE+D963WQ5XDZfLTwLobafoyB3i66gOkO3z85tAcKnmI3RB25+PVB
    EZ98eAuca1GkEm7XR3L2jnIB5DGE7Gq/dUpvQ2A9oIHx8hwh4f84uT4y/OhQorrh2fKXDR
    UYo9Jps0lppZOy2xiKorTonIMZqLK9GUCnCQcdTCD/z+aL3OihCctiT9iWAjf4SCGuOWH6
    0ORm+HxXgzRDvylsCh2WOkVei6ivCiAy/pOXBTW6wB8gDyVJ0wFaPNiIhLc7QTSUTVd0fR
    ERLjdb6EZU+Dki41pvOSDzzqVu0cMk2tI091bs/p27sDSxRwRpDFmiDRc3/ZDY2u5Ul2SI
    OPx33kXzgG+E/c4y6gGL1mQrS3z8rptnZsZ4owrtpg2lH1eqKB7La0D+PkCoMdBn0npl29
    fD+0maj2YD2LkSNZuJUbu+bZ9k0d5jj10L502yhfObxYmLwVWXauW5OKlNaYHvNOSZYRh1
    B1MLAELYXcfvK9e4BzhnpKOZDobJUxR4/EAkI3/r5Tg+zhq8MIV22YbgSBywV/m3C/Ol9Z
    tfhUrxn0CZN6lvpckz/MdrmW6RNbLHgNDoOCcrXKwIaaGIk2nwGsc/g+cWNQ
X-ME-Proxy: <xmx:GWBCai2qw0XmRmxyWPR6FLbmm54UDPpSJ20Jy8hIy4K45o57rj-E0g>
    <xmx:GWBCatQ1eDVdWizfR8qQVpekgYDYqwn4Dsftb6tocDXLqeey1LsS4A>
    <xmx:GWBCaiN1RDvbgdYM4V9an_qnOH6_hzMi1MOIPxIkQuD6yWZVDzbnFA>
    <xmx:GWBCahh4mGPnsEewwN-WO51dA4XjPo8tvQM7NlZUzxe9tSpVkNg4Xw>
    <xmx:GmBCamgDxFRgLtpm6Rnn74QjIJNnDeW-onOquh5F_Lb1G7ItVpF1voWu>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Jun 2026 08:07:53 -0400 (EDT)
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
Subject: [PATCH v7 01/15] mm: decouple protnone helpers from CONFIG_NUMA_BALANCING
Date: Mon, 29 Jun 2026 13:07:32 +0100
Message-ID: <20260629120749.566063-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629120749.566063-1-kirill@shutemov.name>
References: <20260629120749.566063-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: warimxgu51egpmj4cweo9tef584pr5n7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9C49D10000F
X-HE-Tag: 1782734874-394746
X-HE-Meta: U2FsdGVkX1//6O7E0P1uTSnlfbxGq4lD0hQhitWL3CHVIoHGXr1/5wwJ8+sIqzuYvzlplc+0aiZqFc2Lxqw/h4201yDjZvGZvIOndfPygLcLqVx3rkzGPKHUQSBxRVgDM2mpJ2EYCHmLSv0soceY/xCtADcOHXP9F7s7AFHYHahhp/4JGB3p8LCu/cJb8P9AJqfWv/1u8sJTFLm6mUVgOK9WslwhQwGEyQ/p8Z7sl0rMIprj4XUZWPhAdns1qI04Xpo3neMwFUUcBFjug/+34Prei6oqMYGKmBCF9E4jDzRIa0J5az/G2rJ1+ofFFYKu5OygAMgllfV+TAv70G6DqKGFRf459e7jAE+GhhH/7pdBUnAzLCXKKEVth1vZM/0XsRg/yk81PHnytK+Xt5v86vbHinkPPuQcIcZs97cA6IcdvHE/V1yJO0jvizr6u4MNf1bmTshxJVzIoAQJpZMluO2DPmgCWrDJD+wmRJ44KVj9oyBiw5CbsyE+K6hKqSWi8eYG9AysdaSmCF2wGsam0vFwtPST69C6Nlc1nsEKRiYAg6S0ASoQI8L4TG1eo4aetnyvpbN5b3A77tEtUjoDgSMxuBk0D4PVIhUy4uO3eCRu8lzkETNpvWETQiqeTCzxkEiC6qWmTzlqPaLOfk7TsfHSg88Y2YHEpYJ1Vpia8yT2F29OtGwMYr6s77dy/zh5ltvQth4bBMEM/VSU2zFwh5ANaaqkjnvNJHvZbf9ajewOzFi6S+LnF+nJBRvZqV9Zxpn711opPIrocqUzIkAKMyv0PqrzaHNv+52iI5T9oym3woL11J/q1qn/SdbKZF/7UltkXGg+WMR4RG1qdsebQuymeBE5d4rAkgRScINaXVrHlmHuaCJDqv+ZjbBXZ+2t8qvDpZXMDo/FVrqQy0ozgS3Xv25xbGCdDthOJfDyHRfjCNN7jlhTODhhSjETC1oZjsD0icUtu9g5v+YUBnn
 CciDlrS/
 PTra+rhacDDSAqmkRyf6BHnsHulJFBeyClfoWjO1mkJka9AkUDfCLqXok86wdMguB4Thhgxyq6PpnhGOjkyxd9niHbLmwRxumhdkihbXt1/4Kat6dNmwVu5iReZH763u/WnQ+zQtfgMwB9oY3+PVHYUNYGgx52phLYbTL7i0OlADYKA/shDKhBsFE9e0hPyJazBlqdSjKQVQry1lDx+MQC/VEvdTso2M2ua7HaeSmGQH2lqsxfZONJW/O3F/avTJ+YTJpzyFvi6/AYIlJwuFoPiKmlhrV6NaK6EemGBBTlRS94AbSsh0PDJSyytl5n4SD66Ro9n+TXocqTX20TiMurn3AZl39r2A67BdDhBchY4nDXvnZxQjsIAu5AmqbdEaDDTu7MyDLxvPon3HROfFQKSeL9Xk6m5wr0QoUc4dtg92sTuGRQz7HqbVqHj7/AA/VKlnMP8ydYOxpEgEu1b6894AptyE+Oa6La/HUjTB4Kwcm8DPSqmPe3je+1u62+Q06Zi3xK6a5epTTOE0lzSBbf5cvxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

pte_protnone() and pmd_protnone() detect present-but-inaccessible page
table entries. This capability is useful beyond NUMA balancing -- for
example, userfaultfd working set tracking uses protnone PTEs to track
page access without unmapping pages.

Introduce CONFIG_ARCH_HAS_PTE_PROTNONE to decouple the protnone PTE
infrastructure from CONFIG_NUMA_BALANCING. The six architectures that
support protnone PTEs (x86_64, arm64, powerpc, s390, riscv, loongarch)
now select this option, and CONFIG_NUMA_BALANCING depends on it.

No functional change -- the same set of architectures continues to have
working protnone support, but the infrastructure is now available
independently of NUMA balancing.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/Kconfig                           |  1 +
 arch/arm64/include/asm/pgtable.h             |  7 ++---
 arch/loongarch/Kconfig                       |  1 +
 arch/loongarch/include/asm/pgtable.h         |  4 +--
 arch/powerpc/include/asm/book3s/64/pgtable.h |  8 ++---
 arch/powerpc/platforms/Kconfig.cputype       |  1 +
 arch/riscv/Kconfig                           |  1 +
 arch/riscv/include/asm/pgtable.h             |  7 ++---
 arch/s390/Kconfig                            |  1 +
 arch/s390/include/asm/pgtable.h              |  4 +--
 arch/x86/Kconfig                             |  1 +
 arch/x86/include/asm/pgtable.h               |  8 ++---
 include/linux/pgtable.h                      | 32 ++++++++++++++------
 init/Kconfig                                 |  8 +++++
 mm/debug_vm_pgtable.c                        |  4 +--
 15 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b3afe0688919..6e123adca29b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -78,6 +78,7 @@ config ARM64
 	select ARCH_SUPPORTS_CFI
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_SUPPORTS_PER_VMA_LOCK
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 27689c62bd25..83eb707508cc 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -553,10 +553,7 @@ static inline pte_t pte_swp_clear_uffd_wp(pte_t pte)
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * See the comment in include/linux/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	/*
@@ -575,7 +572,7 @@ static inline int pmd_protnone(pmd_t pmd)
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_present(pmd)	pte_present(pmd_pte(pmd))
 #define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index d8d252325017..177fb9dc6432 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -67,6 +67,7 @@ config LOONGARCH
 	select ARCH_SUPPORTS_LTO_CLANG
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+	select ARCH_HAS_PTE_PROTNONE if 64BIT
 	select ARCH_SUPPORTS_NUMA_BALANCING if NUMA
 	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_RT
diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 223528c04d73..1952e34bc8ee 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -623,7 +623,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline long pte_protnone(pte_t pte)
 {
 	return (pte_val(pte) & _PAGE_PROTNONE);
@@ -633,7 +633,7 @@ static inline long pmd_protnone(pmd_t pmd)
 {
 	return (pmd_val(pmd) & _PAGE_PROTNONE);
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_leaf(pmd)		((pmd_val(pmd) & _PAGE_HUGE) != 0)
 #define pud_leaf(pud)		((pud_val(pud) & _PAGE_HUGE) != 0)
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index e67e64ac6e8c..53a0c5892548 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -490,13 +490,13 @@ static inline pte_t pte_clear_soft_dirty(pte_t pte)
 }
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE | _PAGE_RWX)) ==
 		cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE);
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline bool pte_hw_valid(pte_t pte)
 {
@@ -1067,12 +1067,12 @@ static inline pte_t *pmdp_ptep(pmd_t *pmd)
 #endif
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pmd_protnone(pmd_t pmd)
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index bac02c83bb3e..36b64a24cf30 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -87,6 +87,7 @@ config PPC_BOOK3S_64
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	select ARCH_SUPPORTS_HUGETLBFS
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select HAVE_MOVE_PMD
 	select HAVE_MOVE_PUD
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 3f0a647218e4..58c12f4fac66 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -71,6 +71,7 @@ config RISCV
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
 	select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
+	select ARCH_HAS_PTE_PROTNONE if MMU
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
 	select ARCH_SUPPORTS_SCHED_MC if SMP
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 5d5756bda82e..8139e0b2f008 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -534,10 +534,7 @@ static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
 					PAGE_SIZE)
 #endif
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * See the comment in include/asm-generic/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_val(pte) & (_PAGE_PRESENT | _PAGE_PROT_NONE)) == _PAGE_PROT_NONE;
@@ -547,7 +544,7 @@ static inline int pmd_protnone(pmd_t pmd)
 {
 	return pte_protnone(pmd_pte(pmd));
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 /* Modify page protection bits */
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 84404e6778d5..ad56daa6f874 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -148,6 +148,7 @@ config S390
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && CC_IS_CLANG
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+	select ARCH_HAS_PTE_PROTNONE
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_SUPPORTS_PER_VMA_LOCK
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 859ce7c7d454..0689dfdba407 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -842,7 +842,7 @@ static inline int pte_same(pte_t a, pte_t b)
 	return pte_val(a) == pte_val(b);
 }
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return pte_present(pte) && !(pte_val(pte) & _PAGE_READ);
@@ -853,7 +853,7 @@ static inline int pmd_protnone(pmd_t pmd)
 	/* pmd_leaf(pmd) implies pmd_present(pmd) */
 	return pmd_leaf(pmd) && !(pmd_val(pmd) & _SEGMENT_ENTRY_READ);
 }
-#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline bool pte_swp_exclusive(pte_t pte)
 {
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bdad90f210e4..380c4aacd42a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -124,6 +124,7 @@ config X86
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if X86_64
+	select ARCH_HAS_PTE_PROTNONE		if X86_64
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
 	select ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP	if NR_CPUS <= 4096
 	select ARCH_SUPPORTS_CFI		if X86_64
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index ac295ca6c92f..36c44350f843 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -985,11 +985,7 @@ static inline int pmd_present(pmd_t pmd)
 	return pmd_flags(pmd) & (_PAGE_PRESENT | _PAGE_PROTNONE | _PAGE_PSE);
 }
 
-#ifdef CONFIG_NUMA_BALANCING
-/*
- * These work without NUMA balancing but the kernel does not care. See the
- * comment in include/linux/pgtable.h
- */
+#ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pte_protnone(pte_t pte)
 {
 	return (pte_flags(pte) & (_PAGE_PROTNONE | _PAGE_PRESENT))
@@ -1001,7 +997,7 @@ static inline int pmd_protnone(pmd_t pmd)
 	return (pmd_flags(pmd) & (_PAGE_PROTNONE | _PAGE_PRESENT))
 		== _PAGE_PROTNONE;
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 static inline int pmd_none(pmd_t pmd)
 {
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 2981e386da7b..7d3dc8abc6c8 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2129,18 +2129,26 @@ static inline int pud_trans_unstable(pud_t *pud)
 	return 0;
 }
 
-#ifndef CONFIG_NUMA_BALANCING
+#ifndef CONFIG_ARCH_HAS_PTE_PROTNONE
 /*
- * In an inaccessible (PROT_NONE) VMA, pte_protnone() may indicate "yes". It is
- * perfectly valid to indicate "no" in that case, which is why our default
- * implementation defaults to "always no".
+ * In an inaccessible (PROT_NONE) VMA, pte_protnone() may indicate "yes". It
+ * is perfectly valid to indicate "no" in that case, which is why our
+ * default implementation defaults to "always no".
  *
- * In an accessible VMA, however, pte_protnone() reliably indicates PROT_NONE
- * page protection due to NUMA hinting. NUMA hinting faults only apply in
- * accessible VMAs.
+ * In an accessible VMA, pte_protnone() reliably indicates a present
+ * PROT_NONE page protection. Today the kernel uses such PTEs for two
+ * purposes: NUMA hinting faults, and userfaultfd RWP tracking on
+ * VM_UFFD_RWP VMAs. The two are distinguished by the uffd PTE bit and
+ * the VMA flag; see include/linux/userfaultfd_k.h.
  *
- * So, to reliably identify PROT_NONE PTEs that require a NUMA hinting fault,
- * looking at the VMA accessibility is sufficient.
+ * So, to reliably identify PROT_NONE PTEs that require kernel handling,
+ * looking at the VMA accessibility (and the uffd bit on RWP VMAs) is
+ * sufficient.
+ *
+ * Architectures without CONFIG_ARCH_HAS_PTE_PROTNONE get the always-zero
+ * stubs below; PAGE_NONE references that survive to runtime fire the
+ * BUILD_BUG() fallback, since callers should have folded such paths to
+ * dead code via IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE).
  */
 static inline int pte_protnone(pte_t pte)
 {
@@ -2151,7 +2159,11 @@ static inline int pmd_protnone(pmd_t pmd)
 {
 	return 0;
 }
-#endif /* CONFIG_NUMA_BALANCING */
+
+#ifndef PAGE_NONE
+#define PAGE_NONE ({ BUILD_BUG(); (pgprot_t){0}; })
+#endif
+#endif /* CONFIG_ARCH_HAS_PTE_PROTNONE */
 
 #endif /* CONFIG_MMU */
 
diff --git a/init/Kconfig b/init/Kconfig
index 5230d4879b1c..9d91074c5d0a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -944,6 +944,13 @@ config SCHED_PROXY_EXEC
 
 endmenu
 
+#
+# For architectures that support present-but-inaccessible (PROT_NONE) page
+# table entries detectable via pte_protnone() / pmd_protnone():
+#
+config ARCH_HAS_PTE_PROTNONE
+	bool
+
 #
 # For architectures that want to enable the support for NUMA-affine scheduler
 # balancing logic:
@@ -1010,6 +1017,7 @@ config ARCH_WANT_NUMA_VARIABLE_LOCALITY
 config NUMA_BALANCING
 	bool "Memory placement aware NUMA scheduler"
 	depends on ARCH_SUPPORTS_NUMA_BALANCING
+	depends on ARCH_HAS_PTE_PROTNONE
 	depends on !ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	depends on SMP && NUMA_MIGRATION && !PREEMPT_RT
 	help
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 23dc3ee09561..5e9f3a35f924 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -672,7 +672,7 @@ static void __init pte_protnone_tests(struct pgtable_debug_args *args)
 {
 	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot_none);
 
-	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
 		return;
 
 	pr_debug("Validating PTE protnone\n");
@@ -685,7 +685,7 @@ static void __init pmd_protnone_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
+	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
 		return;
 
 	if (!has_transparent_hugepage())
-- 
2.54.0


