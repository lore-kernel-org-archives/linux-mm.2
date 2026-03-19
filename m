Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4347A1090253
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 697BE6B0554; Thu, 19 Mar 2026 12:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6484A6B0558; Thu, 19 Mar 2026 12:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55DE16B0559; Thu, 19 Mar 2026 12:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 467486B0554
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:48:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0215D1DDA6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:48:03 +0000 (UTC)
X-FDA: 84563394888.16.D4E807D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9DB124000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:48:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Xw+O7FG3;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773938882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXeCQjktyUwgTu4HadNZz99uSY2R38PEOAIiPhcfa9g=;
	b=AONJOZJEOCil7GVFE7wwKstoxtpks8xiUYAOHk3b38mveY5HYXZ6J7k8suzlmY8A4zr7nc
	3fBrBlWEc0zgw26GOGEzBje/FC3BvlvhycrOTcIggTihDMdkK6y+V3HGGJdW5ob7scyJFe
	VaDG8bKuFsN8TITakwtDhTg6AXsoe/s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773938882; a=rsa-sha256;
	cv=none;
	b=xcYdnluH/XaomaAexzh9vVuThE8ZjwxoBUMPrlCpJDCTX6g+a+tcDLw7Hf4m20gL6texY2
	MOjzKYMrLYpU4QhQJCsk/s9cS1GJkfR1luy96LVSkm/mljAZhDdu2eOTpF3+L0FD51O24g
	JquRA5qFBjKCH0CLrHYJGtLkWgNRF1s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Xw+O7FG3;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hXeCQjktyUwgTu4HadNZz99uSY2R38PEOAIiPhcfa9g=; b=Xw+O7FG3kRKKHHxXyr7VPkkf2y
	cFCq3KYqqXQrziE6sRmP/vygsVDPSqG2iizJbYDDB7v+Ie26k+NvwZSsIXB3BsTEXbr0JqtbTwSS+
	hqY+z5U3enykK/KJyHy8YmWq6PC1k7y7eRot3E3gW7aXxpko5NLaMmttTY9lXXewOke/eHI2VTJPr
	Yc9so2BFMypj5U4k6Fd0zZDZTW9c4pYWn8Hn+02xgEmi8+0pPk7d40IqSvLvW55Cwn4UqxZI6gh+t
	7TVBhQ4KkP32qovhVhotAa6iu5NgoxFYisyVAvNdLsKb2CbOEVDeiK7c2jc2PMb7CsB/kCJOYLX2J
	qpmwYgfQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3GWy-00000006ODA-0kn4;
	Thu, 19 Mar 2026 16:47:32 +0000
Date: Thu, 19 Mar 2026 16:47:31 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dev Jain <dev.jain@arm.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, david@kernel.org,
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com,
	weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
	pfalcato@suse.de, baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com,
	kas@kernel.org, yuzhao@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: Re: [PATCH 6/9] mm/swapfile: Make folio_dup_swap batchable
Message-ID: <abwoo2aIbRwZDlam@casper.infradead.org>
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-7-dev.jain@arm.com>
 <18928285-20c6-4cd9-842f-c0aef91421a2@lucifer.local>
 <26631dbf-1a3e-4d30-9a07-ff64319cbf2f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26631dbf-1a3e-4d30-9a07-ff64319cbf2f@arm.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9DB124000C
X-Stat-Signature: ityn7rbww3fwwjd1jdxi1s76hrqkdm13
X-Rspam-User: 
X-HE-Tag: 1773938881-939291
X-HE-Meta: U2FsdGVkX18kf+ivNEjv20AJRhVko5qvHqcvPjezyczL2OgJhfRFLA5cAf2aBJJdLQPcrU7bUdDAN4LOKCbkTeruNKyhLSN6B9S5O7nwsOwjp5/Z+EnkmDVRc5owP62Z4hYGIZJHVPYH9daEYfw4YLCVGYcUz1K20j1bonrQ8B76/UI6Jk8qsTFzfuKW8H9+O8tH+DqWrlBKfYhHSdosgfZnm5AJNIB8iGua0vwYlVQanpdzNgSKVNcKFx2tdXvcIitAdCb1s136XFF261gyDqe2j2KtRWVn8Tj317lTt73Mk6P5588fdrbjAC9h5Z66Y7wPVAgdpPFAFV1umeVb8fPOHSfH6diAt2lFBj8Bra7lljQavAjTg2iLPEvbqin5GEoGA8qKvMzn/zb99ZrUXiaiflL2aaoNQ9WROHPs33I5zAc6jC096akPeHd+LZQw3hYIitg2CrvS5N7ZjBGjHUjY6RAVbdbHwmQvYbe+rvx4qnAdz+4NJ5vazmS9IEGNEiwsHP5NzX7+ksIyPtSUUpYpYtS9N9lYC7F9IOUC3MSUpVtBqpEi3ubnYkoYgaMtLKjEQIwSFSvPtYZRcRxOrZgROJdP2hR8BzLyAVVBgYWUXmC1VtXG4KZi8a6PJkALRdwuqRwTLMA5od6qZTv/0JHqCKWHCy3WepeDcdYU189UQPr0vsY2AdwvnoCUmRNfcJ7lVNklrW5Uq9IStFWnTeZEYmS6D1P8m02oH+x15n/lYk2MoG9ZNThqiopnTMGuTVA8fuBBGVL3UKvsgkHPrVYaOKWX2rEsU9hZMqDMMAhkZGWiQFPen9Y/uTNGSv/VjjlHXhmx8IfWfNhuI4LI3XGVlBr/6RX/GH5kLmkQiiBEtz9VwnwmsR2Zuxq49tX73J7P2Kx5vy30CaUZYDv3Wf9d7TNZqFK6w1Zsq7js2ZAYOC1snkb1uqP6rgqcGW+u4XXr8h0LzwA8ck8GQLL
 gMTodPV2
 XVATEcRV56Y3ZBnKGksdUQkT+81G3Pw+7WMqNyF7biHBVY6Zm+J6Yi5jidIW5UbmoQd436EsilB0evZMtKM9PuX2gz33090GNyE70w1SOx6CJVPVGNm8FJvRqTZd+tQVfd0gMAeXItPrwjQNvTDOUQ68uvKZhOoYcuxn6a/FFm+SmVm3gR2HLraHPphF6HZBV6GJPe+r5+f+v69DlcGGdXGlhFU3eBadQk6FY9izwkOXLQ8bOE6IQsolLMclN+jgZr4MgBhqdFgZaKO0JqVreDH22t9J94Ozq/PeBHmI0oLboCcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 11:12:22AM +0530, Dev Jain wrote:
> On 10/03/26 2:19 pm, Lorenzo Stoakes (Oracle) wrote:
> > On Tue, Mar 10, 2026 at 01:00:10PM +0530, Dev Jain wrote:
> >> Teach folio_dup_swap to handle a batch of consecutive pages. Note that
> >> folio_dup_swap already can handle a subset of this: nr_pages == 1 and
> >> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
> >>
> >> Currently we have a not-so-nice logic of passing in subpage == NULL if
> >> we mean to exercise the logic on the entire folio, and subpage != NULL if
> >> we want to exercise the logic on only that subpage. Remove this
> >> indirection, and explicitly pass subpage != NULL, and the number of
> >> pages required.
> > 
> > You've made the interface more confusing? Now we can update multiple subpages
> > but specify only one? :)

For the next version, please lose the "subpage" name.  It's just a page.
folios have pages, not subpages.

