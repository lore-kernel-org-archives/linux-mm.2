Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A4BAD0E6C4
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 12:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3BB66B0008; Tue, 25 Nov 2025 07:23:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E135B6B002A; Tue, 25 Nov 2025 07:23:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D295A6B002B; Tue, 25 Nov 2025 07:23:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE1E16B0008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:23:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A3DA131270
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:23:15 +0000 (UTC)
X-FDA: 84149044350.04.76D926A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9E282180008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:23:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PrkIGiiH;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764073393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6u/e9Bl+58OV6dGb303lDWzf7gS76A7HV+spLpj29o=;
	b=NYRHOTKmphJLtZEes5TnQtLUIYoKOya2UBQ3cMUpWLV4ppCeXOGyJoApynibnb1aAPvgPN
	DNNKwH7FRtxm4nQd4wGPCf/eolBjUqWJKFtavA5MUR//ZVgoo5ut+IYutyLmgBIQXcNKsn
	te3dZa67HJCrfAC4SiJeVegLDAGhiSM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PrkIGiiH;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764073393; a=rsa-sha256;
	cv=none;
	b=Ww1TGhG3Hoi3RyHycA1zIER5lF+DwLHQ8TFnHd8WZRO6oOmEqrLOakX3wofOwx2WpjDLTf
	yVMnoHzHql1EcylgMEW5cydmzxDjnv+uUIv4daHSBifDVUAIHqRxKkWfgD1AfCgi4qhJGK
	zzX/sF4v2i7Q+QtWABq72kuUkAsg5RM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 587AB43CD0;
	Tue, 25 Nov 2025 12:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA125C4CEF1;
	Tue, 25 Nov 2025 12:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764073392;
	bh=dgBsZgJWsujT1G5ZZyKp5poEm84jGPGY7WbAbiL0MR0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=PrkIGiiHSiipdIgzxPoyKCJ4Fy3jRwcIwcp5kblp2SuzY9IJRC9td8hSxj7WBX+OK
	 tHsOa1jxjoE8ceReNCftcWRT98GvaRM0Ia8paupqWSuu06gNtntWVK2V4LQWr0WsV7
	 VGIT5x3vE1vHyOipQTu/CVZ/WVCeMe+WT6R2hFP8Jj95v9ajS+QegQGNA9Diro6RHD
	 FIV26stHU8SOFSWUTETfYamJZmJqnmIg2kx494WXDxRs+HUC0o5o9j6B2MVoEucVx2
	 vyKGLTcBVIH5jsgc2lFyq6s8Xt3D454mrw3aOT/8J72JonvIU8bLUsk2B2hRd/b7TU
	 THa3yTkV/FFbA==
From: Pratyush Yadav <pratyush@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Usama Arif <usamaarif642@gmail.com>,  Changyuan Lyu
 <changyuanl@google.com>,  akpm@linux-foundation.org,
  linux-kernel@vger.kernel.org,  Mike Rapoport <rppt@kernel.org>,
  anthony.yznaga@oracle.com,  arnd@arndb.de,  ashish.kalra@amd.com,
  benh@kernel.crashing.org,  bp@alien8.de,  catalin.marinas@arm.com,
  corbet@lwn.net,  dave.hansen@linux.intel.com,
  devicetree@vger.kernel.org,  dwmw2@infradead.org,  ebiederm@xmission.com,
  graf@amazon.com,  jgowans@amazon.com,  kexec@lists.infradead.org,
  krzk@kernel.org,  linux-arm-kernel@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-mm@kvack.org,  luto@kernel.org,
  mark.rutland@arm.com,  mingo@redhat.com,  pasha.tatashin@soleen.com,
  pbonzini@redhat.com,  peterz@infradead.org,  robh@kernel.org,
  rostedt@goodmis.org,  saravanak@google.com,
  skinsburskii@linux.microsoft.com,  tglx@linutronix.de,
  thomas.lendacky@amd.com,  will@kernel.org,  x86@kernel.org,  Breno Leitao
 <leitao@debian.org>,  thevlad@meta.com
Subject: Re: [PATCH v8 12/17] x86/e820: temporarily enable KHO scratch for
 memory below 1M
