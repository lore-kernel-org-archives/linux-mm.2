Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B675C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 18:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0236B008A; Fri, 25 Jul 2025 14:03:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C7B86B008C; Fri, 25 Jul 2025 14:03:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6B66B0092; Fri, 25 Jul 2025 14:03:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BFA76B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:03:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BD04C087B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:03:18 +0000 (UTC)
X-FDA: 83703558876.21.6ADE6AF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9EA1AC0002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:03:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A35Jc9w8;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753466595; a=rsa-sha256;
	cv=none;
	b=ymsQMrfrruJ9grn2Av2Px8/Xz0skJGo1/YID+gmUlILR2My6PL6TazzElAUU2vxH/3dSMp
	lgod1bIN/vNtDzfklt7wsh1XUFwMtOCy6aOz8YubNTMIqz/Av3BpYmRyLbOTw+Gd7VFKtk
	objjBblwO1m6saW4hGXflsQOoD9qzzg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A35Jc9w8;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753466595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1A1XdrpKswvqDLqRwvvl2q/mzdhe8nMBmqHzzSNW3Y=;
	b=V/JwVteIgiaWNDA5IqSbjR1h5JSbwzlVkPwymBa5M5UAzbb8YtR6MqpXyN2O4WfEGIjVy+
	jUGsW9Ll1uv5euh75ONsrHtZhCgs8eQnEcilLP7c7ngIyf1gfkyha82bcUFZxHngoe3CPj
	01Q0RyA29TgeedwRYbizcaVH5DJElxM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753466595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=m1A1XdrpKswvqDLqRwvvl2q/mzdhe8nMBmqHzzSNW3Y=;
	b=A35Jc9w8+5KA/Ct224gpFpYhv6N4PUx0tadfb5PzV25/TpZpHZ0RxqLFxAjMDoFAj+5FxT
	CXiWq6QKMcUp8rmFMZ797fLvz79GCOhFoqxUTX4BYwKHpO7diQYn/PH8q5NneZWDkb1znW
	OTvZVW2WfyhtpAKzcsdLUZmG44Hh8Hs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-FaPhRnuDNcW4-lSvcBKKOw-1; Fri, 25 Jul 2025 14:03:13 -0400
X-MC-Unique: FaPhRnuDNcW4-lSvcBKKOw-1
X-Mimecast-MFC-AGG-ID: FaPhRnuDNcW4-lSvcBKKOw_1753466592
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4561c67daebso8836545e9.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:03:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753466592; x=1754071392;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m1A1XdrpKswvqDLqRwvvl2q/mzdhe8nMBmqHzzSNW3Y=;
        b=ZNwKHcDCByuA4EYrihma7soDYHpagX/DWE8YxJ9vDNsKHsCmPXxlsZB2wabdYZwwdV
         20KVj8BUBg2CYygOacyu0iVghSWtF4amlFcFrjW6axYYb/WkVS+/HW2C2JhhvB4HXDda
         ra8M3L+0l0URoRYIObHMauGXVGeOVUp862pVPxWauxPOcArWZwQspYrwIpac1CZJ24cL
         kCK04dRfbCH87h069WEy34jWRV9nAOER/7RVRkZkZ2kxz57YyErkxT9xbZ42V2cNVGGj
         VfmGv2cdA59T9EJWO+dbRhMBelDE1I0vRi4aIQKMeX5qrvKKChnOznGUj5uhGy9eO2ZM
         7W0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVEG6du1KXGK8XPlYaeFIxJhy15KE/2V8TlDyKqrgBC/Y9vblemx7IHUWI7iQaE2i8Tu/N95pEupw==@kvack.org
X-Gm-Message-State: AOJu0YyG+9km0OERmNEt+vLJvRyqhgHvV1UA2U1lpGZ4kojSI1w5VY0R
	Yd6QJyuvhAXtu+E/e3aJLt+kTadCXzU/G6ZiSL0Y+2OOwufAe0cz4iYo5MDU3uyRE1OMnU4xUfh
	NQBkeXcDg1ATWZtR24C4t1rLyhEAGRvBDAWV2vh4S1M61nGcqEK8Z
X-Gm-Gg: ASbGncv+glq5JbblWac2UHUtmk5/Y9GDbrSHQgyWN0AIvvtmYeHhYStMpImU/WoXih5
	j0XK9xWJ5JBIQ+gsib3CK1lsGRl1HzeC/kVeyOUIVnUePuuVTPZ4NAmKMo8CGgdZlRkVUV9beMO
	hcyXgiJ4SXBtKrYxgcKvrXp+C098ARTJ8M9Lz1Vn21uyStQ/b+n/Ac2am7QLClB11l3O6wgghi7
	hPamgKMoKIwxXUFYox3aaTqcK0FwphIAbxdyZznTNAQ2B75ocR3sr8Y9+bnGAJ/t0gAksF3ojWk
	wQ4kd1MRQvpPxHJMaA3qX2o/us7HlU8setru6k+5XyxwIi0DUW4djLEtczl2d8qdTp8R3VLdX/Z
	dBNhj6jJP5Dmov8wjAqjHheHeCuJ+iyd+Imto8w1kd3P/de5JmbuNMaE4czBb4CS5
X-Received: by 2002:a05:600c:12d4:b0:456:23e7:2568 with SMTP id 5b1f17b1804b1-45870580784mr45206005e9.13.1753466592372;
        Fri, 25 Jul 2025 11:03:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0emwjXKmT752G3twyQEVU2y3mXUVE5sfgxlQvTVcJZVNMgLqr4pAAogO1mHgwG4QpZo+CcA==
