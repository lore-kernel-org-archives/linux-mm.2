Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 000AAF46C53
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 16:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD6C6B0112; Mon,  6 Apr 2026 12:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4916B0113; Mon,  6 Apr 2026 12:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BAF66B0114; Mon,  6 Apr 2026 12:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09B476B0112
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 12:18:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4E38C1AD1
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 16:18:19 +0000 (UTC)
X-FDA: 84628638318.20.EEEB10D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 59A6CC000A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 16:18:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RlLkC7yg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775492297; a=rsa-sha256;
	cv=none;
	b=HG/LVFxwNvLmlz8ggaJ22v8TBNfyctWnhN7P1zhWQ7CdDvsRnaZAHB69grH9YdjgPit0Ou
	G3pTx1ibINWiHaAPoWintyer/FwQJseXagP0MQLhNDtvwZmirG1GPO5cpacwkeVO/volm2
	2xqNTQNmOYBIRwepFqCoLPQdrZOuZlQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RlLkC7yg;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775492297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6y77XvnI+Mo2VOk5fqGJ7LyYJ/iXdioOpfeqZJmaEik=;
	b=p9XedG703y2VcZ5IgOwPvHpLXuCRMsFjxIjs9zzwb0QoAF3vxCfMAH6ko93MNexdf7HLcW
	eE4jy9RFLH6ETZULHnGgBKZOgo+k7Rghi3ZXSh9MDhJY9+PBAUCH3wrP3PGALSXovKogdk
	TZF4lK48z1my/j4If78Qi4W5OtH1C4I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775492296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6y77XvnI+Mo2VOk5fqGJ7LyYJ/iXdioOpfeqZJmaEik=;
	b=RlLkC7yg4IBd7ns0ST/m+OmUaBgr6RrzcA8EYdQnEM0n+PZcNsSgiMF1vUmN4nUo1eesbA
	A07CviY2y30c7CZJw0PztQYFjfbOytVeqUA7cSG+Fq6zv/fGaFq2P5ZKwhvJ/FkxolIALG
	uAHqFCD4Wsnp9hM33qIWmOr1/w2rh2g=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-KUwoV0oDNsiIlQ6jBsQJ6g-1; Mon, 06 Apr 2026 12:18:15 -0400
X-MC-Unique: KUwoV0oDNsiIlQ6jBsQJ6g-1
X-Mimecast-MFC-AGG-ID: KUwoV0oDNsiIlQ6jBsQJ6g_1775492294
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-65079af211aso97077d50.3
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 09:18:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775492294; x=1776097094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6y77XvnI+Mo2VOk5fqGJ7LyYJ/iXdioOpfeqZJmaEik=;
        b=EhlSYho0jcrQcQ32EZDzxKCxN2NLZOpsN2JLWylsroUSD5YQ5uv/SKemFVDe33rNkd
         zHKIxTcTyvNke0xNGQ40hzorvRu7zCLygCiQzMt6uH8dMeBUOig9n86o7+n0QjlWScFj
         gR9GQByDZhm/dMjWM+cN4oqdLKCl98B8FAPDKxgz6pgZX4WjPf0+CR1zs/xXH5rswbM+
         WlRhrmxPDEcTtweJdS0Fc3HPicp1AJDbK6ZbE3S3rnxedbfszzfdyEEVxxOUbABrVCnK
         LBtGYlQxwKZBVQ1W+VJKBep/QVlGSUMSIyOHPFKAGbWmUgNnj5sck+becjloz0edrgq8
         elQw==
X-Forwarded-Encrypted: i=1; AJvYcCV1JgfmCzlhsKSgkSilaY33cFUh5DmQ4stQR8IoWTTUtd7a7AwqLj9RHVR/7Dy+e7PYft3oZbZWaQ==@kvack.org
X-Gm-Message-State: AOJu0YzrQ68I/cPU1tXYoabcd57pytI63fU9GMNflv5DELGDHwGH7iY1
	pfoBrHcuZWMa61xxkbGDKGGapi6IdfkQYHUxsh8jihsv2fYp6O4z1aUzfkv5VL/DqmkYFGBfzPK
	z7dLvO+wD1dmkIWLI6IxSSS4EgvkCcweoB55vvcxFeb9gxDdtcR3xaNC9twedhpRhtCS5rlxjj9
	Eu6nvG/uHtdQZBX56XuUR36jfhbuE=
X-Gm-Gg: AeBDiesNMroCSixX1qGUTm+2K32Je00v2bfQPb1fHLKMaZgy8VS0phWEm3gMZAYcwt5
	e1fu2VMKCob6P0ZpOG9W4mLP3oNKYJRyx/GBUkcWV7dPugUEC4IWmwzd1u3ccoQ8BI/UB9M9LVi
	TCrlgqfKOxIxlPoYj6zRqZvsyIq3Ii4/A+MJdY5ttnqWPb38W+cL+91Mr8+qYOOLtHz8h3zQNEt
	PMhoGju
