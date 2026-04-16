Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB6E6F433D6
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 01:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A52B6B0005; Wed, 15 Apr 2026 21:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155EE6B0088; Wed, 15 Apr 2026 21:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06BA36B0089; Wed, 15 Apr 2026 21:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9B316B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:45:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A34D13B7F0
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:45:12 +0000 (UTC)
X-FDA: 84662726064.11.AA060D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7C03A40002
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:45:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TuGwlXvc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776303910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFRYcYHFwWNWxcwH3DEZFlTdGdAHPsKBvY8s9ug6UTU=;
	b=PbOIg/LNiyJKC4gpKUD3a//tZz3oczvf1zT1UtWL1Tc0x8dywUaNgdyVw+IaDRWxrmiDof
	7tRAg6UMP40aRm+K3qoNLS8AwMJeX2KTfW0YEUtHQHNCszVpIhQuIcXsQ66IjhPuPxWFno
	H9U+/jQ8hYj97EUMYJ1hf6sxgQDBHR0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TuGwlXvc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776303910; a=rsa-sha256;
	cv=none;
	b=bUvVm3fNTUHypRwDKQqgIcyo87hX7Ng74bJvrbsanB2/9/PIOVwXMekEgViid74K0fjslJ
	L0lbataKWM2N08XTfMDYcYeGsoWcEmS7zZ4+mzAtl2Yewq5csrwL/3fy1CfCRwE0aU4EL/
	eN5R/wnwJgzZ86Q+6mgpzYQ+fS+9SCU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E760A6013A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8499DC2BD01
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776303909;
	bh=MFRYcYHFwWNWxcwH3DEZFlTdGdAHPsKBvY8s9ug6UTU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TuGwlXvcDhApwrs1LZGY7ksdFNnDMYkaU8hh5Ne49KWBPlV11T95HCpDUZninrq9Y
	 ffem1xYv5Gpem3st61nAmqnL09KIF7IydZSboTz5qLP7fXKfG6CHfZjRwSSvRjZYF4
	 lp7AXVb3QIm2eouG9jZg/1ChNX7cdh/adYYOQ+WMF8gPjfONPkLZtaMJm3V+ztSW9f
	 V2zxH9xy7frJiZcKGiF/lJ1DcFYp1u5dhs+KPYbUGp0RCMyqXrmupBIJ9/LUFzwXZi
	 cZvq8pviiqAoeYhxmJhWOZoREiFmol2ECLF1+5rn/8b0adGa6Cjp4ZvEWKe/qbVTyj
	 g+t6GQ2s78rcg==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8aca4e14411so53145476d6.3
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:45:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9nW7op2O8SFWxIrqPlfkUDXnccxCoUby2NYpgsfrOzAFMr2ZGJB/wiWTBqYXsPY+EIIoFeVzNF2A==@kvack.org
X-Gm-Message-State: AOJu0YxYexBhKI/6B49jGdDrAymxuqmLdw4/AjmTr44CCjC7L4545IEk
	c0PjMOGsfYN7cGXJRA6jrDlfl58BAbg05heEgd7zUvgh6/+p6WUPoX7XZ4ojuPEUApxcXoP+q7f
	fHsC7/Reuy81ONrRZC1cfFcIsxfT/wPE=
X-Received: by 2002:a05:6214:2b0f:b0:8ac:b43a:42d8 with SMTP id
 6a1803df08f44-8acb7acf810mr193354176d6.12.1776303908511; Wed, 15 Apr 2026
 18:45:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260410101550.2930139-1-matt@readmodwrite.com>
In-Reply-To: <20260410101550.2930139-1-matt@readmodwrite.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 16 Apr 2026 09:44:55 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x96rrt+T5efMEPR1YmhTY_Ce2S4mZwN3sqB3Hx01=URA@mail.gmail.com>
X-Gm-Features: AQROBzC9QiVyZl19UNIoiJFZNBsS5YVRyhULjuJkIjPLorZROfBMhFAK7htjbRA
Message-ID: <CAGsJ_4x96rrt+T5efMEPR1YmhTY_Ce2S4mZwN3sqB3Hx01=URA@mail.gmail.com>
Subject: Re: [PATCH] mm: Require LRU reclaim progress before retrying direct reclaim
To: Matt Fleming <matt@readmodwrite.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Minchan Kim <minchan@kernel.org>, 
	kernel-team@cloudflare.com, Matt Fleming <mfleming@cloudflare.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7C03A40002
