Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67972C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 16:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D717F8E009B; Thu, 24 Jul 2025 12:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D217A8E007C; Thu, 24 Jul 2025 12:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C104E8E009B; Thu, 24 Jul 2025 12:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B06AA8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:26:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5813916047B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:26:29 +0000 (UTC)
X-FDA: 83699686098.06.B6B30CD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 02E0580004
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:26:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dwOfw6uK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753374387; a=rsa-sha256;
	cv=none;
	b=vfb9o2XHvgzcGggRvows+Z8LSYzIhq89v3XQLNkZcbToNxHd9C3ruR4clF+ZtTF9vxOj4g
	7IbjM6oq+7DANtpsEHcGjIyVgWMmcfGOwrS/9tZMggabqiuciw2LY17kDWKB8Qx0ncEkLK
	nkY9SElwwytNG8QWiUbEPu//FFa3foA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dwOfw6uK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753374387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wCJmiHs91fWMJGcXllYI2ngkZBzpbp9RtMQBg2/8M4=;
	b=fD0p9QR77PQlznr0rt9xIhdWbx2TJ9cggU/iCP9NZF5Iuu2DDgOEzf1w3fYqFQ2Ruq2hK3
	8e/amRPFN4opr7Xqgm9uC80QoR6fhO4PEHKiHp7Qqb9RiD1TUxkYpQbCpxINBYI8kS3TFd
	fzMYze2y/e/9CHWGATBhsQc2T4+K1vY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753374386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2wCJmiHs91fWMJGcXllYI2ngkZBzpbp9RtMQBg2/8M4=;
	b=dwOfw6uKFzdp/Sxhp1QtK1HrZlFWlGnJZ04Dm+zF7ImiIFit6I3p//D7wW75kJBfyoIdck
	b6NZIZemdyF0bj0lR+RzidAKdyB16wNspttdfgcvrChShlUa8afIrL6WjGMQmlSk6G44kr
	cfiN1dlr/w/K64kS9IkePYwwxodESfY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-DFNJxgyENDibGzdpCDSx4w-1; Thu, 24 Jul 2025 12:26:19 -0400
X-MC-Unique: DFNJxgyENDibGzdpCDSx4w-1
X-Mimecast-MFC-AGG-ID: DFNJxgyENDibGzdpCDSx4w_1753374378
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4538f375e86so9583805e9.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:26:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753374378; x=1753979178;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2wCJmiHs91fWMJGcXllYI2ngkZBzpbp9RtMQBg2/8M4=;
        b=ljBD8PjhQugor5//09/QIvcgpcHS+miYm/5kNIkJWG9NMi9RHknJvkAIcah3Hr8048
         bcs4iJBUpPR09qdfXSNT0e4bn4D7IQZOXG1p1LCwFbf0F8FPydkHhKgH4H8zR8Ch6O52
         vF4oAqjCFYhwc+zhL+DnbtpTR43fGGcOcbwNbrL5QbTK66k7t/CWFb8gdvOJk8Wr9vv1
         BBo0kvgWjGmM+Ynybc50NJCF4BSR8LuSpeuOcGVAbp4JxKm8yeQ8v4WVW6RDaHKi1ALi
         qaJKcgazFAYkin9cA3KylebHRyCmgt2oAvL1gHBCGPcaqaFSzyYJufN3KU/Sfywoedg6
         icyw==
X-Gm-Message-State: AOJu0Yx5Sg3na3bf7zsLtxUfD/oIRjOgGXjUm7NgZjLg6XPTkWjcd9LN
	7GPKE+/LizC9V/vvE+FZ7kbqRgiM5CT/gEEdZOIbK0MzPvsw+T7WXNktUcx53Zqh/j+Yxrs2WpG
	qURtubmW6o9ALu1jeCCYY4zx6cWVOgApWvPZE1l39mOgJn73m3gsgRbYfWVGzsLI=
