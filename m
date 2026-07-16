Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A9C9C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 16:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CF1A6B008A; Thu, 16 Jul 2026 12:04:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2807E6B0095; Thu, 16 Jul 2026 12:04:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147C46B0138; Thu, 16 Jul 2026 12:04:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7A3A6B008A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:04:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A29816021A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:04:43 +0000 (UTC)
X-FDA: 84995112846.05.5F4B762
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf07.hostedemail.com (Postfix) with ESMTP id 10D604000B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 16:04:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Xsgwr6/T";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784217881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tz9IYBII36hEmZ8WCkdw0Poo/VwDhmKC5JCuOyne4eQ=;
	b=EIJmO6Zts4JeDSG6rXKgiDEKkNnrK3bhKixKDTWgMxoceA4tQXQ2kclVnU2ttIuC+G6GAD
	gEP/D+y0yLDy6E0ces7TqY8GsYTIrt5O9UDRYOJD82ixIa4k6x8fzrI3hWqoQPMuyVMR8G
	+5t5qfuQ/fh/ja3ke5K83+qijQgmhqY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Xsgwr6/T";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784217881;
	b=egivlSV7qaZew+NuYFAnX6Y03JTwHuEUaPwRyM+t9qP8RbtBfjiiNYkUHDeXdll954Mbm1
	Njzmy4r/oZHEk20uePy1kVpJ5UemB3aSY9IsoHW8/dvL84lIM7LZFf4oN7RWOB4u1IMLmc
	zLYqPkOee9kMH692/62JfT2Bn9gmJg8=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784217878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tz9IYBII36hEmZ8WCkdw0Poo/VwDhmKC5JCuOyne4eQ=;
	b=Xsgwr6/T1iv1KWaE1PuNvf4s/O+/mxi0r+dxIsV2UrtO3cqwbAo/F13cifsh5A4y30WL0M
	OAfBvENtdO2+WNOtB8b1YZ9VkWLo9N61R3G0xE+YVfNijzJSDAweY+G+J3yVeHK+S33Z3J
	u3V4cUBGDVOKcydQVkb+bPN6FkiL5cw=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 Jul 2026 16:04:30 +0000
Message-Id: <DK04G61IJ7OP.6MAP7T3WSU2C@linux.dev>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-fsdevel@vger.kernel.org>, <iommu@lists.linux.dev>,
 <loongarch@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] mm: move internal mempolicy APIs to new internal
 header
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Matthew
 Wilcox (Oracle)" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>,
 "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hugh Dickins" <hughd@google.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Chris Li" <chrisl@kernel.org>, "Kairui
 Song" <kasong@tencent.com>, "Kemeng Shi" <shikemeng@huaweicloud.com>, "Nhat
 Pham" <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry
 Song" <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Joerg
 Roedel (AMD)" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Huacai Chen" <chenhuacai@kernel.org>,
 "WANG Xuerui" <kernel@xen0n.name>, "Thomas Gleixner" <tglx@kernel.org>,
 "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>,
 "NeilBrown" <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>,
 "Dai Ngo" <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Trond
 Myklebust" <trondmy@kernel.org>, "Anna Schumaker" <anna@kernel.org>, "David
 S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>,
 "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>,
 "Simon Horman" <horms@kernel.org>
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
 <20260716-folio-alloc-cleanups-v1-1-5363b8e92d33@google.com>
 <73d3c545-dd8a-4131-9826-1a7096dd619a@kernel.org>
