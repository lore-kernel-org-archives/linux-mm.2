Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405C9C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 15:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C216B009C; Fri,  8 Aug 2025 11:40:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63A26B009D; Fri,  8 Aug 2025 11:40:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C792B6B009E; Fri,  8 Aug 2025 11:40:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B888C6B009C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:40:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A0E4B852A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:40:36 +0000 (UTC)
X-FDA: 83754002472.28.D5BE956
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id A099B180004
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:40:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W6fXrM0s;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754667633; a=rsa-sha256;
	cv=none;
	b=mulBLQ3tsywSqbdzKEM9jlLBEoCNFMDVMyQ/iaK5Kjw/z1EEQ2ZD4+LN7guqycV/jWD/YH
	+LnsZKX/S9ntpPUgza35+5AR/whNl2pdfB0XOLjcfETi/ZWcKOTHiZ0md0fNxJyZxKB+dm
	AR9C9mql/9fKH449FVFnedyZASNShCo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W6fXrM0s;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754667633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nV2THAhy31Q+K4giF8sVO2GD93KEd5+dTPyv2cww754=;
	b=rzZmZaJElHPFuCaBdSsWSiJAVU5Aml5aNgQVpNgtjJZI8Zpd7CCzFIYzGFmrF2e5YFBWUK
	RLPWgGvOWivX+CTmAuy4Avs1L8GF+iOqBJrBA4QCy9S4SwtltGmfV0W3oo8EpGdFVq8XTD
	/cDvVTz93S9eZkzhtdelFTXKhIIN89M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754667633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nV2THAhy31Q+K4giF8sVO2GD93KEd5+dTPyv2cww754=;
	b=W6fXrM0sPRtiqYW055+2E9DR7nr3sKOmRPdLJCJSBsJvKl7mMvq7DCMJ2kAc4guynx5du5
	QoFwxXaOMtMPE8zuTF+8aDQKqfh548LW6j508+6e46ssQt8Z0DJaX9zTvHiUBOIt9vlPjN
	nmBnYOhCUdfzhPknAwAcGUJFUzFum7E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-570-9EzzfmZiO4yzHrHWCyU6sw-1; Fri, 08 Aug 2025 11:40:31 -0400
X-MC-Unique: 9EzzfmZiO4yzHrHWCyU6sw-1
X-Mimecast-MFC-AGG-ID: 9EzzfmZiO4yzHrHWCyU6sw_1754667630
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b7865dc367so1127533f8f.2
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 08:40:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754667630; x=1755272430;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nV2THAhy31Q+K4giF8sVO2GD93KEd5+dTPyv2cww754=;
        b=VGgRL3RgnH5U96cAulUU6Eww/tLIi3TjzEZuASlgPR9L2XTZMtRCsI1sdj59icLw03
         9h33uAnczEYBzyGOzNPN7PXSYpGlGBZozLbFyf3WrOeMOYM1TsxxMonB8djtcNBQXtVp
         lPIjn2ZLEXQA5mh97tYvt/9G4rDQ2r54Jl1L68JT++BjKsB/CyQpxc+PnO+5fm4PCHPB
         tlZkYF8hsOkUmqNh00Zl4o0eaUHQl9MkPpeCPer8VQqp9EomSDn8Za3Ua87/qTHFKuvv
         dMN0c5iX3kET9bwkgPh79z3l0XSk/JtOKN++HceCla0d6Opb9hIG4GXulKeep+Aa3Qxs
         wzXw==
X-Forwarded-Encrypted: i=1; AJvYcCWbs1O+2TBtXubWIPTolayWk75MHDW2j9RqYiKNQwJrNHPBXKWQAMivMT8Dl0/sXPUCqrfvqEocHQ==@kvack.org
X-Gm-Message-State: AOJu0YyJ0ixIJum6q2WIB4XV46QzGSmxUnzBrQ0D1248HjUPiTvEKo4c
	Sdmq5U5nSYod+6XmRVE0YTOUushZsJrFDS6LZR7u5/Zhe0a6Z1ug/ocWmfFNFmDJtCLRrZHdEDF
	OwugKRfHJwO9mNAWl0Bq4DVlQ2CJFYrztQtdSLlvaCKOKvjF4AnCj
