Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB6F6CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:26:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 227946B0006; Tue,  9 Sep 2025 05:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FEFC6B0008; Tue,  9 Sep 2025 05:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0522B8E000D; Tue,  9 Sep 2025 05:26:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4D118E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:26:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC2A111A03D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:26:31 +0000 (UTC)
X-FDA: 83869181382.16.9024DA7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5CA8FA0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:26:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FIau1DiM;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OurCkvo8cRfbGgLYwYff0XkxeLDF9OohYudpKg0Q2Mc=;
	b=hdSNpAs6CEcKou/fa2flP27chNx3F58n82aZBpaaZcs4z2NlN+vwH/67K5sCgbphkgYGlU
	knfnwJ2VZAYv2DZ/WTleo36OeV+U7skBlVq6VIQJ6qIyhEFu03uA5KyMAHXNy8qnwp5VsB
	xt80ScmSWphMb9Z6H/aKzVWByXWL6s0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409989; a=rsa-sha256;
	cv=none;
	b=WCic2tEy1KAR8ksZ4DScdx4t4sddqFG3B4wYTV0+Bh2XYGaZQ+mZdn8FF8hmBv/wAy9uE/
	FjWJ0XmeZ+pcnfUiQL4qr4+bruQ9CPS5lM4h1LN6uDL5AyTV1wtNjiPwNuhH0dbSdCQuVw
	XKAUO7heN3mOkO7fx4Nsr+qGy3orZec=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FIau1DiM;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757409988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OurCkvo8cRfbGgLYwYff0XkxeLDF9OohYudpKg0Q2Mc=;
	b=FIau1DiMRicThLT/pfqhL9J3pt0vKCPADedalRdVcVHY+xQLpcjraYrEv1qoJ6Wjy6lax2
	Ecu7jyrlW6ilgoiPCBkbFbbzgQh2DIuHQluLF9uRgjTKllhnCTBwUr0HghcHBvp64LkC6F
	/fHLYG9mJ42lv2SSnSOZkI7VVovbNrg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-154-rGk7PIpsNqKrd2ySOQO7nQ-1; Tue, 09 Sep 2025 05:26:27 -0400
X-MC-Unique: rGk7PIpsNqKrd2ySOQO7nQ-1
X-Mimecast-MFC-AGG-ID: rGk7PIpsNqKrd2ySOQO7nQ_1757409986
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e753e78902so113801f8f.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 02:26:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409986; x=1758014786;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OurCkvo8cRfbGgLYwYff0XkxeLDF9OohYudpKg0Q2Mc=;
        b=TvgU0aa/fQ06xmhnW3qCg4obgSlQ9dm1ushhwZltiDtQ4bReuejlrMVJT2yOyjZuIB
         uN8I+t6XiBfSse9ZnfdkgidHDPOJKUX90ZF9L5mfCtw0ue/H/bnYcK9dFgXAChQWNRYz
         3qAAKR4JZGg5t4+ZYNRFxneHD987ioko+loysqLISIbqsewBJMk4w0bxUn9+ihcgttii
         0xygHm9GXigQ3gpiZg2w1fJsuxkA1NeLthkMyDNfXYWic893Cyo4zop4QIf3nPL+jS4C
         IJ6MMV/vEeh9zNr3NPvAHEG2qsIjRWidJ0ybqP8no0tPbC9DrFjivEKDzxzxpS+i36o6
         OYEg==
X-Forwarded-Encrypted: i=1; AJvYcCVXwCBeP1UFov/9AP9CZjUL6HhfNJ3KCoErItVo7jcoc8UzKVSk059zX7VOvtBoFPoUhk+FbYH2ng==@kvack.org
X-Gm-Message-State: AOJu0YxPzsHjVs/XfNckkZC92kcuLLL3SbNY16a8X63w2PeRP0cstBpU
	wbq23pI3jAPkuqIPD0GuC5YF7ouKGmMaz0NhBxqGF9zlmJ/hhQSjBBcVGzrdre4CLKX5J0/ZQqI
	txOv/owjx19fcp6sY9DNujqEy37E29dh3/S4NSlwJ2j7JWJTMfXf/
X-Gm-Gg: ASbGncstvBsEQ33f+8VSjN699fWXtYNphFNyY2d+3yTQiD8ut7EXyfsxvyGcUp2JL/L
	O0mzZZdrSyohTW7zKZrimuhkj0lkr6GSQFpDX4vVABe3vIvAxcPLaOrhc0guKv4HzxBgv5owjUR
	FUqasTNrzjR6HX3KugLmsGPvLa3c5b3PTQYhfAdNdCYAz7ZyKAyaT+3zSNj/k2FDFaI1PYe0gKK
	Gi5V1b0hiAbaYBt4YiLUscpc5RbJLDtFUGxOmamRMVTb74fEiOReZ0F6Klk+dYbyQTiX5xLcSOI
	gnbqGLZtUHTj0sbxioGxAVULjn8rOb+n2Lxo6Q44FLiQdYNquab0x8nus3DddBwBpEUeACpy7TU
	xSks3UvMvb8tik4gnbWcK7iNTiMzR1Se8qDvp69Fl/fomhv1QGDzD8css86vLGvnuao8=
