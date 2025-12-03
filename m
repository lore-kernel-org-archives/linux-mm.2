Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8618D1CDAE
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 23:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5846B0031; Wed,  3 Dec 2025 18:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608876B0032; Wed,  3 Dec 2025 18:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4339F6B0062; Wed,  3 Dec 2025 18:30:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9AA6B0031
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:30:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5F4E133598
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:30:40 +0000 (UTC)
X-FDA: 84179756640.17.F705E88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 25C842000A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 23:30:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tb1QFnmr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764804639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bHDnA39n23L3Oms8EO9Ali9+Wl0S4uKjpuKYohEsaUw=;
	b=OXjal+RW1vL2P0fCXR1rwP3ODeG2qggc/FlB6IAIXq7aWSqvlcuJIKvvPSQ1i7m9k3rf5X
	qAt6rwCOBIOrucCLYnjmC0RMlw648Y/vtlQAfZiVhS4Lr9m+cXLBIaExWWv9VjnJtvYBoJ
	0Xm++DYsCY3F1XTvcO05B6GDsseLSug=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tb1QFnmr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764804639; a=rsa-sha256;
	cv=none;
	b=CWhfJ11rqifLjmHXfbcwyCBDTKofWMPeKQJOfM67mKSey8LJ1FMRPejlB799fQZUwiiHMi
	tY47qyg5A/mcCnwks/WYEIY5H1TiYR1aVj9HPiy52+DyHWlF1C7Zucc1z/UjExSChMUQNJ
	/B+Cr5pp5wf0w4TVMccWQSQTufc1vIU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2B6044411;
	Wed,  3 Dec 2025 23:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5515AC2BCB9;
	Wed,  3 Dec 2025 23:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764804637;
	bh=5dAQ4T//TVYvlDNMsV5Y6TSBwmCOXpo3qNaO4v8qX0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tb1QFnmrmnR+zXH4fFBLmyxgcqpG4u3ZvwA7jcak8tIqWFqIsmYPPKVxGdTX8Ryvr
	 R1Li+pHJWV1tAMBLLP3p+jTOEuYTJC+rO7oIZ4ejDqA1hne6lUoKesO8t7wxq6qoqz
	 dGwtzcdHfbeL7AZLleyooLz5rSKKZZHmqOqNQT/gL2IqbrPdi1OGOn1CFy4tmYloBK
	 ZP+6uTtqVaFhxeXwW8PA0tVDOwqLxJ/ruN46Fnaai8RPGeamw7sRh3iri3PFyf7QuU
	 aqmZoLMDLVciN4vCgG365BnxUxt6oAmlIlK001XgapbBRngGvP07yXaJrao1Bu0yB+
	 aS4CkB0gAXGhg==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <kees@kernel.org>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	cocci@inria.fr,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Joe Perches <joe@perches.com>,
	Christoph Lameter <cl@linux.com>,
	Marco Elver <elver@google.com>,
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
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v6 5/5] coccinelle: Add kmalloc_objs conversion script
Date: Wed,  3 Dec 2025 15:30:35 -0800
Message-Id: <20251203233036.3212363-5-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251203233029.it.641-kees@kernel.org>
References: <20251203233029.it.641-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3968; i=kees@kernel.org; h=from:subject; bh=5dAQ4T//TVYvlDNMsV5Y6TSBwmCOXpo3qNaO4v8qX0A=; b=owGbwMvMwCVmps19z/KJym7G02pJDJkGJ6Sy9r13X/2Re2em+HFHS6vbrLaGdziDJu7dxrh1l R1vmPW3jlIWBjEuBlkxRZYgO/c4F4+37eHucxVh5rAygQxh4OIUgIl4hzD8L6ve9u7a1VXb7Pz5 MjPFYksnmr7e9rF9fq7z04VTjtk3ejH84bQ9zWIc4xC+xfH9mXsPlN8nHDdq3WiycYLhz4VWbE2 qDAA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 25C842000A
X-Rspamd-Server: rspam11
X-Stat-Signature: wc1fb16htkgdkif9fid5ttygjqed77xa
X-HE-Tag: 1764804638-434570
X-HE-Meta: U2FsdGVkX18VcTOKo5NdERwwoMI+7jbZz1QwlV6hbiIfe0Z7dQWXAVTZfa3pb1qCa10aUP5efFYZwEBnU40tOQvOR9GGzwS3ux1+VADXFH8NXeC+CwtCT0zpYi/utlEPtGYZz+pUQOsYgEip1cx6BNOIpZJNjdQva7clDbZbXIlmcdIKAPlEbLdxOS2kLA/NnF0XLWdvcKMK7KJFH3YTu/GYT4OCSa6k8wSPyYb78M3NKOJAtUdk8dL54pjsIVeUY/yyy1ABbgbiQ57O0RidJR1+ZO4X4b12KUr/SQyNO6y5Zh7DDh50AqHoVl3mncUVFMqQitoSkNxsuZsS6rbk/Rlt1k5d3sOeJd/egpmjWMbKaYEr902j8BamYm/d2sCNwl0VpxgUwnOkY35m27zAV7IoyoF5ut99V7053U5rVWi7XLWnfBxAxwg6oIRWH3M1h1rtnVVAzWbmGC9OKqZubpuYl2tRyKMkqlW/NuelfDtTJGaPHre1JPFaPsCu31ehc+hWd2SJmawRYY6wF5UyEl0r6iFYPb+H+7JZvBpvYXzP66YmgC+ZfCB90+XrLEMbBoiN8D8Sw0qS8a02sjGIavcR9qN1y6aPEBJFZIx0gGvEMpaFp6tbec0II7E7tWcYnmIOLxyy+W4hSYTT1z1an+78tEMYAUehk84d/u9nn1JOXx3xGUxsCI0Y/FH/rCWK1lshtZkS7QB6d52yiFK3FuIguIXSiYVaM/nsQ3Xa6NkU9KzyNRIJE9Xz2zfTmov2wuHKvC1vkr3GEu+4kKQw39fX90ZfLoUj2ce7H7VKp5PAOiGRh4GE/gUKjU9IOwoAY651LfIueW9A2iweaj2v9OXsGZ1G31cVYa04uJcC2tCRplPl0dDWvPEymidFu/wGv3ogJxnhzdTUtGR/ELJWxgzw4TzzX+858MyBswkogyXLLxKDlbEF1EU6z/wS2OwKKXh/YhLKwrBt8eZ/x9r
 Gg98n8MH
 3XxoPL1Issgp04OAl4an/jC3QhhEjycWk022qd84lfkpqu+d3JoxHdiQw6IePQgdM/iKYdOOsdEBrLWrPmG+3Mj3ASyGuARv30xqqDv4hu/yktFEhNqa4vZIeg8/q/9bkDwTLVELRc8TPRCqzKPQ2psHkaomC5n54PfBXzPGNilbjujHfhXRT4IAw6etekieISVtnjWMAhPs7okLB3Ca8MkkyA7jXk2tshAGlbcsFl9j0euAYC91bMP0GDy024feCOQlSneyWzJZhrR1+MyV3/+0C+mm93QZSTZfDutfUMFWTL3gASbkpw51G8jXXzCHT+Fxvirm3G2QICpMUOAx+oZdT8iZEan/fQl+1awDvTknQlyM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Finds and converts sized kmalloc-family of allocations into the
