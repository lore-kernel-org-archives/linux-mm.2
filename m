Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 718A6CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25B58E0003; Mon,  8 Sep 2025 13:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD3A8E0001; Mon,  8 Sep 2025 13:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C49D8E0003; Mon,  8 Sep 2025 13:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0488E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:30:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1053E1A01C7
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:30:47 +0000 (UTC)
X-FDA: 83866772934.14.36B65CC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 950DAA0010
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:30:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Dn7M4n/u";
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757352644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAwcm1nPLLX4X92euXLnYeRyvAbGSoqBmBe5SHTlwFM=;
	b=dkAjO+/4qQnLE3SjzOVB3SKWeZxNUpsrXgnQf5OFamOGxWN/PnjplHg7+9C+RZUoiueou2
	AN3V1vx91fv8ANLEfO2ei2kiHVdc4l1SuRBvw9kJc4Jv9EV7JJoADKYM2+EAvFfIvpC3x0
	jP9FEtEAwdLxagGkKr2wckUBqKXbRFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757352644; a=rsa-sha256;
	cv=none;
	b=G72jDH/Cr6NIhEiQSyQ8SMSPi9kdMZ6y4vlvxEUaaX/ZZrb6qqfzXjAzhAOAAdi4o1Vy6G
	TQ9DCGTB1425IDi3bpszJgfKI4GeSkVnSLLxforTZuL/kvbw7KqPpnzZzOhkBrUUSugP08
	qJXlIucgyjCSWTOClY15ZwheXHbNaSM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Dn7M4n/u";
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757352643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RAwcm1nPLLX4X92euXLnYeRyvAbGSoqBmBe5SHTlwFM=;
	b=Dn7M4n/uL18CMRQz3835/ibmNp3mKtqdrGsHyDuHwXrWSd9n9XwKPXPuebjYRvyvLn0AEK
	90OcofXxFVLc1JTLQL2xH1fgU72W8KZ181QtsHksJXYHhQHQyIJIlixtNEW0L3b0rvmddA
	a1dlOnc5fk0SIdtPn+HoxEBvYbp0ePc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-56-V6U4m0mjNHi_T2H8uX3hvg-1; Mon, 08 Sep 2025 13:30:40 -0400
X-MC-Unique: V6U4m0mjNHi_T2H8uX3hvg-1
X-Mimecast-MFC-AGG-ID: V6U4m0mjNHi_T2H8uX3hvg_1757352639
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3df3e935ec8so2193132f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 10:30:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757352639; x=1757957439;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RAwcm1nPLLX4X92euXLnYeRyvAbGSoqBmBe5SHTlwFM=;
        b=Hlz8MWvUV76BPg/fIbFP6GxlfA7+ymxre3PvQ10jT+duZgKGgPuacrZlMYkKCanwoH
         HaK2s6XO+KLgxPVFAjJUoJe6YixDjnch3k4PL/gdFnTzQIDW68wVPxGDunA2xUmd9Lph
         VUmeTgZSQKzYaGzNF7tOF1pWn/R1/O7no9l7DCBrAUYCLc08NpyC+dqzjdHFE18iSMok
         EayphSzTnngPtiM3G5N4xGUC1QRC8+GPyZ0NBv9k+XJfC9A8UcI6H3nUl3oMD3N9I8+1
         1JB7FsgcdMWX96gScOsNYKu5UZWKrz6xOLKLjZClUvhWvX/abG/dsScfguV80oCSkMH7
         cMVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfKw8PbJS69m4fBhgF9alRbyy15NupWegqz1ETz57506TvF0IIw5fu3tBMZs266jA8E3RsvuUCzA==@kvack.org
X-Gm-Message-State: AOJu0YyuOCA69Cd3x2nmz02/wqOH5sJKODr6RxnH7SfeRfp4XTjP0DT0
	dLQzTEESPR4eduKVAx6q9FCNuqOdlMm+rsNpecJcKyv3COgtIZ6LQROaIHrhdSoYzGrGDkyzCaf
	sgNY7yLZlAUrmjJJuFLeFD7ML0VeBzCK8izSNsNUH7t4l4LScYlq3
