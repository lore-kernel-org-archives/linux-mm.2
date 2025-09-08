Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123C5CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70DA36B0008; Mon,  8 Sep 2025 11:08:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4D46B000E; Mon,  8 Sep 2025 11:08:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AD0D6B0011; Mon,  8 Sep 2025 11:08:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AFFE6B0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:08:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 05EBD1401CF
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:08:07 +0000 (UTC)
X-FDA: 83866413414.02.EE715A0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6624814000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:08:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fkRwNQsY;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757344084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pKUW/icABhJPZyV0g3yxdIs8s3bqfZdt2XQu7KwBtE=;
	b=M9Z9t2Nnt7imnS+EYv+xpt8MiMnPkyaE9uzO2NGVQITQCfRg9hqDtqTsqTyknR/c4BJXdf
	V0M1B7J4eBJdxUoyq1hkmPH2Jv8yXOQYl7QUiCAMeaegiQ48dBN0PtMg1w88A44mrMqVR5
	EE6GRDPZFfZIb5JMgm8bxd4sO6k8CGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757344084; a=rsa-sha256;
	cv=none;
	b=hn3Di2gHecchmHFncfZOb3sJprLx+vqwfw17Gp8rj6quEROJ1vqbc3o+wuoI6K6uTcpHDn
	H8qHOS6T22r1JN/ijOM5Hl4fdqRgS1wUGI6xEvhCRlg/daOyifcThbhB3wE4z5jQxtDRKe
	hK7yjCbq7U2bv/a9/G+k8dRjN7BtKpM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fkRwNQsY;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757344083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5pKUW/icABhJPZyV0g3yxdIs8s3bqfZdt2XQu7KwBtE=;
	b=fkRwNQsYhNT0GIFXYrP/ib3WalJpzp8/qQ0kO4E9gTgD5YD5Kweozy5U3000pLeEH964KA
	K/7r3mtq3PlIsN3nNJyOdwRg3JLXWejsg+PGYI6wSVPGeSbA2Q25JL61voRkHyEj88XRoP
	Q4NEcLjnVb37AJ8G9ehULkzAmWxHzko=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-260-QVy_F8M2O2muTfhSbAp30w-1; Mon, 08 Sep 2025 11:08:02 -0400
X-MC-Unique: QVy_F8M2O2muTfhSbAp30w-1
X-Mimecast-MFC-AGG-ID: QVy_F8M2O2muTfhSbAp30w_1757344081
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45dd56f0000so27339845e9.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757344081; x=1757948881;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5pKUW/icABhJPZyV0g3yxdIs8s3bqfZdt2XQu7KwBtE=;
        b=QPb3QNyqqM0p4ZG0Bev4IAAGzKweteitgRf16YvsVxDzMquMeUrxh3uMEMgXZeiGwG
         ULDWBMWCJVnrX8POONGSxXGOjqK9UHYLbFPAJNdf/QfLc5h13u1mrh03w56WEkVk/ff2
         gymnEjoCAm2m11LH/TyZJ9xsFEmpso2oKRMy0p0OigmSFRFp1loRxGXu72Ncb0pS50ZU
         w2nHNqBOS4bTOrmzKWd0tXnor8T4AjZaCcuenUf1IhY1loyHaKqqrF6OyBSw9Qxtl5qC
         979jlv+1EhTFsGhyFiLCXoRJxNReIjhN+xRrrFFIkHna371lI85SS+cMGBfEvY9NRn0x
         JQAg==
X-Forwarded-Encrypted: i=1; AJvYcCWItHQEy60KBU2KhgQWvXqRJZg9Hr4TeCJQV0+KqRdnI832CM+6ulYsflaT+/9EKppeLO7ZLWrIFA==@kvack.org
X-Gm-Message-State: AOJu0Yzs56tkN4MpFzaT9eHu5oV0jB6pS4gOduJI4XQCJp6P+DZLBowU
	ck5yiBZt4hvJvvN2NYPxIHLLW+sYcmqad5xn3V33Sq/1BwL7vkZ1myIYfvKHHiyei+BUxPnZTvh
	vgXuxAJg+8E//wvHqseeeGOEmblJoSh5Rl5MUon2x7FXtu/1Zmkw5
