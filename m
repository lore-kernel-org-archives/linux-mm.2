Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6B7FCD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 17:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC0E6B00B3; Wed,  3 Jun 2026 13:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C9C6B00B5; Wed,  3 Jun 2026 13:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35636B00B6; Wed,  3 Jun 2026 13:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B93B36B00B3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:13:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49837C0A3E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:13:04 +0000 (UTC)
X-FDA: 84839246688.12.DC3A15B
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 30F944000B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:13:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NgybOYNA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780506782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrFjxyk0Z/o0MfnkVA2E8r+AuJihHpuU5moBK75MRoU=;
	b=5mNnVWayfn1At2ZJ5QVpM/BYav36O39xDX3HYrDW6F6yfo6KhpI4pgMWCz3g92zQJy9lDT
	zYGrachhthwn1Sf0yXG198iAodHvpalehos+Jo0z/0EM7AxBqo20MUY+6A6CPM6oImoOn4
	NYfwHUEfIYhv8d52kXj5XBA9atV5giQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NgybOYNA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780506782;
	b=HeqwkykQouilbrg3q1fBJlnfiFfHyUOcSVBmsrOa5ioSrmlFRixkTU8gprrv6vT2NybQQU
	Kdt6LJWOlxfsMV3fhHDKrc96MKdHzhKd8B3Lx9Uvd34yP7pp17eEJUhajiwxFGNFotqJfY
	FcjQSf9WRVkP1OtboAZx4pSaEQq5n7k=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490b4e1ade7so15223485e9.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 10:13:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780506780; cv=none;
        d=google.com; s=arc-20240605;
        b=Zo6jwd/tLmnVM6UPfaZ6NlmF/keG1I2r+l7Leb5jy6Bu3UcBU79uv9o072Hz0RID55
         oASLZzue/utvRWnqrMEKYX7oR30CuX2JC2k9mzj3RsmxMSg93+HuJ4BeqGq3m+22ZRE/
         pPSykhkmZjc+RcrTfjviKBTxCgideQAY3TyAA+JIt89XTWVPmIW7S0U7lkOUOqFHRDCn
         Pfx2b0QckW+ZzmezyUrRhE4zlTCxafAFvgOqD0fQqFsIYbWX+dQqPtHy2+1MoZwrgmL+
         KUnjOU2Au5zbKsOTK7Zg2Zsgd+xNXVARKbVJzo9RYHS5iYrdV/OZx0g4iPzcjCHTKs3A
         hAkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BrFjxyk0Z/o0MfnkVA2E8r+AuJihHpuU5moBK75MRoU=;
        fh=Gg9d4VXPYb3rvzC/8N+pi8tnU9WhVqsN1dkv0gAfe5A=;
        b=irOI8nlDvgrqJFZcvRTnP8cQpA4Czqan9KUEubo9IP3H/G8O+ddCSzHb1z0yrRuTcl
         t5VHzErUxAmpJgpDjWVtANbtligsEVzRMr8tyoUwq2Td8B/xqKocrCDR3e3eqrCBwQsO
         4bEmyhbTit23dtfHPurn9ypeEYnebsz7w8rRjdFsR5NGA5YFFrL4dgDkH2NvjkhY+oGr
         tklH9XdYq5PB/ETWWEpW0FEdOqyU+QQmqmnimljhDGxxeNLGP8CxMj0VA3e3n/fvDcj5
         3d+3GGaZC4MzZk4BydPGpq6idyuD07HVzkYI2ZAKant4J9YqBiJGvzNLrcIX1mJitbcd
         0ZLg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780506780; x=1781111580; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrFjxyk0Z/o0MfnkVA2E8r+AuJihHpuU5moBK75MRoU=;
        b=NgybOYNANGZ66WDYuus0e3Gsx2dHp6aIRCFPH8K74tpj49sqYmgZrNj8w2ISZ92qgu
         XrWWjd0TFI7y5XzwZdBIHU02IJKykCIGvQ0I2XqQnmqIhe547F3LlWALsFhh5w9uh6uk
         aXeXho64O5m/Lv9zvu572g95dXm+Fr4k+d39bGj6qGU/ZYY83qpnhn1mE8rNLUy0tbuJ
         nC0PnYsXxJg5BR2fCeLeSRJ/FPRUSurCbX5Br6ZANjG72MY9DpgHdccBffm4jo9rEPGu
         2pVy3sTaPSLI8R8Hop0mhMp+C9fydrc7/maszt+YJBHIdTaez53Ihr5CUrgrK7k4i+ao
         nE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780506780; x=1781111580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BrFjxyk0Z/o0MfnkVA2E8r+AuJihHpuU5moBK75MRoU=;
        b=W4L0L1F4UOqlIi6LFGlMqnZzbjcJbCpo4H7B4YnsiHoQMNBmKC2NbZ8t+zLTtN1Xlf
         sOpVjOkSfMWPZdT7yZ1Khi8mglSfSU+WEoxZnvqAxMKmRtFgSwWa1f31dgphA1BBmiq5
         kZOySgm8D6QqKOf2W+mZBlEnpLsfqhhaPKl+Cl2IBlc5k5yaEGwaE6FwbQI0tqUrTihF
         QqZdgxVqnNr+Nch7UfgolMFKRYrUAPEm5N/OQ1oBhaHYOD9WlzfW2Ul9gppA5/7/WyxC
         XqM5MmT0bbmr2VXBPm0Pz2KepScIxrbSTB0kQXQmYeZSb4UnfvbAOYVlJK23u4YJ+oKz
         NYpw==
