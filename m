Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD48DD111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 19:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276516B0022; Thu, 27 Nov 2025 14:33:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24DC06B008C; Thu, 27 Nov 2025 14:33:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1644A6B0095; Thu, 27 Nov 2025 14:33:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 020FE6B0022
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:33:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A1048789B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:33:42 +0000 (UTC)
X-FDA: 84157386684.29.C613F31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E9C5118000C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:33:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C82VoaDh;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764272020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9qVfZYLusbs7nTb2ljdkkAnGNja00E4+fsYf3laijc=;
	b=SUa3stIlrskt51KIHckTimP+An6Ldw6LcYychSU11nZDx3hh4O8eaQPeRPUXoh3WW45/ia
	jcGmPi8oSnezSbbAjAbENOShalB+5NM/pTejsoAtAFcRcDLOa5tNoNvyrd8OEnafRzgpAE
	CB7dalFMXouEz1Oc3m4nXOgD8qD5P7U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C82VoaDh;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764272020; a=rsa-sha256;
	cv=none;
	b=DfeE0mbzciZqJn+lhb5VvfBQ7F4A11YeW29v1BjnxQwThHb6bBGAMAYXZwvS35t/o+ApCI
	KXcQz3SISQ2G8zm4knN7N2UUW+cZTHVs8KL5i+TyHhL09GB61I/FeoGGzgKEdb8VUF4iNm
	/jaKDwNIN2snsJsqL5Lg5E9t6UJVNfA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C36E6014D;
	Thu, 27 Nov 2025 19:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F48C4CEF8;
	Thu, 27 Nov 2025 19:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764272019;
	bh=bKwbRmbrl+X8raFsxUCv3iqsRGv3g/qP8jWuzhz/5xo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=C82VoaDhd0sLSQSLoV+c3099bDHqryfKIwdPCaSkPbMob2hxR6Mo96WsptlVjIgXk
	 uP97+DGgersxABmCaWxwVwO/9cRncMCk679v0utJXbOe3eUAoBEmHyUK962izBaUuz
	 ghigxFj1nYps4+6cypgfSmpBaKlAIGYwIYKpVSas=
Date: Thu, 27 Nov 2025 11:33:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, David
 Hildenbrand <david@redhat.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Vlastimil
 Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Chris Li
 <chrisl@kernel.org>, SeongJae Park <sj@kernel.org>, Matthew Wilcox
 <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
 <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou
 <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, Miaohe Lin
 <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Pedro
 Falcato <pfalcato@suse.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, Rik
 van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins
 <hughd@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 14/16] mm: remove is_hugetlb_entry_[migration,
 hwpoisoned]()
Message-Id: <20251127113337.c6a897e0b786d56084d23025@linux-foundation.org>
In-Reply-To: <66178124-ebdf-4e23-b8ca-ed3eb8030c81@lucifer.local>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
	<0e92d6924d3de88cd014ce1c53e20edc08fc152e.1762812360.git.lorenzo.stoakes@oracle.com>
	<66178124-ebdf-4e23-b8ca-ed3eb8030c81@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E9C5118000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: yk1sqqa674ooq1c9wy4jrch6kpxk1u17
