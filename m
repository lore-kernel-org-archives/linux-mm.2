Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F21A606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MWaSISJR
Received: by kanga.kvack.org (Postfix)
	id 32C4C6B05B5; Tue, 17 Nov 2026 03:18:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303D26B05B7; Tue, 17 Nov 2026 03:18:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240CD6B05BB; Tue, 17 Nov 2026 03:18:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E48796B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:18:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 669EFA77AE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:18:56 +0000 (UTC)
X-FDA: 85443910272.23.C201FF4
Received: from mta0.migadu.com (out-251.mta0.migadu.com [91.218.175.251])
	by imf08.hostedemail.com (Postfix) with ESMTP id 75350160004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:18:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MWaSISJR;
	spf=pass (imf08.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.251 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794903534;
	b=JOSMUYlZsPXeLimVOngQAb9/7Q4XJLGz/10Cfhol1iuDbV4CiEp2IZdcbr7EPR1I8fUczh
	B6y+Rj6woxT8VmrgJ7vG4KiFVQnOXK1bbS2WNELmAzPo58MGVUYk1KrqlopCYwLxV+oXDs
	oWJN401Ff3lFSkdy2Q3IIxCrXqwWtIk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MWaSISJR;
	spf=pass (imf08.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.251 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794903534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YhtEV+fDeZTJ08RYkT+mQubrYxatIPSQ6bLyOMfEMlE=;
	b=caNSpxLVtUZaLTMwtEqWYZfuKKJVRcKix/lH7LG2gqqXdOXLl93jzJxPMs+rQpu1R/SkRj
	lIcpfMktfJ/557kQV9o3PyT5q33MWlpcfPOa3z5XyzzEDzDHMGlvGDFkr9UqnJ7BJVNnSi
	75V4i+7eudFEPaTIgCth+xZvAudHoTE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ySNz+TNmyqi6iQ6MbWzuBl/rhL5C1OnuBt5JbV4NuZU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794903533; v=1; x=1795508333;
 b=MWaSISJRh2+uyRRak7JAnxzRKaYKYA/950l4BmxmqRy/oKAV4TjRXeGWNwjE+y0UY8N7LTyc
 5+OHJ7sstWEEKzyiFiAR+glNCrqbuMhc0GGNH8CpDxBtZ8v0RNlQdGNYuozNdxpveQN6IRSq+8T
 YgyVlnEYDAbnF2/GFkLe3OS4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 50c09de987ed1a19;
	Tue, 17 Nov 2026 08:18:53 +0000
X-Mizu-Trace-ID: 50c09de987ed1a19
X-Migadu-Flow: FLOW_OUT
From: xu.xin@linux.dev
To: David Hildenbrand <david@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xu Xin <xu.xin@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH] mm/ksm: do not inherit ksm_zero_pages counter or PTE markers on fork
Date: Tue, 17 Nov 2026 16:18:21 +0800
Message-Id: <20261117081821.7211-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p7ku39giudedik85jbgsz1wac59oc7he
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 75350160004
X-HE-Tag: 1794903534-6206
X-HE-Meta: U2FsdGVkX1/Lzcy0IusjYDWdh7+5Ft2etCFLctVNpXEPEDbXyVq+hNUR9olEkuD58AHkvpMjNPdaJl/Bni/6psZ1bSXH466VJOx8OtfCoL6Biz8CtUPRcS8g+7DYJWzw4U/4IYjaqTdGYcOt7JcKet5Q/jQrX4fXkdweIo0idq/9zOq6qOsHhymG0CjiXUiyF29v28L2TRxTqJInqY399rYLCrZ/SHXhwGRLJ8tjMJ68c/18GBlHmgCWRByrPrgW+fyXPRz6/fAMCiPUMx/ePmQ2Job+qfhFciRNK98sj+Skw82NXn5Xq4SelfBJ5gKvoz/cU+o6niW0DQE9h9YfILbEf7fNNTHZdPikpkLQP0OVNdpjTdN0UX10oxaDULTvRshtH560TmQPQVpNzbzAZblmCDaBU7WtTdSUW/G62k+3Ewlf7KV22pRH0PZAn8aMv5ZMrW+9H7dFr1irJ7kvk5yckGlIkNFPQSWPilOvOkJPMlkMz3ZkzBWjeu8C0vk8iIbmkg0ArvPtir1D6rJcS686dA/bMNQaZmhNHxqLWdIVK+APbAPedBjt4vWaPtqSe7pEv1plOISYLs8sj3s4hMOwyVCv8SdS/qJ/adohTFx181So/NBm1UkHU5EyTpPMtq0lo0Gl9sBeqx4lUo7Y/o2uzwXzEJjOnOCz02YlSG4avR5ZJvzUXQjjlQCyeUm7LbQiDQAd2Hdn1Cl6ejuO202jo9zh4SnMs2ArarJEv/z31jHBTRg7rogjK3uxLt6O0bQWPIJHnWdLRUaXikd570xYrXpFz/LSaLurBDOQy+ZeI+Y98DMHjLdsCh02ux8kz+HZOn0kXTDptfpnwYXTBVKE32KecwOUTubXNqlazkPkWxA74hAPygeNnx2L8m9tmJcLjR+Bt/0ALmWDJUuOTBC0hwYs4AN0WPjTW0imvCFGgZA8Gp+IqQzqpF+SZytCSQIZMHd9XmtIJxmilFA
 v4mXFRw3
 /gew5++vJsN7658+7IUh33X8fcc/IuszNepBw8As1p1m4Hn5G/3DozqmULCGfj5o92bP2uQMesBor7uSAH2hhng+YiMz/y1EqqqMpECEb7DUuxk20hIQabNXbFp7UGaPcuxNp4Q4eROjMn9DcQneupNrKKqUb8hGhGm/im6r1oNzgJQ/u+BSLyS93AjLHtHrhWakJhE0kcwDn2ub+d2dmhrFyCsRtVoQ6TiIkKMY9d8xg0t+RDve99BFIOUGktITzxVttJsw/fU5SpiZUbRDTF/RNUtzNfkQSCpUNLspnpPfAqbXDV3q1EqwUtdOdWxNbAsAd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Xu Xin (vivo)" <xu.xin@linux.dev>

As documented in Documentation/admin-guide/mm/ksm.rst, ksm_zero_pages
accounts only for zero pages actually placed by KSM.  However, the
current implementation wrongly accounts for forked zero-page PTEs as
KSM's contribution, inflating both the child's per-mm counter and the
global ksm_zero_pages counter.

Originally, commit e2942062e01d ("ksm: count all zero pages placed by
KSM") marked KSM-placed zero-page PTEs with the dirty bit for unmap
accounting, but forgot to clear this marker during fork().  Later, to
prevent ksm_might_unmap_zero_page() from underflowing the counters on
child exit[1], commit 4d6fc29f3634 ("mm/ksm: fix incorrect KSM counter
handling in mm_struct during fork") kept the child's inherited per-mm
counter and added it to the global counter.

Instead of inflating the counters, fix the root cause by resetting the
child's mm->ksm_zero_pages to 0 in ksm_fork() and clearing the dirty
bit marker via pte_mkclean() when copying a KSM zero PTE in
__copy_present_ptes().  With the marker cleared,
ksm_might_unmap_zero_page() will not decrement the counters on child
exit, MADV_UNMERGEABLE in the child will not unnecessarily unshare
inherited zero pages, and the global counter remains untouched.

[1] https://lore.kernel.org/all/53a7bf3d-843d-4e19-b0a3-cc6852fe72c1@redhat.com/

Fixes: 4d6fc29f3634 ("mm/ksm: fix incorrect KSM counter handling in mm_struct during fork")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
---
 include/linux/ksm.h | 8 +++++---
 mm/memory.c         | 8 ++++++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/ksm.h b/include/linux/ksm.h
index 93793ca6bcc4..3c6db19d825e 100644
--- a/include/linux/ksm.h
+++ b/include/linux/ksm.h
@@ -56,11 +56,13 @@ static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
 	/* Adding mm to ksm is best effort on fork. */
 	if (mm_flags_test(MMF_VM_MERGEABLE, oldmm)) {
-		long nr_ksm_zero_pages = atomic_long_read(&mm->ksm_zero_pages);
-
+		/*
+		 * Child's inherited zero-page PTEs are unmarked on copy and
+		 * were not placed by KSM in the child, so reset its counter.
+		 */
 		mm->ksm_merging_pages = 0;
 		mm->ksm_rmap_items = 0;
-		atomic_long_add(nr_ksm_zero_pages, &ksm_zero_pages);
+		atomic_long_set(&mm->ksm_zero_pages, 0);
 		__ksm_enter(mm);
 	}
 }
diff --git a/mm/memory.c b/mm/memory.c
index cf075fcec3c5..7dce96af2a51 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1160,6 +1160,14 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
 		pte = pte_mkclean(pte);
 	pte = pte_mkold(pte);
 
+	/*
+	 * Clear the dirty-bit marker on KSM-placed zero-page PTEs in the
+	 * child so inherited mappings are not accounted against the child or
+	 * unshared by MADV_UNMERGEABLE.  Special PTEs always have nr == 1.
+	 */
+	if (is_ksm_zero_pte(pte))
+		pte = pte_mkclean(pte);
+
 	set_ptes(dst_vma->vm_mm, addr, dst_pte, pte, nr);
 }
 
-- 
2.34.1


