Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82B47CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 16:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D88928E001C; Mon, 13 Oct 2025 12:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D601B8E0009; Mon, 13 Oct 2025 12:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9CFC8E001C; Mon, 13 Oct 2025 12:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B99FE8E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:40:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5794A11A57C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:40:19 +0000 (UTC)
X-FDA: 83993653758.24.A7D3272
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id A0EA480017
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:40:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XZSQu07P;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760373617; a=rsa-sha256;
	cv=none;
	b=eWJpyopOx/0/A2LvERScMjnk5yGoH9z0bP1R38dbI5luThHigv6ZG9kbQz+j/jA9lnTRGR
	1LHgEMPR4VIOAW9U29UZWEdm5KrTPFNW9sxXIo0b1vbfQuUzX78GjHBA2cAGcUfiizRTBL
	aGo+d5Uo7vnHNHzofAepozME+DGxltA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XZSQu07P;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760373617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtgke5IIG+N7o7YGoqhF+zbTkrpkk29pKkR8cJvrfW4=;
	b=mw+/COV9oJ+vD6hizhcmyUwxm51nZW1fLLK1qwnRptKyaltbkooCTfGX6x9G0f+PQ36zV5
	tM0xQTwScYxHR5wZhskejnXrnSaBwR4TaBamcsPZJontR5gHx35cAzKK6lGnJvh1lZn0jy
	+Z+iMbVJcQY5rgnJdmKVfh8A1lZRcuM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 35CBF43A06;
	Mon, 13 Oct 2025 16:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D77C4CEE7;
	Mon, 13 Oct 2025 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760373616;
	bh=hs5Dm6BPAEGHFTEY/NVYLFoUg8OkvqoPEabZITp2GSE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XZSQu07P4SgkBBZjCn0RGnl0R5rV5/5dNJSGZOUAAsLQYCfUrfnNS+2HXe4K3m8l/
	 KspWTGFqpB6+C8D6h76oWfo9JXkqDf2a34ASBb98qAVwnmZ9Btt2ElduQT2WpPTwww
	 kmiBHNzSKdUzad5WTPGTAhE4J8bGtJo1Iu5u+uJCq98zd4m34G+qLiBvGhsU7F+Csv
	 HWvSoO80bQv/kATFT6eHFXH67KQXHE+9CuWPspkyUx+j4KM1t6j5TFunRpv9sPvTbQ
	 9iKwbP2ZPelsuuF5j7/TZi2mOfSFBbkWV2a2oDkxTMJMYb1C8FClYtFZyuYVCnuH7T
	 j0FoiJN2A1P0A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Breno Leitao <leitao@debian.org>,  Changyuan Lyu
 <changyuanl@google.com>,  rppt@kernel.org,  akpm@linux-foundation.org,
  linux-kernel@vger.kernel.org,  anthony.yznaga@oracle.com,  arnd@arndb.de,
  ashish.kalra@amd.com,  benh@kernel.crashing.org,  bp@alien8.de,
  catalin.marinas@arm.com,  corbet@lwn.net,  dave.hansen@linux.intel.com,
  devicetree@vger.kernel.org,  dwmw2@infradead.org,  ebiederm@xmission.com,
  graf@amazon.com,  hpa@zytor.com,  jgowans@amazon.com,
  kexec@lists.infradead.org,  krzk@kernel.org,
  linux-arm-kernel@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  luto@kernel.org,  mark.rutland@arm.com,
  mingo@redhat.com,  pasha.tatashin@soleen.com,  pbonzini@redhat.com,
  peterz@infradead.org,  robh@kernel.org,  rostedt@goodmis.org,
  saravanak@google.com,  skinsburskii@linux.microsoft.com,
  tglx@linutronix.de,  thomas.lendacky@amd.com,  will@kernel.org,
  x86@kernel.org
