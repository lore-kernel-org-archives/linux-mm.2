Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82BB7CDE001
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 04:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A788E0008; Thu, 13 Nov 2025 23:41:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4AF08E0002; Thu, 13 Nov 2025 23:41:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3A998E0008; Thu, 13 Nov 2025 23:41:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2288E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:41:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D48F13A2F8
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:41:30 +0000 (UTC)
X-FDA: 84107963940.13.A53B3DC
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf08.hostedemail.com (Postfix) with ESMTP id EB838160006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:41:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2025102301 header.b=K9SDNwe0;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf08.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763095288; a=rsa-sha256;
	cv=none;
	b=3t8idclGbYVRuzWoqUhRMO0SYePfRGCNLzflUZe39P3cjE9AETcW/fuSxHF+OTvTzUKwy9
	nnHtpvcm80avQnQpI9Jce9433o1eaT0DzxnnviJsksnn98uUr097mK5S5+4FcLBMGV+H19
	TUpr0gh3e0lFvhFEcMtPj8WcCsLgRbA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2025102301 header.b=K9SDNwe0;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf08.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763095288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97ZI1DV37mgHB4KO9c/1pz2K9royVseEBh1e0LpLLFY=;
	b=biZAkOxNLVqEaBfU39BgG6Nw5C0dtQHD20RMwtRhjjGPxc5C4Uzia/GN5VLn75pP2N3Tv8
	tk1WlpIJggaR9hPmoAtsOT+H7nwPw2YxPpgRWy4gl6qwhZxz2aCPiuKyWTYhe1v7pq/UXu
	fsz6XqL2dk9tbr/si/kyalE1lXBWhVY=
Received: from ehlo.thunderbird.net (sfsymphony1.static.monkeybrains.net [208.90.214.66])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AE4ed9U1921817
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 13 Nov 2025 20:40:40 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AE4ed9U1921817
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1763095241;
	bh=97ZI1DV37mgHB4KO9c/1pz2K9royVseEBh1e0LpLLFY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=K9SDNwe0uGJQ2fMWwnT4JB22olsFwwuaIMoDVSofKYVvzJBQh0AjCIjlGAiTONRFk
	 pjaXbCJqqa1MzalVsK/xAH0VsE7Wub3xLGOn9jhvIJ521q/yFQ+DeRPGZ2N1RbEURc
	 /h3oMUwbjuOjC41rjTLUVMjf6P3PBtFTIr0Oc560y2SJUIyjTfJWidv3nTgPjcoU4Z
	 5EXa5R7UPU7lV9QJq+OVRjEwSDjd93twS2BLsApC7ksEzsvw+MkWLkh5O544nTs+F7
	 XGxUGP2jHOkcU+eSxsnHCkLkoT0ts0zBCZTZydTumVY6+rDtqLqMOoHhf9XlDIC4Za
	 4BFNvVnh8j//Q==
Date: Thu, 13 Nov 2025 20:40:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Uros Bizjak <ubizjak@gmail.com>,
        Alexey Makhalov <alexey.makhalov@broadcom.com>
