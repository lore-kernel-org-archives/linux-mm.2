Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A24CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07F1A6B0442; Mon,  1 Jun 2026 11:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008BA6B0443; Mon,  1 Jun 2026 11:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E132A6B0444; Mon,  1 Jun 2026 11:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE2BB6B0442
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:57:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F05EA0702
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:57:05 +0000 (UTC)
X-FDA: 84831797610.03.9FB68D6
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 51C54100013
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:57:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fy3r/ZdT";
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780329423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WY4YPDieV37EdMYLsPozHBfblk0U6F7cKbbQOcc8GXs=;
	b=UCd2eDAMK6D5LClG0chbic1AjUWyBMYNRO78xN8Accn4UBqlfzxCXuGeGNajttvnAQIxGl
	F8PCGx7BCr9cXz0Rg8KPeAl4qwzswJ9aEJY/cSx8sKJ9AgxYbVhf4oX2uTPPnYIZQSzqmR
	teaARMYATnaQx9QoQA6NIZx3G3Q4DY4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780329423;
	b=gU7q//YiDVOjoX93B6ZI7xMNJFuALpH7Es3MyVtIseDBJFexvs0EWauZ1qV8xUfwHyZ6ni
	ezkU1If5E1/xzc5zs4La/X9IcMDeyF3hSt4JJj+Jt83l2NLtOGT4w7HDBaBiD348YmnkvR
	7RfA/T0iMpEvZOJ620mvxOhokpZarDM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fy3r/ZdT";
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45ef616daf6so2893112f8f.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 08:57:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780329422; cv=none;
        d=google.com; s=arc-20240605;
        b=iinKV2SvTJbRoWyZj4WOEjK8vDhn7FJn+tK1BbEzcizl9vGKkRi/AxessJT1J1M/ku
         1CJBWdd0Emdxl1VdT5kxGawk5bGQQOeNuiabC3RYjKzMyqlopJ9Zmu6g4d7uKT9G9Jtx
         y+sceMNf/rj0EBzWKH1tLAf2g+7ERMfOw9obS5uFq4b29vuWmqUUUaz/lYmE3anYknir
         zrxf9e9fFW2+bDEMN8aYWUx4lyVraetizM4RqT8dXWJevEUDFO60PGK4CKkZU6X+32V5
         dOB+hTxDyQlzXJg6VSmCmfbzPFxGZeMU3NyASKHApHiyc5j/MQeqLnpN6/McWX5e77Jm
         24HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WY4YPDieV37EdMYLsPozHBfblk0U6F7cKbbQOcc8GXs=;
        fh=ETLfDtXfBdZjI0Bwa/0bgjFH7PRhi6HnKFPqFKR3/aU=;
        b=QHbs5vGvkXp9As5tOq/QDwIeGXRSegwGZoqpQYS+2Tjr1PFy3E0+o1exRr7cRXVAlC
         nmEtEjtA2PW0t37FucTff+qcgePYgl9Qzwf0jy800JirB/pzh51zOtwf1Bo4oSKJvCPv
         pZuUhWvTVLz55bS1MBMaeHa72Dp1r4OpLcV7DsHjh8c9SzmKwv9OwRPtp/xNkD3RVwHI
         dsAVBqV59kYpyKWbxuj7PS+qCnQFxZpcwasyf0b1/pTAkcyG0buZbppshgMHdd9nb5tP
         QWq/o8ABiFE5J3BdrvCFHOyMyO+4wldHScTz1uhUzF6tLzYRZp6orBtgFIYuFxuOicZg
         VU+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780329422; x=1780934222; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WY4YPDieV37EdMYLsPozHBfblk0U6F7cKbbQOcc8GXs=;
        b=fy3r/ZdTXsJ7I8EpXvqjgGDKbXZ/vvIFlpOo9kwqfq77c/x0tw9XPWNX/mEg7R974N
         kjqd1jHcV5KCsiMAPM3EdsYTN2TJWrlEnPMSTnCC/ZPvnnUVnSnk15qIGut8bO55cA+Z
         lecQqlMX8svfrFrzMuENRGuT1v/hxcJ8sGa3efEFTxUmKDHCc+6Xwq9rdi+zoZKppYXg
         vP85NtQM6BRSPROTtToD+pwETn7j8JBwYnMA1M2CX50b9zw7wY5kl5+pybs9Va9rlOmW
         JJpKt6NfwyuxVFGT8YvCyveanxy2DgyWcnrXXrlpkPhBpjcm60GdBnTWOyax6/lPHsDW
         B2TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780329422; x=1780934222;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WY4YPDieV37EdMYLsPozHBfblk0U6F7cKbbQOcc8GXs=;
        b=dHsUa5y0cTzsQTXLhaORvhN/bEpA5lLcwaXsoQJp+8GhWIUKEiD20ClKd1DZyzqWWX
         i98/fslNIK9dF8hOYlQQtRoqP5WT+Z3L9f9IHixjXF/bfLnY1iEXU2OOth2nm1KMc5eW
         keq6faQMb6btH02ZwQ2BCjSJLqz4D5IeKByi/+y4K2vGAdh/YaRqBUJj8gksokKZEog7
         ihUnr59aT7aIpIjjfqEfRYt1o7PRlffkkY5H2y1DpAOnrbIEgC8OyAeBLdVpP3x/4+pR
         ONcnDcr0LWQeBP35v1Zgx7VS7UWo/LS/Kazt6HkUKQO1tzA1fCUV8DBHWzlBN/tAerXG
         y69Q==
