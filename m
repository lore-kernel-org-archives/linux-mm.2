Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF0AB606A331
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HdOnQ+9U
Received: by kanga.kvack.org (Postfix)
	id E0AED6B05B1; Fri, 20 Nov 2026 04:04:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBABF6B05B5; Fri, 20 Nov 2026 04:04:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8446B05B6; Fri, 20 Nov 2026 04:04:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B562F6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:04:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 00A991A0E33
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:04:26 +0000 (UTC)
X-FDA: 85454911374.24.8B1783C
Received: from mta1.migadu.com (out-78.mta1.migadu.com [95.215.58.78])
	by imf31.hostedemail.com (Postfix) with ESMTP id 116B420004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:04:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HdOnQ+9U;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.78 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795165465;
	b=NF3dxt2eOpSQoguDSsLzCqdO62BmAQPBUgaQMCTo8R3vURoUVjBZxlQww0/wuMfePObagF
	CDq9zWiwdGujEnLmkGSOwjP/8SKgvI+Mmxs/eZk0rKqGJukrdtHTUogQ9471z8ZwtnlL5m
	YNL5vKX3feOwt0MRqMmUuefyzCPXS8c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795165465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4RZB7pvKMGNXZ0e7P/ml5wdFAEeCdJqj2hE14qekyY=;
	b=WxLMq8bllBaLJKqyArFzNcBP+1bPWdB/b7IwyCboUWZ3BJCYJUnp5ingnZNY1+lcu6pxyM
	x9/J+pIVWs/PALD81I/9KNrN6clciVydvHcbV5JTGjet3dI/CbiwfuWubtQyR82rDs4FlK
	HXkabDQgu+r0Sr9r+eb9/DJHZkO+VSQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HdOnQ+9U;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.78 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/4RZB7pvKMGNXZ0e7P/ml5wdFAEeCdJqj2hE14qekyY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795165463; v=1; x=1795770263;
 b=HdOnQ+9UYsKLuCXbzJub0XnPdyqdfFG2A1IAy5FsDFWZj8lPVRo9W4ckjPQ1BHcE3pWFOMO9
 hHH5AJfH3vxXR+ZtrXYjdTGDXKLhOsc3WObAzBixY48M5Zg83bs0cP75PELSdffYhdquax9jCZy
 bHfTT799Ng79w/kxjeaOPAAM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a5ee9e0ab9ccd638;
	Fri, 20 Nov 2026 09:04:23 +0000
