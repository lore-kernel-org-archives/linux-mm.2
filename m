Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C197CCD1BF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 20:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF398E0005; Thu, 23 Oct 2025 16:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6E58E0002; Thu, 23 Oct 2025 16:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6478E0005; Thu, 23 Oct 2025 16:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 685ED8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:00:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F83E13C234
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:00:36 +0000 (UTC)
X-FDA: 84030446472.20.AB8311B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id EA444140007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:00:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d00KWeuf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761249633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgiDH3MpoD7uD2qK9rjnzvlUwoqe2VD6FKHIi7bhrcw=;
	b=PXKjwLgXuNaH4qViZfLzGXg4oTOwz77Lg40J1E6o1ky5Be6IzV9Sz0LAAcvRWjmhG7LdUh
	nVIk+mOLs0TYipulXzxPaUlMxy3YjlSK823qVTPq+ASsP0lYRQKI82MBJcG5MgsVldGz+7
	GK81e1pky3RYkUZxoB2IlD5WvLzx9OA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d00KWeuf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761249633; a=rsa-sha256;
	cv=none;
	b=wXBDmDInZ8h9G+uVbH2L8Zek948GegV8pkOgUZb8Nfjf/kxEgNCqSZM43YdEdfKwOz55hL
	GhoENWRuDV2edf4ymj9qasf8RmK/1ALMJ9ch7L7FdL5BCrNuBY6We/mdzOV+HhmkgpEFtT
	znGNYLruO1D3wupGdZN0my93TDapRZI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761249631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fgiDH3MpoD7uD2qK9rjnzvlUwoqe2VD6FKHIi7bhrcw=;
	b=d00KWeufa3AKSa8FKCpowxH3XRbDbA5BHwPakkGVmrcC9krGonCZu1o+7WaWJo+HSJFgrJ
	/gWrdOmzoElBEnJxHnDNJMMmQVgNPEbyrl9uVnhLBq/hsUjIFzKmcMvjsDoZl1G+MJuBJJ
	LJlW96uwuS7/v56TWKVba6edZsmDSQI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-sdUP15BFN5KnYi46ysdt1w-1; Thu, 23 Oct 2025 16:00:29 -0400
X-MC-Unique: sdUP15BFN5KnYi46ysdt1w-1
X-Mimecast-MFC-AGG-ID: sdUP15BFN5KnYi46ysdt1w_1761249627
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4298da9fc21so140514f8f.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:00:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761249627; x=1761854427;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fgiDH3MpoD7uD2qK9rjnzvlUwoqe2VD6FKHIi7bhrcw=;
        b=ECfHqkaopPm0UNkdN1jo52ABcaV+pA5E44hS6wVXbxX1J5Xorm2Ootpbd6yCnzBRln
         UhsOYyILLkHJ0r0A0iwBqFsaqtGuQpsu1ZdtQhYNkWpYrMtwat/6znQBpd46Y/ahenz/
         MsGEbeZFuMlfkeXHzttHlo6n2Xi/WGH0dHPusZ7ZXEfUU78b40CbdJIJ+EuGU89o0/N/
         FzXqkJIRmCEtZUkcN1XkjYCmID9kNmyZSWnZq0oCLT9kepYaLnzS5qiJo1si2kqE/Qjy
         VwT3BKTGLQwTK9omEZ02hf0ecEWmRaKnNTeUOgWUKWyIiykQcOQMxktxg/yFqz7qIrew
         qoXw==
X-Forwarded-Encrypted: i=1; AJvYcCWE5u9ECvb8kHnPUt4JDZgBlFj6/mYoYubnY4FKcqs6yIBovnj5BJR9ASf8V/8DyL0L4S5a3lv5kg==@kvack.org
X-Gm-Message-State: AOJu0YxK8jXGo5cCOiwDd5pidsY2gTdMyoA1m4In1BlDdaxNOmq9lDJV
	tF/7O7bHrtr8ueb1BYBZ9zaCW3gxlRLf42Fz0IldiJ0OUBQ5GWWuB02Oxfdtmvd8B890LZeauyp
	hQz4XnBS/ywm2B1prqyhdYp3n3F8o/GVnj3ettqOPeRRosMk6lhK9
