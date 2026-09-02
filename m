Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE9CC624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F4D6B00B9; Wed,  2 Sep 2026 10:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEFA16B00BC; Wed,  2 Sep 2026 10:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05276B00BD; Wed,  2 Sep 2026 10:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94F986B00B9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:11:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38F7A401DF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:11:01 +0000 (UTC)
X-FDA: 85169008722.19.1586E38
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3FC0020002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:10:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ECd0AAgX;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788358259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ebSLBU8UfHrQpTdooqoDv4OrjDjrNDcCYGDv+r9oP8E=;
	b=6urRKKOGfkJFx/5+16yF/UCmg820881XNySZVq9WH/kmc2l6Wh6aocaGDQf+/l5eGuUwG0
	vKAAC/HD5iX38FaGTOuyCt3OFUmYwDRdS7bjrAS4i1VwvWoN2Lc2fg2+58Ul6sfv2UrdyS
	fODcKhIG4WxOCm77WLGrKrIrS18fIWg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788358259;
	b=QObUeoyJKg3VdSLGiNqnD/ZP8B+yzvjMMEc9zAll6gk1xT5IkqBt3rr2sjb0yKMy3mqQHf
	qtVMECbTAiu1LfMaNLFJI9lwpdyQa0Bl3jQfoAPsdvke/d1rP4L69eyOI3rWkEj/IwxlZU
	41nmV4lJVwzQT3QKOAiens+ikxKc9CU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ECd0AAgX;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-485538d3499so689775f8f.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 07:10:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788358258; cv=none;
        d=google.com; s=arc-20260327;
        b=EvrngAP80dtUzhpwx9LIt7ig/hzCAxbTZUv+ycetKnzLNWeGv1powmiq7iDzp15vwh
         GqLeyrYAdYvzCVaZSiySSfxwDIerkPrKnR9f7vC5CxUX+hFKfVTrpAcfUn0X955vSzfh
         ymJtfuxFS2HLvwynTjNKRFHTq0rUONXGTxPTqkRtoJSwJgc6XN+jZ0q0jEB+E8jU24M8
         HzUfs2RHy1ziPrAbxuj7sX2ESc4csQTb3SC/ZKdbFENeeqfY5Fz+udyX4vqHicawTYrx
         auqgzATl0Z9QEShUKb8oiaTNxr5JO+GwIxLHcNan7veCtfjitBfLh7lxpojvkEiZsEd2
         3gZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ebSLBU8UfHrQpTdooqoDv4OrjDjrNDcCYGDv+r9oP8E=;
        fh=ZvJEo4bxULAnNlxUBVxh+iohpRVmUu2MwKLkBdZBJGo=;
        b=jxq/+jp23xT9mgw0oVoS++HQD1HxHgRwtoZcK/EPKHNSOWikvJdiyeaLqb5g2LyrRs
         T6IzDZQneCARiwX4K50UZAtCeW4dqbl8pXdv/An/9lhjD3o1I9H8bKLg6sUP8NxD9tQR
         /jq8ogpDUDQNPbA3dwkkZxkmG6VoECRavDxf+yZ75cV5Y1JEwWtL2lgUmO1ERJJUwbAV
         Ll2U7rOfMMxhO1KZqOE14uLBOBnHUXTovXn7wYjWiWv4xvVuEgLzbQIE8hZD3TqMRA4x
         YxqWfKpPMX1LsGl0F+yd4Qi6TN9dHYgwJJSBHX4eYJS4g/DOhcrpy9o8SpyDyx9Gcaq6
         z2oQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788358258; x=1788963058; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ebSLBU8UfHrQpTdooqoDv4OrjDjrNDcCYGDv+r9oP8E=;
        b=ECd0AAgXOgf8VHIJnS6Mb9mglQk3uSHu8D+1p1q3w7IatXPxXda56Du5UDsyia2uNe
         DdL9IAfXWVLT5zpK2EiZEbFBJyeH7F0AXl/F6dn0G27+RvoTToelv9Ey7LIdi027geDj
         TUUHrCc6yZXbXeUtQRLmL25AIkF0zButHOChKGqr3kBEC6EZYDO6VwFu2HsXUc52zg1W
         VhJ4t3oMuqHazppVIqRwKqbzqZHcCvwJfedJVoev3dSrHZTRL5m2YPeCg9ZjcjPfaB/X
         zgMpsbyh8TMZzaipaL9fZRBfx45KpHh2zDtaNy//KBPKbOyyEL/+dubrGL4MHcaPbYQY
         +oyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788358258; x=1788963058;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ebSLBU8UfHrQpTdooqoDv4OrjDjrNDcCYGDv+r9oP8E=;
        b=iiDQQGWHcdDPDmdaBJcV5GZJMANt6nKzHSuITo5hajp01E546oHvrZVkJ6x3tGQrra
         Ufokkh+5qhVxw7I5lcItKiAFLKf682zeKyCEIBI+l2Gnq4vtnsX+JgnzHuYnjtADNFcu
         Cg3UKBuY6G0snOIGhI+ymxMII7XWsdDv0UsRD/+pINb2ZkR780hQ6ElvdBG+9k5HGl8T
         X63bTmVFeM0CVKm80i2vDTJWQnkOa0JeWkokr3mYYTHUm1dhFdZikD17wONsGmMYa9bi
         0DabjxE2A0trliL4FlR5tUQNqohlqua079vcbrdFCkFnUUWuFxLC7qrENYj4x2n9bOOg
         p/qA==
