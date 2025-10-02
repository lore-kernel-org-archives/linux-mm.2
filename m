Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22BD2CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801578E0006; Thu,  2 Oct 2025 03:35:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D90D8E0002; Thu,  2 Oct 2025 03:35:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0968E0006; Thu,  2 Oct 2025 03:35:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 553788E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:35:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04624119B23
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:35:09 +0000 (UTC)
X-FDA: 83952363180.24.0189C7E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 92866140004
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:35:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="J/RWQxIO";
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759390507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=86Vq5R/AWWxcpYDogfWJwRtuGh+AWS5EijwWmr2aWDI=;
	b=FJ3Nh3Pc+wA8ybdz18+jeUli+FKzxZTFy6oaLs0yTI5qhE3lZNvcW8YWEZtewyr6f2BBx3
	wMRkiX4aSsWvhBDXoci6P0+oAL75pfsAXIOwLHv9vGV/7TAqjzqU3W/wNRZ/GIA1VMm9JQ
	jLhiU3sB8XaCTiK3OzvT6byqAOXegCQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="J/RWQxIO";
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759390507; a=rsa-sha256;
	cv=none;
	b=kJAWI35KpXUr5IQ+W3Wiofyu0syNp5trfHqdnV5fZvFMVSNfpEaOt2VJsDsP4/MWjeCjOE
	pi0JJxdUmwf/04QmbHBVElz2o7X4Bu1tAe90KIIQbua/3W1EZ/ZUfzOGIp8TlBTDXFLG6B
	5TG2n5jBX9RcmfXUBZnieWYNsdTXKWg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759390506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=86Vq5R/AWWxcpYDogfWJwRtuGh+AWS5EijwWmr2aWDI=;
	b=J/RWQxIO7UNYwmTqQAPUiG4CDIEXTsTcVZcSQx9u6ZKrSQ/A3CoD7v5Dos8qQoR63VScQL
	+aWTka/gA6gI8qA8yNooHqpnHmRyidDrVxpP62f1xC8HFTxn0fKz2a4C4IPMS7mGaRSPW3
	hk5OkCal2Jur0Qada1GuParlsMc586k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-NtMPiDnGOna_pBn8ThqllA-1; Thu, 02 Oct 2025 03:35:05 -0400
X-MC-Unique: NtMPiDnGOna_pBn8ThqllA-1
X-Mimecast-MFC-AGG-ID: NtMPiDnGOna_pBn8ThqllA_1759390504
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e407c600eso3234525e9.3
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 00:35:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759390504; x=1759995304;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=86Vq5R/AWWxcpYDogfWJwRtuGh+AWS5EijwWmr2aWDI=;
        b=o2mGIjMUTPI6a7n1nh7moXWchB99kA3W5M4Rzor2NkB7JnFFpKQi1rO3ViyowzR4/M
         cHu26gvDUTzuCg9ReyTWJYSasZjtufshfMjfoBWTloT69z08N0I4nnPVC8lTdSxCZiDP
         He4tziCuYml9FKwz/B50VJdI8ES8BK3k6eJPZs8AHzKe/0YPucETS4YXgNmabu1FqszO
         UBMK8LOS1+CYMet8kMF8WSTrnhy63DhT7xLg627D/pxpYuSzctSlkYlCTBLQwaOkoqiG
         wNsB9qUrmcCSILTmA0320EkoTPx/oSAIcTjaRdOFZoBWWknU7EoOlUeWBQO7FMKmHkFC
         +B9g==
X-Forwarded-Encrypted: i=1; AJvYcCW2axPy2urtpEJd3ICiuoKbpQlQwHtYu3O6LrjVIuP25l53+hZVq2aqUj3YspJ+52YWbBpbNCNUnQ==@kvack.org
X-Gm-Message-State: AOJu0YydjXThexbnCXN74jokYPuoU65Gmi3mGNT8CIo+Q8H7dozxLVIp
	XSyEgbCJZytfzmzl8u3G8RRtkf0emrQOqGO85qOV8GTk1Tqh5lqQns7p6z3rK0XpStFv5C7QjzG
	SWYzM+fcBijG0Fk7MzthMGGYzMpe6QCkyxZnFQz4QXZ4xHXztw8c8
