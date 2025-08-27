Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1B4ACA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0234C6B0280; Wed, 27 Aug 2025 07:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0FAD6B0282; Wed, 27 Aug 2025 07:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD75F6B0283; Wed, 27 Aug 2025 07:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C921A6B0280
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:56:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 474D4139D92
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:56:19 +0000 (UTC)
X-FDA: 83822384478.28.416A4A6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 971A640003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:56:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wx5o7ttt;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756295776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UcP+MKIMKTIXme29nP4iQa3HplkH4GbIfVhPmf/w8b4=;
	b=72I03VDzLFNxz4n4SvQOHXUdfFyjKzrc79yZZS/0ivd8VBuzf11wWlLQpnH9+ekOB+1F1u
	v6hfgdXDauZwsx73IKRyXtU8hvsWnJ+4hcnFUjTzhsnu1QH+qvTEw4h6kxRzdKuzo/GqMt
	zY24OGRG0e4vznEWVufa2ShYcWxRetQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756295776; a=rsa-sha256;
	cv=none;
	b=aEE0R3H/DH9NkWKZ832jWTlwR01rNvhduQ0bhp8s+T4liZFYKceF9gnshKG+3BH4TD6hj1
	lIvWx42a/sZqbiVGooFF9AD3VXGJH/2AJTafZBSMZqoFdnVL28hpYqXuKs6WUSMIDhek+X
	Xeb1OvRHGQGBHGPjPkD/pgJhThEFbkE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wx5o7ttt;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756295776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UcP+MKIMKTIXme29nP4iQa3HplkH4GbIfVhPmf/w8b4=;
	b=Wx5o7ttt0tnBE5qCgHCWUMS3bD3hOqWmkbUcayrQlqqcsFHXB/3l/wNT8rUELLpbEXSank
	NnOEikjS2mJ8HML4mPJfzMV4WE4+yAJYw56tacBL8cx9CXmKJWs/cbrE44H3w2J2EltnkJ
	snn4+gwogqdUxi5WAzqMn7gq6xTz/lo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-531-oVeUBxriNd-_njYfKEaclQ-1; Wed, 27 Aug 2025 07:56:14 -0400
X-MC-Unique: oVeUBxriNd-_njYfKEaclQ-1
X-Mimecast-MFC-AGG-ID: oVeUBxriNd-_njYfKEaclQ_1756295774
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-70ddbb816f3so12655036d6.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:56:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756295774; x=1756900574;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UcP+MKIMKTIXme29nP4iQa3HplkH4GbIfVhPmf/w8b4=;
        b=oY9AsuhSsG5I+9DW+jJAP+W+0DSNvsHd/Ja5qdEXSD75yogwUHSK+FQZqAmZfFBY9o
         z6y2PNCA5k+5GbQzV7OK4KZoUzYe4QmxbJ+hXZtmFr4LuYcUmDAlYImDXnJgy56HVLpm
         hzS9voFOasLdAfLd3cbw9NOhY54gKRqQ2WxQaPi2R0nxPehmK9ySw4QcmTsG5pLbtS53
         XOEpPbdaqQlMwNtQopUvTz8kza5pGO24x0Y7L1ImyhnJKSR7M4gQ014qfYiyxXDDzbTK
         bXlTRLEDUUl0E8nJG5yYr3rpLQhdxhwpnCLgB7XMbRdMF18Y3Mfk78zNyiadepzX6fcr
         +X5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVOyQ3U6PAAAmKRlG3rualqmeFFRrdUHTAP3OW6ZkpjvkTpqFYO7yBf4Ck87yk27lMTQF9JWAuGWQ==@kvack.org
X-Gm-Message-State: AOJu0YwCNn4XGv7lYzDaEwf5FLN50klM2YrXzELcQlZDJHW5jL8BO0bi
	EbzXIrja023rA+33XElGcTL9PqM9OAtDQDIHOHieWtDfTx+jRBEyxUbS5+xEI0GonDfkuSJ0cWT
	9Q4XYbZH7ae8ftHyDmEDQjvoSq51N7gQCaSeY2RrbOuJhxQspndpR
X-Gm-Gg: ASbGncvHaX7JrN3D0a1Dda4mUoQ1PHNGIbg+yTmiAFDXvFptcKjOsyFysb48JGt42pk
	sa9zepSZZEB76jm0FsT5IVucXJ++J9QeBXDY14I17006dkZyz1FdrQ78xYTelAQoUnDMZt8hzpQ
	/CzJ4ZysW71CUoXqfQrRKHqZoRYjFRxVuq0Fe0jWc47nlH0CgXZOLYkgXeSl0aZhdfZ2rz2lZZp
	rcu+Dmky5xJxGQDUoE+51VDACOKjVCnk9fzUm6Vykl33Qdqen0P+nARGa0YuQe+uIvKVcuqK5jB
	wYmF2GnGVIcv7TjVx5932t5Yrptqx6VDx0wXF3tHALU+ceMT5LNAyEF4jGKkzg==
X-Received: by 2002:a05:6214:1d09:b0:70d:b0d3:e50c with SMTP id 6a1803df08f44-70db0d3f0b8mr164309666d6.3.1756295774001;
        Wed, 27 Aug 2025 04:56:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGP+7/f9Dza6Dboh0+crUGjlYh2k6wyTyltwaqvnIJ5dLoNHOMhcL4Qv2lqiKTxRR93kuSh9A==
X-Received: by 2002:a05:6214:1d09:b0:70d:b0d3:e50c with SMTP id 6a1803df08f44-70db0d3f0b8mr164309146d6.3.1756295773424;
        Wed, 27 Aug 2025 04:56:13 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70da717df65sm81671596d6.30.2025.08.27.04.56.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 04:56:12 -0700 (PDT)
