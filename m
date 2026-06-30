Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 878EBC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B186B00BD; Mon, 29 Jun 2026 21:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C886B00BF; Mon, 29 Jun 2026 21:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00B6A6B00C0; Mon, 29 Jun 2026 21:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C76006B00BD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:12:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3794FA0334
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:12:45 +0000 (UTC)
X-FDA: 84934804290.13.7A38924
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2D191C0009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:12:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JyaUNIkL;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782781963;
	b=YiFB8dyXmIG95O1f4MZ/8PyEJrv6W7Q7oeYS+/boHv4Ziiy8wL1cPLHeDIrM22/Gollmup
	luHyZWR43ewDRlPM1/Is429xHC7GYC7XKAfw+8tiDct4xplLqMw7jymu9JVKiyJGxOzAUy
	NJu7qCuNBEuEGYHgOviYKWokKrzca5k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782781963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=inHqJ400rPcs/rHocBQUUyc71tWcLt7G6vrd2M4T2zQ=;
	b=2T/kCE9h0WowmCGULCpnZOYu10rZW4hjMHRH9O3LPE7m0sQ/1/nOmJKQCtTb2SKN/AKEDi
	y64OM4mOmm5tDT0a44oimjhGlam+7plSR2UcY7v5cCdPOYvjU/BlSsxBj0pND2j/SY0xNW
	TPGC0ZMArU5iGUjf5/gnUh8Ivra5Q0I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JyaUNIkL;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=inHqJ400rPcs/rHocBQUUyc71tWcLt7G6vrd2M4T2zQ=; b=JyaUNIkLY57rBH8S+mg/T3Sbgj
	JDSh7P0QK0847LxoRYy34jt8lO2+YgI2mCiW9hZbuwhqhzJ/YdgJyyV9YbFfYWMzvZis8V0tBKT58
	4vI3NaaZz29zTfu/V5JMnFlf4nDSQh5FgXSoa8QQjOCupPb6gJ4Kn7of6hwkfPwgWiS8WBCe/5p1n
	Ykv3+Ri1UyBdByCbWnMOArG2uPnT7IvRpUWkG+76UYzqFRU+OsWnk6wfDNHctZyoay/bP28DPnXpe
	aEvQvSYD+GDo1w499vc2DrXCFrTpgPnTejm5Kurk1d2OVZlfmx15Lxu6ILocFhYlb0+oY/yrDsV2X
	DheBXclg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weN1S-0000000452m-3j2W;
	Tue, 30 Jun 2026 01:12:23 +0000
Date: Tue, 30 Jun 2026 02:12:22 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 2/3] mm: rename swap.c to folio_lru.c
Message-ID: <akMX9hoSgBmulBzv@casper.infradead.org>
References: <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-0-4627aba8ed1e@gmail.com>
 <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-2-4627aba8ed1e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-2-4627aba8ed1e@gmail.com>
X-Rspamd-Queue-Id: 2D191C0009
X-Stat-Signature: ege6xmc3hbmxaytnatggzd3hk9q9ud9u
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782781963-818352
X-HE-Meta: U2FsdGVkX18wb0c+OE4zd5oy+z4G425lduonIueIYwEgr8dw5rNdqbi22gPCxTFyuAYHf3mjQg8OfS/9ML/sszFhBDqrsquOI7EwrJNymbcx8GtQNvo2T6Q2LSoCK/8E1woxMCARgscRCLf8UjfRsUWmMo/KTjxwvzKCRwmnoma4Rcjz92c9DtI3N/rVmPa2cQZCX37DZYCpPnSbrU1/8s6ztrYxC3IgIv3kf75/VTAe6GAvcfBXKjQblz1PVD7CcH1jIMi2eHLV2qjQSP09PpmO4Opvygf7hy8e9CMxHl5SbX5vlh3MFMqCZzarhiPoppx6Ji4TT7jNPpy6VrH6BmBvdN9j+BsrHgS38MZdB1zPT4kEdTt3KRPZ/6OPSMX7sXnIgSuLSpLXUNHtWbpbTfJccv2gPaQz+FW9ENVv6UXmn66DNu3s4xnQSSVIfLuSxo/YenyZ93wvpRwtLeQ5VvfRHZM0FFTWafx3Xzzje6VtYSkssuu+jw4FHk8HOmTC3x1x+N0NYOHh/buRP1LxMQhxw/1n856+nyI5bXreutmv5x/ncaw0msL4xPannSENtKRMDVUjjwtkRA8vPzDnNZOeCTwzrInmv6BA6XCyibxL5SXbo8wQTHN4nos2K070W3tenyH9sdQUD+71VJtdIXOWVnMA4pSMl19MKH2SFZg2WuNtE069fffKydqllyzL/R5kSSRDUT9yV4F+NWolMqGojTxuPtoscXf/f1bOwe5ayWMioHBrnJz16bS7uXV7kksXOvtYWeaPKk3sJ+C7DJ0TH2trFSWPtMjGgEr9vIhslAd0Lqs7PZa5fBrkls3e8htOQ/IjUP/HrQML4dj0JVbmKZozE8/TcN3DCXZ1MP8q3YCmhbRFwfkfEEsTIRL/FViaWveF1+RC1PecbajxClJdbO4sTxJT0pMDC0c1N2er909R2yU4gaBFwrMS+eJvrHeuaCsZZd+db3NOZi6
 oyo8xNVa
 mYju+JjQg+QD+lVsfKLzUcbwuUTwhgsxdVlIXRI8QeiEsrY/FkWygRBEBtN1uQJ5WFhfxfbk+1OMgwLiS85ZfRMdCU9GoiI1s84LDX79rqrT14wl+4PA6hKF2nDubm39JfpcjOd5NA+n85A2+Vlzm0jyVgBmDAD8FuySnstJ2vS4KjLr3HHdkuIdNiJftHdC5Y0NGX2AUcocg7LDHqjfaN3y3x7IWscSvxuWwmfSPUfrLV8rTeAi8z8RPW6gNWtXFyKWS2HnJrdDVs522Db7JRmZHqssZuhCAY5i5060b4tGTbbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 09:08:18AM +0800, Jianyue Wu wrote:
> Rename mm/swap.c to mm/folio_lru.c so the filename better matches
> the code's main responsibility.

I said I didn't want this.  Rename it to folio.c instead, and then we
can move some other things there too.

