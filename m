Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021F3CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 13:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DF758E000B; Mon, 18 Aug 2025 09:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B7238E0006; Mon, 18 Aug 2025 09:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CCD68E000B; Mon, 18 Aug 2025 09:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5FF8E0006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:18:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3BFF1DE258
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:18:19 +0000 (UTC)
X-FDA: 83789931918.21.7C41BB7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 65BDA120010
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:18:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eGvDx6sZ;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755523096; a=rsa-sha256;
	cv=none;
	b=Ttp9ThHil3Ffg52enL0XWwvTkC5YhBFMfBZ5rrzzZVNxSYIBTJFuF7fI7XqyY3R9ppYTKX
	6OHqJrguyjlqjC47mQfON7TN/QuNy5AsP0oOEbQ4W24IgCm48sznxz21xdMl1+uPt4Le82
	hhLeDjYOQyA3rAsd74pqf9S6QDv/CmQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eGvDx6sZ;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755523096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EI+lwS0pOMLisQZ2H6RwpS7sAotb8pPEp3ZpZSihh10=;
	b=LDVKAifjd30KNCZ9LxbPk9EZtO1OBJim2gJ2fhaRD9TRx01hZ5DJAGKMYZiy+aC1fKb1Yy
	zTi0k3t8OmY84jLXVQzagIRj31JjA9WHg4yO3R2ItmxELzmbICLbxQmldGX09fFVv718Sx
	bLoT2LQetDSfsMuqP6BqOQaA2fxoYs4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755523095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EI+lwS0pOMLisQZ2H6RwpS7sAotb8pPEp3ZpZSihh10=;
	b=eGvDx6sZkr/+qNlEqy6XTfqrbBdxMzN5bsWBhZd2IWy2VZXom6/JybJ556nMDNSKgLc+PB
	OhJCxpHv0XUgBiTbt0Oe5Lx7oc7XpaMOKj9jv13xNL6WRrqNKnNV02PfFYTdBfxrsR6VK6
	YAM9d/qmGMSzejnC9sgVKn/4JXYqG9w=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-yfl5V9hVMOe7J_yq7e0rQA-1; Mon, 18 Aug 2025 09:18:14 -0400
X-MC-Unique: yfl5V9hVMOe7J_yq7e0rQA-1
X-Mimecast-MFC-AGG-ID: yfl5V9hVMOe7J_yq7e0rQA_1755523093
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0514a5so18015445e9.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755523093; x=1756127893;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EI+lwS0pOMLisQZ2H6RwpS7sAotb8pPEp3ZpZSihh10=;
        b=Ac8Cwm75d14UcQ51mDFosSFd7q8MJBi8BNvKWh7mqioINzXqSnxFIicxVftx2/5USh
         NWt+q+agRKCiAtQe6OTpVFznbv5kpKqCjERBH8yvD8y+MLwiZxyraYJg0DXtpeAWMmQ1
         W0yDdEf1iiTimKbo2ghaKSttB0FzSezmYZsg+S8vcExzg62PsNCRcr77vzxBFPawWo6+
         zJ35DYONgiZNbAyPRMMRh39ZFK4Z0N0Y/9/HDQzxsGDs7SUFHcGkQZDpvM1q3yQLnjZn
         LfbG2BWtbp5wjYVMPLIbTovNr6/b7YsqsyaoVjzTkEKLxc32jJONPrTYzVVZbIQdnoxg
         /geg==
X-Forwarded-Encrypted: i=1; AJvYcCU4HyK3Wq74iEINGLqkqCe9hBKqC3ZlGWqIFdwsnUGwMnFP63QQxKmnD43LKK1t/JNFnoAi5HZghg==@kvack.org
X-Gm-Message-State: AOJu0YwNEAwd5lAJWxiM5WAE3S5UFgpgbSYKaChjhoMQ3k1w/yw9c7Ck
	s/b4bWgZkZ2T3ECY8WEEhNFp7WpQDZIXK1J1KvWaAiAQZFekHBIZiKiiQGLlM11g440u1dx2N+z
	4SiLC8192TLMzzsUdgHfA9S114tKd+uT/XJbPDsi88Gkjs2fb29/v
