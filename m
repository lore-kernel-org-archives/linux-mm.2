Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C17EF46133
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC9B36B0088; Mon, 23 Mar 2026 10:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A516B0089; Mon, 23 Mar 2026 10:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98FDB6B008C; Mon, 23 Mar 2026 10:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 854336B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:46:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A6F1160BE8
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:46:55 +0000 (UTC)
X-FDA: 84577604790.11.A6AC3E8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8339A18000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:46:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JD3PTkjz;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774277213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCjjml3v1WGzDQJPuQzQaQ287NKiUSYjn0KZrOdUMWY=;
	b=esgZaHc4bj7xC0uEkXEb7s6Sp39yrSlHNpebH210dUXLyzYY4f/l/ft4epc3oz5tLGNWDp
	3C6a3VrBweZXYrq9ktroTd0aZsGP/xBOLNZtZRotqYhu0rq/4Vxe5FCRaVOmSq5K2lUTMn
	Lua4C8meO42+ibfkLfSrukwZWGSdw0M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774277213; a=rsa-sha256;
	cv=none;
	b=uVAsyeYQtBN4+NoDVq5FUnCPF2wIUs04HSsXE3r6oF9T5eGCnmFZrdnvo+Gytq8I4QsTTR
	T2CYGKUDVEddCBPiWs5A2H9Kbvk0Nhxgftw2fz6qccTDtZGYBDaXkKgQxMKESlDIoWv66L
	ZkyC/Y0mPdXfCD6HWSxH381ZDAyPkuM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JD3PTkjz;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lCjjml3v1WGzDQJPuQzQaQ287NKiUSYjn0KZrOdUMWY=; b=JD3PTkjzwMQzE9JXet3xkeXKgP
	7NNZp/wHKeCuVvw/5q8ytgw1+uJHUNsw0twCVI/TQ7VVRCwHN+B6LLa24NVjem1QnchEj/33cJUBp
	jaP39w7PVsKUPUDEoRYkLX/c93KaDBUJpVGoaUhSWH9G+9UR49WWGHlbTaLndemasfp2eIFmmNOiV
	gTcS4Xk+7gLVkITeZOZ9daPB0es9dJHaGnhqgCWYMuf3CPK6K5rGaldL0uM0aIh3g4wwf9ImAkzU0
	awTFFG38j+MRrce3FgjPnyhaNEK55gj0wEf0Gv/9L3OlArD2TADM5eL+Svy8KjNCZU7pJPCGB7fhG
	ry6ERzfQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4gYA-0000000CL0G-2kfB;
	Mon, 23 Mar 2026 14:46:38 +0000
Date: Mon, 23 Mar 2026 14:46:38 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate: rename PAGE_ migration flags to FOLIO_MF_
Message-ID: <acFSTlF0epHIrA5v@casper.infradead.org>
References: <20260323141935.389232-3-shivankg@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323141935.389232-3-shivankg@amd.com>
X-Rspamd-Queue-Id: 8339A18000B
X-Stat-Signature: 5tqzt4ke5ybfc4pma69atwjshmb6si6x
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774277212-431725
X-HE-Meta: U2FsdGVkX1/9Fysm6AqKKu4aeAoy8uLNrNv8sTrjAxx5mopjbz46ZoNmrJwWsupd5Na+OqK4UyNRwztQ1PH1tDFo6LsLU7wjF8bY5FWBsfFPiUgZIasEBaz+KnxW77FkoKLUuGrbttJMb1+lxV4MgOIkqJb98OmGkWrO/w4jdpt+7caYAD9waOQFiTgX3LjvjW/dcRPcxsJTI0NQkw0FpKA8X2oOyYKOq023GmpH/iYZQ0M3SWsNQ11Hr6g3phJ/xC4ec+WRDGval8IMDfukgpU0kPq3mEVjB3TknhCZuyIThsiaW/iS25HB7rLv/x2mPwGzxHJK1xvtPpRsroYw29xbCOB/Da2xlRnsBTQwtalIBgxGIsIkWJ4QwNAujXhXgVxpWchoWMQLOznqJTut4EiH2pq0f3WxDpQn/f0Afz83fVyLGzUsa+gmy7ficqj+bpMIIxrcc8XPhwEUtiRZz9hnWIcLUn3gREy2k2KGEJRoksqbYWb8MNjAQsgolTkOjNaD7YTSBJ2cgP8fiHGwRUNabVEzN5vaqfVoIEkP93vGyXL/oq2WnSUx9zS3EUkOX7GKO4rwuwrnyW6YcnAJYbmNDKZKiB2OSFEAbAVBbp+m8FNQdfi8TJWPua/poP5+tVAAH6Fm15j42yj6cQ9ieKEIQ9W4dnPVUYAo9mF8GLrdM9xv5/m6cEcEjzDBD9DyrG0ptl9E83dTjVqfPXAB7YdRLhfAOw4dCJlTK1LBh79NYJkQQlVNjxJ3eNY+mVnb7TmA9BoBwP6l8WFafx+P+GBlBO1y7kUtYSGA6BVQ6MNikytt6pipPWJ5jz2DIhyjg7Qr/gEdfD9XIXaDdcSCuL33evCHjjzWNgW/TtdY+Ihe5sAmHowSEI/3zV+1jFUTZ2+p7YUiXTKlXj/cDgQQX5lvaFdFsUN+Q8i8BuqHoKB0ElPoj/69UiIEZaUBhBVbJH2dfo5nm3EEEd8kbMr
 Lvgu7mPH
 S4AP01vV/y8HobaP3X/Al38+zzP0NBf5GwCQTwPBqpYZUNVn5mabVm+sgnxATKjtQL8YqUMEzIDd3CSIZrmCgz976Wx5vDEvLnCGzzRHkJu/cSLyRDGgAONqHrYmeFvu2kPuAt6Hk+fGg9bDndYvwq9g4Ydd/2RfF6zK+Gc7eAWaK9uKdM8yFM31qYbwr8+i4ugH4A5uyK2Lv4UIOJbSBOOpJWeFfSRYLRDxS/8irkgvcr0zDS2AhvfX/ut9tl4eNRblyNY48HsJ7Wg1YksmNHXfRilc4ZZ/pr8NIZ4hTw/dvuVYwk6qJ1kn99IZ0FAS4wIGuXUzyoup4CMCRp34w5sCaVWysHHToVx46eE5yLZMrR5Vtt+sXF548/D3UCq3+LluqWa/cnzECSh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 02:19:37PM +0000, Shivank Garg wrote:
> +++ b/mm/migrate.c
> @@ -1135,26 +1135,26 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>   * This is safe because nobody is using it except us.
>   */
>  enum {
> -	PAGE_WAS_MAPPED = BIT(0),
> -	PAGE_WAS_MLOCKED = BIT(1),
> -	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
> +	FOLIO_MF_WAS_MAPPED = BIT(0),
> +	FOLIO_MF_WAS_MLOCKED = BIT(1),
> +	FOLIO_MF_OLD_STATES = FOLIO_MF_WAS_MAPPED | FOLIO_MF_WAS_MLOCKED,

what does 'MF' stand for?  i mean, presumably not the pop culture
meaning of MF ...

>  	locked = true;
>  	if (folio_test_mlocked(src))
> -		old_page_state |= PAGE_WAS_MLOCKED;
> +		old_folio_state |= FOLIO_MF_WAS_MLOCKED;

I mean, this doesn't make sense any more.  PAGE_WAS_MLOCKED is a
sentence that means something.  FOLIO_MF_WAS_MLOCKED doesn't ... unless
you imagine Samuel L Jackson saying it ...


