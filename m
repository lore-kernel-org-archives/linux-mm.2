Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F5EACA0FFD
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 14:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8CAB8E0006; Fri, 29 Aug 2025 10:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63AB8E0001; Fri, 29 Aug 2025 10:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952428E0006; Fri, 29 Aug 2025 10:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 846DA8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:41:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4DDFE5B07F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:41:19 +0000 (UTC)
X-FDA: 83830057878.25.0A3E348
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5096818000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:41:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DxlbUizh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756478477; a=rsa-sha256;
	cv=none;
	b=qQYvGVFJDCLBfIugJ4eJR2vy91bihTRWWIi8Fmwyx5+X1XHR2f3KVF4Bn1AsDiApjBZuta
	IIlsBZuXrW3iWIIKVoU9wquoeVWVUkHFMMT1g+hIJXHDWtL3ICuM4iS7G/DJySTRu2IGXf
	8TUpD7hGcMzgvGYwQRiGsuwi7fukMzY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DxlbUizh;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756478476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IaQHZcwb14XTWilYbwjP6AKy4Qvx/cjgmhYjWqgMQRs=;
	b=FZNBaf+jHEZRA4hGCcZvcJdMPaJGHT93eqJTifwIlEW5K4iVj56+kWAbB5TABe3KgwYQw5
	Bpcs7rtrjpYe8vAg9bNI/FRgz3Hu24Tr+mf0TWmDGuBk7fKk9zYm2VmiQ6GSJ4nLH+UgM9
	F8Whyl/lTQ0ly8gzvknNm5vamUA8brM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756478475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IaQHZcwb14XTWilYbwjP6AKy4Qvx/cjgmhYjWqgMQRs=;
	b=DxlbUizhCB5BawKdtayUbZmKjwLNqyd5gybpB35feX3Y3ofc5PK006dkMcsh+WQJXlO3Ux
	Qh+WZm9hXmA9ld0gTCQ4XL9p4n23gQlWBf9Z6SB0mPBB8zKmjiJZulijjd0b9j3pF6xR9y
	zBv9r9VRUel4kLJcABjpOTMf5YsSlIA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-yuwjkcPgMT-tAqFFke2Qhg-1; Fri, 29 Aug 2025 10:41:14 -0400
X-MC-Unique: yuwjkcPgMT-tAqFFke2Qhg-1
X-Mimecast-MFC-AGG-ID: yuwjkcPgMT-tAqFFke2Qhg_1756478473
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b83ae1717so2083085e9.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:41:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478473; x=1757083273;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IaQHZcwb14XTWilYbwjP6AKy4Qvx/cjgmhYjWqgMQRs=;
        b=Uog/A2JJkkyFGXeBSgfnAaATKBfcb30XWpYAazpt8MUZDjShO0CbfsGw00Uuu/gjOE
         J6vdiiNQDDtuwZk3RUdTpudiAzQ9FjJK3Y1xyEVlOR5gqmvP8Xxt9Hx6x5hgx8owAyu9
         kRsAJEX6ntpA5SC4DbiKREnIoHOMtF/ewIKjorLKwhOSP/F6GFBn1s/ItcZCYeV52TgF
         6EiG9AJhACdPRXYCOoCmAADfuV/ENKt7ZB1wIDff6n5RmXsKh6ARsaQ0F1+oXLerT5Q5
         te7Vy7qkj8heSFQXTMxcv4qiK1mBNSwOU7pX+r3DLcQ8DEdudlv7QjSNNqAvkUQ3j77m
         dcMA==
X-Forwarded-Encrypted: i=1; AJvYcCXZksEyAZS7Pz1Iz71VZo9M7oeAm6y7YfM9XXJuKfhnryhno/8I5Q+fX1GgsxXF3iD+lHefp0uhsw==@kvack.org
X-Gm-Message-State: AOJu0Yy6mVKkU+rdRnV2BN7Yf3yerMw9gERF0ewfviysQH2Pu7GaFoM2
	qeeFxSCf+26jLN334nKKfnSvrhfYRGoVk7l1ymd0LGDVuTvPxsQKN2YCApuwe52DZra++yhevuw
	nyDYo/q3ffAPHn/I9C4vCMLYznqXlUn3ckc8NGRyFMbpAka7ELGCD
X-Gm-Gg: ASbGncubJUxeUdKLnjkdfHie/jykbTJAEg6h5rdG6jQ4eJrN54tB7ZRzVmuBUhCRyaI
	dmo2mNd9gvbokqoBSzFn/uIVrUidn+vSvLgWVxFvk13LLrBEpVx9XS3zrZE1iuQg4YQb3AEqfDt
	hGTZ8QTG5OuM/x/S+rXV0CwpXdn1AUj/k8daofQXZsC71DZ8gTN2IgfbZ3+Xml1F1zc6t+UXBJK
	6m2GibgGeFN82y9j3GNvHWiUXnJN3xXua6OSTZkg9wcuK7cPd5Ca6fQyHOS208zLk2xv4NbobVM
	25LxNtkZqSZFXzoc4HDL3GU7j2EtjDWzqiEhpMxk4hKm1jBh945O4vIml4CCiGWojpnrkQPiUWk
	2Ypwc/gRf5XyD5aBYlg5r9iItClsKwNtE+QmlifCK6IRnnJui8lOtwN6vr6UI6Q00
