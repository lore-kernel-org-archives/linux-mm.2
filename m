Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 447F3CFC516
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 01:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B89B6B0026; Fri, 21 Nov 2025 20:43:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2DE6B0023; Fri, 21 Nov 2025 20:43:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73BB6B0027; Fri, 21 Nov 2025 20:43:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB4E06B0027
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:43:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 550E0130576
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:43:08 +0000 (UTC)
X-FDA: 84136544856.10.C57C5E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9E2C2A0004
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:43:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WMvlgijz;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763775786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVS0zpRfIl4H9hjN9Gsnz9HU6fNZFKYbuKVMZDTQ2Gw=;
	b=3FLmgUnG1hdwwrQdWIilRxLKf5SZQFrkDwr6W68ZyvQdgy8AgwZegP7STjm3A7M+Mochaz
	gFPxjUdCLsr4jFeev1KY9B47W358OO9QADJxGUQFHHGfmHCAAvWzO++Eiv7Kd5bDpwP7wP
	TbohOPbRF9i5qAp/U4mPNmvQDLTdRr4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WMvlgijz;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763775786; a=rsa-sha256;
	cv=none;
	b=YNqE5dEX79fqbfuBhLYLngptn//+tHlbrJwtrc+0YTBf/dPBFhtOZBQtecNNotDVrlY/3p
	nP+PaBMp1sBBiSeKAd2JbMD8lVBpgV/0xDvNuhC0HcUhF9jxXh1OYkROS3ljSYTkh+bjx3
	aN4uJGxkDs2uN2r5EluAFbG1wMaGOFs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AC31060172;
	Sat, 22 Nov 2025 01:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45596C116C6;
	Sat, 22 Nov 2025 01:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763775785;
	bh=JxuvIO3718cS+Dvv5mnYaQfpRZs89bnBJgRU4fqHVhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMvlgijzbmFNkfbnQVSo6QNnc2jbeN9HLvXWjQOD93VkbfHKnVlUY7eOKEBcuHc67
	 6PayG7QOl6uN5Vz7SX/SjbnnvJVTQSEFclQ3E+RQMEN37u2gsLaJDrutd2UEd1hPKn
	 eHktdbFsp5skk56TH79GEktt7iA/iT2S0Qrad486wiP+ow/jAeOAJNCJmRYglKwsM+
	 9a0RORXbOB7nHKxtWvj/g0k5k++pY7QHTI9D4WK65u6qIM8mqN4C23qYwhkfzWSWS1
	 eNUUfNb2zOrPMBidmcWKFrNloeo0lQC+OG0v99oD132px4tyS1RAxPzJgAcV2eS+tF
	 wFnZ3vu36liyw==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <kees@kernel.org>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	cocci@inria.fr,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
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
Subject: [PATCH v5 4/4] coccinelle: Add kmalloc_objs conversion script
Date: Fri, 21 Nov 2025 17:43:00 -0800
Message-Id: <20251122014304.3417954-4-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251122014258.do.018-kees@kernel.org>
References: <20251122014258.do.018-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5220; i=kees@kernel.org; h=from:subject; bh=JxuvIO3718cS+Dvv5mnYaQfpRZs89bnBJgRU4fqHVhg=; b=owGbwMvMwCVmps19z/KJym7G02pJDJmKoiovd0kEL2nM9vrWcEr0BrNDueiFSz1VT7Ynz/mxU HCv85o3HaUsDGJcDLJiiixBdu5xLh5v28Pd5yrCzGFlAhnCwMUpABORKWdkeMS4oWH2j/3ayy4U ntTmmnLqyr3eozWS3Heu/Np3OmE6822GP3wLym6t6qhK1xRnlXp2RrSzPrjMxZRN3oOxU9LE8eY tFgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9E2C2A0004
X-Stat-Signature: d3yasn5z16bjbc9qcwywcdgg4jmdooa1
X-Rspam-User: 
X-HE-Tag: 1763775786-908631
X-HE-Meta: U2FsdGVkX199CyLACokTmbuHeJiW+eqEol3LLOc0fya8gsDXvi3F4XTm/xS3+1QUnbyWYPjUTjuyWJh79Jkv7svDmb0NH8amXHbij0y/8K08k8m4sqBoEtsk+tByrKP8mseLthfuZVh7seKQg97iZFmd0upBOXZrJBVbBvHXxTY6U+sbJlhSscG5BLKxP23EOHH4QpeKxOxj6+jizLJ5g6bv6ba1Cyx+liiE/5VFOxinZowr77KMfdb7i8X4XfAgq3LjR7OGq0Ojy5ERIOmTHaqxwOwJdLSan7N8eJ4/tcgQt3OoS+jOwV7gUHbFdnRHQCRyQ2d00LL19+o5jNNH4mW90/1hOPGwJS2i8d89K2Cq/D5SHZkw93xkwnN26RR5GePMBTTn5c9pombb5FkfsfWXkPWs+eKY0xV0OC6cpJQgUpHFf485DeAm7o11xzGoNZmcB3Xo/1ku5WhQCzKB5o9Jw9GUj4j1QKkSp8uXVlr+W2UDOHcEGRAfNSP7IuMZRhv8E7p5MZZQ5dXyeuIuDAXsGWL391/RH6DiK9tvTF4QLYwDv1mMxK8EB3IlGjQV49Xq4aFH489LzheZxKe6iYo2bMgIvzg1XElP4/JTP+o8qAkX9limtWYW7dnFBJ431X8DMSEnOdDh8GPYkqZCFEbv92lqoKapwpUZVJSxmmbR64VX8Cl7HZ1WU/ja4NOdbqy6hGopAMlQORh4i4eQWYA2DyuEJL2asoa+bIeNLboxGM60GJPJSgZVOrx3K2wo4ZkzYMRyVg3WfHh1n/B/pRfQnxbeRaWA57guWdR+IZ+Co1SV0PvxKRIIaVFn5Q5TQpNAuo7Ff9HxzvP0ONgMOJeBmrXku8BTirJ6zBf0LzooidiVWlhc2zx9pN1BjGRxGRayFIAmHiuN3IhrEMBUVdIY2MTP5ED3pwlW0s8tkZKfwjn5IIUYZ+E5l+kxnlkKnBwy3v8LiOhsl0P0IP3
 V8Uwn4bk
 QtZzOQHbfGYOW1ZEEfPT0qEQJbLoR9bNlpqmnXYRrmGZIE5tj46StSzzNfa7mEWsdjwhBoBwGZOC8RgutuEnCcjPFYRtgUb+LAGzF5en9IHQpkL0gsz336oz4xqwgA6mnER8MK/NK5fBg1GwHLgPWmOOkK7I+MkDqb/zhNekqHSwiXmPJUMXdFBLHiyi/cpG2wnJX6Vf2i6d1xi+J/El7GV4/JBDC/ZaS5XLEr4XXCOM0JubYumbNoOqICHtXvhT31BjzhxlR0HXwdMbnzmzzJ8hEFeTbt5mDSAO/PGtC7C/0aKOdnNnY7mOUgz4WIfYRLCPL2NdmsaGT0NB5b6bKbD33nGDeUQlGqXvO9UHN/61b8bY=
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
 scripts/coccinelle/api/kmalloc_objs.cocci | 168 ++++++++++++++++++++++
 1 file changed, 168 insertions(+)
 create mode 100644 scripts/coccinelle/api/kmalloc_objs.cocci

