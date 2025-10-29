Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19838CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F5E68E004D; Wed, 29 Oct 2025 06:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD3B8E0045; Wed, 29 Oct 2025 06:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594D28E004D; Wed, 29 Oct 2025 06:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45A3D8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:03:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D91CD140805
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:03:27 +0000 (UTC)
X-FDA: 84050714454.09.C2BF448
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 567E640011
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:03:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VYEceeTV;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/FcJHpggx8mhqHuRDKjQ5iwsuQXd8X9W9pn2zrK9qs=;
	b=Ruxb3KRkTuwcsSfvcPIJDw6Dyht/5a0Zf6bkMbeQdA8zds9/2TCL/esYVpgfVZulgAZZhS
	1VU3LqRSyaXKwbCyIxYxrAXH6dU6eLcPQ6cj7DTYm5LMj5dxT173cfvmp7hD89VJMxHJBM
	nMywWQYNkjdAd1iWYNQ+DrK/fEsNRso=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VYEceeTV;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761732205; a=rsa-sha256;
	cv=none;
	b=xXS/ASEx7xS5Ihckgop3TtETGQX19mJrxyGxCzqzhnvEMoZMT4x4xEpL0G1vGZYh4G+8vW
	f2u463UPJoezJougDIC+VQ0xoCzjrlF6jFtVpTODjZd+Cgmok8qjSopEIdsJI8e1vQ/JfH
	YyzmdUUIS/Y7PIbFhQSlbA6JBjTorRQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761732204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=y/FcJHpggx8mhqHuRDKjQ5iwsuQXd8X9W9pn2zrK9qs=;
	b=VYEceeTVRV65mF3O2GENFPIlY6jh+L9pF8cB53BRxWC3iNsHBszOuxc54uNTvLA13qtwjV
	1HojKZaC1RLZgNecLh+sv6RYdB4dkRkFg2OGsc89HdpwaRrU6yWoipDO9vxYfYKfJYFGJJ
	VO3UkADmVpg5UG07HnYgP5swsrbr8xQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-7ljYW8UmPhyXjLe-D8_u1Q-1; Wed, 29 Oct 2025 06:03:22 -0400
X-MC-Unique: 7ljYW8UmPhyXjLe-D8_u1Q-1
X-Mimecast-MFC-AGG-ID: 7ljYW8UmPhyXjLe-D8_u1Q_1761732201
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-427015f62a7so3302567f8f.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:03:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761732201; x=1762337001;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y/FcJHpggx8mhqHuRDKjQ5iwsuQXd8X9W9pn2zrK9qs=;
        b=U6dPKS6BXyBV4QZNXDahyoAPQqdoayeiNg5ktZPbTM01pdajzfCUNEA9jycH7KGFux
         UuRKSGFw+jmZhgmkKLSnLUn1fojIgkKxrlpX4AQp9yqZuzXUaUbvZlSApMrR8uLTT5tc
         0BZIlwTofhaH2VlL5gdb+P8lP9YwYa9qRPVdQ02tpq21rxVuSS1/5D0RURl78Y1pKoP9
         nTTwdquBk3uYUdXKDb3XpAY6M925PM0Fu+MlPEXwdtVLN/QcVZwtarSCctZWnm08+HSW
         Wp2eYBdmcusx8BTFb1yACyaCAjf7Zzql0aUTBotSRjkt/svOsS8RrNH60qX2PZZuT/S7
         YkRw==
X-Forwarded-Encrypted: i=1; AJvYcCUANGq7c9Us8CIqpvRm6nLHfEQvB5IucUqsYgrKuRhaOh4cZLk55I/43zubsGMcyTPDSQ+yPjg6tg==@kvack.org
X-Gm-Message-State: AOJu0YwyM1Zb3sdi0Sf5xYO8x/yfLExUSkPjWiVpJXmlDZbO3I2HDlWY
	SnzufYVkrYTuq/AsrT7wO9nZ+sW9yCwPrSOtT4rXHlnNcxB9NqPy8Kl1kdI3vO/XKf5Sh+UIAI0
	WS0qXbAb7FdvahiYYOz2fNN4PyqN4rQaGQbZNT5BV3Wa2Q8KJ88B3
