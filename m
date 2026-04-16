Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD273F8D753
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 14:51:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15D646B0089; Thu, 16 Apr 2026 10:51:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E566B008A; Thu, 16 Apr 2026 10:51:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3EFE6B008C; Thu, 16 Apr 2026 10:51:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0ECB6B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:51:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8844F160855
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:51:09 +0000 (UTC)
X-FDA: 84664706658.24.22BA6DF
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8679A1A000C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:51:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=Gf2W4WCy
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776351067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMRz/WI21Uh5Gr86fIIlkO6L3sSSjv9gzE39RNxVDRw=;
	b=VY6V2c0gMVddqzhQZwy40wHHbdbdYFh4MBbGTp8soQlQ3Lcv7I3RzCnfQUBdamfZE6I3yE
	jqUtSh8CZJ6fQ+pVmOul8xSDh2fbY0g+jyxZrl8XcD9v4PCt6ad1bQtPdQaRAhwL3uCJBa
	gxba68s+n5YRkLxGWXglL07m+Uisq+c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=Gf2W4WCy;
	spf=none (imf19.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.128.46) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776351067; a=rsa-sha256;
	cv=none;
	b=Sikobce486jBS7+XDNzBWTLOfIE99IM9Kk6pTpx5fPKzXDR/bPIZtoBlNZFK82nxZGdHqu
	I9iZa6f+YqZqNA41LIoKkCPp83TlIQkCykXlu9sgkJ5/iDcocVisJA/YT/wMQnvL09FpQ+
	cqGNNI8dmAyquyZW51B7I7tOIkhMR6U=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso7303175e9.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20251104.gappssmtp.com; s=20251104; t=1776351066; x=1776955866; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FMRz/WI21Uh5Gr86fIIlkO6L3sSSjv9gzE39RNxVDRw=;
        b=Gf2W4WCyqVAL12wgdXvMQrgHvNE/C46bZ8BuaASaDSTvHHCnOI6V9Ycgm/ShDIPbAl
         UsBmfC6nHGWqnWRqN/RpY4Kf/YWqKoW2G0w91VwW9L7zmC/2GeCKkAore/yW6Gkh5GoG
         yP3SpCEOtGudmMtNsDuhZtkUOiCak5pHWX20OGi70xCm3rSmOJQI43efJK3VgHXqgjrR
         5l1+Zb9QgfnNTjOWGS+ustJXugWzmtHJBbIRvuC3bDSy1roG3XyVOloo1h5si5Rz1Em0
         TaFSBXfy19LcXg/lvCgPmf23ogL/wGy0IWM2P3L9EOcnGIm7CP5a5b6Xw9weoZ1A7JtN
         thwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776351066; x=1776955866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FMRz/WI21Uh5Gr86fIIlkO6L3sSSjv9gzE39RNxVDRw=;
        b=imqtHMVRHFwYrkMV0VhGuhUPP4RMtDEOmxqOJ+UJRM5ZgfuakCsa7AUjllAz8YN5CU
         d7yrf7DAY7mZzPSwaZ819iNDBKin2yvrK9BGIaIz2dl17VOshQ5T92ZiDHyiJK0Nardm
         Vrj9jPspCKtpeKTb8FyatsOAHYE/c4GgmlskqKFxxolrYdM5rGUfAeJYh16xKX4FJqi9
         pPLTmG8AEJOR67CpKCR+XkkRKfugT7SISrazPHKxAxEA7bBNqhnXmhbPm1HV2nJSIqg1
         8rV/F+QGZwpDSthOLu4s/7+AbQ7tEsAJOG/Tol7zR0Ut9E4vMdayxnQ3QO3JNzN4Q4Lp
         4BvA==
X-Forwarded-Encrypted: i=1; AFNElJ8KX2G+JMceTCAc3m4LkWv8Ih67cC9Wg69yllKrtOtlmOxeoWSKGpkRnBspGEQNoGIO3L0A6AhEzg==@kvack.org
X-Gm-Message-State: AOJu0YytpuXGlw/37YTG+gHWz5CjFKYnCdYMgYqybssFMGZ9SFdXJElC
	1+orQTjcdAvFZXFNzXTJ7zS0IzeOU7OiDZyjGHEI5FoKdMp+7fZTXk/1gRpaXUNYQKQ=
