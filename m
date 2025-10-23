Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A166CCD1BF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 20:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6344F8E0011; Thu, 23 Oct 2025 16:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60C378E0002; Thu, 23 Oct 2025 16:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA9D8E0011; Thu, 23 Oct 2025 16:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3F45F8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:54:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E03B1C0C89
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:54:57 +0000 (UTC)
X-FDA: 84030583434.13.EC24E75
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 63DB0C000C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:54:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K6M5HgBC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761252895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=msiKVYWHSQdItrL939R34SZBheamSPWIMDRxwGKcY7Y=;
	b=vv9ev/tBUZiKfDEBbois3NQ4sABqEy3IIQ/vaJwnCIp7ZEXZbz2rsknUm24l/LlcIDUVZq
	OEyVUp6ujisNmuvt7IBibkZatN3Yj38/WfzxA6i/CdrAFHJYr9KAVmCys4DizOf9MH5f9b
	dI1M5Vga0iOCXQnsk+q06rVKcQYF7f0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761252895; a=rsa-sha256;
	cv=none;
	b=Gck+j/ztkMKNnsN7YuxhaR/7N4j5YHIFoQsE+9gHlK8i91js1loXbAJrFV3BL5TgJEWvQp
	n+sQLWFfDy3xLrtKMUSM78OCCIKps0gZQakNsFBsC8MeBb/OpMVBICF8wzv6v6lG/BgQhm
	L2FSaZimN5++wMjhzwM3L/uBumraVEM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K6M5HgBC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761252894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=msiKVYWHSQdItrL939R34SZBheamSPWIMDRxwGKcY7Y=;
	b=K6M5HgBC8HxPH6ygqt9bS70FcXHB2r7xyVuC6AuHsnXqpRrmNGk4T7ms+UtRCDpPB5FjM6
	b2AHM5EbwVFyBG45rJ+SjU4su/UF8VhRPn5/rZw2/rOpcpSrnD4VGBo189/G3lHHAAGDRs
	W9pptwZTfvfOK4+xW9YHKPaIyIhZ138=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-UwbFZ1YOPVO_DfRpXfAviw-1; Thu, 23 Oct 2025 16:54:53 -0400
X-MC-Unique: UwbFZ1YOPVO_DfRpXfAviw-1
X-Mimecast-MFC-AGG-ID: UwbFZ1YOPVO_DfRpXfAviw_1761252892
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3f7b5c27d41so1035448f8f.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:54:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761252892; x=1761857692;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=msiKVYWHSQdItrL939R34SZBheamSPWIMDRxwGKcY7Y=;
        b=sgeBGtX0Bzf03ZZ80949aQ+qR3y6ZZQo67eZkiP9FnGMNM3POuhwXEx4ovTAkVhhSY
         6XlqXXgNTrR0XDkT8IXD2wkzI/udDrn3jcYSSf5If1HvH/Z6l6vL5X4BUlU0OARM9BpI
         fNn6SVPZ63NgMLfMr7PvG9mNNdU594OvRCtQuwNRafbPUUBJtxAGX6xPpteuEVd1Dn47
         81gDX3apsIK7zALvUva+UY8Rv5nEMWpoI+ZPtVV5dPFpztUPcYR793sLJKF0C6TuPbJz
         N0SmdJJg/QYr6CGrwzA/k+r+UkqXfM8GH7+zXDBRY2mFZFlbvzYKk0fXADShBx/pyWhl
         K+Iw==
X-Forwarded-Encrypted: i=1; AJvYcCUCwS4/zjd4/BowC4mk4Zw4cw3s1MyMxH3DyMjRR1G1Ap3+yjPEb6HQpzks84sxYNfOABAxvrQtog==@kvack.org
X-Gm-Message-State: AOJu0YwwH3bKHLaafBqkZ2sO2lG65jRpRUg7MJUssmuj+VAZP8xvNE75
	F8tdef+QYZeUK7NNRH7SMflDxYj2cjPOV4PtENwboC7YnhMRDFksy8H+bsYehxGyPiE38bNxXZu
	d437gBGqEqgcArmDALrF/D7zc2ssJDYCcsT8jcaTvWkjt9TEVCnRE
