Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 848A9ED7B87
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D986E6B0088; Tue, 14 Apr 2026 04:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6FE76B008A; Tue, 14 Apr 2026 04:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85A26B0092; Tue, 14 Apr 2026 04:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6C976B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:11:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 602F7E3717
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:11:31 +0000 (UTC)
X-FDA: 84656441982.02.11280DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A342A140006
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:11:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lZ9h4XlX;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776154289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cfTUPnCtghR61trhjy3rKm9kHECsFrTpZ5LuOwuV5k=;
	b=54F3mVO4MPUq25DAHJ18iN/QWPsPEgYYVZ1ES/NX3Lgf3OxkZ7bTz/xTkkKwAy7x8F3a03
	TiydEbiWNaTEF8jeIq00o7NWVQr+yiNjoizOEmQZonbS61jcGdGRBr++USOgjIAxoFmOJv
	x+G/Wd1jrIKICajOqqEHX40YgR3Y7E4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lZ9h4XlX;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776154289; a=rsa-sha256;
	cv=none;
	b=woHx36z1e1HKooDwpNgIXsWRBF+jWlZqS4CeEd97eIS8xbsSHvFXN1EFlf2c1jfHiCNwX2
	2FQwq2dTVYVWvhVTqVb5mnqem3ROoOtEkAZ4o/VcuQOmSOlv4GkoOlByzsLnjkjj9DgO3W
	ej11EtwUH5AZTN5HjE1/7l7/Ws6ONBA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 057D060018;
	Tue, 14 Apr 2026 08:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A6AC19425;
	Tue, 14 Apr 2026 08:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776154288;
	bh=VxjOWkpHI39Iy08LBzZ4L8PQgORAVarz+9fIJCl1oO4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lZ9h4XlX2/jn5beFHYWAGEYVf5VwdfmL5PcJOFc3kPDZwyqecdRki6/tfMTWTHIfz
	 mQQ2Qe6HuoZE1dfg3E7FaokCCEuwWRCWqO8dKWmPjCblZqG1UC0h3AjUFCU5vpoDmv
	 nLv7PRBGCqV4WJl8QBugDBNzUyANF8OVDBgQ0PFKkiV/sjz9q6XpZScJMVM0cwf1D1
	 kSRRhp2VZuND9B7zFxlFwnswNAllbwc8q9j4V5VExAa8UewkqTyCkA79I5xETjwKZq
	 jpTAvWqysE6aviWnrDNAGuN5Ei0Umffr3aOb+10kAGiWM7dITwGmeiYVnvlhgqZdOW
	 48j3zFw92qrAg==
Message-ID: <aa8a125d-6746-4e16-b301-ff295ca20f0f@kernel.org>
Date: Tue, 14 Apr 2026 10:11:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm: make lazy MMU mode context-aware
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774420056.git.agordeev@linux.ibm.com>
 <de89fd353a8dcd5e3bef4d91e9b6682d132ed9a0.1774420057.git.agordeev@linux.ibm.com>
 <44dd86c0-1845-4dd9-b4b4-2cef6d1c6357@kernel.org>
 <e096e88b-f1fe-44a1-bfa6-451eef028203-agordeev@linux.ibm.com>
 <665a19a0-47c2-404c-bd2b-482ab51b8f64@kernel.org>
 <896b3d93-8e60-42e2-b8bb-d3d4e8c99927-agordeev@linux.ibm.com>
 <534ed892-a6ab-454e-831b-e207930c35cc@kernel.org>
 <584f0f88-aef9-4a70-b0bb-abc797f741ed-agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <584f0f88-aef9-4a70-b0bb-abc797f741ed-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 97q6rtf9o6xasna97a1t68uibpnbsjqn
