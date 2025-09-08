Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A69BCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799498E0014; Mon,  8 Sep 2025 11:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749428E0001; Mon,  8 Sep 2025 11:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9F18E0014; Mon,  8 Sep 2025 11:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 493428E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:50:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDB7DB6E9F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:50:27 +0000 (UTC)
X-FDA: 83866520094.17.50EDCBD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 87BDA1C000F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:50:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JJ9Ikt4h;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757346625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRW3ZVdYmN/Kdh0wLmiEq7GLlrJxKlfpeCG0COnVkik=;
	b=ZzJxK31KCnI/0YM3Y8JOjf3guVCGAzJltJvzVpTHeffwPAiRpZAxX1fxvQ+lvW+ETNaaO5
	udlCyrjh125IfIdWaxzKC3dGlu+7L+93UzmHz1d3KcizQmPIznYPthy+0ucvHBUxPhZt9r
	Xo/+49sAymRugbg0RnBmPuLoR8i3IEc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757346625; a=rsa-sha256;
	cv=none;
	b=BSMA1NpgxHEVJ8BzTrwV1Z/Qogjodke54h4EXXmJPGFNZAoiR58HIlFy0AUFe1QcXNHcDP
	ZOxkvXCwHIw2RPVgRk+9zz1URR64ANYKuRYablVfaR0UypklgHGsIjELnyinLaTL01OLNX
	RXO9xMITvMeSpmroOLhZ5BiLZ7o7EXw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JJ9Ikt4h;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757346624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yRW3ZVdYmN/Kdh0wLmiEq7GLlrJxKlfpeCG0COnVkik=;
	b=JJ9Ikt4hcQjosRnMCi/em3loNXCCoWr7kPV8y1aTnvueUHXG6SQZWZISPAFEjRaI8qaSbc
	vm4vTEuZVpBn1ZjN6Dd2f8bB7YHXRON5I+CJZ7ysqKxAzxErhZVpv3VhbsMx4KU2/jCNVs
	H1avd1/9c4PgaZp05euZoC4uHulLico=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-QWHS_6eTMtWA9rb2w_BCiA-1; Mon, 08 Sep 2025 11:50:23 -0400
X-MC-Unique: QWHS_6eTMtWA9rb2w_BCiA-1
X-Mimecast-MFC-AGG-ID: QWHS_6eTMtWA9rb2w_BCiA_1757346622
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b98de0e34so35773145e9.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:50:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757346622; x=1757951422;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yRW3ZVdYmN/Kdh0wLmiEq7GLlrJxKlfpeCG0COnVkik=;
        b=ac5x9iwQYrTg2naMK47MAkS88D70pdg/I8tyn3ukw5rL7qHzdFe1xDxpvGl0Xfu/9Q
         1FkK6pq8BBzG8HHQGQKkUnGhN4qUJPSdyWNYPOn1X2uoGJ3Ho6jvBGL6alpAZZBAJkYQ
         Fkbee+wzQB0ABRyaAV3o6m/utIIQyfVlpkmMZfprjDtqYIuOkXRHTirD/TZGdYMq2ifi
         xSL03IGjJZPBGhS4r21pghqIGQCO2zwyv6cJjVx8snUyR+0gj/gdwOu8HiggeTWumbnh
         Nn0ZC/y+WAOceWJYJMILKbwnU7p3E1DaUlcjEGLGqC9kqNqZSZeFEv+M/XkaHTmmF45A
         lVGg==
X-Forwarded-Encrypted: i=1; AJvYcCX3JWv4QfpkILpjWW4fIsoHdXHLZ9sMRSW/ccsmC43/x+ItVdtTWyGiDi1mErLt12nPAL5vfYHHdg==@kvack.org
X-Gm-Message-State: AOJu0YzJh8ao+b64iCJvbM3FO0nLwfJj3RMVWSEybCI4t166RHEUZ1o1
	HPPhLxoBkHGFmM/MtNNRPG5vldApesATD9oNZZchWea+hXV2HDiCPQW055DUYVdgvrqIF6LO5t+
	8Gf1Njur/h3d8WLVPUeibYdHSfqWCcL1dzlYF5GxYJ+GBcDYJAkFI
