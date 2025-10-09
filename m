Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE00DCCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36BFA8E00AD; Thu,  9 Oct 2025 15:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5F98E0002; Thu,  9 Oct 2025 15:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD308E00AD; Thu,  9 Oct 2025 15:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0720A8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:27:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BCCDD46986
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:27:05 +0000 (UTC)
X-FDA: 83979558810.06.CA7A7AB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 717854000B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:27:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CXa4JfRZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760038023; a=rsa-sha256;
	cv=none;
	b=ofobCAhr44hoYP7zTxYsV4jCIjg9Tigjr0NqF6VFWa6aOK+l+ao6UUPfSRRYyn1hARxTy5
	QfsCUdPXMZIyc1Fgm5LaCbXQw3+3hw70hihRJAS+El81g4rol6tWkXfblUu/2KttRc8+9Z
	DmEUmeKeB9c8R6eHMzH7VT4XT7cnxNw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CXa4JfRZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760038023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kEnK6fpozBhIAiBgrIzZuihFNuo5JowklnBGljzyNCw=;
	b=6f89HxKhRGs7M7fUjsxR+5tk4fQl1SxEaQhHCFF8OsL2eLUnDvjJsyGhetFO3TNLIqaDfW
	qBRRMYdUREU2zmbttUcpzCWDkSHRqhCkPjGQlzrZhkwmb7ppX0HjAkFYG1G8k29kEweoCG
	KAYc5KDZmKfM4uLv9hM8O7/J89eWKr0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760038022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kEnK6fpozBhIAiBgrIzZuihFNuo5JowklnBGljzyNCw=;
	b=CXa4JfRZkd54yUBOfaO4EH69gkuuhMl68MpClY9+82e3vBm8G3Qt8EpGG8U/5gyIx1Msrq
	Rpijl7s3rBohW26obt+qdirFQSuTbGY2vkXqesSDzqeV8Y5tehA8uzZRGIGwgMcY8cR/oz
	k5GE4H40vMLDrkmb/XN1UeXUbsUxWKA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-TiKzaY32Om-2XlD8esDqeg-1; Thu, 09 Oct 2025 15:27:01 -0400
X-MC-Unique: TiKzaY32Om-2XlD8esDqeg-1
X-Mimecast-MFC-AGG-ID: TiKzaY32Om-2XlD8esDqeg_1760038020
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e4335fa87so8067855e9.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 12:27:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760038020; x=1760642820;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kEnK6fpozBhIAiBgrIzZuihFNuo5JowklnBGljzyNCw=;
        b=Zh+ehgyWKJDiArdozgulolIBJLdhLZ69jJ/Wyz5uYHKklX/dna9oTxPzQhHQiz089r
         CPihWcHn9tKrMPJDOV0EQjiNywVSXX3kEhYeMQtR13cTmvF0AR4Gl9S0IQUlzHre0ISk
         8bvSAWELLK/Hp19wryUBuwT12NbKCoz3FDJn0P8C+wzx/oY3dQw8UWAssk4e/IpWdFty
         wRr5lYRW9PSkKzpitXFIXebyyi+jVUDnywOoDo3+I7ad+UXn7nTNDo5sPn4qAhCam822
         nK62m8cl51QQZh1F2a5kpTNwia6RXfr+yP4S7yyWmGuW879k1WAg5l3RtQs0X8gOUBna
         pKdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwym67IMK4guyN9vF0hGZLZCGznBJCc8E3BcUXM0cLY4hu6cMiT3TtTTlTDnUyVFFCS4C9HmhxIg==@kvack.org
X-Gm-Message-State: AOJu0YwsjoNOtBrUHqRsGwh5hf2BIEelpfUwuUk3IAGIA27s9cblpOQZ
	RCVh0nmqvBJsPnIhYlvltwY+a24Rglsdv98Q1CDLh7NJez5rvo+Y+7hXKfa8bM3+d0OWCFovQSJ
	UDmCvtYqgsHJX4OvarEE9IBMNIV/KMl1tFOkH70EDCjMbrzQZupjS
X-Gm-Gg: ASbGncvXMyzstu8KEPS35gIf5Ts4QVmrQ1Sq8BhcqQ+0Z4ILaVZ++5KlQZMZWYjakhl
	LZNq15gE9g+zD4OMd+X+WA5I0ZGhh+yazUntp+7PcYve2g0WAopblJGFWt5p5bH5MKYYNa+LVh6
	jJtZI+hXRgx0qPNwEmB+MUqXUgybOnfydP0GujunA93B5Tgqjx4Ez9bj9hyUjlGvLsWi+zN9Dr5
	LxNm0AwcPB4Km1fWCloHwhlnGJQHHOrOtg8WLod3+KyFSO/iD/MFy5l+VBr0Kc0VbPfNpPgdD03
	kaKMUvLxyEvZRxtGR8n1cLuTjOm0jovVl8/3QdBpO9t0q2Q1Zb3IAoaN44JKyMWVduA/LpqbPG1
	77zXvuObX
X-Received: by 2002:a05:600c:3d87:b0:45b:7d77:b592 with SMTP id 5b1f17b1804b1-46fa9a9ede8mr61532975e9.12.1760038020403;
        Thu, 09 Oct 2025 12:27:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHq4yODAxz2pcaMx7a04UaAUODwZat3HOAUOtZRv5icQqy/NoE4KlujCgSLikJjIvHu8XTYew==
