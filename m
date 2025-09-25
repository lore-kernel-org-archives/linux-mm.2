Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4CD4CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 10:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAA4D8E0013; Thu, 25 Sep 2025 06:37:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B518E0001; Thu, 25 Sep 2025 06:37:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22968E0013; Thu, 25 Sep 2025 06:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB2728E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:37:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 750B914043E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:37:52 +0000 (UTC)
X-FDA: 83927421984.26.50D9571
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id C8E93A0002
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:37:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LKCPPuL7;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758796670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j86z+a2ydPFGKyipLjb7n06yXseJDAiv3r2xG+2GDrE=;
	b=0MnGMfpehkzXtobujfuhZyJQJywm8zFRzZe2NW5zSQPT+m6NXKenxqakAluwBzeivmVfnX
	i69LNKjF8RnGlmDEQE0D/HkjYe+SNt1m4r/zzjcr/T5jZNMftB54RaNcVTcArCzh+Op9Ph
	rlO8qio/pXE5b5rBKY1PC5iXawGnzK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758796670; a=rsa-sha256;
	cv=none;
	b=FNvJfE710dpj13BDaA4QQWOmOIiug4hfdN5bt5OHWZasZQh0DVNFRXMsBx8ycA9CtHBM+O
	ipEJYKDCFUiWDy5eUGQ0f8fvEhqOr+f15I/OQt7YOYv6e8G6nJEB6DHizOWJCLqsujQqXw
	ESnxAscYwJniqfxFzqAbsE2z2OFcQho=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LKCPPuL7;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758796669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j86z+a2ydPFGKyipLjb7n06yXseJDAiv3r2xG+2GDrE=;
	b=LKCPPuL72hS5NHmyfIDqCugWEmCv0DwVh3Rqlv+vRP0bYQ1Aeqrw2H00dMLSmDMMQG7cyH
	qR74DCiCPvRrEqvpFBnsk30hGDmBHzpkmpGS9x6ua+8gjPf8YDA2l8CtTEj9j5KyhzpmlZ
	mZjH1+YCOQzgUZAdIxlp3qO7bWQU6jA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-hUj6WbyRP0O27Nhv_4FJyw-1; Thu, 25 Sep 2025 06:37:45 -0400
X-MC-Unique: hUj6WbyRP0O27Nhv_4FJyw-1
X-Mimecast-MFC-AGG-ID: hUj6WbyRP0O27Nhv_4FJyw_1758796665
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45f2a1660fcso6907395e9.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:37:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758796664; x=1759401464;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j86z+a2ydPFGKyipLjb7n06yXseJDAiv3r2xG+2GDrE=;
        b=R6KPda/JtOXxQO94g69jyUUqoKF8GD/x2UQ8a0r5cS9jEpoFElBN4bA3+THPIFoGes
         NmFcD1Qiw39Et49B90K2TaVkFYEpM1fZm5Y5zpn1+htSAasuTZXT9fh0TKQyFq5oU/pF
         tluUE9XGDiHpWKwOVQcaJmrjZek5H5lWsIYg2jKwumz5XAa9SgojzUCyYuy7rl4i+DjD
         wSLXfS/voxa/zPawYwDpbsPWCDZoQXCbnyTUAshy7DeZPuOi/zWt9iZrMpF31h0cyw4R
         ojH/dSnsEOP9k/hXYb+tAR0oE3Fa1Pm/HRyuvwA8AMwL0arJ8rjCgC4h7KsOfhVLS3R7
         cjPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYCOSYULppQsSxHYkf+gkTKjlZQMBF83Qm1MTCfEH/nH0wY0zkUgJljt+Vxw4exKi2diYtqKJn1Q==@kvack.org
