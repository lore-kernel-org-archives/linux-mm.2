Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB404CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 22:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11D588E0008; Tue, 16 Sep 2025 18:00:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F4D58E0001; Tue, 16 Sep 2025 18:00:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030C88E0008; Tue, 16 Sep 2025 18:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E67E78E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:00:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93D5CB81FF
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:00:10 +0000 (UTC)
X-FDA: 83896482180.18.A15C6E3
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id B4FF01C0015
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:00:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DhPZty4r;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758060008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThoOhf+6dHZWhwOpzvQ+ee+2qRgrSoe6WcpIwwuJkt4=;
	b=yZpIVlzLllDPIlDjsFWyZe8HowyXZ56OU1AKVN7vHitDfHLxVP0v6QzfcBGNwXddwuoGZU
	JnRe7YXo8YlgeD3Ga8xuVyBAV80myd4qqTCXmOAx4XYva7SaNorbOho7NZ4G+v65+MqBo9
	O66bn7yp3bXd5BzvqSx4++/baSeqgwk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DhPZty4r;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758060008; a=rsa-sha256;
	cv=none;
	b=QZj+qDshvIfKcyjPfAg1e1rFZw3meHDCEka909CDFGhfdFGNaNDb9BDtCDEp/dCKSj4K6u
	7JlHD5Bam4enPlPjidWeIDpmumsvpcu60X6y97GKPIAcQpyCcOBo6vEWtfmLbtJ0O1LQHE
	LAUHRuGPSd4W+fe0yW5mLvI4Ldzt4Ho=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-828d8d06630so35281185a.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758060008; x=1758664808; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ThoOhf+6dHZWhwOpzvQ+ee+2qRgrSoe6WcpIwwuJkt4=;
        b=DhPZty4rjWMa1nlxD1ABRKWbri7471X5sVDDR90esQc4cSmUyEIZw3e/VMABQozKZR
         zJeYdLRf4mBJzOEqJcnzPHtPM6GNjJckfFpGxdWWcHNGUM6I65EgizFzEQ0d7pIxZvgJ
         Z0FjEv5LPhG9db3ZDpOL1fG2t5H36KpT/lW2uBiHOZGAusPb6qgDawh9YhEbu+jq8Sle
         fs9ylyyglQ4Xug7YDJE4qtA3Qn/PIaO18p3jflpOK9uIQyvakIB0R1oCFMXwZs9zW3/E
         ibiIC+HMM6RJ+roadpoJD3OyCveTePWMXPdwEAwUNsMfDVc3oXq9Qq/MZTweFELj5RWd
         ZdDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758060008; x=1758664808;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ThoOhf+6dHZWhwOpzvQ+ee+2qRgrSoe6WcpIwwuJkt4=;
        b=EOtvbnXVauu87SglUqPzJNaYEwYOC3k5y01YG303JXlZk3q+2PxCkEHogN09RkfBd6
         XWEOJn8ktKDRBYoLsIHVLcSL9Xp1cOPfJrVGnFmbw4MDAscAvqkzULpEG3yaeD074M45
         Bg8wShwArWKRH6etwkZdZPdjKPCQAxD6V9NRgxUoHzxCnlLBnpcZm8ofw3UF130p6ly8
         5QlkK8DQPNHvpZhVWwu1jFfYsPrB4tA9u0vrWCTpTIRs8jbogZcWBTd1Dx1ePdX60i+X
         9+ZLoHV/J/yS0Sl+uNRDrBwsBxaXTU5xftSp99c9E4m0z4oMARYJ6hs/EJpBFIgCUwcj
         5eBQ==
X-Gm-Message-State: AOJu0Yxp2+e6V664eNJpJTN2UY7rBhvQWNd9pHSMkTzGZc59JkWSDcrt
	CZ0om/FhlngnHp7Z4pgPNOTzwqDv5UdWbhjT+MQMFGXGywPlZijDRt/7UY3UfUrnxqbanM9YrBP
	vnPnO1UlZDOmiHBz8OJrKqCgDIZlAAzw=
