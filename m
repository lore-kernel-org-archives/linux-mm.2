Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6221606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=DK7Z9izk
Received: by kanga.kvack.org (Postfix)
	id 92CD66B0981; Wed, 25 Nov 2026 05:05:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9033B6B0983; Wed, 25 Nov 2026 05:05:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CBF96B0984; Wed, 25 Nov 2026 05:05:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 580116B0981
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:05:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0246CA8D4E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:05:53 +0000 (UTC)
X-FDA: 85473210228.27.90869B3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5884012000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:05:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DK7Z9izk;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf29.hostedemail.com: domain of BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795601151;
	b=2d+dVTC7T0mNytZ3r74hbhUGm31bmvwYVZxA/hYJIRU5ZDoYHGNdyQDRife8uuu9MslkHo
	RVZ/qx1NWgdNwiDMkdayNwlZGh07kDqkva1kBTWsRRQO6QCwoTmvNRo6w+l0QxhRvJtxNt
	XQjIsutBC2hGEyFcIFqMsbdmRDGSHSY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795601151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVzOnSLOiNwp7oTUU4Cf9rSv1I0m0hohY9lma3fv+uA=;
	b=XI0yhxJFZizaI8mA8FrQMprqpP1AUlqcca2nSha0GABeY1Xl26tMpI2hxmBmQwo1WU64xb
	oglVM7jKLRtSNm8keHaIubXYM6i4JkE14Xv1BZwEJHK2Lqv2XM/6dwSZlI7zfQy3jKt0pW
	ST1+KVySNh5UgNOPvfjSfEEI6hXiEZM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DK7Z9izk;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf29.hostedemail.com: domain of BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lVzOnSLOiNwp7oTUU4Cf9rSv1I0m0hohY9lma3fv+uA=; b=DK7Z9izk01BpR7A/zkj0WwMYoA
	CoXufy7m7SRtXrx5IULq0pQpJnIW8G6faQ9ewDcD82OXfTdNIePjZvz+VxYCrF5csf0R2efUoiFiJ
	sozucpD6cRGf1qTCeHiT18MUWVZQHoZrXlWetQ9sztRVHA924bPfv+IHyEk1pHuDSgvhZfklkwvAt
	Fny0Oz4fK12vr40pmyJyxdVEAFy4L6hJopNcjPngsA1YgMc4VpSCAU+dlYyWzBXkXag0WLO7DQ72X
	L3kfXB5i9W0Bk1KTGrtW9ZQGkcwHGA4dF0Bops+aJlS0LY3HYwIwKJyv8CHoYsFe6H7idIQ09tp1a
	4zfVHw2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW9sh-00000009PVf-08Ll;
	Wed, 25 Nov 2026 10:05:39 +0000
