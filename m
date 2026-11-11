Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0BBD606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 03:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mTm0px9h
Received: by kanga.kvack.org (Postfix)
	id CCECC6B00EF; Tue, 10 Nov 2026 22:43:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5C16B05B0; Tue, 10 Nov 2026 22:43:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBBC76B05B1; Tue, 10 Nov 2026 22:43:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4436B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:43:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5CE221C1556
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:43:47 +0000 (UTC)
X-FDA: 85421444094.05.79A2E0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A2E81C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:43:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mTm0px9h;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794368625;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+rqQqYrT9yFpTdM21Tx4bknM2pwbSO2Dwgz2+bmKog=;
	b=deT/p+mtxEXs6ySUyclFvw+pzoiHgK9hFxv8DFPkCOSFDyLt3Qtq584AFWzDMXVVYZaSm4
	m0AyFnhuL6AnzIE64BJ041VdkCYI24CMHfHJWEByDC1o68Gbgv2BP+G0UE+vCEuuMh1mP/
	dY+TFRDM5wxwo7AmzP75TfMLdG3RlrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794368625;
	b=MlsI4WB8dSChjRoyyQBhsS1lHTTAS1U+Ki+42JijfEm7owCyw+xvKhKpURC6KOYWNlXBHi
	9PKtHj71AB6zyFsJjSnjUo3LcKvZ1WJMsggWEWs9ysc+gaB60kI/aafnLuAuwJ2gHYf+69
	kkVhKGNUVAKjpj65thXNMbm9AGYHprw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mTm0px9h;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EC4040894;
	Wed, 11 Nov 2026 03:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE351F00A0A;
	Wed, 11 Nov 2026 03:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794368623;
	bh=S+rqQqYrT9yFpTdM21Tx4bknM2pwbSO2Dwgz2+bmKog=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mTm0px9hQxukgifXp/JR9YAFwSumMQuU4O2vZnNFuCDy9G7jEh633U/ahLzje1qhi
	 /Y1RGJDd70YEKPY/zKEpxd90Aj27ARyV3AWuhtt2bi3w2DFDO0ZNIgK1mr12pNJQiO
	 piURHjrf8TxXswtFrObGuO92q51LXHzt05Hfs8T+A+lL1p18+R9YI8awvdswGHohcB
	 1t15pahnoQ4v1P99Ytx302h0I6mC0JqTpcmXx5+lKZkJ7PNC8JdBA/Ol2wrM/ydrAg
	 jVvZlxafRdR2grK5cJ0YbJv1pmEYrvWTXZv0a1IXVTPfWDE0kdz6u+Mhvxv+ipMBTH
	 3kCrxnAcUdVxA==
