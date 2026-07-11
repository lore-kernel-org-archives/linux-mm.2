Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2614BC44507
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 16:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E8F6B0005; Sat, 11 Jul 2026 12:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A89A6B0088; Sat, 11 Jul 2026 12:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0626B0092; Sat, 11 Jul 2026 12:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 608CB6B0088
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 12:23:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF6A01406EC
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 16:23:49 +0000 (UTC)
X-FDA: 84977016978.24.F29FE48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id ABAC6C000C;
	Sat, 11 Jul 2026 16:23:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oHKCbOs5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783787028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eyGPCpKJAg7fhbXBnd8C7Wrqfsg9VL7dUFWJAu8QPbU=;
	b=mXc8Q5LgsvC5D9LMq+TJxuJ52qsLNyNRSBzA2JrprSha4QPIRWYqH7q2o0g0gCdd+8DgVP
	Fsvufw1XBhx8ghUpljwzKs513BPcVAL44g3PmX54pITg4WJZX97P6EGsf2BoA+Pk1X/VFV
	EJDNGLxS+C3piE09uTEcgYzm5/JxuYI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oHKCbOs5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783787028;
	b=vfM42JCQzcL7l90ibKzFDJPFxxaYvuG0n8ZuHj3Hn/ml9sjPijEUTQEPdPHBqZ2x1lx2+F
	MkjpCuONMvprHcOeig/TcEsOpnkT1a7FzjTjf8AZX2BcDabaJX+ZXFSmqaPIZpL9JzfMQw
	LCqeKghHuUAqIqUQjuYyfWLzDbvB9zs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2307741729;
	Sat, 11 Jul 2026 16:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7C21F000E9;
	Sat, 11 Jul 2026 16:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783787026;
	bh=eyGPCpKJAg7fhbXBnd8C7Wrqfsg9VL7dUFWJAu8QPbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oHKCbOs50OGhdryTHZVIrJJAH5cNWadJ96vBPL21JseHby43owQLI4TQNXRn8X6gJ
	 TAnHb0VclvTH/ELo5PXr26ZhLJbSwD3gVlLvJn7Z0/7xX0d8g4qtgVFjgxpWwxbv1a
	 7r5CcrXGWEbeyhCP39VRFFsSay0aVbIrR1SurkK/zcKs46h1LZbloHKdjmJ9QcIWOB
	 93pv7I3n5DE5yAji0/HPOsX0hhylbUPeh4N5mBIdjWYLPd6EljlcjYkvh2JpbnVfqK
	 2Dhr9fLfrHgsT5U9G1HrOgWT69oD72z/B+kQJ6Kj2KlR/byBhBoVckK6V+QXJUFKRE
	 5uoKO6B92zc7w==
Date: Sat, 11 Jul 2026 17:23:19 +0100
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
Message-ID: <alJqjo_MZCFWj3Wt@lucifer>
References: <1e7d834c887b6a65627d730addcff13d458c6268.1782760670.git.ljs@kernel.org>
 <20260702131233.59026-1-lance.yang@linux.dev>
 <akaGxiTaJreEQn8T@lucifer>
 <DJTNXVOWGWJ4.3MDNLPMY0Y3RF@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJTNXVOWGWJ4.3MDNLPMY0Y3RF@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ABAC6C000C
X-Stat-Signature: ym7ttb7mxwhhu5m5t734drg4zxphbk8y
X-HE-Tag: 1783787027-68977
X-HE-Meta: U2FsdGVkX1+5vyZ5Ztv/3iiLeJjNFkydQpkEOVsWFOT4ps8TCrGOLot8+1TwknzJnCCsZmflsRwQqMWFe8WQP/wxvdge9g502adNkd33RonM3n38dIrSLFnwH0NjWmUIZYEHT/wfozdpTX7VZQ+c7/wev4/imcowDCJyUxSUPT3nEPpp4AcVUaZSwJ7E2gPSufXIjhVuGAKCFhsH9vtZ2JtdgRWcE7Gr58YdqC75NOm8J38CSgwe+kV/q17BcfApBbSI1AciS2OeZSyHks3Br316RnX31ZD6D3X6BFrQA0lsle041mgebCjQ+wsZN5UHyZfgvfe+N9YyHN+icqJ26SEQ7QcIBJrq0+DJKLbEQldSWw3mQ445SuQq+Qv9riYdLrc/BRGWXBejmG90DGJFV20ylRIzfs8NQWeVG8WaJJdtMCjlTQTLunk55j4YtMF9Mei/JcMUZczanp4mJfQj47PINbTw7JD6duoQu/dWSJPn/ksvj0x2GJK2FSVYSPYy9Ko3KxhL1b0HT1uTag7cyXeQ07GgZdhmDKWw/jzKLh86GqnSZnenENSXLg9MINWQdMYInJfaY2Tz5ORJ1KevOcLTTUhBYx2UCnoIHn/pDQTwpvwH5JOq0jPCB19bUWfK+PQe7cSV0tqc0axu5Z1b0e4msivBdmIqTrPTKQ84FW/S/6cAGMzjiLPvrN6xfpdajy2u9WgoeZtG1RULlF4Nb3m94gUpuha/9V8Fi1fIkw2wUqHjEUDq+PLSXkgPeoo6Z73HdpYx7KVT3Jl9fNYn8LdTuJqMGAEC8jC02QTxWwz18OblOPkStipn/vQIQa5q/W6FWSBW1cE+ywRTjcf8dhBwMPkwqgBM+hxdaig4s8s8VBu5il3AdAAeyjRSL7M/FhEfSfgIDs946HgxGtUZk2HCzhz/IBOpAFAs+b8l8uhY2h1kLY+PpJuKyB9TtHH1rJ2se5HcKIwF89IASjk
 naMi1SXk
 Wcq2SuHVhsl2UmmZYFCGAlVcasRnpzla4QBZDHvWm1tCKEJlD9uCYxA+37+kZEFqloK1N3MdPzG4CKavVb2ATf0YlqJK7OidWJbnBWD10HD2+Fmf5mQBpz5PMxy3qW3LAsMLvJC2OIYspO+8pEaBERbQa6nx53Zv7Qkk4+QaeWm+Z8CLgW0r+CAXVuQX1ZZ1LsFH8fYVKFjwsN10/fdO7gINvfY8yoUFhzijxWAn4fuxYGaWL1g/s1iAgVejEjFSkYtBbm4ByWGhyG1k8bD0PlbHWxh2l/ZudKON5O76gK7WiJiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 09:52:19PM -0400, Zi Yan wrote:
> On Thu Jul 2, 2026 at 11:46 AM EDT, Lorenzo Stoakes wrote:
> > On Thu, Jul 02, 2026 at 09:12:33PM +0800, Lance Yang wrote:
> >>
> >> On Mon, Jun 29, 2026 at 08:25:33PM +0100, Lorenzo Stoakes wrote:
> >> >Update various uses of legacy flags in vma.c and mmap.c to the new
> >> >vma_flags_t type, updating comments alongside them to be consistent.
> >> >
> >> >Also update __install_special_mapping() to rearrange things slightly to
> >> >accommodate the changes.
> >> >
> >> >Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> >> >---
> >> [...]
> >> >diff --git a/mm/vma.c b/mm/vma.c
> >> >index b81c05e67a61..ab2ef0f04420 100644
> >> >--- a/mm/vma.c
> >> >+++ b/mm/vma.c
> >> >@@ -3417,23 +3417,27 @@ struct vm_area_struct *__install_special_mapping(
> >> > 	vm_flags_t vm_flags, void *priv,
> >> > 	const struct vm_operations_struct *ops)
> >> > {
> >> >-	int ret;
> >> >+	vma_flags_t vma_flags = legacy_to_vma_flags(vm_flags);
> >> > 	struct vm_area_struct *vma;
> >> >+	int ret;
> >> >
> >> > 	vma = vm_area_alloc(mm);
> >> >-	if (unlikely(vma == NULL))
> >> >+	if (unlikely(!vma))
> >> > 		return ERR_PTR(-ENOMEM);
> >> >
> >> >-	vma_set_range(vma, addr, addr + len, 0);
> >> >-	vm_flags |= vma_flags_to_legacy(mm->def_vma_flags) | VM_DONTEXPAND;
> >> >+	vma_flags_set_mask(&vma_flags, mm->def_vma_flags);
> >> >+	vma_flags_set(&vma_flags, VMA_DONTEXPAND_BIT);
> >> > 	if (pgtable_supports_soft_dirty())
> >> >-		vm_flags |= VM_SOFTDIRTY;
> >> >-	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
> >> >+		vma_flags_set(&vma_flags, VMA_SOFTDIRTY_BIT);
> >> >+	vma_flags_clear_mask(&vma_flags, VMA_LOCKED_MASK);
> >> >+	vma->flags = vma_flags;
> >>
> >> Maybe worth a vma_flags_init() helper here to mirror vm_flags_init()?
> >> With this open-coded, we lose the soft-dirty WARN_ON_ONCE sanity check.
> >>
> >> Might be nicer to keep that check in one place ;)
> >
> > I really hate all the VMA flag accessors, they conflate things horribly - we
> > should be explicitly taking VMA write locks when we need to (and often killable
> > ones actually) not assuming that a VMA flags accessor does (they should at most
> > assert).
> >
> > This case is even more terribly egregious - you are setting flags at an
> > arbitrary time, why are we asserting something about softdirty?
> >
> > You may update them as part of initialisation, maybe not. It's far from a
> > guarantee and feels like a lazy place to put it.
> >
> > BUT obviously it's an oversight not to open code that here, so I'll update the
> > patch to do that!
>
> What do you want to open code here? softdirty WARN_ON_ONCE()?

As you can tell I said this reflexively without checking the code :)

>
> vma_flags gets VMA_SOFTDIRTY_BIT just above vma->flags, why do we need a
> check after that?

And yeah it's completely unnecessary, indeed.

>
> BTW, if you think the check is needed, patch 9 will need to be updated,
> since the same pattern appears in create_init_stack_vma().

I'll check to see if it's valid there.

For me it just feels like the most silly place to put that check, a VMA flags
update should update VMA flags not start randomly asserting silly things :)

>
> >
> > I want VMA flags to be a clean stateless thing, other than the flags
> > themselves. Implicit, unrelated, asserts or lock acquisitions in general should
> > be done separately IMO.
> >
>
> Anyway,
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
> --
> Best Regards,
> Yan, Zi
>

Cheers, Lorenzo

