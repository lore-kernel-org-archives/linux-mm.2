Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927CC606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 03:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=h+CcrEzV
Received: by kanga.kvack.org (Postfix)
	id 88B576B0972; Tue, 27 Oct 2026 23:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83C796B0973; Tue, 27 Oct 2026 23:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705C56B0974; Tue, 27 Oct 2026 23:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 464F76B0972
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:57:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C69B160BD7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:57:45 +0000 (UTC)
X-FDA: 85370676090.18.AB49FB6
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id A04D720002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:57:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=h+CcrEzV;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.51 as permitted sender) smtp.mailfrom=luto@amacapital.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793159863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMXrGQL+HMAYYOepT9QRjy9INGR/r2c4dPSHBgR+Ovg=;
	b=4VdTd+13RYdMV6/XRRMTTKYwoc/BQXspwsC0iN6OzJTXrsVJteT1/m9GcMDKv+/kmeQ9dm
	BW0f9LWBXsYOPKy1GELmXcUMBHqrXiEYfgPELeiNlTDjkHRvE2duHXR6Ri6nGaB0yPj6ZL
	TWwjat9WoLmXj0DipBEb6VldK/lBMpg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=h+CcrEzV;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.51 as permitted sender) smtp.mailfrom=luto@amacapital.net
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793159863;
	b=GcmuQuRYGT9pjuDH4qdJVNezptcaN7+MAyHEUZjOM8QPUkGZaSa4NQomfElk+xRwiuL62l
	lUvBV6Q9y4ejQ5Jx6LEGYiSg3SUaCSNx/VJfm4+6WbN//wDbqh6rDhxocGvxY2//tm/zNm
	CXCLRXQ+GnK3k1Mojw/9fpWLvl5tbEo=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5ba3fba0080so483490e87.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:57:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793159862; cv=none;
        d=google.com; s=arc-20260327;
        b=pPv5hkpAwuQtAJTizLcEjgasX/ScEW3TrfiigAGlhxbpYwqBm0qNWnEMnMdxVCfD69
         D4qK7kifM59skHBDJDEo6i2xinxHKU1p8Syjn+/rmdRGBZlS4Na4S8W7nMs4k/GRAS8b
         t742vsgUldiZZDjrLmMKIys1m05NZJbkP09xw0JFnLEhjR2WUXirOsi3lWWSL8WXwkw+
         wq3941oF4rBAJ2gDdcYZqTSUyzayWyWesUA8wMZU4OaM2nDrIPfTJcN8VIMMeMAKMHLi
         VXTuF1aZz6bJF5n1dJ8fEhzUP9zMjF5AWm0rwEOvZoSwhgVoMhtS2frc+/CfUwALjSLU
         K2ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NMXrGQL+HMAYYOepT9QRjy9INGR/r2c4dPSHBgR+Ovg=;
        fh=EF8PmbmE2zejz4Lb9wIkkLgSLkMEgHtOjppgOGKm0Cc=;
        b=B1qHn34kY+/dHDcv06pfPe7IA8v02DDmk+HkjWDV4huIAlVnxgB/zczWmW58Wq+xAy
         HJcA2eFCGAM5b4t/Hqp2j8ly3cMSPiCVrTddS5TKOvRf/ojVJL/3pVj0aj6PHI/3K8iy
         KYtCm85VCZEyEoBCEgGECoTTmlyTYKUWL39degX2lWG0JkVic4+KN5zKSm50BOzy0MuA
         gedv6+8NBSd1wzyfY+nJ/WIfCGKKhBAKnzwJITggMJpDHZPr/HQ61UQVhgeXkyPRF3RO
         5D4iWfQvHAJ5eXCeqmblNxb1fGUC/+AEZ7PH6pV6GSvuLt3xu570jkk8fFPDjQ5HBzOr
         73tA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793159862; x=1793764662; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NMXrGQL+HMAYYOepT9QRjy9INGR/r2c4dPSHBgR+Ovg=;
        b=h+CcrEzVDaGYVloSYzsTg8oXL3jhuga09TaU+FvFhOR2ekmTsmItX7VQz4Zy2Ypy6t
         bA9Vu6ySxz0taRDdnYxg88X9MXXA8ruIaLtsnXazVesimjb7GAjek0bN7TvvCjnCFK1D
         eoJo5GCWUndo8idlLvSXcNL2Wtsfhs8ErgQz5eNJIhzbVJbeex+ia0ZtEpu5QFWZboCB
         Ee/B0mwRstHf39lh1EbGySTVGRtUj0Hvy6CNblHZYiBybpN+bBrrQGnu0KMtnl7MxMWH
         bOnoR1in1AE7Juk+BBZKNy1AJtRVjmjly0zHS9oAu0cFTHTac7GgNeXl7SyiVdH4BkPh
         Ipcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793159862; x=1793764662;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NMXrGQL+HMAYYOepT9QRjy9INGR/r2c4dPSHBgR+Ovg=;
        b=m4A+5KWGfQDsYp+I01hFi8Crav53t7ZCojYQUBfky9bJP0NQ2PGq6uQYh1phhmvXfU
         29tKvHLtFaGGnZtg4NN4V1EGNNFMNiOPe1Sz9k0zMvajYRqsplr2EGHmVFyGTRJfPVz5
         8dX4ujpJBkDU5R2cIR6OvzCSt6qvVN2n+GdsDVKlBhrg48E0cix0TgevDA3ULGb8lCet
         0XLB49kr8V/TfQpAnQ/Gy6e5EOXG2kvXoNg1prNWWy3us3E0Cf2uVbBLQdFnRocvoj4W
         vH1c9EBJzCucJC3fW793E4S/Z9JcE/rfxa1ba97Q2/lK9qvXsR8rBTQPxzT9spZwdZ/R
         KybA==
