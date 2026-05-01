Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBF16CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 16:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E16086B0005; Fri,  1 May 2026 12:06:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC70F6B008A; Fri,  1 May 2026 12:06:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDCF46B008C; Fri,  1 May 2026 12:06:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BBFA36B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 12:06:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DEF71A01C3
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:06:17 +0000 (UTC)
X-FDA: 84719327994.14.3715DB7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 140974001A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:06:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WFSklIdw;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777651575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCOnYxAIgiWvR0Bg9Z3oQP7NtLB+AbBygf9mhxuV9oQ=;
	b=ziNzqxef/pInJVfEzqX9vGnhpFtfsZKCWXKjn9IjPFyvfguhsdlz1kQRsKGnMcEKxQW+b4
	AjEgR7p9LIr0oyqqQ9iMvCwp9qk8mjXh6pkOg9vKndclTfgCBQBFfmzo82Hmzfq6JHLUBR
	xSjYT7LQ8g9CxeqHYxSerRIr3i07iZ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777651575; a=rsa-sha256;
	cv=none;
	b=4b4HCdpePlLCoRc3l12rhVvkwGA9XfzmvAlOhKDn2BcCkTngkgiqrmECrT2No0huEJv39K
	nj9LB0OMiGN9rY8Au8kAXJLZ1xC4Ggmiq4ofjXikqNI4AnhTxru1VbGtFgevmOIiNYGmhR
	lAcJ0dNdeQmixMxKPA+WIvPj22ry5EI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WFSklIdw;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HCOnYxAIgiWvR0Bg9Z3oQP7NtLB+AbBygf9mhxuV9oQ=; b=WFSklIdwMHQLNKo0hSt8FUEdor
	8PWAceSimwETsGI72z85Zv4wA/tsNlycLa8f6sQG/Aw6w8RnhXi0Af5mjum18LwybDyAvb1+Uxh9f
	Eq5T7ug+O10pWFjftTfOmniisY01PyMq7+2peSvdamJ+AAvHZRIQTazUoIUXsplGALDIdW/42jR8p
	U9uUO/7PltvaGp/EEhx55GmxP2PijjP4N8jL7/SdhnE0m0apJTc1yrnAE6WrXuehMZUnK54FJ0YvF
	M5qMff6H54NLzO+TN+U51R/JiQDmY0k5rW4FXREurwavyb9AebilT1ieN2HbK2yQvGHgLvA2FHU0e
	rgYRe6xw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wIqNP-000000091GR-0gTr;
	Fri, 01 May 2026 16:06:03 +0000
Date: Fri, 1 May 2026 17:06:02 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
	linux-mm@kvack.org, david@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, jack@suse.cz, pfalcato@suse.de,
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com,
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <afTPamwDbtY_tgk_@casper.infradead.org>
References: <20260430040427.4672-1-baohua@kernel.org>
 <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <afTKsSj0i-ZkRZN5@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afTKsSj0i-ZkRZN5@lucifer>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 140974001A
X-Stat-Signature: qcwchazmqjfoz9h8txbj3x4ztez9pif8
X-Rspam-User: 
X-HE-Tag: 1777651574-265220
X-HE-Meta: U2FsdGVkX1/WkxHNtHEYFKBnZtQkPKrXVVMidJaGnN3QLfhi6QDMcfJ/qBfMgLXP6ZjtIlzdBdyCrcvxD62eRPm7KxNqFtSKBmBTOKMydJ32p/Ior14VP4U2SXdI1lFESl/N9Eon8WG48XT1FwBU+YKarhJEP/drDV/PBQl5qkbaMEzP7+oYcKuuM2gmxXtv6XfOEmfGYz6VW6th1ft46qoR6MwD8AAxJqQxqBH0eHIphvamzKDMSVWsvnrFpMYo5pwdhV5AyZBzue65gZyCbCLTe/JtQHF6aLM+yYBURjAT6EN2r1TW/mK4R+2QKDtA5zoYgqmepnHJScoOfwlGFEqPhDAvL55JG2RInx+xGsAk9rTmsfT9Ovrq+gPQym3VMK+380fhhL70OEvGhjaN+QIdOTFhcD3KTQpViQU49Eog66U627bCSRgjTr/0dtJOP7KD2JoPZr5uKEldRahe/BhX3FAFDEjWx5OX79ttEiVzF9v/j3KaskNnN3uw9Ru99IwuDV/m3dW2oeBIgnqgEtL9Md6aIz/mYXLQQMMy77524SIDul8ot1CIYXrXn07VdyxROyIU0Oj4XTrYivCrE91/tEgItJb89C0/A863A1shBXKJNFeyyARE9xpEmyB9KtcnSXFXAlXoMfUWQwK358TbvQzHuVAkrqXuqL3pmYveRCto+r8+j4auMmOlGdTbrMSZdPAwnW0S8nqBFJDHk9Nh7l/NytBDikvCHoelwxm7aYUgrH5U9npGkHkxKfL9hZz+aaq5liGjQjwE64xUP4JJh/8Rq7HrpbNSSeoH485U7i0VyboZsrAB1JNehIqe0L4fW/IJlk3Cc5ukvyXMRR1qwdWR5PeLTZL55YSt/rvHBKhN9TJhZq7AekVxPamf6kMV3E4rLdybpYd5r7FM0rHvmNYCp27PWeF0975ep3nVcYQl0oA/HkKOKRAEZTaSpKddudkXDFmHGyj7t0G
 wi3q74Nt
 uqMCI2dhG0uBw1hdL8q0ePYnA0hLgXPZIUQbRv3GAX6D5ZPAW7bzDf7vYYEC4bdwPFHt+uzNOp5dSg7Gx3ivVs0KeKSMuuYhxyHGQ4nCtf2C72k6us0vrN6q69Wbg0aL3ppGC/jukqyQ3/2JhhytX7BcS7rGX7B3o7KxarGiV5h5fkQ4Z/Wkfbynp2rFv8nYHoM7ev4A3qrFTZ1gzYNajE71n4D3+xGUHo8tl6j2iiCf4Ulsictj0LU28qYkWLuwFxEGo6wmUFGmR20qHU4K2sE4FuepzUBWCF/tMAVRTa3CJ77kKTe3q3aMnIduq2AY6T+rmhoM9zZivTy1AZH7DfgvLV1j4geAhcC+ghvFMuAUH3qN7namLYSVtcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01, 2026 at 04:52:12PM +0100, Lorenzo Stoakes wrote:
> After a brief eyeball I share Matthew's assessment, I really don't like this
> series, it's piling on complexity for what seem like niche cases.

I don't think they're niche cases ... I think it's a real problem.
While our current code performs better for this workload than the
pre-vma-lock code did, it doesn't perform as well as it could.

> We already have enough weirdness in fault code honestly.
> 
> Let's maybe discuss at LSF if you're attending?

Not only is he attending, there's a topic scheduled (currently 10:30 on
Wednesday).

