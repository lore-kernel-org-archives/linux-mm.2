Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF7E6CCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 09:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E96F8E0005; Tue, 30 Sep 2025 05:51:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 399358E0002; Tue, 30 Sep 2025 05:51:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260CE8E0005; Tue, 30 Sep 2025 05:51:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F7CA8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:51:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC27111AA66
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:51:50 +0000 (UTC)
X-FDA: 83945449980.15.792C2AA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5731B140007
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:51:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PLPh+9sz;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759225908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3c9XOi7tDlReMrDwAkgMkDY9WG67hlQrjqzpE4Wrfqs=;
	b=sA3McGP3AR5HBWYbD9XVH5qMIh04OcBYDsX7tGDix/PmpphasjZA1F84Wza8u8DEycGZoN
	WD/K4SdQIzVhxNi4TwdGHJQzHEANQwCKRWChmalKU1U/pTpKkRF9xEVwAW88DPwkR12V1V
	/cVoIeJdOjFED+RdabIjlBSixjFpmLQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759225908; a=rsa-sha256;
	cv=none;
	b=Q4quGQP4hQ9nWOLmWGlMSQj74IxzKEkSASwTVzY5e2S1oEOORMhEu7QVmaNRDw5X8hyPCI
	D0WORred/iSdJLE0itWEyvyywGap+E8dkUp6Cm9RC7sl0HNS+mMznlKUcg31yU01FLilEG
	WTrwqclqAH71BhHHybM1O+d1weOpmuE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PLPh+9sz;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759225907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3c9XOi7tDlReMrDwAkgMkDY9WG67hlQrjqzpE4Wrfqs=;
	b=PLPh+9sz9mTXc07JQX7/CBfUUxX4CeKrrVIYZeXqoOglZxeEBeWfAkGo1CSBYtbLNaOyjK
	Pp5BtuUH6yHjYTd1w1uKhSOPesS9GySYBDnjGModx5awpWih259qLhWnDrKOHJzsGlzf2X
	51g6OiQBIGbo/WZtifeIDOO0HWqK6eE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-BwMJY5DBOB-dAG298Yznfg-1; Tue, 30 Sep 2025 05:51:46 -0400
X-MC-Unique: BwMJY5DBOB-dAG298Yznfg-1
X-Mimecast-MFC-AGG-ID: BwMJY5DBOB-dAG298Yznfg_1759225905
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso3194347f8f.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:51:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759225905; x=1759830705;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3c9XOi7tDlReMrDwAkgMkDY9WG67hlQrjqzpE4Wrfqs=;
        b=cgwPdrg4v2Gta8TCi7r0eLT8AzXqE2KzDPBm5nolB7C/ixR+5iPK3Vrr9vHd9zDlMQ
         sun7KDyc9rlmMdhrTcGU6VPa/kRaA49fU6nEosmDiTzGOCON6pl2X/TJsexQQbu9W3Ts
         lp1AjTKT7lSKzHAzY62plmO4esYOp3Jc+or30FYxxQPtdgm5GDWBMjWxO9e0ioHcRZ5v
         9qdByVSul0UvQQy8NbazGPV4F0Bjd42MteCS5qUgnHJumAQLlivdt/Oe2OB0gcjJ0uVL
         cACwm8Y2eoiNnOSdZnVk7cZErUvai+wx3VIhVWj33LrNs5Vg7STAzYoC1ZSTPCTxBtRg
         HLGA==
X-Forwarded-Encrypted: i=1; AJvYcCVMEyVQGt/rWfOYg7UgXM37dFnK+J0Otb/ai7RBNSM9O91C236+UG2++SYCmRP3Qjsb49yplWBoFg==@kvack.org
X-Gm-Message-State: AOJu0YzVVJJl3tpulzIyuQI/4WCS0EeG+aKKcRu9DwcpXDnsNGedL1kf
	+ZMD98CYwHZqNiT92bfMWgqZvY5niQmVyVyW0gwtoM49zbUqkDlxj2MaZ9pEGSAtagUsooeOzyY
	C5AX/OU4EUp/mG7XNFmzJ1+/BkNBkqXRgh9a0teNeb6HuavJisDsQ
