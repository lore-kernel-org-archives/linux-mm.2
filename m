Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4F38D31A16
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D4186B0095; Wed, 14 Jan 2026 02:20:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8158C6B0093; Wed, 14 Jan 2026 02:20:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2BE6B0095; Wed, 14 Jan 2026 02:20:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 438CC6B0092
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:20:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E20191B76B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:20:14 +0000 (UTC)
X-FDA: 84329720748.19.04529F0
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf29.hostedemail.com (Postfix) with ESMTP id D0174120002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:20:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=W0aE3JG9;
	dmarc=pass (policy=none) header.from=gaisler.com;
	spf=pass (imf29.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768375213; a=rsa-sha256;
	cv=none;
	b=y89j3bUKCcM6aeu6YEnonOcDbfjkR9lTyfPmEQ9YaPzJHpuV2oE8t6toa1CdMDh+mrXxkv
	L87fmUZv1/5POogoe6WC4wSC212fXWOkQELyst3Ise/iVF/TJXUBv2NCmlop/s1LVHOSNz
	coaWXLzG5X3ZMj40h1j37OX8Q7KX4d4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=W0aE3JG9;
	dmarc=pass (policy=none) header.from=gaisler.com;
	spf=pass (imf29.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768375213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+bsSYT5Z1t0Ue69EheEHF7hxKttSFoeDbi3ynLX/3AM=;
	b=3wznxFDpaQptVCKMWjivZWy830DsgLjMA4yIowxmdZUoSO3455ZOt31xkpmil/hMlXZswz
	RGFpy8u1rl9A5d6u3V4+vvkeqa9ZxKN7d7s8Ec8qWm+rPJY5koI/tSi6NVvUIm5sWgiugz
	kr3bzMCJrt3vZ9rQQuTo4ULLfDV9ZPg=
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4drcvb0mT6z1DR2b;
	Wed, 14 Jan 2026 08:20:11 +0100 (CET)
Received: from [192.168.0.25] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4drcvY6Y97z1DDXQ;
	Wed, 14 Jan 2026 08:20:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1768375210;
	bh=+bsSYT5Z1t0Ue69EheEHF7hxKttSFoeDbi3ynLX/3AM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W0aE3JG9goSHRurW/f80QzESeYLCdz+1cCdlJriVIGX/Ex1LcwRgyEotsO+y02khS
	 FhemM5xiIXD5RYq2dB6AZqI2t8TT/4xXbpur4a/f7pRBb3H2S+LkwN0GSy2rANeE1D
	 Pgsg4O//8AASht2KWtGRQK2AaPGI5F2sOEAbuLOqCRbtqk7ar1sH1X9impRapmfR68
	 JsDB2vJ2shh93AI3xLEc371Bwxp3owy1ZLilXgIqaDVXYrndrwpqo9JHNNqgET7dzy
	 tcIDzuCYYnQoxRAZrybVgK7ezKJw0EEplTcQoXefOAkjkbsbESP4Cja7daHOaHwUWK
	 nlNb1c20WwN1w==
Message-ID: <6c0a9851-9ec9-4a49-9d77-171f36a78448@gaisler.com>
Date: Wed, 14 Jan 2026 08:20:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/14] sparc/mm: implement arch_flush_lazy_mmu_mode()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
 <20251215150323.2218608-5-kevin.brodsky@arm.com>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <20251215150323.2218608-5-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D0174120002
X-Rspamd-Server: rspam06
X-Stat-Signature: 3zjsf8ygxhgmoqrcrjco63xabdjcan3y
X-Rspam-User: 
X-HE-Tag: 1768375212-654701
X-HE-Meta: U2FsdGVkX1+ewWMBKQagSpheIclSzQLvAUn0lp9n1g+tojnuGeipnK4+3dIIjvFQ1i/AfhbA9slAju0smWNt1XbBK08P0KkLBFPdiIZw2QGjTYt0JVJk3Bp17DsKJkZhuiDClNCU4MwCSBAP71OzVpwRbgmUD/pHejdssgsUZ2gjfjDZTx+VuhYamu6yphsGAoE2c3FQSeriAhsoB4DHbHforCayaC/eSAvRkrCsk383oT+QDagL+5m0D6ujjQOOsBDx+Or02L2fs/DnX9I1SPFMWnanRuVRI7Q5QRAw++qaoD3H/KdTKRrm20Ua/tEJLbPgJz3LGNLlfR6roxJXm0OpAu9MEX2spp2mB5xOT7oGNIKNuzoc0DTMJOvRFYlNxuscOYhTNEfKdN1gWbo2xTR86tZwtKd9mKSP/3r7irDE2r2pjK/JHzP1Nbak7Y7aEH6vIILqMexkNIvcWR718cFdq2e/Yap33Bc0glODNIyq7mOpy3Bxymyn4L0POnSCLLBp4cBwDK9QBcEFg1L56c3GVZgxvJmaUkzwUy105AzENiFi2MoS9kpdgFfQlsFH9FxIQPGOHVgoxMFjQ7ZTfRbdyqYMbiQoWsgnDy1GoDZ2Kl8T+9N1Zpg+zrYZQfDjRs6+zmrz3uj+5OCt357Oa1KsrMJlHU7Fa5xMVEg8LZy1CuOogMIs4xdK8c5pP5+uS2Lb25rn136Iw9coP+S3x1Y1sr1+/NEoXLkgGCmL4NlWe4D34R2eCSGOZ3UxW5eOVx69JiB24U8eJ/CFzFcJraPY9qgaSx5PQQawCo2y5Zwq7z0AqP1UXV0Nbnh2YGharqTJA80dUQgfACn3ploI1gnhETjbgWWP0mgrgYKQ355l5jFCWlAeBGx0fkr2uzFB77ooTVSPvKF4oVpVAqJQgm/F1X47jVDc2/4DYh0rQB086KRm+YVjom4D84+oGPgs8y6c/H1mK+mM+ibiVUb
 JI3XhVkr
 SbS3kt7QpQqFUfwnvUrJTARseI5WDl7f5WoWQnd0RMHUrmCqZ7PQx3dOHQKR6xWbCOnMt4IJ0ahJsI+Fkoosc5a3L4P/eqEAy47sqeSX34sW6B/F7nf4KCxRScR3RAKjouistmhXY6xaGzIue0vXN6JEtwrRYTbTXgatsGrcnlRj6wZY+u67JdFXKQ+OB9c+//yWH9veSzjfAxqDDeyvGaN3V1QDx76zeOmlK3/TsYmkXX4ZNZXTdFCAyxszp32HTTTn9RKZcfbqlgNYwgnRxy3avx4FtzXN1fHIOBEUfac+xVfa1AUPZ6GAlwypy21violQHV36rngI0c/VVH4xZJ8Hmao6CpeCYlsDb//pvo0+xYMf2Lh0aM7F1uUnYhW9n+prL1Q9OIeCvz7vAABDP8rXVNM8gJfJQB/TUIXdSvPOIG4mqpQLo+LCNO+kG0kn8Z38+033LbH6k9nm/UYIJrqDhuT4U2DHbyBH9mVpvJOh8PjKT8m6bZkUe/t9dudt0maBK8KCxbU6vErsRIxVT8XMBIb14+YBD7HEPKJk8B3XiT6+CdHDfJNhXgpM/dAIVNgdM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-15 16:03, Kevin Brodsky wrote:
> Upcoming changes to the lazy_mmu API will cause
> arch_flush_lazy_mmu_mode() to be called when leaving a nested
> lazy_mmu section.
> 
> Move the relevant logic from arch_leave_lazy_mmu_mode() to
> arch_flush_lazy_mmu_mode() and have the former call the latter.
> 
> Note: the additional this_cpu_ptr() call on the
> arch_leave_lazy_mmu_mode() path will be removed in a subsequent
> patch.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/sparc/include/asm/tlbflush_64.h | 2 +-
>  arch/sparc/mm/tlb.c                  | 9 ++++++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
> index 8b8cdaa69272..925bb5d7a4e1 100644
> --- a/arch/sparc/include/asm/tlbflush_64.h
> +++ b/arch/sparc/include/asm/tlbflush_64.h
> @@ -43,8 +43,8 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end);
>  
>  void flush_tlb_pending(void);
>  void arch_enter_lazy_mmu_mode(void);
> +void arch_flush_lazy_mmu_mode(void);
>  void arch_leave_lazy_mmu_mode(void);
> -#define arch_flush_lazy_mmu_mode()      do {} while (0)
>  
>  /* Local cpu only.  */
>  void __flush_tlb_all(void);
> diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
> index a35ddcca5e76..7b5dfcdb1243 100644
> --- a/arch/sparc/mm/tlb.c
> +++ b/arch/sparc/mm/tlb.c
> @@ -59,12 +59,19 @@ void arch_enter_lazy_mmu_mode(void)
>  	tb->active = 1;
>  }
>  
> -void arch_leave_lazy_mmu_mode(void)
> +void arch_flush_lazy_mmu_mode(void)
>  {
>  	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
>  
>  	if (tb->tlb_nr)
>  		flush_tlb_pending();
> +}
> +
> +void arch_leave_lazy_mmu_mode(void)
> +{
> +	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
> +
> +	arch_flush_lazy_mmu_mode();
>  	tb->active = 0;
>  	preempt_enable();
>  }

Acked-by: Andreas Larsson <andreas@gaisler.com>

Cheers,
Andreas


