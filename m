Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2FA606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 19:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=fXjOzohu
Received: by kanga.kvack.org (Postfix)
	id 4AE156B00EF; Fri, 30 Oct 2026 15:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45EA56B05B1; Fri, 30 Oct 2026 15:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34E486B05B2; Fri, 30 Oct 2026 15:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1296B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 15:48:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E2CE120699
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:48:31 +0000 (UTC)
X-FDA: 85380329622.20.C00396E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 263C84000A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:48:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fXjOzohu;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793389709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cAqrwEG4tJIMReOWfjqK8hyBrP8PRADznX2SjMD38Q=;
	b=gm9BSMRyQQ3YUnK0X61A9Ig9wcxr3IHc9rkyDinzNZi3NYBNwRk5vmvLzgvM5NIc+7EZQF
	AfNP8pejjCgJEo2U541Thu9uHOe6Xv3QdHi6DSDw15wYu+mh38IPGtw3ZY5H9QnOgkt9av
	1mOrJReFc/kPzK2jQnU3g3hXh73dKis=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793389709;
	b=cYkCx8FkjdHZ+6QdksZKsQo1VfK03dYvYcBWA48/JzpsHv4ijEzpcjOwmqfpJWpTRAIMTL
	BIfqdxB62x1WvkeSEpFNS/CCwxkr0X99S+ktsYVdMUjv3K80vEtJvCg1M1tKuj5goXk9fr
	JIqF/lsuCj4GH8uf+GaZBDbx1A6QMWw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fXjOzohu;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5cAqrwEG4tJIMReOWfjqK8hyBrP8PRADznX2SjMD38Q=; b=fXjOzohuKhVw0dSm7kurhSEjMx
	6ncivLeUVzuEuljHndk6KFMsr0Gp5XJxpEaViT0PKxjF1DxJfKVZD6Q9Al06C0cKCR263e2//KE/9
	BhqcqOXfNHTNAU8tqbvd360LrmpIB7/G6QybSUdbCUP+XIVqT+B4wc0s+jHx/u/oZmUGjxHOSgHuD
	ij8KyKAVJ4xrVQoXVUEhC4MyuFwAz5abZibH9qw/n8SJv12+1cg+iQN2+0QVbJrsVhozc2r2JDydh
	94x47YWl3uDla8PHV/FnwU3PocKKFJUVUdCMHBvxmzPrP1wVloEWX1Va5n3rsEpyB+qYG+JdCSjcj
	2hxJXohQ==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMsa2-0000000Abtz-11sU;
	Fri, 30 Oct 2026 19:48:02 +0000
Date: Fri, 30 Oct 2026 19:48:02 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
	Hugh Dickins <hughd@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 06/46] mm/filemap: read mapping->a_ops->free_folio under
 i_lock
Message-ID: <auT0csDIJwvwfDqb@casper.infradead.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-6-6f74bec9a5bb@kernel.org>
 <auDG-5bYh2tSQem8@pedro-suse.lan>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auDG-5bYh2tSQem8@pedro-suse.lan>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 263C84000A
