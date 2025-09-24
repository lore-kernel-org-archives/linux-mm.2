Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFD4CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABFFB8E0011; Wed, 24 Sep 2025 06:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71278E0001; Wed, 24 Sep 2025 06:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9382C8E0011; Wed, 24 Sep 2025 06:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77BB48E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:00:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 343ED5AFCC
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:00:51 +0000 (UTC)
X-FDA: 83923699902.26.31326FA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id AC19240014
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:00:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M1FBV2M4;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758708048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Ruxy3sL5aI6/uySjOP91+/+LjKXmpr6acLDWYMYnDc=;
	b=F+OtE2aKn166l8AUrobqwQNVcq2sdN3+v/tL/5vRQTozkBY4Dk2EUpajXYfKTp5oBYu9a0
	u1x7+uRvjjj0UUlJJ/yo/QOGNP9nMs8eDG66aKnk/lhc9aiE4EiWZB7x4ArJ4a/aBAfFSk
	jhCFJ7XcUjo5jqsQxwAEr3Rdj8NeXoI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M1FBV2M4;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758708048; a=rsa-sha256;
	cv=none;
	b=a8STMoytpU8sbu0I6z8KxwQGd1k3HUqVXhnqrVbvZjr6XfsGOKATK8I6ZJfS1DiUh8kKZa
	z8TYSm9oD4NJ3NcnAKaS2lOrbX5lcFV6ErOd2hjeE7pVSsQHcZnqj2v6mIo82a9DxvP02l
	ZqdcTBcULjAO2v/op+Nr3mPNJGOvip4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758708047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0Ruxy3sL5aI6/uySjOP91+/+LjKXmpr6acLDWYMYnDc=;
	b=M1FBV2M4U7DHLI91QTEuuN5XLLC/zbOeJxCyz04GDU4f6Ah7pP6QOnicYOvAE0LCCgCAuM
	M33x32FeLyrJ6Am1cw8x+Vk8ieDvI01OE+putx5F5QF8/OKL+niU4YGhy4D9kcWbaGBPsT
	3NOG8FCPvK8VK65SEN1XhDVQJk4h/i0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-LiYASKpZP_-Xf8DaAdQUqA-1; Wed, 24 Sep 2025 06:00:44 -0400
X-MC-Unique: LiYASKpZP_-Xf8DaAdQUqA-1
X-Mimecast-MFC-AGG-ID: LiYASKpZP_-Xf8DaAdQUqA_1758708043
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e1e147cc0so24051445e9.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:00:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758708043; x=1759312843;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Ruxy3sL5aI6/uySjOP91+/+LjKXmpr6acLDWYMYnDc=;
        b=pMnF/XSNIoD4qoCRv5GL1TF4el+Pyo3QOuOeMNUDjLvkokryRUNjNBNDny66CdZspx
         h4NpGXMrmOdQwtutrVQEB4e6t+caoCrmq8wfT0CLrtBvN0PfI7LTwMuFtTjGA77QI7H3
         ZKF3KPHuY68luMhyEoEDGzObWhKarVAojfAYDhu3JyPuowAdF1c7ftSSeFpCLRP/mRe2
         gF3iVLsGLtNCKeVgzFIug8eUAEWC5oGpPkxxj0Vdn7UYu2w/QI6aQ0+8OkGgt4S2zrV0
         bD+cpjlGlBgu2ABpCojRxEpNOGbaOMH/Cn7DvT9ghV7w3jjJw8tGZUjkoA7htxzOyYlj
         KZ0A==
X-Forwarded-Encrypted: i=1; AJvYcCUpc8ldy3kUMwZpF1riMORamgQ5cUk0rqbORSnSShG1CbkW4Wty2gDSWtiHhwEZ+oZ4AlIEsmuyFA==@kvack.org
X-Gm-Message-State: AOJu0YycPtuVITRDHcm4Lr85LaEbnu7pW2J/09V9V79CzT5K0vqbY84x
	IqUL71MlijnwLvg4/R/Qx8rtCh1o5pWI0drh8JzyexnMeSEEA9zHrjfDdT1hyPMktavOtckuDys
	J0N2d6gRo9b6T9mlygy6lrMigqACari1Dfqui/9V73l5L3iLEJyL9
