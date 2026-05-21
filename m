Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B4F8CD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 08:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B756B0093; Thu, 21 May 2026 04:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D342D6B0095; Thu, 21 May 2026 04:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C706B6B0096; Thu, 21 May 2026 04:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7A866B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:51:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3606A1C18A4
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:51:58 +0000 (UTC)
X-FDA: 84790809516.17.CD9E121
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5C46CA0002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:51:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=DmYT+HFG;
	spf=pass (imf25.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779353516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXd5uQBrJ1ShFALd5sLz3kpHDhFAhrrIJqjYNiPwH34=;
	b=KPTNrYbWtQTjMgGdeK8WmuDg1iF3NZBHhhj/gW8WPn3lcpffUOqZ/pxiNTWXs3l3xvpWqU
	oqKw+RHbaxCgaXYhvFz2oZ5DIb0jxmTXEcv8KG/3Nj+Ie8yxlvIzgjWx0JWFBFCWgLV1hX
	wPru62SYwAKhzqyhbEybH7ZWmEauuXo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779353516; a=rsa-sha256;
	cv=none;
	b=kD90qUKtb4YO75Lg84LkakcAifxXo1RfWtVqcCFz2LN0CpdzkXg8kufS2mbwZ1hDlFW/h0
	bsnlP4cnCIjPdoxtiM/DVgqi20CnOof3WisZ8uk8fyYmKKjBTXYOpaSVILl/fPX5SYVDsg
	72BYdiMrPltXW8AKprTFOereODwCmxQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=DmYT+HFG;
	spf=pass (imf25.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1779353513;
	bh=iulSCBrRJsVq/eT2DkXn6xpnezuCLm9Uxrw7xKL8YPY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DmYT+HFGT5iYHXew6GduSiQ1oP/FAdsUWBfWGxMcOmJAsS0TiAbFOhUBYfkrMEHVX
	 zn4rDEa2IKhAlb7z8F6PFWVbIuaHlhrbGqfxelAsn/Q06DHB2HfEipfrVJqlMjXKhM
	 AO+REBNxB9NffazQvnT0VLkpdktu424dVpGHwzmMNTpQ7pTZoa0PFWZvfA4egZfPvR
	 pdK2F3pHWJRFy0bxa05n5/j4DZHlEOvg7a5DQmgiSLUnWBKCazCfaIgouPZFCp48Yd
	 qynIms2V9c50XGtKdPHmq8oH4rJX6DXfBRjtVbnZvdXVtWzE3DMVJWorVuWrolj9C5
	 9zxcZSnalzaBw==
Received: from fedora (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 037BE17E0411;
	Thu, 21 May 2026 10:51:52 +0200 (CEST)
Date: Thu, 21 May 2026 10:51:48 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Chia-I Wu <olvaffe@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>, Andrey Konovalov
 <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo
 Frascino <vincenzo.frascino@arm.com>, Andrew Morton
 <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Kairui Song
 <kasong@tencent.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2] mm/shmem: set __GFP_SKIP_KASAN for
 swap_cluster_readahead
Message-ID: <20260521105148.5497c281@fedora>
In-Reply-To: <aa244c61-b936-4c53-af7c-2f5190867a7f@linux.alibaba.com>
References: <20260519-panthor-kasan-v2-1-b7384458f076@gmail.com>
	<72bec63c-09f2-4a97-908d-3e6af8e3e0ae@linux.alibaba.com>
	<CAPaKu7S4JCRiTyYvTgXHKP9osH8yh8YVzXiPQuNVAV9pBZtmuQ@mail.gmail.com>
	<aa244c61-b936-4c53-af7c-2f5190867a7f@linux.alibaba.com>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5C46CA0002
X-Rspam-User: 
X-Stat-Signature: jfnfcjbaa853qs8sr348ad3zismot1j9
X-HE-Tag: 1779353516-160367
X-HE-Meta: U2FsdGVkX19D/aoVQ1UihNKTELixHfopQOQJ9Vn3oOIaqHUh9NIP9SN8yJVDvlblxCwe32NzZ3kVpAGD5eTkIGA1e//orFEajlpIureFt9q5oJjBVprtUg3KkGXNMmnqiJZA1Oc79WHjHHfkvjsZ//4qocffaUC9+LPyBIbxyjJCrGqx7iFSelmEN7hGt49G97kXBhfmiU41/4ocgMHPCAnepw1gctsvify1gU5Fw0LFT3UHDpcD8cEurZlFmqhFVhR3MJbp2xeIkpMyC0JtvGyr6FPI4ByDJ1ZnicKY96xP6MvkCRrDAMSecoH1R6UNVxZ3vll3/x0Tf6twTR5+PGtSFD06hQGfFDEu7blBll+qnsJU5mH2xjHY6crWiPWnbQ9Qkg7hg24LQ/SS05UvO6aPa+Ay0gGs6iOv7zpJ4/WfHFdDt82bpNmUThGSTht/8gUL49JuhBWLD7fBXihZXxNBho4y9T5jytcgFeKV+JNozHh4jAT6d4KkogmWMk3HUC9IwORTU7RMhtD0Oe/843+9hxkVO8EnscCwXGJuQ/lpdvzSs7HrWlYwULMPgXZ3zwf2DnIUGQbrgXm47PVAh4pnM7p+BP5p/gxTngFjXM14ZMThd1PksPu0mZFScqmcdwJeXVqJ4UypMcZJ7Ymjq554wK1oP/styXxd3GRPAfg10fe2LkhavV4Y8/hJBGVxseKI7F3yqyl5ELX6+j261dkaO6UOR5g1SI5KD2UOlDihFIIT11nwLR3Ob4hDrEH++L5oIkeNjGsKv2Qm0wxLPIOHPKBtnj1OgwfU8q0aTNXElahk3UcDRzHPqzJFFnXRBIp+rtWXI4BuYQZMg+W3/scYxADS+wHYu87vuwvFLBHBRqNHWH77e7s/nnEORE9lbEULZFPAT1L2458ud+qD71T8zKvfif/yg+uuJzOTuXD2MQnhvjsDkJk29paKay/pWebfSCgXfyxWUjbCvVc
 Bc5m43ZU
 FYdBPWMUFo2FvFpc6p3OhfElu3ZCwbNwdFfWaLXK1HnjSQHXQhhIwvyHrl6O23WIbnIWx0S+hKBjUg1FC2fCVVRAwicPRlvPUj0GpJ789POFpPbdwOtxT6+tJM4LAL4G0fNub4i5xHx6B1nr+uiVMYUQ0hdjLirgrC8evVY99F9MFCaBNHaV8oDRN726FreTw0L15eU8/5qNuFVSmtCoyVImQWmsN/CQ3a+0QKbopRCakzSscSaJXetRWtdilLvoNbMVjF3DtTylGoS4SPqxvovKrOyjWeWeeS8BgdpHGHhP7nIcGJtinrkKH0l7jkAogfkjvyeSmcRvRUx0xt0URFHtq9tpEeOBow1HAOQlttRqwbLFcGWYtyjk9DpZUaPCtz1AR6u1xiT1XKjgQhNQYrFpisa7oOhpke06NF7fOwWtETD8NS4znn97x+o4fxaZecAoSJJvGh2NAV4JLCScwZQ5gu7InjnHrlKNmPfAF+1Zpsnf2i+K77M3nBCldVQ+gDAqFCoWcW+92bXVxO0NM7YtxaoSQhBoZDRfe0DgBvX9UPMHyU4u0C23UiKIZXjihOSJywO8g4jjyv136VNwiLAGx7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 15:05:21 +0800
Baolin Wang <baolin.wang@linux.alibaba.com> wrote:

> On 5/21/26 1:06 AM, Chia-I Wu wrote:
> > On Wed, May 20, 2026 at 3:04=E2=80=AFAM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote: =20
> >>
> >> CC Kairui,
> >>
> >> On 5/20/26 12:31 PM, Chia-I Wu via B4 Relay wrote: =20
> >>> From: Chia-I Wu <olvaffe@gmail.com>
> >>>
> >>> swap_cluster_readahead can allocate folios for other mappings. If the
> >>> gfp flags do not have __GFP_SKIP_KASAN, but the other mappings have
> >>> PROT_MTE, we can end up with false KASAN errors such as
> >>>
> >>>     BUG: KASAN: invalid-access in swap_writepage+0xb0/0x21c
> >>>     Read at addr f5ffff81aa71dff8 by task WM.task-4/6956
> >>>     Pointer tag: [f5], memory tag: [f9]
> >>>
> >>> In the above example, because __GFP_SKIP_KASAN was missing, KASAN set
> >>> both pointer tag and memory tag to 0xf5 when swap_cluster_readahead
> >>> allocated the folio. But the userspace had already set the memory tag=
 to
> >>> 0xf9 before swapped out. arch_swap_restore restored the memory tag ba=
ck
> >>> to 0xf9, leading to the mismatch.
> >>>
> >>> Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> >>> ---
> >>> Changes in v2:
> >>> - set __GFP_SKIP_KASAN for shmem instead of drm/panthor
> >>> - Link to v1: https://patch.msgid.link/20260512-panthor-kasan-v1-1-d8=
d3e275d71b@gmail.com
> >>> ---
> >>>    mm/shmem.c | 5 +++++
> >>>    1 file changed, 5 insertions(+)
> >>>
> >>> diff --git a/mm/shmem.c b/mm/shmem.c
> >>> index 3b5dc21b323c2..db9130a8c5b76 100644
> >>> --- a/mm/shmem.c
> >>> +++ b/mm/shmem.c
> >>> @@ -1784,6 +1784,11 @@ static struct folio *shmem_swapin_cluster(swp_=
entry_t swap, gfp_t gfp,
> >>>        pgoff_t ilx;
> >>>        struct folio *folio;
> >>>
> >>> +     /* swap_cluster_readahead might cross the mapping boundary and
> >>> +      * allocate pages for other mappings. We have to skip KASAN.
> >>> +      */
> >>> +     gfp |=3D __GFP_SKIP_KASAN;
> >>> +
> >>>        mpol =3D shmem_get_pgoff_policy(info, index, 0, &ilx);
> >>>        folio =3D swap_cluster_readahead(swap, gfp, mpol, ilx);
> >>>        mpol_cond_put(mpol); =20
> >>
> >> If we force __GFP_SKIP_KASAN, would this cause issues for mappings that
> >> explicitly should NOT have the flag? and your v1 link already mentions
> >> this scenario. =20
> > We lose the benefits of kasan hw tags (other modes are not affected)
> > by forcing the flag.
> >=20
> > The other mappings swap_cluster_readahead can affect are anon
> > mappings, regular shmem mappings, or gpu shmem mappings. I think only
> > gpu shmem mappings miss __GFP_SKIP_KASAN. That might not even be
> > intentional, because gpu shmem mappings pick GFP_HIGHUSER over
> > GFP_HIGHUSER_MOVABLE to avoid __GFP_MOVABLE. That was before
> > __GFP_SKIP_KASAN was added to GFP_HIGHUSER_MOVABLE. =20
>=20
> It sounds like the right approach would be to explicitly set=20
> __GFP_SKIP_KASAN for GPU shmem mappings, no? I think having users=20
> explicitly set __GFP_SKIP_KASAN makes the implications clearer than=20
> having shmem core set it implicitly.

It's a bit of a shame that we have to explicitly set this
__GFP_SKIP_KASAN flag when we select GFP_HIGHUSER though (means a lot
of patching to do in drivers/gpu/drm/ basically, because basically
every driver relying on shmem for its buffer allocation uses this flag).

Also, it feels like KASAN poisoning for these pages would be interesting
to have since we know we won't allow MTE_PROT on userspace mappings
anyway. Oh, and some buffers might even be kernel only (no mmap()
allowed), which makes them even better candidates for poisoning.

>=20
> We could also consider adding a VM_WARN in shmem_swapin_cluster() to=20
> detect any mappings missing the __GFP_SKIP_KASAN flag.

If the general consensus is that all shmem-backed allocation must have
__GFP_SKIP_KASAN, yes, it'd make sense to add a VM_WARN.

>=20
> > I guess what I am trying to say is these are all user pages. We have
> > to skip kasan when user pages can be mapped PROT_MTE. The =20
>=20
> Yes, regular shmem mappings typically default to GFP_HIGHUSER_MOVABLE,=20
> while GPU shmem mappings are a special case.

They are not that special, they are just not MOVABLE because the GPU
might also access the same pages under the hood. If it's assumed that
any page being exposed through mmap() must have __GFP_SKIP_KASAN, why
does GFP_HIGHUSER not have that flag too?

>=20
> > justification for gpu shmem mappings is that they cannot be mapped
> > PROT_MTE. But if readahead can affect non-gpu shmem mappings, it seems
> > we have to either force __GFP_SKIP_KASAN or to cap/disable readahead. =
=20

I'm no MM expert, so it's probably me not understanding how this
swap-readahead logic is supposed to work, but the whole idea of using
different flags from those that were requested by the f_mapping seems
fragile. I mean, this comments proves [1] it's not the first time the
problem is considered, and I'm wondering why __GFP_SKIP_KASAN should be
treated differently from zones. Yes, that's an extra copy if the
SKIP_KASAN flags don't match but the zones do, but in practice, won't
we have GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE in different zones? Or is
the problem that, even with a copy, it's already too late to restore
the flags because they been overwritten during kazan unpoisoning?

[1]https://elixir.bootlin.com/linux/v7.0.9/source/mm/shmem.c#L2112

