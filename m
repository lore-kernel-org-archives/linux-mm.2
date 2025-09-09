Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3902FCAC589
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 07:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EDFB8E000E; Tue,  9 Sep 2025 03:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79E1E8E0001; Tue,  9 Sep 2025 03:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 665A48E000E; Tue,  9 Sep 2025 03:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52AC38E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:56:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 05EF51DE3A9
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:56:39 +0000 (UTC)
X-FDA: 83868954918.12.DD0D55E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8858B180003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:56:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PY6Q+8Sz;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757404596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0hK7FqZBGR5xoCEQtRa11i7RYI4o8uurqOL8JRO5YM=;
	b=SgoM8N5bbjI3XSvB8nanabh4eOx0/u9ve0AvHKgEU9kCuF8SD8Bkfp9MB5YKpU2vMLIAHe
	RkhA1GBzpvW2wDSd+rjsH422+7fOceO7wgdKu6m/+8cO+b4rlwD3ZNb7o1Z6vYknoglteI
	YLFut9xpgdUNQafjiKG2zR5Y5TIVvbg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757404596; a=rsa-sha256;
	cv=none;
	b=e1IOK93IGVH+L6Ec7C932o53d5lZ+SLhYN2dbLDqG2gX5oQmdb+5Vv7uIxn1K4qym17YNh
	XGxxze3vvHioe7hOUrezBvCws5I766EimFwtohyQNz4BK5EI18sFldhemlSZSbw8w0v+2g
	bWAm7SyPvpdu8dtIzszRqonz2amblE8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PY6Q+8Sz;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757404595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=e0hK7FqZBGR5xoCEQtRa11i7RYI4o8uurqOL8JRO5YM=;
	b=PY6Q+8SzwTCiSMoRBUGgBxpw+YhYnzzMLc3c8czHnXgxwwSHYdd1Q2Zv0bOx0ULP4cfYpn
	kXqwzaNslGSzbY2dJyImWUFsJ+Y/fWvc8vfM/XIOc2L3pH8rql199faJWEIIMWTO3B62WO
	sdNaxiwEhjzSIN6NWjcJzvWtPChwQl8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-i8SOts-iPe6r4JZ7UqVNow-1; Tue, 09 Sep 2025 03:56:34 -0400
X-MC-Unique: i8SOts-iPe6r4JZ7UqVNow-1
X-Mimecast-MFC-AGG-ID: i8SOts-iPe6r4JZ7UqVNow_1757404593
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45cb4f23156so28948945e9.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 00:56:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757404593; x=1758009393;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e0hK7FqZBGR5xoCEQtRa11i7RYI4o8uurqOL8JRO5YM=;
        b=AA9RRoCaM9LJ6ib0nbd+VWCm0lh6blGNJJ7QYyC0c3BawKZhGejeYcRLlnJiiFEacu
         9OfaK9f8hKAMPnsGU2vLuLMUIwBigFay/aGqsqaW4mmay0s+J7H7l9bF5bwoj9sQkJhP
         H9rgnq0cDjmBHXZcXtEhuP5vnr8DrTyIMohYuKtaYSOuE8c7gADlnZqoF5jYX3qiCZw6
         qli2Xbxl/pRvJgkZg5cz9Uuk9Nycmh5VDX2bp3E0XVszUaQeWQdHkiLtNjuLalzorzQX
         e1BVfJafGuGcc7Ngh/E1QtYp/4EHn5fPHB6Ck/uub/86K5Z7PWkek14GtrNXIKlnerrH
         BOGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHvy8psTgikqx0wDAmdCFsLgMBjt7zzJOzR9+a6p3NA7lFzicDLpbiEM5oYc3Bhwk25h9kBXpW2g==@kvack.org
X-Gm-Message-State: AOJu0YwnxXg7xY64aP/REw2dZ3piA4wZ0QVs2OfDtnQs9G4PlsU9cE+x
	vdJGhnFcg6r1FN9SVBD3K2NYJcEE3ACuUvTCMYnYoHJK+BtMOPlyWjU76gqkAVrvj+EJL3PA1hM
	4tSs0IvDLvaAy9HZ7l13aWP/682PpzXoie2w96/4YaNBnpl3nrf5f
