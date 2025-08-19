Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02A1CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 07:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498F06B00A2; Tue, 19 Aug 2025 03:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448F36B00A6; Tue, 19 Aug 2025 03:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9496B00A3; Tue, 19 Aug 2025 03:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 160676B00A1
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:33:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B3F90117417
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:33:58 +0000 (UTC)
X-FDA: 83792692956.26.ADDEC29
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 71773120016
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:33:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AfXwkpzF;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755588836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HGYaHU9kuiZzGF6yAbjynMbTPd773QG5CM75V2XmaU=;
	b=pfvqKfb7GSOG1y7CjUk6DEEwl9BAHWgHlVAcpfSrZYMG6glCcMsFobNjh5jYCfdtuOFp6p
	mYq4FuDX7ChqywUZwaZv/wB33u+Ppjx4e2hSPhWLn4+vlVVPPdh3+1j6GUB/4yFGBdUiKN
	tkF3GKegyNGW17177wyj1s1sS7hWOJw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AfXwkpzF;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755588836; a=rsa-sha256;
	cv=none;
	b=IHSYKUUtHgoiz7RUd2K6NtW7+c/UGWIYd9Psztp19jvY0F8+73Sb95XYKmVZSk8mFyeabM
	Ja+kX4QCS8Mr042kE7h61zh3bePihnjVWVPPAYkNGhZ2uVAxVxiZCMI2H7GoMPVqIqMp9a
	xMc0qppeNbv8fMsDBp46YqELaiScczo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755588835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/HGYaHU9kuiZzGF6yAbjynMbTPd773QG5CM75V2XmaU=;
	b=AfXwkpzFql0x5sENicK+FoGiOyLNYAQ6gEUem5k7aQUS/ElxOdnPAvBc6ckVuEau8TZdUl
	sRWQVOlm+buffdxLKHKd6OoLSPTboDXuXUH2Kjh8walt5UU7et0y5+tGgiyGs27kk94ckx
	/8u5XmYJXEV8b7aFihrahIcttNmU3x0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-w7ULH3qWNHi7Z9ZQtSpn_Q-1; Tue, 19 Aug 2025 03:33:54 -0400
X-MC-Unique: w7ULH3qWNHi7Z9ZQtSpn_Q-1
X-Mimecast-MFC-AGG-ID: w7ULH3qWNHi7Z9ZQtSpn_Q_1755588833
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05d3c4so31546555e9.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:33:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755588833; x=1756193633;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/HGYaHU9kuiZzGF6yAbjynMbTPd773QG5CM75V2XmaU=;
        b=aXXM/GrQZS7BXbi4o8zVsZPSgA6jqPgF/NTu8lDE7EPhJkm1plUrjTJ0Rb5HHarzRJ
         LToKqUfNYw/u3f5tICap8W8B9waiJSy4wW8iH3NUk7ljDB89CcuNqGVW/pEJGgfLsBLp
         YEq0EB1FIh7hLsEgTZ1r+2UR5N60CQx6+pdJPODfqpMAQAkvTrcOpL2KkMCNNC8Jo7oE
         MP8g/F4AgOFhw0GGp6pgDuc+fYF08aszVal7S5ydifyFF/+iA2OeBGPlQleiUylQvQ4U
         OD8CNe2cI8eiZ1jS30U7e6CFrv1wQTPckWkxPasF/UvZm6uJLiPrJxHcCWXLxPDf3GfM
         RjRw==
X-Gm-Message-State: AOJu0Yy3qCe+T4fE5sv+4ry1L6rGQ9mzTD3L/AiWuxelEErW7IG+UDux
	TTzz5fOjfcHLe+0WJ3LWQbuSDd25krFgUTygF/M+OPSjlSCEvxRuW5lHcpsaDJhgde2DoeGdWtp
	TtqPXjL6GHaCMMfsa7jRd5pfWc4sZGPZKvPMt6oinRXL8G+KwrYI5UleGmwb9NNQ=
X-Gm-Gg: ASbGncvK/K4ynJKh/lMFcqutIHA9A6DXkYX7iJU7I4HCqEV64kFbosyxkiFhBhss+D6
	erardQg+FyHlGtyjOUmlNdGfmvUrqwtl3HhFisiyNJAsUTj79muYzqVTwPAmBRDMNqrLGVbVAjV
	SS2LnCZqz/Q0LVTWmYVg5E5Y5Bcv4NNyGYyQXyjrOBLK2xhqUi8zlwsqa/HXrQ/Vi5BL6R0Qqsk
	ZLsGCsP+z0rcD56C5Mtg8lzrYBlowpr1tw7CiMR/kJ4eyGmvIBALhvUM5CIIM2X11aFr9+8eFgl
	8b5cQEETJMbtVzPkAQQgOIJ11ZvV+EpyGWoDXH0SYI19p80E0UMH9lVjU38HhazbV4V8CBVjn2m
	VMLpPTWFa/HJo6ML6HVrgUbQ0kGU3/sWqsy5L66DvlxaSnqxa1l+i82D0xkN7f000Hio=
X-Received: by 2002:a05:600c:3b25:b0:45a:236a:23ba with SMTP id 5b1f17b1804b1-45b43e00b52mr10917445e9.22.1755588833144;
        Tue, 19 Aug 2025 00:33:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHAZTBDfDGb9kB6qEjLtHFg3XabkcqA3t8pGaVH7C0rdmn9M5ldhOM4WNjuzlwtQb5eKHBz4Q==
