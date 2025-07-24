Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AABFC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 21:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E956B0333; Thu, 24 Jul 2025 17:41:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFFDC6B0334; Thu, 24 Jul 2025 17:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15206B0335; Thu, 24 Jul 2025 17:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0C686B0333
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:41:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79ECDC0545
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:41:12 +0000 (UTC)
X-FDA: 83700479184.14.0668283
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 04EE120014
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 21:41:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B9oPVGd5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753393270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oDW3PKI0DWOwdUilD3F+jYY1Y79YAsFgQ9CJbwuCt0=;
	b=E6XXftJc7t1FoGjiRdxebzrRoTZ/LXyC5kIn2eJHUC79lgdjHndZfOiRtJCipyjr03DbDO
	ml2oMhZeVtZFYvQkFJHNNAPunAKeXXqHy+rio1rxDTN0W3zPzEdmXNfvPRW1vPFc4y4Sr/
	1oSP1fghnaUAjRqRIDVBpDa2KifrKCk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753393270; a=rsa-sha256;
	cv=none;
	b=fojsxwKoMZ/dJVJbBDTInlYwyxrbM/sPQAq/jd6gHnD+lSOksMbYoP5B9eL2m3xHRHj3Ge
	UT73yV1w1ymIhZXE4j9kRQfSYRK+n+yLDRvhW30nGoWZldYK9Dvsqs8qhjrBH/NuzVZUMD
	E89VwnAYbS65hU/VAXGJdOPtUeB4H20=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B9oPVGd5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753393269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2oDW3PKI0DWOwdUilD3F+jYY1Y79YAsFgQ9CJbwuCt0=;
	b=B9oPVGd5TN9/8hJrw3yM9q/5qP6jZ02F/ycclJ0R8vA7yEgW0qTrNs+ZEMtTcLNIHeA3DH
	WRf7BvGXUqdqmAlZbfYbktodRjAT31vDNywA7e/3lNXgdJweFtW+5DAXp3u2UrLEXt4HhQ
	8Gtx1wWN/bVGW3bikjm+LbjsSIvs8Tw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-tyJNk1ZrO2SYra7RPSpgxg-1; Thu, 24 Jul 2025 17:41:07 -0400
X-MC-Unique: tyJNk1ZrO2SYra7RPSpgxg-1
X-Mimecast-MFC-AGG-ID: tyJNk1ZrO2SYra7RPSpgxg_1753393267
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4561611dc2aso11809655e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753393266; x=1753998066;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2oDW3PKI0DWOwdUilD3F+jYY1Y79YAsFgQ9CJbwuCt0=;
        b=CQSfaYrYgwkKIPlwAXsL5VuFBE8oe+wAHuKMzVRz/lhZUtqS/VcmJ0bHNF8tY+jyH2
         FrmhFeVH+/h4noRkA85dZ0J+ap9mjV8nlrrz7hxBM+Wsgpp9vCJOcCQQ2vHCehAWHLBv
         vwoVP5sEn14xHP3DWCi66box3sACBBMbUjXwt7lorX+a106D/02b7wuRP+4eOugty0Gn
         lJVu0RphdR5aO6v9Q956/YzBVhxVH2e1U7QP1pHR9Pm6FVprZYr7qy/B4Th8L04JLScL
         eaeubpo6AoeR2VF2vZqdhHGn5M4U2i1F0Vx1E6DnN8LKw1m//6NGPZ+1z3tzrrpPECv9
         D/9A==
X-Forwarded-Encrypted: i=1; AJvYcCVfFd2tZ2XYTtKBtT8yBMKTnu0pk8+Cs1+reLFgkweB7DCLuFVoUgzTu7tbcW9m5Lmr3eJeh0UOJg==@kvack.org
X-Gm-Message-State: AOJu0Yz/jjfrLEzfzU8KHYRwYW7XpbU81BwfzyzcWB9voPxzuhVD1Ys4
	ObQfLnyJ0zJ8nx41wvsizjEIOmIloEHhvDNYSeZoHIOUCF+tm8tfkavfpYskgRowwJjfyPHlwE/
	GEUoNgRNaEaLYsX9j3gOci760v8bfy0TawS2ToXS3Cb/J7hIzugok
X-Gm-Gg: ASbGncvIUuJ4Q7ZTDsFkq+ZBWox/jO7zmmPss2sg6K7+6UXHzxHFjbRtprMlTgLxpaE
	U5M5hSPHtom32/Jf1/+7ZsJQVCj3xdOw7pb2uD9tbs4todeM2BCCMgCJBbcTcT9Td+jV+i8vfFM
	9VKjPV6Z38QGZrS29KkvKI77lg5khoN/dWTa1Ovq5fl81fIyd+6cEJE6JyvAQa8gCiAEyKIJRu3
	ewDFFXsghBv+PKrP5Hg/XRg609kaOeVy60cVOxOOQ38bpiBa1y9/AK0c+ZPQPwZa1m3/R0hQASD
	IKFGmL477SV1W4VKRDZisLyIAsrcoByF5TESGdyT8Cb1c5kF5wNVgD5ucmIPj2T88HtYtN0=
X-Received: by 2002:a05:600c:8717:b0:456:1923:7549 with SMTP id 5b1f17b1804b1-458731e04c8mr4140325e9.26.1753393266589;
        Thu, 24 Jul 2025 14:41:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGjZdRc+W59cRKHplILqNhUcU+p7LiEOAnfsLFXmp1s1nZ/3ZC1XfGFJSMJPRAkSFZe5T/2xA==
