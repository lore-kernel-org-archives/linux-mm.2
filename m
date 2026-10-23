Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6184606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 20:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=lwn.net header.i=@lwn.net header.a=rsa-sha256 header.s=20201203 header.b=VWy0WdGa
Received: by kanga.kvack.org (Postfix)
	id BD5F36B03F0; Fri, 23 Oct 2026 16:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86AF6B03F1; Fri, 23 Oct 2026 16:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9C1D6B03F2; Fri, 23 Oct 2026 16:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 818BA6B03F0
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:21:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E436A160228
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:21:22 +0000 (UTC)
X-FDA: 85355010804.28.C679D07
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf25.hostedemail.com (Postfix) with ESMTP id 51118A0003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:21:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=VWy0WdGa;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf25.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792786881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KiicLmvcEJTvj4IUoFShe1zCkXcPbAaG1PST3Sy3hOY=;
	b=SmzyKA7jSkaHIVoCOfbwu1ah0DVhtQbytUCvDnCHIU1Ds2GlrX4EMupz7jB3EtFDSqBiI5
	/IGGFu0nuUcFPAQf6nLsAymnSczxo6ORivBOCFn1mO+M6N4UMnL9ykeb01Uo2/MkqHAej+
	g6THchUTL0Rh2sUc0guubLkUzWWpS7E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=VWy0WdGa;
	dmarc=pass (policy=none) header.from=lwn.net;
	spf=pass (imf25.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792786881;
	b=VPw498j1VEnNCF7Z71SpMOYDWCLeHaE/EH3072MwWpGvz8dYFadP3DBV9r8AZ4WDSEPjw0
	T+raR2QSpnL3msLKEKwC1QFuy0+tfxCFRUp2DE7QkJgmeTAIQzIQl/eyXuwWYC1jciMmDt
	BaJJ33kpLeVj4BSzq0M/7Aed5kKGcGw=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net A6E5F40915
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1792786879; bh=KiicLmvcEJTvj4IUoFShe1zCkXcPbAaG1PST3Sy3hOY=;
	h=From:To:Cc:Subject:Date:From;
	b=VWy0WdGaMI6K/kRrPLKn78UmBR8zOSjJwB8vv9MWdZGXjlfLNvRlrf7SD7dU7XBLN
	 RCTWtUjoMokps474J2EvS+ElcKfubghxKiKPjE+hqlUco1ptsyAo4E/9YHa2KTzWNK
	 DXK/m2NCS3L3BTfhXvJ7orczYvGPiaRua9S22FoNNcfMSfqvPUikx5quvHIxXom9un
	 52dfk1OJySJyvqUMBb/EZXOD3vYdZCnnSEyFEsetmwKe4i5RnRiIbTO4J51KZ13i87
	 XC8Unn58azGD2CAmBAoj/nPpgkHeCl4ar4tdv+H7uz2LQCJo3jH9Raeck50/oFAm8P
	 0wuhMjQG8NigQ==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id A6E5F40915;
	Fri, 23 Oct 2026 20:21:19 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] uaccess: fix some erroneous kerneldoc comments