X-Received: by 2002:a05:600c:3b1d:b0:45b:80ff:58f7 with SMTP id 5b1f17b1804b1-45b80ff5a3emr17032715e9.36.1756478472654;
        Fri, 29 Aug 2025 07:41:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxRGXosrm3vEArUqUEmQe7+Z1YlIMaqjbXRbohfYu21MGvBWlOrWQFqI2M9QmqW3L3NnKwrg==
X-Received: by 2002:a05:600c:3b1d:b0:45b:80ff:58f7 with SMTP id 5b1f17b1804b1-45b80ff5a3emr17032245e9.36.1756478471858;
        Fri, 29 Aug 2025 07:41:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b74950639sm95314275e9.17.2025.08.29.07.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 07:41:11 -0700 (PDT)
Message-ID: <4b053602-7c80-4ea4-8617-0f5e526c02f6@redhat.com>
Date: Fri, 29 Aug 2025 16:41:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 33/36] mm/gup: drop nth_page() usage in
 unpin_user_page_range_dirty_lock()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-34-david@redhat.com>
 <c9527014-9a29-48f4-8ca9-a6226f962c00@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c9527014-9a29-48f4-8ca9-a6226f962c00@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1og9VE_1VGDKhn3tZ4bRfkm9tg2vPVIOmLN8dD9DNyU_1756478473
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5096818000C
X-Stat-Signature: 843in37u93zikp6orj5edzuj6pq6ssqw
X-HE-Tag: 1756478476-630260
X-HE-Meta: U2FsdGVkX1+PYQqQZFnxGRowgeqkBW7ffAitYev2e3/o1/VlY6CaoW4cX634qEztvmWoc7u3vMu+BJicgR6YkWnK9ZhLpwgRDb9nl8bnVDb8tYPLz+/4whnISGS3TwLXwmyOS+oblyDg/9v2qjJH8uSygSZ518Q7VSzl7/IBGqeOB+cT7Jk9NL0eZW38/r1V9d2ouJ8KvS3kh8TcIz8FQE+N8ipXhcQlUuj0JMI+LcTdyGs0DCrZwtkPnRk0aO9cRiiShBDebPZ0PgeVUnVoq8jP+eTZogf4xtF2YbQj7hHLzwXHpLm4cEPosfdVKlCIH75cVnxCKltHBehhoDv1dVgq2LtxWUA3UbowAZPKQbatg/9t/lLfOaBHkzXyKYrj4lHisA7szflLsSWpmoHbjq1nDCkCAh/C52qYiHYwK0LXSDH6c4vjdWWZcrNl3kjuigqOo9Z0vhK+Amy8i4MWX0ZjmV6ev5x0mOkKrkd89ituUUGctw6+3tX61FJT5QvrnGiTZJw/EjL49Afr/niiwZMsEc174O2F1jSOcAtFGCS0whv+2RERJjGWjA4wcI+wYg50MMp7nuXj1vYNXEZeGRC8LbffBMldDysB5NkN7k8q9lXRPORcRzf3/A9DZcOMma9EU2omlDduKhzm7uMa3GkDkdCFOg0L2yiKzWN0T0fENcZ0fzT3Bf9XiSy5cZw/qt71lfFIXP98wzx598bv/J/q7fv21gsrKUndYxEp8eK4NlG51mT/J434737D3nJKEHy0z8qfbd2DSWOACqkSmIRSDH+slyAQlWypJzD3+vxmlo73aKRpGCEdFfce1SHoq3NYhzdDwZIX2nANzqOCXfg1ARRvdvj4TKuX8A7Dk6YkkJOaW8eFCFHkAVyeJvlXLfg44FQ0isiVSOBsK0OyD3264LL4ov1WImffpMliI5HYVLD1b4RFGYcdf1gQMieb/+6QUTQ8ArdPENJY4d7
 LlJrHENs
 FcYwPpbOJ/mFJFv+4fL1vGI8VBKpIEsL5As4EoGZqYFjLU36lx0K0E3xvW2bwdkD1TeXLtgXHp2aoDI258PtIsOqvUdBbVskg90IscZgpA5RuEboA7GO1YcLB6zqQrznDGDSNCH7Fze4vKf6WkXbzC8rFYLkWivrnEVLxP5mP4F8z97FkUXiFo3HW8fcx4V2mmRy5adLN6gUjFaHXdyhWMHW43FLAcHZJjJjqy9sKVRBIx8czy5ZZqXF4fosNJZifBkTOxqFCYadiBWHY+xoOXOQzYJ7qUeG1nS5vi94zXQuDVzW6nkS1FXh7gvHJNoJ9E8qeGhau7+dcg4ZRudCPBPWdEVzz/scljL2PtwpnTAiQC/jHreWZuC/gvmx3XoWfZPbUz94g5eeZNf/nM+GduZvLoiuPsp2ko+5HkvNOAPP+msAkPK7G0FTiYMML3kBH+uk8bHwmJF3gASrGgfWAI3rj9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 20:09, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:37AM +0200, David Hildenbrand wrote:
>> There is the concern that unpin_user_page_range_dirty_lock() might do
>> some weird merging of PFN ranges -- either now or in the future -- such
>> that PFN range is contiguous but the page range might not be.
>>
>> Let's sanity-check for that and drop the nth_page() usage.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> Seems one user uses SG and the other is IOMMU and in each instance you'd
> expect physical contiguity (maybe Jason G. or somebody else more familiar
> with these uses can also chime in).

Right, and I added the sanity-check so we can identify and fix any such 
wrong merging of ranges.

Thanks!

-- 
Cheers

David / dhildenb


