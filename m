Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00C4FCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 07:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 274978E0009; Thu,  4 Sep 2025 03:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C0F8E0002; Thu,  4 Sep 2025 03:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188EB8E0009; Thu,  4 Sep 2025 03:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 053908E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:29:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D55B13BCC8
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:29:29 +0000 (UTC)
X-FDA: 83850742458.22.1BDB802
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B3F69A000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:29:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lpLYW56T;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756970967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PsjHqYi+v0pKX/OA0NyhPUfxs5GwGBB5+EJVUx97FK8=;
	b=z7aThYbc0VzNnX+o8fhOUNzLoa60uwLzBgTung4dYF3u72luckFkBYUtUYEP3qn8MI7QZf
	tIjHT/NZhs2f7nkktLcLVV3A54f0SiT3IU5myjdoXdOZn3lJqvplojtDe3RTSeBRlsOSTo
	Jay+0sMmy4ovRj5iXNtvhKlr5BiVO+s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lpLYW56T;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756970967; a=rsa-sha256;
	cv=none;
	b=X6XsWCrnt+orK7QAfYvjt+HIVYJOkTniANJHGU35/kapYFpy/yQtg+Mvu2h6lOfoz7fTRp
	/VwvQqrh0cFAYDWelyZQbw5obZiXiDxheaupreMmTycViOVX68LwQSFKO4RIQ0d2IpqDvS
	F46d+nvLhefbkYuxukqeKAPTXO/5Dtw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C801407CC;
	Thu,  4 Sep 2025 07:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE95C4CEF1;
	Thu,  4 Sep 2025 07:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756970966;
	bh=BY/OoUnvgSfJZsul+fsudIqn4N54F8eZC4uQXTXlMqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lpLYW56T1SlyqzHeRsk5RTAV3P7jkzy9LyidtUd6wWNooqDh7q2o9Sbm29+0TOCr7
	 4a2nVcvvjFnxoqk/kZR7Yd7KsPhuL7AuQiuGkaHE2tWjYdg8hNiDZGt+x22zSFX4Cn
	 hDevTJvBZ74DhIuCBxBA4kVLOTPu3DQiTPaeAkKt4pxsejpFntRhe+ADew1zonNc2G
	 4q2MTO6OkwNS2Jdr+W7X53iGmZqiUj/G9G2RVp3U9L7DQCFVH+/RkrR/bSrXATmdM6
	 DZVOH7Tds/5rZc89LCE/g4d0RPVzOOtaDATkrkowaKz25XSGnkxVf5lzQLli9RpbWO
	 5mpfUZYI1JIGA==
Date: Thu, 4 Sep 2025 10:29:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org,
	lorenzo.stoakes@oracle.com, kernel-team@android.com,
	android-mm@google.com, David Hildenbrand <david@redhat.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
