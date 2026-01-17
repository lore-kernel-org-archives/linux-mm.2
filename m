Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57242D4A5F5
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 03:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81556B0005; Fri, 16 Jan 2026 22:23:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2ECB6B0088; Fri, 16 Jan 2026 22:23:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6B386B0089; Fri, 16 Jan 2026 22:23:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 924D46B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 22:23:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 578ED58436
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 03:23:33 +0000 (UTC)
X-FDA: 84340010706.10.9831241
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id B3D1940015
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 03:23:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GxbLQWF7;
	spf=pass (imf04.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768620211; a=rsa-sha256;
	cv=none;
	b=r+EZQnio4bItNr3jSyuZewqz+JiFuPctPG4zDJ3W9pIZCW6SoFfBpXrIUfeJ40hlrZcDJz
	hJniekEj9vSvwEVwTo8S4wSlcE73OODDdpaat9Fi5N1z/gKhDVUkS26nh1DwmBdls8u8aR
	TRL0s2mq9UOs23mYuNsv314ypq0hpwo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GxbLQWF7;
	spf=pass (imf04.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768620211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQuEhl8zHrQZCagraBktkM4tCNhuhThzyRBFv9qmF9M=;
	b=4YI6KKMLmd1vtU31ZUlN4712KvIPJ43wi7la594WLRNEvpipFGYe+vTIWRqMpphv4CBrse
	EJaSNy818wXdEgdRSWf531aMCpHFqE7nVM+aIKDP6HAzyaYG7gxo43WZZPPxsbL/gl9ibS
	I+MnPZNStjsGh6e5cONIWnd/2nK7YEI=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768620209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hQuEhl8zHrQZCagraBktkM4tCNhuhThzyRBFv9qmF9M=;
	b=GxbLQWF7/wKOkO85QVUmYAus/Jai2RXrC4MUcTfctHah/9Z82GSaYvH0RQ+oiUBQzfrYi/
	qaKBX1EkLO8SSIvjyszEQfRo0+0CJ5Wui4qeLNZD/8M1H9hsEUCLF/y2aAynbZFJH7ad1O
	kduO05075Ev8wM6P8qTxmabGDl2Oqlg=
Date: Sat, 17 Jan 2026 03:23:26 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <f24061e372edefd7b70490effd18b646c72ff9fa@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] zsmalloc: introduce SG-list based object read API
To: "Sergey Senozhatsky" <senozhatsky@chromium.org>
Cc: "Sergey Senozhatsky" <senozhatsky@chromium.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Minchan Kim" <minchan@kernel.org>, "Nhat
 Pham" <nphamcs@gmail.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Brian
 Geffon" <bgeffon@google.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, "Herbert Xu" <herbert@gondor.apana.org.au>
In-Reply-To: <nj73lvrjul6h7p7qx2t2pqt3zmcrn3zwdvb7ri7rgzfntjzv3t@nghi7tgq5zvn>
References: <20260113034645.2729998-1-senozhatsky@chromium.org>
 <wb2shm35vigisxnokcp3pw3yzu32kezo3ox2v3xu2u5lnxo45n@ktccxxzg2vsc>
 <nj73lvrjul6h7p7qx2t2pqt3zmcrn3zwdvb7ri7rgzfntjzv3t@nghi7tgq5zvn>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: uxk1x7jqj46zf3c817uqbpskkder8yy3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B3D1940015
X-Rspam-User: 
X-HE-Tag: 1768620211-413417
X-HE-Meta: U2FsdGVkX18DE0fxgAmrq1XZbHT/5HDQGa8cxYTUTK3CTE1QAgx0iAGuLVYjq2KsA2LbiEaK387/dHNucDP9+Escf2I2g6EDDXoQdWuEXGeqLL9lB/Y5Xy4BM5Xk2YY/yEVovDum2aZ1YBzIvP5FExkeDKOqFDmtjfeldPO1O9glq4odzIIhTA0kkXhEdbfMhmbW56QiOws1QAk1NIgVmIZcOANAJyCb/vmL/PoqprNjDBzheyfsyglyHlG/XZBT+hqt7xZ+b9uZFORinTC9vO8JirtH3sx2pPopx5cwVHwW86+vAHqeRvV65aX84CoDjJAzh23FBZEML80I+dL4A7nNDiTXamqPNukCYk9Y1gWRvhaDKFLyaaFPE+6drO6shcS+UInl0MYIwc5f0MKm0gIHCOJkymt0ffxV4mToI2Pie/7/MZIwSvDdScO4pcsqxokictANjTCZ8yYSIAli2bxbqhOi0fDvlJcJGK0aa7jwR9ab0QpcHbATcrAtKucLkoS8D2gAURu6cU78in6SfdpcX58hNFjkYqdC59ioB9FRFEhsNTWp36V6gyMP5iWz/2yiW+r7fL5wC+zieYnEHTgggH6SHfTYJ5g3H/x3OFMlUs5ycAsa9IIdEQgIjcGugQzkg71WJ9XhoyU7a8Rz10N0qm6l/kk30Sto1Q4SrqosffCipM8jrrweJtM2WbzxqQ9gk9XWZtr8qT38DyApXot9Ln4FHzTRdGtY+uCU8dH9vKcWaG82bGOTqorvYZq0yHsfFnfgKFGVCKhkB+R5r+CeO2YXss0mHRIsgeL7gOcul5eRhdaAe7QIWo4LoOpbiSFo10ucEwoNtXeBNdzrYpLjzGIoKR7EUEAwQWpGKyX5px2FdgUKkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

January 16, 2026 at 6:39 PM, "Sergey Senozhatsky" <senozhatsky@chromium.o=
rg> wrote:


>=20
>=20On (26/01/16 19:53), Yosry Ahmed wrote:
> [..]
>=20
>=20>=20
>=20> struct zs_pool *zs_create_pool(const char *name);
> >  void zs_destroy_pool(struct zs_pool *pool);
> >  @@ -43,6 +44,9 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsi=
gned long handle,
> >  size_t mem_len, void *local_copy);
> >  void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
> >  size_t mem_len, void *handle_mem);
> >  +int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle=
,
> >=20=20
>=20>  void? The return value is always 0.
> >=20
>=20I thought about returning sg_nents(). Probably can be just void after=
 all.

