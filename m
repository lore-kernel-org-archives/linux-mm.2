Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E87606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 00:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=sOnzjiax
Received: by kanga.kvack.org (Postfix)
	id E2CFD6B00EF; Thu, 29 Oct 2026 20:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDEC16B05B1; Thu, 29 Oct 2026 20:26:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85E56B05B6; Thu, 29 Oct 2026 20:26:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD096B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:26:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1A44C05A8
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:26:58 +0000 (UTC)
X-FDA: 85377402516.02.A871B8C
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id E7C80140006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:26:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=sOnzjiax;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.45 as permitted sender) smtp.mailfrom=luto@amacapital.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793320017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SqR7Qlmk74yXkmM8mpkoCIRlm5LIZR8YEquqyqfTCLY=;
	b=iOcM5036gstZ2oXI6ZIbf7Hw5EQZhNX8LWTMoI4nejy9M0wMRbncl2E89tkthl2UUm0pHR
	2my7alii2wwjUR+zC+4tQaMIm9ypJyXw9UCb2K0Pq3mtFrh3zBG14FyCf55wzdKBVM3p7I
	fts1CvVPVmJQS0/3cVFMb0fP1EaHsKM=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=sOnzjiax;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.45 as permitted sender) smtp.mailfrom=luto@amacapital.net
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793320017;
	b=29FbhYhI3N8U1KEs1ZjlooJ4Tttlt6HeJ4Rhfy09Ar+GvM82SRzUUnGHYYXkaK0XeS5gTD
	k8q6pShmnIhUJyLBEloL5Qx9m3+XhcgkfYx4zgy8cEf2nnrw5kaQF7Pkfusq1LYingk/m6
	Vxkb+UjnEeQIX2W3NpgbOfInRMqyLy4=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bfc9154ceaso186873e87.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:26:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793320015; cv=none;
        d=google.com; s=arc-20260327;
        b=mw8rIhjWhkJX9nHDTv48c4S84qdVlMaVNtOpV4adbtBXSzfcNWhdn6156/7hNXp2GF
         bgo7XL54z88tG9H/fAQPZ6OFH9OKpKm0Qcqp58zOTwObYjnfKM+3Zua2ReQXD35lIe6S
         HqqOCLwPL/Wl5qG39lL9jWlp+Kg0o2lowD6k8hFWHA/5U9ouk+0F03IiIA1xiAaa9AAX
         guqTCSfohAeCUDUq6EO1wcODHj2cY883JNCXtXF1pWF1o3gHYQgxgwQWYVZnFLrDEHBB
         VdvtANnA0lYyasNnzY8AiUvFK1oRKEKxYhnJnwRUcAq5RGD2MRo5w6vLB0/oMYmn68Vz
         y2VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SqR7Qlmk74yXkmM8mpkoCIRlm5LIZR8YEquqyqfTCLY=;
        fh=mwu+r/ukFP4K6tcf5rv1RhERRo3rWxy1cOPHG3ILIUg=;
        b=T56mCIeAAAktW5q//bNKxRsQuDaF5dVyTV9IGR2uANJ856ZOPBinqknv6HBQii7i0+
         pHV2AZScdLzmhghjVMhN6Xvrv0i6A6A0VXj0CXOFx1QM2TA9P2RjF6dnnH4OA7LatXAh
         FwV5kE2tM+mvT3WzjLIlKNvL1i7qHYRw8G5E6X/GctFlccktGjikvFmuFNXkAdlklgaU
         QXoof8Q/M/NG7YqWsCzJaoN09Tciz1bFmW1mbVd4cCfhzHnPf/rdlE7kG3/9zsU3Jk2t
         nnN+bSo0O9KJmOZ8a+o0FyVpTV325v52WYxmbtaX1ZiYDZvxbnkDUNzeUof8BForXsuV
         9W/Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793320015; x=1793924815; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SqR7Qlmk74yXkmM8mpkoCIRlm5LIZR8YEquqyqfTCLY=;
        b=sOnzjiaxWhC6apgx6q/Orp1swfPxFGYnkNkkX4wcOBfjtjbl+JmOvSHBqwYGALxzaN
         60kHfJgStiMmKgz+gpAQEAoMp2XmT2pBCc+AADNRexn75lxUUW+YCl6D+u25ke147t76
         AXDG3zGMdmlnQW7G+4B9CgSeBaYHgLJl0SinPC8x/xA3xLsjKJf4gMoTsgPGYCvhbnUd
         p5GPXCs5Y2Tv+ndcMoYe/n1sDufPr+67aa7LU1sjSypHbLJcMLapFAghGkEPXxttaz+m
         OxwCrbZ9BPiY5jwDgwaMP05YHjNnqTD4h7/TC8ygGXksENU93T26Za5T0clYHujJ/UL4
         GanA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793320015; x=1793924815;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SqR7Qlmk74yXkmM8mpkoCIRlm5LIZR8YEquqyqfTCLY=;
        b=Xt8WBuwO8fRhbuZEOM8B6vgaYN0rm9egkzHqT8rBQc8c0KNAnv63P7c1DuauatKhKM
         jlCLacwNKvB1GOr6BrWuNDVQR9FdlUe8OUBPG9cbliZYeSr4Sh5RdC09/nLsgYO72Viu
         PaYWC6XC6yS9sTFtGQdTyq/74XpYQve1fNH7YCQTcjh/+CGDSAQTU7gjLSS7lPLsKJ5H
         aWjj2cDLuasMIx/SOcMw5x/NSoeES2z1fu5a/H/k4pfe7e7dBU5/WELfIrpcstEB8mkx
         3PsAFkzU6hSvuXb9LJCcSQZZ9WatFJ644i0ue88QcMZlP693G/P1z2cP5HsfSrg0FjmM
         /RMw==
