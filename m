Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4BECC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A41576B00BD; Tue, 14 Jul 2026 13:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F22B6B00BF; Tue, 14 Jul 2026 13:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9306A6B00C0; Tue, 14 Jul 2026 13:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67D916B00BD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:25:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD8491403A4
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:25:00 +0000 (UTC)
X-FDA: 84988057560.07.A9EF03F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id C03EA40009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:24:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=atzfc17i;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784049899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fsZoDfwIlhAbp3r7mUwgeoodrDtaffoeV+0JAtGpzw4=;
	b=qM3KdPdpSAFPx/zggaoIv2BRES2kXCSCSRHJct0yiNi8U7vnq693p+6Q451bCRs8CZjJ6R
	zgVU+xBy3TUgj3hC1aJrH5+yiyosBexkdwB3oB4TlW0opUiS63Y7NfYFZx5oOeHVgFmo5B
	sj5uH+P/mnm78H9utgZJB26NUOJ7T0M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=atzfc17i;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784049899;
	b=lOzzuYd3RIb6orzcWyIXakfyYKrFvA03t9uLdIofsG6e1OiL6BgyVAfiG7QKvfW3LJDTHF
	klkfVIKdFZu5cnBlDTSMQUeLjRnvNL+GT6m13Wuosxp2kLSiijpZE93j38xbvuh2DwrvxB
	6/3BJoNoxCA6mfAWo2NWI562eNzYHjU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fsZoDfwIlhAbp3r7mUwgeoodrDtaffoeV+0JAtGpzw4=; b=atzfc17im00kizUwmf4UrzJrhM
	B51VeAg8wl7/56RvIIhi4jrdm3Wr0z2wHzNWXpUa3TBPlhWQmO0n+F3hrdO8Gha5KrCSUn2pEXOud
	D2Nn33Rmn/TeXOYns4lA7SgJS9iBv5usv4xtLimP5rYd88V0Cx9f+ekvoKq/NvE2CrDQCyaCWAsQ0
	LWVHLHY5bY8FbcLbGG1mZlAwSaew7TWZkNZj+p545JnuhhLiIy/NklVCJ0Soko+Vp9hhsBoT8PFNe
	VLYRSgwnpj2fBI8buq0ZcGhh+PACZBx2svipB49TeHlKoPcHgpR01FPueqT3dRt60YJ9+WJpirFk1
	y3u1qVgA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjgsG-0000000Fa2k-3hmU;
	Tue, 14 Jul 2026 17:24:52 +0000
Date: Tue, 14 Jul 2026 18:24:52 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 06/10] memory-failure: Prevent UAF in raw_hwp_page list
Message-ID: <alZw5EdYVYCRNyj4@casper.infradead.org>
References: <20260709184740.1286561-7-willy@infradead.org>
 <20260710150204.1887475-1-usama.arif@linux.dev>
 <alEpBqExnyvBnnxi@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alEpBqExnyvBnnxi@casper.infradead.org>
