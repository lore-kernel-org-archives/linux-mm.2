Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9AAC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 19:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26F476B00A1; Tue, 22 Jul 2025 15:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21F906B00A2; Tue, 22 Jul 2025 15:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7A76B00A3; Tue, 22 Jul 2025 15:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF2EA6B00A1
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:54:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E328B9C2D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:54:40 +0000 (UTC)
X-FDA: 83692953120.22.B9D8DCF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1718016000B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:54:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CCObwCDj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753214078; a=rsa-sha256;
	cv=none;
	b=LH2H4CHnsuIhT8XaU/M9AxUAX9/PDGMrN4fzCGbidLJ1LwBN1fW0Z8eYrXWMLN8ySngbnF
	3gN6nicc3/4c+FJTUXJQibP/i+5uDLFQByqW0QIBeM+uPEES2WfT7A2RCpUQDR2ztk/AcK
	k8+ED971piCCEK0ZbMPLTdSWfrqJxMs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CCObwCDj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753214078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hJEsJDHhhwgP15Evw5sJRye4NRXtior93RLURfMCjSk=;
	b=ro0RKjb4iP9N9MgVZ7Q0IVbgBgfttfnszHakt9FpAASGfc7ml8f5Ta55HmPuyievqvbOcO
	e4pUsHM3efAJ94C7f3aWJtnow9KohWeuCgZQqaBWhgsjw1NJH0KqttGxqvqGN2DDDmV948
	5UkBY7cWfpWTKU4sE+JGz7C7G5IpaWI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753214077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hJEsJDHhhwgP15Evw5sJRye4NRXtior93RLURfMCjSk=;
	b=CCObwCDjPQX+11BvwXoK8Qq9QY1E1ltgNn4stLCErU164e7EngRk19E0jaFjaEyEUWAed4
	tJ5ecKifmjUTrev942ytivNS4MpHyUsm5gBWSWWAWhSJzJk0CjgDntdHMHWPiA5ec4STBU
	uYTh0nEBmKXB4c9kII4Pu87oR2HmvfE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-01JEEmkFMUWFVjZiqFZTyw-1; Tue, 22 Jul 2025 15:54:34 -0400
X-MC-Unique: 01JEEmkFMUWFVjZiqFZTyw-1
X-Mimecast-MFC-AGG-ID: 01JEEmkFMUWFVjZiqFZTyw_1753214073
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4538f375e86so54324775e9.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:54:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753214073; x=1753818873;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hJEsJDHhhwgP15Evw5sJRye4NRXtior93RLURfMCjSk=;
        b=aFw044fpwSjpuZtYwvpzbp5symuYpnu/HDbQllY0lVxckPcRGPMHDBdHoeTy0y2Yxy
         tpOVelNSoPJks0dMgzN9O3tk9QPU0xZUv4I1qmJnI086y+IX4KigAqeoY4FjLcH74rBR
         yrukP8/QhTmi8wVyhEn4dK2jPmE14rGPAK1Nn2Xsa1mupd+p+GNx8MM/83c5OmQ01upn
         EGs/QEVXH0+VaIxq47GSv3whFPwZpBkA5dI/vZCbWbl7oybVPWJr4hQiWijmRkotZUl1
         7HjY52VSdPnAt3ihBaE6ugUGiadtstXK34KFmxvEAzpcgD27FjatAsDXH1t0W7Dx+4R1
         wLSw==
X-Forwarded-Encrypted: i=1; AJvYcCUVjrgz+IYnstQdMex9E+L75LrLjySAKAMTDaKeaG2cHxUOHEjqvXpsBIBWnaRTzX4Ndy1+XV0l/g==@kvack.org
X-Gm-Message-State: AOJu0Yy+HkUt+KjYkzDPVyxKJvw/K0PAahjq1es045Mk1KaAalQJWEbc
	qvBVB7A3rIb5BCcUT7OLiPWEsxK94V0dE1KiPzER7E4bucXgYkeCThnv0/hZSLeQBJ3yniJ/7Ho
	tVqN+RyoaQOR5y9RLs2CsGDE9TmuVYzd7pnwkUs1jBu/+2Iy/1Fn+
X-Gm-Gg: ASbGncv4gjw68Tfvt0XawG6Clb4Rb2kWmsEZTisLccVGPSzhjYbfBkm32evk5C9gKpd
	1j9wWb1EHBzL5EwodZCKOVXIoXp9fRL1IQA5Yqw35ihkbmnRs68QMTqajlFUJACFImX63oWh3mt
	hNjWY3esWRqtvtN5sEy7P1KiTIxukSg1D1PMsuyx1/FOXL/I7m/ZoZr3xfHbcyV+kcV2WaCHPvp
	1J3OsF3tTg9sElqhSUcGjupIkt212nsr45OdtYidtye2JeeqYPyjTskPk8ZieKZ8In1FePL9RUA
	xO5KCi7Ggms8QIB97dJGdooOh71r2AySPM/tOh++KPtJ4PIQ9Gh10SzQqCfKWCPjqfHe23NreS8
	tzaKEaTwKT2KAxeYwTQjaZmQPvFlSo6PlQ5wOZGjoo2KPBHWZrl19iAdMTW9fLLcDloY=
