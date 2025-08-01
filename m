Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739F6C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 15:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9D66B007B; Fri,  1 Aug 2025 11:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63F36B0089; Fri,  1 Aug 2025 11:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04996B008A; Fri,  1 Aug 2025 11:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A98F36B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:49:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C23D113626
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:49:21 +0000 (UTC)
X-FDA: 83728622922.01.679EDB4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id D8B54100008
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:49:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aXmYBipX;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754063359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Az/lcHresqK+moKhYaM464MNdTcCwiYM0QUDNB9aXcU=;
	b=5MxcLr35T6h8hRhHZ/qbTJ1CrZRZBv0AnoicEsLR351M+ugtNAMZv+PWmTh0OgQj8lDzwm
	qktjbCPDv+eiiAgGoaRCeVznCDhh9zNt+2QS0ZP/SRpMWYOQUrU2ZP0O/NHSMgFMXN5rwr
	0dvZsIZLo3GB3DDsgesYrDsJZH4VNFo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aXmYBipX;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754063359; a=rsa-sha256;
	cv=none;
	b=elcqYC76noNZW5e88Urm8Kzn9cdO6j7Of1OMlp1JxeYhpoYKNHGd4m14KiaKT+tWXmDZEu
	t/mWQVdcLSR5J0v1vbmQslyBhE/nnWs3/I8kesTzPsw/NY8KIetaNbhh+ynvzWqwjq+r/w
	W3fkzUBWwAWgSvOV7MHVnaugGV5Mkkw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754063358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Az/lcHresqK+moKhYaM464MNdTcCwiYM0QUDNB9aXcU=;
	b=aXmYBipXOBWoM1iBeEG7ILuHxIZCkijR2kn0eDjMexav3nohdpXCPmY1QAYGnsaoN20pZ+
	aeYuLyoq0eGBw41kOPIb3WLKuXoS/w1618PHVwjAl7HWbZM7fmILrQs+PeIieZeDDa+FVn
	I8A3QjKH0TxMLZiGIwuuigAciAJGNEM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-iN58_KsXOQOV9emyJ7DFJw-1; Fri, 01 Aug 2025 11:49:15 -0400
X-MC-Unique: iN58_KsXOQOV9emyJ7DFJw-1
X-Mimecast-MFC-AGG-ID: iN58_KsXOQOV9emyJ7DFJw_1754063354
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b79ad7b8a5so1556006f8f.3
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 08:49:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754063354; x=1754668154;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Az/lcHresqK+moKhYaM464MNdTcCwiYM0QUDNB9aXcU=;
        b=buIMe9DcelAOjHTT+4wmVv5NVvPMN8HBt7tCnf9C0zhEWu9ME6OqXguGUc+ebKfCno
         zrb+n1GiHwsHJm89cCPe0S6jbnhnCT9w6AzTPpakQdBlMNQVIifRJ7m2XPHIn4lOqRCA
         5ddbUCmAQqzGzN9SFOoC623K8yfM+xUvfQ007xy1nQGVIPkAyz/56lE8NaHfimsxX5hk
         aSprN9g/nqiym3fZ3jyAs4jvh4BiTDkm/us/ezXrhe/Tk2Ne3QyzVWa3LlgHZ6+uthFS
         NgoZ4OI6JKXd22SDE8gMwsaEpmBL4Tz3xZCLfI/SOrqa62r+NhApGsCFHhUnz9Dv6yjg
         rYmQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2Gc1KCQYVPf50Jv/GQTkyK6/LeIjn6LmuNXtMi5bTnp7tWzaOF7cBMNUqg4rzys2Wyt6qJ2qLhg==@kvack.org
X-Gm-Message-State: AOJu0Yz/s2TCF8nLgXUAHap+aaxVzow32Mh1SBiR14FejWJe490eoFgp
	zelxBkKeDl0hK5ZRa9yZ0Dr6STcL36V2LqdH7dLuSH5cdz7CWSC2yslfwYGrGhPUodgfY1NpVeU
	QSlQ1dYABN93dMPHU+SfuVRYVbWooklrpCdhCpSxLfowwmmStVRkQ
