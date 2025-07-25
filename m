Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107EEC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 07:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A99726B0093; Fri, 25 Jul 2025 03:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71056B0095; Fri, 25 Jul 2025 03:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95FE86B0096; Fri, 25 Jul 2025 03:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 888BF6B0093
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:04:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25E8D59FFA
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:04:18 +0000 (UTC)
X-FDA: 83701898196.30.CE8E8AD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id A2BAA40009
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:04:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RzxtJaUt;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753427055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4kS2/t4WMcop90OBAdv6xyzgwcxg8jB4J+AFsz/icfk=;
	b=QOXaYh7wsvdAezQll0Frl7hF+w50C6J6c+W4AO+mMuKFqDbc8fm+1q3HSbYxgWUDmOa7zG
	Q+sdPOoJ3tbm+mDKSaBvYunY71mwenOMWA8ULRx2Xx2yigNdoD52cw5sC9QYOrGcrtlOMT
	Aa0y0GdZ6JfO82npR8nzKw3Vd2yh2Kc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RzxtJaUt;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753427055; a=rsa-sha256;
	cv=none;
	b=2aX1HUm23DWHZwlQbOqhgd0QQT6pOc1hZBI68qmxEluznziasKc9e0cBJUjQPOPrdP1Kfl
	6dAqA31FEz5SRP7CYQGha+sYEGyCCDGl/l1IbSOFRPLn2ObRShEy2SOSf0of3z2YbwQHhL
	Yq70A37yfK8P+dGZcq8OJaJpJWiE294=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753427055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4kS2/t4WMcop90OBAdv6xyzgwcxg8jB4J+AFsz/icfk=;
	b=RzxtJaUtAvjnwnn6rMBVZ4Crwxpgu+kqdrgEq+JqcbW40RmPatuVAD2YZqLsoLeUkOmqTd
	BQdUsvpfD2OrEi2Wu4FEfnl00nL62PQv2xts6l15MarvEIM7id9MJmJNiiYYm64805ZqRU
	J3C4SHqg8XeNhKEFwVfk5cBxepAsb4A=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-FRk0vtVjPT6HjUaDqXQCWA-1; Fri, 25 Jul 2025 03:04:13 -0400
X-MC-Unique: FRk0vtVjPT6HjUaDqXQCWA-1
X-Mimecast-MFC-AGG-ID: FRk0vtVjPT6HjUaDqXQCWA_1753427052
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a58939191eso728591f8f.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 00:04:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753427052; x=1754031852;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4kS2/t4WMcop90OBAdv6xyzgwcxg8jB4J+AFsz/icfk=;
        b=D+zBdYJYyIVjdpdP32uZdhhB7cIdCDOvi1nrfv2Qf3xZHNjClrpB2m+VcTVuiL8j7k
         bnCHssczq/Zr6jIVyxDKtelo6i8X43IMcc/G5nx1mV025WdpCBFKorsllrZC8+Xs3hx4
         KSPhYxs2W1YzHZeUQi0SX1oamiVTyrFmOVcoYuKuLD0uKUWxgy3exgHS7nUrwHylOxtJ
         2E7a6PBoIeoHnIyUbHCBRID8mI1ySgthlb2Ji6U8rrmMMjPE9j44uzdTn82ye3DPzLoi
         Y6e/b+gMyVAsmNuBaf2xiFzhtVVS9E7xAQJ2XQvIwKwHWB3epHlOQgvcp9ABvDfHXtxc
         ebvA==
X-Forwarded-Encrypted: i=1; AJvYcCXmfLwDJqYpbB7ITRJIk8mp0gODUq49tcfkFJB2lf5yqFXiAeJttSyP7GDtRlnANZN7DWjH1ZqJVg==@kvack.org
X-Gm-Message-State: AOJu0YzfM8h1vFBQ6cHr9X6l/rU8CkwFvHu99BHjOzby/O6Nqmlds32B
	L+zXWcY/bP4rYANDXhdCg0leKySUINCoXHmCqMqRMk0hsMrubZl+vjTxdXpdVcz/C/4A45ybxlG
	2HQOcdaH5wIYFEGoTHEPTmdJn5C68FFPxYLUhrYeufP6r8D3gz057
X-Gm-Gg: ASbGnctalGLRvr/AiWoePvfaRmzZPiGeT1+qO0lDD9Qr3PDttC5OrIv/lVobk0MrZDh
	9h3VMqF6hq8Iy8hRuSpNpLKiPJh2KMB1ZtMe5hWSfNFjqu17Ea47vfoPVtkX5grXFr9fcpa/qGy
	EZ43qQMVPGgd8/XVuqZVuPMnFcZ9loYrUpYyqnQEMISJukTsLSye2mYrYazjyMByOcEcVbgxryh
	dZe6ewEsnBruWw6AD6WjOsVv355cYK6qRkZjvyU6O/+Bvjxz8rk3RmtPyg5GK699PhC3RGieKuD
	52oPyTuIOXBk7ZOdn5BmK+uxPRKhibXplFob/v7m7jCvZ4eNYT0sG/SSQyqpemKddTVV+g==
