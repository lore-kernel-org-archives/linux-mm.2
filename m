Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B657606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 04:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MfqYncIT
Received: by kanga.kvack.org (Postfix)
	id 632336B05B2; Sun,  8 Nov 2026 23:59:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3816B05B3; Sun,  8 Nov 2026 23:59:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8C76B05B4; Sun,  8 Nov 2026 23:59:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 318CD6B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 23:59:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE8BDA0571
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:59:40 +0000 (UTC)
X-FDA: 85414377720.08.EC5DEA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 18CC440003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:59:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MfqYncIT;
	spf=pass (imf27.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794200379;
	b=pZdexW3KUE+giM4HSl66cXELopMPZiQmkpQ1T0bbvpANIo0oBg5X52UCGXgo8XTPg2H54O
	jernXQq7yVjFMBXiJu/7tBP0aZCKdE0RQR0M3wQbgYSnt3fWmXZ/ne5fSOQf4nL2dNrZP4
	QPOpf6AHIgIknvC67yng+KOuWgHxyOA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MfqYncIT;
	spf=pass (imf27.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794200379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERG2I7Pd24sxoFvp82kJAGtR6dHyLv+SwnsIesDmAb0=;
	b=EwdPY6Xi6PPaURu9bed8ZlNPQEHVjohNS9pnEexhsLD5nK/7GieRWVMXuJdDWSALvMxB7q
	l9XBmvhs6IiLkhqn7zUqU4pkO9SSGuGHZFxHo0kmyubZxAsDezQOh2MgR4ggZ8Mzn7by7d
	34uhE+mzUNn4rRH0Y65+pJfiooMtuHc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 306F940A52;
	Mon,  9 Nov 2026 04:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8721F0089F;
	Mon,  9 Nov 2026 04:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794200378;
	bh=ERG2I7Pd24sxoFvp82kJAGtR6dHyLv+SwnsIesDmAb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MfqYncITt25+ECW2QvR5aoo9iAQhXLKcQ2LdXpuZzDe0mnvVZC3n726QmHzfgQh8y
	 DfwvfSOExCsM+2jHtIJDTkiqujRoLgPcduIvhE7yCWF7HRVm5Dnc8n4S07lj4uYw+N
	 oC13rcU8BzslZRwR2c0TdtfDFaY+5upd7x6RZeBUyCxFCXABHd7FI5UFByFQdKgi1Z
	 R5iTB2vqMVn+hM7bHW3mLT90DD/IgrKT87ztZ8D/jhL+TOlXISPnsgQud0PU4hQFau
	 yNWlBQADuUTXqiU5hEU5qaihGJtxUnFG1Vhix1HROVJwJDjs/yOMYcVjS/psdLXRqd
	 rsuSCirkQUrVA==
Date: Mon, 9 Nov 2026 12:39:25 +0800
From: Jisheng Zhang <jszhang@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/4] arm64: percpu: Always inline helpers used by noinstr
 code
Message-ID: <avFOfUZFBqTzrT4X@xhacker>
References: <20261107071339.17467-1-jszhang@kernel.org>
 <20261107071339.17467-2-jszhang@kernel.org>
 <sashiko-outbox-203633@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-203633@kernel.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 18CC440003
X-Stat-Signature: rx4j7ksjfst8113mcxxgktxxhzkfgo5b
X-Rspam-User: 
X-HE-Tag: 1794200378-526611
X-HE-Meta: U2FsdGVkX1+WBsv3NeEnqw6WfzrbDI2TBFM7XfepxOHtYKCNV7wl50SQ0KcZXU10HTIIZdVKod3xBYgiGmH7SieekmDuW0XpWzRRTvelgvDvOIIUbi3WMkObZI39AhKl77TNPwq6TIoU6fop6Pju9z4FfLv3MW/bt4yeHDVLbOfzv0fiAXlJjLjh/RML1Epg1XPZ+jW8TXlZHDdRKMUVfK99IN64TIHv4Mhv3Q56jj7CBkU85h8cdtHaeky3bPnLkcaMhfEi0sn3LncrOagalhBZd9JCiiiHDVEfMQKdTW8ir7fSL4uLJFKi6J2GrZtSpxotHi3Oc7jVK74IwtKavwnIwBayPa04JiMT5igO6gj0OFLgALlovd4MQAnAzETH9wBoxAg/kYwRy5Xjy26v8aNfIC7bHXXCHr2TSklirogvUsI1SFQUxWwa27UdHRgYyzzJ4dyq2IG9ierrFF6+VR4r1jfjTH+ypBGRrRQ4qwlgC1yNp8SztMFUZWlysoqyZLvDNVTIVsP/9k04F8or1DnU9CNm2ByD8lUyFvaNI6AXFes5ewJfqmI9K7nybG+GlpAdCwkouEgn1Hw/d50l8pkW+0E/r0M4jyOJqo09nF1qV8aUQXt0KuV5Cp1LkcZp4zG929CncPY+qJi7ou7mnOunD7Rth4sxwlG/2jHNxkM2KyKVNV+dngQMENMA2sEtce74T6+2fUD1LwlkAzVA3tEN6TZJkLEc197F3pKm2X1iRca1JGrwgtTJjpyF771rTJ54Lin5yOlJ1I8LqiGs2IOdIWbsBt2pDSn1hw3uetYbVmDyDg0eKjdmENq5o3OHNv0ytPVprpU5Hfja3AxD2ker7PrFhYLZbkZir4xA574M+KTR4792rEthqv2hf070pYmc2/kX+2tBgqn1wnlV8WQqAoHRsciqkvK3WAjpaEdsPd7exgryvIhLacwiLpyLZBITK3ZPFURUP1hWaqX
 Ytc6q0X9
 t3PHqZG7MHgAqgIyTqlxySNzxXHUTucJMwVngacZRGz0koJkEDSLNGKi68+wDoJMiRVEvYhcmqAPehu3KmNBVlSimegjTeg1qwJLC/JM1MclsdmM3/xRrcETXeYbM3V2oAICOFhDN4EoKD1TBsmxfbHL/Hs2cMOwns/XvbkRHJKj//OL+VLwOURP2puQqHzvstwU8CF+SuqbOQRyS2tM07WkoMtqKhq+LwqCRrXImh4mn8aMhEYxGl4R0envW1aNcI1Ga7JGx9n2EVdLf8NB+StB/ku6t8u4w3BkLvBmAcAyE1lln4iCRRGkL5S4xVarOjo+ZC4VDZ8/S6Fef0nADuXlZcBpkzG2brcchiEtkL0bHPRuVs/uS7ALbLsqL1uslpEnzDlaOqUvsHyWB/J+Zfk18yocCvTWuZ8lFs8+Z/t06MiteauwxAJVwDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 07:43:56AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] arm64: percpu: __PERCPU_OP_CASE() and sibling helpers not marked
>   __always_inline
> --
> 
> commit 3a2df0916b5200b227df21487897e171275b29f4
> Author: Jisheng Zhang <jszhang@kernel.org>
> 
> arm64: percpu: Always inline helpers used by noinstr code
> 
> This commit marks __hyp_my_cpu_offset(), __kern_my_cpu_offset(), and
> __percpu_read_##sz() as __always_inline so they are not emitted out of line
> when called from non-instrumentable code.
> 
> > diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
> > index 3cc316091d665..7c344de5052d5 100644
> > --- a/arch/arm64/include/asm/percpu.h
> > +++ b/arch/arm64/include/asm/percpu.h
> 
> [ ... ]
> 
> > @@ -129,7 +129,7 @@ static inline unsigned long __kern_my_cpu_offset(void)
> >  #endif
> >  
> >  #define PERCPU_RW_OPS(w, sfx, sz)						\
> > -static inline unsigned long __percpu_read_##sz(void __percpu *pcp)		\
> > +static __always_inline unsigned long __percpu_read_##sz(void __percpu *pcp)		\
> >  {										\
> >  	u16 *gprs = &current_thread_info()->pcpu_gprs;				\
> >  	unsigned long off;							\
> 
> [Severity: Low]
> Should __PERCPU_OP_CASE() and the remaining __percpu_* helpers in this header
> (__percpu_write_##sz(), __PERCPU_RET_OP_CASE(), PERCPU_XCHG_OP(),
> PERCPU_CMPXCHG_OP(), and __percpu_cmpxchg_128()) also be marked
> __always_inline?
> 
> The noinstr function lockdep_hardirqs_on() calls
> __debug_atomic_inc(redundant_hardirqs_on), which under CONFIG_DEBUG_LOCKDEP=y
> expands to this_cpu_inc(lockdep_stats.redundant_hardirqs_on) ->
> __percpu_add_case_64().  Because __PERCPU_OP_CASE() still uses plain static
> inline and is also called from instrumentable lockdep functions, builds with
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y can emit __percpu_add_case_64() out of line in
> .text and call it from .noinstr.text before RCU and lockdep state are ready
> for instrumentation.

Good catch! I will address this in v2. Before that, I will wait
for a while to collect review comments.

Thanks
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261107071339.17467-1-jszhang@kernel.org?part=1

