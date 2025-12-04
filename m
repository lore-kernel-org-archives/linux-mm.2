Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED75D29FB2
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098C56B0023; Thu,  4 Dec 2025 14:39:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0710A6B0088; Thu,  4 Dec 2025 14:39:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF926B00A4; Thu,  4 Dec 2025 14:39:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDB706B0023
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:39:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 962F9B84CB
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:39:06 +0000 (UTC)
X-FDA: 84182801892.21.4C6C915
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B0BB51C0018
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:39:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lxo07IQA;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764877144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zlnt8UMquDekV44NsGIqu3q4V2h5Bg8dHyh34gkZfkg=;
	b=nfnkGlpd62x6LTMGkrj9QpwKDBq6litXX2Q041Kadmq7N2VNoi0gFo+w63o7GlzO2ISazy
	jp3NQoSgqx7bGnr3dNY73cWn/GzFB/ELnPrJTsNh4UCqUG0DbszexxAfZV9s6FoFMlp9HC
	ZV2t9n6pskcXWvIcV4biXCXlC3oA37Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lxo07IQA;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764877144; a=rsa-sha256;
	cv=none;
	b=iYq/9ujoN4eTWXm1vf9w1Xpc8G2aZvCY2d/IlIQMKRNKeZg7kDdKTWlXty0uYl+ksmoJvN
	oQyIPpcejiNiPMRTkUhbkJRkjgSsCqf0wkWPDYNd7ooUsMzJwIHIn8FddOHntyXD4V7Ns/
	F2OoM3+ttQqNC7leutEeHHOM7U8TRIU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FC8D43D05;
	Thu,  4 Dec 2025 19:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED09C4CEFB;
	Thu,  4 Dec 2025 19:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764877143;
	bh=7xoWfZb/rQlOyV51uYCWOVPmwkaZ4pvqIYT0hW3+62M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Lxo07IQAhkWMt2l8zQ9z0zjXSecELZqm/Sl/HVxpGQ3HrR32VZ/HcjuZZIECRJyuc
	 b9AzhJXdV5j/DiFeh1DcrpWMQCqz/W0KmqtebGB5fy6P7btaWJ2f325YRNUM085/yT
	 8ax/GnH3DxXkdSyLt/Wkxp+BHtMijuaoql6FBscs/4yJUFlyB78XqPA/3MI/alf+Ga
	 zCzXcq75PuK2Yx/PGKMG+wUeST30nFTCs+39VviL+9YHWYnLqEmJgSWHEyOtKHT6X9
	 rMeg0TNesxFsC8wSY69xa/Dtn+qNfbKDxsspDfh93eWHo51STHZK6sqNvm3w8dX4gG
	 T2SwhXwLTyAhQ==
Message-ID: <8a5b59b9-112d-44cf-b81e-6f79f59bb999@kernel.org>
Date: Thu, 4 Dec 2025 20:38:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb"
To: Shuah Khan <skhan@linuxfoundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, maddy@linux.ibm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, christophe.leroy@csgroup.eu, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
 masahiroy@kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251204023358.54107-1-skhan@linuxfoundation.org>
 <0b007374-1058-487c-8033-4f0d2830dc89@kernel.org>
 <aTErsX-wfnxkNJ1G@kernel.org>
 <78af7da4-d213-42c6-8ca6-c2bdca81f233@linuxfoundation.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <78af7da4-d213-42c6-8ca6-c2bdca81f233@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B0BB51C0018
