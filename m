Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79157C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 08:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B9D26B0089; Mon,  4 Aug 2025 04:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1917E6B008C; Mon,  4 Aug 2025 04:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A7C16B0093; Mon,  4 Aug 2025 04:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F06866B0089
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 04:30:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65975C1024
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:30:53 +0000 (UTC)
X-FDA: 83738404386.22.1D3387F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id D80E718000D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:30:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ar5fPDmI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754296251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ebFR2P4VjmEcZ3SdqCemUM65iDCRmP6ds2X10ucNEEA=;
	b=rDKZfEKgOmCVnIvgqcsQJ8wX1gPxKDHxF62qPaT6wnVtH3nzGMlOWFrz/mBbL4JDkF2Atc
	YBGAZRdRZIXMXt4N59AVpN42qKse9RTrE563ZGqyGIXmSS+4ox14B6qKlb/uXvAk4u2BfD
	z7iSULrZyL9XDwbmzYNRWw+tCJvIXSs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754296251; a=rsa-sha256;
	cv=none;
	b=jofXCZ/UKGq9YsLQiyha9Y9hwMvdEBip/ipbl7P2A7DyJ/xzaGBrqIQ0QSnSQQ+5Mfk6CL
	iTI0FpGiy7WC9mtP0pqL1UcMUaH4xPCpAg3hZbMfsKSducuP1pUrRjQMuSRF3u+xFvqsS7
	hYnAAv99wB0Jo8sJkWZMmfRrGTHq4J0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ar5fPDmI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754296250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ebFR2P4VjmEcZ3SdqCemUM65iDCRmP6ds2X10ucNEEA=;
	b=Ar5fPDmIOSq7oshGbUyqVBzx0sl+hzgHszlmZ6wQEp5TrsJVItFdNePGCFTxurVaJ5vMa/
	H3jnd5ox1ld6So5noJs4Yb38cYo6gX8eWpKD+HHxxpA5jaVHk2TtG9bNAXRjJ/F0JsbUys
	RxLo1j86FB6QculZ6FRg3leYhiXGhk4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-qBRcbYnVPaKlFhJCXQ75Cw-1; Mon, 04 Aug 2025 04:30:48 -0400
X-MC-Unique: qBRcbYnVPaKlFhJCXQ75Cw-1
X-Mimecast-MFC-AGG-ID: qBRcbYnVPaKlFhJCXQ75Cw_1754296248
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-456106b7c4aso17129195e9.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 01:30:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754296248; x=1754901048;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ebFR2P4VjmEcZ3SdqCemUM65iDCRmP6ds2X10ucNEEA=;
        b=ZcA26ZICEJZD1531wUZghI+rrldCVjnDIuUrFbXA/zIW6NTNQ13vlN+ZELcGs0JIbG
         4Zwn332mDftjzqY798kYoj+D+Cbe+QtJ6P3YyTjOhJ5M5FuJPCzvNUrs3WPjNIf0YajQ
         YVZ+FfrcYH+t4n6BLLzZCrS8ob8IH/7shm++ut4NC/pAY5dSoZOq1a6v5H60HnAptlg2
         FoYdAprvQ1zmClx/SIq53c6CPdLRgJCwW550gjfJGT3y1+w9JWIJUBdFURIIoDms/M80
         314zplSn839uVt0/PbBP2go8vixFB4w56aG0szaVbdigTIhKeF1A2+uvK5WaJblSjliI
         Pf/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgwXsn2cJwfP01DQRSAFME0Sn40ebGyoD6tvFfYcvxdB1IGzi27AxjPo8ENrshHkgkEtiiTJzU5A==@kvack.org
X-Gm-Message-State: AOJu0YwiFNX6ohU2rAd0Qxg4tVudsg/zjJqf7uZZO+zgBsuV+JJ3CEL/
	C/gWZDbHg/seRpoB7hlTL4j7npDiKPChTrrFB4dGqcGyScuB3kOj95jCnf8iN9WGVXnJPFKw5xW
	eGfu/oitLDAl3t2y5S5elNMS0/T8MyozlnSAbiV7E7w7D7uU3Lq9R
