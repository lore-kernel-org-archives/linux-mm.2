Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E61CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B378E00A7; Thu,  9 Oct 2025 15:16:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772968E0002; Thu,  9 Oct 2025 15:16:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661068E00A7; Thu,  9 Oct 2025 15:16:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55BFF8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:16:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 145DB5C0F6
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:16:46 +0000 (UTC)
X-FDA: 83979532812.01.9A72EF8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id A067B40013
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:16:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fw1W9psU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760037403; a=rsa-sha256;
	cv=none;
	b=ODrsmQKuMQTX+FTqZwpyALdRPY8q+tgIH4z4cXa8ouy6OlnoBwBI5ANtrxeu6DjHFUtg2W
	ZXRdv85TuORD4hp5SF07lXHT5cuqVFjlCf7z/NTdj2lgS6RfJYtr78or6NuF4ILg4FYRg8
	PRiKoY047+67xrbHw6tVyKTdr5cCxBI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fw1W9psU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760037403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jjq7BLRoYI2nQdmAcFZDfdFEssHTj+qWciljr1C06A=;
	b=QNtBDoaAg6BjhH9jqTDNyJbDG0Tmy+P+zcMS4NGVHPd+Fnr21bK1TWEJCkGR1t2/+8U/3a
	UbbdZ5NuEMhIwSh1s9YzW3HeZg7FcPzbd+68EUXvOFJaYU+ZJBGLswA2LPg0YcvfpPnTpH
	7TqN5jZAD+FmXIq/xpMoojJTPRProzA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760037403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/jjq7BLRoYI2nQdmAcFZDfdFEssHTj+qWciljr1C06A=;
	b=fw1W9psUpzVpMRNInZc959PMwdIIrekEg3j7+u2ChwV/1FfyFY2Dz0jG3bV1XaB3Dr54Zc
	yAwKJwVA7EOk2VEEuf96Jm5EFiqcwdo6JdRjUvui0BM9Z07DHvI0vVK61qJMyW6X9qmkOv
	9lOEoIL9oUFAe1jJ3HByG6tNoIo+Pms=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-acU_uUzTPYyi_z0FdQWgLg-1; Thu, 09 Oct 2025 15:16:41 -0400
X-MC-Unique: acU_uUzTPYyi_z0FdQWgLg-1
X-Mimecast-MFC-AGG-ID: acU_uUzTPYyi_z0FdQWgLg_1760037400
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e4335fa87so8021155e9.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 12:16:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760037400; x=1760642200;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/jjq7BLRoYI2nQdmAcFZDfdFEssHTj+qWciljr1C06A=;
        b=E3BDPf8XHmYLZ5NEkWu1VwheZson30ACKlRMPFGhYfK6Q3xSqZgMg/Dvull/6a238o
         dSoh4O0lkIdJeloeKaUyQNApx4loOohp3NFkv7ESWTSu8+cT1Kf90G1R6sY3f3gElPG2
         IhUjmEwNi+LBcl3D0oBDiIHqeyUUC1YK7MlnTWMBN2NeKBq/eMHVKAYih53sEmWONRDD
         +9lqqa6TXoo9pgbUTDt+7Iz5YkoaLbcn2boWI3EFAYMgQrpHF0ueXejvtm4yUFJTMSaQ
         6sbZRK19MmxqpaxOiPHbNtTY+2wmptalpe4eJVsmEyRUznC2z0g+ocz7PpQlLMGDwwWT
         pBhw==
X-Forwarded-Encrypted: i=1; AJvYcCUKBzp0Ze3Oi11k09dvvpmsgKxZghqHu2cbad95FaiX9p5PzntdREU7I4MkKanWaFIhMI15sO5bYA==@kvack.org
X-Gm-Message-State: AOJu0YwiQ47qricdqGpz4hdgZUuDbTm1BpwTSXs7pxYO9M0WzVvwQt4z
	7eh6jy0O2zVfl3AciXnAjscYwvn08M3ZQVCkxCmj7/Q4xQueYeDLac+9K83udJxbYouGNe1dA1i
	fk3zKAm6EchjCyL4o/tOH6HIof0VG6s4hf36w+ZMRDRI0qteLATG6
