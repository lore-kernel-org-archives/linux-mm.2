Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F3BC10FC445
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 21:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16DC6B0005; Wed,  8 Apr 2026 17:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7F46B0088; Wed,  8 Apr 2026 17:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB6866B0089; Wed,  8 Apr 2026 17:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C81CB6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:32:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B84B14028E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:32:32 +0000 (UTC)
X-FDA: 84636687744.09.37CB91C
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5D09840003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:32:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dK2hY9mq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of jyescas@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jyescas@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775683950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EPchF2WjR2IpNAhJ1XjC9pUofm9ILg4hJCDmTJUpqZY=;
	b=1T7BtEJyDJ+R5lsdnc++C1jXa1O0Ie1+vnmTBZo/9zV1OPOU0eFY1R+DlWv1fh4vpmWRdm
	YbW5qBJ5rL8f7CQd4OdbDjyO7RZThcqxN6nmG09RWgxKVEvS2xMRYJVZnyPjHDpYn+epXQ
	QZvlntsELqmHaFY8HR0WNQKtulvxIs0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775683950; a=rsa-sha256;
	cv=pass;
	b=Zep/mJ7hUzcU1VMs4tj+9GD+gUQf+xAhiwhV6f5BLN8Ynutmhai1Y4+nRqx8YUUHsAhh7G
	WmTn73Nh2oGCjcjR61iSajax8a54kIHlHGQnCG4vg8j/iZApZXW4T205s75PIC4obQup4D
	lg4ybFYWK2EY5nIt9Sjh8ZWq2atG44k=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dK2hY9mq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of jyescas@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jyescas@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488a62b7372so14545e9.1
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 14:32:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775683949; cv=none;
        d=google.com; s=arc-20240605;
        b=HYkDNBDcvzqBg1jdaojqwkt3Vc0BV6fZjt0elKhgdbMyB0zngsliLCztPRtn2gN02A
         1ha4U6ffx1QmtIRnvp5iCXVVr7sgHFIwXM7LiGVQ/byg8tK25rq7S+UWhMn2OHJz/hmx
         ibiog47YPY+UUY9OoZqnOLZQQy3OEF8YNBsbbzwKJ77uXaZ5gsKFacHYcLKY07ToW1wy
         77WO3ZkBP4pZ1y7uwWKfG0wYoLZq88lDb9DjyHahMMS8FWTfB3Oa4WJqJ0TzdJN9ftNj
         JTgZH1jZk18aES7R4R51qFrJSQfvFpdpoJJE9Y8J/+3xTXuf8WMHvGk5ok5kX+hoTOt4
         CRCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EPchF2WjR2IpNAhJ1XjC9pUofm9ILg4hJCDmTJUpqZY=;
        fh=3P/c/BSk7EWNgdv4A5Awi9jfBtNAZO1W2XUS8gQT4yQ=;
        b=YRCg8ShdoMEnTXmo1kDNTeF7yYq+T6xk1hFS5YZKQK7snSFQWR+WYDxgHvVk0STS/u
         fcoixKae8/ztFZdJVs+qZLeO1+u4SwCN1IJ5eDcEqbHfjOJxGj/n/W2n2IVeTSYp6Jo4
         gvAGsAoBPYTphlzgpqPkA3bN9XI+ef4jJqF+7rdXl3h1AGNZKee6/jqzVfneFhe8p4ay
         w/67szy5qGpwFgfIBeilo7FX7vjcb1JNiIaRLekDclGnvz/k98PUYwRW3sC5m3kYnqFw
         hegqlQzHmWOZkQVccb8cA8ktySNJOxdHdpMuBwALZDzNR9fGGJvyn+gXrdKC0WJyw9+i
         EU7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775683949; x=1776288749; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EPchF2WjR2IpNAhJ1XjC9pUofm9ILg4hJCDmTJUpqZY=;
        b=dK2hY9mq7MNsLYTDFB40WKNTwuRLONwackOaMBlImxg3eSvvIv0RCukBFkoOqKEHkR
         yLi2ObmYGRIowldpZtb/27ZHSBWKEnRVIAUZcBXgEs5HYOE9G47W6+RKZcYp0E6uPRV4
         cHW4x/ghqlJ3RceGLjlMX1K9fuZITn1IDeOO8d8Fk2zbBy3rC0SkIZU2vqJowDBhgluu
         DZ3K2ipzWnNOjZOyj+P4B5JMbvh1gDANTc+2YzcrZPwq74PZHyy0Rz4DRW4QjfS2O6X5
         S0Z01xgOJxRXC5GLGlfH2YPquRsenUba1fDRG9Zm5EkrmFmWScY5W89vvWKhdE5WCa9x
         huaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775683949; x=1776288749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EPchF2WjR2IpNAhJ1XjC9pUofm9ILg4hJCDmTJUpqZY=;
        b=TVHLxuVALA+7Q3GtZL4QpyBloeXh8vOEGmLtaBEolaxz4h1FoPqwCG8TEZkkE+gLLi
         L2h+9TXliwdMwOyZyULwz749WBbE44Tg+qTxrkRZSueW4HduZ2E/9d4s+0ti93OPo7KC
         b1oYOx0QeosX9P0Uza6Gavzh+7b+206gRI3rlD3X+twA/UZEbmFz+K4Uyhi4TnMjv5Jc
         gD38EUoz8ZtRfp5Etc1Wh8KwytcOQBL5TyJdqwTL+EtLo+TKynEiDQlAOWo5X1ddai0V
         5uhtCzUNIyf/bPiUkmMusIrC97PbKJejNmHaSeOuiQdAw1SXIE1QRBIgvDJ1GHZV7w7Z
         qD4A==
