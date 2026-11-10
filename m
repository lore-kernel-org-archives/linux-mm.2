Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70452606DF5E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 07:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Bt11K0DF
Received: by kanga.kvack.org (Postfix)
	id 883E36B05C1; Tue, 10 Nov 2026 02:51:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834CD6B05C2; Tue, 10 Nov 2026 02:51:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A476B05C3; Tue, 10 Nov 2026 02:51:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2C96B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:51:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4D93A085C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:51:07 +0000 (UTC)
X-FDA: 85418438574.25.A80DF1C
Received: from mta1.migadu.com (out-229.mta1.migadu.com [95.215.58.229])
	by imf17.hostedemail.com (Postfix) with ESMTP id AE16440006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:51:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bt11K0DF;
	spf=pass (imf17.hostedemail.com: domain of atish.patra@linux.dev designates 95.215.58.229 as permitted sender) smtp.mailfrom=atish.patra@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794297066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oCAnq9Ydyn9pzFtWZAL2uoxXAv5DcpFwU0HVA55B7zc=;
	b=Et4zsVV2SE4jITGNzYRsxI9K52mARArlE7bguO7xg7VmZiaXjlxmoh6PIw9EGTX5eczEa+
	uzLBC5t0FEnXawJAYAez1b3BtVGwubvDhY6Q4Vxpx4gHY3p1IY7JUX9YMU7Sp6NhadxkGg
	XrZMhi3TAb0mnE8KvaKyXgtDwUh7TJk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bt11K0DF;
	spf=pass (imf17.hostedemail.com: domain of atish.patra@linux.dev designates 95.215.58.229 as permitted sender) smtp.mailfrom=atish.patra@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794297066;
	b=QPw1wcPYTdMkRXzG6HN0IUE4ezXNKWVMtL7x4DDyDkId+KxpAMsuc4UwwJ9wjtVRvxArTv
	MBsIC7wfKgVYy/a0D12+iCjO4jJayCIG2Bv6ZMAHVlc6+cgmg0PpDZX4Iw+yJil8u8joTV
	q5+1SEukBa26JG2LtQ7TVjItuw1x7E8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VEYHcJJXdTr+sSu/VkSL5rhEFuBwOC/PnaSfhFDxgH4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794297064; v=1; x=1794901864;
 b=Bt11K0DFsGKbjUzn/HQN5vSqRNQbCITQzMqgzZSVPTK8Ks7/8ZCi1hZYj1vCJlS1KNqzmK8h
 OnM+Gmbeo3EQyaa0Oy2n0daXlzBnGKD1O6EN2UuNgZywnsbzN9SrVCZBp0/kkowynQkgbfCxr9b
 bZoVt616m4e1laAF5GMWGFnQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d983afd97fe96bab;
	Tue, 10 Nov 2026 07:51:04 +0000
X-Mizu-Trace-ID: d983afd97fe96bab
X-Migadu-Flow: FLOW_OUT
Message-ID: <9c767bbc-3189-429b-b008-021306426b7e@linux.dev>
Date: Mon, 9 Nov 2026 23:50:58 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/Kconfig: enable ROX cache in execmem when
 STRICT_KERNEL_RWX is set
