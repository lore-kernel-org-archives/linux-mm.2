Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4974FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 07:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217766B0005; Mon, 27 Apr 2026 03:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8B66B0088; Mon, 27 Apr 2026 03:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B71A6B008A; Mon, 27 Apr 2026 03:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF5746B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:42:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B6B48120759
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:42:48 +0000 (UTC)
X-FDA: 84703544016.01.DC67F62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D766A140009
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:42:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uN/bcJ3g";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777275767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F/eHfjILfBl9CSKq7sw/xyYdIy6mAKueuiogCscaqtI=;
	b=RROrSanTZgJkUwLOM5gJqm8iQ835RJrJ9cBcQ7G5gQ1Kn8L56NJgS37BzwCl/eIbmu59Kv
	gBYxFk1OnVQtmPL3xu5nAoEieK5d/T26bO3c4reU02WcmaMHLn58od21scNlNOpN7ZFasx
	17jBBtenrv355RR4nzoGbBt+QgSjU80=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777275767; a=rsa-sha256;
	cv=none;
	b=T9Ku6dEXq/oQg8KGwUFR1aECzBCsShWVLsNYZswpsFboKoOCNM2JJGqEEcmL0VVamP+OEF
	/stDNZV63Bem1PVGAm2W8uCRc/oSwLhwf1Fl+ziWmrtWl9UHVg6nzz2uyxjXDl/IGWD+/R
	l4RQwOvJQ3ohplRnZ4ok9zK99TjRCD4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uN/bcJ3g";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CF9BD44228;
	Mon, 27 Apr 2026 07:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC795C19425;
	Mon, 27 Apr 2026 07:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777275765;
	bh=pwVruD/nhFaOXj9EygdHkp8FqO61Xe0FGyUdK8c3O3I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uN/bcJ3gLQvMC6TcceyXTnFzgDG+TbugoH1c2oa8RHYCxSbetHhhuJwsyDUu6IEGK
	 EfCpmntLkvU08WA8sWKWOCGrrx/kdOHwdCFqRmiB+dU55RcfhfaMskW5yP+kgnBJ5t
	 G/13+01PWX47ociUNVchIs55n67GwevToZUej8euCZI6KhAS1jxicWIy/BEvmvNlj9
	 oPmXQJqpRi3iZOQfWdporyRuy4TQcTg2w8TIIQRXmmUVRbOg4SIRNe1lk2JhfBsYFC
	 ycmM5PcTNpWT++az7A8q9//rmAEqa9dWWegMrQn7dyZxOIGHQMVbSeGbFLKQvY18JQ
	 dFFA/28tC4/VA==
