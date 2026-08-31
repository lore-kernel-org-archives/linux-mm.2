Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12CAFC624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40676B0095; Mon, 31 Aug 2026 03:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F172E6B0096; Mon, 31 Aug 2026 03:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E55076B0098; Mon, 31 Aug 2026 03:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB8EC6B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:37:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4603214021C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:37:32 +0000 (UTC)
X-FDA: 85160759544.06.B41CB29
Received: from mta1.migadu.com (out-149.mta1.migadu.com [95.215.58.149])
	by imf08.hostedemail.com (Postfix) with ESMTP id 00949160006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:37:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NWoX0q+8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.149 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788161850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5M2u63ig7FDcjrVEpnxu5v0TgflgKxSRx00T+aHdaAo=;
	b=gtBoQD6qj3zK7sRmNDJVe8lASa5js5IVyhiVR6cVacMs88pvQQ9VOmpMTTo9FTdR0+P4tV
	JcrE1ZJbaUW3jM/sFhDFSSwEab1HJE8cahuaAhRwo77iJJN0cZ/HrXEp6NXPwXVKYMqtZS
	UG+bWCxOzYfiZj1/JD1cshj7gRkniFc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788161850;
	b=zAUnL6sINthUXpsAvCmKv2ndteOY3cHIxSOAEVCcj2z4tRuub0UBDeb2gLPFDTPDJO3N+x
	Bu6TvXVxLJwVXATngCKupf1OFwrQdz8dk4cgXGlXnaZHVuq3+0qRVW4LHnAFqFe/H5JUm6
	2UT4NldOUBmcMhRIy+Ks0YCuD4VVwc0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NWoX0q+8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.149 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uxdKX20I9JQ/4ZC9HWtiJ9xgZdL6bJ5oz1EYtGytCcE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788161848; v=1; x=1788766648;
 b=NWoX0q+8y6x9sv2pt0nThFKzZM5elNJ4wVzcasiOO1US4c1DLhMAlS2nHjbPDLU6rGoDhFP0
 zIf242wtC2iV9CVJ0OHWzpN+btqOfbnO0SWX1r1O7CU9JkL7soQGXDWWZs5iwTW+tTIqpF7fFWU
 3UYpJcnR4U4/WNNridwn+vwU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id df6850f57dc2e572;
	Mon, 31 Aug 2026 07:37:28 +0000
X-Mizu-Trace-ID: df6850f57dc2e572
X-Migadu-Flow: FLOW_OUT
Message-ID: <556a5f2e-7ce1-4045-b935-9ba877254cd2@linux.dev>
Date: Mon, 31 Aug 2026 15:38:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] alloc_tag: fix undetected compressed tag overflow
 when profiling is disabled
To: Petr Pavlu <petr.pavlu@suse.com>, Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260812054105.102637-1-hao.ge@linux.dev>
 <20260812054105.102637-3-hao.ge@linux.dev>
 <CAJuCfpFvdNFdsKdK2CdF2fNp8gbNgFpoeAiaqp70mpbNGCvk3g@mail.gmail.com>
 <143a37b5-93a2-4038-8be9-29e13263e743@suse.com>
 <CAJuCfpF1pWqhc+P9zPg8FT_CcdQxRuEpJ2DtYja1BeMXhW7-8Q@mail.gmail.com>
 <499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <499bb60c-c6e3-43a3-bd92-95a0567ece5e@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 00949160006
