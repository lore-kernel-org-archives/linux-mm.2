Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C618C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B006B0098; Mon, 10 Aug 2026 08:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C1E6B0099; Mon, 10 Aug 2026 08:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732BC6B009B; Mon, 10 Aug 2026 08:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 512D86B0098
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:58:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA8BFA016C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:58:11 +0000 (UTC)
X-FDA: 85085362782.23.A773F90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4A82640008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:58:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JDB+Xqxn;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786366690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jm5ze2mKCra9ETsO08n0wkCgcjZ1SmD1W0aM31gY5N0=;
	b=kTp7dWv0fTucpUcwfSJg7wgEVIwjg710o+BTW9amf31BKUrB2IfVHHi6BvREiA07KFMkwM
	Nm5HJv7F3usuzLC1Si8ionGAGEHXERlBhyRhKXy3d2a9S6vsrmDSON+E+PAF71dU6L8uDo
	9Yhz5zuIF9wIJARaoHJroZdGa+9ds6A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786366690;
	b=u2kybMSSL/6TFS2IbpEBLV9bcEZinBay+70AG1bqnMnV6H5i8ADKyVgo5UGjYFeLNRS6XZ
	2k2iDoX4CwNxntTXWRMx29nuA8PY37A86A8PQUDUpa07JAx3vLmmEFKMbmVQukifb/dkkf
	n0xSApDN4xkrcX400Q41/q/42yh9vzA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JDB+Xqxn;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D519560052;
	Mon, 10 Aug 2026 12:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32671F000E9;
	Mon, 10 Aug 2026 12:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786366689;
	bh=jm5ze2mKCra9ETsO08n0wkCgcjZ1SmD1W0aM31gY5N0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JDB+Xqxn+YpgM5EgiNfcdYAP4X54PmDsvZ6Uo1Lhrq8JPW24vfyPszo2hGnu3XK9J
	 tQJ1eXyNRayWYos0l5DjDOAskJIJB/MOHUaTmspTb15QJf582OsHe4zJOPmPhR0SGT
	 A83zZcBlNYRXRk6sK9eQaXT/xrEjHAU7VEaKMOV6WA+eKHcZi+SF/0PM51SlLvSOaT
	 +4rWg/ZkPwmiXPEeL3jGMPMrtakKc9Q4crVxiO+t/cqfpaovNjLKwcStR6Lq3PNnwf
	 L9VJcd2d7H70FzRYb2u9cRSoIbdQEsHqtUcf4zk7kYVUqTp83YOSgmfnvy7OdHTKn9
	 czmrWIVsH/Ivg==
Date: Mon, 10 Aug 2026 13:57:49 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] mm/page_io: refer to folios in swap_writeout()
 comments
Message-ID: <annKx60dFwG4rFpE@lucifer>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-5-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-5-0899bac3b826@columbia.edu>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: pi145qxx4gib1r1u3essbscykm6uu3pt
X-Rspamd-Queue-Id: 4A82640008
X-HE-Tag: 1786366690-555559
X-HE-Meta: U2FsdGVkX19DCiBaLhDzi/Ox3bPvVx1pnFIHsP2UFW1BxbOc+2B4Zz1L/qEgf1VGBJNs7VSuAY1xoVOTWlyjEtjq1wIkgV8ocFOvtF+33tFYmICo2K34ALyY3qJweTyFTjslUGS8iXsq3yT6vRWZa1sPp87HOqX7aOdeWyN70RQO0BYVPOIhS8Tc9C9EwD3CmPpTF88Jp0QlDCnNuiMd7CMKy7UCX0vZXd7s0xlusyYXWXaMBw6/buYTAeScrL3xLp6Y249l6D7zIzi7YffcPsxdJ1cP/X6VDB58COo6flIdM4+GgMaFtmtIbnAeX8zsy3LGRDiVdq1dAa6pcLpppQDMbSNUY/6tfATeuvloRfL1SYAV4C07Qk2DLhz4gGtjssrDXKIcFdijTF9ge0/RDNswwk3ywxlunLfVQDyzq+WT+zFhjA2ClVW5XWg6gmMJj+e1h3D5VurXDfJgbXmMXjHyZOKRdrMOMtjrFU9bfXVrlLdveCX9+xBEFqtmaLPtKbHkrbmaYIiljKnii+IMMEAfIQ6oiWFIs80WhIVX/kQAwysA6aT2ac9PG1k7dAmmIPgWtSsTglopuBxHJbOYImV1x5PdEnaDyN79SjBQS7d2QorJiQo2PcXvLkz6botYHDwSL21aRUBnZ391rWxin5t6/R65bjfjdW4TpytlxkDD17A+XM14hZSeELuXFvESLAiugd9fijy+/PsHpZvllW1IaRlQXRY4dAAkineKJZ5c+K9UDjd+XIJX08R+sN8q0G56PDaCOxdIeBG6PckeA+D7pbFwthheCqYbb/HIaCqE7Fmd/C8iIpNZVLusM/gIqardKnbFPvkOXF5v1ZwFbmyQ9VurtVUqUsnFkM7cSRoqs6pnWyQiZGvwL0Hk8e/CnyAou8FYh+FNoTd9wvDB/KUjrTTp73jBse6wKwr8x3EA0SLdLtDO2myMPO0/CQ9ttUdZ42aOMIpxhRDjlLg
 ZXXY3WS/
 L1DbSsk93r7FEDlI/PUAOYW24UddBolw2l/N2ICyR6V7hRK///YabJLb3+abYxyjDe2tEnjEmL3kA6iZzJRJPtkcQ/+YgD+fRQLx7WEajlwpoJgFqTQCNpVDvTK/jigqcmlxbRaXTjXCLIpL7X8PMZV1AuRluaeABRVkv5dXJLXtPbeMgd1SJipCQk5PhpY/3U0FAYx8pW84mAVprnxOUtiYuH2hZRG/rSaD+/+zZGSJ/Cflb3rl5r6pUHYTW/YE9gjPW4tqW9zFOT0+g9hjiJI8rouF0cS3wu4QS7xTe8z38TbmXMGEuLpiw1Y0bjtKyQ0Df
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:37PM -0400, Tal Zussman wrote:
> swap_writeout() operates on folios, not pages. Update its comments
> accordingly.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/page_io.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 8573f7b8967a..b18d3b7d853c 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -208,7 +208,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
>  		goto out_unlock;
>
>  	/*
> -	 * Arch code may have to preserve more data than just the page
> +	 * Arch code may have to preserve more data than just the folio
>  	 * contents, e.g. memory tags.
>  	 */
>  	ret = arch_prepare_to_swap(folio);
> @@ -219,7 +219,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
>
>  	/*
>  	 * Use the swap table zero mark to avoid doing IO for zero-filled
> -	 * pages. The zero mark is protected by the cluster lock, which is
> +	 * folios. The zero mark is protected by the cluster lock, which is
>  	 * acquired internally by swap_zeromap_folio_set/clear.
>  	 */
>  	if (is_folio_zero_filled(folio)) {
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

