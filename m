Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2915DD0E6E5
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 14:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651A56B0023; Tue, 25 Nov 2025 09:32:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6021C6B002B; Tue, 25 Nov 2025 09:32:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F89A6B0023; Tue, 25 Nov 2025 09:32:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3AFE16B0023
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:32:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE5B5B6AD7
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:32:02 +0000 (UTC)
X-FDA: 84149368884.10.E38C8C7
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id CBD75C000B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:32:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bldf1y+2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764081120; a=rsa-sha256;
	cv=none;
	b=lPuYspVQ2IYp6tpnQPJwPW9rvOvJ4oRQdzVIDggtZgC41t4wyB9gOrqDnqKVX+xmlIl5/E
	i0FEH+ONqxYuG1TVWcPaWHKs08MBNhqBnn90M7kVUJyR0Yv7L3rBM+TTKBuKad+AxeCFOL
	HiUKTXhL9CpAE6vk30z913TmsJjtDr4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bldf1y+2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764081120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZ4ODszvfszsaMwq6cWxl41Hem6czzJu/Sexl3aAaTM=;
	b=0U8+CSlcyTbjm8b+z4/z0ErPeQ6uEqp0kBK79lSDb+rHY1u6I699H2SxO27zWF8MQAh4GG
	66haJ2h7fbIx1XiC5oxhs4Sc0LKd9FdT1oL8raSIRfh3Fmzosce765v+zCFr/7R63X4ycz
	H3JPFYfqYjbVK0US61AE3S0Vq+h+lQY=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477a1c28778so61747905e9.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 06:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764081119; x=1764685919; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EZ4ODszvfszsaMwq6cWxl41Hem6czzJu/Sexl3aAaTM=;
        b=Bldf1y+2wUJMLqSyTNWSIqwO2nHBHabqPLFAVMhTC9xtpPTTY3RfFr0Zd/4BzHmjZI
         Y1SqwGBLRTgmZa0iK/atto/Dda/18gKZQLgGM9ocPmy9aL44W9BFC20bYXJOQyQq/qku
         SgQaPnMhyths9+FZr4GWf0YrwROtZ9O93HCUWNd5ILS8nsayZ3dXgvcteZNL7AgUcqTe
         ChBnZTICnB5k4mvGZNhRLtJC3OXPMqAoXXsHv7v0F7olBXMkas7hotxOSZCdX51SdflA
         vZSiwhX9LsBnvFcs5gSNsyrwXJUmvS0g98MAZRRdBCjoUifZyE4J/0UrTHiz5fok8JIe
         LLnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764081119; x=1764685919;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EZ4ODszvfszsaMwq6cWxl41Hem6czzJu/Sexl3aAaTM=;
        b=u+nIFbeYcWqKG6tGCHEofVgMdrO1YLKknaZoH6YsKs0/hj2agq6ZiO3+PL+HXtc0vv
         Ks4e1ulI2pRCkwMZOtRCd6QKf/G4KSYEXd2ilUmoIqKLEwzVZW0vQQ9nat9HzRu666rr
         Ml9r4B4IaA0qyoauA/Bo5J7JRD12vPpg2B0gtkTUMfo0WQETih7Qq49hbUJwT9NwuQI9
         buhMQCXXEO62Phu9gE+u/ND/93xYAPNVf1Qlq1a9PrWKud8vi4Ne9L+j41B563oec3up
         hR/3GLaL0sC3tfHWhdbO5ZHvP6TYnA4PYSOOIMgGIX9WetlPGYVfCl9MkPD1WB649g3y
         QWoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKlDIcEMGYWezjah9TchSJe/fEZqiIf8DuZrypFA+g41t94w8+o72342pWluxGsl7DDVLAv/ByeQ==@kvack.org
X-Gm-Message-State: AOJu0YxMxLUssPmrGaBpJVO5kGQdlWkRT3+w259lWKFiuYvpe7O/Hl7v
	5s29BRgKN40rwyCv2yaAeMiSdR6hyvFs76H2qui0OFh/b/WXKr8qFYuM
X-Gm-Gg: ASbGnctcn6mao0HKrZtutvrr2mnuKgVjxw/L3jd8NSxHzpsjHvaSJCsqJTUdjrdaK/M
	YE0xraA/2ypfA/8gPTvgh+U/YF24ipxufi/TjkXktAFWUocjgSN24HP5cMRrdNJ74FETtTOBID6
	K79yh0qPZuMBtOM1W4Xrv94itHmbR+HgLnGyACUZq9B/KMv1lJ86IWffEQKw5sC5sWTwVUzs5ek
	zaC7No2XM+gtwMO1egSaMf6c3bQuCRHwNpZb2MgZDl31FxVVhG0YdrFN5Qk05H1E3/5j0bCNQme
	ufXy4V0Aj8oy1XMDnjCMICAvgtUNptEjfX1uHpggdBWYwdI9jZP3I6hMkgIY0Ush0Dd3l9/vuUX
	io59yLmAfMmuj0OTXUlbJttOfVasu40Q0Yy5MyjZjKl+cBEVwgaEzN38eE2RfmJedzTaGX4cyAB
	jh5DfzuyvPnxqqLxhYdgwDW4i+ePnTnlNtIV1SH6XCH7MUJRVyorpVZvAf2hBVAsM=
