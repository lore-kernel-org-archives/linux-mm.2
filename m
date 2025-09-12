Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C7ACCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 16:01:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3881F8E000D; Fri, 12 Sep 2025 12:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 337838E0002; Fri, 12 Sep 2025 12:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FFBD8E000D; Fri, 12 Sep 2025 12:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4AF8E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:01:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C940B160875
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:01:50 +0000 (UTC)
X-FDA: 83881063980.19.9132FE6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id B9EABA0011
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:01:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AhsSerWJ;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757692908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7PM5ZRd4S90e19FLayespygvhu/XkkjScwaGdb9c5xc=;
	b=G/uQDSbRXNiz8Lwgz7nSUZV/p0LNVKTwjcd8vOfKE5rg5M8j2KpbyKkKZAZrDg3sSUfU3S
	TC6pzTItW/RwGImyZTqcxoSiVSlw37t4MCGYWpNRNmXeeszMOSdX7N2aKyU3H5SqgAuNLJ
	Vbc0oroWZNjRvFNfN7gMyA9tc/uOZDM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757692908; a=rsa-sha256;
	cv=none;
	b=OFpXnjOKFcq1DlD4OI28sVSLiOWUBcopyX/2R6PJXmRJOfgGsYEJezpNNpoLWBGBB8TAiQ
	0J3vVDIniYk3PCOZ9gojwexDFaL+HWhVgM8TelZgCyqUy6t/riDYy4dZ+jeUqZGKJZVZ6L
	IDpbMOHXFHkRmKT/+04RymHrQ6hzzCo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AhsSerWJ;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757692907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7PM5ZRd4S90e19FLayespygvhu/XkkjScwaGdb9c5xc=;
	b=AhsSerWJXYdeRWdgOXGU+CODGTluWr/o7WNwJH7Q67zNQmXnogAPcdUo+rGzRCOxUQKyd0
	1hy9cvgt+FFlafVRQJVA1cPSPOewGlB80ygDIHhyLe0a4e71G/LU1d0iukW/83/5mlQEt3
	NlZHfLABzkR8KSqdrhSEzADbIDh+BD4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-fMsJjWujN1GJQEL1LF_R2A-1; Fri, 12 Sep 2025 12:01:45 -0400
X-MC-Unique: fMsJjWujN1GJQEL1LF_R2A-1
X-Mimecast-MFC-AGG-ID: fMsJjWujN1GJQEL1LF_R2A_1757692904
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3dabec38299so1263517f8f.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:01:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757692904; x=1758297704;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7PM5ZRd4S90e19FLayespygvhu/XkkjScwaGdb9c5xc=;
        b=R3YV3TMWOxzzFeewZ2vG2IX+MqylpwXexGrs4DRj9OCrFkqDT8/QtM1Wo8dRAtk4+m
         xZ/1OEJNSn7hjD9kgDBtCHVGURUbUCI84nSJlch8x1qnDamKoyyiRa/iA05zt97hKt5d
         jG3k9DgoTG3VjAL+O4bDOlOncoSuKzuuQ8kvFW/EehcKNKfoOBDbV6KBWuoQMNzAzopi
         LAskZBPtxuFIn27zmhreTN85T5eWxSZ+94JUZtxbKtC2JVb2kHmJnrASKZJoS807jjqT
         A6N50W3RkgViuaTkg0/bXiWx1EOB0D0XMyBo3SNhxZnh/B8HHxS1Wb+S8a8o6rYpKvVi
         PHOw==
X-Forwarded-Encrypted: i=1; AJvYcCXOUMTcZKo3DMXwjvMrDyaq9TUBl4q2bbJVhDXNY1aoCMQC0TIPGq8J//0WHWVA+IOjwqfNDNbiZg==@kvack.org
X-Gm-Message-State: AOJu0YwAll9pLuKR9rBPkszifb0HKZoPj/bItVv52h3wObJOKbf84YOo
	m8HkDY90qRdFpqQIcysk5Fs5TDvEtfh1MDmI09aBLhEGXhFLJqGumSGF2M1RGiteZZgiP+Irhft
	OfbswfFJAtqc58xbzjifnt0nwGQTxj8scnURgjpDzqtypd3mDFUc7
X-Gm-Gg: ASbGncsAldfudLLPBq/OVZormxL6lZEM9zT88SSvWtycyE40u9nqOPEpQhGAwyRpMxJ
	8ZVG4THgrRcHeisHImCfGtcmNbJIgxdMeOiUsPqjYx62oJOSq+xn6U+KcSaPGiznk4UOkBYh6aN
	e1xO6Lkz2ssWDvouDt3qugBsDA6dM8XXZDtGZggUUDf2Aooejz4oCYTczTd2J1+kfEs7byNQ/+r
	r1H7I8qX3j7suRc+onQaNkjub9pMotIYDrFRH6vPFpp7BoapLWY28HAU4PWhvIBdGC1qe/h3Kth
	rGob3bYhQVAQPyvPIQkmHRW2MTLFkWOnn4HKmpRVyd5Z+QyQUWYeSDqgVPjT2NT14FbO6NnD88p
	yyv2AhmAIAGqeyhMaDCv3AUu78S9hOyIhnyrixogFN24iCJCHVKATs01HJUdFPmox6g4=
