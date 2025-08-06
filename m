Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B0DC87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE826B0089; Wed,  6 Aug 2025 08:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6886B0092; Wed,  6 Aug 2025 08:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5926B0093; Wed,  6 Aug 2025 08:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F01D76B0089
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:21:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C0101DCBC4
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:21:59 +0000 (UTC)
X-FDA: 83746244358.11.3634268
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 841E61C0008
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:21:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BnkowobA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754482916; a=rsa-sha256;
	cv=none;
	b=kTeD+h4VS+wGVd6lxVZCxjmVQWYqpQa1bqd1gZwqTm9a+K3/vBrlJ+h1XrDN3tAc7eurvQ
	e/ZrDiZcJaYFBF6+IUMBDDCEi+e+Ahsg9V4Mz39DdCK04J8AA62jIYQHugeDXYJGh7QWpR
	PckRFO9T6S2UCiqxty6znbgGiTzHr0E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BnkowobA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754482916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F2wXVi4QzTDBtU3Us3UTeh8WA+WDu9bJjruMqCrZlzY=;
	b=svM7hRv65/CdnVOKLiCKv56zUeL5sHHVL8pQjx1ADhlhgd8FVZIIKTSvQLhWohoKC+6qhj
	UqoVDPhnsfIpH6qKxhgW8S32XfjwS7TDWjjMkLYMPjp732ZIqr4Vk5LguYTbuuHN9kAkWS
	vE+2Yv5qkKhvIg2y73euZhBvIusuoGY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754482915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F2wXVi4QzTDBtU3Us3UTeh8WA+WDu9bJjruMqCrZlzY=;
	b=BnkowobAxRrk8f2UejZtvBkgnfulBf31jQ5rVQ/7KUYrwEjUt4/2/uF8hg59TWjT+ctl+8
	ZRpObCJdeESsTwJQGTAVJBQJW1Xw+Qi7X4ry2V9CL+pv0vbfgCIxEbVbXx4BYxd+1z4YTI
	z4U1uw2SbhOn6FPIgGCte6g5YcyhmH4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-c87lcqmaOj28cjqODNnQnQ-1; Wed, 06 Aug 2025 08:21:54 -0400
X-MC-Unique: c87lcqmaOj28cjqODNnQnQ-1
X-Mimecast-MFC-AGG-ID: c87lcqmaOj28cjqODNnQnQ_1754482913
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b7882c0992so2395978f8f.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 05:21:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754482913; x=1755087713;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F2wXVi4QzTDBtU3Us3UTeh8WA+WDu9bJjruMqCrZlzY=;
        b=UFKqKxsd8FZFB1GdKIjyc9+bsICUXmhypUUPBRyBn4BRc+j1evPd+ujAXZzLBHF2vt
         77LSoyzPvWMsfhc1b0Dby5PEYD4AkeEhmrmzaT/xykFuY94jMoqRkNGZDTKf+rrWbVm6
         b1tpSccu4n03CNlB+te2THppHBc2KxXQ+RL4Y1bTMm8d0kkJyRQVdkpP3sOFser+gpBE
         7hW/N/irSSEfZyOy3AIiJ8fu0ynr260wtcNCESWUw5tG4E+MkVrWZmzZU/UbnZIs7Jzr
         Sg2ez7Ql2c332aUhLAj+VN3vplNlQ28vWN1lL8x78WxDfCCuRAUBDeX8AKvJNbQsceJK
         r5Dg==
X-Forwarded-Encrypted: i=1; AJvYcCX1X23RCF54++7wc3ugUAVuKsq4oC9gAf+lrj+sNu8CrrE2THnCVRKKDSpN7B/GiRvqXFVSQLai0g==@kvack.org
X-Gm-Message-State: AOJu0Yx9laLv3pkTTPN0mEsmy1nl+EMbYExnTa+mSjGQWkHpb/DKVAWX
	9jT3vX+hUwSemMzlSFUxtROaih0+dV5MdCRKK3PbJhcXlLuVeeTkE5Jf246Qqq+kLK+EWuddNF6
	LcId4O9W4Siogfs5jbgHXQwTO2kVqJOgATefTAwrVTtWtAkdeqX2m
