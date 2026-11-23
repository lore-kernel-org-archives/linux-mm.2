Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1216E606A681
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 01:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ys1yFoMi
Received: by kanga.kvack.org (Postfix)
	id 14BCC6B05B3; Sun, 22 Nov 2026 20:14:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1237A6B05B4; Sun, 22 Nov 2026 20:14:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060D36B05B5; Sun, 22 Nov 2026 20:14:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C75806B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:14:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 37A891C41A0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:14:23 +0000 (UTC)
X-FDA: 85464613206.25.CF8AA64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5222CC0003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:14:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ys1yFoMi;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795396461;
	b=IEtRCNPc0E2nygrbxeg1rx57MS4sezA8MtgvSMlTjKi0XAReKJPAf5T7kAgBTMzyPN4pxM
	r1WCnn4mU0xMWPukqJyKpkL5kqP5VW2O1mJU7tjufqakURNQygPExPMDxNosnpxY0upgjZ
	G3e/imraJ1upxIDFpH6StwBTNuSSXRw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795396461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=beRsURI87z7ePC5UgnVhljfRVtiAk+JGSK5Yp7RQ++w=;
	b=k+6Vjr6A2KKlanwpXjsIN5iBGLnrIGjn4L6Xel53yYe0GTeP8DNukJLyZmA6GDPTMFOkQv
	crLm10Uk7BMMRva1KlF8/FwPZTA7gyh4jmGQrdzUySlKT/wxhtoT0fA0HMVKPOwe/Ko0qk
	XlLFZsbSFQw/5vSuPQ1YH3OE44d7Pfs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ys1yFoMi;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FA7944ED5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F391F000D2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795396460;
	bh=beRsURI87z7ePC5UgnVhljfRVtiAk+JGSK5Yp7RQ++w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ys1yFoMi3EImki+984yKCe81INtZaQHTXOXdANgrHv9/I07zvlyD2nTpoYX/tGYqd
	 yc6+SySpdaII+pw8XgsrTCpM3A66tynOC/z8F1MdwNB3kNHswhMNS41AJQhEFJWboD
	 kiNSWkHXDArtd5kB8OIQ2CkeuPtd6BJI9R6GnvHBzCI9uDnu81zIxw13OUZ/mEDBWs
	 ZuCk07qi0/QolXdTFeDPWAVBeP5vGK4IVAd16QuexIaRJjVoKX9uD5yUHroorHerxs
	 ih8ab7EmuB5sbtxCgrx7uzM8MHnDn47aasBHwVh/E9KhwdGLxIAV2dlKcpxcdV+/9F
	 FjfZHMSnH4gMw==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93f20c3aaa5so261639385a.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:14:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHYZFNC374dQKf7+iUI2r+VXzsPZAITWQmyPJaaE9sXAwCKeki851NQwXmaAbrO2N1Cck8KlitRxw==@kvack.org
X-Gm-Message-State: APuU4Z8N99yyJmZtTSWZV29CLe8vhznEdlW6APnyokn7c0crWJS1vOrT
	HQkjejjjREkVfN9Sm/a/08JqGd4DySOVpyObBWu6kvk1TCi5mq1T13PLd6BXRG1FMJ6urlxnVKI
	ZaYVSINelsU7IOLgb0OqZZ4zXKWulq74=
X-Received: by 2002:a05:620a:450e:b0:949:5c62:e785 with SMTP id
 af79cd13be357-949ba9b7429mr1776786785a.21.1795396459175; Sun, 22 Nov 2026
 17:14:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122-migrate_reclaim_deadlock-v1-0-83c56185b0fb@kernel.org>
 <20261122-migrate_reclaim_deadlock-v1-1-83c56185b0fb@kernel.org> <179537313704.412063.6683001223228002260.b4-reply@b4>
In-Reply-To: <179537313704.412063.6683001223228002260.b4-reply@b4>
From: Barry Song <baohua@kernel.org>
Date: Mon, 23 Nov 2026 09:14:06 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yEeORJw8dQEH0U-JjWih3+3ZVx=1Va5F_9qsVbPzCLvQ@mail.gmail.com>
X-Gm-Features: Aa3M54qG1iauJEScw2ktzAtei45vPodUuwGuthkS3X5FKVC_OPLT-7KU2cnzR8g
Message-ID: <CAGsJ_4yEeORJw8dQEH0U-JjWih3+3ZVx=1Va5F_9qsVbPzCLvQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/huge_memory: use NOFS when allocating while
 splitting folios
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, 
	Chris Mason <mason@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Queue-Id: 5222CC0003