X-Received: by 2002:a05:600c:12d4:b0:456:23e7:2568 with SMTP id 5b1f17b1804b1-45870580784mr45205645e9.13.1753466591936;
        Fri, 25 Jul 2025 11:03:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f36:e800:2f2e:cb5:13f6:f884? (p200300d82f36e8002f2e0cb513f6f884.dip0.t-ipconnect.de. [2003:d8:2f36:e800:2f2e:cb5:13f6:f884])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4586f88cfe3sm41356975e9.0.2025.07.25.11.03.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 11:03:11 -0700 (PDT)
Message-ID: <d546df23-70df-47a2-9211-2bb971f8834b@redhat.com>
Date: Fri, 25 Jul 2025 20:03:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Add missing headers to mempory policy &
 migration section
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
References: <20250725175616.2397031-1-joshua.hahnjy@gmail.com>
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
In-Reply-To: <20250725175616.2397031-1-joshua.hahnjy@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Sj3C7j0-iQ40sKVOO0MYSFA08wR2GZv5xGnGrNIihXg_1753466592
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9EA1AC0002
X-Stat-Signature: op8gpe4h8tftbonbi95aukwjt561j4bb
X-HE-Tag: 1753466595-768136
X-HE-Meta: U2FsdGVkX19YZkopu6yNZMEhll3EVTNcXSJAFMdaFM/dgnMBu247ThA6BLxrLTRkfXkGypercMP+7A8QrO1VJS/j++9/n4qWBnd+fKfWy2sVREV1qD5F+S+6SaVvh3iBOEo3EnTsamggoJ49fHi2FWBGrgA8JPk6dcEkp0AxDkjTzjW4qQCB9t+Nhr26b8DadUiWfSNB+eW5zmcG6iBxTmFqfo0pTW0GQ6HWNXXsMdaWMoab7HGWWs02cUBf2vMRmtZUWwpxI6RnZP0cyU3ykfBDDENDyguvaGtrJKAWm/xwbm5uligAJHhRwwIGeXzG+1RS9zeI6S2xnDJtprZ1OpDg9LOECQIK/a7NCtYLUJHUK3QvXSNW4mzpD/CZHCTuYuQ20MF/eoFIeek0AqKd8EPqzY5VTKjLLRV/pcphNin0bM7YwRZfSzxKAH+fpnQkI/uKSvvGlKizGPH9wrAeDJHY/hRyLIsaAkSKlLzYZKNqDpaf3XE7KhDY4h5Q9cH8KLuL+jSZ3j/KmsLfAUAE25WVlybw5fspwhitI3qNZxRUBEce4xt6rBAJgfeq65GCqSFO27vkh/YFHPPK1JSDkh8+dzed6cXs2vFYLYN/fx4h1zk2RKaR+mUAX5MG3d8nTIgEukl5RPL0OwTzkNlQNvebs0CJ8CG9dGMW20vdZtRGw3Y3A3HfglV5lEp+BE5wpLl2hS245xb1jLArBM6UiGfReHsyF2b1QKDIX5jvKOHQpSUiRtnHOv3zS7ixX6iO9Xijw0TvhJo9cISIugg9Nfj6hO4Z46f17bXZ3p11MxLkDFYBPpsQ3NvAlOxXoUAooXLLPyknSLaeMa6uxU61TN+3tSNHOCY+zi5eX08JPvNF+MwJgJAiD4Di4+3zje5ybDxtV838OIqh6f8W073doWmfPPOSH8rF6uwr6U++D78U7/G1vRca5/UGKprJ5QoqRUzgEiIUj7wWHROcb7Y
 VhurCrlC
 Vz5ErmCySCH3d3/U32QPa5USvUu1QHx6yNIrYWKFwuyrWOYwA7rFDzs5WdwJ1AsTIk+kHK28DR4se2wl3+5DlrPf7Kd3htA0d3UZOEgFLkhgTAq23JTM6r831f81z5VPR1qvEumP6cKrs56BTw94uTNckzgSYo5f+8Tw8WevDarQ626V1cpIzvoNbC2PF3MLhXMuAFFOMORyOVy4wjHwwn75iQ0r3hu/T8282TFmfH6fIVvrBf/2G6zkeiFdeylUxXPXeBYzvoy4q/XHfODSD+YBkjt8+XUQb5Fn+s2b+y7N+CSLtFyqOH45QV9s81ECrPscusLen252l0aT4ztal5GZupiEkWKxIw0CAxE37MuXqEpKxXUx3qtY6tri94j6idA6MJXoLcS5/QdQJbXZXPCvx0LPz++7syJckJISfBsa2psi14NPyjcP5UmUfLbjQEQ82p0iAaILGuhnfb/KMgVG+Zwx1MJnNiBZQSROlNQLvxvXRyFQZ1r1lZSZjSnU0rQJbkKrOpvYgEc2fvlXKdLatXlHMmqMfQn/VYTgNaRFn447b8oN4LIvTutBlVjZTRKl4heRwnnAJPxcA7z8iEvyfaBWDzUc8Eu/sCV4UQ+jh5phxvsgqEjP5eCeobMWtYKCImZuzlyt1qFs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 19:56, Joshua Hahn wrote:
> These two files currently do not belong to any section.
> The memory policy & migration section seems to be a good home for them!
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>   MAINTAINERS | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a8bebd0886df..dec8db8b5cc7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15838,7 +15838,9 @@ S:	Maintained
>   W:	http://www.linux-mm.org
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>   F:	include/linux/mempolicy.h
> +F:	include/uapi/linux/mempolicy.h

That one is already on that secion on the mm/mm-new branch

>   F:	include/linux/migrate.h
> +F:	include/linux/migrate_mode.h

Yeah, that one is missing.

Can you rebase to mm/mm-new? Thanks!

-- 
Cheers,

David / dhildenb


