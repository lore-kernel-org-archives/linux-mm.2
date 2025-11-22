Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70DD3CFC515
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 01:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74DD6B0029; Fri, 21 Nov 2025 20:43:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4D056B0026; Fri, 21 Nov 2025 20:43:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC79A6B0029; Fri, 21 Nov 2025 20:43:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAC806B0026
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:43:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B2DABB163
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:43:08 +0000 (UTC)
X-FDA: 84136544856.08.4DF09D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D38222000C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:43:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bY5wuqa8;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763775786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CL9rWEp8Imob3kI0yja+Vd4/BWmn09HAssb44lX0SuE=;
	b=ZOvAPmkBI464eKLxzn5kq4ZKUdCWiAnxzeyuPXGsTSc623kR2xdDf0Cy2juCkzwyhxiirI
	O+wdGMJggy38QPHZ6gSenPcHTJ9fHu1trvJQp8o2YR82cXyLpNMmUYJsjcSxkZbNhFcaoL
	Q5c+OztS1nsqzEsVFL2LD4084GKmuIg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bY5wuqa8;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763775786; a=rsa-sha256;
	cv=none;
	b=zLst4OfigN0Q+GdKmTmTnVXVU7dM1s2rula3fL2PQZWaQ6i0aqF08NjE9vyZOow/eAMN4+
	/ibts0gn4+/W+W89Vkmwgk5SmRzYAi+NnIGr/VSL2xTSUiqjgFPEqnTTdAyivZjJVTafOV
	8zP96P3d9ogzghIHFI3xy1Cv9H+oyhk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC111601B8;
	Sat, 22 Nov 2025 01:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0EEC4AF0C;
	Sat, 22 Nov 2025 01:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763775785;
	bh=Bm5UctH3mgw7LUjsKVnWiQeM2ZjrjWLRLpRvc3SOhQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bY5wuqa8a45W1HINfdbep5urhBZTK2k+WQTidy33+y0UlNS72H74z1CfoVuW3hv7V
	 z5FUQMqtrQdtYTB9J+wYlts/dfP+OMaVtwEmnKQ6kVx9FZ+Jj9VFKVlUi5bpwWa1yd
	 daQJRa28y6IKVTL3KGIVBArcTmb5up8agCLOny+j7E58LB1oMO3dTYEgfdSuQ2oUkV
	 n+eST1UZDdTnzReF+ohecgxU/jd9p60qSWkqP83/sI0Z7fA7T8nEks1X9w75Qjwgcp
	 HZMoDc4RKpnM3zWm1fQ4v2vyseKu/YgO/WKEiy7J8c+z03lL/NuR0nufzgSzx/C/HA
	 lJSm+TzfJdi1w==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <kees@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Marco Elver <elver@google.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	linux-hardening@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-mm@kvack.org,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v5 1/4] compiler_types: Introduce __flex_counter() and family
Date: Fri, 21 Nov 2025 17:42:57 -0800
Message-Id: <20251122014304.3417954-1-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251122014258.do.018-kees@kernel.org>
References: <20251122014258.do.018-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5209; i=kees@kernel.org; h=from:subject; bh=Bm5UctH3mgw7LUjsKVnWiQeM2ZjrjWLRLpRvc3SOhQI=; b=owGbwMvMwCVmps19z/KJym7G02pJDJmKoso7nm58EGTt81C0PG6jhZD/jO6pLRohBZOjykWLY zhERVk7SlkYxLgYZMUUWYLs3ONcPN62h7vPVYSZw8oEMoSBi1MAJvLPmpHhtnWqcu45r7Nt6RxR piEzpIWdq2qOP7DcfZlTa5bZAbadjAwPN/G4mYuxhbHdYPr2JoUnd9p5t+mHfkaHZvQWbL51NZQ FAA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D38222000C
X-Stat-Signature: fjdrxtbc1xu5m9t1j1mexjbpzc3qg3o1
X-Rspam-User: 
X-HE-Tag: 1763775786-869130
X-HE-Meta: U2FsdGVkX1/ObjPFVjcNPa7I45Td6c2WWqTFzjh5OWPEMz8I3fv3nyk9OEueXu7GQsvK5UL0SEDYdHWHKjc5qLeVX23Wi+fGfVdnjI9Z410KJLxwEQcwGn61Q6tNzF/F/Q9/wT1KnItLdHz2QEoPC0XngRAd2NHenuIzJwYK5UWxgbVIhng3fOlKSAeoZX4kdgNN5MihQX+VhzU/7vwjnW6OxGwWA2dp9yYEMel+UP852ripxcxF6MnGbqtZTfXxmANnnU/o/O/uC5NtAhGZL3IPMa809qLJTBHRr4GUAcBx0C/qMP5ICFgPfoM09kmg7nM2+DNxY3iJ3UmoPygCfJyf6fIbhROgPlJaHh//Ve/UJxHlkqpllj3NBobRpheeIEdIch/PgfpC4AqC31uc6boeJYeh9gdvCqrm9uyC0bZ+S5oqnD3ngq/AX9Tnl8KJ6INugWdus/BE1IIN8OBjNwDkm5lpyI9stIJibiVhzmb/1XPqftAFUfyWvHuTLGsl/hje6faunrG9odylpWbKMzGLJwdRLS3KaQimDm6/UFrzGj5XI4ZKpBRn3SPLSzpKqQiX2jshgOvPAi5srzYUpSBf1uDITLBOjS7R1DoI/Q14+FO2LVZWks4Uul3/Zr65AMJ+zWTg36zE/BCjAcQOAv5wqS3Y4FdpyhyiAKiolez3XZOfGoB+kE2DJVGNWqzbkKwYktf9W6rLt8auAXOoirhERuzgMfPqy5DUVTqC9LDEWJk348kY3OB7kukNko3FnuuSgjo7wCa0r99HbhOhz4Rgxo8U2soCA5AQO0vfH7NqGEMEKEmTy3kU8468kW1XJoHwxeu80NJ/DCNGs9mrmfmHRoV0n+5M0hz9hTET27vWLbjPuD7sbaFJlrGwwPi0OQFBIzPhKH5d10zH1Z3dhbsU23B72ujapgtpADifLsVtRU0gHT3tt2EYRXH7arl8Bk5UJEGFO48m3/7phxo
 69beRkht
 XYvRBf7hZUEWOBBAT/9qEGIRDmtZpf8/xPK3vW5ZXFZjfrz9Q45mRp0tta7PjHq3g685XaEhHxm28mPn/RX1YUxtIsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce __flex_counter() which wraps __builtin_counted_by_ref(),
