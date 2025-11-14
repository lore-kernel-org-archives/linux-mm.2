Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A160CDE001
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 04:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448068E0009; Thu, 13 Nov 2025 23:49:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420178E0002; Thu, 13 Nov 2025 23:49:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35BFC8E0009; Thu, 13 Nov 2025 23:49:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 242608E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:49:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BA33D14028A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:49:14 +0000 (UTC)
X-FDA: 84107983428.10.D879758
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf12.hostedemail.com (Postfix) with ESMTP id DFC244000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:49:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2025102301 header.b=mcKduUbP;
	spf=pass (imf12.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763095753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5YWWAVRgN8FQz6Otg8fg4nQaM9D7J06Mu/UbfQ9S4M=;
	b=aXDc9j0mha+/OQh7t69OOMu1bwedveGLdFaG6nol4ZMJy65BCQTWqMSo1ar9vg5XJJI3F5
	mojCBzOGgI1jP6IGDq+qEeF+ozhCbUWU3w89rChrpFxWaBT2SOpGk88N3lf2VmDnV3a1vK
	QSMHI7H3/Oy2I6Pv1l4B00Hb78pbzRY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2025102301 header.b=mcKduUbP;
	spf=pass (imf12.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763095753; a=rsa-sha256;
	cv=none;
	b=yXJudK46ZpL6zHTe3BqKuWjQEk0fNSeirku5lTLoEfcneGS/6/GR1GC0pNou5v4YEACFry
	otWkz97A+T+g+0bGYlctymLsvawZbtcDSXiqX9ktUv4qZQF8bimmtFl19uZr+aJp2u7lHI
	lilx1IPEnAn7luBPlXEGUHpETO2oFDE=
Received: from ehlo.thunderbird.net (sfsymphony1.static.monkeybrains.net [208.90.214.66])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AE4mVO61925023
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 13 Nov 2025 20:48:32 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AE4mVO61925023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1763095714;
	bh=K5YWWAVRgN8FQz6Otg8fg4nQaM9D7J06Mu/UbfQ9S4M=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=mcKduUbPOrPu5vaYqEtPHe1BtcZXeJxdyIR7a9GI7ZeS8ygpDymkCX77Tj2qFAQMP
	 6woF4ACuH/huhgocvVOu9Nz4kk9xQaHRNR8vOc1TdB/caNNuLpACwE1ELrFrInIGwm
	 MouOk338h7AJquCSfTGQF2J5lcGIwwgYk4G881hOsnjgiQRrYGCiHruN6B3/K318IA
	 IzBRq/67YGzpfsWpw9SbYErKwB3Ym7gA7MNVhX/wIvctECR/SjKqWpUe3rOJNFG/oI
	 ZQ9jdQbP1gl56CMw9ysfHI9u5WtR6lzi4gFZPr1FRRN2C/4ieQUJkZdEXYyu+mNdSA
	 tASa90L+h0omQ==
Date: Thu, 13 Nov 2025 20:48:31 -0800
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
Message-ID: <6585D209-A4D7-4201-8E4C-F28DC97AED3F@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DFC244000E
X-Stat-Signature: c4fy86sjk63txxgy8cj5akxdseoje8ad
X-Rspam-User: 
X-HE-Tag: 1763095752-145379
X-HE-Meta: U2FsdGVkX1/AicfKo15dfNZ/DfXM3kataDA6eV21tK678j4oRLy17aldZHF9M4PzLC89GEUobfrMaGmdUy2ndBq677pd2fUaP+CKBxf/Sb8l7hVxkZz8gafEArL/kwJRl/wwkqCsf8iClgVcZzvIrZOldwH0CMZxbRjyqHyYV/HAPXHh22RPQTE5Bh4aT5pL+nu0R8yvbM27oJFxAJ4sJ6tbebzpiSvovJqSM+jCs7vFKlfY/UhmT2SVfwlYOOG06wVmMWoFCo8b4VbAKZfAIVhTdODhcNK2W+vzE9LxqO6HO1tEIrqWdQTKEBtX+C/ofIyWn+fi+dYhhBQSuIdjnxupfZCT4MFJvgUIkW7el7DhFj6YNS5B0pKCtJv5Oqxhakn5JOgenBQ8Z7+Ix15OmPmwaiTIIDAPg8/KBF5lBX3tYf9w3Tc/Khxpa7RUF+oKee7Rdx8qVkJXyTe/WhOTqp2hg6chtXq/LcZaLpEPe7ctEbYentjI/MafCKeFehoufrU3B39IZyiJZiJ7CcqGIll1hq3O3sX1PlL75d9xH8wjf5/aW1NlDJ/D7J9R7BchUVM9htvs/VzWbdvYNWCsf+GAvnalfKoFn4Zx/GSGoby6vg1BcakLyv+shgKDWk4xvMxlFOq1uRicR3XDGkgjp7vE/O+uzukyGLFw+67Lja6t50Sv7KWCbbatz31llMFJ+sGxBMsEEzik0BJdpPO28prJ36BlqqEZiM8vnixPOnFANKCEBgySivgPP77V16MkoBXLPkjvf5J9mtR5kTK+mkG1t7PjXzDQWlNKXBXDUISTf+7dsdkJyGzIvtoCejYRWf7yoiurqhWlTyldXEKzAYW6V3vYD57AoNtxh4Eh3IL++75PKq+/JQJkHU4ol870F74ZVuUe+pF6nlE6Eymu2V+oaBEzMo7Arrwl32YpsNreVotASzIaCedVf99ptvolMf60PKbJWR7sg+Df6/u
 6Hx3b4ZJ
 hyfdXF3LGepFBmc19N819CKT70xCCfa+U0wfC8OBCKdhd/y9KnCHVwr5TIwOKvD4ocUZJNdV1oeq9cgpsp4f9tcr6lW/qHI9y8pEZJuqrRjApyVH+HZdGd9v13w1l7pXEF/+UPRQjhO9EMzv4aO3+UukOchVvTxdBLnGLN+Ahmq7JjVG/6VrfrZny1/3X5AKtYthbOQs6q83lXUacIHSKpNU4tHYcflBf71+AvFkKe1DqkFMicKTJp3PRtke1/qvPNveMQoCIhNzhF+AR4SOYc1P9FPnPGP2EEEFac4pt/uka4Y5Xhj9/ernPb5lgqmKkXT7sLhv32lIsfHqcMX9QaLRZuhiAPom/zizZ1f469df2Lt7UfCh+QqZBHB+JV8gxEalo
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

Note: for the specific case of VDSO_SYSCALL6 the %eax value is always a co=
nstant, so:

push %%ebp
mov %%eax,%%ebp
mov %[sysnr],%%eax /* "i" constraint */
<syscall sequence>
pop %%ebp

=2E=2E=2E would be easiest=2E

