Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71615E7DF08
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFED96B0096; Mon,  2 Feb 2026 12:03:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC98C6B00C0; Mon,  2 Feb 2026 12:03:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9EB06B00C2; Mon,  2 Feb 2026 12:03:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A54C86B0096
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:03:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 431CC1A024B
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:03:27 +0000 (UTC)
X-FDA: 84400137654.10.6D2E548
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id 54CF9100016
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:03:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Q9Y2yC8x;
	spf=pass (imf05.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770051804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enr9oHBpII1yFeQRrpbfRzg0lMZszqrmJijcTFzIJ5I=;
	b=y8pvgDND2y5EwXLHIcCSq7xPc2yq9nE3U7Vdg+iwYIJOwY0NE51s6GEoEmwPP/BqP4iNxj
	CXj48ZoKEG6moqv0HCVwWULgo0AFzUtCwyPC8oQuQfNcd9L5cw6m/5lX8WBf75GorC9Kp9
	nN4GCgCDf13Vw4JSEwsQimzd+W5tus4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Q9Y2yC8x;
	spf=pass (imf05.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770051804; a=rsa-sha256;
	cv=none;
	b=nZI/ImdjYcztMjuhIUlj/0o6fJPJV0JT9zsnmhSyz8q0a40T7yVnlR1oydIXOIcOOaxId/
	MEQalCs16u/YSWH+pu9tQVJUIn/N/KjhlAfjLk3MgM63uf+52wjcyiMXa2hOE+qEUoWuOa
	YUDIvSzZphJrvoWJf9OAfCJl8rPfPlQ=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 612FEnEo021704;
	Mon, 2 Feb 2026 17:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=enr9oH
	BpII1yFeQRrpbfRzg0lMZszqrmJijcTFzIJ5I=; b=Q9Y2yC8xIXxxlduNIEnsKy
	NdrlxRorqyTgdfCqbeRLF5IBVdzoJi1RXz2Pcgsv1rQDPol5PmID6DQoSo9sxF3Q
	YmS1lfdCoQ4JNSSybNIohG6KnoZh+zvEN3SgaupSBQZp+AULncHUvXpi3fXkGfPk
	jiXf2ZsMBsdLDGU9k3X378Md6r1KdCKEgN2IIw7ReIgMEnPDryeqZPOdTwVpyvtK
	IH/8pEA7YvdrUIsNccZBIB6dsIYOJaN55JEYFhe6AgkpD8frD6bndbW3LV/BWQNa
	T6EP4o5gSb6MnNLc0co3cec8uRQe+QtlEf3QE9r0/n0yecBmdOKoSuJRTmLUTBLQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dt1egh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Feb 2026 17:02:56 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 612H2t6j015012;
	Mon, 2 Feb 2026 17:02:55 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19dt1egf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Feb 2026 17:02:55 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 612FEKYX005921;
	Mon, 2 Feb 2026 17:02:54 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1x9j5mwg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Feb 2026 17:02:54 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 612H2oMr45744572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Feb 2026 17:02:50 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B4BE20043;
	Mon,  2 Feb 2026 17:02:50 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E303820040;
	Mon,  2 Feb 2026 17:02:48 +0000 (GMT)
Received: from [9.111.137.38] (unknown [9.111.137.38])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Feb 2026 17:02:48 +0000 (GMT)
Message-ID: <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com>
Date: Mon, 2 Feb 2026 18:02:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4.1 06/10] x86/entry/vdso32: remove open-coded DWARF in
 sigreturn.S
To: "H. Peter Anvin" <hpa@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
 <20260106211856.560186-6-hpa@zytor.com>
Content-Language: en-US
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
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
From: Jens Remus <jremus@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20260106211856.560186-6-hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDEzMyBTYWx0ZWRfX9uEfr/r+lzdD
 C8omF/5jkHOK5jJ0rLp+q/PRksQGh16aHNEJ2tv87A/Uvgb7bHn3xxXJyCy+mfU7dv/JnhGjSI6
 9TPCIwG2inKNRZz3b3p3OCUPpXvZYks3yQztd8amLbuZedT/u36cVIJRbjJfX3u/IgWZ9ccdrPA
 9gckFsHHiZUAX1dr+1PgRb+mXHegJov9/cYaVSJ9+lWOn/V3oL/UqvNct5Qm1YMsPFaTzY31j42
 nEbp/xViy68e6vkLVCcFAUZPLefYgUTK8X4pI+aXFmjFLAjB8EASUb2UFra345KJNJKDvsQcDMP
 Y4EbbmbZjPo42HIYejMc7dh+MkUXX7SnQsayps7eksSrYgAYe28S4KPXik177fSwBJqlQYTVk8M
 SdrVTPmlbPKMod3Xv4Gj3FyEzwqoHJxlMHqaBMvHaLpph3jPcI0sjVBCb4PHdKASwnjlmGTRGi2
 ou7KFMz1uvr4K6Z/d5A==
X-Proofpoint-GUID: s4DknQTXfwjkyg4Nz9iruxILomTh7deP
X-Proofpoint-ORIG-GUID: V8Jq_arsggR1Us6G1UPEKmHMb52ek7rC
X-Authority-Analysis: v=2.4 cv=LesxKzfi c=1 sm=1 tr=0 ts=6980d8c0 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=CrQ4HH22-qIxy3_CQy8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_04,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 clxscore=1011
 adultscore=0 suspectscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602020133
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 54CF9100016
X-Stat-Signature: orwronzc5y4jpakcg1bn5g4qyf4uh1ca
X-Rspam-User: 
X-HE-Tag: 1770051804-326097
X-HE-Meta: U2FsdGVkX1+FdR51eyFc4btN4qTD8Walf5cDW0cWR/6AgLfTSnisd/KcT522EivvMduSS6ednYJlbGgXy2kx6s8SXZZA7A8Z2Gy9H1xOLqPcBPB5krCDDV4Js14VDHICPnS0C9lZpm6MqMuMxE+47FWtIWz/Vd5rf9QGp/iU849nEx4gXszUFBzIaqJF8ANhzmCuW/iikM0tTjHcNMoXwyH7KzkjYpqxXjbMcHPyXICsPYqIYhU5+LKoXlOKH6rFUgDA9pNgz/RmqW+2OZPBOqgpdDeBWJXrW+Te3kM+MBGfoYDfXKU0AX7D1qLb6UcU85NaHtkSwt/qeEw9SOUBPO3pG7jC8SI4ocFhsq2nJxXShoSQBpTVcZ2fTW5alLkf12QjIp8GoY3ZLXKJyMU8LHmIg6RWct8L6zEd5aoFla9XhmjbLuV+H9leYYFr4gh3oObRiXE838cW+NCBY8c3ChiC0azNH3hJxrydR5eOPzESeBx0TRK2gd3uDsoHZ7qaHKhork1xaodmrTYH/VnYJN/fWCGZVUyaZSwRH0jPtmrVl5EyVi1gI+tDJm4azAtRiNpMqVTr0uBV7g1d+yT4HONiFfyg+cREtF+st1KKbN+pBGZAka1G/IpynUTq6Z8DfPBLxmfThWJWFcA2hrC9rY+xp0Kl3uHS1BybLHaT4VwT1W8uVQFT68a9nun98Z/BiY1b2xpWRFN9jzvs6/hv2oX/JwH0HpECNQamXH/tx0z/FtOjmQqh+JP3Bkcm48BfstPfjNVZA4t6X+9doddXrStzeXee7VAE5b+rnQS/ngHMfQL/B9nb52L74mgvZ1Tg/19Hv0KNp0S6u3Skp4toFZ1bjadccas7CSjq2GaTM8hljNWkxR5UYb9GQbym8Y/sGFaTOYsg/usG9svjq0V9bbuJZ3fHRcmPI8atCKzma8D7IyUktzimjSULqwJKBntbhx4dyonwfpXIyNbxaS+
 c4VDFluO
 vQo1rUgYGfmCMaDvRq7Z0bPcIewY7lyo7sDKJqJAr/1Kq96AlAwWP26aHoDtCB/y0nPzcccYoeWhjoEnIVNrDsW1iHDWi8PpKlq7FIub35dIDBykjRps66kQpDiC/Er0XJxFSCVFyx/pSXaAIqI1hEqNQTu3rQae9ogTwVEL3+76j8Y6BFBbJHDIikIiqVEBEAlv2YwdiZCXnaAcc90gHrNfOg1vQiBjYgzQ/uWgygYUA8SHDoAhyXPOcabivguCoHyRM84QYLnVGJNQUiGtJzxci/oP9r626EU4oMJOextdiArcgleYC7Wj3B0vq4RKlx93suBFvH+rIpvCBvfBn4NbWZGx/+Lw2N7xM21YuTFLJpY+Aw52RQmzlj4p1LUM7QkoxROUHGd9zCSKJNN57c1ggjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Peter!

On 1/6/2026 10:18 PM, H. Peter Anvin wrote:
> The vdso32 sigreturn.S contains open-coded DWARF bytecode, which
> includes a hack for gdb to not try to step back to a previous call
> instruction when backtracing from a signal handler.
> 
> Neither of those are necessary anymore: the backtracing issue is
> handled by ".cfi_entry simple" and ".cfi_signal_frame", both of which
> have been supported for a very long time now, which allows the
> remaining frame to be built using regular .cfi annotations.

Hopefully Glibc developers will do something similar for x86-64
__restore_rt() in Glibc sysdeps/unix/sysv/linux/x86_64/libc_sigaction.c.

> 
> Add a few more register offsets to the signal frame just for good
> measure.
> 
> Replace the nop on fallthrough of the system call (which should never,
> ever happen) with a ud2a trap.
> diff --git a/arch/x86/entry/vdso/vdso32/sigreturn.S b/arch/x86/entry/vdso/vdso32/sigreturn.S

>  	.text
>  	.globl __kernel_sigreturn
>  	.type __kernel_sigreturn,@function
> -	nop /* this guy is needed for .LSTARTFDEDLSI1 below (watch for HACK) */
>  	ALIGN
>  __kernel_sigreturn:
> -.LSTART_sigreturn:
> -	popl %eax		/* XXX does this mean it needs unwind info? */
> +	STARTPROC_SIGNAL_FRAME IA32_SIGFRAME_sigcontext
> +	popl %eax
> +	CFI_ADJUST_CFA_OFFSET -4
>  	movl $__NR_sigreturn, %eax
>  	int $0x80
> -.LEND_sigreturn:

...

>  	.globl __kernel_rt_sigreturn
>  	.type __kernel_rt_sigreturn,@function
>  	ALIGN
>  __kernel_rt_sigreturn:
> -.LSTART_rt_sigreturn:
> +	STARTPROC_SIGNAL_FRAME IA32_RT_SIGFRAME_sigcontext
>  	movl $__NR_rt_sigreturn, %eax
>  	int $0x80
> -.LEND_rt_sigreturn:

...

> -	.section .eh_frame,"a",@progbits
> -.LSTARTFRAMEDLSI1:
> -	.long .LENDCIEDLSI1-.LSTARTCIEDLSI1
> -.LSTARTCIEDLSI1:
> -	.long 0			/* CIE ID */
> -	.byte 1			/* Version number */
> -	.string "zRS"		/* NUL-terminated augmentation string */

Note that the "S" in "zRS" is the signal frame indication.

> -	.uleb128 1		/* Code alignment factor */
> -	.sleb128 -4		/* Data alignment factor */
> -	.byte 8			/* Return address register column */
> -	.uleb128 1		/* Augmentation value length */
> -	.byte 0x1b		/* DW_EH_PE_pcrel|DW_EH_PE_sdata4. */
> -	.byte 0			/* DW_CFA_nop */
> -	.align 4
> -.LENDCIEDLSI1:
> -	.long .LENDFDEDLSI1-.LSTARTFDEDLSI1 /* Length FDE */
> -.LSTARTFDEDLSI1:
> -	.long .LSTARTFDEDLSI1-.LSTARTFRAMEDLSI1 /* CIE pointer */
> -	/* HACK: The dwarf2 unwind routines will subtract 1 from the
> -	   return address to get an address in the middle of the
> -	   presumed call instruction.  Since we didn't get here via
> -	   a call, we need to include the nop before the real start
> -	   to make up for it.  */
> -	.long .LSTART_sigreturn-1-.	/* PC-relative start address */

Your version does no longer have this nop nor does the FDE start one
byte earlier.  Isn't that required for unwinders any longer?
See excerpt from dumped DWARF and disassembly for __kernel_sigreturn()
below.

> -	.long .LEND_sigreturn-.LSTART_sigreturn+1
> -	.uleb128 0			/* Augmentation */
...

> -	.align 4
> -.LENDFDEDLSI1:
> -
> -	.long .LENDFDEDLSI2-.LSTARTFDEDLSI2 /* Length FDE */
> -.LSTARTFDEDLSI2:
> -	.long .LSTARTFDEDLSI2-.LSTARTFRAMEDLSI1 /* CIE pointer */
> -	/* HACK: See above wrt unwind library assumptions.  */
> -	.long .LSTART_rt_sigreturn-1-.	/* PC-relative start address */

Ditto.

> -	.long .LEND_rt_sigreturn-.LSTART_rt_sigreturn+1
> -	.uleb128 0			/* Augmentation */

Excerpt from dump of DWARF and disassembly with your patch:

$ objdump -d -Wf arch/x86/entry/vdso/vdso32/vdso32.so.dbg
...
000001cc 0000003c 00000000 CIE   <-- CIE for __kernel_sigreturn
  Version:               1
  Augmentation:          "zRS"
  Code alignment factor: 1
  Data alignment factor: -4
  Return address column: 8
  Augmentation data:     1b
  DW_CFA_def_cfa: r4 (esp) ofs 4
  DW_CFA_offset_extended_sf: r8 (eip) at cfa+56
  DW_CFA_offset_extended_sf: r0 (eax) at cfa+44
  DW_CFA_offset_extended_sf: r3 (ebx) at cfa+32
  DW_CFA_offset_extended_sf: r1 (ecx) at cfa+40
  DW_CFA_offset_extended_sf: r2 (edx) at cfa+36
  DW_CFA_offset_extended_sf: r4 (esp) at cfa+28
  DW_CFA_offset_extended_sf: r5 (ebp) at cfa+24
  DW_CFA_offset_extended_sf: r6 (esi) at cfa+20
  DW_CFA_offset_extended_sf: r7 (edi) at cfa+16
  DW_CFA_offset_extended_sf: r40 (es) at cfa+8
  DW_CFA_offset_extended_sf: r41 (cs) at cfa+60
  DW_CFA_offset_extended_sf: r42 (ss) at cfa+72
  DW_CFA_offset_extended_sf: r43 (ds) at cfa+12
  DW_CFA_offset_extended_sf: r9 (eflags) at cfa+64
  DW_CFA_nop

0000020c 00000010 00000044 FDE cie=000001cc pc=00001a40..00001a4a   <-- FDE for __kernel_sigreturn
  DW_CFA_advance_loc: 1 to 00001a41
  DW_CFA_def_cfa_offset: 0

[ The FDE covers the range [1a40..1a4a[.  Previously it would have
started one byte earlier (at the nop), so that the range would have
been [1a3f..1a4a[.  This is/was required for unwinders that always
subtract one from the unwound return address, so that it points into
the instruction that invoked the function (e.g. call) instead of behind
it, in case it was invoked by a non-returning function.  Such an
unwinder would now lookup IP=1a3f as belonging to int80_landing_pad (and
use the DWARF rules applicable to its last instruction) instead of
__kernel_sigreturn (and its rules).  Likewise for __kernel_rt_sigreturn. ]

...
00001a3c <int80_landing_pad>:
    1a3c:       5d                      pop    %ebp
    1a3d:       5a                      pop    %edx
    1a3e:       59                      pop    %ecx
    1a3f:       c3                      ret

00001a40 <__kernel_sigreturn>:
    1a40:       58                      pop    %eax
    1a41:       b8 77 00 00 00          mov    $0x77,%eax
    1a46:       cd 80                   int    $0x80

00001a48 <vdso32_sigreturn_landing_pad>:
    1a48:       0f 0b                   ud2
    1a4a:       8d b6 00 00 00 00       lea    0x0(%esi),%esi


Excerpt without your patch:

$ objdump -d -Wf arch/x86/entry/vdso/vdso32/vdso32.so.dbg
...
000001cc 00000010 00000000 CIE  <-- CIE for __kernel_sigreturn and __kernel_rt_sigreturn
  Version:               1
  Augmentation:          "zRS"
  Code alignment factor: 1
  Data alignment factor: -4
  Return address column: 8
  Augmentation data:     1b
  DW_CFA_nop
  DW_CFA_nop

000001e0 00000068 00000018 FDE cie=000001cc pc=00001a6f..00001a78  <-- FDE for __kernel_sigreturn
  DW_CFA_def_cfa_expression (DW_OP_breg4 (esp): 32; DW_OP_deref)
  DW_CFA_expression: r0 (eax) (DW_OP_breg4 (esp): 48)
  DW_CFA_expression: r1 (ecx) (DW_OP_breg4 (esp): 44)
  DW_CFA_expression: r2 (edx) (DW_OP_breg4 (esp): 40)
  DW_CFA_expression: r3 (ebx) (DW_OP_breg4 (esp): 36)
  DW_CFA_expression: r5 (ebp) (DW_OP_breg4 (esp): 28)
  DW_CFA_expression: r6 (esi) (DW_OP_breg4 (esp): 24)
  DW_CFA_expression: r7 (edi) (DW_OP_breg4 (esp): 20)
  DW_CFA_expression: r8 (eip) (DW_OP_breg4 (esp): 60)
  DW_CFA_advance_loc: 2 to 00001a71
  DW_CFA_def_cfa_expression (DW_OP_breg4 (esp): 28; DW_OP_deref)
  DW_CFA_expression: r0 (eax) (DW_OP_breg4 (esp): 44)
  DW_CFA_expression: r1 (ecx) (DW_OP_breg4 (esp): 40)
  DW_CFA_expression: r2 (edx) (DW_OP_breg4 (esp): 36)
  DW_CFA_expression: r3 (ebx) (DW_OP_breg4 (esp): 32)
  DW_CFA_expression: r5 (ebp) (DW_OP_breg4 (esp): 24)
  DW_CFA_expression: r6 (esi) (DW_OP_breg4 (esp): 20)
  DW_CFA_expression: r7 (edi) (DW_OP_breg4 (esp): 16)
  DW_CFA_expression: r8 (eip) (DW_OP_breg4 (esp): 56)


[ See how the FDE for __kernel_sigreturn covers the range [1a6f..1a78[.
An unwinder that always subtracts one from the return address would
lookup IP=1a6f as belonging to __kernel_sigreturn (and use the DWARF
rules applicable to the nop preceeding its symbol).  Likewise for
__kernel_rt_sigreturn.  Or is that no longer true?  ]

...
00001a5c <int80_landing_pad>:
    1a5c:       5d                      pop    %ebp
    1a5d:       5a                      pop    %edx
    1a5e:       59                      pop    %ecx
    1a5f:       c3                      ret
    1a60:       90                      nop
    1a61:       8d b4 26 00 00 00 00    lea    0x0(%esi,%eiz,1),%esi
    1a68:       2e 8d b4 26 00 00 00    lea    %cs:0x0(%esi,%eiz,1),%esi
    1a6f:       00

00001a70 <__kernel_sigreturn>:
    1a70:       58                      pop    %eax
    1a71:       b8 77 00 00 00          mov    $0x77,%eax
    1a76:       cd 80                   int    $0x80

Thanks and regards,
Jens
-- 
Jens Remus
Linux on Z Development (D3303)
jremus@de.ibm.com / jremus@linux.ibm.com

IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsrats: Wolfgang Wendt; Geschäftsführung: David Faller; Sitz der Gesellschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM Data Privacy Statement: https://www.ibm.com/privacy/


