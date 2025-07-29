Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB535C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 13:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AFFC6B007B; Tue, 29 Jul 2025 09:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687876B008C; Tue, 29 Jul 2025 09:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 575F56B0093; Tue, 29 Jul 2025 09:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BF5E6B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:58:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFA8C1A006F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:58:14 +0000 (UTC)
X-FDA: 83717456508.04.07C579B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 83FDF1C000B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:58:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HusHbLrW;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753797492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsCCUQApP9CC8DKwwUvy60D3l2hcvtSPFJWH4AWrj1E=;
	b=kRZSvx5O9vwOYpk3HODyttgog5nyb5JJ5JDfOmuGYXA0vsLwbRNGxMbLykJTNjLsZsvW3c
	rB72Vb5NbBuNF9ewWjdgRllOh/Vs+MQdS+Vv1gZaQ3QNm8vY0Rmj+40/zRC3Tpv1NPHuji
	YyMnc/Y3b4+yRFq8Dq7vWk8vJfUebFc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HusHbLrW;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753797492; a=rsa-sha256;
	cv=none;
	b=r2tODRyBixDEMYka9F4Z/OO1ziLyesAmrEVVm++W+suANCnScBRnoXipBoD/xXWbs6yS+H
	MWAvO0SKQ2kF8c57zGcAPcTGmTrWYupDYY2pKnV6gJnxfC+JgLkH0H37NMER/Cyoxjy0CH
	yIV0SsH3y6qdQ6a7wf4OlCOi61WwXc0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753797491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rsCCUQApP9CC8DKwwUvy60D3l2hcvtSPFJWH4AWrj1E=;
	b=HusHbLrW+U50SCC3usGL62AdwYWuqRT65MtMjBqBK5G2bXicT0eA+3Z1Ey/4mjvvZEJg5B
	p5rvdh4hdriomjYTHWQx5Fbz/dxfViq3bL2bjtgx9+LCyJyQ9HjfiugUEF1INX4MVkZJc0
	NKvwqfdaPM+CKhGto8QdmAPw2MxDDlU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-unfb9nDOMsaus1dBLw2Ofw-1; Tue, 29 Jul 2025 09:58:07 -0400
X-MC-Unique: unfb9nDOMsaus1dBLw2Ofw-1
X-Mimecast-MFC-AGG-ID: unfb9nDOMsaus1dBLw2Ofw_1753797487
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a503f28b09so443405f8f.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 06:58:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753797486; x=1754402286;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rsCCUQApP9CC8DKwwUvy60D3l2hcvtSPFJWH4AWrj1E=;
        b=sGPVbTAycBJvOGBOr8IuSHUEapxSS3gUR7U2kEkX9LoY7DYZQbnVUWbNyHqXkh+AbD
         Vl+zTHha0FMHWR+L5Q1b+JjPAX4FJwGwFAT3q1ZgBiGlTUGVF1AHLK7sDScZRmYcdKjj
         Qpkuu4RxEH8ZOmmznL4l83+EYNa1HcjjxAn6e70h7syQLIxFkcI+xLAEajVaMyQ9BVj2
         t8FQGReFAUfXPml7EDg2dx/8W/YUbxtYJzG73bipdoFuxfA6zP+BjhzY3dbkQUFlRCet
         09ojS6S2pTn9iiONDQFEXYTrexGxz1CgjSaBChGX1MpPW0ee8RYIjAsEm0k4QKlIYJ0N
         6Khw==
X-Forwarded-Encrypted: i=1; AJvYcCWYf1/X/Ryv5hBbFzt3WHoxJd11wL69JUJ9KASk+8ytn4RJbUKh5L+gi/zIwLCuZlxM8paSCP9ytQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2URdUeZx2GLz4NiQHTW8N89amP3ki3uIahy0dQQd2Mp7M7dL+
	tcnCdexzwXPlfVpNyRSPdFfMjeA2C3gh4taknezsiY4IEzUBye3f48fwTVc87ii0O9ZN64LAe77
	pIEYRtQHMQJgRFX7kR4DSXq9qExjDXRuDCjoUtZgymWfwuE67PZcO
X-Gm-Gg: ASbGncuZnCWznzTvsDivIeLDcSuE//Ep/UJrRKpW29f+qA5DmlYMChkU+BxO6b34hes
	wwUqCXcuECkapZyFh8I1w90Ts7MgD6ImST810xmm9vAiWz3dfp5KmoWn8SqelfHvHXEagXyMitO
	VKbUKgK/2SUqsq4YuTIccpzS2IOJzqZgCOKN8ZIH3RzAID1Fa3SpyaNZEPGApWC4N7VyTBwEK3s
	GNh+c5WZfaEiTY45C4P+90ycIXvtUzjV8/zqR2naU6QKQi1EKk4GhnUb/NoXNoo8/kORZcms/Mg
	UCWW10DupNPFPR//+RGpFZxeWhzPLIC4ZKaMD3uRNNDhXmRNuQYfM2A3TkBvdAeVGOg6Do4O
X-Received: by 2002:a05:6000:26cf:b0:3b7:90c7:325d with SMTP id ffacd0b85a97d-3b790c73843mr1932669f8f.6.1753797485027;
        Tue, 29 Jul 2025 06:58:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH6/lwTxd6DH/vJTkaLgAGz/uaV/Fd14fWfaZW5uHWl0CIlnqV9QqBAeHRZ55YhVyNGyUmhVg==
