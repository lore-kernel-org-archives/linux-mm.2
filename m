Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89732CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:44:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40758E001A; Mon, 15 Sep 2025 06:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9B18E0001; Mon, 15 Sep 2025 06:44:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43208E001A; Mon, 15 Sep 2025 06:44:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 893278E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:44:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 306D71A055A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:44:44 +0000 (UTC)
X-FDA: 83891151288.20.22660BE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id A7F3016000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:44:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZVWcrepZ;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757933081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pfBeZpYZH3kwLaHNF9xrLr+NfYDzXqMeo508dRBOzOs=;
	b=JvdPgENK+avVVyFKI1FKDPQV6qF6QVizBzzltRRtQQp3qvgZsZgBzXdBhgBPi1heXm28h4
	f/TGrSSpX4WzTJ5yMEzRb32a0XZSV/2hlbsc2JJTnDY5DUJdN6huY55kaM8RvVGIkAN6QI
	1pYO4+GJJsXjTTK3iAQLFM3AU5w/A9c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZVWcrepZ;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757933081; a=rsa-sha256;
	cv=none;
	b=GKAwV2SrkSnAQunmw364Xh07voAbwmREt39SHW+wBxbVq+LS0oQfrs9hgtKlitokWdHdbm
	qZOjItCElyUaauSjNNI0HLlIOhxggmmKGumUZeYjXY3DQnoIzXO75gEnraMBQJkQFsjp9p
	AeCVRaHZEOVg84YvT/fnnL3w/Q7zHrA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757933081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pfBeZpYZH3kwLaHNF9xrLr+NfYDzXqMeo508dRBOzOs=;
	b=ZVWcrepZ+x4jlBzYr81ZJ/C1iPx+pjSBOb+vzyTXdAHWIYNtONq+fLpc6BH7sEHHS0T5FZ
	r+uyVvBIWQE9mhVGMPJqCni+STChLJ3vtwCQD3bRv5tIOyQBpRh36P5CyKsi9o0AI1d3g+
	Wc84b7KiHDVuuP0B2byUsKDadSgfT+I=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-xrIAxpRsNrG-fBmm89ysag-1; Mon, 15 Sep 2025 06:44:39 -0400
X-MC-Unique: xrIAxpRsNrG-fBmm89ysag-1
X-Mimecast-MFC-AGG-ID: xrIAxpRsNrG-fBmm89ysag_1757933078
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3eae0de749dso447249f8f.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:44:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757933078; x=1758537878;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pfBeZpYZH3kwLaHNF9xrLr+NfYDzXqMeo508dRBOzOs=;
        b=Xa2sNzxrT2j5EwTYAZc7zekIGQ9QocJc2XQaF5PkMktZak4PzJ5+4M4+Pj/jaW+JRK
         Rx1ZnNPRmyUJzoGQMxFo2qewTuTEQXGSv4QEigRoLL1Ml3+uysecsiPYfUcZkG1oESNM
         bSy2qeEsbqeTjsskxQZU6D6Ym9TWnSbHEZFe18wwFZWBVY+F8fjHVe5SIu8upBk0Rkb1
         43Yi0/ZrkJMJ3d5HKcgXJtB9wlIasSL/7R0VA6DjSEuSzRMiV95TURXghFq0Mb52qpv4
         UxQ1HZSzI9misL9V5l+bVS2784z1Q6bAvjce1LdyuTbzFVIyKoFryuKd76hW5XPJBClA
         1kDA==
X-Forwarded-Encrypted: i=1; AJvYcCUWnx7WQ2fhMhsxKPoSXmqSBmSEV7O2PGE0sa/Sm3Vk6ECb07TgH0E/C3dv2dp7J0Izj0/ngUslrw==@kvack.org
X-Gm-Message-State: AOJu0YwfKwY8XLTWiwb3v2TM+bJFboH1R//uNZBUGvB/btEzibyNAzhn
	YnZ+i3TmP9MO4C0fI/q36Q4ZRSX0/ABDei088YKSc1Q678mQfw5t+2fhukMuqShDWMLntXEzzjO
	YBYPslP57ykI3+I0VBkClmNXKF0WGUd3FRxKJ3l6dvQUIn+JRL2xS
X-Gm-Gg: ASbGncvdfDF7v0Wv/h9m7bfPjzhR03Lb5sJevV4IPvTbYwRthur+tUT/rPytO3uFMXU
	Duu2Jj7i6Yi9/SWu2zgToDPP3qhJRae3coyIvOCKsLUWJ80aGlhHOkHFiG7hwjlGfHs1UjhYCzQ
	DfeF5vwDNB+1+G0REzE742i+mg/WdObhuODcvlIWhuprbGnk+KTHgqFBtjYboETuOTCYtLJ9vrN
	tBwiYmOBrTwS8EIp600mSE/p5gLf5upbnbFnph04J12jat7rnQRcvnL08HnNzA/swYqJNLjpu9j
	cLR6r45uI5svO1LcznXgzaOmAsCvRK3afdx0yEAzjx7iiQv/5Uz4JrAwc70P7ExX9Al5NNRp6Nk
	zUGBz/sQ2FSui2BDPUMGqRZeiqcHQjTn6bmbKnj9q5xvhZ/NSGkQJe2eaT8AzNjh7Zes=
X-Received: by 2002:a05:6000:4313:b0:3e4:64b0:a779 with SMTP id ffacd0b85a97d-3e765a0adbcmr10716123f8f.53.1757933078501;
        Mon, 15 Sep 2025 03:44:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZ67BH6eODIX53bsHRNys6uDTQ10DKCXfSX16I+6EVy74wqGrkRZ/YiWiJ663QUmC8ksBjyw==
