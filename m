Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE05AC55182
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 04:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6193E6B0095; Wed,  5 Aug 2026 00:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C96D6B0096; Wed,  5 Aug 2026 00:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BC306B0098; Wed,  5 Aug 2026 00:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2ABF46B0095
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 00:00:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83065A0390
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:00:44 +0000 (UTC)
X-FDA: 85065864408.18.6E5EA55
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6D065A0013
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:00:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tU77d7C2;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785902443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0hhcN6fw6oAmRl5W71ZCi2rBApMIiJvica+dmVXD0F0=;
	b=LqQKYvTO3J4CW/KcMMmfxkBYCZ6IMfH94TKngyUAqffpGlC3uQyxcdzib4xsFlvokyEglh
	+BDZRyuhGvEX2pkdlQyOjmJjTa5NRL1d3sP+VPUZuP0mkEMjAJX9f7D49hI4kW07xp3r/8
	olCYrqSptgu7lSqYjQ1X6zaG0+zbi2I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785902443;
	b=d6rAwEDwPVfM/n9aHShTOdnuWBoV5QraYb68RUDnjUfVmhWwfxPV71oQTT+40CDpEAhCrA
	ydEYygzeFCP0lQAe97tMqCP8fphUg7OPKKW2v0jGaLPg9YKT1A2K4KihJyDUaMWOBtw94w
	blUR3AKYpviGUbnoFSOp60ezwzaTgyQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tU77d7C2;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0hhcN6fw6oAmRl5W71ZCi2rBApMIiJvica+dmVXD0F0=; b=tU77d7C27ycHl1FYQZi4KMTMbM
	dHzDRHojIkVHY1kKyBsuehAAUTSx+WOPekxb6uBus26/BG9RRdGCPwL3UM+DkuEf9z33JNb+vjIzj
	mlbHdunt13yV6EnA4BR4GvOM3lK4y6+n5EpOiZht4rf0Zt4Y4SFrMUfqKlYRGzf+oDbHwSEK5CNpT
	SD4dUaYxIyYOTXEsVHeTJ3o60h1bo4Bgcew8GyjegTngN5tM/OGcyc2G2fp6ajmbB1OjjcThF6k/v
	P8kLmJg/rQLKsyATDK44vJ6aY9Odq7/w/mxRoo66LqAuxzlXKVVbUbIxrhgDA7KQBl3IP7xKOBbW9
	8mD/FW0w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrSJI-00000008QnE-0xZL;
	Wed, 05 Aug 2026 03:29:00 +0000
Date: Wed, 5 Aug 2026 04:28:50 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v8 12/15] filemap: Remove checks in
 mapping_set_folio_order_range()
Message-ID: <anKt8joV7HtZ3Tks@casper.infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-13-willy@infradead.org>
 <anJYKOiKFoqLSTTo@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anJYKOiKFoqLSTTo@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6D065A0013
X-Stat-Signature: hget8iyd9tomewsireopbhnaw6ktzd6k
X-Rspam-User: 
X-HE-Tag: 1785902441-896472
X-HE-Meta: U2FsdGVkX18/Fttr5mPoWa33L/p6a16OKVBnUvPBEgSDHAImRJoMAMS5BvcyVUFIRDVgaqHB8WT0emN+TCu8bma7mNbYlV0SBSarf5jessaWL3eq39ghbu5/u1lfX58buoBBwXC8KrRx9MrRvyNs2WUKsQw2tFkj2Q6PDGH6GKyIgdS8RhILys/VPIR6213py8XtsYq5isxn6AKxpM+H5TM35w54b9sTXIBktH/v7G77iHvPwYvoBMn4D8BBYg80SAx5XvFGT71lDFjyBJsTwFAgdIp3dO5WwRQwBJs5uj3/j1tKWs5f26touqSzj+t9cfqxrgriasOGO1icthaxmWe1U1eVIUQR2U2+HrLsr7Ljs7FvHzQpTbY28lMtortU1IWLzgEkCuElMKag3d8oXjcc9xeOAhCzHnD+HWaHH4mAJdRNn1YqFVwdCYSRaXnTH94++9iUGX8pgfXAfJRXxSLNQ/tJw2qjRK4EKmR/S2CyQ5BZ/aviH+TSvu4xSbNZX5OmZ2KV2K3bihFB4HPduDUzaxnGrt8PchZlIQAjSkffFWmT0/4LLWHW3vtSV6QuArL3XKUuDDIvzfC+4MghzXouLDy159HqStKVKRwkL9OPCM631WeQ+RybvloSsSaQnJN3S0HiPhhRpGfrqFneVlq4CNqfRL/m/98d0y6m17oXTbNGwfgpyf8dIeauWNoGFu+YTnYX2I+FBYHJR5ttAkP50FRJVjP1/g3+gtmsMHaBpzffNjMSIcpgQ6wL9sR6U+aFPHr6ErJyOLbnzLXmL4hBHWZwvxgg4Pc2cmdysxakxCWDXALqJyVIyicbiYal8ucDNlwqKwEY3ofkE/lall/9jBGtsFLteo9ZV9gq0GiMymbux/vxft7zqey332p2T4pPZHnu/IRBorvw0RRLdHOjoYPUIUZiTduzE4R2ui2ARRUwJOwtQQ9a/0AweAKflJZeB9eEwwUqSqim7hq
 SzZO7Uda
 7SXxdLFNBoCsgr+QN02MJaNjzkdwPKFymQK7lIDI0F3aF6Nez8o/ZdUh4OihI1MSwmh22ypve71kmvR8WHYWolmQUsjmKN2ZsvqUjKi5YhTjDktwpV6QH1gBxc2hizw8Os5YGapn88lLFjwfV8tL0TQmM5Go6jaxwtTL5jqwK3PcYf/H/FvgBSbtxhHcg53V+hD3tGLL7nzimnbQBxM0FnI1F0bozlpVRNTXYrFwBYjFj/sf4Y7V/Ulz+2epTEQdqp7pjOEBEikXDvP3rhTEWrVUzdptEzx+gll839xH2PWYH6O3muYhN8Ljv1uzwH8ILb9eKJJ2dPIfXMIHfnUA42JYpqbVuQEeZW7Hwi8JIAIPkUUNpZJlylsAvaZNG4P8lflKOwFKAGZUYwrSwfF3HHp++dGkEyYhEj2yjB+NdlJw9Q38=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 05:23:27PM -0400, Gregory Price wrote:
> On Fri, Jul 31, 2026 at 09:07:57PM +0100, Matthew Wilcox (Oracle) wrote:
> >   *
> > + * hugetlb calls this with orders larger than MAX_PAGECACHE_ORDER.
> > + * Normal filesystems should not do this.
> 
> Any static way to enforce this?

Not easily.  We could look at mapping->a_ops and compare them to
hugetlbfs_aops, but this seems like overkill?  For such a low-level
interface with so few callers, I think the level of protection we had
earlier was just too much.

> Otherwise
> 
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> 

