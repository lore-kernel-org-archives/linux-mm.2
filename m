Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F255B606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iRZErLHu
Received: by kanga.kvack.org (Postfix)
	id 088306B0829; Tue, 24 Nov 2026 13:35:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038156B082B; Tue, 24 Nov 2026 13:35:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69656B082C; Tue, 24 Nov 2026 13:35:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDBFD6B0829
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:35:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B43B1A0C49
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:35:22 +0000 (UTC)
X-FDA: 85470865284.21.08B69B5
Received: from mta1.migadu.com (out-141.mta1.migadu.com [95.215.58.141])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2D5FC18000F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:35:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iRZErLHu;
	spf=pass (imf16.hostedemail.com: domain of vineet.gupta@linux.dev designates 95.215.58.141 as permitted sender) smtp.mailfrom=vineet.gupta@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795545320;
	b=7/mvRQul/qeXeQp8padiocxXU/jQLCLj2LPUbSC7kEflQFGOeVch77yneJ0FBnxV4Gs+Rs
	fW6t5HRUUD0Od27zUvNKLAV3jEoWG/CQWuOKDqr2AaCI4nSYFAA0wK8/7qUn6zF7+Hy0fd
	zJz71j8ArNg0C3fPuJKCQ8Z3xCPNxxA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795545320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZD9tL3vMl3UtRiIJdtxpjqUODfVXA7ba8Z8pqs7VXsE=;
	b=PIjBwgpOJmHDlpS6Fkeo+6/+4ei/srU4/Ym/5nTYATEmXHlzjAvBFsDx1joIOLlOPyURjb
	j3T4pD5KOtRS5NBprBib/iWcgxHPzfjSEuxUd9M2hOrsETkJ+vFjvW29sgO7GvBtLqP4hH
	2z4S1VcI2zH4MAx/pgABBUthRKdLhf8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iRZErLHu;
	spf=pass (imf16.hostedemail.com: domain of vineet.gupta@linux.dev designates 95.215.58.141 as permitted sender) smtp.mailfrom=vineet.gupta@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GRQQ4ERdsiUnnr2qKIeSLtPr4xietU4WPx/E9/lU1Gg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795545318; v=1; x=1796150118;
 b=iRZErLHuh+Qaf95aB7zVlWe/oB17nxtoFCaUB+VRlj5hXd+bC+U/urdQ29qIDR+nWM/wLp5S
 Odp8XhJuLDLgLQH7PTg8v6tYPZYHOlv+tak2DZjNBkOku6xuEH9r5Rq4x8TDLj6nWAXjjiZf/nG
 e9k9BmZ0+dkLanOKiffBYsYM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 695234c76aa59047;
	Tue, 24 Nov 2026 18:35:18 +0000
X-Mizu-Trace-ID: 695234c76aa59047
X-Migadu-Flow: FLOW_OUT
Message-ID: <59a0bc6a-61d2-462c-92c5-445d29298d85@linux.dev>
Date: Tue, 24 Nov 2026 10:35:08 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] percpu: do not put btf_type_tag on per-cpu variable
 declarations
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: chris@chrisdown.name, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
 daniel@iogearbox.net, acme@kernel.org, yonghong.song@linux.dev,
 eddyz87@gmail.com, martin.lau@linux.dev, nathan@kernel.org,
 ndesaulniers@google.com, morbo@google.com, justinstitt@google.com,
 llvm@lists.linux.dev