X-Gm-Gg: ASbGncukT28yb3BthMWx9n/Ylc7iMyyc501rkUt4pJ+buG4qwL3TMnqlHz33rMf8rmk
	2V+dwn9d9UQq5pO7sRz28u+jeGNjlsSB6OUDZRsZi0Hdv3Fi62K7w7uXjig5KhTwFqdxbI2cKG8
	qfctATs7WlGRq1tOnPvLdODEGMTBrHVP2LQ5pknFggDm1o6CjpPfuzxK0U/ygdXRtlcVak8DDbF
	BK/KHZSM++j4j9Bhqc+Bhn+w/u92KwmIiWVrzXJ6DZnco6YB4LtVYvyOGOEGQe7439tjrT4E9P3
	+ZX8b5sOkKYcbjlAISBLShhYOeveaX4S4vSm9d4r9XVkRjwXyd2eQ9ZQPYl0SgmwwBGpnIqoH7k
	FG1RWoo2K
X-Received: by 2002:a05:600c:1f86:b0:45f:28d2:bd38 with SMTP id 5b1f17b1804b1-46e612bef22mr44635595e9.18.1759390504370;
        Thu, 02 Oct 2025 00:35:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHD4HH0nVViWrXg7TeX6u6AgfVrPfMMJghbuLvV3OHL0cr7gLl6gQ1fqpMX6H7hU0Kfl0cLxg==
X-Received: by 2002:a05:600c:1f86:b0:45f:28d2:bd38 with SMTP id 5b1f17b1804b1-46e612bef22mr44635235e9.18.1759390503885;
        Thu, 02 Oct 2025 00:35:03 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e611970easm40105015e9.2.2025.10.02.00.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 00:35:03 -0700 (PDT)
