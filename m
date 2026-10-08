Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A6BCA6016
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 21:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2026B008A; Thu,  8 Oct 2026 17:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579236B008C; Thu,  8 Oct 2026 17:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 490246B0092; Thu,  8 Oct 2026 17:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 299B86B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 17:25:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4941140168
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 21:25:18 +0000 (UTC)
X-FDA: 85300739916.11.6B4BB53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0A01B1C0005
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 21:25:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZjJl/wo1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791494717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=odDRkTcjbS423eFUVzRKgzpHhfm86iv3G3/SNcHY7is=;
	b=teDPKixChn35D/ZbsxB6KjACQhuRCtFEq3UGszb/Hgb7hXukEKtJbS6P9doutt7POQpqlG
	GGzxcTCgH/fYseYhqfsJk0IQP9tEDLU7bkT6npAfeQzTWwZJwk0ZSocu2l3+lFlEVQxLNf
	P2E9fHdGbA2oG7DVUOpGf3tRZ+voibg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZjJl/wo1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791494717;
	b=nEQzH/iXhWyUU2N0/wkdqQNfdgUIb7ZEB/cJBgv9NlkttkwyyWq9j/Uwl3YVH7YzRv8RGi
	qcUV0kGaqRInkXnylAsKCHtfRGLqkPbto6A/4py2m52M3SA6D9Uzx59CtDOCj0OZs8btI7
	vWeYOe+JcpmofuOe+fVIFT8UilxkyYU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 089B8406EB;
	Thu,  8 Oct 2026 21:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B5F1F000FF;
	Thu,  8 Oct 2026 21:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791494715;
	bh=odDRkTcjbS423eFUVzRKgzpHhfm86iv3G3/SNcHY7is=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZjJl/wo18DivxZod9Ph2FuLJmJ0Pe6BmpQB57sdezehMYyARbOEVU8OGYlasU7V/S
	 0AT+zRfhasFu1NUWqERoTuQdlxiQP3IIeICSISEgSyXXl35VozAJVTNxB2bysN99vf
	 JfipJu9WkWWRjdDZiddIe/cXmY43UZwTIiDZnEwIxtK2IGH0UoFZxfezn7ejJCJdq4
	 QGd6BQqNjD2yQzAqk9ixMc4c11z/zcWVonaLCd7MlyrrU4sbCkmiHW5YBwRkvRDG8U
	 qZmSxy/lRaMiD4+hT2CFnuTLIH1WH3eg5IzgqjHuPhhOOpSdCVlAbQNo7AT/fvx+ph
	 VX7EkFoGAlt2g==
Date: Thu, 8 Oct 2026 23:25:13 +0200
From: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Willem de Bruijn <willemb@google.com>, Jason Xing <kerneljasonxing@gmail.com>, cgroups@vger.kernel.org, 
	netdev@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v6 0/8] net: skb: isolate skb data area
 allocations into a separate bucket
