Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31759CA0FED
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 548BA8E0040; Mon, 25 Aug 2025 10:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520B98E0038; Mon, 25 Aug 2025 10:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436BB8E0040; Mon, 25 Aug 2025 10:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30F7D8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:59:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECD8714040B
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:59:42 +0000 (UTC)
X-FDA: 83815589004.05.1DD7524
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6363440004
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:59:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jn0AZo3p;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkD+sthOFrkZQBgyD/Brdao7sTCKGDTnrvrWEf6+780=;
	b=SeGfzmgB6tLpfRJbOHVJNVXMkxtGSjiJRXqk2aFeQNujyCMngUcGN98brP3RPwJAczXPr7
	X/sjqcGq85ta/5MhfRa4f/sgHZAG9mBbiQTzIroSkbY9ZgqrbzGiVvalgnaAtLMQHe42Lm
	6V4ws7wKqtD1Yzw8Zk0LfgSmftJN9VQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jn0AZo3p;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133981; a=rsa-sha256;
	cv=none;
	b=MjGjariw1tw9pHRzGKzhBrIWrC6gBkZkEoBAGE/vq7OExO3DcTIDZsUc1iwDjMimyuMaBE
	ExHy6YFRsYmZCJqduroELHmQjrDzCASavLJrBm50KoOMue6gFgkilZ7I40x2KqLAiAZsmC
	AsxEBKeQbUWf+YJ9A2YF4DFDN+lTcJk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id EDFB95C5988;
	Mon, 25 Aug 2025 14:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3D6C4CEED;
	Mon, 25 Aug 2025 14:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756133979;
	bh=YtWwiemXxXk/HndwfafEfgJsQeylyFu02jnoMvbgzgo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jn0AZo3pPFK0BugUL3OMCDpCV1HmeNy40TLdNKtLX5SypUoRptbAF9EKk4ejmZPkz
	 4+fhto2i95Q8o+P1Az66DJeNk8sJ/NyNwPVZIk6s6vBe389Ho9bI4oPnQEWOp80T7O
	 GtLnp1xpVgMb/AC15WB27oS0HJcJwkR6UUktQVbU3ti8iXBP/sjXLozRWAuvgf0GjM
	 wZgTeBgQn1M3OOuOkCDIwQMCPIaP4blPKHTb9cXNDnLZlHu07Wyh1OfkyGZAnS83zw
	 dhcVTO4etdblD/32knv8disDXUulJuw7B97TzcOXKyT3A66aD23GWc4jfTztl6wlSw
	 r5yMDLTA1mfKw==
Date: Mon, 25 Aug 2025 17:59:22 +0300
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
Message-ID: <aKx6SlYrj_hiPXBB@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-11-david@redhat.com>
 <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
 <7077e09f-6ce9-43ba-8f87-47a290680141@redhat.com>
 <aKmDBobyvEX7ZUWL@kernel.org>
 <a90cf9a3-d662-4239-ad54-7ea917c802a5@redhat.com>
 <aKxz9HLQTflFNYEu@kernel.org>
 <a72080b4-5156-4add-ac7c-1160b44e0dfe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a72080b4-5156-4add-ac7c-1160b44e0dfe@redhat.com>
