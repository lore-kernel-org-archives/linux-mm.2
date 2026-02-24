Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B6F2EFB7E5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 03:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664B36B0088; Mon, 23 Feb 2026 22:35:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612F36B0089; Mon, 23 Feb 2026 22:35:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4296B008A; Mon, 23 Feb 2026 22:35:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 347F26B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:35:08 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B414258D56
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:35:07 +0000 (UTC)
X-FDA: 84477934254.20.F449DCE
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id AF42F4000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:35:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P0FM4c90;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771904105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzOdDteQ7ZLurHZwTqbft5SWZRf804LGh7Y3eqQaNZU=;
	b=4APEUujGIDQboaSLhXkKaV48QBgiDjOx4cotDX2TsssuLkrhOeSsn0SNA0BSZ0mijY0OIB
	Yhx03edaXt4aADEjIq6k1OS6jukzHDrUa3WVmJ77VO+ZJYG14+R6mcG1Eany8xPXU+kH/n
	NzZTLBLVsmcMcVfDAnt6ufKjjAG69xc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771904105; a=rsa-sha256;
	cv=pass;
	b=FPm5nQqNAiUpP3K0pdfA4eT+B7cy+kwqi2LrXFusy1q7Z2XlRzPHHCuYPOyOYtWEOI67qS
	78WWoXemK8UcLlcejafotqKYlWMi1DrV2Z7mWz83IxO8ehb48jysvJ5xoOeiDdO/1tO0RO
	3keNYCOHr4aq3S97/u1Z4yTP9kYqp+g=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P0FM4c90;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b8f9568e074so894467866b.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:35:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771904104; cv=none;
        d=google.com; s=arc-20240605;
        b=RSMNs38R/AAmUp2fp0n6q7834sFZHUTZB+5MiOtLwZVmjNdsDPr0QXmu530HPPL4EK
         WvyDTqKKUwFjsPEvGRD2Lr2ZK1g1RWpQiwyTvoOZtC3P92+zabmWwFno9/XZ65GmjCdg
         SB8g58BsX/1YAuRqDh77tvNM8JAXCpwYHlL7ogiWBGxnj22ylmbegFkIgDkO0eiYHe3C
         Z89CuYq5qLY5GABaGGZbrGB7g2QEIEKTsH9CUvqs73msAeJ+gI1maH+H3Fz16iHhtf5P
         fpFjdg/dpyiiM0tMz1goPOo7HOa4TE+HAXLtLgL+FPtsXOjTovu6XDPNw6BWIVISsEug
         2m+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pzOdDteQ7ZLurHZwTqbft5SWZRf804LGh7Y3eqQaNZU=;
        fh=OPjsTtbeDYorWqq1nq5qQZuoDBxJti+gQU4Z19KhkeQ=;
        b=QNnoaxP534SDF7/g56azn18hEneqlAUP9xEEXOw5TOR5lo6DwB92QNeSBBGR1fkI/C
         twmzkfshV5Oa7UnOqKKBZCpkwUfQCf9Wl8A+J9VbSrzoDccvG09zQ9LJakC8FkTy5Nmo
         lV4xzYDi5S/o4J7VzM9LDYo8HSuQJFkA1VJbAvOapUPvprkgdFgcMKbvTYux9R/ov2FY
         aMtx53yWoI4WWmMdIRr+NSCCIHn0OPPgm4Fock7fg22+Fn+1Z1GtZjCrh3q+ezO1gb/e
         8MEKBWkPKxAyqth0DyAfMytsG00Z2vtEtG3cwT29V6PfiosMPFz8V6KsYzo0VPyhTrtR
         ETiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771904104; x=1772508904; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pzOdDteQ7ZLurHZwTqbft5SWZRf804LGh7Y3eqQaNZU=;
        b=P0FM4c90Cl/55Pnk+5E9/bKohuFpill9pgpvlx+/KK1h7zWx25d6EOqmJo4fNXuOWt
         CLVC9lO/+Xesf5Os/5kbxlGnp2GMFKkRizbB5AOihGVonfL0m2K/mKdbfC/CG8hlWg7s
         ZXtcMI/klOn+eN60EKJstifLv2SIkgPFL/mCWlEO0uY+Cu2Wp951576D7czcRKuWUw52
         DW0T1kCM9l7rtnVOVbkRW3XNb8cSjTTW5o6ntFaL5R9eY3NV10QFs3ATRZO4Cibdtj9t
         9OgGZ43ECwi8AHMibqN5B8GMD2IYls+FurWNj1Q3pB5/XUy6rbSz6I3CGsSkSjH/qKD8
         y99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771904104; x=1772508904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pzOdDteQ7ZLurHZwTqbft5SWZRf804LGh7Y3eqQaNZU=;
        b=CalBwvzOPHGUgzwlmBwLknpcLssB1DmAwmyZw2WqCpCdv3/46mlW7etbehvvJsmo8B
         rT1SDbxV85tTwcpKbvi9YCDth6LdzfqJ6pU11EaKf5qFckQhJYQoPLP+Xaink2/lV5jA
         ycuMtA5G2opUoB9+u30he3ofu/9um3xs6VVW1QwlLEQoI6cD3ubQQEAOgL+3jixSsHqa
         RSbNaR4gPS3SV/8vy384lc9CyvYKK6gou/DREgOTTnEbBKNK6kI9CZbQs/dUfd8DRgSp
         OfdzG/gcP2PNOwSOzOTfJuWd+ji+vyatRBKJHZhfZqvb8wUsefv3oJyThICyJ9OE0VI7
         zltg==