X-Received: by 2002:a05:600c:8717:b0:456:1923:7549 with SMTP id 5b1f17b1804b1-458731e04c8mr4140175e9.26.1753393266134;
        Thu, 24 Jul 2025 14:41:06 -0700 (PDT)
Received: from [192.168.3.141] (p57a1acc3.dip0.t-ipconnect.de. [87.161.172.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45870554457sm34257195e9.18.2025.07.24.14.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 14:41:05 -0700 (PDT)
Message-ID: <ef111032-e108-4771-9202-b8cdab278422@redhat.com>
Date: Thu, 24 Jul 2025 23:41:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
From: David Hildenbrand <david@redhat.com>
To: Kees Cook <kees@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <202507241352.22634450C9@keescook>
 <e0a22433-541c-40b0-92bb-34b0596db642@redhat.com>
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
In-Reply-To: <e0a22433-541c-40b0-92bb-34b0596db642@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dfWqE-fRDp7dFb7gc48I2fd7Lf-A8FgpXZUFpsnG5AI_1753393267
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: db8855sknbs56fg4fw4jafbysjuqm4tz
X-Rspamd-Queue-Id: 04EE120014
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753393269-934704
X-HE-Meta: U2FsdGVkX1/0003AuFioxytMmbGNoFEuQWr8QRAbm5g7EvhWXf3p1J8IwxnF7NW7irQf+YSsgU23e9QE0fy+qQntFunBhB2PLXERdXXewsqte4jWpQjyLoQcD4jqX7mRva4O+5QPjbWqClFd3KaIs6wZWfvCxoVyDbSRWGwK2X5wQ3645dsykw9YeDokH7l2jaMu0iBosUxzurvH3qqOMV9aEhfd5yVhFnEAJJgpY/P+M+Zirjk1yablP21XKlPZvWo2Um60jw7TbInAfrJNMVWWdrP0GXSUt0aGpcrJ4iFX1b2ah6I1HKZxqjk8zysTdgwA3a8/lwXE1H7lfZQLQioyotBYeVq/sgIHrF5cptuEuEaCLmlfu1TcdALyWpVkfpoh89cUhX8CbgYEw79FHoCrq60lTAOc+RQKoglV/7EUUt7XVKxAtWwGL5sdGHZCslH9qpN35QrHYe55Iyr9US2bOYPgmwWhyjlFwQMyf58XU7WVJ3Rrzd6pKalOmbJZ3w6DZjDkBjH11eM19gyXMcQCUAVkTBJUtWSbx5TooYVLjqH6sXL9kEuzSHa1QsaiymdrWisFwO63s1riPb8iR8iM9jaCLVnRSG5A9KtnO8zwAF9j2qTYk3JOtCaHkZRc98fsmfe4IPiOgM5HKsTNfHkAirHpQHC3kJdGHWlq9YOoGwQxX4QvyT+Qd8xlutKNnWY2kXlOBiFpuBp8Kv/tq3gurQqUzUltWkF4eBfvlQACk1yNhSymyOBEsg4ZjxQMu5KQaFxnl28s7Gd5HTF+U6xTpnYo1O8qEDtk9SpbI9K4ZPUGaTMDO1ZTgDmuXkE0Hzhl9fwir1vzOtg8BUAtVSsPyJRD2jIwixsrua4R7F7Lx5HmWNt656p5dXqgYLVSyvG6IOOUs0bmT6avlPWA23p/+7WJHMvXwmLTui9drygZ7av4xU1sLsjbCbtwMjW+hm8syc8GhOWXgidQQ23
 mBcfZ3pQ
 99e0egS2eA7UxYPRjBI+wT9JNsehJ9zZcpxYzfV8sRUCepAAZRuNW7EN3lfRR8Ff0WTlPRazMKV0ZSj9x9iu0QaFdPwEAyvhJOPlySNjkKWD4WKyUu0DhqibmSlLD9r2aaCmrOPgHG9STJEnnLJnstQSka5NCVi21y3ikDgkNFuMd5o7mJilCEA/8QKHA4bvmy8z+BUfkOjTLed6j5sCY+FRliPy7lcdOUwkOVIF8AAR9C3RggUIZkrAcfQ6ieikLtgFalI0+avsGGOyqzq7g23eKxJOkPOgME5T9Ztj7uNeUdAdqBp0vKCnqAJ4OTwhRM3mUZo/rT42XeZCe6u+4nqA8PCbIxLtNIyOVEfzub4aoTevXX53dr4Tu9i73O+XRAcVMn7iRv2SBv4MQhCRJBY7fJvr9Y7MkwxfL0IT1Nnf1V+k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 23:32, David Hildenbrand wrote:
>> As an aside, why should discard work in this case even without step 4?
>> Wouldn't setting "read-only" imply you don't want the memory to change
>> out from under you? I guess I'm not clear on the semantics: how do memory
>> protection bits map to madvise actions like this?
> 
> They generally don't affect MADV_DONTNEED behavior. The only documented
> (man page) reason for EPERM in the man page is related to MADV_HWPOISON.
> 

(Exception: MADV_POPULATE_READ/MADV_POPULATE_WRITE requires 
corresponding permissions)

-- 
Cheers,

David / dhildenb


