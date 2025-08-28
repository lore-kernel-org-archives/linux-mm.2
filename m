Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A3F1C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30EF18E0001; Thu, 28 Aug 2025 04:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297AF8E000B; Thu, 28 Aug 2025 04:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B0378E0001; Thu, 28 Aug 2025 04:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0051E8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:18:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA17885382
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:18:35 +0000 (UTC)
X-FDA: 83825464590.17.79A6D04
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id D405E80007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:18:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NSIekOtv;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756369113; a=rsa-sha256;
	cv=none;
	b=sm58iZeglpPr9Xub/A693gYPZsKwYZe/lfeulxQ/Lm4h53vK7r7zmVPzRmlMkZE/r/BZPW
	+wEGYTvx/Vy3dhS3UrDsr5LfaMOPpBoScsuBt3T86liP6NaJdLDtS7JiIb2Sv7URkeXxYz
	HlS4lNvf5JRgQ6horY81jj6LFf4eYEM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NSIekOtv;
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756369113;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CFlTc2o50xP7q9jUUn86Cat3HkUhlqoaXfvof6seHm8=;
	b=np1miQBx9uMEndHIyMd3uYsLjZh+j7wVix8vgpq8qQ21aapeYvyjDI/c1zANeYk1ihfCoQ
	DRJOYsEMw5E/p6yYqI1DCteTeC+hXlwRxCSLrEDPLeauUzZORmVdk51/gORdim1kSCmL+w
	mEDjAkA/xbFNnb3XBPbitecIGgCJg4E=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61c26f3cf6fso1138221a12.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756369112; x=1756973912; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CFlTc2o50xP7q9jUUn86Cat3HkUhlqoaXfvof6seHm8=;
        b=NSIekOtv3W27cl3y/yrzuDgugyJUCV+Ged8GJhF9UdE72VsqFbVw5ZhJ4BgrBodjbM
         Qjhy8L+zgv57giaxO/XFzx1nNjMkZFvRQibiSe6AUyDJclFxvSpVhHYAmeMvWOfqZxw/
         KtANP6hRI6FX9TIPHY0Ha/7gHre+MKEdVXYEb5NfqDm/jK0VfB3GiAQBFiFKREcg/pvw
         11vsmm8RzOnkf8UCaSRav42YJQH9LgH1wJmgLe0/32f64MSEz73RZyA3CPI1uHvUZfgo
         MXOmlnrwGENGbqECMWMVoj+c+0JfbxWv+Gr3FvTIz66s7x48raR1ZHL6GvcYjXHK7Mv1
         spCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756369112; x=1756973912;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CFlTc2o50xP7q9jUUn86Cat3HkUhlqoaXfvof6seHm8=;
        b=eTtNX2g5U07MgFJCkpzezrYt4K3S+rZb+zcUzmTc4Oy55OK3fOLd1iWnnkCW2vqAx7
         N2aKpo09peijHnClz9oRvvMS5VICyU9B2iTLMz0TVhg3lJxMhTNodQM31hQFKLNyCcBA
         lnR0E6VJcQh1E7WM/yzaqwKd8pKXDO2GQtTMlAvCob2VBXCmby9XZji5oWl/kgopio7j
         2Nvev7Wef/arH718yrh70hhOQkG6LgY+/GW8mtai+GVzDxVLtqv0J2c4ky0eCgobwW8X
         +zgCkvSaqyoFyebNO9Zge5WguMQFXXGxlz/UPE60Ed4NFYrbNv1YxGpiauhWKC51aL0q
         tdHA==
X-Forwarded-Encrypted: i=1; AJvYcCVZ8htcgyedp7M7l+i6yD9e26UA+5x8WtCkW73LCyIE0gJhcX4ejqa8Cmw76dV+8IbTQE9yUAazNQ==@kvack.org
X-Gm-Message-State: AOJu0YwNTKpwv71UuVkmdVe5CNF6NPT+4kymFu1biVkMyn//r1Ijy9HC
	nI6qQrJSXL4S4a+JAKs9oIlyrTmhyiFGbiHCLLfDfi7tVVgQwxpS0QSC
X-Gm-Gg: ASbGncvf/ur0SRzAKXWHnhsmnbxzq0o6tQ97q2SVpvs+eSrllK4uTuFiO6qhDNuq07Z
	iBbClAeDbfhP3WQwAlHa6RLpRZ0ty7dOOYqQTj4ficIk+1Tj2Carst2ZBn1ln5nO89UINmnNXi2
	CUz3akMC0lfIpqpkeUyeZWZFi2forzXKj4dOl3Eb6hwW6e62aI5ITLx9WuOFQ6QBkduhnse+oNf
	SsOjK5WM5MHSUN3JwYg4WwjymjNBv5PEymG7BPFZPLgiXPtgpppAPVq054WY5lLK0ytksfD0kX3
	mJKr/XtXye658/zzw/YqzFNxyhwf9URAIcKnhu5+zRGc++BP6e1nVC5+KJwSBqHVXUb//GgNDm6
	Wvgklg64/JZ07vQS4YSUkiaIEjGOJLdDXVaH1
X-Google-Smtp-Source: AGHT+IFrqyfe7g2Zl+sLgEHASy1+ip6WVy4aEpiIRxktJ8PetprRYIIgoW+xQR/WhySTtvxcEvhJTw==
X-Received: by 2002:a17:907:1c27:b0:afe:b878:a164 with SMTP id a640c23a62f3a-afeb878abecmr620398166b.50.1756369112172;
        Thu, 28 Aug 2025 01:18:32 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe80daceb5sm811531866b.68.2025.08.28.01.18.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 01:18:31 -0700 (PDT)
