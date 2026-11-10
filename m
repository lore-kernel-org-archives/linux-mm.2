Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC0C606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 23:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Et63vtGd
Received: by kanga.kvack.org (Postfix)
	id 176866B05B3; Tue, 10 Nov 2026 18:50:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 128526B05B4; Tue, 10 Nov 2026 18:50:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03DC46B05B5; Tue, 10 Nov 2026 18:50:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC6926B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:50:48 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 446101201A0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:50:48 +0000 (UTC)
X-FDA: 85420856976.22.94884C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9A56FC0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:50:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Et63vtGd;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794354646;
	b=HNpV9GI0WRDRRld6h7hASNzBA06jutVcAfKyXFvjcCJn/EbfL4p081DEZR1huTZJqbKwOO
	iMZR3rX8gnfK6yCUfs/IrHawO3tEYcJRXLASHddhiipn7VffdzPr0YeWjDpKmkpwSt/NTc
	WRTZogcPQ92+D0SV5nyByvw5rNufT6k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Et63vtGd;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794354646;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSHVo5Z8Mhi/Q8cDi0msIQSpFPFrZfC36MvEomP98P8=;
	b=s56wPPkIwWWBFx1T98KTMtYzfNPZq0Ud+VhLpmUYQxZPgJ1Dc0Tah/cj6JcuqrO1bn03K6
	9Z9o3vuoCEuHpRQEfHf+PmOFLkvfpsiPPRfb62xGgdhGAlPylv/yEDOxdcbN137iBsUrdE
	QpOtTWXOFOhnsceVkgbMTs6j9u6vpCg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78A0B414BB;
	Tue, 10 Nov 2026 23:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FB21F0093C;
	Tue, 10 Nov 2026 23:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794354645;
	bh=WSHVo5Z8Mhi/Q8cDi0msIQSpFPFrZfC36MvEomP98P8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Et63vtGdiLmK4F83s6L0TlV35e/czXM9iItm3InaKNLDeFdeuDXsZtGmKJX/R6IGj
	 qX8kqIt3SKsRXq3YDINL0D/L5cdzfH4WaVyT8qbloauYwBZJcXRrn228MUPBktjbw5
	 g1/Luqj46JHcac301+2jtfx7T7tRxdEb0nR+ZyQiwXipq4WMCESPvXtH1ydQCcqd+p
	 kUnKkTaXiVzLTQc3QzbjyzpdfELcJRP8DFCJ49UxcxXCgxEYUOpdL27hyzZRyCLOfg
	 d/QT5KxEc1YzvTTVEvnmapGAgdHw4RwcBq0TMYqVJ5bwTin9a9a3OwkbFZi4vJ4EMG
	 RQYODSVzx/6KA==
Message-ID: <sashiko-outbox-207955@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 12/25] net/core: Use per-node PISA allocators for
 skb_page_frag_refill()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Luigi Rizzo" <lrizzo@google.com>, "Luigi Rizzo" <rizzo.unipi@gmail.com>, "Joerg
 Roedel" <joro@8bytes.org>, "Will Deacon" <will@kernel.org>, "Robin Murphy" <robin.murphy@arm.com>, "Christoph
 Hellwig" <hch@lst.de>, "Marek Szyprowski" <m.szyprowski@samsung.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "David S .
 Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Matthew
 Wilcox" <willy@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Willem
 de Bruijn" <willemb@google.com>, "Kuniyuki Iwashima" <kuniyu@google.com>, "Joshua
 Washington" <joshwash@google.com>, "Harshitha Ramamurthy" <hramamurthy@google.com>, "Alexander
 Lobakin" <aleksander.lobakin@intel.com>, linux-mm@kvack.org
