Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5F81CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989CB6B009F; Wed, 27 May 2026 07:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962FA6B00A0; Wed, 27 May 2026 07:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A0D6B00A1; Wed, 27 May 2026 07:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED4F6B00A0
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:08:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16C86161252
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:09 +0000 (UTC)
X-FDA: 84812925498.27.AE46433
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf04.hostedemail.com (Postfix) with ESMTP id E470640010
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:08:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=CPeVKOpq;
	spf=pass (imf04.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779880087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fr1wwam3yXWGP8K5xNNCiXv/Wq2ATv+XGc7BKR2rebs=;
	b=IotPstL3DCOqFrUKCji2Oq9kBNXH92A3WWL16sENX/rZ/KEXKcHDL2vDEVKXCtNU+uB3yD
	jx5L1Pr8AkyNC5Gren9ISSK0Cny3pn7GxnJSiEWgSSmCkFCbdGc8PuYOAHwk7KHSChv6os
	d/tbMxffq/ctM1GQvgopoEmLn2nY8Vs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779880087; a=rsa-sha256;
	cv=none;
	b=MjmWzid36CsMWSHgQ5pdldgRHl3xTsNrfMAYigvzKw5vwts/OmyLWxt/76jug+IJ0inVD9
	BdRQoqVNmA//noWKTdENk+Ax9q2/AXo5dDK+PPrnrwG0oflzj+n9StfdYRT5xsiP6h4W7h
	GcHaHxms4Hq2hP14/gpimmNHukSfkcU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=CPeVKOpq;
	spf=pass (imf04.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=fr1wwam3yXWGP8K5xNNCiXv/Wq2ATv+XGc7BKR2rebs=;
	b=CPeVKOpqx4CAIv+0r/KaD2lvQPXbCeVU1t1dn/zmUNc6wbj67qGdXOhRJx9dzIoUjTdL1wyiB
	NvTLHdG/CXjDMAJl6IngyK6ubbSoJJbGk6nHNSIH1ezZfUHuQRRvCuXjbuZ6kFvQJNLjFis6HH9
	DDHx9on4j4VZNX+dN2rduGM=
Received: from TW004-1.hihonor.com (unknown [10.77.232.85])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4gQRdh5qnGzYl1Gk;
	Wed, 27 May 2026 19:06:48 +0800 (CST)
Received: from TA003.hihonor.com (10.72.0.43) by TW004-1.hihonor.com
 (10.77.232.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:08:04 +0800
Received: from localhost.localdomain (10.144.18.117) by TA003.hihonor.com
 (10.72.0.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Wed, 27 May
 2026 19:08:03 +0800
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
Subject: [PATCH 14/15] mm: support merging of ANON_VMA_LAZY VMAs
Date: Wed, 27 May 2026 19:01:46 +0800
Message-ID: <20260527110147.17815-15-tao.wangtao@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.18.117]
X-ClientProxiedBy: TW006-1.hihonor.com (10.77.215.153) To TA003.hihonor.com
 (10.72.0.43)
X-Rspam-User: 
X-Rspamd-Queue-Id: E470640010
X-Stat-Signature: tnbn7kc7dikuh5rgiftw9pdosz3n3n8w
X-Rspamd-Server: rspam06
X-HE-Tag: 1779880086-744998
X-HE-Meta: U2FsdGVkX18O0Ay0Zvi6latT7AzrDgfDp2jdekBt58WDE91ooGq7nLzn3FQ7m1TrgSFiGO0YZkKWMOaYoNPJg774/B8Mgck5PFwCH9vuShNqg5wIwgPwDjaGc+FdnJHMwwJh2UkAANpveFLZNvpBcJ7lNIcyU3QUibnuGMdi6l9ZVxtIpeJtvd4yc1WdG6BOXCHGQEJ4qj+BPMr7ZRLolhY++cZoHL7ui9ewKYXkdISReedIjp3WjxdHOVWpUXi+fbeVWZlfPBUm6m4ogSC7Of7NjiKmrEr0vz+6pl+QfGYknv1Wq7Tj4zYbfokndvyEmBihrJ9BKvIO5D0uPWqTTyEAYTSHaB4AMrzIsFyF7QI5gQmxNE10mB1NWO5p1TKh13iaa0XZKzvgJZ0StP2JV24N+UqKD/bewQzKphUi+vEXtTlA8uG5LolU60c0g1Qqaaz7YDY8RzzI54MUa0E1Qhep7hPpArPQ1vTo2Y2TQJSaENZ974Gu+xJzK8o399jw+rPa9jN2MNTPR24jK4G62s6PxM10yG16C2ofq+AMtl+omqs2GTo/fRJAXzGmMSn0xyC+QXhdO5T6mzZHNZO9Omi4SY1wYF7grmkdaYuZ7AHmeROZChvYF26qrx6oKhEe7yIIo0HqsSH/NcSJaCDv9j5XU0U6wmwij+MmSpSHgTUrjOZINRweGcdpcP4ziVM0FeK7PrkBzEimOTHqVaHZsGTaiN0+24iZImppYLqg2AmqJZjNgnUuvuLDarV5cYcKZGyH/79ndfqGSQ/pE/X6mJBCJ1Z7Q7wbDP2Sl9gIRaJZDA1h2Fy5q4NypuH0spte8mX6/bhCG7XtndyDhpus6IEKvoIReck4Xmk2HoDqydBBQgyuhaw641PvsWkCJO0pmrhFFxOXDod2CYUmt0gJkdclcRGK3zIVzMmTknrLrhr0oN5PTrnPlHjsc/qMpcyKq5VpxJp7Go6xxjjoV5o
 VdSyN5oR
 YKaGGYl6BjzN8G9y64DESO5yZhNNiyGFpsiCC+YyXob7KhlPEG1GGqVk5qPZdUV8G2G+Kn8+UR0y1OFvCX6MrPddVpzYDzaQYjM3oPd+gETcjnCn+ABe2NoNs14pO40GzDFNJN4e8a1WFpv6gi+dr06vj+tzgJ8Jxazi4ny+jyCgpmZORzqadMcC4E9snCQVzOGh9WEuXGdCFoDgvjww7fFBrSGPa9N/mvdtKJDAc/+qpvdktIS+Yma080gq7MMssDlw9Hd34uROtTos9nnuRYmqG5A7nvza8qskUYHfZl+K4DdOvCQH6k4UUVYJuRVmKZFkjbt1eBxB+C6VFAdq/wVBSBkAcXe3PSWDy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow ANON_VMA_LAZY VMAs to merge if they share the same root or if one
side has no root.
For ANON_VMA_LAZY merges, do not delete the lazy root VMA. The lazy root
VMA may still be referenced by folio->mapping.

Signed-off-by: tao <tao.wangtao@honor.com>
---
 mm/vma.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 0a31ef82a90c..ae1047dcfbc2 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -76,9 +76,10 @@ static bool vma_is_fork_child(struct vm_area_struct *vma)
 	/*
 	 * The list_is_singular() test is to avoid merging VMA cloned from
 	 * parents. This can improve scalability caused by the anon_vma root
-	 * lock.
+	 * lock. ANON_VMA_TREE_VMA has no anon_vma_chain.
 	 */
-	return vma && vma->anon_vma && !list_is_singular(&vma->anon_vma_chain);
+	return vma && vma->anon_vma && !anon_vma_tree_is_vma(vma->anon_vma) &&
+		 !list_is_singular(&vma->anon_vma_chain);
 }
 
 static inline bool is_mergeable_vma(struct vma_merge_struct *vmg, bool merge_next)
@@ -776,6 +777,17 @@ static bool can_merge_remove_vma(struct vm_area_struct *vma)
 	return !vma->vm_ops || !vma->vm_ops->close;
 }
 
+/*
+ * The ANON_VMA_LAZY root VMA may still be referenced by folio->mapping.
+ * Keeping the root avoids allocating an extra VMA.
+ */
+#define SWAP_VMG_TARGET_IF_DELETE_ANON_VMA_LAZY_ROOT(vmg, delete_vma) do { \
+	if (anon_vma_lazy_enabled()) { \
+		if (delete_vma && vma_is_anon_vma_lazy_root(delete_vma)) \
+			swap(vmg->target, delete_vma); \
+	} \
+} while (0)
+
 /*
  * vma_merge_existing_range - Attempt to merge VMAs based on a VMA having its
  * attributes modified.
@@ -933,12 +945,15 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		vmg->end = next->vm_end;
 		vmg->pgoff = prev->vm_pgoff;
 
+		SWAP_VMG_TARGET_IF_DELETE_ANON_VMA_LAZY_ROOT(vmg, middle);
+		SWAP_VMG_TARGET_IF_DELETE_ANON_VMA_LAZY_ROOT(vmg, next);
+
 		/*
 		 * We already ensured anon_vma compatibility above, so now it's
 		 * simply a case of, if prev has no anon_vma object, which of
 		 * next or middle contains the anon_vma we must duplicate.
 		 */