X-Google-Smtp-Source: AGHT+IET/PZINZcMffFdmxJigMRJhlhA6uIQoTot58T3/URSr348bM3kiSSBFmcvLwKBiV4zYcA0QA==
X-Received: by 2002:a5d:5d08:0:b0:42b:41d3:daf9 with SMTP id ffacd0b85a97d-42e0f1d5993mr3302081f8f.2.1764081118878;
        Tue, 25 Nov 2025 06:31:58 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1126:4:ce0:a4eb:eabc:d420? ([2620:10d:c092:500::5:f0ba])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e432sm33683057f8f.9.2025.11.25.06.31.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 06:31:58 -0800 (PST)
Message-ID: <80622f99-0ef4-491b-87f6-c9790dfecef6@gmail.com>
Date: Tue, 25 Nov 2025 14:31:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 12/17] x86/e820: temporarily enable KHO scratch for
 memory below 1M
Content-Language: en-GB
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Changyuan Lyu <changyuanl@google.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 anthony.yznaga@oracle.com, arnd@arndb.de, ashish.kalra@amd.com,
 benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com,
 corbet@lwn.net, dave.hansen@linux.intel.com, devicetree@vger.kernel.org,
 dwmw2@infradead.org, ebiederm@xmission.com, graf@amazon.com, hpa@zytor.com,
 jgowans@amazon.com, kexec@lists.infradead.org, krzk@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com,
 pasha.tatashin@soleen.com, pbonzini@redhat.com, peterz@infradead.org,
 robh@kernel.org, rostedt@goodmis.org, saravanak@google.com,
 skinsburskii@linux.microsoft.com, tglx@linutronix.de,
 thomas.lendacky@amd.com, will@kernel.org, x86@kernel.org,
 Breno Leitao <leitao@debian.org>, thevlad@meta.com
References: <20250509074635.3187114-1-changyuanl@google.com>
 <20250509074635.3187114-13-changyuanl@google.com>
 <a0f875f1-45ad-4dfc-b5c8-ecb51b242523@gmail.com>
 <mafs01plmxngp.fsf@kernel.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <mafs01plmxngp.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CBD75C000B
