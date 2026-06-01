Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDF14CD6E57
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 588316B03DF; Mon,  1 Jun 2026 10:40:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538516B03E1; Mon,  1 Jun 2026 10:40:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427EF6B03E2; Mon,  1 Jun 2026 10:40:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3042A6B03DF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:40:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3F14C2166
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:40:42 +0000 (UTC)
X-FDA: 84831605124.18.B53AD6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 188B5100014
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:40:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LX5O3pKp;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780324841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yi2ZVOf/CVgiICSrh/5HaGdVssu1alwT4zEP5+1/sk8=;
	b=YqlI1y8EKob3Z9eVp5IvRIrx8uxtcgCK9CpMyO9x+vkY06Up2MDH20OT2Tv3eX6e+LnFXX
	lb9McihXz4IttZnlHPXcNr+nckmMdbqZeVG5q0CiIS/kJoiPtF022V3rgSEasw/uQHZdJF
	1i9vDBgQtTOSDRoZvSZ3V1tBz/ACWXA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LX5O3pKp;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780324841; a=rsa-sha256;
	cv=none;
	b=OVGtKy4X9UlBHkNW7ziQE4/oLMqpuyXs5WOsZadFJZmazBMka9FKi13AAf7rDhF/qn3Fg7
	OXYRmE1iX0mLLxwXV5dzAkpmG6UDLF7vC6UuV0CM213T3TQTqoRgfpsll6Z2/qaqOk9ueg
	U8pGdS0Y3yKtMnbI1B4PN4QJp2rC9iM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3954740193;
	Mon,  1 Jun 2026 14:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF671F00893;
	Mon,  1 Jun 2026 14:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780324840;
	bh=Yi2ZVOf/CVgiICSrh/5HaGdVssu1alwT4zEP5+1/sk8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LX5O3pKpV5VL0ZUZNEqncE1v+B15dsGcei2/CP/ZTqDMCW4Ea0yScmeqikPgCjSj5
	 JSpn5GEIDCYssOh/aquUG5JpDIe/Sa1LK2h/LJc7CPl1GVjdnbQc0ReatV8tr4Wv+2
	 4uH85wTsnKZYTGQX7sBkFRqAFRhU8mxGW4B9hWkuQiCm81aCGyL5rYsA4VTBshSoG5
	 2WB+ZNvonbyQwPtvgW2czAohE/hit4kG6khYhYorU0LC49PKt4hLsiu5Rx7z0TGGUO
	 MjUy6/9njSZ0Qv6ec5W+PdMgSjGA5pwrhuqRG4WniWcbld2s4JM1G/704cWfx5yKVH
	 Z/dcXO8R7VWCA==
Message-ID: <4ff89390-6f61-43d4-8cd0-6d56a1d448e9@kernel.org>
Date: Mon, 1 Jun 2026 16:40:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 10/14] mm/khugepaged: introduce
 collapse_allowable_orders helper function
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, liam@infradead.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-11-npache@redhat.com>
 <b7ddff01-9adf-4ff7-84a6-021087936c34@kernel.org> <ah2UhZb9EYgYxj1F@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ah2UhZb9EYgYxj1F@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: judmrjrk4h8h8u94mdg97qumen9z9sim
