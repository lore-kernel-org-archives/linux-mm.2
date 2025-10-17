Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CBFCCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 15:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B693E8E006C; Fri, 17 Oct 2025 11:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41E08E003B; Fri, 17 Oct 2025 11:08:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57208E006C; Fri, 17 Oct 2025 11:08:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 957878E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:08:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54812118992
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:08:01 +0000 (UTC)
X-FDA: 84007936362.16.7E097A9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id D7EFB140008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:07:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="XH6Rcs/H";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760713679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9X1BIc43NGsZkRZORFu1zjHPZ7Rg9eKPpWeWjUt83E=;
	b=nWFMFhwcXJKlLeJBDaJmeemPOt84vU7lLEtgWQ72Zu7b8I0JiDXfFC57xeVXwB2/SNgEoy
	bWdItrOKlhi42e4seXEkyBnJae5H2dDEXw6AaKhZ3083iGAf8cLVlPdN1RFRwoqw1WJkR6
	YDsbytPefrAchZRl9wwKiqLDiNYJJbg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760713679; a=rsa-sha256;
	cv=none;
	b=Vs6e/9HKJRBjkIgIjddvbGPnjqU+nZ7ooGXLtl9ydTK2/CgEG5WLsDMWF+Qijc6gXPTftV
	6LcspnlVKfWgxa/RQILpezMflIBhhXrgQQyJ6rMXfqsin5PlEaP2yvXfAD96EPXBPkukcD
	gL8RIJLeX6PXE7OVDI7qk5L8nhRU0Qc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="XH6Rcs/H";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760713678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=J9X1BIc43NGsZkRZORFu1zjHPZ7Rg9eKPpWeWjUt83E=;
	b=XH6Rcs/Hmw76CimagWexwKTeok//FL22p7oKG2qD1r1ZDBqQOjSz78/HZmfG/49ZQlzoSQ
	4MV00tcOl75KqQTu6H2doeZSbCbIzOsl3iEnlXbS9wbs00VjUWYNye71uzWBUCuVKNUi+e
	ndm8scpSkwgBFjDqr7AxDPCaxzVYMr4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-HSGRd9qFPsanUks5QPyOmg-1; Fri, 17 Oct 2025 11:07:57 -0400
X-MC-Unique: HSGRd9qFPsanUks5QPyOmg-1
X-Mimecast-MFC-AGG-ID: HSGRd9qFPsanUks5QPyOmg_1760713676
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-471193dacffso5946685e9.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:07:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760713676; x=1761318476;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J9X1BIc43NGsZkRZORFu1zjHPZ7Rg9eKPpWeWjUt83E=;
        b=OlHf4LQfivyADcMJwL9US9sH/b243vnnhxlMFpbIJzRnR2ibu5f2lcwNI9Tyy1iNRf
         viDV4ojL/SQoiKT230BNst2hedoKgCZ7FK1HQEPSnzhWd27l+UOKm4RxQe6sNx6B7ngU
         nqd3TsjnKiX+9Lzk/jEkBC7lMSsp/fxY4A7A/hrHXzCyKCdADtTALaBc+xr/exqTz2Te
         TZBRZIynjvBKEM5RBQ3XBGSbUeht9t2ty/koh8u4xvdmECzCkwCRACxtQnNQYUw9zc2H
         gOHgP5CH+d1OpkIeXQrz8iAw6vFj6WznDk9ZulONca/CDfDkOZ74kHNXr3ydUitd7cXD
         AyuA==
X-Forwarded-Encrypted: i=1; AJvYcCXm+/Hnga8phkost/oqOlmKf2h1nJTCYPlRRBLv95pZLhNf4jr+HHUbMFgbTTICjGI6kUYwLcU16g==@kvack.org
X-Gm-Message-State: AOJu0Ywz8fCazNa5Ag04+7gJ3QdGg1q3E80xkNNvfvCidSmvXKSGykWB
	HjzMwn4PAGP44AsmzXDGzJ9x+OCq0j89r32j4MzRJOTy3AARP4ojty6s4LXWqTwRhrUha9jAZzh
	AbGtrG9xClNosaqMe6kRd+Lzqa3MYjnyN1cXMBLtyhi9CczSn35yG