X-Forwarded-Encrypted: i=1; AKwUvBxJGGRiMUP/105IRtF3jD554xquvT7tGG+dz01cmOtvMwGXqcnEoaTsXuVF8/WVEoOuOTzSuMeP9A==@kvack.org
X-Gm-Message-State: AFq9FYLCjwVPa8j0hH7Y7hK1rV/3Te+ahpN5D4edrrRz1Aq9iY5n9uny
	XDprRFEswb79jeyZg5gcCtlr+nVAbROVODVTbRttdIXhkTSYx+Kq0jjJTnbaEIvoByLH4qhsY/s
	8w+mfCXnqiwJ/YMMJpyRBGFRRAHp3bYK9uIv2d+Jq
X-Gm-Gg: AYBFou2lHrSZy0hxh/cKjuHVx5B6uBpqf8wikO/vGJldA6IEstDqKkB8MagnUKp93Y+
	sLmwhsRxPrPkbsl2BmBO0GxAMBROfjtoB6bkqFj44hVhw4qumby6vVvKn2uLPrOVYCknd63tOUg
	cH0Nv6AOqxgQVxYSeUIBPRzV+vC2bejprhoK9kwKU+Zrc4Ip1/t72ckT6OaYp677zrsSizARlk+
	LI4ft2VF9jO5fR1fvoRE8Ezl3xX42zidtKRKwfKmtgJ5K2YhKkOqQBMMc+5xApBomljYg2WZwow
	fMOrH4/r1SOaebQzy7j9sj+lRLyn6k8PNrVem79y0WUSj/93wTPzpFNwDBNuuW3wq3YpWNUUAbZ
	QqXS5rKHMVpyf8kkRXpJWVSju4wgP/YnySWSUvoiss5oEGkOXQzK5JNBpnfFUBGeBb0keRHqy
X-Received: by 2002:a05:6512:32cb:b0:5bf:ba1e:afef with SMTP id
 2adb3069b0e04-5bfd9520081mr152686e87.6.1793320015099; Thu, 29 Oct 2026
 17:26:55 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com> <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
 <auEksxfAi9lHFXmT@google.com> <CALCETrXDY2e8x2kdr-FQvFLs-Y7FwNozXGDvqqM6yvVA7QLV3g@mail.gmail.com>
 <auPKfqh_YjRU9Ui3@google.com>
