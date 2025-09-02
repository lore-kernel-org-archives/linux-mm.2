Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46559CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 19:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F1E38E0006; Tue,  2 Sep 2025 15:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9848E0001; Tue,  2 Sep 2025 15:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7D88E0006; Tue,  2 Sep 2025 15:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 367238E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:01:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BEDE8119952
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:01:50 +0000 (UTC)
X-FDA: 83845229580.22.BA95B85
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3447340024
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 19:01:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YqfLFrri;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756839708; a=rsa-sha256;
	cv=none;
	b=mQ63YFwxEZ9lUBVcZd6Ll+SYBt3sV65gATsx4tYyclIRyK94llCwmH9zx/0cufDDw2Xx/3
	FWyFqo7ZcEn0M+h4QKhFpKSbsUEEWSmnC9xY0qkkKS3+yM4sIDQnKtFvVxCuXzJXM6QKf3
	N6m4H3NId7Fc+UuDewCdMZ6LNhSWmAQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YqfLFrri;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756839708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xG8SHV8fzAAYJPex5gyHGD1o+s1vP7RR3dhhmyQkukc=;
	b=PlqnApavGZtvQ4H5MxvB0FyZU2QXMgHWRLgkhdjGmjNL56W9OaZYEJaz+8FcO7L8Tr+oon
	BPWGIPmu9Wg2mlEbL8Y0exo1CcFLPZmiwqzFp0JeFajzfv0ot/YfUUFSLTgCg9xVZ9VMhu
	wSMWNzdXj55MO2v2VV+r51e1zCd0Gjc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756839707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xG8SHV8fzAAYJPex5gyHGD1o+s1vP7RR3dhhmyQkukc=;
	b=YqfLFrriz4me99Ca0TaJnFLYYxZPSFbsOcwkMDRCRqKEJwrKqE44YhygZ1T8iGoH3oShVh
	BwkeHsVldlnWXSb3EMZ5zamAuZ4yAQ23GfBsACwlLCFVkwURMEos/T9YEQRU72V1OyHpTw
	loLgHawZPu7YKfLI/qsKG9DOnMVjUhQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-Uwev_9oONz-P_d9n4ugl3A-1; Tue, 02 Sep 2025 15:01:43 -0400
X-MC-Unique: Uwev_9oONz-P_d9n4ugl3A-1
X-Mimecast-MFC-AGG-ID: Uwev_9oONz-P_d9n4ugl3A_1756839701
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3cd821eaac8so3441421f8f.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 12:01:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756839701; x=1757444501;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xG8SHV8fzAAYJPex5gyHGD1o+s1vP7RR3dhhmyQkukc=;
        b=K5iwBka8rh0qE3LJPCPLCnDKVO0vI0oMFBmkWW/B1xnaMJtPzEi6S+Ia2BBWHbB45n
         kStI2hV3+fykYu8+0oBoDRFFTTI7VXeFAlYKTta6y/95Tvk0sxxgOC95a2CtLFHImmzE
         VE5BQwQjjQHekFdufug+hNb8Hd/3jSR7znFaX9tf7q5K7ho4ETOnU3F2d9cKjuZ9axNk
         v6XPI+Dwr79zyL2nU1NEm/goFosLhd+iDTSs5ks68IRRGmye+SrN1XCQ5aV0gqwIA0dt
         Xx05ycrB7LflRQ5uTd7XjZpLTXe3NBK2fJUpYMMDLWy6G5D579E2lqjKchUlZ2tBv5ao
         werA==
X-Forwarded-Encrypted: i=1; AJvYcCUpOPlPpKtFfzwdxT2VB0uHdp7wYRgbNiJDInGO1zIj402MsTMDUDdj+QaV2/cSUcE6IPQa3y1SWA==@kvack.org
X-Gm-Message-State: AOJu0YwUuMD4II6NHDZTLvIRshtN4DtzOCxLbfms0nIszpcHuC8QgDGg
	UjL9ZRpEbNOt6GFmbWR8CLhp5URkCic6dRu1uIRvHAHZxSNUb/OceDC+TKpJz/Yu3G2NaiFcG+G
	abNUxSmICiFV88JvJpiaKlEwNDd/1xP5tnIJPwMTkRADg8uir7peg
