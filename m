Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47E39E8304A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 03:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 791F26B0005; Mon,  2 Feb 2026 22:58:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73EBA6B0088; Mon,  2 Feb 2026 22:58:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641796B0089; Mon,  2 Feb 2026 22:58:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 522756B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 22:58:46 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D04275663F
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 03:58:45 +0000 (UTC)
X-FDA: 84401789010.21.7B18212
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8984F12000B
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 03:58:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b="NIQKq/zu";
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf29.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770091124; a=rsa-sha256;
	cv=none;
	b=7Xv2KqrPZOMvXXG5NqDF7eXsouqb0junTQdOmq55LEdIJxCBF3YuxKPwcNrsndqZncndUl
	Qp2ZOSS1/jaY0YNPe76m4jLP26kCNZj/7mEVthdGQpdjnj7K1lDHbXFSi1Hcw2Ob/T6tYS
	mjyYPgMgFD+j+feNhvao27P/gx16NZI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b="NIQKq/zu";
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf29.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770091124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYNk1uESj2SdlyhEUgCh4uBoF2hsXCsmavJNLvewoyg=;
	b=d6vQ/llPpFnt4H5SNr38JKtH2tfK3VnyRJuCon1mkZ2BImI3Y0qxRjC8b+YiNdBSOuuykI
	3+odl2Bj64ZlD/wACzvdar6X1QEcXfxJQJqu5YdhOAa3Izz49x4RbdNnJoLkPH4PoTDtj7
	7sCUJPUy2ZeH/ear1YjTLvoNpUStVm4=
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6133vk3W3170984
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 2 Feb 2026 19:57:47 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6133vk3W3170984
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770091070;
	bh=kYNk1uESj2SdlyhEUgCh4uBoF2hsXCsmavJNLvewoyg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=NIQKq/zu2+acVlOXWh6sSfEQ8JkbE+NqM13UYjoCRqOtnwEXlB/i9XR0vM71yA+q2
	 yo6IE2xbl2AIGaxb4uCbdtgdzHjbjINGCySSmvT2BPogG3MWulce6FQSOv9JoTPcGI
	 hS8NDD2tk0UcT+Lxf/Vd/1Nf+zhNNu+vuh2vs7626ZsBpsiK3SjI8WMXXh6UdHHjBW
	 AL8W7E1fn0ou3GTzdQmIZVOEL06kICoWYk6oVjhQduLuxPl2IuNsthZlnNrm6kFEtY
	 YC/VqQy2lD2fd/IchD2/NZHlYEzNbhZVJff5Ac7J9ZF+Mt+h3VfEJkcC4whVjLQBfG
	 KclzhxHP7IGwQ==
Date: Mon, 02 Feb 2026 19:57:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Jens Remus <jremus@linux.ibm.com>
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
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Claudiu Zissulescu-Ianculescu <claudiu.zissulescu-ianculescu@oracle.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4=2E1_06/10=5D_x86/entry/vdso32?=
 =?US-ASCII?Q?=3A_remove_open-coded_DWARF_in_sigreturn=2ES?=
