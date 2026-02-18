Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15EBCE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 12:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FEDA6B0088; Wed, 18 Feb 2026 07:26:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6824B6B0089; Wed, 18 Feb 2026 07:26:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58DE86B008A; Wed, 18 Feb 2026 07:26:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 44C9B6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:26:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6ABC85957
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:26:53 +0000 (UTC)
X-FDA: 84457501506.08.D818A9B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id BE505140009
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:26:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771417612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1xkDr3hOc8tIX8rhb1B90insc8AsQBPXnJpIU64iv3Y=;
	b=iR0AZW7fSkMtlKlWhB2oSqXpIbmW2zaprF4NxVdDfKYqrYKvTi3BsaRhXGQmrN2f+tnu8C
	9OZ8l4+BUDOiQzo/COXFbXDWOS4xZ1+ljbSHxYxVERprfJzfAKVKYoV3aO1Gx4oIOp8nK9
	K3QWn7FDMC57WTvM2diWPvvGl/HT4Kk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771417612; a=rsa-sha256;
	cv=none;
	b=XHst7RJsMESxKuAY7WXHsCzIQQA+BnUDveILNxmnKsZJ58lcJUTc6JyC+641AElPA7fWJ/
	MgE1VXIb2c6p3j+5pk+5xJ+k54XscdOV3LlaEIJZjPljbk8fF19n9SYHkkoQ8iZEr2y305
	cEL2BVMcxzaCw1IFBuKjqy3BiL83rtM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52C9C339;
	Wed, 18 Feb 2026 04:26:44 -0800 (PST)
Received: from [10.164.19.71] (unknown [10.164.19.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3F31D3F62B;
	Wed, 18 Feb 2026 04:26:45 -0800 (PST)
Message-ID: <e6333bbf-3a94-42eb-ab42-3f9255e1e51a@arm.com>
Date: Wed, 18 Feb 2026 17:56:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large
 folios
To: Barry Song <21cnbao@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <46d0b6bf-db7e-418f-a497-983db4d4d786@kernel.org>
 <ddedb72a-d24f-48bc-88b2-f6f99f3d45ad@linux.alibaba.com>
 <CAGsJ_4xqtksoCwjLp-7Kvg5=LyqH+=aGWDWi8jRp8J0c-QiSwA@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4xqtksoCwjLp-7Kvg5=LyqH+=aGWDWi8jRp8J0c-QiSwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BE505140009
X-Stat-Signature: toq7hygm7cx1apoq18hbba9dfxay9dwu
X-HE-Tag: 1771417611-259940
X-HE-Meta: U2FsdGVkX1+5CeQBxp5LHRZA3Fh5Tg4yYIh4/4U+VXZGXFJdFFaQGeA02875BGHUvjUJLtjfD/WdoPToPtxMFKDl2tVzJRMi+OcsUDm/2xVO91Dd8NhTuLCrypq1EkMAMk07IKmON7mBwgM3K2EVQKvYzIJS1DqS+TkmhUZyRbKMqPdM9mxiMaX4BETgXJHx7g1t4baTxk6rFTueFOxF11LlR3QZHFbApLBCKTgRdJPcD8kBxEU5ibPXellzKY6Ver2nCpKRcWAOwYvUP9p26WMygVtLGV3xFDRrlrbLvz19WVJP/nFNmSfCZKeKtSMBhrB2+4ts5m9Ybhw73XLE2q4ehjD8KqtBrSF0J2I/RYPtTLewXkMV8JrXuUfMBPe9530eh59DvY72/acldQXpibvz+zDFAYIAGDJmcXKG1zs1HABfHs3JIupU/AxJ3Wl01FY4/pWiitBoup4vQi9G4AS3ycb3LSgzPKEJRF078X3kejQFakvKFsi1KqM9LAozt3BdTBjGim1NP/lMO8Nmu34AEFnesi2VOqTGtsx9mQ/NSfJsN1uE7IgEixoeNuLs01yA5OloI8kGLU+lKcbpBYAsjgOdkswsXimzohk+FkBVGJA8VZmpoiAQPHacqwM2BSycgzK3+RTj/Me0KghHRa9EddL4hHPyzD39Oa6hWK/MzBgosvFKkl7fqKFm08cfZmVqbX40YbqAd+mswiJ7tkVHboLfQsFwWwm8Vi22CxXciMVXd+TKemG3yG4HrhvQx5OtSOvqt+FIBsTXJBuesxw8nq21q415I0Q2yCYzK0Qz5lwcWGB2Q5qQdbDpXL4UIwYllg8nBAL4Ovrbq+Zcre8YS8/4q7Hw+3boXCM7PfvhP/EVQeLwa1G28oE559PFPZye/ePajBs/ERXURJOYJGztamH3adyK4fEuWCpFjB2ScDXwG+DDmg1p5etPrCOGtgYh+lG/fOKuConrtsk
 K3PPVpQF
 jXA3wSHhF5diMUt1z3Pp43jXXq3WFSt2ID9HbdR5Ocmky1/nCgVDw0onK9uZS+BePruBCAliJKoK1kuGCgiSn6wdZ9+xJi/P9214xmLJAsKprkp2yuL9k7O70UISzz3EjNd04bOZdkPaa6edAQHDihxDBR/CRi43TcxJpvtiZv5gH3pxG8IqRmEOkcMx6GG1+yFNQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 13/02/26 10:49 am, Barry Song wrote:
> On Mon, Feb 9, 2026 at 5:43 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
> [...]
>>>> ---
>>>>   mm/rmap.c | 7 ++++---
>>>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index 985ab0b085ba..e1d16003c514 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -1863,9 +1863,10 @@ static inline unsigned int
>>>> folio_unmap_pte_batch(struct folio *folio,
>>>>       end_addr = pmd_addr_end(addr, vma->vm_end);
>>>>       max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>>> -    /* We only support lazyfree batching for now ... */
>>>> -    if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>>>> +    /* We only support lazyfree or file folios batching for now ... */
>>>> +    if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>>>>           return 1;
>>> Right, the anon folio handling would require a bit more work in the
>>>
>>>
>>>      } else if (folio_test_anon(folio)) {
>>>
>>> branch.
>>>
>>> Do you intend to tackle that one as well?
>>  >> I'll reply to the fixup.
>>
>> I'm not sure whether Barry has time to continue this work. If he does
>> not, I can take over. Barry?
> I expect to have some availability after April 1st.
> In the meantime, please feel free to send along any patches
> if you and Dev would like to move forward before then :-)

On it :)

>
> Best regards
> Barry

