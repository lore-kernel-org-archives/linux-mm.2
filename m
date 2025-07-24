Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D623C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 21:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226696B0092; Thu, 24 Jul 2025 17:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D05B6B0096; Thu, 24 Jul 2025 17:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF466B0098; Thu, 24 Jul 2025 17:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDB796B0092
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:54:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 731761DB183
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:54:00 +0000 (UTC)
X-FDA: 83700511440.25.451CCB1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1C666C000D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:53:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OpycNFQZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753394038; a=rsa-sha256;
	cv=none;
	b=plmMKOOUgVk4nUWofQ+IaqU4WByO9gA4vQ0r2IAB7efqT2j5PvjmJl2Ef0wPicPapQVj+u
	6hi9+whpc+PYyn0kqCjm6UcGESF5JIDssEm4KhJVvb3YFW+eWnVgxw9sEVEfrxZ/7Gi82r
	4G/7mckGzXF/wIK4yKk/Gu24Oqu7HAI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OpycNFQZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753394038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jXLN4SsCK0ZOlY5y21K92auQYthqaAwqTZRZM+NRLdw=;
	b=r5YM4//HqU0ckvGUmAKJlWybc2rCXj7yhGXz2+4wdQmx/iGs61/iDqAAnopWhAC3QaVvaE
	cZH+MJlo90udAZmvD8MplsOd/+PNbM/Mz1ChYT6DBIOjSkT9PBjJRGtqxKFDz9/B3W/jZ1
	3q/+voOXAOD5LxF1EUGE5qVVutZMzTQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753394037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jXLN4SsCK0ZOlY5y21K92auQYthqaAwqTZRZM+NRLdw=;
	b=OpycNFQZ/xYgtwXd3kiZj2QX/LXIflzLWzSfsF1q37p2OKEfEYPe1G4jzPYqwHhRGfniTH
	wJvXrb85rnwpLK5miRTdWnguZl8naRinOPk4462wHzO1e8M7gVTPwZ/JRKFkpv6HVHWTIy
	mDG780KQamiPvH/aVS4TnSfkU1XQCB0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-C5swodLkMFap4GdtvaG0bQ-1; Thu, 24 Jul 2025 17:53:56 -0400
X-MC-Unique: C5swodLkMFap4GdtvaG0bQ-1
X-Mimecast-MFC-AGG-ID: C5swodLkMFap4GdtvaG0bQ_1753394035
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4f3796779so816130f8f.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:53:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753394035; x=1753998835;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jXLN4SsCK0ZOlY5y21K92auQYthqaAwqTZRZM+NRLdw=;
        b=YLxBY0/CqFujeCTdMUFE0IB5kqMOAg1NKz0gTDTNY+G4sVzmpynPyBOvg3KEYuJCRj
         7gcl6DRnNptAWGvjY0f6HXfdlt/A/4uoE3x4sG5nwEUgIetYCqZ6jwqYvOvDD0zehdi2
         Ra27rlDMbFkjc5NyoAfY5sgKYX35zqW94TzDoCYemvPvJAM3YPqZo2vC7kUaCcVs6XwK
         E/RX7Xfb5BUhjiftKlN6CVXmiZHCyfHMtmV5KnBjcV1LMfLtRrSTNpZn1CG9XIfVl7gP
         ByXbJI/hxn9FGTNAr6dWKfZMWw9e2cVCGSlPHG19yU/IqIfJ707V8zUi9SI5c9r/FrFj
         MCjA==
X-Forwarded-Encrypted: i=1; AJvYcCUj5DhFmEBhJeSk9dSUx5LYCzZFwgXP5CG1yaoXmeD/TXCmRwe2KrwBPxPZOFINc4AS4soiZ6yryw==@kvack.org
X-Gm-Message-State: AOJu0YzEy5220rkBEiOkJjrqygmqcOgf9ahAbttu9IxGkuqb1loUFNrj
	dopozImd1HVlxR0IE2kNqWk5ojCzNqy1GzcbSkju5xthoSwPSM73jr/7RpvD8dD+6mPAZbwl3VA
	dMfmeikXdvruWcH28Y5bQQUN48xCgi/qsH6YZsGpnf+q1RaTdPSaF
X-Gm-Gg: ASbGncuFoD/iHad7jxAYuErn3bCzHmEPUn7EPmeDk4X2ePFCeqzXt4cHPtpT+W0Qf1w
	YvNB56VvtDDqM3S27xcWVc+MgI2i8epMMaLz8GDV9D43scMMrfg0jj5Se/5jRmBiEBjidWgi6EE
	h/J72qqe0bx197DyfjOIRxGVNIV9l13B8R6bdNAn22LJ7xsz0WGoZd6nfuRYkc6K5Z++w/VLYE3
	8EqBtcwgmnQKK6p/gxHKeEutZUNPtLLSsu4qNe9rbuilYnK2h1roH8OdDY6+dAP3qXOier2xdIQ
	J1RLfoVNkaxsY4H6/JTm0bV5TILtFmDFbS5DI/kplAKwoZZVDnh7xYdeN6c+m9B1PsD7MiEi8Zf
	5lTUvueosSJaZcrxdUzYHTrSXSHOc0/AJEEK5kFK0ip3DNAxfYGBWgGnx2za6g+7vPcU=
X-Received: by 2002:a05:6000:1ace:b0:3a5:2949:6c38 with SMTP id ffacd0b85a97d-3b768f14a6fmr6764491f8f.52.1753394034740;
        Thu, 24 Jul 2025 14:53:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkJOWTq8/VD4bvUr6a2rEovzwLN5dTrmxK2FT42yxexbPhNZb6gZWZXp4oLGU60o1OpU2tGg==
