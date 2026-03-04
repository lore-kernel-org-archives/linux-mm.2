Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A9BEB7EB3
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 09:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 524246B008A; Wed,  4 Mar 2026 04:04:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505666B0092; Wed,  4 Mar 2026 04:04:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424FE6B0093; Wed,  4 Mar 2026 04:04:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9AB6B008A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:04:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DFF3E8BBC7
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:04:08 +0000 (UTC)
X-FDA: 84507793776.27.EFE9E8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1A44D14000C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:04:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LO5cFKB3;
	spf=pass (imf09.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772615047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOQlj6naO92JugN1Y9eyq9OsCaSmpPv2KoT7HaBPRQc=;
	b=sAltIboOa1F4HvzYgN7+sX8H3URginhkiKAcfuLgnfeXKKJtuiEzoFqWkInTI51QCqiBGc
	+H6vC/f9BKoPIkbWMFIVz58qfm/5O5xmhFizOHufWwE0Z4L8clocgueLDoYgEktTV/Vo5V
	YEcT1xI+PUnSIigxF05Y+KUyhzga3gI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772615047; a=rsa-sha256;
	cv=none;
	b=3szS+U/AMfPf5t+G1KLEHNxttwPoaXMJXeUdUo+KqVpJxp+2UO3Qa5zateHHxuoJtu9KJY
	dMOu9pnX4EzSPX2vSHzr04Q1z5Q8ucAMPp24RuHoRMV1XlyDWTyURd+veU6iBkUIcDzJD5
	h7mAMrL4QmLVR5dEUxi9mBNJiC36EU0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LO5cFKB3;
	spf=pass (imf09.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3387C40B99;
	Wed,  4 Mar 2026 09:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F464C19423;
	Wed,  4 Mar 2026 09:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772615046;
	bh=duYFPXRSVqTWjpnCYbxKCrWGKHrn4IMlEvOkeRB4SBc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LO5cFKB3INrXPIS9/Zzl0WPAjo/Xz417AVxD+S6wAoYl8T2a9o4qmbHKzaF3yafXU
	 qPupfGUV3z8mC/GJE5HSVUjlpZr/zfH/n8eG1iWtPbkj5xC4dE5vQqHN3pRq/NJY5p
	 UNgtygr9jbQ5jthBp+wJPEHAwxOUPwCoo/6O6de4EnKslc+KW8thlzk44/3Q0fr+x0
	 +9ttAdacuqh4wTMayA0UCQME/k/uUScbhIcelDUYRXOWs8gX4QALILX4bsw7L6V6dg
	 tz9Jci+tOojITSRXWYmLBR01xP02JIAi0LHkPMAQtNNFCWjlsFZPmK6FeP0QEpjE8P
	 NgjYWXUy5RhYQ==
Message-ID: <88b77e80-8b6c-44de-b74f-ad589d49b6cd@kernel.org>
Date: Wed, 4 Mar 2026 10:04:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 07/10] powerpc: book3s64: Rename tlbie_va_lpid to
 tlbie_va_pid_lpid
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
 <465a2aac31f00d395be0d551574de37786ace094.1772013273.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <465a2aac31f00d395be0d551574de37786ace094.1772013273.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4yp5okeyfhm5hztnqwejiycy1tgi56uz
X-Rspamd-Queue-Id: 1A44D14000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1772615046-431448
X-HE-Meta: U2FsdGVkX1/5QMSb33Mgvn47TSkRowCI6GFN9OwY8tTtoor+nWr5p0PSCXIpv8vdbkb4ATAc1vhuzbr2l1efI7ZaTqMuuEJ+EFZC4+cX/Ng/OIhiDKJhETiKhlET1bksGart0+yfbS5n+SV3Ixwzw2J6SUK3eC9hxTdqfIDKdOe9MKVKY7V2aTwjNjVykEl4YMloyblz9gtsj2eFx6FVOFlLL/rbyMWIAsCFMrxcVOlBDlxi2sV7xZjEQzE+ARjhz+XQV2Ms9bn1tk7OkcIzQ5AM3b1hXg65jQc0A1tgPemhM97DT1U/hnAwD6ScY2TBz3I+avTHnXtsexJ2CJ1JwWU3IwoY8WlU1QnD/Rbxx4QvKXKhQqZrDeMp/ydgSi9oK1a6qyXlioIAMvZEb2W8deMRNfRDynNMAFEeg9lekEIi3GJvya5/tByiaWkhfqc/SsxeazQT+uxULKib2iwPx8wJYEzqBJURX/FYCnyu8jwW8nOK7aTsa598Hkxw5BXfUpUABEGiUMjgB+AK2lrNYbnGID3yn43nZdt42eL6Q3YkOI0x7Pawu1mrF/by/LN9HBusW8h+Nv7xnXdiTq4jsuvXJuZkygldlJJoTxVYx+eOsHYs126UEbIqss1kcJif4UJFTpNT+EvrXU/FyZ0oqV4urb3q6zSwklv56Yg+4i23eBp3vQkq5CznxEr2Q7EDyT/r7nn8+cLM9MOcxU5+PM688ekP6BKqFKhAY8X1Zc4/W3bembo1zoDHjO0KHzT4dcD2bo6f6Xks2JXcC+25WM4/6kB4/7J4UIr7nmvwJDgVaUbRR8lNR/eriaq4hkMtmJWj+dNyV4UZatAEEMxaGB2Vb9MFVdwiD4dcU7cyQuIAOLr4FahMNJb592uc/7XFk/c7PAPjtEOzkHsl7nQNaJRM1jjlDfAFZcMWVBPNOSmXjdt6iOEEUEt/XJZyfkt7vINMh7i8yRxEArbZvDx
 tSCfz6tY
 WbiXmO5XhI7JLjKmYXKK6UEHitPmurpOAz5lq2deUi+22N0QH7eoFcE7oZzDHa0EkUkWtvj7HLBgTmWZqK5qQ/lQi40S8NGwIO4+dpBozZQCu45RnLWj+gXNxBwHXGjZ4ISyr1EDd2WIoMluxvBsymaUhw3oyZKrG6ujIZTP5fHAwUWvzKMIdju3ibH2sO6z0g5QbT1x2Nr8lfDOld/5BxyR2XMjEHHIjSEi/NO81/tLcMqwroVeViWdqPUXqGo+QOStm36tMs36wq7y39nMufUInKKujZvt/sliUl9PHEEEsMAYELEBMI4SfOdctkLlWmBzcz5Maw6Tf354s1rQ/I58BdKDdikNDQo992EtIZ6EKM0svgptooLlipW4tOJ4fgCWICJzBUxFgeh2NxI09YxYv+vNXOyMrrwaEAx3xv15tRuvAwefhKx5ZRda0RmTC9Fsi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 25/02/2026 à 12:04, Ritesh Harjani (IBM) a écrit :
> It only make sense to rename these functions, so it's better reflect what
> they are supposed to do. For e.g. __tlbie_va_pid_lpid name better reflect
> that it is invalidating tlbie using VA, PID and LPID.
> 
> No functional change in this patch.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/powerpc/mm/book3s64/radix_tlb.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
> index 339bd276840b..1adf20798ca6 100644
> --- a/arch/powerpc/mm/book3s64/radix_tlb.c
> +++ b/arch/powerpc/mm/book3s64/radix_tlb.c
> @@ -1411,7 +1411,7 @@ static __always_inline void __tlbie_pid_lpid(unsigned long pid,
>   	trace_tlbie(0, 0, rb, rs, ric, prs, r);
>   }
>   
> -static __always_inline void __tlbie_va_lpid(unsigned long va, unsigned long pid,
> +static __always_inline void __tlbie_va_pid_lpid(unsigned long va, unsigned long pid,
>   					    unsigned long lpid,
>   					    unsigned long ap, unsigned long ric)
>   {
> @@ -1443,7 +1443,7 @@ static inline void fixup_tlbie_pid_lpid(unsigned long pid, unsigned long lpid)
>   
>   	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
>   		asm volatile("ptesync" : : : "memory");
> -		__tlbie_va_lpid(va, pid, lpid, mmu_get_ap(MMU_PAGE_64K),
> +		__tlbie_va_pid_lpid(va, pid, lpid, mmu_get_ap(MMU_PAGE_64K),
>   				RIC_FLUSH_TLB);
>   	}
>   }
> @@ -1474,7 +1474,7 @@ static inline void _tlbie_pid_lpid(unsigned long pid, unsigned long lpid,
>   	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
>   }
>   
> -static inline void fixup_tlbie_va_range_lpid(unsigned long va,
> +static inline void fixup_tlbie_va_range_pid_lpid(unsigned long va,
>   					     unsigned long pid,
>   					     unsigned long lpid,
>   					     unsigned long ap)
> @@ -1486,11 +1486,11 @@ static inline void fixup_tlbie_va_range_lpid(unsigned long va,
>   
>   	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
>   		asm volatile("ptesync" : : : "memory");
> -		__tlbie_va_lpid(va, pid, lpid, ap, RIC_FLUSH_TLB);
> +		__tlbie_va_pid_lpid(va, pid, lpid, ap, RIC_FLUSH_TLB);
>   	}
>   }
>   
> -static inline void __tlbie_va_range_lpid(unsigned long start, unsigned long end,
> +static inline void __tlbie_va_range_pid_lpid(unsigned long start, unsigned long end,
>   					 unsigned long pid, unsigned long lpid,
>   					 unsigned long page_size,
>   					 unsigned long psize)
> @@ -1499,12 +1499,12 @@ static inline void __tlbie_va_range_lpid(unsigned long start, unsigned long end,
>   	unsigned long ap = mmu_get_ap(psize);
>   
>   	for (addr = start; addr < end; addr += page_size)
> -		__tlbie_va_lpid(addr, pid, lpid, ap, RIC_FLUSH_TLB);
> +		__tlbie_va_pid_lpid(addr, pid, lpid, ap, RIC_FLUSH_TLB);
>   
> -	fixup_tlbie_va_range_lpid(addr - page_size, pid, lpid, ap);
> +	fixup_tlbie_va_range_pid_lpid(addr - page_size, pid, lpid, ap);
>   }
>   
> -static inline void _tlbie_va_range_lpid(unsigned long start, unsigned long end,
> +static inline void _tlbie_va_range_pid_lpid(unsigned long start, unsigned long end,
>   					unsigned long pid, unsigned long lpid,
>   					unsigned long page_size,
>   					unsigned long psize, bool also_pwc)
> @@ -1512,7 +1512,7 @@ static inline void _tlbie_va_range_lpid(unsigned long start, unsigned long end,
>   	asm volatile("ptesync" : : : "memory");
>   	if (also_pwc)
>   		__tlbie_pid_lpid(pid, lpid, RIC_FLUSH_PWC);
> -	__tlbie_va_range_lpid(start, end, pid, lpid, page_size, psize);
> +	__tlbie_va_range_pid_lpid(start, end, pid, lpid, page_size, psize);
>   	asm volatile("eieio; tlbsync; ptesync" : : : "memory");
>   }
>   
> @@ -1563,7 +1563,7 @@ void do_h_rpt_invalidate_prt(unsigned long pid, unsigned long lpid,
>   			_tlbie_pid_lpid(pid, lpid, RIC_FLUSH_TLB);
>   			return;
>   		}
> -		_tlbie_va_range_lpid(start, end, pid, lpid,
> +		_tlbie_va_range_pid_lpid(start, end, pid, lpid,
>   				     (1UL << def->shift), psize, false);
>   	}
>   }


