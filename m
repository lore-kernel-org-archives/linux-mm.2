Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A78C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 17:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3F426B007B; Mon, 10 Aug 2026 13:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16326B008A; Mon, 10 Aug 2026 13:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E1F6B008C; Mon, 10 Aug 2026 13:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F20C6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:35:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 207601A023C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:35:05 +0000 (UTC)
X-FDA: 85086060570.07.3CA42E8
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf19.hostedemail.com (Postfix) with ESMTP id 48F9D1A0003
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:35:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786383303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rt5AlsMo+AYk5P8dzMLhves1W3fBFsJWMUnpulAKF44=;
	b=I4D3+a/FZixLeGSuepiThIv6bt0TXKpLDkySR1RSPrG8Uo9SfaUXAzDT58G6v24YahDvLM
	hMli/1ioXG/LN6tfVdliTztqaRIf50MkVXtGra+MhQ1p3cwq5B4jW8H4DD7SE9AgNYpX6o
	H++6NMGXfuOwHm1gq+o68aosGN2Qzlw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786383303;
	b=J34fqsSMiZMDlpgz6Km7qmAgdvMSM8bpzTzQxdla89ql8QALNj/9UQgr5y4UaGxyD7ZmfS
	qRshM844gbK4cfYwFggp7YR9dOLnuNGoZax30ZCP4m1kle52ouVjZzIqf9fyTEX1s73cV1
	Oiu11SXdrOdDvbRhv14JLhsrZGU05tU=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 098DC68BEB; Mon, 10 Aug 2026 19:34:55 +0200 (CEST)
Date: Mon, 10 Aug 2026 19:34:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
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
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>, Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] mm/swap: rename __swap_writepage() to
 __swap_writeout()
Message-ID: <20260810173454.GA28736@lst.de>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu> <20260806-b4-page_io-folios-v1-6-0899bac3b826@columbia.edu> <anYPVB3dwJCVoXVv@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anYPVB3dwJCVoXVv@cmpxchg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 48F9D1A0003
X-Stat-Signature: aia4ojjghbwshnw4xi9mtwjuh6r6nyjo
X-HE-Tag: 1786383303-204508
X-HE-Meta: U2FsdGVkX1+j8NlmPrC4ipkkHe9XqLo+CAijvf0/gG49HXMx2m+qEhpCWMJ+P9WY8dEQMh44UI3fQ0giUvYHfw8NhIbobITlS8acncjabIXA5ll+k4mk3CFZJ3Vn6cugC9/XgH638wScrRAI/541LU5H3+bKBpOlH0kMmH/WPY+LzvfRWxp8CqXUgNcoR1xVggvHvi0MtMM1YQV9afR1lXtWoDYcoN//Vht87ME9Jonal69UwY48FxqILSzJLk7uBMUi9l4YlQP54XiLTahFOwkYuiGLedEyLf57iBs3cc6N+/DCtYzFM4D4JQTKHbwGILId5dxpTv4x0sLOLJadbkQFzkG3Qz7gcjk0lF6UzGUKNi3wNXcunKayQurTBspTP0wsqZPkJ0zrQyralzLNAkeG5od/VRAMm63w51wtythhDFDiBhtBIc4Z8PhRIBZfBu78CuZIP0Sf9eh6bANs+jJm3AfyoMJ7E9lZiK8mGIfzMje91zhkQ0oejC8PAHRaz5CNycgdA/Gy8be8kxZmXyD2KwDRf3zu2VWPM+Dl9mc1EL+aJLQmasyuGRvHxStclcz1+tBWImy5mYpJ26D63ljnqWstWxyYnkr92B3FV9HIis5j8wZsKakXozLn5UbFxnCSnej5fL6YKjeQ+AaMrFCW3lD136Kaii1KHcC1N7pNHo0OmUbipFsWSVrE51KvX1q4sckT8Xd0tfd4dsAbNba8qKM4clWllT2vH3WcuA4TrzCZWqJV28yIfgpkP7RcyhRe9D5qHAvwiOIvCuNNPNn3UKlo3C4eJDmZHu8L7O/1ItMTbSNVyfTFqeBFm1Mg0vho5/VtCpEI+FxALoRsN8KmEaTZhH/mI8csYQdLpABJvAeLlZb6pi/kCUVJY6GQ32l84RwAHglXh46BbdBlKEWTy1NdvMky6/2ataOnjAKJgDa8AipEDDLV94AIFKjCkUbWepxxuQCGGhveias
 sAe+d+o9
 Fmo+WDoShRuPXqBR3RVVjjDVF3SzZGWX6nw5QjdEtGyFacN3MtxuBqx/04xsXIxNf0F4VsTxdx1Q2u0R9HTm/D8Cv+3iQcg+ViMPg40D8yJ9DYrpGkyLRcsxAu053TANKyWfD4vLCxFpLusY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 01:01:08PM -0400, Johannes Weiner wrote:
> [ At the risk of starting something, should the file itself be
>   renamed? swap_rw.c or swap_io.c or something. ]

It needs to be split first.  I have an outstanding series for that,
and will need more.  Please don't rename it while that is in flight.