X-Gm-Gg: ASbGnctGtMB3dhH2mtM4Y+A77cbQbAZy9Eyu7tE3l3JgX1qSVuqWiED/gil97xNVBuL
	OpT79+mnbwGj9AdtT9owyFL2AKZO4fHAfPw3iH1SD8Ze4imSV9HllGkQvM7oYydsG1krznvG0KE
	iEoJIFSc7urlw3UE+JOu249i8Dxmr9pSNN8Igv+phl5PgiqAVrGZrYl5c+WO9z8+2Xpwn+9HvO2
	0pXIHl7hgZp3ZV/Lxrau31RsryVp7lSL0zWtKEnpQulxP+Hn8+BLMhZhpOKVNKYdzkHogI1PQDg
	GMYCcsm7QP9HcmHhvge7IiPXRc55tKVWKzXrLUjP1INtSjwRF9yEpxKRJwsO0lkhjMAop7+C3eC
	WJJJyAwy3kxm2fRCiEUY6vo+HWT4e33v+waZwDQVNx6ehF6xdbzbYkiD0c7GVnt/l5Ug=
X-Received: by 2002:a05:6000:2309:b0:3c7:516c:f664 with SMTP id ffacd0b85a97d-3d1dea8e3ddmr9433571f8f.50.1756839700821;
        Tue, 02 Sep 2025 12:01:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZuKmy5+kpBqtUCz7rFUogMWS9lJklSyblvxp1qoAtN7Sujp/LvaGOc8MXn3Bui6WUnliXSg==
X-Received: by 2002:a05:6000:2309:b0:3c7:516c:f664 with SMTP id ffacd0b85a97d-3d1dea8e3ddmr9433535f8f.50.1756839700348;
        Tue, 02 Sep 2025 12:01:40 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9a6ecfafsm35391745e9.21.2025.09.02.12.01.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 12:01:39 -0700 (PDT)