X-Gm-Gg: ASbGncv/bezszPJCg6wqx0etI5e55F3Y5rEmvGlW+WkgRd21K8VtzFIWEEJgSroFKdi
	thp7Gc8CcwcE8wmXFsWSLVBBdWhTZNUYOCQRZ4xfMZaqRYEixQ69YORxpm7Un+o8iuDe0ZkYfyz
	wyNB1yLtVT9CaBbaUQl6RJsgA3IUd+WQy3oWIDQs8RqKgqQ95w8aDH4zByrLdC2+ViiDw1uzz6f
	WfzBTnkbWpuT5zA9RrjS2xQpxdF3a5xTHLGh70GX3LztHi5gaOPCddWaskh5qYiE/gb0w3SvQdS
	yKNItq9aQl37GH/6qQnSpX/4Axh3LKPIYqz6lNpsKWUoT0vv1xyjf8SmwiSJO2cLJGTIihlTW/V
	duOch+Px+
X-Received: by 2002:a05:600c:3e87:b0:46e:3d41:6001 with SMTP id 5b1f17b1804b1-46fa9b17df1mr59434175e9.34.1760037400218;
        Thu, 09 Oct 2025 12:16:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHxEViiRN8Lw2h0KvemsqiiXPHU95kQiydslrrD2f9G9rGLUFyRDI7eBLoEqJHlLxcoXRSxgA==
X-Received: by 2002:a05:600c:3e87:b0:46e:3d41:6001 with SMTP id 5b1f17b1804b1-46fa9b17df1mr59433925e9.34.1760037399787;
        Thu, 09 Oct 2025 12:16:39 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5e0a03sm403646f8f.37.2025.10.09.12.16.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 12:16:39 -0700 (PDT)
Message-ID: <abe539bb-375a-43ec-ba36-6d10a35dd85d@redhat.com>
Date: Thu, 9 Oct 2025 21:16:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/8] Fix stale IOTLB entries for kernel address space
To: Dave Hansen <dave.hansen@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jann Horn <jannh@google.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <c04d4c9d-e868-4883-af92-26f142bc84be@intel.com>
 <d3cf3716-98ec-419b-90b7-b91b83599498@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d3cf3716-98ec-419b-90b7-b91b83599498@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rFV_Q4aIaIrguOk5AAbuRjDkZ1FqD8tCX7d_o7K2tqI_1760037400
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A067B40013
X-Stat-Signature: 9whim9yuqd7tw4sqbt5niq6nofrdhqzw
X-HE-Tag: 1760037403-491721
X-HE-Meta: U2FsdGVkX1+g9umrRd2OmPRWTJa7GKO1qvzsH3Jy3G34utB2dLJS66SoMjR7EKwvEvWFDp4wX7Xg0IYTF5XdVeFi8MA4IGn5+MMKSP9amcPnDWt+0cv1D6WI8/goI+iVNvsmGpjAW51r355wAH7DLYv25dYjk414oBPAJTUO1A9/yrVhA8g4ZLf8CLHz/If6mdf5+iqFt56MoyrcgGiojm8X50yAFH6TeZB4FYGz8A3idp68FfIH8SY1yVLaFulPqVNZRY9ehgY2uB6NlWE+YVPvx1pcAMENu29cQHNCmBg4m4IaZq+KfgFxO5chEaVOYD+9H0N7xXPVSu7TUtMhuMhoW8wEOUeBnKjCgUUX3ul7nhM61aG+FUB2J2/MXt65MCe7a8OsNR2LkwqCo9yE4oRAQ58kjaxxfEuPX9JTmg0JeD8O6yd99Ol2OkZBfJefW7SRvVtBiLKtvZpbtRmX1MBOz/Uso/dvFJjbolR/Jva+5tpH+jXDyUVWTMvQZME05M4Vd4hWxLVgehGSAal9jf8cha6IRl5l3kw2BoVTjn4q1rfhk0/wBQ9RW43wGO9Js8eF/AppL7wPRa6HpN6mevW5C14TB9+Sjp1mwsxe7h+c2ad8ySEGPI4N4cMf4RlBcAyPNaf3QTDCwGyf/dk/DAT9emb7h2yY8CwfIRREWFNj8Xi1mfEuj2nJvOQ72GZmDKO3RQhmzYzOGEujpkEGTfAL3X3bTHHTXDoWf4KarDsWZMbpynou3zU5Nl973zYhhPQ1Q3jEbP35y8AinyYcL5egP2rDOjcbrbdcHeaBvc3fb2/PeEcWiYQ5JA8AI8qMRuRKG9ioV1Cq6090t1gzi4rpSOz603FOWM1nc8xzcWGteMAFAU9RW6mHX4RSfobHw0DoVIW9byCnpklYFe+ZLGfnoNOemHScGxQVTraIP9wPSrKKvePKnRdriiDtHMmVa6Y5InqRE4VeIxj6Dyf
 CMb2eTv7
 WRrfpTfvvklu3PqevFdCLrbohMO937owX6F58q8xiNZy3lIl3LfqlBJfPRe0u/klmT1EQtNk/dKqY0aEycthPNIGIGpl2ibrZGyGnCCsdpLZnPifmq+EBmUyUxZ9oXHX3Kn5vOf+1mJTDPz+N18A2NrchwQojtmkCeXTQypt7O25anHVIAZ4T2Ey1soS9dWIwp/2l9DgdQSyqL/BBKdTlKFf27om6HPoNWlcORB7y1gA9HTgS6YC+lnKn0LA+63zTeRiyhNKi9nHBaj2Zv0FFzd8f3LNq85CRSdTX0swnIRW7ANZTYk6Qjw6VMoX03N9/F0Kv9BX1EMszdxEy2n0zeA9EBAIMSXG9/otAd+fQHGHd+ZgWFUlglC54D7GOd2fwQTypYIantf6SvrNZcqFhZKZr/VB6nXGnKL7mPiS3C0v6SQ5P6UIX2VISVhUt4IbxyyhFdGPHsJENlrKxTsu+pd/o+ol6G7CBBkk0UStulmAQTmwN4/DcaztoHCr22OswM987
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 21:42, Dave Hansen wrote:
> I wondered why no mm folks were commenting on this. linux-mm@ was cc'd,
> but the _people_ on cc seem to have been almost all IOMMU and x86 folks.
> so I added a few mm folks...

