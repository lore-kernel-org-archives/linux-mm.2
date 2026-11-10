Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E743C60A5BEB
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OL68jl5e
Received: by kanga.kvack.org (Postfix)
	id F13E36B05B5; Mon,  9 Nov 2026 20:22:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC36A6B05B6; Mon,  9 Nov 2026 20:22:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2B96B05B7; Mon,  9 Nov 2026 20:22:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF8B16B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:22:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 364A6C0812
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:22:57 +0000 (UTC)
X-FDA: 85417460394.10.18298FC
Received: from mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	by imf01.hostedemail.com (Postfix) with ESMTP id 13F9040008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:22:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OL68jl5e;
	spf=pass (imf01.hostedemail.com: domain of vineet.gupta@linux.dev designates 95.215.58.12 as permitted sender) smtp.mailfrom=vineet.gupta@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794273775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yIKtvc1ZmRXWfGxWgiVO8Ns8HZpEqAzhWlHpQ46fpV8=;
	b=tYCOjCCFyANjpr5t6HwJfb+mMtEyY8BpMDR6KWlom2IpZsXDKu0mZce3Q8Dn/BJsH1AJJG
	UT8VgBgbRJyYNZmgk8FEo0219cMeSjMUaX0rXDr6wMblqpfF0g3B3tOnhlS29IHV7xwc63
	3VRM0BI2YPigeJw0c4sVSlf2EbIw1ag=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OL68jl5e;
	spf=pass (imf01.hostedemail.com: domain of vineet.gupta@linux.dev designates 95.215.58.12 as permitted sender) smtp.mailfrom=vineet.gupta@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794273775;
	b=o5UbjxJLffqqvYjtkFXde561DkJkxyLI9irY0f9npEZl277eS80NidWr81LmWP2QLIjXMD
	SzFavc5w3/ANCjxCtrsRZlCop2zjHiYIo4m7GKGEW2Q8uyNOQYgeCBShV49X2RYUzn/imR
	qrnX9J7QOwnxbfZocnY90J9abhUU8sw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=omlSFSzGf7aOUZjYbn/5+K5lXnf2XWvd5GZpuA4NvOM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794273773; v=1; x=1794878573;
 b=OL68jl5eOqQZJ8A9g06Dd+WgTgxJL2Uk13W8O4uZ8gCgG7u7mC5vZa0rgv/TC/y59jdd0B4e
 98g5lAgc1CnXpqmBJ+TTw6PkiaVSTjM07JhLHtpkacUSfhiaHGLZQzg9Ag0u/I/X1uxhVACOSll
 U/WNubHTjqr+do/A+UucvENs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0dd2321632bd0456;
	Tue, 10 Nov 2026 01:22:53 +0000
X-Mizu-Trace-ID: 0dd2321632bd0456
X-Migadu-Flow: FLOW_OUT
From: Vineet Gupta <vineet.gupta@linux.dev>
To: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	peterz@infradead.org,
	mingo@redhat.com,
	will@kernel.org,
	boqun@kernel.org
Cc: longman@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	ast@kernel.org,
	andrii@kernel.org,
	daniel@iogearbox.net,
	acme@kernel.org,
	yonghong.song@linux.dev,
	eddyz87@gmail.com,
	martin.lau@linux.dev,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	llvm@lists.linux.dev,
	Vineet Gupta <vineet.gupta@linux.dev>