X-Gm-Gg: ASbGncvcNWeNFLTww3/O12j7Dbt6WAzDBO9HgmU0WSzAUsSLUy1bvxYzQFwUK48+KTb
	g/2GPjG4Rfamp5C3k+yi2XgmjE1llromMEEN5aUQm7HGisDqXWVL/M2U98Fp55bWgoDU+MPG4Vk
	rtWC3O9PPz5+UaBIFBUR9C8WaSiDVmSygp8y7LKGMbTQhhjFIbjnGBZnblHUWVYxMYDi4I+Adst
	EOw65ZuntOJxBr2Vmo99Xv/F6ZUs/SIBWXs1Uc+0gOxeSPTPVfaAT311tRYRCfUtNGLhfsk64lY
	1lFUwXSWJAQMiPNDt0dZeYPWuHZDZnN3qWoZUVUjyJ3VO3hWKOUNYghldtVu4qiU1kjnpY/Ry1s
	S8ASDxtjqgJMBYY8jGP0ZZUqI9CXGwgzTOdaYakohch36GaPYujp5xfYisy+yRq8i
X-Received: by 2002:a05:600c:4e14:b0:45b:86ee:415f with SMTP id 5b1f17b1804b1-45ddde8a741mr84356305e9.6.1757346622264;
        Mon, 08 Sep 2025 08:50:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIS2Yy99pUw9GXFN0rA/K14GohJu1BEy0lmIZFIqwZ3w6bOX7inAYbi8cC2UvYQeQPJx4Tjw==
X-Received: by 2002:a05:600c:4e14:b0:45b:86ee:415f with SMTP id 5b1f17b1804b1-45ddde8a741mr84355495e9.6.1757346621708;
        Mon, 08 Sep 2025 08:50:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd0595af9sm100737155e9.2.2025.09.08.08.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 08:50:20 -0700 (PDT)
