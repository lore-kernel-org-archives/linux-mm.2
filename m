Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C571C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5BAF6B00C1; Wed, 22 Jul 2026 12:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C106B00C3; Wed, 22 Jul 2026 12:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFBCD6B00C4; Wed, 22 Jul 2026 12:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 921256B00C1
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:59:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0930FC0283
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:59:30 +0000 (UTC)
X-FDA: 85017023700.04.11A1AE8
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3A74C100003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:59:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=r6Sk9vUz;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784739568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qY9nXLv8vuQAHMKqYLjCyjrlLX0YlK0rzr2P3pDbLns=;
	b=Av5vEoFvTvPTPq4CFtpAZ2zU5LHmktIvsdXB4+nOUZhwjULLS7ctnQatP7E6k/eIRG4b2J
	6cbbYa4g76y5rL4Kvwt2Z3nkch35zS4lkmHa2Auj4doMuyQOj9VwCci7SNVbo5P0hV/Qxc
	cacsS4SnZNTkrxB8MldyPH6fq+YPbaQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=r6Sk9vUz;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784739568;
	b=K6vz/eF+28JenSDsITj8A9Ie8bPOBNf028w9wFtuf9aUYGjaCB49KiKzaD3JdmoFZcDwm4
	5NlcAkslXFuyCeq3ogYs0XZqhtwnUKH6oh4QyhdGdORSXy8sLS+KLIt9IS+lmXPR5qu9N2
	BAL7cCzVxq8qwgp1VTotmnsJ+wAsXGM=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8f186025973so146194616d6.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784739567; x=1785344367; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qY9nXLv8vuQAHMKqYLjCyjrlLX0YlK0rzr2P3pDbLns=;
        b=r6Sk9vUze+iS6AezMNS4ZtJzRV6Kr7sFyy0HrmiR3eL7mbidoXg6DIkVOGZ1U8sVTk
         oPqsYaBpwmBZRuP7mMf0x8iaM6Oh/xvFegTtJLW4Qv6dN5hauSfLC/hDusn0rVLePsU4
         ZPycIfD+Eqpa0XbFzuoOL/wiSGt7DhFgVl4K2qS1NC8hvZv2R6sN6OQo6fPsC06Ci3n0
         s0bnbQPurMf3Q+tWSscEteP0Z2K3ZEUAd9eaTlr7/5w9qt7s09WPz7JVL0QKn8JT+U+6
         JFhRY3PyZNRgDR1GvJr+JxDXqq4iIf/dAtJMewzwJ6jvSvDprkfjZdaU/50JxGvwKovz
         SzSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784739567; x=1785344367;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qY9nXLv8vuQAHMKqYLjCyjrlLX0YlK0rzr2P3pDbLns=;
        b=itFv/B9uBT5ed7rPm3+6F3SOOEOIIJN3xDQ+ornR/QdsE4uEuOl5stsswHIUB3d1SG
         lnFevA/Z/fwwUM4kN2JY4at/lzkjb3zuqk78L7hZE1nqFwRBkXBtMYWMJBLu0FL3cf6r
         I6Xdd4jSOQ+52DjKFlXOpctiNyBBZm1pCA+sPTzsrhx9zlFijtqhSNxwlSzoHGr99y9A
         ARGMaPxAEdrtD5cZaYtZrUoQEYriobJdTuLBnmDFBO9xQV4yWwpD22uMPFeyQfR/zNzt
         0S+9tQAgOQ+45/vkPpCLeciV5i7aj2DXtJS9a8uq6pcJEMuVU7H9zioY2ZkOharb8wzR
         /0CQ==
X-Forwarded-Encrypted: i=1; AHgh+RpRKHmLvaU+M4SryHA7rsOc931I6luBaGrNVyeVJxru7f/Y0XRemmCkvaoc0bZOCI2N6e/9F141hA==@kvack.org
X-Gm-Message-State: AOJu0Yy7YpLT5VXsAyh292anS6As9f/r9HOPoSBuMET6lYVy1PcgpThr
	aG8As4AnrG/bM2b5B3v9b+X/VYrrS7e6c4JH6WHHc4Qu9ldGxF9iuf/5CATQeyPsMuM=
