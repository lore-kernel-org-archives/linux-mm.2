Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB657606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 20:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NKktgR4r
Received: by kanga.kvack.org (Postfix)
	id F28AD6B03FC; Fri, 23 Oct 2026 16:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8D86B03FD; Fri, 23 Oct 2026 16:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7806B03FE; Fri, 23 Oct 2026 16:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A26566B03FC
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:56:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E3B54014F
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:56:05 +0000 (UTC)
X-FDA: 85355098290.17.BB22392
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4C4F91C0006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:56:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NKktgR4r;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792788963;
	b=Yjg91l81UtvR0mNb0Da3nOXL3uUtbPtiz20LTaalwpg2hx6b985uUDqDsDCcw79KXyLNk0
	2SpXpz/2Gu3BxGQuF6habb5bZWGSD8joV7EmAJN2pjtkv2xZkp5G3Txs34kB0W/gqvKOeG
	zBzz8XC218/zDubpL7asWurd86HGus8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NKktgR4r;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792788963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a31hdiyyDF8ZUUv40jZBEIwm/U5+mj/EC+c4Mf/cga0=;
	b=gvRmNHggYuOBJbhQ2f/WZgIFkvRQMh8QZ1Qo/bGWN0jiP9ofUPlc3jU7r/iHkLX6ovwfjy
	OHFAJE0AwBgO8JIB+w8sd+zc1UwP5yJiCRjAB8uaGkakVd57cgYIf/Z5BhqeEtYGhVwFLI
	3V9WLsMqv8/9TLGxwGVESAiSfvoHYwg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C828860142;
	Fri, 23 Oct 2026 20:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4021F01825;
	Fri, 23 Oct 2026 20:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792788962;
	bh=a31hdiyyDF8ZUUv40jZBEIwm/U5+mj/EC+c4Mf/cga0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NKktgR4rcKUdiO2NkGJRqzAQyHyNqk4IJRrBJu5OAedX8PNttS1iKxSWrk4vI+QCk
	 YNzgXsxxdNLNEM0LOhDMdTdWBRlT/hiT8BXaWGx9CzvO241Sp7xjXaQQMlT+li1Vmk
	 xEV8BbhLNv3aETBLsnUYUea273eBkAXi2UlnleTBUcRzusje/zDVOTo7VpvS4HCzqP
	 XZZoc2CkOJIPULxNsLE8pm7OWICD3bKx8L75lOJptyqzWNQxaZmKTKNYlZZ0t9JZgf
	 /4WlgKEJZLnCIM0Tuna+bCKkOB1ER1mWz32qJhFlXkmDKNt4I8eWKojYMQm8qkFp7o
	 rB+6gAabFfuTQ==
Message-ID: <cc2e3af6-bb56-41b1-9cde-151797c3068d@kernel.org>
Date: Fri, 23 Oct 2026 22:55:54 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid
 PTEs
To: Zhao Gongyi <zhaogongyi@bytedance.com>, catalin.marinas@arm.com,
 will@kernel.org, Ryan Roberts <Ryan.Roberts@arm.com>
Cc: dev.jain@arm.com, baolin.wang@linux.alibaba.com, lance.yang@linux.dev,
 mark.rutland@arm.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261013093600.54995-1-zhaogongyi@bytedance.com>
 <daab2f45-56c2-48ad-a24f-aa4f889e4da2@kernel.org>
 <e0f60526-bb95-4d39-9a7a-72cdf32ca5b6@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e0f60526-bb95-4d39-9a7a-72cdf32ca5b6@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: otb8j1wx1szrzykgxykmwoszxfit7395
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4C4F91C0006
X-Rspam-User: 
X-HE-Tag: 1792788963-939521
X-HE-Meta: U2FsdGVkX1+5asekYRm3g9KXDlOEiAo+V8RgdW13yySj7BedNb1DqHqcAiobIYyTbZwubk4glXWvK25Bv4l3Z3NH6GV7VmaK6tKEJclzNHaWm0zqNJe3hNsCUTpoyHVuUNSaRzCLDRgk3SGDUnAGBT/+8HNzVlq5snV92AUVtRzQk4bjAiFcd+wWdmy18mM5Bc/m6er6HQ7FDB08rF2EY1YvFnT6edCbVLrq6UZ0gVfucOYacJJH+ILmqC2GI/sc7DvC6d7m0QCo6XmvDcr65XrtBbu93Eup01pwDhvQ8SIIEg2pO8kdonZ2sLVdvjAE3F+6rfs4+Zsnf+01ZWQ42azPQO06/6BnhQVAUYzPqz5vj9CFhtEMomLuUtL4dacWN4+LchGlSRN5Sr7XXv7UFLGClYbuh9Z94WiLFeM7xX0nkKSDXW7Fct6t5U6MyV5kSHGz/9hPG+Pb+vQRqAoJxbWcVj/k/4SBHQUjvamA9brkJkzO5q0d9IvCxjK5nwLnwvAQkj5T00p88E4buHwciIiupNOuCs/Rlsw418uwxpwtt5IoWikR1+yljOYsJfWOCaVEtaYPpiFqjUxa92wmXzm9+CbTlha28g1RFz9Qq/oSjQPAi/CFhhlviQFrVpQj8voRcbJ6qFm1Gqw0zNuwV7SU+pMNSHa5t2ZaNgT3SI0yqoB/PGhp3u18/SYa5HlhXocueAZQTaTthKw0xh9XfaJmRPtvl8J4sHTntyT8X8edNgpggobRqF7lEOIWR2JKA8bgqzBELBML6fWpCaGXDUFFSFuLQW2pCd52JRdJFQ/pVH4mE+jIITyTFAG7Tg0DXsp0/RK+jI3q5k4SdsTfvfYJtC3lIYFvmyXa3l3U/0QGFlmAROjTtdmJy31raiqfcqtxMYFOkB8pFebY3YQtj/r4fIH5Eu4Jyl7csUCxjVImXER4IYTqAgl6JiB2JcMHJjLgk35aYgz1b2k3jSg
 8EbLAoCo
 csTGcGkzWBmA9McXnqD4O03j4TrzOQph28iZhuNX89tvFCRyAsdcPlHEX2Wk+JtcoT8DtAgxO76hK5gq/+x/ySjGDA3WuEg5ZkGgNmFhLQSoIbOTTibO9JBj+DjTB/rH+XmW7IXwr3hxBZlhesGB4b2/uvt1EQZsLOd2sSTBSAv7kN9T2G85+p0M2tvmr04dpB54Mk7crsBnjKG6KkDIfaBQgrsvM619NzPnEQVHo0r4qD1yU0zCkVD9FOdk5HW6OtolH3JX/hkZoloVBMKgFhR62FYmu3/m/mMgo+EVY5M8qrSAm9M77BzPZIX2OwOk37uW2elACaiJFkhxuhTC2qIniKX1SZIAlBNv/vL7nPePhIN/azTZ/2jjYve7pF3VGAKHt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/19/26 09:06, Zhao Gongyi wrote:
> On 10/14/26 5:41 PM, David Hildenbrand (Arm) wrote:
>> CCing Ryan:
>>
>> https://lore.kernel.org/r/20261013093600.54995-1-zhaogongyi@bytedance.com
>>
>> On 10/13/26 11:36, Zhao Gongyi wrote:
>>> The transparent contpte layer treats PTE_CONT as software state: when a
>>> PTE has PTE_CONT set, the contpte helpers may align the operation to a
>>> CONT_PTE_SIZE block and operate on the whole block. That invariant only
>>> makes sense for valid mappings. Explicit users such as hugetlb manage
>>> their contiguous encodings separately.
>>>
>>> contpte_set_ptes() currently sets PTE_CONT from alignment alone. Batched
>>> set_ptes() users can therefore install present-invalid PTEs with
>>> PTE_CONT set, for example mprotect(PROT_NONE), NUMA hinting through
>>> modify_prot_commit_ptes(), fork() copying a PROT_NONE large folio, or a
>>> PMD split installing PAGE_NONE PTEs.
>>>
>>> This is not a hardware programming problem: invalid descriptors are not
>>> translated, so the hardware ignores descriptor bits such as PTE_CONT. It
>>> is a software-state problem. Some arm64 fast paths intentionally test
>>> pte_cont() directly instead of pte_valid_cont(), for example commit
>>> 9970a9a27ffc ("arm64: mm: implement the architecture-specific
>>> test_and_clear_young_ptes()"). Fixing the producer side preserves these
>>> fast paths and covers all consumers.
>>>
>>> In the observed failure, mprotect(PROT_NONE) installed a full
>>> CONT_PTE_SIZE range of present-invalid PTEs with PTE_CONT set.
>>> MADV_GUARD_INSTALL then zapped one PTE. The nr == 1 clear_full_ptes()
>>> path only unfolds pte_valid_cont() entries, so the neighbouring
>>> present-invalid entries kept PTE_CONT while the target entry became a
>>> guard marker.
>>
>> Hm, is there a good reason why we cannot just use the cont-pte bit for all
>> *present* PTEs, even if HW would not be prepared to benefit (!pte_valid())?
>>
>> I guess we really only have to make sure to shatter properly, right?
>>
> 
> 
> Hi David,
> 
> Right, there is no architectural restriction preventing PTE_CONT from
> being used as software grouping state for present-invalid PTEs. For this
> particular failure, making contpte_try_unfold() recognize something like
> 
>          pte_present(pte) && pte_cont(pte)
> 
> would make clear_full_ptes(nr == 1) unfold the block before replacing one
> entry with the guard marker.
> 
> My reason for preferring the producer-side fix is that the existing
> transparent contpte helpers mostly use pte_valid_cont() as the membership
> test, including contpte_try_unfold(), ptep_get[_lockless](),
> pte_batch_hint() and contpte_is_consistent(), while some range fast paths
> test pte_cont() directly.
> 
> If present-invalid PTEs are also considered members of a transparent
> contpte block, I think we should audit the single-PTE modification paths,
> rather than changing only this clear path. We would likely also need a
> pte_present_cont() helper: the pte_present() guard matters because the
> PTE_CONT bit position is part of the swap offset for non-present entries.
> 
> There is no hardware benefit while the descriptors are invalid, and
> set_ptes() can recreate the contiguous encoding when an eligible range is
> made valid again. For a stable fix, I therefore preferred to stop
> contpte_set_ptes() from creating present-invalid transparent contpte
> mappings, which also matches the pte_valid_cont() contract used by most
> of the existing helpers.
> 
> I agree that saying this invariant "only makes sense" for valid mappings
> is too strong. I will reword that to describe the current helper
> contract instead.
> 
> If preserving the software grouping across PROT_NONE is the intended
> semantics, I can rework this as a broader unfold-path audit instead.

Hi,

sorry for the late reply.

If we have the spare PTE bit, why shouldn't we just use it?

It will make batching over PTEs faster. And we care about that for present PTEs.

So I don't quite see why the stable fix couldn't just do it right away? Do you
have a prototype that shows that it would require significant code changes?

-- 
Cheers,

David

