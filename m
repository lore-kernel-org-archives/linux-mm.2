Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26CC1CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8115B8E0017; Wed, 24 Sep 2025 06:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8DE8E0001; Wed, 24 Sep 2025 06:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0B18E0017; Wed, 24 Sep 2025 06:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 57D758E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:07:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 253AA5B150
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:07:32 +0000 (UTC)
X-FDA: 83923716744.25.BEFAC51
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id B98F0140005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:07:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Re6o0pnj;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758708449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8GrFljRltqv2IkALg1YfGWmZraH37YnKJBWkHZnJJ9Q=;
	b=2PAtp/kJxZsF0qunfjDH1iYhPIAGls8V4DBRLlJq3kswJ5+pMCNAarT2b3o3HdmL2hsbPC
	pc4jtwO9b3kokjsCxlMHMg5xhwYn20yG4yeeYcgVKo3BmXl7T9XQf8sUKBkWMusStiSMPe
	bxNeT77JifYFn9aKtiio/wQgWK8isnM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Re6o0pnj;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758708449; a=rsa-sha256;
	cv=none;
	b=wYHsZTHaY9J/oWbghWIQprmr9Zp2jCsYoeBwpSkmjb74oCUNNdrp/neZbtDe2+I6Ej1vk4
	TEzxy1c7Q3nIohRhln9Jb1CHz2/fXb/OrXHu6yyeuWljbdad2khcZVppAA7ShvGoFHFhub
	CX6hlz1TTxvb7HI2+qUu7x6tCGB3Q7o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758708449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8GrFljRltqv2IkALg1YfGWmZraH37YnKJBWkHZnJJ9Q=;
	b=Re6o0pnjZ+1G8+EITSCg3GFYNmG7YQI9s1OM9JaNj2a7wwny7N+TTZZfKP7tjGTjQ2zwSP
	hgdKQr5Aw1s2C3tdMDKX6KVmCI8VCBpqodxBYF3L0WeKqNnAD/0t9e/xzIHjUVzMKGGffy
	n+EXg1/GqbNYLJF6JJNIVwvWKIVbVlA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-f1G8nltCNqS9n1MJ4HCoig-1; Wed, 24 Sep 2025 06:07:28 -0400
X-MC-Unique: f1G8nltCNqS9n1MJ4HCoig-1
X-Mimecast-MFC-AGG-ID: f1G8nltCNqS9n1MJ4HCoig_1758708446
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46b303f6c9cso28166085e9.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:07:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758708446; x=1759313246;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8GrFljRltqv2IkALg1YfGWmZraH37YnKJBWkHZnJJ9Q=;
        b=Rq81fNok/M8ujlOwdtmKQg07O8Y7BEcrgv4twizcXCqqAQ9WYpZLGfCt/JofbTvRI0
         DY0B+HB6nvaYbGzelXOxp9jQfeCcyLhx2RLvYq3q8N5Zmusa0KazwZnvch56etfFYosR
         2jlYJNyZ6YaiWi2z9YooNak/fj5hjIHRlCxW/coHQzTwM1Ag4rWzkt6v2V8aCJYGGfz0
         4EdwPooOP0CcGbunPcLF2H/00isiUFwL8zoh4Cu8m/COYitk3Qe7D7jHOCNd8V5RyzU7
         PsS4YQtobuITIHWYsPK9UNCOht4DBNMfL7HwJu1jDNKZuAVjlkmDGkMqscS3ECnYtWeM
         SuPg==
X-Gm-Message-State: AOJu0YxYKbB/540LKXWJ1LTTZj5+AlrrPX7A3lzFKQNo1CjUJHhhJ6Ri
	GlKhEfnUbRkUgpd39RA++AaugIKTU9Cag+sEuaJW0uSrQafy27QU/4ywWQUcB86w8HUyg/wEQ9p
	Y9Me7/WHvlJ0Ki8FB0CsriRNF1yifqyXisOD89Wg0tRMQGtAoPufz
