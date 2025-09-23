Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC7B7CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 08:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35E788E000F; Tue, 23 Sep 2025 04:09:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F3F8E0001; Tue, 23 Sep 2025 04:09:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7318E000F; Tue, 23 Sep 2025 04:09:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 026888E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:09:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB4431DF1E2
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:09:49 +0000 (UTC)
X-FDA: 83919791298.13.DF41F35
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6C47B1C0012
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:09:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GJ36UmNq;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758614987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sjew5omy6aBEynE/MbLFlpptKr9mVmWrE4MDs78qygI=;
	b=UCaWe94OheGHrKIaFhF1seCZCxqZfLy55Um/pevQhq0reh22vZmYJSr8UJPsGYVEtm8TRD
	oRniQLcSEh/a5pLZUlk2caKgaa08jskc80YorGipk/k4eUHD0hVRntmw0lXtOb6pEoYyb4
	V3Xdd8Ahb37wsB79bGQGjE//+vHZ9Ec=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GJ36UmNq;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758614987; a=rsa-sha256;
	cv=none;
	b=VIietkCa0qJgPYDhgyVSn7lh68ANFuk/To2TscdDKc0iRvjQl0WwarRMuQcK5Mj4t/Bb4t
	FJ5NoEr5Gx8aqWT/f2vtE+M6boICLa1rJeeolC8on3P7T4C4XcOqoLgCaG1rnRZtgZMbE5
	KZ1Q6aL4nG51i+uVwTsoaxjDK3UAqec=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758614986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sjew5omy6aBEynE/MbLFlpptKr9mVmWrE4MDs78qygI=;
	b=GJ36UmNqf5w7K2mjBWFP51aeEWqle0Sy7fbnb74qc7UanxFuYyFYORC7+cbArCX8oY8H9x
	UHVv72YmIoekPcUJF5fCxQLsWHcoeyn3A1RQRTFOUiRYPxcRq41rqawZLK0yALToTIGIqV
	P8z28Q39bMGr863eCcHCI/aVTZKPFOU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-ZbM_voPBNpeViw2KFUE1gw-1; Tue, 23 Sep 2025 04:09:44 -0400
X-MC-Unique: ZbM_voPBNpeViw2KFUE1gw-1
X-Mimecast-MFC-AGG-ID: ZbM_voPBNpeViw2KFUE1gw_1758614983
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e1b906bf3so11637725e9.1
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:09:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758614983; x=1759219783;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sjew5omy6aBEynE/MbLFlpptKr9mVmWrE4MDs78qygI=;
        b=iiaiwOVHCnS8K9Vn2Q6cuGh8rWGqq+djeyPCJClumvTnUg9tR14WrjlsoI8iX9CGr1
         8N/nr23/y12GjmIpe0RDNNIYSJnmjb47skHpzi6/x8vIEh7sPZP0CgcePYGmFyaYrL2d
         VtUtzTr1kO/FOZTEN0no7+Jr8OccvKJJo7V1XnW+OSEgFiIMGQBD7ZEw471lkpjLk9Cg
         U+zP/Qe1MQpU3GeNVoiL0QgT+miDqIB9zkD20vsS4M1h13g0EpVSI9f901efDWIWH6sL
         Fa0PeUJlSuxpuK8/1Zdw+ruDnY1tRSOS1IKn06806L1MYhdOyCiiWWFcb0ezSH8z+l4H
         5YAw==
X-Forwarded-Encrypted: i=1; AJvYcCU+Wmle1hPCLqMazunxa8tyw0cNN9g65fRGffSno8ddrYfzgjoF4+E5L7cUAz+3gmE4c9R73tWKTg==@kvack.org
X-Gm-Message-State: AOJu0Yxgha5AtJ4z8tKVN9nx0pIkFz4DHUgPpdbQ4HJhl1BqxBLw1G/6
	PmiP8DWwIw9r5+hCMLwJRBqSs1qk5ztSn2LnVHW5AqPA+B7GwUiKM50CaMw3GuVcWIZKswdC/bN
	NXDi9b6uiLHVcnwmmzLi/mgsDSdroQcZbzqaGpXIMC4mp4ZhPkRHo
X-Gm-Gg: ASbGncuEC1B3s+WpW0xFg9Rew5gvOLhv1XJobz53nGFaCB5ECW/xrCghzoEaMlQ7dTH
	cg9KySIz/4ZpnEWwPhh73JNuufd7ZvxhJHIRQAH9bqnKB28N0mhu649JcNGP8H/C1MZbK7ANLn9
	hnbQVc40AWucnicqGY8TfLewmxnUBkE1hweqVOIpH6RBYeWnPl/f7NeZBNxEUGaw0WTGbwZkRK4
	XaFSOEcjzv+WeHLz7HvDt7PYmMRkRvJzq4uYakrQbYprpl6qd3V5zFCss06KmwcJDXhPpmLVQ/t
	P60cFuUbLt1eAYUqwVl1aEK1+TGgEknl5qIubGumK36ulm38qyhYXG9JJFLZTfzXrXbOZyk=
X-Received: by 2002:a05:600c:3b93:b0:468:7a5a:725 with SMTP id 5b1f17b1804b1-46e1d975205mr15348355e9.1.1758614983367;
        Tue, 23 Sep 2025 01:09:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqsDVDKIkEtvPSnkF6zOpO6YZVDfSuoPENxbkDrbFn5kbABwZWCfuv/jwB9uITJNaFWS+ksQ==
