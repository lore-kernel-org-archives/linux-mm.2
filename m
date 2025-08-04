Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87902C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 08:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DA086B007B; Mon,  4 Aug 2025 04:18:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2936B0088; Mon,  4 Aug 2025 04:18:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE25C6B0089; Mon,  4 Aug 2025 04:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA9E66B007B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 04:18:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 828F81610D5
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:18:37 +0000 (UTC)
X-FDA: 83738373474.28.E190ACD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id E1438100004
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:18:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ggWtJtI/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754295515; a=rsa-sha256;
	cv=none;
	b=NZoYIdCNEPhFq4O88VCapWlHP+cD+I5wy8sJlTqB7YKMaXWCZRb0TvZ2cDGCxhW3Omg5yd
	+z7D8wucq14t+mACjsofi8+ev/+VLyDLqshp9uZGRJJgTPmNssjmIR35se/BKXk+H/a0i8
	6PQ1IxBARmHIVmuOf9iOO6749spm+/A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ggWtJtI/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754295515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=03VTkg72jBgLlbJ0gR0pMgPL+qT8FmKqbpHG9wdlaHE=;
	b=VECOnZskzbp9V29RUoHNbs3kQFmqyJCcd9Kx4lBN5d5Icb3YNt3I9a9CxgG/JX6IfGbbFh
	qr2QW2qvQlE5YGDh/RpuHMRVdsDGmCktMf/B+jHsBhBe+bMtr9Zr5JKhHdbXhATYy9uQVb
	cmaA8l4rRYD5UDo0Jj5Wvmho79yUIgc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754295514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=03VTkg72jBgLlbJ0gR0pMgPL+qT8FmKqbpHG9wdlaHE=;
	b=ggWtJtI/kyzHewpj68OXADG4FUF+9bu2UTnvhMFXQ+72+ljr7V6CLGSs0tPFcJ+bFW+6dC
	l8IdTrvTXvI7AYyUM1KXvgMlsjD98whkPNeV1Jvj5LZsJ+v5HPoSeRV5RDS1xBy7pP/phc
	ryffLlLilTUw8tFE64md1Sqvng2wZ4I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-IuB2at8wNpaSI5Tz6ILXRQ-1; Mon, 04 Aug 2025 04:18:32 -0400
X-MC-Unique: IuB2at8wNpaSI5Tz6ILXRQ-1
X-Mimecast-MFC-AGG-ID: IuB2at8wNpaSI5Tz6ILXRQ_1754295511
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45359bfe631so16401905e9.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 01:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754295511; x=1754900311;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=03VTkg72jBgLlbJ0gR0pMgPL+qT8FmKqbpHG9wdlaHE=;
        b=uHQGhN+e7zg/33FBI/rD/Xw7+Vjm+1CkWYn5oPba+EuqtoYbi69zV27jp44C59Iytb
         8mgq32te/NKCAhEYiGLd9kKTa1j8VUkpLMWQHLZlfs4gtttAE8blaaBr6Y3Y7GnFdMFd
         v+XyM1nEBBPJJKrXd02dSE6L02IN4Ab5s6aS015B8Ga9or+bfCOJu1TKMblekk3+AS95
         NwViQ06LD46ERYzCGArvXzorxeweH44I9CjD+KxoJnxQjy9br5nTLHffq11jTG138d3c
         NqOuKXtpzJ8DhrIsvvihZtjXz3kcPMRy1zJIUFAUwp8KTWYgwonb5sUosu16sPtA3h9+
         370Q==
X-Forwarded-Encrypted: i=1; AJvYcCV2B0zg1M0BEaLHu45EzxwFrJsf8Y/VAYTZsMXmL+y0zLdbDIcQ6X0HhU4huYLaYmqQsWQC5yo+Ug==@kvack.org
X-Gm-Message-State: AOJu0Yx0TQF1O3u5+NC6tAbOMIOtbgC4yuR2Lw9PwjOZem2c5HjKZmdB
	LBBJaFoomk51XEyuvV76o3yYgrd2RCE3dXFHn6CSxykIkiAQBlz4BtvwGx5oaKpEOzTnruoGai8
	7k0vGbfAtQ64rOdUHC4WSqy/QQvXMk6pRUocUwYFRIZi9UHUy6OXH