X-Gm-Gg: ASbGncvjqvfcHX2mo1ETeXTfyimbtEBzYLhBTC+F98ZBMk0SVs5e1w0wgLbTojFkz3T
	s5o6NzoEnlrFVNFnpkuWHFOFH4FkFoelFRmEzxQR/dC1k1hA2B/2LTuaun5WdE51AFKvaTadGvo
	ttL+AoH4nw79rV/7xPdHLwcvdkyS5RH/NxPEM5h0kzCKR6SiSIlc0BI+TGs7pby9dGuQhPAjM0B
	7rAbqkQLjIg2IMZ0x7kWZj96Lr+Z5sP93rgvlGyBiUy9gZa4khsqXqHDZPRg+aaZfOIXYNAdJCY
	Czsj1O/Vjz4yxeITlyAon1JDUJp+E81jBCOVra+dyOsRQ5v2+IQSPhDfQ0jYkeTAADKqxz0mG17
	6nsqVa7qI9dTQ+flBKBTtjnufsvDqBbBNTGv7CmSmM05OcVqYBMsEHZgMPqQOeDL+PRSU0iuz9I
	uQkCrTqSL++osdaA6be/RCHmge1IU=
X-Received: by 2002:a05:600c:818f:b0:46f:b42e:e361 with SMTP id 5b1f17b1804b1-47117931c89mr25044825e9.41.1760713675702;
        Fri, 17 Oct 2025 08:07:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeV20qcvkEmPA1bp02PI7vEzOGbT0hRxWJer5oIgjdZd36IQslHVl6fowxmxv1EbzRsULEwQ==
X-Received: by 2002:a05:600c:818f:b0:46f:b42e:e361 with SMTP id 5b1f17b1804b1-47117931c89mr25044545e9.41.1760713675293;
        Fri, 17 Oct 2025 08:07:55 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47114428dbfsm85439735e9.5.2025.10.17.08.07.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 08:07:54 -0700 (PDT)
Message-ID: <8c778cd0-5608-4852-9840-4d98828d7b33@redhat.com>
Date: Fri, 17 Oct 2025 17:07:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: KVM/s390x regression
To: Christian Borntraeger <borntraeger@linux.ibm.com>, balbirs@nvidia.com
Cc: Liam.Howlett@oracle.com, airlied@gmail.com, akpm@linux-foundation.org,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, dakr@kernel.org, dev.jain@arm.com,
 dri-devel@lists.freedesktop.org, francois.dugast@intel.com,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, lyude@redhat.com,
 matthew.brost@intel.com, mpenttil@redhat.com, npache@redhat.com,
 osalvador@suse.de, rakie.kim@sk.com, rcampbell@nvidia.com,
 ryan.roberts@arm.com, simona@ffwll.ch, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-next@vger.kernel.org
