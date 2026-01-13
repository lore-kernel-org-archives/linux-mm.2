Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C406D0C844
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 10:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F3196B0089; Tue, 13 Jan 2026 05:31:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576A96B008A; Tue, 13 Jan 2026 05:31:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457856B008C; Tue, 13 Jan 2026 05:31:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31EA96B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:31:09 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF7C01601C7
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:31:08 +0000 (UTC)
X-FDA: 84326573016.05.95BFE2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2991B1A0009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:31:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=COHIcUZh;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768300267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82oNiSJ1RtCjHJrlz+u8AaV/Ovz1e7P3wCEjO2Z8Dyo=;
	b=biWo9l3jkdgtXLkt1HxVP5fM0V7SZ8HnO9bYjariGLAoPQ9lXVxWhm6Bc8wyJ0sVekE7of
	ECWDGbAwfkl07CQ7sTs0n5AUvb847m3jRgUIwIAWlEybZHKkqF1Acp/FZebka4ogHq4Rb1
	VRF+AQrYSajS5gAuGN/ZHek63fTFrJw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=COHIcUZh;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768300267; a=rsa-sha256;
	cv=none;
	b=mQ+8es+cxk+eBp5UqcjdbnxVgwPPBvI4E8hnLQFl1/4lMMXKR7t+CjWETOYiduN4strXnA
	GtCvckc2i7QSByPqJyMZ6Ydq89zAbGAcAjDXYqpqqhnNaA1qs6lm6iVkCU0+u9rOfStTk/
	1t3FE/Zmcuq3J1v+70i6TM1d+cUWzcQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B0B86000A;
	Tue, 13 Jan 2026 10:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AE7C116C6;
	Tue, 13 Jan 2026 10:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768300266;
	bh=qXfi1gOm+TOj7q+4j1t43NeJ9IpYpbAkhWYTJZRTYq0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=COHIcUZhYpQkm6FG/CvO17h/smQtVgJ+9wUTehCS8Q1cRyT/Ga8C5iGKbUFaTi/9G
	 BLfMinCLYSop1HSUE0H+87N0E4FucbR3YwQt1Kjz3M1BzCDjeqwYztk5l+hMBZCxsk
	 Jue6HhNFdnwuxEmIY6h2i9k36hGaO/jVTdB+t8jQ5b5qStcYRnJ9qs2UtOrewKpgch
	 ZiTdjhtt1XsOwt8nouBwta3q9CDSfh4YAU1xaMF/wc55xnzyyOljZp14jsX+KWHFYx
	 IH7sVI/0ofbltswKKiU1NX4Tmv34YG3yux+IHKgYpfPemTaxPYlaohsW+vM3ru1BPI
	 OVuZxwqB67/zQ==
Message-ID: <482f2f36-e906-492a-a80c-987bf7359d83@kernel.org>
Date: Tue, 13 Jan 2026 11:30:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: Mostafa Saleh <smostafa@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org,
 robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com, baolu.lu@linux.intel.com,
 rdunlap@infradead.org, Samiullah Khawaja <skhawaja@google.com>
References: <20260109171805.901995-1-smostafa@google.com>
 <20260109171805.901995-4-smostafa@google.com>
 <20260109195111.GQ545276@ziepe.ca>
 <CAFgf54r_au6isA10Nrve=MHL455X=tKhNsSwH1ej-TX08J3xLA@mail.gmail.com>
 <20260112133256.GB745888@ziepe.ca>
 <CAFgf54psxPrsvujStPNtrzxiKOsJF+aVrN7BcNxxmAF4wDmRXA@mail.gmail.com>
 <20260112135208.GD745888@ziepe.ca>
 <CAFgf54q+9Y5TtGJDB=8q_BW-0F=TM7zBbCcMzvtvr_N2WMnd-w@mail.gmail.com>
 <746f5adb-1d91-4ca2-8ae0-a2d171203b66@kernel.org>
 <CAFgf54pbkfdFr6biE8BiNKBnTBFWxXGmvxsZ0E+C1C44c9AW_g@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <CAFgf54pbkfdFr6biE8BiNKBnTBFWxXGmvxsZ0E+C1C44c9AW_g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2991B1A0009
