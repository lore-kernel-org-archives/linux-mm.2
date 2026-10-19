Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6563ACCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 07:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72DA86B0159; Mon, 19 Oct 2026 03:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE026B015A; Mon, 19 Oct 2026 03:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3F06B015B; Mon, 19 Oct 2026 03:06:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37ABC6B0159
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:06:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB228A0468
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:06:58 +0000 (UTC)
X-FDA: 85338493716.08.0E74520
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf15.hostedemail.com (Postfix) with ESMTP id 586C3A0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:06:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=hXWIrbHh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792393617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96Wm4D57LuIgrDtXs3jtILL79TgZtcHA3nY+j4YAW3Q=;
	b=UYxzg01iaUTJkadZiZkHeGByvZ3eA3qaXLl5qA/Ng1DHsb3a/YZWzrfSN4P1CgBTS8oWNm
	LCeCLm8a7aZ9LeLU4/V6OT49K0HA7XAIprD8x2IVAXJFXYLGovOysWmQNxVqjmvRsQKhYH
	dnHNBfaSHRpPPwBDtJyQ+swkCw0u96s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=hXWIrbHh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792393617;
	b=Xw60uzRNJrdaSkVwaSHqq8r0rjUNwxVqiz2ZVaFmHHw99IaDYktTtYyjraUZjuvqPnTRJb
	JWr+QbJoeHn1YOogU1FW8HXRn1AcCGmpIeGMAEi+7tYga2P5MHk+EbJ+eKAyj88B08AdCb
	r+DIJDG6uIcVCQ5R5SSMKMZMPGVGPLQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792393610; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=96Wm4D57LuIgrDtXs3jtILL79TgZtcHA3nY+j4YAW3Q=;
 b=hXWIrbHh/zoTrGqhiFS5hJfKXv7MRtu9h/fgsAkvpSItQI1ZG3FHO+G9k83wsyWDD4qgki
 PVEpHMONKYA3jenAosXFCEvzbFEqVwqDPSWlw27Ku4IedpYrk/BWxL3jjfTXQkArNftX0r
 wslhnH5fkcuTMGu9tfm5OcnI9J01SIfF9tKV8DfHzJd6+yuvo7/TjFbe1OnHc/3DSyahu8
 yrDImSeKhxMyZhCaJi9Z7uN3VI9xHFiyl6Fd7lXsSiXkTiIwFs/xP8IfpXt5LAwp1YEa9h
 fp6l9kbTv6lZ795Io88mkKpGU949+GbPPfh/1OuG54DekUD3Dg4Mnd6Di6fYwA==
Message-Id: <e0f60526-bb95-4d39-9a7a-72cdf32ca5b6@bytedance.com>
Cc: <dev.jain@arm.com>, <baolin.wang@linux.alibaba.com>, 
	<lance.yang@linux.dev>, <mark.rutland@arm.com>, 
	<akpm@linux-foundation.org>, <ljs@kernel.org>, <liam@infradead.org>, 
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>, 
	<mhocko@suse.com>, <linux-arm-kernel@lists.infradead.org>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Date: Mon, 19 Oct 2026 15:06:26 +0800
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid PTEs
Mime-Version: 1.0
References: <20261013093600.54995-1-zhaogongyi@bytedance.com> <daab2f45-56c2-48ad-a24f-aa4f889e4da2@kernel.org>
Content-Transfer-Encoding: 7bit
In-Reply-To: <daab2f45-56c2-48ad-a24f-aa4f889e4da2@kernel.org>
X-Lms-Return-Path: <lba+26ad5c188+a0165b+kvack.org+zhaogongyi@bytedance.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, <catalin.marinas@arm.com>, 
	<will@kernel.org>, "Ryan Roberts" <Ryan.Roberts@arm.com>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
