Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE7D10ED651
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39FB86B0096; Fri, 27 Mar 2026 06:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377556B009B; Fri, 27 Mar 2026 06:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28C8F6B009D; Fri, 27 Mar 2026 06:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13D666B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:20:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD956141095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:20:32 +0000 (UTC)
X-FDA: 84591448704.16.720A914
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf25.hostedemail.com (Postfix) with ESMTP id 31275A0010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:20:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KGe9Bs3P;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774606831; a=rsa-sha256;
	cv=none;
	b=3IdKw1swoQQsFqcIT3dkMLku6zZjSbXXY5nxyjIwrv9UxO0nzoVNzi0OOERuY/aKJK56Oa
	NyiGA/Wz5b8+TJ0tQ9QuD/L9Z3jSftIgzUMutW20lbTeyhEOt3rl+vn1zsIL9OpEKbdPXt
	tSSABDy+Ht4WbLVd8GrlP4H+Y/0yJYc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KGe9Bs3P;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774606831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wBNRzQUe8vj+5SO1/0crZCQ7du7rPTjET+qwovjjHzA=;
	b=DspfN3bwIwvr9jf4Qaks0Xyquvs0nvS9RI5pbsqEOpXQI4YCDj4kj/57SaQPtSlNCNUzbc
	5+F7fr+JQxoUzts+adlQZEXNMjMVcXgZbfPopEefSozZkd5jsz4H5kRl4wRgjANNRIbvYz
	bbLbMppdnWZx8GO5CPKWxRgqYlum/ik=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774606825; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wBNRzQUe8vj+5SO1/0crZCQ7du7rPTjET+qwovjjHzA=;
	b=KGe9Bs3Pamh+RHSsRNu+hHC15hcvGNe084segw1IaF+oSdzFCMJUOuzMq87JCHj73BcPujpae2CJ7iwZkQpmhKYSzkPosfwT4uci9Hv0crMzjKGikfCNbgRUF1Z8ka3bIUeWwehW8FQwyje4waqaMQlLkhxxp34POr6gTRq14eA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X.o0REq_1774606821;