Message-ID: <asgAh4mrr_yd622U@thinkpad>
References: <20261006092030.got.500-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006092030.got.500-kees@kernel.org>
X-Stat-Signature: to15bkc5gupzihsp9qky35yzt5ozttyz
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A01B1C0005
X-Rspamd-Server: rspam08
X-HE-Tag: 1791494716-288995
X-HE-Meta: U2FsdGVkX1+481ihNdTXBwwMS1cBwmLQhELXIckF8WwZY5RpGqmhjIOLiOB0+m115pk++cCV01UaqXARf4EQ1gXjuOvrysVDQypp95pR/uKj0W6dCU5YB0qk0gbkxhdcZHqb+WdLwyjlyc4wTAzFnGJaXA0xoEZiA1/JkunJDcJ0t0W3qiwwdM1XkgzY49UQ7BWzKyIYfypYbDcpJZMqkt5bu/eqFR7yrRoVsNa9hQDrJXqS3tkYWONAgaAU4krnrbUtkVyeJLkySCfQTgu+V7f7JAa74SWTH28tdHNwkqQ2AUrhyFizcOQVVChbaEX8X3OR94m2gGHyli4Nqgj991eDsmDgqGQoKyh4P0DD+gkYkTZZQRM8XwHYlUEih7JbT5/auzOfs5sIu0Ql+jlv/Bc8qZs6gSKPppk6D1hWlJKyaab3yPL6bHqiv/0Wic3GKWCcJ38Y6ELsC/6kVm8Qu3WugaJiztsO4fYniAD/iqwR03VJwdnn1RvM9FHKupDTEk+S4/vWZkhdNs25iX8Yz0NIKCH9SrPihmwEQWqtbicarH6fr9WH4sSQLrm4z6S6hrmTqQBbSDFq/mJMxnlXOq6EfrTjX9a0bfQSJsfNi0jUQKyxgXtFKAMmIUf9H2dD9Kwgaw8ZLz+OIUhkuCKLwSUW/9YRstj11Vk3MGKLvioMVKjBqS80vkkA+koorFLfb8n6BIMEvaaDo6IEbnhRyWmBcVREKNuucsaH8TavJfhZVMcTwbqNZrbi39kLFDUlU9/0lVHR0Xher32C8VwRyIT0gi8KLEhWjuldKqlSmmNde0Axh2wW+Q1v7cLzhpm3u1uItFxqvPMbnwlU0pDLGwf9MiS8g6mi9pUElsCSoYs/PGWSLcZlTBprGVxAXWSMHxetnKpwjDJKKgXdVKla1NVUfHirSRixlHvW5RZd4KsdsnFlit1ok8tSHySG7yXYBfiE8KCD3dUIdOfmeHK
 kIPHumWp
 YCBgbwrIo2DrfY77mybDReiai+i29htXC3h2kVe1PHIkAobJtVcmX+s7uynDjBrIDh05p3nSqLa3YRQb01bzNXYQf1w2YHPdX5vXvlOe9pDLXjTSy6WwbXt8MZU3qxzFQlz2L0oaDUD+nbowwF+NeNlESDXv5Y2Jt4nFSqvVoFBPPcJqENGdtWnZztDGbYWs3gLY2J/rZkLrCoi9ImLFFrKqC8IBTycnL2JWWfncB1mxbE7A56eT0x+5gJaHTUVnITEJH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 02:20:26AM -0700, Kees Cook wrote:
> Hi!

Hi Kees!

Was hoping to say hi to you at LPC but I missed the chance ;)
Maybe next time. Safe travels!

Uh, my mailbox stopped working for a few days as I forgot to renew
subscription. (Kiryl told me it's bouncing, thanks!) Hopefully I didn't
miss too much...

> This gets the buckets able to handle memcg (GFP_KERNEL_ACCOUNT) with
> isolation (since it's common due to AF_UNIX),

Cool!

> and GFP_DMA with fall back
> (since it's rare).

> It gave me an excuse to build out bucket kunit tests
> too, and that (and LLM review) found a couple other issues that needed
> fixing too, including msg_msg allocations going uncharged to their memcg
> when CONFIG_SLAB_BUCKETS=n (fixed in 2/8).

Oh.

> Harry, on your v4 question[1] about bucket users giving their own
> alignment: I tried that in v5, but a set's allocations don't always
> come from its own caches. With CONFIG_SLAB_BUCKETS=n, after a failed
> kmem_buckets_create(), and for the DMA and reclaimable fallbacks, they
> come from the general kmalloc caches, which can only give kmalloc()'s
> alignment.
>
> So v6 goes back to mirroring the kmalloc cache's alignment,

I might be missing something, but why is that a problem?

For kmem_buckets users, the reason* to specify alignment is because
they might need less strict alignment than kmalloc.

(*Perhaps it's nice to document that in the comment)

However, because kmem_buckets can fall back to kmalloc on e.g. kernels
w/o CONFIG_SLAB_BUCKETS, it should be fine to fall back. No?

Creating kmem_buckets with more strict alignment than
kmalloc doesn't make sense. 

> and drops the ctor and flags arguments for the same reason.

Uh, for ctor and flags, yes. We can't have them in kmem_buckets.

> And the whole
> exploration made me realize I had a completely wrong understanding of
> how memcg worked. :P
> 
> The bulk of this is mm/slab, but the final patch is netdev, which Paolo
> acked in v4, so I'm hoping this whole series can go via slab?

Going thorough slab/for-next sounds reasonable to me once it gets
some reviews.

Vlastimil?

-- 
Cheers,
Harry / Hyeonggon

