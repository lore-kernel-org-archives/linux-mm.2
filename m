Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C67EE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 05:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D2A6B0088; Wed, 18 Feb 2026 00:01:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CAC26B0089; Wed, 18 Feb 2026 00:01:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5010D6B008A; Wed, 18 Feb 2026 00:01:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D00F6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:01:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D716C1C0FD
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:01:27 +0000 (UTC)
X-FDA: 84456379014.19.7CF80B3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 10EA2A000B
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:01:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771390886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAc7E88ZRIexOprEQGnU4vc+b5ht/HkO2tQN2NKpBG4=;
	b=05fEKqM5pKAykzHRWyr3uVLoZ0cNwuSqrw9m9zGJVy1mU08GUUPB198/5OX66cOMhrdLOL
	YHZ5tvwe9M7XZHboGBjZmoRugxxEZkcbVVpYZ4CKXc55mzJ/DK/1XR1mImBDvi4Q3dRtuz
	KB531cOTD2/DBBlWRC+fUqukqO+eOkQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771390886; a=rsa-sha256;
	cv=none;
	b=0GQ8edb9qHEmXiX2KUxrEIkiUVcUAYGYvaflntn1HeD9BB6sgSPB7kP7Tcv7AzsZBHFo9j
	bJjGwMo1UBGkuuIjUkHkdwncEfVLQaLRNisjBz3KEuYac0n/DHxvF9DtbUCCI5q2gY51b7
	cze1AViwBGLrB3+/0VTHEGX+bPw23OQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03E791477;
	Tue, 17 Feb 2026 21:01:19 -0800 (PST)
