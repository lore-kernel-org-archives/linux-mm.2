Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E21D8CD6E57
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 13:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA1A66B0398; Mon,  1 Jun 2026 09:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52B66B0399; Mon,  1 Jun 2026 09:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42116B039A; Mon,  1 Jun 2026 09:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C37636B0398
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:15:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5B601A06B2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:15:36 +0000 (UTC)
X-FDA: 84831390672.28.3B850AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2AC3540019
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:15:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4sdvrBp;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780319735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfQic8cg02JJEuSFQSv/u6ajmnSdKmrqVqPMmLzXIZU=;
	b=R35wTseUNEe5uIQSzV8300pIr519T4qX1r+SYG1BRQegLSibKq3OTrEcu25r1Wx5bKukg3
	kUYGtTHNSYB66osxfArBpphPzr1tafP9yyLgoI65D8QBXiYLv0MugY5hG1zM4qTUeeXYA1
	1+MjyRyH0ZXQVavDtl2VoG+rcsWDFgY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4sdvrBp;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780319735; a=rsa-sha256;
	cv=none;
	b=PvN5XdUYdkG2YWjwqUBZNe0urlNzyTEucASEUHZbBNvGrKVzh5jQJsbZ/qtz7i6hTMnM2r
	ELgysjqaFBBWfagGf42S9c5q+7zqDUMLTO/yJw3vTF1Ll9YBuom354l/QX11mvNn6jraOx
	rhCduGQKVP3uHkXlrub9I0xkNSBB2pw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 341C260018;
	Mon,  1 Jun 2026 13:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1552A1F00893;
	Mon,  1 Jun 2026 13:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780319733;
	bh=cfQic8cg02JJEuSFQSv/u6ajmnSdKmrqVqPMmLzXIZU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C4sdvrBpAR+a+2Esvt0/7mq1AgEshnCO2JjncRA62xq6Yz7BHqaIslnEuFLLE3DW3
	 bn36BUA9G3QOipvzaTDC2Vig6mt7qaPTeqAkGmtCpvESOfLVXgfhNBqAybE1+1r+Wg
	 NBA9D3QGE3JScLJfkP4J4JZGz2pNqm+zGp0Ov7snSaAik/AmbJ140zqAF0wVeCi4K/
	 BX8MMSxoIUOLWGadEvDMVGvowRpRRrbyuP/cvZ7Qpp1v9g630MT2vPcegmwWzAC00H
	 qVcZUTYhVqGKSpiKfEe0s68wvOHq0iP8ogkJCJk+S++ajh4ZcyfKi+QgnDhs1Cfnhy
	 xTgu+BEP+Ipuw==