X-Gm-Message-State: AOJu0YzXGCTzi31J3HTIecHlQj/KUBmQmU8AR+A920OWY7zM9hKlldbD
	C3fxQJXHf4L0YmaUXE00/sDxRKHljmDsZDZCnABl/dUafCoq2yUGaqDRQHjRDkXJqoq+6gy96K9
	xrgF/pHdFKa6aCicYk/F3e66kdvf3snw=
X-Gm-Gg: AZuq6aIhS93OcUNVSmzxpNcT2OkBG7SOFHtQ1fnlKb7AwbTaFytHPoxNF6omj6XLaRt
	FfaySty9+SdVDXYZRYY0oEjCoCvXryjuZBlbgnBmjiJbEO3PYsl0khlvJJ3Uo6ZS8LB69oGPYY3
	so0H6DEnllUekepWHhWBMNPnP4Li9WMN5N3zVML/mpwMa4IEA1xUDusAi8dQp2HWgLOfeheG9O6
	Pk7bSXr6z44rznrL/n7sUhvv6D7OOSDbCwPOUxx6W/9ZQiGb2xbdESs3uiUx6pminCWd5iGk8fS
	pcaAdEbt1iAp214IDdvdVhi7CEP1D7J+taLI4HH9
X-Received: by 2002:a17:906:7311:b0:b88:7093:3ca3 with SMTP id
 a640c23a62f3a-b9081a48372mr712577366b.23.1771904103707; Mon, 23 Feb 2026
 19:35:03 -0800 (PST)