X-Gm-Gg: ASbGncswGeo0iT9wBXbPqT7FKXSxtLWRPMXEBXexC7EvWtXLJ8w/flCOWOWLNSJmb9r
	SK/J5Vk75zfAwnl7HrvxdFW4hQoicttV5lMziOfUEpu4gV9gJcbBAjrGqTcKZ4wcxNH7PybZ6YM
	hg0f4ZpbUfmafO0xldMBflXcMQS7mxGpDlXKiskz4JKP8AkT7DqAUSwSQjfQzY/v55DKKXQY3PN
	sz5zHgTAoFAsfwGjCbTGZJzPCnjT3SFuDWm0uleTnu8bK55iJDQWcnIP9z2PLWTAAv2TqSijUq1
	ZYHaHa9kaThGGbvP+XlOVMzZ1UH1JGVR/D7lS5e3beE+gv+vdgqfb8GTltacrBHwt+x5fdhXOHH
	2PdAGdjBmHAUDZrFx0lKu4r83TZ57bdF9GnsLwxF6xkViWXAjYrp+y2FWytVEL0QKRUM=
X-Received: by 2002:a05:600c:630c:b0:456:29da:bb25 with SMTP id 5b1f17b1804b1-458b6b319a9mr62347205e9.19.1754295511152;
        Mon, 04 Aug 2025 01:18:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPlqx3gyV0juTbAVjR35GMx/1qDB3P0HrwB88TY0MgfTIBNCbUTSygE1TMTy2La5YUlfvLLQ==
X-Received: by 2002:a05:600c:630c:b0:456:29da:bb25 with SMTP id 5b1f17b1804b1-458b6b319a9mr62346815e9.19.1754295510587;
        Mon, 04 Aug 2025 01:18:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4589ee5790dsm155654825e9.27.2025.08.04.01.18.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 01:18:30 -0700 (PDT)
Message-ID: <e290b9c3-7bcd-4b6a-9e5f-dc3c7d3d43e4@redhat.com>
Date: Mon, 4 Aug 2025 10:18:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] [ntfs3?] kernel BUG in set_page_refcounted
To: syzbot <syzbot+2a0d2af125c01db73079@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, almaz.alexandrovich@paragon-software.com,
 apopple@nvidia.com, byungchul@sk.com, gourry@gourry.net,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 matthew.brost@intel.com, ntfs3@lists.linux.dev, rakie.kim@sk.com,
 syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com, ziy@nvidia.com