X-Gm-Gg: ASbGnctazr7/k9bcOgwn/KtbBUxmRFTxYo1rI/IcnlkTIW0obCiE780FJIaHyFAxlLC
	uiw2RkbMkonYg2gg//xXTIXZW+q2rFXk64ESS0QP1ULfThq5toDQ2BGDhY2g54+IORNAYyQRRfb
	L+482qyvYWRXZdyKAvhR1+y4tdPYQ8ldQrUGZlniCqK1VLQpHcl1b2MRw2FvrOm2KLiWeJf95kA
	7B3BUZMSH+XtNVeAECQ6KUh0+Rv88RR9dux8ZUS3WfrMNI21lTSiEeAmhn8inqgkWZ9Tt562K/V
	iksbLu/QJ9As5e66iBOr/Vp2RF/kGJAplOZftIk0tU6i22WAsNU0F+9f+ufFAOKgj0iPvUZiNDX
	ElQudo92G53qfkcLfVkQ7ZjwADtE5rXh2OR49qiCVoYhtrKOsDwQwO9Ucde+KOesL1lg=
X-Received: by 2002:a05:6000:24ca:b0:3b7:97c8:da97 with SMTP id ffacd0b85a97d-3b8f4924341mr1780867f8f.43.1754482913453;
        Wed, 06 Aug 2025 05:21:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrhEEan++iSXOab9zkoq+gifw7e0bR0MIb7hns3/KNkBAB0GTU5Q8yfIUjPoioTc7fxEAojA==
X-Received: by 2002:a05:6000:24ca:b0:3b7:97c8:da97 with SMTP id ffacd0b85a97d-3b8f4924341mr1780843f8f.43.1754482912987;
        Wed, 06 Aug 2025 05:21:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3c4beasm22333215f8f.30.2025.08.06.05.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 05:21:52 -0700 (PDT)
Message-ID: <3d2c04e0-b164-41fb-922b-ad7c09075a62@redhat.com>
Date: Wed, 6 Aug 2025 14:21:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in follow_page_pte
To: Dev Jain <dev.jain@arm.com>,
 syzbot+57bcc752f0df8bb1365c@syzkaller.appspotmail.com
Cc: akpm@linux-foundation.org, jgg@ziepe.ca, jhubbard@nvidia.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com,
 syzkaller-bugs@googlegroups.com
