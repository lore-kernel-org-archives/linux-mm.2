Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AD8B105D98C
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 00:12:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79D3F6B0088; Tue,  7 Apr 2026 20:12:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 774D06B0089; Tue,  7 Apr 2026 20:12:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A156B008A; Tue,  7 Apr 2026 20:12:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 599DC6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 20:12:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C36E15BC84
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:12:27 +0000 (UTC)
X-FDA: 84633461934.21.BE9E622
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id A952A80005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:12:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v4rzpaCD;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of jyescas@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775607145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHMFWRsyNJMSYyS5gv8kYWrKwZicycuGQkDesa1aKUk=;
	b=oRdoaKwo2/xIa7wEtZh5cS7EFm/wcOFBZ7ot+QZhfvi9ToU2aJQEK3nK6C3zmV0tn1HXeP
	Jy+tcKenl+wziQryYJv/NIJ4+WpLC1ZUJjFYCkzAKEUm2WSgJ6CWpfb99mroG+N80DLgQX
	XUk9JQ38L0b8Ak6aO2hx2xsekO0K8L8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775607145; a=rsa-sha256;
	cv=pass;
	b=o79TKAwylhmwSd1w+OS69upEEQHe2gGr8T5j2QnPJUQnH0vZEzxknUWLFWsmTdpVQdMjBQ
	NLHahbvUbh48wFAnnS6Q0qfD3nhXCKeCp3QzYdiZ2LTaVQnmDRnMqQgBkneu3Q3ZsGBbie
	w60+siKW2Fi1Tj8iKOcBR/EdykV5uFo=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v4rzpaCD;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of jyescas@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488879dcbc3so51945e9.0
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 17:12:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775607144; cv=none;
        d=google.com; s=arc-20240605;
        b=MGKiiwlWs4kpL3r0aUYN6ua2I6eg45Pkm9P5oJm5UrKnlCD43Wn81OcmnFOEJ4GTOl
         feM0QS4SaBjn4gM8jFXQ69xYK1imX7M4j80lfnlmlxhzV6mdsww2IbRaBwLE6fuY1BG3
         T8xrccGa+bz1yrwPK8yPdJG+P22TTh+Qa5PNZLWNokpVxvpzT64IMLvbvOHU3nOTSb5I
         +F2GhmMQmTWRlxE9F3gF5UmMWsDemKQ/B7toBMwXMH11Ms8uKvnkO1EXsx6otxyA4/02
         htm5IFolqsRadriQ7LVFSgvpjTkjfIXLHkDX91boLWw9CaTBc4As7bDxkoGJusbG0jz1
         3x6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PHMFWRsyNJMSYyS5gv8kYWrKwZicycuGQkDesa1aKUk=;
        fh=r53IUjjZK9tsZY4yEovaJUoaj1XfaIQDturyaOaABsc=;
        b=faUClSir6NFOzVjIMpPWerEaN66GnkSgGtRfaGyDrjWVt8XpPdAx/f7uu0Ga8j3t4h
         RfnP4asqoQZT4FrBVO92697jM1zhJRqgFwINwqWXQnV1BSHYYaaGvdlCfUKpdmz83YF9
         c5bj5erIROZVgDAX8zO3oqC+FVbMEAJXuoQLmYmVRFwU8ve8sUxy5Jm2Nstk2qYI7noR
         YPjQnQUUow+TtsBk5psIcsjvi9eWpfrwxS1WbBJBE1vOB/uMXBlGrMirbMFgr/dHU8SX
         OgQ0B+cCUndb4hl+aDIaI6dhQxe30DJVvW3awEw2ZNPfsnZHo++nY90YWEx3jnMGpV51
         803g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775607144; x=1776211944; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHMFWRsyNJMSYyS5gv8kYWrKwZicycuGQkDesa1aKUk=;
        b=v4rzpaCDn+x7tXgt/HyRdW11zOPkfj0bWyn+obG+TtbZhZv/kWiNfqb+xK6cJ0LfnD
         xH418ywJ9PribDcPRa61WEbyHEO8qDmazmd+GwPYvhBCZAzip+tpKQsm+foWQV13/Pt+
         LEY5e0WJE7h8GDHExBYIOp2QHU/t8UKaLK2DTvoEP74HWyg60Iu3fqoHhKd8ek531E5u
         CAwy3Xd9pGsSJ/eOd6UBSmL71AVceMEoqFfB2rtq7PERAb7znUZv5rAfeVJceFo1b5Q8
         31EOkL3MHIdfeXXYkmwrkEARgi/NPkScDVQH0vhqOz8fw7aMwBDE2////NRq4Kxa3E0c
         PgqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775607144; x=1776211944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PHMFWRsyNJMSYyS5gv8kYWrKwZicycuGQkDesa1aKUk=;
        b=qiElPhBTycDUVD1o+wYB7WpdK0uXOxaKjG4WwClsVcHjPGraEAmFSlbd5zwd56c9vY
         LisFIPFkGPKUiZcMVFgKuQDedBsIhHm1DHpMXRKieImtGqOBw7t8f55SXAZezwT5/oNc
         186etrtNHcjSdTUVMH2cICeKSFuPlvC7p0p6KROw4IW6+2DORRkHJATPu/AtAsswktRD
         Z9LrDT9xyTY9Z120EdD7ciXxmw3HxCIRdqrvwsdXLhDIgAXH8ZcV+z19ojTuOZc1bbXZ
         p5M/UWVlwxvlbAP5RX+o0OiuUDSTWvf7YgrNVM2Zdk4P1nulBlTua0WEr0r22p6bjirS
         kRmg==
