Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45094CF6A81
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 14:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9F786B0088; Thu,  8 Jan 2026 09:09:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77736B0089; Thu,  8 Jan 2026 09:09:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 982DE6B0092; Thu,  8 Jan 2026 09:09:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 84F846B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:09:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21F1D1A016D
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:09:30 +0000 (UTC)
X-FDA: 84308979300.24.6453415
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 732AC40008
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:09:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WGgf1BP0;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767881368; a=rsa-sha256;
	cv=none;
	b=Y8IRdJJhZePYA0lY9KiCUqwlNFfNQE0OLGRqzsAyDqY2qA8efe30TS+OwcCED/ALuxCeuv
	zXqf9LqpR0zok05MD60h9BcX5P2elG7hpbzGedsFA6cJo4B2mGt3jxz1Oy+OVb+BASV+oH
	i9E2aACAfnXDIpzhS8dexpRtrwinnkE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WGgf1BP0;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767881368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HojQq9q24AfBmZaxHNzm//OheDCcNKb2U02PaP3VG38=;
	b=6nd19HGXmbBpA2oIykQDZEm9XlnDkTDqvn+SvtpCLzv70wJoI+LRjxN0h01mtrghamMUoZ
	dnzXzF0ztf4NC33jeeW4o6kvv3G1ZCRy/4XQkwSZ84G1KmTK2dLhHxQvO0j0q0QLRllHnV
	J7He3TAYgEsvs7AsF8yjF8HWws9gMn8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HojQq9q24AfBmZaxHNzm//OheDCcNKb2U02PaP3VG38=; b=WGgf1BP0kF4qcijKfc8vvVP3KC
	njFwdcyy/JN/17iRysUAEpbBQjgGtBsRnh3A3QoIOVu6tfdKfDsv8WZumYBh3GOUrUaZG8de67oYb
	mHhWAaD9IkuUOeYkE9Ze4MrkwfsTu3rlUwTIF7Jdy10xVE52IAPVGdGL/09heNvDK3KSFCVNOCj3l
	BotpXMjqnZbo1CGOYGlPqTvJeip/rUKuRlsHQ5cFilwiPPJDhgOe69xx7k/E7c0MQQj/ZmbWWefBd
	MuQkhDuZpKNRr9+0MIo5xVzH13Slb7UxOc7KwHSEoHpM6/cErYDjlnPXrtXxFL2BF8fbjQEdjzGQa
	xY6jfdTw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdqhU-0000000F25b-090v;
	Thu, 08 Jan 2026 14:09:20 +0000
Date: Thu, 8 Jan 2026 14:09:19 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH 2/2] Fix an AB-BA deadlock in hugetlbfs_punch_hole()
 involving page migration.
Message-ID: <aV-6j97kTobFdYwE@casper.infradead.org>
References: <20260108123957.1123502-1-wangjinchao600@gmail.com>
 <20260108123957.1123502-2-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108123957.1123502-2-wangjinchao600@gmail.com>
