Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C45C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4C566B008C; Mon,  4 Aug 2025 08:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FCE46B0093; Mon,  4 Aug 2025 08:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EC476B009E; Mon,  4 Aug 2025 08:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1256B008C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:18:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54097B74CE
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:18:24 +0000 (UTC)
X-FDA: 83738977728.04.56CAB70
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id D0EF14000D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:18:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CFg0Oh2Y;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754309902; a=rsa-sha256;
	cv=none;
	b=tsLt+OmUezraGRYEcLPYxKLT6HbmN8QcrFmXDHJ4rdcRIC38KyxNQqOWpC67OG+ikIM27M
	ljiq6tFoaXrVeVvSL5zi18yuizY6q0BwDH6vQiJj3NotBJhAbifGcBQQiFnpqA0V4H3bsz
	V2pwnBegYC8mDoR2Ecbd9pG7WOhnL/c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CFg0Oh2Y;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754309902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aP1j/ubQX+lP/A8PXryWthbp18R/7thL54KlRxdc41c=;
	b=7J4T0jtS1tVyJCDjNHWkamgPS1RV6cqM/4UvD0USDicmjWsz/AzEcnphqSLzWIU2kzKCQa
	5TpOVKJdp9w5Gu2247hqBidbB3dRUIFKp/3wC1hIVvcyFL+L9wO/va6WmviHKJR/RaLn8/
	BSMwFVcW6OqeB9Pf2ZVOjSYs1VAfbwo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754309901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aP1j/ubQX+lP/A8PXryWthbp18R/7thL54KlRxdc41c=;
	b=CFg0Oh2YUEyNM24/deSss07Em3DSa834zSvwg9xV7vTiNwwXa6++PdUZy6fbgIZwGMCi7i
	u6eiHHV2p14okwi4DGSIsCd+K821PZV5foJmM1kfOm2AyLdfcaUwT+jP0kPhcUlrQMqSS6
	9u7N8g5lHB3GJ5gOkhY3BYE1uFVIsIU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-DR63VlxTO9SZ89sCvoweyw-1; Mon, 04 Aug 2025 08:18:20 -0400
X-MC-Unique: DR63VlxTO9SZ89sCvoweyw-1
X-Mimecast-MFC-AGG-ID: DR63VlxTO9SZ89sCvoweyw_1754309899
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45526e19f43so10673325e9.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 05:18:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754309899; x=1754914699;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aP1j/ubQX+lP/A8PXryWthbp18R/7thL54KlRxdc41c=;
        b=V52c6VS/H0+XZnH7VMz7dSF2CT3bmy9ZgftoUmK63VuETEJwPiX6pr7I3UJf8FENYk
         jHMImWrEzuiS6nmhw4T/nzwnMdLejUCQI28AFs+3gjLMewN9SJoiAsKvzoRKBiDQ4A7m
         9t0nGvsKBDmf/7xFRfFJE855xFAdGS2s/AFwO6ml8TJ03Dt7r15Dxpf17jzT/Oxx2Bwj
         IDJW92DcrF6lXX8OWma0rTDcH2sSKPZEJVRwocsOeKbxjqBye8essYMhKJAUsHSbAMWj
         5EHRHFAht4LFlX9zghAI1vrLR3lCZUYMlSGpmpgUy/yJAeKkEAFSlbDuD14AAJGyiI6o
         u5fA==
X-Forwarded-Encrypted: i=1; AJvYcCV7WNiTEqXBMcdhxO23REaBauZLmxMXrcp1ZaF3aBwxZFjsIoh080LO6/3RjrOPZZdpKqqGeq6kKw==@kvack.org
X-Gm-Message-State: AOJu0YyNPo9Bnql+weFXJOnSx0KckiDbd0bsnUX60VhNmx3dEEDekoDY
	OS0dvrPn7hi5wwnCpZy60iXOFT3rY6BsMQjyPFrfQzmlOAt1MamuUXem4QEzWisZxNbBUQz/mBK
	ZO4gaLvLxkMUpVArJZzeripdhUu5EqH9P4s6Pi8AJB4+VieTn/DGT