X-Gm-Gg: AeBDietHQWsa4o0tvJJ5K+ei2YEx7TiJc7ev2U5PhyatbOVpS/ASlVRMM7k6RboghpF
	LzrRL4nKU8JrQhSh3fqaEI7QlOuIMJwWqMjVC77MVwuGt1fo5ubGqdcg4dETVSXAmGgpihqxteW
	TVpCxSaabZR8PIsjPmtZDSlpIXf4rcH95SagpF9BMuAFhHwIGT2xs6/jjX8CHWu4ImNniJ1zhOS
	z/+riZ7P3gWMWDSX5SEe3JmsfIRhDXtaSOsP+qiK2SvKZszAmDORhxImfSd0pTP+zZoxCfovPtC
	OnOwOz6RmPG6c7v61ZD1quKlXOjj5/dr3FzWKPS1KH7UZO/kUd/HKyib8yHrnMcWmVSf3bNDLE+
	EPE8PYanthzOCisDYgeo4boK+Gdn1wFPh0bUm5U1CJMhlCahzw808f12S34gFf4QeS3o/rWyotm
	GYL6LWWOUYsR95hsbV/g==
X-Received: by 2002:a05:600c:8582:b0:485:3c2e:60d5 with SMTP id 5b1f17b1804b1-488f45cc724mr39994985e9.2.1776351065748;
        Thu, 16 Apr 2026 07:51:05 -0700 (PDT)
