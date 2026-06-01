Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7910ACD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 13:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17A26B039A; Mon,  1 Jun 2026 09:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF1C6B03A1; Mon,  1 Jun 2026 09:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05016B03A2; Mon,  1 Jun 2026 09:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A22756B039A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:24:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27E8FC242E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:24:22 +0000 (UTC)
X-FDA: 84831412764.22.693BC6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4ED0D1C0010
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:24:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aHTWbVtK;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780320260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xj0Qmb3PGvR9vYXLCTRMNng9IbwfFzut9XpsoiGbGg=;
	b=FNIl0BP1Ah3p1K7vpTtl4R6i7qmoeeIL8MDTbNwnumrJazkwrtqfBHl9fG9MwDpvF+VV3O
	BwIOIi06wCYSKKbTYuDMKORxrgc/rg7IvhVgISrNVHJeXBUbksYSU4RcZO+zQWcxQqnX9t
	ZsLt75YXdXh35k4Eda9r/ONgXWlLs80=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aHTWbVtK;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780320260; a=rsa-sha256;
	cv=none;
	b=i3qcy7fbRAeH4EYb4mvMN9BBTeP5H59pyTMYqUSyhzW5okJCIfdfwZKJwKbnpwXZI/0m1D
	i/t52xSa0O4PbNg36S9JoRhJg8MyJGotV8kBJqrBFqSqamVgaXhEc67h1X7jj4zeuHtv6F
	jIdqV+OMyhh0168ElBZtiLuUPNBl1sE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5168D44059;
	Mon,  1 Jun 2026 13:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B419F1F00893;
	Mon,  1 Jun 2026 13:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780320259;
	bh=4xj0Qmb3PGvR9vYXLCTRMNng9IbwfFzut9XpsoiGbGg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aHTWbVtKn7f+LNNNpRHoDFO9RRSGdRMNh+r/lcwYlL4Kpb96gJTSUYUalNPuCsI83
	 Xnddj/uOXCZ7MmgKTAa5furNrlqlZIsJBIaqJp64H1FKDFpBGnc86eNbGnHk/kMtUb
	 aLxbEunIY1/JuAIvCeJ4iYSUnYlJ2d3GcUYBNh7lfvgUHc5JyunfmPzbpru9L1Tg7D
	 DCtaTk3iZ7N51uQrnxKjPJuEWtcWV8BKb2JzGRGRT29OMVksUbgemQidyKWGcmlXDG
	 L9j4zrUaeYrIrIr8eS2RkkZtpF0OUUxDZyQIfz3ar4tAM0QRy/3jh+C+g69I4GqTc3
	 JybqLRPxBDJhg==
Message-ID: <f6816b64-14b9-44d0-ad27-323629a0117e@kernel.org>
Date: Mon, 1 Jun 2026 15:24:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/6] mm/memory-failure: report MF_MSG_KERNEL for
 unrecoverable kernel pages
