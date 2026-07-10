Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A3B9C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 19:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DF496B0005; Fri, 10 Jul 2026 15:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369E86B0088; Fri, 10 Jul 2026 15:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209FF6B008A; Fri, 10 Jul 2026 15:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E081B6B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:50:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E3D91C8A4E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:50:32 +0000 (UTC)
X-FDA: 84973909104.27.FDFF439
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf28.hostedemail.com (Postfix) with ESMTP id 97DB7C0009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:50:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GKQlBZKx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783713030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJ3Qr58WQkTtvB+lHQnXmYdDTqZWeRuKVOjEOb/7jpM=;
	b=eKZr8LFVimTxBnj6zs+B55R1S8lAQwgWg4IP43zG05p1kmooF+Y++z+b4vxcAl9CSmstcX
	6LsrHIV/E+7q7FFYPMQgbZVCvdi20EBNamk3F4gK6+RGRGrjqZj8EhhzoEhhWmhj79DySn
	bUg3NRTPrIwEasXWIj7za4smAFZyVJw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GKQlBZKx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783713030;
	b=yV6nvKlaqi6r6mVH3A3/kNunNTcBlKe9PW4JEIf29iiXgAjAFMHlB8fIT+0wfKKSfanOOE
	bIUqioXynRXbNGtYGHabW6QYg6M3OVn1cit5Gh9p/ujB6+pNYRU7ZY9rLR2pO17Rlz10Zc
	DlTNGRoJUtpEsgh7fb4l+gAMseI9+ok=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783713030; x=1815249030;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wstU32o1ukGNF/Xb2VDHeQ+rDnkS5bjwvJsCoMlMLLU=;
  b=GKQlBZKxw/CbXWtlcexUaHfirAjtn9PgMRuuETBAtv1gk74WSwHd/C6u
   t7C4+r0wObeQGI1EY9vraI/e95MldO9CpWJeY5ZmEGL6M9ewht8j2oaA2
   OrqhWaTXpfykTvWiOjPwtFM/6el48Hn/KcN177Z45cDXi/GzqqJFYJfNu
   +18iTooRMA8yndhlrvSnUKiQ3QwyquYGI/pXRX6se+Xc6s3a8VzIGNjoD
   KI8xPw6YNdq4mx2z9flcumBT50SNYr/4t7uVLtkBOm5ur+2UEMAxEbGoH
   j0EXlYBq19j5POthM+7ysdN3Tvwt5kWGX8Xfs5IOOoxJVxCNLtRPL8cmg
   Q==;
X-CSE-ConnectionGUID: xSB3fhkXTg2Y02Vl3Zq4ag==
X-CSE-MsgGUID: kBx3NBZsRW6KwfHZ/aGqew==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="101842536"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="101842536"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 12:50:28 -0700
X-CSE-ConnectionGUID: 5POQ9fgNQHacP2lc78bxaw==
X-CSE-MsgGUID: GFXUrvZlRjSSulHJ6FdmBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="255063240"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.111.199]) ([10.125.111.199])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 12:50:27 -0700
Message-ID: <f2af8fae-62b8-4c5a-8f8d-594b93912dc0@intel.com>
Date: Fri, 10 Jul 2026 12:50:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm/pat: acquire mmap lock on page table free to avoid
 ptdump UAF
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, David Carlier
 <devnexen@gmail.com>, Vlastimil Babka <vbabka@kernel.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, stable@vger.kernel.org
References: <20260710-fix-cpa-ptdump-race-v1-1-d898699a7417@kernel.org>
 <529e37eb-ad4c-4b0f-8ba3-c5608aa7a893@intel.com> <alE6fUJZzELlUfxP@lucifer>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <alE6fUJZzELlUfxP@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 97DB7C0009
