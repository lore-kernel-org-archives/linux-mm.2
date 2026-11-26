Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B567606A326
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 06:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GD1QMk7A
Received: by kanga.kvack.org (Postfix)
	id 38DF36B05B4; Thu, 26 Nov 2026 01:43:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C8956B05B5; Thu, 26 Nov 2026 01:43:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E696B05B6; Thu, 26 Nov 2026 01:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7C176B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 01:43:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 596B31C2139
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:43:56 +0000 (UTC)
X-FDA: 85476330072.07.2939A5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 89DCB1C0008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:43:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GD1QMk7A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795675434;
	b=VuLDfI1gTpR5exPiGE1cBVcvgV2HIOhHpFnr3088tYxGHQ2K9Kk3rnGn2lxS9YwZCy8YRL
	UqTVoObOAoBsGwdogxtcURvmBTWZj7eXYrYYzFgh9X1T/RSwOflzdOiJ95edNzknjm5Cb1
	nkvesuQQbPlvRhD8U3AHrzh/N2uBQfU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795675434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55bsZS3cIcuqHnwPLGxOy5fV6OTtTanCWxejpNB1N5o=;
	b=jLNZN6jtPUwkKhGOCCWOpwxoHdrXLMhFJaW7C9jQNtUNFVY3VpbsJ2Z2PUgx4S4GzckV/U
	C+f94nAgGo9c4pnRnnBgIRki+Ig8ejZ0qDshnJqwDq18brtdqw6NYIXhurbJpgME+KK5FV
	bR2+RhRKaaOiFphp3of3mBoLX/nv0rk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GD1QMk7A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C12D3436CF;
	Thu, 26 Nov 2026 06:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DAC1F000D3;
	Thu, 26 Nov 2026 06:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795675433;
	bh=55bsZS3cIcuqHnwPLGxOy5fV6OTtTanCWxejpNB1N5o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GD1QMk7Au9pSYonyrPsyVvey0M8BSM0iTtPrsO//M/VX1/OjXiciHroKhOomhOJ5s
	 /UlalHde1P24QisHMoYnpDJrr8jxLrq3/LsMSUOrfllrHImGICiAx1UClXktaHUspO
	 BxGaeuWMe/I5qok8Ounbng0qPlAGSF2ZN7Mazv9T7DMxtApLT3Vz85TDO4pyzIOUmZ
	 sjFODvsvQQb3oqjJvgpqlTVnRyYLPfONZFB72kcyV5/cO2rFzuXNN1nrL4fDwxdKck
	 U1ttURtmZkqEPqA9AhqMsmq6IRtblyAI26UqxIveuzik9YXCTnum8ezaeZaxQzM7ey
	 kfntytOKYUsUw==
