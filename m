Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F02C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABF166B00A0; Mon,  7 Sep 2026 10:29:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6FE26B00A1; Mon,  7 Sep 2026 10:29:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987E66B00A2; Mon,  7 Sep 2026 10:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76AC06B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:29:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A07D1C046D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:29:49 +0000 (UTC)
X-FDA: 85187200098.10.ED20F0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 396F91C0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:29:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mU+l3JyX;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788791387;
	b=NP0V+epx+5yv0SXuXQO4EeYdY1hpMSTNxHHk2HjIIi4gUh5eF05NUSOKJMdrFdb4UozoRI
	MEnvyvnyKIHvpPAEFo7CCCSFJW2d/pmDqyfptkn7Ow8NQLzZyc3X9VA05nUmtAmeFd8skG
	aK/sD6tLL+j/ldTivCcYnzf5QnJ5y7U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788791387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAii27z2R3WgSqMKA8Gvau234+ZHaRSBQodcRzcwYBw=;
	b=sZ6SfgeQgNsqk4GVT+swp0Tlh4/96LBVJiZ1kmh2Lr6TH2XS2Dv8dr5Y8kaE2nIZT8pD5X
	WnSw5H3L46KTMfbzqmE8zclfb2F82Si9w31OSqNVEPqgbHLebrBrHFhsroIf2gci3Gnks/
	r0rhkbyw4pLI6s5yHUIDun0dhEbjnQA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mU+l3JyX;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6067140AC3;
	Mon,  7 Sep 2026 14:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53081F00A3A;
	Mon,  7 Sep 2026 14:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788791386;
	bh=KAii27z2R3WgSqMKA8Gvau234+ZHaRSBQodcRzcwYBw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mU+l3JyXv1lFF417mpUDg2GKxM4fbh9tRwzkGb6iqcgwGparR9k/Xj+qfJiSrIwm0
	 OS8z1dLT62S8dUiFioRY6kaDWcxbqnR7gBA1w1ivIF90AeKnimZqD62rHchQEVDUS2
	 cyNaheobD4eI0Wl/86XcysCssx5BfLCQL4kcX7keiqpdtP5Y0E26VQV8ciJVe5DuzO
	 7sHid4cCgC16vkAqraTkVgnDOm2tEA774R+usebV1MYWqKS8aLfRHu7/cRPifxwpDB
	 xgF+pWW7J6hSVGAWOq+hVzGvGLjUvi3GvplUZsf/rpA2ovFPF1CrwAilNxpe8SKpgs
	 DF6KeggghiakA==
Message-ID: <69100a2e-ffd0-4094-9999-910558807e4e@kernel.org>
Date: Mon, 7 Sep 2026 16:29:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove PageWriteback
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260905-remove-pagewriteback-v1-1-06f41c00db03@columbia.edu>
 <ap7FKO_9BdNymgsn@gremlin>
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
In-Reply-To: <ap7FKO_9BdNymgsn@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 396F91C0002
X-Stat-Signature: ff9chrdy9ipbqo9ntruhogjbajqdpthb
X-HE-Tag: 1788791387-957936
X-HE-Meta: U2FsdGVkX1+CZNII0ymer21hp4308svaWksdsZYAdXqy7GWE7QVhoC0NgepFn3Ct2TMwZNIZI6ZJ1qTUSpch6sUefz0QvkRz0/1fS8DWg50j66efmd0OaAfFqAIkH3XQcmI8USQOZ62r0kZboWX14D+JDFE8+Xz4cJjMeYg2rHXdRs712iHDUPRmKQbai2fX35w7S2EgpBRAFTkSuPTtULMuAonIRu6QCLt/9IVe2KtncYYReyZ6vIl0tQSvRjv0+onyAmdQxokt6AgtxQnT7H73k26a+G8vUV8cRwJhgelSTH2p6sw9FRSZp3ujjKflBidX2XCpAMnSfe4ZccvGBhAO/UIp1D0QUryz2XLvDSDNI+Fri9hc9l0t7mVbtgFAAAgXNaQRpavR54JjjJ7R988QFjgyxIWZ8D02rPBmVc+ldY9fFezHPgAfSzYrthcNZoGN4kL3Mn6feQ7KH83sm6zmuzkNc5ID7D2obfEAOBRgw1VfDjFLlvOXGWJ5llOCtSgyP8BdNr2wg3DtEY3aYsQBd9iCfWR6bHs8FdcTOJS5JHOekvamrCbjF/1n0WGcZkI4Vc6wQye2uyaAmINTP8QupoURtBbwAXMlvJHR10eVIwE0ovTXDsb/ON8kgMPPtRRqmoBIpayY/R1RqExjLknxlK5kGQ/uo/kW86hCJSr6WM/aZNJqAoPLZ1qf06jYRbrveJm7bxHOvawB/EgR194UAPc6zsQh7P7shKxTZzuPdpVuSQXaCAwqy60tcK5andKQBG+FKtdagJko/X5zWZrLW6KgxNaY5rolh4LJKMKdgRE15zCVWXgGd8ttsnJ+uhpxzOhtXlQ4zv1p6NDhBL3bnu4qDS2JglM1yghPcfimZYN1PB9QMVp2hdlmGRul8zI+pXgV1YXPM77gHVyLUBKzhWEjyUHUfD9O7uM0Wc1Iq/LQ9a3+c4gpwWL04DZMY/C/W5mQN+dXgFK2e6f
 y8Zie8ue
 upaJzhF+8Ib0pyTzjsocp9VggxKB7Eg49El66AzmeAAOADMtGlcUhpFUwy5KVAPiAPMY/YVodEG6vI1KOcStQs2+Nw88YC4ZKTFfUD9Q1u2GZSG2rB+OXgtCbadGSyMRS5i5MQaAcK/HSyJbM6EwEv0Haq3tw1iI+qUfk9zUx5pCJSEgnNOePSbFNvSsvIXLR5IOLNZJ/i5264WwX080b/coVKgRr7eq+XbFrv0IRMWnUd4U1wwMOAJ//yx9GVKlNCCToaaNFHKhBZf+TGzZ/ezkDFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 16:08, Lorenzo Stoakes (ARM) wrote:
> On Sat, Sep 05, 2026 at 03:08:30PM -0400, Tal Zussman wrote:
>> The last caller of PageWriteback() was removed in commit f75987e543c2
>> ("libceph: remove pinning assertion in ceph_msg_data_iter_next()").
>> This flag is now only used on folios, so we can remove all the page
>> accessors. folio_test_clear_writeback() is not used, so don't add
>> FOLIO_TEST_CLEAR_FLAG() for it.
>>
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> 
> Nice! LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Indeed!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

