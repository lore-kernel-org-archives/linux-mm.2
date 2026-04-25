Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69CAFFF885A
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 05:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5FF76B008C; Sat, 25 Apr 2026 01:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11016B0092; Sat, 25 Apr 2026 01:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FFA76B0093; Sat, 25 Apr 2026 01:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4286B008C
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 01:57:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56E5E1B7173
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:57:03 +0000 (UTC)
X-FDA: 84696019926.29.CF4D0CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6A04080009
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:57:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="csaj2/sP";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777096621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/SAdnBTygtTh2NK8lr0Q2fCwrNkVrYhcyCoxfv0ysc4=;
	b=Wafdxt94sv8oDwmVC3jUuphNUijF1RVRAKn3CvBE76w7FDSqmU4SAWGZb+JZC4slj7m3Gu
	yyB3KkQtZbYy7JpIjlt9YoCuRYYxZ0M/4q4nUfKbWfo0PYZ2ZRQZwdUIrxR/E8M5TzcGvz
	yi6QWRjh/nMYBmB3oUDJAIjCS9aEDVM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="csaj2/sP";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777096621; a=rsa-sha256;
	cv=none;
	b=SSfI9ScSofewPg0w4n4SDctnvB7nFcpRSag63CMeLiDMsSsaPsdPIM30W7d7AkSt2whSf4
	4Xz9/rHlMaHLXSj9MoaXp3vo1ZVCvGKVv4iZdfbNdHjXEjRvINUa0SlshL8iRyIM4nOzxu
	5rzDtOapw98qq5ECEKhopP5N7BxZX2E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43ABA43AE2;
	Sat, 25 Apr 2026 05:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD955C2BCB0;
	Sat, 25 Apr 2026 05:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777096620;
	bh=Tm1RVF/otoy7t8GU5QzG858Hip+jjhcSOcigpbnnIKY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=csaj2/sPuUjak144yih/NYw1vSry/TXCHzWpoDZcz5rAcuuVYu5iInicKb4zlCr44
	 w9BepnEXbI6L9DWYUaTMPSi6oeEGk7YcprFxmNZus0KmJ4M5azn8XHPlou0JYacw+h
	 bDvFfwrtUnik8NSo1Gm7EzIXQazOuvmYF2mWkscyHv85tIwo2FAqHrxyOovalwtkGE
	 FHiuWIzk5oN8en9lg33iJ/GvC8hEbbBfsyEi5oGw6YUXwmHbVDdhDNCIbdUtvfSzXj
	 8W3+FjlTTLkY0fd5L+eBYd6NWQQo70jpddYtlprwAlT/rvNwT11pUuqG12oFU3uNA3
	 lIqP29VveexVA==
Message-ID: <602b431e-244e-4171-bc82-6ba7ee71fe65@kernel.org>
Date: Sat, 25 Apr 2026 07:56:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM guest
 memory
To: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org
References: <aeImfRrrvr3UoKtL@thinkstation> <aeTnlQUOOh-dHG8z@thinkstation>
 <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation> <aeoxnuGKO3uqS2kG@x1.local>
 <aeo5IPpQi7onyjTF@thinkstation> <aeprnnccJeyHB2rt@x1.local>
 <17b0dc02-eee3-46d6-9afb-5f81a3a20216@kernel.org> <aep8tsYFfr_Xe54q@x1.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <aep8tsYFfr_Xe54q@x1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6A04080009