X-Forwarded-Encrypted: i=1; AKwUvBzFF1paQzvbTS9JKHgJBRGmrx+tHr9/XKVLe/cli6jNPp4Jq1EaElyHh/7NXFJkDOS+oQ4UkcDxNg==@kvack.org
X-Gm-Message-State: AFuF++nERiNZcfXnYeaaEk0y5mtDArcnNq/7RvGDSgnJDw3ZpOuQTAV4
	Vu9bxnTnzMGz6gbP/VOFLt7r60XpwTxqFmYWfJ5p1zohE3cUcnj3QNhVDCPbXpdUlHWXiGuW+cJ
	1qHEozbzY596nG40fqYVHuMA9d6KTE/8=
X-Gm-Gg: AYBFou315AJfzDsg+A9dFxssO0X1/likZlxSnCs5zZVZiJN+n8zqQNqPpNJ2t+Q6QFV
	eqqqTB75R1MSeYURW2DXa2NhFp1Hjy6E3lvk0J2M1CJrzzLdaxcEj02uYOQom0ioK4l6jJ9H1uh
	KKqsOyXnBSQZr42c7+hSDryj/bEijt3lQ11e2iArBXg8DlD2AbaZcvSnzb+hss8GA1TKfCKTXyo
	PY5NEkWeK816svew6AneCt1Ft/Z9zf2Y+WL1bVA0oy3PIP6znRQc76/SsfzchEFEKt4pWXbW0pr
	pLJmlqiNQ85qJjH4MlRXBepGV6FdOzoyA4Vhx8DG51vqG1C/1h06oRmR9dv+ewx1RAaLx9C5//H
	zFfU=
X-Received: by 2002:a05:6000:18ab:b0:481:512b:f0e7 with SMTP id
 ffacd0b85a97d-48488f1898emr9592102f8f.17.1788358257484; Wed, 02 Sep 2026
 07:10:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
 <apVNB2FRTFMDtvGP@KASONG-MC4> <apaw_XmqnEcY8sv7@MiWiFi-R3L-srv>
In-Reply-To: <apaw_XmqnEcY8sv7@MiWiFi-R3L-srv>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 2 Sep 2026 10:10:45 -0400
X-Gm-Features: AcwNN1WYya8eMurhgXTECj7Nz3qh8FEbpdAoE296wjpQB5CRlBuJqO6z1kGHWtw
Message-ID: <CAKEwX=MU9uXVenEu7he+h-Pq7K3BmCGvvKS-KiPK61Xd0ox_mQ@mail.gmail.com>
Subject: Re: [PATCH 00/16] xswap: extendable swap device backed by zswap
To: Baoquan He <baoquan.he@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>, Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	baohua@kernel.org, youngjun.park@lge.com, hannes@cmpxchg.org, 
	yosry@kernel.org, shikemeng@huaweicloud.com, chengming.zhou@linux.dev, 
	david@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3FC0020002
