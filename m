Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF80606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VOZXMwFI
Received: by kanga.kvack.org (Postfix)
	id D2A7E6B05C7; Thu,  5 Nov 2026 16:35:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D017D6B05C8; Thu,  5 Nov 2026 16:35:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19436B05C9; Thu,  5 Nov 2026 16:35:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90B336B05C7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:35:01 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 197F2140BFC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:35:01 +0000 (UTC)
X-FDA: 85402370802.18.2D0D4C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 46FB91C0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:34:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VOZXMwFI;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914499;
	b=8IVXQ3jVSXztcn1wv8GmeC9KVGQnlmBb5puxYJTO7S9idqKGyyeSG8bUb+PhJrl+X3H83Z
	048UDyxh+oZkJP7dUr6t/B3nxnUvRN7PolYVd5hUE1/JfiTrP8vthB3SuLhDgTft50kHET
	DW3jNGVJeInfq5i2pSEPsdtuw2MN1d8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VOZXMwFI;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqj13y74wygWSmayTPQ4iPMQc3qMQDiKbXhB7QOG+mA=;
	b=n2ojDYw3Uu2x7uel0gxwMuHxJRlX0nn9qxwe++7RwpouGtCqRIKgAAOvLqNUkk7rlw1jTi
	vzWs+6XN1zinPTmthu1USnUWE4DIGnOLXSYPwXqmJk/ABVeKgk7zODE34gUo7OJ9jPwiDO
	q33Q9OH6+ZQ+dO6jHlH7pdNXlwmEmNA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7099F41187;
	Thu,  5 Nov 2026 21:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9141F008A1;
	Thu,  5 Nov 2026 21:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914498;
	bh=qqj13y74wygWSmayTPQ4iPMQc3qMQDiKbXhB7QOG+mA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VOZXMwFIw55C/gyPpTFMi958v5mx5VT01snh2SA64awr2LbAScNTljXqXSrQYbiaj
	 RV7VVW31Dx8nplzx5bLpirryInTRUpJmwDuUPaNOi6NwGChrxsBejRvOPhE5vzrmJ2
	 ibB0WxGC99Icwc9mBMBIppQkz1ran+hYIvyuZ4PTP3ux4GpCm65RxCnOqccO9/vgpG
	 eRfxWbVn1No9ze31mWcWL6lZD7fySHk5wdGW1jeOrPye/O/Pj3QoJ1UW5d9HjYbgmj
	 2HgBTfIoWS+TgTiWFCZVz1fU08DAIAnlltZ+zA7aS+qglKIsghb0mEocg3yKJD+pla
	 d9oPt5DuR8UWw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:31:02 +0000
Subject: [PATCH 11/13] uprobes: convert VMA flag tests to use vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-late-2026-vma-flags-v1-11-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
In-Reply-To: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
 David Rientjes <rientjes@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, damon@lists.linux.dev, 
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1835; i=ljs@kernel.org;
 h=from:subject:message-id; bh=sx5WtkIScURFA/l2IshQG5M9gB0ax8rL7dz98vBV9Zo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLefF3eVuN07XEeXyib4EmPkM7Sa2Z/rntYCu7v4hb7V
 5x45sWBjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExE7hwjw6WJvcWcrAdvuDPP
 e6O7Imh6UszvHqsA8T/ftk6Jmpx715nhn+Em9YjI13G6KxckMRb13g42Wvfv2zy17kdn4jfarqq
 RZQMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 46FB91C0006