To: Mike Rapoport <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Dan Moulding <dan@danm.net>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
References: <20250716075410.82578-1-rppt@kernel.org>
Content-Language: en-US
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250716075410.82578-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oes83eco4qohudwo5xmkfsiz197dhoj9
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: AE16440006
X-HE-Tag: 1794297065-63565
X-HE-Meta: U2FsdGVkX19QJnRir80CoGJO0V4VqJHmlc1pbpYzVk6Qc1LQURkyMXGYezWuZgg/6gVLLheYArZcde+LUN+48EIsnjNBS4uTOImPxR6JzHJZKmElyZMrplyeupnsZcaiGobiCFcQamDijsnD07ELxrrbAzi+maprC/OTQPC97UhlbLiLNW1eYue01HcDmG3N+fz7hxX6L1ElaYAjnJlq8SkThTaLnx7fJ04UFs8EDy7m/2C57XevhgrzBeBFwG25AwfKLCr0CQAyKMilBwmnuc2D8APJaD6emrL9pMA0GGMK63qj4YZsZfdJX+Gwc+5rWb186DB6rImeSlw2AlZF63cyVfenwMG3IiTLyMyJvs26k5de00aUnUJiEjxUPwqsh7ZlIue4B3JLVRlFrp2aix21iM/APTBqe67MVsRCA7Vy6Iy/IDRgmEtEKGCJ4Y7CaDm78ER7UCYwfDmNGXOtFifdOxboaNma1wwHAjaKl9ikktIsNu8PZc29Or2sQ0jugcWuekb9OEt1rAfQWs2d1eVNI/D91t7T6xEVl/BupgcYcyk+jKIGR0ZTcf6D/WPubwK0/AR/UKPmb2gLkLA9A1kHvT9Z8knpl9lD8Kw2GIulTQC4ozWXYm9bJ2Fs8th00Dl8ANlOwd7+c1+zLr8OWJPAIpwAl+an66naGgu/dRGygAP2hVIH2pulB5m6cbiyyp9pVr+wooZv2M1yMXQQV4u6h8nUD3neMtxhyLJJRgPTEQLraLdroo4IJCfrIgHLPp4YPE3/XKJ14A6DK8bZqGVQTokA6d3a90U5ota1uDI817NFef5sG6KEdug6CuuISU8nkNmVsMfQAL3QRh2Ik8CZKTEF7ONYt1ZO0GFfn4KfkRBffLT/GxOvt4fIEe6TmqerXRIhq62FMd1qFw5kLzlSsmgJTGzX88FEKik/6xISWaXURmmaf0n2bWaAqRRVz52c8c/zPGtdBQ2CzQr
 T1LM/DKO
 Ifmz9RS5LX4TqlNQTYA05ETPfoSL4tbZXvc1xe6pAa8xZbT+kkXoXfbd37tSUZTUegdKHYmDiDULxv30ITXGJg6MJi06wk5LodPwVrGec3EZUtmC04RHbDvBXin1B2yQyserM8X6lU1hi/dsVbKnKGHGBpbh52xjQJqtBjPwI4YvAKyYtT1PYE+DUICgWh/THSy8qag2krmoqYpMY/3kAeJoZEm14GzLO31hX4HM3fLM+UwwvYC35SMtMFy/OVmQK3Xt8JRyCvl8NPhw2Z2O8IiZIzDxpG79i0IARjBRjXUQJlP/mdkY7e5GcQ4fnXN5N9SPvqG47ffalxl0jEz+OMzTGC+fszSWAVhIkDveJWkpUan6v46F3RwL+bTxpiXFJJDaFBkhA2AlBNtEXtnR72R/URL4O3bgSsDD/BfEH0CdrCSIV2o/O8j4GjAtqXFd69em9iNf80OWowlo0GG5rx8pPlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 7/16/25 12:54 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Dan Moulding reported that kernel configured without modules produces
> "Found insecure W+X mapping at address 0xffffffffc0247000" warining:
>
> [    6.022847] ------------[ cut here ]------------
> [    6.023020] x86/mm: Found insecure W+X mapping at address 0xffffffffc0247000
> [    6.023200] WARNING: CPU: 5 PID: 1 at arch/x86/mm/dump_pagetables.c:246 note_page+0x6ec/0x790
> [    6.023381] CPU: 5 UID: 0 PID: 1 Comm: swapper/0 Tainted: G                T   6.16.0-rc6 #1 PREEMPT
> [    6.023558] Tainted: [T]=RANDSTRUCT
> ...
> [    6.031153] x86/mm: Checked W+X mappings: FAILED, 10 W+X pages found.
>
> The 10 W+X pages are the pages allocated for ITS thunks. With
> CONFIG_MODULES disabled, CONFIG_STRICT_MODULE_RWX does not exist and ROX
> cache in execmem is not enabled so execmem_restore_rox() becomes an empty
> stub.
>
> Enabling ROX cache when CONFIG_STRICT_KERNEL_RWX is set solves the issue and
> makes ITS thunks memory properly protected.
>
> It also ensures that memory containing ITS thunks is mapped with 2M pages
> for kernels compiled without modules.
>
> Reported-by: Dan Moulding <dan@danm.net>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   arch/x86/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 8bed9030ad47..d6d8050683ae 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -89,7 +89,7 @@ config X86
>   	select ARCH_HAS_DMA_OPS			if GART_IOMMU || XEN
>   	select ARCH_HAS_EARLY_DEBUG		if KGDB
>   	select ARCH_HAS_ELF_RANDOMIZE
> -	select ARCH_HAS_EXECMEM_ROX		if X86_64 && STRICT_MODULE_RWX
> +	select ARCH_HAS_EXECMEM_ROX		if X86_64 && (STRICT_KERNEL_RWX || STRICT_MODULE_RWX)
>   	select ARCH_HAS_FAST_MULTIPLIER
>   	select ARCH_HAS_FORTIFY_SOURCE
>   	select ARCH_HAS_GCOV_PROFILE_ALL
>
> base-commit: 347e9f5043c89695b01e66b3ed111755afcf1911

We recently hit this issue after changing CONFIG_MODULES from y to n in 
our guest kernels.
Did this patch slip through the cracks last year ?

Could we get it merged?

I have verified the fix on 7.4-rc1 in a KVM guest running on an Intel 
Cooper Lake host.

Tested-by: Atish Patra <atishp@meta.com>