X-Forwarded-Encrypted: i=1; AJvYcCUQtZKJP1T/RCQKx4R+Sk/J9AAmoHElAhllQxRrTuoRCYE3HnfQR3s7+y2wjttcPdy5Q9zRn2LO/g==@kvack.org
X-Gm-Message-State: AOJu0Yw71sO3UXXnR7Gz6+YvSnOf1gKRJLytTEN0ClgfKNUuVzW8bKod
	5py7/G6cAAuzV6kbojrY6azIaRrJNeMbDOfI/fodLEvEIBOgHG9o9ZLP5CwjRZr6WFNV4OUzgMf
	/s8ovoNcNC0O0C4wF0YmFLTTqHCgJVZ331Z+P3jUp
X-Gm-Gg: AeBDietg7M+WnVDEXUGMo/cYDMk0QCKCn2gS6CdwkLqB92iTJAQPVoxFvLXAnPXTP0d
	VSfctaeE3bIEcXprht69ikFzOotIy9yfOhpxM43hxVKaVuX5o/AfEJFjvc3TvRWEIWEIXQlQIAf
	7191OcVsIX/p/k9eUcFYDH7pI4zIuzYn42K1J8l78KjHPys8lrrKtkjrRavh9ydYuLAalMKvc9q
	0XWG70v619F2uFm0aqFKnF3fBBOvcVrJ7n7wrvh7OlOsvCrqILHYr+lGbkWidbpNEKdnENthPu8
	bvVHbULR7BD66UW2r7ew3kqDBoko8omJlZs96Q==
X-Received: by 2002:a05:600c:8885:b0:480:4a7b:228 with SMTP id
 5b1f17b1804b1-488cf24f98amr104945e9.1.1775683948255; Wed, 08 Apr 2026
 14:32:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rj-fTpKjtsw1jJ0aAaC3a2Rt+zrizqY23ZHvq0Mm56uTA@mail.gmail.com>
 <00ec73d6-11d9-43ab-b1e2-d543425d19c7@kernel.org> <CAJDx_rj4DVG2D8ab9O8RWDEF81a5J-fiwtDedubEnsmL-1q+sQ@mail.gmail.com>
 <5c6e3c1a-bae3-4997-b02e-135374d1d6f8@kernel.org> <CAJDx_rgYXWNC=0_QZDmMpuZU8aZqRU8OeMBqXT1jjzrpK=BWeQ@mail.gmail.com>
 <e63e0ab9-75bd-4a7f-9400-a8f87c80d1f0@kernel.org>