X-Received: by 2002:a05:6000:1ace:b0:3a5:2949:6c38 with SMTP id ffacd0b85a97d-3b768f14a6fmr6764479f8f.52.1753394034223;
        Thu, 24 Jul 2025 14:53:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f01:5500:ba83:3fd7:6836:62f6? (p200300d82f015500ba833fd7683662f6.dip0.t-ipconnect.de. [2003:d8:2f01:5500:ba83:3fd7:6836:62f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fcc3ccasm3300445f8f.80.2025.07.24.14.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 14:53:53 -0700 (PDT)
Message-ID: <9c861191-ac9e-4d26-b2a2-1facfa45de44@redhat.com>
Date: Thu, 24 Jul 2025 23:53:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Jeff Xu <jeffxu@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>,
 linux-hardening@vger.kernel.org
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <CABi2SkU75e7tXcpgnLbDhqSJBWVPOvmfMh2uPsU3mUjMUhhYqw@mail.gmail.com>
 <38ed372a-4b27-498e-bb3b-f95792bbbe27@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <38ed372a-4b27-498e-bb3b-f95792bbbe27@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f2Dg2ku663sK853dopfU6QPn7RNTyvW-wOI8ZMd0g9E_1753394035
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1C666C000D
X-Stat-Signature: zrp6thqpnwhayuj1afku5tdg9wgxz73u
X-HE-Tag: 1753394037-136535
X-HE-Meta: U2FsdGVkX1/HPgm8sVhVj86SQibl0GlFCK+Nuqs//38noryiYO4mKyX8nJoBB8U2nooPT4ASEM/rhSqNMc99r1ZHLH6sqNaZnWAMGwfNMjXlLMbVfI8i1gx8MWfcxtBLROk/O0DlBbSP7QFOwEQaBjKhiNDEEDq0ThGwZp7fZviiYF5JfpnkJWTLgsDORjJS61bZsSCranHvPZAbWVSAsGKoPkH2cxFL0ObMT0zLg2871pRZ0NgVBwkqBHtVp5GVL9Qr5RiM3XNH3Y0TFElqAs9S0lLxanqf6gYPQFoL0PhWiSRzlce2Ch3oi5XIh1EnaRrfQILtqD0rZUGdwYjPYeB/CEPKeTd1+iqO4JpL4qZv62QGSwLelrZbSJPcK1qDLcoPO/xDFrOtxHlM7BIC33k3aJxOc5wOdW6Gy9Nyu3OKyUqCl7sS03b5gc+Czi4cm5nzY4ogEgEB3S8ezspcs/WLQszFuVLNxVKEvFPHQC2eUG5IHXuUbWgvyLuxN7dqJaSm1dyskSCQAMwHnbltgVxTNgcYOypqwcMv6r7IlmMdZSW166IUUoeNUAIZbugocK2BXJ3XZz5+rLvjG2ZhujqgCKW7RkUxbj4vavN3yIwlNIElmgcCvoFeTyxJ+R4L8GA9HNUtuph0i9xh4i7usxQ1Lrydbt++DZOt9opcWtDL9z1RRcEkCagutnxh0ALbtrn9O5B3BB4T4C6FIJBhljWfjP3XeS/DFuoyytPvgiPoNzAFDRzkSJd0y7qpO4bymV87DAopz0oDqepM7WafknYbqMH70J8LhV73nebYQcSiBZCTGu+3VWtI3lS7v191IOAJgWE3BZc3aK5NAt5m7JVV5W/ILUg1wv7yFKkBJMrBipHnFMK0Rmy/dVit+kO6t1ZpS6ufLkQ7Sy/7prmI6YOBZ1nNglHjiYg7AwuImNg/S//NjiS7586dUkB+qdaMFj464sPwApcu3EAGjFz
 XPV/bdyt
 zdqB5hm8+nU4dDMF714Mc9BF+OGTiuldEvun7ahZ9/bwxJ1YJC7/rGhvvwAeAoyTr+qOBGSNwbtF9PbpqMdygE8J5f8eMJsGbZHMXVt4xzsZua6WQ5jfzSboX+niKCW+Zj43XlDzbR2zxLMqS1mfbcIsw+s/PKh6bAPQyShJr3LowxSV+umqhJu8tl/QrGJOGW3L0F2Ns9srSLGp+Ooh3hLwxRpbpCwqtO3qNBv2K+XgNim1lwx8TEjsC1d9tojnmGSKkE0AB334qtU6RBAGi/7TavQaxr1XtJdjCzShtJ8BFdt0viKTdk5M+TgoCIwsOtJYUegmyIQXf20jWkrnidpbKz0HtZW7OJC+rfDQmbN6QHY4ok1g+WW6IWxmfTg+d4wLByWILahyyiw2ZC9bPXwG587Ql7ZZu/9qGeC43sWlJ7x3fmHmgYq4FbAEhQGwPU3VEYAY16SuZm9IirxSwWFz5Mg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
>> 4. We could ask applications to switch to non-destructive madvise,
>> like MADV_COLD or MADV_PAGEOUT. Or, another option is that we could
>> switch the kernel to use non-destructive madvise implicitly for
>> destructive madvise in suitable situations.
> 
> Umm what? I don't understand your point.
> 
>> 5. We could investigate more based on vma->anon_vma
> 
> I have no idea what you mean by this. I am an rmap maintainer and have
> worked extensively with anon_vma, what's the point exactly?

I think, the idea would be to add an additional anon_vma check: so if 
you have a MAP_PRIVATE file mapping, you could still allow for 
MADV_DONTNEED if you are sure that there are no anon folios in there.

If there is an anon_vma, the only way to find out is actually looking at 
the page tables.

To be completely precise, one would have to enlighten the zap logic to 
refuse to zap if there is any anon folio there, and bail out.

-- 
Cheers,

David / dhildenb


