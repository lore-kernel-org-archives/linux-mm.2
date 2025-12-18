Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BD02D6D22A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 14:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 824436B0088; Thu, 18 Dec 2025 09:16:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1A66B0089; Thu, 18 Dec 2025 09:16:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B31E6B008A; Thu, 18 Dec 2025 09:16:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56C6A6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:16:36 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03F181401BE
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:16:35 +0000 (UTC)
X-FDA: 84232792392.05.078148A
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id D86C78000C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:16:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aVnvCi7U;
	spf=pass (imf30.hostedemail.com: domain of seakeel@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=seakeel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766067393; a=rsa-sha256;
	cv=none;
	b=DYJks8aDi7m7FeTcRu2zRRS+wFtyCFGXlSFBkW/YSRi8/URl8g9Slw31PLOXFHwYHXfVXv
	YnNrjruPKwxJkfkMcIl/AfgsgsuoLSBZ0c2zZiVn5zMRIc6rdzKtk5/Zvnms4apv7yxfYb
	8/5deFKsmUDxz1Cmwf1OzmevMaR1sbg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aVnvCi7U;
	spf=pass (imf30.hostedemail.com: domain of seakeel@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=seakeel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766067393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXzxKl4n/8RvMAsuC5o0CHJyqBCSHbh1Hg5d0ZUuzDk=;
	b=B39E2wsQ9+rzHLgh7QbIcLfZii+YVfpQ31khOB+HFrLhVo4cVDNiXdlDI1jhUcw7vHleMC
	SbiRTLA+QvxgK15H45iVnyEd2K8hmgHWZTrkro5A2OWcknZIMCQQcwB4bcKHYRkis98uzr
	OD+99ueOZkx2Jq465AviqoGahG1LF6k=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-78e765f9997so4552407b3.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766067393; x=1766672193; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fXzxKl4n/8RvMAsuC5o0CHJyqBCSHbh1Hg5d0ZUuzDk=;
        b=aVnvCi7UqTbUXf9sRgqm/8oloQGfl/4qhmNWjzBrnHzlPkxQ0O1oXlQeauPj1oiTod
         kp3ZstyTcR5zuDmrW1WcAc7+UHgd2h2P/BenwSogbigXzRuCMB8D/f5B8SBqRVMnRkDm
         WSdbYwC5vjxn7g0KJg4qTjF1pSCV29iZGV4AIYB6d3kiStyEnCTjLnpT5OOqT9qI3x3A
         /smnTONNL+8spLdpbLXbTkINoPMbxYmIN9z5APUUXjH/yVwFpB40A9kfqr34oVXwOm33
         uEPL27VbSZrkUVfcTNG90LmpQjo2czxdpoFHL2FaoXgIfzz1JY+NOE+0RZ5CE9hZN7nR
         vYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766067393; x=1766672193;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fXzxKl4n/8RvMAsuC5o0CHJyqBCSHbh1Hg5d0ZUuzDk=;
        b=tH3DUBVmLWxKKLN0gQXipAtmHisPe7R8Jtdv8LDnVYZcoN4NHj+/JM3AXqV8UFSBjk
         k5Ke4ejtcEUgEn0ZuLdEVcvEc8pYRu+Xqrd5rsDI5233d67N5hFOpgGHp06QoG7lRRkn
         Tvsngx4pkbxCKMkh5lX3/HSTv/fC1mjqASQnf4pIPbNsJG1NfGvo0O7YIQ6jwfJDRNv+
         9vlfKVXqvsr+vxHfiCg4ZPGyHjdor14dUX0wu/BG201vnHjg/wtmNFY2PE5bsLgJYoX5
         dNBkovdmgwitcmiUUyqwe+osMBb392eY4SGZAPU5zg28PC0gDdqhM9JMLX17IPOgYAfh
         Qbhw==
X-Forwarded-Encrypted: i=1; AJvYcCUaPYcphUKsNXistrpInT8W78QzRIaVjrP8i3r9W6VNedZdzhF3ZaF/EkOaOZ7S0QsZjfuVCDmkgw==@kvack.org
X-Gm-Message-State: AOJu0YwI3GvOGw6cinLiQ30Vw4GMNGCZgmUQM1Olq33RtFCM7c8ZvNtW
	VzQwNSS2vhK5B3Hw4aMzYpnoJyCucLKz4FtbWmjk8hFBXzPGvNgMYExm
X-Gm-Gg: AY/fxX5RtTbbxEVu1kEKjH/fZOQyfIRtrlYwirM4q8hr/0faDz5vwKCU80cgu8qzm9z
	6ifWbi3/mYmRdLQ8TVNwAJTbvof3GvFzPrdkrDyv+BtBgKpn7hN6LPaLU5KyL1xU3DuB2+mww0m
	MPd+vR61ObCb4sY7+5eQgcyCbZ3ydmz+xk2Y1Deher0ZWRto76y7nqEMO90LucfC3b0uumZXurj
	UoS0xoMk/ZEJlivBmEKR0cEE7khBqLX7TttJm6acjbkQFBiVzOfxnXDCEX3paBh1exwYK/1hJaG
	zL96hEZQu4PMJrIPGhx7vgBtmrC8Jp3Fi0P459URY7Tl07BrqLi7y+7tRdj5o72XfUFt3CmzcUX
	UiwcN/tXK/o+lHwiVoidIjX6p4DLMeUSPtsFBHkZ6q73xf5DkcsP+Csa/h2OffvoGLjq+WGO+oV
	U+b8JcfMiv2gnCHySaNWJ3UW+v7YwE740w+pw3tQ==
X-Google-Smtp-Source: AGHT+IHiyiDMA9Ch4dS+LVHDAxXzncC3LuoMgD0ZQuZ+G9ON0TWb1O0iMOdyZnWTo8KMI06Ox9pplg==
X-Received: by 2002:a05:690e:4086:b0:645:5a9f:8002 with SMTP id 956f58d0204a3-6455a9f836bmr15444591d50.6.1766067392483;
        Thu, 18 Dec 2025 06:16:32 -0800 (PST)
Received: from [192.168.2.226] (104.194.78.75.16clouds.com. [104.194.78.75])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fa72b48efsm8363757b3.51.2025.12.18.06.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Dec 2025 06:16:31 -0800 (PST)
Message-ID: <4249e49a-c91a-4e9c-92c1-79c272627540@gmail.com>
Date: Thu, 18 Dec 2025 22:16:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm/pgtable: use ptdesc for pmd_huge_pte
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, alexs@kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Thomas Huth <thuth@redhat.com>,
 Will Deacon <will@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Magnus Lindholm <linmag7@gmail.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, linux-mm@kvack.org
References: <20251214065546.156209-1-alexs@kernel.org>
 <52e2c1eb-67cf-41ee-9088-760fb6258153@gmail.com>
 <ee42b057-b2d1-4a61-a6b0-39f81f78a918@kernel.org>
Content-Language: en-US
From: Alex Shi <seakeel@gmail.com>
In-Reply-To: <ee42b057-b2d1-4a61-a6b0-39f81f78a918@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D86C78000C
X-Rspamd-Server: rspam04
X-Stat-Signature: fxxirhojpikgn3qcf6h4i5b3rije7y3b
X-HE-Tag: 1766067393-315483
X-HE-Meta: U2FsdGVkX19pRuzv8Va4Dt2h4mY+PDs048DBX6SMQJBUlW6sMTY8HLr8Eh7FBh5zygG9Te5SAw/V4SQb2ykYVC3iZ+8pKBDI9DqoANjA0Pbg13i6Z0YsUCl9avT1sASk5GGqPQUlcR8430A3cd0I4Z9aiKWYGseAL4aMHzjuEu+CaaJpjWzVvtkIQ7FiPnnWrNI7DsJZ2JFKOrPgDLGwULBGPxXW5MAeFPDUq5BHgcITRYSUxYmS8D3qCFF7KktfYtYFcvvHPlk98vdcnB2XgsLZ850+CJTU8xuaZ39lr9+CxMaI/4q07P+qC5l3wmZlzahtdMjMBSJVAaXloCQm/I7DoS4JNq3NO4Iq4HvRu7YsL5gv2gaFSTNY0PXbHTDA1mW8f2beBtwv+pIFpeC4dw2mJbBQ17q6+s3PPihd26YoqDXqSVhHlYFhFXwmZRMqlUcIeJ4r5mELCAZUFAcP8DnWbBwYwL4wdbxeBtTn/HLVQ6dZHdchb0l720Fzos78tykfH21EPG0BKW4rnFVvtJw6N3vLGrt1CUxKzt7oET8LEXvT4vN23cvoDSPKTP2gzAgrsQcNUYeUcs5DMC5wDBr27CsmO6PgigMUqCpvP6OU4o28BUzHYi9wBydkqj4mLcNmW2rjzljN02Ynb0supwJcAJzXLsLcxRGCt2IoKdARImmoBbvn69zvVOTSV0EOStRU/BFD/X19PPJbHDzqiX8pKlbMoFfRedIjICJGbnmQvVIcEnCikOgWVYhDpqvIC2eK1OUo0d7rGkA68XNMwQI8zWuABe4sstRgRY/m0kawwHhgQSRFA8U7OBppPwIXRpEfakc1LfqpNfioxB96D3bsoNetFBZkgXyyomNQ2NOWpOa0Dseu8X/U81+bwtW7MXV4PcBiHXApXh4BusJ7V6ru2jx2ZG//2mpnFDS01Wy5NQv4ypzmdrYKI9hxoH4Nz/Qw66inIcZtmXOvQ2l
 G55Nq9Bl
 Zw3VXoRtO5bzo0/YO/rIMd0a34mHKcqd44DeuC5leb+jzucau22k7PoZ8AALknVF4DzUqeKz7Nyk91ZJlOFFJVtLWl9ObgrmxRIy1wJ1ZL1tvpVBXEnwPkVuLIu0OGaMpnukHa6trrxCx6xGVp/BPDKElD3hTjcLL++E+I+RprVs9+FZrvxts0oYlU/DvBpWaqUiN0O5HR8V9y0vUppwkxJDGM9xGEUf+LWDJrJ66wYOblHhlNyyYy65VTxhH+RGByd2v5GGm1pNHc6iTYTCXHk6CyssHv0OBv5k6juMTHjyqRmHomjnEDuj21Ib/PqBjRrPg9pJ1d48P29sKpOuXcDKVnBemhOovmu1tO6BAtw4HVK79t413SALnIbAjjzoBJBrwWNtnupq13cB/+z9PuGvaIAmhrYiszjKWNiv0D+Q5MpYZT3EzH0PvwCrGemzrpwTMHumdTM8/vGPRSajSlhZRpe0Ikpp23Qy9sllRWIwzyOkoPzGQoPe5I3pktIimwIUMSGSIlP4Qvujb9JYYtayWymI3YzhI55fk07QdmKXo9y1nJl5PySf0T2kDto01M7r2vWo7PevAx4w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/18 18:01, David Hildenbrand (Red Hat) wrote:
> On 12/15/25 01:53, Alex Shi wrote:
>>
>>
>> On 2025/12/14 14:55, alexs@kernel.org wrote:
>>> From: Alex Shi<alexs@kernel.org>
>>>
>>> 'pmd_huge_pte' are pgtable variables, but used 'pgtable->lru'
>>> instead of pgtable->pt_list in pgtable_trans_huge_deposit/withdraw
>>> functions, That's a bit weird.
>>>
>>> So let's convert the pgtable_t to precise 'struct ptdesc *' for
>>> ptdesc->pmd_huge_pte, and mm->pmd_huge_pte, then convert function
>>> pgtable_trans_huge_deposit() to use correct ptdesc.
>>>
>>> This convertion works for most of arch, but failed on s390/sparc/powerpc
>>> since they use 'pte_t *' as pgtable_t. Is there any suggestion for these
>>> archs? If we could have a solution, we may remove the pgtable_t for 
>>> other
>>> archs.
>>
>> If s390/sparc/powerpc can't align pgtable_t with others, we have to keep
>> the pgtable_t to bridge different types. But we could take step to
>> change pgtable_t as 'struct ptdesc *' in other archs. That could
>> simplify and clarify related code too, isn't it?
> 
> Not sure. s390 and friends squeeze multiple actual page tables into a 
> single page and that single page has a single ptdesc.
> 
> I was rather hoping that we can make the code more consistent by making 
> everybody just point at the start of the page table? (that is, make it 
> consistent for all, not use ptdesc for some and pte_t * for others)
> 

Got it. That would be great if owners of these archs like to work on this.

Thanks
Alex