X-Gm-Gg: ASbGncuuVVbxlnaOGhwU7YyKFYPnUJ+3Np33sGNr8SJy07OzCGOnrUirli/DXPVdVDt
	fqyJl5ddxmlhQ/0fqJcbxXmLp3qbpFfGowK5MQHY5qVFYx5iTW7MuPqJc2QtF14Osr+CixiJlpc
	VvHxX/NWmCAlkEsEIKjYfWHJ5tiCh0iHCw/Z5BoYnxLmo3CxMirpaYbtwyN54dFPXRtx0fxKE+a
	j8LxsWLbN4X9eQDRE52jzVdNrOY26fFS78IvFZyMYl5/ZQce3kP6Wi2w4All9G/jtTFoWe5E202
	5ZwcD6pcIhE/2ElWICEyg08gjmo7YPo7ts+JSuBiSNaBWWNl5hUeqhqpIZjdAItTDr19/juAdGg
	kTIz3kXqSPySWuVaY8Urr1ghDOrlIunCCjnWUJa1C2J4bGofO1W7cbbtdH/PmlGP/V1w=
X-Received: by 2002:a05:600c:1daa:b0:456:2397:817 with SMTP id 5b1f17b1804b1-4586ef22d72mr27705635e9.13.1753374378328;
        Thu, 24 Jul 2025 09:26:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+5G7TGfIydnLso+oRUba37Jmb0wSxkNxasccKU1EnjIej5F4jNVLDO2jBw6bDea8i30U1xw==
