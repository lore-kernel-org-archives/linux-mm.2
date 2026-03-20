Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E7361099B35
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:28:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11C7C6B0113; Fri, 20 Mar 2026 14:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CD886B0114; Fri, 20 Mar 2026 14:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F259D6B0115; Fri, 20 Mar 2026 14:28:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF1086B0113
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:28:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D6528B28C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:28:32 +0000 (UTC)
X-FDA: 84567276864.23.2CAC63F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0EA9E40015
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:28:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gkHt0MCc;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NttFtymD8x5IkIE47Y3LvszodJUvEpPL23VFH4Wm7xA=;
	b=3ceg7YM/+Xx3Oe25/c2b21FzFNWlnLUqJsHPsZ7BybcItdFvqK+m3m2JVQ4ey66QqSW/Rd
	EG14wR4rLWiIXhmGMqrbdtomXi9kn0RyM8FXQ03jx1agP0NZTC3V1QGxhHYANTQT9PXhg9
	ApMUgY6ooA9yLvXdADd0SJHt5o5OKuo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031311; a=rsa-sha256;
	cv=none;
	b=iDA537E0fwQP/yrY2rRFJK6nLyzk1/SqvYZ99zLDC1vyhnsV5kq6nEtO69Q93DZYZ1W5Ri
	h3K8RibTROgV6aWZAITiNFyQeV0PvqIowxwYiFzWNA4c4nNJ5Wwk3tEw4t6nkyhfAGClUy
	AmeTyHt2ParUKl6o8CoQmKWyQjGojyw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gkHt0MCc;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 125CC4059C;
	Fri, 20 Mar 2026 18:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E703C4AF63;
	Fri, 20 Mar 2026 18:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774031309;
	bh=Fv5VAaAi7lFFXaq+Zs2NQXEVg9yFBZfIimKqUJwizNI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gkHt0MCcBHLIQio/xzhZ3JYDqMoeggebPJgOlyMKl++IgyflAsadSjnR6ajO59T7W
	 Bads34sP/a5yAm4Az5ZrzO6EFDu3djUgXqmf5qozSpDl0E+emDW/7MW3NjnJK8Slny
	 OotgoXlSvtjugWgJaY9L6WhmqLGWE1/djXCDpUtueFL1T/RlRKAFXQq8l15zcyQNzg
	 xjTOR7A8pPrNcxZlYg/qfRZqRoGr1vsLPFhe4Hd1TaAtSvhAOyzOMqZjEfVQNGp8Tp
	 eyJrsI19HFTP1bsaOPJ+0b/i2opswgGS1tIHSoUImZmzyNRI2vbOkompeaDJUfnist
	 DFKvOz84NKcEw==
Date: Fri, 20 Mar 2026 18:28:28 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kees Cook <kees@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Brian Cain <bcain@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Dinh Nguyen <dinguyen@kernel.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH v3 21/23] mm/vma: convert as much as we can in mm/vma.c
 to vma_flags_t
Message-ID: <5c61e8fc-f77d-4f9a-80b9-534978aa1840@lucifer.local>
References: <cover.1773846935.git.ljs@kernel.org>
 <44a952b98d68fc231ab231de6de04b077866bab8.1773846935.git.ljs@kernel.org>
 <a7535063-abaa-4f67-a090-4a47098f10e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7535063-abaa-4f67-a090-4a47098f10e7@kernel.org>