X-Gm-Gg: ASbGncsHfUysl2RNtFVlE7FIUGvD4qk+rNoRkknuT3IdeDGzq0hP3sbtqcDr2MYAmnY
	nDEdWi4UrOt0kPqxCPkQgtuKQzgRL+8zhV7FIvMcGn4fD4JqUnWVPJPYsbUT2yFZ2n3iQ8R+09m
	Bc9dob6DBR0JVjELu0WV+fSAlLEtvAP7iW5SHTfr2wu7+11xXQu5YU6h6ghyUp7yLsPgowFqnTw
	Fft/UOrPw3W5D7sGt7yY82uLKGh4t+nOORdevspW4EcOmk+SE0T7MioOMAzf+8CjVGasjcBNdrn
	ix7SgCesnTUso0wII8KRW681+vDWpMj8nuyvqbL/kKznBLmivRT3zEx/xt42GIVqsDnNXe0rKD1
	P7WjgaS0YWpmFt+Kz7zw6fxVk9zpCm6RNru0smu3YOIK/bzb8soh0p8GllvkkAFQt
X-Received: by 2002:a05:6000:1445:b0:3b7:8412:4540 with SMTP id ffacd0b85a97d-3b900b72d33mr2337798f8f.27.1754667630461;
        Fri, 08 Aug 2025 08:40:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKTxiJV2FPuPGMFcDLKL8AQfqKKwG29vC2FbgES/WiGrUMMRdjd3ayWesLeL8KISsx4PxMEQ==
