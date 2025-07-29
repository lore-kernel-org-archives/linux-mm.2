Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78645C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 00:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E55766B0088; Mon, 28 Jul 2025 20:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06176B0089; Mon, 28 Jul 2025 20:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1BE16B008A; Mon, 28 Jul 2025 20:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C23B66B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:51:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36AF1140316
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 00:51:16 +0000 (UTC)
X-FDA: 83715473352.05.3C82913
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8FFD54000C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 00:51:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753750274; a=rsa-sha256;
	cv=none;
	b=GU6uUTcX9AQRI6S1Dlc2mEHTmgWpCq+uG5K5C32QPoD+y2/qYI8x7KPPNbQbkyeEpn3I7h
	ysWznx9wbuhNwiJWP3uM4LYrafv+U8J2if8uwTEilB4C3w3tSXI5Sz/OyaUxCQZTkx2WGq
	8e8jRXDr5Kdp1M+34aUGZiJ3cuO7JG0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753750274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UThrB75mgxXXHCGZSSrf3y5a8N801gx/AW406MakHe8=;
	b=OG76fVnRUgUiCiJvwifVk+tTbYJeNOzeYFn7Ee9XHM9GSS0ZH8AxsUmUpJy9yNjj9eBrbu
	Sdn840Tn3axqEbCnZ+Wd5j/BFsP73Rcg0QrSqzUcsRv36N/lYg69se+Xzz5eiFnDhwCp8+
	9UxnaJ4rG+85qLJxo8D+r10hNhi1fxM=
X-AuditID: a67dfc5b-681ff7000002311f-77-68881afed51a
Date: Tue, 29 Jul 2025 09:51:05 +0900
From: Byungchul Park <byungchul@sk.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2] mm, page_pool: introduce a new page type for page
 pool in page type
