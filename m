Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B135606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 20:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aXI8LCOj
Received: by kanga.kvack.org (Postfix)
	id 930196B0691; Thu, 19 Nov 2026 15:16:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E19D6B06D9; Thu, 19 Nov 2026 15:16:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0176B06DB; Thu, 19 Nov 2026 15:16:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4FC996B0691
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:16:21 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFE2FC0479
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:16:20 +0000 (UTC)
X-FDA: 85452975720.25.266200F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 325C0180010
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:16:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aXI8LCOj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795119379;
	b=XBJdMEiR5c+19s1ylmtshZ6Dq/Y7xrU5u1ztUhFxULrFazUK8j6DfbAN82VHNrSQIIY8Yg
	CSDJ6QD4h4hnQpmNmwnAfp7mr9vz18C0/51JUrBqLyrq8YhsLtFQ4Ui2yjQwOac+/WulnN
	Bi02vI3jjZiG7JkcRj5ANCcdkhoGXgc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795119379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8guypKOYpjdcOq3rY5Ln184uhI7aFGCjLwkde4AGfM=;
	b=8Vvnjwu1abYtK7PpoeVPkSPTtTFAyko0Nq85GFVdQ62tMbLmtfPbzOU7Ug8D7inpBYjCrw
	vFzDDU4gvJgNbJhE/6SMHDVwZsYqaGv8XGHdz9coR7b5G77dUIX3uTb0t/YQFNrhtLN1F9
	ddTpultqOeImOjr37qG5J2KwcDyvCik=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aXI8LCOj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E74DD61387;
	Thu, 19 Nov 2026 20:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D611F000C0;
	Thu, 19 Nov 2026 20:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795119377;
	bh=b8guypKOYpjdcOq3rY5Ln184uhI7aFGCjLwkde4AGfM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aXI8LCOjjbrnYnc0RwqwcQVYjFYuZP7jshxcWA5lgDpS/oXj5bFyoisOI63BRuvSM
	 kMKtLeJLOkrTpn9ArQQOkh1eB1Zkf2LdQcRgjfAKp4N/++y5NRocK9cwepgmT6CYK9
	 c5tTCWykVPcHp1owpvG6vCkTL2wH0FYgVexpoqSj3AHN55XgHM+6x4NtYba3sFofME
	 rjTVVMbukye3C8vRRdAYbBGJQMe82ExTK95/BO4U48uQPFHQwZDxRXAKMI9NErTmmQ
	 yJoRO17NV/LNKzjOWYBxndEBLWU4mi9MqmECbUtFUInzr4XuLuY349L8yVCGJSHkwl
	 JnFuNI7P9jJLg==
Message-ID: <699ed617-8325-4c13-9579-81cd4f0540df@kernel.org>
Date: Thu, 19 Nov 2026 21:16:11 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
To: Dave Hansen <dave.hansen@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, leon@kernel.org,
 kas@kernel.org, dave.hansen@linux.intel.com, bp@alien8.de, rppt@kernel.org,
 stable@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
References: <20261113195536.2660763-1-gourry@gourry.net>
 <20261113200303.GA395967@nvidia.com>
 <179460249376.482102.14669935557901467762.b4-reply@b4>
 <20261114002027.GE3706007@nvidia.com>
 <20261113181025.6e8b9475b29c13d29f59e02e@linux-foundation.org>
 <20261115000005.GG3706007@nvidia.com>
 <20261114170127.3d29199864eb352d9045eaba@linux-foundation.org>
 <55034934-8aab-4e8a-a74a-b30c977670ed@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <55034934-8aab-4e8a-a74a-b30c977670ed@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Stat-Signature: mtb9k6eo73jacrd9tyx666rxgcyn6d5u