X-Stat-Signature: pzmgdam4cb541378q9rf7dj4p9jm6d99
X-Rspam-User: 
X-HE-Tag: 1776303910-406399
X-HE-Meta: U2FsdGVkX19xBg4Rt99/MdXjSfeyC4VTOYIDiyVn/Uv4EZl0doblvX07dVEKn8ISa2H+HqvL/dy72RSsjdqj1aXsgvDjOVHC1mMnXaaKyTJ3/O6r+2WriYA+jIQ16vxN4TywUyharUdOM/E4R6hZoUrDlgqt3K58iNgfQyXUuG8CE0jjJAcrZ7Yea5sdSFgme6EUnc1IIHH4Adna0K8m95lpO8SdWbXuvNQ8KGgnhsqTbPN8H+eMZAK9a+e1RjT7X6OwxrzhIYApGns02uZVjpzzmu6I6EYjyPDqcF5ZYKmOt2fqsFuDyGe5ylhUuQ/p/tbO19hc6nneW3+7vnLMrfpzAbeh0q8kzh7h4PI8VkDVVTsI9CRE73WTLYx+WEqYKCt91NRvIkFF/HmoMXklJJ4t7umd3e93e4ME1Tos6fABaRhZQNQtU/NhVbV6Q2zxHK83PeFllF93sgu5V3GzndT4W70PgRNAxPcQE88OUyyh+OtDcDcOPc7o1v0MdZMxlbRkO5wl/zxf7j5b+YCumbHPEr32Vu6S75XWqtEEDMnSg1pQWOH/uwoVYFGIrz0fDsNccXyT3cG9YyLV/zMUbtKcMXnBoW0RzKVvwZGefRYN+ORqOqrrp/7xW2/YjvWKBtXCswyuVmGG7BbLIo5XplHg2gb0yc0VrGdN2BbgSX6WZK+Ikoal2DGoCVtLvnqf/yOEI2bJgl0vXRNLJyXenNEshMdRrjD00AU1KTGMot9l14hLnF3Eg0r5/ROFPVgQDWUWD2kdqVJw92gKN0QmYRllTt2GUXaFv7vBXhBJ6mLaWsBkatsH2PdBSjHxLizT/mH+orBdeWfesIC8rKo8NrUmi9k91YuzpuzPR33hv1yP8yTtx/dt7HbVCx1nSG6PKjdhBE/nYhvQ1YDWdRe6XG4GB57xtjMr0Br6JiuLkYnt2igR8JIhf9EWRJ5A3YOrVv32wKaELNa9CZrmqzC
 UoWqz++m
 dDqiF4WxKhkUN3xVcNdD+hq+0hZKNCuZWhkFCluNQn7ScEwTu9I7G5TE+16/th527kEUbj/enpdYBT97neCjiE23LI16vKgqj7tsNMxa1sO5/Z8caovkgOkOQ3cL+IR97GKy+PCLKUgsTGBvsFka447jLww5+1pOJSmXH2BRzUGJ7tx79q80FtN5ACqRJ6hHz61xUiDKfAct3CDaHz+dA6EhGp97I3ZP8g33KZZaw6UyHLeUIaLhzZmdQmSMvHOT3VsW9cEwIg1LpABw99vgVsbEw9WyeePpRb0ovdUeYPm6Yndo0F6UuGEREwiLzYbezqBpU0VaL69X1LeftVXmVnJUJtCGtB3wyIY9FcleeUlnASf2feQyaz+RP7DjUkVn3Lr/cjQbhZ3PTt+uCCbqyGdokuHyqoT/q6rDncR5rHSo6pUY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 6:16=E2=80=AFPM Matt Fleming <matt@readmodwrite.com=
> wrote:
>
> From: Matt Fleming <mfleming@cloudflare.com>
>
> should_reclaim_retry() uses zone_reclaimable_pages() to estimate whether
> retrying reclaim could eventually satisfy an allocation. It's possible
> for reclaim to make minimal or no progress on an LRU type despite having
> ample reclaimable pages, e.g. anonymous pages when the only swap is
> RAM-backed (zram). This can cause the reclaim path to loop indefinitely.

I am still struggling to understand when zram-backed
reclamation cannot make progress. Is it because zram is
full, or because folio_alloc_swap() fails?

Or does zs_malloc() fail, causing pageout() to fail?
Even incompressible pages are still written as
ZRAM_HUGE pages and reclaimed successfully.

>
> Track LRU reclaim progress (anon vs file) through a new struct
> reclaim_progress passed out of try_to_free_pages(), and only count a
> type's reclaimable pages if at least reclaim_progress_pct% was actually
> reclaimed in the last cycle.

I would rather detect what causes the lack of progress
and implement a better fallback.

>
> The threshold is exposed as /proc/sys/vm/reclaim_progress_pct (default
> 1, range 0-100). Setting 0 disables the gate and restores the previous
> behaviour. Environments with only RAM-backed swap (zram) and small
> memory may need a higher value to prevent futile anon LRU churn from
> keeping the allocator spinning.
>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Matt Fleming <mfleming@cloudflare.com>

Thanks
Barry

