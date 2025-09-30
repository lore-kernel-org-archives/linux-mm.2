Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7489FCCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 09:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1EF58E0012; Tue, 30 Sep 2025 05:57:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF61F8E0002; Tue, 30 Sep 2025 05:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C388E0012; Tue, 30 Sep 2025 05:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AEE5C8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:57:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51F9111AA7B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:57:39 +0000 (UTC)
X-FDA: 83945464638.27.FB899D4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id DF835180007
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:57:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NXaJqXdQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759226257; a=rsa-sha256;
	cv=none;
	b=m5tvbi7/+roViLiipRQtF0HwuDUerHUdl/kqqed0T+eQddkGa43M/ehe/ICWreha0qTs0J
	iLqPBn20wJ9xzX49q+Jw0EkkXsUR85LrxyyHIpwhh+oGIy0u0h/l4Hj8Hsm7qC8z5k762c
	/luG0UruCGcoZgjoUWORTE7NLvR2/1k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NXaJqXdQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759226257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGDV0OWQM6iGYWe561Tqua3XYwXhvKGNAbiZWMTbw6A=;
	b=agz7KqyWEEoVLC4lQAJEI23IauVgWotC01Q2Oq09xUexFEE1IyNaA6BI0twdJgkuDT0AD+
	PDnjjmT8hFWuojdG3tF5PtjXbLEbuzv1bBFdjPhlGsgy1w0Le6VoZixKSc42o/5LtQYrSO
	9WjreUsRLOnfnFxel9rn/0oanBcMvA4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759226256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BGDV0OWQM6iGYWe561Tqua3XYwXhvKGNAbiZWMTbw6A=;
	b=NXaJqXdQ0RFaqYJwEsZFpuIob0A1jYPvLYAnBGs21mldrsIj4NJ0avK2xBKdDKfOP0ThsU
	qsJsgJ4Wy8ELLCc5qAbEKQCN20aRUWdFTLILRrfcW1pKO6+JmiPv28lRUHYE9jhlpHyLb0
	tgnMZayROWyf0Q2k5TU+sXu6sNk4sV4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-tuvH3MZUPcyKRK--iGpgRw-1; Tue, 30 Sep 2025 05:57:34 -0400
X-MC-Unique: tuvH3MZUPcyKRK--iGpgRw-1
X-Mimecast-MFC-AGG-ID: tuvH3MZUPcyKRK--iGpgRw_1759226253
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e407c600eso23924085e9.3
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:57:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759226253; x=1759831053;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BGDV0OWQM6iGYWe561Tqua3XYwXhvKGNAbiZWMTbw6A=;
        b=UDIHZtM9nH0mWsgEiukr10Sa4gOBS8QZ+9mDvcpXXjrvx+qw6sPJX7faKETeFR2yzi
         wC25BiRaxjElm7rk+VGZXX1MBBtpT5WsouomKsF8pd0+hRHgTjkZJa6O8lKxKoS8qpm7
         E0xFxw0bQ+D3bAhj/rUmbp9mfv5VRrCdbzFud+EGNXOeWsccuRR5OQI7vUA6fy7t9rGB
         XIx7qvGDZh06/OV0sqQkgdfyD971ssUf/gbsk3g2T1pRH0CZBX8+68z/aEEeqqEOA2YS
         D22iqK89QW9Q1czXbroccrWAvgPm1DQ+7F/uVHHolEbKCHg9MqgUSCWKcFHOlrx4QoB7
         4G8g==
X-Forwarded-Encrypted: i=1; AJvYcCV1rcmg3vglDVvPhnkqWWQAlx8j0CW8YAtSqKvz8T3MkBmPAuBHNYsphCvtso3ZmDWYWO9GgZxp5w==@kvack.org
X-Gm-Message-State: AOJu0Yxe3u6hZupqHn2peSxMnkPOKLN1ySfTW+1asQmFpedsTh83fzxc
	XWCZn9c2NR4zmWCXiFp1CKeccnJtQUEihJ6gLuZ04Qtxw8QxoXzontSU3kjxFRAZrTB2okiSro0
	tJ1dWynEItbBPh4KHqQOFgJYCxfqNpAMNX8NofqQ0vifaqoy39AxU
X-Gm-Gg: ASbGnctsZo1vlj/CaGYIQyd6OEmmH/qvRUF9/nt/Zi4NP+svje5o+s0+Abi3CU0khGa
	lxOrrCUq5LqxNYXXzMqvGb3DZ0ZmO6aRl2pVYijK4P2yh3wD7/APNe74n0OmqB6/rzkIVlJACKx
	BezkvT8r/YsSHjitRU9VGIsuvjYjjvsA0I9MjSos4DWwAJyjIvm5RQOpMpgx1Ptsly80h84kVVw
	Rcd2V5rZwAs/ewyrildE6HDrMYT0R7rUyP5ZlN/AhHx+tpxoJTk5ayev3bhTcKXut7yKY/7DhUF
	EfMaSaTQKb8yoUbrpp9l/FMjg60bNY7HCqrainYdSi4d+tbOE8QKk95snrn13cR+BV5AoPCDRkW
	5D+7K7Elr
