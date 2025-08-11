Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E9CC87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 13:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31A78E0052; Mon, 11 Aug 2025 09:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09828E0045; Mon, 11 Aug 2025 09:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F238E0052; Mon, 11 Aug 2025 09:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D39FD8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:20:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A284311548D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:20:02 +0000 (UTC)
X-FDA: 83764534644.21.AA25389
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0971414000B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:19:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MPmO6RSe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754918400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgpMULjPzZBlSeJpyHnOmxgS/ZHJN16+NEixb3vEu70=;
	b=pJCbcemHSjF9u67YBOJ5xqAFA7mbNQ3V/B562gR2DmjTsAx/0k8LHLOwm86u4rGXeqkwSN
	xHP6vGCDbMNjWNleNzXNGkezoBa2MMDifcrE6NlHiWrkFQiqG6FzEP6XuaPW0iZr3s+mhR
	Y+im5YUHYEnm4RYrxOoYgYgojs2v5VE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754918400; a=rsa-sha256;
	cv=none;
	b=ljFFGwzVkSlfOtDdZHRuKlRLrPKo2Idw/lC8/1ccPMPcMggJZZ1ZdIVGppAWQ7eCoSemWA
	GCpkG4ECvGndaxNxXAIz1p/uGpNEWyHVpwccCKrffjrveqSzXSqcbgllE3cIMg7zZqnffi
	9GeDSZnFDQ0Vd/VhHoGKCtYclcZXutM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MPmO6RSe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754918399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bgpMULjPzZBlSeJpyHnOmxgS/ZHJN16+NEixb3vEu70=;
	b=MPmO6RSefD7K/GO/8U1/t/Hbi/AKBykML+5Pm0qrvUQYmNJ0VfKVaNUBOayZ7bov4+QaZw
	c1vIYsOWwrRDp+KJ4NoJWS70EQJSst5ebhvwAGKv+JmYE5dp/iTHlzJVekCJdS3kUQ6ssF
	0C6VMNON32BoD81JUHeObu1VvNmSb6U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-D7t-wNJ0NbetTHvwC8Pv5w-1; Mon, 11 Aug 2025 09:19:58 -0400
X-MC-Unique: D7t-wNJ0NbetTHvwC8Pv5w-1
X-Mimecast-MFC-AGG-ID: D7t-wNJ0NbetTHvwC8Pv5w_1754918397
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-458b9ded499so28698625e9.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:19:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754918397; x=1755523197;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bgpMULjPzZBlSeJpyHnOmxgS/ZHJN16+NEixb3vEu70=;
        b=JxlK46kcrwV+/RD50yGgg+1TH+aHEKA+91qO5nWQ381rPgHmaew5XJoVIFdWvkpuqU
         Ppr54IU6GkoqQff2aASbPZt2iCpD5rBqiXimlixQ7qaz/zS3iZaB8pr2JgHibZzop1vD
         qiCdF1IRKhmzh/1nMTPBirlGZeoPC3q1lpwaSibaoYjMKUeRwpGCPu4GSSdQ1aA0ROPc
         2AZ1+mCZNi32Trf9ihbxgmdRVVQyGQgJ8QBm6dtILv4RPbz2a6iF3Vkphbt6PzFWl4Ij
         sczl9Nl0g20ogys9an0FtZ0T9k7TVdcoQpoDYcdEAAFxknSP4zuPxof86v9otRuybS1b
         Ekqg==
X-Forwarded-Encrypted: i=1; AJvYcCUYSOOIDhioRBkApAde5p3zjJxQS1hjlUA9bORPRkweFpiCMKEO3NesgXUHmJkUrC/js5Zz2AR0Tg==@kvack.org
X-Gm-Message-State: AOJu0YwobJYfOXumFE897oPLgCHB65NqMFipKjFJxpgH9TtkC0siYI+M
	YjSvZvkIcZzBwmdNZyjxNLQrtfy1vMGcH2falpY4zc2JYexcOOQHZOdR527KZ2yiaAqTOGJWS+h
	HN6ht+JhoPbdkYCpEm/QJmrzPPsk3CeMEnbm/MnxoUqXZIwA0wIbu