X-Gm-Gg: ASbGncsnjun6VAnETKTbPBSS8WZwhLbiN8VI4QZNd12FXH7HivxDEq8uUCy0Z2W9Bqt
	qbQbdniIoOhM2BdjzrNDQtDtI6XmWlWfMSif632WNjx2VFCkq7CKzNY6iw/glX43IuSHjsjBGd4
	Jg2ivac6pirl1ipGnKL60z2x8PL+7D6hW3RIfTqSsR1jRicuaGfmV0HmFwUMANuO56Kcjw75zGB
	+xrtZ9JdjbIA9ZhE5h8eJSEBQDzuL/9Nse7jp1/a0pByti13mTYFAF32YVU49/Zfy1wxzD6+x11
	eXfQC0Cu0Q0VPp4OA5EYkgyI6J3sNxxQ3AoCZgjKpRSC/cQZHyAsHBuHiD81PGwOjPnbVgz7Vtm
	A2L1fRyqeLxC3wGAQTLn/1tEeLAoytFMu3mVpZ3qS2OBjYAvfK1hSTKdp2eJA2+hnZS8=
X-Received: by 2002:a05:600c:c4ac:b0:45b:8a6f:c6de with SMTP id 5b1f17b1804b1-45ddded4e96mr85872485e9.29.1757404593367;
        Tue, 09 Sep 2025 00:56:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgC4IFUNh9g/XD3LRtpaiwy8dcTRFuknGnF+NHBRAo/E7QpfUA/FSCYNKeHII3orJEVfEPbw==
X-Received: by 2002:a05:600c:c4ac:b0:45b:8a6f:c6de with SMTP id 5b1f17b1804b1-45ddded4e96mr85872225e9.29.1757404592917;
        Tue, 09 Sep 2025 00:56:32 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45de24ab648sm110290445e9.5.2025.09.09.00.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 00:56:32 -0700 (PDT)
