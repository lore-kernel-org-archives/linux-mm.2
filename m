Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0BFCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 09:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43C8D8E002B; Mon, 18 Aug 2025 05:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5738E001E; Mon, 18 Aug 2025 05:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28DC18E002B; Mon, 18 Aug 2025 05:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4E48E001E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:44:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF7B61390EE
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:44:25 +0000 (UTC)
X-FDA: 83789392890.02.E09F840
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6899720004
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:44:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BZY56k3P;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755510263; a=rsa-sha256;
	cv=none;
	b=tfE+TwlL/kF6+tH77UWCS1FMDrD3OPjWceM2ad+lD4Vjhw9mvWboDjzxPaEO+MycAdFVLe
	hL2zQCwpLrsYnhRh2jiC58slH8kaOXklNHPz//3lYZp1GEK6n8pJb3ANHJO4CDlbY2j+zr
	SugA7LGM3+++bNCGTIe1dk0kdC19RVY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BZY56k3P;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755510263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bO/hi//70PNQS4PRKZk6OCbLR0nHf4/8WHcoc8PRhG0=;
	b=y+KqlL9l3CtZJrsLa634Qktm9+qtNXPSMrnlcU/Tfpo6QEjhqWqFiYXN33vNUCUMHRf4ti
	RFBc+voJgJYSxFCZBqRZep5IF/ivbxF5TU68CZpQG6ayrpCH9ItG/rU4uj261wSmfbDRDA
	Qtuicy9Opu1H7VAEGOCxGV3eTRFcOr0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755510262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bO/hi//70PNQS4PRKZk6OCbLR0nHf4/8WHcoc8PRhG0=;
	b=BZY56k3PVNTByusUR28PjCNLQrKUqVCaY6eLVXpvrnJR9lTBlFvnu9zmYmYJfbW5D8GxJ+
	1wuLLyKHfazwDw/O1bhLkwpsGDFo5CeO3hBGu7cTFK9nAQh/a8qnRIfPXwmad6G6MWAeA5
	aFtrRvEUdSsrGvrMz+l92Vwh2o/LM2c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-M8aNwJz8OUiKpqLnM_NTLw-1; Mon, 18 Aug 2025 05:44:20 -0400
X-MC-Unique: M8aNwJz8OUiKpqLnM_NTLw-1
X-Mimecast-MFC-AGG-ID: M8aNwJz8OUiKpqLnM_NTLw_1755510259
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1ba17bbcso15857905e9.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:44:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755510259; x=1756115059;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bO/hi//70PNQS4PRKZk6OCbLR0nHf4/8WHcoc8PRhG0=;
        b=EYilKVjHYR2aFTDAw01wO9BvsZz81mo9qKxPCt+UVuxIXkoc/cd4wJK8F337GRE4jR
         8HBaeg6Q34AMVEOk8rGt0JCoxNaGQaWBhL+uWHGmwPBOChWjOc3vKmZraZ6yGogUqKHs
         6TvOOxlTfXlEiTOddNtDgOZfVv90z36vXUidekK6FDyQEonIVKoGTZ8arraB1YGytQK8
         KNFsXJmNact1efrWK0mC3Zs5K4hUxGbo592AYuBInCVWTPziByEVxPsGeaMoTTJjaAh0
         N/4l5vCTFl2o8Q5//LM/ACT2SZCxGIxUzbvKnSJdEonUEoJCzYRGqTWgRMIKU5mOQO6I
         Lkxg==
X-Forwarded-Encrypted: i=1; AJvYcCXvglrFLvqPa4xKKhxBg8vvpDZ4EzOHZa9BJQTvqxKvJ020I6aCVVe1wP52BkGA7mq6ri/iS5VWjQ==@kvack.org
X-Gm-Message-State: AOJu0Yx6eZklZ7IisJPoyv1Y+6MY4v4gHbZnWc16v5F8a0fW4v4ov8Wa
	+0r3EQtsAeLBc9u8clY37Qwy1HI2Dm8KJJjKM3YqPT1yDuyWEpyVMHYEGLp7DxTx4Nw9NEmG+wI
	rQkoEAVPvwPu7mLXNWMK1XrsWTIGce6IL9VLnMUlbMTX1xMPf8Ae7