References: <20261117220824.609017-1-vineet.gupta@linux.dev>
From: Vineet Gupta <vineet.gupta@linux.dev>
Content-Language: en-US
In-Reply-To: <20261117220824.609017-1-vineet.gupta@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jy35ihhpzg4ckaodc6zam113gm8aj1i8
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D5FC18000F
X-HE-Tag: 1795545319-830825
X-HE-Meta: U2FsdGVkX18ZyDX9mWKzoBBugvFzm9e0BcQG9eWnLiQL9yV91qWyw1OYt3sia2KM4RLgYeyvVAWZaIQMECpCP4BhKBbtzEhRqZVCzWrhWP8uDV+9tDiA60jHFJZdi4oSXgFjdt7OVOKyRJ7T5V9WWC1pLxmu7u/hedPHYlejCDxKQ6wktT2i+kHTNor4vNzT7+LKoEz3QWqHMJXMXAwV+H1BXcGgCxDS9QX0k0T5YO9yWXLYFN1VQkAxHPLpCPtnt8j6ggTQlrm9Xnodq8TjvLI0ZTomG8c6bZa8ujr/RoWIw3DL8K685e7PIi9cfVPVdTEpWV2hRD+8cO3Txqs4a2fiwUzDMEfSUQmYul7tXhBeRQEFQyvVgtee8xHlmzjKnZmL4k9lk8J0+LxSkzUfEoEVqwE0oY8FvI908avr6toCSPx95tH0DNTKD/CQwa+FqpadKcbPm4JeWjIMTl6X66N1u4q+z7xRSCuLyb7PIrbk22lb6xhdb3Y+9fbheMjLTJW4ePIpz268F5QlBHKm5QWdC44LOXw+9n4PcL1NMVXkaBuXOILnewH5y4kQcGJ31fesVMsRpKtl+P/5BoVIpY9S7UkeT6BRKxyQFil1PJq0FWAHxrGtHblD6wl7bJcSh0MY6rq29rHdYjscZf6P5jPv2ruKI+CYoBz07M53e9vaGcZTYO9tO1lkhZ7OEVL5NcaHfY4OL9pVqfzcGC27JBCY5GyXgofCRLqG8wqi3+pTwsLGEhKJw3f9JJ2e2zcdNvMuoKsT3rMlIWG+6sqINpA/R4SkHQEyNl5QTgafNPo/Y+BZcvTPoPjCsh1qg0pzhNyHjeY8EbCoUBrUaMbHbQba2cS0bk7C6/Yez14LmVmo+WFCAKqBkYgLKN8h/wKS4OSJVc6Grn0WCzSMRXYrTFHVAWNssM6JLyMZUpoi7nzv8P6E7eJ17AYtJogNw+I7rrkvqGggjgdl9v4s3tW
 FbYSEnpZ
 7IK1wF/9Mi2D9Qp74SrzMJhcYlzvygH3v+1nYl6QxkFnljMJLIn6jgFxL7i2ZzxR31C6EwQ0vYHhciHSFjgSzQMXCkCyH5ABflpFLcAC2TnzdRn0qLbdCZge3ZoJWIXflEeTDUsMVN+0ASzlG8mvx2QXc38xjn1w1/fD4kOR7CsAB4mUbZ3G4l+UkmOSOH1KdWiDVd5t9ZfbEjSwtLHILKyYrfaZAHZ2k82ajVbj6pKL1AY/z3zSoArSSQXFuWGAo7dW12vuRtTSOtoI0K30Hvm+NrDm2Th0Sgduy2BZPYbrGhUVoOa8Ex+jgJw+GfNxnqittkijhR16auy6fFs0jFhgCa2d8PsYcgt1EtTTkVZROUl89QqCyMEO4dL0NpTy15xk7dOGV3KkyoYbXkOowia/lA/yRlBaZsTwu5kYQQixd0zCTENiY8yc8ckSIJ+EGGsDhcAdMkDRPV4leUujhaexccY+IMKxtwtce8NSzynn++TxCRmAvSIW7fwGzHSchLmpcLqQALHei28U7EZIV7XhIYle1tNlWHCbAOvAMgWmD5CZznq9zq7+XiqtP4F+9duE7/UwJAMUxsPmAapGyjyEDTpUfR3po655ZWQkREavaN4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 2:08 PM, Vineet Gupta wrote:
> __percpu carries BTF_TYPE_TAG(percpu), which records that a pointer
> points to per-cpu memory. __PCPU_ATTRS() applies __percpu to the per-cpu
> variable itself, so DECLARE_PER_CPU() and DEFINE_PER_CPU() put the tag in
> declaration specifier position on the variable's own type.
>
> arch/x86/include/asm/processor.h has
>
> 	DECLARE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);
>
> which an x86 defconfig preprocesses to
>
> 	extern __seg_gs __attribute__((btf_type_tag("percpu")))
> 	__attribute__((section(".data..percpu" "..read_mostly")))
> 	__typeof__(struct cpuinfo_x86) cpu_info;
>
> and GCC warns:
>
> 	processor.h:232:36: warning: ignoring attributes applied to
> 	'struct cpuinfo_x86' after definition [-Wattributes]
>
> which -Werror turns into a build failure.
>
> The compiler is right to object to a type tag on the aggregate, and the
> issue is fundamental: every variant of an aggregate shares one DIE, so
> there is nowhere to put it. clang drops it silently and GCC warns.
>
> The tag is meant to record that a pointer points to per-cpu memory, and
> cpu_info is not a pointer.
>
> And this gets worse: for a pointer-typed per-cpu variable GCC attaches
> the tag to the pointee, so
>
> 	static DEFINE_PER_CPU(struct bpf_hrtimer *, hrtimer_running);
>
> comes out as PTR -> TYPE_TAG 'percpu' -> struct bpf_hrtimer. The truth
> is the other way round: hrtimer_running lives in per-cpu memory and
> points at ordinary memory, while that record says it is an ordinary
> pointer to per-cpu memory. clang emits no tag there at all.
>
> Add __percpu_var, which skips the btf tag (__percpu under sparse) and
> use it in __PCPU_ATTRS(). The cpu_info declaration above becomes
>
> 	extern __seg_gs
> 	__attribute__((section(".data..percpu" "..read_mostly")))
> 	__typeof__(struct cpuinfo_x86) cpu_info;
>
> The pointer spelling, T __percpu *p, is unchanged and keeps its tag.
>
> Before this patch the tag also qualified the variable's type, so &var
> had type "T __percpu *", and a pointer does have a DIE of its own:
> pahole emitted PTR -> TYPE_TAG 'percpu' -> T for each one.
> this_cpu_ptr(&var) is that shape, and that is where the records came
> from.
>
> Those are the records an x86 defconfig built with clang loses: 280 BTF
> types, 140 TYPE_TAG and the 140 pointers carrying them, with .BTF
> shrinking by 3360 bytes. They are the derived pointers -- clang never
> recorded the declarations themselves. None of them were reachable: a
> record points at a type only if something is declared with it, and
> nothing is declared with these. The 803 places that do declare a
> "T __percpu *" keep theirs -- the 110 tagged pointers that something
> references are the same before and after. .text is byte-identical.
>
> Signed-off-by: Vineet Gupta <vineet.gupta@linux.dev>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Tested-by: Chris Down <chris@chrisdown.name>

If this patch is OK can someone pick this up please. I'm not sure what 
subsys?

Thx,
-Vineet


> ---
> Changes in v2:
>   - Dropped the "message is confusing" sentence: GCC's "after definition"
>     refers to the definition of struct cpuinfo_x86, not to the declaration
>     of cpu_info, so the message is accurate (Chris Down).
>   - Dropped 2/2, "local_lock: do not put btf_type_tag on the lock guard
>     type". Only the tag on the typedef generates a warning, and that
>     needs a GCC fix [1] anyway. The pointer usage "T __percpu *" is fine
>     (Chris Down).
>   - Rebased onto v7.4-rc2.
>
> RFC: https://lore.kernel.org/r/20261110012235.1024461-1-vineet.gupta@linux.dev/
>
> [1] https://inbox.sourceware.org/gcc-patches/20261112191815.884167-1-vineet.gupta@linux.dev/
>
>   include/linux/compiler_types.h | 8 ++++++++
>   include/linux/percpu-defs.h    | 2 +-
>   2 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> index c5921f139007..b250d6870324 100644
> --- a/include/linux/compiler_types.h
> +++ b/include/linux/compiler_types.h
> @@ -50,6 +50,7 @@
>   # define __user		__attribute__((noderef, address_space(__user)))
>   # define __iomem	__attribute__((noderef, address_space(__iomem)))
>   # define __percpu	__attribute__((noderef, address_space(__percpu)))
> +# define __percpu_var	__percpu
>   # define __rcu		__attribute__((noderef, address_space(__rcu)))
>   static inline void __chk_user_ptr(const volatile void __user *ptr) { }
>   static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
> @@ -68,7 +69,14 @@ static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
>   #  define __user	BTF_TYPE_TAG(user)
>   # endif
>   # define __iomem
> +/*
> + * btf_type_tag records "points to per-cpu memory", so it belongs on the
> + * pointer spelling only. Declaring the per-cpu variable itself puts the tag
> + * in declaration specifier position, where clang drops it and GCC attaches it
> + * to the wrong type, so __percpu_var leaves it out.
> + */
>   # define __percpu	__percpu_qual BTF_TYPE_TAG(percpu)
> +# define __percpu_var	__percpu_qual
>   # define __rcu		BTF_TYPE_TAG(rcu)
>   
>   # define __chk_user_ptr(x)	(void)0
> diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
> index dbe3267a0a13..f53fc430aaad 100644
> --- a/include/linux/percpu-defs.h
> +++ b/include/linux/percpu-defs.h
> @@ -45,7 +45,7 @@
>    * that section.
>    */
>   #define __PCPU_ATTRS(sec)						\
> -	__percpu __attribute__((section(PER_CPU_BASE_SECTION sec)))	\
> +	__percpu_var __attribute__((section(PER_CPU_BASE_SECTION sec)))	\
>   	PER_CPU_ATTRIBUTES
>   
>   #define __PCPU_DUMMY_ATTRS						\


