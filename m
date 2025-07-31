Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC37C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 16:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEFE06B008C; Thu, 31 Jul 2025 12:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7B26B0092; Thu, 31 Jul 2025 12:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE3A46B0093; Thu, 31 Jul 2025 12:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AD0976B008C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:15:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6746B1607B7
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:15:46 +0000 (UTC)
X-FDA: 83725060692.13.1DFDDB4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id BC9CA40016
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:15:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LGtZM1Gk;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753978544; a=rsa-sha256;
	cv=none;
	b=U6w+LSRkRhq01tE2VyAuM+/qk5OLvdMnl6nVsQY0eACXD0vZ7R785M5xp3f+sqbOfBxYwq
	NbuxO+igeKR3szsujxvRiT0++4PuJHBoXTIL3JtMuW7EJaGJ0JgOIzYgks07hrulsdESKP
	pPEAyf3aOeBvrs22/wkPCcTAvdBNmhQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LGtZM1Gk;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753978544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCFMEvUPyBLrGC/oYDfyk4mKEAk9olU5xdsqV7nWMUs=;
	b=Ouc8ox7JJgaD+uGjV4r+J3qAVB/CZPPCTBsACYXl8D+b8hr/YZlae7Eobn8GiO0vwiCDip
	qdKGJTq1a5g20SYUKvXIFRVPn04hn1kfb8u3h9QGr3F2O1+j6JoHW0aKFp7lsiWELXDuTc
	hLqDAs0j/h6JAyxQbr3OHbhjMM8f4jk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753978543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hCFMEvUPyBLrGC/oYDfyk4mKEAk9olU5xdsqV7nWMUs=;
	b=LGtZM1Gkukjm4QhA8dmysEkbpCfxbhYwJP3LxB0Og0y+L5lR9u6Q23pD2CuoGt1g5OUmFx
	+fJVcnmH0pM/U8PO9jLQoaLlaQrTpwHRhDKAGX9jueQYvY3p96LpoH3uOYl3gdZSBeF4S/
	3z6aFVGyyFt949mSeahTwQ/ZsUC7v/Q=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-_IEroW28ORW5UM1m1xkkuQ-1; Thu, 31 Jul 2025 12:15:40 -0400
X-MC-Unique: _IEroW28ORW5UM1m1xkkuQ-1
X-Mimecast-MFC-AGG-ID: _IEroW28ORW5UM1m1xkkuQ_1753978539
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b7807a33faso284557f8f.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:15:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753978539; x=1754583339;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hCFMEvUPyBLrGC/oYDfyk4mKEAk9olU5xdsqV7nWMUs=;
        b=ccJLyp7Mtz8vt0xByGA69P9ViFOg+jm7F1UakqGuCS/4d2WYUxKFnCljEPheELln2Y
         +6DVpChnqyah08laJZGEX7DrsxRYQDuj3ApcuNogV9wNQnJ9fFidUVmgB+/gkQsip9JA
         CO3ReOiWPG+JBpqLt33wiAfmRZPU+VFkWsnZwJHpud7y5UW2uzwx5hZCq1O4yUhW5+q3
         2dMYJEeFbHHFNYZVigV9pTywvwQP9/3ncP6CguLQWsV9B48rPcmaSOpZe7F0OHWCEXWA
         ABuXm9YTLdZHi7IMh+ULwo+j2KnCsKrVUYNxJ9t3MJhlkFluHhnZXLt6M0VN33FdXlb8
         pd7w==
X-Forwarded-Encrypted: i=1; AJvYcCWoWdvn27LMgVn4DV14JF8zlly7nQBeSampPaCxfugrHBcjxso8BPuwZAEJ0ZQVb6ZVaY2B6wOseQ==@kvack.org
X-Gm-Message-State: AOJu0YzjgYBiALqxG+lCNBPIbZynvQAUn514BHr82NC7PlP1oDyY3gGL
	ZWJtzyf30SDhhr5rXWQS2RY9rst/RWAaEKh5GUUInQsgQc7ZumEY9G7xSyZmB4N1NL819ReMOBR
	+J6+GzpcOUd6vmvKlvk7rPn4tWymcNMcDhzeYg46MEHuVLNKBCuuk
