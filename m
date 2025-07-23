Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F46C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:14:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7ECA8E001E; Wed, 23 Jul 2025 09:14:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E7F8E0002; Wed, 23 Jul 2025 09:14:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF71E8E001E; Wed, 23 Jul 2025 09:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E3DA8E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:14:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74913133778
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:14:14 +0000 (UTC)
X-FDA: 83695572828.08.EC31A52
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1002A100013
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:14:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cF0eayr8;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753276452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6p+xzN+wLyirMb0AuRivvb6HtwACpC6Hnwdv7MYVdp8=;
	b=Rl6BUfNB6i8JDv3aKXmGEjDuntiJ+SoQ7aGqcKyNQlT1xvD28x0cMgIdwOLJ1JQq/R8Tuu
	UX1aWkLvjhrPxqFVJAZzFserT7WEaMPN4tVERmBDx9oKHBCw3s9N5QZp/U/M7toVZdQwqQ
	sHO1KC+zw9heHiZxEpDkigonhDDI1NM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cF0eayr8;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753276452; a=rsa-sha256;
	cv=none;
	b=IJ0W5ECb47TQvf5KcoS/lUgozQ4q61d59ZLFZ7gyBwpSpDFC4CgxRblaGiu1qk5zmjkkmm
	MmXNR88kg4dXskvtzTsAFGVXc0A8D1bfD0RVwf2HHwF/y1cfFJZPrP6dNBMJO1SKmAdKky
	+zw1NyadWEQcqt5HEEOp19LuQgL+0+k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753276451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6p+xzN+wLyirMb0AuRivvb6HtwACpC6Hnwdv7MYVdp8=;
	b=cF0eayr8XzTOzy98lNe+wBO88EDpMkDSrKSDc0KBg5d/FVMAS31gXEoqilpctGjyE9ftxA
	PQAoFi6zcDJa1IbEqvH6QknMBE6nuJpJ9PDOPL7WfLPLdgYv3bV57oCzzsaaiRalZcywXX
	NtAt042c5MQ/dKx699ls9wCoJb4WGfc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-TvoyLeRsOtCDyIc7IZv28Q-1; Wed, 23 Jul 2025 09:14:08 -0400
X-MC-Unique: TvoyLeRsOtCDyIc7IZv28Q-1
X-Mimecast-MFC-AGG-ID: TvoyLeRsOtCDyIc7IZv28Q_1753276447
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-451d7de4ae3so38351605e9.2
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:14:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753276447; x=1753881247;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6p+xzN+wLyirMb0AuRivvb6HtwACpC6Hnwdv7MYVdp8=;
        b=EkbDB8d/0nt0buNVnx6fEDaLlj8e4peS2nAkQSRxFttcR4/PW1tG8x7LAx1cjsRExl
         Gir0zQJ0zOffAAFYydd+mZ9o7z+J3J8YGPIYRYjE32BPeGH34Og8zLK4HLebNsD5I1IP
         eW54oF6YDZW43OJriiYcKu1mu0UgG/XhHSK6cWqMJudaD50Nf8lpW+r682GXy3WDV2ON
         Fj4SR4q83UkwRTn6HpR++KpnBz+jTj9bbPuB8UQvMXPFFH6QD4T09hl0TxA2ZrqlKOdM
         hT3cKNr7+No5FSSqTZU+NDhdwaPpkUZwfWyOf1+fa2rYGJw4M7Vwq9A/R1Hp5cb7uEO2
         LHTg==
X-Forwarded-Encrypted: i=1; AJvYcCXtYsUNEBdYUYK/3IcGfh/CpNCtM+MkXV1odhT30fz92xeDseRW5BTgLJ3Axw2zCWfwIBcBqusKBg==@kvack.org
X-Gm-Message-State: AOJu0YzrCbLzQapJkSuBgasftRKQSM5klFsO7Gn7UFKNRUPCFXDbcZxX
	Vt/DKN0Fm1+M/AVoMEPFFyLx49tAbrqAK7WFAljUrqugPOR2v9H6hqL5DWwLnaqttL3KO1afda7
	mKkIvJkjgk7zPALri8KTZI1ngyJtoxVyUWKS2JvzrKasNcW0Ttntx
X-Gm-Gg: ASbGncuBv3wNfwN7gxGHK/hNP5titcszGFnORtMvXpicZDIOj0LW+WfDpWlyDtHA6Dd
	0RKk/1/xSTd8sC2LmRksk2aJJKOnsW/uElg/C416b/hEyKoegEr0nxlJ80EYWphDrpHAw5w4k7X
	kkeaBQpJUsrd+9qBloICfKjsnNvgb0STzcRFvZTWraXsfPOCP+U+eHgQDlKwRSD1qAo+0b9dI50
	SOzUdqlyp249CtBWYvItemUjFt6cq9R6LCaTXuOOJBY7vOv+eSCjY5bWaASG//ISzAkb4Lqk/S9
	vn6aZUbo+MLz5XpkguuK9784LCbpZYUBA8CPsoAqFXT8E6cKczrPoUADMVxKrX1sG5duya76HC6
	d+iE8z2Ewvsr2wSUNZ8Nb6hTdNFl71cn21a+nZ9ygiBVVQzzdayh2tZ8N+kl6R7Zf1sM=
X-Received: by 2002:a05:600c:630f:b0:456:2bac:8f8 with SMTP id 5b1f17b1804b1-45868d485b0mr31823405e9.16.1753276446909;
        Wed, 23 Jul 2025 06:14:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGX5hmVs5THsV06/0nHz8W3x3Vy+uGKXy6UR1ic4kjB1KcfMlE4URZuALTwA30TESjz4cMu7g==
