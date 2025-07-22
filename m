Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0988C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DE796B00A3; Tue, 22 Jul 2025 11:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5DB6B00A6; Tue, 22 Jul 2025 11:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4B46B00A7; Tue, 22 Jul 2025 11:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 385C16B00A3
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:51:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C1A3E8046E
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:51:12 +0000 (UTC)
X-FDA: 83692339584.12.49E776F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 641DD1C000D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:51:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cFTGAGmp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753199470; a=rsa-sha256;
	cv=none;
	b=SIrMpAP5tEKZunHVlMgDHqV9rNmu6K5NdcVPHmy0MzF5Xs2Q5PXGle1g09sfFs3cmJ9YPK
	NHY2Kt9Ao2PWcrQ8+AsMWWr9HdtSiKqKw6+pvipRxN230tEX7V1k40X0shipz/si6poDlm
	pBHuctPRMfyom9zKdRwdKG7z2GTH1YU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cFTGAGmp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753199470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SlkGDyZmqfarTxh5iJOxgcRyWvjlf8J8u4Rc9/G05cY=;
	b=sTziVWPOXzjFmA1ab6uNOYlcXIoJq/PmhqbYYtzKDdMSnJxbWKp4/uWBhXIt+XklmZwv+A
	+WcGr/aJnHcYv5p6dve1Nt/iAJGtqn1MmGTO5CYC2AB4T9oExT5Jf6oxfzrwCVqO9hosSX
	TwPlkgzfoyRKba/FZiQJppLYLzuj8UY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753199469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SlkGDyZmqfarTxh5iJOxgcRyWvjlf8J8u4Rc9/G05cY=;
	b=cFTGAGmpvVQbIKYEaqHqYHiCR7bOqFDTDUbQb7Zfgg5bn7+ERPr6J5bpMJH3Xufp+WBIT4
	ljTw29SzvZOZoIoYcJE8EOjPHUVlv6e9NnHaM8QDunsd/9EKHubP83H329N9GjnWKm8Mit
	pEeSRSlVvay5a0gggpuVHvWkgYMl9Oo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-IUeY9GhzNfKne3Ey4XfbeA-1; Tue, 22 Jul 2025 11:51:08 -0400
X-MC-Unique: IUeY9GhzNfKne3Ey4XfbeA-1
X-Mimecast-MFC-AGG-ID: IUeY9GhzNfKne3Ey4XfbeA_1753199467
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a50816cc58so2059774f8f.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:51:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753199467; x=1753804267;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SlkGDyZmqfarTxh5iJOxgcRyWvjlf8J8u4Rc9/G05cY=;
        b=WRIMm8CQQiHmDzYJ2RFiqEOd/VCqwSeHMqTF74pV/WWIiK/Lo4apSKJB3dJ6Wg1DiM
         REO9E4ZwOZzs26/Qi9LxeX3KlGi0ifvtoTUIB0XSBOiqqlfDwN7huZ7qlJ5JMKKdgVYR
         flXWM4ouzj8/zCH012c/MYgZNNcqJiG5EYkBcg8ok88OVNyIB1pYzy2O/kYgFZAFlNgj
         TA4hiKA0Ehi5wXg6xsK1TEZ1M+9I1jxiIvJMY9VPU7xpAdXyEUnl13TDbRVUaXfPeAfQ
         8YMifadfgbZXOuvbHElKp96/7brTedNLQN5EX0wiZyyxKXQNIkgvSq1tWNM6Lnxl5iVe
         2T4w==
X-Forwarded-Encrypted: i=1; AJvYcCXvaCOmYl9fFpuAPvVjYk+YP+qz0TIQ/H4MCroHO49EJ3MnvFQnKmEsBcf1nIS0lcOMuLLiH6Zn7A==@kvack.org
X-Gm-Message-State: AOJu0YwcLHZOr4VVTgNyjEI/Wj6kZKRZqTizW6o9Ge1ST+puphChpmcn
	0PLRQl2VtABLLNpHJx79FL5DhOIOOha73e28iP2zJNsbPF9ksmZFNYYvonfizsdZlgk0YTDmE1H
	xgd3x5IU6v3c/xs1EVtqHSf2lU7EZ3fAGgDmp5AKLsqbhFGeR/JLR