Date: Thu, 28 Aug 2025 08:18:31 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-kernel@vger.kernel.org,
	Zi Yan <ziy@nvidia.com>, Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 12/36] mm: simplify folio_page() and folio_page_idx()
Message-ID: <20250828081831.fv4bs77kihwbffdi@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-13-david@redhat.com>
 <20250828074356.3xiuqugokg36yuxw@master>
 <0e1c0fe1-4dd1-46dc-8ce8-a6bf6e4c3e80@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e1c0fe1-4dd1-46dc-8ce8-a6bf6e4c3e80@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D405E80007
X-Stat-Signature: esm8g9dijf1u3yzs8xmjjc3enhyfzkk5
X-Rspam-User: 
X-HE-Tag: 1756369113-925505
X-HE-Meta: U2FsdGVkX18hE+myBgA4E8n6u1N+rRlwlfuq/472NmIgN8U2BEa3b6vi3AE3s6PqJAVcDCyTASo+WsI4blztcPCXC+p50NN68R0Lb6qFJa7IiU6UA4eOFNNcpHdNvqcC1oDFJEAI3NGVw8qx90J9j2L+DyY9+wxN1GLG8F1grC0LDkCaJPQu2cAw0cTH2n4KMykeQRGXAohKdxL6jzhDo+/R4u5QxTTFs5Uo4vVuAGmQr0b4xCKBnacLGkjoBDPTu4A2t0r7EAwXB8AE3OQb7tnqEkABlEtAySHnSU1FAor1FPvAScaQ+X9/7N/oHXIJp1+nrca8MKvH24xt1Yx2cqviLcqk/4WzSV2bc93XrhuzgYk/5+ymxzj3O+/5KGpd+FnLVEk+AAAEKATsGOnd1fevN+3c+KL3oq1i94PkQ2I+DdBdPZmBBtjdpJvQwO22CFCyCWkJUpTt08KNqqR3YF0K9jATI1cKkY7Mb3X66fVhW6SJglrFdtv2NqWSGnr2EDCqqG4IxZ+ouZSnjLOPaB1m7tKmA9eCDKHJ525/gqFvQ0Je96wSCmvre1Qazz7wIsePaCqIBb9yHxiksvtSUtlNb8GT01ORJqqa1036kmTdHwvjdI9MeylKlRsaLy1BAiKf1IClegAujIvvRO43HBuK3zS8Bli13jZdZEoysFH66o7yC8kkvRyZYCLsDYbjRSQ4TXrHfSAGpV0s8ntpZehgleoFcxhXkPhrzU/OoWYJlccgyx7FskQEZC+o/TKpSRck9GjDnQWRqySONAj5yklr8lxoPc2lplzrbw1s/A1xkhcPavM5dlvqF+1WZZnmc73gWXFZu/0ddW4aLUXHulTt2KSNltyRlnhre0p/f4tFkmhffj6amKOyH7T/bZoTkEKbLDT6bmoU16UM6jyVamlsyJJRwnivjhYO9iCYY6+U6czv66fEZhcNWU0e9SNDX1pmfepKKEf7AtcDDxm
 p7quzG0l
 Zei7Gl2EXIkoDQZj/CICBfqzfV1gSAhncf4KnuiBBCa95pKKi6/mnzblNxe493BM69HM6l3wJkxJ4UKMscGa1fNy6taE7ivwXF4i7b360SfeY617zQVLxx6MbRRywg1B5mJY5mLS3gDqP3N7EN0VCokCJMKg0rz/wGu5JgNKlIpgRHq9ryYkqLWGLf8Fpx4OMwXfvdqu1uxrATGmfz+cnuCr+mcuJx2xchlQYMgdFxY/37tYZbZnJPW1aGadmRRde6pa18EBLlSfcYs7J0SFtQ4nBwC9bX2GMVOXIdI96Zs2EfFHLSfIUiwHmU5B25B1wKStzqyCkaED9C113tkK/ueYTukij4EnPVcm1c/441GDuHNzmhwsVTW8eBAOjGIYu5hsZuW0qp/WbcQFj1jkWo5Uqj1M3y2JKmKr8CrJOvrgToCZgGTvAYuX4ryZH7RSQIt6P67bspzmg/IkZ0g5gaWERW/xNxFu3lNxqg+yEXVYcSppVlzSGFobn50iu2VZUcA/XSRIPEagm7LGCXK3o7FEIks2CKUGXVTZ7gGNO+8KdUR9jy6Qsk1Lzib5e/qGMYpm448A797BltNZ6EuZdKeONJ7kGW5OUlpnvFamyIWtCrThpZit1Z0sn79/TMzjhq3KxCoknQScrAd1VIfzTbDnYd/InuPcZrpXCU+R+jj6SSa/fdenay5F3bd4SxCe9HKEEh9A5Nr8iYDk5/3SNFEPMz844GbtnL3HwfdwpbIllfnFoRV7+zR/Aw2oxiWwtKZkJOrjtkNQfQMXcFRXYc8xXcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 09:46:25AM +0200, David Hildenbrand wrote:
>> 
>> Curious about why it is in page-flags.h. It seems not related to page-flags.
>
>Likely because we have the page_folio() in there as well.
>

Hmm... sorry for this silly question.

>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