X-Stat-Signature: 3s1n6e6nf4fxt74b8f63ajqfs58t8kdx
X-Rspam-User: 
X-HE-Tag: 1788161849-294646
X-HE-Meta: U2FsdGVkX19yNzWyQqywjpDLTvdZxSEvF1L0XgiLf4OmSEdxGGgHlrXC6MUYf+RjY81jSgOxf2NtoNZ894AlwYov5niMb/QMjhVIumKgjQDJZ9xAvqUDd/u5gr0rGP0r1eiR9NwnYDGho8QxTodLmetJWCAS+rU73kuqA9z8DyezGRyyhUhCn4yToL0DmdP/17Cqju4NE4NwTYTasV9gzXerqbKma9lpqkqP0i9D4nzcQ3Ren+3htKvtgn29DrzD2eCfr7u9B/Vppg6K+PhsdfczJ2tMPkdVqqo54R5Gmx0VaDldl2u5jdFYk/P5EfX5qySqVWOMAU8Hq8AAw24XGelSihKv91YrSV3b/6ZWoEIoi4aZeI2xcbaP0Ft2oMSWEdzP6HCZPg0TwlSvev0d5zy7zYK/5SbKQExcmkhY2/y8fUQ9wwTtSG0fizRu0FWMJEgNrSsXt9aFikX23RxfjaDNOx6XiIL3+m4Dz5g9pyjn/1528P9odF4iOpG0+IGeZ/nlTdLIl/K5q3fjXlfYZa5wq2aaVTSe+tPckIkDWnoK85GJvvsyPN48xrPDJfYoeE4dJu2GsJMXl7sRJlvY15vAjqb2jRPZsCCeKIRSgTls73lf/6GlgE+CZra8hBKi9hB2VOkR60MVo24DvpCHsSMqStrlHCGrjeh1qaghDWmB8EHT2a5uipUY6klzB2AkZTni0hURoAxfrWn9EOKRTngR2Ht4MqDK+q/kQPTTHLf3Xx2UvHQiB49KprsFHhqXeHmtskrcuQMWszGkT+YSjGRMOEOdnkOe1QqC03WFXesb8ZUx9ocD+jomvUIdPQV+/KthxIaZTmWqo2blwuAyt/n5ykWZtgBLofp6wgoxPNye6ZwUdySV0XBXWUp8JyKehq4oEzlRwBZijcmsrbTL3aJgJ6lyeIEVC8qhzbk0dSeP1uWGi8z9t/GLt3AYLkXnvDxglA3PP723mhKKFmN
 YEXLZQA4
 FJqkM+SGayBWHrLkcOMxFYl8TsP4IBaiLBqDQA93ri9rYOGKW7fDKwayZ4SBQkTbAM2QsDgD4aFY1t4BhoiKTLljeUqkGy7LPgxW5/yzk67/aVxurrnlG63dJqB26gY0grtO+9Epk4vSZ1qeL7sn/GnuQVuIV6qMH9vawkeq/8mGZnc+nBuTPuinGJVDKjAvO0mU0lUq/1n8LTXpSOiEvL2ZxOD0yBUKj+7NLS5pG/lWUg37NwiH5D9COCHgDap6LNT3RH70To7XYae+aiPDPS3cIjoBoCieNbNPODCR+xu2ATFU0N2ASNaTjW46zqYnKfLDe2FMrqlDqXKuGYZjrnbpKHZ21lMRKrklmSpIdstiFQhPdGZFjFb4PHMvKXRja9e8iIX3VF+wadXgq5oDt3qrZx4bDGNjoNT/IaAurhfvh22w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Petr

