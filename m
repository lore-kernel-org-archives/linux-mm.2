Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83FA3C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558FF6B008A; Thu, 27 Aug 2026 08:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509B16B0092; Thu, 27 Aug 2026 08:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8836B0095; Thu, 27 Aug 2026 08:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8846B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:02:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BDDC120427
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:02:34 +0000 (UTC)
X-FDA: 85146912228.17.0E8547B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8D299C000B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:02:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bb3BqZBk;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787832152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XsxeEPR3/Rk7rjBdJvlKvo98WGdtvIZTN2N8+2tZQM=;
	b=LykJFcNL3JwppxLNkj9Assh6LseMtcGOc9z4DKBqYw1Oy1CsRVV4yPDl/D3+FC0+Vt9jF8
	ooIjouJbnrCRQfZ7KLUsUCO+jZhiEu4nojj10hK0aTqGSJFZRFeH2igWJ93LBvT6VVmufQ
	iE1CK69Hm5ZCYSgmMwMKAws/6W5pzNc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787832152;
	b=0ZgDOEJF9bsKT/hWYCO+5v0yQQw8EnCP9fLfFzrG7/FT+yeGf0cDWVIWQQIL7BD6C9GkZ+
	K4sj0m05bbdOpma/Vft8AAR3Moo7gk8DyoWMKwPR5vW+jmt3GYPh2qeVNCknYsZEu1254y
	q0wZWOgwf+DozBl72iwZqu6OXObAbzw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bb3BqZBk;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CA0D435E5;
	Thu, 27 Aug 2026 12:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F33F1F00A3A;
	Thu, 27 Aug 2026 12:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787832150;
	bh=2XsxeEPR3/Rk7rjBdJvlKvo98WGdtvIZTN2N8+2tZQM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bb3BqZBkCy12z/XYEtwhaP4jdrDxearjy1VX5lOWm3vJo60wfk987M2UrfvVy920O
	 iw3Olx8b6JTkkj8q8ioUhGJWt5ep9HybbQExO3t7OgMDtF0sn5YLA4HE++v+JGatPj
	 aCIrx6SRt+vZDaxlKypBpBTTTFnjLmZOVH9bKNl7Ya8QhChxdoPxFCoswIxxAk1jMC
	 oVr6q6lg3qjxecFQOg58k2XwDKPV4d85t3eq/b41tiGIMsPYwSajuDpSgooKQsDpUo
	 gbzWJSSYGaSOTe458yLIzoEl8Xqh12uH3tZSLcXAS1fb4ih4D46Y2ab4o9wQ0IDVK0
	 cgUmJJrgg2L1Q==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 04F11198006A;
	Thu, 27 Aug 2026 08:02:19 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 27 Aug 2026 08:02:27 -0400
X-ME-Sender: <xms:SyeQaoKo4tb8bnlH35Szx0wbWy1NZzrTNp7vZHlBAy7-Fq4uFp-eiA>
    <xme:SyeQarFtcvavQQbVlnXTqwtmjArg-w4o6Ar6lS5E8jAZUR7yVzO1kMBJNzgQYLg2F
    dVhC-lD7rF7m35p74_UP39j9dC5zeKcCs-ESRSXIPDxDgRCgZMm4KQ>
X-ME-Received: <xmr:SyeQasEhQH8TtHVEGB_dbkCL2SlmpH8VDjVoQNmre6hRRmzmxEEpLkqdwsU>
X-ME-Proxy-Cause: dmFkZTEirA8p/Fg2Vt0IQ3sbf8tygsd6g4HGOD50ZYQXuEOzvK3DDnN+iPIFENoOnOzS8y
    jl4cteOEz9eDzItp1psFvzkCM8nSgtIDdtXPBJUOsZUni9pif7kyC1W52Cbg5Y5o4uXe65
    VqjwEt9ummVrtTdk+rpysdpOiyf5vZ9yetWZQoeBBoc+hPU4GIoq6romIJ6qEM6rH+0v7t
    OBnCBYkMaKf1tYtVOe0M2Ct7auJ71LhpDbgT1P/lz9P3MFwvlMkwlj2+xrVs8UmZMr74kE
    RP/8923JcU3qWpmArRahVMHSYtCWOWanNLthEMna1K6MswnvpxEy649NmN9nHdrRrGzBbW
    W/k1jezLaTAJc73o/EXawFGSUYoJR4c+TXIzR7h20OG7HDRGWp0bK9L+wkAlAJYhtry1YW
    sJ6WIBHNqylTjDtXfscT6bsb+fxgd+t/Ew3ALSICZinX2t+XlOJp4HolZ4C7IdMTv4hHWH
    +t8SZPqTgfyzBoelXA+4SfIjRWtn9U2ZpWT4mGQvrNivXc7daUyWHp3sDOkyxYDXoQcmbq
    yV4DrKa+59naxi6Pj7cBVsnTFEGxK7FsGKZcsuXdDqAdLJIuVE6szwyIGDdiPnskEaEVih
    QWuXHPSyTDwaLSAQhXmFzfXcK8Uhx2Pk992kJhYYzXVdDq7ovWBWIfhGRHxg
X-ME-Proxy: <xmx:SyeQas6x_CJAKC10gEebMtWvee83j2n4rr6KZqH9u-QrgV25nhpENA>
    <xmx:SyeQaobfSR2oXdZfYfuMbYFgWhmZIlwMBfH9GtmIZCEj6lSEoQBxbQ>
    <xmx:SyeQaoswysIcl7AWGL07Q0fQFEhknHXPx5s0slrJlXtovuG8C79AOg>
    <xmx:SyeQai2eUUcBLktxZoPLt_q8cP0i2UUXT3PadRIqdG8xhqrvOK51Fw>
    <xmx:SyeQaioTmw4oBvOWObMpNP3HJglgHG0vOGhDDJbax1PZhaE0uqr0wCVD>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Aug 2026 08:02:17 -0400 (EDT)