In-Reply-To: <e63e0ab9-75bd-4a7f-9400-a8f87c80d1f0@kernel.org>
From: Juan Yescas <jyescas@google.com>
Date: Wed, 8 Apr 2026 14:32:16 -0700
X-Gm-Features: AQROBzDj3BlfZe1BTK7xN0h8nxSfdR1qxTOiq7qz_g1sAsapWkwwZSEjfsIt0w8
Message-ID: <CAJDx_rjk-5pp5Z884bnTBss19Xk0msEayR=GAMG2wWCk+WOZ=A@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Discussion: Targeted memory allocation via debugfs
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>, 
	android-mm <android-mm@google.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, lsf-pc@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5D09840003
X-Stat-Signature: kdq9mafq91y74zw7aztaijmznah9raa3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775683950-417708
X-HE-Meta: U2FsdGVkX1/SXrihMf9cZfPVUo409K+2H3IdWW6poxoD1uMd3ivHAYocvhIkPugdEbjERuPPayr2F+3zpJD7gEyRQY5fTZ3Ms/4YChZAtjJ4n/Wlvtoq+Ynx9tpctBAADqjHeQNMJpBqh0BYfT5dTjcYV3WX68NB5ttZWlNe3jyAaz1GpnRiDVAcJ/tovyaAWq5IgYyBm6dRz1s7tMMPRiRzQrZCHpO4ZCS2AFQVc7g8FqVg5FGicPNNne8asotDQTOqJpl88OWeYnPIkSERIEOr1P7kHqwIdfrZZv8F4vn5/JzAwz9fDEq/Ch+G+S1seSsJOP34x7+y9dC1CHcQTMVKf/UQSUgrWPMDZA8UzzLhKsbBXIChmIgLRnkiKGhDEO2hpgN0m7hJfI44PWlDa3Wtno3qPJyBKIoqMri1OcQN2IjsRPVIE3aFlhdD6Mau7Ty1IOG2sLj//soYFlo2k+lnglhZAecsvSEX9wuzUsaxE6/Ht/EmK8YI1zYC3VO+zZUq5uQ6zq0sJQbNdJCz8BsO4bOXPR9ScHPDt+ZVn2rlBveybwYTtqZUGKsqRcBWAuzwPOpdch6QfaYsN07g24dETNH+/gpG2v8GcklrCOZZ6g2rfPtw0lDtNQbwVte0O4i8s82AFTryL5U1081j8oCaq5AOgvgX+r8Dl5GOQuVQOa2D0lshhm0/gVEB4tY1OrP8D90s/rKwR9kDah4BraVWa2cwr4J3tY+FBtMD/qdgnEPRnW4z4uE9FI+Od39IhGc+kL5roKUtxY3+bqbmHr4XaG7rTiSESfiQkAb36xv/PawLeV1dFNBIMot3s1AwYYumYbMngZ3vHWlaL9n9NLl6LUOsvQYIMbghVe7SpeqURtIM5ln5kBM3WfnYB+c2Gnxukn6fEIdyCvgdbqmfV+lkA5BiwCGi61Iqut31MCvaq7WkdamBiKI2OLWsr/VBHiOzs4ncP7P1Q76C8sK
 +WuDf7q4
 fMmjSuBMLoqf+H9/6+T7x7rYXV5hSpq4J4QHt558kxZFk2Ez5tEFyHExZwxaAETWgj/+0oOSWxo/0fnRDIT0nugtdeDPFq/UCVBx2mM+WD/QMjp5qpU4SGTKsP+T5EfW4TeOmhoVp47b0AfGnu2QZ/7dCl1u63/uULKxOb6sef/QZLasTzLdJM9p5nwR8MtWva+SWlYmkl4pBJpzq39bKQo7Tr8i9piXdLwEjk1mJ8Mq1fjAhclOc47MUbLG0vtmkinwCwBJBK72zbE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 8, 2026 at 12:47=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/8/26 02:12, Juan Yescas wrote:
> > On Mon, Mar 23, 2026 at 2:14=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 3/19/26 01:56, Juan Yescas wrote:
> >>> Thanks David for you comments,
> >>>
> >>>
> >>> On Mon, Mar 16, 2026 at 8:52=E2=80=AFAM David Hildenbrand (Arm)
> >>> <david@kernel.org> wrote:
> >>> You=E2=80=99re right that going OOT would bypass the strict API stabi=
lity and
> >>> extensibility requirements that come with being in-tree.
> >>>
> >>> However, there are some symbols that we would need to be exported in
> >>> order for the module to compile.
> >>
> >> Reason I am asking is because we had similar discussions around memory
> >> hot(un)plug in the past, where we decided that an OOT kernel module to
> >> simulate add/remove was a better choice than exposing weird APIs to us=
er
> >> space.
> >>
> >
> > Hi David, I apologize for the late reply. It=E2=80=99s been a bit of a
> > whirlwind over here with some internal issues.
> >
> >> Which symbols would you need?
> >
> > These are the required symbols:
> >
> > ERROR: modpost: "cma_alloc" [page_alloc_debugfs.ko] undefined!
>
> cma_alloc() will be exported soon:
>
> https://lore.kernel.org/r/20260331-dma-buf-heaps-as-modules-v4-5-e18fda50=
4419@kernel.org
>

Excellent, cma_alloc() and cma_release() will come in handy for this usecas=
e :)

>
> > ERROR: modpost: "migratetype_names" [page_alloc_debugfs.ko] undefined!
>
> I'd assume that you can work around that?
>

That's true, we can just hardcode the strings.

> >
> >  > I guess we'd want to call the buddy by
> >> specifying node+zone+order.
> >>
> > That's correct, for the no cma allocations we'll call "alloc_pages_node=
_noprof"
> >
> >> Is specifying the migratetype really relevant?
> >>
> >
> > Yes, we want to be able to allocate these types of memory:
> >
> > MIGRATE_MOVABLE,
> > MIGRATE_RECLAIMABLE,
> > MIGRATE_CMA,
> >
> > When the request is for MIGRATE_CMA, the "default_cma_region" will be
> > used for that allocation.
> >
> >>>
> >>>
> >>> Yes, that is actually one of our goals. We often encounter
> >>> "heisenbugs" that only manifest
> >>> under specific workloads and we want the ability to stress the memory=
 subystem.
> >>>
> >>> For example, if we want to increase the unmovable allocations by 16 M=
iB,
> >>> a 4 KiB kernel, we can do
> >>>
> >>> $ for i in {1..4} \
> >>> do  \
> >>>   echo 1 > /sys/kernel/debug/mm/node-1/zone-Normal/order-10/migrate-U=
nmovable/alloc
> >>
> >> How will we handle unmovable allocations ending up on movable memory
> >> (e.g., ZONE_MOVABLE)? (e.g., allocating from ZONE_MOVABLE)
> >>
> >
> > Once the allocation is requested using
> >
> > echo 1 > /sys/kernel/debug/mm/node-1/zone-Normal/order-10/migrate-Umova=
ble/alloc
> >
> > We don't care whether the allocation comes from movable/cma memory.
>
> Well, you should.
>
> If you end up doing something like
>
> echo 1 >
> /sys/kernel/debug/mm/node-1/zone-movable/order-10/migrate-Movable/alloc
>
> You are just breaking ZONE_MOVABLE guarantees. Or what am I missing?

I see. How should the ZONE_MOVABLE allocations be handled? Should they
be excluded?

>
> >
> >> Also, is there any reason why we can't do it similar to hugetlb and us=
e
> >> a simple "nr_pages" variable, that can be set and read.
> >>
> >
> > We could use a "nr_pages" variable, but we would also need to set the
> > node, zone and migrate type.
> >
> > It would be cumbersome and error prone to have something like this:
> >
> > echo "Node1/zone-Normal/MIGRATE_RECLAIMABLE/8" > /proc/kernel/debug/mm/=
nr_pages
>
> I meant something like:
>
> echo 1 >
> /sys/kernel/debug/mm/node-1/zone-Normal/order-10/migrate-Umovable/nr_page=
s

Got it, we can do something like that. It makes more sense.

>
> (not sure if we really want to specify the migratetype)
>

The migrate type is important because we want to make both MIGRATE_CMA
and MIGRATE_RECLAIMABLE allocations.

Thanks David for your comments.

> --
> Cheers,
>
> David

