Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5092CCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 16:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8875F8E0005; Fri, 19 Sep 2025 12:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F1F8E0002; Fri, 19 Sep 2025 12:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79BDB8E0005; Fri, 19 Sep 2025 12:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 665B88E0002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:08:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 08A541DF24F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 16:08:28 +0000 (UTC)
X-FDA: 83906482296.29.9C3ED78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 61794A0011
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 16:08:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gxcwNWOd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kbusch@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kbusch@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758298106; a=rsa-sha256;
	cv=none;
	b=Tj5YiPdnRZbKX/quET1ejqMErONR4HagQmGpUcF1GBKloXLFddO3XusacQX3U4h+W3h5AA
	eYeeXwk0nio4VmeM1Dc5zMXVIM+/TA/bLliW+c39OftREe6fXMXkRIPu8gt2lTMUvIoJ4k
	omQIUQb5ox8eWKSUcndguRNrCRxK7n4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gxcwNWOd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kbusch@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kbusch@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758298106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93+iChQy8k9w2vSLxjsMF2tpsbL6StUGENS3z0mFMo0=;
	b=1+XcpLG3Eek8zjBserPTu5Fegngg44xbJxi04bxC5J9U6Qi2rUPJt5KzUqJ9MERTItZDA+
	y75cpxmkY7xxi6RQkS1PExyPi1pDhT5TIJ43G1YhSMjk9dQRkDq7/7dk3DJzunkHdBQyCC
	ttc5yOoBCsfUmu3vXSwIn+rhUDrM+SA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 581BF60140;
	Fri, 19 Sep 2025 16:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C8EC4CEF0;
	Fri, 19 Sep 2025 16:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758298105;
	bh=KR7+2nE82F6C0RiPmuqmiCYxfBNwhzjUQ6Re6K7PmkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gxcwNWOdwyYYCt/Mr4IoNw/QjfiG4fCy9ykIixLtIZgzxpvEaTh0ZrsRzbEkVlnG2
	 m8b1wOyRgj64SHlplGanM4IqWdr6Ywznq35IYlrDTPSiuH1HbSJA9OSV6F3cLQ0fmv
	 gIfqZUpL6QTaZY7lchfgfbbV/HzPQ9GlWuIYB09YAq8LPsugW8lRkDPp3pD3pmqfjH
	 MMDTa/BarqpIPeeM6zxgfbm5MTp42dkz6/ahu8QcAFUE+eO/S+U7a/1bN3BopMvk86
	 +JRB492i+MxOTtI0yVlp8MJ781GY30PjuvtN+/6jEMPcnyQy8X2xhocLeJS5gf/FQl
	 TeUW9JwC+yaOg==
Date: Fri, 19 Sep 2025 10:08:21 -0600
From: Keith Busch <kbusch@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@redhat.com>, iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>, kasan-dev@googlegroups.com,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v6 00/16] dma-mapping: migrate to physical address-based
 API
Message-ID: <aM1_9cS_LGl4GFC5@kbusch-mbp>
References: <CGME20250909132821eucas1p1051ce9e0270ddbf520e105c913fa8db6@eucas1p1.samsung.com>
 <cover.1757423202.git.leonro@nvidia.com>
 <0db9bce5-40df-4cf5-85ab-f032c67d5c71@samsung.com>
 <20250912090327.GU341237@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912090327.GU341237@unreal>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 61794A0011
X-Stat-Signature: noncr1dujjjugtdsyfn3m9jw1uqonexe
X-Rspam-User: 
X-HE-Tag: 1758298106-666242
X-HE-Meta: U2FsdGVkX1+Gz+74U/ds0AypI9BQ/JB8AnNeHL/+fOCrVXGWABrDxrPGYtqWTwEFKp00mrXEdxjbRznZQeJp33JhZuCZSA4eULv6uppWPCP3Uu/kMN7DYmqx21eNemag4TV8gekuFeCwOT44a2XEaZVFLKeutz4qDjIEBpF/X9JQkuvzpNQUdi/mo5UfKHUwFKmT4Bc5d9wOErOKgImEZpqT68xYb7m+ELqU2DD6yv1i73l+2vwz2Zc9TZI+nUIxx9L0YhdFQNnG/zWqVV08EGvbq4pUFjQqdG2o5N9g86uL3D0CkC8+92mdHtJj4dZOFRQtAW9JLs5qutDg6sCQ+tHpfTo0MHxF7MngkzNlvCgF13C1DRgcxWVCRyjbYJ6HWIta/1KOBgM3JCAXkFVrq/rwoYBSHQHNa6pS1I0i15nMLWkFHiDxs75WchBaMYkQX6pZzUDvEmWQm6A1y6yr8rIAb9U3CSqEWQqfAZ0e7kt2gE3hbvoatDKLuNfeqUQePmveR/pqH0ohMGFLjbYIlwHPWrTtaQalF2pVIlYeotcUZkvo6yD6WpFP/ua2ZF2NmPI82lvQkbqKlG+hDPzGhhM9R/KVNek+vNUHNtr7Iz1F5QXjI7o6MsvcFb71fzMLLk8UWe2PZnr1Q94c+kGfvDCwlNqlzrK+EJJ22FIEM+875wepdKjNK9wUNeYYr9AOGdHHJlA6WMKB4AenspHihPAsSx0f3UeuPG9LpnFK79ykcP6QorxKXrR+UWbPtwqTd9t0WZz3FDGYfwyoZY3xVxcowdTXXRUCmTZzXdhN0IBtE2956UAU6jt6SGekGs41+JjD955jm5/G/qb2YGLtyCp3WaMY+ycqexhrbUzeaSTyV1/TGa6dnqUl4MePQRP4F3incm0e9eTeurrGjfRIb3ovLZbrzrMNbefLAoZR6bCjR5RMmNakCBEy5J+qEpbfq3j0DudWnqYdopXJs/B
 XpbA9Mkg
 PRSplJ1VTkV0APKBQnIVDI4FK+nOmyN1paZ5svQ1qa0S5S9MvSsDZ+eWNK6RrOm4AL+lxowtlYMe7OFOWz/qWhQoSyefvAf5xTuFkpMsYPi3OP3oQXuo0tUGfTfvYHl0J3n6We8i9EDi13xXkOwBPkMZGbT8yp7hvPtfvzCP8kP7gIa+yuHRXNZ+pNBPqM0qMpnDQP2D9UxGZrrJ9FSmr9rRIrvxHUc7CwvvceBIRbAuiwNF4AUNPtIwdWVQTw2DojjFtzIKbIYr0Rbv3HZQbEzjRWtEhIb1rn/K2v+g+KrKIaWZOM2z2AItOl+zWOIODbaFL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 12:03:27PM +0300, Leon Romanovsky wrote:
> On Fri, Sep 12, 2025 at 12:25:38AM +0200, Marek Szyprowski wrote:
> > >
> > > This series does the core code and modern flows. A followup series
> > > will give the same treatment to the legacy dma_ops implementation.
> > 
> > Applied patches 1-13 into dma-mapping-for-next branch. Let's check if it 
> > works fine in linux-next.
> 
> Thanks a lot.

Just fyi, when dma debug is enabled, we're seeing this new warning
below. I have not had a chance to look into it yet, so I'm just
reporting the observation.

 DMA-API: nvme 0006:01:00.0: cacheline tracking EEXIST, overlapping mappings aren't supported
 WARNING: kernel/dma/debug.c:598 at add_dma_entry+0x26c/0x328, CPU#1: (udev-worker)/773
 Modules linked in: acpi_power_meter(E) loop(E) efivarfs(E) autofs4(E)
 CPU: 1 UID: 0 PID: 773 Comm: (udev-worker) Tainted: G            E    N  6.17.0-rc6-next-20250918-debug #6 PREEMPT(none)
 Tainted: [E]=UNSIGNED_MODULE, [N]=TEST
 pstate: 63400009 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
 pc : add_dma_entry+0x26c/0x328
 lr : add_dma_entry+0x26c/0x328
 sp : ffff80009fe0f460
 x29: ffff80009fe0f470 x28: 0000000000000001 x27: 0000000000000001
 x26: ffff8000835d7f38 x25: ffff8000835d7000 x24: ffff8000835d7e60
 x23: 0000000000000000 x22: 0000000006e2cc00 x21: 0000000000000000
 x20: ffff800082e8f218 x19: ffff0000a908ff80 x18: 00000000ffffffff
 x17: ffff8000801972a0 x16: ffff800080197054 x15: 0000000000000000
 x14: 0000000000000000 x13: 0000000000000004 x12: 0000000000020006
 x11: 0000000030e4ef9f x10: ffff800083443358 x9 : ffff80008019499c
 x8 : 00000000fffeffff x7 : ffff800083443358 x6 : 0000000000000000
 x5 : 00000000000bfff4 x4 : 0000000000000000 x3 : ffff0000bb005ac0
 x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000bb005ac0
 Call trace:
  add_dma_entry+0x26c/0x328 (P)
  debug_dma_map_phys+0xc4/0xf0
  dma_map_phys+0xe0/0x410
  dma_map_page_attrs+0x94/0xf8
  blk_dma_map_direct.isra.0+0x64/0xb8
  blk_rq_dma_map_iter_next+0x6c/0xc8
  nvme_prep_rq+0x894/0xa98
  nvme_queue_rqs+0xb0/0x1a0
  blk_mq_dispatch_queue_requests+0x268/0x3b8
  blk_mq_flush_plug_list+0x90/0x188
  __blk_flush_plug+0x104/0x170
  blk_finish_plug+0x38/0x50
  read_pages+0x1a4/0x3b8
  page_cache_ra_unbounded+0x1a0/0x400
  force_page_cache_ra+0xa8/0xd8
  page_cache_sync_ra+0xa0/0x3f8
  filemap_get_pages+0x104/0x950
  filemap_read+0xf4/0x498
  blkdev_read_iter+0x88/0x180
  vfs_read+0x214/0x310
  ksys_read+0x70/0x110
  __arm64_sys_read+0x20/0x30
  invoke_syscall+0x4c/0x118
  el0_svc_common.constprop.0+0xc4/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x1a0/0x340
  el0t_64_sync_handler+0x98/0xe0
  el0t_64_sync+0x17c/0x180
 ---[ end trace 0000000000000000 ]---


