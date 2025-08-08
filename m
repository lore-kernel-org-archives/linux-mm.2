Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F760C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 14:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A1C6B009B; Fri,  8 Aug 2025 10:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE18B6B009C; Fri,  8 Aug 2025 10:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6FD6B009D; Fri,  8 Aug 2025 10:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B11D96B009B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:24:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33FE6B696C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:24:00 +0000 (UTC)
X-FDA: 83753809440.07.99858AA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81420A0003
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:23:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eB7Nd1JZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754663037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XoatM0Ku2K5SI5xfNAI9cK1iS0HhuHQQ3g0x13YtE24=;
	b=2cAuH3QFPrifwpZy6Yvky0Qiy//qhC7y1eHM13ThUMIOBaPHJPkxgbepF4Pl3BRFloL69l
	RKIVIziz9tW6h9dHgS0eWYS6p3DZckbJymemjWhhoPHFVqkpwHwQM+VK8qQr69JA2P78UT
	JlMT2t0YDQrDf3Z92vje4fF7wgsaxZg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754663037; a=rsa-sha256;
	cv=none;
	b=8Kn6nmRWEib2KrimXjZvoyHHHWLfTVeRFUj4X7tH2hu/MhITJ88aUhkbfW3QyU/IuYScP3
	11ffsaZenNXFDb4ks9rv0H9tJRYBo7Vz35ACkEi80IUe53zLR3TDVI3X6GYFVbViiPqw0G
	poX2Qcur4e3XcXU11RrtBljx8TV7lXc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eB7Nd1JZ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754663036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XoatM0Ku2K5SI5xfNAI9cK1iS0HhuHQQ3g0x13YtE24=;
	b=eB7Nd1JZNxGQywr+SaC9TFxwe5wn4FfFrGoTvMio1e18lS0CSudZvzpW/pQMQOIpU7MhzE
	etRhUbkh7M2qJaMr+YHT5jlEIYM97/NTx4vuW6pk6+3dnoB0ngH7Hu1q3B8M9MZskKM/pa
	l9ftKYMhj5wbZq+ghfdLnRcAnjANYVg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-L7Eq4etjP9Omb-bJImnGrQ-1; Fri, 08 Aug 2025 10:23:55 -0400
X-MC-Unique: L7Eq4etjP9Omb-bJImnGrQ-1
X-Mimecast-MFC-AGG-ID: L7Eq4etjP9Omb-bJImnGrQ_1754663034
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b7892c42b7so1458336f8f.0
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 07:23:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754663034; x=1755267834;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XoatM0Ku2K5SI5xfNAI9cK1iS0HhuHQQ3g0x13YtE24=;
        b=ZQEP2LZ6r7DId73gzgkv+vcLRKnpHbW0Hknw3NwDa2IpflSUqiFGF8bR19x9/vdO3Z
         17ExDW//woqFd6vew7fm4Wy1ug/F5/CpsBI+LxT57+dZkTa9tTd85BY+VNJbaqMFkKzl
         Ibj5bTG82gPfjeFgLFs9i0zx1kptmm1wtGissykRjCD8fMjU9+3c5HfAtEnm+6olQgWs
         t5VgGMkHlUS7ttzElVqi2jWTIfWrCf+5El0FTZbpvwXKJfiIGTXOjBz3nkKdOCE/Ge70
         uk48ahRWLj0nbLTAeZwcS938EZ8EYKNvUvl8QLyK6Atzx4cD9PIUi8J3Dus/r4267Ugp
         2B2g==
X-Forwarded-Encrypted: i=1; AJvYcCUxI1qNInGO/hT+GjyfiV5EhKRtZj6VguRAzHxiZraa4wL10PgNbLrf8lf84/bqHoJwTPgJSaLsAw==@kvack.org
X-Gm-Message-State: AOJu0Yz5DUHOcCMwGkdLELjgq6cwmkpw/LeVaNu7ZaOB87bDZWkUl4tb
	vg6wpKIZCIF9irZ+y9lCYCMJSLLG2HwU7SPVKVQGUwCo1E5fXvgNKQnkUYgULMVCzFTLzmy4HvP
	4leSd3sCUb/jaYbCxLRA5Qh8tWVMswKBcPlffEIOi7XUCzBGrH6jk