X-Gm-Gg: ASbGncubJ6Nd4CM6MiAcc3G9LY3Nkh/beNpp7qmtdaNd2PMl4GlDeq0oL6x4uYq8oJ0
	EV7IWZzYr1TmdcuBvcF7tjA1gZjXj2UyDKygWDHItDLsE9YUyBVPyjUeV8eLxPa4qSdhfWYff/Q
	FMrzKkvd3wcwttHdoWvQ+fOIwis0nWQEulfTLbAFC1Do5gcKhnuJdYZBuDOEvjlUz9TP+ob5hmH
	hozTe4mpnPfRkbp+1uW0rpeJwpAUUaiSGoiF64eLIgQT/flxbachMHuTVCLkEf1CrxDPw7xA02J
	kwUj42f88xDUqvIUx2cU84wXG2AJ8hVQo5h0/P2akpRvxj5r6bdGdGIlOSvNrjmyUtsWXj8ZmHy
	ntSikU5Xv
X-Received: by 2002:a05:6000:240c:b0:3e7:68b2:c556 with SMTP id ffacd0b85a97d-40e46ad0110mr18214278f8f.26.1759225905068;
        Tue, 30 Sep 2025 02:51:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8L0Ol2EiM+AbDlbohqCAI1G5Tu/oLcjBfYdO2UrvC9G2OHhzANDR+0hlm9krhZmp2YY9EjA==
X-Received: by 2002:a05:6000:240c:b0:3e7:68b2:c556 with SMTP id ffacd0b85a97d-40e46ad0110mr18214248f8f.26.1759225904672;
        Tue, 30 Sep 2025 02:51:44 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5603365sm22602468f8f.37.2025.09.30.02.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 02:51:44 -0700 (PDT)