MIME-Version: 1.0
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com> <CAKEwX=OaDKQwanaYm=Mt+mWAKjaqXPdiScF6NB=TZYx1B-Xo8w@mail.gmail.com>
In-Reply-To: <CAKEwX=OaDKQwanaYm=Mt+mWAKjaqXPdiScF6NB=TZYx1B-Xo8w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 24 Feb 2026 11:34:27 +0800
X-Gm-Features: AaiRm52VHlOYalauge877tmnh-TeDdpT4IyzWYAbnMeFhaf0i8dbmK7dBzdlJ7Q
Message-ID: <CAMgjq7D6n0H2=di0SrMQbJ48cVeKhGeQMH_mY0y-au4OJbE2GQ@mail.gmail.com>
Subject: Re: [PATCH RFC 00/15] mm, swap: swap table phase IV with dynamic
 ghost swapfile
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: my5nwgyzkismq5meq9om4ay1i6ayrpgf
X-Rspamd-Queue-Id: AF42F4000D
X-Rspam-User: 
X-HE-Tag: 1771904105-985832
X-HE-Meta: U2FsdGVkX19Ft5MwoZL6ZD46rsitjaBjt39ZO4cklGmMHgPGjuS7xmgzuyKCoE1WWatE32N6GajR2Di5l/aWKWALyVKRieJL4vZV6YpaMTdpBKweJnG6nTb2OCQhd8bjXyPMFXfZjxNkl1M2CfnXJphW0KZuAMHdfhHzqHJIpVTQIqyWPW4EPTQujOV0QXJp3/q73vSf6apc/k1j/IW+pp7W+FqoHaCZNPaBv3yXUzQ5T3XogpvOS2U5P4M6WH9n8vMTbNhIdl1J1ZR9PwO/b3svDji2Rz+spgRAXc4ZxjEduq8p6jErV/cYYE8eOVOkVLTNczRqzcGiCWZqbGYMt8hVZghje87UQqIyVQ74a2Ud4MseOYbFKy7RMav+IJxAFSzSb+8GctIBhvENOZX0R4WGH6ITab3Yd8oFtRWzNn/bnaof1+uozzEtAix0pzjX/XxjiF5pHU17LdrLLx+vyt/EosD7BVB0MOpiH0C8BCdg8a2hMQUBkZmMYdy6PHurlTVkwWC9u/7zCE+4ir6rUs2szlnViwjFl9IyApEl2GuDSxWU3KdfdpwMzZ3dxENTuzQ7FNOWUpt8qyZyWlYC1ADLQWVFl2n1asg90ju+KKhQKGQcvm+Y8pzt0byFGaIhupjucdfvv0cOHIXnl8cMpDdOFLuW18/VYeo9n8n1zKaFqQ81IWK6cLiHiiWWBt4+s/59pxffGDPXKra9mK5dMSMgp4r3nRAILbxH0LasZ3ihBM0Et7hzMz1xn1Fbv2+fJEow+wTyudXJe32WwyzlDFTf6Wg58oRDK2KwpeurBEeO44LQaQLD7Yrf+LkUH0IXSYDjm+3OVZDdqR5yKEF6vv90H4Z8mhlnjDZ1F/GhDTV5sVhVNJqFzgfiVC53VU4BYRZ3bOq0YB5ehv2tAXUhm7N7YvwygIl6f8nIWKR1aVIMtbXcz9pne8/mUugIoRVZl18Uy6FwpGyEDpPHvsd
 7e/iMEjv
 aOPbHgr1T9XraUo1PLSPRweu0wgcvBbZUtT55K4volfHAKT+K4zQiZOSgXJLAzNoQH5fCdAohJXqpxEQhChoRWRwDDzT+IEBz7FlRx/IvmLYqnOLlKGPls+SEtjJPpKxbCS8DgiNYPCAN+4d6PvtjCzZspdTbStDRBZgrO0QhstfeVDdKtDyqHGgLQgDy6L/fzWyKdlkAbwcXNBZFdEDeJBdqwd+MdfAk826cECg6s1Rz9W0UQSq9w7NuwSUzPVXHeTLyDEkMKmpnibBVrPPhqkiHOsvJ7lBjiVjgW6jA7U40PDSF6CiXqxRIS7yqoPs1KZlk2HfdNZKhP/iN2fNeps44Pl8mvRjm0NtE+RCyUenjRTYKp3frujjNE2mXvhFBJ04rBOkhtfClSlXkpE9OE8nuMF0MhsKQCNo18BP6BNGZ1M451PpPEoEY7YTHaA7xe2bFnZ4ClBzbSv0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 2:22=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Feb 19, 2026 at 3:42=E2=80=AFPM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> > Huge thanks to Chris Li for the layered swap table and ghost swapfile