X-Forwarded-Encrypted: i=1; AFNElJ+s7eCzNn8wfab63QJbFUt0RoqO33Yu0fGKrEOUwh2jNzidhWFz3UQbEeFgGwpDNLAMxrUo5gBwLA==@kvack.org
X-Gm-Message-State: AOJu0YyO+gx/09MYcF71l9QnIWuDToD+230CJ0qOViv1C/NCYs/+AM4g
	YRkd88WGOUQybKRk/4+TakOq/rFRpuOZXQioTQi682wtmDYeJyNRBeMGqYMWZzjFN0TSioQXYb/
	ZrtcG7jiYfH7SvBRQU4Y2Dch4AzM1SCQ=
X-Gm-Gg: Acq92OEONOQ4p7zYmok2liaqMvDpTpEz5pDGlIBiWtoUB6CqHi+6lahr4Md8TWJe7hD
	T/JiX2XXB6g9JQyJn4abURC7U7YnbdTqAHX79+ZzanoG4SoGGeAtOHyflgguujCidJCxn9Rq3LJ
	WZGI09+me4srHwO2gqM4wdxm4eLNWUJPRy3H6ef/TPZWQlXLOXwlvUN53giyL5eQ/6NN31V8gel
	h6jxAvzu53rGTVNFRktG9plr4rcxNw/xgS+kgdI8/5i6BGE6N9xrPhVdsSHY7Hl63dMTcUx5hf+
	32ic2pr7+BhAcaJduoutSbN3TTZUVmCMG9ODGv7XLAbzGtxmHQ==
X-Received: by 2002:a05:600c:3f12:b0:490:b591:b372 with SMTP id
 5b1f17b1804b1-490b60f0030mr77803805e9.26.1780506780336; Wed, 03 Jun 2026
 10:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ah-A2gQ0GPgerXop@google.com>
