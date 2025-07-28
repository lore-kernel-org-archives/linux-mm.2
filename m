Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F5CC87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 13:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3386B0088; Mon, 28 Jul 2025 09:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A40E6B0089; Mon, 28 Jul 2025 09:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56B9A6B008A; Mon, 28 Jul 2025 09:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4407B6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 09:14:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7C27132B39
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:14:12 +0000 (UTC)
X-FDA: 83713716744.25.AF5947A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3C1A312000A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:14:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bUsJSd8G;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753708450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LvmPhToHOR6HSgjCI2OnycSjK9gNQAEM8DewQu7Vi+A=;
	b=IC6vJ25Jz7+VBJGT8eYauS8FUJsdmi6faiB7GKlHb3PHzd3lNK23OkviDnmIkggEhcoUt3
	XE16exx8s2TkBNUErMfQFUMYxqhlemH95hcQU7d9LyP8bGaLU6iW89rjijCsLyDMH+nYIi
	xJ6i9SW5QTX9Jmy0wmfEDxZypO1PFjM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753708450; a=rsa-sha256;
	cv=none;
	b=kd0pmL+6EHYgF5KPOhuhqLExRxEwBH7oiVC2O6mPeIuupTxDAs/THtl7tJEn/+zA5rFi2H
	fzpOhikI1EqAFxG+sx6wVpzzMkRAr5H4DGyTgir4/5YGUyu327MFOZaOPdU+QpTJ2ZQduT
	wZWh1pMdIYaLPafNjevruNrZbQaYLO4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bUsJSd8G;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753708449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LvmPhToHOR6HSgjCI2OnycSjK9gNQAEM8DewQu7Vi+A=;
	b=bUsJSd8GUETspzyNjkcRZOxgfeGE2BA8rj0kHdMZad+3n0/FcC5X4OjN+f4SyB94Aa4uiG
	SS/86Udef5mN98w7msQBGzqwR3D1X9y7AeZKs2XBfStNadbywxEfh3xgfiNHuGHt3ajRL4
	3iFJoEKWlXtAVc/2HHNXQIozORnUEZ4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-5Emlcr_5MACnKp56hVY6xQ-1; Mon, 28 Jul 2025 09:14:08 -0400
X-MC-Unique: 5Emlcr_5MACnKp56hVY6xQ-1
X-Mimecast-MFC-AGG-ID: 5Emlcr_5MACnKp56hVY6xQ_1753708447
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-55a30c41be6so2411355e87.2
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 06:14:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753708447; x=1754313247;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LvmPhToHOR6HSgjCI2OnycSjK9gNQAEM8DewQu7Vi+A=;
        b=ApDcyYmQTRtNQRrkHeKRieNeWGaaUrtvn68ceVsTJwjWxUzvjxUzK4j090mlOWXUig
         WjWoMnM7gzMfrHNCAnpXkJyGP/eNYhp6WwWQmcSJLPBkVXfU7/kLsdcOAM9t4nuhasyx
         wFwduWXTf5ge8ghY6VNbTAOfT17njAkhpsdeYE4g2DEPwVkGjUD/xkQyUT/sZF1sVQj+
         WCBIyvrTSGmJIRwhxOMt5uXzqiyfrdxUiG8lKTAzT558bEVS+JRi7YgiAtnwIPuNEWMt
         j6ershf9PYyWq5BM6FAXTnJqCL740pOJTd89dKGtOCUPOZcc1RlBc6klQWO+A1LS++f2
         Uh4A==
