Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35098606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 03:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N1qZdOF3
Received: by kanga.kvack.org (Postfix)
	id C90FD6B05B2; Sat, 21 Nov 2026 22:06:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6F446B05B4; Sat, 21 Nov 2026 22:06:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5A16B05B3; Sat, 21 Nov 2026 22:06:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9645E6B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:06:09 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D115A81A4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:06:09 +0000 (UTC)
X-FDA: 85461266058.03.C6D6083
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9C18DA000A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:06:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N1qZdOF3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795316766;
	b=Bgo5ukDEYtbA9+QSyUzm+vWrKxTYlyRteYBesD2IV5TWO8VdKNPEetOM7QMARc6q16wqqq
	WIEFKCeqf+uhWxqcoy5E149OG5qAwP/AHvoZk5rLutbVokLau/PSxY6c6tF+B1cQRxtUJu
	OHqRQzFYd/M3oCzhwxMde05NAIOoXG0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795316766;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TRE91LYUdfG+M5qRQb0nv94l0WEHNX5UCCRKqMv/OYQ=;
	b=aJbZMVRrIerUhWwTUvWuTgx6vg+BHsDxMetyvW9/9/3U1pOOEphliOF/PvVHAe8ZFZMfwb
	cAIvtx7FGULfoveUX55Yn6y5UQ7wG+NqbkWY1CgH1VZvcIMCFvCbQ/5bLHCraSmZTeZAVv
	gt2VU2v1vq1nKO7HSfDH64hBrz+FgH8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N1qZdOF3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 536446021F;
	Sun, 22 Nov 2026 03:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA2B1F000C6;
	Sun, 22 Nov 2026 03:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795316765;
	bh=TRE91LYUdfG+M5qRQb0nv94l0WEHNX5UCCRKqMv/OYQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N1qZdOF3dotBJmOxF9Pc/28UoSJkVsQVp0PfunYifOQtYJnZTaJggRQXaWfJ78MaR
	 nSrzEL4UyJ9Z2H6tRrNEmriDLgrIRw87v/PYOYZqoy/FUCRVj1lIKr0oDlCAT2hoNf
	 4jxBTltuj0JT71xO39JMsb9PFapRXHJgvwW/PnxtLTtK+GLVA873IyYgZeub4L3U/c
	 D+k53oOQoexedacGEbGB6H4GS4xPhLterBel/K+Yn3R9/BK/nMd7xUekLEaaIapdYF
	 J/JT9xfzkq7urlFzMX+nVD3g8JL2hYNzzigZCM3pkJtmsKxMuijPVy4ePYROb6fCXw
	 3KThZWzxXioBA==
Message-ID: <sashiko-outbox-227657@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 2/7] mm/gup: handle memory.high overage while
 populating
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shakeel Butt" <shakeel.butt@linux.dev>, "Tejun Heo" <tj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Koutny" <mkoutny@suse.com>, "Christian
 Brauner" <brauner@kernel.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Jan
 Kara" <jack@suse.cz>, "Matthew Wilcox" <willy@infradead.org>, "David
 Hildenbrand" <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Zi
 Yan" <ziy@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Meta kernel team" <kernel-team@meta.com>, linux-mm@kvack.org, dsterba@suse.cz
In-Reply-To: <20261122024737.2741569-3-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
 <20261122024737.2741569-3-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 03:06:03 +0000
