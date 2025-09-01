Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72DB3CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA07D8E0017; Mon,  1 Sep 2025 04:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78398E0013; Mon,  1 Sep 2025 04:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67288E0017; Mon,  1 Sep 2025 04:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A14478E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:14:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 556A15AFBE
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:14:32 +0000 (UTC)
X-FDA: 83839969584.15.03C1FF6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 34EBD40004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:14:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DzOmPPQo;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756714470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rt8jifWvTRyr4vsSKdSgOrev+jQ7PqzJ8Xa1YWSeYxs=;
	b=1gIVcezQVvchoBzZFkmTkAApBhWxdjm7qouwlI/7kcEfdONTWHUSoM5eA6rf5H03Z8DiZf
	icana5roLFp1yD/FEiIvyJoS4wuJqaGp18FFWsaQLiLcgR6GA3PN7zZQcW0SRhQXKdEBbm
	hgvlxSrbrPdwKYpdfTJM8/lr9tgzQjc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DzOmPPQo;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756714470; a=rsa-sha256;
	cv=none;
	b=qzvu4F/gPZGv1rnFYqX99HHhaz7ilj0lME3Mgw5bOr0pN97SvClRc+54UuHoWCI93KXNAJ
	LSmXUgfKLCo87wN5N/EpFgHgXYzFaqty0hTT1RpEQ6KZB4eU4n72ZG2fwgPjY3R986BdTH
	xWMnLMTe6Cji4/WMPEzMn1QisM/MJ9I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756714469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rt8jifWvTRyr4vsSKdSgOrev+jQ7PqzJ8Xa1YWSeYxs=;
	b=DzOmPPQot2iijXduibNgEwu9WdFGKmmNQ6mO/R3Ie9r2r273V/t/CZa52o7YwL3vasRXrl
	7m7/uBR+NSuvOY/GP0ZXasPsTeiQopP8pyMGUrJ7WQUspzoytjzXl8doCq1S5gHOYTs4oY
	ON7VFNgbwE8S4eIymbzRiWG676rZMqw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-coKpqTOXNRmS6M4WNmlv4A-1; Mon, 01 Sep 2025 04:14:28 -0400
X-MC-Unique: coKpqTOXNRmS6M4WNmlv4A-1
X-Mimecast-MFC-AGG-ID: coKpqTOXNRmS6M4WNmlv4A_1756714467
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b8f4c2f7cso2794845e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:14:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756714467; x=1757319267;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rt8jifWvTRyr4vsSKdSgOrev+jQ7PqzJ8Xa1YWSeYxs=;
        b=w4HwoXlkdSlcg1UKeucFF7tGXBYSv1Mf0GQfmnVmMKJ1jmhg1jtTamEvdtStOA8nyK
         snDhsVQV4OijwIttbKBPuk74eXV1gazkrr5Wzqx4cBtFCsJ73dRXhgQrrGqq4rlw7U2B
         s/REGuMIaMyfGl3AgStHRBVBRIg7WxfNDIutLmHlUQmuZ2OVLWwbrn5Df7WQkQnMoNSW
         B5LMFrw+4KH1HmCBELaiJ7Px9gsQU8ePN/xiANKYsBTcCD2VvWcYP0UoxNg9BVQRCImn
         fB21EqKy8GlGeoLa8iYVGaE2OPXUGaPxPBxxn3Y7i6pblSynmgG5jbZ6HLQlG1zbf+Sh
         Zv2A==
X-Forwarded-Encrypted: i=1; AJvYcCVPwW7SM12ZTTLOvp1cBHY1PbuzbbOSqcPcWmK3r4AcLjUKXZienibZhX3IvmZJeTrUDTTEiBMEqQ==@kvack.org
X-Gm-Message-State: AOJu0Yw9dACLOrkqWS2ixuR9oLbaWa+G9YYtBeo0DgOJUQbkTXomLODd
	fVwojaQ/8T8GIRjdIKKM79U6kQThcTicDErSFTORSF7PzvBVV+VtUDEoOreQGv3XjXULBuD0pxM
	VE5JImSGCSuaHPcg2JEop6VEKZqqtp/3zy7/jmSJQEg1UWVtBbzEw
X-Gm-Gg: ASbGncvEgfoYCBUpOJsAcdbkcIzZxb2Bb77NRhRreMzXdDBSAOSZlsQR6gIZFFiH48w
	QNyFoMerON7JGqi4r/D71vZt2Q1jCQzjAKrKPo+epcXHfyFHVoMZPrkPl5WSx08BUkx5UY9Fw4u
	MNjd+sXXHIn4qpoUm7x3pi7u16t314o24/n0o0TRMM0SerxvEcA63L5v4rsMrOUhEFHdVLOKFWn
	2rupOewhTRSK34HG850zsP2ozi/PF8LD+SqBWhEfPclr713wGCtXfxZAwNBiL/bkU0guLtMlmVq
	72l9GL7WKmQ3SH1xjxD9bLRSAFs0WB8ecY6CnQOsgzC6YSiuAvsZG2sAdH3KaF0Cfru7/YiQ/Rv
	VuMCPZ+YzUlIuWkY5CrlcFpOOLM6BB1TGUqLkm4citNBOdr5bdq+tFdE6IKqDYt4AhMA=
