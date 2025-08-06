Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82242C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26AC66B008A; Wed,  6 Aug 2025 08:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247386B008C; Wed,  6 Aug 2025 08:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10A226B0092; Wed,  6 Aug 2025 08:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 016086B008A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:24:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A743F1404F2
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:24:38 +0000 (UTC)
X-FDA: 83746251036.10.1DD616E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4C53A180004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:24:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GwjFmu1i;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754483076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIyj2Wn/9XHAni6aZsxrY9Shasga7/OI8hKW0Eid1vw=;
	b=g8XDeb1Bl5CPrg5p4dNWFGs06wbDBicJYHro12zNG7Dog0O8DVGQ7/eYvLJ5KPAujN0bbb
	5gawF/3OezhNGPqrSYj58WCgd3bBgDh6atPRHucPoDblN/rpi2M6I0PfoGPJJs3DruL/xE
	5N1LLGk+7vg4RvuUEZvR4cIC/7cxK40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754483076; a=rsa-sha256;
	cv=none;
	b=UX+Ju3OxLdwlCymfXkiPnd+YvPySyZ3Rk69eKPfXYs/VpvLYKZAasjokT4WS93vICuQIT+
	1e3Up8VYQdN37QiIWaRcBX7VMHLT2THh+G91R4d/20PH48Pi3jnV2b++q1Za/xz8DvNS0H
	y/1zppjf3Y2aAP2fAKikhQ7o15g4Gq0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GwjFmu1i;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754483075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MIyj2Wn/9XHAni6aZsxrY9Shasga7/OI8hKW0Eid1vw=;
	b=GwjFmu1iMqnmrfGSre884ZbD2FSd5WgptzCu+HT50L2yEe4cer/UQQF7GfP9y92sDAROPY
	dMC4JgOSEWq6jgZUI2Sp70cws5HPeJZ5e7hLT9iiLbkK6N8OHsIzemVcAwkzrvxKnXIOTE
	ND+nCwrofGllKp2bmEAozsVbibPNbxA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-dGpDjzLMOUC4UwnGBblV2w-1; Wed, 06 Aug 2025 08:24:32 -0400
X-MC-Unique: dGpDjzLMOUC4UwnGBblV2w-1
X-Mimecast-MFC-AGG-ID: dGpDjzLMOUC4UwnGBblV2w_1754483071
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b78329f180so4710533f8f.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 05:24:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754483071; x=1755087871;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MIyj2Wn/9XHAni6aZsxrY9Shasga7/OI8hKW0Eid1vw=;
        b=QA577k8sy89TEi5aKwlI7hT7P5NI0wPsn2NN/a5Ac9euNYSrpJR94a8u/EoEkRddox
         HWLGXQpfLwR3O9dAWj3Vm08OzyId/hc9YPH7mIs2bRkIiSUYxZ+t6Ni/MlqckxjorfBh
         n1AqtL6fWVb7ITyc6HPYLNwL0KJGXauPZwdUqq+xNRtGIOKoqmp/8GWdO6QwK0zz6G+m
         QcY9ninTHa28RZuu29jfH6mBi8S1QkEc3+OQxhGfSq0NoxaLVmcDs009qwtMTo1OekRK
         EP32D7k8Mhy81EwNglP/nUGW57G1A34laKCnlnom1HAArhHSkN/HBWItvxmarJFliBMO
         bVfw==
X-Forwarded-Encrypted: i=1; AJvYcCU6Rbj3CyuESE+a9uvsJTIcTW91g9Y08E3gyX8+8ddBtA70yz9HmxsAOSATcLmuWm/7lOGz6B3jyQ==@kvack.org
X-Gm-Message-State: AOJu0YzG+0yhZRkYq8TQfYSvju5QiaJe4va03j5v0xzZyPvZLfKRXjG3
	JCyqns6vu2PPUzvcK2X1XA7mUOuiGvvwjUBaJQ75dMTC80PQQLffCyJdp8zHhVHxKsAvJ8yxWRc
	SKenCRCqR4NoiZi4DCaaIGxJcYuQaICcRvqmpDm91qyZvWbGIYiqY
X-Gm-Gg: ASbGnct1VB3y0OkAxJrk6IP9/P/vEPWsgWLlkNDMVucY6rFSct3btOvj01bHZO0d8jR
	/kAAT4qplMHhz7M922F2bfWC51wBO9unZKSee99xZwDODHpkrXC5gStQrz+XBBZjJwRxZWYCD0F
	/lu1mhvhED6qeh17aFkzr8LOy36KM1Mgms4DbaECgR9k2VEBtTISlwvstbaY60XixFj4+gT6dgH
	HhT+PfIkncEtZeYCBRxuzJSjfFQ8r1ynYrhUKxxaymTQIk2NTwUFHOMwznK8gxoB7Evpohl3hLW
	skReGB1IxQrAcvnn/IKRFotcbYsGCPiWnOZqjZKeQwGTE4oH71ILLRBzUBiWb/GFgBZ5NuYQH7Y
	ee6Wp6td28BWlwOxMCLv31oEJaH0xGAHXitSluC7PUqFFnyNDJ27f1BVGw6ruNVZkV7A=
X-Received: by 2002:a05:6000:4027:b0:3b7:8b2e:cc5a with SMTP id ffacd0b85a97d-3b8f41b503dmr2340138f8f.40.1754483071332;
        Wed, 06 Aug 2025 05:24:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbbEMbCT2awtezRB1880Ia/u3kJMAjx+ivYlRRgkF2JNcEjHJ04sShVIDm9LiLrdVjbATLeQ==
