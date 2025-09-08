Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BB8CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6529A8E001E; Mon,  8 Sep 2025 11:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602DD8E0001; Mon,  8 Sep 2025 11:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2FE8E001E; Mon,  8 Sep 2025 11:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 320F58E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:27:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DBA4E1DAE0A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:27:49 +0000 (UTC)
X-FDA: 83866463058.20.1E483F4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9324A40009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:27:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=it7AVOP7;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757345267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AcVb4aGGb/PCSNKySt679yYA4SUgcrQuR3+AtlRJhW8=;
	b=sQPw2nCwR285XRlCQPF+jd898uL2+1dI1rxx9o00lluwO9LntU9bcZJ5m3OglBFwjPyN6x
	qay/RFqLon7etgIERnQin3V1fNVwZZ/PmYpt26xU+eAkYSznpVcPhlO+XP/wFKhbMb4LlE
	GXPRQeWdkIKozJhkHCNpFWhB+QO8jyA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=it7AVOP7;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757345267; a=rsa-sha256;
	cv=none;
	b=cU31fJWEAFaiSxbvVl9ORxuPaninXPMHzvPJy8sl9kZ6vFBACSbCjguPi0d1b9/CcRYAMo
	lRsEheCmBgH6AszcpjwzCzfYOe1CQ929jDgiwT9bbNGRxryWmPmrtYHG21JL+SR+SABtmV
	/MmeWykCaWaWgHsVfUrh+bA6lnVzKDg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757345267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=AcVb4aGGb/PCSNKySt679yYA4SUgcrQuR3+AtlRJhW8=;
	b=it7AVOP700YP7sQU0xZQIpZzKnuluUcodI4I9cfBufWtKxwh6fm+S01rjgVP5NVJfwFjjM
	PuFPCGaDvL+d+2Jrpu/4UH4ZstoRS9X012V1oZEOoYKri45rH8wzjOI4VU8e+O4fWDVszi
	MmsJ3AC9TEssyCVixogGc5WMS7zDS1M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-EVLJhI--P4eVwmf8aFczaA-1; Mon, 08 Sep 2025 11:27:43 -0400
X-MC-Unique: EVLJhI--P4eVwmf8aFczaA-1
X-Mimecast-MFC-AGG-ID: EVLJhI--P4eVwmf8aFczaA_1757345262
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45dd66e1971so30438935e9.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:27:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757345262; x=1757950062;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AcVb4aGGb/PCSNKySt679yYA4SUgcrQuR3+AtlRJhW8=;
        b=smlF8GV94ZI3LwdEj72SRCqlnb5UI1Mez3FzPW947P8mE4omzbcNK6fwT9pa5KMuKH
         fKxbLrKSINr5ddqUB4dpEHCpraYTSJvozxoroWBkWOEz1VgNxD8STjJYZa1YdRsuxcub
         32sW6YA1vmhydeQ6Qiyv/SCM+5VTzTdzqVfjtnRTxkEnexPtHNd/BneOIW0M+Lj60LdR
         Pk2w65k6LGkOJp/8sYM8zLnq9ZdjNkEhaOVCG5ANzCtbTaJ1JAJ6WNw2jJRdKR+wuzZr
         tnzAqCFaL6JE+7jUPNeZVawoNFtetHNbLqc5N+XDHaMe4I9yLiZxEAoL9MZgeiKSP6yA
         OZbw==
X-Forwarded-Encrypted: i=1; AJvYcCWoi6smtQJHFJf5tQufBcVpgTA76Gi5C0DTXUriHhn2BHyCLP0ywrsxEAHgq8dQG63Zbbbg89DEXg==@kvack.org
X-Gm-Message-State: AOJu0Yx5xzwzq6pVO3uXtX6wTV8+Lpn8tGusv50pQMTsyNAwDl9Je1ea
	4mEhLqDtgJXagHATiRwQhLCS5wi9SqGZpnqe3eSS2fKTnapWDOQQLdYGlFG2LwYjJJfWo8S9JAv
	t8UgNkhc3rsS9p1LdahkzLpLE2I64nx6+fV+QX88sxLPJrWH/0oVx
