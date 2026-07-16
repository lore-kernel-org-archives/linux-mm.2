Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8834BC4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7804E6B00B3; Thu, 16 Jul 2026 10:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757D16B00B1; Thu, 16 Jul 2026 10:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585A26B00B4; Thu, 16 Jul 2026 10:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10A9B6B00B0
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:49:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 576721601E8
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:41:00 +0000 (UTC)
X-FDA: 84994901880.02.51F4AF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 97213180006
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:40:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kK9sWOex;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avwfvqQvBuo4kJWama3zKcnrK2MiPJPDY+UL3bT0tcE=;
	b=HBRYXgrlLjtme0lX4GEocVs38EFjZd4CGta8XYHubYvo3tuxtiRYlzGDLlFo7ZIjavRh9t
	YsLiJ19JpgDqdGcBwxJMCVZAjyi2ZesePqaiFRbYdTCN3OVl5b4Isar/VY41rw6II+DmdR
	OXRvuQIhad3pWxkDOAweLojJ6I1yYWA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kK9sWOex;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784212858;
	b=t6aHt2GxYDJDM2qDY50et2Z242R8dispIZNB/g3crC78PeT+dhYI/f3yTqPuXHv0PuFvYJ
	56J1cJZF5HTs1FntAV+aqW4pvd0kRF11zGRkJyPkN/jh8TA5X461mlNlXziLb6Ovc4bmQn
	CjVf7brCGFV23rLDRPyC5G1euqO+7i0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AF1B60A58;
	Thu, 16 Jul 2026 14:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0DC1F000E9;
	Thu, 16 Jul 2026 14:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784212857;
	bh=avwfvqQvBuo4kJWama3zKcnrK2MiPJPDY+UL3bT0tcE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kK9sWOexAIu3PHE/vl+jtGi0muqtZYfbmbvglnEZqTqayzxospTi1EeEu0Daedt/8
	 03rsBOGFmSpKIvZ4gFsBYGqCQ2gi74RVAnD47YMK5DgUkv+MWJa3r1BAI8IO66vwIO
	 H0Su0ifPrazwL7KOR6WRYVQMUml5pZDK9xOct3Jd2iaDymTQH/H8Vb2tIc5/aMC5H6
	 vsUl/hGhpYhZWw+q9D1aLS9Z4b4dQ4xy3ctQRFZ9iTYUtboKTDx6tqsNi7VXsn6Csk
	 85vdq4FHTE7lRa3LUfCYZ4R/je5keMvenwdi8UyLkCcpDUnfTpobllCzS7vXKlrh9U
	 FCkJ/biDc/ZYA==
Message-ID: <f0a543bb-e646-4214-a1b7-dceeb1a9264e@kernel.org>
Date: Thu, 16 Jul 2026 16:40:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] selftests/mm: add PAGEMAP_SCAN test for THP PMD
 holes
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, usama.anjum@arm.com, peterx@redhat.com,
 liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 zenghui.yu@linux.dev, shuah@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, stable@vger.kernel.org, kernel-team@meta.com
References: <20260715144234.442721-1-kirill@shutemov.name>
 <20260715144234.442721-3-kirill@shutemov.name>
 <714bdcbb-92cd-4dde-820c-e3761cbbaf07@kernel.org>
 <aljWYfPRCVc6IB2b@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aljWYfPRCVc6IB2b@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e4h5yuhtxidcxwz5hqn9uhaq84d5bxf5