X-Received: by 2002:a05:6000:2f81:b0:3c8:d236:26bd with SMTP id ffacd0b85a97d-3e63736f01fmr10702039f8f.11.1757409985920;
        Tue, 09 Sep 2025 02:26:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFxR9lLCllY89SGP0DnTjf2QCQWH2LpNqo/3CEdj7ZBEWXvSf1n4XCUk73I9R4VihF1/vNGg==
X-Received: by 2002:a05:6000:2f81:b0:3c8:d236:26bd with SMTP id ffacd0b85a97d-3e63736f01fmr10701953f8f.11.1757409985314;
        Tue, 09 Sep 2025 02:26:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e752238832sm1808267f8f.31.2025.09.09.02.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 02:26:24 -0700 (PDT)
Message-ID: <e882bb41-f112-4ec3-a611-0b7fcf51d105@redhat.com>
Date: Tue, 9 Sep 2025 11:26:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/16] mm: introduce the f_op->mmap_complete, mmap_abort
 hooks
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
 kexec@lists.infradead.org, kasan-dev@googlegroups.com,
 Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <ea1a5ab9fff7330b69f0b97c123ec95308818c98.1757329751.git.lorenzo.stoakes@oracle.com>
 <ad69e837-b5c7-4e2d-a268-c63c9b4095cf@redhat.com>
 <c04357f9-795e-4a5d-b762-f140e3d413d8@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c04357f9-795e-4a5d-b762-f140e3d413d8@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aGYaWaPOQHE9LyiD_yQiQ5k9smm7-90JcZzPHE1DtNs_1757409986
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xtwk3ctygcxb18sup96ejr1sy9pdzuun
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CA8FA0002
X-Rspamd-Server: rspam10
X-HE-Tag: 1757409989-715161
X-HE-Meta: U2FsdGVkX1+m2jT/bEeU7R41vFZF6wodSUqXRXaujPUEXbqK9Xh99EgQy7ovBtggPOlKnGfu/TRelG3UNT9RiuU4/m1/RCsFGY+oDzPgkqK3khF2Mhg38U8qx5Sn0wneJbWHqmlIwhajZbC1xeD8Bx/azdBHRo0oeQNmmrDf9lW08ZZfzlHcKna9dbUdrfeuOXagqZciePWftxxJ1VC/FSri5QNEiSIBsRdRX9HBKIZRwrcsfEcD1u6iEzHyir2aZjwdhF0ls36CS05QjwuSymyYHU7BbGhGiU4VrdjKu8FT/DLbb5a4tDnb65yEgdQqFR747gzayyavWqWn3XQlR9242bXie8e/EsoY2OKmHYPXDe2u7guEtsq3gInTfaKMykk9QfNqIEm2EakxOPDU9Qv3UaP/gQfToZm8sE1Jg1Ltx7wPMVLeSeaJRNmbzBrVz7wPKBJq0emvWItsW0X1BATOkWf1GONGqQZAIFjN4Ie7nM12FfClC0yp/eRA4pfe64Dx++XHtAXo3ZmRDEUcHhcNov16nKVerL57vkcnNepuA99NbBTmXn+piFJRQjshaOKYwt6spoasaFRTWg7o4P88jj6zU+em76b73Hka1oO6YtDXQ7jGF37+T4idmUX+8+Laeyml0KSHeUwy6mZdidzPxBYXM3TosSzHVkSI31KZJAiVBc0fZzC4c1an2nuoLB+i1PRO0+UcZjUM5umqw1K9ziYgCbdvX+ALVOAmKcQ7OX8wpYTKM+ilwVMxeysB/IPghJN0E07WbH9yYJMIIqm0Zq4xSPD8asCQXCfNwvoAJaOAFK5RoaVes+EkRFyjH1s/SqCyr1RAMLnn0vBl8H60KwclTu9mF8oMdKq87O6euEi2QrqzkAmWhpUVY1EFiW8HeMe8fhRRyqbURGgNC7kLnC8Yszh9QNNHNZm/xzok8SdbnWo/Xst3AVvwx4rRTKxzIOB6zhYSIiT4Ewf
 K2sD53zP
 XjRdNe2WYlDLECWV3+2g+rdW+guYiSbaVlwZmk/RGEAvYlUPdE7c3qV9Oj0cYQsN1H948QXLAMPcwl0Mzfr90joQFmbF/QEFtgpHgXtdpvIEFqW76ap2KR6uGMq4mO3bsMGwGUQLW3Md/6vQZTq8E763TgNsnUZw6H+NNAs8j8zQHhgZlAruMtusMMZxjS4mAGvYWTo82urjGGHOqEgdwBm4lB5tqQJKaNReX7kANGNp+w8ZD+NpGQR3xwwJiyN7S6VfZcFIIHCDidXPz+jBENHynop45KCP1DgC0vmy75nF5DJjm+O+6XJJbxlT3v1MDyiKEuFR0fOPmYsoV3qDz4okZODw3i7r9ezdcDtuL1rcwjDct/E6XO1FC9lauLXH+aJOMtrrXxFp65qUUT3SYBjayon45wTmPxfC3ZYLgREkOND7MUYAXuEWoTc6VDVnPwesr9J8zbkBHPoa+MROXi9lN71XN5KJGgVvh36XIT7BNxJWStK4/euipBJPrcotNMIxuS/6rC6bgTrlGqSTHWY6wMH7sgCSi9wD1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 11:13, Lorenzo Stoakes wrote:
> On Mon, Sep 08, 2025 at 05:27:37PM +0200, David Hildenbrand wrote:
>> On 08.09.25 13:10, Lorenzo Stoakes wrote:
>>> We have introduced the f_op->mmap_prepare hook to allow for setting up a
>>> VMA far earlier in the process of mapping memory, reducing problematic
>>> error handling paths, but this does not provide what all
>>> drivers/filesystems need.
>>>
>>> In order to supply this, and to be able to move forward with removing
>>> f_op->mmap altogether, introduce f_op->mmap_complete.
>>>
>>> This hook is called once the VMA is fully mapped and everything is done,
>>> however with the mmap write lock and VMA write locks held.
>>>
>>> The hook is then provided with a fully initialised VMA which it can do what
>>> it needs with, though the mmap and VMA write locks must remain held
>>> throughout.
>>>
>>> It is not intended that the VMA be modified at this point, attempts to do
>>> so will end in tears.
>>>
>>> This allows for operations such as pre-population typically via a remap, or
>>> really anything that requires access to the VMA once initialised.
>>>
>>> In addition, a caller may need to take a lock in mmap_prepare, when it is
>>> possible to modify the VMA, and release it on mmap_complete. In order to
>>> handle errors which may arise between the two operations, f_op->mmap_abort
>>> is provided.
>>>
>>> This hook should be used to drop any lock and clean up anything before the
>>> VMA mapping operation is aborted. After this point the VMA will not be
>>> added to any mapping and will not exist.
>>>
>>> We also add a new mmap_context field to the vm_area_desc type which can be
>>> used to pass information pertinent to any locks which are held or any state
>>> which is required for mmap_complete, abort to operate correctly.
>>>
>>> We also update the compatibility layer for nested filesystems which
>>> currently still only specify an f_op->mmap() handler so that it correctly
>>> invokes f_op->mmap_complete as necessary (note that no error can occur
>>> between mmap_prepare and mmap_complete so mmap_abort will never be called
>>> in this case).
>>>
>>> Also update the VMA tests to account for the changes.
>>>
>>> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> ---
>>>    include/linux/fs.h               |  4 ++
>>>    include/linux/mm_types.h         |  5 ++
>>>    mm/util.c                        | 18 +++++--
>>>    mm/vma.c                         | 82 ++++++++++++++++++++++++++++++--
>>>    tools/testing/vma/vma_internal.h | 31 ++++++++++--
>>>    5 files changed, 129 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>>> index 594bd4d0521e..bb432924993a 100644
>>> --- a/include/linux/fs.h
>>> +++ b/include/linux/fs.h
>>> @@ -2195,6 +2195,10 @@ struct file_operations {
>>>    	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
>>>    				unsigned int poll_flags);
>>>    	int (*mmap_prepare)(struct vm_area_desc *);
>>> +	int (*mmap_complete)(struct file *, struct vm_area_struct *,
>>> +			     const void *context);
>>> +	void (*mmap_abort)(const struct file *, const void *vm_private_data,
>>> +			   const void *context);
>>
>> Do we have a description somewhere what these things do, when they are
>> called, and what a driver may be allowed to do with a VMA?
> 
> Yeah there's a doc patch that follows this.

Yeah, spotted that afterwards.

> 
>>
>> In particular, the mmap_complete() looks like another candidate for letting
>> a driver just go crazy on the vma? :)
> 
> Well there's only so much we can do. In an ideal world we'd treat VMAs as
> entirely internal data structures and pass some sort of opaque thing around, but
> we have to keep things real here :)

Right, we'd pass something around that cannot be easily abused (like 
modifying random vma flags in mmap_complete).

So I was wondering if most operations that driver would perform during 
the mmap_complete() could be be abstracted, and only those then be 
called with whatever opaque thing we return here.

But I have no feeling about what crazy things a driver might do. Just 
calling remap_pfn_range() would be easy, for example, and we could 
abstract that.

-- 
Cheers

David / dhildenb