X-Stat-Signature: u8dfry68qb399iajph3gefo7bmjk5yb1
X-HE-Tag: 1777096621-300948
X-HE-Meta: U2FsdGVkX1/w0h78SZDo324a7bba4BBMnki9MhAdmgKZJCrN2ZxWAg4fD9R8wsnzTib9yv0nrDQGkmAbhMiJYpn446YREWy9XLFRcIjwR7RSQ/+QGnmLNDGdJQXRMcDqspabYuQKvlZT2KO9IUH9JtOueFCtNEi6gtppKFFuVrjAl65aLCYRnd1NCL6hpp01HOV3XsOiWuoHICSIlRQTU+T9waG+ZHmDmUEZY/33AjOubKgdrP3FOSSTbryk5pnML8q/F7l3NQSk/+MeZFYFluBjnaLRYJhm0ULYPGdg/+ZJhsSacxGHP0K1s7Qhf4VOubvFZvRBmYGBeczbrpCOQ8/E8eIr1b/WL6m8ragO2zCjWZ7MsBXRYkva3s5/lW7rByN2+HKh2gEasy0V06WO/YvOU3rY2cFAzn4w+SHRSNgaCHn5+G5i/Cb0vhDu/wfKiJEl+NhF/QsyVGAwppMcfSPzIvcX8Tj/jcd+huhJVL1vpwst0UDq0HK6kXKZcrIZPn2FBhYUQ0NB7epEOjJfIUTLBH+q6WZ3ABfqZ9NlznwApLaExcrYL1VcwfUYBOin317MHvkHGYoiso1Ie+34HhzcecEDqGyAmghvGACyA3Rz5wr/EYDJ7sph9He0y79fn3zrRavAg0KzBqX2FwuVSijG3P92YU8lsZeWuEN1Wa1TnSSgvArq47oOVHP+coyDpNNms69TR6nKwvprwCEObS8se7ZCmC9gN0oTEDtvzYNXB4aymBbjD0FnAYmbVGvTvQyH+hudRtzeiXyNa6M2MWI4sFud6cXsd2BbhjpaGuJIbL9pM0uT7DpyfQo6yYofG9b6yrymJ9WAnE5nenvQZduBzW2VyhpkRpsNEDue4ux/1xdhFriYbgyyQlTiZqqxg8nbJTWz2LaUNHyAYNSgkHcw/rYpNu4qlTZtYqAYdfVnVeHjw74F5ZSNtHaa6mrEObmvbkltf68fHvbIQOB
 KwGqwfrk
 e2eNnkJifZcVjaZK40HZas2Vc1q1PgZWDO/P2+S46Aj43BLuvQ59zvWspRSpLOpurMjmPk/1erSrASNpNn4sfhOl734Z7qS0iG6pdqQBqokBT1lTynW398ulXlBvDWad26Qnl/2ZELMCCh4+/94MsFPg1DaWx7JIQUl/KmI+wlD/TSFz9hpdKFqZT7tVbiEeP9RnIjaKs9wQQWLsOf2h9j0+0uEDlm6hVDXgwEbb1DwXnrfKGL6N+ULKAiJgWbNMdApCPeWmCur8x6PQZpmFgoe2a/6u2QGzNu/vQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 22:10, Peter Xu wrote:
> On Thu, Apr 23, 2026 at 09:25:30PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> The other thing is, as I mentioned in the other email, I still don't know
>>> how the current RW protection would work for anonymous.  I don't yet think
>>> the user swapper can read the anon page with RW-protected pgtables.  So far
>>> my understanding is maybe you only care about shmem so it's fine, but it'll
>>> always be great to confirm with you.
>>
>> I wonder if uffdio_move could be used for a swapper implementation instead?
> 
> If RW is justified to be useful first, maybe.
> 
> I had a gut feeling Kirill's use case doesn't use anon at all, then if
> nobody needs it we can still decide to not support anon.
> 
>>
>> If we ever have to read from a protnone page, maybe we could teach ptrace access
>> to do it, or have something that can read from prot_none areas -- like
>> uffdio_copy, which can write to prot-none areas.
> 
> Somethinig like swap_access() in my proposal can also partly achieve that.

Looks more like the hammer for the nail here: we could fault the page in just
fine, while keeping it mapped prot_none and keeping the uffd-rwp pte bit set.

I was rather thinking of some uffd-specific thing that can read from a uffd-rwp
protected pte without trigger uffd.

> 
> https://lore.kernel.org/all/aYuad2k75iD9bnBE@x1.local/
> 
> There, it was only about reading from swap so far, though.  But that one
> might be easier to be extended to read PROT_NONE and directly put data into
> buffer user specified (ps: in my local tree impl I named it maccess() to
> pair with mincore(), but it doesn't really matter; it doesn't even need to
> be a syscall..).
> 
> To me, the interfacing is not a major issue.  The major question I have is
> why RW protection can help in swap system impl when we already have uffd-wp.
> 
> So I want to make sure the use case can't be implemented by uffd-wp already.
> Because that's really what we might do for QEMU.

There has to be some added value indeed.

-- 
Cheers,

David

