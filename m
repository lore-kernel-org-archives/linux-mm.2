Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 162A7CD6E43
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 23:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5B66B0005; Thu, 28 May 2026 19:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196AF6B0088; Thu, 28 May 2026 19:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D38B6B008A; Thu, 28 May 2026 19:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC4226B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:30:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A28B51A0A5B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:30:26 +0000 (UTC)
X-FDA: 84818424852.18.6B8C16C
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id B8ACE180004
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:30:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IJNiVaMy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of william.kucharski@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=william.kucharski@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780011025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4wIN4SNHRitM0ngarezIhOM5acJEbDG3qSyZyguPCI=;
	b=w0K5krecoac3M5lBberUfxsK3RpSTHcKucYrWcl2pgzKAK1oXgil8M7d9ATdCBDK9YoMd7
	fw70+RVSnnCAM3TgJw6mv1wB/NThGTMfgwH+uqB11u+1ai4fztRrsyPoUjeRrV4aZLaZZt
	ezuJBPjq3K8EHghKW5GbuqMiDB9qFsc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IJNiVaMy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of william.kucharski@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=william.kucharski@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780011025; a=rsa-sha256;
	cv=none;
	b=aE8fXPh6zk/7OscOFFDXW/gpQGHHv6IenSfIDrx3meooMmkMy9iiJIGuUdCC8W1iETfG4U
	zpcLI2pVHfSd77pA3LmgNM9B9kCxt04e7pgSGRSRSOOu3K5Jajy4a3UGBGtrPKIj1aNdh9
	lEJQPWrBqbRRaOpeizMf5wXPw76RI3Y=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780011022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D4wIN4SNHRitM0ngarezIhOM5acJEbDG3qSyZyguPCI=;
	b=IJNiVaMyTnO0R8z438tXxUIihVO7hXAF28ZbM8NefFkZnYup68YW7NgHHE+Nyox05yyblt
	wTiE2pvjqGpFvYiIgRb16TDhnQNAD6yZOA4HPZ5UdcsdlWOLOBsMWBNqRYfi3L5WkiZWy/
	E2+R14LJHOe2EQ20LJ6nT+g2NW9i/cU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 0/2] Add bvec_folio and its kernel-doc
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: William Kucharski <william.kucharski@linux.dev>
In-Reply-To: <20260528175905.1102280-1-willy@infradead.org>
Date: Thu, 28 May 2026 17:30:07 -0600
Cc: Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org,
 linux-mm@kvack.org,
 Leon Romanovsky <leon@kernel.org>,
 Christoph Hellwig <hch@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FADCC457-872C-466E-82F8-F88DF03E54F0@linux.dev>
References: <20260528175905.1102280-1-willy@infradead.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fgfnxc6kf66yfsmyp54u81tp7djtbkom
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B8ACE180004
X-Rspam-User: 
X-HE-Tag: 1780011024-417134
X-HE-Meta: U2FsdGVkX1/NJELDYBfYnr6fisS3iJxfgunaShUSWA58Gz6MLnGMdLr9eu9cXvutaC/X8a19ag3KqpQUnwwnGXeLjPLEQB8dkRW6LvnXDmF3JZwcU4/EChiWMtjiaZ1msf2XZ6QC3YzcqHLwYCTn5tpOzSE1eZUWDDH9MqNQJq+QTHv8zHI9McD8zGjbB6786jl2139Dd3Y/Juk6fF8acQj74qkozvGb1keIhMTlPr/5fYm4oeWrXmvopIVu5s9UovFMvNVyORSvjytQMUn8w1yst7VCQqEH4FC/EQi9qpOgxYTEE04hX1mEBbOPJL1WiG+D31c/9fvJClWC7TdphUWaZ59DfgMi3u1tfjH5jAcxKXdBnWZXyOj+ytyM2lOHc+GKvxOZb4FKLEW9ZHjdOZVdw1YboGl1fKptvcWuNgLgN84NYs2pRZ1qm3Actb+QZbulm6X5nLg+3WCwWM6PkFXvaQ5Wnrx0yqHQhLtxhyoEosEwWqz+aRL+paQYP4agnd4NDnzgxDUE5Xotid7fW3iMHZ2xxsO+qW2lzvZFWdoJOtuWUo0qoQ8Xm+dBn8L0J8ntCOBwgga1yZu40JAQABTQSc006AGqnvaItx4YC2E9ggdDS8LnU+mlxof4V4R6bUlKozEemDycgNRWjCvQNrsnR3P6lFNFPgJZDBBYhj0Y4GUEXVFsjDvIi7tdbi091ON08LfewV5EsCKAM9da5Xt3qkey7ymBW/oncghd9B7Dg0toGb6O0sl/rJT+Zi927zi/EZzLFzYTXgUlnmxL1m+n+EwZ4m9p21lxKPeVMYlNi1GtPqhG69TpyE+0206U+UXLbn3eoYYyH1spM25No3ZxmVWRTShcnrWXyuYL5jYFL21oVCmydJBKf6ebOTWGGF18KsN79P33MNRMif7Vr+0ZBgDUw/cbJTPb4di5TlCoobZ5FSm/FqmHs05NkfCH04wNmS4fkVVtqyJqhHy
 Gvl7t2Rn
 eal9r7UF7w3TvBkXVePKP23qaMf4/6HvFavoSj64qV2ciJS8I8tr4ALPn+DBygQbDN6groJOc7vTBaqDs2rgKUrkdueHmIqGKp5nXcnlhadZyH6O9/10z7GGSMrw16V8drvEJtecAzK86L+mtClP1ErWH3RgwRJh0AjTZ/niRZBGSYTcVg7bErlC5cFauIxShYjJHJjzjDQHD5YLI6aimXu3IAuV8jU1vM1BB6bpPaehCyhn9+A7BMauE4YpiWvU99/laHnFmMxo/ZgWYv5OpsFxOrlqhmB1tCpRkQBHpAdaZIeK9W1HhlLRs5vXXfFlG/wiooOzfc1aqGTuq21l0oWIqGr7aQazXDwWEqmtw1JrhANI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the series:

Reviewed-by: William Kucharski <william.kucharski@linux.dev>

> On May 28, 2026, at 11:59, Matthew Wilcox (Oracle) =
<willy@infradead.org> wrote:
>=20
> Add the convenience helper bvec_folio() to avoid references to =
bv_page.
> Convert a few of the obvious users.
>=20
> v2:
> - Tweak the kernel-doc (Christoph)
> - Add the bvec kerneldoc to the documentation build
>=20
> Matthew Wilcox (Oracle) (2):
>  block: Add bvec_folio()
>  block: Include bvec.h kernel-doc in the htmldocs
>=20
> Documentation/core-api/kernel-api.rst |  1 +
> block/bio.c                           |  6 +++---
> include/linux/bio.h                   |  2 +-
> include/linux/bvec.h                  | 17 +++++++++++++++++
> io_uring/rsrc.c                       |  2 +-
> mm/page_io.c                          |  4 ++--
> 6 files changed, 25 insertions(+), 7 deletions(-)
>=20
> --=20
> 2.47.3
>=20
>=20


