Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27063CDE007
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 12:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE5C6B0135; Thu, 25 Jun 2026 08:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27E0B6B0136; Thu, 25 Jun 2026 08:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1460F6B0137; Thu, 25 Jun 2026 08:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D89696B0135
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:08:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F51FA0639
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:08:48 +0000 (UTC)
X-FDA: 84918313536.09.B9F05E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 88F7040016
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 12:08:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FGW6k/JE";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782389326;
	b=vvIdKM2YeDKfRnhMrSKBLpMmX+Xh6HMeiDv3X+7eT6FIeBejWw0/Oh4tY2Yxb4uhRuzND0
	UpkiBBpyQ69PBpA0tG25CZUa4nVfTHmyVOaqDMCLbbDZ+s2APCKIaF33hwXDfjMMEponY7
	7xNFKVZ+UXeUPDRIg06i7mpHaSL0Eto=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782389326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUMnbm9PMtjxsIHIOqPvFeqdrsxsns25/0hnbpw0h1E=;
	b=sulXMPShWchA1P7n4GQyvAq+StGbwv3KhWSY/cXthBQNmKcXwPJfvyXo0dSrd0LcFTsYZs
	9XdqlERrq8DrEF0d8fmi8oUgQnKRP7wSM6Ftqtvabg/mQ1oZDO67mWQQzAyMWXgDSV9UhZ
	tO8KIoRxYLmKGdmFqvkV1rv+v2sYeIQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FGW6k/JE";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A6F560217;
	Thu, 25 Jun 2026 12:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9B81F00A3D;
	Thu, 25 Jun 2026 12:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782389325;
	bh=bUMnbm9PMtjxsIHIOqPvFeqdrsxsns25/0hnbpw0h1E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FGW6k/JEa1F29Biq8P0vCqd0k0Iz3i4FBze/O3ByQhUqGW3nmARz7FElqJf5IiP6Y
	 9yfZPETp1G1DBFaYy2/Jp5qdeRMDJhDuR+3lJ3Ws4QF1C/MKAxEP6BxfU+y+rhLoYx
	 iSVynPoCQm3SjVeqSOMTBTeDVJxZRbSIPCXq3dj2ooNgB/1R95WRbGT7c2P0TCQmoG
	 b3Mqj9wg65NLkOBLmoZhLG+PiNzPCsuV0F3m3T7hsp89RH55eGAS1YXrrOpyayC3vx
	 xrnAIhQQ2zAuV4Wui+vkhZ0adzwFo8lXc8E0rlzYHV/Am1oIDNTPNa3nsu1yRz5X37
	 LZM0i0uAKvkbA==
Message-ID: <7efb57b0-7205-440c-8638-2ec5354aacce@kernel.org>
Date: Thu, 25 Jun 2026 14:08:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <20260625071830.996043-1-hui.zhu@linux.dev>
 <2c4dd46a-4755-4bf5-8f14-2d73eb356e3e@kernel.org> <aj0YlpCkGySxt7-D@lucifer>
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
In-Reply-To: <aj0YlpCkGySxt7-D@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: mqzn6e6oa4z7uc7omb6yhpk81kr4wxdc
X-Rspamd-Queue-Id: 88F7040016
X-Rspamd-Server: rspam06
X-HE-Tag: 1782389326-337017
X-HE-Meta: U2FsdGVkX190k3hm+RGbwmQB8hA+g7W2ngnjLFuJex5emxkcjL1Sh2nWbjyWthNb8439jah02thhISPTyYXz5GXr9yGr1/w6jkRfqwduumOofCPytrJ4EguiMeMAR4fsC1CKOPTcb6bKUdvR87w8P6sVTtEND5YFVrTdwqMDnrhF970cFaTnLZsuaY8A1n3ujHCz94MRWNSp1ZlecBdzN3Krf+kC/rpHCbmAhqMU1xhjroIS5MwlufRGXg0Ia2RPKWfufVIGCLjA+EDnLZI5U3sP3sBt55xUeA4gTGI5VaY7oB7sAz4AGI5JZLq6ZN7qL958+I7JHBFnEsAckCHSMoLwwYgOivWLm+zX8n41um5GPfqixfl5+HS4hRdSO0M+3psQEC9L6foJYroRqgaugADYIxCO9CZ/QuSXlqtYYCi5UctbVHbw5WPbr3Wb+w2+97f29EHoIGOAHir8Rd3SbxmhhWDKmqf8RBMMeA4FsHKkRenD3iljbKDX6cwqUOdnKYhq2qqdz2PmtU/5f2oVy+94cVAJ6Npnpi8upC2yU1euoVvZe7YEocsO9yuU+b9zyak+gW5F/pmxbsZ/gbAj8eozmXHEg2nANT4dxPqStQou0m9bDmQaQqFl6tQOapEfdfL9r/DXNNFy5NHGu/p4EyN+yy5PRCvXVK8d0w0L6hA+eANqMGs2tXbfcWhjbTPnu2JD/yDsS7yWiItYfP9wdKPrCLG2773C31eTDpA2pQPIaK0O4ba3bwfnCCCHztRVC/Io0VnBDM0XRVHcUn6rqg09x2vCN1ceW2Aloh6O3lGsmXti8IZBh3q9YRL5mEXFkPworUzWlSYNiX88JEisC3j0ozJOHbJn6EjVWQxKUJeQmZ4RXyoVss+SPXtL02JLYyrUKL/ivlUH+/t+2cEe4YAeFpP8EOOfdRZuVDA9dUT7i2dlijND+4k2lsGzfubiiUmpMrdBmkJ3GZCjl88
 5a/qqiFA
 Zp0YTH2jnwlShHJvqZV3LkswlVGxEly4bGplROnu6z62YZdKX3xUsq73bSQGjzyEAD4PUAMezbvmuBpTkM6fk2X9VXzGgOESh356HyVdZ0aWEKAYwnkbyWn2QTZe/O2IMgdu3Z4eZFcKekleeqgc85msFrCMg/MnG6eUYvJr4cnTo0M7dhwmESMHzw69WmCpSbww7PVojt+keow1s+FJQXKIX4NHN0NKaE+qBMKW1Wk54gTx1yxvyfsTFBQ/WVNWeOQIA1oJ36F3hjIDUP0vm6qOIrg7/9A17lNreww1bBdkD6Zi04Qt8iS1iEa58sttLM1LOqkJXxyYjn6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 14:07, Lorenzo Stoakes wrote:
> On Thu, Jun 25, 2026 at 01:53:14PM +0200, David Hildenbrand (Arm) wrote:
>> On 6/25/26 09:18, Hui Zhu wrote:
>>> From: Hui Zhu <zhuhui@kylinos.cn>
>>>
>>> KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
>>> page->flags and folio_trylock()/folio_lock() concurrently doing
>>> test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
>>>
>>>   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
>>>
>>> The node id and zone id occupy fixed bit-ranges of page->flags that
>>> are set once at page init and never modified afterwards, so they can
>>> never overlap with the low PG_locked/PG_waiters bits touched by the
>>> folio lock path.
>>>
>>> ASSERT_EXCLUSIVE_BITS(mdf.f, ...) inside memdesc_nid()/memdesc_zonenum()
>>> checks a by-value copy of the flags word, not the actual shared
>>> page->flags/folio->flags being modified concurrently, so it doesn't
>>> reliably assert anything about the real race. Move the assertion to
>>> page_to_nid(), folio_nid(), page_zonenum() and folio_zonenum(), where
>>> flags is dereferenced directly from the page/folio.
>>>
>>> On CONFIG_NUMA=n, NODES_MASK is 0 and the old memdesc_nid() body
>>> folded to a constant, so page->flags/folio->flags was never actually
>>> read. ASSERT_EXCLUSIVE_BITS() is a real runtime check that can't be
>>> folded away, so doing it unconditionally would add a pointless read
>>> of page->flags/folio->flags and a check that can never fire. Keep
>>> page_to_nid()/folio_nid() as plain "return 0" static inline stubs
>>> under CONFIG_NUMA=n instead.
>>>
>>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>> Changelog:
>>> v5:
>>> According to the comments of Sashiko, guard the ASSERT_EXCLUSIVE_BITS()
>>> calls with #ifndef NODE_NOT_IN_PAGE_FLAGS (for nid) and #if
>>> ZONES_WIDTH != 0 (for zonenum).
>>> According to the comments of David, avoid calling
>>> PF_POISONED_CHECK(page) twice in page_to_nid().
>>> According to the warning of lkp, switch the CONFIG_NUMA=n
>>> page_to_nid()/folio_nid() stubs from macros to static inline functions.
>>> v4:
>>> According to the comments of Andrew and Sashiko, set
>>> page_to_nid()/folio_nid() as static inline stubs returning 0
>>> under CONFIG_NUMA=n.
>>> v3:
>>> According to the comments of Andrew and Sashiko, move
>>> ASSERT_EXCLUSIVE_BITS out of memdesc_nid()/memdesc_zonenum()
>>> into the page/folio call sites.
>>> v2:
>>> According to the comments of David, remove useless comments and use
>>> ASSERT_EXCLUSIVE_BITS() in memdesc_nid() instead of data_race() in
>>> page_to_nid().
>>>
>>>  include/linux/mm.h     | 23 ++++++++++++++++++++++-
>>>  include/linux/mmzone.h |  7 ++++++-
>>>  2 files changed, 28 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 485df9c2dbdd..772bd1fc6fe7 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -2294,15 +2294,36 @@ static inline int memdesc_nid(memdesc_flags_t mdf)
>>>  }
>>>  #endif
>>>
>>> +#ifdef CONFIG_NUMA
>>>  static inline int page_to_nid(const struct page *page)
>>>  {
>>> -	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
>>> +	const struct page *p = PF_POISONED_CHECK(page);
>>> +
>>> +#ifndef NODE_NOT_IN_PAGE_FLAGS
>>> +	ASSERT_EXCLUSIVE_BITS(p->flags, NODES_MASK << NODES_PGSHIFT);
>>> +#endif
>>> +	return memdesc_nid(p->flags);
>>>  }
>>>
>>>  static inline int folio_nid(const struct folio *folio)
>>>  {
>>> +#ifndef NODE_NOT_IN_PAGE_FLAGS
>>> +	ASSERT_EXCLUSIVE_BITS(folio->flags,
>>> +			      NODES_MASK << NODES_PGSHIFT);
>>> +#endif47
>>
>> This is getting ugly, really. We're leaking implementation details from
>> memdesc_nid() into folio_nid().
>>
>> Maybe just turn memdesc_nid() into a macro where we can just do that check
>> internally? Not the best thing in this world, but better than this here.
> 
> Could also do:
> 
> 	if (!IS_ENABLED(NODE_NOT_IN_PAGE_FLAGS))
> 		ASSERT_EXCLUSIVE_BITS(folio->flags,
> 			      NODES_MASK << NODES_PGSHIFT);
> 
> But not sure if it's that much better.

It's still making an assumption of what the memdesc function we're calling will do.

-- 
Cheers,

David