Message-ID: <aLk_zbXxYxHs1Igk@kernel.org>
References: <20250903232437.1454293-1-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903232437.1454293-1-kaleshsingh@google.com>
X-Rspamd-Queue-Id: B3F69A000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: u5zppr3m9aizspjab654fent3imn4uzr
X-HE-Tag: 1756970967-231272
X-HE-Meta: U2FsdGVkX19vpCz25I8nwvBoQbloA4b45FA1kpYPYpMJPydl31ducHaJ9D/bTmuKhnGK0TuAJ2Q1HzBhUIVvgNzWugHWs0oS9GZg73XyZ5DO8zvLJHCieQICWuIOtsY4h3lFH8DH/csEu424SDvbOyCZDIVa90XWITrPMoynvQIF6W262T0RWg2DzgBhsHqoorkJ7z9/rTw0ObY9AwJEKZXBievSERJg9EZgD1f4Blt4E3kt0FgeyQMN/VYR9qI2PrUsgf7qiZmGucatVjn1FIfqMZHA20BR8l9FCsXjkjAnBuelkhOFB/9q2vscrp/0s1kBh4mEXueaN/Kn9hkky+OgAJujITmIMXe5ksXVSVIFCCIf+QTqh2OUdksEo3YuE63s2ToWq7mGVPiglrap25MI7J5PhDPNTMUsyO+DGDo5eqIgtoDKuH5EzmTJk7n0bZVfcmWdB5vPQrEXyHKudOnPILBvisMBJ2g0/WSEZNInLtNsd3wZ6kAVuleThhM+DNVXfw/FrUo1lOx15TaIJ/NJX50sDcjggUc7/PZCccIdbjdzXQoTCt9WcvcCExZXWgJBIJKTcFaGuFeJCLTGCWRh5DEgBmQokGOrvz6Vlv2r3fOl0E3zNPT+0eULypXY9ImueKLRlddby4ZyTMQYZUlot9h0d3kCQeQHpqq20Gvl8wv6ctZbaey9I9CxS99FsnRwXiF5jW+IQkklYiIAmSSfB3AnM6KMdG3xwrvnYL5N2cdyVabD17D8J4Qd9x3nrBIjE9E3jlFakwBwmrGYJPSEokJX3H2pH2ZUBK024RJwYkAV0g+X25/LGO9ZSlgYEsYwZv8iOprDyyCc9/S4IJhid+/qOzglAmY5MsjpwBRvdvLH7CvkJ0wNokL+gAbg0B6X9gmALM+Lu0BXFC/xk0MBXL6S7Ft8+P86vVWw3ExwNXkmgdwkwFvficte4S5kw6+qpZRtuL9nFSpKbtZ
 +l8sulT8
 n0frBaD4pr7TbYhGUmLfT6ycXSltn4v+LZNNEDTNduRl1iCJWQeax6x+pLJVLHbSBYL7KaLCIK8PzAMxnpvD/LREnOPiUby4wlhuFXo/hyXDNyW+e/OwkJ7ANEIWPfZvRXpYlJdAFC9SGFUuZCEY4KbFxRwuBJ5Ya6ust5xHXcoQNmryZKbm49RFPFeDGsNcnWJNU5xjS806ZB5trDAXNHJ5GMtbyESnmCPl1nb8dl17LQrhOAzpvT/84KxurrdOJ7XuOEzqqhAt7jecWAGVGq2E0A5rhAp2c9CWjskItI4EP/tee6aUwHZk0xAbjtMb/t7vctfGudWdg9cv/aU8x8YkF2JxEjIyymggjgfJYbFBqYQPm9zlrY1qVw0Ud8l2QNWqUo9K5/rzfBuWO9fq379rghnUJkjI8tN/2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 04:24:35PM -0700, Kalesh Singh wrote:
> The check against the max map count (sysctl_max_map_count) was
> open-coded in several places. This led to inconsistent enforcement
> and subtle bugs where the limit could be exceeded.
> 
> For example, some paths would check map_count > sysctl_max_map_count
> before allocating a new VMA and incrementing the count, allowing the
> process to reach sysctl_max_map_count + 1:
> 
>     int do_brk_flags(...)
>     {
>         if (mm->map_count > sysctl_max_map_count)
>             return -ENOMEM;
> 
>         /* We can get here with mm->map_count == sysctl_max_map_count */
> 
>         vma = vm_area_alloc(mm);
>         ...
>         mm->map_count++   /* We've now exceeded the threshold. */
>     }
> 
> To fix this and unify the logic, introduce a new function,
> exceeds_max_map_count(), to consolidate the check. All open-coded
> checks are replaced with calls to this new function, ensuring the
> limit is applied uniformly and correctly.
> 
> To improve encapsulation, sysctl_max_map_count is now static to
> mm/mmap.c. The new helper also adds a rate-limited warning to make
> debugging applications that exhaust their VMA limit easier.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>  include/linux/mm.h | 11 ++++++++++-
>  mm/mmap.c          | 15 ++++++++++++++-
>  mm/mremap.c        |  7 ++++---
>  mm/nommu.c         |  2 +-
>  mm/util.c          |  1 -
>  mm/vma.c           |  6 +++---
>  6 files changed, 32 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..d4e64e6a9814 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -192,7 +192,16 @@ static inline void __mm_zero_struct_page(struct page *page)
>  #define MAPCOUNT_ELF_CORE_MARGIN	(5)
>  #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
>  
> -extern int sysctl_max_map_count;
> +/**
> + * exceeds_max_map_count - check if a VMA operation would exceed max_map_count
> + * @mm: The memory descriptor for the process.
> + * @new_vmas: The number of new VMAs the operation will create.
> + *
> + * Returns true if the operation would cause the number of VMAs to exceed
> + * the sysctl_max_map_count limit, false otherwise. A rate-limited warning
> + * is logged if the limit is exceeded.

kernel-doc will be unhappy because of missing Return: description. Please
s/Returns/Return:/

> + */
> +extern bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vmas);

No need for 'extern' here. And the declaration should go to mm/internal.h

>  extern unsigned long sysctl_user_reserve_kbytes;
>  extern unsigned long sysctl_admin_reserve_kbytes;

-- 
Sincerely yours,
Mike.

