Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB79C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 23:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4759A6B008A; Sun,  2 Aug 2026 19:23:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44CD26B0092; Sun,  2 Aug 2026 19:23:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365A96B0093; Sun,  2 Aug 2026 19:23:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 111AD6B008A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:23:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9596E4053D
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:23:09 +0000 (UTC)
X-FDA: 85057907298.01.C20AF05
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5F24140009
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:23:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SQkOZwYd;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785712988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JI1ktj3Bz3caTxqnuCI4TmhxMGBgh+dVMiaBP2zCz4c=;
	b=pww2mzlS/2kcJjhtc1Oub/6SvOOxBXcTTqWkNL2EBk2hE/gvJxAdsfjkMXXhk/m6XRZGyC
	LmwTYi5wd3ogNxa5lNqAa72sFNG109k2iOco0Uigs2XfcMEDa6KAiR/DHpEFwP8foajReS
	WxlbESLZkPP575bsXy762Rd7BJ8BeyU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785712988;
	b=tLlXaq4PY4Ta7qDrzexB0/S1pe+gXs11AwQoqq6U1sxMM9FOfrjqlQqhwaf2v9PawrUwE9
	AeybdV0W0a55gM6hlBI1T30bkizcxS9qExt9DeBYEmS5hbzH0SqFIjXRDfPexNNSR0o+gx
	gY9RQIVRSlO+qBbBOcViwZPev5DW3y8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SQkOZwYd;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JI1ktj3Bz3caTxqnuCI4TmhxMGBgh+dVMiaBP2zCz4c=; b=SQkOZwYdQ6aROR/PLvxeztwjsl
	A6QyQsShXcTzOPW/XpH1Zr7axPN2BtzTrDixng/CTDk5sWMVt6EQ1PhzZuz8210YEqv2bBmVUNE54
	2QLm1YvBS51NbyoxfQuTBczwg6NImLwZLftV9vWPKfeVCukNvgY7AanhCBLPn9nH0CKV29NsV3Jl3
	RdJwZEmb0K/sPtoJkt/OdzeJnQs5YezzfLy1DXvKYfuivXhc+r5KICXRx2SBMFgcGnnj7xjsD3SDD
	ZBXoIYMqf33/DPczcwBOYp3vM8dGDUisP75kOERfF13y9jGKZin4LPePcjsNHLnNIxSGScr8EgknA
	SGXZsZLw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wqfWH-0000000CCTg-3fst;
	Sun, 02 Aug 2026 23:23:01 +0000
Date: Mon, 3 Aug 2026 00:23:01 +0100
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
Subject: Re: [PATCH 3/4] mm: remove wait_on_page_writeback()
Message-ID: <am_RVfvDCDDOA9L-@casper.infradead.org>
References: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu>
 <20260802-remove-wait-on-page-writeback-v1-3-6c35d6b3ad36@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802-remove-wait-on-page-writeback-v1-3-6c35d6b3ad36@columbia.edu>
X-Stat-Signature: tjs3sk7c7oeqr98obp9ht7bhp8tw8su9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5F24140009
X-HE-Tag: 1785712987-101897
X-HE-Meta: U2FsdGVkX1/KnRr75K/00iroVCDSxQHHLnch628uNKbVtQw1AMrOnfoibIM6RFk+qwkxq0hMeowefzUizR3qq7cDj7WP+tuUxC+RsMOANxvg+wm266zLxyLczwS90LkQjCN2htSXqkZFV7Um+VQTk4+U/3Rd55Bqu915bxyKrp/gVEr7ffUOCqDcYW6rSTAF+EHxgYTn7UXXWJs3Is+5tvd8iO1ZFiGzKTCDAO6YRAi+Dn0C18HFrWMUoXY0vHISYyHDYlTZhVaXRbYd91c6Sewm92N2b5kAdt2ceppp9RiV4fgC92k5sle4I04hmm41xWQSjNFsT61c4huYTTfKMvkz/DtG0bXsBBoQFG53m/ZxhXFcjjJt6Km3bl2W8HYd6COVUvJG7w7yHtFfv5d/WcapzLwBZ6gk43aJbkp/QF/gbwHtacitxKtqfI0prAWsflAGZDEETox7Jr3zttoSg/1GoV/svhS1cIT4CEIpSE0TAbt5x9gsaWtr3K45qA55QaIU2PYkSpv+PFn4Z+/45k2m37YSImQCUkW9UkDcZOEpI+XtMIYg6UDGfKCmrVo2riUlE9owiKm4ntPoPRUbmakMlZejiDrnQoS5z+c2do4uxcQ3bdpW2Tp/mhpC2m3+FipftRB14AKhq/9OFn7O6J2/fMvxv8E75tGqSyC1vNmQfKWMyquhF4oBxBDrPsOadkbQwW/+oqgM3yqlJOI9rz6UWkLUiAEoCLo6PaArLaiejFBw+5M4XNG7rIv+prs+1DMGuCyU7RjAXT4FtNLxEoZBnClHb8VTA0QhgeKyn5GGUVHTZ5vRCk8CRTw9quGf6epjHXnidy+b3lfzE/8XT47A5quGyriF9ck8pQK037GVECuuy+HTpYeNhxQBkI0fRr+zd+0FT083jcjUcA4gdfbNLcN/kun9ctrI4RTiQP8Z1QAGIC4vrgM8yU0oAbgnQw7XCqTsjLisMle0s+f
 9GFdrWwv
 FqA0pgIuXuv7++ypVGyk+kBzodIzUT+at90iRHhCKOAu7MFT6OBzfRgCR32vdKSr36K49+ipPNCCWFmT+RQ/r/v35nuuEKnhGimakhPewoSzZv3rVsLeC5AdkSzRPjk4K3alHBJb+alXmNidUmV8Y5KMBex8QbUGfbbe72z6SUWjXk7wmXMvIgQZ6XGRTIAcWVfhzVZwRsIF1qz/6OTD8zYBdAQivLVWajgzFBI1ThGIxbK47FAM2nvr72HkCpbbwYtC9a4F9JSgw3Cgl7Gbih5TvBMiokSeSKKct/V6WYDQF5oi8zTJMJZtZLEsMU/K+61iEXToocpkfPdnD9iXEyKgd9z2nPfL/Mx/pqy5oX7qImrehaoiXFxQ+CWit/BdRc+7o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 02, 2026 at 12:50:04PM -0400, Tal Zussman wrote:
> The last caller was converted to folio_wait_writeback(), so drop the
> wait_on_page_writeback() compatibility wrapper and its declaration.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