X-Gm-Gg: AR+sD127bKAIW95ip0Bq5j0yKA1Q2KVf0t/wTLZfG/LWxKoeAZf6ixp0d/rx74H3qes
	kqEPDS5D/KEDanxxSe2B1B+icdx/bYvv7RSB/3Ebcvi1prIbJC52kz0MRsKQkuPn5pqtYwXsjzW
	9szeTK18ffeEY1RDI/gV/bsr32y3I2PEy4B2NKuMAJYwjVEh0ebgZQ3zeSX3UkbAHAJ/qCdDfrB
	MNJdga2GjP8THvgjf0NyjmTap1yMcAGTgvisOkgRhzAj4VrGOF/FyueJzUB7DvcOT2I9KXhtYl7
	6EETbHB5sctp4Gw/3+jiDJvktAjXuRon4bhxfNIsqWkugZoNY17Caz4jbluQ7wFsFs+w9k1+PTT
	H0gI096sW5wXiFg06GGEy3UZjBldt1LheNWU46EWZ2MZUxhXDWjtTrzFQJqYc8mg/n+C+/Wfhre
	xehSTkdFPElnoEbqmGJVvgxpr53VUhyUNjFULCaE7wyBF8PUhxSIXAl5ft4SIG/98wZ6y1
X-Received: by 2002:a05:6214:4985:b0:8f0:56e4:10b9 with SMTP id 6a1803df08f44-907783a7325mr273324596d6.35.1784739567382;
        Wed, 22 Jul 2026 09:59:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba672806sm25545896d6.0.2026.07.22.09.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 09:59:27 -0700 (PDT)
Date: Wed, 22 Jul 2026 12:59:22 -0400
From: Gregory Price <gourry@gourry.net>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm: page_alloc: move capture_control to the page
 allocator
Message-ID: <amDyzpXQirujriAk@gourry-fedora-PF4VCD3F>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
 <20260722150006.3848560-4-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722150006.3848560-4-hannes@cmpxchg.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3A74C100003