Message-ID: <20250729005105.GA56089@system.software.com>
References: <20250728052742.81294-1-byungchul@sk.com>
 <fc1ed731-33f8-4754-949f-2c7e3ed76c7b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc1ed731-33f8-4754-949f-2c7e3ed76c7b@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWUwTYRDH/Xa3u0ulyVo8PuHFFAwRFbwzxiO+mOwL8XzwiNEiG9twppxF
	JChVjnAUBZVSIkigHCaYghQQUMuphkAgYAGFgmKCVpBTLkULMfr2y39mfjMPw5LSCpEzqwwM
	FVSBcn8ZLabE3xwf71x2TlDs6tWuBX3ZExpK5yLBYK0Sgb6kEsH0fD8Dy3XNCKYaW2j42jCJ
	ID9vlgR9u4aCmbIFEkaahxkoNXrDYOFnCmrjTSQMp7XSkKJZJKFufoyBW1VFBOjLYxnoqEwV
	QcZCAQmmWCsDXTV6GgaeLIvgszmFgte6Ygq+ZzaSMJh6DJpzN8LsWxuCxjITAbPJOTR0Z9UQ
	cK8zl4aPmkEEnQ3DFGQuJdCQfTMVweLcH9uYdloE2U0DzDEPvsE2TvIVxb0Eb6l/Q/DVug8M
	n2sM48uLPPgkSyfJG0sSad44eZfh3/fU0nzrw0WKrx46yFdXTRF8StwYzU+M9FH8eH03fdLp
	gviwr+CvDBdUXkeviBVv6q1UcJZj5PKXIRSLMh2SEMtibh9uWwhNQg4rWKDJIO1McVtx04iG
	sjPNuWOLZX4lX89tx1/fmZkkJGZJ7j6D48tqabvHibuEn744ZO+RcIC7DDkiO0s5BS5q16LV
	fB1+nfVpxUlyHtjya5Swj5KcCzb8Yu2xA3cEtz3PW1m1gXPFLytbiNXTrCzu6d+6ypvxqyIL
	pUWc7j+r7j+r7p81F5ElSKoMDA+QK/33eSrUgcpIz6tBAUb055cKbyxdrEKTHWfMiGORzFGi
	SIxXSEXy8BB1gBlhlpStlwQX3FFIJb5ydZSgCrqsCvMXQszIhaVkmyR7ZiN8pdw1eajgJwjB
	gupvlWAdnGORwXb+PBOdPuR+xHDdR277xiYfX0yPOps+E6euCbNVux2nYiYePe4a/HS7zmQ2
	O/5Mizn1KPFOzOFGv5nuBzbvUXXEWJe7Ibsvf82w64G5oCZl51LbgLLDkLAl8cQz63jE6YfR
	ph/pUfvhwKvygaVt1lP1XtsrNMEF59xiOrQ79vrIqBCFfLcHqQqR/wbFFJJgRwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTcRTH+d3ffbk2uM2VFw2i9UIlSyo6YkVI0CUogogoqLzVrQ0fyZai
	UWA52rQ0S41cM+zhe2Vs5aNMazPLQgztsR7OR6k9RMvMZprmjMj/PnzP+XzPP4fFyguUP6uN
	PSzpYsVoNS0jZZvDU5aM+5s0yz4aV4Gl3EpDmScRijqqKLCUViAYGnnLwMS9BgTf6x/R8MU5
	iODq5WEMlmYDCT/Kf2HobuhioMy2CdoLe0ioMVZi6DrzmIZ0wyiGeyP9DJyoKibAYk9mwJnX
	SMGzigwKsn8VYKhM7mCg9Y6FBrd1goIeRzoJjeYSEr7m1GNoz1gHDfmzYfhpH4L68koChk/n
	0fAi9w4BWS35NLw3tCNocXaRkDNmouHi8QwEo57Jtv7MIQouPnQz64IFZ98AFm6VvCYEV+0T
	Qqg2tzFCvi1esBcHCWmuFizYSlNpwTZ4jhHevayhhccXRkmhujNMqK76TgjpKf208K37DSkM
	1L6gt6h2ylbvl6K1CZJu6dpImeZJbQcZlytPnPjciZJRjk8a8mF5bgVfYMjGXia5hfzDbgPp
	ZZpbzLtcI1O5igvmv7xyMGlIxmLuPMMby2voNMSyvtwu/mZduHdHwQHfWpRHeVnJafji5kz0
	N5/JN+Z+mOrEXBDvGv9EeFXMBfBF46w39uHW8E13L0+dmsXN5+9XPCIykcI8zTZPs83/7XyE
	S5FKG5sQI2qjV4boozRJsdrEkH2HYmxo8l8Kj42drUJDrRsciGORWq7QpBo1SkpM0CfFOBDP
	YrVKEVdwUqNU7BeTjki6Q3t08dGS3oECWFLtp9i4XYpUcgfFw1KUJMVJun9TgvXxT0Ylvnut
	t0X/+02B38qiPNkmye/pcP/gghM9iwIfrDbtyQpydi/HfqGiSTarrbbOE3n0dpTBbf+91fDR
	fqPvEhUxZ82O8KYZoePb3EsLeuW01t77MzXu5d2w3dmjVve1611LfL8GH5hnnDP0XN7hlEc0
	h1kDT3nUc7PK1qtagxdciVeTeo0YGoR1evEPOG9m1isDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8FFD54000C