X-Gm-Message-State: AOJu0Yyk1uj5N/XQW16BRyarEIhdxaXkU1ag+Vy3ASLRJXU3r539LGYd
	le17/XLou8TABzUFs61hyrQ+ZlCitZQC4UKfyvBAw5yJev2Ya8e059c9EMn7xNsxrLUJtUeHpdU
	2YJZW5IIuxYXcBI8iCf/8C5jUsQ1ZEX/j4xuKTQlT06/KaH0oe2BR
X-Gm-Gg: ASbGncvAnKqp+NFxC9SK0r9Fj7EF9v7gNjYhKcyoraEchdrT0yJ9oSpND0nucp7s6vb
	sAzMh2F0ZGb2A02LhKc9n4LrDMAL0IbcnhTiF/UtCJLhyS1olHSlA1Z9eu3+gUC6UWl9krCjlR3
	boUhNlqCgwwhePeDeGaR1172GXsCTCPvdKVkSi1xQcZmWSGlcfZsgq/2eiTQdsAKnv7L7A0DsvC
	Mz1aic66BfXphbObO+YspsMH3JaKXq2Vr3vpD/0+xWlq0/ky5bC0kCjCJRGeBKD3TUnrfBBoe/v
	wDhQpgP7v2KnqMLqn3am/v5/IaYgYKe5LpMAZ3Bb8ZCoT3f9/fyohqRbXFay4c8VE2MdZoU3xPe
	iDCfW+tFm9jZoUpnR6IdhzObte2r9cvMhGDFs4s/7GGHuG5je0myYxxtc4hOdYYgFwBRM
X-Received: by 2002:a05:600c:1c88:b0:45f:2919:5e6c with SMTP id 5b1f17b1804b1-46e329c5735mr46280985e9.16.1758796664669;
        Thu, 25 Sep 2025 03:37:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1OlhgrIXCfTLwvyk//rFgoAATxq8ZwsqL2id63TzVhr9sBS+YiTsV2if4gGtZKmkB76cyew==
X-Received: by 2002:a05:600c:1c88:b0:45f:2919:5e6c with SMTP id 5b1f17b1804b1-46e329c5735mr46280635e9.16.1758796664213;
        Thu, 25 Sep 2025 03:37:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e33105e0bsm14956875e9.5.2025.09.25.03.37.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 03:37:43 -0700 (PDT)
