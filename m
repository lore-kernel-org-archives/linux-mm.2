Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BD1606A331
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bmKWrOdl
Received: by kanga.kvack.org (Postfix)
	id 381936B075A; Thu, 19 Nov 2026 23:38:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35CD06B075B; Thu, 19 Nov 2026 23:38:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295E66B075C; Thu, 19 Nov 2026 23:38:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 059A36B075A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:38:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75FE7160D52
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:38:51 +0000 (UTC)
X-FDA: 85454242062.14.E3B44A3
Received: from mta1.migadu.com (out-97.mta1.migadu.com [95.215.58.97])
	by imf04.hostedemail.com (Postfix) with ESMTP id 66D5F4000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:38:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bmKWrOdl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.97 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795149529;
	b=J1/X/EpLiBOf+T/Z4DWcT7brfkQ4zaYTwM3cLZ84J63b2bvZ5uWcyxAp2u3qB0oS7JIC5g
	OYVH4Ww8gka854P/Hbc2A0BszrXjjdBlqc6H60NFawMxAH//v6RNUHxw9gR/Lc3fzzB0wz
	zWWYf1KgmDvPfD5ul59LTW8Q0wVr93k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795149529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uzasxw4xqD3fvs8trR1Jh6kQdFHAglewV9gnHu+H+/M=;
	b=I9HQBy6LlP9emgR8ig43QAj0XmVcQC70KtpTgUIVLQIj5Ka6Tm3xqe7dgcEXjRrhrQXhRU
	DxRDLmArnjSUNGwxgo8Foc74Xj/5yffODVSjkvhoS8cjLg7A32RNMTfqavXQxwFClKLuvm
	/uNoqc5ppFQxv1Bsv4D+GZ/CaM7AzSs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bmKWrOdl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.97 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=b3WBb0Xrdw7pL67XV6lz+KQ1Uw6QUh++E1jCIYS3bb8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795149528; v=1; x=1795754328;
 b=bmKWrOdlZC+vKBNYMM12cHGh7amn65+AFZLxJSNjTnweKsbUI6PyVKyYQhrXoAe7xrHxTQCs
 eRFRH1z+LbdaJ/BDIuhEdGYLTQkZzV61aIpQxv0KQDjsCHZJUTkMd6G1Om02lTqQJCPVBDGIzUq
 UJ21ccZdLpLhnCCniCLyjmb8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id caf988e3d507123b;
	Fri, 20 Nov 2026 04:38:48 +0000