In-Reply-To: <20261109182533.3594984-13-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-13-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 23:50:43 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9A56FC0003
X-Stat-Signature: tb5rrzeq84qm3jkyj8fzqt5djsm9rpb3
X-Rspam-User: 
X-HE-Tag: 1794354646-627560
X-HE-Meta: U2FsdGVkX18TpAsYSbeiwWGaHWtB65QZNjcc1XdoUQVtnt1PJg9Bzg1faPk1qvPlkQLqDEBjEb0qrmIk4Cgc4wdAuuHZgJbeKXcqvr8CKV57f0uV3qTX5NPwBsxpDVDgk/9eDjYvUEPrjT89OG4n9Ky7C4Sg0IfKuVcs6asYT9VPzOWxhdBvGg5dmyYv3XG8PAkp1xVTcTZi5tL9Bk8EgsG0TBL3EIBEUU4nBfvMEouVxhppPdu2rGRHcUtmUFujuBRcQbwmDak1dRg8zpejUpjiGrnBW/ZU1hpZP+sDULpM50T8Ad9GMY7g3e80Qa4u1oF9+ZGSapHw441WjmM8w8VQZYQppnQk7Y+Qcqnkc4nZSHon1hZpBZ2l38aJAiDuDkH5iW+kA9B2O973eW/3HNy6mqvfPWqmRBx+dtRAK/HTTO1F9OWeKoaDLmqIH4IZBaiKQN4Dyd3P3PUp20cr/4d2IDMZ6RSLntT0EmHYPR/HY7gOs6IqrFtOMAT/0rx+TD/nfHaqad/SclzWpttUkqqWfyBmncZs+zbzes0+VWUUHzWoP9V0Z89rqRADz/dMJb9PYYCkVEkZbK6DJeubLtW4exGmWQYIPi21Uzhphsc5BpyTb/+bREtGqd+hs94OWiI+vWzCJ87aku+IFZwFGsFThWK19EyBKvxgIJGmP3RbYM332SrDgMKNMCw+j1SeWAakezNV7e9MRhote4+ZhZJ1elHOocK6Mp/gJa/E8fOAgacsupe0y+BndTFnKYaAiOSV2oJ3rqfT6q0sY944teTrAorWyrd1+/VpvEG8ORdbp4R/iFh/DARjtLqRvksDDtXoU0t480MdAMtNDdT6oLryrdJUkQQyS3Cu/3/dwouOSObFoqHlRtJ/pEzThdjPnUxpHxV/Ygp22NKawqiN/1doCL2bVh5hdcN4KTp5VmrMh+er2wuOxIAkU8Au8nHgaPGAYp8P0G1qerCcyr5
 tnPR1Veg
 wCNi0MhWw1HZ9q5KbgruESk6HUhaQItsYlhzHddvfpbK1drX9T6qh84P/3+meZUa2Y7z6yppF6wfMm1gO1EZdFJGGniicqm0cDFVBIGQTzLpcJaaHzvJUNYSHMSQ2ZnlFQk62K36IU8pK6awKHDxzSx+SzMBe8SoXA+SolXqyCU7Cbi3RmcXdiaZFXqYf4sYkB4514nR0ck4PiUiQcHs0MlJZAaOSqYNMgABcQOj7MC2xYbOK+xNkdOrTG33tXm5ciLgfYFXg/bFUzk1W+tZYIPCUMlzp6yDUYkPJWi0HmaFWXsePvUqV52a2K/R4YC06mQfyDXEJzYhW4gH3OQzVVZoX6wxAKIccFlM/cHjuHf3hvnNxEYJWSCb0K+NmV337ix+xlRUvb5/fTodPEvGNDOzWjsiMT440iIKSYxr/j2jFD1j2qQFI/oChGBGfkV6OZ+yxKDirXOCk626de30Tbp1s6IgHbs3yNEjOvX5HkK77ehBDKc3phjk3EqSP/aOClG5bFTc8eQ9gZe/MBoHhOuADRG0VW80UXA1GIZea8OVqTcFP6i82glN1AYQ1/nl+VNPEecQDLICj3lZ6CJNTZ3tjGFgV9uP55vXpfXsNnLOb0X9cP4c8TB1VqN9trEVHnYz40AriSXxjISzqexaNhHBizMmTa+AKOG+1EVisPAClOdQqR6fYQzNm+wHm024T5uE9Le3aAZ8pQiEJpaeQXTq8tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential
issues to consider:
- [High] net: ip_make_skb() and ip6_make_skb() ignore sk_use_task_frag
  for PISA
- [Medium] net: skb_page_frag_refill_dev() checks ingress skb->dev on
  forwarded ESP packets
- [Medium] net: mismatched PISA and buddy page recycling in
  skb_page_frag_refill()
- [Medium] net: odd-offset checksum corruption in ping_getfrag() with
  PISA paged mode
