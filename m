Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7513606A880
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 22:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=M3qujAI1
Received: by kanga.kvack.org (Postfix)
	id C8EEA6B05B0; Tue, 17 Nov 2026 17:08:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3EA16B05B1; Tue, 17 Nov 2026 17:08:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B906B05B2; Tue, 17 Nov 2026 17:08:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D83D6B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:08:42 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B0AF1A05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:08:42 +0000 (UTC)
X-FDA: 85446001284.17.3C6F09A
Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	by imf07.hostedemail.com (Postfix) with ESMTP id DAA1340003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:08:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M3qujAI1;
	spf=pass (imf07.hostedemail.com: domain of vineet.gupta@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=vineet.gupta@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794953320;
	b=PeYdUaDgS6a0rqoPrTzXESVt6y3dMrB+YZ/oxxXJegEh78WEjt9l3/9UcMdLfmsf6cGDwu
	hA841aM5bwpCA++z6+WBtejwOsKx3J5zKakYoINJvCQqqaxc5SQqOh7CCrXcLIrHPDyw9v
	TCebR+W/y7PdNLumuE9enEsxOCE3jOA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M3qujAI1;
	spf=pass (imf07.hostedemail.com: domain of vineet.gupta@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=vineet.gupta@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794953320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bI8B5pGHz5h1ly//mHf7ndgFx4Rz2ltW2HmUrfyIsQA=;
	b=AXV/RehUTH3wLbMwCu6v3gjXzzWd++DXOJr94nBa0zryE+FaOtNAE4AGmsppAzsaPDbDXT
	KQvtyEFHLwPLA5Hov9V7ykByUhFmacRcXZzHuTrpmqwQ4bOiRr3Vj2Z1mxUFoAdxdGnvIZ
	7WmBEJC3xmnVX2PtSpAahlJ654o2zH0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6n3oDTFw9gSbVu7ljl4fwt44Xt31tv6c5y9tagZDFdI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794953318; v=1; x=1795558118;
 b=M3qujAI1eAiVRSUeR1KRAUAEnb1jINv2xfB6M1rMuIkDL39OO8hpitN0ywH/Wdh9ZqAEhH03
 ciCo0aG/EhCSCabtGg3pLu74jNK6ofZDj3NAY8n5s8y9Efri7hUovj4mC1emwg4EXZK0ls3/l+u
 DI7b2an/LIHq3fDEy3QuZNxE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2bbf6e667b38bebf;
	Tue, 17 Nov 2026 22:08:37 +0000
X-Mizu-Trace-ID: 2bbf6e667b38bebf
X-Migadu-Flow: FLOW_OUT
From: Vineet Gupta <vineet.gupta@linux.dev>
To: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org
Cc: chris@chrisdown.name,
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
Subject: [PATCH v2] percpu: do not put btf_type_tag on per-cpu variable declarations
Date: Tue, 17 Nov 2026 14:08:24 -0800
Message-ID: <20261117220824.609017-1-vineet.gupta@linux.dev>
X-Mailer: git-send-email 2.56.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DAA1340003
X-Stat-Signature: fuzqhpuu45ckokzwc7hc5qp9fum8zd18
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794953319-492231
X-HE-Meta: U2FsdGVkX18bn6NJyIj18U9vN5JO9AR5J9RXpgdP1yo5YKEF3vfaybM1RIsiFqz6YsJfNgYCjg7oPxBSe5L6XmK04xWL1Bvurz2nsplqMZu/cgsxyUFBPnxU+YgqbOe2D2MVdW59657dSLLI2tthi3xEj2KntaWMY4U0jhwU3qSYtNHKv5qBRxC5a7PkzSJQ1az3FUChP345DmG/GV9DuoN2QHLVTyCbuwlPg3W7+lt6FPFPNAdVTWVYTb10Zj4p/fJbOVh9KFfgqIbOpMpRv3v2W5oNVs0P9lLZuLgFPbhIa+ndVQDX04R0KQ6mSuF4oxBLjh1juVqB9UM19bgQCQw1R0VxGdC0GQMjUwvs2szlQeHN7j5UpnahAUu9cJlnQu4SdoGcI+OcCXKcvKH1SzU3yaJQN6Oxw8Og4Z1Qe5hg/tj4peCyCHTGKIxkmXiMX5iEDtM3+rXw1q32EbU0A4aIAI0IQgacDSbhQ+dMDPocJMGO0RgBsrYpXRU05NFtq2Q6wQiEgDYVJ1vnCBkBcLskCwh5wrvpP3ofqpG06i1M/GZ4fbidewqB/j+TrHqyLz/MEqqpufmFjAY4UbcLNjV1yZcs8I13q7rro3+7qhvmpayVn8cW8WMKPjVBMMgdgDapZHnVRViXyDQxENSCPVgI1rwg6z3DMFJtSNbFqKyV5tnyYMc1IzaKtlEh7IAv4kp4Iz/+X+p0EpLjO8mnHBK2PIEg4+WbWWQvzthDQK37DFEbm3GBfYqTMTW85ctnX5YFOKBBSBxvtkh82M17Wd6iHEmp/K99BMbIB06un2spieYuRIqJ9svxonruJ0WWQ+iRFJQ2Oh+4pt77LQ155LQAZNmvPA5iZLRU3D5zI9PY0S0fS3SSHbUtrHtA60xWD3nAX5djoD3xKZjC56MMqguUkRIC4cMEb8797VIVKfKQjGYUafV8PygznJCGS7c+JDSFZGgpS0apx44615D
 Pt6vqR41
 RTasVoropvQq2t6JDzmIcliDepHl0cBIvckjYV/uyyCp1LwedjXvfWO7IBHzls7a6w5nRTuNBkDw8SybUVxcTolAYKlXqv96B6eVRwZr+ocTx/A2dv84+V/OQ3xO9qM5u5Iz4rJBj06roCcZVOUW8J86vYsWhoQMTr1zAUmskCuHGhH303pjToYxhTLY8kw98gFXRMuFdiHqCPIp9nTV+OppzUSgdzX0SVO4ji4SQOL9m77xOo5eaUwB6NobPbtRJ1bGHVM+DHLxUwlvdSkHs7BU8BO/yDfRRlVcEnTby/qbnOjQAVekPG3rEfObhlRMy30tlv6dh4qPYD8G1IucQnE85Xqcb5AfyHo0UkWMq4g9E8+c=
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

The compiler is right to object to a type tag on the aggregate, and the
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
shrinking by 3360 bytes. They are the derived pointers -- clang never
recorded the declarations themselves. None of them were reachable: a
record points at a type only if something is declared with it, and
nothing is declared with these. The 803 places that do declare a
"T __percpu *" keep theirs -- the 110 tagged pointers that something
references are the same before and after. .text is byte-identical.

Signed-off-by: Vineet Gupta <vineet.gupta@linux.dev>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
---
Changes in v2:
 - Dropped the "message is confusing" sentence: GCC's "after definition"
   refers to the definition of struct cpuinfo_x86, not to the declaration
   of cpu_info, so the message is accurate (Chris Down).
 - Dropped 2/2, "local_lock: do not put btf_type_tag on the lock guard
   type". Only the tag on the typedef generates a warning, and that
   needs a GCC fix [1] anyway. The pointer usage "T __percpu *" is fine
   (Chris Down).
 - Rebased onto v7.4-rc2.

RFC: https://lore.kernel.org/r/20261110012235.1024461-1-vineet.gupta@linux.dev/

[1] https://inbox.sourceware.org/gcc-patches/20261112191815.884167-1-vineet.gupta@linux.dev/

 include/linux/compiler_types.h | 8 ++++++++
 include/linux/percpu-defs.h    | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index c5921f139007..b250d6870324 100644
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
2.53.1-Meta