as newly introduced by GCC[1] and Clang[2]. Use of __flex_counter()
allows access to the counter member of a struct's flexible array member
when it has been annotated with __counted_by().

Introduce typeof_flex_counter(), can_set_flex_counter(), and
set_flex_counter() to provide the needed _Generic() wrappers to get sane
results out of __flex_counter().

For example, with:

	struct foo {
		int counter;
		short array[] __counted_by(counter);
	} *p;

__flex_counter(p->array) will resolve to: &p->counter

typeof_flex_counter(p->array) will resolve to "int". (If p->array was not
annotated, it would resolve to "size_t".)

can_set_flex_counter(p->array, COUNT) is the same as:

	COUNT <= type_max(p->counter) && COUNT >= type_min(p->counter)

(If p->array was not annotated it would return true since everything
fits in size_t.)

set_flex_counter(p->array, COUNT) is the same as:

	p->counter = COUNT;

(It is a no-op if p->array is not annotated with __counted_by().)

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc: linux-hardening@vger.kernel.org
---
 include/linux/compiler_types.h | 31 ++++++++++++++++++++++++++
 include/linux/overflow.h       | 40 ++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index c46855162a8a..a31fe3dbf576 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -507,6 +507,37 @@ struct ftrace_likely_data {
 #define __annotated(var, attr)	__builtin_has_attribute(var, attr)
 #endif
 
+/*
+ * Optional: only supported since gcc >= 15, clang >= 19
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html#index-_005f_005fbuiltin_005fcounted_005fby_005fref
+ * clang: https://clang.llvm.org/docs/LanguageExtensions.html#builtin-counted-by-ref
+ */
+#if __has_builtin(__builtin_counted_by_ref)
+/**
+ * __flex_counter() - Get pointer to counter member for the given
+ *                    flexible array, if it was annotated with __counted_by()
+ * @FAM: Pointer to flexible array member of an addressable struct instance
+ *
+ * For example, with:
+ *
+ *	struct foo {
+ *		int counter;
+ *		short array[] __counted_by(counter);
+ *	} *p;
+ *
+ * __flex_counter(p->array) will resolve to &p->counter.
+ *
+ * Note that Clang may not allow this to be assigned to a separate
+ * variable; it must be used directly.
+ *
+ * If p->array is unannotated, this returns (void *)NULL.
+ */
+#define __flex_counter(FAM)	__builtin_counted_by_ref(FAM)
+#else
+#define __flex_counter(FAM)	((void *)NULL)
+#endif
+
 /*
  * Some versions of gcc do not mark 'asm goto' volatile:
  *
diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index 725f95f7e416..12ca286c0f34 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -540,4 +540,44 @@ static inline size_t __must_check size_sub(size_t minuend, size_t subtrahend)
 	(__member_size((name)->array) / sizeof(*(name)->array) +			\
 						__must_be_array((name)->array))
 
+/**
+ * typeof_flex_counter() - Return the type of the counter variable of a given
+ *                         flexible array member annotated by __counted_by().
+ * @FAM: Pointer to the flexible array member within a given struct.
+ *
+ * Returns: "size_t" if no annotation exists.
+ */
+#define typeof_flex_counter(FAM)				\
+	typeof(_Generic(__flex_counter(FAM),			\
+			void *: (size_t)0,			\
+			default: *__flex_counter(FAM)))
+
+/**
+ * __can_set_flex_counter() - Check if the counter associated with the given
+ *                            flexible array member can represent a value.
+ * @FAM: Pointer to the flexible array member within a given struct.
+ * @COUNT: Value to check against the __counted_by annotated @FAM's counter.
+ *
+ * Returns: true if @COUNT can be represented in the @FAM counter. When
+ * @FAM is not annotated with __counted_by(), always returns true.
+ */
+#define __can_set_flex_counter(FAM, COUNT)			\
+	(!overflows_type(COUNT, typeof_flex_counter(FAM)))
+
+/**
+ * __set_flex_counter() - Set the counter associated with the given flexible
+ *                        array member that has been annoated by __counted_by().
+ * @FAM: Pointer to the flexible array member within a given struct.
+ * @COUNT: Value to store to the __counted_by annotated @FAM's counter.
+ *
+ * This is a no-op if no annotation exists. Count needs to be checked with
+ * __can_set_flex_counter(@FAM, @COUNT) before using this function.
+ */
+#define __set_flex_counter(FAM, COUNT)				\
+({								\
+	*_Generic(__flex_counter(FAM),				\
+		  void *:  &(size_t){ 0 },			\
+		  default: __flex_counter(FAM)) = (COUNT);	\
+})
+
 #endif /* __LINUX_OVERFLOW_H */
-- 
2.34.1


