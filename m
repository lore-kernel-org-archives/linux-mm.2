Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4473ECCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4D9B8E0012; Mon, 20 Oct 2025 09:53:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FDB58E0002; Mon, 20 Oct 2025 09:53:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ECE88E0012; Mon, 20 Oct 2025 09:53:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79A1A8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:53:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E42E117F7B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:53:14 +0000 (UTC)
X-FDA: 84018634308.24.622FA00
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 87C8F20005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:53:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IlXonPsO;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760968391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bIUQcQqGzVepp2tFG39wK71eceYTNe6sFkAh3btcuUk=;
	b=s5CYFeQeZSnhphoB0FMCGlQuKAjAtoK5J+cWEyARawZ0nqnxzV4EHzcndSF9n9tnGlrVBy
	r0p87fGBWA3Oj4m7SOQA2QDIvJnKep2KjXCyLmh+eRNsz978/RON8AmRk5G/xOFA2aB6eH
	C631Z5NjoihYlwUuwTVNAuFB0v6yYqw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760968391; a=rsa-sha256;
	cv=none;
	b=ndKMMZ9Ly1Ox4xKbyKo3EGIc+cHuuB+ChSDSr0eor2eEib5XO8+nWbdO5Nmy2wvFk3qy1y
	yrH1bKg8kH0Cdbrg7r4fQUD77ZZGcQzZQBhO8c1DvEbtQ5PWQlm5INC9mQAr9QrWV8Fvr/
	/luHKVWYF77YPHQfqldLYc6WxKD35VM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IlXonPsO;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760968390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bIUQcQqGzVepp2tFG39wK71eceYTNe6sFkAh3btcuUk=;
	b=IlXonPsOE8JVQP84aAb3McPoe3NRoJT2he7UTBnzSmQ1pwH4P1TU/PTWwYtSu+r7hXdLi1
	mg8TJqTkqUp6+BKdlBE+JkQuPm4ibr/Jw5t4i/jxCp6tcc1f6KdE1HJDCGwkpK9UVNpIe4
	XFRciXoemqYLCAu8o+EatjG9YS1bToU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-W8TheWInPK-yL-w_o-ea2A-1; Mon, 20 Oct 2025 09:53:09 -0400
X-MC-Unique: W8TheWInPK-yL-w_o-ea2A-1
X-Mimecast-MFC-AGG-ID: W8TheWInPK-yL-w_o-ea2A_1760968388
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-427015f62a7so1836598f8f.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:53:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760968388; x=1761573188;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bIUQcQqGzVepp2tFG39wK71eceYTNe6sFkAh3btcuUk=;
        b=EZKTvu5XpWmZeaGt9LAJpR2ZPR4lgvcOI8xNucoK3Gl5lt/Pg9QHaP6xKxxHGu8NyA
         pmnkUcpHf0hwGlfPbQohwCp4XVnjF3Ny3+DEVX8s9N008tNHKOi/Jz/fRpz1czviJxrr
         qke4LXkSbxYAgJczJ8UWFyEmZ/OVsDNoRwMLLO6wz+MCOfvSRbz66RQ/9ciPJxDfZFP+
         cxqxUAinDXms/1tnrAsEThG8nKL9lVGkK1pgQFIm9r9+qWzBLY2E9t+uOHsHQrsaerCO
         9F7tdA5WwEw+AlHWkNnf8lyrrqiLz+UAbvVPM5gFtMLW9cynPTQk2u+iLCDM6wYmw/6i
         blnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAtCdKEmgXITkVYjzDuhJag4K0ZzlHcmkHgJxU2Fzzm4Y22Cq9XLxFiY1wuPgoC9zkxNMydZG6KA==@kvack.org
X-Gm-Message-State: AOJu0Yx2uuwXmVGCq0j/43LZXBAtOg1xSkP3sGU3f85I1/+M7Dr53aOf
	z+scqblmQ3g7xSeZ0f8ei+YbBP7DcWX4FzkAEAduSgGU6jwX0fdI9f3Qg1BmZsTrXkoNj5Hjqo7
	pL3JlSIfzRR1T3wNOD0xIhYqJVrHcrv7rd+QLVM3yfF9umckZoWR0