X-Gm-Gg: ASbGncvrAo5RALmM6WHFB77g9t70Y/+flhY+8YFNKJGNHO25jSeCl/2vWkIutF5AQuL
	+jPKkqKs4715NZvFXDFgq/DzQ3TqmGe1hum9xh1FghsiW8gB3eKAcpWrMfd5TYD/JpdzHXu9JdF
	FpuzlNDJGxc5XglQ7a2jSuhazneCW0AhqzJp6kwdRSD5EeqcY7wbPoTV/r9XPjhnO5NUcAlJSC9
	ZHPtOe5WlOQUHyJaeJ9o4PEZLAg/KO4k3a9Z0/LcVOR05CbMLBH3dL5BMFbhcmZVWQEPEIujEfl
	szFO+p1ZVvUNEmR6KwIYJ7ZA9pC683jWJxJFJuwX0yGwF/TVrzqrax3hI58eWTREAiEiFlLDREC
	Ds0UP/Ejo+tkMVo5x9auPLgbEjobbIwIp3OAFcZVEelC0NgrhU0q6xmbm5DY18lSU
X-Received: by 2002:a05:600c:1547:b0:459:dde3:1a56 with SMTP id 5b1f17b1804b1-45dddeda169mr71402115e9.28.1757345261626;
        Mon, 08 Sep 2025 08:27:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFqHRAU8/Ayw6xHlY2Njo83Xv4mquQlEJe0L5F6BJtpt3Rw+E9lidjU1mHw6Po2oKE6ibJ0w==
X-Received: by 2002:a05:600c:1547:b0:459:dde3:1a56 with SMTP id 5b1f17b1804b1-45dddeda169mr71401445e9.28.1757345261153;
        Mon, 08 Sep 2025 08:27:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e8ab14esm485746255e9.21.2025.09.08.08.27.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 08:27:40 -0700 (PDT)
Message-ID: <ad69e837-b5c7-4e2d-a268-c63c9b4095cf@redhat.com>
Date: Mon, 8 Sep 2025 17:27:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/16] mm: introduce the f_op->mmap_complete, mmap_abort
 hooks
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <ea1a5ab9fff7330b69f0b97c123ec95308818c98.1757329751.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YGmOhTA3n0qu0UKY_Tn9xmfCmptciUd7wmRD0upuYAo_1757345262
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9324A40009
X-Rspamd-Server: rspam05
X-Stat-Signature: r4m68yf57ix4sj9zdjq7f4xfkamp8hhk
X-Rspam-User: 
X-HE-Tag: 1757345267-641990
X-HE-Meta: U2FsdGVkX19Fo3/0dJPJ0AiEo2+5piwglEyBeiMXsy5aFjDVYhk/iVi6VaDOnDK3NbK21C8weFY3zjvbLCp6knJWMbFPztgOUIgwket2fX3c/vsdfAwRWlEMV4TQbbiJHo7uG3FMI1wYjxrMDB6CSxJG0wxI0SKpTM0c88xqcsxP3n1FcqqxdHS/YB1U8bmUbuZcO4M5MRULvvWY3vteunFMZCM8LN9fPL150Ozt29zbfYchGE9oURZP0WEoS7IDaCiKHD+TK0oBOKwixv5lE90aWPKQ3UKkVJ1VYgt9iIWVveNnGxhRjVYQXbOOTDfYyZeVzLDFMmlqL4OsMv4M74DamqvgyJ3nnvGnWFz9KUHfMaf3gAMlOFcut6r44TVVN3qzO8U71HJwk/IkJHvQMh51v7884mG7PWsfUewP2CIss3Cg/xFiACO13d/Vp2JhxkjzKJvGJ8Jy0gXwVcSavq8ukq7affyNJRVGo0rLUK1tuUj5fu5q7t2qSkqPqsw5iIoOCBMBVw1Ql9JScVDjTXLwrxh2lIvpz02LIPcZCphVOgHZPw1Q3JyQVtd+1WQqMKMvvRhcjo+yI/jzbhtnSsnZbaXC+5DPGWy8kP+DzMo+mTzEj4217oELR1UqOrDBKl13w8JotXgXKt1Dypv1b1k36cuRQZjhzRydiKrA9gs3i5oRXpERdvRIPimddUcZKBeGYlz8R30LQltWL/dwDQ3kBUoVwkqRLWR8xClPdcIc7AK1pXbhVSJapPlU4srhH95B3oeDIAc8IpzZEB+w3DVQ+0E+ZFF3ayemKt2VYyzqMaBCN8izKs2sU0usPzvbqSACtyYg+LqyXT3KUkzPBjkQW+7HKufm7a9apAqvV6Ycsun/m/yHa/pC86x/cEwevhHTz+WtHQc8qK0qN3B9nnV1rriP9h6qEbvyi8xRFXUIryIMNbKwbxLca2dpbRaaXci6u20+T6mTQumuNym
 UcPHTemv
 5o1aUYdpXepgKkx81X7R/HXDlkZSsWtJWBz/hDhbxc5D20Dh7EAygcDkvsGk06KVyn+EcJ7fSnBGoU9wgUrRSp1yAUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 13:10, Lorenzo Stoakes wrote:
> We have introduced the f_op->mmap_prepare hook to allow for setting up a
> VMA far earlier in the process of mapping memory, reducing problematic
> error handling paths, but this does not provide what all
> drivers/filesystems need.
> 
> In order to supply this, and to be able to move forward with removing
> f_op->mmap altogether, introduce f_op->mmap_complete.
> 
> This hook is called once the VMA is fully mapped and everything is done,
> however with the mmap write lock and VMA write locks held.
> 
> The hook is then provided with a fully initialised VMA which it can do what
> it needs with, though the mmap and VMA write locks must remain held
> throughout.
> 
> It is not intended that the VMA be modified at this point, attempts to do
> so will end in tears.
> 
> This allows for operations such as pre-population typically via a remap, or
> really anything that requires access to the VMA once initialised.
> 
> In addition, a caller may need to take a lock in mmap_prepare, when it is
> possible to modify the VMA, and release it on mmap_complete. In order to
> handle errors which may arise between the two operations, f_op->mmap_abort
> is provided.
> 
> This hook should be used to drop any lock and clean up anything before the
> VMA mapping operation is aborted. After this point the VMA will not be
> added to any mapping and will not exist.
> 
> We also add a new mmap_context field to the vm_area_desc type which can be
> used to pass information pertinent to any locks which are held or any state
> which is required for mmap_complete, abort to operate correctly.
> 
> We also update the compatibility layer for nested filesystems which
> currently still only specify an f_op->mmap() handler so that it correctly
> invokes f_op->mmap_complete as necessary (note that no error can occur
> between mmap_prepare and mmap_complete so mmap_abort will never be called
> in this case).
> 
> Also update the VMA tests to account for the changes.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   include/linux/fs.h               |  4 ++
>   include/linux/mm_types.h         |  5 ++
>   mm/util.c                        | 18 +++++--
>   mm/vma.c                         | 82 ++++++++++++++++++++++++++++++--
>   tools/testing/vma/vma_internal.h | 31 ++++++++++--
>   5 files changed, 129 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 594bd4d0521e..bb432924993a 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2195,6 +2195,10 @@ struct file_operations {
>   	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
>   				unsigned int poll_flags);
>   	int (*mmap_prepare)(struct vm_area_desc *);
> +	int (*mmap_complete)(struct file *, struct vm_area_struct *,
> +			     const void *context);
> +	void (*mmap_abort)(const struct file *, const void *vm_private_data,
> +			   const void *context);

Do we have a description somewhere what these things do, when they are 
called, and what a driver may be allowed to do with a VMA?

In particular, the mmap_complete() looks like another candidate for 
letting a driver just go crazy on the vma? :)

-- 
Cheers

David / dhildenb


