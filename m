Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1404AC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 10:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A59D96B00AA; Thu,  7 Aug 2025 06:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09196B00AC; Thu,  7 Aug 2025 06:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1F56B00B1; Thu,  7 Aug 2025 06:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BEC56B00AA
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 06:31:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F1A85C2F1
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:31:07 +0000 (UTC)
X-FDA: 83749593774.22.05BB94D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id A4DBD40014
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:31:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hfDRaaRs;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754562664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+qVW9cLOj54YF0xIaj0lWIjiH/j6vomCG3o/DXozcQc=;
	b=XhMEu5NjYtcszXIVv475UDwnIdHNo+byMRmhSOFskj54U3kjkvhpcVcsGYS/nmJueVlBGw
	2xnZk+IHGfVBT0OUuqApuGCz8juRnCVPXHhAIAugZRj9wN+83AlpZBimQGGLln/5Iw4Vs4
	20iJ8etaUGVQzrVsBt3ugyuR+w10jwY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hfDRaaRs;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754562664; a=rsa-sha256;
	cv=none;
	b=uKo5zHEbvh93IIxDOcmwUCtDtWhMRxerin0j56j6lXtV7a16G7qKEMd67JlJNEpxvE4FL9
	jdT0RazoWumcNY6CbFUtaGUX/cAC99W3TeeSj1ROPEt2Aa+QCOe45AAFnsK+sZ1pkocX6P
	EzXGMQx4EiN1cspZLuNF138K9MZHzr0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754562663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+qVW9cLOj54YF0xIaj0lWIjiH/j6vomCG3o/DXozcQc=;
	b=hfDRaaRsjKFL3HmVG6aWrXzs9HrMXiszjYyz/BsHRlkxeD26fROrUCGML16Me9hmHsTsnD
	7o2VU6GWBc5ro+DqY9s5yEx81pfuHLoLTvZzN878UfZm3ew9k+R/JTZe8sUD+/HcTFc+SS
	cuAHaQEm6IyXT0UUKBMt9Ow5U1L6ob8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-Vrs09F-1PbiJVRFOv-VNlg-1; Thu, 07 Aug 2025 06:31:02 -0400
X-MC-Unique: Vrs09F-1PbiJVRFOv-VNlg-1
X-Mimecast-MFC-AGG-ID: Vrs09F-1PbiJVRFOv-VNlg_1754562661
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b7889c8d2bso381364f8f.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 03:31:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754562661; x=1755167461;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+qVW9cLOj54YF0xIaj0lWIjiH/j6vomCG3o/DXozcQc=;
        b=kgrcUpjaU06wxP1sm/Wmzfa0Mfp4PpxYk6wfkBUIflAelnIT2VfyqMcrZ+Xk0A3woO
         9CMPV9q6hVDFJbk+r29dDcPLixZ1TH8BUFcS46a1q71mJR+Ob2t8hMbxx0NQzgeqkE4M
         nXMCEpgzMBxDZ2f2IQtcJnYxCSj9R2Kv1yvtQDr7xvhjzykaiRmPBtQSbzBZzIMBSEya
         EJzksh86m2eAdoisw2QdOAhX6pANsWWiLJ17JL035Szltk/CVOqMBVPEvEbPbReehXr7
         alZUGASpIlG44qcA1C8arwl9VFH59hMKLd4bXwRXg6ZBUV7ZYysPzLsjC6rVXHXcmPts
         3Htg==
X-Forwarded-Encrypted: i=1; AJvYcCU6KAE7EW4T+de15PByAKHajcSTtWlcVhCdMcMRxsGwgBgudFQUV+cJhRzzvd9QmsFMOJcvGag3DQ==@kvack.org
X-Gm-Message-State: AOJu0Yw4Q4S4GH/i+vLtpUbF5yBpNh04wM0ftO2WPjzzZ3cqdpPm9a/Q
	CNf+fLjQdesHImI5zfhAKtwm2Hc3eapEpHghHhq6sx3QbffwL5B10D8kx8bMMTAJSlJ7iaeKgWc
	bYj/V7+s3BZEEZF2ykrj2wUDnpVymL2nNbjrIhtf6ACvUtN5kMW/n
