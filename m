Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 287DBCF45C9
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 898216B0005; Mon, 12 Jan 2026 14:12:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81B836B0088; Mon, 12 Jan 2026 14:12:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD7D6B0089; Mon, 12 Jan 2026 14:12:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFAF6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:12:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF092140AC9
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:12:02 +0000 (UTC)
X-FDA: 84324256884.24.C525A46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 20AFCC0003
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:12:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X7B4ifj1;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768245121; a=rsa-sha256;
	cv=none;
	b=xV8tnLYcds8gNKDRqbbcBZRzp46pbzllhWUeKsferuWdehluOEId1S26ad5UZgGNmB9BlN
	EjLxCSIEaLJU25xMMUXTXbrf/B1vttOOWVULIyHlVIdw1Y9F0pDiTTwYxrGq+GaBq14NS1
	6XGTQUCjx3EPVwpVTz+AWjlH6fZr94w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X7B4ifj1;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768245121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CR25MdQWLL6cMKYz7Z+plmOJy4095xyXcq5fRdd28u8=;
	b=ZYVHHRaDpq5aHdBscpLOrMoMFQilHAMvJ6259NfvSgHbTjslJdAvFcQDyfpqkETBW5TGvb
	T2yOB+oyE5qsYqNFfCJ1CNalY47Q6d6fsAYU27JBbfCDQQfj2X80sgssjNn16MpQF4DQKC
	KIMbe0Ql+UCORumuXpUGNw/3zgK8ZGI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 102D243AC3;
	Mon, 12 Jan 2026 19:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0584C116D0;
	Mon, 12 Jan 2026 19:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245119;
	bh=XcipN9fgKBFHcgoA+Nr6po6gwNQSSLcIPx8c1aOF+XQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X7B4ifj1p/c3HLp/4J2+Go8rjUoBtJGV50vA4sipb6J2chKy7E3TTr6yBwz6jIjNv
	 y4MSvXhaziqYvaFOUgyptnQX32PjVB9WqHHzw9/7lrcV7Z8Sel+08VAsiJ/M4VBYy/
	 +QnWcc8DoF+EAqCa1miLOe3TDQNDd2SKy6GdpLmb097XMRJ72uD3mNOgqah76dtjwq
	 Sv6B0s1LDNgEWBsU+ZdAxlXXozJ6aaQX1YtyKgKbSvYLcIUhKxTRXbE/tqjU1aOJsH
	 33mmqNurBRMC4Q73SgJyCnLQDkhQcQ6rgWEz57BZ4fQvIVplMKiWEyNwRR2nDJx039
	 m4i12kKYmQfIA==
Message-ID: <746f5adb-1d91-4ca2-8ae0-a2d171203b66@kernel.org>
Date: Mon, 12 Jan 2026 20:11:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: Mostafa Saleh <smostafa@google.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <CAFgf54q+9Y5TtGJDB=8q_BW-0F=TM7zBbCcMzvtvr_N2WMnd-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h8d5o5nfeg53ytf5fxzjjfqwznz6fcyz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 20AFCC0003
X-Rspam-User: 
X-HE-Tag: 1768245120-283621
X-HE-Meta: U2FsdGVkX1/QTS+rXgkGQ4g3Jum98uXyCwdnXF6nbDELX/I2+p0CG7naUX2NOTlNl8sW6EVLmWOBOetzILC/7PC3K34ck2nVOx6vwJqZut+NSnl4K5JR4Gu2HtS9BVY6UBHFfapVZ1vOvBvnrwfVf3+GzsHhQWQDYyP4zpEkGM/ADnTWeNxMU/GBujw9YTgQGrp5qJM3XauO0LiGWHTSfE6SB8iqlEjv6K/aMD6CLuXI9/Z1ErnRp9bu+EycvGS47Hx7bgLAzzyfflwGXdAkLZBr+13cU1pgskyHW+gDLHfM7gxLLaQvJby1P0U/dL03rOu4voeGbRMJqtQC7AmIwdnPU/2dck2SQX26wipXqi1E1fd116fMVF6R8ILyaNLQmLY5cwuJpunqsnfud43OMBojA1abSNnTkWL5CO5sYolY5uDisYzXtiGHa+g2K5E3eSN4mxP50eVPXSH18+aJSTQZqZylNCp1KzVbJgSZ3RABAoEV5qy6+pWOPWhopPhuAGeowGeMgpMUuwNflLfYLiLEriS89xFQIb1fAaQCNpsea0ZgGKKV1B5lNLxxgNAGAAVGixS/1C3qA4/d4t9OJgfqg4RRaKFc02qFQPT7ryP2WY/2JjDGB5KHof4VBIN93zWNr/a2yGYc3U5D2IPJirgYbggCvlEJfptjEUAYkjQ1rFG2NCsXTX9I7cznEI77+6njSWczm5JIceV3MjHzSFxS5qoe+Q/HX0k52Y195iBgKqeh08/XwJvLTyA2t2dMv94fyl8UuH0FB4rY51O7/JuLnmMNclaHWVRqIfOjv1xZXH6BP3Lf6MKj9ERQ92rLuq7yofBlDbwd7rMsLRcVfAifIl+51J/5lUx9Rrqf7WfuFJ5KFUyHKgMA3uocu3aNEVU3MiysrhoCzp3lel+QhVp1WWvi6RSaRZ9Ali+54iSgAoVh6aQLug5O3SKJ5yxlUFpYjL7Yi+SsxOdcmIJ
 On0SVFM2
 7T/4TWpqbR2KUA3UJKkPyTZIT1pjZDGFoVkQQTfdVXvU9kbVPiwCxdFCpFRWF681od6TLURRL+2EV+5QtcJblh0Vg1VClGq6MFF6gaUNgTxSEfRjaY4Ba2d8FZz2xWtwC5yUCtykTuMg2rxDidlnBjDFoC4OtiHUpDMnJiJHBoTOMd+8HZ8NWKs5uHNnoUliNvDf/0wUsiuU0sQR7KvDB6Vs7f+bWCp8X/+jk0KylhggCeglDqLfTTdWRLABEpAqeErxMIwdPt2G6PWY3VUqTF4u8aB6jfSxWKlfFNkMjc7fjyoZqHDmIntVMTgBCJExsvjtb8ZjeCcz7I0Y9H7LJc+vAjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/26 15:58, Mostafa Saleh wrote:
> On Mon, Jan 12, 2026 at 1:52 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>>
>> On Mon, Jan 12, 2026 at 01:43:41PM +0000, Mostafa Saleh wrote:
>>> But I don’t see why not. from the documentation:
>>> /**
>>>   * pfn_valid - check if there is a valid memory map entry for a PFN
>>>   * @pfn: the page frame number to check
>>>   *
>>>   * Check if there is a valid memory map entry aka struct page for the @pfn.
>>>   * Note, that availability of the memory map entry does not imply that
>>>   * there is actual usable memory at that @pfn. The struct page may
>>>   * represent a hole or an unusable page frame.
>>> …
>>>
>>> That means that struct page exists, which is all what we need here.
>>
>> A struct page that has never been initialize shouldn't ever be read. I
>> don't know how that relates to page_ext, but are you really sure that
>> is all you need?
>>
> 
> AFAIU, if pfn_valid() returns true, it means the struct page is valid,
> and lookup_page_ext() will check that a valid page_ext exists for this
> entry.

Not always. Offline memory blocks have a memory map but no page ext. We 
allocate the page ext at memory onlining time.

Also, I'm not sure about ZONE_DEVICE memory, very likely we never 
allocate a page_ext for them?

I'd assume both cases are not relevant for your use case, though.

-- 
Cheers

David