Message-ID: <462bb4e3-7a38-4155-9f95-52fbb4b6d464@redhat.com>
Date: Thu, 25 Sep 2025 12:37:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: move rmap of mTHP upon CoW reuse
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lokesh Gidra <lokeshgidra@google.com>
References: <20250925085429.41607-1-dev.jain@arm.com>
 <072b8684-47fe-4a2a-bf69-f6d348f0489b@redhat.com>
 <45e08ee0-c85e-469e-a3eb-4ca2e8b7ec0c@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <45e08ee0-c85e-469e-a3eb-4ca2e8b7ec0c@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qcPYll9UUZ5-5sQ_VKqx0KUPB5PB1Y1XlBp5vnq4ozQ_1758796665
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ihpsma1fgdfa87jcuxu6x7dqgncpi8x8
X-Rspam-User: 
X-Rspamd-Queue-Id: C8E93A0002
X-Rspamd-Server: rspam10
X-HE-Tag: 1758796669-936281
X-HE-Meta: U2FsdGVkX19OssT4KgreSXSkBLSis4ZnU9lWuQ88X6IkZwwK+xDyUbhHVo/8gxn059VpOlvfVKY6uE8G1Gz0IEzkm61jO0G0xkY2TysI7vm+FCWWOgVDpDAEjfP/3ZRBpNBAhHD1WmJqHYLDvS5pjlgp4l/6NUDXmBPPKF/slIQ4RBQNHe1nggv8pfqJMtUw1loqykVhdMk+WaaWZUbCOOt818RHdJuNR7sP77IgrbeVVM7EutL2Nx+H/OqwvGhCjMblqsFeVrqeBRVoGFTv+5fTUm7JJ9yCMNz4iap2izfQpYVNkuxbwJOlnfmmDF03zficl0glJ+GQ/+5T746CEtY/3I053EZz7faADjT3AY4qFTfOq6TJ8Rb3/nknSVpzzEFcooSNWuw+cpk86szv7Yl4nOgHKE6/Jtk+mliLyTLHMUVkDSslYMj4nNJcLH2w6dohh9QlbBL749A1jzLCpO18QDhVszAS8nvOzdjTO2HuygiUxzgQyBL+IkEZGcZQG+fQdM6f6d4p+I9ANVt6zXCIt6+uhiz1fujr4WYLqWgnPZxVSPKZy/1DpkHZAaZMqVJwQlL6PMBCcMEgU/WEMU1e+IEmC2bAoZpPh2xOJdxaKBhN+lpklH2ZIJq3tnSNagrWi4rRn1nw728HH6XbUucrzLozV8EVRMX0wWq2f/EVFGDr+FULBrYujr655bu1nNf85H7S26jvKFBt5AEQVstSdRcCKdHes782/KH/aOMou24POkWvosorfH2g4t6BOWah7J2RpNZQPFg5362Nmn9sNL2gzTalzzcHhuH42FJ5PpjVTMa+uulriQngQhewgaLcON71CUv+cfTO8ykafvI4j3R0sMGNSIb0GEZEnZMhfNBVn8nUhJAmGCy4TwVe/epov2oyE+F/VPwukv5ZT4vrfEPs394ZsY74fCnTb0KDbppw0eoR6G9mWc5iKQ+IFwulcI4OnVkYNvoxw31
 h9eEsKdF
 WZW1AWXnETd+NtYyY7ZovlOP0VInrAGwT8ai6ZJDjwGXzU3622YFqb6CP6yO5E546u6VmxiiGyQqGlKSeuAsQEKi796S3fWKVuUmw81uiErqZADLbrb2GgL+XnJX+zq2BKuZr9oW+rL59wqLsEbNOb4kdjMx6iKF63mQ0/Ba23+IV7OUe7WB7VGHT1V3jyEDLUcQZIAtVpIIuJ1aKy23To1EH/mdF9RKroIkaTbVlwklqvpnlbh32+D+LfC4Ph0sjgp+fViWjAhtgWHRqpVSA//3zqP6eDjPi+afBtdWen+3hXHh8+9vVTrZjcMblwB1CbrDe1CHCN1gKg3UUMAXUSoxz8T2m/DOE3WaA7aUjjA/bfmrSY5tW7KAjFkbtbaZzLpdqyq9CjXe+WIoRSpUfI2OfRlWRDf53W49U2ba6D5GUkM6UEejzqAorWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 12:33, Dev Jain wrote:
> 
> On 25/09/25 2:46 pm, David Hildenbrand wrote:
>> On 25.09.25 10:54, Dev Jain wrote:
>>> At wp-fault time, when we find that a folio is exclusively mapped, we
>>> move
>>> folio->mapping to the faulting VMA's anon_vma, so that rmap overhead
>>> reduces. This is currently done for small folios (base pages) and
>>> PMD-mapped THPs. Do this for mTHP too.
>>
>> I deliberately didn't add this back then because I was not able to
>> convince myself easily that it is ok in all corner cases. So this
>> needs some thought.
> 
> Thanks for your detailed reply.
> 
> 
>>
>>
>> We know that the folio is exclusively mapped to a single MM and that
>> there are no unexpected references from others (GUP pins, whatsoever).
>>
>> But a large folio might be
>>
>> (a) mapped into multiple VMAs (e.g., partial mprotect()) in the same MM
> 
> I think we have the same problem then for PMD-THPs? I see that
> vma_adjust_trans_huge() only does a PMD split and not folio split.

Sure, we can end up in this reuse function here for any large anon 
folio, including PMD ones after a PMD->PTE remapping.

-- 
Cheers

David / dhildenb


