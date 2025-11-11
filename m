Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B647CCFA13
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 00:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22878E000B; Mon, 10 Nov 2025 19:23:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BACD48E0003; Mon, 10 Nov 2025 19:23:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74618E000B; Mon, 10 Nov 2025 19:23:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0FE8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 19:23:19 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C6B712CC96
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 00:23:19 +0000 (UTC)
X-FDA: 84096426918.15.A8C3D60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 690BCC000B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 00:23:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="pBK+uz/9";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762820597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhCU1wl+0WRiNZkcInDb6pihu5NuBMB+5m3WCnvHHos=;
	b=JQhUhy84av5k03y8o4illMYD6l4uNFV7nsOI1DeUlzcnPk/TlIl0dvkPitTbL4UUYDvgzY
	A1lI2IfH10ET9sCdqjXlSpKDT4ClEPX4UsL4MWzZocygAIXlMUFct0HNZNdmH4ItAwH1mp
	x1TulolAuoIyj3VAUdn7HJN9slJNLnc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="pBK+uz/9";
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762820597; a=rsa-sha256;
	cv=none;
	b=ddxM3X+ywMaV43lKcAGYac1DQCYjlporfV22bEgBQavNlp5NckrKlRMvMhIAeti6LXtw4g
	EexAz+yyBPP4OLg23JppA9OOq6pJZYNK9u/JiHHKe8D0R7ZIUU1kRJjo5RvU1ZbaAuI4se
	t9gTB7N9VA59pbj+BXr7S8OFXViqujA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C8D44428B;
	Tue, 11 Nov 2025 00:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8D1C19425;
	Tue, 11 Nov 2025 00:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762820596;
	bh=gHyaL6pqvKbF/42T+jG0a6a0x8S6QYiyQ3WK/gyAZKs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pBK+uz/9B/7dT4Dfr1fmhdpoHhdxbIQqjTbyre/CkikfJY2PM+IIamTL2ZV0BAKI6
	 KK/J5MjNOlWuttzCb4ScA2sCUxaN79WlqRq+Yt72sQj5jhbtkPdo/BxnO6J7GWbfms
	 VP61krwUmcnmNbdLHyOdfy1bZLglbb1ntnV/rcd8=
Date: Mon, 10 Nov 2025 16:23:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Chris Li
 <chrisl@kernel.org>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, Alexander
 Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, Peter Xu
 <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Arnd Bergmann
 <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
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
 <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, SeongJae Park
 <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn
 <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Pedro Falcato <pfalcato@suse.de>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry.yoo@oracle.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v2 00/16] mm: remove is_swap_[pte, pmd]() + non-swap
 entries, introduce leaf entries
Message-Id: <20251110162313.baee36f4815b3aeb3f12921e@linux-foundation.org>
In-Reply-To: <c9e3ad0e-02ef-077c-c12c-f72057eb7817@google.com>
References: <cover.1762621567.git.lorenzo.stoakes@oracle.com>
	<CACePvbVq3kFtrue2smXRSZ86+EuNVf6q+awQnU-n7=Q4x7U9Lw@mail.gmail.com>
	<5b60f6e8-7eab-4518-808a-b34331662da5@lucifer.local>
	<CACePvbUvQu+So7OoUbJTMLODz8YDAOgWaM8A-RXFj2U_Qc-dng@mail.gmail.com>
	<3c0e9dd0-70ac-4588-813b-ffb24d40f067@lucifer.local>
	<c9e3ad0e-02ef-077c-c12c-f72057eb7817@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 690BCC000B
X-Stat-Signature: kkbe8ahnb76fnpq9ash4p3pfprayzeta
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762820597-813484
X-HE-Meta: U2FsdGVkX1/G0h18wv//Q9wXQx+GEXnO3RIU8gcJ+v/MYxFNQYHBdyarFiqIGp0gRWPB/3vEOWCzVzZk4GCxg9loYttLUsQIizRcF3AhdK3ZXbokmHo9gYp1g5bdOw4n7kLiZaLLtVsbAOd0fOI1flV+eXvBsZuc62EAaCS7Uv6Lzxi59Tpw5ePoKdXLuhKSAZfHbIfirLIRBNNAJ3HLEO12D0YMHBkYcfqJgCAs8/jKheicywU64B6LAtLtNc/hyc3Kne7AcWhGYeua3DqIyyC54dVmLLR+CwaHTKRmoyw9whzn2oy+0YtYCY9Uwl+Q2D5XADyI5n8SuJQQbgPWYzjDnAjYwmp4KqW8lmzKKtlutaIxQbJgDcnRclHsJvOHfyShxL1aDGgnpfSccPrw/YADu0Xw5JIEkSWzhxKfURDhBENy6pTL4DvxSXkMGyEM7kE9fBnRjxmWDYbb1j0lc/V78PrPVBDmneUer3XHq/FFA4so2SFzKiWUh3aLBmJ9a0+cnh84r4wsFh5Wf8yxnoFbaRJhyTcrGs4VVpTL+vUw2sbZFqfGLUjU+YycB1tDdxPq3pfKwANZQyt6JQCdtFFks8WzNzrbGtF0/10Ve5BqHdSPPgd3JKignEyWaZ6XfNdSaCrP/rlLIgPfN+QOtplBMHrOdh+w9TaJ1KyezRzAmYULGEa4akF9KBOwg4j3mDzVsNfhlAcXj6Yl3ggRVqaFYd74Pb4sYbzh4ZUphOm5UDIBFcXZXTwqsHJtSyWcJDYQtHrFUXPw4ptq/Vbqvoo7fIXPteDO4yrVRAKw4TOh/ITj+FIzhHXG+2E++v2pqA0EVoHocPHNzT491UUuivjxV+IkCPOooL4FGFCvmy6s1EDY2Z9hX0JW3SpZSmfVYW8fIzKXuXiw7REjHFA11QudB6//YsTdc5bDsfywkrbTSw9NbVZZpLCJ5BletsbAceDOeGwmUElaTmaWGQl
 abjVVxIS
 lshfRO2YEwQH0ODo4HX92mn2rKywyWu0k1Fiao7SA56WBBOzTwn55hMrilaWshe2LP8fA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Nov 2025 15:38:55 -0800 (PST) Hugh Dickins <hughd@google.com> wrote:

> > I'm sorry but this is not a reasonable request. I am being as empathetic and
> > kind as I can be here, but this series is proceeding without arbitrary delay.
> > 
> > I will do everything I can to accommodate any concerns or issues you may have
> > here _within reason_ :)
> 
> But Lorenzo, have you even tested your series properly yet, with
> swapping and folio migration and huge pages and tmpfs under load?
> Please do.
> 
> I haven't had time to bisect yet, maybe there's nothing more needed
> than a one-liner fix somewhere; but from my experience it is not yet
> ready for inclusion in mm and next - it stops testing other folks' work.
> 
> I haven't tried today's v3, but from the cover letter of differences,
> it didn't look like much of importance is fixed since v2: which
> (after a profusion of "Bad swap offet entry 3ffffffffffff" messages,
> not seen with v1, and probably not really serious) soon hits an Oops
> or a BUG or something (as v1 did) - I don't have any logs or notes
> to give yet, just forewarning before pursuing later in the day.
> 
> If you think v3 has fixed real crashes under load, please say so:
> otherwise, I doubt it's worth Andrew hurrying to replace v2 by v3.

Oh.  Thanks.  I'll move the v3 series into mm-new for now.