X-Gm-Gg: ASbGncsH6x+6zmGtLtEIJBQ1EgkqDygyT9tpo+0jTOgibCwJc86BusAajBytHE3HPMG
	/yMMfDzbkTU7LvpsBPpkX8Wm9maKxNrpQauYYym8EFFm4/CfpVZWXeCuTrws1msceI3xGIz0OD2
	1pdpJH7yo2mqBas0atVo7jAUVoE3+60zi0zr8/PzZZrp4dhtmQrqTkmYTNjhvrdhfwRtFI90GkL
	XNPhLWKl4aFHPSTRY4dvvZp71CkvJTgAFbh5fA5cGz6+ieyU+WRJQihJDXOSlh0+h+0y388NpuJ
	fFPAzL1BsJgCh8Wt+TWiCIkHeKJwd491VwAixQKUWeUWqfjTxpCIve7v4k2koynSxA8eNQ1KwKx
	ppinJCn/a8C34I0/0BWb9B5UQpsb5e3KyclzvvRWa5LZhQgKcnyBn7H/fk4BOtvWF
X-Received: by 2002:a05:6000:2f84:b0:3b7:9dc1:74a9 with SMTP id ffacd0b85a97d-3b900b7aea4mr2535161f8f.42.1754663034455;
        Fri, 08 Aug 2025 07:23:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEePpZjK2UFX8XfHhLL2C/dDb4Nzd1zVHG6VBTgVmPIHVSFXe9BgmOEmO8a7NQY0B0WsA+mWQ==
