Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF20CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 20:11:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C1A8E0002; Mon,  8 Sep 2025 16:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60D358E0001; Mon,  8 Sep 2025 16:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB108E0002; Mon,  8 Sep 2025 16:11:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D9F58E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:11:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE16E1DCEE2
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:11:10 +0000 (UTC)
X-FDA: 83867177100.12.AB1CCDB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8C0BC100003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:11:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OJrnN7PO;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757362268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTJ+HCVpQQhD4Z+sGAn0il4Y4FIJa+bkJg1ouzoR6YU=;
	b=BpFY7AmyTNvN4OBZmWbtRVBmUN9aI9v5n2jnR9hU817JCo4kf1f3Dp6p8mCrkwG789QBii
	Z6k0g/vxLNreTfeKNGe2EN6xnXn/xwCQHSY6S9vx4V/RvAfpIJFov4sAG+iWrC4C39CPyw
	pR1ZczPBWPwtBwtl86a1If0gNSnyha4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OJrnN7PO;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757362268; a=rsa-sha256;
	cv=none;
	b=3SwF8VdThanQRmcxiGYImgGLv4WHlNIaoIngxH7nb4uAr5pbgkoKGhc+sL1nxmCp2suATs
	eaqDjT2OPp8XNjmK9rDbVceXHLVDzN1Qz7WwgHp9I4jGS8bzAjn9bGrW5IV5E6HOkBB4Hc
	aoPKAmX3KDmZ17yEwAJdwkwz0nT9WO4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757362268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yTJ+HCVpQQhD4Z+sGAn0il4Y4FIJa+bkJg1ouzoR6YU=;
	b=OJrnN7POVLAvqki6Dth1ovFQWFcu4Ln3KXyciT7oVO5nG3NEVQKHOfwexxnO45xYXdQtTs
	MRaZ5gAqvtTAQhk1+5bGCKruadDlCkTiw9D+WW8A3JJ/CehKK89GGMu5mgUC1cmnDufxlg
	G7+WMIsRFZc62fi8J19hbiw9dXt2xnE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-572-np9hn2YIMESplrsGvIW86g-1; Mon, 08 Sep 2025 16:11:04 -0400
X-MC-Unique: np9hn2YIMESplrsGvIW86g-1
X-Mimecast-MFC-AGG-ID: np9hn2YIMESplrsGvIW86g_1757362263
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45cb4f23156so26139525e9.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 13:11:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757362263; x=1757967063;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yTJ+HCVpQQhD4Z+sGAn0il4Y4FIJa+bkJg1ouzoR6YU=;
        b=kRSZBvWJrgLYcGtoGXR4F7Zk0gv391ApTXTElNUIXCiQo/NCcXMnB2jWKuK5UdjkOa
         y1RqZQ7fL4xV/eiiuCisZtMci8KOHDWWN1iE15UvH8RDj7zthjCEY92XRp+YFwnmbm9m
         TrH4GuC5LWizN92Q1SdgTbZgiY3LjvlELEixYB57bvib+ze4TiQHalcJ+8rOSGo90+mj
         VxGDMgx4/E2ksTriZvWHghrq7IRAPkTLRBetnNxBQOFnd9Dy8ODKTV5JzVQuVV0ysmkP
         7wzoRdqmvxMDu17SEQer8uK7k+3jw0b64raM1dN5God5R+yEyst9VgHU5RO4G8MVicPC
         xxrg==
X-Forwarded-Encrypted: i=1; AJvYcCXNSw8fMixb056kHJNZHDH3vk+aUne/mxJ9FHGKZAtnOAZ9U0OAHJhHqqSvf1vUthLvDiimwv9nfA==@kvack.org
X-Gm-Message-State: AOJu0YzMmkP9YLFJOnuXXDchIL+vJYjDHpJykpELo6la55WdEzgBQ/0m
	Q035G/GF0Lrz8htFizjcTOasXBmH2Pq7rLWoHmVqjS0+HxbwI1WagibBwtoXQHxprwyih4xOS6P
	JANxhvbewAMRCiYaDK2LbjWNBXkpeXj3V7vGlbUjsoATYPBtonKVu
