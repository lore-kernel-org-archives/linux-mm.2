Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3630BCD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 22:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 369D26B00AB; Mon, 11 May 2026 18:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31ABB6B00AC; Mon, 11 May 2026 18:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230836B00AD; Mon, 11 May 2026 18:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 106536B00AB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:13:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 708F5C14EC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:13:13 +0000 (UTC)
X-FDA: 84756540666.01.0D1B86D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id E921C100007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:13:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lm+VJhb5;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778537591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IWsrHdegAbrW3XQt/M+4geMl+7yVwHEqcNyvM5bIv1k=;
	b=Lm1Fd28sB8DmY2T+EycmLT4mSdMlfQT0ftYr0dcvKA/ujWdbrLarvb0XAsRE+Tfh7KsWDt
	7546P8x7pcZILUTfChSotQWLdzYd7ZjaeO4SqzuWsHNPnmICXZ6Xy/3REQMHJ6RTMOn4zk
	25xr8kGxne/jC/BD9kxEhloNME0Fr+M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lm+VJhb5;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778537591; a=rsa-sha256;
	cv=none;
	b=fsLnlVcZqOqL+mCsrYrGruEhT4DP+MiUjh19kKWXKXY0hmJ4DlkSht5pkxo2jZ9s+FmHGk
	1aY+fdx6UyicqdBvzr/xWAI7S7i51ZrOaXQs2mmcwiGjZdPBPTUHu89LVHynSrYXV3LtSV
	t70rmaoaphSaBM3Jq7fMhofrYiA6PEA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D28B6001A;
	Mon, 11 May 2026 22:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67099C2BCB0;
	Mon, 11 May 2026 22:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778537591;
	bh=8fJMj3Wfv9yngO3GQMAeJuLKC7maaCx6qHJ+90vYE+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lm+VJhb5bavqVydXuPazQLWHg8GKKEUWXGfG/0KZ825tRGTbEU0LyacTZ11W4Mu5w
	 dDp8Nf7AbRuZF8dI8RClv4XVFKOn4SRs2gh+lMpX7StkAsIm6RYHMz6XzvspCruicy
	 9TmSPo3dOualt+g4cilvFXjLZN5mS+Xxszvjvid7W5VRZJMDy296wYKAI46r6+fBDL
	 lafXkknC9mSm1xJ3CMiDcOeE404egVzM8rJWZp13gy9e9xcc13/CrqsKQa/+6UjwMw
	 fzye0hSBs+O1LhDnC1btACWcgM3g77NNyjTz+iiEwp20PW25tcyW75JIjRHe6m0piX
	 exTxyHc53N8FQ==
Date: Mon, 11 May 2026 22:13:08 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: fujunjie <fujunjie1@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Baoquan He <bhe@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [RFC PATCH 0/5] mm: support zswap-backed anonymous large folio
 swapin
Message-ID: <agJT6D5zaUD6FpwQ@google.com>
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E921C100007
X-Rspam-User: 
X-Stat-Signature: m3ufhkaxks9fk5a1tdg3e7dehhdfd4ae
X-HE-Tag: 1778537591-672298
X-HE-Meta: U2FsdGVkX19fhT5InljwzYxEIPFD5Fub4Q1QV7RLm5W1p2MlGvhlL22XE0Mhq7PTMoPUhcKQZJOj9TSv2bGkKD13Umt/+VX2JMNCLnj33tCLx6DOenzpgB3GnEZ+NZFSuBbavOW47pZl0fPJpXaJepIA5VTxY/r5QJDtj7Ygm3c0SJWalMHnVxbanv+6hMzPrpcQnzl0KzKUA59z34TR90zeSPiggOga5MBr5RbVWCd4UZIvKRwpt8dj4+5pFkj/AMnDosX28hBJGtpoU7u5OmX2jt9KK/JtYQABf/cLuHmZmUbHQZSVyadM7QYKSfdRVPstjgiBJSJSAxyrdmEvgORjUc79mhVm9QPyikaN0EQKYw+A0/cT+SwIw8V77EIsZZj2KyzplxL76HdhqB1lkRiEznpOcra3PIAyI/TxO1q5c2SFw2FdM93TZsltQgu9cH0VclnRxR1NBmbyEd29jQUdw5CDrD8inIVT2XvmfXwvSJePq4gznYjNpGcd9K/sVf0BaiuuQrMmNmPfjQJWM1uLQtfxewExdEJp6JQz7NY07o0oy9R2PxVgCAB4D+iYsFWlvHJ5DpnImVO2KNCM0BGXlCYL+UD12iyxEmBH33NzPB04HCEXbnBRFEMp87+Pg08oz1NUNG6f8688BbPICnm6w95xBsO9GEmYcDgtKm2n/X31MVr5dXEd1G4JqM9MiNK6uNbkG4q2h6GtjZ1B5+QTOyfa8kIZXHf7Gio5XxA1gpdmxcEGBjgZa67PzD9ktCcT6oatqZZOgP3uyftKMMvdm3Ox17i4DLrlnYJai6YSO4C9lO/f4cpSsZb5SwjVNEw025A3IQ7tjsgjpFrhfYVH4ieUBHhDFbeg11sx9tEUvlDR9Y3Kn3GzApqkf2DLcbWf86EeduWZIjBMAIgaIUAkJyCnNy6PT1AzqwvMdwQfM6LEvx9JoPimF0bvgkBhii5hLzH0u5q3XCei3yL
 k0UDiryW
 gtKFnFhyz0vJqqFeYWJYN6rwdEJ8lmAkgLjoduvjn/9zic83UWorGJ4JA00mePvO+xqLRqWTWWUn17VIuiS70rV4s5Pene7fSmz80x2v4qo4j6FDTRBjGwgaVSPQLN2sHAJmo4AJHOKVkJzGjTP48z45eXceVLVE2lk1IC9CphOGLnY3POrB/mxK+GWiu8+lTZ3UPaQxguG/b/12rq6e+zD6LtrHkBo5e2mJxUpVLoTsP9DGR5HcSZl3pDUC5C12utSMQEdcLGqZwdBtKWHKxYbAqgwwMEdc9L4D2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 08:18:29PM +0000, fujunjie wrote:
> Hi,
> 
> This RFC explores anonymous large folio swapin when a contiguous swap
> range is backed consistently by zswap.
> 
> Large folio swapout to zswap is already supported by storing each base
> page in the folio as a separate zswap entry. The anonymous synchronous
> swapin path has remained order-0 once zswap has ever been enabled:
> zswap_load() rejected large folios, and alloc_swap_folio() avoided large
> folio allocation to protect against mixed backend ranges.
> 
> This RFC keeps the scope intentionally conservative. It does not try to
> read one large folio from mixed zswap and disk backends, and it does not
> change shmem swapin. Shmem still has its existing zswap fallback and is
> left for later discussion. For anonymous swapin, the backend rule is made
> explicit:
> 
> - a range fully absent from zswap can keep using the disk backend
> - a range fully present in zswap can be decompressed into a large folio
> - a mixed zswap/non-zswap range falls back to order-0 swapin
> 
> The series adds a zswap range query helper, teaches zswap_load() to
> decompress all-zswap large folios one base page at a time, accounts mTHP
> swpin for zswap-loaded large folios, retries synchronous large-folio
> insertion races with order-0 swapin, and removes the anonymous
> zswap-never-enabled restriction once mixed ranges are filtered.
> 
> I tested the series with a full bzImage build using CONFIG_ZSWAP=y,
> CONFIG_ZRAM=y, CONFIG_MEMCG=y and CONFIG_THP_SWAP=y.
> 
> The QEMU/KVM runs covered both the fully-zswap path and the mixed-backend
> fallback path. In the all-zswap run, a 512MiB anonymous mapping was faulted
> as 8192 64KiB groups, reclaimed into zswap, and faulted back. Reclaim
> reported mthp64_zswpout=8192 and zswpout=131072. Refault then reported
> mthp64_swpin=8192 and zswpin=131072, and pagemap/kpageflags showed 8192
> order-4 THP groups in the mapping.
> 
> In the mixed-backend run, the workload used a 64MiB anonymous mapping
> split into 1024 64KiB groups. After shrinker debugfs wrote back exactly
> one zswap base-page entry, refault left 1023 order-4 THP groups and one
> order-0 mixed group. The kernel stats matched that shape:
> mthp64_swpin=1023, zswpin=16383 and zswpwb=1.
> 
> CONFIG_SHRINKER_DEBUG is only a test aid for making that one zswap
> writeback deterministic; it is not required by the implementation.
> 
> Nhat Pham's active Virtual Swap Space series is adjacent work. It moves
> swap cache and zswap entry state into a virtual swap descriptor, and lists
> mixed backing THP swapin as a future use case. This RFC is independent and
> works with the current swap/zswap infrastructure, but may need rebasing if
> VSS lands first.
> 
> Feedback would be especially helpful on:
> 
> 1. whether it makes sense to support all-zswap large folio swapin first,
>    while keeping mixed zswap/disk ranges on the order-0 fallback path

I think so, yes, but based on my read of the code this RFC only affects
synchornous swapin, which is more-or-less zram+zswap. This is an
uncommon setup outside of testing.

> 2. whether a follow-up for mixed zswap/disk large folio swapin would be
>    useful after this RFC

That's a heavier lift and I think we should consider this in the
longer-term, once the virtual swap work settles down. This is
conceptually not a zswap thing, you can have parts of a folio on disk,
in zswap, in the zeromap, etc. So it needs to be handled at a higher
layer (virtual swap for example).

> 
> Thanks.
> 
> ---
> 
> fujunjie (5):
>   mm: zswap: decompress into a folio subpage
>   mm: zswap: add a zswap entry batch helper
>   mm: zswap: load fully stored large folios
>   mm: swap: fall back to order-0 after large swapin races
>   mm: swap: allow zswap-backed large folio swapin
> 
>  Documentation/admin-guide/mm/transhuge.rst |   4 +-
>  include/linux/zswap.h                      |   9 ++
>  mm/memory.c                                |  67 ++++++++-----
>  mm/swap_state.c                            |  23 +++--
>  mm/zswap.c                                 | 111 ++++++++++++++++-----
>  5 files changed, 154 insertions(+), 60 deletions(-)
> 
> 
> base-commit: 917719c412c48687d4a176965d1fa35320ec457c
> -- 
> 2.34.1
> 
> 

