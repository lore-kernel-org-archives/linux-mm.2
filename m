Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28A0FFC5918
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 09:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C4EA6B0089; Thu, 26 Feb 2026 04:27:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4965B6B008A; Thu, 26 Feb 2026 04:27:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2266B008C; Thu, 26 Feb 2026 04:27:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 26BAC6B0089
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 04:27:26 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE894140A9D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:27:25 +0000 (UTC)
X-FDA: 84486079650.20.C6C36B1
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf19.hostedemail.com (Postfix) with ESMTP id A03081A0002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:27:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="t7H/RwvO";
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772098044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Z7J2/ULNSA00ESGJkV5zPKGTqAvtL1rE4wzbzIL92k=;
	b=eCOdp91TOY90xr14P/6ybADomXzGbDMFu1Yj5oZ7fPqul2HANhFbBTEqNKEoFCMN3iHOWq
	GMZpn2il7iaBUjLxFUpBq3FVn3I68/junJJg0HZMOnAEPBZVZk7QiIt3wxi3tIh7F4F9vJ
	36nKPIG9yYTrCK0A/dHUtW+6pCx5m9g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772098044; a=rsa-sha256;
	cv=none;
	b=KeJCz/oVbIC8Sj8hsk8XTwFKCFr+uSSTeu4gD1EZrBVPP9rT97EQQARj35MV0DqMIuDR6s
	V1rbZdyPWiCEIV+00R0gqE7oqxVlTc/Yvg3iKMjLD2vXxY3ZZWnO5rGYyS2lWqArihYXmh
	iv62JGulEsvcziVXWExvyJTgmn1m0+o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="t7H/RwvO";
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772098039; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=5Z7J2/ULNSA00ESGJkV5zPKGTqAvtL1rE4wzbzIL92k=;
	b=t7H/RwvOxr1w+kYVWoXmXIYcgN6QKyrhhd2dNIE58KFFbwlKxL01bV38M1a2wDJvovmGc5il6htMtukPT6+/sxQofloadCnPpWhraOuh+z41j1qK8Dv6CNJa+rqAkNcHSRHy2ecVUmJdPFm9fMEZk5b4Ftvws9R9kqxpNSfn1pM=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WzqngAX_1772098037 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Feb 2026 17:27:18 +0800
Message-ID: <08a22ed6-3165-41a5-8d46-aaa09402a0f9@linux.alibaba.com>
Date: Thu, 26 Feb 2026 17:27:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm: support batched checking of the young flag for
 MGLRU
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
 <84d2426c63c1eafeaa0cfbad7c5cc11e9c11b980.1771897150.git.baolin.wang@linux.alibaba.com>
 <2e7a1e24-3616-4b79-b943-b5f7efde2d31@kernel.org>
 <0871edb9-08a2-46a0-ade6-af842a12e0d3@linux.alibaba.com>
 <2599bc1e-1f8e-46bc-afea-4cb8f657545b@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <2599bc1e-1f8e-46bc-afea-4cb8f657545b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A03081A0002
X-Stat-Signature: boqsgqqnawnxucyoip7tuk7on9sbumkf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772098043-78707
X-HE-Meta: U2FsdGVkX1+cCtcvIx21h/gyfBYpOSNeozIrZRFkYAWRAARHByQY9FQqKQoeFeLL6lgOlz1IyxXA+HR7bp71ZfkO8RO1F5/SKIBDuApTx+7PCCzxU1Yrop/zzN/ur83ON6lwJpdBazc9oi8jTpWeAomfx5ZD7l0FpNxgzDI1vAEhxx5pEQt35bC63/TTBPW0P+jPU5wGmiklp1vV/tSlSEx9Q4SBuHgHYBdcXTunup854/IDrL33yhLm0wkdV/6Fno3u+aVa2xTHwCY2hx2BRQCAVRJCCiF1HLukpjtYVaSyVWnScys5a5tYJ4gKvoN4jiKa2JJUOBb+8osK5K2mPEU6TfZB2TZokgJ9m3SWpbLC+45bPkIEiBltXJgdcy/0GjPgnDAlEIZYIy+OrLu572Onkd3m+QlbUD6WSxIdl5PwBol6AgDcLT2qEVk3nkEK64wqskfDXm5D1HodgLjHj9NDr9nfFmGJRWNTv92FzE0YPVv7REUmWyrU5VGQYHBKR2IV9ArZPeuSkpYjCytPlq8AKcmFtDOMh2jOmCYfCSxDAg4BilIlue8vyRO0wLmE73MtWKd+RimnY4in505SWD+yUEZXINAxcWcgdD+A88/VWfO2ACjNdwXzAj82fb7MtMfp1X96KqHmInBYaqSXlTut3Zp03BppvVjasHHfDQwkIrml1IYqu+ETZF0LmwB4VrlazR6HubvhtimjfCHXEm/0hGDo4+CXAneOSBb3b7SCtGZcVIz86b0YkLXkmh5YcDMFuJLzuMwHfcEnI28kSbyyTqkD1aaxK3AYuwD5zlJETDtyBV0sJDJ2mP6Juaqb5T1ZddGDs5S0VxeZczoiWehm1QYOHEYl8Cbm7diDtoTAR6jgHVb3ZrcoTUdXDvUJZNrOwsG19bVl8TfJMWl22tHpkRFHbHZT/t5jXarFmTT8v7RfAEGThAcnHi65c/MbGCP3CqRgf2qowr+XN/W
 o/FyC4NP
 qUS0tMIMIFnO695cKykkva3oc56jETl/YdabOW2SB9285Nrn1xePqm23o9QmLlPjPCkPx4jgy8KNPwbhsfnFYuykA6XhqwP42qw5nTHC/8vXGJv0kchkVsuAcBTavXjbLWMM/A1H9ZMEEjgwFaalgOiC2MuJObRkItIShHdv9gCyzkr2UPBdK+21kVQSt5gSbcye/deaQX5+9EWyFXss+R+UafvvZK5WMSmQlL6BIa6MnwJJt75+zeV3bVAvkht9c+7QQWzzMddpkXGOc5w+NLvNCMjjfFmTPkEPK9ddZxoPfiqkeJJpktFrFo7DLB4DbjxbcvNHKyHHkK07rIqA1cXZutw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/26/26 5:08 PM, David Hildenbrand (Arm) wrote:
> 
>>>
>>>> +            pte_t pteval = ptep_get(pvmw.pte);
>>>
>>> I wonder if there could be a way to avoid this ptep_get() by letting
>>> page_vma_mapped_walk() just provide the last value it used (in
>>> check_pte() I guess). Something for another patch.
>>
>> Well, we’d need to add a new field to ‘struct page_vma_mapped_walk’ to
>> store the last value (e.g., pvmw.pteval),
> 
> Yes.
> 
>> but this makes me wonder if it
>> is worth adding a new field just to avoid a lightweight read (which
>> should have no obvious performance impact).
> 
> You recall that ptep_get() on arm64 is not that lightweight due to
> con-pte? :)
> 
> But yeah, something for another day.

OK.

>>> What is "batched"? Did you mean "nr_ptes" ? Or just the initial value
>>> for "nr" ?
>>
>> There is already an 'nr' variable in this function. "nr_ptes" sounds
>> good to me, and will use it.
> 
> You can just use "nr" here and reuse it for the existing variable?
> 
> Both have the same semantics (nr of ptes / pages), so having a single
> value might cause less confusion.

Sure. Will do.

