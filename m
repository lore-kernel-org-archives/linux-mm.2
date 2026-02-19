Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2525FE9A04C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 09:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82DC56B0088; Thu, 19 Feb 2026 04:45:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DBB86B0089; Thu, 19 Feb 2026 04:45:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B01E6B008A; Thu, 19 Feb 2026 04:45:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5660B6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 04:45:36 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15E09160483
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:45:36 +0000 (UTC)
X-FDA: 84460723872.19.567146D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id B523E180008
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:45:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dFxhBMuP;
	spf=pass (imf16.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771494333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jc3i9FwjGQs8rH6ZGdIFq1/g5A3pmIExt0aTpd8WwbE=;
	b=7hWtWwRTEmJcRPfk0Xve0QR9hcN/EGhPcpg7SoXQsdDx2Sbgt6eS5vNddtqosGBCr6as3P
	hh0oxLJvFQBX7dWtCgCZEUFDVPf+ZdwJP3WYb2kMBKVhU/f6ow+skq97T4GJQJQtXF2z2h
	aNvMNq98rsF3gtsMyoTDB1EweFYFBaY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dFxhBMuP;
	spf=pass (imf16.hostedemail.com: domain of aesteve@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771494333; a=rsa-sha256;
	cv=none;
	b=FH4wUfEjg/6FnQIsjYeWiy/tQsWBgLA8ab5SQiWPvW7TZnYt2hIpsM+sqPYwrXmS1Kyia0
	nHuBeV2AYO35K70sr1vpbMlcEvJ3wV4MrVOP3K6hGlwCQJpbcqlCYVt0EgkwFy1cyqzESq
	vaphHbOm3CY4oRkbhO/ClyxIQxGjfZY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771494333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jc3i9FwjGQs8rH6ZGdIFq1/g5A3pmIExt0aTpd8WwbE=;
	b=dFxhBMuPj9glkz+Ecbx4ytyjc7G3tcNVv5NAhD5j2tds1y0KcKMUVDmhtWjFw7GuwaVIFR
	sRqmudR28bl1sZJlxe1+HsTLPicPaHAouWfDYt64wj6+Ff0IsYzj13ygp4VC56/5xOBqFf
	ti2szQmnYU7AiCIanZVeVgheh7OU7/E=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-_ibK0OeQNnmj_7iEI_qSuA-1; Thu, 19 Feb 2026 04:45:29 -0500
X-MC-Unique: _ibK0OeQNnmj_7iEI_qSuA-1
X-Mimecast-MFC-AGG-ID: _ibK0OeQNnmj_7iEI_qSuA_1771494329
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-797b0076763so12488497b3.1
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 01:45:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771494329; x=1772099129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jc3i9FwjGQs8rH6ZGdIFq1/g5A3pmIExt0aTpd8WwbE=;
        b=S4ttRy0Z7EqA1T0sD/laYlQjjZtPDxqJq+sCM8nhvSdjSmzX0s9wCyyBfGM35bWrnz
         j8DI0aZ6gxoTAwy70DT4usa/jk4u/o3t/M9yVczBxp16Ajrwl/U3ZkTXagjtFTrlwSel
         vuctcpw1vLmNqQ8YYoe9DnDhfrs4R2vu4EQ1VEE0dZtWq7eDs1+3AqHEfj07IkpzMwal
         lGv0XrDqC2cXmSoEGztD2hc0jnCnayBpA4JcwZMxhRbM8fiFBumKP9Ov8nLSEwDWUa0S
         30PsyNEArBZGrdAiS8LGaoW5Lz09zdUnkg9RyCbZ0/+u4ad5BvOhbZ77NhAVvFJ4jfqD
         dqgA==
X-Forwarded-Encrypted: i=1; AJvYcCWn5C6tHveyOYiMQXlJvdwgl2gWg8+XE8sfkoiVIAPQ9c3agKHSehHny6sz+40tBaMNqBA4zNjLxQ==@kvack.org
X-Gm-Message-State: AOJu0YyFyuRHGQ4e7/deu6Z27rFRsDY+DCuzeXBKV/C7nvds1Ide+qUM
	6+0xtN33PAvZCoZ3m9H/N/exQcQYaslmD2+CeDNqtIFSEmCUK7FlBB0MyHFAHs7JvgdLTbr+k4e
	ooOIXUn55Q4TO704y6yDvKsd0JkVKeIeC2tdS9T35JkrSOlrR8t0umSZcKFOhiEj4P/7T6OorJK
	MeBebuSTey2Fa5ngtcg4oVNKCLfh8=
X-Gm-Gg: AZuq6aJis9vz8ZOb9dksHONbigMibb6auZITGnwEz9ZVEouCtRcIknJ1d6HfmNLS4PQ
	9iy+hP73KBj3oarGxFryknNBDOr0XC9aV2J9f489P0zhSOFin2V3n/7aUsakLFFBwiPN+Y+E0VB
	1wpPKmVCYB41dcIyGHLFeAh5KLoJNYZ/5Cl9oa1wdwfPUtWg94yea6Jv226dKw18pR+zGgP7/fn
	g==
X-Received: by 2002:a53:ac83:0:b0:64a:cece:95f0 with SMTP id 956f58d0204a3-64c21b189b8mr12656985d50.61.1771494329173;
        Thu, 19 Feb 2026 01:45:29 -0800 (PST)
X-Received: by 2002:a53:ac83:0:b0:64a:cece:95f0 with SMTP id
 956f58d0204a3-64c21b189b8mr12656956d50.61.1771494328829; Thu, 19 Feb 2026
 01:45:28 -0800 (PST)
MIME-Version: 1.0
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
In-Reply-To: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Thu, 19 Feb 2026 10:45:17 +0100
X-Gm-Features: AaiRm51_qfw3XQOH44zsawVMk4430XcLLbmTSpOFr53O7yUQLt26G4MawVh9oqo
Message-ID: <CADSE00+6Jnv_R69nrWdakX2StNK058ksxva48z=ZnwT=Zr3UOQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] dma-buf: heaps: cma: enable dmem cgroup accounting
To: Eric Chanudet <echanude@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, linux-mm@kvack.org, 
	Maxime Ripard <mripard@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fRzXzvpP8cTTNR81QvD6OzwbJ6Dwnth9eqZAMJB6JqY_1771494329
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B523E180008
X-Stat-Signature: 4ycthtma86y1px3xmhg4au4jrhiqp1o6
X-Rspam-User: 
X-HE-Tag: 1771494333-25494
X-HE-Meta: U2FsdGVkX19gw88Ot+A834WOaG3gzSj47ca7/TKe2yja/1JW0gI3VaUVZn3YjriQ7wbqaevKuiuEJJ1VaTmZ4cAD8FNXHkh6Az5hLMFF1f7PMsDirCkl/YUQAtZBXeq2NPfBFSwcpPKS9SwRvsFRMkBXckQ7sdcW+Gb6BAl3prGMB+9FXFw6iLNA5qCmrF0EvR3bBFO795itfYh/4/fPBu7HZf3W/0YuD5zW11hY/kjfewMWC5fTRnf7IGzF/Hjl1hAYKtqInbUYx5r6L1AqZfA8WgnmfPRjvOXfG7kIVnu7oNr/eQF6TDd8b7fxVu4iHO2kwn7RBhPSNNbcKavplAH7kyeG3FfC+QSvs/avvPOX/z6IOvDhbZdCQBK0mfHeIDw+MaIGf5jWOsZIUiWLeZWdUchhWE1zh2e9qhTV4Zj3P8bgSgEsA+ZcIqVqVAAb+ntLXMTemx5X/LtNDKVAq8j2gu3emduXXDMw4lHuUhlupBT4yrRaNTHo8jzn/RO88UOQYZNaIu8CrXM+7mUFeCHGS8EJZg1gIELAEpCREKweeXhaRIGOXIcfqigrTHgWCrHWi5jxnABpACeZVVQjMx9DVaCHgfAmSFsArWvzN+tw3m/a8KYxJo59/myjTNwowRjp/ziLLfMJfNoAOHgF1r+sx5S4KHOMFXdIJXYynnhao2mfLwSmG9V8g2/AV53lkpL3rxs5MN/unt1c9I4aJyYsP7A4S8i7xGlYe8J1Up7k7C0BeRQjEXrx+9lcybDAvNlJP52ZgudsZvAvh/wYE2/6GUgTA+Tc+nMcJMbCmvMG30Ra31IC5jSasxMVrdz9qb4t7Kfkwk7vuzkUUVzZvyPcpLhLdfAYvq11/3ws7oSCEK48uckliFOBUqMvhmLj1k5d4rk/Oa8laOLt4nXuNIkTucov2FSi8t2ba47qPrSBKuB5rXvv3snOYLOxz7UsNXThWFHLVsO+0/Zi0y7
 OSZ5AzAD
 raJG9F8o8magyM7XIjU8DoximmYnFy6hSMXv2blZDzC3LoydnCubhHvS4qM97f0L5uUULQBS2FBmdLhBNeUobDqNjmApO6IK3tlW7SvDgTivd6nyVNB4aGmSqCnpNOT3IYZ5mlfHYhdUTJo5c/KAl1gUF3Gs25YuMWtq11t8eU3uEXvFnkVgyZMGOziYu78CxMIBi/B6PvAUKLcZ6JnuxBB5iEJdMfgVeaWOYcj7Cf3xaTkbgxMH8qel83AX4gcJ9Kyxa6g0/mLh94YEHSpvQgxfHAbokgC87Jp34mOE3KlC7pmiQFKDZCCYKrruzFgWbFCLTKPHwkdtn6b0B7NoBIFIJcT2fLrrQi0oI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 6:15=E2=80=AFPM Eric Chanudet <echanude@redhat.com>=
 wrote:
>
> An earlier series[1] from Maxime introduced dmem to the cma allocator in
> an attempt to use it generally for dma-buf. Restart from there and apply
> the charge in the narrower context of the CMA dma-buf heap instead.
>
> In line with introducing cgroup to the system heap[2], this behavior is
> enabled based on dma_heap.mem_accounting, disabled by default.
>
> dmem is chosen for CMA heaps as it allows limits to be set for each
> region backing each heap. The charge is only put in the dma-buf heap for
> now as it guaranties it can be accounted against a userspace process
> that requested the allocation.
>
> [1] https://lore.kernel.org/all/20250310-dmem-cgroups-v1-0-2984c1bc9312@k=
ernel.org/
> [2] https://lore.kernel.org/all/20260116-dmabuf-heap-system-memcg-v3-0-ec=
c6b62cc446@redhat.com/
>
> Signed-off-by: Eric Chanudet <echanude@redhat.com>

Tested-by: Albert Esteve <aesteve@redhat.com>

I tested the series with a Fedora VM, setting the global user.slice
dmem.max value and then trying to allocate buffers of different sizes
with DMA_HEAP_IOCTL_ALLOC. Exceeding the max limit results in
'Resource temporarily unavailable' and the allocation fails.

BR,
Albert

> ---
> Changes in v2:
> - Rebase on Maxime's introduction of dmem to the cma allocator:
>   https://lore.kernel.org/all/20250310-dmem-cgroups-v1-0-2984c1bc9312@ker=
nel.org/
> - Remove the dmem region registration from the cma dma-buf heap
> - Remove the misplaced logic for the default region.
> - Link to v1: https://lore.kernel.org/r/20260130-dmabuf-heap-cma-dmem-v1-=
1-3647ea993e99@redhat.com
>
> ---
> Eric Chanudet (1):
>       dma-buf: heaps: cma: charge each cma heap's dmem
>
> Maxime Ripard (2):
>       cma: Register dmem region for each cma region
>       cma: Provide accessor to cma dmem region
>
>  drivers/dma-buf/heaps/cma_heap.c | 15 ++++++++++++++-
>  include/linux/cma.h              |  9 +++++++++
>  mm/cma.c                         | 20 +++++++++++++++++++-
>  mm/cma.h                         |  3 +++
>  4 files changed, 45 insertions(+), 2 deletions(-)
> ---
> base-commit: 948e195dfaa56e48eabda591f97630502ff7e27e
> change-id: 20260128-dmabuf-heap-cma-dmem-f4120a2df4a8
>
> Best regards,
> --
> Eric Chanudet <echanude@redhat.com>
>


