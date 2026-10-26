Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4CE606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UNbUEG/S
Received: by kanga.kvack.org (Postfix)
	id 632BA6B05B1; Mon, 26 Oct 2026 19:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A186B05D7; Mon, 26 Oct 2026 19:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9776B05F5; Mon, 26 Oct 2026 19:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BF4F6B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:29:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A4D71C429B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:29:12 +0000 (UTC)
X-FDA: 85366370544.29.CE07AA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B77C4180003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:29:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UNbUEG/S";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057350;
	b=zRNsf2RiIFPOV+vxn/N9XzGFVjamlSl273SvpJdBwNUBgVsh+fruFCJ9Pmw5zxK/4TxO2L
	PHV+eGq1LKaJizpK2PwxhPd3bEYi5DkDtaTQ97/FL0uptWbqNUzWA8pN4B1lGbwP5YnLTA
	XrIJWUL61aAEZe0Hxbi8ElAyyHLf7to=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UNbUEG/S";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OoFHaYBhm5BDHRt4hk2dDlai0Lu5WpyAocva34cAfYA=;
	b=jBdZ20HBT3lfXQu1Mz1yZGtRGsdJmK4qQNmcoaD7b3ub4lOAXDGst+gRHoUSiBBqTUJqx4
	dW93bgyoEun3nqHsQwK9BKX4gHae2vb9Xl7Awv7qutxL8twE2/y7V9Kc/FKL9ieR91u2K+
	V0OdB35mL+RP9u1ZmGNugLe8bnSJ/WA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09B454146D;
	Mon, 26 Oct 2026 23:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0091F01825;
	Mon, 26 Oct 2026 23:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057349;
	bh=OoFHaYBhm5BDHRt4hk2dDlai0Lu5WpyAocva34cAfYA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UNbUEG/SujRxvLabLs1Ob9p21oBhi+rGXvfUKjqMDQc12IUiZnwmTDApSDiN/doHK
	 Htp9Ipsw+SQp+pFzIORI8kLx2XLdu4rOahJ0TPlelHfX1GJ1qLDkN8+N+aWCn8WCds
	 tZKLfzo3kEI2Ic5a7yAs64WNXkp0GQ9463s7JB2V/ciJHVqOo5idW1iS2SKYE4l3o+
	 mmQ3vIfL+tDLHRHgEyxeKpggddER2NA819TKZnVHtRhi+Sq3NPEIiR5ET0FwgZX6ei
	 fEZXbzJhICbnx1enS+A8NU5WTSrME8TXg/tsHJn7ecpC43Su1OH1tQwLJM8cp/lhBz
	 YEOm5b5Nlxakg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:56 +0100
