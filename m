Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE86C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8DA6B009D; Thu, 27 Aug 2026 13:48:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 680736B009E; Thu, 27 Aug 2026 13:48:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F7C6B009F; Thu, 27 Aug 2026 13:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB556B009D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:48:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE3EE14013D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:48:39 +0000 (UTC)
X-FDA: 85147784358.04.775CEDB
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id E2463180003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:48:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qj8Nx+LN;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787852917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ki/jHERIN4Hv3jSUFZztXyDphrusQOq08taXm86VOSQ=;
	b=5+MwLVyyj2svTJ/mEDKD9UstnUTzhBPQ1PvzyvwV2xsMVOtTQLji1E+fKzPG/kZljlCt70
	n5l18M4hl04ak4+S9sDmG0wTNjWFXZfb/Z9VNgMIJ6aA0LJwu1ePvbvENapayaws/cjZ+y
	xh35MrSvkMHNJkRoGdUUE7hJnhdK6CQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787852917;
	b=0LDYVHZ8xcqHF8qv3Cxbxj6dJ1UBG2uPNqsmWXBsbJsGe+iw5bRh8aoG7s4OLqIg61DHcc
	yLbxBdasU9rtxw3Mdy+rMeSalHkBcv6ruo4YywUvtsqufWjAsGA24nieT1k2wvEfR5rXVu
	9NLcNruwdM7/ASZUkW6uVJoiFaLJqsA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qj8Nx+LN;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c250c6a6a9aso18921366b.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:48:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787852916; cv=none;
        d=google.com; s=arc-20260327;
        b=bcOYGLv0FSwhgk02afsekN5D55saWQlXTIzDjMQeNDMO3Gg753oIBMuG5mHj6ce20y
         nrZY0oHGr4x+11JUj0FOGKRWhFOKTT7XaqBUsewhBS+fpLCoAV87HmgVmotv+7CLTvE0
         MN8lyZM4mtXT3rvA3ZPT6AJtbkGpUM5aDdnf/lTb4dOp/J2WnILmKw0OsHwZVLZyOp8x
         6q+x6rzhQgp/C8SG8jZvQoMbi26Pc/M4ZL2FaLw15zyHKFwtfxIBGSzrY0KnzRYlICav
         c61CuqqZPC5z4i1+XlxUCGjuSTvG1ZrTTG94aWpUOZgLMfgBNUp5uKntgOmbOpwHdDsq
         ayRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ki/jHERIN4Hv3jSUFZztXyDphrusQOq08taXm86VOSQ=;
        fh=gW5ivs51vbjATpS7fTtCbsRWfHNWurt1lFXO5nnQLVM=;
        b=EcVTYRP1I68+ZxYTI325jSuKbipFkwWBqwwg179ZQsS+3xI2vFthaa+GH5+RUsolee
         Sa5AGJ14AHEPmwj2PlvcdZkiCcwIlsb0iWQ1E69eVE94Egww7OfuS6/S8GAr7GGVbPZK
         WSeQRkL7env01/BNrxNbZ5hR/BUmqnqVrM5rnmEwjUNFJBMkNJimwXtK27nYYs64AFBT
         GDvr3Z3a4IKB1XFZ33asFJH9T/8dk4NA++NzOKcDA6XmUoWm61eeN+X7Dyg2VeBMbXMD
         ixhv5nbI7d7Qjkn8/HZlVxsIkWExKBOvXQgy5AbWjfyULAMMkMUeXTrQC6o06sjw5UUb
         zsBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787852916; x=1788457716; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ki/jHERIN4Hv3jSUFZztXyDphrusQOq08taXm86VOSQ=;
        b=qj8Nx+LNo3n7Jkp2v6Icg3gruESOCPXz2DZ+6oR0SC0FibWEF291S0m/pc2P3B0IT1
         B/NN2pH+tU6bSfo7WD+/x95zvtwpg+9T8ng31X63gD+C1tEFwtLD4L+JqKYQubYITCcw
         UtGYlVSBZGG0mG6Am2UJZz92A7zIqyIFIhrtRViuEGnErDYueA488yoaRO0tMbUQvnqn
         haXKmJWtE1DHmIhhVIb/5ESswR8FStWIQm6e2zbsjIokRWg8yXiiTWfBPI9WnK5BE9lb
         VG3uaD6xzxrF3V2ExCXkza2Yo6gWeZMdN4om1Sbk16BSA79LMefhEZ7obAMgmrjOtS5T
         26Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787852916; x=1788457716;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ki/jHERIN4Hv3jSUFZztXyDphrusQOq08taXm86VOSQ=;
        b=Kt3PyT+8E5XNCncKWDKmFpZ2FtDCMJ1VOvJ2ez2qCTzGNbeTEj7qnzs5/j01z5u9IF
         nMh1OuI5rvIqKSubsSES+FB9hNlMVJ7kPli0RsWKomEhdigFeYUMwET6dJjOue6QYtRz
         1lBPEsKp14TW7UVQ5Em5yE6jnJjZs/vh2GjCQWNSdDdZjejkdqH2gme1mEUoSO3R/m3m
         phYzFAaU125LgMtabQOg/ycy2kj0pqWpvOXpn3Hwh8GMdx01PCgO3V0x/00cqbKTRcXX
         tDoOr9boo2fuGSYW+lH/06c8yRb6obTHD/o5e7XVlcdtqmrqQKWrHZatUQvQtC6laFKo
         PJ8Q==
