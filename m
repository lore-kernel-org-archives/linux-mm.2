Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F572CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 17:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E25C8E008E; Mon, 11 Aug 2025 13:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192FA8E0045; Mon, 11 Aug 2025 13:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 081F68E008E; Mon, 11 Aug 2025 13:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E45EB8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:54:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1E6DB7A4B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:54:38 +0000 (UTC)
X-FDA: 83765226636.23.607ED06
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3966340007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:54:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=atOtRgW4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754934876; a=rsa-sha256;
	cv=none;
	b=V8HpvHBOglSVdRy6zodQsLrJHiwmyTSyfD71SVwqQcHQxw9WVYw6sNpk79Q+0Rw20SOeq5
	vl17MTrerxwYr+Q1cp8CvlRtDH1hfmibPk19kJ4oBtk3xo7KROaFawY68eYh4MkuO5G1jh
	dtN3Qfl0Gb1npTh3gC5ZXg2hQ7Vkmys=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=atOtRgW4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754934876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9om+qqO8G94oegS4pPBf2LrGuOs9ErV038pUk+vcwMA=;
	b=nsoxCTc5nrNhXm0WsZhT4fHkX8vEy2JIiug/BdP8G2YHRI2rvmnN24dzoQM/X0RFlOocE0
	S2V5LnO+LhA9nfxtv9S7kH1KGiS4XEns6QFmtXnDcamc6RFPGfqYOzURnS7koXIG2qMTQJ
	hHEXTovxi9jt2hTkDdaRFFFWKTuqjo4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754934875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=9om+qqO8G94oegS4pPBf2LrGuOs9ErV038pUk+vcwMA=;
	b=atOtRgW4OqjdbamWyBy46J4A2yZ87DZza2MRNmcvh79T/M0dkmr58fQso5sudlNJmSqT5s
	pfjhvsfGHyWgZDajK+iEOiDxa7WzKeYrWxb4lUdyzo7m3l1Wcl2C0/dkkKCRGy2VMmLMAI
	dRLcYaWnO2EDodfqMq/j/Nodqh3VF7o=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-YldkFD1QPHGbh27WX8sXiw-1; Mon, 11 Aug 2025 13:54:33 -0400
X-MC-Unique: YldkFD1QPHGbh27WX8sXiw-1
X-Mimecast-MFC-AGG-ID: YldkFD1QPHGbh27WX8sXiw_1754934872
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459e30e4477so40815205e9.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:54:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754934872; x=1755539672;
        h=content-transfer-encoding:organization:autocrypt:subject:cc:to
         :content-language:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9om+qqO8G94oegS4pPBf2LrGuOs9ErV038pUk+vcwMA=;
        b=geAtmeU8lr6Zx9A0sPaOQk4sgPmuEPGU2cW+cMdmO6b7Uti9tnpEv2QRhcUZd5Zxc5
         Y5AP92ikoAANmMdK4XCjj/I4OERyiNW+JQIiwaMuDMBEIxKsIxP560hamVlYFRFcTTF+
         t+4XoSY8pdLx240uCTkDsiB7rUE27GFQmLDzHrDyLIcRAv4nLsU/Ni8fqDt2NFaqP3l0
         xErj+CGbUgSBesgbsm6c0l8SGUChIUm4ltIWQHfYGyArompSP9Mp7H9bAFKdMJBbObiB
         9hk6QF4dIzZQnbkqM9QePvSggKmO/8o4e8PpRKV29WMubAXRwyVV0mgVuCalyD5rJwLJ
         hyJw==
X-Gm-Message-State: AOJu0YyoJPeAo74dFl84dH2BJd1y8SBGYaH/wWoFVzrHtEZv9KL2v0v4
	7q7dWus+i+aVC29bSBgJW89yHq5UXgfzSsC8m6bgbPobR4W/bafEyIM9JlokuaOK9EAU/KQ6OKt
	BZWv+T58oAj2sEW/k6b3rtWbKsgORZ6jArK7HuPAR9P+hRRetes1zN8gS9SssERP8XmiYVP27BO
	XR82CdjmW4WX+ehFenov8Il9nXUkLBnsHcQ88=