X-Gm-Gg: ASbGncsCcCe/3Qql153AZWy42WZG8e5Qi7aaF3ze3tAJ9RuZIUZCQuG6lcQcSn7sCRN
	Q5K5aT/dDO6axkna6BU64hDXPaqmifQr7UzlgPYcu+L2R2gfhUqw1sH8Nmx242/WR3xa7UoxSKJ
	nei7zLlsDEZiW7QZvtY4wXjZ+z3+V+pGyEU6SUWawkwaWl2dDhgpb6Uc52SwulZjq990dLAbRw4
	/TYfHvQ/MnB+WGfXSnKgfBnd1by2KVq0OsrfwTIZAfVGdrl2vke72wEP7ooOl6EyR8D6GOSgiwi
	Xw/4jn3nzfU027LnKcmbGlnW1seYBLAS4SyJqXYVTULY+d0Lpu30Ati+UYKjoMWqo0Z3F82ECEQ
	eDV6wwNGyjE2VFx+L1EyKMB+xGrnw6twxskYnIUn7lSBM42J0V4EJrVYz7toFv1hY2MwgIMJ1YB
	RJi4CrPdVXQRBxNwh8d9mdlBiBuNA=
X-Received: by 2002:a5d:64c2:0:b0:427:80a:6bdb with SMTP id ffacd0b85a97d-427080a6be4mr7318989f8f.46.1760968388333;
        Mon, 20 Oct 2025 06:53:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNJVqO4jkClQAHIXRWj8GsF6qeiRz7gfVAznbjdQ8V6m0yz78pmC4EKThEBfYV6xT0dDAiDw==
X-Received: by 2002:a5d:64c2:0:b0:427:80a:6bdb with SMTP id ffacd0b85a97d-427080a6be4mr7318978f8f.46.1760968387961;
        Mon, 20 Oct 2025 06:53:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5b3affsm15329118f8f.12.2025.10.20.06.53.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 06:53:07 -0700 (PDT)
Message-ID: <d16132cd-81c5-4655-a788-0797553238bf@redhat.com>
Date: Mon, 20 Oct 2025 15:53:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 20/20] mm: stop maintaining the per-page mapcount of
 large folios (CONFIG_NO_PAGE_MAPCOUNT)
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
 Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Andy Lutomirski <luto@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Muchun Song <muchun.song@linux.dev>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>
