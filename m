Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F8EFC44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 06:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4906B0096; Wed,  8 Jul 2026 02:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 264E26B0098; Wed,  8 Jul 2026 02:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155DA6B0099; Wed,  8 Jul 2026 02:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DBC656B0096
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:36:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7366BC4033
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:36:48 +0000 (UTC)
X-FDA: 84964651296.19.FE79D22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CCE3BA0004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:36:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TxzNfxkA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783492606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0HJkQVRyCuHBvyWHHR+93fIn2+uXye8kCTNUU3r60I=;
	b=7CuugYOn+zfXR7fWrapp6m7p+F4xjaBX164Q6WajcInhXOIc5eMrxbBGk9KfgvrMrSb/9M
	1Eew/hy5Dd0NT1WYM4Q+nEQzspVpHwGxSDY1gGoatiVhX1fghALbSJZIgiiGVzLgXRaQNP
	Tm6lAtzmCcMISceS/LLHX97aaYPZiac=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TxzNfxkA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783492606;
	b=WrLFPVT72l2v78NBBB58ewlYC7ICC+hSIltQv+8hzwyEQg8q4u46F5Um2tIOBgM+5lAQwO
	9b1YoYT9rs8aWJa20qnQe0yZ7TBkQ/b5R/EXojhFc/7FHKXppSA7P4/3cza1CS3oOzXXgH
	vkyfPQE9WhKrTNysz5tYZF8D3h+/9p4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0206B436F3;
	Wed,  8 Jul 2026 06:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE831F000E9;
	Wed,  8 Jul 2026 06:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783492605;
	bh=s0HJkQVRyCuHBvyWHHR+93fIn2+uXye8kCTNUU3r60I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TxzNfxkAbGy4rqJIqCr89/xbSHEkX+rin+tyCSt7590zWJuMCw8dcQKrSCNVIiWoA
	 ndOV/GgWovh0WUxdtvgi0EtOpL/TilvEb2DV/Haj7x+l+Y6wUpasj2HUpo6QNlgM2K
	 FXdGWdWH5cn/DW+KWFvNGyKQiWhHS8hgb6rAvdnbskLQw7CGy/oixnnHzdKAsVfU8i
	 Ckw1IGQsAI4HAECNOWyM3Pg5nt+m9bUKguiwdqud8b7wpl/lsMWQrtFW3E8+u/b4Vo
	 qizUfCiYMop6IHGz5Ym885tLg6yCjh+X38Gv1RHOK0ly9wgNDvXOadV5LseTU5F1jP
	 7eax4QVB5vPgw==
Date: Wed, 8 Jul 2026 09:36:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Thierry Reding <thierry.reding@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sowjanya Komatineni <skomatineni@nvidia.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Russell King <linux@armlinux.org.uk>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
	linux-trace-kernel@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>, Chun Ng <chunn@nvidia.com>,
	Shyam Saini <shyamsaini@linux.microsoft.com>
Subject: Reserving memory on ACPI systems (was: [PATCH v3 04/11] arm64/mm:
 Add set_memory_device() and set_memory_normal())
Message-ID: <ak3v6dt_VIZTynT8@kernel.org>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-4-d80f7b871bb4@nvidia.com>
 <akYs91INHMXMTI-t@willie-the-truck>
 <akZkuwktaXFTrASP@orome>
 <akaSJ5D98w2cHqb6@orome>
 <akftuw9NyRy36fXA@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akftuw9NyRy36fXA@willie-the-truck>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CCE3BA0004