X-Stat-Signature: hfi5nz8md6yo8wsncanap6mmosb5bpf6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783713029-593327
X-HE-Meta: U2FsdGVkX1/0lZYGZEtTM09lm3rJBBePvbJSd1ueVi9dNO7ek+ouPzb5J60b1hw+vcO9lUJmnJ1lClMNrw+b1dY99jXKleSyZOjFrqNrXXf7gonC1oMEJ/o2eBJ/r0/EB9CDZjIi8QaqLNh1+lNIvYZ4k0mwF81kZT5NJ/xJPhbN/H3QkKhKdIu8QdcjCwdshCG1UdfkyRZub+XCZn4SjoAZ8mAEzkFNmL5ple1s6V9UsFwHFqSNH/QzWFgHwwJldGmooE1jU4MfkghP92BBKiLMjcxqBDhXgzyaLtcfV874ygNQzhZzhtPUszzPIA/x0RP9B/eNJ1kSppnrrY9a1++iwXhC6Jw8b6zj59A0PeOXB5oHuJwh5C5m+B9oQSJoEMe1PlYkvx9HB7Uel2KhzAXZtdvssHRaG1+vBGaEb8gZVycWzmbMh2749DplvVTv0aop38gJoI61N4jXmln0daXUVqVJxzgCMw+8dKUrdvDHsJMHaobrBoTHAmlYz95UhL/qm6PU5fc7jMN/qs1i6orABqLV6JWwbj5y6s9Gr+nUOdobrf5LTgNNxkTbi1tOBpNr+Zb/PVVVdJvGk8bJbIbRjMHvegizBfjJfxjju1ckuE/ZcfVQ61Yn9p2U1XkgW8oa4L5ZkonXOQvupGdbsuQ/A/hFhnYxLZ3xaQL16Aa6ZXisgsZo3M/GOpStf31tOje5zrQ5Wa3+4F0m/ELuctkAjY0dxTg36hPlJUGcQNfGeazvXaK4AYxfnuCqgSDHLkFZXG2s0bNLXNGRRnWdR14T/eaB3oyEQ7Tkf/FPboyuwy/Y+pcfuCFXXzBIEiHc024+g45gCbOk7iFN8rpDKW5XAvO/UyKcJiwFtTlN1TKEPZKaaOs/dH1pPkVVeXG2LasgzxXlTusAHbV4Ofwdg2pBqnrlm9G0X5LjCvylTFD78KRawm0t3xL0wCem7B+QB971VGKrJFA+Rc8aXE0
 sOSDvKdI
 s6TeU59LMb5N/TxpymlCAZzuAKdoFxRWcfWjEx4J5loD3iLE6yX0WwUOkaV228IK23sk7hAS7JITfTixGLofkGixczPf9gzKGwvDkpsuvWOQwwyztjSr4q1xhlaz8ATV2xO/88FGmAeEC4clgzthI6OzLHv00vP7rd4BR7S2kRnfOF77V4B9tTOexC7/tPADRPulXrEx841dXU/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 11:53, Lorenzo Stoakes wrote:
> On Fri, Jul 10, 2026 at 09:26:48AM -0700, Dave Hansen wrote:
>> 1. We could just bite the bullet and have separate ptdump files for the
>>    top and bottom of the address space:
>> 	current_kernel_top
>> 	current_kernel_bottom
>> 	current_user_top
>> 	current_user_bottom
>> 	etc..
>>    Then the lock you take is dictated by the file.
> 
> I mean that'd break userspace though wouldn't it?

It's debugfs. So, yeah, I can see it breaking things, but it's also way
less of a concern. Nobody ever complained about the new PTI file getting
added in there.

>> 2. We could always take both init_mm and current->mm locks. That seems
>>    icky.
> 
> It's actually the least awful of all of these I think :) and the one I
> implemented ([0]).

Oh, cool, I missed that. That's a good pairing with this one!

>> 3. We could have ptdump_walk_pgd() take a different lock for each
>>    'range'. Logically:
>>
>> 	if (range->start < PAGE_OFFSET)
>> 		mmap_write_lock(mm);
>> 	else
>> 		mmap_write_lock(&init_mm);
> 
> I don't love this. It feels a hack for x86 that's put in the wrong place,
> i.e. core code.
> 
> And can you can make this assumption for efi_mm for all arches? Could other
> arches might be weird about this?

Yeah, it's possible they're weird. But I thought the whole idea of
efi_mm was to reuse the non-kernel part of the address space. So oddly
enough it kinda makes sense.

But, yeah, I totally get the reluctance to do this.

>> I'm kinda leaning toward #3.
> 
> Another way forwards might be simply have the caller _call
> ptdump_walk_pgd() twice_ once with the range set to [0, PAGE_OFFSET) passing whatever mm
> != init_mm, and again for [PAGE_OFFSET, ~0) passing init_mm?

Ahh, yeah, that's a good point. It could be done a layer up too.

> Are there cases where you expect to see a delta in the kernel range in x86
> for an arbitrary mm?

Are you asking if current->mm->pgd[255->511] is always the same as
init_mm->pgd[255->511]?

I think so, except for the LDT PGD when PTI is on. That can be different
between mms, and it's a single pgd_t entry. I think Brendan had some
grand plans to use this PGD for other things for ASI as well.

So, yeah, the upper half of the address space is *normally* identical.
But PTI plus set_ldt() is abnormal and we have to deal with it. The only
times that code frees page tables is at exit time and in an error path.

So, how does this interact with mmap_lock? Surely, someone looked at
this recently because the comment says:

 * Lock order:
 *      context.ldt_usr_sem
 *        mmap_lock
 *          context.lock

and not mmap_sem. But, alas, I don't see any mmap_lock anywhere. Someone
changed the comment and didn't look at the code.

Is there some mmap_lock interaction that I'm missing? I don't see it
_anywhere_ in the ldt code.

