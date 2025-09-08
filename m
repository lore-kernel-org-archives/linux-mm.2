Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6001ECAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A347B8E0009; Mon,  8 Sep 2025 13:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5178E0001; Mon,  8 Sep 2025 13:37:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885E28E0009; Mon,  8 Sep 2025 13:37:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7435E8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:37:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16149B7132
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:37:13 +0000 (UTC)
X-FDA: 83866789146.29.DC5B210
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id B458418000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:37:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fGszev+x;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757353030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ddTrLlBONI++Tc0vmAVCsKGI5mMqVsSsSog7PjuxMWA=;
	b=FGlekrPWsvMPTWTFVPnBJnOuvKIQbScUovrwcBRIp7Y34XmxULzZSxeDNOLzdnIAm2Yo0n
	y02Y8FvNcPGwVAJH0004GHHMXervSg2tt/knZpec9Cn2I/jgya9Dc1iiEFImoboZsu2TNc
	ACUSm8Ew96alvPfHfcI7RurdEFs3Dok=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fGszev+x;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757353030; a=rsa-sha256;
	cv=none;
	b=uBxIBGHoReSGm2EFX1ViV3iYQ9/gj7za47Pk2gnlAvFZrB9LMXlifCRia0Q0SXO5C+IdhC
	S76uedsb5YX2tpLlFkZ7yoo7ogD/MrXkj3+Dn/fBNDsvoXCxVMcqDlhFYnmjXPLe9jIeIJ
	mrPNgIA0QzreeaGq8EmugkALZFPSH7k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757353030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ddTrLlBONI++Tc0vmAVCsKGI5mMqVsSsSog7PjuxMWA=;
	b=fGszev+xE6BPXdxIA3GEjiZjGlQujofNXqOmcOzZwO+e9yzsR+nhMlrB1jktxbL3lvqlbX
	z2XKjpMQhxdy/hs7MDeBhJdB26pvGNjDKy4juY1jjSVBrG9pFIOWMA71qePjrKB1kwT9vs
	Pq8o3WPelTt5wTLlySi8/H7gcEZGe20=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-h1YPICSVN5ajEhO8bluSbQ-1; Mon, 08 Sep 2025 13:37:07 -0400
X-MC-Unique: h1YPICSVN5ajEhO8bluSbQ-1
X-Mimecast-MFC-AGG-ID: h1YPICSVN5ajEhO8bluSbQ_1757353026
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b98de0e34so36668235e9.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 10:37:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757353025; x=1757957825;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ddTrLlBONI++Tc0vmAVCsKGI5mMqVsSsSog7PjuxMWA=;
        b=MKKz4S29l8zX4OSGixaxdkUv5x7oKtBlLJCWHUu2kphhs8AHxqaZVIqKkvscptaS7d
         CYdDuH25qZo2iQS+aOKSpSc6/Zmd8Xaqg1/HBDoAzoBZZwaLg609gxqq3sZYOMKWOAoa
         jBZYtUNhD5VwDe8T77kXd/ppBF37i62OXrzxWJqDhIkGcZJHCk5rzsPRzl44690OIl3d
         BLny7bE568CzRynbYJ+D12O/72+Q6gYKZ35/Q/3L3FLl91dy+9ur46WImQpiGygBC/GG
         iShvy+nAq7bfD9RZ9j5BUPAzq6y05pnewDUTScEkWONZbqgqPWnP4APQVfkDOmGUlcu3
         7q+w==
X-Forwarded-Encrypted: i=1; AJvYcCXdXr8IwfMUJ4fEOGaeGQvbp6R3q2zqIfDA87kNkZ5Sc7FBOhLIdXyrd81+LuijYNegHas6TdBtiQ==@kvack.org
X-Gm-Message-State: AOJu0Yyx2wSQ14KliO/ajmUdsLQ80L/X44mnN0qUU18WRUu5vKhEUA5P
	Unf0r3zP1poFWXtuW3EHpBT68g2uZi2+wQTDzZatW/lDEm62633zGyWEUqphXFgnIyvwx7LFNTw
	Kbgx9YFh/dz0lHc6eTDHzgwxLMHnf112jSptqPbC0kfPkIS1jxgUW