Date: Wed, 25 Nov 2026 02:05:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, John Hubbard <jhubbard@nvidia.com>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
Message-ID: <away88BuU8ibcTA5@infradead.org>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com>
 <awWNyDZT2SVu2Zp9@pedro-suse.tail5790ac.ts.net>
 <55114986-0ba1-4a80-8498-bf674d64e01b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55114986-0ba1-4a80-8498-bf674d64e01b@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5884012000B
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: aqboi9kqihgbps83x4g1izd995b6cti6
X-HE-Tag: 1795601151-192502
X-HE-Meta: U2FsdGVkX1/VzN145hW9dwCKUEO+NwIrIAvo4m6QZqWLOZyjUccYrzHFstk3Kgf6C712oSVpHANuXbxtHXrdwAX30r/66qeTcCflGPMdEVWEeq8BAfjAX7GDenpkdN0qlO/bYYE2GPBsmqP7HwZT5uEJfncnq3EWEyqCL3z5llJQg1TihFhb403n1Q/e0bz3f1X+ei++ArVff4O9Gp1WSNIY7VCzHOPvj1Q01BhYlVk9WUTMdnR1X09aTjrtVFs0ZsEBvAjel+bjoPnbMnVv2g8jvxn09Nm48dvX2NiwSG3XdCLDayoAJCPROGFwngsityddNorvCHq42WmqLBYvOeaLe3/Hv8/Zpqo6IZUB/DH9lNp/oaA3n+ypKJgnFD+yVAw1K8UBdDfQHuH9wY+nm54OOAapEYc/Y7NbKFlTQNyHCMvsCjq+HhpMsQOtFxLTa6cF5JDTqe8k/r/jhT2NnU5X7emxAexf83vOLYuaCgbdoCBBVWEg3X3EZeFKQ1B11EPOn90beJ0eZIIbp59d0cpuMu+ygVAFrMulx6FSjxbAUA2b6kwIjPIxFCoATCSParQG02owwzIRm8H2ztuD7PE1XtPA0Nn+S6wjW+ce4axo/toOh19bT6dgmF5wjQfosKdoQtmWyzq4yQUL/qveo4pYWoeMPsb6XvbwGeKRrIuJbbt59s5m2XWyUXp8F00yWcS1PLUEa2xJhvxlSVSmWhCV3idg+X5V+9NWnxMeNvFZC5F+0Ibd4t//qCAKf+sgeVVfsGDSfHiQDlxAoWy0MkZVosxHiFVvB2eV8uOHMuSWC+J2yjbx79OoCdWI+4V6sQ8YLitt10NvYNpaDY+TN7k7B1PH/Jaw0YLWln1DUgMEaPhctnOMGTwsDqeg2xqZ3GtxuEGp3nGb7jxqaUSSRjxLcjznH9cM8pXSzauibDo2VC6gJ5fnAYj3VbZr1Im2Na/jHa+tT3MGmdNroZ+
 JRlaOTuP
 WiBQ7RxXiNs1weOtqkWeDWAM90r1qoe23t6nSw8pOqF+4sMPA8jXMJpH8Rbq7cNot3jLnPDrsFnFkc+oCiD9qLTQ45GmgRUxo6TVv1O+wXQQY0KQsZZU3ZC4qfMZh9PQWo8Hb7bkAmelsqKFIGZI+/VI+Az0KAPhWo+8cbHzbLWZKiRwRhTfgoypS9WF78xbS+ABd3gWclFZKR8ZfneP85hM9UrE5BXArdgBbsxcox2140doWg4SlH7afVKTe4KCC3hgKKVH8MiG6OthMFiWHeVKOgRqZ4GDVfD0CJpCNwv7VfQv2TzLxJiCEbsEd36RReC2jzr+hqcSRulWK8WScN0bRUbM9XdtAus9zVjvC5m3M5F06dS0X+5NiQKbRzYIebm/e8ry0M3Z3SypQdzj1u+Li0ksPP+krbrbpoeKnMi04ifIYTfSI5uud/LhRC20Ne4eqUBsAb2QWQdzzZx0f55Unr4PoWFdskgijzsqqakurVKfprGnkNs/yBPJcIP709J/wuRhwBeKjKgO35KLCDdjhX3E5FPbsM+XVQ1+mdTg/+GDib7hcFubfgkT8ThzlMBJa90W69LuDTTdCZhsqXjiJc4Ru3eJ0qZhQoy8/sX79WYQhtpmcMoLLLnlkCYkxnXO4t5Z5YwRgZ0P5kaTPhDt81+z2lEcEac66M3MVHn0/3sgS+r5sR5XWAQdfiUzGdQcEWw2lgZeF6qe1Pu/MNtHZz0t9O78OpYdJUENJiPBXEF1WJ4B34PMKnQz+kGsyADQgzltSj6OxiGnPHU4680qvgxYze5n+EiMQV9Gk0iOMfeaEdfu2bq5A5+uFVFp8wH0zcubM5l/RphQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 10:50:42AM +0100, David Hildenbrand (Arm) wrote:
> When I looked into this issue, there were some problematic things.
> 
> We have some odd drivers that use FOLL_GET|FOLL_WRITE, but I am not too
> concerned about them.
> 
> But are ways where unprivileged users can mess with  FOLL_GET|FOLL_WRITE
> references to trigger this.
> 
> I think the two that stand out are:
> 
> 1) /proc/self/mem access using mem_rw() -> access_remote_vm()
> 
> User can write to a writable-mapped page-cache PTE. Then we can race with
> removal of folio metadta, to then set the folio dirty afterwards.
> 
> I remember a good reason to not convert these paths in the past (we are not
> performing DMA).

I don't think that is a good reason.  For file system backed VMAs we
really need the pin to be able to do someting sane, DMA or not.

> 1) We fix all such cases now where unprivileged users can trigger this,
>    converting to FOLL_PIN.

We need to, if not for this series then for all the other outstanding
issues with GUP writes.