User-Agent: K-9 Mail for Android
In-Reply-To: <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com>
References: <vdso-cleanup-patch-4.1@zytor.com> <20260106211856.560186-6-hpa@zytor.com> <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com>
Message-ID: <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8984F12000B
X-Stat-Signature: f98u4wtey1os66bap74746es3r3ykhu5
X-HE-Tag: 1770091123-897769
X-HE-Meta: U2FsdGVkX18jLrxUDCxcMkzkKbewCuHCbC86agd+Gou0w6PkTzHNLWpH8lWeP1SBM7rCB9KSVsVvcY6tye5z8vUK3Gn+uQrKx6K0ffcKvnI75VQKk7h7j2rwVbq4++iMjW756iT+x75pTcNLJElPCYzGkolXK9rxwR0Lp+z2a+krxtQO6iveC8Ul84gSLonwRmBR5/kJ8k/p0+9MROaHYZv1jvIfWA0jS70aDZgAYZjz9syoWihDGBLfEgOgCCaxNfbaNobAEr6XbS0XWzQol3p6dwMI/tANcq5UgY5JXDN9CA0+8rPMmFRKKXByMRAGBQfG86ypfFmizKsZp3EdT+jilvCrNcSsf+UT+J+6eGtD8cfFCmpLAXPnk7u55OTK4XRN3FJnXxFqFt7lSgyXjorw5/vTpbqeOHvo70IWhegeEbWswmBW5jW6CD+kjVJIojN6gDfFt/epAO7DvY8tR1PenU5zEugl0ICrkSTV9eO7UvTdM+132Y6qaglDhJNdJeIuIfVTXclyl7sFH2txma8YDIfaGyX42cw5SGOWIgyMgDWeEILLjQlEBdU6RnowbrnKf93UEpY3bIaQgBYJ/3uiiSWQFGGMN07Nu4lFqGiYaXtbRJBIyeL/e4palCom2ASczyUpzHed1Wzov1n7Djzf5axoOXuk5dB482xAvX39lLXrYzxuSx5hiMka9sh9DTgpCL6/rATRuiCYa+7von8pfI9RaumLV7MFwht3M2uo/nKyAGOKImCa3awv6wdXKBU8vWtnMeYzwwu5jpFX6Vnl36+97mgjpx3ZCnp11axK9I7hJqAFOtQXo+V6pbNlN7VF0M73Plxf268jg+JtK/EW2TJ0UDTwzxTEdO5IuWrbbN2Ch32h42Lqp2dtjW7sOXJ98L+hhagRcvrnTwMBx38DMZamuTtYW1JW2DCo5rbz1p/2MsHNeet0fCAo/J7YuYG7HH+Ym5wl56DFmO6
 HaGcxlRJ
 VV1I4Uh07BbWpmpcpwcPsDEunsHTGLA9+L0Uy06zjNxZt7tLYPDOnOfLAT91hMwPY+gi+fAfQYkMIEaefqqlaDURQ8V+FNojAeElh/n+LjgEuqAkUXbp8aUnRw7yrBA+c7ODmaESnpmFc90/Ng+IHJSjbKg7G7jvmzH/UWUXlLzg873qk2vvZhhrGYQinv2nyzn1P3QxeUZGxyPW8TikeLWLrD00l942shC6bpClSZB7tfVt4vgx/GwHjnh3XMRF7KCYXRb26HC53yN3DYpZRyNPJvUydIrWaLyzbakEYeyF+u8bALDWg5AbmxytpELljquWhZqVPCPAkzKinxmW/Z5UVQaIV89suiSVRcm+QXSkeMG7NM4/SLVuusk6igmtcrdtB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On February 2, 2026 9:02:48 AM PST, Jens Remus <jremus@linux=2Eibm=2Ecom> w=
