Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6886606A6A1
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oul1Xglb
Received: by kanga.kvack.org (Postfix)
	id E695A6B05B8; Fri, 20 Nov 2026 20:09:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42396B05B9; Fri, 20 Nov 2026 20:09:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D56D26B05BA; Fri, 20 Nov 2026 20:09:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF49E6B05B8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:09:23 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B96D802A6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:23 +0000 (UTC)
X-FDA: 85457343006.21.8D19C1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6D0A22000A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:09:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oul1Xglb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223361;
	b=kAo0x2OXB2JNImSeKwBlvYyG7RphKpT7jDFT8VLSPJXZKD3DIpQUKyxT629FgUv36b2reA
	TA9fBnZCSpEWJ0qja1T9E0BxJwFUcrOItW+cWf8N9f6DKfPPLxT+p5AMVPSgbnsfDJ0cdW
	etClyMGnvkZDGLgTaCYVgbLWp9Cf4ro=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223361;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7DteKgxXrQDMguNwaVxehpqZO5kSOGQjWE3FoEMrD0=;
	b=hCUpXlGbyhaYMuAGx9TgsawswGtRCJtUofPhhTWZqY1J1giJ7kG3zsZPap6iXCAj4MC8hO
	ZR5Y0cueZCVkH+2gPdpMyg8+3Szbn+QkNWEWzmpc3zrkGp7G3k7wcN/zwhJx+RZVbohS8j
	XLNv/1T4tEMZv3aog6jNroMDwWIp6oQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oul1Xglb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20F6140633;
	Sat, 21 Nov 2026 01:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7193A1F000C4;
	Sat, 21 Nov 2026 01:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223359;
	bh=z7DteKgxXrQDMguNwaVxehpqZO5kSOGQjWE3FoEMrD0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Oul1Xglb46lPncG0V2W9OaZG6FadIlVwvfoLfotOM3llftN1vzbjXUizOXBB2s7NR
	 g8jrgT3Ypx4R9nxwsxGXJqhpACiEEvepDhOPyCz1k5k6XoFJRjIPtoX7GAXn9ZzPpu
	 pPqnH4fm35XgECBHbwksg5Sug5F5xpOQYIWc8610u9ijOla5qsI6oorrRjtYIoUZDS
	 AWcKicd4jQngjPKCPQ8M9wXVYJWANOP6d9LDv9Io5uv37ur6BML/5pTQPUAWYRS3SF
	 vowKqmLPuT2pu9dcmPdA89aFGEvXMdUq9XIus+Xi000hX/PHRc7g2DZrwVlHLfbk1b
	 d5lo/gwkY52sg==
Message-ID: <sashiko-outbox-226467@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 03/25] mm: Add per-NUMA-node PISA page reservoir
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Joerg Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin
 Murphy" <robin.murphy@arm.com>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Jens
 Axboe" <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Harry Yoo" <harry@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Hao
 Li" <hao.li@linux.dev>, "Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Jann
 Horn" <jannh@google.com>, "Catalin Marinas" <catalin.marinas@arm.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Simon
 Horman" <horms@kernel.org>, "Jesper Dangaard Brouer" <hawk@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Willem de Bruijn" <willemb@google.com>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, "Joshua Washington" <joshwash@google.com>, "Harshitha
 Ramamurthy" <hramamurthy@google.com>, "Alexander Lobakin" <aleksander.lobakin@intel.com>, "Christoph
 Hellwig" <hch@lst.de>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Naman
 Gulati" <namangulati@google.com>, "Pranjal Shrivastava" <praan@google.com>, "Mostafa
 Saleh" <smostafa@google.com>, "Randy Dunlap" <rdunlap@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261120010655.467825-4-lrizzo@google.com>
References: <20261109182533.3594984-1-lrizzo@google.com>
 <20261120010655.467825-1-lrizzo@google.com>
 <20261120010655.467825-4-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 01:09:17 +0000
