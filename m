Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E202606A335
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dPXfLhRl
Received: by kanga.kvack.org (Postfix)
	id 343AF6B06A2; Wed, 25 Nov 2026 05:28:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CCE16B064A; Wed, 25 Nov 2026 05:28:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E916B0613; Wed, 25 Nov 2026 05:28:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1E866B099D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:28:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52E8E1A0D71
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:28:11 +0000 (UTC)
X-FDA: 85473266382.10.F84F69E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 788C7A000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:28:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dPXfLhRl;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795602489;
	b=NfebJzP0vrbkFYiiFuHocC9s+TcvzHOvNDbuIkwrWIclB7tQZ4cJgnshy/ZDuep4Vhb30q
	TuIWITWdrm35zDB14Q6kFUzXjDewhtT+b5dXUbqDu6/Qgv0u+BLlGhud26NNmGT+5HYmqj
	FK5h5BsVIWsL+RQ+6j0ggjy25NONk2Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795602489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGVz8MkfrWT99NOgoSClXzB3TiqbC7fJ6Ti/DWb6XV8=;
	b=l+Xr5hkMCjIGGZ8OLBOxK57kxsZAxw8LaASRSsjP+z1v/m3dCvL0St+ViDi6vPhzVPy7xa
	UumxN8LfgWqcA/hBIjmzB4b3wc4IUpcpg2Cr16B95wGI1Eckb46I63tKuhFUgIotKNWC8P
	2Dwlqsz7nCFMBW8uzNjct7p8IzoEdhA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dPXfLhRl;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A4294137A;
	Wed, 25 Nov 2026 10:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5B21F000CA;
	Wed, 25 Nov 2026 10:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795602488;
	bh=MGVz8MkfrWT99NOgoSClXzB3TiqbC7fJ6Ti/DWb6XV8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dPXfLhRlNX3C47bTvyfqDSPoT+ngQnO1ogDDwToQbuHwgruya++gG0PxLaInNTGUM
	 lYbCZk+rU0bcihXPKtTnde6wbQxpNGOVLAuh0Ve7aATx9pvU+BvWjX0vBNy9ufMptf
	 FDPpZvPelhxf5xOW2jsfIZiVFTvzxBdSJVrHrfV9I7HAYijci6NweyiBxDvExL2uzG
	 A6NiPTZpI0m8RuK2U7tC7M0RIaITOozt+dduoxm6wjf6pVOG681AQLd5KAWL9KqSnF
	 bUCuMIUsrByWE+o65RckiYhXigGW4FiBeRcpsjHz1kesmIEAC0fCAflmlqRm5yz2Aj
	 Zsevq5p/BAYsg==
Message-ID: <83953464-5b75-456a-abd0-9c4b4b82a481@kernel.org>
Date: Wed, 25 Nov 2026 11:27:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/ksm: prevent zero-page remapping during
 ksmd-triggered THP splits
To: Nico Pache <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
References: <20261122-b4-ksm_fixv2-v3-1-f78ea7779746@linux.dev>
 <27c7a176-cd38-4e2c-b2e6-ad63b79ffc07@kernel.org>
 <b69a5619-87bd-41bf-9125-95f17f232c62@linux.dev>
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
In-Reply-To: <b69a5619-87bd-41bf-9125-95f17f232c62@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 788C7A000A
X-Stat-Signature: tkpex4fym9rujorkra4kipsjr8qknuio
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795602489-554239
X-HE-Meta: U2FsdGVkX1/X7sTDCtEM4k8hZ4Qyc7QyIn8cHwvNXdxiQ4+Kr80fzR7hYb04lke37diKIqqPaXeGGtZRHpEIRNHRDrnGFGT1tYHnr5qDH8V11lReo1AU/btxgJnH+gL66K4u5bPswMCBGlyy8HPr37kqtu9f+kDrONroDwfl/Cwvm+cFIRoaVxiFPlNLSoPphVBJhSR9ZF2LOrFFcaz+miO7igLlRR0/gvPATJZF6l7LXKNzL+u59Sm/WCikgW4a1ThRZp0fEP6i2EgE4h3DJW9Y6VOC1GrQUulZtxQlRPduecpxMb6LJeAacyaYg72Xn4yLNan5n310LEW1XWBEwrG8QBeetKhMgvU1MyIt/+q+RTC3ieMIW4r7Q3ty+ShSeIetQ8K869+fCG6LNfYhVZZ52dMHUnd1gv/w8K5+TLaKw2ckP3tkFVOBV7fxCEZn/Y0n4ng6/IT7HWQdOFFjIxbdbpGyS1rr/03FVzhwVfaz42s1uJQo5EgHg90qBsESJjJtYKr0dWeyn29BrTmktokC8mzjKnG1VNFIvVM7LAUn5DgW7Mq8q2YV6K7BuGL7Y6pV/tS5wctyzAWPfLaZTeDww0wqX4ustw7nUc8TM0uSSZKFgXqOSa7l5vm2pDuB5MWhIOtS629rn8B1C3+ybGse+KBV5yYUwfNEreovQ4YgmXYlIaHJHeR+ArvS8jEnfLAldD+zO0dsKTOjzR7u3CuOAOMSC4Un2gau8u7o+aV/y+DUrkKjBObhICRkw+WpghLggwtV9vXIYIEIG6vYXbUfLNHMvVPBL1P6SEXxJuG0EV01jA/BDd1i20EnG1pJh2wL+izJU8VzZ77PX27awUhsoKj9LBXZLHdVFAhMBImeZ4Qxb97TnC2Em4YGjAXgsIvQ4VCx9ZJZSiulf6QJurkDm/GRsUUn0uosxG3MIQTnTAbjAdqJp657bR5A582YkuDR5qgzZwisEDlQBgO
 mn7RMlSp
 Syv1q2rae3upCgq/ufg5KnSrwU/CaKnBJabva5oltfEdKr1FKuhGiXR91wIyXXMZThpd3E1M5zHQ+K1JPji6ErGl+MaQmIb5OmMwrp4maIhNj8WToVLfYkmAJu5E00KtlkHq69L1dK/nesXA9wjgEFtqeJTPuUD4m4CumDSimaucrH7+QSd/bUbOIgwJC7k0evlpKhvEwgncLkIzDN1PYdqCdHHS8go1mmGFP9IT3OhWoOlg4NBmSF5zXNJqwGy9g5vjp5AzVVP7zQsGZHYTVmwuX8jdkcv3RcZgtRcFC6yoqYYWHMNHW2bl1XBQG8nc3UzEhj5OKoBGN/BxINU/neRs0wZkHHu2hQBeRaPuiBgjhCRroVzV279CIQicraGR9G2TDEMO8Ya4RNMC9KlYeJunjscc4Nc3+lhk1aP0Yyi4pNNH9SgKXStQpzC+yetXoHwPbYSYOJUWJzplxazdNzGG6TQCLMH1J9ovxvG9OeRurBN/rEhmPsIzAGZEXmMrc5lkmloxMfwpJz0DMXCzz2nEUlbsqf5OsMr14BF1LP/BiA1oaxGYUUilPeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 00:28, Nico Pache wrote:
> 
> 
> On 11/23/26 9:33 AM, David Hildenbrand (Arm) wrote:
>>
>> [...]
>>
>>
>>
>> I do wonder if we wan to make this an inline function to not require a function
>> call just to check this.
>>
>> Thoughts?
> 
> we would have to also expose ksm_scan_thread; tbh im not sure what the 
> impact of that is.

I wouldn't worry about the impact. Maybe put it in mm_inline.h such that it's
limited to core-mm.

-- 
Cheers,

David

