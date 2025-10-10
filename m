Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BBC0CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 09:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD78E8E001E; Fri, 10 Oct 2025 05:34:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87F38E0018; Fri, 10 Oct 2025 05:34:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94F728E001E; Fri, 10 Oct 2025 05:34:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 764068E0018
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 05:34:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19088B7132
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 09:34:08 +0000 (UTC)
X-FDA: 83981693376.06.65A5D25
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2747310000E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 09:34:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760088845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cv4nEj7UBTV72f1gU8wuBa1ut3a9qHUaWAVjisQOCJo=;
	b=nucNWUnbw18wTds8b9mAabs+DmBOUoXWemS8JuZut+mvcytJulgJQ061JvEblX6uZGKmBV
	MdSYimSoyKyMAPU01UugWpE6wHFb5VvSRnPAlf1VIy38bcgiTd5rEUF0D1jt0V/Vucl5lE
	x5bxuLvnhyNGvgjfXc/+rl9HUohQNbs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760088845; a=rsa-sha256;
	cv=none;
	b=4wbVKmAPYgc7ydzSI2d80rMC9XHjj/f7KXoekVYEM/g92UIPYLtlWh7/uDEWgoTy92DBJ2
	y5EzPdB0vphXishfy5ZFog8dp/blZZht2agWhsc3LgyZ8uYd8ITmr7RMV33SzYSF2LRt6D
	pJvu8guG8IHJ7KaUsWrn1M+rzycCqmI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b4f323cf89bso326147266b.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:34:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760088843; x=1760693643;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cv4nEj7UBTV72f1gU8wuBa1ut3a9qHUaWAVjisQOCJo=;
        b=GFTi4VB/M2TRxI+dD200SJ2dhq+vBrpwt5n3pCn+6g34rKUxIV0d9jykT3LW9j6mml
         PD/XbNIbXj9KsFNxTwT+K2mB5JF0IUJXLBCuhY7CkGfHJBMivq0cs36PTbk/UUdKd6i3
         FBIMVk13tNsCSDSZ5gyUubPTRwl6FklDjC/2DJGV30wAR+JW6mgW7Ix/KMZ0KkUGsb74
         NRtZJo1Xdo7n4wESdm95GfF4TKTUNuMI1+pyElMOxHKXeg4AD2q2RWIg5/uBz4/8QoQa
         MyIEV5V/K8ZNg7G0wSRf9Pb7nnk+KyXyDFHc0s065qxbLgN1lhP6bL1nNkdoZMW1M8FO
         9CQw==
X-Forwarded-Encrypted: i=1; AJvYcCUN2G7gtKZjYTntgMQZAZ95nsLC576RnuQPbQmz5ICeVU10RIScH0pM+3FAMimNUx0lHjImxqv5Tg==@kvack.org
X-Gm-Message-State: AOJu0YyoKBPC0euTywqcgKtUSf4ghpSlb8DRGVSuEdVZLopHnAI6SRyW
	Yf5Rz+AJ1ED6EwkLgaL0qYmxTRfZs/8itP1tK7Te6Bq/Bd0N3WOvx3dy
X-Gm-Gg: ASbGncuAl2I/FZuwDYbyw9Sw84JvwhFIxWekwfuRrUfAHBSroYSQwHzzSA954FwAyT/
	MIQcH0VG49+194ATwfOZlAJqF8owe0nZO/pfNnDYFphuxhWJuCdjGcxEHwKSF0gLggaXR5Zj87b
	PuXmlxqUFaSsFMPS03qy+AvE2FGgcs/yPhQPfGMKh1pEgRUwstCAiWid0EzsYuaW7987tmH+s46
	Ggz1Xw3qulsLpKVLfnqkeORvz57RkhB+jRIIbcY/4k+egnj27tVzX/lqEGz1lefoRAOBfONKAGX
	rbGaUA31rcANFoJcco7s2h0g2aoRdMC4Taf3t4DN6/Z6raUd7HiShDxopUZkys7Q22lujG7JXhS
	Wg8v3fH4V8PzVxM4pnEw/0ZuCPJLGBqUmRolz
X-Google-Smtp-Source: AGHT+IHJJZYzLmff6dVgniqDgTA9wuOtJBZMe0+HaoaCcR6f3ALYVARpNqjkBuP0lUSeRtOHCgzETA==
X-Received: by 2002:a17:906:6b9a:b0:b45:1063:fb65 with SMTP id a640c23a62f3a-b50abaafd40mr960927966b.39.1760088843318;
        Fri, 10 Oct 2025 02:34:03 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:70::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d9a3fc41sm190057566b.87.2025.10.10.02.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 02:34:02 -0700 (PDT)