X-Gm-Gg: ASbGncvm2iIb2r0S7ElSRr6PTj5X6tc/Fm2nf5OHJiqZ7F0F1ggwzcr3CsX14VpshJI
	yQ5pwiDG7OxSo9VwCbrSpuk00vDR5J2KSIGtmsRZ0zUvJuqpC7H3hoV9PMpeiBHSVtpyklp4wdN
	Cr1KD5unMzWbju9OYuygcx3ENKm8TZYOIbNQ8iy03XpoeOD05os+modx6LNffhLSglqhJVruvlr
	HKrnh9qfHZdcbv/HXCU3I3Qp+7AA25iiAGf42rKZA==
X-Google-Smtp-Source: AGHT+IFp40UDIihRYk9syb9JZvodewOvILFSFFVd5xhGvihtX7lMBcvp+BijPssbXYsS+F+G32VtT7aS7hCYn23A500=
X-Received: by 2002:a05:620a:3729:b0:809:b21:5421 with SMTP id
 af79cd13be357-82b9d9d342fmr496291585a.39.1758060007615; Tue, 16 Sep 2025
 15:00:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
In-Reply-To: <20250916160100.31545-2-ryncsn@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 17 Sep 2025 05:59:54 +0800
X-Gm-Features: AS18NWBZzepHycNk5Ebg4834edrTcub9sHWJBZ1C11nD4dWKjdfFZmTFEHRW--8
Message-ID: <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
Subject: Re: [PATCH v4 01/15] docs/mm: add document for swap table
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5k1t4a49y91hwz3htym5c3nqrmkcs8ch
X-Rspam-User: 
X-Rspamd-Queue-Id: B4FF01C0015
X-Rspamd-Server: rspam04
X-HE-Tag: 1758060008-643568
X-HE-Meta: U2FsdGVkX1/SAVsB++S8ExSRF8TLXb2rhSI7C86hm/LwYYS3IL5KCR+awBFdDs/R+yFDDo+jp2HOfsv8lTY3k1OuDCQnokmIYhX0COizkKsvRIABR1RMG5J1In2jXg7D353WIpp6+MVt2MdZdx6SnbhYXXm2v/2GhafaY3yli5BRaxKkSAFkm5ESZr0qQjX2gOumzLKne6ufpq1kq73/fto8fEsJj01wt5/vbqgmO2fmcJCrdiex/DusLnQfMfVq7mFostNPe50kFD7vK/N3qsZvty9zJCmhMBe1R6RmP2pCNYVgVI6vY6y8P7rXZeLFL8vfC89CA8UzhjAIx8dS0bQoH7PzlAs4ZTyIKyEqi3zrqfrP/a9kHJkFwoeropBjRTz67mpfk1YSadR4uo53uF3fJHPQaXYA/4J8JjA5jdmk53skrUXjZz1xRaqdWoHpt6H0XXjQgmtByqXYPvbR92Xg9++b421SnOVGp0lW7cpRQ9xw6oUOBSn5gBDgVVFsKZMfcnLryDlREUMweTRwOCfS32tUs1JAMaWFja7kFnZjJUzio+r7O3wJl+qdBkV3fzXlCmv97lGNt32Uqn2I9uQgLaqy7crpMdU8+mXIoV0eO2Bq5eXqINCwKNdijOXw7YLySKHpGpoNPZ9tA3EznRPqylCCb+nBpqSrmKUDy0fKhuBak2p0NJOKmX2I8T3eiv/hXh9Zwj2RnG69ydaqQyLchyrbl4IFh8xV1/yU/guhWqt0NoyUbzx/jV9lCARxQMm54vtFV6z52Y4WyvUftVzwuOVGC/p3nlxuZNYvkbuI/hudHicsganGujhVdHlUbbSFsC1SRetVERW8inZNb/1fkBlCTo2rh+SEhp8IExMA3frDDgGJmHvGzEwbFDTyD4J5YuMgmBCTES/Fi48tsFtj0bt3YHsuifhjtGqIP1s1lmw7nesflTA/nZosfL7LFVS/acESu27J2G8Wl7u
 bbq1dMmn
 E8PRk/a2jnemPzDFr7hXz5HtHUEemYCi04KANijG4kCLSmQf0zypjkkxuvY7AAo9onoXR45eq6jNtc/1X5PnQLDHHnDzFJDeJG0Akj53DdaY/FjCokRIhKzxcb20SrpcD3ee/l2JvqQWxQW3/bN34m69+X0D48vjMxwxLoEFXe+jZdFXTdqdLbxhryO0gDKBfpV+e9CeDKI/mxixFgpvpW7NNkQTY/97BdcQxwsEfyRmwpwyIiJil/mqQSmnMzVnNZ1s8/8M9q7zs+FFUoo2iXWrF181IFfSFpHhNm4uPlj2Ep+MsdRgTPzvVA8PnuTNkm0Xm1FPZctRfD+aNKQM9EhC+L6vvu1GYNkD24UKcsbxeuJ49iZx73YQ0ZifTJWxBZVAaqHnmhTj1dGoz/ldTdSmZMdRcuvuEEfsRkwpsuz00gMY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:01=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Chris Li <chrisl@kernel.org>