X-Stat-Signature: wbqg4ojz7nid3e3r54aw6j5rw3zbo9wb
X-HE-Tag: 1764081120-43590
X-HE-Meta: U2FsdGVkX191Pzoba2HlEAJ/6N72C8SI/pivZh9NqmvM6GCys2j/nM1nmFGHaVZ7jxGbvKU7YDaZOQnoTwiZ6vciHLCbI9EvlH83wSWONIAdCtodzB3ZFfvgFQu5c8juZ+PndhOmH492ohxZzHZu+m8XsiKC9a24844Nxe1THBNaCcfIPqbLwltrENczex/cXEKCY6sCnXnfwPncv4Q2LPqyQJrr8kGQOsCqtTdAUW/4hyOLaZ3KBBXYrmL81jjDdRe/8I/szYk7jSBF5u39e/cfzX/t6/TdowUA9EL/8LAq6qNKIWs6k4jawoebeMCuhliNDffGhkM76lZY9Y0TNAnhE2pW8RvdVhQ1VpTcJ4bvPYEyplkgW9z6CKggc4iDUZ2BxTOShWYUFWumGJPoO39tuPJmALv1GL/Kcv6N0R35ll1j+X8vcgiLFSVqcwYr6WBtLXs63nnz1jVFeDqu4I03tvTAJ+RbbOmJaVVzzx6Un6hVE/pcM3Vbt0DIUo4JjIi1yZ/Ds+9FQvBjH8HZrtTT3fFGkzarywjFfy8Qx3AEqIB8dbK1n6yng252JWUT8HaojA4MDYnaexUcFcn5CpnQ5tY8jssGTR4eWaOcQRoDpWaGS14cEgIX8PhJntPGcnQKjbaYQldHQdnyz4pHlAFRL18ip9vxCZrOwWg7xH5iQiI1xu2VmmjkDghyLCnOhFH2WHd+Xx4RCoQpEMtlU5LiiPO4z50onKRlXseRNMYXnTWhSL0JDV9rzESNgxekoMkHic2uhsXzm1KtOHj0dGVMpL504TrGVxCXgrsEErgwPXM3JMy/GG/9WOTK09plmKcFI89ZGpnRQF6NOf6rYjGPwi8pz7h29fLgj3Q3kWJNeLziMF4/32lemO/goyqmMFRGY4JIaqgfVTMzqOEHAY66fOWoiOal5Fo/mXRW5ms17aiMV2DiklWyQe0yPXSa6CZC6lfkZj18TGm5iu0
 mn6R70a/
 XLoJky0uD+KYn8PGX1WvlgXPfoKzzjVzelQocQiZmhZXoZGHbg2MJLOZH0lTv/Fz/GG+dcS4Q771T9fqTx0fAOXnfz0pRPU9xm1ouuaxEFCsB7aDLXp0OaHsjI2tGDUBfudIcPkLw0ewpGBPL81/4+uXSla9BOxlHKOI6WA99Gi+azgUvO/PQ6zGjqNcwh40vcXOHCZ6kltiFOxzV/riB4eFIvoO7OVEzF0Uee1p7+mpFQzmmsrx20PRNy5YYbjZfTANN3H3zCRlgNS9rcnLe6WhEau9ORDIhIykiwum0hy3YZooYF/a7j2vs4iHjFCmHyMBkDa51qLhUEnriLSiYl+4vpLsjciYQTbKuPstBkE5p4UuECrws56nqjeF2QOPpZ1K4ymssfceVV2CfmkOe82P8K8U3O3eDtFN6xNo/c3d62a2i3jEomYwYb7c6bPHHmYbFw/OTOXGCEPOvcToiPWFZIxlLI5rjU1clTpFTzqv/fgEy5dSoZABLPSa5TDQnOP6bhmcnvO1OI/+yIlO66zy2zdgJLrs6/fWY/Z4OzP5tRGoC9GEQvmcrqGDj1ALBxzOqZ5mBJDBg7EA/oUTu4T/ebHcvQKNm3MMOUqt2DbEe7jLRA7VQKzU/gHngp3n0FzIDKzpQvMeiEeaSqvrRDdh2seI3ihfFEdWIX/96/od1bI64p4O7PcQ9GA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/11/2025 13:15, Pratyush Yadav wrote:
> On Mon, Nov 24 2025, Usama Arif wrote:
> 
>> On 09/05/2025 08:46, Changyuan Lyu wrote:
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
>> Hello!
>>
>> I am working with Breno who reported that we are seeing the below warning at boot
>> when rolling out 6.16 in Meta fleet. It is difficult to reproduce on a single host
>> manually but we are seeing this several times a day inside the fleet.
>>
>>  20:16:33  ------------[ cut here ]------------
>>  20:16:33  WARNING: CPU: 0 PID: 0 at mm/memblock.c:668 memblock_add_range+0x316/0x330
>>  20:16:33  Modules linked in:
>>  20:16:33  CPU: 0 UID: 0 PID: 0 Comm: swapper Tainted: G S                  6.16.1-0_fbk0_0_gc0739ee5037a #1 NONE 
>>  20:16:33  Tainted: [S]=CPU_OUT_OF_SPEC
>>  20:16:33  RIP: 0010:memblock_add_range+0x316/0x330
>>  20:16:33  Code: ff ff ff 89 5c 24 08 41 ff c5 44 89 6c 24 10 48 63 74 24 08 48 63 54 24 10 e8 26 0c 00 00 e9 41 ff ff ff 0f 0b e9 af fd ff ff <0f> 0b e9 b7 fd ff ff 0f 0b 0f 0b cc cc cc cc cc cc cc cc cc cc cc
>>  20:16:33  RSP: 0000:ffffffff83403dd8 EFLAGS: 00010083 ORIG_RAX: 0000000000000000
>>  20:16:33  RAX: ffffffff8476ff90 RBX: 0000000000001c00 RCX: 0000000000000002
>>  20:16:33  RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffffff83bad4d8
>>  20:16:33  RBP: 000000000009f000 R08: 0000000000000020 R09: 8000000000097101
>>  20:16:33  R10: ffffffffff2004b0 R11: 203a6d6f646e6172 R12: 000000000009ec00
>>  20:16:33  R13: 0000000000000002 R14: 0000000000100000 R15: 000000000009d000
>>  20:16:33  FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
>>  20:16:33  CR2: ffff888065413ff8 CR3: 00000000663b7000 CR4: 00000000000000b0
>>  20:16:33  Call Trace:
>>  20:16:33   <TASK>
>>  20:16:33   ? __memblock_reserve+0x75/0x80
>>  20:16:33   ? setup_arch+0x30f/0xb10
>>  20:16:33   ? start_kernel+0x58/0x960
>>  20:16:33   ? x86_64_start_reservations+0x20/0x20
>>  20:16:33   ? x86_64_start_kernel+0x13d/0x140
>>  20:16:33   ? common_startup_64+0x13e/0x140
>>  20:16:33   </TASK>
>>  20:16:33  ---[ end trace 0000000000000000 ]--- 
>>
>>
>> Rolling out with memblock=debug is not really an option in a large scale fleet due to the
>> time added to boot. But I did try on one of the hosts (without reproducing the issue) and I see:
>>
>> [    0.000616]  memory.cnt  = 0x6
>> [    0.000617]  memory[0x0]	[0x0000000000001000-0x000000000009bfff], 0x000000000009b000 bytes flags: 0x40
>> [    0.000620]  memory[0x1]	[0x000000000009f000-0x000000000009ffff], 0x0000000000001000 bytes flags: 0x40
>> [    0.000621]  memory[0x2]	[0x0000000000100000-0x000000005ed09fff], 0x000000005ec0a000 bytes flags: 0x0
>> ...
>>
>> The 0x40 (MEMBLOCK_KHO_SCRATCH) is coming from memblock_mark_kho_scratch in e820__memblock_setup. I believe this
>> should be under ifdef like the diff at the end? (Happy to send this as a patch for review if it makes sense).
>> We have KEXEC_HANDOVER disabled in our defconfig, therefore MEMBLOCK_KHO_SCRATCH shouldnt be selected and
>> we shouldnt have any MEMBLOCK_KHO_SCRATCH type regions in our memblock reservations.
>>
>> The other thing I did was insert a while(1) just before the warning and inspected the registers in qemu.
>> R14 held the base register, and R15 held the size at that point.
>> In the warning R14 is 0x100000 meaning that someone is reserving a region with a different flag to MEMBLOCK_NONE
>> at the boundary of MEMBLOCK_KHO_SCRATCH.
> 
> I don't get this... The WARN_ON() is only triggered when the regions
> overlap. Here, there should be no overlap, since the scratch region
> should end at 0x100000 (SZ_1M) and the new region starts at 0x100000
> (SZ_1M).
> 

