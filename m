Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F24C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 13:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA758E000A; Thu, 31 Jul 2025 09:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B678E0001; Thu, 31 Jul 2025 09:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EABE28E000A; Thu, 31 Jul 2025 09:20:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAC128E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:20:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B662F1146F4
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:20:30 +0000 (UTC)
X-FDA: 83724619020.01.104A4BE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3842B140012
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:20:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DgREQ4c0;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753968028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H8cVWOuIO40JfoYuCXD6TQrtJBGKCxwzWML3Rk1WtL4=;
	b=GkQFY1VTctl0Nid46mgO0oCLeMgDFyADZLFZiDriAS0tfv0lLxNI2jMsJDjxjyBRGDL4vv
	k1arIgdKuw+pe146TiLrHr75XMWY4w5BJNSjzDTPK8dFtLiYL1wUMSuPHU/eO9tdpkGq4X
	UQf6tx2WTRY25ervVf0Ge40AvHUTHjc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753968028; a=rsa-sha256;
	cv=none;
	b=VSmYrbz9VZFbXPJcjrZYwYb2Z2N8KEkm5wbxiCM/BXzcWBBR9zYW9OkWXl9V5ldNwl/f+y
	63rQCjbFG/A7GJ/PUYiF7YyqKmbA1QjrnLH+gDeLL+Qb4Yw0DNrK/iGCaZttzY0q9RqDSr
	jjPYqaTY7sua1jfcpzgDkG0Z7pft4q8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DgREQ4c0;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753968027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H8cVWOuIO40JfoYuCXD6TQrtJBGKCxwzWML3Rk1WtL4=;
	b=DgREQ4c0xYGTbts5i1jErOhsfflQx8iQK4CSYnFWNfGqp61ZOCgWH2i0b7klTP6xQ5lga7
	/peE+QYhS9UoMkRhqMh4RvZPPPIpxbdegaQ0mlN2qUgZXkHrpCj1cTIiae1lrY864/Ggj9
	DoznQeeqviwtoJz3YrytmFosV3MhyWc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-0ZC5Asv9MP6wDb22YWZPOQ-1; Thu, 31 Jul 2025 09:20:26 -0400
X-MC-Unique: 0ZC5Asv9MP6wDb22YWZPOQ-1
X-Mimecast-MFC-AGG-ID: 0ZC5Asv9MP6wDb22YWZPOQ_1753968025
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-451d30992bcso6174055e9.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753968025; x=1754572825;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=H8cVWOuIO40JfoYuCXD6TQrtJBGKCxwzWML3Rk1WtL4=;
        b=meD/R8OvwqGDJxjhrpDzyROUd1bsBkgEip9l16mAioQX1urePnmoGSAdw0Kh4IR/TJ
         /aOHIQXb3ccb6KM+lDleKUqqxPPddFYNb5EkEG3zAfJ7LH8TsMMPrWcP8rvJAgrN1MOr
         m1HN8KBoxU/PmLyC8i6jLYg6cJQ3HeirDUWkDb9OEHwsLgSUYj7DmyjqN0IBsL4gZs6v
         d5ED1w1VZ98RDE7FE8l+v61keC5IqPUgeq4ORVRaAyUPK8SRRvXn/f0PpEDSrgyO2DqI
         N4tPnz38e5UkpNUMfdPXJOZgIMuirC/e4wmH/iTM4FPz9/FCamabOCg4zHYPl5yaAo0S
         5TEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZAeVT4rtfit3Z4bbCiCpUjk65HwLalfJBl/pBbYLj7Tnv/zgKJqx8T1lUaCd8YBvn1wjr8SGHTQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3Q+/m8bbzawLqr4Q8and6vGr9r44e4uOBgqjH3iFHnKMzcdYO
	J9fxGtni1e2vl2Phek24K5Fnj+IlrzBUxr5iGr8rT8MccRHrHiQLTsgmKHd+EooktuHu0AQ5IHX
	whxouiAnEqKs5EpPObkMtj2Eii3wF4L/cKsTeYlReY4xW/2pRoLe2
X-Gm-Gg: ASbGncs3ldhS4bur+/Vtf3f1aBKNwM6ht+og0QVb4217W+5Sf3WP8Uy7wTrApmbPoMJ
	hJNHkn2/ynlBbL7w5Y47ToPWUI8LOE6krIADXqc32cJs8SJWY7zyWOwhLj7gLVFy1eEfG4lK769
	it+TrEywIS2I7QFArnUbBXUHqj+hdrzzzbJ80PAKBKuAcmO+L8zDKmM+ZnlBlML6cNVH+cUrECf
	cAe0NPX6u1rjPS07ZfQSJFtbIqnZnPAG6ezp86rCORe2XL9u5ZVh/pHyiMToecRcLnoG6o982du
	fjbTYP+ILZ2hn6Ex1NoaEsaseNQu24nRTupIhoMLEc2M/e2bQtjvNqksZ1Dn9RnhyRBUAEWxG28
	jhDsFfXzucgUU44fgVXlj0sIn92/kq7izLy00J0e5JMI/qIpvZD6NzNaFGBpZVB5cHHU=