X-Stat-Signature: ifhcnk8rhaqsawa6jse374yypub3bzot
X-Rspam-User: 
X-HE-Tag: 1783492606-34077
X-HE-Meta: U2FsdGVkX19kayOzNd/P/RZL2gqEpkzJAHHWinwBWUzx40e2cXCWpUXDyB5cBBE5R+Jy16/3moaHgQ6+jG5LYvUAiLlxFCcupAraVP3LacegaXvpuhrnPncWDiII5kEoBPJAmn9Oq6EjR5+oWUlPBVPa/Knl2LR8wubZ5ShQydV1va0BzXr4QnzbumMXE2A+5tfQyEzmCIkAI+D9KYQ2+RYtdf0fifkJhUkvUeQ1QW8DGTpXFKd2ubFz7r6SQkqDmFfZ5HAZyOlk/CNSM9zR6At2sHjEFcSx7iKtCiXl8NBnRbEP8kdSiopYkxh0UCAPHAbQaYq8PTeSYTEQpYCQ8BvEJoOjk8TmuDdS56r1GbRJ4Sux+JTOxsPynQqjcnhHT97Gz6HpH76AV6090EC5WsIt5af1TGWRS7gs/pFYp3kppVSNPwwp+HOMUWNtOAH0WDcGvuYjRBf2eVd/o5mZOXTaa0+qsrASdEtgYOFDrxW9iRn2NqsD0x0zR5lEjvL01XSB4l2C3n+yVtvg1UDMN+ur19PJYiIH3GESSMJ6SV39XsikObRmY5Luoe7RZe01ZyhOwKjjo0F5LAsvyHxl4Oz21BJXN91JJZ9WloW8YmilEUMQVxMCJk1ZRgVERK4dbQWHoUuchEM4XtHShZxNO9XXdgfzl/tb2PWhlsVcxcNOGZZieBGbVjL/E0scuSkyucpTvy2HBeU3ecTnnh9TNXScZtYUvFAPI2LXnUM7i1nyYumYKoOXYKHpOSa8FjU643INsM0vmimxs7iKVv6YQAFAyZMwW1DclW6mGy9PzcRRsBn1xFiZe7fKhXrLTFRbYB8EniuQimOVKLyeWRb3ZITdMmZl1qUYWDYGtdUT6WI9+A1X27lXSGTN8P+LrGoe2zdfoMaMYW91hPJ/5TLIs+s7/3FeXAa+rjMfHVy447vuLQnZyZc8euilprn5VSlEhKur8lsuQ4HaEWycsnS
 5/fnha9g
 +b+OI5awB8y6+v6Xt9BY9SfefYNGJ5IQ9Y23gFsVNpJAAKvFy2A8gYtKcyGm2Vqk75L19Pxt2jFaDlK8Tst/FwwhWBlXZoh0nnSdkWGKu9IJi5GtsNJIQZ2rN7mXxqFJylaDnqFIsvlvootrod2YaTke6neDLFXVhMim7xAYL+EEgWcshryeymhzbfl+mOaTP4GnpxM3uY+YjXIKNcy+zz7uz/WXi7++R75MIqJ7Opaa2ZjQ8lzx4lFjWzOdKF/3eC1avNszFPfAzia0owcMUgSmVVdR+PYUluvlrHNYdCGGa3BR2KrYJfCKwFRyA5Yn/1T54U2WI7dkLiOTFH2eRWsPw9ZHDDwYNUdYrlfnpZRJt9QbAIcCy8zRRFYyCgH1wKvBKg4Y/I+/VjybX4LYZQd79K8bkWIzC5e+EtoeGfWJBwQf/dgEYAHFz/S+i+Oz2XogmRslxQZ3YYp5Z0PGDv+706A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 06:13:31PM +0100, Will Deacon wrote:
> On Thu, Jul 02, 2026 at 06:41:23PM +0200, Thierry Reding wrote:
> > On Thu, Jul 02, 2026 at 03:46:44PM +0200, Thierry Reding wrote:
> > > On Thu, Jul 02, 2026 at 10:18:47AM +0100, Will Deacon wrote:
> > > > On Wed, Jul 01, 2026 at 06:08:15PM +0200, Thierry Reding wrote:
> > > > > From: Chun Ng <chunn@nvidia.com>
> > > > > 
> > > > > Add helpers to swap PROT_NORMAL and PROT_DEVICE_nGnRnE protection bits
> > > > > on a kernel-linear-map range.
> > > > 
> > > > That sounds like a really terrible idea. Why is this necessary and how
> > > > does it interact with things like load_unaligned_zeropad()?
> > > 
> > > This is necessary because once the memory controller has walled off the
> > > new memory region the CPU must not access it under any circumstances or
> > > it'll cause the CPU to lock up (I think technically it'll hit an SError
> > > but in practice that just means it'll freeze, as far as I can tell).
> > > 
> > > Probably doesn't interact well at all with load_unaligned_zeropad().
> > > 
> > > > I think you should unmap the memory from the linear map and memremap()
> > > > it instead.
> > > 
> > > Given that the memory can never be accessed by the CPU after the memory
> > > controller locks it down, I don't think we'll even need memremap(). The
> > > only thing we really need is the sg_table we hand out via the DMA BUFs
> > > so that they can be used by device drivers to program their DMA engines
> > > internally.
> > > 
> > > Looking through some of the architecture code around this, shouldn't we
> > > simply be using set_memory_encrypted() and set_memory_decrypted() for
> > > this? While they might've been created for slightly other use-cases,
> > > they seem to be doing exactly what we want (i.e. remove the page range
> > > from the linear mapping and flushing it, or restoring the valid bit and
> > > standard permissions, respectively).
> > 
> > Ah... I guess we can't do it because we're not in a realm world and so
> > the early checks in __set_memory_enc_dec() would return early and turn
> > it into a no-op.
> > 
> > How about if I extract a common helper and provide set_memory_p() and
> > set_memory_np() in terms of those. Those are available on x86 and
> > PowerPC as well, so fairly standard. I suppose at that point we're
> > closer to set_memory_valid().
> 
> Why not just call set_direct_map_invalid_noflush() +
> flush_tlb_kernel_range() for each page? We already have APIs for this.
> 
> The big challenge I see with any linear map manipulation, however, is
> that it will rely on can_set_direct_map() which likely means you need to
> give up some performance and/or security to make this work. Does memory
> become inaccesible dynamically at runtime? If not, the best bet would
> be to describe it as a carveout in the DT and mark it as "no-map" so
> we avoid mapping it in the first place.

While I got your attention a bit off-topic but still related question.

AFAIK a lot in arm64 drivers ecosystem relies on that ranges defined as
"/reserved-memory" in DT are linked to devices that use that memory.

EFI/ACPI does not have a similar concept.

Given that more and more systems are using EFI/ACPI rather than DT as their
boot protocol we probably need some way to define such memory carveouts in
the ACPI world.
 
> Will

-- 
Sincerely yours,
Mike.

