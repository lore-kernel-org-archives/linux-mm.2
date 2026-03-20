Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3363C108B8E8
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C72A6B008A; Fri, 20 Mar 2026 06:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9778B6B0095; Fri, 20 Mar 2026 06:07:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840BF6B0096; Fri, 20 Mar 2026 06:07:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CDB26B008A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:07:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 228F78671B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:07:34 +0000 (UTC)
X-FDA: 84566014428.02.5AA5E6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 67AFE180009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:07:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Itu4E1Ov;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774001252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ie0HW15O+NabGZKzBru1jtHrPAhJ4YU3ll/S2+yA2A=;
	b=wtrLBbiSG1P3SNYVNENtSV5fQ8h5nKEBIjgYog33nCbyvmD4WiKHQsduG2wCBBpiQeyoRC
	EO4k4+B6SVGXCNNSrcCBURHHmXOVLVEsyEasy4rtohl8t5ie2HB8LwIPsbH4j8WOxA94uA
	jukg4AkfTAPpkvobDSM2xpaXYEJ5L0U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Itu4E1Ov;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774001252; a=rsa-sha256;
	cv=none;
	b=rBWdmYmADdz8mAN10+OPPbZbdQyn0LpWmeDNxWH2k/RWYDCh7oyi2gGZz+ehaSTPm2kfSd
	LqiF1JYpsSWFYVEQ3+IxRkJJhmu0xZwKJA4YBiIjJSYHD19pBGQHYUrkwyQDSNBDU3fHfU
	oRsBYlN6PHKm8cSDxwq3GHaZlIvGqNA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D3F8C60053;
	Fri, 20 Mar 2026 10:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37C1C4CEF7;
	Fri, 20 Mar 2026 10:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774001251;
	bh=HG/rGGoNtfmgAc4U0HGtP4/BW/VJOiLdcySiWD1qaxg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Itu4E1OvLJiu+26GVJzlvEDtBtdWiZGVwPy1vfejJdOfqX8M/kfUiaqmGh+KAGBii
	 +wRFlV+GkZReoPZH12gqN7AYwNEcZY7eodMEIvLIAoHECB48y07OwnLwBnysAEkqBZ
	 4ZUS7I3s2h5DWzhQk0zWWZu3W5FboJ0k/kY2/sZIC/AJHZHER//Sd8EfzIFRFAvi9x
	 Vi6woqgmAOxJaiW7lM+GjVlUoxtB+JtcLT+vzczaEnGNDAvvtH6vKMPa83D8pOkmim
	 AYJK71AsGQU31pxPdLX2R2UQ6+RNKHnKdNO4u/pLjs3KCxUGjVTtNDmJvPEi5DB9NM
	 AvCbTnAosP5ww==
Message-ID: <75ce12ec-b83c-4b5a-8084-6037d602aa75@kernel.org>
Date: Fri, 20 Mar 2026 11:07:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm/mprotect: move softleaf code out of the main
 function
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>,
 Luke Yang <luyang@redhat.com>, jhladky@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-3-pfalcato@suse.de>
 <f0ccf41d-16ca-404a-bb84-fe038bcfe0b4@kernel.org>
 <ypaiecdbqmma4imr3euccouexs4uecaacjr4aucv4vynz3xbrm@4xa343ivvazy>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ypaiecdbqmma4imr3euccouexs4uecaacjr4aucv4vynz3xbrm@4xa343ivvazy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 67AFE180009