X-Received: by 2002:a05:6000:4027:b0:3b7:8b2e:cc5a with SMTP id ffacd0b85a97d-3b8f41b503dmr2340112f8f.40.1754483070912;
        Wed, 06 Aug 2025 05:24:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3bc12csm23360857f8f.28.2025.08.06.05.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 05:24:30 -0700 (PDT)
Message-ID: <e67479f5-e8ed-43a7-8793-c6bff04ff1f4@redhat.com>
Date: Wed, 6 Aug 2025 14:24:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: add static huge zero folio
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>,
 Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, willy@infradead.org, x86@kernel.org,
 linux-block@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-4-kernel@pankajraghav.com>
 <4463bc75-486d-4034-a19e-d531bec667e8@lucifer.local>
 <70049abc-bf79-4d04-a0a8-dd3787195986@redhat.com>
 <6ff6fc46-49f1-49b0-b7e4-4cb37ec10a57@lucifer.local>
 <bc6cdb11-41fc-486b-9c39-17254f00d751@redhat.com>
 <bmngjssdvffqvnfcoledenlxefdqesvfv7l6os5lfpurmczfw5@mn7jouglo72s>
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
In-Reply-To: <bmngjssdvffqvnfcoledenlxefdqesvfv7l6os5lfpurmczfw5@mn7jouglo72s>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y8zdR3aXKHfTdpVahdg6KK_sfqvy_hvR9S9wGpiLrI0_1754483071
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4C53A180004
X-Stat-Signature: 6yh4aw4fi9i7ig4d469m5kexrnz8btwz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754483076-869075
X-HE-Meta: U2FsdGVkX1+2UfV24n9ehzzRKwG2Ua8emZj6hD9Sg2ig9e3a6wPhs5RF2A7w2YYr6a+d9yKn2lSgR5OyDfOJAdiyf8eJ+EW0qmrRSCTTY2PKQ0cMaGnYReCKQLn8BlT4u3kpTio+DaSAvlmh+wtBsjjt/nBivtkL10rTZT7ijfgOg9n1kjon9cJl7lnIfDeffppfKb0Ezgg65z0j+jW7ZZZS5f5WC3PtnSs49rIifNBJEsrB/LyjTEyAp15eh41k0sn73zs8JSKiWwQ+4RHA2dBEK2W4q6oi2gka/RufzBA62VzjvdZCrVy6FdYgyTXm2ADaIC21fvoYAxRUmDj2HCCLI2umKx8V7VvKmwOUjospLUreX/VINTXPDmAhprZSKm650ODBDF79NopAqp+i0CjdCw92Bmeym/KiN5Fbsi5sBRj6bOD/W1Wa0O8sTCta6ZaoKvfdkBEFSiWtAOs4V53jAlHjOS/gFsUgsg5HwHi1tBiN0EqBrkj9xfHzT5egMtMUHaCCWqSQ/mIiU5PdGDFWPgrE7Licr27gb77LB55C34kmiEeeHTveAugpoXK4AmKUMFl+1xsdIlCOuGLkjkTOct3LPkRMt7BWv517dIvK16Uz3bWJxw6OXzMAwvpd+G2j48KS+oLDfAQYe16XG+og0wDl+nkaGw8ZqWoR5/fxf/Zg42lLacPHzNOBPAtrPdcq78kqNoeI3Jd8RbP274H0jjoGPJymQQIEamdbjLE37QbeGS6O6kUrigCMOLWcT8kTlLWUNHFg7i4OnozPQakapN3E66xX/C8XKE2R+EfAsz5gscaLh6MVFVpT249mb5v+u26YR3UFdoKh0g1RQarMG/ec0/7NvOHqSAyI6fpTWscyFAjXKUTc+lJ21aHg9OuVwn8J/JfwNf6xHJfPA30rwCUN/ruoXb1Ss1hetyrShpJzUIzdJglwZ3ONu98pYp5xJxp2vB4cz0mAJPx
 cmfMeGhs
 gpaH61YBwnR9A1ssY5vbmFA2Robcdd5lmHybm7HK5fO4NDyRsNnpBeqQms8osECXGkeMuum8K+c8HeoFDcLCbaVNvjkMoM1QUDe2cisMXWMdj72GceaDMtnNDbkAMumdnCJrk637WInHo4hWxAb9hdAYrG3LzjxPVdbT3rCuJ1K/nmWC4RvOh6/S+mpIciX5ay/Ew3TLSOmB9vC2MjZ8smq6mRkJa0Vfh4t47gLdNBqw/O++QCyCmwZZ81CRy3lcaLtq5BK6rz7rwHk6Ei0SKLMrOdEZryMbRxAOs1qfVlLH+Gh3jZmFW3ZvKRx9YRRy5qZfF8qpI4yNZdJLGIEJoQBCV1ui3A8Uj1RWpugtpq1s9AgFgizOUDH22mTD5TeCqdTYO7a+c5j3Yuo7xx8vzDJJtv4ofCZY0efjr9TrvZ41+7aOGoGR5S+h8iah0xqotENTRjh6f2PmqX0ffuiprGwetSXpnrwwIuL651TWN/VINvth/iZV3uMOSZ65+DfYWKqxCLtZGhd/8bZPzCBIFAcRlxAXEQuouJEX2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 14:18, Pankaj Raghav (Samsung) wrote:
>> We could go one step further and special case in mm_get_huge_zero_folio() +
>> mm_put_huge_zero_folio() on CONFIG_STATIC_HUGE_ZERO_FOLIO.
>>
> 
> Hmm, but we could have also failed to allocate even though the option
> was enabled.

Then we return huge_zero_folio, which is NULL?

Or what are you concerned about?

-- 
Cheers,

David / dhildenb