Message-ID: <3cf7c02e-d77f-48cd-bd03-69d71f8cf92b@redhat.com>
Date: Tue, 30 Sep 2025 11:51:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 12/16] arm: mm: define clear_user_highpages()
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-13-ankur.a.arora@oracle.com>
 <d2dca02c-ec5a-4b3d-92fe-2b3a3614b5df@redhat.com> <87jz1obyd7.fsf@oracle.com>
 <d03dd7ab-5237-4de6-8872-a8ae2e9b7c5d@redhat.com> <87segb9i9a.fsf@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <87segb9i9a.fsf@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8CjP4Y-s8dhMeuHl9xXosUJIi1S7us-2gB5Nqw9jnx0_1759225905
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: an3nre1ajjrg6yzkebijjgfjisuebprg
X-Rspam-User: 
X-Rspamd-Queue-Id: 5731B140007
X-Rspamd-Server: rspam10
X-HE-Tag: 1759225908-765914
X-HE-Meta: U2FsdGVkX1/jAQHhTM2MRK+T0d6NQ8Qn+xv2ZY2Pj2VVCwpsgC3PKFppUCxojjszjwaowTA6llLYghp7ruv+5yD018DFgOiKkB9u0cKD9M87zq7S5xicYbDqAp42ND5fDetvRDwa90ayiJCjeITDlJJAT5USoUbzFx1k5OI+zVuZPwlgePSvuQwq/nAmbryLtz7hPhlH1dEVE8gY8R4KVgqho0+EVpme/eualZ/uU7Kbd4CM6Y1l6j9HisPSEJ+sUxdW9L1MlngRv4F8en/YhPVnaIm7Yz/YtioM/FGvpYpKs34gGH70XntVlqHvPC5j/c83G7uOB3C/Zhj5QWX0IpdOXG7ex05lPTPeOnetlSVBjCE6gICAub+9dScMRM0u1Y4KvfKMc2KBJaChFG4MzFym/m/yylUfCeb08OstYcs6qlDNARZQPZfywqPhUKrTasKskcyEPt7IwOwajY+8i0Kzzmgkvt1EJzCKBSksIOUGWFGmajt42xSEJWTDavm+ckb9S0Mrd/GsZpzaF39EFW1Q7jROl9FMAu6JlhXHFBHUvrGhNdeogdIP1cYtBP2SPvd1kkx+FtOLe/+7++IgMt3tMdKKhI2WCIPudV9Z8aws83HxCndUJdT/9VmEYa97vD/BNFJrk1RZkZdCSDXRxQ8Y5jP9r2TLTSa7ppIHZspqLA721HXZERLGSNApiyC7nq4oItpbyGqGEled3m7g+J1jb7eHnbqaPKmv5Ru9FNbOq/4H6Bk5DJBHZd6BTVot1N9RT/NJ8PAyXmy/r6+xr8azMklqq0ES5t0Z5rgTs2LwS/pqGox6BsLMbuyt2oXMTdvPBZxDMgd3+0Mv9FvTrwogfC2rC3DgJ2PBQL5ULnnk4zj/dFzA6ID7vfdtUt4mV0d9coOQhyTejxvtkfToPEvIrY5cqN2Pu9hoJ2Hx8Q6Wd3HY6e7qnP92EYYR+jeMNQjHDCnaC3BXB7xjVuH
 r0upUgjn
 wNllPjY77KOS3IP1wDV96UzKGI4MZ9e3MJDVMY1OwB+E6vGVERrAYD9TJ9j82XT+QuVLt9QlJALNlM+42ifO42TZcAKUOA0ivhviiuhQgJCsoa+lUWgls/e2VDJUaSkRs0BFkp8o0njM7JXe3p87QUd9HrUXazhJvRVah0hGaIA0pJxQRciBBrwg0WLT6oHl+JcrasREtAcjhu7subsWdZVW/l6y1vGyFoeOIFmLfBr0ZAauWAwiebdiolWb42c27bgbIfhcOsBM18afDKsbur9XsTbtiILqPzySezoEgi5xGR6b7DkIzkzB/lnNMxdw0h6r6z7BgxcRnfh4ZYPsVRhHraUcQr7zZm5lZfC59moK3eW0slPMUIbcQ5wi0+MdIRACzHbuyRRBvrrsvL27LopBzv32132mROuyKpu1RpLAWmebVvTXMp/lPX3337MBVgE2AbVF3bYBOqWXrFTjfoWVhPHZdlzAv8w59
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>> assumes one of the following:
>>>     1. clear_user_highpages is defined by the architecture or,
>>>     2. HIGHMEM => arch defines clear_user_highpage or clear_user_page
>>>     3. !HIGHMEM => arch defines clear_user_pages or clear_user_page
>>> Case 2 is fine, since ARM has clear_user_highpage().
>>> Case 3 runs into a problem since ARM doesn't have clear_user_pages()
>>> or clear_user_page() (it does have the second, but only with !CONFIG_MMU).
>>
>> I think we should look into having a generic fallback version in common code
>> instead for that case, and not require the arch to implement such a loop around
>> clear_user_highpage().
> 
> So, as you suggested, I moved clear_user_pages() to mm/utils.c and
> conditioned it on clear_user_page() also existing.
> 
>    #if defined(clear_user_page) && !defined(clear_user_pages)
>    void clear_user_pages(void *addr, unsigned long vaddr, struct page *page,
>                          unsigned int npages) {
>                        ...
>    }
>    #endif
> 
> That fixed this issue as well since there's no more bogus reference to
> clear_user_page().

I'll have to see the resulting code to comment on details, but if we can handle it in
common code, all good.

> 
> Are there cases in which (TRANSPARENT_HUGEPAGE || HUGETLB) might be enabled
> on ARM?

Arm has

arch/arm/Kconfig:       select HAVE_ARCH_TRANSPARENT_HUGEPAGE if ARM_LPAE

and supports hugetlb. So yes on both.

-- 
Cheers

David / dhildenb