Message-ID: <fc52e463-5704-4713-9c91-1e4fa0d58047@redhat.com>
Date: Thu, 2 Oct 2025 09:34:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/21] mm: ASI direct map management
To: Dave Hansen <dave.hansen@intel.com>, Brendan Jackman
 <jackmanb@google.com>, Andy Lutomirski <luto@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com,
 mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org,
 derkling@google.com, junaids@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, reijiw@google.com, rientjes@google.com, rppt@kernel.org,
 vbabka@suse.cz, x86@kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <00e7ff5e-fe6c-4edc-9bf8-2352321f74dc@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <00e7ff5e-fe6c-4edc-9bf8-2352321f74dc@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JZtd8n70Cr6FfDd6j_l9o-yURRM0A1JpHGnt14e8jrw_1759390504
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 92866140004
X-Stat-Signature: 4ydoipca3ei8e7gqktcjw68yjc3dsqur
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759390507-989274
X-HE-Meta: U2FsdGVkX19VgX1GS8PZbFsi3T+o18di+GUOHyC6BCyklvT3RgX9BkCkT3VIqlu6pAPCZbOKuc+e+WS76P1jl+oN6c7DkskgtT0+Yk6WBu5/xQ7NN4JKz95djwh2Ha6octLC5xewv7Twj3LHKAkZ7lFPlI6G+NBkgcZ3y4qeefM3HU1+h5wd5thr9yFjRBmtrZy6Yyq5npp4jaFAaTTw0FZjYMuOS/D80/L2ULObZL2B7FDGpV54TYp/KrTXVfMKdRngi+Zxe2RWOYU1iWKJoPELxdQoXM9IDPMdzDq/yzV8YjVdswVa+WmmOcf/DQaHcDSBgwMO5o6VghNCk7ktoAmoyz4zg7h5llhC9WQPuLNykJsq2agfnZO5+FadYBy9hCepXLOavlSQZqU4md0InAez2l7fHql71oWxxetqSfvFRzERIrZPa5l3MS3NwCwvcgMIimDrnPl1u9EKallP8cr4iM99vJTugTGnCkeoItCrmvAoyt1NFniMvGcGfY+fHtEulMVfo4xmzgDCSOqOy3C8WGlsnsWcFQ5uJl2kY7O3eSYDa4gdS3uqfVAX7Bd9jyKTShmRmfI4cctaK2TBKVZVrUWhS1V/mEmcBv7xQC1cLzNN58FdWIEJqpQrfE1WbTqUrgvxzmh5p+LxDBfw5l9lDgMg4x+HXrJkDx++v6iVZKOYFxWshg3MzcOWDfD//cAd8gqmwqkfHQV3msdr6V3wPqvcEbjJPI/ytMl8AVC7V9UmNiRxZeQSQmwiWJozId+YfhReYc7NosZQrRfA54LzzQ0phe0RXSgwb5fIaOQhOrYfs09NREywL36lLF0LxMUdzr8i7j+3dkzOkGcHvDwhI6ytSLuuuJDWI4f8aJ72kPQSDSkKsvTwLJggOAyWFALzR0FmHxkyimzd7FUFo+wnXS7Eu7UXPFIVTxPI0mHGmmWoSGC3DxOEdLmf7O6Zu5ku6oB26E4yBijLV0O
 uky0CWR0
 zuO00FF09MN2G6XQnU+l1FlnDCRJPwC7oPnjiPX32BHgernQQnMR99JeZ60o92A8+UR5IxKiLRBp+PakA+/cFuarNUdRugKs2Zvjkh6yU47RBS9XNGF6piiYNYdTxxayhwm8Hctb5RPCYVLWum0vollcp1V4nr2I5PskhOIWQvK43RjwwR23mRJQo3ycDPx55Bbmx1zuBPLOEQLniUKRTVFxKwV3nlA1t2QVcNHZOd8icpSvpy2w+2zwnPpHSzkZdt5C+w/01qnlNsLDF3Rsvse39JDf3Sz8qWBwE0cncQO1aI9OXdcjoU8Q8UHsf0Bzycz8nMHgtKW3XPCS6uPWrfHrYxxJXA9pvU9HD1LdMeKjJktLu8xJP/+f5LEmPOEBNOgfuWGXNn4cT5B4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.10.25 22:59, Dave Hansen wrote:
> On 9/24/25 07:59, Brendan Jackman wrote:
>> Why is this the scope of the first series? The objective here is to
>> reach a MVP of ASI that people can actually run, as soon as possible.
> 
> I had to ask ChatGPT what you meant by MVP. Minimum Viable Product?
> 
> So this series just creates a new address space and then ensures that
> sensitive data is not mapped there? To me, that's a proof-of-concept,
> not a bit of valuable functionality that can be merged upstream.
> 
> I'm curious how far the first bit of functionality that would be useful
> to end users is from the end of this series.

There was this mail "[Discuss] First steps for ASI (ASI is fast 
again)"[1] that I also didn't get to fully digest yet, where there was a 
question at the very end

"
Once we have some x86 maintainers saying "yep, it looks like this can 
work and it's something we want", I can start turning my page_alloc RFC 
[3] into a proper patchset (or maybe multiple if I can find a way to 
break things down further).

...

So, x86 folks: Does this feel like "line of sight" to you? If not, what 
would that look like, what experiments should I run?
"

Unless I am missing something, no x86 maintainer replied to that one so 
far and I assume this patch set here is the revival of above mentioned RFC
"

so it might be reasonable to reply there.

[1] 
https://lore.kernel.org/all/20250812173109.295750-1-jackmanb@google.com/T/#u

-- 
Cheers

David / dhildenb


