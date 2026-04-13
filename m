Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87E2EF531C7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3536B00AC; Mon, 13 Apr 2026 15:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB836B00AD; Mon, 13 Apr 2026 15:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0FE6B00AE; Mon, 13 Apr 2026 15:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 99B7A6B00AC
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:18:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45F8D1A02F5
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:18:28 +0000 (UTC)
X-FDA: 84654493896.13.1028CBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1489D180003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:18:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y51oSv5F;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776107906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2ei49Kgx3/2Bj7NnLhtwQP7EJaCX+0nqfXStEQ5oNE=;
	b=3y3qPIdeBst/ZH4xFlq4PeMWANW5cRxrKweNkHvd5+eQvaKNOzJqzYkpo1tc8x5GTK/d0G
	15ixO8OvWRQlDvjmcMOARbYT8LVQ09ek7fipGNM8rzMp6hjLeIyFbaiFZG5dGb64MTeVpm
	vvyGthbKkbQl0b4XYUefMDp4x6r5tv0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y51oSv5F;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776107906; a=rsa-sha256;
	cv=none;
	b=ho41uWVbXGX+V+Pn4hrDoqh30lyXm8cLm0I1bNByLvBJHCKthnyrN7MRdqC1PEE2nfwWSw
	9mtzm4F2oscAeCWw071tgMQgWKsrnquT2AYiuZ93vu7JpRAptESmt0Ppaja2M1Y+0CPq9A
	/VtRX+KWm0QswzRX34w6zcUV3EWcB+Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E6CFF403D0;
	Mon, 13 Apr 2026 19:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E51C2BCAF;
	Mon, 13 Apr 2026 19:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776107904;
	bh=cDopfrHKIY5CWvgWtMsDFhixhLYI1yjKSO6ar8V8IMk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Y51oSv5Fn7/3bMuNcw5NT9B7MhAPp346CPj5F1js+nM9h9lbdObXV/AlLREPX3ZZa
	 x3SVN6+cIYe1wuEIY1o+CFKY44d9u/2/qfgsfEDE8BM0VHZRnae3DdLqV6azMsbGox
	 3GHMMz1nZW6mCQhQylwiNWZVSrjaDTx8s/wrDbWUoAHtYHYTshaDFxHQD9vMH3ct9W
	 3E+Awc/K0L+Br8emV94yXJopfPXn7RdF8wmJaxpBbPYdKeJF1Rpsph8oX7nb+0Y4Bv
	 xRtZE6TJ79pVP7u7ACNQ+2xHFY6yaW/MPzybwyKRELPR62hLrEVr4kg4w4DLhqCSoS
	 NF8Kh2ThS9X3Q==
Message-ID: <4d38d333-d446-40a3-b6f4-c4890bfd24cf@kernel.org>
Date: Mon, 13 Apr 2026 21:18:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 2/7] mm: memory_failure: Allow truncate_error_folio
 to return MF_DELAYED
To: Miaohe Lin <linmiaohe@huawei.com>, Lisa Wang <wyihan@google.com>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com,
 vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com,
 tabba@google.com, dave.hansen@linux.intel.com,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-2-92c596402a7a@google.com>
 <2f177e0f-2eb0-48d0-b48c-7a0a340caf5d@huawei.com>
 <adA_1zXLUBqmSHFl@google.com>
 <5c5dfa85-baab-5c0f-6f6d-b71abbe10ed8@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5c5dfa85-baab-5c0f-6f6d-b71abbe10ed8@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1489D180003