X-Gm-Gg: ASbGnctujiIiRml2a7unSn00asHCnG8inkD4lIUillS/zD8zRMTJRYwQUDdIxWnZFXO
	tsgP0uYccDPUacE/xP25zPI+zU27Gnzw74525c/LEaOtW2loHvKPwyNIUoE2Je7UNY977xZvHn9
	C38s+WSibQRXtULpYKfuj6CBIzCkhWo97S7C9nwVqpzZRNwwa8QdR2uKkqeGhDY45PCGZfzM636
	VoYgojzVKRxEEFkwR+pOqW6xvYS05kD0XEZ3SoRhb33VfEZBAhqHdUEwlwkGQvk8dyxlcTDl5Ca
	nenw5or1foa5mhU8cTznbZcLHWO4zjo318UR76sKJXAkwpFhgpc4R1H+lrwCAbbYBv2ltNCbqdW
	HvCt4lTV5KRkIOOv7LryzTnmXUsocxymfHdeW3t1j06ghX4u72qqkOBdKk9xcUkReKVfX9MMBY0
	JrghpQX9zMvd+OkXAu2HDjxBzr6YA=
X-Received: by 2002:a05:6000:1ac9:b0:426:f9d3:2feb with SMTP id ffacd0b85a97d-4298f5768b9mr202874f8f.23.1761252892170;
        Thu, 23 Oct 2025 13:54:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6P6cDPePEsuTJGDLHUKhovQrQ2mHJ56yA+geqOPGhrDw50Ig/1srvbHRTrnAUVormPLFpaQ==
X-Received: by 2002:a05:6000:1ac9:b0:426:f9d3:2feb with SMTP id ffacd0b85a97d-4298f5768b9mr202848f8f.23.1761252891707;
        Thu, 23 Oct 2025 13:54:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4298b9963ccsm4026621f8f.7.2025.10.23.13.54.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 13:54:51 -0700 (PDT)
Message-ID: <3ad31422-81c7-47f2-ae3e-e6bc1df402ee@redhat.com>
Date: Thu, 23 Oct 2025 22:54:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries
 beyond i_size
To: Andrew Morton <akpm@linux-foundation.org>,
 Kiryl Shutsemau <kirill@shutemov.name>
