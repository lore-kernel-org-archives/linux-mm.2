Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00BF7CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 05:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC45F6B008C; Wed, 13 May 2026 01:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74C86B0092; Wed, 13 May 2026 01:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB1E36B0093; Wed, 13 May 2026 01:21:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9DB326B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:21:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F3CF1C0600
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:21:29 +0000 (UTC)
X-FDA: 84761248698.01.4DC608B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3DB161C0007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:21:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=LYp47UHn;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf18.hostedemail.com: domain of BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778649687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+nq8dgADBoiyTyjYHwy7GvXLat+nsmv3RDJEo3Azbg=;
	b=G9nV733qAuKHr3lq4/bNQROc9CE1j4X/OxBnSEwfDLZ77dTXYCeqQCH5bB0AtwY2UMp/cS
	pSdB3tFn0Rqe6Izt5fbSMbca9tqeVT4oSaNKW+FdVmq/Jtwm1LhItNJqPPbTKy2PophrSe
	d5oHzOAkzpXCWJFrHmwhS8WB2VfwfVQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778649687; a=rsa-sha256;
	cv=none;
	b=tvoC9/OVFzBKN0zclYrTNejM8Y9SODT+y8GbVswHoCUytelO/04KwpIkdmNea7UNKM5k1z
	33mi58P7l7SAbigzMZPPHm8IrkdrsEEQhB60XXYlsyfKwUYiksuZE01RsAR7bFXkFL6Ccu
	w02pO7ym3UIL1xEoc8PS748vmPo5Yc0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=LYp47UHn;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf18.hostedemail.com: domain of BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=k+nq8dgADBoiyTyjYHwy7GvXLat+nsmv3RDJEo3Azbg=; b=LYp47UHnu/NV0LA7wdv5Edu8J1
	UVwUlULFSOySubGo2P8zx/2xe76V8zC4COHwh39gZEHd4xLVObGAyRsuXRwzuPadozuEvrJZrthqJ
	HvE3do0/oK0oCSW1R8z7Zw25AYS4IM6j+O74slVDJfOjdVPQeOhZlw0ZRD6VX5WZJUR05/XigSMtf
	B5qKvIiGOsqOi7Dooqt5NGFb0zt4J0rvQqUCt7VyAVbsOc6rs9BSnzaowd3rwHLq3Kp7jrrGnJB+F
	CBAHfRiXCzTelmpBCCLNUPf4jTXT7/OPbv4WY/bw6cEIaIJge9GBg39N4dBXNH3MFbWxRBQU/8WZk
	nwyc7Jhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wN21z-00000001J2I-1vTY;
	Wed, 13 May 2026 05:21:15 +0000
Date: Tue, 12 May 2026 22:21:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, baohua@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
Message-ID: <agQKS17GVeAxXYHG@infradead.org>
References: <20260512104201.716213-1-baoquan.he@linux.dev>
 <20260512104201.716213-2-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512104201.716213-2-baoquan.he@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3DB161C0007