References: <688cfb9d.050a0220.f0410.012f.GAE@google.com>
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
In-Reply-To: <688cfb9d.050a0220.f0410.012f.GAE@google.com>
X-Mimecast-Spam-Score: 1
X-Mimecast-MFC-PROC-ID: 0J9Ds26NQ49YsExWcoM_wRwRj9pEH3nh-1wIAooiFrQ_1754295511
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yk1wj6rs7i1gc98kd39tauoxcw89gheu
X-Rspam-User: 
X-Rspamd-Queue-Id: E1438100004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754295514-146585
X-HE-Meta: U2FsdGVkX19kOGojyXM1zmC/X7khOqVj1arZ/v6+Gyb8cMDI1v5OJ1O8yxAibMOlZPkSdoOtYEqMjm81F5k4FWR0+Cfz5lPIqS+jDvgdu3G+UtuSSU+4amUTjIgPBkvPH2FKe4Fcmg6JkB6ZeNYtKuAXJZSrIAzFQX7eQrKNZ3/fTjqxjfPx/NVPRvfIflXHbP2PVaUb/4dbxoZUPfLNxRw7/eoKKBBlm81Wfm+N5Pr6dwedv2Yg5sRY3vAjCpDDLi5O9Nn2m5sRvsvxQZNSmwJVZjL25WATTIFP0ReCZ3z6vWKHL/oqSx6fEo6NgWcAQan2vVAU9YSHVD8/ktnsYuDrDSLElU4Ni0j+k494l8NgR22BRT0wYbt0mcFjQ4/nYb9cKZyLWG2jtsAiTvOG9WAjz4B48syhczavuZemkoYOAOLnuAHk+RfnXHmHg9mz43Y5rUMMtL068RCBaM3SbOIL/UIKpYTK9n5kMFcuXBvJlr63HvpMzi/st43vCkuAC5dVMu6uq3LPdnFyT5hNbc2yN4ZxcAw1OBuh7ZLYBb5AYZntA+Nqr8O5ZIhKt6T/PGeRayzkdwK/TpgSfM6X3oMC749S8FU+fSD6SLLLLdKbP7KVOvNKxkLJZxzAXgKJgPsHel9zXFOPJWux+Eov0ncllzfi+6MHZXFDGIKOGBzUc3EcidSXw1L5wqtl7wUZb2WAS5JH23B9HI+XgKaCPY4IDI+daoDaUDvppFP7lR1T2WWySwOQFElLviuoALDVdy9ZPRbGmQfqOQLdzbJLhR3PdqZpwkL9cPcw9VoDtco6iDovXpJk4x0GP28hhuN+VQBYlnkPEUO7zDzzOxExgEMwqS16qO25oRGobrakAFHtDvvD+NOTy600eR11D+QchL4Ij8t6HKe5h8vLBnwDQKS7X217KVWn0UJdUfQYFGqsnznXzG3THXviEBsgJCxrXA7kMMcWu3D3j5yP2jG
 AUZTlz8E
 3f1ZzlUjCrqkWktLP7m1MuSxcZgBC9XdtiGZrQpAwiygjTMGRI1p45wqGjIlChGpbns/kvs3eN/8ULQRORJ5fFkd1KRVIV0UEBeJIz1je32XL1b5tdFek8ftL1FlsgIgBm1VE4KUphcFEwTBNKnITfwM2kILG9IKcYrufq0LedGxgPKze7etvks/P43lLcB2lUqH99yLn7bh+7PjvGEQH9nRcMl3j9Q5bStjdrQjGyMTJsEsjMl4oVQiTXjsrXIHnyzTz4awj+8tO+YiNYMTZTlTfFO+SW9s6DeGY6hi1ccNyfj47P3BeOiSBjLYXWEHqMXSj2ZshyhNVjyScQzvOb2EJ2Y/QoTtGaXqPgTeH3Gb+Ewaa2B7YABHE5wJzEp5W0k3kAbbObXW7FNnXUGDuqwwPWRhV2bD+/hN7/nqccgxVsGVslkadDP6mI5eSqXYzwyLlOqoddoIFDN5mfJVibXhUbk0AyRLszO0MX/+yTORSzEDNX3Ky/jKCb+qA2GgWZaqEkyOtnwvXtF9xEr3NakM3yIbunp6LMTa9Cf2jJSeM1B3vGbbpTGBNbK50rsX05oxpG9PxoBIFi1Sda9qMMM8dbTnuPijda29Ds8qewPaKhAo0Avd5GY1xMY+O11Lwp83Mz1vOSSsK2gMHtTGQQJZ05LBnsXWQns3wgrYLxbtnFyhjWprhaTmX39H2Xncsn6WOIPzlsKBQyzFcoCQvvWTrJ11kcdTxxG9xfK6EgWBWRbiUyfp9eYCAGvXuuxRqvuRpd1ZfdzKdZrEq9KBnAgXkECRWIh7DPIndDZMdJg45kMDeYpwb9AG35E64DXLsf/Ixjkjd5X4oi0DZTVi3nKc4YUsMfvGcymYJ+5I2NrwTpWFDaRgZjUoJ8M5ySMQMbmqLvu290StaWq6Qq2CRBxqBPVrDYslD+oBHVCmXzr2qow9i9wyKQWVEId0XHJvYgPJdJwxCdabBGRDLa7StOcaXn5hx
 xzvRPQif
 W0Bx0P+OZGdMqceQryuprM3+kgVqPiWmdueO96th4UbKCOUGC2djbkWai5Zk4dGFruJD/ImNu2VYFSQWcJdL49X2km8XQj2YmWLX7TEM2dBEEsbshXf5XH8GKqfeQoKtsuZjc3QsX2sm5+D6pFwbKM5UoETj0eThKj2Agf7blTI/tzcnswoz1/q78A69Gk9nt0ldh1B8IU2sUQJb07PCV6LK+MFKeB0X9Q9l20aBhOtwa67rGxcBYanqSsZ8RS4qtaCVVwJDXNoaZugp4t4POMLN5QSxaKtkk9bqXWs0wYdV5E/JbAJLRTiyS5g62aAxGv1TP5dK7RhdLHzOTsFSO+iOO2fL+TRo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.08.25 19:38, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    260f6f4fda93 Merge tag 'drm-next-2025-07-30' of https://gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15c31834580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=bb7581d3fb1bb0d7
