Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFDAACD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 12:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1016B008A; Tue, 12 May 2026 08:45:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 491AE6B008C; Tue, 12 May 2026 08:45:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380306B0092; Tue, 12 May 2026 08:45:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 25DB46B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:45:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7A9840448
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:45:04 +0000 (UTC)
X-FDA: 84758737728.25.1CF1823
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id ED647140010
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:45:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eSRfdyib;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778589903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0IpUefSLj52U2lFKbf7VLYEWpm5WbmDmH+noI1qi4ng=;
	b=TkavzCMN2vywAwUzAUHUZP1jZ7EXy4ql736DUgRhSV3KXzkDtbEfDZVqpJFpO33G+M2gSm
	pxU4ukyBbH9VpjF7Vfltp5HzhtBc2M+EySk03Ew7wlXXSU//pNO52Mus+QhtL1p45jZZ7J
	JcF2mOB7VujcX6+UrwxK0zPgivVAvQM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eSRfdyib;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778589903; a=rsa-sha256;
	cv=none;
	b=BAyCjpj/v7F+G+gXEEF09oUNLmL7XOFBxoekkLMgKJYBOb0oZJzu7s/pXy3+jg/2tPbYpd
	EqC0iDuSa86Y6KFgdz/vXUS67jPWWhBoIN67VzstPtxH4cpjX8nBR4mBzizZ7zdbo6Dwo2
	5c0qwnk9oAV0Y4bvlojlGmns4b5k3Ic=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C137C44039;
	Tue, 12 May 2026 12:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570BDC2BCF5;
	Tue, 12 May 2026 12:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778589901;
	bh=+Qd2oNkAu9nMaSnTOhJAuwCNAPyt8qx11rpclyzT4Hc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eSRfdyibJ/kA19bgGeFXkt7Hp+PjO1U7/9EhsV4yXk0mAxQ2e67O5wPw6v50Irmid
	 OXa7ZtKcqrzTbd7EUSK+QcIL9drUsmdlGmSsJKMzq4Lt/rPAcYCB3snlpHYBE2v3bs
	 OeCV04HrmrGp8zO6y7VGaN3UN2SG+DjNfgQduj6YdcAfr4O1lMOzmMS1/EtBTOsyV1
	 gkNsOf8ElxPJ565dpMOIar6tB6ScJPJ0+kkKgoPPimzi20UYtU3HMivheDEJ/6aL8x
	 oOrjX3nlWdSl79DnbgoeSEtC5kRHoEjvmSAMA3dVUZ5WE3yirOJqUkfThLn7yrIEWq
	 z95o+Ikba0KuQ==
Message-ID: <163cd3d1-dc25-4335-b527-99e0acc421d4@kernel.org>
Date: Tue, 12 May 2026 14:44:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/5] mm: Add helper to convert HMM pfn to migrate pfn
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260505184421.2324798-1-mpenttil@redhat.com>
 <20260505184421.2324798-3-mpenttil@redhat.com>
 <4a9c4170-c6b7-424c-969c-19240f07e46b@kernel.org>
 <7e3abb7c-c57d-419a-969a-fcd150ccca99@redhat.com>
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
In-Reply-To: <7e3abb7c-c57d-419a-969a-fcd150ccca99@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h1b5xcq9d7a8du9drgpu9dkw8yfkfawx
X-Rspamd-Queue-Id: ED647140010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778589902-583393
X-HE-Meta: U2FsdGVkX1/TZsu1gMFgHw8SHFrX3XgGHgnmlSqThfW+rNLqoPrOGKeH2enarMgNs+3a9MKPZZCCVt98Ndz505kmDyq1dYRGJXTaylEstLiC25ZcJ/yiURemzMIip5aJ7DOrek3OwgS4MTUSFGkBRGRWEVtYo5efMJ4ghoGZeHKM+81oapVVT+fpGRv5t7UJZxdGyLXBEl2Q4KOezthdG+axrnbAPwXT5g0GSD7qdaS0WP1OdpGI67+clsixNYH3aF0F+VjkTVAtNIWxbqKIjXV3AvezqrIqbJE697d6WWvZ7dgpi90TtXBj+DNwLQGFR0nbkTGgpafQR+y+WFda4mQdjRjvgO9XN9g7xf50ZBNd+1uP2zB9Pa0hUk7a2N+hTDCxRUqaqBs12+0JpllgjK91iyMjIdTT82kHrDm/gPy1h93WhMILfJoHJP0RM5u2c3DSqeS83u9TrW7B3sDzs9ndHJEf2k5PJ9ihXuMKEJgE0cCkdapDR71X2e7MU3n+DtiYwex2qPLL1/A96PopmJ2xJjGN6UFAausaCq4KEf6gHAWn5rt/7o0FArFe7zdCP8LTUd6UrmjHb5A724KuP2QoNKmzg0NB4SFv1847whfTCZAKLeeeQeFvgNSrUR5FRvwa/Kz2pAssPUkhV+P/aECj7weL5M/i5lMFvVS3PLsqxJ+WmODhyg2eEr2b23wMJLRjEYEHy0ZZMV36qwsWD0UKvUwKGLb3vbE9x4Uhv6IGuXxmllOHkwn4/u7S8qXhuDYmO6Ggj4iTz6JMrNKfA4XIMdiCfbcOGWXSdWNcckElSPPFs1kHL2eWkdG5REStvGJfPhlEsZc8txRfrkSOjJEAgcPANmVCYlBp32Zto/Ml1utUXvpJ+8iCWkCCYc3l1WSxXVkV6ackZh8Xo8fuWp0LiBFLNKSpsJDUpjTwKUVtQ3/J0GpINLPPSLH77fu3nfc+1uQCNAnxkRYaHyp
 FB/ztxj1
 6Eq3W88o/zudJKrRi4gobfuarzDHClFd3235XjvK58/XPXKcX363BMRZcC/hnRL8xncaSfSZ14wbdcjiSj1M8YU8WjE+qT3diebtBGqe4g9SyAP42b2mnRu28DovvvVCSeyUkdDgD96+AXzbLFG4QRsY0bascEhQoKdVPv1WFlhPO00gxNW3fbbrak6jBodqoEv1v+V9yJqFHd8NHtQGJCCqvoNQksUtbn/iuXaUDomYKKHOpakbBUK9y5RVO9RGM9bLH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>>> +
>>> +		migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
>>> +		migrate->src[i] |= (pfn & HMM_PFN_COMPOUND) ? MIGRATE_PFN_COMPOUND : 0;
>>> +		migrate->dst[i] = 0;
>>> +	}
>>> +
>>> +	if (migrate->cpages)
>>> +		migrate_vma_unmap(migrate);
>> Can you remind me why we do this here, in the setup() phase? The function doc
>> does not really describe that.
> 
> It is to be in par what migrate_vma_setup() does today after the "collect" phase.
> 

Ah, okay. How the whole machinery works is still a bit of a mystery for me :)

-- 
Cheers,

David

