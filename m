Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E86ACA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 16:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDAAE8E000F; Wed,  3 Sep 2025 12:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2938E0001; Wed,  3 Sep 2025 12:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1F08E000F; Wed,  3 Sep 2025 12:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A66CA8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:14:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BFC513AA67
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:14:33 +0000 (UTC)
X-FDA: 83848436826.11.02437D7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id B95C010001D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:14:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c3IIu6+R;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756916070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bzt9EmHzCNTi5JpIlfAxwaC9x9EuNT1d//8tcvBDG2w=;
	b=bsl6f0p0W3/QjHiu2MdOHHRR3vjpYDsUA8tqu7dfwwIQ7JrMrPwEOEFk+cohNMECOL2rWv
	fXQB7Ab8urrZwisFUJI41auzdfv8zWAtvJzWWrv9eWq8C8VN5xjr1iTF8jpQekwhiSmt2k
	GYn9FyuU5Fq7Lxp3Vm2EATeqlsUyWTU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c3IIu6+R;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756916070; a=rsa-sha256;
	cv=none;
	b=1Gl2kX2utA4hSFD0ev11UYs2FBakackyXdwmqODY9eM1juWN/C5M4bZ0eJDdiRe9h2qAbK
	kSxxw7PqqZGblLH20aIAiZyykEhgPsk+6o6YJsyf5E1xBVT4NzbeR7a19HUm+118eFNXJj
	dHMX4nHXa4sSw90MvRsw8dDydYs3DBM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756916070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bzt9EmHzCNTi5JpIlfAxwaC9x9EuNT1d//8tcvBDG2w=;
	b=c3IIu6+RMNCelEvpLk0gxQUSz6m96H4RQgGg2jRvuOgGyCM+w0p0lXoQRturijowMuhwZQ
	EhgmcNmLNNrRqTg4jLbURvaOuSjGCz4cROC7ZvXOIfhklwQfZL+1K6WwsYveTKHox/u5oP
	9BEMSE7Te2VHdSARwbPDDWRYXpq9nwo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-6b1Uq6Y5Nv63tvkTLbc4bA-1; Wed, 03 Sep 2025 12:14:26 -0400
X-MC-Unique: 6b1Uq6Y5Nv63tvkTLbc4bA-1
X-Mimecast-MFC-AGG-ID: 6b1Uq6Y5Nv63tvkTLbc4bA_1756916066
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b8af0b986so96645e9.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 09:14:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756916065; x=1757520865;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bzt9EmHzCNTi5JpIlfAxwaC9x9EuNT1d//8tcvBDG2w=;
        b=I0vD7tojfwRcymzdkB3rnTjMeKQEln/D+a4/oBUTq4D8iZZ3968UjnYI8GH6qj9BPu
         IVkeT7viO17YJajU3QDLIpLLyLpcPoSWNYSeDTRdQW3IqVwfP/wupYoFiUqh9CsBsujY
         54BLSZCLRzL7tkKQwn/4+BG9Yt3gzUXBr77AviSh14aV/jXC+JUBPi2Tocm/Jx3nnMXt
         VBj7MHAjQ0NnVu2uHiWkTxESYAeVgHZzRWFATvlcvuJCpIZn5lUBycmYPJu9bsqWyD+G
         4Nga5gzeysh8cB5q3GSx0B+QsCXbqL6K0SBlaDFUcRkPmLxfBskYybxhnhtcxwfVlQlt
         74Og==
X-Forwarded-Encrypted: i=1; AJvYcCXT0ZqXpyBtxKFvvwnr+mBV0VtWkl6AOZ90GI76hFZhdPfN0ZoYraJflb4dCDYY1pb5JMe5P1qehw==@kvack.org
X-Gm-Message-State: AOJu0YwKxSUyo4xrSS4ZaaxQawffBne1+qcl+aVvxvXWUphBiLf5Eq+o
	Rd6Y/rq/HdDUcCqy+cpmUG6T2qLGcKh1yRmqqaKm6NdjHohDLfRAVwGz2mgjYMaEJWBeo9BWxBh
	3dDJ41fz9WelyRmY8yaAD2+ZMgbBo87et7kizePD/EtqL07l7a2+f