Subject: [RFC PATCH 1/2] percpu: do not put btf_type_tag on per-cpu variable declarations
Date: Mon,  9 Nov 2026 17:22:34 -0800
Message-ID: <20261110012235.1024461-2-vineet.gupta@linux.dev>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110012235.1024461-1-vineet.gupta@linux.dev>
References: <20261110012235.1024461-1-vineet.gupta@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w1i3fa7zmgd4cf5b3is36yngr7uu3gdi
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 13F9040008
X-HE-Tag: 1794273774-96540
X-HE-Meta: U2FsdGVkX1/RSgR2kDAxuFy5WiMUGQndGshUcyJbLpWRA7zhLNeC4zh6xN/cB1AI6jBslIHMA06vsBS1TgAO3wFmzktlnPPyGBcihBOqITwJ/KuP8ttE8J8oG3rkpIH/9iv+fnqN182x96/nHtWuRC8EEj9hEZnxvgZqgsdJ+cxHpm60b93SsQCgdYseGmcCeK31tLD+DzGFjKSIgBjrtlXTZrv0379xl0nseCc6JoplE8Cz0u/uJs7oEkZ44TLp5q4Bjxvj3BzzFxc/bwhnFMUzc3QIh3ROazN38sKkoWRZu3MY2S+n6TTa2wK2UTOyI/vOjp/N4EcPSBNjW64+vC5TbDAE4EWo7DTqs/WZcxYyWxrZU9xA1XJ6mrUxe1OGV7W5hdSgeMBSRMx35yCMR7Ppz03HYESRgFaxjnw3moLaJdV4oun7mZrCV6fV8ikZghs0TiZtmSrmjt9pQ8ihCqbiSIDhWxYdOBGHm05MhQlFNQVnzSbRiuopQVwGEy4Ytx9/COMQo8A4LTQ83hFb5o6z22TJYIuCtTLrbrOeTUGXKYWoiKnVgUOfuO7w6ovCYDFcYJyP6PAqZRCfxKmgch6hWhQ+miBUhlVX7Xvf7Vq+nmGCnCvtqwR/nHStd1ArorwwrQo/IbS3BPKmlaDzNFJYh+Dcb2LseXjZSxLP4S3XkeWQZLnunGZpr1IfObKwuA2sTQkdcbLmIgjO/S7PoJ1k6A2qhRKY/og84fhORdg13uSmHqA6XQ1HRBMoUVTWlxriq+gNUIgOh1WHpgXkl0ihXZ6mOUx9xzgApSFhQkm43SZt+D9QC+VBCTcJELgQiq1p/fjSgm1Tc0GmNEG3Dsb9enf3JuqUsDxVAaZmP01RPn9x6vrYjQreC0X4IvVKEyHSfKKZUmdR0P3Oh1IsRibHhWzg58FcMY4ki7xvPBgOwVslZn6G1e0XmBQgTtKAMmU7HcfU+xpBgfHd6IQ
 x/iAbq1v
 7QBysFdkt4TEHBPXs44xJdfIvVPN7mu3kFxXSPkhltVvW2+TjMWV9L3d1qa0xb2pDWKq7RrU4vIMw9DTEropjoceRx7nGlRSrlIfuzqDlnRL+Kl/mNrWAycPRVvoA48WFplOg6ZNe7ymcw2VB8xWR7C4cXwjZJJ50201a/FndfVnT8EBB6yBn+xwItermM/WSSDutR7E7PVKzxw+0XS65eJIzmJsVq4r7W8U9/TPHPDAYwjAAtz4zNm/ogsDLbeW9nDsVTQENdglYeBAhG4wyMCceLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__percpu carries BTF_TYPE_TAG(percpu), which records that a pointer
points to per-cpu memory. __PCPU_ATTRS() applies __percpu to the per-cpu
variable itself, so DECLARE_PER_CPU() and DEFINE_PER_CPU() put the tag in
declaration specifier position on the variable's own type.

arch/x86/include/asm/processor.h has

	DECLARE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);

which an x86 defconfig preprocesses to

	extern __seg_gs __attribute__((btf_type_tag("percpu")))
	__attribute__((section(".data..percpu" "..read_mostly")))
	__typeof__(struct cpuinfo_x86) cpu_info;

and GCC warns:

	processor.h:232:36: warning: ignoring attributes applied to
	'struct cpuinfo_x86' after definition [-Wattributes]

which -Werror turns into a build failure.