Date: Fri, 10 Oct 2025 02:33:59 -0700
From: Breno Leitao <leitao@debian.org>
To: Changyuan Lyu <changyuanl@google.com>, rppt@kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	anthony.yznaga@oracle.com, arnd@arndb.de, ashish.kalra@amd.com, benh@kernel.crashing.org, 
	bp@alien8.de, catalin.marinas@arm.com, corbet@lwn.net, 
	dave.hansen@linux.intel.com, devicetree@vger.kernel.org, dwmw2@infradead.org, 
	ebiederm@xmission.com, graf@amazon.com, hpa@zytor.com, jgowans@amazon.com, 
	kexec@lists.infradead.org, krzk@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org, mark.rutland@arm.com, 
	mingo@redhat.com, pasha.tatashin@soleen.com, pbonzini@redhat.com, 
	peterz@infradead.org, ptyadav@amazon.de, robh@kernel.org, rostedt@goodmis.org, 
	rppt@kernel.org, saravanak@google.com, skinsburskii@linux.microsoft.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, will@kernel.org, x86@kernel.org
Subject: Re: [PATCH v8 01/17] memblock: add MEMBLOCK_RSRV_KERN flag
Message-ID: <ef6wfr72set5wa5el3wbbu4yd5tnc4p2rhtjpb5kpmncv3xs5d@i3c5v3ciioi3>
References: <20250509074635.3187114-1-changyuanl@google.com>
 <20250509074635.3187114-2-changyuanl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250509074635.3187114-2-changyuanl@google.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: 7ny7gefw7rsb67omnm4z5fqp5fy5uwoy
X-Rspam-User: 
X-Rspamd-Queue-Id: 2747310000E
X-HE-Tag: 1760088844-993913
X-HE-Meta: U2FsdGVkX1/LzyuHl2qYRCBJh+UqwuuOnfnUyhxAQwJq2jNCYXZHMAw1QLRg61DrgDcHyd8SLvU0sORc/Qe/2HG1qXh2tMdefyCAGbXxkT2LxbvtqhJYs2ZXCw3RS8t5emnbsCkPVT0UQmxL9X0Sm8kYHP3xv8qRc5oXs2QohhdzWkmqNwbNvVoJ7dofsxvgh4MGIXZSJA4NkaDELw1BJE4alTZrcoueR0Ldr0STJ1vliGhwbeqZmzLYJSGFMmSmxYkSloIwWIvAn/0dQyWBxed7buE4jadkSoftQ72PWYquQt5nd88bFFpxfbKgSdAxH5tsaGiGnt1PvMVQcJ61SUSmn7dbIwijbADR7mUl5iIIfXW1vf+z7I6rfIWNlR4waIBrNtciXQIEddS33hv8V5pS04laFBJw+UHyb4+kAFjmZSpu1Hku/r5NbtXFqB1NhkiOfv+EZUJFNVkOxUHmKGwNfkl+5rsaguV4IEmyImH3XEIM+5LIVWqqneCwuoOnfOi5SJjq6AZ9gMU0qmSGUjjOpG52HWDxFNSMJZrBjBju5wFAfSBdfgKZDgh8S6BR76cNLSf+yCXGy66X9rw3jyYy4M/Qzhw3K5wd/dNA61WlVeufL9p1bB1xibZNzb/turhuKhd/MBImZZ6Gg9wPKUdqNFwK3FrYTw6+s7dpyWoMCB/nidF4odEwhP2t0n4q2w+2N5Jsir4RwxEQUSQhCkyKFYjlVZJXT1B7/ycqCGBPd/NhRD08UAw8PA+rMQCTW7wOzXaXiFGrwsTbmfozsNco6rSSyf9ToDSq5DWcwILME8+/nW4StcDxss37M6tZrhnHmhH5rfrSNG63C8e+8RxxIORxO962KLnUPoYa0luTFZ4gh/ulPRqK7ga8neLXqU2Gm2peOXlYBzscjEgwoHpx2p0teDe4c+vsSbhv8NPQUMfyhAgo+Di4bs8dT/a36FNPwVGGZlnmbtYhtjS
 xDbHn0ir
 6E7x/z4sgfTlmvxGy1a/h9rphr5YJ94GxAMjPjHXt6+nR8Y/19HhUqXGCCftaoBz6h+yoc3G5y3azr09QIF+TbeHwdpZD/IXnOe5AXNzgmE93upeZ+YcPpWOFh7TkjrwhSgCnBQQRrzrPQyBl0pwTzqEArpQmujgEtPJ2dutztYT+iNNRCbBQuGc1kJr7N0B1uovPu1kguJsXPj6w4qLEnLTcH1SN8QFtXaY/JwKia71lhcXjWDT15bNR0nhj5ifdxigOpbG5IMe/R9wdPJRCwdzaUBO5g7nxih0hcHRw1lgMrmB4Yx+rnFz+jfptTkdlWqK1BF5DI+Opx9IvBkrVZKfpQfA3YJm5owe5fMwly41e3jYnB3rBHSNyVweDuliZIvu4m6usWzuu5chcsgce/xBmNHjNqyrjbdQoV6heDpriK3+5kWNS1sav16tWOoQL1UsZXIl6VornXBw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Chanyuan, Mike,

