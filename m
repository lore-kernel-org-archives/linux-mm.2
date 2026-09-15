Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DA4AC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B8D6B0088; Tue, 15 Sep 2026 09:43:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FDC06B008C; Tue, 15 Sep 2026 09:43:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315156B0099; Tue, 15 Sep 2026 09:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 144436B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:43:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9CC191603DA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:43:28 +0000 (UTC)
X-FDA: 85216113696.15.665A929
Received: from mta0.migadu.com (out-122.mta0.migadu.com [91.218.175.122])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6CF601C0003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:43:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vGPc+Z92;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.122 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vGPc+Z92;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.122 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789479806;
	b=IovP+V208do1IXsPe30PClGCR7JTIp+rZz5EQF4/V/U0RcKcxtqGiNMDKJtKAO1SdsJKnQ
	J9abYtx45hrpK87I3Ii60iA5vDV8S5CONmGipUPp5DC7UeFnKMVbKVxVwA4Ijh9rl62rBS
	z7g7UCjlgiKnG9cLVj3rYppTRXNTdCc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789479806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAwQ3MRz+blXVd6WEH+DymLjj+dZf8p9ZsqTmnCf2m8=;
	b=6t4DmLsCMFiCYbb4q4TIwvpsC9BuXX7KEGCxpmhalAGWo1bjQBx1NTtLTlsm+eQp8wTT0a
	VKH06cOZsP+BJ3uN/cIWJc5jC+osdqVHTrMgvIxoI+9LOn+sZYB4wE/GPXUDFYuPsJcpSA
	Qp96O49j46DvPeFsGQny020LHixDaIs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6HudDoiUDG0qD8sOY5Dvp2rvFR5U8GAkB5GWE5aD+1M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789479804; v=1; x=1790084604;
 b=vGPc+Z92QfmYlv0I08b8/LRhcYnsPy6z35SiQ4jrED23UugUlek7Z4JMvHtx5DvOEE1Kg/Cy
 IJoObSEawkgGIYk/nI+8LeG2zT64D9bj0dBWndB2mRTbgH2058moz1XmfEASVVy/vOgfYWD/hub
 oxndnVdWm1uVTzlb1PcgT8/Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id abc51d4308209202;
	Tue, 15 Sep 2026 13:43:23 +0000
X-Mizu-Trace-ID: abc51d4308209202
X-Migadu-Flow: FLOW_OUT
Message-ID: <30bcc70c-be07-4237-9bb1-554aa5b5c5c2@linux.dev>
Date: Tue, 15 Sep 2026 21:43:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/huge_memory: fix pgtable withdrawal for huge zero
 PMDs
To: Andrew Morton <akpm@linux-foundation.org>,
 Kiryl Shutsemau <kas@kernel.org>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, ljs@kernel.org, surenb@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260912234635.db50397364858aa15f58f4d7@linux-foundation.org>
 <20260913072312.52111-1-lance.yang@linux.dev> <aqfRCPheDYTgTdAk@thinkstation>
 <f76beaf8-351a-4b22-b362-a945a5e1af6a@kernel.org>
 <20260914111940.f7e2c72eac4a2df97a646793@linux-foundation.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260914111940.f7e2c72eac4a2df97a646793@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CF601C0003
