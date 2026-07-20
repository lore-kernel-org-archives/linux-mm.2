Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36A5FC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 13:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CC186B008C; Mon, 20 Jul 2026 09:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C596B0092; Mon, 20 Jul 2026 09:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B086B0093; Mon, 20 Jul 2026 09:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E8E6D6B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:47:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7AD39A01B9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:47:56 +0000 (UTC)
X-FDA: 85009283352.23.BB90398
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DFBCF140008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:47:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aTJI3wmK;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784555274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXooEgSoXcuhNAbJx8Sd5T6Eee8JvBtnWFh2Q/Q0dVI=;
	b=OCfgNELR4ioyMZIMYNUj57rZGP3PlkTsM/icEpK1lnsXvUlbt6sp1OrBeVec2NvsDkwEHS
	18U66nvmCNMo4+3cJxZrrG0mDY2oyJ3IlvzSNXzW3v8s9P91pBgtGG1yj7hoOR1smq0uZQ
	yfnVV9B0I1vQT/W8UJt8q79YsK3Uupw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aTJI3wmK;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784555274;
	b=Ia4AbuNn4e5nZRdxSFD8nU6ZMGjMdeHA2VBujplHjQHldmh+qZQecusVWJCDmxXlqLNwd6
	H5eRXmaA0KEyWNYshAxPXBbJayYMS0iKBqrrlapPDzfYzOhfYvE/K/e/NFffGlnqarOtYh
	YIdzu251/R2ArTYkq6bGZs16ANxfJ4M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5778760A84;
	Mon, 20 Jul 2026 13:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D25C1F000E9;
	Mon, 20 Jul 2026 13:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784555274;
	bh=kXooEgSoXcuhNAbJx8Sd5T6Eee8JvBtnWFh2Q/Q0dVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aTJI3wmKsPlHpTouI7l29PN4C4s4RZ+I5yGc8W83xTfsJtodi0R0ImMV0oLJIoZgm
	 siOfGlvOp2zFChQK0n7QRqtnCvmcwFnkarmxWHPry4aVIrZELkbuoIE1qh21SPhrYp
	 gGljkzvVqei284ThFY+J18FddOczIFDkKYmV6GpUfl65FaMlJ6/zNkAabS1/UtpqKB
	 NJrY1+VNuNSRzghb9QhVKv7205sDQpnSkJ+GnFEUFekMrqnJRpVRIBDMwQp8s+V5Kr
	 Dq6Ck/s0mlACaBBvomypCXFQdqfQX0fUGOw0buAJGqkdG+p9w9dsA+g9ovLKqCdHDe
	 /HCaDv+eDpa9Q==
Date: Mon, 20 Jul 2026 14:47:31 +0100
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
Message-ID: <al4mxWe6hKxyTtHO@lucifer>
References: <al3KlYMbmeR6iDX8@lucifer>
 <20260720153816171RRd991pToocX8jt6806EG@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720153816171RRd991pToocX8jt6806EG@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DFBCF140008