> > idea, without whom the work here can't be archived. Also, thanks to Nha=
t
> > for pushing and suggesting using an Xarray for the swapfile [11] for
> > dynamic size. I was originally planning to use a dynamic cluster
> > array, which requires a bit more adaptation, cleanup, and convention
> > changes. But during the discussion there, I got the inspiration that
> > Xarray can be used as the intermediate step, making this approach
> > doable with minimal changes. Just keep using it in the future, it
> > might not hurt too, as Xarray is only limited to ghost / virtual
> > files, so plain swaps won't have any extra overhead for lookup or high
> > risk of swapout allocation failure.
>
> Thanks for your effort. Dynamic swap space is a very important
> consideration anyone deploying compressed swapping backend on large
> memory systems in general. And yeah, I think using a radix tree/xarray
> is easiest out-of-the-box solution for this - thanks for citing me :P

Thanks for the discussion :)

>
> I still have some confusion and concerns though. Johannes already made
> some good points - I'll just add some thoughts from my point of view,
> having gone back and forth with virtual swap designs:
>
> 1. At which layer should the metadata (swap count, swap cgroup, etc.) liv=
e?
>
> I remember that in your LSFMMBPF presentation (time flies), your
> proposal was to store a redirection entry in the top layer, and keep
> all the metadata at the bottom (i.e backend) layer? This has problems
> - for once, you might not know suitable backend at swap allocation
> time, but only at writeout time. For e.g, in certain zswap setups, we
> reject the incompressible page and cycle it back to the active LRU, so
> we have no space in zswap layer to store swap entry metadata (note
> that at this point the swap entry cannot be freed, because we have
> already unmapped the page from the PTEs (and would require a page
> table walk to undo this a la swapoff). Similarly, when we
> exclusive-load a page from zswap, we invalidate the zswap metadata
> struct, so we will no longer have a space for the swap entry metadata.
>
> The zero-filled (or same-filled) swap entry case is an even more
> egregious example :) It really shouldn't be a state in any backend -
> it should be a completely independent backend.
>
> The only design that makes sense is to store metadata in the top layer
> as well. It's what I'm doing for my virtual swap patch series, but if
> we're pursuing this opt-in swapfile direction we are going to
> duplicate metadata :)

It's already doing that, storing metadata at the top layer, only a
reverse mapping in the lower layer.

So none of these issues are still there. Don't worry, I do remember
that conversation and kept that in mind :)

> > And if you consider these ops are too complex to set up and maintain, w=
e
> > can then only allow one ghost / virtual file, make it infinitely large,
> > and be the default one and top tier, then it achieves the identical thi=
ng
> > to virtual swap space, but with much fewer LOC changed and being runtim=
e
> > optional.
>
> 2. I think the "fewer LOC changed" claim here is misleading ;)
>
> A lot of the behaviors that is required in a virtual swap setup is
> missing from this patch series. You are essentially just implementing
> a swapfile with a dynamic allocator. You still need a bunch more logic
> to support a proper multi-tier virtual swap setup - just on top of my
> mind:

I left that part undone kind of on purpose, since it's only RFC, and
in hope that there could be collaboration.

And the dynamic allocator is only ~200 LOC now. Other parts of this
series are not only for virtual swap. For example the unified folio
alloc for swapin, which gives us 15% performance gain in real
workloads, can still get merged and benifit all of us without
involving the virtual swap or memcg part.

And meanwhile, with the later patches, we don't have to re-implement
the whole infrastructure to have a virtual table. And future plans
like data compaction should benifit every layer naturally (same
infra).

> a. Charging: virtual swap usage not be charged the same as the
> physical swap usage, especially when you have a zswap + disk swap
> setup, powered by virtual swap. For once, I don't believe in sizing
> virtual swap, but also a latency-sensitive cgroup allowe to use only
> zswap (backed by virtual swap) is using and competing for resources
> very differently from a cgroup whose memory is incompressible and only
> allowed to use disk swap.