X-Stat-Signature: 6xans4zdngs76r3buuigmd113s11mm3a
X-HE-Tag: 1788358259-79407
X-HE-Meta: U2FsdGVkX19MSQoI78LnRguthoE7LSSfsXQ+GGOscyY+kEgMHfTJOmuX8jXG5qcZFiuMurzRsGW95WyvlM0tnUMJxsj9Wb3EoHd2X0EIXceqAMZdpMi7sYJ1DniJDwuvzwH/M/ryYcXX0JO4ajlLqKktH1rF9lNwmPNoQqYDuClaq8Fj0Y0679yuHJaCmoSzlgxBGCUX+l73L0PKhOpLqMQ7pi+83RsYER62v/TWGyGzRFZao6ry+TYCB4OcFTSe8ASrKBSaelfHwgiSZrwAgXCITzuVJtjVnGKN6O/gX0IvGSfZsb5IUfduJ2IgbuTCR36UQgEfXLx80EJDLyUJzmPykS7krDcS5+Rh6C/m6CLdZxcbGMluESjOqIkNxPifjYKu7PCM7kCohH7JQFesJiWI3+OIdOlqjKgmVfRa/2PzhsOy+vl9x6jqkMw3g741zTFt34HXPD8ywEKwSvTt/9tVclsI37TJByIyDn6Bh7lE7ms9ytmDDROS88og9F88GJRz2pdu1d1bUJrNyCtFhxZcwdUzg4UhIKVi7BjMi05INljZzanqr5nNbgbZUz4NrRpa2zCZpsjRnzGuUS9jgOifMyas4WoLVjxYpRUg6DT5JwknRKLsjfBJqVq8s8cT1RuiyXSbqJo5rRWehqagpmBHqmmN+CmOIm2iTHcviPnG+wB2WYnGaOKkFH6MA0+oY79iLSmiD+W9k0nZxmjMBtOf6hhq5sKpHqxn+Rq6swARXmOS25jJJvKPvxzN4sdt4KtKePI9Iei8ZbVNMzUiWTxF+IzT/7cMX9ak3o1ISnHK652WY+FJ8KXnhGMNhwyfr9KwXhJI/RAqXX6aq8PUnu1oj/AKtb1sOt5KJhFIYUs4tUjAr9T+ErTkH1JJwVGSxPI3nw6d+NXyfkz5iTTpNqlkVXJR8wTtxigz0OWu2LJQadF4R3DKcb4BTB36+5mJ9viFbutJauqlIyz7W5+
 b9txk1ra
 0vRcvcbpj/B/nzasXnvgnhEX8fQr8qfJKPXDO/TF7tSu9GBa39oYVmI9oaBbbkCttjUiYpoEOfowZO07loPhxaTy+kXcx2LmSfGUt+e6R08jRH1rfGxDiRsd5Wk82wpSvvCA5N06710TzlvvhSpA/S6zDvlJfcg4vmQy/luVoxDbaaAi1bsc6InSwixwf6P88GedZzsqHfcub+jS+zyC1c5GPy6I5KfTU56mqko+mWjy/GGKi4DDOJZq3R5b6RijKNFMlbb5Aa8lqES80Tr7KS7HAHR4DKoABRZSxk+PmyVsmFzzweVMux5l6GWl1OMoGb6d/zEzc8ajA67q/XEO9wNgMFT5bmqszaTTElFGN1JY5j39/OtKw9YYDq9Hjw/J/GDfLZWPkftqD9iNkw47XFc9gYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 7:03=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> wr=
