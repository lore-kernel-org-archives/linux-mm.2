Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91E7E109B46D
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 14:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E069B6B0099; Tue, 31 Mar 2026 10:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90456B009B; Tue, 31 Mar 2026 10:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7F026B009D; Tue, 31 Mar 2026 10:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFF866B0099
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:15:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BA9FC403E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:15:35 +0000 (UTC)
X-FDA: 84606556230.25.D88CC5C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 935A61C000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:15:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oJM7vb4P;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774966532; a=rsa-sha256;
	cv=none;
	b=rSu5fRpSvv2671CF9f/MvfX5rMhyHh+8IadikDPvbqxytnsyyi6pfW2SwXqN+/9r+wHJ9A
	aYUyj0i5PUpc1CfsJtT+E5inykugihk9ND+iz6m+j+pqII0KZ2on9aQXCpeh2bjPj5OaZ+
	gV2lilrN6XO91jK+5GmohD3CqtyeOAk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oJM7vb4P;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774966532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vh7GsL2aOJLXCu2y3HKS78dfz1/yFoQr/PU/mbSm8s0=;
	b=lncWQsKHL12HwjNjQG5ky872EQ1/e8qumvQ29TLi9kdMxA3nDFJ8/Qeg+bH1D3U5JiWCz+
	/UIYLF3syW5PgbsjzDzLBGXiJMYYiajpVPtd3vVTVi4+38y8bX18XvBn6iWaoP3G05jk90
	mygUxOsjegIa4HU2w85WtXKNKt2hAiQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79392497F;
	Tue, 31 Mar 2026 07:15:25 -0700 (PDT)
Received: from [10.57.56.98] (unknown [10.57.56.98])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 83F593F641;
	Tue, 31 Mar 2026 07:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774966531; bh=9z2MXKM/ZiMSqPeqkaUKxlawR2frF3py0x92yErvlU0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oJM7vb4PMFH8u1/9y2halmmZt6v/lBq8nRr1CQtr07dScwz8NKTR7nvLEVsrXHI2M
	 klGmCUswAwUvGwr1LljNzFRndxJf6Rv0el6JfhfIv57auBJK1/WHKBPEasmO4dMZd5
	 Vvs9SSp1PkrOXybInOopmh2rYwurpfgXCLuo9QcQ=
Message-ID: <c27cad07-bba4-472d-8853-fc6fc55e951f@arm.com>
Date: Tue, 31 Mar 2026 16:15:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm: make lazy MMU mode context-aware
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774420056.git.agordeev@linux.ibm.com>
 <de89fd353a8dcd5e3bef4d91e9b6682d132ed9a0.1774420057.git.agordeev@linux.ibm.com>
 <44dd86c0-1845-4dd9-b4b4-2cef6d1c6357@kernel.org>
 <e096e88b-f1fe-44a1-bfa6-451eef028203-agordeev@linux.ibm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <e096e88b-f1fe-44a1-bfa6-451eef028203-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 935A61C000E
