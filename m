Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 618F2C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66F0C6B009E; Mon, 20 Jul 2026 03:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646C16B009F; Mon, 20 Jul 2026 03:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584886B00A0; Mon, 20 Jul 2026 03:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 318236B009E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:14:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C266C1406F6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:14:33 +0000 (UTC)
X-FDA: 85008292026.11.CE3E192
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 35E1A16000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:14:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qc2SHIfq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784531672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8c1NwXrdIUkx3pvI3J59TnigPzn4Ew9yA8/E48gML0w=;
	b=b2XFYbNY/CaMSR3D23k97wPcJO8dYUhr0fcc4ociuJTvhMQk1SUkhLsFmo0sxYGcbDDCBJ
	Lt3SrZcF55DZI9Tv+awInCxzm/x9OWbShjnIjN9fNMk4Mk8Qb7wWgLszmMdBPmVQXcjPMZ
	sFwbEX3NiptlRWjLnhWFWU7GyN8CvUk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qc2SHIfq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784531672;
	b=ROZ/dFDVmeGZHXrhUYhMyy9UzOCxi18mRUrKlmA4I79JGM5osunOPnH6VQ4rLs9fJtp7ys
	Vpki3lZRsAjZAndH5RVCIj/7Aszp1XdRhfPN0y6+t9uAnxwVLBvaVnin2snuM8117K27qU
	HKfOOmELJlZZqgWN5lLszRTJnpzi+Lg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE183601D9;
	Mon, 20 Jul 2026 07:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0064A1F000E9;
	Mon, 20 Jul 2026 07:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784531671;
	bh=8c1NwXrdIUkx3pvI3J59TnigPzn4Ew9yA8/E48gML0w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qc2SHIfqPkpRmaLfQdPjU+4iOnjqK8iSvAn5ApPARqUjV/vl/u+KoBHUB85YlZ/FD
	 lg4Y1hWW1b7PWD0l3LwYX25F7pbuztAnDVpabiqbnovQK3zXE7TWbOZq5IXimi411r
	 5+xtIgrHltyPrAHhl0eMpHV2DcWX86lNtU0v4CUpZHM1lGJVGTqsst3Z9pKO0S+DRM
	 wAPZB1+Atkh1xsyHhVr+0sCLrtDId47LU6FkiKcsWFrXgrUebnYPtefQZYGlYksngy
	 pglpmj3RC+lXTq3HysYz+HdkRpMXS9sSKVaGsNum0/pC3WMyIBMR4wBBzWmC0xpfR1
	 iX9TdZfJMaM/g==
Date: Mon, 20 Jul 2026 08:14:08 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	jannh@google.com, pfalcato@suse.de, willy@infradead.org, jack@suse.cz, 
	linmiaohe@huawei.com, nao.horiguchi@gmail.com, riel@surriel.com, harry@kernel.org, 
	lance.yang@linux.dev, kees@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	usama.arif@linux.dev, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, peterx@redhat.com, chengming.zhou@linux.dev, 
	arnd@arndb.de, gregkh@linuxfoundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 01/15] mm/vma: introduce VMA virtual page offset field
 and add helpers
Message-ID: <al3KlYMbmeR6iDX8@lucifer>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-1-cf24910ef094@kernel.org>
 <202607191155425057lNrNOYTi44E_jmidmtkn@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202607191155425057lNrNOYTi44E_jmidmtkn@zte.com.cn>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 35E1A16000B
