Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B27CA606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 03:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l1pv33k7
Received: by kanga.kvack.org (Postfix)
	id 1AABE6B05B1; Tue, 10 Nov 2026 22:22:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181386B05B2; Tue, 10 Nov 2026 22:22:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BEB76B05B4; Tue, 10 Nov 2026 22:22:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D37596B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:22:54 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 525431201F1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:22:54 +0000 (UTC)
X-FDA: 85421391468.06.4DB97B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9ADF040003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:22:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l1pv33k7;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794367372;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YT1/oQUToBkhnA9VGxB8H+MfTWW7U3OJoaI+S7ENeAw=;
	b=HxjvEbvZNNP6WHPkn6FXu1uDaPC1jk9GAPTIKLRknPT/oDVK1Yj78VDTqL8DwIdOxJ+B3Y
	gtkPFlfh0//DRts46tMatDm5WCO406XaBYUS6WuVfOfAluhTxV2ChKDAc4SCRKjiysLWHA
	RyOTCT8n2KSK7yPtmxlDPeJ+wL1VPEE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794367372;
	b=SKwKIzm3XI7rv1zbuyvJAB8m6S6dxaCabUoaU8/RRr7/lkX7IpMn5W4Yo/8fwr2++eBGIl
	YqJWW7ONXKsbpATFvZ8iD6gUyM1TALbdSflWsmA4q/nicztrYqygTC7sCPOIkzsUYkM4Rv
	LE4bV+LXQACKvl0dLVKgne24qcBdCjI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l1pv33k7;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA51044F0B;
	Wed, 11 Nov 2026 03:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B14D1F0089F;
	Wed, 11 Nov 2026 03:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794367371;
	bh=YT1/oQUToBkhnA9VGxB8H+MfTWW7U3OJoaI+S7ENeAw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l1pv33k75UjpV0bd7Cdl3bHqqNCrFYcl4hNF1DhtHkanpBVtnvxXU6MSq1/5DEYLI
	 tzyTpqHozpHYoRS5UB20gfikApwvFCJD0bPkgFeRzf6+ZbJMtENsReMErxo9LJaGyG
	 tVu4JlFne8vK8kH/j5FCf+3BxCkUAZVzs8gnmjRhDD+kSjJ4La27RbOu1ilQOJ8fjz
	 aCDdq7Rqn7foNnitm6mY3ShQOJUOmL04o2We16sEApMeUA+fJMNTISjYoRvG7PfV9b
	 QJZNc9trI3izMH4v2s2jHoraetHmeliWqtOufjEVafGR2ja96WO79t/zYj2ZT4khcZ
	 jLHBfzTfFjs1w==
