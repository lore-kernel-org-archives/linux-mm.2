Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB6E8CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B188E0054; Thu, 21 Aug 2025 16:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342C68E0048; Thu, 21 Aug 2025 16:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232398E0054; Thu, 21 Aug 2025 16:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9E08E0048
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:43:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82396140535
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:43:50 +0000 (UTC)
X-FDA: 83801941020.24.DA9143E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id AE70F40003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:43:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FiB1khin;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755809026; a=rsa-sha256;
	cv=none;
	b=Pkw9/QTDvvl/clKJFFMiosxAD8lQQhXgscQBgImwPA+DAgCEovDc1xe2TrEVM2oWh4IJho
	KAhqMaP69LorbMXK7iSFmY07tprEyCvhoS6R0tGzAb3KfcEEQChrA4Aj5WcGnl1YwI/yGF
	sQuS8XX4hgZ5QJZoSh7irZwPGlZ6FkE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FiB1khin;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755809026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/fo68/IS9K7j0Ewx5SO22U2/CaLZSJBW37TgxTQuZY=;
	b=QkPz8FuLZ9dEdhGchk4fCfWucckYngEkuKW14h4Yd5uf5s0fwBpSQ8+XO4kT9EtatdDCNa
	OsbLJNBc/Xd+2YYmlc1lyjDB22Jm3vSCPSgg79S4mdNL6wAI9EZOCBFAhMAUQrqOI7ZlrJ
	MTlj3X9g3Gf3N1mEcWS+bS6umdw5eMc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755809025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h/fo68/IS9K7j0Ewx5SO22U2/CaLZSJBW37TgxTQuZY=;
	b=FiB1khin8H8p+jVNc+3V1sv53KabjTszUYJHMKHDJ6ZE43TMUNamZU4arJEpqCbp6ZuqEt
	1aRqW5UW25cymAcsC5ST01GK/0BR491N2EHiDclLYHND2P9KKKRng+hpolhZWvqlbFlEbk
	KwV4KNB8oPMliehVBca/Kt87Xaaqzrw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-Cn8eqMOhN3KsFf3gnqA-CA-1; Thu, 21 Aug 2025 16:43:40 -0400
X-MC-Unique: Cn8eqMOhN3KsFf3gnqA-CA-1
X-Mimecast-MFC-AGG-ID: Cn8eqMOhN3KsFf3gnqA-CA_1755809018
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b9e418a883so807813f8f.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:43:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755809018; x=1756413818;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h/fo68/IS9K7j0Ewx5SO22U2/CaLZSJBW37TgxTQuZY=;
        b=BnXUxCDJ+YxhiceARLiMLa8oro7E+zFcoKpglx9vlKU1/k5i8hr48MYEgM50W2uSy6
         dZQYAi9NlF+8XSHnndbDVmZSKzsjImG0nMl+s3aPRShWimKgihC2yma+7ar/LHPwVppH
         H9fgwPhxiMfLjZDyIg35XyByoWx0AjkzpWQv/oB2vneBJ0YvJvcR508Vvj8maqEXsuLg
         JNf/9jUYUlWpayEh1QeqMTcLUQdS7PJbr8wKvH9eYsiSrg2FurMzthSPORr17CaLWzCR
         eJ3GKYJmsR6yx8tPGTibMpuUZ7DRdE14RvEctdSqheIMELImUiXaJUJ+l1qm5TW+OF9t
         EKiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSNwLt1/WSGvXBudHrSZSzyh2pTjHX3HmPvQAySZrkYfltt/mMk8+f2+nwoIQMDDL3dRNekQ9RIQ==@kvack.org
X-Gm-Message-State: AOJu0YwMG2QdYDQteKETp9AvkUege0tYTAqPVoXSFM+YMCbKHjsThPcn
	6V2Irp49tdoUkykRZvo5cOoONoSyi1X21u75UOhrNpgvolsv4S7dGQjYS/bfdF94AtRdg5EfT0W
	5SVKAUc4g218IUDRT1aMCH2t6QsUWOL/Y0L/J681g9tRkHn2xWMFy
X-Gm-Gg: ASbGncvQqArJcU08w2uiuN5mgJDXejzFTk2mA+LB9wEcnRFWP5wcIUn9v3lJfEJSBQA
	6ggXbtGJHvE5V0htpNEuUU1S43Q5oAc7bHlsfM1PKVKSceqas8RnF6Vu5989JnN3HPtF55C8PzG
	SBGf8QT4T1gvJgn+84/yDUc2QnOKBkE4OIO5mPgSrFpwmnAagBhG0cVQxcArZIqgHgXJxdMcUtj
	oTX/k80hBG/YeqYYJ8pcxfD/AzXVy3YBtQzlXLhUX7KUDkgk8R4y3GEvWflfbRpeqezuABKCh+5
	CS8gpAWrVnrrV6Vwwg0vrOWdfIaHSreTdbVHWG6j9+9HkaS/e9PYv3Q1cRbo7GkvA6dYPw0dxbm
	NjHDaUZ3wPAblGVTfZMUguPAlzPwvbIJurXYuN40yqDhivsGy+2xeecM/wUJbTw==
X-Received: by 2002:a05:6000:1acc:b0:3b9:1d32:cf2f with SMTP id ffacd0b85a97d-3c5dd8aafeemr255834f8f.38.1755809018392;
        Thu, 21 Aug 2025 13:43:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKIuRxKND46b3AmB7y/Xw/b9KvWRYzcjy+ul/Xngby02wgViPbY5Y0WYNrMrywVt99HnqEQw==