X-Stat-Signature: icgkgbkzo4twmyoe74ybqgq9mf9w741g
X-Rspamd-Server: rspam01
X-HE-Tag: 1789479806-525570
X-HE-Meta: U2FsdGVkX1+lYE8lcgmmbZEtod/G5L8573GASjbbqzQXSSSO56D7aXlmMuPAOTNfmomsQ02nkO88tt6nZ4/VNWAT+S6kn2gCgIEmoyMUAeqcn5g73Zl4nZtrwfPQ4HzG7SJjv5MnbGPYuj67MN0zcZtIOqC9h44Kc55H29nZhNfgarjoApttc6/RJuAUbIyX+vLVNKZAWKYu0q9q4k20WDuscp8dGjT4emzhAhUqim2gIU7aamV9Z8kJOkp6zpRWd72m4oJN0yxa2dpPwJCJhekkq6ZLEur99Ijxew9LPlR9JNcnczIkckbG5khvBj9bpa57EqJJyzYoItu6i9ywJrjS1vberDp3sLC2Mv3GtDsX5o1sD1t5+eFhWEHWrgQO0DFk20q+s8gGlQfQrcDBxoNGt5hMgElGyrFBdinIaJP8ZSOPLQeiCsGCfdnZ2vNKg9kK7cfPNNNGfjILqFnWcDyqk6ZXrqPSmNCxtXMdzVn+/DSsLJnOSIrWPRNAVaC/6QzgOKC5XrC1s1QiSbWj48/xW+8hxoNCDcwvOtd6Z5Z0yAhzwUW1ZtdYBMEVCcUjBwclKRmv38e3izRNopbf+fGlATTQllRYhR9s5n3NqldJQlvyOH+TvBkYgroU6ZC+s6LK7EebzQgzhiNqdBbjmffU0s0I8iJ9wOzkDSNgUvu7wqZsXHt075+i00hDWq+Ubj8Or8QPEhU3TEvxGGcUJF1/ynrsLwFOge+cS8NtWrtU6ylnwbYmUprUac4gHaeb4w7kbrNpzm1jpx6fiWNqV19fNEs6jSt+9StksrpveMerMx6fIZLXH4K1bhb86RZwZ+Ko6nVxRby7uOUhFzzIVpNppUNOurBSFaH2ChGKJhegAcVBgYCl4z3TsDhm5Hf7RXZ92ms29Ue1CLUxF2SrgYDireeSciRn0EOJNls/bkEf+vLkC58mA3QPJ+k1FNbbjVmDLcJssRE3DGKIJrO
 tNM+y+Ne
 K36DEJwk1DL3YTLfgC3x/MqMivF/h0IzwG40fHBhi9eCL1hrV/ca4G83P1/YGtrwAdFdl6uLif4Ng4WKMrirrW8i4YHfcEPsMrQbYkBKfUH5CpT3LY12JuoU54NtTs1CTW3GoXhLCuwymiSpVCsJnI5doCKh0Ae35VI1OMZfyBFpUOZYo/2IyD6lSDLAgMyG5HtPzo0yv+OBgP00RRihlL2d8AyibKcK5C7pu+9jbu1YIxM7oUYVXVYGf6xHOdskb5str9z0A5LnULWaVPo/cmT91Q6oXnWUE0GAGAqO8Fzxi4w97eLdeU6XoeXbEGmQkev4vc93CajLUlAX3VI9q6EpE2UbSSscOgj5T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/15 02:19, Andrew Morton wrote:
> On Mon, 14 Sep 2026 16:29:00 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> On 9/14/26 12:59, Kiryl Shutsemau wrote:
>>> On Sun, Sep 13, 2026 at 03:23:12PM +0800, Lance Yang wrote:
>>>>
>>>> On Sat, Sep 12, 2026 at 11:46:35PM -0700, Andrew Morton wrote:
>>>>>
>>>>>
>>>>> That's the sort of thing we'd prefer to avoid.
>>>>>
>>>>>
>>>>> How real is this?  Is there a reported-by:?  Do you have a reproducer?
>>>>
>>>> Yes, I reproduced it on x86 with a small test module. It sets
>>>> VM_MIXEDMAP | VM_HUGEPAGE and calls vmf_insert_pfn_pmd() with
>>>> huge_zero_pfn, without touching the page tables directly. A full-PMD
>>>> munmap() crashes before the split series[1] as well.
>>>
>>> Ah. So there's no real bug upstream, right?
>>
>> Matches my understanding.
> 
> Thanks.  I'll remove cc:stable, move this into mm-unstable as a
> next-merge-window thing.

Sounds good to me, thanks, Andrew!

Kiryl, David, would you prefer the validation for raw-PFN mappings
of the huge zero page as a separate follow-up, or should that
validation replace this patch? wdyt

Cheers, Lance

