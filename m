Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46666CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785386B00CC; Thu, 20 Nov 2025 10:44:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D646B00CD; Thu, 20 Nov 2025 10:44:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699C26B00CF; Thu, 20 Nov 2025 10:44:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 584F36B00CC
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:44:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A01F1601D1
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:44:11 +0000 (UTC)
X-FDA: 84131406702.15.12E993A
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 581DE1C0003
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:44:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="m/NFBP6q";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763653449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/ugw1qh5Js/ttrR8EDVGlYrGkAdfYtHHIqpSwNHbFo=;
	b=zQ72JEmRfxNtg7ue4ctHTucQj3m6IIb6nTJ1T1Z+gzHv1I51Zm8jHIRP1PmCknGsImcYPv
	/6D1QIghB2dZIvEPw3WKcFCZWauoJGJ+WWCsDPBeNuTxU0PtwAmh7HFBdC4M+vo/oQ9Hw4
	++ztizz+fC2qSZWvHOdqzdP5pn/SfCk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763653449; a=rsa-sha256;
	cv=none;
	b=KdvKtblaZvj12TKHS/8LAiopwXCicc9QwUmnvhhGPJI3zORoOHXakMrRxCxum8NPc9H8tY
	AGIrISyfOOTGNxLbHvxE4G708nKjxa8IQQLvRer/OTc9XAqUbM73a1KGb3/9fn22lzXXVF
	uuGvOzo7UzZNIBvsnsRQijprM2o0aTY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="m/NFBP6q";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4779ce2a624so9363945e9.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763653448; x=1764258248; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/ugw1qh5Js/ttrR8EDVGlYrGkAdfYtHHIqpSwNHbFo=;
        b=m/NFBP6qABJI0KKFgA0GSBloRLo+WOc4rAOodTI8gjuswYHbYUTQTSPsgLnp/EtGlq
         RIQr8MH3gThOl2s0VNn0Z8NCvgG1t6/D+pPvWpdmAMdBhPbOyPM8x0ygJKX0fAyZxGmh
         pS8ahUInKEIJMXu2Bq/PWRzRFreH6PVN2Xb0Qn25FxfdNehEDiM96iCn5K8wthC60kiT
         zE7HthQczVlmcxopcjuT4sTFQ6ynaKo5jxkUyDve4EJXjJZaE1skwlDUeFi2l5cn4Wqc
         1pAAYUHubA7RG5FMb6LmYYdMa98GJ+nGHgrNzQ86BBp9ZerOAdf/SDNd/nNmMTlCv4tZ
         vMfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763653448; x=1764258248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V/ugw1qh5Js/ttrR8EDVGlYrGkAdfYtHHIqpSwNHbFo=;
        b=cdcEzXlKBbF26/L1iq3AeRq0/Mf+nqMVB9sCpxVIiZpMhKW7/cVtapf/W9+Wwu/4l3
         kFVktB3d1BeuXK91bm70USL4DPD5Y0WyE8tm7GeeQHa6BKwwrF6f82bm5yGjwLIU8q00
         hGBorT2hyTux4E0gWNMHTNFEwot4Ri6Q+KiBCfRClVK+iKcy74aVItIp/YeZX76mQYzR
         2G6fSaTgyVwyNGLmogJlz7KcmBU8mSWH76zLGcc0Q807gdVg3rrDRB0geODsMkRxfkKd
         a4lEQFTSZJTbOLt+ujOEbRmejC53Sfiw5Fk0hyPtQ6dPp4D2aywoNB7prwnfFacnijFn
         H/uw==
X-Forwarded-Encrypted: i=1; AJvYcCUsBL4jL9gBc5KA+l8SZRUiAZNXsLwUIkv0BCQo0J3qSHqZiACiEjr06HgRact8Q57D03iypmMYcg==@kvack.org
X-Gm-Message-State: AOJu0Yzooavjus8+PU5YlPDLOexmEQ7J7K4Nk2Zfbgu4xXRd6WIgNDh7
	a+KvkxY6+ExJd7TDpmlNXVg8awrfWoZJcIIQ9YzGeMftJoQ6DdZJsQ9Q
