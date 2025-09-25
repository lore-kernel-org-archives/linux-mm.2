Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A293CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 09:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6E878E0005; Thu, 25 Sep 2025 05:38:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B462D8E0001; Thu, 25 Sep 2025 05:38:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5CE48E0005; Thu, 25 Sep 2025 05:38:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9584A8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:38:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46A03140420
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:38:48 +0000 (UTC)
X-FDA: 83927273136.29.ABE69C8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id EE95CC0002
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:38:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LmWnD79Q;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758793126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=it1xa6zCsSImRY+xGhkMLXcJ8czGI9ZV2cO7XzXjMBU=;
	b=ArWzF9487te1CYTKahghJ0SD6LYaq+LT4QJXH6a/H+2YFxksyCQrX5bU4ZYv/e6PoKqFyX
	2qt5tnTMO9Dpq097qMgY4k8xxQ2HG/AxBc8ZqTSiVMAnh+maLsL5gh0lESED5RHXEAa5Og
	1EmjVCF+OEruzKT9bxmOj+zrayhdCu4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LmWnD79Q;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758793126; a=rsa-sha256;
	cv=none;
	b=zUFi1AyPe3O0v1RstjTSrP3O5g2ydQMWDiWH++OQQ9odxnW3nhVNzxHFeFDmEjurmt2tQ9
	D1z0MjbAionhr4GcGMOZOAxDE6mxided5L2UzWI8fpNrh7H7CPLu6MfT/S7u4tOLnTmF09
	4eBOQSBYFooZOSWcGvNXKEQVURkmvuI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758793125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=it1xa6zCsSImRY+xGhkMLXcJ8czGI9ZV2cO7XzXjMBU=;
	b=LmWnD79QMX//6h8MG1gcxG9ReTbGAuwuD1E1yjwXayDmIj1vSL1mcbmp0qEXmrVKHZ8dJc
	9JamP+EqFLTqggTMlsogF2LpBQXqBoPyULKGrOO5XfnLKhCZLDlsph9IVZnBkFcHJ1ZP3r
	ejg8O/dEofXo5GwoIpXe5lpMjqm3y20=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-RxuEkj0mMai4sUDuRrbPoA-1; Thu, 25 Sep 2025 05:38:43 -0400
X-MC-Unique: RxuEkj0mMai4sUDuRrbPoA-1
X-Mimecast-MFC-AGG-ID: RxuEkj0mMai4sUDuRrbPoA_1758793122
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45de18e7eccso3796865e9.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:38:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758793122; x=1759397922;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=it1xa6zCsSImRY+xGhkMLXcJ8czGI9ZV2cO7XzXjMBU=;
        b=R6rz+Zgfy+7qKGaxtyKs0dtrg2+wBkH83QTP6AxFj3KjMjycZN6KGk8IZSK/Rs9PdQ
         nrlV/pSbdtS5wgAA8ki5xvDWnMOO/i0OtvSYHMy12vwiTIn42IlmeUAH46HnO+0sRRjP
         k/DdR3uLy7V/G+7K9jRX02Y8RCDXA6pgGD0hRRUFCF0ehhPTXw25Ras8xl3VPXDvVV5h
         JOeQoQnuIuvedEj3uWuwKjzfVtQ1zoDTXOz/Z7xsMAxsCLkREfKK8M1dTIiXJjCwAWMZ
         Krf3UE+29ioIaRK521WlZfv8VSZpr1mRHLrwhLAph0VnTtCnuejGpuJbX1vwg5Q7V796
         4tUw==
X-Forwarded-Encrypted: i=1; AJvYcCUaKz5KhtiHz330w0xWLIPeLxj84XcNrHh/pdGIKge3gdu9T3514pm6/UFVcKH0dmBlLdp6f+GL2A==@kvack.org
X-Gm-Message-State: AOJu0YyyVt7jerUiigMscYH9CyQmUWU8Dy6saiE/3cJ4+0M4wtoZA5ra
	uJTzzbgoPC+CTOmPdc332hLwN822lzQ3CUhWYAQTC+lox5u3T6/xtd880aJr9QIQNG814tpWXYh
	NfukcalL2RlVfftBAFDdR4AU5aTGoKmKkK5PGx+GBnkl8mOkbf+9g