X-Received: by 2002:a05:6000:26cf:b0:3b7:90c7:325d with SMTP id ffacd0b85a97d-3b790c73843mr1932579f8f.6.1753797483137;
        Tue, 29 Jul 2025 06:58:03 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b788f5f28dsm6505110f8f.10.2025.07.29.06.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jul 2025 06:58:02 -0700 (PDT)
Message-ID: <1c821e8c-1d9e-46ca-b0ab-3a897878d883@redhat.com>
Date: Tue, 29 Jul 2025 15:58:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] /dev/zero: try to align PMD_SIZE for private mapping
To: Zhang Qilong <zhangqilong3@huawei.com>, arnd@arndb.de,
 gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20250729134942.900517-1-zhangqilong3@huawei.com>
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
In-Reply-To: <20250729134942.900517-1-zhangqilong3@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YJT55l7lgD0osn4aWwiGDWrN1DFbY-QtRVw9wS0l1Ng_1753797487
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 83FDF1C000B
X-Rspamd-Server: rspam06
X-Stat-Signature: w5r14gxyh1io4ia9znxr36bhwc6u18qa
X-HE-Tag: 1753797492-721674
X-HE-Meta: U2FsdGVkX1+KIWHG2faK3R9M0CrjGXFfpJY3rSv4QslLT3wlFn+iBpvxNEE4xEF8iJFgrDJdP7tMZnXtNm/5Iif2sOZ9QV9z1DZwyeljUS15kZsZctHAvfqHqLjimyTAXWgIU9OTpMh2C7f7NxBAhBbfRluUVccaFqFGHce34gvkbAs50bKf0eSb2QEmvHvVF0nJWo2K46bW5EsF+Ulq5cmV2ovqJao5kIyQKrq7NHPcDOBojWCPSjKPFQ36ruF8UXfKMPxXrjLw+v+V42a289FqHm2rYYcBVdGxOReDlGzgKaJ800lJZ4sf+siacHWVc6dnuPvZqiTJLd+ag1qgsRKzI0XA+b17QMX9zhUdcVNZdedleYoBYm6AsWG0tkf7ym3M8Z5mmuq2ejMeXdgMtS77Xor8ajd2LSvQzCGgx697NkUzlvr1pFJnj6VEWbIJCTeEJi+TJV7+daUN61bnbgeWuh0RGKK7ZLb1qjYgTj3nYEuJtHM9W70gavqH2COVRxxeyDD5UUukzP8DKdfjBzI3ehjnQBsunh+a+LvEkxkgzsol/E7l841XZPul6q2t5ldHu/af70NiWMiSiCYzMQ9BKfsejhw+0tp/Gbnno7gzj6c6hczJfraHfCPY/AC10H3KPJCYM4XjBOhBzNORZJjV/jc75yads1uHGsLWnasrnv8675ZFEWSE9ezivn2eaw9TUzHOOk0OHrlUE2DxwSvtkvk00BUh0M9ng/DGEi0HaXhKITYdYjx4DyLF6C7Dcc/ohRj7CVSIEkQvjuTylrOXzWAgzEoeiADQzYnloLD84qoavG+detm/MC/XlYKUBLihSOSxIQe9qL+4CmMwsW/eR2vco17L3Vk6S0ET93MjstRg06lQ5b7PfRkL0uKMPsf2dQoDgOVdSC/LBN0Cg0DV3DyVZOqw7mfS0i6p0xLbu8FBSg2SNVjUhK4jDBF7e0MrN7IY7zfnI7CqcJf
 anD4RVmA
 F/LXCAZ0k0uOtmOTDPTdsIVOzlEAbjEzU/kuoY4OgqwoUFEXQJyPQEeDAWwOqNcL5K2wtIF78XSpOdkKMv+fp58b4uYlEEHLaPvO6/dM3ibXOdmi9xLuUSMT4uiWy8uOjcbJ9hn7nyZWGwh9l8cnWt8t0hl/Q0igEIBqQk8WKU+HYiA7Lwx3/PML8g+81DcR5nSrLE5tOKmjvCjrMr5Hssj3P6PgGP+p6oFRTRKqIOKOzn3pn6f9R6ZTInB/B3HQsci6DBY4n9wdpyCiY1DJTOlj/pfH//QH7b1iSW1Bjy2ejFme/YaR7phEfDQlhE2dq+YxznGfYFVHGGfryPVW89UPpVekmVblfu10lyZDYy49CpjMYJJwkUjzxp9JSDEdwiuHQ7uTMth/MHjywHUaIgPF8BnxiNAk7wFMj90KFiab5tS7BR/ag11tgkr5MPWHWkFdMKMYUEOUUOHKCGY+j7HFxSo+c5RV6FP5MH8xn2EYjB9qr7bUCGU/zrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.07.25 15:49, Zhang Qilong wrote:
> By default, THP are usually enabled. Mapping /dev/zero with a size
> larger than 2MB could achieve performance gains by allocating aligned
> address. The mprot_tw4m in libMicro average execution time on arm64:
>    - Test case:        mprot_tw4m
>    - Before the patch:   22 us
>    - After the patch:    17 us
> 
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> ---
>   drivers/char/mem.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 48839958b0b1..c57327ca9dd6 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -515,10 +515,12 @@ static int mmap_zero(struct file *file, struct vm_area_struct *vma)
>   static unsigned long get_unmapped_area_zero(struct file *file,
>   				unsigned long addr, unsigned long len,
>   				unsigned long pgoff, unsigned long flags)
>   {
>   #ifdef CONFIG_MMU
> +	unsigned long ret;

Can we call that "addr" like we do in __get_unmapped_area()?

Nothing else jumped at me ... so I assume this is fine?

CCing mmap-man Lorenzo.


-- 
Cheers,

David / dhildenb