Message-ID: <50045fa1-0b46-402f-baf0-a08d05282410@kernel.org>
Date: Thu, 26 Nov 2026 07:43:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
To: Tal Zussman <tz2294@columbia.edu>, Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
 Pedro Falcato <pfalcato@suse.de>, John Hubbard <jhubbard@nvidia.com>,
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
 Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org,
 linux-nfs@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com>
 <awWNyDZT2SVu2Zp9@pedro-suse.tail5790ac.ts.net>
 <55114986-0ba1-4a80-8498-bf674d64e01b@kernel.org>
 <away88BuU8ibcTA5@infradead.org>
 <d088452f-1118-4a06-bc16-1942e523e0fc@kernel.org>
 <20261126022418.3620783-1-tz2294@columbia.edu>
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
In-Reply-To: <20261126022418.3620783-1-tz2294@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j89emzcqhzosd8nj3paouuuznioqxkb9
X-Rspamd-Queue-Id: 89DCB1C0008
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795675434-754046
X-HE-Meta: U2FsdGVkX185LYdBEw+zNFMi2Pv1zCGjZi01dnJZ/BXrkZHa9eeCkXWUhVV7a2KFiMnt7bPxnPovvMgBZCQDG4Feo4ERB9t3/7UCYtFxE73+QfINv4OV0FnU+Y+6HZ5ggGqSjmqj+eSYDLEnpkJh5Wb0jAYTPXJDCpXKEKbSCMFoM3+wudPLaPkZv3OavBuldoia6uXjOqW92NOkEVyNdmcdCaA1QTnEOrfC0cXyWlc4VXeOYxsuI5tKBWEfg5zV1sjxLjvfrgnMQP92OByKffozT+UNGEpkpVcPeCm6ewXtEgDUcsncAx9m6R4kEFr4xv7CU/lC5gyCJ7iq/DOo1uiPY+Nqc2ciNbZqVmV4mlPZOlA1XA3t1DBxPwHEA0hk9FI5w35u4n+CVcNx3BXOv9aGN8F6y036Lb/kwGpwue+4TIDvia319dQC/CJkkN6qmM5AJSwIhbH0Ml52UY+3P7PhotnbZMbex3XoFecEPC4FvnKETk7g2y+3CmjyyMJQbEjymoffKnB+Q9Wa85COJP8NkovgYCMaf6kVIdfAmaWetiF4gBG8cpfUGJ3ng8MeBxqG+UCefFuW2jM2YOLAD3zdHJIyi0uoRbvEJYOLV+Ca25I/PGqNh18MScJp2u8vRmMLrF48+GjUX+VKI67gSZ3D0dUvE5B8zwq9zrp2kFlXlgcQ+KrB47jxYxdx7OA1v1HcxmDKhxoo8Dl8hBEvRbRwBowglFyKcbh2l0JaL9PZI8guuJYtc7sxJlbQvyrRbGA7JCj3aZfxdm26vJnusP7pVnOcApi8Oj1HQ44kPugXlholGEIwULLRkPqPXlXCZpDhK+0qA0rd3KHRXvHT/orydbZpMJZz/d9Z2UVKIkzYLKh866cRiU7LeTVWwmUDH8+qjc5Qer8GQ4ZVCdcQo6ik6WR7Yta89zUaCUE7uLq6TG4W2RKYPcwFHcivqpg4nYaXy4wuRlvurwaRhRo
 oN8WUjWi
 n+EKy8UEvKP2XLswQDyohxE9Bgall0NmwkwuXdNSF4lDS7dX3lf8Wt97V/qySGEe+EQ4re3aMETreUfJRiO4UyQDE99g/dN1kP3PpdyfgfaHLeeKeOFaf8SjIc+Z7UIjFZvjJBXjASRlM0QiT8m7vKF1ykHcfw5Id5mNBGKA7SO0FpxJZ4++XJltwDpIKhlWrVZ3tKgXvpku+haU3/yYsbz+3LNgBuv/IsAZzR2ceKOcv37+bUgvKdQUsmcax9ReVEJmzlWnHlAmDpRfrQUfK00B1wVUGs8rsU78or0Z8e9BctTDD1+B9hJ99ZWj9yyffW4TDHKRfxxrf694tFhf8JA+Jcmhc3VH3Y7ZUYzyU80qPEdAhxczb3ZQds21gdiCAWJPw8trnNAh+sI5N6b3k9oBkyCUWewq8UL3EeQQ6CYZwxgM8rrbHugs5YPDwL2AdSNmOPW3qjOGfx9dFnIZX4PhzNaPrhLEDJ0EECKg15GUCykmhkz31w/AUwBiUMB9ve2QQS+rasTdvSTbfBVndi9Mf0dq+7dDIALHgckmzMuVEZf27Odb4UYg6sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 03:24, Tal Zussman wrote:
> +CC Miklos
> 
> On 11/25/26 5:19 AM, David Hildenbrand (Arm) wrote:
>> On 11/25/26 11:05, Christoph Hellwig wrote:
>>>
>>> We need to, if not for this series then for all the other outstanding
>>> issues with GUP writes.
>>
>> Cool, and I agree (that's why I placed it at 1).
>>
>> But who is "we"? Because I recall that "we" wanted to do that a while ago.
>>
>> (I won't be "we" ;) Pedro, can you take a look? I'm afraid the fuse thing might
>> be the harder nut to crack)
> 
> Coincidentally, I sent out a patch to convert fuse_copy_fill() to use
> iov_iter_extract_pages() a few days ago in order to remove its usage of
> set_page_dirty_lock() and address a different race. I think it should
> address the fuse side of this issue as well.
> 
> https://lore.kernel.org/all/20261120-fuse-copy-fill-pin-v1-1-72a0d888f140@columbia.edu/

Oh, nice! I was assuming the usual "we use put_page() on some random hidden path
or core code" would make that harder. I recall that's the reason why vmsplice
still uses FOLL_GET years after we discussed that it should be using
FOLL_PIN|FOLL_LONGTERM.

-- 
Cheers,

David