X-Forwarded-Encrypted: i=1; AFNElJ9xbNNSxVrJRDyNgDH1iuh2pk1BTgnJvreyW0x2RBz+2xS9sxDHqatEh9ia3fcmt9N9jxif2gjgcg==@kvack.org
X-Gm-Message-State: AOJu0YxoLyec8zofOcsdCF5TQZCj8fatsXKGU0hVwvqhawAK7mRwWFry
	krM91mTMlHSxpjSXi5KGWfouyHukHbN+VPs5iF8vgiPFN5HcuT0Ao2yBepoWw1jletC2biKond1
	P0Uq5/BHBeP4i93bsOEMHNRnSVIz0MME=
X-Gm-Gg: Acq92OH2VPf2jcFYdrP43Xf0T31BuOVMMuswguspFLTrDFuf1vPkTJ0p54AQLNUW9YG
	Scs/lEIjR3Pcdt09CP50c3IpvtJKS9xRT7P5akAKmtg8KP89xJdMaTO30OnE7yFPYJuMXX29ZuU
	fKNaO7KfMeiSig8xoOwhfCW1JYq44iJr/G5enEJo7SbFgfwCNOyhmLmhRDSiLLOdsvJtuHRxtx2
	UpWG30I2xxOxxCGAPLJ/dMcN3O3GqZkV8koVg705VczfR54IOWWTB4UqogeQdk8sFYssYjbMI9s
	bbQaCf7wQcEK3ZdlIGeA6QhC4JR4hlyu8dhwOmdkXA523M0q+A==
X-Received: by 2002:a5d:64ed:0:b0:460:1233:ecf2 with SMTP id
 ffacd0b85a97d-4601233eee5mr6740014f8f.30.1780329421236; Mon, 01 Jun 2026
 08:57:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ahz_iYG4lqWL4g-J@KASONG-MC4>
