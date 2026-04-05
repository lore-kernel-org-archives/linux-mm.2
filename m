Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B312DE9D812
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 17:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DD4D6B0005; Sun,  5 Apr 2026 13:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E346B0088; Sun,  5 Apr 2026 13:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4416B0089; Sun,  5 Apr 2026 13:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C69C6B0005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 13:38:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8C53E235F
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 17:38:43 +0000 (UTC)
X-FDA: 84625212126.30.2094497
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id A522D40006
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 17:38:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZUra9IOd;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775410721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPHyJbs4uiXMxYGli4epDavO7/1nm+agc9OgX+7C8vc=;
	b=MN4Vld7MQH/XdgX8f5+nbB0+UWSZHSh86qXNxu3PfmU4f+RR52wjmjnLwDTjJgIAxIu9k4
	VFTp3hCssFIxq30JvAueUuzZaHHsxot1QTpUt274ffrslfKjaiX4eX5EXhDDLKL7DsHwi/
	w4KGz6/DJwvKcPrXg+rIkvAbDSo7d8Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZUra9IOd;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775410721; a=rsa-sha256;
	cv=none;
	b=tOEVWsaSGEuIFQXoU1e8jbNHoU4gC9OpfYkUUSOLDseyOd5saJVKd5Iz3vQZFvOZ2uYjFz
	QurCybQxfgvwqUZDTODzPCSFQgr7nnyG9OFoTw+xvNlyP0vfCbW2tcI9nA+L+Wx8CDMmwp
	PyT4Uz2xlp2O4F6NyMRbO1mpmznZ44A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775410720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jPHyJbs4uiXMxYGli4epDavO7/1nm+agc9OgX+7C8vc=;
	b=ZUra9IOddYLypSRePj+QyaRZ9Dmp+GqU4JEs5MpsbbpXQTCPMtXTELfbfmVc8R71iZZuN0
	xAFVH/U9gcMxwmrp8c9fAD6Lmru1lytU4elGVmEmrot47hN8ZFGJH8QpwZ6qyCrnPzjbJe
	eFrvSRm4Qgp2yx1Te/1cOT18BDZ/1Lc=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-DMx6t3oBO7ii_ys8qAbNAg-1; Sun, 05 Apr 2026 13:38:39 -0400
X-MC-Unique: DMx6t3oBO7ii_ys8qAbNAg-1
X-Mimecast-MFC-AGG-ID: DMx6t3oBO7ii_ys8qAbNAg_1775410719
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-79472373f48so61432527b3.3
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 10:38:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775410719; x=1776015519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jPHyJbs4uiXMxYGli4epDavO7/1nm+agc9OgX+7C8vc=;
        b=QVbqShWRNyjyn0ImqAF52hCueba/iTwpm03G2bkte9FT9YIyD/Ecx+/cVX9X2hMfGX
         msarfvdqtqm+kNgHejhYI9Ub5t0z1Xi5pNjnx6VjBMAIXUKgg4TB8m3afkVX3ZgSLBu7
         CTS7YInbL1UfCn99IxvzHvd1ZpIvzY5+6HdWnKBPYc+tM55YCAudqDrDiv9Yi7jBTe+Q
         Q0LgW0ri0VVC2wKRZYtvlHGXt7DFsxMkWhnSuN/gyfu3eJJVqARdDqgGL4nJb7o4CV0V
         zXCoLnyOmY5gkrGctNMrlqm7EcgZoBhrTLAtEruHl48y8k8WD7Fyzvk/k1leLGLrWKVM
         BLEg==
X-Forwarded-Encrypted: i=1; AJvYcCVAx7/Mw7QeB5TmdZ+q/iVwdgGN4jnMJyKQ4pnGb2RqkPwXUvD/hw74vegAmidzYTLBMeM/p906Yg==@kvack.org
X-Gm-Message-State: AOJu0YwB40ElCejBjv39ZIgzigiFqTAsazmAiEh3wwfSEP98AP70BP17
	lMzFjBtQYY8LxvEAJXKBWo1QLe3k+sNWwVP1hPPeqDQJmoExvYAcUYsGA1dcvkkjHDouvcW4Y6p
	5PFMGf6GM9+on7lWlatwyZZN9EU/icIiDv2KSQNrlltpT4TlLHGYpMOc0U1PDkX49Bj3FsGVMni
	dDb9GgvKkCyGEHAFMrUQBi9x3KVmU=