In-Reply-To: <auPKfqh_YjRU9Ui3@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 29 Oct 2026 17:26:42 -0700
X-Gm-Features: AclHuK_wmS3zhRrQoH9hx3ZcC8OW5l1uNKU_reQs4AjmGufZO3hljBUi1_f8y4I
Message-ID: <CALCETrUEyfvaEGxMHo=c0ia3CDgSxg-YW0_=Z7T31Ou+pvicuQ@mail.gmail.com>
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
X-Rspamd-Queue-Id: E7C80140006
X-Stat-Signature: zgyybxh4fosm9ozgatgs63wojdb4y5xs
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793320016-381950
X-HE-Meta: U2FsdGVkX1/oNuBNZiPwF57XQuoKk3XQzJO1BOqjMcZ88HR/tFAWugzBaH5Omm/AM1Lr6iGbxCY+bgdR2e/oLPxsvGyxP4zMuUhiPMyKViscQgf4+1FXZWDwxY6Ft/2o6LYMpThl45UmWgAB2UB2kQlKhmqtV1RQQnVH3krDyAQs922h176z0Sin5s/I5fsUZOKBHGmi7OmjnEKFBMxCkbSapwd8Iq7b7TzOfmRqv881ePFFKVWl2a1S33czZ1pBvEqZiobaNfctBMQwBrd+BvIyXX5Iq0sA8S5FnQdsSxYD9FupoHSkDfCI5pzGdOe8rq3dLPCDEWN52+O58sjavkh33zx7tNYa5KP3+1rN/UxPY5N2XDx73HK+kUTQK4WI7qmEYxPIu77+BS8YVrV/QJPRuf8FUlhRcRgrlE2J5o2JYqeRB+QM5iPrtrz0DIvGagR+ptPDKng65hO2POWaoqtAaQiV9WssTuvJnnA71v8s4HzlTmXdHvEVHeJ7OC6Qa5Pp/+Z7tjm52p7ci/9uzm5bpmI3goaIAOgiBB4DOZ3fx4OT04vNimLGOlF+x14bv58KGuFXgUl0SLhiV2qcLY0sUtap+RLS032z9o6ZXxZK7Jrv8P1WvLyugk1T/M9F95ysKUk8BAoQeMQpT0cOivIKIGQwVQO2z7o2osrHa24vmdIWYIWa4RUDBVMsoOF90akCjE1IA6wffzDJqOL4Wt/lOmVDxsMFgEDkKs5Jj84KwI7Mt00sBbl+qzdWEUpisR5KvQ+oypGUjJx7Asgbv9EUffsiuirxxTSVEYIUXW/sS5TNsRzPMAil7HXDxfOZQ83359WrDI/lfpuJBEGrPDVRxphK6QpPIt7H/8VQ2OakksemNC1dM345rw5FFbXlteE4/cWGLjaPuMmNivNM6sIN/zXdYzVlvZKYqgpGTaLKWgv1/PZ8HR3TgSnRdcCbZoGCsOls+ij8j1JUxFZ
 hkwxr+c6
 WwQGvYIRuv4bga/pFHGV3gjIYTI/qzCFvn26RV4x0JoJYTQlK0o+9DvEAo/7kJkAa3/NQj9GUZPd/vafmvCv6lCkCpY0vxMUzgyHE1CpbjOiHQvOIgvmoMedwdklShhW6IAGuXjgDJoh0vfDZcF8hWsZFx4H6NI85VQ+muG6LhYoH+x37SPWJAFxOHMIt1YpmyV/iTMOYI6APEyjz4qH4XWn/5z+JJpKqPA/vMSygKXaS2mOH/bK1rVkDDAlG+pSZFpgmfna513JklPMpnM2WvIAx4oTYWuKDbYhIVGw1wptK2kAAUzyao4Pur6G0E91J5USO1l4582/sidtAzjTaGPWSn3x2g9X73yxsjUV6dRr7t6kousPeTI55NUEYu68YhwQlj2cFS19D4w6Xd9bsagjbzBrzi3tatt0DmsbjfB+hYhHQDYM79144IWcYtDAz0nyYQ1XK2zaMdoqKM0wD8dVmNo1BCMQSEqjy3cE1UmZ4WNmcd2/gFFvGfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 4:16=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
