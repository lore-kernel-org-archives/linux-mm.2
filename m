Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CDECCDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 10:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E88256B0088; Wed, 24 Jun 2026 06:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E308D6B008A; Wed, 24 Jun 2026 06:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F626B008C; Wed, 24 Jun 2026 06:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B05436B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:26:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D0041202D0
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:26:46 +0000 (UTC)
X-FDA: 84914427612.09.0B60D72
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6D2864000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:26:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=apSiimHy;
	spf=pass (imf01.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782296804;
	b=8JtttmRe/AO45+5EnVN+PSNLGzCuwzHBnCiJBy50UvPYTgO1rm7PGK2IDCaAxs0k8srRSU
	NVqq/3qwakBzvmACeZ2koMTQ1Fbyu9KKE2ryBfw2pvl3JEI86WdHQ6bsyamWCcRdLczglZ
	KRiC7j2Bfiy9SRd7iTE9URRReEvZfP0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782296804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D6F2zQWBGHFpRAf7U7g8Y6CAS5vE62CGllnJNK6O1hs=;
	b=tDoA3O/bmRTjPAzO98uxUR1rjxqhfoeK3WmccJZdfgMGY5Y+wZ6nJt7pUdjneTRQ2BfJg7
	bEXwMhf8GuVsEpVWSJoKxNbAJp0of47wrVDeAoG5ZsOJCc/zeIQ37iHfiNh9QZIEjje2vn
	N7GWN/OZp5W0nmCevoiPuN/G3ZBV+5c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=apSiimHy;
	spf=pass (imf01.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1782296801;
	bh=vB/+pduY8W2aSe2B53EzG0p/Gq5D5OvsdlA7KCSPxrY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=apSiimHyCPKHyW4pfJO5br+B6Opds6HPMpLL+tFOWsb1ErJZ9mAtByaqMcxn43hmZ
	 9TGU1QHMHZu3mnzl5Y/tJlu2+xPFnzm7U5l74+v8aqu/eBxOT++/KMY3qetujTdZ3l
	 a7MJVOAzcmHpzuavGQDusF2bMcR45lzQpS3h9whUfx1KWXn1WXaDwyrT4n06FCzfuG
	 J78OqTscGXA2qszTbI7Om8LvDmdqavwliiyDafrJl8kLo1Mgs5Xve79MfEvNWE292X
	 H6elRWWnmzQeZakuIdEiLifBnz7CdWnm5oTnyu0mUB4oDPRwBGRzXaGfPT5j+N9ZhR
	 N/67ntEsQXVcA==
Received: from fedora-2.home (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1BB2C17E0C91;
	Wed, 24 Jun 2026 12:26:41 +0200 (CEST)
Date: Wed, 24 Jun 2026 12:26:36 +0200
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
Message-ID: <20260624122636.22d34274@fedora-2.home>
In-Reply-To: <20260623181942.1536598-1-lk@c--e.de>
References: <20260623181942.1536598-1-lk@c--e.de>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wqy6i9k7ue9b3iigno3e6y4yq7xj89in
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D2864000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1782296804-866917
X-HE-Meta: U2FsdGVkX1+F2qU4sNdOp0FwKcShYUQKC8OcTs+sE0dNIa6U2IDP262bH/9A0Iw1UTORDAnIJRaKvC/jNFB14CE+dJ3Wu3vAaQ/rLg3fayDvHoo/r3EhAkKOG7tCTbvzzQBwKKLaQNhpYfEGqyTuNe+ZA7T5WhifAbmBxkQ76kEqeHY15ExCIbTaGXJ2MzgwHF2KI+WXhJ4aqus+c31/O9N7JNHs///NQ6+zcV/ZBoU8MWVFIJ6En+/7/H07uAJ9KPD6nM+XWs0chzEnPLx4SqSs7RR4AjCiqUW4yGmatrC/tm8nITNP5pxq5l3FkiSukvhu48UJAhAXGxLHqD5eWISPQB3Yy6DydrTGcSsyyLT7DQur+QuvPNwn/O93krzpuXs7/3P4LPkf0cWlboNY4JgrGnwtlOwM/QEe5s1DX28h5GVXCITiqPjh/YlsylSyLmjIqZyqXJg2Q3HsAIcRkKDx9ciqwp353X6q/rMb8cclLhV96gVD96lEwSrZr7kr041bBWKyxhQIA1vAnoevMTR/eseQS7prgLN1MYsPYbfYLotUx55moDn8DQFTnIYhPl/TV1haVpHgwKMpRrclakEJU9MwcoK0OaoHP1ROSJ57J1p49rnNMq9s/sFT2S1Qdc9GYlr84Ir2436ZYLUVrQMstE31CmfB7DEYpMPNh4V4PaFy0ujz9H3cpxlUMN5FkR+7MsiuGxHtk9ClXT3Y3gkry3Qtb2uPezbnQ+Zq691UbJFNiIzpKTH3brlaKSvnuRZZGtNw3u61Pp6zm9z8M1FL1GtcUffeBThVRpG6NO2XJjjAurW+mXpFoK0DoB615JawNZtmlA6Rzul/uE6PEZS414OpKTU5tjSF980+QOFCaSoVVMv0BaIqgK619Jh4G1bCZT5NjvC44YvFErRMU97xj21NgFNEl7BbSfMBw271Xuhih2bVPJwI6FyrfYpVaMz2foFmkayvh4xeXWr
 St/UoPAJ
 MDD3GZy7uvEKHiJD6lvE87AyeZ/EF7C+TXgJrUu9rXaKAgvvpwQhVwLHrK7AtBueH5ytV4ztKSjhdo71nXaEz6It2FXsTxLVbTtBZqD64NnHj1XihDwqdrlfPbDcbbqyLBSJS5bG3MNdaipkn6G4H9YDwwfpUQVc48TGFPBQMWvN9uZtakmyyOPUJ6KnRmGCCcMjBKvfrFC1qAj48na7DLYxEVPUjdwdS/T6XNYvDz+Zc47wkw7VTf1/pigU3+nh/dUik8JbRsHge0sdgEVPXWhmAGAl8WR15S/Ah/qWy7pp1hL//KAOMMdZHxvSP+OzgNCfFPoEvdHF8H2ZekiN0FfJllQILOtKZXSZOPWmxjJuWp8kxOvjD1HQkHPyzYjAJlutgDNzzT1we6diOSsvdd/DjeyveBAIfMOQ55AkVvqx+YyuAik9RRKyMCoEtLUSPIfcMYRxL3l9ZuHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 20:19:42 +0200
"Christian A. Ehrhardt" <lk@c--e.de> wrote:

> When checking a different patch[1] sashiko AI pointed out that
> panthor needs the same fix[2]:
> 
> In the ->huge_fault handler do not install a PMD huge page
> mapping if the huge page exceeds the boundaries of the VMA.
> 
> [1] https://lore.kernel.org/lkml/20260622215718.1532689-1-lk@c--e.de/
> [2] https://sashiko.dev/#/patchset/20260622215718.1532689-1-lk%40c--e.de
> 
> Cc: Boris Brezillon <boris.brezillon@collabora.com>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Liviu Dudau <liviu.dudau@arm.com>
> Fixes: 68cbf96b1e9b ("drm/panthor: Part ways with drm_gem_shmem_object")
> Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>

I know the discussion is ongoing to decide what we should do about
these huge_fault() handlers, but I think it's worth getting this fix in
in the meantime.

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
>  drivers/gpu/drm/panthor/panthor_gem.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> NOTE:
> The panthor version is only compile tested because I don't
> have the hardware. However, the code is identical to that
> fixed in [1] and I have a reproducer for that.
> 
> No need for for stable backports. The code is new in 7.1.
> 
> diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
> index a1e2eb1ca7bb..54535bae2b0c 100644
> --- a/drivers/gpu/drm/panthor/panthor_gem.c
> +++ b/drivers/gpu/drm/panthor/panthor_gem.c
> @@ -802,9 +802,13 @@ static vm_fault_t insert_page(struct vm_fault *vmf, unsigned int order, struct p
>  	} else if (order == PMD_ORDER) {
>  		unsigned long pfn = page_to_pfn(page);
>  		unsigned long paddr = pfn << PAGE_SHIFT;
> +		struct vm_area_struct *vma = vmf->vma;
> +		unsigned long start = ALIGN_DOWN(vmf->address, PMD_SIZE);
> +		unsigned long end = start + PMD_SIZE;
> +		bool in_range = vma->vm_start <= start && end <= vma->vm_end;
>  		bool aligned = (vmf->address & ~PMD_MASK) == (paddr & ~PMD_MASK);
>  
> -		if (aligned &&
> +		if (aligned && in_range &&
>  		    folio_test_pmd_mappable(page_folio(page))) {
>  			pfn &= PMD_MASK >> PAGE_SHIFT;
>  			return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);