X-Gm-Gg: ASbGnctCfLUrX3bgd7/DV03XHUh/dk9xqNnN3NnhpHXgy4PpXdFq19iMvx+q31/+3Pr
	qS4qSuP4HnfjpxdMjW4szgRNKbW93l7Vxi6tC/28y+6lbczurPY3w04LclsW1HjHbRycIFK4ZS3
	J0/u9AW5/TrYSsq9J5/9vxtZc8Fvo6s5RCHasSIWoLgcGhgj0wNkkHgQEKNsH6OdkhSa/A4DOX8
	w2DX2d/W0pRDn9FxEI2EeBZfw1brl1FPtembIDBLrRGD9lnwzBgIU279hYsh9vbF8MJQ4j3xnvL
	52I9rRBRg8jjCZaB9zGQdJr+IIHU/5r87dAlcF/vtKTZ9f5EqYjuFZDMN/6KLJzpnatZhmITosR
	btspaPDxD4KqXggC9wBcRfVMrMJlardyeCaykM1BeVBg8Zkt/7xiKrygvCckzYxpzTiTz4xt7Jp
	jLy3Bu9RSwPA10KeFk+NOS49S32kI=
X-Received: by 2002:a05:6000:2507:b0:427:370:20a3 with SMTP id ffacd0b85a97d-42704d96174mr19941785f8f.38.1761249627188;
        Thu, 23 Oct 2025 13:00:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+rZmuEcRX9PJVwcjwDKugYlruYrunINiyEqNzleVVHplYzNJRNIG0mWVdUdIxUb84AVBP9w==
X-Received: by 2002:a05:6000:2507:b0:427:370:20a3 with SMTP id ffacd0b85a97d-42704d96174mr19941727f8f.38.1761249626561;
        Thu, 23 Oct 2025 13:00:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429898ee8a9sm5476369f8f.46.2025.10.23.13.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 13:00:26 -0700 (PDT)
Message-ID: <2073294c-8003-451a-93e0-9aab81de4d22@redhat.com>
Date: Thu, 23 Oct 2025 22:00:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/13] mm: enable lazy_mmu sections to nest
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
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
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-8-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251015082727.2395128-8-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QrkzzJFLYuKz-NMq8M0uNMrBvJAkHjIes9DTxHZNi-o_1761249627
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EA444140007
X-Rspamd-Server: rspam03
X-Stat-Signature: sy6hqw5x6c3obadfuofux8w18ifatsxw
X-HE-Tag: 1761249631-479813
X-HE-Meta: U2FsdGVkX1/r/XcGFdTEL7ehBIGVeH2QJmneyiw9GO7EPDwusBHoiCMNBOJsEGpCrJMEP3RI3ao+PkW4CYsjIqBdg9JliuOu4ECDHj1KFFgSbwT9Gvo8N7E2o/uzytiCYCEH55dhkXUxBJwEBIMcmPoS2ndGVj3SJtM2FexsREen9iRgAS3czJMpj2mhzcHcfOggZ70gM93OebKqrTIvm7cXMM2S86wOfvH0gIc5Y6xt/OHgVGQ/z82yN10tg5f6HDmmAseQTw/NoGsr7GKpX0Zqdw+Bx/BGS/Rt6zspjDAkaCBekuW5tFny/Cs1mAs6Nbiy53ghZ9rnBi39ENn59FIpPctht4Bl1VdJbTzYnfDdncdL6Yd/1+t97RPWs1RrJ0mKz+8Dh+CpMBBP3y+U2uLntd5shgYf2RlxuOcuh7Iidoty0LhXMzIqw8+D+cnc2E7D2JTbvI3VqMkstBxapuJx/bwmW5d33F923ny415UqofZyfjkniVFADmz2SimnWZ6NF1fb6euKTntDek383wTqpXKqoyjyv/BJygEAmf12S4tYoOXXxLubtBk9Lg+7Yhsx1+XyaYS5Nu/fLqXdI7CGhIziZmyzN4n6Qh9OhSRpj9MJFQ0ZJZc7Iut5BrM4iTFU+An9YVfXP5vzA2TmAXU+sN2sBNG9tHQkyQwbQYhGxEsANB5ckM/71KuyHvUzght1VdUZb14cN/7HKW/FY/CoPK0k3NE+iQq981s5FJP6YpXzU6IuxRkhgBoPWgvylYcwDwJRP+Pe8huXJd40YhKZgDuFyAzTWAJZ6qawPubN8brkYiRNTTgC2HxS0lSYtZ+P1FayrNss2TtZS7Koa9cBdPKm3crf4Ju0aFb7c8qCmAJNE8G3+FgXotJF5TpNOxqMgHqs8zBn4ily7W6z7tOOQ8lQlXJfMMfQs7J/s2w/reRl7rOzXn6cAf3EwiPXIgdJi2DmZEmQIRisAZ6
 V8IrPKP3
 HRO82x3vd65VFs96NbXkzGOhtJqaPQJj5X1nz/CSSTZQXaLm5u8YvIY2fKXHaers4W2cjwonRvOz4cjTeXG0Elt+K6kdW3L4Ewt4UHaJ6RZ+hORL22qlnjGoEQ5OBJk9sWA3YYYbZ5F3rGib/KM2jm/7uUwtwP4GSEEB1P5K5LjEgbxQYiv3GmbUrou42uVsXcC08FaRJ3r4sOZ6xEZybkAEOGW1IWfRUuw1xFbinuwHwHWI949c3TuP0DAnG91EDyYnjBVHUbrXF5Mhz2mcUom7FA0Ha8IazWnvpgkmSiAX/ETpgjRe8sb0fADCtOfRUoPabwO/qH1qV2QRQMUWHt5/YkikOFNtjSruWSE2F/3KgVH64j31vN8pc2ubRJJPm83F0v477Wj39cALiu+QeeLn5fVAVzlHHAcavFO/5iGwCI+L7/AcPwJDL90Dzh2B+OZhatsP8c1GMiBntQouY8mLxc0srJXpEOkE5frszWBMle3BMJI7HxOWMXPn1Sf7kM3Kiztyy80d7QHvaqV+STSrOjEuMCnCvMS5rYzayXK4oVTGpoEEs+LhQjMXAOKH/CS7G5HAALiOdp2Lkd00pEJkZQfWMhL2lj6A43G7vDy0FzvTITgxWrKblpS3A9jBcITtsIcgsZVYuxdM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]