X-Forwarded-Encrypted: i=1; AJvYcCW9EdjH7mGlCDKjmvAVrOxwHR6Jro9TAIHf5RrT4SCq0kWMTyHj6KoVkkOl0wQX5Yb/oBZoZnsv3Q==@kvack.org
X-Gm-Message-State: AOJu0Yy3I5yai+2K74AhLG74rTlNNMRjWmGq09RWWjv1f1dnF+XlpD22
	/03OscNW4mhne0auMHr+OZDLmNwIiZeXlkGtKS9SH1if42pXbEeKXtB4Kvd5XIJWjJcG7k1bWaF
	p8ZBCGcI9GEtafaKRsxd1RAxoiGzWCeqQ7AmLGajMO5YNiJ9+LHSmNaNo1FWNIr8=
X-Gm-Gg: ASbGncup6V03PwXDPusfoJnyw55XTgShm2pjyOcRKp8ctD2boHLGDadnQs2w1wK4aWK
	0/05EmlT1QxnILuhqPpm2why+F+Yy3+2mZBdHaxhOhMIzsox+nbzwFaR86W8jqdRJiG5r4Rs3Ox
	6pLkPdCRt8pK/TDNIHRJ52skoFZvSX+pcJ+DZQx6xQ+ZmsP26x/EhmAn7wJsEFvj7ylW7bLDyxV
	Bj6MewdixIvPHI2XwR4O55tamj2rYl6rW8Zo3BMdN3M5Sba6uZyN4mubOWr86SRJRuORwJvsV7/
	dGFnOqkTXybovzVqWRPPlduywmH06gNMRzSPLULAZDX63acCe1+x7fLw80qVtnv1lTuO8W2WbYQ
	IraXlpCS5cgWQC8kiKegahXz2vCJxIuEs9PbEeDsloqJjITDPBYQPNk420bqlT+es8pc=
X-Received: by 2002:a05:6512:a8e:b0:553:2c93:6140 with SMTP id 2adb3069b0e04-55b5f3cf898mr3204048e87.9.1753708446615;
        Mon, 28 Jul 2025 06:14:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7cooNi7EIlieaXAkiyUszr7FMSt+00vQHmfmy7Zn4/r9Ui1z6R8+K731nkAB9nSbSvB1iwA==