X-Gm-Gg: ASbGncuXlF86BDOnCfRUDCjpKdZqSMf44NGxhvpGDkCP2ZnAFmacJ1LypI9gXFy4V5V
	C7TfrBPp87Ail12w+2PGSNEX3B8tke3M2/G5PZY/DvTTtJXelhpmugymJMeIShpiRQ/ftXyg0gz
	y2waeI1Jw5pbSXZSI0wg5IKFYeomaUT5N0EDYMeKzEmfYey5qO+eAuhcr742yrUOC5VXzC5Gkxr
	WS/SnxZYMg7Hj8w+94o0KXzL2Gqqt5BCTW1uKhlNmbCCx7iQHeG+H2sWv7m+FMFVCjPs4wYbsm0
	9qDLo/HAftDdoB05oi4KppdPf1dR4n7zYLr61TSkvzE6KdBMxwMWnyTIuIIL7tWS/RKySzKTl93
	Oks2EnlHwjvKGFgX3fUlQDoyq2Q6rzWH83yggA+5chg5Qu3MFEmLQmeTwKfy4neIRRA==
X-Received: by 2002:a05:600c:c4a1:b0:45d:d56c:4ab5 with SMTP id 5b1f17b1804b1-46e1d97d834mr61858825e9.5.1758708445765;
        Wed, 24 Sep 2025 03:07:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaQcC+ULZdp8/N6kG5WGhH1icSL2ZrXnUmEBTw0kMbgJba2jUfE9tmmYof9yvOb6DQDACnRw==
X-Received: by 2002:a05:600c:c4a1:b0:45d:d56c:4ab5 with SMTP id 5b1f17b1804b1-46e1d97d834mr61858355e9.5.1758708445323;
        Wed, 24 Sep 2025 03:07:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee07411f4dsm27150172f8f.26.2025.09.24.03.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 03:07:24 -0700 (PDT)
Message-ID: <0341cf34-9c20-4f25-9838-39871409b2a6@redhat.com>
Date: Wed, 24 Sep 2025 12:07:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/userfaultfd: don't lock anon_vma when
 performing UFFDIO_MOVE
To: Lokesh Gidra <lokeshgidra@google.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com,
 jannh@google.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
 Barry Song <baohua@kernel.org>
