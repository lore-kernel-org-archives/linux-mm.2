Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE51CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:01:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D70396B00EC; Mon, 11 Aug 2025 04:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47EA6B00ED; Mon, 11 Aug 2025 04:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D776B00EE; Mon, 11 Aug 2025 04:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B352D6B00EC
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:01:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D50C82B59
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:01:05 +0000 (UTC)
X-FDA: 83763730890.19.F5F42DE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 96593180006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:01:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qk+THswK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754899262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4E6fqFxwxnXPSUUu6SboQfpiNZsJ6risTizRFtUoN3w=;
	b=Su6kBJ4YtXCGSwD8Hv2ySgylduhgwihLIjiHtBeWfXPrbcwCe7aWGRAOtBicuTQSdReyOn
	zsDi4S8zjr3008I0dXu2ETTe4zV3aOdqkzRU7FbIFv9rpHy3vZ+KOBJvl9Prz+ylYM5vQi
	r6M2W9yOIiMYPw4Sq/esB50uRckpGfs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754899262; a=rsa-sha256;
	cv=none;
	b=7jloiUOuGkwQApyLVYNx27t9z7IDzLvCmcDifwFkNPKRjlSDLv97wpBfe2T6kbizb/znhl
	K/C/ji/i5B6QFY8vDQZLuVjFUFKandw3CXTVxnFjxqTH3HpNNY0uK+Q9IpnWC4Um/9rwY0
	WMDZBgopAc7UQ/cB8cb7DzXjc701xoM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qk+THswK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754899262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4E6fqFxwxnXPSUUu6SboQfpiNZsJ6risTizRFtUoN3w=;
	b=Qk+THswKpilLrW9nniE4lkCSTGGk70J8Yi9AU2sJejm6VTntOFoww7vt0JYR+nYL1znpvy
	miZI5J36Xjg51gLrn0l7dDFFl8IL5/dAw6HZgxO6zx+lOv5e9kKKaqJ0H7cV5IDUODlafX
	inJz94d1PB2EQHbbAR951T+02Q9qwXU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-nYv57sqKM7CnaaIGuFjtlg-1; Mon, 11 Aug 2025 04:00:58 -0400
X-MC-Unique: nYv57sqKM7CnaaIGuFjtlg-1
X-Mimecast-MFC-AGG-ID: nYv57sqKM7CnaaIGuFjtlg_1754899257
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459edc72b65so35559375e9.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:00:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754899257; x=1755504057;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4E6fqFxwxnXPSUUu6SboQfpiNZsJ6risTizRFtUoN3w=;
        b=uQ8ZsBBH+CwF6cKOU7vu1bwvojT8uw7iSkP7p1cAVkk/3JCBd1M6VrWWTCWdWde6eI
         PkpNjr5d72EN5sR4Y5LX/VYE2ch1riNE5oKgAPd6412nKPnDQqfNJ7Oo/NcSD9ZHfHDd
         eNGAR0MjpR1wnCr9vkgc1OKYbE4bI16bJ9jXCvTw/J3XNxyEyyCjQblOOxlLbV5+BZ4q
         xErd7TIZiRbh3s6ZyQSnTudbUx/CB7JPQcIplx8C9Kz/vilUk1Q7sS0xP561/wal16kh
         Mm4Xwp44kODT8lK3I1V8EaS1amN0DP5+0JIPMZw52pyzWAbQRKtqns55dukEt0oL0ayU
         wTrw==
X-Gm-Message-State: AOJu0YwAj3B6UnarVyn8wktpKZ+sp24OGCkcfGRDnz2AGOqwLtnO751+
	EV2n1G3erhXOL0XB7fwD3YqGWEHdFwQxUFk7Gi6TXnLHJ3koI+HUSujwJjStXPwIc+/p2uQPkQM
	x8rZyHlsyZmlqTERQieIyppDak02eK+ZYf1+ajWf82d2vzAEGoLlI
X-Gm-Gg: ASbGncugeqJXJPnFMQpidF54Yco5JPUtnDwUYystSPzs1DIW65gbgGECgdJfxBOWVtX
	P7mmHeN67JNa9PpJ18itKfbxiSHO5yom7PLMMnVl/mFIn6uu3zWL6AayIdPsRCVT0POgkaiN2kb
	iSrRZKAbS3Tp1Yb4iiXrbzsWqtuds69/y6U8f/i7YU7BV0P52RuFKyWvw7e7t55rbWYdur1TRRB
	BF7rDqeJl9wGtX+XdF/R0QR1Kt0DYgRDF9IfcZHWkeMSf06PGKV5Paun+6hihJ8+emTc3CTu5Ne
	2hzlRG9+EhpbuF49SPuWIV5sx+/R3HVetY4KD/jr3ywDsk9Jo9oGmtNiEHTrAGexjGTIvco=
X-Received: by 2002:a05:600c:4ecf:b0:458:bd2a:496f with SMTP id 5b1f17b1804b1-459f4f9b16cmr79982095e9.21.1754899257196;
        Mon, 11 Aug 2025 01:00:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQj4yeDpFrPoA8t+TmdmB4Y3DMZn/XonbdeVQvwP9JCoSjHYJ/apPyH5+/zG2F16hnHaUm1g==