X-Gm-Gg: ASbGnctFVrmXgIeO+tVxE20QtyhO1G5rFQwW/db00/EhW7Jl7wFPKjDSDejp2aDDxrc
	SAzoH0kEEXBhx6bZclcr3pxRqQte8wnZ9Jy31Fh2Y0iGtTsdZEe5sTdd6lIY/CHJrZQRsJiHs7L
	Zthu2MuEyfL12LGpnk1a2OpPbKSYUtXB7lla9s5flSjH+LlWDJyEBwiOxxIF8ylYFlHyti0S/s6
	48pKfHMgX66QP6+l49ARUbw/b/N5nmgJXaCtvEmGvoObt7RDZPQi+Tqo1wyAwtM7YlSkGBwSZZ3
	2TzaYBn41iwbCmm9hVI8TWxXZDtA/MR4Mh4TIufZj+GL/PMuH1re+Kbf9Yi1M/pCmwoJCi7FAd9
	r/UYvIhTCLTHf9kjyjrzfx812hrQS36B1K9+ZgiFEyVNV/Za/lIw2dkakV5XpnVWXoog=
X-Received: by 2002:a05:6000:40de:b0:3b7:9350:44d4 with SMTP id ffacd0b85a97d-3b900b49960mr11535140f8f.11.1754934872405;
        Mon, 11 Aug 2025 10:54:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUrZqJM8lPLbvZNhW2crgDKNR3EikOOGR0IxCBJv8fwqNeUnk26Qg7O6HdkMRGrEmcbXp7dg==
X-Received: by 2002:a05:6000:40de:b0:3b7:9350:44d4 with SMTP id ffacd0b85a97d-3b900b49960mr11535120f8f.11.1754934871895;
        Mon, 11 Aug 2025 10:54:31 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3c4d02sm40242259f8f.33.2025.08.11.10.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 10:54:31 -0700 (PDT)
