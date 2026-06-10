Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 124CFCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28D426B008C; Wed, 10 Jun 2026 11:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2643C6B0092; Wed, 10 Jun 2026 11:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17AE36B0093; Wed, 10 Jun 2026 11:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 064626B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:02:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95D66140155
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:02:05 +0000 (UTC)
X-FDA: 84864318210.26.B662A9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9DD61100015
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:02:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bLp7gKfV;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781103723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vBNtytDEfxL/pz+YWvvBjkIv0STW5xtFZ5ArtldVzng=;
	b=BGyt1MKUNaycAzrzW4WB41XzVh0PB2pwCZitppVDGqGFGG2v1T7bAm7SaSYPJUVmp1cH16
	yk1n+vyJQFLX289Sxh3VCFk9byxO48T3ITTNPY+SBHYhls1frBrJETVjI8Jp9AMZsyBJZe
	pFDY80+/0ryC4PklJaQDaVqhyK7bIVI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781103723;
	b=Kn2Wq1gzofYC1leA2awsfEXKIUviBpAKPPkbbwyAT4VPZYnpl92OqxAacK0SvhfasssNi5
	69hiFDk05aSoYX3UPsIeP+1ZZnLQAoB56t7zum50TADgh6DEFX3ElGAdr0aIUbEB3yww1W
	s3pb2oiJdcmKgnd349GetzwVnKiuhJY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bLp7gKfV;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A88860172;
	Wed, 10 Jun 2026 15:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DBD1F00893;
	Wed, 10 Jun 2026 15:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781103722;
	bh=vBNtytDEfxL/pz+YWvvBjkIv0STW5xtFZ5ArtldVzng=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bLp7gKfVv/9idt34PBmdyss+uSKw2MKefryQrQaKGYAWWA+NaBBePteRGwjhZTf5D
	 56Mjj1k7nqRj3m6j999DvmlcY2YW/yRGz34KW67UpK9ml1Ved+Fx+AVqNeFDjhdqn6
	 nTTWZJSgJ8ffEQuZn5w2yUciiDNPvcTqvhv1e4AiKwtqdEBWwbbv9t3lJTenYuLYfX
	 NZD5uPEmEPBeTGslQ3YItaQ1YVezpSEj8Z9lpr3hhDhx6EsoaF5Zfvb/jqmWWr6jqv
	 woj3Vwb/dYXbBhm8tVzjrcyuZzQSU2YzUlKBrzg7EL0Iobu+0AVyZw5hSBXARpzIyc
	 yt+zhN82B1EeA==
Message-ID: <d05e51a6-428a-420e-b6ba-54f94d029f1e@kernel.org>
Date: Wed, 10 Jun 2026 17:01:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>
References: <20260606015729.1837935-1-surenb@google.com>
 <20260606015729.1837935-2-surenb@google.com> <aifO_rCurVhFRTcl@lucifer>
 <CAJuCfpFOpvNmV4aHnk3Vi0Jg4vF4Cmsm86h2vODZ84FVLXt9yw@mail.gmail.com>
 <aikLCwuzqBetvDrf@lucifer>
 <CAJuCfpHX5zoaD9XxDGbpXHs5U_8OrRyRuk=Nx8CjDb5qMNy0jA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpHX5zoaD9XxDGbpXHs5U_8OrRyRuk=Nx8CjDb5qMNy0jA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9DD61100015
