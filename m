Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33902C44509
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 17:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D786B0092; Sat, 11 Jul 2026 13:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC20E6B008A; Sat, 11 Jul 2026 13:10:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8AAF6B0088; Sat, 11 Jul 2026 13:10:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7DA6B0088
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 13:10:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F1921C402D
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 17:10:05 +0000 (UTC)
X-FDA: 84977133570.17.E6EA3D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 132114000B;
	Sat, 11 Jul 2026 17:10:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k3fNhKS6;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783789803;
	b=NmXDsoGa4A2fYeaswVyeLD4m7uIpV7dWikifFFck/NIv4lM2AG1unJHW8kGPabgRpiPXYa
	LVQzGbUk+KeIi5Hgiaaf2Ot1HR2cPkh09QRPVFc2KZgHEcccV55tvkEO+ZRXTUTrVzaaUD
	yPig6en8UfEFi22S2yl8D3r+xe/Pg+w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k3fNhKS6;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783789803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AvtNjMXUVGcPIUxCxCfqbdEtpU8jR9HOTGYaAlW6IJ8=;
	b=Llf4LNpg0Ck46G6HyYmpez8OIq+Ko/1wFjfHU0spSfKEDSH24cjcq+Uj/f5EC2tU9KxeOi
	1RkmF+8PUGL5O/+Zs4Xl4mJpCuPkBbPWF68gManZV2+xa21RdrNvji3r36Yv7Dj+hu5w9l
	DL9HYTUPMTe2iLp6x2mpBom5RFY3zUk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3878D6111A;
	Sat, 11 Jul 2026 17:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6F71F000E9;
	Sat, 11 Jul 2026 17:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783789801;
	bh=AvtNjMXUVGcPIUxCxCfqbdEtpU8jR9HOTGYaAlW6IJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k3fNhKS66r/p/o8Bc1xI7ewhTioGM5eE5UxTbAfHwiEEG5NZOQoHjazK2cWX+6/SE
	 v+U9r2rkD4VP0CNSplf/nSgPr33pdrLmGKOrJy6x0c8Xsnfudte+l8CuZRkvsJHzhL
	 2xzdkO2v+Q+2PPXWrMuMSvbGqEw9CmT9+ZHMiG1WT8jUC5NdwLiZsm50xu5zeD+/aW
	 zvImcxhwsTnEPAUhEbcG4TpZeBj1kqZVb6dm8VWTrMRJu36W2lybHuDy0lpFg0MMPF
	 ANsT8GKLEgijBVcxkcvqBp+1nPOUHmAwPtV+5/DPz8eLqjTPOJ42AuY6RZqVPq55n+
	 bc2Qco/fVIOQQ==
Date: Sat, 11 Jul 2026 18:09:35 +0100
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
Subject: Re: [PATCH 13/13] mm/mremap: convert mremap code to use vma_flags_t
Message-ID: <alJ4VPr7Igk3SJYt@lucifer>
References: <380f761d35a3faa4370f8b3f92e3d4af3d4c7110.1782760670.git.ljs@kernel.org>
 <20260702134947.25189-1-lance.yang@linux.dev>
 <akaJx8Zt8kazlrjq@lucifer>
 <DJTOP760MDDG.2KUSKD8WVVKJ5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJTOP760MDDG.2KUSKD8WVVKJ5@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 132114000B