Yes, this is likely a separate problem. I just discovered flags = 0x40 while trying to
debug it with KEXEC_HANDOVER disabled.

> Anyway, you do indeed point at a bug. memblock_mark_kho_scratch() should
> only be called on a KHO boot, not unconditionally. So even with
> CONFIG_MEMBLOCK_KHO_SCRATCH enabled, this should only be called on a KHO
> boot, not every time.
> 
> I think the below diff should fix the warning for you by making sure the
> scratch areas are not present on non-KHO boot. I still don't know why
> you hit the warning in the first place though. If you'd be willing to
> dig deeper into that, it would be great.
> 
> Can you give the below a try and if it fixes the problem for you I can
> send it on the list.

Is there a reason for compiling this code with is_kho_boot, when we have disabled
KEXEC_HANDOVER and dont want this in? i.e. why not just ifdef it with MEMBLOCK_KHO_SCRATCH
when that defconfig is designed for it?

> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index c3acbd26408ba..0a34dc011bf91 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -16,6 +16,7 @@
>  #include <linux/firmware-map.h>
>  #include <linux/sort.h>
>  #include <linux/memory_hotplug.h>
> +#include <linux/kexec_handover.h>
>  
>  #include <asm/e820/api.h>
>  #include <asm/setup.h>
> @@ -1315,7 +1316,8 @@ void __init e820__memblock_setup(void)
>  	 * After real mode trampoline is allocated, we clear that scratch
>  	 * marking.
>  	 */
> -	memblock_mark_kho_scratch(0, SZ_1M);
> +	if (is_kho_boot())
> +		memblock_mark_kho_scratch(0, SZ_1M);
>  
>  	/*
>  	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
> index 88be32026768c..4e9b4dff17216 100644
> --- a/arch/x86/realmode/init.c
> +++ b/arch/x86/realmode/init.c
> @@ -4,6 +4,7 @@
>  #include <linux/memblock.h>
>  #include <linux/cc_platform.h>
>  #include <linux/pgtable.h>
> +#include <linux/kexec_handover.h>
>  
>  #include <asm/set_memory.h>
>  #include <asm/realmode.h>
> @@ -67,7 +68,8 @@ void __init reserve_real_mode(void)
>  	 */
>  	memblock_reserve(0, SZ_1M);
>  
> -	memblock_clear_kho_scratch(0, SZ_1M);
> +	if (is_kho_boot())
> +		memblock_clear_kho_scratch(0, SZ_1M);
>  }
>  
>  static void __init sme_sev_setup_real_mode(struct trampoline_header *th)
> 
> 


