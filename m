Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD58CA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 12:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A94D8E0017; Mon, 25 Aug 2025 08:28:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881248E0001; Mon, 25 Aug 2025 08:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BDB58E0017; Mon, 25 Aug 2025 08:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7E88E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:28:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BE4183F9C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:28:12 +0000 (UTC)
X-FDA: 83815207224.23.BA5E2C8
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1F449C0007
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:28:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TPjj42HA;
	spf=pass (imf28.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756124890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPfDBfbpwUW+KOvZVoZK+orl1I1HkIgHCfW1U8nixbM=;
	b=oAoicysMHBObRD14GjU5JIbxekHCezrDrT6JaRKe5DFvyBLwuMW4+9zHOH3MJNyy36AWv+
	E47joV71n9uF1EwstvupDH6n19iCpJqFoK77l0k5vqQs2LekjO+2quXOpHz6nUNj3S0cNk
	cLhXBMcXHM6IWfcCJwJ4y7T7wSozYTs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756124890; a=rsa-sha256;
	cv=none;
	b=k0953aprQQYzy6e+EwmKR9Xz3EH7iZ7cp1blwlNi+5pToxe79TiDrKboYUFnPLzmMZ29xo
	6482JPEcORGzT+tnh1QyHHGP4qMQbBAD6Sp4xJ6qk9kpZ3JSn9a3+lBYIefBzImk63qDk1
	J2QGSgDado56D4qkeaNxv0MDh830Kew=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TPjj42HA;
	spf=pass (imf28.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3c79f0a5fe0so1043990f8f.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756124888; x=1756729688; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kPfDBfbpwUW+KOvZVoZK+orl1I1HkIgHCfW1U8nixbM=;
        b=TPjj42HA6o5t/ScmeieApokOFIwp0+LrE5IAXYwS7qMnbmYHoKq55EbQXQvwCAvEd8
         X+VVR/6KGqzdV9HXf8xbEf3t2Ry6zZO0MrtFY83hiZ+6/eKPvHbMeBtWiM/JbyghiJVi
         aUEaHPQmWMPvVSGLs6WKz76o4Rz36rWI9KvWa61YuHLm4VJhah3bz3on2jfLfg98R6r9
         5a3CqqCC+Ln3cNeko3xFTXmcJYyPIjOLjMV5NSDXxLzZyQ6NvvybcS6hCqouZjgKchXm
         kJ0q4W085Aj31gKWEPLna9GHh95zFp19of5+axnt5tlf680XF/uEUMUUj0YszwmUXm3U
         kBNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756124888; x=1756729688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kPfDBfbpwUW+KOvZVoZK+orl1I1HkIgHCfW1U8nixbM=;
        b=XBuRt0rTOqQvjGFHEe3tuMfKVKlP0VEU6RZIe+GAcIEh9P0xOCMjJiIBQmWF/ziRUb
         s6bA9+0zZn/G6LR98weqQYCOhK1ernfhvaubbbNq3+14SOfEkr5rLvKM7FbR0ZTt/08z
         AbMWlVzIs7QRUgSShX+hTOU1DXfMLwR5euobD2+UUbOAlZw+JMKGhAb56B2fdw37jf79
         4WYK5+egCeHgNtMYHGbHk0xS7mFtTmP81dmtKxJmBBxBgOjBN19QLDM8926/ECwLxmjs
         rhK2H1P8uRKchrrFZL16jsR0kHVdJ/Rl6bYcJ/6hQAMyMC2rUxF2wvceu0TQ1Lw1/4yy
         d1Zg==
X-Forwarded-Encrypted: i=1; AJvYcCWPGE9JWVHDCUpDGMdOlkWMSTJyaZIAr3k5VujRemKg20RywuGIKtXd9Ej2zGv0iBWs8Yv9QWf4Ng==@kvack.org
X-Gm-Message-State: AOJu0YxCebDTu+XUj0MDEm2Z+cE9NeBbEXtZuYSDeHQDFyGYDKbaVjUF
	lfBMZvH8y9MeWwBAGs8zmEKRlaN7Ywc+7Fae7hz68/ICI5lg3F8CVCgF
X-Gm-Gg: ASbGncvC3rXAdwhkziICf63H7S6lOF5z99e5wTc7fOSARE1tPHz7VZKYwQQKes/Rvdl
	JLfZme4bkIwTmyslvOlM70vBkBlQgo6TYA2XqQU1/hDB3v+N+4JZqet9BxVv+63/4sJ9hpYYDPR
	F4FyyHqkNG5ooLdNS7IadPL3L9WwtddqVx1EcCjIPIZda2MxWIiv++Dh1opQcaVjsOvnFa1IPks
	zaY2yZlorXXD/EW+L+b3ggFavsash0hit+InY6HqhWM0nflR7UNvIDoH8TXpiblLV7tQXapFpMH
	f7uOxr45qrD7k/HIlaD5SlO1SsZahbXvEUcakb7c/UJI2Gd38DZBM3Ij0Ifq8eKxI4LPyKv+CaY
	I+/mUwhE6io6qlJZJdUNWzCAA75pr4Ajn5uk=
X-Google-Smtp-Source: AGHT+IESgx9HYKPain/SQOUHC5A3qxDYmJ3/amsQb6PIdB8JBVmGFTgZXWbCC7qK1K4LPP+7blyqdQ==
X-Received: by 2002:a05:6000:2585:b0:3b9:16a3:cf9b with SMTP id ffacd0b85a97d-3c5da64a8fbmr10103861f8f.5.1756124888325;
        Mon, 25 Aug 2025 05:28:08 -0700 (PDT)
Received: from f (cst-prg-2-200.cust.vodafone.cz. [46.135.2.200])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5753adf7sm107780735e9.7.2025.08.25.05.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 05:28:07 -0700 (PDT)
Date: Mon, 25 Aug 2025 14:27:58 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mm: readahead: improve mmap_miss heuristic for
 concurrent faults
Message-ID: <ynl23xmeglxarrkrmh4r3sj3idvqbofwatrnhgx6tsl4zfrsxp@juc5kmjelwjn>
References: <20250815183224.62007-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250815183224.62007-1-roman.gushchin@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F449C0007
X-Stat-Signature: zxqz6byjwdfd5s5myikgnbsnef8n8h1n
X-HE-Tag: 1756124889-153512
X-HE-Meta: U2FsdGVkX181UPupxIe5addK0gcKYzUnp/4Tueq2dIblbp74SAAvlMUIk8fTHqpnKhQBZ6HFvzaoi65+bnvTvaQyPm5efGz/mc3p6ilOe1SyItv5+62c+RPbpEHm4ku2BENfe8RYUEhn/XtSJDtoaQq1ZL3BK37NJ4j2/VPcuXV0xE8mYbBfkFlDzjrdcO9qSzO6HLHUQD3JrQYF2pQuYoPA/StZxwa+p/XFdIAcuB56YB9VWlunOkAvhxspF/FgbvUDRuPLOS4ek+vK+qXGfQeyNZnJDv9L9XpMasz2TvoqpjCB71wD5FNGfqQ6RDE7ij8DNl9R/PvS78w10/J/WdDEgYwreoCLD+z/HtaDPuK2BGVpHQb4GWXjN3KOdyLhFg2sWzei3OqOwjv3hyuVIZNX7qcSBI2VF+tZhby12l5V6YJ78kw3H/2VdY6iY4xsNQ+xoKUXsWQQbfKgk+UM5KELHFYPIleTrtEVuK+cnpNnkeh1jA9UuuGBlyCJjN/qIlVGVYlvVOKNDK+HXYFY6Ry08/u8JZrkhPw6NH8broYsdXzWkzD1wc/cT+weDpPxMwls0N9P+f5e2p8I2xcJmlUf07OGw0MTRTVrnBQxHDab6wj/L/QX19GlD+k26cyNvChS/IpjzRDB/d64SwsA0sIXB/KB3cuVCxhhm3iGP/BkiwOsc45jiuVQstjvpoYQXEtLKMX8GUFRhnkWlXMlkPHTGHUDs2cwdB/1eLULQ0vQ/GasYZpz+ibaZeNdpSJK34QL/wZb9eqihAIuNm6MSZ8BJUUaNLKCnES8JFRbB8wwD4kdvCNNVAHM/dokrawvtLqFlIM+t5gu01XT4I72QnkCQ6S/1AgNWsHz9DzZm7Xt8ev0968Wmr++eVmWPBoJjsHskh4jj1QCwGu6AbjMRmNPAJ3AiQ3lto9gUDXDSjoolq4pJ50gMhXxrBLdnQbcszyCjMDb9EL8NnZ9OrI
 ZUWLB/Y9
 G/A+uAhPYd6AxW72jRcaoP9TZcjE2i352pFflxU9xBoh1nwl+1CieM7XbrHS2lPy248EBiAMTtEY53MVbjC844dIIlWJicVkcNjMuoYVvZYG0qzWX1ISwNZhL567Cc0rjAk3yYIryIjUFJGUcj0fZe3zyAuKJvKwpenSTMYnPLlb1S0SQ8LJMHaXvW+ZM5kjCjvy2zVZz91V1BclKMDB0m5t49MCBh+IM27ZwG5NqYonWFa1pZiQFmVWhgVjwIkynGfnQQlAY0eomK9RFnTFcTmCIvuAHQhJ9n6OmhxOAt0jtFPKqvQzejGSCOtZGQ+fHK0Ok6D7YExo6G512mFs8FZUyy+z3WdNI7ZCVlyXtyS5UJyf7mHi6P3gfvCsGSJw+/ktnQVHxIXDXETJGItmbIi2Vdn++9NOhZhm5+vs5zzRcc8CRX6FKuQsRIPCCg+F5d9T5/wt6LwKpaxgHucE2wH8Ze1RHOGVsLR9sG27gLI/7NOwxmyLu8InT1Nn4RG6qSDUNz8wA3DUpGbNgiWE1woKTnGZoaA1080en4Nss9V5c3cuGwSwotBFBrU1lWzJdhOi84rjDTOgD0jJjWEG4g9PD9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 11:32:24AM -0700, Roman Gushchin wrote:
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
>  mm/filemap.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index c21e98657e0b..983ba1019674 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3324,9 +3324,17 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
>  	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
>  		return fpin;
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

I'm not an mm person.

The comment implies the change fixes the race, but it is not at all
clear to me how.

Does it merely make it significantly less likely?