X-Stat-Signature: 54t6wxdey8798uj47tacm14im4cgs86r
X-Rspam-User: 
X-HE-Tag: 1778649686-684596
X-HE-Meta: U2FsdGVkX19dHXPX+Wuj5U8g7xX2LVVuiEqzsz362ax0vjdSXVfC6EAVGg2eh6rfHb2n7QWJJIOoOG1RX4uICqhw5MyRtYB6M68jxKGJe6Xyn1lzi4b/X5ohTQN+WBjtFk4Z7sORBtqM5Zyon/kx0cYo4FuXZosgsvYj0j8cKBtBxuJWLnacl+miqXvglbD3lulljcAwZNIJYrc7mV+khWEQJZEkMed5naX8QNBDRPsJSv/mnuz2J6ALYrw1b28Em0nUynirY4Moy/O3kxndx8c8x6+LLgHd9bX/A2RPK9ZSfN+UPP0tE/wozugRGWDdRcIddZT26VmdMEy6dIsEznqFsg/HjhWky9uoyJ0MNXthQe9OmyZm7c59vBqJzpXKiVMiD2qKlRBrX9xMXzQPpZ/ZBZ6LZuWhx56ZhcVyo19SGVLss2p3Rgy3YTAKrklQYeP9eLNuExXGjLtzk4Amw5WCSHo4lvsWjbctU/DCk3N7nEiHdl1a+tH6ejA9yNB5We0xWhRkMsyLfhai+S76hr7UJeaUfNYo+6c7nVMu8acv1EniyAG6emwA76C07FMMGGcaO4uFhVSUHCbiwcZjY8zk//VlQ9rwO/Emr7xaHh202agN7h99VQ0My6BeQFg0NV+eju11uNytSURJ03oiSGvodEVhKB/vkBAUsFbMN8//H/44vSUYNXKqqDaRnvdPmYHM9ZGmkHpbyjq7xJLNIsC8lVG9L40tKBbsPXMr0YUzvzP4ryhrSNBhvxK/C/KSHGV4o2nEMRMpHGCErNlHt2c14wQAQY61PKTSJzIrxVwJzC0/H/lCFHXq/8NY71NeJQOyeFLYV9S/hQ+yzP1hzO+CbWwVmjRe8sMrIVc+nwnMe58rKl8eT3X3IuAetyY3Iawbmkh4tVKBpRuRaFPYB9DlLAaznUElxyNrgq71mL6ij5JW6MnEVd2KQGcXbij/qSNdlVYBfC5cg/q46wR
 fUzSGfoS
 0b2Rny1YdsbOJWgQM/Mlr9QcjJiyGXW/kKK+x8HmZTD9nQA6G7JS6mltWn3X/kgKDy3zFxqOmGoQ8GvmN8E1XyirRuRsKJ/iRbSH3LyfCkq9qO3VKc6TrIhwhxKhE+7+W7HJFJ21aaSH/7r0xsPAAAJ1u9/ZC5EJ5Fi4cEF8wu6H8GWUhGtBu9EHk+srrlBWCgu09yZBTsqxX903esa/4T4jT8gmOeX4dw2KyZLuC+pgG39JRgHSQs/uSpuCAyDJNS6MYMTTYECXUbQ8ap+y7aTK03GW0LSz6w94Gbtm6tkG3wXb7MuIvj+eDN2qM4/wPkIpmu/6ZV3sXCK61G93c7U9r/V//8bPllCcNIShZc/e+hYhrGOZCUwI3W1UpZ8Cdzm+l2GBd0nBV2mFLraoQVjBsME8Uw9KEkXLiDpxsgwz4GaphlY1+IOQ6KrKuVWAnnNidIVAv0LA4f7NXfO2G3ohjsy20DeJvo+nuIt5trcP1eErTkx6XnQ1fot46z/lcPt2q4uv9rL9Izna2/hPWlVBIzhR0VufrzIZ1dHtpZKDhiwo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 06:41:59PM +0800, Baoquan He wrote:
> Codes in mm/page_io.c are only related to swap io, it has
> nothing to do with other page io.

That is true.  At the same time it also (mostly) isn't about all swap
I/O, but specifically about the block based I/O backend for swap, and
secondarily a little bit about helpers for the swsusp I/O to the swap
file, with a little bit generic swap I/O wrappers thrown in.

So the new new isn't grest either.  And I'd rather wait with this until
we can nicely split stuff out - the rest of this series is a good step
toward that, and my swap_activate series is another.  After that we
should be able to stop creating swap_extent structures for
SWP_FS_OPS-based I/O, and contain struct swap_extent with the bio code
and actually create a coherent abstraction.  This will require moving
a bit more code around, though.  My preference for the resulting name
would be swap-block.c or swap-bio.c, but that's up for future
discussion.

Can we just skip this for now?