X-Stat-Signature: 7h8ub97w63ojdjdzu37u714pabf8nkex
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EA9E40015
X-Rspamd-Server: rspam12
X-HE-Tag: 1774031310-408927
X-HE-Meta: U2FsdGVkX19aO4O39jwVDZvQWkdmFWDhhQeMwJhLrVlvvIxiSsx/3+DWOJq8tE9HTET6smQHPxfzdu+QhTix0E/CJ2RwJuOyHGv677HvS8oPCzRyNH/jpQHvJykhEH2Dijlm73uY4RFl4hZNEVHYlFf/Uy/23S0R9DmFTrDh3V195BgcIw4+AmPo7ybMhjVToEDSMJXnas3Wla8I7JSgzbU81h3nVyCWM/deoSRQKczUK+GoLstGngT9Kav2HIvQ8DQGQ7scWQwIG+FRDaH0qOAaCjDj9ZbGKNuWBiU4nGcP/h1efSUdsZXKgzTmvixho4S1syz6+5VFTeNTosBhInSqkwS56PDtvQxWONbdOt03KWwcCVn7rQFUjlN26+Jtj0LiJig8J0OOP26joFMgga33Ql4m/wjbn1EvE+6L5ZbRq2BH8+3F7YBgi7xuadfo7fYDik72+WwjJjUQ66gehIrv2U4IYx+fRE7gln07+AiU99LdILx2P7KmRxBVOCJmnH32h5btzfzVuI9SeVOSZ2xiHJHNYZw4q0PBsk7q7wy/88QvY+p/tzOnTKnS/96mC86P8V1uty6yA9S/OnqkP96zymXyOxzLE4kk/1UnunGuWmQZxhc6bIdtNsEbyremZlODWnK2TzD8b+naMcxM400cLdrsP1YZjrSj/uubWK+M+bvRLjs1UwuCQXnBo6SPdoKblNZADeP73ETJYAT/5M3nmtbBysZxKwP+iHOryiPoERAzG8Kgy+YOhNm0Znft7l6PljRvHYWU7OucvkdTgzJf0ge6Z4A/CBmzIoi36GUa6TDdxGood45sh94t3Jg6eZPe+DHY7oZJxLw+8nQSkaRGGCw+zTAi8+eEjRhHmbg/Hip+++wEpxI+TozB+gPL/4YNl7snSG5vBydEV1xHeyYi3+aTZJD+oiYW4p6Gp6KuAjQrnFfss9KxcLidD0Kedv3dv941HlNI+za1YoO
 xzJYMI6G
 niPHmq5uUdHjpAOnrAhdCqygOZD1UsArhdTaA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:15:52AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> > Now we have established a good foundation for vm_flags_t to vma_flags_t
> > changes, update mm/vma.c to utilise vma_flags_t wherever possible.
> >
> > We are able to convert VM_STARTGAP_FLAGS entirely as this is only used in
> > mm/vma.c, and to account for the fact we can't use VM_NONE to make life
> > easier, place the definition of this within existing #ifdef's to be
> > cleaner.
> >
> > Generally the remaining changes are mechanical.
> >
> > Also update the VMA tests to reflect the changes.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

>
> Nits:
>
> > @@ -2338,8 +2339,11 @@ void mm_drop_all_locks(struct mm_struct *mm)
> >   * We account for memory if it's a private writeable mapping,
> >   * not hugepages and VM_NORESERVE wasn't set.
> >   */
> > -static bool accountable_mapping(struct file *file, vm_flags_t vm_flags)
> > +static bool accountable_mapping(struct mmap_state *map)
> >  {
> > +	const struct file *file = map->file;
> > +	vma_flags_t mask;
> > +
> >  	/*
> >  	 * hugetlb has its own accounting separate from the core VM
> >  	 * VM_HUGETLB may not be set yet so we cannot check for that flag.
> > @@ -2347,7 +2351,9 @@ static bool accountable_mapping(struct file *file, vm_flags_t vm_flags)
> >  	if (file && is_file_hugepages(file))
> >  		return false;
> >
> > -	return (vm_flags & (VM_NORESERVE | VM_SHARED | VM_WRITE)) == VM_WRITE;
> > +	mask = vma_flags_and(&map->vma_flags, VMA_NORESERVE_BIT, VMA_SHARED_BIT,
> > +			     VMA_WRITE_BIT);
> > +	return vma_flags_same(&mask, VMA_WRITE_BIT);
>
> Another case of possible refactor, if you agree with those pointed out in
> earlier patch.

Ack

>
> >  }
> >
> >  /*
>
> > @@ -2993,7 +2998,8 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
> >  	gap = vma_iter_addr(&vmi) + info->start_gap;
> >  	gap += (info->align_offset - gap) & info->align_mask;
> >  	tmp = vma_next(&vmi);
> > -	if (tmp && (tmp->vm_flags & VM_STARTGAP_FLAGS)) { /* Avoid prev check if possible */
> > +	/* Avoid prev check if possible */
> > +	if (tmp && (vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS))) {
>
> The parentheses around function call not necessary?

True, can fix up.

>
> >  		if (vm_start_gap(tmp) < gap + length - 1) {
> >  			low_limit = tmp->vm_end;
> >  			vma_iter_reset(&vmi);
> > @@ -3045,7 +3051,8 @@ unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
> >  	gap -= (gap - info->align_offset) & info->align_mask;
> >  	gap_end = vma_iter_end(&vmi);
> >  	tmp = vma_next(&vmi);
> > -	if (tmp && (tmp->vm_flags & VM_STARTGAP_FLAGS)) { /* Avoid prev check if possible */
> > +	 /* Avoid prev check if possible */
> > +	if (tmp && (vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS))) {
>
> Same.

True, will fix up.

>
> >  		if (vm_start_gap(tmp) < gap_end) {
> >  			high_limit = vm_start_gap(tmp);
> >  			vma_iter_reset(&vmi);

Cheers, Lorenzo

