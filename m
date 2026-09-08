Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74D5DC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71E3C6B008A; Tue,  8 Sep 2026 04:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A27A6B0093; Tue,  8 Sep 2026 04:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 568FC6B0095; Tue,  8 Sep 2026 04:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A48B6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:10:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2EDDD12044E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:10:41 +0000 (UTC)
X-FDA: 85189873482.11.E868315
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 376A5A0005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:10:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VuvCCa9v;
	spf=pass (imf15.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788855039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LQ40bG3b0qEiWUXfmVaeOdjqlO0VS+wXll0EN2GKX0=;
	b=25z5R+mloENRwgTLcqq5OLwbhaC4IXqlzdQUN+Zjt0EJHoTSM0J/Sk6UZcPU6BPbXDEbbe
	2MhbEjHz4RpusuDGsFs4bGhF2pQPfvYCq7VU81w0HWvRxQW1N2zlp1CPadUOU+KC878Ru5
	+hkkvMa5NV3JiKQQvQyA/1FQTyxY0sE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788855039;
	b=moO/KQqDqsdN5LaMMaSTgKqC2tpJ9r01PUyVzka9SOPkUFkKHGmI7Zpo7BXktu3vJr3GeC
	B/SmZ4pz5oYGCLi9nBBqcnjT+31lZTNOekn6HmHpU56eA7hWY6fz0iiAFRMsSWt4OHFoks
	BzshP2H6LzkKLP+75FlZjr7A7/eJGdM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VuvCCa9v;
	spf=pass (imf15.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EAFD43A59
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC951F00ADB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788855038;
	bh=/LQ40bG3b0qEiWUXfmVaeOdjqlO0VS+wXll0EN2GKX0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VuvCCa9vusaCARP4kqjikR+bv6LqFhsoUvglKfI1pJ9AsquQHsudSXKaSRn8WciPB
	 PU18JpWe+CCGQx6pgLnGpxBdjf9d+Mqnyw1E9xm4a2xJ9aDt7sm9IBOWx3+xaz5O9f
	 2Ay4dvMkb9bSXsEADr3vdT7M8wxiU/jRORNkZoyRhXHNLqO1haqy9GfjsmUMdT66EI
	 /nA3gQ0tWJ5CJnqoSdyAGbyi8ZDHkzxKrSvGBcabUcF1k0uQ+jmtd8hmMrk2ac067f
	 Pv4LmFlyY+5QoFse7RhmSATPp2FEbb13AOVufv4NIVar572vARYJfyAfl/ECwAFfOy
	 Xa1T0McJHfLpw==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c28fde3bbd2so211544566b.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 01:10:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxyfuscW25pWkYC4jOG2RwIp3dSwyBjhN0ahD6PgxUHmzzsdazXw2fOqRvlnFor4UiprSJzIs1y+A==@kvack.org
X-Gm-Message-State: AFuF++nptzD32NogkbemeIS/dPnjCowdouzrMLH2y5afvcj7O/lUAgIv
	zlhjVuA4FnPG6BPcS8PjZLMeRTlSvoBzgtTc1MmmOFNVLoUBatmWJb0D5baziJgHwQfgR9vpDWF
	hb0ZMWY+8hUja8XYJ0S2o6lZDOdAtf8I=
X-Received: by 2002:a17:907:940b:b0:c26:1691:b366 with SMTP id
 a640c23a62f3a-c261691b9d4mr944555766b.31.1788855036997; Tue, 08 Sep 2026
 01:10:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260907161938.1932355-1-usama.arif@linux.dev>
In-Reply-To: <20260907161938.1932355-1-usama.arif@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 8 Sep 2026 01:10:25 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNr7jMYkWjaRYpQYkR8yQT3R5guV=2EXTfWBipAZ5kEqw@mail.gmail.com>
X-Gm-Features: AcwNN1WdBn7Fr6APF4VR9MOEKeL7VFm43JjsPuRw9XMXiiE2ug9S5SNh0owgQu4
Message-ID: <CAO9r8zNr7jMYkWjaRYpQYkR8yQT3R5guV=2EXTfWBipAZ5kEqw@mail.gmail.com>
Subject: Re: [PATCH] mm: zswap: don't fail a large-folio swapin whose range is
 not in zswap
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	kernel-team@meta.com, stable@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>, 
	Longlong Xia <xialonglong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 376A5A0005
X-Stat-Signature: r4h45gt74t9ftfkc71jdzhs8i19d9xo9
X-HE-Tag: 1788855039-89690
X-HE-Meta: U2FsdGVkX1+tbEH97SPRnkaNloFfrmsMBt1vZ4TcFYl53cT9lefvxy0sO0hFo4PXX2jVL31uhoE9gnmdTHJfjBLAHSB5i0OL0cxu3egbZUho/qOd6bwdgLIXSoIYO6DxJvFygwxagIrjD03ylmYddlQSdpHrlOL9VUB5FB5X6xi50Cuo0HABV8xp1h2vV6puD1afDpBRUZW6nNetg82gPMTvqe0uCycyZ9c4c40z9SjJxe0hiagG8cxd6E8J9ky3V3ntdW/Zb1pZgaOoI7vXXg46+Zr8Wg9N0wfmYczMuugyWS/hg6RGGEJN4gSxp8JGjm+xeGTl+JwbXPlfdYMMVB3TOZvETVsnAEyFjbS4mH9jz1//QjYmVGO23uJ83NOiTS/hwgyzGQqZl+lTfcLuc3i9xPjTzsgKKw8ONLKhpnjXD1S2xfX/u9r8enG2CvgS4p68lP+10seIvxs0gQqP4rQOdHztS0MJpEOTd8hmGnbAgLA55oJ1JBcP+0+UGMNtsHOWtcqtfeqAjIMbxANDm99X7Mzz1ZlB/QRT4gj2DvZAjEeP1/4Wj0cWxNtjyhQeq5yVZ0qxOCWLPcsiUz9WyWSVQz6qSNTreACaG+5gOpSehIerHhLjWcAb00OSDxbISO1oTee/hVp3CqX/NoW1YIjhWhiE2Apfc0H3V//FUyeYz8VY/JalS0aBLeaTIxVp/Ch4FDFmXBSs1Pw0vKAt//akYEb20Ppdq7XI/hvoDv/BERJ4I3cIO4BrpRw8VpyteLIJApJc8jd0Tt+J4jprPo9VY1nS8QMP3XKhJTtHcYipXgumhskZgdXSh/E/x5TZdPOEOjjpCz3P570YFsYRTdBQT18vUrahLXb8oMN3Rdwlq4xS83nbRA6159yAAuSn3CV+PR8PcES5IgpvRVVPfWwowV9K0yt5rk37YzUHbZ6D+jI0Rg1JdyIrIeV3EA/dt8KbSSLwFJwEnNzGr6m
 slvqKwu7
 6FPuRplr76/iH9NIXVQI630pNNQzWHevH55O8SOz6t4NuzUnHLJwk80leZd4RVhpQOZHuQgPZnN+y8gkBfwmzp00VYFt91I0o16jGdc0elZ947+GIHQMQi7MvOFIBNF0lTJvnMoBLptojEsJ5S1Q0zqktMgHz/b6ZAXFUKPskr8+AEuz0Xe9nhuIi9ZJ9eXJZbc0GZjwaaHyjH3tVkYUJ0fpJPLUc5I1d0/2/c8m1Ts2SIl+bze7a9e4fIBD7apjZwI5OdObPcCxMNUOq8qEkwZ8rt9HVikizbOlupczIKpXAFNj07EHMb4GA3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 9:20=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> thp_swapin_suitable_orders() and shmem_swap_alloc_folio() sample
> zswap_never_enabled() to decide whether a swapin may use a large folio.
> zswap_load() samples the same one-way static key again once the read
> reaches it.  Nothing serialises the two reads, and in between the task
> allocates and pins a high-order folio, which can sleep.
>
> If zswap is enabled for the first time in that window, a large folio that
> was correctly permitted reaches zswap_load(), which rejects every large
> folio with -EINVAL.  swap_read_folio() treats anything other than -ENOENT
> as "zswap handled it" and skips the backing-device read, so the folio
> comes back unlocked and not uptodate: SIGBUS for an anonymous fault, -EIO
> for shmem.  The data is intact on the swap device - it was written there
> before zswap was ever enabled - and the not-uptodate folio stays in the
> swap cache, so every retry of the fault fails the same way.  With
> panic_on_warn the WARN takes the machine down rather than the task.
>
> Scan the range instead of rejecting the folio.  The caller has pinned
> every slot before issuing the read, so zswap cannot start a store or a
> writeback into the range and the scan is stable.  If nothing in the range
> is in zswap it is all on the backing device: return -ENOENT and let
> swap_read_folio() read it.
>
> A range that does have a slot in zswap is still refused, because zswap
> stores large folios as order-0 entries and cannot reconstruct one.  That
> stays reachable - a slot shared with another task can be stored inside
> the same window - and refusing is correct, since the alternative is
> returning the stale device copy.  Report it as -EIO rather than -EINVAL:
> the request is valid, zswap just cannot serve it.  The only caller
> distinguishes -ENOENT from everything else, so that part is a
> documentation fix.
>
> Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io device=
s")
> Cc: stable@vger.kernel.org
> Co-developed-by: Alexandre Ghiti <alex@ghiti.fr>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Yosry Ahmed <yosry@kernel.org>


> ---
>  mm/zswap.c | 58 ++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 43 insertions(+), 15 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37f34e406c8e3..fd36ac38e9a1e 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1571,6 +1571,32 @@ bool zswap_store(struct folio *folio)
>         return ret;
>  }
>
> +/**
> + * zswap_is_present() - is any slot in [entry, entry + nr) in zswap?
> + * @entry: base swap entry of the range
> + * @nr: number of contiguous slots to check
> + *
> + * Context: The caller must keep the range pinned, otherwise the answer =
can
> + * change under it.
> + * Return: true if at least one slot in the range is in zswap.
> + */
> +static bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> +{
> +       pgoff_t offset =3D swp_offset(entry);
> +       struct xarray *tree =3D swap_zswap_tree(entry);
> +       unsigned long index =3D offset;
> +
> +       /*
> +        * A pinned range is at most SWAPFILE_CLUSTER slots and is aligne=
d to
> +        * its own size, so one tree covers all of it and a single lookup=
 is
> +        * enough. Scanning only part of the range would report a false
> +        * "absent" and let the caller read a stale copy from the device.
> +        */
> +       BUILD_BUG_ON(SWAPFILE_CLUSTER > ZSWAP_ADDRESS_SPACE_PAGES);
> +
> +       return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
> +}
> +
>  /**
>   * zswap_load() - load a folio from zswap
>   * @folio: folio to load
> @@ -1578,15 +1604,12 @@ bool zswap_store(struct folio *folio)
>   * Return: 0 on success, with the folio unlocked and marked up-to-date, =
or one
>   * of the following error codes:
>   *
> - *  -EIO: if the swapped out content was in zswap, but could not be load=
ed
> - *  into the page due to a decompression failure. The folio is unlocked,=
 but
> - *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_=
page()
> - *  will SIGBUS).
> - *
> - *  -EINVAL: if the swapped out content was in zswap, but the page belon=
gs
> - *  to a large folio, which is not supported by zswap. The folio is unlo=
cked,
> - *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
> - *  do_swap_page() will SIGBUS).
> + *  -EIO: if the swapped out content was in zswap but could not be hande=
d
> + *  back, either because decompression failed or because a slot in a
> + *  large-folio range is still in zswap and zswap cannot reconstruct a l=
arge
> + *  folio from per-page entries. The folio is unlocked, but NOT marked
> + *  up-to-date, so that an IO error is emitted (e.g. do_swap_page() will
> + *  SIGBUS).
>   *
>   *  -ENOENT: if the swapped out content was not in zswap. The folio rema=
ins
>   *  locked on return.
> @@ -1605,13 +1628,18 @@ int zswap_load(struct folio *folio)
>                 return -ENOENT;
>
>         /*
> -        * Large folios should not be swapped in while zswap is being use=
d, as
> -        * they are not properly handled. Zswap does not properly load la=
rge
> -        * folios, and a large folio may only be partially in zswap.
> +        * A large folio can legitimately reach zswap_load() with its who=
le
> +        * range on the backing device, so scan the range rather than rej=
ecting
> +        * it outright. The caller has pinned every slot, so zswap cannot=
 start
> +        * a store or a writeback into the range while we look.
>          */
> -       if (WARN_ON_ONCE(folio_test_large(folio))) {
> -               folio_unlock(folio);
> -               return -EINVAL;
> +       if (folio_test_large(folio)) {
> +               if (WARN_ON_ONCE(zswap_is_present(swp,
> +                                                 folio_nr_pages(folio)))=
) {
> +                       folio_unlock(folio);
> +                       return -EIO;
> +               }
> +               return -ENOENT;
>         }
>
>         entry =3D xa_load(tree, offset);
> --
> 2.53.0-Meta
>