X-Forwarded-Encrypted: i=1; AKwUvBybZyECsPrtISNCQQxtlvx3qtGHb2YUbBDcsDbFaaapEi4m6ZW7FA5yWS8MY0XEgkL8bEQGPNPCdA==@kvack.org
X-Gm-Message-State: AFq9FYI0rnKnN0OPLfvwxPd+90wdGav9QpNrws1AWOvPhySnY7PtfVhU
	68NXBmhN9zDfOKM5ht3o3DPLzonQmqzhTUz1sbIM8ebn7XTAYyCUp/mfDfHTSrrwpAM7VVbkC30
	UG4/nQ1EiKAm7z0gB3B54qHiIGSYvwrJ6LxnTQyGA
X-Gm-Gg: AYBFou1z9Zw5CsPRfubXwKM/vFzkOWyPpu6UAYtDNF9f1kJx1OFW2SMYnPad+dza/Lc
	fOHEk0fXxq/f9yt4jDB0IWR6nhv1fea5Z9NT0inB44eJ5xFxOb/loz5aj/y7a8Flzs1EEMRFNoK
	008PKynt5O3zJq3Ajs4EsEdbRTP2so8j3MbSkulNu9nqqg1liBdPvo+druRQZIIEbhUm3VxEwtX
	0eOPwBUYL9izNd96xOgA5vWh9XcSZBhhsqVWjPC1B6BY/1VezCAaQfyep10RDB8PDZAlr5T6ElN
	oRqrOzDvChKgD9IMJebmuPSL1kEyWGbE/GY9g0e4Ht6czT02YbOOaNzyW0hGdPzzwO8gckPGOKQ
	0a9TrGeJOR2Zkh5Gr5XE4euW6W3jvlW2TMA==
X-Received: by 2002:a05:6512:39cd:b0:5bf:c619:b088 with SMTP id
 2adb3069b0e04-5bfcad172c1mr381529e87.20.1793159861277; Tue, 27 Oct 2026
 20:57:41 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com> <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
 <auEksxfAi9lHFXmT@google.com>
