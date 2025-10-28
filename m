Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F230ACCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C92280172; Tue, 28 Oct 2025 12:06:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579EA8013F; Tue, 28 Oct 2025 12:06:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468E180172; Tue, 28 Oct 2025 12:06:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 34CAA8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:06:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5E6D13B110
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:06:29 +0000 (UTC)
X-FDA: 84048000498.22.ABEA4C7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3AB368000B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:06:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BI6Oyx+O;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761667587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fEiTV8vRb6ThfDpOr4lY+uCNfpmz0C8bm6VrusAPB8=;
	b=ZGrLCphOFbyVyPotuusIeOJBGEBIHp6errAdZdsNYgJC2wc0STwU4/9CccS0yo/Oc83Dnv
	xt8rzGvU/IOQTfVdE6mjs+ZCjaFlLQJsAH5VFeHXF8obHYTsmwrxGEc0bgQ53Kb8KGHe79
	UrssuBjynpMpLXsfpkaVTbun5+BlsFY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BI6Oyx+O;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761667587; a=rsa-sha256;
	cv=none;
	b=htQ+XS+8d+6DH7IGFNu3YL6/RHdQoIKaAbHortHXDl8W9VkhpLxQ95fYkHp3eZTiW6dzB0
	Y19h3Y/FLMj6xr/y6z3hmJW2MogXuILsCPvXiQxzGMxIXDMZvG0ppIWYbjreJLdg0FCGGS
	CZMJ8SUQH67vMW2zX2XHIx5YNmmNYAM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761667586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7fEiTV8vRb6ThfDpOr4lY+uCNfpmz0C8bm6VrusAPB8=;
	b=BI6Oyx+OfhabXhkBY4FiABlRGffeDDssJSTgwHbO+shLCf/bWK0VHicrsaJN8ohv/agZ+V
	1/jTFDyqFrl6GgWvfq68Kvn7nQZuA2JAUpXuHJw2H1SFeD4X0x+A4MCWLmAYnYT4Q/LKvW
	LyQ6T1yjhi0T7wXD8ibEv9M7cQ0C/PM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-5QrENtdbO4qYL5kNWiMzHQ-1; Tue, 28 Oct 2025 12:06:20 -0400
X-MC-Unique: 5QrENtdbO4qYL5kNWiMzHQ-1
X-Mimecast-MFC-AGG-ID: 5QrENtdbO4qYL5kNWiMzHQ_1761667579
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4770c37331fso17136485e9.3
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:06:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761667579; x=1762272379;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7fEiTV8vRb6ThfDpOr4lY+uCNfpmz0C8bm6VrusAPB8=;
        b=f8CD7X8wqvVPpLyj4Ik0Gcukkea882tUYzM76sJsVHtGnXY3/gzvFFDdadZkvYpH3K
         PnwfpdE32j/J0SZ3VvKfHJRH8s4K9EI9bmUBummPQ6wehpAvXhLHQGg9oErPDRD9L351
         FiyQCkcRj9c5fD9vFwIbqHMS/OKxT5zK4kJL1RbmWnRWI0KhhiLJ5Awzmn5DGMkW7uue
         ozCEnKRN+nD78+IdeXqvHNvwmLj3glfWa4H+0ME2WzWdqcstOav9Q6oE/yWksiac0WMx
         3ox1K3bhajpcR+xLyWRYJ4er+bLlLMVLdUxGljqQQCOGuYK8wwNp0AHCSRP6F9Bq68IR
         CjPg==
X-Forwarded-Encrypted: i=1; AJvYcCXZ34sOfkdGE4swNC2xdJbhFgKxj1zLHdtD97dxFnyiucPr3mfoucxGhYbnOKf3cKI0iM1qw9VK4Q==@kvack.org
X-Gm-Message-State: AOJu0YwqZzjDuu9pFiaJMPOX/xmQmFskoLCq9fCwbE25OBdD/p02GVD2
	CnNGV3mrUXdg5pq4X/VZPdwFESJbdC6MfKNn6DKK9749TWzhHWOd7A/lAL432tXFLQJhj/vuWwG
	xmUPSEa/SWj1v2IjBC+pEAsG0BGlIM7bsuq/mDCWoNhB4EPjbY1jz
X-Gm-Gg: ASbGncvSX8lmn1DZY6kEAH+SOc2Jt1r7V3u0UP1u5ZNgHvWGa3WB2XbOXgEcJ+uzLNZ
	AyToBII28W+SH46VITYYQVfBsMWzmdacNbuyFIY02HzXphDsFjVnb6huJ6umxlySXraQnSFL2SB
	gyfM2XQZmmdJkWdC7UnCO6Op6SX3Zey7Cbb1jA4CpzkKrK52SeZFxk7uVDMIo7rVXf3k0R2lon9
	w143/8A6HZRcLOFwPUY/G+gMlLeKXK74w2A4Tqwao0Amr5kVjZpkPc2QUjrKwpFYk+SNxcr8dFi
	kR8ndhpMvnnOvYE6CmFoH9DDraPPSBWqAX0tuFDknLBPn0jKl9N2XU4T/qyRLn6tRMwQKglUbQq
	s/NBzZQODtc6Urs5v1jEMvLWFIOGKzlGp
X-Received: by 2002:a05:600c:3510:b0:46f:b42e:e394 with SMTP id 5b1f17b1804b1-47717e7a904mr28298515e9.41.1761667579318;
        Tue, 28 Oct 2025 09:06:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXT5BB0dlLpX7heAZB79STVaY/doPErnydPItM+XhQvOUsNw5gcKnIBB8PLR6EDjE/Vkd2kw==
