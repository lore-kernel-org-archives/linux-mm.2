Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A1B2C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9846B008A; Tue,  8 Sep 2026 10:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46A176B008C; Tue,  8 Sep 2026 10:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359906B0092; Tue,  8 Sep 2026 10:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0EFFC6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:17:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 96BBF1206A7
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:17:37 +0000 (UTC)
X-FDA: 85190798154.03.06094CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id DD812120008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:17:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="myV7eNg/";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788877055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNSm9JyIdvqOJegC2cdB6kLuYGU1rFuia0SmDqpT6mw=;
	b=Lie1U7YrUDWcKUr0t2Mzo0HPEXlNAqRk1EUF27f38CHjDucbmZnTzX2Zn7R0hGCKfbYqAW
	CSHfVgJBkqplu3f1A1ZWChQIJJpUlswLgpDBfyYAU4W9nrxt9liYjnSmjjjmGDOWfk3eln
	r+mVITk/e4Hddl/45T/4T9SmVUKhr/s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="myV7eNg/";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788877055;
	b=wToau+i5gHUe41vOfDkEeHMiExoc/mIXQfbxkr4pilNSAwCOhJ8Ux4nvFTOVvwzJ0YQtjc
	g1G1hHyEyFJROpqIXX/BcpmxhczHl6qsZ+905PCzO2B4Z1YwakoL6ijLa3CTnGKlAqqJ72
	rxVdhL+WgTvftcXkiol6uXGNY1s7cb4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7157C601DE;
	Tue,  8 Sep 2026 14:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B171E1F00A3D;
	Tue,  8 Sep 2026 14:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788877055;
	bh=NNSm9JyIdvqOJegC2cdB6kLuYGU1rFuia0SmDqpT6mw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=myV7eNg/gv18ZLJYuBI9HmZI8F2KKiBaPLhVUz+ajLhMZhgl0dEcFdPpnMth6B83v
	 f7bKAmwnkn9B0NO+54KyVRbbRUSJT+mqymyMHBpmKK2jZU+aRP8M304KVS1gKBFzeh
	 EcYROI937QJtzjnVZHMtcKkuH/fgohPt/53e0Xjf4cYrDbIlpcnz3Ch3HzkCeAF2He
	 mjDTcEnwkIc79obTXOVQkYijQogcTpASWqBWw7RwTrb82kurV+UZ9BZelSzjnJ3ui9
	 WLgDmf/OjnP51LoWTRGGQQ3znASGd9+51tfmaf5s0IinPyNYr1r7oMLH+QeT7qEO5a
	 nrFkF6e9FdI4g==
Message-ID: <2335b64f-483b-4327-9598-94123c36902f@kernel.org>
Date: Tue, 8 Sep 2026 16:17:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
 <20260908-map-private-dev-zero-v2-3-acc7b5625305@kernel.org>
 <e743b598-9048-440f-9124-72071c696679@kernel.org> <aqAFBTyAqPTHlxkZ@gremlin>
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
In-Reply-To: <aqAFBTyAqPTHlxkZ@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DD812120008
X-Stat-Signature: ma36nj4ftx6meoc6ws43wc8knaqoypj1
X-Rspam-User: 
X-HE-Tag: 1788877055-372662
X-HE-Meta: U2FsdGVkX18XZIMUmS4Gq4DpWVvuYehXuzpnLIOZrirWboC8i193q+qQwZSCr0wEH/1Yw42XWmE8/HEoQudt/L7nVLHyiEwOaqZzJqTgEGVWuqnRszpra2t1awnmNnwl9idChlWwM6VxQQl38bc4fTmQ02rHaJ0Fo5RqMdrgrXnuNOl6/dXezB+4ltoH/XdZ83TbIVzSbUX7vmlshWqO+8xBSmsMJAWsawwdZR9r9TTwTSxLWLmPdy0hFrmf2fpQbUpf0i35Ycw1DZ3ncRniOVTu6t4d0Pfz8RHnFUlbDrXTV8znVUe3UP/GH4v8Yfk1bJUGm1jgiDrhbfEn+AJYfYX4XIC6EliKuuEBNElRQl+0SFc0ldOpEeSM/R7CYhCNEcPcJ/23qptzFEQ1egnaNcV4nsnJwognJZJlvtz5TzlLnN4Z9pk78nQjh5c25Xz3mtkI1/bpzKXYbPByReEv7EhtwTcdbPvYIslIiKInD2lqb3zBqsqKlhArV0y+Pw4mkrURzvUV/m69iuW1vIgkDAe/LPpvLi6CrNYftG0leWM+WZWJ5FHM+Dht4/sBLPg0xWYx9dUSxc5xAOiVFhyMXAgm1+sNhU9NtZOlQkECZDPRdCRo+vEMrGfjyx0Y0sZJfzciKMcQqTHU1lTVLKa7NWWpuf1XfOtNka5iekgCkqHN/SPT5bBlJsnrPHs4E8u0tPB8PfTE/N9ULXssM4voB7Csk+7Awew/WNiFzVkX5/R6YigeprgoxzIMZnzrbFf+9++eEuhQVCtoYKZP4E/B8eBePLJ/qe0bi1VyNSPpa/e2wVj1Hqrd+2qBNBhP9qIMehWMqsM0e5obS+6EkW+oa5CdpHW61/6bmpxc+g6ZJyK9pa9MAYkdw7TDdCJAbH2QhuwFFbLatHstuBRg8IWsJbl6up5kcZwIVFzOF55RBfBqnU/RSgnn52ePE6WyYuzn4Bb+Fs0WD04DnkMmNwv
 RiyQdFI2
 yKMtUyq4AiR09YEKkirxSaWJ4aCx+cGJuhoS/qM77eh95IkrUtJ9uac1wFbNI/EUvMAcKewMWX/Q28legu62ECPUL8E3UmsHOx28toIUZH2DX40GQRGq6DBEhv8sc09McoFTpLvxXOkCRHfEuRADbko+LvO6n1CWEFQ7dRuoPs6x5g2CimqPjgsKqOvu1B295zSzXkdhmLkSbOQLAbpcj8359EEng49hVVKraOwFbGPZeIIgOEZs+5M/i7Hbdhzz3Lv5Ab7JWHsD/T7s3UN04WCRa5z3cO5TWv1itRipqn91Y74XALY/HhXq8/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 14:52, Lorenzo Stoakes (ARM) wrote:
> On Tue, Sep 08, 2026 at 02:49:33PM +0200, David Hildenbrand (Arm) wrote:
>>
>>> +	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
>>> +	if (is_anon && map->file)
>>> +		vma_set_anonymous(vma);
>>> +
>>>  	if (error)
>>>  		goto free_iter_vma;
>>>
>>> @@ -2777,6 +2793,10 @@ static int call_mmap_prepare(struct mmap_state *map,
>>>  	if (err)
>>>  		return err;
>>>
>>> +	/* Hooks cannot mark themselves anonymous. */
>>
>> Wasn't this supposed to be reworked? :)
> 
> It is, you yourself pointed out 4/6 makes this irrelevant, so I changed it
> there :)

Ah, thought you'd adjust that right away. Works for me, thanks.

-- 
Cheers,

David

