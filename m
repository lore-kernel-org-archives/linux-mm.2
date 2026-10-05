Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E13CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 10:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D4AB6B008C; Mon,  5 Oct 2026 06:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5845E6B0092; Mon,  5 Oct 2026 06:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 473B46B0093; Mon,  5 Oct 2026 06:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29ABD6B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:13:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B61E81C1818
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:13:10 +0000 (UTC)
X-FDA: 85288159740.08.4583DFB
Received: from mta0.migadu.com (out-164.mta0.migadu.com [91.218.175.164])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8E2C21A0009
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:13:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=apu97VKc;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791195188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBqvA15GisF4LHjA8W2t6sF9uStIhzLskQ6rjcIEa/Q=;
	b=aY0PB+WGet1lAuRJGuI/aJIm8/9D08i2t5NFjgvvscWyrzSiXTUyXXfUw5ZQlZaXkuSqeU
	+sMK9oyBVQSi836/K5039YuQT552tuZ88DG97/+fTbJbOvcCKfjGycCOzcyS8jhJ3FEG5j
	Epi61lKEbvRF+Zf6/pArh+SBLOboliw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=apu97VKc;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.164 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791195188;
	b=I3Abqt3Y9LeHKOVuaDgAiSX1St77d3iLHG8SKvvsWVOQi1xIXs9IFNKspUx3J83h8xLXON
	yp3OmHu3ivgzCV0a7lD/NxY0fyAL80D+PpsknIqHU7kHdhDMsg7M7jN6Hc+iYZrnRU8/mI
	A2IZ/RbLUqhYiawH4ZN6OxwLgRNtT9I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EEjZqFY3s2FS+GoGeqCsbWhVvDm5TQFLGZuK1OsTwm8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791195187; v=1; x=1791799987;
 b=apu97VKc4yfs5pb6xyfFQoSHyABTaaeZSNBcVzNSiJnltv0jdAIDMCBGtC8/IcyJ/zJ7ilTG
 m/35yBKt7i6vI8Z3tF6FuYyP6Dm1fzD35ZNMiW816GYQ/aFYRSZqPvD+iQ6MVUeCiOMNxT/nsOY
 PqFPw8Jyh3rF0RP3m3cF4UlY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 73aaa0ae9db79217;
	Mon, 05 Oct 2026 10:12:57 +0000
X-Mizu-Trace-ID: 73aaa0ae9db79217
X-Migadu-Flow: FLOW_OUT
Message-ID: <6801221a-6307-407a-85fc-46906f95d22e@linux.dev>
Date: Mon, 5 Oct 2026 18:12:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
Content-Language: en-US
To: Andrew Cooper <andrew.cooper3@citrix.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, riel@surriel.com, linux-kernel@vger.kernel.org,
 qi.zheng@linux.dev, nadav.amit@gmail.com, thomas.lendacky@amd.com,
 kernel-team@meta.com, linux-mm@kvack.org, akpm@linux-foundation.org,
 brendan.jackman@linux.dev, jannh@google.com, mhklinux@outlook.com,
 Manali.Shukla@amd.com, mingo@kernel.org, stable@vger.kernel.org,
 toshi.kani@hpe.com, david@kernel.org, mikhail.v.gavrilov@gmail.com
References: <20261005052302.43042-1-lance.yang@linux.dev>
 <asM7b8ECO34-jiwi@pedro-suse.tail5790ac.ts.net>
 <60d5db86-8002-4d87-b8d3-c161d674122b@linux.dev>
 <ab077b6a-160f-41a2-a167-813f0560e30d@citrix.com>
 <38541ec6-d796-4f35-a700-75ab097b6df5@linux.dev>
 <7ad90e94-d04d-453a-ba22-9640a5024d8c@citrix.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <7ad90e94-d04d-453a-ba22-9640a5024d8c@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8E2C21A0009
