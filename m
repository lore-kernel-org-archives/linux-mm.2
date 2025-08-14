Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B3DCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE89A90013C; Thu, 14 Aug 2025 06:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97C8900121; Thu, 14 Aug 2025 06:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A877390013C; Thu, 14 Aug 2025 06:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98374900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:37:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F13FE1605B9
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:37:00 +0000 (UTC)
X-FDA: 83775010200.29.5C3D91A
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id E5E8440011
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:36:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XfjqPqgz;
	spf=pass (imf12.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755167819; a=rsa-sha256;
	cv=none;
	b=MZUQ+WPXEGWg95OSilcyA8bSzR93FjN/7192OpXlEjlqj3G6IzZGGsiSy0ZJPiN+iGygH1
	PkWJgGeY1+WXXINO2AIk2En49sbBHMs7ZtzLdLAnMeSA0Zn7R93pFl+4LaqQzKlmKH1Nq6
	F3VZ6bZX5P+nKNINtG6MVb163UmpfwA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XfjqPqgz;
	spf=pass (imf12.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755167819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZ6gQfT6325DrhCJg07rbAmAUq49pVA1Mr8s55Uj+I4=;
	b=bCIwA+k9JQDF4UMDh0xzLu0VdvGro47Bk64xuIpaNHL40wexk0PaaAxKDyia9VI1BRgcfD
	esWo+ESJOBgE1cNr5A+KWn/ClBIekBpK3/iFCJXvIVHD72kByEIL7n1s07J8f6+Fk5wOeV
	1PtDb5SSqqxQsjwaXH3OSpOIGoOxm8A=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45a1b097037so4304735e9.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755167817; x=1755772617; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QZ6gQfT6325DrhCJg07rbAmAUq49pVA1Mr8s55Uj+I4=;
        b=XfjqPqgzHoRJN4/3RxEUnm8cSkDFb4bTzBXBfrY8abbaSdwo3f3vxbI5lGytSM9xQV
         udKVb3/2XG+4Erw+ywCrxjBk48GpE0cwPrV1GbVrZaRH7m8J9cTJmo6siHkjRP+ff/3P
         jwRxjbCMluE1zs+gfh57RRWlurKwG2pkq/HyYlg6T0CkSt1Z7K7ql32VtaEwKxvOgYJd
         6L0bLTL8mtZdGWm7pHmbP4l/W9ArOS5AJPjK33agw5GhUhHI2E8bLPMR7boduz5AXe7d
         r2gmPm5pTIX8vjhr1//E5Dmt09EyF77m918PWc1YS+FZCF7iN4zubCLChvLcekr4Mvm+
         zx5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755167817; x=1755772617;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QZ6gQfT6325DrhCJg07rbAmAUq49pVA1Mr8s55Uj+I4=;
        b=bT3BCwkxXU3qkwzY0G1eOLKkRruV2rrplFF8S/4zifeVg/MX3nb8L+sGkw0Ha2XYgl
         Jlmzz+2M2b3jJiheAZSPgwj1NtWAlwDFnYMgqCUPUYsU4XmGoG8qB3m8a8SAURJ668Hm
         Po4t+qPF/Of1vRN5YjP4X6QtJSteNbiFoHHwI78+pLPtwE71cxWxpfZyuWRxOa9SXLGK
         I7QaQrdJGtq4YVXNgDfkzWe88oZX2diGaaTZGjNr6i/6qMbWOKD4xQjvaelYxGE9faec
         0dhIJbh7zB334e3lr1fGb9ZRrbi7xB0eJX+7XCEfFmY8fVMINBPIV5hBGbVUkgsvhH0C
         NsfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsnZJvWXKNB1C6HNi9JMj/j0e5OdUd9IZOHOThuS32+yhYHW3509RJnJ2uuevQx/Y86pZie4jDsg==@kvack.org
X-Gm-Message-State: AOJu0Yzljnw4KssO5DZSwplfgkmtFrpnLPRq9sOubc5ptKG/mWYlpwE5
	OGCKfVhzGTVI+OQYZS8bgXWPI7VjNquIGWXYZyvlnZz0emeM/MLqI6xmXAxrrz3c
X-Gm-Gg: ASbGncuC9dwOEGKXDLMwvqsdDVL4vdOMQ5l5IoOyRJ6o+Mt4fEh0Y9mN4DMzaRmoE7W
	a/spZBqHffjgL4ZzPa+Eo5mVpCJSYsCvefWqLkoZWzxReBTG6MTa0Yy7jz34ZBoBAkGWysWYScU
	qvnnDpLPwzfhyGeOAxSOWdC63Cwn6YFhSnBPpwIX7TomCCq1pC7lVClrM4O7fVfSKiPri7OWZF1
	mI/jAH0ZCy0GtqJwF38gWCSMuHMuPdL3ezOSnieD4IhA+JdgFmafmjdvxk0ASSXGTeJ8GLUPZRI
	r9yOYEa3nOckPFoRxxOTF3e5FkuOXKh8B0m+x1iuJq1dH2+QqooT6g/RZ6ixMXWdCmwWUyEpfVa
	/cgmOWccwV263g05e69NbpIEQ60+IhYq+/nDJbSY/6OTM4ME6TstLMMvZpwCmIifXES3Fdn4=
X-Google-Smtp-Source: AGHT+IE9AwPEDaKR+KjejS9PbwUO3RCQq0PbGo95Hon+5KFFW2EiEVkrk/aM+Rydn7mH+KdWdrrzhQ==
X-Received: by 2002:a05:600c:46cb:b0:459:e06b:afb4 with SMTP id 5b1f17b1804b1-45a1b602f28mr21995305e9.4.1755167817082;
        Thu, 14 Aug 2025 03:36:57 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::7:8979])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1ce9758asm14558735e9.15.2025.08.14.03.36.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 03:36:56 -0700 (PDT)
