Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03B03CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 14:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610178E0044; Mon, 13 Oct 2025 10:59:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7EA8E0017; Mon, 13 Oct 2025 10:59:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5252E8E0044; Mon, 13 Oct 2025 10:59:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F82E8E0017
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 10:59:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDF5A11A4D1
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:59:41 +0000 (UTC)
X-FDA: 83993400162.10.FA5303A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B84240006
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:59:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WTk8n4Fz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760367580; a=rsa-sha256;
	cv=none;
	b=ki+3rALF/jYO7UKCHRwS8qlCq9Wr2vX33HGCfX2mFsikXQhrMuzOodRgD5JJq/kFZEcFQ7
	tpWzzCC65ukfZoEUCV2C38/MswBBlrq4cwxDbsL2FesY2ZMoKWO/KOVtQjW/2jg/WDT6e4
	3FEZBFJfhZkzKK9WnplmEEwBavHaBxM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WTk8n4Fz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760367580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91rYI2vMdFaeelqR6EO7cjHmJcFvcuwMoHwsL+HZWMA=;
	b=Nl9ud/MN770hMYyax4uXP6FOpSWhpnGHfRi/OzU9SZXBTR410NLGAMveYbDQTYzmbpBBRZ
	NitoeHchLpN/07czfrvWzhOVPD8s+Pg84VTLIgTR5qOxczdfChtaS3T3JmhpqZR/KfyoLR
	m7CvA6Kp1wVBQ5DdKB3+KOV+XV23VxI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB6C1404E2;
	Mon, 13 Oct 2025 14:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EC5C4CEE7;
	Mon, 13 Oct 2025 14:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760367578;
	bh=Q4amGCgEx94K8om8pN467kDbQql6OA0eh29fHknE5Fw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=WTk8n4FzwfU+JNjoGVR3OOl9hk+bHZHl0+w5GZRjNYV4kcGnUqw90e8JkiIMYKBVG
	 NcRsWksnrwcNhPIi5h+FE6/w7V49pHEpvBJWDcfp0XXxUphNZwlLcwqTdOS2Xv5h7H
	 Ul0xhpRLHAp0v3U+9tWebDkckBTJyEpUQ7VkzJRTjJ7rMvZEqDE56NUEyhKX1KF1zu
	 LtNnj2IWLDizfR5k0EAVLhiypzbKxwaeEPrWlIC63tsQcyvoiy5YWWAZ6X69XXqsee
	 FAkG/CwJmqtbCg+OysuPgKOrseEsQDQlXtHMNhTe2lx3PAI0wJ8StKBXuFCzGviqs2
	 SmK2gwrIbAo8g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Changyuan Lyu <changyuanl@google.com>,  rppt@kernel.org,
  akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
  anthony.yznaga@oracle.com,  arnd@arndb.de,  ashish.kalra@amd.com,
  benh@kernel.crashing.org,  bp@alien8.de,  catalin.marinas@arm.com,
  corbet@lwn.net,  dave.hansen@linux.intel.com,
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
In-Reply-To: <ef6wfr72set5wa5el3wbbu4yd5tnc4p2rhtjpb5kpmncv3xs5d@i3c5v3ciioi3>
	(Breno Leitao's message of "Fri, 10 Oct 2025 02:33:59 -0700")
References: <20250509074635.3187114-1-changyuanl@google.com>
	<20250509074635.3187114-2-changyuanl@google.com>
	<ef6wfr72set5wa5el3wbbu4yd5tnc4p2rhtjpb5kpmncv3xs5d@i3c5v3ciioi3>
Date: Mon, 13 Oct 2025 16:59:32 +0200
Message-ID: <mafs0wm4yluej.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: bs5rjjoxfkymqywyyk33csd151yh1k1f
X-Rspamd-Queue-Id: 1B84240006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760367579-492585
X-HE-Meta: U2FsdGVkX18b+EmmWZ/M999GloZadaRdGMfDVhr+0O1vV1lomHX+4XrJMDIMCcMULHyzUwawxxzVZ4EIlURLT+A1ppAiE1UK7eCfdfo+1dRGmjigwCqi6MRjOUnL8FsuaCdB2bwVpDEzemItz51TlCkuV13OQKziS7HBW0t3m6SkFBPHTwsdWmgpGq5O1/ewsgOZ3oY3CLDVDLNRotAgzMuIoodPtbjh0JVWAn9eOGa7QEtGMEGh17Myn6inIip1b0xFKXjWIAw+56vrihNFU1KA7XceqEiD4n3Ghq2eiw0MWJTZ6joytftiDBcM/rDvpnxlhLyuiZdesRFxsAIo5cndQioUrLmqXd8CPFx9CE3oarYkY5dqca7ZIVfom1OoM63eLB9la3SwphkluKxYhTC/T20KYvveSmOAvfDtJ3zF41M8LU9nPTJ/Hv3DOAskYPFwFIEFpY2LXhbZfoOx6K1Gt4SKfXuSpYBCjIGGhvWhtn5yOpnswf1WIA+DVYocWFicGTmFfoHiUE+aA+iZqHZ8vMy4JaDr6sAvH3l00lVRqM0bkXM0qc7+A/HFw3fpchJZZeQvkZMbmFwP+m3YqoFlDaCU0u4gs8yhuQF5ldbHZ8Z8exu8QoHbttdeQKZ9sA5NgiD8S2oOlTUNIprMXXD4/Z4f7CCSavih5rfZJAoqUbssrNhWgZW9NNz4E2FCF9wANwlT1H+vlevIqGwNeg3RgK0mIE6yZNAIhtvedY5aWi3YrGW60hCP8HgRV07VWwQ9f1f0b8hAI8PwQNuHxxuw/TpYEbB3PBhSFiNiXFF11wcIJM5fpdMQ1VhHoBqRs8rGJNiMcCAP46xt4taSCI1ytFRY+UHTTifc/dB7Q2nxDT+aUr5Y4K0SmpKZJO0yc1sL6EoHNoRPDS28XNpcR+M0Rjln7OR0z94v5e06n+Jhy22IMlAtVjexZT4qX4t3YtSfZeLHaDfsMPwgbOn
 K5EpA+Si
 xnd6upEO7AwOxtNQ9Cfu1Qtd1JIQIo/tTReehEMSgcqViIaKRDx5vkzs2fn9FMPZVDE54VFPQMvGXJgxUWYUPFn7BkB5JMukzDqoT1QfGMtvBHTSCTlPX+o8xNdQeKvCXTpjd1VZbKSEq9ABh/YcvS6xGskFW3RVY6h2Bsg7NB7S8nBT7QZsORC3w+Mg5RuUGvOdZ3blLsSJorSO38jp/YPkBn++kDHxrW+n5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10 2025, Breno Leitao wrote:

> Hello Chanyuan, Mike,
>
> On Fri, May 09, 2025 at 12:46:19AM -0700, Changyuan Lyu wrote:
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -492,7 +492,7 @@ static int __init_memblock memblock_double_array(struct memblock_type *type,
>>  	 * needn't do it
>>  	 */
>>  	if (!use_slab)
>> -		BUG_ON(memblock_reserve(addr, new_alloc_size));
>> +		BUG_ON(memblock_reserve_kern(addr, new_alloc_size));
>>  
>>  	/* Update slab flag */
>>  	*in_slab = use_slab;
>> @@ -642,7 +642,7 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>>  #ifdef CONFIG_NUMA
>>  			WARN_ON(nid != memblock_get_region_node(rgn));
>>  #endif
>> -			WARN_ON(flags != rgn->flags);
>> +			WARN_ON(flags != MEMBLOCK_NONE && flags != rgn->flags);
>
> I am hitting some sporadic warnings at early boot on a production kernel
> (6.16). Unfortunately this issue is not easily reproduce for me to test on
> upstream.
>
> 	09:14:44  BIOS-provided physical RAM map:
> 	09:14:44  BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
> 	09:14:44  BIOS-e820: [mem 0x00000000000a0000-0x00000000000fffff] reserved
> 	09:14:44  BIOS-e820: [mem 0x0000000000100000-0x0000000064cb7fff] usable
> 	09:14:44  BIOS-e820: [mem 0x0000000064cb8000-0x0000000064dc3fff] reserved
> 	09:14:44  BIOS-e820: [mem 0x0000000064dc4000-0x0000000065b13fff] usable
> 	09:14:44  BIOS-e820: [mem 0x0000000065b14000-0x0000000065b61fff] reserved
> 	09:14:44  BIOS-e820: [mem 0x0000000065b62000-0x0000000065ed0fff] usable
> 	09:14:44  BIOS-e820: [mem 0x0000000065ed1000-0x0000000065f2bfff] reserved
> 	09:14:44  BIOS-e820: [mem 0x0000000065f2c000-0x0000000066621fff] usable
> 	09:14:44  BIOS-e820: [mem 0x0000000066622000-0x0000000066630fff] reserved
> 	09:14:44  BIOS-e820: [mem 0x0000000066631000-0x0000000068107fff] usable
> 	09:14:44  BIOS-e820: [mem 0x0000000068108000-0x000000006819dfff] ACPI data
> 	09:14:44  BIOS-e820: [mem 0x000000006819e000-0x000000006a48cfff] usable
> 	09:14:44  BIOS-e820: [mem 0x000000006a48d000-0x000000006c58cfff] reserved
> 	09:14:44  BIOS-e820: [mem 0x000000006c58d000-0x000000006c5dcfff] ACPI data
> 	09:14:44  BIOS-e820: [mem 0x000000006c5dd000-0x000000006cfdcfff] ACPI NVS
> 	09:14:44  BIOS-e820: [mem 0x000000006cfdd000-0x000000006e9fcfff] reserved
> 	09:14:44  BIOS-e820: [mem 0x000000006e9fd000-0x000000006fffffff] usable
> 	09:14:44  BIOS-e820: [mem 0x0000000070000000-0x000000008fffffff] reserved
> 	09:14:44  BIOS-e820: [mem 0x00000000fd000000-0x00000000fe7fffff] reserved
> 	09:14:44  BIOS-e820: [mem 0x00000000fed20000-0x00000000fed44fff] reserved
> 	09:14:44  BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> 	09:14:44  BIOS-e820: [mem 0x0000000100000000-0x000000107fff655f] usable
> 	09:14:44  BIOS-e820: [mem 0x000000107fff6560-0x000000107fff656f] type 128
> 	09:14:44  BIOS-e820: [mem 0x000000107fff6570-0x000000107fffffff] usable
> 	09:14:44  random: crng init done
> 	09:14:44  ------------[ cut here ]------------
> 	09:14:44 WARNING: CPU: 0 PID: 0 at mm/memblock.c:668 memblock_add_range (mm/memblock.c:668)
> 	09:14:44  Modules linked in:
> 	09:14:44  Tainted: [S]=CPU_OUT_OF_SPEC
> 	09:14:44 RIP: 0010:memblock_add_range (mm/memblock.c:668)
> 	09:14:44 Code: 28 80 3c 01 00 0f 84 04 fd ff ff 4c 89 ef e8 6c 77 09 00 e9 f7 fc ff ff 0f 0b 83 7c 24 1c 00 0f 85 9c fd ff ff e9 c5 fd ff ff <0f> 0b e9 be fd ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 6b fd
> 	All code
> 	========
> 	0:    28 80 3c 01 00 0f        sub    %al,0xf00013c(%rax)
> 	6:    84 04 fd ff ff 4c 89     test   %al,-0x76b30001(,%rdi,8)
> 	d:    ef                       out    %eax,(%dx)
> 	e:    e8 6c 77 09 00           call   0x9777f
> 	13:    e9 f7 fc ff ff           jmp    0xfffffffffffffd0f
> 	18:    0f 0b                    ud2
> 	1a:    83 7c 24 1c 00           cmpl   $0x0,0x1c(%rsp)
> 	1f:    0f 85 9c fd ff ff        jne    0xfffffffffffffdc1
> 	25:    e9 c5 fd ff ff           jmp    0xfffffffffffffdef
> 	2a:*    0f 0b                    ud2            <-- trapping instruction
> 	2c:    e9 be fd ff ff           jmp    0xfffffffffffffdef
> 	31:    44 89 f1                 mov    %r14d,%ecx
> 	34:    80 e1 07                 and    $0x7,%cl
> 	37:    80 c1 03                 add    $0x3,%cl
> 	3a:    38 c1                    cmp    %al,%cl
> 	3c:    0f                       .byte 0xf
> 	3d:    8c 6b fd                 mov    %gs,-0x3(%rbx)
>
> 	Code starting with the faulting instruction
> 	===========================================
> 	0:    0f 0b                    ud2
> 	2:    e9 be fd ff ff           jmp    0xfffffffffffffdc5
> 	7:    44 89 f1                 mov    %r14d,%ecx
> 	a:    80 e1 07                 and    $0x7,%cl
> 	d:    80 c1 03                 add    $0x3,%cl
> 	10:    38 c1                    cmp    %al,%cl
> 	12:    0f                       .byte 0xf
> 	13:    8c 6b fd                 mov    %gs,-0x3(%rbx)
> 	09:14:44  RSP: 0000:ffffffff85e07d48 EFLAGS: 00010083 ORIG_RAX: 0000000000000000
> 	09:14:44  RAX: 0000000000000020 RBX: 0000000000001c00 RCX: dffffc0000000000
> 	09:14:44  RDX: 000000000009f000 RSI: 000000000009d000 RDI: ffffffff8685ebf8
> 	09:14:44  RBP: 0000000000000002 R08: 0000000000000020 R09: 0000000000000000
> 	09:14:44  R10: ffffffffff200570 R11: fffffbffffe400b2 R12: 000000000009d000
> 	09:14:44  R13: 0000000000100000 R14: ffffffff8edf5ce4 R15: ffffffff8edf5ce0
> 	09:14:44  FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
> 	09:14:44  CR2: ffff888059e2dff8 CR3: 000000005bc1d000 CR4: 00000000000000b0
> 	09:14:44  Call Trace:
> 	09:14:44   <TASK>
> 	09:14:44 ? __memblock_reserve (mm/memblock.c:936)
> 	09:14:44 ? add_early_ima_buffer (arch/x86/kernel/setup.c:413)
> 	09:14:44 ? parse_setup_data (arch/x86/kernel/setup.c:500)
> 	09:14:44 ? setup_arch (arch/x86/kernel/setup.c:245 arch/x86/kernel/setup.c:958)
> 	09:14:44 ? start_kernel (init/main.c:922)
> 	09:14:44 ? x86_64_start_reservations (arch/x86/kernel/ebda.c:57)
> 	09:14:44 ? x86_64_start_kernel (arch/x86/kernel/head64.c:231)
> 	09:14:44 ? common_startup_64 (arch/x86/kernel/head_64.S:419)
> 	09:14:44   </TASK>
> 	....
> 	Memory: 49640988K/66772816K available (54946K kernel code, 19058K rwdata, 22636K rodata, 2940K init, 120968K bss, 10650188K reserved, 6291456K cma-reserved)
>
> So, there is a memory override, and I am curious about it. Do you think it

Yeah, it seems IMA is reserving a region that overlaps a region reserved
by something else that doesn't use memblock_reserve_kern().

> would be useful to expand this warning to dump more information about the
> issue? (only compiled tested)
>
> 	if (flags != MEMBLOCK_NONE && flags != rgn->flags) {
> 		pr_warn("memblock: Flag mismatch at region [%pa-%pa]\n",
> 			&rgn->base, &rend);
> 		pr_warn("  Existing region flags: %#x\n", rgn->flags);
> 		pr_warn("  New range flags: %#x\n", flags);
> 		pr_warn("  New range: [%pa-%pa]\n", &base, &end);
> 		WARN_ON_ONCE(1);
> 	}

I suppose this would be useful. I think enabling memblock debug prints
would also be helpful (using the "memblock=debug" commandline parameter)
if it doesn't impact your production environment too much.

-- 
Regards,
Pratyush Yadav