> 
> In summary (count/enabled represent the values *after* the call):
> 
> lazy_mmu_mode_enable()		-> arch_enter()	    count=1 enabled=1
>      lazy_mmu_mode_enable()	-> ø		    count=2 enabled=1
> 	lazy_mmu_mode_pause()	-> arch_leave()     count=2 enabled=0

The arch_leave..() is expected to do a flush itself, correct?

> 	lazy_mmu_mode_resume()	-> arch_enter()     count=2 enabled=1
>      lazy_mmu_mode_disable()	-> arch_flush()     count=1 enabled=1
> lazy_mmu_mode_disable()		-> arch_leave()     count=0 enabled=0
> 
> Note: in_lazy_mmu_mode() is added to <linux/sched.h> to allow arch
> headers included by <linux/pgtable.h> to use it.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
> Alexander Gordeev suggested that a future optimisation may need
> lazy_mmu_mode_{pause,resume}() to call distinct arch callbacks [1]. For
> now arch_{leave,enter}() are called directly, but introducing new arch
> callbacks should be straightforward.
> 
> [1] https://lore.kernel.org/all/5a0818bb-75d4-47df-925c-0102f7d598f4-agordeev@linux.ibm.com/
> ---

[...]

>   
> +struct lazy_mmu_state {
> +	u8 count;

I would have called this "enabled_count" or "nesting_level".

> +	bool enabled;

"enabled" is a bit confusing when we have lazy_mmu_mode_enable().

I'd have called this "active".

> +};
> +
>   #endif /* _LINUX_MM_TYPES_TASK_H */
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 194b2c3e7576..269225a733de 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -228,28 +228,89 @@ static inline int pmd_dirty(pmd_t pmd)
>    * of the lazy mode. So the implementation must assume preemption may be enabled
>    * and cpu migration is possible; it must take steps to be robust against this.
>    * (In practice, for user PTE updates, the appropriate page table lock(s) are
> - * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
> - * and the mode cannot be used in interrupt context.
> + * held, but for kernel PTE updates, no lock is held). The mode cannot be used
> + * in interrupt context.
> + *
> + * The lazy MMU mode is enabled for a given block of code using:
> + *
> + *   lazy_mmu_mode_enable();
> + *   <code>
> + *   lazy_mmu_mode_disable();
> + *
> + * Nesting is permitted: <code> may itself use an enable()/disable() pair.
> + * A nested call to enable() has no functional effect; however disable() causes
> + * any batched architectural state to be flushed regardless of nesting. After a
> + * call to disable(), the caller can therefore rely on all previous page table
> + * modifications to have taken effect, but the lazy MMU mode may still be
> + * enabled.
> + *
> + * In certain cases, it may be desirable to temporarily pause the lazy MMU mode.
> + * This can be done using:
> + *
> + *   lazy_mmu_mode_pause();
> + *   <code>
> + *   lazy_mmu_mode_resume();
> + *
> + * This sequence must only be used if the lazy MMU mode is already enabled.
> + * pause() ensures that the mode is exited regardless of the nesting level;
> + * resume() re-enters the mode at the same nesting level. <code> must not modify
> + * the lazy MMU state (i.e. it must not call any of the lazy_mmu_mode_*
> + * helpers).
> + *
> + * in_lazy_mmu_mode() can be used to check whether the lazy MMU mode is
> + * currently enabled.
>    */
>   #ifdef CONFIG_ARCH_LAZY_MMU
>   static inline void lazy_mmu_mode_enable(void)
>   {
> -	arch_enter_lazy_mmu_mode();
> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
> +
> +	VM_BUG_ON(state->count == U8_MAX);

No VM_BUG_ON() please.

> +	/* enable() must not be called while paused */
> +	VM_WARN_ON(state->count > 0 && !state->enabled);
> +
> +	if (state->count == 0) {
> +		arch_enter_lazy_mmu_mode();
> +		state->enabled = true;
> +	}
> +	++state->count;

Can do

if (state->count++ == 0) {

>   }
>   
>   static inline void lazy_mmu_mode_disable(void)
>   {
> -	arch_leave_lazy_mmu_mode();
> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
> +
> +	VM_BUG_ON(state->count == 0);

Dito.

> +	VM_WARN_ON(!state->enabled);
> +
> +	--state->count;
> +	if (state->count == 0) {

Can do

if (--state->count == 0) {

> +		state->enabled = false;
> +		arch_leave_lazy_mmu_mode();
> +	} else {
> +		/* Exiting a nested section */
> +		arch_flush_lazy_mmu_mode();
> +	}
>   }
>   
>   static inline void lazy_mmu_mode_pause(void)
>   {
> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
> +
> +	VM_WARN_ON(state->count == 0 || !state->enabled);
> +
> +	state->enabled = false;
>   	arch_leave_lazy_mmu_mode();
>   }
>   
>   static inline void lazy_mmu_mode_resume(void)
>   {
> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
> +
> +	VM_WARN_ON(state->count == 0 || state->enabled);
> +
>   	arch_enter_lazy_mmu_mode();
> +	state->enabled = true;
>   }
>   #else
>   static inline void lazy_mmu_mode_enable(void) {}
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index cbb7340c5866..2862d8bf2160 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1441,6 +1441,10 @@ struct task_struct {
>   
>   	struct page_frag		task_frag;
>   
> +#ifdef CONFIG_ARCH_LAZY_MMU
> +	struct lazy_mmu_state		lazy_mmu_state;
> +#endif
> +
>   #ifdef CONFIG_TASK_DELAY_ACCT
>   	struct task_delay_info		*delays;
>   #endif
> @@ -1724,6 +1728,18 @@ static inline char task_state_to_char(struct task_struct *tsk)
>   	return task_index_to_char(task_state_index(tsk));
>   }
>   
> +#ifdef CONFIG_ARCH_LAZY_MMU
> +static inline bool in_lazy_mmu_mode(void)

So these functions will reveal the actual arch state, not whether
_enabled() was called.

As I can see in later patches, in interrupt context they are also
return "not in lazy mmu mode".

-- 
Cheers

David / dhildenb