X-Gm-Gg: ASbGnct2uV8pMPMk/weFn3GRlpMWfoEP+810Ux4MR3R51tqFwE9hYWwkVKbhv5FhCVv
	itRJvOOBAu7qmLcFTdC7npbltAWWHdNcANTd/P3bFxPavisFzmPwfnmod1JCv+uXWZNRbB+SoXk
	LGCxyPZ8+q7RRS0sJMu70MvM0FzVHbdNIgkOkTkwYg1H2s6wDEdFLh5O2NpRWyc6zPBDsOH1Pa4
	XZhQCFQqnEcToTJ7cK/cctUZ30ceNR7GuzAJh4lkxQ38TP1VeGZR30eyBfq+ugLKptiUAJPr4gv
	Ac/nQhRFBpved0FgNg/6z6xL2cSPPb8r8dkWnGML7hkwmoqjMFl1YRWwnll4Yq1ZzdIhTGCZ52S
	TAKHstEWvwH/5ma4axi1l7ncYksK1T4itYW+KTYXykmgn1WMzczccXXZrn9TSC2FzGE0=
X-Received: by 2002:a05:6000:188c:b0:3a5:8977:e0fd with SMTP id ffacd0b85a97d-3b79d1f809bmr10603180f8f.0.1754296247605;
        Mon, 04 Aug 2025 01:30:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHofHu5ZtOwuJz5HKrWCTgS4jITMgfjzwqhGlCL/LeQzyG7CNRclHWrI0CkyPhQKfbeG1CIQw==
X-Received: by 2002:a05:6000:188c:b0:3a5:8977:e0fd with SMTP id ffacd0b85a97d-3b79d1f809bmr10603151f8f.0.1754296247174;
        Mon, 04 Aug 2025 01:30:47 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953eb7acsm194716745e9.28.2025.08.04.01.30.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 01:30:46 -0700 (PDT)
Message-ID: <d9d0890e-2837-49dc-9ca8-1d6c28e95a21@redhat.com>
Date: Mon, 4 Aug 2025 10:30:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
To: Qi Zheng <zhengqi.arch@bytedance.com>, "Lai, Yi"
 <yi1.lai@linux.intel.com>, Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra
 <lokeshgidra@google.com>, Tangquan Zheng <zhengtangquan@oppo.com>,
 yi1.lai@intel.com
References: <20250607220150.2980-1-21cnbao@gmail.com>
 <aJAFrYfyzGpbm+0m@ly-workstation>
 <1d1d97f9-2a67-4920-850e-accf4c82440e@redhat.com>
 <4fa8f492-c7ef-451c-8dc7-38b031c8a092@bytedance.com>
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
In-Reply-To: <4fa8f492-c7ef-451c-8dc7-38b031c8a092@bytedance.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VUKMHhb8n93YnMSKlAtYOsmhWCHfmSn98zOjzXR4tFU_1754296248
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5d6qwtr9aecu8rdws93fkk3wqfzj1ah6
X-Rspamd-Queue-Id: D80E718000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754296250-74499
X-HE-Meta: U2FsdGVkX194E/TTQi+MriEmZr5UPzgCk4Jbd7bvYDijQbM4eIOBOi8WuJlOzQwluUHTTgjWJw2ETH+2mmmF0Er+/LHTixfFJN4MNQcIr+zVxgmg2rNrQM8wHXajZdFsVyHqbzcIkjvbQYJfnIAPLq1fB6s/re5OszzWqmHW2Re9cpvUz+p+2jz0XoVR89TvzAliEmfmzGmtcg6tameJVx+llljaR09lr5xD50Lsx0cKH5jfbhqhlxE6S8G/0y8KWYFakBl2m1bNhJ6aQYRJYYk8DSYaGtlwuASqSHVBZphb7WAgT+SKoRdD9FNqHhd4aCKccQc3QMGBDr5KwOxxd3gzVrBWqiImAr+WaKotdTlWUQ0czfLkmZXoGH97X/uZ1LsG3khUkKTN8X+QAel4kltJcIQGM5BRBM/SDt9yA5Q6l3V4NLgwYdLnWmY+g7tBy5dwK7vnqZjaVhp+Ys9XQOUXSvuvAnsm9M0d3WJ5JnoWB0DeskdGojqvvpD9/aUSeXZeICg8foMEYBlsxStBIAWTljMX2V3UcYacKQowV60l/7aM8JCmGWY+mRzviI/qCWs0qIXadK7Ik3QBbC3LlGUwQ09TMYcoewVqwHcL3xI6EEXg+O91SMcafiWei2E2G400FmEXxL6Yy8HSua3srdkDfZPZyoLr6GO2qtHAoRvDnnOpQ1HtiGp8jE5CBnLuB+n9bKT4tvEAcNrbvvoa9nuCUjQsFbV9rW6gOFIPH4SMG5fJHo9ABiLKfh8k01g9bEtyhA6plS0eCrROqrFhwVJiO6eAOdNUjOxoz5/8Zj7yzqXU+o/xsLD6UXCP0qzljfiqL9GpuDF/fNZcaZsPci4VTzv59mS1EGVqchgzkKlXUHjo1VF6MQPW0oMQP6Kns+BlKfaA57yMTtTZ8l/Ro/kKZk9aXsAHpRUjpLS9SbsSKozCDQu0MchL6fQHlzIMNAe8/eIZeRZtma89238
 jVThKPd5
 51H2l+z8Nl6vsQfgmxc+J9MwFsLUN/eGsALqsLhmduxYzW7vXkV4LKGVLcbDpwa+2IW794zttpBPl1/GtBjaRnr6QGb+k8kXSN8kVZC12pdxq5vwmGhgumLGoSaGOMd3bbbJ1jniY7x5PFQEgti+I9IhQzXeFSMnzjIHvoeSIbOwzlyJB7lW9BlPgzhiH87GOW61jfIn4DoYdY3nnMcLjGdf2C+G4A/zDINzU8boEsRttsx7nylZZ2xB0MkN8AWJWvVkIPBdvwQAAL8bdW4e8cGqjxlicmxtMKH1eN0OFIdV6VL/+p45Yc8q2rRcSQ9SwYSd4PXUEHslwyD8evs995ZUlnh55eaoTjbjBiaiNsbmFTWy44qAPyT699mFt1reJZZsm6HUDZxf6+mpzWOO1d6Q/q065l3F4pNOe7naHzaJKRdXQybROIpH4u7LhVGV95VJ1TDnG4Dd3DX4cH0Nj7MztA/BQ6QO1OPZH8iig0PSd72fPNOev4AdIEyv0argjFGA4Mn+NmJRZYkekuwqraKxKX/2F5IfWnIDW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 10:26, Qi Zheng wrote:
> 
> 
> On 8/4/25 3:57 PM, David Hildenbrand wrote:
>> On 04.08.25 02:58, Lai, Yi wrote:
>>> Hi Barry Song,
>>>
>>> Greetings!
>>>
>>> I used Syzkaller and found that there is general protection fault in
>>> __pte_offset_map_lock in linux-next next-20250801.
>>>
>>> After bisection and the first bad commit is:
>>> "
>>> a6fde7add78d mm: use per_vma lock for MADV_DONTNEED
>>> "
>>>
>>> All detailed into can be found at:
>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>> main/250803_193026___pte_offset_map_lock
>>> Syzkaller repro code:
>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>> main/250803_193026___pte_offset_map_lock/repro.c
>>> Syzkaller repro syscall steps:
>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>> main/250803_193026___pte_offset_map_lock/repro.prog
>>> Syzkaller report:
>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>> main/250803_193026___pte_offset_map_lock/repro.report
>>> Kconfig(make olddefconfig):
>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>> main/250803_193026___pte_offset_map_lock/kconfig_origin
>>> Bisect info:
>>> https://github.com/laifryiee/syzkaller_logs/tree/
>>> main/250803_193026___pte_offset_map_lock/bisect_info.log
>>> bzImage:
>>> https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/
>>> main/250803_193026___pte_offset_map_lock/bzImage_next-20250801
>>> Issue dmesg:
>>> https://github.com/laifryiee/syzkaller_logs/blob/
>>> main/250803_193026___pte_offset_map_lock/next-20250801_dmesg.log
>>
>> Skimming over the reproducer, we seem to have racing MADV_DONTNEED and
>> MADV_COLLAPSE on the same anon area, but the problem only shows up once
>> we tear down that MM.
>>
>> If I would have to guess, I'd assume it's related to PT_RECLAIM
>> reclaiming empty page tables during MADV_DONTNEED -- but the kconfig
>> does not indicate that CONFIG_PT_RECLAIM was set.
> 
> On the x86_64, if PT_RECLAIM is not manually disabled, PT_RECLAIM should
> be enabled

That's what I thought: but I was not able to spot it in the provided 
config [1].

Or is that config *before* "make olfconfig"? confusing. I would want to 
see the actually used config.



[1] 
https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock/kconfig_origin

-- 
Cheers,

David / dhildenb


