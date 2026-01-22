Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7975AD3EE6A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 14:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5A26B01FA; Thu, 22 Jan 2026 09:00:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7838D6B01FB; Thu, 22 Jan 2026 09:00:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685D96B01FC; Thu, 22 Jan 2026 09:00:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59A9B6B01FA
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:00:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 063931403DD
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:00:41 +0000 (UTC)
X-FDA: 84359760282.24.74F20F6
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5B85B180009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:00:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a4hQtNra;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769090438;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KXXllTpn+4j3DQ+o0FpmjiZEdWUg34VA5GPm+3TDwac=;
	b=iw/LerhAIy7ad9pm6RngGeFaD1Aa6w2791EkfIHavMTg5MST7cqOOWJ8k2iciHp8e8IWM3
	FlfRURHFGSkov2uNjjcqBozi/JL1NKY+kakG8C+2kZZCJe0UEm5qH9IUwu0O3FfrWpm64D
	pbzi8+GzJCmQ9QNWThoSw+DoSdwI3yY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=a4hQtNra;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769090438; a=rsa-sha256;
	cv=none;
	b=d3LrMfy9Y5tzgRncofn4GAmGiyrEQqiY/LRZgPzHvCo4yCaYXzXS8IuS9N4CEXgEKLfzCZ
	lJG16DFLXQg+k4KBIh3VM+01bfM3GI+AW5aJ1K4RsP7JBW6FL10ixMsn7fIdoF3GmS7Z8p
	ZGM5ob3Lzbgf/tjdSqi/9DBAsbqYi9s=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65808bb859cso1678877a12.2
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769090436; x=1769695236; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KXXllTpn+4j3DQ+o0FpmjiZEdWUg34VA5GPm+3TDwac=;
        b=a4hQtNra7DdRd/Gr3PHE7/UqqvHGW3P99HEC3uCAM4DEJXIDVaWWimN4qrh5sc2Rhy
         sPKbsWPMP2HBAeDubo4EhSY4A3fSgBwMgj6CSwsO2/bi+Zds2AvBnI+myxP++DL2CCZT
         oiOPijj/4RrrY37Fm34WSsierGzymnT1iO6/B+kLsV6+6yQ4Yi4SEQWiflFDleTA86RV
         clp7Mov3KZ/QPoWKygAc2Kw2lE71R7cyG0EhwlEus9WdYmd2tdLhwR3QZIevQVXCFDO4
         Sbiwie2Ru1hhXcyv5x2hN2uyjlDjzZFloqKZIXh+yBmMETpB0JzrFwB66cdEiLdC1FdS
         SbTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769090436; x=1769695236;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KXXllTpn+4j3DQ+o0FpmjiZEdWUg34VA5GPm+3TDwac=;
        b=dnKsiqNphEgtttT5byfRuFR03S9w80s7bEIX6sA/F5ZaSf6aUCiWqc984VWSaHu2F4
         p1yPDi8ACAqKLBwX3XaAsEyKYTLY044FRopCkAN97H0ww11z1UqUNqtUdKo+47frmHxY
         BC+zsX8hETuXNSLjDNBzF10WJHi85p1ECxcuqXbl01eIR0WVEoRz2P91FNi9RziogTCd
         iKp7r+yPfdM4KijrpB2p/npo1bBRNs8rXZASeKG0AvS0tc6fTBJWZ8HsJmMtWmKuSspd
         2f0SqFcwqzZxE2FnyW49jUir6DIx46dwaavS9rmDwJLDsxUWkoq56QKKNpjrW8s1cB5s
         N1xQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+Zhqn9tST/9eLVgZlwD4huXzi3+jTh7AYtbesvon57qgocU6pL5Y3aoSCnypEIfViSgxqFHGqLw==@kvack.org
X-Gm-Message-State: AOJu0YzTlx7ZOtQ0XLeeaQ6jkfbeqJoVpsWp56vr5iqw+G4eLdT5ee3c
	HHTB+t6nJsKC3Leiv0YbCgZkrmgObgNWX2N95wKBB0pkAFAnh9x5GJny
