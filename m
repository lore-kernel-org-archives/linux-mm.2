Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 978A6CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 10:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB736B0005; Tue, 19 May 2026 06:16:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9C436B0088; Tue, 19 May 2026 06:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB3976B008C; Tue, 19 May 2026 06:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 975106B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:16:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A64B1C0149
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:16:26 +0000 (UTC)
X-FDA: 84783764772.08.5C25BDE
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 40D9418000C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:16:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CbMiw2X3;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779185784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5n5Fe+/tJE004wZ1LJmzBZg7dYty0bEFgclGXQmBao=;
	b=G+8FXYcblc31L3eULw6gz8cKPZTf3rjBzyYjx1n5uaeGrYzyKXwEJl4ItbsxDQaFqrVyDe
	kp/HQrAiIvCwJ4oDYhndBUWBRDQ/wbV9yNhaDSpIfdJWmwVbMVsCzSg+irqpHccujG40SB
	X1o1S+8aQhtoNx4ZKE4XcmJWokVIRqg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CbMiw2X3;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779185784; a=rsa-sha256;
	cv=none;
	b=71GBrcsvo5jR8QMuKUAb4H3PLtnuWgKoSXF1jTENS/P9NlpeYWEFDqc9Ys1Sh5ncRMrjDI
	YQGvuKfz5iR0q3m5PI9MHOY/JpXbRQfFSRPnYxX0TZw4y1b/moTKtt5Ivja9cAD5WuPcTz
	5JyJ6t2fVfbZtRtXw22mHXMhvYrT59Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779185782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g5n5Fe+/tJE004wZ1LJmzBZg7dYty0bEFgclGXQmBao=;
	b=CbMiw2X3VPL98P9K0A7EL0bMwkRWTK8qxiqX+MvlsklT12/CyVuQYu5Yy4lClKjKXD5vpz
	xCstGoOYLD+3wNxH0Uql7q2JaW9UDw30wO9Cch0cywyBSLJwO6m5mOaJKWPmXCM63UOOFk
	IAVzLlVG/bFhK+sV3lgIyW0s/iMRSOU=
From: Usama Arif <usama.arif@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org
Subject: Re: [RFC PATCH 0/2] mm: swap: allow per-device skipping of zero-filled page check
Date: Tue, 19 May 2026 03:16:14 -0700
Message-ID: <20260519101615.2876646-1-usama.arif@linux.dev>
In-Reply-To: <20260518073455.2495934-1-youngjun.park@lge.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 40D9418000C
X-Rspamd-Server: rspam06
X-Stat-Signature: 7r7a1b1ktyo73wp1rhkodhuyhpxfa68z
X-HE-Tag: 1779185784-686225
X-HE-Meta: U2FsdGVkX1++BmXpKYV0F1ye6iYBl1eoOEAkxrc1nrelxP8UFuzpuP7MVB/Houf46Z+DgsYnpjQqVk8/qh/NbRPij2Z0+MIkLxNC8ceoWkN10OPRRavnB8pdX7f1UgPO6CpuAJp1ayCbAyJR+2zSCWpGME5UP8zMpTIzQ6S6Bwysq187gQpoLypa/+LbY/i94YE7sYcJYm+YCEqS8py78KVkuu73P5sTMccmVOiK1SR3QPDsZBXre/O8RP/VN4OwJ+mJzC0wzJ3Fs31SI+Dqp1zdkJ2vldeLpahidjhCNGgK5q2FVmhZ9FeRoG5T+KfNvhrUFEPQsL+LRlUu2yVHPjuIJPchLFkbHeZ7Pig+QB2XaN+nAq6Au0gbss4k2d2/ez9UIqoxz8PQsYRVuYzdy0qOUEjdYJowNaa0EJJgVxATd1qYVA40+tmuCw7H80pf9iEs2MB1ELd16TZm9I6+hhYvFRlhJpg3iFfQLyHJOFHBktLzxUOir6HoMnvWuAEzVfCbDkk6hnrcmfibV155fLtDtjDhhjc8tFHzdUTI3KtFjHSNSxHaqtpNWDGNp/LcgsK3/Adfdq4qLBz8B29wLI4oqGmw2IaFZXmN3N5JauqQSCb9ckQhNJwl5bp1HqUxqSRRjKj63wrDBaRv2yUi7KWILAVI7TCTvslHchAXAmxqREJZU8ZuDEkViNaWCGJhgkjBpYs9GCewDbpb1FdLRtbyLxf0EpJqO6f4EPRyEtZvW3qpBtQY1tabGDrE9q/E2qumsiH57fBDq24SOTQMMKMWVeZKirvfzJp5popYfXsPfYw4+6ZUNCDNzySy5NJRXGqOfUCURnN8YPRlAj5zx3sbo8cBcD4YCboK6N0YLPJharN0F5qTGpYyr47ec3kc1i8rkz8+7JLC7M3LL7axyhg+YjlZTqdqS++24NUvnvBXfLkgB52wTZLxSc+P8qq+ltyh41jvwNcUhTbJ4Hs
 6SQRXUaA
 G92IZ2JwL5DnRLs4AU6OOBDFlTRfoPW5KTV3cZsFnf8VX6Om7UZKn8V2O0h9wRSEC2mTbGTqpQaz7lrO4umzX4ylSD3bFkeXo7umi8J67CxQmb8fgMLsrACxXjQ6P35VOYhkERhcbS10AlW63jOS3zFlW7LjfEWocC70GbWYOKSSz/9jDtx3WqI6nTsCQpfOtbAX2xd3sy6vRrzHHMPOVTqxE5vd85oL8RITRaxLIYYOB4ONSUGzxJ88U0tKmm71hIQxdu/HNkZpADo4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 16:34:53 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> Currently, the swap layer checks whether a page is entirely zero-filled
