Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05D65CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 07:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284D56B008C; Thu, 11 Jun 2026 03:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235A96B0092; Thu, 11 Jun 2026 03:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14BB16B0093; Thu, 11 Jun 2026 03:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06E286B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:52:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83FFB120501
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:52:25 +0000 (UTC)
X-FDA: 84866864250.20.FEDFBD4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id DA1A440002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:52:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pw7BVdtV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781164343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gy0fOwvIMH4EuNtEbs497c1jGFk+9kN0Zl6QDcA1oSs=;
	b=IBGpVP0A9+soOATYeJWP2o1BsWhnjqsDM8cw06J76cQl29TRwQ+shciVIH8Ndv54sgzvL8
	Em87G5NA9QdeRRjr8H1/4Qu14ZIDAYFk8agPvxGyrf4cZYQVYlPpq9/F/1tX9BFY8G5c/U
	cEQT0o9OF7x/FLUMi9EUuuwRWN8mqu4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pw7BVdtV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781164343;
	b=V5gqdbul5mnKVMFM361OaT3eaJ5xE4KjL74yIHwVOBVxJl2Plxv3n/Mh3sFJu9BN/bUTZZ
	YCBRRCwQ9BJtkDH+6K7vGh4kz949EdK9Em5VQof9jpVRBCN4X+Ocu0OSRkeLuA1DNAofjL
	ukp+TQ19EFqRz6SdXkGZyoqct/x7LJw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 451CA60052;
	Thu, 11 Jun 2026 07:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0901F00893;
	Thu, 11 Jun 2026 07:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781164343;
	bh=Gy0fOwvIMH4EuNtEbs497c1jGFk+9kN0Zl6QDcA1oSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pw7BVdtV9nJb2vVo/Ix5ymbdE6e+nicMi2ufCJNiA6K1Lue934jVv9/5L8lXkcO0m
	 2UBvFQES+wq6L24tK2B59XMB8NPE9Fpx92KlDOqnfP6eUzBgFMOjwhNJCfYg+ejkMY
	 LGBCMRYQhGSjGjFGfGtR2O5QCR5vFGisu7Vr71TDIG/m8Bnokjel7ReskvLrSndeOw
	 B3MFG3DYMPrp+AoIyEt1yCYUIOlR/A2AH20Z8s/Y52h+lqPnZVzDuce3w4Tb/QbS7j
	 29GwXAaBqo/L542gTyeNxfXiqdQKZTpr6+GGPCbYrxbdC6w+buZi3wsWl8sYUg6U1W
	 NDPm3lVE1z5IQ==
Date: Thu, 11 Jun 2026 09:52:14 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Liu Shixin <liushixin2@huawei.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, muchun.song@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v2] mm: page_isolation: avoid unsafe folio reads while
 scanning compound pages
