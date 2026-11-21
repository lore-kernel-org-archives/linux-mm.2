Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AAC6606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 16:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b+3C52Uo
Received: by kanga.kvack.org (Postfix)
	id 43A006B05BB; Sat, 21 Nov 2026 11:03:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA546B05BC; Sat, 21 Nov 2026 11:03:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3010E6B05BD; Sat, 21 Nov 2026 11:03:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BB7B6B05BB
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:03:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A2B5160534
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:55 +0000 (UTC)
X-FDA: 85459597230.19.60BF253
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 903F3A0004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b+3C52Uo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795277033;
	b=TNuqIbUO3GTGfxtXC3mVC4BPs36RPNhdi/MwYXYAMhLk+k4cYEyNjZjO2D8ThRksoSRV3E
	LlhWXw/HyI26Rr7LKpdB1MAcXIzbMax/9h75bowgUzmBmjPQnBhikDeKQcOQLgwlscGJPm
	dj0f272mMeZYkEz0NKYS6Q8uotFniFo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795277033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDSkNbiVCjcKjY0huYgi9jNgMZpXs6ov9m7QmsU9zQo=;
	b=8rDPl63mi+1NChuut9+pKNTXJeyfGri0FJ+vMlDNApB3Psi5EVOLTwbjTnvhCWHC/L2o7g
	7VfNEM5w9HPgJu/VubgSpK5gI5xI6plRokWTMt8lOQs0VUDt2OD9mCRxa43Sl9YOxY4Smr
	DPYNbQ8hzZlDKTy7fx2VYPdCbo1g/2g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b+3C52Uo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7C8C416B0;
	Sat, 21 Nov 2026 16:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789371F000C6;
	Sat, 21 Nov 2026 16:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795277032;
	bh=UDSkNbiVCjcKjY0huYgi9jNgMZpXs6ov9m7QmsU9zQo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=b+3C52Uo7MISXKD2TUrjtOl8AK1/SmPI3C4oJJ/6OTTfmMhL+jjWFmWhpMrO01ICj
	 nspb0UJo6sEEuvwdwUqTt1Plj3WNqPv+NLM4pLPdAZWDIa03BW0h1aRbetd5YsO3oN
	 ug0MctLjIR0H6yImQiZWBiraf8C3vjhBBWh8u55rNzwkbAxquJpQtayKQEjmvVCtwv
	 GJYxU+dyk5UYUYnYdbdSRkR2p8hhbHEZa0oH/j5eitvz/WCpTYgqZ1spNUR+1KFqPo
	 tdjJNnnTyPtdalUFW+QeWfrK/0X6iRTFTgVYjy8RJxy1w/saLOJFAhiycgBiFj/vJX
	 w3VCRYVzM3fZg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 21 Nov 2026 16:02:33 +0000
Subject: [PATCH 7/7] mm/vma: make brk mappings non-executable under MDWE
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261121-some-more-ai-fixes-v1-7-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2192; i=ljs@kernel.org;
 h=from:subject:message-id; bh=0hgCjPfgFXf4bZ+aA8yvv6WW2+hAHQ3XfeJvr+jnVpo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIZD+xY0vBqqsavCUsOZHHXfruUL+t6JltYqsD7zW6mn
 ytf/rDV7ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBE2M4xMpwUkdOV39WSqdDt
 fWBupyR748rMJX93/LVhFgvqm159JJaRofO28yXdVd1n9/DszJrJzqn3Le2X+YPUM5OsNz6+8mp
 RIR8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 903F3A0004