Message-ID: <11a5d391-3a13-4376-98f1-34b529d3c583@redhat.com>
Date: Wed, 27 Aug 2025 13:56:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] huge_mm.h: is_huge_zero_folio(NULL) should return
 false
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, shikemeng@huaweicloud.com, kasong@tencent.com,
 nphamcs@gmail.com, bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250826231626.218675-1-max.kellermann@ionos.com>
 <20250826185515.7fbe1821713195b170ac1b31@linux-foundation.org>
 <CAKPOu+9wz9g0VuYDPiNDYdaGG-gdK86h1gGSCmVPsC2a5f-GPA@mail.gmail.com>
 <e5783c3d-7eeb-41d9-9fe7-730155f9bf17@redhat.com>
 <CAKPOu+_8_gfko=Sh-YKpbgcMy0aJB=m9yrC5JJKEZm=yeYPOgA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+_8_gfko=Sh-YKpbgcMy0aJB=m9yrC5JJKEZm=yeYPOgA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8AD0uAJX03X7bT5EMa0nGNB6HJTk33m8byR-HjxtxBI_1756295774
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 971A640003
X-Stat-Signature: tkkems9omq9dhc5xj66whf3ud63biwkg
X-HE-Tag: 1756295776-327939
X-HE-Meta: U2FsdGVkX18/h1TjeZNvpEwKUxsMV1QxmRfX3f66Vm3YzdjwGjBrE45VRm49319lUn2ETe7UYE/tJ4CXXDv3OmFLqlo2QDWdZm4RD6V7D9rTXmPtWgvf58eH9UVORTobfEUy14wInQXQAagH493YoMJxdijYNL3n0q530z4RFspEsgYMTkDGzQDcblJIxUWwu27EHbHbr+SVQn1RDqPmFMswyhjXxpE/VRP/MRNSjfVWegDIoys6yYJ0iYALJNo4SPeFfvdBN4I7UwLwRxRM2J5iYxnAryEEK98QWRSuHbXbeHJ6rF7FMFJe1mHDhZU/y83C6ApeUipzDDS9usxbw4R9/aOxx50U4gxekZ7dZ2st81VPe39rfahTipmdJ3QlcrkdS0/BAAQDcZg5Dy8owwmNlYHFBmHTUoXPFMwIrNAnB15t5SQd6Mq4U9vwbZh9CVPCA2Gir1z3Y1NqB/djCDncwzRI8YcH2wgaR8ck9HGotXKtQ3cgvIH82UoLoMTvsw/shuD/AuExpb+jSJTdROXaqeJyNLW4gWxhf/ZLN7zg0/WjMjOdcEXJ5lqoe4vcSzg4ICE+wEOPgj8307oe+vxhJWOqKK524FeYGLNzoVbY2OuEgBKYiJzdN8WoJro/IND6YvhIBdoQf2870T6RxrfCuglMiph3cJSfnWzY6o350Cv2g1WIueDvnZrd+GlPZmspYQx1MpL3d0XtdSfdCmk/dQ9s8yFR4GKTme2clrvxaYxsmW4XO3GzImpmO8KgmMrbrRIpnMjqzr9yQA+EBmXyZKhcdikB6ndd2kvi3tPGgkH65a5A7HsdNwtA70/jfWOzoZtggGRFD+rwg5tVbSDm0K98efPcEj93iaC57fK2dyhrlhgWDCbiRcP4hZhtqLFZrGGPOW4Sw4J5dAzyxoOCcMOEI3lYtj4Kgw2s4qrmgR7go7TwPN+AqKhVN6WQtAr0XC0cDjyGKAPKgER
 R/nvJpt6
 9/VTbOiGmX+kXcIcopAkKX5/UwK5r1JL+rzXffvVVLDaC7WtiZ3yNfNnEc/GWEMDAZH5GgKIYHg4sKpCSM9y9i3kUdnN+Gzyi0mFoqQRzc8DPLVonD+mDBlyT0unyd8uhoE+PNPOESICiejyGFnr3UO+WkFeZlQ8HG4PWswU9e6XzPMJwvvbqXD7Vl9bE/pNgVJFhLBw+NjMh5aIGV2ooMFzJgOw1VmiQ4G/4K8x8w/nNxB7P5eGxtgQmVvddW4YExLcXRZ57hQduIMzy3xrlH8SdxqvkiLfnpuoICpITCO9JxSMx9xXqyFdtRliShVbF3E13rIpVqhiNW5GBRRgJgG2Xde4GtMLV+Kp9IealzhoIeLxSnTZ5QdYE52i0sZ7CsaAyDUBm8xJFu0nL4yIeDdYRB/p6Og9wzKp80kCkrk5VhEfhg/+PKRKKkTv47B/4bcRgZOxoV+Tpr4hEvKeabsVEFJIpmRw4AxpS4Fe5VPkrGVFYkF9zKLVI3etZVoUX9JNjsG+OjAEBg9pz0EjBACoWACE0fJk6u3XH4CcybytWvXz1KHkLsvlkFNlF36FJB0CANY+y9CN6GRt6RspM7EmWgfiX4Fb7RGes
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 12:13, Max Kellermann wrote:
> On Wed, Aug 27, 2025 at 11:36 AM David Hildenbrand <david@redhat.com> wrote:
>> Why should it be allowed to pass in garbage (folio == NULL) into a
>> function that operates on valid folios?
> 
> This patch isn't about the function parameter but about the global
> variable being NULL.
> (Don't mix up with my other patch.)

Huh?

"Calling is_huge_zero_folio(NULL) should not be legal - it makes no
sense, and a different (theoretical) implementation may dereference
the pointer."

And then

"But currently, lacking any explicit documentation, this
call is legal."

No. It isn't. It never was.

-- 
Cheers

David / dhildenb