X-Received: by 2002:a05:600c:4fca:b0:46e:4ac4:b7b8 with SMTP id 5b1f17b1804b1-46e4ac4ba51mr123119685e9.25.1759226253367;
        Tue, 30 Sep 2025 02:57:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8Rl/Qb4ZrL8CaQmGgrGsko0skVn2UHu0+6ug/mAnkLMksTp3RhRLptPRlYk/Xs/2tN6bx4Q==
X-Received: by 2002:a05:600c:4fca:b0:46e:4ac4:b7b8 with SMTP id 5b1f17b1804b1-46e4ac4ba51mr123119425e9.25.1759226252944;
        Tue, 30 Sep 2025 02:57:32 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f536a3sm56995465e9.8.2025.09.30.02.57.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 02:57:32 -0700 (PDT)
Message-ID: <c925f44f-f0e8-42fa-94e6-24a02f9df28f@redhat.com>
Date: Tue, 30 Sep 2025 11:57:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/8] mm: hugetlb: optimize
 replace_free_hugepage_folios()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
 <20250918132000.1951232-3-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250918132000.1951232-3-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hpuVBHZLkqYGuTs1FD4k9WbGyAPNuMpD_kXzns8Pwqc_1759226253
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DF835180007
X-Stat-Signature: ndaw9d3w9xnidcie88cpha3q8r4i5sbn
X-Rspam-User: 
X-HE-Tag: 1759226256-807554
X-HE-Meta: U2FsdGVkX1+WBrxzq0TYKclXLBlfV3IAU3H2VVGtK6y+5cQksq5jnL0AN8QfaP70mqENtX5hPD6FD2rbKi8nhKGFJZQBhXVvJ+lklScHpUB2oaOn1XSIArqF2McKryPwACa70s5d1lMrTz9UquiCDv9V6mdvU56yIlxbG75ic7deI97AG/ZIY/bY3BSZedvRRovoqe3sYpcvr/AKQMTaQypQyw/iGJ1gYpcfCWBRG4xZrqB22RYezg3e2w+GRhjE/SStUWgvGrt5H4ufT5yXw43WYl295ogMpfD/LvcP1Twlb7gffF/niklWyJuLmQ122F0ybNGyMNCqdVCCS4T+T5IQ+6uyu/YIo1eajpPdrvtpizYDvfDl8V2VfAxzm7jOwIDZyUrAoGgy2O5abPAv7aX9wDObR4Gm1Yc4D+3yjBBQr+aatlbNi/gpyyLUa7qWi3Q2Ejy2Z1p3neAh+Z/1U1ZnpK67Vdfkx3ATki+LBJye9ic49lRENK744c+2m01yh+0d/7Fw4iqaHoIa9pZpnGHHoMd14yGh+0p+qEEjZ7SR6tkWb1A1kIrb0ecQcUXvMXdaCTZYjvv+1PnDLIzDmjx8JyJm2qqvS9jpzypAMfqrDw1NKMbIWog/D1QxvA3YYSa04vo0YTZVJl05Ah8SyOsPzhon8JLaUuFOJl5sS3XbtCB9GfDSVTvihSMCFny2cCEFf6r6GuWPfjm7l9yEAmMO+d0LciMnxFpl1FFu5PLUhR9IZCbhkSW/ZpmKV56PNSedT0rEHhCB0bMjG/OL7VbddA50x0dcgtPT2jlovHep9OcfR0nKBD3r3rUpGXbZW0mTkJ38qN1NS/Hx3jVpYwvFApVci8gAMxJkhXgNJsiRO8IRSsyvqqyEx5yg7CrHfsg9KLELCRUNwSjB9IrTFjyWk/52dBNdqTkzKjLVzL/CKTi1tNAzKmcZ6N0bZjOmy2mCvDYcf9aVTB4og7X
 r2V5vU+a
 WqTN/Pdlcb6yXP1s6JzdSq6RVZ4qLHxWYowJRkV767ZxvepM+JI0SmG7OStE0XZVNt7HCSmISk7rb6DLj5R6nyYQ/ZSiQdBrmV7PALq6aP0iUPYl1YchmKYTD1xbQjAAdBuFbLZF7xPlRjzyhhoaFyvbWBg7g8RS1/POzNxLwOAVOyWSMnXzdtVnFdCwhDfFNz8CQm5f17hgXrsUQKPLjJ+n1fVmOdRxKr/ER4xjrqaUe3CBrI1hjSmfIt1Z5J5dxOw2oiqfDoQRh9oGpmF8KIUnLj9kNbdZ73ajOMhx1y/q+RHqCZnLF7ZHsQqZ57FySirH393hUUQ5kjMnnt58rvDvofYRHV3yfFlKbNybKFCrbnTf8NzlWTIoWuqpTeKtKJp6xbP9oPBwWdaq5wmk52lqpaov4EdtO6C38r2wYvoa3/GcgpYzgTqb40w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 15:19, Kefeng Wang wrote:
> No need to replace free hugepage folios if no free hugetlb folios,
> we don't replace gigantic folio, so use isolate_or_dissolve_huge_folio(),
> also skip some pfn iterations for compound pages such as THP and
> non-compound high order buddy to save time.
> 
> A simple test on machine with 116G free memory, allocate 120 * 1G
> HugeTLB folios(107 successfully returned),
> 
>    time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> 
> Before: 0m0.602s
> After:  0m0.429s

Also this patch feels misplaced in this series. I suggest you send that 
out separately.

Or is there anything important that I am missing?

-- 
Cheers

David / dhildenb


