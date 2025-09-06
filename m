Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C0ACCA101C
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 07:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD0D8E000A; Sat,  6 Sep 2025 03:01:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ADC58E0009; Sat,  6 Sep 2025 03:01:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44EB28E000A; Sat,  6 Sep 2025 03:01:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30FDF8E0009
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 03:01:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03F74C047D
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 07:01:05 +0000 (UTC)
X-FDA: 83857928532.23.0C3F87A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 92654140004
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 07:01:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="jCUpZ/9Y";
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757142063; a=rsa-sha256;
	cv=none;
	b=c7+kF6mfM2GY9wyhT2vniNLLuamLndOMmj+SG8nrc1gaC/YEt6MNsUFhl2NVOn7GrwAU1c
	3nGcCX5wphPLPC2o0vEVLCLbo+kmw+mOLhiXjyh06wtpyh2n450vCohemFyrEKrnlVmSlI
	Lq0DEUrTDHUfZeTW+2EDkV3ityfZu7g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="jCUpZ/9Y";
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757142063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2JJG+ZfsCIb5mNyWFksWhvinuGju8fueKzmBULEe5U=;
	b=h5tNSybLr7gFuaAbTkQP8YstttFyLeIJFSoP9XIXMCnVnfhY+hMfx8UlklMQZX/NoDirak
	HtIek3DCAl6Pv2dFK/IGjB1uRpzH0pVAGjaj9KJHNTnIST3r/isWGpNACn48i2Vjuf8m5G
	aQHQJxxTUB7W4hKws3HlduTQQlQi+Xg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757142063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T2JJG+ZfsCIb5mNyWFksWhvinuGju8fueKzmBULEe5U=;
	b=jCUpZ/9YjuClodJapBo8VHvzu+0F6vY/hu+S6FMpBv+Hbfs7K3TSLQYfliicneDZtmlK0s
	GxeC3c9DbZ6VCl1NB7yETsKa76QK9dFbm6hBO8y205B1QU/dTVB6Vu/NrBj9IS7zZycdlL
	+E/nlslgyDi84L1fvjC1qYFpdvpPUu0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-W5VPXUpZNL6mwhlae4IOwg-1; Sat, 06 Sep 2025 03:00:59 -0400
X-MC-Unique: W5VPXUpZNL6mwhlae4IOwg-1
X-Mimecast-MFC-AGG-ID: W5VPXUpZNL6mwhlae4IOwg_1757142058
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3db89e4f443so1798535f8f.1
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 00:00:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757142058; x=1757746858;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T2JJG+ZfsCIb5mNyWFksWhvinuGju8fueKzmBULEe5U=;
        b=X2o6EXBfGUqh7DYyDYMopO8QYgkpuuVteNId5RLTrch6w8SM4midpA1aZgzjIRrpqi
         yG/K9fYNY0Mx/yqvdin8lcpPiMg78BdEtXsnfdn4baNxRv4ptiE32rnZR/RfpUqM1Owk
         W5gyAFbsV909aGSBBC9gOH+xDXV9uHp1F8fA4COvwtlg7bXrHUf7tS5thECPqKhPdv6B
         QVRQcUAEybX01+8HBYpiLr002HDd9lIjoZc90TSgUp2S7Yu2A78Emxv/TBQThJuk+OWx
         rgiHCVLJDcydgRjk+023At+0f6N3vNO2aekWV1ImpcY7DHM0jrAVTSGJpp4LosF/Dy6p
         +zYw==
X-Forwarded-Encrypted: i=1; AJvYcCVJ87ybPb3O9qLTUevzJYe40e+VnF90+JSeG5FK8Xff4iP29MAgsXjxypl7hh1f+5OIze6X+sHEtA==@kvack.org
X-Gm-Message-State: AOJu0YxpzHesOtNvtc+1LazXcVtAE0zsGxX6jriNIwBP+7Kwu5N0/cSb
	12mqYK45OZseW0dZ2S3AB8jKODPk6vrZtWSXdy0UvJQR5nO6wGVvghB1dKUJ0qoakn9d09hB1Y9
	v2nJVPSnSTNSBZO6Ccuj7AytHbMQgVnmp7wowHFapsgtXQlDEa+le
