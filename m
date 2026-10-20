Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59010606A330
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 17:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=NkWn0tMo
Received: by kanga.kvack.org (Postfix)
	id 75FB06B0541; Tue, 20 Oct 2026 13:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70E896B0542; Tue, 20 Oct 2026 13:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FD396B0543; Tue, 20 Oct 2026 13:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A5AA6B0541
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:58:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB6401C34BA
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:58:23 +0000 (UTC)
X-FDA: 85343764086.07.FDEC063
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id DBA9440002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:58:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NkWn0tMo;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792519101;
	b=OjKHPFbzc1WcSF96PcM+dTmw4c1bzO8d88gECgeDNU6SzZvHvWyEKwsmRaJ5CH5yP/Jk/5
	FoyvGwTRwHs2Yof+ckyIm1bLZvn5q7VU+eCU/CBXNc4OxsL+QTThu2Y/pKqIydsruFOmpN
	9PgzhcJzh+qpH007M59gRncNj0AGvRw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NkWn0tMo;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792519101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYpDQsgGRr37nBGO2U3Z6QjUyN0Co5SvOmgYxqHioD0=;
	b=i8dqJJsvTEAsYvuIpQzmr3yz6OARsyXrLlDs/wjgij7M/QHHscuTlLoRBgcvVocuXiKNtZ
	zIFksobeCTIiWK5MWUoSOfxquFEYQ0sBFlQ6spV7UYSRc+VgejaOAQNYmPuSi8F4cn2+6c
	U19YXvfYUjH/ybmQUoq91VfgpX9gWSw=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c3fd91337baso492537466b.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:58:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792519100; cv=none;
        d=google.com; s=arc-20260327;
        b=ISs+MWegZLTayJBqEEt7rkfJomcpj1UlkRkovZGp/5zk6EhBfu1t9ile0ht8doQ5CV
         LuPg0KWfR6pUiXJspPXZ7Km1VE9HPzl5lC6lR5fDajHfFKL/pNKQVtsaT3c8TGu0bj+a
         gQNYoJ72szjJ2lIokkIIyXtYernmuJd/AQvc53B0v9vuPtGbgllUoGWlowjXCdbXqdE4
         2nbzHXKO23DhQu2DkP7dMEn/bUX+bztrJgt2q+LSEZE84AR0pYLrxHlZaVpXY9cgzW0y
         L4nP2pu5vk0NFEU4SZAPaRjHEBy9M/DQUzw3pPzhzLWwtXZOy2oFLUG50WWfac8YAj4T
         rDCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TYpDQsgGRr37nBGO2U3Z6QjUyN0Co5SvOmgYxqHioD0=;
        fh=vDHySJwjsVPdL3nbZC04mZjNp+TO2e217qJEVvnxWfQ=;
        b=lT/oIByPOXCWQ56p+GFrsPCjCGAfa3jVyTLrjbeKhNLwglxOCIU1cwXdmzIIRhUJQP
         wXUagGuwNsiYk5bMKjEeJx5g3S7By3BW6toaX9qQyhH9JJ3Evek3LYMOPiSYGwawgNAh
         hrYnSWhopXzR7U3TflD4Q8+dusLlkBOi9Oc5ibB192OMHdCPDjuZRDeuaqxACjjvMKyP
         gWblbw7LPit+TQbqlQTJAnqbF8tfZ0HBS9LWnJODCluPou+0683WGyg1mi/AD5eTLF3R
         p2w4xwE0ZH+Ykwl0ZispOZ/0VnBU8Zjs92QNkjsv2iGNOxepGafZjcTitSEdT2pLDsnQ
         8i9A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792519100; x=1793123900; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TYpDQsgGRr37nBGO2U3Z6QjUyN0Co5SvOmgYxqHioD0=;
        b=NkWn0tMoHcQfXUifzT+I6GkwFwuBi3WdL4CdZa/6oyRD0YZnYrvWhcZgTTE7figmTP
         h7FI3yu0K2UFrtAbSMYH8vwY6v/d4c9ykmbjWUCGLk4RDmy4iELg7cM73wORuyT9gmSJ
         q0FNV5CBCF3jyPU+Wa/5Ol77T3fOGf7Z8XQ/YXQWh9rq/IqLGA/E03l8Y72lZxgExc5I
         7wd6tQwutcMZplJfWUGw1ra9ediH9OMRDUeCan6OSvyIMlxrGyyNWBNcewVHqCpQ4KWD
         yrp1qymVl1xKLwXOhcUUN/ZljYhqMAAfN1Jl+xaTAGTeMaYTsX1/865j+YOF7qfI6U59
         iQxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792519100; x=1793123900;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TYpDQsgGRr37nBGO2U3Z6QjUyN0Co5SvOmgYxqHioD0=;
        b=dNzZQXR1/W6soYNmmp8/fJd/gGBTzlPl/N2Vjgpup9/p2u6BltSPlHB3i8awSeDCjz
         8bpZvgndjiIiiEN5lQZrYBfOz0N99gQ1uWDD69mVwvik54v4lSFOIks1ThDwobNQBt4z
         cXx7exVfJyqcqMlSqEAQ4P+qaoeod4a6z6EFjea0mdS0FOT/Yq2eHeG2PyKKmEE/wXOw
         WJg2W7UZk1mglWbgoZxOOn0AQUdEonTB74HrTlEXDsYUehqia+phCkbKD6mXsbTrl5Lu
         uZXDwzKW3qDRUSg886ufcM52/ixgRrUVwbQKh54jab5sJjIipJtcu/pvTm5Sc0PGGVtX
         6X9w==