> before writing it out to the swap device. However, some swap backends,
> such as zram and our custom swap device, already perform their own
> same-filled page checking internally. This results in redundant CPU operations 
> checking same page pattern.

Hello!

So IMO, we should go in the other direction and remove same-filled page
support from zram. When we added zero-filled support to swap, we removed
it from zswap, because its not worth the extra overhead of maintaining
this in zswap.

I did some analysis at that time, and I remember more than 90% of the
same-filled pages on server workloads were zero-filled. I think someone
else did analysis on android (maybe Barry?) and it was about 85%.

IMO we should just remove same-filled page support from zram, and keep
this centralized in swap, so that everyone benefits.


> 
> This patchset introduces a new swapon flag, SWAP_FLAG_SKIP_ZERO_CHECK,
> to eliminate this redundancy. I introduce this as a per-device flag
> rather than a global setting because traditional swap devices still
> benefit from the swap layer's zero page check to avoid unnecessary I/O.
> By using this flag, userspace can selectively disable the zero check
> only for specific backends.
> 
> Furthermore, on certain architectures where the zero map is managed via
> a separate bitmap, skipping this check allows bypassing
> the bitmap allocation entirely (saving memory).
> 
> This modification is based on the previous discussion with Nhat Pham [1].
> Additionally, this patchset is built on top of Kairui Song's recent
> patchset regarding swap table and zeromap modifications [2].
> 
> Tested simply with zram on QEMU to verify zero-filled page handling.
> 
> References:
> [1] https://lore.kernel.org/linux-mm/acQvNRLpHwnHt7i+@yjaykim-PowerEdge-T330/
> [2] https://lore.kernel.org/linux-mm/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com/T/#t
> 
> Youngjun Park (2):
>   mm: swap: add SWAP_FLAG_SKIP_ZERO_CHECK to skip zero-filled page check
>   mm: swap: do not allocate zero_bitmap if zero check is skipped
> 
>  include/linux/swap.h |  4 +++-
>  mm/page_io.c         |  7 ++++++-
>  mm/swap.h            | 12 ++++++++++++
>  mm/swapfile.c        | 14 ++++++++++----
>  4 files changed, 31 insertions(+), 6 deletions(-)
> 
> -- 
> 2.34.1
> 
> 