X-Received: by 2002:a05:600c:4515:b0:45b:8078:b31d with SMTP id 5b1f17b1804b1-45b85525d8dmr54604195e9.6.1756714467217;
        Mon, 01 Sep 2025 01:14:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHY2ZV8vKP8gp9rZ4Bt5dPZvE5UAnieGuQUdLK3Xp9alJAsEPpspjx2UaDoV9WaTWqyGGHutg==
X-Received: by 2002:a05:600c:4515:b0:45b:8078:b31d with SMTP id 5b1f17b1804b1-45b85525d8dmr54603735e9.6.1756714466756;
        Mon, 01 Sep 2025 01:14:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb9d37sm14332236f8f.49.2025.09.01.01.14.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:14:25 -0700 (PDT)
Message-ID: <1177bac9-2dd9-4401-b168-2ccae850cadd@redhat.com>
Date: Mon, 1 Sep 2025 10:14:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] mm: lru_add_drain_all() do local lru_add_drain()
 first
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <will@kernel.org>, Shivank Garg <shivankg@amd.com>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>,
 Peter Xu <peterx@redhat.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
 Alexander Krabler <Alexander.Krabler@kuka.com>, Ge Yang
 <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>,
 Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
 <c50129a4-a07e-869e-604e-3952f8530316@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c50129a4-a07e-869e-604e-3952f8530316@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cMzu15_XEk9CXWyK_siRHKciutpIZA7FJ2AKCHJvSFw_1756714467
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 34EBD40004
X-Stat-Signature: qkj7fwo6kqeiee6bcdj9psszadm5rphp
X-Rspam-User: 
X-HE-Tag: 1756714470-927263
X-HE-Meta: U2FsdGVkX1+aZcvSQcMB5HS//0DLYEVsfhIWhDdTpNKoFIGCltT9h0w4DwdTJ4zsJlo2gQvYE6V53hpWXA9FDZXeuai10aDu3ZAJ0R1FpZjqcQQLux4uT+Q3gCrVJc9TbEFLkOZ9U+soIPGjjNbuxN7TUo3Xahj0KJpyaW+MUni7GD4vUmob7QZZtlVOFRmNYpUmI6BFPnzxFVYmHtgkWS7kBU15iGGeRN661IGEDZ4bxkrRruDZmktgy0lFnmBS7TykIotQNKU/pTxuDjG0MskmOV9YmDUYsZJL92eNUM24wps1TkggNswQFfUMADCx7HBKkQ0RMK5d/+K8NHA1y5tj0LYxJ4YxfLLO9dvpQ6N3k6pPspoVMiuBNp+ulglR9TDPJBVcJaP9n5QKaPMUEEdofHZI/nZKWvlfbDD7DoRFB3GeOqHKcZtYoY3Pz/zTZi5MLPSjQVS5r/tWDWmR++utDaqNLVPYeuBaUxWNHbZJBdQWnM28a4Es7ZEzikPz8YzFBU3F763hgkGb4ZqFW/Fg2Brlv/6Z2nAyebm/hMiWDrjq/9xZQvLcx307YbnyI2RZRZBOJzdF4OFwehV8YPQVXgM0D4KDxcw9lIXMbH1qXY7NiNXstzerKrPuNrpFJRuaF/xEsUPYk5afwvCE3VOoyg2JPKYZnl5d2W4KcoBf1loyNzwe7MGDaiWOohIjjsmJjL/ysLrwsA81eJpWryqLtAd1xz09n0ZDM7nHOki5IUBTA1HOCj3kEQ54W79C5xT+fUBKfZJh++DeLFS3/NLSw4WcilXgTqpvaWBobhO46QEqom9hlxCvoBS3FrL8VrWIX79zaCDMoPJ+tTBLbp5u64sO7+b5hs4jkI21A1xDsckqOrBi5VVTKtkUDP8Fr1ecMsKeuJkPDisTK+w9qUuG/+gkAXVQb/ooF+xH0x74bkdeyZSVuSKvW5ZeLs2wzc4tUx/b1k5D6O+Ld6B
 OoUdF83x
 540GcsGavf55nAzAen9OWQwZdxetkNCoyy+S75jfrctykw3P+j8Q1MQy0s7BHHZMFsApNSr0MmIklmrni5kzS27uM1fSLWWHHkdomM7J3mQA4gKhdkofMkWUAbAjT+H/H0+f6QfxXwINPYNuhK+DVegQDzRE3dWQP07Q3lpWTFs3w64B5ekOWD4puJiUzHbOkM/TbnzFEzFR0BKxBRnbaS8LuZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.08.25 11:18, Hugh Dickins wrote:
> No numbers to back this up, but it seemed obvious to me, that if there
> are competing lru_add_drain_all()ers, the work will be minimized if each
> flushes its own local queues before locking and doing cross-CPU drains.
> 

Sounds reasonable

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