Ah, now as you mention it, I see in the beginning of this series I
added: "Swap table P4 is stable and good to merge if we are OK with a
few memcg reparent behavior (there is also a solution if we don't)".
The "other solution" also fits your different charge idea here. Just
have a ci->memcg_table, then each layer can have their own charge
design, and the shadow is still only used for refault check. That
gives us 10 bytes per slot overhead though, but still lower than
before and stays completely dynamic.

Also, no duplicated memcg, since the upper layer and lower layer
should be charged differently. If they don't, then just let
ci->memcg_table stay NULL.

>
> b. Backend decision making and efficient backend transfer - as you
> said, "folio_realloc_swap" is yet to be implemented :) And as I
> mention earlier, we CANNOT determine swap backend before PTE unmap

And we are not doing that at all. folio_alloc_swap happens before
unmap, but realloc happens after that. VSS does the same thing.

> time, because backend suitability is content-dependent. You will have
> to add extra logic to handle this nuanced swap allocation behavior.
>
> c. Virtual swap freeing - it requires more work, as you have to free
> both the virtual swap entry itself, as well as digging into the
> physical backend layer.
>
> d. Swapoff - now you have to both page tables and virtual swap table.

Swapoff is actually easy here... If it sees a reverse map slot, read
into the upper layer. Else goto the old logic. Then it's done. If
ghost swap is the layer with highest priority, then every slot is a
reverse map slot.

>
> By the time you implement all of this, I think it will be MORE
> complex, especially since you want to maintain BOTH the new setup and
> the old non-virtual swap setup. You'll have to litter the codes with a
> bunch of ifs (or ifdefs) to check - hey do we have a virtual swapfile?
> Hey is this a virtual swap slot? Etc. Etc. everywhere, from the PTE
> infra (zapping, page fault, etc.), to cgroup infra, to physical swap
> architecture.

It is using the same infrastructure, which means a lot of things are
reused and unified. Isn't that a good sign? And again we don't need to
re-implement the whole infra.

And if you need multiple layers then there will be more "if"s and
overhead however you implement it. But with unified infra, each layer
can stay optional. And checking "si->flags & GHOST / VIRTUAL" really
shouldn't be costly or trouble some at all, compared to a mandatory
layer with layers of Xarray walk.

And we can move, maintain the virt part in a separate place.

> Comparing this line of work by itself with the vswap series, which
> already comes with all of these included, is a bit apples-to-oranges
> (and especially with the fact that vswap simplifies logic and removes
> LoCs in a lot of places too, such as in swapoff. The delta LoC is only
> 300-400 IIRC?).

One thing I want to highlight here is that the old swapoff really
shouldn't just die. That gives us no chance to clear up the swap cache
at all (vss holding swap data in RAM is also just swap cache). Pages
still in swap cache means minor page faults will still trigger. If the
workload is opaque but we knows a high load of traffic is coming and
wants to get rid of any performance bottleneck by reading all folios
into the right place, swapoff gives the guarantee that no anon fault
will be ever triggered, that happens a lot in multiple tenant cloud
environments, and these workload are opaque so madvise doesn't apply.

> > The size of the swapfile (si->max) is now just a number, which could be
> > changeable at runtime if we have a proper idea how to expose that and
> > might need some audit of a few remaining users. But right now, we can
> > already easily have a huge swap device with no overhead, for example:
> >
> > free -m
> >                total        used        free      shared  buff/cache   =
available
> > Mem:            1465         250         927           1         356   =
     1215
> > Swap:       15269887           0    15269887
> >
>
> 3. I don't think we should expose virtual swap state to users (in this
> case, in the swapfile summary view i.e in free). It is just confusing,
> as it poorly reflects the physical state (be it compressed memory
> footprint, or actual disk usage). We obviously should expose a bunch
> of sysfs debug counters for troubleshootings, but for average users,
> it should be all transparent.

Using sysfs can also be a choice, that's really just a demonstration
interface. But I do think it's worse if the user has no idea what is
actually going on.

