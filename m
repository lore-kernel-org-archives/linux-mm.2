Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 966FCCEBF92
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 08:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA67F8E0021; Tue, 18 Nov 2025 03:51:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57588E0002; Tue, 18 Nov 2025 03:51:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6D018E0021; Tue, 18 Nov 2025 03:51:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B38C98E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:51:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48B89160438
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:51:48 +0000 (UTC)
X-FDA: 84123109896.30.C2797B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 860A380003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:51:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IwveRkhR;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763455906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ko6w8NRuUOab8gjKo5K8KVmFbAa/z3euDZDeRBJOjSo=;
	b=G8dBlhCAp79TF0bfk/ZDWD6ejELC0Q5hTz7pbZcOeQIwbWbw9WkVpjsJvzZGotiK0kXqHm
	rdpizpE0q4jTjKvisQ4QXI63ep3eCx8SJ4rJjZa0l6M7WueF88R+fVJ4fmUz2kmcECyQOX
	W1z1ucAEBuU+glk6WFej/XJZMEyJCEM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IwveRkhR;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763455906; a=rsa-sha256;
	cv=none;
	b=Sw0N5mAfCMslzKHA7ZFpDzZpprqkERTu2u5ugvmhdQptoGO1eL/lPVblfvLs0YQuFu7cYt
	tN9WJd7/T7Z15KyaNeDyAj12Sif15PpuYAkHCS7UFt/YbWN4LzDhdf7f6xO6UGVJDoHNoS
	7D44jD4/krPK8DE47B19u6KklxZAne8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EED8408F4;
	Tue, 18 Nov 2025 08:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B775C2BCB3;
	Tue, 18 Nov 2025 08:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763455905;
	bh=qvUA4igN+3L19DyfGE1idHMAssgfS6Bs6bYW7pr0XHc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IwveRkhRugwYpdfit9oT2x8PUOOCVrEXb0545F/qsp/2w4Z8PpQNCqP49Jo5KbUFD
	 plXuA7r0nSCTJxZdCV8FxqKQYl2sYBBBNUHXLNp8ixPMjXK67ca8ZXMO1u4rairRc3
	 cUTgW85RYCXI0MwMUJxOAsAOMHgCnXJh1JXQUERyVbFiUOOhLNpEwchHlavt0AdRQc
	 8fDaSxkhI5AdC9sA1u8+58UuIT0Ce+uFIr/YOTI0q982Tj7vVAim/ZVsOvr9tYrGcG
	 GcuKpx/gCEDUdIewKXNvNPbVawUqRjyltsq1vinrRty3tgnG8AdcES2vXyfVSmUaLx
	 LLxYTWBXADAMg==
Message-ID: <7f89c0cf-0601-4f61-a665-72364629681a@kernel.org>
Date: Tue, 18 Nov 2025 09:51:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] Extend xas_split* to support splitting
 arbitrarily large entries
To: Ackerley Tng <ackerleytng@google.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, michael.roth@amd.com,
 vannapurve@google.com
References: <20251117224701.1279139-1-ackerleytng@google.com>
 <aRuuRGxw2vuXcVv6@casper.infradead.org> <diqztsysb4zc.fsf@google.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <diqztsysb4zc.fsf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 860A380003
