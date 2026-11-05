Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6EA3606D814
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R7WzdCq4
Received: by kanga.kvack.org (Postfix)
	id C1A576B05C9; Thu,  5 Nov 2026 16:35:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA6E6B05CA; Thu,  5 Nov 2026 16:35:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA1D6B05CB; Thu,  5 Nov 2026 16:35:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 830A36B05C9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:35:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09874160C08
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:35:37 +0000 (UTC)
X-FDA: 85402372314.12.998BFF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 32C324000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:35:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R7WzdCq4;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y5JuvNnNeOh9oIZYUQiD2mrwwH6GN2Nh0rxsj2kJwUo=;
	b=Vy2xd61NyyFtUWYO5gh9zKXygVprQyKCFFScBcBW1lo/CgyB50tAcjndmTmvMVZ63O3XTc
	w4gnTQWXXmai2PdN7Na9T0w4STAgikmphUNMHJWZWCd/vd8hzMPpexGH6EWSjDRGo+svGM
	E1GqFDD/8G5VVim8mkRu31beh+HqmV8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914535;
	b=AX39Y2kQOtc8PKTiy2msD/K5kH5tdsLxZJHUET4JqwtDVKfnUem65EqtnVCuhDU/jZ3jbz
	ArUdQW49fsKXn5xZeTaSOPoyHxVWcEJCKg72WWZ3m93DQYwFVC8mYM+jrRLHf5iFmcyRTm
	1kUBDccjbaKM1CnJax7y1bKyIliGmDg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R7WzdCq4;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 602C44379B;
	Thu,  5 Nov 2026 21:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89E21F008A1;
	Thu,  5 Nov 2026 21:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914534;
	bh=y5JuvNnNeOh9oIZYUQiD2mrwwH6GN2Nh0rxsj2kJwUo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=R7WzdCq4szIDwvRrpAHhITrD0LMGL2Ayr/ooKvmMdyGasXQKDcBboripakmO01VxQ
	 YV6gWg3WzYXJGaP9RBXms9q1o/TSZwVLLaVEZfqLw0xiVgCNumabu3VK3l05YjGAQ2
	 46aaByM/B5ZaXGXlsVEhPqLim2HZXmKUrYtuwr1dNrHF5yB482YZP9OW2Jtvu422ao
	 6Tt1yTUQ1HqeI4mlyuzXFRXgFr1sp/lZYoZRhG5yDHjZjw0XlC4zm1FOELcAb2B6lS
	 fn9rEaS0KIp/p1dGwSwtWV76kVBTvwe1On76u9GWkFrWldtHLna5zrVfRdVYH5SYVu
	 GuO5/2y1sU0NA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:31:04 +0000
Subject: [PATCH 13/13] security: convert VMA flag tests to use vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-late-2026-vma-flags-v1-13-0d3cd15ab75f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3517; i=ljs@kernel.org;
 h=from:subject:message-id; bh=mMkVa3Aus9iq3GDDk7CXNqU7B+d35DdB8d1OJciXJ/o=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLefF0x/4mS2NVe3nd/9p3ZfnzOaYGJvjo5O8+kJ13ud
 1ZPNlAr7ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBE5Ccz/PeSFiq94GRiJT4r
 cM9y7UAJQ5np05894OaeezEhc0k9mwIjw9qZtm6zPV99FD/eVGBjuExiZXPoVpMpufynsmSe/N6
 dxwEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 32C324000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: rppq43h3ymrisnkmb3o113puqamae8rh