X-Received: by 2002:a05:600c:630f:b0:456:2bac:8f8 with SMTP id 5b1f17b1804b1-45868d485b0mr31822865e9.16.1753276446335;
        Wed, 23 Jul 2025 06:14:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45869199605sm22885035e9.14.2025.07.23.06.14.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 06:14:05 -0700 (PDT)
Message-ID: <901d2b3b-66ed-44fa-8c45-291be23734dc@redhat.com>
Date: Wed, 23 Jul 2025 15:14:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 04/22] KVM: x86: Select TDX's KVM_GENERIC_xxx
 dependencies iff CONFIG_KVM_INTEL_TDX=y
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
 <20250723104714.1674617-5-tabba@google.com>
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
In-Reply-To: <20250723104714.1674617-5-tabba@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bTPt3QEklxH__OwTTc86APZuOxhLIPpRg3wNsZ-HRy0_1753276447
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3jgg3r8rkqot4zmnk1aq8jguphiyxsjs
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1002A100013
X-Rspam-User: 
X-HE-Tag: 1753276451-863071
X-HE-Meta: U2FsdGVkX1/kmlmml7zCdDo5cbZqrlm3eSrdVJSQNoh5hv1+sIwLIdLMysiV3wtT0BnQ3JqZ1hw5YEqLCDgYmf0/W6WtDXd5lONyLumH1OMkgG4hhr+ZheJvhui73XN27OH6dy+ZKyb+pqDdSicLo52Uu4RVD2gbE8+ug6nkotaBBcNg+MsvWzewg7WKhp2Qj8eUe/zUnhtkgq6i5KLC/LGvZaT1fuNi/2bzEr69P8fUEbr067ubqxi3NTR4qNe6VqCaWWKN4JvzfnfjfRwe6z+/9w+v2uOBIl8r/zgFSUlqBZFtnTLUOfncHDVHAeLMJy7apd7uDOq4wk+XDHK4nmt+GT9utwlD6hWgOkaqQYL+8Z6GI1OxkG+b4nA8Guot2Sc6YCpajneAdjoDUc7e8H5s8S+XOOKJ4cIOZZupMH60iaGx0PvvpsEB4JgAdGy4vyqw/Yp1Zn9Xh85LCGcZpBe8KaGYfh8gXRE1waWS26Rqq/fl5YOR/1j5HVeImov1zJW8Pa1iWuXR9x5zvioCXEwCasVKxsMq6Y8bnVkCmb9mheIuqc2+NG9Vmnm109HyxqfNPzM/OatAkd64gRrWZBrsZchrvVPXAJm0YrSo3nF304hmtk7dxj6EVwRT4NcUMhJJ0U9y9b+WEk+/giMlPl2+CtxLjeW1F3A7w84QBJIh4qPDIwcy6bW8NQCRll1N6QYkwWwLMs/j+e9fjFiVWCDAp29IGQ18xoZYFf+bZP9HMZ45uz86vcXGkKILeioD3wjpe81PqH3FVST4evGhhXHLTjefqYF3IGj3OxytZjhhYQgzih+dGgK0CQBhc14e1azT0sCSk5K7jcjaHZqxtiPK9mkTjpx0YhU6SOPW/XVRnplOM2taXtiALG9t8SYdAZ9o0vphb68wUOvGqI31Gl6IYEqV/7sXZpLkN+fMTMHzbyw4h7E2obfikB5rArWfedOwzfYEr5Htv/pzBSl
 +Ss6z+HK
 JCUikBkrQOZ88fS6B5XrLotGFfKUgdzf9SYzcaQSP9Z85AEavJD+Y5kVwF3kfEA5HfDgI5uJKQItP89pk4D1MOUosMzh5LHsdtpm9a1EcUB3nH7uBeU3hswiRVPu0PhIqH+exfZSoxjLjw0nC17L+KQP+mBTk3ljFRC8Uk3OvR24ncYn9w6m7FBkb3FLxNmXOFQA1bldstSgLG1y0B8OrPxB0vu4lFb98kY446tfIcy2VMbtGFPxzaUh2R8hpdIJT77xo1YmeWiyexn4B1T7OX7DqcmEuUcT+YXY4WRSonQvgRkLg/b28MzaYxGgZ+9kEGSND27rc3Ym8F+hnU8pyXheYEJLDLPGyAxT8G57FYn8tef1OeVXVgKDkCheih3JL+ex/dQapnnPimg3SkvfjI9NOAS6CIbGWSDuUHfL5YTigCgheSL2VJw8KCW6EFlcCIcHqyUShqHHkaWf2OIP444f9dNslESiHb22zTP4GxqxcsBVzNjlIxFSxwDj8O171/fQyBQdc/oXjATylwsF9+ORIw5qsnqzmjeGG0g8XYeZ6L7gf0fbRUfVI2CGo14el4B9J0XE/J46Fb9zPyeSnZFYE3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.07.25 12:46, Fuad Tabba wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Select KVM_GENERIC_PRIVATE_MEM and KVM_GENERIC_MEMORY_ATTRIBUTES directly
> from KVM_INTEL_TDX, i.e. if and only if TDX support is fully enabled in
> KVM.  There is no need to enable KVM's private memory support just because
> the core kernel's INTEL_TDX_HOST is enabled.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