Message-ID: <d3c2b00c-6810-434a-b837-0707b0a11611@kernel.org>
Date: Mon, 1 Jun 2026 15:15:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Nico Pache <npache@redhat.com>, Usama Arif <usama.arif@linux.dev>,
 usamaarif642@gmail.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, vbabka@suse.cz, vishal.moola@gmail.com,
 wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
 yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com,
 zokeefe@google.com
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-12-npache@redhat.com>
 <b8380eb3-096a-49f1-9ace-99c1e75888b4@kernel.org>
 <CAA1CXcBg1su-bk3i_H+TW4-nTgvGSGqRNeC9MpQo7sGeH8ejnA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcBg1su-bk3i_H+TW4-nTgvGSGqRNeC9MpQo7sGeH8ejnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: be5jebqswdn9jyy8inwrhdpqm3obhrpr
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AC3540019
X-HE-Tag: 1780319735-893093
X-HE-Meta: U2FsdGVkX18Cb6h5tJVD4po6a8mHsh1NXqkp/tTtQ6Qr7/F/EKlpZ7vaO3gYLrFUJJPT2vqPM4c9rXwoPYI5PKCxh13JIeCXm+h8OXCgCnwrAYA5Ua+7u9zYB1hemyb2pun7+/LDn/ytOV/LTbs9DUm4vRX0o3mtXKJAeiGIAwjx3M56ZZX6W/mmBo+/BsbpyzXCCcjcidRC6b4BRyHQTF9Hy2x0R+gpkI4Mfyfg7AfhrLJkZ0afQ6qX5y3ZKrkkhISRY2bK6pHcw6XpU6xHKIyttYtGFGOJ7TfjAy4yxsYl42sc5ZiJhR4KWCr3QKOxhnsKkQ2P152+TIhZzhNYwUxv2gDlhczCcHU/dFXJAT2fgsK6MnA04WJH0TepZv0BZAitYjG42AZHXU4pyMJ2/HiDPeZSqzVkDHq/f2GscbdfVOzzDqPpCiuxUCIVDVbQE3BgAqRfr22VNF1j5e8Sr44RUGePCtAzb7iNE67Y5YXT9aa+ao6Shw3VWvAWd+G77iHdYPSx/7GOqdDf1thbUyJbweZy7KB5p1GkTiDexW4cd9/aqPagYDEiKzbosWFgc2BhZ/xIbBdM5J07LlL/UcmkclKQEScCvrTw2pO/Um1FLsf3MlVtU4phmLopsKQTpNCU8xxEz8VPBcfCZgfAN11oRE+aHgIto5Iqjr7HdeLxSJMOBCDKCYRBX3d3iVJ+YcdKj51F7I+y1TGMLRzKYeiJ9xg0iAb6r/OfJrH7qILsE7H7fppjuO0fNhbhvdWkqMvMJeqMHEl/AvfqPlhHAJE8a8JzxjyvGJen+nVzHirFJdH9ZUWn72qnIfEVJfyf6i4qjqn7HU+z5OkBzHvssHBscEErPlVJQf16r/o9Islw3nCgvB+9J9ejfXPU2G7RmrLIn+aw8888K4xFFVM4F0h/g+2eMGI0gCrceGICCmKDLFuTVKEdCNJzhkNHkZzMTMrS4KnZuidKGkUDUaP
 Z6WkDVI1
 UGXlf7xSKAPOIfi02uSRPl8e2OrcLeKa8Btk05pk+cvU+TbsKzlPvhvu+7xNxqSvhK0vy6q183oSurC0V3t94S/MEb3o3oI4ojwxXroBmW+X6FgkfgdK8OY6qMZdSJwnBkkcBefMMZuVpZFc2B1XA7g9d7wGn+vQKmiju7ai9V41/TpKnRlWo3PI9hDU8Y0yIDdWJKL9lkbwgIEwnr9aYK7TeWCPh3g75VPQOPqjV0+e9olr+ZIuRfkW/SR+FsF8KUDMrpeLcdCn0n6CsWcyPCMpX7aA1yP7VwdAqk4wjAQf4plkI8AMAg+LtJwNQbZqtY6Ua3Jcl1jA5rnov61BW6NxYK+bptl9P6tSOuUIEyLoJEQ7CUWBPzaV/3QP3ObTYWNos4KQ9XhEA21ahkTJr1tauEyYQC4tT45TIVE2SQUqS3C8F6VR/WPkYivFOxlvm7CaMRv+MFs3cFrx+W6cOzH6qXHT9Xe2VPfbnJQsGnxEv0Cc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> Reading this, it is unclear why exactly do we need the stack.
> 
> So I looked into your items below. It seems logical, and I think it
> works the same way; however, your method seems slightly harder to
> understand due to all the edge cases and more error-prone to future
> changes (the stack holds implicit knowledge of the offset/order that
> must now be tracked in the edge cases).
> 
> Given the stack is 24 bytes, I'm not sure if the extra complexity is
> worth saving that small amount of memory. Although we would also be
> getting rid of (3?) functions, so both approaches have pros and cons.

I consider a simple forward loop over the offset ... less complexity compared to
a stack structure :)

> 
> I will implement a patch comparing your solution against mine and send
> it here, then we can decide which approach is better.

Right, throw it over the fence and I'll see how to improve it further.

[...]

>>> +     bitmap_zero(cc->mthp_bitmap, MAX_PTRS_PER_PTE);
>>>       memset(cc->node_load, 0, sizeof(cc->node_load));
>>>       nodes_clear(cc->alloc_nmask);
>>> +
>>> +     enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, tva_flags);
>>> +
>>> +     /*
>>> +      * If PMD is the only enabled order, enforce max_ptes_none, otherwise
>>> +      * scan all pages to populate the bitmap for mTHP collapse.
>>> +      */
>>
>> You should note here, that we re-verify in mthp_collapse().
>>
>> But the question is, whether we should relocate the check completely into
>> mthp_collapse(), instead of conditionally duplicating it.
>>
>> What speaks against always populating the bitmap and making the decision in
>> mthp_collapse()?
>>
>> Sure, we might scan a page table a bit longer, but the code gets clearer ... and
>> I am not sure if scanning some more page table entries is really that critical here.
> 
> Someone asked me to preserve the legacy behavior (PMD only). Although
> rather trivial, if you set max_ptes_none=0 for example, we'd still
> have to do 511 iterations for no reason if PMD collapse is the only
> enabled order rather than bailing immediately.
> 
> I'm ok with dropping it, but I think its the correct approach (despite
> the extra complexity). @Usama Arif brought up this point here
> https://lore.kernel.org/all/f8f7bb71-ca31-46ee-a62d-7ddfd83e0ead@gmail.com/

We talk about regressions, but I am not sure if we care about scanning speed
within a page table that much?

After all, we locked it and already read some entries.

Having the same check at two places to optimize for PMD order might right now
feel like a good optimization, but likely an irrelevant one in a near future?

Anyhow, won't push back, as long as we document why we are special casing things
here.

-- 
Cheers,

David