X-HE-Tag: 1764272020-561939
X-HE-Meta: U2FsdGVkX1+gQIW6OM93YFxVThcPC8uqagqdsoYGiqhnrW0WulnfrzB7OkpWLbAyRvX0cFELJn7vQ3crmD91HGg+wwUe3RwaQJ/gWeJEIjGezaUHFAm5y5POwu1Shn2WP0/NtHooAXZ76ROOzZxvY2tbPcIwXHXP0y4SYcoKuFIZ7pmk8oWxqcXCVo+z8NIRMY1d5oYQ4yNL3kDyLCKyDIN1TElogcFLeYtnFmdqX4wlS1ZzpKOLk9gw21f6KZy696qV58+6tFkH+lse/gbUvYsVTMgoroftlGUxJTkYiVjC7YW2R5ObLsbzWWjaeo80tAxhhZVTjJQ+yZKGo81ZS0yWeWti5fU4OKOv+8geBXhPnmjBLYjQf0PQwm4iWRVULC4qCTOSMgBeTkv+Z7pDINfQlpeegL3iz2rk7nrZdC+Azw8TKBZz02kRQW0nZwmgWI0Cl1wL6I9hv5DXgwCWi0LO/nUzzCSasH1xyHugyApd03zvJ3YKPf04WTW5dVoTuxtJdE46/ZuBcb+AI6+h4oRAqhkIwqz4VUFictJppHCfIqVBEfV0eHjPeC2fmpYvjYa2Q5YSIlPnm61c1jHkxwVpBobqf4g27HTi4MsLogzUn4B3TYka2WrI4P/39qterRlIj00M5dk0rSkeaTHsorMzTw0TGX+EZRlHAQXpmBh2RYuyUEM8KEp5VZ/6e/96wnzV0P3RPdWn0Lm+8jwh8z1cSpEfirI1LY+DKbE7tQ7FDanY89nGcqqKLYAKe1t8PVsY3S9FbnNhKNjxzrIZL+IeMKL9x7US1lrJIeoFJF0H4645qJOt/3sBjFf3vrrlYow5DYohK6FFBm5/91o5VkSx0HwSQPJB0XgVVJM+FF6dp4edTfnYh255xOBKQ+7JIx2ozt5JrgHzuewYbeT0iYmG0spXoGlzDeHiKcablFVALVovWl5J8hrCpqZvcwS72NjGoUyUjdA8JRaKv9x
 PKNSz9sb
 GY9KoQ2rDYAeKPQz7Y6a14URO18VTDqkMFtxXaHtDrI88YuZNMeuoTe+/55Y2cQ2HSDn+66b6VQPL4/9vppiFO5DL2w3PA9kG9RXxH91QouNv7omIxo+cV94xUXMiuvbzhTnRvdFs1loLIEiQ5YfNPrStK7UCYe7SCRocbKYoicsxZ+u5kNvAUxZsozeqrp7H9H/VkMnxZtyDATZmoRHLoSmd890gkeN9s5bh7YslwxoNDmYnNqofb4X0DzxXzooe5OCBIESFl+W/lOM4UlsQmARFoObzFzA2Prtt0u2T4OaDQc5ycfEvDZ/ViRMD4BxyR+oBMubJ91pbj8AZMtQy/YaPa3oQSWzcl7XDBa26rKG3TnA6ZwJs6n3zVf8NAULmqtO4GME+2v+NO8o6o9pIvXyYsjRGSXNWajHSr+I7pHdDW1kQB7dlrYGRsQ28ftdWrjW/TxD+qwlT2OdBv4rD80MZQkcB2dMDG/tZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Nov 2025 17:45:17 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Hi Andrew,
> 
> Please apply this fix.
> 

The offending patch is in mm-stable now, so I'll do this as a
hey-git-made-me-add-a-bisection-hole commit.


From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fs/proc/task_mmu.c: fix make_uffd_wp_huge_pte() huge pte handling
Date: Thu, 27 Nov 2025 17:45:17 +0000

make_uffd_wp_huge_pte() should return after handling a huge_pte_none()
pte.

Link: https://lkml.kernel.org/r/66178124-ebdf-4e23-b8ca-ed3eb8030c81@lucifer.local
Fixes: 03bfbc3ad6e4 ("mm: remove is_hugetlb_entry_[migration, hwpoisoned]()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Closes: https://lkml.kernel.org/r/dc483db3-be4d-45f7-8b40-a28f5d8f5738@suse.cz
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-fix-make_uffd_wp_huge_pte-huge-pte-handling
+++ a/fs/proc/task_mmu.c
@@ -2500,9 +2500,11 @@ static void make_uffd_wp_huge_pte(struct
 	const unsigned long psize = huge_page_size(hstate_vma(vma));
 	softleaf_t entry;
 
-	if (huge_pte_none(ptent))
+	if (huge_pte_none(ptent)) {
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
 				make_pte_marker(PTE_MARKER_UFFD_WP), psize);
+		return;
+	}
 
 	entry = softleaf_from_pte(ptent);
 	if (softleaf_is_hwpoison(entry) || softleaf_is_marker(entry))
_


