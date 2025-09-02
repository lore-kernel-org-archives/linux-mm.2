Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F1A8CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 10:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625748E0010; Tue,  2 Sep 2025 06:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6468E0001; Tue,  2 Sep 2025 06:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49E0F8E0010; Tue,  2 Sep 2025 06:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 326458E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:10:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB568C0B2D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:10:16 +0000 (UTC)
X-FDA: 83843890032.08.BB705AE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 58E1C1C0009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:10:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pcw4kjlY;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756807813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wdClPbvtGlTGAY4FJdMl3PBrF3is1zKBeqf/3g+Hb8=;
	b=4qQS2Ga6tjgc4UWhh7e5OgBg53Ds3VBGKRwGjIKL+pwsv1GPifZnT0dCjmWmRqHZonatVW
	FuDwW/Vgg7Rw+H49e3LFzQ5BAvIfYBiG/YajHB0JSeTkf5zv8mOPZj0LvTEoEuSqMFCvXJ
	3Xm5dSZPleZeSGojuyPZdNZBKDATcNE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756807813; a=rsa-sha256;
	cv=none;
	b=ezURM1oSxLDKJTCLjkmDYJB5174C5BUNRJptEaLjyt3VJ5kyvJOApIEQ7FeyfM4ZceUK1U
	B6DB/nQ+SIIidki4YQrHnRsa8z4k9KiHjaT6sTe28chQ+fhv7KpIRqdofyTj7IxO0roGAO
	BFYjtDPeciLmwkJw1MCU+S7qSNK+q7M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pcw4kjlY;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756807812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6wdClPbvtGlTGAY4FJdMl3PBrF3is1zKBeqf/3g+Hb8=;
	b=Pcw4kjlYi5s6YNXRZ3vdc6yHbB0xfgxDGFUplL9610Us17tnPlG5e5gaBzDip4nma8BsoR
	ZI9W26PEE10yUudwtM2YvcRL+XxkUjjy+2I01BjtkyJDslPyTFMpbHW9mL0WjNiicrxwyV
	3Ww/r6ItyMWa5EriFGVWaMVTXyWUhcE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-KdzeTSYtPNC3h39g3YyuPg-1; Tue, 02 Sep 2025 06:10:11 -0400
X-MC-Unique: KdzeTSYtPNC3h39g3YyuPg-1
X-Mimecast-MFC-AGG-ID: KdzeTSYtPNC3h39g3YyuPg_1756807810
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3da4c617a95so470984f8f.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 03:10:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756807810; x=1757412610;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6wdClPbvtGlTGAY4FJdMl3PBrF3is1zKBeqf/3g+Hb8=;
        b=EXC6ZKtv4DXkRvT1q2VZnzFGJABmWfr5nYIkTRz9gdSRekdRIPEScJ4VaTvVhIMX2q
         53ywOfWO+yOyG4/gWcEL2tbqwYdZNRbPNOp8ZIYTjG0Zo8dJ+kxjgRlz3c/OYr+yNw8/
         ZlJmbSN6OLRHiqFIPUxg5/lCNLebttDG4LDIwXkFFX2gCGSLGrESqQInIR/IZIzG6QjJ
         nfg9HvAqPK3Qhyq5KQawuhNNjRl76e2G5bdR8PuxOg2gA0rTZu/4drHIqrFLB+sdNvy7
         IjHe4mDO1pMETh79KoMTQwZFF9HeSz56ajmMMmDW784XOZNpcid/cO8ag1nLnHm110cJ
         lL+w==
X-Forwarded-Encrypted: i=1; AJvYcCVFkoNvhkiv2Etg/TEteCNlp0dXMel+nPST1XINC9tM/57jEB7GA9aifLTTyblYBaeeLbQe1gt2OQ==@kvack.org
X-Gm-Message-State: AOJu0Yyt5/MNyu0qM3072CHJEoflZorxHVRIcu8pgBD+7Xqm5DnXstcj
	Zt+aJMie6yCH+degQsPrW+H4J15pcxdIx5YDxK2ROszpulUQ25eqRqShFVRegXwJDwUOPE9aQJM
	dDf8rCGWzG5gGxEg0DOwOhvAgg7AbV/MT8btin2WXvnRQxLsP0aCs
X-Gm-Gg: ASbGnctNJ+fcQoZa5I34qvPQKQVrpx07Px8tc7Dzc1pL+IbL/nOrTK04YgUggnyyJ12
	ILdp9qiqu5czs6D9ZknXyZCCrkD+N9x8bL5GpYcedM3lYwXT6i5UjEod8UcENDpBkDRzARg2g5/
	KOz1eKCgGVZWNG351TqaPebLL4Ki4CXKyuoNCRnDaAlUr3uR0F8qb7fkyDhQ0wvn6BkU+e7D6TJ
	1xKbfR4gVx+DbZZbWKj+WEEYaOAYFtN0oVUtzpV3cuk8zwMg/KCUy7Q1g5K1mtY5OSCA963Ab0b
	3eKnJHio/yh12GpgAKgEMZkVtDgDbM8hKTmEHPLhD3nu9a5xG+DrmngwFILplI0q5Fjl6XL865E
	mB1eBeHwcC5qDjrUIk5+I2cXbONkgGDOYSvI0T9omNI8ZyWJfFzSAWqNvNWM0LlZJWx4=
