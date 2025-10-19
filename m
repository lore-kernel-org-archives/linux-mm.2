Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F452CCD193
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 00:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CCC28E0003; Sat, 18 Oct 2025 20:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67DF98E0002; Sat, 18 Oct 2025 20:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5938E8E0003; Sat, 18 Oct 2025 20:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 480608E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 20:31:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E52241604C5
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 00:31:11 +0000 (UTC)
X-FDA: 84012984342.17.B642CBE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 00B68C0006
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 00:31:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YxoWqhT3
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760833869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obiIiWXrbpLkc3mvTBdVrdtNhB5OOJsd4njuEApkCqg=;
	b=xzCFM4IEByUvxluFTYRRXddeXmJ2hVUU0X9zNrPEgwCX2SnCFmV+iZ4aivhcsRawdlK5Ww
	ZOcyYt2lwYtJn8k1lVKGgg+ZKpyqMaeAihbvgtLDO24YJ6Zw5rZyRVpgF74pZQNyNJag3+
	K4KtJJJCxdgA5BLOXDhgEld36zYJ1NU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760833869; a=rsa-sha256;
	cv=none;
	b=HZkluO1gDhe8P03d2mNkLS8NFJjmWOwxm43cwe5qyYAbgy4Je1kcedSnLuJbBVGnDkWH4e
	eBHyFrwOWMVKfTvj16xICj1U4hVSHuw890CbMQugeTgCLnNAZMDFhJHLqAb1uZR+2z1u28
	Nz/MKN+8Nv3F58L0TpQq8LlTPIU9Sas=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YxoWqhT3;
	dmarc=none;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=obiIiWXrbpLkc3mvTBdVrdtNhB5OOJsd4njuEApkCqg=; b=YxoWqhT3EO3YgwuL82eCnE6ZM6
	cmRuUXUabSlX5GEZ6Ul79GcjPqjua02/dLakywJXS2RPOzu+usjGcDAwngL2UUanrCou1X3wlNzWJ
	9A0UDIvNQU7LtoFNtOg9b1cqw7OUOGGmQSdgNxRtip/BaJifbpHtWaivgxPsGgxeCVDxIWKoV3mws
	e3xh7T7BoX1lQPGuYACttufPUjtUM9om7ExPkJp/9LHH3oTzJFpjWEYy8zxiG41YMO9QTiV0iXwVX
	CVdz31ZHOqAdmsD4elReFtav5/3a13M12aISa3WSpm/hgffczsMBPdvBxAkiLWrG2lyKQ4DksNWct
	fmN+Rzaw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vAHJv-00000000YBi-1hlF;
	Sun, 19 Oct 2025 00:30:47 +0000
Date: Sun, 19 Oct 2025 01:30:47 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] mm: treewide: make get_free_pages() and return void *
Message-ID: <aPQxN7-FeFB6vTuv@casper.infradead.org>
References: <20251018093002.3660549-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018093002.3660549-1-rppt@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 00B68C0006
X-Rspamd-Server: rspam02
X-Stat-Signature: cfk95ngcn7j7j5kcxoox8gtazeoadbz3
X-HE-Tag: 1760833868-796959
X-HE-Meta: U2FsdGVkX18dWt+p57VkjSSi2tWHuH09VmwXStYOrRKimVO9jRIXVjTrN6DxjPRMtLtN9ZbvBP2x/qiOMsEpmJvP0xPqQfk2HdM8vzjZqy6WTMNsyv+Es6dwGP6N/Ad4mQveOCjcx4o8WmbTB4ArM9NlTPT3Y8UOFI80KfdCQtDf/fFvc/su8ic0M0CDTar6+dxzz0ggiGPOg02LGMuyN/bDY7IrT4upgvZcKhOIbijSh9zL55yyqTu8RJ1ZtTvvqgDwQn+B0Eh8LKZxYv0KodpZmxiFRySOmsdfwKEBiAxwl4XbDQle7gVZRuVpoi8DjI1jSGEm8/+kGwyei8jn8Fdps+Yjqtj779T4D5OHdjRGczyFugiIiOT90v5HwlBBY8HWCwMITNEoXag/ZoKh+EFUx5VDYumEq8by1xE3zIKtgmDm83mnm8KQAn4KbmOKipnXXkfFbowTgBKkvYKKcDD+x5c3FkonDQ7caXxKuqulIwbYwbBFfoTp3EhY4QwEUDqVDDIN6f358r1zHZ8rhz/uO0J83fKYz84P05i+GLaX5uR72KPxiXPYzFXMT5rjqmTi/LoO94iYxcDgJrqoT6NtXa+3X3TOg7NTLp8fQqKhcy/uQZmlk4iQf6VzzgUYqYetbOBuUkZgDf8M+d6GKKYMXLtMVNyJ8LkSZc0cWjp87ySJs6+hA22hPoj+DvZBOk5QcAzzMYCK0wJmarzo9hXc7ko5p6B5PA5J759GyIzeWD+WaEAKaTSZi8//6hxINAGwiELJtm3hyR1r9JrBod9ZQr9NAgPA0kqwvByyqerYFBiUQDsE2uZo4WyGxSq6y0s/pRtqmbdRNLihx7j3F0RTnQD9dhJZJvBA8zAX9UT+3ZrDqAXQlf/2w9Q9Pz76hs8ilcu8NKHT525vTxmv1Ns17+187imzugApXqGI70htBRtmoWh5fSsQ/FVZgEMmkR52NvOlAF/SXIswGr1
 jEJnorWy
 uF+MTOeTuVD00S5UYcmN8X/YshbDHKPzqA+J7S4u8KA3iWDzC1YpHwLmJdPlFrk4Trx6cNnPFr3q/a3Ca5TlO3VMAHyaF8X6TuvnUXgSCPhap2m2f1nE89/gRUcsJ6Ai7bGM6OTgMqZirRDObNOB1wjIs8/1Yd0idXgPKTJqwVNB8eWaDAUonMfrZUCE2B53YxHmuG/jVZN3Q+n2Q77L8tN/oTCEUwQljGIQX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 18, 2025 at 12:29:59PM +0300, Mike Rapoport wrote:
> Vast majority of allocations that use get_free_pages() and its derivatives
> cast the returned unsigned long to a pointer and then cast it back to
> unsigned long when freeing the memory.
> 
> These castings are useless and only obfuscate the code.
> 
> Make get_free_pages() and friends return 'void *' and free_pages() accept
> 'void *' as its address parameter.

No.  Linus has rejected this change before.  I can't find it now, it was
a long time ago.  Most of them shouldn't be using get_free_pages() at
all, they should be using kmalloc().

