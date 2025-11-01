Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A98CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 12:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7406D8E00AC; Sat,  1 Nov 2025 08:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718728E0068; Sat,  1 Nov 2025 08:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6078D8E00AC; Sat,  1 Nov 2025 08:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F14D8E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 08:18:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 117C6C07C9
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:18:18 +0000 (UTC)
X-FDA: 84061940676.08.D7A35F7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 93E0F140003
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:18:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=duSGsqk1;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761999495; a=rsa-sha256;
	cv=none;
	b=xzrMGel4mWnfR/uj3z/c7ufQQeXro/leSasbYf4TizqaKa+NhicE2kyFwN7SJJG98MNDyW
	Az8tEP0gWPoUod6ImV6OZRbYVCiVn/7awLkeaF+ml3bkJFd8iSX32DzwPLD7zWROX8FiGn
	ESl0ZuApfnRf7O8y2a1ZveJFejhT1JA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=duSGsqk1;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761999495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nakH/PvmVEC4FueXBEYiavMVStVvZPPhZqsGXFef+TU=;
	b=YvklieDkSm7mBsxRMXDnD0YorqwIQOsSPjW/fy8wkL8i8Me33r2gYaoMhKdPjRy8+tZwPH
	Ckm2Ibug6jTmcAEmpVSVkguamVF/Ecz9F293tyHhuh5Dd/hx0A/gOr9b8I800yJb4ttShv
	5ebTYvQ3XJuSW/feXzpjYz96Oe92cbg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761999495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nakH/PvmVEC4FueXBEYiavMVStVvZPPhZqsGXFef+TU=;
	b=duSGsqk1HLG75OxmukG552lkIF8Lgb7eTKamQvKaaqWQLPP4RrXITVPZDU2ArbdhpmX7iE
	g7lNhUA8lHiQMPvD0oiw4lUsdg8LpqAeuXxEhRvWbImfcqgbFuYssnRh/i8dJGUkVXfgvG
	pYqU/hcn2xSkcc9WPKABOdhyUyQcB6A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-_46mKvi_OyOo1zKVPKgBWg-1; Sat, 01 Nov 2025 08:18:13 -0400
X-MC-Unique: _46mKvi_OyOo1zKVPKgBWg-1
X-Mimecast-MFC-AGG-ID: _46mKvi_OyOo1zKVPKgBWg_1761999488
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4711899ab0aso27988995e9.2
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 05:18:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761999488; x=1762604288;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nakH/PvmVEC4FueXBEYiavMVStVvZPPhZqsGXFef+TU=;
        b=aCy582704OD5soc96TTwEcw35p7Yv0HIyPwmrjxosqMKehIs+ossD3oWrauHV2s6ZB
         5DcxqFzXauQkZb5LZ62mJNh4fEaveKeMTOfosxRTLkMffmLLw2su5eOVq7g4en+wiRg+
         JOCE9qUEgV94tw2Lnl2ba5788QBxChm+khmoV12i0YLJtPg0baEtTdmtsyGyJ8uzEeWL
         eC7RHHML7UcieIqjVLYEenyEtNIkGq3Ae09F8RUtHyWNKccZEEs7qehupnDFTh/Qjdge
         hkKPfKmp9AgrSJD1qGz6jcf8wdud8uNJkPQohd0dTcP8l4NgZPBfOCnSiK/i09W2+P+Z
         HLNg==
X-Forwarded-Encrypted: i=1; AJvYcCU/aEJJvcjcSg2UXMQRmHc4Dy8afbkBJs74Y9aKdm5U0JAqWClYu2KXu3Thdb4/Xq0I8FbXK2hXLw==@kvack.org
X-Gm-Message-State: AOJu0YwOC+dKHUf3KTBphUkgFjxYdXqW9kqbuhY+KXjmanTHLp1mhJY+
	yIIPyyC2McXrr2L5CbVe3Khg8BpGnn5n0m6wmk6dnPWQkArRIVkftfUjDH/rTbM1FiGh40foMdx
	vlK2uHZnGB5uOQi2NAHgbBCKv2ca0E07QOQrVEP3zFAv45/I3DveN