Subject: Re: [PATCH v8 01/17] memblock: add MEMBLOCK_RSRV_KERN flag
In-Reply-To: <mafs0wm4yluej.fsf@kernel.org> (Pratyush Yadav's message of "Mon,
	13 Oct 2025 16:59:32 +0200")
References: <20250509074635.3187114-1-changyuanl@google.com>
	<20250509074635.3187114-2-changyuanl@google.com>
	<ef6wfr72set5wa5el3wbbu4yd5tnc4p2rhtjpb5kpmncv3xs5d@i3c5v3ciioi3>
	<mafs0wm4yluej.fsf@kernel.org>
Date: Mon, 13 Oct 2025 18:40:09 +0200
Message-ID: <mafs0h5w2lpqu.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: uort67mkijkqwpqyeqxtswdifi6pg7dd
X-Rspamd-Queue-Id: A0EA480017
X-Rspamd-Server: rspam09
X-HE-Tag: 1760373617-82982
X-HE-Meta: U2FsdGVkX190GNyIIQ8qsOoQd12yUdghRQxATaRTHl4r+D+/7rsRCByC6wnDFzCLzEtPO6ZlxuLuTDAv1kupQqUtk5NbApcvNtg+0cwcgFqEN2HgfpEuRh36PwT5RB2UqC4GquyG7tDWb2YdfsqHyf/BnmzwKT3AtTYYnDv+8OJ/PeTcDf4JCiZqO01+yrGrEfk+y+VAZGHclRlIEAx6X5mwpR0hlscVVPQG3YMdKbqDkNN/MjKeeCArSMYcFFPSmmO1Rg4ByTAWDpOME0w2RlRVrpQ8CSTNwGHNbwPdbAr78TFwRT8rhJ975du0/I8jJG5J41nwRSvl9BOeGO65d1QcvVyHT4ctQp+ZaZfvAWDTDROHglrC2dZeXLG7jGlmwunHGup9/JNyCBc82H1tSFbc36Ww8GE/6NUE0Q8U4I29cm2iixD+FsnCGGx23lmq8s9kcbgaZE1dC/+7bgzDqoIkBK16GCKu2LPSgTrWwgEpP7k5P4ZHXvJvfQB6dT5bUqjt3IRN2YnJ5kcwRLstHwUVGwbSdUmlOMGx6nemDYbPmAibiROhMxc4IjlNv+rKPQDssJFSpQewlsSdduJih5vaJA8VXfBuozaM/ujQVsLod/uwVb/OyMaskDaeaCSLVGD3hz++WZ41HjY5Iv7ZISry78ldyM1obOuAFTAikgbf9kXJZ5PcTk9kT/GXQuFy6YoAmK/lZmg+ZEN+2WYDyGMXxXuW/j7+v9ewerqtjr1S75561sEuwCOGcYk75OqNa9iV65+ZNd9/C4WpWoZtfJdGJfZ1Q3NGLkwjk8ok8HCjZFFYYIZaWlFkzYnq3CguB1KIT3O5vgfqY7nhnodzXyn4G4QLgWdvvEjCWl/T9tRmOH0fiC/0Y0t3Kqq8cXDT3XzWHdDYzqaAxuQz5r0dBUiEgsGLcMeBx0Y635PWe4rIB4dy7eB9Hul0t97Nd+bkWSXhMSYpWlsMrHj01fy
 PtjABkWw
 uyNHM3fCe1ULB6EEAi9u/Cvq+If0pOsm6qFlI6wccUMViSFuFwbBb5d9ZF3zV6NX5bJ+Xw8hIKO+iYxk4ej7TQWvBJTZLAUkEmavWWuhL01talJ96XueVxIKjLhaUUL3pKYaaEyyUWoIjoZk+qgULh1md9k5vVX4VAWG7NO97RdriDgnsqBBprrdUku11xJ1Ee3IjDcDs/avsXB7BeDeDmY+a/n1+4ravuFRH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13 2025, Pratyush Yadav wrote:

> On Fri, Oct 10 2025, Breno Leitao wrote:
>
>> Hello Chanyuan, Mike,
>>
>> On Fri, May 09, 2025 at 12:46:19AM -0700, Changyuan Lyu wrote:
>>> --- a/mm/memblock.c
>>> +++ b/mm/memblock.c
>>> @@ -492,7 +492,7 @@ static int __init_memblock memblock_double_array(struct memblock_type *type,
>>>  	 * needn't do it
>>>  	 */
>>>  	if (!use_slab)
>>> -		BUG_ON(memblock_reserve(addr, new_alloc_size));
>>> +		BUG_ON(memblock_reserve_kern(addr, new_alloc_size));
>>>  
>>>  	/* Update slab flag */
>>>  	*in_slab = use_slab;
>>> @@ -642,7 +642,7 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>>>  #ifdef CONFIG_NUMA
>>>  			WARN_ON(nid != memblock_get_region_node(rgn));
>>>  #endif
>>> -			WARN_ON(flags != rgn->flags);
>>> +			WARN_ON(flags != MEMBLOCK_NONE && flags != rgn->flags);
>>
>> I am hitting some sporadic warnings at early boot on a production kernel
>> (6.16). Unfortunately this issue is not easily reproduce for me to test on
>> upstream.
>>
>> 	09:14:44  BIOS-provided physical RAM map:
>> 	09:14:44  BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
>> 	09:14:44  BIOS-e820: [mem 0x00000000000a0000-0x00000000000fffff] reserved
>> 	09:14:44  BIOS-e820: [mem 0x0000000000100000-0x0000000064cb7fff] usable
>> 	09:14:44  BIOS-e820: [mem 0x0000000064cb8000-0x0000000064dc3fff] reserved
>> 	09:14:44  BIOS-e820: [mem 0x0000000064dc4000-0x0000000065b13fff] usable
>> 	09:14:44  BIOS-e820: [mem 0x0000000065b14000-0x0000000065b61fff] reserved
>> 	09:14:44  BIOS-e820: [mem 0x0000000065b62000-0x0000000065ed0fff] usable
>> 	09:14:44  BIOS-e820: [mem 0x0000000065ed1000-0x0000000065f2bfff] reserved
>> 	09:14:44  BIOS-e820: [mem 0x0000000065f2c000-0x0000000066621fff] usable
>> 	09:14:44  BIOS-e820: [mem 0x0000000066622000-0x0000000066630fff] reserved
>> 	09:14:44  BIOS-e820: [mem 0x0000000066631000-0x0000000068107fff] usable
>> 	09:14:44  BIOS-e820: [mem 0x0000000068108000-0x000000006819dfff] ACPI data
>> 	09:14:44  BIOS-e820: [mem 0x000000006819e000-0x000000006a48cfff] usable
>> 	09:14:44  BIOS-e820: [mem 0x000000006a48d000-0x000000006c58cfff] reserved
>> 	09:14:44  BIOS-e820: [mem 0x000000006c58d000-0x000000006c5dcfff] ACPI data
>> 	09:14:44  BIOS-e820: [mem 0x000000006c5dd000-0x000000006cfdcfff] ACPI NVS
>> 	09:14:44  BIOS-e820: [mem 0x000000006cfdd000-0x000000006e9fcfff] reserved
>> 	09:14:44  BIOS-e820: [mem 0x000000006e9fd000-0x000000006fffffff] usable
>> 	09:14:44  BIOS-e820: [mem 0x0000000070000000-0x000000008fffffff] reserved
>> 	09:14:44  BIOS-e820: [mem 0x00000000fd000000-0x00000000fe7fffff] reserved
>> 	09:14:44  BIOS-e820: [mem 0x00000000fed20000-0x00000000fed44fff] reserved
>> 	09:14:44  BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
>> 	09:14:44  BIOS-e820: [mem 0x0000000100000000-0x000000107fff655f] usable
>> 	09:14:44  BIOS-e820: [mem 0x000000107fff6560-0x000000107fff656f] type 128
>> 	09:14:44  BIOS-e820: [mem 0x000000107fff6570-0x000000107fffffff] usable
>> 	09:14:44  random: crng init done
>> 	09:14:44  ------------[ cut here ]------------
>> 	09:14:44 WARNING: CPU: 0 PID: 0 at mm/memblock.c:668 memblock_add_range (mm/memblock.c:668)
>> 	09:14:44  Modules linked in:
>> 	09:14:44  Tainted: [S]=CPU_OUT_OF_SPEC
>> 	09:14:44 RIP: 0010:memblock_add_range (mm/memblock.c:668)
>> 	09:14:44 Code: 28 80 3c 01 00 0f 84 04 fd ff ff 4c 89 ef e8 6c 77 09 00 e9 f7 fc ff ff 0f 0b 83 7c 24 1c 00 0f 85 9c fd ff ff e9 c5 fd ff ff <0f> 0b e9 be fd ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 6b fd
>> 	All code
>> 	========
>> 	0:    28 80 3c 01 00 0f        sub    %al,0xf00013c(%rax)
>> 	6:    84 04 fd ff ff 4c 89     test   %al,-0x76b30001(,%rdi,8)
>> 	d:    ef                       out    %eax,(%dx)
>> 	e:    e8 6c 77 09 00           call   0x9777f
>> 	13:    e9 f7 fc ff ff           jmp    0xfffffffffffffd0f
>> 	18:    0f 0b                    ud2
>> 	1a:    83 7c 24 1c 00           cmpl   $0x0,0x1c(%rsp)
>> 	1f:    0f 85 9c fd ff ff        jne    0xfffffffffffffdc1
>> 	25:    e9 c5 fd ff ff           jmp    0xfffffffffffffdef
>> 	2a:*    0f 0b                    ud2            <-- trapping instruction
>> 	2c:    e9 be fd ff ff           jmp    0xfffffffffffffdef
>> 	31:    44 89 f1                 mov    %r14d,%ecx
>> 	34:    80 e1 07                 and    $0x7,%cl
>> 	37:    80 c1 03                 add    $0x3,%cl
>> 	3a:    38 c1                    cmp    %al,%cl
>> 	3c:    0f                       .byte 0xf
>> 	3d:    8c 6b fd                 mov    %gs,-0x3(%rbx)
>>
>> 	Code starting with the faulting instruction
>> 	===========================================
>> 	0:    0f 0b                    ud2
>> 	2:    e9 be fd ff ff           jmp    0xfffffffffffffdc5
>> 	7:    44 89 f1                 mov    %r14d,%ecx
>> 	a:    80 e1 07                 and    $0x7,%cl
>> 	d:    80 c1 03                 add    $0x3,%cl
>> 	10:    38 c1                    cmp    %al,%cl
>> 	12:    0f                       .byte 0xf
>> 	13:    8c 6b fd                 mov    %gs,-0x3(%rbx)
>> 	09:14:44  RSP: 0000:ffffffff85e07d48 EFLAGS: 00010083 ORIG_RAX: 0000000000000000
>> 	09:14:44  RAX: 0000000000000020 RBX: 0000000000001c00 RCX: dffffc0000000000
>> 	09:14:44  RDX: 000000000009f000 RSI: 000000000009d000 RDI: ffffffff8685ebf8
>> 	09:14:44  RBP: 0000000000000002 R08: 0000000000000020 R09: 0000000000000000
>> 	09:14:44  R10: ffffffffff200570 R11: fffffbffffe400b2 R12: 000000000009d000
>> 	09:14:44  R13: 0000000000100000 R14: ffffffff8edf5ce4 R15: ffffffff8edf5ce0
>> 	09:14:44  FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
>> 	09:14:44  CR2: ffff888059e2dff8 CR3: 000000005bc1d000 CR4: 00000000000000b0
>> 	09:14:44  Call Trace:
>> 	09:14:44   <TASK>
>> 	09:14:44 ? __memblock_reserve (mm/memblock.c:936)
>> 	09:14:44 ? add_early_ima_buffer (arch/x86/kernel/setup.c:413)
>> 	09:14:44 ? parse_setup_data (arch/x86/kernel/setup.c:500)
>> 	09:14:44 ? setup_arch (arch/x86/kernel/setup.c:245 arch/x86/kernel/setup.c:958)
>> 	09:14:44 ? start_kernel (init/main.c:922)
>> 	09:14:44 ? x86_64_start_reservations (arch/x86/kernel/ebda.c:57)
>> 	09:14:44 ? x86_64_start_kernel (arch/x86/kernel/head64.c:231)
>> 	09:14:44 ? common_startup_64 (arch/x86/kernel/head_64.S:419)
>> 	09:14:44   </TASK>
>> 	....
>> 	Memory: 49640988K/66772816K available (54946K kernel code, 19058K rwdata, 22636K rodata, 2940K init, 120968K bss, 10650188K reserved, 6291456K cma-reserved)
>>
>> So, there is a memory override, and I am curious about it. Do you think it
>
> Yeah, it seems IMA is reserving a region that overlaps a region reserved
> by something else that doesn't use memblock_reserve_kern().
>
>> would be useful to expand this warning to dump more information about the
>> issue? (only compiled tested)
>>
>> 	if (flags != MEMBLOCK_NONE && flags != rgn->flags) {
>> 		pr_warn("memblock: Flag mismatch at region [%pa-%pa]\n",
>> 			&rgn->base, &rend);
>> 		pr_warn("  Existing region flags: %#x\n", rgn->flags);
>> 		pr_warn("  New range flags: %#x\n", flags);
>> 		pr_warn("  New range: [%pa-%pa]\n", &base, &end);
>> 		WARN_ON_ONCE(1);
>> 	}
>
> I suppose this would be useful. I think enabling memblock debug prints
> would also be helpful (using the "memblock=debug" commandline parameter)
> if it doesn't impact your production environment too much.

Actually, I think "memblock=debug" is going to be the more useful thing
since it would also show what function allocated the overlapping range
and the flags it was allocated with.

On my qemu VM with KVM, this results in around 70 prints from memblock.
So it adds a bit of extra prints but nothing that should be too
disrupting I think. Plus, only at boot so the worst thing you get is
slightly slower boot times.

-- 
Regards,
Pratyush Yadav