X-Gm-Gg: ASbGncvBwxUl1324ou2WfShTW58xyMfjwS2dSSE31YKDoov36js72D3x+x633lJEz/Q
	YE9vr8eJd/DU06S/zTa72Zt6wop+Iqty755igBdggYuOqTNA7C0Qv0Zv3ML4h46mdHlo0nyx6zI
	pHQNYU5Ew3e/KMdvnrDQKlorLWsX0VbngWTGOrM8ucV8Z/YpnVYNCKpVG3DCaAJmJOb5jWpW8Do
	K8KoG/lO7XK8VDiQ61joHpcLkGWBA4yCwEAbFoJ2rvLrh6G4mtVNH+2aAKs1ln/ADYMuaBdnFU/
	85AE1m5tMsu4q1ilBgENNrdl24PMGJMbm6cJrmTaGWkvKPK5YXARa+3XZB2bYmMJcPEiLfXcpKN
	wUgxMwcEg3DOeB4NmigYaOGdQJMSE4hzpziII9tk7NL7bcuKK19iKLMDpEnfLcjFjihBYMEfGCk
	cckqxSqe1RT4+d4vs6L9S1tSS+lKJua7H5auLUhjU9xVVCANvHneQF
X-Google-Smtp-Source: AGHT+IHZscOyGXLMcLEwSzXG79SY8Qx2G6gT/YROcc1hUDKG1pZJxcFyYdrYEnvMt+Oi8xS02ts8rg==
X-Received: by 2002:a05:600c:450f:b0:475:e067:f23d with SMTP id 5b1f17b1804b1-477b8a98d52mr31212975e9.25.1763653447408;
        Thu, 20 Nov 2025 07:44:07 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fba20esm5977502f8f.37.2025.11.20.07.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 07:44:07 -0800 (PST)
Date: Thu, 20 Nov 2025 15:44:05 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Mike Rapoport
 <rppt@kernel.org>, Tejun Heo <tj@kernel.org>, Yuanchu Xie
 <yuanchu@google.com>
Subject: Re: [PATCH 39/44] mm: use min() instead of min_t()
Message-ID: <20251120154405.7bcf9a6e@pumpkin>
In-Reply-To: <e06666bf-6d19-4ed7-a870-012dff1fe077@kernel.org>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
	<20251119224140.8616-40-david.laight.linux@gmail.com>
	<0c264126-b7ff-4509-93a6-582d928769ea@lucifer.local>
	<20251120125505.7ec8dfc6@pumpkin>
	<e06666bf-6d19-4ed7-a870-012dff1fe077@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oxu9tk1395xys66zoxcktgfw5qh1sun7
