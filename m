Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A401CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 12:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6009B8E00A5; Sat,  1 Nov 2025 08:15:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7A18E0068; Sat,  1 Nov 2025 08:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6D78E00A5; Sat,  1 Nov 2025 08:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37EBD8E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 08:15:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C07D288FC0
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:15:04 +0000 (UTC)
X-FDA: 84061932528.23.F7AC8DA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6E2E38000F
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:15:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fKZuXQk8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761999302; a=rsa-sha256;
	cv=none;
	b=Wc8l0Z0dGM1iofAxw2JMDmt2cRMLGtN4DyY2M/chhjxpYjdROl/4pFaca0dpMP76FVhuid
	JrCt34jJrUrSAGfQD+SqqaE01LZYMG3SkbZtqS8e3RqaRr6pk6VbQU2W7tiNzCoRKb225o
	z5n6G5O77uFcdz3egqAFPmyMmGFbjj8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fKZuXQk8;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761999302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wcrewv7OssaEm3gyvMk1iF/ClvQjL5UKQAK3UbLbS48=;
	b=nlCHLYY+0vvRzy4KY2se+gFmk1/aIkjrXLQT5A6xQpC9iqbP4bHsfdH7BftR9m25jLmCJV
	WB9okg70ZZdc1B0BL9vKKK6fQjt7QzVcXQmEPYgzLP92ZmThSXSF30/f5wDKkjicN0XHJ7
	LxLp0PUgZmLsnmSvWITwx+QLPMPyGM8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761999301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Wcrewv7OssaEm3gyvMk1iF/ClvQjL5UKQAK3UbLbS48=;
	b=fKZuXQk8rqZJ/qIysx25x3joyBTIxbXB8XcPFi4J9N2Yj5njYHqulAOsRv8iz09dipV9LP
	4J9HT7fN3PKAnu21VyLqhJLDFlpJyFJf3Yp6Vc4owm6inAA4ysdfUEsA8Ofo6Xkz/qsUjo
	GDmy51tKmV2b5sYfro/FmAi3rEkEG3w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-QCWBZeH7PhigvZuixicRvQ-1; Sat, 01 Nov 2025 08:14:59 -0400
X-MC-Unique: QCWBZeH7PhigvZuixicRvQ-1
X-Mimecast-MFC-AGG-ID: QCWBZeH7PhigvZuixicRvQ_1761999298
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477212937eeso22902155e9.2
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 05:14:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761999298; x=1762604098;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wcrewv7OssaEm3gyvMk1iF/ClvQjL5UKQAK3UbLbS48=;
        b=WNftoww8znxBEU8vPzejm0O+aZOJDgiwlVGcgau1m7CDnxvjfsWf/eGPWlYLtxXRBw
         2VgSlmGgtR3Qojq2FZM9HdgNaVJ7pBEDzw92gT+KFMCkaLWU6xgw91DZkZdYawcjVK7z
         y+Zvy6IdumCFteOoCkAsSBSi9RE3bAQnBs/w5fbMlWCadWXTNpywiv6dXE0l8x4QAocv
         2xPmht+j9G3NXyKxJtGU/DMaXZwzQnWEMREpsb/LuKvCemsQ7v2mFO78bA8MKJ2YgAy+
         TjVyokpN9AwCyVwjPq1wiTQmnK7e7RdfWu9aNXxyltKEr4v9i9hbSJyPTh/3G9Ml/RzY
         f4jg==
X-Forwarded-Encrypted: i=1; AJvYcCUPoTPTpgQdMTC1EjQ/7dnsxpzB4lBvodEOd/932W8oL3Tewkz5MAdoidJROWatGxNtf5iuSz2G7Q==@kvack.org
X-Gm-Message-State: AOJu0Yxw1n0n1Ma21+JGiVsFKyRkoTInFlklNJJbYa1whZD5ChIiQy+Y
	9WGBBTm6R+Oal04uAg/W+/AbKSdUDuumqLEkL9LWcP5w5WKhPIVF+6l+oQSxXFqJbRy7wZ3NDOC
	luromk1CbkNtwBLz98cm2vOYDF6PdD+j5RsyO4YFck9KDogcwx6u4
X-Gm-Gg: ASbGnct8acb2FHnIyEWgpBKGRZ7numeWSjCnYtwmnhjdtibDdegVmB5Ty+e7A6XTA6x
	EkVYEMxYuGG7/GIbWsCWgMbFgMw7LTvWawKbwASgq6obTFzBRSZ5BKGaKCTHpojL5JjOxy7z4Jv
	/Aj75Cnp9BMKHZweePemer/+w8A02WqA4Vb0P2I0B99XDS8E3fw2QZnSCf/ZJx5k4Q13JlRZ7sy
	78Yb2EQhPw78/1JV/PP6aVq7vuoa9WP8W/RR4va5fM8fxYabGmrf5xRQZMpf5UtiQ7y/aojTzvO
	dR12cB63IAGMJwrr7JLiG3xhABclg3ZxxAv/rT4I13PANJwOKZE55Ze9brUzNwSfzk5gnjVsGyT
	loE/WWrIExvo/SsximV+vCgE65UVOTHXjKY7LpaDI9QsEbCxgCTHhHyJplWiyzRzFiu0/OExLIt
	tmwDcpjvIgkTVJ6GpiJIMsCH2KoYI=
X-Received: by 2002:a05:600c:64c5:b0:46e:37a7:48d1 with SMTP id 5b1f17b1804b1-477308aad21mr78192295e9.34.1761999298486;
        Sat, 01 Nov 2025 05:14:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpoAFpg0euM+1PM4mK/KRSGv+bWD5NPrehon1oy/C0JEyB0MU730bCFNURR8O9btag493PXg==
