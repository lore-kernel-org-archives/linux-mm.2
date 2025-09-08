Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44922CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A388B8E0003; Mon,  8 Sep 2025 11:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FDD8E0001; Mon,  8 Sep 2025 11:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FF058E0003; Mon,  8 Sep 2025 11:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 801BF8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:04:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BF66B6DCA
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:04:03 +0000 (UTC)
X-FDA: 83866403166.22.3965D66
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 09FF28000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:04:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TT9jDVnx;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757343841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QDJIN7zG3W3mljseXZ/jACk2q/AyQF9T/9Te0n2aogQ=;
	b=p5S0DUjRWdyQfpTXR5++bEywUS1OYZ9KJ+bPfkMK0ZzF2ZbYGfN5O2DlLE8oee27y5x3RK
	peGEB0bvAIxw6FL7SrXF8JwDLNWXW8kzaQGkV9kIAT3zuFOEi6kMBHsjpJHUgbTPA17Oej
	uoFta+ZP3tmb0qZ98oZHUbantFfKX40=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TT9jDVnx;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757343841; a=rsa-sha256;
	cv=none;
	b=ajAzM5DfKKbvraxcOKxyVxYwX8crvd90eZS8cU4ePqDIjtIWD7McVUI4XnPzlS7DeY7lNT
	qFIFqJt35+hvest3qg+/guHVKWvR7imLPI/pyukqWhgq6TJuhlp+cSroUA2spoDzNOgvXC
	Wry02vsqMe0ivy8ovpRF5Hhi/JmEYlg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757343840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QDJIN7zG3W3mljseXZ/jACk2q/AyQF9T/9Te0n2aogQ=;
	b=TT9jDVnxByCPBYuSupFCNDXABmwC3BtGV5bK9hgS/UlZvcn/fdtN1tzQP8C1Xdscb8ZxKj
	85tRqaUZPeEaepV00OIFVxwrzcv1VHkiAN0fan9KrnyMkGomG4h9IRAHTd6YW9qgzTSQ9P
	/opOMDE5UyJTmmbUAh+kztf3g36Wg3k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-qR7F0I4gN6aKtabVe1ecUA-1; Mon, 08 Sep 2025 11:03:59 -0400
X-MC-Unique: qR7F0I4gN6aKtabVe1ecUA-1
X-Mimecast-MFC-AGG-ID: qR7F0I4gN6aKtabVe1ecUA_1757343838
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45dde353979so12308645e9.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 08:03:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757343838; x=1757948638;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QDJIN7zG3W3mljseXZ/jACk2q/AyQF9T/9Te0n2aogQ=;
        b=jsBQEEMwWuVaZWQwlGHQ6z2UUI7sYxxW4OwjbztRaJPhrnR56oIYwCzqlsHlfqX+Xr
         ISz5eq0nrnidYoHMdZ9i558otNarXDwi/dsI7NWnpPUfydnpQ+EmWej1v1rPbNIhokfd
         kB8NFCxaYtKMFpPX6MzkymM9/YwgV9BL42K3lsTWQ/hrxXxmchFsHm/sOeDs/Va/0KhS
         I58HTaMXH400M+GrqhqNKJTxAtL2eSZyzFsS/r2G4Zb3Zrg/ZxnphoiBTtEkE8/WVZl7
         NGJmLY+iFFa9gkUMREKqANxZQTZAQVFdouSPX8gs1RKfp5Qv/1SxSY4h7wdbuWKjQfLL
         Pyrw==
X-Forwarded-Encrypted: i=1; AJvYcCU61I+ot88nN7MOQW9XXMYbHtVxwt2HbCamVC821Ci2pdTj0+Mv5HCqh+OtYh/1hXpiMXg0Bm7mFw==@kvack.org
X-Gm-Message-State: AOJu0YyPI15dB4Z5Ndquol+ddjx5j3QKa7bEOl5eJw0IBj/rQpS2Ftj0
	Jn+elJPrMmXNc1VnkJ6qG1dK40ro6Ns6/4Y4sNKVcG6TVBBIkfNl+xYzN2I8NGvDe2ND/kCl2UK
	uLl+CuIyzmZ0VHz6Cr3+mw1A7Ps85kKJErhP5DG8s48XwQFidL+3G
X-Gm-Gg: ASbGncv5Ul3PhcCyT97UkheB3yZil57jiYXGyLe+lcc4FxdbvfyZ4pebF8eRc5YZDa6
	i8wYvmGBGmWTJqAitqmr4ut0zg0O4zpjf3MQwBlkgxb2KPA58ciiZGFr96CIe4LC3n4lFY33n+x
	zujKEfJ+G6rQ1EtwoXC+DvSl1nChX096kHv5Y3ODLl/M5iLzTPgXbBn6OJhwVuZaXdhoAnbfegL
	RElHySwpehCIVl9INTZeuBmwDhL8KsFG6E+mopr1AKIAUQ0Xk+hgJNjPDuNQGvfEgkBFnqmOYts
	irgm8oBo/4jyVM8/03v2TkQSTaBLFpG1WdB9rH3ZbD/zBFGEgWuttdosoZ5Yhhux4Zh0NgFFhzs
	XTSRYpWU7Mo9QQrQyYkCiy9UZis3iwF0VsipdJdDohKGIqU7HCZxsuf0UOdgSob9p