X-Received: by 2002:a05:600c:4ecf:b0:458:bd2a:496f with SMTP id 5b1f17b1804b1-459f4f9b16cmr79981725e9.21.1754899256766;
        Mon, 11 Aug 2025 01:00:56 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a3d6.dip0.t-ipconnect.de. [87.161.163.214])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e0cd2c90sm289685575e9.17.2025.08.11.01.00.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 01:00:56 -0700 (PDT)
Message-ID: <6eb26cac-f6a4-4739-8f45-ea26e11cdd6f@redhat.com>
Date: Mon, 11 Aug 2025 10:00:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] selftests/mm: do check_huge_anon() with a number been
 passed in
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Donet Tom <donettom@linux.ibm.com>, Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>
References: <20250809194209.30484-1-richard.weiyang@gmail.com>
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
In-Reply-To: <20250809194209.30484-1-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XZOlefk0INOFj5IbPo06vQAiIHu_-8oHMjgPfHzEdCw_1754899257
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 96593180006
X-Stat-Signature: mmdoou8s1bmsyd3efriam9uqma9i97og
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754899262-129723
X-HE-Meta: U2FsdGVkX1/DZIbpSv5kL8wWgmmZ1uoqUST+usVyyltSqA4uGvAL7xsUonJm9vJLyNGCnrCQJ0W76SHwXU03COi5+9W4yY5A6/s9sr6EmKXFaZqVXaPYomjXH+w46ZgcIgxz6aAX9gbsQFfjrKBwAkJpUXZ3avf75nmIHqi3GhnDnZbliqAfo0wsBM92Tcn0xp2CMbcgq4ntvJ779NfagLEkntJY/K4jZA8isdh7Zzk4pLXBBCZBIkl1rHTNVtI7iJ4sbeVBKBEMGtK88yWPAOAApn22U+mCuqyOGmmHmoPpo3+9lFWpekebvRUN4RVA4ZuQZb+mPZHdvyTy+K0mV7NlirTfQs8KmVZTpbWUnBhQSdycYlGTGI1QogDZSULaEYvFdl0t/ssFfXAHlqxuWrhWR3W+HI2m6PlgpTxS1h2cbo2oU5OSXdQH+4zJg1iDKINAkuLgd2pshfAsQ1a6n2P25C+XIphsL/NSfJdJQy6T3laimLmVzqEyV++dUDw1QrWzgVEa9cZYkkrEyEN/RAQ++bJoDO6AHX5j1MDX0IJo95yCE51mVPcXMSSZdWd3+Sj5g3PHbCbl+0xhaa+SK7H1CQAb9c9YNyl69syhtIxyKbXZ0wpD9WiresFZqOfFWfrBkAN7dpzZlhdJQrmsfY4Id97n+VqITJ2ZpEqJ+kYwtPQ5ghZNNaqOuMKNKA6sRj+QfOOBkJBs7FhVN7e/TwGZP41xGVRSAmvh2HK4CrFl1MQE/diMOTbMAuAHlrYzould18+2PMR/YXqX81BCJcNovpQsRC2CFhoJL1ybA6AAi1QalSMO93tHfsbDTvWwwXmQrvbBVx6ZWTZxrNq/KNuVt7m7x3WOd9OyM4ZUylbm/eaw7x109wqy/NRA8h5mOxAyvfhmAau1CNLMUQxXlE0dxNIQohVWK7jlEtPmyLqYQqt4iTfxaoapbYlsIl0Fq72yGPZy6YVeYTzCDwJ
 XzWCs0Wr
 +4zLEXOAZdvERdhY3wN26D2sb8uEENwHRWD0dBoEs4flQFMrRWOKvPM10Tz9EWCfXWt6HxNg1BU6y3gQufsBePGPqWIl8+KVwIlPzV466Mcne2Yioq69l2SbO8SWXlsRRvGgm6p65l+C0aAFPerVx3i+CWUh96mBLiwAHLrLtfqRtZnfsqSfsLz9bTuTFtUsWZ0IZmBGWUjE/565hZ1/YqZZh9WS4dRpwxnxHcKXPcDD4BClAO6Ob0wVF3NF58n8+P3ePjpA2mKwc2c0ZW2z8h3n/1tMZ+5DrdZ6EGm7pJZ6ZTYYFXpXLhV8QQEvCFv0+t4jQBaLOi/yuCllRq6rlY+okvIVfwkGVXbgtCckUxSLO+yZFiyl1cQ5axbaX/Tawa/D1iRKaXGDNGrwFsYbmhmY4bbm/NXQycpPs+pkDfSaHWk+90cd8ZYta8kYYdWw6IBtSl3ba36ClpPbD+3Uvhcjm0VhvckPhaY1ACJ+yojNmoP/JdGMWa/ZZ1k+h9vFMd91YycnPVARzivZTdCURgj724OqgoNu8TPAfcnj36RX9C+Q+/eaZzo5iVMpkPGHRymuTLO8ZswCbjuA2KFC/riSL8fMT3O1qRqd9ryCyFxYCHZl6NlOmHGKTglUV9ZqM9Ch9YtThJE0n2hIc3TTjKcQgVOQgwFvVJCYdMg5gSnneUMfRQtD6Fy3WHQ30XHnHHOeDk09jcxLF4sJXyUiNAnQRi9R7dNz+vmjZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.08.25 21:42, Wei Yang wrote:
> Currently it hard codes the number of hugepage to check for
> check_huge_anon(), but it would be more reasonable to do the check based
> on a number passed in.
> 
> Pass in the hugepage number and do the check based on it.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Donet Tom <donettom@linux.ibm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> 
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