X-Stat-Signature: gs7h61cun4dyg5ym8wbjm5snczsymn7x
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6D0A22000A
X-HE-Tag: 1795223361-426171
X-HE-Meta: U2FsdGVkX19NKzUA8hkQR9STNPp8Jy6D7HzPdxDrKW2tM16XxqIFSEi9IlOq6Xii1/lCKj3xYGcWUpVK1HHPrTVB3W5vKv58txRfcbnRpGmLcFeoof+LMgQJpFISuq8v7XY1jkxD3VUDxMTgfG9+OQica1XBETIJb9j1b1D5upDyZd99fkMbr+UO3Bw7h9SWXhEUOKb+1CIyDXM/8mhCCsv0det2ArNLcPmWAPcIhQMoSpVnEhrV1Mxqr7lD4t0mIv97P0LcIKRARGFRgrenO08fgT6SM6LtVz31jyCudk0xJYFBVDdsi57sqYbFwNwqj0WKy+NDUj7Cxp6bo/J7da2L3YXuv4dzfzuZp4l1VF22Lm1wKisI3Fko3ERZr4JA7b3uBGuBBA/Ma1h6loW8WCjcB89eB5UijWsWnBqqFkjiHMC3Lg198uOFiwNOuT3HigGg8Q/QGm8dNy+oaMlg0kLQB9c8uwvTrpB/LKCsDkYK9M3u6f9crKyhThN1liK7KGBbIeUn8iPjj5pik5JwjOmQYG4POZRWPX7xXjRQNCReoUJCys5Ngv/g4S1HMo1Z7Q3cSerWYEAGasD3KUqYegyoFeUWsftt5kcJUKUXjRv6pPFEZealWOx+aGcoSZ+GqvrLGtqeWiLjpCwJz9cSDNBXNCYMLcFp60Fd2FcpttSf5WTinanOmBWQb/xdpC7amqY9cG7lw5HHw8T4xNbHdUM6pF1zQu3iJIBUH+ncDVXWJiFBzqlLw0NNgRx9lL2j9nHnvKivxC7EJzex4gD5hrc0VL9IkL9RD41+A2uAYA/4oYEGzMSq9VASngX+s2ljQrF6PynlKfe0sDLGphiGiJcQw/3o68skJ2/VOIJGpajvaXSBeSmi0eiTBwOjvp/clNQ8ujdQNp2j+6ijWWmpeU17FA6RNDgFTBlletRf07F56LYWUGju9HEO1acmmvbWsB+XPBZ4i5JK4WQPRPk
 HxggUR/y
 0xir1gCYREFSkMUTItLCBLu/3+IUA46aUFGLiUB8zPJIoCiRqpfuBdUp97lGY7MZoGCbC1DKiuWmCvXVZLzi8wbVT0cjFDnFkGnTvQR+kKTRv6HBUmsri8DcKnTaV0fAu2z1AuJhjzXZ3U2ebS0k8dz7L7xPH2ltnuJB1e9zy8pfqTXGo3FH8tQzRcPeujEVHXRoZFbfj3M+HRnZ4XX3wewVwx8f895K90lInUYmm5YZvYrMwJ1+QgraR186LGSUJb6yN9tQyE5iWDv7sABuGSgsfXxAgJMJLr3tktEGhNTBbCDO+BZFqC45ssooYpi+CTyz89J/cOnqrvdA9/+07SrluTJ+EMOa78a2bLu+Ipn4p9wxpuKswTbnHeW99Lf0iRKRQ/wyCd2Dls5HFs36pyrMyTEw5Ii5pjWX2wqfPbJ4GjZ6yv2BcimLhsi82o5MOLWaoxwJsrM1W0rbnYF8D/L3eYh9jROvXWxduIvzDg1du+nW97nBwL+RqCsgwS3wJqZPrMzdPEC9//VC2FykiB15BQ5mhaH7lC2CNLFS9V8duX8DJBF+VpoMltMywEUFuPhPL2ySqHArbNSBzRv3oE2YHFo32YcgBimTGbybFuEWinIVQcQUYo5Ul+o2vmFE+Ra9tjK/tpFwZo2rxRcGFEyoq3GASTLmT9AYGhSYEKWzfGLJAeaUIKz8EOk/fH9MVOtAvaEy+GdXFAMbq/pQ2/7FXCHjDzIbPwyhRLON4ZeAzfUNlLCMhYYo1SyZFA7DEVB/9mS+ZAe0B40AKTBeM8iFy1r2QhzfEh7SJYjMgJT+HQ0khjGr+Xn1mBBM+psn2tWlDi9pb70em19p8TITlFpzKCskySoxhcqFRQhI4hxobUhOKkhIl+LW+c1nRIRq8hb+fWNMWbGp/Ifo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: race in pisa_schedule_reservoir_node() skips reservoir
  trim work
--

commit 540432e01d5fdd397e42906780e4e3354270a3d7
Author: Luigi Rizzo <lrizzo@google.com>

mm: Add per-NUMA-node PISA page reservoir

This commit adds a per-NUMA-node reservoir of pre-allocated and zeroed
PISA pages to satisfy non-blocking allocations, managed by a per-node
work item and controlled by the pisa.reservoir_max parameter.

> diff --git a/mm/pisa-node.c b/mm/pisa-node.c
> index fe9f37deac755..5b9b44186b967 100644
> --- a/mm/pisa-node.c
> +++ b/mm/pisa-node.c

[ ... ]

> @@ -53,9 +153,180 @@ static void pisa_release_page_rcu(struct rcu_head *h=
ead)
> +/* Refill node @nid's reservoir up to pisa_reservoir_max pre-zeroed PISA=
 pages. */