X-Gm-Gg: ASbGncs95Zxe2799Rt97plrTrfEcVaFmrQr9b3j7Vkn7GyZHzDjJqbKA9iBpLYKtxxG
	9sZbfMgV23gfiZ3G0+6EJaVpWov2Aow5vb2X/H/BxBVF/Gyv9stOQOm86QBuwM1WUdxPZN/EJdn
	Cv1q6ECL6zKPid85xT7xWDpDYOs43qZiYhNuJzFUPCwvU8Qm9NtIae9McCq8xBIrAz/KoAYmy8Z
	4VbSgjDKDvba5nlGsKTl43mfILcKHW/rr+WdWiAX2aC5O1L7DCPzpd9vbki0iimbyNFuYYTnILC
	eq15q0TTOVNfftU277cVV5ac8VzwnJRdrmVtGCKk9UT05xA15eAbxuFew9/Ogo9d4fXfTZ366Er
	3NPXW3d8gvyQhk9dio7RZdtaqA32ugU686p/lxLc04dsbZ457QGNlUhiaC+AYcRjE/bY=
X-Received: by 2002:a5d:5f90:0:b0:3a4:fbaf:749e with SMTP id ffacd0b85a97d-3b7950065fdmr6170037f8f.49.1753978538699;
        Thu, 31 Jul 2025 09:15:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGytZULQmZ/hDajIkM/Htt7MthdICmHyxaaQPthRUhPkwjUZgExKSH13cnPbk4HyFbkpq+P8Q==
