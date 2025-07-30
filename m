Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5586C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 09:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3921E8E0006; Wed, 30 Jul 2025 05:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343958E0001; Wed, 30 Jul 2025 05:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259928E0006; Wed, 30 Jul 2025 05:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 173BA8E0001
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:39:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0366C03A3
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:39:22 +0000 (UTC)
X-FDA: 83720432964.18.B6367BA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5FD68C0002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:39:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZwszenE7;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753868360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vBb2D1EuitPhFOGonlD9FPgqvzl4qzBSMtXexC2pz54=;
	b=Smy44mdpnjZ5xfKIwPhyfxZled6q1F0bIU5gt+8MWrdexHTVyijBAyioyiu88CTdKq3HgU
	cXsq6QGHcxo2jdQqU75z5UveEUZSojdx0ALaXeTJZtA/QTciX04xD57nP/HOtR9PiJCZoV
	rKqpbMh7LEcFQM7IZoCHmceg64w6DTc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753868360; a=rsa-sha256;
	cv=none;
	b=Nm8r1HzLCU5nj+9vo+HCKJtBaNezHNodv7hGdUVSuHwMLXpmDXSmFFv3mlt3Z/uE5PDkGI
	B4cVEpQPID9mouXkceHiEyKRbaiOOqp8/4kjFargHhYBykIOZsSYE6QRu1ZyDFjOuTci4o
	u4Sr6IxO0X+xnFxBRr4MO6tlSBZwey8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZwszenE7;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753868359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vBb2D1EuitPhFOGonlD9FPgqvzl4qzBSMtXexC2pz54=;
	b=ZwszenE72YyFqighRPCDHES/cZ5rv0Y0XN4S09+MS2yYt6r0IMfarJdr3mhE7Q/c1kfK45
	2GAoShM5OA42y3CoTDc4JPIoJDvpLExOScjBTOJhFYh9CkYBBWICpPauF5DGsfC5HP+wVY
	DE6ZDbSwzkvpG7ZuQg/NdIRZlXYDQ/4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-IcvIy404MBmGfokQ8PHvlg-1; Wed, 30 Jul 2025 05:39:18 -0400
X-MC-Unique: IcvIy404MBmGfokQ8PHvlg-1
X-Mimecast-MFC-AGG-ID: IcvIy404MBmGfokQ8PHvlg_1753868357
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4588fb6854cso7139365e9.0
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:39:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753868357; x=1754473157;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vBb2D1EuitPhFOGonlD9FPgqvzl4qzBSMtXexC2pz54=;
        b=mlVlBPoM/iFpU7dkXvHxrMJlWW/eRHUSHTsx1aHMML3XyKMoUyWwfbf3TvoAdt7vKy
         ZyIAADnUt59Vvm7D2qhZzzUCTaDB0fehlimGzqfGNZUZZqS4IGXZr0L5h5kq1FnZUn2T
         POljcvvFI/V5tW3TUVD346O54vIw6enQAufRAiSel2+wvY7BPzGeJibOPVdrBklKK8fp
         bbo52Npjiv4XkLjrp7izAcjIUQ/bcu6ic88opVV7x4ICpf9MZunvG5++T4MFueVAxuEX
         ef9FJQ7aIHxbMvmrAf5RlmbYP8Srp9UYJmnf0++Ka5jkbSVfNiIuXBvYCYlvGbSGzZKL
         3P4Q==
X-Forwarded-Encrypted: i=1; AJvYcCU1bMlIKw/gVhBrt+um0Vi6gWmnPp5o6K8KMa2EAbHcWavEKxQZa2tYze/Fu7tw6lgIUKix5U4C4g==@kvack.org
X-Gm-Message-State: AOJu0YwtshoKERtns+In6XZcNEuaPdBw0K2dMlmUhqJGZmAXhBaSc1HI
	Xn5U05YaXClw9ojRkM2R09pgsgBZiDZDc39N9TQnpFpfvG0m09qQeEADZvjGf3IUJkDRGwHIVA+
	q7RsZsh4mlF94Agqiwla3X9LbpDwfUrvYFPlSFTypsczMNDCF/r0xGQDwjPY+FjiJOA==