References: <20250923071019.775806-1-lokeshgidra@google.com>
 <20250923071019.775806-3-lokeshgidra@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250923071019.775806-3-lokeshgidra@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DfQ0qtxy0R2qp0Snwbjx5_u0YV7oeH8L30_gvybIN9E_1758708446
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B98F0140005
X-Rspamd-Server: rspam05
X-Stat-Signature: 1iyq3kk4i871wnufdwo7qsdy7jykxhs1
X-Rspam-User: 
X-HE-Tag: 1758708449-285881
X-HE-Meta: U2FsdGVkX1+xtDjrUE+IcytAyZyNTUQ2rbJpu1ogVmmQLNrwzGeUPoLXvMwIxDEGxrJVLOCE7SjOfTTl1AG3c7iZr58E0bEGU/SVpJ0T6OXcP62QYvDqLDN+D+4erz+1jBca3LX0RJ1q7xGAbhcnqRbxfO3Fv1fgF2REU+Z8sR7PjnB3aAGNgTGvYBY3WOrHRJbgxZrnQBzybGg/8o58zhdIpxaDWUqbwrnb1exMTfXoOqshasRmURI301eBYBnfsb0yngbIrExxIEY3z7oNmmxravd0s6n1nnwpkTgPlEWNq0zw5UMTMDfH5Eipkytb1y+tBQcdalkx3TNOe6aeWxWHKksWl9S6s/ccIQgn0BfjEygZGJDZ86l45EqWJXUOnNjIYbsu8GaWO+KVaWMkUHBCKh2n1BimTD1TMHZdCUlSoxDe23En8vzDBEYrctBBABiyhc1YteVWfLp5P9PrRs3/x3Pq+NvankwOcNLO0LzrnxdApAFl73jYZIgiPaGZsNoICAd7Sqyw08x9OBQveWLFctLZIX1hobr1QHgYwqZho1OVB8aWLOst7nUAfABUDABefTOlkluBTyJ0UVgwjp/lmCepud/5dPR5L5s+bwlHbmpWuzn/AZ4t4eY+PqSFJYwIxxPC4BLzsOvcy7QfMpPyoePwPMTnNv9rjlWElkAH73hUia5Q8jBt1pDmH8IOYliZjfuiZJalBYpQrDRkD3z9FO/SjT1rWIbYOyWWfiWG154eiT55IBWpwxYQp7KiWelugx09kNzImi+7bt2+WSvnW3mhk6SMyihfNiZ5Z4ZuNR0fBNgy7t8n81O3kkIknkMvbuwfZKEuWduVWagt7Mw6MH021Vy8A6veJ3ZiNyAD/yr2wMunycBhBzpGBdn90eBARMQopeINeQEmqAs6nTsZEDkpVK1IerRRb2ytLZlxfHKP22O6I8tlQC4EsY8LyeQl1j1wI2wxMz1q8cn
 wWQ8m7uC
 C7J6BUhhTGFU4/amMx1IoPCc8z9IsE8T174ldftJ/JFojbp+t1jZRGiOnoptBMGPaiPsvQQ2/o/8NVznf+nNlKv0Bs9XI/7oSLhdPxM4RXeyaLPnU9LhV92Cr+kSwdya1q6D9p7smpB4Qy5+c1bX7feBdswf95UGB1NPZmZmrfUxqpGPY87FdhniywXLQDRm4d5onew1wETGQDGUK0U1xMa2gWE1uzuR+h0LJ0Z0CuQs/lDnXve/ht0tIKPS9XVuopFfJfxcEViy2ozG4Hjm/C4HBKFQWSBxYKasyPs4cJ4k71n56BkpNtD/DADjdlPMn8ECkNg+vlD545ZAGcHZ9AtpjdSFyOXvp7HIA+ZCLFs/u8N8nLbuPrGC7cab+DCXrqRAoCjTuHHtohXzFOU2DqW1Ss97m+A52v9tipJe5QuKA1qJuXYgrEAIObil21CDtY1t5pTZxHseAG/NQZJkqfSD2hp7huAZyFOf4VWuWrAfzkqJRPT7qFTr6eIWqrMmsFXuoR4AqivDJ1XXbN8VxJJNM4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 09:10, Lokesh Gidra wrote:
> Now that rmap_walk() is guaranteed to be called with the folio lock
> held, we can stop serializing on the src VMA anon_vma lock when moving
> an exclusive folio from a src VMA to a dst VMA in UFFDIO_MOVE ioctl.
> 
> When moving a folio, we modify folio->mapping through
> folio_move_anon_rmap() and adjust folio->index accordingly. Doing that
> while we could have concurrent RMAP walks would be dangerous. Therefore,
> to avoid that, we had to acquire anon_vma of src VMA in write-mode. That
> meant that when multiple threads called UFFDIO_MOVE concurrently on
> distinct pages of the same src VMA, they would serialize on it, hurting
> scalability.
> 
> In addition to avoiding the scalability bottleneck, this patch also
> simplifies the complicated lock dance that UFFDIO_MOVE has to go through
> between RCU, folio-lock, ptl, and anon_vma.
> 
> folio_move_anon_rmap() already enforces that the folio is locked. So
> when we have the folio locked we can no longer race with concurrent
> rmap_walk() as used by folio_referenced() and others who call it on
> unlocked non-KSM anon folios, and therefore the anon_vma lock is no
> longer required.
> 
> Note that this handling is now the same as for other
> folio_move_anon_rmap() users that also do not hold the anon_vma lock --
> namely COW reuse handling (do_wp_page()->wp_can_reuse_anon_folio(),
> do_huge_pmd_wp_page(), and hugetlb_wp()). These users never required the
> anon_vma lock as they are only moving the anon VMA closer to the anon_vma
> leaf of the VMA, for example, from an anon_vma root to a leaf of that root.
> rmap walks were always able to tolerate that scenario.
> 
> CC: David Hildenbrand <david@redhat.com>
> CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> CC: Peter Xu <peterx@redhat.com>
> CC: Suren Baghdasaryan <surenb@google.com>
> CC: Barry Song <baohua@kernel.org>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


