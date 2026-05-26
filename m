Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B74B5CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D0496B00C0; Tue, 26 May 2026 08:07:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25A496B00C1; Tue, 26 May 2026 08:07:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149486B00C3; Tue, 26 May 2026 08:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2C7D6B00C0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:07:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BFA14140206
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:07:40 +0000 (UTC)
X-FDA: 84809446680.09.44A1B47
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id B8877140002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:07:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RyrWsVua;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779797258; a=rsa-sha256;
	cv=none;
	b=vgJdtQnsyjxT6c3L5WIZDweNN35/jLb1TEXu58S7a9XKk77XqL18TbZNFEVe0eyhEZ7DRN
	DrRDA3snX71o3mv8mhDPTLDvd/ZRuAC3z+wJeY2hYa8beRGYHanEW4X8pPZ7MPPTwweTvp
	u1ufzWkUZIWe0WiYK+spNkB/kVue0D4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RyrWsVua;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779797258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HdCzA4cxs/UXVY1rBI+ynwKuOH0VRJEDWv8W0sC8Rh0=;
	b=AiIZjk7KO6NdrIxL4qW5oaQlKAheeBFF7omNKi1y6fjRQRQFW6G3G8tOuvCsl3EWZSXogD
	Prx334wW/RlbSr9FeFavW9uYJvOLiT1rXHWXI4vC2QZZ41GCwOxsXUUJ5FofSCKCsX5xx2
	oh9CxUPo3PJCNl2FsNlLxI4rszmAkdI=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48fde2f2d61so15268725e9.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 05:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779797257; x=1780402057; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HdCzA4cxs/UXVY1rBI+ynwKuOH0VRJEDWv8W0sC8Rh0=;
        b=RyrWsVuaszmwMwSANoTOSphJncLksIMxy1CxoDLrZYXFCRTN4cDsul4Uhej2mINIAf
         w15WaImneZqmM80FWDkWS5XvICycc6rruMl0TN1kHqBZ4xXl3+w2SDaDERhZpn/eVscY
         xGgDfGjFYswXRKRgGb2tqhVVlr+bQiQ3JmgIPCmUxp9rOV/dscDwGVFMH0nmQ7CCHmUq
         9Uct+TYBDP7s9J4VALpg/RlhKj7Hs+I0lFQbkmjc09JDPAXt4a9a5P3FaVykxbB9dOlN
         cEFjwcf2P5l+EgowMbg4OfCGHTb1JMnawVUK9MTHc0cI9hxGbTAmepaiwJr9Se4RYyPB
         cDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779797257; x=1780402057;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HdCzA4cxs/UXVY1rBI+ynwKuOH0VRJEDWv8W0sC8Rh0=;
        b=BydpPA5//dBo9Ov1Yz6CZTsIFkUhDwPV93r0dn5txI+JSPl0kYDau0UDBQHUOmt3ds
         UrKeAs+CkFIvOeK9S6+i9E8cdwW+TMfvvadEsH/GUndr/ZLBPfkCSIdbZI/n5eQOlq2k
         +7TFKscoRueG+pKkkU6sKfGpn8abrSra6Y5Wz3/AOh43D7tn0oiSN5WpeSMAD2LuyWl4
         7i08Vo3OpTwSQCfLYWkGBbHvHice/ImQoKJSqeqV5SD9SBvQTvzGRQQHSR2sozL82dNc
         vZy5OpObS/9FwmgJFG2nylCBTFMUfrwFWkKYpR4o/8Ti3PZ2a+hUYWLR+aD5KKLIEeea
         3lww==
X-Forwarded-Encrypted: i=1; AFNElJ9VlvS/KYoRUOoGrVa0L0DGd0KpcPjkNe0TXDDr1F9IUfIii3CrR0sHaI30HjqAuYrOXnsLpeg0pQ==@kvack.org
X-Gm-Message-State: AOJu0Yw+6MqvqvOd0WwCYR3Y6uDe2ALAfteg3AOt43oYqHfDeRH9GNog
	z0qi/Adm22cm8uhE7/E096CcvTMsapHSPAoIw2utXzt4p40roxlIcSkcIrF1H1VYaVc=
X-Gm-Gg: Acq92OFs5nnQBxPZovUH5TsETG+1bj5aNt6l+u/tCuJsG0rmxWDPkHZ2q22/nxxgk4b
	xO50MpdNnxVxf2C0lW8QL2o5UY0WURlS6tkIM89TJWNjbUinKMZD03mhUb4BzyzeLzwNCHrf4/8
	y5PUsOsM4/PuiqDeu474eWj7T0ab1bHOoQ02Y7HfFieXlJ6v7iUhWq8EPIN0kME8VsrQGBzYRbO
	WcLr4o1Z0npD3iqaYgcWJokkKpVnuRyaeTBwcXrBCSocseUoUEZ2K0SZPfdLFEHtXNajhhhNHDn
	lITT6vdhiaQkZNQThpTXhGlZ0rZ4lLaz2jmvYJTIDuyMXFH7fCymHHFtfWf5OMYJaSu1NRJ+K9J
	Mls0AI8BK+lK4WigVQuGIAcGVgcH4fLBskwjEcU0LFMAzfrPowULl/iVij0XoE2ENrZd62r0nGZ
	jbVIR3k72Go7YEgoVCcHEdT9i+cQ+vEPBGnwaRa8Q=
X-Received: by 2002:a05:600c:b96:b0:490:4923:aa3e with SMTP id 5b1f17b1804b1-4904923ab35mr126128205e9.7.1779797257109;
        Tue, 26 May 2026 05:07:37 -0700 (PDT)