In-Reply-To: <ah-A2gQ0GPgerXop@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 3 Jun 2026 10:12:48 -0700
X-Gm-Features: AVHnY4I5W7pLtkTwClTAUiBCAvVnzXvNIyCOJB5qfNQcTKUvgB1xOS2GUrN2MI4
Message-ID: <CAKEwX=MWX9KkSFAoN4xEMg3b+gZUN9=yd7rirAWG5NOBf26eAg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Yosry Ahmed <yosry@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 30F944000B
X-Stat-Signature: hr9ti9qdgibxcxmak41im4r5k1pxsp7y
X-HE-Tag: 1780506781-15573
X-HE-Meta: U2FsdGVkX189/uUQ6LlcGhSqdnEHm/EU7puHuoX4MNG7gJYNfxfYvG6H2TYW625BBvhGHgUxCF+IEuogim4XKbVbHp9f7AwLNQlDniXYcXIygBCiI5CyrPbkNBGDlZKmMXkR5ZZDF9zZADDCX3mIiBpNwiTWFRPwmsA/RuTg8IZQO3nOSOHQ9BP2qSAGUdEu9eYtE94hQLoS/kb14o9IY3+KSUbjRjC0Qb+KOvGBcPNAyMLia6xv3CUfbD51qhqoHYyvCT+fxhiw0YOt0TLSPdcfGWZRkYt4nHNmFN048Wsq0wGpo4GKa+abRJFVxa7C/jBXfBWL/eXJgXODQ/YyQ5cVCs0ZRxNfdnPOupcVxN95Qygf333b/K0M5Puc5qZaN+dgn4gWSV0mjmIigwnbq1MFLsgJJwd+41+FXdIDBFKSI/Py4wYLLF+q8f4oqat7/B/hVBIoyUfwNyicNiEpEkXu5qIOcAevvwh+ut/FZfPfevSks24X662tYTQWjruCDvwlfsnLVVNV5OiK04b/+Cis4EP5CMiiPyeX9xWpB3Xa3NyaNwfj9AhxV4VBYVplHqMBvFpqPoeJpOG2hhDG50vGlmZqUQboS0yo7C9epfM+RApyahAGVURl/44K6iVNHZHzvHKujFk8F1kVG6amNFgrh1jgilqi+1P4MifWJ5p4c59DQeV5PWzB24vFYuUSCSnrhtLF8b5AJ4lwWNshOacyDtgQebiWPHsQ6PMJ8LJFmY18IvPazCPK7ixLYI7HMioLzjoLHe7kou4BQvnpETisX53cj7leznSaPpRW0ChAdwmldg76CFmofvp9UnfKJ2GDakina1qH/8HLAKwTmeOj+dVLBRhfyiwzjpXnWYrjGxveXkvnF73uTdIzaMIlIcAGCSG2NOD7BPlWPV8qI40B1OSCEl5sGckeUpGOgTziAGjfpFjlASvr+ei3jR0gYqq+lSbQTHr7CYDimGM
 Rdt7WWGG
 /PTWS9fzBTLXjrHDpIyGWH5hlGGS3Z2hDRq/ywNXVSSyUdJJSIcYLKR2P/0zKtowqQshInU0htOOxjh/8v2V1mz1Ca4BMonCm4KiZwt7Wvj/XZkPj/e0MMS9vPlQ3c95MP82n/Ytl1HzU/K8H0iDrKRZVYMEA2LbKIqmzBgNAa3OSrFkeuP/Ee1BZYPUeQ7UcrABxsho0Zj1xxfQ7gQDPHAVCgAnMnPLzPTxjGCK/UjVSBx2x1rd5To038x2uPxC7xPG7lSM3fIEXUD48WOgdqIE/xYZrRu80eBdFrLOM90WKTQn/v333uH+YfS4mp5TRvsThIwBbqvuUXhzP4bp0O/tCkTkqdZ8OwoH3ZptBu+Zp3CwI55nrpaPtgDgvQYaHzZ+1adqiYhw4J3u0mNaX5TF559qlEC8Hn+qFYSW8+xygsfv6TfiJukYu7ESX+y5g2MVcoPBvMW996HkfVgcocQUSIDJOnOn/rLB6Wfb8W10kXk+7nb2QxCMy1ZYwAUwP3LxClfBX3UElx1nswOCtOBTR7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 2, 2026 at 6:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
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
> >
> > We still have room for 3 more future backend types, for e.g. CRAM, i.e
> > compressed-CXL-as-swap, which is laid out in [10] and [11]. Worst
> > case scenario, we can add more fields to this extended struct.
> >
> > Other design points:
> > - Both vswap entries (Case 1) and directly-mapped physical entries
> >   (Case 2) coexist as first-class citizens. All the common swap
> >   code paths =E2=80=94 swapout, swapin, swap freeing, swapoff, zswap
> >   writeback, THP swapin, etc. work for both. When CONFIG_VSWAP=3Dn,
> >   the vswap branches compile out and behavior should be identical to
> >   today's swap-table P4 (at least that is my intention).
> > - Pointer-tagged swap_table on physical clusters for rmap (physical
> >   -> virtual) lookup.
> > - Virtual swap slots not backed by physical swap are not charged to
> >   memcg swap counters =E2=80=94 only physical backing is charged (I mad=
e the
> >   case for this in [7]).
> > - Careful separation of vswap and physical swap allocation paths and
> >   structures adds a lot of complexity, but is crucial to make sure
> >   both paths are efficient and do not conflict with each other (for
> >   correctness and performance). I do re-use a lot of the allocation
> >   logic wherever possible though.
>
> Thanks for working on this! I mostly looked at the high-level design and

Thank you for initiating this effort in LSFMMBPF 2023 (god, time
flies). I was very excited by your presentation and decided to take a
stab at it :)

(I'll be sure to mention the full context in a non-RFC version - it
has a lot of gems in our technical discussions).

