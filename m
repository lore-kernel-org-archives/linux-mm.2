Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54265CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E446B00A3; Mon, 24 Nov 2025 14:25:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E7D6B00B4; Mon, 24 Nov 2025 14:25:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F6576B00B8; Mon, 24 Nov 2025 14:25:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7778A6B00A3
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:25:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 498C44F6F1
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:25:06 +0000 (UTC)
X-FDA: 84146478612.11.AB6CA23
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 47D2EA000A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:25:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ih46kXcT;
	spf=pass (imf15.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764012304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jk37GvM71JhaWd5rL6T9q167IOkQkimPTz38uVA1jc=;
	b=WM84vSEVtCZgjlo/X/oa5Nl/6ww13d7a0Fdq0OSx3eMYgIc2Gw35OBj1U/3ljHI2Jd71Ta
	QcvOubAlvu5ERFFglE/t85MRjT2n7M1VuhVbKohfncb068CfbXDu/TcnE6eUVWXT6Fe4ua
	jgUVR8Y0nNmaN4Xj2vqhXXYFvWgvc1A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764012304; a=rsa-sha256;
	cv=none;
	b=70Kkx4f4YS8GThjZBTQjceCv2DdeCDqKLI6zs8wB9QsJDGdV66A2qBFh2KI+8XgNPZknbf
	Sw5pVMM6G1+eQKBjbs0C3xtHvkUonQ9x/VgaGDtrHQuDh4q6nkwcdBEBom1MmOE/1qivXP
	i4DnOf5/xgMY0raTVrnWKSHNUgFBJuA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ih46kXcT;
	spf=pass (imf15.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4775895d69cso19651195e9.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764012302; x=1764617102; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9jk37GvM71JhaWd5rL6T9q167IOkQkimPTz38uVA1jc=;
        b=Ih46kXcTmYHKG4IX6bxfan7CD+GBgrVSt9WBFQx8i9RJ9E/KNi6MwVt5jSp4VE5Awa
         GKddNhvtDe2nDSfhVnjdtz4nfHZGmuFzQikud2AD7BFbLkzQ2+IkzUJyitMl5ERCEGaY
         I6SjU+pwTR6m5MUIUXHP6dfu5NXNmsvxfgXwt6mNGmomvxhaW5vZAmeI3nKB/16kM4/r
         sQs8wriZZDqCVuKxQViqs4pYZdaZGECKuRi+iZqONj8XxnUpHAwbqPeoHP+RST/XU7Q+
         Mdje32739Hb1XEExPEp8gw0vDqfL3u3LPAdv+eEJAc2CxO5SGXOL0BuauuHgDmTh8dOL
         UKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764012302; x=1764617102;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9jk37GvM71JhaWd5rL6T9q167IOkQkimPTz38uVA1jc=;
        b=TZGMmc9FsF+oFPL2GksFQLbsdhxk6rX9Afk4ZOjUIs6gqWfOLOOZhSsZlH9Ktc01H4
         MhoDx7nBXQ8g6W39isk/Tx8TXmUgpxAex03RTbSRuRMYmC2QGaaR6lFt2ngxqUFhovqe
         ExBvH+5wnz/zGstX8a3ATKinKVGh3yWb/jygZuUV4hW+eOfY2iNq1NU/ycdb+ZznK71D
         eHPzL1Yis5gpi7GRFfeRkWF/6/SJkRIfLzHn6+yos8V8OeHUqzfw6uGtRRUdamzZHEi7
         WG6dvhefjnz3YjDRs4e5wK2iFXlLeUe4Ryv8ZTv71VtXHHp0FTwNepXWaTOC9Zrwy/We
         Lbog==
X-Forwarded-Encrypted: i=1; AJvYcCVMtMUNj295mDTzZF82ua4eu+7IoaP66EKT8ahEfTBkSGeJzaINWtjtaYr4mblFOrNyphbq4nGpeQ==@kvack.org
X-Gm-Message-State: AOJu0YxL2WsrLpUy0gX3TfU9wX+mptpwWfss+tlmXQ8n8VJIDEXOQvKn
	eB2aATLbfWvQDPSHXVIjIYCaa5ScfU2IijxqGFnegzONsLw8DIao6klY
X-Gm-Gg: ASbGncs/TspiClaCNsExRRTytota+Ypm2+FcpYMuF0x5SzMojM5rAEsTijJfIziKZAG
	fQO0+5zIy3ySnFuLJcDL3Nx1aSktK0oqfI7a4zYxa7Mcr9ZkYkduAzC3FLeMy4fpBQ9TNo1evwe
	Nmgv1WFWoZvMKbXe1q4nJ2lkQb8FfkYOUTDtX7w9TCfdUkPvKFq80Wp0FePg1aP4EqfV3shXgcQ
	VEv4EpFMQgcz5mPe9IZmQUlEw7vMIjHxu50K1IaXz0FTCz0ol+EF4PbJfChsZ+2dUbBfFjyGBci
	LSV0HAZ5QPLtWicu37NZN1qo1PrWKLw0ltZnX6apQwRNENJEehYqBRrFhJxxx6YAKIRMFEVDRuM
	w9TsExVZ2A3GToXujfGJ/fi43SxiwUbarvSyP7YiGPhEcNqeODGaVq4NlNOx1d//SA7Ghfo5bQU
	WS/mPdmPLNRP2TwPnsqL1ZMmX5HZg2vWDSmwJ/lOYu2Qga+yjwVMRXQhUBGpBWTTQ=
X-Google-Smtp-Source: AGHT+IFeHLsoYr2AmZntomxO2DLGMgEciJ8EAmlBYd3tNaV7xwLFtpLjqhrJ3Jk53gAvqzID4Fk9Ww==
X-Received: by 2002:a05:600c:3115:b0:477:b48d:ba7a with SMTP id 5b1f17b1804b1-477c01fd202mr126949555e9.32.1764012302165;
        Mon, 24 Nov 2025 11:25:02 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1126:4:ce0:a4eb:eabc:d420? ([2620:10d:c092:500::5:5b96])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf3ba1b4sm214863705e9.15.2025.11.24.11.25.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 11:25:01 -0800 (PST)
Message-ID: <a0f875f1-45ad-4dfc-b5c8-ecb51b242523@gmail.com>
Date: Mon, 24 Nov 2025 19:24:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 12/17] x86/e820: temporarily enable KHO scratch for
 memory below 1M
To: Changyuan Lyu <changyuanl@google.com>, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>
Cc: anthony.yznaga@oracle.com, arnd@arndb.de, ashish.kalra@amd.com,
 benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com,
 corbet@lwn.net, dave.hansen@linux.intel.com, devicetree@vger.kernel.org,
 dwmw2@infradead.org, ebiederm@xmission.com, graf@amazon.com, hpa@zytor.com,
 jgowans@amazon.com, kexec@lists.infradead.org, krzk@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, luto@kernel.org, mark.rutland@arm.com, mingo@redhat.com,
 pasha.tatashin@soleen.com, pbonzini@redhat.com, peterz@infradead.org,
 ptyadav@amazon.de, robh@kernel.org, rostedt@goodmis.org, rppt@kernel.org,
 saravanak@google.com, skinsburskii@linux.microsoft.com, tglx@linutronix.de,
 thomas.lendacky@amd.com, will@kernel.org, x86@kernel.org,
 Breno Leitao <leitao@debian.org>, thevlad@meta.com
References: <20250509074635.3187114-1-changyuanl@google.com>
 <20250509074635.3187114-13-changyuanl@google.com>
Content-Language: en-GB
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250509074635.3187114-13-changyuanl@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mia5ofw1yyaubdph49mtq787h4jwzun5
X-Rspam-User: 
X-Rspamd-Queue-Id: 47D2EA000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1764012304-710826
X-HE-Meta: U2FsdGVkX190vbGitAW5wMxEcHCjTsGk0/rhCTbJerbS4WA0lt5JdhnqRTZlnLPT9/PjBGtlmMr2SeAtQgjr5S1w/AzUfoDggeFdoHxcZp2PuxD7H8tamIQgGkYhVwC0Sioo5Yn2N6gKMhDY0hDx18hEvYJ1VAsIBJSRqRDZxBhJ6MQAO6I1LGP/jloayEmH2Uq2zz0kY0OjoWuGxxKYgPsFjtj78P2et92RCkrg3T5//GKKi3q+pcOF0/JCpppg6WxxDr+j6h+4863BmO3hbX5vkYnXG7/0dMafnzYDUEu+5HF2C8uiqanm0DFHlRUMhESE8Ui67WBQzR69ziSfkX33gcOFNEjtXHM1PiXaTq8iLLwVr+5BHEHU758bb3n8UeTegGxaybaJnSiA2M+bTjh7j+37peYWH9/vbC+5nvXoCRsIBDC8pcOdm+Au1Nhqr/0KeXtpy9tbGo/siZVqhhQqxp8DTs8HllxPBT5/G9JpVS/1NQpnS5AlcvJSNzObd8NOmwmtG7ODPC0RkFcJ6zwK8cOFU3cPM6x7BDnZ2MMb6IaeT5CUE9IhVjv2CQU+Bl+Y4ldsW3cIjKcdXmiZuTOQqAPSJMclzkzTsenXLpgKITLP+yYTSswIVuMSPydZRjZbFYfek7WwW8NkUpz+xSrPKimrFZEXsgNStg2rihmz8x46i9EvY5XoQTbw1/MuRD/mZE/PVO3eJHAGwZuD4BeQ1YGvKp357tb0fJokuHchk6Kg9MPVhnwZV9kOm/XW7m5jW5XdEDKJlzo1wbgqagABQtfiS+y127LyHyC9sF/HbxJhRsbX+r57Rv9Ifdm2OeMH1mqygDyWYPYCYZqliQI8E4WAv6ySH5gx9guWwYuFp1HnFsa+Mn4i8+lxLBRJ/Xgb/UULb7SwNxNlEu/rcexakxDSTfYgnLlVI8acyAutx8HeFyeScMzdaXCM6M4wAQ8KES47RHxqZ1BX8oj
 aFXhoPuh
 nxM1xNPh0d0vHOY+q02EOTs5tE7dNZ70MMT9hHng5mH9UgY9RgHRsHPpF1MKu68rTkLAI1wEgGMT0g68l6qxdBUT31CepxNzSj/wW6HvnUFCGS5GmnCCw7vRSk/ZBqkKGy6bAzPEKDxYpkIwXJUUmWGHI5jluF7YBnOTpjEawA3faE+hhmQum3VMiIQB50S6oI6x+jYCy+pAHO8SMpo+ntQqUCaeNNnutxRyjaRIQ4qODrUkgeGWkL0IwRPhOA+nJuMjPWufex0eRfSoWycjtcA8yIvYFXARDnTS41jHXGInjrtWbn6AyPRT/7lMnrxYVeqoUYLfTQe4ycRO3hsFOhGNX46H+JIH9ICFncfp+e+rjSM+CEa2eIjYiVEfxDydgYDsRfOsbkyhnha7MkObbZkI60Ue64Wqbu/H2QC9UhdXvk1oO9vhM/RaHX+fBRaXzeWT4xjfeK7bSlRMhucqy4gS46VL5ebgSkbO+Gtki/axC8aNxCklfk5T+Y64R1EwCBVCPBiCZKGjYFPyYaedEhfXzTr7bKE7FqUxfVRlIcRB1r71/PpgcWZov1q5J2sRHoSMpa8QC6Th4atxoZ9tQS08rivp7z72LwysPkAXvAZv0cDbF06+GkfFJDHSWAt9C1+Yj2B4YiiqVVlvE04LndbSvbOkCi5+KxDnfNZheQtegCL/FuLrcW3RdvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/05/2025 08:46, Changyuan Lyu wrote:
> From: Alexander Graf <graf@amazon.com>
> 
> KHO kernels are special and use only scratch memory for memblock
> allocations, but memory below 1M is ignored by kernel after early boot
> and cannot be naturally marked as scratch.
> 
> To allow allocation of the real-mode trampoline and a few (if any) other
> very early allocations from below 1M forcibly mark the memory below 1M
> as scratch.
> 
> After real mode trampoline is allocated, clear that scratch marking.
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Co-developed-by: Changyuan Lyu <changyuanl@google.com>
> Signed-off-by: Changyuan Lyu <changyuanl@google.com>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> ---
>  arch/x86/kernel/e820.c   | 18 ++++++++++++++++++
>  arch/x86/realmode/init.c |  2 ++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 9920122018a0b..c3acbd26408ba 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -1299,6 +1299,24 @@ void __init e820__memblock_setup(void)
>  		memblock_add(entry->addr, entry->size);
>  	}
>  
> +	/*
> +	 * At this point memblock is only allowed to allocate from memory
> +	 * below 1M (aka ISA_END_ADDRESS) up until direct map is completely set
> +	 * up in init_mem_mapping().
> +	 *
> +	 * KHO kernels are special and use only scratch memory for memblock
> +	 * allocations, but memory below 1M is ignored by kernel after early
> +	 * boot and cannot be naturally marked as scratch.
> +	 *
> +	 * To allow allocation of the real-mode trampoline and a few (if any)
> +	 * other very early allocations from below 1M forcibly mark the memory
> +	 * below 1M as scratch.
> +	 *
> +	 * After real mode trampoline is allocated, we clear that scratch
> +	 * marking.
> +	 */
> +	memblock_mark_kho_scratch(0, SZ_1M);
> +
>  	/*
>  	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
>  	 * to even less without it.
> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
> index f9bc444a3064d..9b9f4534086d2 100644
> --- a/arch/x86/realmode/init.c
> +++ b/arch/x86/realmode/init.c
> @@ -65,6 +65,8 @@ void __init reserve_real_mode(void)
>  	 * setup_arch().
>  	 */
>  	memblock_reserve(0, SZ_1M);
> +
> +	memblock_clear_kho_scratch(0, SZ_1M);
>  }
>  
>  static void __init sme_sev_setup_real_mode(struct trampoline_header *th)

