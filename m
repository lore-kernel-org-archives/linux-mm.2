Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293ACC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 10:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A27A58E0038; Mon, 11 Aug 2025 06:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D8068E000A; Mon, 11 Aug 2025 06:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7198E0038; Mon, 11 Aug 2025 06:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BEA68E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:43:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1F42117302
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:43:13 +0000 (UTC)
X-FDA: 83764139466.06.3F8C215
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2EC0640004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:43:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T9hSuZqM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754908991; a=rsa-sha256;
	cv=none;
	b=Im1rOVVYQ9RI5c9tjp8ICuq9C9UStIOoRXX1EFdkJkDpJSklM+87UEr4q1tQh9Ewte8evZ
	2x3NB3v8KAbz+7Cm5P7EWlDGajI2++kjhKXJtRqYTk1VBc8zjZ5DVoPH1lvglnY17cn60I
	VMM+QhJaUH7C7+8184KkXL22Hn+1VVs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T9hSuZqM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754908991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3YjvvbdyzhFmGp/7Kma3wP//jygvfsZwyPlqFhfats=;
	b=nfHEaX1usRN+9N2DQmEpoXFLlSSxmwIRuxG0BRC3rsu2rosm38RrW1PX6ASF4qHNI8N5tb
	mD/BjqbRM6ycaAgCm2eMZrKIZ7krWmj6blgm135rNfRtEjbdjf+NPeVGXHoIIoVuzybD36
	CCdtYBWC71GYNemvOb63/E6I+Yw+COw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754908990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=u3YjvvbdyzhFmGp/7Kma3wP//jygvfsZwyPlqFhfats=;
	b=T9hSuZqMqZhjnazUrMslebmSOcvBiyS+3ksYOi0F5ZvEHYo+RIC95VykoPsrsxBfGWXJYd
	0eanFZyiTIlDtrPFaUy0ngy7vpSIlgmN1PVOJYLVxSu4oLdYcR+SlV5dTYwVivBq9dleO3
	7FXSxXVR/lHKJ3ee4EaAv6VJcht3sFw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-i1uL4yA_ObW3IEXHbJKBNg-1; Mon, 11 Aug 2025 06:43:09 -0400
X-MC-Unique: i1uL4yA_ObW3IEXHbJKBNg-1
X-Mimecast-MFC-AGG-ID: i1uL4yA_ObW3IEXHbJKBNg_1754908988
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b7889c8d2bso2176309f8f.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 03:43:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754908988; x=1755513788;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u3YjvvbdyzhFmGp/7Kma3wP//jygvfsZwyPlqFhfats=;
        b=VLLcZxd36NXizsXa24p88Kwki8GYfN0Mj1H0gXs6bzS95DbAc2h/cn5JSzs+B8suKd
         ULd2Rggv2mRGM5neiw/1mvZX0Di/NiIzAwYF9CecJH3dNVgt6cG6W6HlwLuFvoJLJb1y
         2HZKTKk5za4AC9ojizhCpJOlC93fmPwXqTqjNA8OmNzQ+ckAvTf5e0OLfFP/gu9SCd/J
         iJbu3i+CecHyNcB1bUAcnRMXKp5wluXQ2xspB3/MOmL1jeg7kR3uDgWUnnQmtGwhdcs1
         700EuvNfErfJWiGtTsAQkjKWMZ9d7mBvqi6l71KHUSRasA2udhyH3c8O4aHdfsE3vcOP
         VLQA==
X-Forwarded-Encrypted: i=1; AJvYcCWTkDOcTUIvJh2tmvwsxrCEZqPvLXo/Icy6fJPFqcMsrUtxEC5B3whFHNv6ow7B9D41kZRde3UksQ==@kvack.org
X-Gm-Message-State: AOJu0Yy2S3cYK2JOX1YcIDy+XyyxjYeXbSdrGnrrcilLtFeH3PPaEWwY
	6GzdXI1K9yBriTOZJvBWyugBw0JSj9FcZT45PXHeDNWS1YhC9eGziOmwa6SpUQbX9zsUDAZI9eQ
	r/LyUCv0cPDAS/fRi7DrF7RZLKbpPAbXyM91dptMW5YqNdpmBy4xh