X-Forwarded-Encrypted: i=1; AJvYcCWXiV0z1CVdj013wwUAeYo2aHdHstOAjwPsTB2Cm705TUqIElBqXEDZV1RYeQpwxirKxtZ1BaOeaA==@kvack.org
X-Gm-Message-State: AOJu0Yx24VCwEcEpvtW0nOaf9FNvqecJC3nbrb4Kh99fx+OzJOfeK9e9
	R+QrAUKldcz0fYZ9j8rcRCI1BUSt8d9VwDROsJcBf9nQ8JDTcOURRpl90fwrHP2iDVipgrSQigR
	jgqgyUih20RNbguN3vCDTVaIrT9PMGmen0rLDZ9MF
X-Gm-Gg: AeBDiesv8Ri/ezux6hhI6VV0d4sdrXlndixIJ+x71ho1Xio2ts6Nqzf5x51sueI+VOn
	IFYIDI1y+16P5Tq38p1ePgkqP+w9sAdDvBpbYQ1Y3cshuk6/P4lPgXvMwXkigGKGM5qFXa3aMw+
	i5gzjdeIx+EQdv0egJ74E/gp7NBDv/PT+qdEPheZj/Xl/ZyxkH4G/7VhSIOZUo9nP5382AaPLdh
	KBDVTgcKJEUH7RSIepTh6zj9K4HOp1MNh1NzpM4mTcUE8VgqJawV1+5Ciiw9I5+Kv4w3KJkf1ol
	EpBb8Xy7r+3m5ELvAwDRiOPCMAYY8TyGWOmzeg==
X-Received: by 2002:a05:600c:3acf:b0:477:255c:bea8 with SMTP id
 5b1f17b1804b1-488c78de781mr30715e9.7.1775607143498; Tue, 07 Apr 2026 17:12:23
 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rj-fTpKjtsw1jJ0aAaC3a2Rt+zrizqY23ZHvq0Mm56uTA@mail.gmail.com>
 <00ec73d6-11d9-43ab-b1e2-d543425d19c7@kernel.org> <CAJDx_rj4DVG2D8ab9O8RWDEF81a5J-fiwtDedubEnsmL-1q+sQ@mail.gmail.com>
 <5c6e3c1a-bae3-4997-b02e-135374d1d6f8@kernel.org>
In-Reply-To: <5c6e3c1a-bae3-4997-b02e-135374d1d6f8@kernel.org>
From: Juan Yescas <jyescas@google.com>
Date: Tue, 7 Apr 2026 17:12:12 -0700
X-Gm-Features: AQROBzCUem8iN4R1U-wVLmAUX9FaiFpwBbk2tQnc7o0GY4ZQNvxp80Rm7zX7hdo
Message-ID: <CAJDx_rgYXWNC=0_QZDmMpuZU8aZqRU8OeMBqXT1jjzrpK=BWeQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Discussion: Targeted memory allocation via debugfs
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>, 
	android-mm <android-mm@google.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, lsf-pc@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A952A80005