X-Rspamd-Queue-Id: A342A140006
X-Rspamd-Server: rspam09
X-HE-Tag: 1776154289-993788
X-HE-Meta: U2FsdGVkX1/W8P5LNq0xuZvtT0+kaXXL8VsSuVRV1pHQDcyveEhFQ9z2qll/RsmSZFWdaHs/xFEwROTFk/BJElP1XzBVde9LrQPU4vsOEwK6lE4+AYJGJ3EAI7pIefcHdk+i6v5r/w2M+q3//SrC9faW/zt5P1O736xeR5J6RdoCkYaE28sEeW9eQxvfDImcc52wZMRWL58S9xHCZFbZ995vByHQ1VOL8GJcicvy5HDOwH9HL//iAD89QCBeu8WxMokRtlzHkT7wqzHGx5rFbqkAwAJYbboM/NGpZQ5WaJio/ABsltPbF9lXzBkfFi0mkis7NngY2ReoOGsqIehJznizmIXjgxCG3v7+pL9vpXmcwK1UjX6HqXkxc2CRiUzRXUjWftbwhWjbX2cM6fuUgg0a76jdP2iu69mc8jima5V52DTdNJ9sbJPOHSy9bn92dJ4kaAGGFeZV+bedOvBK1qgYRT+ihAxJsYkByC+bWZxYgcvEn0gCuvN8MPABltxQQIoQbjc6xDUi93PBWUz8mx1HZ1GantQENchW8vZYsjnAI1u0mk/bija8xSkEIoLWsUv4Ai0qEwg1iYjsbbCJJT4mDS+F7lB3HpaecFixFMpNcyXKRKl3PiNglqpWKk59JJTGKHFAAxaKAEpgWuPFv2i0V1wlmnuPatfn5tg7NRQNqmVZxgl5fzxwK7WSNED2Ce5jaDSB4WDhyvB9pDhAYwcnSsZgSJcor2PR2/oyUty7fT06xXvlfI4AhSkdYq03XOIkSbNY/l5OvClfQPqJz7PKmTkHwFjDUypvfMbSQQ95F9wvaPuOnKtR6Tuutz6L47Mq7d/c7WC4pua0d/M3W2uxpd81pDs2HfP7rp1La01hglwwFIUafPKy5K5K+bbKJacAxRdWv6rrBwppx3NlZR8gF2qOLcW2jADpYey1DMqQaF+3dDFybF0YFLv9Jr6eTyVMQKAvMI+exLXjaBM
 Kyvd5fd6
 ypjUd/oWd5n9dnbzmoWeeN9L28ZVweU6Az2DIW6XVohRCFdEtRgwPM3lQvscPxGVvLMEbsQ/jKYtTJjMp56kPcdo+qcGH0i9ot+u1IGo7AgPMcyguXe1S+0VYVTcfYL2LywnA0kbQ9w2Rl2nHw+PExhNNW+WzT14R63DpMLbt2ZTDteDS2/BUQIhwSynOqsk3QQYFIQNlXlbOttTjSZQN3ou4fceFnpy1VokFW+frOPW5IBL96C/JQDRDpgB+ODWcmcTG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 09:53, Alexander Gordeev wrote:
> On Mon, Apr 13, 2026 at 08:32:11PM +0200, David Hildenbrand (Arm) wrote:
>>> 1. copy_pte_range() operates on two ranges: source and destination.
>>> Though lazy_mmu_mode_enable_for_pte_range() applies to the source one,
>>> updates to the destination are still happen while in tha lazy mode.
>>> (Although the lazy mode is not actually needed for the destination
>>> unattached MM).
>>
>> So, here a
>>
>>   "No ptes outside of this range in the provided @mm must be updated."
>>
>> could be used.
>>
>>>
>>> 2. move_ptes() also operates on a source and destination ranges, but
>>> unlike copy_pte_range() the destination range is also attached to the
>>> currently active task.
>>
>> But not here.
> 
> I did not quite understand these two comments ;), but I think
> I address them further below.

I'm saying that the second case is the problematic one ;)

> 
>>> 3. Though theoretical, nesting sections with interleaving calls to
>>> lazy_mmu_mode_enable() and lazy_mmu_mode_enable_for_pte_range() make
>>> it difficult to define (let alone to implement) which range is currently
>>> active, if any.
>>
>> Right. I assume you would specify the source here as well, or which one
>> would it be in your case to speed it up?
> 
> It is in all cases the source/old/existing one.

Make sense.

> 
>>> All of these goes away if we switch from for_pte_range() to fast_pte_range()
>>> semantics:
>>
>> I don't quite like the "fast" in there. I think you can keep the old
>> name, but clarifying that it is merely a hint, and only ptes that fall
>> into the hint might observe a speedup.
> 
> Okay, that simplify things.
> 
>> Could performance benefit from multiple ranges? (like in mremap, for
>> example)?
> 
> No.
> 
>> In that case, an explicit hint interface could be reconsidered.
> 
> So all things considered, how does it look?
> 
> /**                                                                             
>  * lazy_mmu_mode_enable_for_pte_range() - Enable the lazy MMU mode with a speedup hint.
>  * @mm: Address space the ptes represent.                                       
>  * @addr: Address of the first pte.                                             
>  * @end: End address of the range.                                              
>  * @ptep: Page table pointer for the first entry.                               
>  *                                                                              
>  * Enters a new lazy MMU mode section; if the mode was not already enabled,         
>  * enables it and calls arch_enter_lazy_mmu_mode_for_pte_range().               
>  *                                                                              
>  * PTEs that fall within the specified range might observe update speedups.         
>  * The PTE range must belong to the specified memory space and do not cross         
>  * a page table boundary.                                                       
>  *                                                                              
>  * There are no requirements on the order or range completeness of PTE          
>  * updates for the specified range.                                             
>  *                                                                              
>  * Must be paired with a call to lazy_mmu_mode_disable().                       
>  *                                                                                  
>  * Has no effect if called:                                                     
>  * - While paused - see lazy_mmu_mode_pause()                                   
>  * - In interrupt context                                                       
>  */                                                                             

LGTM!

-- 
Cheers,

David