X-Stat-Signature: e9ie74jyd8e6dum6itfddxpusg1rqcn9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795277033-966730
X-HE-Meta: U2FsdGVkX19kxjMf1ncJVbqOoCKNmguBkQoUBazmxtwhkIYsmDpQWvw9K3NO+2n5A0XOL0EwOxNe0vN923v3cAxml4FUPpc4OGmkvcYoeM5wkp2ECxSm7SWUz3fV6Bpkrkf4Kq8zjXRrjFm9w2ToPc1G5kGYagz/srOLg20VbxySA9r0KUvym5lAOeDwt7C3HiWAlC/UcePZ7Eci0lIG2OaRPEjTOkJdh41/ynaliU6nNWbmbsAYT1kV1hESpaqyYvf/eDO1XmXiOS6hToiR243YjNDbSfKsidvIoq0m3x51/P2xeQkpf7FgfMcOMflrRzU84kk8SDiDnzlskhkgV4Cw/NWJcSOoAdmfRo/j4HSnBCslLTulwiRg5Rgvt1HtigKQUnP6zEjANgnwzicqK1a0BM0GqHMw2BcJM4HH45bWvckykT5d90BD4uWd+wSfAH44RqLrBUEJmOrarOmCz33Hcs5uE9nV21L+VgUU+mOpGrckfxnLV+XQX5T/D0l/PHdYFSWLlLq7vMRB5r4zMwPi6QN7gh9k7JNZfJQEQ2GNcVpCqdYAbGgSc+gPgYBCJ0cezBWLC1iEPAn6ZTUg1MbYSM059p1FDqNGvyXsJ0d6W4NPA/Ceb1W+HnmeRKhbYEernvaQZjz45HYvo3BPPBBaqFVrz8fmwTYjSP/GGueiB51gDXnTQZiHlW0AfZZZjqcyePszIbJmjcY39IKa3ykpF0ezN/b+r4ZCfrhJyqho757bdWuRIW2GwDWGammJuBEIYtZsWKgYYnIGB5BJwQCQT4Xb+numk7UlxsogsRDObhS7Py4l+FhITQIb76mYkgmkRFqP1D1gRwIbyDBY6kW/SpEB5nvQC1VTuuBLaOoCjZLqKTzJkpfT4HKWsW2IBuhEGuwDMNsffQwUM2WZtnpN36BoS7gbqPcgyGWmPpza+qVEVF3HTbgVM8N2XoR4T95AT0DKZjpXrvefy7j
 2XDEroMc
 sb+3b61aNi5tG/T/FdT2CY+qx9Cqxifc/laxZ6XWvutgy+mBwBunryVUWK9ZfzkXGejpdZSWTaBraZALqNsSX7hM+Cbz46x2MYgM537LMMOUZgeEZv0GhBWPVMZjHwWM/tTcMyx8Ayt0xscKyVWhlQhfNvaTy0J3ILWX+WAH+tl9EzaRZAe6Q1Xe1vBVFBJEpS9twImzx0ZYZCi8gbUJtKX9uQZwaiHJdK+XZEAEZ21iRoiAYNBvzf9NRWEd888gr6jFsr1nxau2Ld+rbm0hZdmnGvp1nj3bdSJlJ4TbjQAWqmLh13GH6zGeAbl+RBNjxcWrGam3qSwwaqEGlpPALdG/rcb/rjJO32VM3qFi9EbbiO0bcuDSDzhveFtd6omrpqugsNzDDC7c3XF9eCKXDSu2st1oKYJrPAb0Dw0HdI4brycmZKpspDbR/l2z9J2rJqSNNcEVh/Sk0iP6AmocDlnJxDepakfRmQNgc32REm66RATMt7KOylSBezg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

With PR_SET_MDWE in effect, brk() and the ELF loader can still create
anonymous mappings that are both writable and executable.

MDWE only holds if every path that decides the flags of a VMA asks
map_deny_write_exec(). mmap_region() and do_mprotect_pkey() do, but
do_brk_flags() does not. It always sets VMA_WRITE_BIT, and it gets
VMA_EXEC_BIT in any of these cases:

    VMA_DATA_DEFAULT_FLAGS is
      VMA_DATA_FLAGS_TSK_EXEC    the personality has READ_IMPLIES_EXEC
                                 (e.g. x86, arm, arm64, mips)
      VMA_DATA_FLAGS_EXEC        always
                                 (the default, e.g. m68k, sh, sparc)
    vm_brk_flags(is_exec)        elf_load() of a PT_LOAD with PF_X and
                                 p_memsz > p_filesz

Fix the issue by dropping VMA_EXEC_BIT if MDWE is in effect, so that
brk() and execve() keep working where the bit is only a default.

Under MDWE, a task that runs code from its heap, or from the part of an
executable PT_LOAD beyond p_filesz, now gets SIGSEGV in the cases above.

mprotect(PROT_READ | PROT_EXEC) on these mappings now fails with
-EACCES. While the personality has READ_IMPLIES_EXEC, so does
mprotect(PROT_READ), as on any other anonymous mapping that is not
executable.

Fixes: b507808ebce2 ("mm: implement memory-deny-write-execute as a prctl")
Signed-off-by: Chris Mason <mason@kernel.org>
[ ljs: switched to MMF_HAS_MDWE test, tweaked commit msg ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/vma.c b/mm/vma.c
index f8cf319ff9cf..a8b8101ff781 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3235,6 +3235,10 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	vma_flags_set(&vma_flags, VMA_ACCOUNT_BIT);
 	vma_flags_set_mask(&vma_flags, mm->def_vma_flags);
 
+	/* The flags are implied, so under MDWE drop exec rather than fail. */
+	if (mm_flags_test(MMF_HAS_MDWE, mm))
+		vma_flags_clear(&vma_flags, VMA_EXEC_BIT);
+
 	vma_flags = ksm_vma_flags(mm, NULL, vma_flags);
 	if (!may_expand_vm(mm, &vma_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;

-- 
2.56.0