X-Gm-Gg: ASbGncvwTcgp1QzcAEA0eI8udMkX3RWzGJEgdUKTN4MBY0p1+2AN4I8vxmsO3PLNQfm
	RCRotmJdfAdBQdpRug+Pf9oL/3nGQ1reCzMol0j5+1hEgqnFsmerjSV6jAmqA2kiNA5rGeeYGC5
	bjvF8lpm2Zva7+2JfcYoGXZLiE52JphD1j8zlj5RlQwqKgFIG7JPGwH9k/fgpaZ5LZBsNGccTF8
	FlWQHhMimvetJMuN95/4aQTzkRYYtBbligAm2s4zJ1tism2kv93SrCtNfuqIPxUaUhD2k4jeO/Q
	udCLfYH8cDnv6Uy1StaM2xuJlF7mP1gGQZuWRbnOJvMziyfL/kLUpW1ossOmt87qTEqRzBlqs0q
	UT+Dqo6VElR54031Nxv7GB6WeGRmTqwECE3+wV/Hp5GDXB6qG40AknnVV/FeA3nHOadk=
X-Received: by 2002:a05:6000:2310:b0:3b6:463:d85d with SMTP id ffacd0b85a97d-3b613e6009bmr18304996f8f.11.1753199466969;
        Tue, 22 Jul 2025 08:51:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkDfCaoi3LHsLkKqFiAXihZtN/+Fsy2fLKOrcY5Mqg0ADhJH0qc+QAMJ0yQdyroq1ofLrPmw==
X-Received: by 2002:a05:6000:2310:b0:3b6:463:d85d with SMTP id ffacd0b85a97d-3b613e6009bmr18304895f8f.11.1753199466286;
        Tue, 22 Jul 2025 08:51:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca48823sm13874304f8f.43.2025.07.22.08.51.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 08:51:05 -0700 (PDT)