X-Received: by 2002:a05:600c:45ca:b0:456:29da:bb25 with SMTP id 5b1f17b1804b1-45dddee902cmr75155685e9.19.1757343837707;
        Mon, 08 Sep 2025 08:03:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFcYhKukj/qnNSUjtTjXPQvR6FO4J24oSYFDG6OuWaoCp94GzEZWcRix/Ms1WkzMyuueQOJNg==
X-Received: by 2002:a05:600c:45ca:b0:456:29da:bb25 with SMTP id 5b1f17b1804b1-45dddee902cmr75154915e9.19.1757343837183;
        Mon, 08 Sep 2025 08:03:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e115c4f755sm17147156f8f.39.2025.09.08.08.03.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 08:03:56 -0700 (PDT)
Message-ID: <e9f2a694-29b0-4761-ad7a-88c4b24b90b7@redhat.com>
Date: Mon, 8 Sep 2025 17:03:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] device/dax: update devdax to use mmap_prepare
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
 <85681b9c085ee723f6ad228543c300b029d49cbc.1757329751.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <85681b9c085ee723f6ad228543c300b029d49cbc.1757329751.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XaqqlC4LPGU4k7nUA8ShOBJfwq_GL8jGr4EWKQnoHIg_1757343838
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 09FF28000E
X-Stat-Signature: fi5asrcxb858z9sm965me7nc4gy9cdu7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757343840-739729
X-HE-Meta: U2FsdGVkX1/JOeAVg1UnO8kSNODce6XxQrmyGF8dqheU+rdqVUi4onLSXNNZs83JdySxUW0BKGfBU6ChF1JzT4gDGWEvYj0HbWszxHa0m2Qv2o7Cb1eUWgLJkMftPRFV4346FUSkHEz8UxVmpv3FZmvWMorjLrf6g5LCUy7GacrQHlb1Fa8kd+y3r0pTQhytSPgESy64Db7sR9E1lreQqJWQx2C6gh6qDm9eXAWjuQVkvYWoDlG0x0UIBinZnkpWpnnPRsd34hLZWO/tBgIKnO7cJLLZuDUuwGyaoyWwfrCYBCbp0Cq+Z1Q1a3FopdedbVZNftuIWKahsOgxZbT6uC2oQuxDu/kGlFDEXwZBA4ewfXVNFbqq262beptXka/+UeIrgMpFYzWaDxCKu3hW98nBElzYxFK5L7gtJqI46aZQY6pd3Bem4YvKOq8SAliaszDZWEuxRPQwBjA6b1zyldjj/yZ/3f4vMh6ft6JKNXciJW5ybpQG1qTdAiDR9OCUfabPWNgP4zb0nyzGjnKFo9EGqWd/BaN9Z5l0teQaP2HOde61UEzPZWFwm18n1orKEuSr1491oSXe8SFKMuBz4LecIOEUVes84n6KPnQAWFG43oRSCJzvARrZ6KR21R3XDv1v8//A02rwTUnw2qlKS8PXJAGaw+vbsSYRmtiLTquapRcuwkKx49HNQEUfIb5s5Curp3o8OFI3iQPVzBYZQInWSQOyJOT5It1pJXUsKlWeeK0VFOdm8pWdJ5oI+edzJm/cVSYNbRY/4muIOz4VvqKdicZ27nZpMK32IDef0dqqg1zOiXH1tyWyEWfmaPGHPZf8G8CjsA1wrNbbsB2/Jl6WPl+hwzBEGi1syi9C1452JzPIsxSkfr+vULdhHwY8qz7FvFszsEgqe3GBDPUb0bDsEDG+y0ve9BPh2BXJK6uUSuVwTgefQlFFWRh3mpYQLGUMF9caItopAsLiFyf
 mp8Q9/n1
 LEK6S6WOtkzskIqIg5u7/x5CPrE9mxxqCzfzLgbcIqTgLbKrRL5vjopURTDkXF3mVl4jbzg1CIHOTIdEsLRWjm9UTVrhkUTyKgCNAHf4lGRYLn5k7gofsuJobaILeHh6c3Kky
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 13:10, Lorenzo Stoakes wrote:
> The devdax driver does nothing special in its f_op->mmap hook, so
> straightforwardly update it to use the mmap_prepare hook instead.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>   drivers/dax/device.c | 32 +++++++++++++++++++++-----------
>   1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> index 2bb40a6060af..c2181439f925 100644
> --- a/drivers/dax/device.c
> +++ b/drivers/dax/device.c
> @@ -13,8 +13,9 @@
>   #include "dax-private.h"
>   #include "bus.h"
>   
> -static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
> -		const char *func)
> +static int __check_vma(struct dev_dax *dev_dax, vm_flags_t vm_flags,
> +		       unsigned long start, unsigned long end, struct file *file,
> +		       const char *func)

In general

Acked-by: David Hildenbrand <david@redhat.com>

The only thing that bugs me is __check_vma() that does not check a vma.

Maybe something along the lines of

"check_vma_properties"

Not sure.

-- 
Cheers

David / dhildenb