References: <20251001065707.920170-4-balbirs@nvidia.com>
 <20251017144924.10034-1-borntraeger@linux.ibm.com>
 <9beff9d6-47c7-4a65-b320-43efd1e12687@redhat.com>
 <c67386be-5278-411d-97e7-43fc34bf7c98@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c67386be-5278-411d-97e7-43fc34bf7c98@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tuJkYymmEBRQjjlNqekZ8PE-sEmN0Y7M_0bX4cUkdZo_1760713676
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D7EFB140008
X-Rspamd-Server: rspam02
X-Stat-Signature: k7buoufaeq37za1gah74kx1x5goosk5p
X-HE-Tag: 1760713678-410963
X-HE-Meta: U2FsdGVkX19yMh5Vi4HbK9LDICK7woy5I7H3JViwmWPC7rYco0mdPz+Be4QlIhQS4FC90GtXuf5a3AhEbcLHM9H9RwCidXG7XtIq3KmThv0sOy80yiQVIlP7+8EzMe8vkDplJ2bm03n5cPmyjaGKlTYx9zCurt0Jx8Im9ghLeBedVdER19j/n+aL2U1ZgYWE9Yi/KZY9oxEN01Rd1C6wF/prRkL0++buCmf3Hq+tZj8lbCiCz2YMUsL+kG6jqpJN7YDdPy0b0zxHdzXS+UWnQH37yJV2K6WC+PzuE1fUDDPS1V5jes+RqGaBMFbbgaG276iMjDFigK+VjKZJeLhQ6r2FkkleREfZlGFZ0pCmAt25QvjMmd7Aexuvhhzq6C7oEHDe9oyZXOlQLJXef6EZtvaxCBiU9bMwBUuDROqdKXLPyesROZGM+YUZKKI6PoCw78njcRz+gVDjSg7SGqCunTrsgOgEiecsCb/GCbiMJdMCHlW2Ekd+Q6tQaS7anB/rfJd/tENuaxbvg6cx3fPQGI9KRJdVC6QQ2QJTDGIJj/p46k7/p0EXzPF+FrerfSQR3/Lb2DDqNZLr/Qo9gQs7+qQm+SeX5q0ZFMHyZGYbGSQ9QaKNsuMZP5oRZ6KTSifV5xCKiQQ+Yp3iTRPSpHKjgnJgBVqn3K2ZA3n1YCMkiuUZlAcgMLjREZL+gNKdYk5cwwDvohFKHAg4LHvBiIJ72vbFXBw/FbttLaNZGzjouMTq2+78UhEJ3wsB1fDMrCBJVDWai3qk6we2WHH+nw31yOemkY+naIncLbip22XQkjahS4xr4RK2XIR2Ht0LeKgCfh7BwKha1pZSg9o/GZxaKpeCaru28kfjYLvHT2rjeeU0KNWQG4qi5TAKAllYYZK7k9Rx/mMQnp5cAY9LRjbX2AXWiEZk1rTT0kSinB+bGQQQrZJ+t4X3np2uHbKduFk8PsfhdymclPHix8dZzJR
 JsDnb/sK
 PrNIR9OgcvvzmeqeMOT6XDmpMD5s2B25Q7WE9s0NQZY6QYH6yZIkSEfx8iI+4TpDKgzTaybmCvhHFiCrBDEwmuQFTmSeD9O3MQuxeHzdisQ3g0ogHQN53ftxBjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.10.25 17:01, Christian Borntraeger wrote:
> Am 17.10.25 um 16:54 schrieb David Hildenbrand:
>> On 17.10.25 16:49, Christian Borntraeger wrote:
>>> This patch triggers a regression for s390x kvm as qemu guests can no longer start
>>>
>>> error: kvm run failed Cannot allocate memory
>>> PSW=mask 0000000180000000 addr 000000007fd00600
>>> R00=0000000000000000 R01=0000000000000000 R02=0000000000000000 R03=0000000000000000
>>> R04=0000000000000000 R05=0000000000000000 R06=0000000000000000 R07=0000000000000000
>>> R08=0000000000000000 R09=0000000000000000 R10=0000000000000000 R11=0000000000000000
>>> R12=0000000000000000 R13=0000000000000000 R14=0000000000000000 R15=0000000000000000
>>> C00=00000000000000e0 C01=0000000000000000 C02=0000000000000000 C03=0000000000000000
>>> C04=0000000000000000 C05=0000000000000000 C06=0000000000000000 C07=0000000000000000
>>> C08=0000000000000000 C09=0000000000000000 C10=0000000000000000 C11=0000000000000000
>>> C12=0000000000000000 C13=0000000000000000 C14=00000000c2000000 C15=0000000000000000
>>>
>>> KVM on s390x does not use THP so far, will investigate. Does anyone have a quick idea?
>>
>> Only when running KVM guests and apart from that everything else seems to be fine?
> 
> We have other weirdness in linux-next but in different areas. Could that somehow be
> related to use disabling THP for the kvm address space?

Not sure ... it's a bit weird. I mean, when KVM disables THPs we 
essentially just remap everything to be mapped by PTEs. So there 
shouldn't be any PMDs in that whole process.

Remapping a file THP (shmem) implies zapping the THP completely.


I assume in your kernel config has CONFIG_ZONE_DEVICE and 
CONFIG_ARCH_ENABLE_THP_MIGRATION set, right?

I'd rule out copy_huge_pmd(), zap_huge_pmd() a well.


What happens if you revert the change in mm/pgtable-generic.c?


But the whole -ENOMEM error is a weird symptom.

-- 
Cheers

David / dhildenb