X-Stat-Signature: 5y1uc6h99bngiitnbd7ujgtto6arztbn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775607145-549735
X-HE-Meta: U2FsdGVkX19n2T3KHk2EPYsFGQC0G9TpNvfM1IblTA71nPCaGGfhIMnmYGz+SpetFRvAA35bypn/9geH58J3cqXNrFQgYQ/0wItSXqVyDpvyj4tyFmqpqC8WyzXlScGGC6KzBAK5UijuZU5cvNEgk+CXJKfwd7v/lQJedAXefAP0dqFSUpBuZ53N/24CGZhxyEvp8UQeADn6qLYOu65zSJ/BPjWNrqlAJm0N6djvlJCvaG1SD2VqiYB0eg0LQrHY2/9T0jEwv/IlZQtckoNFCdcJjA5cMImOKaLmiEDqslW1XJbS7w8dLosDjlOtZLzwsSxxKJbEhmUIOWj0jF47RyxjVYomASqENUVNHnBl8GnEF52WXRx9stHDt45BYDDzFPSZiAl6uVi1fr0LW+Bs1Yhjb7yhDIFeyJgH4qpqpEbRjlTtArHcoAYUWIsCW6f9dyhwny6h8/qYdgGEzkUCDkikRIo6ixwN8ot0wAzF2168Whi2bHFzn4OG5LA+aJrtn2f1VHnQ9nexNt0eUi16MKy74M1oidbQ7SbFeEYN2kzuzicmRJruZbfFo5VC/FStoJ8HDMKcojJrWVpi1k7HW4rJ4Te29m0zbV+DckQASADcTvClD6SHWmMUQdQ/kTIi6RF7JfgxkOX5pa/DNIWZPOAlx3Cc+brIEMLT+gkHzYb8U/esV6NiGUYALWH8Q/H0p5S5VL8KIiJC/IjpOWGmyoCvWvt+0oRQNJpY9yyaRbU4j0hKdDoyMwYtEPfUKoHmVO+b2z1VT0VAJZwgQEYkp/v0Pk9YD8Gcr41aMxsfVv0f4jK6HnhBrAXzvmNsS8L+mvuUnxq6e5S5Jndqk0QScysYjYQcSh+4BmINZPNdWZCAvh1TtvsQ7QV7niOQFLDKtI60o4W9XYD2/oVl7p9b2a9hYGWzVGO2N5Rf/yNLkyzPR30Br7g7eYliyStPgwIOutgcKRD+O7ETK/7yd62
 FH+aYaZd
 0NmY2EL9IDoqbwen8QBFmU3DzFZqCKijfWQ2vq1c7E0FnTYAh3WcugBQcS9wNVbt9Sw0pSu8hyN8E7bo1GyxpTmHUp8VuUZBkLkCXpRrZks/EUvp1y9ZODqOpnxPWkyIZyg7v/ngkntXzmie0+qOUVlK9OxfQRqoueeYwj8wxVWfwyqkJ1S2ytgW/baWFuIBuYCLN+CdrICDh0d+eCCpxK9u/0+aPN051s0hOvHZr+pYredLEA2OMq73UJcuGD6eKkX5nDYUSh1g19NaEm/eAwyAdbRvdl6K8wU1r8jctr24JXsfaNYyNA1LhZYAqPSN+yKwAJEz7+elur/dK9oemeCetCa8uk06M+Az3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 2:14=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 3/19/26 01:56, Juan Yescas wrote:
> > Thanks David for you comments,
> >
> >
> > On Mon, Mar 16, 2026 at 8:52=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 2/27/26 03:42, Juan Yescas wrote:
> >>> Hi LSF MM organizers
> >>
> >> Hi,
> >>
> >> I'm late ...
> >>
> >>>
> >>> I would like to propose a discussion on improving our ability to
> >>> reproduce complex memory allocation and reclaim scenarios, and solici=
t
> >>> feedback on a debugfs-based testing interface to help trigger these
> >>> edge cases.
> >>>
> >>> =3D=3D The Problem =3D=3D
> >>>
> >>> We frequently encounter complex memory management issues in the wild,=
 including:
> >>>
> >>> - CMA allocation failures due to pinned MIGRATE_MOVABLE pages.
> >>> - Page migration and compaction failing during reclaim.
> >>> - Excessive reclaim loops triggered by specific workloads.
> >>> - OOM kills.
> >>>
> >>> Reproducing these specific memory states for debugging is currently
> >>> cumbersome. For instance, consuming most of the available
> >>> MIGRATE_MOVABLE memory, or forcing MIGRATE_UNMOVABLE allocations
> >>> specifically from Node 1 and Zone DMA directly from userspace,
> >>> requires writing custom kernel modules or relying on unreliable
> >>> userspace memory pressure tactics.
> >>
> >> I'm wondering whether an OOT module for this purpose would be sufficie=
nt?
> >>
> >> IOW, do we really have to have this in the upstream kernel, or could w=
e
> >> have a public OOT module to perform these allocations?
> >>
> >> Then, there are no worries about API/Extensibility etc.
> >>
> > You=E2=80=99re right that going OOT would bypass the strict API stabili=
ty and
> > extensibility requirements that come with being in-tree.
> >
> > However, there are some symbols that we would need to be exported in
> > order for the module to compile.
>
> Reason I am asking is because we had similar discussions around memory
> hot(un)plug in the past, where we decided that an OOT kernel module to
> simulate add/remove was a better choice than exposing weird APIs to user
> space.
>

