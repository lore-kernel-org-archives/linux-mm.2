Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9920CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 11:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E3CD8E000A; Thu,  4 Sep 2025 07:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA188E0001; Thu,  4 Sep 2025 07:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D0278E000A; Thu,  4 Sep 2025 07:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1DAE58E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:26:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B999D16012E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:26:18 +0000 (UTC)
X-FDA: 83851339236.27.9134161
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7127C18000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:26:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L6tO1+kv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756985176; a=rsa-sha256;
	cv=none;
	b=WQ3EMeTRyz3YhdOLK5rVcw2Oub7ZinUmzFBUlMPC2/1YRQcF2xfG/jlzi9tWu66MG2LO74
	JNGNtUROn2N8+/y+aDI5/DkNFHMXO1OyT5YwG1cNtOd2q/1WPSQkeiJZhg8q03btcR2tf7
	uJxDAVSwEtc24qFPsL+tUhBgFXU0M1Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L6tO1+kv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756985176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYj7vNnXdBif94nkLRSjqJE0U4PgTPFgog7KMgt+5Lw=;
	b=URoK9NqybnZUguTngv4grgfM6s64nM0pzsVjyLeHw+4UH7IC5RGIyfZkPv4onvqkU/Ayvr
	CI/4JrFCOphFIPAzBiE0oEJa2zm3PpjL7zMwAH/bPCuVj+lHmnpbWBBc2HPbQ2puhnwtCD
	2AA7w3pDLzAnloeH8Bt5HoGa8H31bRk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756985175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FYj7vNnXdBif94nkLRSjqJE0U4PgTPFgog7KMgt+5Lw=;
	b=L6tO1+kvx0aTpxn9Xppn+1eb84NthxI+d5Ves8ms8tmG9iQc5fnBiIYLojTncZDzfTPVgu
	fbAAKVxL5l+N0nhW4Xzu5ulONT5aXxnmNhvzWryReUvRLndQK+DsyIKG1vIJ1Gr4/WConE
	ruAS1Rw+9OouEyECryOk5zYwEcN2rWY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-y810XbySPae70DCtnz6Iww-1; Thu, 04 Sep 2025 07:26:14 -0400
X-MC-Unique: y810XbySPae70DCtnz6Iww-1
X-Mimecast-MFC-AGG-ID: y810XbySPae70DCtnz6Iww_1756985173
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b8a2b9fcaso7565465e9.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 04:26:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756985173; x=1757589973;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FYj7vNnXdBif94nkLRSjqJE0U4PgTPFgog7KMgt+5Lw=;
        b=LvgfmXvTFgQy1jcYVzoXSlbS9s4duOWCBLJcGsUuxlZegqj+RBMnLRmt9u1HJ5bPB5
         /xCGknb90cWiA72CngIdHzwyaN/gFZkcBRfoIpyHqJHKel/5oZF714DPGNOFxEeabBfQ
         hFAlRNbLfnB6MG70cyZXXerlBEbB5dt6vXpIEUN7d9JPQdrS/RrFQlHxrmbOLuDOwbYG
         Sy4rCATvuZhZ5H5gVE2mbpaPYfhn1aLst3h5Y0TtK8EkVuj0RvtMZI7U8yf85eHzNEci
         gswcK1ERBXw9JAbx5Mk6vqdFiztugTbGaIGY3xbTCDJ9Egv0KKLX6hGkJubCF/9ZnMFZ
         wQzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUn1V9pmkqVabFCEj7qWMDzo8tFq57/JYbhdmavk9cvF7JwPJHBNNXjLJigk0AnO3pHr33z60PDQQ==@kvack.org
X-Gm-Message-State: AOJu0YzreCUFf1yghoKWHDB6oAV+N1VOu8fQ7qZQtDzBP8thfzq7sS5n
	HR7dlRIBfb74TuhLPYZ2ics8OtHjXeJ2aYCnvGJuesVelFu4Z6z8b91UUG0MHQLLpETB9qyghP1
	U/FPpbJx8+PbUmTlwiOMTgvH6wzczr9u6InzD0hZmJppNxFnK06Ne
X-Gm-Gg: ASbGncuHfauUVaWIbq5o1mrqv4xlbEy+eChudW3nbQVEHBEa0zUshSg1TgJhzbfYkRt
	MmsZu58D3hXl1wKc3SoWq7ESck5O+8kjCchb+WCjUIhEOc+aZ6u6z6/FARQ0HBASdcEVFT5TTZ8
	dEUi4apLjZe9vHxGOm3MIYaQMlZXGJK0iL3QJHI6kk6/U82MwQkJWC5wSHp6u8maGMVvRBWng6X
	8H66Kb4gxOn2q5LqgNvzZtM7D8rf5nsNY/k1evJvJ8DHcvTKvhad5wN8wvkeE7isqeu2+pyvo2o
	yAwukDILCZJm2JqK8tMA5O4fqZznWGeEcPhGQo56VdgYoM/0S9oC8f4jtbCyfQuK/3wiLbK6XVe
	cHM+xBtAGkpn9QgfpPCr4eMls3yIL7yk3PbfJRat3TXKK7wmvdRCJ91ZAnFAOjQWJ
X-Received: by 2002:a05:600c:1c0d:b0:45b:9a76:ebea with SMTP id 5b1f17b1804b1-45b9a76ed12mr67521275e9.20.1756985173013;
        Thu, 04 Sep 2025 04:26:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHA1kxxSVjg9EPss1WbdwZlOW60kNPkZEhsIHevJbu19C93SnnQw25G1XfcOFYBQHy8oHojpA==