X-Mizu-Trace-ID: caf988e3d507123b
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 20 Nov 2026 04:38:47 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <9d737a7fef0cc4f69b43014fa9371c914ffba748@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 18/18] mm/swap: redistribute queue readers after
 membership changes
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <fbb87083afcc51fce533308d723edc55263bdf06.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <fbb87083afcc51fce533308d723edc55263bdf06.1794666741.git.lianux.mm@gmail.com>
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 66D5F4000C
X-Stat-Signature: 7kdqy8yjco9ugcnsjwwoqpwkke4tbq95
X-HE-Tag: 1795149529-385686
X-HE-Meta: U2FsdGVkX1/SurBfUIoCaYmfATYvFzM5oCUMwqEcQkx/Xwmpaf0reGnts3wB09ILu4OQL0L89cSbFfOek0q4BHwp9xcktdpSrUbCbEiF0DluJMOI2SBCaTaGPhCXjCVqYHheMUIf/gZJNqQLXEy/AwUJF07Px3BV4hHHU1ugPZQ/z+vRgqDHORMXrswNP6+XCr7Vrma/CYUOkC3/dEzXTj6BzdJmyx0eggPPnZnF2rJIxOou3qxW49vgaXDqy5DPf+xkSv/nEhJhfZv4PLDv9paLGVeRdzkY5cOUdEYFxhoPUYq+1T9XObdL085g2NYdXzOE7AvTt7Sv1Ev5XT+sGzP85b0F3HOpSbQ+vasWUCa1Qg2iVeibam3kYFq65CYc1NcBDOFsOE4/EulJSqHsJixLWKnsQjM75QUtAZl+WxeFNp8M6ddRz1nJBJ4FBH60sPxOe3R9y91of+tVvviimLt+4mLKEou6XffB0M7unSjTqBVq5LsBaBx4MqZ2Bv4eAwOBWaY7eXewOGvgjKJfN9hpZe2m8hm/T/Tdpf/mYmY2kjICdYoVQnoBphb+9Wg6FwnStex/n2fzrA20K28pv0x+FCqh06cAhY3JfBwkItPGnnRfnrlm/Ac2tFCtQ/39X8lO8yy4kbo5dkHK547i9aBy3gZcmcRSUagFd0Kcmkyzq7hHLKl5cCGqA8WMUCFgas6rdHSW9Rs1rTEs0MmWOgm8WtL2t2uKjrJ8cd3IC+Yk2xE6qcdgceluQHWa+ZGUSe1+sTVIuOhWtx0XQcFPUAMVP4u1gJ6FxdtYJzD506+8bUE7x6kybrNzBSBvj9Cebk3jK+uCGqu9oBcsTWAl+XbU4YiUF/naoaPmwuDCKW/aA7qWyulpa5ZzQN4Bm/0SiC1XqLv9WBINcwqdqSKLrhlzJAREY6bYe/DiCY8ytvmyd4h3THwawRbzeXcnioEUXefZZ1amgC7IhXWtd78
 L5/OM+kg
 /StZIfMov3QD4ZQp1oWKBQZu196B1pq9HZ+m3U+wWpr7/UAikQ02XtLtMoPZgWtaR9BlKBfggp+v/m2sVqNVDXCpAqTN5lg1NFzaE9hypydXJ36bWuyRje/SBvjCukecnIu4zZpQiDzkF3gLcPt97e2+DEhKJCmDzJtMmKx8PScE0DRlYAQyrEOKxThC8FJZoirVvLI23qreKVZTt+5L4yGdtFKIPJFcvUYS0bEPTnUQ939tKKw285F3SGFCcWeNmEOUgGkbQdLZeKC4JwQWjhaLQjyfGztdHSygh2Dhx8QFfpMstAP5s34P7SLTBQn8rZYHSGipPq/xdlQGKITPhBiJ1D8LbCjr3DOgqe1GbV9OVjyqz9MvB/MMikIDzEp1GfgdvQ5l4VPoYrPcp3qE2Yjn/qH5h3S3DQQQ34hEY/VefWbPJl+8N1yMwBd4v2DfQ1z1n+q7kShx6ndO/9niANjt+54/QOwlU7OINlNq1dCxxebnYbBxM6dwh2gsJ8T2PeTfCzabMO6wnKZDLTkXyeKAA0X4cmvupP39J1jVdbY4e8qQDLEilT8PWhyhxpbiufkOuDPvcR7Km9eA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

>=20
>=20Adding a device to an existing priority ring reuses the per-CPU reade=
r
> storage. A ring that previously contained one device can therefore keep
> every CPU at the old common starting offset after peers are added.
> Deleting devices or rings can likewise leave offsets and quotas that
> describe the previous membership.
>=20
>=20Reset the valid per-CPU ring offsets and quotas after peer insertion =
and
> every nonempty deletion. Run the initialization helper under the topolo=
gy
> writer, which excludes allocation walks, without allocating new reader
> storage or adding selector hot-path work.
>=20
>=20Use cpu-id modulo placement for a fresh best-effort rotation across a=
ll
> valid rings. This does not move existing slots or guarantee strict bala=
nce
> for every active CPU subset. Mask and availability transitions do not
> trigger the topology reset.
>=20
>=20Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swapfile.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
>=20diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 0c192844b121..eb2128132455 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -497,6 +497,7 @@ static int swap_queue_add(struct swap_info_struct *=
si,
>  spin_unlock(&swap_queue_update_lock);
>  memalloc_noreclaim_restore(noreclaim_flag);
>  kfree(old_ring);
> + swap_queue_reset_readers();
>  return 0;
>=20=20
>=20 failed:
> @@ -569,6 +570,8 @@ static void swap_queue_del(struct swap_info_struct =
*si)
>  swap_queue_install_readers(NULL, 0);
>  }
>  spin_unlock(&swap_queue_update_lock);
> + if (swap_queue_len)
> + swap_queue_reset_readers();
>=20=20
>=20 kfree(old_ring);
>  kfree(old_queue);
>