We don't need it for zswap but it could be useful for zram.

>=20
>=20>=20
>=20> There is a lot of duplication between this and zs_obj_read_begin().=
 I
> >  wanted to create a common helper for them both that returns the zpde=
sc
> >  and offset, but we cannot do the same on the read end side as the un=
lock
> >  needs to happen after kunmap() in zs_obj_read_end().
> >=20=20
>=20>  Putting parts of this code in helpers makes it a bit obscure due t=
o the
> >  locking rules :/
> >=20=20
>=20>  I wonder if we can drop zs_obj_read_*() and move the spanning logi=
c into
> >  zram. Looking at zram code, seems like read_from_zspool_raw() and
> >  read_incompressible_page() just copy the return address, so I think =
they
> >  can trivially move to using the SG list helpers and
> >  memcpy_from_sglist().
> >=20=20
>=20>  The only non-trivial caller is read_compressed_page(), because it =
passes
> >  the compressed object to zcomp. So I think we only need to handle th=
e
> >  linearization there, something like this (completely untested):
> >=20
>=20So I was thinking about leaving things as they currently are for this
> dev cycle, because both zram and zsmalloc have enough of new code queue=
d
> up. If you don't mind let's remove memcpy() API and convert zram during
> next cycle (after the upcoming merge window).

Sure. I think we can do all of it in a single series for the next cycle. =
Add SG interfaces, convert zswap and zram, and remove the old interfaces.