X-Gm-Gg: ASbGnctLAt1YyKtiwKi/6kHim0HQsmyndVicGxFKcb4ZxEol1d56DyU1Uaa6DJSnsg5
	RoRZuhmV6vjGGJRWzASa+g0zF1u55UxS3DsFLlJNBXTLGlH6udrWx5auihObr0hQjKFkZeFh249
	K6zFf7oo51Oe+liWOu0L6l5JcYL1B/u08whwwdlp7K5QVR48LekIUt6l0b6Fj92i/AAQzNxSSn4
	VodezqZdXRBYl9Hl9ly/+WpbKNjdc+y58FKF7Lj0Ij5eJoU6HQp/+aa3L9w4J5yZPL8Fn7S3KI0
	tC205xtgTiZKguliU5nz7ESiDcuJnVws3y/W2acok4q7oumVgwYGYMVTvsutcUK8TkQC0XsIRQs
	MkDDD51rudIXBnZg6jg5nugSjktVZY+WI8HGBVXI/GICRWtd7gMdLtIDQj4rypWGQ
X-Received: by 2002:a05:600c:5299:b0:45d:dd47:b45f with SMTP id 5b1f17b1804b1-45dddef7fdamr66712415e9.31.1757344081143;
        Mon, 08 Sep 2025 08:08:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+Vkq5qu+3/zUjGE8hzCjU/5dhhaUv80YZQC3pknfc7Ya8cxmZvSqhgPFMqrGgKhR5fxqC4A==
X-Received: by 2002:a05:600c:5299:b0:45d:dd47:b45f with SMTP id 5b1f17b1804b1-45dddef7fdamr66712145e9.31.1757344080658;
        Mon, 08 Sep 2025 08:08:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45de6e787desm19519385e9.8.2025.09.08.08.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 08:08:00 -0700 (PDT)