X-Stat-Signature: x3gr736g9ho57ffinqyhqp7f5aipgxxe
X-Rspam-User: 
X-HE-Tag: 1763455906-997244
X-HE-Meta: U2FsdGVkX19aQxJBfGwVU74N/N+QlB3fYNtWH8s0w5rai7sloIi0o3aAfqORFrEarxRM49DgloozPufhpNC6HBIGbnXD7hHhJhAT8izyA2+S0yXbKseLWTWgiBZwPyWamU4TVtoXajaehJcSaC4GUQ5BNFImS9ZT0iGlvtsDpBBGLQZLe3EbCTz4aPwOmNQaiQo3eQnIIr4ytl9BX1bHdaSugwTSRjix/TfSRSxjxoox3+kXn+pggL7M1Zoz9VpaKNjjYJTiv1tDkavF35YSPC8PKW+lPQusLBoAyqc3ytxRDHIji664k1YOrTGNt42Zn7Pg5UYN0ymJd1FrDvFunj3poySBI10NnIw2+MnOlsKt7c4iOT6XBTks0xSAmGUsgb5hSdf/9vD8gWF3PNd7dS8yfxIeGZ/GNoEQ53iA/pcoXUvOQ0YzFEh6sxDcySbIf7fAZ4+yMJAlzfyESAWMDLWEIzMXVepKebPJj1L9OuUbRZRnW9v7JYRwraFZBQdp5/cGJkSIP4vaE1JFbUGBsAHbL4nye9GsJNRDHpv+08TpceJVUEMd/NV+AaznbsNlvQ3vSCuaMF6r1a/NNnjPmu0lssoeS4IbkIDEyqf2Y6RMycqmWVJnzuv5nnxR3WEq5OsLU8+apzL6K0Tuu1+xPvztj1ENV+AZ+YYaIO+IWvVAsgIjd0N2QFDcFEcr4awqY2hpmLmZe/tgu3fhsyppg5TSar5GJZQkxVQoFTaYYY97UNCHVascfsNQwBEsn56ZCax3R8yKxPhUwSN5PaEop7bCJi1WHfmQi612wg+vlNymKcp9aUhhHgyxTwEetLezn9smR0T070JBGD68X1cl57FAJiGJdtaXCFsUumC0I4ewQlEf1+enYoqWcezWOhy4aPANmgjwloD+ZAeoX95XJf9utKwGqY8N8okJhBSGIEAANI51fsC6dp+eZXPtpG7pTTx8uozclnbrNllOYdz
 7rkm1O+z
 VGlegm6ecQKnZ7iLZz7L0442miKyCmveq4ZKwfREzw2UYjFOALAFKhGua+nhxwJ4jdCvI7o0+pa9QUq/D/kfjDn7bhr2Io5lPpasHB1d2TU1bi+CQoF3IE9sfOTncFN2biHzgmI+mslwN1S+7B5Jckq+P0475lwhNFMstuMA7PMUGLm5eglCYRpQQ0x/U8Koh86KuyRW1FWAHP4XuHPIGYU8/rtEodYn+rcbsYcz1oF2qpywzm/FZECrY5g0c9/8WGMGb5G7P2KzQ0fO/t4JVKK3MhePxp2lJe/UiTOuFpeZIt3qc5pPCJhpH7URNaaw8mLEHjoIiTH5qIKqM2BwUfLVZ1d43o+NKQbsSjQQ/5R0ljog=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.11.25 00:43, Ackerley Tng wrote:
> Matthew Wilcox <willy@infradead.org> writes:
> 
>> On Mon, Nov 17, 2025 at 02:46:57PM -0800, Ackerley Tng wrote:
>>> guest_memfd is planning to store huge pages in the filemap, and
>>> guest_memfd's use of huge pages involves splitting of huge pages into
>>> individual pages. Splitting of huge pages also involves splitting of
>>> the filemap entries for the pages being split.
> 
>>
>> Hm, I'm not most concerned about the number of nodes you're allocating.
> 
> Thanks for reminding me, I left this out of the original message.
> 
> Splitting the xarray entry for a 1G folio (in a shift-18 node for
> order=18 on x86), assuming XA_CHUNK_SHIFT is 6, would involve
> 
> + shift-18 node (the original node will be reused - no new allocations)
> + shift-12 node: 1 node allocated
> + shift-6 node : 64 nodes allocated
> + shift-0 node : 64 * 64 = 4096 nodes allocated
> 
> This brings the total number of allocated nodes to 4161 nodes. struct
> xa_node is 576 bytes, so that's 2396736 bytes or 2.28 MB, so splitting a
> 1G folio to 4K pages costs ~2.5 MB just in filemap (XArray) entry
> splitting. The other large memory cost would be from undoing HVO for the
> HugeTLB folio.
> 
>> I'm most concerned that, once we have memdescs, splitting a 1GB page
>> into 512 * 512 4kB pages is going to involve allocating about 20MB
>> of memory (80 bytes * 512 * 512).
> 
> I definitely need to catch up on memdescs. What's the best place for me
> to learn/get an overview of how memdescs will describe memory/replace
> struct folios?
> 
> I think there might be a better way to solve the original problem of
> usage tracking with memdesc support, but this was intended to make
> progress before memdescs.
> 
>> Is this necessary to do all at once?
> 
> The plan for guest_memfd was to first split from 1G to 4K, then optimize
> on that by splitting in stages, from 1G to 2M as much as possible, then
> to 4K only for the page ranges that the guest shared with the host.

Right, we also discussed the non-uniform split as an optimization in the 
future.

-- 
Cheers

David

