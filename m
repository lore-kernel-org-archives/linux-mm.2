Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A3DC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 23:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70B88E0006; Tue,  5 Aug 2025 19:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B218E8E0001; Tue,  5 Aug 2025 19:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A376F8E0006; Tue,  5 Aug 2025 19:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 946398E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:30:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36D42140295
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:30:18 +0000 (UTC)
X-FDA: 83744299716.13.4BD8598
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf03.hostedemail.com (Postfix) with ESMTP id 454F920007
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:30:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLmpCmZY;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754436616; a=rsa-sha256;
	cv=none;
	b=Z4r5AivqINfy5FzILkcL1T34Y/on1ALP5ig7zwgU2lnbG9KkoCDiz2Xz1tcssA5wAMM5Jo
	4D7ozu9CuWSqSNHWHxMncmnfSSa2Ovq1gMSnTIXxIWtKZ8RRVugKhrA83ksf+q2+QHqetW
	5qSR0DDYcGxpI+ITYEvzy8//k1OzMUg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NLmpCmZY;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754436616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYU9E8/GtMxie4CN3VAKHJKBAQdCD9RBBaZRkZOJOSA=;
	b=BtnJkk+gO/qZ0sk/RG5kSJRgxwUh+eZ2GfdpjktAUPKUFM1v26TZHi7dQG1IM0PTmbV7x1
	Jb2CJaGj+Nfy2129Ot4lJj6oJlmqo+2cK8Y643gx4cTjX9qyUXch7OyXSLfw4CNNTZus+W
	XAd8crUR9r6XJ2TvCVXfQxk5/pvrip8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 8E5D2A56818
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1C7C4CEF0
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754436615;
	bh=AurWwft0/kG2VXE48L1u4X8kP0ymfZEYEf/HqYpJ1ew=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NLmpCmZYYhuXPbYd4jQm3g2ZWJwOzF/PrmGmhFPRqp6I12nIUYGnKEclge6u9rV9+
	 T7dvF92Wd2XlVjuV/tVpnCN0412Uu68zHguZIPKBnCSBox9aCzwbTu+NbJefPYFtcD
	 SkkVgTbTLETNPrsESvp+a2NvVVGi+N32REPbH8kBrqN4wLQKrzYl0f3wanCaggUa7c
	 H79mo4xDFllMBJgJ4couSj6tBE7QELPMWX90E1cmf1s/VCIfmOkUUmX2jN/ot5KW84
	 KLNPZuyn/ysam38tXXd0GSqKmQreK45ZhO3kxnLxCrN4/atpY139U1d5HGrz+raYG8
	 i/fVABd3wFm0Q==
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-459d5ab32d1so38265e9.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 16:30:15 -0700 (PDT)
X-Gm-Message-State: AOJu0YwDPo0D9+rdr3A0EVc7jpD7y1XMroYFPkudd56TArhtrF4rpanK
	tvlfE+3L6TffvVlIORovOlO3pjtipkZDrk6ZYpoKSbbP8Nqx4P57KghZW/RW7EuP2AZ2nzjY6Gm
	0jCWV+MLrMztB2xnZzIiNoo8P6hs8uYJVA8kl8nGf
X-Google-Smtp-Source: AGHT+IG3PMiScD3qbIYh5VUh6lcYUbjTYVJUKBP49fdNfQWRFTwKG+WZIIFDl9jUb9q2WKH0ejwk8EEJYQ8uZXZ8ipw=
X-Received: by 2002:a05:600c:3111:b0:459:d7da:3179 with SMTP id
 5b1f17b1804b1-459e74c0f21mr296005e9.5.1754436613909; Tue, 05 Aug 2025
 16:30:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250804172439.2331-1-ryncsn@gmail.com> <20250804172439.2331-2-ryncsn@gmail.com>
