Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0C19CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5441D6B0093; Wed, 27 May 2026 07:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51B6A6B0095; Wed, 27 May 2026 07:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431866B0096; Wed, 27 May 2026 07:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34F1C6B0093
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F360F8FD79
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:04 +0000 (UTC)
X-FDA: 84812925288.25.1144515
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id D97DC180006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf24.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2r62RTd5HXd6Ue6ywelaox786yyb9mDIcDi1lgCG748=;
	b=ptRLm4kGF9lIFekjppwAoeRELPzpR5OlYu7MBz+wDLztKdaFwrvo1X1rpobxhCRGvnXXXy
	sX//mjTtcEFF7OLEv8QI4+K1BCF3JQd8udge/vxBrBY8oXTWVL4qRA9HDrt4AW/2tIRcKU
	huRTG3M/aLbIEv5QWsY/tnc6jGPGODw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf24.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880083; a=rsa-sha256;
	cv=none;
	b=feZqNErsoJYV2q9Zf7tOWFEXO50F+CZ4g84w7WRQJrVhV03caWF3vVaCTPbSELRZbeLc8k
	yFYf7v0So/PNZwAlVuCtvi3ZrzQh9brOufliRkK15sLMJ6Cdb083Ur6pRmr0TRbcWx7mEM
	2VRnygQQQHz/iWBSJ21gSwGYGx8PWno=
Received: from TW001.hihonor.com (unknown [10.77.229.151])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gQRdN5KTvzYl4n8;
	Wed, 27 May 2026 19:06:32 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW001.hihonor.com
 (10.77.229.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:59 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:07:58 +0800
From: tao <tao.wangtao@honor.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<willy@infradead.org>, <sj@kernel.org>, <kees@kernel.org>,
	<luizcap@redhat.com>, <zhangjiao2@cmss.chinamobile.com>,
	<tao.wangtao@honor.com>, <kas@kernel.org>, <ljs@kernel.org>
CC: <hpa@zytor.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <jack@suse.cz>,
	<riel@surriel.com>, <harry@kernel.org>, <jannh@google.com>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <nao.horiguchi@gmail.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <pfalcato@suse.de>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<damon@lists.linux.dev>, <shakeel.butt@linux.dev>, <ryncsn@gmail.com>,
	<21cnbao@gmail.com>, <jparsana@google.com>, <dvander@google.com>,
	<zhangji1@honor.com>, <wangzicheng@honor.com>
Subject: [PATCH 06/15] mm: add CONFIG_VMA_REF and VMA helpers
Date: Wed, 27 May 2026 19:01:38 +0800
Message-ID: <20260527110147.17815-7-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Stat-Signature: amixsgursw1nnc8pejw7rbh5wg3tu7u8
X-Rspamd-Queue-Id: D97DC180006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779880082-629650
X-HE-Meta: U2FsdGVkX1+ooPZ+fO5XmNo74j+mRv1KWxAukKJ9LP/dtOfEuGXwh388gwcKeCsmJQ50vpDleKCPmCH4UVdnnIirp9HUv+bC8jzz6ck0XlOzxxBi2heNj+tykqRG5m2vB0QuVRhmqMtfq6oNh8I08pT7iv5rEd5m9PNlubalp/vSCSROXGimhl44dwGCaH3bUf3CjNit3yHkA+SPb7nepgJTcyhEe9jdwsv1rGtTuNAaSpkwZ31g+iobgFhYPqYze8kwqfkZfv5ghKeE/GgAHwa5a81Pd3H94OboXOXxWPjkHVPJRPp6/BZYMNPY/C0t8QtUlLyHhAE2GsxONg1dEA1k9NVOmn0aralZMtmLpWIiJ6jh6WE9VUmYprDl7rBxNxrMgCcHXHjTihcI3aRvjLRhf0v0QCo3w+59e+wz76ENiYCIe05ifgLzkRK6jXgmAW0lj11y9J6+8WCiBj5+NBXKTCOtJ3QQKhukdYPwWLo9u82wwAQfDMnhTJObc5fw9f4ANlCF8biEyiRxamFNaC0vq1wNJ/okI4oDNpGbz0pspaStjAmTNV651Qi6xiEmhkgbMYlnRnhEEFeP3WQt23BCxus6m9GtZxESPVmEBLCXgQ9jk1uBlPevn/n8dcvQwqvEThVz/K2ZoHGuApTvaRek9LufLWrvA/9cvenMMY3J+4IH20LoZQcLWoJAHOVtoNJdwDMb1aWCyKU8XH9/4u4pMaTV1713+rNF/LnRbEDr0FGzbR0WAUSwjA0J2/mnwQWSEGVKdZKxFQZzrwIGFaJi2gz8aECfHE0cdO0tHRJ7nvlwd44go99lN7ddWoUd2hQnkT55B4slu6PaJP7zT5z4/sVHkOQOIDhLQpHJ93FZgXZ+IF06m/8XjcGemWZz65OUOIbQ9UnaRaj2hn3TicEuILuYIurcaxCcWClzx7mgTd6oiELF109ng/pXxH7p6x6O0ZXdP7OI16A0uXQ
 Ih+T6jyk
 Da6ZcZoxxTDJERPxwdjiAWx/FV/TR86ZlilIBgYxOHW30WvuaKJ5fAq6UVHEi8rKF4jOIGSd5nforaLL/d0/N2yZK3VwEHKYIatrwtCTwXKk8aGisrsImwKDqBa9Y5d1yDSujk4m4mhM8lvtLQZaG7akGBi02LRRkO76PWvu6PzkoV7K/XUr2AjhbRljY5MCTPJ+0Ht9/6KDeTxjucwjljgLL8Egfk5OspfOFjYZyaitop02pv+NkMLH8t7YX7POfe+fcQwRCo6ybQfjWR666TbbWE6kLwdcn9NxXZzJLCFPoSi4eV64F96bBXm4WNoxJmmZ+fUiehDdp0I/y5rEBjaYAkUpFIl6KzMSQSkkU/NhaDUw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

rcuref only manages the lifetime of a VMA and does not track its state.
Prepare for the upcoming ANON_VMA_LAZY support.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 include/linux/mm.h       | 38 ++++++++++++++++++++++++++++++++++++++
 include/linux/mm_types.h |  4 ++++
 mm/Kconfig               |  8 ++++++++
 mm/debug_vm_pgtable.c    |  2 +-
 mm/mmap.c                |  4 ++--
 mm/vma.c                 | 12 ++++++------
 mm/vma_exec.c            |  2 +-
 mm/vma_init.c            |  1 +
 8 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index af23453e9dbd..e98bdb414e43 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -918,6 +918,43 @@ static inline void assert_fault_locked(const struct vm_fault *vmf)
 }
 #endif /* CONFIG_PER_VMA_LOCK */
 
