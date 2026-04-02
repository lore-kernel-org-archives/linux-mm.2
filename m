Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4943CC6B1D
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04D406B0088; Thu,  2 Apr 2026 03:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F402A6B0089; Thu,  2 Apr 2026 03:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E926B008A; Thu,  2 Apr 2026 03:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CF8746B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:56:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 77B73593AB
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:56:28 +0000 (UTC)
X-FDA: 84612858456.30.A18CC03
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8A42C000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:56:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dDTeZLGe;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775116586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXkLjBlEHxc7QqWamKYsPiQA76M/zPbmVxeIaau3KHQ=;
	b=K1ixAgC4dFVbMgv8ckGi8d+q4CxfGqhqC5d2gSW/RR53JNAxZPgSehZr4WAK01bFtlbk7x
	fMT3aC0s5qwNsbe7MFa4Q3N2/faAvYrw27JKRiPM3M93ehX4fZnj7drnzdtkj5M3QmYlUJ
	Hb/PzP+bzz0nSNriMooSmhO0n+dNP/M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dDTeZLGe;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775116586; a=rsa-sha256;
	cv=none;
	b=5RM6F6E+LajwDJ8dDOGKOi29ypYeb9kmSM0BtX/h4claetclcfrc7O0koXenl7ATfTO1MG
	5hCXl6QOzzkV8Hwy+RQMNfIVCXuZZajUXvdCQ3uY1O7DpfgdNxmRNBdrmsYKlreZ8cqQGH
	FXly50/NhoZDf5I8y/Ii8Co86Jm40bs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 261FA6186F;
	Thu,  2 Apr 2026 07:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA8AC19423;
	Thu,  2 Apr 2026 07:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775116585;
	bh=lVU9GB5TisBjGeJ2erKFHIxR+nRd7ro74DQMBJO4z7s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dDTeZLGe4YVevDNuHBtTRXX+lNU3Rgs5R5/Vp6zvo3sCIyh1SQqdqDZ59xf0iu2VE
	 Nxb7uV5avzKfPudssph9cjwFDwJqS1+MY8dN7v2vvdhyDjm+NEkEmie76o6sfyscz7
	 JVExtl/BIviMKq/1DAAR08KceJl/nU2c6MqRCg3oPEim3jt7C9Pa3ABxiOOjffV7av
	 GQMV4KRsvf5dxEHZB+7OSEDG4qapdAmJaWyZ7IuIM4xqcA+x9ARVdzLh0r949By0ir
	 edGSntceyGAck1KCKAqK8t1W378pxdsSyotmZs15uSs1auR+nf+tXKiIA12dgUIBXP
	 eMseknJSESx1g==
Message-ID: <877d3988-57f3-4f87-8836-85aad5454879@kernel.org>
Date: Thu, 2 Apr 2026 09:56:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: fix preinited section_mem_map clobbering on
 failure path
To: Donet Tom <donettom@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Frank van der Linden <fvdl@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260331113724.2080833-1-songmuchun@bytedance.com>
 <17246161-f314-45da-933a-770231ef2a49@kernel.org>
 <2183487D-0CED-4BEF-84D7-4439F3386584@linux.dev>
 <bb05187f-2a54-4c5d-aad2-27b462707206@kernel.org>
 <3ab0e5dd-cd3d-4f78-a7ee-01051f200b36@linux.ibm.com>
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
In-Reply-To: <3ab0e5dd-cd3d-4f78-a7ee-01051f200b36@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B8A42C000A
X-Stat-Signature: zb9ioqiejn66nbfdpmgc6cir758sse7s
X-Rspam-User: 
X-HE-Tag: 1775116586-800635
X-HE-Meta: U2FsdGVkX1/jDIxldeKAhofq8Znzv20/wV8d15pGeeYUa6Z2Dq2AUUSoC797y6dNyEe/JNy5Fd7biW/HsCjBvTd/eTugLo8OSVWSUYYM9WkaFwNbaksNaDSueJExQdiodLJ205l/hAsRyWbMSbr28Uf5OkMEyvQTbJdSr/S5AiRwEHdKAPvMvkQ8mlkmNhlMhvjudq6vVtQChZekcaoaiS/+FYYVn4Gj5lfL9G2rSxBhykpbR4C3HVIuwhDZkFvatvyN4JbDs5YzN6HOuIfT8hRIDimtJDH9Uiqx34CJnrwp6xcTklvQsSdiEe9WwqlfFAvC+wgU1lh5uMGP+SE9NJ6/qVIg6kIV1N3EPHvOHlTfmEZDeefgWLWWxwe4tairmyG+C/8Cak9cm1ndkROsCLAHAw0IaBH33eD/ctcn0/QNPHJpkxGBQeWPQbEUukN6Kca170AFEUA+pF+WUprjYMDx5pAdOJFquj2xRMV28d2TEnaNmNZHY97DANCrRTPSc5UJjzcpzz2jVVz0xLnMXKRpYdtqwAvgNjJ/XQFLdZsXRVwE9awWiCHjHcnfTBW50YaLRfeQVdr8Lvo/t/I7NLKU0qlXVeB8oPRcKu7Enf8tvidpsEAihKZ3Dpchx3hHiuy25DRVZIoHqLcnxTMQeN4CPJoU4s7qBGpNZLhqhMiw00ZTPCICcmZXfiqz66Rgnn4n4LhuKspFj+fh84SdTIdr2RahvZEHu49xYPYelO+6k0Y0rjhpUsrZwmGpqgUsC4KhxUOSG5uQPaXEPznOyHAZCqV5H05PhYRkq6LEDu/mSPzOPxR5ogfhnVcNW7tBr/euBhCMF4OjZBw6R0VyVSIFSN8QzNqmLwH0HHCyrijzW0W9bNe9AFMOv9kT2ZSdbJHwhw9nLWD36K2p7SL0jlVSm/3MCTuEzMM6+nSWy5ipkrT1bfqsOdcH58+glIQqCoYt2wHoQk1SR6C/fiF
 xzf1SNJV
 U8pNyN/teErDTvkINQQ6I7hPagD6N9Cf9IUgUKLJFUqC4yED+DpjCTTo9uvHbZKC1vOvYRSOWa3a+W88qseOykuPfUrtOyc+NdHCJu+pVGL9owdWzC+yuGl8VoWgp7w5vTVsVUWMn/G38rzHwAxHt+GWkIAm0miTVj+LJG7Ehl75glgCjrOiS7G/IH7CsBJUWANCt5joqtPJWo+5aNkURSAfa1YJBNtnRdqZjv3AYGkpy+CGuBnoc+8+SD2BgEb3JARuItxPMWfjTvkujdOYWX27trAvo7QwV4N3YexDsG7wIoV1DId6w+GKZQbjy4Y/2oAjB8kciFTZZee0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/2/26 09:37, Donet Tom wrote:
> 
> On 4/1/26 12:55 PM, David Hildenbrand (Arm) wrote:
>> On 4/1/26 04:41, Muchun Song wrote:
>>>
>>> Thanks.
>>>
>>> It's truly a coincidence — I also have a piece of code locally
>>> that does something similar. Since allocation failure would also
>>> affect subsequent startup processes, I simply made it panic when
>>> allocation fails.
>> Don't use BUG_ON, use actual panic(). :)
> 
> 
> Apologies if I’m missing something, but would it make sense to check the
> section validity in memmap_init() instead of panicking? Is there a
> reason this is avoided?

Not sure I understand your question, but trying to handle memmap
allocations during early boot should be removed. If that ever happens
something is fundamentally flawed.

-- 
Cheers,

David