Message-ID: <1ff24f1b-7ba2-4595-b3f6-3eb93ea5a40d@gmail.com>
Date: Thu, 14 Aug 2025 11:36:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] selftests: prctl: introduce tests for disabling
 THPs except for madvise
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
 <20250813135642.1986480-8-usamaarif642@gmail.com>
 <13220ee2-d767-4133-9ef8-780fa165bbeb@lucifer.local>
 <bac33bcc-8a01-445d-bc42-29dabbdd1d3f@redhat.com>
 <5b341172-5082-4df4-8264-e38a01f7c7d7@lucifer.local>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <5b341172-5082-4df4-8264-e38a01f7c7d7@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E5E8440011
X-Stat-Signature: 3nsygmppk8cca1my8szyfarw3c4gbd5q
X-Rspam-User: 
X-HE-Tag: 1755167818-997696
X-HE-Meta: U2FsdGVkX18/QHVA0325ifyYYnnT2GWAVCHKwc/QZXQMyKLolFDWUUqCaBFf4OvMAAVeVKKKjbNdjEgBQt8eePI/dYSn/0O+i/UVGnvPTxcVfg8l88o3pqXmvrQNTxkzg7eYilpGMZq34XbFwsJ2a1IoB0i1lagsWN3SyzR/TYsXro+rMsc9U1UbetY8H1+bTR3JbGP9A1lnRhFsffhimJnoLpc0H4+GGYStVyZED394kxzMD1fN/5hEQeVD3+XfpmcVwOJ6wD3NNKFTf0f9F+XksF/LR9cBGzgkDkMxInn/x4oOMXFuRrDGJNzQR/aAdIHuu+aGOICRHXNYxatoHwBlXx07CdEDdtvqIX+Jb/nIAsS7HITlSxH91ph3pIF0f2y1E299V+coCetVZ207Pu4E3IUHhAL/rCg+L2Ij9D+MwujEBJKTSUr/a5hBekdwY7zezpRjgYN/no0Y+mvUcOcvAIoSfB6zeUNBd97T6lsY4wOK0PjRSR7VSOenYvZ+FJiMLq9AkiG0NlXczzkmpxVLUdhsaT+f57m4wqlEReFsmGjl+f8GESQ1pP+zLCphkH6inNT7Ft8mKRXdgJcqe7tfCOYT19Ab1D31qIyQADxjJgfMAlqQQxmUy8OvetFj/PExfA/iq0MIvQ47ZWp/blW345x2FFi1kN9zSqmW0/O5So1n7vJoG9x0M1a20RCIN/U+KgrIl8PaM8o+joFI3RPndojINV1pR5LsudYyiuypKACon6QMMg5bsoL5hZOklizgplLDolXNUnDca8YY/0vXO/pfGsDWphPfPTqTo9JCkJ9/34qU+lYdQ9SZChSYC1p+Iy1LmwoE9cmHp877J7KkZu4uNxEOny5u00NWbANeUzHafFvYp3ihrH9auZLZgkVY4cTQeSOFYKlyKSu//TdnOSfwSacpAw+Z2OZOASYuO5DMZA6iXUa7GueTh48Pvn3dFomvx3ESRvok9I9
 AjElDQib
 ArGDmJ0AwxCEUvCkGLhYHTngW4s228d0x1N4cnVuxzn9C2nUG+xgX+a/KMt73Fvp/RaeKE0UGa+6Y4n7RPoNto+y0TwJrTMBbdSm4NcLW3yGLRjvQ4FHFe6dleszZGXTa2rIWR6LTndk3sZQoK/zNdQ0n9tVfOnyIecFaBfJPWdAQ78xiBDP3XknPdKmD9+qSyZQ5kj5Tx22VXJVofeSq+L1ICiIW75vAxOateVy74DK3NsvbaBr1ImFHqMd4LeUyLvdtVlbkjEiHvpqw588qK1FYvDT+zHKEEJrqBfburRQ8SEDHAAx9Os9kuzUsk8H+wIEoy8CXOAF+rw9esHIPI1pwfdnNzWAfVFtq67EItI/fG99sVqxH5Uaarw+HoP/VLzfeeWpD3K4gj1T4Jk1m3huWbm75BQ/ID683N7d7T69HEoXa8M9BoVGBs4wK6PMjdlEhtE1S00oU89LtZqaZSWUUshA9Vn7rgNlOtOXbYrJD6FGsxGEacX1NanrANCZWHOgj44ywvaJILB4UlvrBa4rg1ahus2eBS3bb5K3a/sED+hjSJKK4toivmpwc1YTZPAq+g4BIlE5LVnmYf6w08tHCi0CDlft8s/hDIgoI+w/U6X5FZXYcF19hcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/08/2025 19:52, Lorenzo Stoakes wrote:
> On Wed, Aug 13, 2025 at 06:24:11PM +0200, David Hildenbrand wrote:
>>>> +
>>>> +FIXTURE_SETUP(prctl_thp_disable_except_madvise)
>>>> +{
>>>> +	if (!thp_available())
>>>> +		SKIP(return, "Transparent Hugepages not available\n");
>>>> +
>>>> +	self->pmdsize = read_pmd_pagesize();
>>>> +	if (!self->pmdsize)
>>>> +		SKIP(return, "Unable to read PMD size\n");
>>>> +
>>>> +	if (prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL))
>>>> +		SKIP(return, "Unable to set PR_THP_DISABLE_EXCEPT_ADVISED\n");
>>>
>>> This should be a test fail I think, as the only ways this could fail are
>>> invalid flags, or failure to obtain an mmap write lock.
>>
>> Running a kernel that does not support it?
> 
> I can't see anything in the kernel to #ifdef it out so I suppose you mean
> running these tests on an older kernel?
> 

It was a fail in my previous revision
(https://lore.kernel.org/all/9bcb1dee-314e-4366-9bad-88a47d516c79@redhat.com/)

I do believe people (including me :)) get the latest kernel selftest and run it on
older kernels.
It might not be the right way to run selftests, but I do think its done.

> But this is an unsupported way of running self-tests, they are tied to the
> kernel version in which they reside, and test that specific version.
> 
> Unless I'm missing something here?
> 
>>
>> We could check the errno to distinguish I guess.
> 
> Which one? manpage says -EINVAL, but can also be due to incorrect invocation,
> which would mean a typo could mean tests pass but your tests do nothing :)
> 

Yeah I dont think we can distinguish between the prctl not being available (i.e. older kernel)
and the prctl not working as it should.

We just need to decide whether to fail or skip.

If the right way is to always run selftests from the same kernel version as the host
on which its being run on, we can just fail? I can go back to the older version of
doing things and move the failure from FIXTURE_SETUP to TEST_F?   

>>
>> --
>> Cheers,
>>
>> David / dhildenb
>>


