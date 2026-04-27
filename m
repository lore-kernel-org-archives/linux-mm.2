Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34856FF886D
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 17:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FA986B0092; Mon, 27 Apr 2026 13:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2316B0093; Mon, 27 Apr 2026 13:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2B16B0095; Mon, 27 Apr 2026 13:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2786B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:17:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A3FC140186
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:17:16 +0000 (UTC)
X-FDA: 84704991672.22.DFD7645
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1328EC0017
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:17:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ccnzw+ca;
	spf=pass (imf28.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777310234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPNbmpE378SDR0albN3uUkse5xd3MAMC7j8Z5wC8tqY=;
	b=Tcf5qHICxwA3Ub9tDjDQp/HnXU1JC56zqJWWpq5Mwr/Xg63PUd8e+FIcbfRxyMcp21ZYM0
	T8xuxAiMZiZsKgRDbAcH04EPhib9Yf8RZXuhTbuoYvaKD8UdRcHhM3NYgqwzB5YGuNh5Tr
	8PbENowDXx/RbuNNSxbwoi+gN6zlNrg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ccnzw+ca;
	spf=pass (imf28.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777310234; a=rsa-sha256;
	cv=none;
	b=FEiIIcDX96yYVXRjd/j6a3hp/svvLzVMJKClQP8s3LjmuUaslK0VPArwHsoxQDv4c9GMAi
	VofQ+mICurYwbE2tUdocHi2zPwZ5JcCNRmdbKuMfV+HqjP/CjxNeQJb5D85mFd0HN2XLOZ
	VdmICk3/4rHA3RDRxpX/OH1DdPdIRPQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12679437DE;
	Mon, 27 Apr 2026 17:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC974C2BCB5;
	Mon, 27 Apr 2026 17:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777310232;
	bh=745VKRe61Lf8afs4o89V2mPmcfGcqMzEwAyCkwUFzR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccnzw+capg6i/qeCJEEZZnJkaeh2P8NEABjGdQ84B8/8ElHQuhaIfwHK4KyIZjuzW
	 fShA2udW2NQ0Ct7kJfcn/Kb043ljqkq7hTjPsRqwiNPGH9FmgvMogRNjEATWGrG26g
	 6zW5qtX0OAMj+t+S60HkjDsyGYMrisyc3m/7o9VPvVvQnsaPOrT5y+ZTzyh8Xto7fx
	 AWFGU9d3c0Mo3tNoddRUR02dQmZ5LMWSNNkmTWtszo39IueJ4zsAp4+3T5NcIhGntz
	 oVxgjUbjxhRTuJF8KweLMZaWvhi+rfu1/RR3XrUIQOPEazAae4t8SpoXJ0czDjJbhT
	 7qOjNG8l7cqnA==
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
To: Yury Norov <ynorov@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	dmaengine@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-fsi@lists.ozlabs.org,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-wpan@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-staging@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	bpf@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-x25@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-sound@vger.kernel.org,
	sound-open-firmware@alsa-project.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [RFC PATCH v1 1/9] uaccess: Split check_zeroed_user() out of usercopy.c
Date: Mon, 27 Apr 2026 19:13:42 +0200
Message-ID: <a6d39afb167871e0459946dfd6b28bc994ae3c81.1777306795.git.chleroy@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1777306795.git.chleroy@kernel.org>
References: <cover.1777306795.git.chleroy@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4389; i=chleroy@kernel.org; h=from:subject:message-id; bh=745VKRe61Lf8afs4o89V2mPmcfGcqMzEwAyCkwUFzR4=; b=owGbwMvMwCV2d0KB2p7V54MZT6slMWS+nxmtvkzq83WmyICs092/GNmylHyYwx1uy/R0rjqso Tc19NiJjlIWBjEuBlkxRZbj/7l3zej6kpo/dZc+zBxWJpAhDFycAjCRrBxGhr1T21lnr9ow8bLw mlcX9LlDfR53LmTbs/fCv2dGAh23RTkY/gpGWFpU+sbMuNm2suHwI9OT2xZsfrLc1dbD4+idxHd 72DkA
X-Developer-Key: i=chleroy@kernel.org; a=openpgp; fpr=10FFE6F8B390DE17ACC2632368A92FEB01B8DD78
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1328EC0017
X-Stat-Signature: 46n59eyhcd5iuryesfmrkosag17yo7ng
X-HE-Tag: 1777310233-606233
X-HE-Meta: U2FsdGVkX1/QqRWJaBXcBjg7+cdrzNuywBpoiNiLdEufNzItfc/WmytTbgX5g+HyJYRWuUECnMZd6iYmDGOtiJXzPqTy8SAOCBRVcDGO7tZAc+scC0DK2Xo3B3H+/1xUaUyMW9krRWcNDh9PVXVx6+4kYiN8QgUGYJ6VaaUuksIS5nlkgsaTiXzuCCfIq2U93LRQosRROnDQJqL18bs4yuS2XWX1TdbdA9wlw+lUF7ABx1sM4Lul9ILXfKKEis6bfFbIJ0RBGK4IRw5CBxh45wjigYWKS/q3G0w90pix/gDUq/svyp/UfwUCQ/oiPhZfmLpIES2LR/ASOmdgiWUunaYI5F7DO4HhQHolmlqroiqnAKQ6lNtoiPR1rxUAita5KFbpfiylRtUsBhHNBY2jPN36EyjwlWj8fENCGQjqq7eBbpPYkVptZyOs5oY1GUU2N0jY10Q3RNrQUVpWHlnxDggoWvk59OUblXj7sbh1o00WwDGLHYC4G7K7Pwyf7mnGxKw9gZ43RY3j/SOQEW3yj7wtkSn91AbAq/olQZ9F+0RxpsPiXxNgVs5Tu618WPJxPMWlz/P6+5wefVWdAUwXCF5St/KhRTg5zBk1W8VwwVuaxsEK16OhnUxnZPAnUBVqA2E9Re7R5WN9yns36N6qqzNSIA3tBWvndwyu5qoDAqDt3ip1GtwpI4mPyF6vkF8CWWHzcDSdLPIWzmQ+W+H1Q7M2BXLpjDQuARvRwHjkgYz2KY5TrGWbG1p+5COJBvuXiCgfi1c8Hz+l+MI9ZDz9OXYrQFYUKL22AXxgMmrfo5lHeWemCtaoJrXwKsiiW4dyi4xUcxmVlLClq9QKZp1KkkmoEDjKpLdaFj1YaRzATbPPG3N0ycKbXVouPOBAi0l4yYhIqdXp3HBXq6aFNqPV97eGMIAUNos9b9wpbg/VuMW7+vTEU9Kkxq84qHfDEcX/tgPVKJGchtjhPBk4Mqc
 wCRnKASE
 MbPGEhUAS56FuPEPjm8phAqWS95atC+n2qliomZx23JDynqAi2rErffJQufLObV2l65TVKtMZt4qoaClkMT+36q8oS/aQyBNqJpRQueZhLZhwhGprSrefMH/5ABIYzD9H8xBTQQbase/dbBIe7ka238G7x1g6jEx74O5Wc7MSOhDA4ifjGA6tJAn5QxgA6Ozi5GSmEjSVm3feHfvWXQ+8oSgO2zEzWQvUP6ODczbKeUGvduB9kT4tpGAD43sxjEPw9QvpWutHrILZ0o0hOqoXV5ldsr4ckBLPB+1xtK0Zq3Uh20oM/HjgxP9pKKO0vWj8IP0uXNDMy2nuI6t5FfchOschdav7T0mJpSKxUG5AuY5Q2D/OaHSk2BR/weAOQyu9o+GU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Until commit f5a1a536fa14 ("lib: introduce copy_struct_from_user()
helper"), lib/usercopy.c was containing only the out-line version
of user copy fonctions.

That commit added function check_zeroed_user() into the same file.
Move that function into a new file named usercheck.c, so that next
patch can change usercopy.c build to a conditional build.

Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
---
 lib/Makefile                    |  1 +
 lib/{usercopy.c => usercheck.c} | 22 ------------
 lib/usercopy.c                  | 62 ---------------------------------
 3 files changed, 1 insertion(+), 84 deletions(-)
 copy lib/{usercopy.c => usercheck.c} (73%)

diff --git a/lib/Makefile b/lib/Makefile
index f33a24bf1c19..7c0334d7675b 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -59,6 +59,7 @@ obj-y += bcd.o sort.o parser.o debug_locks.o random32.o \
 	 percpu-refcount.o rhashtable.o base64.o \
 	 once.o refcount.o rcuref.o usercopy.o errseq.o bucket_locks.o \
 	 generic-radix-tree.o bitmap-str.o
+obj-y += usercheck.o
 obj-y += string_helpers.o
 obj-y += hexdump.o
 obj-$(CONFIG_TEST_HEXDUMP) += test_hexdump.o
diff --git a/lib/usercopy.c b/lib/usercheck.c
similarity index 73%
copy from lib/usercopy.c
copy to lib/usercheck.c
index b00a3a957de6..15b0d9a18435 100644
--- a/lib/usercopy.c
+++ b/lib/usercheck.c
@@ -2,32 +2,10 @@
 #include <linux/compiler.h>
 #include <linux/errno.h>
 #include <linux/export.h>
-#include <linux/fault-inject-usercopy.h>
-#include <linux/instrumented.h>
 #include <linux/kernel.h>
-#include <linux/nospec.h>
-#include <linux/string.h>
 #include <linux/uaccess.h>
 #include <linux/wordpart.h>
 
-/* out-of-line parts */
-
-#if !defined(INLINE_COPY_FROM_USER)
-unsigned long _copy_from_user(void *to, const void __user *from, unsigned long n)
-{
-	return _inline_copy_from_user(to, from, n);
-}
-EXPORT_SYMBOL(_copy_from_user);
-#endif
-
-#if !defined(INLINE_COPY_TO_USER)
-unsigned long _copy_to_user(void __user *to, const void *from, unsigned long n)
-{
-	return _inline_copy_to_user(to, from, n);
-}
-EXPORT_SYMBOL(_copy_to_user);
-#endif
-
 /**
  * check_zeroed_user: check if a userspace buffer only contains zero bytes
  * @from: Source address, in userspace.
diff --git a/lib/usercopy.c b/lib/usercopy.c
index b00a3a957de6..7a93f56d81dd 100644
--- a/lib/usercopy.c
+++ b/lib/usercopy.c
@@ -1,14 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/compiler.h>
-#include <linux/errno.h>
 #include <linux/export.h>
-#include <linux/fault-inject-usercopy.h>
-#include <linux/instrumented.h>
-#include <linux/kernel.h>
-#include <linux/nospec.h>
-#include <linux/string.h>
 #include <linux/uaccess.h>
-#include <linux/wordpart.h>
 
 /* out-of-line parts */
 
@@ -27,57 +19,3 @@ unsigned long _copy_to_user(void __user *to, const void *from, unsigned long n)
 }
 EXPORT_SYMBOL(_copy_to_user);
 #endif
-
-/**
- * check_zeroed_user: check if a userspace buffer only contains zero bytes
- * @from: Source address, in userspace.
- * @size: Size of buffer.
- *
- * This is effectively shorthand for "memchr_inv(from, 0, size) == NULL" for
- * userspace addresses (and is more efficient because we don't care where the
- * first non-zero byte is).
- *
- * Returns:
- *  * 0: There were non-zero bytes present in the buffer.
- *  * 1: The buffer was full of zero bytes.
- *  * -EFAULT: access to userspace failed.
- */
-int check_zeroed_user(const void __user *from, size_t size)
-{
-	unsigned long val;
-	uintptr_t align = (uintptr_t) from % sizeof(unsigned long);
-
-	if (unlikely(size == 0))
-		return 1;
-
-	from -= align;
-	size += align;
-
-	if (!user_read_access_begin(from, size))
-		return -EFAULT;
-
-	unsafe_get_user(val, (unsigned long __user *) from, err_fault);
-	if (align)
-		val &= ~aligned_byte_mask(align);
-
-	while (size > sizeof(unsigned long)) {
-		if (unlikely(val))
-			goto done;
-
-		from += sizeof(unsigned long);
-		size -= sizeof(unsigned long);
-
-		unsafe_get_user(val, (unsigned long __user *) from, err_fault);
-	}
-
-	if (size < sizeof(unsigned long))
-		val &= aligned_byte_mask(size);
-
-done:
-	user_read_access_end();
-	return (val == 0);
-err_fault:
-	user_read_access_end();
-	return -EFAULT;
-}
-EXPORT_SYMBOL(check_zeroed_user);
-- 
2.49.0