X-Received: by 2002:a05:6000:1445:b0:3b7:8412:4540 with SMTP id ffacd0b85a97d-3b900b72d33mr2337775f8f.27.1754667630025;
        Fri, 08 Aug 2025 08:40:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:900:2e1e:d717:2543:c4d6? (p200300d82f2509002e1ed7172543c4d6.dip0.t-ipconnect.de. [2003:d8:2f25:900:2e1e:d717:2543:c4d6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5e99e04sm137942595e9.11.2025.08.08.08.40.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 08:40:29 -0700 (PDT)
Message-ID: <311404a6-d0d5-4b5b-8e6c-be284abbf319@redhat.com>
Date: Fri, 8 Aug 2025 17:40:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/1] userfaultfd: fix a crash in UFFDIO_MOVE when PMD
 is a migration entry
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: peterx@redhat.com, aarcange@redhat.com, lokeshgidra@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20250807200418.1963585-1-surenb@google.com>
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
In-Reply-To: <20250807200418.1963585-1-surenb@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HWX6JKafmAS0_cl7HlStgqWVWx08Jj5HRWacKzg1uws_1754667630
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A099B180004
X-Stat-Signature: zk9ity5ifhrsafem764sn66cyxek6pkh
X-HE-Tag: 1754667633-541429
X-HE-Meta: U2FsdGVkX182p2mim8I0cvvm5gai1ShvPA0XOEXJPnYmmd97Zba1mbpbKKtRIIWnQBLuHLbHklsZR9AzjZN0/DT6tefLrM4YRDDJ/GtrDA/7RW4g2WQxKIQxk4zIQlLJQdwF1bTM1FU8Gefhd6ubOGsKcWN4MiMyPxk5TM5AZdaEo4Z1vRM+O5WiyEjAFya1F34h36/x3tc+OkVb5wl2wXx0mchkjpiKCbbxxdnQGxNesnzF297OruDL/hDJ37q+SMH52aKO0Wxq6meX8XTJsl+a+dxRBmP6tEm2LAfbFZY/jLCFN7zM8f+BFtNIgSlFdLnXeGMT3zDT82f6fGQ3XyTf3c4nW0ToXxr83s7kfVR2d3qHRXNrs2o+rZOVPAQ2Gp0Zd2tK8RtsRMxOpwpXLrqqIowXRjdV+tAgZU0bvktVP+5KT9SPppQyhQOxFdLqffpdUo8yuXU46mjzbNIxIs6oqSZ2KUJu1jc6hZ0ywXHp2nf/DCEycIfTPaxMQf7K7o4iaf29SeqMX9TYfaqwIAGr/faH2RXbpDGsr0FxGzO7t2nXaViwlsfatS3NCiIsd5c/xYD+gQhmpB5nrwWc+pRH5k4V6M8V5yUPThcqYID4FHKfGJUFgVZabqkd+l0e4qraL+bcQSRs6hpldI0ygZBwVNsjcCluZB3NlM/KhSSARXaYMg2JeFnhc/CM6gAOLYBCs+y83MpEJKMZNOKzXaLo97jqf/dF/3+MO43VPGNL2zJbplprRzhl3FXHay2QRkprtis24oLDyQwYH7SGwjoKaMsTPPaTFEXsh30RRN6nwMifaeF4pNp0HWeEIuVrQ9WR1okQwAcVME/NveGt/RuZD7146zN0o8Sl9XRYaQJddYK2lttM5iws2extLkJvMrDrhGy0K5z9LQQb6YmBC5hAfG/lRmMucbYfeVK6COozkIL1lhaJAvBeOGpZHRD6IarN6BA7FDlJnyOw7cv
 8/Gq9N2j
 XraISni0RiXUOFEKR6DxDAvPTX+4bBaPzpOiQlb+HOJ36zA8i1VoBzjB2JmCv+NsoMTAulJuwAwNjCwnk26DFSfXez/oFuo57Yqqvdnt+xINjsIftYbpvCBntFrKhdZpmygIpu/9tpQAVdWdKYen/exQjb+JLPAf5Q1+QMT9ZVGHDkTxP0wr/Rl0qHQ+/OFLIupDnvSi5r2Yq9Ljc9qJtsmzE2u9Gknr+ebNm3REDFlmDSsMjIWLYLhdQOk6o9IkXi4YSAv7vFb+R3BAOlcuV8NLUCZqguKivKtJIFS/eC+5gsiVTGsXk0rXQ5TzHhABaIkgVGywNPSARk1MLuoBDarvE4hZvcDsaeS/vmuNVR+pJ1enKPQ7Num6soy5mnDi7qr26OH1GxmM+tUwzUhX/ZOXETUqc+J/6jqdKKb6yor31eXnTMgtyGZc/UmOP5JsQ1sW5vPkXMV3gmRmCRyF0s31/2z+IArCW1PvzgLSDvt1Letq25AnwcS/qRt3qBcNit2LD/ooH6ZnQXtgNiy2mseNCsyLqxStds40ducSbFG3BGqhEOj65oy5PyJ18QSUq1golth70uDzx1+DWPRNBsB9Eo66rGi2en7BNsQbqTSe30yF6H1QuN+6uKRxc9mdLgVv2tcFKbCGS/zvaZCH2eYUnKJIo4640Yeqe/3gNPJ8Gvbgxr6oKgHUDBKZv2xrrfB5LMU5wnmeK7J0q0N+r85IDFOIfhAZOWaIZJcDo1CX0jhwToEc4FkMC8ne4V6IVueOw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 22:04, Suren Baghdasaryan wrote:
> When UFFDIO_MOVE encounters a migration PMD entry, it proceeds with
> obtaining a folio and accessing it even though the entry is swp_entry_t.
> Add the missing check and let split_huge_pmd() handle migration entries.
> While at it also remove unnecessary folio check.
> 
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Cc: stable@vger.kernel.org
> ---
> Applies to mm-unstable after reverting older v4 [1] version.
> 
> Changes since v4 [1]
> - Removed extra folio check, per David Hildenbrand
> 
> [1] https://lore.kernel.org/all/20250806220022.926763-1-surenb@google.com/
> 
>   mm/userfaultfd.c | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 5431c9dd7fd7..aefdf3a812a1 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1826,13 +1826,16 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>   			/* Check if we can move the pmd without splitting it. */
>   			if (move_splits_huge_pmd(dst_addr, src_addr, src_start + len) ||
>   			    !pmd_none(dst_pmdval)) {
> -				struct folio *folio = pmd_folio(*src_pmd);
> -
> -				if (!folio || (!is_huge_zero_folio(folio) &&
> -					       !PageAnonExclusive(&folio->page))) {
> -					spin_unlock(ptl);
> -					err = -EBUSY;
> -					break;
> +				/* Can be a migration entry */
> +				if (pmd_present(*src_pmd)) {
> +					struct folio *folio = pmd_folio(*src_pmd);
> +
> +					if (!is_huge_zero_folio(folio) &&
> +					    !PageAnonExclusive(&folio->page)) {
> +						spin_unlock(ptl);
> +						err = -EBUSY;
> +						break;
> +					}

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


