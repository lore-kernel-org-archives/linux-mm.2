Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24B8AC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AE146B00D3; Wed, 29 Jul 2026 10:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2368D6B00D4; Wed, 29 Jul 2026 10:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126106B00D5; Wed, 29 Jul 2026 10:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE5126B00D3
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:04:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDD59A1AB7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:18:53 +0000 (UTC)
X-FDA: 85041264546.10.8EA5EF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2E63340004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:18:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WL2UcCJq;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785316732;
	b=YX9tReDUosGAsjWcdrwQsms6UBF9ocK5P65jxBvaKPJbV7YFK3fg5cK9+6K9SVY6kpdKSo
	sFz406DHKAgLL5j+Jv7pp19I70PN/Sd4d1OLMdgwNO1T2mRiiSm7npNtmqXNOI/w4JgoUr
	pvfBc0MF0kBlYGl04Rrlrv65SD1e59s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WL2UcCJq;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785316732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmoUVJ5yBqcifcFy0pDqheGPbRslyS393EKLLRe8nf0=;
	b=x2egt0QsxekyYC0iIMOOxj3VompLooxdxHEafi1HVSNimCGPTNI2MWpFBPngpDYrxHHwkq
	4+75UiICdXmY1704jHcsgE0iEo2Xmn5Q9nXSizkwHlP6d3c1vHmPCWOlyI++rTIRZfZW0Q
	gn8tkHWq0NEfTAxMAVAw4w/IMXQuerQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B1B0438F9;
	Wed, 29 Jul 2026 09:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA791F00A3A;
	Wed, 29 Jul 2026 09:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785316731;
	bh=kmoUVJ5yBqcifcFy0pDqheGPbRslyS393EKLLRe8nf0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WL2UcCJqGpID0NJWJeXvc3JhTXUGApi6yIW1VevW9SkrfNKShFla1kZcmmwd7RVJV
	 jYzHQz+/QZ0hao3Ex2ErJXKhzbs0/oCQBm6ZEuNBkAlNu+eAK49/hQEUSovMbabJ2p
	 8c53ABquIRJEL/FpwT2NZ9FBRn4/RlSZ8G1aSHPUVBsdgPoBjq/+v+tbLUDHXmIN60
	 QPRhyTlQK7eTmFaJR/y5STwMNhkFIxD0HRGgCgFjYxaVfuvB5oxYRuMmvt+tkd1Qfe
	 v7OFW0/tSpMOMnG0F52EJ8WVTeYDfC0te/z6NbMgQKsmh1BY9xSEzKClgIsD7CUko+
	 +IrouMSkTfhfw==
Message-ID: <dce4a0fa-c206-4493-9910-f294645d4418@kernel.org>
Date: Wed, 29 Jul 2026 11:18:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: unpoison pages in memory-failure
 teardown
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260729091127.1001179-1-usama.anjum@arm.com>
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
In-Reply-To: <20260729091127.1001179-1-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2E63340004
X-Stat-Signature: grbieta14mmonju8b76ommjis3iwbdyz
X-Rspam-User: 
X-HE-Tag: 1785316731-531907
X-HE-Meta: U2FsdGVkX1+qyAN3FTLulhplMmKO6MbcsOeSijvUk+pheVuW2h5cOytuQk2hwB0F5+U3LxUQVWXghKIw9fK5s4yRHGyaxh0VfEYmZxwtzhjoHlGSiwU1gTrhtr4rzbsjulMPJU3DUOnGETvSKn+73Vwgi/DRSMkkfEYfoe94qgicClmZAIiuSlxYGwj6EHZlgvql2gTBKO7rQUuWhZTffNcxNDXpII67xzq0VoCAzbUff48rMO2WXSHChmJWkLpOGHeOac5Y13DmGpetz4rqMWB4tTvGBwbc8oHKXAka8CcthTwvXB3zXb5rZb9mtsvmsyk6AtpWjuaSzf6SpC0p1y0m/pU6TuT7nfjuP11CWv3CIo3neo1v+mvhlNe73o9okuzcixjWhQouR6d1YdQYfIqBevAG0PIOlL6p6ImwnjdEG6g5vWHaC9l51BCJRAwVepgwFrDi8dal5WJlecLhY44cRf8X5HnJrvQvpkkMyN7omVBDH/wv/X2Ka73BdF/RJjO5W0pcQl/T1Ze6j9f9Z+VS8x1+MnarL+XdVya8NeMtL+mOlW9jPF0kLSeu+hwDiCwkyrWsVzjskxj/Nnog+/mSPn1wo8cMT8YdkDhm92zQK6tw3k56qWpjSW+CtzJ4gP2IhC8sAClHxCEqEIspUgNoG0jPw4sdcomJc+9QIJfeFdZB5+uZKGJ+5vGn3mnn9cJn2UJz9EGRHlBFjHCh4s2WaSv0NTKEADTloLhlfbEwGLxk0OdUBDVNjsMgeF6Zo3lURJ3lg5WQSLDC21tA1REfYZaRh98p8oBsHN0GKnI2ykh72h8W+K6yKTOuiYgBg+AEuEbxRAIIGG+8oMAL78k/OxmbWtDasRNJLWoHIQiapqczX71jHaLaYtxrmQZLBjDu/iCCm7y+Lj/mO83jNXWDa7llJkK0WL3FDjeNQ7CrFWSVMtvGLyiM109Aov3y/lJrxy3BKOnxrEZLYM6
 IMOL9db3
 CXH9n7H3kZauyA/X7fOnnUOEfj7oqBBROaSfmSPL4KzLe7Lgrhv1uP1WBYvQCc1ZelN/nJVBOU29uJb5aQhBlYC8OyGlVrOvzbBU6ZNyAoudUgIw/7pIo0gIzMsm60Lf1LStvBeYJPfSVjsUQSG8PwS+TAm3I/uEO2CwpApQWCJOWUPot1ayXS8xt+vah3cDyWW8sG1JUOF8QOgPSroDto9AUZW52CKi2rPqL4R8aVVGtCJDqjv/fxY7FlhEfJwmXdIf0YMCWgrm1rYYqv4+q3QkLyMu4v+dza/mb9UPZV3BX3vyVZCUwERuUyE1QjP+4eKizZtVT/ds2V2GPRougVTfr2zo6XfR65DdLCyuUAOUPRNl4k4jkm4eNJansbhXim5JCR/Zh7GDAf++WEkcQAddEEVRhBezoJrjsUOYrUZJh33Ig7OnYn1V6xxefoTMX2GS7dRew+gbVCYXQYSUR4xAgOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 11:11, Muhammad Usama Anjum wrote:
> The memory-failure tests call cleanup() only after all result checks.
> A failed ASSERT_* invokes fixture teardown and aborts the test, so it
> skips cleanup() and leaves the injected page hardware-poisoned.
> 
> Invoke cleanup() from FIXTURE_TEARDOWN() instead. Guard it with
> self->injection_attempted so tests that exit before injection do not try
> to unpoison a page when no injection was attempted. Injection can poison
> a page before returning an error or delivering SIGBUS, so teardown must
> clean up after every injection attempt. This runs the existing HWPoison
> and HardwareCorrupted checks on both normal and assertion-failure paths.
> 
> Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

