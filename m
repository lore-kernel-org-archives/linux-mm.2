Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44313606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 03:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W/3KgFn3
Received: by kanga.kvack.org (Postfix)
	id BA9E96B05B5; Tue, 10 Nov 2026 22:13:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B82546B05B6; Tue, 10 Nov 2026 22:13:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74126B05B7; Tue, 10 Nov 2026 22:13:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0AF6B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:13:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9F7FC01FA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:13:54 +0000 (UTC)
X-FDA: 85421368788.26.662D80D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3EEAC2000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:13:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/3KgFn3";
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794366833;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+I1uHC/fXbTeIPsQeUhAQyP8+b7kDHgcJvwZiGIC+E=;
	b=5C/8/+szPTb5QM2SZPeUQrk5vRaNqnsTzyFZ+ksCbQUiQQte+oiBb5UmIkpZnf3MnwdLRS
	Rf9N1VuoT0e9Y3AmElauHzi6fVmkBx2UOuQeOkeFBYRc6QOVb9M5WLCF1uO5iSKRGre0np
	DqF/457Obf5uSGsgXo3L5wp+ht3lOD0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794366833;
	b=BHrv2s/ZP9tvQXezn8CXUqZRey8rvDh1GFif6NMA/Rt339lfHDetodtiDdDpY80GbL9T7L
	LFdHv+M+UsvwQ7K4gaRKVb7MZbWSUZjRDNzYLaECfuxhAjQ/ES1B+ZLvnQQpgQDcEIYOvN
	y2gMV4kt9YzGs6WkyOcgkaqnqKOV4+A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/3KgFn3";
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0C71611E7;
	Wed, 11 Nov 2026 03:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135BF1F0089F;
	Wed, 11 Nov 2026 03:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794366832;
	bh=g+I1uHC/fXbTeIPsQeUhAQyP8+b7kDHgcJvwZiGIC+E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W/3KgFn3VAOzjnfz16QpC5oZk5GrnrNHSU6+vxnfLDlJVpm4wk9+3P2i3C/2kxSka
	 HVtOdfAyVb++vKxBmUXf23atiD1bgd6FBpfzprpDTfjXm1xQMPTlJ2/0AWUXi5omBM
	 hzTLX1w+i4kWsOCTPp4nMLJZQu0Y/riUlkZE9pSuLMuk/zxCx2+1Vp/O760ZWarudU
	 nY1f1T+8BH4csv5J8GbqaMZNv8NQoHWRGPOu+Zo+BJt9ogH/lkzqfJxPShrZtJfOHb
	 AyoGiX7KVrXb/BvH+8OZGRC7KrY7l5jStomtcqvFAMQNKtj9eg3a9Kda5gjLgkrqbw
	 hhRttC7k7UttA==
Message-ID: <sashiko-outbox-208165@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 20/25] net/libeth: Use GFP_KERNEL when
 pre-filling RX rings
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
In-Reply-To: <20261109182533.3594984-21-lrizzo@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261109182533.3594984-21-lrizzo@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 03:13:49 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3EEAC2000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ndu8186azzshgybh8e5sr6btchg51xn5
X-Rspam-User: 
X-HE-Tag: 1794366833-687174
X-HE-Meta: U2FsdGVkX1+0mBPoXK8Pj5A+NShNJwb0PBNDDADhAVuIzZnqbLNXWmPl2NuAYhJzgH2+9xJdj1dyXPnmYyN6s88QHx+8MBhJ2pd37fUGm+yzQXqqfRWxFIvWQh9NESO5iA3nmlA/mCgHEXCfU3lWcNFSEoUd1xIPCxflprC2cNHhfSbmrS5TxTctQOJwhme46n0Q6VG9LgC6vdKMMBZsUN/h4H6MK7y2y5+2bVTX7TvrQZK/JE0VI1CZf8ckvOI4JePhgL7d0N8a127i/MzhCktG/au87AhTFB42MTW/tTz2b1uFE7flHABwqRO55lOMV5V4ADsPN+dVR3oM28r8XWPMLQMzLWXH0w16iwzX+oeya858SxUn9M4WogR95yoYa3+1Jp/Jw+orZEwvwVOzUbZYopPYQ0KW4ckPSKAI3SYdX1ppswcU8ZxEJcjZ2JqRFzMEqfKPQX5hIOOZAYXRV/t11QQnyBAzFsAWlAP1cdB7m4Zxps8o2iaMbU933i5bscxysaEgeFCGBEFDB/JF1AB5pQp7jhmispLC5ub8+3m1a2qfNz7UgABIZupXD4v1hlGXkfDGPf6AIs3W5PLXw/2BXZqAqXk4RPq/JsszFiBb0JCB3rvw/2UP1Tld1Iyy6vxKlPvNSfHuXdgIX74AynJrAhyIZaD3rD9rpG2+cjaAp/siA2OgW5tuijdSlo+P90rwHQI00xONUj9A3hkFrmJ1gMXA2GOZgLoa7qnqXeyoKWf62nAGOVgujabRjEFvBrs/QtlrunhgJ79vZbusJ8/Pe9XOgKRbOAF7gTdySuFu6chabvGn2ByUxBTASA0Q6nReOemjteRd1ktpwiqiLVTh5AWMpVtv1WiP4qRMiCgmXy1soMueXMZSz8gagUGrVoqcYd6ny+bfOZcUFVnpUZXxGkOcnku2I/cFkXTM7KVM94skw8qWB2KKuvsi0ftCCS+SDhl+osKYWBL5tbH
 GpvPQ+XS
 nLl3i9k3zsbcJMqZi5XUbJFykfcCt57ocs5EJiZlWEG7oFPNfy2KXjxq2qoxf2uR0TANYIxxGahmyCJ88C+QcB+HVvPlWkZDhHkk5Wqo8wBzGiPnS+6/z25t4MfzWvJBY6cFfOw4XinTyDUe5mmAbH9AK2eROerr8IDVAq1V1/zb/x0g2Md+8dABtkUUZXQ0bOAcENabHpRuJTGmnCTluLXd38nfMP5NYeQ2rwjawCDO1xg4Ak53jDzDnFuAr0jstkT1dQH/nxQ+vUqLRRBnCDvYPWSBc4ETu+3hzMRY3eXFejY3w6gc0IlPeMOA2JkchWoDAs2+A0bO7Yw+GvkupVxPnn3e5R9/8cCA+bJ7Y590r/2KwlNxA5F45DM9+nd5YBG1ismdBlS/F/Lpo1C+LcjRexU9hz0Mj6f3zhVHj4BE+1BVoLJ3OljMeNuPXgXlC0l89JSPfs2sdDyx0bS1S+thZGGEWr4il+QaWsbS7xNICUSbPWP5pOHBA1VBdG4BAOpPJK4l7ftLt1qLPMe+VErSwXnjMUQPmSwxC1tQbpKkNLBlkvwEKNu3nfdmJz168CVeWFkIJ8lAqJTAqHuOi7aiDqHVJgvHwslLjH5kZJWdKI2GnQVjb7+a4PTyLZvpqi3HHkLWm8nPFu5vs1+6JdRjtfmcU9VkhQ59ECHEc0WTWHo0QmeRq1USKgVBX6PXTEPyO8BFdqLuFZrO9JecGzUR/nw==
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
- [High] net/libeth: GFP_KERNEL allocation in NAPI softirq in
  libeth_rx_alloc()
