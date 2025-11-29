Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1937D116F1
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 12:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 927376B0007; Sat, 29 Nov 2025 07:36:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FF776B0008; Sat, 29 Nov 2025 07:36:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815926B000A; Sat, 29 Nov 2025 07:36:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2156B0007
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 07:36:57 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 040AFC09AD
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 12:36:56 +0000 (UTC)
X-FDA: 84163594074.05.A877F73
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id E5D5D1A0005
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 12:36:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764419815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Ot2Tg1xiAoyo3U7a294MLHTQILR+1RrXETLgGihLK+8=;
	b=a/Zf04rvOf4LcuWwMgnLZA1xt9WgK/GLtVKcyB/DNvVxTPXm4sj3aM58jZOZ944wH7cwDj
	Q30ilSmifv70I/78ZEGbaIysVGEX4EWcCVjxwN+KpjbvfKwkS0UCAVHCLOboBeeun1nx1Z
	d3S2wO0rSJA7uuZqca+Zn9JgY1KdqYY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764419815; a=rsa-sha256;
	cv=none;
	b=AAI+DuwTN146+NEVb67m8bFPi8nl6GXWnZxyj5mKxNlSlguceB3b+uSzbqFIbiyA7I5ICL
	Omx5aDZ8NFPNUxaGObg8S1qfHvz6wuyLBHbDIhs3yELQb7VxcrES8B0mhRrX2gxIozJdLo
	RhECnjS35tAaCOfq5yNfir8YG8rV9ec=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D1E51063;
	Sat, 29 Nov 2025 04:36:46 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AF5043F66E;
	Sat, 29 Nov 2025 04:36:51 -0800 (PST)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com,
	kevin.brodsky@arm.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	stable@vger.kernel.org
Subject: [PATCH] kasan: hw_tags: fix a false positive case of vrealloc in alloced size
Date: Sat, 29 Nov 2025 12:36:47 +0000
Message-Id: <20251129123648.1785982-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E5D5D1A0005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: xc5n3iwp61zkd7boq6i3srr9yt7bku8d
X-HE-Tag: 1764419814-630920
X-HE-Meta: U2FsdGVkX1+UtLiCkLcJP3j+mmL/JdLJtX4gJ56dEw2YQB2PEmqS8XVo7FOmB8zwzSHzoSDWFP4khOUWvOkilrA47PHpdAMw/IxuX9PhxZt3aLxMHuBvDXVnPcoPPqn3c1yUXd3gbjvHtJDNCM/xjw3hK4/WfR+mUTOcAo9s9dJqzF4I8iOwffSOrL8EYnjKjUu8aMKi2R/mVH2++5Vbp6DqZfsuRKkq/G7MGGP45nTFLXsBSzY3sGVhTI4dzfry6bvrcgW/wmvSgTJuwXcO4NasLUCaGWvWIa/bDaflwBbwIJMssnsQU0vkZhdaesyP3BxkFjHnDFmuE28Igp8C4X53eI+J4FBEcu4oAcI+E2HE9VxHzN3dWTSuKPC3qsDI/4r7KPv7GOX0JY1fs5ebPU3UA2i9Sr2i5k/YCSeYZ1ClST1+JI9FZJ/zp/AzwAEX0bhIYRHgl5cMjR7SWuCF5OJ18rc2XqzXVfaIYlTEyP6DZvkRaaO0JiQO7SEJWcJ6KMHFWUNOvJGeJsQdqDAuU7AUBc4j3pQvGoBxbjCD5HzQjvLwZWfuayNFD8ts7AdcMzK1zjc7b5QbkEJuU4guJ7piFwDD28Fwp4BsHwY7pQ62KUMkysT04KWsRycHKOAeUOTWVRHmnkSv6wGlGqC3TJiWDjZjyUhIDf/3Ok1rw4ECXT6v8b/J5yK0cuk47EQ2G13rylFaooc4RUOHQ76ToZ39tN3YJ+Et2PP8RaPVhfLHVNxKf0qSqaTYhUt3K1RKK8Nn2BGLYKxtD5m9aHhv1CgVau46H77I0BjCVEKEL2pDncGej8+QIoEnhONHTtbxhKmAZxOI/9G+BN5WjM3OaD5UhAHBdgVGf8PjQpyL2MKZbzlJzktYJOzA/P6svJ4sUC/8OYXvUqVMMbwX/+Zx3v58Z03PSiU82u+iRebUHltJO27r2nyYo7/2hdiK3IYrQlGzDATp4ptd5FWwke/
 vbvY2g5i
 cP1wNHuK5RuOLPEltK201duqYw7hUigEWyqQBrR+gDP899WgrWCtv6Il3xeUbYE5JxEDelRAAzjSZMa6oW4Zy1NiwpxqsVHncfpCB1vqxRWCQevcJGJQMiH5bEO+oXtxHpH/SNBoS3QG32Jf35Pe2m1qjhoXrQhF1riR+VYP6vzddeUOLioIdMZNVOAC+ewyCytp7c+swOF/WhCeDrOTXMwbJOowV6vrHWNre+Z6/F/+L6aybGstWPT1PrLsl8cV+ihMynXeb2edT9lItarnppKRS82v27VhswdXPrDG3t2fDMQHTWGfmtPIHXoE2rJowKdb6ZgwLHxXlmw4TxbgKKndwemsi+365ZGa+ciKMfJlCNSU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a memory region is allocated with vmalloc() and later expanded with
vrealloc() — while still within the originally allocated size —
KASAN may report a false positive because
it does not update the tags for the newly expanded portion of the memory.

