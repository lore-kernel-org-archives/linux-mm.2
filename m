Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D64D5D0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2793C6B0031; Tue, 25 Nov 2025 13:47:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A166B00B3; Tue, 25 Nov 2025 13:47:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1AB6B00B5; Tue, 25 Nov 2025 13:47:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E643C6B0031
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:47:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 922101403B0
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:47:23 +0000 (UTC)
X-FDA: 84150012366.25.8401A83
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf12.hostedemail.com (Postfix) with ESMTP id 59E3040003
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:47:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kHkJQ3pZ;
	spf=pass (imf12.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764096441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MKt4LgiZL8PWmFKIeAL+5VfuqwKeyBt7O/W/YkhAjg=;
	b=t6vjSH3jTgoOUK4IkMVCe7OoVjd9H4yjioKg7//fRqf5p3L7y0saK70BdFuNtpePDImST/
	UbDAczXJ0cfdoEqTwEuETjm/XGm9xIiIH8XuLNRkfNeC+HAdA+uTWtYxX+4/ehsbh97w1J
	F9h0w4VpyPDXuBIQWUFNLKtccWwntuk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764096441; a=rsa-sha256;
	cv=none;
	b=oQ2t4b4myzFw9k0WRJ5JdPYlL2/pd9sUtP04+vhoacYmFqyyLWvdc469lHCKAYrsj4iwWg
	/94ZTPLQeJupNHKpCW8Pnrl/wbdfgIEx8/+BW79t0+VB6wcw2GU9chxq0jf3EdNa2UC9Gu
	37Qc007M26zTtfx9p0ScWjAXWNtGbQ8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kHkJQ3pZ;
	spf=pass (imf12.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-429c48e05aeso61161f8f.1
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764096440; x=1764701240; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1MKt4LgiZL8PWmFKIeAL+5VfuqwKeyBt7O/W/YkhAjg=;
        b=kHkJQ3pZXLrLQ3wrpWwhD0iqwfe0GSVqwJbUuCI6HPmIcCch3K3xRZuGSMwp1XGs9R
         50fE3QSdRErk7mNuzsPIWvHvJwDRX/65kY9afYY6hcF8FphVKaIIXVpapmogsI5B6/eJ
         uwzeHQkHhnobJtsJpt5uDKxZCBb8eIdj7K9v4ctOvWlzqbS+l+Qh6JnPVTDbEm+FGE2S
         Ey7Vl/RDoS3VqaimikFtEzegx9OesLqAhs9Wc0m+ZSkvOJBhSYXqOqKFI5Jg4Or6FID7
         VHMsqvGj1iNN2EXaBTQORskJqUIC5nGuFfeHSCXDvVjH5ZwuLC0JBKs8aYXYZoMIbmc0
         TrBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764096440; x=1764701240;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1MKt4LgiZL8PWmFKIeAL+5VfuqwKeyBt7O/W/YkhAjg=;
        b=MJECUHSQoeXIeJECLlEdTp0mPvQO+piSmasTSSWvCUQ6cF5Ol0oT1lfYlB0pbrCL5E
         303ibvTbtzDoxfj6BTN2LeOhNj0GkcpcyC4IQOBOWi0T4V1Bu7f1CkqsGH9GdtDndAo9
         RrVvSkEyWMjc0/yRD7c9s1n2wPP/t7McbAMGInAUquddyeGrgSVi/9GJBxAY40UP5VkE
         aNiyVaSSKzGz8TlmN+zzdB4G04xKCvEqjoSujWE5oKnpSbxWCZGNVkZchliRZaJUWi7U
         iUoy1m9UyW3WCwHmyjCFiv4eq9mq6h/bR4IytzDg4zoqijUQBhYNU8eKsyhaWK6CK2hx
         I7yQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnjCq7gLuNIM93ctw5rLtUhAzRrCoSkeqihvfW6kk8UMy+mC3qUR9W6DGmliI/wEOIq5J+6jRlKg==@kvack.org
X-Gm-Message-State: AOJu0YwePAkVjvOOLJZLeZghIgyssxAZjtb68lnm+JSjHtwumoD0essb
	V7ZHFfcMWSO3+N+S6gY7t1qBAIG3Cc8POOG2ElPtGVn/YhBfZSbE6KGQ
X-Gm-Gg: ASbGncuF/hkeammxY+FISH6Kxid0VxOsZmOaoHP6x//yWdyT3ZIOK9AsF5pwZYxie4I
	TG9q6ljMoajuAZEF0aZJDSpvy+wXH6ochH+/aze24EEm+ROvh1sghxsqmB7vE1EbM/dgVO5JwJp
	UDZlovBlp6YBJuC1Nx4uPxu9moKRFFNilMZtd9dy4qZqaNw2qAqO/tPGDlSKEiozoi10CTODAjW
	SOjbSoPNyxZZlLSsj275ck+KFHuaRGobl0L2wK2tMl2CJOTijJSejeA4FiSpFALlQ32ocSnDI74
	D57YfaZItcxWPmJDhPBU1K4iejwT/8o1W1uLK7l0vtMg9PHMMEaVwLwXdizHphALpBWfIYk6Mvh
	3fmFhN1L5abaJL3f8nRU8mlcbCyRWHNr+HV4Zd2PMVN7cV1S5DB+K8iLgVlKxr88jr051ZbycOV
	/q2m10ElUm1whqTLmf1Ec7uz2x7sZbhH178Fs7d+WuVPToRZhngzQ8hQ1187rDaIE=
X-Google-Smtp-Source: AGHT+IG/i3aZCks5WIqnGk/6a0sMPmYIN5l4APrGzVcZcpl9umy4ItmF5a7+oV8tsk34pCQpbOWSSg==
X-Received: by 2002:a5d:584f:0:b0:428:56ed:c68e with SMTP id ffacd0b85a97d-42cba652ec0mr23828199f8f.9.1764096439172;
        Tue, 25 Nov 2025 10:47:19 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1126:4:ce0:a4eb:eabc:d420? ([2620:10d:c092:500::5:f0ba])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479052ec685sm22122175e9.6.2025.11.25.10.47.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 10:47:18 -0800 (PST)
Message-ID: <ba690e06-c2a1-4d2e-9428-9ca2ea9f2b86@gmail.com>
Date: Tue, 25 Nov 2025 18:47:15 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 12/17] x86/e820: temporarily enable KHO scratch for
 memory below 1M
Content-Language: en-GB
To: Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>
Cc: Changyuan Lyu <changyuanl@google.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, anthony.yznaga@oracle.com, arnd@arndb.de,
 ashish.kalra@amd.com, benh@kernel.crashing.org, bp@alien8.de,
 catalin.marinas@arm.com, corbet@lwn.net, dave.hansen@linux.intel.com,
 devicetree@vger.kernel.org, dwmw2@infradead.org, ebiederm@xmission.com,
 graf@amazon.com, hpa@zytor.com, jgowans@amazon.com,
 kexec@lists.infradead.org, krzk@kernel.org,
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
 <mafs01plmxngp.fsf@kernel.org> <aSW0MF9BXjLnY2Fr@kernel.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <aSW0MF9BXjLnY2Fr@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 59E3040003
X-Stat-Signature: 4xxf69oq9awkddfegxpcwgwf46f1k7br
X-Rspam-User: 
X-HE-Tag: 1764096441-463292
X-HE-Meta: U2FsdGVkX1/twRQwFRSsDz3js6ml+NZulu31UGuJ8vY8LE/1BygtKl/i9P0/GiF7AAyU5zvKe7jMJpp6vt9cwsu64c7c+EmULrRHGYqCQHFNrtvZIRKOICWDQGUFNSy1KNIU7aQYvi8mxSuFSkDua+F2o6A+36JbEUClKNTmwpnjOA36i2VtjJUflxSGAA5WBm7uGiOtGnGL1yZbBFMx262IsylDRE/qfuUG5tyo/Ap4+V/z3NtBbGn8sbtJVUVHYDmmNQxlvUX9ZsU5InIQ9FG5JDMIX1N1MYpoyX2TzBT49kRkq7aFjG7CAYfXEVHKsziGel3DQEjM32o90IqVapNUmey1ELxPqG5aTKKUuAWePTCJlImd2Gd7e1bzfW8DoHRPphU/ejaRADp2mLQBXoK6N3E70YzLomOOTaEQMdLwK784Kz9M48KVOgRbN6gkyqmk6wFbxKyceShE4vF+aIZn/1Hcbei76QsAC1c4mxYi7rOQgT9+hyGYDA9oOkZNEoen3CarXGdZFlL+MuulPdAw9t6N/tS6fyDDTiTsAYMR4qFNzweyt6/68D16ceP+VXx4AUTgNj2pEfVD0UpYretiDtDiwIAQ78BJ7/jbmZVE9WtCNInEik9U+tKe08CNWI/jmIanqLPiS4cEYg7jGrBE0GrcDKVSq+iooahMkCsCoLj4FslbqYq+sLuHaQN9SE5gyX4HYzEo4fe7tP7VSPlBu7Jr/6qDWL+17MieCSxtq6ZUj60P0Atj3v1fdYb8B5FSRF3di3HIucJgodGhzfdviwPW/abmBex/yxLhXe78f0L/sTTkcchVdrBPC0OyqS0xXWahHXwbU7U11P6sr8hxWs8HvRFsOyOxNf8xqpWw7vQhnHnwEEVPOp7Gcw1gwludIfIgVmI98jnfcAYM8ikSxcx6utYMeiVZZyve9eTf7uJadWFoFqz575bh78oO7NQjuZqvKpnjeL9UA0x
 Kxlf2cHk
 jtfJKYsxhv4da7A63Dw7mbKYy6viGm+I8+iE98uyh7EfF6Ya/3hnMlOK4D6cOMSsp+cUoZKF0NygpyIYMOv+DGc/m8SchshT6kW5+ZmdFBvUbi3qj8ZV9g2HBKiegzHjC79a+/n1eZMGaRjFzznhkdS7/M1l5xxPPIhibYfERg3wnH56cVvQSdNFZ6yGAK+MgMnO0dno4ypIbeaVIK0OhkdVX5mn1eOauSY+90qtgNnusa6NWebYRuQ0mf3+xK3IlDeKHXDemyDcyqCjaoFaTJpVy/rBWc9K955Q7wrBaSdwQqbxOIp44Abei/5nWJzPKEfDuocKgfeMYxkYkiyqLLa6yOxAI0DjdoinHbVA5TsBaYFpqZ6ev9eYsXGW8aptrJWD+eK2ovU/0ugmaBGXUAMOaeIDOuIESyFC8rZKpbsYjEgibuiRiQDyEpPFwQ/R51uZIrZTBDp0uFuUbIhLLn7h7Ss9hdEKcM/eiIQrQpaEVDjMe+I0cWQZJmJJnyfyGYUmRZkw0IBrnojls7dOoGkoR4ByIk8YfuG03
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/11/2025 13:50, Mike Rapoport wrote:
> Hi,
> 
> On Tue, Nov 25, 2025 at 02:15:34PM +0100, Pratyush Yadav wrote:
>> On Mon, Nov 24 2025, Usama Arif wrote:
> 
>>>> --- a/arch/x86/realmode/init.c
>>>> +++ b/arch/x86/realmode/init.c
>>>> @@ -65,6 +65,8 @@ void __init reserve_real_mode(void)
>>>>  	 * setup_arch().
>>>>  	 */
>>>>  	memblock_reserve(0, SZ_1M);
>>>> +
>>>> +	memblock_clear_kho_scratch(0, SZ_1M);
>>>>  }
>>>>  
>>>>  static void __init sme_sev_setup_real_mode(struct trampoline_header *th)
>>>
>>> Hello!
>>>
>>> I am working with Breno who reported that we are seeing the below warning at boot
>>> when rolling out 6.16 in Meta fleet. It is difficult to reproduce on a single host
>>> manually but we are seeing this several times a day inside the fleet.
>>>
>>>  20:16:33  ------------[ cut here ]------------
>>>  20:16:33  WARNING: CPU: 0 PID: 0 at mm/memblock.c:668 memblock_add_range+0x316/0x330
>>>  20:16:33  Modules linked in:
>>>  20:16:33  CPU: 0 UID: 0 PID: 0 Comm: swapper Tainted: G S                  6.16.1-0_fbk0_0_gc0739ee5037a #1 NONE 
>>>  20:16:33  Tainted: [S]=CPU_OUT_OF_SPEC
>>>  20:16:33  RIP: 0010:memblock_add_range+0x316/0x330
>>>  20:16:33  Code: ff ff ff 89 5c 24 08 41 ff c5 44 89 6c 24 10 48 63 74 24 08 48 63 54 24 10 e8 26 0c 00 00 e9 41 ff ff ff 0f 0b e9 af fd ff ff <0f> 0b e9 b7 fd ff ff 0f 0b 0f 0b cc cc cc cc cc cc cc cc cc cc cc
>>>  20:16:33  RSP: 0000:ffffffff83403dd8 EFLAGS: 00010083 ORIG_RAX: 0000000000000000
>>>  20:16:33  RAX: ffffffff8476ff90 RBX: 0000000000001c00 RCX: 0000000000000002
>>>  20:16:33  RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffffff83bad4d8
>>>  20:16:33  RBP: 000000000009f000 R08: 0000000000000020 R09: 8000000000097101
>>>  20:16:33  R10: ffffffffff2004b0 R11: 203a6d6f646e6172 R12: 000000000009ec00
>>>  20:16:33  R13: 0000000000000002 R14: 0000000000100000 R15: 000000000009d000
>>>  20:16:33  FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
>>>  20:16:33  CR2: ffff888065413ff8 CR3: 00000000663b7000 CR4: 00000000000000b0
>>>  20:16:33  Call Trace:
>>>  20:16:33   <TASK>
>>>  20:16:33   ? __memblock_reserve+0x75/0x80
> 
> Do you have faddr2line for this?
> >>>  20:16:33   ? setup_arch+0x30f/0xb10
> 
> And this?
> 