X-Received: by 2002:a05:600c:64c5:b0:46e:37a7:48d1 with SMTP id 5b1f17b1804b1-477308aad21mr78192025e9.34.1761999298113;
        Sat, 01 Nov 2025 05:14:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c9737830sm2218179f8f.16.2025.11.01.05.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Nov 2025 05:14:57 -0700 (PDT)
Message-ID: <15f832f9-b95d-4b08-8467-21a27cbf8450@redhat.com>
Date: Sat, 1 Nov 2025 13:14:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/12] sparc/mm: implement arch_flush_lazy_mmu_mode()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-5-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251029100909.3381140-5-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uTNVOnE71cYqs1wJA2fSwt8ykqWkQo0amS7n40ZL-ds_1761999298
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6E2E38000F
X-Stat-Signature: ykekg6km391axe5oh7zdu3ei5tg9qwkc
X-HE-Tag: 1761999302-441846
X-HE-Meta: U2FsdGVkX1/V8X6WcBwiEg/qW9/Ve74NVcfPkmnbVEsgqX49CqZJB45REeyqRYCDxSRnMPn07lc+XwN2p7BHBrMWop+6VkNXt+9MJADQKjHK85IToecmeo5sQ/kpFk6diTX2f9QuPPvIieM/40kbwlwYxhlZQyB6SESBE2zQYlHqtQPn+N4LVFP+uosv0Q6DmIN6ecNx6cfnreYXnlAD9yrwUjAFPzXYE10UGe0uZQb29innx9jt5NZwGL07QS9i7XQPD11eeLMUCeRo8ORBGQ7K/OcgGg/tpU+uRs4PPorZp35QBmuQqwl3VDfdocjL7Z6+KCLwpwUrF43FLT3ZmhO2OUyLEvmYVE8tXBoMUs2ICA7qiJiCBzrx+Lxqyc0Noc4dFg5fu7IOFTcCYpvcCzL//jAMzqfYKKxeGSYA6eFDfFf4gtXIciKl9fsWqR9tU585IMGmQ6Hg5/NVqH89fL/bX7IuNSplon8R1A2wLs4NkRTKee7t+ViDJzFYEtQmebL/82mUflvAjRQ2E8DC13AFm+Ktfys0j0fqxgd95OSWJXl4k7QfU5ngKJsAl2jGw9hIBrVL0N3pte4xKgKQcDljH1yk0urEndO1nNp4cCPax5mONI2BX6VFfwg8MTiDRqMb5IsHS43SZKhb8q1/G6GWUO/Oi8R8Q+RwDWRLvkMlGKESRUGfoImONZoz8ywcGEVEvOKBHMZgSRGjV9jkWfIbOzrYisucQD37qpflnXGcKtRnDZIp1sD6HErLt7n2QhVGDvIKjW2pdYtkeYrTW5udWUNP6HAWsu1Ir1U0pZDwtqrL1Ly5fKxY1oEosadKTPjUZRt0OBNZAt7u9ePJJ3hLRB8e9Z0kGNxpTRebD81ZmBS2VjFoO57QdN0p8Srkeoq0yA9VQJg1XGaHiHx/gDTKt8HS3Mnr/5dl0Y9+cVxU343j1LKKS/MG6HTCrgJ/VFohf7Oq7rAJCA3ErFh
 wEEj0i6B
 JmuMgqI+ZFRXRy4+Wc1mS89/okMPVe1FZfCmp9scvI7PYeWkT0w7z8vzVdezrpuUO0bzZMrWOXh6pzGgLO0ZY3+ebqDns7AW25Jqj5IiJminGIHVyc6d3bjVqL5jYYxJRAdzUu412P4mYQYU2JcJqQF45n5+3fVg9Ckc6sJuxBSlkYY8S9AZBCN9J8Z/oRiZFnQuizZ200xH6Q/d2u0YnNhmwlecclwX76PUyM+gazA06c9GpFukLEddnEFPIrE+YSvK4rnFS9GleWlaWj9eV9NHtq3SfAWduGVfCKk/8vJtc4R+BVoaT5oS6yC8zDl84uQjj0SxgkvhYRkL86mferlI/ywM2Q0T5Pcyobfo2G7Q6CndPz8qx+Iohx8ZCIqQMHIvVlH2w0p1b+TBuHm4HPGPHAi1fF4LvN7h7rt6KiXzNZibrnPVI+1hqjWmM3kFa1o6YqerSzw+Y0dVGzlwASBqQ1BYXTlPCCFIJ0zFXlkgkclaHuk7eChaP70BNil6GJgSIaBWDSmv58qXyzs/OfCNMobJdR4BHJdUSiQ4T0UDtUU/hW6WDKwTzAnk6nkk31HcdsQcRYM/CWr1B6CTzXBwozFvCEXXzMuBxViZMt7zi4Sha0mA/XXnpU7kv7M+LMv9WZ9Sti1ifzqI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 11:09, Kevin Brodsky wrote:
> Upcoming changes to the lazy_mmu API will cause
> arch_flush_lazy_mmu_mode() to be called when leaving a nested
> lazy_mmu section.
> 
> Move the relevant logic from arch_leave_lazy_mmu_mode() to
> arch_flush_lazy_mmu_mode() and have the former call the latter.
> 
> Note: the additional this_cpu_ptr() on the
> arch_leave_lazy_mmu_mode() path will be removed in a subsequent
> patch.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