A typical example of this pattern occurs in the BPF verifier,
and the following is a related false positive report:

[ 2206.486476] ==================================================================
[ 2206.486509] BUG: KASAN: invalid-access in __memcpy+0xc/0x30
[ 2206.486607] Write at addr f5ff800083765270 by task test_progs/205
[ 2206.486664] Pointer tag: [f5], memory tag: [fe]
[ 2206.486703]
[ 2206.486745] CPU: 4 UID: 0 PID: 205 Comm: test_progs Tainted: G           OE       6.18.0-rc7+ #145 PREEMPT(full)
[ 2206.486861] Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
[ 2206.486897] Hardware name:  , BIOS
[ 2206.486932] Call trace:
[ 2206.486961]  show_stack+0x24/0x40 (C)
[ 2206.487071]  __dump_stack+0x28/0x48
[ 2206.487182]  dump_stack_lvl+0x7c/0xb0
[ 2206.487293]  print_address_description+0x80/0x270
[ 2206.487403]  print_report+0x94/0x100
[ 2206.487505]  kasan_report+0xd8/0x150
[ 2206.487606]  __do_kernel_fault+0x64/0x268
[ 2206.487717]  do_bad_area+0x38/0x110
[ 2206.487820]  do_tag_check_fault+0x38/0x60
[ 2206.487936]  do_mem_abort+0x48/0xc8
[ 2206.488042]  el1_abort+0x40/0x70
[ 2206.488127]  el1h_64_sync_handler+0x50/0x118
[ 2206.488217]  el1h_64_sync+0xa4/0xa8
[ 2206.488303]  __memcpy+0xc/0x30 (P)
[ 2206.488412]  do_misc_fixups+0x4f8/0x1950
[ 2206.488528]  bpf_check+0x31c/0x840
[ 2206.488638]  bpf_prog_load+0x58c/0x658
[ 2206.488737]  __sys_bpf+0x364/0x488
[ 2206.488833]  __arm64_sys_bpf+0x30/0x58
[ 2206.488920]  invoke_syscall+0x68/0xe8
[ 2206.489033]  el0_svc_common+0xb0/0xf8
[ 2206.489143]  do_el0_svc+0x28/0x48
[ 2206.489249]  el0_svc+0x40/0xe8
[ 2206.489337]  el0t_64_sync_handler+0x84/0x140
[ 2206.489427]  el0t_64_sync+0x1bc/0x1c0

Here, 0xf5ff800083765000 is vmalloc()ed address for
env->insn_aux_data with the size of 0x268.
While this region is expanded size by 0x478 and initialise
increased region to apply patched instructions,
a false positive is triggered at the address 0xf5ff800083765270
because __kasan_unpoison_vmalloc() with KASAN_VMALLOC_PROT_NORMAL flag only
doesn't update the tag on increaed region.

To address this, introduces KASAN_VMALLOC_EXPAND flag which
is used to expand vmalloc()ed memory in range of real allocated size
to update tag for increased region.

Fixes: 23689e91fb22 ("kasan, vmalloc: add vmalloc tagging for HW_TAGS”)
Cc: <stable@vger.kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 include/linux/kasan.h |  1 +
 mm/kasan/hw_tags.c    | 11 +++++++++--
 mm/vmalloc.c          |  1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index d12e1a5f5a9a..0608c5d4e6cf 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -28,6 +28,7 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
 #define KASAN_VMALLOC_INIT		((__force kasan_vmalloc_flags_t)0x01u)
 #define KASAN_VMALLOC_VM_ALLOC		((__force kasan_vmalloc_flags_t)0x02u)
 #define KASAN_VMALLOC_PROT_NORMAL	((__force kasan_vmalloc_flags_t)0x04u)
+#define KASAN_VMALLOC_EXPAND		((__force kasan_vmalloc_flags_t)0x08u)

 #define KASAN_VMALLOC_PAGE_RANGE 0x1 /* Apply exsiting page range */
 #define KASAN_VMALLOC_TLB_FLUSH  0x2 /* TLB flush */
diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
index 1c373cc4b3fa..d768c7360093 100644
--- a/mm/kasan/hw_tags.c
+++ b/mm/kasan/hw_tags.c
@@ -347,7 +347,7 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
 	 *
 	 * For non-VM_ALLOC allocations, page_alloc memory is tagged as usual.
 	 */
-	if (!(flags & KASAN_VMALLOC_VM_ALLOC)) {
+	if (!(flags & (KASAN_VMALLOC_VM_ALLOC | KASAN_VMALLOC_EXPAND))) {
 		WARN_ON(flags & KASAN_VMALLOC_INIT);
 		return (void *)start;
 	}
@@ -361,7 +361,14 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
 		return (void *)start;
 	}

-	tag = kasan_random_tag();
+	if (flags & KASAN_VMALLOC_EXPAND) {
+		size = round_up(size + ((unsigned long)start & KASAN_GRANULE_MASK),
+				KASAN_GRANULE_SIZE);
+		start = PTR_ALIGN_DOWN(start, KASAN_GRANULE_SIZE);
+		tag = get_tag(start);
+	} else
+		tag = kasan_random_tag();
+
 	start = set_tag(start, tag);

 	/* Unpoison and initialize memory up to size. */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 798b2ed21e46..6bfbf26fea3b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4176,6 +4176,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	 */
 	if (size <= alloced_size) {
 		kasan_unpoison_vmalloc(p + old_size, size - old_size,
+				       KASAN_VMALLOC_EXPAND |
 				       KASAN_VMALLOC_PROT_NORMAL);
 		/*
 		 * No need to zero memory here, as unused memory will have
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