X-Gm-Gg: ASbGnctHfBR9NhPwnrYc3muPShmWBHkvuE91B7ZL4WztSO5RTRGYIZa1ZdSEwJH7x8n
	PlxYegrRte2ZYTz8U+hQj6+GEScdO3y6wc5Px9qI7ovrwtTUrEO4BfmeJslx/3XM+qEVscSRzHm
	boCk9GRuuzPw+nbePTk2EUMtl0IwmH3SrejUYdVOcKsHrkGSskXF+3qJjDM4p9D4Fie+NW1zJvc
	mFbbwwrpHiJyuLJYFWRAnE1ja4P0hsrsLx+/sJGCHd4tInC2kYqAg0DU+JD2PVoPjUb5Hbwmjni
	DNYk1YYjisFjbj5wyYIZneo2STfNJx+XkTVGtCNQtDKidiZcV/I8wv5c/Pe/Ksmjw7dO2PC81bn
	Sx07+cb1u/8YiceyOzpud/MZqDWCOGR4QW5c1lDh9koSHmaXapuh6tIjedFlBeWEZE7w=
X-Received: by 2002:a05:6000:188e:b0:3b7:8473:31bd with SMTP id ffacd0b85a97d-3b8f414c4a7mr5352826f8f.0.1754562661277;
        Thu, 07 Aug 2025 03:31:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVvmP83x7UutNKzV8FG/fdk3ibG+3w7boHxmbnZj/SXv3iUKT38lto02D3K+S+RQXWyX0Mbg==
X-Received: by 2002:a05:6000:188e:b0:3b7:8473:31bd with SMTP id ffacd0b85a97d-3b8f414c4a7mr5352785f8f.0.1754562660784;
        Thu, 07 Aug 2025 03:31:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f49:bc00:12fa:1681:c754:1630? (p200300d82f49bc0012fa1681c7541630.dip0.t-ipconnect.de. [2003:d8:2f49:bc00:12fa:1681:c754:1630])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b95f4sm26154427f8f.23.2025.08.07.03.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 03:31:00 -0700 (PDT)
