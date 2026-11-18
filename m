Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BED4606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n82NdDEF
Received: by kanga.kvack.org (Postfix)
	id 462456B05B0; Wed, 18 Nov 2026 04:39:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439BA6B05B2; Wed, 18 Nov 2026 04:39:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F336B05B3; Wed, 18 Nov 2026 04:39:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4A46B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:39:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A14A01606CB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:39:03 +0000 (UTC)
X-FDA: 85447740966.12.B54B34F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5C1BC0006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:39:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n82NdDEF;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794994742;
	b=kieVkAM5U8eopYTOPM2H8vblM8eYF9FvlZ2Q41KaiKu+wQXuZvmxkbN1swa932hS5Xwte/
	TPBNaSq82oEXqK/1RJ4QOpXrdW7nlYoJiiouKffkEqV1BAJjwl8LxSHKGYkqonofhFLCxu
	Y2MqDvKZz5bRvk6gDLtW9Tp+imfxT0c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n82NdDEF;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794994742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFcykN8FbTzlkQb2QKEzQvmDwgjWoZpHj6xZz+E6k4M=;
	b=TI99CMM8dTUotKIalCI7gkAgQH8R5BempBPqk9fHkuV6WqSesladc1mqfVSP8yOp8Djxs6
	uPCleKoRRADtf18/mxX8+wLUqeYEigjHuKYmwucD6TXVsHMSbIbx+vY6/DQuYJZpJxGQ+c
	H2rJTAHZ1FcuXUAs9zTQ7RG7TTfKtTE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E2CC043A36;
	Wed, 18 Nov 2026 09:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF601F000C5;
	Wed, 18 Nov 2026 09:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794994740;
	bh=pFcykN8FbTzlkQb2QKEzQvmDwgjWoZpHj6xZz+E6k4M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n82NdDEF2Y36movBI2landvuiWeoHOsmHhM0axpee/x9FcrkaT0e7kHegUZLC0CvF
	 qSvYrAS1IbaeJgTOvIYTCMd6GgQYjC/tfTiJ8h00Q3mKJ7YS6pb9Q7i1/8jl3xVCyW
	 QaL07DWQ/xNeUW9xMBJ2DHZOe2ctnISw2rNuK9eOpzWD4Nzm+/RHaXBoSiBEOaoo51
	 plyeS3IfMN9yjUGHkaR8vM6lc6WeDANPUDcmhkd+abr6XWQALHYCyIl0x3BanWBsr8
	 5ZnW5vVA6nyfhNIOmPbF1b9264K0HKSqoU67uP/QLdAuzAQ251KopKwjWu+lfYE/B1
	 Mn+2t1rW1PM5w==