X-Gm-Gg: AeBDieuJZIYVXwVQBlLCCvEOniYTjkqgDUdyQCiQocZvkjfrqrWjfE6LSP+0Kc5gHlP
	FX9s+AAdWDRcGjJDocP1KSuzx9XVnar9hCCKhvTXbmLJWAYWfjyYORoSWkBdhprO+deGgsaEA8w
	Wa7s19BC7xO5xOuRISUYz5ZfozQDWQM1wgfMviPlk8cX9vAzzm/a1LrDm1JzNQW5tbeFLEa7h4z
	anlS/DU
X-Received: by 2002:a05:690e:1246:b0:649:c36a:a9b4 with SMTP id 956f58d0204a3-650488246b4mr9221016d50.36.1775410718603;
        Sun, 05 Apr 2026 10:38:38 -0700 (PDT)
X-Received: by 2002:a05:690e:1246:b0:649:c36a:a9b4 with SMTP id
 956f58d0204a3-650488246b4mr9220969d50.36.1775410717507; Sun, 05 Apr 2026
 10:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260327014255.2058916-1-ziy@nvidia.com>
In-Reply-To: <20260327014255.2058916-1-ziy@nvidia.com>
From: Nico Pache <npache@redhat.com>
Date: Sun, 5 Apr 2026 11:38:20 -0600
X-Gm-Features: AQROBzCPtZOBkOnc2jS1i15igfbub3Mq_1a1-pEjy-3xwa9Wl99L5UbfvWnok3w
Message-ID: <CAA1CXcCmue7iX3O9RLo7wR5EqASvJGCLraw1+iQMZ98BiMJwrA@mail.gmail.com>
Subject: Re: [PATCH v1 00/10] Remove READ_ONLY_THP_FOR_FS Kconfig
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	David Hildenbrand <david@kernel.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
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
X-Mimecast-MFC-PROC-ID: T5o3_1EHySSFflgTh_FRiV09VvkHVP2M_ChXy11ihDI_1775410719
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A522D40006
X-Stat-Signature: 8qqgbip7dchbcj3qkr6efkfhiw17u5fm
X-Rspam-User: 
X-HE-Tag: 1775410721-732518
X-HE-Meta: U2FsdGVkX18/00rxxkxCUhE2fDZpOZ/lh9saVo2QicV3dj4rqa6Nmgp5vTHPo4DGgq3f/BzDsaAzzp7i0OaSMrz1phrOsWiFbinC6a2nDgRVWRVZVDzaQGsBO0M0TrClFXF/u+GMS9kctbzpnZZDtQlBpZo9LaojwVe0iucRM+4QcV+3bzygNQqRv8dZCwWv9OfbxBa9sAtkRWvDXafLgC/KNa+2BQbL7AAYerEtuhjldpIr6pNtVDGMhj1MWY75RvZzBD5Wt8LIJjHdcqBleSNlTH3fOkCcIdw9gdd6t6wBMRqql0Kga1pOr07ju+Gs9o3NcXiZ0Ocwv2iISJ7N8RcjzEHSw9K1dpDDegeOAkTllPfiHm+PQ5Bg8Goi3siVHAF93tUgcvsX8Y73LZzR+QQ8787Wz5sURDtxHByk9XQukFzVAit59lN26aXPe7yMC0ZZtXu2eU6l3bwZJ5OfrFpPqCNLwhzyQEQrPZlbnAzObQ+8bCBf5FtMBnydol8Ga13HL6ViUEZKaN7K7UFcTWm9BgM0wvHqjQq3aZUe2I8tkdK/k+0AO70SBTs47Wph6XV16iAxn0Pn7Akb62cnmajFGI13aSEaoFwyqzAQXIgsrYzELb3JYjChYrP7rVWOLuB7IXQs0/NY4tttKvd96BhaDYVdbLDEuTthXdWAfuAUMeSJoS/Rtd6I7KSiCwEKrbVYNYT+w7qtyBdxrV5Ie7RvlZDBhjwxuDubMloyc/KtesxNvbOklLOFQG7dZ+EZPJJu/w3MwuMTO5I66F+C7SX6gmpDDIyHilGIvfuoF5LTvdQA6JAzHA0UEvF29XuGfEehClvLtxy0r1+8cSPrvAd6diXoW20iYitrZWyH+hyBfyMpohB2nKCfLyet2cC7VpcgK//DwLw77B9SGkD6BA1jYXPP98A/WorS+ZTK1HsmRCwZ3UTlyCe7oaE5ku/RjE/yrdbezZpLvmpMamo
 J/5BZDzb
 UdANwkQh6kNTjn/dd1Z1WJoKS09vlnJWi1y5gQbiiM5Yqo4BTOC+/HHjEspdhxV2E7VH7UvYDiov0LETQAjSO3xNwkavN7glau7UWBOrDpoQrmzyKJAY4bGz2LF3JQFULXCPf9soKztvRthYFc+fojUIS+OtckHO2FPVbfsgpVcfhbcwrsr6v4ujqjuI+UEi9GKnsCr2mHeq9yNe20vO96Nn0WUUlWi2hlcKPbej96bgOBG2vRB2m7hUW3pgY+xMDkG/7+hj3O6rWq2YgWIopeNnMWIvjes941n9cJarNgy67i9CwXq3+VM8VrNMFSNwp+Prq3DN+hEUmkiAHGfJvFJ+fYfUOv2jDK7BVGXYO0sVVbnjhA2ycwyseyt5mVhcIFHZ0UivUj0YGSo0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 7:43=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> Hi all,