X-Gm-Gg: ASbGncuY5JyYuCdioYVXeZboGPhB32CFqFNJ9bSrDenIt5+Nw988xEfaex2233kovPR
	xWbbzAyiutkf/TpwDLIaLC0+M0yWCdmg5Nzpw3BMByK7hyxuPHiV3y03iyXdgWR7SPInDj7LqAf
	TRqBMEeWlBgqrf2ti0GpP12VDehjY/Ywo/acZQSZy1IK6vkWAdnQkdb3fNHAneX8bF+aGqk9Nqb
	Nv+7IjeXrxw0bTJF5AsopcIOeiFGMJ1cHPqEAbVUsZ8MUMpvT+d4MQTOoTfZjb0CwjLGQOZYm2V
	qo3W0qq3UtwkSzyXtFkMjW+LqcGfbEsJAYGGj1R3IGCks6Ynz8P0I9sFyUAEqoBxNEdHp7+XRWE
	kEUFGx1XDo4DHXx1xyUPSy0xnb+HaFXyNo4yPvmR4sO+CMbXDrfNYCS7D3auZuC5qgg==
X-Received: by 2002:a05:600c:1c02:b0:459:dde3:1a56 with SMTP id 5b1f17b1804b1-46e1dac30bamr58808965e9.28.1758708043185;
        Wed, 24 Sep 2025 03:00:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHySs7hH+gLA68zmNmKselPtLp34hha5qnLkX8e6NAnyxNd/x+utNoLi5IXs/8ZogcpFP0IzQ==
X-Received: by 2002:a05:600c:1c02:b0:459:dde3:1a56 with SMTP id 5b1f17b1804b1-46e1dac30bamr58808345e9.28.1758708042642;
        Wed, 24 Sep 2025 03:00:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a9bd9c3sm25328395e9.9.2025.09.24.03.00.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 03:00:41 -0700 (PDT)