CC: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?Q?Thomas_Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-sgx@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 7/9] x86/vdso: abstract out vdso system call internals
User-Agent: K-9 Mail for Android
In-Reply-To: <CAFULd4bfxaSy0kkVjfjqgHe=3iT-QcGAhbK9WFepPmZu7=ocjw@mail.gmail.com>
References: <20251112043730.992152-1-hpa@zytor.com> <20251112043730.992152-8-hpa@zytor.com> <CAFULd4aMOueG5y3K7F57ryLtt-JUhE-yfsDODC=5+bgjF_gtSw@mail.gmail.com> <d5531acf-cd79-428d-80d1-eb7562cf3922@zytor.com> <CAFULd4bfxaSy0kkVjfjqgHe=3iT-QcGAhbK9WFepPmZu7=ocjw@mail.gmail.com>
Message-ID: <B00D1422-204D-4ACE-AE00-94ACEA7430F7@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB838160006
X-Stat-Signature: y46nw6oeiraqmf1dy5pczocbkjfm1z9e
X-HE-Tag: 1763095287-762887
X-HE-Meta: U2FsdGVkX18Jc1fdi59q3o8d6BoZgmmVgl5IoXYEdhPPZNja4q2qLmNOEfwEbg9J4qMJ6TzfJOFCUpxgICaDIPs8S1KdTehjUFQqmCeQO2OME5rrut5IYSt5R6LHxdjJEWVmjjkjsKkbnZiygkGb88bpU33vPtJcMlgINk4ZAMbu0VhrrL4+LC6BDHdh1NGGwjvAZyEoObkJsF5vjl/hQ8MU+rxVt65rtVir+oSsUl01pv9N6h/4iBnURKo4c6OYAtACdW0pn9V/rmthMVC6RIlsn3KOx7BfVGMZR+qZaxpigvdw0rPxrLhMttwsCwroDFVcscS3bAxs255Ya/I88JYuzsD1RK+3Ri9L2SVYcr+01JzUCoWhVf55jrBq7hsR32fY1lvq4Bt8g0bRta0pobEiwoWHC7cToHAtgmO+szwi1IJ0fa4lqpYRt26sNTOUp08wUQT8uVfDhS7PCPbwT2vmH7hCh5ryeKJuV1M/qs0Stj6/FZYccK65yYbILncOa/YtlGmOLb5kM4Yly/UGLjNHNYBK1geZh+OryvNlBQ3UDudMv5VArCAsz2gIhJKOUXwBD8eaYnp6ldvC8YqkbQSGQWWvcNPoxjusVq0NTmpMUkvz/7TnhhcJPRfdSdTyA0QJjKwgBkcABvawkjo3FNJdX5aMU7Iu8ZQwr7HFQvov9DNlsbRJ/ksm0ylI8ihhdN+Ylp1lhBFRUFt1037cHCEeiCZfnRW40P+pnU3qv9ePnY6qEjZa76lbO9F5sY6BaSsh20dkgCO6cqzT+zL+WjD3fLZZzBpBIujBAdsX/ESxSMSqpTSIHsUqmSa/iDApsngAROWtIaETKDRQy64phfQszAaULJPDX5e09me/T4O67nNNFmvP3Vg9/DrwYOnbe5Zpqig16USjWXDkFOzt3rvXqtp7CNusRGARgi+giHK1omtD+g5S9ZXJxInHBmgdi8iUrWrmMih4AsB7AlZ
 ilxlgfoa
 1pcAeYUA9DObCk4daKZvQU0aCWjPKNUixfO2V1jpcVB29A/whmrlL1YHXnGC+o1k+FyNrrOU//cmmu6q/sE8xq3ICxDGNDrh9gzz0vsxZu+1w95qZGZPrLPmYHt5O+cTxYDZB3vtXs9snSFYV+DPCjweB5cqzPcjV4WUwAy5sYK3LqdaYTpfIAnMXd04Fuq7ajZ8XPF8ExmYKaZ1eLpk3qvaLv1GP2IcpnNF/MlxifSYWvZH0xAJAdMRtIVIMeZRZ/klaFVUHEsUKshIcQTQxyobjEneEhEBjvahV29lS451NMVlu38jyTuYeyi+GsMHWUwK/cjNkDj5TiH1i8x1ZRoWQPxxir2HS+cIHuYt2Apt80DbBVG7wCxorgpyV5TZHHGFO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On November 12, 2025 11:15:08 PM PST, Uros Bizjak <ubizjak@gmail=2Ecom> wro=
te:
>On Wed, Nov 12, 2025 at 10:25=E2=80=AFPM H=2E Peter Anvin <hpa@zytor=2Eco=
m> wrote:
>>
>> On 2025-11-12 02:31, Uros Bizjak wrote:
>> >
>> > Unfortunately, %ebp is still special with -fno-omit-frame-pointer, so
>> > using "ebp" as _sys_arg6 on 32-bit targets will result in:
>> >
>> > error: bp cannot be used in =E2=80=98asm=E2=80=99 here
>> >
>> > Please see how %ebp register is handled in
>> > arch/x86/include/asm/vmware=2Eh, vmware_hypercall_hb_out() and
>> > vmware_hypercall_hb_in()=2E
>> >
>>
>> #ifdef CONFIG_X86_64
>> #define VMW_BP_CONSTRAINT "r"
>> #else
>> #define VMW_BP_CONSTRAINT "m"
>> #endif
>>
>>         asm_inline volatile (
>>                 UNWIND_HINT_SAVE
>>                 "push %%" _ASM_BP "\n\t"
>>                 UNWIND_HINT_UNDEFINED
>>                 "mov %[in6], %%" _ASM_BP "\n\t"
>>                 "rep outsb\n\t"
>>                 "pop %%" _ASM_BP "\n\t"
>>                 UNWIND_HINT_RESTORE
>>                 : "=3Da" (out0), "=3Db" (*out1)
>>                 : "a" (VMWARE_HYPERVISOR_MAGIC),
>>                   "b" (cmd),
>>                   "c" (in2),
>>                   "d" (in3 | VMWARE_HYPERVISOR_PORT_HB),
>>                   "S" (in4),
>>                   "D" (in5),
>>                   [in6] VMW_BP_CONSTRAINT (in6)
>>                 : "cc", "memory");
>>         return out0;
>>
>> That code is actually incorrect, in at least two ways:
>>
>>
>> 1=2E It should be conditioned on frame pointers enabled, not x86-64 vs =
i386=2E
>> 2=2E The compiler is perfectly within its right to emit an %esp-relativ=
e
>>    reference for the "m"-constrained [in6]=2E This is particularly like=
ly
>>    when *not* compiled with frame pointers, see #1=2E
>>
>> A better sequence might be:
>>
>>         pushl %[in6]
>>         push %ebp
>>         mov 4(%esp),%ebp
>>         <stuff>
>>         pop %ebp
>>         pop %[junk]
>>
>> Then %[in6] can even safely be a "g" constraint (hence pushl)=2E
>
>If we want to also handle x86_64, the above code (including push)
>needs to be 64-bit, with "rme" constraint for the pushed value=2E
>
>I have CC'd the author of the above code, he might be interested in
>the above discussion=2E
>
>Uros=2E
>

For 64 bits, if you need frame pointer support *and* frob %rsp, using:

xchg %[arg],%%rbp
<stuff>
xchg %[arg],%%rbp

=2E=2E=2E is probably easiest, with %[arg] in a register=2E

