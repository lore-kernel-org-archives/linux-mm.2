Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF82BEBFD12
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 08:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4056B0096; Mon, 13 Apr 2026 04:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CB2E6B0099; Mon, 13 Apr 2026 04:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1DE6B009D; Mon, 13 Apr 2026 04:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F18646B0096
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 04:15:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C12D160C8B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:15:18 +0000 (UTC)
X-FDA: 84652822716.08.D266D9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E3D73180003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:15:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mbiFSFfT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776068116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Lu48lztwRaIfeIQCr1c/kAA65MdcWp40T7yg/djCBw=;
	b=Mxuv7Oujnu3R3f+jRqCUx7hziOuPTSdoE5IKgvdjk13LdKJkiM42HEOJBxe5dJiaOqQLkv
	zFupI25EBgMBAqsvqj8pbTFdfbYy5ytZa/k2028guzyTBPp0AQW1t2hmXaNxy1AcN9RhSs
	/qlUCyPFYW/Z2KS0LR0hliQdVk2dTiQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776068116; a=rsa-sha256;
	cv=none;
	b=B9v75egCK9+im14nQfb7o7O2dOgDvac7vD7EtyLgnSIBiaPKdUadfvUg+FO/AUQxNxMQNH
	CiuvIfEtqal1EMj7q68nyLUjVbme4T7mjOW3VkWkzhOvhy+V2CJDk+1Nt1Fi/4hcPUJf1H
	7WxBO29wClemmvG2cZIlCd3jhnNZC0A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mbiFSFfT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 417CC6091C;
	Mon, 13 Apr 2026 08:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1349FC2BCB0;
	Mon, 13 Apr 2026 08:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776068116;
	bh=33NTUTIwsDbi+rzZUkVvN5OJH7UDAeSwaboNiGNq9+A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mbiFSFfTNcEKw5YAOH4DOxMGSmBU3n6+O+zj2mN2C0clNi0DFYW7IwqtZYNSPgWE/
	 fqZSbHWxiO7a7rDnRcRNeDH/rQjwiPk2mvQemSbQ4p6RSFAF485IKX3d8/UsiSojDS
	 Fqq2ExtLmFLznIr1GYYZw+zchzSAR5WH9da9skaePiJiHkR0Ip1vep7slyLcTFebpU
	 5BMuJv9XPQR7cgpvGYvQ1uWI6vOOsYZaVi/gdV0b1Kk4wUT3VsgoMgzMXZwIyrbkVt
	 TP5XU6xiYzseMGWJ3cRNQOa6qesQgb9weZ9LuW09e3ZJEz2T0Biq/8OEG+bbf0JCMO
	 wWZy3fyLHZPFQ==
Message-ID: <4e1b349b-d0df-4ad5-8050-9a2b3b3831ac@kernel.org>
Date: Mon, 13 Apr 2026 10:15:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/9] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
References: <cover.1776033471.git.mst@redhat.com>
 <ea67e39bc3aea1b0b491908f851ffce25154cd26.1776033771.git.mst@redhat.com>
 <2155527a-e077-4b71-80ee-d735f9984f60@kernel.org>
 <20260413040143-mutt-send-email-mst@kernel.org>
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
In-Reply-To: <20260413040143-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E3D73180003
X-Stat-Signature: yhc1k3a8mdq9e9f43qs59t9b1n6oq1jg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776068116-937563
X-HE-Meta: U2FsdGVkX1/mUXGNfnr9BbD89V7cqlRUoFIUoQV4oSJU4aWKqFruCl2xr+NpFbF9fM/pEomqc0X4ZmzroZuDPr2TrxwRxJsiZtd3UYxpNrmCQsbTJ6San+VLpRAOEjQ+yanPhKLgZVALJmWzVwiiIVPoTE/CV4tEuZetp8PWYm/tCoeQ7NvOShWY9JCxVMIo8ThGYyxMTIrfC7ZtCYhnsqR+xomIWjl5zHvxtH7lxIiuyyCfrRmfiZ2Vtxl2urMpbmukp/mK9t/qsHX2apAvxUTbE//OGJglhDMAp5VZyK3uiOn/+AppCAzaYgeixMqWQQOOaturiGa8PvTCig4pQ0juBOIcASkRje+VAZoYZFwyvNq9syZ5M4YEcmv2NzdcgCCkWmbl/zuKyjbuccSkmcq8DX7Zynh3RGYzaODKd4fkN9Eb3dE17a9pg2iP58kDUn4T4KtjqmgCJXcmgvnjp5k92fy2hFqXASQJyFzgQDbLzQIrnSeF4R9utPItqSPsTgDI07/AW8pwl6wNSHLhH7FYw0K4o4XGxW2Ec3Rd9h0UZ9tu4vIyTJorwpkCgZh2jV0HwTwSipmCdvCx98VRh3dpTPkt8RyIKvfpaYK6ir3pmRI1C1nZhU5RaZGDCxYnrYmRfTASrwUaJiuVjD+jkbNoo2Fd2eBvovmaZeqT+o+AbpXhb9wVn1A2BJ1/sI8pVl5VRIDXlqCNKaa7IHIytFScdVNwMsosJdhoTOQ48blBsMcZFRoDiadLj099RGc2+PAe28H2DvMjvCSM9mz5qUB4r3kQVESRDlG3nTc3CwvdY+LTK+ijmTkl68FPPnTVWH2YwND7rfdW/PF2DAvIbBX4GUK27I15+UfL+uHO65l3hnHL0UEpdxTCoL+yfJUhqWPXIX8sc7m0A66+AH9EjlshkuyTWjPXYuZwZdmfaxKxC7dGLFEYGxOryxtIFUgOAGthl0KojLWPHWL1URN
 ku19OsEM
 p6hP6H3t09615PKtOZUl0RhIfOep6qIr6bjdP/O1j7aFHQ+k1Mufo73nCYi2doMEOdtHunws2EhJQTpG3Ps6q13ZnFHjtB28YLveSlUIOEMBlkaPY/vx6war++ZMeGUduF8XVb/S8Z1+yjsqD1yfi/EfoIhCPNxi/4wEZPjJbFWZs8xl3fQgg0CyWd7hFVexwJpDbp+3Hvjr6X3Wp4TqWe5IrzPJchbQlu7ujxAskY1fkZWll6X/lSeQpzkvryh7kcOJsWeVQu7oXdGAy4f+dIHEscauqhLPHfMBP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 10:10, Michael S. Tsirkin wrote:
> On Mon, Apr 13, 2026 at 10:00:58AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/13/26 00:50, Michael S. Tsirkin wrote:
>>> When a guest reports free pages to the hypervisor via the page reporting
>>> framework (used by virtio-balloon and hv_balloon), the host typically
>>> zeros those pages when reclaiming their backing memory.  However, when
>>> those pages are later allocated in the guest, post_alloc_hook()
>>> unconditionally zeros them again if __GFP_ZERO is set.  This
>>> double-zeroing is wasteful, especially for large pages.
>>>
>>> Avoid redundant zeroing by propagating the "host already zeroed this"
>>> information through the allocation path:
>>>
>>> 1. Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
>>>    drivers to declare that their host zeros reported pages on reclaim.
>>>    A static key (page_reporting_host_zeroes) gates the fast path.
>>>
>>> 2. In page_del_and_expand(), when the page was reported and the
>>>    static key is enabled, stash a sentinel value (MAGIC_PAGE_ZEROED)
>>>    in page->private.
>>>
>>> 3. In post_alloc_hook(), check page->private for the sentinel.  If
>>>    present and zeroing was requested (but not tag zeroing), skip
>>>    kernel_init_pages().
>>>
>>> In particular, __GFP_ZERO is used by the x86 arch override of
>>> vma_alloc_zeroed_movable_folio.
>>>
>>> No driver sets host_zeroes_pages yet; a follow-up patch to
>>> virtio_balloon is needed to opt in.
>>>
>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>> Assisted-by: Claude:claude-opus-4-6
>>> ---
>>>  include/linux/mm.h             |  6 ++++++
>>>  include/linux/page_reporting.h |  3 +++
>>>  mm/page_alloc.c                | 21 +++++++++++++++++++++
>>>  mm/page_reporting.c            |  9 +++++++++
>>>  mm/page_reporting.h            |  2 ++
>>>  5 files changed, 41 insertions(+)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 5be3d8a8f806..59fc77c4c90e 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -4814,6 +4814,12 @@ static inline bool user_alloc_needs_zeroing(void)
>>>  				   &init_on_alloc);
>>>  }
>>>  
>>> +/*
>>> + * Sentinel stored in page->private to indicate the page was pre-zeroed
>>> + * by the hypervisor (via free page reporting).
>>> + */
>>> +#define MAGIC_PAGE_ZEROED	0x5A45524FU	/* ZERO */
>>
>> Why are we not using another page flag that is yet unused for buddy pages?
> 
> Because we need to report the status *after* it left buddy.
> And all flags are in use at that point.

I'll comment on that on the other patch, where __GFP_PREZEROED, which I
really hate, is added.

> 
> 
>> Using page->private for that, and exposing it to buddy users with the
>> __GFP_PREZEROED flag (I hope we can avoid that) does not sound
>> particularly elegant.
> 
> But propagating this all over mm does not sound too palatable, right?
> There's precedent with MAGIC_HWPOISON already.
> Better ideas? Thanks!

I'll comment on the __GFP_PREZEROED patch.

> 
>> Also, if we're going to remember that some pages in the buddy are
>> pre-zeroed, it should better not be free-page-reporting specific.
>> I'd assume ordinary inflating+deflating of the balloon would also end up
>> with pre-zeroed pages. We'd just need a (mm/balloon.c -specific)
>> interface to tell the buddy that the pages are zeroed.
>>
> 
> Indeed, it's also easily possible - it's a separate optimization, though.
> Another simple enhancement is including hugetlbfs freelists in page
> reporting.
> Doesn't need to block this patchset though, right?

Not blocking, but I don't want something that is too coupled to
free-page reporting optimizations in the buddy. The comment above
MAGIC_PAGE_ZEROED triggered my reaction.

-- 
Cheers,

David

