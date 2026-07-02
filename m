Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19606C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0886B0150; Thu,  2 Jul 2026 20:55:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8036B0152; Thu,  2 Jul 2026 20:55:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE78A6B0153; Thu,  2 Jul 2026 20:55:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7BEB6B0150
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:55:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3EB0D1C5CC5
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:29:47 +0000 (UTC)
X-FDA: 84944221614.18.3CB913E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0EA6720008;
	Thu,  2 Jul 2026 15:29:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EZDY+QGc;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783006185;
	b=tXi3MP1q2MYGJZ0g8I5TiQL6D7RmHy+kn8YMDpup3dThiY9lb9v+bk/w3pcmTNhGvkcFwA
	D7sdyr7fc4Pn6fMsgU8vOrEKCm4Ks3tQwRSwQRZEI+bTNpc1KDTSMBGAv3M8PY4SW+3Iy4
	3W9jueOmHxhkHEK0YYI+KDnM+PyLHoA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783006185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AmvNH9wwHqyoIMesePnV6/zMDBtlSz51dFh4yHJ1BTo=;
	b=CHJqm17aCd0GCnW709ApQm/DkKZOrdmslMQR5mbbOqCkoirzmMCyif2/aJvte8MHOjues9
	1TRazdTNh8AE26yM2rH+NiF7Jc9SldIN5k19PUJgDr/2OUuq/7rD1rR2cfHQJjQSIjswjd
	/1FhBt11IT2wpiXLhbI9d7W3mM0vUdw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EZDY+QGc;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25A4F418F4;
	Thu,  2 Jul 2026 15:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7DF1F000E9;
	Thu,  2 Jul 2026 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783006184;
	bh=AmvNH9wwHqyoIMesePnV6/zMDBtlSz51dFh4yHJ1BTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EZDY+QGcsghhDIw9rxbIhnPAJRijthrModhJ3dAoSN5cVM+YkTpcpEvD+KPlh/M/u
	 Qwt3kZkRl2OzXpZ8lNBF20cEMvcQmjr2C3N0OBOmi3krbMnyRHMJTEBJXrtiCGLkys
	 hVceGk9nKeLivyWhhq1nb1heVf5ntbaXnUG4S4OpDlt89/1RU+lLBy/OziQBm1WY0f
	 mLETtt6Kv1hVTKJQz++mgHlN+PUF+ac9yH5QtMrmNRfTW7GoeSyD7Rts3hi3Don33s
	 UtJfTmtwGOSlfBDJEzVdm8IjgP96nHmx5GxFIPDKfkfCebxxa9UBrNHRuHW+T6BGzw
	 FkrA9PbgKP9aQ==
Date: Thu, 2 Jul 2026 16:29:20 +0100
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
Subject: Re: [PATCH 06/13] mm/vma: convert vm_pgprot_modify() to use
 vma_flags_t and rename
Message-ID: <akaC-xxNr8ZyN4aH@lucifer>
References: <548ba81b2971734d4d2143237ad1465bd1b2f525.1782760670.git.ljs@kernel.org>
 <20260702122116.65642-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702122116.65642-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0EA6720008