X-Received: by 2002:a05:6000:248a:b0:3b7:8737:7f1d with SMTP id ffacd0b85a97d-3b787378026mr3011013f8f.46.1753708119115;
        Mon, 28 Jul 2025 06:08:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f47:2b00:c5f3:4053:2918:d17c? (p200300d82f472b00c5f340532918d17c.dip0.t-ipconnect.de. [2003:d8:2f47:2b00:c5f3:4053:2918:d17c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587abeb39esm97528125e9.13.2025.07.28.06.08.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 06:08:38 -0700 (PDT)
Message-ID: <3e88642f-3914-42b0-b864-4ad374b659b5@redhat.com>
Date: Mon, 28 Jul 2025 15:08:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
To: Michal Hocko <mhocko@suse.com>, Hannes Reinecke <hare@suse.de>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
 <aIc5XxgkbAwF6wqE@tiehlicka>
 <2f24e725-cddb-41c5-ba87-783930efb2aa@redhat.com>
 <aIc9DQ1PwsbiOQwc@tiehlicka>
 <79919ace-9cd2-4600-9615-6dc26ba19e19@redhat.com>
 <f859e5c3-7c96-4d97-a447-75070813450c@suse.de> <aId16W4EaqjANtKR@tiehlicka>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aId16W4EaqjANtKR@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mJxEkRGKcfG9gPhfQXgOnGJHwt0VE0kaAS57UhnZ6_8_1753708447
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3C1A312000A
X-Stat-Signature: qmcfwreswgm9zwzpa77wn1aituqdjfbc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753708450-284065
X-HE-Meta: U2FsdGVkX1+vKKUWQeGnkNfioxLgFqnsjK4OG411XbiFqWdZmAg21pwyC4h/CgR+DNROXqQDVkKubNHFZvIL24TMcLmOKvOETtBc8VkWQgECEME9F0M6xZ3h+I4oWqntMq17edd1Ayp3jQRMsHu0rSB3czKFz+puK7kWoGw0WNIWLWwS/R5eK+TOopEao7YGTQw0RM5j6YjPeTfSM/xnVDRosc83ouCIV9aOG8+l0PkZXT7h+pLQRVEbZPnMFe8bTJ+AJxKfuYoyC/+DOqUNY2wGHqsKI9cR1UcdJXOEaHLceLm5o6kv5fXhrc7TSi3thhTI2kE/ZeYFe9fC9XlkzgociJCGQAtes1iVQYQnnQnOlgROY4LhS2/Y1sWlnpCfON3cSkpkkaZjpujpA3Ko5c0lFkTR0yNS+AKeSIOIL0vERC//NM9ZLe5cmw9m1PswpKkatRJmLXQzmlJnEzqg8gour/oQ6uZDrgG34yUXXbjWGKXlTD4spbjg9KTiietrehb9HTrXpLTUbPUzKvN5MvAr8QedezmRpNgMpf64Z5HJIGDdZPiIavTkw/yAhRm239RfLOS81ukK+Tw9dzXpy50N6lDvHAtULapdiloauborLUQISRjsD6K8twFDzQfr5PZyAI+yLHfwDtFZOnddeI+jT83ZM0lIdmrcnxQQXHHyS6WT4MTcTka78W2HorswcXUw4tEhJ6uSYUvzSKr8dngWw1P2yRshe8UkW5o4glCKKtPkgOaH5grjhuV0ARrgb0Z2GFDt/qcGbD7AGNrdp3E2eBwbIL8/lQ0lboFIIV3anI02ROhO1Pf9iNZAgtxQCQ5eRXFnBTFtlINIPgMdaSksVLSMVVm5BPyWBzPIxG7bsUQar32zNY0J+vNH6fCxGhYMwl3zx22465W9jaPyWpR9YN+UQwDQN1Cuc4WeYA2nxHH2rtSXXLyhY1lebr+LA/dd6YlEsQAU5xuq5SC
 +jd/wqdj
 yqaMXxJgJi3Jenz2vnGaxJBHZZxkF8gM3PeWsxRWUs3SYwmYyLNb+EPPPvTIDBbUNsRQ807bjnnlIoYbVGol45CQXL8CJKgvqSBGYP6UQ6DH0N8BTtKbWsU9OaGKV0Ftme8XJEWiwlw5dZ3IjadEOwElJyDdfNvDoyiBPXZRptdySHA5saNLf5dccY1yFf0b9BR72U7KG6fn82xs8jChUfqE5+y7oHcD8C+ltKKbdCjF/6A80DYuqeXbOVEKlM0HEH8VbyAuiSVHBbiFrPisasvWvsS/Q85Ye0HoiLQ8AmS6A68tpWuhm+VrCIMhvTobNlvPJR1szXSV24sh8mPvLSEvWrHbKHS7CJs9SccmJ6DfWSsNUOJpikO9SH2/TTIVKFnmvSDuMB1pgR6ePZlQeW9Vzqbnw8ZrqwU65sfRer+9f6c4lJI4v1+uvDl6B6UZ+a2z7ypix/NANYegChlk9ZiKM5Gy6lGOu5OifcmLAgtWYdlWBr9+J7nrYVW5vjdhy7HCE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.07.25 15:06, Michal Hocko wrote:
> On Mon 28-07-25 11:37:46, Hannes Reinecke wrote:
>> On 7/28/25 11:10, David Hildenbrand wrote:
>> And to make matters worse, we have two competing user-space programs:
>> - udev
>> - daxctl
>> neither of which is (or can be made) aware of each other.
>> This leads to races and/or inconsistencies.
> 
> Would it help if generic udev memory hotplug rule exclude anything that
> is dax backed? Is there a way to check for that? Sorry if this is a
> stupid question.
Parsing /proc/iomem, it's indicated as "System RAM (kmem)".

-- 
Cheers,

David / dhildenb


