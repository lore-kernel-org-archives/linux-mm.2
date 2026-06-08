Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 621C8CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0386B008C; Mon,  8 Jun 2026 07:35:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A14C6B0099; Mon,  8 Jun 2026 07:35:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F626B009F; Mon,  8 Jun 2026 07:35:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7513A6B008C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:35:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 142B21C21D4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:35:43 +0000 (UTC)
X-FDA: 84856540566.05.9FAF2EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 594A61C000F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:35:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UEn4Cg4m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780918541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+mt/AQPoXVlo6YJRcaj8WIglPtUVRoT7Dfgki2X6jvs=;
	b=piFEmyUE5vAFjkOZsJrVTfGm/VkrtHouIlZiMhbauKN4IWGNo0aWTzjO4H1Hyfdl+vYgMH
	DMQN9ikUmf2mrwybWRQada93GOV3VaU6juJNORVpzbqFeuf0Jw+5Tl4HZdtjNJ8bCTF4u/
	n+vABodNmGf9lvp9wFqBZqYCbG8yQOM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UEn4Cg4m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780918541;
	b=4ME2MkyIQ1E03zXhxSFrDVIRlXY98oeieAu2/rpDG6af2nZBzqPVWPRXNIcKXz9IRzuW06
	imUy9jlkusaliE5mTeVdpavdHs+SR0kmYkuVMyCGYxe3ZUWny7pqRbICKFWqFOqyiW3hFZ
	QrKxCb/5bg8wzlQ7pcegluKnBc+oKBY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B8FA41973;
	Mon,  8 Jun 2026 11:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165351F00893;
	Mon,  8 Jun 2026 11:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780918540;
	bh=+mt/AQPoXVlo6YJRcaj8WIglPtUVRoT7Dfgki2X6jvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UEn4Cg4mDB4ZqeEENfhRLZ7CrCWKslv8smC/a7WmpX/Rw+bW6iFuBZ/DLi5ZVfAvF
	 wDI4SpiPlVUscTRteSxgpmAN61p5Hg3FU/KSPU61RVjIlHU7pDEK3IC7n29gYIrXRI
	 oo5+qthlnghCO4xmG5YrKq/cTvL8zsKwETxVQfDL0TQ/LXe4YEP1PsdT9C7oI0R9ud
	 +TNjaw89uQKCcIaRboc76St9sLzDrrrOuGJOkY1cir0WuZsTkTfjyJlrapaS8k5Lum
	 XMgtlY73eBx3lEOMCQAZRMf0Pyam0nD5yT3nkasxPGDBADEoxq+ggL4shNvrZGl2KP
	 u1tyU8EvsjL7A==
Date: Mon, 8 Jun 2026 12:35:27 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 15/37] mm: alloc_anon_folio: pass raw fault address
 to vma_alloc_folio
