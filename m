Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1413CFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AADD6B008A; Mon, 27 Apr 2026 12:07:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 782046B008C; Mon, 27 Apr 2026 12:07:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698446B0099; Mon, 27 Apr 2026 12:07:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59D696B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:07:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5414D121932
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:49:40 +0000 (UTC)
X-FDA: 84704770920.17.2635AE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8E760120014
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:49:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MI6yBmVH;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kQ+PgdM1PbtfpIYyny31IM2+kRZt1X8KXnqjpAcJE5g=;
	b=dxtdv/wDgJ/tJs7lWLQmorh/2N6/PVFlq8DmYAePCEEa6XifDerkuwp6IoZla4s+yaKABL
	+pCfOAMV9l3USIo7xaDbBGxNOMlRqfCIpLTdUJEQWF6u7xrAJOdXV2kmmVQKEL6r1VqXMV
	rSRHDxcquqZgajPUjrx6uQdmtCGNUtM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MI6yBmVH;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304978; a=rsa-sha256;
	cv=none;
	b=ahrCVmd76Wrn1JJ37HFWCKJ70A5xe3V/K+T1qgWGKlJt7C1YGPknqJXJBY4nBmGN6R0Gir
	WkraJougHzeAmdqppV00HIPl1wh+ZgdHZov5ckz6NBOa25d26D0DsMb3dPoXPo6CHmLYj+
	b3pGWsouMYZ9p+24rFs00Rxjzda4eNg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E03B60126;
	Mon, 27 Apr 2026 15:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5E7C19425;
	Mon, 27 Apr 2026 15:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777304977;
	bh=RnyH3VaJp9iG+DCxp6sKhHFXhoXkGIg/w2D9Ek0Oh5Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MI6yBmVHD6NdSnTMBO36N9sU6nMr/OjWEqGqd2jCLjCEWVVf7dk6mjXJGk2yQaK+E
	 PhAYxUVn5EV8LITl1X+gPSXptKRIM68RrM34vUt2DrcVNMQao53KTVeexPSpg28oD3
	 f0L2Wus9WpPXxriMmieKZnpDtIBoXuIfbtGyEw9UGVFgV4dr1WPwrtXnNPuVkTAPhX
	 d0LlPk1CCsyBnddzt+4T76XT6w7AfRcUNgeHf3g8/28A86Jer16wSp+KT0ISHT+EgH
	 O4pOx9y4K1R9LRkKGLNNOayXWpdALpsycItvZHn9moremGmL8FZrXgwn+NY/5Arsfd
	 IEXCtXz5ZIQlw==
Message-ID: <9d365395-051a-436b-9017-352ebc889770@kernel.org>
Date: Mon, 27 Apr 2026 17:49:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] mm/memory-failure: add panic option for
 unrecoverable pages