X-Received: by 2002:a05:6000:2f84:b0:3b7:9dc1:74a9 with SMTP id ffacd0b85a97d-3b900b7aea4mr2535140f8f.42.1754663033969;
        Fri, 08 Aug 2025 07:23:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:900:2e1e:d717:2543:c4d6? (p200300d82f2509002e1ed7172543c4d6.dip0.t-ipconnect.de. [2003:d8:2f25:900:2e1e:d717:2543:c4d6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8fc28a830sm6142600f8f.16.2025.08.08.07.23.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 07:23:53 -0700 (PDT)
Message-ID: <687b556e-0196-4a38-986a-2e7b0308e03d@redhat.com>
Date: Fri, 8 Aug 2025 16:23:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: fix accounting of memmap pages
To: Sumanth Korikkar <sumanthk@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, richard.weiyang@gmail.com
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 linux-s390 <linux-s390@vger.kernel.org>
References: <20250807183545.1424509-1-sumanthk@linux.ibm.com>
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
In-Reply-To: <20250807183545.1424509-1-sumanthk@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dy-kiu53ntMAjx-VBgvWahPiaRuXlSj4YLHbDXbrsMw_1754663034
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6aazqt7or67195r5t3a4n9xrysmft69s
X-Rspamd-Queue-Id: 81420A0003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754663037-98813
X-HE-Meta: U2FsdGVkX18QDxMJLSMvbQYXjPhK6O1QFeqPiLiDrhyzYHLcmdMxvbSMUmeCdWxOg4URV6jstR2KJT0ETmQwsM5xq8viELUkVvPfGZ3b1lBiKso39JjKSzHaOzMM2qB0tF1BgGQwRKyHqDRVkqemWLQdimE7uExDJjoQLQmcIOZgbuA+wHJGF5/g6n02mrjiZH9CeZDUuKzVhhngkLN4HQnnoDt15YrqVm1BcsJ4uPmUi63E3E3+s/CxdVNyDSiouoA8dsYuO1Hu5vdQswpKkXrW22Bc+kLXGM93IpImOXJ+/JXZF+VIo4ZTyByGloyeBubMmkw5YzGhiEOwcjfQT0W50f+xdTVkWcRShlQZs1wgeu36I3L7aPtKtwKO4VbrfwcPzBpNbE3lDF8vR7hz1+JMlufuWKhbwqIfgzcIhd41HNr39G4lqPQuH0C9ayhQ4I07VfDC2WrtqcvhRxOgojAnKV3u/BGlWIA9xFfKQwyfhtt87XWk9TA2nD2CrjVuASh4cnPYUDKBXDMtp/8XQMIPI113/zvJwd+ihjDzFEP0Toc6xdG8B9RS0Jr/x+pSplVYxfqeWxn3y/9BSUlSvztLEqcphFF3HIveiRqaRGdjyqjx6ZlQNgms8rb8Uygr2aF0478gFMDKh/b0+fUFe8EYgM8Fs8PoOPxlSXZiHQjjuLLS+xjdoVpgboJk/tu0ZqUYjcDM8oQKvHO2EScmIyKnt7PvkuJU5JHobH0qrcqr+9w9WL252AeS7AOqmNOlemdN3GLUKaF0NN4D1+obXoil/yOvwBHjwFXyO3b8LqOpgrU/Kc6jqbRKtuVa0SMGXJc0l/0EAQ9Ig/h2raxrvozYUHAERsw9PWUPpu2Bn2Q5h/5fefLf7h5jq6QNJbjE6cCa4zH23wdAbSnZSYd07Ji0ZTyXKO96+vfZQ/coxyQIAdUL06XBcWHtBWU0gc6AC2J1F6mWfVetkvHDFfa
 Q+BXa6VY
 Fgd5nurpGSilayJjNpBsL/qF0aa/ofm3NPlfM6fSNn7TABnqSH/ec/bTTBKf9LndWh2s/o7m3j3NTpvXM2xQjtp5iqMG8Gg7O/YPJkecJporwnQ+C4EtJVyEuwyyP0idFjM8cE4TadSLQlmuyN8md+yvHUx3gAZSUr9jEjfVw3jXaQyh1YXbWoKhHLX/P9rTX5VH7oeuZPCTvfCN37yU2w0qjzYbC38kq300gcwOAiRS/6KFX4aGfNAKKhpttdJ/HxYKg7O3QCii7SlQJO9Xw7acz/vxL9Ty/RLciTkUAVX5aCCzrK1ttg3gme9LWJaDQ/fnch+yTZd+x75DaHJGUvbiML1rNNe840tBLAT10DW3xnse4M64tFQQjD2Q3vT31bOE18FaQ6S5ekW/WtNou7g+b5X5XfN8WR+zalMyUVBzeoOsZMvRmIbqJ0mnMN7XkA4D27FuXNnUT0vryR4FVW1qkWsUPb1rvwMoQHRKN1ptYGw4PZ5wf7C1qRorJ0tzJ5BS7M8v1n5cOeFqhI4wqUqZqkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 20:35, Sumanth Korikkar wrote:
> For !CONFIG_SPARSEMEM_VMEMMAP, memmap page accounting is currently done
> upfront in sparse_buffer_init(). However, sparse_buffer_alloc() may
> return NULL in failure scenario.
> 
> Also, memmap pages may be allocated either from the memblock allocator
> during early boot or from the buddy allocator. When removed via
> arch_remove_memory(), accounting of memmap pages must reflect the
> original allocation source.
> 
> To ensure correctness:
> * Account memmap pages after successful allocation in sparse_init_nid()
>    and section_activate().
> * Account memmap pages in section_deactivate() based on allocation
>    source.
> 
> Cc: stable@vger.kernel.org
> Fixes: 15995a352474 ("mm: report per-page metadata information")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
> ---
> v4:
> * Add fixes and suggested-by.
> 
> v3:
> * Account memmap pages for !CONFIG_SPARSEMEM_VMEMMAP and only when memmap
>    allocation succeeds. Thanks Wei Yang.
> 
> v2:
> * Account memmap pages for  !CONFIG_SPARSEMEM_VMEMMAP in
>    section_deactivate().  Thanks David.
> * https://lore.kernel.org/all/20250804151328.2326642-1-sumanthk@linux.ibm.com/
> 
> v1:
> * Account memmap pages for early sections.
> * https://lore.kernel.org/all/20250804084015.270570-1-sumanthk@linux.ibm.com/
> 
>   mm/sparse-vmemmap.c |  5 -----
>   mm/sparse.c         | 15 +++++++++------
>   2 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index fd2ab5118e13..41aa0493eb03 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -578,11 +578,6 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
>   	if (r < 0)
>   		return NULL;
>   
> -	if (system_state == SYSTEM_BOOTING)
> -		memmap_boot_pages_add(DIV_ROUND_UP(end - start, PAGE_SIZE));
> -	else
> -		memmap_pages_add(DIV_ROUND_UP(end - start, PAGE_SIZE));
> -
>   	return pfn_to_page(pfn);
>   }
>   
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 066cbf82acb8..24323122f6cb 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -454,9 +454,6 @@ static void __init sparse_buffer_init(unsigned long size, int nid)
>   	 */
>   	sparsemap_buf = memmap_alloc(size, section_map_size(), addr, nid, true);
>   	sparsemap_buf_end = sparsemap_buf + size;
> -#ifndef CONFIG_SPARSEMEM_VMEMMAP
> -	memmap_boot_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
> -#endif
>   }
>   
>   static void __init sparse_buffer_fini(void)
> @@ -567,6 +564,8 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
>   				sparse_buffer_fini();
>   				goto failed;
>   			}
> +			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
> +							   PAGE_SIZE));

IIRC, we can have partially populated boot sections, where only some 
subsections actually have a memmap ... so this calculation is possibly 
wrong in some cases.

-- 
Cheers,

David / dhildenb