Message-ID: <80a047e2-e0fb-40cd-bb88-cce05ca017ac@redhat.com>
Date: Tue, 22 Jul 2025 17:51:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 0/7] Add NUMA mempolicy support for KVM guest-memfd
To: Sean Christopherson <seanjc@google.com>
Cc: Shivank Garg <shivankg@amd.com>, vbabka@suse.cz, willy@infradead.org,
 akpm@linux-foundation.org, shuah@kernel.org, pbonzini@redhat.com,
 brauner@kernel.org, viro@zeniv.linux.org.uk, ackerleytng@google.com,
 paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz,
 bfoster@redhat.com, tabba@google.com, vannapurve@google.com,
 chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com,
 shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com,
 thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com,
 kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, rppt@kernel.org,
 hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com,
 rientjes@google.com, roypat@amazon.co.uk, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, kent.overstreet@linux.dev,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, chao.p.peng@intel.com,
 amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com,
 ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com,
 pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com,
 suzuki.poulose@arm.com, quic_eberman@quicinc.com,
 aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250713174339.13981-2-shivankg@amd.com>
 <bdce1a12-ab73-4de1-892b-f8e849a8ab51@redhat.com>
 <aH-j8bOXMfOKdpHp@google.com>
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
In-Reply-To: <aH-j8bOXMfOKdpHp@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: U7lJVN0UWv6n1J1S93dieJ4ilr0kYobW8xIBvSYoGVA_1753199467
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 641DD1C000D
X-Stat-Signature: ayy6tuh1nhjbnigshtsei5mjffhu9t6s
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753199470-707495
X-HE-Meta: U2FsdGVkX1/VYG6Cu80dJqfI+a8OAyQIIvtqNJ/xSbJ6wf33h/lWCOPS0XzEDygGVjsQ3OHR9dNRnJPJP88keTLj4GltQxMI/se5UopXXDQCiqy6okBhQmPjtfyg4dKbIGv3A/h6F0eT/+IKzlLUWXY5Ho3c3BRVkhj3Cl+DHQY7/3CBcqlcSEQ5pMX7lX7SGK9LqTSkkjlQeiOsq6i2g9DXyZXCTmkyP66bFYbAFdP56DY0AAbbGsKcyS+C2rUaJ52/yXSSCtYPV9MXiE8cTkvLw389T6+zTccrzpwfgOGAFygM1ALe6mTRLbiY+W6p8AYNAqQOq51p51rM7Qo7Kbwx1InoupEhz5MDWcml7DfnNOxXQFUKqoqlYxWGrvSTBCDbsp0DvIxArUD3+iAvvj5xv0CM3uJhQffAGv56lQcEAanou/7ePbSRePmDNjejwPARGXOJWfwxCLeN/m6Bz7J2O0Js4X0GHvURlNwKzBDrwKvXrzbSm1xFyk9s4ux2HvbuTAPpBVZpQk1zBIbggW/A4H8X1vpH+Lz1nw9uf1M/yBy/G1iTvfawPi0odR9C5/FRaQlvurY9raWxY3SPnJowQFTWu4Jlu8f/QFVFLPh8CSwcb6gCwHo4YHrvSM+C3IW6doRMGD9dVKD9VwCkN8HL/C8MD7IvgkY7NRG1Ae61XmaUWwHqhOx9YRJuZlib+2kB0yWy5zYYZIPFhUS8wxFfcxnwh04AsCJ35MH8l90VUcMJmh2hRKjgFfd1x6mscKEcTr6wIcADXfq4tCv2mBtb4PU7zuZshbJ6I80uZBzqiTJVU/vgsy5eA3AGL7iN1sz/m558C9vFA+YiaCoi/bsWUk4E2EL6klYXLwMH99M3budvN7Q/+jQ9RxMHVrtJZD9rZGITOv8P8sMEZfhdbTi4rVu7SZ0EqKF6DCH4a0NdpS/TTMW2BEXkFNRlSd8Y2seiLSerso/O9gis9WS
 HXAhhQoL
 pov0g6+oyAqGS3sd+JRRlagZWV+nGLJ2pbt5Q3CcObViztyr4DpT5zG09j0M4OPIXWlXMDh0gStJ0SAINojDv3Vqacp0bjp5IEKOVJnw8/usHjErG012+AwtRCYm0CPEWISD5GLZuk2C3mEojdD8sEMjNLQbOk5Pojb8r4/woFbGHEk7zXKQA5SHvTclFKdB45v0XdgJaP0pFFu7JCOObiMD9OtcgRrrAmWaYDkrUTyLoBWuSvKWf+Dsdgcd+X2Q2b92u7IBfoRcLbDXQfgZXji/XSIXNl4dEZuKfeVCsODeQL7OrvmFBGmayHAvaZtzoC+8pc0hTEN2auQGaH72cXx5WlvLtWhLEOagzh8NNI/B5AuxqH6dYh7azyRGZgQzRXz490/RrSHW7YmWqVibSYzbRqx/U/75TyhAPZzNZJZ936bEo1xRJIRW8Z0TVK0GUZHoE92Tb5ts1oCUb+oSh6sbNBdljs62In3k+9PAWrOBgvFH2ACm9PVjY01Lbjfadpmi761UXtTBjpDyxYMTrwYHN33fzsvSNaHxC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.07.25 16:45, Sean Christopherson wrote:
> On Tue, Jul 22, 2025, David Hildenbrand wrote:
>> Just to clarify: this is based on Fuad's stage 1 and should probably still be
>> tagged "RFC" until stage-1 is finally upstream.
>>
>> (I was hoping stage-1 would go upstream in 6.17, but I am not sure yet if that is
>> still feasible looking at the never-ending review)
> 
> 6.17 is very doable.

I like your optimism :)

-- 
Cheers,

David / dhildenb


