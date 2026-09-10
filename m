Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75AC4C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF1836B00AF; Thu, 10 Sep 2026 19:55:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E023F6B00B0; Thu, 10 Sep 2026 19:55:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91DF6B00B3; Thu, 10 Sep 2026 19:55:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB146B00AE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6CF5A1C28A1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
X-FDA: 85199512440.08.E12D1D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 679AB20003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="O7P/JVmN";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084538;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wc8pPU8mZNNTGCuMBEoR7A+PiAi9QuMnVW3knoVU1p0=;
	b=Lnuwu9KAo6zjqf0ayX+1317xTlWmMU0Q0TV105id3Xp4HMr1Whvo5DaRxsnB1oj3IKR2d3
	ltOJzBk/u5hov49PrwTZ37r/BMlrFnfB0mVlzvM9bXW3HsrhI9UodJfCPQ/HKzJlUyQELF
	jKBID7xzr2TBd3HbApvrBiMlmGN89iY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084538;
	b=w/JLXOgqlMN3QoyKd5k5OysD82NfN0bp/T/M7gy+6y2tIDIZArYn6upBp/hRCzOi01SMw8
	j6XZkRHmUXr3ci9mhZts1xuJTf8taMUzx1nmSKcBeZrFCUdcRPmr8hpVlhgVheGZm9SCrf
	vKekhm4wkQekv5ZMY6+8y1YU2CvV5b0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="O7P/JVmN";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D03443FD8;
	Thu, 10 Sep 2026 23:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 951B6C2BCFD;
	Thu, 10 Sep 2026 23:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084536;
	bh=Kemej0jCw7h7ikYa35Qx9+U1O1Ro3V7ZhJlVculzUsU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=O7P/JVmNLI1EnSEz6RH5llteFY1N0sqCt052QXTIH3HbEiyHGVNP/Aj9g26JJMdoP
	 xoyb7fN7h6GUpLDE9bRzpyopk9lXNYmVDHnSsjx1LUWuErnWxoaIehRjwPgWqo4Ksn
	 KwO1QIg5OkGoW1/Hg/7A7+TSkU35IuI+h+2tmcjFdslMtg654lQpApP7wPmDL6Mzde
	 BkRS781mYl0heuRUt7oAo2EfsvVcdpRPYb/FrkMi8gO6U1lTlVUE1KuglEIQ6JBDr1
	 swVKYWP+RGNWQe4eb5k7QtDn8tPtxjgAEcPB6ky83r0no8X23bunc1hRpH+RjZbSdp
	 ogzBhEhO5bpyQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F56C79FBB;
	Thu, 10 Sep 2026 23:55:36 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:27 -0700