X-Stat-Signature: 9t98yrboq7s57k788dss1cegawrfm4he
X-HE-Tag: 1783789802-629364
X-HE-Meta: U2FsdGVkX19Gy61V1F1MxCpMnUe1g6G2qWdc7bwq/16T5T9kbNnNZCk92q9gYtmHSUcU3NDBthz5NCUQ1aRBHyTlI0TO3yBSYDz99YhmbifcpD3cJyvrsAdkOjIfXUFz8FVx/59o8b32YEPYfNoE01WqKYbTXjapR3yQrcl5lrPpq79NhQsVSwLHa1aOcFOncNQfAiocbDBI3Gn6JMJVgvlzDantqqzHTZSSouPVoMZrc/ojRy91ym2lOivad5SeCO+CbDSzav0aUA59nyKREaeRnnEIuo4wJuE3zxu/oLIXh89TFadfz/LO1t5mnGYq1dKqVSuog0Thim+0Ks0pRToJoEW7snW5anLs2h38iDSwPwYS3q2TwSQbmqycp9dodCrsi02Fe1WdKCfeBUl2VUrYaadjou3W0/4s7zF5/bZ08colhTGWrWLHC0smwNN3eDSfuC1p4K/6J/4tG9FVj/2PjP8oq3mpOA2O3IjKPl29CWPFTYWkFaIa8D0AgPY7j859ldTJYuf4VMWS+4EoOfQQqVn+bo24+pxDe1mJ2qe9ApiQBYHM2mQlIBLRPyP+xni5YQkmBnAswbHw8g65pB87wi/DhTKvQu3u83Y/Pff5A5GGNOLkgBa0l2GDPpjRFXdoFaDZeB3mzd78S6rk2WyZgAJq2NoJOk8RUu2jmRqVWfhnAaCaJ9M56ZMehxZaMTS1zbiHQ0hhsCFmFq/vXEvSUCOuzT0HNWv6RHgo8uuyBVtZJ55yLge2D/UmsWv9iPqL2GAZB8Ke3yUfXu1tRwKmL4U1wOTtI1nbl0EAeD8jcE31YNegiZxzVbXKGD5UW4sLq1tPII0s3/ebmpHHgrvszLcy/P6NF00g+fOyDeSEsAv237nxHclj6X1zdmYYQDKB4NC1ejiHBa9YBxCgYXs6Ulyr1Y1OQqZbV96BOaMsiT/cjnYMOPiuq6rFUENzT0sZ6LXB/mgbxSqVET3
 FnMWRvcH
 Q6c9KuqnTxg1QPKqlTAPUFEAYF64u4CEvs6HCDybHzkf0F8TxLjgXv+DuRNglsASA84ikds7Dmns9eUlyGbEtMYXLsNfjuJqg4TZUnH6Z4WXcBBmNLIVeR5VF5HbJzf3d6mDqO5VmLHckN+9qMDNJdJyeGns4yS2cN/K4HIgzeTMoQTcBSCAR6nY51IVqIvyhXlS0J6fL4u+ogGJpq1q6dFzneE14QcBwkK04+9E65mg3OZY793BPmrD7u9v/drJNBrf+2+2B9PMYE5/zmqLO+/WPUqz1MW+0SQu+7Rva27TLrVWEnFuimI3+dWo6KSpp4WP9n+rwVeg6Ixc6e+18quU1tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 10:28:00PM -0400, Zi Yan wrote:
> On Thu Jul 2, 2026 at 12:07 PM EDT, Lorenzo Stoakes wrote:
> > On Thu, Jul 02, 2026 at 09:49:47PM +0800, Lance Yang wrote:
> >>
> >> On Mon, Jun 29, 2026 at 08:25:36PM +0100, Lorenzo Stoakes wrote:
> >> >Replace use of the legacy vm_flags_t flags with vma_flags_t values
> >> >throughout the mremap logic.
> >> >
> >> >Additionally update comments to reflect the changes to be consistent.
> >> >
> >> >No functional change intended.
> >> >
> >> >Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> >> >---
> >>
> >> The vm_flags_set() cases below spell out vma_start_write(), but the
> >> vm_flags_clear() cases don't?
> >
> > Yep as I said elsewhere, implicitly taking the lock is terrible and me doing
> > this is completely on purpose to get rid of that :)
> >
> > But I haven't been clear enough clearly, so I should put the argument as to why
> > that's ok in the commit message.
> >
> > Will do so on respin.
>
> How about also add a comment to vma_clear*() telling us a lock is not
> needed and why like you explained a lock is needed for vma_set*()?
> This asymmetry could confuse people.

Well you do absolutely have to hold the lock once the VMA is initialised when
using any VMA flags API that manipulates flags (apart from the explicitly atomic
case).

The argument here is that the VMA was _already locked_ at the point of clearing
:)

>
> This patch looks good to me.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
> --
> Best Regards,
> Yan, Zi
>

Cheers, Lorenzo