In-Reply-To: <auEksxfAi9lHFXmT@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 27 Oct 2026 20:57:29 -0700
X-Gm-Features: AclHuK-ukwGAOGBSGCB4Bz_ycZfHCvtj9w2gkhhBJhRypC_kHO1bNXVuIJcmKsM
Message-ID: <CALCETrXDY2e8x2kdr-FQvFLs-Y7FwNozXGDvqqM6yvVA7QLV3g@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A04D720002
X-Stat-Signature: itbo6k9iic38z64tusbhhg4r3865t3pf
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793159863-862200
X-HE-Meta: U2FsdGVkX18EfZCc2QcvWkIGHIiNSChiaDzXzBAG0QtMMNGYpg3cPWFqTm/pVmvNa5B9eC1Koolc86+vdiLwZ4v7v7Adfk7kZmEotfDjrkLpcs+1dRFe9yIRXP/pUj6OZapTYzk5CKMgobqQwULE00QXg3Nk3KAecNTy2RLvM6peOdN5M4eESFbUMd00w+uBZvJrVpCRi7fWcuouE7/V5vWh5bpH2VnRlYXIB7MICZkmNMfNxLFV1XxsosUZXYQy2FktskIyKOMBhlKizlSCo6ijsoAfgg5ROivgvWLe6xFcgVK5sfwO/SoGFPar4LZS+tdFoJVxqmAjr85HltSSs46gqwa5lsFcJXYrObWhj3KADS6lGv0rrXjQeEXwuOn6Xj8Mjm4+Nz7howDHIGmA7ZqQFiogSQZAGZ9qp8PkbiYXzAv8/KfvGQSulh9gQeg0Iv88Cvg21AOIO9DYxWUj6LazZRLs1B/jqinZyvWVuWB/eYIlBWwV5kPpjtuu7uoeNyNiujqBvsikdTxWaR2v9ngg805N2lK3AJ4VmESL4TjUMRmpdyeRxhxj1UqSQGK2I3k+RJ39X7nZNBt99KaXMY0l036aHQBvZThEMy0KOdaP1Sgw/tkKlGvqfC22e6PyEL83eOVoznWaqBxH+WdIseF13dWWAyR9aAEa5YXvYNOcJaptRuuU4WcOU12stRHlqb52Iuumx9WOPZNdUImnUqWIyFMxtiHAndj3BExoOsiKQ9xP1pKfAFblSRgLOuUpwV0f1DoXDCvF/CVGvSOk3C/LARZehm3980o79no17lgO1t1InswHBWShqi3wRXHnhJm3vZpTqWO6xu7wQaURZoWSa9ZTs9EZnTGA4cVyznp7A2IF6pwf1XgPbY7hJ52S39N8iGjBMwK4Ztno7Ob6wvRJaFgcOGGWvxToAa/XrOTvC7bKdAqAQt/TKfAv6GxUUC8uEWHAzNGRAXmcsuM
 FUojLx9n
 SvuhEmf/zcDl9BDB7ev7ae4UT86227v9qQ1zM62iojW4HHUWLzKOlftTntcDeUNZ+ujDeSOophEP97bmy2Lt7mWpl2Zip6zgR4LtIZFNFXfUA9iskeV5ypS1WqF14ikvzgAFtvFU38DHOjzkkwc6tiRer7LIrrHFCfNundKzMu9lCWBgEhbNKRNs1whxZ9lCBO26S+89Bx5fp9udFCeH9NJipO8+Vknw6xlGAwLpWrIlRqSXSIl9Bg8+Wp2oWnUAihA3aO1X6pt4oK2RkxAKPGPwd7dAjWgFfvCn1yCJO43HPb1P2QS4Xi2bhbOxym6y4AvbyzcqD6Q6Phi44phcKMGZGrBlzdGdoZMMvGOqEPDOuoGlPRbkqgJRk697CdXWdi0VUDHldZlu6xS8hFv3OL8vAmdGCNyJhuhh7i+b6ntUuAIEJbKbGWp96/FameTp6Y+O4sbkyKTWh2MDjQzRUqm7fwz40tKN14vdZQiEVgG1SHlAnDxxifHx/iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 3:55=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