X-Rspamd-Queue-Id: 188B5100014
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780324840-225552
X-HE-Meta: U2FsdGVkX1/LcxZ9p3LN3sJndFoQEQTbss85m0seWPurP5LFwwBu1broP/ehY8e18LDySJqMWVE7q07fPdgD2gSJXkJ8Xw8Snt4te5FtVNnmckMem/2oZuLA33qyk7iF7vUXwRdjsUP/ZYqHMkaduinVc+wpBgInESp/6kD3rTO0IhFWphr2TTZ+7vgrtBeUUz2N2xoOFwCv31aqTt2nJslW7ESTqeJSIJ6QKvXY0aE9tNTwUi7qoQKUSOfECXbwdoFDZCKN/Jz6gRn1mygcWmN1CpIGMd7XqQG6NlIX25hRXPRovXoteVXWazNUk60l2HZw+tKDtyTzqQIBAu6LunGsaOu47EN9r166Iq4Le8WJrslOPBtqXkm/4wGkc5+mVwRdPot3ng/LxVQ/YAM5UDRJD78XD6Fe3kSHoUSOMcXAqlsDeleThJvntgCudGzi48Z4vDTa5qAsTC8kCIsUiyL2gFWcWogp52OiO5cNEGuR4GpgRgXYE3DFo9VD0FtnsIWLOaNbok7/nwfGZGvv/R7RTTTT5gkf4DKuAqgZX5x8s/g2WVQKHhHend0RZeOuy79rYMK8uylXBPfDXedyqy92VOY5aUHFVi2R9aj24PFbGMALw6hsuUTs4+IcFfmQx588ppK551i1DugAO0P0IF8ZWjXU4eVHqIv4l74U5VJkeviql1brZxCiKsNHM/hyJNs/llEAwFhPYk1beYAuQtcHapx3sUBzIC7qpAIQ4AFVGuTI2DUVRIUxSwwcSpRjszfhbLHiNShcyZFtsx1Cctj4xmXQwO+607hW0lbAs4f2fjlRKnKLWW22fVTBmuh3L87LvMHQtEdjWMA/0oezrf9Ps4h3K4ktiPyoueMMqbP3p5kQ/YlxlmbA+nfH5/bf2ZPJw6bJ90nSJXjC7KwKsVtbPdgjwoxLNxkzV4xrsI9wILoU+zwkVNpI3H/qagDD21sllGCUCwdXLqgyrZT
 k+VB2D5V
 2HUq9NJ9lML8jqGL9AEKhQxjWhkJBB1q5R4idsZXuvJmdtXhd2vSPsP3L4Fev1/zsbuc+7Bji87fOrV2HqxE0f1zEgNyMUJ4XKwz2j5OY8C6mUM3yedfhWH/gNQXlbuEu8AM181BWLNX2yxuY5PSL8/Cfe41QtiqCdQ7D57vSdtttJkNfhGixBpPTfTMQV9bAOEWRY6UB/CTC7VQpSr08bdI4awELmOntnK46nCaR6e4+PF3oh7cokCI8xDULY10w0k/whJTgpnb+gAhulrQflN+oaCG6xfhfVBTFopsDcrz9tFWBfiolRraEFwaX04iQ61WQsrG88Li/kuIbkAImP7up8vGkIS4UWBgGBDA0hLuk6B9JH+QMYdEq7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 16:35, Lorenzo Stoakes wrote:
> On Sun, May 31, 2026 at 10:18:16PM +0200, David Hildenbrand (Arm) wrote:
>> On 5/22/26 17:00, Nico Pache wrote:
>>> Add collapse_allowable_orders() to generalize THP order eligibility. The
>>> function determines which THP orders are permitted based on collapse
>>> context (khugepaged vs madv_collapse).
>>>
>>> This consolidates collapse configuration logic and provides a clean
>>> interface for future mTHP collapse support where the orders may be
>>> different.
>>
>> It would have been good to describe here that, for now, it only ever returns
>> PMDs, and that it will be extended next.
>>
>> Logically, this patch belongs to #12, not #11 ... so seeing it before #11 was a bit
>>
>> ... and there, it is clear that we don't even want to know the orders?
>>
>> So can we just call this function
>>
>> "collapse_possible" and make it return a boolean?

FWIW, I realized later that #11 has

enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, tva_flags);

and forgot to delete that comment.

So we must have a variant (for #11) that returns the enabled orders.

> 
> Yeah agreed.
> 
> But I also don't love the naming, we now have thp_vma_allowable_orders(),
> __thp_vma_allowable_orders(), and then collapse_allowable_orders() and we also
> have 3 different ways of collapsing, one of which we call MADV_... COLLAPSE,
> and the other khugepaged + fault-in too for laughs.
> 
> It's like a big circle of confusion.
> 
> And of course we call THP collapse 'collapse' in general, so :)
> 
> Anyway I'm fine with collapse_possible() so we can move on and then maybe
> cleanup later.

We could simply have

collapse_possible_orders()

and

collapse_possible()

the latter being a simple wrapper around collapse_possible_orders().

> 
> Also - if I look at khugepaged.c I see thp_vma_allowable_orders() still used in
> hugepage_vma_revalidate().
> 
> Wouldn't it be better then to do the abstraction once mTHP order checking is
> properly introduced and change this also and have _every_ order check be
> consistent in khugepaged.c?

That'd also be nice, if easily possible.

-- 
Cheers,

David

