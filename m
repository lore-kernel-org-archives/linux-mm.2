Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41F63C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6119E6B0093; Thu, 10 Sep 2026 07:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9F86B0095; Thu, 10 Sep 2026 07:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8F96B0096; Thu, 10 Sep 2026 07:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7AD6B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:23:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B368A4E8C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:23:26 +0000 (UTC)
X-FDA: 85197616812.02.0FC1850
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id ABB9C4000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:23:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T3rhYIz5;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789039404;
	b=CWvjwhnrmF7UcaJO2X7m6sfFJNyi+jT/es4RZMfrrReyVCqRJI0H5UnbfeBUVm3OHnW9nC
	d8PUm9Malc9j6ihlmfqyFSTLSxq8Q8+NfL3IaynKkLRvyKO2rV1elsg2m0lZZqdTeNxyu2
	gCu9mKHF8Vx2m9Zg5f37PyA6x6FdvfM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T3rhYIz5;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789039404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E7/3v1GrknKuNpa0yYaqMVP9wTXrVL+HTHd5G2Rj/ek=;
	b=D9E4aRZF8Y7LI7TnNlmLwkvRQOyee8ZTclImgCVU2P1Tf001sppG76aX5ieH+fxfQH/QX1
	82rT68C78BjtNGkRjx37MIHGbewBASj+pskgrDwl+mz3gN9idVb5Adr44te2b/HtjI2oVY
	8cRnaNH3qPh8ZBQFNo1+M2RZt5PvEcg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 37936600C8;
	Thu, 10 Sep 2026 11:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B2C1F000FF;
	Thu, 10 Sep 2026 11:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789039403;
	bh=E7/3v1GrknKuNpa0yYaqMVP9wTXrVL+HTHd5G2Rj/ek=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=T3rhYIz5fx4UnQc7d2+m4sOw4xu3ZxZUB0E80NBL18sW9+9WMQ67dISO1JSlPXoeS
	 jOQN6mnNAw1nZEaDb5LKyGaEWEeraVRLSOdqf4GO7hafNZ38TVyupvSSykhaSmTlNg
	 rRYBTw6A1kYU2N6fqMt4DmW5o9Gbq3o0IQVwfr7pJidlimblOGVB9wdjafhkPn56wO
	 1XZcx2g9U7tdh3J25sTNvwsHnhrvPVYZwg/2+qu/mXfYXsdVVKLZI3MgO4rmlmtA5Q
	 IMmFqzjwdUeKSPte2qodIvgLEvNrLWxwiIbdsuVlY9UH1SjXlUuBI2hgoij07i0huA
	 C88IYINGacJUA==
Message-ID: <9750125c-49b4-48b1-adab-3a1cbec4255a@kernel.org>
Date: Thu, 10 Sep 2026 13:23:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/3] kselftest: mm: fix some failure of
 split_huge_page_test
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <b923f63c-db7c-4ecb-949d-368bc6311626@kernel.org>
 <aqKHHWKvOonYZPy0@e129823.arm.com>
 <21e0a933-63b6-42b4-8cd7-df05b0c9acfc@kernel.org>
 <aqKRdIjAYB2PEwRN@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqKRdIjAYB2PEwRN@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ABB9C4000A
