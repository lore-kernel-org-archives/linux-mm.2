Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D629C44501
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61E626B00CB; Mon,  6 Jul 2026 09:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F5CC6B00CC; Mon,  6 Jul 2026 09:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50C1B6B00CD; Mon,  6 Jul 2026 09:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2364F6B00CB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:48:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 996D38CC27
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:48:25 +0000 (UTC)
X-FDA: 84958481370.20.68F0BD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C37CC20009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:48:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MJpvANO7;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783345703;
	b=mb0e7PLfyLr5I03YmMA16JYNpJwXfQmrsga2tTZl4NPqoonwtEuxjtwBXsGkfSUMXEqe4c
	98B6mMlezTFzzJIkj/XjL+oJDzOJ8e1v8YIa8gnmPem4PHwhDzy6i7qJRipjCwPT88i5E7
	iZgj9jL2qN5Ulz6hxpk/gUwDorDZv54=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MJpvANO7;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783345703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9KGHs3IaR4sMS8H8qaxq37Cq5Iqi3LZuorN5eZgO0so=;
	b=YPdJlm5MKXdCJ880V1Ea0baHpnPfjE0qZN9GAPSSrdWSzbYVRThjKpq+H79B55mq+hcvUp
	youmWHd9gp2nBpk3OB8t3M9fCoUVCAOed52bRkfh5X3lqYE8LxPbYgSyN2F8CcZGBTnfS9
	Vzpz2pT3msMY3Cl3BuTg5tdukd62gU0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 18B28429EE;
	Mon,  6 Jul 2026 13:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5101F00A3D;
	Mon,  6 Jul 2026 13:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783345703;
	bh=9KGHs3IaR4sMS8H8qaxq37Cq5Iqi3LZuorN5eZgO0so=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MJpvANO7oMNOdUNCDbxaRuWKZI6IrdcFSfL/z/0IGKB1xpzEiaQ31nPCnpb23z4AQ
	 5k2yoWzaYwh+KJPHcWoxyK8rfhSBw5GxgyOMkKY2jTUT13x8SxcBbrtZDLYd2v7b3e
	 lBTmg/ZLXQ5yaX9qVna2VhrjoCGo54hkv9Aw2kqOr9OUQXWSO+PkwaqFggOYhBq8EX
	 MWFKnKeKwLMLu4CKnlXubeWlKGKhnV+PiYZlWWr6q3z0CGPWZgNW4Z25UGK78BVeN7
	 7NQiO/oBBEVvn8lgVqSeWs10wFd1EsssyH75XL0I5Cr2TH917CSeyfD8/epkSiv9G9
	 z/84ROp/1LRHQ==
Message-ID: <efd55e0c-8caf-4633-b876-18e8e788493a@kernel.org>
Date: Mon, 6 Jul 2026 15:48:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/8] mm: add a set_page_section_from_pfn() helper
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de,
 bp@alien8.de, dave.hansen@linux.intel.com, kees@kernel.org,
 linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@redhat.com,
 rppt@kernel.org, tglx@kernel.org, x86@kernel.org
References: <8a6f0bc0-5b6d-406d-9d2c-d3861b5c31b5@kernel.org>
 <20260706115213.50375-1-lizhe.67@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260706115213.50375-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C37CC20009
