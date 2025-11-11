Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC9F2CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352788E0011; Tue, 11 Nov 2025 04:40:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303268E0002; Tue, 11 Nov 2025 04:40:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2128E0011; Tue, 11 Nov 2025 04:40:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 058BA8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:40:10 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B761C12D294
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:40:09 +0000 (UTC)
X-FDA: 84097830138.29.354121E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 030FD4000D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:40:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GCiWpRgX;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762854008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yl4+gwf8QOtt9hN7qj5CGIv/iNxBo8//09K9iSurOVQ=;
	b=rky8MLyuXZ+0OyztyJbxBOnCAcvsmZwGavaqOdRjx0/8Z5P5GkE630aHot35tITXHF1QIw
	ZJBCPq1486VSJR8rJIpUAMOH26AyHoDAC0zcdtjlSEyWf9zeuhjmsnMrivTAp/Ek4JKJrQ
	21qlXV/MlAXfL0ydJlLSV4KF6V/WDQU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GCiWpRgX;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762854008; a=rsa-sha256;
	cv=none;
	b=5ddyKQf5fWdr4N/4fdO3g/L3DKuRK6Zs8hDKHQecE9SAYF8CoBMK6eQRohoGDclc190NJB
	CNhu/6zq1KAZJTuR+kaxCCSnAvqqVytlivuaob7N8ocLW7y02WqF8Y/1/fE3FHpkg1g7/I
	WN7LQ6sYy5P10+08HTbFW+cpUKXPUGw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE69B43954;
	Tue, 11 Nov 2025 09:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E4CC4CEF7;
	Tue, 11 Nov 2025 09:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762854006;
	bh=tV63J7taBdyVxD5Onk+zak6F3ctliG+Q3nAMch/i9HU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GCiWpRgXryUr0YiOuRCqFKMHFElrFfOJGLeX13fDzQhzdLeEMfA68uzI2EJFfxVhm
	 0MUDm4yk8dcgPkbCGQ9mByaYozbzGtDDR+dxx7BYEgVrFiJ8SZ2pdALZBfQboS0gvo
	 mHVFJX+o1gZPTNTphPXA9WbgGYWk9nlExIF62mZ73WXnbIrDTiR4NqRFsQaQL8Dvkw
	 S1IFcQzK7HMyEOdAdOb32M0+zECDPIh+yvtjXasK0QRuj70XQpLdc9540fG5C8LyLy
	 GOdJphkYB7U4gWmOkayWv8GOEYQl0T5F0efMNLKo7WjK4EvGrJauQ6RDtyW294LDmB
	 ZpUDNt59CcokQ==
Date: Tue, 11 Nov 2025 11:39:43 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 01/16] mm: correctly handle UFFD PTE markers
Message-ID: <aRMEX5YP7ubGOmqo@kernel.org>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
 <c38625fd9a1c1f1cf64ae8a248858e45b3dcdf11.1762812360.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c38625fd9a1c1f1cf64ae8a248858e45b3dcdf11.1762812360.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 030FD4000D