To: Breno Leitao <leitao@debian.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kernel-team@meta.com
References: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
 <20260424-ecc_panic-v5-2-a35f4b50425c@debian.org>
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
In-Reply-To: <20260424-ecc_panic-v5-2-a35f4b50425c@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E760120014
X-Rspamd-Server: rspam06
X-Stat-Signature: dud4g1xgqtu7ijecspu5y1bfymtumod3
X-HE-Tag: 1777304978-106472
X-HE-Meta: U2FsdGVkX19xwX5qkU20niNaoobUAys9f/l7Mr4VfmJMEjne2e07Tb4j5yMXEc2sVzLe/nuCx0b5LV5gf7Lei0LbYlwmf6KtO0LQ8T58wWx7XxbaekCrSJgrjU7sSMPNYYOlh5vRdOBK0wqtABRIxmjWiPiW/rHGj8/0Os2P1oZugyCYJV7qRVt7IE45ckLqHf5rOfs3vIvQ2FgfLj0yk4EViDEQLCTz6jckuVOMe/nch14cCmKMVTnT8JGcmrexnohSLKGqmWIPU0pIoB8SdVdFGxEqcLC9dvSn+VfKnM1MZfXEclEboBmGth2aKJ/4hGkFFZtU/BGRJ3Kmt9inzbfczOpQuud6DK6z2EqfR7S/avvZcwkCoeGyAk+amCWl4QYpJZZtOM4IxlHghu3RwJqVoIKa16qnQHcOg33P+gYqEKQa8ECCU2pLkzMfhJQOatC7QkVuBLu3MvI/Bovh1vaRZ9J9XyLTwa0EuwozZqScYog+sNdE6A5XmWwpL0rxVb8gR8wXDHwteT7V7QKzoCNB8pW7Rh7rNNSx/i39+6Dh7Ewx3QIWmwzI2LGOu2Yco6m9uoGGsh34meAIXkx23Radl6GOVjgC2Sv2Va0gjPYCxpKvUyrqwhSvxb4qu49ouxRtGUeKsJfCym+yrbCT255AyYDUDBLozdEx2p/2oIyoSU3v9sOk+8ux2NNxVm3FgMKu04xrN8vzgj2ce+tCtikwEfgazhSOdFwyALQQRDPX8rWOGGxsUho0eBJV2/84fXzscmhEVhi+c54m48vXlXpKqsTIbGookX6VngS8NUK/BSaRV5aHTQFo0T5+wjF5Sb9pGQ/vHODO4ykAFB7ZjwXvNR+/b2Akbqo/fj4igjgCZSWpS28M2c+31PROYPS6Q63vJ3jnIByXgh69C6jbUqeRICKZq+lmmADwu6RYNnKISpXBuVkJ3RZRKW6BVjKo6yLwOWgHOGxHaGau9bX
 /WvpaaYi
 K6/1td0X3SY7L0iIPDJDE0Q1uxOdtQ9QUTXaTis1046ry8nu2VuR0lTNvN8xNmRAv54bp8bD+9qUDAym7I+G4lrkXOgp3HIARZxkknXPEemOgMrOwW91YAtCuHJcxt9bPANicEtN2zeYEZ55NMwJ5vJNpPvpuZtpFGsM8X7D//4wPl6jiSodJHMZAZ2qpq1r3zqU57GcighpMxcawp4OKVoj2cP3UlUKjeBZnX3Jx68++I5Uhku0rN3tgilpnqJel0ocqSOFu/olwAbe695oCyRoj5raQy5j02L7Ys6ZPiy7QgXJBi5YKIq7+0W/VyEESWQ90xFOcnD0a97k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +	switch (type) {
> +	case MF_MSG_KERNEL:
> +	case MF_MSG_UNKNOWN:
> +		return true;
> +	case MF_MSG_KERNEL_HIGH_ORDER:
> +		/*
> +		 * Rule out a concurrent buddy allocation: give the
> +		 * allocator a moment to finish prep_new_page() and
> +		 * re-check. A genuine high-order kernel tail page stays
> +		 * unowned; an in-flight allocation will have bumped the
> +		 * refcount, attached a mapping, or placed the page on
> +		 * an LRU by now.
> +		 */
> +		p = pfn_to_online_page(pfn);
> +		if (!p)
> +			return true;
> +		/*
> +		 * Yield so a concurrent allocator on another CPU can
> +		 * finish prep_new_page() and have its writes become
> +		 * visible before we resample the page state.
> +		 */
> +		cpu_relax();
> +		return page_count(p) == 0 &&
> +		       !PageLRU(p) &&
> +		       !page_mapped(p) &&
> +		       !page_folio(p)->mapping &&
> +		       !is_free_buddy_page(p);

I don't get what you are doing here. The right way to check for a tail page is
not by checking the refcount.

Further, you are not holding a folio reference? If so, calling
page_mapped/folio_mapped is shaky. On concurrent folio split you can trigger a
VM_WARN_ON_FOLIO().


Maybe folio_snapshot() is what you are looking for, if you are in fact not
holding a reference?

-- 
Cheers,

David