X-Gm-Gg: ASbGncsZ3YoNnzpWI7es/u15qmuhWdJOsuYLS0bRHgM0Z3fXldj0b4kXJz43YXMUf7w
	QwMgFuUkEz/094HPG35cSlgGJfn24KpFudVWUWh1S76wLzsPNGJgbCmYKotwrxbnt+tm7yxB+sj
	Ua62vEUcBfQR46+tGWuji/ZKqG4WVJ47OWbcyuIG4QMDGDJqWoi76cA/E8dtnRdVY6yNiLmDdTN
	Edn6yLHZbbBfWuSQZUfFjOgmAZ4q+9AXgw+zlbcUBUrFpYsjuTFP4aORgC9ncjjaTnS8PN5Uax2
	XYgqYvvvzhq/nSn30+vRPp9w7bz1gazg17zNd1gfr4CP1fghPb+vd1RLhbGl8yzAfb9uGSao33/
	dI8sgmTj/t937+QFRMvzXGv+DaELJLnqizhzdraXi6gEhhT7xtyKAPM501ItoKUW0
X-Received: by 2002:a5d:5d0e:0:b0:3b7:89c2:464b with SMTP id ffacd0b85a97d-3b8d946ac69mr243872f8f.5.1754063353690;
        Fri, 01 Aug 2025 08:49:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2DBedDYQ23+gwq7i61urTwz0CARF2LptKXy1Zi0AMl+j8e9WYtV69W+oHsDf1pQvk2OOq0w==
X-Received: by 2002:a5d:5d0e:0:b0:3b7:89c2:464b with SMTP id ffacd0b85a97d-3b8d946ac69mr243821f8f.5.1754063353088;
        Fri, 01 Aug 2025 08:49:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:7500:5f99:9633:990e:138? (p200300d82f2075005f999633990e0138.dip0.t-ipconnect.de. [2003:d8:2f20:7500:5f99:9633:990e:138])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4818c1sm6216272f8f.65.2025.08.01.08.49.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 08:49:12 -0700 (PDT)
Message-ID: <d8899e72-5735-4779-9222-5f27f8c16b80@redhat.com>
Date: Fri, 1 Aug 2025 17:49:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 2/4] mm: add static huge zero folio
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org,
 x86@kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org,
 gost.dev@samsung.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
References: <20250724145001.487878-1-kernel@pankajraghav.com>
 <20250724145001.487878-3-kernel@pankajraghav.com>
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
In-Reply-To: <20250724145001.487878-3-kernel@pankajraghav.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7xue1pBZO4aF7ztm5R2zfX5Ng7oPG58QGbD04Ab4L1U_1754063354
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qgpr4g1joc358am98npi8p5cswt6brp7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D8B54100008
X-Rspam-User: 
X-HE-Tag: 1754063358-222129
X-HE-Meta: U2FsdGVkX19FYKe1KbI0awzubZQMRLEziRCybU7Eg1enuf64cEhrs7p0U4eAEF03pCIpAOx/NlbxNLp6HQx2WnimyfXSs977Z1K5eeDWcPl952HW73DWXE7DQMXIP5j/qEq2Wf3d/iOkmy4vTYMpQKzcI4OBl70Al+12HTHxhJ222myMze1mu0EJ+plEvmPnBUV5D2RYjxZCAePicn0avhALwHsg1f2r2XuF9rGWzNGJ+CAnXa3zc67JI61F/DCKEyTwjDnP0xLs6lPO9bWpARCZbcY1NUPNSuJM3TpR9MSdjjI+PMesMRbSDInsKFqXMz5u44GPOGgaU1Feq6ojRlwOQc4etjyEBTgu3VteaG3MrbScSiYsYPtv9vJyGoyFwFNxfwvSBH7TayV8SXTDuMvgb69bNQrMYuZ0NlJ5jEOUtGc0Kp04tDaD30/tix3vg6ZhFvWVtUuP1MsWyExLGXFlpNjhP0XNAFIgtCqfyKPHfFUl2Zz8ZuEMopn7b7HjaQqbS0jnPI0ZMZWI2jLBGa8vvAglurxFAYGdGCkd7tNIZ4woa5vbmR2e43YYZId6uMbGNAYL5FQPBYh44XCEJkUEA3bz5bTiJV2HcyHdWCjX5JeKOmkUzhsYT7S2vpFZCg15GcjdAWHo0oHhZl4AjHtIPuSAHAlhF9K4aPIt4nY5LG2ZfzdtquNXTxURCNsOX5dtZk/Rxv3nA69qzAOHEK6tXAwJM5HFc4Oh0ouM5hje8A8jDCCwUmC2QZX01nf86afnQ8HgQq1CB43j9BlnuFkKwcU6YfuHEIuQQKq9p+k9cymSAEIyjYhCBv4XGbUcXpbt1eIka6LtMgXCyVxLYeWsC5t2oe/bb4FsYyY9jd89O474DUgsIpwNG0I82tTRr7PAfda0FfD4K6K7XAEPsiH5PZzcAUZ0ST2BtV9sQN8HPbH8lKUS7Cd2g01tbOF7TD7DMsK72yStKXlYxbs
 X54yxBD5
 9XpHZmnX4cmsoyioC6gORenprcT3fribp2cViUlaZU2QnuBzurPjsBpXU2MqFwLRk04nbPkbsjQgtFmB6aE2pGusW/lV8zJ2dYTJbI4pwlXaM4UHwihgQtA/u6XRk8qgUvVJCnQtgI3kDqUJ+QRBBuASS4yyrc6M10OaFlYTw/cuAyMAuws8FRZoGJc1Q452K1xZc3YZsLU7ia7UXXG+Nx8h07+sqjFSDy/wC+/afSKq76SOAkzwHLXuGYBrayrW54xv8p6uHe/dCo6yXqYh6oZd7+VGGy/u7CnZBQuGCL0RS/LdkB544O7Ayl62B9u1HDMmpeABaxy7l6ZpwnUAhU1Ij5ZmQKDMo6Rx/9EJLtqwpAr7IVd7pqHZEdV9Q+xVkiDT5nmFgsLHMVSg9fE8qLEFABiZ4RpFuOOqLTLvY3gofuQ/a0s40zGc0uXE8pAzrSR+X1kmUEIXvPGVFzwAwjvsVL+sdhLv5n25Am5oLuRKpBUagfEyZFRIxE54zpq25qhoiA+0K1SRO1rNPxrs8c98pIbeXcBnjcM6jrvmOU4yGpBrBDxSMUjxJl1+8gx9/mP+8M6VnsDggVXiRVN5fNuxjyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 16:49, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> There are many places in the kernel where we need to zeroout larger
