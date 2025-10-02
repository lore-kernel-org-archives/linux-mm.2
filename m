Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D168CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A08D8E0006; Thu,  2 Oct 2025 03:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779278E0002; Thu,  2 Oct 2025 03:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6673A8E0006; Thu,  2 Oct 2025 03:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52F5A8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:45:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E37311A0393
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:45:46 +0000 (UTC)
X-FDA: 83952389892.30.88889BB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 85B46C000B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:45:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RUOD2yIr;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759391144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SP/dY3VkQHLVxg99pk5ub4ghhIabgLfHHyUzpk8h1d4=;
	b=DLx2kJwyUpGo+4FeHbTvwEfVk8qNlP2dOCIZMhER0s9tEqrssou6hzl7jXZfphL83Fs17z
	A/wJFs/KmRC7/1TPNBsEC49xxh+0RirGK1ZGu1x7lgjZxd/8hylAEoBOn6UzukMb0cdoM5
	dFwr/y6DBe4EVoNVQzp8hSfvTdDmsZI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RUOD2yIr;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759391144; a=rsa-sha256;
	cv=none;
	b=uuCYAOPu6MSf4a+bNtwhpqfikw/tZDMyICJuCfoez3WHPs9Sew70nJsbvvgxyL0ekbtyZz
	60qOsV6ewUhuqZIxrFMayvE961sGajjzV+cDOBXC2NEVjjVHt8eY4C3esjhecxbP9e3/ne
	OP78ezBl5AoVLo7QByCMmMQcGNvIHkA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759391143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SP/dY3VkQHLVxg99pk5ub4ghhIabgLfHHyUzpk8h1d4=;
	b=RUOD2yIrjC/SApcqdQP7jg+UHb558dTLFzN8ojpxHCDkE06kyvAz7LwLGvAY536lzqowu+
	JV+NdnSE/eiFf6i9e/t8tUFuuKs8CMeu8vXEGUZhKjOKuhR0SF23BpXqNVzyNnNjqBBes9
	ICtUVfFUoNuhScg8MaELvSFsTV/wnJ8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-C_Gl1ka4N8m5HvayhqkVdQ-1; Thu, 02 Oct 2025 03:45:42 -0400
X-MC-Unique: C_Gl1ka4N8m5HvayhqkVdQ-1
X-Mimecast-MFC-AGG-ID: C_Gl1ka4N8m5HvayhqkVdQ_1759391141
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e375dab7dso2432295e9.3
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 00:45:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759391141; x=1759995941;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SP/dY3VkQHLVxg99pk5ub4ghhIabgLfHHyUzpk8h1d4=;
        b=muhNtxfo31PWBQgCpbXhXobyXiuiQGfNJpdG1FfmQY/OB4G0Pmul8UDrC7Kx9oaHSH
         QQW6Mozkml/CmvcWY4xqCIkOKU4zp9al1hiCTjJRslHWZhFruNTHRil0jhj0rD7fWvMt
         JsLFNuML0NyC9nsQzFfxHdah7dYnITVdHNPSoLvbXgT3VZt9JO1tXn+wLDnmxJNixl+P
         KO1AMqzCMMdoNrOJaKMEMxUWkSk5wMSajoFVKwrxzGwnV1RhRtdjgpw1LQ0MprDLoWRj
         f1GH/9/B2eUvhcXMFoBb7xjxc7geFTo/EOi92i1eNtLkTQRiA27A4kHM9Hmh943zcgxu
         G+dA==
X-Forwarded-Encrypted: i=1; AJvYcCXJeKZ1qeDmBzMero7x7r1Dmcf7KwOZZw3V7FHbqYhB8xlvmSJ8mw3uGNvnlRQn6vgvT8pvKLNoFg==@kvack.org
X-Gm-Message-State: AOJu0YxstbAR6qkTnNut+u2u0T8DF8VnLUqwbXyP8EDKypF15iWWPSsO
	FZbk5rQIraTOR0VFtX5ybVnxS5Aq6Lmce/aEUbjMzHNQRo7/2ofporgpVuEjk4JjS+F2A38AZ/6
	2nTqced83MzxPaDV2ATQaEvfncZIMoQbrdVi5IviQAmEaFlwT1+qX
