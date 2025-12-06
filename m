Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 099D2D3B7DA
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 17:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5900E6B0005; Sat,  6 Dec 2025 12:47:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540A16B0006; Sat,  6 Dec 2025 12:47:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42FD16B0008; Sat,  6 Dec 2025 12:47:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2C12F6B0005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 12:47:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7FBA133C00
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 17:47:43 +0000 (UTC)
X-FDA: 84189778806.25.C103C33
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id BC3631A000E
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 17:47:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ULqfgNkL;
	spf=pass (imf19.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765043261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axnvS5zVZLm16kKZN5PMooBxp95tE4LRRlIvfmIjaJk=;
	b=IPTi5xmR62vk0U7ezPHyyUmG4tPfCL2R0R+WaDIgMV1hg6esXW6gniGVqyqyPIHVipTzLo
	BiD3dP2oYttMtkDPnQFOib1S9uUs97VG+gW3Vqty45dZ+5CpXUfAgoLVvKBXsrC0LrtlH5
	FesilngpTicsAtTDCftcw+9ynm/e/sI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ULqfgNkL;
	spf=pass (imf19.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765043261; a=rsa-sha256;
	cv=none;
	b=OA5tp+zRyE0VuQW5vuWJtXHsgbVQoDeEMLB8fokNWlPqiDY88RC914iLy+3NwLLTG3zM3u
	XuRb+xr27nGEP5CIQ5YDxuBYO7Iwp+164hXSnjO4028wtUdVenky8Tf00YCdcFB+jq3FZO
	6/NbMSPjGwSlT+SVSGf+H5rtoSnKc0Y=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47118259fd8so27017305e9.3
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 09:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765043260; x=1765648060; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=axnvS5zVZLm16kKZN5PMooBxp95tE4LRRlIvfmIjaJk=;
        b=ULqfgNkLabRWvzPE0QiShlQK0d128VKLx13Ru++/yyww2+NqoHj9XAUm3MhXyCd36a
         VRjejte3kJNKGcI1hIldYBO3kQz/UVnT+oAbnTV1e+eIXnEF4ksN0v6OcAO+E3CXtIgL
         XNxA55t68ohekvI/tEAu8BR50j2Vt8cJCJdHpZCB52mSI0kDAbhIyDA92ZRlP4HQcIO1
         G8DNyipFOW/l8F55kvrhsDIJyGFVRRU1PJuLFgmlG0M/bYmHZmrQ1jHLliy4/jqp/oAM
         LCpWWe7Me815DMfFQmGykT+Vi+M+J0dkmEBpkknlNbqleYQIc04gKWzNT7qDlNJa1bKO
         6wAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765043260; x=1765648060;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=axnvS5zVZLm16kKZN5PMooBxp95tE4LRRlIvfmIjaJk=;
        b=ZrloGHsJWnxnSMuY6toiGOSxhMoqQJJshzjPXAuG3D0kfe8Pwk7pedZuwa2oWWJE6G
         dKNhvLEDRK6mc/Kjgm2DrdTVybj1SQhnBRgF1btHyPWsk7wNWgfUYz8gjyq/GU0MSClj
         5MZ15Nkwg4yS9DXRpaELR54+iLVa8CrUNw5sGqZ42QZhHwki92dcg2G3uHYiuIlIbrMl
         sceqo0Leo3wtGkuEb0QpydKAHW13rjlKqJeXm6jEoEWrLnCtdJGMQNWP/GpHKs3atfhH
         xVjp7mjNmqvLzKKOhHReMmR7cuT+4Asf1kha2p/5Y9apg/pDwrSMmELD8Qxf+wN0TmYg
         O8Yw==
X-Forwarded-Encrypted: i=1; AJvYcCVe3v3clslcI+k5U5u5S8vUF90dWnOWYLtASts7NcSdC+W/sCxIuxjbdJVX9Iehx0rJEogLun5wig==@kvack.org
X-Gm-Message-State: AOJu0YxJcZgc5hBjzBwh6uuWhCS+Szm0DZy7rVhpSb5BYLJ5MsaaYTwu
	usJEM/u+M4Y7ChtTIB9L44y55dTcKnMURB2pzSjwcnaK7MA2P7UojRxq
X-Gm-Gg: ASbGncvoixpg3p8DwlGvzHousKSLt/hEFf9qaIhOOQRG/1q0dw1W4PNhKlPyROLoQ+w
	3vjTslaOq2BdyMmnOyzCsw6DnZG/CfG18MMnVjpcdYG+d9dHlrEhowD/oAmtqHKEmqVAvmsF6nu
	GJWu943vtU6IduhbcAiQBUBEsMU2uo0m9+yOImNG4dQlo8fnPwFB0JmA8mtKj4+7sz3MdHyp/xq
	vAHIB25Z++cyk0YkKPT7afQGvcg11k/b/7jViECdc5j9cNaWsT62MNF1lMRj5X21r1dyFG1t4QM
	dcRezKUcv1sXmmh+sJg5MSxdXPTITDNyPXQWEKV/6rk7GcwxM4DSui8CeVEpKBfelp3mlmWMkLq
	+Fj6odLU1EYSIAVTC9jbNT7+N1f8HOphH6yjuUEckTppIyIHkQt3Qu4GT7KAz2IJDEv6yZumLPp
	Awszl7+ygo+KIkcRSzMYSwgNyMWrp0iH44T2RpAuIp7+4yeLue3UGCHcLY/Ja8aTIEt/4iZVxNO
	RKBGxM1RQng
X-Google-Smtp-Source: AGHT+IENdlC9ATk+qjyGaFVV0Sr7UOEmj9wx1lqsrnwLpmFCj2H673PTa7tMdOPqBH1ESxPCoGhK4g==
X-Received: by 2002:a05:600c:1393:b0:477:b48d:ba7a with SMTP id 5b1f17b1804b1-47939e4fe6cmr27937955e9.32.1765043260129;
        Sat, 06 Dec 2025 09:47:40 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e750:1800:450:cba3:aec3:a1fd? ([2a02:6b6f:e750:1800:450:cba3:aec3:a1fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479310c802bsm143938775e9.6.2025.12.06.09.47.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Dec 2025 09:47:39 -0800 (PST)
Message-ID: <8e59b242-6311-48a7-b9f5-e698c4eccd2e@gmail.com>
Date: Sat, 6 Dec 2025 17:47:38 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
Content-Language: en-GB
To: Kiryl Shutsemau <kas@kernel.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20251205194351.1646318-1-kas@kernel.org>
 <e1c50f7e-cec4-4676-b5d6-f6446cd64ba5@kernel.org>
 <bdie34dgpltxd5ayvjvqkusx4thdrrebgllvwp333psfuu4vgj@bkfxg2c5sfr2>
 <01e5d0b3-dbf8-4f77-b38a-f48c46f7c31e@kernel.org>
 <ysvhofzg5mdtvxfujdsmffkuqna72pr52ehrpglmlhxnvwstas@xurgptkgtnbe>
 <1b659d59-b1c1-4910-baab-0eef7cda234f@kernel.org>
 <3v5hdubqnil6w54kimvbgapghj7irjp7xuqma6uxtsrpvj22ph@6t47vsevdwyi>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <3v5hdubqnil6w54kimvbgapghj7irjp7xuqma6uxtsrpvj22ph@6t47vsevdwyi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ya7bzg1eyg13yd8hqtpys3qcywyqx57n
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BC3631A000E
X-HE-Tag: 1765043261-965241
X-HE-Meta: U2FsdGVkX19xvVOJNP/74gOOVgAbKcGue+ubPOotPvl4Icvg7M2Umam1hv6rLKemss37dsGn+IwTqxwQvoPzLp8PDiVXKeXmEaGSRk47dOkyAKiGv8Tsj62wNYHmlMxfn3+byj1P/jsjWUa4SGVva2zL5NL/88B5pNxEA+a0N6cCZE21sV6Crrp0QD9f7exIKfxzf/efSVAw70Qhkgi+WAPgq3rcVW1knKDzgBW435ssGIUBtLMq3Ek9/S+8hUYKW9ItyVevBHnofE0GTGIi/g6kyOul8p0IlCfIab4wiM/ETPpH4chHpXUKanHEm12UZoQ+F3Fo/1J+8OBSeIk/HzEpLpRHrQ8/HOpTvBUh/e9/MCi+XZRtXF9E+yoq+63RfwDe9Zm35LBnf5BnxPF7qq8fzNYl9FZ1I1cv12TW5T2TTyFSbEJu5keOrUmGsslI/3o5OU0Y97G3gJ18MZXaAOALQXz3V+lQM9IxTnDAgFML81iHQYUJ8RKYK839btpr2v3OwQfhzcxR/WG2UB2WXiunMlU0VvLM5lZePV5DzPd4cOoSGIXpL9SCb8F0QefYm01gqGwwk4PQ7BJQuz3znhj+0eDf471ZQibxeMJscL5d5QvHDqN6MpY0JPV5ldxXRVm4OrAEPPVzFjz6mN/UK/fbmZdRNQbFh3qBJU+K5dnJEvvj0LSrQcFS5iDWfJ1K8PfmzAlYCv594HvYn+IzuyS6P/y8U/z5Hpe3kzXa1XUYNTNQY0eI67CHS385xBZZdAvV61ARCqf22pv7Ib8U8plRP06wDqsSseH46l/qPUE9eqsnNBCZUdkFyRugMiqfQrOo09BorJO7vzaD+zhz6qekhUdQEznqrtXmXObaYQ+S1bEYK9MX1NjsvvoVlq1ANTyxNlUujdGJWHjD9kwVdAK2ixd3RCBDl92SRUdvLclZWV16V6mff3eZph7dzPaK17Cqqj58VQl5Is3Dvgd
 LDBV4yhf
 RcjB/mAB/HxcR5oxOvGF8iggQX2UDYlYzwSE2kSD4hy7AJQHxwrTmMdEsAclLq5fmVYe7JmlLaguCACR6mAgnMKPiGvJX12WIKAIoAaxcCfUu7sDJD/EUwduQQ4/iaIpPt+AQqXBlSz9Y6H+fXVYyFdFYRE4eaITgZMzKHL7OSEsHXyzZRIhlO7sDdHOmqiqeueC2JNqmx7nOeNfkyM+KmNqUipUUIeBJc/wgU4TlJ6RPLxELokF0DDiQRxFNHNDtFhQEv4sRFbUe+Q3gENKZxS8EJFlZkh4uxwnrickn4PKyNYsYJxEZcLrgY6Tk6fLIIU+mbjP5CuqrSrhYoFpQdiY+qRVCWfwrhScjXecM8xVAZ7Umj5mLjrwU2b+debuW4FeqRSzzDBAczf6VMW1UGhoWOLxkzYePtsUi2tn74n6blWpyH/BlWClaSVV6TWqfyzorYTQq/30uLKkbtqEiQMw9sbFlc7pFz3gUk41x3ez5qs+usb5TCQA+jv8J4o57Mtdi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/12/2025 21:41, Kiryl Shutsemau wrote:
> On Fri, Dec 05, 2025 at 10:34:48PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/5/25 21:54, Kiryl Shutsemau wrote:
>>> On Fri, Dec 05, 2025 at 09:44:30PM +0100, David Hildenbrand (Red Hat) wrote:
>>>> On 12/5/25 21:33, Kiryl Shutsemau wrote:
>>>>> On Fri, Dec 05, 2025 at 09:16:08PM +0100, David Hildenbrand (Red Hat) wrote:
>>>>>> On 12/5/25 20:43, Kiryl Shutsemau wrote:
>>>>>>> This series removes "fake head pages" from the HugeTLB vmemmap
>>>>>>> optimization (HVO) by changing how tail pages encode their relationship
>>>>>>> to the head page.
>>>>>>>
>>>>>>> It simplifies compound_head() and page_ref_add_unless(). Both are in the
>>>>>>> hot path.
>>>>>>>
>>>>>>> Background
>>>>>>> ==========
>>>>>>>
>>>>>>> HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
>>>>>>> and remapping the freed virtual addresses to a single physical page.
>>>>>>> Previously, all tail page vmemmap entries were remapped to the first
>>>>>>> vmemmap page (containing the head struct page), creating "fake heads" -
>>>>>>> tail pages that appear to have PG_head set when accessed through the
>>>>>>> deduplicated vmemmap.
>>>>>>>
>>>>>>> This required special handling in compound_head() to detect and work
>>>>>>> around fake heads, adding complexity and overhead to a very hot path.
>>>>>>>
>>>>>>> New Approach
>>>>>>> ============
>>>>>>>
>>>>>>> For architectures/configs where sizeof(struct page) is a power of 2 (the
>>>>>>> common case), this series changes how position of the head page is encoded
>>>>>>> in the tail pages.
>>>>>>>
>>>>>>> Instead of storing a pointer to the head page, the ->compound_info
>>>>>>> (renamed from ->compound_head) now stores a mask.
>>>>>>
>>>>>> (we're in the merge window)
>>>>>>
>>>>>> That doesn't seem to be suitable for the memdesc plans, where we want all
>>>>>> tail pages do directly point at the allocated memdesc (e.g., struct folio),
>>>>>> no?
>>>>>
>>>>> Sure. My understanding is that it is going to eliminate a need in
>>>>> compound_head() completely. I don't see the conflict so far.
>>>>
>>>> Right. All compound_head pointers will point at the allocated memdesc.
>>>>
>>>> Would we still have to detect fake head pages though (at least for some
>>>> transition period)?
>>>
>>> If we need to detect if the memdesc is tail it should be as trivial as
>>> comparing the given memdesc to the memdesc - 1. If they match, you are
>>> looking at the tail.
>>
>> How could you assume memdesc - 1 exists without performing other checks?
> 
> Map zero page in front of every discontinuous vmemmap region :P
> 

I made an initial pass at reviewing the series. I think the best thing about this is that
someone looking at compound_head won't need to understand HVO to know how compound_head works,
so its a very nice clean up :)

Would be nice to make the commit messages more verbose, and also maybe add more comments about
why it works a certain way when sizeof struct page is a power of 2.

I don't know what the current memdesc plans are, so cant comment on that part.



