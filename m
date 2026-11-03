Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67101606A33B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 22:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZXOGSZvR
Received: by kanga.kvack.org (Postfix)
	id 3324A6B05B1; Tue,  3 Nov 2026 17:31:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5066B05B2; Tue,  3 Nov 2026 17:31:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A4816B05B3; Tue,  3 Nov 2026 17:31:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C91E36B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:31:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C692A81FD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:31:54 +0000 (UTC)
X-FDA: 85395256548.09.64AE5EB
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7419140009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:31:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZXOGSZvR;
	spf=pass (imf27.hostedemail.com: domain of 31mDqagcKCJ8MGTGT9MFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--nhuhuan.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=31mDqagcKCJ8MGTGT9MFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--nhuhuan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793745112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1QRyQDO5+0ViUOtVbl2pTjWS8q1UvDtamNlK0wDnbM=;
	b=olvH5edKL0xN5+AMMTu+fdX97epJYaGx1OFrJaYZ6e5bnzS7dqSpo/Unb3JKrzWwLkaQUM
	ApVvnUt2W5HEz5CQYhnJ++/lMH5iPhwp4AtHre82Ga6oWEPrOSFx2FnFKcX8b6cw6ux7vv
	F7M2qJRCfJh1Dt98FLGYaevM3q+U5e8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793745112;
	b=URsi8lGrfQw00efu5/PNCeYgMIztv+kAKeMRDi8LGHpdzmyHY2b/mp2GKl1yexxDJpPRrJ
	5/Vk7ZMO6inO49y8mUSXWsdZp2zpl8fnZk/k3m9B0fzNSr/Fj3mKK7UPj3wKejb4SbsKIc
	ADwbugm4DjQ1rLjflY175Vi9Sk69vmg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZXOGSZvR;
	spf=pass (imf27.hostedemail.com: domain of 31mDqagcKCJ8MGTGT9MFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--nhuhuan.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=31mDqagcKCJ8MGTGT9MFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--nhuhuan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33713e5e6daso37687eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 14:31:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793745111; x=1794349911; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b1QRyQDO5+0ViUOtVbl2pTjWS8q1UvDtamNlK0wDnbM=;
        b=ZXOGSZvRAVa7wy1Bc4h9zCeEqg5Yggel+KQyyl3nR/NS3MY24hn1mjPqEdJCGML8Ax
         vLYYSz0IS6jecvFeMxhLMFT2e+3/pkl9vTut0iFxhhlCPnfxZ6ErQ2wxpXbJbDhdljFF
         2iUm4R/X/lFlYm7TZ94xOx7WTHtseBc7sp0BxRmbenK346hFnsR885Pds7vxfipFSz44
         OC2231v3lR1QSwSPeDtr/BwJ8rt6RS88XifuhbnNIehvX4Ky7Js7Rdk1CeYiVhsFt2dm
         8t1q6BKrNPGDT3NdsfapJ6xA+l6wlEjCzpAmRjAMOuFtctowaw2w1Wa/CctvC4+Jfg2w
         hnMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793745111; x=1794349911;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b1QRyQDO5+0ViUOtVbl2pTjWS8q1UvDtamNlK0wDnbM=;
        b=ApWNsdJVmJUPXTlyO0mnyQ/mfrvP0QKbzk8+EYIw7BP25dHn1d40IUiLiukdvDVVC+
         RtOKJhCVRzZN0LI527S5bJJdaTAtappppU4fvUXJYDUTfn1uIy3wHnNlIwrGstwyMQnI
         6TohGOIrnZGHBYa54o86EbIMRnWxejz6ik2J19eY/CEVjaGTCegV7W4NeoeLQRzoOLkV
         tTOxTzBTsVmTZJ8c9/ZUzs4dZIrh5sh5/Rml8fmGdH5j4S4g/e8CNJfNmghezcJtAAfX
         wm5crpspbOasI0mjAO+p0d0UfGYvwE6gs8aj0GRHKffgRrVSYrS1yzgQwbIGSjBBP8+A
         5DyA==
X-Forwarded-Encrypted: i=1; AKwUvBxYnwyVHaXFFkpmjypsyTpy/VRX02qFJPtCECUMybW9vKfCWGaiUMRh3X08Z+P552wqrWpTxeYfsQ==@kvack.org
X-Gm-Message-State: APuU4Z/uLcpJNSBqSse6jPikcCmov+8Xv6vmzoAVXtz5RjwrBpQdxD4f
	xt1Z6th5EWGeeCyeMFGgupc8euiqNT6JEATzBaGWduFpZMFmd87Ua+za/4MRSuMFyV0cI5eX3xm
	olGCZwJa6EA==
X-Received: from dlea11-n1.prod.google.com ([2002:a05:701b:420b:10b0:1a8:14f9:6e3a])
 (user=nhuhuan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:1711:b0:1ae:59d6:91d7
 with SMTP id a92af1059eb24-1ae59d6945fmr16251403c88.40.1793745110700; Tue, 03
 Nov 2026 14:31:50 -0800 (PST)
Date: Tue,  3 Nov 2026 14:30:23 -0800
In-Reply-To: <20261103223025.2482227-1-nhuhuan@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com> <20261103223025.2482227-1-nhuhuan@google.com>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
Message-ID: <20261103223025.2482227-2-nhuhuan@google.com>
Subject: [RFC PATCH v3 1/3] mm, x86: support copying a folio using
 non-temporal stores
From: Huan Nguyen <nhuhuan@google.com>
To: tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, trondmy@kernel.org, anna@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, jackmanb@google.com, 
	hannes@cmpxchg.org, shivankg@amd.com
Cc: rientjes@google.com, dave@stgolabs.net, nifan.cxl@gmail.com, 
	fvdl@google.com, jic23@kernel.org, rkodsara@amd.com, bharata@amd.com, 
	sj@kernel.org, weixugc@google.com, xuezhengchu@huawei.com, 
	yiannis@zptcorp.com, yiannis.nikolakop@gmail.com, 
	dimitrios.palyvos@zptcorp.com, alirad.malek@zptcorp.com, ryan.roberts@arm.com, 
	nhuhuan@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-nfs@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 6bnyk19aoa78bsk6yq8gtcp9rigeef7m
X-Rspamd-Queue-Id: 7419140009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793745112-30100
X-HE-Meta: U2FsdGVkX19OT/iYHxc3GYfu9hdgA64evcPX8VXaNWqRRXmpINoCKw+m7im2gcm4HmWAJeda2QNKCd6s0VrmbCu4lsHvwJC3ZOYdVn5y8velOXDvrsQYPxsk1CTV5ak5Sz+jtdxKST/9nTGMV+LVtnTbUpI/OYA6IRRA/x9idVB4yq9N4jcRK0I6YV1LiDBUPHyHcgVEjbw/29hcMYqqYLRldY7/tsEjC6jUaN6ZfamTLiQuAaEgsRbZu/+SBi54lgEsj2q2xzXPcZUFpslzA1rRngvL6ljOU0G07NSm1e82jmQDs/ASLfJPvQ01ica+riBW7XlWblk0Fukg62pzt7z4PZoxEu7+HZ1C2QdFQzIYusD9I3c/1UfsZ7IpogWROfJxyCFXAB3oxobIMaP6lzPuAzIjZYFKFOGoVReqLcXVTa9Rj8BoxQM1CRZKCp38o1WdAF/tMc1yP8v7h62lxJCuTwJZ3H0fDzKN3+c6WOo+Ykc0WYZACCmhctbGsdpaPJ5KK/R1g346Lofn+oBmhMF/HZHQUgOYpwE3w9zgmF+WjppD8Z3x98zd2wYAwESW+JG+4/FPsoLlJRkiOEpDXj2bfHI5jum4IsvBBGkgQZ9q/gJ4eUVgrjtPhW6VsR0crhIxevD18UB2RmqgwhGt/+0PY2DzEI0t47lbDkzuxt8r9djOmMgAAAJQARkFk+nxrFbwM56hm2+WOzvl0jpyr7ASvfKt+I0sKBJcuT9l7BWAQvsdTkYquhGx4lsTo+7yKgqCFBGhnflLbBrC55n+lxr5wMrgKc1GtBobwJi77ht0JNBlVmNTt3qhwy6LuvxSsjGZ6MupFd40tfKfUGl0QZ9RoU8YONlNIaMyFLvKjzfcz5W/Mlg8/3Bpyc732tHzafJx9isaYecn5kZB53iZpjKERmExpV4MZ9AMuNUR68+X128v+kN9+CIlybNkfmdzTDUZrdUA+6M6DnHhQ8v
 HB3JfweQ
 DsOMYgTzA0ZjBwJLikaRvY8oK5Y6nvlxwzkSz7hmCLx8vy0sVqpSBl1tYNl4C4hkSshUT2cAkEASOO7VSa9+bwNNC5x3JqkHKcXPAuc76/AVVH+A32xl4ynbWMPnVOLh+Xi+5gjokSaIXnf+MJDt2mEF4Z6GdWwjZ9bb6/TqsRdascm84SoA1Ki74ZbKI9O4FOLEPQc7RlOh/1yVEfa+fm2qxGi+ykcJ7CfOh3bypyvPpbkv9oloRcrPsJ/6Y0cp3Di6eRAwK3rNr2eDXpLslaymwqPJxNQsjuYD0KFbPJK+7FchLvhfV7eDv6MjlfKhS09XiySV0dSNbMoJzQe+c2Y23px3XgKRFjuwMe/osNfS0XZHzNLqIy1W23cpQIS3DxFbM57P0gduIT7d0EYjygnq6KQFUCD2Ort19I6MhJXKcW1pSy/sGi3PNKpRBBJ3pkd2UO8SCqUlwekF7Xh3DYyisyyS8hVgPmw6IvTzYrYl7L+xzEc0fp/5eET9aXeklDTaT6S2Oc2RKwpQcLa/quK2wujWJNR9gQ/BOlAkOHQAATC1kPrFXiVK4vsFGK3ZDBrOpxMLk2YPBYBKjahyTl0cxm9wnIYuAqoemFLiTt98pyQovWtffOMCkHBO81tlaiFbJFuVOnGJPIHHnRPWbjGoTAYy1Itowh7aOOx6l5R+Ihqvt8hkjc7ne8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On x86_64 architecture, copying cold memory folios using standard store
instructions pollutes CPU caches with cold data, increasing memory
latency and bandwidth overhead.

Support machine-check safe non-temporal copying of folios:
- Add copy_mc_page_nt() to copy a 4KiB page using non-temporal stores,
  prefetching, and MCE exception handling.
- Add copy_mc_highpage_nt() to map and copy a 4KiB page.
- Add folio_mc_copy_nt() to copy a folio using copy_mc_highpage_nt().

Because non-temporal stores are weakly ordered, a wmb() is issued at the
end of folio_mc_copy_nt() before page tables are updated to ensure the
new folio contents are globally visible. In the event of task preemption
and CPU migration mid-folio, the scheduler's locked instructions on the
departing CPU serialize and drain earlier stores, while the final wmb()
covers the remainder on the new CPU.

Suggested-by: Alirad Malek <alirad.malek@zptcorp.com>
Suggested-by: Dimitrios Palyvos-Giannas <dimitrios.palyvos@zptcorp.com>
Signed-off-by: Huan Nguyen <nhuhuan@google.com>
---
 arch/x86/include/asm/page_64.h |  2 ++
 arch/x86/lib/copy_page_64.S    | 65 ++++++++++++++++++++++++++++++++++
 include/linux/highmem.h        | 21 +++++++++++
 include/linux/mm.h             |  1 +
 mm/util.c                      | 29 +++++++++++++++
 5 files changed, 118 insertions(+)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 1895c207f629..f37126b56239 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -114,7 +114,9 @@ static inline void clear_page(void *addr)
 	clear_pages(addr, 1);
 }
 
+#define __HAVE_ARCH_COPY_PAGE_NT 1
 void copy_page(void *to, void *from);
+unsigned long copy_mc_page_nt(void *to, const void *from);
 KCFI_REFERENCE(copy_page);
 
 /*
diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
index d8e87fedc20d..185fa3bc34c0 100644
--- a/arch/x86/lib/copy_page_64.S
+++ b/arch/x86/lib/copy_page_64.S
@@ -6,6 +6,7 @@
 #include <linux/cfi_types.h>
 #include <asm/cpufeatures.h>
 #include <asm/alternative.h>
+#include <asm/asm.h>
 
 /*
  * Some CPUs run faster using the string copy instructions (sane microcode).
@@ -88,3 +89,67 @@ SYM_FUNC_START_LOCAL(copy_page_regs)
 	addq	$2*8, %rsp
 	RET
 SYM_FUNC_END(copy_page_regs)
+
+/*
+ * Copy an entire 4KB page using non-temporal stores (movnti).
+ * Returns 0 on success, or number of bytes not copied on error.
+ */
+SYM_TYPED_FUNC_START(copy_mc_page_nt)
+	subq	$2*8, %rsp
+	movq	%rbx, (%rsp)
+	movq	%r12, 1*8(%rsp)
+
+	xorl	%eax, %eax
+	.p2align 4,,10
+	.p2align 3
+
+.L_nt0:	movq	0x8*0(%rsi,%rax), %rdx
+.L_nt1:	movq	0x8*1(%rsi,%rax), %rcx
+.L_nt2:	movq	0x8*2(%rsi,%rax), %rbx
+.L_nt3:	movq	0x8*3(%rsi,%rax), %r8
+.L_nt4:	movq	0x8*4(%rsi,%rax), %r9
+.L_nt5:	movq	0x8*5(%rsi,%rax), %r10
+.L_nt6:	movq	0x8*6(%rsi,%rax), %r11
+.L_nt7:	movq	0x8*7(%rsi,%rax), %r12
+
+	prefetchnta 5*64(%rsi,%rax)
+
+	movnti	%rdx, 0x8*0(%rdi,%rax)
+	movnti	%rcx, 0x8*1(%rdi,%rax)
+	movnti	%rbx, 0x8*2(%rdi,%rax)
+	movnti	%r8,  0x8*3(%rdi,%rax)
+	movnti	%r9,  0x8*4(%rdi,%rax)
+	movnti	%r10, 0x8*5(%rdi,%rax)
+	movnti	%r11, 0x8*6(%rdi,%rax)
+	movnti	%r12, 0x8*7(%rdi,%rax)
+
+	addq	$64, %rax
+	cmpq	$4096, %rax
+	jne	.L_nt0
+
+	movq	(%rsp), %rbx
+	movq	1*8(%rsp), %r12
+	addq	$2*8, %rsp
+	xorl	%eax, %eax
+	RET
+
+.E_nt:
+	negl	%eax
+	addl	$4096, %eax
+	sfence
+	movq	(%rsp), %rbx
+	movq	1*8(%rsp), %r12
+	addq	$2*8, %rsp
+	RET
+
+	_ASM_EXTABLE_TYPE(.L_nt0, .E_nt, EX_TYPE_DEFAULT_MCE_SAFE)
+	_ASM_EXTABLE_TYPE(.L_nt1, .E_nt, EX_TYPE_DEFAULT_MCE_SAFE)
+	_ASM_EXTABLE_TYPE(.L_nt2, .E_nt, EX_TYPE_DEFAULT_MCE_SAFE)
+	_ASM_EXTABLE_TYPE(.L_nt3, .E_nt, EX_TYPE_DEFAULT_MCE_SAFE)
+	_ASM_EXTABLE_TYPE(.L_nt4, .E_nt, EX_TYPE_DEFAULT_MCE_SAFE)
+	_ASM_EXTABLE_TYPE(.L_nt5, .E_nt, EX_TYPE_DEFAULT_MCE_SAFE)
+	_ASM_EXTABLE_TYPE(.L_nt6, .E_nt, EX_TYPE_DEFAULT_MCE_SAFE)
+	_ASM_EXTABLE_TYPE(.L_nt7, .E_nt, EX_TYPE_DEFAULT_MCE_SAFE)
+
+SYM_FUNC_END(copy_mc_page_nt)
+EXPORT_SYMBOL_GPL(copy_mc_page_nt)
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index d7aac9de1c8a..264b3f109151 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -484,6 +484,27 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
 }
 #endif
 
+#ifdef __HAVE_ARCH_COPY_PAGE_NT
+static inline int copy_mc_highpage_nt(struct page *to, struct page *from)
+{
+	unsigned long ret;
+	char *vfrom, *vto;
+
+	vfrom = kmap_local_page(from);
+	vto = kmap_local_page(to);
+	ret = copy_mc_page_nt(vto, vfrom);
+	if (!ret)
+		kmsan_copy_page_meta(to, from);
+	kunmap_local(vto);
+	kunmap_local(vfrom);
+
+	if (ret)
+		memory_failure_queue(page_to_pfn(from), 0);
+
+	return ret;
+}
+#endif
+
 static inline void memcpy_page(struct page *dst_page, size_t dst_off,
 			       struct page *src_page, size_t src_off,
 			       size_t len)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9f167950926a..549bb21027e4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2127,6 +2127,7 @@ void __folio_put(struct folio *folio);
 void split_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
 int folio_mc_copy(struct folio *dst, struct folio *src);
+int folio_mc_copy_nt(struct folio *dst, struct folio *src);
 
 unsigned long nr_free_buffer_pages(void);
 
diff --git a/mm/util.c b/mm/util.c
index 8acfe2148ba5..0418529264fd 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -778,6 +778,35 @@ int folio_mc_copy(struct folio *dst, struct folio *src)
 }
 EXPORT_SYMBOL(folio_mc_copy);
 
+int folio_mc_copy_nt(struct folio *dst, struct folio *src)
+{
+	long nr = folio_nr_pages(src);
+	long i = 0;
+
+	for (;;) {
+#ifdef __HAVE_ARCH_COPY_PAGE_NT
+		if (copy_mc_highpage_nt(folio_page(dst, i), folio_page(src, i)))
+			return -EHWPOISON;
+#else
+		if (copy_mc_highpage(folio_page(dst, i), folio_page(src, i)))
+			return -EHWPOISON;
+#endif
+		if (++i == nr)
+			break;
+		cond_resched();
+	}
+
+#ifdef __HAVE_ARCH_COPY_PAGE_NT
+	/*
+	 * Drain weakly ordered non-temporal stores before the folio
+	 * is published.
+	 */
+	wmb();
+#endif
+	return 0;
+}
+EXPORT_SYMBOL(folio_mc_copy_nt);
+
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 static int sysctl_overcommit_ratio __read_mostly = 50;
 static unsigned long sysctl_overcommit_kbytes __read_mostly;
-- 
2.56.0.398.g882cbad275-goog