Message-ID: <sashiko-outbox-208173@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 21/25] net/gve: Use GFP_KERNEL when pre-filling
 RX rings
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
In-Reply-To: <20261109182533.3594984-22-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-22-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 03:22:49 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9ADF040003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: wtnp4ojx17w3ec5qqfsn7ankeuwgf5qo
X-Rspam-User: 
X-HE-Tag: 1794367372-301600
X-HE-Meta: U2FsdGVkX19A5iLH/Bf3xpYHdmd45VLWhn7/CvDKZCCIai2Txd81oYj0CNFfdqcAN3C1V4iVqBfy/o4KczaKE95evzBqE6iIgXKEttM+u3RGkv1ZLym8y0WT/RSjrHJl7TLHLvO49Iyrw/6yts53B9qNmCttOYXuRPbjU0DIf8f2Ke69BBP48W1vZuQCu6S1VnjqE4CJKNVSn38Vu2avFNF+07W0O9SSweVf56Bk0weiO0QQIg4+BOwK5WKaXkmcOuSp7vTqTQAQ0Og2oSLhrP5HYI/hxXlRL9GJ+qS809h5j8lub86WOtAcT3dhH9dOyLwkRT+glFHQgSpN5JSx/scsPt6cPUpg1QP/20138A9rA6t8NLkeaaIbMriATVyggSVf5wf3ZFhrG/9vmcRUhOKZsn19Ms2uvVmmco1y7aGEZs6tKTVMopi6OBoKHplPyXRWKdq8F4VRC5QiUAQYiVdPg8y2WUhkE2fASWt9a6ZR8MvcaUdAySEewWCfBxkFrWM7mcasI6eqK6OGWkUkfst3O1BSuAkvkANvmPtiXYV2Ublbey+Op+Uw3ULjUaaHfxtGjY2rV52/ZDClBXnKheSrR9n1py4i0dvR9uoGU8t2sysIgqA9QsS6TOs/YMFhVhyaLp2Xu0vjyP8c+jzso5KwkyuGmWUlzBOE4YJj0t6y3TTiLMigqURkAOg2KxUbHl9PVS39Bm51Fqw4oLXG52IVPYErNED4NO3T+NbD0hvJ66tJGL7I8lqRG0RMJoZD8KlnLiwPkoDlsaeE1KYYiGgVK7hKzoa9QtW0sFIARXehn1WwWai9R8cAe3AKAweH0GuRAL7Qhpr5M4lcF48GZhlnujVOwAolB/W26IjUM7YZFATf81obIjPyE104rl84VeTlaOipEHoet4lm1EzewIt24y2D5x4JNGTaIcKaWmSP32My5xtGJUu8LHS+1G8lFKPY1bqMmCiWhryR6+9
 JWe0V3xM
 lHKlEDiu0R2RZfEapX37Ta3TSmcKhkTHp24PCnwEfSzRsXD6r54LKGyMWwHig4UM/Rn1w0EU/J5kgLzQGlR5gZKIZVZjXHONUcnOZ1CnjXy3Mmc26uymFdOmwFbRUXEDnrmZmnmG7EiUeokWQD1WNoEt8GbtEQMHl2HsNCggXlkbo3VRpjnthMx6M2nFLwCDgWxhtUZJgxKYanaJQdtXa3pHB0qZT75GwmZ2N7XT5KVZYqJ6IPsokEUM597WghAq+uicSU72q39b2QgKxva5qrSAjQ9GFZQIfnoIARQnmAirFVyAB1Ae5H0sIQa3CDXR4UrBplf5l/w6v0ftt+f+Dtt9AoAn8CH8L3v5QTgQ+pYxaS3drybSiBxHD6aZfnW9WnCahDFUYaG+/bgI2SuYBDIknY6NZXOqKqm1kmC5OSk+9QlXT8gTSeFc7aCFfpoZBPwyTM0+uf98zVWSL6hiG04r5jmM0fcZsf5ZwyhSAbpMGn+iMGbVwuQJKwcy5lf9GmvOC4gS3nZmSzOQEo8xZF5Rqnopah88ZFbZnhf9AmkyH+YfQL1qe/HdPpe2PaMNX7V2b/uVIT1rXaf27L7X6RShwVWZg8XBJD06PLw5DsmVP2Oc9KmZVJu8ub6FDLH1ccOdgTQ47o+5EJkkTq503fooHUNgnSewmN1I9/G1yZUs0vI2ZQoJjNOMn0MF6Qj6XqbnYKHySLG6BDC+En39WXPBAJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] net/gve: sleep-in-atomic GFP_KERNEL alloc in NAPI poll during
  gve_turnup()
- [Medium] net/gve: gve_rx_alloc_buffer() uses GFP_ATOMIC on live config
  pre-fill
--

commit 1b07e24554dc827c263c1efbdbd4b2e0d6ee11bf
Author: Luigi Rizzo <lrizzo@google.com>

net/gve: Use GFP_KERNEL when pre-filling RX rings

This commit uses GFP_KERNEL instead of GFP_ATOMIC when allocating RX ring
buffers in gve_alloc_from_page_pool() and gve_rx_alloc_buffer() while
gve_get_napi_enabled() is false.