+#ifdef CONFIG_VMA_REF
+static inline void vma_rcuref_init(struct vm_area_struct *vma)
+{
+	rcuref_init(&vma->vm_rcuref, 1);
+}
+
+static inline struct vm_area_struct *vma_get(struct vm_area_struct *vma)
+{
+	if (rcuref_get(&vma->vm_rcuref))
+		return vma;
+	return NULL;
+}
+
+static inline bool vma_put(struct vm_area_struct *vma)
+{
+	bool release = rcuref_put(&vma->vm_rcuref);
+
+	if (unlikely(release))
+		vm_area_free(vma);
+	return release;
+}
+#else
+static inline void vma_rcuref_init(struct vm_area_struct *vma) {}
+
+static inline struct vm_area_struct *vma_get(struct vm_area_struct *vma)
+{
+	VM_WARN_ON_ONCE(true); /* not allowed */
+	return NULL;
+}
+
+static inline bool vma_put(struct vm_area_struct *vma)
+{
+	vm_area_free(vma);
+	return true;
+}
+#endif /* CONFIG_VMA_REF */
+
 static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
 {
 	return test_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
@@ -957,6 +994,7 @@ static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
 	vma->vm_ops = &vma_dummy_vm_ops;
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 	vma_lock_init(vma, false);
+	vma_rcuref_init(vma);
 }
 
 /* Use when VMA is not part of the VMA tree and needs no locking */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index e7f5debac98e..a2bf17a42b55 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -6,6 +6,7 @@
 
 #include <linux/auxvec.h>
 #include <linux/kref.h>