X-Stat-Signature: jdq8eqdoqr7ka3dobsubghdtxhsbaod3
X-Rspam-User: 
X-HE-Tag: 1764877144-970323
X-HE-Meta: U2FsdGVkX1/T+PqPo+iDIzer0yHW9a0gHIxKIUBb1NcFPYKMy4/glB0F32e82ADiRlZi71SOtpyxkLF2R7j4XIPBKUMOV4a2KTGvd3AzKi3D0yg8rjCjCgQ1GP+XIVi2MZ12EQB7AEimlkvtcWN/ompKHNk15oNWWemBLVvZpTf34lPlCWbR9Y979q1ME8FGYFG5vlT+6NqbC2nPnP22G7kCTtyY/NV1l7b1rdFFVa+Fs4pDBNaSdNJJIrfJZljND3vv4mvBaSpg/OqoaJY8A/414F/OF+MX/GEpeKkjUUSXa9hJlVXjYD7KyON9i1EHNPl5Jf79eYnZeMUrqthKksAjXWq/MICQ0ay3tJIT0pE6CzXVVzlRL9G5gM6XZhY4SlN2gxNt0TkhMMKioTAWPO7mvnPyQMmwmOz1m4WVEB6rdK8XKG/0U68A0G46Sm/nW7JwbqAAm8AqEoF5dX3Q1yazll7rSDVthjM6y/93HAqpwhTfWit46/A5Ea/7BQGt91Kmkmg8TXWZw7jCs3yDtE9OdaIzm6D674ccgW8oZxSIf3kE6nRnKoT8EopAadA5OM3mOMkXEuR9+GPeb8uo0NF8DjKBr1asdGZjFaLF/LnyA9iBtxy92EbxOYqO873gEveMwbr0VOb3UQBGKRlweFhKOMImWfCwDorGli23EZHLXnOJ8q/qcVLSGeQSs3zDvBqK6+zM3pt+G2T1GCtEfyVCaMwDAxRQKksHFwTmWu6OcRdX6oBVr5fzEiCUX8rc8JHN9OVvdN1isTY8JYFtq+6GD4XnhbCA8Jvz3HRYqJ7x4ZxUjko1OpT7uPmLOumR/t6+lI5igGwPtv68uH+nC8nTuwOIFNKYVVSyMXuujFwjxu2CFFn1BvP27idQ7xEwuJnmdyLA3exNL2MroOL7WruG7P7iwTJH+a0DyXyR/hJlKxkloLkFX6wzz9KjXiH/nWH13Ud2dBRcCJcRw8b
 GG5FL2a0
 6JfgDIXqwga/g6pe9RUwJWpWw5z+1vYgbZR1gmohROUc45dRQPBhYb3d99oaQP0nuHH6HX3xxZyHiZdIeafZemrBsEnd9FVZSCdao2gV2VIYf4cal5uW8bUzZDKooGa5KfKrI7sSbvcjL3kVs0O12PgcvaGzjNtMhBBZqGRf/ozjFkzRvm3lMKRaaJfRfiI6q8UHP8IQVQa1m5R4Kuyb1lAPwpbgU1l3zgBD+W8HgRjIzTbYNKfKtXNcU49peR0s06wjAQ9fBvcFXi1kV7dNcUJVr63abktkokon4+ulYxK6MrNDMo+rlwMRe2jQOcFsOf9Nn5CYaHB51tpY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 18:03, Shuah Khan wrote:
> On 12/3/25 23:35, Mike Rapoport wrote:
>> On Thu, Dec 04, 2025 at 07:17:06AM +0100, David Hildenbrand (Red Hat) wrote:
>>> Hi,
>>>
>>> On 12/4/25 03:33, Shuah Khan wrote:
>>>> This reverts commit 39231e8d6ba7f794b566fd91ebd88c0834a23b98.
>>>
>>> That was supposed to fix powerpc handling though. So I think we have to
>>> understand what is happening here.
> 
> This patch changes include/linux/mm.h and mm/Kconfig in addition to
> arch/powerpc/Kconfig and arch/powerpc/platforms/Kconfig.cputype
> 
> With this patch HAVE_GIGANTIC_FOLIOS is enabled on x86_64 config
> 
> The following mm/Kconfig isn't arch specific. This makes this
> not powerpc specific and this is enabled on x86_64

Yes, and as the patch explains that's expected. See below.