X-Stat-Signature: j3xjemhxko1h5rzaieb9dbqofi6ewqk7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768300267-889290
X-HE-Meta: U2FsdGVkX18r+tDB4iAbCoN9/7IgO4JaRr0WNCxqC81M/jQ+eB2FdRNaCyj8+umY5J6rn9J10sUNkF01ETT+et55LUlYhC/rHsZdC3IxBy23R50RU/Kv0syerP5fQGKNKsU0aQ6DwVa7t9RMNsLr7v5Qqr+8ODG3ASeoV7MKh34HAi141ppjqypCQHwLduhn1I0JamCNOg8B67LpcpkyQh0poinHDXfFn3s296zGpXLciKjRBDTRB9kdXF8DPKHzHrdWAdxfUN+hW2GKVuF/SSc6nH0yrupHIDqYj8irbH46tlHHa3tnMG4qkNpNvfLviM+Q5jPHJr5bvTJrnvJ70uC35LRVX7dxZ28EblC0En342y0nU346WdHA7QJWLJha+C+V71maSmIqgKeZd2952N4mSf2t1mJBnG6psQ/9x/E/btD6/6exgntqsC2tn3Br6K2npudXtsl+dYj0OjZ2lMZkRsI+HROq++LwgSx3Jiwwu32yow88VBzrMSQPwRt8KIMRwmZG6jNd+Vt2MvqncFmo4jii04Q3J3H3ozO1Isvv1whWpteXnwR4miyieXxvqB3K9FDoL3hnAbwF7ZhTS48/tD+M+UIfrGcrLzfh9uC968X5Gude+vtuMzx7Hh0eCHqQZQfY8zlBBpU3m4xOP8dt62LddaIaI4yAHa9y6/QmYFAiSFg70JadJvCEvQl5HZ3sNnGBUxgeE5ghfbpnKYs0kgQflK7s1mbSgSvPAxKyLFNAUKNwOCxdWJHADpo7aPfMJNdvGMGtFZYjCeZxN+hoxpuSeM3SL1E4BNpEh915lutcicrQ9cQu9c0WfdbwD9C3QYT0lv58M1sypQw4Fo8KPwbDbJEjHy0xmXjbLDYI/xv+37rejzA3f187xRpIVowg/x4ANpNUhXUyYFq1/Uxy4L9zMeptM0AYs2XF3rtERVI6l5RtVEwm7fkbVfSm8ZV0K0qywU9MUIayyzx
 ywBR1Bxi
 a2g7G6inzUv0c8jdI40DhqMVS5HP3H0bjEFghIsZ+hkqankbRFX+C8kDyqO68ArnrdHiUkuG/oKzTTdUPT5PVvpXDqz11Sw2oHQWEB6T5D8aag9ZPoW9gaf4+KqQnP3YZSGxvXrrGdlOFDmWu7G9GittHQJRIIT49+0RA2mDjfe5NKUXaRa4xTKNOH6LXoxlmpxdhMurlKrgU2CunjVJvmUY5mBGVgvVMqWviKtJxqBCbgGIptGxTpfD+6YVGeiwP2F7fNNX1A+pvpyBoxFpezx9TiU1PsUIhofbQI/p1ZscnejaUFB1L8zzigs2La6YJm1g1hfIefzzCqm94uEZUl+vqpLk82BnWtyPD4iX5rR88GNQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 11:22, Mostafa Saleh wrote:
> On Mon, Jan 12, 2026 at 7:12 PM David Hildenbrand (Red Hat)
> <david@kernel.org> wrote:
>>
>> On 1/12/26 15:58, Mostafa Saleh wrote:
>>> On Mon, Jan 12, 2026 at 1:52 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>>>>
>>>> On Mon, Jan 12, 2026 at 01:43:41PM +0000, Mostafa Saleh wrote:
>>>>> But I don’t see why not. from the documentation:
>>>>> /**
>>>>>    * pfn_valid - check if there is a valid memory map entry for a PFN
>>>>>    * @pfn: the page frame number to check
>>>>>    *
>>>>>    * Check if there is a valid memory map entry aka struct page for the @pfn.
>>>>>    * Note, that availability of the memory map entry does not imply that
>>>>>    * there is actual usable memory at that @pfn. The struct page may
>>>>>    * represent a hole or an unusable page frame.
>>>>> …
>>>>>
>>>>> That means that struct page exists, which is all what we need here.
>>>>
>>>> A struct page that has never been initialize shouldn't ever be read. I
>>>> don't know how that relates to page_ext, but are you really sure that
>>>> is all you need?
>>>>
>>>
>>> AFAIU, if pfn_valid() returns true, it means the struct page is valid,
>>> and lookup_page_ext() will check that a valid page_ext exists for this
>>> entry.
>>
>> Not always. Offline memory blocks have a memory map but no page ext. We
>> allocate the page ext at memory onlining time.
>>
>> Also, I'm not sure about ZONE_DEVICE memory, very likely we never
>> allocate a page_ext for them?
>>
>> I'd assume both cases are not relevant for your use case, though.
>>
> 
>  From my understanding, in that case, page_ext_get() will return NULL.
> 
> So, as long as struct page exists, page_ext_get won't misbehave.
> 
> I am not sure about offline memory, but MMIO can be used. We use
> pfn_valid() before getting the struct page that we pass to page_ext.
> Would that be OK?
It's tricky. If you look at lookup_page_ext(), it relies on extracting 
the pfn+nid from the "struct page".

If the "struct page" is uninitialized (e.g., offline memory) that cannot 
possibly work, as it could just give you random garbage.

(note that there are two implementations of lookup_page_ext(), both 
extracting the PFN but only one extracting the NID).

-- 
Cheers

David

