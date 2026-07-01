Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A76D4C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89AEC6B00C2; Wed,  1 Jul 2026 12:09:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872236B00C4; Wed,  1 Jul 2026 12:09:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7630C6B00C5; Wed,  1 Jul 2026 12:09:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EFDB6B00C2
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:09:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9B811A0436
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:09:54 +0000 (UTC)
X-FDA: 84940693908.04.551AFC5
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1264C10000D
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:09:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GKsigi9j;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782922193;
	b=uakYtz1An1UMVDp2jJtDytXmJ0FXV+aAHp8dqU8bJLRQK9lIt9/B7nhflLx1/FcdVTOHyb
	O1VL06vopqKohgv9Y8FxBKwQjpvOv2Buw/OmyGxBrMx4qN27OHiPE3o2LHo/tnV/6A4cnR
	MxCFubeVqJ6d07FhOG2DL4WffS7xnPg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782922193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32k3xy2qoDs5v558QiIXDOBJrw4XcLaI228zHYcvJQI=;
	b=L3tEb7fJBHelweU9XxiFQN0DJ1K7/CHhRLIJT5XxxkdPmdlR9Stps573r8NVLZlCapRpPx
	xyWJ1rqcJMOPi021y2Q6qO/J19tiUikQZGVft3KmdAnlN6sAOp1b+bTTNniYXBG5Jt+LbN
	UrIXMkq7gD37l6J69nBbJwV+IOmNMy0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GKsigi9j;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782922180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=32k3xy2qoDs5v558QiIXDOBJrw4XcLaI228zHYcvJQI=;
	b=GKsigi9jw5iEZkRAOu0U35OCwwNX+WFYQBJnw1VnjqCFwAV1xkeG5HVPPXjVerUIFCpvkl
	1sYFG/+4cZNO5RnH+3ZGNEajZyzEn2vDXqeNcTTch6ZM0ZT3P4Eo/8D1DaouN8eSB+B2FA
	bvbtO9Gx6J4K8rZ0y4m06I1Z9Hu4ibM=
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	l.stach@pengutronix.de,
	inki.dae@samsung.com,
	sw0312.kim@samsung.com,
	kyungmin.park@samsung.com,
	krzk@kernel.org,
	peter.griffin@linaro.org,
	jani.nikula@linux.intel.com,
	joonas.lahtinen@linux.intel.com,
	rodrigo.vivi@intel.com,
	tursulin@ursulin.net,
	robin.clark@oss.qualcomm.com,
	lumag@kernel.org,
	lyude@redhat.com,
	dakr@kernel.org,
	tomi.valkeinen@ideasonboard.com,
	hjc@rock-chips.com,
	heiko@sntech.de,
	andy.yan@rock-chips.com,
	thierry.reding@kernel.org,
	mperttunen@nvidia.com,
	jonathanh@nvidia.com,
	kraxel@redhat.com,
	dmitry.osipenko@collabora.com,
	zack.rusin@broadcom.com,
	matthew.brost@intel.com,
	thomas.hellstrom@linux.intel.com,
	oleksandr_andrushchenko@epam.com,
	deller@gmx.de,
	bcrl@kvack.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	hughd@google.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jannh@google.com,
	pfalcato@suse.de,
	kees@kernel.org,
	perex@perex.cz,
	tiwai@suse.com,
	linux-mips@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	etnaviv@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	linux-rockchip@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org,
	xen-devel@lists.xenproject.org,
	linux-fbdev@vger.kernel.org,
	linux-aio@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sound@vger.kernel.org