Message-ID: <3229ac90-943f-4574-a9b8-bd4f5fa6cf03@redhat.com>
Date: Mon, 8 Sep 2025 17:50:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/16] mm: add vma_desc_size(), vma_desc_pages() helpers
From: David Hildenbrand <david@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
 <20250908151637.GM616306@nvidia.com>
 <8edb13fc-e58d-4480-8c94-c321da0f4d8e@redhat.com>
 <20250908153342.GA789684@nvidia.com>
 <365c1ec2-cda6-4d94-895c-b2a795101857@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <365c1ec2-cda6-4d94-895c-b2a795101857@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kBZ2KOz4ySWTK0qPQjUvetHwcyUCEel8LY2SNpP_eo8_1757346622
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 87BDA1C000F
X-Stat-Signature: zcybf8s4y76zj3rrhhfauj7xwb5gqe7u
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757346625-662978
X-HE-Meta: U2FsdGVkX1+LGHs2haaZe0CwaY1CGXWKEgRQHN7HZT1mGqjXhpQR7pkQhZDtPkaBX45LAScqc6y/0g3l4qSVh1u8g48CLVRmuyPvvM2ByWWJ/m1emO09Z5RlyL2ZyPJScXP+iz/Xzlolm6NtP3r2Zq3NqhlEcEqoc02xBAE+b1cytX2oa5EaSJlT/++5pKw6eFYFD7nftuH1CSjfp2hb5KaekdoeveWo3cFwzqtUbeSsuB1TWyvA7nd2dF5l7bNu2qh9/PmxFzZgLMsBNUgsyKj/320IrI+HgUiRFCUyMMBfnWQ/T87oDoRWmIuF8Z7nZg69wk4YXqRY/gpbs2/QXe1S5M5tfa6GQGc6u4enyERWGP8/OSlt46F32UK1KrNrY4UDN5CCnQeftDvxmG6LPUxhuZO9GTRbxlbQEFuK1sHd6RBZ8L+TkuINrHHIQ333lKJO6qiaG1wHcoqCAHzXZAWSsrrakFvB7rmgf2iWM63FYsVq8BrcZT/MMuGse4PsE1Od6yYp7T7SGuRpaUByMMhDlXV1QF2EXFF2Wqj5TqgTYcA1/XhrVbpfLZTrZwejdA02inWhpbDIRXQUnxh6zPgTkin4KhWJ2Yhvx/2/r16wLgihOHWLw52ZZgWCrW6XdjAH4hRjejiXeVXpFkxTcW9GMgKQACRylLGRW/D60ToCKzqY1Jjh87jGizuL7bnK11TAIhrq4w7W7TBWAj/izWWOISnUjq8YiFh2pll1m62YoKvHOcGIXhfEQ85g64cM+8Gr+gLqI49v7wvAoPbTx3Mq7g53Ajp1ZI//DdwUPd1IlOIYHp2EnWomEA7YuynHz7jNZY52GPa5BJ18qK3hAhLdv8T4KKF28BKF9Jd783ap/k39oRQYoKB6mi8KuNz277cCRkxK1J+yHh/6xnAknf3xMqrXxLxnJQu9Dsb6vjtasN+ZVaj9en6RNceK+goV3exsm3ZbEPTOqTo5t6D
 uY1b+Vv6
 n/Ui3D/7GMoWAcRlT+eCCoOWD7GOk/cYhuP/30COa4i7d4OXzdXfqIiI14rtsOTbUow0tV1ZsR/r0DToCL58ZiIC6ymDYML0RMj/IANvwOc+K095zX2BiVgq0A+8/4EIWTJd4disj6lEPvlg8cMJdnEwU0E2GMh4vSH5cIFJtrXSnrHrmEyGjxYLC/JWbneUKwaAFSEOL5BTNNxOpfWas/LyB6fjXkgpuvPzRvwj4njQr13ZzFu9s8bS53svHqYa95Oq02LpJorLgVIbiZjVh1JLBtjjmWHoF+ZzKh6VKw9Y2J0HtCGHWeQmF0/gOd52aOkkY8TUcjeFUrpv2tHJ2P8eQwxDnlF2YD0mUZPhkTqw0gzH57mJz3Qh96Z/72xq+CEetsBxg7qb47TPT0i8z/muzYE8EXHO5TFilDvI6go06IeMjk69bZubAbTtAQm6Fnr2H1EVUkfk7xv16P2P80oBYXyLSfDc3hXWTgdj2jyJIUJXCh514cnssf5Z+/iE93mH6fyRbM0ckansBBrha5vnfGxegIpmi8EzEQj/fmPtt/FrvHc+oXmXfpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 17:46, David Hildenbrand wrote:
> On 08.09.25 17:33, Jason Gunthorpe wrote:
>> On Mon, Sep 08, 2025 at 05:24:23PM +0200, David Hildenbrand wrote:
>>>>
>>>>> I think we need to be cautious of scope here :) I don't want to
>>>>> accidentally break things this way.
>>>>
>>>> IMHO it is worth doing when you get into more driver places it is far
>>>> more obvious why the VM_SHARED is being checked.
>>>>
>>>>> OK I think a sensible way forward - How about I add desc_is_cowable() or
>>>>> vma_desc_cowable() and only set this if I'm confident it's correct?
>>>>
>>>> I'm thinking to call it vma_desc_never_cowable() as that is much much
>>>> clear what the purpose is.
>>>
>>> Secretmem wants no private mappings. So we should check exactly that, not
>>> whether we might have a cow mapping.
>>
>> secretmem is checking shared for a different reason than many other places..
> 
> I think many cases just don't want any private mappings.
> 
> After all, you need a R/O file (VM_MAYWRITE cleared) mapped MAP_PRIVATE
> to make is_cow_mapping() == false.

Sorry, was confused there. R/O file does not matter with MAP_PRIVATE. I 
think we default to VM_MAYWRITE with MAP_PRIVATE unless someone 
explicitly clears it.

So in practice there is indeed not a big difference between a private 
and cow mapping.

-- 
Cheers

David / dhildenb


