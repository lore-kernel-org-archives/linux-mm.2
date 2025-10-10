Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 269C1CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 02:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E5978E000A; Thu,  9 Oct 2025 22:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698318E0002; Thu,  9 Oct 2025 22:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3868E000A; Thu,  9 Oct 2025 22:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BEFA8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 22:40:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D29421A013C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:40:10 +0000 (UTC)
X-FDA: 83980650180.28.713F78F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 875021C0016
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:40:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=v2KuPb7+
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760064009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nEgPiwNZqJY/+pI9FIhkXYcYvcHnRfvZ3w5CnVMM8Q=;
	b=C6FuvwP4Rcos5SNQ0gQkiKX2YEcy7l84Pdog/lbfm3n5p46hd5gr1AENwHLao0CX5YWa27
	T87hYf6XvdxFIKp+GeD/W2AWnpfLExBYEuCKMa02fIi/e0xGeidKsyqTicInImbdI4Rg7v
	wvTyFEyQg+uXpI8JueqoYHXdDvhEzU4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=v2KuPb7+;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760064009; a=rsa-sha256;
	cv=none;
	b=LgIGmPr6rZjvncZszoEMuzSVzZjW7W0e87ylahUmLJ0opdAp5pUz/SNKl/J9/U0sAFZ7Gd
	dq7WR2PwPSvy6LAwdKO101uclzsjVEhC0DaL9iCvG2A8hZwmVe5wHo63emIGopliwkJvYP
	UNFMWpmIiJ8AP8Jouew6smhH9h6EBZw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5nEgPiwNZqJY/+pI9FIhkXYcYvcHnRfvZ3w5CnVMM8Q=; b=v2KuPb7+X3CquJ8kc7LUjH9LyU
	lXhmAD0NZIy8B9cVZIjPqtRCU/mTL197+QHuEWB+JvZi2dHdt8x+oVEoohFVJ/5/bofowuOY8cw1+
	W34mQIV8jcJfn7f+m/Le//QjkQPy8/PTr/EH9kIbgc34HGov9DcIe1eG1s+6P0btLYxQ8YZcmk7UI
	CpP7lSE3KDiwpMZo11L++VW+5WIapejtvBwxr8R5ZrvfooDPB3H0NRJmmcxHYoeiCiHwvFL4jJ/V+
	w3dCKWfggOWZqSlGPX4XpmPp85/yLo1n6Gd3tA62nu50W5JHRYbTv6ucOwQ847lT4yro+jr1hgrmG
	YWdN3oBA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v732r-00000002Scf-3b0v;
	Fri, 10 Oct 2025 02:39:49 +0000
Date: Fri, 10 Oct 2025 03:39:49 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, alexandru.elisei@arm.com,
	peterx@redhat.com, sj@kernel.org, rppt@kernel.org, mhocko@suse.com,
	corbet@lwn.net, axboe@kernel.dk, viro@zeniv.linux.org.uk,
	brauner@kernel.org, hch@infradead.org, jack@suse.cz,
	m.szyprowski@samsung.com, robin.murphy@arm.com, hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	minchan@kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, iommu@lists.linux.dev,
	Minchan Kim <minchan@google.com>
Subject: Re: [PATCH 1/8] mm: implement cleancache
Message-ID: <aOhx9Zj1a6feN8wC@casper.infradead.org>
References: <20251010011951.2136980-1-surenb@google.com>
 <20251010011951.2136980-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010011951.2136980-2-surenb@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 875021C0016