References: <20250303163014.1128035-1-david@redhat.com>
 <20250303163014.1128035-21-david@redhat.com>
 <20251014122335.dpyk5advbkioojnm@master>
 <71380b43-c23c-42b5-8aab-f158bb37bc75@redhat.com>
 <aO5fCT62gZZw9-wQ@casper.infradead.org>
 <f9d19f72-58f7-4694-ae18-1d944238a3e7@redhat.com>
 <20251015004543.md5x4cjtkyjzpf4b@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251015004543.md5x4cjtkyjzpf4b@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yWYcmZXhw3gmETfzS-SUELo8d4GldYzs_2DYGasP_GU_1760968388
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: o1i6f4b37njrf7ri9dawbotuuahdz1rt
X-Rspam-User: 
X-Rspamd-Queue-Id: 87C8F20005
X-HE-Tag: 1760968391-979634
X-HE-Meta: U2FsdGVkX18fRKAvfqvLQXCnEpKIJ6EQX13Vht/h/XLF3Syetb+WfIKuG5FDG6Ip6x2u+uRYlARJGX0bdpVEIER65upHtoUjZ9zO5t3XM8Lo3BEs1Zv4TFMFpDef70R8YABr7T/UOH9h82dwNjoYFPqAhuvawS2iPi6nUgz7/PFe8Cn0lZPbnMbu6Q0kTW6TtNgy0uWgYmXhgvHZvE623zue24Sr9eKS4IDswC7NBE+C+8RL8R7HKc3Rr8KVot9RPBmwByZMbAES7Oij4E8dC5HgcxYAq7o2Na8RV7rVuXgYMOH1dBJW9sUiI6c3GPQ7yvLWtm+lDV/9GTpSsSdczzJP1kDp766v7DAf56AHns8twLw1WxxdswMck8Q6TnjyO1Z/Ql00HC/qBviVjOJQpaqw3FCInHSwx3aLwPFVk68uvTV+QBo5IC/GKyecBgA35+iPVV3PJDAQEnipdHiOJlha8OZGKU7asYrFU/RQqRtCx5aUW9yrBrEUc8ypfFJ/SMXKuxId97a0E3vGtfy+rmqYMdlrZFG2ho+EzJRSgx0yqPe1p+pzPRld71PBoLJXovBlN1Cje+JzdP5cY4WHRNyfH2jTFxw1Qwb5JoIEJ8ba4Ybboia9v0eXHnykMlZBFoX73vEYnx2bNuMYjs3I5QasBuPKZDFNqyT79g08CCwvzXlcFTvOI2MZLihE9pBsP4DUV0qRUOeabsuyUJ0fyU+EnFr4yMfrO8fKwcdhAETGtGFkEa7yyyIk3zhF1lTDbag9wzDVSKT0YD6C5rIatMbjJIlgISxr9IhVYPOEnIrMdApFAo2zc2z71Czi6XjXEzLYI0DM1Q8QTTUAZ0tgjA3K+Ojf66zRqK+TFpl4LKSm5S2/BueDJJfuPxMficzR9YQV2b9gMOFL7pz/oFkQCUyCfBrA6QgZ2mMz0RxGTdnkFhLhtWVM8fOtRkD/y4V691FMB8YthrP4mD46Tik
 +PPJgqIz
 41xKKIvUVxlTJ3sS2LC3KgyMd+TpjJkT41IcxQcnkrZs5Scc5bG7xazjVEQaB2Ydi8x+9AF+MsGXQ/YnQyiMOISU3oOwtMEZ0+nvVpFti8/4qf0ODTUSgozxmAo2Kntcp0nxD/0n6kzajrKJ/xv5n6hBroNkwIwnI9GE1akfCvGhzmy9GtfLJcQlYDS+aWOiXjEozQXJGCa8BK2C8YB+WCpMWYsh1wGkfhP/1uMkN4ThgW8suUfKvWORwg2SNOAjoDnhWllYoQPyDTnPk0toAz7jf/AC1XQDp5O5oLC4er1QRSO+vrhyFVnNpisLGaeA8AsDktGChaWbQKiljuLB23V5hmtJxUsTeAwwfWKopHHJC5iLR/DuRIs5Jd4nLkpCT6aX6QRQ6JT/q9j2OjGZG22LxM5pALaFHb51s8HvSDxpckjmqXC0MrkVD41pSA6ybxPPLsEA6Bwe9W4qeNezxcHWUWF1XDUeEzsdXRwV1VVQUklTfaRK7koQsoVuVTLyt0k7xWtKMHZQquecU8AY15lDvDuJhl05qnykKxgTItE9O4WY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 02:45, Wei Yang wrote:
> On Tue, Oct 14, 2025 at 04:38:38PM +0200, David Hildenbrand wrote:
>> On 14.10.25 16:32, Matthew Wilcox wrote:
>>> On Tue, Oct 14, 2025 at 02:59:30PM +0200, David Hildenbrand wrote:
>>>>> As commit 349994cf61e6 mentioned, we don't support partially mapped PUD-sized
>>>>> folio yet.
>>>>
>>>> We do support partially mapped PUD-sized folios I think, but not anonymous
>>>> PUD-sized folios.
>>>
>>> I don't think so?  The only mechanism I know of to allocate PUD-sized
>>> chunks of memory is hugetlb, and that doesn't permit partial mappings.
>>
>> Greetings from the latest DAX rework :)
> 
> After a re-think, do you think it's better to align the behavior between
> CONFIG_NO_PAGE_MAPCOUNT and CONFIG_PAGE_MAPCOUNT?
> 
> It looks we treat a PUD-sized folio partially_mapped if CONFIG_NO_PAGE_MAPCOUNT,
> but !partially_mapped if CONFIG_PAGE_MAPCOUNT, if my understanding is correct.

I'd just leave it alone unless there is a problem right now.

-- 
Cheers

David / dhildenb