Message-ID: <aippLofoK3VJIQzO@localhost.localdomain>
References: <20260602130755.38794-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602130755.38794-1-kaitao.cheng@linux.dev>
X-Rspamd-Queue-Id: DA1A440002
X-Rspam-User: 
X-Stat-Signature: 8ruim314mmfif5qxcui61ycyz379gtyo
X-Rspamd-Server: rspam09
X-HE-Tag: 1781164343-480657
X-HE-Meta: U2FsdGVkX1+D2YxlxiGPuhRSuFVkatoGQRtCBDOTwGHnPOP16S6kNBnL+iPXD77LGbB8TJfrTNIjhz+AqNOWgbxYDbBYFka1bVIOlM6XN0I3arGQpemY+XtlVF5a/6XyjGv0qnfwLgnqfYyNy2G24SIw4k6HqZiRrWWUxr3MRlMm1N5ZOv568MJvRVcEx9OzNMHmGW0eyzfB8gr0QpJTkrnab1zhmg7kPUEvx2QsRdUnQ2058xifWmI/52/ynN4frRqgQ9MWyQdGL5RbvfblyUZvPrAB/+v73TcZe7tTvQWjNkceF+plMjSA99mLBGxrH4DdhdPd8HooTiONKg/NGbvH2W9ADi8GyUKtSQTOTqFrWh9zypVPlBduxUaqrrrfIkpTuJ9dgQQNxsMCttE9As2huex9+ZlqNuiFh27L6EKhrhZNw6rY8AfFpCAfiSyOvA3vOkfiVYY3Y9qc4KPNlufGDZ6+I2Y1VGKhmISjXTVa6ssAMAM9sld9KAeeUVseCebeuc3f5kv8HuyugV3SjrOs3sJoV1UL7yNgRrzrdCaL0ab69l9mdYv40lK81Tpiiv0SZMCn/sVvl094cPCrRvIHRXY50jKl6GMZyiItmXbV3I9at0XUzIN+ES76L6BzeWebT/mpn8GjQ+HHmqLTdU1R+LMFpS6T49ZqF2BEC7HAPl9v//x18iW1NOQ/oyWUAeJpj9R9GlBTmpvwqTfLnuzOHMewBKCVSB3pqicCDpzVKyx8URuBSK+gMFiNIjpnagGaaaR7vgbedWzE05UGPs2BuHFyZfMFNoXkFdokVDL+wKZVptaiI7u8AJNp4f/P3GDITzhSrxvb2lse+aLcprRC9OS6sF7FPjbMv0bsL6ytrs6ZXilSZ2QNjsr3ucKnpMZENnW6YG5ljdoI/NBBp6BvXjxBRcjk8RhSSsPqNKshJG6GYFtETcuNeFJsoaxWsnKVgLZA9Z6kH89gu7H
 dmlPT2Bq
 lEjPvgGhlYTgvZBzsixpae2woRWTxk/aJtmpuPeiO+0j/8NzHFO1DuIPymRwBN60WMyStT8WyHf8yoQ6mZrhA0j5ZN5nnFNnByDxAPlHPo76l1LkACCa5de0XQZmyWJ41mrdzXqvRNFEr5ceFk5jjQ4vO4MJtxX8whHNa66OGqhd81rrFUdM8cWyv1GI9+MiL63RW6EGH1tEOF2YTYeSNojeBajFzmifPPRJGzRMBtiofvUEILNIyqanEcopR3jxQGu+vCiy9FjUA8AM4GGNqmYflMNf23jNaE0/E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 09:07:55PM +0800, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> page_is_unmovable() can inspect compound pages without holding a folio
> reference or any lock. The folio can therefore be freed, split or reused
> while the scanner is still looking at it.
> 
> The existing HugeTLB handling already avoids folio_hstate() for this
> reason, but it still derives the hstate from folio_size() and later
> derives the scan step from folio_nr_pages() and folio_page_idx().
> These helpers rely on the folio still being a valid folio head. If
> the folio changed concurrently, the scanner can read inconsistent folio
> metadata and compute a wrong step. In the worst case, folio_nr_pages()
> can return 1 for what used to be a tail page and the subtraction from
> folio_page_idx() can underflow.
> 
> There is a similar issue for non-Hugetlb compound pages: folio_test_lru()
> expects a valid folio. If the previously observed head page has been
> reused as a tail page of another compound page, the folio flag checks
> can trigger VM_BUG_ON_PGFLAGS().
> 
> Read the compound order once with compound_order(), reject obviously
> bogus orders, and derive the hstate and scan step from that order
> instead of querying folio size information again. Also use PageLRU(page),
> which is safe for the page being scanned, instead of folio_test_lru()
> on a potentially stale folio pointer.
> 
> Treat an unknown HugeTLB hstate as unmovable so the scanner does not try
> to skip over an unstable HugeTLB folio.
> 
> Fixes: a0a9f2180b90 ("mm: page_isolation: avoid calling folio_hstate() without hugetlb_lock")
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> ---
> Changes in v2:
> - Avoid unsafe folio metadata reads in the unlocked scanner by deriving
>   the hstate and scan step from compound_order(). (David Hildenbrand,
>   Andrew Morton)
> - Treat invalid compound orders or unknown HugeTLB hstates as unmovable.
> - Use PageLRU(page) instead of folio_test_lru(folio) to avoid folio flag
>   checks on a stale folio pointer. ()
> - Update the commit log (David Hildenbrand)
> 
> Link to v1:
> https://lore.kernel.org/all/20260519121646.40833-1-kaitao.cheng@linux.dev/

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

