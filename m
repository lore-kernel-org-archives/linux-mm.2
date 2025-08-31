Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56895CA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 19:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C8B36B000D; Sun, 31 Aug 2025 15:24:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4795E6B000E; Sun, 31 Aug 2025 15:24:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F166B0011; Sun, 31 Aug 2025 15:24:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2245D6B000D
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 15:24:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7DDF4119B1C
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 19:24:15 +0000 (UTC)
X-FDA: 83838028470.09.028BC95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A600820004
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 19:24:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HXaM8cag;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756668253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a0szEJ/QlfZplb4/ARKQmjFOwMtZL2jruIejnVcxUEw=;
	b=7SZMt7jZURKEd+/8+p1oiec8qOMyiZx0oLtX8YuN4gInaIVocE/qFeSo7/tRvWzW233W8N
	0hL9lAkmDYe01XxpJqqX/0l4qVHpokisc9Td0DKEaa/oiyuThsBwLc7NW2d5e/FqpoeI2d
	baMCg6MzyGuTqIeKE4xpJKP4uMF3ATA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HXaM8cag;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756668253; a=rsa-sha256;
	cv=none;
	b=goPqnUAXN8sjKUSGkIHiACZ5wMEgQ3Y23FULHBXaUMdxWXJAz+oCPnkdWUvrBytonBoAQL
	ryqrtr6ORbaCUMT3xZ4KyFCJKb2AJ4mjfmonU3WI2PDoEPPb3ZR+bn+fS56+YHR85ZvvDU
	x/A5RwCXE40l4h/k3NIVn6SfZbkI3C8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43FEB40769;
	Sun, 31 Aug 2025 19:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2492C4CEED;
	Sun, 31 Aug 2025 19:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756668252;
	bh=M5hUqZj2bhXJOyicZDtMiFAzUXOvG+Rj16wszrq7TwI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HXaM8cagIxYY57R5t0q+9xGVfy0aW/w8p/iSWjJMDBfD8kAoXNhsbz5p19zz4xbU5
	 4uhwBe1MLxF06pISTb8uzTcHG71ogjs4TD+aVBheZzVHyl/IMB5Fhf3m6Ch7jRddSo
	 MiuvQuAtpWC/0O2/mI0Vkweu5pyYqG3ksdXkR9n0=
Date: Sun, 31 Aug 2025 12:24:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Baoquan He
 <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc, mm/kasan: respect gfp mask in
 kasan_populate_vmalloc()
Message-Id: <20250831122410.fa3dcddb4a11757ebb16b376@linux-foundation.org>
In-Reply-To: <20250831121058.92971-1-urezki@gmail.com>
References: <20250831121058.92971-1-urezki@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5tridkhh6tbk6spf8oezs685y18fzkex
X-Rspam-User: 
X-Rspamd-Queue-Id: A600820004
X-Rspamd-Server: rspam05
X-HE-Tag: 1756668253-539243
X-HE-Meta: U2FsdGVkX18OLv8UE41yB9g8hCLt7IDw177CzmZRot5h6FIuel2RWGbczTsE/RRtt7mfGdng+cgXJv0USa8knKubVR9k43EIpWHeE84nhWz0+6iUTVqfk4tFB5rtRaC6XWIIPrgzT2+lT1I7c+d6DeNdqUvO0+VlmEOCt7BFPGo/RekjcL/k4wLG57C4FhOPU6aRbHEPnj4rgtFEKa/hm/hUYxYe0jJHr4JglCAa/1YJD6d7VlnXqiG1kXn6xv99J1DtCrxUp69BUTYGIA2d6xjHau5l1tFn0ZSwyYoGBYU4h/Rl2QOcIuXz4Kb2wpg6bNI2B1Cv9xpWmM0iwDhaxt4okAYlSgLZu6yJoDSmEBjmedsJnfoE7WuQnN8oTtPsc18vZ88yERiyL8VWSfwP9vYYVKM0ysmizx5b+2UJzacmXwGqMg91O8yjrRO3e/bF09fQRlVCkgAAqSWzq8iCXFOYUZ5Qdrv/Pvpv1IrvyNI0Cq19RcX2DHqOgglWgovr/Ffx1WRgitozripVid7JgoA5eJSeB7jhGN6D1wA3mNdw27FR6ywNSW4cvpFRN7jfjqQUJCx4Q+PXg523I0ZMF9eExEeHeYoVpeL2xCoD85eiSNvSxb0eUMdVOsO2+y+TeJPzAJ+LBoJ1SvA4JfeCwCqi+duXuqMmdjDBFXDbyp68E+g6tpAaT/cS1UnGx9rskMlpjk+rytciDekalqfGGS2t62kUhdsm5PxporOUW0TjZqfAqhJf6238FiN6F4EHek6nUEtMUo2C0YHSK6RvusBw2LY/6bAe11Midxt71xh7JXB8ja7L5U2bIRzqkMbwgJZeFhColmoNzTCUMRCft5b4oQ+lrok1XjHBeA3AykTBhW1LYt2CHBgfBmXVH62pFCr+M7Svpy1+cgxC/ffLH44AeVuFrR3Zhf8kFDJ40dB3HtXdtekdJZiW2/XEABAYJr7L3fSDnrRALiSHx0m
 h3tt9iJP
 bwc/CYNil28hUTq3qZh5y0NwMEyMzD5UT9snXILRdsV+eqpv1gqoM3WVjJDEA2VAMIXL4+p5StB6i86BYXefhFd95aJ8hmp8LwPQABR7OeVEwP9CCtQU0+fH/iZ4ljxJmUAYtakfmFYz6VvsotkgXKDDuDSRgFyBdBF4tmLwjlHWSV2so+vVucmdnvM4PDsBNo5WUYHHuBoOqrat8QABhINGSGRtaA08qJKYWn9RqP/DOFnxJmfOqbm6vF8u/2Odj0OhWkWFdkwy1ViFj2Axf9H9nue6Sk+cCm8h7am+fiyu6C2DgOAnUNySqWTmogJ9nxnFmk4/l/TZOgbDXqzz5KUKBfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 31 Aug 2025 14:10:58 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:

> kasan_populate_vmalloc() and its helpers ignore the caller's gfp_mask
> and always allocate memory using the hardcoded GFP_KERNEL flag. This
> makes them inconsistent with vmalloc(), which was recently extended to
> support GFP_NOFS and GFP_NOIO allocations.
> 
> Page table allocations performed during shadow population also ignore
> the external gfp_mask. To preserve the intended semantics of GFP_NOFS
> and GFP_NOIO, wrap the apply_to_page_range() calls into the appropriate
> memalloc scope.
> 
> This patch:
>  - Extends kasan_populate_vmalloc() and helpers to take gfp_mask;
>  - Passes gfp_mask down to alloc_pages_bulk() and __get_free_page();
>  - Enforces GFP_NOFS/NOIO semantics with memalloc_*_save()/restore()
>    around apply_to_page_range();
>  - Updates vmalloc.c and percpu allocator call sites accordingly.
> 
> To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 451769ebb7e7 ("mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc")
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

Why cc:stable?

To justify this we'll need a description of the userspace visible
effects of the bug please.  We should always provide this information
when fixing something.  Or when adding something.  Basically, all the
time ;)

Thanks.