X-Stat-Signature: b6fzn9ezn3ijpxdoajthpqrmscyntwam
X-HE-Tag: 1783006184-396953
X-HE-Meta: U2FsdGVkX182Tif/orRrqW2OMSgDliNZeO20cNIIDrhzystpbrCkvGhmIHiRLDkq8ZGxfB4I4Y8ZQOnvEzhVZ/U1L2yDqyT/TNcBQYyIenCHeouWIOkxb9JGRWNTAO7o4JcMw4h2C25c/9/xtz4U0YRyGRkXwFHoch2XD1cUDX2J+aKqRCsX+nqdrkAJRsxnODBrrsxkKjDDkxqVlCRgaXwVRYV2Xdg5dJh3wN/CrtCl9xlrbpxl2F5g0Cr4vSyilMBkqy9qNhsE0XYCMW929DzMwXtK8unG+op9jYLSaKK9yXzs3pL8enRa/m756S/pqUvY6qU7OAH7unQQfqg2EILmjSmqiagmdQXPgyniBCQSZQP7L4ZsZeW1H8j+vVIfswY/un04AMY97VAtaYTJ6BUtPGcu1TCKrvy1uPtwMI2t+1zUoiZAAWoOWJ3JJei6vxY1sT1XoEIKR8zqYOdZLgGq8pU7dqq2BHOU+a59fThbuBsAY0lgt1RUYrBEHicVsn6ngm8gikheXbnIhDYMhzZ+oU8iVtmIYMeq1xTs4EXQ4jUWMLGb2Da4HjwOveUI141DEdzJ/ltjTz6+8PdRCLmMvJnwzeq3Wj1IHuj/RFukt1EZKXRdiodpBYF2WTg5F1cP418douNC5U0LPqP6MzuEkZIiru1iPuxXSo7vnuojJkD3K/9SA9bvu/Fbq4/dNms33Za4crJA3Uh9fnHsbm1pmmdhH/IASNP559GVgMSlGCas2+EhkEE7H2RT3ybBsBO6wGvyg1RTUGU8rndDkqiEOmNrlV5IrIIfBL8bmuBLGEdr/GEYWiz1cQRb4tKAx8ep3fvmZvz2C+aFwFd52NDn6SD+8q3WTO8NJpa3pYBIfgJxi7VdBtiw39fZbOW/c93/wSlMakAE5KemXth/BJkSKFKmz3fyba9nDQtGP3l5OJKNKvFWcfCKLXh+BfhEsOKIl/RsKoYk3c1Fr3q
 kbi6xC0Q
 LNg/YW+dBjz0MQm811PlZWuWMVnYo1oKwGW4Qy9HI5vPOznEPpLHddlCQluBVa0QP3WZk7Lctr5R32Jlezba0qNj6o2t/0fgDV1boHzJe5fYLClurzEIasEPs0Go0X0idPcfihbVSTq17hqEjW5W0zxnXitkvZ1bFYln57d+wDj6IBkxQjZV6Edet110kNQEFzO6lJD59Rx3vd2NsIhNz/oD7Q5a9FtA8QCKvqT1qsnm/ArcMrzTJsw8PcUsG1RF/GzYZVbswr39Xeuq5ursG+lOKri0JIIBd7nYuqUl4boYvDZTFQWS4t9GGjUFgDFVO/TJs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 08:21:16PM +0800, Lance Yang wrote:
>
> On Mon, Jun 29, 2026 at 08:25:29PM +0100, Lorenzo Stoakes wrote:
> >Update vm_pgprot_modify() to use the new VMA flags type vma_flags_t, and
> >rename to vma_pgprot_modify() accordingly.
> >
> >This is part of the ongoing work to convert vm_flags_t to vma_flags_t, in
> >order to eliminate the arbitrary limit of the number of bits in a system
> >word on available VMA flags.
> >
> >Update VMA userland tests accordingly, updating vma_set_page_prot() to no
> >longer inline vma_pgprot_modify(), rather we can simply define
> >vma_pgprot_modify() as a static inline function and the tests will pick it
> >up from vma.h.
> >
> >No functional change intended.
> >
> >Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> >---
> [...]
> >diff --git a/mm/vma.h b/mm/vma.h
> >index bcf0c2773449..6a8abb8ae937 100644
> >--- a/mm/vma.h
> >+++ b/mm/vma.h
> >@@ -522,9 +522,11 @@ static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma
> > }
> >
> > #ifdef CONFIG_MMU
> >-static inline pgprot_t vm_pgprot_modify(pgprot_t oldprot, vm_flags_t vm_flags)
> >+static inline pgprot_t vma_pgprot_modify(pgprot_t oldprot, vma_flags_t vma_flags)
> > {
> >-	return pgprot_modify(oldprot, vm_get_page_prot(vm_flags));
> >+	const pgprot_t prot = vma_get_page_prot(vma_flags);
> >+
> >+	return pgprot_modify(oldprot, prot);
>
> Nit: could this just stay as a single return? something like:
>
> return pgprot_modify(oldprot, vma_get_page_prot(vma_flags));

I feel it's a bit clearer this way, separating out the two, I know it's a super
tiny difference but anyway :P

>
> Otherwise, LGTM, feel free to add:
>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Thanks!

>
> [...]

Cheers, Lorenzo