X-Rspam-User: 
X-HE-Tag: 1793914535-950180
X-HE-Meta: U2FsdGVkX1/JVLKSJPr29gPDYNtttnZNYj51omdF4tZHlWM2Rw7kZ+0ToztgiWm2/SMJ60F+wA0r42MEtue5tUe6tfcJQv7cMqAUsBCUcJQJN+qCSRShuyQ2nzK8mx2gtHJfe7YORNcbUwyDjKImhr9Qh0tqGDJkNC0FpnBSnopat0HhWyg6va4BusPXvOU6kMFaQu9XEACvaVYjh3iraJy8hHQ1ooTu3mqcfGRs7nnkvLVPrcfLMnvmMDt+/CQeL3PcKkVR57RbKN+8G8v2ZUspr/09XKv4qfW43jGXHNhrTtUQxBchrKk18eRBnoOf1wdwSPjuIR/iWdpyS+JJXzG3/EWlkw+Fms+Onr4xg2l0JGBR6uPTpXZ7STQL7aHqcDzIZC6BCbhonSer/IulqwYCv84zep7SGZ2K0wWoQK/MHUNUc6HGUDLUVEJKPkId/BkNazPLYjOP9yP7Eow+LSI9UiXubK55PHqiSOEUd7pMqS4T/8GbfHrGsN1sFR0YTq3OgwRoMtgrozrHc/9olykWrhEI+R6qIeBicCSN+PeilrZZFONYyrsEaQwgtvctN4r5HH+vQVFEF2XZb/5vPN9wgB7Lws3jD7OWuDwpAe33HapOZldvTZyI83YkPlIgSnMEcr8cispuzFlDkcFQ9YNQsTo1G3he1gkht1KDEW7FG9tBqmQvdvEtA0ZohSHucA4Qm37myUNtky9KWW2IdAfO/jFqWeO43viyRGTOfoAEhPYU0TXAMJMarJ8wm/mYs8TSjsv9ejhrKQL2q5hivnUHuOszPv7fyn6teW6Eblrj3d8UBfBuxYGRcE9Ng7OJo7qUBvEhcVZUEEh2gVgDgcpITGBhBeUd3MFpm4bfFtfxXnoPGu5QU0bbyr28IKc45AKouez1dZ2OoPJzz6PLL0sIw5tpKv57WKU0E4vGJ3pMrT9oVxofdOouD3xOdSg8lxDp0wX4e2KNxTvLvWL
 Rt2LYWKd
 E2LMutz9RtxDRFBD5m526dxH+lJfDzbdXxf00G6xa0nL6y6KLJqRtNnaLBL+SJXtrtd/q6GJZH0j+zcBRkB7PAgCF0s3yxVBfq15kAhOf0rs5ZsOSEFyZJaY1yjBkz4XfHpPAcI2paitdH7a0dJyMQ4Sqgyo6UxbIZ5e3zvsigvCmmBYtg1eZ0i4cqbvgtSEu7Pg0zsw4XQladKkWwEgDwWuH19nsix6U8jFwzJ8thuBFoTDXeg6mTAmYFYN2wlcly7Hs0hag0DzgWCoK1OT+tUzjWF/n/KadzXeCtXzfjuRUHFatPnRRu5et77QRCLWdrt1VhAc4RlPieOK+I2Pogir36XVUcYbArSXq16j7GUJJc2+26KVOGp9ezg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
mmap and mprotect LSM hooks of SELinux, AppArmor, IMA and IPE.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 security/apparmor/lsm.c           |  2 +-
 security/integrity/ima/ima_main.c |  2 +-
 security/ipe/hooks.c              |  2 +-
 security/selinux/hooks.c          | 14 +++++++-------
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index c73681d820a0..00099a32b3f6 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -590,7 +590,7 @@ static int apparmor_file_mprotect(struct vm_area_struct *vma,
 				  unsigned long reqprot, unsigned long prot)
 {
 	return common_mmap(OP_FMPROT, vma->vm_file, prot,
-			   !(vma->vm_flags & VM_SHARED) ? MAP_PRIVATE : 0);
+			   !vma_test(vma, VMA_SHARED_BIT) ? MAP_PRIVATE : 0);
 }
 
 #ifdef CONFIG_IO_URING
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index fed80da3ee09..92032afe4cd1 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -556,7 +556,7 @@ static int ima_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 
 	/* Is mprotect making an mmap'ed file executable? */
 	if (!(ima_policy_flag & IMA_APPRAISE) || !vma->vm_file ||
-	    !(prot & PROT_EXEC) || (vma->vm_flags & VM_EXEC))
+	    !(prot & PROT_EXEC) || vma_test(vma, VMA_EXEC_BIT))
 		return 0;
 
 	security_current_getlsmprop_subj(&prop);
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index d878b52ceec8..247b07748b1d 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -112,7 +112,7 @@ int ipe_file_mprotect(struct vm_area_struct *vma,
 	struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
 
 	/* Already Executable */
-	if (vma->vm_flags & VM_EXEC)
+	if (vma_test(vma, VMA_EXEC_BIT))
 		return 0;
 
 	if (prot & PROT_EXEC) {
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6168dd5f91c2..1bf78c2a6aba 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4206,16 +4206,16 @@ static int selinux_mmap_backing_file(struct vm_area_struct *vma,
 {
 	unsigned long prot = 0;
 
-	/* translate vma->vm_flags perms into PROT perms */
-	if (vma->vm_flags & VM_READ)
+	/* translate VMA flag perms into PROT perms */
+	if (vma_test(vma, VMA_READ_BIT))
 		prot |= PROT_READ;
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_test(vma, VMA_WRITE_BIT))
 		prot |= PROT_WRITE;
-	if (vma->vm_flags & VM_EXEC)
+	if (vma_test(vma, VMA_EXEC_BIT))
 		prot |= PROT_EXEC;
 
 	return selinux_mmap_file_common(backing_file, prot,
-					vma->vm_flags & VM_SHARED,
+					vma_test(vma, VMA_SHARED_BIT),
 					true);
 }
 
@@ -4229,13 +4229,13 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 	u32 av;
 	const struct file *file = vma->vm_file;
 	bool backing_file;
-	bool shared = vma->vm_flags & VM_SHARED;
+	bool shared = vma_test(vma, VMA_SHARED_BIT);
 
 	/* check if we need to trigger the "backing files are awful" mode */
 	backing_file = file && (file->f_mode & FMODE_BACKING);
 
 	if (default_noexec &&
-	    (prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC)) {
+	    (prot & PROT_EXEC) && !vma_test(vma, VMA_EXEC_BIT)) {
 		/*
 		 * We don't use the vma_is_initial_heap() helper as it has
 		 * a history of problems and is currently broken on systems

-- 
2.56.0