X-Stat-Signature: xrtxnn86wkhajnrehffw7bps4u481hhb
X-Rspam-User: 
X-HE-Tag: 1760064008-33375
X-HE-Meta: U2FsdGVkX19kY2IloNUZeQUXddT4Y5H8ortvNpsnvBqCA1d54N67PiD5rVPc2DyEO/o0F/M1E1oqxL6WwMM1OTdGK3L+PAL08WBcFTztT+UbGV4Y0vOnV3RVjbDD4qaK+DFlk9Zm/uiOTDGHyjKtKeBWhseSq62vgh6fQOClFR5P1Hr4hoRcd+2MV7d46uxWjyDLif/bwv6gUWe/84Vxoh4LFAfgdnAltwjmYeZTV9nEremBnjfT0/+GLfgggLghVxI8W5e7fvJMpn+d9FYvjHUhmvvGlhI1l4wIljb9e4K3jL0CxNzTFCe5GWSeIHoIRvEDsWZ1B+CCxnC5Y6Gd5y8e4YngCynr3Gs3ZHwHR1XT2yj8AeKTSh/Xdu54R9qeIwSmwtR4RiXVcFoYaWYsY/QH7WpwrHxcVS1EC9tVaboumQ6w1dklyAwTEbBwD/8GI0hD0umxjL8JuJiNFTCB9KsBMj2bfXezYfb3OVKTdKCyFRvIUgXWKGV+g79lJtKyIy6VCIpzcXA9i2OOfTzbiz7hPQeooA+B3KRYRiNhME5rusX1P9tR4M9M0P4PkwGemE9cjDMGDpwJYV0jeB1huV12ygZxu24JugH8zF0B9Uew78bidOgCOMzL7NGLzS9v+0OG98hLiv0gPcmYsT0YGztGe1/N5tUxXatS09kcFF8j3eZG46/4TNW9ppmq+cmA6D0XRdPgMDedLYRLvpdXkj6bdfXhCRYSqLzhfRNZp5bIUjSn9iLGlQ4Nxc6kHawAfNQWAodqHu/X22hW0h7vZtdqy5Mjloishe9bYc4e4RMm0jY8K6omeggWihI6R1JqrJjZ1m081Ro7uxaGxfD+bfONRyRHBesO5xCuJeGE8R85AiRl0GuqQg9aNeUZh9YTnCHXfkloaB9hKDS8MdJO5iQmP48C/RnWIOe5fRpIS0HwNBlWpCz19OYOFtDDAa+VhBBhz6NDs+nh6M72FJW
 ZIsLRiUY
 LTangsJj22lq+6FuKulYLOTTiJQdlubPQbAGcutQWXGMbKbLxTiRoRcYFprnAKx/j4kDkOhi3oNEaxxr/D8Olvh/TqM49fUIsFFpUbzhryzTXHAnJKbAgz3UQncrLnmwyLrnwDwuPFZ/vITKzM8vJuU+ahcfUqXzmKI4fomKaCPeBeWo478JpbLPU6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 06:19:44PM -0700, Suren Baghdasaryan wrote:
> +	/*
> +	 * 99% of the time, we don't need to flush the cleancache on the bdev.
> +	 * But, for the strange corners, lets be cautious
> +	 */
> +	cleancache_invalidate_inode(mapping, mapping->host);

Why do we need to pass in both address_space and inode?

> +/*
> + * Backend API
> + *
> + * Cleancache does not touch page reference. Page refcount should be 1 when
> + * page is placed or returned into cleancache and pages obtained from
> + * cleancache will also have their refcount at 1.

I don't like these references to page refcount.  Surely you mean folio
refcount?

> +	help
> +	  Cleancache can be thought of as a page-granularity victim cache
> +	  for clean pages that the kernel's pageframe replacement algorithm
> +	  (PFRA) would like to keep around, but can't since there isn't enough

PFRA seems to be an acronym you've just made up.  Why?

> +struct cleancache_inode {
> +	struct inode *inode;
> +	struct hlist_node hash;
> +	refcount_t ref_count;
> +	struct xarray folios; /* protected by folios.xa_lock */

This is a pointless comment.  All xarrays are protected by their own
xa_lock.

> +static DEFINE_IDR(fs_idr);

No.  The IDR is deprecated.  Use an allocating XArray.

> +/*
> + * Folio attributes:
> + *	folio->_mapcount - pool_id
> + *	folio->mapping - ccinode reference or NULL if folio is unused
> + *	folio->index - file offset

No.  Don't reuse fields for something entirely different.  Put a
properly named field in the union.

> +static void folio_attachment(struct folio *folio, struct cleancache_inode **ccinode,

Unnecessarily long line