ote:
>
> On 09/01/26 at 01:54am, Kairui Song wrote:
> > On Thu, Aug 27, 2026 at 05:44:50PM +0800, Baoquan He wrote:
> > > xswap is an extendable swap device with no backing storage. Swapped-o=
ut
> > > pages live only in zswap, so the device wastes no disk space and its
> > > size is independent of any physical device.
> > >
> > > xswap decouples PTE swap entries from physical backing storage. The
> > > cluster_info array is backed by a sparse vmalloc (VM_SPARSE) area tha=
t is
> > > grown and shrunk on demand:
> > >
> > > - Grow: when cluster allocation runs out of free clusters and the dev=
ice
> > >   is below its ceiling, more physical pages are mapped into the VM_SP=
ARSE
> > >   area and their clusters are added to the free list.
> > >
> > > - Shrink: when contiguous free clusters accumulate at the tail of the
> > >   mapped range (tracked in O(1) via nr_free_tail), they are unmapped =
and
> > >   the backing pages freed.  Shrink is deferred to a workqueue to avoi=
d
> > >   lock recursion.
> > >
> >
> > Hi Baoquan,
> >
> > I didn't check too many details on how the implementation in previous
> > RFC until now, After looking at it, using VM_SPARSE to setup the cluste=
r
> > info area is a really smart idea, really good job!
> >
> > I think many info are missing in the cover letter though so I wasn't
> > sure how this grow and shrink works from the description, after
> > checking the code, it looks much cleaner to me now, correct me
> > if I'm wrong:
> >
> > Every xswap device will have a huge and fixed "hard limit"
> > (si->max and si->nr_clusters_max), and practically can be considered
> > large enough to hold any workload, and won't change once swapon
> > is done.
> >
> > The actually data (si->cluster_info) of xswap device is completely
> > sparse and dynamic using VM_SPARSE, and so we don't need to change
> > any existing routine. It grow/alloc and shrink/free automatically by
> > the kernel, limited or driven by a "soft limit" (si->nr_clusters
> > and si->pages) which you can modify using the interface below.
>
> Thanks a lot for careful checking, and you are quite right about the
> mechanism and details.
>
> >
> > Once concern is that the "hard limit" is now the total RAM size. Isn't
> > that actually a bit small? Will be better if that one is tunable too?
> > With a parameter, and before swap on, as the hard limit is hard to
> > adjust once swapon is done. Any thing limiting this?
>
> Chris and I talked about this, we both think the total RAM size is a
> good hard limit. Because xswap is similar with zswap/zram in essence by
> compressing memory content to save memory. So the real limit is the
> zswap pool, not the slot count. In fact it's never able to utilize the
> total system RAM, right? Making it larger than system RAM is
> meaningless.

No. This is not quite right. The size of this device is the size of
the "swapped out" data, which is multiple times the post-compression
size (i.e zswap pool size). The multiple here depends on how well the
data is compressed.

This is not to consider the other swap backends:

1. zero-filled swap pages have effectively 0 memory footprint.

2. disk swap pages (I know this is not currently supported yet, but
it's a consideration for the overall design).

>
> Memory hotplug is a case in which system RAM can be enlarged during
> system running, while that can be taken into account later as a enhanced
> feature if it's really wanted.

A lot of these problems are self-inflicted. If we design a fully
dynamic swap device, then it's not in consideration.

>
> >
> > And I think these details better be mentioned bit more too.
>
> Sure, I can put these thoughts into cover letter or patch log for
> reference.
>
> >
> > > A per-device ceiling (nr_clusters) bounds growth and is adjustable at
> > > runtime via debugfs.
> > >
> > > Interface:
> > >
> > >   /sys/kernel/mm/xswap/create           write "<percent> [<prio>]" to
> > >                                         create a device; percent is a
> > >                                         percent of RAM (0 for the def=
ault),
> > >                                         prio is an optional swap prio=
rity
> > >                                         (default DEF_SWAP_PRIO)
> >
> > With what I have read so far, the mandatory percent limit here is kind =
of
> > strange, even with 0 as default. Why not make both args optional and ju=
st
> > let it grow without any limit by default? It looks more "fully dynamic"
> > that way.
>
> I'd like to clarify why we default to a soft limit rather than "no limit"=
.
>
> The soft limit is the administrator's deliberate size choice, similar
> to how zram requires an explicit size. On a multi-TB system the
> cluster_info array is not free, so planning how much of it to allow is a
> real decision. The current behavior is: grow up to the soft limit as usag=
e
> demands, then stay there. We do not shrink on idle, and shrink only happe=
ns
> when the admin lowers the limit. So there is no grow/shrink oscillation i=
n
> normal operation.
>
> A default of "no limit / fully dynamic" will instead let the device grow
> without restriction under memory pressure. While allocating cluster_info
> pages exactly when memory is scarce, relying on shrink to reclaim afterwa=
rds,
> which is the oscillation we want to avoid. So we'll make both create argu=
ments
> optional, but the default will be a sensible ceiling rather than unbounde=
d.
>
> >
> > >   /sys/kernel/mm/xswap/destroy          write a swap type to tear dow=
n
> > >                                         a device
> > >   /sys/kernel/debug/xswap/type<N>_cluster_limit
> > >                                         read/write the per-device
> > >                                         cluster ceiling
> >

What's the point of having multiple xswap devices if it's going to be
dynamic, cluster-based anyway?