X-Received: by 2002:a05:600c:3510:b0:46f:b42e:e394 with SMTP id 5b1f17b1804b1-47717e7a904mr28298285e9.41.1761667578841;
        Tue, 28 Oct 2025 09:06:18 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dd4a36easm204397805e9.10.2025.10.28.09.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 09:06:18 -0700 (PDT)
Message-ID: <b40b7eb6-4e15-475b-9a74-c3ca1560fd38@redhat.com>
Date: Tue, 28 Oct 2025 17:06:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
To: Omar Sandoval <osandov@osandov.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Israel Batista <linux@israelbatista.dev.br>, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-debuggers@vger.kernel.org
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
 <811fd675-b231-45e4-b9d5-636fe63bde6b@redhat.com>
 <aP-2x314BKks2_N9@telecaster>
 <3d3bfa52-3e13-4d23-8ef7-6cb8b1ab7d79@lucifer.local>
 <aQABhaMC8xfO2Vem@telecaster>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aQABhaMC8xfO2Vem@telecaster>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R46-NaW1biTtMNhXdJr9J2PN-Iw5vQYOkAVk9nvYZXs_1761667579
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AB368000B
X-Rspamd-Server: rspam03
X-Stat-Signature: q397foiz9juuqx5kd8gfcr69exe6h8ax
X-HE-Tag: 1761667587-764197
X-HE-Meta: U2FsdGVkX1/80o4tJo3IXZ2T1OuucoEBrPv0NR87bPV8jQ0D+G9IKwXiifmnpunGh9t/akHzOrPccUWiAw6rSYteRkL8eNmlgo7oOVTlzmni6HYN2fo3eUEycGOEtA95yOXn7isV44Kmy2qkQsmwsu/TlHhDDXM5ihU8axK3Qo7SIt8IpZvpK/8iysAGo7icskJyoyg2DoFRWisU2Rb0YsdfcOcAyIFayn863KPmbE/0Kd7sG9qcVw9W5GG/WzxAaXkdeYBXWIoWGPmmBTZy7cGfjfqYrX63H7zLQM1k5urUyK2c2JyzctebS24kNpr9ceG0xjmzQOzJmAHoe4c4BP+xDGACeZTAwKmtx22/Z4Ec4EdmMw+w5mAL8syG1oJ30QgbyYX5DV05z2u2lLh/Wdtd84M9Y6kJqnQqbrcnGONK39RKoyknmnE3zPR1afn47VKsiI7JvUVtmygdjwQRm39abMefDjFHHGrzxnuHT91izvXROtz5ToMmbyS2CmY78psoNAg6am7vIBMl87t2ypIcA76VK6Q4eOk7JXR3oSnfNoEPk+9aFFi7pNoVT0rbM+Fo/GgO/z77GnByKqVwF+fwiHi0upsnkKWDMSlfiQme+FNObP5RBM1L2M17PR/XMBmkHIxvCt7U93adENdCjzTjoHixjVmeWctpZXKtR21ympApJ3zB7uJilqS8TY8+M49rvkXClkWURXVoMGR1nDb1/XSWtqD3x9eV/+PTIHmK+q40aJoW5nk4FqobZbu59JRg8MhE9hiprjeIqE8/lMU7DFgGDNtwrKH56FB11GTLeyoDyc/0g8qO6ZPHNCahgFwAIUYph4vIDfmaKPhLCApWkW1Fs8hyekU/ks7K+hPU0zdYbclrtL/vu9MsuP/WtgiD8C7pZi2xcHXouBcB1RWtn5O+F5Sikr7xY93dmOAeLpVozcflUn5mUiHYTGjiwcvIHKfxA+FUOGheIUo
 EgA+rXGA
 cyK8tm6qVtjJQCfARGxc5M1DJBXzAwGTR01uiQu0Qwu3HgAZgZTOshZY4GQJPB4gkxvVJgzWTdM6uk1O/qWZ39nkWj694auJU27CjHmXBlxyh5b9QWTO5ejtoie3s5iTLCF8TFpD/AIewXiGD0oXmABZRRQXz4v6jiXED8+0tmcL7O6G4OJJJsMNbml5YIfYQz++010LFZrtdt0VtsvAFOYTwVOQzxalFBTi3k/CoOHy+4O0dkOwroPGq7FuXI/pt61/SscNhwB2Mt2Pq8UYhOkxBzY564nXkhepdBDjTFQJpBFZlMbOgDu0NWUzrsZcaVS8qCIhHZLOBkj/Jg1XShF11DgdSDupmTMXFe5/xDrnDtQgbNMhl6mgF3yvZ0s+26a1kdslc9gEU+Pl4x89WKJAO8Tw5itL3zbbbpkiQ4KYTP9m1R0dp1x6oAziA0rKcCd95MKoVoVTct5p+1tKEorh5W6m6yJ/zYoLqnJaShmjnYZvsyjePwiPrbLf3pzgyrPJSrOmM4t9VqsC+SPUGWvVMQfiZ38iTQsMdlfZ5sZfp9y//zGMGrU13ppsDwLOoSLSCTUrGDeggsYdswcUShGbcEotUczgVueSo8TrO5d8VlwLBYGeW/QMy4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I read
> https://lore.kernel.org/all/809f552d-3282-4746-ba49-066d2bd8d44f@lucifer.local/
> ("it's not valid to have flag values as an enum") as a claim that this
> was invalid at the language level, but it sounds like your objection is
> more of a personal style preference. Which is totally fine, the MM
> subsystem can have whatever rules it wants.
> 
> To play devil's advocate, using a named enum for flags makes it easy to
> document what flags are used for a given field

A current best practice for flags is to use a __bitwise typedef. That 
way, sparse will be able to make sure that people are not using other 
random values.

We don't make use of that everywhere yet, of course. FOLL_ flags are 
still wrapped in an enum, for example.

-- 
Cheers

David / dhildenb


