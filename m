Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559FC606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kp9aWV9V
Received: by kanga.kvack.org (Postfix)
	id 5A7C46B05B9; Wed, 18 Nov 2026 09:33:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F4B6B05BA; Wed, 18 Nov 2026 09:33:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494F46B05BE; Wed, 18 Nov 2026 09:33:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4436B05B9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:33:58 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F4404077A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:33:57 +0000 (UTC)
X-FDA: 85448484114.11.27C1FC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id EBB6B180004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:33:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kp9aWV9V;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795012436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r0M7bUtZEofsoW8E6XLzL0ND8blGJ4WCG6thjd+0hTw=;
	b=eRVijVwBvm1sZ52Hqh4kx+8S2xs3cLTLCwy0EwH4gu79AKTA4skA2aheiE3MkanMsey+zf
	ZrHHanjMLX6sZdG+DRWB9abXZEOSg2ej7iKxD99/8iv2I39mewBgvNd3a7VlE8kkx1BDF2
	0UonajRD3slUcKmcG2aw24kkt1G1SOY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795012436;
	b=W4EMcy0cLq164jHJq5Xyb9JHSdbo9gQa8GsBb3iERn3skf0ryuoKC+38f3PwfGZ2Cgv7wu
	agtv8+/ogzOdsSzdjkKBdRtOloySwM8RZKp1ZUECLaZmTf6QVy4pGVxQzcvCiq4ec0hF2l
	fdQQxQRd+xjVucmLiqUVME9oA7Q/mVc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kp9aWV9V;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F310543612;
	Wed, 18 Nov 2026 14:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D43D1F000C4;
	Wed, 18 Nov 2026 14:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012434;
	bh=r0M7bUtZEofsoW8E6XLzL0ND8blGJ4WCG6thjd+0hTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kp9aWV9VMOCglS7T1p8dI1UFHOj3QgFUQWE27OP4HKp8U3+jjxoxZ5MiJj4la/XvM
	 5g271rkeXZHxD1RQZeYy9sJtGReqx/Wu2njRPkXusfpMZXxCGIR5ZzMv8YoTGpm6hg
	 Z6tgqCBkZgIcFlZSz6035WSZxIeGPy+JrC1PJGNpvJDd48S1qhJk/hFuZsiCPChbpz
	 cbipzUh3C8OOrW/AvXUuXYqzav1/ZSNl5r9u80mpnTju6Ee+vMAghVK8OCjuuDA05S
	 HY68vn5JPr7XXFHUq32yMMFYFnOyzSscbzp0r5NSgcm81ZAyPEr+jLZrZyeSuycfOU
	 fAGNDFU01uI8Q==
Date: Wed, 18 Nov 2026 16:33:41 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	James Houghton <jthoughton@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Balbir Singh <balbirs@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	Andrei Vagin <avagin@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/9] userfaultfd: refuse UFFDIO_MOVE into a
 non-present huge destination PMD
