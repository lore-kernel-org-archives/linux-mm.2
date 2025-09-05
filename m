Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1BFFCA1012
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 03:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A13B6B000C; Thu,  4 Sep 2025 23:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7790D6B000D; Thu,  4 Sep 2025 23:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68EE76B000E; Thu,  4 Sep 2025 23:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5778A6B000C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:11:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D899FC04D4
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 03:11:34 +0000 (UTC)
X-FDA: 83853721308.18.169E28A
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id B6B2C40008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 03:11:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OZgisK41;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757041892;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWaRxsA3F2axUU+/K52ANbDJ4QSQJNANqGCCZURMeaU=;
	b=P6Uaz6ZIs9VTEwjQtmLO53Wm0YDm3zNTKWFZV62NpJqvFfQQ4nBJOqI+3lRsnVCyPqQat5
	SSlJwGljQdwoSGNoCggkP7T9ALtqqf5Pcex6akLMmMhTAPxHmkH3hkT1kp3oazJ4fl3dbX
	UYrwR9o+etTr7Oh1etlot5SbW7M9rVs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OZgisK41;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757041892; a=rsa-sha256;
	cv=none;
	b=tHO1OF6/jt0tdgrbX5x2moR2XmO/Kux+d8WU63nhtNs1EHyPbPDf4PO9vNUmOCI/6fazLO
	5gZNle70Ksb9snCHqn99rHfVsX3X5hIeHrqDnppfKq9Ln+VZ9lPTe2Cy1L2RfQwNSUL7uC
	b8eipUy99PzZ3Kw2sfukhbQhMNZi+S8=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b04770a25f2so251968066b.2
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 20:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757041891; x=1757646691; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KWaRxsA3F2axUU+/K52ANbDJ4QSQJNANqGCCZURMeaU=;
        b=OZgisK41cibqsltRio0yr5Gz0FlqVNkjrzfiWhBlfGRvTJY+tBANwR0gNF0DoO+U2B
         m7zSQQVm7NmZkI5AnbgWZKzicRP48odE10Ke1qmENQkcf2TDVvlsIvwVu3rbchT0X6xY
         jKJLiAAzCDcjmvuZKvIzuKhCLd/ZJ3hEZyKTpMQEGUiuv/ksYA/cYyEnIPQEfV1yVUzd
         Hi8piqDczdtTzfR8HMBw2I9nv5ow3tE000ixdMb5fHDsieLTiOFS9POP0/Z9nUIN9dFA
         shbN61reMiiEcD7XjIretGEJz+zcy9RJFzGGoWeryJslYgRLID11KDfMZDfQF06IyKoj
         pyRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757041891; x=1757646691;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KWaRxsA3F2axUU+/K52ANbDJ4QSQJNANqGCCZURMeaU=;
        b=Ryb6VCu32qG/pVOpPdzyAKVVkqF4v9wA0epiqdayA0eUvIWZ896pcppTt2q+utJwpg
         fzUK6v2omgDigTIjO8aTHB8xDh4iIxgsq7e8RyxlG/6w4aUh4ZxEROsYzEYPmLJPsXrg
         qaxll1S0s15ROjm+C1bIfQfCgNRAJkHHXbMgzhEyTFFzIKWXQ1YlqtcEoGOokHlXpPCO
         2YpMCAh6OQ3EI7CLNQCbHceUOqOEb6gJau3ArEYMXkjMXszrEALC+mbbmycB/qntk/fv
         My1Gfx34ESMn+vFgs2JLurIdrwIy0/eGn7et8lnNh3Ywwm7otFQLTgiaaXIVKYgoO7Oi
         QnzA==
X-Forwarded-Encrypted: i=1; AJvYcCW9hGPah07Xc8gnr3QZlupopv5eivQzu3WOuWliNdOGX9dnJtdtzF3IWPQgV3yV9xg5Gxq+j3P+9Q==@kvack.org
X-Gm-Message-State: AOJu0Yy+iZZLFOi1RKQ1oHXUdTZjaAnhctoubOVauVYnXMrD3B1cPQG6
	SzF2t6pR+7Xlh/1iTtkIZCSeyv814XDVjhkZCafdU402QC21HayKuE4t
