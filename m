Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC0E606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bB6kz+8o
Received: by kanga.kvack.org (Postfix)
	id B18A76B05B1; Mon, 16 Nov 2026 10:38:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9D86B05B5; Mon, 16 Nov 2026 10:38:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08076B05BA; Mon, 16 Nov 2026 10:38:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84DF56B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:38:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 168E44015D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:38:18 +0000 (UTC)
X-FDA: 85441388676.14.167285A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4360A140007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:38:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bB6kz+8o;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794843496;
	b=m634JnOdX20EnvUCUlWY9/WufyddhZIG3IhnVtHX3b7oExD1lHjiBmIQBzkOUIput9gRWw
	yiCGgvBIZJtaPbKe0idwdS8LSn8R2qczs8FCab0lBr8l41L1MYICVp91Ju8qXn876rm+it
	/6e85btGnDhsQzAH4IxbFlDcyrxoXLQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794843496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QkY1AswMgCW3uvRS9sHBimGtyREBTePXz0XOhfcgI8=;
	b=O+90DPeNx4F/ZB0ef2esQhHoXJltvvEUUvPxspDGG+uCzvmm13JChdTaPWi6OoZYKcP6X/
	UrmXIu6phpgbxuXpkdYhiJyYoGrzNgrwW4N5agpP0RBxgrvYNPb9UzT66+nmoqXlrUdFxe
	jkCmtOAMH5bIaK6O7KHbHwNn1T26gpo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bB6kz+8o;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F3B840758;
	Mon, 16 Nov 2026 15:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7701F000C4;
	Mon, 16 Nov 2026 15:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794843495;
	bh=8QkY1AswMgCW3uvRS9sHBimGtyREBTePXz0XOhfcgI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bB6kz+8oa0cYXQEup1eywQV9GIotHoHhj0TCZxw5Z5uZIvRYwj8u0leZfYPPcrOyU
	 AzVbMT/Rr8flKtmEum7ALt7bnAbChM96pxXi+w+QRzjPqhE/odtISJItpK6WKsQBjU
	 QWfVzwSCx44ye/9kP3jQsmM1xUoJWdFiCriSAoKxWtcO/RWMHKpS+Vf97RaZ/J6Acd
	 DbnWAVl+VyvF3ZmcS+o96CtFg5c/FKngm+uFONmX0wwLQbH1Xq84PfWf2p27FrxaM/
	 z0XcI9b4jmfU/IF+/+WGju8aCUrngJbnqJo6okt1xbtwKCVLll14DvkCwMV+VWt80k
	 YV8/m26jD3EUw==
Date: Mon, 16 Nov 2026 15:38:09 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Matt Salsamendi <matthewsalsamendi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: fix stale walk_end after a completed
 scan
Message-ID: <avsjPSUup6pnsZrR@gremlin>
References: <CAMPWk9NE_epOdOCbs1PGh8OQP4wjTObvjU-1Wopmu7SSNAMXhw@mail.gmail.com>
 <20261112203351.7d5bf7d0f78d652d@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112203351.7d5bf7d0f78d652d@chrisdown.name>