X-Stat-Signature: 9oi4bu7cpp6kocsz5cbpf4xa3ekax5uz
X-Rspam-User: 
X-HE-Tag: 1793914499-213684
X-HE-Meta: U2FsdGVkX19qaTK5bqyWxD7KLOMWCdyVne7Ib9y1zGVn9dg9ta39hsXH9M6qbOtbo/4B1vLwGFctn3qJ3TIwOHIaH6Df2a1JKfvybD7ZIs4RFH+e1dKFtz6A+LUfXGGKt387sJuG5DY3kCvl1GpdB6rqMXKxBOSAAJcvxqcquAfkiHv3aOhhOOqR73Fza/Zh+HXdDEB6RSpZ7XRg9a+6/zabWp9rnA2N/BWYD/u/LKoFCj6nBRjp4MRzoBl6q+NefzPyf7TL5AKzrYxMFJ6eenBE/feXn3bwXiTVBEIb/M0rhoQPvN8wyF+1UADvQn3RjLlxZQ02cjMMRFfrVPHCNI45rSeUWWlfRVA6kFAI66KWluY+LaE4VG9ydQrj1YWWE1D1Q6M6G1qg4RrSSRgR6dVK8J6uzHfasw3ngLLTNTU631tlibhR07zPsk1vH/DLExuZlEnp8EpIhnkyhOV9PqWgZiUoBP8VIfAFMP/0HQMg9H2UyNRWh9AUcna+tVd+ePps7yE0eW+ZBUAtCaUhrCkfepHCFw3WSS8X7wGTTlLNNCc6T7gciqy0kVW8nbvqMKe8bF7nttT4wbvnRdWMVfxY3g3QG1XMjDL/Vv5O8fVKsjPAQCQ2gJ31FJXDmHPtzEkvoHrIxDjauD/Q4Oze0pR4MVjDyYyeuYzV/TWK4fF8LUg8pIDGP/0sl7j3ej3oAjqKA+0ea3/3+lZHbbRfqeLQfcOIuMzl06wPqePTErjKCjvDGZ/9WkiYqDZ8+mtC7tXZ0hapWSrVHjYevgR/phlqZ8N4WvnEfz7SDO99pv5LstGVsjirI+WXL1Rh6Unwemq93rLtLpl7Cbo+UlH2SLMMElDPb7V4f7U3z3NxZ7Lf234K/0uYHIPq8zfC2JtIMVGOmuLW/4MZI3KbePo0tdIANogKgz09HsSKRZv63dvrLIBp3MpI+T2MRhOAUU4P8TTszItzHtcfcQ2iYYJ
 mUO0I+Tk
 Qa+CuYVQjOxkaTpYmFNyK8jPKXK8082uNASFevn2DAwQz1SkqRwZYEE/EAhjv5wytQ4QDafM7KN8QdAzNO7nZ5EXQwg0BKYYcq1544U8Nv9tDut5mczwl+klqGnFUJnr1NmokBn5vatgg6FAGwCvUyZhVLe2Ll3XO24uyKuGGagXOyjpsc81WxASkzAwj9wvMiiaE1T2ckmikEiJWm+8diMvkmi9EIe0xLToNO5KxRrFFxA/F/665MbYO4OrLE0HC3hl4p9q3mTOeVHHkp8l8+e9dvl+9C3C3EoukV/BSh2yiRu+AXS80TdGhf0h6LU0pNDHHRlcM2BDuQ8/njLLPB4HtP3nUhdIrShgoxzMaXQe4xs0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
uprobes VMA validity checks.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 kernel/events/uprobes.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index caf444762a27..853fc952331c 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -134,12 +134,14 @@ static void uprobe_warn(struct task_struct *t, const char *msg)
  */
 static bool valid_vma(struct vm_area_struct *vma, bool is_register)
 {
-	vm_flags_t flags = VM_HUGETLB | VM_MAYEXEC | VM_MAYSHARE;
+	vma_flags_t forbidden = mk_vma_flags(VMA_HUGETLB_BIT,
+					     VMA_MAYSHARE_BIT);
 
 	if (is_register)
-		flags |= VM_WRITE;
+		vma_flags_set(&forbidden, VMA_WRITE_BIT);
 
-	return vma->vm_file && (vma->vm_flags & flags) == VM_MAYEXEC;
+	return vma->vm_file && vma_test(vma, VMA_MAYEXEC_BIT) &&
+		!vma_test_any_mask(vma, forbidden);
 }
 
 static unsigned long offset_to_vaddr(struct vm_area_struct *vma, loff_t offset)
@@ -286,7 +288,7 @@ static bool valid_ref_ctr_vma(struct uprobe *uprobe,
 	return uprobe->ref_ctr_offset &&
 		vma->vm_file &&
 		file_inode(vma->vm_file) == uprobe->inode &&
-		(vma->vm_flags & (VM_WRITE|VM_SHARED)) == VM_WRITE &&
+		vma_test(vma, VMA_WRITE_BIT) && !vma_test(vma, VMA_SHARED_BIT) &&
 		vma->vm_start <= vaddr &&
 		vma->vm_end > vaddr;
 }
@@ -1607,7 +1609,7 @@ int uprobe_mmap(struct vm_area_struct *vma)
 		return 0;
 
 	if (vma->vm_file &&
-	    (vma->vm_flags & (VM_WRITE|VM_SHARED)) == VM_WRITE &&
+	    vma_test(vma, VMA_WRITE_BIT) && !vma_test(vma, VMA_SHARED_BIT) &&
 	    mm_flags_test(MMF_HAS_UPROBES, vma->vm_mm))
 		delayed_ref_ctr_inc(vma);
 

-- 
2.56.0