Message-ID: <af3695c3-836a-4418-b18d-96d8ae122f25@redhat.com>
Date: Mon, 8 Sep 2025 17:07:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/16] mm: add vma_desc_size(), vma_desc_pages() helpers
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
 Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <764d413a-43a3-4be2-99c4-616cd8cd3998@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FiNvXp1X4NX1UC7G_aKvVdGTiwPXUb1bYhx2vzVANws_1757344081
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6624814000C
X-Stat-Signature: tpcqpqgejmugm6gmxdfd6gko4jow679h
X-Rspam-User: 
X-HE-Tag: 1757344084-870278
X-HE-Meta: U2FsdGVkX18tu9eKEy0Q/QhGks5ypraa+TtRVwGdCW+dulBfTwwV8D83wCDP/9a1RUtXmKgidRkzTbXTaSmayUWCKS1mWVeHK2SiXn1vqPn+cvSGlnXH7/wd/4PSs6l6WO8rhAJEjBcnXFSfhhkJkS3reH4MCExMtEEv1KqPj5NwRrfkjmGjfa0FzeGk0xCNw39bVEtjpShivMU0/QeV4SAa91R9eVJQ1H7YO9czFTFgjJjW4LMOPLJnCyXAJUQdTjYqmlUlEd1xh/Pp6a+lu2bqt7FHqFZ3U/i24izEY6rLOqDVgeV3sI2BAGt9uRxLsY/ORkHO2AQVxt+TMg46r50W99ejQ9Bj2Vq3SxoUIph/ViGgsGuTHKIZYuCfU0ATRzrFwHhsaMujxZLeplpeP4HZNJtJUIH2IAsiK5zvrrsYARsb1vQyIlFDFvhZCHJ/pid/jm7y8tuoqsUnAJK1SRfGCvvdm5machaPzcjC8Sa3XSCZNOe6jTpA/I637oJL1jaLrCEd+4G6QdU7qPYBDRiZ9MS1GOmznuFVHLvkpkDeZvnwK1BOktkMDcH7i+fLtFXxw+DottIGM3eRZEz9Kxc97JJ1Z201RbY31awxT5SSiHxfcYB/L8o927YyeeC/BZ45n0HK0RBoRq3HAqCw6QDOTs1Q4eZSKB/qxFgorBMyyyO1DNXNZmdP38fjvCCIZpi+3fmaX4P26Bqpn22b7FGkVghFhal1mn5QsoRITNFuK2VEY7J8TgZ7vi61hWRKtPeGfHPH9h3dQjfQxXQWwWuY+2+ZjB7J+dFKI4Yprd0iQ4FLRE0JgGNwbHET+k/HxS7yN1y4NjQHK8/FIzd+6lZbmcQPKNy4Pqe5SC8Hdlw5wXZX3LI9jjgmlgxyosWCpln1GxERIYstkCU3gfAut7+u0RwDvvcT+tA9QMjbHp1TztceCnKdXDo0RkhEfB4E+1mlP75SP8GN+DeIMEV
 Iy7AfWoc
 xNFabcOZwzaW1Z4yVx9Pt9hTYK7vq0vvsm9octJ4wJPKdVhjA6l/14kQwZsfzMZ/qoMJZht84ymfFtvjfwyj9LLhHeSEgPX2YLm5PfWIo0CMuywPhnmQokVcJPUE93IUf5nRDahT/T880rTvzEqXOGCm6zSVm2dpaMakEr/bHPET++7FD6pmBeoyMRG8yb09Rt2lK7cQUoqqzsZgsuQkQk7pNyQFk9DN0plnCyvJk/jrg/6X2Zij0cvUhTUB9zr0tAK35OBtX5WQuTcNKNeGAiwo7+oSI90lrHJQBaA/oIweBwGZb6sCXBqD1tN7UlFzHUsrSMD25XZVA1QBhmA/QoG8NPYW8roeofqMVDJwOllTV7QWlnIxe8QnNRx6hBzlCQL/3BKOil+1IhcB1YWM2LPRvzz+za+nqWCxQlTfyBEwnNKkS3eKDo/CApxQiaNLy40tQ85JsBLaZHOZpsPmxaO4kaRjqAHbx52wwNCsHBY75bYOkM04e2ySM+ENL2O5hdzolTI4OxzZwY48=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 16:47, Lorenzo Stoakes wrote:
> On Mon, Sep 08, 2025 at 11:20:11AM -0300, Jason Gunthorpe wrote:
>> On Mon, Sep 08, 2025 at 03:09:43PM +0100, Lorenzo Stoakes wrote:
>>>> Perhaps
>>>>
>>>> !vma_desc_cowable()
>>>>
>>>> Is what many drivers are really trying to assert.
>>>
>>> Well no, because:
>>>
>>> static inline bool is_cow_mapping(vm_flags_t flags)
>>> {
>>> 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
>>> }
>>>
>>> Read-only means !CoW.
>>
>> What drivers want when they check SHARED is to prevent COW. It is COW
>> that causes problems for whatever the driver is doing, so calling the
>> helper cowable and making the test actually right for is a good thing.
>>
>> COW of this VMA, and no possibilty to remap/mprotect/fork/etc it into
>> something that is COW in future.
> 
> But you can't do that if !VM_MAYWRITE.
> 
> I mean probably the driver's just wrong and should use is_cow_mapping() tbh.
> 
>>
>> Drivers have commonly various things with VM_SHARED to establish !COW,
>> but if that isn't actually right then lets fix it to be clear and
>> correct.
> 
> I think we need to be cautious of scope here :) I don't want to accidentally
> break things this way.
> 
> OK I think a sensible way forward - How about I add desc_is_cowable() or
> vma_desc_cowable() and only set this if I'm confident it's correct?

I'll note that the naming is bad.

Why?

Because the vma_desc is not cowable. The underlying mapping maybe is.

-- 
Cheers

David / dhildenb