X-Received: by 2002:a5d:5f90:0:b0:3a4:fbaf:749e with SMTP id ffacd0b85a97d-3b7950065fdmr6169988f8f.49.1753978538121;
        Thu, 31 Jul 2025 09:15:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3700:be07:9a67:67f7:24e6? (p200300d82f443700be079a6767f724e6.dip0.t-ipconnect.de. [2003:d8:2f44:3700:be07:9a67:67f7:24e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4a6f62sm2778077f8f.73.2025.07.31.09.15.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 09:15:37 -0700 (PDT)
Message-ID: <09acd558-19b9-4964-823b-502b9044f954@redhat.com>
Date: Thu, 31 Jul 2025 18:15:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm/huge_memory: convert "tva_flags" to "enum
 tva_type" for thp_vma_allowable_order*()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
 <20250731122825.2102184-3-usamaarif642@gmail.com>
 <c44cb864-3b36-4aa2-8040-60c97bfdc28e@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAmgsLPQFCRvGjuMACgkQTd4Q
 9wD/g1o0bxAAqYC7gTyGj5rZwvy1VesF6YoQncH0yI79lvXUYOX+Nngko4v4dTlOQvrd/vhb
 02e9FtpA1CxgwdgIPFKIuXvdSyXAp0xXuIuRPQYbgNriQFkaBlHe9mSf8O09J3SCVa/5ezKM
 OLW/OONSV/Fr2VI1wxAYj3/Rb+U6rpzqIQ3Uh/5Rjmla6pTl7Z9/o1zKlVOX1SxVGSrlXhqt
 kwdbjdj/csSzoAbUF/duDuhyEl11/xStm/lBMzVuf3ZhV5SSgLAflLBo4l6mR5RolpPv5wad
 GpYS/hm7HsmEA0PBAPNb5DvZQ7vNaX23FlgylSXyv72UVsObHsu6pT4sfoxvJ5nJxvzGi69U
 s1uryvlAfS6E+D5ULrV35taTwSpcBAh0/RqRbV0mTc57vvAoXofBDcs3Z30IReFS34QSpjvl
 Hxbe7itHGuuhEVM1qmq2U72ezOQ7MzADbwCtn+yGeISQqeFn9QMAZVAkXsc9Wp0SW/WQKb76
 FkSRalBZcc2vXM0VqhFVzTb6iNqYXqVKyuPKwhBunhTt6XnIfhpRgqveCPNIasSX05VQR6/a
 OBHZX3seTikp7A1z9iZIsdtJxB88dGkpeMj6qJ5RLzUsPUVPodEcz1B5aTEbYK6428H8MeLq
 NFPwmknOlDzQNC6RND8Ez7YEhzqvw7263MojcmmPcLelYbfOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCaCwtJQUJG8aPFAAKCRBN3hD3AP+DWlDnD/4k2TW+HyOOOePVm23F5HOhNNd7nNv3
 Vq2cLcW1DteHUdxMO0X+zqrKDHI5hgnE/E2QH9jyV8mB8l/ndElobciaJcbl1cM43vVzPIWn
 01vW62oxUNtEvzLLxGLPTrnMxWdZgxr7ACCWKUnMGE2E8eca0cT2pnIJoQRz242xqe/nYxBB
 /BAK+dsxHIfcQzl88G83oaO7vb7s/cWMYRKOg+WIgp0MJ8DO2IU5JmUtyJB+V3YzzM4cMic3
 bNn8nHjTWw/9+QQ5vg3TXHZ5XMu9mtfw2La3bHJ6AybL0DvEkdGxk6YHqJVEukciLMWDWqQQ
 RtbBhqcprgUxipNvdn9KwNpGciM+hNtM9kf9gt0fjv79l/FiSw6KbCPX9b636GzgNy0Ev2UV
 m00EtcpRXXMlEpbP4V947ufWVK2Mz7RFUfU4+ETDd1scMQDHzrXItryHLZWhopPI4Z+ps0rB
 CQHfSpl+wG4XbJJu1D8/Ww3FsO42TMFrNr2/cmqwuUZ0a0uxrpkNYrsGjkEu7a+9MheyTzcm
 vyU2knz5/stkTN2LKz5REqOe24oRnypjpAfaoxRYXs+F8wml519InWlwCra49IUSxD1hXPxO
 WBe5lqcozu9LpNDH/brVSzHCSb7vjNGvvSVESDuoiHK8gNlf0v+epy5WYd7CGAgODPvDShGN
 g3eXuA==
Organization: Red Hat
In-Reply-To: <c44cb864-3b36-4aa2-8040-60c97bfdc28e@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZAzH0tAdGvfd_C9gPH9z3PHhx4AVcJqxPrN4VGvF_VQ_1753978539
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC9CA40016
X-Stat-Signature: kai8tyrung7j4n31pdbaapfs8txtgrq3
X-HE-Tag: 1753978543-98302
X-HE-Meta: U2FsdGVkX19YhiSasHMq8h4QE15IWIDxXSWXmq4eO/oj4VAKq/YCwHiTMQ5jUbUh/3mDsWcMsiyUJoNaMNKEAB5xxs75mlap0RGKRIcXruo79zdP6+rTDEyw5bIKlFkBO8ilf7TH65ovzfabfBhLR/9YzkJgLWZcH7O62GNvM8Tu5JKiCrKKutlsAlJZ7FRToxmJe/i/DeaORBW8AU9jvDqYk9t5UlprA2CIh1doPfORds5FbHqSIe1UfdtNLtdcle8WNcG6mb+hDV2o9ejazVVr+0+irA2N6M5mpaaNf7imxf4+W8dhvXTg1sowRAAjXWUV7rHiYfpRzVnIOHAdUVHkQJVjJoT0ZIlCU6MtSgAkzG35OcOfqdsDAChWLDPiTbNMBQolUMxnr04NXsQRpqCkrZYfEH650Y0BjRWQeqmLlM/gx7qOG8l3V9JpzBhRI8uHBDYVfri2LemRXwEZKpjMq07Hoj0KFG1FO517uhaXTqfswdh2UJStMMQjOYopMhbmb6e51ygoBw1u+/RnoMSx0mdMYn7iA2RMEf+ZU5r7r/qGdShS9jGoSL+gFHUz9Ti0iA4oUKw//mJeRJuVpLnuArTGiMngtMcsWuYc6qrzubVyGKSsMNsJcXxjet78oS1mKWHYJWOYra1WpF8EXi2SWSx18qY2EBLFvVpLJjGtlPxBMQ8lQ6TmikKbIwzNWIsdUn9U+6Qb4rBQsTfT+2pl2+DTJgMo91EXxSLan9SHhrWkdCzzXjyirYnNj7hb0TQMGuhLMBkwqSdfkrxdfuD0ORkrMnDFpexZJKXwr9g8GyKJt4RyQ0+wO6zKVWZNrvbXD0n4kS+CXsXDpJXv1qLUe5HD4snjvhr4H+ioTSa9pNcwLXPCKnKqbXgWjrACV47kLQC0c5XZ+9M9u9Dv4912ch0FHuaSEnCrvzUEQy3T1405R8lu0WkNvNXJo6z7Z+O1HyHem+xLcNxmVQd
 VHwpWXiM
 XhvI9Q3Xt99h5XjKt94T5BW7JLfX+02cd3Ql/pUWinHW8BUCalk5qu7738shfZmO6so+9Xg8DTcceG5hNXWVNZIPWfoH8VUS0f+3ogcVnlJNkHGKxV7EGCam/9UYUdKyH8e/y+Dv6lRWbs/+4srum0Sov7psxZEiAuc9HvTK1s7UtUNj977nmBD8l3nDDQDyGSfR2BMCDNMSfTW9Xg0bGmeNQXih5BHZ9eu/T35OA3BMdjYFcEd5JvRW50ZpBF9fOFf6kk8AvL/rL5GSKHowVnX7jVNjg5LVALoz1zjWzrpAqCyNK52ms8FlneQ494JqeX6VXn71nQ+XA9KorKQT0V8NsTXnB94K/SUHiQA7sum1gsmCox8DPzdTwP7z6fZRvsyhiYktWPb2lQsLIWUPT2MRzUwIzFlbQvxF9sTCHehGGB2y4GLDsezRiW2E2HBjSz+JlhohoHnvMGx81h5tAgmWT0Qs+yxUEdgCzDMVRo8qeRunpQ/kgC19la3p1X2ids7wT0/a/FkfDIEwdnVCtODBVL+5rpuipqNq1oo1+0MMQv+34xSssKkAHxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.07.25 16:00, Lorenzo Stoakes wrote:
> On Thu, Jul 31, 2025 at 01:27:19PM +0100, Usama Arif wrote:
>> From: David Hildenbrand <david@redhat.com>
>>
>> Describing the context through a type is much clearer, and good enough
>> for our case.

Just for the other patch, I'll let Usama take it from here, just a bunch 
of comments.

> 
> This is pretty bare bones. What context, what type? Under what
> circumstances?
> 
> This also is missing detail on the key difference here - that actually it
> turns out we _don't_ need these to be flags, rather we can have _distinct_
> modes which are clearer.
> 
> I'd say something like:
> 
> 	when determining which THP orders are eligiible for a VMA mapping,
> 	we have previously specified tva_flags, however it turns out it is
> 	really not necessary to treat these as flags.
> 
> 	Rather, we distinguish between distinct modes.
> 
> 	The only case where we previously combined flags was with
> 	TVA_ENFORCE_SYSFS, but we can avoid this by observing that this is
> 	the default, except for MADV_COLLAPSE or an edge cases in
> 	collapse_pte_mapped_thp() and hugepage_vma_revalidate(), and adding
> 	a mode specifically for this case - TVA_FORCED_COLLAPSE.
> 
> 	... stuff about the different modes...
> 
>>
>> We have:
>> * smaps handling for showing "THPeligible"
>> * Pagefault handling
>> * khugepaged handling
>> * Forced collapse handling: primarily MADV_COLLAPSE, but one other odd case
> 
> Can we actually state what this case is? I mean I guess a handwave in the
> form of 'an edge case in collapse_pte_mapped_thp()' will do also.

Yeah, something like that. I think we also call it when we previously 
checked that there is a THP and that we might be allowed to collapse. 
E.g., collapse_pte_mapped_thp() is also called from khugepaged code 
where we already checked the allowed order.

> 
> Hmm actually we do weird stuff with this so maybe just handwave.
> 
> Like uprobes calls collapse_pte_mapped_thp()... :/ I'm not sure this 'If we
> are here, we've succeeded in replacing all the native pages in the page
> cache with a single hugepage.' comment is even correct.

I think in all these cases we already have a THP and want to force that 
collapse in the page table.

[...]

>>
>> Really, we want to ignore sysfs only when we are forcing a collapse
>> through MADV_COLLAPSE, otherwise we want to enforce.
> 
> I'd say 'ignoring this edge case, ...'
> 
> I think the clearest thing might be to literally list the before/after
> like:
> 
> * TVA_SMAPS | TVA_ENFORCE_SYSFS -> TVA_SMAPS
> * TVA_IN_PF | TVA_ENFORCE_SYSFS -> TVA_PAGEFAULT
> * TVA_ENFORCE_SYSFS             -> TVA_KHUGEPAGED
> * 0                             -> TVA_FORCED_COLLAPSE
> 

That makes sense.

>>
>> With this change, we immediately know if we are in the forced collapse
>> case, which will be valuable next.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Acked-by: Usama Arif <usamaarif642@gmail.com>
>> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> 
> Overall this is a great cleanup, some various nits however.
> 
>> ---
>>   fs/proc/task_mmu.c      |  4 ++--
>>   include/linux/huge_mm.h | 30 ++++++++++++++++++------------
>>   mm/huge_memory.c        |  8 ++++----
>>   mm/khugepaged.c         | 18 +++++++++---------
>>   mm/memory.c             | 14 ++++++--------
>>   5 files changed, 39 insertions(+), 35 deletions(-)
>>
>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>> index 3d6d8a9f13fc..d440df7b3d59 100644
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -1293,8 +1293,8 @@ static int show_smap(struct seq_file *m, void *v)
>>   	__show_smap(m, &mss, false);
>>
>>   	seq_printf(m, "THPeligible:    %8u\n",
>> -		   !!thp_vma_allowable_orders(vma, vma->vm_flags,
>> -			   TVA_SMAPS | TVA_ENFORCE_SYSFS, THP_ORDERS_ALL));
>> +		   !!thp_vma_allowable_orders(vma, vma->vm_flags, TVA_SMAPS,
>> +					      THP_ORDERS_ALL));
> 
> This !! is so gross, wonder if we could have a bool wrapper. But not a big
> deal.
> 
> I also sort of _hate_ the smaps flag anyway, invoking this 'allowable
> orders' thing just for smaps reporting with maybe some minor delta is just
> odd.
> 
> Something like `bool vma_has_thp_allowed_orders(struct vm_area_struct
> *vma);` would be nicer.
> 
> Anyway thoughts for another time... :)