> the zswap parts, as the swap code has changed a lot since I was familiar
> with it :)

It has changed a lot since 6.19, when I was working on v6. Very
exciting time to be a (z)swap developer right now - we have new ideas
and new features every other week :) Reviewing code has been quite a
joy (albeit a lot of work).

>
> It seems like the direction being taken here is that we have one
> (massive) vswap swap device, and we keep normal physical swap devices
> around as well.

Yep.

>
> A vswap entry can point at a physical swap entry, or zswap, or zeromap.
> If a vswap entry points at a physical swap entry, then the physical swap
> entry points back at the vswap entry (a reverse mapping).

Yep.

>
> I assume the main reason here is to avoid the extra overhead if
> everything uses vswap, which would mainly be the reverse mapping
> overhead? I guess there's also some simplicity that comes from reusing
> the swap info infra as a whole, including the swap table.

Yeah it helps a lot that we don't have to rewrite the whole allocator
and swap entry reference counting logic again :)

>
> I don't like that the code bifurcates for vswap vs. normal swap entries
> though. Not sure if this is an issue that can be fixed with proper
> abstractions to hide it, or if the design needs modifications. I was
> honestly really hoping we don't end up with this. I was hoping that the
> physical swap device no longer uses a full swap table and all, and
> everything goes through vswap.
>
> I hoping that if redirection isn't needed (e.g. zswap is disabled),
> vswap can directly encode the physical swap slot so that the reverse
> mapping isn't needed -- so we avoid the overhead without keeping the
> physical swap device using a fully-fledged swap table.

Can you expand on "vswap can directly encode the physical swap slot"?
I'm not sure I follow here.

>
> All that being said, perhaps I am too out of touch with the code to
> realize it's simply not possible.
>
> Honestly, if the main reason we can't have a single swap table for vswap
> is saving 8 bytes on the reverse mapping, it sounds like a weak-ish
> argument, even if we can't optimize the reverse mapping away. But maybe
> I am also out of touch with RAM prices :)

In terms of the space overhead I do agree, FWIW :)

I think the other concern is the indirection overhead with going
through the xarray for every swap operation, hence the per-CPU vswap
cluster lookup caching idea:

https://lore.kernel.org/all/20260505153854.1612033-23-nphamcs@gmail.com/

>
> I at least hope that, the current design is not painting us into a
> corner (e.g. through userspace interfaces), and we can still achieve a
> vswap-for-all implementation in the future (maybe that's what you have
> in mind already?).

That's still my plan. Operationally speaking, I want to make this
completely transparent to users, with minimal to no performance
overhead.

The next action item is to optimize for vswap-on-fast-swapfile case -
that was Kairui's main concerns regarding performance. I spent a lot
of time perfing and fixing issues for this case in v6. The issues with
the most egregious effects and simplest fix (vswap-less
swap-cache-only check for e.g) are already fixed in this new design,
and eventually I will move the rest (lookup caching) and more to here.

>
> Aside from the swap code, the only sticking point for me is the logic
> bifurcation in zswap. Why does zswap need to handle vswap vs. not vswap?
> I thought the point of the design is to use vswap when zswap is used,
> and otherwise use a normal swap table. In a way, one of the goals is to
> make zswap a first class swap citizen, but it doesn't seem like we are
> achieving that?

We already have all the machinery to make zswap completely
independent. Right now, if you use vswap, you'll skip the zswap's
internal xarray entirely, and just store a zswap entry in the virtual
swap cluster's vtable.

I just haven't removed the old code for 2 reasons:

1. Reduce the delta on this RFC, to ease the burden for reviewers (and
definitely not because I'm lazy :P)

2. The only other practical reason is so that we can let users compile
with !CONFIG_VSWAP and still uses zswap on top of the old swapfile
setup during the transition/experimentation period for now.

But logically and conceptually speaking, there is no reason I can come
up with to use zswap on without vswap. The CPU indirection overhead is
already partially there (since zswap uses an xarray) and further
optimized (cluster loopup caching etc.), as well as the space overhead
(vswap replaces the zswap xarray). I actually wrote a whole paragraph
about how we should always go for vswap if we're using zswap, but then
decide to remove it since there's no code for it yet.

If folks like it, what I can do is have CONFIG_ZSWAP depends on
CONFIG_VSWAP, removes all the non-vswap logic, and call it a day? :)
Then, on the swap allocation side, if vswap allocation fail and zswap
writeback is disabled, we can error out early.

