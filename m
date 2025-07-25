Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B229DC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 10:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 564D76B007B; Fri, 25 Jul 2025 06:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5158E6B0088; Fri, 25 Jul 2025 06:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6146B0089; Fri, 25 Jul 2025 06:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BB356B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:10:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D224E1405AC
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:10:15 +0000 (UTC)
X-FDA: 83702366790.27.1F2D1E3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 66A6712000C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:10:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HY7QbDuK;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753438213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCv5vRN+V3N36ln4l/qk+no8mmBtq9CdsJugmAnVBHc=;
	b=LfnWMX0JC/kq7Wbb6GeUkqi0qSursjqNQyNbzEBsZHeNv6KpJEXCP8/PDKa5lur6ogZzad
	pFk57oLXQgEqZxwkCKSBsATtZUVCxYL2Orr8zj2dso0BqzB+tFSlynCADG+IBPauoZ21AS
	4oEz0ZjoNYuT0S07ehnaXzKYed7uTnU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HY7QbDuK;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753438213; a=rsa-sha256;
	cv=none;
	b=x5LfjeYPrTEwUah94PrNkhsEsxChWqC7xpep/1AYxtg38tx2yZopqofXGys9W3R9iaYZOR
	fLT7RJg3J8/72hAM4W69zveRQbfErdlscx2dnFc0JIoAbVHkZM3tikCxZJHQFD22s50t/z
	vsZeYqrlnklkure+zRPiRORgPrzR4sQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753438212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RCv5vRN+V3N36ln4l/qk+no8mmBtq9CdsJugmAnVBHc=;
	b=HY7QbDuK444Im40cKsmRZmvna/JDGoKmFAHEhda6K2zlqcTzsN2jqH3AabmvLN8B9URn3O
	gVr1ugv8S7DzzlopqW1xOKI8qZRRTldk54W4LG+iAwXiIf5AhdfpFwLlgzITp0fC5Kd7DE
	zagKFVGAIElnHmE38PMUA8iOoFobC94=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-IBUj4I5SMqy0SAorgP6KFw-1; Fri, 25 Jul 2025 06:10:11 -0400
X-MC-Unique: IBUj4I5SMqy0SAorgP6KFw-1
X-Mimecast-MFC-AGG-ID: IBUj4I5SMqy0SAorgP6KFw_1753438210
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45359bfe631so10670205e9.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:10:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753438210; x=1754043010;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RCv5vRN+V3N36ln4l/qk+no8mmBtq9CdsJugmAnVBHc=;
        b=OA1nwbnWnrYjeVPcjLA6+wCnum8j7w1/EBmhRuK7EN9hTPwV/SMNt440+jJvHBXMNB
         z40NRoMRO+VKs6Za3mlGLxkYiWWNpumTjMh+OA4LCoG1powm9PVY6f0Vs3Wk6Ljm1tpT
         wYqWhivkPe9vZ481DSMuTP/55axBQv5CFZdIFkKlXkQ6rEQ1yRvAZQrGk61YmfzpQ6ya
         0ur3uCM7xtNsYGuyXJqvYvZDSqPX6J0hnFYRAz5GdKL8Rrzb8IVaCdXFQDmt6NiRoFtc
         pXRwXIo4ZGlmVq5NdARn2mjN45yWgUNIY68UVkEEP9JK0jcCiYnmRoUpq0VcuF6fkqAj
         5qbQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5DnUvrNOsuK63ii72QhidmYObOCHQDMXW4fCKsGlwM1mCz/liev212GxrUpOavY3GcSWlVIL/MA==@kvack.org
X-Gm-Message-State: AOJu0YwRfjVUN0TsRClc/hwAEKgfjSkldRzin5gI8ydZlLDolbFQ54A8
	k7PMmlyEIEl78hhOGuS/7SuzrSsCrnRADa1vsXoynWEHAT0aXwDYYLFbz77azeof4fZ0DffZ4Gg
	DIT4Thvo9UzI4K1e4YmF0Ujvl+xhU4T+LU5IvlivwlgBRZVesk2dT