In-Reply-To: <20250804172439.2331-2-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 5 Aug 2025 16:30:02 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPY20cybaFqBXk34sEgZ8ydNOk7AoOtmNGLtdO3huzE-Q@mail.gmail.com>
X-Gm-Features: Ac12FXwfQtbdLl-ZH8xY_rHbGNg2CrKCn-AyfB_UOtUyNCuCGMOEJxBOJsdu2Bk
Message-ID: <CAF8kJuPY20cybaFqBXk34sEgZ8ydNOk7AoOtmNGLtdO3huzE-Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm, swap: don't scan every fragment cluster
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 454F920007
X-Stat-Signature: obso1rdytk87qr3xfiktmgyxwqtyyxc7
X-HE-Tag: 1754436616-509623
X-HE-Meta: U2FsdGVkX19g1yoZSAhMEBlyt/WKEY3++IRlIaKOGtlBlZqocE9pcBRqB7HOQ2HkBypLoNuAJwupNM+YMNo3AhCbgCnR++jKhCpky4CEesGWHS10vlWayN9X+sXf/SyREebBQLBXPvqqgofV/j7gWtevnnTpbSJHSQa0QDT+fHkdCJoP4FlN2UJBgkf90WsRXfRm+sOe2hRdyws0Ys2EZzfoZ1yS2GEALjRt7ETvdufdciUBO1qBJogI2TBswUXR+JEVpldnVmZtL2HZIw6oZW9a9AREvTPh2W+sWuDCGs9Phggh03EMakDIj4ddTEySfTGrGr5rS0zNEOpplK2gtYIbxajyBoCGiE1XM5dXvXuXxw7I+Jlzlwen3Yh5tJIXSOWuIZ+7RsaODD8JIt2nuVJn3XWn02TK7JaCHk9mLBIZm0QRl8OoKx3jmbxT8SNoA7zA/Xb10Il7NW1kSK86zuIPRTkglTBwyofanbToj/LDFRZX3DMVw2B3dZgjIP4OkOTnJTQUA8f9VdFVW4bYTaMJ7RiK4gbvp/PeZgupUWu2ZHVQUpxlbLHYH39ZIkYUeT1an+b6ATMAaujCh9r+MZ68d477bJwGhyYZ4RKDMgX1kgXU1FdachFTbtOtN/QAEBItfu+dos/dn9XoBagz2TlSVzgXA+GjMVGk6mvhl2kTGO8hRww7t7+sJtIY4S1dEOyhtTadDR168DuAfpvNassw0f12gZi0Peob23HoNnAs6nttqH1oKVwnFAfABoGySJ3/WtK4sqpGst6al5WmAQcBDSpJQ1N5g7D5jQ+bvjKfJx1/Hpu47QiTn13EDsZR1pTHZv9UpSrgJY5ayscjd0jVt9X1ZHYYgfxWv7K+Wol78gXSSuZ4g/Npi3uUPoKRvqt7lFQlGU+yLoox4ZAhozqh0Kp4BjMpRPIZU2lhkWqIPmIE+TZviUZpaUnDnj/BrlaGBE5BTDwS/3FR4lj
 IZn6iaXR
 CW5JPrh/cpe2qxp0VA+evTsmD5BlHPLCpHiJ02dtQkxnzrFHzbTYfNFwwk2U1yc3WyWFSxXfdkQ9z2s3aL+zlbF9VCPzhcN2gn1bQKP7u9/YbMiau5jSucxnLw65re/4mOWIEjci+cqsDi7FZg71PZPAS9iLa6tBBdTI6TiRi8RkaV5c9NAKXMW+TZE/KCzj0exRmF7pZadHPb7PHvdvEhAmwud46M0WfF/340mqFkz1U+dqD2/KX8VoFN4HZ35SkQG5e84xIwc4EMd5DC3fBpw0m0obUYOxEGP7RfDJ7c5exu2bUygjVBWRJTbZDuK7A0e8tKLoh5ExqEJ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good to me with minor nit picks on commit messages and comments.

Let me know if you will refresh a version or not.