Cc: Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
References: <20251023093251.54146-1-kirill@shutemov.name>
 <20251023093251.54146-2-kirill@shutemov.name>
 <20251023134929.b72ab75a8c132a17ae68a582@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251023134929.b72ab75a8c132a17ae68a582@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wzz7QqJOUgXcnWK6otD1x1ohr8Fc2OgXsW_r_Q1vKhA_1761252892
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 63DB0C000C
X-Rspamd-Server: rspam02
X-Stat-Signature: nwpxba31oegm3qgndfajhr7nsxgesbf7
X-HE-Tag: 1761252895-774606
X-HE-Meta: U2FsdGVkX19vnkdywZbmSv0/nHCHQ70cQ8MvF8aO25NndLIbl3Ngx0eQ4bxiQW2+CrhzB2d+mBg2Wn7qgW5yBXaIHfzuly+Y7gJbwCVDv0bsWpQGSwpcQg7oftXhVblRPRvngeoBaxnf3hfZTBI3gV1dYOlaxoxDl7w3WUpl2lmH5KFnsIRagWlXjlAj8Ch/YXY5hhtCvAnzWG03MdhGSRcCxUnD7Js0keAfUH8cS5VBH3DpgBddldtN4Gw+Y1W0X1UU0O5zgVLqd6fUTOmpQA/P/n1/9bNVdZk3SUhUTz7sq9yqe3GeHkcFNaAeH7nrKg0E5pukUObbOkegBpfOnBMFM0sAYFSYXHA87V1Ae8aAhjWrPjNGCkQbruQx3G5GuxFYF/xbnE/a78JgtZAr/7oRovXDRiuu6vPsMc3gU6yemJixMdks2w2XsdDGrz5ZgtCyBDpbBvalYdPBZsZwwqHIxFI1kmf8DbGH584dd8+XEHodOrt/Ck2j0lTLu72hYg2k050sdNoMCP0dynCU1hj1egO30UnAZvo4/pYDqNccV4/ZFjDtixRXy65/UBQjIehUagqnSyk/sCWK7drls9KSlLxld2kmZU32npTq9GVTKD+ifyzg031/P0mVSqp2FkGV00chmDB9Y8kWZRMxKxgtDohsqAdfrEzeybpvoZl4fFW7wu5fdfteqZhOHuCMsTegVgQ61l3NnyntuXfB3ht9LcsypbvyobzznjeKqUvtAQIM1zqKoSSMAR8RNfyBHLaALaYW0UE2hZelpL5OOLOXpVzvOuk8dIoKilWKs48IEXlC3bRv/I4e5zV1duX5N0vvIOgvY1RK3UCPrMS3HABABBjeGDPcoOZvo/3Cat0KaG3FLm6BnpsoYUgR6TwqSyC1+u7FfuXjQhVEW1MGFgGTgQDhd6HpZkDA8cr8utnjlz5q7tArHSsIx6lwIYBJV8UusmhKky7VSYWtUij
 CW1/gcZx
 61k/nrfqnBcBBb3oAsuS3PjDurpYI+5MHAxl7T9st23QIgi6+TVt+anwRYGSaz7ayKxO3OQGquEVwUTe0Ql9943bSfooC/IlaxdpEshE+c54fJo+elcFxtmnKmIO2ops7NoFZgiwbFp4owPwxN+8HO2P8HVB+x3oaBHKvNuCSaAfkxDdPa5MnLsbM34LAN/LR22qdg4ssoZIB7ijCHMr3TY9rCcMnNOlehyczCwGhpkgxCwvtK5KMRUs+3Io47iDe1YI1zKwNiS5ngkeTyq9EeUOYCabz16KWbeLF1LIE5MeB8veMlCvxWciyU4umwj5cP+lFY8lueoyCgxSQ8hBr58LesvyGpQScVvkwxuhgJIklR4vPGeD9/BSCNO33U0iy3D8gz5jzq6pDo3abqwmd0Vv3zyJHLqhu/gv5fCUHRmk8/pWXnEG5WcQ19phgrxnzvmMls24JOXfe42W8/rmLMIZbq763kXXnJNtEisFh1Q1WVDR0Ibj4sqDg+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.10.25 22:49, Andrew Morton wrote:
> On Thu, 23 Oct 2025 10:32:50 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
>> From: Kiryl Shutsemau <kas@kernel.org>
>>
>> Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
>> supposed to generate SIGBUS.
>>
>> Recent changes attempted to fault in full folio where possible. They did
>> not respect i_size, which led to populating PTEs beyond i_size and
>> breaking SIGBUS semantics.
>>
>> Darrick reported generic/749 breakage because of this.
>>
>> However, the problem existed before the recent changes. With huge=always
>> tmpfs, any write to a file leads to PMD-size allocation. Following the
>> fault-in of the folio will install PMD mapping regardless of i_size.
>>
>> Fix filemap_map_pages() and finish_fault() to not install:
>>    - PTEs beyond i_size;
>>    - PMD mappings across i_size;
>>
>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>> Fixes: 19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
> 
> Sep 28 2025
> 
>> Fixes: 357b92761d94 ("mm/filemap: map entire large folio faultaround")
> 
> Sep 28 2025
> 
>> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> 
> Jul 26 2016
> 
> eek, what's this one doing here?  Are we asking -stable maintainers
> to backport this patch into nine years worth of kernels?
> 
> I'll remove this Fixes: line for now...

Ehm, why? It sure is a fix for that. We can indicate to which stable 
versions we want to have ti backported.

And yes, it might be all stable kernels.

-- 
Cheers

David / dhildenb