In-Reply-To: <ahz_iYG4lqWL4g-J@KASONG-MC4>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 1 Jun 2026 08:56:49 -0700
X-Gm-Features: AVHnY4J3CWVnqj31twB-X3G7CKmr0QCOZt19FSIp451FrmL-DXJf8H_pV0_U-ho
Message-ID: <CAKEwX=PzMwXXgq=ULAkFD9UqMz+ewLqhKt+xdGxkV7OmA2QG6w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 51C54100013
X-Rspam-User: 
X-Stat-Signature: 1wxwoz95t11h8pfhq3iwjr4dorqm8n8z
X-Rspamd-Server: rspam08
X-HE-Tag: 1780329423-614844
X-HE-Meta: U2FsdGVkX19FTLGUyMbInnT059pSECBDvLUknNR5/AnUCMGVCQZyWNFiyioPP0u9qRfCDbnsxp2TMrG1ax5RYTVs26kep2rk+ZImJNUWb9jsR5HtbcrEfePQZlI5TBq+2agSg7gK2bkWiqsYlWGFB1r2KGbfKE0j77NZfjPaCUL8qAQjjZEOr/wU4li/rRnil8pfAEViGxHV9hfQtKxFB/pdUOydJjlmrZDNRWB3cv6TCKoWVETZhDTgsQo5aN1aS9bQa/bRsfBZurkrEgeu+tTws/IYWzBy21qB2sZejw3KbAFJ0G0Xn78RHq7pj3LleDJey+ENI7vNzze3djxvW+HemT9eXQxdEV+ljf9Rz9HaDktJ6YnbqdR4W/TyMRvbwOa4Gy7veY+PAjuQwWz1f/eol11KyZON0/mBiudj0nsTx1etqYX8COvPl9RaEyHRIwFRvFUSjPlAH8/jBeH5nQD/WvaoMOJBnhCwFl32C9fWX37nVfBLLJ1YWcdxTkNqXV73zM8gPaNOyPZ7k+rfsBXO5q1wxiE3ihGHXQBmERfistmS3QH2KrUo2vY5qwa+JkPLk0xjpVKJVdAC3ZJFg/JnRfDnYl+9mLD3mGCzya4cgkjbPKnH9cb6tCdFQapwmUZauC642GgH02ho6FQxuYbBiqOfuqwG3/4CMM6C93vzcGnNh0CcR/M8BgIQ5+OmS0bcoK+jXgS0zX2IRXFppc3pFsvKlvZqeQq7u8i03+Q64Iros2PjUmMJOJ17B7DiyEKo5JYoXogghMhEKpfJiTKtEPSdc/Pp7FE/uajtgOkgTmfJ5p3MI5VUeGAbPyMiAJ0qG6VzMXG1fAR0UixhkJ1RQEVaaCtoRu/uktSx+w+VvyGMOFeEiSRglFFMHqTRBrHFGfwSArp2+OPiZG3Pt1AFvilrqshR54jD12IViI91wPDfznqPE2WCASebcL9dTGTbZpTy1I2gESFUpa6
 l9Sq5ITe
 VWPEqG7TLvaNPCv8FM2sAsZFRP+MQs+AeRevIz2aXj9Rjizg9pHPiJYtCWqX7hCrFlutDF0WahBYZG1ge6CD5YS1jSBIR+c6jGsapb5xTeaxsPuzmpwyX+sXXIfCT/g+xhaHAwO2HkOy8dmL8oGRERjL47Kw718b+je/gTn/1tXnX/QcO471+cLg5WZW1P8bLDMuaTciZwZcXb3Jb5ibePaG48ABlP2/J4TmLSMmXcRB1xbv9XGFVlAUpGQV9E98n+0pirjBeTcyAj81IY3tLQjDj5m+x/nF6zo8cWhq5tx+m7dx9bbnMWqput/KTybcYpGSuquB9n5ZnDnfkcpoRMSIO44hix40nqiHhDWPnI3KSztSs1qJ6Qp4VlnbVmOMHRZT5LJUDmqzE55C2PFgr2z7od9LGVwsINF8n17F5IR/hMcGvi3HanTxdQQI8kiqRfbVLtOLcPhBjBwXeJSZzn5tzj/cSsVpUha7E8oOZb9uBnLtDS+1lEkmtAD/kolI5hX21
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 12:34=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Thu, May 28, 2026 at 02:29:24PM +0800, Nhat Pham wrote:
> > Based on: mm-unstable @ 444fc9435e57 + swap-table phase IV v5 [2].
> >
> > I manually adapted Kairui's ghost device implementation (from [4])
> > for my vswap device. I've credited him as Co-developed-by on Patch I
> > since a substantial portion of the dynamic-cluster infrastructure is
> > his (I did propose the idea of using xarray/radix tree for dynamic
> > swap clusters allocation and management though :P).
> >
> > >From here on out, for simplicity, I will refer to swap table phase IV
> > as "P4", and the older v6 virtual swap space implementation as "v6".
> >
>
> ...
>
> >
> > This series reimplements the virtual swap space concept (see [1])
> > on top of Kairui Song's swap table infrastructure, on top of [2]
> > and in accordance with his proposal in [3]. The proposal's idea
> > is interesting, so I decided to give it a shot myself. I'm still not
> > 100% sure that this is bug-proof, but hey, it compiles, and has
> > not crashed in my simple stress testing :)
> >
> > The prototype here is feature-complete relative to the swap-table P4
> > baseline =E2=80=94 swapout, swapin, freeing, swapoff, zswap writeback, =
zswap
> > shrinker, memcg charging, and THP swapin all work for
> > both vswap and direct-physical entries =E2=80=94 and satisfies all thre=
e
> > requirements above: no backend coupling (zswap/zero entries hold no
> > physical slot), dynamic swap space (clusters allocated on demand via
> > xarray, no static provisioning), and efficient backend transfer
> > (in-place vtable updates, no PTE/rmap walking).
> >
> > II. Design
> >
> > With vswap, pages are assigned virtual swap entries on a ghost device
> > with no backing storage. These entries are backed by zswap, zero pages,
> > or (lazily) physical swap slots. Physical backing is allocated only
> > when needed =E2=80=94 on zswap writeback or reclaim writeout, after the=
 rmap