X-Gm-Gg: ASbGncvPUsfFvqkOpeEBl49aZJ9jpItvLofcfGu1fo2Ei00EuGxGbMniWTCuyUO4DFT
	z/H/hkC1UikYaEaW4TWpLNT1wR3hrxc5uBeThMAgRZ0pTRo5iDdSlxix5Lo9f6reHmkH/qoCLLg
	oLAOzfx1HT0DsR6ZRQ9AmUOcH3H3YkLVKfVojrM2Vo7nUmRaVK6CHEV8SK1NB2JrpzQzfbH2pYf
	9PLJu0DhQ+zYPb8g6wqzId0pXPwflaIII34kagIer21jnfxZP6qhzZDch4Rvg6EH+VNydrYgzuy
	wbkKU3sONYbICpXGRSjfSiTVBriGMw+tyDY3pT2z26XGE6AMWH9v9qYCiNogNKD2NDF0L+Hc23A
	rqilfMc7aU6BtMSPiwnSbuGTx+iynnYOtG87LFE+sw0loYFIwThHEBtf8r7yjMMf6bNo=
X-Received: by 2002:a05:600c:c4a1:b0:459:443e:b18a with SMTP id 5b1f17b1804b1-45b8559aff8mr148123295e9.14.1756916065569;
        Wed, 03 Sep 2025 09:14:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrG1gLsbYnBIn3I8NtcnWq9Wo53kgjPvmlGfN/iDdEiLF/Lvowr8NqtI002hGo3+RIVMQJCw==
X-Received: by 2002:a05:600c:c4a1:b0:459:443e:b18a with SMTP id 5b1f17b1804b1-45b8559aff8mr148122835e9.14.1756916065025;
        Wed, 03 Sep 2025 09:14:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9a6ecfafsm79703055e9.21.2025.09.03.09.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 09:14:24 -0700 (PDT)
Message-ID: <78b9c23d-98ce-4b06-9acf-d36c58777d56@redhat.com>
Date: Wed, 3 Sep 2025 18:14:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/9] mm/cma: Allow dynamically creating CMA areas
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Frank van der Linden <fvdl@google.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Sumit Semwal <sumit.semwal@linaro.org>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
 linux-tegra@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 linux-mm@kvack.org
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
 <20250902154630.4032984-4-thierry.reding@gmail.com>
 <CAPTztWa7kcx8bBEJEKvnjcD4v1-eDLVxMd9C10XiBQi4CDLfHg@mail.gmail.com>
 <e513c127-d4f4-4e93-8d4b-23d1e4fdceb5@redhat.com>
 <g34tb2ontlnazift3sik5dqs75a7k2bhzo74kknkxoegv4q5vb@jsqo7v6awovf>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <g34tb2ontlnazift3sik5dqs75a7k2bhzo74kknkxoegv4q5vb@jsqo7v6awovf>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wa0zyfPEkhaUni23TCF5apOwZJqNG8ZFIXXEt_Sep8U_1756916066
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B95C010001D
X-Stat-Signature: k6x199jfxq5ji3zkddaymdxt9x99ecj8
X-Rspam-User: 
X-HE-Tag: 1756916070-483131
X-HE-Meta: U2FsdGVkX1+Z8cZE2vS5KKE7edghKAt4SgQGz/iMC57/mBnCgFX/CHVzAybirHX8EzpVXBA5NKzwbePkwvJXY3sX7zdQVHpzQ0MbpfnJT092OGvyiZwf15YhWc3q83LCPVT0aBE5y/E1MM6EUCrqfOjbMandKcpkmXbJV1h7DvLnRH5BBvJoC/L1iwCmHnSDv+89ZFakT1OR7gOtj3AD+ftxi9Tudx8BTwk7h2tZiskFDyewTz8sZrARyDKrq3PoAYex/58up/vBle5u3zdeVDEO4sKYvOOM/8m7rOPweyy2e/9X9onggY/SsYOMsEd+I0PRFffuKFO/oILNqBKzqeRHhEKEnn9Khztk1TX9B39pl90EWVfPrUJ24b0NgzDSo4Xb/0xglgSKi/8gK3AqMipCQoJg3dGXud8qICpPj8vK+dAyI+X7eP0MUWwWvKqU81WbYBQn91FLG9iQpHUjDN0vWFNUuR/VLg21VICy33eY6i8gpbWmuWHVeFZ2eQjAENajPA9mA7ROcdju2LYKNlvNk0aYwAi+K203pNPP9pMrPMAbn1G7cVPUW9FiH8O5qgGGMIkTzUqAHDzesZTjSLvciW6yRxt26rp9ys3eXNsQpYLiNcDOpudd1Bb+Hj2WEZG9iK45Q/9+wT/VQHENHtxbX3rjMk2etgr95o47AiCzUgmIUYOyKq4CBXiDmvHtim4KZxVe8pX95BXYispUCTa5u0GzdBo4mJ0XyTIw4J7qg4yfiol8tg0zbGun+8sdPxxUM/tnZD08A7ze3cBjSKXoGxLrZotHftQY1FZjOHT9Z4Er46YT4y8m3iOtSpOzrvi4gr1OLp2HpytkMae2ZaCqNdAYgNFuQ0Heih4kJXHDS6zPx1KJVYoynhBbleNJKYnRYtjrMhIQd7cGAjblV7izK0NBw4oKLBWcNVK6GKLBBUkTD+UZpFoX34WQ3iJB+w5X1q+2Xz87sAb0LQY
 ilE5N9pT
 UhimoyKW9X1FQzi0ztV3BWK8nlVwl04VFA4JwkedXENWy9K9qptBFaodfNLNapqun4E78MLP3uLCcxshhYkLkIcurn6Fj3YxtAkR2ci0Of8buydf421rnarqRzqqqQpYEwNzqbDa+bL71HFeStr3zKJWlnUj1JSB0eZk/iA8q7NvHM4u2uJMVLQY/rPZjAUehOwTx+cbm658s5epAnnV1A0JZ+keaMLVi3CcqdK3jC2GCDnhpI+n2ibnsuBh6TlQFMqQb083oCFfHGsiW6Y5QxD0+kQiNf7H04IiTccErbLNHBtxGoeV4aLexW614Ohc9WuytbAa2ARhw2dkJ4htC6ez8/F0mHDbPjJIUtz8ruwq7MVQ0pZCqwwuOwomq10uXsMHlgOW/57uoJkFJl9uzJW7N5j8MrJ2h+edWrVHRWBSGPCzw87lWPxygg7/MVJ22+AfGeFaZCgcSihjCS9Lkrw94kHz8FAxec8ovnQ9lgJSdWPm3IpJY8BupXTeqUmhjDfqdmf+Nwep4Ren1wcmPhaTc0Mnz7Pjie0qESi0k4bnoYLlIoMkR1JoqDfq3V8W+ybJ5w1QWWVVIHRZyhceXg1StaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.25 18:12, Thierry Reding wrote:
> On Tue, Sep 02, 2025 at 09:04:24PM +0200, David Hildenbrand wrote:
>>
>>>> +>> +struct cma *__init cma_create(phys_addr_t base, phys_addr_t size,
>>>> +                             unsigned int order_per_bit, const char *name)
>>>> +{
>>>> +       struct cma *cma;
>>>> +       int ret;
>>>> +
>>>> +       ret = cma_check_memory(base, size);
>>>> +       if (ret < 0)
>>>> +               return ERR_PTR(ret);
>>>> +
>>>> +       cma = kzalloc(sizeof(*cma), GFP_KERNEL);
>>>> +       if (!cma)
>>>> +               return ERR_PTR(-ENOMEM);
>>>> +
>>>> +       cma_init_area(cma, name, size, order_per_bit);
>>>> +       cma->ranges[0].base_pfn = PFN_DOWN(base);
>>>> +       cma->ranges[0].early_pfn = PFN_DOWN(base);
>>>> +       cma->ranges[0].count = cma->count;
>>>> +       cma->nranges = 1;
>>>> +
>>>> +       cma_activate_area(cma);
>>>> +
>>>> +       return cma;
>>>> +}
>>>> +
>>>> +void cma_free(struct cma *cma)
>>>> +{
>>>> +       kfree(cma);
>>>> +}
>>>> --
>>>> 2.50.0
>>>
>>>
>>> I agree that supporting dynamic CMA areas would be good. However, by
>>> doing it like this, these CMA areas are invisible to the rest of the
>>> system. E.g. cma_for_each_area() does not know about them. It seems a
>>> bit inconsistent that there will now be some areas that are globally
>>> known, and some that are not.
>>
>> Yeah, I'm not a fan of that.
>>
>> What is the big problem we are trying to solve here? Why do they have to be
>> dynamic, why do they even have to support freeing?
> 
> Freeing isn't necessarily something that I've needed. It just seemed
> like there wasn't really a good reason not to support it. The current
> implementation here is not sufficient, though, because we'd need to
> properly undo everything that cma_activate_area() does. I think the
> cleanup: block in cma_activate_area() is probably sufficient.
> 
> The problem that I'm trying to solve is that currently, depending on the
> use-case the kernel configuration needs to be changed and the kernel
> rebuilt in order to support it. However there doesn't seem to be a good
> technical reason for that limitation. The only reason it is this way
> seems to be that, well, it's always been this way.

Right, and we can just dynamically grow the array, keep them in a list etc.

-- 
Cheers

David / dhildenb