X-Received: by 2002:a05:6000:4313:b0:3e4:64b0:a779 with SMTP id ffacd0b85a97d-3e765a0adbcmr10716076f8f.53.1757933078032;
        Mon, 15 Sep 2025 03:44:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f2acbeee0sm67118205e9.0.2025.09.15.03.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 03:44:37 -0700 (PDT)
Message-ID: <34754ca4-fced-4a3c-8ff8-c00967d487de@redhat.com>
Date: Mon, 15 Sep 2025 12:44:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <2c5328ee-fb6e-45cf-a151-868cc8e7ff97@lucifer.local>
 <4508810d-7645-4f57-a0c5-2ee9f44206fc@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <4508810d-7645-4f57-a0c5-2ee9f44206fc@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KCjuXawEBaMhqNoHAgVKVrjiefGCq-8USOA-R5kuIjA_1757933078
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A7F3016000A
X-Stat-Signature: uo6uof63nqjt64aq8wzxjgwyi66b3sg9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757933081-11560
X-HE-Meta: U2FsdGVkX18WavBGYRe1xtd6kV1aTtC+AotCZAPTthu+Xo9uSZVeRa/gXjypAAb1R83p1urn3JxHdm1pBb6RbAHgkpSfuDWJ5vfY+wo6ezNTr4wK88AKUbaUuJ0UBXNq/Crn0IbMYSmuIkzLcGfxK8zn0cA7Y7M3K2OQubdIOArU9KZudvreRBxWDSBBYNBLH1RthUZEiS8yyvrkuwH6w1GKD7C/wfNxsKD+f5iXphKg0FRwp7pQeLeBAJZCfB3PaF3Rsgk89IpLDJ+mMuGkj7ii2SWKjQ9IGsbtJhpXHcg4sjp9cbHBSo8pq6wFlT41salP34p9C+9yKCW4GwARsDPb7xEwA7WCTG9qeeqrBPpGZaZprYKLtuKCGfKuWwL65+OkG6wBuf+JXE2Ihd2lSdqp8r3ICMez4MxKscjna/kLzhiHZBotAJvsx2bOgKQ7w8YE7qWMm56Qrf6huRu6dsko47GfjFiA7cX3KNzNg/oTARVKLgt0dutXVhlDhevdAMN3sqH8yxQhn3Z3pzt0voFtekoI1qgbYFPfR2Uh6PnGYcQqWuMWZG34Lwza5I6w2v6IAAkA0flwSGWgKkdWicniShvl6+V0kLZP4I7XnVcQjwq+rAP2JwcKZh0LL+UvI5RMoxJW9zmAMIqX8755tFKw7TWOUxVGETQYe0hScBaXx0cubUjPWaAHL+pR4Y4JzOoBqGQ9s3ZcFyUjHPgXO6nkZom6dhUb5lmQAJsDAhORjvohEny+cYsyCuR8d2dELPDFzKu2hKAAxW2nIDJZUviWV37Un3ljOLYb14Ct8cDAWd/wPIjfdnubtL+sfTday9XLMkMov5rMfqY5JobklDYd73eL42D0tlfDXeEuPBQFDbyZAB86hMfQhZu5DfKaXb+ciQBkmdph3M5fmgKUjIrgUYicU3bupKXeit6aF6SMV2PEaE0qKCjxnfrU32lze/qzV51cCC+4yEzOoHY
 qyao/2df
 IAWxEyNpg6wlWyyb/OqQqLgH3Ex6Lhf81g7eNoN9TsMolYg4GEzd7e7r9YJQy+0gEbChrScHkNsSjm4mfW1gsZ3LEf+wpy7PaqUZAGTfKwRojiw6BwfPrqlMR9mMig1P4nJyR0BjWNmRLPmCBXpRuJ8kUoICVsmiFMTHQ2/YZqUSemaOilwxhxAXtHwFxmLuIFNc5uxfDz4Hrg7QaHWVFxC2L+lfAENo/LVhHq7hoxlnR/i99VVUyeMaiVcrK3Y1fuvGb2eyNAIcEnFr8YGPMyOzCGi7HGFkf/ydvrsM4CwOKXBBLoKEBN0YbdAj+ImZKcwJgcrWeC4eIIFxUA0sQlkHmfl0ilD26rEc2ljqM2v2AtPN0mDPgdtgIS2OZEVX0GpnC5L2ETSvjSyOcUTpWQITLBenbbX9Zbtqx6TXRz7erXJKv8HUdQiZQQVkBfXdh2dNG1q8lAm87Vuf+/RXlsXRVLnodK/POgCS+NGxM67Y5EvHxQEJeIDSFVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> Mapping that to actual THP sizes (#pages in a thp) on an arch will be easy.
>>
>> And at different mTHP levels too right?
>>
> 
> Another point here, since we have to keep:
> 
> /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
> 
> Around, and users will try to set values there, presumably we will now add:
> 
> /sys/kernel/mm/transparent_hugepage/khugepaged/eagerness
> 
> How will we map <-> the two tunables?

Well, the easy case if someone updates eagerness, then we simply et it 
to whatever magic value we compute and document.

The other direction is more problematic, likely we'll simply warn and do 
something reasonable (map it to whatever eagerness scale is closest or 
simply indicate it as "-1" -- user intervened or sth like that)

-- 
Cheers

David / dhildenb