typed kmalloc_obj-family of allocations.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Julia Lawall <Julia.Lawall@inria.fr>
Cc: Nicolas Palix <nicolas.palix@imag.fr>
Cc: cocci@inria.fr
---
 scripts/coccinelle/api/kmalloc_objs.cocci | 109 ++++++++++++++++++++++
 1 file changed, 109 insertions(+)
 create mode 100644 scripts/coccinelle/api/kmalloc_objs.cocci

diff --git a/scripts/coccinelle/api/kmalloc_objs.cocci b/scripts/coccinelle/api/kmalloc_objs.cocci
new file mode 100644
index 000000000000..916cc3a661b9
--- /dev/null
+++ b/scripts/coccinelle/api/kmalloc_objs.cocci
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/// Use kmalloc_obj family of macros for allocations
+///
+// Confidence: High
+// Options: --include-headers-for-types --all-includes --include-headers --keep-comments
+
+virtual patch
+
+@initialize:python@
+@@
+import sys
+
+def alloc_array(name):
+	func = "FAILED_RENAME"
+	if name == "kmalloc_array":
+		func = "kmalloc_objs"
+	elif name == "kvmalloc_array":
+		func = "kvmalloc_objs"
+	elif name == "kcalloc":
+		func = "kzalloc_objs"
+	elif name == "kvcalloc":
+		func = "kvzalloc_objs"
+	else:
+		print(f"Unknown transform for {name}", file=sys.stderr)
+	return func
+
+// This excludes anything that is assigning to or from integral types or
+// string literals. Everything else gets the sizeof() extracted for the
+// kmalloc_obj() type/var argument. sizeof(void *) is also excluded because
+// it will need case-by-case double-checking to make sure the right type is
+// being assigned.
+@direct depends on patch && !(file in "tools") && !(file in "samples")@
+typedef u8, u16, u32, u64;
+typedef __u8, __u16, __u32, __u64;
+typedef uint8_t, uint16_t, uint32_t, uint64_t;
+typedef __le16, __le32, __le64;
+typedef __be16, __be32, __be64;
+type INTEGRAL = {u8,__u8,uint8_t,char,unsigned char,
+		 u16,__u16,uint16_t,unsigned short,
+		 u32,__u32,uint32_t,unsigned int,
+		 u64,__u64,uint64_t,unsigned long,
+		 __le16,__le32,__le64,__be16,__be32,__be64};
+char [] STRING;
+INTEGRAL *BYTES;
+type TYPE;
+expression VAR;
+expression GFP;
+expression COUNT;
+expression FLEX;
+expression E;
+identifier ALLOC =~ "^kv?[mz]alloc$";
+fresh identifier ALLOC_OBJ = ALLOC ## "_obj";
+fresh identifier ALLOC_FLEX = ALLOC ## "_flex";
+identifier ALLOC_ARRAY = {kmalloc_array,kvmalloc_array,kcalloc,kvcalloc};
+fresh identifier ALLOC_OBJS = script:python(ALLOC_ARRAY) { alloc_array(ALLOC_ARRAY) };
+@@
+
+(
+-	VAR = ALLOC((sizeof(*VAR)), GFP)
++	VAR = ALLOC_OBJ(*VAR, GFP)
+|
+	ALLOC((\(sizeof(STRING)\|sizeof(INTEGRAL)\|sizeof(INTEGRAL *)\)), GFP)
+|
+	BYTES = ALLOC((sizeof(E)), GFP)
+|
+	BYTES = ALLOC((sizeof(TYPE)), GFP)
+|
+	ALLOC((sizeof(void *)), GFP)
+|
+-	ALLOC((sizeof(E)), GFP)
++	ALLOC_OBJ(E, GFP)
+|
+-	ALLOC((sizeof(TYPE)), GFP)
++	ALLOC_OBJ(TYPE, GFP)
+|
+	ALLOC_ARRAY(COUNT, (\(sizeof(STRING)\|sizeof(INTEGRAL)\|sizeof(INTEGRAL *)\)), GFP)
+|
+	BYTES = ALLOC_ARRAY(COUNT, (sizeof(E)), GFP)
+|
+	BYTES = ALLOC_ARRAY(COUNT, (sizeof(TYPE)), GFP)
+|
+	ALLOC_ARRAY((\(sizeof(STRING)\|sizeof(INTEGRAL)\|sizeof(INTEGRAL *)\)), COUNT, GFP)
+|
+	BYTES = ALLOC_ARRAY((sizeof(E)), COUNT, GFP)
+|
+	BYTES = ALLOC_ARRAY((sizeof(TYPE)), COUNT, GFP)
+|
+	ALLOC_ARRAY(COUNT, (sizeof(void *)), GFP)
+|
+	ALLOC_ARRAY((sizeof(void *)), COUNT, GFP)
+|
+-	ALLOC_ARRAY(COUNT, (sizeof(E)), GFP)
++	ALLOC_OBJS(E, COUNT, GFP)
+|
+-	ALLOC_ARRAY(COUNT, (sizeof(TYPE)), GFP)
++	ALLOC_OBJS(TYPE, COUNT, GFP)
+|
+-	ALLOC_ARRAY((sizeof(E)), COUNT, GFP)
++	ALLOC_OBJS(E, COUNT, GFP)
+|
+-	ALLOC_ARRAY((sizeof(TYPE)), COUNT, GFP)
++	ALLOC_OBJS(TYPE, COUNT, GFP)
+|
+-	ALLOC(struct_size(VAR, FLEX, COUNT), GFP)
++	ALLOC_FLEX(*VAR, FLEX, COUNT, GFP)
+|
+-	ALLOC(struct_size_t(TYPE, FLEX, COUNT), GFP)
++	ALLOC_FLEX(TYPE, FLEX, COUNT, GFP)
+)
-- 
2.34.1