X-Received: by 2002:a05:600c:8b09:b0:455:ed0f:e8d4 with SMTP id 5b1f17b1804b1-45868c97796mr1266185e9.10.1753214072879;
        Tue, 22 Jul 2025 12:54:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHy8bjruloOQcKDEXBOSsxE2UZXnksvKYgU7LFIJ6YJhSijB+BvbfxvrDV+WVoYprggwmv3nA==
X-Received: by 2002:a05:600c:8b09:b0:455:ed0f:e8d4 with SMTP id 5b1f17b1804b1-45868c97796mr1265835e9.10.1753214072410;
        Tue, 22 Jul 2025 12:54:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca48719sm14470065f8f.47.2025.07.22.12.54.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 12:54:31 -0700 (PDT)
Message-ID: <551c7f1f-93f2-48ff-ba00-259bb2c391d7@redhat.com>
Date: Tue, 22 Jul 2025 21:54:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/4] mm: rename huge_zero_page_shrinker to
 huge_zero_folio_shrinker
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, willy@infradead.org,
 x86@kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org,
 gost.dev@samsung.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
References: <20250722094215.448132-1-kernel@pankajraghav.com>
 <20250722094215.448132-2-kernel@pankajraghav.com>
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
In-Reply-To: <20250722094215.448132-2-kernel@pankajraghav.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YA1dAmKQJYQ1ygc1b1iTvxmzkAqmJAYJULktykA97co_1753214073
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1718016000B
X-Stat-Signature: uo79zq3qudihwdakj74be1q15fi4xi5j
X-HE-Tag: 1753214077-32552
X-HE-Meta: U2FsdGVkX186a52n0uZWshyoq9Hdrv9iDqanvNp4GY/rCz0xgV2MWROoWSO6d+sUIjhvn7Z1MRnY/1jPRktPVl1fi8MJLFGo8LeSh6RFPHhd8LJDFHOE/Y59EeJ7KP/stVVfNjecb2kQ9nHC+VKUIXM+PWo0yeKhXRSn62CZ9ck1dvKqs8aNIWcuaSVMkDw7kBFfuS7yTp7CV2unZ4SoJ7oHOl3yq493hfGrmzBSiqRQUDxS4/ZNCLHWjFpJZRh8Cwo+s8auqetiIfqiyAoMXWsKoyHy6VBEbvQ09+Lu78FORmFR68kAqmp+FmM/A9KLc2EKzbafbnXhYtKc08ABYRnyOLFDpHs7fBZOtRspQcIXhaPclP+rLq43wyrLhGJ3lz5X0XNhyzDubMLduJl+f/a/yv8xPpptBqT669Hhiese7yBneHLU4pWp948+WwfOnDDKCdE+2KgVXg+Mi6yubnXlIcK6lAJRAQpz96eyUWkZ3f9bTr+Bl6e06BWp68NzvVue/Ecn4I9joPCBP0kytXbP9YGLusq52c/JuAOg2uthw2pXzcK0ifok9PNzhYeaAYEL+QdBbWneYkQfTcVxW72Fa2Oewhny6CSwDQSkqWn1aJjijTrsXPrQvw+yHyrNF4rwAKHUqJFHpOUnZVK7sHvqRXZM9O5DTa29pkjj/0ispQ8OIG2mn/E8b40NdoX+U/NDKqqcolXW2LNGCo7i1hNQ8A1R0dy9h22c7SaY/S+NfG/b6+BwUoWb3jQ3NE/pZrI8LDG+zmlazplDKZTDtOH0Rx1Sv6sf3wKtFz65Q1Kl/AUGXVOV1Xbwhq/XUue2Be9yrYEFW813XWoqbzP+Kk5nOXr0IQU4B3+TymGQtn4/lqvupG6+A7X6yzr/RNhr2CMBUNmfmZSoNAtK3tUuE93hwpLqsagfhTQHbfRnMh9FELWusCEBiF46QIMWs3mLbsDm7bmlPtaBC4rDduR
 4s4oZa3U
 JAKJS0dHWq9jREZgEZqzoIXin8SLX54J6+ZunGrEFxScafcxfjLhmqHV7/pdxCim5uvCGc5l0KYBhvPTR+YFHOYcfzbEEAZe3dI1wsQ8ELkcUbg2FSDoWleTCeXU27+6Ofus/J2nJEB9SpVVjlrMiY00rrOQ4XsQkzCVcyV1AiY+227iZAOzwpt+zoI9r2FcSLlBEzOzYUnlDk0Ko1Z6I0Cx1k3n90mS0vjf5azKRAJz6CA3rYk0MOOGpMz6U1SfB7rwFKmRdji8sNu7+EUAMVmIacegEq4i2MJY3wX4V67Z95dcTFHLHSjjK3pJtTO30q34eNOee9UrDuJJLHdBPTjVJL+6Sq5f7ShwP3sopIrQdsGTExPc7DtegNqjJqMJkisFj0ZAcwbnmEAubrkce2Jhgm27VgfpEKplUai3smmZKbL7OdWfxd91+t0pwMmIkIGsjcmEQNEhDcU0eDVbJ3THgpuorvFbz0dA8mxFLrLsw8G2+7Lr1BCfmxcwbGqJ3MP3kuXpRRFSRT4YoiT8REDmj6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.07.25 11:42, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> As we already moved from exposing huge_zero_page to huge_zero_folio,
> change the name of the shrinker to reflect that.
> 
> No functional changes.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