X-Stat-Signature: 938tk6gyf387357qc64r373kwwqr7fga
X-HE-Tag: 1783345703-906717
X-HE-Meta: U2FsdGVkX1/7Py+X0QdBTtnQyDG4TzIyYLi0HmU6r4ki+Qeu/C23cycod0e+o7AEPDTYOS5yobFIU9vbrz2x0PvflECYzB+vjZL9DUDGP30g4hOA1taMzLkl/nO4pmxl9qRSAwchF2oDcFEIG/EZhCuSkcTfiEenF1XbUTi7lWJQVMOnNuD5yT35BO7y8X72cePEOa2T5CTk7MkCVO+iD5Tazv2XXBFrSOU5PEadZGANp2FbVwENdt5LAIXy/zRPA+1fkucwyP9NY539sKuYOauQTq8/yWO0ta0Nj8Puvt21HUcl71HY2ThcHJadoDGhsH3INKbKbpZc/vKb/XUKfbXSlRGvjqMR200qsc8i84NohLnXYfcoqmmUSGFZosDduQegJNNCLu8T0ylX2+U+A9RZlUfPOwF5nwBVMRkbV9R0pEv8HhQw+48swXKUFNz2pZWB4xGcAE0oOVrK1/1DlAUUZzYdHCpHVdUHrEqp93f3djEytE+YM7BY+nZj6H6hFxe0V1eftv8LmK5AeKKsJvoShUnU8q9l4YzbhGyKcn6fZlJkp3SmNvCvQDxfjWxokcYAHvhzkjudiUn2Qj1qAbKHNsrjhlYmnz0AXzLw55PBQy84eNh2Dyln1bIqTOWtJ2Ljb6CvOV5W3V72Vdbo28qJa3AviN47JMjEZ5ZPayrQROWPn/ISOFce/6KrdTF5SNDJYWDVODlsx2qS1bCxhV6sUus+aAlTDLfWefj3nP1PTdSPcY6f+cWSbGthRcxC2vTwE67ogFIijTO9Z44rRcAoeiZC1kFzgWJbnxfnPBdkSIAkrYU/muYwiVcaBQrl/rCNaOUs2MVW2mCUvv9rP00AqpSohuLYTcj33R11979528Pj4tCRhW/x0ixpu3e99VGSp/VNRp8nk6dAz1ZUIJhXhgGeoR64I2RAZQkMxjvGCcOOd7g7LBb33o4/hDWUtv3OfOUZJvtY2aM8Ttl
 ErFIbvxN
 4Ns5b0drIhUFU2o/c5Rzw9xfdo6Hh4MBA6u4dfPDuUtqICD0TVpQ1TZQq4LZ0UJrETwaSrU8exQA1uWNQmaYROSoOXV2bcWaaeglSNA/4eqRcIjR5Vr3iULKpNcNrmMJhDlhZER/M3H8hI+y8BBTv6byp0ss6dyT+ERtjLyYnUH32qcXmq6mO33J2UJRBzKa9QTlXEoCRLZg/AkSvjjWWI8recvAD9U6GyUHalZNS+8TyWYWbgK1yejOQAivHnClD2OCmcaR0TZ/gv5O6jiZF97Jav6Bm+Yt7BPd+hx9bhi6PINnS2n/3eDXcpJxuMEodlgRz115rSlT78EI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/6/26 13:52, Li Zhe wrote:
> On Mon, Jul 6, 2026 at 11:15:36AM +0200, david@kernel.org wrote:
> 
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 485df9c2dbdd..f78afa63dd3d 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -2541,11 +2541,26 @@ static inline void set_page_section(struct page *page, unsigned long section)
>>>  	page->flags.f |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
>>>  }
>>>  
>>> +static inline void set_page_section_from_pfn(struct page *page,
>>> +					     unsigned long pfn)
>>
>> Two tab indent.
> 
> Thanks, I will fix the indentation in v6.
> 
>>> +{
>>> +	set_page_section(page, pfn_to_section_nr(pfn));
>>> +}
>>> +
>>>  static inline unsigned long memdesc_section(memdesc_flags_t mdf)
>>>  {
>>>  	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
>>>  }
>>>  #else /* !SECTION_IN_PAGE_FLAGS */
>>> +static inline void set_page_section(struct page *page, unsigned long section)
>>> +{
>>> +}
>>
>> Why do we need this?
> 
> The empty set_page_section() helper is not needed. I will drop it in
> v6.
> 
>>> +
>>> +static inline void set_page_section_from_pfn(struct page *page,
>>> +					     unsigned long pfn)
>>> +{
>>> +}
>>
>> Dito.
> 
> The no-op set_page_section_from_pfn() helper is still needed for
> !SECTION_IN_PAGE_FLAGS so callers can use a single helper without
> open-coding #ifdef SECTION_IN_PAGE_FLAGS at each callsite.

Sorry, I meant two-tab indent :) Why we need that was clear to me.

-- 
Cheers,

David