X-Mizu-Trace-ID: a5ee9e0ab9ccd638
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] mm: hugetlb: allocate larger early CMA pages first
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261120074701.48298-1-qi.zheng@linux.dev>
Date: Fri, 20 Nov 2026 17:04:06 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 fvdl@google.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <447E288B-0ED0-454B-8390-EE39C1CA83C7@linux.dev>
References: <20261120074701.48298-1-qi.zheng@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User:
X-Rspamd-Queue-Id: 116B420004
X-Stat-Signature: d5gqbfmg8on39sezxq6jz53nmahbg3ji
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795165464-121567
X-HE-Meta: U2FsdGVkX1/IjFTLJWAqVwBNzRG//+SWx1uroZDnFcwMre4xhhKsRhqMaBSnjE09dDt2iX3C8jkHTUL8om4I5NkVq8uaKJZ81J1bMfAnRE7XWSSJa7xRiubU0wU7Suj8weRII/TWDEptoAwWB0b90GNmX1nz5BQMHR9iMyizGuPROA5qHrPNM6l7Kdn6+hA7pIQZ+91B5z3Kwq7mUmcviPK+LaYo18fOBUxh3CoykrpJEcNaJpHubaN0Y5L9/zSM7DRENxFXXq0YiRWvW6t6VXgGzSU+f3fIsABPYqQxCx2pVjE89auVG79f79F06VBgYGgO8fTgmatd9NH3x4+tzeDgc196ZwMYKC4TPCOkbTs2b4CdD3+dRm7Tt3aAckBG9XuN4QWOnVNZKxuBbDtnnFNnv3XegoCSZnPdDgDgGC7GaI0qFWeEhdlqLHo+eslOjuyVj15w8HHCpSi7QkX1wwqK7KlaADZunWamhYqvx0Mog+BgmleLv13Gya2jCGr4vUQu3Eh+AQHTOfMIgeaxI6ogBYLCYonMXEUViY/L8tNGe5br2lOr14LJuKhMjPE3FoXusDXXP+y1qWWBrvLadYIbrqaBiA249Wk27mYwKQ9PVSG7cSHWX/RlNuHyW7uP+hRz8vjRwKxNTxE8isziy28Efq1A/9/NlizgGkDJM284n4zThecnYKQOTEIQp1onME7KQy5drFsAlICowaL6E1HZf6VafMXO6SoJm9EWqlKPExMKQLSySuao1+oCnVtW2Q1Cyp72jzBHZy+J9A32gQAKyEsR90HpfCaY0mQW7f0pbGffkvUjDNBqPyZu6Xto6/wrrSCxK+ZXnXuFKWJYcSxDpv07pmpXHWvQJblcMCD6WKe4XG15cIcUN54n3G/fqWWO23ABWJ3jgfRc0FEgtv+3/J8lEQeyB4TnnNMtPqCpvJbm968wEPillDW5SjO8kQfvqFZb4GdNZvR6qua
 59U53+Jq
 8jWy0HjmtS9zR1+hDqJeCD1ahHR1VN4a/lz6tBqmVwJJTugCi0zb4j30hs25yBZrPM6DoECnRXOiNUzYXT4LZ81h4BbD0LO0dJx1Bt11Y40vert/F6d8jRii+u7t6Sw90/Sp+yRYUkgQHXymxGkSNq/dCr4X247OZy7nb0YebbFmRe1LaHC8r+23aaiRzo5oAxBAX56L6lrgjyAg4QjtHpyJAB1TgxS2YJl3xfBUUg57sPj6DowTZ9xCKJsawVb+LpSQnr5zOT5+PnnKLaMx51tWrJk6xvyDeqzqnXnarZbzBuJJaB30dB/iGvu/4KYqrkS0ZsHZvKPhRwt6r6F6Jfx/fmYSZ8LBGwaOMfM8v96O85Yw6L8Pzu87Pa/TeC6CQynho4eJRHQMhdtNMiebWQngso5D0lBeAAexRGpi4HyBQd2i4UsDzsNuqW6F06+7nqbllZESQQtj+KRpdMXaL8Hsm9k0weL2UBdGLDuNbkSsOxEtR93FWrtHlo11E5EuMyyOhWYMqqSQ42Wc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 20, 2026, at 15:47, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>=20
> With hugetlb_cma_only=3D1, early HugeTLB CMA allocations follow hstate
> registration order, which can depend on the order of hugepagesz=3D and
> default_hugepagesz=3D parameters. cma_reserve_early() advances =
early_pfn by
> the requested size without aligning the start of each allocation.
>=20
> On arm64 with 4 KiB base pages, 32 MiB and 1 GiB pages share a CMA =
pool
> aligned to 1 GiB. In a 2 GiB CMA range starting at 4 GiB, allocating a
> 32 MiB page followed by a 1 GiB page places the latter at 4 GiB + 32 =
MiB,
> violating its required 1 GiB physical alignment.
>=20
> Simply rounding early_pfn up before the 1 GiB allocation would leave a
> 992 MiB gap and advance the cursor to 6 GiB. cma_activate_area() marks =
the
> entire prefix below early_pfn as allocated and only frees pageblocks =
after
> it. The gap would remain reserved with its bitmap bits set, and =
releasing
> the two HugeTLB folios would not reclaim it, permanently losing 992 =
MiB
> of usable CMA capacity. An alignment-only fix would therefore also =
need
> to track and reclaim such gaps.
>=20
> The same alignment issue can affect non-LPAR PowerPC64 hash MMU =
systems
> supporting 16 MiB and 16 GiB pages, with 64 KiB base pages and
> CONFIG_ARCH_FORCE_MAX_ORDER=3D7. The 16 MiB size then has order 8 and =
is
> also gigantic, sharing the 16 GiB-aligned CMA pool.
>=20
> Allocate early CMA hstates in descending order. Each range starts =
aligned
> to the largest supported size, so this preserves alignment for =
subsequent
> smaller allocations without creating gaps.
>=20
> Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA =
areas")
> Cc: stable@vger.kernel.org
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks.