Message-ID: <aian4VFP8s8aYJu2@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <2e931dc3daa76b57eaedd5b2d3d49f1075797252.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e931dc3daa76b57eaedd5b2d3d49f1075797252.1780906288.git.mst@redhat.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: t67i565uaw65c7p3ktzsfzc1ii7bt96d
X-Rspamd-Queue-Id: 594A61C000F
X-HE-Tag: 1780918541-830343
X-HE-Meta: U2FsdGVkX1+r4cgeAIOtcr0KTZBZMS0BjlN5ZdHDzCEvSvn4L7KuNxb2/K0vrL2D6cFyqQPt/va2/ELCW0azwWhyLItWYsZvzn7799qeZ8R0hjUY/PF2ofIJMqmVUVdDxt4f7HymVvSkEL0cdTvFka/JwY38vKd/txdEGl8KWQ56p6I0inxaO5VmesJEpcq42nwp/UvTfKL1KO03a1bYZ6b1n2zA/mt+LT87TK91ZExE1FBDp8po+eY/rGj+mEMp1G9x6/gIJbbSp7NIiZhTnsJndSGBfi/sTCA48Ri7ZNbCgNfTU1MtQSi9HPKEScWIa/C7ZnZ/nOSkXWSkZUYU5CIPPZzCnQngAb3QKeBKBf4HKsucQQUvCtZh2K/3F+muulXWH+R227War7/RSW0C0sFfy2JiIa8zatVnBs0w4HY+gM/Iib2VaWSHO+4wKw8p1ztzUf8wkeinPZAzIhzf1zJb/GPS2yyWIO7tLl7zl5WbumV7GXGFHgWMX/RDGHjlpddBloPZYWFFOHEY1anbrrxBnSuvbVCkFEzatFgA0RHJMkaZO65tg1lmLsW72cKuttqUHJmXL9d9IcPGrNYFqsJpOuXttsCKlT2yPgkASHlTDCU+O2YbqMspD+eDSYv9weo1Edt9/E+CdTt30HbCIDg2wsy+LY+v2lKQ/dAy08LT4soauRBjejWH6VtS8G34XK3Brge9DhQKZY5D5+9ymeKOP18vFtbyYCjHmlU2KTfrVjnZ912bTflBXmXwn19VKRGKZQHf62LDuOYT912GqVDw9i5AvrlAlnbMs+IuMhd/q5esNPSRXoryTz6WYgAAGJ+0AXc9fmxGfc9mDM/bZrMi3ms96oPbsgGC4VYPoXY/gfJjwan1l6SWTXkxuCGo4wl1COkY1QdYCELicBt7h1RysUtYIqRrg+k+6cDspOjXojVulqsUBX3kD8v9SQp0axBSE0zyNUDvLhKcS0D
 XOOlI7SI
 AWXzn7LcVrLhH7ZDDSaeYwgsrKR+YG8febO5lyj4WxbNv1dtv/a+5LGLN+44YtE6ieWNx1zKyTv16wHexhnyDJaE44Kojx12p4vJsP4riDsNtcoxkhocnz8fwtknZGcJH+RTp3yI00Zue61jPlLh/kfFbqAWmBCDNkPuBmzyPu/ucDOiBCqYedF6e54UdnejhZ4h7T/WPQwNRBpw0OcT9ad4ysaTc5P6+S362hg7/rem0X3jPAAw/1oSniZeqNBymjY53izyyRsZ28giVZUbmkuLXDhKOUmyhXofBm7BscVWVVD3KnMPzmQdC5IRCeB9jnT0LHkh+HPDDeljf0/UZ0p4+fMefzQfMfHUQDxgKHVeITbLpFlUPatJy7dDcfPwxQA4P0pOdiuwZ24swPfmIdvexlyi47F+sE6bGubVs5ozdpv3P92QPM8VX9CduA1Z+aeCyEPgKqrjzwlM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:37:25AM -0400, Michael S. Tsirkin wrote:
> Pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).
> NUMA interleave is not affected: the ilx calculation in
> get_vma_policy() shifts addr >> PAGE_SHIFT >> order, which
> drops sub-page bits regardless of alignment. post_alloc_hook
> will use the raw address for cache-friendly zeroing via
> folio_zero_user().

I'm confused as to the justification for this? You're saying 'make change X,
it's safe because Y'. So the justification is now this post_alloc_hook thing.

But are you now creating a new requirement of vma_alloc_folio() that you must
specify the actual address we are faulting on, not an address within the folio
or the folio's base address?

(If that's a requirement, why is it?)

If so you should update the vma_alloc_folio() description 'virtual address of
the allocation' is not at all clear.

And if that _is_ a requirement, then are you sure all allocation paths are
correct?

I already see addr & HPAGE_PMD_MASK in vma_alloc_anon_folio_pmd() for
instance?

If it's not a requirement, why are we doing this? it's surely useless in
that case?

>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh
> ---
>  mm/memory.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 86a973119bd4..21f640674c4f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5268,8 +5268,7 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>  	/* Try allocating the highest of the remaining orders. */
>  	gfp = vma_thp_gfp_mask(vma);
>  	while (orders) {
> -		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);

If you're removing this usage, could you also remove the silly thing of us
declaring this at function scope then using it in branches when we should always
have declared these separately?

> -		folio = vma_alloc_folio(gfp, order, vma, addr);
> +		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
>  		if (folio) {
>  			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
>  				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
> --
> MST
>

Thanks, Lorenzo

