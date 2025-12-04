Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01D66D1F9AE
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 10:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346B26B0027; Thu,  4 Dec 2025 05:34:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F7686B0028; Thu,  4 Dec 2025 05:34:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E79D6B0029; Thu,  4 Dec 2025 05:34:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 098DA6B0027
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:34:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D83652067
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:34:34 +0000 (UTC)
X-FDA: 84181429668.14.304F960
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7C3C880002
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:34:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KmUkPc4c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764844472; a=rsa-sha256;
	cv=none;
	b=ogTbMdkVDeSbjWAyo0HdIixBtaxDJQ0ADhu2nnU0EcePpUn6ke78fxwjjFfRemTLrx5N6j
	072pTiZ8RWAkCKCd0J1xCYO2mVxQCHzJNibtFQ/V5nAddWnGoGyhMFJkfPritqFV+lSkR8
	lF/8GlIke5owMMvPthRY2W49JUI6+4A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KmUkPc4c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764844472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3o0ORDO/48qgx//Y17G+zNlIJsffnbiH3gN3t9bTHg=;
	b=5m4XCH26kRNI5TaoJ9TixJy0PuhCBpI7BS5P5JiBb9qZL3pp2dbu1BdDd0jw8pCqtfmPtH
	Ww71JwgiHR5NS0sP8Rgd90Qb/Q49kIRY0TSWlxQ/rnsIzR79gJGSnyK8HKZJ8V6SwAWEcE
	lI0cC0812ejMxdwVsUJpwh1orU8wHR4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AB07440D2;
	Thu,  4 Dec 2025 10:34:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F92BC4CEFB;
	Thu,  4 Dec 2025 10:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764844471;
	bh=9fIl0Nc3fq8oA7vLceVddLBUKc6eKPFKzK6/oiJIcA8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KmUkPc4ci2T2TIC7hVVmPg7QcDWfUF7A7vjx4SXZd5APHYI6p0EPA06UBSC50WVqc
	 /s+JLtrUlskFkUdrCqubXPPWEu5KXhJTFwrbHojtY5JwrsOwAGZ4NdeV7PeflZ0TYs
	 L3Mz2gMd+iBDZkgF2m6PMUnmAphl96Zvcv0F3qrAs/gxAw0PD7I9Rmsa9+1U8BOd3f
	 EJ3h80r6wOkGvhGP7O9wt91WJ/WWkZGkDNMwF/5Jto53QfXvsKW5+0y94+nQL+M5NA
	 BVcCB9XMrOqiqreetMRPvdYyS6BUi++wGc9KW4M1vtA1UoBjjTay792aXNHHgmyE+m
	 kOEr2FN/chDSQ==
Message-ID: <93782526-c198-4590-b96b-c4f630b8ecbb@kernel.org>
Date: Thu, 4 Dec 2025 11:34:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [v2] mm: shmem: avoid build warning for CONFIG_SHMEM=n
To: Arnd Bergmann <arnd@kernel.org>, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Kairui Song <kasong@tencent.com>,
 Christian Brauner <brauner@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Guo Weikang <guoweikang.kernel@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251204102905.1048000-1-arnd@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251204102905.1048000-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7C3C880002
X-Stat-Signature: aoy69osmnbga8t1xahs6io893x94e6ib
X-Rspam-User: 
X-HE-Tag: 1764844472-676141
X-HE-Meta: U2FsdGVkX180fM1s0T3mild88pTWbBUeKZfcRvQF/b+kb4yO4Tlb/7o1zCrbUjhW+w/DFSHthnJDfV7UpU4ecqHQ+PEWnSMkULBYUXphL4Xh8ATrVtJ6Cwv8AhBuk0ywTWmRasxDNXpN2USHQhLYZQeF3YQC6wM+q+WG7XdtYpyRPwtPixcu5TMw9mUtC0zBKXQFx96s4Uo9ae+ALEslCWVOia/5Zycr74gJUtqYGSPYYBwZ0HIJwQY2yWsrmdpMOYWMdaAD86YJ3XLqo7X7SfjXz98U0OGSk0DLnBLC52yK1RZx9ofpcBCvddW8ZmDDMa+DLBr2+rrXXUpmokeVRnc5jOgmvYkDAQHSb5SOO6Cw7WEhXhXUc8PTuKXbSNqC8rg+vQ5pIqHXfFzkD1FTsoFz93WZQ0WMThJ2zIXSnnhbwtY29l6Sr3P/2dq0GeFa7vKodhdyQyS+8YiNmVga7WIUz870DsE/nMNLzt9N8JxQ9TzanBGO1WyqTYwmqem/QhuFh7WF/lE12Rkgdc9VhqvUnGPqUUme/+aB27ZQlE9OVVZj7tKavCCNZ3fk6w9fH03d6yw9KAsGSwdbHCm3nDZmwqzQleGaL37V6K6+CfhykFyJ7Li2I/1TdDXTstiDFwX762+1T+0hSL8qoorxZPMgZ1r1gBmfW9kHQUYpyJ7HAzUuhPhk1ycnqPXZIlD3ZFx3+vziAdXZD1KN+nQkNp/uX1LFuPZDJhmVS4pVpm9gOoOuOSpw6U0GO71WS96dG0Fb3SSwI88um0sQ8xkup490CQTQx3f1wWP/j3yOWmXHpi1O1jovHk/qoo/8aREEOhej0Yyxa0zpS9vascFBR5/0ptVDq8rFf8ZeXqr643GMTSAoEKaZYypZU7yrutvTDMOJHhKKCgjE8xD0iN4z3Q8Q/KmNY3WhgO2x23HRt+l8gGhZfjsdLRRPdzKPFEX9SkNNfWXmKdZ8rIlgiOw
 JdCRuyCT
 GbUTl96mLkvn9YRWCFh/htxhpC+C8YrNhicjtzawZl01m4NyUmvpjZWslErTrwCq3gNcGabuegx87n5ITkOaGXMQ1j60s1y0OicIFk/MEF9zMm8QLf369E8RcdTmIjkfXOJxojkaiU6IGHd7s8ExcH3bPHu6UyUJNZnQlgS4RtKuEXivzGwBGKSMXXhcRMqmCZelPSyHwUxVDSkyPrTqrBae21PU+3LQtnQwMUuhXIh4Ht7HTj5fSNGrg/rgzOWZCcKxm1mlaVyGuxwAkMOxgeeTWMaq7odLbeGHpUSA0oX9Dt7jET63CORShIXdv+Movt2E3ldHKsKJaKY05GsWQx1KvtNVQL4hrvrgCxyqOVCN1lOCU30kU6/OyOrrkVoshDRFItu8oRfRecJVNbjgnElJjyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 11:28, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The newly added 'flags' variable is unused and causes a warning if
> CONFIG_SHMEM is disabled, since the shmem_acct_size() macro it is passed
> into does nothing:
> 
> mm/shmem.c: In function '__shmem_file_setup':
> mm/shmem.c:5816:23: error: unused variable 'flags' [-Werror=unused-variable]
>   5816 |         unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
>        |                       ^~~~~
> 
> Replace the two macros with equivalent inline functions tto get the
> argument checking.
> 
> Fixes: 6ff1610ced56 ("mm: shmem: use SHMEM_F_* flags instead of VM_* flags")

That's still not upstream, right?

$ git tag --contains 6ff1610ced56
mm-everything-2025-11-29-19-43
mm-everything-2025-12-03-23-49
next-20251201
next-20251203
next-20251204

So we can likely just squash it into the problematic commit before 
proceeding with it?


Thanks Arnd!

-- 
Cheers

David