X-Stat-Signature: zarga8t9tcz59hfbsbnf433he3ke64os
X-Rspam-User: 
X-HE-Tag: 1762854007-177902
X-HE-Meta: U2FsdGVkX1+5gIZI5jHz1tc3cBs+EmPg3YREIiEFItuQ6EKX1R3FsXRUvM9ssf/xxXXA90oU7qvtggja44lFlLu5KIk0Be5XFFxlHjtK0yFB9BJ+vVgHT4eHQ1Hk6KZ6ngr3H9DgajZFhmhu1LizN95fw2I5gLlkRD8sTNZVYxkTsMWS+d0fBTsK9XSoK1arJIxUBGfORmSlKNWEpN2hjWcTHo6wgEoexYDbSZhngGPculXv/I1PkrzM/KFY+wW4IY62y/HYMcKi/OknU3hzbDTHtR2qZ2fC98y1YD6E5iAczrRxmoZ4utAz1Kq9NQ3zurJE1v2E1gfa80L7hrx2lHFmgjwf0OPut8e4Ot9t7stdA/Enf7NXYB6cF6dHyvMNhgZr0+PGLZbZq3v0Xsc2YhPbUdQPvJIyizdyPczRnkmuI64+SCnqgK2z2ErQI6qjCn4g/rc/ogQOmFk/TGhG3dtCX6GyqFDgWtWg/icvuRgCUX4tybBwA/qUhVE2dBKRgHpkU/fa7h/00y6ycdUXRPR7A/8FntZsIci67hr/mMGiSruzDtishkxAPyUtRlGHdV+w4Kh8oA88meuxCR8WNwXEzR3WOmdTGS/s7YT4oN4pGyn2uMJjFqXKAujk3pZRW/uqbj2VADCcNNl7eZ6S2p1BkjiCb7DbtDZZ2GYoKYTR7LPnbKU6yjpRLqcBmtrgrsfiXLaLoyU70tAzBhpRG0sU88Tde7JW4MjiKAdTpwGMwAS1S3RPk5oO6OyjE+zFKYsh6ZcJRVv83Uae3cmJ4/jQx37L6KMI14JwoeUoNz/PrpK6Pgx8cONxKLC0beoT/yXNCsVisExISA70pfKBc3s/2mTMqFtMpzBzao0O5NIdeRJ9HqIFriYtP2pqRSh2aivtQ+AdVNFrOI4ciuB/73BFqgPWdCbkofyFlvw0Y+MTatLZvbPXsnzcOFko3IAHoMb4MmhWlcSmyQtNNE+
 L8dUiJsG
 RB1ZPtmnXMRyEdCEGUyd4Anjh+k3dybOdazZpUNpvZ2knUrUvR2ORjIl0IIXBzAkpv0f4Ojp+fFoajRXlEK7RnihyiYwuT9bXTi4VUh1fxLFrWfPM12N0pvYZlNZEqIgcCRaXy7qwEIGtpt7Xvh4RKcJTdmkH8mvCwL0Y/Mm8cWqd2M3XhhdfSAtR/7FzrXqfiQEbTLT35WGtVLnzWVVYBSeJvD3Q/PJNQlvYoIgY72sZG8Qg7Mt6/LvRfa0jMdyhX9N2Shye+8kWwFIynRNvAnl+MWwT2b9J/sCeloIVK40M0Ya6zJkDfieXxwFmoeoq0r53c0sBnGuK/iekyO9DCRQTbnws3Z6WxfPKQRrypNj1QGl9Joj9BGG2NQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 10:21:19PM +0000, Lorenzo Stoakes wrote:
> PTE markers were previously only concerned with UFFD-specific logic - that
> is, PTE entries with the UFFD WP marker set or those marked via
> UFFDIO_POISON.
> 
> However since the introduction of guard markers in commit
>  7c53dfbdb024 ("mm: add PTE_MARKER_GUARD PTE marker"), this has no longer
>  been the case.
> 
> Issues have been avoided as guard regions are not permitted in conjunction
> with UFFD, but it still leaves very confusing logic in place, most notably
> the misleading and poorly named pte_none_mostly() and
> huge_pte_none_mostly().
> 
> This predicate returns true for PTE entries that ought to be treated as
> none, but only in certain circumstances, and on the assumption we are
> dealing with H/W poison markers or UFFD WP markers.
> 
> This patch removes these functions and makes each invocation of these
> functions instead explicitly check what it needs to check.
> 
> As part of this effort it introduces is_uffd_pte_marker() to explicitly
> determine if a marker in fact is used as part of UFFD or not.
> 
> In the HMM logic we note that the only time we would need to check for a
> fault is in the case of a UFFD WP marker, otherwise we simply encounter a
> fault error (VM_FAULT_HWPOISON for H/W poisoned marker, VM_FAULT_SIGSEGV
> for a guard marker), so only check for the UFFD WP case.
> 
> While we're here we also refactor code to make it easier to understand.
> 
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

with a small nit below

> ---
>  
> -	ret = false;
> +	/*
> +	 * A race could arise which would result in a softleaf entry such a

                                                                    ^ such as 

> +	 * migration entry unexpectedly being present in the PMD, so explicitly
> +	 * check for this and bail out if so.
> +	 */

-- 
Sincerely yours,
Mike.

