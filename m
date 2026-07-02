Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4819FC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 118D76B019C; Thu,  2 Jul 2026 21:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F08B6B019D; Thu,  2 Jul 2026 21:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C806B019E; Thu,  2 Jul 2026 21:15:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C61BC6B019C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:15:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A6FB1C3FCC
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:47:40 +0000 (UTC)
X-FDA: 84944266680.15.3B0870D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7CF8D1C000D;
	Thu,  2 Jul 2026 15:47:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TzKC7lqe;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783007258;
	b=E5lF4kcC9pOQTc1oBfFmGmA5DLwA0tU58SmiMlyqte8A/mIg3Den+GqKbUSR7sF0MBiOTe
	/3t1hP/lu7BHlI79WagAi8TZf4/TI62q7lJIimAenTNwSR6U7He0dkDIetU9B6bImDiag0
	g0FihkFppzgvz8OsiFH24E/DerDjgFc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783007258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Po4UWa+Txwx6nSBMW1aPQiZMcfNfQH1HH88CC93hgvE=;
	b=nGx1CSbuc/FaBf6KXv/xXTu4s6pl1SSMLbNvVxBMxTdIXzjM1lLUwuLv8zgl+TpBUhZTe5
	JmKOxhRUidIOJozlQ1tdbVX2fTj1V2XpAwPDRDiF5uuY1OQjrpunhPKQ2qjzox3BuyBVUt
	xvRx1KgNbSnu5LbfVZ7z288KCgtE0/o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TzKC7lqe;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E29F6601F1;
	Thu,  2 Jul 2026 15:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504D91F00A3E;
	Thu,  2 Jul 2026 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783007257;
	bh=Po4UWa+Txwx6nSBMW1aPQiZMcfNfQH1HH88CC93hgvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TzKC7lqe9Irn8JWqPCnRnBZrIjo+wjSEuABLaM62PvcVIf4DaJMLiJvSaLOlIhJOf
	 znTjZNuNsA3irPkrJRqgdqBSalvaquhCKCvJXbcnp48ft4f4usQWudMjc5HdiilEg8
	 aXu2StIvmQVSGOVmy/Z45hqYBBWUQ4dmbbAuXk0zKTG9Nk6i9FrPim4oLQSVwaxjeJ
	 SDNmxdCjFnKqxvBlFG1TSv8opFwMO6hCg3J9TODlwY2GGXnrD8Ppex9n5gZkrvDNyw
	 HAH74jjJFvvUXueVEU77M3F6be8/OSAHgO1cGcNXrmLyLcrgWJzjocoh6IYJOxKTNs
	 hiEtCFwm59HOw==
Date: Thu, 2 Jul 2026 16:47:14 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, tsbogend@alpha.franken.de, 
	maddy@linux.ibm.com, mpe@ellerman.id.au, maarten.lankhorst@linux.intel.com, 
	mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, 
	l.stach@pengutronix.de, inki.dae@samsung.com, sw0312.kim@samsung.com, 
	kyungmin.park@samsung.com, krzk@kernel.org, peter.griffin@linaro.org, 
	jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, 
	tursulin@ursulin.net, robin.clark@oss.qualcomm.com, lumag@kernel.org, lyude@redhat.com, 
	dakr@kernel.org, tomi.valkeinen@ideasonboard.com, hjc@rock-chips.com, 
	heiko@sntech.de, andy.yan@rock-chips.com, thierry.reding@kernel.org, 
	mperttunen@nvidia.com, jonathanh@nvidia.com, kraxel@redhat.com, 
	dmitry.osipenko@collabora.com, zack.rusin@broadcom.com, matthew.brost@intel.com, 
	thomas.hellstrom@linux.intel.com, oleksandr_andrushchenko@epam.com, deller@gmx.de, bcrl@kvack.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de, 
	david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, hughd@google.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de, 
	kees@kernel.org, perex@perex.cz, tiwai@suse.com, linux-mips@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org, 
	etnaviv@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, 
	linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, nouveau@lists.freedesktop.org, 
	linux-rockchip@lists.infradead.org, linux-tegra@vger.kernel.org, virtualization@lists.linux.dev, 
	intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org, linux-fbdev@vger.kernel.org, 
	linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-sound@vger.kernel.org
Subject: Re: [PATCH 11/13] mm/mlock: convert mlock code to use vma_flags_t
Message-ID: <akaH31jAOuMtthKF@lucifer>
References: <2db16db81538355ca65f778c246d2381c673cad4.1782760670.git.ljs@kernel.org>
 <20260702132107.73727-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702132107.73727-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7CF8D1C000D