--

commit 8b7f90733116470d28d79365ee87cd75951698b1
Author: Luigi Rizzo <lrizzo@google.com>

net/libeth: Use GFP_KERNEL when pre-filling RX rings

This commit switches libeth_rx_alloc() to use GFP_KERNEL when allocating
RX buffers for uninitialized ring slots (where buf->truesize is 0 and
i !=3D fq->count - 1) and GFP_ATOMIC afterwards.

> diff --git a/include/net/libeth/rx.h b/include/net/libeth/rx.h
> index 0e736846c5e8a..de1e5fe44aa40 100644
> --- a/include/net/libeth/rx.h
> +++ b/include/net/libeth/rx.h
> @@ -106,10 +106,17 @@ void libeth_rx_fq_destroy(struct libeth_fq *fq);
>  static inline dma_addr_t libeth_rx_alloc(const struct libeth_fq_fp *fq, =
u32 i)
>  {
>  	struct libeth_fqe *buf =3D &fq->fqes[i];
> +	/* fq->fqes is zero-allocated and pre-filled in process context for
> +	 * indices [0 .. fq->count - 2]; slot fq->count - 1 is first allocated
> +	 * in NAPI. Use GFP_KERNEL for initial pre-fill and GFP_ATOMIC after.
> +	 */
> +	gfp_t gfp =3D (buf->truesize || i =3D=3D fq->count - 1) ?
> +		    GFP_ATOMIC : GFP_KERNEL;
> =20
>  	buf->truesize =3D fq->truesize;
> -	buf->netmem =3D page_pool_dev_alloc_netmem(fq->pp, &buf->offset,
> -						 &buf->truesize);
> +	buf->netmem =3D page_pool_alloc_netmem(fq->pp, &buf->offset,
> +					     &buf->truesize,
> +					     gfp | __GFP_NOWARN);
>  	if (unlikely(!buf->netmem))
>  		return DMA_MAPPING_ERROR;

[Severity: High]
Can this allocate with GFP_KERNEL from NAPI softirq context if the initial
process-context ring pre-fill fails partway through?

During interface bring-up or reset, iavf_configure() calls
iavf_alloc_rx_buffers() to pre-fill indices [0 .. count - 2] and ignores
its return value before iavf_up_complete() enables NAPI:

drivers/net/ethernet/intel/iavf/iavf_txrx.c:iavf_alloc_rx_buffers() {
	...
	do {
		addr =3D libeth_rx_alloc(&fq, ntu);
		if (addr =3D=3D DMA_MAPPING_ERROR)
			goto no_buffers;
	...
}

If libeth_rx_alloc() fails at index k < fq->count - 2, the loop aborts and
leaves fq->fqes[k + 1 .. fq->count - 2].truesize set to 0.  When
iavf_clean_rx_irq() later calls iavf_alloc_rx_buffers() from NAPI softirq,
reaching those remaining unvisited indices will select GFP_KERNEL and sleep
in atomic context.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109182533.3594=
984-1-lrizzo@google.com?part=3D20