X-Gm-Gg: ASbGncuHck7eAFIE259uXegLCQWWrDFrk7oi5yN1wc4gcwyYJecUDJlHTpaTc1YVKda
	1y668+9bbt6CeGyQnyKRk79KomCRNFEa+VP91iqONbHXZXefvlhwb4RFuqJ+Ve6W7bZCbYbvNlK
	IR4z6/xBFUGop1RQmIokrr0CGV1f5KA1dSsbZ86WpMcDAlpoZFzHduCeWKBoPXXMOP5MzxZpdde
	9cMjZf6x0ll3nsmto8nSJ+u1JvaWpUKHoiawGQF03adX4Fh8c0fh+PYanKAKdLbfvbRqAvYnLXl
	DBRXMCAZvx9B3U54dbMIUy18z1RQq7NJH6NORow+0cFfLnL4hhbO3jLibD75DqVCOmS76Wwmrpm
	Y0aUlhnS7LyHw2N8M798t8Bvetf8u42RqoQUDThf1O+lPIyw+kaa9t3mT2jtN4MWKiDY=
X-Received: by 2002:a5d:5f87:0:b0:3e2:804b:bfed with SMTP id ffacd0b85a97d-3e64c1c2183mr835279f8f.42.1757142058290;
        Sat, 06 Sep 2025 00:00:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdr4VmZX14HWt6vWJrgVQl61309Yoz3EBz+B4BvfuTuYDfgHO59nfbR4v+s7YipRZZX7VN6g==
