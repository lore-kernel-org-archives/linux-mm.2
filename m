Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 611C3CCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 18:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B1C98E0006; Sat,  8 Nov 2025 13:01:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761FE8E0003; Sat,  8 Nov 2025 13:01:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651358E0006; Sat,  8 Nov 2025 13:01:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8B98E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 13:01:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08475140812
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 18:01:10 +0000 (UTC)
X-FDA: 84088206300.17.F53CE02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3405E100015
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 18:01:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oDUv3HSn;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762624868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GiBoPXBJufdX5B3STDLZ2n5iNuptKizgzFgu85Zt+VQ=;
	b=WF9hYSCua2yB0yKXHBRQW7nCgrMwJ+yCGoNtkxrXRjBZs0YJxu/m3Bly9tobmrTblPIDtC
	0us7rP53qor/LX9A56KfwVzY/6PSnAFFiDVEb8UZ6lBj/G3lQEodo7T5r4vDQuwYRJTO6y
	pGIPFU2yEHBroPt6uP0A/N3OSyTtQmU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oDUv3HSn;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762624868; a=rsa-sha256;
	cv=none;
	b=2XaqyEEfKveRAQ+VMsSb9e9ZQuE6YNAcGNDwc5jX699cAcKmdBgnpBrt2NZYo1sUza0VH9
	L7mjvGuXo9CBwHGZyO5Jq2c8dlVC1CgZ7ld+/H25TYGMyCCfnLnZpB3JYB9N5NBxnUR3mY
	Ve3aIpDYoaCgEc9DVq8y0lzug0nSolQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CDED6405B3;
	Sat,  8 Nov 2025 18:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDFDC4CEFB;
	Sat,  8 Nov 2025 18:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762624866;
	bh=WY8ReV6b5rLneuyL9AKjyd/kw56HVWU1CULr7FLVHP4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oDUv3HSnjIfwPyFkFpXgxuM9gpIrqWGxlj+VbGgMDqQY7mvSx4LjzbZNiu+GyW66l
	 sBSmHMFXObgsrY/JwizQJcL8IlCvpaHLDnEETtyGW2/R+vrTgZKu9v3oCok35vTcqF
	 jmex0BTITiOowYk1xFcmp3KlwKUu3Iwim/OcS0ek=
Date: Sat, 8 Nov 2025 10:01:04 -0800
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
Subject: Re: [PATCH v2 00/16] mm: remove is_swap_[pte, pmd]() + non-swap
 entries, introduce leaf entries
Message-Id: <20251108100104.bb9fc75f97b9263af7e5673b@linux-foundation.org>
In-Reply-To: <cover.1762621567.git.lorenzo.stoakes@oracle.com>
References: <cover.1762621567.git.lorenzo.stoakes@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3405E100015
X-Stat-Signature: j3wj7eq7xfk6xdk641sjqk5qbt9d5wcr
X-Rspam-User: 
X-HE-Tag: 1762624868-34790
X-HE-Meta: U2FsdGVkX19FB1512VKK7QEoE/H7DeeUcuROrr9EHo1Pp77Wa/aM3yyeAY9umDw1IR+MqSKZPafvUzLUfflOGhc2sDoQPzzdD4qOhpsdvRvUUUpMQpOm+K+Llaw+wexSISVdZqdv2UiZhQNlEPGYML9K2Gksou2CHn5quK+LKHr5BnsJGwYKe+JGkYW8+bEp50LgmO8PyeSdX/jE4fNab5MLUIlraLPaL45kRUKqEQbqHpkqz2yEHCyhE9KkwNWKWwHUV31X/TOc8bjDlZK2S5PQYvXqG+ywMF9DXZWE/mS54+RYsmeL8+AG1mXtPpGSw8SIHMUpFx4bU30Yt/khxpgaylf/7REL43KIAzpzS2xrHF4aTFhUC0fBWtAU0xzs5UaPEAlBKSWKDL/w2rveUChRaFpd+nhipEZA2nC+G3pnLBfdJKir3nNjjeY2zQ/QW7YELuyMXePpwGzVWpjtCQmR+fotodZWVL6egKTjjXiqHGZ/pehnLHE1PcK9J11Zz7sci7zW4Uc8Gr+wh4aQhSTuM3mswrykiI6zuVloZWNjlM1jWmH3cxXlB0mAzFLNh+MAc4xOzEAWzFDOTXSNpBSgPctuDBthzqXVtr+mzisvqLR+LCAP84cMHusMxvb34inFjPtNmrmM8bfEYgvXuR6cSZgnK2NLzYX5OXmIg6dM2GQnKtXdRp471cbUKAp+jDKipHL3sLN21DuMu6jWS5XKJfzepDWlOJLDqhbdfwdUNqYWBV9ojh1FmqX9U8HrhRhgZBb2VIUhGqpKTmqUYbvZuFgi6qSFJNjbhpp2pUidFYnPxuIaP/2XRc5aUHIL6FQPynN3Aj4rwk4qh8ccDnyMs1wE18n0ybcCPrKSaFH3Z0wGt1f4huHW20mPriT+Ne0HM3MsZuUI3c6E6U2XuMFVs3JXHrmtQjwpZW9v3ElKDbamLSIY1IqGPYFa3bFWJud5BMsJje+Y4ycr8u/
 cFbasacc
 SLu2V6IXagpp+Q4vlwMtymCBph8e8VqF23MDFEzsZr38WhrtEuFw69uSI/KgQkbHPYCFwxosJWQKQdUL9eu2mePNywTNPLIusUm/g/kVRXhjvLkdo32LIW7x14X+FdsI45qSMhDjUNIqlMNPzqjga2+/OebY3wALEte+Z2/+RAh4lwvTnd1eIOPqGdumdzNA1eaXAjST29WB/a4MF1a8rWYuE2BIj85d0YuPZ7YI2Vs5PtjqGnnYhL2UENesTjPYegsoGeR9XFkS12rkVQEIBc2Avh+7VHTra6yAB1fuPszxY8o8hF3I8n/TdHs+eAHoJ0jvCmo+ZbhrGUnp4Uk7AeDR21VL2LbPlhPPWeKtNh5skYY9rS4E8DvSwYHxzQ4ReHztpMGpGBNa4Eo0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  8 Nov 2025 17:08:14 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> There's an established convention in the kernel that we treat leaf page
> tables (so far at the PTE, PMD level) as containing 'swap entries' should
> they be neither empty (i.e. p**_none() evaluating true) nor present
> (i.e. p**_present() evaluating true).
> 
> However, at the same time we also have helper predicates - is_swap_pte(),
> is_swap_pmd() - which are inconsistently used.
> 
> This is problematic, as it is logical to assume that should somebody wish
> to operate upon a page table swap entry they should first check to see if
> it is in fact one.
> 
> It also implies that perhaps, in future, we might introduce a non-present,
> none page table entry that is not a swap entry.
> 
> This series resolves this issue by systematically eliminating all use of
> the is_swap_pte() and is swap_pmd() predicates so we retain only the
> convention that should a leaf page table entry be neither none nor present
> it is a swap entry.

Thanks, I've updated mm.git's mm-unstable branch to this v2 series.