X-Rspamd-Queue-Id: 97213180006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784212858-275131
X-HE-Meta: U2FsdGVkX19NjRmJpiH6/1a+skut1+LZ+VWQbXWJFXA+S8615ah0vX83RxLd8FW+lzYwlBkayu/x8BZWCTJl+2grYY/KQ2FL/SUbwSy0n5d8vpXBVohgtfEtapesVKstfREguRFzn039zNKX/9zclCfZSYjS1wORym3jauyNE11cOYsIeTT5EyvUqjSlUdTEAwL4oWOSVxLXM0yV1MQhlrB5RB4Cu45f8ilefomJMTgDTFWLt/D+g2qm2M5zpQaS+rFZCHlC65ZaFNJRanHyMWXYthz20mA1tYoZBiwKlEWHO/0B1xAS9/1oK+393Wk5QXz04A4UlZQ5fKsrj6GhuO2cTEWqVFYb1U54IR5yHD47hsiuoILMmzCZU+SOejYXL4DOsn/g6SW25RVCj2OS0u+vy2jM2MVq9U4+8BL7q2Hi8TnUYqmjvKXHw8/u+PdcUVzGn2OJG9YMicheOnhA6c5PXwYEaEttr35z7SZzgFmJtRXmjyjMF4T4jtk1D6vE4Hi7Vnql4Xk9n/gGcS5H+h3WwP5Y3JoGQOEsNFo7sOJ6f0wd4Er3NtKhArY5BY6lzchSfPJ5VZwUQ6VHHhdfQakJ5aMrk2URMq9EegI/BFInFNyZTv+sfQjJkgu1uNiRqYzXa7iT7WxZ4nIoFkna2GXutDJnDahYBBjVEv/H1KcHWaMWqsXQ077D3KnMg0sZ4JtyBtLWmHFFtlrFRxTTD2OdFqCdhMVN8AfH42n1LmXi8TqKcsAtjPvU7Ge7gzr+vtxQzpfKm5IEA0mn+GVVpjK2SOFqaojPzQxVj74PIySBlXjZoYdVUikAEnGVOBNkQWHJhJYeqmnYEI5o9JiItUYhiZ2BgYEJINrRlcfPRKLw8eYe3Q2HzkjgdxN+6aK1+7k2RsufU9XYON84Z/jZ2qQM4egtBpE7OP1YJ/uNjkgGcJSPRRAw77NAMcJ2JQX/4GWt/fi7mPSRxAba724
 fJvHQAR3
 /i7NLHOLdG3qZwuV+9tsz6y0vCvgUrE/QG8abDsCU6UoT84cjJSsnUw5xklg9spzIVfZZt0WTvxMwInx2bdmzMViEEY/CsJ2uKWPv3KuOnNx1bcGXrKElzGWLfmvdwd/tZ9HcJNg9/aX092QbnPEybmX7L1i9pcMSNzv84GnMF7IVvngyLLzrVz1Nnr/kRAXvvVV6QzdGV8aBy1VkKiyleuqJJAouL7OPwKYJDbnadZXnBO8kuKUJ5hKNoeEw4zYJVjDqwHDiT52yoefEUEN0gmuqGAIZF1RLCm//X6F2/D63nfu1nw8c9HXIJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 15:03, Kiryl Shutsemau wrote:
> On Thu, Jul 16, 2026 at 01:25:22PM +0200, David Hildenbrand (Arm) wrote:
>>
>>> +	/* Fast path: category_mask == return_mask == PAGE_IS_WRITTEN. */
>>> +	ret = pagemap_ioctl(mem, hpage_size, regions, ARRAY_SIZE(regions), 0, 0,
>>> +			    PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN);
>>> +	for (i = 0; ret > 0 && i < ret; i++)
>>> +		fast += LEN(regions[i]);
>>> +
>>> +	/* Generic path: same query expressed via category_anyof_mask. */
>>> +	ret = pagemap_ioctl(mem, hpage_size, regions, ARRAY_SIZE(regions), 0, 0,
>>> +			    0, PAGE_IS_WRITTEN, 0, PAGE_IS_WRITTEN);
>>> +	for (i = 0; ret > 0 && i < ret; i++)
>>> +		slow += LEN(regions[i]);
>>> +
>>> +	ksft_test_result(fast == npages && slow == npages,
>>> +			 "%s pmd-hole reported written by both paths (%ld, %ld of %d)\n",
>>> +			 __func__, fast, slow, npages);
>>> +out:
>>> +	wp_free(mem, hpage_size);
>>> +	munmap(area, 2 * hpage_size);
>>> +}
>>
>> Sorry if I wasn't clear. I think unpopulated_thp_scan_test() can actually reuse
>> bits of unpopulated_scan_test().
> 
> Ah. Make sense.
> 
> Here's my take on this. Looks good?

Yes, thanks!

-- 
Cheers,

David