X-Gm-Gg: ASbGncvsl1OQXrq1Qz+f8/iB7FPwEoSPfEcBrr3S+E96ma7mTGDDw3JcQRmnA1wMU3Q
	SJDycK7FCpEA0aSqe1E1VzQ3s/84otvp/5WrGRswy8reZziU1eCz181PuPCXzAgLytG+4FRmID3
	1G4eaV21t/ZUNKPx9p3AF5ZWxhJWHeKtk0882kRY/08GKQdDTK53H1RuBOKwiEK4IHfTTtjTzLq
	yjlOOpHLMgWeMurabXcJT+VGX4qltBX0snXEp5nlEGcCbF4NRVjDVLv6OFtVFRuN18Ejq8KF+1Z
	clZmXxTuRPNW40LawCM3Haj81W/HETbGUnRLhHyBaqTqQQghhDCI3hHMUiOoA+JssqTzWgEdlDo
	EP3S/NQpXZG7rf+UdgEcyard9U0iJOvtXViiBPZvIrt35HJ2ifkROl80pjxb+3sE9
X-Received: by 2002:a5d:5d05:0:b0:3ce:f0a5:d581 with SMTP id ffacd0b85a97d-3e636d8ff6dmr7012158f8f.7.1757352639311;
        Mon, 08 Sep 2025 10:30:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGj6Fx/oJ/i3mGb5tdhsyoUu3a7TRpHUY03SW3dQRjVAjsi0xq639ZH0YB5uZksW3RpOLFefg==
X-Received: by 2002:a5d:5d05:0:b0:3ce:f0a5:d581 with SMTP id ffacd0b85a97d-3e636d8ff6dmr7012120f8f.7.1757352638837;
        Mon, 08 Sep 2025 10:30:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd296ed51sm197762845e9.3.2025.09.08.10.30.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 10:30:38 -0700 (PDT)
Message-ID: <92def589-a76f-4360-8861-6bc9f94c1987@redhat.com>
Date: Mon, 8 Sep 2025 19:30:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/16] mm: add vma_desc_size(), vma_desc_pages() helpers
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Matthew Wilcox <willy@infradead.org>, Guo Ren <guoren@kernel.org>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
 Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
 kexec@lists.infradead.org, kasan-dev@googlegroups.com
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <d8767cda1afd04133e841a819bcedf1e8dda4436.1757329751.git.lorenzo.stoakes@oracle.com>
 <20250908125101.GX616306@nvidia.com>
 <e71b7763-4a62-4709-9969-8579bdcff595@lucifer.local>
 <20250908133224.GE616306@nvidia.com>
 <090675bd-cb18-4148-967b-52cca452e07b@lucifer.local>
 <20250908142011.GK616306@nvidia.com>
 <764d413a-43a3-4be2-99c4-616cd8cd3998@lucifer.local>
 <af3695c3-836a-4418-b18d-96d8ae122f25@redhat.com>
 <d47b68a2-9376-425c-86ce-0a3746819f38@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d47b68a2-9376-425c-86ce-0a3746819f38@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qlfgw7j1C1R747acSduc7jo3tEL87Bv0ywIXOoAdSnQ_1757352639
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 950DAA0010
X-Stat-Signature: pdk31cdt1dh43npzhgddna8a1ue64ju4
X-Rspam-User: 
X-HE-Tag: 1757352644-701364
X-HE-Meta: U2FsdGVkX1+kEs6xhrIASYJ13hU9ttpO+d0tUgiqXUeoD/5iirBm94RQTz7Y7aav889Gdope6Lkzc2Q+g7dWXshxoGwEXYGWEPx7dFtvNOwt9haCMWqlZShTGDOlz8MP4D6L6+24Ahyd7+04v5zlD2aCMjeERWebNDhrPx/eQ/no3VsgYWxboKQu6OYr1MZ/C2uNjEPE3w1tykTaQAMlgG+Ul/j3l2LjHrD5WAOzfKlriY4SeEnE3UKpjQfYxgs2TgEfoqhKOtkTNf/eh8xkOx/BxSyFXCl+J5WJEE2lyOlIZM+3NAyFdeZuRrYpan6yYzlvZmxfTEeK3O7hcMon1V/Q5E2UiMyUbv3SdXqBH+kWb92uPlRqZRPaWEC9CVecljMKzb1GD1yiNqvVdhkSfJvg7RbB6PEXYtRxRQ44GUgP/U7LvM+CEuI8v+MNJKCwDU8iJ6qH3uYh3V0U581obDnB17m2mChfO/jXYJ/cvDSGqX82V+ci9T9hl2A8aLJP3Yul/be+HS0O8b42gVDb8KERpF0gaWKJmGmW1fdUfRUZCasA9L3bgUMjJLLYrlDccjIhGAmprZ74i+lb3niL4wBFE4OiZKTbgocq5v0lCKsgey7dCfsCci9sM/Gn2jNaOO7g7lG3pju0B0M+17HS6KeeZ1Gm2uJvHzm47js6yYFIDSKCWqjvx22rmgWS+P8GqX+/u9M9xbmnnK+TGCtkt07FSYlkVKWnA5cUX0b12WurZGs2j1qOQWXTq8T+tu0oy3qRjrkP2fAMWn1+Ew/Lv/UawZamdb6BlFLhk2yzuabB+IY1wxKyIpAghyTsQdY/BfuVksaZtOR0MaW4Jpfk02uhjzgrzVjxqxNtrmFSe/JtTCdOvrN1bogU8ttKUmXUMmBSi7I2UNsWXr914zniBl0F5liX/SgfUvjeKVfaOGgcELQbq6TYolr8LWk1zbIo2XcljB8GowjaIqXM58R
 twVIpFrt
 keTLUqSq1vIHT9ZzGg3LdzOEaJ3YsOGz3wRd3NEqsQqy7GZQUmzawORO8ApvDekjOSNiGj0BbmW0HTEzcbqYJe1llk3lZHb2E2TAwhqect0KnidKjRuMt1y9dSvxf0heaAANZOOm8m5/aYCwseV8EGVZAPxdOjDRRUmq9b43VOqdFc4P/1Q3hYNElGNeunq/Huvk+5BdbBQqz6ql3WOfKYLR67DZTBwtO4cIU3KHmH2guIATagLszBbSDNknV3kY2QCVRqoy2IprUSLNsjAYcZ0RONbacFir7cSzMDZ3yOhGCvbzfahww93iBf6UoKFRVuPZEYmv8K98Xjj+S3/oGRmcJEbQ1+vyMQd1w3rkZ++PBsmRsDyK2rWZgCSbKd+RQhhLKmsVxWHxggj1a5qkED0+Jw6XjfylbTifKCutJ0hmC7FzD9xWHQ15aGA49pNIrwgKp3G+YTQNZMpD2Zlm2aDO0/KWaendnPQoVlNAwiEtlDzxc1e3z8ibDegfG+gnVoECpcC/IQ6Vpqlo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 17:35, Lorenzo Stoakes wrote:
> On Mon, Sep 08, 2025 at 05:07:57PM +0200, David Hildenbrand wrote:
>> On 08.09.25 16:47, Lorenzo Stoakes wrote:
>>> On Mon, Sep 08, 2025 at 11:20:11AM -0300, Jason Gunthorpe wrote:
>>>> On Mon, Sep 08, 2025 at 03:09:43PM +0100, Lorenzo Stoakes wrote:
>>>>>> Perhaps
>>>>>>
>>>>>> !vma_desc_cowable()
>>>>>>
>>>>>> Is what many drivers are really trying to assert.
>>>>>
>>>>> Well no, because:
>>>>>
>>>>> static inline bool is_cow_mapping(vm_flags_t flags)
>>>>> {
>>>>> 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
>>>>> }
>>>>>
>>>>> Read-only means !CoW.
>>>>
>>>> What drivers want when they check SHARED is to prevent COW. It is COW
>>>> that causes problems for whatever the driver is doing, so calling the
>>>> helper cowable and making the test actually right for is a good thing.
>>>>
>>>> COW of this VMA, and no possibilty to remap/mprotect/fork/etc it into
>>>> something that is COW in future.
>>>
>>> But you can't do that if !VM_MAYWRITE.
>>>
>>> I mean probably the driver's just wrong and should use is_cow_mapping() tbh.
>>>
>>>>
>>>> Drivers have commonly various things with VM_SHARED to establish !COW,
>>>> but if that isn't actually right then lets fix it to be clear and
>>>> correct.
>>>
>>> I think we need to be cautious of scope here :) I don't want to accidentally
>>> break things this way.
>>>
>>> OK I think a sensible way forward - How about I add desc_is_cowable() or
>>> vma_desc_cowable() and only set this if I'm confident it's correct?
>>
>> I'll note that the naming is bad.
>>
>> Why?
>>
>> Because the vma_desc is not cowable. The underlying mapping maybe is.
> 
> Right, but the vma_desc desribes a VMA being set up.
> 
> I mean is_cow_mapping(desc->vm_flags) isn't too egregious anyway, so maybe
> just use that for that case?

Yes, I don't think we would need another wrapper.

-- 
Cheers

David / dhildenb