X-Gm-Gg: ASbGncsfBtfaQsm6sc6xGXOny+3OMqSn19OGQ+DkeKflaeuXlF3s3tzoeKQJoCvuxtx
	WvEYsitg8M12xMr9w6BuM/MojzDIPjVXRGiN+Jo2l2oS5qWgd+bsSBV2C0+IIhE5UKUy0R6mllh
	+w+jQZGqtGyBHr6mJWymnm7bvqTwQMpbntIpNS6DjCB+Y+IUyk9SD04zQi5tMa8wU0vsQPFB0bt
	XQbiW/M+b2cP0wjkMmQiq7gFG69vfd6BEvlcwgjXyCgpqGFuMl9wHwGzIdntCuCGy6ZlHcgP5pm
	PfrrH0hZbnNui+YUaeEWp7ZboC5xmSR/bWM4h3ljVkryOoIyqEZMbAsfEikE3f/XmpSunrxeqR+
	O7Jdo85GE5vLIipKMKBOlfG+3Y5Td2BGG4UUzD3hguWDvLSc=
X-Google-Smtp-Source: AGHT+IEcZ3ujwlH71W34C1zM/U/SOot9iYckovuspsXjjvvAeLH6b0D4EeeCZIYr1VeTmTbzX5yeIA==
X-Received: by 2002:a17:907:9815:b0:b04:3a69:eba4 with SMTP id a640c23a62f3a-b043a69f41dmr1642370366b.39.1757041890864;
        Thu, 04 Sep 2025 20:11:30 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0471c7a163sm445469566b.47.2025.09.04.20.11.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Sep 2025 20:11:30 -0700 (PDT)
Date: Fri, 5 Sep 2025 03:11:30 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm/page_alloc: check the correct buddy if it is a
 starting block
Message-ID: <20250905031129.lgipzjwz2swhxlg7@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250904020654.28689-1-richard.weiyang@gmail.com>
 <D9D94987-8A36-41F0-B0A8-3BB47910223E@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D9D94987-8A36-41F0-B0A8-3BB47910223E@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B6B2C40008