On Fri, May 09, 2025 at 12:46:19AM -0700, Changyuan Lyu wrote:
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -492,7 +492,7 @@ static int __init_memblock memblock_double_array(struct memblock_type *type,
>  	 * needn't do it
>  	 */
>  	if (!use_slab)
> -		BUG_ON(memblock_reserve(addr, new_alloc_size));
> +		BUG_ON(memblock_reserve_kern(addr, new_alloc_size));
>  
>  	/* Update slab flag */
>  	*in_slab = use_slab;
> @@ -642,7 +642,7 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>  #ifdef CONFIG_NUMA
>  			WARN_ON(nid != memblock_get_region_node(rgn));
>  #endif
> -			WARN_ON(flags != rgn->flags);
> +			WARN_ON(flags != MEMBLOCK_NONE && flags != rgn->flags);

I am hitting some sporadic warnings at early boot on a production kernel
(6.16). Unfortunately this issue is not easily reproduce for me to test on
upstream.

	09:14:44  BIOS-provided physical RAM map:
	09:14:44  BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
	09:14:44  BIOS-e820: [mem 0x00000000000a0000-0x00000000000fffff] reserved
	09:14:44  BIOS-e820: [mem 0x0000000000100000-0x0000000064cb7fff] usable
	09:14:44  BIOS-e820: [mem 0x0000000064cb8000-0x0000000064dc3fff] reserved
	09:14:44  BIOS-e820: [mem 0x0000000064dc4000-0x0000000065b13fff] usable
	09:14:44  BIOS-e820: [mem 0x0000000065b14000-0x0000000065b61fff] reserved
	09:14:44  BIOS-e820: [mem 0x0000000065b62000-0x0000000065ed0fff] usable
	09:14:44  BIOS-e820: [mem 0x0000000065ed1000-0x0000000065f2bfff] reserved
	09:14:44  BIOS-e820: [mem 0x0000000065f2c000-0x0000000066621fff] usable
	09:14:44  BIOS-e820: [mem 0x0000000066622000-0x0000000066630fff] reserved
	09:14:44  BIOS-e820: [mem 0x0000000066631000-0x0000000068107fff] usable
	09:14:44  BIOS-e820: [mem 0x0000000068108000-0x000000006819dfff] ACPI data
	09:14:44  BIOS-e820: [mem 0x000000006819e000-0x000000006a48cfff] usable
	09:14:44  BIOS-e820: [mem 0x000000006a48d000-0x000000006c58cfff] reserved
	09:14:44  BIOS-e820: [mem 0x000000006c58d000-0x000000006c5dcfff] ACPI data
	09:14:44  BIOS-e820: [mem 0x000000006c5dd000-0x000000006cfdcfff] ACPI NVS
	09:14:44  BIOS-e820: [mem 0x000000006cfdd000-0x000000006e9fcfff] reserved
	09:14:44  BIOS-e820: [mem 0x000000006e9fd000-0x000000006fffffff] usable
	09:14:44  BIOS-e820: [mem 0x0000000070000000-0x000000008fffffff] reserved
	09:14:44  BIOS-e820: [mem 0x00000000fd000000-0x00000000fe7fffff] reserved
	09:14:44  BIOS-e820: [mem 0x00000000fed20000-0x00000000fed44fff] reserved
	09:14:44  BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
	09:14:44  BIOS-e820: [mem 0x0000000100000000-0x000000107fff655f] usable
	09:14:44  BIOS-e820: [mem 0x000000107fff6560-0x000000107fff656f] type 128
	09:14:44  BIOS-e820: [mem 0x000000107fff6570-0x000000107fffffff] usable
	09:14:44  random: crng init done
	09:14:44  ------------[ cut here ]------------
	09:14:44 WARNING: CPU: 0 PID: 0 at mm/memblock.c:668 memblock_add_range (mm/memblock.c:668)
	09:14:44  Modules linked in:
	09:14:44  Tainted: [S]=CPU_OUT_OF_SPEC
	09:14:44 RIP: 0010:memblock_add_range (mm/memblock.c:668)
	09:14:44 Code: 28 80 3c 01 00 0f 84 04 fd ff ff 4c 89 ef e8 6c 77 09 00 e9 f7 fc ff ff 0f 0b 83 7c 24 1c 00 0f 85 9c fd ff ff e9 c5 fd ff ff <0f> 0b e9 be fd ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 6b fd
	All code
	========
	0:    28 80 3c 01 00 0f        sub    %al,0xf00013c(%rax)
	6:    84 04 fd ff ff 4c 89     test   %al,-0x76b30001(,%rdi,8)
	d:    ef                       out    %eax,(%dx)
	e:    e8 6c 77 09 00           call   0x9777f
	13:    e9 f7 fc ff ff           jmp    0xfffffffffffffd0f
	18:    0f 0b                    ud2
	1a:    83 7c 24 1c 00           cmpl   $0x0,0x1c(%rsp)
	1f:    0f 85 9c fd ff ff        jne    0xfffffffffffffdc1
	25:    e9 c5 fd ff ff           jmp    0xfffffffffffffdef
	2a:*    0f 0b                    ud2            <-- trapping instruction
	2c:    e9 be fd ff ff           jmp    0xfffffffffffffdef
	31:    44 89 f1                 mov    %r14d,%ecx
	34:    80 e1 07                 and    $0x7,%cl
	37:    80 c1 03                 add    $0x3,%cl
	3a:    38 c1                    cmp    %al,%cl
	3c:    0f                       .byte 0xf
	3d:    8c 6b fd                 mov    %gs,-0x3(%rbx)

	Code starting with the faulting instruction
	===========================================
	0:    0f 0b                    ud2
	2:    e9 be fd ff ff           jmp    0xfffffffffffffdc5
	7:    44 89 f1                 mov    %r14d,%ecx
	a:    80 e1 07                 and    $0x7,%cl
	d:    80 c1 03                 add    $0x3,%cl
	10:    38 c1                    cmp    %al,%cl
	12:    0f                       .byte 0xf
	13:    8c 6b fd                 mov    %gs,-0x3(%rbx)
	09:14:44  RSP: 0000:ffffffff85e07d48 EFLAGS: 00010083 ORIG_RAX: 0000000000000000
	09:14:44  RAX: 0000000000000020 RBX: 0000000000001c00 RCX: dffffc0000000000
	09:14:44  RDX: 000000000009f000 RSI: 000000000009d000 RDI: ffffffff8685ebf8
	09:14:44  RBP: 0000000000000002 R08: 0000000000000020 R09: 0000000000000000
	09:14:44  R10: ffffffffff200570 R11: fffffbffffe400b2 R12: 000000000009d000
	09:14:44  R13: 0000000000100000 R14: ffffffff8edf5ce4 R15: ffffffff8edf5ce0
	09:14:44  FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
	09:14:44  CR2: ffff888059e2dff8 CR3: 000000005bc1d000 CR4: 00000000000000b0
	09:14:44  Call Trace:
	09:14:44   <TASK>
	09:14:44 ? __memblock_reserve (mm/memblock.c:936)
	09:14:44 ? add_early_ima_buffer (arch/x86/kernel/setup.c:413)
	09:14:44 ? parse_setup_data (arch/x86/kernel/setup.c:500)
	09:14:44 ? setup_arch (arch/x86/kernel/setup.c:245 arch/x86/kernel/setup.c:958)
	09:14:44 ? start_kernel (init/main.c:922)
	09:14:44 ? x86_64_start_reservations (arch/x86/kernel/ebda.c:57)
	09:14:44 ? x86_64_start_kernel (arch/x86/kernel/head64.c:231)
	09:14:44 ? common_startup_64 (arch/x86/kernel/head_64.S:419)
	09:14:44   </TASK>
	....
	Memory: 49640988K/66772816K available (54946K kernel code, 19058K rwdata, 22636K rodata, 2940K init, 120968K bss, 10650188K reserved, 6291456K cma-reserved)

So, there is a memory override, and I am curious about it. Do you think it
would be useful to expand this warning to dump more information about the
issue? (only compiled tested)

	if (flags != MEMBLOCK_NONE && flags != rgn->flags) {
		pr_warn("memblock: Flag mismatch at region [%pa-%pa]\n",
			&rgn->base, &rend);
		pr_warn("  Existing region flags: %#x\n", rgn->flags);
		pr_warn("  New range flags: %#x\n", flags);
		pr_warn("  New range: [%pa-%pa]\n", &base, &end);
		WARN_ON_ONCE(1);
	}

Thanks
--breno