X-Gm-Gg: ASbGncsJEEaVmmbSq5bNB0q2KU5KXmsdnU3/LJlA7zJoDMYxm8n+oyaQmK0bqFWDJ3P
	nJEnV6DsFkGajdCZQoR3HZugaNcpC9/Ap2uG3pW7ivjFr1dGgwpSDcTv3tzNvZOkVpWxLxrDNDk
	JmjSwzR2BDNkNzQ50Hg09eHrG4T+vfEhTTN4rYnh0ldANhezLYN0ENyLRoWXZi+pFz0MDx371GG
	l7XikV+Qf0bMArlx5Z4lT5FNp0BqC4CorBAjCLfCvDJwR4ZwMxxbDuCOHfpr++QFajxiNLrb8FF
	E1siwfy1c80ox7ZplNXtDsnvmZa7vdEA8t+hGpSdI5eGN2/4bq8I4+W4bF5Y8ZLA24n3XRE=
X-Received: by 2002:a05:6000:178e:b0:3ce:a06e:f24e with SMTP id ffacd0b85a97d-3e64c87e0a1mr5862443f8f.52.1757362263255;
        Mon, 08 Sep 2025 13:11:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmoGWcHGRU2wMNj3AUaA3ve3GL1XOR+7OoKa6K12F32smmVG8lX2G5M5jqlg7p8BKffe6Vzg==
X-Received: by 2002:a05:6000:178e:b0:3ce:a06e:f24e with SMTP id ffacd0b85a97d-3e64c87e0a1mr5862413f8f.52.1757362262811;
        Mon, 08 Sep 2025 13:11:02 -0700 (PDT)
Received: from [192.168.3.141] (p57a1ae98.dip0.t-ipconnect.de. [87.161.174.152])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d978ab6fc7sm27761353f8f.45.2025.09.08.13.11.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 13:11:02 -0700 (PDT)
Message-ID: <be8580b1-38cb-49a4-a916-95c9289059be@redhat.com>
Date: Mon, 8 Sep 2025 22:11:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] mm: folio_may_be_cached() unless folio_test_large()
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>,
 Shivank Garg <shivankg@amd.com>, Matthew Wilcox <willy@infradead.org>,
 Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
 Alexander Krabler <Alexander.Krabler@kuka.com>, Ge Yang
 <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>,
 Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
 <861c061c-51cd-b940-49df-9f55e1fee2c8@google.com>
 <7fe2380f-a83e-4a9e-8c5e-8459c9af0d5f@redhat.com>
 <7113d289-fb8e-4589-7eb5-1f7139965ade@google.com>
 <3f76748b-8f99-4e63-ba39-adadc2f58838@redhat.com>
 <2ba8984b-8818-2a7f-7544-4c5fce3e0878@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <2ba8984b-8818-2a7f-7544-4c5fce3e0878@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VFassEQsRhcSAHRhnYt8HWmNAgj3fVaFp_eWcbEYnRU_1757362263
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8C0BC100003
X-Stat-Signature: wccdscwuh3bdqmihff3qf3uxrmbuo6gy
X-HE-Tag: 1757362268-320489
X-HE-Meta: U2FsdGVkX1+HdzndY9pkPjz6vFxydH9WB08wn/GC7lc7z5nK+tfUM1wxiIZ0jBteWuCA7DANqxeMBfH+/6ufBIFg2wCNC4M341+OWNzFWAFG02AWYPoRwbiE0fG7yWt3rj23HySeNJEkHzDuHxpCbMZ0WLLT04dyUlhK3YkCyfss0r/26A46xNxUY8HUZBCAcbS0qA+H1tvUpHyJJ6BmpH29V2IrqnnPlNwUml6fkh1yubgq/5OrsEaUREK8c+FcxmAJ30iiP5sFITVgthRmJ4m/3kgmKvZyrLgdJr7pfF/gMQc5E0/GTHTOOss3wR2IQeYn4KFK7d5Mb1zcuL5LDZUKxjvY0CYfF8ySKI6/DnxkjWJJ3rx21iVBzFkJJOswAR9Tqo3WVNwBlLvd+HqnuWcoDhhr+4Xf5tFfIeDM9PcqNlLQVs9OEwAaIaMdKqP030cpO3oDrLHS89Mw4UN/H92Qc9uSw8J8KBYrNTo5Ul6Wu6t2KszYJnzrOjF4ylyERsox8B1asucbJZ3UfZMrbSKEbLegPsw/5+Ph21aJyk8+J/pM+n60W4+WRMz/uQV/n1sCeCF/W+MA5K8lDJKFb1Gab66Kdsg4lA/NH6TLrnVUOrbAdccUuwchRP8UyjkCfIoL6L07kOK9JNuJ4assJYqDfC/atmOu/OkvxxLPRHzChrylsWXCLeg2WplhXoBRZgswWSc1hzFjLIY0yWq1fA+w+gfVDzxeB9fCLOWwPFsmzkUoMmSjBDt25Zpk3galn2HGJ7Cy8d3RsXfmxyWAMY+gxgNlYBHr5fsJAcUXKV4XXPZRJ17R0jIknBh+0UCV9xs5bKZQKO7f204/OZVqoHjBmuAb0Wd6FKnsUONrpYnvqOI6zn6ZxJdGEBfI8MY2PPaEXdB10I3kRDNXGdB+QaEeYN+E7wgDz6PuoIz3tqhsmaLEoUWygzKGvs79ZxY1kRKENdxG9p8r5LfVUnj
 GzNJDxea
 EnsjI+Y5fRoeJJPvEIYkHvbUPHEdhwIzS/BjKJWN7YzQ0UUNoiK7cjj958WbAlsiXhm9BMCjALc7F7yzE1CLl3igQLit5yhbWgiNmpept+oAmNiMLVpywg6yPMSoIDnpkKx9QNEby1piuJSt/kZGDSu/5saPzZnyOyBqh9BFX8kmWozS97RigP49ZRFlEQtH3mrwvIZRdzWoOvDyHn8cH+ha4HXewP8GtdV/vbAdaJrj/EBeuKYhT1L/0AN1gp6wxxeLvgjAzoOPEyZCjleGJ3YjQzQPCVTzfjQFi6+UDec8yD+8PowdiktcmYjMIDyl4WOuZpfct3QBb8Jj4Q76NscMZ9D+UPUaU+hOHbfMGj1PhPaV6iRU95BuXHoghwaA2bRc7BOZuhgZ8NLG4Kvt7Nz69RR0mV9x2fydTygs7xtsKs0z19C3zBqKWDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 22:04, Hugh Dickins wrote:
> On Mon, 8 Sep 2025, David Hildenbrand wrote:
>> On 08.09.25 13:19, Hugh Dickins wrote:
> ...
>>>
>>> (Settimg aside that I've never perceived those pagevecs/batches as a
>>> "cache"; but lru_cache_disable() gave us that terminology, and we've
>>> gone with the flow ever since.  lru_add_drain() would be better named
>>> lru_cache_drain() now, I've always got hung up on "adding a drain".)
>>
>> Yeah, the terminology is not that intuitive :)
>>
>> Not sure if using "batched" instead of "cached" might be clearer long-term?
>>
>>>
>>> "may be" rather than "maybe" was intentional: perhaps too subtle,
>>> but to a native speaker it neatly expresses both the "we can do this"
>>> and "might this have been done" cases.
>>
>> I would wish we could find something that also non-native speakers can
>> immediately understand ;)
>>
>> "may_get_lru_cached" / "may_get_lru_batched"?
>>
>> /me could not even phrase it in German properly
>>
>>>
>>> kernel-doc?  I don't think so, this is very much an mm-internal
>>> matter, and I don't care for the way kernel-doc forces us towards
>>> boilerplate ("@folio: The folio.") rather than helpful comment.
>>
>> So a comment that this is an internal helper might be nice. Or we just move it
>> straight to mm/internal.h ?
> 
> mm/internal.h, where we hide things (GFP_RECLAIM_MASK etc!) that belong
> elsewhere?  No thanks.

Yes, or other mm-internal helpers that actually belong there. Like 
folio_raw_mapping() or folio_nr_pages_mapped().

> 
> David, I think you're over-thinking this: I'm coming to regret not just
> going with your excellent folio_test_large() optimization, and let
> someone else mess around with the naming.

Please don't feel like I'm pushing to hard here. If you feel the current 
naming is fine and for some reason I don't completely understand it 
should not be in mm/internal.h, all good.

-- 
Cheers

David / dhildenb


