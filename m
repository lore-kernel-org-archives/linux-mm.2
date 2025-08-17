Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2E4CA0EDC
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 08:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA30A8E0039; Sun, 17 Aug 2025 04:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53FD8E0035; Sun, 17 Aug 2025 04:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96A198E0039; Sun, 17 Aug 2025 04:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7369A8E0035
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 04:34:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 280C4C059E
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:34:18 +0000 (UTC)
X-FDA: 83785587396.18.10889CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3EF2CC0002
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:34:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SjeZrue1;
	spf=pass (imf22.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755419656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lv5EppNL44ZEX2hvBRD7O03Dw/5DmQ0XDkM46OyMHp4=;
	b=gBFhppZH/DkORgLLsUhgh6rlLsINu1fsc5iNZXpdtFUTnex65cBDmxY8zTxLhAJRylc8A1
	PmjJi92hE06rBgZgqQvB6TPH81WE+1R5bvkZMtLnriqWu+yKUoNfxUMRF0uKojy17/8kiA
	q8Fb/H7PQUsC8AI76pL3BC/+2ZYtF6Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755419656; a=rsa-sha256;
	cv=none;
	b=ozYX6zTjNtYbSvOnas4Nv1mswbERBCX7fIA4dWtGuJBdN+X/r4+/+P5kueylumBcVzCVj/
	iBtwVXTT95JmtPHpVtgEhfbngiFvLIGfG7Cp0s5zqW8LhauvWLj6NQHEL6Gg2WmYr8KcPB
	toKFD+TxqGh3iIpFSuMp7FSiHjla6dU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SjeZrue1;
	spf=pass (imf22.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 71436601DA
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29236C4CEEB
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755419655;
	bh=li5zZbum8kkyoUzY84Ph1M8+NH2gQa+3WCpR7pJIhAc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SjeZrue1BVbhIJAnBNMVx96Io0yARDyZ+wTeB0fvi/1GppRjxvCiN/RKWXIF4JVWX
	 Dza97NVV2d8qa9sYhkKxsxWiVOXGDCzl2BfpKiGV7O1zG1wo29qQPO8yZmCQd375Jx
	 c68TD6F6rM7IqLbCD6wz3nuzsS+/8nk3c5syIR8ZLAonxL83R+8DYyle5HCYOkd059
	 m9oP4Hn8CMZ9VscrMIrIvi69FH6ERWmf9nDNo+unc+i3PZF1xmkzSiD7TiuonERh2X
	 G/fXebe/OzAPBxawF8VdozPod/5xoH4bNueTJJ8ETNDau4gz83RYxqzEKOUfiso3Xi
	 73g2Xh+kjSuVA==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6197efa570eso2163016a12.1
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 01:34:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWjR8HBVDnplpRMTzHivdSc1YyGZd0dAMKJSB6uMsrZnmGmAhdYafozoI70uhRSQ2CNvO7v3MLZaQ==@kvack.org
X-Gm-Message-State: AOJu0Ywk/v33aOiwGw1N2S2i4WTmhlMarP+RAF51ZLZXzaO+Oo3LZ/ds
	qAOkqh4eUjEi6tzOFp+rw4PlYMtDXy1SwIXC/5B7/Ay6gwqmKo/nJ79QefR/jeCFE+AjOLCEBez
	/s2YYwNpJvfaqb6ajBKulRDxKtlbUsSU=
X-Google-Smtp-Source: AGHT+IGa9W/r1zgXGlg06WiWs92ObZQDb827/f2x4dsSdzi3dHGFsi/6Oo0bvRS19ctBiV52MhxG3L7W2cSOzww/3TQ=
X-Received: by 2002:a05:6402:270c:b0:618:2257:7fcf with SMTP id
 4fb4d7f45d1cf-619bf1e5a9fmr4440978a12.18.1755419653730; Sun, 17 Aug 2025
 01:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250815090539.1578484-1-chenhuacai@loongson.cn>
 <a20d605c-79a0-4d89-985b-9512a990b492@redhat.com> <CAAhV-H470h2HDEN_NY2qNBxUqQrSRQhLzwqZe9PB8GjnNsZVFQ@mail.gmail.com>
 <66ebc632-6704-4637-b62d-1cb11e5a4782@redhat.com> <9db98f7f-b90f-464b-ae7f-e94ac523bc28@redhat.com>
 <aKCwjCJTEhX4Q6wW@casper.infradead.org> <e06f23d9-adcf-4d0a-8ba1-bda6d4b483b1@redhat.com>
 <CAAhV-H6csiOVDco=pocC72WSPiafDJV+1+R7P0KvB15dxOjtow@mail.gmail.com> <3871f0b0-db94-4358-877b-fd5ddb4337dd@redhat.com>
In-Reply-To: <3871f0b0-db94-4358-877b-fd5ddb4337dd@redhat.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 17 Aug 2025 16:34:01 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7eX2OOaT=kMdvTZP5mO=_vpCs54h9_=xai6qPUJJixog@mail.gmail.com>
X-Gm-Features: Ac12FXzrRv7B-5AfseowyHbeieLtUNdQStVrTWOt3K4mY48V0WZeUg2NepDi4TI
Message-ID: <CAAhV-H7eX2OOaT=kMdvTZP5mO=_vpCs54h9_=xai6qPUJJixog@mail.gmail.com>
Subject: Re: [PATCH] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
To: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Huacai Chen <chenhuacai@loongson.cn>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3EF2CC0002
X-Stat-Signature: jh9puzzs86ud68jmcf7wcummpcki4bs1
X-HE-Tag: 1755419656-180293
X-HE-Meta: U2FsdGVkX19GPGIR2M00PXRmdT7N2ZCbMliv1Wm5o5KgucmCYralpocs3B4/m4T0LLQfvxO0dXSHrLM6ugzDMJSRteTxTbHrhY1gclZLMP/pH9ZGzIVC5u48SIohJOroLgiC0Mwo0nPlCzXUN2DTLJ50oG4ixVjXqqZoEF+lC3wee0Il0jycqRCzYaHd1pFX96fKjbkqxpTlcr02abMU0yZct92nNE21laKu+je8048MGo125qNu5qFMhIhVURIcraDIWcb+7g6m3rZVfdObsfKehwun8xSk1b9ZwWg+ofbsSORFHZVc+zMfXedjoS9hjijxpTf8JNZB+zRBwSTzgRwNGn2af21aK4y5DbH/bybHVqwr+sM8MmnDQhPXRE4Wur2nc2IPl6cT7Wqelin6VsivT6THTwjpZzds2d5Is8Qw+cl1xJob6eViDv9C5Nrq2NFQQBbX+ye2fQicYztPj41bfwes9iLkvf3enti/6cDJXxK8QJwsrV95F/JlZTrcvkEvqZNIYzlv5ueWyb2WsOAt93JxXIVddMh7WL3VE2I5AeHY2QK2lPc9pe32snziLwhJ15bJbs5IT9JSUnY4tV8autBj6F61oDThG2CGt5myBAwMUfWTv0uCWcskHbewZ3/8WwcQfvgKkVt4lfgcuaJlnDYe8F4X5yRcof+ztnxNWe1xXdz4nE8qHh3PuSdkxrr0l3iTsw5nOBpjnyaqnJPlUueA+eTv1+gHMw88LCMgZdIl+Klj2w81OeIuPozJwo+bhJFtu+RF0oT79oENs7nFqph1Tgafeq/aQoo/YgMg2DLU75JLry5r46/6Pq+5hX2QrJqJemyrn44uXy2cBleF9SVY/Ziu89w/ok32xV7Lyk/IhZw6L3k6v85HnuQBERQtXnzfDyYM41SHkaFyb9UUGpuXzUFlNnPnISh4tRDuONxDr0j01bEejwXC8AyIOIsCKjekzq2JjLFmpNM
 Wev0iEEc
 uDQwctx/qNVCCfJoxYPaURLw1yewWSFcahZzIaVGhS5U1gC570AYAf3CaxkfC3EF8MWBnzWz2tozbbam5o9XmuaFPQ28nxFTjAmBy+Ypb12ZdNXxW/ks/G1TkqMtlTHQvirvU63+0P8jV3LOERNChfGkHABe86gt+v6WhKSCJxoy1Nn1HNWp2c/Xa1PtJdZjni9SpyZPK0GdNh+5IhRksy5ghx98VqiUfzXqub7GlBkCnVwCF60lFH3IcoGU1VBkPZOSq/p1guAO6iePJ9gF/9a1ClS+hkXqukjPwNxYM71qbJJAl41BURuQDGxH2SWMPrz5R8dTWkapOrkAwUToX4hzhBfHWZwiU2rH4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 17, 2025 at 4:05=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 17.08.25 03:37, Huacai Chen wrote:
> > On Sun, Aug 17, 2025 at 1:02=E2=80=AFAM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >> On 16.08.25 18:23, Matthew Wilcox wrote:
> >>> On Sat, Aug 16, 2025 at 12:54:52PM +0200, David Hildenbrand wrote:
> >>>> +++ b/mm/balloon_compaction.c
> >>>> @@ -256,8 +256,10 @@ const struct movable_operations balloon_mops =
=3D {
> >>>>    static int __init balloon_init(void)
> >>>>    {
> >>>> -    movable_ops[MOVABLE_BALLOON] =3D &balloon_mops;
> >>>> -    return 0;
> >>>> +    int rc;
> >>>> +
> >>>> +    rc =3D register_movable_ops(&balloon_mops, PGTY_offline);
> >>>> +    return rc;
> >>>
> >>> Using 'rc' as the name of this variable is an anti-pattern.  All it
> >>> tells you is "this is the return value".  Calling it 'err' is far
> >>> better because now we know it's an error number (or zero for success,
> >>> of course).
> >>
> >> I know, we all have our things to complain about. Some about Cc: above
> >> --, others about the name of error variables :P
> >>
> >> $ git grep "int rc" | wc -l
> >> 12730
> >> $ git grep "int ret" | wc -l
> >> 80386
> >> $ git grep "int error" | wc -l
> >> 4349
> >> $ git grep "int err " | wc -l
> >> 6117
> >>
> >>>
> >>> It seems to be a particularly IBM derived antipattern ;-)
> >>
> >> Careful miser :D
> >>
> >>> Some internal style guide, perhaps?
> >>
> >> Kernel-internal style guide maybe ;)
> >>
> >>>
> >>>> +void unregister_movable_ops(const struct movable_operations *ops, e=
num pagetype type)
> >>>> +{
> >>>> +    switch (type) {
> >>>> +    case PGTY_offline:
> >>>> +            WARN_ON_ONCE(offline_movable_ops !=3D ops);
> >>>> +            offline_movable_ops =3D NULL;
> >>>> +            break;
> >>>> +    case PGTY_zsmalloc:
> >>>> +            WARN_ON_ONCE(zsmalloc_movable_ops !=3D ops);
> >>>> +            zsmalloc_movable_ops =3D NULL;
> >>>> +            break;
> >>>
> >>> This might be a bit excessive ... just passing the pagetype and not
> >>> having the sanity checks should be enough for the tiny number of user=
s
> >>> this interface will have.
> >>
> >> Yeah, no strong opinion, this was a 3 minute hack.
> > I have tested your code, everything works well. But if the checking is
> > too excessive, can I use a set_movalbe_ops() to replace both
> > register_movable_ops() and unregister_movable_ops()?
>
> Makes sense, given that I don't expect us to have multiple handlers for
> the same type in the near future.
>
> Please do keep a sanity check for replacing valid pointers
>
> if (old_ops && new_ops)
>         return -EBUSY;
OK, will done in V3 later.

Huacai

>
> Thanks!
>
> --
> Cheers
>
> David / dhildenb
>