Message-ID: <sashiko-outbox-208216@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 22/25] net/gve: Use PISA memory for RX buffers
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
In-Reply-To: <20261109182533.3594984-23-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-23-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 03:43:42 +0000
X-Stat-Signature: gtkd4u54f1qng3z4ud7nxfbqkin99dzs
X-Rspamd-Queue-Id: A2E81C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794368625-592865
X-HE-Meta: U2FsdGVkX18j3x6BFQL4Yzz8JKsEtuicYYkwO/w4MEohOTpAslpsfvuhFROCY0iRX3+XZou4Qbl9/sS5Tl9H9GRxGGAMMAV0swhllmtktCY9MFmfyNZSS7enzFszSKDh6GY4hVrzepSEwdL33ie9y8t9YoDhrkjfo7p/U2GRvmEBhihezNhdDKHJ4eT4cYJoRqjgfaBIlQKt4B4YfSgVaoFVT3XO42PZNl+2Lgtk7m8hSb/F2YreN7gzfXRu/67GID/5QQKPM5vYEDM6gJyJF/uwmBUnkNg3bvYPt1MWX5YKVuUXeeYdLKSlSMjvV8iB1b+pHtG8z4WN5SJFnSlrBYphlNEcaJvqLDiKOtbldTSIohexK0ubZ6YBAHSBVCzi8QuwZntKGskvqQNsxWsYJ8iTUQMCUPH7kgMtOm6Ce4MZCw5eheDvgW0uER10/20Je8elrt1ZaZVEMu0q8aGoAknaZAOyEOdlE4WxtYq6xpcK+Zzd6NFDMNzNGeQUzD6lvRPvaot+jMkI98uLXEbfkMCddbI0FyrL3pdAo0VfNRyMROcWXy5K1bkK0bUpvnV4F7nnSBfj9s6ceE8h9GnGtYk0XeIjmKCoIxO/+UHZmmssXhMDC17ZsimLzycluJ3fF/5I3prV2IElwj6GooImj2o00/a3JkzPW5+9gdhQCx3SFrEWrTp9miDSVmowjvFRK2xVHShPCFn8DYjWQH5GBsgGoc6KJJS6aJDCgAFIla86HLzelm+in13PORYsvP8W/Hf+XXy/WFAH+PdOvopAxb/NL47MzdW3Vg0tkHXU2VszgJclNlJPxvcjyWim5NXnwgqD++owP2KZ2pXiyoaerMll2RCEQA0rpEU3gwc2HoSm6H1vF2AH8iTmfoGWFJxsJcRR2OhenqIGmZv8JkAEzPYrc6oWwCuHBzM+SYOfnGb5KRm6YUCjoJb5dxqc572xE4JcjZLXDR1vmLCmNrE
 /rsSqrCv
 UEf+XKCYpVd/sKH9KzQ7bghdtUduvI4iyxvm8ADnEZ7pG8MOsYMJiflZRsCTMa3ZCu9H4xBOS+xfXTU7ZqjcdgKr2NItU+80OR2iNXZBJKx7ibW2m65TyqMmXgp1n4id9M1XgpMMAaiUvdu/G/KlWenxOvJmpUiuq5OcYZm28jpUOz47hFRTQAbK5auXR2gH/Wh8kBcrmahnZ0466sU3OabRqzVhWQ65jQ0NxNxKxGLTP6uDc+WibLsrjRQVdPQNB5qymUpFv4jAmfBOmRzXczH0I+CWzXTnaRwug8KRerf7pBaCnk796u6ZCBBHA9Ppnng6MmCxIa3F+uKcxg8l94qCVANFXvJrpoAYoz2woPe1iEYMrMOXkakapSozF9urC4LrTKafIqEAlJxLqsufhDl2DO8Mr5+gQ/3lZhUqQmuMmWeWTQhjWRMP984pejjB+M/BWI14pZ5jMUODU/4Bh2Oao98/1Epcwb3PLwK2Kfi1phT1m9efjCRXjQhcBjt+O/qQt1YgqfTrggv9DZnncCekyQBi7jGfM8RJrp5ZtwY6ZfGEnrf4kjivMEZz5c1ASDSklvw+Mf27JvQOlDIlpGdprVVTccC8HSrUX/bs+/nS0RqOzUWyQ45ePXX3JYqqkOlctt6hhgU2m+6railvzNq1RTgWbioEEcD08
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
- [High] net/gve: wrong GFP flags in gve_rx_alloc_buffer() via
  gve_get_napi_enabled()
- [Medium] net/gve: uninitialized new_info.can_flip copied in
  gve_rx_refill_buffers()
--

commit 58fd34b0315f121e3fcc6437dac09650326d6a54
Author: Luigi Rizzo <lrizzo@google.com>

net/gve: Use PISA memory for RX buffers

This commit allocates GQI-RDA RX packet buffers with pisa_rx_gfp(dev) when
PISA RX buffers are enabled, and replaces plain pages when free PISA RX
blocks are available.

> diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ether=
net/google/gve/gve_rx.c
> index 89f287b678bf0..85c243bbdeb33 100644
> --- a/drivers/net/ethernet/google/gve/gve_rx.c
> +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> @@ -4,6 +4,7 @@
>   * Copyright (C) 2015-2021 Google, Inc.
>   */
> =20
> +#include <linux/pisa.h>
>  #include "gve.h"
>  #include "gve_adminq.h"
>  #include "gve_utils.h"
> @@ -170,6 +171,8 @@ static int gve_rx_alloc_buffer(struct gve_priv *priv,=
 struct device *dev,
>  	dma_addr_t dma;
>  	int err;
> =20
> +	if (rx->data.raw_addressing)
> +		gfp |=3D pisa_rx_gfp(dev);
>  	err =3D gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE, gfp);
>  	if (err) {
>  		u64_stats_update_begin(&rx->statss);
> @@ -499,13 +502,19 @@ static void gve_rx_flip_buff(struct gve_rx_slot_pag=
e_info *page_info, __be64 *sl
>  	*(slot_addr) ^=3D offset;
>  }
> =20
> -static int gve_rx_can_recycle_buffer(struct gve_rx_slot_page_info *page_=
info)
> +static int gve_rx_can_recycle_buffer(struct gve_rx_ring *rx,
> +				     struct gve_rx_slot_page_info *page_info)
>  {
>  	int pagecount =3D page_count(page_info->page);
> =20
>  	/* This page is not being used by any SKBs - reuse */
> -	if (pagecount =3D=3D page_info->pagecnt_bias)
> +	if (pagecount =3D=3D page_info->pagecnt_bias) {
> +		if (rx && rx->data.raw_addressing &&
> +		    !is_pisa_page(page_info->page) &&
> +		    pisa_has_free_blocks_rx(&rx->gve->pdev->dev, 0, rx->gve->numa_node=
))
> +			return 0;
>  		return 1;
> +	}

[Severity: High]
Can gve_rx_alloc_buffer() sleep in softirq context or pass GFP_ATOMIC in
process context when selecting GFP flags via gve_get_napi_enabled(priv)?

In gve_turnup(), NAPI is enabled, IRQs are unmasked, and napi_schedule()
is called on all RX queues before gve_set_napi_enabled(priv) runs:

drivers/net/ethernet/google/gve/gve_main.c:gve_turnup() {
    ...
		napi_enable_locked(&block->napi);
		netif_queue_set_napi(priv->dev, idx, NETDEV_QUEUE_TYPE_RX,
				     &block->napi);
    ...
		mb();
		napi_schedule(&block->napi);
	}

	if (priv->tx_cfg.num_xdp_queues && gve_supports_xdp_xmit(priv))
		xdp_features_set_redirect_target_locked(priv->dev, false);

	gve_set_napi_enabled(priv);
}

With gve_rx_can_recycle_buffer() returning 0 to evict non-PISA pages even
when pagecount =3D=3D pagecnt_bias, a NAPI poll running before
gve_set_napi_enabled(priv) reaches gve_rx_refill_buffers() ->
gve_rx_alloc_buffer() while gve_get_napi_enabled(priv) is still false.
That passes GFP_KERNEL | __GFP_PISA_RW in softirq context, allowing the
page allocator or PISA metadata initialization and page decryption to
sleep in atomic context.

Conversely, gve_adjust_config() -> gve_queues_mem_alloc() and
gve_rx_queue_mem_alloc() pre-fill new RX rings in process context while
the interface is up and gve_get_napi_enabled(priv) is true, passing
GFP_ATOMIC | __GFP_PISA_RW and preventing PISA from blocking to initialize
metadata or decrypt pages.

Passing an explicit gfp_t parameter from gve_rx_prefill_pages()
(GFP_KERNEL) and gve_rx_refill_buffers() (GFP_ATOMIC) into
gve_rx_alloc_buffer() would avoid relying on gve_get_napi_enabled(priv).

[ ... ]

> @@ -987,12 +996,15 @@ static bool gve_rx_refill_buffers(struct gve_priv *=
priv, struct gve_rx_ring *rx)
>  				union gve_rx_data_slot *data_slot =3D
>  						&rx->data.data_ring[idx];
>  				struct device *dev =3D &priv->pdev->dev;
> -				gve_rx_free_buffer(dev, page_info, data_slot);
> -				page_info->page =3D NULL;
> -				if (gve_rx_alloc_buffer(priv, dev, page_info,
> -							data_slot, rx)) {
> +				struct gve_rx_slot_page_info new_info;
> +				union gve_rx_data_slot new_slot;
> +
> +				if (gve_rx_alloc_buffer(priv, dev, &new_info,
> +							&new_slot, rx))
>  					break;
> -				}
> +				gve_rx_free_buffer(dev, page_info, data_slot);
> +				*page_info =3D new_info;
> +				*data_slot =3D new_slot;
>  			}
>  		}
>  		fill_cnt++;

[Severity: Medium]
Does copying new_info into *page_info overwrite page_info->can_flip with
uninitialized stack memory?

new_info is declared on the stack without initialization, and
gve_rx_alloc_buffer() -> gve_setup_rx_buffer() only initializes page,
page_offset, page_address, buf_size, and pagecnt_bias, leaving can_flip
(and pad) untouched.  Previously, page_info was zero-allocated and this
branch was only entered when page_info->can_flip was 0.

When the next packet received into this slot takes the copybreak path in
gve_rx_skb(), a non-XDP_PASS verdict, or a drop path in gve_rx(),
page_info->can_flip is not updated, so the following
gve_rx_refill_buffers() pass checks an uninitialized page_info->can_flip
and can spuriously flip the buffer instead of checking whether it can be
recycled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D22