diff --git a/scripts/coccinelle/api/kmalloc_objs.cocci b/scripts/coccinelle/api/kmalloc_objs.cocci
new file mode 100644
index 000000000000..39f82f014b17
--- /dev/null
+++ b/scripts/coccinelle/api/kmalloc_objs.cocci
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/// Use kmalloc_obj family of macros for allocations
+///
+// Confidence: High
+// Comments:
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
+@assign_sizeof depends on patch && !(file in "tools") && !(file in "samples")@
+type TYPE;
+TYPE *P;
+TYPE INST;
+expression VAR;
+expression GFP;
+expression SIZE;
+identifier ALLOC =~ "^kv?[mz]alloc$";
+fresh identifier ALLOC_OBJ_SZ = ALLOC ## "_obj_sz";
+@@
+
+(
+-	SIZE = sizeof(*VAR);
+	... when != SIZE
+	VAR =
+-	ALLOC(SIZE, GFP);
++	ALLOC_OBJ_SZ(*VAR, GFP, &SIZE);
+|
+-	SIZE = (sizeof(TYPE));
+	... when != SIZE
+	P =
+-	ALLOC(SIZE, GFP);
++	ALLOC_OBJ_SZ(*P, GFP, &SIZE);
+|
+-	SIZE = (sizeof(INST));
+	... when != SIZE
+	P =
+-	ALLOC(SIZE, GFP);
++	ALLOC_OBJ_SZ(*P, GFP, &SIZE);
+)
+
+@assign_struct_size depends on patch && !(file in "tools") && !(file in "samples")@
+type TYPE;
+TYPE *P;
+expression VAR;
+expression GFP;
+expression SIZE;
+expression FLEX;
+expression COUNT;
+identifier ALLOC =~ "^kv?[mz]alloc$";
+fresh identifier ALLOC_FLEX_SZ = ALLOC ## "_flex_sz";
+@@
+
+(
+-	SIZE = struct_size(VAR, FLEX, COUNT);
+	... when != SIZE
+	VAR =
+-	ALLOC(SIZE, GFP);
++	ALLOC_FLEX_SZ(*VAR, FLEX, COUNT, GFP, &SIZE);
+|
+-	SIZE = struct_size_t(TYPE, FLEX, COUNT);
+	... when != SIZE
+	P =
+-	ALLOC(SIZE, GFP);
++	ALLOC_FLEX_SZ(*P, FLEX, COUNT, GFP, &SIZE);
+)
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
+
-- 
2.34.1


