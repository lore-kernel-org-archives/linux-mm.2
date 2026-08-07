Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BBA9C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 19:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4173D6B008C; Fri,  7 Aug 2026 15:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF6E6B0092; Fri,  7 Aug 2026 15:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32DEF6B0093; Fri,  7 Aug 2026 15:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 177C96B008C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:54:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A27AD160181
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:54:50 +0000 (UTC)
X-FDA: 85075526340.26.8FCA955
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id DB6F44000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:54:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=r0coSWH5;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786132489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=re5PFQ5drpCxk/MZec5F79BMNzk+R9n11UoBsMD2zNs=;
	b=cpZKYxQ8S8Uo1CFHcW+/Qt2lRHn2MxU5+4PLbTjK1MH46Ezdv1erwwE63iHOOTxo80wBap
	1JYyc0N0Jy5f5yDdLAouYSQXQ8Fovg09xa5do/pjZutUo10prHH1/VtThgCcoVcXtBwe4A
	5FQoKj2DnvhRZG/xLsxQ8M+6pfo9u3E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786132489;
	b=zH71mCW78UBPdr41IAEkEWWZ6D6zzcXTdCpEBvq+QOaSilQCk9cbu2XEWBDpd7WHvCnx3l
	30w/jPEe1X9iwin3YNpO9a7k52pQhxdJpNkLzoloXLqV4G4FrnFzE5nbRoh51HytVfuqBI
	I6eHEn8e0c8Y5Ddy2rIZgKOH/Kne1D0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=r0coSWH5;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=re5PFQ5drpCxk/MZec5F79BMNzk+R9n11UoBsMD2zNs=; b=r0coSWH50wwV9u09UL/xbqyB1V
	JhRcSBKeq+4HRHmx4B8aA6bFJtj1rDV7wMh3SxW2D2fqeu74KKGeOEnl9M3OhSgkOSkxbDSD1EWLr
	Ia0BI/FweSZRmTskiyywsfUcoKgqoVMpPo7yOQ1N3AjPfTjx6RHT+Btyvpn6S/U+x6hT4v1qPR2AA
	xl7qZRm9Z91qNMRmxt/yMf397DF+wDypsqMCiqpEA2KbkuXzo0A6wQg8W2gHWJoPbIJ5b8f3qP2y3
	5H5hG1Uh2/jANLO++Ok5Xl6PWT776AcaChqhV1eUluWtTcHGqOoVXdvVcYE0q3td8XZxWiVVkHaUw
	MQ8lAWhg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsPeP-0000000DNox-2Kyh;
	Fri, 07 Aug 2026 18:50:37 +0000
Date: Fri, 7 Aug 2026 19:50:37 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Christoph Hellwig <hch@lst.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm/page_io: use swap entries directly in zeromap
 helpers
Message-ID: <anYo_XxQyTRhIvYu@casper.infradead.org>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-3-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-3-0899bac3b826@columbia.edu>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DB6F44000C
X-Stat-Signature: boyfk3uzzqmgynqmxzixzehnpsz1hs1b
X-Rspam-User: 
X-HE-Tag: 1786132486-317028
X-HE-Meta: U2FsdGVkX19BX1EL397kZH6/7eTb03/hBDMSwWcaueABQOcJ5vZdXW5p5ZXbDd8G71bPpkWvCbscg/rfg/JIXdxG1dCJ8G7HEnmd38Z1ZQpatovA5EPo9QkWPqvyfV3pCWjHU8NwYFKzWdhl0evx+VdzjlHn6fnm/SNUTct7OB2IaOzCKWjyCJU038aU38u/JdaXTmfXEnouF0hP7oNwc+qYBMkhEIL8S8n4QRK0F84SQvdHuSTL1hEQQ47BdvD0TFJgvKD/BVJ1rNoLQxv6/pxYArvmUnNl6B7fLekMgkHOFITUwtFn7ZGRPFIh6v0w5iKPu4i8l5DHHra2g0DVjcbWzwPxcgZDcPy1k+IdxCfpvlTvroaSsumVwQlpCqfsr6xgx/sHKmMmPlydhDGxWhQ+rG5LvWDz7Dzg+ZZDmAsoLIP1XM+pQLZztPBQEHiVzKdlX49p+qYbiPcltV1I7iOjoI1HtVV4Lrev5Oy0og2ymOeZBMLm6HCI6RLMNa2j1E7ubKa7aaJAF7dRm4HRN87UZHMvT7mK+og4e7o1/jCYXkTkSvDpwgXnuQ8eghsW0sAEfteMFWljCSxOf9WPKwhOShv5VV+lbdPBNPfg4nNF/8nrQquniwmKrIzqso623s/zKYKLQ2xXQ0+R9bgB5G+owAbPcmgePn3n6hVHgYnZ4BBKZ2i+LnBh4IQY6EqE/f2RKmkzlgXBh06zpEQJFPcHQYQO27Y49apRM3byXruds/mjReX8j4rBGSh7vnKgCgWDABcJZhPCGkWpuLqf7vWxhXd4WBTFPjzid61sXSr8onbTcjbBBUGqhOPoRUmfYPRxyxKWsorGaSwnCu0zvn/wpVR0+HdpVjJHt9mwwwCjmgvDmMz1dDoKNUYXDILHNHgi6YdLvYIZSPRU2FWRIO0ZaXQ3Q9LJS+cdhF1d8Icn2mu7Od/9sAwsQ1mBeLNhwRslaInfThrn+rn//4b
 8GQCjNm9
 fAjqjkwtO7ma4h8kC0f++UpQuGt0bXfUV/eOeeGj2G6eqaJn/ZuW/vKf/TL9cPq8y57tdGKrp9WvgdAziKhtH3ayQbu71B4fxpd5pawDgTR40J8L/TUWlcgYvisXt5P1hU274UWcuONJ8Z8N1z+L4jveyePX10qxmdsB0NOTEY77xIr0hoEig3HcYFQUaZ30/+gbgwvpdsExy4dGKhz0YpoFl7rVzNYic4l5e58EzKEaeN48xYKOUhnuqpia4vwehPLqAQfrhqNM6pMHRyVghQeZEO4nFbIeW9oWSEtHd+xZ9nhH9lzWKxcc2/8m3zcBa6FbVl+3U+66RGJSPZDiWE32itHkOKXA92a/J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:35PM -0400, Tal Zussman wrote:
> Increment swp_entry_t::val directly instead of recomputing each entry
> with page_swap_entry(). This removes the last struct page usage in
> page_io.c and saves one call to compound_head() per page.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