Message-ID: <av23RfHuKjWeeEnN@kernel.org>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <20261117-uffd-state-fixes-v3-2-b617009d1a4a@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-uffd-state-fixes-v3-2-b617009d1a4a@columbia.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EBB6B180004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jcgsfw3q41pm1ww9dc4i7xky4ysyyfqe
X-HE-Tag: 1795012435-304912
X-HE-Meta: U2FsdGVkX18StLK3+P/yPrSv2Th7n4/+7MHvL4dnn29X1UV5khMb3QyXG88b23Q/t58jjOwQXffDNTRrrfOEDe23VHuGOt6/71lbMlHouRLhgQN8YmqJ6DexucSNQtpf+nPhKpontiq9E+JqSblhK+mGSXeqAzQNrC+qJHaqeWJjNbQnL4tfMI/um4Q276A20nttOTrdgp6FxGeW/koVlvloxF1xgfaW5uQWMl+o+Lifi2l7miE6PgQdM1le96/0uF1vSU7/oXYk1alYeoOIwXhjxfNstQxubMnnFgqmSJnheHXjwNUCeCaUcENDIg+uBCDE6DLaCeTCtbcEhvw286gO0ffrEgAcuiREieA2kxkLnZ6yyRSkOSCtvwCfWwPh/hpbP4mqnxEUMOEmMpHqVymINaXwj0cUFdvPuDkr9xqFF4GimwQ7CijqlUni41Q2kFQWUMsQDDK+vJnUAmWlThGhmUPbXXsIxDvmyXgDaNEpYyiu6XeDY/1eEW4uT+95aloxYutDckWl3vr7GBSEd5s8tsGc7XUveg6tUa9Y3hWjpf9ww9EFGYTvalOl9CXLz3O+qVjIM1Wi8kMdCAS7NZxmp6xAzWID+frBMSS84ryK3Cl8g40ghbuQN6JZHRSggczz5T9JT0FXqrIA6E9BygQR8bdYdxhLqKUUfp7SCl+mATPJpgSFOwMeieMiyT8QeCWupzkKEN5mn/LDX2eSYEaDBvOuYgDb752qkMH0uOei/Sb+48ZFr+ibQL7cTILFnJvobkC2RUMfCLah2eegGbunK1PLtLvveb/WY2Vit7CwFqntlHTn9YhuYkNK5e2ZY+1I1RVAVQcQzUFZPvBUlnJEnR1wI+uN/HnFw5NBAbcVT/gizG836epUfH6WBZfKO1X5mUk4M38cl3OkjMH6AX4zR9QlgmptTD9S3QIQKQFD2UbqUboqnMspuK/C5B6Vjoqq/lbd50C6huim0Sy
 LWK1Vud7
 xh5TxqjkFGvrhEqPsFv/JE+dAMuiiwa2UuCAWimEzLTamKBuNUthMlc9giTy5UosGtV7YWWts2nmtnEkWK65OrUnG8VNeRWNlmlz5V99vAfs7TRXaWfgPuydfVqvjAsw/W3y0SCr6J96hz0IMTnNVJX8CJAw2EepxVo0vrhdbmmvUQrcZvlYyzoUexRvvbP43JHccsWvymAnD4ebYbNSTWWHiiCHNu4xyva6/p0Ro4dusNl5OHzeQPnOK6+3rdaiKmbiYXi38ErtiLUPdjqXmGRaF9zwoezAAFQHYlSJqDr2SB/QcJnJVUzf3iFXm0/IeM9JPFl/OdJKUyK2AOasKjetKmnpYgL/NOLiMgj57fIAxnVOa8MwSzwieKdgSmzFJ8r3ys1oweO1MkLl3Jz57xoqemW+TKVszFtptrDjHFfXSinE4AGFe/4SJSHKfDXHpOI6pua2o+8Gf8QDuWX0hEHo+VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:28:42PM -0500, Tal Zussman wrote:
> move_pages() refuses to move into a destination PMD that already maps a
> THP, but checks for that with pmd_trans_huge(), which is only true for a
> present THP. A device-private THP or a THP under migration is a PMD
> softleaf entry and is not refused.
> 
> The destination PMD is then treated as if it pointed to a PTE table. It
> is not empty, so pte_alloc() leaves it alone, and move_pages_ptes()
> fails to map a PTE table from it and returns -EAGAIN. move_pages()
> retries on -EAGAIN, with both VMA read locks held. If the source is a
> THP, it is split first for nothing.
> 
> For a THP under migration, the loop ends once the migration finishes.
> A device-private THP can remain in device memory indefinitely, so the
> caller of UFFDIO_MOVE hangs until it receives a fatal signal, and
> anything in the mm that needs to write-lock one of the VMAs blocks along
> with it. This requires a driver that migrates THPs to device memory.
> 
> To fix it, check the destination with pmd_is_huge(), which is true for
> a present THP and for a PMD softleaf entry. UFFDIO_MOVE now fails with
> -EEXIST in these cases, as it already does for a present THP.
> 
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/userfaultfd.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)

-- 
Sincerely yours,
Mike.