Thanks. Lately I find myself scanning linux-mm only randomly. So if it's 
not in my inbox, likely I won't realize easily that there is something 
that needs our attention.

Will take a look.

> 
> On 9/25/25 13:24, Dave Hansen wrote:
>> On 9/18/25 22:39, Lu Baolu wrote:
>>> This solution introduces a deferred freeing mechanism for kernel page
>>> table pages, which provides a safe window to notify the IOMMU to
>>> invalidate its caches before the page is reused.
>>
>> I think all the activity has died down and I everyone seems happy enough
>> with how this looks. Right?
>>
>> So is this something we should prod Andrew to take through the mm tree,
>> or is it x86-specific enough it should go through tip?
> 
> Hi Folks! We've got a bug fix here that has impact on x86, mm, and IOMMU
> code. I know I've talked with a few of you about this along the way, but
> it's really thin on mm reviews, probably because mm folks haven't been
> cc'd. Any eyeballs on it would be appreciated!
> 
> It seems like it should _probably_ go through the mm tree, although I'm
> happy to send it through tip if folks disagree.
> 
> Diffstat for reference:
> 
>   arch/x86/Kconfig              |  1 +
>   arch/x86/mm/init_64.c         |  2 +-
>   arch/x86/mm/pat/set_memory.c  |  2 +-
>   arch/x86/mm/pgtable.c         | 12 ++++-----
>   drivers/iommu/iommu-sva.c     | 29 +++++++++++++++++++++-
>   include/asm-generic/pgalloc.h | 18 ++++++++++++++
>   include/linux/iommu.h         |  4 +++
>   include/linux/mm.h            | 24 +++++++++++++++---
>   include/linux/page-flags.h    | 46 +++++++++++++++++++++++++++++++++++
>   mm/Kconfig                    |  3 +++
>   mm/pgtable-generic.c          | 39 +++++++++++++++++++++++++++++
>   11 files changed, 168 insertions(+), 12 deletions(-)
> 


-- 
Cheers

David / dhildenb