X-Received: by 2002:a05:6000:40dd:b0:3d6:92ed:cae9 with SMTP id ffacd0b85a97d-3d692edce79mr4863325f8f.18.1756807810343;
        Tue, 02 Sep 2025 03:10:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkoI4ocC8az1pQjkDE/RfScpqsrmQLhs8u/znVft2GCWKtKFWLKJoOcckAT+Xzei+dAhtQLg==
X-Received: by 2002:a05:6000:40dd:b0:3d6:92ed:cae9 with SMTP id ffacd0b85a97d-3d692edce79mr4863301f8f.18.1756807809856;
        Tue, 02 Sep 2025 03:10:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb9db4sm19138122f8f.47.2025.09.02.03.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 03:10:09 -0700 (PDT)
Message-ID: <e22b8472-6d20-49b4-b49b-78f79f126294@redhat.com>
Date: Tue, 2 Sep 2025 12:10:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-2-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250822192023.13477-2-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qOyxaocDBNG6lWj85iV-H72Dea2b7OyjjhJr5qRwd04_1756807810
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 58E1C1C0009
X-Stat-Signature: 1g1ei86cgap77r3ud4tbuxmm3opihrms
X-Rspam-User: 
X-HE-Tag: 1756807813-707145
X-HE-Meta: U2FsdGVkX18/7OJtCP0Qv1tj/tdhIC90uBC20tRneWyJlbZCkBhTRjp+GZ6WOXWae5WIi5MdlANijtLfCr1S1aZ7jmgd99Cri5gAgsUZt3UNEyeXX8cEeLj3gRUcYQyaZI/MQ/UnC/IJOsmV0s+thKNZeHDzG7Z1YkCxlfGzRfKwj2+9grwcnR9ZpmNeMDjXLXCkmupx0wW7kyAfHPvfNgcSZ0sQYbpQ+A811KZW7s43ZNja7cZqt5qzn51+enKD46QJ53nL/sthkUcAvdpab6WWK7AQW9nkJva1+j5jC+FpsOu0W53wnVQ1Gc4DtC23VrG0stKcE6qJXxRb5j/0GmPGGdcdzydurjFiXrrQh8mep5DT4P9bvgdsI+TnQClEf1EvC3qEsUE+gMKV/eNJd+4mQP0dl2X6gz9grc7XJBRuM56KqaD0MOlX4F4FfG6u16zVmQHGWaIOgO9gkz9A90gp2nc/bvQf+qejOsbdmM14wGlYzgOSeW4FYTVHN0/0UmhdPx91YLyhSZciQ+uEwoGiFqCPy4na4xBihYsc0/yhVwI5JtXgekKguGpYdt9Ft+wJI411mObRIgL7KM2ULCeH3mj5UFs9e/LtQAAo9BuYC/mFQnTy9+uj2bUSdd1k42SiMH7SzpANFcLXNWBBOjg27pdgV2e1A4ntl/BTdwLkMOVyXJe1sYjpFGlrv6zNKX9DLGpEO6N/+iqTXbnHTRI7BXkrfclhnzPMeQZgrE3ugEyXRaSQDOSQwdPXm+nhYymHq+7zkpHik/LoUhsvQ5ShQxVyfibTwOPgLWBWgkU9OQX4hWVJSADDUIBqBvUWTZiwUfAtb5/LgP3dFMkXj29NjmdopO3RHwfR3OcQGKnjT5zP4lM5JFfPKpOnYd+DdHtzsz1P6QiWkTOVIDBMClGJ8wLkcJX3cQUjpa5QR0/3YGjc1DhtixorA43A+pkq577KvUUWnOrIbbN725k
 Buhx5rX6
 MRVHA8GMlYxcsHYE7BESpLlhCvCAHAfenaTDAe21DHlb3rskG3co5KWYIR7yiTHJ8yXjHl74SxGOOtyMz68b5yRke+wgQeYc2iGxd4Vn/zsMZslww2IEIaIr9k9wmCmuhVqQnLKhrqpV7kJl71/x21Tn02PgOSdxrxvz5avIQWPBLY2yxft3s9nGLrbUdwZ0pYJuCpiGC8dxbil3hWm0Gz9SmC27mkXATJ+h9ovZneobZ8meeL0VlIIezWi+7clES6l+Io1MfTRX4S+Sehd3xPbxXL08vbbySaDJzZifQqNC51QZ70YjthWEI3xdF59mbCQj0BdfSiFDK9o3WdClDiXZ83fs//HdeyqpTvhhd3KeI/sYLRAYk4uw31FQa/BQmYKPJZy3EMuY6xPPeXSFuHrSkjnZa2b6uMtLU4HM/P76BHMW3rKyOrdeLkJJ8MUPjCtIbA81Aq1goX1s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 21:20, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Always use swap_cache_get_folio for swap cache folio look up. The reason
> we are not using it in all places is that it also updates the readahead
> info, and some callsites want to avoid that.
> 
> So decouple readahead update with swap cache lookup into a standalone
> helper, let the caller call the readahead update helper if that's
> needed. And convert all swap cache lookups to use swap_cache_get_folio.
> 
> After this commit, there are only three special cases for accessing swap
> cache space now: huge memory splitting, migration and shmem replacing,
> because they need to lock the Xarray. Following commits will wrap their
> accesses to the swap cache too with special helpers.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---



> +void swap_update_readahead(struct folio *folio,
> +			   struct vm_area_struct *vma,
> +			   unsigned long addr)
>   {

Oh, one thing. Regarding recent const-correctness discussions, "folio" 
should probably be const here.

-- 
Cheers

David / dhildenb


