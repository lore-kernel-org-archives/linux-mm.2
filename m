Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E67D6CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 246486B0006; Thu, 11 Sep 2025 04:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F64E8E0001; Thu, 11 Sep 2025 04:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BE716B000D; Thu, 11 Sep 2025 04:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E4F8C6B0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:12:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8743758D49
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:12:56 +0000 (UTC)
X-FDA: 83876253552.16.6A24CE3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 00CFD40003
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:12:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Petj6vyc;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757578374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3FQkhEMcvr0EcoaDlDZlVAs7hfOGwWx07xz7iOCeSY=;
	b=Vm231Fi6YpT58wuvpwdJJCn0E6F3hixmcRrPuWnPYfnc8Bazj389v/dx1/cf91OMZa11p6
	7v2cwvjV0gxmRI1eXA5YkbaFReZaXS+qK1C4fkSi0bAIwJpBotAvgTPkVPmS0/wLUqG9WG
	KUEDAdA22h8X8+wBhkimgz5onQQShZ4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Petj6vyc;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757578374; a=rsa-sha256;
	cv=none;
	b=45T2g92cXnWZVOi8TQ//cMbh9hrmvJO6mZE23Pv22WAV2QaviDBx0V2o/Ut9aE0NLAypZA
	bTEeuAaDdbZQdXyTxSodYVS0CuqKvj9sQC836j5MgmIivZDmwsx48FlIuRftXSPyrM7S+o
	3W7lYBlBhXsanatsjSTrtU1mpoBZ5BU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757578373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=q3FQkhEMcvr0EcoaDlDZlVAs7hfOGwWx07xz7iOCeSY=;
	b=Petj6vyc3RQNdo8O3XK2HWxrts+VJyfNuSu30dvaTGt8iittqS0QbDFBik5vTmpcW8OHCv
	etCoYhiSTy+q72Yffsfxr8kM9R7uzJE9xKt3sYUdeMnD9eSd+8uu5nSqhEMN1CAd+Y+2V2
	q0/T4q7GkXhaZJhTNWartU85U7ZC+nQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-ftog54LKMVydIYtU0GGSlA-1; Thu, 11 Sep 2025 04:12:52 -0400
X-MC-Unique: ftog54LKMVydIYtU0GGSlA-1
X-Mimecast-MFC-AGG-ID: ftog54LKMVydIYtU0GGSlA_1757578371
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e751508f3aso257547f8f.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:12:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757578371; x=1758183171;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q3FQkhEMcvr0EcoaDlDZlVAs7hfOGwWx07xz7iOCeSY=;
        b=Zl4c8xcFIpy1nFBIJjOsFm78dLnAEGajIm3Ndyrat5k0a9jGn4VOpol5RZfK9gp+i9
         nbhayL3d92mvpLn3KS5ABNn/XrTVfYwFa7WxJ7E0QFdjtgjxnyJBwVCO1S34PpfhoFnl
         LwwGAVNcQ8R8lAI1vNN76Iifb0BM83TH0xtC8ikohf5/+1vfMcWcXgsj6kKvdA6XuMAl
         e5wR8ygIy4L2XZHEqSyx2+Q+mKBaUAK6N18IxWa7RtJ2m/nVehi7ia8nHgqS4DevGYE1
         pEPTEsLVDbl2+6BCWkTrpCq6UIhPdm/gZwgMf+9cf/ezG6P+DX+QrvmiQm/pYqvd2X2x
         c5sA==
X-Forwarded-Encrypted: i=1; AJvYcCV9gNSQEqHdMHtyK7Js4NQ03wdvymcVJPW0l3Q0EN56uatjjRX8gWsCWJqRihGvTmkKI+ncagbGZw==@kvack.org
X-Gm-Message-State: AOJu0YyLrOD0xbZcW/spK5FaklqhJ8u6S/Eec7qPOiBpP9WhU75FkZkL
	SisTDIHXVX4hjU7n8illJTsxDEdJLOCUOiFWXbFUXq9N5A7HpzI6BOkmsi+zu7yPSol5jXm3Jei
	gQwvwJgYHtpL7l+8xsq403RPd/XikK5grS7UfYYUU06zlhIjYLCg/
