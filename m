Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE59BC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A63DC6B00F7; Mon,  6 Jul 2026 04:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3C0B6B00F8; Mon,  6 Jul 2026 04:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9520A6B00F9; Mon,  6 Jul 2026 04:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DCC66B00F7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:46:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E658C402E0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:45:59 +0000 (UTC)
X-FDA: 84957719238.21.72C46D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 28B3D180004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:45:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VoNyyimY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+VphFpucmenCRxzAqf6GCG3ouKRkPe9LBUQD12MWcpw=;
	b=06NEzxNURhP+XdgK51N/JxgbSVnIijdX5ZavNFldjukmf851NNndVfyO/mWIEzbf7m0B5W
	ZNEtVzUuyEYIfzm9PIaavxgbJnIf0kyKss7hyz97NapSxWEaqgJzb4/M1I9L/xs275b4OF
	jw+jU6E5S92Lfkli9vVaEXimEe8FBkQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VoNyyimY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327558;
	b=wVWk9+rHMlFNmGbVQQ5R3ZZsFnoIfJ5db5SvO6vjXaCcCqRfVof18yha28fWGEIl3drhDi
	U98ZUTVX72BpJXhs0lFUsaUu4UxTV76wPusFfyYwQwVWtSTjF6IdeajoMwXL4G/miqygv2
	6SaNDtgd07HYDGLy3pSXN4fBGFWqC2A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0169142E06;
	Mon,  6 Jul 2026 08:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9ED01F000E9;
	Mon,  6 Jul 2026 08:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783327556;
	bh=+VphFpucmenCRxzAqf6GCG3ouKRkPe9LBUQD12MWcpw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VoNyyimYnqqKLu1tQ9fTHSAp21AMnYBuiWyDfCJxhaM5/Kel8HyLFCw14x1s78N9U
	 7mGtgGN7PQ4XmdHlIMaW/7mlNyN/cMHkDlR8PbVdbyty6JdKay20g0qf+oHdS6g7BD
	 uF9eg8bFVbc42WPLvi/yhsVBGSO6LkgMOTX2l+QzthLuq25fpiD6WwgLlbBL/WWC2U
	 kdApDETEjy1WcUFc6A2sdKhZdnKGL20lVZikzBik4ow8GBgILpM6f0eCBgmOBqBrF4
	 hqE4J+OoveSZBRXmoWaSnTu/fspZaLo9MMP1OudEZa2PkV/QKRUvIlQW0v+WLjL8KI
	 c0u/RfKS2F/2g==
Message-ID: <4b4e8007-3747-457a-85cc-d1003e1c8fe2@kernel.org>
Date: Mon, 6 Jul 2026 10:45:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] arm64: make huge_ptep_get handled unaligned
 addresses
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, ljs@kernel.org,
 liam@infradead.org, riel@surriel.com, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, apopple@nvidia.com, rcampbell@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, ak@linux.intel.com, nao.horiguchi@gmail.com,
 mel@csn.ul.ie, j-nomura@ce.jp.nec.com, pfalcato@suse.de, tglx@kernel.org,
 dave.hansen@intel.com, jpoimboe@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260703114202.365553-1-dev.jain@arm.com>
 <20260703114202.365553-2-dev.jain@arm.com>
 <20260705003559.8b124d2b94b685cc2e4e77ae@linux-foundation.org>
 <8fdbe0d6-87fd-441c-b6d2-baac380f6fb3@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8fdbe0d6-87fd-441c-b6d2-baac380f6fb3@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 28B3D180004