X-Rspam-User: 
X-Stat-Signature: ggfw7u4n6uu6mgt54t6u76kt1etqg4qu
X-HE-Tag: 1784739568-741295
X-HE-Meta: U2FsdGVkX18j/WIRm/qpjMhEB3jH+1W4fYNAS0EWr07+0i6+Nq7njHbBBOF/+4D6JwIgVIgrR5BisjNiEvdKEwVe1dTvARg1IRUpIicmd9GAKkY7ndaJ/tM3GzGM+Q6fjnnv1KBmbbp6L+mXIfsO9ia8GlmWUs5D/yIAa6z6WOLbdws6moNVYgxPR92jjWlaVYI+Ig1vwZ/n5XLuEojcdW1XorOrpEd4VtjPYB3MHD41Rw4NNWi1FNNanFx/YpxvlH7YD0+zITzg02kS7nXBJJh2S0lEIWX/7peJ57oxZmsXJK5v4laMBre/dPh5WbxG3Dvb9iYeDdSf63JTi9JwZpbKOE9P1N1f5KUe7e6fOLol7FdxtnnqhVzLyGMMHXsbQc7bh5ocx+6ogg+cddjzidRsrg0aw7cxSJ2W2iqzrHN9H6wuUfsnzIEVMp90tEYcLtm9cY4DGPyiqeFrj/FJCl/Jnk7TIOPms20qSVoqpH7/IUv72Xe6SiVjfQ4J6VsJR5dN+YVJQFbiH95qZAKBve6yFAoHybIljJzP2m+Jnn4nWvUrVPazal7XgmryKoi17bqavn4x0/aAyn6NZEOsc2KUuarkIJiMGTl4Kj6YpnVjWa8BsZTY2ZNgBYtiZKFVAVaF49f0Kqxl9sw2oTg94YvsjZ9Qa+veBobASqgLBuTK5a7jm6VavxmX61hUzxb4e896nbG8/MSV6yXN3Bi5d8Q9q1VYkDxzBPbyCnNLCpPBHL/jKak1eziyMIZD9RZ/JWapqU9yaKqjIe0TgTM4w7Ojmj5krKHsWzaNS07ejS8t8PzF7gtL9wicOqMZtQ/h8ev1H1tY5matOFLkZR3mubYymUXbGw2MJKKRHQOvJfH+5d7X+sxZzQlVgM+jZtWjCY8WK2wwz0ezvtZh9Yef3aJ1HVRaUEdi8GsH1jFljPVXUXJsm3RvqjwKIbzvcu4scgR1OxUBPh5Dp2OxMTY
 QpVvviqA
 Z8Stu2elx94Rgv1u9UziwCUj0DAfFmnLJqsdzb3JNXFwGGwSithKgn5cCdGtxF5+Odh6zWuONYTjbZwudichEJ0CLW2OjE6qfHrsVLSdiv3OY+AsPTwUY1drxPITDytYEDlr0+sBpFTYnHeIOEKr5MyGa+6fM/L3q4fQrzKevk+WBHrvNi8a5OEUEEnRNQGBC06toRJL1P3aOWVAs12V7G5hnuzqlOKyoCxrX21POLyizM4onCVU0YeFdIIRUcgezCidFBoBAGx7rJoXVIEkzEDw4Np6zQ0j29wA6ZB13bD51ZR0xUIo3GcBZFVWujeGroA7nfi1BvaPkNwVvQKzs28ARyHXX+z2t58Z+XMmjtqhn5iOGVhKi2DVgcPJGc26a8ZxAbLFRlpUnYh8IHIlgLAxoCGLRz9Yy9ZRZYHG9LNbvbEN7TPxuRXyP6Y0OKqCkf5JzPQgw97+H4OP6Q7ev55aRZqYqyYcdmvplcPH1x0pb07jduVvyumKk4Q+knU7zWrv4EW/9PvNnPkg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 10:56:46AM -0400, Johannes Weiner wrote:
> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> 
> The compaction capturing code assumes the allocation request order and
> compaction target order are the same. That won't be true once
> defrag_mode promotes sub-block allocations to pageblock-order
> compaction: compaction targets the larger order, while capture should
> remain at the original allocation order.
> 
> Move the capture_control to the page allocator and give it its own
> copies of what the page freeing path matches against - zone, migratetype
> and the allocation order - rather than reaching into compaction's live
> compact_control. __alloc_pages_direct_compact() fills in migratetype and
> order, and installs and hides current->capture_control around the whole
> compaction call; try_to_compact_pages() aims capc->zone at each zone
> while it is being compacted. compact_zone_order() no longer deals with
> capture at all.
> 
> Pass the capture_control through try_to_compact_pages() /
> compact_zone_order() in place of the bare struct page **.
> 
> No functional change.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/compaction.h |  3 ++-
>  mm/compaction.c            | 50 +++++++++++---------------------------
>  mm/internal.h              |  4 ++-
>  mm/page_alloc.c            | 45 ++++++++++++++++++++++++++++------
>  4 files changed, 57 insertions(+), 45 deletions(-)
>
... snip ... 
> +		WRITE_ONCE(capc->zone, zone);
> +
>  		status = compact_zone_order(zone, order, gfp_mask, prio,
> -				alloc_flags, ac->highest_zoneidx, capture);
> +				alloc_flags, ac->highest_zoneidx, capc);
> +
> +		WRITE_ONCE(capc->zone, NULL);
> +
> +		/* Stop if a page has been captured */
> +		if (READ_ONCE(capc->page))
> +			status = COMPACT_SUCCESS;
> +

Might be worth a comment to explain what the WRITE/READ once is dealing
with here since it's now detached from the main barrier(), but otherwise

Reviewed-by: Gregory Price <gourry@gourry.net>

