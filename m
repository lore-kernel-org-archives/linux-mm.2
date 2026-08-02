Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2626AC55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 23:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1407C6B007B; Sun,  2 Aug 2026 19:22:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F0706B0088; Sun,  2 Aug 2026 19:22:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0076C6B008A; Sun,  2 Aug 2026 19:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFE2C6B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:22:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D02240557
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:22:41 +0000 (UTC)
X-FDA: 85057906122.12.7C4244C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id C3E8710000B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:22:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bNCcfmfX;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785712959;
	b=ZNEVGtl9Rh/VQmDHOVpluKUQ2fCH7UYrMlPV0oIJDUHcjM19056dFUG9gwpnvQjaRrfHgl
	f4EVrrmn7Rk61UV/NM7zYBk2VJSOKPFg70RfGHx97mc85BNEQ3ZheS9AxE//S64Eq2MrBa
	dpEfCGxjbyX3U1b630Me2blo/5YTSFc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bNCcfmfX;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785712959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYPOkQbW1lOvJHgzDB/D42RIqBuqUE7gwCxeBtFkNcE=;
	b=chWB7BQs7uvF7JusNrzpTBOaAOZfe6dgvs9peXh9TjPoq/qXIuUfdnSnnE2UTGgXquC1ik
	//LfFbYOioCCN07wxPJYOnTNvOGiqZuftuM/Z3uqnlT6brPDOeBs3SfgcMbrVmRoWOs0qI
	3Bmyg3uqs2vnNYcbO2utRqwllesc1EE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CYPOkQbW1lOvJHgzDB/D42RIqBuqUE7gwCxeBtFkNcE=; b=bNCcfmfXzYPcDZU4gQ941j5m+e
	ezZSwgr3RloMRdgx0AtjFMkwQv2TZcjb5FxNEO+bLaQhhSYdInhHgG+cIC+ZK+3nUgiWp1JM07dPL
	pEB4m2M6GzM47r7k6Q2hStBVUUU0qvd/67jn/wsowipJ3J4yY0F+pqIwjYRrsGK+1OrHV5LNehNJq
	DRw2NG62SGqccFo52U6OfpfykBJWe+M9FBtLKr+Pm/9/y7Ap/pNaMDGPGZbU5b99YEYTpV2kWQajN
	cxOJy+i1wLHH5/obl9QyKatff8oACgs9wpdeTNsFdh+6YUkxuaploALcfmznKBTZkOHuYldJR8gIu
	w8jxBHzA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wqfVl-0000000CBhr-0SJ4;
	Sun, 02 Aug 2026 23:22:29 +0000
Date: Mon, 3 Aug 2026 00:22:28 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/4] ceph: convert
 ceph_wait_until_current_writes_complete() to folios
Message-ID: <am_RNGURAG-chvAM@casper.infradead.org>
References: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu>
 <20260802-remove-wait-on-page-writeback-v1-2-6c35d6b3ad36@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802-remove-wait-on-page-writeback-v1-2-6c35d6b3ad36@columbia.edu>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C3E8710000B
X-Stat-Signature: fozj1z9xosdp1484iejd9jfq684g8hwq
X-Rspam-User: 
X-HE-Tag: 1785712958-991927
X-HE-Meta: U2FsdGVkX18IFHhyx2xbHA+zyTSjJTgiQjlxqSRJtxtxB18BdSiJiGehgEFPnQUGhLZSohZZevlO5BA0Fg4JegyFt+zqhstSOnb8Y6Nmw8+3Jx2OemYwfyjqMhJBIB3AkcQsnURus3paXuHVsMWTlTCZsOJ/0AExKeqY/lEj6MnNIzTxfp8XoW5EVQMX3TsBip2NM/JR84oknAg+Qu+rIWoowq5HI59PwsCfJakM8ToVdpz8VTCIFBvRuhQQzwBACV6SKJk9D7VEywV4pUpndrBmYkCMjhJSfUU87nYOyBcrINN7Yi5QPagPkwTUJTgXXR04Niqj9v0eFOiYOn9WNp1Sca1R9rhMsQ8b4dMsWqflIUAe8tcvCRIl49TOUBMRCx8OHasyRRo4AF3rZ2ccMRX9Mda8Mqszt9Y5Ri9qEjAu9BbI1pz25ve3RRIe09l6NsEj5+tnrelHvlRJIHEuhWrFFXHqPDYfMG3zvu6+JnFlva66Pn+CqnMz3tZbE5qv3H46x8SoDuHXMd6WmsJJIMlLIswVrpshKe2P4sNyqCeQJIj5v8VzM8uv3uTbAsTaUtxu1Xe+ntS+/TQZLcUGuEZk8Yhzm6dQBWh3FGq3+kMpHx4eV0+0eVdYnZ+HLLs1Nx3/mLZJnRNQ12GDYYdnKmdijXFHdAn/wvpbyK/V2VUmEwIzBfPBb3BTSfuDXVwOlMevy0pZxX1G7dQMX9BFYrBNkJ88pGXCVLfeGNio8PDJjuttXWvVSUj8qWqkTel/30DWpuvbdq79xlzG5DWh4FE+LzsE5VPcYLBlnkJildE9YBIuFHXWpxizxZ5FmunSxHOOg9ghI0hENzhi/FDi6ZmVj7685M1wntf5/2n7fn2oBKo1r377J3WuCTxpKU/lBZTQVNdGEu0Pta4HBqgG3DqdzIZa1g+1awu80hc88uJHcZI7W6NUCJ8zD77v9E/eAYv1BqXohGg4j2/saq9
 v82NSrYf
 bKHBrK1Q4HfrQb2hUfvL2wfQHcXt6TTcYDP/X2zu+aQh2Bu+jr9I9rL4DvuFEFxKhu+BkV8bBDYFF8USjWLlBnA+Pr4Olmfvz3KqD2rMnvwTRyorkAW53w2FC4Y56Berc1rFf431n3+F+Pp9Eu0wgRBjJQ4ijG46OJtqHMd2HlRjg6A6BToLLH3/DBl7S4uYGKQmVGTQqj3jtaY8H+m1ONs5OK+pCztNlx04mEagGP5APmrPgjR2bYJDw+yFDC30Pcxqm71LKFLwocag0q+DovT+c/qwlvSqFa0q2gfaDVS1B1poUd4L/naG6CugCZnDv3t/ptsHgCA5LbRab3C7zhoP0p5WOBzMo0Eh8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 12:50:03PM -0400, Tal Zussman wrote:
> Iterate the writeback batch as folios rather than using
> &folios[i]->page. Use ceph_folio_snap_context() for the snap context
> check and folio_wait_writeback() instead of wait_on_page_writeback().
> 
> This removes one call to compound_head() and the last caller of
> wait_on_page_writeback(). No functional change.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Beautiful.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