X-Stat-Signature: o4c1uiqfcohewxdy1u678u641z9y6px8
X-Rspam-User: 
X-HE-Tag: 1783327558-349584
X-HE-Meta: U2FsdGVkX1+1AqtKF347XEo2ybZh4ULFWPpkHwPod13zRG+iJTUFECHJ97PdKv1o8+ZePikcZJMP92E3s26M0tPDd4agXf1mdi0DG+mUGALHmloXG7tOpIgajpYBQ2+VuuM2xl8M78BGaOLMPaVdskj9o+/tkvlEcgwRDDzw9lVxHfUT59oOgrGuLwzwVw5sYOQyGwNFtgJbC5vqCqKkBW3eW0LnC7zeIavF6wbtrZMCzpmKEgFx4gFj5+TE+ECSzRlJN/+1RxjydYZ0kh0LLELetN/X8oSCG2pTmBs6AGx6OcAvvx2BKVcahzjoBRy/6EphmwpO55CamutKhOXrH0Gh7bnX2linkIoob3USPO35Oeruyv0rpGRKxrd5b54+VbG2kvQrlTsUjhIxOAze0ZQoarcLSjeVWIwC1zJBIgCjPB4vRyqLBSvvGCJybFA3KksLIKeiafRysgd0CfLH93IIDbMiYM03WjphHaBN8t1or1Ydq/d1h/HQuZ/ApRRRRGhaT10XNl2PJEY7RR29Tt6MYtZVS23YN5S1IqhCT0wLQsKp+RSobJxQXdlfNXYndpNZtoUGspJJCHSLx6AOKdBVjOPRk+cQkMSHk1vPenFTw8mpgFsyjTLQze2mT9d9QMh5QSCzt7JLtKvgYczaVev5QwoqzkfGykPl68oCiNMmoYLEtYKDBuF5UCjMNSfwZHvXdDCumkHbq6GeEMABETDNghYKFJmZarUzf/KAjMjICOQt7zx3nflBGOMI2D9MUQP8RQy3yfnhp5mjzahwlzdHDXpJwQ8XCf01UTTTvqka+SsWhsBXEL3xLfN2LO0QvjUDQ8QKFx67Sb64QvsHhgI6JHshHN9uQvufzNnQ0+DvcC9wujI+zYWvcCcl1NYdtLARujNorjXeof+l1KgKQI+GxtPwNFR2ykaSgVK8tNuQXxnXW7mFIgmf5qiyHwcQQeizGtMykugPraubiAq
 EOqkb87o
 tE9XnpJQllOypx74R9Kt+sT+ywX5ip5U1b5JeMRz3gtgmTwApBzipUjKUznYoAJbtIz60dtfFhwIvATeH9UHjAB+RZKqE0C7qLQJXYKPjk73ligkjedkZJ7Tt6om0ObaH4LXTmcgGdyuNBCrDO8vtbG3DT4P6YbGtmTZNt6VQ3u4Yw1+q+5L6y11NGld6SklU6VhbTlJlPDQ5OmJuayA2xybcml4v+cjHXkZgztCmOPGmR5pG9SC/1FppGNZF6Cc26ixS7dZBEZGNaaHcHZofAEK+h5kX85f7h655t3FZaC0RTvHccMrwFAg5fL1vE/FILO1yg7U+1E//+ZKgvkXYHQIT47KJuMFH4jkK51/16/Gma1dV21yqrM5Ghffo7POSysrCpWftvGzZ7UWMX7Sps6DQrMhlvpHBNlsC/bB10M2ZD6NjB/SFRfacPI4YK8BUnAFfCXzZFqNsHCH7X3QBjHbRzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/5/26 10:08, Dev Jain wrote:
> 
> 
> On 05/07/26 1:05 pm, Andrew Morton wrote:
>> On Fri,  3 Jul 2026 11:41:54 +0000 Dev Jain <dev.jain@arm.com> wrote:
>>
>>> huge_ptep_get() can be handed a virtual address pointing to the middle of
>>> a contpmd/contpte mapped hugetlb folio (examples of callers are
>>> pagemap_hugetlb_range, page_mapped_in_vma).
>>>
>>> The arm64 helper rewalks the pgtables in find_num_contig to answer whether
>>> the huge pte we have maps a contpmd or a contpte hugetlb folio, and
>>> returns CONT_PMDS or CONT_PTES, so that it can collect a/d bits over the
>>> contiguous ptes. We can falsely return CONT_PTES instead of CONT_PMDS
>>> if the addr is not aligned.
>>>
>>> Fix this by aligning the pmdp pointer down to a contpmd base before
>>> checking equality with the passed huge pte pointer, to correctly answer
>>> whether the huge pte is the base of a contpmd block.
>>>
>>> Fixes: 29cb80519689 ("arm64: hugetlb: Cleanup huge_pte size discovery mechanisms")
>>> Cc: stable@vger.kernel.org
>>
>> Please describe the userspace-visible effects of bugs when fixing them.
>> Particularly when cc:stable is proposed.  Thanks.
> 
> Forgot for this one. It should be, on systems where CONT_PTES != CONT_PMDS
> (meaning page size is 16K) we could collect excess a/d bit state, meaning
> extra work for the kernel.

Even worse, right? We could walk 128 entries, when we really should just walk 16
(IIRC) entries, possibly reading garbage or even worse, into a memory hole at
the end of memory?

-- 
Cheers,

David

