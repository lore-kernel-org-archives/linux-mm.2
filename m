Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F593606A32C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HJyNJIVa
Received: by kanga.kvack.org (Postfix)
	id 1428F6B05C9; Mon,  2 Nov 2026 05:10:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F3CE6B05CA; Mon,  2 Nov 2026 05:10:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2CDA6B05CB; Mon,  2 Nov 2026 05:10:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BED6F6B05C9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:10:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45621402CA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:10:24 +0000 (UTC)
X-FDA: 85389759168.09.97F916C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 787B580005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:10:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HJyNJIVa;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614222;
	b=JEu7pSIeY9NLdC3EkeJX4fG8LFDTfrKQKunFEX3YmGRxJ77d7uP6IR8mYdQBPqfrxxR49o
	LkLDgmGcVv2ZCoB9pYEWv1asLBb0cC9VOFjwp1gbDY1di0z0p8yXSk5/JJ8lgN8+KTF/Ti
	IqjirOkfWdeKdhueYLarXwwuaDhWx3A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HJyNJIVa;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PH8c+vUr2qMHZasd7I5mMP2fuKotNi1klsbALagqctg=;
	b=zlEuBkHXRPOF3pV/H5D14iJjaSuxPCMHcKfnRg10cAGhPNHd+R3f2XsZb3QL6tP2Qo85Wq
	RkDdtZzMRI6uo7hyhTthzxY7GEnm4KWFvZyAimP9YlTjAJy8h5iY43VA3rkcuLXXNYNh9O
	pD0RBL8tpoidKsftTKvYDG5ekR5STfE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B2E540515;
	Mon,  2 Nov 2026 10:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685001F000C1;
	Mon,  2 Nov 2026 10:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614221;
	bh=PH8c+vUr2qMHZasd7I5mMP2fuKotNi1klsbALagqctg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HJyNJIVazbqTzWrUk8kDzEGk/1v20F9z35tlQgMyPWSHtF1GtZdEOIOxdICFB67Bt
	 WQcCYADRA67Clr/QzQO/ZUZplHzRxgNkIXrr7fktyLCmUwqmHfOHM6P1qG1E9aaeY2
	 YxORbWpenWBvewka4n/rXLv23cFu+m2USUwNrWZ9T/4b+4ePXnwVPxKhfr2PW6cgnr
	 nlZZCjNAvhdNOAhrPJ9cLuGsxvxskE34mCaVEPLt7PsQzrMGAp+F386OCka6qotHaj
	 Tvb0Jm/yE4N9bpRJyC5r56j5F6bYbuVp1tTGSPrLnK8NC6UkbD1F1QeVIpyJ8H11WE
	 qjPnvPiR3cu/Q==
Message-ID: <bd519d0f-9e00-4efe-a090-9ce81bd4ccfc@kernel.org>
Date: Mon, 2 Nov 2026 11:10:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: release isolated freepages on compound
 range mismatch
To: Zhenghui Hao <zhenghui.hao@qq.com>, akpm@linux-foundation.org,
 ziy@nvidia.com
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <tencent_869149E9C4305627F0ED654860AC4DDBC309@qq.com>
 <5d79db66-2195-4f8d-a721-e1756bc6ead0@kernel.org>
 <tencent_9125D3B8701AD20B318ED534FC1119659807@qq.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <tencent_9125D3B8701AD20B318ED534FC1119659807@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 787B580005
