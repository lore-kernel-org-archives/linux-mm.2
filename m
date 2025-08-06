Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5792BC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 02:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C6A8E0003; Tue,  5 Aug 2025 22:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23E18E0001; Tue,  5 Aug 2025 22:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12938E0003; Tue,  5 Aug 2025 22:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B197D8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 22:07:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E181115323
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 02:07:49 +0000 (UTC)
X-FDA: 83744696658.18.AD914DA
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4D51EC0007
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 02:07:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PZHZ6fcX;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754446067;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TpITwhr9A67ffsCSQOPHyjsSE7A1x5MUNzvao45sH0w=;
	b=rzIoEP78/J2JemLudrASELVwqsjKXXae601TQXTVr2PrNYVQLH0aQCRhrbLn6zQMhhQo2Y
	cXX5YbVKIVigdUbcxE5LRoo+jJzcxw7bOc5VZJl1YDbblESsjV462XXjtJTibeTGdgB3+J
	GAveArTU1xJazB/nc6NMi83sYrI3BlQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754446067; a=rsa-sha256;
	cv=none;
	b=zVgxdPl9mhDa+HySWfNopRRr62m4dHeV10G58lI3bVkakEFy/B98OXMUBpLzqnW5VzxOAv
	EdvXLap5YxQsfizsx+xjzpzdnDEBGQ854ZElnR+7KI+bYbIfwm4D8JNL5XXrSH69xFuaYx
	rvMiEJ0cAvvl6SEwE80g9bh21AXM1CA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PZHZ6fcX;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-615c8ca53efso10317396a12.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 19:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754446066; x=1755050866; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TpITwhr9A67ffsCSQOPHyjsSE7A1x5MUNzvao45sH0w=;
        b=PZHZ6fcX/uRC6FRTg6c5d4c9dQMETpbJYszghrDetJrIcAs18DZpIAD0GI4RTt9672
         1gZ7Ylfe/KqZaCXcdFeTrPynngVsFKaYCFWr/L4x6HsXZkD9XZBrvXDJKSAGusaWhJLD
         aZdDkIiX8dE/mPbRaQZMMdO2/StqhxyHbEIV/4KSAS0P/Wq+/kvw3l5Ke6y6/FBjm0op
         EwTQmfoz9vhuWBBuUgXt+TLwgnLweuclaUA+rGxig2Xn4O2BrVYqpefTK3ixE75/rFA+
         S7H0GWCUj2n2IvbhYd9EGKnQnqP66dnXX7aXfGD7xgsXn+NM/pt94gDl9r0Q5E82cK35
         M1pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754446066; x=1755050866;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TpITwhr9A67ffsCSQOPHyjsSE7A1x5MUNzvao45sH0w=;
        b=YlHW8sCIChAggKqgqIGMAwFEycDOYNjs+LWhj/cSFz/4nk/dskijnOkqa9DR92SsJp
         Xfzt67SFDpJlWxJZ5La+6mN99xP3Wd/gnL0LE7uueYChoz9Y58OqZfismDBEgoTdHCka
         G90KNgBQ3UFvRak95ZdZFkJEiW6rUzNgzOBMi5zrToAxkfPdODxBqdU+9J7nv3lbZGhD
         nHDYcSsyOSSDuaHnqy6Dxt88V/OGuiCM3Dp7ncDfZ/q2XY2FaZsvkNGSEuQ+7r4DCeVL
         1VKIqyHvKlYTMe1/XOt3JBuzkkbCGQpT3+PsBbXbn3UhD7xDUOEO/gvjtHETgRMxuAU3
         4Etg==
X-Forwarded-Encrypted: i=1; AJvYcCUBZm+pYFbJ/04DrgZsq2JXG+krRMRpvjNS7t0iZGdvv/ysto3R4Am6AdICdw4wSrxMGGYHgrp0nA==@kvack.org
X-Gm-Message-State: AOJu0YyDTT+raZrtjVbGHtgT4ID+PTMhsg8a0Doi8VPO3l7R3w6caJRQ
	DOiAdMGWHNRNOgo0BtIJfEMPmT+8PMMtkP/TMRR5HZ6vmz0OE2jCnaQla7DE5E7w
X-Gm-Gg: ASbGncuOPUY/dhDjuj392KNDGSmO0oDzmmBZoryrj0TI0RGmh72zAlVlmJTLqww4yUd
	XD5/FjlcteizLG5eR+CSeEt/cyGTC8enVmfu4+XyAbxByGJOXv17F2cwilFdYS1kPHqrXFjpGRs
	CgrnbdlQa3QBTe3/yj/nVb1Juma1t5HE0xzb2reygiON+C/5V2+OxSMyWx4im7qSWTjXXUwk8jj
	8Ek1++CJs6FQHszgoBRvHst+K7PCz+44QKC7sECB0KhdKNT8OWwGBE3vRcWe3g0B295ihmsX57k
	FWVWDuYVHxc4sRLONVDpdPPcg0If5zdoTmT/2j/ibt7HA6YV65Eq1csEFropr/Ish1DCKz6RFLt
	E35m1FbqtpMSRUEkrHH3hjnZd3/ny6MX7
X-Google-Smtp-Source: AGHT+IGzc7It1T9mdNV+lU5ZWtwPMPm0G1+b9g3xgIXNb2r2gdXmdobSRLJxbqy2KZlOabt6uN/rHQ==
X-Received: by 2002:a05:6402:24d8:b0:615:cc03:e6ae with SMTP id 4fb4d7f45d1cf-6179609bbacmr916447a12.6.1754446065519;
        Tue, 05 Aug 2025 19:07:45 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f00247sm9506616a12.9.2025.08.05.19.07.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Aug 2025 19:07:44 -0700 (PDT)