X-Received: by 2002:a05:600c:3d87:b0:45b:7d77:b592 with SMTP id 5b1f17b1804b1-46fa9a9ede8mr61532735e9.12.1760038019986;
        Thu, 09 Oct 2025 12:26:59 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb482ba41sm12434105e9.4.2025.10.09.12.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 12:26:59 -0700 (PDT)
Message-ID: <94851383-7496-4e98-acfb-a16cbfe7523b@redhat.com>
Date: Thu, 9 Oct 2025 21:26:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/8] x86/mm: Use pagetable_free()
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>,
 Alistair Popple <apopple@nvidia.com>, Peter Zijlstra <peterz@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-6-baolu.lu@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250919054007.472493-6-baolu.lu@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NLO0TGoDgXHIB8iHch8-mNN6dEv4hQx31bBDrKbYEWA_1760038020
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q6uhcqndzrge7xyjwhs9csmj1is4i59d
X-Rspamd-Queue-Id: 717854000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760038023-190004
X-HE-Meta: U2FsdGVkX1/6iWfFwVnCTH9UokNeXMtaPzfYNuL4U8qak+K/Zoj7KAboO5kTqHA7io0xyQd6+BRBA6Hrac4NakCQg2KekUSlvnt5DnnEzJxPAnOltPtaqOkpJ7L8nl8gsxvy5aqGRBdsKP/a4q9eqlk0ppRtNxqu4zAQiUvyst2XaFcHqcM0KPZZKC7ONSRLMFt0l9dZIsMewyuT1SAX35iNGfRUdpqCr/hebzR/dyJ+i7cWGiLRy9s+DVKFipUWBDwWkRjryc5nV6QOadsR/K5kU2OV40XV1K5VqFeo5mTC1tU1oChHHuZhFBhrmxzjNQSgcfrsFXCQrw0Bvn3P06gavNkjN3O2LqnxsyPMNjwh24SHxxOxQePKD5UhW+34g1g0SPH39IBrlElbCIQGDO8F2cTsr3H8iOxSmU0VVn0wiFwx83dPiSYOLnLlC8rW/FlwRKbPR439JFI5MBE/8bK3x9+iTSBytnIKIY9QNAWlyB6L6WrzWu1hIkosmXkVQhl8Q2/9VO+AXpMn3YXz9+cG1ZCOQjRdw3b4t6UeTGA4eVsSbNOyEsFVfig1LKRqktLzjpL1LMD5OvfDESuyTydG2FTr3aWmgHjbUI1Iswky99K6gl5OcM15uOVgtRg9NxZ/wnwNdrAa9VfmPC/dH+LnyanFodCShnXK3VU4cYsY28gfqOXh2e0uTUUnINe/Ed1RnGwVBRHXnsDTxK7B316AaSa8wdEC24Jf86tHSkZUbMyd8fo8OEM9qJsDFTHZ74U/G6r82jz9+U4emCLFkaCWXb393+VDs1EQuSyewSbIHp3AH0Uci3oywoUWj82LSglx2lpwJU6e1tRXVlYm/Y0JMBGuodmGjZN97+2WnvJSt+TUhI007yhO4eFIkouTenr1TG3nGxhbKl0HVelmYb/gWlIIOrtzNee7rvedXssED4OhcSlPditAP9E+d+OvUBmI31AIIlJyRUOP8D/
 SpDD6SJp
 M8B8wY+BwfjqBf+oghE3kqSKD2OZ9IHY7IOdz4CQFiVw/3JtufEKH1JsKAtlZfKrrHyPeLAquUiC2Z43mRqZ0qeO/CBhDNZHcsG3SD0MIijYwPNOmmDi8IRb7bT9+Bi6bABsRhy6+NZ2GdnxF/LjCfgofoqbi8tG+c1cb+vbNH8FhtfUk9pfno/4EIyGTghqbXUxi09RdUp/9ZCwegVCx4chJBOQOZv7MmPki92nYfLyh3JMF+ctB+G6kRdy8tU7W/lhSgFrVRPThh/OPz0f9iahOojtxCK6G9+qU942+Fm6r1HYlTSfAJPxCtr/1e0OlDp9Ib5Taf/A/cbkvLBVLFRaNUIedRNizmRGGcaCUtHm1MaaBNfVDEzbTFUMKJGbOcs+fWU6N/SuTyRVNdZY/1NPvuUAggoE13C1XLvQZdKjZLwcdIE9BaxTrU0AzMxNRXRoPrXCSDfa1j6VLISdJGr3Y0BY9Q2QsSaEJDSR3OX366QusCUQUEUpyVdpb4BwrBXWuPKgzpWzPt0O0hbffazNo1wcAbzvIzNctSlkQnCMhn/yzRA0Mg412cKubChbABjOqlzTY4K4V38jDiekD5U6r/42awsBMdQDfbQZ5sJ5KRApMVT+pv5BxQ/zIfx4Y4QLI92+newzKwXBbIatx10oSRfkf25B0OmFx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.09.25 07:40, Lu Baolu wrote:
> The kernel's memory management subsystem provides a dedicated interface,
> pagetable_free(), for freeing page table pages. Updates two call sites to
> use pagetable_free() instead of the lower-level __free_page() or
> free_pages(). This improves code consistency and clarity, and ensures the
> correct freeing mechanism is used.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


