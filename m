Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EDE4C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E438E6B01A7; Thu,  2 Jul 2026 21:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE326B01A9; Thu,  2 Jul 2026 21:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94576B01AB; Thu,  2 Jul 2026 21:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 813F86B01A9
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:21:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 352281C0E75
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:53:28 +0000 (UTC)
X-FDA: 84944281296.30.89DAD6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 22C1A4000B;
	Thu,  2 Jul 2026 15:53:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQbSkv+E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783007606;
	b=rnAz7Fcf2oSgFyHnJioaR1KNzu5R5p1bPdczDpuly2gJx601pFBQ+XhjLpoDbdhZs59uxN
	yjiBIUqQZO+/keCKk6xbUnKgaQFbhKa6kczT/xoMda0th/5Xe3zkLh/dk+Ha06F8hZutdJ
	rZFw69Hel7XHHcQ/mBw6TXGapLU+tTw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783007606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rQoQgNL4RLwOJnesXJ906iiowNQYEhnsDiycftRDMfA=;
	b=tYqoFUMgA5r8nBnWan+gXmoFVwhtsNlvFIeaTSKhecTEOwZW2ZTKVpg7Sdn6mmc1Ir6Cyd
	78DNs/QLCMSroTwsYEqLw7v1nQGZqdm1ZsTOHmHkvHnN7uLj8frTqJQvzAhJsO6mHVj8wV
	lm/Lr5Sduycj+Ja6WoP/+pDkhmQsfYs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQbSkv+E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A81B601CA;
	Thu,  2 Jul 2026 15:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BC51F000E9;
	Thu,  2 Jul 2026 15:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783007605;
	bh=rQoQgNL4RLwOJnesXJ906iiowNQYEhnsDiycftRDMfA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RQbSkv+EjZljB5g46djvoiDLFxojsXRU7Kht7L4jS+hQfEbvLoddE5ik5cDm8RdCY
	 BqtXzK5uRv9pKYN6O4Tsu8EtqfPc36l/PyBm4MnF4L/Lj7XhDm03p3BdIE6c5nK+EW
	 WgpMr9xlTDqRIB0VqPTmKhcFe7wtPBcgkLNUiWKV6EXjD7eDfr1juT0c0xwZM3oIhX
	 yoTEQ0aDxj88mE4YuknOHetVU7Tkkxdet4F5l/46xPMCuTjg7uKR5BnT4gNu2YfNUW
	 X6p/cRUZ6h1qZ1EK6Q4sO2TBLVEUPUv3Po11nDMVUJoDiNp2oyKVRliXzikuEZxJQO
	 doneV51wWqdgg==
Date: Thu, 2 Jul 2026 16:53:01 +0100
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
Subject: Re: [PATCH 12/13] mm/mprotect: convert mprotect code to use
 vma_flags_t
Message-ID: <akaIfhfbTCAdJm3H@lucifer>
References: <7ef626d8a12dc742cfc09d080be5dc09850e873a.1782760670.git.ljs@kernel.org>
 <20260701160917.91435-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701160917.91435-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 22C1A4000B
