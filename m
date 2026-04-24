Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E85DFF885A
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 23:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF7BA6B0005; Fri, 24 Apr 2026 19:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8506B008A; Fri, 24 Apr 2026 19:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBDC36B008C; Fri, 24 Apr 2026 19:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA4106B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:19:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34F4412014C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:19:03 +0000 (UTC)
X-FDA: 84695016966.30.F537F89
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 49FD4120003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:19:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lAdngFjW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of ihor.solodrai@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777072741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3XVMe3dGeABivLaYIdooN1MvQa1CctnziG70XU09po=;
	b=5AgYwgduKg1O+mWCc1v9wd+MBTyPEF/+b2BS4/hjtukqVKzaAW4GIdticImaN46TdRdscm
	hu+s1IFLrGDK+p5Qc4z4WYVKdEYIwZW4QNzJSZISm3yivNuVY+nihT0WmhA0bECcJW5lfg
	TmsFQlLgeDb2dXXSI53AI0WJ7WL6a/0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777072741; a=rsa-sha256;
	cv=none;
	b=biT8lQGdHdc7qyhSkyYopedIwiIBj8eic/scELaa/N9ofgOXHVXN8AN1PH5mFseR6Q9AH6
	M8yX8RGxZC7w0ZVnveOncU9jclZ1XcWR2apql7Ew9ljtTmpLISHai78W1rdU4+n0NI9U+L
	3WUGR7UEt3Iu+HdO9TQ1WYjMvhYmhYw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lAdngFjW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of ihor.solodrai@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
Message-ID: <7dd64547-25a4-46de-a896-98fcec04468e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777072738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P3XVMe3dGeABivLaYIdooN1MvQa1CctnziG70XU09po=;
	b=lAdngFjWpn+SFIEIgyjCn6oyJ7s6mP8JViggHzKVI1eQOG8r8fZE96FmVDJRHvA5PSglKz
	UM1P3b5Y3bU4XRPVejznw6aBsaRiopshcyt4CJCQ3+MTz1tCmr61vtPiwmaHEKEmgNqEbm
	tyMnnBKBDxXtgqkPNrAauQU71Wd0y8w=
Date: Fri, 24 Apr 2026 16:18:29 -0700
MIME-Version: 1.0
Subject: Re: [PATCH RFC bpf-next 2/8] bpf: mark instructions accessing program
 stack
To: =?UTF-8?Q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?=
 <alexis.lothore@bootlin.com>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman
 <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
 Jiri Olsa <jolsa@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Shuah Khan <shuah@kernel.org>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: ebpf@linuxfoundation.org,
 Bastien Curutchet <bastien.curutchet@bootlin.com>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Xu Kuohai <xukuohai@huawei.com>, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com,
 linux-mm@kvack.org
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
 <20260413-kasan-v1-2-1a5831230821@bootlin.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ihor Solodrai <ihor.solodrai@linux.dev>
In-Reply-To: <20260413-kasan-v1-2-1a5831230821@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 49FD4120003
X-Rspamd-Server: rspam04
X-Stat-Signature: uyqty6yrpu5q79pedka4gywjksqwpr6k
X-HE-Tag: 1777072741-636390
X-HE-Meta: U2FsdGVkX1/L+FvL20UlBmWQCvzjC8eXhsD3kkeC7SHxQMnObXGk+Fo9Ipj+xUREI/tqiTzIHQtTX5fyk3AQAS4m8sgeWe+k06HFhARNqWrQ1NM673wDlz7QkoQ/ww6ldqWnB6qk6+j/RFxoqp8ZpfpfRj80uRpEfHL9LqgySSnCGd2QOwm0AKfXRU5neZym8StRRez+eYO7Co3II8k926uvDqWXrP5seRMJ0Ho93x07vHwvD3mdaSGdQ/pq9WZz0JUevhkpBdJj9qYcaSI9AKSzF+Klx5rTgypfNxC50aluwa9V01145hG3jmOlY82hzkoStLN0gZI2plyMX3ulC2oe+25N9awli0JmXKA5G3+RbpcsVX9MyPdLT+wuqmPyv2reBIngm6qbgxCsxX1VbHvHiynGKZ8ji2/h6yiK1UQwznPkFaJzxsTqEOJD9JwBRkiqAZqX2vaKgKRFmNJm/USbOjeHuShAxVEAKX5XvnYtgkaZg/LhFPIN7O3m3ThNwyygoCbbpaRxbmkAbv/lUSuDCbtHX+4vJn0sxKSMzOfdB84rRykGlmFaEgEtAobGoOZusB0qWIDNqAy+5ZCPox89muOKbGu9Wym0b6Vf3uP/smb+i3vuXgHW8E2ODkG44wY1/YYWhg5Fk3nvwrvE6YdyFJ9Gp6GinNbN1Dm/f90CrwjzyxBy7b+pHD+X00LqJO30cWLyI1pib1Ls+166wQQGr/73+UwafUt5UJXIy+xfyumI33TOPp9lT8lhmfmdPjAgTNwCxQYcyy1atYYngGo/9mWbrH6JuCDUSh4Ewoj6NCFHNeHudUefof2JKsOoKfPbfq4E/zzAKuqb9h0X8rSVPjTsIfA4byo20jJ9L5xTGhEJOytPfwo0qKa9zBB2m+0vR+alL5BSsPV5j5+Netm3vGPtJIuRKpv52kM8Z0BxsVkfOpqD9lqi3MQW8RcJGiQaws19v2NyDJiX5pO
 GIuDQ2ES
 CrZl1EgOc1jdsXeixC84xoXc+1YnGS8xFAYsfTrCptbsg+bqsgUtP+GIAtmIjo97CflY85Mf6lXdCNc4vPm+5MEWJgMQFqEMzMbHPyKvjHTK/OoVLLTVVFLFaSAFOmvvS7v0SZUInN+NoDnXB9rsARth4DEMXwa7vraFGgMmzGGrMI4b63idJeZ+lDvdzUJv0+VJqefN7OGTwuiY7eMs4m8WAolyYhJ/F4jsqs188mRe5ETv8Plf+lvUAYSyvzRZPYlpWGl4uQ8qnk+BqWamKd5p/fBWL5L8bIBUwoFsSzqWf/iOZCP97CXdkdbUsIc7dvXvbQ5m5hvIlixcq4mpv+yPFcj18JEXfyyMJOMHyr3LAUl8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 11:28 AM, Alexis LothorÃ© (eBPF Foundation) wrote:
> In order to prepare to emit KASAN checks in JITed programs, JIT
> compilers need to be aware about whether some load/store instructions
> are targeting the bpf program stack, as those should not be monitored
> (we already have guard pages for that, and it is difficult anyway to
> correctly monitor any kind of data passed on stack).
> 
> To support this need, make the BPF verifier mark the instructions that
> access program stack:
> - add a setter that allows the verifier to mark instructions accessing
>   the program stack
> - add a getter that allows JIT compilers to check whether instructions
>   being JITed are accessing the stack
> 
> Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
> ---
>  include/linux/bpf.h          |  2 ++
>  include/linux/bpf_verifier.h |  2 ++
>  kernel/bpf/core.c            | 10 ++++++++++
>  kernel/bpf/verifier.c        |  7 +++++++
>  4 files changed, 21 insertions(+)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index b4b703c90ca9..774a0395c498 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1543,6 +1543,8 @@ void bpf_jit_uncharge_modmem(u32 size);
>  bool bpf_prog_has_trampoline(const struct bpf_prog *prog);
>  bool bpf_insn_is_indirect_target(const struct bpf_verifier_env *env, const struct bpf_prog *prog,
>  				 int insn_idx);
> +bool bpf_insn_accesses_stack(const struct bpf_verifier_env *env,
> +			     const struct bpf_prog *prog, int insn_idx);
>  #else
>  static inline int bpf_trampoline_link_prog(struct bpf_tramp_link *link,
>  					   struct bpf_trampoline *tr,
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index b148f816f25b..ab99ed4c4227 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -660,6 +660,8 @@ struct bpf_insn_aux_data {
>  	u16 const_reg_map_mask;
>  	u16 const_reg_subprog_mask;
>  	u32 const_reg_vals[10];
> +	/* instruction accesses stack */
> +	bool accesses_stack;
>  };
>  
>  #define MAX_USED_MAPS 64 /* max number of maps accessed by one eBPF program */
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 8b018ff48875..340abfdadbed 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1582,6 +1582,16 @@ bool bpf_insn_is_indirect_target(const struct bpf_verifier_env *env, const struc
>  	insn_idx += prog->aux->subprog_start;
>  	return env->insn_aux_data[insn_idx].indirect_target;
>  }
> +
> +bool bpf_insn_accesses_stack(const struct bpf_verifier_env *env,
> +			     const struct bpf_prog *prog, int insn_idx)
> +{
> +	if (!env)
> +		return false;
> +	insn_idx += prog->aux->subprog_start;
> +	return env->insn_aux_data[insn_idx].accesses_stack;
> +}
> +
>  #endif /* CONFIG_BPF_JIT */
>  
>  /* Base function for offset calculation. Needs to go into .text section,
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 1e36b9e91277..7bce4fb4e540 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3502,6 +3502,11 @@ static void mark_indirect_target(struct bpf_verifier_env *env, int idx)
>  	env->insn_aux_data[idx].indirect_target = true;
>  }
>  
> +static void mark_insn_accesses_stack(struct bpf_verifier_env *env, int idx)
> +{
> +	env->insn_aux_data[idx].accesses_stack = true;
> +}
> +
>  #define LR_FRAMENO_BITS	3
>  #define LR_SPI_BITS	6
>  #define LR_ENTRY_BITS	(LR_SPI_BITS + LR_FRAMENO_BITS + 1)
> @@ -6490,6 +6495,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
>  		else
>  			err = check_stack_write(env, regno, off, size,
>  						value_regno, insn_idx);
> +
> +		mark_insn_accesses_stack(env, insn_idx);

I am not sure this can be done unconditionally here.

It may be possible in different states to have different pointer
types for the affected reg (PTR_TO_STACK in one execution path and say
PTR_TO_MAP_VALUE in another). And if set uncoditionally,
instrumentation may be skipped for legitimate targets.

Maybe reset by default in check_mem_access()?

>  	} else if (reg_is_pkt_pointer(reg)) {
>  		if (t == BPF_WRITE && !may_access_direct_pkt_data(env, NULL, t)) {
>  			verbose(env, "cannot write into packet\n");
> 