> chunks but the maximum segment we can zeroout at a time by ZERO_PAGE
> is limited by PAGE_SIZE.
> 
> This is especially annoying in block devices and filesystems where we
> attach multiple ZERO_PAGEs to the bio in different bvecs. With multipage
> bvec support in block layer, it is much more efficient to send out
> larger zero pages as a part of single bvec.
> 
> This concern was raised during the review of adding LBS support to
> XFS[1][2].
> 
> Usually huge_zero_folio is allocated on demand, and it will be
> deallocated by the shrinker if there are no users of it left. At moment,
> huge_zero_folio infrastructure refcount is tied to the process lifetime
> that created it. This might not work for bio layer as the completions
> can be async and the process that created the huge_zero_folio might no
> longer be alive. And, one of the main point that came during discussion
> is to have something bigger than zero page as a drop-in replacement.
> 
> Add a config option STATIC_HUGE_ZERO_FOLIO that will always allocate

"... will result in allocating the huge zero folio on first request, if not already allocated, and turn it static such that it can never get freed."

> the huge_zero_folio, and it will never drop the reference. This makes
> using the huge_zero_folio without having to pass any mm struct and does
> not tie the lifetime of the zero folio to anything, making it a drop-in
> replacement for ZERO_PAGE.
> 
> If STATIC_HUGE_ZERO_FOLIO config option is enabled, then
> mm_get_huge_zero_folio() will simply return this page instead of
> dynamically allocating a new PMD page.
> 
> This option can waste memory in small systems or systems with 64k base
> page size. So make it an opt-in and also add an option from individual
> architecture so that we don't enable this feature for larger base page
> size systems.
> > [1] https://lore.kernel.org/linux-xfs/20231027051847.GA7885@lst.de/
> [2] https://lore.kernel.org/linux-xfs/ZitIK5OnR7ZNY0IG@infradead.org/
> 
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>   arch/x86/Kconfig        |  1 +
>   include/linux/huge_mm.h | 18 ++++++++++++++++++
>   mm/Kconfig              | 21 +++++++++++++++++++++
>   mm/huge_memory.c        | 42 +++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 82 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 0ce86e14ab5e..8e2aa1887309 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -153,6 +153,7 @@ config X86
>   	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
>   	select ARCH_WANT_HUGETLB_VMEMMAP_PREINIT if X86_64
>   	select ARCH_WANTS_THP_SWAP		if X86_64
> +	select ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO if X86_64
>   	select ARCH_HAS_PARANOID_L1D_FLUSH
>   	select ARCH_WANT_IRQS_OFF_ACTIVATE_MM
>   	select BUILDTIME_TABLE_SORT
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 7748489fde1b..78ebceb61d0e 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -476,6 +476,7 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
>   
>   extern struct folio *huge_zero_folio;
>   extern unsigned long huge_zero_pfn;
> +extern atomic_t huge_zero_folio_is_static;
>   
>   static inline bool is_huge_zero_folio(const struct folio *folio)
>   {
> @@ -494,6 +495,18 @@ static inline bool is_huge_zero_pmd(pmd_t pmd)
>   
>   struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
>   void mm_put_huge_zero_folio(struct mm_struct *mm);
> +struct folio *__get_static_huge_zero_folio(void);
> +
> +static inline struct folio *get_static_huge_zero_folio(void)
> +{
> +	if (!IS_ENABLED(CONFIG_STATIC_HUGE_ZERO_FOLIO))
> +		return NULL;
> +
> +	if (likely(atomic_read(&huge_zero_folio_is_static)))
> +		return huge_zero_folio;
> +
> +	return __get_static_huge_zero_folio();
> +}
>   
>   static inline bool thp_migration_supported(void)
>   {
> @@ -685,6 +698,11 @@ static inline int change_huge_pud(struct mmu_gather *tlb,
>   {
>   	return 0;
>   }
> +
> +static inline struct folio *get_static_huge_zero_folio(void)
> +{
> +	return NULL;
> +}
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
>   static inline int split_folio_to_list_to_order(struct folio *folio,
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 0287e8d94aea..e2132fcf2ccb 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -835,6 +835,27 @@ config ARCH_WANT_GENERAL_HUGETLB
>   config ARCH_WANTS_THP_SWAP
>   	def_bool n
>   
> +config ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO
> +	def_bool n
> +
> +config STATIC_HUGE_ZERO_FOLIO
> +	bool "Allocate a PMD sized folio for zeroing"
> +	depends on ARCH_WANTS_STATIC_HUGE_ZERO_FOLIO && TRANSPARENT_HUGEPAGE
> +	help
> +	  Without this config enabled, the huge zero folio is allocated on
> +	  demand and freed under memory pressure once no longer in use.
> +	  To detect remaining users reliably, references to the huge zero folio
> +	  must be tracked precisely, so it is commonly only available for mapping
> +	  it into user page tables.
> +
> +	  With this config enabled, the huge zero folio can also be used
> +	  for other purposes that do not implement precise reference counting:
> +	  it is still allocated on demand, but never freed, allowing for more
> +	  wide-spread use, for example, when performing I/O similar to the
> +	  traditional shared zeropage.
> +
> +	  Not suitable for memory constrained systems.
> +
>   config MM_ID
>   	def_bool n
>   
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 5d8365d1d3e9..c160c37f4d31 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -75,6 +75,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>   static bool split_underused_thp = true;
>   
>   static atomic_t huge_zero_refcount;
> +atomic_t huge_zero_folio_is_static __read_mostly;
>   struct folio *huge_zero_folio __read_mostly;
>   unsigned long huge_zero_pfn __read_mostly = ~0UL;
>   unsigned long huge_anon_orders_always __read_mostly;
> @@ -266,6 +267,47 @@ void mm_put_huge_zero_folio(struct mm_struct *mm)
>   		put_huge_zero_page();
>   }
>   
> +#ifdef CONFIG_STATIC_HUGE_ZERO_FOLIO
> +#define FAIL_COUNT_LIMIT 2
> +
> +struct folio *__get_static_huge_zero_folio(void)
> +{
> +	static unsigned long fail_count_clear_timer;
> +	static atomic_t huge_zero_static_fail_count __read_mostly;
> +
> +	if (unlikely(!slab_is_available()))
> +		return NULL;
> +
> +	/*
> +	 * If we failed to allocate a huge zero folio multiple times,
> +	 * just refrain from trying for one minute before retrying to get
> +	 * a reference again.
> +	 */

Is this "try twice" really worth it? Just try once, and if it fails, try only again in the future.

I guess we'll learn how that will behave in practice, and how we'll have to fine-tune it :)


In shrink_huge_zero_page_scan(), should we probably warn if something buggy happens?

Something like

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b4ea5a2ce7d2..b1109f8699a24 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -277,7 +277,11 @@ static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrink,
                                        struct shrink_control *sc)
  {
         if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
-               struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
+               struct folio *zero_folio;
+
+               if (WARN_ON_ONCE(atomic_read(&huge_zero_folio_is_static)))
+                       return 0;
+               zero_folio = xchg(&huge_zero_folio, NULL);
                 BUG_ON(zero_folio == NULL);
                 WRITE_ONCE(huge_zero_pfn, ~0UL);
                 folio_put(zero_folio);


-- 
Cheers,

David / dhildenb