X-Gm-Gg: ASbGncuPPURoYb2X2GRZxM/BtGPs/RpGgCTllW6xLP6QfHLGpzTraPIG3emhBjeOsGn
	h+A1U7+CBCQWu6t3QwBdceoK6grQk/9D5W9SGzyHiT+usjRgsZ16z9a2PRWrwvoIwxbjW9qTgxr
	/kP/zmxdSQccb8hqSVYCQf9kcdCh/vmxzNTZqVdQChpHcr5EOb0397gEp/QLZf5kAcMREV1xlWD
	Nv7nUx8N/mVfvknlHeLqSv5l4scZuIj6EiqtLaOyFf0KQyoITr7mGHezzJtMGFE6tZq4UcSugXy
	KhSpIjLnwSuahTxoCrh2N6TOB+z+t/jv3wCiiTPuwNYvdyqG0Se4mrpfk8zu0lH/WuAVXWdkcqn
	bMac5ok319XI5dlO/p11GymWX8FqvAIkL+KnUgGwhShmGUlM/vZoGRl5ny6OwetnK
X-Received: by 2002:a05:600c:1e0d:b0:459:db80:c29f with SMTP id 5b1f17b1804b1-45a22031cefmr78156915e9.1.1755510259116;
        Mon, 18 Aug 2025 02:44:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjiMETiwxz6+Sga98bI/im2QTZ4KQOy7MiHPd8ZEIVTObrOWdDHjAMkOKMLStR98OStBvZxA==
X-Received: by 2002:a05:600c:1e0d:b0:459:db80:c29f with SMTP id 5b1f17b1804b1-45a22031cefmr78156675e9.1.1755510258626;
        Mon, 18 Aug 2025 02:44:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a221bbadfsm125147675e9.0.2025.08.18.02.44.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 02:44:18 -0700 (PDT)
