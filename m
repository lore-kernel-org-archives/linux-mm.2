Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184A9CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7198C8E0007; Mon,  8 Sep 2025 11:46:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1138E0001; Mon,  8 Sep 2025 11:46:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DFED8E0007; Mon,  8 Sep 2025 11:46:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD8C8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:46:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06A1B1186E8
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:46:10 +0000 (UTC)
X-FDA: 83866509300.09.1177735
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7CD00120009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:46:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J4wwz31m;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757346367; a=rsa-sha256;
	cv=none;
	b=8h9K/fesA6g4HJmQRE6gMCvCmEMUMzi4WAgRUb0pDEWHB94qIe/apUDv5Mk4HAeXbiQq86
	KNfn74Z1ARrd2BjWPcuNgG2J9f2vx6XzkaAPCwECQxQogHf7S+xGa8Rt5CYKTE5dCkPnsQ
	1ts1snlfHHaX3+Lien/X3KWUyGs9sQE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J4wwz31m;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757346367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZriZC5ZCFi8VYhXaUXVlHuq1MXLstgNz6E2jeOUAEIM=;
	b=19qhoHh2tnMEK/xaUqs7QegQ6lrkezzYacS1hXqE43tge3Yrvi0ZOecgwWDDjJp8w0dT6M
	6Gj9joSlvMuHGxIyVS2fRFWCYTBlc9PJoxtDppxB/ivdO6NU6fpI/9WwBTesFLRKef9NQH
	SvzIAQmBmuWdGiGlhfNFejQH2eolb7U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757346366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZriZC5ZCFi8VYhXaUXVlHuq1MXLstgNz6E2jeOUAEIM=;
	b=J4wwz31m6gKuPG0IfcGaKCIPe1BClGsWbeyvKKYG/MdDs82aVa4vFdkO6h6DWUaMRNPqbN
	XCqzF/kHVuGZFvQ5M2K6yvYfu8Jl1qr4VXUtYurB7KdmrfS4KmRdth6He3qbMolxflDjI+
	is3SVqe+BLeMUcggFjOY0paAZKpJpYM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-4GwhiTm1NDatS1rqxhDCAA-1; Mon, 08 Sep 2025 11:46:05 -0400
X-MC-Unique: 4GwhiTm1NDatS1rqxhDCAA-1
X-Mimecast-MFC-AGG-ID: 4GwhiTm1NDatS1rqxhDCAA_1757346364
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e50783dda8so1443261f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:46:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757346364; x=1757951164;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZriZC5ZCFi8VYhXaUXVlHuq1MXLstgNz6E2jeOUAEIM=;
        b=I3etXOyWeSHU9PNqK8VN5B0gLkkEqb3ZxgbBrTcwn4vesxDLNQI5Kp9Uu/L2LVpIYh
         pbTNUO5BMtPBKnDAQnNGP6isDScS4KKT241ODqLdje/7/pq/e3fpODGq/vsA/mUV9/sd
         DVF47GP5fHiDeutuYPBpJzdclqD3uHxIRJmN5NSGwud7p6RUi6KsbHxMn5UpCZYQ8O4E
         2zxfOybJa02dPUf9Lsz7uFMWRO9K01TNB7ABfLNrYSOTiT9a6uMQIMq3z2AUgRQ5Y6sI
         tmg+QENVLbg++mGWLJy+N/MRx8OH1szJMlj9J9neVTeyv+GgxIEjFQgcp1TWDqBOD0F0
         zSIg==
X-Forwarded-Encrypted: i=1; AJvYcCWIMAWGy+ILUDjF99dFOA8xsDqPO1y5BIa6llWSdhKYaDgcY9B4GSKm6AYy6cGSSFt2b5F8wy5N3Q==@kvack.org
X-Gm-Message-State: AOJu0Yy2b31Ig/JGhWep3uPj3UrLXroqbJf4nBBrQj6cQE3HRhC6JoAe
	wK3lQ/NEyE8kbr2DRpyg2G8dO6J3DittKu5kJVzEHmX1bP8R9VMM2jzyzpuwJA/Gry9SOUGL4k8
	mRGk6TXBE+AEplTatUlWK+Gih47gB9Lli2GAjBEK+6xSdLZK2l4CZ
X-Gm-Gg: ASbGncujXxp6VAbN6z2MvaUEXgHJMNufmHiA6FrJSbmLAgTfoAAJYNWjjGqgcvXjNBA
	N67Ccxp+l3XBH9cjPRrWFBsyOhY3IhLwXQJ5MHWTAPGwKi/maZ5VDEOecVvEyBLsUS9KrwaqHaw
	FEiHA0a5O+aF81aaz+2YvtlBlzbomsQY4V6jCymTajcj4ZOecYRfqobWzspEDS7B0ppgItWX3l1
	jiZuAUWmcv+b56FtgrDh+oh8tv4PGB/xI329KgHk2jSTqukn5dOA8DRQkiOyhN/0K57hk2qDPR2
	w5VGdMXKNfIgJg1gbf0vQSRycfa8KFkc5lO4+uRLEy2aB/cfxoqbhTievaP1mMTwCkkTKFojQLB
	AoRzrlkHAH9IHFbaCUPMwESOPF4oQvpa1JbPzNW8wK30bPTr6e73dJ+VZ5yGxCt/x
X-Received: by 2002:a05:6000:2601:b0:3e4:64b0:a776 with SMTP id ffacd0b85a97d-3e64c4a5859mr6039934f8f.52.1757346364045;
        Mon, 08 Sep 2025 08:46:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGH0L9/mCUrbfcy9B9f9kRjFruh5pYVslSI/dkJK5qtzud/rfRXHKTDbMjnJFVOPXLqfNNQtw==
