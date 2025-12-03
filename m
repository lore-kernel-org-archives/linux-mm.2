Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A595D1CDAA
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 23:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B756B0030; Wed,  3 Dec 2025 18:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014506B0031; Wed,  3 Dec 2025 18:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF76C6B0032; Wed,  3 Dec 2025 18:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C79786B0030
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:30:40 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 964AC13BB14
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:30:40 +0000 (UTC)
X-FDA: 84179756640.26.C52DB89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 01616C0010
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:30:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GkKzzvC5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764804639; a=rsa-sha256;
	cv=none;
	b=ysVoquF7jpduJCIy8ff+h2ETKq3F2TSnfRFmka2/kfEBg8729q33/s81vOaoBGGg6RRNRs
	R/hZ1wb4JxGw5z0ZGlChoUlc1Abgmif5pve7vvCq62HBvc9nfE4JST/7YTYLdkTQjt/4nt
	Lqxx8NFivsCEQ47RWyyLEI1OMzsccyQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GkKzzvC5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764804639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cx3M7V60xZ1MIskixZFeT3lomPyvPv9zROSSuzF1+8A=;
	b=xfx2Gd7N95/yfsm24TXrUhu2bltN7v4ewP0Z+nP2RuSqyuk/Ed74sQT0T1XQsKQmD3tkJt
	42/TQf4CNAtev8BEzIuHkKaixqI6eJVQ6iU7TSaWsv/u74XRFXpiEDTARDVpV6MDr3bnyi
	uFVTpx4v6LmoMmBh0ltnDVFki6hovxk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9410644404;
	Wed,  3 Dec 2025 23:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E903C116C6;
	Wed,  3 Dec 2025 23:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764804637;
	bh=MfXbJ6vSs1Dx3b2SfnaSAfowCKIWsMTNjHXn3OinNe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkKzzvC57I+ubbzzUXskQZPPGE1GvWjqTiM3d35YfztkY9NIikn9kZ0T5XWf2PxAi
	 GQ6P4Y3Spf4QUlTwHZJooN9f2Ia6Q2b9h0klqmRNW5/klLd0GuZR3Nu6FoApw+Xin1
	 DvbMZp62pbv1KK5jklUVk5wCy9maWxe2Ssb9xo8aqvEXedQVjo3AmEi19cUH/8ALvT
	 Ygp8GmIrVwPmd692LyrycPTdMK6sBy7bIJxNyqc1f0HcrNv8hp8db+TRYQ9VUoU0AQ
	 qHTcsbtd2ymA2lZ2RdBNlLW+UAD4OTaUBYSWACqvTKz3jPGGk8+ZcV++UUULCi9FaE
	 e+CZ4JNFFVAxw==
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
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Joe Perches <joe@perches.com>,
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
Subject: [PATCH v6 3/5] compiler_types: Introduce __flex_counter() and family
Date: Wed,  3 Dec 2025 15:30:33 -0800
Message-Id: <20251203233036.3212363-3-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251203233029.it.641-kees@kernel.org>
References: <20251203233029.it.641-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5281; i=kees@kernel.org; h=from:subject; bh=MfXbJ6vSs1Dx3b2SfnaSAfowCKIWsMTNjHXn3OinNe8=; b=owGbwMvMwCVmps19z/KJym7G02pJDJkGJ6SyquI9VTrT7K0fRN96M/XBg4q2dqVNr7rUPzbWO P1O3Leto5SFQYyLQVZMkSXIzj3OxeNte7j7XEWYOaxMIEMYuDgFYCLe/Qz/M962TshlVb25WTQ3 YnViltHfjsB5KdXZGiIu2ROm6jhNY2R4Op1R/sq13++vuB0wmvLk3Fpvj8u+a03qGFTK09OCWHb zAgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 01616C0010
X-Stat-Signature: ga5yerwzjaarp4erzaayfgjp8zeuceta
X-Rspam-User: 
X-HE-Tag: 1764804638-731977
X-HE-Meta: U2FsdGVkX190lIaYecvE3WpEToAViGtSJdiCQba+AxfSVEq7pkOUXijKrbt6WcmZ9QIiEeiXrqQZLms6SxzpcjGaKY2UkDwHVueMzWDDsuC/jfGSJn9SdESutsQYy9UjEIEPPfmvH9c8cGCUlEwm0pwez7+hoNJnRj1NTsf9I9k0Y5WJgfBJFcWZbl07EDtXY+XZjGsSPyYoeGBl07/xFwhFGjdTGVnBRaN8fagdeg1kM/aqY1IIwyuV0b1A6jeY82mmAHu+jVIusmCfDIzncSY9zdcJEuwpEOB0ylayyJwQrJSI1P8WMBPnOpYYKYCUSjBeCWjGE/OVqr7gdpP4Loi4caVIv3nC2XJnxtr2o2OgBT5MI6ibj6iBqlvkXTz4jDjZJMAxAwTumXaaUydtn4xNUYs7a9lUzTuB3Al0yFgxydycKMwXYqtnAS86wl15/EimBuW/exa874pSPQIx+A/VL4jD6pa5l5cHAJvjkyxy1nZ63d1mA3NHthD7AeOUIoaCkhIBDYOIw2D1q3NF3YpeDB83TgSbbx4FyxYIx+0RJEDgbBA5bpOChAd6FzZhJcKsvORbCYtmPgBrZVNzDyIFn2oekH6vBYkjuBCSHMQisXKlxwxDkl+9eQb9Pn9+7JQpn+BI1Hf2M8/CayS6w9zHL/XQqqyBtaLpoo7/B34QISLSMIo0igL6W3TyIhYGSkMFLhNlBc+WBxy2dSKsQBY+YABcPdy21Um1oifik/NZHgBNAwB1YYIiAgh7H10XehVFNbZ4bXD4SxK4e2LFo2tzevp0DUE6fnK+EU/lLZyTu6gxb3jtIRh9pVakLH6q2VIExogm8HEVrvkLGZFl1bC6QeZimn3rMO+hkue+Rr3T1kFPn0mG7V4yDQ5Ix6UDZCz9wQUyWkE3kN7ZHmXxiju1tK6Rkx3uCVSDKiyAeMbs/Qo4RLMu52FPoanQioiqZj3JFQhn9IlwpxjDmG7
 VzvfvIDj
 QQZEN1u98ls8hTlpP5bzVoEpOyZ7DwoHWTADFRSSpGThDZvtjwLtckjXAf39NCIGeezQDotnQrryJq2mi5Ujyph5NKg==
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