X-Received: by 2002:a05:600c:35d4:b0:439:643a:c8d5 with SMTP id 5b1f17b1804b1-45892a38f57mr77121345e9.0.1753968024930;
        Thu, 31 Jul 2025 06:20:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFw7izoet6gCRjloh7faX2I/dT1hRt2aBMnfvHniM+pSH974YB03S1kXDORrNyqMh7/oaxdrw==
X-Received: by 2002:a05:600c:35d4:b0:439:643a:c8d5 with SMTP id 5b1f17b1804b1-45892a38f57mr77120805e9.0.1753968024404;
        Thu, 31 Jul 2025 06:20:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3700:be07:9a67:67f7:24e6? (p200300d82f443700be079a6767f724e6.dip0.t-ipconnect.de. [2003:d8:2f44:3700:be07:9a67:67f7:24e6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458a22365c0sm23257955e9.3.2025.07.31.06.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 06:20:23 -0700 (PDT)
Message-ID: <e496bf28-ed56-4935-8ac4-994e297506ee@redhat.com>
Date: Thu, 31 Jul 2025 15:20:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] prctl: extend PR_SET_THP_DISABLE to optionally
 exclude VM_HUGEPAGE
To: Usama Arif <usamaarif642@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com, Matthew Wilcox <willy@infradead.org>
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
 <20250731122825.2102184-2-usamaarif642@gmail.com>
 <dda2e42f-7c20-4530-93f9-d3a73bb1368b@lucifer.local>
 <c9896875-fb86-4b6c-8091-27c8152ba6d0@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <c9896875-fb86-4b6c-8091-27c8152ba6d0@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7uffsyoOL7teYSWN-KsfX82w_DDLI_wjuEfWn6eRgn8_1753968025
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3842B140012
X-Stat-Signature: 6w6giy7nhur8m3cj5nu41zomw9p96iho
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753968028-153331
X-HE-Meta: U2FsdGVkX1+oSC0h1LZGZge3xnDFDmNmg5TQKbryWozM/1mF09km3+WTmZU8phxyw8tSV/NzWswW/tU6irh4HYx3FHIlSIjhyPDo33iiZgOw84DF6FikB6Rb9iZRbsKPP+01ovj3tfb/QotJ3CmS0Aen0T1cS2O1c5V6QVrGIjJEM4JY317g/N+aO6ncSjzJYNCv3YZFRm0TejLtZjsaxkKkQyaQygNkueeMLzzhKLt8Yf81Z6SyzTk6YxiXDxCGr3oK7skEAroKGfJMw7k/uu7QV6yjG+pRoYyyXk5MWHnWnX2J8zZt2DeVcwoR2pFxeOPh7jZ0hHxC0+DL+cOyuOWqcUaeDfwuGHjvDZV1gidh5pi+Ued6Mi/LgbsKj2eAs6OW9EIIQ1zcuhJwgW5C0LOo6V2LCdH0omdeuuKuQxdx4Rd+XVQzgrAlLJh5Ck/sQCIYwFOPAaB9qC4OA0U2nLk9oq67XuQHf0bWpvLdjfziqzYFbIo4DkdAdnGsDdPQCsHoVHdHZYMhcnv+TQCiRZOyUqRC1oFdmdlhqUEQeN8x66b03k7ajbu0S0snkkT6VRWb8xGf+dSJODRw/9GK7/xE3UNacGUzNcdh6iZJZR4s2fTchJcyWBMHdKt/vY2ZgYP8joHybvkDPupcUypjjNOWJ36FtYcZ8qH+YkJQQS7L4NMpGgaDnCS9pk8rdj5ivhVixtzfRzlEQ70fzDcXzb25KgPzCsPKHBZBlHdmK/fMTp6Kv0jsNN3yZxiiFVwArSy3mhSkyfZB7elrVTctjYN4d9XA3brewydj8MEcR+Sv15iubmx4RR5zpb7XHrb/7XyGxuhtfLQk2Pubk0Fgxlg86S+cHf9prXME7tLhlxw6mesc3oRHYiN/OgnjfjBT4avFCLsy7UO7RqbFUkwwIXNLn1mowWqBgiEZB8RI+NCiIRpufhsPdYvCwlJqi+bT/x4z0hp7Q59Wufc2L+f
 Eruu6O3O
 oeA389o6G/Q2j7aC/sWyKFJA82NddgtvhvMGX1KJI35aK9trHaU/Pe1cR9LK9WuxdT0xtcTr6ft22bfiOXetJYJ+Sfy+Oy0M+IDUZEYTAp6uXXbp70OH7x1EHkHXk2UGD1CJD+fr+erLPw9cZSGANYTHAS42sXNIaxclmgRTlQe6jkYPOXXuyBPbcF5+OO3oJU1kS3VOJEXT9XBfb2IrBFcN7PzGtMPDU/5i6W528eTsDmarBOadU1/y/ufQRBH5c+ns1qmdyNClcEqa0Ety/U4cH1lTfL9c3r9mhLZ2HIVFxBiW767a8d6ViqsEffOPstdn0sGXtxRg3FtlOVpFPOQU3cp/m8KozcBt9o6CC/yS5rQ7t9qQ+9UeJ4t6CQY45p8/PU+Y4+kAv3xTSBHgqyU99nYznFu++owfPRJtWMJPxIR8NHINdoer5FuSyIMeRH8S79ESd/j6qB7Ih2qXFzE7hVDtAQ0rUVBmLpYNOkA/49bOpoWOxaDMfQD6Qy2AUjKzVfqn2t2pWNuqbIuVINY5JAuSG21VeeJCvK9KuwfkYkO3Q3+0ek+B1hrnu2TFY2Ds6K3kv1HF+PMKvmijctPBZorFbwTbOVuaqQdu4YNQi9/9VsuxbI/jwr6hYscU7eSrB47uby5DtktKudfJEVu//Sz2aHO8pq8AVUaFf9OkMT6xGa+J9ksLJR5NVFjJWwDXZi9Tzfbzu7cuCQhz82UHWbpylNZT2PRCu3Mnyhc/bBqiJFfJqeLP4dlRLEEIJtzUEHRIuTpdwDldO7CRjs6YVOg4lYq555C2IaY7/lEOWKfP15+C+I20yU/OY8qAYdeEpgg0knQ09GDQVuRAb1HgruM0rNf7ZTlhp+y4pZ2h2X9dC5fDJu5cgZcLHq5dbdxtKfj9l0WhinKNRFDdRtTu475EeRNuzI3Vu0tiFYhztfdzwSluGwqn80fjUOv0amMzmURhfWparIxDGvwmbt8WQ3IWZ
 hzSU7Srj
 cTzhl0x/fWIaW126I6VN+LKIOfiaboLo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.07.25 15:12, Usama Arif wrote:
> 
> 
> On 31/07/2025 13:40, Lorenzo Stoakes wrote:
>> On Thu, Jul 31, 2025 at 01:27:18PM +0100, Usama Arif wrote:
>> [snip]
>>> Acked-by: Usama Arif <usamaarif642@gmail.com>
>>> Tested-by: Usama Arif <usamaarif642@gmail.com>
>>> Cc: Jonathan Corbet <corbet@lwn.net>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>> Cc: Nico Pache <npache@redhat.com>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Dev Jain <dev.jain@arm.com>
>>> Cc: Barry Song <baohua@kernel.org>
>>> Cc: Vlastimil Babka <vbabka@suse.cz>
>>> Cc: Mike Rapoport <rppt@kernel.org>
>>> Cc: Suren Baghdasaryan <surenb@google.com>
>>> Cc: Michal Hocko <mhocko@suse.com>
>>> Cc: Usama Arif <usamaarif642@gmail.com>
>>> Cc: SeongJae Park <sj@kernel.org>
>>> Cc: Jann Horn <jannh@google.com>
>>> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>>> Cc: Yafang Shao <laoar.shao@gmail.com>
>>> Cc: Matthew Wilcox <willy@infradead.org>
>>
>> You don't need to include these Cc's, Andrew will add them for you.
>>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>
>> Shouldn't this also be signed off by you? 2/5 and 3/5 has S-o-b for both
>> David and yourself?
>>
>> This is inconsistent at the very least.
>>
> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> 
> The Ccs were added by David, and I didn't want to remove them.

They were still part of the first submission without cover letter, so 
you should drop them from here now that you are sending it as part of a 
series.

> 
>>>
>>> ---
>>>
>>
>> Nothing below the --- will be included in the patch, so we can drop the
>> below, it's just noise that people can find easily if needed.
>>
>>> At first, I thought of "why not simply relax PR_SET_THP_DISABLE", but I
>>> think there might be real use cases where we want to disable any THPs --
>>> in particular also around debugging THP-related problems, and
>>> "never" not meaning ... "never" anymore ever since we add MADV_COLLAPSE.
>>> PR_SET_THP_DISABLE will also block MADV_COLLAPSE, which can be very
>>> helpful for debugging purposes. Of course, I thought of having a
>>> system-wide config option to modify PR_SET_THP_DISABLE behavior, but
>>> I just don't like the semantics.
>>
>> [snip]
>>
>>>
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>
>> This S-o-b is weird, it's in a comment essentially. Let's drop that too
>> please.

That just got added automatically while modifying the patch.

> 
> 
> Everything below --- was added by David I believe to provide further explanation that
> doesn't need to be included in the commit message, and I didn't want to remove it
> or his 2nd sign-off, as its discarded anyways. Its useful info that can just be
> ignored.


Best to drop under the "---" I think it was most important for the PoC 
to give more context.


-- 
Cheers,

David / dhildenb