>
> On Tue, Oct 27, 2026 at 08:57:29PM -0700, Andy Lutomirski wrote:
> >On Tue, Oct 27, 2026 at 3:55=E2=80=AFPM Samiullah Khawaja <skhawaja@goog=
le.com> wrote:
> >>
> >> On Mon, Oct 26, 2026 at 03:46:34PM -0700, Andy Lutomirski wrote:
> >> >On Mon, Oct 26, 2026 at 3:06=E2=80=AFPM Samiullah Khawaja <skhawaja@g=
oogle.com> wrote:
> >> >>
> >> >> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that pre=
vents
> >> >> holes from being punched into a shmem or hugetlbfs memfd while leav=
ing
> >> >> the file fully writable.
> >> >>
> >> >> Background
> >> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> >>
> >> >> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
> >> >> memfd_pin_folios() to pin the folios backing a memfd and hand them =
to a
> >> >> device for DMA. Pinning keeps those folios allocated, but it does n=
ot
> >> >> keep them in the file. If userspace later calls
> >> >> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the rang=
e,
> >> >> the folios are dropped from the page cache while the device continu=
es
> >> >> to use them. The pin holder is never notified, and from that point =
on
> >> >> the device and the file silently diverge.
> >> >>
> >> >> The existing seals only partially address this. F_SEAL_SHRINK preve=
nts
> >> >> pages from being dropped by truncation, which is why udmabuf requir=
es
> >> >> it. Hole punching, however, is only blocked by F_SEAL_WRITE and
> >> >> F_SEAL_FUTURE_WRITE, and both of those also forbid writes. That mak=
es
> >> >> them unusable for memory that must stay writable, such as guest RAM=
 or
> >> >> DMA buffers, and udmabuf explicitly rejects memfds that carry them.
> >> >>
> >> >> Proposal
> >> >> =3D=3D=3D=3D=3D=3D=3D=3D
> >> >>
> >> >> F_SEAL_PUNCH_HOLE fills this gap. Once it is set,
> >> >> fallocate(FALLOC_FL_PUNCH_HOLE) and madvise(MADV_REMOVE) fail with
> >> >> -EPERM, while reads, writes and resizing are unaffected. Combined w=
ith
> >> >> F_SEAL_SHRINK, it guarantees that userspace cannot remove pages fro=
m
> >> >> the memfd while the memfd remains writable.
> >> >
> >> >How does this solve the problem?  F_SEAL is about a userspace
> >> >contract, and if there are existing users of the APIs in question, it
> >> >makes very little sense to start making those users fail because they
> >> >haven't taken the appropriate seal.
> >>
> >> It doesn't change any existing behaviour, nothing starts failing for
> >> users that don't set the seal, and drivers wouldn't require it. It's
> >> opt-in. Userspace that wants the guarantee seals the memfd, and a
> >> kernel user that pins it can check for the seal and rely on the pages
> >> staying in the file. For example, the iommufd live update path could
> >> skip verifying the pinned pages at preserve time when the seal is
> >> present,
> >> and do the full check otherwise.
> >
> >Can you clarify the API you're proposing and the issue?  It seems to
> >me like the user is expected to preserve HWPT state by creating a
> >memfd, then using some new API to tell the driver to "persist" its
> >state into the memfd (possibly by binding its existing state as folios
> >into the memfd)?  And userspace is supposed to seal the memfd against
> >growing and shrinking but not against writes?
> >
> >What if the user writes to the file?  What if the user populates
> >pages/folios into the file before using it to preserve HWPT?  What if
> >the user mmaps the file?
> >
> >Have I understood this correctly at all?  Why does memfd make sense?
> >If the goal is to attach a bunch of pre-existing pages to a file so
> >that the page preservation machinery can preserve them, wouldn't it
> >make more sense to have a handoverfd mechanism where the kernel can
> >make a handoverfd that stores its purpose and logically represents
> >some pages but does *not* allow read or write or fallocate or any
> >other user operation that actually acts on the data or its memory
> >layout?
> >
>
> Not quite. Let me elaborate my use case.
>
> For live update we need to preserve HWPT (iommu domain) so the devices
> can continue to do DMA during live update. Domains are preserved by
> preserving page tables and relevant data structures using KHO.
>
> To make sure that the devices can only DMA to preserved memory, the user
> preserves the memfds (into KHO) that are mapped in the preserved hwpts.
> During iommufd preservation we need to check that the memory backing the
> iommu mappings is preserved. We do this by checking if the mapped memfd
> is preserved, but if the memfd had a hole punched into it before its
> preservation then the punched pages will not be preserved. For this we
> need to do a complete page table walk and test each page separately.

