Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A48C2CDE003
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 10:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651266B008C; Wed, 24 Jun 2026 06:33:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9F46B0092; Wed, 24 Jun 2026 06:33:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1256B0093; Wed, 24 Jun 2026 06:33:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 230886B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:33:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9CE87A0290
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:33:22 +0000 (UTC)
X-FDA: 84914444244.06.0EDAAF1
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf19.hostedemail.com (Postfix) with ESMTP id C03471A0005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:33:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=En9T6wV6;
	spf=pass (imf19.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782297201;
	b=sGG0iLa6vLmMBJNeA9Xkb5G2SajNCkZgkVQirvLNN7vbp30Dd9Xho7WSbmOyQe+se3og2K
	nVjSQAl42eEtSOHpCgdpsiVVkAsR0ediNV9Z+ukwXXoLSLQKArq4n7FBVlh5ECSQcxd/4y
	+NNTHXJPelIwwAN37QzF6/auRMxV4VA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782297201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vmymUvhL9/gQGLQjtCPhXyAZ9HCZN0sY43dw5XerOt0=;
	b=GhEX03MTd5chxXJsMsC5fEK7UMyR+0yGVzUHGSLTtAtTIg0k6AgT/g7rVG3LVfu0U00eaA
	nKGGj741oXfKqcuMfuEYWUPb5xqOTBtPRk1lIKVfI9qA5qGoneGH7BgW0NMsj1MEuh0S5F
	9QlzahZmc9K3cLcXLqUTt+Jc1se18Z8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=En9T6wV6;
	spf=pass (imf19.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1782297198;
	bh=qSYOHFLFwGgYk8Qfxz13gyyEZHuOKB7DCcv5vxPHQZE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=En9T6wV6Cbm93LIQPD8jr0gw7ajIbYL2bXy7UK5//Xx3r/bJY5PZdqy/rOP3uYlPa
	 uEDerbvgOmyB4Qgabl5iSZEBHabp7vxLEJsJb13Y2KiAeaXiz+EmjlFdOTXBSIXU4Q
	 uwpSSUAtPx1vCzBvjFAtlKEPp/In6X9It89/ac7kBV+W61aeN+BfEY89qaHF4CJk+i
	 6jCd3/KZHi5OIzn1zrrybUmwhCyFZnOR4TRwCQCgtkB0QK04sHxMXD3w5ABwWz3L8r
	 /AUnXD9y24quNm/8h0TB6G8IQcVu+NIZdoYmCqbjWaG2VSBFhyEpqWetCePjV5/QKW
	 UK/IUJUWdZdxw==
Received: from fedora-2.home (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9AAB617E091C;
	Wed, 24 Jun 2026 12:33:17 +0200 (CEST)
Date: Wed, 24 Jun 2026 12:33:13 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: "Christian A. Ehrhardt" <lk@c--e.de>
Cc: dri-devel@lists.freedesktop.org, Steven Price <steven.price@arm.com>,
 Liviu Dudau <liviu.dudau@arm.com>, Andrew Morton
 <akpm@linux-foundation.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/panthor: Check VMA boundaries for PMD mappings
Message-ID: <20260624123313.3dcd8b8b@fedora-2.home>
In-Reply-To: <20260624122636.22d34274@fedora-2.home>
References: <20260623181942.1536598-1-lk@c--e.de>
	<20260624122636.22d34274@fedora-2.home>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C03471A0005
X-Stat-Signature: 9gcmqpdg4uwyqta3xnjp5x9zjo8ter8m
X-HE-Tag: 1782297200-536536
X-HE-Meta: U2FsdGVkX1/T5D+pVvaBJQV5MFArl9jpsryCmiuQIaVsbaJ2x2zOj2HvdwOjkVjQX7rvPdOxt8mOYamHNRy4HhGXsREAhZURUJd0awQvwkxTP+K04u/DARNgfrDFubQupqPdTX7slzKHSdoi0nAlWwyvC5nk5ZTwjprKsmeDbu11RR4tTS1ndKnb8lUUEHEoZLyj0QwoCIQrO8iwJJC/NoPg4id6geVy5yD5Dux9tQ1KclSpUUiz5cq9j30clQPpBVTbImhEVkLhp003El2QMaeIKUCU/k+lYIumUy3CE1TstopRm1nQ5Xk8ollelkxPQVGq624+0nspIb4v0BKF/nCRSMpkD2lD0LpCsTJqZEviPKcnYGVAIe43f9YfnDYz7h8u+cRANaZM8q7XMM2cGzWDzZl9O403FxN6yxkNIaPLqk3SND/BWN75q7/cMipZb7QihTmGZ5qANprW2HUt4R06jRNw94fP1NXQ7YRX5eCF6G4gWXwuNjMQNneju7ulWEhVL9kEYbY5K5jlw9MsJlAyhqdIFUUTtnIP2b/s6NqOuUwNEl/i7uX80zpj9ATBtpG8WPGhlivhvluanMiGspTTT+vBzDidF0vYIMVXuNh7NzRrtCz2nuRZOKbm/HBub+0XqP9KYh670n70937nocOmJyAlmJNb5Kc5lkdgaDNM+Y9Xd3RDEFuALNtAUhHi4dhiy/Hao0D6JAqBi3/7+75j1rSeFh1i1ANe2oPYS1w7Ngcq0t0lYTTxxGKCuC5CFI9tRRm26Hp52lAToxbeD7wKft2nDpOkTMkRI55AGd6hQcpNIfeEStOR7vhgvqo+pcoLkJZBVMZnqxekZ/0v1mxesbW3nozFWnx70zh0R6r5dFH/7KeF7bwd6Vfn+UGw6r+apNutt/obv7XqUQXyxtajwDOlm/bKVYYJHgDky79Lt+GoTJsMFZ6yHWAKiNaAC0qx3VUvYumDy0POfyR
 cT26ijLW
 LV+mj6mVLVb92DSSB4Mbw73YPh5LiluspcqnOqj7PEW/QauLKnTzglKMVUWLc3gid2ngiTK8L1yuqczMYL8E1sCJqa2KQJ+WcshCa+6Uo/+p3wzkOrlhL59phxCx8PMnb4hpqYcJ/xeNggpHIS7M9/9fh9bGs9/DHzca7MZEwf06dq+zIAzqRCBXwrxhRxdZ/4bWeBBIXaBQrLjTpNed9JexIlKK4oR0sQcFgYvWG5QkSGn4LNfdVjMQesqfthFlGxOPABVHKC5NhoSEN1D5iH69fv6xlW940TVAho8smdN+Ogy0/fsUYIsD8S062mVOqVjZDR8PF1fsCzlu2qMlIZsfgTxmxUPxMMn/5SCt71BdYDijUxXwsQ4rvqEob9m6Lbj4F3PWneS1yUbANTUuIQ6gUPlzsCDlC1nFmcnRkT/AW44g8cUayhgVq0Rc6G1OEUuaA9mshqUhZLZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Jun 2026 12:26:36 +0200
Boris Brezillon <boris.brezillon@collabora.com> wrote:

> On Tue, 23 Jun 2026 20:19:42 +0200
> "Christian A. Ehrhardt" <lk@c--e.de> wrote:
> 
> > When checking a different patch[1] sashiko AI pointed out that
> > panthor needs the same fix[2]:
> > 
> > In the ->huge_fault handler do not install a PMD huge page
> > mapping if the huge page exceeds the boundaries of the VMA.
> > 
> > [1] https://lore.kernel.org/lkml/20260622215718.1532689-1-lk@c--e.de/
> > [2] https://sashiko.dev/#/patchset/20260622215718.1532689-1-lk%40c--e.de
> > 
> > Cc: Boris Brezillon <boris.brezillon@collabora.com>
> > Cc: Steven Price <steven.price@arm.com>
> > Cc: Liviu Dudau <liviu.dudau@arm.com>
> > Fixes: 68cbf96b1e9b ("drm/panthor: Part ways with drm_gem_shmem_object")
> > Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>  
> 
> I know the discussion is ongoing to decide what we should do about
> these huge_fault() handlers, but I think it's worth getting this fix in
> in the meantime.
> 
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

BTW, I saw shashiko complain about our page_offset calculation which
should look something like

	page_offset = vmf->pgoff - drm_vma_node_start(&bo->base.vma_node);

to be immune to the vma->vm_{start,pgoff} adjustments done when the
VMA is split.

> 
> > ---
> >  drivers/gpu/drm/panthor/panthor_gem.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > NOTE:
> > The panthor version is only compile tested because I don't
> > have the hardware. However, the code is identical to that
> > fixed in [1] and I have a reproducer for that.
> > 
> > No need for for stable backports. The code is new in 7.1.
> > 
> > diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
> > index a1e2eb1ca7bb..54535bae2b0c 100644
> > --- a/drivers/gpu/drm/panthor/panthor_gem.c
> > +++ b/drivers/gpu/drm/panthor/panthor_gem.c
> > @@ -802,9 +802,13 @@ static vm_fault_t insert_page(struct vm_fault *vmf, unsigned int order, struct p
> >  	} else if (order == PMD_ORDER) {
> >  		unsigned long pfn = page_to_pfn(page);
> >  		unsigned long paddr = pfn << PAGE_SHIFT;
> > +		struct vm_area_struct *vma = vmf->vma;
> > +		unsigned long start = ALIGN_DOWN(vmf->address, PMD_SIZE);
> > +		unsigned long end = start + PMD_SIZE;
> > +		bool in_range = vma->vm_start <= start && end <= vma->vm_end;
> >  		bool aligned = (vmf->address & ~PMD_MASK) == (paddr & ~PMD_MASK);
> >  
> > -		if (aligned &&
> > +		if (aligned && in_range &&
> >  		    folio_test_pmd_mappable(page_folio(page))) {
> >  			pfn &= PMD_MASK >> PAGE_SHIFT;
> >  			return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);  
> 