X-Gm-Gg: AZuq6aLLQCOH7QKwD9mke2uF2g6oC+lZwhn4cV74mDdhZzDUdkWsrOhVtBdP6ppnpIe
	erndSFnMSIc86XjBHP3868Bob6eJS6XVsfosCjY5Pg+qTMQex17dpqF+1HD+iPj9Y7wXHHodR6k
	05ccszix2VJFfX2n7N1IuXxRaqIbz7GAS134kC8JvMMieTXJfFd3Ww7OXUqmwDMdIU4ryWiBc+y
	C+I6a/GwzWpfEYH2zzKo1r1UyZ+TAlkV5W52nR3VWmwOkC8b9YO+rVp2GQTxoy5yfDR3c26Xv9y
	Wxs7G1Gz19a1yYt/LnjRdLSEmS3YpC71Us2MnQCwO1+CV4UUsug4ncMB2IDEUqTXXex9Uc2dVfs
	HL7ednUUuq3+/fmPOejx21D89BZsUIjBrjAOXMB3LKU+frCLl7vnCLn4/sedB/ZPsLnH12x2eUE
	t//9Aww7bFAQ==
X-Received: by 2002:a17:907:84e:b0:b87:33f3:6042 with SMTP id a640c23a62f3a-b8792d3be6dmr1826205366b.9.1769090435585;
        Thu, 22 Jan 2026 06:00:35 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b884006d3bbsm68748466b.32.2026.01.22.06.00.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 22 Jan 2026 06:00:35 -0800 (PST)
Date: Thu, 22 Jan 2026 14:00:34 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, Qi Zheng <qi.zheng@linux.dev>,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	peterz@infradead.org, dev.jain@arm.com, akpm@linux-foundation.org,
	ioworker0@gmail.com, linmag7@gmail.com, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 7/7] mm: make PT_RECLAIM depends on
 MMU_GATHER_RCU_TABLE_FREE
Message-ID: <20260122140034.ymigrfppzwvmcjkr@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <cover.1765963770.git.zhengqi.arch@bytedance.com>
 <ac2bdb2a66da1edb24f60d1da1099e2a0b734880.1765963770.git.zhengqi.arch@bytedance.com>
 <20251231094243.zmjs7kgflm7q6k73@master>
 <a3a60bbb-70b7-49ed-abc6-937e6c13d681@linux.dev>
 <20260101020715.45wqnjgcklvjcth3@master>
 <d38fcbe5-8b4a-40bc-b8c8-1c49ccaa9964@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d38fcbe5-8b4a-40bc-b8c8-1c49ccaa9964@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B85B180009