X-Stat-Signature: csa97imtmxywwses3ebhhdpehz1u3moc
X-Rspam-User: 
X-HE-Tag: 1783007605-184361
X-HE-Meta: U2FsdGVkX19Au4td9+fV/Y7cWfJGyzE1YfDGRcJAfxEtmz0xNTFq930KZtUdtiHZWywj+tJLkTvgzypeS3cRbd1Z3MW7OOpzyj7yaK0J8Gxyg6cqMStdx8udBTtoMgbyldDDChvzzo2+Pl9yb6AL6yZ1iPGv2WduXZvv1hDF+U5v5/C/zYPWEDuU1bTrELKEeXYBrSs2baS7HD4d0rNgncZBKUwoOzEnn7UvWMhu3zI/m9QKzLGRlwRSZ9wl2b/9EKCDyALblTTXHsf8HzVO3GNeqN+ma3GkWV8lTt+aDF04/YVsgIWWm6qrROXUvRgjFHeasG5bCey4iO1Rrysi++0oLZiP44Iaa43a0e5m8o5p9kMASRsGnHldij9wuAjaLg/yYxNSGIpJJUbRgRTCeGWNE2Og/W2EWfHK+VAa+Pg3V8IjCOGSkF0zXRAAmqKH1Elf/GS5mkgPgD+qFP3cgZVQVWkDaykjJo55WqCmy5SLdQSEHC10EED86f/0FqZzPHqc9VyiipNZCkBg0zWIn7emkf2MT+zNNB1sH3hzUdt5y/cy2wDCmGCeDBhbaaTbl93GC6NEBSf+pTgy1R0fbllAIWDTiYN8PBIQtjhXKvaIP0ow8sI5rFCqvAHRhdehl2zUr51ruL3WHBM253nw+RIahGTidd6fEkpZW4S3R9a49tDTrVlm8L7OLyDwuR09TlpXsbk9fFYLMeH1ZUh0h1AvWSBsAn8OEGAkn1OmmWTmhKxPmHNQHgDBUxm+HXtGS+avGbffuhjAEkYg7APvndiZJrEiPkoQNuyPRzDXlVs20xqAISwt7pYNF7bSQKYdumQIXfg8xor7MaZXG+8NwpPYi6K9XOd2AilGhRmxFpElho9VriuDserXBC1GJ7ifGjRE96oWM3hHo2nzg5pwXC0E14u2HwtkixkQhqxzK3V1Kpp8sNZZ4oE9Vg1o5+ykw976EXZolNYmySS7VgI
 R/Tr6K2r
 XGBen6LXgtKrn2gTMunyxGJa9e8wNhcXcTokLYdWK9Ek3caWOcoriahOgftlJG5NXOsuoONPfzBqjLa1ii4j610w7RHuA5N4oiLC/uUjqSS8XDpWqXb+fyd+FeMtycrDBrfrVtymMtjMwnywLA/NSOvN3g3KKnBDP11I07Y+0lw2QR5mzBadCMjNJJFeqq1DvF8sYsX2tHt+/8+OkDIWp9okW6Lo8EkzOs3MT/EdVI3bpXm55uJVMholJX01IUMugtIq7tsgzFm3ER84Fy8b34b6NsFv7VD4JgtxGrD7X3osW7B88c9xocfk7Np2poxLqxmk7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 12:09:17AM +0800, Lance Yang wrote:
>
> On Mon, Jun 29, 2026 at 08:25:35PM +0100, Lorenzo Stoakes wrote:
> >Replace use of the legacy vm_flags_t flags with vma_flags_t values
> >throughout the mprotect logic.
> >
> >Note that we retain the legacy vm_flags_t bit shifting code in
> >do_mprotect_key(), deferring a vma_flags_t approach to this for the time
> >being.
> >
> >Additionally update comments to reflect the changes to be consistent.
> >
> >No functional change intended.
> >
> >Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> >---
> > mm/mprotect.c | 16 ++++++++--------
> > 1 file changed, 8 insertions(+), 8 deletions(-)
> >
> >diff --git a/mm/mprotect.c b/mm/mprotect.c
> >index 9cbf932b028c..c9504b2a2525 100644
> >--- a/mm/mprotect.c
> >+++ b/mm/mprotect.c
> >@@ -40,7 +40,7 @@
> >
> > static bool maybe_change_pte_writable(struct vm_area_struct *vma, pte_t pte)
> > {
> >-	if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)))
> >+	if (WARN_ON_ONCE(!vma_test(vma, VMA_WRITE_BIT)))
> > 		return false;
> >
> > 	/* Don't touch entries that are not even readable. */
> >@@ -97,7 +97,7 @@ static bool can_change_shared_pte_writable(struct vm_area_struct *vma,
> > bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
> > 			     pte_t pte)
> > {
> >-	if (!(vma->vm_flags & VM_SHARED))
> >+	if (!vma_test(vma, VMA_SHARED_BIT))
> > 		return can_change_private_pte_writable(vma, addr, pte);
> >
> > 	return can_change_shared_pte_writable(vma, pte);
> >@@ -194,7 +194,7 @@ static __always_inline void set_write_prot_commit_flush_ptes(struct vm_area_stru
> > {
> > 	bool set_write;
> >
> >-	if (vma->vm_flags & VM_SHARED) {
> >+	if (vma_test(vma, VMA_SHARED_BIT)) {
> > 		set_write = can_change_shared_pte_writable(vma, ptent);
> > 		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, nr_ptes,
> > 				       /* idx = */ 0, set_write, tlb);
> >@@ -811,8 +811,8 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
> > 		vm_unacct_memory(nrpages);
> >
> > 	/*
> >-	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
> >-	 * fault on access.
> >+	 * Private VMA_LOCKED_BIT VMA becoming writable: trigger COW to avoid
> >+	 * major fault on access.
> > 	 */
> > 	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT) &&
> > 	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT) &&
> >@@ -886,7 +886,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
> > 			goto out;
> > 		start = vma->vm_start;
> > 		error = -EINVAL;
> >-		if (!(vma->vm_flags & VM_GROWSDOWN))
> >+		if (!vma_test(vma, VMA_GROWSDOWN_BIT))
> > 			goto out;
> > 	} else {
> > 		if (vma->vm_start > start)
> >@@ -894,7 +894,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
> > 		if (unlikely(grows & PROT_GROWSUP)) {
> > 			end = vma->vm_end;
> > 			error = -EINVAL;
> >-			if (!(vma->vm_flags & VM_GROWSUP))
> >+			if (!vma_test(vma, VMA_GROWSUP_BIT))
>
> IIUC, should this be
>
> if (!vma_test_single_mask(vma, VMA_GROWSUP))
>
> instead?
>
> #elif defined(CONFIG_PARISC)
> #define VM_GROWSUP	INIT_VM_FLAG(GROWSUP)
> ...
> #ifndef VM_GROWSUP
> #define VM_GROWSUP	VM_NONE
> ...
>
> VM_GROWSUP is only defined as GROWSUP on parisc and becomes VM_NONE
> elsewhere. But VMA_GROWSUP_BIT is the raw ARCH_1 bit, which is also used
> for other arch-specific VMA flags:
>
> 	DECLARE_VMA_BIT_ALIAS(SAO, ARCH_1),		/* Strong Access Ordering (powerpc) */
> 	DECLARE_VMA_BIT_ALIAS(GROWSUP, ARCH_1),		/* parisc */
> 	DECLARE_VMA_BIT_ALIAS(SPARC_ADI, ARCH_1),	/* sparc64 */
> 	DECLARE_VMA_BIT_ALIAS(ARM64_BTI, ARCH_1),	/* arm64 */
> 	DECLARE_VMA_BIT_ALIAS(ARCH_CLEAR, ARCH_1),	/* sparc64, arm64 */
> 	DECLARE_VMA_BIT_ALIAS(MAPPED_COPY, ARCH_1),	/* !CONFIG_MMU */
>
> Other vma_test() changes look fine to me: just fixed INIT_VM_FLAG()
> masks matching their VMA_*_BIT :)

Thanks you're right, will fix!

Again I swear I ran claude on all of this so it's failing me here :)

>
> Cheers, Lance
>
> > 				goto out;
> > 		}
> > 	}
> >@@ -918,7 +918,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
> > 		}
> >
> > 		/* Does the application expect PROT_READ to imply PROT_EXEC */
> >-		if (rier && (vma->vm_flags & VM_MAYEXEC))
> >+		if (rier && vma_test(vma, VMA_MAYEXEC_BIT))
> > 			prot |= PROT_EXEC;
> >
> > 		/*
> >--
> >2.54.0
> >
> >