X-Rspamd-Queue-Id: 732AC40008
X-Rspam-User: 
X-Stat-Signature: zi69j9zb5qpep1rfrzbt7b13wkcmop6m
X-Rspamd-Server: rspam07
X-HE-Tag: 1767881367-477101
X-HE-Meta: U2FsdGVkX19w3n9uF3C2hpDA3zXe/PSJQwIIRMIyaeP5mf9Le71PK/LqS8swbFaZu/so/3sG5e+42/H/SH6gAlwlBKwjbuJ0zlMlcn0ymmL+L2BRTHhhnnFt0zsjcjR/780mnyBazojKGmOsMV/jRJWw5KbSJWCJSA0tvnQaixpf/mhEnFP5SYFpiNSwufJ5vvObVPD7Yu//9PZn/4YSfvwWJroK4BtxneO51MWYAwe1UGSV9e/gcHA/4A47m/tmc44Sh7dszXwTOwcY2qCNcys1qformPE2TTRtYjKNZNJBNYfPVX2lY2Hi55UNCC54BAOwwoyskOTzL+ZdF7zpwls3GzJfUUtwOFwHaIjIFBME7y2/WkCqRm0nRkPKiwWXX3u5DFRcYrlRQnMZntGRVwE/gh0sYUt9Z5IFB1ZeRoV6TrG9hs4Df5enEkNctfKYBW2kSc+nonBkMPTzuNTm7WwJDAPDAtBFuohLAAY481ZSOyGtt2TD63KpSP+nLa95p26J2OWGpmEL3xvK4i+eekoY0o3JOTXd/oJMTamDXfwMGerh8iAtPfLUEm8Rr8Za7Np8ReSZNrYgXboDQ+Pwi91adt/s9nMcnwqe7q8OIt+hiz8Wo89A/2l92aArDOE8Feo51N5JhBFAqctcr5po6q12U7Fh+IXtXvBfG8yzTINqCHEJDOx9CrJ446l/tZ56x23AykfKEyO7vlFhkfWUhrRBH8rIM22GKw7wq9n64f36x6dVasiRfmCNa0D3qrlCzQpvHKvQv3wAxW6Koqsc0x8txVLO5drSB7GdG5kkW44QjMBrtt0AAVcRBxZfFzYBLl77hIY6P869yRr0VR4YPNfVdNL68iFr31K3m0UnoVUPrQJiLhqAOTV0Eh9535kBS8p+M+0jbrnUhEhcMyPPdaIZsMDU0IKPanuiUgmcZjx8ud38nPoAL/nNDSKhqICzlJDzWKILhP51Vuzgxfj
 Lf6xtyER
 yzsI7XrhBgfHDi/p0iZqnQSHs/vN038FWHd2DGrtDv0Nx/rcLMHzuWHEzcWOlnPd1z1rvySz6yFfGSXrrTPvw/iJnLfRmpaR/O3VeXmY4FDv+KfeBhrXnEKmTpiKGua8Qard7x/85xTgATuhIvMvr6rkk/iiur1JZcsA2hHb62MSTL9m/b61rLHqvCojrBvEeUx0qizmSf88Z3Uvja0Y70LbUvaLA6QWmMVzm98yOzZvIPqbpKMLjVE9x1fWLkP+svGS8XxjOS7zZW92EOdXLGJdDVElVfwcqZgFrpqJP2Jb6uscpv5q2Uj9FwbSnKOCoq6/1OQ/xkAzdTI9ueldiOmPb1dk5tx4G2J19oMeyWuBJ8pkwLRJNedD+DxTPCaNMRumquT+uVwyOoHg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 08:39:25PM +0800, Jinchao Wang wrote:
> The deadlock occurs due to the following lock ordering:
> 
> Task A (punch_hole):             Task B (migration):
> --------------------             -------------------
> 1. i_mmap_lock_write(mapping)    1. folio_lock(folio)
> 2. folio_lock(folio)             2. i_mmap_lock_read(mapping)
>    (blocks waiting for B)           (blocks waiting for A)
> 
> Task A is blocked in the punch-hole path:
>   hugetlbfs_fallocate
>     hugetlbfs_punch_hole
>       hugetlbfs_zero_partial_page
>         filemap_lock_hugetlb_folio
>           filemap_lock_folio
>             __filemap_get_folio
>               folio_lock
> 
> Task B is blocked in the migration path:
>   migrate_pages
>     migrate_hugetlbs
>       unmap_and_move_huge_page
>         remove_migration_ptes
>           __rmap_walk_file
>             i_mmap_lock_read
> 
> To break this circular dependency, use filemap_lock_folio_nowait() in
> the punch-hole path. If the folio is already locked, Task A drops the
> i_mmap_rwsem and retries. This allows Task B to finish its rmap walk
> and release the folio lock.

It looks like you didn't read the lock ordering at the top of mm/rmap.c
carefully enough:

 * hugetlbfs PageHuge() take locks in this order:
 *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
 *     vma_lock (hugetlb specific lock for pmd_sharing)
 *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
 *         folio_lock

So page migration is the one taking locks in the wrong order, not
holepunch.  Maybe something like this instead?


diff --git a/mm/migrate.c b/mm/migrate.c
index 5169f9717f60..4688b9e38cd2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1458,6 +1458,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	int page_was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
+	enum ttu_flags ttu = 0;
 
 	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
@@ -1498,8 +1499,6 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 		goto put_anon;
 
 	if (folio_mapped(src)) {
-		enum ttu_flags ttu = 0;
-
 		if (!folio_test_anon(src)) {
 			/*
 			 * In shared mappings, try_to_unmap could potentially
@@ -1516,16 +1515,17 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 
 		try_to_migrate(src, ttu);
 		page_was_mapped = 1;
-
-		if (ttu & TTU_RMAP_LOCKED)
-			i_mmap_unlock_write(mapping);
 	}
 
 	if (!folio_mapped(src))
 		rc = move_to_new_folio(dst, src, mode);
 
 	if (page_was_mapped)
-		remove_migration_ptes(src, !rc ? dst : src, 0);
+		remove_migration_ptes(src, !rc ? dst : src,
+				ttu ? RMP_LOCKED : 0);
+
+	if (ttu & TTU_RMAP_LOCKED)
+		i_mmap_unlock_write(mapping);
 
 unlock_put_anon:
 	folio_unlock(dst);