X-Forwarded-Encrypted: i=1; AKwUvBxY5Jwd2URf1Ey5dk5Iak42LsKwlgGyRVDnc0iGwiZkSHeqimkvnbE4pCuTrqKT7EwzYb4t/Dpasg==@kvack.org
X-Gm-Message-State: AFq9FYI+3xVlpeIVxaA+3N2N5ALXarfdeGQRCM0iJMbQyTdzWImWil7d
	mfmj1Zpw0VdFa6hjvLOax1fBCz/PB5pcn54Q1o/hjlhk19YyBweEStgAvZlQ9LyCrJwvZ6m+HBV
	DKpbDqcpEEzaJ4md7NS+BeM6cm/RB0eM=
X-Gm-Gg: AYBFou0WpP51ArHVYqy+a887Vz875NJjCcG6hs2BjJtmx7qGlwfQi2I7D9hRf6gEoyj
	6apSE08pJUh8VgK1qcq5uasm+nuMUjX8OFIalua4rLIj0kRNTY+tbtAOlnCaZhfSB3oD0mc3E5x
	yOxLcUq1aBfqEDmH05vJmQwe2024yVvcKg8FlFWP3QQLv0c+1qUkOwjrw17JRdtW87QwmsguQCP
	Il1N3foMmkXu44uClPauVJ0lQ4q6rgBU40K/Ng50pHe+OM5Nb98C1foImbXrl1YH93z3osr/8xM
	hjKFq4x9GbpFOUREgmsr2ojpcgG2er/AcWnoaiCLE/M09oXTGSdXNdpZahOOChMoNWlZmNucdzj
	dVZnaIL8k40jq
X-Received: by 2002:a17:907:6d12:b0:c31:8984:7fad with SMTP id
 a640c23a62f3a-c419d067e77mr853092766b.15.1792519100063; Tue, 20 Oct 2026
 10:58:20 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019160615.2348500-1-nphamcs@gmail.com>
