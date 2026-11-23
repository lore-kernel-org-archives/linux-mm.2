Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC9D606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 20:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=SieKh/wJ
Received: by kanga.kvack.org (Postfix)
	id 99C6D6B05B7; Mon, 23 Nov 2026 15:23:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94BCC6B05B8; Mon, 23 Nov 2026 15:23:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83AA36B05B9; Mon, 23 Nov 2026 15:23:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6DB6B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:23:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8D11409F1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:22:59 +0000 (UTC)
X-FDA: 85467507678.08.BDE8063
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9D180A0004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:22:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="SieKh/wJ";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795465378;
	b=Cort9wf6Z9/zbTMLaAJHVnjAgotMPXYS+ccxaapoumEyn5MPdcxe9gU7F3OLm2RsQqTgVY
	9i/Uk+lUvOI0w6TvUEoz8D8Bv8e8GGF34aVBQYQAXRLIMxzrRHXXR54ChP3j+tLOkY6d0+
	PxFe3pWXalLTXiEk5sC13/VRks1hNBE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795465378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKXZcV8cKb3Lg1UagSAM58C/qQq0Byjz97EepSOcDvY=;
	b=pWYqjepiglL0Hv4QHc1jez43AUVzAlbUJS3sJHEjOHlI+3GgagWkTUjnbafxWgu0EW9zM1
	MSSm0zj3APWnOXqmOmK4AbZ5+nQGwEsIuYxcJC06pgVDvf+ws8WAuJzR/crlFfNQIjDNqz
	4c7r6LFEm6MtKGa47ktYB585HMXBho8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="SieKh/wJ";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KKXZcV8cKb3Lg1UagSAM58C/qQq0Byjz97EepSOcDvY=; b=SieKh/wJ1aTov+gaxl5hmOcwwM
	hFQ5mZXaNyF0dzEWsPJp8agfyi5mQ0Mrrdj8JFcWrv8xBio/0j2WBcKLTPq4Bae0HPPak6s0+oX0K
	3mheKlnmLI13Izk9zBqmXoMp1i5bll9H9vBHbSNkQzkpo0LQvY5yxokAU+nXiGcMtIP+8HBnDOZ6d
	9EzE7POVu380aSAOXnTRCxAdU2CGbHfizSz2n+C+224iWNTU1MOt5vFOduTuSgKgkgipe8quFeUJ/
	2D1jLEKpcRSt3+AnJ4tEN4mW7pduiThuU0WBiTYlNGTgYprHtra6kNVPwy0nMG2IHfnJwuXGrBcO7
	0rOglfAA==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xVaYl-00000006z5F-1ZU9;
	Mon, 23 Nov 2026 20:22:43 +0000
Date: Mon, 23 Nov 2026 20:22:43 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	William Kucharski <william.kucharski@oracle.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 1/2] mm/huge_memory: use NOFS when allocating while
 splitting folios