> > step.
> >
> > Compared to the standalone v6 implementation [1], which introduces a
> > 24-byte per-entry swap descriptor and its own cluster allocator, this
> > edition uses swap_table infrastructure, and share a lot of the allocato=
r
> > logic. Per-slot metadata is stored in a tag-encoded virtual_table
> > (atomic_long_t, 8 bytes per slot), and physical clusters store
> > Pointer-tagged rmap entries in the swap_table for reverse lookup back t=
o
> > the virtual cluster.
> >
> > Here are some data layout diagrams:
> >
> >   Case 1: vswap entry (virtualized)
> >
> >   PTE                  swap_cluster_info_dynamic
> >   vswap_entry          +-------------------------+
> >   (swp_entry_t) ------>| swap_cluster_info (ci)  |
> >                        | +--------------------+  |
> >                        | | swap_table         |  |
> >                        | |   PFN / Shadow     |  |
> >                        | | memcg_table        |  |
> >                        | | count,flags,order  |  |
> >                        | | lock, list         |  |
> >                        | +--------------------+  |
> >                        |                         |
> >                        | virtual_table           |
> >                        | +--------------------+  |
> >                        | | NONE               |  |
> >                        | | PHYS               |  |
> >                        | | ZERO               |  |
> >                        | | ZSWAP(entry*)      |  |
> >                        | | FOLIO(folio*)      |  |
> >                        | +--------------------+  |
> >                        +-------------------------+
> >                               |
> >                               | PHYS resolves to
> >                               v
> >                        PHYSICAL CLUSTER (swap_cluster_info)
> >                        +--------------------------+
> >                        | swap_table per-slot:     |
> >                        |   NULL   - free          |
> >                        |   PFN    - cached folio  |
> >                        |   Shadow - swapped out   |
> >                        |   Pointer- vswap rmap    |
> >                        |   Bad    - unusable      |
> >                        |                          |
> >                        | Vswap-backing slot:      |
> >                        |   Pointer(C|swp_entry_t) |
> >                        |     rmap back to vswap   |
> >                        +--------------------------+
> >
> >   Case 2: direct-mapped physical entry (no vswap)
> >
> >   PTE                  PHYSICAL CLUSTER (swap_cluster_info)
> >   phys_entry           +--------------------------+
> >   (swp_entry_t) ------>| swap_table per-slot:     |
> >                        |   NULL   - free          |
> >                        |   PFN    - cached folio  |
> >                        |   Shadow - swapped out   |
> >                        |   Bad    - unusable      |
> >                        +--------------------------+
> >
> > struct swap_cluster_info_dynamic {
> >     struct swap_cluster_info ci;       /* swap_table, lock, etc. */
> >     unsigned int index;                /* position in xarray */
> >     struct rcu_head rcu;               /* kfree_rcu deferred free */
> >     atomic_long_t *virtual_table;      /* backend info, 8 B/slot */
> > };
> >
> > Each vswap cluster (swap_cluster_info_dynamic) extends the classic
> > swap_cluster_info struct with a virtual_table array that stores the
> > backend information for each virtual swap entry in the cluster. Each
> > entry is tag-encoded in the low 3 bits to indicate backend types:
> >
> >   NONE:   |----- 0000 ------|000|  free / unbacked
> >   PHYS:   |-- (type:5,off:N)|001|  on a physical swapfile (shifted)
> >   ZERO:   |----- 0000 ------|010|  zero-filled page
> >   ZSWAP:  |--- zswap_entry* |011|  compressed in zswap
> >   FOLIO:  |--- folio* ------|100|  in-memory folio
>
> Thanks for trying this approach!