X-Gm-Gg: ASbGncswWx6xprjR377h2JSZo7eRbQsUH1DNUZ+sBAs43hw1zPhDBiOCy/84iTJgbUp
	g9qWFbInPC7m2gaZOwBa9X3NAlGKAftW8s0a7o/pzqisVrXD4trmA5q37bMneFwLREHgUlyC4dn
	zEMb9IfRLs2/xLGpw6EW26YcTYdP8Pfs6o/cqmZnN45u3lbGx2pRTsGihVK2mQRpHbmjVpqgCFY
	IKgmasyHsOPllL1dM9wkak9IHrigWmDNuHf0/vNQV6wBn/s06h7yl5ji0v8S/PxeOgtENkbJBmJ
	CnjdKhQOuTrlP+z/JKiYlY3SclYXa3azeHwKk0iFx1Qse5L9DjkUy167ihIkOEdddRCc8V4Px9t
	kBUUhnqhcln0tS/tlDijl2w==
X-Received: by 2002:a05:6000:401e:b0:429:66bf:1463 with SMTP id ffacd0b85a97d-429aefcf5a7mr1864160f8f.44.1761732201082;
        Wed, 29 Oct 2025 03:03:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhljWIvbjQXrTT0ZcTSN+ZEGtAmVQa0mTp2gcq9/yltWmwcEjiu9nE5kn8XdaFT0qYfkxXUw==
X-Received: by 2002:a05:6000:401e:b0:429:66bf:1463 with SMTP id ffacd0b85a97d-429aefcf5a7mr1864123f8f.44.1761732200603;
        Wed, 29 Oct 2025 03:03:20 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952db964sm25517336f8f.33.2025.10.29.03.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 03:03:20 -0700 (PDT)
Message-ID: <dcceca48-bbdc-4318-8c07-94bb7c2f75ff@redhat.com>
Date: Wed, 29 Oct 2025 11:03:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/mm_init: Fix hash table order logging in
 alloc_large_system_hash()