X-Gm-Gg: ASbGnctpcX5prI3e+l5yVnxlAFNy5/sRL4kRbxqg/9IRKT+4bfukD0snRHsLaIBqqPM
	9PKEt0uLbQUnXNI628bwtQNdx3QkL8kz/VMvVsLyr7gughfl/PAU7rmgV7v5VVj9tl/+y+4iKJL
	xBurPVOwHJreW6w7Mh967AL2EH4FAfsbPOTcmNCAdMj/6FMO3kGeKZxSDUOlKAiU0IoFhrOXbmP
	OSGFVEe+/58iByxADL8ZzvuPow6buhsfCrRXiypUIgIbg9mTisEYLfu1g9CRawng7/CNX7ASxb5
	azEkB63Lygsz/28qI+40yBgDhTNaIpD4ccCSFSKsy36OhniQLoRH+VQlsyzCDhzuHo/y1Xhb3qs
	6iRVHM7d6yVL11dB164qkLnPLl6VwS2yOL0F7DasAoPmYJdOTJKHtv4kIf0jfQ3cdhnE=
X-Received: by 2002:a05:600c:468b:b0:455:f59e:fdaa with SMTP id 5b1f17b1804b1-459f4f9b7e5mr83425995e9.21.1754918396780;
        Mon, 11 Aug 2025 06:19:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFfTab1uacg66NFWygY4dulUklcFe1ZvbKk6PpdZGtHXsje3zBsH3EhLzcZBcKFQK7tW+OLeA==
X-Received: by 2002:a05:600c:468b:b0:455:f59e:fdaa with SMTP id 5b1f17b1804b1-459f4f9b7e5mr83425795e9.21.1754918396349;
        Mon, 11 Aug 2025 06:19:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459de91ea4csm309924635e9.10.2025.08.11.06.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 06:19:55 -0700 (PDT)
Message-ID: <7e7bfd05-434c-40b7-98ec-8ce352a8147d@redhat.com>
Date: Mon, 11 Aug 2025 15:19:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: swap: check for xa_zero_entry() on vma in swapoff
 path
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>, akpm@linux-foundation.org,
 shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Matthew Wilcox <willy@infradead.org>
