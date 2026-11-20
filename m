Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DCD4606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 14:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eIK9EkYL
Received: by kanga.kvack.org (Postfix)
	id 009F56B00EF; Fri, 20 Nov 2026 09:54:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFCF56B05B0; Fri, 20 Nov 2026 09:54:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12CB6B05B1; Fri, 20 Nov 2026 09:54:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9CEF6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:54:49 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A5B0160FA5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:54:49 +0000 (UTC)
X-FDA: 85455794298.07.EF453A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9B73D20005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:54:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIK9EkYL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795186487;
	b=4JpPnmgQa+8LeRzucEHdV2a/oABA7h44q2hUlJQ54OKYB4TZ2i5n5FXsyIrTZnzA7JhIJq
	Dej9BOga1kyur5wkE1yyWiHOd9urstXsXh4a1822ePd8z286P0RHF08ItaDQPnwc3oSoIj
	k3j8eNP+7oFzpMk53ORFuC5sI7bb2Yk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795186487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YXkMF49tfbR1XrNxSmARw9QjbBb1TVrWgTfXHrV4vhQ=;
	b=bhV0qYAhsyzPWmZkgI4soMsV/JwY4OA+OhxK7m+GoK6r6ObRShIt9a5CvMiFeJaNx3zc/o
	zzCUDU86TQK4OF1ymBZTPPpyePlhvrAWQOK+pCH6ulUPAc8mR4KJYHfAbR2uv7PWowUdZJ
	irBaNRjNRNvqUPM/Zs2gkKSJecwDDOE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIK9EkYL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC9654248D;
	Fri, 20 Nov 2026 14:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B33C1F000C4;
	Fri, 20 Nov 2026 14:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795186486;
	bh=YXkMF49tfbR1XrNxSmARw9QjbBb1TVrWgTfXHrV4vhQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eIK9EkYL6YNouxCKFKo9gIUK8cO1ySdVl96yCE1rq7wuTOlqRE8qknkbshPl1xlLN
	 3KOF85Pf3JIzT9160NLAIzPpvBOu/y5o20cpMVSCUStMQJpajDPpxv0xql8onEzdc1
	 Bq24F74qyQyPCe3a0Ub8zjMBlGHRVua3XzC8HlMSh7rc0w+6ewtdOPqMpNqlgASYYX
	 tJIZWZMaiMxfw2qlE06Mu17u4Y3J4CbVNpMEF7mMNe9qziuMXKmrwuDoSUkQLv6pn3
	 yDWp8beOFg/IBB5aoUMH03jJAr+YJNYE609fue5l1rTTHi12txxpruqZ/ms1Gg8eZ0
	 dnkEtvuXJwE/w==
Date: Fri, 20 Nov 2026 14:54:35 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Luigi Rizzo <lrizzo@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Simon Horman <horms@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Naman Gulati <namangulati@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, iommu@lists.linux.dev, 
	netdev@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