X-Rspam-User: 
X-Stat-Signature: uwufaypfcusyd3gy1eehyt1tg3so6kej
X-HE-Tag: 1791195188-74919
X-HE-Meta: U2FsdGVkX1/JpmzBSK6PZgzbjAJR1FqWVDP2tI7kNtZezmtIrCWFCkEVTsexq5Q6aIaP2K2uKOi4jxJ4yjG1jl78qCRf0F5H2CT5tNZLV6+ZArNHMVaV0SaUzjKCIMVl1L/JJWSSjsH6jO75l8NVMD3Jx8myQzJDqKaM7DbwKoabQn+uUwFRkTThQMYpkNRNbYwlN/OpUtFhvLVfB7daZwO3JRSybB8qtgDNY014J1x316O/0fvMtfvIeUl5EvwrgdF3Soo6R2DcqX/Yd4+Qvlfn0DlKeh0aOFQdfAp/9ba4C4+FvTIx6TYUcVqv0WB+ZkqCZwTneFOlY5hhUqaPh+d7RJTkBZvr05Q6ayCO63c2QbDlLVtKLofkKT7JnGZPsvcO9G01xqNfSjSoFbxL41C7C9eXzXNEiWdZzuJQmn3Z26ZQShEYbgH0tmuw6faFuklKK1RYYb1h+B3YXPfKzfm44SsMGhi3eELVcKFqdGBV9BT1B9OogDSTjqMdCE+cAkVhSwtVELIWVyAvKWvdvdk8dIF2APnul5Cn6UrXh3HJNelhFhPmZGFbNRPT4c6xGrRLDqtA1f52NxtHJew7rkD2i1gDrrIo8iSx0QbL1xjrpEFwQNmoJAKT0uSEY+8en/70UVeeBOXF4LNbinkvCA+lfe8gVwD5b2hpRvRObuLeLkpJRufUo4NQ5WGr1MaL0QBGq6z59lOSDu2Jht+/9WrvmzHeulX1dAOXL4N99TSnlLEjjqzZ5RO2qHQvHH88HhtPZmthpZABwHEAjQ5+PcGWTEpAoXJog1EL/rQv08l7byaxZRXawTp+y2aAiQMnwtuQEsL3tRe38Ls0cJACH7UPtiTlgTUDnuogrpewl/yMXENMSX8lEjMkiOZ6i7DTXcqdhJYhKYQ6qQV27NjanYBoGfbnwxND90NMF4gYp+g48ms+c/qH31tCTNBtEL28Mz4rgcy7TdxWlLOMZzb
 aTXzTqG2
 nbDrLLRsWLN7QD2yO5BrkTGCmC/yCrero/EmFO+97278iLkMh+myO/em3B4S3KQg8Ojfahzbfgd7JOOCdLvXXfFlOwQsjbJScfCbQ1z8yvhgG8OZVniHe57ofPfVo7XCN63QulzLg/mRL1bsvKW+mN3UOvuZPnExsKM3rDEQbWbSVjjm9+lUctHkkkHM/jFsl5JQA4yCH6tbXxQKJ1MgUk80v+6zsvidoTZMhtOyp1OQGKE2bajVofwN5ITI2WskOYpd++5O5eGZPTfqb5+dBPW1QqNKPwKzPTlfLvvkUpkZWRRMkc46LKLI6tNq4kcNwoYdroqqkI2JCpxAogKODQS9hYiRvsJ1rKdrPgVgQZA3o1sNVnA8s/XxpB/9E07ubyxdjtSV42gXHQU7zakjvm1IBUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/5 17:57, Andrew Cooper wrote:
> On 05/10/2026 9:32 am, Lance Yang wrote:
>>
>>
>> On 2026/10/5 16:19, Andrew Cooper wrote:
>>> On 05/10/2026 8:29 am, Lance Yang wrote:
>>>>>
>>>>> Did you repro any bug related to this? The functionality is perhaps
>>>>> underspecified in the AMD manual.
>>>>
>>>> TBH, I don't have a reproducer yet. Just LLM stumbled upon this while
>>>> I was investigating another memory corruption issue [1].
>>>>
>>>> [1]
>>>> https://lore.kernel.org/linux-mm/arY1Wq6R9OY20ans@pcnci.linuxbox.cz/#t
>>>
>>> What hardware are you running on?
>>>
>>> That looks like the Zen5 issue, for which you want either the latest
>>> microcode out of linux-firmware and/or
>>> https://lore.kernel.org/r/20261002211617.1001617-1-bp@kernel.org
>>>
>>> TCE is a no-op in Zen1 and later, so unless you're on older hardware, it
>>> won't be that.
>>
>> Just to clarify ... these are two separate issues.
>>
>> I mentioned [1] only to explain how this came up while investigating
>> something else. I'm not claiming that TCE caused the corruption reported
>> there :)
> 
> Please can you answer the question.  Which CPU are you seeing this on?
> 

Which CPU? None so far. As I said, I don't have a reproducer. I'm trying
to make sense of what the manual says and what the code does ...