X-Gm-Gg: ASbGnctPOiUboppmp364oEI6B9EXqv6stPcRel0PRUgY1n3ArizcmWzPQwx65Z7iSOw
	0B/SmBFld0tYZob0QkxeedjhdM+vlg+kQwpy7AzDyF9qb3GkCdbKGCmJKA6oQtWnKwad/A/PKbZ
	pKtzwysVa3/Uzi3kKISQzVdqXBi58DMmr7GzZSWMrVrSI8PNREC7oIuqOPXbAqSrWBVpMPdH+16
	wIG6vxKhYu4X/zsrWSuJAz0Fz8AEiO0ced1TpHFUwZ76rl9N9iZohpgSCeFpfqT6V4qAmtThI3N
	eLmdEJuh0nXX31gdWXJK3GI7yJZ/TvJL+X1uICy4d0GNlYs1LQ10kzD/K+JNV9qPiE3T0JdBAJx
	mDwBGv7oKxPM9Ll38pVLO1dnRW+/GlMXQaDqRr5gKLowJp62QRswawAWO5WXlu7HwHjjW
X-Received: by 2002:a05:600c:8a1a:20b0:45d:f7f9:9822 with SMTP id 5b1f17b1804b1-46e329b27c2mr24051165e9.12.1758793122227;
        Thu, 25 Sep 2025 02:38:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVxkfcKZdBRrn77cRbQGAcPMp2dfiwtZjiOl6HprH7JU8Dt7NVvFTN8NqQoWgRk2N1EMDfHw==
X-Received: by 2002:a05:600c:8a1a:20b0:45d:f7f9:9822 with SMTP id 5b1f17b1804b1-46e329b27c2mr24050635e9.12.1758793121780;
        Thu, 25 Sep 2025 02:38:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5602dc2sm2225863f8f.32.2025.09.25.02.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 02:38:41 -0700 (PDT)
Message-ID: <54195a6a-7cc6-4df1-a787-45d8f564c0bd@redhat.com>
Date: Thu, 25 Sep 2025 11:38:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/2] mm: add PMD-level huge page support for
 remap_pfn_range()
To: Yin Tirui <yintirui@huawei.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, anshuman.khandual@arm.com,
 yangyicong@hisilicon.com, ardb@kernel.org, willy@infradead.org,
 apopple@nvidia.com, samuel.holland@sifive.com, luxu.kernel@bytedance.com,
 abrestic@rivosinc.com, yongxuan.wang@sifive.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-riscv@lists.infradead.org