>
> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
> read-only THPs for FSes with large folio support (the supported orders
> need to include PMD_ORDER) by default.

Hi Zi,

Thank you for tackling this :) Ill try to review the next version as
I'm a little behind on this thread.

Should we guard collapsing READ_ONLY_THPs with a sysctl? My fear is
workloads that convert READ_ONLY THPs into writable pages (assuming
this is common/possible; my understanding of FS is rather low),
leading to storms of thp splitting. Do you think this is a real
concern? I guess this is also true of read-only-->writable fs-THPS
even without khugepaged, correct?

Cheers,
-- Nico

>
> The changes are:
> 1. collapse_file() from mm/khugepaged.c, instead of checking
>    CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
>    of struct address_space of the file is at least PMD_ORDER.
> 2. file_thp_enabled() also checks mapping_max_folio_order() instead.
> 3. truncate_inode_partial_folio() calls folio_split() directly instead
>    of the removed try_folio_split_to_order(), since large folios can
>    only show up on a FS with large folio support.
> 4. nr_thps is removed from struct address_space, since it is no longer
>    needed to drop all read-only THPs from a FS without large folio
>    support when the fd becomes writable. Its related filemap_nr_thps*()
>    are removed too.
> 5. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.
> 6. Updated comments in various places.
>
> Changelog
> =3D=3D=3D
> From RFC[1]:
> 1. instead of removing READ_ONLY_THP_FOR_FS function entirely, turn it
>    on by default for all FSes with large folio support and the supported
>    orders includes PMD_ORDER.
>
> Suggestions and comments are welcome.
>
> Link: https://lore.kernel.org/all/20260323190644.1714379-1-ziy@nvidia.com=
/ [1]
>
> Zi Yan (10):
>   mm: remove READ_ONLY_THP_FOR_FS Kconfig option
>   mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
>   mm: fs: remove filemap_nr_thps*() functions and their users
>   fs: remove nr_thps from struct address_space
>   mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
>   mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
>   mm/truncate: use folio_split() in truncate_inode_partial_folio()
>   fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
>   selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
>   selftests/mm: remove READ_ONLY_THP_FOR_FS from comments in
>     guard-regions
>
>  fs/btrfs/defrag.c                          |  3 --
>  fs/inode.c                                 |  3 --
>  fs/open.c                                  | 27 ----------------
>  include/linux/fs.h                         |  5 ---
>  include/linux/huge_mm.h                    | 25 ++-------------
>  include/linux/pagemap.h                    | 29 -----------------
>  mm/Kconfig                                 | 11 -------
>  mm/filemap.c                               |  1 -
>  mm/huge_memory.c                           | 29 ++---------------
>  mm/khugepaged.c                            | 36 +++++-----------------
>  mm/truncate.c                              |  8 ++---
>  tools/testing/selftests/mm/guard-regions.c |  9 +++---
>  tools/testing/selftests/mm/khugepaged.c    |  4 +--
>  13 files changed, 23 insertions(+), 167 deletions(-)
>
> --
> 2.43.0
>


