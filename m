Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16042FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 21:38:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4773B6B00CB; Tue, 28 Apr 2026 17:38:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 428696B00CD; Tue, 28 Apr 2026 17:38:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316776B00CE; Tue, 28 Apr 2026 17:38:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E8D06B00CB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 17:38:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE3921A045C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 21:38:03 +0000 (UTC)
X-FDA: 84709277646.14.828DC1B
Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6F4E01C000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 21:38:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=BKpyABXY;
	spf=pass (imf21.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.85.4 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777412282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m2SIkG8G4dme99QjBJF700FHzCmI2Nw1YXi++Sm72C8=;
	b=c+IRZR8w5+XlsGHQPpNXq/kREEBGHKfo8XHkOhkOd3Z0POu1p8DRRrXyEmVfRJ1U+6W40P
	yEANgxQntQlfrwKmOaMqjVGxIrZrNTr1fleSNoCP+KXxSiEnLhnW9lPSn+yls0dRmsZqC+
	zc4yT0OTCewqMN5d66fF3BOFiZ6SQNY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=BKpyABXY;
	spf=pass (imf21.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.85.4 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777412282; a=rsa-sha256;
	cv=none;
	b=iI4IJQ9Wc/IcfWgdvEhighIo5cCbzHEUlJgIJBvBcOPovLVmaPWki51iYhPD85A/0eSCMl
	QXjvY3OtyUORqoHIXDpa0VShfEyXf9hfBe+VrWvoGBf6zSqNDeim8Qv+ZVkeU0HqvOOaNQ
	4/+0BYz0eVvMO6uo32LLJwFmObrM6wE=
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 4CDAD4E42B64;
	Tue, 28 Apr 2026 21:37:59 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id E94DD601D0;
	Tue, 28 Apr 2026 21:37:58 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 049BC1072939F;
	Tue, 28 Apr 2026 23:37:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1777412276; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=m2SIkG8G4dme99QjBJF700FHzCmI2Nw1YXi++Sm72C8=;
	b=BKpyABXYUA3W1yBGbOawA4h4lg+xP/ujDg9fnM/GDmfVvQtFe4V86zv2jRnYLbIW85egeu
	gzsW7by84jCsCEyDe38rcP0G9Lu0O5PyhiJVlX1VH0lqEiLpLLVqCPQ6zb2WFjm+11Eb5Y
	n8RhoTuzI6NlP3mUu2V0iIjtY0wmrD64vrUUDjJFf8c9e/GfSIul/+IfTbDMPsSiDwMCw7
	iSMV2XUHFoLSDmaAwdjiKsMThFnyCYBB9t0d5djhof0yNcYWt/373RotXiqc8RA8Tj6M7F
	lFivzfSQqW2W19Ln1HG5awMplQ6C4gwNMrAWCyzv+PL9twiFGEXnUYVU/us/rQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 Apr 2026 23:37:43 +0200
Message-Id: <DI5429HR7UGP.IJHX75ZB16AZ@bootlin.com>
Subject: Re: [PATCH RFC bpf-next 2/8] bpf: mark instructions accessing
 program stack
Cc: <ebpf@linuxfoundation.org>, "Bastien Curutchet"
 <bastien.curutchet@bootlin.com>, "Thomas Petazzoni"
 <thomas.petazzoni@bootlin.com>, "Xu Kuohai" <xukuohai@huawei.com>,
 <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-stm32@st-md-mailman.stormreply.com>,
 <linux-arm-kernel@lists.infradead.org>, <kasan-dev@googlegroups.com>,
 <linux-mm@kvack.org>
From: =?utf-8?q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>
To: "Ihor Solodrai" <ihor.solodrai@linux.dev>,
 =?utf-8?b?QWxleGlzIExvdGhvcsOpIChlQlBGIEZvdW5kYXRpb24p?=
 <alexis.lothore@bootlin.com>, "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Song Liu" <song@kernel.org>, "Yonghong Song"
 <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>, "John Fastabend"
 <john.fastabend@gmail.com>, "David S. Miller" <davem@davemloft.net>, "David
 Ahern" <dsahern@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
 <hpa@zytor.com>, "Shuah Khan" <shuah@kernel.org>, "Maxime Coquelin"
 <mcoquelin.stm32@gmail.com>, "Alexandre Torgue"
 <alexandre.torgue@foss.st.com>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Alexander Potapenko" <glider@google.com>, "Andrey Konovalov"
 <andreyknvl@gmail.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, "Andrew Morton"
 <akpm@linux-foundation.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
 <20260413-kasan-v1-2-1a5831230821@bootlin.com>
 <7dd64547-25a4-46de-a896-98fcec04468e@linux.dev>
In-Reply-To: <7dd64547-25a4-46de-a896-98fcec04468e@linux.dev>
X-Last-TLS-Session-Version: TLSv1.3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6F4E01C000F
X-Stat-Signature: asm334ufgcmoi71r8zhneedu5ximia5z
X-HE-Tag: 1777412281-508482
X-HE-Meta: U2FsdGVkX19gcgNU2xBsDED8FE+yu/8mu5elZqhuOG9HRuXNggeiTcG77Mfdkpv7VpIIIo9neV9Q3amURO0wwPIaQflncDr8jrpxxWLDam8qp2lWakQ9HKGciQi2id/ac5LadAQRY0gm7lzaQJIymHZCiajw4/Gy6D0dHdbyX1yEUkppf8IKs/GvbqpWmc3doBc3ekNCS3Ljvul2DaUneievVmXSXLHiUAHPLBS8/w99+ghIZiLqThm8P8W5uPl4uqBjIvjDpJ0hfxRA0OxbyRRWWIDIziRMUDkPP+EIDFc5CoifkVNOz6fStzF6T0DeWRTh3MKAly2rrN6HppzQjDBgA0ratmuPi1sdxIjU0QzInTpc9TlX1qQeazvxps924T61ckYfpEP1ZQxEksilP+srvXE2+uPK9xNXJums0ocWxZI+7JJaQPXvW9wWVFz43dXk1Krew13PPG2xyt2wEAfP1Ke0V7rRVqHlzzf6duMtuJ1NSOJySMl8sQmW6I7RYdfdzIa3BqEUHrLYBlAwPmHq+Uvv8qGcbqiyUrtQpgJyVzSvXxRyJUdDXWJo2eWGpUI9Mn3VD1QJ6S4t9rXxxFm+HHzBG7fzSW6bxgBfYtPQJ/WHWAcnn0nhicP6tsV7A6kE8vyKtacG64RCa6pG5GlWy1os1qGf8Vxqs4Rpyd0cfxbv0MDqHrCzNzhkhbznkcApDuwCBq0azhV6KrlA2+wcCWrKPL+RucGJGHqQsxgrYvsK4K94ksft4OOg4L5PEW1CSs1jyumTzU12WvUZv90eXTbMU6wknNhcnbbkUhY3yhQP8RDZ/wYF06TJrZEUsnLNDl9CETLDrJkAcCWAvFrYYy1DCjoPUdbNuJ8shSlq5m4xF3t1HilVra1W0Usz4D13yHWtoRqQ7REGiFybCoiWXcqK2MByilM090PFTyqS2ru0xQlhpMTRWJn2K4Nn4csK1072CohyH1w/2WZ
 yy/80z3Y
 cF6UGgDfTU4YcdskI5Wv8qVIIhqUXNtv59gOrLQs7bdEiNcMLMQp49JftKqU6QtgJG9NoEuPZEnBK2T2gWgLC3jB7g2pxmqEHG0Pd/l/JVLUNNGb5Qw3hgJcmSw8xE2SzcD90jvSYDm4ahjobLVUO8RAbXi3qH9TPkVndC/hNZK2UVE2EvspTxsCV9EWmedn+o8EMPzpR4dGdgBnPlYRfPW5ZtoaCWIZBKsFujCaBL9+bn+Ad/KOJRCwTY1MNHVBdm8t7KODCCVHD96BFfbrSFJqTG18qp7L3P8aJSk98ARb1EJnZyc+Xw8qmU+G5mDYLfR1lzK9evhz8bV5oYmpWFO/pgXcPUybjmYDfre5h6Pq8yc9//oDUSRySN+5Q9IPpnQy94BgHdOTAy2iJ4oxVEW+SlqpDn3k2Tszry/DbR6wFgt2RskvXD4RXueRP0f33AjT3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Apr 25, 2026 at 1:18 AM CEST, Ihor Solodrai wrote:
> On 4/13/26 11:28 AM, Alexis Lothor=C3=83=C2=A9 (eBPF Foundation) wrote:
>> In order to prepare to emit KASAN checks in JITed programs, JIT
>> compilers need to be aware about whether some load/store instructions
>> are targeting the bpf program stack, as those should not be monitored
>> (we already have guard pages for that, and it is difficult anyway to
>> correctly monitor any kind of data passed on stack).
>>=20
>> To support this need, make the BPF verifier mark the instructions that
>> access program stack:
>> - add a setter that allows the verifier to mark instructions accessing
>>   the program stack
>> - add a getter that allows JIT compilers to check whether instructions
>>   being JITed are accessing the stack
>>=20
>> Signed-off-by: Alexis Lothor=C3=A9 (eBPF Foundation) <alexis.lothore@boo=
tlin.com>
>> ---
>>  include/linux/bpf.h          |  2 ++
>>  include/linux/bpf_verifier.h |  2 ++
>>  kernel/bpf/core.c            | 10 ++++++++++
>>  kernel/bpf/verifier.c        |  7 +++++++
>>  4 files changed, 21 insertions(+)
>>=20
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index b4b703c90ca9..774a0395c498 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1543,6 +1543,8 @@ void bpf_jit_uncharge_modmem(u32 size);
>>  bool bpf_prog_has_trampoline(const struct bpf_prog *prog);
>>  bool bpf_insn_is_indirect_target(const struct bpf_verifier_env *env, co=
nst struct bpf_prog *prog,
>>  				 int insn_idx);
>> +bool bpf_insn_accesses_stack(const struct bpf_verifier_env *env,
>> +			     const struct bpf_prog *prog, int insn_idx);
>>  #else
>>  static inline int bpf_trampoline_link_prog(struct bpf_tramp_link *link,
>>  					   struct bpf_trampoline *tr,
>> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
>> index b148f816f25b..ab99ed4c4227 100644
>> --- a/include/linux/bpf_verifier.h
>> +++ b/include/linux/bpf_verifier.h
>> @@ -660,6 +660,8 @@ struct bpf_insn_aux_data {
>>  	u16 const_reg_map_mask;
>>  	u16 const_reg_subprog_mask;
>>  	u32 const_reg_vals[10];
>> +	/* instruction accesses stack */
>> +	bool accesses_stack;
>>  };
>> =20
>>  #define MAX_USED_MAPS 64 /* max number of maps accessed by one eBPF pro=
gram */
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index 8b018ff48875..340abfdadbed 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -1582,6 +1582,16 @@ bool bpf_insn_is_indirect_target(const struct bpf=
_verifier_env *env, const struc
>>  	insn_idx +=3D prog->aux->subprog_start;
>>  	return env->insn_aux_data[insn_idx].indirect_target;
>>  }
>> +
>> +bool bpf_insn_accesses_stack(const struct bpf_verifier_env *env,
>> +			     const struct bpf_prog *prog, int insn_idx)
>> +{
>> +	if (!env)
>> +		return false;
>> +	insn_idx +=3D prog->aux->subprog_start;
>> +	return env->insn_aux_data[insn_idx].accesses_stack;
>> +}
>> +
>>  #endif /* CONFIG_BPF_JIT */
>> =20
>>  /* Base function for offset calculation. Needs to go into .text section=
,
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 1e36b9e91277..7bce4fb4e540 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -3502,6 +3502,11 @@ static void mark_indirect_target(struct bpf_verif=
ier_env *env, int idx)
>>  	env->insn_aux_data[idx].indirect_target =3D true;
>>  }
>> =20
>> +static void mark_insn_accesses_stack(struct bpf_verifier_env *env, int =
idx)
>> +{
>> +	env->insn_aux_data[idx].accesses_stack =3D true;
>> +}
>> +
>>  #define LR_FRAMENO_BITS	3
>>  #define LR_SPI_BITS	6
>>  #define LR_ENTRY_BITS	(LR_SPI_BITS + LR_FRAMENO_BITS + 1)
>> @@ -6490,6 +6495,8 @@ static int check_mem_access(struct bpf_verifier_en=
v *env, int insn_idx, u32 regn
>>  		else
>>  			err =3D check_stack_write(env, regno, off, size,
>>  						value_regno, insn_idx);
>> +
>> +		mark_insn_accesses_stack(env, insn_idx);
>
> I am not sure this can be done unconditionally here.
>
> It may be possible in different states to have different pointer
> types for the affected reg (PTR_TO_STACK in one execution path and say
> PTR_TO_MAP_VALUE in another). And if set uncoditionally,
> instrumentation may be skipped for legitimate targets.
>
> Maybe reset by default in check_mem_access()?

Hmm, ok, thanks, I missed this subtlety. I still need to dig in there to
make sure to really understand how the verifier handles those states,
but if I understand correctly your point, I guess that just resetting
the "accesses stack" flag at the entry of check_mem_access is not
enough: it would make the final result depend on the order of the states
being checked, eg:
- first state being checked result in PTR_TO_MAP_VALUE, no flag set
- second (and final) state being checked result in PTR_TO_STACK, flag is
  now set
- if no other state: insn ends up being (wrongly) marked to be ignored=20

So unless I am misunderstanding things here, the question rather becomes
"for this specific insn, is there any state in which the accessed memory
is anything else other than PTR_TO_STACK". The flag could just be
inverted (ie set to true by default), and reset by any state resulting
in something other than PTR_TO_STACK.

Alexis
--=20
Alexis Lothor=C3=A9, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


