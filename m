Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F835C44506
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 16:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4A016B0088; Sat, 11 Jul 2026 12:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0B06B0005; Sat, 11 Jul 2026 12:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABFD06B008A; Sat, 11 Jul 2026 12:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 813E06B0088
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 12:45:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B7DF140645
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 16:45:24 +0000 (UTC)
X-FDA: 84977071368.01.79B7949
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BB38B18000A;
	Sat, 11 Jul 2026 16:45:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UQeTQQM7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783788322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wyycO0T/E4ygtisRzkqVLShoTPRgxuh1j7TtfC7wXl0=;
	b=NK0+yEAg5XXngmaIc1/6r0gDrGDJuxzkYf4LZPZTYsbq67BHoN1IwIHENcX4TK+DIbSCup
	u080aSctbdeOQDreBbxwUIp0luOproOvG5/LWd4Olrw3fs56s6YFBdpW/hNazgRmUNzdSZ
	GFICqdOLfoCjG/1Sly/zU2Pvxq0YDio=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UQeTQQM7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783788322;
	b=7ZRSIl6vQ7aMS9BAEDIh+i/8b3CR5GjAEM96rWqUzb3LXOpH6PcrOWIFCtP+4i5JHhKyXX
	fsTD2t6mD20r9AMFC67sHaDLH8S+rI2xaSSo08ABJ0jTImfMFo5DOozrofFUkNB4HwO221
	T2oNgHjgxa5/ptZZthftakHx+WCYJuM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C698560052;
	Sat, 11 Jul 2026 16:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368D01F000E9;
	Sat, 11 Jul 2026 16:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783788320;
	bh=wyycO0T/E4ygtisRzkqVLShoTPRgxuh1j7TtfC7wXl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UQeTQQM7/zogPNVpPumivekv/Dm65tJwKSGkKyUaN15OK2ePQoOxgmoczQXNeufyu
	 mPB2SeO/+jaR+zlJiyLVdyWAwHg7D0CKx8xMhyA5MDEdHDSR6TPUNUJn+Nzb/es+VO
	 1AGLLXVLTi7PuZQkYtNin4NBM5SzIQlt5sWd9Tt0MOCtyaJ26niLtZLm/iWL4WgjoE
	 nytqWs/CMB6G26FmrITyykLrDBQPn0ehby972yRXsbQJ2wOYF8M/bvBoXBfucUYQHe
	 8/x2mtOwd5qD3Tv70Taj9RQTidlVV5lxGicVGK4dGGf0RiLlLhHP5bQmNpx1vNrQvn
	 rYrD/ste49T1Q==
Date: Sat, 11 Jul 2026 17:44:53 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	tsbogend@alpha.franken.de, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com, 
	simona@ffwll.ch, l.stach@pengutronix.de, inki.dae@samsung.com, 
	sw0312.kim@samsung.com, kyungmin.park@samsung.com, krzk@kernel.org, 
	peter.griffin@linaro.org, jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, 
	rodrigo.vivi@intel.com, tursulin@ursulin.net, robin.clark@oss.qualcomm.com, 
	lumag@kernel.org, lyude@redhat.com, dakr@kernel.org, 
	tomi.valkeinen@ideasonboard.com, hjc@rock-chips.com, heiko@sntech.de, andy.yan@rock-chips.com, 
	thierry.reding@kernel.org, mperttunen@nvidia.com, jonathanh@nvidia.com, kraxel@redhat.com, 
	dmitry.osipenko@collabora.com, zack.rusin@broadcom.com, matthew.brost@intel.com, 
	thomas.hellstrom@linux.intel.com, oleksandr_andrushchenko@epam.com, deller@gmx.de, bcrl@kvack.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de, 
	david@kernel.org, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	hughd@google.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jannh@google.com, pfalcato@suse.de, kees@kernel.org, 
	perex@perex.cz, tiwai@suse.com, linux-mips@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org, 
	etnaviv@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, nouveau@lists.freedesktop.org, 
	linux-rockchip@lists.infradead.org, linux-tegra@vger.kernel.org, virtualization@lists.linux.dev, 
	intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org, linux-fbdev@vger.kernel.org, 
	linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-sound@vger.kernel.org