Date: Wed, 6 Aug 2025 02:07:44 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: wang lian <lianux.mm@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Jann Horn <jannh@google.com>, Kairui Song <ryncsn@gmail.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Mark Brown <broonie@kernel.org>, SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: fix FORCE_READ to read input value
 correctly.
Message-ID: <20250806020744.yj2f7z6ntdqnv2ff@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250805175140.241656-1-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805175140.241656-1-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 4D51EC0007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 6iyesmg3xts5h7rhjxqfmerwo43rti8j
X-HE-Tag: 1754446067-742411
X-HE-Meta: U2FsdGVkX18j4Wc8SsHzV//M7RHySg6BZeJvoViLbUpu+4W41XHlsFyeOAMSCfEISPzn4il+9aHzrlu0IUKtb8hELEyn5jGIF3Tux6+ZgG25vOIYHQSYVry68nCemNIIm06VYrd//n8RjKVoTMbD/GtpLZcrODfmc9RUUl4nMiuGPQ4NwpV9ZJkeiCxscWT9eIUpRYpRMA/4NssMrFMj1LBlcVABHKesTcySGozGhHpE4qnPg3MIOVhlPq3EvyIQJlUdBntJ09pbNQ7JEgDX6iLMhExbUbK38Uhj1GyTeIig+oFEdtIc9+Y7aBg93pztgRIFSciUE25F3b6j75zFE1ZiY5S+OihL6srx9Hgsd2A+NgbQlBWDeNXIUQRJRzwhbQlnlP/SoG/flAI9Eqpdzp9VhcqhMFdvEdgmCjOzRZrcuo3jDHGRyU54EBcrjmUwVC4/pzdzu0heysqLAoJuu4bVp1gHqya1iC/o4fGgSX1Xm/PNlN+dTi6OawVer3N9xzt0CJyC7l5NtMZByLiQsxujqy8/NHP2jYdVCZ8ohTudcUXOieK+QwuYMuDup1lrjL8CtRVrpgXhZN5FCN1Uq+Ku7lgGiCCc5zOjbdfPMnMnrX13PuueIQkSq18dvqH2r/wHZiW56lKCxTs5/AlUpWpj9umP2/sdBAKrG3kKEdWOldfNJTjy57aeSEIcsiq+Kolctjyf2XWT7V0RnL3fjmodc422zfRvWaKvbn53k7JfNfbxu2bJ/v8Bv4suOs5jQ2vTmn1T8zC/0CRtTKzlusBjRyztaGlYBGQZtBVbfOCwRJtFTT/chOhXoBbOINzvC9pt4l7CVtfvKiZson7GmgPvo2QQi+I2aXXZL8U49T11nFciI7sfamGZkPokDuNw8ARyKRf4sKDq+udy3eXeTvQo5uohGXrr4c8anAwTjJJQ8zB2Y3nZChatEUHFWQEecm7UxP0+n3GRSY96TNS
 MJCE8l0D
 tx1Q/+dUJ3HUcup22+O0q3wVBZjsj/Eb3EhD0rqBRojUT5mbDPjPmDIswHwIa+FR7l336HwlHiluR557sTGa/5oJOkO0gHYYPQYYQINC3MOmzJ4npoQtz3ujaphg2TYuNJ4r4oKGlk/o9igkLBe5EbRTSo7Ozq0MrVc28xjInhlkeIc6hHYQJGJF5QolYmENXbjvYMetWnT6wuVooTkcwgJvhX40Umi7HfE4W3UQV7YOoQeTocQhH+hH00/qgzVyMf4+fJjlzG3lJhHIOEr6wJxZQ/ZrkF0QQJ1FomCAIGSQqxepgfzvzXVXNR7MBFVr+dJKkk1LKYRqoY0PXCZSDWS5g8bknnbvnsFJLRcTRnM9i/jJURZNEKA82ZZM0fVV2pHwYkaoizLU4pV6TpQNMKe3MST2ZxMmFneJYgq0dTCnlmsxeF2mGVFhjUpZVI0baIXkzQIzno5M+GAfr6Q4Xe0DYkc62I4keg0QWZTtreRTinOwUp/oy7bJo1Y8YMscon1DhTyOd4VwvfcYEADqnlE549xVoo2NuACowY1TkElN2uYBiplEZd8AGFVag74EhAHSMrTU3PiL1JZ0ujUETkSxXNECkDT9j2vCmqTz4GvZ1L7wY9jMLP0BEHHmdT4A0xqxCscuYBvkcycAq2JxJOmr/6za/JHTfaqvf6KpMrxB5L9WIzcumWgQeMi0VO/GoT1HAvs+M4M4OXs6I7fgV3KExS7F6kQeUKOg5NavP5RolH4wFGzVtmcPEDKJ8BD4R5r1Wfa4wuhkWww3i2236Bbf3EbJq4+QB6Jr3DOjHRP+jg134/4H/Ua53LluUcgQrdqU0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 01:51:40PM -0400, Zi Yan wrote:
>FORCE_READ() converts input value x to its pointer type then reads from
>address x. This is wrong. If x is a non-pointer, it would be caught it
>easily. But all FORCE_READ() callers are trying to read from a pointer and
>FORCE_READ() basically reads a pointer to a pointer instead of the original
>typed pointer. Almost no access violation was found, except the one from
>split_huge_page_test.
>
>Fix it by implementing a simplified READ_ONCE() instead.
>
>Fixes: 3f6bfd4789a0 ("selftests/mm: reuse FORCE_READ to replace "asm volatile("" : "+r" (XXX));"")
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

