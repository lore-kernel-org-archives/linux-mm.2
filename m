Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8666C5AD2B
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 01:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 103B46B0088; Fri,  7 Aug 2026 21:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC2B6B0098; Fri,  7 Aug 2026 21:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 019D06B0099; Fri,  7 Aug 2026 21:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2836B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:01:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9542160230
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:01:06 +0000 (UTC)
X-FDA: 85076298132.09.C490C4E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id F050512000B
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 01:01:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=C2xfi2Ki;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786150864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Q19VgZTrKUHTTDXqxXWDvuS6KJO/3691btmdN1kzfo=;
	b=MhFxKutNZWHzbbo4CdQglDtH18oVQHP6YSjqgFGtM88FH2A6s45XnucrDsOaXmRbrbFw5H
	0Vy3XlscDFgQBnNQncsaR4DIjrF2adUvzL6KcH3aSVwMNWVWTADwqVVGNgVswr0d/JgyM3
	rkyEysj4fRjZeHPs3wCj3MPtaJCWKVs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786150864;
	b=4x025KSUAO2RAEgiwQJds7CxubR8oDI/JnK1f9vYB1mMSYJTCoHFkIblyOtKsxEre+iFJL
	fijYWAaTDojYmNOIQpLxi89XMvE6pbPA0lwofS8OkD5kHzBIBRyPle6p3xE5L9MErr8CFN
	fezhQBzNA2r5gyTPO/PZFj33y+0uSyk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=C2xfi2Ki;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2Q19VgZTrKUHTTDXqxXWDvuS6KJO/3691btmdN1kzfo=; b=C2xfi2Kivj6/FI4Pys8nqHD+/x
	2mfL8gP+5GN2VJjSeX1dUUv4wRTB0oe2Nxsd6MmYrFJb3DhG5U8VrA2/vjS7caFCp9cHcj3INyUzX
	nOgAi6E+DRVUwPylCQZ7/rQj2Fa+baBXslSgXkXtmWFsYT2LdFMN/SEHIEMHKeAV7kanO/vGAOdvj
	j+v3qoMepC5AOCXtJTg5cyHbQRyi+m1noGyU4ogfhhydGOGrQB40vmRiS9N9EaRZA7tJnKUixzCVg
	TlLxnrJSfa/bg5ZftKFBkYoobPdQD4znPl0erzANoM5ZRfyhb5K2Nu+CSIophSkCm/y6h7E/0AV7I
	NZRAy9sQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsPmm-0000000DUxj-2GxP;
	Fri, 07 Aug 2026 18:59:16 +0000
Date: Fri, 7 Aug 2026 19:59:16 +0100
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
Subject: Re: [PATCH 5/6] mm/page_io: refer to folios in swap_writeout()
 comments
Message-ID: <anYrBEk4_Gzx303p@casper.infradead.org>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-5-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-b4-page_io-folios-v1-5-0899bac3b826@columbia.edu>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: osxkfth55z8u4hmn1nonpm4bixbpij6h
X-Rspamd-Queue-Id: F050512000B
X-HE-Tag: 1786150864-663449
X-HE-Meta: U2FsdGVkX1+xCK22Po/XqAZDpGE+mrDTygrPJs/VpT7+MwnRRtIu4jfqRSKgJFnsVFIZSdVvF0Rxk2NXOhIOO5wrgINPqxLPCRia+XcLm21RvImYQhz1AsyY5vKA6AZYhG9KzdF4lF0UpYXYDs1vmcqi0gEpU1dr7HlEIIKjjcnJf4ftevFYWvNfMnNpRUy3z8qPksY6cCMRBSROMccAEsmkTv3GmncJbGAZPm6pEUUnptwosrv1LTLXfuG9aFg0tilJYG2EP9+w8Jbw4TCzd83gJERLqwwRuLjXxVRyxSTuJ70ugsMNuAluMB7Uf1qJgslLCUk2i9jCI1AwnzPghL6duRj4XV+6hqOjNu8vbOR2QQOSfQ+yrd0KjtX309Pkz02VgHXvL5nFushOuQAzVOwnPkFPnMGyAv+PJofz0m4MQO8imLRjjTGwfN2CGEYNcUaSNeUJeuGPfjlArrFeUat4yjzp/TcFNsunsZRT3NtxeW+4NNq3a3ZlwGMaUq4hyEIYu131yyBgchzi6pL2e73jcNB1LATTRRMDwehA7JadJLu5gql4CtevpHqwWK3WrJfwyu95GxnqvcVvKr6uTZDDrCoWK59yYYWiFv9Lda8+Qir1OAQGD6YHsV4Ak0pMOaLmUgMQI3w337O6HtlCqy2RJdB4XrrZG7u//pn46xCxEBr9xqVDwh4FTtx9VpuuTgBbj7oMQCDnKr+RkGoa88zC4rjO73i8yw96FYDx1j8bwS587DJkaLfnMGXuANpmqkAh/n8CLdf0MM6qaTMn7/bxHwLOw5heC5j+EKhthI/ZuC4SYQ7p8Rxnyun+TGMzq26aL+zVeuwluTMxY5/P/k1145Fq9JqhOhMgolJoBZxKNKxuEx+vRsKD7Rvs5XhYiY4qFxQV50hAtSkRhIi/9qZ8rphPvltlRcO6js/69dQPVpqnXsIIAZNLqYo2u+Z6s5KB27peuhMnUGxkZh+
 694PhRti
 skk3CQKeGIf/s7QjjZSwjgCSzl9NQRZSX0fAUtIhTOiMxP1TfQajZmvTOWI7/exuF+SW6bFtkAnNwSbXgAWOmpjmsOgEJTx8RsU3flaaUepREiqRUoFuCcW/A7q2jCbU05jAjBL/5QQlRMAnuBox2Y6sf2VKYILyrmugenrClbWN6CzroMqxJZChyRnYx/aIElEDMFoujPVK4pM0arrFSq6eeCBj2SYqlaHDBFq6j5jTLc1g+5snQO8uDtzpGF4wGXOMG8oOPyd+D5T8CvZZS2yl3LmG/m0H2j4LvfQ9VgqiqMEN2h6qIqyhZnWsnm0oa/qhOoYZsqrmIi3OxauEWlYDQ/nSfCp+/IjJWuNmCTF1+RsKOtP41t9Apkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 06:55:37PM -0400, Tal Zussman wrote:
> swap_writeout() operates on folios, not pages. Update its comments
> accordingly.

Sloppy of me.  Thanks for catching.

Reviewed-by: Matthew Wilcox (Oracle)  <willy@infradead.org>