Nit: I suggest the patch title use positive terms, something along the line=
s:
"Only scan one cluster in fragment list"
"Don't scan" seems to describe what the patch does not do rather than
what the patch does.

On Mon, Aug 4, 2025 at 10:24=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Fragment clusters were mostly failing high order allocation already.
> The reason we scan it now is that a swap slot may get freed without
> releasing the swap cache, so a swap map entry will end up in HAS_CACHE
> only status, and the cluster won't be moved back to non-full or free
> cluster list.
>
> Usually this only happens for !SWP_SYNCHRONOUS_IO devices when the swap

Nit: Please clarify what "this" here means. I assume scanning fragment list=
s.
From the context it can almost mean "map entry will end up in HAS_CACHE".


> device usage is low (!vm_swap_full()) since swap will try to lazy free
> the swap cache.
>
> It's unlikely to cause any real issue. Fragmentation is only an issue
> when the device is getting full, and by  that time, swap will already
> be releasing the swap cache aggressively. And swap cache reclaim happens
> when the allocator scans a cluster too. Scanning one fragment cluster
> should be good enough to reclaim these pinned slots.
>
> And besides, only high order allocation requires iterating over a
> cluster list, order 0 allocation will succeed on the first attempt.
> And high order allocation failure isn't a serious problem.
>
> So the iteration of fragment clusters is trivial, but it will slow down
> mTHP allocation by a lot when the fragment cluster list is long.
> So it's better to drop this fragment cluster iteration design. Only
> scanning one fragment cluster is good enough in case any cluster is
> stuck in the fragment list; this ensures order 0 allocation never
> falls, and large allocations still have an acceptable success rate.
>
> Test on a 48c96t system, build linux kernel using 10G ZRAM, make -j48,
> defconfig with 768M cgroup memory limit, on top of tmpfs, 4K folio
> only:
>
> Before: sys time: 4407.28s
> After:  sys time: 4425.22s
>
> Change to make -j96, 2G memory limit, 64kB mTHP enabled, and 10G ZRAM:
>
> Before: sys time: 10230.22s  64kB/swpout: 1793044  64kB/swpout_fallback: =
17653
> After:  sys time: 5527.90s   64kB/swpout: 1789358  64kB/swpout_fallback: =
17813
>
> Change to 8G ZRAM:
>
> Before: sys time: 21929.17s  64kB/swpout: 1634681  64kB/swpout_fallback: =
173056
> After:  sys time: 6121.01s   64kB/swpout: 1638155  64kB/swpout_fallback: =
189562
>
> Change to use 10G brd device with SWP_SYNCHRONOUS_IO flag removed:
>
> Before: sys time: 7368.41s  64kB/swpout:1787599  swpout_fallback: 0
> After:  sys time: 7338.27s  64kB/swpout:1783106  swpout_fallback: 0
>
> Change to use 8G brd device with SWP_SYNCHRONOUS_IO flag removed:
>
> Before: sys time: 28139.60s 64kB/swpout:1645421  swpout_fallback: 148408
> After:  sys time: 8941.90s  64kB/swpout:1592973  swpout_fallback: 265010
>
> The performance is a lot better and large order allocation failure rate
> is only very slightly higher or unchanged.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/swap.h |  1 -
>  mm/swapfile.c        | 30 ++++++++----------------------
>  2 files changed, 8 insertions(+), 23 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 2fe6ed2cc3fd..a060d102e0d1 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -310,7 +310,6 @@ struct swap_info_struct {
>                                         /* list of cluster that contains =
at least one free slot */
>         struct list_head frag_clusters[SWAP_NR_ORDERS];
>                                         /* list of cluster that are fragm=
ented or contented */
> -       atomic_long_t frag_cluster_nr[SWAP_NR_ORDERS];

Nit: please have some comment in the commit log that why remove the
frag_cluster_nr counter.
I feel this change can be split out from the main change of this
patch. The main performance improvement is from only scanning one
fragment cluster rather than the full list right? Delete the counter
helps, but in a much smaller number.

Chris

