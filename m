Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1758EDF039
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 05:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C04A06B0005; Thu, 12 Feb 2026 00:04:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1D36B0089; Thu, 12 Feb 2026 00:04:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABDDC6B008A; Thu, 12 Feb 2026 00:04:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 990DA6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:04:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4288ED6DD7
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:04:34 +0000 (UTC)
X-FDA: 84434614068.03.F5D2A06
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 79B2340006
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 05:04:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770872672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+LI2jimcLXG30rp40jFxMo0vtHxesEC/XIOz3WYdex0=;
	b=8GfpO/houK5J4lO/N2tlchr5XVg4e6/WusDTqGHBltd4xADwcnzB0Jd4jKpI2zbzopu3zg
	//yhpV1p99dgEaoAOpme3Axs8Rp429CxmqpFla3eJBjYeK5FxqpGYaz3gkEEb5JGfF/gPn
	H7S+JH1MThwgJcxXKlEwgjRtpQSjAE4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770872672; a=rsa-sha256;
	cv=none;
	b=pyAwvrFLTg1NdnKKkiUTadC+WGJdSnjGMtm0CL6kHj973dGdYS6KWD6/bp74YA6ZP+yiv7
	jomkurtJdYQZ2h7YLiuTgJ6Vc5rTcMsnjID6mxB938nPOcgMbAIvQ4KAsPkRpl9Ih9zISi
	45fvHO9X0Oo5Bcil704SN87peqAg6OI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0CB19339;
	Wed, 11 Feb 2026 21:04:25 -0800 (PST)