X-Rspam-User: 
X-Stat-Signature: pkh9mw4cisghgx7u7omdb3hjos873zt5
X-Rspamd-Server: rspam08
X-HE-Tag: 1781103723-243604
X-HE-Meta: U2FsdGVkX186UlZ5oTCEnQmWPE7UrK6pQDgAvIksJ14wjPksJPDyPVluuTxj/ZI3GaPoYkEJbWN2KxA3peU3vx9eatcFNlveL0ohC73FDsaxiF6/NkObxdIbZ2adhF3a6msGuN+aJpqV5QOdOikxXK3YdlFnQgYuEQf8pisAuTxRF6oNCth0cLBeIWI5xo1akzf9Vp0TS3oH6zLdFjGHgRix7/SbruRsjaMVrvTL/BSvW9kNxEb0T+kuiPtOn+i3yJVm5YCa5aL/qmt0YUstO57lNwwBQKM00TXJU8mGy5O5PFh2nCKr+cKPUOF6rHHd97Jdu2ysV7XlFiv1vVZ34m5abMTRXrwCNEu5KOp0870JSS4506gULRajym4JKPiOytN8Zl/25FjBQPrN+IIdi9/2cDZhycG7tprsj6iOAbARtnciaELNDvxRaohibPrcqOPPHFTuH66EVOpe+6hfu6+l2xLa6+yc/9hf70b8VwSlqnkk+Gd/zsXfg8Bd6yeM1DySzWN0tvLRF0KbdY6FFh7Qru7UTdIvdCNIHQEpybFVWymBWHr1Il9MvIfHJEKySAOoWwBZ77VAIBcGC50pS0m3PLOpxF5n9hyk1OVt3xQ3zeozwWwRH4gm7jD4DxoF2XO76v8nfyOSRKx/ZB+okl35dd+k4WyaG8ibzHg/1+AdOI7GLNH4n5H74h0RampdqmTYRnTBhy+UExONPyMoVP46FwfAWNie/M1PvowwHkqSx8m6Wu0w3DUv74AcZnPRAWRR/4c8jqRLYrzZTafk+rnU9l1Z46lMWM12+JlSh3kGfnCa9lrTNChSVksJjBRs0yobtneKl0qBTNeWxeSDXe1NaqebrNtsfsrTDHPyj6iMHNhf/Gx8PfQR11PixB2HkZx5Qb1VqeIeMwERsh9SkcnvaGgpJBzf5NDbUD+kQ7DBzS+eBnwSydRA0eX67pb//4dH+FtiNpFNeFlGYnV
 wdGhwwlc
 MiszqZOOVRumPdHjsrTAnxeITTyASiqzQf+GwmvpEi7CFV2ev8pkkt/P11ae6IJ9KS/R2N768tPecFOzo2eNxeZANCr+3OdHAxvwbIoXHESwy9W1UY3MU0nQNn9512yjh90BYY1z76rW+b0l8YPqOOmQnLfeD3FU9WycIEQR5aTELx12t4KYCoQJKOCJ+9/c0NzdFN/yPennpge/t14r/x2vrEV07vdONJVTqBmTS6sPtQkpk0NHzd/e5TeTIJSOSY531wSmNQzdMFrkgrgAA5shVtwoBs4M2Av8eW858XdMyB92kCrs/YrECvi5u3JWIkY3mW2mb6kFUpqw65LlW9Jp/RTIW2ZYQoeT8DiCGkTfGNUQAU3W7RKgtyM03RTGycU8SlEKGc71VSMIpkJ47tgsyxcVQlLVvW/9H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 16:56, Suren Baghdasaryan wrote:
> On Wed, Jun 10, 2026 at 12:05 AM Lorenzo Stoakes <ljs@kernel.org> wrote:
>>
>> On Tue, Jun 09, 2026 at 10:11:03AM -0700, Suren Baghdasaryan wrote:
>>>
>>> Ack.
>>>
>>>
>>> Ack.
>>>
>>>
>>> Sadly, for now we do (see my later comment).
>>>
>>>
>>> It looked nicer I think :)
>>
>> Yeah tbh I think you're right
>>
>>>
>>>
>>> Ack.
>>>
>>>
>>> We need it to avoid resetting vma_start, which is being reported even
>>> when no normal VMAs are present.
>>
>> Well previously smap_gather_stats() would just be a no-op for a gate VMA, as it
>> has:
>>
>>         if (vma == get_gate_vma(priv->lock_ctx.mm))
>>                 return;
>>
>> Not sure if you'd have VMAs past that (is that even possible?) but in that case
>> we would have set vma_start previously.
> 
> I should explain this case in more detail. proc_get_vma() returns a
> gate VMA once it finds no more VMAs. So, in this case if VMA tree is
> empty, the first call to proc_get_vma() will return gate VMA. Now, the
> original code was using vma_next() and would return NULL when the VMA
> tree is empty and in that case it would bail out early here:
> https://elixir.bootlin.com/linux/v7.1-rc7/source/fs/proc/task_mmu.c#L1423.
> I need to use proc_get_vma() instead of vma_next() because it works
> under RCU. So, the new code matches the previous behavior, but the
> condition is different. I'll see if I can resolve this in a nicer way
> but that's the gist of it.

I guess some well-named helper that encapsulates the check would already help.
But maybe the whole logic can be overhauled.

-- 
Cheers,

David