X-Gm-Message-State: AFuF++kJkUNucXE6AkltrmR1jv12i9W9J7spw4hhCFnMXeWDxFOiTcCF
	AXrqhgBSmwirg3K3326IlpPYmwKEiy3YbQgp07xaP3IHiCGxK2N+9JQVAQFXlLfH98ySBMTkOY4
	M9IK9Q6x/ySChv1rM9KvoiNhnedBqW3k=
X-Gm-Gg: AR+sD12vJbuhVfiHDfQdoncco9Moz2m8Kk9A9l9vlIa6SjjleOHz/7C1xNHkxEyY0jy
	PAgOUXd3bYtXx2wHzs3SUQLeBJLfzQ+pgBX5UZhAC8YTR5oq7S3MYOgivPirBkqIxWCUyYqk5sc
	infM7rlb0E+2dzWfdRPoYLr0x44788bxlssSliDrtYtevqGMYP98ldtlycvCvmnFeNTynYPNJw5
	wSSypV7+A1rMjOB7qY0OXt8ykPj/FguDyrKQeL/pppC4RSuGTK7WD7kdaFha6aLq9NmqT9qRzw7
	+HS4etBpk4bjW88GgY0rUWk003GNXOV5LiQzAFw/9UcPu6OhKaFein72vSD7a3rigZstSaC+GZ6
	/
X-Received: by 2002:a17:906:730f:b0:c1c:6f0d:5b22 with SMTP id
 a640c23a62f3a-c25570166d6mr33555066b.11.1787852916422; Thu, 27 Aug 2026
 10:48:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-15-9b43f5163238@tencent.com> <ba386e23-1b05-4897-98b0-ced78df6dc25@kernel.org>