Thanks for the suggestions. I hope going forward we have sth concrete
to tinker with, rather than abstractions :P

>
> For the format part, PHYS don't need that much bits I think,
> so by slightly adjust the format vswap device could be share
> mostly the same format with ordinary device.
>
> For example typical modern system don't have a address space larger
> than 52 bit. (Even with full 64 bits used for addressing, shift it
> by 12 we get 52). Plus 5 for type, you get 57, so you can have a
> marker that should work as long as it shorter than 1000000 for PHYS,
> and shared for all table format since it's not in conflict with
> anything. You have also use a few extra bits so a single swap space
> can be 8 times larger than RAM space, and since we can help
> multiple swap type I think that should be far than enough?
>
> Then you have Shadow back at 001, and zero bit in shadow. The only
> special one is Zswap, which will be 100 now, and that's exactly the
> reserved pointer format in current swap table format, on seeing
> si->flags & VSWAP && is_pointer(swp_tb) you know that's zswap :)

Are you suggesting we merge the virtual table with main swap table?

Man, I'd love to do this. There is a problem though - we have a case
where we occupy both backing physical swap AND swap cache. Do you
think we can fit both the physical swap slot handle and the swap cache
PFN into the same slot in virtual table? Maybe with some expanding...?

Another option is we can be a bit smart about it - if a virtual swap
entry is in swap cache AND occupies physical swap slot, then put the
folio at the physical swap's table, use folio->swap as the rmap.

(I think you recommend this approach somewhere but for the life of me
I can't find the reference - apologies if I'm putting words into your
mouth :))

But this is a bit more complicated - extra care is needed for rmap
handling at the physical swap layer, and swap cache handling at the
virtual swap layer. Maybe a follow-up? :)

>
> Folio / PFN can still be 010 as in the current swap table format.
>
> Then everything seems clean and aligned, no more special handling
> for vswap needed, there are detailed to sort out, but it should work.
>
> > - Pointer-tagged swap_table on physical clusters for rmap (physical
> >   -> virtual) lookup.
>
> Or reuse the PHYS format (rename it maybe) since point back to vswap
> is also pointing to a si.

Noted. I'm just doing the simplest thing right now - working
prototype. I mean, we have enough bits :)

>
> > III. Follow-ups:
> >
> > In no particular order (and most of which can be done as follow-up
> > patch series rather than shoving everything in the initial landing):
> >
> > - More thorough stress testing is very much needed.
> >
> > - Performance benchmarks to make sure I don't accidentally regress
> >   the vswap-less case, and that the vswap's case performance is
> >   good. I suspect I will have to port a lot of the
> >   optimizations I implemented in v6 over here - some of the
> >   inefficiencies are inherent in any swap virtualization, and
> >   would require the same fix (for e.g the MRU cluster caching
> >   for faster cluster lookup - see [8] and [9]).
>
> This could be imporved by per-si percpu cluster. Both YoungJun's
> tiering and Baoquan's previous swap ops mentioned this is needed,
> and now vswap also need that. If the vswap is also a si, then it will
> make use of this too.

Yeah I made the same recommendation when I review swap tier last week:

https://lore.kernel.org/all/CAKEwX=3DN2XcMHN1jatppOk6wnmz-Shab5XMtTtzgYOzRv=
U_6YFw@mail.gmail.com/

I like it, but yeah it will be complicated. That said, I think not
fixing the fast path for tiering/vswap will seriously restrict their
usefulness. We don't want to go back to the old swap allocator days :)

We can also revive the swap slot cache, but why do it if we can
repurpose your proven design, and just extend it a bit for multiple
tiers/swap devices? :)

>
> YoungJun posted this a few month before:
> https://lore.kernel.org/linux-mm/20260131125454.3187546-5-youngjun.park@l=
ge.com/
>
> The concern is that some locking contention could be heavier, or maybe
> that's just a hypothetical problem though.

I don't think it's hypothetical. At least with vswap, it's very easy
to get into a state where the shared per-cpu cache gets invalidated
constantly if phys swap and vswap allocation alternates (which is
actually very possible under heavy memory pressure), hammering the
slow paths...

