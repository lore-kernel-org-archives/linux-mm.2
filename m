Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C062DCAC592
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1753D8E0008; Thu, 11 Sep 2025 04:26:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126B58E0001; Thu, 11 Sep 2025 04:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08C88E0008; Thu, 11 Sep 2025 04:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D70C98E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:26:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DF87119DA8
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:26:07 +0000 (UTC)
X-FDA: 83876286774.22.B6C3DC2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1B02F140006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:26:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="c/C2YREc";
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757579165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7POuCru78kGApa5+fS0YJkwH7KPQQkXWv0CGmvzYVco=;
	b=YwkxpgToJdOuxaiwJt5+2J7mSu/6uClRhY1tqn9hdu0HezS0eWWl2B4LhXNVcOqxUcaZAN
	7ZOgBTXZ2X1JHSQ1EEGk9kUGM9kWNgCn3DpwHcKCRqS+Ex6PYTOlZVnuAz3m+l7vEfZtAl
	nHOqYiGxBnsDIqp8yiFZTWl3E0njAN8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="c/C2YREc";
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757579165; a=rsa-sha256;
	cv=none;
	b=zPmPpRRX8PJMS6TVt4BX8qUvo0QT8l0qNrA4FQzUOOKgIR9Cnnh4rsdX/+numWRPPXU0oU
	sLqKtOOykr45yDMYBk2eUUXgd4tyWpxycpQlqjeRGCmSKyIkC85hDp6glfoMO1S4DGCh+4
	E89RzGPe1FJuvbZSU3vgwWrp6W4SSwI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757579164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7POuCru78kGApa5+fS0YJkwH7KPQQkXWv0CGmvzYVco=;
	b=c/C2YREcIBIJyo1moc0huBmILagTioqmmT0JvMSRPQdTk76/CSM1K1JeS3W+Y6jUO6kPrc
	mX2okCiWaFqdIknIcTijImiX7Fqq5FO9dsQl8AoussdKmKdINVVv1RMKCHjuujET9i0NBg
	NFF5bEBOlbzdxMdU6H66Wkxrbvi9lGE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-i4WE1Mw5M6C15USa2zWXqg-1; Thu, 11 Sep 2025 04:26:02 -0400
X-MC-Unique: i4WE1Mw5M6C15USa2zWXqg-1
X-Mimecast-MFC-AGG-ID: i4WE1Mw5M6C15USa2zWXqg_1757579162
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b96c2f4ccso2886925e9.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:26:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757579162; x=1758183962;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7POuCru78kGApa5+fS0YJkwH7KPQQkXWv0CGmvzYVco=;
        b=IKqR0lWW5D4zDIZkPevZR9/Hf4r0MMO3YwwtBlsYk5zha5OisaNYmklMWxcG4RCHR8
         HJeE2z/lD4W6t3q1djC4eBCuwr1TuHDL1P/ogdaI38T9cJlnuIHBh2iF+GjdtCxUtZ1v
         qpHNbgXCXpvIDVFHbA+L6xDY0bO42vPviF6ranffau3chFNZaJvsJjY6UWHc5IZGrZPd
         9z5C/P0/1BHDHg7wjjdif59f7cj6UfFfKFcLkX4ve0y5k8HkMR2o9S61u3IkcuvbahZN
         TGLBUosw2sn/PXNchR1iCew5eM0/I6pcsfkAzVt4ca7dSLfPmb0V/88r0W4YR1w9ZtKY
         B3eg==
X-Forwarded-Encrypted: i=1; AJvYcCWdDC65nooC6TfZuYM3HLv7cI9b38C67c7cRRNqlpEa1zD6h4WpUFyaVtcHU+nRv9QYFP6qmtmFaA==@kvack.org
X-Gm-Message-State: AOJu0YzlPHB8YjeMYi9sbKosN8s5JNSy8i4eWz4/75CEKlFqgwWq9GlL
	fnowynenz8etwNXWUKz2UPHICqn3clY5zxuLwj432k9bxUERDWGzOQ1jz/XxDZgLiJQYr1nzheQ
	9D0ceNdB0p4Pu5soRfbQRqZT/gGwaOOryyjFZvD0/zDkJfE5YRZrW
X-Gm-Gg: ASbGncutBAK8wyjvWKCeNDga9FnfMBBlo1VKktc8645p7A+Xruq4FEwib4CapCpI/HF
	ezg66gBrNnfrk9BUwtNrag7Yo2SLbNnV8x8dRaC0n0dLeX3DApY02OTbos++tIU6zKvU7jS3FK9
	IzHbhuHCH9b4poO6NTcFmq2CNRvsB8GDyAs7T7NkLTxrxexkAf1717OoajQdjO8a7FItKKNaJAC
	/wbb/5x5mq/CTsKpNGC/GymdFzPPlXWy6IN87NtEStrH/7sBM/MYJOT17Dr3QVmdUdCqltcDIkm
	8hwDp1NL08qVRiG4NJdhuhL1ts6TytHMct53uygVPgXOlSZZJHWE+ykkMBwj5DuFtB8KVE/84S6
	VzoIZWo1mjXNILTDH3Wc+zaKvpQBUDK0a1XtqdEeABVEOPteGNDtczypBXyJt6JY53JQ=
X-Received: by 2002:a05:600c:548a:b0:45b:64bc:56ea with SMTP id 5b1f17b1804b1-45dddee9076mr150068515e9.23.1757579161688;
        Thu, 11 Sep 2025 01:26:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDuAwLOSj/s3Gqrh54fTzuC8p4LyTF13aJNMlKfkacx9a5R5buH5EBWGRUItr5LP0KM+SQog==