+#include <linux/rcuref.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/rbtree.h>
@@ -978,6 +979,9 @@ struct vm_area_struct {
 	 * slowpath.
 	 */
 	unsigned int vm_lock_seq;
+#endif
+#ifdef CONFIG_ANON_VMA_LAZY
+	rcuref_t vm_rcuref; /* Ensures the VMA stays valid. */
 #endif
 	/*
 	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
diff --git a/mm/Kconfig b/mm/Kconfig
index c16b5d9b3ce9..c039ce583924 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1419,13 +1419,21 @@ config ANON_VMA_LAZY
 	bool "Lazy allocation of anon_vma"
 	def_bool y
 	depends on ARCH_SUPPORTS_ANON_VMA_LAZY && MMU
+	select VMA_REF
 	help
 	  For anonymous VMAs without children, avoid allocating anon_vma
 	  and anon_vma_chain to reduce memory overhead.
 
+	  ANON_VMA_LAZY records the VMA in folio->mapping, while VMA_REF
+	  ensures that the recorded VMA remains valid.
+
 	  Say Y to enable this optimization for anonymous VMAs without
 	  children.
 
+config VMA_REF
+	def_bool n
+	depends on MMU
+
 config IOMMU_MM_DATA
 	bool
 
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 23dc3ee09561..cab8a4e71243 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -1036,7 +1036,7 @@ static void __init destroy_args(struct pgtable_debug_args *args)
 
 	/* Free vma and mm struct */
 	if (args->vma)
-		vm_area_free(args->vma);
+		vma_put(args->vma);
 
 	if (args->mm)
 		mmput(args->mm);
diff --git a/mm/mmap.c b/mm/mmap.c
index 2ae733eb39f0..ccedebc87cd5 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1481,7 +1481,7 @@ static struct vm_area_struct *__install_special_mapping(
 	return vma;
 
 out:
-	vm_area_free(vma);
+	vma_put(vma);
 	return ERR_PTR(ret);
 }
 
@@ -1922,7 +1922,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 fail_nomem_anon_vma_fork:
 	mpol_put(vma_policy(tmp));
 fail_nomem_policy:
-	vm_area_free(tmp);
+	vma_put(tmp);
 fail_nomem:
 	retval = -ENOMEM;
 	vm_unacct_memory(charge);
diff --git a/mm/vma.c b/mm/vma.c
index 3501617085b0..ed15968a5891 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -392,7 +392,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 		mpol_put(vma_policy(vp->remove));
 		if (!vp->remove2)
 			WARN_ON_ONCE(vp->vma->vm_end < vp->remove->vm_end);
-		vm_area_free(vp->remove);
+		vma_put(vp->remove);
 
 		/*
 		 * In mprotect's case 6 (see comments on vma_merge),
@@ -470,7 +470,7 @@ void remove_vma(struct vm_area_struct *vma)
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	mpol_put(vma_policy(vma));
-	vm_area_free(vma);
+	vma_put(vma);
 }
 
 /*
@@ -582,7 +582,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 out_free_vmi:
 	vma_iter_free(vmi);
 out_free_vma:
-	vm_area_free(new);
+	vma_put(new);
 	return err;
 }
 
@@ -1950,7 +1950,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 out_free_mempol:
 	mpol_put(vma_policy(new_vma));
 out_free_vma:
-	vm_area_free(new_vma);
+	vma_put(new_vma);
 out:
 	return NULL;
 }
@@ -2596,7 +2596,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 free_iter_vma:
 	vma_iter_free(vmi);
 free_vma:
-	vm_area_free(vma);
+	vma_put(vma);
 	return error;
 }
 
@@ -2946,7 +2946,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	return 0;
 
 mas_store_fail:
-	vm_area_free(vma);
+	vma_put(vma);
 unacct_fail:
 	vm_unacct_memory(len >> PAGE_SHIFT);
 	return -ENOMEM;
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index 5cee8b7efa0f..e7f388010488 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -160,6 +160,6 @@ int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 	mmap_write_unlock(mm);
 err_free:
 	*vmap = NULL;
-	vm_area_free(vma);
+	vma_put(vma);
 	return err;
 }
diff --git a/mm/vma_init.c b/mm/vma_init.c
index 3c0b65950510..1300d813d61b 100644
--- a/mm/vma_init.c
+++ b/mm/vma_init.c
@@ -137,6 +137,7 @@ struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig)
 	INIT_LIST_HEAD(&new->anon_vma_chain);
 	vma_numab_state_init(new);
 	dup_anon_vma_name(orig, new);
+	vma_rcuref_init(new);
 
 	return new;
 }
-- 
2.17.1