X-Stat-Signature: 8xtquptaparijsisectaj8e5b3joqzgq
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795396461-714411
X-HE-Meta: U2FsdGVkX18cMMYHi+wIpg4yo6/i7giPQ+bSm8kwbtmCep9Ebc/ptjRWJlWMkteuk/Vyn4wQKW+mHin4rPpxP01vXFkV6pypikV3Pq0Ts90IpG/T9kLHl6Lvd7Ldt3JryNrqjkze0qPQG46Ed706WoxjZuzZkOMevQRvGiGPqnpeCRi9Y4APv2NMv9imV7/5FtC5k2MACt3FwQ264Oxe7W8ygVQ+iissG2bC9AWBujZm1pi15ZfkuxJmgvK2o1RoHhrGvgv8B8VqOQtnnkvSeqUiCz6Gssdhr4rOmSlYWb8LnKWSurFrIgYiuGlDiWEk+UVMFl3xvWX0Lk+bgj6V+RgfoEO8TX0Cfky4gsu0H/u3CBSVUyYKeJgPjWP1bnd664MPwS2Qr0/R6Xfv1CbVojs7IZX+/fNXQZige36Q5fpN3T+BZj9U/RMTduDpsNzQwPbuGARnh2JI+U9TgHXme9BsgqY9gPtctPB8iqT78AQlsA9t8Iu+NBHnyV8y52D9H6KurKb+UKVEa0JPCJEg2XlfWSiqSU4PQO5qkEaIofNz4AqozlrjbeUnDaIbXjpio9w4In8pjHxqM4ObiPWmt8LzTYuGZWIcfPG+/7l1jaXQpO3lJMQP0Msf+I1vyJGFbVDCVlwd3Vxa+BfMFvJOIFkgwIbqC7yD+MghpSVy9omDOgIpv4/XNWJKuRtanLXLxmpk3VZQgg1nKWUvUeNRD97aJ/EHnaKsK/fPyQFCicj45YCBJcGvFRABT9ovlvdv61JtMQmvarGIK4r+agagnYC815WYlhnc/Uu18y0BZzk3A75YNE6exRoA9ZiPaXiFlzID95H8wRHVBgDePdClgrjdghZuPrAdsdkxTxfs+T2u+g9QC1d5OFsa5n9Va7ueZpQhsLXmoQWUTN4hpkgPzswup44vTZzX6dVMtJJbOrW66Fj33xhz6ub63GnBv2wOLJdnrSdEDYIjbfDOb9B
 AL6tMpI+
 92y4sgP9miiSYnTtcLB5ijAX3TbtFBbanUTLFms/eY6iNf/a8nj0rcvRn5Y31yuwWCOzuQZWjG84N35d20rzLRjEa3qvibOo+ULlSH8se0DwB1y3ZYdv8kWTl7oiywXuwN/NAZK1ocJy/i7CBq1rUA6hldtlM2j2OFDKiQFp3l/jdTXsxnXHj1YZ6FqzEyclVsPuZSNnpEwsjWo/iXSlEsHqfTKwjyboWMBOUaax9Q2jMU0bz6c+RQCht7ahz2w1gkK88tqC08kvvO3Nv9O9yk+aimOo1TwZnKLr0tVnkWXWjgbU3jHtsZ4HLrrTOc7FsUdi41e/qVwl8eD1yloifGkF7UKY807JlfLhtP8XHlRv89ZplIlOo7fodlYvHSP5WNQD67a3Ll192zrl57yzWdA1DddVrGzENDumxYB4ap/rLNB/QgpkfeXMmU+axdQnOWDT057DWlJKoo55wNnwExRRVNoRTxIcT2atssQkeBtzg54SgxoYIj2r8hMnSvc5qPypBWDoeF+IPIQf2sRaD4x8Ji5Cd0e7mcaWjcaYI0JdhRMoLjD2C886BHEYZ4mbKQKPusopXEhE5VNZV6Hl8kXjQxdWb6jhJD50YnA9+OmAa2fFIIcUVCjrojH2CwfhyeYLMbcL3TGULzp5iq+GLHk1T9qzT649eqbFzod271hKfFJXsn93yR0y1ZIMH8vzr7T88rTUDNMusidJXYKgVO/bIuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 2:46=E2=80=AFAM Gregory Price (Meta) <gourry@gourry=
.net> wrote:
>
> On 2026-11-22 13:42 +0100, David Hildenbrand (Arm) wrote:
> > Various callers (migration, memory-failure, s390_wiggle_split_folio) sp=
lit
> > locked folios without holding a reference on the folio's inode.
> >
> > Splitting a file folio might allocate memory for the xarray and call
> > filemap_release_folio(). If either ends up in direct reclaim with
> > __GFP_FS, reclaim can evict the inode through the dcache shrinker, and
> > wait in truncate_inode_pages_final() for the folio that we hold locked:
> >
> >     try_split_folio()
> >       folio_lock(A)
> >       split_folio_to_list(A)
> >         xas_split_alloc()
> >           try_to_free_pages()
> >             super_cache_scan()
> >               prune_dcache_sb()
> >                 iput_final()
> >                   evict()
> >                     truncate_inode_pages_final()
> >                       folio_lock(A)
> >
> > This requires that nothing else holds a reference on the inode, and can
> > be triggered most easily with FUSE, which evicts inodes on the last
> > reference.
> >
> > Further, xas_split_alloc() charges the XArray nodes to the memcg, and o=
n
> > cgroup v1, memcg reclaim waits for file folios under writeback if
> > __GFP_FS is set. That can deadlock if writeback waits for a folio lock
> > that we hold, for example with ext4.
> >
> > Let's fix it by splitting folios in a NOFS scope, so callers don't have
> > to care. A NOFS scope also covers allocations that filesystems make wit=
h
> > their own gfp flags, for example in filemap_release_folio().
> >
> > On NFS, splitting folios with pending writes or ongoing writes to
> > fscache might now fail slightly more often, until these writes have
> > completed. On netfs, only folios that are being written to fscache are
> > affected. All fairly irrelevant.
> >
> > This has medium urgency.
> >
> > Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
> > Fixes: eef88fe45ac9 ("s390/uv: Split large folios in gmap_make_secure()=
")
> > Fixes: 789763523fb4 ("xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc=
()")
> > Cc: stable@vger.kernel.org
> > Reported-by: Chris Mason <mason@kernel.org>
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>
> Reproduced the hang determnistically.
> Base deadlocked.
> With patch 1: -ENOMEM (safe)

Hi Gregory,

Just curious how those -ENOMEM failures occur. With GFP_NOFS, we
should still be able to reclaim anonymous folios (except in
SWAP_OPS_F_REQUIRE_NOFS cases) and clean page cache folios, right?


> With patch 2: split succeeds
>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>

+1 for the patch itself.

Reviewed-by: Barry Song <baohua@kernel.org>

Thanks,
Barry