X-Received: by 2002:a05:6000:1acd:b0:3e7:615a:17de with SMTP id ffacd0b85a97d-3e765a1a4cemr2586243f8f.47.1757692904272;
        Fri, 12 Sep 2025 09:01:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGV+C0BMQnQi47+CMhL25ihOXmCC88+Ak1u1W7QF2sbOPSW+YvOWNmU0uOjOZodfLU6UMRT3g==
X-Received: by 2002:a05:6000:1acd:b0:3e7:615a:17de with SMTP id ffacd0b85a97d-3e765a1a4cemr2586210f8f.47.1757692903581;
        Fri, 12 Sep 2025 09:01:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607cd4cdsm6980192f8f.37.2025.09.12.09.01.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 09:01:43 -0700 (PDT)
Message-ID: <f40a1a9d-2d37-4afe-abbd-366ff573303f@redhat.com>
Date: Fri, 12 Sep 2025 18:01:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/15] mm, swap: check page poison flag after locking
 it
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
 <20250910160833.3464-5-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250910160833.3464-5-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 98TaymC5nm0egZhm5xVIc0GqTlxW3VNYFERenA-bTfM_1757692904
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B9EABA0011
X-Stat-Signature: wfa77mninwx6yt3343swnnz3jbt41r3e
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757692907-566273
X-HE-Meta: U2FsdGVkX18oTV7iJDSk1CYgHgnKvhNlxVqNhPuykPukyDCYd400rUNLDVVOT9FMyMrvCzBXx87zBb7Na/ibiP9uUCBptS/9coxNNnBnyqpcUTAm4cSAi2bHfY6+ZnRQJDmIRqqyVXw8cm4b6PqZm4ioa0XudgVFuWvpSEgJo/ASuGdOLrZIZ3wReDrK1XP/Gbh3hq9oZyqkxVpuhaITrHE7I8b1Kl9VLqDxcmAYbhFrNpwWyy2gigjdkk8/yG0iUxa6eZsETNyTXivTufnXhMrFf+/y6DNfryNjb/kGyTRk7X/8RgpKQI97Q4L2tfKAj6htQSSMSurHMJM+k5TY6MSDgF5ngurroWOcUI+8t3irAd5/XeQDv5PVVQq6zFbEB38qdwN+TGA3oN9dexjQTBhySBO1y4shSV3Z487oZJGuCAPJhIbaZHMhtNkSk2Uybixg91OW4j5TJgAgF8uCj2AGQvPhmAIUoAsZgCbBm6wd46MtSD8iaueDVteDQVWv6TFP/nAW6ZfeqGAPgjLewllB0RUpRXBS/UcjuPKP8lW4JXwk6SHJp9byj4HsXzMmafY4Q9Y6fKAr8UFcF+hOBj920J5KHFxREj7irjKLZ3zM2B9M+UjInif3vvsrEm1x8XjRtPSUM12iXyyaiGOWJqUKmeVAF3n/9apuujbNpyUjeEEalwvaeXO64fEE/v3ZTGV1OfEQF3vTJvIiBLFSShpN0Np6fy0sdsDiouKXHOXwBJiksexT6Wot1gQ0cyHLGSxMMHkCBIqKAh0h8sA9tAxgSZBFA2qpQBZIqZEobGk6n1tWuEAutwLuiTyOUfQnQHz/rRyob/WhXYV0xl/bDNadstqLDJbg7URTlETmldHdGZCsfQP4UkK9BRYCuCGqbtNYxlcxYaqe3nZRwsR64S4xVnd0Pi6TCPT/ltN9JzpIj0eRNWENTStpJdMDV/ir30KlrSX4MfSHn/tgLZr
 FYvl8rYr
 S5KASkwzMK7pxVVaKqgbRya9xillkFiTBOxI1l1fpoWF97SYv+nb+oMh4YCki93oYxw6pV02PS3UfX93CePAjGG00ixWSyvSRBsUBOpFVbipNoyfsrjAazsWJ+TDWIQJsqNw4rJM8ugMAz5Ki5Hxs91PN5m4yryGxaphJx+xK5aXuuXXj56Y3F5oiTGp5kFlcXza6nOICW7QSVmPgsovjh29gn4Ww8fOqpLA1IBh8mhWQB1Dpj0Q+vX1GOA5gRe/RQJdMKpH1Pq8HjcYS4b2eYwCW7vNbv2h1XZlBp8G0pJO2peJ+AKRXJfFqmmvEq0N2EpIgNrOSJhOmM49/OgG7mjBIRKsHkzzIjIlmNkClwxsTLscHpjTGjkkGnUilOIFS19MhQjYrbgQqVAerVYeij3WjfAbrOvfLVwpzogum4B1vbJpGOvl3Twf8D+lwIEousVhT1rU7TNyfYdlkN+fCyFMVgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.09.25 18:08, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Instead of checking the poison flag only in the fast swap cache lookup
> path, always check the poison flags after locking a swap cache folio.
> 
> There are two reasons to do so.
> 
> The folio is unstable and could be removed from the swap cache anytime,
> so it's totally possible that the folio is no longer the backing folio
> of a swap entry, and could be an irrelevant poisoned folio. We might
> mistakenly kill a faulting process.
> 
> And it's totally possible or even common for the slow swap in path
> (swapin_readahead) to bring in a cached folio. The cache folio could be
> poisoned, too. Only checking the poison flag in the fast path will miss
> such folios.
> 
> The race window is tiny, so it's very unlikely to happen, though.
> While at it, also add a unlikely prefix.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