X-Stat-Signature: 5yt1htbffxkzaiohk3x4pucpndswpk5t
X-HE-Tag: 1789039404-818349
X-HE-Meta: U2FsdGVkX19o4MN6nSsDY5XT+NgltmtmaXrUeA3pj4khc1lmPkkJfgVzN8GTsjZ+18tmRPdewRz4BFeLveB7Wt3o/vNR2igKJVW8jPR+Xl0fD2bvMwargoKU4lAjKLcaGGNz91/mTVfeP+rXVR26SL4zCP0rGVUYSU09u/G+O81rvY1aW2UELOPHJgvOwH2rHOZaB0AEJkN5mpqty+KB4bqb/GdZAliaLvx3TcVb4lNsC4/bHHJ8sMrHbc5oNk64ctSIzUBkvDF4wwVx9Vbcf1dCmsEm2PFfc7ZX/dguBtxUg5S7I4rakbP2e8X3R8krA07KtyOknZCxvM6GnX3EemxXPmtZNh9mFcBTfjhtqCoo+PpVLDFjgrb2cIdvsDv1LC9+kNP8ImOnC2fcBKaAA+NR55rK5a2uvnubh6Lgd+t/Fm8EUtIzjhHcZ0XZyJPtuJ1uTQMLT+rs3FbNOhBMY9pcJgjsvBsmueMpjgM4qqimn2G2nilB861CUZOIFgu7RCJc6KDXac/kvC5+b4XPvRQaoVoHKnQsHN1WEIchIezUR9bFXXEREIxOfxSWWGtkTQg+ciYQrRtQNp687Rzsqpgw7VaWGL9+1cxNVi+rAj7V+yyn3LR96lMAeI+EexR8QEJ8zpZ1hc99TZxolN7GJjUr462Kig6Vda9Z5OoNcYu/8zQJba9T0Mf9f0cdMRQt/EJP+GJDCUrhBjVYmW5tggmEvSUSGw3QtmvE+xPxA3o111TQUy6Em1Odw+53+FQ6pyiH8bV2ASEzpWBdA50BlAW3whzHh2B15yTCQqzRPOYZ98BdOliWPX7gfFr6H3H3un4tC7y2VafXG1ohw2aGpb60/8KPxwhyKlY2DZNFrMW9kEsMJKCNx9fI3jHLC8hlUIJsaMJI+lUN9atyMMHZjWvck0E12+P78qTBmf5scRDtZZwZ2hhLRQpTIJ4/fM7gsyqFZawIoOhkr7j7y0g
 OKKGjtMq
 WsMWxRqzvnLTkN4Ai8ik9zCMwqBLUI1MizgqUX0jdNNou1YlVYUHxHdG0243UR5SYZVQBFQmtq9MXMqTF1tzao7wKVv3KFtTn/JkN34K467++J+ULHIYc+WVHZB5g4wS6+jQm5UQaAm1suhNyZAXC9yrx3AKylaNzus6TAi9AVWoofPz1EPqdCofw2xrx2XWDn/5Va2KLN5/6ADGEy/qZvH1quTbau4h+lpGz7z9ERN0NNz+BWk/m0YUgUEbltYfwCw7GDcz97pHN7cFCeMDI042X8jafwUsAyXWjv/+HADA/XfOQFE/6XZ5TzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 13:16, Yeoreum Yun wrote:
> On Thu, Sep 10, 2026 at 12:45:39PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/10/26 12:31, Yeoreum Yun wrote:
>>>
>>> Well, users currently for using /proc/self/smaps are for check vm-flags:
>>>   - guard-regions where using check_vmflags_guard()
>>>   - pfnmap test where uses check_vmflag_pfnmap()
>>
>> Most vm-flags should not be an issue when it comes to merging. The only
>> exception are vmflags that do not prevent VMA merging.
>>
>> So it's VM_SOFTDIRTY and VM_MAYBE_GUARD. And I agree that for guard-regions.c we
>> likely have to care such that we don't merge by accident with other VMAs (guard
>> regions).
>>
>> But that's independent of memalign.
>>
>> ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
>> ASSERT_FALSE(check_vmflag_guard(ptr));
>>
>> could be problematic on its own (unlikely but possible).
> 
> Yes. That's why I'm think it would be good to use alloc_isolated_mem()
> in case of ANON mapping for this case.

It's really only guest-region code that needs this.

> 
>>
>> For other flags, you really only have to find the smaps area that covers the
>> given address and look at the vm-flags.
>>
>> Or am I missing something important?
>>
>> (merging vnas with VM_PFNMAP is impossible right now IIRC)
> 
> No. what I want to say including the patch #3 is for the above case
> where you point out -- ASSERT_FALSE(check_vmflag_guard(ptr)).
> 
> Since we don't have any interface to check vm_flags execpt smap
> and for memory mmaped with anon would have a chance to merge,
> We need something to replace memalign() with preventing unexpected VMA
> merge. 
Only for the cases that actually really needs this, which is in my understanding
guard-regions.

And I repeat, this is not a memalign() problem.

-- 
Cheers,

David

