Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 806E0CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADBDD6B0098; Wed,  3 Jun 2026 11:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB30C6B00A0; Wed,  3 Jun 2026 11:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F06A6B00A1; Wed,  3 Jun 2026 11:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91FB56B0098
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:40:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B51FC186E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:40:18 +0000 (UTC)
X-FDA: 84839012916.28.84F091E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id B86B620008
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:40:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=e2ZjQtRO;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FwyipsiWLdhyjXhTM3VU7vrDs7H1TSBGFHlVfKCBm+A=;
	b=8dV6wtTpXXxnSQzbK5ZaUavPIAYI1fopOHbtT+a807YrGOHv8wqsjzr8RXBWSWHJ6UlEHU
	N+8+aphC/U5OK6cg/ngu3xzphS3KrTWFuZDYvCoHhiSBkX73dN23PGIzvdVSxLOodOKMPb
	OpWTwm/iWsYJUiFx4nJo0QnFOR9LJ58=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501216;
	b=FJuyPfZXxIgaU6b846e2dx2nuHuQqj/KNvNdebvYHrQhSMLlq9+uVria4ZD9b+kynEDDLK
	slDulVzAQ6BIezgv4Alfy8sltJc1BtGijGG9XLTPlw0/CUoHkeP5tB9s8F3rFlHc2OJoS9
	xIH5NyYMD/Q6hoEkZWb1+dLi2s92F5I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=e2ZjQtRO;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FwyipsiWLdhyjXhTM3VU7vrDs7H1TSBGFHlVfKCBm+A=; b=e2ZjQtRO9TKskyAd8FXj1qnJaP
	/6auntyxaIMryecHQvKkbXTM9hvkURlS4I1/iGe3dDPikOVNcs9mViJeh7pzXp/f6g07ynVgi01Xr
	Iz4CQRqfLNRXx6bSeGZywfThMD9XCGhBNilJ47A3uaXF9GbqikbUSHkKEAvMqpliz2MvIfGe7Hx6h
	VPAStJDD480Cs4AUbGctmE25Sq9uaYaolhn17Z1Tz18SDv8StZCFivIVa4sV7RUxEwo7R1g1+zWy9
	itr2Re17m1iW3uWfOu6JAGj1ctTOE02ozhd6icRrXHeTZJYcJRLJNi/tfEFjf+7aw+S4Oc4sSyayg
	DU+3YhLQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wUnh9-000000047mu-2mYd;
	Wed, 03 Jun 2026 15:39:51 +0000
Date: Wed, 3 Jun 2026 16:39:51 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
	Tal Zussman <tz2294@columbia.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm: move folio LRU code out of swap
Message-ID: <aiBKx7t7XRBWJLm_@casper.infradead.org>
References: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
 <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com>
 <ah79c9IIuXt51ybs@casper.infradead.org>
 <aiAGrJsNm_uAf1qu@MiWiFi-R3L-srv>
 <aiAXwQQz0MeGrD1x@lucifer>
 <CAJxJ_jhTAS3gbo5AoLPGCUSchUPTsUVzkNVprg9pfzqXFpPEaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJxJ_jhTAS3gbo5AoLPGCUSchUPTsUVzkNVprg9pfzqXFpPEaA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B86B620008
X-Stat-Signature: roo1nigdwxbtbp1qgcxkwcca93yidj33
X-HE-Tag: 1780501215-149648
X-HE-Meta: U2FsdGVkX18GTsNdaav92JxG8e18LEvdUXIECprAIWCDCI6ZGSe8Zwb05DPu+x3uTq7pA8lDQJB8hH9WJLLyhCD/qDfuWuEtEsI51QFDVbWTjYnvJm1AwtW5u/RpEgRjVhhdOHGgzwYRoybIztyy+nLR5R/b+pAlsHerDc3qUGHhmvVRHdKsa2KYtoNSLeocZu5PMjm0TBMi/rWyaCJ+hNXJIYI0sDU/Bi/7WeICGapv8pNJE088VN7/1lwHd5SNEhfDEJ358EQZ54b7ELp8O51OZsnaUqZUHVolEOiZPfPHdKU5JAZ4yQeTJn+sLJk7OxUxRIp4cY4GQWiv9ytaULsFd2O2AI15S76OhryWRtSGMF3/k1jzNGOUD3RfdPwOTW7tDIVVRmI0p8fPt2Qc3kgLx+XHficrQ2I9N4kz6jjNgj4nJxRr27q+ww0rLsHMljP4SNwEeZOfFbROU3E0Dr1IzbPGr1QaGLGKx8dWkeDfNWFo3us7kwTnbpEWWmBYchDvUqHRSInWv5eh9P/ViwPv9v3BNkNdJkD4cl9eWS1Bogcwz6me0PUtOIVeJBgEGDrE4lnBnFrdxrggNxchGgaN7l6STD1s2FEsiUcUh1VPWv2+qwSwAWOHUWNM0NbGaDBGFtWy39YsJB41nkaAfi1zG9wDXSx2y896Ix2wTEFSjBxxdX4kqXLO5xIbr7wEEh9BzgLSSedWPT7oJK0m84M4YZNLJsc6+vl80USmen8RNowyLYnSEHE9LZhaDNI3BAsXEW8+miRDdAvHFdJd/M63eMWVpSq0ZMzpXyLGB2FSbMtBzUCEbE9y9K8gBbj7JBR962rIOZamS38cJeXf0/oRgzFRyUkHPrrvWHlJZ60zulA/h4HkAACKLI+O/m0JxIq/t4kQTo0d2BGRotzcRRCkDVDJwhOe/lHXojAjfEWrhIRWAY9GJNSsY6vMrN6bnQOyw8WQzwK0kE6/1XW
 zX0WLRK+
 0yvClLVF3kDBExPXdv2MS0AMXpnrQcF/EpuY6BxrILAZiVphtztwuSwXm7iiaIGMV95BT3ycA1413amQnwuKTMgO6Yp/XRfJXZqAEDw9AE8d0M7gzILefHnk12HDlgxp1NMFgutzdjO7vmNhv4cYZ6uKBZH9GW1eHRwC4UC/3O74wz9iWMWxDJRAHJO1JQmYtSXSqsvRjNvD+v7ArI/gS65Ge9xsAQfVTzqeFOmGnnXQwZI4OzPR02udaRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 08:29:44PM +0800, Jianyue Wu wrote:
> I'm posting v4 shortly. It keeps the rename to mm/folio_lru.c so this
> series stays a small cleanup on top of the swap_ops work. A broader
> mm/folio.c (together with Tal's folio_wait split and the util.c
> helpers Matthew mentioned) will be a separate follow-up
> once there is maintainer consensus on the file boundaries.

What's the hurry to post a v3?  It's not going in this merge window.
I don't mean that you should also pull in Tal's patch series, merely
that your series renames swap.c to folio.c (and we give serious thought
to whether we create a folio.h, or leave folio functions spread over
mm.h and swap.h)

Then Tal comes along afterwards and moves the folio locking functions
into your folio.c.