> diff --git a/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c b/driv=
ers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c
> index 6880d1531ba5e..3b13aa4999ae5 100644
> --- a/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c
> +++ b/drivers/net/ethernet/google/gve/gve_buffer_mgmt_dqo.c
> @@ -223,13 +223,18 @@ void gve_free_to_page_pool(struct gve_rx_ring *rx,
>  static int gve_alloc_from_page_pool(struct gve_rx_ring *rx,
>  				    struct gve_rx_buf_state_dqo *buf_state)
>  {
> +	/*
> +	 * Use GFP_KERNEL when pre-filling RX rings in process context (e.g.
> +	 * gve_open) so PISA metadata init and CoCo page decryption can sleep.
> +	 */
> +	gfp_t gfp =3D gve_get_napi_enabled(rx->gve) ? GFP_ATOMIC : GFP_KERNEL;
>  	netmem_ref netmem;
> =20
>  	buf_state->page_info.buf_size =3D rx->packet_buffer_truesize;
>  	netmem =3D page_pool_alloc_netmem(rx->dqo.page_pool,
>  					&buf_state->page_info.page_offset,
>  					&buf_state->page_info.buf_size,
> -					GFP_ATOMIC);
> +					gfp);

[Severity: High]
Can gve_alloc_from_page_pool() (and gve_rx_alloc_buffer() below) be called
from NAPI poll with GFP_KERNEL during gve_turnup()?

In gve_turnup(), each RX queue's NAPI is enabled, its IRQ doorbell is
unmasked, and napi_schedule() is called inside the per-queue loop before
GVE_PRIV_FLAGS_NAPI_ENABLED is set at the end of the function:

drivers/net/ethernet/google/gve/gve_main.c:gve_turnup() {
    ...
	for (i =3D 0; i < priv->rx_cfg.num_queues; i++) {
        ...
		napi_enable_locked(&block->napi);
        ...
		mb();
		napi_schedule(&block->napi);
	}
    ...
	gve_set_napi_enabled(priv);
}

CPU0                              CPU1 (<softirq>)
gve_turnup()
  napi_enable_locked(&block->napi)
  napi_schedule(&block->napi)
                                  gve_napi_poll_dqo()
                                    gve_rx_poll_dqo()
                                      ...
                                        gve_alloc_from_page_pool()
                                          gve_get_napi_enabled() -> false
                                          page_pool_alloc_netmem(..., GFP_K=
ERNEL)
                                            <-- sleep in atomic context
  gve_set_napi_enabled(priv)

If NAPI runs on another CPU or on softirq exit before gve_turnup() finishes
the loop and calls gve_set_napi_enabled(priv), refilling buffers from
softirq context will use GFP_KERNEL and sleep in atomic context.

> diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ether=
net/google/gve/gve_rx.c
> index 81ea800e66e94..89f287b678bf0 100644
> --- a/drivers/net/ethernet/google/gve/gve_rx.c
> +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> @@ -161,12 +161,16 @@ static int gve_rx_alloc_buffer(struct gve_priv *pri=
v, struct device *dev,
>  			       union gve_rx_data_slot *data_slot,
>  			       struct gve_rx_ring *rx)
>  {
> +	/*
> +	 * Use GFP_KERNEL when pre-filling RX rings in process context (e.g.
> +	 * gve_open) so PISA metadata init and CoCo page decryption can sleep.
> +	 */
> +	gfp_t gfp =3D gve_get_napi_enabled(priv) ? GFP_ATOMIC : GFP_KERNEL;
>  	struct page *page;
>  	dma_addr_t dma;
>  	int err;
> =20
> -	err =3D gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE,
> -			     GFP_ATOMIC);
> +	err =3D gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE, gfp);

[Severity: Medium]
Does gve_rx_alloc_buffer() still select GFP_ATOMIC when pre-filling GQI RX
rings on a running interface?

When reconfiguring queues or ring sizes on a live device,
gve_adjust_config() calls gve_queues_mem_alloc() -> gve_rx_alloc_rings_gqi()
-> gve_rx_alloc_ring_gqi() -> gve_rx_prefill_pages() before calling
gve_close() to turn down the device and clear GVE_PRIV_FLAGS_NAPI_ENABLED
(and similarly in gve_rx_queue_mem_alloc()). Because gve_get_napi_enabled()
is still true during this process-context pre-fill, gve_rx_alloc_buffer()
falls back to GFP_ATOMIC and can still exhaust atomic reserves or fail
allocation. Passing a gfp_t parameter explicitly from the pre-fill vs NAPI
refill callers would avoid depending on GVE_PRIV_FLAGS_NAPI_ENABLED for
both issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D21