Introduce typeof_flex_counter(), overflows_flex_counter_type(), and
__set_flex_counter() to provide the needed _Generic() wrappers to get
sane results out of __flex_counter().

For example, with:

	struct foo {
		int counter;
		short array[] __counted_by(counter);
	} *p;

__flex_counter(p->array) will resolve to: &p->counter

typeof_flex_counter(p->array) will resolve to "int". (If p->array was not
annotated, it would resolve to "size_t".)

overflows_flex_counter_type(typeof(*p), array, COUNT) is the same as:

	COUNT <= type_max(p->counter) && COUNT >= type_min(p->counter)

(If p->array was not annotated it would return true since everything
fits in size_t.)

__set_flex_counter(p->array, COUNT) is the same as:

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
 include/linux/compiler_types.h | 31 +++++++++++++++++++++++++
 include/linux/overflow.h       | 42 ++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

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
index 725f95f7e416..f362e155a7ec 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -540,4 +540,46 @@ static inline size_t __must_check size_sub(size_t minuend, size_t subtrahend)
 	(__member_size((name)->array) / sizeof(*(name)->array) +			\
 						__must_be_array((name)->array))
 
+/**
+ * typeof_flex_counter() - Return the type of the counter variable of a given
+ *                         flexible array member annotated by __counted_by().
+ * @FAM: Instance of flexible array member within a given struct.
+ *
+ * Returns: "size_t" if no annotation exists.
+ */
+#define typeof_flex_counter(FAM)				\
+	typeof(_Generic(__flex_counter(FAM),			\
+			void *: (size_t)0,			\
+			default: *__flex_counter(FAM)))
+
+/**
+ * overflows_flex_counter_type() - Check if the counter associated with the
+ *				   given flexible array member can represent
+ *				   a value.
+ * @TYPE: Type of the struct that contains the @FAM.
+ * @FAM: Member name of the FAM within @TYPE.
+ * @COUNT: Value to check against the __counted_by annotated @FAM's counter.
+ *
+ * Returns: true if @COUNT can be represented in the @FAM's counter. When
+ * @FAM is not annotated with __counted_by(), always returns true.
+ */
+#define overflows_flex_counter_type(TYPE, FAM, COUNT)		\
+	(!overflows_type(COUNT, typeof_flex_counter(((TYPE *)NULL)->FAM)))
+
+/**
+ * __set_flex_counter() - Set the counter associated with the given flexible
+ *                        array member that has been annoated by __counted_by().
+ * @FAM: Instance of flexible array member within a given struct.
+ * @COUNT: Value to store to the __counted_by annotated @FAM_PTR's counter.
+ *
+ * This is a no-op if no annotation exists. Count needs to be checked with
+ * overflows_flex_counter_type() before using this function.
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