References: <68930511.050a0220.7f033.003a.GAE@google.com>
 <20250806111922.669-1-dev.jain@arm.com>
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
In-Reply-To: <20250806111922.669-1-dev.jain@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xe_Pemc9FteUvO-VTvgROslS_-bJktLxTQbIwQXu02I_1754482913
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 841E61C0008
X-Stat-Signature: s1xrujewj166k1y4u9mfwe5ctfm7ow1i
X-HE-Tag: 1754482916-265137
X-HE-Meta: U2FsdGVkX1+StFPFLv8RuoAiCRj6X6BF+9agQ3bOnmlaM7gEORVDQQihwiC3N09P9IGda8fxLpbLrUe/O55+Ur9xYsvXa5UJKtZ6ejE5WG8clxq+pv1ilVwbi0Fvi+oACZji6GeanNy+zxsSIr5B0t+8Krrfvw+pqvp5RV6Yxi5XsoQpAmQqAI/L+HX0u2x8mpF4F7o+OwH4qcb42lBMNy3VoEvW7idUl5vu/AbFrz5pSA4q5SWHXK53q3rI7K6XG2v5TLdjgC10SHgb8tKNCOkLw9WMQQj0wyvRgR+I5ZQyAwjeY7yiGziWhg1G6Keu1814LRpzo3q91E+1K7qCL1o7B7yFmCroJgGX3O6P/oadKlJHxzLDajdI0EWzgViTfK6ZZh0ye2iuGJjJoo/XvBxvka8ePwJIombWilbZE0AOALMLYe0Kyo6FxGulGq9lFr6yFESBBBVUNGAGIVTQN3/aXvQKuCXF309PgH5ipNuoeaXjXH2vIf864sHsY+KtqJvg7N51devhmMr2UHkAcwfclpDYmBjxi45ZkKQ5H5ZopT3xGuVD0ElcLaA4ygEWCwCLdvIC2RuQfbPqOToDxLuONgnLDSpOlS1tFvlPUTCDCVnkj6htvQuWJFGWVhv+V+Q/qp+JLUk1H0NWPNp5GzURsDZ2kvUW4gjLtCz4Xz0N1/QV/ACuCyUYvx0zUAbIKKMkq3evLuQH5U2kDKzXsEv4hb8Xb4ju1qqzEbcHzb1vG241OY1i1jJeUc5KP3JcEkIuu7slbzaGKOdaq7mauxqQvl5GGlDDwGyS9Qfei+xV82Z3zm07qgQ83xpNCrgEU7HzPf7wvsOVzsbLEzMinZwGbCBoFWqE4btNM4XNQeFbysMKvb2Mvv88+L2Vui+u4fAckMbIToF1+f3VcN9JuOju5e2G/A/dtJcjBq6zVpUt6AHQwYEWFOH4j1k5QfF9//kML9fhJ8BzKjUt2q4
 +1ubKrX1
 iJH5p/GHFo9INyJ3RoTJJJZUHgdsxJChMje/PbaP4TpvId9jV6Lth9yLkscp6qu8C6uwVk4fvCGPLUM6xLFC2Qa048JUx5Khcxq4cGAR6qYttBghTq2d6v7Qd3+uhzRdfPyHC6NaWSQstgCFZadypDedRzYxOFyX8v9vn88EoKVMzmmOFUd9MYnorNg98OEJakFNOlYjBnIQVEWhWLg7ReM3aPnZeJipB84ZwMhDOWSGUmf9fTs6FKdU/VMBdZh90BDrtQtFY8IIvCnZO0SZ9wGhoxT1LAcAZCG9hHB/k08y8AFrNjTdzBlUn2s+3s0fFz4Fyg6ZKyKAxkklmNCQGBN8GAtl+4roD2HGmTheYbt0LnBTuYy1vF2/sxjU6TXaOqE2gDnOefDPwURCF4pu2CMgXMUWx1ZupMLq29Ogpm149CFg0COENl5+iFa9ZiU3wOcbScogjFwm77pPoCrBk0HKpsUcvY7kLVrw3lUZQg4drbw1nFNpyH5r8SbcaebH39Flxghi1qfqpN+3wYCxbr+mZAmh6MoAJA8pNCP7Nq2DRZw0gVH6XkkIKxjCHVqLa3IPY1zKPEufZcarMyiDoqZOMqwjwrT4wVBUPi4+dv0HokEpFxb2nDaj3cyQ0zAegOg0GpZhjsy0ETNNLE/XANWBh1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>   static void commit_anon_folio_batch(struct vm_area_struct *vma,
> -		struct folio *folio, unsigned long addr, pte_t *ptep,
> +		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
>   		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>   {
> -	struct page *first_page = folio_page(folio, 0);
>   	bool expected_anon_exclusive;
>   	int sub_batch_idx = 0;
>   	int len;
>   
>   	while (nr_ptes) {
> -		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
> +		expected_anon_exclusive = PageAnonExclusive(nth_page(first_page, sub_batch_idx));

We shouldn't need nth_page here, for the same reason we don't use it in 
rmap code: we're operating within a single page table and hugetlb does 
not apply.

-- 
Cheers,

David / dhildenb