Received: from 30.74.146.57(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.o0REq_1774606821 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 18:20:22 +0800
Message-ID: <cec6308f-699c-40ca-a8e7-80247e030fb9@linux.alibaba.com>
Date: Fri, 27 Mar 2026 18:20:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 dev.jain@arm.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
 <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
 <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
 <86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
 <e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
 <e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
 <e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local>
 <bfd282b1-523d-4945-97a0-ec30fe1df577@linux.alibaba.com>
 <a0181a7c-d191-483d-bbc9-678bc355a984@lucifer.local>
 <aef474b9-5286-46f4-99d2-43d0b85f7176@linux.alibaba.com>
 <5b1c0687-a4e4-4a95-8e8f-2d2ce171247c@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <5b1c0687-a4e4-4a95-8e8f-2d2ce171247c@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 31275A0010
X-Stat-Signature: 4d16p8n3tnosqd91yfdz6zq5ga3whhwg
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774606829-683014
X-HE-Meta: U2FsdGVkX1/oZwPjPx5NnhHx0U9VBlAxpmvv8ZPhNxzj/GsI0BJ7qBY7Pqlu7FxOzaNOCp2/DACQu6w/7SK3GrcQ/7BpLouXxKJTULrdduM3V79idwUP04EJGBN6boQc9anYGwpHky3VTrq5f6zso7QWEDKCYrAWL0CRBLC5+DZfL5FY/j+ZDeKsHVpYkMcanqtxppkWDVEWfTX4UXr2WeESb5ZkUBZnSRvaPB0aduvOWmqc/SwacqPZX2XFgV7BWXsQTJjDgR+9XL83uhyvppxBdJ4Nt2Ndnm8uJTnJMKNA2v0jGhIKCsT0FzuHAp73mWZW+88vRQ7fvgf+rseCqDa6aCSCyskJmnfsv4UmRre14dswmZTUdtgDGdNF/pLbOWgy7ReoPn3fsIkGzrwOOhOhj+N0EjbT8i1tIF6wXNvEzaWf4lal8HdTGggq2LWqz3e6hzvgARkoVr9FBiBA2Gu4hmIsjjXaWyxjHfjisRf/FbgHXyqTqbfFWqnFIZjr/jyYEOZsx7yehVWp379UFjaNXYhtg0EEM1HCchf6OFX20HGtjEnjeuoZSgNmT4RDmi30DOq0IIt2rg9CWG0Vzsrnn+CJnNFerHWzaLdcI40ZcnwRfbl5lKGhpS1Zx7XU65MXTFlNHgtN6q91XYH4+ZAH87cW//PxC5JB0B+o3+cGd1GLOdA4WHetVqgBa0+RvXu0F4V3DltPoDfQGB/XndLbnhyywaTOadDHih89lAXo3QWBa1YA94TU9iycMDhCwgYtvr9Rip/tQHqCsKKPim8y+mbZWVziW/cyGW8WBXs28bOPTfO1fuZxspm/0Wc83dqiP+sbEHF+cvE8oM/C7MZwQM6n/itp4c2PbRZfpD//YwqUZoFUznQ9yIbyoLfbNZWq3U+BHtpJTFAmG23ZcbDK4dpfo4degiaBPRhdQm1hZl1Rv6xo3z+NgDVL3x/OUOMxo9PI7Tvan/2DHLO
 Xhzfq615
 hNLMHwzfn87IybvuQkxDmY+8RwzcvQrQr13V370RArHLXzWJXVC0P5mFafW9meJXfMuiROliUwb1eMhmnFWeTz+74dJd9zQuMJvnO50vCcchaFFGTq5w/VHXVvtjD+l6I1tx6tV2Quaaz7drKorVruaDV+ZT06kLW1F5Gy8ZX4ZANjxeLNs1h5juBm7QIGlENvhb3Gla2+LuwnXy3b8GxVNm7wPcfE2wxjhglqt9+in9pnYIgwojNMB+WdArSDyUMrjpYKhF1CXF8umMn12nEyUdUlHXOFUZXF4upKIq3+YPehxQvlhD+e+TJFB8aYFw1vMVIKJ5HnsY4DYXAwEOd8KOhzNAnhfLzpPoKgmCuQfsVWKoU/09utv0n37OtsHzZ++XnAeE9a9Cx+h0XjxmX/LaYVxLDMiOK7AoxS9UQ4713BZw9ciLHBRkfUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/26/26 8:21 PM, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 26, 2026 at 08:04:10PM +0800, Baolin Wang wrote:
>>
>>
>> On 3/26/26 7:10 PM, Lorenzo Stoakes (Oracle) wrote:
>>> On Thu, Mar 26, 2026 at 09:47:51AM +0800, Baolin Wang wrote:
>>>>
>>>>
>>>> On 3/25/26 11:06 PM, Lorenzo Stoakes (Oracle) wrote:
>>>>> On Wed, Mar 25, 2026 at 03:58:36PM +0100, David Hildenbrand (Arm) wrote:
>>>>>> On 3/25/26 15:36, Lorenzo Stoakes (Oracle) wrote:
>>>>>>> On Mon, Mar 16, 2026 at 03:15:18PM +0100, David Hildenbrand (Arm) wrote:
>>>>>>>> On 3/16/26 07:25, Baolin Wang wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Sure. However, after investigating RISC‑V and x86, I found that
>>>>>>>>> ptep_clear_flush_young() does not flush the TLB on these architectures:
>>>>>>>>>
>>>>>>>>> int ptep_clear_flush_young(struct vm_area_struct *vma,
>>>>>>>>>                   unsigned long address, pte_t *ptep)
>>>>>>>>> {
>>>>>>>>>        /*
>>>>>>>>>         * On x86 CPUs, clearing the accessed bit without a TLB flush
>>>>>>>>>         * doesn't cause data corruption. [ It could cause incorrect
>>>>>>>>>         * page aging and the (mistaken) reclaim of hot pages, but the
>>>>>>>>>         * chance of that should be relatively low. ]
>>>>>>>>>         *
>>>>>>>>>         * So as a performance optimization don't flush the TLB when
>>>>>>>>>         * clearing the accessed bit, it will eventually be flushed by
>>>>>>>>>         * a context switch or a VM operation anyway. [ In the rare
>>>>>>>>>         * event of it not getting flushed for a long time the delay
>>>>>>>>>         * shouldn't really matter because there's no real memory
>>>>>>>>>         * pressure for swapout to react to. ]
>>>>>>>>>         */
>>>>>>>>>        return ptep_test_and_clear_young(vma, address, ptep);
>>>>>>>>> }
>>>>>>>>
>>>>>>>> You'd probably want an arch helper then, that tells you whether
>>>>>>>> a flush_tlb_range() after ptep_test_and_clear_young() is required.
>>>>>>>>
>>>>>>>> Or some special flush_tlb_range() helper.
>>>>>>>>
>>>>>>>> I agree that it requires more work.
>>>>
>>>> (Sorry, David. I forgot to reply to your email because I've had a lot to
>>>> sort out recently.)
>>>>
>>>> Rather than adding more arch helpers (we already have plenty for the young
>>>> flag check), I think we should try removing the TLB flush, as I mentioned to
>>>> Barry[1]. MGLRU reclaim already skips the TLB flush, and it seems to work
>>>> fine. What do you think?
>>>>
>>>> Here are our previous attempts to remove the TLB flush:
>>>>
>>>> My patch: https://lkml.org/lkml/2023/10/24/533
>>>> Barry's patch:
>>>> https://lore.kernel.org/lkml/20220617070555.344368-1-21cnbao@gmail.com/
>>>>
>>>> [1] https://lore.kernel.org/all/6bdc4b03-9631-4717-a3fa-2785a7930aba@linux.alibaba.com/
>>>>
>>>>>>> Sorry unclear here - does the series need more work or does a follow up patch
>>>>>>> need more work?
>>>>>>
>>>>>> Follow up!
>>>>>
>>>>> Ok good as in mm-stable now. Sadly means I don't get to review it but there we
>>>>> go.
>>>>
>>>> Actually this patchset has already been merged upstream:)
>>
>> Let me try to make things clear.
>>
>>> Err but this revision was sent _during_ the merge window...?
>>>
>>> Was sent on 9th Feb on Monday in merge window week 1, with a functional change
>>> listed:
>>>
>>> - Skip batched unmapping for uffd case, reported by Dev. Thanks.
>>>
>>> And then sent in 2nd batch on 18th Feb (see [0]).
>>>
>>> So we were ok with 1 week of 'testing' (does anybody actually test -next during
>>> the merge window? Was it even sent to -next?) for what appears to be a
>>> functional change?
>>
>> I posted v5 on Dec 26th[0], and it collected quite a few Reviewed-by tags
>> and sat in mm-unstable for testing.
>>
>> Later, Dev reported a uffd-related issue (I hope you recall that
>> discussion). I posted a fix[1] for it on Jan 16th, which Andrew accepted.
>>
>> Since then, the v5 series (plus the fix) continued to be tested in
>> mm-unstable. We kept it there mainly because David mentioned he wanted to
>> review the series, so we were waiting for his time.
>>
>> On Feb 9th, after returning from vacation, David reviewed the series
>> (thanks, David!). I replied to and addressed all his comments, then posted
>> v6 on the same day[2].
> 
> OK thanks, I see that now.
> 
> I still don't think we should have made any changes _during_ the merge window,
> even if they were simple code quality things.
> 
> Changing patches then seems just crazy to me, as even code quality stuff can
> cause unexpected bugs, and now we're having upstream take it.
> 
> Also this speaks to -fix patches just being broken in general.
> 
> If you'd just respun with the fix as a v6, then we'd know 'v6 sent on 16th Jan
> addressed this' and there'd be no isssue.
> 
> Now v5 isn't v5, there's v5 and something-not-v5 and to have a sense of the
> testing you have to go read a bunch of email chains.
> 
> It also means change logs are now really inaccurate:
> 
> Changes from v5:
>   - Collect reviewed tags from Ryan, Harry and David. Thanks.
>   - Fix some coding style issues (per David).
>   - Skip batched unmapping for uffd case, reported by Dev. Thanks.
> 
> And that to me means 'v5 didn't have this, v6 does'.
> 
> And it's really hard to track timelines for testing.

