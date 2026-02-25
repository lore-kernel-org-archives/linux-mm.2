Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7CC0FD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 267FD6B00A2; Wed, 25 Feb 2026 11:06:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245F46B00A3; Wed, 25 Feb 2026 11:06:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E896B00A4; Wed, 25 Feb 2026 11:06:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01B956B00A2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:06:22 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C89338C195
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:06:22 +0000 (UTC)
X-FDA: 84483456204.08.59EDDC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id BF1C440013
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:06:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rWGyZhLK;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772035581; a=rsa-sha256;
	cv=none;
	b=qngdixHlSIz6neF5q3NSkq6hfyEGJaDrFYT24kPb6krFRQYagZGaRqIfr9mdtVdawO7ujc
	2lZ7paAMsqzADQdnMZeIyKq06VSF5SCxsHGxTm2Wh+5oj2FzduVQVrPhrrVzVd4detpH6T
	2tyhgvc4sWj0Gy6cxPOTv21iIz4B1XY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rWGyZhLK;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772035581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fFsxMWE1ut4viaW08wuponMeMTtje1DivE0qfAlUAFg=;
	b=LWrhUXSJ2PJG/pPxiUg09YuXc0AH0hSONZgrX9auGpBZM6Qk0o4YLXceGiZMUbaAjrSgfh
	0ZMMIIQMDDnFtq+FS2FpAYTkOZju0zQvRFKEPS0eGWHjRmawyFsthu5E0f3QnbH07O0o1Y
	SsEtM/qMPWkMUan2QDlxib8bboxvW+I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B950142DAC;
	Wed, 25 Feb 2026 16:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04B1C116D0;
	Wed, 25 Feb 2026 16:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772035579;
	bh=P1WqrWepQTVhtGtG9DocW0+fnFtdDHJ0Gf1aJlk8qPg=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=rWGyZhLKZYiW2u9VlD06zBBflxsyka3E89QsxNaXXoJYozgm/nDKuG9XxPVGQGQf8
	 mapz3f7xm5vfA6oingwoLiKzIumwOKnSxNyUEmFn20mpuWWLYJWqlwNvXAD+zx/1zg
	 taAtqF+z50BG/LDGhVnmPM+9p9nDL83129yPJQyyqJFOwfrVjS/7s1NbhAjH32XT46
	 FXdHTpr1kEMaEIlUYiTwmPF3APKoLGnz8kYbap3gxcegegXFjEepDoE1nO9E6Y2QaN
	 l+Hib6lT4TNlVcYEGy6/UxzhaFsxEabsu8fLwBSijjFLR1/AtSNh7bllSkwvTZ3fzX
	 MNUx0aaQP+Jlg==