Message-ID: <ebaeb8d9-0b22-4304-9dba-40d37d82e369@redhat.com>
Date: Tue, 9 Sep 2025 09:56:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] mm/gup: local lru_add_drain() to avoid
 lru_add_drain_all()
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Krabler <Alexander.Krabler@kuka.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Chris Li <chrisl@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Frederick Mayle <fmayle@google.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, Keir Fraser <keirf@google.com>,
 Konstantin Khlebnikov <koct9i@gmail.com>, Li Zhe <lizhe.67@bytedance.com>,
 Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 Rik van Riel <riel@surriel.com>, Shivank Garg <shivankg@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>,
 Will Deacon <will@kernel.org>, yangge <yangge1116@126.com>,
 Yuanchu Xie <yuanchu@google.com>, Yu Zhao <yuzhao@google.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
 <66f2751f-283e-816d-9530-765db7edc465@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <66f2751f-283e-816d-9530-765db7edc465@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yYWEnf_whNM9-szzDcVSMKs3vivWYW3zI8zQTaxSEFs_1757404593
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8858B180003
X-Stat-Signature: kuucj1j75551c8txqqkicyyc6uafz3s6
X-Rspam-User: 
X-HE-Tag: 1757404596-276640
X-HE-Meta: U2FsdGVkX18Nv0HEO6G1Iyq7EhUtWphbv2atnCh5RF2ZpYmLVwkPwck2D/BySsIF0cXzRBZgHGkBNlegMs/xPuB//sn8d619mZ+i84f2BRP+VG8uhfgUXKFy2z7iM/PTjXzjQadv+P5SMxSb0WLKYDYeYAMd9rWy3xLF3eDJAJMcRIadAI8+rWOV3Lu5jqQOuq+2oO35XpC2KOz4x4J+7rgXLWC6DecoYriA7v5e1NnQPVw8+ESIyw4lIJEtP+Jrdx6W/f+T6wtLjCwIUEMbpT7BpOv5XYIDgas+Fa6/PZFSyQI2q2lDHqohB/fkZPKG4qq4YMreXH8po4m4z/chgBfNoxOakjLGlSlhURli//jVkb/krGsgVhhFM+hGac7GOyxSJVAygsHJoFfCdundC3b9CyYafKVMIPm7H8g1kwLMonRY33lw75SHEUjvZDd39QQ4bd0Lhv7GcLKTqYWCGbyovmCCD6Nz8CKyJ2fES7kpapzzCDrSp7N/ddvVxb9iyFctS55i6sH/Swg5wMYQdkmKJZmrnTIzZjfwncwFWwi5iCALehduZo/4JMEyD5U7Idvho6U+qcn79XrevJlFOxKJ61F9UgLA9OjYYgIOxS0UgLQC1Izm3v5BVri6n6dc9IfMw69RpB+Od43UD9SwXG+qSHSa35CuNyeh9VkQMiB+MVbBtJJ1tbKPFnL1fOZcU2zjFfxjKw7Mx34YLvnqnTsokVSTdDgu+ooIyiOU/1eLQq2R/N7xivDm1GSMN4BweWWzhoP36xGLLWGiRB5LyTRYb9ZMKVktDdmUvWdo+vD2cyu8dJg5fnNIn3mh/j6rpDJkfb+1F1NAEMY8cB03Pf6+DwNJw2lS67uNGIMZ+7HE26jjvymX6uupx+hcaJc3Cv6HiZVPsPBO7qDu5jJGNEtt5J9tVe8gSXbCcm+eXMc9Bt8dGrJJtnNyrYX7/+IY0h3qtdNnMwd/WCLcXEi
 I3y+0hY5
 SxQbpVFbE2h4lempEzxAiOIEo3GX/1aIo0MxQUtl+XGUTpeaB8XBtBlu7gZOpyCXRYykDQorhWHHCuxkRKx5BCIjtUPxDBNMgV3i7X5jOj+NG0Wvmt9lw+A27z6luPRxMKFlnzK+1FGLhCQI1ZgGSFsKiShB922SehbZNZM+yd6qT1I48qbxqDKzD36ISVGYp17rc7wr+pV5V+nOvK4frHX+b68XOyOUoC0nBmU27/xmh0w7v+avrX116RXddKeznFmj5O/Bk+EkuFImH+IgPSlEgK0jwW+a+GqPMkGNBGGDnMuwGwCOiKE48Ehr3WdVGr8dl95gZsvllKIa522PWcaLsXC2Tb/QZ4cCv9cT8nY1sEiaDNTEFOmuWRbBwwGzl5yvrawbFRmwYDHGWpdiUS/L821PNEqJEkaBvuto5jtIIm/YUiRTjQq8WVC/AXXfKKLKsWAymQvFKwSOf5bkdAcGIYfU/OY3E7rCuN4mR8k4WEBZRHiE9uOfn5HiaBqt1DR6iH3sVwXMY7x560FxJZg3Sho0c+4qykns62nFznwAK/AU8RnHgBvJU/YC5IN+EVcxMQyU9Gtjrg5bYGo8PC3haQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 00:16, Hugh Dickins wrote:
> In many cases, if collect_longterm_unpinnable_folios() does need to
> drain the LRU cache to release a reference, the cache in question is
> on this same CPU, and much more efficiently drained by a preliminary
> local lru_add_drain(), than the later cross-CPU lru_add_drain_all().
> 
> Marked for stable, to counter the increase in lru_add_drain_all()s
> from "mm/gup: check ref_count instead of lru before migration".
> Note for clean backports: can take 6.16 commit a03db236aebf ("gup:
> optimize longterm pin_user_pages() for large folio") first.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: <stable@vger.kernel.org>
> ---
>   mm/gup.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 82aec6443c0a..b47066a54f52 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2287,8 +2287,8 @@ static unsigned long collect_longterm_unpinnable_folios(
>   		struct pages_or_folios *pofs)
>   {
>   	unsigned long collected = 0;
> -	bool drain_allow = true;
>   	struct folio *folio;
> +	int drained = 0;
>   	long i = 0;
>   
>   	for (folio = pofs_get_folio(pofs, i); folio;
> @@ -2307,10 +2307,17 @@ static unsigned long collect_longterm_unpinnable_folios(
>   			continue;
>   		}
>   
> -		if (drain_allow && folio_ref_count(folio) !=
> -				   folio_expected_ref_count(folio) + 1) {
> +		if (drained == 0 &&
> +				folio_ref_count(folio) !=
> +				folio_expected_ref_count(folio) + 1) {

I would just have indented this as follows:

		if (drained == 0 &&
		    folio_ref_count(folio) != folio_expected_ref_count(folio) + 1) {

Same below.

In any case logic LGTM

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