X-Gm-Gg: ASbGnctT6o/+C9kOUzOtGVtX96pyjT8a22WY6H9c8C5uqHSH73TXaWIZ7JzReO2Rr+j
	GBhnsQrZpMXPlun53CPEdqJvNTfC8tQ22NpRES3f6NlCYA7sKCdL/sWudz+vLGDiGIUDTbDN8aP
	L0ClQJNxo8apgZt2hUlhmf4lLaeNORhdCH+qB+fGdp2MQajtISq2JUoN2+MAiNNdjtT2iQrJO/9
	wcAHE6TRm1S5zremnypa1CLoTpYmoAJFq1AvnXGXnbgweUvCaUfjk7I4e1ApHBnckYoXlRSbIyZ
	ZDQQfRsLY45rvWtpCAYF7xpYqp7y12Va1/SdSXJHzOC7AIjNKuqSFd0wmePnDx8dabNpkAUaND5
	t7F7a2FkSmfsf/mg60UAF35V8BbPX3Vbwsz/rT9m2qK9FqQRgnQ1hokg3+EDUkm6wLCI=
X-Received: by 2002:a05:600c:6088:b0:442:dc75:5625 with SMTP id 5b1f17b1804b1-458762f07eemr12140615e9.5.1753438209998;
        Fri, 25 Jul 2025 03:10:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFK7mwDSWg8+ygksCm6dpsZRM8Kza275xhyDlqpfynlyccXvQz3lJi4ZoaZcr76pXUpb8kLzw==