Received: from localhost ([2a09:bac6:37a8:d2::15:40d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488f0e9c668sm75209365e9.4.2026.04.16.07.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 07:51:05 -0700 (PDT)
Date: Thu, 16 Apr 2026 15:51:04 +0100
From: Matt Fleming <matt@readmodwrite.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, kernel-team@cloudflare.com, 
	Matt Fleming <mfleming@cloudflare.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Require LRU reclaim progress before retrying direct
 reclaim
Message-ID: <aeDuVmN8Q6cpNTuT@matt-Precision-5490>
References: <20260410101550.2930139-1-matt@readmodwrite.com>
 <v3j7f476gbj7b5rxigpcorxhaimg5dyhgtovsl5quo7gc33swc@7i4ypekahw5h>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v3j7f476gbj7b5rxigpcorxhaimg5dyhgtovsl5quo7gc33swc@7i4ypekahw5h>
X-Stat-Signature: brg9cnypw5o38nyxt3gdahaapdmtd7rw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8679A1A000C
X-HE-Tag: 1776351067-271937
X-HE-Meta: U2FsdGVkX1/m+q/r5To8mTHQpQRzjMxt3RF3DpbT1DHNrEYqT2lUwYRYi4R5wyzkDjyVxgzGxwpxOzoJOSrOkMZSMMX58F/S1NPnFHGF+UiO1odU2kGPXQDWs4xufEWRbNPg1XTTYfbeS8/1NrNtNOiO6Bu100e/g+FpkRuBKaJV1pF+7dhSFbYCYFvgWvR3zlLbewvdgYkF9D+2F9iFxatsGku5gczH0IOabW/5lFToAm2okzOxqbU3uBe7Ohm8bMwHIlV8sztJOW23SmyeVokQfMsffu2LyAzqDjUEYjkBNHVezhD7xpvKuoY5cgOnv3M4ICS8+uMmhU5RbNmS8PISnJzOLq7XlYRE/kmH7L/YA7ebozjnpPljFbibuYNZ6jVo3X7aIaQwU0UIuOKEtfyAic2a/Ufe1e4TLdC03+YojoxxbEvGR47SKdzGEvapzxt0mWlvP/yIFb6r0F7Ds5iw62Af1cL6kErh9ZYaxMJihi5toIHuS6P1P1Nuvw9efgSk98D2nvWagLIy3g1Yt3HjNIEmKqSRc26z43OXO+6MAKwmjG7RnO6SmkIF3B2tOIRu6aKc5nYeIfj1ix7D7g+RBpP0rCNXDYIrQWOHSa7SbZC8sereRlOb6lKGSPLM7isQigSckrgPyLx1ZFT1Q+FSMf3p7GVX7V96ZxPCzaUe6ALjwkvrRDMBrf2pkXGwADjzm3IAJREOsxuMaXEF8Y/qIjH6+91FCVrjaOEyEZcKu27NJG9ldFr4CciCOQrG+B/jM2HHaS/lzmR6/zkTmQHj5FtY3SSGu2OsPLF0OXiD8Xp2lUOX8GKLmWKPxkhOYCQjTevqpz4zBE9f/z76JuHb5tnFLn2JhIcs1e7BZ5SLybGwbtAdMnwyC5WiiN9kkslhqAXbeXAKIT3ktUajWd52oie5dVcGBYkEwXuPe0DR4ykzxjHdiF/cDWa2TYNGCEYiXYkw4/fhNDGqHUE
 V+miu845
 E9kXCeLF2XwRvncDRMOZI2rAJJkwQqrBgnqpl2QJxLkLDqLa3lr3uA14XttIf+cwkdDgl0YdfjStkRCKSNbrTnmUUxSUTcleB12YlyhjPmN9h8LJ+4Oc4K3BFx0pPvhptzOcZcf/77frhTGzULW9Ayl/aZ6CiFPbZOJ0UrJfJ+mbs7VyE23pf/dls3xXiEP1zk287C2GV6RItRiZzRhXDO3f7fU0b1xIC06IXWo2cvH/Ll0eNw4WFJ91I4l+f67tSb8FaoEJNHra4o832cuk8QLJ36aUwB9nViGiAXzhEnA7gVGJ11usQW5C4/xX20HqJT0NDPV15760wKhSvilvxVw2bZJZmoLr9gKgd6ks3VZP9g89G0lltegw9EjuJzCUvWmb3REwS8c0ubPfvIiQVj5OtsmLHxriirIgB6FlHdigCoRtdL4g6zbbkYbBBYnfKsfm3JxcAZJyg7BnGnnaLYcDKiQHEQobILCGLWjt887CBum1IxPlDZ0zdEZdltLHFDeeS3hoU8W0UYLOe5CImGai5ZE70n6okhWodJCYeWdC1bB5O4u5mrMe7ZhEIN+rklz1PM68BjywpRsgrJUGgq8668QM3w69KSNSaOb8TEuwLKX2HSTQSmu5VpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 03:57:25PM +0100, Pedro Falcato wrote:
> On Fri, Apr 10, 2026 at 11:15:49AM +0100, Matt Fleming wrote:
> > From: Matt Fleming <mfleming@cloudflare.com>
> > 
> > should_reclaim_retry() uses zone_reclaimable_pages() to estimate whether
> > retrying reclaim could eventually satisfy an allocation. It's possible
> > for reclaim to make minimal or no progress on an LRU type despite having
> > ample reclaimable pages, e.g. anonymous pages when the only swap is
> > RAM-backed (zram). This can cause the reclaim path to loop indefinitely.
> > 
> > Track LRU reclaim progress (anon vs file) through a new struct
> > reclaim_progress passed out of try_to_free_pages(), and only count a
> > type's reclaimable pages if at least reclaim_progress_pct% was actually
> > reclaimed in the last cycle.
> 
> I think there is at least one problem with this heuristic: you are counting
> everything that hasn't made progress as "we cannot reclaim it". When in reality
> you can simply fail to make progress on any given folio as e.g it's referenced
> and we want to give it another spin in the LRU.
 
The intention was that the percentage threshold would avoid giving up
on reclaim as long as "sufficient" progress was made. This should allow
for some folios to need another trip through the LRU but...

> My theory (from merely reading the patch, maybe I missed something) is that
> a pathological case for this is a lot of folios added to the LRU in a row,
> that are set referenced (or dirty). Say SWAP_CLUSTER_MAX * MAX_RECLAIM_RETRIES
> - it will simply OOM too early.
 
OK yeah I think I see the problem now: this heuristic applies the
threshold against all reclaimable pages but that falls apart when doing
SWAP_CLUSTER_MAX chunks of reclaim.

> The other question is whether this effectively solves reclaim problems - some
> hard numbers would be great.

I shared some numbers in my reply to Vlastimil, but if there are other
cases you'd like measured I'm happy to run them.

