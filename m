Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1120CCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49BC48E0021; Tue, 30 Sep 2025 06:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44CC58E0002; Tue, 30 Sep 2025 06:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B448E0021; Tue, 30 Sep 2025 06:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 204F08E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:18:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD92F11AA5E
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:18:48 +0000 (UTC)
X-FDA: 83945517936.06.8B4A6F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 792A61C000A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:18:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MHCLxdEk;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759227526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGQmqTN9UVzJt5VlxNDbtC1eGMpZyThEwsqWNCnufmI=;
	b=Oa//EzvI1UsI1mX4jorg1m9Xx055hCDmethEuuflldxS47xy4NIJAxhAKAuiNSHM5/Manv
	PLCx86DBX6VEePFgHN6oSD9G/rRuechK8IUhBVXFrRgByu/XttvDSXoqZCIqrTbxe/rux3
	+apvH7jy3szXwlrMCHQwRf7CkZvfwn0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MHCLxdEk;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759227526; a=rsa-sha256;
	cv=none;
	b=PP5lGsN/AF9djKqicLL98TT83GfazM/CoNJC7aSE7b8tpVddevM7O0uJbAForwglrYqeUQ
	7I/cI968sD7KBKURehucNrTgoPB4glnicJcyL0oT0ag/xtJXzRmLnHFIEGI2QsqfauoqGK
	JJ7z8fWWvBxFYhebvgRgmewx7bmh0sI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759227525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SGQmqTN9UVzJt5VlxNDbtC1eGMpZyThEwsqWNCnufmI=;
	b=MHCLxdEkg6U6JXKqEWrnkfNO+978XpcUHXXhwZMMtMQ+0T+gjqHCfWPP3cACqzum/ud0ln
	wcHmg48BEbkJYvYPKMoU84AG3CV3w9KKfUoW9vv8NXEKm7BHWWmS62fejyx7QCUinBT/BI
	vQvW7G2G5hKX7jwO9d/08KRudaJTIOU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-p5ddC2hlPS6FC0kyY24BvQ-1; Tue, 30 Sep 2025 06:18:42 -0400
X-MC-Unique: p5ddC2hlPS6FC0kyY24BvQ-1
X-Mimecast-MFC-AGG-ID: p5ddC2hlPS6FC0kyY24BvQ_1759227521
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46b303f6c9cso41418935e9.2
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:18:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759227521; x=1759832321;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SGQmqTN9UVzJt5VlxNDbtC1eGMpZyThEwsqWNCnufmI=;
        b=sij2nu5T5xQjBgBpcofhm4Eglx04Dj17KoLJJzto3GPgXjrhiExXdYTkAByjKzw59g
         V2+6kug9gsDQNqqDjZYW7Qou/l7sym2Lg2cB12mqoLBm/BNMoIPbUVfOMBfP7XjX8/f9
         ZgsaezKNdMRc8Lp5dDXpacNCHiU4hbzULULl4LRcYxTyIEu01OQmzG/n2pHQsfX//HD5
         +eECHeS3cmUq8AOMDso4ZhZJ/Xfh7vmnyHDZt3F4GcAsLKdEr3eIkSUSG9xRnpnY+9xG
         GH+PzlmaQ/CwCnuFt+yAm+VmYw/Nar4MnxdOGz38TC3aY+rSrOXh8PoWcm/PCWcZvWN0
         gohw==
X-Forwarded-Encrypted: i=1; AJvYcCWR2SMY5uxzdx+7bcQblnYRbhJZUWa8YqSzXFxNhcYk9ewzlsAUldvtCiX7TTeXwJmeSrt9vkiBbw==@kvack.org
X-Gm-Message-State: AOJu0YwqvaurMzIQEEf/thOXH4ukuLgtqvKDOYLeSsqBnfLg7XWoix5e
	k3bQ9ol+MuLJqIdw7TWcCPWybGCWivit6U0nseBNEvYh4PmtD3znSY0Tux1+khTZFvV+ueXy0Yu
	nWeHTQWMbTsw+aNkDvDBreI7qzf9vzq2zgHtHVZpwRtyA7fRGgckS
X-Gm-Gg: ASbGncuqezLtITJcIIWJjlfHvnNUXUPX0nX41vPAZCKM/JytUDdFgNA+l1EGtxyyc1J
	WA60KqlWjTVjSGq8PpBqDyNFSU4FVriPsPnMf9VVoddqWGNhE6LtGLNJt78tkbxy2zAUPBpaPF5
	WKN+/rKZxxLhwZK23LUDOqOsqtZaajMzdFpBmygnuK2/Fu/uaf9wc62ya3C01DmMxdp9AXJFYh/
	Fx1uqhh2ClG8M5n/BLS/L+Ij/narEw6X/vya3BX2x26jhCf6WS1C6eKUPJVLXfdIp3/yQV2rd8k
	3ijuPwujP5Fj2slUDgVOqWEfH8jC9MJa7uPuTMetfgkvynNOtZ+bghZ1MX3bBeNRRZ0BPHsIvk+
	vOvmwArzp
X-Received: by 2002:a05:600c:3145:b0:46c:d6ed:2311 with SMTP id 5b1f17b1804b1-46e329f9d06mr159524645e9.19.1759227521251;
        Tue, 30 Sep 2025 03:18:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFznNgdi9tc1XwBIaCPvR9T1IUai6bfy8CZ4nfYKaSegh3zkEHoAxrSeANzdq09JMiPpJO5fg==
X-Received: by 2002:a05:600c:3145:b0:46c:d6ed:2311 with SMTP id 5b1f17b1804b1-46e329f9d06mr159524365e9.19.1759227520813;
        Tue, 30 Sep 2025 03:18:40 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f64d06sm48925495e9.12.2025.09.30.03.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 03:18:40 -0700 (PDT)
