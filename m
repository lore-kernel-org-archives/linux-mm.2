Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15C73CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 19:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFD218E0003; Tue,  7 Oct 2025 15:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4D88E0002; Tue,  7 Oct 2025 15:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3AC8E0003; Tue,  7 Oct 2025 15:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6A98E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 15:35:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE06A1A02A9
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:35:38 +0000 (UTC)
X-FDA: 83972322756.30.8C5EB3E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3156CC0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:35:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gDq8hdat;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759865736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAfzTxWuab53JE8Gy3AGdKtPMv/FNNv2702EcVDBDzo=;
	b=rQ9zovd93ptsieGQnp6peocITCHd42wCd2GBWDeYLNHuBHi4AxblV/AVFwIn7xVnm5wuqS
	M4/wm0kqeQbHQ/vBjmnD00F4bp2DscDgWdLwcZFCD6dL+B72Lz82b8NC9S7SyB3/pRrYO5
	Vy7CuMiGzqaQwxBbGvqKAJl3BhLv51s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759865736; a=rsa-sha256;
	cv=none;
	b=yUAPlTz/gcAWkeFAKBpzrMS1KL7OCtPv5enkDSODYmrYyK85gl35g/uud30RlegyGqOIc9
	WI/K/pMeD/ld1hHEl/4xGklkCm9RN1pxP8lryTwKhjZT1am5KgJGJl3/c7d7tPkc6gCP1h
	Ju9RpYPmucz04yDPMgMviTNsIkNU5kA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gDq8hdat;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759865735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RAfzTxWuab53JE8Gy3AGdKtPMv/FNNv2702EcVDBDzo=;
	b=gDq8hdatFRQs8oUcR2ODaZVibfHlo/Fi5qZPkq+E69fFOPNzmAUzIjSfdcq4UVCq2XQqJE
	WkEL25MJIMhSQF0FSPEQMUmjqCg3ceKGDyIBhGfBelc556pwdrDtvPNZctJOyJu8i4jh6u
	rJjRjyNP+GW5lfr59gn6sya1pBCEAmY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-EoDIZbXnOT6PpVf7q0qK1Q-1; Tue, 07 Oct 2025 15:35:33 -0400
X-MC-Unique: EoDIZbXnOT6PpVf7q0qK1Q-1
X-Mimecast-MFC-AGG-ID: EoDIZbXnOT6PpVf7q0qK1Q_1759865732
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e39567579so29297345e9.0
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 12:35:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759865732; x=1760470532;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RAfzTxWuab53JE8Gy3AGdKtPMv/FNNv2702EcVDBDzo=;
        b=jtch4LwLpz+x5x3neqK2P68RBt6X56rAxUXnTomzHBeY2gLC8QWOjtXuV7uBuHwinW
         iSm8/jZdJ1VfeihkpSfi+qX9/ncV+ss7IdmJPvmf4aDTxBz/ASMm9R+4h+yUHiBOFJRq
         JvpaanDjZ5W3umctPYQ9nnoDZpTxA54//83HbWvegjV9p9zDgznp0gD5dOc+3ad5j+kI
         eCfsGtKHWNV4uCBvvpCyjYDrnQvA7N8NEXnOSFerRgUA51dXHjs4bZTPtCGUTod260Tc
         fuQc4pJG0VwK4VCvCq8r1BAAiYgQw0K84N+D1ug2XOED8GgMnUNtp2AVGDGZlmZI6U3I
         r38A==
X-Forwarded-Encrypted: i=1; AJvYcCVCR8EzDiKyoXnGMp4OW8TZAcllETt+RtETKsYsXSwuiHeQ52h3eYL+OuIxzt/3fayfU0KPUxchDg==@kvack.org
X-Gm-Message-State: AOJu0YxxLxQbuyF+sLzXPfSso2TvKyGU2qQb3Y5KPrbThR/7DeDM/hjY
	RNu06iNTHd111BsZR3zHh5TQEjA9am/B9K/uNjuhriHAZjZgI6L0fbdnpY+rZvmXNw2M1X+mTDw
	aBgwSMS/rUGt6Uru8RVBKi4J30ORz1X6NsoyITbqBqgKaL5vR/SmI
