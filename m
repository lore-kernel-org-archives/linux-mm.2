Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80984C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ECCC8E001F; Wed, 23 Jul 2025 09:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09DAA8E0002; Wed, 23 Jul 2025 09:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE6F8E001F; Wed, 23 Jul 2025 09:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD2D48E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:17:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6BF421406C4
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:17:27 +0000 (UTC)
X-FDA: 83695580934.07.6696968
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id F1C78C0006
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:17:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IloeifgX;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753276645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUvOWYi7qqvGYE01TjZyNH5FIGW2BUt0z90QQ23/hCw=;
	b=s5UY2RRv5JEQ20yf1dA36Wd0uGBD5vwwB1QRE7xT8lzKdyvnWRTnH5D0NrxZ/JegBlE0/S
	WRC3qgisjsLFtoVK23orbzB3UwuHLDdhhQQ0BoK9pP3fTDfPd8nzpFLSS1R0bHMl+K6chz
	x+ZC0CrhrBL78Pn7jcDPIvePq2fkBLc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753276645; a=rsa-sha256;
	cv=none;
	b=mNI+pQmNbVUxkO9BNH7+2wuXZnu7QvwWNzCScwf54jZ1A1F7V34EoJ7cpSKaio7Zj+VDrM
	mJjwhP1EQrQQmb/p0jBv2mhoIJjwcuKuI5Eo8mDXF6MRdCZKw7g5G2LwDyM+QE9iw/pabz
	K39DldpBeXJZRb3wXB82niVe7Shv3n4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IloeifgX;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753276644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QUvOWYi7qqvGYE01TjZyNH5FIGW2BUt0z90QQ23/hCw=;
	b=IloeifgXgr0NyEqtLyTkbRdBqusVC1S1YCRhWEkND8ym81WGnddH1b0GYpCudRNoDFKY67
	MK6PpAMTM/106gJdlx5fVPeuNdnGk7rdsSWWB+8lM6enPctTAPQneGihUVWeSbqpZidP9+
	u8TVzHLIfXJPnUSX3/lKvF8VOwe/EF4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-qK09k8QdMjOUiT8_P2NkMA-1; Wed, 23 Jul 2025 09:17:21 -0400
X-MC-Unique: qK09k8QdMjOUiT8_P2NkMA-1
X-Mimecast-MFC-AGG-ID: qK09k8QdMjOUiT8_P2NkMA_1753276640
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a5780e8137so490572f8f.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:17:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753276640; x=1753881440;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QUvOWYi7qqvGYE01TjZyNH5FIGW2BUt0z90QQ23/hCw=;
        b=bpnFmI4Rx/uccpe0OGOsAssuK/PEMtrZxUGD7YrjHv3fjkDyoUdqGvlEaSLwRjIjaE
         /2wRxKFA68fQG9X8T6bSXhJnxKea50MoOP43lEaDUybP2hPcvgHLq7eFXe2Hwh98IYnc
         odzOswMv/E+InYWvCWSdLGsOgJB7ii9Wve6+dt2oaVEW3PiwOtVLUprsB7VxSq16LiI0
         sumIyrx9ImFWxeFTDEQUENhnNm6QCg6JqOf3axLxWyF3K0wbHML1ywI6id33bIN99XaW
         E3FuDzYL7I0abgkOOSSdDDCsn9ATCrdvhH5YtGT8Nzb00kROdnSKQSOVUS5xLRV5B+mV
         LuIA==
X-Forwarded-Encrypted: i=1; AJvYcCXgXmbpTrzMfu0xS6rFggqxq0XdumNQqamUOZxVRLpCtlVg2LTLbBmljpU8IQ3OOxyfumXIMUKSTQ==@kvack.org
X-Gm-Message-State: AOJu0YymGO7taARqaYstmSEwe+D76VxsMOVkd7KJSXRFKPSxbxSgPOsJ
	hle0RPYmC38uVvSiP3CgmQLcHSJcFRv01RdFnozukVpAt90zfc+Suvu9jb+Wx5Sd0RO0yv3cKGw
	i1M8f9zLvQwLhW/nEonrAOEqnSIf7ATyw698OFz+L2QsogN7uTGD/
X-Gm-Gg: ASbGnct25Y9SLQRZC99/uoIodeiO0b6qeFcX38V76glBb1i/VRHOUkBileVSF/FpMXC
	FkX5ZT3tT/LBiB1YtzIWffpoHF5u+9w/G0lYJSOPbptEqNwkXx0DqlLXCJ2467OI9yQLmA1o9GF
	q3e9CE0ONqt/Y8Ed6oF0Sogbyq4urs5roSN3SBUGPBMrPdWa2Q+vFgPZcD+tXqKhupAw0SBn2KQ
	lzsWlE2oE//pHWUQIlarBw/qiHcZx0yA9wo0mXPa5vVgODpVtyyc6YmROBvzUIBkLk/OQl/X5oG
	jrLr6gSy3SMOiWQMuasdcramqt9t20zBnpXQgk117PSOq84B4ktbkcE+9aqhAfYZY9H6D9jHQp4
	HAyjE5J4SjQ/Z9RRZkZt0bUyFYVBfwkkXuF1F6BaEvXdHpLQAIiPMNKmkWlqyxbjf910=
