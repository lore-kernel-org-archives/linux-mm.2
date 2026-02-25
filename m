Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C385FD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB3956B0088; Wed, 25 Feb 2026 18:31:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C61496B0089; Wed, 25 Feb 2026 18:31:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97F86B008A; Wed, 25 Feb 2026 18:31:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A83786B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:31:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 521BF86BB0
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:31:19 +0000 (UTC)
X-FDA: 84484577478.02.828152A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C2A93100009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:31:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hts5iko5;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772062277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TA1v5e8OD7JNHzwKUv2pYfZF5lX28NZvCATWMgeOf9w=;
	b=i08T5TzqTcdXlh/JU/0ZDER1o5mjyd6HtCG1Oz7FYB4sYOwyMhn+Z4GkI+it5+bDnay5qr
	hWNwi9zeQf45wzbNlDbhKoNs2YNOBGeq/zJ9X+WNLoyDjiSdv0xlZEl/zxuHAW5a8nyvqF
	067ibi612an9ymcFHbPhWoo6iz+ZHvY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772062277; a=rsa-sha256;
	cv=none;
	b=rQyVlccaANLF8shOH0M++0RwYcICM7MMbx3yXJNeitnM3x5a86gBtx3OOp7OI1xGZisHBn
	KcdMO2VCs8B0TUZ7Bw1XZGJkwor5clvceLVj/pePjENMG2N1DDzbDF+XkZetx7tFc79Lvs
	dzNNbK1AQA7SlKu2ERh4gG6Tv0wx1Dc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hts5iko5;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 11C3260053;
	Wed, 25 Feb 2026 23:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862D2C116D0;
	Wed, 25 Feb 2026 23:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772062276;
	bh=obkI1FVNxT6sa1JWz7SJNPJ5sUYJoL8uwfx+TuaNXco=;
	h=From:To:Cc:Subject:Date:From;
	b=Hts5iko5XDHdD4DxAUey78Ja5C7J5OkIO1eyaWzr62jF2EQdR3NDndztOAjzSzxiK
	 9MamRoetJp73z7YpLt3OLEWESwvnScOcQJGZykDUw0JdbQxyvgBJumGMYACw/VGSBD
	 7mHpBqfA63Tatx9cdq4igioBo8j2UpAI0vzp0SHtrniX4yFUohLeXIJF0BGrYbeiim
	 rmHlLM3OUl3M4FO3/0KIf5Ghm0qxCohR5B6lJ/hdpyEZTKheGMnFYRZ+z47JcNAX4g
	 w3APT633imujsByWHdI3F02g2ovvf8712ep4bzejIfpOnVmxC905piaLKFvMueNpcI
	 4wRNew0FMyfMQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] tools/testing: fix testing/vma and testing/radix-tree build
Date: Thu, 26 Feb 2026 01:31:11 +0200
Message-ID: <20260225233111.2760752-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xddu6y4nt5z1ipy3cfhxsuwjnfdztnde
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C2A93100009
X-HE-Tag: 1772062277-48809
X-HE-Meta: U2FsdGVkX1+RivRl48SkiewqMWOdXXtkv41Y6lUFwJFfsXaWgjgdP/g2r5lxzVHLIJ78bUsJOend6bdrzE3ERgYrMQ5mpQP803Cq+bJq1ZahSO/0bSB6jOeMDb1v+SI0IY23ERQ9EV6SghsGC0Zw1TpeuVlC22Mpa01IDeeuzlLLvRmeCgrvZ7V/rLTMeuFqK1/mYqGj5+qQFyTb2xLSJPV0jzh3YiJx1A8m126fiViXL6VR3Ttf58A+X367hDWrursbON0QBAke5IJIqboik/Ow3ZrpkMvwroZAAvtmnitOlHkYr6ktvBcgd8805NnVmrv7tmtSMMMijY9xttY+iRqVvBpeeeXyNQwUectP8H2xJV7fNUFsJjHJ3oJagubxxP/H+EAEkE8lK8iUuU+K4hnRkKknGfEMq4AC9IXruyz6DDICdl+wSDHwPbepMTeP8Pp+oL3tlNNchkJzImwOvJIPm7lRvdD/iBqWWLIk8QMO2VKoN+KEtmjFw81czLUOpQRScHhC5ZLncwK7FBBoaOnc4LNO/9j+h9fN1QYEcck96/XFdh/RtbUR2DdddpRD/JgIk2TWVjly5L++pJ+gM4fr8K6FA5nIJvg1rXH2D7ZmBWEAy+6Gso3b/MdAQU1Jvidvv5yB3x5Kc56czwAblFsPvuEr0gKRjIBwG7AdhSxRHIqJqx9soS9B/S7GX5xyngL3pZcjQmUVrAJHr1naoMSZ52HDBiuCVK4JRwkidfsIkyJJqbCDnOjXPriNtTzMt6h8jgyV7XPTAvS+7ioSVpisXd1PWrCj7Eac29WwPOf+YDoOkQeTPXJ+LrFjzcgyGYFuLAqnZbA4IYI910s/mWMso/10B3NIjfhnWVF5XWd6GwMJZjxgWjhGlfdpNNHjQ/xboMbdQjxPwBfE5Dt5ftzk49x3zB7ZOqJUTquaEn4Q32rnmddq4/ghC3gRXI23cMSrLuwJNKVC3ueeKsJ
 de9D0PD8
 5fLOERuG+C24nFjh39GfIbdG3hiO0oURJXQFedEP+aD90yMoecZBelsBaO7fb23DQ+XanfI3wqxMCEJHnzF3UE8QJF1V2wtOvaDlHyhLo61SuxudOEvYyA7cCYzorX2W6ORH4kUFcfV6Jd8ItpyaxJXNte9/1dB9SVDwe0GHMu1B4hyp2DkxDJ/5vxbZEFCuXrwLVX1xZpy98D7xn7zlfoASsuARhLhD73EGTHcVXKZPfbSaayQo2v4yoDfZ0HXtBpjZ+G/dISM3dPPzOYkdBkO7daEnJPnQ/OKU8G0yVlVRRqqLbef8r3kfrzka6XwXehcQPPULn//Kkgq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Build of VMA and radix-tree tests is unhappy after the conversion of