X-Stat-Signature: h5rgwfxz6i8pcohu8h3suyp9pbdusrzm
X-Rspam-User: 
X-HE-Tag: 1769090438-416950
X-HE-Meta: U2FsdGVkX192TU4GoYoFsFVGEb1Cc9GQg3PhmW4MJJET86CGdyaIATUO2J57ilRyn30eoR0akDSsh9BOZ/Iu5RvLKd/GEoKOV+WDCWQaWygPq+OIx1mQcg/pyfjp5KayCRZ3kTi7XYHJU0ZgGfCwzSh/AqZfEUDeweCtEMnwNNqANorRL7gdH9cDXNQYsr+gGQa094c5WwwRC2UnKrNcays1UQXxI8GiZXOCarqsLYELw3+Aq1CCjSP4x7Pqx9NNld3IamyW1edxJYELovVw2v3Fvoa1RuxDZC2bpCw4KIMXJfEyBRrT+pbFJasosQTd3A1GS0fLIqzVOkhWGd8MyqrkYngADRJ0Hio2O8toVzfNIb5RfeiOUI6lYfYYclK7AbSTUW6hY5buPF9av1NS3r4WAsILhzUtbD9956DQvJe60X3Z8pwR4NpSWPFd40JNtY7cElAHukRQDUjg9uKJxND8T5MT7YFkepjWvvAxr0kCqwzCuTOlQaihibXKs4XuZMT8FmKGsN56wYiLHWQvwlDEeMR2D1PkYZWM5J60HEu2HDOlpIk3/+qnhnR9HQYjV+G6qgTMLFe5/mzBM9p5u0mxSPP70vqsDs0/81TCNxOg3t0VTqVZpPTtOyEm9kXTdGpCQNC1hw3azjDPcXKqqnj/32MDsbuydPbtUJtOKoD/sHPbqR7KQjZ0QfkXBGKkaenes1j9tFf3FenvhjA4u8CEFk/I7NM8r7eJg2YC65mTs8kEw/kcFvVmEHZ2niilyWqGrWaRxsRZ4B0zim6ewCILj7ZB+65q5scwbz5465iofyXsXAIw9FtZco2zwf341Jq2J5dM8uqHZ+ooTxdqzPSX7P36Q4n4FTKTpXPxj2Vr55Dg4pAS28DKbeAOSnzKvPdcUtofj32YxD64lq2JgqwCNLiuDssHZSZhJS2ZBc6moW0Lz1nyriwnwUumsGbtSVRexGIgoxXzqkmMN35
 XMXyC2Gs
 8HAHQ3paK3kAll6eos13w9F79LxTy55IrqZwLmm4UsZ2tH4F6BFtFB9XCZdjz/UoaNnJdYTYAtlkuFo0ed2HQR2PYuMYpsZYNeauWOJEs7b3/Ij7f7My47T4CyqLpo5IjqkeWquF65Ax/hQhifQ8dddeFy/vI9MuOFhw1zX3ztJ/tLEIGbrRtENds2NS2wP/CixZS2MqvcXhvYyMS/mhNnuxEQToqApe47wi6RW9+MSt9cvnbG+dLQ8lM6UhE9bqO1nXFHEyncBwgg85iw5/wL3v53CX3187SjE6ypfbP/pVJosV1HMzamqPDiTnQ++ufGWbFHYdbpCHq+ioZqbJybevHSWma2CGmvNDKIp4l+QuXQ+NTZuhcpnl6TlvNcTVgXqACo7I9gxkzCjJtG2uyEovWYrbxXhc4c2paSJVqf3TAnlSbtvNWr1CyXU7Z8fiapqthu4oboFKOqkO/TcF7onF7ZzO0ZsOvuomXkwFfA4/OL9/eqrxHEXHNtslK9J5L8NrphSrS5EogKINb0vSHl346eoTqnKplkK5cE9Fk36r7SvswzLD2QjnLdMcZOzvyfZei7pzot9I0WFLhEE+Cu+85eELcimj1XDns7n8feTXb9F7eqPTakv4z7ZK9g8y6BhcRjf6SD82KfVu/ETaD/2lI6Fe5s+GdZjjhVEv2p+Uv731P+HrFkY7Sz0Jr425Ccrlzg4tHaH/LL8XsXxZ7ez78v9bJWueQcVGArgTVV5zBlFMPai9eBkK1Jqt320+txd+zN7xKSxN77yjV9kIS3q1693F8cz2xolTiAL4RuV8xcU2PTcyQ9tbw7dnxBrJAjVnOuDke+grZK0RvseY6r4+l6CEKWCgN3LPFb06T9eZL+CA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 11:18:52AM +0100, David Hildenbrand (Red Hat) wrote:
>On 1/1/26 03:07, Wei Yang wrote:
>> On Wed, Dec 31, 2025 at 05:52:57PM +0800, Qi Zheng wrote:
>> > 
>> > 
>> > On 12/31/25 5:42 PM, Wei Yang wrote:
>> > > On Wed, Dec 17, 2025 at 05:45:48PM +0800, Qi Zheng wrote:
>> > > > From: Qi Zheng <zhengqi.arch@bytedance.com>
>> > > > 
>> > > > The PT_RECLAIM can work on all architectures that support
>> > > > MMU_GATHER_RCU_TABLE_FREE, so make PT_RECLAIM depends on
>> > > > MMU_GATHER_RCU_TABLE_FREE.
>> > > > 
>> > > > BTW, change PT_RECLAIM to be enabled by default, since nobody should want
>> > > > to turn it off.
>> > > > 
>> > > > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> > > > ---
>> > > > arch/x86/Kconfig | 1 -
>> > > > mm/Kconfig       | 9 ++-------
>> > > > 2 files changed, 2 insertions(+), 8 deletions(-)
>> > > > 
>> > > > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> > > > index 80527299f859a..0d22da56a71b0 100644
>> > > > --- a/arch/x86/Kconfig
>> > > > +++ b/arch/x86/Kconfig
>> > > > @@ -331,7 +331,6 @@ config X86
>> > > > 	select FUNCTION_ALIGNMENT_4B
>> > > > 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
>> > > > 	select HAVE_DYNAMIC_FTRACE_NO_PATCHABLE
>> > > > -	select ARCH_SUPPORTS_PT_RECLAIM		if X86_64
>> > > > 	select ARCH_SUPPORTS_SCHED_SMT		if SMP
>> > > > 	select SCHED_SMT			if SMP
>> > > > 	select ARCH_SUPPORTS_SCHED_CLUSTER	if SMP
>> > > > diff --git a/mm/Kconfig b/mm/Kconfig
>> > > > index bd0ea5454af82..fc00b429b7129 100644
>> > > > --- a/mm/Kconfig
>> > > > +++ b/mm/Kconfig
>> > > > @@ -1447,14 +1447,9 @@ config ARCH_HAS_USER_SHADOW_STACK
>> > > > 	  The architecture has hardware support for userspace shadow call
>> > > >             stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
>> > > > 
>> > > > -config ARCH_SUPPORTS_PT_RECLAIM
>> > > > -	def_bool n
>> > > > -
>> > > > config PT_RECLAIM
>> > > > -	bool "reclaim empty user page table pages"
>> > > > -	default y
>> > > > -	depends on ARCH_SUPPORTS_PT_RECLAIM && MMU && SMP
>> > > > -	select MMU_GATHER_RCU_TABLE_FREE
>> > > > +	def_bool y
>> > > > +	depends on MMU_GATHER_RCU_TABLE_FREE
>> > > > 	help
>> > > > 	  Try to reclaim empty user page table pages in paths other than munmap
>> > > > 	  and exit_mmap path.
>> > > 
>> > > Hi, Qi
>> > > 
>> > > I am new to PT_RECLAIM, when reading related code I got one question.
>> > > 
>> > > Before this patch,  we could have this config combination:
>> > > 
>> > >       CONFIG_MMU_GATHER_RCU_TABLE_FREE & !CONFIG_PT_RECLAIM
>> > > 
>> > > This means tlb_remove_table_free() is rcu version while tlb_remove_table_one()
>> > > is semi rcu version.
>> > > 
>> > > I am curious could we use rcu version tlb_remove_table_one() for this case?
>> > > Use rcu version tlb_remove_table_one() if CONFIG_MMU_GATHER_RCU_TABLE_FREE. Is
>> > > there some limitation here?
>> > 
>> > I think there's no problem. The rcu version can also ensure that the
>> > fast GUP works well.
>> > 
>> 
>> Thanks for your quick response :-)
>> 
>> And Happy New Year
>> 
>> So my little suggestion is move the definition of __tlb_remove_table_one()
>> under CONFIG_MMU_GATHER_RCU_TABLE_FREE. Do you thinks this would be more
>> clear?
>
>
>Do you mean
>
>diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
>index 2faa23d7f8d42..6aeba4bae68d2 100644
>--- a/mm/mmu_gather.c
>+++ b/mm/mmu_gather.c
>@@ -319,7 +319,7 @@ static inline void tlb_table_invalidate(struct mmu_gather
>*tlb)
>        }
> }
>
>-#ifdef CONFIG_PT_RECLAIM
>+#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
> static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
> {
>        struct ptdesc *ptdesc;
>
>?

Sorry for the late reply.

Yes, and maybe we can move the definition to the 
#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE code block above, then to be next to
tlb_remove_table_free().

So that we always have rcu version when CONFIG_MMU_GATHER_RCU_TABLE_FREE.

>
>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