X-Stat-Signature: z4bcpsj4rtdqhz3eyk6tnwhe8wxwb7pu
X-Rspamd-Queue-Id: C03EA40009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784049897-578476
X-HE-Meta: U2FsdGVkX1+sMpopK3i3hay/PtrjRjKJXP9vLxRK6HqDxoC1Jc4m3RRnQ1bG95eb4ZkiTZEaBuvOMqdSz7j0ZrGeW7/IQmK2czLcazrrc2T240gA8LXkWLQjRTw3FYKd3mU1qqbYsiXEyyBu+0J8UcwLyod7Z2evj8TSKT31eRsdaj35aDPtAXvRrQ4Z/89e37SaRzHsG+arVPlDF3yG4gFtRayIWtBQ+yfDfd5wS/NH+wPkA+P4aoK8w8xYz+iG015vHZjjiEF0udYLVudFtXm9BqbvTIfnWXI8Zwnrf86eUrT2Q6BX4QODRoPAV0eDwqwlmrIJt6BiM9ebkdgtrdsLk/LujUYDwtZCCUhSsd8jaof+Cy/+k4s57DczxsC7TvCz/ccKrK1bJoN+rwFOdKoMHSWRyq+SDiRiBmvP06VaSg/NGDUbYt6GfMz7c+Oyw8skwVC4uOwyt2kEBSXNA+Nc/gm1Y8qfAmLw8He8qDZa3J5o79e/4G3TyPC3sKG/grjfK9wueho9ecK5+1bKoJs4niJ1nEoj8U51F4SGhKXc8o17XuVUCkPqpIRer28vjmBEEZiwnXqDeBlk29ORiPe6Z7r28CRQ8H0IHQWZvnkGA8asbD7DLfRCuGXxbNiZ5f2H/I2hBvrpebYiAXUYowOmfY+sidP3upk3Ec/KT/niEsK1xBXxmjpne3YYPk6qqiqCklxMkh40aiT5ksxdvvbPAr+XchE03T1hTiVIkkEfjMb0AH13eYATUeit5FaVh6+TazhkmXuJ6T+Pz9DEaqGWeie3EwaeyTCdT5DeaIlDhz8z57ZHP3gUl41ZUgbul954VXDA536gCDRlY0zBJhMa3WltN9l5R1fXJUcWsNNPr7CUYgZfwhV8xHe4jbmWlF1KPyVR4mtExC/cgdYEaKTNVHFyHWMnTtDMeG4JN6/4bUy5QQHEqUyFRAS2FECUcf74r+Vw1bq4GhMH0Hr
 lFX96ifm
 i1OiyDLQ6/MLLGZTDLf3NyRJ1Qf2vUqtAOA78ckcxXYhrK7Wp3UEmbjugT1uqrSQiapLEDl99gRJIOD/865sE1A4eTdtK5RzkcUy+4U0tZPRYwWoW4eID+b1iydOD0xdNz/Tl2VWNvsFOCBAVpdpBJsmO94ym10aBf7+X0Dz8HzMgMwp/a/T8/hmltFXttUsnJP5kCBDvaq9apR2G9qlASAXNWK4YxI74K0Un2NEOuFeXq178HAKyQ9nGDj+17zY00EOYR7tDhPryVhMJRbjimKTo+lidIc2FKN+ZzDYjAbD4KNjVeEsF2S4a41kDy7MkZcyVGqi/LNNIk5N+0RKNTlF08ek960JSpD/q9rpp7ycCypGlgaZqw8lgZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 06:16:54PM +0100, Matthew Wilcox wrote:
> I think I'm going to have to change how we track hwpoison in hugetlb
> in order to make this work.  Let me think out loud here:
> 
> is_page_hwpoison() can be called without a reference on the folio
> containing the page.  The answer can be wrong in this case, but any
> UAF must be benign.
> 
> Grabbing the mf_mutex inside hugetlb_page_hwpoison() is insufficient
> because we can't protect against folio_clear_hugetlb_hwpoison() (the
> approach attempted in this patch).
> 
> We could add a spinlock for protecting freeing & checking of the list.
> That's probably simplest.
> 
> It'd be better to protect the list with RCU.  But then we'd need to
> put an RCU head inside raw_hwp_page, doubling its size from 2 pointers
> to 4.
> 
> We could completely change how we do this; instead of having an llist,
> we could have an array of 32-bit page indices.  Reallocate it when we
> run out, doubling its size each time, and put an rcu head in that.
> That'd give us 32-bytes the first time, space for 4 indices, then double
> to 64 (space for 12 indices), double again to 128 (28 indices), etc.
> 
> We could also RCU-free the folio if it's hwpoisoned.  We'd need to
> clear the hugetlb flag before asking RCU to cover up this problem
> to ensure that any reader that saw the hugetlb flag set started its
> grace period before.
> 
> Probably all too much trouble.  I think I'll add a global spinlock.

Sashiko pointed out this doesn't work either (ok, I was reading between
the lines a bit here).

Since we don't have a refcount on the folio, it can be freed at any
time, and the hwpoison list head can be reused for literally anything.
Even if we then recheck that the folio is still hugetlb once we've got
the spinlock, it might have been transformed back to being a hugetlb
folio after we loaded garbage from the list head.

So, complete rework.  Instead of storing the poisoned pages in a list
hanging off the folio, keep a global hashtable.  Patch series coming
soon.