X-Stat-Signature: 1oorgh76j3f5jferrgz4izeg3hud8y9e
X-HE-Tag: 1784555274-929707
X-HE-Meta: U2FsdGVkX18fxsvr4tgQrk/K4oGs/JdTVQNhcoGr2i2pD9tg8+S/Q2jNUuzImku2dvRDFAASi7CXRwY/qvzMCUznAR71SCP6hdH+jXU8UFG1M+e+Lfc6uM7zQT2v+eLsmBVI10ew2peBEmiv5ywGCy1IOSfXopEtWgqlcU0Xmd+rBhEzFwQezUxlIlQ34QEcweLcULEVdfj0WYWc9oGLUDpa7WhpdC8mg7D3Ti0ydmm4JXD75yhtqWWLEqbIacnP73horr9MkghQ8tJOBvz+ex7SgA6RdRDNQ2Oa0lNxLFsfLk3LI6uyuniiCB4YECseRmz+6REgFnYekKSCdxCEwZKPDYX3HuCqBnF1FjLXcMNPszUSvSB86Y6NgVUBNeTYH8Qnk6jQPNQYv0Byx+NmrdAFti3m5WeYMOujZ5et9lJm+c11BJmBJeOOhtNoiWn3NQ5ho2CXFIXjfVHxySMG+BIELUBsu3rtBD5c+izMzkm1OxRRyx/WiYgHbQwuHyRXTnrDgaWMQsIG8bQzEzSIwg/dTbNqU8EmgJOoA0u3H8dCTlVRJC8SxeXAWOnGxMZveUWBJ0P4y6MVcCs0h8trAiHq1Z9KbSrNUeT/xaw4F+n8LgGN3dUXRjVeSbSMWMU5CZS2nMNQAUQV5t7h8jKl6DM6HitIQr1Xw+b2NhzxB4DiBgxSxMGRYtmxg/6ejGg3KRcfpGs7EtPe6h6Tgb1FgNpRiI8FISypY1aP3MMD3u/X9aRQWG60sguWxror7qjTuZ6yabe5IdbjRDLIy/rHycBrQvs+D48VX9/bcoy9lb0Qzmq8xzVe/4X6Pd6vS/wGNiHZ9qrd1/RtTYMV/cFkRj9LL1e9aDgjPNKqhM+u5TB2ML3GmBxJy99mU49Ya9Ov0Ge7JQ04j5D2D8kfbXtX7wV7rr87gIyc+wUdKt7q9GxkF6zoJVZZQ0rkr7yEH4sLXpmvRkW7pscwrfuHoAr
 Ml4Pc60t
 SWyWrB8hbHbyAmjz8SoOHeH7FMQJI2JlVGzfxghoymiYQw0OGSIg/BwYWEKIzEHia/Q7tBXkeukP8pRdi9yThnVM3JGzrXHimtdGqyXSxEtl4Bigh0Qcawn2hVUSSZAnpNfthjeXPL4SXDA2hf1PxXx6eA+b70xPsC8b38YekWzAQYOc8ymTslxJBgMYWUQrFEGl5UP1qoIOvi0nHdKnV56bftG0iR2yK05ivzHTJ1MNGl38Xd3TOGYG3I7zcJygpBlzeEDSOKLLNac+2Z+7OfHPAxetcUXa9QEKQ/oKPV+l8ImtiU+7QezkdoEMnjC7JKKZuPeb+7cdD9CW5Wva49KhU6ZTOLQd/GnQ/w4R2p3PsD5Do/U3m0MxETKgl39F0nfJN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 03:38:16PM +0800, xu.xin16@zte.com.cn wrote:
> > > > This patch establishes fields within the vm_area_struct type to store the
> > > > virtual page offset of VMAs.
> > > >
> > > > The virtual page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT if
> > > > they are unfaulted or were not remapped, otherwise it is equal to this
> > > > value at the point of first fault.
> > > >
> > > > Currently, anonymous folios belonging to CoW'd MAP_PRIVATE-mapped
> > > > file-backed VMAs are tracked by their file offset. By adding virtual offset
> > > > as a property of VMAs, we can now track them by their virtual page offset
> > > > instead.
> > > >
> > > > By tracking this, we provide the means by which to eliminate this
> > > > inconsistency, and more importantly lay the foundations for future work for
> > > > the scalable CoW anonymous rmap rework.
> > > >
> > > > This patch simply adds the fields and some simple helpers. Subsequent
> > > > patches will update mm code to make use of these fields correctly.
> > > >
> > > > The fields chosen are packed in the VMA such that, for 64-bit kernel
> > > > builds, no additional space is taken up.
> > >
> > > It is not necessarily true that no additional memory will be consumed, as it
> > > depends on whether the baseline kernel has CONFIG_PER_VMA_LOCK enabled.
> >
> > We are moving to this being permanently enabled.
> >
> > > Moreover, in the future evolution of mm, maintaining this benefit would
> > > require that the layout of struct vm_area_struct before __vm_virt_pgoff_lo
> > > remains unchanged, which seems impractical.
> >
> > It isn't, we are very careful with this struct.
>
> Ok, That will be nice.
>
> >
> > >
> > > My personal suggestion is: maybe we could simply add an unsigned long field,
> > > say vm_virt_pgoff, without worrying about the increased memory footprint for
> > > now. Additionally, it would be helpful to add some comments clarifying the
> > > difference between this new field and the existing vm_pgoff, to aid understanding.
> >
> > Nope that'd add 64 bytes per VMA for a typical usage which can add up to a lot.
>
> Okay, but I hope at least we could be a bit more verbose in the comments, because
> __vm_virt_pgoff_lo and __vm_virt_pgoff_hi are located somewhat far apart from each
> other, which might cause considerable confusion for others seeing these two
> variables for the first time, and clarify difference between this new field and the
> existing vm_pgoff, to aid understanding.

OK, I've added comments, these ultimately refer to the vma_start_virt_pgoff()
comment which gives further details.

>
> Thanks.

Cheers, Lorenzo