References: <20250808092156.1918973-1-quic_charante@quicinc.com>
 <dedf7436-9afa-47f6-b676-88f2dd8b638b@redhat.com>
 <f008107a-2741-476d-9e32-ae9fc0f81838@redhat.com>
 <29e080fd-5f9a-4760-876a-a6ccef33129f@quicinc.com>
 <fec5ad61-7caf-4076-ba81-7b454ec7018d@lucifer.local>
 <9178bf98-2ea7-4ad8-ad43-cdcc02ab863d@redhat.com>
 <904f85d0-acd6-4f47-ab45-fbf18b80f1c6@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <904f85d0-acd6-4f47-ab45-fbf18b80f1c6@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XxV-5UARQ8l94bwAEbE5oDeLkFj09Durgl-OleJ21fw_1754918397
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7bt3gcucui5t6mi4ruu4fh4icq5siwt4
X-Rspamd-Queue-Id: 0971414000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754918399-72969
X-HE-Meta: U2FsdGVkX1/RvPwqci7CfGoPo1oczZX7Q4DRvB556JsJQhv5BRu81+gi92x/t5voUbE/L5lPD42sLva152rNUO/btR+l8lC8zndCpQhz2IEn+nBwdbRL1UELctk61Qjc3kGB5UwPLz3ReHFAZ6K34LHSySRLrU+UbOZWMPAFXaWzZBjZJOClTr40QBfL2Ug9PIZ0RgdvqaPipFNKoakox5BuV5jCdeTwa90hbiE2It+EmpHSr7uinX7bXl+0oWZFbIbeDvTqM7xY9qQG+Ihu+XaIyAiJwqIS7qertwndwFDY0jkjUbptu2HM7Wv6tLmcGdHdyq5IPZYdX1aw6pz772FPd0V/KLEF3DQkqA92CnVPN2PEMDlwLgXSTCg0XCosp+dlSi28WDBzYJKtFhbZUhpyTT/XaZ4crvx92Q9XyeUJACBlrDGhOvIjS+tK35uzDU6pR4e9HLLRoXVLPF9LR0waK83gNoc+/4n0cqkr2QXLrsU3nPlZwh/+A77imPWJ15o9PKUUyRPuHrzMU3vwY0ZDeWZrXeFHjfUD0Z8BU3RNBswjfyjRCiuJJ2jrKatSP13Jo8XVBn+x/baMVjCsK79+W/Pqui8eXLWqqjUq9ftdnYLJLx0ac1oBpFex67dP9Y5ePB86Y/6qZdDZA0f7wBQ79S4pujzghLWnpm+dd7XKhZPiITVKmQFey3nJH74kSt7286lfXiK+ZM0rkQ+MC1BUZ85wwwrS3RYaKFIiOl6oBrqUHVhO+araRETGYFSsAD2matUpggMjG9YEMmqQkEDPq80jHUwia21RZWGATgiNLsiYdhDB2ae1CFIgm/IQIRcjfupW1ZGryonMWCKsG2R9f0NvJ4QdSqZfIQkEWz5QXlJD6b+kWaKfURcSxUceFqHnyS2KlgszIy5PdWwa59CGnZZLNwop2EQtZf1unZsy9a/HaXc7As+XzGUDNSH9qt9nOZ/05OMojMfEX0m
 jDY++qBP
 CcKB5yOzplIEmv+Z7LF5RLL2T/aBr+i+uRxLEyXRHPJ8Cy2LKId6GlSEeztf8qXR9kK1A39sq+Mqz6in6j+XEyOpIj6dSo03OF6j6jaCWU0QMEhApNnMJPvyexW6y1KOKob7z3Jdic23k0ln5uWxjglHhbxtHwnQX7U1VxOaaoTYJWLoSoVDixeHg3AGGpjzQHDqD58DKd7AXnZhyRX0d2w2bp3IOkpXZmnufoRHNHB5sD2lkk9BXibxKQRC3l4yWTZ25M3Cq6nzHm+zFcd2cym3tOlWpCdLGVfqm25JFZTUHWK5oiIHN20TmLsAOlehUpH+WjdsTIsikxcY1fyR2xPQb6KbECwLO3gSQzQ9mPQhJzdZlmnRExcgdPgOs6lDx5yNlBc08lrImVb+J9sM5Xw65h+StyPkmF204zuvV8VgVXJDA281Mf4pBIn4MLBExuaWx4ybR1U1O3Bn+dJQVEekfDV1tR3VUFMg3p4wbPSHj4gu3KzNpeUOgrcHZ0SGJDNz+W2XBLV/5pHk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>
>>>> When registering vmas for uprobe, skip the vmas in an mm that is marked
>>>> unstable.  Modifying a vma in an unstable mm may cause issues if the mm
>>>> isn't fully initialised.__
>>>>
>>>>> Is there anything preventing us from just leaving a proper tree that
>>>>> reflects reality in place before we drop the write lock?
>>>>
>>>> When you mean proper tree, is this about the your previous question? --
>>>> Shouldn't we just remove anything from the tree here that was not copied
>>>> immediately?
>>>
>>> Commit d24062914837 (" fork: use __mt_dup() to duplicate maple tree in
>>> dup_mmap()") did this for efficiency, so it'd be a regression to do this.
>>
>> We're talking about the case where fork *fails*. That cannot possibly be
>> relevant for performance, can it? :)
> 
> I think it optimises the overall operation, but as a product of that, has to
> handle this edge case, and that necessitated this rather horrble stuff.
> 
> Obviously we don't need to optimise a 'we are about to die' case :)

Right, so my original question was whether we could just drop all stale 
stuff from the tree before we lift the mmap write lock, leaving only the 
VMAs in there that we actually processed successfully.

-- 
Cheers,

David / dhildenb