- [Medium] net: plaintext TX data placed in PISA pages on MACsec in
  dst_tx_pisa_ok()
- [Low] iommu/pisa: netdev_tx_pisa_refresh() skips lower walk when
  dev.parent is set
--

commit 8f85f66c700b51ce7332c64edba9f65c4414c1f0
Author: Luigi Rizzo <lrizzo@google.com>

net/core: Use per-node PISA allocators for skb_page_frag_refill()

This commit adds per-task PISA page_frag support (current->task_frag_pisa)
and routes TX page_frag allocations to read-only PISA blocks when the
egress device has pisa_tx_bufs enabled.

> diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
> index 913706a503341..7b9d0a7acc101 100644
> --- a/drivers/iommu/pisa-alloc.c
> +++ b/drivers/iommu/pisa-alloc.c
> @@ -644,6 +644,63 @@ bool pisa_has_free_blocks_rx(const struct device *de=
v, unsigned int order, int n
[ ... ]
> +/* Slow path of __netdev_tx_pisa_ok(): refresh dev->pisa_tx_stamp. */
> +bool netdev_tx_pisa_refresh(struct net_device *dev, u32 now)
> +{
> +	bool ok;
> +
> +	if (dev->dev.parent) {
> +		ok =3D READ_ONCE(dev->dev.parent->pisa_tx_bufs);
> +	} else {
> +		rcu_read_lock();
> +		ok =3D netdev_walk_all_lower_dev_rcu(dev,
> +						   netdev_pisa_tx_bufs_walk,
> +						   NULL) !=3D 0;
> +		rcu_read_unlock();
> +	}
> +	now |=3D ok ? PISA_TX_STAMP_OK : 0;
> +	WRITE_ONCE(dev->pisa_tx_stamp, now);
> +	return now & PISA_TX_STAMP_OK;
> +}

[Severity: Low]
Does checking dev->dev.parent before walking lower devices miss lower DMA
NICs under upper devices that set dev->dev.parent?

Stacked interfaces such as net_failover, hv_netvsc, and DSA user ports set
dev->dev.parent via SET_NETDEV_DEV() while linking the underlying PCI VF or
conduit NIC as a lower device.  When pisa_tx_bufs is enabled on that lower
device, netdev_tx_pisa_refresh() only reads the upper device's
dev->dev.parent->pisa_tx_bufs (false) and skips
netdev_walk_all_lower_dev_rcu(), leaving TX allocations on regular buddy
pages.

> diff --git a/include/net/sock.h b/include/net/sock.h
> index 173b37b2b8bb0..73906351d11db 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2670,6 +2670,95 @@ static inline struct page_frag *sk_page_frag(struc=
t sock *sk)
[ ... ]
> +/*
> + * May TX payload routed through @dst be copied into PISA pages? Those p=
ages
> + * stay readable by every device that mapped them for as long as they are
> + * active, so only data that leaves the host in clear qualifies: IPsec p=
ayload
> + * is still plaintext here.
> + */
> +static inline bool dst_tx_pisa_ok(const struct dst_entry *dst)
> +{
> +	bool ok =3D false;
> +
> +	if (!net_pisa_tx_bufs_enabled() || !dst)
> +		return false;
> +
> +	rcu_read_lock();
> +	if (!dst_xfrm(dst))
> +		ok =3D __netdev_tx_pisa_ok(dst_dev_rcu(dst));
> +	rcu_read_unlock();
> +	return ok;
> +}

[Severity: Medium]
Can dst_tx_pisa_ok() place unencrypted plaintext into PISA pages when
routing over software MACsec?

A MACsec net_device has dev->dev.parent =3D=3D NULL and links its physical =
NIC
as a lower device, so netdev_tx_pisa_refresh() propagates PISA_TX_STAMP_OK
from the NIC to the MACsec interface while !dst_xfrm(dst) is true.  Socket
send paths then copy plaintext into current->task_frag_pisa before
macsec_encrypt() runs, exposing cleartext in DMA-readable (and on CoCo
guests, shared/decrypted) PISA pages and holding it in tcp_rtx_queue until
ACKed.  In addition, forcing paged =3D true in __ip_append_data() and
__ip6_append_data() causes macsec_encrypt() -> skb_cow_data() to
immediately reallocate skb->head and linearize the fragments.

> diff --git a/net/core/sock.c b/net/core/sock.c
> index e2401d735c5a7..695fefe316925 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
[ ... ]
> @@ -3257,13 +3258,20 @@ DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disa=
ble_key);
>   */
>  bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_=
t gfp)
>  {
> +	/* PISA pages only go into current->task_frag_pisa, see sk_page_frag_ds=
t(). */
> +	if (is_pisa_pfrag(pfrag))
> +		gfp |=3D __GFP_PISA_RO;
> +
>  	if (pfrag->page) {
> +		if ((gfp & __GFP_PISA_RO) && !pisa_page_can_recycle(pfrag->page))
> +			goto drop_page;
>  		if (page_ref_count(pfrag->page) =3D=3D 1) {
>  			pfrag->offset =3D 0;
>  			return true;
>  		}
>  		if (pfrag->offset + sz <=3D pfrag->size)
>  			return true;
> +drop_page:
>  		put_page(pfrag->page);
>  	}

[Severity: Medium]
Does skb_page_frag_refill() recycle a page of the wrong type when
page_ref_count(pfrag->page) =3D=3D 1?

pisa_page_can_recycle() returns true for non-PISA pages:

drivers/iommu/pisa-alloc.c:pisa_page_can_recycle() {
	if (!is_pisa_pfn(pfn))
		goto out;
    ...
}

If current->task_frag_pisa or x->xfrag caches a fallback buddy page (for
example after a high-order PISA pool miss or before pisa_tx_bufs was
enabled), skb_page_frag_refill() resets pfrag->offset =3D 0 whenever
page_ref_count(pfrag->page) =3D=3D 1 and reuses the buddy page indefinitely
instead of allocating a PISA page.  Conversely, if x->xfrag holds a PISA
page and pisa_tx_bufs is later disabled on the egress device,
!(gfp & __GFP_PISA_RO) skips pisa_page_can_recycle() and keeps recycling
and pinning the 2MB PISA frame at refcount 1.

> @@ -3289,6 +3297,39 @@ bool skb_page_frag_refill(unsigned int sz, struct =
page_frag *pfrag, gfp_t gfp)
>  }
>  EXPORT_SYMBOL(skb_page_frag_refill);
> =20
> +/**
> + * skb_page_frag_refill_dev - GFP_ATOMIC skb_page_frag_refill() for @skb=
 TX
> + * @sz: minimum size of the fragment we want to get
> + * @pfrag: pointer to page_frag, private to the caller
> + * @skb: packet being transmitted
> + *
> + * Pages come from the per-node DMA_TO_DEVICE PISA allocators when they =
are
> + * useful for @skb's egress device (__netdev_tx_pisa_ok()), otherwise fr=
om the
> + * buddy allocator. PISA pages are readable by every device that maps th=
em
> + * while they stay active, so @pfrag must only ever hold data meant for =
devices,
> + * e.g. ciphertext; it may mix PISA and ordinary pages.
> + */
> +bool skb_page_frag_refill_dev(unsigned int sz, struct page_frag *pfrag,
> +			      const struct sk_buff *skb)
> +{
> +	gfp_t gfp =3D GFP_ATOMIC;
> +
> +	/*
> +	 * Before ip_finish_output2() populates skb->dev (e.g. esp_output),
> +	 * the egress device is carried by skb_dst(skb).
> +	 */
> +	if (net_pisa_tx_bufs_enabled()) {
> +		const struct dst_entry *dst =3D skb_dst(skb);
> +
> +		rcu_read_lock();
> +		if (__netdev_tx_pisa_ok(skb->dev ?: (dst ? dst_dev_rcu(dst) : NULL)))
> +			gfp |=3D __GFP_PISA_RO;
> +		rcu_read_unlock();
> +	}
> +	return skb_page_frag_refill(sz, pfrag, gfp);
> +}
> +EXPORT_SYMBOL(skb_page_frag_refill_dev);