X-Gm-Gg: ASbGncsw90Zpm4dK9kA+SNriHAKvsUS9PNnyyiM7wtMQMgu4gIzqd0NmovAoViCzdtt
	eSb/0KxsUyqOj2sLvFaBweB2K/g0t4kwXgXYsUzyDa9pjXUDEf6E2JVEoO5EEGOKElXyBlVn4TJ
	lMWtaSXFY4HlHhzUlCamMgTQvp/wUeJTm12u0ltPR+vfNLMXL3zMyQb3axXNTVLls9qDdl6wbzj
	/i6PwsxXn+WmwYe1CdRKOklCsTc8cbNPRTxClx4LnT5+23Uk9MLt/+ZOyL5n+JbJkn2V6cekJZI
	9yGbw5RGiSccdILEEWndgoQaLvEuX0XPOMtT5QZgDO1NM/1fnm84SKH5bUH5zGjQYh0HF0Qm0oh
	g4UTKwAmr
X-Received: by 2002:a05:600c:8889:10b0:46e:67c8:729f with SMTP id 5b1f17b1804b1-46e67c879a8mr16420515e9.7.1759391141409;
        Thu, 02 Oct 2025 00:45:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtg0CUJ7svXVqUDtw0OZIK/6abcmBaw177Cf33RxxgmXLfoTe+SvEZlnZfZl5+aJi+r0Tu6Q==
X-Received: by 2002:a05:600c:8889:10b0:46e:67c8:729f with SMTP id 5b1f17b1804b1-46e67c879a8mr16420215e9.7.1759391140974;
        Thu, 02 Oct 2025 00:45:40 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e675c67f7sm21440265e9.2.2025.10.02.00.45.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 00:45:40 -0700 (PDT)
Message-ID: <44082771-a35b-4e8d-b08a-bd8cd340c9f2@redhat.com>
Date: Thu, 2 Oct 2025 09:45:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Discuss] First steps for ASI (ASI is fast again)
To: Brendan Jackman <jackmanb@google.com>, peterz@infradead.org,
 bp@alien8.de, dave.hansen@linux.intel.com, mingo@redhat.com,
 tglx@linutronix.de
Cc: akpm@linux-foundation.org, derkling@google.com, junaids@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com,
 rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
 yosry.ahmed@linux.dev, Patrick Roy <roypat@amazon.co.uk>,
 Zi Yan <ziy@nvidia.com>
References: <20250812173109.295750-1-jackmanb@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250812173109.295750-1-jackmanb@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aCsh2dAKIABSC9TfkX0QmjYabs5DrD0v79Dcb9godwM_1759391141
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 85B46C000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4whbjeortuhjzp6758tqag1me4ygwmcp
X-HE-Tag: 1759391144-170046
X-HE-Meta: U2FsdGVkX19KBLq+/Ktk6/WNzk1IGLG4gCxm4A0umUrepsghkjD+mNryH5w1wlMY3RCcfn0ct4G+bfScVPjC7SI1km867KOQJAD3rtqT3FMsR0gazTMTBcv7/axmLZEFWPvgLcw5qWCNSsLXRWvZhQQ4cmgKIrFYqktS2UVh1ogLrDodirNStjogHbofkCvY3dJtPm1KzfZYb0Ef7FuzDEVYgf7BxK2cslqsAIaacK1WnBV+6SMCX/+Ck7spZseA8YxmkLQ7XtFZUxKjBN9tpWo61gJc+ZQsdBJnRYNFMIzwuAhvic84MDQLmC3s1rS1hkxqWIX3ChSY2jdwqh2NRs1RNbRGaDKGkQCe+Z+WwwQG47B6jGHGBPzxzOmsLQtc9+a5BZBjBIzTrgm3OJKHNUVo55iEnS/I6COgSbuilXezU7ar9RT7/HrFyWgHeAYXOhqbXvBH7vr30bsRGTt0/aE8Ny0gcfJ5Xc7dRtKBHMaQ6z+omEB7hgp7q+9MzkTLEqiAhyrl2ZaDSiq20HRIA5Khnn0ObwJf+zIHLiU2gpCe3s9g1ag6jXAQ4SOb5ux4YKe3rAsIPTYmBknMbFWNPCApMxpwAKo8DJO0YTMYpWXOJHEBLHXlmt4cf4fQvw4UwHx5eyv5YpIEk5QeqK5MhsuixkaJMlzDIhrkzlLYzsRXaT1ZbfoSCT5yHMdvhaEzQExSi/o4klWTh+s9oEGPiWHzpVB7WCeX2/RvnNujAx3lnGtDvnBoTgMeh/vtlgTw4Mp6tr4287QGY1hffWvcPSSEetQL4YTN/LaD2j1isOZOY4nbf5YxGhbPnmAHhie5Hm2n+PeY1NbpLk1hdKmcZFdWEpbvlOWqi8M8jAnFHMe5tJE86D1sSy0i/jWB2sQwhJ6Jrg8KP/sksN9TKzrTgBW+7FjYFDB7LGt2gPxWJ1LljCkPLhWhToabsupj4iWX5NVJ6G57/l2INe6LqK5
 EWZohOcJ
 OdMb2pwsCDM2ffiqFsQMMRdGLCWGCehxYHKgb64asN1mS7kWgZi0vh/+xUkRNevpdnTck1/TVybaYuKobX7LIxLEvF8fAPCjvzn0fWQiUQZFbJnQUmXjFlkOiCP1g7pxIfbcp7KHT5WokVqPJLb0IRjv246/ikcBkDw9yLbBWSjyB/XLkCiSfORVsY0YB9SF1si/YPN233vp45S9/p1fi8yCxuzcLEiLZm3ciI9e8d5wdZ3YgP/kr0vrTacD4pKxflmsho7WPc+XjMYZQ2ZVabrzVEDQldaTfoCT0nK+7sGONW7QuesCCdDl4rnkp54Nlk9Q2CRtWVA+MDaQ/PiPo7bKm17vKtkMMslN8/lvZo9/tQPUGoibTSpQIZV6HrXAaPa/S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I won't re-hash the details of the problem here (see [1]) but in short: file