Message-ID: <3eba855a-740c-4423-b2ed-24d622af29a5@redhat.com>
Date: Thu, 7 Aug 2025 12:30:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/1] userfaultfd: fix a crash in UFFDIO_MOVE when PMD
 is a migration entry
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: peterx@redhat.com, aarcange@redhat.com, lokeshgidra@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20250806220022.926763-1-surenb@google.com>
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
In-Reply-To: <20250806220022.926763-1-surenb@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: K0VunzDr7RJmyHXIWm1sNd-mtBD7prgJm2OyIFd1m5Q_1754562661
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: unepbtadz1iennitb4yb9tktpa7t3bbr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A4DBD40014
X-Rspam-User: 
X-HE-Tag: 1754562664-234907
X-HE-Meta: U2FsdGVkX18vjSK7qT60io37O4py7PCqn6x6+HLDAEIKfXE+fYAgZ60vqCs1bktijej/ciDhv/DdyzWVBzoQgVYsaujU+k5Cc8fe8UQ/d4ehP2Y1lgeu1447hwEFmLXDqqPBuWB0LFloq2Yjk387TWErtlYayxcsNbqUEyabb2Wqc8pG5mCVko4jco1WSEEKpvUXstwAAB9DxEjrLZe3Wk/iwKqKep4EJFBiVv6uw084s9MSOBEoc8IKSd8av5rFWfdU3xytMrjk62wnoPDOg6vF8/Wg4E/NOm0OHxscsS3xxbJ/JH675BhEZp8OV9WnZLTsjsFUtSD5csJChjdVx1KEFWZzBtCCddX+bzzJru8UHtExzM3MsxwrzXEODqXp9IyZ3jgGZWVnXApefaS8xDYZ2aP8eLrKNjWfRZ3F7CDRoSUttMCSXjkmqAMZmeEZBk3/CbZYVebDtf9rC3k5DevNIHEPk2KDG/domMHNEhpb6/aVq2gJpUDhxi13osYVTW689rXI/5xHOiYkMD7ZYaEKKqpi1CK+TEKCbNlrw2vgiaG6x9uAmpvDVx4Rc931/a6fzmO4/0mzkyM6ZCDoBwOISEuXNFLPRlrb+TwIexnRQGn3QXREODgC1wAEPF+/f/6Y5Djy/Yei6DsGTNU+0sfJfkwl/egml/e3XiV/96W/2Qkbwvg1Xj1Yt6lGdGxwV9N+9/Y+p2botmhiU2t4S1fx7yA2a9CM9fw8cj80JOGUE4DcwI2HWymABcyVhgcBTVODsYX82/2ZR7IPHiPvlI0jwokxzmTqd262wtWfYSRQ1nAT+ZBn845+ewATI+uXTSzxDmB2YOqh0F5apFAFlZByMqqcXKaDF6vJo8kRPlFjrtkb5eGuF+XBcxEgaetJi8k6rXOmbn27132EpKm5l+OVX5GO2jHNEz6G4gO/b+MUOc8o7bzICuicCnjb2rCxhtfQXw8G8GDg8dAbPEg
 ytiO+nL9
 2cnvcKKoeIbqzpytCoPw8Dwlk8smYeKdY6D2sKplLv2zpBYUwqRnLBXgk+GSRm3FK+962bgRETZfmcGSftZg+EgcHbxZiZ39ha74kmAcdxAOmfJWxfFyUaGqziybgsnZ5uAjpR5tkxcfwnNPrmiA5NS0Kexx6QdFFqgJbvuqleHYd6ZSWB654V/W97TV+04a5EMZW3ONsSo7AOaW+/p5SC2tA54s7BmbLTfKVtj7SVsfNABu4vaNbA2OcCN/6gktZ8ssTFGuI548wnjNwjz07Qe5SyjNpOwxKUmgozwijGNJayCTRDyFo6pGJO+lbRmwhaZUWGcGxcLT6B7bVsUnYYLCPfoEO28xD6M+GPk1EvgHBHtolpOLZDyJtGBXryuTHEBOXe1RYc2gEu+39EgkK/DL3ijB5J2/OY3/J0DrkSNGMyp6GNxlz2J8TfeCunwZ79o092KGDMuV29AqrozhjK3YBnL7MOV62li9h7h217esKFpEaJ/2FKOsqlsq33a600QYLFeEyJdPVh51IRUdl0M11OFvaspa5G6IMUsiuBdXluaU3xL8gcZmXqdn+lzGuzYWUDbLaG8Kh3fnfMI8dIomufI7d4298hBjBU4kJuhCuKn3/mkAk1cUmdFld5eIpH2D+fKFPTT99GNaW8F9Hza/FWJkqMLXTBn3noF5ZrJ9OrSeVIMF53bMovg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.08.25 00:00, Suren Baghdasaryan wrote:
> When UFFDIO_MOVE encounters a migration PMD entry, it proceeds with
> obtaining a folio and accessing it even though the entry is swp_entry_t.
> Add the missing check and let split_huge_pmd() handle migration entries.
> 
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@google.com/
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Cc: stable@vger.kernel.org
> ---
> Changes since v3 [1]
> - Updated the title and changelog, per Peter Xu
> - Added Reviewed-by: per Peter Xu
> 
> [1] https://lore.kernel.org/all/20250806154015.769024-1-surenb@google.com/
> 
>   mm/userfaultfd.c | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 5431c9dd7fd7..116481606be8 100644
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
> +					if (!folio


How could you get !folio here? That only makes sense when calling 
vm_normal_folio_pmd(), no?


-- 
Cheers,

David / dhildenb