rote:
>Hello Peter!
>
>On 1/6/2026 10:18 PM, H=2E Peter Anvin wrote:
>> The vdso32 sigreturn=2ES contains open-coded DWARF bytecode, which
>> includes a hack for gdb to not try to step back to a previous call
>> instruction when backtracing from a signal handler=2E
>>=20
>> Neither of those are necessary anymore: the backtracing issue is
>> handled by "=2Ecfi_entry simple" and "=2Ecfi_signal_frame", both of whi=
ch
>> have been supported for a very long time now, which allows the
>> remaining frame to be built using regular =2Ecfi annotations=2E
>
>Hopefully Glibc developers will do something similar for x86-64
>__restore_rt() in Glibc sysdeps/unix/sysv/linux/x86_64/libc_sigaction=2Ec=
=2E
>
>>=20
>> Add a few more register offsets to the signal frame just for good
>> measure=2E
>>=20
>> Replace the nop on fallthrough of the system call (which should never,
>> ever happen) with a ud2a trap=2E
>> diff --git a/arch/x86/entry/vdso/vdso32/sigreturn=2ES b/arch/x86/entry/=
vdso/vdso32/sigreturn=2ES
>
>>  	=2Etext
>>  	=2Eglobl __kernel_sigreturn
>>  	=2Etype __kernel_sigreturn,@function
>> -	nop /* this guy is needed for =2ELSTARTFDEDLSI1 below (watch for HACK=
) */
>>  	ALIGN
>>  __kernel_sigreturn:
>> -=2ELSTART_sigreturn:
>> -	popl %eax		/* XXX does this mean it needs unwind info? */
>> +	STARTPROC_SIGNAL_FRAME IA32_SIGFRAME_sigcontext
>> +	popl %eax
>> +	CFI_ADJUST_CFA_OFFSET -4
>>  	movl $__NR_sigreturn, %eax
>>  	int $0x80
>> -=2ELEND_sigreturn:
>
>=2E=2E=2E
>
>>  	=2Eglobl __kernel_rt_sigreturn
>>  	=2Etype __kernel_rt_sigreturn,@function
>>  	ALIGN
>>  __kernel_rt_sigreturn:
>> -=2ELSTART_rt_sigreturn:
>> +	STARTPROC_SIGNAL_FRAME IA32_RT_SIGFRAME_sigcontext
>>  	movl $__NR_rt_sigreturn, %eax
>>  	int $0x80
>> -=2ELEND_rt_sigreturn:
>
>=2E=2E=2E
>
>> -	=2Esection =2Eeh_frame,"a",@progbits
>> -=2ELSTARTFRAMEDLSI1:
>> -	=2Elong =2ELENDCIEDLSI1-=2ELSTARTCIEDLSI1
>> -=2ELSTARTCIEDLSI1:
>> -	=2Elong 0			/* CIE ID */
>> -	=2Ebyte 1			/* Version number */
>> -	=2Estring "zRS"		/* NUL-terminated augmentation string */
>
>Note that the "S" in "zRS" is the signal frame indication=2E
>
>> -	=2Euleb128 1		/* Code alignment factor */
>> -	=2Esleb128 -4		/* Data alignment factor */
>> -	=2Ebyte 8			/* Return address register column */
>> -	=2Euleb128 1		/* Augmentation value length */
>> -	=2Ebyte 0x1b		/* DW_EH_PE_pcrel|DW_EH_PE_sdata4=2E */
>> -	=2Ebyte 0			/* DW_CFA_nop */
>> -	=2Ealign 4
>> -=2ELENDCIEDLSI1:
>> -	=2Elong =2ELENDFDEDLSI1-=2ELSTARTFDEDLSI1 /* Length FDE */
>> -=2ELSTARTFDEDLSI1:
>> -	=2Elong =2ELSTARTFDEDLSI1-=2ELSTARTFRAMEDLSI1 /* CIE pointer */
>> -	/* HACK: The dwarf2 unwind routines will subtract 1 from the
>> -	   return address to get an address in the middle of the
>> -	   presumed call instruction=2E  Since we didn't get here via
>> -	   a call, we need to include the nop before the real start
>> -	   to make up for it=2E  */
>> -	=2Elong =2ELSTART_sigreturn-1-=2E	/* PC-relative start address */
>
>Your version does no longer have this nop nor does the FDE start one
>byte earlier=2E  Isn't that required for unwinders any longer?
>See excerpt from dumped DWARF and disassembly for __kernel_sigreturn()
>below=2E
>
>> -	=2Elong =2ELEND_sigreturn-=2ELSTART_sigreturn+1
>> -	=2Euleb128 0			/* Augmentation */
>=2E=2E=2E
>
>> -	=2Ealign 4
>> -=2ELENDFDEDLSI1:
>> -
>> -	=2Elong =2ELENDFDEDLSI2-=2ELSTARTFDEDLSI2 /* Length FDE */
>> -=2ELSTARTFDEDLSI2:
>> -	=2Elong =2ELSTARTFDEDLSI2-=2ELSTARTFRAMEDLSI1 /* CIE pointer */
>> -	/* HACK: See above wrt unwind library assumptions=2E  */
>> -	=2Elong =2ELSTART_rt_sigreturn-1-=2E	/* PC-relative start address */
>
>Ditto=2E
>
>> -	=2Elong =2ELEND_rt_sigreturn-=2ELSTART_rt_sigreturn+1
>> -	=2Euleb128 0			/* Augmentation */
>
>Excerpt from dump of DWARF and disassembly with your patch:
>
>$ objdump -d -Wf arch/x86/entry/vdso/vdso32/vdso32=2Eso=2Edbg
>=2E=2E=2E
>000001cc 0000003c 00000000 CIE   <-- CIE for __kernel_sigreturn
>  Version:               1
>  Augmentation:          "zRS"
>  Code alignment factor: 1
>  Data alignment factor: -4
>  Return address column: 8
>  Augmentation data:     1b
>  DW_CFA_def_cfa: r4 (esp) ofs 4
>  DW_CFA_offset_extended_sf: r8 (eip) at cfa+56
>  DW_CFA_offset_extended_sf: r0 (eax) at cfa+44
>  DW_CFA_offset_extended_sf: r3 (ebx) at cfa+32
>  DW_CFA_offset_extended_sf: r1 (ecx) at cfa+40
>  DW_CFA_offset_extended_sf: r2 (edx) at cfa+36
>  DW_CFA_offset_extended_sf: r4 (esp) at cfa+28
>  DW_CFA_offset_extended_sf: r5 (ebp) at cfa+24
>  DW_CFA_offset_extended_sf: r6 (esi) at cfa+20
>  DW_CFA_offset_extended_sf: r7 (edi) at cfa+16
>  DW_CFA_offset_extended_sf: r40 (es) at cfa+8
>  DW_CFA_offset_extended_sf: r41 (cs) at cfa+60
>  DW_CFA_offset_extended_sf: r42 (ss) at cfa+72
>  DW_CFA_offset_extended_sf: r43 (ds) at cfa+12
>  DW_CFA_offset_extended_sf: r9 (eflags) at cfa+64
>  DW_CFA_nop
>
>0000020c 00000010 00000044 FDE cie=3D000001cc pc=3D00001a40=2E=2E00001a4a=
   <-- FDE for __kernel_sigreturn