X-Received: by 2002:a05:6000:2601:b0:3e4:64b0:a776 with SMTP id ffacd0b85a97d-3e64c4a5859mr6039843f8f.52.1757346363314;
        Mon, 08 Sep 2025 08:46:03 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e21e4c0e6fsm15532578f8f.17.2025.09.08.08.46.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 08:46:02 -0700 (PDT)
Message-ID: <365c1ec2-cda6-4d94-895c-b2a795101857@redhat.com>
Date: Mon, 8 Sep 2025 17:46:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/16] mm: add vma_desc_size(), vma_desc_pages() helpers
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908153342.GA789684@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ng26TQZX5tqPiw7rXLmGnOhIZqsHYI1aVYM4AS_C_xU_1757346364
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7CD00120009
X-Stat-Signature: zhuc8aqtaqhiue8xcxoeh15gzcxmj4uz
X-Rspam-User: 
X-HE-Tag: 1757346367-432927
X-HE-Meta: U2FsdGVkX1+lVeL0+Y7/ZpldkZIFw737lbUQIWtrkhtDsHggLFE6g8PosHE4M9d0rNErsFbbF0ax/8JuSivMxaOlCSrm3q+tAhIa8vYC34Sg+T4/xxhmGz+56f+p3Pc/xoiR/i24KOFCJXcZcojdsflzK39k0sFD5+4QUpeHBf0fCb5px6lIhAJbZw7La9jdAz7wdgU5xulQG2ne7Qu77jIV78JF5BWkn5N1yfTtp0jRHF323rwCB9Nx63TFDuwALCB4rGwwsQNPTBJY1spisHC7pe0+WfW83Gl2Hw+rF/+c4LoujV+IBgj1Tvuoco1mB34SToASvmRhFuYxMyffyPDJ8CYlhPW63bb55RRWafbYUqTmCdoEe8f9FSUzEVJ6LOV1uaK/6Wrza3kTF2BqxuFDdjO1lUwgN5zlLlQNdpX7EfZuLT0iIQFYokhGUNm2DyZwfpRWOoinCiOSQkLxCfwo53OmiRkf/Ax3w3wlAUoUwaChdElA3zUxkkJB/f9biAalkk34Z+zIeQTcsBvw9qXyeM83mC1Enf9qRZs7pxfpYxkIBjImX31T2jxwqCMgHePewLYhN5hDTTZBbESjiqA/yGjSUiEyCtP0ad5Plvr9CiNakqYmla9D4Sphd7rFPlCkiZAeYMTluMlZmUNfEdcatzoy+0bkD2Z2ijobgDHhF+Hxdd7f7e0sTFPl86KioWlIltpw35dDUuWoxWgh9efg8MzkAYuFpyZX+weDu4nH7egqXsJNVEClRgWnkQLdf2BpW71tuWk4LSukA+7vVgYDMhLlImlr+r8mLSUENCR7oozGXvh2yy2YXgvXsi8v1g8RYbdfBXCR73ar0qwESufQjTk+Vba7JmfVHCh2Bakb3sUlVr/7Em0KKGnvY/qxTpMLECQRUqeHlvWyFjJ9XDX/61nphpERWChH4CZ07a9s31DjRKXl8TrpPmZ3qXeKO9Jrvn7KJbJr2U/HCnG
 2F9t+ZrW
 WR5ggFIOst6UGfA99YNUbrp5v4KOWKH2/xNOpEtHsTIo3Bw+n5M1fZap580oDLefEQEVERqhVAoU1ZLMyTUcw+tK7VACppwioNYygIyJ/Fr9KdcUVxI/PgFuAvNdbBXYYAV3zPoU8FpGfbE3MIQbJ3dDOhGpimnonXQe1wRnezFDp8OZ+jUW1hTFbW61Hx5Vxzzx+ntat/JoZ2CWQvo7X+QBx2HB/4w7SnWGgmcbzty70TdgbAWL/cJEp6rbPPWzZaed/h3V2SahI9lMQ0dahhekqOqHP3jkyP+tjI+7NZrjl6rUEMxHcgUEVuaa2/SBmC/NgsokaHsDrU5kYLz2ek6R4s87Vk+R/6b/jkgpjLER5PTc5e3pzCUpkzHp8Id0BgRUnGKlPnKWc/JomwBJyW3EdaUpZhcUgrf3tD9Dg8GSjdv29pzbhUCs+CBc9X5XT56nUA6P2tPnoj0kXzz7eN7jLU4/VcRbxNB6cTUeG3SKqylq754GbaQH9sJ3uhNy8b0VXTOcdRk9CPPAjCC94fdxcyUNYCZBo1fPnUFM4euDIN/w4rarp34pi6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 17:33, Jason Gunthorpe wrote:
> On Mon, Sep 08, 2025 at 05:24:23PM +0200, David Hildenbrand wrote:
>>>
>>>> I think we need to be cautious of scope here :) I don't want to
>>>> accidentally break things this way.
>>>
>>> IMHO it is worth doing when you get into more driver places it is far
>>> more obvious why the VM_SHARED is being checked.
>>>
>>>> OK I think a sensible way forward - How about I add desc_is_cowable() or
>>>> vma_desc_cowable() and only set this if I'm confident it's correct?
>>>
>>> I'm thinking to call it vma_desc_never_cowable() as that is much much
>>> clear what the purpose is.
>>
>> Secretmem wants no private mappings. So we should check exactly that, not
>> whether we might have a cow mapping.
> 
> secretmem is checking shared for a different reason than many other places..

I think many cases just don't want any private mappings.

After all, you need a R/O file (VM_MAYWRITE cleared) mapped MAP_PRIVATE 
to make is_cow_mapping() == false.

And at that point, you just mostly have a R/O MAP_SHARED mapping IIRC.

-- 
Cheers

David / dhildenb