Received: from [10.164.19.71] (unknown [10.164.19.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B8DB3F7F5;
	Tue, 17 Feb 2026 21:01:22 -0800 (PST)
Message-ID: <8315cbde-389c-40c5-ac72-92074625489a@arm.com>
Date: Wed, 18 Feb 2026 10:31:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions since
 PTE batching (cac1db8c3aad)
To: Pedro Falcato <pfalcato@suse.de>, Luke Yang <luyang@redhat.com>
Cc: david@kernel.org, surenb@google.com, jhladky@redhat.com,
 akpm@linux-foundation.org, Liam.Howlett@oracle.com, willy@infradead.org,
 vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
 <c450ee86-4c34-449d-b144-6b4dcb996998@kernel.org>
 <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
 <CAJuCfpHJyHH4=kcQcc_RUPhmLBN8HckoDW0DHiUe+FdQ+tr2NA@mail.gmail.com>
 <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
 <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
 <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
 <nfrvygkft42c35ymgupwggrc2hrbatxaa6cn3hjxffrvhaprqg@wjg4ye4uv5go>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <nfrvygkft42c35ymgupwggrc2hrbatxaa6cn3hjxffrvhaprqg@wjg4ye4uv5go>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 10EA2A000B
X-Rspamd-Server: rspam02
X-Stat-Signature: kjug9f1ke7o3i639ptao6oo1drk7jnti
X-HE-Tag: 1771390885-519985
X-HE-Meta: U2FsdGVkX1/PiUZ7L3zb0tufG99KCTCoIzd9AnRZyTqSZeGjkA0rFPM+JtaSXusMOlmQEmI89ZasDEQtiBTzVFZ2aMLh6J8OdYQdwSbQ98jVWY+uSLAaDzO3RpuZd/6tkA5E6LW+iXag9+uNXrpgUT0cKudBdf7mXiWgAaXI99KktOK5hnshLF7jf9NtRzPuqxPK1AErY7ScutNsdeTXrGGHFrbBUKXDKq5ZA26QaPs1pqHhdEVTAOQ5ToR/8gfRucsc5XpCD4ys7aCG0cSuEMmKRSTOxRdXveGbOJ1vfqY2yHT5uzdBmuOi1IYnrWZp9XzMijDoDmIZjeP+gARpLFJa+Nd5dqCevdhwCwJuIZzIiIJsLEBada5ylyElXYOwKrNGaws03vsmeqqjkk1/bnT1KsTXNSkLdzj3dKS/iV2n1XqYNobJ0HbwhPOpsCP63FANJqamwUc8SmPw+ba1icJqOlg37edS0w0zVYcbDaAAli/TtIBVdH+2D53MpFcEu/27wt/v1VGcgczVWYQpC0SdxLy1rfmnpQi27SZeGq8k4Mv3Muf7zYNFHgJNkccLwxLhVrROX9+drMYzLcEtRckYbLqB/8WYX/wE4uFBCT1suB1RI11VeO8umDMm1mscTuHiNi8+4IlelnzlhYVNOqWJaeHiB3EP3qF8EgxhplaYEjGe5O+eufM+LPOKqfyavxuKQ3doXGENXPE6NoPwUZFtsB+Wg4F8xipHnvD2T9NvwkFYR3tRfrGrUT0YQjBrlCar4La6dsX6oiHKKodWPfPVODAGX7Z++kFjSXE+0RlfahQnbQM5avTmp8Z+DZk2Yl3VGO8ogYqQqqImQ/rjZWiZM8Xx8c9hk7wav0XVNifR5AdArfFpEBRzq+lPAzglfqlJZl3KkZ1CPfLBWmFzzvxJnjC7sp2dkQl6iuRdaEWW1wQ9k1dlMuYxrgk7p7wvMjacVfEssPNZspiO13M
 7BVoAFGP
 daDxTERwJKQ7IFTI7J/keRPy3KCig93RdGfDu2uB4Gu0qEx7a/hZfJdFGwJMZCC9hpp/p3pJf48enQcq/CWPZ1hmn1ytMfPrwCSq33IYr/sqCjscK9S1VzcrWELt7QsZ/gLFkVYxH4OP/SD0kH1CPLY4lIBp8DvTILxfEegVk1hSUH0Rgm/+3DV0ozICl/MPdHDfKwvrH2H2zI/yemmVlSzr+CQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 17/02/26 11:38 pm, Pedro Falcato wrote:
> On Tue, Feb 17, 2026 at 12:43:38PM -0500, Luke Yang wrote:
>> On Mon, Feb 16, 2026 at 03:42:08PM +0530, Dev Jain wrote:
>>> On 13/02/26 10:56 pm, David Hildenbrand (Arm) wrote:
>>>> On 2/13/26 18:16, Suren Baghdasaryan wrote:
>>>>> On Fri, Feb 13, 2026 at 4:24 PM Pedro Falcato <pfalcato@suse.de> wrote:
>>>>>> On Fri, Feb 13, 2026 at 04:47:29PM +0100, David Hildenbrand (Arm) wrote:
>>>>>>> Hi!
>>>>>>>
>>>>>>>
>>>>>>> Micro-benchmark results are nice. But what is the real word impact?
>>>>>>> IOW, why
>>>>>>> should we care?
>>>>>> Well, mprotect is widely used in thread spawning, code JITting,
>>>>>> and even process startup. And we don't want to pay for a feature we can't
>>>>>> even use (on x86).
>>>>> I agree. When I straced Android's zygote a while ago, mprotect() came
>>>>> up #30 in the list of most frequently used syscalls and one of the
>>>>> most used mm-related syscalls due to its use during process creation.
>>>>> However, I don't know how often it's used on VMAs of size >=400KiB.
>>>> See my point? :) If this is apparently so widespread then finding a real
>>>> reproducer is likely not a problem. Otherwise it's just speculation.
>>>>
>>>> It would also be interesting to know whether the reproducer ran with any
>>>> sort of mTHP enabled or not. 
>>> Yes. Luke, can you experiment with the following microbenchmark:
>>>
>>> https://pastebin.com/3hNtYirT
>>>
>>> and see if there is an optimization for pte-mapped 2M folios, before and
>>> after the commit?
>>>
>>> (set transparent_hugepages/enabled=always, hugepages-2048Kb/enabled=always)
> Since you're testing stuff, could you please test the changes in:
> https://github.com/heatd/linux/tree/mprotect-opt ?
>
> Not posting them yet since merge window, etc. Plus I think there's some
> further optimization work we can pull off.
>
> With the benchmark in https://gist.github.com/heatd/25eb2edb601719d22bfb514bcf06a132
> (compiled with g++ -O2 file.cpp -lbenchmark, needs google/benchmark) I've measured
> about an 18% speedup between original vs with patches.

Thanks for working on this. Some comments -

1. Rejecting batching with pte_batch_hint() means that we also don't batch 16K and 32K large
folios on arm64, since the cont bit is on starting only at 64K. Not sure how imp this is.

2. Did you measure if there is an optimization due to just the first commit ("prefetch the next pte")?
I actually had prefetch in mind - is it possible to do some kind of prefetch(pfn_to_page(pte_pfn(pte)))
to optimize the call to vm_normal_folio()?

>

