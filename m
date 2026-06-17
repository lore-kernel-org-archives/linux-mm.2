Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66215CD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 02:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 521576B00AA; Tue, 16 Jun 2026 22:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9B06B00AB; Tue, 16 Jun 2026 22:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436706B00AC; Tue, 16 Jun 2026 22:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A0F66B00AA
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:18:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8086512027F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:18:42 +0000 (UTC)
X-FDA: 84887796084.15.CF60AE0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 67C8840004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:18:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Np3vjqjt;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781662720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HkKhP5dgWoNLgZ860E6q6vUvnofK+KTQ8ZVRLSCljDg=;
	b=Pb+qKt27qVmswKsg0t9hsCFJ2/FhgztekjIDZKenEOEeCr6CSqDdkf2vqaFz4o4zD+T3iy
	QHtLpmwDuvBJl35qU4us0Dwcpu3d1FRutc3W9Be5NkQOoT7oj7uRNU/83A+5clN1wyjsL0
	aPR8rym+jVK93yKGEhC/PcS7LF37LTk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Np3vjqjt;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781662720;
	b=3f3qX9/rdxojqkPWW/8nreSBOo8qgqzgF5aspldt9dweGJ+i+YX4JxxpovLcsp2wVJ/MXq
	Ou4BWhooyT2uDDvroXh6BPKV/8QpjfZBbiCEa3A2JCwW6VPkjY2jUesGn/PWWDqN7NzEJX
	QiAy6T8zfUgyXBsYRumkFPZwRhEcjMI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=HkKhP5dgWoNLgZ860E6q6vUvnofK+KTQ8ZVRLSCljDg=; b=Np3vjqjtw2ZLTul/KSyGkcjLMC
	yV3inZ0BaexoioE7KKqggbpP0jSnISe4DKocTaDxWbA0Zg7RpezmPTR+X9MkMTMpSjamVK1NWpYb+
	IXvQ2Bv+d0lSMoQGo3SvNaWSg1orzuJTFWPWGKNxGFQHcVlhrPFndCU9TEa3DB/TJmYrXbGZ6lMiH
	HfAMmvhNCj43jlk42OKqiBSoLvOfrjYoQRCCbYFouV2Lx9sRtuM2rX6GzhKt/6sCumYIhXft+yQbM
	/TJOsjZJd4JbNazOTxP6enqku9/9bZswCkSM4Ppz7fS/X5ZJYjkgP1CJDp65mQX05Fbbq35TB0gos
	Jm2bPXUQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZfrB-0000000BpkM-3YpQ;
	Wed, 17 Jun 2026 02:18:22 +0000
Date: Wed, 17 Jun 2026 03:18:21 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Rik van Riel <riel@surriel.com>, ziy@nvidia.com,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Hugh Dickins <hughd@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: khugepaged: free xarray nodes left behind by failed
 collapse_file()
Message-ID: <ajID7ZpnBYOucAVz@casper.infradead.org>
References: <20260616145413.1491961-1-riel@surriel.com>
 <ajFrxhGf7loEHUeX@casper.infradead.org>
 <8a4caadc-f414-4874-97d4-2fbaebe2af39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a4caadc-f414-4874-97d4-2fbaebe2af39@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 67C8840004
X-Stat-Signature: jrggsr8qa9hy9ur4k5wbda6qp4k7r7k7
X-HE-Tag: 1781662720-218564
X-HE-Meta: U2FsdGVkX196GYYC5lVHVkju6rE6TSe3xWybprMLj/SBh3Zknj2KS2WOejZ5tQL9KdIa7VmxiSN+d5w0kCcYgb3gTRU0LQRSaW6kV8xpfEibfJBSgENgYRQvWagtqgMj56D53+XahW3iciFTrP471IpvTofIXQdULEsHxgh/ZGEVmdagvb+R1FjzSpfnGkTAsx9gM2IIglU2+CWhDc5rJQqLhZQiIadzKjsZlsBvC7148CCUwFKU5F2QcEO756e4LdFfODoMgwpmQio6liG0C8e0onYZ3FlHn5jMW6ulONQmGs18F1dH4lvGE+B0Is+XaL77CuXlOK4JsVNm2z+XOnNUILj+Wc0BcXgLQMjBkZb3lpjefY1E5x2BYT3FxJZtW+OJaZqrSBwMpu9LLakq6c56+H0CwFF34jeFddqV51syU3zMHEUzDqMizIZgXjmlLRdb6OccU/Jd/kMrrX1K4E4isBzsnOrqmziW4emeHWau0MDrHvpizlb0tW+zX0abwKmaseWOrYR+XNHHP6ExSTknXEMhIePx+LjgQUgeNejtxefMHKmMyuhZQKf3e/KMjGArq9r8KFwZVDPyGVgc0AFI9cF3T3nFUGIF15i5qw/bwojytiTbx3dgpkfz5okfrF99zHD/eq96Gb/KqkVkeN/XZtdxwD2I23zQYglcC7OcMaPx9g77QKrkGEv39OJsF3i89lukyK9T4AZ6+2cxm+k0xSVVWlbS50qf2GulAmV0BHO9rbeeNqeS6SSAk3citKSHRY615+q/Jryr73HPQ8A6zHNcmWtQgLENj61oWPjy2nIxFiFsokRa+L/1mNA91iULVBLpvhtN0Ay4CY/CzVQJeYjfO+v96jDO0jQ7KuihomtrK8Pksu/6lPPDGRMweMbC0N5PFpAUnJkTuzle8ZBvdJPyvPg+kxOMG3PNVg5aWAbC6hXhHjKS1GydzOXx9N9YbGAOr6PLxBz1EgU
 omHOJ12y
 nQLMu5f5Vdtd7xlMOOU3bgCPnvPoJDmNZrmuZpk5c45MsBBOE3HnDnilhDg/okQhH4W6YDdfXJCoUK218ReTfZyodRknj7eIpviz2baJh3Sf/z0BzyFa2UFCzzVIP9uJKn6jK4urxJG7hNSJfucowz45hfSbd3SGbd7ZOeRc7N2Lr6BVYUq0fDKIin59fPlXpQqmaN7W9V+I/cwlYjo3iT3i04521jqHoWswGEy89TIW7rQiwKbGiZX3MrPiTcdvyGkZoxs3jrOtLXNZWjCob+ZBOPKcMVAtgrltKIzePlpNQ2XI83abL/Zk36pW+AKAibj6OKhsmcPA18oHGvqwZTRg8Nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 10:00:59AM +0800, Jinjiang Tu wrote:
> 
> 在 2026/6/16 23:29, Matthew Wilcox 写道:
> > On Tue, Jun 16, 2026 at 10:54:13AM -0400, Rik van Riel wrote:
> > > syzkaller reproduces it trivially with MADV_COLLAPSE on a sparse shmem
> > > mapping (collapse aborts with SCAN_TRUNCATED because the range is empty),
> > > and also via slab fault injection, which forces xas_create_range() down
> > > the xas_nomem() path before the same abort.  kmemleak then reports the
> > > 576-byte struct xa_node objects allocated in xas_alloc()/xas_nomem().
> > I think the ways to produce this problem are sufficiently rare/unlikely
> 
> I can reproduce it easily with following steps. [1]
> 1) create file /tmp/test_madvise_collapse and ftruncate to 4MB size, and
> then mmap the file
> 2) memset for the first 2MB
> 3) madvise(MADV_COLLAPSE) for the second 2MB
> 4) unlink the file

Yes, but is there a problem?  That is, do we need to clear this up
before we get to clear_inode()?