X-Gm-Gg: ASbGncs7rViDDQQ6KzkH4hICYUBLsfcTEtERFbM2uLTnmCqj0hQo4hCg03GUjHYIFox
	00Y4TWr+i9GdyDG+7En6s8JbAi92s8Mssh5+hbr+QPGB8Oi4+aO9JgL2TbjN91nVUqwrtfsa9TP
	PBR8DRwqE9IWh2Dw4HtOHhk7P98Otx28HisIztDI7lOAcHAX8iQRNomvFPAE8rO8HseZmBBxB8N
	6OBO7fJeUtOSCaSbKeU2FrXancS9ZqKz5cK1rApYh6DnPC6GAMoqoVxl1gR5Ldf/KuojWGdqQWu
	pYYRTIpb5UQoKRooFWBeJfgiFHEvK9/zGyDqE01an1I7tpSQQ/6p2L2dUHiiiNaGhmO5KITrvFx
	KDMZQcask
X-Received: by 2002:a05:600c:1986:b0:46e:4246:c90d with SMTP id 5b1f17b1804b1-46fa9aa4711mr6325725e9.11.1759865732184;
        Tue, 07 Oct 2025 12:35:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCN7DAOe0T4B7zFqJ7eZ3GMf7f3SbobsOoyW6DhHtRl7kGlkXWNnfp4MoPqJQerU+j3+Qa0Q==
X-Received: by 2002:a05:600c:1986:b0:46e:4246:c90d with SMTP id 5b1f17b1804b1-46fa9aa4711mr6325625e9.11.1759865731749;
        Tue, 07 Oct 2025 12:35:31 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9c2a39dsm7330825e9.18.2025.10.07.12.35.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 12:35:31 -0700 (PDT)
Message-ID: <5e3b16ec-9ef9-483e-b97e-bff0c1915b19@redhat.com>
Date: Tue, 7 Oct 2025 21:35:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Support dynamic (de)configuration of memory
To: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-s390
 <linux-s390@vger.kernel.org>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
 <ab366c03-8c78-449d-bfc4-2d155212d9d7@redhat.com>
 <aOVUNmDiWgrDJ1dJ@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOVUNmDiWgrDJ1dJ@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PlSQkbiQ5RxliFse65xCLz7foCORsj8oMhCGnWWyOZo_1759865732
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 9rq5798x9t6r5gsfk4shimkxeb4n9e5x
X-Rspam-User: 
X-Rspamd-Queue-Id: 3156CC0002
X-HE-Tag: 1759865736-317647
X-HE-Meta: U2FsdGVkX19SM+ikVuLLY9RTY0anyWil6rbDrdg4TPDm7L4Ez8+aDbnPZDECEc0XEfKMly5fkEzhi83M4fupM49ezuih+6zAO1ALfoggcqCqg4OgErgPzOf/li7hN/YAyWKpslRKBF4EUcQOc6biH2veDmeNTMheq2/L8NoU+1F4+mA+jwDSLG+IR67GyeAuBW25CS7mXWRr4Ey/Zc9m+2pRkWDB3zhM+85wn/1k5pAt8Do2lJTo0iXFNP7uExuvo6vOxR2PWyugM2egt1LEaWOsWcc+JhkwiBvMNS1M9x29As78hrSD4GwcX4awIgZJpP0ywXICEzeHEfRKy4i6/RxqrEN+1KOY+5dFCmPgTDw5d7QgCoFBzKIX4phtvOzzmS4poUxQKN7v6JybQpLcXPSoA1rB3isKBSfTdEihPhtX1eAHcp9e6Gr2lWu00+9FOjRNhmKOq/LKP6u2g+m3mRX6EtEvU32sb+xF8iY7XuihX6ICD+BagbOMbIv7TeVrlWPoYFJbD3Uf3aKyaT+rDRxRZ8tmyqjV3fpsQysZWFk50iIqHvQw7mWwhmgKVlS81RgYZKj652wuv/4Gc3KEDDbhBYpyEp8qA//DJTuXSTORKm9Ls0S78bpdsT8mw3ng9ATeL8gk4A6LMtrkuONBetHqodFFwcrTNXcuRgQhUytzoOC+rZbeGMQ9/Cvr0pkVbwZqygdterKKVybS2ohL1M0uwNZWx4j7cY+RHCia5/yeabshlRbHUXnF6K2TGyODliitLMxp1s8IG6TBeVl908SxjipT/PW5mZJu9ug3E+m3V7btMHRAxf0aIue5ppIaHmPz2Jo2pkPA0jTRiceYRs4U0vuU/Qd/BdVnNwfve2ZThRESfXLPK73CVaq3JWeDsD3WikB1uDwgoIdUVyuEcmZxx90YH3CjIDmzzGQYSUlu8uROY1eMuIdC6+KgQqdcsIR9uyOUXokWwNb4NuO
 e+zNVqi2
 SRqD/Vvfvz/cUemHRvO1tC7Odh01OKe1uPXRmJwlEqcza1tZdtF1AzAqp3bAqsW8qRPQLP8KW1+fsDzZITaIFNHK6B/xwL+8vZA3BY2Ffrxhpqrx1q9MoYLz6zUCyuDYFn+Lx5XV/9WXb8lnypgHtA20P2LO9Vo3dDRQ0rXCvYcTK4r4I1meRMl++itALc064oOmAdAiXhH2U0DYAEXGJMmeBVVUar78Hu1q4JAH6MtVwtbLnn7fzKiZ4MHVj40mDf9CiS+RIRwsKQubxFBD54EdLC2T15djRjfYo7tDhHIFAk06B1NzOKm3JADUtCG8ggoYm1uSxPMspXUUsCS0GH3aheQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.10.25 19:56, Sumanth Korikkar wrote:
>>> With the new interface, s390 will not add all possible hotplug memory in
>>> advance, like before, to make it visible in sysfs for online/offline
>>> actions. Instead, before memory block can be set online, it has to be
>>> configured via a new interface in /sys/firmware/memory/memoryX/config,
>>> which makes s390 similar to others.  i.e. Adding of hotpluggable memory is
>>> controlled by the user instead of adding it at boottime.
>>
>> Before I dig into the details, will onlining/offling still trigger
>> hypervisor action, or does that now really happen when memory is
>> added/removed?
>>
>> That would be really nice, because it would remove the whole need for
>> "standby" memory, and having to treat hotplugged memory differently under
>> LPAR/z/VM than anywhere else (-> keep it offline).
> 
> With this approach, hypervisor actions are triggered only when memory is
> actually added or removed.
> 
> Online and offline operations are common code memory hotplug actions and
> the s390 memory notifier actions are none/minimal.

Very nice.

> 
>>> s390 kernel sysfs interface to configure/deconfigure memory with
>>> memmap_on_memory (with upcoming lsmem changes):
>>> * Initial memory layout:
>>> lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
>>> RANGE                 SIZE   STATE BLOCK CONFIGURED MEMMAP_ON_MEMORY
>>> 0x00000000-0x7fffffff   2G  online 0-15  yes        no
>>> 0x80000000-0xffffffff   2G offline 16-31 no         yes
>>
>> Could we instead modify "STATE" to reflect that it is "not added" / "not
>> configured" / "disabled" etc?
>>
>> Like
>>
>> lsmem -o RANGE,SIZE,STATE,BLOCK,MEMMAP_ON_MEMORY
>> RANGE                 SIZE    STATE BLOCK
>> 0x00000000-0x7fffffff   2G   online 0-15
>> 0x80000000-0xffffffff   2G disabled 16-31
>>
>> Or is that an attempt to maintain backwards compatibility?
> 
> Mostly. Also, similar to lscpu output, where CPU status shows
> CONFIGURED/STATE column.

Care to share an example output? I only have a s390x VM with 2 CPUs and 
no way to configure/deconfigure.

> 
> Also, older scripts to get list of offline memory typically use:
> lsmem | grep offline
> 
> and
> 
> chmem -e <SIZE> would work as usual, where <SIZE> specifies amount of
> memory to set online.
> 
> chmem changes would look like:
> chmem -c 128M -m 1 : configure memory with memmap-on-memory enabled
> chmem -g 128M : deconfigure memory

I wonder if the above two are really required. I would expect most/all 
users to simply keep using -e / -d.

Sure, there might be some corner cases, but I would assume most people 
to not want to care about memmap-on-memory with the new model.

> chmem -e 128M : optionally configure (if supported by architecture) and
> 		always online memory
> chmem -d 128M : offline and optionally deconfigure memory (if supported
> 		by architecture)

-- 
Cheers

David / dhildenb