In-Reply-To: <73d3c545-dd8a-4131-9826-1a7096dd619a@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 10D604000B
X-Stat-Signature: boo85q1utdz6cp3h3a8h85yxf85r9ugm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784217880-528308
X-HE-Meta: U2FsdGVkX1/p+GJoyYO0bDiy0eISa2LqwNTx2gCnw8BsR4mOocjz4LVZMhIplGbVwn0YG/nNt37LN9e7gOzCoXKm/kPxrtUXNhWCAe7UmHX37qX7rdRCgpHvuee0RWxFWibolT7ozQPrcQvtP4KIkaV/6HQ7ugO0oZlYeaH3n9UpnXCkVEof1w5fsdhxX2x4ICnh2ZNDh0iawY1evpzzQvK2hLiRLliJhBE3ftVhOXvHJYnj+M/C/uQMCTT8asjwmZYluKObQblsUHq5sqNeb9szyl5GqzFbn9IJlXurEtH05g9hln+Y3hZG6sycM+kJJ6T1/h0QEDDcu0HYAitSPQ1NDI553LjmgN0T86zoekwrjyqeC4EVWkuYn+OoBrDk0vDl4jIASs75LVDoM6RlJ9Bp1aC3RIl4CcI/TUPmgW8udpXBDzhd9xqw33jy5sX8gC++U6f6yCtlBsHeyQYJD3VwDAMxR+I/OtGZNrKAUbYwhio9I0eJ0lO+lhYwPCNiVaEWi6iPAdOurM6zdZVtbYC9G8zhjVpxiHauBFZ6Z0CtWnzTktcmWlJs9l7kQFevrxWYmkQGb5ZreTQa7bmwvi9XrcfovV94icQ+9H5rhcMH0NSOe9/MQ32DnSCPQN1pVu4AlikQTDYFr6SoE8MK3anqYVU9U3qJTlV77uIYxIufyDdFYnHKL2Mz0YWKHeDNozto2eS4Ne+5hWVzxWM+mdRMlSpcBv5IQDCxWsAZ90DW9G3pnajaEYso9xtrXqi11oe2cLyIxozOPvlk2BWRqsOSoR32SQ4AeVz65WQLPmOGba0IuGgYA5mPDZy1HRrF1M8rvMFQ4WmSOP4/QFu0pl/vj7l+8VvJn3OZ2IXwOMCJ/JVxP5uL+dzbkDAf34Cxrdk1xIKXZNp9N2h8oGGQBnoXhOMQsm0XlCQ4nwamc/biGmxQHOK/LZsrkIi4B+k0uy/vNfz5AoNQbEp6HfS
 O/r6opIa
 NpXCcXe4wj8Z7fx4d7eaVyqj8mFhWe8F2UqtT0z5GYSV090UqS7INL2S6nvRXdUnrbtL0bz/ZDM4BnFm3KTxi2pB3QNk23YDHfm6UQWu2oe/E0RLJVt7M/Mt/K+xjBz2fsQT75FcFQmvcDqSzFchWPi1JI8jWkBC/+e/MaarxfNlZkD4WLArRcOMd7ccFiQZOyoCjR2g98bNEhBVE4TmNuTinCDcqh9QhlKUrm/lo/o+nf1ROQK9W0fU+8LOFTqPGsbBsrC+ve2xd4Vy5bCsKT55EiCddCARahoczZjxqG3vNVZ2uRWRbHHMAqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 16, 2026 at 3:22 PM UTC, Vlastimil Babka (SUSE) wrote:
> On 7/16/26 16:30, Brendan Jackman wrote:
>> There are no external users for this surface, reduce the scope.
>>=20
>> Ulterior motive: a later patch will add an alloc_flags arg to some parts
>> of this.
>>=20
>> Note it might seem like this could just go in internal.h, since it's
>> pretty small, but actually it will eventually need to import
>> page_alloc.h, we don't want to import that from internal.h so best to
>> proactively created this header now.
>
> Hmm, maybe it could just go to page_alloc.h then? After all this is just
> bunch of internal page allocation functions, which just take the mempolic=
y
> pointer?

That would work AFAICS, but I think it's quite tidy that, currently, all
functions declared in page_alloc.h are defined in page_alloc.c. This
would break that.

If you're certain you don't care about that then I could live with using
page_alloc.h.