X-Stat-Signature: o53tkpq6x6f1jmhkyoizutgy1pde948p
X-Rspamd-Queue-Id: 9C18DA000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795316766-192724
X-HE-Meta: U2FsdGVkX19SmoYtTpFzGCmgIBppMmRUhsZFfM0MKpvMqeBq710i5pEH39NmVZC9YKcjUUEpLw+MdOof4dgg70rI3hNfv14Pdz8dKenngi1euxP+9DILeeyAkCLre582YwEZgVE/vkLhoZqVWUrusIfZVIqcpV5xF22vsyMs+u3vxDN0Gsdde+te0viaF2gvti9+VdUbYekYXR5kLEfrt8BzVifTs1hKVntADp3LceY7K4YnIkDpz1MyjSdt+OrMr2yDwt+RcrVt77ph7qTEJoUqWZj5TS/L5+waSHExgxETTuYZeksGyr+EQVmyj+awpMyT7CPpeZkxKWW/kfIWefICuoYeucja+WVsNGe3bEhJz2hxa4QaVa12gWNTxf449R6Dxq62TmYMmnukr9xynb7WUgBaBl52jXmJpZPLgODp13xVI0kZJs4HCJ7LQdls4jnCbuQOz7HJ5rSsFiRedZSb2vncMI0iWs1dtI9fpkxB6AT1PYW0l81J4tDUY28HoVRut+cBP9fqnhrkh8W4iEn3PH814Nm6lPLHoi9hY3iw3507D39fUAwj/pMTBW2Lxl0JBqMvSSs46xHb/iJi749gS7kDC5uVj1BoQqwRNRGWj5MLBoljSohyV9dxymmJO7b56JOzQVdhz1Lig34XOpPOUfwLYl9KI28XACOTfkWP6CFiojAJZONnxGcSJUgefKt4IJTkPqhB96OQSIaBTIaSkZTegGZXTIU3qHocIwuKjAVYRrVCxlJ8sLAjBopw6Kv00kRwgv4oGm4SkO/a+gwZMNwruevwUg8wUvKI6SIgRWAbwGcK6AItO4jm8FN7chP4odaV8LJe8jYeSMQWaXlhXP8HUgGdGtRAxqVPct5uLH29CFmFSor+HNJo/jyD5m7qvWU5/ZeLjPJ7JX71/6OOmS+gkXmWdUpqLXC6t8FDywfqkIkj0NkGl1BitrNc6nDT/hRvksYiffTvOiB
 SBTR5RMw
 URmoxvVJZRNkZgEjJSvHmcUnkQAlcZfXbmYBEj4yoYOGgib+HSgSfAl8/R6gGnV40AGBzakQWHn3iSZz7bz3LqvRJfFEqaz39gFoXqXvkqxN/2tkMDTqhZ2cfsVAsEOHsrrIDK0cu9iXiDNlKzhUCNyciTLTAVA1NKN0SDefzOtuMrCn+XHxwmkOC6PmPNJYqTjHYU2E4IddZoNFHGp4DQ+4i5C1mQg9OUHin1WlZ72nNHfV2LKb9iPRAaTHoJ5Y4JBBM3wLbA53BrcXGDyiv7PdV2wj6DCThmEyQXK48MRs7doa9sVWcEesS4US1DeswqGb+wVqFsUJXMtu3DvJSb3Kmxe4O9+nlkBRT3Np1PXJR4BeU4iasnkpG0xIUNWP6Wx64OEm7kW0PlJ1KmfYBmmNY68k7ubzjUtekkRG3xEo6n+06i6KorOvWgKP3mJaqQN7vriLQn8l9PGa6XyeYrfHy8RhryedqnKPtOje1tThqPpVbIP5kOa1Pfn4xXtT4Y5RgzRhX9nwV984DESYHS8bmFpnTlljQW4DFWwftYe+S4J5ngCtUoiacPn++kMbRKeApWSByEBapfmZ9XjzDE5te0B3qc2v+cT8M8YdjMyTiaHuc9oAvA/qDhEsnFGtYGvdSf4XAt0GK/JZHH7vvBWawbTVx6oj5vD4ebEVuA67eMJyhF1gjRzWyTrhUHgGJkOog6oD9ef4nMhLYVzkCuyAOEZivIGI2kZxs7qZbfl5PbHbZ6LR4lQWmwetp5zFRmQiHoW9FATsVTlWGVfgx0v07F+Xzj0LjQ9YD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm: unsigned long overflow to 0 in populate_chunk_end() near
  top of address space
--

commit ec48ff5e44f8914e2b82f0cee190a74feb7645ec
Author: Shakeel Butt <shakeel.butt@linux.dev>

mm/gup: handle memory.high overage while populating

This commit chunks page fault-in loops in __mm_populate() and
madvise_populate() into 2 MiB ranges and drops mmap_lock between chunks to
handle pending memory.high overage.

> diff --git a/mm/internal.h b/mm/internal.h
> index de4593b3e3b60..12f7b4b1254fe 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -948,6 +948,33 @@ extern long populate_vma_page_range(struct vm_area_s=
truct *vma,
>  		unsigned long start, unsigned long end, int *locked);
>  extern long faultin_page_range(struct mm_struct *mm, unsigned long start,
>  		unsigned long end, bool write, int *locked);
> +
> +/*
> + * __mm_populate() and madvise_populate() fault in at most
> + * POPULATE_CHUNK_SIZE at a time, and handle memory.high overage between
> + * chunks with mmap_lock dropped, so other tasks don't wait for them.
> + */
> +#define POPULATE_CHUNK_SIZE	SZ_2M
> +
> +static inline unsigned long populate_chunk_end(unsigned long start,
> +					       unsigned long end)
> +{
> +	return min(end, round_down(start, POPULATE_CHUNK_SIZE) +
> +			POPULATE_CHUNK_SIZE);
> +}

[Severity: High]
Can populate_chunk_end() overflow to 0 when start is within the top
POPULATE_CHUNK_SIZE (2 MiB) of the unsigned long address space?

When start >=3D ULONG_MAX - POPULATE_CHUNK_SIZE + 1,
round_down(start, POPULATE_CHUNK_SIZE) + POPULATE_CHUNK_SIZE wraps to 0, so
min(end, 0) returns 0. Passing 0 as end to populate_vma_page_range() or
faultin_page_range() underflows nr_pages =3D (end - start) / PAGE_SIZE to
(0 - start) / PAGE_SIZE, faulting pages past the requested end boundary. If=
 a
VMA in that range has VM_LOCKONFAULT set (for example, on 32-bit parisc or
64-bit s390 where TASK_SIZE reaches the top 2 MiB), populate_vma_page_range=
()
returns that wrapped nr_pages and __mm_populate() computes
nend =3D nstart + ret * PAGE_SIZE =3D=3D 0, looping forever from address 0 =
with
mmap_read_lock(mm) held.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122024737.2741=
569-1-shakeel.butt@linux.dev?part=3D2