X-Gm-Gg: ASbGncszyNY5tzfKFDeqXgiyeh1J/W2VaA+ygWFyEiuY26supwnnYQuXotU9KrtqF80
	Wn+/z4yclIBnhLtEuWf4Oi03EH2NWBM9FLOlY/bFC3Ei9WZx3WvRhWgQ/Ez+fHEamOFJqh7857q
	c1BJeUzNpwBRRxTInLY4OXtYLAABpXU8BymhX0QbyqmQqmmrSBgUlOMkx++cbsiAQ5KKceSiFZx
	7pG23iTatjI5PQbvG6mvKVJS0/v10tTzTyj3hiqCPMv3nSNztcmdpfWWflMW8DVpsKEAjdPeqyI
	tyqZEEemSvtrIxDAbbKd8rr37tTz1L2J7OqU0JvCy0Kap+QLatjeM1O9mZbVgCbdtVD68eU3Kg9
	CUKs32ZEouHTHFKqVa3UyXFyd1kP4V3SypFkMeGTm1TsTK+jxcIt1tOgh8noI8pk+H+r9rOhPPT
	vqSU5p9JzZdTh+sg5TvmzDpefYdP4=
X-Received: by 2002:a05:600c:1d9b:b0:46d:996b:826a with SMTP id 5b1f17b1804b1-477308c8b64mr64006445e9.36.1761999488372;
        Sat, 01 Nov 2025 05:18:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEYuiv87iZ7G8foU4ArwULKDJw8Idy7HTvUTtsGo13HOjZ3TpQsscDerygyrVDH0/hBtY+XhQ==
X-Received: by 2002:a05:600c:1d9b:b0:46d:996b:826a with SMTP id 5b1f17b1804b1-477308c8b64mr64006055e9.36.1761999487959;
        Sat, 01 Nov 2025 05:18:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4773c53ec2csm45855895e9.11.2025.11.01.05.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Nov 2025 05:18:07 -0700 (PDT)
Message-ID: <8f3596e9-fe40-4591-946d-65e849955a2f@redhat.com>
Date: Sat, 1 Nov 2025 13:18:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/12] mm: introduce generic lazy_mmu helpers
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-7-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251029100909.3381140-7-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KmRzHUt_D3QrTdnXA1BvzzZ9X0iZdl-JRecAqdYZhQA_1761999488
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: w6fycywi7tcx33o7ap7f4f8qyt6f1err
X-Rspamd-Queue-Id: 93E0F140003
X-Rspamd-Server: rspam09
X-HE-Tag: 1761999495-725872
X-HE-Meta: U2FsdGVkX1+SytIsVsKs+YsW8wNeOqgPrEiLoBXeB4Ymx+x5LbcXgeGF/oFDvp0+ruCvUADN2VH0wAEQ8tsxVfbkVj14Wg9iI6VPyWWCZZk18t21jzPZlJiPMdfbkeoRN1A+28GwxjUZxex5umUw33jIQxE9OoqC7SW7MRl12BMRUdq/KZkGIAfh7bklr7VZAJs4iVnOhl9Ttk7eYSARLP8BYQSY2P3GIdMQf1e22Gme4Ge5Lt77yuFDgqGyNCswZZNVFLCdS76qfB5PNvFEqmkTW3liFA2GWnsh4z2PPw/Rm1ynUC/tgQ2+xm3hOWSWytyAmxIkDzoYm34CKUS0SLYE+36gLIF8F7wSmLbBEAUcgXL4i75GCvNlhAEeaY0TxTR+uXMLS2efpabuX5rZFsANtjBypKBaTY9mjReRdTTuid9uKf7+oxaERWpXiXbaxmTqgHfL+gR1XxECgEX3yrXjxMpe7725/d9QIxtuTeyhmQ83DC2EB2DCskAT4WrONfgFzBQgv9CekZvN/9j2CcQUwjGM+yypvUrvJh1gSz8Uw5cgWsPNdY4ejQywju5KuiJZ9rs2ZkvshFGgoSRcHMc8S5JOVdyUzCeqqS99ZEdp8EOTu1DNmohMoEd3w943RQyw7unqAhIlo8dIBxFGbiBOat6sEgq/37NPfjvDptvvwIt1fk71bvegyxDXJ9bZxW643viOcSRVpvyQ859upwElns1AsDRUK7NMaqa6vVdYHAQLujfVoyRA4U4RcIR5dN8Tw8+gMFN0B1snL2iNsGbvDK+dzNKjYWa2ppF878cX8fREXzyGMU3Vmzc9/wbCoM0u+kYilVFzFUm1iKxQVp6nGoRKkPUHqc1/33kQQp5vRi7IQIgDusKPNkG/vqyFGQgZs/c6uTTWiSLOfQUA933ws7MvmjTzktnrJwAKPcMuUg4eJ9Mi1h6KSeUbjdTmTTs/7F6m/XnSTCFLnvn
 WH2pmcQx
 4LyhFBlm7vOOitbMdlgi3ngfWftf/xAnREHV6u3uR5RicCpdYWjaXwZ4zQj7MZTD3jTL957WmlKiId889WwV56vaBY0tvpvG3W8J7sgoviAjwIo+brDc9JQTbJBvP78CE6OLCBQkl9urhOntWVFGygX2xJFimwrvfFjMdp87Zn6Xj6Yxz+Ej7i7qo1Tzk5olW4QLXFnoOgTm3Xn9ox4kzO47IU7RIB3rTDKc+V3m0ms+ZLIu+B9C8DLYMALehCw5hufLvxN2eaRKvsv0SRtwZsQ+6d/wtKNJ+9qm5//XjR+irUIi1zU4deM5ZRNnpoCj68ze4LOnoG01P9WJWBzcPv7JAG5/CJdZtkCex50TMgUGNC+k0lhX+Ckzl3Lf0icN8MJzSldEuUrktkIsELfeNLrX9zrglh42QdiyvKsRAtOqgE8rL5o2QWG5uuC/K1YZJcpZczOofPA68v6RKAf+UMR9rFxtChMk5gh/4G0q2J1/dGzuIFsFFgD1AG250Ldw8isoM0i3VIGTd3CjQMnqFjTFW/GbZL4p2MbN1PN8BfWxObDIQp42pnhSiTEFDsSNDVhVU7vnBgBWiWomj9Z9P0vyjL2je3AnHOEUWV1k/9d7FqhAXqjnWUJIpi/b8fbJIU7sC5GcCvfhUbgM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 11:09, Kevin Brodsky wrote:
> The implementation of the lazy MMU mode is currently entirely
> arch-specific; core code directly calls arch helpers:
> arch_{enter,leave}_lazy_mmu_mode().
> 
> We are about to introduce support for nested lazy MMU sections.
> As things stand we'd have to duplicate that logic in every arch
> implementing lazy_mmu - adding to a fair amount of logic
> already duplicated across lazy_mmu implementations.
> 
> This patch therefore introduces a new generic layer that calls the
> existing arch_* helpers. Two pair of calls are introduced:
> 
> * lazy_mmu_mode_enable() ... lazy_mmu_mode_disable()
>      This is the standard case where the mode is enabled for a given
>      block of code by surrounding it with enable() and disable()
>      calls.
> 
> * lazy_mmu_mode_pause() ... lazy_mmu_mode_resume()
>      This is for situations where the mode is temporarily disabled
>      by first calling pause() and then resume() (e.g. to prevent any
>      batching from occurring in a critical section).
> 
> The documentation in <linux/pgtable.h> will be updated in a
> subsequent patch.
> 
> No functional change should be introduced at this stage.
> The implementation of enable()/resume() and disable()/pause() is
> currently identical, but nesting support will change that.
> 
> Most of the call sites have been updated using the following
> Coccinelle script:
> 
> @@
> @@
> {
> ...
> - arch_enter_lazy_mmu_mode();
> + lazy_mmu_mode_enable();
> ...
> - arch_leave_lazy_mmu_mode();
> + lazy_mmu_mode_disable();
> ...
> }
> 
> @@
> @@
> {
> ...
> - arch_leave_lazy_mmu_mode();
> + lazy_mmu_mode_pause();
> ...
> - arch_enter_lazy_mmu_mode();
> + lazy_mmu_mode_resume();
> ...
> }
> 
> A couple of notes regarding x86:
> 
> * Xen is currently the only case where explicit handling is required
>    for lazy MMU when context-switching. This is purely an
>    implementation detail and using the generic lazy_mmu_mode_*
>    functions would cause trouble when nesting support is introduced,
>    because the generic functions must be called from the current task.
>    For that reason we still use arch_leave() and arch_enter() there.
> 
> * x86 calls arch_flush_lazy_mmu_mode() unconditionally in a few
>    places, but only defines it if PARAVIRT_XXL is selected, and we
>    are removing the fallback in <linux/pgtable.h>. Add a new fallback
>    definition to <asm/pgtable.h> to keep things building.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