Subject: Re: [PATCH 12/13] mm/mprotect: convert mprotect code to use vma_flags_t
Date: Thu,  2 Jul 2026 00:09:17 +0800
Message-Id: <20260701160917.91435-1-lance.yang@linux.dev>
In-Reply-To: <7ef626d8a12dc742cfc09d080be5dc09850e873a.1782760670.git.ljs@kernel.org>
References: <7ef626d8a12dc742cfc09d080be5dc09850e873a.1782760670.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1264C10000D
X-Stat-Signature: kcykqn15sjtn73sanxrr3pmrq6aj41aj
X-HE-Tag: 1782922192-876365
X-HE-Meta: U2FsdGVkX18iujqS3EqhuTdP/lfr+A8eXTrHxlLgZGfM5lHZ2dOOY/p25ZHmOVNdtDS31TfKYG/YaZjppnObk7H2QrJG+67VTg3QFZF2Al0iNbXMeo4Oc1knwSrY2fvxG7o7pSvvLjGUcyJ//A8fleDnY4JsvOVF6yqENJkoREt2UpW1t4rXF390IFijXs7DQnBU3vdzJiarZ7uymvfOwapCjI8Iip/eGzyL67CjA5z2XvhevmFJn2QkQEc4u5psG+BHaTIyhtD1wuZpWi+GBjcHloTJSV7ihoO7alrIKxt7QMf5mS8FdAQd0reyxpEM6m8SmClIHlE5fDJI9JVwQdUEBFozr82o9sG8nHLGQHZBVs+/DWFQIKJJtQCF79ZQUU7PISrMeMuXdVX+sa2K9BPrmHbaG+5S5vd8LbhhOQ1iWLzzhHQoeSkiLifPdf5zabXc5TfTUSJGaaD9E3OCAZIytnlCSGZ9W3l8EApqjiHZFdyeeu/W3xH0+tVeQyDooH5G1fReDw9J2sSNwMObHzXBoXkkgmsQVUd+NI1fuv8vdp3TK5l+2F4hwRRznNBmc1+NxY50PPWQ4rIfXSoq1kRhxa6P/QiJcGyM4RRnJ6o69NLZMrR6O4cuOUplNbPABe92ddwJGS+6yOMUAYyq6LH9d/g22UaDRbjLp8kAhfjR0NhMR11rkH2HVYT0mdJrEy37W/yqmitFEX4JWBjn5RQ2KTzKWzUVF5XBjUxRL+UFHKZUuJGf1/0kFtU6Gp33HT0jaqAcrBjth6NVHtCcrn70nDTUF5WXzhFX8hXZoCtk0OcYh2OUVT9CzLc3ZO9iBstwcZNndgwPGWgjv4f358Q0TwqA/rymPYsJF928BeruSpbn6+0snIuE2aH6wXXzjEIc535WzRHJjVTV2ZwkpobySjKh/vKjA6DE3cxOsYItlmJr+G21oUCoti11cZ9EtZkv8P6kTazObyNdo+D
 v4V+gbh+
 7kCTmyoH8M0h5gkXnoPlUKqjbWHF9Mz0gzvhNOZxBw8jbSahdi4RU70URUndYqX3h7NyJz5En6Xtexxz02vQWxP9b298wYMs37vToUEVQZ6lDaP+8eGJI+X1ncysRi+BbTulHgZo5KMLiaqusfBEeu5M5yYRTneMOCxfpaBFwr1KZJiHK0Cz+zDHZeoGCSc0uhpq35VNssy2P30xGSh39d+Kg9EY33jMQUXbNMGnL9FY1NslgtZGPbX/Lq8eE2WPZFohKHwrxy8Oo3B0A33huehMx0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Jun 29, 2026 at 08:25:35PM +0100, Lorenzo Stoakes wrote:
>Replace use of the legacy vm_flags_t flags with vma_flags_t values
>throughout the mprotect logic.
>
>Note that we retain the legacy vm_flags_t bit shifting code in
>do_mprotect_key(), deferring a vma_flags_t approach to this for the time
>being.
>
>Additionally update comments to reflect the changes to be consistent.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>---
> mm/mprotect.c | 16 ++++++++--------
> 1 file changed, 8 insertions(+), 8 deletions(-)
>
>diff --git a/mm/mprotect.c b/mm/mprotect.c
>index 9cbf932b028c..c9504b2a2525 100644
>--- a/mm/mprotect.c
>+++ b/mm/mprotect.c
>@@ -40,7 +40,7 @@
> 
> static bool maybe_change_pte_writable(struct vm_area_struct *vma, pte_t pte)
> {
>-	if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)))
>+	if (WARN_ON_ONCE(!vma_test(vma, VMA_WRITE_BIT)))
> 		return false;
> 
> 	/* Don't touch entries that are not even readable. */
>@@ -97,7 +97,7 @@ static bool can_change_shared_pte_writable(struct vm_area_struct *vma,
> bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
> 			     pte_t pte)
> {
>-	if (!(vma->vm_flags & VM_SHARED))
>+	if (!vma_test(vma, VMA_SHARED_BIT))
> 		return can_change_private_pte_writable(vma, addr, pte);
> 
> 	return can_change_shared_pte_writable(vma, pte);
>@@ -194,7 +194,7 @@ static __always_inline void set_write_prot_commit_flush_ptes(struct vm_area_stru
> {
> 	bool set_write;
> 
>-	if (vma->vm_flags & VM_SHARED) {
>+	if (vma_test(vma, VMA_SHARED_BIT)) {
> 		set_write = can_change_shared_pte_writable(vma, ptent);
> 		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, nr_ptes,
> 				       /* idx = */ 0, set_write, tlb);
>@@ -811,8 +811,8 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
> 		vm_unacct_memory(nrpages);
> 
> 	/*
>-	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
>-	 * fault on access.
>+	 * Private VMA_LOCKED_BIT VMA becoming writable: trigger COW to avoid
>+	 * major fault on access.
> 	 */
> 	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT) &&
> 	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT) &&
>@@ -886,7 +886,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
> 			goto out;
> 		start = vma->vm_start;
> 		error = -EINVAL;
>-		if (!(vma->vm_flags & VM_GROWSDOWN))
>+		if (!vma_test(vma, VMA_GROWSDOWN_BIT))
> 			goto out;
> 	} else {
> 		if (vma->vm_start > start)
>@@ -894,7 +894,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
> 		if (unlikely(grows & PROT_GROWSUP)) {
> 			end = vma->vm_end;
> 			error = -EINVAL;
>-			if (!(vma->vm_flags & VM_GROWSUP))
>+			if (!vma_test(vma, VMA_GROWSUP_BIT))

IIUC, should this be

if (!vma_test_single_mask(vma, VMA_GROWSUP))

instead?

#elif defined(CONFIG_PARISC)
#define VM_GROWSUP	INIT_VM_FLAG(GROWSUP)
...
#ifndef VM_GROWSUP
#define VM_GROWSUP	VM_NONE
...

VM_GROWSUP is only defined as GROWSUP on parisc and becomes VM_NONE
elsewhere. But VMA_GROWSUP_BIT is the raw ARCH_1 bit, which is also used
for other arch-specific VMA flags:

	DECLARE_VMA_BIT_ALIAS(SAO, ARCH_1),		/* Strong Access Ordering (powerpc) */
	DECLARE_VMA_BIT_ALIAS(GROWSUP, ARCH_1),		/* parisc */
	DECLARE_VMA_BIT_ALIAS(SPARC_ADI, ARCH_1),	/* sparc64 */
	DECLARE_VMA_BIT_ALIAS(ARM64_BTI, ARCH_1),	/* arm64 */
	DECLARE_VMA_BIT_ALIAS(ARCH_CLEAR, ARCH_1),	/* sparc64, arm64 */
	DECLARE_VMA_BIT_ALIAS(MAPPED_COPY, ARCH_1),	/* !CONFIG_MMU */

Other vma_test() changes look fine to me: just fixed INIT_VM_FLAG()
masks matching their VMA_*_BIT :)

Cheers, Lance

> 				goto out;
> 		}
> 	}
>@@ -918,7 +918,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
> 		}
> 
> 		/* Does the application expect PROT_READ to imply PROT_EXEC */
>-		if (rier && (vma->vm_flags & VM_MAYEXEC))
>+		if (rier && vma_test(vma, VMA_MAYEXEC_BIT))
> 			prot |= PROT_EXEC;
> 
> 		/*
>-- 
>2.54.0
>
>