X-Received: by 2002:a05:6000:1449:b0:3a4:ebfc:8c7 with SMTP id ffacd0b85a97d-3b7694beef4mr2628841f8f.8.1753276639706;
        Wed, 23 Jul 2025 06:17:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGs9I1KLbQeMu1ajtdHhYyM5hqYLgRpOaRoFft+2iVCe2Ctcg0/AKmdicmyvq7Lk8vhHyXlWw==
X-Received: by 2002:a05:6000:1449:b0:3a4:ebfc:8c7 with SMTP id ffacd0b85a97d-3b7694beef4mr2628761f8f.8.1753276638372;
        Wed, 23 Jul 2025 06:17:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca2bb96sm16449200f8f.30.2025.07.23.06.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 06:17:17 -0700 (PDT)
Message-ID: <8ef1ddd4-6597-4897-8e85-e839c1759889@redhat.com>
Date: Wed, 23 Jul 2025 15:17:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 09/22] KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit
 builds
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250723104714.1674617-1-tabba@google.com>
 <20250723104714.1674617-10-tabba@google.com>
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
In-Reply-To: <20250723104714.1674617-10-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XGWFrDwmzy4BhkD153uVPfsVwO5OAEkgFhyWQRx2hyw_1753276640
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F1C78C0006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: cq6yhb8974hokxend86afwka6rre7rh8
X-HE-Tag: 1753276644-220547
X-HE-Meta: U2FsdGVkX1+OIzmSfW8zGYI7IOJCEzVx9C4IQN47kLFZqo5y1yLlKiZNH2zLwhRbwU1hN8QVKgjkxj8oBRtCqBKOkdeHBDFKiGyHZazp/0Eo4tl/j/EUqfFNqtoqCZCTYHuukrd3zkp8HSjIJ7pVRrlM2chqUGVoptHLjlDUx6Wtw/5nVH8yOl2EfAgCiiYofa7uOn555sfeGvrcI/jghG5bxyIoMUhSvNgzJPY0+ZiJBbpcWn7YEdl1uO4kk0eel+ZtxH4vvKhXcdn7xXWc7QzzCNi0ecvUneuGTlImIoYIMRtiBAdtOpSXR/4FJHfSO6d15xdjB3tBfHLasvamSPUQrLeh/EmPPwa2N1gNQpmjADSpCpICsZItycMcH4DGeDfCFsZ39Msd6cXh5Q7LtjqJDdg0QlQEs6nKKG2A8jaz+qExaOr9mt6PfiGctMsTc/aPInF/Hi42k2SBeLtcldNgYG38yjaeKczgR2dtG8n/NpdE0P1Pqj2JWexqppwRO5TYt5h+Da+qRv19nBOdaS7CjcK9NvpIpJwGLTjd6DtSCKRh84TG/1DJtWkyh77Nx5nI97TXNU2AzprOHDKAvXycTdIIj5YNy+JzaUToVWmdDlA9SAxnkIsNlu4RAAwc6dbCf9IJNMdBkki7BJuUVOPiz9Plk3rpwiamE3f8wKZoQVZJoJ7N2qZS82g/2sK+EGVhWZInq1PvOAfPnneL4eVALQZ33BLl4KgrM1iEnf7Rv96Fs8yYAmwVeDA3NR2mhMP70udOCjHkUaMMRwXJa+3F3SWzKWoJOVlyOMdt+t+hx6clPNZkJaYxJx449VlYK0G/IkuP9XXv+v5n5rag6iT1m69g8ua++uuk7sCPT32snOY/FRBAWt4FvndQ9gJ5K1OdV4OocKfRPAww6G94awCHRPVz+w3ljbZUIKzPRx6fMij1oJXq3IagYysDy/3PmmrOhzDqnf+6Vh3f6r9
 VxZmQo26
 yqeM5+rAMUVHC4c1bJKdsr2owrLpvEKVofHLYh+p2q8Un6ry6XN8j2fscNxTGB2xQVBAhXvoJDcBSSd+Iq+XrXxcUxcZnxBE1RVCnX7eKv2iV1cxj8iTuQwMIWgvbbrhz4Umaifms+FUc4iOkKBkqDqeP9IJAx0fXpqDEpwe1i48ccjrRRg8p7XWN9h0DA9rcx7rbTViZGISG4foN/15bZKCRRb2yp0JDxcjVz+OpCgLyuL8SQDRrkpzIU9Z2F6JeX9mGEEt0oBRLomnegcsQ8dLV28yv9j8TRAHAoozUukbJ6pvPbVE3Qkr06PmAHXQAyaxwazuMRnJkYB1CD7JVjxSpJ7WovEO2f11r+pjTg7hgjNZfgurYDWBQkgXTfemJ4Hdlk39oCW/zCLMnqOAHOpSHct0cuPS5zPZ7ijJR36ykOJIoNPCTzMmcxrpYfqiCZwer1iNDYh02890mMZpfqPq88cWimGrr7lNTEuwba1cuBBGe+FVdIJsdLthCUUZyqWMEvjzwPwiCK2iCfzWmP87UA9ABhzAmQH5ORF4/Ox3+jFOHtroJDEPSkDQnhzgEx2Aq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.07.25 12:47, Fuad Tabba wrote:
> Enable KVM_GUEST_MEMFD for all KVM x86 64-bit builds, i.e. for "default"
> VM types when running on 64-bit KVM.  This will allow using guest_memfd
> to back non-private memory for all VM shapes, by supporting mmap() on
> guest_memfd.

It's a bit weird, because mmap() support gets added in a later patch. 
But I suspect this is fine.


Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


