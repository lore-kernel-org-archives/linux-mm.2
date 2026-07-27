Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE86C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:26:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF2816B0096; Mon, 27 Jul 2026 11:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3696B009E; Mon, 27 Jul 2026 11:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8ED6B009F; Mon, 27 Jul 2026 11:26:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FDD66B0096
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:26:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0916E4077D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:26:22 +0000 (UTC)
X-FDA: 85034933004.09.3E92B06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2BA494000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:26:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XiI/SW+m";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785165980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPb+kzeoUnXF98fDEQI+NU1Jrx1TcODK0K85tqr76eo=;
	b=XIz9bT+RwXdCQx7Difq8dWQiWt9+lba1fkIBGTxdpzXEO53wYD3ZILGZq57mpYYBgwtVEC
	dg+eHN86YTDJ7ru9UAlX3fKrlumR8zSYo3qHK2Ht79qZrF/Ss27AiqIzDl/AoZzsHgATuk
	LDG4r24PkTtnf7erSfEx0rjuykUrfr4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XiI/SW+m";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785165980;
	b=3FLNe7Dp8LqT7fWrGGve/FZw+lMBGo4EsI7bD9NKC812J52PYEgYM5ciIHIOQR9lc9zWe7
	sDkSLWi+m0A3h1KLVAzx/foUdJD/JqOs7h9eJcn5lgf5YccvdgXSm+8DddMWhjpeqMLEEV
	3i8BKU1fbaMbFTxHonajZ4Tqy9hXZOY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EF2343BA0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9331F00ADB
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785165979;
	bh=hPb+kzeoUnXF98fDEQI+NU1Jrx1TcODK0K85tqr76eo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XiI/SW+mgfr4KX2b8VHbawXl9I+JK9gWQpUB3BOdvdTbUE2c6QgsN6wexRgURbPIr
	 80/sAH6/aFDnotaD2xBkS82mCKysQQv6G6cNDph+nPqP7WSRshDy/nM6zmDyIZ44uz
	 dGP4aqOvqQ2r+IZSEDUeQxz6OOZCojR/6PmX2GNnOr9h1b+WQkUb05v8ZdcnYpSuLZ
	 t7UgLfzdzJBjNR0CFM6HzslUmrQLbGBXneeK/6dbfoUG7BOnqRzRn81hFGXYEem2p6
	 qxqdMD6z3oosQ22TXTnNzArHA6tr8Ya4/SgdMppn0YTBeIy5tVDLY7BLl/v9HPj36W
	 EwP6q3keAEMOg==
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-81f64e8dfbcso31222817b3.2
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:26:19 -0700 (PDT)
X-Gm-Message-State: AOJu0YyGbC/zK4ARb6U/qgWR9Vno6LHNJ0fU6iWJniGAWjpgA5T8ssRN
	pTzqvE/bcmLl+kJqwuZm1zi8mvHXN0wy3QNrLKvxxAyzBIQJ+Us7mNytFNw/NAL0JLd8WaBdG4t
	wvbpycDoL73AeaZnQqqCKozDADV8oD5hDv+tpNaI5RQ==
X-Received: by 2002:a05:690e:2502:20b0:668:99ce:a035 with SMTP id
 956f58d0204a3-668c7b87048mr1868066d50.75.1785165978420; Mon, 27 Jul 2026
 08:26:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260727135029.1059441-1-baoquan.he@linux.dev> <20260727140503.1060918-1-baoquan.he@linux.dev>