Yeah, that's not the only nasty bit here ... :)

> 
>>
>>   	if (arch_pkeys_enabled())
>>   		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 71db243a002e..b0ff54eee81c 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -94,12 +94,15 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
>>   #define THP_ORDERS_ALL	\
>>   	(THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_SPECIAL | THP_ORDERS_ALL_FILE_DEFAULT)
>>
>> -#define TVA_SMAPS		(1 << 0)	/* Will be used for procfs */
> 
> Dumb question, but what does 'TVA' stand for? :P

Whoever came up with that probably used the function name where this is 
passed in

thp_vma_allowable_orders()

> 
>> -#define TVA_IN_PF		(1 << 1)	/* Page fault handler */
>> -#define TVA_ENFORCE_SYSFS	(1 << 2)	/* Obey sysfs configuration */
>> +enum tva_type {
>> +	TVA_SMAPS,		/* Exposing "THPeligible:" in smaps. */
> 
> How I hate this flag (just an observation...)
> 
>> +	TVA_PAGEFAULT,		/* Serving a page fault. */
>> +	TVA_KHUGEPAGED,		/* Khugepaged collapse. */
> 
> This is equivalent to the TVA_ENFORCE_SYSFS case before, sort of a default
> I guess, but actually quite nice to add the context that it's sourced from
> khugepaged - I assume this will always be the case when specified?
> 
>> +	TVA_FORCED_COLLAPSE,	/* Forced collapse (i.e., MADV_COLLAPSE). */
> 
> Would put 'e.g.' here, then that allows 'space' for the edge case...

Makes sense.

> 
>> +};
>>
>> -#define thp_vma_allowable_order(vma, vm_flags, tva_flags, order) \
>> -	(!!thp_vma_allowable_orders(vma, vm_flags, tva_flags, BIT(order)))
>> +#define thp_vma_allowable_order(vma, vm_flags, type, order) \
>> +	(!!thp_vma_allowable_orders(vma, vm_flags, type, BIT(order)))
> 
> Nit, but maybe worth keeping tva_ prefix - tva_type - here just so it's
> clear what type it refers to.
> 
> But not end of the world.
> 
> Same comment goes for param names below etc.

