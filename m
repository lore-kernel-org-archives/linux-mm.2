Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFEFBCA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEACB8E002B; Mon, 25 Aug 2025 10:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2008E0001; Mon, 25 Aug 2025 10:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8468E002B; Mon, 25 Aug 2025 10:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4958E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:32:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B8141A045C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:32:44 +0000 (UTC)
X-FDA: 83815521048.06.D1BF65F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6F26D20007
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:32:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n7YZsnMU;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756132362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7q3aZRioWrrwo6BulP8o1mtOMyDOIQxT+3ZS1iXQjig=;
	b=ryks3NQsytMPLMZHgT5/tvW8mzZbTZFx3C1BR+vcbisfLgPWmqoO329qNlh5RxIA5zprcG
	KYEsSnEEvXtBF5A0BKjRTKp1hK63rOvEwHyLYDvWAmKbRGvezFy84wTovS3GQfAtnMrLPb
	lcW1ZvNfLqblrDn2/LyktU2YwD2e+Ts=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756132362; a=rsa-sha256;
	cv=none;
	b=H2zErLe/ibPUIMtTTloudEG/WxwLDIOYT8z8kmwXIehlXOaC7cWoQ1CQkd7J/aVyHSJ9Vv
	sxDRMq3DBiiyd2yJINGWZSF7da1tj9NFiKAkL7AnN51Q3oY5kVC5GPjhNEwrcC3uPaWPkz
	g/yoFOkzy+yzzXI8duRZ6X5oY0bUESQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n7YZsnMU;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 07341407BB;
	Mon, 25 Aug 2025 14:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28395C4CEED;
	Mon, 25 Aug 2025 14:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756132360;
	bh=DU+1S4Dtf6BzIA9TMfJpqm5TRVwGVofXB+Dj9RHsm1g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n7YZsnMUaPKieR6Aen8NXplrqXq649ng2cWds08Paw0ZE1V9/s04MYuzfMJunBPPM
	 e9q5l/4IYbHR+zLW6tZ3Ain+SM/EPsptEidQNiwcBG+gIXbD0MDb3NpuMIodH9q/bK
	 gfUkw7ZqtLUllteesZei9c9/9Nob4tERnp37xBWgOfA8ssretvfGAj7ddnS1nJ/eSw
	 gYK9m1P9+EEv6DvwLeTd0I1ynl3rIVfEsEIPpMbPhXNcaQgQQCdndA/xeV7DIotpxx
	 J60e7ZU1ZivKd3L40DdBa/CHbHS/SOS0E/lE/sJu2Rz1DevUCKw6IvTf/zpKfAvZXV
	 BIxp/l6R3haNQ==
Date: Mon, 25 Aug 2025 17:32:20 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	linux-kernel@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 10/35] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
Message-ID: <aKxz9HLQTflFNYEu@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-11-david@redhat.com>
 <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
 <7077e09f-6ce9-43ba-8f87-47a290680141@redhat.com>
 <aKmDBobyvEX7ZUWL@kernel.org>
 <a90cf9a3-d662-4239-ad54-7ea917c802a5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a90cf9a3-d662-4239-ad54-7ea917c802a5@redhat.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6F26D20007