X-Rspamd-Queue-Id: 4360A140007
X-Stat-Signature: cqn4ejf15dbxmd38m9wo85ya5rf74d6h
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794843496-669073
X-HE-Meta: U2FsdGVkX18Ie0QJzWcnxLQM6r6lamcOHP6ICaSqlcgTMvIiXedscDM6tVZluK/gXRy1iZpjza9EkSV+puifQqEF5Mg+6kRlQjz5jqMt6h4bBiA3KFLvQ5pZB45AgXUErhU4a+8nPEoZWbCkMehNtenJOFQjZPXXKPZ+SESZQMxZNQ04tsMTZ0ZY7V8LQZS9NVJSS5OpXuAW5oiQm+0MvIXQAjD6VLQ8Z+z91yaAEa8PufzwfEwCf3UNVkC4qQwSpEvS9Vg+3YuPb9lFRYEgVBCtqx89sfcD6hxowkAOr8VKRhetDOxbbNxz1YD97Y5294JHLUfyjVz4z93UiXTCQHqIAvD6hY7dIOuYxELs54eazhFJX5MIZlrTtZjFz+iyccIjclZSWyT1+HqlhLaqUgFEHpOncnXsvbbWGeEMrtf0mVZdu+8hVd9mkQ2b41MGAHEsQ0WhHpIBHF26ZgRth9/H4rCTHUALL3Qjz96jns5VKWMO9an1OUUZvDLtjUHoYsrihvPZ3G1D6arGFlfpwiK+gEErdSlxZaP6xsGB92mtkbtCAdSHgk9KqP5tSeFMT7E1gvYCHIg0iELxzi4+ZaDVsUrhlMvjvbdM8ybvJfJMLSzWk278kv6XoEKiGM+t7ER2bB573OwRU1S7wQoNMrzZ8pwBL3LxBvCtSN5GRPlRWOhpNq3jHkfgYyOtafbmoBow9Ecv8O0GNsw+VNjazOJXG1YRwsvu8e7+W/t8p+Qq15lUHP0kxsBoQoFTg5nf2IMZ76iKiq1Z6mtfQD16PHlMSw04FEbJA5kXs3/6nbtYI/WE56EfNX4VxL7RY+ZXuRUF9v3LVCG5O6qI4T8zYdbQilbYIeZ/wIzGwiedJDD0JM+dCZccg1zyZsAuwxqBEvu1ovFlf5NdEQluGX5ZqKSXMtF/O5Fhpt4lvCPcJP/m73A9eaqbmvsRQubo6FCRJHK7ciM47cZIPFnbm6J
 EBiz/oeM
 DAEp6+NwIhIXKolcTUlD89dJOst9k6fYWjPtfu2VYsNZCKq6zsM65au2FDYBGj0mSVmTYH05BulM57BjdRrQCTlxcJ2JJDuv16kRnqf7egB991s1GEdW2TSDdJSSTDM/BhMsZeWFZI3PPJsYTwhJpc68KhKiCHRCPL6DT4txVijfD95aCR17KcAweyQrXb4dp6kUW/LbtJ5Gp32fPqYGgjugZRZ71Z/cUP5syDGs1Hz+i/mUn8fA0UPiTNapsdZyfW/Y8FB0VpD9nZTO1mZghDNaRKey8ghyi5MFT2l7VsBikAaYCbMD73OwZyaA8rPL0cnDgoDolJRCQR3QeTw2sX2LbtZhdDcf499kG8QWbCJMVbUXDRYHyg9ae++6P0c3yIkUeOZu8rkZF2Szjh7fDm/laDXWx5alEsVF4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 08:33:51PM -0800, Chris Down wrote:
> Hi Matt,
>
> This patch doesn't apply as sent, because your mail client mangled it. It
> wrapped long lines, including the hunk header and the Fixes tag, and took
> the leading space off the blank context lines. git am rejects it as
> corrupt.
>
> Please send the next version with git send-email or b4 send rather than
> through Gmail, or set your client up as
> Documentation/process/email-clients.rst describes. It's worth sending it to
> yourself first and checking that git am takes it.
>
> Matt Salsamendi writes:
> > +	/* A completed walk may follow an earlier full bounce buffer. */
> > +	if (!ret || !p.arg.walk_end)
> > +		p.arg.walk_end = p.arg.end;
>
> While this fixes the refill case, ret being 0 doesn't always mean the walk
> got to the end of the range. pagemap_scan_hugetlb_entry() can't
> write-protect only part of a huge page. So with PM_SCAN_WP_MATCHING, when
> only part of a written huge page fits in what's left of max_pages, it backs
> that page out. It sets walk_end to the start of the page and returns 0 on
> purpose.
>
> Before this patch, the caller got walk_end pointing at that page. With it,
> walk_end comes back as end, so the caller is told the whole range was
> scanned. But the page was neither returned nor write-protected. From a
> quick test with a single written 2M hugetlb page, PM_SCAN_WP_MATCHING and
> max_pages = 1, the ioctl returns 0 with walk_end at the start of the page
> before this patch, and at the end of the range with it.
>
> Maybe it would be simpler to clear walk_end before each walk_page_range()
> call, and keep the existing check after the loop as it is? Then that check
> only sees what the last walk set. In the same quick test, that fixes the
> refill case too, and the hugetlb case behaves as it did before. It would be
> good for the selftest Andrew asked for to cover the hugetlb case as well.
>
> Thanks!
>
> Chris

Following on from Chris's comments, I think something like this should work
OK? It's also nicely simple :>) And obviously avoids the hugetlb stuff.

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 22361607020d..1b87cc635a34 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3160,6 +3160,7 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 			mmu_notifier_invalidate_range_start(&range);
 		}

+		p.arg.walk_end = 0; /* Reset partial walks. */
 		ret = walk_page_range(mm, walk_start, p.arg.end,
 				      &pagemap_scan_ops, &p);



--
Cheers, Lorenzo