On 2026/8/26 16:32, Petr Pavlu wrote:
> On 8/16/26 5:16 PM, Suren Baghdasaryan wrote:
>> On Sat, Aug 15, 2026 at 3:45 AM Petr Pavlu <petr.pavlu@suse.com> wrote:
>>> On 8/12/26 7:41 AM, Hao Ge wrote:
>>>> In reserve_module_tags(), the tag overflow check is gated on
>>>> mem_alloc_profiling_enabled():
>>>>
>>>>     if (mem_alloc_profiling_enabled() && !tags_addressable())
>>>>
>>>> If profiling is toggled off at runtime and a module is loaded whose
>>>> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
>>>> skipped. vm_module_tags_populate() still maps memory for the tags and
>>>> the module loads successfully, but the total tag count now exceeds what
>>>> NR_UNUSED_PAGEFLAG_BITS can address.
>>>>
>>>> Once profiling is re-enabled, ref_to_idx() computes each tag's index
>>>> as its position in the alloc_tag array. update_page_tag_ref() masks
>>>> it to alloc_tag_ref_mask before storing in page->flags. Indices
>>>> beyond the mask are truncated and idx_to_ref() resolves them to wrong
>>>> tags.
>>>>
>>>> This silently corrupts /proc/allocinfo: allocated pages get attributed
>>>> to the wrong call sites, so the statistics it reports are wrong.
>>>>
>>>> mem_alloc_profiling_enabled() and mem_profiling_compressed are
>>>> independent. Once compressed mode is established at boot, it stays
>>>> active regardless of runtime toggles of mem_profiling.
>>>>
>>>> Remove the mem_alloc_profiling_enabled() guard. On overflow, shut down
>>>> profiling, release the reservation, and return -EAGAIN so that
>>>> layout_and_allocate() retries with profiling disabled: codetag sections
>>>> are then placed as regular module data and the module loads without
>>>> profiling rather than being rejected entirely.
>>>
>>> When the described overflow occurs, why should codetag sections be
>>> placed as regular module data? Will the codetag support use them in any
>>> way, or do they simply waste space? Is the issue that alloc_hooks()
>>> creates relocations pointing into .codetag.alloc_tags?
>>
>> Correct, alloc_hooks() will have references into .codetag.alloc_tags.
>> With mem_profiling_support=false they should technically never be used
>> but I don't think it's a good idea to skip .codetag.alloc_tags section
>> allocation and to leave dangling pointers. Also the case described
>> here is an outlier, so optimizing it would not yield much benefit.
>>
> [...]
>>> I'm not sure this is the best approach. It's complex logic for what
>>> appears to be an edge case related to a debugging facility. It will have
>>> the usual problem of error paths not getting enough testing and breaking
>>> subtly over time.
>>>
>>> An alternative could be to reset SHF_ALLOC on the codetag section to
>>> remove it from further processing and have relocations that point to
>>> this section resolve to something else. It seems that alloc_hooks_tag()
>>> could tolerate this, since it only needs to reference the associated
>>> alloc_tag when mem_alloc_profiling_enabled() is true and that gets
>>> disabled by reserve_module_tags() on the overflow.
>>
>> Hmm, yeah if we redirect the references into .codetag.alloc_tags, that
>> would be much better.
>>
>>>
>>> It is also not an ideal approach, but I feel it could be less intrusive
>>> to the module loader. I can put together a prototype if needed.
>>
>> If your approach does not cause module loading to fail when we disable
>> profiling, then that sounds like a good idea. If it's not too much
>> trouble, could you please send an RFC?
> 
> The alternative approach I mentioned unfortunately doesn't work well,
> since redirecting all relocations against .codetag.alloc_tag to
> a different destination is nontrivial. It would require introducing
> something like frob_relocation() that is called from each
> architecture-specific apply_relocate()/apply_relocate_add() after the
> addend has been decoded.
> 
> Another option I realized is to change the order in which module
> sections are allocated. Rather than interleaving the allocation of
> codetag and regular sections, the module loader could first try to
> allocate codetag sections and then allocate regular sections. If
> allocation of a codetag section fails, it can naturally fall back to
> being treated as a regular section. This avoids retrying the allocation
> process, which I would prefer to avoid.
> 
> A prototype is below.
> 

Thanks a lot for your prototype. I have reworked it with some changes,
and here is the link to the patch:
https://lore.kernel.org/all/20260831072104.120197-3-hao.ge@linux.dev/
The differences against your version are listed in the patch.

I originally planned to put you as the patch author, yet I was
concerned my modifications on top of your prototype might not be
clean due to missed corner cases. I therefore added the
Based-on-a-patch-by: trailer. I realise this might not be perfect
given that most of the credit is yours, and this is my first‑time
dealing with this scenario. This is also one motivation for sending
it as RFC. Feel free to tell me if this attribution is incorrect,
I will fix it in the final release.

Thanks
Best Regards
Hao