Message-ID: <284f04e0-6555-4469-93b4-fdfc0dc7b91b@redhat.com>
Date: Mon, 11 Aug 2025 19:54:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <david@redhat.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE/CFP] LPC 2025 Kernel Memory Management Microconference
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
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xnWgoL_AFitTznOwDS5DRuIqI8zxFlFZA9o-acVQ9VM_1754934872
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3966340007
X-Stat-Signature: npopxxb9q5bgiyjr1aeidnjhmx9saqp7
X-Rspam-User: 
X-HE-Tag: 1754934876-703101
X-HE-Meta: U2FsdGVkX19/bmqkHqjfOlOu5b8rZtTuObMnaWXeEwdONDEPUwGuDYZRYJx6xabCK1QQfKYcFmF9cEgcFXqW2sFYDA4Xkt6JXDhmIrXd3FQS51OFzV49Fzo/QLgRxmcqO1rOq7VDQ4xOC8jrcX0FtdzOFdMbPgItXJ8UIl5nqSQnhv4U46BA3a7eB24OsB/9xvvGJCQMxxCqHyVbPzOtW3D7QzudKZP8QX2qBY60OB5RrcCxlgKAZ5POCqeAf4V2xKppVn8Y6YFWjxm+97OLyZE87sxhOerU0ViveuCDP0hL1/UhxAqwwsD1Zud9/kB4RDJZIWjEDJRkO+iIZ9eOVZWWmL1k/6s5y2mIWBJCOKP2RBocbgXtIL8OUsg+oU8Dse5e8vMrORyLSSFTs3x0bP2qTciDg7jPxUrLnTJ98RRJxZAo09QuDvGyKwzFYClFRLfRFeQoKqoc8Jp4xDtFmjQ66OsKJMbrqD/I6T0qLfVKYDRhZygXPH9z6q1XhRYfuj9mYKTiSeP7JTiN4uwEZT4PYkQWuxGKQB6II3q2M+9NEHP7JGOVcezW5Xi4asN8x/CcKc5xrIQur+F+VKBEFulQxMEJdB+DUZb5du9ZUYzYNOTnaQJjlC1AeFwDT9ven1WsBk/RtrnGm/k46hHdOM/qGfeLyacrjq4VYMSi7h+W4SjSL2IEqKHFHuws1mynfXpvzvIRcN52woXdkF0QlMeZR3FHgvjR6uJheuJypXd7ZQsZRlR7WLkQLV6UXFBardFSNC2ZDtHJucLGhN2cZgUbA/MUtp34NsamqCF4sGQT5srZEkL5bVh/FVu+yAKAFBN8CXV0MnvtoQfnvHKU4NFjD1Uq/0/RSGMaE+Jd6xyFIei7Via+mmxU4D4Q5v91VWhHt2TETHtajSll5PE0HNQn3rWbI9w5/jdwOO2G7L1XpH0ZDQkLwQoIg9FCUM8dbxX/H1WjfvOBExQuedv
 uhVisYdQ
 AAh++c9vtd+Nq6aUwYSwSUEErG+XSE7cOZwUcZTqEptkrAOy+CDkt57U2n7jPvHeFej/9gz947BLeaUPJ35jI0oOsrtXggT/KjmzhErKXAa/u7M8Rn7oMNyb3iMkDXKIcOocaSMHmdQsJKKgNShCU3xptTIYMgaWqFoN8OP5fN+PiVBqR5AgEbYtsGUCGMhQspe8+/lLQbLxrX8VjrpGMYZqZLHiP2mmojk5Tk3mYQfdqFKFEbPwSoYnFfPgml0TQe1j31AU/bcBt5eiMnZ/nVsamSgFChx3Y0ruVgUzpAwTkgrwuZYuoc7itU3h3PYrdjDEYMfE+bXxOJm/vn+ZYPa29YPMbvT9BcbOK6wsDlNA+IeuR3T1A1E9iMnPQKCWfbnfnEPWJEdNAnv/On4kcRNuWKWZQ6xzIyPT9wjhzM3bmQ7MwPOQa4IGcLNG8fZk+LCwSGyGW9owGWjCKOdtfsGDJ8tTQhB7UDgNZvHMSkjwSKmttlRdfp3LK7PKx2hMBiiW9x60sv/mNUwR69Mj458jLR9AxbIMIe+pE00nawHUfj5TSWGhRolaP1bWfzyRHDd3UOWgpAxLfo+TyP9Bj+f5dAaUzh+PxZx+DHvAK2D/Wi8lUVivDlNPVi4DKNcrJ3Kvv03ka3IwSKVH3haH66TmLLfrpTiLUJm2Nc7L2TxDwMqo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

we will have another instance of the

	Kernel Memory Management Microconference [1]

co-lead by Matthew Wilcox and myself at the Linux Plumbers Conference
(LPC), December 11-13, Tokyo, Japan [2].

Due to our past experience with remote presentations, we will only
accept in-person talks this year, unfortunately.

Topics we are looking for are pretty much anything that would be of
interest to the Kernel Memory Management community.

In particular, we are are also interested in topic suggestions from
outside the core-kernel community (user space, drivers, architectures,
...) that would affect memory management in the kernel.


Example topics that might be worth discussing this year include:

* Making Transparent Huge Pages more ... transparent (toggles, policies,
   khugepaged, ...)
* Making (m)THP/large folios a first-class citizen in MM
* What other improvements might we see from mTHP?
* Where to use eBPF in MM, and where not
* Ongoing challenges with memdescs (e.g., allocation/freeing/walking)
* How might we make allocations guaranteed to not fail?
* Which CXL use cases do we want to support, and how far should we go?
* Challenges with hypervisor live-update, and the integration into other
   subsystems (MM, drivers, etc)
* guest_memfd and the interaction with other MM subsystems (hugetlb,
   GUP, ...)
* Making hugetlb less weird


Please submit your proposals at:

	https://lpc.events/event/19/abstracts/

and select "Kernel Memory Management MC" as the track.

Please submit your proposals by September 30th to allow us for
planning the schedule on time.

Note that a microconference talk should provide sufficient context to
have an open discussion about the topic presented. When planning for
your talk, please absolutely leave sufficient time for such discussions.


We are looking forward to your proposals and seeing you in Tokyo!


[1] https://lpc.events/event/19/contributions/1995/
[2] https://lpc.events/


-- 
Cheers,

David / dhildenb