X-Stat-Signature: 1wt5fogyfhsz6i3r38f3hyhyef4gbbp3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774966532-720808
X-HE-Meta: U2FsdGVkX1/jFJ0n1vw8of6um7RvDwW4cd43N/2zUTSSlat6VGaqYPKu068KhlsEq5wZLC1vLLTNqB0I9Y7oR1eAiVtqXlob33RgAavf8BBWn+DLpv7HTjhizI49K1djBilkOtfxSLOLFLZ2sI+s9xjoEmmNifdbT5AK3xcutrQTIyIP9hWOMaG+oVSC73OFLAi1/EHE+YH75VvR15Fskc8gUrksUOCyOxjq2FWzf1PQgSeqWohkHABpfGsXqJUxymVWp5vZxdUOPioD+8GK8qoznF1782DVX7lwknws3Whum+XrPKu9DYkCjqm+w74BonAAbujpyDhdIH0WUvbTpiG9ASdLI1/4vtfG/H+Ox7y6hPU5ia7MxLWolXQa0CiJxBuYls2O4joQAtmpxJUlcAqeQpMcC5GR4pyJVSAkn2efm7XkupjQfYmoLTKQc+bcnSna7IaSPGTIZ5TpbevA3Ytjr5034LF0muzyxgfZj2odbiHCfU6MmIceCoI5sde1bi9jJaCc8IJ1ARHd6sXwp7Lve+m1qfTuzYGfes90wMAu+YrQf4zOi5R5WIkdZRBS9jP2u8XtvkeLHaxlb7NKVmdXFlD9wsa63YyJ5omcJH7kDdCKsW5jnaw7Aui2nwrGDaA74VH1FkaWp7b89dylYIcvxW7sJB3d8gYgUWckJz84TFc7vfW1hN9rPlT8jEAUdHunz7Ta4KyKac/gui/pG/hMFhpy4VJu/Eep6LH0OkzqUXcINpGPxTW90BmYnMhx3YTkgcKOC0A2vOBQ6zNACxh2pJs93uwP9X7YfVhwiBlUqd3qW3F0aTTy85luKHljt5bIEz14pdw97iLa5eqByMDXnzZjOGxi4bn/L93TVuNfIYs4r3y23CRbF03+bJh8i8Nopwe38NPdXPhTAhS8QOogWG7lYG1zg9k7Y8NwBVFdm/Puac7eGQ639zWjRGJLGj5y5b0HBmDTcBtp4wq
 sL5EiZ32
 nOpXc9s0YyRtGyyqoAMV59IlBlf7zNv3ETNwrpn0fvTO/lIstaTAy5uHdeONSi1eWwSaE+eUmB0jBoxpG3w5bf9SlGLO/AhbcBSDnflAZbzj2YG9HaW5CBDpp9Ow7m1yF0XrWxkKdDL+kdJrfDUbhaeT5aJYVUycooegHCa5kuGrXIDPsvttn5uYLObYxHfvGtNizxVOVfXzab2f7+3Bynwe841ZCA2DLBDgDCBQ/5nzcBB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/03/2026 17:20, Alexander Gordeev wrote:
> On Wed, Mar 25, 2026 at 10:55:23AM +0100, David Hildenbrand (Arm) wrote:
>
> Hi David,
>
>>> +/**
>>> + * lazy_mmu_mode_enable_pte() - Enable the lazy MMU mode with parameters
>> You have to be a lot clearer about implications. For example, what
>> happens if we would bail out and not process all ptes? What are the
>> exact semantics.
> The only implication is "only this address/PTE range could be updated
> and that range may span one page table at most".
>
> Whether all or portion of PTEs were actually updated is not defined,
> just like in case of lazy_mmu_mode_enable_pte().
>
> Makes sense?

I also feel that the comment needs to be much more specific. From a
brief glance at patch 2, it seems that __ipte_batch_set_pte() assumes
that all PTEs processed after this function is called are contiguous.
This should be documented.

>>> + * Enters a new lazy MMU mode section; if the mode was not already enabled,
>>> + * enables it and calls arch_enter_lazy_mmu_mode_pte().
>>> + *
>>> + * Must be paired with a call to lazy_mmu_mode_disable().
>>> + *
>>> + * Has no effect if called:
>>> + * - While paused - see lazy_mmu_mode_pause()
>>> + * - In interrupt context
>>> + */
>>> +static inline void lazy_mmu_mode_enable_pte(struct mm_struct *mm,
>>> +					    unsigned long addr,
>>> +					    unsigned long end,
>>> +					    pte_t *ptep)
>> It can be multiple ptes, so should this be some kind of "pte_range"/
>>
>> lazy_mmu_mode_enable_for_pte_range()
>>
>> A bit mouthful but clearer.
>>
>>> +{
>>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>> +
>>> +	if (in_interrupt() || state->pause_count > 0)
>>> +		return;
>>> +
>>> +	VM_WARN_ON_ONCE(state->enable_count == U8_MAX);
>>> +
>>> +	if (state->enable_count++ == 0)
>>> +		arch_enter_lazy_mmu_mode_pte(mm, addr, end, ptep);
> I will also change arch_enter_lazy_mmu_mode_pte() to
> arch_enter_lazy_mmu_mode_for_pte_range() then.

Makes sense. The interface looks reasonable to me with this new name.

One more comment though: in previous discussions you mentioned the need
for arch_{pause,resume} hooks, is that no longer necessary simply
because {pause,resume} are not used on the paths where you make use of
the new enable function?

- Kevin

