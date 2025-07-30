Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F693C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 11:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB75D6B008C; Wed, 30 Jul 2025 07:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B675F6B0093; Wed, 30 Jul 2025 07:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A30196B0095; Wed, 30 Jul 2025 07:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 917666B008C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:30:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23A61113EA7
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:30:21 +0000 (UTC)
X-FDA: 83720712642.10.D036A01
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id AE24D80009
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:30:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FVObvwn7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753875018; a=rsa-sha256;
	cv=none;
	b=emueBuJoQC3M0md7fXshshPlrkD/5EFOt101wtWhy+hid4Aou3rQNGuFlVq5oc6znYKR1w
	3T7TduHRjWHJ51tr4WDIdZZAHa7DTvm8CDQzOh12lGyTTvM8lKqcDS5sGbTjiDxCWqBVbo
	gzrFUVbpXShijQYQgqzPJQfEHldKbMc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FVObvwn7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753875018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3GzBWqyifWHwH5iceOXiQp1MaER96Ffw9rxd4twZL8s=;
	b=njKGczy7UgfbZnpkFaF+oLoL1lZmneP1Aze2vi7cwKbMResU+sWLJT2BYLX6sLu0+LVDSR
	//F2LkXJz534mR202k+bwtNiyxC5LqyoE4SWaPV2zrr9xyv2Ow3U6RYZxEhoiQrx5z87GJ
	MRXO2LUfUktC+Up9BSRpwBHwY6NT//s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753875018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3GzBWqyifWHwH5iceOXiQp1MaER96Ffw9rxd4twZL8s=;
	b=FVObvwn7ZSzVwmrDaPKFDzKP0zZnmwtcAdSZ6K0EeFDtgqv4SDc1teIcbPAB4g/uyWTvmo
	sg+b5Ys4aYpdC+ebaJgJ0yZSEqg7kU0iI27ft6Cbrv09bEqtf+lRT2rFtvWbyyv0GZL+UU
	jyWMfKnGVgdxkDWhgoWeZBW/5FMo5N4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-nLqDz0g2PRezBaRcRmV4OA-1; Wed, 30 Jul 2025 07:30:16 -0400
X-MC-Unique: nLqDz0g2PRezBaRcRmV4OA-1
X-Mimecast-MFC-AGG-ID: nLqDz0g2PRezBaRcRmV4OA_1753875015
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4561611dc2aso48876085e9.0
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 04:30:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753875015; x=1754479815;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3GzBWqyifWHwH5iceOXiQp1MaER96Ffw9rxd4twZL8s=;
        b=ihJO+LxOw+YgAKDo7s14YGiXMTh7Irz1GGhjqjSG8wi/3orK+X5wTwUO0BgiCorY3b
         lT/R4Yw3Eiu+n+DZt/0tFPKGQRMEGU56+0XCeoTtwDywBZqK+shy5q/dZD/ya4TMB24n
         K0i5Xzx6Xu8aU9ttECE56nh/MT2vuWoiC8S5ihXe8iNC9aQE2y/KR60R6oVzbZ8ovqp1
         A2xEASKBztzlhplVqlq6zvmTuw+qeI1TpzdZrsYBXlgwKE4R8gXdHIc1jKv/nBK04pI8
         hhb3WnVs8mY44qr7PBLIWFu7u7ZfQj8IMsP5NyuVCdKdHv/JiB8zpMokB0OEnL2ZNJfu
         f7AA==
X-Forwarded-Encrypted: i=1; AJvYcCVUqLE3RcN1mZVkzX74mwrRLw2NE0ou8wce5GdsbLx3qNJXzSuxG7HeNf3myHQWUdWo89iQ8T+Kbg==@kvack.org
X-Gm-Message-State: AOJu0Yyd5Fr9/MzX4K+tp5B0uNpR8Owe0Djd6gH9gauOJGmaddenB+B/
	THbh8KvKOI+H2JY2/3nGypn0EU+eVLOH6K2iZB6d2vz+axX0J13FWxKPSGMgJoBMebaK4BZ7PM9
	gagriG271osZY0maxUhtbMJFkgg6lIg+i7wttE6QGFFjhOIQ+Cn0l
X-Gm-Gg: ASbGnctOrp02Z4cwykfZDM+r986Ac/RkJb6uFheo8NkSrJfBg0tAzwkBz0+3wwqK3/0
	tIF/PnVxHoNz7bh6D5QiuGUbV2CauRnlWwAG99ONrD0GO/a1+oVSowK7Fw0brXx20TCjPjzIfXd
	GPDLW1IL6zbvGgtPPnKl62Xka+QMdo/JEiN76eCF/gBLzRHZgWGyIC2RGK03AZF5j0zH9W5kVGr
	wb0d/1eXN4AK/vC6vrtnivDrmuINzSNaHL5/TToxYPr8E0G2iGnqvqWV8evttQOrOeb/EdQ/r1+
	nDBPf32DmK0xCrJV+SL5cXCOjWcN8uA2ifRVOz8lpyAn6WGHq/HJLsGkK3xs2g==