Cc: wangkefeng.wang@huawei.com, chenjun102@huawei.com
References: <20250923133104.926672-1-yintirui@huawei.com>
 <20250923133104.926672-3-yintirui@huawei.com>
 <f8571506-30c0-4dc8-9995-41a6469f8fc7@redhat.com>
 <8313b0c1-bf62-4257-951c-fd7e29193ae2@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <8313b0c1-bf62-4257-951c-fd7e29193ae2@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hd9YfuRcE2s06AwsytjaFZqGVnMJNia8abnbH44u1s4_1758793122
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nqbcp4wfbmeiyeepnsyksr6djtxkod3j
X-Rspam-User: 
X-Rspamd-Queue-Id: EE95CC0002
X-Rspamd-Server: rspam04
X-HE-Tag: 1758793125-511917
X-HE-Meta: U2FsdGVkX1+lp2RjyycEaO0QxHhDhPbJep1/362SMwMXYR/9qGh0gKvOqfpbNy6/q+0tzXSiDVKhjqM0gccVVpEUs3/0zgC7VcSoWTxuFkAcFhAt2dX1hhpgkh9LAwKmCAF/5eH+pB295yxurl3gnsuRtdQssHq3fc0j0ESBzH21s3He2PJRO+F8lY659pmugsKfZqIunjUCR3bbI7s+0JdJDN1H2eXIUFRPiiazNeRm3JV1XeIkFfmCwqK7+eXt7l5ud5djWZHcMLxKzwfTNvx2qvlThmiyhgsqjXC2Q3bvHkEJDV05/fm32zRDlKJUpktjmeHIvS8+bD+J8KPrIgDo/ct0CkPzKGP/3ag3JWiYO8bfaWvKcfbdw5DInehc9Y1e8kv7/TewVsmjk3ojRwU7HFIta5clvQ8d41OKEXiCXpLkzn2POvJWJLjoKzId166Zy9uz3BGifFCfPzlHjVGUZ+p+9WESV5glRO6vRcHihWCbUqh+f3wvn9c3I0EYa/k6td7AH9119sDeisuNfF4BFTfKib9EhS+55ueFNlQgzYI6QRLNfW/WALQTqzX56vDbZbumOrpT4gcsNaBA3PFCQ7KEtmWsV1ua1x6hwWpMxBOHlKyEIGLaF/wSNo3CFBcnqoEhNzsqyCPQ/9o9fXN2Bsgv730qzlGwuqXVPJIgfswMeZU8NsGtPkBiixW0dTfmqPtCoFXZWMigL8HANpg+lhsFffVGjwQ+m7F5xbJHMUpp/q1eiCkTOzu+gnakzOABsVMID/LNSx7wYX01/182pueIJZdSs0pC7Pc/QoFf8TIeU3bS0S9G0DKshe4pvSval04e6V6CwsPkR7SAXN6BcvCWmGTyOqDQG6vZJhF9WSEDlio91VbJXSGSkkJUi/zTJ2Y8iIRZOa9JnQLnEiLH+xuFA6S+aTJsO7ohg1xx6EMg3555y5mrZU4PLCetre0B5ISIr030nNP/E3+
 iWyYx3Er
 jjqu6G3EaNaApZjkZYesOqLW8VAQHyJ9yH5DMs62/eN3PC9WeIOa58wz0kPGm3UUrX7bvwgRp8XAKXElJrNDP9WGwnKwwDJVi2kMbQpWN6TN9dC+AbJZgO1QhbHJ3Pfu2xQQ+fYWPV918X3VrmR2Yd0o3kIbiy4fVbNQ9QzGzrrDAOj6iiaI53D83NJxsPOtgKILSAzlIFKlEgomLhQ4lICWFt6+TmdAJaekP0WK+NuKVOKKrDXdySiOIW4uo91VdCRwPUJH+bAVzAjBK0hn8SfTO5UCHV0N9bHoQXayK2GI7HkTZKdDsE8//GzgDAKgmzMMOIKDi0vvUReu8JGsVkM1bR1+HP8wfWfmmCLTz2J+y0/KBjuBgOf5NqYGzAXsoCy3Lj6vnepxDLFjCTUtKvkmxoyKKJ1YJW/qHN9IdvBq0ndqT5Qw20Zdp7nlqenB9VXo3CbBoNL8Y4Q/9JrDomo0RHYCvLgVUSCwy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 03:43, Yin Tirui wrote:
> 
> 
> On 9/24/2025 5:50 PM, David Hildenbrand wrote:
>>> Introduce pfnmap_max_page_shift parameter to control maximum page
>>> size and "nohugepfnmap" boot option to disable huge pfnmap entirely.
>>
>> Why? If an arch supports it we should just do it. Or what's the reason
>> behind that?
>>
> There's no specific reason for this - it was just intended to provide an
> additional option. I'll remove it in the next version.

Good, then let's keep it simple :)

-- 
Cheers

David / dhildenb


