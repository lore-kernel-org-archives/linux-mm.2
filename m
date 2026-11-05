Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 209F4606D828
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cFhjc+G4
Received: by kanga.kvack.org (Postfix)
	id 3DBE66B05C5; Thu,  5 Nov 2026 16:34:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B27C6B05C6; Thu,  5 Nov 2026 16:34:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CBB66B05C7; Thu,  5 Nov 2026 16:34:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD456B05C5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:34:43 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90E7540C74
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:34:42 +0000 (UTC)
X-FDA: 85402370004.08.472D9F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D3E08A0008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:34:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cFhjc+G4;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914480;
	b=Ot9qZRwg6BcvixOxqJpmV7C2U4eQ0m01BQHfEW5kXpf6OO0H7OH2aPX2oFRq7i4dteOFAJ
	0w6lRzdb9nhKqcT5dZTlgjtctH0J6Qg+B2xm2EaR6lBnPorlJjqjJQ2yaWF8wVAvz0l0RS
	FgEzFnBLyAQTRIX+0fwvPQyjfZ+A0bQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cFhjc+G4;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9BAEEweiBOL00ynx8QFZHsM3C6FC3rJdJpwUxIRdWLY=;
	b=8NiRnO6Bhfr4sM6Ors7Ua0hXPug3NuyRaCt76Wi5+9iy8nt9nwQQk8ZIZUYlpfpYrXmdoz
	VX60AbWT0QsyoaAiAmfmycbkRa6/4X2Bs/DwCx8PGcsKke8ZaRJs4nfGCcLiT8mUofUM6d
	lNmFyRul09S/JZDr2S9+7AF3cx0mwbg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FB7A605DC;
	Thu,  5 Nov 2026 21:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5B51F0089F;
	Thu,  5 Nov 2026 21:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914480;
	bh=9BAEEweiBOL00ynx8QFZHsM3C6FC3rJdJpwUxIRdWLY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cFhjc+G4G8gAyk4Q5vXifNOkvLi+qJxrRxnxHYYDQaK+C7JgQljPw+EI6OCSe/N+9
	 xMlvS2piE0LrB1a5VTU7L5xnhvOT6DEAAwLGSQglGTVNL96iuGR5eut/CJS15JpRZZ
	 T4aqXqix0udU7Cq4t975/38o7eS2biU4lIoGAX4qf6m04ezs8PVPD8BG+vWnm9rBEE
	 Oyt/adVbaxtaaBvFhlWJpJZJA3NH2bxr78iwIzN+H2MdZo56SZXYqcsxsd6zc1SCu6
	 zJlxru9KNyefxR8kgepJDYKL3Ee14uePoCd06S3wGCFo93bqAQEkxrXYu7O9c4s6E6
	 0jwvYv9uMCYKw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:31:01 +0000
Subject: [PATCH 10/13] fs/coredump: convert vma_dump_size() to use
 vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-late-2026-vma-flags-v1-10-0d3cd15ab75f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2595; i=ljs@kernel.org;
 h=from:subject:message-id; bh=CJSeLd0QU97/MNyt+Xu3ONZE6gMT2KeSXtSTxKcXbcA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLefF2+Wcxvf8HKmsddSYcNS2Mf8UkEKGQq/Dfj1Ozau
 CVwU+23jlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkkhojw62W/gCj5yc+tyxq
 3Hzd+nvtJbNWwdnLRMyFpy01udxn/5nhF7Nz19UZAhMCvHzv6D0ysDkXmZwW7mzJL2Nf+Ob/s/0
 q3AA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 7idh3efup15ejfa4eor3p3anma64soyg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D3E08A0008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793914480-646934