X-Stat-Signature: e4g3yigyxjnpquqbnsk8uoik7q47cnoq
X-Rspam-User: 
X-HE-Tag: 1774001252-80956
X-HE-Meta: U2FsdGVkX1/1c5lDVxOosF4Kb7Zjv9hZhL3oFT9NTvQsvSRpYr4L+E1hIjHH6k7fpacp9mANCB5qCZEmcu5XI4aBG2cnBLmyLzv9J/MiK90aAcixnCyHEq6sJis2DyrK9quOfhNtoQlG1m926wWgWBPn6L3OnDbp4wW54swFkLBgncuyHCBs5PRGJsu1Ds5Cod/f9Py+5vbeESNhC8LtCnPahKofrJm4vU0CVR+g9hkTRkQ6xxNNXCJh87ZFik/Wv76OjP9fQriKhVJM9Z7KctAAkTMgC+EcZ2bsjVAh2mTIiczWczY9TeId3KGJ4R+N2ElfasZQNx62VGOk7WGBlFFEtMInuK7hL26VZfbzCVmhnwKh/WYu5BpCCYFiIFaS2I9YYfQB4LOb8oDT384TLwWpckPNYNOjSoY0bKloUMFCFIjl2YmGuoksWzgBPjmO+rOAW/wmndg23HdylMSEdYIhHQ3P/DriISzGJyO13MjHcdp/VvAc9zUmIIxSgGGQmbKK+1mLilJMimUBWf5AmpbMU+o4f0wvH70PlhGsD6JZNqZbbFuTc4DwKUgcmXKKwBHYGobztJJg/GxX79NOKVvYB4QPSoOkscxK2BNi3dcVhTCRofNiWKv6Y+mw83Zj6QjAfCZYHn6q3Ij/eozBd6hVA1S1cCYkUrMMjYHwYiEic7UA/FMwbd1mWrw8pJN7n5I1evsA3rTGAGRJtxg8NdiuYQHqD5nppCVLcZ+FPBQXUOQBn5+jmgO9jiZkRdK0kL04Qzsd9A3YAfKU/5C1Be0uuujv0T1t+4bszhb5WLoZ11UAXDeFiuhun5fJgvmECT7SjnLV3xlpPeJ7umpKENeZQ5Dkgf3IjfCXmTKGNBnwNkzDxZkIC3KQaKXlew7M93pWXxKyyKWS82fiJVNWlrl5g0ZegZubHdnK7AqZVUfUbq8Ix+IV1ydNpUeYScPRba4TYBJE1MODUqRsjqR
 qyyg6kuY
 TlIwHJasNVs56K48V2cM9rotwVyLGpYv4ceUFRlllT93LS+zIaVyxu91/iy6+qNe3dbzsUN1Gjx0XFIKk0MkkdZrMXle8PLtvqj/nIJ0UUapJRe82dKS7r/TwCSTW9lYWfCDQuQllgQc2BxZdc7q0VW7eL+NAvoIxk54mvPQMKPlBqccjxEsLhZbNUn24PbmVI1W7+886pl+bYVp2oDAnRvzmzAd5INZmpSFOlQRP/hBFXoWnnYCMf5PtnamLvvn7gukH7xs5F74Hwl6j1BiECGAABg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 11:04, Pedro Falcato wrote:
> On Thu, Mar 19, 2026 at 10:33:47PM +0100, David Hildenbrand (Arm) wrote:
>> On 3/19/26 19:31, Pedro Falcato wrote:
>>> Move softleaf change_pte_range code into a separate function. This makes
>>> the change_pte_range() function (or where it inlines) a good bit
>>> smaller. Plus it lessens cognitive load when reading through the
>>> function.
>>>
>>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>>> ---
>>>  mm/mprotect.c | 128 +++++++++++++++++++++++++++-----------------------
>>>  1 file changed, 68 insertions(+), 60 deletions(-)
>>>
>>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>>> index 1bd0d4aa07c2..8d4fa38a8a26 100644
>>> --- a/mm/mprotect.c
>>> +++ b/mm/mprotect.c
>>> @@ -211,6 +211,73 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
>>>  	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
>>>  }
>>>  
>>> +static noinline long change_pte_softleaf(struct vm_area_struct *vma,
>>
>> Why the noinline? This sounds like something that works good on some
>> CPUs and bad on others, no?
>>
> 
> If you don't like the noinline I can always remove it,

Yes, please. It's easier to argue about __always_inline and constant
propagation than "this code is too scary big for my CPU so I better do
an expensive function call if the code is actually needed".

-- 
Cheers,

David

