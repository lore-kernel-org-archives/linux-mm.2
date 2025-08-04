Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3187AC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 18:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 529E36B0093; Mon,  4 Aug 2025 14:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5023A6B00A4; Mon,  4 Aug 2025 14:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0EA6B00A6; Mon,  4 Aug 2025 14:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB986B0093
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:50:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B57A416096D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:50:05 +0000 (UTC)
X-FDA: 83739964770.13.8F9F5B7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1AFABC000C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 18:50:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aiKY5AaT;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754333403; a=rsa-sha256;
	cv=none;
	b=FwB3ks2xjWPzRbc3OYCLhv1iYR4WN223zRUFJg/EM3PH9f+xJEj7Uo9F0v9OGKh7J25l2o
	P1dLNQ5ZnvhWmboyHg8Ad54+RXAKm+hCQr12RNSTqqHMXKVyo9T/NoMOEQZ60M5GSsqXlm
	XOTl7+E6gTvksHGipnUL1UpVQbRSJMA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aiKY5AaT;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754333403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7UUfiKeOYlsuGZHT7CWAZbKMNooPk/lkfRZ63Id3bE=;
	b=kGAvJf2uvgSQbv9ZK5CR8YmT0UjsNSnh0mnXW9epe7jh3tMekTuU2V9QGo849bOkSAeHNC
	lzd2YPgW6m/9C8PZFXPBvQmsLjfUJbXZE0+SJ4Wkmkk3H65huEAKSZLZ60SlzpZ9xe0v8V
	Hhorq5ToKNtBXjlFlI5AnYOuzQ4AVD0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754333402;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T7UUfiKeOYlsuGZHT7CWAZbKMNooPk/lkfRZ63Id3bE=;
	b=aiKY5AaTebe96qUKti9EP+cEEp0/CPwS0KMp5IFHjcH6Plw9a2smwOB6744xE6ZKvpHNWX
	LVftDXXir3RMho9nJNyksZAHDFN9VBG6SGL42AOkLKhFr6EBpzGAyK/zbDNUMRvUbAMd4k
	Acw5/MaWutyt2eurfaTra/Whf+2LZ6Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-Iy-TNkguP7inmRyC0JqmzQ-1; Mon, 04 Aug 2025 14:50:00 -0400
X-MC-Unique: Iy-TNkguP7inmRyC0JqmzQ-1
X-Mimecast-MFC-AGG-ID: Iy-TNkguP7inmRyC0JqmzQ_1754333400
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459dde02e38so4947335e9.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 11:50:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754333399; x=1754938199;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T7UUfiKeOYlsuGZHT7CWAZbKMNooPk/lkfRZ63Id3bE=;
        b=Ly68B4J7rjYHZ76l7n0dnpLnIw+GbT7soTky7iOkgijvQIRylRZV4ek/E1+ieeop2I
         quRAk6vqkGSpuJ7xrkYCfssv1oAraW1mbqvg+40CzZrVOTORT2vo0gNZ0ynuUy19sMn0
         Sz4rTSoa7LIYXLf2sf8CKamR3BDvgSf4ifjWkIetrZV1Emc5ksqL9c6dLlRSLWb3Wz4I
         SWQcukUY6h1IBn9p5GZ9xfzWadGhAyji6M3KuSMB2Xvw8MCoRSRr+pGrRssSn2O/MIpg
         8Knv3WQgx/7/NAcPnhlDSKmVtML8b0RAYkl+hjjIWsk+DPNgZmxViwPIf4voa1Mjjnq2
         ub2g==
X-Forwarded-Encrypted: i=1; AJvYcCVWQkwk2uZ9TOHX15oYQjxLTcimsCzKKJzf5j5XsTIqjXi4eW1FaACeMVpKaJScSGjqLP+tS+JwPQ==@kvack.org
X-Gm-Message-State: AOJu0YwC3UkjthTkvn+uXHjShUMMCmiAzQZ62zpFgdGxwKUg9B2qIOYw
	MYc/xCkX6XJLD+7tpT/sQiXR88tHhUFVWiUjXipa/hyH+gvmJs2WuUf6KJGzTkbLYR4/RkDPzGj
	PGFJJkIOe88DpM4ZpRrai5F1J/i4L9/5OqR43AK85Bvaw8/CKlHOE