Received: from [192.168.43.36] (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490452765f5sm332553945e9.5.2026.05.26.05.07.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 05:07:36 -0700 (PDT)
Message-ID: <1dea9df9-18c2-46f5-bf47-abb3f088574b@suse.com>
Date: Tue, 26 May 2026 14:07:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: partitions: replace __get_free_page() with
 kmalloc()
To: Mike Rapoport <rppt@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260520-block-v1-1-6463dc2cf042@kernel.org>
 <ahPnX-CwVgK-9chp@infradead.org> <ahPxmSqT4Y4jcAbQ@kernel.org>
 <ahP3R2nH8-bHMVf0@infradead.org> <ahQX_JCgS9JWIhY-@kernel.org>
From: Vlastimil Babka <vbabka@suse.com>
Content-Language: en-US
In-Reply-To: <ahQX_JCgS9JWIhY-@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B8877140002
X-Rspamd-Server: rspam03
X-Stat-Signature: odtf7p81ordso8zspkap6qio96p1wtnj
X-HE-Tag: 1779797258-833081
X-HE-Meta: U2FsdGVkX18KRF9DtA0RJ02B2LPnlSQxUEBu4dhOZxP4owuD/ub9xYbUK9z1qnClcYifzcROsOy3rpY4k/APFU4vDOvhXKklg2eqSfsTJrtX5jNozvV8+fp7AZEx58d55aLkvd683Yw3XRupdxmnfdcxoH2FtdSW1weyYOtWzlcIO6TZ6HCrapzwZoiw3ErHcoydYYloWADhJam5ODhuCQUKDZF0m22XDtF4K9Ni1vlfGRxtaA/VLGZ9o96i3/bapDzXWcg57SleFIFmKC39lgCi3Qs07q9WBu4wf+z5pNEQ6KAXBTzLr0FyEDpRExtGFQw9bYVNAlzJXRjwgRaRFYApY0WYBlCXgSBNOXPhtbh2v8L3K/v3zrU1CnMy+Yayl9z0oNKTBmky/uz7GKqvu9drduIZwUFgfwuUbMbD3Zn3DBqw2Fok23Fb2M6EzfcKfea3JSeum+wONJr37d0ogDY96/pg3SSfKzFB3wBgHYLkWWmfIozA9F1ZscrQZXZsM6ovaOK2cSYjNJOhKXOkbVDddxpglCXUfGf1s+ipSq5A3MAYIKVAXSDXyYQXjfSLL7mfMnsmtkoyaY4nuIUsrjBPal9GgX06VGVMP4letH3Q4WBXC109aW62J1ao/m8z+LyDHWGscEg8h1jArj1nZM6owEs1vw/qNJVItJjyybJga+rFhfrDcmj1KXmiOJ5Am2LZQAA6oV7Doh+WUZr4NdIk73xVjPAezPBJGODwOuuDXH3k381sRP7THtU5LynhlGGdv+HfiNmdnaW+ig4pvBFrmsLWlhJq98pSb3O5L4lHZ+D0AZ8sRLU41uSKDBVr0dD8jC66c2n46p8qBCVWcD8ARu6NwTV/ceXvXbMmRl31DBLVgIsr+WHAtze1Uo4NdR+YDMtN08WolxKzW2VOqkkY8S2wrOiZthWqFX78pZdz8F/F+inNC6N3NH5bHZeM9hy/tmOkx9j8aFYQMUM
 ehqXfr5y
 qPFsYXMG0MIDOKentkd5eSyfMEyZoeSizFBJX9dcODyBWlCVDkQKbz3rqSri+L0sxa3KMOFpuWpJw7vveHRrTXeltVvS1UEXcEB5l+GrZOCg1Bb9lXRoJkk2GjbNml4kerhjlD/UJo4zGrrI9d+VD4Ara2CXmKLLbaxl8OtsyEqmdRX4eiEJzt1qhvq/e+QALDPyAs4ooveWzB5/d7Iz9YXYFkNuSuckg+Qh2XLVvCem3hj6X51kveUSgdlBM1Jmxu2a6gRZdsZWlhPeGMI5ak0kd0/mL34jWuUhNS4Oe2u/4GWCVqF4s+N/G8g0fWxI/zu25
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 11:35 AM, Mike Rapoport wrote:
> On Mon, May 25, 2026 at 12:16:23AM -0700, Christoph Hellwig wrote:
>>
>> This does, but it still fails to explain why kmalloc performs just as
>> well as __get_free_page(s) these days.
> 
> I don't think that in this case - a single allocation on the cold path -
> the performance difference is even measurable.
> 
> Nevertheless allocations from slab caches are way faster than
> __get_free_page() (i.e.  alloc_pages()) as it's essentially lockless
> cmpxchg. Allocations that need to refill the cache do alloc_pages() with a

Probably not "way faster" but the fast path is quite similar - percpu
pcplist protected by spin_trylock (pages) vs sheaves with local_trylock
(slab), should slightly favour slab because spinlocks are typically not
inlined and local_trylock is.

The main reasons for switching AFAIU would be related with the
folio/memdesc conversions? If one needs just a kernel memory buffer,
kmalloc() it is, even if it happens to be page size. Page allocator
should be only used if you need e.g. the refcounting or anything else
that struct page provides. But then in some cases the memdesc conversion
would need adjustments at some point. With kmalloc() we can forget about
this user.

Matthew can probably state it better or even link to something
authoritative?

> little of slab bookkeeping overhead.
> 