X-Received: by 2002:a05:6000:1acc:b0:3b9:1d32:cf2f with SMTP id ffacd0b85a97d-3c5dd8aafeemr255783f8f.38.1755809017884;
        Thu, 21 Aug 2025 13:43:37 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f26:ba00:803:6ec5:9918:6fd? (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b50dd02ebsm10113115e9.9.2025.08.21.13.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:43:37 -0700 (PDT)
Message-ID: <95012dfc-d82d-4ae2-b4cd-1e8dcf15e44b@redhat.com>
Date: Thu, 21 Aug 2025 22:43:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nico Pache <npache@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com>
 <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
 <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
 <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qh8ArODC1olGoze_k8h0P3UGvM-izLwI-9K-1IPAlE8_1755809018
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AE70F40003
X-Stat-Signature: f59gxjtnhebxz86k6p787bbrsz9wi9j5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755809026-393335
X-HE-Meta: U2FsdGVkX19khJ2V6yxhlCFm7r/see9ctcVjLR8PxpiU2Gd9wIT6coFrMLVACjPt6RrOa1m/kkKRAkpZEKh1ucQC+3d11SJK5SyApabTTzgfOC/BSr9O2owg3N7qVaPMkOgpBscCjsZJluI1UDdV4gxX9rzOxGU6q5L0uh2e/o9dauMEnMhXxn9D5cHxYLMh/JD/4aaRsbBZIAYd4sTgKJ6u1i2+7gHbm1nONswCWwiOyggmMvk0MKhsxhK5q9Dp9oRUtWYGrSpF5KIs3iNqbet5iY+CZynLvAAi2+Jq2qmvDWQsRe09wuCtjZY6D1KWg1E2lsXkobbJPsl6FkIBhlhIi71OJkAeSld+Uygh2BH8T2HLLtms8tktlqaz5QWSIyar+ZzBsByDalCdMkXuChzcYwvCLGNIDEejOPY2Wr7LRannCuJa6xxSH+RJS7pUqtSqEAjyHjK/hLVUN2852MjR902OwPXBQtJi7Jh0/OMaoYXMuChoIugpDbxsadLYMjqwky1YwxZ8GkCJaYmvMB5/ktJCoAT/L9Ag+XOYbjB5Wft4TolffzPsK/czYnGtaO7lsS/wbyU16tVpAWweE50ifYm+mxOw09jrvghv2vizRxE5wP8KzJ7VTD3FNhUmdgQ6RSDb3GLZ6kRl8dvBkcAq6gvPVK/tp95DNDipEPy+imJR6s78/nJ2Y2PpbH1sG1DfHT6mUiwwQJkEDjx1cwwSiLa2wrDuttpELqS9AwO4KkKEFiWy+xa6ppGWvbV5wcRWVHkhr0NjO/FPKk31HNa1zTbQJm0A7G9sJ8C3svoogn2R67vCY01YKLak4QyHBglQD5OxBcepifToUd8xwLZShQ4mPaMhHDBVa/+Nz6Q+Z0B14l0LdfH9AK7g//ByTAttrzTlbjJitRl3a5jrKYggILPT5gZFfr3lwu0dXDb0OenzUMh0Wm49+Awn+aHpM82KbEh1wdVvHCn72hb
 Ou6oPoGn
 Mrzjs9bsfxP3ccOpwrtR+rNCCJR757UaO2Qqrf837jKFCIUdyJzTC1JPD3VO0Z/K7k1gRL8V34TUE0AArVYRkJUMt/AL89IkD5a38GSjFhOrgUNRkzwxGGuO7QkvPJQ8nwkhHKuCJKGvInv40P34C9cTsWp2eDw1ngLXcL21hrANPuF/6Zu1pAr1dRiGmaYX2RjwqGAsJkUoojshtjzYsuwrhDu4l+RMfC7rKiDaJIIZWlNeUchjupkg4PR/eBPGMAmAakSRAWIr1NkZ8ucBM8/9Ur488EmgvcpGXk2Rd3iBLMCIYAsA2oQWUTZfJvwGJgJUL9L9FGJxQNfn0fp8CZg7t6r1qlAVddjgIOE8Kz6AvfHKZa0hF/CRlZODaTvCWwaWq2wVoNKMF0NhqL0wsDqPUUdPmF8MyCXvNjxOCosG4bOXBqK3Hg4Lwy6/FloKoLexTcoTXkvxVXzttmai75I8O+fK7fjGxH1F/n6SimKTogBoZjlFxBJzcyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> The one thing we absolutely cannot have is a default that causes this
> 'creeping' behaviour. This feels like shipping something that is broken and
> alluding to it in the documentation.
> 
> I spoke to David off-list and he gave some insight into this and perhaps
> some reasonable means of avoiding an additional tunable.
> 
> I don't want to rehash what he said as I think it's more productive for him
> to reply when he has time but broadly I think how we handle this needs
> careful consideration.
> 
> To me it's clear that some sense of ratio is just immediately very very
> confusing, but then again this interface is already confusing, as with much
> of THP.
> 
> Anyway I'll let David respond here so we don't loop around before he has a
> chance to add his input.
> 
> Cheers, Lorenzo
> 

[Resending because Thunderbird decided to use the wrong smtp server]

I've been summoned.

As raised in the past, I would initially only support specific values here like

0 				  : Never collapse with any pte_none/zeropage
511 (HPAGE_PMD_NR - 1) / default  : Always collapse, ignoring pte_none/zeropage

Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1), but not sure
if we have to add that for now.

Because, as raised in the past, I'm afraid nobody on this earth has a clue how
to set this parameter to values different to 0 (don't waste memory with khugepaged)
and 511 (page fault behavior).


If any other value is set, essentially
	pr_warn("Unsupported 'max_ptes_none' value for mTHP collapse");

for now and just disable it.

-- 
Cheers

David / dhildenb


