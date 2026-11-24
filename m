Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C871606A684
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jBY1Qn66
Received: by kanga.kvack.org (Postfix)
	id EE3CB6B07E1; Tue, 24 Nov 2026 12:10:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC2F6B07E3; Tue, 24 Nov 2026 12:10:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD1FD6B07E4; Tue, 24 Nov 2026 12:10:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A06E46B07E1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:10:30 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD0F7160AC4
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:10:29 +0000 (UTC)
X-FDA: 85470651378.01.21DDF8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1BBB780007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:10:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jBY1Qn66;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795540228;
	b=TnejhQQKbgSe6yX2KCnWp9VrY2oKjhJ1w0Eskb5MCCk5ucJTwhtyn78DaUkl0ENf9rmpQJ
	fCJJXtSWH0BZFebkD0Ef0hMKPNv20JAgALyHhDLH+Q3Ml8XiK8YXAYS7pZN8/h1JEv8cyR
	NzzIfVBJbvOipAxEe16DBwo1zt0DwBU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795540228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXXPy6WusW+RtMHH9pxyWXYqvEUmlOSucA66MCbMyWM=;
	b=lDqCqamq585+Sv1DbmWXDa58p/d6g3ri9/hJKqwKzGUNhQ1vIUJCRh0j1SsK55UcLqzffO
	w25zca8NnLQtA78hcBxt+vKDwgX4LP7xKb4vF5VWP+1D+uF5PIJisuDx260LWOoxWEb+vZ
	am5HopMXsIJTWpiAR/lVpjNd8T3GxeM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jBY1Qn66;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30C754594B;
	Tue, 24 Nov 2026 17:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B768A1F000D2;
	Tue, 24 Nov 2026 17:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795540226;
	bh=kXXPy6WusW+RtMHH9pxyWXYqvEUmlOSucA66MCbMyWM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jBY1Qn668Xx6cFJn1LNQP++BAmL+XvoNrVOqmY0WeqFfOa7oiFQUE/L+yXLAvymNw
	 j/O7opUmRdBVZDFK2z2hwCfdDjgVunIUuA+NHJhc73ppbsWIYV6UMc+D/IyTVzC6R/
	 A3LhdQQSfjgQMdYgOheTVx0LiWEiiJNujEQRY2WemyqbIKOSm22GpuXIk8yUlIaZck
	 u/aeL20jppZ0Mj2zZTNW98wbqcx5ARmvc6Ds2tmFh5xJEqbDb+uG76VMKSrzLasMCA
	 evPNd4hzOIDXMTEX4j7umlJ9XOarBUNgfLgeqBREgxfDKLaojaV5GNYDwDuOFTlTJw
	 VjY8mP5Nt3sIg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 17:07:58 +0000
Subject: [PATCH v2 06/11] uprobes: convert VMA flag tests to use
 vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-vma-flags-v2-6-bf3fade93064@kernel.org>
References: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
In-Reply-To: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1883; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Re9y/UhEggKk0Yr9WN6U0P71qdV2VZQcBDAdRJ6gjq4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZj+Sp3EsMqglU9Xeo2CWvtvVSf9i/3rwJKYynboVsn
 v5NeM3hjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAFyEleGf/SvrBLe8x4F74xas
 OpVwadINw9DLs+rvtredqfzmGexZzPC/kEvZrnNmx/YVzyO2V/CFB778ayYkfSV8hdnMG0umXZ7
 FAAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: 1BBB780007
X-Stat-Signature: mpk3twufh4yjnjhq117wqwntogo87h3n
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795540227-39237
X-HE-Meta: U2FsdGVkX18z1PXRWhvTHMrmM6vCwfl9hoLFC4VAlgsNeOYUi6UVOMUYbSTJLV2lTC7LNmSss4yErT73ymQIEsnD+pvR59YX3W4OnQRisvlnfhFwDfl29jdkfd/ynGXVVCEw3jIyJi0K/HelyF67tr2TPHVsmRuiSuGw7facX/g7YKLgcmlqa+LbfHwXkZS9Bd0kPjEOhVQbP4yMXiQt6MuCfGn4wGJlZCWPXE531meZQMiKd9uEL2H6Nj1URJY9O1ErjnbygdJaiUGFPRCH+OsbgmnTqblS+J25suM7j4QlifLE8qw8UkSPCME+iXVbyE4qeub7S9BGoCEavKNLDalYIsYGYboouFH1opCknKDPEg9tHi3CB5oxIl4UDIGQDj6mZthfgq2idMaPUpF23NeRN7gwi2TfAormyHNybz99oqmiwi0DmMEFVe2xUdjhE+nBbfcQs9rBwIQMrVrntCN9y5e0DmcbD7CFj+RFYxqfAFSPOn3kupYEqXXBVZjbdwbKWaN9GzN2AhmfCFPhq8sTxnFlLZyX9BaaiQvSj8emmbYrchOmy0RHz/VRA+uhteyf6FFeg+lqb81z3mi02BMhiEzhh9vZN66UjgmuF3GSFKjdm5uGrVGm5HHUeE5bdCMTbsgz6d5uj09jRnX+22xb8vuf4MrrZmOqkOxZVPRjmFW75TIZDdUkp94BTIxZhLOjrVw2C+eS5wCiYz9kkJPKSz4bb1E7OjwTbyFE3Qqq8kszcohd+UsRfHJAVtoppT/1cbxakgv8biv7FRXEQ5lXdnLz6iqqkl7TA1LHe6T533SE5m9jojVjdFcbpkGgcAnsDqDOY69gOsX5oyGt7wWZT/CS3gftFABP9HbR9apOEL/CWIGm6PTJU91gKrlhDHiCrF9JyDLwG+WRprXmi/qS4l6ka7P35agZB5YebxqE8tYWeZ1wj8JNdRea1ExszYQVILypkKN6eTjEjzv
 NL0q/ZuY
 kOF/Edz6fYJ5z0ezJLLo4mybkgeZVv58lpjYaf2m1UwHM5qVNYMpV889u7nvS+wXnNT6agCe44Er+cbuv5xEZrBOvJ5MdBTQs8PgqCOiulL1ESGUDKSwLYjiMJXpvRfoNQBCGyXbpHegwNiUZobg8C97spTXHD+7BCHDwxnl9yHKfYSADsLIk0csfr/z96kt9UoIZiZDv6LYAYmK7lHOPp4D9i2VFlMThKgFm0tx2BJHEWcBoU2K+6C5ItiASfCT07IhbZZ1bv9zFMg29piVJAltM0VQzQnoQMp5I7gXIUnFZC+/wj+g+zMeWApN5DYpUrLhmLKgnftsJpJtNWnXnVMJg0xxl/NDU0d1c8ce66Rpj2gX7+i5x9L6BLay9GU1iMF6IC9vjMJ56iVhFSMtfe4kPR0jBPUUU0pFnN+71a1m6NjuW+xO7v3cY/36XJkIv1QAhvAnYL2HwD5bI6Xv80aVCj2Rt9BigoVvSdQPkO4XyDrIz+0Vf6Wt7KepY+jj7sdRPeDF5IWScrXbhcGssrlSHTGjBF0igRa9PZhky5dvHhsQgcazMUlhgpiXwFiPABHGqwEA4vqhobJH5INzgbEVq/Q==
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
Reviewed-by: Lance Yang <lance.yang@linux.dev>
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
2.56.1


