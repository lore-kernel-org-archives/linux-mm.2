Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 359B9C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 20:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F10B66B010A; Mon, 29 Jun 2026 16:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8B96B010B; Mon, 29 Jun 2026 16:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF4E6B010D; Mon, 29 Jun 2026 16:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA95B6B010A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:56:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B783A0277
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:56:02 +0000 (UTC)
X-FDA: 84934157364.06.DA45E65
Received: from one.firstfloor.org (one.firstfloor.org [65.21.254.221])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7EAE940007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:56:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=firstfloor.org header.s=mail header.b=eXLEYbaA;
	spf=pass (imf01.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782766560;
	b=UpILAUaudG4noxoSba6DdVe7bnFn6PGDewlkIhk8O/FqV5TNrDnKLfPwonOrOjN5lZI01v
	Z1Zbys8r6h1CWadr0gHe4MUDx37gIbpeST3znj5jAdq7qA9x/vXgOtz7cTq2fGoRW8eEcR
	5jbNUWH2EhoMT93QG1AAEIcLnxafdSE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782766560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aj16nab06T0RTWU7f7VTBzkIDG8/cdXpUTIVhdbMFDw=;
	b=Xnb2uOHnDNDPiKz7wyjFgV1xiv7uYLRzCyDUtM+mYQdzVxicgJ+uWbF7dORRkjwkAuhC8a
	rGi9IvopDk/Hzacsr7fFrMp49Nx8ftdWogfkTbkYZDRlmF5iMcUyNQBHKli6FJbPjH/9pY
	0xjBVcSYHAPEZ8C9q+ViwMFkxlEimAw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=firstfloor.org header.s=mail header.b=eXLEYbaA;
	spf=pass (imf01.hostedemail.com: domain of andi@firstfloor.org designates 65.21.254.221 as permitted sender) smtp.mailfrom=andi@firstfloor.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
	s=mail; t=1782766558;
	bh=/tvg/jN0WToCXtXgDqZ/kuwds2GDUd6tWHDA03ofEXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eXLEYbaAqXzj/CjiVayX5D85ctAC6z4mLTUp2/1tYuXAIndvl0XPz7qtPphQmGHy1
	 c27SZpdv4xKDPL8QwYAb/COLdJDU4rV0J5XR3F8qAixw9ZsqAKbtnaHCHFAbMqi5Du
	 mrEFjObTcb3WsXHQcH3NxK4z+xOcKZueE56Ud878=
Received: by one.firstfloor.org (Postfix, from userid 503)
	id D8DB35EAB0; Mon, 29 Jun 2026 22:55:57 +0200 (CEST)
Date: Mon, 29 Jun 2026 13:55:57 -0700
From: Andi Kleen <andi@firstfloor.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
Message-ID: <akLb3WW1nJBaIBwc@firstfloor.org>
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629092856-mutt-send-email-mst@kernel.org>
X-Rspamd-Queue-Id: 7EAE940007
X-Stat-Signature: k8f6u76bpk4spjd1kqaycpnqxq86w331
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782766560-521335
X-HE-Meta: U2FsdGVkX19IFjMuCk/TpC7E30VO6EqZzF0DrInj3szZE1mFAetCJvKylAI4stim9FyWY/dZB4lOvFjcRyE2NHGyMT13jLIeoN0+41Kp4o+uf42pJZ+8tmbgUmV/EWGJJ+NTXPm/Yi9bi12DJo3TOEIFB7BK0JRnWAyvFvUDkaB6WgbYZeyJgGl2YMaLl9T09boF5J9HkHO3cEaRWY50ulHzk7X2PtLpOc61DwY4l8bmHPvoaDp/BsTYP0kfEqCoP6eW4HE/A/od5zZwmz195pRvWqUM+4SpnbpO4UHAbu7dEpfIdVZO1UQUYfMvOne7u88ayvf57Wx4udFzjOKP1NmqYD7bkKDs6D0ysWuhFyibFAAseG6ETCT5bDqP3iPDQ6O/f5xtPI6O8lEL8GhXFpK9LE/17KLPGLUwWztY0JId4vxjcKPNlpJo+dT9MxpUa3YpaaRaMxC320x6LNiedHHlcsmGm3eyyj1l8cPgJUUVU/tlArd9HNg/0CtpaBlkgHLJrvIJxU2sUbu8Rm1eob1L+/5pkhgi3jHR35g1HqdFuWYfLvtrnF3c57TWPYB2BhhMK62lQm/ra8FFCisDsjBRKhqdMdYaRfNIwD3KyMs9d0v0EqP5US3DqQHcsN5c2mduCgDFc5ZyNDf76pQ0g4CUu5N5pcTOuMvF9Wy5n/bBmfkJm2YBMMY93sMiBh3RkYNje084fMWwcwTcDxlo4nowPkSvhQuyx7DJ0KJ2ixCaf2g01X4jQur/vSNQVGTylAoQWGjHDwlnV1t1KmPV132rjM+Ispyzx1xcXyiKVaepBTTYTSsJvm9ZfUNSh2cJsIvUvi8PSAL5zP+38aLOa6EylQzfoMEEPoktMtLVhSSAUxnYON/P43hQJ1SLv8wfyFhXbTBDTEENH/6LjBAHzCecqMt1Wjwqlsla6V68W0nHCg2n8ZXiAwUqkDMoWatwGVZKpbrD0gb7ngFAdi0
 XCdRFD2n
 rmCIEdKiEi8mMvFopw3d6EniR8I7I2Era+j0d6FDhuekoiimpd5R43JDfrX5aiAvaUk+txin+kwLi5DRKtScqeHFMDzU+brGsHZx4oHdvh0LsCrH7g6115jj7DOqEfq8t2BtJ9wVRfLikNN71W59agbGAx/bTFrA1MRT/O8b9DpE3phYAACRFPMW4d7xl9yrykw+or5AHKhpmjHZkTXfogQcmgrfMTUtrnwnJ4ZLAFaYjXRFnblJW4jfnRO07BKIluWcvcbGSmrZxsD75MfnBxfP54BojWi3tXmwc3wjXUnn5VyKyUKRq3W5Z+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Or if there are actually more performant alternatives that we could use. (I
> > still doubt that using atomics is ok in general)
> 
> Right now I'm thinking of looking at something like stop_machine maybe.

There can be (rare) cases where yoy get a lot of memory errors in a
flood. While memory-failure doesn't need to be particularly optimized,
it shouldn't be excessively slow or impact the rest of the machine.

stop_machine is a big hammer that is likely to violate most of this.

-Andi