Message-ID: <186ef2e5-bd0a-46e1-a88d-2fc5448c1c72@redhat.com>
Date: Tue, 30 Sep 2025 12:18:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
To: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Axel Rasmussen <axelrasmussen@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, James Houghton <jthoughton@google.com>,
 Nikita Kalyazin <kalyazin@amazon.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrea Arcangeli <aarcange@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
 Suren Baghdasaryan <surenb@google.com>
References: <20250926211650.525109-1-peterx@redhat.com>
 <20250926211650.525109-2-peterx@redhat.com>
 <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com>
 <aNur9nbdnlykqbU7@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNur9nbdnlykqbU7@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F1C0SZU__gqPNKtT02gQj0xkuFvJNql-fSZy-dw1l_I_1759227521
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 792A61C000A
X-Stat-Signature: m4755hsee3g8zdd5bk9sd7qu3fq4rrf7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759227526-373206
X-HE-Meta: U2FsdGVkX1/jP9RCiOLkSluV0ggFY/fDU4J574VCcNL/A+SrH6tGTmVDiy2iJSVpydXFgjpyqaeVMcI/rZWlnm9i6C0srAX0VvX5F5r4tgzzaNZAah7xVxivgjaXgHUA/zCLtWY3ibTXZR+FY64fYy8HgEm1vCyc86XLR14me5qGYwegSzaP0o+tqUKP1Qj/57WGn2+YUCr7VjnQDFN3kKwIX4pI3Bhr23ZglY1tLWdYgYE7yfNMq/kCCpEwlMEYgz/Gz9zuui/FWQwi7QHAJpryAA26qHaHN77X9DDQ3ZXovkesZg/IboeYygN2Q+kpFMRgle7SP0Eatht1hm98vO5Wr6DEQGk0D9mLrG7JRTDjlnXuWEFXzDKyLFy7GgmxROuS90Lr+WvhB22fzhdrVy9YxVMK0aZDIk7gf9eihO1nKklIhzkFvOXbcjoNF2uZwWZVlBt4skSq6v43NzLOxD/LtnNjsHK8k2qk0+eu3rYg3NXlTDD8mxbV7fhFWpmf4Q3/zSKHMSxhcQEyt+Knu3wAqZsZV69XPX1AwqInLg4YPT/WT3R6bn0gNgSHNyyiHPEVVYAy4U+gQQWwD3L4vZCkjOXguPO8PnroLci5O6KDJxnci2VHgAiByykfeEHY0cFkLItzPEZSeqct0j513cJDLM7OhGlPQ51gdNUgRfl5pcQNteAuwIKaUYIy9Kw2kx+Yv6mts10aI/GMN+teRvmKhIUplPi0PXTg9CDyQsOyqYswMhyd1v1cfzIvJPQh+cc6gRycAOYUjWWdIghKp720dJrGaDIKbepar9DJMDBiFxbPlrgz6G+wNE2arpmQp2RssSZvP5Q0B1mZBUplzqFQ2fs40yxWjPwVRo7/v8vWIHVH0cTlcTMH4DZ7cxPCHC1x9SwYknVNd/FbuNoUBgzUyLJ1werdNUbD8+SJni8TXu0Yx6ZBXToJ2sx01kdLkwr/wVFsJ88aDU+o7TE
 w+mYQGu2
 2sTAW4bjL/lludHwEISskuopqlxEdbpMSJhiI39WbM5m/gwupgZKHve03s/N5KH9faW1BpOpVhFYX+hvnwhccLmbQweGIH/4LS2Mv96V93ocz+yhxtusWF2rkWatVQ+7dq6it3k/kOaPyW5ygNtSzZeVsDiE9V8wcEATINOU02XAkgD5SNJ/dx/5TugacyVEqfc1pDd3+EBn7Ov5sTXNjzHBjNDRy0J0iU2AVgNwVF/XklsFP7Bj4E+uP6XotMbUypZ+hJ0hjsz2rVpcdvXwT5hKJN71TK4RMYcjpYnmmVGC6JcSimnR4PKBRbno8QW91x61XfFuVYYVS06Jz3L6gbX+tr4hJve3hGlLzKH7vkyugw8ZBC0zSdQjZZ6OBapuImZXDpFUruEN0fagVnelyQqQoLlZF9OTDtFQCcxh5rGNR8ncGdXwgCfvFddZUhuoTBUOqb8UZUlRw6LsvFWlCPYgwoCQ0k930XbjHPm6jRSxNw6mrFnFjhPMMRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.09.25 12:07, Mike Rapoport wrote:
> On Tue, Sep 30, 2025 at 11:36:53AM +0200, David Hildenbrand wrote:
>> On 26.09.25 23:16, Peter Xu wrote:
>>> +	/**
>>> +	 * uffd_get_folio: Handler to resolve UFFDIO_CONTINUE request.
>>
>> Just wondering if we could incorporate the "continue" / "minor" aspect into
>> the callback name.
>>
>> uffd_minor_get_folio / uffd_continue_get_folio
>>
>> Or do you see use of that callback in the context of other uffd features?
> 
> If someone picks the gauntlet of refactoring the loop in mcopy_atomic()
> we'd need a similar callback for uffd copy. And as I see it it would be
> different enough to warrant emphasizing minor/continue in the name here.
> 
> I also think we can drop uffd_ prefix for the callback, as it's called as
> uffd_ops->get_folio() or whatever it's be called.

Agreed. I got annoyed yesterday when typing vma->vm_mm often enough 
(vma->mm! ).

-- 
Cheers

David / dhildenb