No strong opinion, but I prefer to drop the prefix when it can be 
deduced from the type and we are inside of the very function that 
essentially defines these types (tva prefix is implicit, no other type 
applies).

These should probably just be inline functions at some point with proper 
types and doc (separate patch uin the future, of course).

[...]

>> +++ b/mm/khugepaged.c
>> @@ -474,8 +474,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>>   {
>>   	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
>>   	    hugepage_pmd_enabled()) {
>> -		if (thp_vma_allowable_order(vma, vm_flags, TVA_ENFORCE_SYSFS,
>> -					    PMD_ORDER))
>> +		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
>>   			__khugepaged_enter(vma->vm_mm);
>>   	}
>>   }
>> @@ -921,7 +920,8 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>>   				   struct collapse_control *cc)
>>   {
>>   	struct vm_area_struct *vma;
>> -	unsigned long tva_flags = cc->is_khugepaged ? TVA_ENFORCE_SYSFS : 0;
>> +	enum tva_type tva_type = cc->is_khugepaged ? TVA_KHUGEPAGED :
>> +				 TVA_FORCED_COLLAPSE;
> 
> This is great, this is so much clearer.
> 
> A nit though, I mean I come back to my 'type' vs 'tva_type' nit above, this
> is inconsistent, so we should choose one approach and stick with it.

This is outside of the function, so I would prefer to keep it here, but 
no stong opinion.

> 
>>
>>   	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>>   		return SCAN_ANY_PROCESS;
>> @@ -932,7 +932,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>>
>>   	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
>>   		return SCAN_ADDRESS_RANGE;
>> -	if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_flags, PMD_ORDER))
>> +	if (!thp_vma_allowable_order(vma, vma->vm_flags, tva_type, PMD_ORDER))
>>   		return SCAN_VMA_CHECK;
>>   	/*
>>   	 * Anon VMA expected, the address may be unmapped then
>> @@ -1532,9 +1532,10 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>>   	 * in the page cache with a single hugepage. If a mm were to fault-in
>>   	 * this memory (mapped by a suitably aligned VMA), we'd get the hugepage
>>   	 * and map it by a PMD, regardless of sysfs THP settings. As such, let's
>> -	 * analogously elide sysfs THP settings here.
>> +	 * analogously elide sysfs THP settings here and pretend we are
>> +	 * collapsing.
> 
> I think saying pretending here is potentially confusing, maybe worth saying
> 'force collapse'?

Makes sense.

-- 
Cheers,

David / dhildenb