Subject: [PATCH v13 01/44] KVM: guest_memfd: Optimize away conversion
 overheads via dead-code elimination
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-1-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=3368;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=jdeuN8QAludHAg4pQOQtYLnhlGiFogxOH8nIW0ZEBXU=;
 b=sww7etsIuwKRvcfuD8DJ8EQ6FFI8MsNcKxp95SrzPjrCWGonLp4p47TacW9Do8Uk33c+xvNLV
 eZ8ISUk5/WfAr0WBMyA/jilQOtj6AdalhDVD7M/1i+snixje8pJKuVS
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 679AB20003
X-Stat-Signature: wdjx6wwjh8qm5xnrs8q11ot1yq9gtyos
X-HE-Tag: 1789084538-907139
X-HE-Meta: U2FsdGVkX1+FpWrcHqWk6hgblAaQ3ydOlodksrvI7/SIryfSgwKtd1+vlfmU2D7eUAgSsFw9azaj+i71MmKUmLnc1cR+zovt/lRLWssV05LFRymheI+YOB0uLj+CFwnE14WA3DOaC51zf/WL44/XN9iSGjoVqml9uPWo/MHzlX8wTfTJIzCb07NCUTqy2CgTnX5b50+5eG9oilc0NyGH+5qwgGLr/qwFeOa5LXhq9Lh5cwfA8mbT199yrzl9sS0VZN3jG4nfwsNNjEXEbUmmIzz/maMhPev+DwsKbki94W4o9MAGXMjZmQcBOQkOdXRLXoLmllpKD6bxejpXFU6lchxUvR4lXUCy9X8ouioL9qW0kCilwUhVLwDytp78JvHtOzQ3IcP4qV96FAjb6cFeqG9Q8j6vt4tzt3dlMytjlBn5GxwI5keR4QefZsicPgtemts6dmxm0iQiYhOCU7YDWTvfyNfqEktFc/5dvdSzNAPL/wVZ+gT5bEKPgebg2Uh42SY1LdYFn2Mqzbnn3NDiCF6p22ZHUy6R5wSiyoTyD58uf3gRT8BnwXbAwx9IWKvq4lEzHFifkjigp2jnrMmQkLJUs04U5LnKabzZYQUD3tsxW2Mel2dtYAC0/wPkBOAh3u+7s082QnuND/bp2BX6seBy33JjwEU+hszHMxTq8xfQYkcMJXDA6Vp/4MImZDqL2hqzL1b4BTEXPDN6V2XFmCSPahIU2oin/RVY48Wco4lgH5P/MlUCOTJ90tkmkPeGQJE06gL6Rfe+w4VjOiOUbqi8RyON4Xc3DHr+frcDOJ2ipXu0bStq0Cy2Xq7rFPbc3w8PINKv/WGHlAA9kifj9eGcg8Au136zVEwnDfC7lraOQXqL5jGzzm+lKKFmZLjqTZtsoyD381D/MhuAIElciRdjDQ+aVTg4oqHYo+Thmii6TjIeafYbdnopsznO2qi+TdUk+0jrcUmaTXYRefP
 rXwEIARP
 VABTZPfQFmz9o+l7auShcUL4lm9dveilJ4xTdmt3OXLKyzVPDSq5zDvr668KLsQUi0xVrksfh7+3AVzupEx4oYmtJbPyU5uK19Ho7OveUBf3Wzp9uTmnhbhfsC4Mx8lSbABqQnsfF2x1ev8wJt+hna+1Aq9xQ6dt2zedlF3gFo5TzwPwKZaZnDP+FdAMds180fuDCzdPP5//6kPCOBxpMpRAR/NlcLVGHlNlASRm5xLe2FdJl3lzgrjVzbW16GSp7+OS+suYPQEbZ7V93vXH3Ut1igj+TMznmsReninM7gW/tuc9Jis+Yc+W911MTPP9t667/cbiXDSFzjQgCgNBN13aIcxTdwYBVq8jxmqVDFVk9X0RMr3Xrnyxd921pfYUhzi+mdwkDg7eiqGy8G+T6ETL4UOzHuBUqaYJsqaWNp2QzeuOfRi7eC8RlTtSTWjpyVqret2ZHbRwdTSe+dXgLhXYjJt2nPmQfcjcTAcsvBZdhZkhKi8SN20+ATNbPnbDsFyLB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Add and use kvm_arch_has_gmem_convert() to guard guest_memfd's invocation
of arch hooks related to converting memory between private and shared, as
only one half of the x86 CoCo duo needs the runtime hooks (any pre-work is
pure overhead for TDX).  At this exact moment, the overhead is negligible,
but that will change when in-place conversion comes along, at which point
to-shared conversions will "need" to find all affected folios prior to
calling into arch code.  In quotes because very technically that work could
be pushed to arch code, but that would bleed guest_memfd details into arch
code and would be far worse than adding yet another kvm_arch_has... hook.

Opportunistically provide the kvm_arch_gmem_make_private() declaration, and
rely on dead-code elimination to eliminate the call to non-existent code
when CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT=n.

Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
Closes: https://lore.kernel.org/all/1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com
Suggested-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/x86/include/asm/kvm_host.h | 3 +++
 include/linux/kvm_host.h        | 3 ++-
 virt/kvm/guest_memfd.c          | 5 ++---
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 683bb8bf43a94..6beddd8a0c749 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1854,6 +1854,9 @@ enum kvm_intr_type {
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #endif
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+#define kvm_arch_has_gmem_convert() (!!kvm_x86_ops.gmem_make_private)
+#endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 502465119ca0c..b7516e19ef419 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2597,9 +2597,10 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_GUEST_MEMFD */
 
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 			       kvm_pfn_t nr_pages);
+#ifndef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+#define kvm_arch_has_gmem_convert() false
 #endif
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 798d91df69537..2190e4d6b6bea 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -772,11 +772,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_mark_uptodate(folio);
 	}
 
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
-	if (kvm_gmem_is_private_mem(file_inode(file), index))
+	if (kvm_arch_has_gmem_convert() &&
+	    kvm_gmem_is_private_mem(file_inode(file), index))
 		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
 					       (kvm_pfn_t)1 << *max_order);
-#endif
 
 	folio_unlock(folio);
 	folio_put(folio);

-- 
2.55.0.1007.g17ff1f9808-goog