X-Rspamd-Queue-Id: 586C3A0003
X-Stat-Signature: 8fmzu1n7bqxubtfa13qf5okrcx5znh9t
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792393615-904125
X-HE-Meta: U2FsdGVkX186Ds69YD4mxu1ZThvUnwBP+y9+MXxwtrbQgCsfzh25/NPvyzTXotLt6a5ZwRIk+f0+AfhP6PBN5jfQRVYJT2lCLnyWLq5/lhaJgpN39IRce6uHR47P4GTSXq9AFU3BcKsjaQIZqfYN+K0e7sb+2fifDIykMItOtqlfsYH7FFF+kgiA2+obI3uc4J+2ZFKwjjwcmMLhN7R8/QW+gL1T2J9/Jb+HjMAGpDKeKNavE1LK5ARqy4awNVG1iQxiOg9ReA9wfWmvW3WBo2HnPOZv53WH5QXPNHINcrSgN7G4Ua35nzgg4d5TUINVHjRKJr0uGcd+rpYqgYQDgeaNd34PTENaKFw4xGbPoF4yhjxqXMICEFUV8uouaidE2g4ct0Ho5xBz4Iq1p8cK8LdE+d+yvdoDcKpPISLwJTkcVyxlR5PiWP8lp/BLUdvcqO81Zi73Ha5AJTD8MlknCOboY1utyBypkVsuK/kS8efedfv4kXw0zR2MciqQSjL3YdzQcCaNfL4eVoE7hU0ydNX4EHRg6jvPhTQh1EU28rbq4EWvqMqgkCiy9QKTyg4Dc+8xKxpZG1aJTg7X/BccCtnwnWXGqdQ4HQJ5JNKyF4ID7WyMMECQfHtY1WjMu3cKMaSHld+5DhSSDaXOm8URomwzo4fHNPT6eI4SE3T5PcxbDNuN6Hi9UIrOz9xsh6yNkw+ie3+sX+W1HhXS1X+nTYdZirIdrvPM+gGoDq3iPsrgGJ8nLR5GE0llSHFK6t+2fjaDKAC/0eiv/cmRrLYp+TEMrlycGeqb/4HFOcQ/NsG4tPuKThA95UM0+FSK39Ma0MLjrygswlGaEqNYpUFU9M65CbKtVEt54+0TyqAOEMTOqTHJEr6xp/gFIu9ZINYh02yPZxw6//tMKy/FFMHHC8KS1oTXI+vNCzdHIFp0reQxxOO0dqLZk3daNrNEYDTgUmGonJUoWZ5f6oMEssF
 moTe2k+x
 IMZyfyNT4A1SLVM1I/zS5MQUyTmhHpSUf7RBMdeejTgYII7s6TKDGRfpo3gKFhHDf3KuIlvgfRJL1Ytnx4328Z4v+w9z8D0jPaIu8E6NvUZ7+gTAgmBfRfU/D5RLBGg2JtTBWhpH7pWd0CMyh7Nz23NkWUdez/VJvw/TfcedI3J9lAcukCycnrO3fKafBthmW9s26famRxlASmoOHlLclNBuzL+kmAS2J0zJ2RU56x+hRkYRqdB6YM9gvsVROXPqun0Y+dMopzrnPWmydHTD4lK4uYw2fcuspPIGwse7QpVLnCt18g9sMR1tIZIapP/MC3M5e3hGCoPFjnIzyprt33RH/1UKxmT9byedVrH3iOkdfNXPYLfcu1gdmeE05AUFC8jRR+2SCp7eK4X0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 5:41 PM, David Hildenbrand (Arm) wrote:
> CCing Ryan:
> 
> https://lore.kernel.org/r/20261013093600.54995-1-zhaogongyi@bytedance.com
> 
> On 10/13/26 11:36, Zhao Gongyi wrote:
>> The transparent contpte layer treats PTE_CONT as software state: when a
>> PTE has PTE_CONT set, the contpte helpers may align the operation to a
>> CONT_PTE_SIZE block and operate on the whole block. That invariant only
>> makes sense for valid mappings. Explicit users such as hugetlb manage
>> their contiguous encodings separately.
>>
>> contpte_set_ptes() currently sets PTE_CONT from alignment alone. Batched
>> set_ptes() users can therefore install present-invalid PTEs with
>> PTE_CONT set, for example mprotect(PROT_NONE), NUMA hinting through
>> modify_prot_commit_ptes(), fork() copying a PROT_NONE large folio, or a
>> PMD split installing PAGE_NONE PTEs.
>>
>> This is not a hardware programming problem: invalid descriptors are not
>> translated, so the hardware ignores descriptor bits such as PTE_CONT. It
>> is a software-state problem. Some arm64 fast paths intentionally test
>> pte_cont() directly instead of pte_valid_cont(), for example commit
>> 9970a9a27ffc ("arm64: mm: implement the architecture-specific
>> test_and_clear_young_ptes()"). Fixing the producer side preserves these
>> fast paths and covers all consumers.
>>
>> In the observed failure, mprotect(PROT_NONE) installed a full
>> CONT_PTE_SIZE range of present-invalid PTEs with PTE_CONT set.
>> MADV_GUARD_INSTALL then zapped one PTE. The nr == 1 clear_full_ptes()
>> path only unfolds pte_valid_cont() entries, so the neighbouring
>> present-invalid entries kept PTE_CONT while the target entry became a
>> guard marker.
> 
> Hm, is there a good reason why we cannot just use the cont-pte bit for all
> *present* PTEs, even if HW would not be prepared to benefit (!pte_valid())?
> 
> I guess we really only have to make sure to shatter properly, right?
> 


Hi David,

Right, there is no architectural restriction preventing PTE_CONT from
being used as software grouping state for present-invalid PTEs. For this
particular failure, making contpte_try_unfold() recognize something like

         pte_present(pte) && pte_cont(pte)

would make clear_full_ptes(nr == 1) unfold the block before replacing one
entry with the guard marker.

My reason for preferring the producer-side fix is that the existing
transparent contpte helpers mostly use pte_valid_cont() as the membership
test, including contpte_try_unfold(), ptep_get[_lockless](),
pte_batch_hint() and contpte_is_consistent(), while some range fast paths
test pte_cont() directly.

If present-invalid PTEs are also considered members of a transparent
contpte block, I think we should audit the single-PTE modification paths,
rather than changing only this clear path. We would likely also need a
pte_present_cont() helper: the pte_present() guard matters because the
PTE_CONT bit position is part of the swap offset for non-present entries.

There is no hardware benefit while the descriptors are invalid, and
set_ptes() can recreate the contiguous encoding when an eligible range is
made valid again. For a stable fix, I therefore preferred to stop
contpte_set_ptes() from creating present-invalid transparent contpte
mappings, which also matches the pte_valid_cont() contract used by most
of the existing helpers.

I agree that saying this invariant "only makes sense" for valid mappings
is too strong. I will reword that to describe the current helper
contract instead.

If preserving the software grouping across PROT_NONE is the intended
semantics, I can rework this as a broader unfold-path audit instead.

Thanks,
Gongyi