[Severity: Medium]
On forwarded packets entering esp_output() or esp6_output(), doesn't
skb->dev still point to the ingress device?

In ip_forward() -> xfrm4_output() -> esp_output() (and the IPv6 equivalent),
skb->dev is not updated to the egress device until ip_output() runs after
xfrm_output() finishes.  Preferring skb->dev over dst_dev_rcu(dst) checks
pisa_tx_bufs on the ingress interface instead of the egress interface for
all forwarded ESP traffic.

> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 3396f177a18d0..a5ea530bc8b5b 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -986,7 +986,10 @@ static int __ip_append_data(struct sock *sk,
> =20
>  	exthdrlen =3D !skb ? rt->dst.header_len : 0;
>  	mtu =3D cork->gso_size ? IP_MAX_MTU : cork->fragsize;
> -	paged =3D !!cork->gso_size;
> +	paged =3D !!cork->gso_size ||
> +		(sk->sk_type !=3D SOCK_RAW &&
> +		 (rt->dst.dev->features & NETIF_F_SG) &&
> +		 is_pisa_pfrag(pfrag));

[Severity: Medium]
Can setting paged =3D true for all sk->sk_type !=3D SOCK_RAW sockets corrupt
IPv4 ICMP checksums on SOCK_DGRAM ping sockets?

IPv4 ping sockets have sk->sk_type =3D=3D SOCK_DGRAM and use ping_getfrag():

net/ipv4/ping.c:ping_getfrag() {
	if (!csum_and_copy_from_iter_full(to, fraglen, &pfh->wcheck,
					  &pfh->msg->msg_iter))
		return -EFAULT;

#if IS_ENABLED(CONFIG_IPV6)
	if (pfh->family =3D=3D AF_INET6) {
		skb->csum =3D csum_block_add(skb->csum, pfh->wcheck, odd);
		skb->ip_summed =3D CHECKSUM_NONE;
		pfh->wcheck =3D 0;
	}
#endif
	return 0;
}

When paged is true and a ping payload crosses the end of
current->task_frag_pisa.page starting from an odd pfrag->offset, the first
chunk has an odd length (pfrag->size - pfrag->offset) and the second
ping_getfrag() call starts at an odd packet offset.  Because the AF_INET
path accumulates directly into pfh->wcheck with progress =3D 0 and ignores
odd, the second chunk's bytes are added with inverted byte lane alignment,
producing an invalid ICMPv4 checksum.

[ ... ]

> @@ -1592,7 +1595,7 @@ struct sk_buff *ip_make_skb(struct sock *sk,
>  		return ERR_PTR(err);
> =20
>  	err =3D __ip_append_data(sk, fl4, &queue, cork,
> -			       &current->task_frag, getfrag,
> +			       task_page_frag(cork->dst), getfrag,
>  			       from, length, transhdrlen, flags);
>  	if (err) {
>  		__ip_flush_pending_frames(sk, &queue, cork);

[Severity: High]
Can ip_make_skb() and ip6_make_skb() re-enter current->task_frag_pisa and
cause a use-after-free when a socket has sk_use_task_frag =3D=3D false?

In-kernel sockets that transmit during memory reclaim or page faults (such
as SUNRPC/NFS over UDP, which sets sk->sk_use_task_frag =3D false in
xs_udp_finish_connecting()) call ip_make_skb() and ip6_make_skb().  Before
this patch, non-GSO sends in __ip_append_data() and __ip6_append_data() had
paged =3D false, so normal RPC datagrams never used pfrag.  Now ip_make_skb=
()
and ip6_make_skb() pass task_page_frag() without checking
sk->sk_use_task_frag, and __ip_append_data() / __ip6_append_data() force
paged =3D true when is_pisa_pfrag(pfrag) is true:

tcp_sendmsg_locked()
  pfrag =3D sk_page_frag_dst(sk, dst)  /* &current->task_frag_pisa */
  sk_page_frag_refill(sk, pfrag)
  skb_copy_to_page_nocache(..., pfrag->page, pfrag->offset, copy)
    <page fault on user buffer / direct reclaim>
      xs_udp_send_request()          /* sk->sk_use_task_frag =3D=3D false */
        ip_make_skb()
          __ip_append_data(..., task_page_frag(cork->dst), ...)
            skb_page_frag_refill(..., pfrag, ...)
              put_page(pfrag->page)  /* frees outer page at refcount 1 */
  /* writes to freed pfrag->page, or corrupts pfrag->offset */

Passing sk_page_frag_dst(sk, ...) in ip_make_skb() and ip6_make_skb() would
respect sk->sk_use_task_frag and use &sk->sk_frag instead.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D12