To: Breno Leitao <leitao@debian.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-3-9ea0cfa16bb0@debian.org>
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
In-Reply-To: <20260527-ecc_panic-v8-3-9ea0cfa16bb0@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: euz3ou8qja534ztw5uicaa8j3wnz81ky
X-Rspam-User: 
X-Rspamd-Queue-Id: 4ED0D1C0010
X-HE-Tag: 1780320260-725305
X-HE-Meta: U2FsdGVkX1/S3h5Oa4KTccsx1lEAfqcmweZJndJxL5Jhjunyp1RANOTOKuik7JuK37wix8IYl/tYaxEhiZ6/RZaVevkWFeV0fmR6ZIjSeY58x+Y4+Mdmurm+ZYt7SHcdLYA+srkXRHHkJT1of5pGGUfl6dw4VePcEwHtyn/BVFRkucWWeExYkG5PM450cx599VTbtf18wBeKc9bt25sGD1gEkWHRIu9Tp16mG6XxtWT1sdst8do6B0kM6epa8nUVlfJYp4jTM1clHxpa0BdyMj2af0v9FoxS/TmRrZK7qwNxFO4DEmslDYmkUf3r/PpgCQQ4F1AfQk5pNjTu1ENrxARb64tz1XcyEI0VFN9jFCZAwejn/hm4iv7wfFWu41Z8EybVPlzWqVnKl2vNdyzx2sG9YSl1C6mDNrWsyPB0SONGgiwJJ4rbZei8JdP0iPMKnrayVA9mGmViGDF2IEjmw/ttpbczCG8bSxUpD37uybkbMrWsjiWwulkD4Mvs2wpOF2joqnknDBv/pPB7rKiOSriKssAbPTotEZMEbEyHsjeafaY21G2e/YDOzNz/TmDLAAHLeKKbg1NMyUzzkROxKXEP69YB6jPM5ViaKilFag8epTe0s8+ny9HmTBskkYP04dzoodr6RFdtf2kBSlr8Iox15n+o12r6tvvQQ47OIbEZnIPVtgl8u9KqMOhYyllYTUgWl8D4H31lZgySUHzw8HpypQlDysXwTqeOPinFuYdc9wPqzpEAqXTscRMV/h3hjdLNkAZKX7eAbOJQWnsith9re9VV1l+dv27xlvF880WGGuRs3b6BhEFLfaVXMUZ+DbYQPqDWKB/wxwB6pQhwZ04Lw31iTXnisEQ8owWV4xcyrwgTo9/mHLp42lpJotZzmhNebkDXhISVwgmWur9IMCf1DfYEiLzvX/2IobOPMfUPXHkyAxAjFowj404Dgg+gHrXaCzCMNzA7m0p5Om4
 +43ee3nT
 7Vjj6Tu64OTaXLOxBNNCm7KFauOdVWU9TQcS6+7BYkW7uixLUS4WTrHbz5mpVnQD4aHpfvTwF3Amf9ou7ly74ZLhn11WxT5N1AVfOHXXg0uieqNq9d3LNRhUoQrNWhg5zuzJq7ZHtiFT+lLBUvqUKabQ0DICXJOC3TjygK8Tueth+GL0W2cFILWvxbtTMFdcxw5C0uFw4736dGFmSHYCM0Rep8NlGdANZ1hE0p0o9oK3HO92v53ea7bVvLCe1y+9U77oq5nf7cRjie4tF37gDzpxABLuNkNLCrI6EDwI7EjNxSjsM6f+b3JmVkbbR4Dw/2g3ZU/m7RVEu6U4HUH3f6QUX1XxCCkF4uGRwOWkZhGqpQ+gi0z28Nfn3tLhdhQGkiE/a3zQdvxau0TlD93AyEYB/k6OV2VqIUWzIECm61E5nFCI8IqGOiUhRWK6UwUpwfHWXaO2yOAFCjUEhnpKspM12Y8wbS5L/iqKcuNzgxrDvThAzQNQr8cCgsSSVRgCcnmiqV1vzzqCWIcuOVyqqTDvnpSQfK2KN4CF7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 16:06, Breno Leitao wrote:
> The previous patch teaches get_any_page() to return -ENOTRECOVERABLE
> for stable unhandlable kernel pages (PG_reserved, slab, page tables,
> large-kmalloc).  memory_failure() still folds every negative return
> into MF_MSG_GET_HWPOISON, so callers that want to react to the
> unrecoverable cases (a panic option, smarter logging) cannot tell
> them apart from transient page-allocator races.
> 
> Turn the post-call branch into a switch over the get_hwpoison_page()
> return code: map -ENOTRECOVERABLE to MF_MSG_KERNEL and any other
> negative return to MF_MSG_GET_HWPOISON.  case 0 keeps the existing
> free-buddy / kernel-high-order handling and case 1 falls through to
> the rest of memory_failure() unchanged.
> 
> The MF_MSG_KERNEL label and tracepoint string are kept as
> "reserved kernel page" to avoid breaking userspace tools that match
> on those literals; the enum value still adequately tags the failure
> even though it now also covers slab, page tables and large-kmalloc
> pages.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory-failure.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 8f63bdfeff8f..14c0a958638c 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2426,7 +2426,8 @@ int memory_failure(unsigned long pfn, int flags)
>  	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
>  	 */
>  	res = get_hwpoison_page(p, flags);
> -	if (!res) {
> +	switch (res) {
> +	case 0:
>  		if (is_free_buddy_page(p)) {
>  			if (take_page_off_buddy(p)) {
>  				page_ref_inc(p);
> @@ -2445,7 +2446,19 @@ int memory_failure(unsigned long pfn, int flags)
>  			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
>  		}
>  		goto unlock_mutex;
> -	} else if (res < 0) {
> +	case 1:
> +		/* Got a refcount on a handlable page. */
> +		break;
> +	case -ENOTRECOVERABLE:
> +		/*
> +		 * Stable unhandlable kernel-owned page (PG_reserved,
> +		 * slab, page tables, large-kmalloc).
> +		 * No recovery possible.
> +		 */
> +		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
> +		goto unlock_mutex;
> +	default:
> +		/* Transient lifecycle race with the page allocator. */
>  		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
>  		goto unlock_mutex;
>  	}
> 

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