>
> >
> > - Runtime enable/disable of the vswap device. To be honest, I don't
> >   know if there is a value in this. My preference is vswap can be
> >   optimized to the point that any overhead is negligible. Failing that,
> >   maybe we can come up with some simple heuristics that automatically
> >   decides for users?
> >
> >   In this RFC, CONFIG_VSWAP=3Dy means the vswap device is always create=
d at
> >   boot, and CONFIG_VSWAP=3Dn means the vswap device is never created. T=
his
> >   *might* be enough just on its own.
> >
> >   Is a runtime knob (sysfs or sysctl) worth the complexity beyond
> >   these heuristics? I'm not sure yet. Maintaining both cases
>
> I checked the code and I think it's not hard to do, patch 1 already
> handling the meta data dynamically, everything will still just work
> even if you remove vswap at runtime. The rest of patches need adaption
> but might not end up being complex, it other comments here
> are considered.

Yeah, it's not terribily hard to do. I'm more wondering if it's worth
the effort, both for the implementer and the user :)

As I said here, if we want vswap, just enable it at boot time and get
a vast (but dynamic) device. We can make it optional per-cgroup
through Youngjun's interface, and that would be good enough?

>
> For patch 2, a few routines like vswap_can_swapin_thp seems not
> needed or should be moved to __swap_cache_alloc? VSWAP_FOLIO is
> same as swap cache folio check, which is already covered. Same for
> zero checking, and VSWAP_NONE which is same as swap count check
> I think. That way we not only save a lot of code, we also no
> longer need to treat vswap specially.

Unfortunately, I think a lot of this complexity is still needed. Vswap
adds a new layer, which means new complications :)

For instance, I think you still need vswap_can_swapin_thp. It
basically enforces that the backend must be something
swap_read_folio() can handle. That means:

1. No zswap.

2. No mixed backend.

3. If it's phys swap, it must be contiguous in the same device.

The vswap entries might look contiguous in the virtual address space,
but completely unsuitable for the backend.... This is a new
complication that does not previously exist for non-virtualized swap,
so it needs more code to handle it...

I use vswap_can_swapin_thp() in two places - first when we try to find
a candidate range of PTEs for swap in (swap_pte_batch). And then
double check after we've added into swap cache, as the backend can
change arbitrarily before swap cache folio is locked.

Similar for some of the other helpers. For instance,
vswap_swapfile_backed() is needed in certain optimizations or for
correctness's sake, etc.

The VSWAP_FOLIO is redundant, I agree. It's just for convenient. It
represents the state of vswap where it's still in swap (swap cache),
but only backed by the swap cache folio, and not any other backends.
Technically, you can represent it with VSWAP_NONE + a check in the
swap cache field to see if there is a folio there.

If it's not too much code in v2 I can try to remove it (while leaving
behind a comment explains the state).

>
> If you keep the format compatible with what we already have
> as the earlier comment mentions, a large portion of this part
> might be unneeded.
>
> >   at runtime also has overhead for checking as well, and some of the
> >   checks are not cheap :)
>
> I also noticed the new introduced swap_read_folio_phys in patch 3, so
> this actually can be done using Baoquan's swapops idea which is now
> part of Christoph's swap batching:

I'm actually trying to have swap_read_folio() work for both vswap and
phys swpa just with a biiit of if-else. But yeah this might be cleaner
:)

>
> https://lore.kernel.org/linux-mm/20260528124559.2566481-9-hch@lst.de/#r
>
> That series is focusing on batching and better performance but swapops
> was also proposed as a way to solve the virtual layer, makes it possible
> to have vswap as one kind of swapops which is Chris talked a lot about:
>
> https://lore.kernel.org/linux-mm/aZiFvzlBJiYBUDre@MiWiFi-R3L-srv/
>
> Following this, we could have something like:
>
> const struct swap_ops swap_vswap_ops =3D {
>         .submit_write           =3D swap_vswap_submit_write,
>         .submit_read            =3D swap_vswap_submit_read,
> };
>
> The move the folio_realloc_swap in swap_vswap_submit_write.
>
> Merge of IO might be moved to lower phyiscal level for vswap.
>
> Another gain is that the memory usage and CPU overhead will be
> lower with only one layer. As I'm recently trying to offload swap
> dataplane off CPU so the CPU won't touch the data at all, the
> overhead will be purely by swap itself, plus some mm overhead.
> Things like that and IO optimization above and could make swap
> subsystem more and more performance sensitive so we have cases
> that needs only one layer.