X-HE-Meta: U2FsdGVkX18MwZB1/QILTByRRKWdRrBogSYwEf8xvpDB7Pi/Y4a2XSVIfERXQ0s9wAjljKSGaq0eSN9qYCVSTdWOkMJXEjuj+vQha2fNWWLbcX21YZAJ13J/YuhFrTKRZR/uObhvcQmjLTMdlBYuUGlrexZWit4gus9g1E/92yCjv7P8KsJmy5WJxlMvTkEvNsa89g1YzK4BmBwNWjQMVsmUsoj2DMkGZI4Yy0p3jQB8b8NQjVzsRtxREaEdU0inuWUyRPRUd9DR7BoJU8aA3jWjWjmYJ5rY0Lua+RJp5PyfYL3Lq/lEx5ItAxyc+keDyMrsLUV3JU3hUAV39LRG17be+Bk0E19qQITr9zq0H9RWTZ8X9VlhXUseAA4J3vcogFFzfrhOgxGZhEiQ1IqY3S3qAwJZXTIsACsXyTy7KXV5AuR/A6ihtoCSUvuPbpH0piwXHLGUuarS+1XdL7nIFWnMGmvtTAKV4qV2MRkvXHLhcw8LLPrh/l/6wJl8R94BcJjlgIbvuhhXI3g8QcYxqOzj9ZjIs1JJ3grnhNDhmsyl6JGv3OejsQCHw70kK34XWgrKEC0T8OklV8rLfu1aQtKNh2dtQlrYw7JL16g2CC3FsbaQfZlOlpB1qJAvOsWa/yHqcQZr6ziAA1OzFmSb3SqPTYK6HCyRpJI84NP4eoz+U9dOCbZH4xMxTQH55heZpy5D/sdfHr1cFaWukrBVjykkdtnrOBnfWE1zn1AnA0nOwSwb4h1qO/31w8clGKBGIQ1UPKzV9BKdDdv6pMhq9z6lCLX+KDVXYX5yGU+gdGo8MkfoSlV5dKcaoejrQmMn17SonW1DgxNGPcL2BRkvA5JSSvGcvuHQoAb546tiMjtocxImNeOCBcx65NV1oT+JhNQTAGZ5aIZ3zLvqrTnsfTLetPgD2IeiTPm7UHMo3CQ/LqCjvQvc3mQLa+Zs9/DYKzcakuPlIWYSYw+nmHs
 uHhaedM0
 Lc4NDoikOkHI8lpi+i3NfLjsRCbJu9WBJfrQRu00cK5SOHZfwYz46Y/sochi2JMqSB+tI3SxAYGyp+EEbpYQ4XqgW1v4PE4wXTmbKeOo66PhF9CAGZI/NjuAI5waWbsPM/bX4UWgrbHCCsohtoOKO2uAPwPaQtWcSd7yXU0aOjkPhWLO94J3SrvAknXKgB+I1DhICzFXC4CoRevFLJGFhN3V4qzRt6C9IfI9PEjwS8rZ1EGBZbojw6cEWl94BvXdYLzzVdIjIvjAPyXw2vq5nNMZfFZnclVO7LhteWHsHeasb+VjnzoIDJs1UMLOdaa47UzwLCU1FlQK3QvCMTDQ44UEPBcQN/o4mUKGODsH66fZUIrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values when
determining how much of a VMA to dump.

The flags copied into struct core_vma_metadata remain legacy flags as they
are consumed by the binfmt handlers.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/coredump.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index b25ef2ffbdee..6ebc04421b91 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1835,15 +1835,15 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 	if (always_dump_vma(vma))
 		goto whole;
 
-	if (vma->vm_flags & VM_DONTDUMP)
+	if (vma_test(vma, VMA_DONTDUMP_BIT))
 		return 0;
 
 	/* support for DAX */
 	if (vma_is_dax(vma)) {
-		if ((vma->vm_flags & VM_SHARED) &&
+		if (vma_test(vma, VMA_SHARED_BIT) &&
 		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, DAX_SHARED))
 			goto whole;
-		if (!(vma->vm_flags & VM_SHARED) &&
+		if (!vma_test(vma, VMA_SHARED_BIT) &&
 		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, DAX_PRIVATE))
 			goto whole;
 		return 0;
@@ -1851,21 +1851,21 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 
 	/* Hugetlb memory check */
 	if (vma_is_hugetlb(vma)) {
-		if ((vma->vm_flags & VM_SHARED) &&
+		if (vma_test(vma, VMA_SHARED_BIT) &&
 		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, HUGETLB_SHARED))
 			goto whole;
-		if (!(vma->vm_flags & VM_SHARED) &&
+		if (!vma_test(vma, VMA_SHARED_BIT) &&
 		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, HUGETLB_PRIVATE))
 			goto whole;
 		return 0;
 	}
 
 	/* Do not dump I/O mapped devices or special mappings */
-	if (vma->vm_flags & VM_IO)
+	if (vma_test(vma, VMA_IO_BIT))
 		return 0;
 
 	/* By default, dump shared memory if mapped from an anonymous file. */
-	if (vma->vm_flags & VM_SHARED) {
+	if (vma_test(vma, VMA_SHARED_BIT)) {
 		if (file_inode(vma->vm_file)->i_nlink == 0 ?
 			    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, ANON_SHARED) :
 			    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, FILE_SHARED))
@@ -1888,7 +1888,7 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 	 * dump the first page to aid in determining what was mapped here.
 	 */
 	if (COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, ELF_HEADERS) &&
-	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
+	    vma->vm_pgoff == 0 && vma_test(vma, VMA_READ_BIT)) {
 		if ((READ_ONCE(file_inode(vma->vm_file)->i_mode) & 0111) != 0)
 			return PAGE_SIZE;
 

-- 
2.56.0


