Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E5FC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C27A6B009D; Wed,  2 Sep 2026 07:42:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 799A56B00CC; Wed,  2 Sep 2026 07:42:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 688E86B00D0; Wed,  2 Sep 2026 07:42:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41B526B009D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:42:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B95431201B5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:41:59 +0000 (UTC)
X-FDA: 85168633158.27.FB1CBBE
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id D176712000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:41:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h9RmcuGX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of eli.billauer@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=eli.billauer@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788349317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8Dfh++0Ud+IxXdfXwfXS9P60ggh+Cfx9Hb6zf15cRc=;
	b=AJHg9gASbxX+bvOGWQcubHDEFfrgoKyS9INMA4raoOkffnQ4vWA338capDNpPdMB3WN15V
	aLOvcOe323016wyxlvkc1G1jhoeMGMl04X3RspjoruORHx0ScpUrA6uKhhfXDPXL4YGHfF
	TYKQxYs3vGnx9RV/1RgH0FBf1QQh71Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788349317;
	b=MCynr5Nav5KM7MHg+fTeR2bB8U8nkNUzb3iBqa/XnR6VVZJSynuNd3bFRsSht9FeGyOVjD
	13vfZkuxiw9UFnjYuPDcQLmD6vyiz9b3ufvGj3iA8ZuBUHBnd5i3Op/IvAfCPU6eVFchQQ
	GFNeGvHIdysQhdjyrGisFGyu70IypxU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=h9RmcuGX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of eli.billauer@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=eli.billauer@gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a65e66555cso1297673a12.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 04:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788349316; x=1788954116; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z8Dfh++0Ud+IxXdfXwfXS9P60ggh+Cfx9Hb6zf15cRc=;
        b=h9RmcuGXh7fuiZjGm2iSiepXG8HfgBcCqMrCbhCJuLCQ56/DAPD+InwHy45X/ZtBxC
         o7OOS3djV7tXRcVBldTeKDfnn7YLfD905cI1lJyo6+pjZenAKddqQ0L4Cjq/PSIe1WFH
         cn+0Kodclurh50HlNomGz/sjwe+Krg8g2BhN+gPqXomaUThNnwRVCfqS2brWakXjch7S
         qyvSNuY9z+puwK3nEwJNCSxIX7bDid2XhMxTpUxkLmLzAsEtaKwrEG0lhEl7PZAL0qbk
         qWYbZxIMnx98F/8iab30tiv+bxWEbWSu+hIyRUVEF7Y+Pf5kd1Cf3B11fdoQs/BzhrVz
         iweA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788349316; x=1788954116;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z8Dfh++0Ud+IxXdfXwfXS9P60ggh+Cfx9Hb6zf15cRc=;
        b=BdDYdYSJU/9SIr+hLgAdSHewL8RBMfjild+9Wi2FKbC1xItmTqgnMZtzZ0SBrmJM3W
         RrT6tbUoABtDhW8iaUlIE2mVQTLz3+KavyO/P3h6iYJ/L3kiMsTCfpz25WNN9TuUiiYb
         td/997WUMPTDr7lwJGhR/WgGqr9R+8UQJQTAhnzFAbcr/uwBRBOCzhukldsBvN2vcKuG
         SrXK8DvSWbvXW5CDJFVih7oWgR+rf1HHcECcB6WMYAsBEvQZPN+1sHdy5WGM84QFCvkH
         diN0RnFA3oZlSDffVzqKd2fATma6Diz7t7sMtMZ7uIWrRahMzzgrGQNEMH4EyqvgVEq6
         oZnQ==
X-Forwarded-Encrypted: i=1; AKwUvBxutBeftcwtZtqAMTGcnTCeO72s8KRV7wL2hqboOv9Q1dLkC5rexsQQ34rm2Dg2AQ++gfjOfn8Btw==@kvack.org
X-Gm-Message-State: AFuF++kgQkESX3VOyyrejIDgQFNJ9DrnvyfcUKAxec0o+9ETSkGyzw7u
	04+rWzsA7YR+JEg5dTF/X2k3GCjsZlaL+VWCOBSWKYU/f5x3vOOXsN3Q
X-Gm-Gg: AYBFou1if7QbL6CpIo+ws08N5ndXWpEQbvXZvfBSCxf7NoKDVh2bmW+ow25+RX+ioS6
	+i0ojdeRgq61P2wfQJhkeloGGHpjzOgNeX4BQmVfHnUZjxYQifohchB6dVBLk20qWOYGoA9Q/xK
	j0b7lQs0GGHbX4u9Zhf3POcgg5ItW+aygOuQlun899If+iN3BlaCInHJuamGklBnXcJrgnf4Y/X
	IiaNqhKikcIsHEx6PpqedpGA3Pxab2sS3tl4Ew/2zzAvDeWqHk6mYTOG+mH/DTjBxa64KmULQ+3
	57z5yc6ZQe7nmSH6s3bgIE6yE+RGmAbDBZdZ2xh2oJ3ZbSgfMbHtgpHpcDodR5uoKpoo/GZjH97
	RstDl+mQSmyGVaL7o828WHc+O4dSCVcdvqOUekhw4MVeBAjKab2u9IxHNp3gOpzadgt5LrAgdNP
	vL+tBTPAsdDjVKrWj0xNXtzU/HYNknZWCKQNJCcfUijIjR8o7Lo7UdTvJyXJpbxvUNA9Cx+MVbu
	+QNYpr0FHF+ctNC2OxfcEg=
X-Received: by 2002:a05:6402:3608:b0:6a6:32f5:556f with SMTP id 4fb4d7f45d1cf-6a682ac0a4amr2806106a12.17.1788349316334;
        Wed, 02 Sep 2026 04:41:56 -0700 (PDT)