>  DW_CFA_advance_loc: 1 to 00001a41
>  DW_CFA_def_cfa_offset: 0
>
>[ The FDE covers the range [1a40=2E=2E1a4a[=2E  Previously it would have
>started one byte earlier (at the nop), so that the range would have
>been [1a3f=2E=2E1a4a[=2E  This is/was required for unwinders that always
>subtract one from the unwound return address, so that it points into
>the instruction that invoked the function (e=2Eg=2E call) instead of behi=
nd
>it, in case it was invoked by a non-returning function=2E  Such an
>unwinder would now lookup IP=3D1a3f as belonging to int80_landing_pad (an=
d
>use the DWARF rules applicable to its last instruction) instead of
>__kernel_sigreturn (and its rules)=2E  Likewise for __kernel_rt_sigreturn=
=2E ]
>
>=2E=2E=2E
>00001a3c <int80_landing_pad>:
>    1a3c:       5d                      pop    %ebp
>    1a3d:       5a                      pop    %edx
>    1a3e:       59                      pop    %ecx
>    1a3f:       c3                      ret
>
>00001a40 <__kernel_sigreturn>:
>    1a40:       58                      pop    %eax
>    1a41:       b8 77 00 00 00          mov    $0x77,%eax
>    1a46:       cd 80                   int    $0x80
>
>00001a48 <vdso32_sigreturn_landing_pad>:
>    1a48:       0f 0b                   ud2
>    1a4a:       8d b6 00 00 00 00       lea    0x0(%esi),%esi
>
>
>Excerpt without your patch:
>
>$ objdump -d -Wf arch/x86/entry/vdso/vdso32/vdso32=2Eso=2Edbg
>=2E=2E=2E
>000001cc 00000010 00000000 CIE  <-- CIE for __kernel_sigreturn and __kern=
el_rt_sigreturn
>  Version:               1
>  Augmentation:          "zRS"
>  Code alignment factor: 1
>  Data alignment factor: -4
>  Return address column: 8
>  Augmentation data:     1b
>  DW_CFA_nop
>  DW_CFA_nop
>
>000001e0 00000068 00000018 FDE cie=3D000001cc pc=3D00001a6f=2E=2E00001a78=
  <-- FDE for __kernel_sigreturn
>  DW_CFA_def_cfa_expression (DW_OP_breg4 (esp): 32; DW_OP_deref)
>  DW_CFA_expression: r0 (eax) (DW_OP_breg4 (esp): 48)
>  DW_CFA_expression: r1 (ecx) (DW_OP_breg4 (esp): 44)
>  DW_CFA_expression: r2 (edx) (DW_OP_breg4 (esp): 40)
>  DW_CFA_expression: r3 (ebx) (DW_OP_breg4 (esp): 36)
>  DW_CFA_expression: r5 (ebp) (DW_OP_breg4 (esp): 28)
>  DW_CFA_expression: r6 (esi) (DW_OP_breg4 (esp): 24)
>  DW_CFA_expression: r7 (edi) (DW_OP_breg4 (esp): 20)
>  DW_CFA_expression: r8 (eip) (DW_OP_breg4 (esp): 60)
>  DW_CFA_advance_loc: 2 to 00001a71
>  DW_CFA_def_cfa_expression (DW_OP_breg4 (esp): 28; DW_OP_deref)
>  DW_CFA_expression: r0 (eax) (DW_OP_breg4 (esp): 44)
>  DW_CFA_expression: r1 (ecx) (DW_OP_breg4 (esp): 40)
>  DW_CFA_expression: r2 (edx) (DW_OP_breg4 (esp): 36)
>  DW_CFA_expression: r3 (ebx) (DW_OP_breg4 (esp): 32)
>  DW_CFA_expression: r5 (ebp) (DW_OP_breg4 (esp): 24)
>  DW_CFA_expression: r6 (esi) (DW_OP_breg4 (esp): 20)
>  DW_CFA_expression: r7 (edi) (DW_OP_breg4 (esp): 16)
>  DW_CFA_expression: r8 (eip) (DW_OP_breg4 (esp): 56)
>
>
>[ See how the FDE for __kernel_sigreturn covers the range [1a6f=2E=2E1a78=
[=2E
>An unwinder that always subtracts one from the return address would
>lookup IP=3D1a6f as belonging to __kernel_sigreturn (and use the DWARF
>rules applicable to the nop preceeding its symbol)=2E  Likewise for
>__kernel_rt_sigreturn=2E  Or is that no longer true?  ]
>
>=2E=2E=2E
>00001a5c <int80_landing_pad>:
>    1a5c:       5d                      pop    %ebp
>    1a5d:       5a                      pop    %edx
>    1a5e:       59                      pop    %ecx
>    1a5f:       c3                      ret
>    1a60:       90                      nop
>    1a61:       8d b4 26 00 00 00 00    lea    0x0(%esi,%eiz,1),%esi
>    1a68:       2e 8d b4 26 00 00 00    lea    %cs:0x0(%esi,%eiz,1),%esi
>    1a6f:       00
>
>00001a70 <__kernel_sigreturn>:
>    1a70:       58                      pop    %eax
>    1a71:       b8 77 00 00 00          mov    $0x77,%eax
>    1a76:       cd 80                   int    $0x80
>
>Thanks and regards,
>Jens

That hack dates back from before the signal frame extension=2E It is no lo=
nger necessary=2E