X-Received: by 2002:a05:600c:548a:b0:45b:64bc:56ea with SMTP id 5b1f17b1804b1-45dddee9076mr150068205e9.23.1757579161181;
        Thu, 11 Sep 2025 01:26:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760786c95sm1559703f8f.17.2025.09.11.01.25.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 01:26:00 -0700 (PDT)
Message-ID: <90e926c9-40cb-4791-8360-e3d145fe3503@redhat.com>
Date: Thu, 11 Sep 2025 10:25:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: 20250910133958.301467-1-wangkefeng.wang@huawei.com,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
 <20250911065659.617954-5-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250911065659.617954-5-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 13bwmUj8WtWGA7rzgqHKtW7eRr0tsCRYnOxwOfAtwsU_1757579162
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1B02F140006
X-Stat-Signature: tgesb3cchpow4czjgqduism8pcnxgj3m
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757579164-785645
X-HE-Meta: U2FsdGVkX18aOmHjciF+ApHa6u5d+tYj/NDgQJVsgRSEchHQGO3QbkwlxFwPAIlU6vsJeZ1WrfFtAJKtq0N2QR51izP1wDVeZoGtDaulhHS9s4XmlxmqaVJnpwfdbvtAe1U5jkzLGGhNJBjUbVkv20jTKshbJf1rC68qM8yJmATrM0JgY3IDHIWIXbWhoVnhDLNjbstyRKA3cQHQshMw4oBqd+0Qz4hVILsxlqRAKJTonZxDtQvFwMZarV9dHTKg+TN/5FZttMvcKGvYFgNpa+N7veRs98MsJbcUKXxl8fIv7Yov9vZwKfaRgsaNpCdrYISQc7Y+s0qQh/+FJlPXvFoYt61j2aOg/fg/+rphh+AApoAzEPIZQrioOjll8tO7OWTrQgBiZXaHWKtT5FmZau29Yb4cN19iwKm8iT6Pc9EMsstRGS5R62WTW7yan32LXBHu6vNjvUqXkHcNKT+GEGuDOFzJb1Fap5gWQ+VP38LtEcToJ8h1skgYTrM2fYfuNpmGzj7Kmb2/M+dlBhg627umz7F+u2Rj41zCHn5slbwlHTgrEdStw22Lhi5GcIoDMn4nkS4xNx+v+nK3u3y1NsbsgHXE/3w6sZXxNSqhRqwi61jscJ0W/iVuTGEhFNEBS284/VTHnJCI2eae03JDIf0nwLyLljB+nTOVz4i/G1x9VVK/M1TDUNqIQsboydVbiNb5QowV6MsitqyKwLWvJ3/xrgXbNLj0vfZXBIIu8scS6ZVVuLCMpRI6de2gl2OhOnvWFFGGGC+UsTiMIS923fCippYtHjn850mVhklAur59e0dCCRDd4H6YWKaJtI6o5WOjPiqAMn55D6qv/AFyhjXOeoX6pQXK2UxKMQ7dFvP1kqmAccu3XQFJZyIH02dPUngh1/3J8zTQSvwJRFJ/iyhGmtXjpwaq7i5abUqXNEuRdfuERyIfR/L4+zzlNikZlSeRH4QhAFCOjVOR7O3
 I+czT3yz
 IiANmX9XZVON4UddagAZGxRCNooafcaH70g86no5u9scoWmS3MzeE0tpFY/P59Cf0pafT6vy6MeuYOr0MHF00aFrBeZ1NTtOCDlzJV4ak7EJxi/mY5Qh7OUxiTJ2S6ZaEOj9jmeVS44Z0z8cc1Eke/ptws8DFF0VubHRsLieak0fKPKjGaatZtFTk3mJiyC5x5nukuF7yEQFY+770jdVIwZKLkNh95Qim0vEnQiu4Vk+YBxIn0imQdx6SkTrZmfxfBnhFQAj8iItcwTXgU8XtEpltqBAP7g7IsQtexeQRF6Vy1ClrdOWUrsV9k/xp/AuAxPlz7DekjMl0FLHBhgvBruyXQioeXaBBHMw/uRCuY7XS2pnrKWgEmMSeuDUGgk/82e7YFaEwf4kW3H3+ETzHFxJ0Cnn6vanP8JuN4dW+3VnBygJodWJ2mm/v+uyTU8AproFpXtcZJKJDb+fHpFA7/eqqqn/JfOF345Cv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.09.25 08:56, Kefeng Wang wrote:
> The alloc_gigantic_folio() allocates a folio by alloc_contig_range()
> with refcount increated and then freeze it, convert to allocate a frozen
> folio directly to remove the atomic operation about folio refcount, also
> saving atomic operation during __update_and_free_hugetlb_folio too.
> 
> Rename some functions to make them more self-explanatory,
> 
>    folio_alloc_gigantic            -> folio_alloc_frozen_gigantic
>    cma_{alloc,free}_folio          -> cma_{alloc,free}_frozen_folio
>    hugetlb_cma_{alloc,free}_folio  -> hugetlb_cma_{alloc,free}_frozen_folio

Can we just get rid of folio_alloc_frozen_gigantic?

Further, can we just get rid of cma_{alloc,free}_frozen_folio() as well 
and just let hugetlb use alloc_contig_range_frozen() etc?

Long term alloc_contig_range() should just return frozen pages.

-- 
Cheers

David / dhildenb