X-Received: by 2002:a05:600c:1e01:b0:456:1efa:8fe9 with SMTP id 5b1f17b1804b1-45892ce4323mr29265175e9.2.1753875015493;
        Wed, 30 Jul 2025 04:30:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEnL3iXbokbIqC0Pm+v5Ra/rDptiTrRsG1Ols//d8nDmztKA2bkpZWNHk6oLfyjXU92baoGVg==
X-Received: by 2002:a05:600c:1e01:b0:456:1efa:8fe9 with SMTP id 5b1f17b1804b1-45892ce4323mr29264655e9.2.1753875015032;
        Wed, 30 Jul 2025 04:30:15 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589952a60fsm19204465e9.23.2025.07.30.04.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 04:30:14 -0700 (PDT)
Message-ID: <e0153fb2-af59-4bcf-a07c-d650fa56d55e@redhat.com>
Date: Wed, 30 Jul 2025 13:30:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 00/11] THP support for zone device page migration
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, Jane Chu <jane.chu@oracle.com>,
 Alistair Popple <apopple@nvidia.com>, Donet Tom <donettom@linux.ibm.com>,
 Ralph Campbell <rcampbell@nvidia.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
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
In-Reply-To: <20250730092139.3890844-1-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MyMKCFjUlYZ79_6i82aQGbyDD4CJ4S2dZAN8ssZSyfU_1753875015
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AE24D80009
X-Stat-Signature: pqeatwx9u31jeojqmje1k3hs7x11itb5
X-Rspam-User: 
X-HE-Tag: 1753875018-136961
X-HE-Meta: U2FsdGVkX18UwWjw7iouIVtcOlDdBKJPsbBqfJ6D44fzYJPNnrDExGOdKkG1PB/3GRgDDXtf05+nm8L+/GomomJ+Ow3PQ5Uou8XxZH01FvHEUOs7dTWba+7KXUIV6o83nt6LMOuhyJHePkzP/bZ6GCUNjHRDSxTCSII8HcZ713NV52E0JjRx9mdbJ7pIc8KbzOLyBE3y9VylVZ0OGiSuYpVcTRZA3NIJMzvDca+YWnjLBQUUujIpk6OUdrJNhafG9bPd78pNsc9Lyd/ksKSvdAf/d6o4tBFrqZs/b01B3lkNrY/0+yKN4QkOgsKiJmA8mAtjquwI6mVtocorkV09Rd3IqtiyOimjn26ZRkWbGNubmVuYuRWnuhGXvNRE2JA+s2EolQpUITaBNt6Y92cW7p1BiAWpmK2ybZemIGUr3uOuSdx89W1MSSc1T8z9UxwkH42prdV8oLU2rWKBxmoo0thGgUORngsMns7fib5MUSa+u78W18AE4fsRhWC9L5VyPXOA15MmD4WsQMarx/PX9TLPmJRqOQfFV9dVxeHApBBvhnOY+Bltr47pf8t9EQIeSHfmhQqBxftdH93rJ+vzm5XbZP1abRb4vObKTlbdheWIl0HoRsuItHd39sCyyPReBSbBT6kAtzmGu7MZZhVpWQXCaL2v89Li6YKGR7p9p62BcennMS1vGjoiFPiyoWFm04O4hZTcvzA6KgJlaE54lgIGFMPh6obVsczyQ0dd5JcURIEgGLsl7RrRooXVvM8BvXQW/QII5cWJ59v+QggMUw47WGS0wFCSk6WdBkkTZ+YmqR5k69IW50mEnkuFsreusz1i/jqmkUkgdO1CmKsPcJG3/l0QyLg8s97mkw494JruiAFgtGaHYugtyovXVMQmLHc7J/4hjRaU3HpL1BRa8q/OfrU92Yxz9I5McuaMrhQQriW2ELLnwxRIMIX0kC6sQhViKCCDk5jBg5FudhQ
 xv7ptF+I
 d1edqJmthkAzDiXnqt6aZSOKyiZk6UXwvxqXA07lgVJsmpw3x26GHUXDQSojJuV46lRs4zJZANHEtCJtkV0xGvyG/gZXSlEtpJu7UEqa4Vl0+1nnzsUMBmIyRvBJvSQBkK/3lWDHb0GKZDbWIGRxave4DK176qqrtTarhzY6Rx1ZBsgp1DoOXI+lOEdqTPpmKdnNhceJLzx6B7WvBjuP/UO/wHdb9Mst+hZUhm03S0pKbJMNFi+m5nPS0FVCzmXFsSirGwaE5OXF4kjjBa6l+2wAFX3I7e/1r3kuhEDFyIx8dLcO/qOy8JvpKLC7r9t2WQ4oYGVvqFn85KYoPuT7qU0OMnX68VjuRd3uC6sO9kw3yKm/hD9SpDAElD/2MkTa+tHGjzCDFHUckrsUK5icCeWlrO2b8eo/joH6KfgYl+Ns5qi8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.07.25 11:21, Balbir Singh wrote:

BTW, I keep getting confused by the topic.

Isn't this essentially

"mm: support device-private THP"

and the support for migration is just a necessary requirement to 
*enable* device private?

-- 
Cheers,

David / dhildenb