X-Stat-Signature: egajky6mx6ihw37sa8ywfqgjzj4tjysi
X-HE-Tag: 1783007258-986854
X-HE-Meta: U2FsdGVkX19gIMTG0PUgGF5WnxBGB2rz3RRs3mrsfi6IzsJN2FTlcBr0OSxvWkbDezW4Zah++oWVlDizmQ48GwswtobP6yTYSeGxFte8KyJskYQqmrIFua72+ZAc/SfxHctIwEOvceVziXUYhLN7eUeD6j6RaURxiL7hpe1A6im7JcthQ9ts5IjzI9GZcLNDw6f3fO4/hVCCGBkr6JvZQrRhqkiDSUCdkoykVeIa+fvlaqqX42MqyeNpIlad/JGQc7qi1VrduxU7+rzxc8hlI4c4PWDz+wFhPOC+lXo5Ke/f8hgJKge+W5X+6QUZjgMj8lt+AI7jREu0XHsPsiU2wWhTEwVuoXm1aS6QS1Dlr+vLYclo5is7b4ngu7QoZGJBN8CQa+Nqt1Q87tevdS1VNW4fmtaKYyLXVS7pXFpODECEdS7F7vmG1MQNOUG4yFadfD3d39hqRWwzPNpI4mVDJoFTrCfihu4YdXe+7k8MABhxC9r1IyxkZWKv8p7Nf4MaV+rAJqlg1u2WsD0IeDdfqRmU9reY+QFEOPc9vWJCk9lipAuYjkWjj4lbHUyO/1940pj2EjCP1zXXVD5xLg9V3h71hgqsEWI3DeU/65SgFi3tsKCNaMo2rafiIJ+sLCghvuoL16soNCW9zWnWn7RJSKiDFlxC3m7eOnxBOwW2QP2lAqt0kAz4R0ZCrxHJiP6Ny/URpwo4t8QIFJvDCgTFG2PRwtRi3dxb5EVnd1BqKCmPdh9Zw6pw+IfNZyVDys657WxQzAyNsLV6hLqdOH/15BtDCffUq7YIOWgmfjCOBDRbLzd7Qbk1Z+ccXq5bcQ3+k6NLRxlkd0D4oGKUQK7mB/S9xcWlZttynAZoRRxfwJwCWU358Zqhly3w9mi/7CGpvCFQ1KPQTvKCZK5YIVae9bMxmVyVb6i+Qk6jkL9VmjdfiNZRXHteX5+3h/gIkLm4A8jFJ3nqkOp4eWRpI3Q
 drdd8liy
 OdRXgbYTJHIo6669m+xMzReVFxi0IcsgqhYQaiHm7NCTahRh0YGZfTrlszWCLg3AQI4J4KZLI6ZjqMwd0iwJ6713hRsOzAKso1SLDT+md1NoNAXM5sNZ3XRekB/eFhQYn77piz54Xmhr7aSewNorUmpN6xJxaiQdhrAdukd0izFoG526uacYiCHBChfOBnare65Mkl2Kjjpui5egrboC3zUIeyxKAXHRXPcC1BzcYYTHGDX/Fx7Pv9R5WZNHD0wXGctPVB2qpi/A6JJW0s3eWlGXrGg5Ck/MHRTGWVLqOsKITo5DniTrUVFvypb2er8At3wJd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 09:21:07PM +0800, Lance Yang wrote:
>
> On Mon, Jun 29, 2026 at 08:25:34PM +0100, Lorenzo Stoakes wrote:
> >Replace use of the legacy vm_flags_t flags with vma_flags_t values
> >throughout the mlock logic.
> >
> >Additionally update comments to reflect the changes to be consistent.
> >
> >No functional change intended.
> >
> >Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> >---
>
> Nothing scary jumped out at me. Just one tiny nit below ;)
>
> [...]
> >@@ -466,24 +466,23 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
> >  */
> > static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
> > 	       struct vm_area_struct **prev, unsigned long start,
> >-	       unsigned long end, vm_flags_t newflags)
> >+	       unsigned long end, vma_flags_t *new_vma_flags)
> > {
> >-	vma_flags_t new_vma_flags = legacy_to_vma_flags(newflags);
> > 	const vma_flags_t old_vma_flags = vma->flags;
> > 	struct mm_struct *mm = vma->vm_mm;
> > 	int nr_pages;
> > 	int ret = 0;
> >
> >-	if (vma_flags_same_pair(&old_vma_flags, &new_vma_flags) ||
> >+	if (vma_flags_same_pair(&old_vma_flags, new_vma_flags) ||
> > 	    vma_is_secretmem(vma) || !vma_supports_mlock(vma)) {
> > 		/*
> >-		 * Don't set VM_LOCKED or VM_LOCKONFAULT and don't count.
> >+		 * Don't set VMA_LOCKED_BIT or VM_LOCKONFAULT and don't count.
>
> s/VM_LOCKONFAULT/VMA_LOCKONFAULT_BIT/

Ah yeah oops, will fix and respin! Good spot [and claude missed it ugh] :)

>
> Otherwise LGTM. Feel free to add:
>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>
> > 		 * For secretmem, don't allow the memory to be unlocked.
> > 		 */
> > 		goto out;
> > 	}
> >
> >-	vma = vma_modify_flags(vmi, *prev, vma, start, end, &new_vma_flags);
> >+	vma = vma_modify_flags(vmi, *prev, vma, start, end, new_vma_flags);
> > 	if (IS_ERR(vma)) {
> > 		ret = PTR_ERR(vma);
> > 		goto out;
> [...]

Thanks, Lorenzo