> 
> +#
> +# We can end up creating gigantic folio.
> +#
> +config HAVE_GIGANTIC_FOLIOS
> +       def_bool (HUGETLB_PAGE && ARCH_HAS_GIGANTIC_PAGE) || \
> +                (ZONE_DEVICE && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> +
> 
> The following change in include/linux/mm.h is also generic
> and applies to x86_64 as well.
> 
> -#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
> +#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
> 
> Is this not intended on all architectures?

All expected. See below.

> 
>>>
>>>>
>>>> Enabling HAVE_GIGANTIC_FOLIOS broke kernel build and git clone on two
>>>> systems. git fetch-pack fails when cloning large repos and make hangs
>>>> or errors out of Makefile.build with Error: 139. These failures are
>>>> random with git clone failing after fetching 1% of the objects, and
>>>> make hangs while compiling random files.
>>>
>>> On which architecture do we see these issues and with which kernel configs?
>>> Can you share one?
> 
> Config attached.

Okay, let's walk this through. The config has:

CONFIG_HAVE_GIGANTIC_FOLIOS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_ZONE_DEVICE=y
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_VMEMMAP=y


In the old code:

#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
/*
  * We don't expect any folios that exceed buddy sizes (and consequently
  * memory sections).
  */
#define MAX_FOLIO_ORDER         MAX_PAGE_ORDER
#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
/*
  * Only pages within a single memory section are guaranteed to be
  * contiguous. By limiting folios to a single memory section, all folio
  * pages are guaranteed to be contiguous.
  */
#define MAX_FOLIO_ORDER         PFN_SECTION_SHIFT
#else
/*
  * There is no real limit on the folio size. We limit them to the maximum we
  * currently expect (e.g., hugetlb, dax).
  */
#define MAX_FOLIO_ORDER         PUD_ORDER
#endif


We would get MAX_FOLIO_ORDER = PUD_ORDER = 18


In the new code we will get:

#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
/*
  * We don't expect any folios that exceed buddy sizes (and consequently
  * memory sections).
  */
#define MAX_FOLIO_ORDER         MAX_PAGE_ORDER
#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
/*
  * Only pages within a single memory section are guaranteed to be
  * contiguous. By limiting folios to a single memory section, all folio
  * pages are guaranteed to be contiguous.
  */
#define MAX_FOLIO_ORDER         PFN_SECTION_SHIFT
#elif defined(CONFIG_HUGETLB_PAGE)
/*
  * There is no real limit on the folio size. We limit them to the maximum we
  * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
  * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
  */
#define MAX_FOLIO_ORDER         get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
#else
/*
  * Without hugetlb, gigantic folios that are bigger than a single PUD are
  * currently impossible.
  */
#define MAX_FOLIO_ORDER         PUD_ORDER
#endif


MAX_FOLIO_ORDER = get_order(SZ_16G) = 22


That's expected and okay (raising the maximum we expect), as we only want to set a
rough upper cap on the maximum folio size.

As I raised, observe how MAX_FOLIO_ORDER is only used to
* trigger warnings if we observe an unexpectedly large folio size. Safety checks.
* use it when dumping a folio to detect possible folio corruption on unexpected folio sizes


> 
>>>
>>>>
>>>> The blow is is one of the git clone failures:
>>>>
>>>> git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git linux_6.19
>>>> Cloning into 'linux_6.19'...
>>>> remote: Enumerating objects: 11173575, done.
>>>> remote: Counting objects: 100% (785/785), done.
>>>> remote: Compressing objects: 100% (373/373), done.
>>>> remote: Total 11173575 (delta 534), reused 505 (delta 411), pack-reused 11172790 (from 1)
>>>> Receiving objects: 100% (11173575/11173575), 3.00 GiB | 7.08 MiB/s, done.
>>>> Resolving deltas: 100% (9195212/9195212), done.
>>>> fatal: did not receive expected object 0002003e951b5057c16de5a39140abcbf6e44e50
>>>> fatal: fetch-pack: invalid index-pack output
>>>
>>> If I would have to guess, these symptoms match what we saw between commit
>>> adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero folio")
>>> and commit 5bebe8de1926 ("mm/huge_memory: Fix initialization of huge zero folio").
>>>
>>> 5bebe8de1926 went into v6.18-rc7.
>>>
>>> Just to be sure, are you sure we were able to reproduce this issue with a
>>> v6.18-rc7 or even v6.18 that contains 5bebe8de1926?
>>>
>>> Bisecting might give you wrong results, as the problems of adfb6609c680 do not
>>> reproduce reliably.
>>    
>> I can confirm that bisecting gives odd results between v6.18-rc5 and
>> v6.18-rc6. I was seeing failures in some tests, bisected a few times and
>> got a bunch of bogus commits including 3470715e5c22 ("MAINTAINERS: update
>> David Hildenbrand's email address") :)
> 
> I am sure this patch is the cause oh the problems I have seen on my two
> systems. Reverting this commit solved issues since this commit does
> impact all architectures enabling HAVE_GIGANTIC_FOLIOS if the conditions
> are right.
> 
>>
>> And 5bebe8de1926 actually solved the issue for me.
> 
> Were you seeing the problems I reported without 5bebe8de1926?
> Is 5bebe8de1926 is 6.18?

We were seeing all kinds of different segmentation faults or corruptions.
In my case, every-time I tried to login something would segfault. For others,
compilers stopped working or they got different random segfaults.

Assume you think you have a shared zero page, but every time you reboot it's filled
with other garbage data. Not good when your app assumes something contains 0s.

> 
> I can try this commit with 39231e8d6ba7f794b566fd91ebd88c0834a23b98
> and see what happens on my system.

Yes, please. I cannot yet make sense of how MAX_FOLIO_ORDER would make any
difference.

Unless you would actually be seeing one of the WARNINGS that are based on
MAX_FOLIO_ORDER / MAX_FOLIO_NR_PAGES. But I guess none showed up in dmesg?

-- 
Cheers

David