Message-ID: <d61b173f-ed58-4d60-b1a1-b93678371576@redhat.com>
Date: Tue, 2 Sep 2025 21:01:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
To: Lokesh Gidra <lokeshgidra@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Barry Song <21cnbao@gmail.com>,
 "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Kalesh Singh <kaleshsingh@google.com>, android-mm <android-mm@google.com>,
 linux-kernel <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com>
 <a0350dd8-748b-41d5-899e-1505bd2b2e80@lucifer.local>
 <CA+EESO73TRAcMWeo_aXkLM+0rT5nt1cxyvf+Ye3Xp9kqxL5=6Q@mail.gmail.com>
 <f5cb68a7-19eb-40aa-95f7-51fd004a3f8e@redhat.com>
 <e6b12ef9-1808-45a3-9d64-5c7fd1904b5b@lucifer.local>
 <CA+EESO5FnraOUV=CzcD6t_e086pC7rDZuVv4w2ng==7KacA=Pg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+EESO5FnraOUV=CzcD6t_e086pC7rDZuVv4w2ng==7KacA=Pg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BhM5n0TDmmfUrN7naFUrq7JpS3ShiR1_ZEnuHMcZNB4_1756839701
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3447340024
X-Stat-Signature: tazqo5qgxa3dj9san7gwsqmt1hnsghqs
X-Rspam-User: 
X-HE-Tag: 1756839708-803688
X-HE-Meta: U2FsdGVkX1/xR5tcyIpYT6rIKzdSboN7n3TgrHU2e/xJKvrgyhM1vZRDCor/+XT2Waog1EiFN0nMpTtfRQ812LK23vmhFnaob5xownLG+havNDm0Ktry77BLgmeAWLoiXEzv3wVOoP8HQR9NIB6Wu9vvmYxBWVpVKw2LOlRY1WjrAK1L2TT/dMzn/PNT+43Mf+5oJUGori/xzsESpti97OFhiQjfhJ2olrx7lwivmvDGEgU5/VoEitNpJScV9JMLyZ6JxyhU2gfK3UCfJD24XgPlVAzkvVlV4tCZlXdiek2kkhu/Jtat/V1BCHQNiYjkBmrcx6hM070Pe5ABqbi41R2iE9ZvZJ3KHhTRLLrLY2fGswiisVAyaIOKV5z97bje1uiEXECNbGFQaj2cqQCs63QcHGh2HhQSVQYZ6RuYhG/WHX5+umDBPvWSGnqpemfOSd4tqpVuWziojgd0xNpOMuTh87EfaTqyvJUVl+p7j0F4aEEy6sIf0jcSopC4YvqOfflenvFbeuJxkRS/3ni8Tcrb3d45GOulGlUAGEZFebp4fSY24vsheQXlQM3+KIge9NzIc07VHBILQwQ6d8IEUIx5IoaF11VnK5rNzMIBSTMTPSSp4I/wCMYMBew3DYvQVaQfEGwP/aF+FRsE6TeBb9wY486opsvLZs6fPshzFEcf0Rqe9rXB4iH4Zypiik4oUlI4QEnuPNTLpGCfOkbgAjohNItQywWYrUl6LemQ/R01c0rLkUb0KopQAia4uB6GH91YnR9kJ/Qv7UrziKFooXAeC21EJMqK7OGC8MtUNuwZTmdyquIEwDSrruVDXcZBTJuAL1BxWhtZcKuQhpFTSYqS7+/caUpRfyjbff4v+sbIE/3SOb1G4Qwqrqk1uz3Frw1NhHHsAtcNU4BevLVKfy0kFMzDj8pEwp02bhbI6xKT7wx/T7Jl9I6rmIPxTjFnvnwHFiHCr0JE8JhDXq2
 09EjD1bx
 PWx3L1q8Z1MRcDkbW8n/7b2dYpmIBZDXU3/bQFPdEUIN/KSKxa0iK8GP3pb3kEs/wwo9ouEMYTjOfKgA8fCESl9lXOz45RaBChe0Tnul/b2c6Ar/BqfQtv/W7fCU61OlP65GPM+Z+ee85jHKgjmKkM2tpnEfMfdIbAX6oESnNbN3RPiwx08vLpo0t8E9lLBA+AAhXccU5077nMzunDgdqp0j9T/ydEP7OD24hcFx8PVlv44btMkeHRMnIK1o1cTAoRJM/5Beo/ZFvBtzLk6+V7AhHJAj4M8ZAje9kC2DK75kTnW+n6f0CBzyPS9B3nUY3CUgXKe/MTNXemxFwb5G18MD5B7hx4CUqcLtMWXGJkH6O7e0V00TRUkEBcdoRDFz4Dn3KclJhXtgbtJWQ2clFlbIrGZx1hpLuZ7kjv+/s5BY84LCmPWYIvh218udDP4SbhI6jgs5A1GyuVV0s4f61Zt85dHE3M/7XW+8GwBqdyXv79cAIKzuR6o5Ua/skZuTkiTwjEbo2/WhyWDA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 20:59, Lokesh Gidra wrote:
> On Fri, Aug 29, 2025 at 2:04 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
>>
>> On Fri, Aug 29, 2025 at 10:42:45AM +0200, David Hildenbrand wrote:
>>>>>
>>>>> I do wonder if we can identify this case and handle things differently.
>>>>>
>>>>> Perhaps even saying 'try and get the rmap lock, but if there's "too much"
>>>>> contention, grab the folio lock.
>>>>
>>>> Can you please elaborate what you mean? Where do you mean we can
>>>> possibly do something like this?
>>>>
>>>> UFFD move only works on PageAnonExclusive folios. So, would it help
>>>> (in terms of avoiding contention) if we were to change the condition:
>>>
>>> I think we shouldn't be using PAE here. Once could consider using
>>> folio_maybe_mapped_shared(), and assume contention on the folio lock if it
>>> is maybe mapped shared.
>>
>> Interesting!
>>
>>>
>>> But the real question is with whom we would be contending for the folio
>>> lock.
>>>
>>> Is it really other processes mapping that folio? I'm not so sure.
>>
>> Yeah, I might go off and do some research myself on this, actually. Nail down
>> wehre this might actually happen.
>>
>> Generally I'm softening on this and maybe we're good with the proposed change.
>>
>> But still want to be super careful here... :)
>>
> Anxiously waiting for your assessment. Fingers crossed :)

I'd suggest you prepare an RFC patch where you neatly summarize all we 
learned so far. :)

-- 
Cheers

David / dhildenb