> dashboard link: https://syzkaller.appspot.com/bug?extid=2a0d2af125c01db73079
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149062a2580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/1fce1d4d56ce/disk-260f6f4f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/01688cdba884/vmlinux-260f6f4f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/eba9b2f77e6a/bzImage-260f6f4f.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/95ad5335ac08/mount_0.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2a0d2af125c01db73079@syzkaller.appspotmail.com
> 
>   do_group_exit+0x21c/0x2d0 kernel/exit.c:1105
>   __do_sys_exit_group kernel/exit.c:1116 [inline]
>   __se_sys_exit_group kernel/exit.c:1114 [inline]
>   __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1114
>   x64_sys_call+0x21f7/0x2200 arch/x86/include/generated/asm/syscalls_64.h:232
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> ------------[ cut here ]------------
> kernel BUG at mm/internal.h:491!

	VM_BUG_ON_PAGE(page_ref_count(page), page);

We seem to have page with a non-zero refcount in the buddy.


The Oops below has a VM_BUG_ON_PAGE before it

[  531.894112][ [  531.894112][ T7687] page: refcount:255 mapcount:-255 mapping:0000000000000000 index:0x0 pfn:0x460e7
[  531.894153][ T7687] head: order:0 mapcount:420858112 entire_mapcount:1009385984 nr_pages_mapped:6946817 pincount:-7831513
[  531.894176][ T7687] flags: 0x80000000000000ff(locked|waiters|referenced|uptodate|dirty|lru|writeback|head|node=32|zone=0)
[  531.894219][ T7687] raw: 80000000000000ff 0000000000000000 ad00000000012200 00000000000000de
[  531.894240][ T7687] raw: 0000000000000000 0000000000000000 000000ffffffff00 0000000000000000
[  531.894261][ T7687] head: 80000000000000ff 0000000000000000 ad00000000012200 00000000000000de
[  531.894282][ T7687] head: 0000000000000000 0000000000000000 000000ffffffff00 0000000000000000
[  531.894306][ T7687] head: 8000000002082800 ffea000118504800 ffea00011915c8ff ff8880273c2a01ff
[  531.894327][ T7687] head: 0000000c0089feff 0000000000000000 0000010000000000 ff88801aae000000
[  531.894341][ T7687] page dumped because: VM_BUG_ON_PAGE(page_ref_count(page))
[  531.894363][ T7687] page_owner tracks the page as allocated
[  531.894372][ T7687] page last allocated via order 0, migratetype Movable, gfp_mask 0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), pid 7405, tgid 7405 (udevd), ts 508249020508, free_ts 508221042792
[  531.894410][ T7687]  post_alloc_hook+0x240/0x2a0
[  531.894458][ T7687]  get_page_from_freelist+0x2119/0x21b0
[  531.894479][ T7687]  __alloc_frozen_pages_noprof+0x181/0x370
[  531.894502][ T7687]  alloc_pages_mpol+0xd1/0x380
[  531.894531][ T7687]  vma_alloc_folio_noprof+0xe4/0x280
[  531.894560][ T7687]  folio_prealloc+0x30/0x180
[  531.894594][ T7687]  do_wp_page+0x11ee/0x4910
[  531.894623][ T7687]  handle_mm_fault+0x97c/0x3400
[  531.894652][ T7687]  do_user_addr_fault+0xa81/0x1390
[  531.894676][ T7687]  exc_page_fault+0x76/0xf0
[  531.894700][ T7687]  asm_exc_page_fault+0x26/0x30
[  531.894722][ T7687] page last free pid 7403 tgid 7403 stack trace:
[  531.894735][ T7687]  free_unref_folios+0xc8b/0x14e0
[  531.894775][ T7687]  folios_put_refs+0x569/0x670
[  531.894811][ T7687]  free_pages_and_swap_cache+0x277/0x520
[  531.894832][ T7687]  tlb_flush_mmu+0x3a0/0x680
[  531.894851][ T7687]  tlb_finish_mmu+0xc3/0x1d0
[  531.894872][ T7687]  exit_mmap+0x44c/0xb50
[  531.894902][ T7687]  __mmput+0xcb/0x3d0
[  531.894924][ T7687]  exit_mm+0x1da/0x2c0
[  531.894954][ T7687]  do_exit+0x648/0x2300
[  531.894986][ T7687]  do_group_exit+0x21c/0x2d0
[  531.895018][ T7687]  __x64_sys_exit_group+0x3f/0x40
[  531.895050][ T7687]  x64_sys_call+0x21f7/0x2200
[  531.895086][ T7687]  do_syscall_64+0xfa/0x3b0
[  531.895114][ T7687]  entry_SYSCALL_64_after_hwframe+0x77/0x7f