Message-ID: <awBYFhnpFGtEXZ6r@gremlin>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120010655.467825-1-lrizzo@google.com>
X-Rspamd-Queue-Id: 9B73D20005
X-Stat-Signature: d7kxm88stfraz8r61bfka8356y1bwmae
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795186487-459539
X-HE-Meta: U2FsdGVkX1/7bSrkEv+lOO9P/uyN3uctJV3k3vCTrsp5chfhKaFt7B03G5gP1Z4vPjl7rBnzZn79c+zh1LFPLPzy9REPLu5Pl9GopsgegsgMPnPCghCs0TLtV0niWbadkalF/pT2lukQr+U2LrmIbiOsqkmflRW0eJOqkQdkj2SJa63HfqHgCsyOP9adooaioslguVLbFEJ5M6THAsfgAlZXASwhdXfcndw7hXAV2yk/u2xtKsYZyJoFl1r9fAjmv1hzUzZHgG8aUjnX65bjYIhF1vSIVl8E6ZOmuzIK6VvuZkcKm7J0HDRUVnLlo9o49sKBM1MVv/QznUErEUCYV4e6Zo5Zx2LK7HbpuCZ7DZ0mFBohdG5Q+kRD54kSTdUYz1kf+Zm+f8pbNEhYO/D+7JXJ8wne1ErYpAplTql37+GHZ80glyltxvBUawbTA3HYIYlKEKI1IzXBhZyxDS5juq1P6caDyk9I8Xw/U3UUqmY6izQumW6bGloXC9+mFcJzPrAqHmg/XGXhBTtV8JG6dgCnkjQ6PA7qPgqX1375yGh1kVPvvseJH9eoq0wR2/WgStf+pg3d/ZXGWd7z31Db5y0K8Jq6v1cqS51ci7cwXZel934CRMLktQ/lQxkbJetUZzcEnx+QlEFVK3HWglo8r4LORLXak0OkOn7XcN/PVPIxJBO7VHBe+CTTKFYslc8n3mEAcJWLBL8X3K5SKno2KkfSHFOodjXvpO/MeyLKRcjfVRdM0WbTJ+yZbpZAOURQnotuR/AX+PTItAKuU+t5MnS+eqTSms5FFOe4Td/i/TvbVwQieHnBonFicZ0aevlhCanZMff5Xg0bDRlo9Ba9m9r/IZtrw1jftLR1BL6F1lyDy5CtsZPo1ZD3BQrLgv+VcqdEKFqa3jOMtQrFMcWAD9d3INWWXxx0OjfihuRTP1HT9IaezO2JavNcClTFgbP2Y0dkgyaeJFv8anSIwhu
 cSDGpHqi
 UZ8WKHF+qfFpXMQTbfYtJerXxmD1N8rxDDxzgV9E1bMq0PG6s9H4qF30B4biFVRYAUUhdUb28JrqSga3oqLiG+foJccMSBitjHq8jnO6+AEEwz4ZXvcgHd+nOGmt/jM5pabzbLcTNjPQnJhUpucy7uI3xLuKXgiQHep6N5bjgzlr/kk/FMEV+dIj8jRm9dCpJBATp19czP8VDWz0ddvAHuAa6f6X30flk4XkFYOR9CG86yjBaVYRU4KwiverSPNrCldvaTwo3Dk/k0v1h9WRoWeDCUOyUcsbJ+i0svS9spY7P6wYjNmypY0GeSzjKHqCPx7WGiu7jvrb4QpkKQgmcq7vEonpRVCgJir1lR0Guypiju5cBzFRE6n1tmBGI73WTaJX37oFCiQt7g8qwOtCbMatNtSMF56DCyaHL5XUXWXaqa1jvuhMuA4ZsjtbdrfSVn0fmwFSwFYYywvUmEwslH4mXlqrTPsb3C+b1QIMSYXkIVZASWEPHkOLqX+uzYf+gUmYVSKDQX/j+qxfv7Ot12TxctXwI8N5jdfEdzXWty87+56M6VuG+SNEblCSxB7GZpXjn74oH4UE46y5dC3jx2+RxDsqdaRsWyINn0wSbuvfUDDGZweN1OWoREZGrimT7FvYreoCBPRSOrfXaAQmFNrsRbR25yyJxxfkQlSMBwVUlho853mWnDIaB68Sxu1nFS15dcdMaE/uKDiXy/VRQHMy9T302e3mCioiJ5orwVaUb6auM+0XFFjxeK1d801mOqCvAFdXXLv5x/mzUHvRZsv4KRmX2m9S8Nyc7OB8fAQLtZF5dSduiEn38Msxm8J5m/h1awRTksyuYEhY7jdZuVr6PoWC2B1nw1oGHP67LChifjEFaxDaoYGNLhuTl/SklFCXcI1pxuOLXF9/RvlWYLeOJCeurHggalNmnY4cjwCfXQ0VBTm0tG4EAF4JQqgfbMDn35+4nLlXR6R8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