Message-ID: <awSgk1VTUsiVQOAT@casper.infradead.org>
References: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
 <20261122-migrate_reclaim_deadlock-v1-1-83c56185b0fb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122-migrate_reclaim_deadlock-v1-1-83c56185b0fb@kernel.org>
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 9s6ymso6naxhsbxgww3zcb54rj74mztm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9D180A0004
X-Rspam-User:
X-HE-Tag: 1795465377-233964
X-HE-Meta: U2FsdGVkX185VmM7qTAb7SyRdL3UthU2e2afJwpJ+tG+790gowEMWfWhl/wJLbNbJosDo2T1cQgf5A4iaOSRG0vq/v3cQX32jmWjq8wXz/if04FYSkh3SyoXQQdXe58FYvWqXren/UMs2Jre2s3z3PxpS5YZj6b5YBn3o/Ro7tg0fN5Rs9UJXMQ+MYFzBhGSwnVAW930MuWRps4R6y6kXX0h2thIlPwDAAcYlpJ7qz0Vu8D2Uqe7JQLcHnya/kkbuCU4QD60yXOkuAVMZ8ONm5x7Ck6WZ0tu5uzqQH7pjhgstX3WC0tVR8okdNL9Zkv1sJeWYu7uAXWO3N8xAJY3sLlDkyhHJTzPAX0P9lCdDR1rXwAUfpSJdPaCci/p19yKOoF+ZNOQOzHV5qCviTrMyjajrohWwcjIPTiiw9YKDmT41xvZQrQDMXFFDBNHIf3QTjPE9tvAwFx09k3ol6w/516eBXbgJ2RDc/h4zaGI6uOCGhL2OgtW//bmVKBEZeRiK09HJyWME3qFo41ww4uAvNfCFmRDl8/cKWZONx3NeoWmB+d/DdZa8eea5rxXm0O6DlZbSgxQGwukbjBUyWKvBzSXQLsVcgR8XXK6O0+gEKL9XIkLFJaNP3H9gl13+Pa4EnxXOH9mipp4tUs8jlt0/rwlCIS+JxTx+PKCKOlkn2Wnvj7UvNdAM77K1dXvV5GI4y3FBM6bLi4FxU6m7BwN/kRnz80Y7/ZeSuMVTbh4V16/2oRaR+BnpDqvTAepOVoFQ8roqhV+yFgP0lkVL47XHYsll/B+tBvVT4xx/B/hINAPFDEsWTDUCW89HkxVTTYCXeV1LSXdB5R7MESCcKJOfz4gOWq1IisooOtzJpT2lUp6GSbc6v4FswR73VoSmqJvkm7PZyS8wkXUjCsOylYgzX7PhOpIV7rSlePBnOQJIYFklSFwpkba8n+OsDbC8MPKD0V0JFvJToLleg1yR4H
 3IZ4N2FP
 YG7Sx2zt9t/Bsh0NfaknG39fhoFsd4X04aL3VpblYKnJfGLOE9djIqcVYgW4oHiU0gnsn3L+KAeKlPQ0Jwr3nlwcitVqrnSk9w9WkP/RGMFBdWF+CX0crxoCxEw+8dU8YPJt1dxYUxSOwuvc3AMF+IQAiwspwQkDXHBENPFyH7taBdBwPIwa/c1qUUPOSBhzt1p0CLNvx0aao31d09zKRkd53bV6q+w+ilcN5BF9d6vUjQprdWfkEslp/dzF8y9v/K2UsTE46oyVZM2SySsPJVuaa+VGDf6ofZY6OifQrEHl6fVXNdx3KG3NaaAy5TS4jdVg5COsMZrGavemnv6sJZswgUrMu+/XhDnLSPAyHRwh0B/FtIM1h8k1CpTJCgwDO5Mk2phPq/BN1WXs6Lx+NI7zG+Nhb3NV3THbO3tjSL46Bptik+n2Ij66Kkm03iRUYKORvxAn+xDxFDUN1qNLlt7k4Uhe/Ve8WGKzm+/4MjCjZA7DE5hkKaRAoFHNUFrKhRGV9rcJWjkvLtsyKBGTXhEBAGDlyLY4/DGNq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 01:42:17PM +0100, David Hildenbrand (Arm) wrote:
> Various callers (migration, memory-failure, s390_wiggle_split_folio) split
> locked folios without holding a reference on the folio's inode.
> 
> Splitting a file folio might allocate memory for the xarray and call
> filemap_release_folio(). If either ends up in direct reclaim with
> __GFP_FS, reclaim can evict the inode through the dcache shrinker, and
> wait in truncate_inode_pages_final() for the folio that we hold locked:
> 
>     try_split_folio()
>       folio_lock(A)
>       split_folio_to_list(A)
>         xas_split_alloc()
>           try_to_free_pages()
>             super_cache_scan()
>               prune_dcache_sb()
>                 iput_final()
>                   evict()
>                     truncate_inode_pages_final()
>                       folio_lock(A)

The "holding a reference to the inode" piece is a red herring.  We can
deadlock even without it (although maybe the AI can't see it).  If we
don't remove __GFP_FS, we can hit this path:

  folio_lock(A)
  kmalloc
    alloc_pages
      try_to_compact_pages
	compact_zone_order
	  compact_zone(MIGRATE_SYNC_LIGHT)
	    migrate_pages
	      migrate_pages_sync
		migrate_pages_batch
		  try_split_folio
		    folio_lock(A)

See this discussion:
https://lore.kernel.org/all/20200214065504.GK31689@dhcp22.suse.cz/
which led to patch f2c817bed58d in June 2020.

So yes, anywhere we're allocating memory with a file folio locked, we
should enter nofs scope.  Perhaps we can teach the AI that rule?