Looks quite messy "page_owner tracks the page as allocated" seems to imply that the page is indeed still
allocated.

> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 7687 Comm: syz.0.738 Tainted: G        W           6.16.0-syzkaller-08685-g260f6f4fda93 #0 PREEMPT_{RT,(full)}
> Tainted: [W]=WARN
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
> RIP: 0010:set_page_refcounted+0x142/0x1e0 mm/internal.h:491
> Code: 48 89 d8 48 25 ff 0f 00 00 74 21 e8 18 4e a4 ff e9 2c ff ff ff e8 0e 4e a4 ff 48 89 df 48 c7 c6 a0 47 17 8b e8 4f 05 e9 ff 90 <0f> 0b 48 89 df be 08 00 00 00 e8 3f 27 03 00 48 89 d8 48 c1 e8 03
> RSP: 0018:ffffc900065f7670 EFLAGS: 00010246
> RAX: 0ebb44fe4874cf00 RBX: ffffea00011839ff RCX: 0ebb44fe4874cf00
> RDX: 0000000000000001 RSI: ffffffff8d1dbecc RDI: ffff88802f581dc0
> RBP: 00000000000000ff R08: 0000000000000000 R09: 0000000000000000
> R10: dffffc0000000000 R11: ffffed1017124863 R12: 1ffffd4000230746
> R13: 0000000000000000 R14: ffffea0001183a33 R15: dffffc0000000000
> FS:  00007f4368d266c0(0000) GS:ffff888126c1e000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007feecfc73000 CR3: 0000000034c06000 CR4: 00000000003526f0
> Call Trace:
>   <TASK>
>   alloc_pages_noprof+0xe4/0x1e0 mm/mempolicy.c:2513
>   folio_alloc_noprof+0x22/0xc0 mm/mempolicy.c:2520
>   filemap_alloc_folio_noprof+0xdf/0x510 mm/filemap.c:1007
>   do_read_cache_folio+0x1c0/0x560 mm/filemap.c:3885
>   do_read_cache_page mm/filemap.c:3989 [inline]
>   read_cache_page+0x5d/0x170 mm/filemap.c:3998
>   read_mapping_page include/linux/pagemap.h:993 [inline]
>   inode_read_data+0xa7/0x480 fs/ntfs3/inode.c:1054
>   ntfs_fill_super+0x39c8/0x40b0 fs/ntfs3/super.c:1533
>   get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1692
>   vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
>   do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
>   do_mount fs/namespace.c:4133 [inline]
>   __do_sys_mount fs/namespace.c:4344 [inline]
>   __se_sys_mount+0x317/0x410 fs/namespace.c:4321
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4369ac030a
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f4368d25e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f4368d25ef0 RCX: 00007f4369ac030a
> RDX: 0000200000000080 RSI: 000020000001f740 RDI: 00007f4368d25eb0
> RBP: 0000200000000080 R08: 00007f4368d25ef0 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000020000001f740
> R13: 00007f4368d25eb0 R14: 000000000001f771 R15: 0000200000000100
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:set_page_refcounted+0x142/0x1e0 mm/internal.h:491
> Code: 48 89 d8 48 25 ff 0f 00 00 74 21 e8 18 4e a4 ff e9 2c ff ff ff e8 0e 4e a4 ff 48 89 df 48 c7 c6 a0 47 17 8b e8 4f 05 e9 ff 90 <0f> 0b 48 89 df be 08 00 00 00 e8 3f 27 03 00 48 89 d8 48 c1 e8 03
> RSP: 0018:ffffc900065f7670 EFLAGS: 00010246
> RAX: 0ebb44fe4874cf00 RBX: ffffea00011839ff RCX: 0ebb44fe4874cf00
> RDX: 0000000000000001 RSI: ffffffff8d1dbecc RDI: ffff88802f581dc0
> RBP: 00000000000000ff R08: 0000000000000000 R09: 0000000000000000
> R10: dffffc0000000000 R11: ffffed1017124863 R12: 1ffffd4000230746
> R13: 0000000000000000 R14: ffffea0001183a33 R15: dffffc0000000000
> FS:  00007f4368d266c0(0000) GS:ffff888126c1e000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007feecfc73000 CR3: 0000000034c06000 CR4: 00000000003526f0
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 


-- 
Cheers,

David / dhildenb