Hi David, I apologize for the late reply. It=E2=80=99s been a bit of a
whirlwind over here with some internal issues.

> Which symbols would you need?

These are the required symbols:

ERROR: modpost: "cma_alloc" [page_alloc_debugfs.ko] undefined!
ERROR: modpost: "migratetype_names" [page_alloc_debugfs.ko] undefined!

 > I guess we'd want to call the buddy by
> specifying node+zone+order.
>
That's correct, for the no cma allocations we'll call "alloc_pages_node_nop=
rof"

> Is specifying the migratetype really relevant?
>

Yes, we want to be able to allocate these types of memory:

MIGRATE_MOVABLE,
MIGRATE_RECLAIMABLE,
MIGRATE_CMA,

When the request is for MIGRATE_CMA, the "default_cma_region" will be
used for that allocation.

> >
> >> Or would you want to fire up this debugging on a production kernel? I
> >> would assume now.
> >>
> >
> > Yes, that is actually one of our goals. We often encounter
> > "heisenbugs" that only manifest
> > under specific workloads and we want the ability to stress the memory s=
ubystem.
> >
> > For example, if we want to increase the unmovable allocations by 16 MiB=
,
> > a 4 KiB kernel, we can do
> >
> > $ for i in {1..4} \
> > do  \
> >   echo 1 > /sys/kernel/debug/mm/node-1/zone-Normal/order-10/migrate-Unm=
ovable/alloc
>
> How will we handle unmovable allocations ending up on movable memory
> (e.g., ZONE_MOVABLE)? (e.g., allocating from ZONE_MOVABLE)
>

Once the allocation is requested using

echo 1 > /sys/kernel/debug/mm/node-1/zone-Normal/order-10/migrate-Umovable/=
alloc

We don't care whether the allocation comes from movable/cma memory.

> Also, is there any reason why we can't do it similar to hugetlb and use
> a simple "nr_pages" variable, that can be set and read.
>

We could use a "nr_pages" variable, but we would also need to set the
node, zone and migrate type.

It would be cumbersome and error prone to have something like this:

echo "Node1/zone-Normal/MIGRATE_RECLAIMABLE/8" > /proc/kernel/debug/mm/nr_p=
ages

However, when we have a directory tree, it is harder to make mistakes
regarding the node, zone, migration type, or order.
The tree would look like this:

# tree /sys/kernel/debug/mm/
/sys/kernel/debug/mm/
`-- node-0
    |-- zone-DMA
    |   |-- order-0
    |   |   |-- migrate-CMA
    |   |   |   `-- alloc
    |   |   |   `-- release
    |   |   |-- migrate-HighAtomic
    |   |   |   `-- alloc
    |   |   |   `-- release
    ....
    |   |   |   `-- alloc
    |   |   |   `-- release
    |   |   |-- migrate-Unmovable
    |   |   |   `-- alloc
    |   |   |   `-- release
   .....
        |-- order-8
        |   |-- migrate-CMA
        |   |   `-- alloc
        |   |   `-- release
        |   |-- migrate-HighAtomic
        |   |   `-- alloc
        |   |   `-- release
    ...
        |   |   `-- alloc
        |   |   `-- release
        |   |-- migrate-Unmovable
        |   |   `-- alloc
        |   |   `-- release
        `-- order-9
            |-- migrate-CMA
            |   `-- alloc
            |   `-- release
.....
            |-- migrate-Movable
            |   `-- alloc
            |   `-- release
            |-- migrate-Reclaimable
            |   `-- alloc
            |   `-- release
            |-- migrate-Unmovable
            |    `-- alloc
            |   `-- release

> Why did you decide to use the "handle" approach?

I think it is more convenient for the user and less error prone. Many
userspace developers exist.
that want to create memory pressure by allocating CMA/Movable memory,
but they are not familiar with
the nodes, zones or orders. This debug fs interface will make the
things a bit easier for them.
>
>
>
> >  \
> > done
> >
> > And this is way more convenient than writing a test driver to make
> > only unmovable allocations.
> > The same apply for the other migrate types.
>
> Right, but the interface you provide looks like it would allow
> allocating from movable areas etc, and I am not sure that is generally
> helpful (or adds more complexity to handle).
>

This will be a self-contained driver that does not require changes in
the memory subsystem.

Thanks
Juan

> --
> Cheers,
>
> David