X-Received: by 2002:a05:6000:2585:b0:3b6:1a5a:a64f with SMTP id ffacd0b85a97d-3b7765ede34mr717071f8f.17.1753427051919;
        Fri, 25 Jul 2025 00:04:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPMmiOSrgMj31SBrK8QNvmBgBxAu5I2pasvIE6YWJSNABwM8LEBf/FFALfw+SN8Yg7nqPpSA==
X-Received: by 2002:a05:6000:2585:b0:3b6:1a5a:a64f with SMTP id ffacd0b85a97d-3b7765ede34mr717026f8f.17.1753427051321;
        Fri, 25 Jul 2025 00:04:11 -0700 (PDT)
Received: from [192.168.3.141] (p4fe0fd5a.dip0.t-ipconnect.de. [79.224.253.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587272b405sm22756835e9.19.2025.07.25.00.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 00:04:10 -0700 (PDT)
Message-ID: <c678789a-4fe3-46f0-9cba-9298b55b328a@redhat.com>
Date: Fri, 25 Jul 2025 09:04:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: "akash.tyagi" <akash.tyagi@mediatek.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
 chinwen.chang@mediatek.com
References: <67a54f31-e568-427a-8fc8-9791fd34e11b@redhat.com>
 <20250725050810.1164957-1-akash.tyagi@mediatek.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250725050810.1164957-1-akash.tyagi@mediatek.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: P41dUorDluRzhL7sru7kJb7hlwt8rPxl5a9KlzcWXrM_1753427052
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A2BAA40009
X-Rspamd-Server: rspam06
X-Stat-Signature: jwcmu8umjf4q9f87kwdxaaiwt9xan93z
X-HE-Tag: 1753427055-505600
X-HE-Meta: U2FsdGVkX19Z/rfVVTIW9svrPYMKw4wup51B4D/fIhmSwQ9+5OdWe1fnh24nMnuLhUvgkzhZ2fP2+vgnMISE9Zso0Z5xk4dGfDzOCBrH24ACdqp4zHwCZ0As6v8qAcGaGzMlvBaqPVsnJrJGNNr9VIdnEXlEk5qvdWs+bj6DHV4G613DFbxk6iJpQjpUA0QXwLWZWUGOypMaxf34pxCbpUSZ/FPnDOvHfElv4WupMpx+MjPuUWVbE7ofpkhryOPaS2dS0RwiF/+ie4Hq7brhvaj6ThtFGda5nVyriCBnlVMr+iyd2kUZw6FrimWTOncrSAxzOx3AuTROI54OUWpQGyurDHIE5Ryrxdr28EDcciF53VprhhMWt5uLCmbYeSesqxu1nE43wtwB8Bav/L1KpvofpMU5ZwzLb6yFbjbv4RRQFJObzNoeGd90kb8H4XDsQr/DDspGeb7u7CkKGMhe1ShKHFMqBqUPveb6x1qwc/0y5Zcp3EKigamb6vf1jusipJ1TPLVHpvSS0eh+9X/+cxBZVEO1yF2TEnGgmA8iZhQ29VV7T5GyhTp1KkooGb6XP2N1Y0gETu/pCCf9N5fqLHzPClbC3+Lm8f89wvJijqUUE7Yc5HnhEwgcPnkn0qkXUvHz8E9E+J1z5hMeydKbCaN5z6C3FYx/HOVw9m010OYTFJrZxUcK/NkF4h2xpbYGfc7hxZsj+zlKr4oVfSzUyZueyKv9/gaTjy2UuTVxM1V/l1a7HnhMeqFfwRTK2Uhl7915Eb7TnYgJh8g0Mqk9yHSC3UxiQj5Dz2TELUnuPc10fdpukRsTwQL3lg8wzSd9odbJKdncnmYpHnLmJ+eYU6gItdUmV7O0hEKZXNlTwLtdoPD8B9nvv9KgsoIZP/gGXvMFxeeqtKOcZpU8C2gLeR8ARGcyxJ/l3vBprDrGtBbI07tfLgPZ0AN9Q/9eY7KAOSeXAhU44Diepr+D3Vj
 XrqbpWUu
 aggMUEj+NWgP8GVteRku8vxG9ADn9/7rQ64Gmr4iFMpN8V4MKViRgOjwDDIky+E/wyIqRPCf5z2y2/af4yucOmlCRmcB9o0PQCIesjEavOPMkg1aXl0E5eOFVLzQIR0p5LQIvISGZ6MAGpf+6wVUMD3yEwt75scRX1tPzmmq9Ct2Zn1MrYMLz19ipyfWnjSvA4aPQkx0w+pRSC1kctiRPoJrD0wjx6+7Gsifm+fmO5WTxWtfb32gQOhJoHM7XQkkhIjpT88GsGSbEMSvBFahk4PKs4y0yNtUEiBwpp8/iYeE3+UsSjEyDSinWnsY7Fb93NlxqI5VB5QK8COZUbsp1+h8GMj2BtXrs03LNtrULUOPbfiZrZVTPQO09qvfF8GvCy9NPm9bqfLtlBXQTHTSkS/Ycv+5plx80YnjCtsVYlSnV1SHQZXEKDSFZ6BBqpoZM7gbcdplZpHEY6YzGc/61c5zKjXBYZFtBEL2sfX4RPGIJk2DIeJr8vspAggoV0XNxRo1oLu79dLmUczY9CnOYXLj4nbYYkOOxqB+nRrosOfzJdEMCCKFoEx/mLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 07:08, akash.tyagi wrote:
> Hi David,
> 
> Thank you for your feedback.
> 
> We encountered this issue in the Android Common Kernel (version 6.12), which uses PCP lists for CMA pages.
> 
> page_owner trace-
> Page allocated via order 9, mask 0x52dc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_ZERO), pid 1, tgid 1 (swapper/0), ts 1065952310 ns
> PFN 0x23d200 type Unmovable Block 4585 type CMA Flags 0x4000000000000040(head|zone=1|kasantag=0x0)
>   post_alloc_hook+0x228/0x230
>   prep_new_page+0x28/0x148
>   get_page_from_freelist+0x19d0/0x1a38
>   __alloc_pages_noprof+0x1b0/0x440
>   ___kmalloc_large_node+0xb4/0x1ec
>   __kmalloc_large_node_noprof+0x2c/0xec
>   __kmalloc_node_noprof+0x39c/0x548
>   __kvmalloc_node_noprof+0xd8/0x18c
>   nf_ct_alloc_hashtable+0x64/0x108
>   nf_nat_init+0x3c/0xf8
>   do_one_initcall+0x150/0x3c0
>   do_initcall_level+0xa4/0x15c
>   do_initcalls+0x70/0xc0
>   do_basic_setup+0x1c/0x28
>   kernel_init_freeable+0xcc/0x130
>   kernel_init+0x20/0x1ac
>   
> This UNMOVABLE page was allocated from CMA, but it could not be migrated - so CMA alloc failed
> At first, we fixed this by adding CMA THP pages to the movable THP PCP list.
> This fixed the issue of CMA pages being put in the wrong list, but now any movable allocation can use these CMA pages.
> 
> Later, we saw that a movable allocation used a CMA page and was pinned by __filemap_get_folio(). This page was pinned for too long, and eventually, CMA allocation failed
> 
> page_owner trace-
> Page allocated via order 0, mask 0x140c48(GFP_NOFS|__GFP_COMP|__GFP_HARDWALL|__GFP_MOVABLE), pid 1198, tgid 1194 (ccci_mdinit), ts 17918751965 ns
> PFN 0x207233 type Movable Block 4153 type CMA Flags 0x4020000000008224(referenced|lru|workingset|private|zone=1|kasantag=0x0)
>   post_alloc_hook+0x23c/0x254
>   prep_new_page+0x28/0x148
>   get_page_from_freelist+0x19d8/0x1a40
>   __alloc_pages_noprof+0x1a8/0x430
>   __folio_alloc_noprof+0x14/0x5c
>   __filemap_get_folio+0x1bc/0x430
>   bdev_getblk+0xd4/0x294
>   __read_extent_tree_block+0x6c/0x260
>   ext4_find_extent+0x22c/0x3dc
>   ext4_ext_map_blocks+0x88/0x173c
>   ext4_map_query_blocks+0x54/0xe0
>   ext4_map_blocks+0xf8/0x518
>   _ext4_get_block+0x70/0x188
>   ext4_get_block+0x18/0x24
>   ext4_block_write_begin+0x154/0x62c
>   ext4_write_begin+0x20c/0x630
> Page has been migrated, last migrate reason: compaction
> Charged to memcg /
> 
> 
> Currently, free_unref_page treats CMA pages as movable. So, some MOVABLE allocations may use these CMA pages and pinned them. Later, when CMA needs these pages, these pages failed to migrate.


MOVABLE allocations commonly fallback to CMA allocations, independent of pcp.

Long-term pinning is forbidden on MIGRATE_CMA pages. We had a bug recently fixed,
maybe you ran into that?

See

commit 517f496e1e61bd169d585dab4dd77e7147506322
Author: David Hildenbrand <david@redhat.com>
Date:   Wed Jun 11 15:13:14 2025 +0200

     mm/gup: revert "mm: gup: fix infinite loop within __get_longterm_locked"
     
     After commit 1aaf8c122918 ("mm: gup: fix infinite loop within
     __get_longterm_locked") we are able to longterm pin folios that are not
     supposed to get longterm pinned, simply because they temporarily have the
     LRU flag cleared (esp.  temporarily isolated).
     
     For example, two __get_longterm_locked() callers can race, or
     __get_longterm_locked() can race with anything else that temporarily
     isolates folios.

But there is this known problem that CMA can fail temporarily due to
short-term pinnings. See the "reliable CMA" work (don't remember the exact name).

So what you proposed in the patch at least does not apply I think.

-- 
Cheers,

David / dhildenb


