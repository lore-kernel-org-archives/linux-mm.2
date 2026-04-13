Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8DF6F531CA
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04C3E6B00B7; Mon, 13 Apr 2026 16:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3F806B00B9; Mon, 13 Apr 2026 16:47:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E55BB6B00BC; Mon, 13 Apr 2026 16:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D36946B00B7
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:47:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67CAC140110
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:47:19 +0000 (UTC)
X-FDA: 84654717798.10.67AA86E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id C385A40008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:47:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=io9etQAO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776113237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/FCpeJbPHpze89HqlHi5GGx2Gbv6ZaMe5dTP7Neskw=;
	b=BGFER7BA2QBwytwsJKAY4A5eAoeNS+KCa7GL33D2EhUpgoKDH+KzEgJqLxuKLiU1sKgZ1w
	5SE1LA9r8TLYzBRpNPi2u2SVfGiGKXNiFmz2fNKPFlAmRgGOLSUXVEwEm2LFSJ9K8i36KC
	5UgvTDzx+jGc6mZyD4gB8QZxWqimqho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776113237; a=rsa-sha256;
	cv=none;
	b=xiDHxUkzkwWzrnW0ongl9EUvQde7kS/AI88l9zd24uvoVGUFZRv6sthfo8xg22SVI7Gewa
	AM/AbkHXwMF18CLtvOaRwt5vRTmKEKuWgED+SGTAqnvesP7SvHTCUgIK1663zpIzdWrmgl
	BmS508iOXIJQAk4Uukou/ycfEVDc0X0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=io9etQAO;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f/FCpeJbPHpze89HqlHi5GGx2Gbv6ZaMe5dTP7Neskw=; b=io9etQAOSXXNPIpcMmQYDPy5lo
	jct8aeQuAKRQ+BSF+8HGBx9hSwdoNq97aKTc4Ljl5O/l/sI1UOozNx+TNO0sxrsGwMzyULsoSoYxU
	XLm95gjTIq19FjQU0zcNHLLnHT1zC3368JWp/oaoQnDL4QwOcBxe++WDyKKtfanNZYEvTg9vGzYHw
	pRHFmh8i1NhzxB9qtWFRQU91gjqiZLXiRpXOHQ9FUsPAALOK1k8jZvGcdsG//LHPAbKoKIiwJqImr
	h8h0TuHIKE2hLMHvhfTHAMCgB4uslx/iSHEt+w5ro0dh5oTi0gIlhFGSVoXgPDaicNfQPNTUovTyn
	JKT96BUQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCOBY-0000000EVEs-2c1W;
	Mon, 13 Apr 2026 20:47:08 +0000
Date: Mon, 13 Apr 2026 21:47:08 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS
 from comments in guard-regions
Message-ID: <ad1WTCR5Kld-tiL8@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-13-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192030.3275825-13-ziy@nvidia.com>
X-Rspamd-Queue-Id: C385A40008
X-Stat-Signature: dky1d87r5337djiz9996fakeognt54zx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776113237-532768
X-HE-Meta: U2FsdGVkX1+y3eakRZtAwRKJNH3nib7852S4aqbHW3mg+SRuHu+stnrnk1HtEVgflZ2cxCnIByisYLwKQoKspUcH5aX81tkuEFqtyuUQgnWbJnaw614zlexGgx91Cdku8MjBSQgnCBplS9xSDdzlmFj5houYeh7X51tXx5JdJn5aM5RDp3bP8dSaQAsHwG3RC8vI4n489M44qsXO69mVLAVlJjGtApTQphJcL1fwT4TI1gF1e93Is2lvx5ZuLIB8q6zAN74gXBY+VVURpx4pvLzItssOh/qGBicSZO5i1GNeGj/2sh4QrQ7VKxQSjV/8K0pvZl1/doF/B80BFIdbNufmz1VK0zFb85VXFUXX0VOl6WyaHDFhwJ0IXvevv0eQ3btNuYJuCVOc+sIqI02tHhYn9mylmQImQEOxQQpz0QOcuiZMUrmLBj7NaSGr57fHplfHqpK65ZWUwF6u9NyVwK0JIv6Zqxpap8ARMKQIH2rfKyVJOEMdxfkLqeCTOq7Vy1GxcmNwt0ITvRGaoOE+Ubt2YOq7zOiZ1oEI5noYl0h93II8VjFioKFcnxAtJRvlZt3+Z9eQy4ylVn0Oy9joje+frW2a2scxcz01CgA6011leQsMd7U8UIkEJxluSrUB/VfRGCQHGnlSzniF5qZ8RErJOKsoPYIocBjdEqWs8avOBjSEAfCu+N8IR+fJBJaUOcsgum1g8KJZf8I5X5RzdVuRtLNvjQ2yiLhUOpXmbXI1znE8PxOkf71KmoLQGiQFVdKrtx6mP2nDY6HC1JM/BMEAQtJGDi58Lvigk1VmUir9h7pXh003l9QTcXpynq1Lcz6yZnzU5fdbfc0XbMwnpkcCJYQp06VvuICJ3BONUvjEBmXtZttU9+nECX8pXll6mffQg9FLEdFziE0g1wnx3mIe5ILqOhlGoNbjCkGsyZVCG7MjNJSKitG5/NKzNqi4KqxPt0+S9/dr5wspSd1
 TnxVLP9N
 ddHQrxepgbbZxELLzD3pEF+5yc8xkx9SPpfYmEzN2nJafO6dFeBnlEV9yhDcX/RgjJbIgDkZM7HM0HchhLRtg8XqUOMLoCu4VwizuY4H/xRmPSBPLs+clYbE79O9bnlhc7pzhwrkqBpPKcmWfmoNoQtDzZlJwoY+GN24xPPBQnJgxZJbho1MJfIq6KBBSKhnLUdAhbhQe4VH2+5Oj5ClaydLfXGcUQXq6c++nzSQkDYU/jXJ/HP2EkRrYLZBf5WANOta0ipqQqHIaqMyzbWN0TdYLR9k39yKZ1fMlquVXiDbH0mKplcRsFmapemspxkIrkMbV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 03:20:30PM -0400, Zi Yan wrote:
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -2205,7 +2205,7 @@ TEST_F(guard_regions, collapse)
>  
>  	/*
>  	 * We must close and re-open local-file backed as read-only for
> -	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
> +	 * MADV_COLLAPSE to work.

Is this true?  Does MADV_COLLAPSE refuse to work on writable files?
Should we delete some code here as well as fix the comment?  ;-)