X-Stat-Signature: mx1se3ww6xj9tqy7u7q1fw17y1t3q1ns
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793614222-822360
X-HE-Meta: U2FsdGVkX199Vvl/Jtpw7KdUxBj8mF8xdLNPI9sxl4imFM2gtzaVmFftR9LPoFSCOtk74aQ+aIiVHlsJ/3yPEEOM6pKA6/F7VQ65euq/1HXp5vW2E3H3ggeCO1CsnpjrtCoTYE3MqRMxW54IfRM+Tf8+oUaW6pg+owbzd7ajGFfccr+XsMDzlZxORxrX4oE1hLumJuMlRpxM8eTzZ2zXKfBvT+yXZNQveKcJ3iDIKiGMdV542w0I5A5YnqSuQAUZOx/uJbWGIMeaETbJGq811h5P7hSMk5X7SPOmolU6vwuu2KzHXH/bvgPSv7Io8N7reHS75Q/HNUppwi+jn3VkQ/Jmj7TwSLn5gRawUpTJyZ0F3mLpo5B1kgvRzt8Q/TGQvnhzh6PfQx+OzMt5pVnvgfPJq38IfizhLfcDTTKSivmOTdUeSroA6PRegwTW3Bn6bfMpbwsPs0RafUzVUAevQ86ub4FfTBsocLfDpae5ybFOZERGC1NMvs+4piAF9O4qqTL61B7ufJEqzj42Nx7sHR11+GZLpIv6fzrlcExOXk8DD0gN1PU5q/CGxbo9ihsFfTv/T2sdiivhRIOrmAoizTE7PmZC5r7bA4gIoSH0YDUO3OG3ozFe3IFng8CZn7tUbxTrh2pR/MtXN9Q0C6ZlvfGC8Sn8jnsYeeIZjphPf021SzlT3Yp8KSOV5PDmvbNCOpnhVuk6W7hK3FiRYP39CTEeeBACOK3bafALWF2sC21VgG2O44s0WRm7HsTr6oOzXdsRctO6cl8PENIfvjb8kno1kDFj7EDbrBgxB11b7u81droC4/Ka3Aj8qKbkIC6VksB8fXItBbbTx2QcKa716oIQ2IQs1h0fepxUR6tCFzqqVpbFBtmIfMCdxlkUa9jvaC5K0Hz8wPpa6O7jcnm63BCpDp5GT1vPSiEA8eXGhJ9VMW9IpjMJWeb+SQztUJL2NEL/WzyAsnW90GGAjOJ
 bYsTuc9G
 In1zDrUrWIUD/kmbawW9pe+RTXQktiJH3lL5TPLCQwHI4gCa3zcF4srEPFYOCRe+Hm5jwxCb2cMIdagcyffeQ6Nd5m+2EzO0e+am0ZfBmRQHEvadoqFSmjKqAYg0TMa6z8kJn+EUUA5ZA9RPQvXFKaHgYUYJyX8M/9Om6bV3xgP7jNl7KqSw1CRP6aNSp+91E3HzsPsceuDBB6SrfKmeI5t2ubmTvoja0+mZcyYSgS5ly2Ho+/M1fJAHCA340YOlsKkqP6kLCGpl81LUaEbzYtDD7TtVa8XOeYED+vkWy3ePzlrZTZhdRb8IJcNrZ0t0wox9e3oBlq6cvKQiU2pTotzhg40exH0bsp7bF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 10:29, Zhenghui Hao wrote:
> 
> On 2026/11/2 17:11, David Hildenbrand (Arm) wrote:
>> On 11/2/26 10:06, Zhenghui Hao wrote:
>>> alloc_contig_frozen_range_noprof() isolates [outer_start, outer_end)
>>> before checking whether a __GFP_COMP request exactly matches the
>>> allocated range.  If it does not, the function returns -EINVAL without
>>> releasing cc.freepages, leaking the isolated pages.
>>>
>>> Call release_free_list() before returning -EINVAL, while the pageblock
>>> is still isolated, matching the cleanup already used when
>>> isolate_freepages_range() fails.
>>>
>>> Use WARN_ONCE() as well: the condition is reachable through the exported
>>> API, and repeated invalid calls should not flood dmesg.
>>>
>>> Tested with an order-9 free pageblock and a one-page __GFP_COMP
>>> subrange:
>>>   before: free_buddy=0, leaked=512/512
>>>   after:  free_buddy=1, leaked=0/512
>> How did you reproduce this? Using a hacky kernel module?
>>
>>> Fixes: e98337d11bbdf ("mm/contig_alloc: support __GFP_COMP")
>> I thought we discussed this in the past: if you are able to trigger the WARN
>> something is messed up already.
>>
>>
>> And indeed, same patch already here, SMH
>>
>> https://lore.kernel.org/linux-mm/20260629-free-pfn-on-alloc-contig-range-error-path-v1-1-496ff9ca22db@nvidia.com/
> Thanks for the pointer, and sorry for the duplicate -- I missed the
> earlier thread.
> 
> You're right on both points: the reproducer was a synthetic module, not a
> real workload, and being able to trigger the WARN means the underlying
> path or validation needs fixing rather than papering over it with
> WARN_ONCE.
> 
> I'll drop this version and follow the existing thread. I'll check whether
> the earlier patch is still pending and only send an update if there is a
> real delta on the current tree.

@Zi, are you still intending to follow up on the things we discussed in that thread?

-- 
Cheers,

David