Received: from [192.168.1.89] (c-85-228-45-68.bbcust.telenor.se. [85.228.45.68])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c25d044d776sm117567566b.62.2026.09.02.04.41.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 04:41:55 -0700 (PDT)
Message-ID: <9a3d6a08-339c-3315-cc81-46907d0836ad@outbound.gmail.com>
Date: Wed, 2 Sep 2026 13:41:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From: Eli Billauer <eli.billauer@gmail.com>
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
To: Mike Rapoport <rppt@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>, Arnd Bergmann
 <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Michal Simek <michal.simek@amd.com>, Ritu Agarwal <rituagar@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <20260831123937.32255a49@pumpkin> <apaF1HUtJnstuUN4@kernel.org>
 <1729fb06-6beb-f8ef-3e71-47fc3f00345d@outbound.gmail.com>
 <apcPg_y-HsMki7we@kernel.org>
Content-Language: en-US
In-Reply-To: <apcPg_y-HsMki7we@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D176712000C
X-Stat-Signature: 3uacedyuetinstf86bmskyk6pryqqa1m
X-Rspam-User: 
X-HE-Tag: 1788349317-741389
X-HE-Meta: U2FsdGVkX1/yO9VBUgT2AIun7+4zV6PPsUeSKHZbaiuzcmunjBEW6715bg0Wiz8KHwst+2opkm4ysuO5nAx447RJ2O99OOW074Q5+b4mG+Guek/+0lFHEFy0jiqw/kH4LnEkfGnZO4x7XnuqWixGs8yYjokAiD89TNXIphXugWwIfa+RPHNgK/pzg5mXeraH1PTr5Fr/BiuVNbeQwYGr+01NGVcBHk8SIbVTl10VdztccjTKUORBxBY5zi1oTF6Yvxn6OuWVf570WiRiG5E85kBalfvzbId5EpznWUH6rJVq5S30lPyD8DClk8dHAjynU55yexECrYMdHHLCayHt8cV7+a5A5xyYUZbPmiuFUeqQeviJoYySG50n5O+xe2pmYO4NUWei342eAETlvH9L2G7xNW8SWE8wMbXy4v0pTzygKuPsqCeYUY9zBrIXk2/M8xWCDQfgo3J4AQrN4QLH5Ez2/jxowYWNvKu9A9NX+A8wRlKz05z3ySstqHoAEl994Fulq8IEPJk+hI4AJzgnDTCCE5uX2SRMPVWaWDLxP2slt8yaKoNJ1lnmEhkG5icYo2qUl/fsxYfLYjrlEW+5mZh/S+Svj6O/5vsufIJhn+SI91SPKUX7uTmUPGLnBkTBD9c3ke8eOvML7P9QcOBx3/lgEIR7NvEgZyn3M0narKZRlwvHUST1LMUAMsiZwSx6aLQ+eXnxd8njzedxQ+8x9DwcirdS25ikYjt/07TETC0fSNf13qj6/C3d09OCRbjlM0klCmY5kTgOrnSsBD5/FhsfRZBguHQGOVDlMKW4W2ASELZHqEIF3QbSZZArNDqnexX7FRsU6FXyN2C8QfMASS4eZLWwqHVw3YWNyhkx/HeHGYdPfgskzOC+kNZ07hnyaARzgQ+eM11BahCaLzo3+bpZ1xOuMsBExLgIOntAKBDJ/mZkfgn2KJvpPcTIA7tgI9QcJakstI+/A9blxTf
 Xo5M2y7d
 Cs1QUZBXQ/CVHStHNIlkpXTLR8BZJKgDvTpXNZTlDDyWn82n3xlEqo+pigoKDQEM4X4uexT6YA1u6zT+obGoHOObrfZI/BaXveORtxca8zeZUGTKGvzpSNamUWb3caD73Ew1NS7l3xO8lKV2CKaP0GfLFgikZICGqB53G+UkPfVI3xnArEE6ceQ+JRBt9iXES7J8O/yxoAwPeOD6gTRiBhbEXs+rrh5mHAtulc13LiWynrusZcwmOnvIxlMauT8fZTvC3LHO7qWZbbaUViw0BLyBC6mL3xAPArLv7dVXm9LjqjSL0gUJNKx7KW3rHP5N/mSZ94dtH0dI3CBFkCtKIjtdp6rPxuvQBKAzRUPRh57q2JPV8unBkdeY4BsyliuTH1JNKDP0NXEWEYNuLvRlNfI9VmgXCLGEEo7RiF/8Nt0w2V8F2kgVZapAR0+MYBbmJhJmHjM2/0NK2iIKuzATzeCUJUXWaMFKuuEhc3OSlv4FJy97pWm9CVk3A+bybieqVz1mQIZEH8r8aO27Kc3FA8UZ+SQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/09/2026 19:46, Mike Rapoport wrote:
>> * Does vmalloc() guarantee that non-pageable physical RAM is allocated when
>> it returns?
> It's not pageable in the sense of demand paging. Some architectures lazily
> synchronize vmalloc page tables and this can cause page faults that will
> take care of the page table synchronization.
> 

Thanks for this clarification.

This sounds like a showstopper to me. Immediately after the allocation 
of these buffers, data from the USB device can arrive at 400 MB/s. If 
the data flow is throttled as a result of handling page faults while 
trying to write the data to these buffers, this could lead to an 
overflow in the USB device's own RAM buffers. This is because the USB 
device is an FPGA, where RAM is an expensive resource.

So using vmalloc() may result in a malfunction in the data transport 
where the __get_free_pages() would have been successful. This outweighs 
the benefit of a somewhat higher probability of success in allocating 
very large buffers, and surely the improved aesthetics of the kernel code.

Regards,
    Eli