In-Reply-To: <ba386e23-1b05-4897-98b0-ced78df6dc25@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 28 Aug 2026 01:48:00 +0800
X-Gm-Features: AcwNN1UewL-cuQ-vSgggye_rWK2vi1yOvz8HHS6k5d9ejkD-Ea0vd1P4dZ-uXL0
Message-ID: <CAMgjq7Dg5pf_MR=C_KqixYmyfXyD3UpKoR_6aO=aBpZsY4yJEA@mail.gmail.com>
Subject: Re: [PATCH v3 15/18] mm/huge_memory: lift order-0 restriction for
 swapcache split
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2463180003
X-Stat-Signature: fpk58jhsae3jt7zg3rp8qzhmntf3a1yq
X-Rspam-User: 
X-HE-Tag: 1787852917-993671
X-HE-Meta: U2FsdGVkX1/ndsL7C2bhCgG1vjFJtgYOWmjj/NWwX9fpmduVT2zOZa2qo6Kw+3Z/jcBQDVrCsDBHsrVWm9xdYczdvp7axZpciEH3UaR6dunA4r7dTbIyAjg5lNLfOsoMT2QKNVBZOQDYXaAvnEB5eluUxaDrQoce7mJ+klHIsX9hfyTqezdccl6543f296Ol/EWgdfHiJtDTBCK0U2z4S8spTujCUhb1D8fRdJ77BdyQzRkqSXEXbOD2HrBoluo5Rntaubq1mb/U51umqKLfSF7JjxY7sItiQOZfYHVkBzJ07Hby1qoNfPDE7dhtiKHlc3kCa4bhW6yNj+bPEl8NBS8xYDlgGu13r5OXJnJevvw0uvmWtt8Y8YNlNKqv6fVFbWmtWNk5MwIvWQioJzjInyM+bcnR6bUDuCdq0TYTKe4j2CtFvHl7ovj3FMYSUtZ633FbOc7WcD8axqIdn3hYLAkTGsKtxlWr4wlNtIfu81dBlj6LlBITPEwDkrvScFU2ibA35uSwMfw9AnoMHS+V+ypFnoFNo/zatUXwDEIV7HbywV2wNNxZ6IFUrwGz6WsyMxycyw6BJy/IEPvutTmgZ3vghqwlw2rtxffY8AlDOgDh1SzsnSJ4+MidF83HsiI2+eoZnrcUQV0rxfvHE42VGn0+Q/0owzbzvPrQkB+cUpkjZEnwnotnLFtpNkSh6CyCD22seGot+RXK7Fw2COae7IRFripL6VMVesqzp66HLlotzOKNV/r6AaQE8yWvoO+3MBZcMb7wLvNmY4ysFkCJFrP2LmlR8gaqVJrcokc2vo3YsiAQdr5K9QecXi2pJdJjALZqBRtWCeF9j7mkJ14h3iLH/kSXq0nKLLvIkvSbZxmopao6EsEE1k4lVwIPUKK5/MNfe5YsEFQrZQtNMMqTy45Ux/2uRIz6Ms3BenY+tM0O+Wwth5WGb+TvLGNXsRjdvzhs1fSXZSRjrUdwnWg
 lhe0hi2E
 TASjaO65GeM5gvs4WtqjMq7LL/H0Hj6J3wksHyIoQ8fbQ11dTU0JRwB8Af1/47gpVPAsW/Dxq09a1qU7A4y8abu0lXLXS3FrleD9rTD7XxyLFTOax9rIq+xJFcyhNIMxbXW/1zZKfZjuFrCyRzL4Ehvlsiubzx9I5Cg8kUS9ipXzDueAU/KB8JhSn46FcqeOyVhBNoUPArvtjcPPX6icpH0sk1gXPxG3AYwEZE8wSgvUyhpMTeX2bAShONJTeaU4KE8yFF3wf2R0qkoS/ejCga0JWvSzMILMkbrmfliAL5ZyPQIBRCHpzUinlv3upS8+gI+hZ48HAYpnP6lNjUUkIx2Y0AVGpyx18wI5wynUWgutl/9QPc5RJ/D06UIuaQvAL9xOYSSJZYQf705CcPLdJCRZF0oHN/kkso7SfSntzNq0o/rEkPuSkBojL01ZicaL/j7VcsaWD/cz8rYPdWO3H66eYjaiuzc+4qG9+MawnbzfD7P07R29Lt33Zqfo4ieiDFf3bj7jmiis6ijE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 12:51=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > The restriction that swapcache folios can only be uniformly split to
> > order 0 dates back to when the swap cache was managed via address_space
> > mapping (swap_address_space).  The old split loop only created order-0
> > sub-folios with a fixed stride, so non-uniform split and non-zero order
> > were rightfully blocked.
> >
> > After the swap cache switched to swap table under a cluster lock,
> > __swap_cache_replace_folio already gained the ability to replace any
> > number of entries for any sub-folio size in one cluster, and the old
> > swap_address_space locking and limit was removed. The restriction
> > became obsolete but persisted through multiple refactorings.
> >
> > Drop it now: swapcache folios can be split to any supported order with
> > either uniform or non-uniform split, except order-1 which is not
> > supported for anon folios. Mappingless swap cache folios could be eithe=
r
> > anon or shmem, so for now we just simply forbid order-1 for all swapcac=
he.
> >
> > Acked-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> In contrast to the other cleanup patches, this patch changes behavior.
>
> I would suggest to send all cleanups first, and send this out separately,=
 such
> that it gets proper attention and doesn't get buried in a sequence of
> harmlessly-looking cleanups :)

No problem, send this later then :)