> +static void pisa_reservoir_refill_node(struct pisa_node *node, int nid)
> +{
> +	while (READ_ONCE(node->nr_pages) < READ_ONCE(pisa_reservoir_max)) {
> +		struct pisa_meta *meta;
> +		unsigned long flags;
> +		bool clean, added;
> +
> +		meta =3D __pisa_page_alloc(GFP_KERNEL | __GFP_THISNODE, nid, true, &cl=
ean);
> +		if (IS_ERR(meta)) {
> +			pisa_alloc_backoff(node, false);
> +			break;
> +		}
> +
> +		/* init_on_alloc/init_on_free pages are already zeroed. */
> +		if (!clean)
> +			memset(page_address(pisa_meta_to_page(meta)), 0, PISA_SIZE);
> +
> +		spin_lock_irqsave(&node->lock, flags);
> +		/* pisa_reservoir_max may have been lowered while allocating and zeroi=
ng. */
> +		added =3D node->nr_pages < READ_ONCE(pisa_reservoir_max);
> +		if (added) {
> +			list_add(&meta->list, &node->pages);
> +			WRITE_ONCE(node->nr_pages, node->nr_pages + 1);
> +		}
> +		spin_unlock_irqrestore(&node->lock, flags);
> +		if (!added) {
> +			pisa_release_page(meta);
> +			break;
> +		}
> +
> +		cond_resched();
> +	}
> +}
> +
> +/* Release PISA pages in @node's reservoir above @max. */
> +static void pisa_reservoir_trim_node(struct pisa_node *node, unsigned in=
t max)
> +{
> +	while (READ_ONCE(node->nr_pages) > max &&
> +	       READ_ONCE(node->nr_pages) > READ_ONCE(pisa_reservoir_max)) {
> +		struct pisa_meta *meta;
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&node->lock, flags);
> +		meta =3D list_first_entry_or_null(&node->pages, struct pisa_meta, list=
);
> +		if (meta) {
> +			list_del_init(&meta->list);
> +			WRITE_ONCE(node->nr_pages, node->nr_pages - 1);
> +		}
> +		spin_unlock_irqrestore(&node->lock, flags);
> +		if (!meta)
> +			break;
> +
> +		pisa_release_page(meta);
> +		cond_resched();
> +	}
> +}
> +
> +/* Per-node worker: trim/refill the reservoir, then scrub allocators hom=
ed on @nid. */
> +static void pisa_node_work_fn(struct work_struct *work)
> +{
> +	struct pisa_node *node =3D container_of(work, struct pisa_node, work);
> +	int nid =3D node - pisa_nodes;
> +
> +	pisa_reservoir_trim_node(node, READ_ONCE(pisa_reservoir_max));
> +	if (pisa_enabled() && READ_ONCE(pisa_reservoir_max))
> +		pisa_reservoir_refill_node(node, nid);
> +}
> +
> +/* Queue node @nid's work if its reservoir is below or above the target.=
 */
> +static void pisa_schedule_reservoir_node(int nid)
> +{
> +	struct pisa_node *node =3D &pisa_nodes[nid];
> +
> +	if (READ_ONCE(node->nr_pages) !=3D READ_ONCE(pisa_reservoir_max) &&
> +	    !work_pending(&node->work))
> +		queue_work_node(nid, system_dfl_wq, &node->work);
> +}

[Severity: Medium]
Can lowering pisa_reservoir_max race with pisa_reservoir_refill_node() and
skip queueing the trim work?

CPU0 (kworker)                        CPU1
pisa_node_work_fn()
  pisa_reservoir_refill_node()
    /* nr_pages =3D=3D 0, max =3D=3D 16 */
    spin_lock_irqsave(&node->lock)
    added =3D node->nr_pages <
            READ_ONCE(pisa_reservoir_max);
                                      pisa_reservoir_max_set()
                                        /* sets pisa_reservoir_max =3D 0 */
                                        pisa_schedule_reservoir()
                                          pisa_schedule_reservoir_node()
                                            READ_ONCE(node->nr_pages) !=3D
                                            READ_ONCE(pisa_reservoir_max)
                                            /* 0 !=3D 0 is false: skipped */
    list_add(&meta->list, &node->pages)
    WRITE_ONCE(node->nr_pages, 1)
    spin_unlock_irqrestore(&node->lock)

Because pisa_node_work_fn() only calls pisa_reservoir_trim_node() before
pisa_reservoir_refill_node(), the worker exits with an extra PISA page left
in node->pages above pisa_reservoir_max.  When pisa_reservoir_max is set to
0, pisa_reservoir_pop() bypasses the reservoir altogether, leaving that page
stranded in node->pages.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120010655.4678=
25-1-lrizzo@google.com?part=3D3