Thanks for this! I think it helped narrow down the problem.

The stack is:

20:16:33 ? __memblock_reserve (mm/memblock.c:936) 
20:16:33 ? setup_arch (arch/x86/kernel/setup.c:413 arch/x86/kernel/setup.c:499 arch/x86/kernel/setup.c:956) 
20:16:33 ? start_kernel (init/main.c:922) 
20:16:33 ? x86_64_start_reservations (arch/x86/kernel/ebda.c:57) 
20:16:33 ? x86_64_start_kernel (arch/x86/kernel/head64.c:231) 
20:16:33 ? common_startup_64 (arch/x86/kernel/head_64.S:419) 

This is 6.16 kernel.

20:16:33 ? __memblock_reserve (mm/memblock.c:936) 
Thats memblock_add_range call in memblock_reserve

20:16:33 ? setup_arch (arch/x86/kernel/setup.c:413 arch/x86/kernel/setup.c:499 arch/x86/kernel/setup.c:956) 
That is parse_setup_data -> add_early_ima_buffer -> add_early_ima_buffer -> memblock_reserve_kern


I put a simple print like below:

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 680d1b6dfea41..cc97ffc0083c7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -409,6 +409,7 @@ static void __init add_early_ima_buffer(u64 phys_addr)
        }
 
        if (data->size) {
+               pr_err("PPP %s %s %d data->addr %llx, data->size %llx \n", __FILE__, __func__, __LINE__, data->addr, data->size);
                memblock_reserve_kern(data->addr, data->size);
                ima_kexec_buffer_phys = data->addr;
                ima_kexec_buffer_size = data->size;


and I see (without replicating the warning):

[    0.000000] PPP arch/x86/kernel/setup.c add_early_ima_buffer 412 data->addr 9e000, data->size 1000                                                                                          
....

[    0.000348] MEMBLOCK configuration:
[    0.000348]  memory size = 0x0000003fea329ff0 reserved size = 0x00000000050c969b
[    0.000350]  memory.cnt  = 0x5
[    0.000351]  memory[0x0]     [0x0000000000001000-0x000000000009ffff], 0x000000000009f000 bytes flags: 0x40
[    0.000353]  memory[0x1]     [0x0000000000100000-0x0000000067c65fff], 0x0000000067b66000 bytes flags: 0x0
[    0.000355]  memory[0x2]     [0x000000006d8db000-0x000000006fffffff], 0x0000000002725000 bytes flags: 0x0
[    0.000356]  memory[0x3]     [0x0000000100000000-0x000000407fff8fff], 0x0000003f7fff9000 bytes flags: 0x0
[    0.000358]  memory[0x4]     [0x000000407fffa000-0x000000407fffffff], 0x0000000000006000 bytes flags: 0x0
[    0.000359]  reserved.cnt  = 0x7


So MEMBLOCK_RSRV_KERN and MEMBLOCK_KHO_SCRATCH seem to overlap..

>>>  20:16:33   ? start_kernel+0x58/0x960
>>>  20:16:33   ? x86_64_start_reservations+0x20/0x20
>>>  20:16:33   ? x86_64_start_kernel+0x13d/0x140
>>>  20:16:33   ? common_startup_64+0x13e/0x140
>>>  20:16:33   </TASK>
>>>  20:16:33  ---[ end trace 0000000000000000 ]--- 
>>>
>>>
>>> Rolling out with memblock=debug is not really an option in a large scale fleet due to the
>>> time added to boot. But I did try on one of the hosts (without reproducing the issue) and I see:
> 
> Is it a problem to roll out a kernel that has additional debug printouts as
> Breno suggested earlier? I.e.
> 
> 	if (flags != MEMBLOCK_NONE && flags != rgn->flags) {
> 		pr_warn("memblock: Flag mismatch at region [%pa-%pa]\n",
> 			&rgn->base, &rend);
> 		pr_warn("  Existing region flags: %#x\n", rgn->flags);
> 		pr_warn("  New range flags: %#x\n", flags);
> 		pr_warn("  New range: [%pa-%pa]\n", &base, &end);
> 		WARN_ON_ONCE(1);
> 	}
> 

I can add this, but the only thing is that it might be several weeks between me putting this in the
kernel and that kernel being deployed to enough machines that it starts to show up. I think the IMA coinciding
with memblock_mark_kho_scratch in e820__memblock_setup could be the reason for the warning. It might be better to
fix that case and deploy it to see if the warnings still show up?
I can add these prints as well incase it doesnt fix the problem.


>>> [    0.000616]  memory.cnt  = 0x6
>>> [    0.000617]  memory[0x0]	[0x0000000000001000-0x000000000009bfff], 0x000000000009b000 bytes flags: 0x40
>>> [    0.000620]  memory[0x1]	[0x000000000009f000-0x000000000009ffff], 0x0000000000001000 bytes flags: 0x40
>>> [    0.000621]  memory[0x2]	[0x0000000000100000-0x000000005ed09fff], 0x000000005ec0a000 bytes flags: 0x0
>>> ...
>>>
>>> The 0x40 (MEMBLOCK_KHO_SCRATCH) is coming from memblock_mark_kho_scratch in e820__memblock_setup. I believe this
>>> should be under ifdef like the diff at the end? (Happy to send this as a patch for review if it makes sense).
>>> We have KEXEC_HANDOVER disabled in our defconfig, therefore MEMBLOCK_KHO_SCRATCH shouldnt be selected and
>>> we shouldnt have any MEMBLOCK_KHO_SCRATCH type regions in our memblock reservations.
>>>
>>> The other thing I did was insert a while(1) just before the warning and inspected the registers in qemu.
>>> R14 held the base register, and R15 held the size at that point.
>>> In the warning R14 is 0x100000 meaning that someone is reserving a region with a different flag to MEMBLOCK_NONE
>>> at the boundary of MEMBLOCK_KHO_SCRATCH.
> 
> Judging by the register values, flags could be in %rcx or %r13 (0x2 - MEMBLOCK_MIRROR) or in
> %r8 (0x20 - MEMBLOCK_RSRV_KERN)


I feel like it might be r8 (MEMBLOCK_RSRV_KERN) from IMA.

> 
> Since WARN_ON() is triggered in __memblock_reserve() I'd bet on
> MEMBLOCK_RSRV_KERN.
> 
> And apparently the warning triggers for some memory that was initially
> reserved with memblock_reserve() and than some of it was reserved with
> memblock_reserve_kern().
> 
> If you have the logs from failing boots up to the point where SLUB reports
> about it's initialization, e.g. 
> 
> [    0.134377] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
> 
> something there may hint about what's the issue. 


So the boot doesnt fail, its just giving warnings in the fleet.
I have added the dmesg to the end of the mail.

>  
>> I don't get this... The WARN_ON() is only triggered when the regions
>> overlap. Here, there should be no overlap, since the scratch region
>> should end at 0x100000 (SZ_1M) and the new region starts at 0x100000
>> (SZ_1M).
> 
> Not only that, the warning is from __memblock_reserve() that works with
> memblock.reserved and the dump is for memblock.memory.
> 
>> Anyway, you do indeed point at a bug. memblock_mark_kho_scratch() should
>> only be called on a KHO boot, not unconditionally. So even with
>> CONFIG_MEMBLOCK_KHO_SCRATCH enabled, this should only be called on a KHO
>> boot, not every time.
>>
>> I think the below diff should fix the warning for you by making sure the
>> scratch areas are not present on non-KHO boot. I still don't know why
>> you hit the warning in the first place though. If you'd be willing to
>> dig deeper into that, it would be great.
>>
>> Can you give the below a try and if it fixes the problem for you I can
>> send it on the list.
>>
>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>> index c3acbd26408ba..0a34dc011bf91 100644
>> --- a/arch/x86/kernel/e820.c
>> +++ b/arch/x86/kernel/e820.c
>> @@ -16,6 +16,7 @@
>>  #include <linux/firmware-map.h>
>>  #include <linux/sort.h>
>>  #include <linux/memory_hotplug.h>
>> +#include <linux/kexec_handover.h>
>>  
>>  #include <asm/e820/api.h>
>>  #include <asm/setup.h>
>> @@ -1315,7 +1316,8 @@ void __init e820__memblock_setup(void)
>>  	 * After real mode trampoline is allocated, we clear that scratch
>>  	 * marking.
>>  	 */
>> -	memblock_mark_kho_scratch(0, SZ_1M);
>> +	if (is_kho_boot())
>> +		memblock_mark_kho_scratch(0, SZ_1M);
> 
> We'd better add an inline stub to memblock.h for
> !CONFIG_MEMBLOCK_KHO_SCRATCH
> 
> and move is_kho_boot() inside memblock_{mark,clear}_kho_scratch. This might
> require moving them out of line, but it's not that they are on the hot
> paths.
> 
> BTW, this makes sense even if it does not help with the issue Breno and
> Usama are working on.
> 


Does something like this look good? I can try deploying this (although it will take sometime to find out).
We can get it upstream as well as that makes backports easier.

diff --git a/mm/memblock.c b/mm/memblock.c
index 154f1d73b61f2..257c6f0eee03d 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1119,8 +1119,13 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
  */
 __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
 {
-       return memblock_setclr_flag(&memblock.memory, base, size, 1,
-                                   MEMBLOCK_KHO_SCRATCH);
+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+       if (is_kho_boot())
+               return memblock_setclr_flag(&memblock.memory, base, size, 1,
+                                           MEMBLOCK_KHO_SCRATCH);
+#else
+       return 0;
+#endif
 }
 
 /**
@@ -1133,8 +1138,13 @@ __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
  */
 __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
 {
-       return memblock_setclr_flag(&memblock.memory, base, size, 0,
-                                   MEMBLOCK_KHO_SCRATCH);
+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
+       if (is_kho_boot())
+               return memblock_setclr_flag(&memblock.memory, base, size, 0,
+                                           MEMBLOCK_KHO_SCRATCH);
+#else
+       return 0;
+#endif
 }
 
 static bool should_skip_region(struct memblock_type *type,

>>  
>>  	/*
>>  	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
>> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
>> index 88be32026768c..4e9b4dff17216 100644
>> --- a/arch/x86/realmode/init.c
>> +++ b/arch/x86/realmode/init.c
>> @@ -4,6 +4,7 @@
>>  #include <linux/memblock.h>
>>  #include <linux/cc_platform.h>
>>  #include <linux/pgtable.h>
>> +#include <linux/kexec_handover.h>
>>  
>>  #include <asm/set_memory.h>
>>  #include <asm/realmode.h>
>> @@ -67,7 +68,8 @@ void __init reserve_real_mode(void)
>>  	 */
>>  	memblock_reserve(0, SZ_1M);
>>  
>> -	memblock_clear_kho_scratch(0, SZ_1M);
>> +	if (is_kho_boot())
>> +		memblock_clear_kho_scratch(0, SZ_1M);
>>  }
>>  
>>  static void __init sme_sev_setup_real_mode(struct trampoline_header *th)




The dmesg from one of the hosts with the warning is:

 20:16:33  BIOS-provided physical RAM map:
 20:16:33  BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
 20:16:33  BIOS-e820: [mem 0x00000000000a0000-0x00000000000fffff] reserved
 20:16:33  BIOS-e820: [mem 0x0000000000100000-0x0000000069ca3fff] usable
 20:16:33  BIOS-e820: [mem 0x0000000069ca4000-0x000000006bda3fff] reserved
 20:16:33  BIOS-e820: [mem 0x000000006bda4000-0x000000006be5efff] ACPI data
 20:16:33  BIOS-e820: [mem 0x000000006be5f000-0x000000006c9b8fff] ACPI NVS
 20:16:33  BIOS-e820: [mem 0x000000006c9b9000-0x000000006ebedfff] reserved
 20:16:33  BIOS-e820: [mem 0x000000006ebee000-0x000000006fffffff] usable
 20:16:33  BIOS-e820: [mem 0x0000000070000000-0x000000008fffffff] reserved
 20:16:33  BIOS-e820: [mem 0x00000000fd000000-0x00000000fe7fffff] reserved
 20:16:33  BIOS-e820: [mem 0x00000000fed20000-0x00000000fed44fff] reserved
 20:16:33  BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
 20:16:33  BIOS-e820: [mem 0x0000000100000000-0x000000107fff847f] usable
 20:16:33  BIOS-e820: [mem 0x000000107fff8480-0x000000107fff848f] type 128
 20:16:33  BIOS-e820: [mem 0x000000107fff8490-0x000000107fffffff] usable
 20:16:33  random: crng init done
 20:16:33  ------------[ cut here ]------------
 20:16:33  WARNING: CPU: 0 PID: 0 at mm/memblock.c:668 memblock_add_range+0x316/0x330
 20:16:33  Modules linked in:
 20:16:33  CPU: 0 UID: 0 PID: 0 Comm: swapper Tainted: G S                  6.16.1-0_fbk0_0_gc0739ee5037a #1 NONE 
 20:16:33  Tainted: [S]=CPU_OUT_OF_SPEC
 20:16:33  RIP: 0010:memblock_add_range+0x316/0x330
 20:16:33  Code: ff ff ff 89 5c 24 08 41 ff c5 44 89 6c 24 10 48 63 74 24 08 48 63 54 24 10 e8 26 0c 00 00 e9 41 ff ff ff 0f 0b e9 af fd ff ff <0f> 0b e9 b7 fd ff ff 0f 0b 0f 0b cc cc cc cc cc cc cc cc cc cc cc
 20:16:33  RSP: 0000:ffffffff83403dd8 EFLAGS: 00010083 ORIG_RAX: 0000000000000000
 20:16:33  RAX: ffffffff8476ff90 RBX: 0000000000001c00 RCX: 0000000000000002
 20:16:33  RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffffffff83bad4d8
 20:16:33  RBP: 000000000009f000 R08: 0000000000000020 R09: 8000000000097101
 20:16:33  R10: ffffffffff2004b0 R11: 203a6d6f646e6172 R12: 000000000009ec00
 20:16:33  R13: 0000000000000002 R14: 0000000000100000 R15: 000000000009d000
 20:16:33  FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
 20:16:33  CR2: ffff888065413ff8 CR3: 00000000663b7000 CR4: 00000000000000b0
 20:16:33  Call Trace:
 20:16:33   <TASK>
 20:16:33   ? __memblock_reserve+0x75/0x80
 20:16:33   ? setup_arch+0x30f/0xb10
 20:16:33   ? start_kernel+0x58/0x960
 20:16:33   ? x86_64_start_reservations+0x20/0x20
 20:16:33   ? x86_64_start_kernel+0x13d/0x140
 20:16:33   ? common_startup_64+0x13e/0x140
 20:16:33   </TASK>
 20:16:33  ---[ end trace 0000000000000000 ]---
 20:16:33  Memory allocation profiling is enabled with compression and is turned on!
 20:16:33  NX (Execute Disable) protection: active
 20:16:33  APIC: Static calls initialized
 20:16:33  efi: EFI v2.6 by American Megatrends
 20:16:33  efi: ACPI 2.0=0x6c5ec000 ACPI=0x6c5ec000 TPMFinalLog=0x6c987000 SMBIOS=0x6e69d000 SMBIOS 3.0=0x6e69c000 MEMATTR=0xffffffffffffffff ESRT=0x67d97918 INITRD=0x5f275d18 TPMEventLog=0x6be5d018 
 20:16:33  efi: Remove mem00: MMIO range=[0xff000000-0xffffffff] (16MB) from e820 map
 20:16:33  efi: Not removing mem01: MMIO range=[0xfed20000-0xfed44fff] (148KB) from e820 map
 20:16:33  efi: Remove mem02: MMIO range=[0xfd000000-0xfe7fffff] (24MB) from e820 map
 20:16:33  efi: Remove mem03: MMIO range=[0x80000000-0x8fffffff] (256MB) from e820 map
 20:16:33  SMBIOS 3.1.1 present.
 20:16:33  DMI: Quanta Twin Lakes MP/Twin Lakes Passive MP, BIOS F09_3A23 12/08/2020
 20:16:33  DMI: Memory slots populated: 4/8
 20:16:33  tsc: Detected 1600.000 MHz processor
 20:16:33  last_pfn = 0x1080000 max_arch_pfn = 0x400000000
 20:16:33  MTRR map: 8 entries (3 fixed + 5 variable; max 23), built from 10 variable MTRRs
 20:16:33  x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
 20:16:33  last_pfn = 0x70000 max_arch_pfn = 0x400000000
 20:16:33  esrt: Reserving ESRT space from 0x0000000067d97918 to 0x0000000067d97978.
 20:16:33  Using GB pages for direct mapping
 20:16:33  RAMDISK: [mem 0x5ed81000-0x62ffffff]
 20:16:33  ACPI: Early table checksum verification disabled
 20:16:33  ACPI: RSDP 0x000000006C5EC000 000024 (v02 ALASKA)
 20:16:33  ACPI: XSDT 0x000000006C5EC0C0 000104 (v01 ALASKA A M I    01072009 AMI  00010013)
 20:16:33  ACPI: FACP 0x000000006C62E590 000114 (v06 ALASKA A M I    01072009 INTL 20091013)
 20:16:33  ACPI: DSDT 0x000000006C5EC260 04232D (v02 ALASKA A M I    01072009 INTL 20091013)
 20:16:33  ACPI: FACS 0x000000006C9B7080 000040
 20:16:33  ACPI: FPDT 0x000000006C62E6A8 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
 20:16:33  ACPI: FIDT 0x000000006C62E6F0 00009C (v01 ALASKA A M I    01072009 AMI  00010013)
 20:16:33  ACPI: SPMI 0x000000006C62E790 000041 (v05 ALASKA A M I    00000000 AMI. 00000000)
 20:16:33  ACPI: UEFI 0x000000006C62E7D8 000048 (v01 ALASKA A M I    01072009      01000013)
 20:16:33  ACPI: MCFG 0x000000006C62E820 00003C (v01 ALASKA A M I    01072009 MSFT 00000097)
 20:16:33  ACPI: HPET 0x000000006C62E860 000038 (v01 ALASKA A M I    00000001 INTL 20091013)
 20:16:33  ACPI: APIC 0x000000006C62E898 00071E (v03 ALASKA A M I    00000000 INTL 20091013)
 20:16:33  ACPI: MIGT 0x000000006C62EFB8 000040 (v01 ALASKA A M I    00000000 INTL 20091013)
 20:16:33  ACPI: PCAT 0x000000006C62EFF8 000068 (v02 ALASKA A M I    00000002 INTL 20091013)
 20:16:33  ACPI: PCCT 0x000000006C62F060 00006E (v01 ALASKA A M I    00000002 INTL 20091013)
 20:16:33  ACPI: RASF 0x000000006C62F0D0 000030 (v01 ALASKA A M I    00000001 INTL 20091013)
 20:16:33  ACPI: SVOS 0x000000006C62F100 000032 (v01 ALASKA A M I    00000000 INTL 20091013)
 20:16:33  ACPI: WDDT 0x000000006C62F138 000040 (v01 ALASKA A M I    00000000 INTL 20091013)
 20:16:33  ACPI: OEM4 0x000000006C62F178 028A0C (v02 INTEL  CPU  CST 00003000 INTL 20140828)
 20:16:33  ACPI: OEM1 0x000000006C657B88 00A8CC (v02 INTEL  CPU EIST 00003000 INTL 20140828)
 20:16:33  ACPI: OEM2 0x000000006C662458 006534 (v02 INTEL  CPU  HWP 00003000 INTL 20140828)
 20:16:33  ACPI: SSDT 0x000000006C668990 00CEB8 (v02 INTEL  SSDT  PM 00004000 INTL 20140828)
 20:16:33  ACPI: SSDT 0x000000006C675848 00065B (v02 ALASKA A M I    00000000 INTL 20091013)
 20:16:33  ACPI: SPCR 0x000000006C675EA8 000050 (v02 A M I  APTIO V  01072009 AMI. 0005000E)
 20:16:33  ACPI: TPM2 0x000000006C675EF8 000034 (v04 ALASKA A M I    00000001 AMI  00000000)
 20:16:33  ACPI: SSDT 0x000000006C675F30 001368 (v02 INTEL  SpsNm    00000002 INTL 20140828)
 20:16:33  ACPI: DMAR 0x000000006C677298 0000E8 (v01 ALASKA A M I    00000001 INTL 20091013)
 20:16:33  ACPI: HEST 0x000000006C677380 0000A8 (v01 ALASKA A M I    00000001 INTL 00000001)
 20:16:33  ACPI: BERT 0x000000006C677428 000030 (v01 ALASKA A M I    00000001 INTL 00000001)
 20:16:33  ACPI: ERST 0x000000006C677458 000230 (v01 ALASKA A M I    00000001 INTL 00000001)
 20:16:33  ACPI: EINJ 0x000000006C677688 000150 (v01 ALASKA A M I    00000001 INTL 00000001)
 20:16:33  ACPI: WSMT 0x000000006C6777D8 000028 (v01 ALASKA A M I    01072009 AMI  00010013)
 20:16:33  ACPI: Reserving FACP table memory at [mem 0x6c62e590-0x6c62e6a3]
 20:16:33  ACPI: Reserving DSDT table memory at [mem 0x6c5ec260-0x6c62e58c]
 20:16:33  ACPI: Reserving FACS table memory at [mem 0x6c9b7080-0x6c9b70bf]
 20:16:33  ACPI: Reserving FPDT table memory at [mem 0x6c62e6a8-0x6c62e6eb]
 20:16:33  ACPI: Reserving FIDT table memory at [mem 0x6c62e6f0-0x6c62e78b]
 20:16:33  ACPI: Reserving SPMI table memory at [mem 0x6c62e790-0x6c62e7d0]
 20:16:33  ACPI: Reserving UEFI table memory at [mem 0x6c62e7d8-0x6c62e81f]
 20:16:33  ACPI: Reserving MCFG table memory at [mem 0x6c62e820-0x6c62e85b]
 20:16:33  ACPI: Reserving HPET table memory at [mem 0x6c62e860-0x6c62e897]
 20:16:33  ACPI: Reserving APIC table memory at [mem 0x6c62e898-0x6c62efb5]
 20:16:33  ACPI: Reserving MIGT table memory at [mem 0x6c62efb8-0x6c62eff7]
 20:16:33  ACPI: Reserving PCAT table memory at [mem 0x6c62eff8-0x6c62f05f]
 20:16:33  ACPI: Reserving PCCT table memory at [mem 0x6c62f060-0x6c62f0cd]
 20:16:33  ACPI: Reserving RASF table memory at [mem 0x6c62f0d0-0x6c62f0ff]
 20:16:33  ACPI: Reserving SVOS table memory at [mem 0x6c62f100-0x6c62f131]
 20:16:33  ACPI: Reserving WDDT table memory at [mem 0x6c62f138-0x6c62f177]
 20:16:33  ACPI: Reserving OEM4 table memory at [mem 0x6c62f178-0x6c657b83]
 20:16:33  ACPI: Reserving OEM1 table memory at [mem 0x6c657b88-0x6c662453]
 20:16:33  ACPI: Reserving OEM2 table memory at [mem 0x6c662458-0x6c66898b]
 20:16:33  ACPI: Reserving SSDT table memory at [mem 0x6c668990-0x6c675847]
 20:16:33  ACPI: Reserving SSDT table memory at [mem 0x6c675848-0x6c675ea2]
 20:16:33  ACPI: Reserving SPCR table memory at [mem 0x6c675ea8-0x6c675ef7]
 20:16:33  ACPI: Reserving TPM2 table memory at [mem 0x6c675ef8-0x6c675f2b]
 20:16:33  ACPI: Reserving SSDT table memory at [mem 0x6c675f30-0x6c677297]
 20:16:33  ACPI: Reserving DMAR table memory at [mem 0x6c677298-0x6c67737f]
 20:16:33  ACPI: Reserving HEST table memory at [mem 0x6c677380-0x6c677427]
 20:16:33  ACPI: Reserving BERT table memory at [mem 0x6c677428-0x6c677457]
 20:16:33  ACPI: Reserving ERST table memory at [mem 0x6c677458-0x6c677687]
 20:16:33  ACPI: Reserving EINJ table memory at [mem 0x6c677688-0x6c6777d7]
 20:16:33  ACPI: Reserving WSMT table memory at [mem 0x6c6777d8-0x6c6777ff]
 20:16:33  No NUMA configuration found
 20:16:33  Faking a node at [mem 0x0000000000000000-0x000000107fffffff]
 20:16:33  NODE_DATA(0) allocated [mem 0x107fffcfc0-0x107fffffff]
 20:16:33  hugetlb_cma: reserve 6144 MiB, up to 6144 MiB per node
 20:16:33  cma: Reserved 6144 MiB in 1 range
 20:16:33  hugetlb_cma: reserved 6144 MiB on node 0
 20:16:33  crashkernel reserved: 0x0000000052000000 - 0x000000005e000000 (192 MB)
 20:16:33  Zone ranges:
 20:16:33    DMA      [mem 0x0000000000001000-0x0000000000ffffff]
 20:16:33    DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
 20:16:33    Normal   [mem 0x0000000100000000-0x000000107fffffff]
 20:16:33    Device   empty
 20:16:33  Movable zone start for each node
 20:16:33  Early memory node ranges
 20:16:33    node   0: [mem 0x0000000000001000-0x000000000009ffff]
 20:16:33    node   0: [mem 0x0000000000100000-0x0000000069ca3fff]
 20:16:33    node   0: [mem 0x000000006ebee000-0x000000006fffffff]
 20:16:33    node   0: [mem 0x0000000100000000-0x000000107fff7fff]
 20:16:33    node   0: [mem 0x000000107fff9000-0x000000107fffffff]
 20:16:33  Initmem setup node 0 [mem 0x0000000000001000-0x000000107fffffff]
 20:16:33  On node 0, zone DMA: 1 pages in unavailable ranges
 20:16:33  On node 0, zone DMA: 96 pages in unavailable ranges
 20:16:33  On node 0, zone DMA32: 20298 pages in unavailable ranges
 20:16:33  On node 0, zone Normal: 1 pages in unavailable ranges
 20:16:33  ACPI: PM-Timer IO Port: 0x508
 20:16:33  ACPI: X2APIC_NMI (uid[0xffffffff] high level lint[0x1])
 20:16:33  ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
 20:16:33  IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
 20:16:33  IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-31
 20:16:33  IOAPIC[2]: apic_id 10, version 32, address 0xfec08000, GSI 32-39
 20:16:33  IOAPIC[3]: apic_id 11, version 32, address 0xfec10000, GSI 40-47
 20:16:33  IOAPIC[4]: apic_id 12, version 32, address 0xfec18000, GSI 48-55
 20:16:33  ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
 20:16:33  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
 20:16:33  ACPI: Using ACPI (MADT) for SMP configuration information
 20:16:33  ACPI: HPET id: 0x8086a701 base: 0xfed00000
 20:16:33  TSC deadline timer available
 20:16:33  CPU topo: Max. logical packages:   1
 20:16:33  CPU topo: Max. logical dies:       1
 20:16:33  CPU topo: Max. dies per package:   1
 20:16:33  CPU topo: Max. threads per core:   2
 20:16:33  CPU topo: Num. cores per package:    18
 20:16:33  CPU topo: Num. threads per package:  36
 20:16:33  CPU topo: Allowing 36 present CPUs plus 0 hotplug CPUs
 20:16:33  [mem 0x80000000-0xfed1ffff] available for PCI devices
 20:16:33  Booting paravirtualized kernel on bare hardware
 20:16:33  clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
 20:16:33  Load bootconfig: 46 bytes 5 nodes
 20:16:33  setup_percpu: NR_CPUS:512 nr_cpumask_bits:36 nr_cpu_ids:36 nr_node_ids:1
 20:16:33  percpu: Embedded 78 pages/cpu s282624 r8192 d28672 u524288
 20:16:33  Unknown kernel command line parameters "biosdevname=0", will be passed to user space.
 20:16:33  printk: log buffer data + meta data: 2097152 + 7340032 = 9437184 bytes
 20:16:33  Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes, linear)
 20:16:33  Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes, linear)
 20:16:33  software IO TLB: area num 64.
 20:16:33  software IO TLB: SWIOTLB bounce buffer size roundup to 16MB
 20:16:33  Fallback order for Node 0: 0 
 20:16:33  Built 1 zonelists, mobility grouping on.  Total pages: 16691284
 20:16:33  Policy zone: Normal
 20:16:33  mem auto-init: stack:off, heap alloc:off, heap free:off
 20:16:33  SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=36, Nodes=1