X-Rspam-User: 
X-Rspamd-Queue-Id: 581DE1C0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1763653449-937993
X-HE-Meta: U2FsdGVkX1/u3/6bPGfnbRswdMnN/i2M9+Q7m403egmEg32rTHhy66cs4zqpxr3qFOOjFGEBOpGJqdh3O6PNF8mzEODSrgua0e1EAT0xdpad1PNVwSYzvGnXs94bVhnxVITPGJ3GiuEqLY0aN3aeQU1qESlup8Bb253K31aIZrx7phZhmqXmARDDx3RTCvLlBx8h3CVr3//jxitn2CDHDIBzUWW5WyuSTU2XDc1/aUOpMt4MvF2g9Os6Q0cUlPW40QtQgdRbR8cff3Yj18dTogiDOHaI35zAoCAgERa/zTknWUzlpBCWtoSoLyjS0PZ1069iC+m6dFF5AMcb/qbKQm/IOgHLJBvNNcSKEJ6Ul8PP0V+/VSUxC/u0NTGdrSEoBIYnLsyVvh28fLI4itQ6wU4Y+XHdWv09L+PVLYkf42WzI3JJEO1mPkg/irqaha5+6665yuJ3i1+zpsB5qL1Z8/deH6gOWgdyiSi6frdYQweg1kkRZ6FjsZxzAJ5HcvlfwGFg98rOKx6lGqtsAADu4S38KBNLps3wVpZdNDEWDd+o9WPqPrdXHVXoC/VE5hDPu//oN0GCzMZd9+I4yM/Co0/iJY2URJlHS4nHNqOBMoN3GY28dJ65EO9twJVTwsorTJwOjUjBbPow0irBfzgmrViElbjlhFXzKlfZ34gNrxeG7yIe1mVk0DZmUozafW6DqMSZX7sKpCOtzniEs7M6YV2juwwQdSgMZOiuMz/j9kigqrsc98MxXJ/qPipn3XFzy2aWYKhqOQTpGQ5IjNMwcottfnv8dDT8OjK16wk/nlmMnA4x4qD0mxuGgQzggL7bo5Ixy0VEuR6vwLnxN9LhBSsuCorIbKXVS9kCb6yh3hhvQHmPPDZnr3GjIdlL5T+B4ZRDDSiXHGKyq3i4IvmKPVI9LL40hrU1dpVqVUFul9xXPnxsopUZBdXcFLSXxHGPyQCDgswxbVQU2no7V5N
 NqYdDM0a
 +TRmen2sa1QU37fVVJ5n2ONA0TBbbiAqunGaVmHLl5JD2bXxiDZwC9g51uRYW59xYff0ZunxnJZ8iMiP5PH/xmbawqTHxKXvQWDrp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Nov 2025 14:42:24 +0100
"David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> >>  
> >>>
> >>> Signed-off-by: David Laight <david.laight.linux@gmail.com>
> >>> ---
> >>>   mm/gup.c      | 4 ++--
> >>>   mm/memblock.c | 2 +-
> >>>   mm/memory.c   | 2 +-
> >>>   mm/percpu.c   | 2 +-
> >>>   mm/truncate.c | 3 +--
> >>>   mm/vmscan.c   | 2 +-
> >>>   6 files changed, 7 insertions(+), 8 deletions(-)
> >>>
> >>> diff --git a/mm/gup.c b/mm/gup.c
> >>> index a8ba5112e4d0..55435b90dcc3 100644
> >>> --- a/mm/gup.c
> >>> +++ b/mm/gup.c
> >>> @@ -237,8 +237,8 @@ static inline struct folio *gup_folio_range_next(struct page *start,
> >>>   	unsigned int nr = 1;
> >>>
> >>>   	if (folio_test_large(folio))
> >>> -		nr = min_t(unsigned int, npages - i,
> >>> -			   folio_nr_pages(folio) - folio_page_idx(folio, next));
> >>> +		nr = min(npages - i,
> >>> +			 folio_nr_pages(folio) - folio_page_idx(folio, next));  
> >>
> >> There's no cases where any of these would discard significant bits. But we
> >> ultimately cast to unisnged int anyway (nr) so not sure this achieves anything.  
> > 
> > The (implicit) cast to unsigned int is irrelevant - that happens after the min().
> > The issue is that 'npages' is 'unsigned long' so can (in theory) be larger than 4G.
> > Ok that would be a 16TB buffer, but someone must have decided that npages might
> > not fit in 32 bits otherwise they wouldn't have used 'unsigned long'.  
> 
> See commit fa17bcd5f65e ("mm: make folio page count functions return 
> unsigned") why that function used to return "long" instead of "unsigned 
> int" and how we changed it to "unsigned long".
> 
> Until that function actually returns something that large might take a 
> while, so no need to worry about that right now.

Except that it gives a false positive on a compile-time test that finds a
few real bugs.

I've been (slowly) fixing 'allmodconfig' and found 'goodies' like:
	min_t(u32, MAX_UINT, expr)
and
	min_t(u8, expr, 255)

Pretty much all the min_t(unsigned xxx) that compile when changed to min()
are safe changes and might fix an obscure bug.
Probably 99% make no difference.

So I'd like to get rid of the ones that make no difference.

	David