X-Stat-Signature: fkyeqyd7ofiipgaa8e3mfo6rrwe9oct9
X-Rspam-User: 
X-HE-Tag: 1753750273-569101
X-HE-Meta: U2FsdGVkX18+jy2YKt2D4c1XYGQOvzMT3rXKMhlZZ282lTVTkMCFIsGSvhnpcqRM0mFHzLRvz3PNGJXTLSVoopSEQ3PWVn6yGGwX2E8B/h5p9TJdEo9N2FsscrW4Q+R2I8OSfXPizb3GKb7rPTHG5Gu2HNtRndhFGIFf06Wi2O2nN25nNCOtl4u29eq0iHaJkm2bA4Sad7nWrkSGqyA52Zl/aVoQd4qGrOYjeqJbxCNv5RQiAKnuGhy02ckbSW/YRnIojpifDbYGsVJoFACgDIzDgALiXvUq1xRSRVRkaJ0Zv/2ksithvSfL7swUey6TVFlRBGKEwKhTqhAVHNGW4rdDQwV4EwV696GQC3h8Suid8m+gQXGXyyv8PTxK41NZDEpJPKlZ70suVxQgkvce83wRlroKwrQYA0cmOM7S2vr1DnLiv6Y6rUe1GBhnuV+r3mWsRPXjgj96XZeGiSg+Y5dndH/S+p0fsJacw9l3WtHb+ddrtK2eby6QXKQbFEPFFATCuNpISbB+Tm9Ei0p/BR0vSRIP4rnAgrzpAZ+5SnKkZObflxkwTLTd5Nr+dZ/skagf8Lvvz8AQI+BWZSMPkpj0dfZ7FXB9cWrQv0RF5m8SoVQtKeS39deJQuVmaY7SWfNZHYo3VIIUCH8Q2NuN4uOKQXyod6hhIX7nPaXzH0J+IgUWZ6ZGVWse+sRFE1M8NkgY+0ZzpNGxw9l2tk4ROvexnwt/RAvZSvtdwSBHFJE4Bw20hyn3XTM341g3spI6PtubsP76FlqL0JfW6mFcNRV/3l8wPja7q7BLvD0UdErIFIpNKTBfUJVnquu6NS84kIqFj/K+i8kEBuqoNRoEQ1exAB9sFAkuJlq2wLYHWyk1Lb3ZajmE0DZlpKaO/zxr5uLHnNAnjStrFAx872H9EFqK9JbrTCXwAFaIqz5cYOMeSTNOc3fpftBRTJFijkDSdOuMoOy1LiTNrEw4HX4
 LRvOLeFY
 ltSzu28OdV3nCnl8lyohZ9O+tEsoEu/FVWGH89v0bHtu6etaUyUSGyKcwi43I2VTBinXvCdmtJgoiUD3nzMx/o6DXm/fAYbKV9CkW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 07:36:54PM +0100, Pavel Begunkov wrote:
> On 7/28/25 06:27, Byungchul Park wrote:
> > Changes from v1:
> >       1. Rebase on linux-next.
> 
> net-next is closed, looks like until August 11.
> 
> >       2. Initialize net_iov->pp = NULL when allocating net_iov in
> >          net_devmem_bind_dmabuf() and io_zcrx_create_area().
> >       3. Use ->pp for net_iov to identify if it's pp rather than
> >          always consider net_iov as pp.
> >       4. Add Suggested-by: David Hildenbrand <david@redhat.com>.
> 
> Oops, looks you killed my suggested-by tag now. Since it's still
> pretty much my diff spliced with David's suggestions, maybe
> Co-developed-by sounds more appropriate. Even more so goes for
> the second patch getting rid of __netmem_clear_lsb().

Sure.  I will.

	Byungchul

> Looks fine, just one comment below.
> 
> ...> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> > index 100b75ab1e64..34634552cf74 100644
> > --- a/io_uring/zcrx.c
> > +++ b/io_uring/zcrx.c
> > @@ -444,6 +444,7 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
> >               area->freelist[i] = i;
> >               atomic_set(&area->user_refs[i], 0);
> >               niov->type = NET_IOV_IOURING;
> > +             niov->pp = NULL;
> 
> It's zero initialised, you don't need it.
> 
> And a friendly reminder, please never send patches modifying a
> subsystem without CC'ing it, especially kept in another tree.
> Sure, you CC'ed me, but it's easy to lose.
> 
> --
> Pavel Begunkov
> 