>
> Swap table is the new swap cache.
>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  Documentation/mm/index.rst      |  1 +
>  Documentation/mm/swap-table.rst | 72 +++++++++++++++++++++++++++++++++
>  MAINTAINERS                     |  1 +
>  3 files changed, 74 insertions(+)
>  create mode 100644 Documentation/mm/swap-table.rst
>
> diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
> index fb45acba16ac..828ad9b019b3 100644
> --- a/Documentation/mm/index.rst
> +++ b/Documentation/mm/index.rst
> @@ -57,6 +57,7 @@ documentation, or deleted if it has served its purpose.
>     page_table_check
>     remap_file_pages
>     split_page_table_lock
> +   swap-table
>     transhuge
>     unevictable-lru
>     vmalloced-kernel-stacks
> diff --git a/Documentation/mm/swap-table.rst b/Documentation/mm/swap-tabl=
e.rst
> new file mode 100644
> index 000000000000..acae6ceb4f7b
> --- /dev/null
> +++ b/Documentation/mm/swap-table.rst
> @@ -0,0 +1,72 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +:Author: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Swap Table
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Swap table implements swap cache as a per-cluster swap cache value array=
.
> +
> +Swap Entry
> +----------
> +
> +A swap entry contains the information required to serve the anonymous pa=
ge
> +fault.
> +
> +Swap entry is encoded as two parts: swap type and swap offset.
> +
> +The swap type indicates which swap device to use.
> +The swap offset is the offset of the swap file to read the page data fro=
m.
> +
> +Swap Cache
> +----------
> +
> +Swap cache is a map to look up folios using swap entry as the key. The r=
esult
> +value can have three possible types depending on which stage of this swa=
p entry
> +was in.
> +
> +1. NULL: This swap entry is not used.
> +
> +2. folio: A folio has been allocated and bound to this swap entry. This =
is
> +   the transient state of swap out or swap in. The folio data can be in
> +   the folio or swap file, or both.

This doesn=E2=80=99t look quite right.

the folio=E2=80=99s data must reside within the folio itself?
The data might also be in a swap file, or not.

> +
> +3. shadow: The shadow contains the working set information of the swappe=
d
> +   out folio. This is the normal state for a swapped out page.
> +
> +Swap Table Internals
> +--------------------
> +
> +The previous swap cache is implemented by XArray. The XArray is a tree
> +structure. Each lookup will go through multiple nodes. Can we do better?
> +
> +Notice that most of the time when we look up the swap cache, we are eith=
er
> +in a swap in or swap out path. We should already have the swap cluster,
> +which contains the swap entry.
> +
> +If we have a per-cluster array to store swap cache value in the cluster.
> +Swap cache lookup within the cluster can be a very simple array lookup.
> +
> +We give such a per-cluster swap cache value array a name: the swap table=
.
> +
> +Each swap cluster contains 512 entries, so a swap table stores one clust=
er
> +worth of swap cache values, which is exactly one page. This is not
> +coincidental because the cluster size is determined by the huge page siz=
e.
> +The swap table is holding an array of pointers. The pointer has the same
> +size as the PTE. The size of the swap table should match to the second
> +last level of the page table page, exactly one page.

On a 32-bit system, I=E2=80=99m guessing the swap table is 2 KB, which is a=
bout
half of a page?

> +
> +With swap table, swap cache lookup can achieve great locality, simpler,
> +and faster.
> +

Thanks
Barry