Date: Thu, 27 Aug 2026 13:02:16 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 	Ackerley Tng <ackerleytng@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 	Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, 	Binbin Wu <binbin.wu@linux.intel.com>,
 Christian Brauner <brauner@kernel.org>, 	Christoph Hellwig <hch@lst.de>,
 Christoph Lameter <cl@gentwo.org>,
 	Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@kernel.org>, 	JP Kobryn <jp.kobryn@linux.dev>,
 Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
 	Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>,
 	Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>,
 	Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
 	Matthew Wilcox <willy@infradead.org>,
 Mel Gorman <mgorman@techsingularity.net>,
 	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
 Minchan Kim <minchan@kernel.org>, 	Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 	Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Rik van Riel <riel@surriel.com>,
 	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 	Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 	Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>,
 Zach O'Keefe <zokeefe@google.com>, 	Zi Yan <ziy@nvidia.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/25] mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize
 folio_activate()
Message-ID: <apAllneItXmyjRPo@thinkstation>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
 <16b39f43-d91e-7b23-900e-90cec13837ff@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16b39f43-d91e-7b23-900e-90cec13837ff@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8D299C000B
X-Stat-Signature: cdsbwnbiahpmf6kfpkgmr81pfnimx1ng
X-HE-Tag: 1787832152-352442
X-HE-Meta: U2FsdGVkX1+TvaZeErlc0Rp/ZcRy/EJK1iOlbPQ4MZxOHXKbcQhdYVVvZDXu3Tije7HlATAeRDT9UUCU76igJm5fi0YYFoCNjkHF8J5yQCTWS3+dF8mqYnrXdxCPxZ/pX/N8oEyB5hjD4NIUGQjcC6FpekjK6pKFPU71KljHBppSWk9CT5X1KNnRC+tRY53qu3flYpfdFiodAbGk8kO/JqQIT3QUXZ0/mclQ2HulJw2zyjWFevpUhmaNDWQ8NhR7rolp/aeLJL+lqsrwSfNpxmcLJbvIPHj/zMNCcxkxHnS7syeln1nf79KbCLv+HHGqRx+1Yn06vjMgvWdDhrTcMpJ5L8bx7+5BUl85ywYQ4gkQnDJg3zC2wIPtV0aqyiq2IULosXQMFkdfelorateH9fVG7FKqEVXCjiYE/kwj6c43i3jKCbTHTan93wbcBFds0ka0ACqdc37Vv+XTJXkR92NIGuuaQYlCiqF5IIYC3CdHbd8tm1uxrhqU2LhAYiKDgmLktrCaQKW9HYlBmWvXOLaKZjuDYn6w5L/WeShl8n+msUVlOccOPBvdEyr4te5lMJCvIVhHw55OSYHPSsbR+/5ZcgaCthO260xwfQ0KuO/v9D+EO4vHxYYmxlN3cBN6QvHrXNA0WYPwFTfHrdS6ulRBc3yx9Ghcap6YO/9s/C5fBoxzPOnoXE1X04RbyWHibTmgqWgEr7rTh8hjrIz8nXygzEbfHAiuudM8Mix8muitc6XGEqAnjef8is0GEaZWIbnZkDlqqJepDMu5ViBTJ9+O6hIpSjofz4iqCHp3rFtAIMco0EOgxOag3gOwMPicbOLcb1QAJRyVwlvroWrbZoD2j+5IsxtyEr0ZYcGjXaxEuSk1sZOJdY2YsIXiWpM4btR3p3uUAosHUNzgQuoRzGrP++S98auyZIJrVs87DevCw9FpsBDw7t+BNGUzxknGp+FnYdVuIO7Tn0CZHsC
 op4FZrLY
 dhP+gTCsTIywj05TvjYUnbc8rIkSaNdOsN/3F52oqUGRFsSMCxZY4TSKnQNITjqvTgjHtxbOKQQ/P/s/omgUDpujj9QQNKTFxkvfyZNqM4UoiSqt+J55ypzmZc1cuOVbMp6szfxkbrJ4OE2p0AO2Pn+644VbeOTjUoFPW/iYCqLZm0WWKLWrRZyy4c1eOZfzjZ/2YJG1MJPoPCEsKAGgPE7wyy2gNdrr2mD9o72tsq5fhnK8MozZTE5ujFFjVEcPtH/Vshaz810L7O24MU/aGniozO8oiTfhcVP8qCoErx4xIDmI30zPX+TP2wqgVFK1nQrRxirnJyU/B8M4oZ0eRZWyammoMUjAwphtxZ/Edeh3szvJKmoaXcLhkoFM9BI9wQo2P6BntnQGUr6W/oNQhuyOR2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 07:09:34AM -0700, Hugh Dickins wrote:
> @@ -355,6 +356,8 @@ bool lru_add_del_folio(struct folio *folio)
>  	/* BUG_ON(folio_test_lru(folio)); */
>  	if (!(folio->lru_next & BIT(LRU_NEXT_BATCHED)))
>  		return false;
> +	if (folio->lru_next & BIT(LRU_NEXT_ACTIVATE))
> +		folio_set_active(folio);
>  	folio->lru.next = LIST_POISON1;
>  	/* BUG_ON(folio->lru_next & BIT(LRU_NEXT_BATCHED)); */
>  	return true;

folio_activate()'s try_cmpxchg() can land in between two lru_next reads.
Logically, it is safe but I suspect KCSAN would not be happy about it.

Maybe READ_ONCE() here?

Other note, page_pool (pp_magic) seems to be using bit 2, but I don't
think there's a real conflict.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