TL;DR: NAK. All of it. (And yeah, I'm steeling myself for the inevitable 'oh
Lorenzo' :)

Sigh. You know, it's hard being a maintainer, and it's twice as hard lately,
given the endless surge of AI-generated stuff we see every day.

But I am especially frustrated that I have to ask people to do the _absolute
basics_. And from people who are not helping with any of that. Quite the
opposite.

So the basics - you haven't cc'd the right people here and you're sending a
massive new series in-reply-to another. See below for some automatically
generated feedback on that.

In any case, the courteous thing to do would be to familiarise yourself with how
series are sent in mm. And that goes so much more for a series that is so
invasive. And seemingly, AI generated...

And you're sending it when
https://lore.kernel.org/linux-mm/a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org/
is in effect.

Anyway, to the series itself....

This is ludicrous:

>  .../admin-guide/kernel-parameters.txt         |    7 +
>  Documentation/core-api/index.rst              |    1 +
>  Documentation/core-api/pisa.rst               |  485 +++++
>  arch/arm64/include/asm/pgtable.h              |   28 +-
>  block/bio.c                                   |    9 +
>  drivers/base/core.c                           |   78 +
>  drivers/iommu/Makefile                        |    3 +
>  drivers/iommu/dma-iommu.c                     |   49 +-
>  drivers/iommu/iommu.c                         |    7 +-
>  drivers/iommu/pisa-map.c                      |  488 +++++
>  .../ethernet/google/gve/gve_buffer_mgmt_dqo.c |    8 +-
>  drivers/net/ethernet/google/gve/gve_rx.c      |   40 +-
>  include/linux/device.h                        |   32 +
>  include/linux/gfp_types.h                     |   14 +-
>  include/linux/huge_mm.h                       |    7 +
>  include/linux/netdevice.h                     |    4 +
>  include/linux/pisa-iommu.h                    |  141 ++
>  include/linux/pisa-mm.h                       |  205 ++
>  include/linux/pisa.h                          |  356 ++++
>  include/linux/sched.h                         |    4 +
>  include/linux/slab.h                          |   10 +
>  include/linux/swap.h                          |    1 +
>  include/net/libeth/rx.h                       |   11 +-
>  include/net/pisa.h                            |  204 ++
>  include/trace/events/mmflags.h                |   11 +-
>  include/uapi/asm-generic/mman-common.h        |    2 +
>  kernel/dma/direct.c                           |   11 +
>  kernel/exit.c                                 |    2 +
>  kernel/fork.c                                 |    2 +
>  mm/Kconfig                                    |   35 +
>  mm/Makefile                                   |    3 +
>  mm/filemap.c                                  |   12 +-
>  mm/huge_memory.c                              |   36 +-
>  mm/ksm.c                                      |    3 +-
>  mm/madvise.c                                  |   19 +
>  mm/memory.c                                   |    8 +-
>  mm/migrate.c                                  |    3 +-
>  mm/page-writeback.c                           |    9 +
>  mm/page_alloc.c                               |   10 +
>  mm/pisa-alloc.c                               | 1758 +++++++++++++++++
>  mm/pisa-kunit.c                               |  778 ++++++++
>  mm/pisa-meta.c                                |  834 ++++++++
>  mm/pisa-node.c                                |  567 ++++++
>  mm/pisa-priv.h                                |  319 +++
>  mm/pisa-user.c                                |  898 +++++++++
>  mm/readahead.c                                |    3 +-
>  mm/slab.h                                     |    3 +-
>  mm/slab_common.c                              |    2 +-
>  mm/slub.c                                     |   23 +-
>  mm/swapfile.c                                 |    3 +-
>  mm/userfaultfd.c                              |    7 +-
>  net/core/Makefile                             |    1 +
>  net/core/datagram.c                           |   17 +-
>  net/core/page_pool.c                          |    3 +
>  net/core/pisa-net.c                           |  264 +++
>  net/core/skbuff.c                             |   33 +-
>  net/core/sock.c                               |   31 +-
>  net/ipv4/esp4.c                               |    7 +-
>  net/ipv4/ip_output.c                          |   20 +-
>  net/ipv4/raw.c                                |    6 +-
>  net/ipv4/tcp.c                                |   17 +-
>  net/ipv4/tcp_output.c                         |   14 +-
>  net/ipv6/esp6.c                               |    7 +-
>  net/ipv6/ip6_output.c                         |   20 +-
>  net/ipv6/raw.c                                |    6 +-
>  65 files changed, 7907 insertions(+), 92 deletions(-)

I mean ~ +8ksloc. 65 files. These should be clues for you.

>  create mode 100644 Documentation/core-api/pisa.rst
>  create mode 100644 drivers/iommu/pisa-map.c
>  create mode 100644 include/linux/pisa-iommu.h
>  create mode 100644 include/linux/pisa-mm.h
>  create mode 100644 include/linux/pisa.h
>  create mode 100644 include/net/pisa.h
>  create mode 100644 mm/pisa-alloc.c
>  create mode 100644 mm/pisa-kunit.c
>  create mode 100644 mm/pisa-meta.c
>  create mode 100644 mm/pisa-node.c
>  create mode 100644 mm/pisa-priv.h
>  create mode 100644 mm/pisa-user.c

And here is a perfect clue. 'pisa-mm.h'. 'pisa-alloc.c'. You are creating
parallel implementations of core mm mechanics _just for your feature_.

And you didn't even update MAINTAINERS :) though, moving implementation to your
own files and adding hooks elsewhere is its own kind of anti-pattern.

>  create mode 100644 net/core/pisa-net.c

What I'm trying to say, constructively, is that you have gone down the wrong
road here. And it's one we've seen many times before.

You have decided that this feature is exciting and important and really special
and unlike anything else, so it must be implemented through hooks into other
stuff, new special GFP flags, an madvise() hook which amounts to 'I can do what
I want here', your own allocator, your own node code, your own everything.

And I'm sorry but we've seen this before, and it's been a disaster. Hugetlb and
uffd are examples of code like this.

Every feature of this nature imposes a tax. It means that you 'just have to
remember' to consider and deal with feature X when you write code touching Y
because feature X sits outside of the core mm code.

So my constructive suggestion to you (and this is an RFC, so you're asking for
this kind of feedback right? :) is as follows:

Firstly - please rethink using AI to generate massive series like this. You are
not going to get anything like that merged, and it disinclines maintainers from
even looking at your code.

Secondly - think about the problem at an architectural level. Listen to people
like Jason and David who are giving you highly valuable feedback, seriously you
are lucky to get it.

Thirdly - rework it so it _fits in with the existing core mm architecture_.

Finally, please don't send it as an +8 ksloc 65 file monster. Nobody is going to
take a series like that frankly, especially not from a newcomer to the
subsystem who may or may not stick around to maintain it.

IOW - try to find ways to implement it incrementally.

Thanks!

~~

FYI: Issues my scripts picked up:

1. New revisions sent in-reply-to mail

Please always send new revisions of series individually, not in-reply-to
any other email.

The easiest way of accomplishing this is to use b4 [0] (the recommended
way of sending patches to mm), otherwise format patches like this:

For a patch series, e.g. at v2:

$ git format-patch -v2 --cover-letter --thread ...

For an individual patch, e.g. at v2:

$ git format-patch -v2 HEAD~1

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

2. Missing cc's

You are missing cc's. Fixing this is easy with b4 [0] (the recommended way
of sending patches to mm):

$ b4 prep --auto-to-cc

Alternatively, you can use scripts/get_maintainer.pl:

$ scripts/get_maintainer.pl --nogit-fallback <files-or-patches>

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

Specifically, the following appear to be missing:

  chrisl@kernel.org
  kasong@tencent.com
  apopple@nvidia.com
  baohua@kernel.org
  baolin.wang@linux.alibaba.com
  baoquan.he@linux.dev
  byungchul@sk.com
  chengming.zhou@linux.dev
  dev.jain@arm.com
  gourry@gourry.net
  joshua.hahnjy@gmail.com
  kas@kernel.org
  lance.yang@linux.dev
  matthew.brost@intel.com
  nico.pache@linux.dev
  nphamcs@gmail.com
  peterx@redhat.com
  ryan.roberts@arm.com
  shikemeng@huaweicloud.com
  usama.arif@linux.dev
  xu.xin@linux.dev
  ying.huang@linux.alibaba.com
  youngjun.park@lge.com

--
Cheers, Lorenzo