Hello!

I am working with Breno who reported that we are seeing the below warning at boot
when rolling out 6.16 in Meta fleet. It is difficult to reproduce on a single host
manually but we are seeing this several times a day inside the fleet.

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


Rolling out with memblock=debug is not really an option in a large scale fleet due to the
time added to boot. But I did try on one of the hosts (without reproducing the issue) and I see:

[    0.000616]  memory.cnt  = 0x6
[    0.000617]  memory[0x0]	[0x0000000000001000-0x000000000009bfff], 0x000000000009b000 bytes flags: 0x40
[    0.000620]  memory[0x1]	[0x000000000009f000-0x000000000009ffff], 0x0000000000001000 bytes flags: 0x40
[    0.000621]  memory[0x2]	[0x0000000000100000-0x000000005ed09fff], 0x000000005ec0a000 bytes flags: 0x0
...

The 0x40 (MEMBLOCK_KHO_SCRATCH) is coming from memblock_mark_kho_scratch in e820__memblock_setup. I believe this
should be under ifdef like the diff at the end? (Happy to send this as a patch for review if it makes sense).
We have KEXEC_HANDOVER disabled in our defconfig, therefore MEMBLOCK_KHO_SCRATCH shouldnt be selected and
we shouldnt have any MEMBLOCK_KHO_SCRATCH type regions in our memblock reservations.

The other thing I did was insert a while(1) just before the warning and inspected the registers in qemu.
R14 held the base register, and R15 held the size at that point.
In the warning R14 is 0x100000 meaning that someone is reserving a region with a different flag to MEMBLOCK_NONE
at the boundary of MEMBLOCK_KHO_SCRATCH.

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index c3acbd26408ba..26e4062a0bd09 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1299,6 +1299,7 @@ void __init e820__memblock_setup(void)
                memblock_add(entry->addr, entry->size);
        }
 
+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
        /*
         * At this point memblock is only allowed to allocate from memory
         * below 1M (aka ISA_END_ADDRESS) up until direct map is completely set
@@ -1316,7 +1317,7 @@ void __init e820__memblock_setup(void)
         * marking.
         */
        memblock_mark_kho_scratch(0, SZ_1M);
-
+#endif
        /*
         * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
         * to even less without it.
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 88be32026768c..1cd80293a3e23 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -66,8 +66,9 @@ void __init reserve_real_mode(void)
         * setup_arch().
         */
        memblock_reserve(0, SZ_1M);
-
+#ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
        memblock_clear_kho_scratch(0, SZ_1M);
+#endif
 }
 
 static void __init sme_sev_setup_real_mode(struct trampoline_header *th)