X-Gm-Gg: ASbGncsr2++KFWLD7LiawzJdWB3qzRMvq9L2+uEr2AGxZw4Om1Ndf62rVAznQ4NJuoU
	iPJT1vev4CDDq6gK+VnyMqE7P8MBAsd20s9CVEsjR4BnzX9c0ocH6RmixbZoppF1I0WUCZxpq7q
	ZWXWhyFThp/yT7Zp8YSIC+38J+F8TczcJ3/MO/a86Bij2DPX5x5HUkHboMP+eICb5Jh/UT9ycm1
	dp6tZZSLoCC1mFn9knkFpoFtYJQw5Q3Y40kGZlLz9ynhXFK6C4FVyx9VH+QfiKbJJB2nGtQTT+T
	dAHe4Ar5TbBr9g3s2SrrPQ2G7TqGp70tvx7cPXhGO8QzwhdSSPUi1ci9ELw32jr3dryT4wUR/iA
	wQZMfSrMei2aniKLtFvI2WmhyIdiCn5q33MMwBYAfh4hQ5rolfZSW7gyZGkawugw5bTI=
X-Received: by 2002:adf:eb02:0:b0:3e7:4ede:d8a1 with SMTP id ffacd0b85a97d-3e74eded8c3mr8215904f8f.48.1757578370657;
        Thu, 11 Sep 2025 01:12:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExNs5PQty033WtXs6t/LxnTxcNbGcQzB2atLhIjEhboWCVT5UxRk/pjRwFiDV6ZMYel8lVSg==
X-Received: by 2002:adf:eb02:0:b0:3e7:4ede:d8a1 with SMTP id ffacd0b85a97d-3e74eded8c3mr8215888f8f.48.1757578370258;
        Thu, 11 Sep 2025 01:12:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760711bb9sm1533593f8f.0.2025.09.11.01.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 01:12:49 -0700 (PDT)