X-Rspamd-Queue-Id: 6363440004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: mzsyqkxjxe4rt657fbm3ze7spo9wuhu9
X-HE-Tag: 1756133981-575806
X-HE-Meta: U2FsdGVkX1/e/BBdUYNBWUXa0LyNZnbLgUn7j6YecU9hMzMEDSMBbUdJzjQBDx5waJeg4omrjLCLTnI6znrxq4qLHOJ6jRarLbYOPGTkkM1MuX9PFZpe/OAtbS0aBL4qBLyqSbiQGIZujgcVc/RVKmqFV99R7Xw76ZdLKuG7oPHCiWRG4tvhzNRu51tBKt4DgWycGuVY1irPLFf5gJsb6ygKI4vbIk86Y8wr7PObh6pyX3CMjxB8MgMhH4qhPavuWc3gV2E5pSo4JzDJOW5BV3jtXKDoITEkD6nFCeAS7Jy1w64PCcSFW/R83kkPRgSMbEgQjP26giG/0/b2S1BkMlQzha8VIqCeESi3ZUMrUN4pQ6u99dr7rsFL822gMf7nTLYLV+3igJ4P70oqawB9VGnEnQ3eUXjjrEgpzEnoiSYzoJ0/ZL1SqghN/OnYiA5+EsNzq/Gs8BLRVTF4pOQUbIvC+cLhbJWVrooAG6pFJjXviKhC+vM7nifT6eJb+VRJdJbmY2Rev6TC1qnpHNIkM3GCnpuj6b4J/eGsZ7rnduVJqW1xAdA0neR0CeL5hoKhj041MBnFSLA2ulJF0xOu2vSxNKh4O8p+6PSbFIbJ5HmtkYlh3I82eFAp+yVMwuC+Pqa+necumsvS5fC66DtT2qvVQbZqbGmRfwt1LZiph5jV5RvliIU5RfesUn+oBMFNLsVbkxUevz7POxzTPY5gB4p+EDkvNd8T0u016uZJ0nJY5KNR+hKuT1e9mPdIIifRuwMguCI3PiJlmfLNcfWtobZrBBltdoFc5lxLY8FEtEF+tqHufN/YuKzx3t4rrj2b77e81Kr29yux8rwLSuOqTSNUjigHVfWyu6+wWDnTJo+RNA4RzxHCs6PQDjHyLQcqiX01P/Ngt1CAXFq8NVXrgc8R8Gyg/4Iaba+CXmq1T1n7dGR/hJS75PrIFKdtmkua0SLpQ+FZGglrLWJF8xR
 E+UrYHDg
 nHGMm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 04:38:03PM +0200, David Hildenbrand wrote:
> On 25.08.25 16:32, Mike Rapoport wrote:
> > On Mon, Aug 25, 2025 at 02:48:58PM +0200, David Hildenbrand wrote:
> > > On 23.08.25 10:59, Mike Rapoport wrote:
> > > > On Fri, Aug 22, 2025 at 08:24:31AM +0200, David Hildenbrand wrote:
> > > > > On 22.08.25 06:09, Mika Penttilä wrote:
> > > > > > 
> > > > > > On 8/21/25 23:06, David Hildenbrand wrote:
> > > > > > 
> > > > > > > All pages were already initialized and set to PageReserved() with a
> > > > > > > refcount of 1 by MM init code.
> > > > > > 
> > > > > > Just to be sure, how is this working with MEMBLOCK_RSRV_NOINIT, where MM is supposed not to
> > > > > > initialize struct pages?
> > > > > 
> > > > > Excellent point, I did not know about that one.
> > > > > 
> > > > > Spotting that we don't do the same for the head page made me assume that
> > > > > it's just a misuse of __init_single_page().
> > > > > 
> > > > > But the nasty thing is that we use memblock_reserved_mark_noinit() to only
> > > > > mark the tail pages ...
> > > > 
> > > > And even nastier thing is that when CONFIG_DEFERRED_STRUCT_PAGE_INIT is
> > > > disabled struct pages are initialized regardless of
> > > > memblock_reserved_mark_noinit().
> > > > 
> > > > I think this patch should go in before your updates:
> > > 
> > > Shouldn't we fix this in memblock code?
> > > 
> > > Hacking around that in the memblock_reserved_mark_noinit() user sound wrong
> > > -- and nothing in the doc of memblock_reserved_mark_noinit() spells that
> > > behavior out.
> > 
> > We can surely update the docs, but unfortunately I don't see how to avoid
> > hacking around it in hugetlb.
> > Since it's used to optimise HVO even further to the point hugetlb open
> > codes memmap initialization, I think it's fair that it should deal with all
> > possible configurations.
> 
> Remind me, why can't we support memblock_reserved_mark_noinit() when
> CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled?

When CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled we initialize the entire
memmap early (setup_arch()->free_area_init()), and we may have a bunch of
memblock_reserved_mark_noinit() afterwards
 
> -- 
> Cheers
> 
> David / dhildenb
> 

-- 
Sincerely yours,
Mike.