Message-ID: <5b195d44-66f5-4d9b-bb79-259fa938cc59@kernel.org>
Date: Wed, 18 Nov 2026 10:38:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] mm/userfaultfd: check the hugetlb alignment of
 every VMA in the pre-scan
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Andrei Vagin <avagin@gmail.com>, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <20261117-uffd-state-fixes-v3-9-b617009d1a4a@columbia.edu>
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
In-Reply-To: <20261117-uffd-state-fixes-v3-9-b617009d1a4a@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C5C1BC0006
X-Stat-Signature: 1e5pu6aq6eycmtq6siwokom8for7jytw
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794994741-153471
X-HE-Meta: U2FsdGVkX18EEy2Y8D8kmEtd45RNTpFj1ijgtP7TbCpB2IyM/IuIOWT5Dt9BP6e0lRTHobvHe8nCwyPRD26KInU4MNrMcjiwgPUy521J0E7Fpjolzli18lKrxe7ArGwWH5xT4CDBfN4Aal3Wn9drX1iOq4nMiTObvSMz534oTFise1tWIp484BzESVanzLejbK7DXN0M6rnlryh17etdoL/8PhLXgkQ7+xBfUswHzFV8qkI0H5SExiANnOaawMEgnbFPcq5CNVOrLep4XXfhkUzTgsQQQ5sIZKI5w5ULmPJgbUHUpTbQ6qfZ9tSeW0VT8XCBwm9RXQd4thYq7c+OeIwfsWxhAe4XOgHisIcxPVPf6w1g0nUopYIVZ2zQ5W6wXjVRG+BzbgcwzSoI7O2ONyEpDqZBpXTbqfw0HNzCk50neSBIvd0CRhivTLI3DsT3CG1N3nZ/KjZcmUmZpEL014zU1sOOI4e7n+R9XDgMtxhb+oZRUocfmG0O11LrnlNMva/UYED0h8RGTnDE8cby1OCoLMXm1XMy7FX8wlECKXshBrZ7UjplGlLo6g+2VARVegsyMo93dVnfloWRBEtzUGpTpkG0u+SG37yND0Tb7GLAqaGEiS+MReI8PeFtLG3WeDW83D56wK2GMFYu3wx73IEg7AJezXxf7+fjbZZqhAza56hXzZgJ+ZQTrLjoc5Gufoo+qVwGBlAsT6F6cxbXEGBCYNgnyyADMr+dfwfREjiHlTf5IHHw1MiyOGUCOqeMjFng+og5j1A9yFtzEGuYn0bHKTwaalitQ/37FS0xMlezsu1GjABuniUZybcq0cb5jqUKctZ0hHwIWvPKMkRTxFKjy4g8EwILEUfbLsCdH8GHuapl+kSLjh53GNP/dWgjnhLgSQYfjfjRHyqkEKDpH808OjwQCL2/6eukus9EP+GfLlkN4cr0OsyoWzwUQkIv1c163ZblIEWCu27uSZg
 GWW5gMl2
 tqNcuKQYNRNAu+E8R9/ca1LwS+daEWApN4p+0uCM/0hEzBXQERD16AAqmul8RavEv/kkGTryV21IEna8+5vME2eIx+1WsJnTl9Umi8ys8CT1ccpss/z2BB5JAhtZg6esLcKXCGy0KpDbftSyTshR3YXkReEnHPWvWM7mTXizDBHpI82jxmliA7yqC9mqbwCXUtZmJplfC6EvVOHfYc1dNiQccOKj3+Ch7KBZLH6k7pAI9aQeG+JZ/djKS5/RAS9yjEQgatPl/LPZlNhhA9tWt0nNuVS9soomAzVCZKv79vPy/F4vRdC1OaAV/eSarxjBW6mXU0u+FassD+3JYKh3rGmthcNlaaCSbKFU2ylUJ1PrQsMpXMoMqyai0iRZPsofNYUP3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 05:28, Tal Zussman wrote:
> UFFDIO_REGISTER and UFFDIO_UNREGISTER both scan the VMAs of the range
> before changing anything. For a hugetlb VMA, userfaultfd_register()
> rejects a range whose start or end is not huge page aligned there.
> However, userfaultfd_unregister() only checks the start.
> 
> An unaligned end only fails later, when vma_modify_flags_uffd() cannot
> split the VMA there. At that point, userfaultfd_clear_vma() already
> cleared the WP or RWP protection. The ioctl returns -EINVAL and the VMA
> stays registered, but accesses to its pages are no longer reported. This
> requires a caller passing a misaligned range.
> 
> To fix it, move the alignment checks into vma_uffd_range_aligned() and
> call it for every VMA in the pre-scan of both ioctls. UFFDIO_UNREGISTER
> still returns -EINVAL for such a range, but no longer unregisters the
> VMAs before the misaligned one first.
> 
> Checking every VMA the same way also changes the following:
> 
> - UFFDIO_UNREGISTER now returns -EINVAL if the end is not huge page
>   aligned in a hugetlb VMA that is not registered. It used to skip that
>   VMA and succeed.
> 
> - Both ioctls now accept a start that is not huge page aligned if it is
>   not inside any VMA and the first VMA of the range is a hugetlb one.
>   They used to return -EINVAL, although such a range covers that VMA
>   from its start, which is always huge page aligned.
> 
> - UFFDIO_REGISTER now returns -EINVAL rather than -EPERM if the end is
>   not huge page aligned in a hugetlb VMA without VM_MAYWRITE.
> 
> Fixes: cab350afcbc9 ("userfaultfd: hugetlbfs: allow registration of ranges containing huge pages")
> Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