X-Stat-Signature: yrcmfb98ge9ggwftmwuo5ytuea1zikiy
X-Rspam-User: 
X-HE-Tag: 1784531672-383377
X-HE-Meta: U2FsdGVkX1/rEaO4QBAIl1Xz4N5p0oxuc0ZGh7yFjb/vay+tqIDLmILYKUM6O55CMmwfhwo+uIkYSxj6o3bIfsvHztG+/xuI190SFFCo3QNUTAa1j05/hvmWGQalMyp6PnQ5ly/KYjc8n+dv7cZNaIU+IwE4YaTLRupJ1aoSmHHnw1eZ2VPCa7/bba1ijoKpg6Y7zMJhy49V7GoYKdFXisEp4IGY96NfPqsbusdlY5gQljK5zKplq5KYeJ+HD3xRCvrgpxTCy5o+AeWsI7Mn5Z0qvTEk6rccXMFSVl7ym79IHDmb1gipAEKo6yOI4F/zrH5VBud0AWbQxU71QTn5/PX3wgaTyluInz4Ebf+xO9pK4yzFhw/z0kFG3k3a+hLlqCxl0tJ0AraIkU4mcClrgXHUfjVCsWv4kBcMWRu9WlBPiQQNBxTLzC7nBf8T/bOpbsmqpmpbZ7QUjnDh3IwbZ8JlygUdWKE1aUc/UEiU4z6G8JjfIm67PItQNMPlDHgMOGCHBnXKQtzAljJfTtz2ecS3SEzdX3DS1RMGGGDrD8Vah/8vtuemm3HIwy4dFCFObCZSwfRgvanKeRtiWpqihl6uSkGG5oq9J5oTLCeFHgIzgZrFA/5rfl7y1hGmigefj6VIGKHBthhJHluWxuH6Axv9mhou6YjXcld9NugSmbu/DM7lQcDjmLyRvh9a7J/Bw+3uNX9ugsdQXYkpLpz5ABM8eqLw/QzP+Mc/HRdxtizOX/zReGdaZob3wuskmgne0RZlFXJc7m+z8r/WZooQfHyB5M1vWwE5YrPL+6dZT4SBZaS517kSLvry3HSqlSnt2CSDo4RgyWu0gDrkbWEZ6DZWG62NHIzcBo3rI3wM5m2Xq2VKsaljSOZrW8ueoHMnfqmaJ9r/kUy9av6IJZ4p5D2aL4iJXT5dV/3iZ5TUszdU+2l1d+OBkQR6y8O7yKNdzMX+1SOt6G/XIOQEIs+
 DNVHdnyv
 xVnzRIVX4ByJLLbkrXLObJhVq9BXa0og47UuLRgpMT0+QaXTPKb9kMghXFtSthlc8LcLip1taJwsUXY/vqBRW4j8oac5USmwJ99FHSy6YivYoWkKimpLdY/LE0xI0woBJIDcQo/xKwOIYH/7M9/uKjPT27ixKD1sa5MX0YZUJV9x2dwE52zZPJKlbiFUTbGLUK1TA3u36eSyYxZruyCnIzFmo8nefeeLRLvV5uZHFVc5HigtlB3yfVH9usHf6ywIc41t1/kyMqVDfBv1jHyw4XArmqLtp/8bgdeq9wjVfnC7ktbP9eaLLUavaIf4Rm3gN3LYc68R922pNt6mGL5OekG6JyAYXNyfPu7xOkO2h7iw4rQ0XSaeIGtGeea5SLK4GIQqXMAex+Zc/hR71VdcnskucxyQQH8UOP5vs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 19, 2026 at 11:55:42AM +0800, xu.xin16@zte.com.cn wrote:
> > This patch establishes fields within the vm_area_struct type to store the
> > virtual page offset of VMAs.
> >
> > The virtual page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT if
> > they are unfaulted or were not remapped, otherwise it is equal to this
> > value at the point of first fault.
> >
> > Currently, anonymous folios belonging to CoW'd MAP_PRIVATE-mapped
> > file-backed VMAs are tracked by their file offset. By adding virtual offset
> > as a property of VMAs, we can now track them by their virtual page offset
> > instead.
> >
> > By tracking this, we provide the means by which to eliminate this
> > inconsistency, and more importantly lay the foundations for future work for
> > the scalable CoW anonymous rmap rework.
> >
> > This patch simply adds the fields and some simple helpers. Subsequent
> > patches will update mm code to make use of these fields correctly.
> >
> > The fields chosen are packed in the VMA such that, for 64-bit kernel
> > builds, no additional space is taken up.
>
> It is not necessarily true that no additional memory will be consumed, as it
> depends on whether the baseline kernel has CONFIG_PER_VMA_LOCK enabled.

We are moving to this being permanently enabled.

> Moreover, in the future evolution of mm, maintaining this benefit would
> require that the layout of struct vm_area_struct before __vm_virt_pgoff_lo
> remains unchanged, which seems impractical.

It isn't, we are very careful with this struct.

>
> My personal suggestion is: maybe we could simply add an unsigned long field,
> say vm_virt_pgoff, without worrying about the increased memory footprint for
> now. Additionally, it would be helpful to add some comments clarifying the
> difference between this new field and the existing vm_pgoff, to aid understanding.

Nope that'd add 64 bytes per VMA for a typical usage which can add up to a lot.

>
> Thanks,
> Xu Xin
>
> >
> > The first field is present on cacheline 0 containing key VMA fields, and
> > the second on cacheline 3, which contains file-backed reverse mapping
> > fields.
> >
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  include/linux/mm.h              | 59 +++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mm_types.h        |  4 +++
> >  mm/vma.h                        | 14 ++++++++++
> >  mm/vma_init.c                   |  1 +
> >  tools/testing/vma/include/dup.h | 26 ++++++++++++++++++
> >  5 files changed, 104 insertions(+)
> >
> > +static inline pgoff_t vma_last_virt_pgoff(const struct vm_area_struct *vma)
> > +{
> > +	return vma_end_virt_pgoff(vma) - 1;
> > +}
> > +
> >  static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
> >  {
> >  	return desc->end - desc->start;
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 939b5ea8c9e0..2710628059b1 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -967,6 +967,7 @@ struct vm_area_struct {
> >  	 */
> >  	unsigned int vm_lock_seq;
> >  #endif
> > +	unsigned int __vm_virt_pgoff_lo; /* Low 32-bits of virtual pgoff. */
> >  	/*
> >  	 * A file's MAP_PRIVATE vma can be in both i_mmap tree and anon_vma
> >  	 * list, after a COW of one of the file pages.	A MAP_SHARED vma
> > @@ -1041,6 +1042,9 @@ struct vm_area_struct {
> >  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> >  	struct lockdep_map vmlock_dep_map;
> >  #endif
> > +#endif
> > +#ifdef CONFIG_64BIT
> > +	unsigned int __vm_virt_pgoff_hi;  /* High 32-bits of virtual pgoff. */
> >  #endif
> >

Cheers, Lorenzo