In-Reply-To: <20260727140503.1060918-1-baoquan.he@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 27 Jul 2026 08:26:07 -0700
X-Gmail-Original-Message-ID: <CACePvbU7ih58GHW46Wr59uUdo7wnA6c6Nd98oOdwUzi3BGF0-A@mail.gmail.com>
X-Gm-Features: AUfX_mx2Jud4mQLY2sdlWkG7iyjlYfeISg951bsj3TKrTu2zctiQCcmHApX2umc
Message-ID: <CACePvbU7ih58GHW46Wr59uUdo7wnA6c6Nd98oOdwUzi3BGF0-A@mail.gmail.com>
Subject: Re: [RFC PATCH 02/11] mm, swap: add CONFIG_XSWAP and xswap fields to swap_info_struct
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, nphamcs@gmail.com, 
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, david@kernel.org, 
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2BA494000C
X-Rspam-User: 
X-Stat-Signature: xzdfibd7s35jofffaxaopqfy5umok8hw
X-HE-Tag: 1785165980-564421
X-HE-Meta: U2FsdGVkX1/ZtRtsjOa3ZXti7oQn6UuySEdB5i8foP0nBWoSEMy2ABYifnKvPrhsQRFL4HWkKJ+mPjmV7lqXSH8zy3HJ/MwsCGUy3RIorzD2DvEt89SbWqo9Tl+3EDIh7HiKpKCbc+l2MdcKovjlKmE/7CLQoj5F1wJDdwGd35UKv6fPDC4moHIds0/q1Z/83PLx80tkHxul1SmZjlh8owChAWnX8UlJCMAg6VnkWMhDSlPhQQ3GWt92pgwMCP0u34tFW7iQ3qvKvXaCaosiq+KKS2A0txwU5MUpzol/jgTBPbnyRJpqTzwnA53uFtPjnprgdEJLvX1hUfZihju8hDuWwrCll8VesE+fXgBlDdWCckUVFTOYwqwLY3ZaDfNmfncjoH7nNWYS2SKBrxci6o7gjDRNiutK4TYodcyrbuLdLHOjQDPZYsgfrtX8mBZ6K383YZsckq9HCkQiYJvB49o4fYcvzF73q5z4gQ9zKLq/AfB+ppPBD3SJr+U0EdTWN5r7xf0UaaKXQKcO/VHQ7D9QreperCTN2TM1W0Awupx1mVN/w8wcLAGlt671kIoq5gZLQADTA2cG7ojik8SJ/roTfRoGgKIVhRPA2KNKDg62X+m9EItyQIglxfZBzOamA/iLUNx5HD8WjC6m7Kc4f/hWuDyrJHsYc58ef43ZQ5xerQXIfddsznsSDTa3XiDRlWW9ablzZJUyQh1B2dy0UOt6J297ZxF1h4JG6B95xOxfbWuRn42hM/QNPdJQZ+xJSzU+m3MG12SSf05sCG9YcJqkJCsbo756WeZT1cxQrcRUAJGWJTfZrXiNQjVk/zY1RIOxORM6lz11Mx9BVa17qLC1j6X136itj3TwDmQqadOeMvaKKAxqM40CqlX3DHZuIw+Bqv4g/wFQ9vExWfADZ61Ax/QiBkjxxndLig0xBY7eKwRzPlccj3KZsEPif4gDwqVkb5CULQR1/owYGPT
 EeaFlC0L
 LwhXEK+avvyuR0vfzJYbT7YQeuMGdfsPV/vP4bXcxIuN7xLeSOGuDOQ1TJ+FVmsWB+bl3jfjBB/binChOAGDnXlKpBMqluAc7UkAkjA4PoCgnz6FJbeq4D8UprjQ9tjZ4D3afcuOLI8BJ7rhm2qOpyS46V2XyumE63+jXYBVjEcGLgR2RMjoRP5LW/1kPgtEQomEV5dgBIdIpAJH3saH7QIEmsE40VMD2o/w2JYnoAxHPuGQ+3R+neS/B530qm6RCPLRFsbRt4YYqRV7odjaFITnbgzekpqyHq1VsqOJdWL5L+xrdZG9RD6J6ZcgSu50fmeO4tqP0Qb25KBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 7:05=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> Add CONFIG_XSWAP Kconfig option (depends on SWAP && 64BIT) for
> extendable (virtual) swap device support.
>
> Add three fields to struct swap_info_struct under CONFIG_XSWAP:
> - cluster_vm: the VM_SPARSE vm_struct backing the cluster_info array
> - nr_clusters: total number of clusters in the xswap address space
> - nr_clusters_mapped: number of clusters currently mapped (lazy grow)
>
> These fields enable lazy vmalloc-based dynamic cluster management
> where the cluster_info array is backed by a sparse vmalloc area that
> grows on demand and shrinks when clusters are freed.
>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  include/linux/swap.h | 5 +++++
>  mm/Kconfig           | 9 +++++++++
>  2 files changed, 14 insertions(+)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 80c83dd8804f..5f6b14d30758 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -248,6 +248,11 @@ struct swap_info_struct {
>         signed char     type;           /* strange name for an index */
>         unsigned int    max;            /* size of this swap device */
>         struct swap_cluster_info *cluster_info; /* cluster info. Only for=
 SSD */
> +#ifdef CONFIG_XSWAP
> +       struct vm_struct        *cluster_vm;    /* VM_SPARSE area for xsw=
ap dynamic cluster_info */
> +       unsigned long           nr_clusters;    /* total cluster count fo=
r xswap */
> +       unsigned long           nr_clusters_mapped; /* currently mapped c=
luster count */
> +#endif

We might need more than one dynamic kvmalloc grow array. Maybe
abstract this into a struct so it can be reused for arrays other than
clusters as well. The abstraction can also include the element size so
it can have a generic function to calculate how many pages it needs
for N elements.

Chris