X-Gm-Gg: ASbGncszgoUv5xXpdU6vCQ950BB42drg94vqTyFLZ2mAyHIHUemJuQD3dwdpzLE/vCL
	a9Fhy76FjwqpxmbHfGIKGkGOVsGp3mxfVOr3VWRs9rbnsqv6kIw0f3wm0SyUMiURT4rYYByTyLF
	P8fvldjQc1IUjtS31O9Rf0rxuLk8S+s8H2OQMCpuWJdoZmPWDP+UfEQiSLtVffR1QOVDYqJdfgu
	2SqvRNQAApyFyfbgBlkEZgsNLPYv8qiFGXDFP+KsI8QYrBzrEqTZhi3l22BF9qUbZsFjRH2C0pM
	1qcJT+W8tkbCXG2gZJRStDqFa3RBFoBp1Grhhu+RUg9ic7sYi50aQEo3eakf/JZpTYe+e7B7676
	U1i68o5InjC3ch6mwtEepfbXO/i2ZmCmEX4eHonSmaKK/q5m9/tbSGxVqZPVmGA08ZR8=
X-Received: by 2002:a05:6000:228a:b0:3a4:eb80:762d with SMTP id ffacd0b85a97d-3b900b55fe3mr10404672f8f.56.1754908988061;
        Mon, 11 Aug 2025 03:43:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZc2pYHJDG26+kHcbxUcn2VM0hxurOtrFpvAMDZsz3M0NPAfAOBWGBM/o0246hxTeJIrYCjQ==
X-Received: by 2002:a05:6000:228a:b0:3a4:eb80:762d with SMTP id ffacd0b85a97d-3b900b55fe3mr10404634f8f.56.1754908987580;
        Mon, 11 Aug 2025 03:43:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e6867193sm249292745e9.6.2025.08.11.03.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 03:43:06 -0700 (PDT)
Message-ID: <6afa5cab-2044-46fb-9afb-8be82fe8a39f@redhat.com>
Date: Mon, 11 Aug 2025 12:43:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] add persistent huge zero folio support
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Vlastimil Babka
 <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
 <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b>
 <dfb01243-7251-444c-8ac6-d76666742aa9@redhat.com>
 <112b4bcd-230a-4482-ae2e-67fa22b3596f@redhat.com>
 <rr6kkjxizlpruc46hjnx72jl5625rsw3mcpkc5h4bvtp3wbmjf@g45yhep3ogjo>
 <b087814e-8bdf-4503-a6ba-213db4263083@lucifer.local>
 <lkwidnuk5qtb65qz5mjkjln7k3hhc6eiixpjmh3a522drfsquu@tizjis7y467s>
 <57bec266-97c4-4292-bd81-93baca737a3c@redhat.com>
 <osippshkfu7ip5tg42zc5nyxegrplm2kekskhitrapzjdyps3h@hodqaqh5r26o>
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
In-Reply-To: <osippshkfu7ip5tg42zc5nyxegrplm2kekskhitrapzjdyps3h@hodqaqh5r26o>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sKmJX0qgr8jWjFxpMHb3-kkFIEu0-f9NxJtP6ZVRGD8_1754908988
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: afeernw9hpmccbe3kbcf3asa4zajpof9
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EC0640004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754908991-772972
X-HE-Meta: U2FsdGVkX1+nbY+gOrPfAk+ELUySvrKjuLmJR9nFHWQSMVA9jRrQapvJg83ZhiQTdlah5zxmtLx4FzYu2yMMI2Nbgs10HedQYqkBrEBG28HPf1cYC6FNG77XxbQM1TBSuu128psVKuuNeWsoYcYqO+X4Hn8GRyOotXfb+9ESzcFTNrj232MQQc2QUZZZqyvlttF5OY6DqiTYSnXcUtAxxMqnQDi0KEO1bh0o7En3uPc0NkMo0AAkZx68xNqNwU1IYJxN/fsW049uo7Ke10vtCEVPp0pZUE5l8fZqiiFWgVHWWRPMMylOLDOyuimlsc6mLeXJzQt6wEaT44m9wZs2Onb/n98br7H2ktYDVAH/SWucrH6VbdZVVWGS0Tmh8sl6e70/pAjWkCAQwxysrWkgm5A1HoLODCyqv3cPOcXR2yPCtbcmCDO3Bwb04zNwA+nIDKMqhXy1qnN/CWeYB89VJzwQszVQRue3ZtO5AGZozoMIVQrQEj7OHaZwNakUuNf8YWwAsQTzP8ONuJzNQffUgcfBfuMAmlGHvW9lWzuJRwKPmd33bRUY4QIqFQwX061+He5JJUF+iF2AxX0/5JP2CIft1JCtBAhpUdYrUCxna7kfIw4YuTEM1IpqrxWt+sjToE4/QCB0y7XQlKeW8mfycUIjtXWbmhbHXRG5Wh5vfLFEogxjtwTo6YhvkEXCZd2P+OayZObwzTVQz/Z4AVZT4EiPqsLkXd6skS/zGRx1YO11wGMOEa27EpmkO8EleLFRVCRWJgsB6ncs2e++PMUuGCTQEmhRAFGwPzlPZizZADrV5KOiDzpXyNz2vyr5GY2ANttrSL0y6o0/1HxFOl04kbV6bGQL2jVvyGZrwldYG8GjjLD6KA/JOYIvOd8ewm1B8eDfEWfbfC0KP64zDI5dIkTfvqopXvf1pcmJKhnfBk3OP/2MUNDp+W4cUOzQpf1mw2x4cvrxgsGzwzYBH0p
 1wmYl1La
 DmvGTW/67nR/fSyz6Di67e9gjNmOjJANjDe2LqMF9hVmY6ml1CcqzRbDvXMTA8mQ8sS4Ae3LEIMp8+h9bzz35fKixGQima6/sN6JIeRmKUp/TeuPbxioZqzZynwR+5G9aFF0X3J4+TJ5blOjVz9BjZM3IfZNBqd3+zwlcHuNHCUe2LDq7O8lzFDMPS1eCjbh/QJRKGepOHkYJIRjKzWDR3tveaP+uyq0+KRH2RMAvXn2EbjCMLs27kAV0Cuxvq7zPLGut1CtKRp2zJPdHFls1TFlhn1/cBdCW0rKF5bTxl9GAoTqkZmfklpWNzX93ru3WowCuho7ufvjXS26G9yM2kHQH6wTTdr2Nf2BZkd0UISb+HKFf3EhgvfLTh3U/dCV/QRcionX7GMsf0gDpjsadrToyvCjzITmlaZ+7ubD1kyfasV8lBvDpCwlIwqFfSizSq+rxbGCVr9E9xoheXR6HI7dl9vSLPHY8iM77C1z4HSIqRrx0UaKmQ23Hi6f/JQctWYRxp7C3ZsooQ03yMgE3KJ3TNfh/kStISnjZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.08.25 12:36, Kiryl Shutsemau wrote:
> On Mon, Aug 11, 2025 at 12:21:23PM +0200, David Hildenbrand wrote:
>> On 11.08.25 12:17, Kiryl Shutsemau wrote:
>>> On Mon, Aug 11, 2025 at 11:09:24AM +0100, Lorenzo Stoakes wrote:
>>>> On Mon, Aug 11, 2025 at 11:07:48AM +0100, Kiryl Shutsemau wrote:
>>>>>
>>>>> Well, my worry is that 2M can be a high tax for smaller machines.
>>>>> Compile-time might be cleaner, but it has downsides.
>>>>>
>>>>> It is also not clear if these users actually need physical HZP or virtual
>>>>> is enough. Virtual is cheap.
>>>>
>>>> The kernel config flag (default =N) literally says don't use unless you
>>>> have plenty of memory :)
>>>>
>>>> So this isn't an issue.
>>>
>>> Distros use one-config-fits-all approach. Default N doesn't help
>>> anything.
>>
>> You'd probably want a way to say "use the persistent huge zero folio if you
>> machine has more than X Gigs". That's all reasonable stuff that can be had
>> on top of this series.
> 
> We have 'totalram_pages() < (512 << (20 - PAGE_SHIFT))' check in
> hugepage_init(). It can [be abstracted out and] re-used.

I'll note that e.g., RHEL 10 already has a minimum RAM requirement of 2 
GiB. I think for Fedora it's 1 GiB, with the recommendation of having at 
least 2 GiB.

What might be reasonable is having a kconfig option where one (distro) 
can define the minimum RAM size for the persistent huge zero folio, and 
then checking against totalram_pages() during boot.

But again, I think this is something that goes on top of this series. 
(it might also be interesting to allow for disabling the persistent huge 
zero folio through a cmdline option)

-- 
Cheers,

David / dhildenb