>
> On Mon, Oct 26, 2026 at 03:46:34PM -0700, Andy Lutomirski wrote:
> >On Mon, Oct 26, 2026 at 3:06=E2=80=AFPM Samiullah Khawaja <skhawaja@goog=
le.com> wrote:
> >>
> >> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that preven=
ts
> >> holes from being punched into a shmem or hugetlbfs memfd while leaving
> >> the file fully writable.
> >>
> >> Background
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
> >> memfd_pin_folios() to pin the folios backing a memfd and hand them to =
a
> >> device for DMA. Pinning keeps those folios allocated, but it does not
> >> keep them in the file. If userspace later calls
> >> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
> >> the folios are dropped from the page cache while the device continues
> >> to use them. The pin holder is never notified, and from that point on
> >> the device and the file silently diverge.
> >>
> >> The existing seals only partially address this. F_SEAL_SHRINK prevents
> >> pages from being dropped by truncation, which is why udmabuf requires
> >> it. Hole punching, however, is only blocked by F_SEAL_WRITE and
> >> F_SEAL_FUTURE_WRITE, and both of those also forbid writes. That makes
> >> them unusable for memory that must stay writable, such as guest RAM or
> >> DMA buffers, and udmabuf explicitly rejects memfds that carry them.
> >>
> >> Proposal
> >> =3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> F_SEAL_PUNCH_HOLE fills this gap. Once it is set,
> >> fallocate(FALLOC_FL_PUNCH_HOLE) and madvise(MADV_REMOVE) fail with
> >> -EPERM, while reads, writes and resizing are unaffected. Combined with
> >> F_SEAL_SHRINK, it guarantees that userspace cannot remove pages from
> >> the memfd while the memfd remains writable.
> >
> >How does this solve the problem?  F_SEAL is about a userspace
> >contract, and if there are existing users of the APIs in question, it
> >makes very little sense to start making those users fail because they
> >haven't taken the appropriate seal.
>
> It doesn't change any existing behaviour, nothing starts failing for
> users that don't set the seal, and drivers wouldn't require it. It's
> opt-in. Userspace that wants the guarantee seals the memfd, and a kernel
> user that pins it can check for the seal and rely on the pages staying
> in the file. For example, the iommufd live update path could skip
> verifying the pinned pages at preserve time when the seal is present,
> and do the full check otherwise.

Can you clarify the API you're proposing and the issue?  It seems to
me like the user is expected to preserve HWPT state by creating a
memfd, then using some new API to tell the driver to "persist" its
state into the memfd (possibly by binding its existing state as folios
into the memfd)?  And userspace is supposed to seal the memfd against
growing and shrinking but not against writes?

What if the user writes to the file?  What if the user populates
pages/folios into the file before using it to preserve HWPT?  What if
the user mmaps the file?

Have I understood this correctly at all?  Why does memfd make sense?
If the goal is to attach a bunch of pre-existing pages to a file so
that the page preservation machinery can preserve them, wouldn't it
make more sense to have a handoverfd mechanism where the kernel can
make a handoverfd that stores its purpose and logically represents
some pages but does *not* allow read or write or fallocate or any
other user operation that actually acts on the data or its memory
layout?

>
> https://lore.kernel.org/all/arVYa_90j0oN1hnu@google.com/
> >
> >Would it make more sense for the drivers in question to set some flag
> >(refcount?) on the file to block hole punching?  Or perhaps to have
> >the hole punch code notice that it's trying to punch out a folio that
> >is pinned or otherwise referenced and to refuse to do it?
>
> The pins already keep the memory alive while it's used for DMA; the
> problem is only that the page silently stops being part of the file.
> Refusing to punch pinned folios on every file would change behaviour for
> existing users: fallocate() would start failing whenever a page is
> pinned, even briefly by O_DIRECT. A flag set on the file by long-term
> pinners would avoid the short-term case, but it would still make punches
> start failing for existing users of those drivers, which is why I went
> for an opt-in seal.

Wait a moment here.  Given my comments above, I'm not sure this is
relevant to this patchset, but...

As far as I know, right now, a program can open a file, register some
of its pages with io_uring or RDMA, and then use io_uring or RDMA to
write to those pages later.

And another program can open that same file and use fallocate to punch a ho=
le.

And then the first program thinks it's reading into the file, and it
ends up not reading into the file.  Which makes the hole punch
operation rather different from the write-zeros operation that it's
supposed to be a fancy version of.

Now this doesn't sound like a security problem per se, since the
offending hole-puncher needed write access (admittedly that write
access is only needed at hole punch time, not in the indefinite future
when weird behavior happens).  But this whole sequence seems highly
suspect to me.

Are you *sure* it wouldn't make sense for a GUP'd or similar reference
(whether pinned or not) to *actually preserve that folio's status as
part of the file*?  Or maybe for there to be an extra pin bit to do
this?  Because the current behavior is pretty strange.  And I'm not at
all convinced that anyone would really object if the kernel prevents
hole-punching a range with an active GUP, especially if this behavior
is restricted to writable GUPs.

I admit that truncate seems slightly different in the sense that it
seems more likely that someone would be annoyed by an inability to
truncate a file.  But still, truncate does have the same issue.  Maybe
extending a file could notice that there is still a folio covering the
newly extended range and stick that back into the file?  Seems messy.


--=20
Andy Lutomirski
AMA Capital Management, LLC