X-Stat-Signature: tmx9xwqno6e3e7d47cg46i3aupbdpzpw
X-Rspam-User: 
X-HE-Tag: 1756132362-423653
X-HE-Meta: U2FsdGVkX1/1EjwoIrepzuN2y/m9tQ6yEUuYAf+j/6A96HkZ0qURkC3r5YkXpHdD1PQ/Nsgg8F9wd+OQdWQn392SPCMEBBCiK0lEUhjf8XT+cC4BFzCEnM0oaZdJ5Qf2LRQvZDly6N4n844QX4LOqUH++8iamgIf9zqPYKF3/D1YiEOewi0psmur5VwhxVjp5tarRIKAN1II3IfwrPkY+5uIZBTPT4QmkYFBWI+NbjCiWEjPvxOM/0Kp7fCcZdH+SAGboXzoWuxADs+SeqSZzpHkz7J1iQQcOkq9uui6yqA4CWjhnOiWeZTBi73vXDAtub4GodIS/DRVA+D43yxCGp8c8x4UsjpZcxmYF36Ob5EhvfxH7x4vOJ9OA/D6MlmI2+0Kz/MXQ4XKeask4EV7/n+YuHeneCaE1F6HFhZ0DfhARhkJt/pKwXRhyiQLdGpNnHSjpV7ELlfbsBMAZxOCZRFxS3EFeDmGtA4qttZquSqzAj7xW3cOqlq+INod6ZxaOV4Zb17bfU9gbOJZcu1zP24j/hJtSYRAbp7U4H5y7p0P8tDZ1Mli2xEIJQsGaeXQXtUb3QkQEM9oMyoV/ERZR/GwAGmsVmHeS+QhozwQmrAorQz/4qy4R0Jrx8yb4bjs5M/VT1E409k7mzYoD+WEIXKuRvom3rIr28JeWQEDE0I4Th43fLuOZ7edPt+z0csBar4vZcen30AHq5ll3kWgoKZrsKZO3wtark+mLA7jUe86ew9IufJ+Ywr1D80RG3gP4KbytBBZq6nSILP5eWLy7ajuSvovZ9ytM3DQTxZI0Q8wixmyxcqIbQi3zj1lPSAXUMT3vFpfHo5s8MvLxvNL8wOd6L75Kj+JGtnkmrEhDL73aQWG747psbJW/NjI/UNLDYFjQqy07MA2oGfAxWUj2ham2XUKlvCbJQMwE+U14V3s3pjyO5hDkl2i6RIWo3DpBfDMH13kO+gu1XCJ8Sz
 S4UbS3FX
 jab5yTyewERqSteF2AV70K1V2nUBZrIgRXFkaNB+9Kauq2+g9tCQMl8G1/4TEMBJphyC9Slo+BK4ic/TIjQu8ZBN1vvhk18oXbNzGVYR6EnsfXnArDvz+PnLPdWms8ayWDBMMjr0AWYzJ1W3vsUtTchkWWr3mtafc7bYG1XVOe9joYU9DjVTNnfDT1bIVuNVfeisJqADAfh1kuAQ7OguOXfcQ7jONBDgKYIayFgVH2EfM60boAq7HNT2VSstoxSGQpDN1uONu/Ihuj661OnxCfd9PoMprMSHraeiuCcSM67qQmb+P3Dw2Id7KH+6sfK+P7Wg+MGgfNrp0728=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 02:48:58PM +0200, David Hildenbrand wrote:
> On 23.08.25 10:59, Mike Rapoport wrote:
> > On Fri, Aug 22, 2025 at 08:24:31AM +0200, David Hildenbrand wrote:
> > > On 22.08.25 06:09, Mika Penttilä wrote:
> > > > 
> > > > On 8/21/25 23:06, David Hildenbrand wrote:
> > > > 
> > > > > All pages were already initialized and set to PageReserved() with a
> > > > > refcount of 1 by MM init code.
> > > > 
> > > > Just to be sure, how is this working with MEMBLOCK_RSRV_NOINIT, where MM is supposed not to
> > > > initialize struct pages?
> > > 
> > > Excellent point, I did not know about that one.
> > > 
> > > Spotting that we don't do the same for the head page made me assume that
> > > it's just a misuse of __init_single_page().
> > > 
> > > But the nasty thing is that we use memblock_reserved_mark_noinit() to only
> > > mark the tail pages ...
> > 
> > And even nastier thing is that when CONFIG_DEFERRED_STRUCT_PAGE_INIT is
> > disabled struct pages are initialized regardless of
> > memblock_reserved_mark_noinit().
> > 
> > I think this patch should go in before your updates:
> 
> Shouldn't we fix this in memblock code?
> 
> Hacking around that in the memblock_reserved_mark_noinit() user sound wrong
> -- and nothing in the doc of memblock_reserved_mark_noinit() spells that
> behavior out.

We can surely update the docs, but unfortunately I don't see how to avoid
hacking around it in hugetlb. 
Since it's used to optimise HVO even further to the point hugetlb open
codes memmap initialization, I think it's fair that it should deal with all
possible configurations.
 
> -- 
> Cheers
> 
> David / dhildenb
> 
> 

-- 
Sincerely yours,
Mike.