kzalloc() to kzalloc_obj() in lib/idr.c:

  cc -I../shared -I. -I../../include -I../../arch/x86/include -I../../../lib -g -Og -Wall -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined  -DNUM_VMA_FLAG_BITS=128 -DNUM_MM_FLAG_BITS=128   -c -o idr.o idr.c
  idr.c: In function ‘ida_alloc_range’:
  idr.c:420:34: error: implicit declaration of function ‘kzalloc_obj’; did you mean ‘kzalloc_node’? [-Wimplicit-function-declaration]
    420 |                         bitmap = kzalloc_obj(*bitmap, GFP_NOWAIT);
        |                                  ^~~~~~~~~~~
        |                                  kzalloc_node
  idr.c:420:32: error: assignment to ‘struct ida_bitmap *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
    420 |                         bitmap = kzalloc_obj(*bitmap, GFP_NOWAIT);
        |                                ^
  idr.c:447:40: error: assignment to ‘struct ida_bitmap *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
    447 |                                 bitmap = kzalloc_obj(*bitmap, GFP_NOWAIT);
        |                                        ^
  idr.c:468:15: error: assignment to ‘struct ida_bitmap *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
    468 |         alloc = kzalloc_obj(*bitmap, gfp);
        |               ^
  make: *** [<builtin>: idr.o] Error 1

Import necessary macros from include/linux to tools/include/linux to fix
the compilation.

Fixes: 69050f8d6d07 ("treewide: Replace kmalloc with kmalloc_obj for non-scalar types")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/include/linux/gfp.h      |  4 ++++
 tools/include/linux/overflow.h | 19 +++++++++++++++++++
 tools/include/linux/slab.h     |  9 +++++++++
 3 files changed, 32 insertions(+)

diff --git a/tools/include/linux/gfp.h b/tools/include/linux/gfp.h
index 6a10ff5f5be9..9e957b57b694 100644
--- a/tools/include/linux/gfp.h
+++ b/tools/include/linux/gfp.h
@@ -5,6 +5,10 @@
 #include <linux/types.h>
 #include <linux/gfp_types.h>
 
+/* Helper macro to avoid gfp flags if they are the default one */
+#define __default_gfp(a,...) a
+#define default_gfp(...) __default_gfp(__VA_ARGS__ __VA_OPT__(,) GFP_KERNEL)
+
 static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
 {
 	return !!(gfp_flags & __GFP_DIRECT_RECLAIM);
diff --git a/tools/include/linux/overflow.h b/tools/include/linux/overflow.h
index dcb0c1bf6866..3427d7880326 100644
--- a/tools/include/linux/overflow.h
+++ b/tools/include/linux/overflow.h
@@ -68,6 +68,25 @@
 	__builtin_mul_overflow(__a, __b, __d);	\
 })
 
+/**
+ * size_mul() - Calculate size_t multiplication with saturation at SIZE_MAX
+ * @factor1: first factor
+ * @factor2: second factor
+ *
+ * Returns: calculate @factor1 * @factor2, both promoted to size_t,
+ * with any overflow causing the return value to be SIZE_MAX. The
+ * lvalue must be size_t to avoid implicit type conversion.
+ */
+static inline size_t __must_check size_mul(size_t factor1, size_t factor2)
+{
+	size_t bytes;
+
+	if (check_mul_overflow(factor1, factor2, &bytes))
+		return SIZE_MAX;
+
+	return bytes;
+}
+
 /**
  * array_size() - Calculate size of 2-dimensional array.
  *
diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
index 94937a699402..6d8e9413d5a4 100644
--- a/tools/include/linux/slab.h
+++ b/tools/include/linux/slab.h
@@ -202,4 +202,13 @@ static inline unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
 	return sheaf->size;
 }
 
+#define __alloc_objs(KMALLOC, GFP, TYPE, COUNT)				\
+({									\
+	const size_t __obj_size = size_mul(sizeof(TYPE), COUNT);	\
+	(TYPE *)KMALLOC(__obj_size, GFP);				\
+})
+
+#define kzalloc_obj(P, ...) \
+	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), 1)
+
 #endif		/* _TOOLS_SLAB_H */
-- 
2.51.0