Subject: [PATCH 36/46] mm: fix unkillable fault loop on MAP_DROPPABLE
 memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-36-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1689; i=david@kernel.org;
 h=from:subject:message-id; bh=pzxM/cFKO4VXQWnP1gi4l+XWqAOEVbNka7bwCiIYBW0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu358ufnWFRtyuxz0v7f0W/Xstsp+rpij0whZOtoAdj
 O+fvJVI6ShlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAipR2MDJPYqpQSJzxd+VjV
 Sur4qftq4hcCTkXs/XHuWWzbsvvV/zwZGT7UT1FdZiUx0a1TNyc2/fYVjS1HumMsfZ2tf/o2Fkz
 IZgcA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: asj6iw7ay1yyif6mcx76uqit4eckr5am
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B77C4180003
X-Rspam-User: 
X-HE-Tag: 1793057350-557894
X-HE-Meta: U2FsdGVkX18gA6FfysvSgpLe6Qvni9JrRfaG+I8vzF3k8sniyhDL3c3SAz3sO92/D2a+egREHPzdvjoxKFuksT1oKHTqErqhdN2RsuniBNGiOyM5wBF/wKLKAEBmEhKK3ySuyX+TN+mWI5cBaBqTQRzY6Iu+3O4hXQC2XGbsOBIBdlCK53/QkzwsFUrcWljfDOgs6SQ640Z+IiHFMVN6Ra9IUmP8TBttNTcWJRmAi/MDe8TzYdRwGrqX3QFjo2G+OV9paxhEppMmDhyyvJScgoOyf4/1m0kNek/iTMCjkiE1k8K8S2yZzWqWBGxn9nOUXPABh/EQ79BOrPXN1KFNZmXrNhYsBNTX29vMWde4N7VpDtVGSwZ72WcNtoRJkjNh8mTmTkknn1MVGYWMJ3XRyu+6F5pWf17U7kt0BL4aPAvQs/UmAiD2a8huCyTKG3FS2Y6WbJOew8z6B2BVGtFqCKIHY75pyGWG285KpFXYFzp3wf86QQWHEgwZppKKnMB5SfBhzk24igefMxnOy0uQXhMuE/dsXC3wS5xSpc0biiw5rgY5q8hDSzULLPdwAdOs6vzG6b4sn7DMefYhGZZMiv8gp7kxr0PHSRbt67dxbdPVBbk27yXxqZ8KEPjFV/+C3LGJFqwSUNCyfxS6vBFcM5KBKviOGoUWrMG3nz9/mxlN6G+L5bzXf83rBP0e0vEGv2rSTYmfQqmSoaWsuxKzkEf9lxizG602hQ/OriiNJX135hgbcfrkp0te5+o8OzasqhO+NYe7EiIsYVDwPeHauKRJabDk23Dpc75+hI1fVv8HtqZVtyy8pThUWWQN10PlcTbIP7NIBMU7A1W4gHLjN7eoIcOA6RwsnjkvapmYkAMmp5DvLGz43q8H+OOpF3YBpTuaoiJC7B2AWRzMPQKCyhQ0azlCydeNbx22zczKdqdcSwc0rqfD8KD+kEsw82+aDOq3T6kdnqduMxChOKR
 +DmW4ilT
 BzQoRJXJQurFLEEupTvzJyO2kowJ4io+utFQ1P447qpvGVOtlBu384yILJgKHdA7cKT38xgoOLRYMLdF55dblFwON1OrJ39SIhDAmI+0iSAFxzRp6dvV/iZ9lplfwea7FyCdEu9x6R2Z3ybfZ08JOyexNunbuWDYOx0PWBCBXhXEKRB6Naj/LpCr97dIGs0Ee7I+jIFDTWXIG7v4KXKrI+/qyYR7zLR8ajX3Z8pIiC7xzJzECal6CH5phmpNqniMS741GnGS+cAivxpvohuR7/lY/6SYW0hbMpyVzM/NDZr+MaBY1kFBUVcLEr06yTKMQ14LlpJJlgALNLpEHZWiK3M7Boa3HF8cVR9/0quHiNM9HAUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

handle_mm_fault() suppresses VM_FAULT_OOM for VM_DROPPABLE mappings.

For user-mode faults, pending signals are processed before retrying the
access. Kernel-mode faults on user buffers instead return directly to
the faulting instruction.

With persistent allocation failures (esp. memcg limits), a syscall,
such as write(), can therefore loop while not dropping locks.

Only suppress VM_FAULT_OOM when FAULT_FLAG_USER is set, allowing
kernel-mode faults and GUP to fail and signal allocation errors.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ david: simplify description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 5c5f326b8bcbe..230a2f4dafa13 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6957,8 +6957,12 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 
 	lru_gen_exit_fault();
 
-	/* If the mapping is droppable, then errors due to OOM aren't fatal. */
-	if (is_droppable)
+	/*
+	 * If the mapping is droppable, then errors due to OOM aren't fatal: the
+	 * task returns to user mode, handles its signals and tries again. A
+	 * fault from kernel mode has no such return, so it must see the error.
+	 */
+	if (is_droppable && (flags & FAULT_FLAG_USER))
 		ret &= ~VM_FAULT_OOM;
 
 	if (flags & FAULT_FLAG_USER) {

-- 
2.43.0


