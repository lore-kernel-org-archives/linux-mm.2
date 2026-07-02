Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB16C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03BB46B014B; Thu,  2 Jul 2026 20:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0133F6B014E; Thu,  2 Jul 2026 20:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E93766B014F; Thu,  2 Jul 2026 20:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C42526B014B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:53:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6650F120152
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:25:05 +0000 (UTC)
X-FDA: 84944209770.24.D8819D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 22D3CC0019;
	Thu,  2 Jul 2026 15:25:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kbG+cL/z";
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783005903;
	b=0rxpzriLY01XEtHoRaTcYMUR5+sWWETZpS2BdAhUbWymO1Gu+x9DvJ9P7x7ECypSeMkkrq
	g7ZfspgIJs7b8ZXwT4xuaPcp8UD1wXY85RBeaEBOjE2FYbV5gw+Rg8nYivhXVo+gUOQLHP
	R6uKAeQmdDXeviTA44VRzm/lvTF14Ss=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783005903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LX3BYrLY2k63JpXB67A/Bjg+Ew5yjhUF+WJZEyA1fRw=;
	b=EosLLrrCIur2fN2UbVTVqwztbIyPU2PwHM+qKghmgh8m55zzMSY9ASgPvLbxaN/HGcVju1
	ORzloF1MO9DBhZaV4AyIDuQS85437B0ppyMrr841NIwSJyCqYenvmgaBK3QlvhzyWIZyD/
	FmehL4VPO+Rt1bP4eSshvcozM1BrvYY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kbG+cL/z";
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C929640801;
	Thu,  2 Jul 2026 15:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0E41F000E9;
	Thu,  2 Jul 2026 15:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783005900;
	bh=LX3BYrLY2k63JpXB67A/Bjg+Ew5yjhUF+WJZEyA1fRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kbG+cL/z/Lm6qSE4udnGibaK8FsMK4daZd2R+hoEFAnemIecEE1GgHP0X+YmGanAO
	 lUy6V/tOsn4eLItop07tyF1+tKZLAB376Z73zBZZR/VxVccPToewSf2zWsClidLb0a
	 1ba3VdHACF4EGJhQZxBSvTHBcWlMH/zUclnichRT0/C3hk+pIj4TS7GYchozD+ZWNu
	 evu0CqyUEndELEE8NUvVmpXBep2Kukvvzwrnf2DWGzh4uAWg/PKpNORRO9bOZEjI+M
	 pMTZGas90E8+KBulzvC/BZdad1hSIx2FR4a50cjXxyZVyxi/oq6E9v6gCdozTTgwHV
	 VbLDs0NzwuGjg==
Date: Thu, 2 Jul 2026 16:24:37 +0100
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
Subject: Re: [PATCH 05/13] mm: prefer mm->def_vma_flags in mm logic
Message-ID: <akaCFf_SjccZznnP@lucifer>
References: <3b4ccdc38819b42ddc79ee5a795831208ac7986c.1782760670.git.ljs@kernel.org>
 <20260702121022.49113-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702121022.49113-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: 6suzf4tekizso13tabd74juhycwgs4mq