X-Stat-Signature: mjr1jo3itffj5bxsg7h7i5fpyge37u9j
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776107905-775978
X-HE-Meta: U2FsdGVkX1+RYpsDWjIhc03oTmL+ekA7MgI1Z/ZLFMVcFSOQtwFEpigQ2WpDLj383lfqBV/KjPadhvhHLyHo7cP0TkQl4swN+wGt+5OrhMo+TnI8a22SF09OfA9GjhwHBMNDN409mEAWO3rkkaelucF05z/8L6p9a0iVrGixjEgaVo/oi9LIPAZBxsnIK76EPhyT8p8JRAuXauYpXAp0QCQTAbEhh2FffpsjsrTFD/ovjhOz42WQOAAnguCkH3M/8p00HYxBVpPCkBuomjvVo/5ofeg+3xwpEnFZEimCdRTrsCTINkNsy2Ptoej3dZChAPNlsRhxWZz+51vWPBMUuSIEFdwBCvLILzAsbujlWFrxV+2PpmNPiOfdkXLwaJfdbN21YBCNFERaONifNdEti8eGMPao2ULzhVUAgiE5J6mUl29zk85A6JVKLNBd/ufO/WQz0R9TlhCl2q+VB458DFjZ+HROoSgt2RTDSb/n32zS7niE1YUqSCgCBb2Ka33SwOoWNT7bBKPFAd0mpm2SkMlYo2voDCuaq7yhSLXYEBbiPaWUsKweDjUkHbgqBPYkGfSGDoI0HMWWfXb2xe6qisjbPvBNymArGqrWZUU2DKoMPKGkwcoQnh9NVHZX5olLQQ1uS5HX4FftFGW/iYGAeNfS9zHaM+9xTWDGpkW3746GHFxeEbd5uiT2ax54J9RbI9SaqoDX0ns2AAB1bGHoPbpm+eQQiM0klKOAN2KSs0BcYlKnI4ynt36MB/SXvy2LX3pDLcFuQ+8qFqheUHpg+faDvomApvHUKqMUvrdfmMFAps40ouqpTPcG/rX4ofZzAVNMKjysGk8y5tJZrhZuIP0/MgenwpsP4/rLjNc2Rz99clGoj1NQKuNyyHUSoih6d0ZmdggqhoQsvJrVMoJ1KP0CBz5nmpJqYt8NvmBVG7gYNYyp9lAlw83/fiGXJ/M96M5RiCkSKSRTC2nQGbO
 N0YZi0Gn
 k3tcxWg9q8Kd55vB0HxMoLrq/cqy57fClLH5dHGeiAJmZAsTV7Xu4kPzP4kbomVLxzoecDZWDHBxWTLXz2EE/fI9GOFpQij9DQ8JJamildla7BB62VQ+azhrIs0MTnfGNeHA/5Eb32fz8wZuOUCeFp2s1PRDKGTJLXzs6scH1cz5WxEVSufR0vmteYzLs7tnNp2SAZowVKjXNYhPtHfQVfjL/TIbVO37yc7SFzcF559iUWu5KjWAcbzqtar7B2+s0mMdQ2DnUW2Na7Cfzg1ar38d0kkhi9SmfPD+TVGYbWmnFgy8ZgryyAhnI+Dd8OrKcJFIzFvqVfmAJZ2JSPeC0eJuoOO8xNwdpFnGwLsJqFRHDvedQXFjhsP7uF2A/kM7Q9QK+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/26 05:55, Miaohe Lin wrote:
> On 2026/4/4 6:31, Lisa Wang wrote:
>> [...snip...]
>>>
>>> Will it be better to add a pr_info here to provide some information for users?
>>>
>>> Thanks.
>>> .
>> I think we don't need to add pr_info here; truncate_error_folio() always
>> leads to action_result, which already logs the recovery status.
> 
> No strong opinion but I want to make code style more consistent with sth. like below:
> 

Yeah, would be cleaner.

> if (err == MF_DELAYED)
> 	pr_info xxx
> else if (err != 0)
> 	pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
> else if (!filemap_release_folio(folio, GFP_NOIO))
> 	pr_info("%#lx: failed to release buffers\n", pfn);

Maybe we can even make the failed here a "Failed" ;)

-- 
Cheers,

David