X-Received: by 2002:a53:d9d1:0:b0:64e:a3c4:aabe with SMTP id 956f58d0204a3-6504873ee85mr9904458d50.26.1775492294236;
        Mon, 06 Apr 2026 09:18:14 -0700 (PDT)
X-Received: by 2002:a53:d9d1:0:b0:64e:a3c4:aabe with SMTP id
 956f58d0204a3-6504873ee85mr9904421d50.26.1775492293619; Mon, 06 Apr 2026
 09:18:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260327014255.2058916-1-ziy@nvidia.com> <CAA1CXcCmue7iX3O9RLo7wR5EqASvJGCLraw1+iQMZ98BiMJwrA@mail.gmail.com>
 <737AA503-E522-4F01-B78E-AB6C6B2E89B0@nvidia.com>
In-Reply-To: <737AA503-E522-4F01-B78E-AB6C6B2E89B0@nvidia.com>
From: Nico Pache <npache@redhat.com>
Date: Mon, 6 Apr 2026 10:17:57 -0600
X-Gm-Features: AQROBzCfrg9zP5e6CbYyk2TsG4-q8UqeZvpk1DLrJKBq311IS7ZVoH1gcE7n3p0
Message-ID: <CAA1CXcC-vggwd-Z3h_PAfSk8U0ZvoQH-FpwhD=9XZHUnEGkcTg@mail.gmail.com>
Subject: Re: [PATCH v1 00/10] Remove READ_ONLY_THP_FOR_FS Kconfig
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NZKvAIgZx5uTfm1R9KhXJXj_cU4IdpAGPtnYyuHtxWs_1775492294
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 59A6CC000A
X-Stat-Signature: zdcwc1a61temgbfnjxijsqjyj5zfm49o
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775492297-790004
X-HE-Meta: U2FsdGVkX1938pJO06rC1QkqSs2CUxNgjp2bx+YTzhe2IJ/yEKJyZTWR6Qa7PFxPZr17rXNPZ22sVSGS5WXiTqn5UxpxP+q+VQU1/EzIXFTZaOt1q9mCb09szqUoEWzc2MpF7SPQFDGVf19GlJ4z239aaEpZYMkbeX/1rBvMpUmMDhbCG/T+rsbF3JkaTAQOo9ou2EBTldr6jOp90y6wk2PdQf+7Lq3LgrmfD+bOpqvGmpyiYvb+VGML26Azd1c8HGtt7VEZdUNxrMu4UxE1BWQ0CXKJtATOvDHAHuBwh2BSFqKlScU+1a1o4FMR490W2jet1a5O+FMfotf0sle1ilxsZhGVKrmIEewQctgqHeXg27l3JXMzqgCnRNgt6j3yNun/pG52Jw/plLeCmDxM84mlMOo5J9b8aqwLKk+P9HQAVNQfYkbzsN+wRvBtUTpvmhiZmG/fgE871mELzcYa7A1Dp0VPb4xDi3EaFMiG4yr9iXeOT8RGpMpfaYEu+z6zMOgTlSxu9v8fodwfIuws8mu8cVYwX+qenpNVtAPZBzn4eAEK+4pf74f9zcB5EqqZQFN1djr98epnToTc8P2wa23WH/7iQq96AY1n3/fo1bj9dgOTLRG9rEwED2F6fJCK3lhJ2MRBzttznjIy/1cF2lRevW9YVdThx1wT+Z1hsOX1i/5puG1LxGbRiUwRBcY22fyiSC6y5HQMFSKw+oH99v4arUrJdAmCO4S8U1MDtlayChEHWkEwwnO4dKgAa9IpqjXDr7r+RlsSki35oE+T+cEXwNeYWtYMVdzQYxps6FQnE/wAgVEwquPJPycadVLxKmkPuGyGH9bPuW/T/vHo860ML8V2EUK/80pBXeH8iiYItF2PEyhI0wGeTNapLX9WE/GH2jomluI1yIa7GAlEpphy7hHkdeYR7IAb54EtvlUCrAyNrfga2VFx5KoHoTk/tl3wx7/rKlZQLihNLNW
 jYMqwza9
 U0YHKy/jUdoiaMnrFtbCVAkDjoB7P82GDXsa5mkqkBq+J3FRhMuewH20WxwBhHwtRRi2+sOJXO2F4jGT9zlXT8oxUbJW1qRUcV8v1V1gy3N5Wghnd6ZHU70RI5cetIrbd7whJN1l53dljlbROmjDbgt6kaV+v2L0fhlLbg4sWL2/E43/eBYiybs8ZzCDk4AOzXeePqn5/4dTqP3osVmufWJ4dwJDCCqdxCJOEej2IfqIKq3NZaGHOTMjeVzY4Nr424y4GEL2I51JJZuAVow6Z28ejdRCbFBU2c51Z6Y8Mp5XVCpM1xajzqj3DZEkvzu20BlpNBflToPb/nujVuGEmt71ZdrlbDDIiGpw0arK5oixu9EYxqVMJYk6pkpPcrEXwkK36inCKvL5DZJE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 5, 2026 at 7:59=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 5 Apr 2026, at 13:38, Nico Pache wrote:
>
> > On Thu, Mar 26, 2026 at 7:43=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> Hi all,
> >>
> >> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creatin=
g
> >> read-only THPs for FSes with large folio support (the supported orders
> >> need to include PMD_ORDER) by default.
> >
> > Hi Zi,
> >
> > Thank you for tackling this :) Ill try to review the next version as
> > I'm a little behind on this thread.
>
> Sure. Thanks.
>
> >
> > Should we guard collapsing READ_ONLY_THPs with a sysctl? My fear is
> > workloads that convert READ_ONLY THPs into writable pages (assuming
> > this is common/possible; my understanding of FS is rather low),
> > leading to storms of thp splitting. Do you think this is a real
> > concern? I guess this is also true of read-only-->writable fs-THPS
> > even without khugepaged, correct?
>
> Why would a read-only THP need to be split when it becomes writable?
> After this patchset, a read-only THP can only be created on a FS that
> supports large folios (to be precise PMD THP). That means any write
> to that read-only THP would just change it to a writable THP.

Ah, okay. I was misremembering some stuff.

The concern I spotted earlier when investigating read-only THPs for
khugepaged was this:

For frequent yet short-lived writes on read-only pages (e.g., package
updates, log updates)
Wouldn't we get destructive cycles of cache invalidations and refault storm=
s?
Imagine such pages are shared (library, execs, etc) across many processes.

When these files are marked for writing we must invalidate all of
their mappings, destroying their Page Tables and PageCache. Now all
processes must refault these mappings.

Once the write is complete, they are eligible for read-only promotion again=
.

The part I didn't understand (thanks Claude) is that this truncation
path in do_dentry_open is only taken for mappings/Filesystems that do
not support large folios, as only those filesystems track
mapping->nr_thps. Furthermore, with FS that natively support large
folios, khugepaged does not need to re-collapse these pages, as even
if this was the case they would be refaulted as THPs.

TLDR: My concern is not a real concern.

Cheers,
-- Nico

>
> Let me know if I miss anything.
>
> >
> > Cheers,
> > -- Nico
> >
> >>
> >> The changes are:
> >> 1. collapse_file() from mm/khugepaged.c, instead of checking
> >>    CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order=
()
> >>    of struct address_space of the file is at least PMD_ORDER.
> >> 2. file_thp_enabled() also checks mapping_max_folio_order() instead.
> >> 3. truncate_inode_partial_folio() calls folio_split() directly instead
> >>    of the removed try_folio_split_to_order(), since large folios can
> >>    only show up on a FS with large folio support.
> >> 4. nr_thps is removed from struct address_space, since it is no longer
> >>    needed to drop all read-only THPs from a FS without large folio
> >>    support when the fd becomes writable. Its related filemap_nr_thps*(=
)
> >>    are removed too.
> >> 5. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.
> >> 6. Updated comments in various places.
> >>
> >> Changelog
> >> =3D=3D=3D
> >> From RFC[1]:
> >> 1. instead of removing READ_ONLY_THP_FOR_FS function entirely, turn it
> >>    on by default for all FSes with large folio support and the support=
ed
> >>    orders includes PMD_ORDER.
> >>
> >> Suggestions and comments are welcome.
> >>
> >> Link: https://lore.kernel.org/all/20260323190644.1714379-1-ziy@nvidia.=
com/ [1]
> >>
> >> Zi Yan (10):
> >>   mm: remove READ_ONLY_THP_FOR_FS Kconfig option
> >>   mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
> >>   mm: fs: remove filemap_nr_thps*() functions and their users
> >>   fs: remove nr_thps from struct address_space
> >>   mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
> >>   mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
> >>   mm/truncate: use folio_split() in truncate_inode_partial_folio()
> >>   fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
> >>   selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
> >>   selftests/mm: remove READ_ONLY_THP_FOR_FS from comments in
> >>     guard-regions
> >>
> >>  fs/btrfs/defrag.c                          |  3 --
> >>  fs/inode.c                                 |  3 --
> >>  fs/open.c                                  | 27 ----------------
> >>  include/linux/fs.h                         |  5 ---
> >>  include/linux/huge_mm.h                    | 25 ++-------------
> >>  include/linux/pagemap.h                    | 29 -----------------
> >>  mm/Kconfig                                 | 11 -------
> >>  mm/filemap.c                               |  1 -
> >>  mm/huge_memory.c                           | 29 ++---------------
> >>  mm/khugepaged.c                            | 36 +++++----------------=
-
> >>  mm/truncate.c                              |  8 ++---
> >>  tools/testing/selftests/mm/guard-regions.c |  9 +++---
> >>  tools/testing/selftests/mm/khugepaged.c    |  4 +--
> >>  13 files changed, 23 insertions(+), 167 deletions(-)
> >>
> >> --
> >> 2.43.0
> >>
>
>
> --
> Best Regards,
> Yan, Zi
>