-		err = dup_anon_vma(prev, next->anon_vma ? next : middle,
+		err = dup_anon_vma(vmg->target, next->anon_vma ? next : middle,
 				   &anon_dup);
 	} else if (merge_left) {
 		/*
@@ -954,8 +969,10 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 
 		if (!vmg->__remove_middle)
 			vmg->__adjust_middle_start = true;
+		else
+			SWAP_VMG_TARGET_IF_DELETE_ANON_VMA_LAZY_ROOT(vmg, middle);
 
-		err = dup_anon_vma(prev, middle, &anon_dup);
+		err = dup_anon_vma(vmg->target, middle, &anon_dup);
 	} else { /* merge_right */
 		/*
 		 *     |<------------->| OR
@@ -974,6 +991,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 		if (vmg->__remove_middle) {
 			vmg->end = next->vm_end;
 			vmg->pgoff = next->vm_pgoff - pglen;
+			SWAP_VMG_TARGET_IF_DELETE_ANON_VMA_LAZY_ROOT(vmg, middle);
 		} else {
 			/* We shrink middle and expand next. */
 			vmg->__adjust_next_start = true;
@@ -982,7 +1000,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 			vmg->pgoff = middle->vm_pgoff;
 		}
 
-		err = dup_anon_vma(next, middle, &anon_dup);
+		err = dup_anon_vma(vmg->target, middle, &anon_dup);
 	}
 
 	if (err || commit_merge(vmg))
@@ -1212,6 +1230,7 @@ int vma_expand(struct vma_merge_struct *vmg)
 
 		vma_start_write(next);
 		vmg->__remove_next = true;
+		SWAP_VMG_TARGET_IF_DELETE_ANON_VMA_LAZY_ROOT(vmg, next);
 
 		next_sticky = vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
 		vma_flags_set_mask(&sticky_flags, next_sticky);
-- 
2.17.1