Yeah I can take a look at this. This prototype purely based on your P4
and with just a bit of hackery to transfer my v6 implementation over.
Not very clean - just a PoC. If everyone is happy I can put more time
in :)

>
> >
> > - Defer per-cluster memcg_table and zeromap allocation on physical
> >   clusters. A physical swap cluster backing vswap entries only do
> >   not really need their memcg_table, but the current design forces
> >   us to allocate it anyway. This is a waste of memory, and is an
> >   overhead regression compared to my older design on the zswap-only
> >   case, which Johannes has pointed out multiple times (see [6]),
> >   and is one of the biggest reasons why I have not been satisfied
> >   with this approach thus far. It honestly is a bit of a
> >   deal-breaker...
> >
> >   That said, I think I might be able to allocate them on demand, i.e
> >   only when the first direct-mapped slot is allocated on that cluster.
> >   That will give us the best of BOTH worlds, for both the vswap and
> >   directly-mapped physical swap cases. No promises, but I will try
> >   (if this approach is good enough for all parties).
>
> Zero map is not really a problem when it's just a inlined bit I think.

Yeah no problemo indeed. I saw a zeromap field in struct phys swap
cluster, so I put this in the plan as "to remove later", but I just
took a look and realized it's only for cases where you cant fit the
bit in swap table. I'm gating vswap for 64 bit for now, so should not
be a problem.

> For memcg table allocation, on demand seems a good idea, and actually
> we are not far from there, I tried to generalize the
> alloc-then-retry-sleep-alloc in swap_alloc_table but still not generic
> enough I guess.. Good new is the allocation of the table is already
> kind of ondemand, just need to split the detection of these two kind
> of table.

I have a prototype of this, but I have not tested, so I do not want to
send it out. :)

TLDR is - I still want to record the memcg for vswap (just not charge
it towards the counter). So we still need memcg_table at both level,
generally - just not allocating until needed (basically if a physical
swap slot in the cluster is directly mapped into PTE). You can kinda
tell, since you pass the folio into the allocation path - with some
care you can distinguish between:

1. Virtual swap, or directly maped physical swap -> need memcg_table

2. Physical swap, backing vswap -> does not memcg_table.

Another alternative is you can defer this allocation until the point
where you have to do the charging action. But then you have to be
careful with failure handling, and need to backoff ya di da di da.
Funsies.

I think I did a mixed of these 2 strategies. Anyway, I'll include the
patch in v2 (if folks like this approach).

>
> Mean while I also remember we once discussed about splitting the
> accounting for vswap / physical swap? If we went that approach we
> don't need to treat memcg_table specially.

For the charging behavior, I already have a patch for it actually in
this series (just not the dynamic allocation of the memcg_table field
yet).

Basically:

1. For vswap entry, not backed by phys swap: record swap memcg, hold
reference to pin the memcg, but not charging towards swap.current.

2. For phys swap backing vswap: charging towards swap.current, but
does not record the memcg in its memcg_table, nor does it hold
reference to memcg (its vswap entry holds the reference already)

2. For phys swap directly mapped to PTE: charges, records, and holds refere=
nce.

The motivation here is I do not want vswap entry to shares the same
limit as phys swap counter. If we think of it as "infinite" or
"dynamic", it should not be capped at all, but even if it is charged,
it should be something separate.

>
> > - Widen swap_info_struct->max to unsigned long. The vswap device's
> >   max is currently clamped to ALIGN_DOWN(UINT_MAX, SWAPFILE_CLUSTER)
> >   (~16 TiB) to fit in unsigned int. 16 TiB is small for vswap,
> >   especially when we're getting increasingly big machines memory-wise.
>
> This should be very easy to do, just replace unsigned int with
> unsigned long, a lot of place to touch though :)

Agree. I'm just lazy, and this sounds like a simple patch as a
follow-up. This RFC is already 2000 LoCs - I do not want to burden
reviewers with extra useless details :)