Date: Fri, 23 Oct 2026 14:21:18 -0600
Message-ID: <87se1ww4ld.fsf@trenco.lwn.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 51118A0003
X-Stat-Signature: 5di4uwr4tc37ukct7s7bemjfyxfirk7q
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792786881-86407
X-HE-Meta: U2FsdGVkX1/5Y6ntQCdpxkgelAneZ+3/aIkQRiERLnPvb/iFjNp1dUheGtw6biHoJ0SRWYCN1gJzxQBd0nqdyWtYUR5QYyidkLxOsvzcu70zowTJcCKBeNs2b14yQ74EFv8Fc+EvUF6u4+sIQndrVLrW/zs7eeNXiQD1LSKXRXG8Sf5DSCmy0wDf4Sk881dtNWC+zUvsOqg6Zh9ScdHYihvW7WbWgcIPqIoRjhu9IP7U4N3agvrrDD1gzGbaEmb1cXuCL5IZ+VRnb8glDmdeRRzm//qJXKlyzmThoFz+Y4FA/l4woocyOW3BEObM9xEtxJP5iNBfW0RI8/oIjD44/74hfgzTCVG/FwEa5tNodRcOsOepvxbdzXXgIxSz5KPvaO5jYdE/FP/7v+PozJFQY2P7i7QslC5KOOnuSO6JR7JhvnUdkfzxcQhIzd3euoAK8ZM7DhsnComONUCc7y04ireh+SknIkhhcGSF8DPJUD4ofOE8XSIowFtOJ9/+6HoA5zzKO28kWKVTvAUCzNOM9Ih5sGca68QvH3LwzMAxi2xZqLiS9kUNzmhxtjkK8inknytQcl7bKt3zT22jnpoVifigxoSukngHuzr3tfsm0mqR+AypmR2zcIhihwmeBFZ9LfoO+GfX5Sgq2FoqrsUmJFZcYevpuIAUStTBgZssgMEVwceagwJF88ds50IuvlG5bHDn+JiQUukr7p4BsYaYoHirP+lM4cSv6pIDnyfIU31gxLtrUeZBIwHwDIMaWqQcByOR4fYjgJ+FDgOawxR/dynhCjXi5Qq1GTO1mJwY1L3lIqmh4u1yd/HfnlQh9/smapoGxdtaHwUT3QypoIJheWhMy+j9y2GyQF3lEFtRGly2QR/mBnCMtzscNoUL2vTVwzb3xHbIPgHE1CfHNvwwTDlhwGU52ilJ8ZyckIKqZi9Xo+MevYp/7D1/FmgiSr45im/pFLopbxYQwLlFGIJ
 J3RicPoO
 7GECUdNafknj/7O2xwcCJipAIFMGZzkps1SHCJelIQVn/7GUNXszicIDxh6yGi6JlrMaEUVPgkzzENR5xHgf5AglpVAEG29lbgZsp2g5IeyfGKSZdYgUGaD/DWZdd2RCEk5MwtF7EZ77qL073+83xEwHZB3ObQ0rupIiYST1W11sZHNz4dR3uuHvIayh579+8lhv7vw2RW75rlMZJ0X5wH3ax73dNKQkIGqUlrEObhfjpxugvtnyyyaUVhVReNIM5mEPxaRBFmAoQ5jJ78SLmuwJ5zpjVxkWB2o9mIiiJVWwPojXUwBmx3dDrfVZNgQyxW9y5AGbM6cv0aEr+anRO2f4WNjIGfukGMUXnZGUeYFGCXKpH39YfyfJMPwg8UoAW0oz7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Several of the comments in include/linux/uaccess.h generate kerneldoc
warnings due to the use of "/**" markers on non-kerneldoc comments and
unmarked literal blocks.  Bring these digressions into form and eliminate a
number of docs-build warnings.  No changes to code or documentation
content.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
Naturally bringing this file into the docs build turned up some
warnings; this fixes them.  Happy to ship it with my other patch or let
it go through -mm, whatever works.

 include/linux/uaccess.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index eddbbb65ccc4..67cdb0a4f583 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -357,7 +357,7 @@ extern __must_check int check_zeroed_user(const void __user *from, size_t size);
  * struct).
  *
  * @ksize is just sizeof(*dst), and @usize should've been passed by userspace.
- * The recommended usage is something like the following:
+ * The recommended usage is something like the following::
  *
  *   SYSCALL_DEFINE2(foobar, const struct foo __user *, uarg, size_t, usize)
  *   {
@@ -447,7 +447,7 @@ copy_struct_from_user(void *dst, size_t ksize, const void __user *src,
  * about data it does not.
  *
  * @ksize is just sizeof(*src), and @usize should've been passed by userspace.
- * The recommended usage is something like the following:
+ * The recommended usage is something like the following::
  *
  *   SYSCALL_DEFINE2(foobar, struct foo __user *, uarg, size_t, usize)
  *   {
@@ -529,7 +529,7 @@ __copy_struct_generic_bounce_buffer(void *dst, size_t dstsize,
 	memcpy(dst, src, size);
 }
 
-/**
+/*
  * This is like copy_struct_from_user(), but the
  * src buffer was already copied into a kernel
  * bounce buffer, so it will never return -EFAULT.
@@ -553,7 +553,7 @@ copy_struct_from_bounce_buffer(void *dst, size_t dstsize,
 	return 0;
 }
 
-/**
+/*
  * This is like copy_struct_to_user(), but the
  * dst buffer is a kernel bounce buffer instead
  * of a direct userspace buffer, so it will never return -EFAULT.
@@ -770,7 +770,7 @@ static __always_inline void __scoped_user_rw_access_end(const void *p)
  * If the user access function inside the scope requires a fault label, it
  * can use @elbl or a different label outside the scope, which requires
  * that user access which is implemented with ASM GOTO has been properly
- * wrapped. See unsafe_get_user() for reference.
+ * wrapped. See unsafe_get_user() for reference::
  *
  *	scoped_user_rw_access(ptr, efault) {
  *		unsafe_get_user(rval, &ptr->rval, efault);
-- 
2.55.0