X-Gm-Gg: ASbGncuGbWzfKyJahH8jTtK6cq3NY0WPoNMxNprxLvn5RRyvpvwUBisWTnJCrk5dcbn
	yKZy3y3m6MOG70UHdbkpm8CcvUMiPIrNIzm8M/t2K7jTD8ZdC+zQkZd1I2buccyOr3CITmX2PiJ
	sMGegy0CRopvNj7prAdp9pdtxrdR7hcMX/gWcuuxgegsaFfB4xnTuFg/pNqVYsyUsg2g17dJNY8
	8U9VITFMXfq1Ck0pnW2HvjytgL5vOO0M7vPEnP94tLegR+hkItKjo7cUrjEWPJlen4TQT5uTFqk
	yy/YmVNpsohC+sqV4VXnyaF+2dAihhBy79E4/YoM3bVH0Wt6cndBQPNUa8YqC0KRkTdR0p2xz+h
	dMfQ6klyf7kvkAnbcjLFLj90Pm7RwzHV6zDBpYvH9eOmiBOhwN3MZwazybBZbmqIL0jQ=
X-Received: by 2002:a05:600c:1c16:b0:459:d9a2:e92d with SMTP id 5b1f17b1804b1-459d9a2eccfmr32262115e9.5.1754309898620;
        Mon, 04 Aug 2025 05:18:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+2bCGV2C6/ebzafcm9l4NbmkmomX5W4derdkR7sRtPpZ9SM3xwRcTp42bRjUUnf42oqlN8w==
X-Received: by 2002:a05:600c:1c16:b0:459:d9a2:e92d with SMTP id 5b1f17b1804b1-459d9a2eccfmr32261825e9.5.1754309898198;
        Mon, 04 Aug 2025 05:18:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459dc2647f6sm15009255e9.2.2025.08.04.05.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 05:18:17 -0700 (PDT)
Message-ID: <23e7ec80-622e-4d33-a766-312c1213e56b@redhat.com>
Date: Mon, 4 Aug 2025 14:18:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: Eugen Hristev <eugen.hristev@linaro.org>, Michal Hocko <mhocko@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-23-eugen.hristev@linaro.org>
 <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
 <e66f29c2-9f9f-4b04-b029-23383ed4aed4@linaro.org>
 <751514db-9e03-4cf3-bd3e-124b201bdb94@redhat.com>
 <aJCRgXYIjbJ01RsK@tiehlicka>
 <e2c031e8-43bd-41e5-9074-c8b1f89e04e6@linaro.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <e2c031e8-43bd-41e5-9074-c8b1f89e04e6@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kusIupe7tAs2JZB01uO312lSwz_xrRqthjuh4MUJQkE_1754309899
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D0EF14000D
X-Stat-Signature: mhdeutibsdnstii6bhfihbyag5w6t9bi
X-HE-Tag: 1754309901-377254
X-HE-Meta: U2FsdGVkX1/XccaFrnDUUjMDGd2UYpmsC5IEM2UT8YvDJxVI1+Et5hy5+HRpXQqyPtHUXw+v3Z/0QQyYV8VZKkglj/8pq4QjDDgzz/LeQxOY5b04Zo7EyuTw/Ddeh9FO1D1EhFT6x7xu84hZ8VApV/6Mg75psNW+Irsj9/yTNwcP76NnAYqJKaubGkh+31qAF/d6QfnJwvdHZDHXjcMHrfnvRe5XWWSs5OLfAxAbuz+egGZbtmnCkTexoT5GIeih5w9MEsUpfsvnn9MHFzZENA+dPBKHaijsS0ZC6LP7PUq6c1xuSwkrLed+yb6goJiStKnTvDTEklOGU9lNVfhh58jaf3/4AxMzh1altBd9CDnhsQwApeT/SK2NK3fGigBHzQ+1qXfCX+gZskQPSnQ/8LJlLCwlporft1Ovwga+FCNcN3tMabRv4ZCM2vdmETjXLKF1qYz6jroly+psjIr+q2Fss0XGaZpg/V7c6HIKyY5rWUCgSpjEYayZVyr82ryRJ1sD84n35CDBqGGW+yK8k6qcDZNoAxmapWtZuGILSFcZirwlyRQA9F+kXXRyLSGmOTwz/yWPqBz5M+wR/raV/lWWK88MkAJK+XfJbYdFdyCW/2emjZNvw2h/nOON9lqQiyrsnkh07xyjvfLIbALS7oD0dEeTz8N923zpgsamk0YZPE0EJjbdxbsbbxLMN/TpRS5lfbfHnKa+azsB87c9ayIop9J08IrmADfSBDRqCB1cz7qta5ERLbf6b2pK8KRQ3gWLinHzxJrhYd85oFQBLANlVOogFuq3YX+VQuEtXW1pY2hoWP+st8qUaBRE62CORQYMT0YLkhhX2DQtpWBmwFyJkARp0HBHkFlyR+7Djjq+o2J+7qpB1A+aeJKNpte3buaPtjIA6ryF/J+zl5BsbCdQhAjfkqOLqkcaA/lHnZmUcfZqDi/viJJsZmIYF4wlMK/QozU4N9AhCEAI0EK
 I2N8B4Ea
 wMTtUOmUo3HQI178MPnNFtQanpc+FBw9OAHYgnbxExb/kVyEfvefufyFX+GF2195KChYnlAP0DJBdcw0wg/A5URFGdxU4bCrohXTW3y++vxvPRE4qZJa+IzFqgNvOAVoixOavWNZMc6Q1m6mJGECgBHgWnsuLuMjLfI3aOO4WK/lcBNM/ROWsN4dskW7t6gxa8qB/rKByZs/0+gWvraoQwZejF2El1Sg2SkRTcxNX28X/l7bMgeft+Wd9TT32//4y0dvh8SXS42joJ+S4CcLv9/Huio0YQ6dDxvGFHpTg9NgRM39tLFLd5tiS7vnciPMvVncrqQLaQVENBZXBufZeFr51G8E3lixWbzE1SMbcmZyjYeScogiC7aixaUd731Ol0uL1QFKzuZq7+rESvZxjQ4C69hAuHZu8+FKvrqxx5NjTxqOn2wup7X3rVDN7F+7mf3espKukvprC/6ZVClkVFU1lAmBbtFHU5ock8Ruc8vFcNDA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 13:06, Eugen Hristev wrote:
> 
> 
> On 8/4/25 13:54, Michal Hocko wrote:
>> On Wed 30-07-25 16:04:28, David Hildenbrand wrote:
>>> On 30.07.25 15:57, Eugen Hristev wrote:
>> [...]
>>>> Yes, registering after is also an option. Initially this is how I
>>>> designed the kmemdump API, I also had in mind to add a flag, but, after
>>>> discussing with Thomas Gleixner, he came up with the macro wrapper idea
>>>> here:
>>>> https://lore.kernel.org/lkml/87ikkzpcup.ffs@tglx/
>>>> Do you think we can continue that discussion , or maybe start it here ?
>>>
>>> Yeah, I don't like that, but I can see how we ended up here.
>>>
>>> I also don't quite like the idea that we must encode here what to include in
>>> a dump and what not ...
>>>
>>> For the vmcore we construct it at runtime in crash_save_vmcoreinfo_init(),
>>> where we e.g., have
>>>
>>> VMCOREINFO_STRUCT_SIZE(pglist_data);
>>>
>>> Could we similar have some place where we construct what to dump similarly,
>>> just not using the current values, but the memory ranges?
>>
>> All those symbols are part of kallsyms, right? Can we just use kallsyms
>> infrastructure and a list of symbols to get what we need from there?
>>
>> In other words the list of symbols to be completely external to the code
>> that is defining them?
> 
> Some static symbols are indeed part of kallsyms. But some symbols are
> not exported, for example patch 20/29, where printk related symbols are
> not to be exported. Another example is with static variables, like in
> patch 17/29 , not exported as symbols, but required for the dump.
> Dynamic memory regions are not have to also be considered, have a look
> for example at patch 23/29 , where dynamically allocated memory needs to
> be registered.
> 
> Do you think that I should move all kallsyms related symbols annotation
> into a separate place and keep it for the static/dynamic regions in place ?

If you want to use a symbol from kmemdump, then make that symbol 
available to kmemdump.

IOW, if we were to rip out kmemdump tomorrow, we wouldn't have to touch 
any non-kmemdump-specific files.

-- 
Cheers,

David / dhildenb