Received: from [10.164.148.47] (MacBook-Pro.blr.arm.com [10.164.148.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0CBB83F73F;
	Wed, 11 Feb 2026 21:04:27 -0800 (PST)
Message-ID: <fd1dccf7-771c-4aba-8974-558cc49cc857@arm.com>
Date: Thu, 12 Feb 2026 10:34:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: only set fault addrsss' access bit in
 do_anonymous_page
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260210043456.2137482-1-haowenchao22@gmail.com>
 <5c4d773c-e3e7-4a71-b250-91701cbdd4a2@kernel.org>
 <CAOptpSPuntL5dy+D7-wWcWuOgxugD+_uLzEO8e4fyGjS_ZkUWQ@mail.gmail.com>
 <52ab55c0-6b70-4afc-866d-dd505ff3e85b@arm.com>
 <CAOptpSN96Juwx9apwrt8NpakJOUoUCKxpUPyko9Cz_DJvKoZHA@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAOptpSN96Juwx9apwrt8NpakJOUoUCKxpUPyko9Cz_DJvKoZHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 79B2340006
X-Stat-Signature: 8iqq69h4gjdecz5yxjd5sschx4dfq66n
X-Rspam-User: 
X-HE-Tag: 1770872672-59318
X-HE-Meta: U2FsdGVkX19EykywPBBrlQE4rpHkSIwM8i4b6T0QzzXUq8Eg0YxvhNMjVcqhdkeKy1+r00kamdoLkH9uAXqZBChfYYvP5Lf5ZrXEHXTkTNTMHyEto59fzV/UBj8DM2+3WGv9HwIJuNxm8HqsKVDnw7JRwCoBzbU3665TXmUdiSFhp5JWTEwtJKZpJ02zjiBwo+7L2hn/JzzdlHuB97I9lfEIAczNrY9YWWrvysU6MHKW+aiwRLN41h+6ewjcbE7FCx5SS+79NkfHU7VNElGTDImBU1/rLfdbRZyd5y5/ISC6WWCBavdRlFYd+Bz1hT6i4KyofDvs7rS0n+IeOcg+i0jTMN5P2Lv9mCeWpRLYU8MSq+hJNNsBE3jFNzCQ/Fej1+CCcHtAVFZ1mfpkgjcEnXCGtxuJLvNKAQqsURniMsYBWN+h+f3ku5RIskaOPQd6ppmOmZyH6tQk8TEPZO+tUZF4dw/4isDAB+/zo7k1JW8J6BOSLtZ3jzsy8mMuYIvIon2nRFYGBuy7/m4rZjQy0gPFj9zkacQfnd1ciG1d884fkWgeLMiSsIm5eAA+/dLF3Mgv+Fq1KlSjqed/68QklXxPMOFQJNdG6Ag4b42cSM/setdIyynUftBMGqiRDz7vNrPeVJjzSW+AUpA+IFXTZt47ez3Yd+3xWanVHzf+GYiPEgnGIaW/Yk7bJi8kS9pl2wfZPBidWsP777jvaB7yJiR3IC8PmpejWnYILJLyzcMuPwmKyFEZdIl9t6sdoVylMD6CKY0c3Y0NxqmymvbdXqidFUygeePPXkvJVKrMwN6VckYHkGT14xLtJdfJPXILBKozBs66SJuIGoXSrBiuuJRQXD3/QKFVDD00S2Ai/mXxefEyP4mu80jDQfbIiRW7IjRcc7WdI/PPVoUU12CbJnDBeSeOn1OPCWBoWM199xpSAAf5hofTEHGVZLXm9KtFKKHS7X+lNln7sjr41Ov
 7tbmnpZ1
 y7J/Z47r3vQlJQ/oya6G5zz1kjKXD0eg3GTA4Q95Mfliw8/f7RTfvdkmcWtcs/k8U7VLa4O9+FcBnQlhEWJ0na04HG5imMXTmu+wEQZQ1VTWfvXxQnIeb0Y5H0u70mUlQgdgzVZrcfCMbbDFADbzoDlar7CMKfjS+W7iAEwEf8Rk23U7Bs3hYu3XVfF0Laoev9s22ZxP3ARaXoSqhn+VZ5FCK81c1prGoRASZTUJIPtP4Zmt9pii00vH6Z5w3iumrUmcv9qMlQ7CDFXoU9nNMBC08xU0xGL8zzfuNAUm6tNKHb0E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 12/02/26 7:12 am, Wenchao Hao wrote:
> On Wed, Feb 11, 2026 at 12:18 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>> On 11/02/26 6:19 am, Wenchao Hao wrote:
>>> On Tue, Feb 10, 2026 at 5:07 PM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>> On 2/10/26 05:34, Wenchao Hao wrote:
>>>>> When do_anonymous_page() creates mappings for huge pages, it currently sets
>>>>> the access bit for all mapped PTEs (Page Table Entries) by default.
>>>>>
>>>>> This causes an issue where the Referenced field in /proc/pid/smaps cannot
>>>>> distinguish whether a page was actually accessed.
>>>> What is the use case that cares about that?
>>>>
>>> We have enabled 64KB large folios on Android devices, which may introduce
>>> some memory waste. I want to figure out the proportion of memory waste
>>> caused by large folios. Reading the "Referenced" field from /proc/pid/smaps
>>> is a relatively low-cost method.
>>>
>>> Additionally, considering future hot/cold page identification, we aim to
>>> detect 64KB large folios where some pages are actually unaccessed and split
>>> them into normal pages to avoid memory waste.
>>>
>>> However, the current large folio implementation sets the access bit for all
>>> page table entries (PTEs) of the large folio in the do_anonymous_page
>>> function, making it hard to distinguish whether pre-allocated pages were
>>> truly accessed.
>>>
>>>> What we have right now is the exact same behavior as if you would get a
>>>> PMD THP that has a single access+dirty bit at fault time.
>>>>
>>>> Also, architectures that support transparent PTE coalescing will not be
>>>> able to coalesce until all PTE bits are equal.
>>>>
>>>> This level of imprecision is to be expected with large folios that only
>>>> have a single access+dirty bit.
>>>>
>>> Thanks a lot for the response.
>>>
>>> I saw this description in the ARM manual, “D8.5.5 Use of the Contiguous bit
>>> with hardware updates to the translation tables”:
>>>
>>>
>>>> If hardware updates a translation table entry, and if the Contiguous bit in
>>>> that entry is 1, then the members in a group of contiguous translation table
>>>> entries can have different AF, AP[2], and S2AP[1] values.
>>> Does this mean that after hardware aggregates multiple PTEs, it can still
>>> independently set the AF and other flag bits corresponding to specific
>>> sub-PTE?
>> Yes. Hardware can update access and dirty bits per-pte. It is the job
>> of software to aggregate them.
>>
>>> If so, can software also set different AF bits for a group of 16 PTEs
>>> without affecting the transparent PTE coalescing function?
>> Yes. See set_ptes -> __contpte_try_fold: look at pte_mkold(pte_mkclean()).
>> We ignore the a/d bits while constructing the next expected pte.
>>
> Thank you for your answer. I think we can now get the following conclusion:
> From a hardware perspective, after the PTE continuous bit is set, the access
> and dirty flags of the PTE do not affect the transparent PTE
> coalescing function.

Keep in mind that this is the case in software - there is also transparent
coalescing done by hardware, and I am not aware of the spec for that.

>
>>> The reason I have this confusion is that there is such a description in
>>> “D8.7.1 The Contiguous bit:”
>>>
>>>> Software is required to ensure that all of the adjacent translation table
>>>> entries for the contiguous region point to a contiguous OA range with
>>>> consistent attributes and permissions.
>>> It does not specify whether attributes and permissions include the AF bit.
>>>
>>>> --
>>>> Cheers,
>>>>
>>>> David