X-Rspamd-Queue-Id: 325C0180010
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795119379-674763
X-HE-Meta: U2FsdGVkX1/dwnubrMtdRkeUeWdoSAE8shvKaIRfJ2C8XSI3eLWESu+KDrNN46hcPyWsCXqXmF8J8S0RnL6qsEECFpBeUgy4LV5PzTFF56VB9NbMejy7qfSfO58QwJyQ0vB4h7KbDb5nrEJg+dNxDRV46euKvALL/7jp8GgR3uBQsouMk9nIJ+jz6cq/54Q3p0CxMaxdN8oKIINyprW1mujq84WSF4u5yWDW6FHm25K5jG1JI5pN5GwJe5D5+6qG1S02UHrYuwRCXHLY/J5/a7FLjfRvYD4Gwwt7OfopKRBTSHGlyQoX8/U7hev5O6IYwe/dPnhdoQAcL65I60NbX1P6uyAVNOhK3hwTFVBqJFtU8cELQ31NZGDsuHdExxjj3bhRonPzsRCa2gIKJ4XpQ2aMwhk+9NaWezMwfAs0hMFnnNcRBrmqgKpzKXlymTh2xeR/gTiSgIuGUJZ3kPSjVjNYSlNWJ6X5XFIOM1ZpUc6qO0WfmjLF++DuYjGusX2tVTY3/0xCsyDKk1L4/OE9o9pEgD3XzhuDGWJ5s7VFVtByxLifVlt8+9BXMZlDPrqpD9hM977fK2OkestqM3hSX6dWP9jQravEQ35iqOJmp5WNI5yef/YTrHFhvLG+EhaBAbBWArNJ0fp9wEgSgtDRbJ+C00mBORyO6oFdmAB0slnw0OeADIdaggbX4szxli8Vf3Z4TbV2eIM0O5KuLNLlyoDXXsczRtY+gi2tIMHZGWGXsgG4unt09Qj2ufjSlCruc+SB7vajkdGrpXpXmSfIoXxCWwABLlQW30BV9G69HLDl0In0wI+aRYKSkvFdGfiXK2P+rXE7nJZfPDptyKoz4nNRAAJwxZaXOz9tyFBBEAngRieLEbkMpbCeDUjT/gcD8GFF3i3dEq0f1+BaQlW8zG0/+Vaa7kGb4friq5Kxi+KzMTMxCGtjnlYbvATO9puQOF/UFRW5412X9zlWm17
 IAXMTT9O
 fG9L37fsrPtBmr/Ex3WgSE0Oa9nafoLIV4URERfgaLNwxupd+M+NFxsiQAkODGj0HuMH9Jevwr2TftWmfQWSsCloUX6dbJo0lJzbizf+wOXnRmvFs183pG4cyUA389E64tD2U0ivl796IhptdnR7c2Jj4rOdfYkKk0+O4v9Xtaono+w/VMU66zJujGJsB2hQOr9tCFm2O7uB1JINnhsDJK4SW/ScLb5jNh+MpCSHeJHV5cLGMZl0ImwBYZ2igIMp+xiE9Rr6/48bK2UIYMBblei+Q7AxMTw32IvW2BZ3tgX8xr1l1S/2xTUZelACXhwsL7JHoUWfFOQTBZPBIAVsJbnJ93+9i+rDhjw/zZMl23ksvsdo4HGWHuKktO3pKipZV4Qmesf6HNECJLuO8uGg4Hl/BiMyjhWQKfJ9e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 21:05, Dave Hansen wrote:
> On 11/14/26 17:01, Andrew Morton wrote:
>> On x86, a shadow-stack PTE has its ordinary write bit clear.  The CPU
>> rejects ordinary stores, but pte_write() reports it writable because
>> shadow-stack instructions can write it.  HMM consequently sets
>> HMM_PFN_WRITE.  Nouveau uses that flag for GPU write permission, and
>> RDMA on-demand paging can use it to grant device write permission to a
>> registered memory region.  A device, or an RDMA peer with write access
>> to that region, can then overwrite the process's shadow stack,
>> potentially corrupting return addresses or bypassing that protection.
>>
>> Reject shadow-stack VMAs in hmm_vma_walk_test(), including read access.
>> A requested fault returns -EFAULT; a snapshot records HMM_PFN_ERROR.
> 
> This is a fun one.
> 
> I almost wonder if we want to go one step further and disallow GUPs with
> FOLL_WRITE on these PTEs. There should be precious few reasons for
> devices to be writing to shadow stack pages.
> 
> Isn't this a bigger issue than HMM? Should the fix be in HMM?

I think we discussed this excessively after I raised it and it's even partially
documented in the relevant commit messages.

-- 
Cheers,

David