Message-ID: <5549ac3a-20cf-4959-ac53-0a89ed0eadd2@redhat.com>
Date: Wed, 24 Sep 2025 12:00:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
 ngeoffray@google.com, jannh@google.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>,
 SeongJae Park <sj@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 Alistair Popple <apopple@nvidia.com>
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com>
 <2c9df5ee-6109-4fa5-b895-ad8e47d34bee@redhat.com>
 <CA+EESO4h-_U=Xo3x0G_74t_qJQ54AZ4Qd2Ji437aMV8nDZ+tkw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+EESO4h-_U=Xo3x0G_74t_qJQ54AZ4Qd2Ji437aMV8nDZ+tkw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xRgFYy7RpPTaf2v1p_g-C3Us2HjYMzVLqAkP38MHR1E_1758708043
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AC19240014
X-Stat-Signature: q3j83a9yzfrttignwbwo5ti8o6kukmag
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758708048-834468
X-HE-Meta: U2FsdGVkX1+4trBhMmIrWv/KqxKfE4z3COPO2ZyIDa8VtMaAzO43bnYnccbz0pwwWGyEeH3fgD+8kXSoCrj7QI7wF0LBVU2fQVzhgnwp+CzMrRDWzlNiW3ljqiK+FG9Xx8EtzJCfSscunH13gjMg8TO/S/9YmG0heorETaHnYCVLCkLHEMEIY4DI5XmqjyIvsRYOMlwta/vvdErSanm7YOrQzkVbgfaec+8R1D/toXbJ4VvtYAcAoVbtVKDWgAeZJ3ZHvyjvKhS/GXgqSlE0wlPOd21kYYsrhVnUmV7sx6qwLtUR+2J6+Pv5aA5j4CirQvLpL8RtECvfOIJ779eRG4mi75sAEWIMuu4X3Os/eMCEo/FVlQZoqMPd6I+473laRXBzAYcqU3D0CLYliJkXoVQNpaYu3eXlh/doCyjXdD3NDlY+CrvRo7zqqy47UQSfWgalmdmTxyMJ5/RLlZDH/uzwd47PcnyvqtJKl+FoEvugBsgLQEPc5hYYlAlVkker//WQDU8STYWlhV7VupQ18eDFhDr4sfDMRcJXxAMxA1JVHI05XqqcnqiCNOns/KYoZTfu9B0Yt/2tRLtupKy6UWcUbzd1pnWBgiCtel0tExUh52KloD6/1Kn3jlFeO5KXtFcavX5nzS65F9Zi48tHjCWKusCeiHiPnvPWrnHMRRSCdl6tA1N7xLa+eIlLZ3B5g4J0D/tWaJb/hMmc2DPdkT1tnRfcmktMBVNP6JEYgWF/iT6QAehoU7IFEVlGLW1Xopri9vb9wXbhno1OtQxPKgHYhfM8LIBY3KgLTgirRa0V/FKZBacLOQi1tT+yvQy9uSbgIqEpFSQB3wWdVYdcdJhyITiZDa3oBFru36iNQE4C1wHt4aot6J81cf272svNR1pRNSSZcCyZhLrai1KxYtXW9I/LWh4IJyFul0ylmeM4z9jenrgdsHrrQrH/I/R1JW4fvgd07mSq8i3H01F
 vB9H0yXA
 /MalDJv800DS6acdL2Ku+2YrLILicaO047M2cKSVpiTcGS0FhAEw9KJGqehZN1XszYZTZyqLw2Xz7VfzD6xqEbNgtgsH27rqTvR+oYma4IFlpHqIhSD0swuBZG7KcSc79C2nOUTiK6dYq3iW2OVYntvjfeTgrTl6qstWZxSdbd0yeanqoCr+7XdbAmULw2thnaIZPiWycEyBIsJ71X84hHt/nUPUL9nduyLcXZQXsLSEEvLECt+w7z4Ejxyiq/VpaqoMIFaH6rzMQ0vkb6xoVXvxllz4D3u7eDnCQAxXgtRjGsLi7+qzyLGeoxDTbbOFH4T+Rpa9kaKeHfnpH8lzDbdDxL27Ib1U0HM2nHL9r3lgc0y31y+ASz+TP9COA3bLqtUmTkXF+AQZc6iePbl2ezrUCnJ4LO30L/6TXN1V5aPnYvfYi+5SNvUSx8e3CWBbyr/3xL3lTJ2he/O6v+jDGoQ7CcPA6SxFd5gonBiFIPBX3jjSN2XgXHPsp2OklCFQ9NItG3aTHATc41hoxdL2W/m4/GFr1Hv8337pHbY4ipE8xGUwX6/VC2hLUdpTQjXeNM/mq+VaZwFdlfrHCzRfbkVcI8xqr7JZrqpmB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> Is mf_generic_kill_procs()->collect_procs() problematic?
>>
>> The dax_lock_folio/dax_unlock_folio part confuses me: I think it only
>> locks an entry in the page cache but not the actual folio ("Lock the DAX
>> entry corresponding to a folio")?
> Yeah. The name dax_lock_folio() gives an impression as if the folio is
> locked but it isn't :)

Sorry for the late reply, I saw you posted v2 in the meantime.

> 
> IIUC, a dax folio can't have an anon_vma (folio->mapping is actually
> an address_space instead of anon_vma), right?

We have these weird device-private dax folios that are anonymous and 
should have the anon_vma set up.

> So, I thought it wasn't
> required to actually lock the folio in this case. Please let me know
> if you want me to still lock the folio around collect_procs(), or add
> a comment?

I think we can end up reaching memory_failure_dev_pagemap() with an 
anonymous dax folio.

Not sure if anything would prevent us into calling

mf_generic_kill_procs()->collect_procs()->collect_procs_anon()->folio_lock_anon_vma_read()

CCing Dan and AAlistair

-- 
Cheers

David / dhildenb


