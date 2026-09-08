Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69766C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 348F26B009E; Tue,  8 Sep 2026 12:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320776B00A1; Tue,  8 Sep 2026 12:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211866B00A5; Tue,  8 Sep 2026 12:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D38536B009E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:13:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60BDCA4DB4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:13:53 +0000 (UTC)
X-FDA: 85191091146.21.FD90AB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7C3344000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:13:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QZQ0bmB/";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788884031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOS0VQ3pxNli+fnzbQ+4GcgPT7gVlj6GtERNyCqVDto=;
	b=j+z591pqsjlMqyEmG7giKuZowdAGwLEc28pQN/250v25dPCy2YqgVZclmx+7XBndG6Xgnc
	28gdoUdmc1IEuy9dgv5OxJOp0+R4CXF5v05+n0YqGGLOtetqGEPRiPHc11cAUyz9EigbjE
	tUniOLvaaM8XLKeIV9WXsBgpG3r8DPk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788884031;
	b=R+1YkyLrpbPtx7P7hm+vnrDMstfeFFPkmsk6IX2HyueVueeZOqE5iN7hrpXy+P5b/xcdvY
	91JQCFG1uwOtsoXfZ1QJUl/87D176uOrxT5y4uVMd9yBbPKqoyzEjjvUA6Z+Jje/c+BY8k
	kSVGaFshrzuV0uUH0EiQe14BW3cKoQU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QZQ0bmB/";
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FA5743AF2;
	Tue,  8 Sep 2026 16:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5817D1F00A3A;
	Tue,  8 Sep 2026 16:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788884030;
	bh=tOS0VQ3pxNli+fnzbQ+4GcgPT7gVlj6GtERNyCqVDto=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QZQ0bmB/xT1mMR2EivpC8SAALYplDz/p6XJ0LwSWEjUfwX5385zpmTa2JuhsIXPUz
	 YBo5HdXD6sRD/GHk3xVJ1OQ/eE/sNDGIVV8sio1XqhsRZsX480hZzYkuJOQVuocYGI
	 uLBbckItcXqaxCFSwIWMkFwhlz6IsIrVSvCQrrcqv76HGZTUW6BnqRnGFYhU59fOsR
	 9+rUnPQ0nQHjFIcBv8E9aRovC8q+V57ExoA9EwmSpcdtj2Di9ZDREn5tjZVYkkgnED
	 Z3yu3BRW65/MCTVMPWLWLlj8Tg5zXSc8IxoD/XhjBruToNa2OlwWOY/ySqhe6mHulf
	 rD8JuF/Z6xQbg==
Message-ID: <5b02f5de-00b6-4f8e-9e30-6d0acedafaf4@kernel.org>
Date: Tue, 8 Sep 2026 18:13:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/14] erofs: use folio_attach/detach_private() instead
 of direct assignment
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>,
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-8-6ae22f9d9272@nvidia.com>
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
In-Reply-To: <20260907-remove-pg_private-v3-8-6ae22f9d9272@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8duir44ihx7kx8dnyqog93kbpp6w6dd8
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C3344000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1788884031-39667
X-HE-Meta: U2FsdGVkX1/4WN2iwWb+FVk5v0wNRjYZiTxb6DsO2yrqoA4DSH2HekVAjHAxHm8zuwo0Vy9ZeLUARZYBCYazN3/Eim81VfFe1mxdySFe8A6G2VwJIMwau1Js12kUxj9exjNfPV2obnTln8AdQMKYnRw6DXSkk6TIhwlaHvEPjOZLobvoP7cPoeuN3L4KD6vY/8uSIShWHyyXSH6lhjCODsHOwlnQ5aM4jU+ZUFrKT+F31QSQQPw4rTr+D4BBIARuuFhQJ4stjvl4C6eXPbHAAnWGC/BJXfuaIJJTh03DHKf9sIkqTpRsdqMWflHuz1+FCIMupk7fsvgEdDKEOGQ7vMjXPk0t33qQY+etkH5ksDzoMKIOBbsW/qOiaghoZ14MaWZnbiq/i2xttSLv0innW8PX6AkBmFZ+ROiEc3He7kkH2s3OpQ0C8JVukfh3ELebWyqDr/EfDh3YDxqiuoe3T/fNvADJHmKszFmmYXHVm0s/Pd7G588y2h1Ghx67XqrWaW9u8585By7FUddtNHoXgQTgnIZ+eENlGfWpusUUKjZNNjFJsoiwWaLO8ZAkWTSLb1dbbSzjC01BDu1g/A14Vof2MwUINzqsUGs8v6nC24/y4kNRYuND0kFdCg1ncb8q0mrdemLwuZs76O8J0JVCDa3g9jsKdLZQnzuk5mDpGKlxP5ruBCg3iEVgW9+DBQFBbWG8CXk7+KvrBrT57Jm09qDZ7oKqMd6wmjSn5OkshhjF7cfc6H6YdmpDXyfiyygwRM9KQgi8rqmDkDn2p2q0UJ8HomZ45uI2Z1/Otz+TcVLz+xxfidnFSv4XMcV80bUdCg0Zl1i3dGNE8Bc+bbaJcyrztji3Rxpk6qtrDnzblYHFJAbCPVH+zB+nxehtlo6XrE5jZICN4is+Y0IwPYNzzgdR9Rxw+oZhiUaO6qUTeHocoMsT4KG5WybILV0dnq1ri/oaxJ/60gmFxkXH3T7
 /lIQb7I3
 vJqTgovzmelc6PoYQ6xViVng8D8TytPUgG+lmCVFfIcbsw4qHwMqty4F3jU8mDGtRkSr++OJ8SrqkXxV3B4NUDeLa6uMp5h9sL+MKXUAcSM3CfoE02nSHobO5zXdPrJYJr9vuF6BZMBrdHtsu7h59Uo8S4Ys60YtVTOrWsNiOyLTlKTYU/juUSaCfFzgGmdKOJ33praG/7iwDIjlN+jhDLJ8iX0eFNio5HCLrV3kfeD9ZlqC0O3fcSIt026Z88fMwVt2z+xmdyLB6twH9udf17VABRAPaeUXcyuOLV1YETduWjrMLpjPTzwdCpNzQTtnLJBpgYQlZBfWK+/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 04:56, Zi Yan wrote:
> erofs_onlinefolio_init/split/end() use folio->private without setting
> PG_private or increasing folio refcount and it works. But after PG_private
> is replaced by checking folio->private in a future commit, it can break
> folio_expected_ref_count(), since the folio has private data without
> elevated refcount. Change them to use folio_attach/detach_private().

Freezing the folio will properly work I assume, as we'd always freeze with that
refcount in mind or remove the reference (detach private) early?

I'm thinking of folio_ref_freeze() in __folio_freeze_and_split_unmapped().

Or is the ref only very short-lived either way such that we don't care?



-- 
Cheers,

David