Indeed. At least I need make the change history clearer.

>> Additionally, v6 had no functional changes compared to v5 + the fix, and it
>> mainly addressed some coding style issues pointed out by David. I also
>> discussed this with David off-list, and since there were no functional
>> changes, my expectation was that it could still make it into the merge
>> window. That is why v6 was merged.
> 
> Yeah, we still shouldn't have taken changes to a series DURING the merge window,
> it's just crazy.
> 
>>
>> [0] https://lore.kernel.org/linux-mm/cover.1766631066.git.baolin.wang@linux.alibaba.com/#t
>> [1] https://lore.kernel.org/linux-mm/20260116162652.176054-1-baolin.wang@linux.alibaba.com/
>> [2] https://lore.kernel.org/all/cover.1770645603.git.baolin.wang@linux.alibaba.com/
>>
>>> And there was ongoing feedback on this and the v5 series (at [1])?
>>
>> Regarding the feedback on v5, I believe everything has been addressed.
>>
>>> This doesn't really feel sane?
>>>
>>> And now I'm confused as to whether mm-stable patches can collect tags, since
>>> presumably this was in mm-stable at the point this respin was done?
>>>
>>> Maybe I'm missing something here but this doesn't feel like a sane process?
>>
>> Andrew, David, please correct me if I've missed anything. Also, please let
>> me know if there's anything in the process that needs to be improved.
>> Thanks.
> 
> This isn't on you, it's about the process as a whole. We need clear rules about
> when changes will be accepted and when not.
> 
> And frankly I think we need to do away with fix patches as a whole based on
> this, or at least anything even vaguely non-trivial or that potentially impacts
> code.

Understood. I'll check first before sending fixes to avoid confusion 
next time.

