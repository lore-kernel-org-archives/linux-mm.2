Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2587AF433E3
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 05:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8504E6B0089; Thu, 16 Apr 2026 01:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800906B008A; Thu, 16 Apr 2026 01:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 715796B008C; Thu, 16 Apr 2026 01:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3C86B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:30:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 013A913B838
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:30:48 +0000 (UTC)
X-FDA: 84663294618.04.9706AA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2546A14000E
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:30:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CesJqNnM;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776317447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKdprjO9iqrDHMjwSYEyQPaHIfGiuPJrNzlgJ5M5gfM=;
	b=Z2iJdZUk16vFuWZr0ZgQOKS+OTDfIpqdpCoUjHjwlI6G1PQNoanOAt9bEbBWu5wmrHJGFg
	c4tEZBm18u3+8hLo0HvV6EbAhXztfu2gtXJkpaWT/WBe2mgrvLw2hQNDCUEEIpo1Jr83pM
	JfMoN9xKN8C3mthTgaWFVTjoArvMm1I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776317447; a=rsa-sha256;
	cv=none;
	b=hpTT77FgTNLXZ8UpTSfHvPv8pIxaia1cnXEFU9Z0b2m2v/Af3UpWyRULKdIX2E/Oaw/exU
	b/yLgLBI3ud05oXzdSPV2aQFnCS2DOAbwU5ipXiRtHegOIfqmGMM8xGQdYnzrtLKT8C6Rm
	rEJ/elB2GFxycrOl3XDJB5+KnEDZLYk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CesJqNnM;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5006160128
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1790C2BCF4
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776317446;
	bh=BKdprjO9iqrDHMjwSYEyQPaHIfGiuPJrNzlgJ5M5gfM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CesJqNnM8Y0VrwMy5D4OtnkofFrEL+XRr/Yn7AKVtib8/aaWnnTS5mQzdIgzO/Td5
	 bVIxvjeUT2Us0tjYEKDgeQ729LWtKPMmEBApjL8ttSsTm+2A0PgQvF16GL12taOGrw
	 W4OZv/620q+SJr7yPaL1wrE1MU6IEmEt7jb9O6ehyFYKgj6mLLD8cfnwR//rxIGNpK
	 SBi8ZqjhISWfX8Cik2A4ukv69YaPxAkTyzBmYi3ytTAVNmTUo4LzhYeyJ9dV3HwQPz
	 1+khSHK1Uol49qxjxLpxPmG1T8APEKyAQQKga31WurosStipcAOV40QPjXUU70Dbyu
	 58+l3SphhMY6g==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-89f87257904so61825646d6.1
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 22:30:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+KHm0cO8KXYLOKpNWlokB6Zgim0idOFeOfl/hpiQDoFOC9qRBHulUSC/hirIQpovJG0g+XuQavxg==@kvack.org
X-Gm-Message-State: AOJu0YxAPIOaGSJq+sqFfiHypAKRWLJc1zSe1zv0TRTvQ/4TF9BO66eo
	dpDDm9FgDAuh/BoI2Mqj2W9Df86A5YdZlzFYrD+pTFUsg0JudVUi8cvP3rrZJJvrFeBXFHZBmFz
	rGSBp8rkvS3tF/Vb1bcNWi6jCnXgrbl4=
X-Received: by 2002:a0c:f208:0:b0:899:e567:f04d with SMTP id
 6a1803df08f44-8ac8613a0c1mr388294306d6.11.1776317445207; Wed, 15 Apr 2026
 22:30:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260415192853.3470423-1-stepanov.anatoly@huawei.com> <20260415192853.3470423-3-stepanov.anatoly@huawei.com>