> pages aren't mapped into the physmap as seen from ASI's restricted address space.
> This causes a major overhead when e.g. read()ing files. The solution we've
> always envisaged (and which I very hastily tried to describe at LSF/MM/BPF this
> year) was to simply stop read() etc from touching the physmap.
> 
> This is achieved in this prototype by a mechanism that I've called the "ephmap".
> The ephmap is a special region of the kernel address space that is local to the
> mm (much like the "proclocal" idea from 2019 [2]). Users of the ephmap API can
> allocate a subregion of this, and provide pages that get mapped into their
> subregion. These subregions are CPU-local. This means that it's cheap to tear
> these mappings down, so they can be removed immediately after use (eph =
> "ephemeral"), eliminating the need for complex/costly tracking data structures.
> 
> (You might notice the ephmap is extremely similar to kmap_local_page() - see the
> commit that introduces it ("x86: mm: Introduce the ephmap") for discussion).
> 
> The ephmap can then be used for accessing file pages. It's also a generic
> mechanism for accessing sensitive data, for example it could be used for
> zeroing sensitive pages, or if necessary for copy-on-write of user pages.
> 

At some point we discussed on how to make secretmem pages movable so we 
end up having less unmovable pages in the system.

Secretmem pages have their directmap removed once allocated, and 
restored once free (truncated from the page cache).

In order to migrate them we would have to temporarily map them, and we 
obviously don't want to temporarily map them into the directmap.

Maybe the ephmap could be user for that use case, too.

Another, similar use case, would be guest_memfd with a similar approach 
that secretmem took: removing the direct map. While guest_memfd does not 
support page migration yet, there are some prototypes that allow 
migrating pages for non-CoCo (IOW: ordinary) VMs.

Maybe using the ephmap could be used here too.


I guess an interesting question would be: which MM to use when we are 
migrating a page out of random context: memory offlining, page 
compaction, memory-failure, alloc_contig_pages, ...

[...]

> 
> Despite my title these numbers are kinda disappointing to be honest, it's not
> where I wanted to be by now,

"ASI is faster again" :)

> but it's still an order-of-magnitude better than
> where we were for native FIO a few months ago. I believe almost all of this
> remaining slowdown is due to unnecessary ASI exits, the key areas being:
> 
> - On every context_switch(). Google's internal implementation has fixed this (we
>    only really need it when switching mms).
> 
> - Whenever zeroing sensitive pages from the allocator. This could potentially be
>    solved with the ephmap but requires a bit of care to avoid opening CPU attack
>    windows.
> 
> - In copy-on-write for user pages. The ephmap could also help here but the
>    current implementation doesn't support it (it only allows one allocation at a
>    time per context).
> 

But only the first point would actually be relevant for the FIO 
benchmark I assume, right?

So how confident are you that this is really going to be solvable. Or to 
ask from another angle: long-term how much slowdown do you expect and 
target?

-- 
Cheers

David / dhildenb