X-Received: by 2002:a05:600c:6088:b0:442:dc75:5625 with SMTP id 5b1f17b1804b1-458762f07eemr12140215e9.5.1753438209561;
        Fri, 25 Jul 2025 03:10:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1a:f400:5a9f:b1bf:4bb3:99b1? (p200300d82f1af4005a9fb1bf4bb399b1.dip0.t-ipconnect.de. [2003:d8:2f1a:f400:5a9f:b1bf:4bb3:99b1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fcacf0bsm4625237f8f.38.2025.07.25.03.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 03:10:08 -0700 (PDT)
Message-ID: <649565be-eab2-4783-9595-b4263ac50310@redhat.com>
Date: Fri, 25 Jul 2025 12:10:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <4f66d89a-631a-43eb-b4f9-c9a0b44caaae@redhat.com>
 <692f9624-e440-4cf2-8202-861c679ddb73@lucifer.local>
 <0ad414a1-9a57-4050-a7b6-fdea08aebbd1@redhat.com>
 <507a09cf-291c-4886-92e7-9d9cc294a247@lucifer.local>
 <aa839e3a-11f3-49e1-8c3b-a60106c8d165@redhat.com>
 <d055173e-233c-4513-ab40-d7a10a0b81c9@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <d055173e-233c-4513-ab40-d7a10a0b81c9@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VJaQHorUGAAZPKBeVAOh4ch3k8flP0O4oCntSlywSNI_1753438210
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 66A6712000C
X-Rspamd-Server: rspam06
X-Stat-Signature: w3nfz175w8kr3wowur356b5psmsq1ezd
X-HE-Tag: 1753438213-276090
X-HE-Meta: U2FsdGVkX1/YfGa9C+Q33QgF24B+vJ0XpZI0q01+Dzk4PpLLZMeSkuW5CeTPvfmieqieH6lGOSgvhX2+mCVruzbSDe0b1XthtS7hvGetbpx6LVPXetV84w981tRwm0Lww1A1RpFwcCWk4/B7Du2TF0ZQNg74XESZ5clhyfdTTMnJMOnZIP/6JHnnF/sdDL6BrtrrFOWOfUM7zk+pY2oqm+A5olQf4WNwCR0MDjTFOafdJ58JyBgZIDPjlHxKBXjWv/hHzkkBoUXYtzxd9pApIoZr6Gf6W2abP1byEAHgnC4xSJjcYUtZO6GTJ5CRKN/LmGiDWhpTmj6IxvOKJItmSfZ4W52sg5uE+/lVqCSgfFLatBA6Z8wllUhBmcQK81rtmChMHv5lMoiogJ0I0tvidXkTOJDokMCirBLWVdXBJRmAdOLL9aVgp0NbI3k5OpDRQN3YfoS7tBrhlsW7PgU3DHsEc6Gz6gwvEqcGuznYTlxjQstCcqKS9WQN/J9uzdu7O91wodMTJkzRHbCsWuTlatwN/tFnJki+w4PtsStYAUdW7/wa0tgmyef69sWTMycMKtnJEP6td9MbdwkAfUxVSssUjT6ofabM6C5uBw1/eS9O+wKGIOkpWWCNQnTTwOI2t6Hss+MeD7LPUeiUFYvmJ8mIqqA1sOpaiTjhJheQ5sfFAD3TVoSApWDZxWs2penK3yXgiDwgrO5+SuSjD1Sx2y1XvCjmzahJUnqgpIq1xbNaq3qkLkL5n9BYbb7Khph8Nn9RZ640OLmYC7RWl6+7OiVhzpxWwF0tJ9QM0/q8xmUmfzVP96zTO98GqV21AOTdZrqPrU6lZqj982FO59W2fpq/vsbUNVctWozhWriE2aXFwt9DAUUFH9GiWlme+UaFQj10P/YbJGBsCdqcJtVzWBi8oWdA08eXuM2mTMVA9yziqhYKo4ACbhBRb8WGWHXlzZVHX6BO/nGTUE/19Lf
 0WLMvzIt
 AGGflgW5CG3rZ6I6m3DYuxgAe3Dgnrs5U5z6PohCXLRFvdZ5URoOqyrfNf8il/6u+hG7/3OjfOyb0yE4BrzBatn+G6eMUaH+nqSjl7OGW3hobRkmOZQSMm4xC8AOUgVl+iACZyFCN4B14BEvv3b2C7PDFJvvh7HgAVeiFkeF4usBeMWjfR0bxqliBLXjirE5p5v+p4sRgiZmxrCdt26jejSuxNV6NuiXzrx1nB6w5RAtQSl2evLHBWD8exKkRAxyc5txLR0IlNkUxzYwvUaoVjSFvvD0eTTnqJI8eoTTcT0L5nShcZvRdBgGolLtxO0crK2mKwaMxujVffOE1qfQTeHLZ3VQg00+KBraDLuouvgwPkRu6uCyyhoPC7oPARca6MLrZU3oNEm6Q2+yU72A10mZdifbMWgBVsQ9dEieWo6jAy+RxhSvZN8uQ6V1VfiCgR7FCtGfQJRipRBeqR85FKbdN1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> So - we explicitly disallow FOLL_FORCE write override for CoW file-backed
>>> mappings.
>>>
>>> Obviously if FOLL_FORCE is not set, then we're ALSO not allowed to get past a
>>> FOLL_WRITE and !VM_WRITE situation.
>>>
>>>>
>>>>>
>>>>> Hmm maybe I'll soften on this anon_vma idea then. Maybe it is a 'cheap fix' to
>>>>> rule out the _usual_ cases.
>>>>
>>>> Yeah, something to evaluate.
>>>
>>> I'm thinking more and more we're probably actually safe with !vma->anon_vma ||
>>> !(vma->vm_flags & VM_MAYWRITE).
>>
>> I think there are possible races, the question is how much you care about
>> them.
> 
> Yes I was just wrong. Please just disregard.
> 
> I mean racing with MADV_POPULATE_WRITE seems a niche thing to worry about, and
> so what if you did, it's writing a... copy of the underlying file-backed folios
> no?

MADV_POPULATE_WRITE does not apply. It's only racing with FOLL_FORCE, 
like debugger access.

Again, a race one probably shouldn't worry about in the context of mseal.

-- 
Cheers,

David / dhildenb