In-Reply-To: <20260415192853.3470423-3-stepanov.anatoly@huawei.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 16 Apr 2026 13:30:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yBmrFDHLg8Cf7x0dCLELBp+kY6yoMuP_sHt4Z1wuVrBg@mail.gmail.com>
X-Gm-Features: AQROBzA247U2xaU38UZDq7xvNkV4HsQyvZYePko41DYVZxoaxkV_BD5AjV-0F4w
Message-ID: <CAGsJ_4yBmrFDHLg8Cf7x0dCLELBp+kY6yoMuP_sHt4Z1wuVrBg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] filemap: use high-order folios in filemap sync RA
To: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Cc: willy@infradead.org, akpm@linux-foundation.org, david@kernel.org, 
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, wangkefeng.wang@huawei.com, 
	yanquanmin1@huawei.com, zuoze1@huawei.com, artem.kuzin@huawei.com, 
	gutierrez.asier@huawei-partners.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5gygmwjqgkh7r9mteas84xtqdqsr9nwd
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2546A14000E
X-Rspam-User: 
X-HE-Tag: 1776317446-755560
X-HE-Meta: U2FsdGVkX19yLtNzZtP9npjBR02/RwCb40PKgbHS3mPmOB5VA69wzKfpi5hf9UCFcbisBh9Jnh+HS9MRiWo+o+s8SaZPby2/l4QJrnC7eAfskd9JEPxY3j5PQjhrYw9fIK6wbIIs0z2FTb2FpcKGW0ge4KtjGGZS4dgyTUpwFsHiB4Y6wgwSov+TRN5QhwsgTOWoqASVTb8DsBt06lHRnRD4y2cJ5vDiydgE0qSVPtO25DFRaBoOolME5zo403VARBumaUMq6LLz9fDMBFJM2LSqrkKmmU+tJQIiOuICzLe3dDGSQZd5006iwLwDxW3zl9vmNxBIx7aWKG0vDH/oefAQCtuzJYHFZzrdQEkWVHwzOrm7Eoe8Mio/2TNDYBTXyb9YS3PRzlq2T34ZFoWRXF1X4eol263VHaIgB5aIbw9nMU9UyivExqHYABe5EKZAt9gED1HCWolaDai8+r4AY7Ih6omvtJj1R/a7jzv7xcp9SDzDcH321z3vLBpMOMSb7y9gT9m5PYej5PFNYRcyKKoluYom8oEJJiUfpF4yDu4k7Ox1XBGJvC7BczNOjp3QiUMN52gbjpl/dS8uZvEsPJMRLCnRQwJFLyDCNpjC3v+C0dJGmI6UjqAlPJaxcbL+vt9/YbZBXdVl6S4uwbxn126zA7oRW55I963GZBKieODHXErXrIYECL/I4xEoJQdOSFGbXygPiHEorhcxBnWNnyzWELyk+IWp2sohc2CSXbxjCx1EAb0FtGBF9SXHlDO8JJEXBnXMuc+0v198gf0yyHXbjQ0KgvVDHPv2aJHAjoSWYe7DmWQeL+PpPp25f5JLGmn94rxmNhbm6RsPvqDUqSAkk3iq7Xr/g//0nqNPBjsr53Uh5gT6lqZ1XnOgJgqCgjJHddmbQJlSGIir+bRuVzHGOgZ/lH6vWL388QP+5sfOTIZC2udmtBmZKMteua+76JjqetS6KzwsVM9J4h6
 9NjEoB1e
 YOiMPqy558wobdm7qcLeQABE6lJYS/KN/1ZRSjqQBW4EWCt6t0ns6G3lion/zVs09M7/+rhnmZwjm4E/ALCshczqGaoV9MCtTcABR1fqDnFBcHSVzHF1/NNrCdTPl0TkpRtHcX8mGH2tMRbug2Sd+YSZ+1GhEHbsZryybgfSaBDhxZGDlumCBrMGb2BVI7QudA6WU79G2U3o9XplJoKkjXWLyn3Q+XtB135u7L2fQC81vZq1GdhmiMD10f6Hm105fgGW4ZXTIPRSERqPlUTYwd6gFT+2H1GUqPFAfT/h2vtTO8irA19I/GJ2EjY15+ILf0ZJty4i+S93o7tqVJUrHRuO5TdSVpHKjUvuu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 7:47=E2=80=AFPM Anatoly Stepanov
<stepanov.anatoly@huawei.com> wrote:
>
> [Idea]
>
> If a mmap'ed file being accessed such that async RA never
> kicks in, we might end up with only 0-order folios in the page cache.
>
> if fault_around_bytes is larger than 1 single page, then
> it's beneficial to use high-order folios, which brings significant
> filemap_map_pages() speedup.

Please note that there have been many complaints that readahead
pages in PF, as well as fault_around pages, may not be used later[1].
The performance of filemap_map_pages() is not really that important
compared to pages that will never be accessed and could otherwise
be reclaimed. With large folios (=3D fault_around), a single young PTE
can mark an entire folio as young, which can be quite harmful to
real workloads.

> So, let's just use fault_around_bytes as a starting point here.
>
> if an arch supports PTE-coalescing we can get more of those for free.
> (see arm64 example below)
>
> We don't save the new order to "ra->order", so if async RA will happen
> it would normally start from order-0.
>
> [Things to be discussed]
>
> But at the same time, i can see drawback for 16K, 64K pages, in this case=
 fault_around will still be 64K by default.
> In this case, it seems makes sense to make the fault_around_bytes be like=
 order-N of PAGE_SIZE, not fixed bytes number.
>
> Another issue is - when fault_around=3D0, but we'd like to use high-order=
 folios for sync_RA, for cont-PTE for example,
> For this we can use kind of "max(fault_around_order, cont_pte_order)".
>
> Or introduce some dedicated tunable like "sync_mmap_order".

I guess we could benefit from a small order, such as 1 or 2.
Order 4 is really too large for many systems, such as Android.

But it seems Matthew never likes new control knobs?

>
> [Benchmark]
>
> Simple benchmark below reading 100M file in 4M (RA size) chunks
> such that async RA doesn't kick in and the page cache ends up being
> filled up with 0-order folios.
>
> The patched kernel gives ~3 times increase in throughput,
> considering the page cache is filled up at the moment.

If we consider reclamation, it becomes a completely different story.

[1] https://lore.kernel.org/linux-mm/20250916072226.220426-1-liulei.rjpt@vi=
vo.com/

Thanks
Barry