X-Gm-Gg: ASbGncv41CZQGSVTJdMWl5/ZuckFFIVDme4oUsJrzuZQffKypr6XSdHvoZG7WXAhmn7
	aNxxaGL1Ltf1YO+BUXdRj9m///HKouHzj+l8++HE+2IirR3bnDDKu/4/8bIZ1dK5yvmZO4IrxNZ
	fWjvoCeM1MylsxgO5khmNVH+t9yaOw+9cSHH6wUlF8GhNosmZrmObn6pp1Nq/JoVHrnfHUCXTMv
	ZoiTasse0TzbPTk2aZoTVajPioaUCq7SfXeqtgQ8sVaYYZ7Ml6WI6q5uUYbLZpg4l38RKjPq9V9
	mWofn3aF+qzGtlY3uHcizAnkg1TSfE+hlbdcUeI8MTfxSXAEkXtgRiytSNih9XfNDaPpvYGyGPB
	ZHF65p4KG9S2t4HYysRQaI5QFpWQ0YXXbahVNfk5GIJNXvZeUTIwhhtToTRrBPvWP
X-Received: by 2002:a05:600c:4f02:b0:459:ddad:a3a3 with SMTP id 5b1f17b1804b1-45a25d5f37dmr66229625e9.25.1755523093082;
        Mon, 18 Aug 2025 06:18:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvCChE+JR/YLl5igJTrgibt6OaLIWASKnwzJNFN0U4+Ia5ln7iG9FJAn8iRzHdw5mUIB0cBw==
X-Received: by 2002:a05:600c:4f02:b0:459:ddad:a3a3 with SMTP id 5b1f17b1804b1-45a25d5f37dmr66229165e9.25.1755523092684;
        Mon, 18 Aug 2025 06:18:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9431sm13351453f8f.40.2025.08.18.06.18.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 06:18:12 -0700 (PDT)
Message-ID: <092a4ef3-c97c-4a94-b857-a443fb5f8568@redhat.com>
Date: Mon, 18 Aug 2025 15:18:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: remove write_cache_pages
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 linux-bcachefs@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20250818061017.1526853-1-hch@lst.de>
 <20250818061017.1526853-4-hch@lst.de>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250818061017.1526853-4-hch@lst.de>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1cx9ZizvGzQDwqmhs--iKsoUghP0RDDh2eyXGERH4bE_1755523093
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 65BDA120010
X-Stat-Signature: fcjwf86dt7kddy5me75xuk7whunzzgfb
X-Rspam-User: 
X-HE-Tag: 1755523096-955674
X-HE-Meta: U2FsdGVkX1/4JKNr8G0F4AugZPYXlMfVppotYByqZFTxynNcUD+Vfu9FchvigA9waBCZCNKIHPvSvCOd9jCv4MTQbtWqz/wUFuM7i5DzDWxyOOm4l9GBp7YDSW6/2ImhMzcnt4JLjGqJGTGY1c4JywSZBPYoYfxlsLfjhBd1F51X+RA2SF6DGVn9mdqblRe28u0MGkpvsje9Itp0lc8PcJZ+9bFvdxNzgEmugBH8ADL34QOuGfiutXgJIiOZI7nxEr6RbyesBRynEgR52kbvFzj/tpTRd/5FTx/Qb5xzgQyL4Abdp5/sdMRxAPw28gXLh4EaPLTGaHKXrbWojoDOv84iBfVDLCVWZWohwiwr+GQCJP/BUDB3KgQ6yO46iCp39mBe1/xWSCR3CTgpcqgul7qLcOvZUxTLA/gUz6qom+95zl8G6QJVHc0Npy6qWX+wyHAHjMkh7IvuCxYReCKvqhqvUfvgUQ1tSstwrCTIdk+gAksk4s+GB+z+tvLxozxI9K+iCdY2wJHfHh7+Po19PtI9nm+lBXGU3LqRv3mWQroI4m/E13agoMyh/y6Kve/8Xl/ZLqfyWiE89dA3iRSuVLCusFh8126/ZoRikIu6bQYF7qDYkXXeY73IfMCAJnn8TQrDJ/DxnSlKsi+chbeD0ICfp2DTPdYoqLeiAxDa6Gl4o9bFgzhhz7Yq1Z5oQPesN4kmd3f5iQHavmA3tm/4nFc3FCuZ8ioHgrZ23nbTNAmqLXP9snE8VkvbO6fXroLEd5ZwGu1BvMEgh8T5gzYQa0RFI/P3xo1N0HLVhb0YqxdTYgkppUaQZryUuc30d34sSjlJbbgy9YrIt6gQyGYszjWZ5kypGw6ZekyH89SMQZY1mazeoWMuqcsOJYguzxSqCqCvoyvvQVvAwEfdIojAkjbFBG02ltDl4mi+GflQl6o4fSPglgpDeKnl+NFpNvdy4fY3Rs1u0va5UNJZi8y
 jJfNsFc6
 2hF7vVKJWul9LFLCn3cykMAklyBsjqWdOljMA/Zny3ibn37q9UJHJa8rv2LqeS5oyyinxA+pt1sPgNiPTNvNFo2bBIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.25 08:10, Christoph Hellwig wrote:
> No users left.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