The message is confusing: this is a declaration, not a definition. But
the compiler is right to object to a type tag on the aggregate, and the
issue is fundamental: every variant of an aggregate shares one DIE, so
there is nowhere to put it. clang drops it silently and GCC warns.

The tag is meant to record that a pointer points to per-cpu memory, and
cpu_info is not a pointer.

And this gets worse: for a pointer-typed per-cpu variable GCC attaches
the tag to the pointee, so

	static DEFINE_PER_CPU(struct bpf_hrtimer *, hrtimer_running);

comes out as PTR -> TYPE_TAG 'percpu' -> struct bpf_hrtimer. The truth
is the other way round: hrtimer_running lives in per-cpu memory and
points at ordinary memory, while that record says it is an ordinary
pointer to per-cpu memory. clang emits no tag there at all.

Add __percpu_var, which skips the btf tag (__percpu under sparse) and
use it in __PCPU_ATTRS(). The cpu_info declaration above becomes

	extern __seg_gs
	__attribute__((section(".data..percpu" "..read_mostly")))
	__typeof__(struct cpuinfo_x86) cpu_info;

The pointer spelling, T __percpu *p, is unchanged and keeps its tag.

Before this patch the tag also qualified the variable's type, so &var
had type "T __percpu *", and a pointer does have a DIE of its own:
pahole emitted PTR -> TYPE_TAG 'percpu' -> T for each one.
this_cpu_ptr(&var) is that shape, and that is where the records came
from.

Those are the records an x86 defconfig built with clang loses: 280 BTF
types, 140 TYPE_TAG and the 140 pointers carrying them, with .BTF
shrinking from 6831660 to 6828300 bytes. They are the derived pointers
-- clang never recorded the declarations themselves. None of them were
reachable: a record points at a type only if something is declared with
it, and nothing is declared with these. The 794 places that do declare a
"T __percpu *" keep theirs -- the tags reached by a STRUCT, UNION,
ARRAY, FUNC_PROTO or another PTR number 117, 6, 3, 39 and 5 before and
after. .text is byte-identical.

Signed-off-by: Vineet Gupta <vineet.gupta@linux.dev>
---
 include/linux/compiler_types.h | 8 ++++++++
 include/linux/percpu-defs.h    | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index c5921f139007..0a18b3f10675 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -50,6 +50,7 @@
 # define __user		__attribute__((noderef, address_space(__user)))
 # define __iomem	__attribute__((noderef, address_space(__iomem)))
 # define __percpu	__attribute__((noderef, address_space(__percpu)))
+# define __percpu_var	__percpu
 # define __rcu		__attribute__((noderef, address_space(__rcu)))
 static inline void __chk_user_ptr(const volatile void __user *ptr) { }
 static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
@@ -68,7 +69,14 @@ static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
 #  define __user	BTF_TYPE_TAG(user)
 # endif
 # define __iomem
+/*
+ * btf_type_tag records "points to per-cpu memory", so it belongs on the
+ * pointer spelling only. Declaring the per-cpu variable itself puts the tag
+ * in declaration specifier position, where clang drops it and GCC attaches it
+ * to the wrong type, so __percpu_var leaves it out.
+ */
 # define __percpu	__percpu_qual BTF_TYPE_TAG(percpu)
+# define __percpu_var	__percpu_qual
 # define __rcu		BTF_TYPE_TAG(rcu)
 
 # define __chk_user_ptr(x)	(void)0
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index dbe3267a0a13..f53fc430aaad 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -45,7 +45,7 @@
  * that section.
  */
 #define __PCPU_ATTRS(sec)						\
-	__percpu __attribute__((section(PER_CPU_BASE_SECTION sec)))	\
+	__percpu_var __attribute__((section(PER_CPU_BASE_SECTION sec)))	\
 	PER_CPU_ATTRIBUTES
 
 #define __PCPU_DUMMY_ATTRS						\
-- 
2.53.0-Meta


