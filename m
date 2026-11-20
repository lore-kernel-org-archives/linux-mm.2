Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75BE6606B986
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c0FGgiB/
Received: by kanga.kvack.org (Postfix)
	id B0EF46B05EF; Fri, 20 Nov 2026 13:11:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98076B05F0; Fri, 20 Nov 2026 13:11:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913006B05F1; Fri, 20 Nov 2026 13:11:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 548356B05EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:10 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C544F140129
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:09 +0000 (UTC)
X-FDA: 85456289058.12.600D1B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A1CB1140002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c0FGgiB/";
	spf=pass (imf26.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198267;
	b=yQDiI58oNHws9cS+k18kvua08GUxvaARLA9esrwFvamcvYXbA+B+2NhM6yGg2Xy6esaNlU
	SDW5RAY+orq6A3RtvWDNIJsirNT5oVRQh9runteMSccmt+ipMGZFVX5DpPOSjVTgewOytu
	efm16wkRhSxxi5v2MUJ7ZF2U6H2vV2k=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198267;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDxj2h8LUz/yKelW0hpXFzxdAGDfTr2wWvPbhGHboyw=;
	b=T3PsnLCVLf53xRfk6xPOriKiPTumdt4ecy1oytmiVOZ85K38Tds7YRJVzG4/mYDlrikzWr
	nDZQpFqkK/+PJ72kWJS5rHAk0Fa+E2V+lrFRucLz37OWoVI4CSpEyr4g2xc6otb/kD7x1y
	BYqkziZMNo5KPxq7qavM0LJwVx8DY9o=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c0FGgiB/";
	spf=pass (imf26.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EF95633EB;
	Fri, 20 Nov 2026 18:11:07 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198266;
	b=syUHM/gw4WX9K/HdvrdkKiMNbVoXsE8AjidBbq5sPKHmgT9Z5ldOQN5OL4jCXNU4td7A
	 S4bIfkraeVl5V6PgR3fQR0wSM9bf0Fd8+tf0jwFW7aSIZkKjvqTgaIfZqjJiqUqHoVLsn
	 Yq2yBMHhS116uZkXMjSDuGbdQG/3vJQQa2vrWjE9FKav0vvUuR27owTbA4grVKPCLv00a
	 n9t7xRzB8VrYvGnWp6iox49NHvk2ORyKMVNJBInaUpW9Qw9h8NuA+o0KlWrqPo09RjPLr
	 rSOonf2SLyANA/3nZ7BCK7vUAoljKERX9qNZNAblfUbfz9vM0ot1FwkNe3iqMUCMy8w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198266;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=SDxj2h8LUz/yKelW0hpXFzxdAGDfTr2wWvPbhGHboyw=;
	b=P8+05ni1+P5XWXXUcvC1ApVJBcgCyr2bc1DaxHmObBIWgKwSQCfySyQE5jiWtQocaTHY
	 Iv/s0XGZHiJoKiPYI0KWiJPk0fQhJinsCzVvNLVkm2++1Hzi5kbSWZXFkJ4KPREjMvb7+
	 CY4aB1mudEMiekjH2p0KIcFM5McKRBYFNGiKZ7AzznSjGSGJnxK3NrOD3eAomze+Qqt3Z
	 kCMQD4D1zZmIfF+xnuYLvrQQx1l41v0RxYAlWuzY+pMq+L7SI6+aRMKzU/SBdmGjbVSqw
	 iFz2QWoqZFV1ExbXmoqrSHBcwfHx5NLUB/sK8k5cDUYbHZd2qSk92NZNutrMMxHun+w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 369A11F000D1;
	Fri, 20 Nov 2026 18:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198266;
	bh=SDxj2h8LUz/yKelW0hpXFzxdAGDfTr2wWvPbhGHboyw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=c0FGgiB/SPaUzE5qCN+HLvvIIaUBRZpHwoTSH3IX4F/Z1i2NJ+ao2vrTGfNN4/91j
	 dYxcyzGRDp3Hq1l40A50pV79R2yz9iygjKT01QtokhVTnJ6k3FUI1/anCNNKzxX8y7
	 NCsMr8/FVrW4V8PqFyt1RcmUKTvqE5lPI5se94K9PPW5NkAYO2x1pVZUFKqserUKmo
	 piysnjAaS9+iO553kc6PseyImmdj0alhuD7ScuRfaBxfbUsCAWrVXjynVKfeiVBUEZ
	 TJ1sou7qEgVx02KzwFdvwfChySWbmbMMNvhRnjQAQ72Y1u9ShuV+b+xm01HQKNICb1
	 auxGmLnJsZdbw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1E32C4B969;
	Fri, 20 Nov 2026 18:09:22 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:33 -0500
Subject: [PATCH 42/60] mm: fail private placement on exhaustion instead of
 OOM killing
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-42-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=3361;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=TbRq76F0ctxLdrc4ZvqTJEioaj0puOvUL1bbmmWV60Y=;
 b=4TuCqLi3E6og3lhWPEnbx57vqhH0UZ+xHpnIJwJApHy8FsrwbpMCJEhWBmQF1kacYofzGuQUk
 MJg+9HMhsJnCGqIcMdsQtmg/Q+w3B05gKy4AO+RBfvyb9bK7v/Vtefk
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Queue-Id: A1CB1140002
X-Stat-Signature: b488ssabmahwwx8dj96iqq1ju1pexqsm
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795198267-373391
X-HE-Meta: U2FsdGVkX19JtCTvsfA7pKUPzW6aBic3CqHmohAyaLl2pSCl6i8WWCEI8pdX+u4GIGXdNye8paT3gCIU9EJyUdQT2nSMR+DywV0h9YQp32a7g+SOjCVPOQoEkQ9DcPZIqg4fj2CrAjZxrac6JMmgs84ELzuroFqdOv0nW8ySQ637xgJxm0R8mzGpR2CU9r89B3rAa/KF2o5eMEMQAuEQ1lLTfNkteV58fnE5FMfugLImulm1GkaxdcRM4WIhPXkSUP5Qdl4/T3KfoLmkWP97llDpLKRYsltPBiMCcEmDk+2erbc1FFOFgQSgp9gGirxU1nZreNF4DkRV2FLQ5CtqvB73UoYfIPpKARsQ8mwnKh5aucEKyOljdE6QL1X0FAwqWySkcTu2yIsCUv5RzRu22JV48mS9S/GfQlOulPgnF08pL4AX+N1dDHutRd/mhSeD3B6WxIHGpQXkCbcj2w/a4m5ezf9F72XcAWyyVRPoOqEyVOeEUIDx7dIL3TnP4567LhSEoPJnNSDBl76sMbuLYnHSY7j6SR/K6rE+1uPsXKJ2XDfzgYxnRq26qdP2IfsQylTTG+leuSuq4+t30MinAuL3LpysN9BXIPS238bnxpk2sg9sfVfYYc+jDTY6xRxevnL4Tcicy3j9j2zCM6RmaeLNJhDmO5OCYJFphh0/rE+I9eRE5gon9ohVLPaEUqX/W9YkBLAV0ovoBTY6zA+s+iOoLQvUWZpAsAp4Rxc1c/Z5D3AemgXHGIIMGTqVj4lXsc7VoD4uyX6cfAegkORt9TUv4ghIMT2n6x4tlhcboqyb76Ej7vWulkW+ZWJSRQgBX9l8vlMnySzwbhbTor/7vesXiub3rz9iywZZuDS/OfzVxsFvvA+kmIOcLdkZ2RcgziMMq763lKT+7S2A5YmIJOBv5zZ8yZuXsJNl+u/aFpvlB9mb0aLYCcV/0YultwP4Oy7sPMMcnkUdVc5FFc1
 KYaHMG4x
 lpcVcFpC3zyJy7cBsTXV+5KLw38IOoA1MZy+AUK4vFUAVl/6s3c7pwZB5MQLdV504WmxwsvEb912i63gDi1sU4F2nWxh3pjJC0NKp5NYIe3NlHZQm6+texIUpv3DpQwcGrRb9a32Uvb8uMclPSkSKzsrjTKKnr+vs2YIQKyO6Clzfjx+lqNHvRyEKIXn2VG/w4N2UIuLZ1nGXMX+NrcNbaoX+qqQNqBu1t0WcMbBF6Bh7pWGE7W3yZywxlj7xe9JmQO8ESf1U222yNdmonmdYx0Kw2qc70bHPghbFVlqRLdo1Z/92ncPAykUQXcJg0z8tu+sAZi7zITKLHWPbmpGlFlgpKvf+pdTHxjRpqll62M+LZ7i1JSD3zKcO0XvNDzr4Ehg81yKwplMtnPUkGrSRd0l7ghoswzCnLKX41ZaeMnXmIKp3IjhWe4kbX96MsuOqd8kWqshSpm8J3MdqQOBDNvbwCSRu3Vq+C22gmVBu4EIZSDIRGX3KKYFhleWDU6phiWQRI3f+3c0blp8tHDSHyeMlmQ9rpxApeafqC//bBA6Xf6esMM3X7SkWLKlQjXvDv7CyTF1zE5S1hLbSzzY/OwzheTuIlksW3dFBVl3ffVqWkGJEZdXgE5rfQVAZKHRPXch1Xk6x17tmx7xGBK/NYT0czWJakhG0d0TQD3de1f36FiKXXHIgtExaeu4c74vlFxi9YGckpyszjdyDPpuXF/PsNoPM7ujsTH6zRfPdQ87jchza12YJKbtFTJEYvZG4hJrIsPeeC5f4vaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Private memory belongs to a device or specialized service and is a fixed
pool, like the HugeTLB pool. The OOM killer has no good answer for it:
the task that faults the last page may not be the one that filled the
node, a remote accessor or another mapper of a shared object would be
blamed, and killing a task does not free shared private pages.

When reclaim cannot satisfy an allocation from a private zonelist, fail
it instead of OOMing.
  - __alloc_pages_may_oom() does not select a victim for a private
    request, and marks the task.
  - handle_mm_fault() turns VM_FAULT_OOM from such a failure into
    VM_FAULT_SIGBUS. GUP and remote access see -EFAULT, and other
    callers see the allocation failure, e.g. -ENOMEM from write(2).

A request that became ineligible since the last retry check is not
exhausted. Report progress so the slowpath retries and relaxes it.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/sched.h |  2 ++
 mm/memory.c           |  5 +++++
 mm/page_alloc.c       | 14 ++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e4f6323d7855..8a2e37475e5d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1038,6 +1038,8 @@ struct task_struct {
 	/* whether the LRU algorithm may apply to this access */
 	unsigned			in_lru_fault:1;
 #endif
+	/* A private memory allocation failed; a fault reports SIGBUS. */
+	unsigned			private_alloc_failed:1;
 #ifdef CONFIG_COMPAT_BRK
 	unsigned			brk_randomized:1;
 #endif
diff --git a/mm/memory.c b/mm/memory.c
index 282266dd5e5d..4a8a08df28ff 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7003,6 +7003,7 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 	}
 
 	is_droppable = !!(vma->vm_flags & VM_DROPPABLE);
+	current->private_alloc_failed = 0;
 
 	/*
 	 * Enable the memcg OOM handling for faults triggered in user
@@ -7034,6 +7035,10 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 	if (is_droppable && (flags & FAULT_FLAG_USER))
 		ret &= ~VM_FAULT_OOM;
 
+	/* Exhausted private memory fails like an empty HugeTLB pool. */
+	if (unlikely(current->private_alloc_failed) && (ret & VM_FAULT_OOM))
+		ret = (ret & ~VM_FAULT_OOM) | VM_FAULT_SIGBUS;
+
 	if (flags & FAULT_FLAG_USER) {
 		mem_cgroup_exit_user_fault();
 		/*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 63cc8729c41a..ea48991ef589 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4176,6 +4176,20 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	 * failures more gracefully we should just bail out here.
 	 */
 
+	/*
+	 * Private memory is a fixed pool, exhausting it fails the allocation
+	 * rather than selecting an OOM victim. Otherwise, if there is some
+	 * indication of progress because of a revoked request, just report
+	 * some progress so the slowpath retries and relaxes it.
+	 */
+	if (ac->alloc_flags & ALLOC_ZONELIST_PRIVATE) {
+		if (!alloc_private_reachable(gfp_mask, ac))
+			*did_some_progress = 1;
+		else
+			current->private_alloc_failed = 1;
+		goto out;
+	}
+
 	/* Exhausted what can be done so it's blame time */
 	if (out_of_memory(&oc) ||
 	    WARN_ON_ONCE_GFP(gfp_mask & __GFP_NOFAIL, gfp_mask)) {

-- 
2.56.1