Message-ID: <3970cd97-2e9e-403f-867a-3addfbe399dc@redhat.com>
Date: Mon, 18 Aug 2025 11:44:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] Remove XA_ZERO from error recovery of
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com,
 kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
 chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _GhCGK2Ln9AP0I1cpNsUmkhQnrCN3kb_gSsJfNTBUbk_1755510259
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 6899720004
X-Stat-Signature: pk9co39y45u4f9iwkuc9r3pj4g64mkkx
X-HE-Tag: 1755510263-652262
X-HE-Meta: U2FsdGVkX1+FcyjgzL6VINN5qOLudDBY11osESGRfqMsluUmbFpB96e1qZIxtkoX2Gp81RzdZM8Y4Eo9e9+oFCiRPcHa7BdMa3NA8p5N8hQO5+2ja1lb2FHqjvB+XwWzmG6cf0v9JFFCOP6VfNeyD2KHjvVuCVPsD3sh7gxSMKOMG0juiHY5ADhPpfGoPk8xIulQQia856E4FCwyeSlO2uBN7QXgxeXTtKlXG1sljFjsLN1YvqcBCXz1bSNa0xHWM2zEQ4PjFlI0OSDHUC6m+au6svdzYsP6/ybVRpfNqyGhntZbKMCP6CQd2B068HS4hS1cqVko7il1hlMZWAckqFTuQ9C01rYw0J7pKDVMXe/IQfVNEAk4IfELf8Clv/Dp4SzQTyPD8glqS6+6ZITq/B87lidH8eyGTjQyOUzxBvA/EuL0jr2kWbJxe2qU8FgDjVQrzwTzTtVi7bWG2d4ufRBomyIeRzieSpbCT4x8PhNOJLlPFS/a/7tfPtE2WIUGmsfjjnLwK99xAoRBjjS9Pe+xcXbwp9j0dLg+Srq1IK8ESTh98UyXx5rGJ/JTAzTWNbt7zgSwp/IufME55AsiZ2c+ugsN0vbbVeWg03D1BYVIBvsdM+q8d7tResY7Tm91HDCENNBSNdrJlCvYXAboZtXak1k7IebJjSjFcFuGmBNtBQzNLX1SjUQkUMT3SGl4RofqnViwUFID4rtIyFtjNL7UXnaYiSa9fd6r0398pm+KXv4yVoJpg/9vgvjOiYHTAPGZ51fm15IuNm0HTJBUTC0JbYLGi1wEBJIh1V4alST/PwmQjLiGf0f6Viw2K8qTcO8rXboYLb0Vk5+HBqpLLjtKK0XAxB2yTS/x9c4fr5UUe0yMwlLxSuzt/p2/myv36jPvfIc0YK3PLpiXg7p7OgYGrdbtBk6mB7deiseXTTwdgNTrwwufbb0hrC8EALSu3MmtZhJOYZeGnN55yWg
 wfVv6qz0
 bDB7o8T44RdhW01uMxalCS84eqQJrvVBtdewAi9FZ+0BWtvrXH9AedBHBo/eWLRuvtIwVswJVFmIh1i561/YlxUOxTaW1L3/GfVk58xGQC+DJaKZpOjZmovVuw85DAYjY4NcpayPGu2ZvL4VPto3epXhnfPwtlMgOr7aednv8TOlfeJ3CSNKtj5qfB8qZeNhFe55KpT4/dyykB0C3bkAC8EPhUs0m3LvBsyTTsFKnjiTbx8VLcpyqvSf7a7Isn8+Y3gd/oBET8PG4btG7zSbWWjAT+PXSdAcYs60fQfxyvH3nxwLXoBqX8x7B1M3xx+L7g4Cu6r19EMPapr/B2030kGKrauRP7v7RpbfDNguc8wbj7OZ8o0MLOjMIqom2gaWK6XhpGRv/p7zCcjDFnI87bxNhQrfm8cPOeys0um9r80rEnw/0XUTDM2fG8zJZQEO3mtYy7hJL79hlQlTPYqzihEykMVtujDNFv3Y3kM0fw+EUsDyGGsDzIp2h0ZNPW18bvqDmEZ0038FoL06uyx6te39vIbO2+L1RdKHxqTTqmCUHkvI/erx5ltLOhrkGgppvbNNoXievhmLWhsGt2PuogeqAZDx0r+R6ZyZX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.08.25 21:10, Liam R. Howlett wrote:
> Before you read on, please take a moment to acknowledge that David
> Hildenbrand asked for this, so I'm blaming mostly him :)

:)

> 
> It is possible that the dup_mmap() call fails on allocating or setting
> up a vma after the maple tree of the oldmm is copied.  Today, that
> failure point is marked by inserting an XA_ZERO entry over the failure
> point so that the exact location does not need to be communicated
> through to exit_mmap().
> 
> However, a race exists in the tear down process because the dup_mmap()
> drops the mmap lock before exit_mmap() can remove the partially set up
> vma tree.  This means that other tasks may get to the mm tree and find
> the invalid vma pointer (since it's an XA_ZERO entry), even though the
> mm is marked as MMF_OOM_SKIP and MMF_UNSTABLE.
> 
> To remove the race fully, the tree must be cleaned up before dropping
> the lock.  This is accomplished by extracting the vma cleanup in
> exit_mmap() and changing the required functions to pass through the vma
> search limit.
> 
> This does run the risk of increasing the possibility of finding no vmas
> (which is already possible!) in code this isn't careful.

Right, it would also happen if __mt_dup() fails I guess.

> 
> The passing of so many limits and variables was such a mess when the
> dup_mmap() was introduced that it was avoided in favour of the XA_ZERO
> entry marker, but since the swap case was the second time we've hit
> cases of walking an almost-dead mm, here's the alternative to checking
> MMF_UNSTABLE before wandering into other mm structs.

Changes look fairly small and reasonable, so I really like this.

I agree with Jann that doing a partial teardown might be even better, 
but code-wise I suspect it might end up with a lot more churn and weird 
allocation-corner-cases to handle.

-- 
Cheers

David / dhildenb