X-Rspamd-Queue-Id: 22D3CC0019
X-HE-Tag: 1783005902-814173
X-HE-Meta: U2FsdGVkX19qFEdOSpb+s1QFgo/B7m0YbWfojrBA6sw9Kg3XJaSjrL7yIXPzorKmUPIf0gQflPR53upaorNYnVaoc6fMUZ8+1zeRFK7ObfAK8/KVvlZ9DF1DLPeTj1mtTgGhA8AjU0lF6BOT7rXpI5W9wDM8Wq2fqjyTrZLXi1bBUXE4UfheTPNeiQp6AqnxId8Os6j09wL2U2PPhme+5Utqh1sINgIecegshqAoy06zGOG8xZ/frckcPMj4aw9CorDNs2yZiHv1Myw7m0MDJaV2reRUPAY53M8hQ6xe9Bax1M6w/cvtWyUAe13e9y/uAhPLBZygXg/XeGZvkCiVXy0+EANMZiuf/6X3YHJPtPyvOF/QvNN6rCDi6fBhLymWgNAEymjytfOle+cmlj1VeEUAwYKypD4cHoW7ExVgLDBkCjfCnJl9vZF9/JOSbZpmOIaHFS4r4CGAuA0eVYM9+s+31Cv9Hv9vuiT8n9dnsRWHlMda8jV66v1PvQngCtbsRkdwxjmNjgMpFWLaJTK4x6Bs0URlTC4NF9PskeSWhn3uzem3Gtc+ElURcIzi5/YVZL4UagJ0mrEsnZahCmvezyqWxpZjJrIXa0LLYAZTiqSiuCuc7bmdlfqf2Oix1yHVzRE7vL5sSzB2WaGwczYukfLte/HqSDGEPSCauozk6RcUqiYIIBEm3v29/nTF7NhAAmtOhf3clc9zAFz0aUJCZvArBmpHkn35SIqhHbG7XVWUwMal/8tSfhDZazzkRwtlR5dKcWMjnfNcb2+jcAxXbLGzZE6/D0nmy6XbgY+ptYQAX8ZayPD7T8cSCG7ZhYzMMrpCoJ74+KS49rBJ6t2+iRyY9cKeunC0RH0X9aFAaq2mS6RFW4MIGFZzjA/lw9IpaWcpnTIltnHR/vfguFR+7X0KrhBqFDfyAnGD7NXAjrbjCcUNTctM585Xsdoj0r3dU6ZS/ebwwxJhnLHQ5lY
 izqdvseJ
 hlJ3A/IzcEd7r5VSM544KagXuZ1+s7jcd8BFTyaPSI+VIMEXkDvBA46xZpxOSC6A/K3ritZva9VUAYvzXKxgmxCrQ7pRfcoDpq3G4BJ3phCR0lEI3Upjuwc5Sy4+6Oan0W3CJP2hbxnKtjMrXVAEH8WRiylDigf/fkyHb+CT80U3aQUi8dMUI3rHEw4MXDvo/m/iA27BbkP5mZXjIECUla6AzsEAIGKF0M74twHaYVU3VgoZk7llHgSNm668BG8ySy7EEVHIR8oDPGOra17aMDSKyzTR2F1w85qYIo8S3X7EC7upCrw2p1S2SonQTEQGbheXj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 08:10:22PM +0800, Lance Yang wrote:
>
> On Mon, Jun 29, 2026 at 08:25:28PM +0100, Lorenzo Stoakes wrote:
> >Currently mm->def_flags (of type vm_flags_t) is union'd with
> >mm->def_vma_flags (of type vma_flags_t).
> >
> >As part of the effort to convert vm_flags_t usage to vma_flags_t (in order
> >to no longer be arbitrarily limited to a system word size for VMA flags),
> >prefer mm->def_vma_flags to mm->def_flags throughout the mm logic.
> >
> >No functional change intended.
> >
> >Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> >---
> > mm/debug.c |  2 +-
> > mm/mlock.c | 13 +++++++------
> > mm/mmap.c  | 11 ++++++-----
> > mm/vma.c   |  4 ++--
> > 4 files changed, 16 insertions(+), 14 deletions(-)
> >
> >diff --git a/mm/debug.c b/mm/debug.c
> >index 497654b36f1a..f0a354a9496a 100644
> >--- a/mm/debug.c
> >+++ b/mm/debug.c
> >@@ -226,7 +226,7 @@ void dump_mm(const struct mm_struct *mm)
> > 		mm->numa_next_scan, mm->numa_scan_offset, mm->numa_scan_seq,
> > #endif
> > 		atomic_read(&mm->tlb_flush_pending),
> >-		mm->def_flags, &mm->def_flags
> >+		vma_flags_to_legacy(mm->def_vma_flags), &mm->def_vma_flags
> > 	);
>
> While at it, one thing for later: dump_mm() still assumes one-world VMA
> flags. That works today since vma_flags_t is one word. Maybe worth a
> BUILD_BUG_ON() here, before that stops being true?

Ah yeah that could actually be pretty straightforward, if you see
https://www.kernel.org/doc/Documentation/printk-formats.txt there is a bitmap
format that could be used.

Can do that on a respin!

>
> Not a big deal though. Feel free to add:
>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>
> > }
> > EXPORT_SYMBOL(dump_mm);
> [...]

Cheers, Lorenzo