Let me see if I understand.  If I'm following, the user makes a memfd
and does something that maps that into HWPT so that devices can DMA
to/from it.  And this is presumably something that works independently
of KHO, and it's preexisting, which is why I had a hard time finding
it in your patch set :)

And the hole punch issue is already present today and will cause
incoherence vs the user's view of the memfd but not actual corruption,
right?  So maybe that should be fixed but maybe it's okay?  (I still
think it's nasty that hole punch while pages/folios are GUPped or
otherwise gotten or pinned causes incoherence.)

But during KHO the system will ensure that the memfd is preserved but
doesn't preserve these detached folios?  If so, maybe the actual issue
is that either it should be impossible for folios like that to exist
(i.e. blocking the hole punch) or perhaps KHO should also preserve
these detached folios?

Certainly the *clean* solution seems to be to disallow punching a
folio out of a file if someone else has a reference to that folio, but
I can definitely see how that's a real can of worms.

>
> A punch hole seal, before the memfd preservation, allows iommufd to
> optimize the validation path and avoid doing full page walks.
>
> The HWPTs are not preserved into memfd; the memfds are mapped into HWPT
> and we need to make sure that the mapped memfd has not mutated and the
> pages mapped from it are preserved. Also it is ok if the user writes to
> the file or mmaps it.
>
> >>
> >> https://lore.kernel.org/all/arVYa_90j0oN1hnu@google.com/
> >> >
> >> >Would it make more sense for the drivers in question to set some flag
> >> >(refcount?) on the file to block hole punching?  Or perhaps to have
> >> >the hole punch code notice that it's trying to punch out a folio that
> >> >is pinned or otherwise referenced and to refuse to do it?
> >>
> >> The pins already keep the memory alive while it's used for DMA; the
> >> problem is only that the page silently stops being part of the file.
> >> Refusing to punch pinned folios on every file would change behaviour f=
or
> >> existing users: fallocate() would start failing whenever a page is
> >> pinned, even briefly by O_DIRECT. A flag set on the file by long-term
> >> pinners would avoid the short-term case, but it would still make punch=
es
> >> start failing for existing users of those drivers, which is why I went
> >> for an opt-in seal.
> >
> >Wait a moment here.  Given my comments above, I'm not sure this is
> >relevant to this patchset, but...
> >
> >As far as I know, right now, a program can open a file, register some
> >of its pages with io_uring or RDMA, and then use io_uring or RDMA to
> >write to those pages later.
> >
> >And another program can open that same file and use fallocate to punch a=
 hole.
> >
> >And then the first program thinks it's reading into the file, and it
> >ends up not reading into the file.  Which makes the hole punch
> >operation rather different from the write-zeros operation that it's
> >supposed to be a fancy version of.
> >
> >Now this doesn't sound like a security problem per se, since the
> >offending hole-puncher needed write access (admittedly that write
> >access is only needed at hole punch time, not in the indefinite future
> >when weird behavior happens).  But this whole sequence seems highly
> >suspect to me.
> >
> >Are you *sure* it wouldn't make sense for a GUP'd or similar reference
> >(whether pinned or not) to *actually preserve that folio's status as
> >part of the file*?  Or maybe for there to be an extra pin bit to do
> >this?  Because the current behavior is pretty strange.  And I'm not at
> >all convinced that anyone would really object if the kernel prevents
> >hole-punching a range with an active GUP, especially if this behavior
> >is restricted to writable GUPs.
> >
> >I admit that truncate seems slightly different in the sense that it
> >seems more likely that someone would be annoyed by an inability to
> >truncate a file.  But still, truncate does have the same issue.  Maybe
> >extending a file could notice that there is still a folio covering the
> >newly extended range and stick that back into the file?  Seems messy.
>
> For live update either approach works. If pinned pages cannot be punched
> or truncated, iommufd can rely on that directly and the seal is not
> needed. I went with an opt-in seal only to avoid changing existing
> behaviour. If folks are fine with blocking punch hole and truncate on
> pinned pages, I can send patches for that instead.

That needs opinions from other people :)

My two cents are that blocking hole punch (or making hole punch fall
back to writing zeros) seems entirely sensible, but I'm less confident
I know what to do about truncate.

--Andy



--=20
Andy Lutomirski
AMA Capital Management, LLC