In-Reply-To: <22BDBF5C-C831-4BBC-A854-20CA77234084@zytor.com> (H. Peter
	Anvin's message of "Mon, 24 Nov 2025 16:56:34 -0800")
References: <20250509074635.3187114-1-changyuanl@google.com>
	<20250509074635.3187114-13-changyuanl@google.com>
	<a0f875f1-45ad-4dfc-b5c8-ecb51b242523@gmail.com>
	<22BDBF5C-C831-4BBC-A854-20CA77234084@zytor.com>
Date: Tue, 25 Nov 2025 13:23:05 +0100
Message-ID: <mafs08qfuxpw6.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9E282180008
X-Stat-Signature: qirspajmg3ght9ygdumgfon5u5rpmmup
X-Rspam-User: 
X-HE-Tag: 1764073393-293692
X-HE-Meta: U2FsdGVkX1828+RLLkv7HP4ZUk13YmmohvCg0slcZgJFKa+JTO05cmX+exlWTC9mt+HZcJ+/ISG5biFA+ncGhiChPQdP/1OA786OYgYhsgzZ6qtM75JCQZlCn1PlMtzpWCiGr6lxuQ4foSiGzPxbBMe4DtOUTBH50a4A2OUlNULqCfQXFp0Spt46Wghm3uz3TnwoPhdqfikhHrWTJ9+H6V0A6G0sERBnex0KdYK0js2dIsaqqDOPP+F/B/c7s/m3zinyHKzlbak5nlT3k+3T2TiGX/cinf2hWI1w8PknXw2yi5gcaXhf6nBia8HP9ZTvmrgouRTSTWN8mjpjQ2u5XZyaoveG3z2GuwWJYiUgK9wxAAjXzTW9GIRfJjr3DBbOC92C3i9lbq4+yyGI2K9KwjqMCqAcY8ncksQb+AHJAU/2X0IZ87p4dB/EkEGoW+lQpMsLpK6r+2jJn+4LT+h2BN3ZPWqHTq6T+OS3TNfdpSlMFvF26LHrrwST4CGpLSNFsNiWskJ12OPS7QW0GjB58j+KBHQTZ5mjEUcYER9Wo+YmUIjGke8ynw1wZ9ndAbCiIZYfkThX22JOrflSteMiclMXGcAs7CDOx9ox2KQVujBKm3e5ZXQShMatIbne4sZNwYLfxoUnH5gHl85DuyNDC7qHgmLhqae4r+QiU/TxDRZg/ZOo75r3NmezkL7vj5+qsE6g5fc9cUqDrCpeKblx9PLcnXXnlR4KTVgLRQq3L3+s/BQpqI33ZK6XYiHOUGky9UD2BGpi+1sXF9RzZTZi0/VEXz5MwTji6cqZOVohW35XOcp2V57bggb2dl7oPOz4HSFXMA1JtXB/KX6I0lO5yAHBRvepNPMs41fY02zQMFVcJEc9n+GhW8djjM58ngyieU2hxUbVdsZyG3y25MapQdxYXFtWiV7RdQth1Ej1rtxBFeXw+vZ/KO76mmyk9bywaEPwu23O8Mn4Z5KpYgO
 iIi1t8MO
 CwDbkxk8sEbFfCnW4NYLYkvPyb/UsOhbyK7hyZWVFG1dWmZYMpjTLgzsMzq0lSkEjF/jH394v+llLafEUxua8Kme2qHluMTBXgDuVZ0D2HWzTtdUYmroezmPA6DjinS2V/dWiGtUxWoIkvFUTRQ467iU5QDmBtI7WE9xCBc1MN/PqirdgXIDZfBhl9LjFEFIbcw2Hk/FhtQT1+jPO7KVPKyMbUNjFUQCu3aprEjytFJMj7aL0VhnPcd3PwE/ESstBLQI3y3GvGE+TARbHbnZopFF4Aa0jiH46ASTrYN4u3gQ/4dwSfwJp840GK+qC2xDizW9S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24 2025, H. Peter Anvin wrote:

> On November 24, 2025 11:24:58 AM PST, Usama Arif <usamaarif642@gmail.com> wrote:
>>
>>
>>On 09/05/2025 08:46, Changyuan Lyu wrote:
>>> From: Alexander Graf <graf@amazon.com>
>>> 
>>> KHO kernels are special and use only scratch memory for memblock
>>> allocations, but memory below 1M is ignored by kernel after early boot
>>> and cannot be naturally marked as scratch.
>>> 
>>> To allow allocation of the real-mode trampoline and a few (if any) other
>>> very early allocations from below 1M forcibly mark the memory below 1M
>>> as scratch.
>>> 
>>> After real mode trampoline is allocated, clear that scratch marking.
>>> 
>>> Signed-off-by: Alexander Graf <graf@amazon.com>
>>> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> Co-developed-by: Changyuan Lyu <changyuanl@google.com>
>>> Signed-off-by: Changyuan Lyu <changyuanl@google.com>
>>> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
>>> ---
>>>  arch/x86/kernel/e820.c   | 18 ++++++++++++++++++
>>>  arch/x86/realmode/init.c |  2 ++
>>>  2 files changed, 20 insertions(+)
>>> 
>>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>>> index 9920122018a0b..c3acbd26408ba 100644
>>> --- a/arch/x86/kernel/e820.c
>>> +++ b/arch/x86/kernel/e820.c
>>> @@ -1299,6 +1299,24 @@ void __init e820__memblock_setup(void)
>>>  		memblock_add(entry->addr, entry->size);
>>>  	}
>>>  
>>> +	/*
>>> +	 * At this point memblock is only allowed to allocate from memory
>>> +	 * below 1M (aka ISA_END_ADDRESS) up until direct map is completely set
>>> +	 * up in init_mem_mapping().
>>> +	 *
>>> +	 * KHO kernels are special and use only scratch memory for memblock
>>> +	 * allocations, but memory below 1M is ignored by kernel after early
>>> +	 * boot and cannot be naturally marked as scratch.
>>> +	 *
>>> +	 * To allow allocation of the real-mode trampoline and a few (if any)
>>> +	 * other very early allocations from below 1M forcibly mark the memory
>>> +	 * below 1M as scratch.
>>> +	 *
>>> +	 * After real mode trampoline is allocated, we clear that scratch
>>> +	 * marking.
>>> +	 */
>>> +	memblock_mark_kho_scratch(0, SZ_1M);
>>> +
>>>  	/*
>>>  	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
>>>  	 * to even less without it.
>>> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
>>> index f9bc444a3064d..9b9f4534086d2 100644
>>> --- a/arch/x86/realmode/init.c
>>> +++ b/arch/x86/realmode/init.c
>>> @@ -65,6 +65,8 @@ void __init reserve_real_mode(void)
>>>  	 * setup_arch().
>>>  	 */
>>>  	memblock_reserve(0, SZ_1M);
>>> +
>>> +	memblock_clear_kho_scratch(0, SZ_1M);
>>>  }
>>>  
>>>  static void __init sme_sev_setup_real_mode(struct trampoline_header *th)
>>
>>Hello!
>>
>>I am working with Breno who reported that we are seeing the below warning at boot
>>when rolling out 6.16 in Meta fleet. It is difficult to reproduce on a single host
>>manually but we are seeing this several times a day inside the fleet.
>>
>> 20:16:33  ------------[ cut here ]------------
>> 20:16:33  WARNING: CPU: 0 PID: 0 at mm/memblock.c:668 memblock_add_range+0x316/0x330
>> 20:16:33  Modules linked in:
>> 20:16:33  CPU: 0 UID: 0 PID: 0 Comm: swapper Tainted: G S                  6.16.1-0_fbk0_0_gc0739ee5037a #1 NONE 
>> 20:16:33  Tainted: [S]=CPU_OUT_OF_SPEC
>> 20:16:33  RIP: 0010:memblock_add_range+0x316/0x330
>> 20:16:33  Code: ff ff ff 89 5c 24 08 41 ff c5 44 89 6c 24 10 48 63 74 24 08 48 63 54 24 10 e8 26 0c 00 00 e9 41 ff ff ff 0f 0b e9 af fd ff ff <0f> 0b e9 b7 fd ff ff 0f 0b 0f 0b cc cc cc cc cc cc cc cc cc cc cc
>> 20:16:33  RSP: 0000:ffffffff83403dd8 EFLAGS: 00010083 ORIG_RAX: 0000000000000000
>> 20:16:33  RAX: ffffffff8476ff90 RBX: 0000000000001c00 RCX: 0000000000000002
>> 20:16:33  RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffffff83bad4d8
>> 20:16:33  RBP: 000000000009f000 R08: 0000000000000020 R09: 8000000000097101
>> 20:16:33  R10: ffffffffff2004b0 R11: 203a6d6f646e6172 R12: 000000000009ec00
>> 20:16:33  R13: 0000000000000002 R14: 0000000000100000 R15: 000000000009d000
>> 20:16:33  FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
>> 20:16:33  CR2: ffff888065413ff8 CR3: 00000000663b7000 CR4: 00000000000000b0
>> 20:16:33  Call Trace:
>> 20:16:33   <TASK>
>> 20:16:33   ? __memblock_reserve+0x75/0x80
>> 20:16:33   ? setup_arch+0x30f/0xb10
>> 20:16:33   ? start_kernel+0x58/0x960
>> 20:16:33   ? x86_64_start_reservations+0x20/0x20
>> 20:16:33   ? x86_64_start_kernel+0x13d/0x140
>> 20:16:33   ? common_startup_64+0x13e/0x140
>> 20:16:33   </TASK>
>> 20:16:33  ---[ end trace 0000000000000000 ]--- 
>>
>>
>>Rolling out with memblock=debug is not really an option in a large scale fleet due to the
>>time added to boot. But I did try on one of the hosts (without reproducing the issue) and I see:
>>
>>[    0.000616]  memory.cnt  = 0x6
>>[    0.000617]  memory[0x0]	[0x0000000000001000-0x000000000009bfff], 0x000000000009b000 bytes flags: 0x40
>>[    0.000620]  memory[0x1]	[0x000000000009f000-0x000000000009ffff], 0x0000000000001000 bytes flags: 0x40
>>[    0.000621]  memory[0x2]	[0x0000000000100000-0x000000005ed09fff], 0x000000005ec0a000 bytes flags: 0x0
>>...
>>
>>The 0x40 (MEMBLOCK_KHO_SCRATCH) is coming from memblock_mark_kho_scratch in e820__memblock_setup. I believe this
>>should be under ifdef like the diff at the end? (Happy to send this as a patch for review if it makes sense).
>>We have KEXEC_HANDOVER disabled in our defconfig, therefore MEMBLOCK_KHO_SCRATCH shouldnt be selected and
>>we shouldnt have any MEMBLOCK_KHO_SCRATCH type regions in our memblock reservations.
>>
>>The other thing I did was insert a while(1) just before the warning and inspected the registers in qemu.
>>R14 held the base register, and R15 held the size at that point.
>>In the warning R14 is 0x100000 meaning that someone is reserving a region with a different flag to MEMBLOCK_NONE
>>at the boundary of MEMBLOCK_KHO_SCRATCH.
>>
>>diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>>index c3acbd26408ba..26e4062a0bd09 100644
>>--- a/arch/x86/kernel/e820.c
>>+++ b/arch/x86/kernel/e820.c
>>@@ -1299,6 +1299,7 @@ void __init e820__memblock_setup(void)
>>                memblock_add(entry->addr, entry->size);
>>        }
>> 
>>+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
>>        /*
>>         * At this point memblock is only allowed to allocate from memory
>>         * below 1M (aka ISA_END_ADDRESS) up until direct map is completely set
>>@@ -1316,7 +1317,7 @@ void __init e820__memblock_setup(void)
>>         * marking.
>>         */
>>        memblock_mark_kho_scratch(0, SZ_1M);
>>-
>>+#endif
>>        /*
>>         * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
>>         * to even less without it.
>>diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
>>index 88be32026768c..1cd80293a3e23 100644
>>--- a/arch/x86/realmode/init.c
>>+++ b/arch/x86/realmode/init.c
>>@@ -66,8 +66,9 @@ void __init reserve_real_mode(void)
>>         * setup_arch().
>>         */
>>        memblock_reserve(0, SZ_1M);
>>-
>>+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
>>        memblock_clear_kho_scratch(0, SZ_1M);
>>+#endif
>> }
>> 
>> static void __init sme_sev_setup_real_mode(struct trampoline_header *th)
>
> What does "scratch" mean in this exact context? (Sorry, don't have the code in front of me.)

See https://docs.kernel.org/core-api/kho/concepts.html#scratch-regions

-- 
Regards,
Pratyush Yadav