Message-ID: <17a3bc38-0d97-4316-b2fb-02a91202c504@kernel.org>
Date: Mon, 27 Apr 2026 09:42:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: Fix outdated comment about freeing
 subpages in __folio_split
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Youngjun Park <youngjun.park@lge.com>
References: <20260423034917.8234-1-baohua@kernel.org>
 <ec08f25f-1049-4fbd-8a87-0df135a867be@kernel.org>
 <CAGsJ_4wn=o5ZCNPGguCCk=19iYZr1V9Jup0NdRUKXySsKfD_4g@mail.gmail.com>
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
In-Reply-To: <CAGsJ_4wn=o5ZCNPGguCCk=19iYZr1V9Jup0NdRUKXySsKfD_4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D766A140009
X-Stat-Signature: 6wwbeiujuoe58sh5ogj5tz565fax7435
X-Rspam-User: 
X-HE-Tag: 1777275766-726179
X-HE-Meta: U2FsdGVkX1+7F3B5gjmrRwAtSIDNpwFanqHv3bSiz8Ni5E38chPr9b6iETQd+4e6w4bcWtG+jIgLMjKSedrDCrIrq1Bt4d6cvjLn6zIBRv92jDo8X59p+N3sF2AFWZwrdx2UYGANNlsPiPtRDKaNwVuvZszDIxLAokMiDlJo89uW578NJgC9bUuLpwZVuFdj0zDlqShZTbjdYWc6MMwpQipTYryWnwYb351ljx3mlgcMc78zLpekaCMzp3IvSrTW1h+yzgMOU2gxJF5aaqM4FmPhEgVO2l5ljKJDAqkkMKkAOuuWG/elyyWmWvslA05IFnBt5sDgzBOtTEFdqDogYArnnqkhHtuZql0DB4mxuniZ4/G79TZ9pLz/Pu4ZnQwrOUTcJ14GaKyyit5MqPiS+kYruOtO0ee2xrp0kv2T4aslF6SWjcLJujCnMc/f/52GUjW5PTSAo9BwDrW7m/TXe6g6iyND9K+oxx9yvGfUJ6old3Bqmu/BY+7qxYPdJeVoChQZj0KQlOR9pef5Hl5dPkIaqo4JrOM4V8hLUZmV2Og+ov63gqNrtCy78OGodVhQe4GrGKPaGanrT63OBKBiSYSmgDgoYIRghXFESsnBO+1Oi42fR3ITl3fI3tgPz6Y/1NOsTQuSeoXxI0yfIwW4oGYV2T6kk7/jM/k/ru3TkwzZKSS0Zz4APt7tiNY+09TsYRgT3uQ/ykIVFPJTGaZHO3LCjck3LDoLlsV3j7H35WNJPTp2Jqk3+3oBH1/8MTwf2/2hsBICJnVncGyBSTOgFTxuJjiQo8jlXEefDjJhDhtOE1TAX9ytzr855+LqOp+TOy7+iyPrt1yIiRKNOmbP2UH7RhGDe51TMDg85SMw62VAU6X8tsHCgF9WWJ6D4oxVlZ4eoxo0EfKj5trMdvwLfmjPABx9Hip5Fj5Iaac2NJz8q1MjuDtEq8w3p6s0Zl0TXWUTTvhsWac+PkjVqqC
 xyz3SwFv
 B2mHMOp5V/DP2kYspC3meSQzuGqqfquVEgOFroyMsivKzUfDix+7REuydnxJbBWSkQyidZ7SpguIlGUgifUDCLkrzbK8C/hogFNSpvJit+QlQQrGo2/xskZjxTMGrjh+fa0cwehVA0NuzPBUFq5ou8NOSXuTM1hbgUPomrnj3GIaiiYfBHpXc+AP39t0SpWCdoiGzzEeNf09V5hOAw7Ae/O3Cg6qNLUsWQhk4dvP/wJdDU+FOz2YkXO9zrxB3HXecE94A13Cu1j+k9vYJXZ81vgFtS54wxg3zX6HSV48bjxVynLYtmhLSJhW1vqyEWgmxbLbpIG/bgau4aC4Rf2uYu7OVLB0JKBZfKeJPH5LYJXV76ZF16766PV8qRP0jz3kvf+tv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/26/26 22:42, Barry Song wrote:
> On Thu, Apr 23, 2026 at 8:36 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 4/23/26 05:49, Barry Song (Xiaomi) wrote:
>>> The comment appears to be outdated. First, add_to_swap() no longer
>>> exists after Kairui’s commit b487a2da3575 ("mm, swap: simplify folio
>>> swap allocation"). Second, partially zapped folios are now always
>>> split before folio_alloc_swap() to avoid extra I/O, following Ryan’s
>>> commit 5ed890ce5147 ("mm: vmscan: avoid split during
>>> shrink_folio_list()").
>>
>> Not necessarily. We have some scenarios where we have partially-mapped folios
>> not detected as such as of today (with CONFIG_NO_PAGE_MAPCOUNT).
> 
> Thanks, david! would it make more sense to add “when
> CONFIG_PAGE_MAPCOUNT is enabled” at the end of the
> sentence? 

Better to phrase it in a way that doesn't even require these details :)

Do we even need this detail in the patch description?

-- 
Cheers,

David