Message-ID: <c88a263e-a73e-430a-bfb9-a2b9a32dede8@redhat.com>
Date: Thu, 11 Sep 2025 10:12:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: avoid poison consumption when splitting THP
To: Andrew Zaborowski <balrogg@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Miaohe Lin <linmiaohe@huawei.com>
References: <20250911021401.734817-1-balrogg+code@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250911021401.734817-1-balrogg+code@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pPMK7pw5qk6IzKI5ZwI8hCrvU0K497UJMIxdcsXjIgs_1757578371
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 00CFD40003
X-Rspamd-Server: rspam05
X-Stat-Signature: 7tbugsi5385nx66rhdsz8hdbnptnb8dn
X-Rspam-User: 
X-HE-Tag: 1757578373-105907
X-HE-Meta: U2FsdGVkX1+KXApGFIbnesL9m/isYVvAR4Rl002o4dnbvmuyQnC3A2qWua6/FcsHy19OeUv5bk/+8YQmAZvQKlT8zkmw7muo3d5XeIz2D9PAuvGl77bgD0c7VIwREvMHYmNb/VLrEFrX6KG3ygh8Khh2yLKu8SGLRCcH6OXq7AY60qiO8+F6E2qSZcSqc7QWJN4SSGD386mPHTPpmLWCpwgMIZKF3qTnGlQwqnz66whDfSTSpSUQH2Cp+z3UGbdaKfF9aEzHyNGbEnYDgfs1wdibOoWUTwM+fYTia1IOVa20mjaajse3bHYhAnS0YTe4Rh+xMkyp/7P62oOPrJLm0cft86HEUBF4wTuZd5NBExuDIdE6yPVQNmTzdaxbZhGaESpyaFzliEXiGZ4vEA23E/pSMvB0mJ3WqsoVPq+1kBL30efamTMIHu3Pocy3D7QqOCH8RhwvCdtJHLnPzymgMx3vL7ZE2InMMxCHa56mkk0HDdx0L8Tc0S3CWD9JHyg//qVottK151ulm9lQMSqwOq2F5JErn9YKM2DRDzPF0s6VfbUj6+l1HiDf5/b9jD6DiF7W8knr8eanLF8vLgTjmFrHo12PYfqJcpwY6egiyfh08q9IKRpNa8WTHWhwSFbV63d4JeftEqJmBX4DtjgD/Mp5N8+AmEqGnCFklH//FfhHsKe87qzjjw6KKurRmOl506Am8tPGSMGi2a85M/oGFfR5fhc8NOET6c+jDh/GJ5Yh7cBynLkd9pMmBea+6R15F3eEcHzwfJsTZxt7n5DWP0yx5GoMY4/FercnqdkfJSIOHY6FtRPojEcikZ0Zl2Qlw1B/8VFGvCbpLp9i9LJI8M9vRr+7YFJ4DQUoFlfoS5CNprdrhSjz3U9uCi877uYQoyi3M5Hei3TxU0IDEyuP5j9DaTiUsgO44Z88OKkQvlEUmpktbj4Xaw1xkOWhB/MEud/S2/E3ixNML6epPA4
 5vBluxfc
 7itJvs8tA2Pof1KLdaYCbY0rC6QBp46QN5ZLIxIywo78vYlwSMQflIGu90tUHVk2+VSD1n/rDDrOyOM4opKTjdWIpkXO0ihx2+/0Y/HM1rX7jj4wmWSEX5h1CKSG46M4OBj9IPjHYaskIChN2rrUHnR+NNiRyqMtIEOGgXbqxa8tHmeMd1v1yZjcewizkuD731hIz6cPEduc2bshEriHMbcS0Lhg5NofoyZYJr4VfAD5AJ64h7nNbE5sww7pghwp7A1mssNfvv+WvLfS01BgN3qQ1eHvzIr6hPZ7tUuIrFAPl7zTw3tdChR1h7V056w9HA237/AyM+SdNLZfItjJIActZfC42m3gtHw4OElkNtZyhgq/9wuXpyKV8HzMpjjmAvwgPkgck5DVh0FLMX86ox/kZ2fy1f7RS0GK0ZzFjPAqvgAiEE+POIlNLR0CeMSJQghdx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.09.25 04:14, Andrew Zaborowski wrote:
> Handling a memory failure pointing inside a huge page requires splitting
> the page.  The splitting logic uses a mechanism, implemented in
> migrate.c:try_to_map_unused_to_zeropage(), that inspects contents of
> individual pages to find zero-filled pages.  The read access to the
> contents may cause a new, synchronous exception like an x86 Machine
> Check, delivered before the initial memory_failure() finishes, ending
> in a crash.
> 
> Luckily memory_failure() already sets the has_hwpoisoned flag on the
> folio right before try_to_split_thp_page().  Don't enable the shared
> zeropage mechanism (RMP_USE_SHARED_ZEROPAGE flag) down in
> __split_unmapped_folio() when the original folio has has_hwpoisoned.
> 
> Note: we're disabling a potentially useful feature, some of the
> individual pages that aren't poisoned might be zero-filled.  One
> argument for not trying to add a mechanism to maybe re-scan them later,
> apart from code cost, is that the owning process is likely being
> killed and the memory released.
> 
> Signed-off-by: Andrew Zaborowski <balrogg+code@gmail.com>
> ---

I would suggest just checking whether the page (PageHWPoison()) is 
poisoned before doing the check for zero. If set, just treat it as non-zero.

No need to stop the split.

You'll have to do that in two locations.

No need to mess with RMP_USE_SHARED_ZEROPAGE

-- 
Cheers

David / dhildenb