X-Stat-Signature: s1z1oqakgyd17xdxqf3r9j156oopkufk
X-Rspam-User: 
X-HE-Tag: 1757041892-665413
X-HE-Meta: U2FsdGVkX1+tN5+7jrHw++5FpkcKnaGs0XhfPeugjEjmB31IVFSYjaWFWj9u+kfazzLxMiDfOxwOnaUNeG7wLlnvlJMU4VyIBEMipz/lWNbgkhLhcztD9JlKqGz65dIjja8c1LBoQOfXqgCm5UuEYeX/limW4MSGbFyWK52JIgMneDAfKBLXfmiDWU3FVB/jegC8Hm71lm1mzOS2mzh+B/ReRHXY9I6wWmm145x6jWScPsqrVVhQAOK4E05jhKsva5LE+Ld5bpmo4ljRZ52lgcS7dt/rnBvwE73x6oJfAjkgC1qsBrVP0ibdPOz7sxaKdEdNIhyEF1BF4uUcARtUYUTOPfWkfYryzcUMxHbn+ISX4I9PUZu24eB89THdws4Wn29kPBtqJ04M4J/vh9p7ac+tlhQW9b2ZZ4ZQMNu22eIPFpnbpjQWkGT3PZvrjmjNV0Xi/R44IX6xerwb/mHR8sggyWiXMUoxhLBauOXibLQDHpz4nH7qA6xgZ/BTCcMtNFfgLA8ZlXhjrNqUnxx0TEWT25m7pcoOTrovtO6SapJpY4W28fWuZJn4rGZ1Nf7aBn/SbVk1GAdaT9M0Ovl0K29dDlpnQePoQitAFhQIn55zHb+fV9vG2+mcZdtu2Vmo7z9gbvhMNMBxkcPRkiUWkvBxJU+TD05zbJDcEwHEUyQwwNxDBNFsGiWOVoO2J59ya9ZSqjfbuaH1csK4X8gv3QWXl4okY9oBPPOtGLku1/MDbiZtf2wcXLB54QjIc/ZFnEseZt+qc4peJYP7q8aqpsCv37NaHWi/Xqbq4szWvLMvr3q/JAVor3s5qi+QqcnmPoBspJYfq23N98HyKiqoKjfnmYglbHHkCQHKDm6z+CASpRLt1E7s45U63Z5n2FO0XwlO7wmLuR9emqRTyK7p1YlYzbdScLhEgnuuF1whqhu6xSF41/wR9XQz0x53oZaKOK93SEoGHrDoQHnxGsS
 6MqYEmtS
 F0uaNfxV2hLj3lrOVXUHqLH9MQx105678d3G2N/gH4gt01OXvGjuzlXHT9rY/n+UIYivXIGjNdLGwGFHBRcQOhvVRdbePeK4XswPZz0g5g5LVITkdsMmB7rY9GSzP9rEf0N5G5YFjzO8CIgckr8hiL3LP2TxO7ygR4sLm4tN2Rya5/h5wkM6D8hVwdYf2jTEkuabNCRdd9btAAJ/QxGir60alC3TnB56QxtWRHyNJ9hnbkjx9IYnsEbUTmj/Ix87NCBRqcDMy9A6GhN7gZWXluwQ2EZ07W+CL+YfoM+Ay6TAIbOj0L94osRX38+REHTW9yslWtqNkgX86goJyj8tOHVblUdjzVPYDfckJoOsAVp5pl+GDYbH6wXjmwJfuaTW3GZ3IwqOQ4dyfEmz9/hP3EtRiIRzcAvAHCzcnffYFt8a8leD+mBgWebMP9CarFatfgqjxiTz1+qz54gUp21QjTuPiAxmQthxFEIaPqM7REjk1+amzWbAoXvBc7JDxcZAspvCIJH9WQwe2CXzyq0sDru6U8uRNq+hClkBs1bPOZxIDckOiYT/dHMtPwySfwBVLYXXC+l+WlLau74mX4qwRKtagyzbbMoBnlY4eVm8J+wJYGWVwjCyYmcTEbKt7j8ttctLU7Vos90gu+WVQacZYYXKKbi2eHWvZm1JlkGmpTRy+MubTPZuAZu7FM2zCHtxXVCPBm+xjN/ngklO+3Wa/uxg2/Km5teLWpKnmdCHUPGwYAq+FHBuwKE9oz+8c2wa74MqwJO4BVKPFKjza3Ixjyi8zggmkFfZp6RFdwD3fGtIbopfU+8X6jxDxcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 10:01:01PM -0400, Zi Yan wrote:
>On 3 Sep 2025, at 22:06, Wei Yang wrote:
>
>> find_large_buddy() search buddy based on start_pfn, which maybe
>> different from page's pfn, e.g. when page is not pageblock aligned,
>> because prep_move_freepages_block() always align start_pfn to pageblock.
>>
>> This means when we found a starting block at start_pfn, it may check
>> on the wrong page theoretically.
>
>and not split the free page as it is supposed to, causing a freelist migratetype
>mismatch.
>

Thanks, this is important.

>>
>> The good news is the page passed to __move_freepages_block_isolate() has
>> only two possible cases:
>>
>>   * page is pageblock aligned
>>   * page is __first_valid_page() of this block
>>
>> So it is safe for the first case, and it won't get a buddy larger than
>> pageblock for the second case.
>>
>> To eliminate the ambiguity, unify the handling for starting/tail block.
>
>To fix the issue, check the returned pfn of find_large_buddy() to decide
>whether to split the free page:
>1. if it is not a PageBuddy pfn, no split;
>2. if it is a PageBuddy pfn but order <= pageblock_order, no split;
>3. if it is a PageBuddy pfn with order > pageblock_order,
>   start_pfn is either in the starting block or tail block, split the PageBuddy
>   at pageblock_order level.
>
>
>Otherwise, LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks.

@Andrew, if not bother, would you mind adjust the changelog?

-- 
Wei Yang
Help you, Help me