X-Received: by 2002:a05:600c:1c0d:b0:45b:9a76:ebea with SMTP id 5b1f17b1804b1-45b9a76ed12mr67521145e9.20.1756985172620;
        Thu, 04 Sep 2025 04:26:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d0a1f807f9sm26554201f8f.38.2025.09.04.04.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 04:26:11 -0700 (PDT)
Message-ID: <8984f395-9043-49dd-a53d-bd344fd419bc@redhat.com>
Date: Thu, 4 Sep 2025 13:26:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: remove zpool
To: Vlastimil Babka <vbabka@suse.cz>, Vitaly Wool <vitaly.wool@konsulko.se>,
 hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Hellwig <hch@infradead.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _gb8F_V95_xj7IhN_NtWk4B3ljykg2tGRpgUg8eAccM_1756985173
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7127C18000D
X-Stat-Signature: psbk4w5x5udtna5qacrufzji35synx9m
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756985176-80726
X-HE-Meta: U2FsdGVkX19o6l1ZRxU7EJXJrTVErSt2e0VJxCrTkhwUfhUZsCPmA3mpLCoQ9jEqT5MVlR53rkYqADQvLqyhC9i0I+As0J/u96yAOHM2kDxp6DRiPypjkTFAkDs704pQHKD2UBc/eOio+cu4VLacCkQii+2h0lo6In61LX9wPEWz8hUHgdL7tiZjJzEjiAStPbi3nlSRqUwCA4rzvrmD4Sn3PvD9WmzNDA7TCWr4CS7vsfRES8eXdX43Iht3i4VoOzju5MfRI1vw8kHZ3RJui7A4Gwft/2lYIx6lAcH4knrLNn6DdS/EWeJVjMilgwDJggENkZUe/iv16U7Jfj+sJ96fOt4MZ0cPkt8iWPV8QX2AkgzoWhag6ObB7IBmW0FAh/Kft79JjaZ0s6nPqAKCnYotFV2tfkfWx3gAbL/eqj/sXRtI5lDrH+/thlheg3m3IZZD51MLPQvTt/T/c9Zob+9hePz01R+XOHOt8nW4ENN3gnBmcKOrDBZWOuZ+yHDzQtYgZm2Y1xf91iLSFyfnv29mMYmBN3GhXplFCYEbkFDETdexbMnguDabrT7Fys8Bh/LIuIxx3BEyNdoZ/zgQF7fv0irgYBBKywneJa4IZ5bARCZ0NXa5hyYi7eqMPN/gOF4PhNUfTauKBLk82OHeHB59uSanusinGj590iP/ELLVJkcDTzVO4zd5un027SDG1VJ/oB7Z2pNpXK7EjZdOiOP0sAgLlR3fSIBtADHWlssaWE+iaJ3+JWFPfDVf9o3P+jRoP2C4vj7m40OqPSqofk5/XPdgHTQXgl12I3ql4PDcPQRKXmyuwysVUcwZxg3JLDay4hAMgObJPkoNjDNGDbFuWMCnPUpUjdzh/F7ZkrN0a5yndDzraQobh/xYGUmQ4FcdvsbQRdp5zUOFzw2oPK3ePrNFCQksJi/iGBfIDHvQZe23aSEEVI0CkIAAMlIKGS9nnVqfCMiO51OgH6E
 2SuIMHA3
 D4QPPH9xYdcw0w1N7vDf1d4UGuhs4VHQK8Wfp9FizWiC1WObyrDP1jsyjt0yvV4oNwSB83AxNB3C/CTm83XkoRoyhLNpPcS58CkrIcQnXzBIToYk5a2KUTEQTF//u0jgLcT9n4TA7NotaTwVl/ucsD85LAHtMJx49qga0bp7rOyZRvAvEbqGJes9+VS9+dyvEpD4IrteuyIO6dEWbba+Gasc1kVomu91SniDf6TG8jZHEl40BYBYBNYyWW2BndiwZqY9EGYhS+T52UN5qEAhfWg3DFIJ/Bb3Ic4SkQVQb6qkZNJviXfjT7ENqTO/EPg/Fvj7DlwwQeNx1eOU4/HR3gfnjTYs5olLqKLyzOXBTO1z0UlWtAybaHaeByCf7zEV6/n5duBW1PcFjx8GfrIwiSrbHvPes6KMQwxw2mQDYqhKgzM6XS3M/tt87MmllFM//mkGe+aJgm9/5LKzODVfglBP+dmG7Lco57DRff+fiT225dty/ZY0qUShV1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.09.25 12:13, Vlastimil Babka wrote:
> On 9/4/25 11:33, Vitaly Wool wrote:
>>> With zswap using zsmalloc directly, there are no more in-tree users of
>>> this code. Remove it.
>>>
>>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>>
>> Per the previous discussions, this gets a *NACK* from my side. There is
>> hardly anything _technical_ preventing new in-tree users of zpool API.
>> zpool API is neutral and well-defined, I don’t see *any* good reason for
>> it to be phased out.
> 
> AFAIK it's a policy that unused code should be removed ASAP. And that's the
> case for zpool after Patch 1, no? It could be different if another user was
> about to be merged (to avoid unnecessary churn), but that doesn't seem the
> case for zblock?

Right, and

  13 files changed, 84 insertions(+), 715 deletions(-)

speaks for itself if there is no new user anticipated.

IIRC, we did a similar approach when we removed frontswap.

-- 
Cheers

David / dhildenb