X-Received: by 2002:a05:600c:3b93:b0:468:7a5a:725 with SMTP id 5b1f17b1804b1-46e1d975205mr15347915e9.1.1758614982971;
        Tue, 23 Sep 2025 01:09:42 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1fd57.dip0.t-ipconnect.de. [79.241.253.87])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee1227cc37sm21400826f8f.7.2025.09.23.01.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 01:09:42 -0700 (PDT)
Message-ID: <d2dca02c-ec5a-4b3d-92fe-2b3a3614b5df@redhat.com>
Date: Tue, 23 Sep 2025 10:09:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 12/16] arm: mm: define clear_user_highpages()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-13-ankur.a.arora@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250917152418.4077386-13-ankur.a.arora@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BlfSzHVg3gCoqwFdJemWh9tCCrd0fPKzCwOFhjiu0a8_1758614983
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: m1awcm4uokt3jnn1so5gbydhbr84m8jd
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C47B1C0012
X-Rspamd-Server: rspam04
X-HE-Tag: 1758614987-419187
X-HE-Meta: U2FsdGVkX19yACfHp3J6Xyf+0xTXWVS+G7V/eJ1pNl5bwIPYRHgNn0VkVPcvgwn/2WMEWW+/8My0X7UoPWE+CR33mwyWV4Hog8m0LSrpz3gWaQ8PcbFpn7L85pmXjUUZkwqKK8y35ovhu/sjniutZsXf2RQJWmYTCQrgd47I4hE+NATzArdJs9vLDGHe1j/ya9PSUUGRueBe0I3WZQDnwbIbeJiZeEknfwwIBtlL30OlFqbTDKlbon3pV1nxc9v9D/UYzRWWIr5tBoOrAacLEmNRRajhBgFYd240oE1+BGc69p2mco1Mr7j1fB93nDyMqOOikfLGCDbvwTop2i6VFLRN/SPlR6R5MyBtju8cJ+RQT/JdbF0sRS5tP4YhRRKW3hZSQUGzZn21Unwbkcxfje3QWl8U+APLVXASpFn1S+aHNvqB5pl8I8g70Yc3eq8h3KqQXavBJSfDLaFdGj+/Heb84tIaHqEAmlt9B9t6K2xGv5xIxuUOYjQkthtYaw/sYyW0N8Y80E7rWSy6ub1FHQu41wbtpYZA0SGmLU5H8QhyBjwx0ciPpAINqNC+nsF9FYxC6bcn/WAP6+hcqZvL2GnImuiElo8WSBND3nQtuMHN22c0N4uAzWsXTD8r7E9gCXM+HBKZdFFRAHx5SPPdJUl6TbplO/O7t0VIuS9kMMu49Tv7UD6rsOmzCFxEbNopaZ0/74e5Z7KXuDsy3f/jEr98g0MuVbpwOqELVsh2qzIYSWD/zMeKM8KiamKwfGUGDYbjbHdM43DJVAPsl93tAJWi+i9B/HqBi6XhILLaOWBqrlwdTTYXHR32/N3iwo/0m3l1gn8EH7Z4Tgke2sKqQewU3f3f8Rih7ow1GL0l2+cAAdG74+ms79pBd0BcKS3ZCc+ZQqFiBjsXzkl/aglS+m72jvuO8ZhpvFddkMgYYwkAZcuJ4lm/Ez4ZNE6V7et3FQxWrLlap8xEH3D+b/q
 yuml7vvi
 lRVTeBRi8BYp/RoMtsQHneiO9M1nUVbZz4c4C63A9wfaTYd6ylLnHSUgkuxSgg3IGNgWyv2AZw7r2vZblSxEemsR4I9rfWsWPmVSuK4+iaPE3izf66Q3VLGg+gpqki21nyuD9PEXXCL+0YGxP4iwU9EIpw5cZKnMvRn1kT5ZvIvHozD1KaFAz5Z60AZ3diSe6iush5rDt2k7Wq5A50pRQu1AABJLkeVSra4jKCStAkuwkq0JN8wdmaKw8CcTWHrZl7EEdWpY3vCh8cO/xvMusQPm3qRAv5XKey4SWFERYphx9epdES3K4Vckh88tMcdaLnbTUCrgkLb7TQBH2JQ3SXwgSD0KC7whG+uwot//ZWlMrV4DErVH4nUCh1GeNqpr4TlPUFXlu7g0vguZ3XdelD7mgK/A5mJSDHW2NY5/AKKKb5GYJaZYgUSOTIex/tUoSkA8X+xLTMkVhm0esTfIlw6BGSOH+egXHun6pIRjWIIlcR/NHnJqUpzDn1TM3tB0qJpBBZ9n+t6BhonpvuJbwAyt45P0zeEv7M+C0h/5xzEWxGT8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.09.25 17:24, Ankur Arora wrote:
> For configurations with CONFIG_MMU we do not define clear_user_page().
> This runs into issues for configurations with !CONFIG_HIGHMEM, because
> clear_user_highpages() expects to clear_user_page() (via a default
> version of clear_user_pages()).

I'm confused. Can you elaborate once more why we cannot take care of 
that in common code?

If it's about clear_user_pages(), then you can just switch from 
!IS_ENABLED(CONFIG_HIGHMEM) to ifdef in patch #11.

-- 
Cheers

David / dhildenb