In-Reply-To: <20261019160615.2348500-1-nphamcs@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 21 Oct 2026 01:57:43 +0800
X-Gm-Features: AclHuK81ig-p6n-cemVImrMFEtjvoTG0vQVQgOGs9ux1VBr9C6W8ghDtjcxeOK4
Message-ID: <CAMgjq7AEg6XEUJPaM3mMBQAeS_KiDv8_za4w-R2WaZ=ZGenvuw@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: revalidate populated clusters before scanning
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rxy7akdqttf7ryqikokk5ttojomc5dz5
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DBA9440002
X-Rspam-User: 
X-HE-Tag: 1792519101-8724
X-HE-Meta: U2FsdGVkX1+j1vvRWJC/1zSPYpcg9l/9FmAedtoRUinDt+IvjLp0vcOE05GqaL7jyzSS4YjTjQSv8I9CnOwe+bbrfh1iGDONCvW93U0yKtvRDin+6to912fTrKP1/a+8P8BqdhL6W6oeGZ3zlLb6gC0Wa21AdB4QST6WnRnEM8qtj9R3BPuDcrxkuItwJxabz0RJQ2gAG9PvXGsnVEX3aRXZlr90me8hRy/jcLNq0BE7ExOub5Cs14Vt7RvZ/dckvL20MAc/u+SvuPhtjgsokxCjcEb66nW1Zjsln7yXrvUNm6/vz5hQ1lTaS/d9q0Y+mqjD77OmPbFeC0/IQgmDOaAzUYL52s4DXOgiRewiMWFLuYQ0ZzxD4hGqCdb7l4qrbGDEqqazwYnjxD5OmaS1TNXBY/PZ0Fc0y6H/HfSm/Tb+IrlCYP0LivJFKsKhxpGh1v1UgkHU8UyhFMZVCrCTnmPHLWVXv3PkWrc4XiXcBPvWGl9miOzskkCHP8q8hDnvwUhfvfXzOqJVLBxDh1i8kCg0S3cxeI6/9q4EQDUEaOU+neUEF4dUEBpg7eo4flmcqQG3Hgcu/iIdHfXldFpuqsSLT3y5ke3hlA1DkWr9NJME2TDT/rg5r/4QiFeQckRE/phm/eW0rNp9otFTSfjyA+EqK0OvT6msNDK3VAT87ZZcST7ENKeu5kvgaCm4gZwaYbsIPTirT7jpvVq4Zd7y5aHXB+eNdIgs4njRL2c5Bz7qPePVmczFUZRcTR5ZzdhWkoQH4gKqDWmIXk5QsDrZQx0Z7Ma37+/NoFhYbkuFNy41nHrPa0AaJYLPkeUwMuQEcrpErXZf4yZ520sfnG9dD8tTgQ4wzsxEEILCC6TUgvJ+S5Zm5LnehrQaij5ewoPqVr4uT4/bGwKfnwzPf+aMXgCSJ1iZtJev1lGhz8S+xVtBo+MUpjRhy4wak1BRgtXacjHWry8qEpalSN+xI/E
 d/23O4uM
 CjKZYW+BY/By+fqWD0e2XQlom788fCh5iiflRO3+2e5HpumJVtT+kOEV7mkfLmpEGVhAfxe+TohxZi9QVopO8K0n7vV3HloYYaSKVkGKgnJVVDRVZxxVjQmQrM5Qjw15CujG8tv/fyZ7ZDFP9zJmMtC3DI0GU8Ny6/jMDLXN2nUqKjg4uCoLbql8rSo7SA+RSnJuaf1wrInF2b6XggW1k5P0CMYSKQHrDKErv0XLh7MXnmx7J2EmfM1qxYKYzFQ16Gpo4NlnAtR7NhyrZt1RJg5YtkoWbBZpPomvx5LMknZ2zLBCoKSC+8oEWKqwKATJQUwuD41MuFBI7wc0VRfkcyAzxQO6ldamjYDWY9tlFZHe009nC21Rb9yKUk6shElnBFXrVsUPrS3OXyKyrApZttCmfe4ixX8i4aETV0awHv8D4TpU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 1:41=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> swap_cluster_populate() can publish a cluster's table with the cluster
> lock dropped. A cached allocator can use and empty it before the
> populating allocator reacquires the lock. The resumed scan can then
> dereference a NULL table.
>
> For example, CPU1 can retain a cached cluster offset on an SSD with
> per-page discard disabled:
>
>     CPU0                          CPU1
>     ----                          ----
>     swap_cluster_populate()
>       swap_cluster_alloc_table() fails
>       spin_unlock(&ci->lock)
>       local_unlock(&percpu_swap_cluster.lock)
>       swap_cluster_alloc_table()
>         rcu_assign_pointer(ci->table, table)

Nice catch!

I think the real problem is that it turns out calling
swap_cluster_alloc_table() without holding ci lock is bad idea... I
think this patch still leaves some other call site too?

We may instead add a "bool locked" to swap_cluster_alloc_table, and
let it lock the ci first before it does any assign (not the alloc) if
the allocation context is not locked. That is, keep the
sleep-allocated tables private until swap_cluster_populate()
reacquires local/global/ci, then install them under ci->lock,
something like pre-cdd77f84d966, always assign it atomically.

That should also cover the problem reported by Kemeng a few weeks
earlier too, and prevent further misuse. My Bad on that change :P