Message-ID: <35c35f9f-244b-4591-a610-87606d5019f2@kernel.org>
Date: Wed, 25 Feb 2026 17:06:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "ptdesc: remove references to folios from
 __pagetable_ctor() and pagetable_dtor()"
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Axel Rasmussen <axelrasmussen@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260225002434.2953895-1-axelrasmussen@google.com>
 <0d4f253f-6e92-4aec-9df1-e668b457d362@kernel.org>
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
In-Reply-To: <0d4f253f-6e92-4aec-9df1-e668b457d362@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BF1C440013
X-Stat-Signature: n6trg6itix6pcofunp8qniom8qcbj35a
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772035580-960240
X-HE-Meta: U2FsdGVkX19Hudvd3u2BHJGJ2LqP8+u8LnrUggvI0qfMk19vJ4pdXbnj70bZ5MvC2JqwLSDso5Lpo4PpkJ3vc2Mi34JZJiyIxmw722TFqtwEk/iW0F3qLBS1vijFj6OmbtG/BQe6CEMug2Fm8NJ7f/lfS8p9yPWGU96t1XJ7roax8xoA3TkrBeAs5qC1cKTPpKhlzZ49u3wPZsJX0fxnx/vYkot8B8bmaxGYplHpxx0PNyhBXV1NYz3OqHjAkwI7Ij2Hqut1GVLZ2z2IOESq1j6WP37CHiMu2M/hQexUOjOPg+itv1jr1BvnIRNhNXMwREEr7KP591ERyUAC97ie9RT2vK7gz0GQfPgYgwWTY7Whfis+SIO5U/ep5B+cch3JEwbs7sM/XJzxh8gxVaY4cWV+81hP2F7kUyZQCPRVlG4iHQDrPI3PlGtiq6gEyzNBlTS+VkHJRVf3fZxxrw4r+uzbn6AnJYyjA33JH78yNj2OZInotAqnbk6OpswnALQ0+vVt3vH+3qu09oRlHCeqppEWISubJShXsauXYV7lDI3cT3QctTcqOISt6qvZqi7my2ZvR1mvK4jwSp/sjVp/avOGq5VF8S6AoSbCoQUVFbdy0sHRDS0IMhiajwwoWaLylcLgkITWWCWSPBwHPtVbl7xdKlXqNXD8ukK0VpbTVNWVRw8+EF2kzJrNgK/syy/6VAMx0HEm+xXT0x/EGzVQCWKlfHIBXFleiJGvTqEgWXGeSxwKa4vBEL0hJy0lro8xb3V2LWH1oOaMtybQ3GkvpA8zkNtGwXCnk1NED0zPvwkuF6wnhrbMohzY29opSdiyF//rGhtlRLBKmfay1tZmX27FWMcL1Fe5dUs3QGxjipKjHi2FswkTmzd7MTj0cLST2I0791vCoZgoLKeWCQDWFO3NJBnX7PRWE07ZKyymgbADd5XAuQWoNG5OyoG8cvqDHCeF1liFD5C/4GM3Fn0
 XF8npP3i
 U1S6iezR06ba7gGcYciFJ7oEyV/5Et7m1fp/59Ssq2wouxaHeQ2eHsYX78tSlkCZJteyES2+Z8A1lp01SnWfayVsyq9lT20UGxxjUH4vDI0XRXDZqnONeKJC2bwTb25FRDjXLrpabvt3jvAXKY9BqlY0LF3lE3jgVuGZAGA0eQ7nMsoYeXTRQ3dT/fQMJSiVquwdgF/saJosaBvYIsIIJQ20dkyEQu4vhxDkUnYY1ccldggdTeeq0ZwJainogVUsaiVH6PI03NRtX+NzjMSHiT78I2vGHWMAah2v3DvcIBWIh2AkaMfo0AKS0Vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 17:04, David Hildenbrand (Arm) wrote:
> On 2/25/26 01:24, Axel Rasmussen wrote:
>> This change swapped out mod_node_page_state for lruvec_stat_add_folio.
>> But, these two APIs are not interchangeable: the lruvec version also
>> increments memcg stats, in addition to "global" pgdat stats.
>>
>> So after this change, the "pagetables" memcg stat in memory.stat always
>> yields "0", which is a userspace visible regression.
> 
> Argh, missed that these page tables are charged.
> 
>>
>> I tried to look for a refactor where we add a variant of
>> lruvec_stat_mod_folio which takes a pgdat and a memcg instead of a
>> folio, to try to adhere to the spirit of the original patch. But at the
>> end of the day this just means we have to call
>> folio_memcg(ptdesc_folio(ptdesc)) anyway, which doesn't really
>> accomplish much.
> 
> The goal of the original patch is obviously to get rid of any folio
> references in ptdesc code.
> 
> But if these ptdesc are charged, then we'd also need long-term a
> ptdesc->memcg_data.
> 
> For now we could still go through page->memcg_data, to avoid going
> through the folio.
> 
> But that requires some work, so likely we should just directly enlighten
> ptdesc to have memcg_data.
> 
> Agreed that, as a quick fix, reverting the commit might be best.
> 
> But let's wait a bit whether Willy has a comment.

Heh, Willy just replied while composing the mail. :)

-- 
Cheers,

David

