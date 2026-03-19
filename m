Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4DD31091927
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 21:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 282646B008A; Thu, 19 Mar 2026 17:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2587C6B0095; Thu, 19 Mar 2026 17:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E646B009F; Thu, 19 Mar 2026 17:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 055E56B008A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:42:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70F9C1B88A6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:42:01 +0000 (UTC)
X-FDA: 84564135642.02.67E8B57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 882911C0004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:41:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QyjmBxva;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773956519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYcw0CkvaHjWaOKqnM+5uGxe0+owDhwpHIYVNbC6gJg=;
	b=TLQX4fd/zrURyQCFXxMLah7PGbhmmbNQwVQ1XyfiUUOlFBVVSR7gF8Ugb2MlZr52b0FUWC
	Emp7jU6p3hPXlBDPQRWcw2Z5mU87NYnhl/npLejIrKXzyAYcQ+pc6/j/31MWQPRcEM8Hbw
	XN/jhRO1mw22rbExna0OXieAPhCPEro=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773956519; a=rsa-sha256;
	cv=none;
	b=SzkiErE+SagOlJGzHeHLCrdn2wjmQVqM5UFX6w3DhtJEuY6bod7YdRMxHjreIBZvi5b436
	jMzxeWeAsR7vg9SSuTYcN1sCZRexWhB9nGiwEE1b1aFx+NqY6M1dtLdmKeFRpnf8z9g9io
	Y02VP8BWG7GsV4jsgZcVrUawDK9Y01w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QyjmBxva;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DE5FC60131;
	Thu, 19 Mar 2026 21:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE763C19424;
	Thu, 19 Mar 2026 21:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773956518;
	bh=x/8th3CGRYkACxozKqbZL8YTPI2BozD9MWAKK7Ww1Vk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QyjmBxvav6K2ntcZVTw8FfOJP2Vk429cCp7E1vRKeSgfWlAuUarqHR/sEr+Dc6GEl
	 bK/pV++cQDOAFrXnUBR+UUIfbnfeCws1dRAOJ+ky5cStoIuGYbCq6hIIPuc8SRFun9
	 LJXvz5BJmuTZRSyuTvGofksSKaL+ujlfaMXpwR4MiZh5myqgV1lga4h3Dc0oTjd+sP
	 dnJUa42GJK1XM1aoBxYmAZVigwwtnjB4mXuWLtVUjxY281SzLnexVILDb3rW3PSICr
	 VX8vm+ttrZVpQZWAbMwprzmwoMOaRUoBlGlsAdsOrbAynGojwuWHhE3OOoBvbtBSVn
	 tOz3LjIsR0t/A==
Message-ID: <69382383-5f08-408f-8c13-d674e82c4dfd@kernel.org>
Date: Thu, 19 Mar 2026 22:41:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm/mprotect: un-inline folio_pte_batch_flags()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-4-pfalcato@suse.de>
 <2da1181c-165d-49cd-94cb-5ccbd3bb93b3@lucifer.local>
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
In-Reply-To: <2da1181c-165d-49cd-94cb-5ccbd3bb93b3@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: r4r1toy1zz8z4ffcre6of3t66xcicbfh
X-Rspamd-Queue-Id: 882911C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773956519-608157
X-HE-Meta: U2FsdGVkX18CPX6Ik8QHLEBwb9N4NOK6KgKvcbUyF9iRVzt00PTbLDfeK3m0RR/1GuLbXk19f3h9tICGJtKUUmouSJu4SRp8gKtLde7hC0aNx3IdlQh9TpPpLUudfUaLK7/IIc+bMbNPx2UP8JEco4rUyUY9fCfXM1q+wOFLQC+0/ZpzD8mTm1Wo41n8ifqrLrW+XlX1v3CHeIMRF/7d4mFIR3wU6t7otyBH6zwVKGJNJNkannYQNcC/ysh9UGRFNSjt8VARXoqWE2B81EGCkAuReRMknK5M3NKbnSvjb+82qlkpoqlFvFj7WK9xKxmQmhhVO8c4AXg/ll6PsdS/4sZaZncX1P6VRjJxViUIyPLjA+8GqoOk+58EAhSg+7LRCTjc2LeOmLQRGULae/1lKl0cMKVLJXrbu1F6NRCpKr6u9vg/F8OJtbLj3dsq2ih47aaX7Xk6HcHHGBQNDU0IA5mf3JOnWvOk/avXYhFpvro2eHG4Smq/UlQ9KuINUPHNILlcxt6xYaj1ha061XuB1uzJDob2wki+BCAS0NTLoRZidr6MCq/ThRJZ1e8xET1QCHyyIGWAifZciFHFwssywiAxNF3V4lybTsA0bdFZqbTfvT3smM6Jx9jCKGXMJyn66kjzAJVjZz8Go/dGxgPr8VAWftuGQOhgAwDsl+y3awwFyvl/jnFYtjcueC9RXPaYoOd6na8w3F0Mfi90pTxSerTh18f4aCPZar+29kIsDPRy4DCNVXyU5W6NH2CM/vDlLvEz0yRW5UIbRtCUn71BxhaHhupgrFwP+pJiTkIQ/pHVkDbW0IONleRJWg6OHBpmlpkr4EK5dKS8ry2+dcQGeL8UTHBnmN/sLxV9xESRGfYQwhINIqjbaXHdgjojXVkLIymbjSRnXSLbl4FLVm/yLe7G6b1GUrbRhbgjW01P6Tz0vmmI5SHj6YSUxr7sNTeUPyjfMBZFsljUngjkJZw
 0k+YF1r4
 KF85bXLcRGNWfmHgLQo6QHEcH6CaMZA+L/7rwUwC1la2kgH5d4W95usfBY3cTdd879nBUocEY2PdnezaXvOzm6lGJAQRrrVESa3lrg1TRtFaIBuldrEcspj2gmaRIavcylXHT/boO9yCRnWCvXccFJxVwasGe0OPH5Sj3VkH+haJEU6EkLI/PAW74kV4gmDHB3YgT/qV2/KwH1AyrgKdLwY5zc9Kdn3YlJq5MxE1fj1X96en702us/y1P8Yxr/7LETkn5d293+7amjgtXCfH7KFBFsg7qhl2kdLb4O8reJnayUXkg1NgIlcaEWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> This is all seems VERY delicate, and subject to somebody else coming along and
> breaking it/causing some of these noinline/__always_inline invocations to make
> things far worse.
> 
> I also reserve the right to seriously rework this pile of crap software.
> 
> I'd rather we try to find less fragile ways to optimise!
> 
> Maybe there's some steps that are bigger wins than others?

What we can do is, collect similar folio_pte_batch_*() variants and
centralize them in mm/utils.c.

For

	nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte,
					   max_nr_ptes, /* flags = */ 0)

We might just be able to use folio_pte_batch()?

For the other variant (soft-dirt+write) we'd have to create a helper like

	folio_pte_batch_sd_w() [better name suggestion welcome]

That will reduce the code footprint overall I guess.

-- 
Cheers,

David