Subject: Re: [PATCH 10/13] mm/vma: convert miscellaneous uses of VMA flags in
 core mm
Message-ID: <alJydQjYgboxmizG@lucifer>
References: <1e7d834c887b6a65627d730addcff13d458c6268.1782760670.git.ljs@kernel.org>
 <20260702131233.59026-1-lance.yang@linux.dev>
 <akaGxiTaJreEQn8T@lucifer>
 <DJTNXVOWGWJ4.3MDNLPMY0Y3RF@nvidia.com>
 <alJqjo_MZCFWj3Wt@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alJqjo_MZCFWj3Wt@lucifer>
X-Rspamd-Queue-Id: BB38B18000A
X-Stat-Signature: icpzeg9dht5bykwwj943ewwupr7cxx94
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783788321-539064
X-HE-Meta: U2FsdGVkX1/kifSXrxV1tLOFSZBl382jvwlb+d0DBDJ/7ej4KwMEjsPOOGRtdBXCvJFAwTRvjKZwNDHKNGNbMuQArO4llRftIU9nMaPQv58ZUXHjYfjcOPXhAIWi+fpYN8jM9ZgR6FVwqdk+PeW0eEx8hg0OLX5NAE4F3VIlE/jLRXAm9g/4caac+KHrp0keU5ErTi9MJaZynQRupHYyPvi2Xw9uyri82QVkp8yue57od+cni6h9p9H2oHDBu6qvlrwk3/Q4Xr2N4b+nX+nwymhfMsepNaGv2QRGKbJqIRLdscuuo2aGyOInKnCu0zHai4QCQGvdYKMj65XGykMVr7NkI1+pylP8kSzzKy4zgE7lGu10OrLE1pRdp3KPAWDKZ0YDabNWey++Jem/sCBBO9bmnXKz2QpFDxAhp8hQD/YIMKu/akReKm5mrxBdbnTPKXg1fd+etapRQvtNYVuYA+6BrWDzd5mlbAyyGcE/pWedFxPlQb/w4xLmMQKsTquYBrbnLgZqZLvszwexzY0edZqZYVTlIqc3sGZRu2fdDAg+PqWjFt+DPPC/DixY/T/6cBEdgdhEGT6jyTOG+8QIoZv7FhWsZ+C7yml7aPeOcN89bX3XsLvlCjHjiWiAz35iwC/HPGwiq+gwtOzo8BfdwLfN/ZwQamJNg17PVwXa2p0is1aUcnPmBMrk8mGI/KvKZtqSSCnZR+dT9Taj+SNY1hn9CKT4UNjha3C2SgxSzFIUDHZpTLnUR3/JopI6M0OdiVZvd3VkZMe2cJk96nHGE3DT0ZYep4LtEn79MDbMYTN+a9pc3gA+DJayOscNyA78mPFWsERTdxVcmUkqa+njQivJyNJwPENpYKU6OngJU55K4ktfRZ9ssKCOzV/V07v1Sc8CJtmxntSv0s4dEP+yuyt4vMHvWJKVr+vMuSnzj1vRey9dq4VuKl9ebzJOQW6TGsLDBarTgQsDyrW4L4w
 +cj95ZLB
 FzH2UIN8NNLJ6cOEujdOEHi4jHfCMTcTgwWGd+e6EX1KzIiAykPjV49UBk7RrEABDxbpZ9wdqoZRoA7UFjDF0V8SE2y8N509LNCN88+SAxi9DXZBeSkwYUtkIN6kUn+yxNANWGfkFuOySnv47wRBo5GvIMc5QkPoCk3uk/2p/0lXBDe0mySDCvtdWiswV5Zjv3bEW+vYG7aHoO1+4bK6bumqTugMpSl3YHhdTMKIERQDDig4T8ed6L0mYRgfJbHq0umV//04dNf090j/XyoIG9rLysw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 11, 2026 at 05:23:39PM +0100, Lorenzo Stoakes wrote:
> On Wed, Jul 08, 2026 at 09:52:19PM -0400, Zi Yan wrote:
> > On Thu Jul 2, 2026 at 11:46 AM EDT, Lorenzo Stoakes wrote:
> > > On Thu, Jul 02, 2026 at 09:12:33PM +0800, Lance Yang wrote:
> > >>
> > >> On Mon, Jun 29, 2026 at 08:25:33PM +0100, Lorenzo Stoakes wrote:
> > >> >Update various uses of legacy flags in vma.c and mmap.c to the new
> > >> >vma_flags_t type, updating comments alongside them to be consistent.
> > >> >
> > >> >Also update __install_special_mapping() to rearrange things slightly to
> > >> >accommodate the changes.
> > >> >
> > >> >Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > >> >---
> > >> [...]
> > >> >diff --git a/mm/vma.c b/mm/vma.c
> > >> >index b81c05e67a61..ab2ef0f04420 100644
> > >> >--- a/mm/vma.c
> > >> >+++ b/mm/vma.c
> > >> >@@ -3417,23 +3417,27 @@ struct vm_area_struct *__install_special_mapping(
> > >> > 	vm_flags_t vm_flags, void *priv,
> > >> > 	const struct vm_operations_struct *ops)
> > >> > {
> > >> >-	int ret;
> > >> >+	vma_flags_t vma_flags = legacy_to_vma_flags(vm_flags);
> > >> > 	struct vm_area_struct *vma;
> > >> >+	int ret;
> > >> >
> > >> > 	vma = vm_area_alloc(mm);
> > >> >-	if (unlikely(vma == NULL))
> > >> >+	if (unlikely(!vma))
> > >> > 		return ERR_PTR(-ENOMEM);
> > >> >
> > >> >-	vma_set_range(vma, addr, addr + len, 0);
> > >> >-	vm_flags |= vma_flags_to_legacy(mm->def_vma_flags) | VM_DONTEXPAND;
> > >> >+	vma_flags_set_mask(&vma_flags, mm->def_vma_flags);
> > >> >+	vma_flags_set(&vma_flags, VMA_DONTEXPAND_BIT);
> > >> > 	if (pgtable_supports_soft_dirty())
> > >> >-		vm_flags |= VM_SOFTDIRTY;
> > >> >-	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
> > >> >+		vma_flags_set(&vma_flags, VMA_SOFTDIRTY_BIT);
> > >> >+	vma_flags_clear_mask(&vma_flags, VMA_LOCKED_MASK);
> > >> >+	vma->flags = vma_flags;
> > >>
> > >> Maybe worth a vma_flags_init() helper here to mirror vm_flags_init()?
> > >> With this open-coded, we lose the soft-dirty WARN_ON_ONCE sanity check.
> > >>
> > >> Might be nicer to keep that check in one place ;)
> > >
> > > I really hate all the VMA flag accessors, they conflate things horribly - we
> > > should be explicitly taking VMA write locks when we need to (and often killable
> > > ones actually) not assuming that a VMA flags accessor does (they should at most
> > > assert).
> > >
> > > This case is even more terribly egregious - you are setting flags at an
> > > arbitrary time, why are we asserting something about softdirty?
> > >
> > > You may update them as part of initialisation, maybe not. It's far from a
> > > guarantee and feels like a lazy place to put it.
> > >
> > > BUT obviously it's an oversight not to open code that here, so I'll update the
> > > patch to do that!
> >
> > What do you want to open code here? softdirty WARN_ON_ONCE()?
>
> As you can tell I said this reflexively without checking the code :)
>
> >
> > vma_flags gets VMA_SOFTDIRTY_BIT just above vma->flags, why do we need a
> > check after that?
>
> And yeah it's completely unnecessary, indeed.
>
> >
> > BTW, if you think the check is needed, patch 9 will need to be updated,
> > since the same pattern appears in create_init_stack_vma().
>
> I'll check to see if it's valid there.

Exactly the same case as here, unnecessary :)

Cheers, LOrenzo