X-Gm-Gg: ASbGncsOglqy/89niRsSJPZMK7wmJbwYpa9H6tsiayHDxzZXtzTlPyzE4gNILhx5tSH
	Eh8+Qna/m/7amGHx9s1A0q3/sAdn+vITg2pdgnLu3zZ4fPWaG6JWb4y1yuBPBjwegblGR3bdniz
	mTFrPBirpUi981fJ7Y8CFqiBIX8ch9d5patwQintbmqqKxpDtiRlLtvcRiAhvhQSDoDOdsB/Fow
	7sDlIBDzIXEfXjdQoIAaTY1WGqXSAZGR9BDK3cRimsGh1WEqQMFtAbqsasgaK2v/Ze6O4vrWsSN
	vo0/V7C6HAvVzy93LYrzORXRIEV/7ByZ01OoCShhMD2Pirv2TzPOgWtbD6AXAg==
X-Received: by 2002:a05:600c:3483:b0:456:8eb:a36a with SMTP id 5b1f17b1804b1-45892b9d8b9mr23572575e9.13.1753868356969;
        Wed, 30 Jul 2025 02:39:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSVYa1i2eUOdl8t2BxWHnL7M0RicJPCMguE6gSyTk5SMkJD18M7PgmwqcilerYSTujf41Jgw==
X-Received: by 2002:a05:600c:3483:b0:456:8eb:a36a with SMTP id 5b1f17b1804b1-45892b9d8b9mr23572295e9.13.1753868356391;
        Wed, 30 Jul 2025 02:39:16 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45895375163sm19361165e9.9.2025.07.30.02.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 02:39:15 -0700 (PDT)
Message-ID: <e002f5b4-ed12-4229-a88f-33447990ba29@redhat.com>
Date: Wed, 30 Jul 2025 11:39:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 0/3] mm/memory_hotplug: fixup crash during uevent
 handling
To: Hannes Reinecke <hare@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, Hannes Reinecke <hare@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org
References: <20250729064637.51662-1-hare@kernel.org>
 <20250729133806.979475704b1162d7aea99b2b@linux-foundation.org>
 <907ee759-6051-4d47-bf09-cea362ac0cd9@suse.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <907ee759-6051-4d47-bf09-cea362ac0cd9@suse.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xPPKU5zfJqoCPV54AxDocszRtxYDZHyGb4OurmLCCEA_1753868357
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5FD68C0002
X-Stat-Signature: nk6oj3am6hrdbjyttept1hbfepayyzhy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753868360-521234
X-HE-Meta: U2FsdGVkX193VjZphv+tpivHtF8MQiAgz5xjKryvnc3KeMFONkUCv7q/1MiDJAQnIXaRxiwNRaC9zGRWbJrzF2WUI8+gectNMpSZfMjWmw57kAYtVrySzMzPGo0N0fEwc8/89NUm3HTL/d3BStto3qWKdPm1Db0OPG79WRU9Lpnfj/ABqzrNZHXf+J56tFp+IlEdMWtbWL8q9HKqz44wjXI8GpiCTpG1WprmnoYmt1N0cnI9yX4v3xNClaHG/beH6T7YGybEQbaLdKMmQOWCVIgGh/iIvVZmB9T+sfkPKnbT+hYhg4DcU6zoGJITy2VoAOtkBlA8ozzPd0fT6eYOjwqZO4ZpscS2YX6sP8Z0ISPxMRlasYkBKf4SG/aThZmhwesO92auG8SzSMwtaAt7MeRoojKmEhkZFuWMlbphKNdlRz/wunbmm2o4iJghnhc1SC3lwbS6HwF3CCmmt4ZxJcxAcv2V5WB4FwJGMzjEp5ExntcmUU2c6LWXSsOd4iVkT2zo2LgLzG/jp+if6QjNfRM7b5gyeZ4Y6X1m0HRfCe/E2/RTtd05A70457bbWVnkd9pdPLAqKmJqxuCMbYvPjIm82Nx84aPUczNdJbwqh41iIqmfWM9WzfpuuvDcSWSrXhIf8mSmP0yKdsKBM64meTkS7S2ZcW1In7tBO8CHNSfq2AhTH7GF9k2leOl7p59SdJG/Q4S+Rn531Uq38W7caUw9tkN74MLWiGH8rqQE+uBNXDF+WZOMNOaRtsvD/Lof2FOrdI5HCXRnCXRyjC6HNyAC680euVly/zz9vHe4uwfDo+/p/qYyLgmOdjXjf5izd2dk8GEJve8nQB9DurTymUlEFXSOTuDJHwEjn7RV6+qpJnx7OfvhQgWgMcN09xBss3peMAjXXNTPziSUi4dC/GR5CFtEciBEc8Q0qVONJo80wDnrNdUtUwK6JYXJgYnUU708UO2qnOuJUgUdBz3
 Ha/GwDi8
 0v4eCudchq/zom6oun1Kby2aEOk1gG/C0DXy5gnwFg2UhKu5I4GhVrgXTaOHmEgVWJ8sc9148PNKJoW/i74lL/gH1zuEUHCICPvyvAy6929k4INumXwQe6j808EbmSElgnr5CGtjahHooU/Z9AzK+Ga+aEdZ3bHAa86bWaUBW5BQal5NP1rgwxofqU57j//EuoYVwDEpsytFTHzV5EFf/2VLKHdHgC1vbT/Izs8XDz0Uzh/v36oCcMHMBJOoPi1MkcizpM0iySsOF7aMupyZJ4PXFhzZEWau9Da6LxlsnyiM7rCbASwasV8zxyQEH2en57/k/27IEh6d7aZGfFQoYGlINO1pEvsf9TFdBnlLIjSe/RyVbaBjQ4metpU2LFsDuaoe9zV/g0FfvalQz3mfVWXAPN0l8Ck6Iovb7J2r91SXwQ3+q2vTTLYabyBJDROwZnA9KG7AwOd8Ptcnv/hdLOyfcPWBDRAwWRvq4wQA9/VV+xtA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.07.25 07:49, Hannes Reinecke wrote:
> On 7/29/25 22:38, Andrew Morton wrote:
>> On Tue, 29 Jul 2025 08:46:33 +0200 Hannes Reinecke <hare@kernel.org> wrote:
>>
>>> we have some udev rules trying to read the sysfs attribute 'valid_zones' during
>>> an memory 'add' event, causing a crash in zone_for_pfn_range(). Debugging found
>>> that mem->nid was set to NUMA_NO_NODE, which crashed in NODE_DATA(nid).
>>> Further analysis revealed that we're running into a race with udev event
>>> processing: add_memory_resource() has this function calls:
>>>
>>> 1) __try_online_node()
>>> 2) arch_add_memory()
>>> 3) create_memory_block_devices()
>>>     -> calls device_register() -> memory 'add' event
>>> 4) node_set_online()/__register_one_node()
>>>     -> calls device_register() -> node 'add' event
>>> 5) register_memory_blocks_under_node()
>>>     -> sets mem->nid
>>>
>>> Which, to the uninitated, is ... weird ...
>>>
>>> Why do we try to online the node in 1), but only register
>>> the node in 4) _after_ we have created the memory blocks in 3) ?
>>> And why do we set the 'nid' value in 5), when the uevent
>>> (which might need to see the correct 'nid' value) is sent out
>>> in 3) ?
>>> There must be a reason, I'm sure ...
>>>
>>> So here's a small patchset to fixup uevent ordering.
>>
>> You know what I'm going to say :)
>>
>> Should we backport this into earlier kernels?  Seeing "crash" make me
>> think yes.
>>
>> But only one patch has a Fixes: target, and it's with the Fixes: tag
>> that we tell -stable maintainers which kernel version(s) we want
>> patched.
>>
>> So, still assuming "yes": is it possible to redo all this as a simple
>> minimal patch which is suitable for backporting?  And then a separate
>> cleanup/refactoring series for future kernels?  [3/3] doesn't seem to
>> be needed in earlier kernels?
>>
>> IOW, if we wish to fix this crash in earlier kernels, I really cant use
>> this series as presented.  For now I'll add it to mm-new to get it a bit
>> of exposure while we decide what to do.
>>
>>
> And here's me who thought we were doing upstream work precisely to
> _not_ having to do backports :-)
> Oh well.
> 
> I see if we can roll patch 1&2 into one; guess I'll need to do it
> anyway for our kernel.

I recall that for simple backports, it is possible to request 
cherry-picking related cleanups.

Patch #1 is super simple.

So I assume this can easily handled on the backport side as is (with a 
bit of manual work).

If need be, patch #1 and #2 could be squashed I guess.

-- 
Cheers,

David / dhildenb


