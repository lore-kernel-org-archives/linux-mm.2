Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A3B9D116EA
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 18:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3A446B000C; Sat, 29 Nov 2025 13:18:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D121D6B000D; Sat, 29 Nov 2025 13:18:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4F666B000E; Sat, 29 Nov 2025 13:18:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B023E6B000C
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 13:18:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40F81BC64E
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 18:18:25 +0000 (UTC)
X-FDA: 84164454570.28.070C308
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6B45AC000C
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 18:18:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BfVGAg9T;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764440303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=doTCiKgP3PeVk+fPUI2qFLmZO7TFN62HeeD54C5uMRg=;
	b=x55xC2bgEFopnZaZXdVc/UaPOaDhGym44x7E/vdN+wZT/BgOvI8Wf3yNXs3NXGfHJXAgVc
	C0X+6/UhHnhiblXGxpE2mCgI1Yz9cAwtonG7FmZq7Sz5Qu7hN7yNARLWyXgVU2wC9d879D
	aMp+yy46VZAKPY1+1hqHaRCYDLX+PJM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BfVGAg9T;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764440303; a=rsa-sha256;
	cv=none;
	b=etHwjFzwdRlvaSYECPaihUxJe5kSA/2jT3oomAsDG958Xv0tIremX5zVmfRybN31B6gcg8
	R+/MDQivVJzUlz+1hl5Ujxsw9oTOsY5jVRdH1rIxTNJsCF65hSYqJxepEBviLBemSEhysJ
	kMprFzSkIerJ32Lynejn4CSDMD0Ntz4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DCB5842DE1;
	Sat, 29 Nov 2025 18:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15885C4CEF7;
	Sat, 29 Nov 2025 18:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764440301;
	bh=doTCiKgP3PeVk+fPUI2qFLmZO7TFN62HeeD54C5uMRg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BfVGAg9T3vxHdcYOHMIN10Ajirn3UQT7XqxUxw/Ch0rkHbZC08VcQ5ueVWt60i2q4
	 aeecBO4UKbdITgqkjp2/inS3PMAU+N+LaI7azBnID6frTUlVj7/c+EbkA0lmSCz7KP
	 m4Y6+0Ddm6qGLofPeTWHPXPqLsth+4SSxdhfJ5fQ=
Date: Sat, 29 Nov 2025 10:18:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Nhat Pham
 <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand
 <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park
 <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, linux-kernel@vger.kernel.org, Kairui Song
 <kasong@tencent.com>, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 00/19] mm, swap: swap table phase II: unify swapin
 use swap cache and cleanup flags
Message-Id: <20251129101820.3dd08b93b92fb2fd58159400@linux-foundation.org>
In-Reply-To: <CACePvbUK6uSDtz0QkBq-eqzQ_Hi9+t1gthGGt+ok7xdZtO1V8Q@mail.gmail.com>
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
	<CACePvbUK6uSDtz0QkBq-eqzQ_Hi9+t1gthGGt+ok7xdZtO1V8Q@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6B45AC000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: zmwo5h8t6xa3f9so76dz1dtyab1gr9dz
X-HE-Tag: 1764440303-680171
X-HE-Meta: U2FsdGVkX1+hf4gBer/IxB9sYMbZRb6PYaBMJuizFIqyfXlSAPUW61YuhaPQfSX19sXO0llFGCcPG1QzV6GNoi6WLAuXWDGJecIIOAss7d3efAKab+gNDgxEyZkq84TWRtn5W9+/z2fbGVxV2Dnjlzulc2ykFGI9lZxEUlFV70rd4kFK7n4zgFcZUuojSZxtYjHz8mFfe37pnvT2XIdMRsQ7EkcohabTr9hO9HawFEflmRdRxuQuBsH10OQ8nGzE9gW43JhyIiakP5QSwvlJw/y9haPfWW0Nh1gEKVeBKvt/3oWVuCjwbtGAWL9l312th4RcCupLJK/BggdE9BgTp1ofgtqkIhCzAOQFgt0aocGSEDzL1cAP5ZvW/tCtkODLZGLePN4RK5naCvJb25vPonOd/i6ThvUERZXKxRxZV/mFnhGzgvTKSv9RP/YnQbU825lhTMN8tsWkZBEdDGMGvxk6oMp5LWbiqCXCtLfJNZRX76Scakp0+ufVwK34CqnJycdMxkgAdJJBos4lVENIPyUuGtOrTtTDlEOw6lVSvi+B7ctojS6eXWl1GNRJLwdBVfJj4yp76aUBWXy41Pi/XeTawf+ZNcGrRbE5nlk0z90CSH1S/VRvYKGCy+gwPCI6EgAnViMO67jmng9O1f4Rzd5ukpuZM8uGi7hFxTh5T5fzBVXxZ4tT7hmkAqvWQj5KS3bI0Urf0S9XgaAlZTh78dsk5wHCzpjhi4sSiLA1Epdp5vLXp07k+PQAWk9ULFteeFqc9ETYMXAeoKDx4mOk6L5/uZ79B66oWp9syjQ5GQbsjR6OEfAXlJeMukDsoDASOn5Kjzph5mVcgj0SaPL/nefDUZyHE5irZk5SDvGDFULKfnZP02G0SLK0qV0u8V6/AmRbVUJad5O1g/ygN0bnRgCjaw0UpfVVVpIyZdZjPXdglcL3pdWpFYzhoTQ6kM+cHdKmiNsTuC9kCTqbWaq
 g4XnePdy
 5g8nxyy2hSHy4RsfKNdury4WNFZP2/5vXhal7lSsZh0THaltYKO9wB+Y6ZjkVJIhfNsNsj84TdJm8rmd8AJk4mib6BIW4wSh411mK6Cejmcv/7oCyLVD++khHA/M/1d6JjcLo1RvFUlFfrpEMhs/H06kEsuAl3MPKBrJpomCkz4JxYvD9J5klLcPP76bIrP3rzna49/UMU4SevN64cglB0xrEOV+9FH9OFre/BW4qFSUk0TfkhpDQxeEOYxB/SdMkpapOJwjncNigBEcAO4m06Q4g4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Nov 2025 21:07:40 +0400 Chris Li <chrisl@kernel.org> wrote:

> Can you add this swap table phase II series to mm-unstable for more
> exposure? The patch series has gone through V3, overall looks OK, but
> I have not finished reviewing them all yet. I will keep you posted
> when the series is fully reviewed.

Not on the eve of the merge window!

Please refresh, retest and resend shortly before -rc1 is released.