To: "Isaac J. Manjarres" <isaacmanjarres@google.com>,
 Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org, kernel-team@android.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251028191020.413002-1-isaacmanjarres@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251028191020.413002-1-isaacmanjarres@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lVRGnFe0EQ62TbMcUixJLkA5VnujwlPhqH8YKZsq0LI_1761732201
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 567E640011
X-Stat-Signature: mcujp1hq5w7mo3txk15wfddqcejrx5ba
X-Rspam-User: 
X-HE-Tag: 1761732205-738811
X-HE-Meta: U2FsdGVkX1+yKdntLrDQPr1mvem97lvD/cP4P69WR/oUYxXV4DVrl2Z+HrVWr+ExPD9rIcbOzr3SbLKYkeTZc0C6gFhaR6caG67JV1RFSWt4oiY4jQsClS5yQ2vryzP32LQm3uunguh76FCtOSHjLO0Jb7LyYF28Gl43i1Dq4TlBs/Lp8QqS6Lk3D/bAMBkHqagCKhF7+DdnM15/mhKcN+W8awzdXqbzVbkjzZA6Fafg8MJN6GmujCEFNMgz03RqbA8z+blo+Ch/Sew9cMSlVzRA94geOKG1kNyXEpD+KYSHLi8Dd+Xfvj1Nn0NVCWqpHxvGlouhrNpqHwD+Z1sXKD1cyiI9GSHTgRC8vuESAVtSEA/VrE7MLXl8D0s5Tp8Y19JKFwUfe8KMOusCLQiECNoiEXwGRJqkw/ohcyvJ7Hf1i4aGqYYbub+TVK+vEAQeHmvHKbbKP8WCV9y+FQLncS0oOXMUnPlmsjBPfG3NE3wyMkkDMWRFjs1xE0gV1ak+jpyvRjso+tdbyoCGp8xwt4NdM+XzNlBt4+sKb5DoBvWK/dTXNcz5U9kqGe5uTMOFpxxUKhCyPbRaSB2t5i8J5gp3VDEJRh1J0yTgby3xc5634mxJWWyZpxa7Ijqh0d2OH1N2fGIiGCra0fnD5AR8fgfjdEm/fivUZ8R6G7o44RrSg3cTsvxEiRkrpqZLPqAYeh/xv4ZjttlnR9Zwdma3f09kr4/LGEL1M/cIjg2UBQwbmH1uhK9gZ0ycuQpS6QpHztW5QyMaGmYS3pJuAfVaovTo5Yr6tmbkn9jfJwcjP669G2hX3cLs//GBIEpwyGr3+UFz4nctBu1U+XacYHcIyI0k5pcdiO9jmAvtnORvU+fpPe5hdn7JRP2YYGCwPefBTwvS9rEMTWiqpsbFW3KkDXYa8sC6Z2+uO/BwhrvZOsyw/eOWNlhDi9O7ks8YYvQEsSnUI2HlC6igDig9sF6
 CpMk3Tzc
 CUb9Ew0yfqW8f/OkGEBoy8CIjBPLJIfT29+rvYgdlTcJtfznXMuVNGEnFMhyHIJDXjcpSCki/q3c6b2IbE+5t4UDf5Z2dQTALsWwcj5QikfW2idNXjqtYigngZwkL+QR/K61LJszgOb3GiARpRJ+uhRYwz3fBNlDCeaLJZXE9OWB4VhaeFxaFvUrnsfwoBBswakG8mmylszfSfcqYvVN9q7+YwUUN5reTxbZI2xXfMplyigAr6FsFExqiN9hr4zs5PTmMA0d92vHvbNNMsedltKx8zGtVerKEW/L4VD/poPBq7teDZluLeWReMG772ALUMGRups6ePYsYS73pDaE5BVDPkaRte9wCzRI/itV5734ul1s0UA94kqe6wVoMWmdeVO5b5ldy3ytgzjqCNHNO3OPpuZq/MnVZSqRJVzMQjIFfxTYyextYznUlgOgv5feA0aRZ77dfghY1K7aZ9tL5QWYeLqttKDoV1qIZY5Vdl5ICl0nPdMi1GU7RTTDZEAg1z5Aiz5iiJJY5pjlqt/Tnq2znbk4Ulye8hGq6Bn1dgzUN818+yTswmwco2VbfRT7ql3iyUjThtMfSpvvTkad8Hg5m2yOiwLjUwPxuy0jFVUSedqu9P06fEibBOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.10.25 20:10, Isaac J. Manjarres wrote:
> When emitting the order of the allocation for a hash table,
> alloc_large_system_hash() unconditionally subtracts PAGE_SHIFT from
> log base 2 of the allocation size. This is not correct if the
> allocation size is smaller than a page, and yields a negative value
> for the order as seen below:
> 
> TCP established hash table entries: 32 (order: -4, 256 bytes, linear)
> TCP bind hash table entries: 32 (order: -2, 1024 bytes, linear)
> 
> Use get_order() to compute the order when emitting the hash table
> information to correctly handle cases where the allocation size is
> smaller than a page:
> 
> TCP established hash table entries: 32 (order: 0, 256 bytes, linear)
> TCP bind hash table entries: 32 (order: 0, 1024 bytes, linear)
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org # v5.4+

This is a pr_info(), why do you think this is stable material? Just 
curious, intuitively I'd have said that it's not that critical.

> Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
> ---
>   mm/mm_init.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 3db2dea7db4c..7712d887b696 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2469,7 +2469,7 @@ void *__init alloc_large_system_hash(const char *tablename,
>   		panic("Failed to allocate %s hash table\n", tablename);
>   
>   	pr_info("%s hash table entries: %ld (order: %d, %lu bytes, %s)\n",
> -		tablename, 1UL << log2qty, ilog2(size) - PAGE_SHIFT, size,
> +		tablename, 1UL << log2qty, get_order(size), size,

So in case it's smaller than a page we now correctly return "0".

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


