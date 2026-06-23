Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D009DCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6563F6B0093; Mon, 22 Jun 2026 20:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62D956B0095; Mon, 22 Jun 2026 20:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5453C6B0096; Mon, 22 Jun 2026 20:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 286E96B0093
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:16:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CA76C1994
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:16:39 +0000 (UTC)
X-FDA: 84909261318.03.90130A2
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf25.hostedemail.com (Postfix) with ESMTP id 63B4BA0005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:16:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ica8PoBm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782173797;
	b=KebccEY45B1AGK4x36YHyeifm1T/1xEdz8CzmNcPnZKaNcjYMQt2zZnUaHtKfV+esyPtiR
	UUBvfE+pOVKniunktzN8+wT6CXjgXj36CL2l34fZe5Ql3l4YbJxz5ujx1ySf4ZgiVe7EjZ
	AKYUEwXjdlaAdzwkDxHErzngpR1CrUs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782173797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQ/tN8LPB9pbsNYKwXHKXdDuCRbHVz4A0BWR4CadjWs=;
	b=F9qWwsnKCghU58yb6IMZUUR0KeyzEPNlomA0xWgriBmHLVkWd7va71KDP3LFNwGha09D6W
	N5eA+cOMu7TZK3T+zw6w33mo5BJuFmHx9sGn7GrYSIg6ZVQGROqZNGT+nuD95BhjdUMKUd
	X0hXICQjxY+XY9Qgl2aocfncxp1VPPg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ica8PoBm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
Message-ID: <407fc549-1363-4b22-b6aa-b85283873433@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782173795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qQ/tN8LPB9pbsNYKwXHKXdDuCRbHVz4A0BWR4CadjWs=;
	b=ica8PoBmlvFDqhLY70+zIqEUwaYq/9kKUcVfUDNxWB09L92DemTjVMJ0rHXgj829Y1NjsO
	5cFVokuTTuxBahVAoa3o7pjhmaPnT4HnqwxUWLOJbF0GDL2fX9WdUJVmdSaKHasrgzxUOV
	aUuEWZr3c8n4kTnCJFV10GC6YIPUNYU=
Date: Mon, 22 Jun 2026 17:16:26 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] mm/bpf_memcontrol: mark BPF memcg kfuncs static
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20260617202147.78347-1-jp.kobryn@linux.dev>
 <CAADnVQJ=q7hJkt=ekLD_a5KjJ_+icdwgsY61rujjLMKAKByvWw@mail.gmail.com>
 <7ia4cxxosss5.fsf@castle.c.googlers.com>
 <DJDK2NVO8903.19LWKQ3ST3U89@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: JP Kobryn <jp.kobryn@linux.dev>
In-Reply-To: <DJDK2NVO8903.19LWKQ3ST3U89@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 63B4BA0005
X-Stat-Signature: q1fc6iejs31na47emze9c51rurzoa6c4
X-HE-Tag: 1782173797-276107
X-HE-Meta: U2FsdGVkX1/XxAOht/ttiyHH3pk2udvkMhplh5G6Ej/ZCzDJJ0xzrolzSlBLFEPGtd0jvOi+HsEmxZmbki7yZZ0NEvTR0l3J+kSCBaXKX5jkPUUJKJ2wFky5PVHGW0MLGUd7J4KAyouIB8GCvBoBgIYY56w4XTN1XTGpBBLEt4a9MBN1tFw/9Z+sQohIXipHRldRvUpN6zGn5mryjF+Smm9JlRtJhO1UIaX4tNPxuzjaQ9rUAAVr2xzBHk0PJG8bsZl7qygWQY6mAxDOGVJ5fzmXmnjgn3sHbmh0iBFiUj6/e3tXGdbVfHe+veW6M4e+ZqtD67fvk0CeGalGaQ5epb8Yk3slCx+ssmIg0HaVnjeW5AKBzvytDE4nNdfaDM14KvT6s8oWfo1wKcWFJAG0ccHA9Ykb/m2KXKU5h9LGuuXclZ7q13G+9iGHEtLoM/cukvKZJRXQU0G30rwxiGmhvJv1Gu0wCI5oDhic8dz9uU21bF7szeIixXJ/f3T35HtIm0O/qrfknBhcN11P23lfAn4Zc1gR7aBt1sj9qnphQXalTFF3PEW+F6fZpLZW4d7m4iCodVRqAsy11ewO04s/LQ6gzNSw/Tm6+6sxJek/DUf9c2TFAg6c6dt6VX7cbyVH3hkcgJRNvzGT058uSA85xy0jPodwv3FPvBWf7/gkiJG4ZC+WCcxkat3pegZjQvJTLwiZILyRbxG7uEyhfm9CpC/EbzIzfqMm63WaK5y3tNnMKBE/F9DkCejVNgy5ENC8n5Tzikkepk7InzSE7LyxJpdYcAAV33hf2eamAeRH430zBw115jgVDvzcyerCHXUfXvsM3fIoDyMiyNaeJ0H5PbYfOoxSd+sNzBtCXmwqJZSCKL58x3+Cr9oB9rvRAYqG+icfCQxgMwZ0X56PemmCDT22vTYulELpQV20IyeY4c+Nj2QLluJVesBPF/G7UigQyjcG6qZvFPN2oSsKFbG
 or6/Ge0F
 q1kIoh1HOdOS60X/cI3zpdQEYe7UiijkQEkRVTZwHeejOw5c/5P8EcZ5NOngACqBZ2aW2OYSG1QwHEK/R22HlTW+M7XUOqz8hxcPGvHcoIxCrSBN0a5xfuP1sFrLqjiNZ1bmHlKO9d24J1JOel4MdMC/jMzApLeBFfiISOzrAeUpD5t6Esz/VgbjU/IiC2R66ReZH7H8eiBkHuvFzi4Mt0CLSdgwzdFsro3rTQ+Q0Sma3IWX3JCNROZRW9zO2sPNe+ErigDobvrzHYJmmzIzzAtiXZAnMhiNzr8u1kgrW9YByRHA6Jew8tnC0m8hXgFK/C6fD82xkM85T7+6nBdqkvbnD9BywfkFipU8YtV4R0sTWBh393/bmqg8qRkb2gDBr6EEKuwx3qkSt3bBoSo47nSowFaQ/TrStj+vS3Qd8s1/0uRA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/26 8:27 PM, Alexei Starovoitov wrote:
> On Wed Jun 17, 2026 at 3:31 PM PDT, Roman Gushchin wrote:
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>>> On Wed, Jun 17, 2026 at 1:22 PM JP Kobryn <jp.kobryn@linux.dev> wrote:
>>>>
>>>> The kfuncs in bpf_memcontrol.c are not called by in-kernel C code. They are
>>>> only referenced by BPF programs and resolved through BTF.
>>>>
>>>> Since no external linkage is needed, mark these functions static.
>>>>
>>>> Fixes: 5904db9891f8 ("mm: introduce BPF kfuncs to deal with memcg pointers")
>>>> Fixes: 5c7db3239c9f ("mm: introduce bpf_get_root_mem_cgroup() BPF kfunc")
>>>> Fixes: 99430ab8b804 ("mm: introduce BPF kfuncs to access memcg statistics and events")
>>>> Reported-by: kernel test robot <lkp@intel.com>
>>>> Closes: https://lore.kernel.org/oe-kbuild-all/202606150332.Xy4Egd9s-lkp@intel.com/
>>>> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
>>>> ---
>>>>  mm/bpf_memcontrol.c | 21 +++++++++++----------
>>>>  1 file changed, 11 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>>>> index 716df49d7647..eff79bb2c758 100644
>>>> --- a/mm/bpf_memcontrol.c
>>>> +++ b/mm/bpf_memcontrol.c
>>>> @@ -20,7 +20,7 @@ __bpf_kfunc_start_defs();
>>>>   *
>>>>   * Return: A pointer to the root memory cgroup.
>>>>   */
>>>> -__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
>>>> +__bpf_kfunc static struct mem_cgroup *bpf_get_root_mem_cgroup(void)
>>>
>>> sashiko disappoints. It couldn't notice that kfuncs should not be static.
>>> We have few "__bpf_kfunc static" in net/ipv4/
>>> that work by sort-of "luck", since their addresses are taken.
>>>
>>> In general kfuncs cannot be declared static.
>>
>> It seems like it thought hard on it but failed based on the existing
>> code and a bit vague documentation in Documentation/bpf/kfuncs.rst:
>>
>>   kfunc definitions should also always be annotated with the ``__bpf_kfunc``
>>   macro. This prevents issues such as the compiler inlining the kfunc if it's a
>>   static kernel function, or the function ...
>>
>> So it reads like bpf kfuncs can be static.
>>
>> This is the reasoning from the logs (a dismissed concern, to be precise):
>> {
>>       "type": "Dead Code / Linker Error",
>>
>>       "description": "Marking kfuncs as static could cause the compiler
>>       to optimize them away, breaking BPF verifier BTF resolution.",
>>
>>       "reasoning": "The patch adds `static` to multiple `__bpf_kfunc`
>>       annotated functions that are not called anywhere in C
>>       code. Normally, a compiler would remove unused static functions or
>>       fail to expose them in object files, which could prevent the BTF
>>       ID generation logic (`resolve_btfids`) from finding them. However,
>>       the `__bpf_kfunc` macro expands to include `__used` and
>>       `__retain`, which strictly instructs the compiler and linker to
>>       preserve the functions in the object file regardless of
>>       usage. Additionally, `resolve_btfids` and `BTF_ID_FLAGS`
>>       successfully parse and resolve `STB_LOCAL` static symbols, making
>>       this change completely safe and correct.",
> 
> Almost, except it's not clear what takes priority for the compiler.
> __bpf_kfunc used to have '__used' and it was enough until clang
> got too aggressive in LTO mode. So we added '__retain' and so far
> it seems to be holding, but sashiko is missing that both of these
> attributes don't say anything about _name_ of the function.
> 'static' keyword means that compiler is free to rename it and
> compilers do take advantage of that from time to time,
> while __used and __retain don't add 'do-not-rename' restriction
> to the compiler.
> 
> Also look at it from the other angle.. why anyone would add
> 'static' when the function is clearly not static to this particular
> compilation unit. It will be used outside of it by bpf progs
> that are obviuosly not part of this .c file.
> 
> Documentation/bpf/kfuncs.rst needs to be updated.
> 
> JP,
> pls send a patch to update the docs and include few words
> to ignore sparse.
> 

Sounds good. I'll get that out this week.