X-Received: by 2002:a05:600c:3b25:b0:45a:236a:23ba with SMTP id 5b1f17b1804b1-45b43e00b52mr10917095e9.22.1755588832681;
        Tue, 19 Aug 2025 00:33:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:8700:71be:5385:87b8:5a98? (p200300d82f07870071be538587b85a98.dip0.t-ipconnect.de. [2003:d8:2f07:8700:71be:5385:87b8:5a98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0777892f8sm2450088f8f.53.2025.08.19.00.33.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 00:33:52 -0700 (PDT)
Message-ID: <1f8301ba-4c2f-44f8-a7bb-1512768bb435@redhat.com>
Date: Tue, 19 Aug 2025 09:33:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: readahead: improve mmap_miss heuristic for concurrent
 faults
To: Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
References: <20250815183224.62007-1-roman.gushchin@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250815183224.62007-1-roman.gushchin@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sZdbWdNmu6bDvZHH_NV8JHEEkFx0EEuFOWwXVo6M3oc_1755588833
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 71773120016
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: iadqimh67qdb6qips5nkudr8rpgpguwq
X-HE-Tag: 1755588836-645479
X-HE-Meta: U2FsdGVkX183gWgf9V718kk+FLktsN3r4+o1AhQ7Z/M4ACF7mOUOVw70w4WP8NJAXugnutV3OBT5PZoeeAZOLeKpqzyi3SM0S7LM1UwDG/TSpLk5zfcGqpl7Po524Xp+NGE+gb//uCNNj3gVpJIiETgX2CC+lZaxDz1qEVMVD19bZlAv/mM1Uc4TuB9JFSciazfASNpH/UAhHS6GmgOiy4aPzw/7KsEeUq4gfKkg0uHdco/wS7KHVxETfysgAU0AfjUDtBvel0yKpFT8Ut7j3AFX9FpRT/p7LVx0SrXy/ataoPSAFK9nnFSpXBXXpWl9rdOBunVfUeHBx3qPGuer14WZNuFrOE/yAjxfAIv2gfQkEkofKxD8aDuenelNEy7RU17WNE5t3tPM9fPZ10HsaliSXVeyDyyXGCuilsj6I0QSHyGBB8Z0nMh8DZ2Boc/SQxYQ6aAKjqAysJYbnCA7OXgK6D7uPGwhETPjNawnMs9uANnMBC/xLV7oJFcVSZLU3Y8/CPQVy7xmUZPgtlSkgRGg8oKoXTDZZMyvVBq2QcGKuN2c3ufR6opRgZpi0igyAZkGMcIteuEI+dBnp3nI2HZYjQdKgd3xGmy/mhfNrzDNAuqQh6Of4LkRwC6aLmFI9AH8JN4yyL6gedQsZdxpKNsx1P61KxDxB3TBd7vowiK5wurzoH+18kjg1QNFZzi3PwqqV0q3Jfiu6+KRpx6gKQgFbeF7ewjvo/cZvu0xhXSpgsJaXcshEowYuKVC/Hp7iBhDUKWIBsOek1E6GgKW+MT4qNI2YxgOTu0Vh+m6K/SX+C9e08hGh7TNz3AbealIFr9PLtPmNAMjD5KkY7PIj7ACgaDUCLMOHkGqdZK3BScsc6TPCkA23dO+FUNu9qfohR2bRlTB53uU48lcWy9JA9RrKloVse4u55cMJYJPo06oXC1kxJzLQdUMLUsfg9a08+EJ5rIuuUneq895GMA
 SX3NjPuj
 0/eleAT5tnYbi4piujwiHe8ui8DFsFYPSNuZy6R2sJibOafN7tQMFnrwjZQlG46U2F+sPV025ko4BwI5UYHk6BZqizw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.08.25 20:32, Roman Gushchin wrote:
> If two or more threads of an application faulting on the same folio,
> the mmap_miss counter can be decreased multiple times. It breaks the
> mmap_miss heuristic and keeps the readahead enabled even under extreme
> levels of memory pressure.
> 
> It happens often if file folios backing a multi-threaded application
> are getting evicted and re-faulted.
> 
> Fix it by skipping decreasing mmap_miss if the folio is locked.
> 
> This change was evaluated on several hundred thousands hosts in Google's
> production over a couple of weeks. The number of containers being
> stuck in a vicious reclaim cycle for a long time was reduced several
> fold (~10-20x), as well as the overall fleet-wide cpu time spent in
> direct memory reclaim was meaningfully reduced. No regressions were
> observed.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-mm@kvack.org
> ---
>   mm/filemap.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index c21e98657e0b..983ba1019674 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3324,9 +3324,17 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
>   	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
>   		return fpin;
>   
> -	mmap_miss = READ_ONCE(ra->mmap_miss);
> -	if (mmap_miss)
> -		WRITE_ONCE(ra->mmap_miss, --mmap_miss);
> +	/*
> +	 * If the folio is locked, we're likely racing against another fault.
> +	 * Don't touch the mmap_miss counter to avoid decreasing it multiple
> +	 * times for a single folio and break the balance with mmap_miss
> +	 * increase in do_sync_mmap_readahead().
> +	 */
> +	if (likely(!folio_test_locked(folio))) {
> +		mmap_miss = READ_ONCE(ra->mmap_miss);
> +		if (mmap_miss)
> +			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
> +	}

Makes sense to me, bud I am no readahead expert.

-- 
Cheers

David / dhildenb