X-Gm-Gg: ASbGncsYrbzIIu9U0cvPDfm3urai+ozVdy+drAsNpg6jSjJlDurJdg0bFw+XaShKEu4
	cj6OhSI7gh5/UHWD3gLx9fw7AjX2ltkwc+LXnlrJ9an3v27Mqzm3KHoN9HciiYGbRTIhDkX8/4K
	XrT3l3ITBDpTpnscPGcNX8x6zkzgt2gzmWJ0AbPYR11phC2cn8yCZCDb9WEsoKIOictea+vDb0R
	bQ2A8R8zdo9P1QDXTijYQYTLfUh/S5TW9Jde1159UTKXVI4tc37BO8t8pTo6joFC6ASQJ+isAAw
	yFgj0sHc7ZBmZM1n9TpPduXQA3bP2CWy/Aon757yuo6UuDdGnRQxOVSlfrBYrX6sK+BqYNA=
X-Received: by 2002:a05:600c:4e10:b0:459:443e:b180 with SMTP id 5b1f17b1804b1-459443eb330mr58589205e9.8.1754333399555;
        Mon, 04 Aug 2025 11:49:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEP5GKxPERgMzvVb32ee5lNTwOD6PwhOAZJzd+FoxhfvfxFD7V+1+8Wo8Q6qFIfAKQ4FNeWAg==
X-Received: by 2002:a05:600c:4e10:b0:459:443e:b180 with SMTP id 5b1f17b1804b1-459443eb330mr58588875e9.8.1754333399118;
        Mon, 04 Aug 2025 11:49:59 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1f1eb.dip0.t-ipconnect.de. [79.241.241.235])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c47b10asm16101568f8f.60.2025.08.04.11.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 11:49:58 -0700 (PDT)