X-Received: by 2002:a05:600c:1daa:b0:456:2397:817 with SMTP id 5b1f17b1804b1-4586ef22d72mr27705345e9.13.1753374377837;
        Thu, 24 Jul 2025 09:26:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f01:5500:ba83:3fd7:6836:62f6? (p200300d82f015500ba833fd7683662f6.dip0.t-ipconnect.de. [2003:d8:2f01:5500:ba83:3fd7:6836:62f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b76fcb84f2sm2534414f8f.62.2025.07.24.09.26.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 09:26:17 -0700 (PDT)
Message-ID: <e6e22324-c681-4073-95b9-bb6afb918371@redhat.com>
Date: Thu, 24 Jul 2025 18:26:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] hold PTL for several .hugetlb_entry callbacks
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 dev.jain@arm.com, catalin.marinas@arm.com, lorenzo.stoakes@oracle.com,
 thiago.bauermann@linaro.org, superman.xpt@gmail.com,
 christophe.leroy@csgroup.eu, brahmajit.xyz@gmail.com, andrii@kernel.org,
 avagin@gmail.com, baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 hughd@google.com, rientjes@google.com, mhocko@suse.com, joern@logfs.org
Cc: linux-mm@kvack.org, wangkefeng.wang@huawei.com
References: <20250724090958.455887-1-tujinjiang@huawei.com>
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
In-Reply-To: <20250724090958.455887-1-tujinjiang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kzX1urPsgq8gmJYGKQV15vdwFy9w9yxMJXmeEBgmApo_1753374378
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 02E0580004
X-Stat-Signature: fo3efrcwmujijjbc69dya75nbfjzs9uo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753374386-920459
X-HE-Meta: U2FsdGVkX1/VCYFX9r/s++j8T4s/hkUqPBjxsDmsCpccR8BSOYLNkrpJiOBK1AXXgGE8XOHmxJaDfQZyO4xeiOgMaE3VYOSuNIMBR1rhmYTXVDrPv6ESOne1ELZV5oztdQIE0S7UbpDKdu8bsit7kkn61XehNT+1wckp3RLV8G9Na2zCQZaOi97lOBL24rSSwz13oc9/Q7odjGDYvshB7LxGqAXGmiDXxKqI2WkSuph02nqFtO+o1KGq3X4c8deXmPUUBvsXkWyXsYGCwjWW5wHQ/csodh5XA4RxeyklH5olv+Lga6Rb/ym650lUS/7DcNgrHdP5SL3DAeLooljfhVCw8nYsbvg3eDd/4cKHZBGXsizU08ixkqWzfr2gXLOx0PZGxL7RY+30AZIZLdhPQ+j5H3lTguZzxkrlmwC9hWi5RfYtgrydGZFtBNaBYuKV7PR0SNcKHBCCwWXgpooiZj+5FTB7KJ9qde2cHi4E+SGEBFUTSxbsjvTgD+Fn+iZTBsVh9NYoKXDOFud6/27eEm/Ucv3Z6s5/n9bdEbtuAPlaGvF9EKngKiKY6R1utfXsKlN+TnAL+Lvp+JbJ10xhTfnvFbRaSiLMWARCVrgiPlhpWitstTkO3+9tFnT8uv8hugpY2SLaYQygXsN7+jFpuli62W8g+FCAdyQ3DMK9uOCQllIGQ3OTvekAp8pEj+ghNW0VZfxCIF4xtcPMn+wbpq4X/1MIVZHVM/0oGW+h0VNnF0lPtSkV762re+sdIzCO+2TVdGO+lpR6D9s+tf3xy2G0MB0ja9Li3Zw08oJqX0ixFlK4AYEkINk1RBlMSZNqb/RrkkqyOt24M6IJpgiibcBb//n+PlRTs9QTl7qV33UggjHr1n/S1w6ZW1nFxPcDpofkakDFZ5zIJ2XFCduBnjWX9TIeCtiWmCyHBaZnpDCLwMmqYXc33hyHV/fmnmlUD2Fpd/MFgmpZt4KBEns
 X0DOIpPi
 /69uTwwDaZ/iNoFCEvylOCUJ/vVqchtkSBtr3uCmPhUg7de/BbeIJrdA5+Zv+MttPCSOazuLuk3RDA2PeDVka3UMdrkKCv4k7YjMYkIUJXdrkGHPPcRGunPQKrHYSl+yg+evaUFBeA5adYVQaiwB4ZO+So4EuAZAM3MzAKBdVWRzIDBgZkHAkEyINcE2EqIqw6jD6KEfngu30k8VkiQH/7+5/kEScGsnmBL3LBEU0dgdcZMqBORQMjvdfXjWJOK6bR/j3MuX3wgQe+pWz0MgfvZZTc5OrxZQolKwxU7ajAxZIgZBarvNjf/vJyJS0boChy1lznt7pXdwMUPRWaz870ChxlxRlhe0Twm/1Hkj3+qVbP+yKxyneQyPxDf0J+yEe0ojfV+9GCKxGlGMuM4JGlQORLRp5LHE6UOLo4kCi5Yv9lGkHnLWCZWiLUDITf46t3FpPVyExG7q/qO5iyZy1SLAV/mZEuNjtUcFPscbb0MHKk/5WtkjhsBv7gxO5UMbhDH7XYbHyn/hjMHK9ZV0FXV5tdoNlXmJQ/eYMUuj2o2ITDOEFG0NqYGf4zIU4fVbTalybkzV5/8vnTcwluTsneYsKIN+uCzEqiCSCS7Ttcmc/a7rfE/wp2GaAksoC8lSa+0T5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 11:09, Jinjiang Tu wrote:
> Changelog since v1:
>   * update the subject pacth #1
>   * add patch #2 and #3 to hold PTL for some other .hugetlb_entry callbacks
> 
> Patch #1 fixes a race between smaps_hugetlb_range() and migration by holding
> PTL in smaps_hugetlb_range().
> 
> To avoid operating on stale pages, add PTL for several .hugetlb_entry
> callbacks too. We don't hold PTL in __s390_enable_skey_hugetlb() and
> prot_none_hugetlb_entry(), since the mmap write lock is held.

There could be rmap walkers only holding the rmap lock (but I recall 
that s390x does not support migration of hugetlb folios, not sure).

In any, case, ok to leave that alone for now.

We don't
> hold PTL in hwpoison_hugetlb_range() too, since it only reads the pte and
> doesn't operate the page.

Not sure ... we should just handle it like the PTE/PMD case and not play 
any tricks.


-- 
Cheers,

David / dhildenb