X-Gm-Gg: ASbGnctYk0CV85G3l2raGBcd840Dw4z9t9eP55Vkt+cZ8k1RUqQmmTdR2fhhMr7a+xP
	sYNFXBmF0N7j+KMGKDX40n3HcKfk7r0FygApdN7K4Yf2uhQNRrTZ7wO0Cuupvuug6wLzVe+T74B
	n6YQAhO1FSZrsuLfvUDPQohB/a+U5UkrXKuq12VTEt3IxRrx0Y6lORrNNKEb5OlGUzdWtWLgFYq
	DfdO9hiXgVIy5VO/jR2uTxtD+NkwvhLc23dd2dyHcqRHmxAwU72nyYrOr7O/+UwtK0X/EYozDYr
	rFDoTjGuzR+pzMyRNFZt1CE7/7OQuhTtmWaI0egfnnT8cPwwaN975hTan/KxkgPtws+fcah5GfI
	Ix9slA+3mizYNGDFIexB59kSLTLdXW0Wg7Qu4ceGXbVWpbYnpRTTN3o/uKcDHauXV
X-Received: by 2002:a05:600c:4e93:b0:45d:e0d8:a0aa with SMTP id 5b1f17b1804b1-45de0d8a342mr90484955e9.17.1757353024936;
        Mon, 08 Sep 2025 10:37:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbv9r9FbyFKOKYYRfwPOE7IG/CuXRebsq1QPIBNdBs4sMFncfDfGM1509u6wSlpw7tNCWppg==
X-Received: by 2002:a05:600c:4e93:b0:45d:e0d8:a0aa with SMTP id 5b1f17b1804b1-45de0d8a342mr90484185e9.17.1757353024430;
        Mon, 08 Sep 2025 10:37:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45de16b8b58sm99810995e9.4.2025.09.08.10.37.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 10:37:03 -0700 (PDT)
Message-ID: <7b0f5b81-e18c-4629-a715-b5fee722b4aa@redhat.com>
Date: Mon, 8 Sep 2025 19:36:59 +0200
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
References: <e71b7763-4a62-4709-9969-8579bdcff595@lucifer.local>
 <20250908133224.GE616306@nvidia.com>
 <090675bd-cb18-4148-967b-52cca452e07b@lucifer.local>
 <20250908142011.GK616306@nvidia.com>
 <764d413a-43a3-4be2-99c4-616cd8cd3998@lucifer.local>
 <20250908151637.GM616306@nvidia.com>
 <8edb13fc-e58d-4480-8c94-c321da0f4d8e@redhat.com>
 <20250908153342.GA789684@nvidia.com>
 <365c1ec2-cda6-4d94-895c-b2a795101857@redhat.com>
 <3229ac90-943f-4574-a9b8-bd4f5fa6cf03@redhat.com>
 <20250908155652.GE789684@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908155652.GE789684@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9elErtLV3ajRI0fBfvcsmWLRb4a27Uyy68MNxGq48WA_1757353026
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B458418000D
X-Stat-Signature: a4ec631panagg35y949s6trnp63uaph9
X-HE-Tag: 1757353030-432196
X-HE-Meta: U2FsdGVkX19uCnq7ykrDYWG/Xlhb5tpaKLlRsbErq8nMxVTw71ZIUVow0l7/Ledp202o0FFAqZ4EfpLryYESGbiOGAuBCrKdjs0nt85u5llW0Jhpput+d0P4q6wYppMF2BjYu0D8+eQOAOtujfEhHghHtPm8mYBGf/wUX8A0PfX+13QZUZAyr8NaHSxzeI1+Ha8w8e6/vH7FCDGR8DRsX6jxeR5PP9V3XiuvFjI6DtVCWOJDN8HQpbNWWJ6WthPp4QWF/iEvymzhz/teyKu1KLPvvYQqIpQc+sHoDO56smIW9jYhLNcr7Dnf5YGYx9m/d6rBsl5OfDw/NO+UjA6q19Jv+YVpf9WfEbj+TLBbSnckI9X2SpTcGrJ7r5dIAYYGdkZ4kbNWpLJ+B9KJ/JyYuUNjj6wOzP9y4rSYxfZsvXuX17Sl/nI3TvIAIrVZTZTSTuX5FsCx/ZYO/4KWP1IC7+xkfRSjPi3ow+q38kI6Tg8HujzPzgTZSefVxO0846Gm15Yt24wpGtAXPgai0ywsD9FZ6X/YwKZSY6UxagF+4BTNnBLVpuiQ7lxw8q2I611QBXE43ds4fR65L9QzyzSCdJRrrCdY6lbwwZRU/iVBcOjmolrPRwDheAYWWbLxUEYGRlhpywCgKPFXE7goCDnQ3v7QRn719c7ZjQPAuCzBSuUE98KWD3Bi1CS1BiQKubolovU3UmMjnIfJL54XbqQhMP/3N8UfjdO1309vWjZjDz1ArhKAPjAvQ6ozeNmsFBcOJCkG7+cFucbPIy5BmXbLl0AD+ZtRwTyiC0FiQ1XjZp/gkrFRi+CfvH5yhLYmwz9ZATvKRCa2WnGrfHwvqB7OdqJtWbE2OvgZzCcXdeXEYER6VvOZ4gaSxGiC+DAHDZysaa6TUvhEvRyF/5yMniHP1oS8eVQxSrmXWsjVtT4XRh1vnvrNu5DCeLpuBe7d6sV5AvdPBuVxOGSrwsr2DVY
 22ggSCF7
 X9BDxTVmGbepm8AUrIFrZeQdywPG50He7kbRlSfOr4+FWQix21o/NTaSgvrzHXCsTRCfkFWXsEreopkJUWn5bWOIbHBzTPU6B5rTQy+fiBwVr6JYEW29fiHBSlPTHO36YxtUgHhPZVaMgBSUKJjSnumLd2ecXBbzh//RtYlbSOrIryEcq+YJlpJguUv2yhEmrJqAQqYRBb0SbHOJSikcJXtzC3u/+5jtTZ3KggkV/XEatO3c7HkshXUGNFYwBFOFyqKXYuA+8wav83o/5M9bE7dvj+DshJ4u7WTg/+92JowZ/djPQZIik2Z9Dct8xnjaR7COUMo9+ZQxJbkNo/c6J6LX8tEG3x/DQyYZOyGhhRX/aDSIzGBiqXKIZwDNQRvY3/UbttqqrlFFv/b8jOenPIugxWqwL71MSD5zb3fOOBqWXU0pOOC5BfUdhjI8BhZAOX840zM3ipahjilfZGnU82O8IpN+XovwpgPwLiioHGmTy5az1PbW7F0u/DBSnUNXn/mcYKLz53lWXG8fG9PxzFyw39u79FoS7zYSxvzlGR5a8nUfYW2YC6B7+zsOgJ7RuNxCytB46KzvsKd8tX4g/E+HidnoTIeRu2tbqGz7eSdOjJvM2kmFRUFw5JPqVMvQf7Qk1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 17:56, Jason Gunthorpe wrote:
> On Mon, Sep 08, 2025 at 05:50:18PM +0200, David Hildenbrand wrote:
> 
>> So in practice there is indeed not a big difference between a private and
>> cow mapping.
> 
> Right and most drivers just check SHARED.
> 
> But if we are being documentative why they check shared is because the
> driver cannot tolerate COW.
> 
> I think if someone is cargo culting a diver and sees
> 'vma_never_cowable' they will have a better understanding of the
> driver side issues.
> 
> Driver's don't actually care about private vs shared, except this
> indirectly implies something about cow.

I recall some corner cases, but yes, most drivers don't clear MAP_MAYWRITE so
is_cow_mapping() would just rule out what they wanted to rule out (no anon
pages / cow semantics).

FWIW, I recalled some VM_MAYWRITE magic in memfd, but it's really just for
!cow mappings, so the following should likely work:

diff --git a/mm/memfd.c b/mm/memfd.c
index 1de610e9f2ea2..2a3aa26444bbb 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -346,14 +346,11 @@ static int check_write_seal(vm_flags_t *vm_flags_ptr)
         vm_flags_t vm_flags = *vm_flags_ptr;
         vm_flags_t mask = vm_flags & (VM_SHARED | VM_WRITE);
  
-       /* If a private mapping then writability is irrelevant. */
-       if (!(mask & VM_SHARED))
+       /* If a CoW mapping then writability is irrelevant. */
+       if (is_cow_mapping(vm_flags))
                 return 0;
  
-       /*
-        * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
-        * write seals are active.
-        */
+       /* New PROT_WRITE mappings are not allowed when write-sealed. */
         if (mask & VM_WRITE)
                 return -EPERM;
  


-- 
Cheers

David / dhildenb