Message-ID: <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com>
Date: Mon, 4 Aug 2025 20:49:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: Juan Yescas <jyescas@google.com>
Cc: akash.tyagi@mediatek.com, Andrew Morton <akpm@linux-foundation.org>,
 angelogioacchino.delregno@collabora.com, hannes@cmpxchg.org,
 Brendan Jackman <jackmanb@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
 Linux Memory Management List <linux-mm@kvack.org>, matthias.bgg@gmail.com,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, wsd_upstream@mediatek.com,
 Zi Yan <ziy@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 Isaac Manjarres <isaacmanjarres@google.com>
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ow_I-JWnPm882VM6AiCYgwfnQEA3eHQWP7VPtLgCFy8_1754333400
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1AFABC000C
X-Stat-Signature: g6mhh49ykxn8aguugzm69uzbfegdsajd
X-HE-Tag: 1754333402-426632
X-HE-Meta: U2FsdGVkX1+6TlXxvnFrImBhC7h/SleEVJoZOrco7mNYmJehoP1Ft7mLvF2qNxR9yI89nDUEECbGTJA7kbLEfsPbKOlhtihEbYc9AZKcOaVBLjPShT10FaU+SQdDIGbJlaOB7DCz7K19gk12vNCn0KlMuhn3GMCaDtoWJbjO6VJLJgdjHHioSBqu0OTPoT2dTa+MJvOFvAgSpL0vnEMn99Mv5gewEcIDq89JHzhBy72iWyVFl9ap+0kqWRYVoxes4dH17x5g9EBFSn5LonlXlnahe9/UYorYxyOLJ1NgjSq9ZKawI24Yrf4S3XtjdrS0qq7ufOqgZJKZPZxFwtC9gNZ1A3fwkXBQVeabD0RMmbZrWHIL5P1q6VJe/hweOgZiaGWUPhoV/6IaUh5JYBW0fXtEXnzmLzrMUzSBMP5TFiQ9CYCoILDUxxGkuzQ9x/TxSNNegk0LxgPWMNenrT3CAFTu0yTDD8q9zfQVzYFFCRagP5e8I+n8DXZCvFj9jq68fpZSDeUrrRZYiMB8RgmIUhMRwqEJUd0xgb0/fh4DENDiP5IMOvatfaAbN7Ic7OicGF7NE1Q4w/UShRSG4rykXfNGQgZz5KT1ve/pK+gBPimTlqcCcbjeqNUcHnt0K+wDB/RjvCfbYNv6uB4Wpruz6rcKkEkePgpSP3aS/0JkN2LQ5SvEDnX9a69whjzNQorp+cACwiwFWmJFa5kFBSWJbmwSh4ThGUpyI7ESXBs0Ii/a6XnuXndr416X1FB/ttToArUKIarMv+Jo+KkTAoZSlHki71CcC0+r2zM9Qprl/gtKRJkp6zKK+Xb2s79FMSjvyyOsI0TmpMTQRzlnF5tmjkWt5WN2PH+Zge8TWD67PPmNl2hhG1qNk8W4MyVUat+5S1Tp8V1Y6LgW1TCJQzt1hs+iAcvdLJwy7yd9SnDHB5m2qCg6urnY0IJkmaLYlH7SWixaydLx3HrRTSIZG4T
 16sD4W2L
 KViVUQEEMR4VkXvAhQOKSMVXud8QI4XjF0seWyXzcdnohUJu0iOWliKF49c8q7ekzpKmDy9MjBky7Pp6G7MYGv+T+S4nJPiNmenGwMQjgu6dCAZx8rUEJiJNo/ULo5l4qMgHBosoe/CwGpGuJXHnmbGh5VSRFFVzMH2X4XKdWiP1QAsgpXyJaGX+gbhCS1nYwzgzo7TIbT0pQ1UE1IGcTVIRWytpbbcYKe0Feu92SOVrnxyjugIh/wmpWuTcD6oRGCLRlh5O7sSz0PAP64jZ7Cm9gd0ZrpB3xTkN0/oNqMKMd6bEnPScrLclt1fBcEfFXEmBwEp971x4gKB0cYJqdnnOLikHLXky57RnkHnqHlRYByRdeNs9FWWFOnKRna93F+5wUTymn+8Rm0IN0Xq+QxbQqbHyygeFwxIHKnpGIY+l05jFuch3vSB2k2KXliOeTePp+vxeSPJ7mGvHsBaiL6aBo/i/DrpXXg4xDboqHd2QyxvyYT/mUN6y0Vr2l6kaFMrwk7ykHKxXIU/KzjpsMgve5wXrDHzg7N9Ch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 20:20, Juan Yescas wrote:
> Hi David/Zi,
> 
> Is there any reason why the MIGRATE_CMA pages are not in the PCP lists?
> 
> There are many devices that need fast allocation of MIGRATE_CMA pages,
> and they have to get them from the buddy allocator, which is a bit
> slower in comparison to the PCP lists.
> 
> We also have cases where the MIGRATE_CMA memory requirements are big.
> For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to 500MiBs.
> These cases would benefit if we have THPs for CMAs.
> 
> Could we add the support for MIGRATE_CMA pages on the PCP and THP lists?

Remember how CMA memory is used:

The owner allocates it through cma_alloc() and friends, where the CMA 
allocator will try allocating *specific physical memory regions* using 
alloc_contig_range(). It doesn't just go ahead and pick a random CMA 
page from the buddy (or PCP) lists. Doesn't work (just imagine having 
different CMA areas etc).

Anybody else is free to use CMA pages for MOVABLE allocations. So we 
treat them as being MOVABLE on the PCP.

Having a separate CMA PCP list doesn't solve or speedup anything, really.

I still have no clue what this patch here tried to solve: it doesn't 
make any sense.

-- 
Cheers,

David / dhildenb