X-Stat-Signature: e7u4yff56u86tef5yr1ywbwncfiuo8yq
X-Rspam-User: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793389709-333975
X-HE-Meta: U2FsdGVkX18A6C1q8saIkc/dHncnkRH47RMp5F3WdzgfjWb+cONi/3KbRQyfiiczFkwcU3N9dM6Qt3ZAXmsKQGzImBtrfHD+tEfD2GbCUQJGU2iae9cHcvksAmzvI7qTPY5BA1a8tt3ZWdRZTzihR9pTz8cUlhAajw5QmXU2ngZILKbiRD4fg9225umJXH9nGrqC3nvjcWmW+A1G5KXZKsi+DkN6xVTN+0qWA3o8Kb2qXUkR5k1BvmX43fYy2hW3sRE2VEjVAFlrLQ9kFbzDpLI7RwbypklMKKdxqd+7JZEo/RI7CJf5I7sKJAA6USOkcfTd3hUqRBZGyt1XhA9e6qeeMkfQW6sOsDdtgDnwMwj7VCvMdmlMFzev1qC9eaeLQEJ0j+JeaDyxD+ruoaHpv2YPX73lj1egQryYqvMm74+SbZLt9e0Mk5A1Cs+5URS54vqWasEOsFlXo3ApP2TVWEPo0FquVhs3qVPFjiUCAU+BpIcFTzaoY73vWXRVXaNhRHow/6QVBLAaD6oImC2ojb9n1pjHJfylZ+bsXif0QShiDa0NMgi5lwQVmY+bxBSU0KubmgKyo9hA5FxscNFbK5ZQgU3kUlXJ90PlKAdIEnXapRcQEEhgseNlUPIQjRrFmOfrnNMUVw8zkK/cQPtnD4VlxxwxFlcZ8XLeLsNpe1GGEC/H0KDWGhFJcFF1ANh64InsJ9meCwZGfPptezutUutnx4H4AYH7ASHm5+PXdzbXTFL0gob0zXNiJXa947dbBpi10ejZLr5LfshC42Q72I92DyIIyviGFJ2VBhVQl6v3qy6MhaQfDTowh+YqHdV/LQJXVEoiXqoLZRR12oaczrJY46Q5PjX4D1mnmvPVMRYJ/FSVx6gozwNDJuk39hE1PV3lnT2mn6NgzxhHtMwdrwNYvaudBPH7+MBNw7W/YaEvJ24yetyd6TqMv+XdaLuA5u/8rtlXQijie8lisw3
 MUg69RB/
 pjtmcNhEBKVWN71sNvarNZaUxoltjDCU3n8iX7EI67yQ7w4vvuEJlPPrUE40YqspZa4K7EizjYvUdHepe8C38yyd7nmn5a88sjJfKG+t575l/HK1kmm4M08O7ixR7+AlEZV/OXBW1MSauueeiTFxwSBLUB3HhK8Gy1rV4dXM7ccms3dZLiAMmOCrfAqtayjBBCpb5M0yzvnBbRYvOkibIqzP7hcW+O0toeGZRdjtmnBeSMhE/6gEFFsK8DTHyCCbZ7mirAKFXicfnLuxHuIvX3kocNr22oqe0cTRKLwDxNcKboNOkCZ/Em9OVWXTYLe/0j0yvPRAOVf1jM2uv/+NtXI5+bmvs2TNu8hzVQTY3KdVgQxv8oYoFmuGphdoB3TVgg2YhEdWBWkbLL0ZtbyzTrC50n7rExmnyQf2cdVPF8JKDIy0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 03:47:35PM +0000, Pedro Falcato wrote:
> On Tue, Oct 27, 2026 at 12:17:26AM +0100, David Hildenbrand (Arm) wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> > 
> > memory_failure() -> ... -> filemap_remove_folio() can read mapping->a_ops
> > after the inode has been freed. Once the folio is deleted from the
> > pagecache it no longer pins the mapping, so after i_lock is dropped
> > e.g., a concurrent final iput() can evict and free the inode before
> > filemap_free_folio() looks up mapping->a_ops->free_folio.
> 
> Ok, but after iput() then nothing also pins the filesystem, and thus the
> module. So we can be calling into total garbage. So what gives?
> 
> You can't just take the pointer, you need to make sure the filesystem
> is also still alive.

I hate the existance of ->free_folio().  It'd be lovely to get rid of
it, but I think that's outside the scope of this patch series.

This patch narrows down the race (and removing modules is a CONFIG
option anywaysoit actually fixes it for some users).  I think this
patch is a significant enough improvement that it's worth applying and
perhaps we can work on removing ->free_folio in the near future?  There
are only four implementations of it today:

fs/nfs/dir.c:   .free_folio = nfs_readdir_clear_array,
fs/orangefs/inode.c:    .free_folio = orangefs_free_folio,
mm/secretmem.c: .free_folio     = secretmem_free_folio,
virt/kvm/guest_memfd.c: .free_folio = kvm_gmem_free_folio,


