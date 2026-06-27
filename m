Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD449C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 07:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C7F6B00AE; Sat, 27 Jun 2026 03:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2CB06B00AF; Sat, 27 Jun 2026 03:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F46A6B00B0; Sat, 27 Jun 2026 03:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62DC76B00AE
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:25:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E4BBA1A06B5
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:25:20 +0000 (UTC)
X-FDA: 84924856800.26.C7A7600
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4BF3EA0004
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:25:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mFLDYxrL;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782545119;
	b=6eKtOYMYm9YAgR7m7WLJ/ig30pROkF7okk2JYsV9jJAshpnZ5Itlx7NoEFRN4qAVuzVcPp
	/7uibWio2qUUwLt8jp5UpdPCHZ1z8eRpxpmfhTIQ118lVZkpz/ozQ6VEG0r4J5yOJgRSgn
	SXFKWODHxGGi3Oc39brpT3n5sdiOTAU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782545119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jYH2dLJwZ3cdQqCNGntqjFRlxZpQAFD5iRYR2M5+uBI=;
	b=pOSvHQ0o2fHfA7jJJMVf1Qcl04/rmsZrKNFq5pV/nR9NsUuuV7HOBlAZ6VAwUwWeZ2JYRM
	PprucUL3SBc+VVW27JdjT78GxHSQx1O7qWnbQa/bQJbpJ44OuRp0zQWTSVZyivMwo50fOk
	q6yBb/m//K3Kxz54ST5iY9Bcgd2Te1c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mFLDYxrL;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782545117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jYH2dLJwZ3cdQqCNGntqjFRlxZpQAFD5iRYR2M5+uBI=;
	b=mFLDYxrL7UzOFziiy3W002Tsl27Ys6rVpAkAtTN7GhFfN+EGRWLkUTDlYqR50K6+LYo6l5
	K3L7/YS7n8L0JMlaYVk988HcdfDtUwbN1MTF4Dte5n7Mho32m3Y188LRnHLaIFnN/7unqA
	Oj9MWBWemhL4V5W4bxZL5DpOGcwAxEE=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	peterx@redhat.com,
	usama.arif@linux.dev,
	willy@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [RFC PATCH 5/8] mm: add reserved THP vma flag
Date: Sat, 27 Jun 2026 15:21:53 +0800
Message-ID: <e790929dd5853aafe9bfbf7adb684bf7d3093d43.1782538002.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1782538002.git.zhengqi.arch@bytedance.com>
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tfkncawgyxckn6s8ao68f5igftwgk8fj
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4BF3EA0004
X-HE-Tag: 1782545119-98940
X-HE-Meta: U2FsdGVkX19Fb6JrHccdX5AMZ6ZKzBN9eHkNME91zKNmUJh+VHfXF6dt623RpmBMTIkxD+7CMTCxugpt/58AXat0kO/lB/TqS741TR+ltO/2QQcq9u/lkhtEapR5gbPo57liLyWLBVUN5A2mICgCfuIsqBilJNZB+qRdhhZdvekRa8UJqVASjl5w1mcYDZXj3tjZyC4pSCrtWzihhEFGaUQLtsIWQ6RRB3n/DeAXj0NGdHOHeiyweT2HN9ST4GPVG941tv63tNTxNwhIUeuJANhRrZ+zAQWY4K3gTflm0Bn0DHmbK3RC7Ad13Z8TKQXXMRFe6cT186u8iplVh4UKBtgytQZZEZCKyLkZZjEsi2AsUigG4un35hUPBs9ZdVcVnX1DFcUJd3+BSggyJEuFISYRiNouEGA9CgwLwikKwKXJvNR67VprGZsdlWfwAWaAjZI1jzenhHleC1sTx7fSEUJ+kQu+6K/FpoasAWsg3s+7hdRnFKoQRhih6+s6uvEa9MZ6hoqjeCgHSqpQ7J6bhmus/OYjNCN6SmoL++xKxsCnn3GTLa1ax4gKbbprDtKBUR9xoXqarS7XULjqn/Aib9CGmFrc1f3YHdO8NJmHNgPMIb83DRyGCEIGvuFk4xmNPW+Es3Rgrbk3CnWR5lt/iDNo8O+puqfVg6oBRisqCp1J5P3JjxHbpVpOPvmvXMQdpei7o/pw9/upjxnYEK1MbCHObooAXVuJZ4vOr7vehByhrlt++tJIvddslWAhEi1XOSI67EaNg0aDfZhM+NtfLaGvngiKHmb+iOjAPwXjdar868HEnPUe9SFWIjLqYGzEtka1y8XWXv9+pygLEY1NFuZrmxOT+lpkjTUfvgYW3JdIOBe+r/E1oG09Vrjlep/BmDvkiiTL/rMX0cRn2hHt5bVNLwFhzzVfwwMxSomIR3htNraNg4gR2lyHZkl2nBjuQH+ystJZydElxc27wrZ
 SJ9x9n1L
 Yah4Khfx5lrhRBxD5qDpFs71ws5ogK403fwcCjhtk50XMF5AVNKVxTSGrEj8jm1gAMHqXjnjxCs4YzuwhAXEw+gl7csOcol3LndzONxPQ8eMeKOkh7EqHDpyvzIMF8/IR2jMx0556241Pu/BZU0fCTP3iz5VaCE0au65YcpRGSd/Z45gepiVDqZqEKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Introduce the VM_RESERVED_THP VMA flag to mark Virtual Memory Areas (VMAs)
that have the reserved THP policy enabled.

Also, add the "rt" (reserved THP) flag indicator to the output of
/proc/<pid>/smaps to facilitate monitoring and debugging the status of
the corresponding VMAs from userspace.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 fs/proc/task_mmu.c              | 3 +++
 include/linux/mm.h              | 7 +++++++
 tools/testing/vma/include/dup.h | 1 +
 3 files changed, 11 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d32408f7cd5ed..65c4b2a61aeac 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1245,6 +1245,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 #endif
 #ifdef CONFIG_64BIT
 		[ilog2(VM_SEALED)] = "sl",
+#endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		[ilog2(VM_RESERVED_THP)] = "rt",
 #endif
 	};
 	size_t i;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbddb..278cf4bfd4ec5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -353,6 +353,7 @@ enum {
 #endif
 	DECLARE_VMA_BIT(UFFD_MINOR, 41),
 	DECLARE_VMA_BIT(SEALED, 42),
+	DECLARE_VMA_BIT(RESERVED_THP, 43),
 	/* Flags that reuse flags above. */
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
@@ -526,6 +527,12 @@ enum {
 #define VMA_DROPPABLE		EMPTY_VMA_FLAGS
 #endif
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#define VM_RESERVED_THP		INIT_VM_FLAG(RESERVED_THP)
+#else
+#define VM_RESERVED_THP		VM_NONE
+#endif
+
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
 
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index cf73bcd9bb9d5..022b7a56b6a9f 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -160,6 +160,7 @@ enum {
 #endif
 	DECLARE_VMA_BIT(UFFD_MINOR, 41),
 	DECLARE_VMA_BIT(SEALED, 42),
+	DECLARE_VMA_BIT(RESERVED_THP, 43),
 	/* Flags that reuse flags above. */
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
-- 
2.54.0