X-Received: by 2002:a5d:5f87:0:b0:3e2:804b:bfed with SMTP id ffacd0b85a97d-3e64c1c2183mr835230f8f.42.1757142057809;
        Sat, 06 Sep 2025 00:00:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f30:de00:8132:f6dc:cba2:9134? (p200300d82f30de008132f6dccba29134.dip0.t-ipconnect.de. [2003:d8:2f30:de00:8132:f6dc:cba2:9134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf3458a67fsm6794555f8f.62.2025.09.06.00.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Sep 2025 00:00:56 -0700 (PDT)
Message-ID: <815cbde4-a56d-446d-b517-c63e12e473de@redhat.com>
Date: Sat, 6 Sep 2025 09:00:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
From: David Hildenbrand <david@redhat.com>
To: John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, kasan-dev@googlegroups.com,
 kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <016307ba-427d-4646-8e4d-1ffefd2c1968@nvidia.com>
 <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6194LdeUTkMCCDAj356KDYBA6LVci2hdIy5kgQ6_0GE_1757142058
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 92654140004
X-Stat-Signature: r7yfgix7hm8coph567pis8ooouwas3p7
X-Rspam-User: 
X-HE-Tag: 1757142063-55520
X-HE-Meta: U2FsdGVkX1+iFo1VK62bJGcSmnAVxKVMCIBSVQMc7XuadiBql2S9ulAGrJTk8dvbicdLd/iXZ9OwuGBJLy1zFaQ5TFmltg5I60ddWqGc/TiQnhPK400Bk2Ny7BqS0gFn+O5oPF1jJLqE+S6ObLJfzPiMyuxQfNtGdz9tAg/nwQOgGPae37bcSdY+RUnNmmxLwYQ8gC1pLL3J1OJdLgI4RsfKDwQC/LM3du1HZC1OnbW7DrF3S2bsLRmZFZD2q+0W+wwJWk/Y4CrjGc8HQBk3Sxrngf/n+sMxAIziqFd/Ddx07DVw+fbvrssHj1zD+EeG9omahpzFc6w1CO2OPwZhpriqFOMuAVQosf4/Z6/6lR8YOYI+cRWzi0I2BYRm5F1LnPmnvDeHxU8Wh7r6tA/q727A3rGn9K4iDsZOkcmBnWqLUQObD3zA6tryy9TBQsvkd3wpR8n16WveLWG3hNNDExWoPQaQQB11dQqpYe9BBZs0YVfrbaJZtlryKpg73bFgiKvxx3vNOowbeWpkp17ecqq8ZGdX8f20BvVRcVc/vF6FHMtpGPkMcbmZmhmvBZrxN2VFvGBnTwODn4/zQKO2d+ypg2m1kocol6Is9EWC/yrjWpgi3+0/G0lFfAi6wIIfyuTvRYrHA1g+jm3Q//5/jG98haER04H6ACpOVT5iLG6m9zPDGNCspvihBCR3t5yXgymrV7LX2l5+qjEgzvQQksMb2s5Pft4z3diZtuU9A6tilcT/x+pNFdRH9NnDJupVM02wyoJv+bUplsVnU1pnu0dysPzOoLe63sYEipgOzcR+4v/dsO54SI/7aOYFQXohmBlvTHyUGpHYtKLpf+X8w1N3za90U5M1rV0uNGoTQp2DyOkXIcFG/jWBgReo4DaObqM9AFEUEiH5v65FcKUcqvaAMw3jhj8AyeRivsv5LTcnA1+kxO+XMMeov4wKx6bC0y5YU58QH7CTon+Rhhm
 E8LzuK59
 tfntMVVVRLvlk4pD5PU9skvu+UXb+3Isb9sUau0bOsXllG2Vq05lSoaK75RGhufGpnj3YqAtDlALS3uXGjqQVvTAkMfhFYVVY7x/CLaKhs8Jcj+dLRgkXytGcU5EoXudRT8VK2Q91syansDdsDIELcljZk6moEBbULkRChlIcu5B0A3tVdR1Khb2qUVz89U2NUgjiKmha68h7PGB9NRPGfxGiuZVQME1lsfTKXQuzmW43X9Fexay3nqnaek02KCbPyE5PU3X/z4UCZ4JV4icxTYmpam5sgWRohxYbLAhaeyP/5uZ7cxN6lGjUwbS84wx+4uOaH4KqSUa6Vlg9h5my48JoJaJkFbudI1+VS9qiGe3iC7i5e0RCraAcGcLAFQDnIHuwdT2gxcufBBWJLvG9Nstv53k3kdg5M2b6ENCp6nrjIACzzvnEeoDQksp22yjjIZYyoEI8SeWYMqXk/G7Yi6X2gLCfKZ8YgEV2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>    	pmdp = pmd_offset_lockless(pudp, pud, addr);
> @@ -3046,23 +3041,21 @@ static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
>    
>    		next = pmd_addr_end(addr, end);
>    		if (!pmd_present(pmd))
> -			return 0;
> +			break;
>    
> -		if (unlikely(pmd_leaf(pmd))) {
> -			/* See gup_fast_pte_range() */
> -			if (pmd_protnone(pmd))
> -				return 0;
> +		if (unlikely(pmd_leaf(pmd)))
> +			cur_nr_pages = gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags, pages);
> +		else
> +			cur_nr_pages = gup_fast_pte_range(pmd, pmdp, addr, next, flags, pages);
>    
> -			if (!gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags,
> -				pages, nr))
> -				return 0;
> +		nr_pages += cur_nr_pages;
> +		pages += cur_nr_pages;
>    
> -		} else if (!gup_fast_pte_range(pmd, pmdp, addr, next, flags,
> -					       pages, nr))
> -			return 0;
> +		if (nr_pages != (next - addr) >> PAGE_SIZE)
> +			break;

^ cur_nr_pages. Open for suggestions on how to make that thing here even 
better.

-- 
Cheers

David / dhildenb


