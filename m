Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5772C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 21:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0FEC6B0092; Thu, 17 Sep 2026 17:56:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC506B0093; Thu, 17 Sep 2026 17:56:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD2836B0095; Thu, 17 Sep 2026 17:56:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFDDB6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:56:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 29F6CA5B99
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:56:58 +0000 (UTC)
X-FDA: 85224614916.07.90CC55D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 73A612000E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:56:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bE+Lz4Bp;
	spf=pass (imf03.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789682216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kuBtV4+7ALBPAyy2nomafqxqzWcbcsqKb3dSOrzTp7c=;
	b=ZoKvCv/xEyoT/quYz00JamvzL1wHb/yrpLXwoI0vt1oR6CxE8wHmoV9NnmLUCsurRLx2F7
	6huSdsheDXVg+ZdbFdj/z2hkuHs9yhJK9xkkLZglw7bI63v9kP4Mv8L/5qg8rEfgSANiER
	kcCVT6QShQfwP9Dp9T3wJAPJwOFKKHY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789682216;
	b=LonDgdsE3injCxO34KVFVhmleMAu6r6o8Ndxv78XLgbjfbaPKOJ87mY0ydA6+1Onk/896O
	r43Pr94Wfe2bRslzPgftPbAue0qwKzTDwJs5Pu3RwU4tFWuwn+5YdGL1Ia3LWuKV/bl+Ht
	UzH9oKYRRxGmmmjcRYE+sYrfJJ7yXJg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bE+Lz4Bp;
	spf=pass (imf03.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 016B060202;
	Thu, 17 Sep 2026 21:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681611F000FF;
	Thu, 17 Sep 2026 21:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789682215;
	bh=kuBtV4+7ALBPAyy2nomafqxqzWcbcsqKb3dSOrzTp7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bE+Lz4BpzH5TSV1jWou2OBtlqHsC//L3WyTj9bXi6va6c8nZfLJ4ol68JuU+o3r2M
	 TAu2icEvroIVO5OuYcPgJYCAhNQXTzOAIclO3FED1OglGnXQvoVgXQi9NkcPaNCm7C
	 NxCHhu8wntvOtj4LO509qvBQvss+eZM34/jEYGD2HXc7uGKovRY4ujMtUk30a4EgKF
	 zPD0eqlpLObbbLfAP2BCbHPLwLZz0rgjBIedFlBVM78LXQPEzVbz5SKMMk3kZSKLLI
	 Ww16aNzudepZDNF3jG6O0DxZCUHUXGJHhXcE+1AZc6MCWnHl/xvccdOs6+sET6/9Sd
	 Dca8d8QUwinxQ==
Date: Thu, 17 Sep 2026 16:56:53 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: m.szyprowski@samsung.com, hpa@zytor.com, chenhuacai@kernel.org,
	pasha.tatashin@soleen.com, devicetree@vger.kernel.org,
	linux-mm@kvack.org, tglx@kernel.org, robin.murphy@arm.com,
	kernel@xen0n.name, mingo@redhat.com, saravanak@kernel.org,
	loongarch@lists.linux.dev, dave.hansen@linux.intel.com,
	will@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	iommu@lists.linux.dev, mark.rutland@arm.com, alex@ghiti.fr,
	linux-riscv@lists.infradead.org, pjw@kernel.org,
	linux-kernel@vger.kernel.org, baoquan.he@linux.dev,
	aou@eecs.berkeley.edu, kexec@lists.infradead.org,
	pratyush@kernel.org, linux-arm-kernel@lists.infradead.org,
	ruirui.yang@linux.dev, catalin.marinas@arm.com, bp@alien8.de,
	palmer@dabbelt.com, x86@kernel.org
Subject: Re: [PATCH v6 08/10] of: reserved_mem: mark /reserved-memory entries
 with MEMBLOCK_NODUMP
Message-ID: <178968221332.3991643.14928206071521736133.robh@kernel.org>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-9-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902073116.802752-9-chenwandun1@gmail.com>
X-Stat-Signature: p6xcwqj9tfztqddnepa7ckxefbfea3au
X-Rspam-User: 
X-Rspamd-Queue-Id: 73A612000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1789682216-300970
X-HE-Meta: U2FsdGVkX1/egsbI2H4q1JSnNL5IZSfetcdCj1/kNAeOuIjN3cAXY3rt0fWYJGUVEb3T6aam0jkTBHS3NUa/pwbSgoiY1kKVWW0cTYUIEVBO1MCS0EusDiSIMN4lffJ2CSJPui4wJeVYeLWuPSJyu9vAIt/vnhfqKXya/61V5SEbqwPslQmbGZSRArLr2t+Yt2h2cB6ETGGxdStmSYKaOidxL8391/Tmq8grOBD6Z2R3ip84FGQ2AVU10lTY2ZArS7nHiN/pVyb8V8ZoRYG09HKEAqA213SX4wC1HzpKKn5/guZWqnPRmx/AwspjLVdzIdLSgnmJ4T4LAqnCqcbZ045y1rVx8nNfOg0MhY8f32bX6UsMayw4S9SnzL2zUeWVGRkGnJ+GB8snpB13JtihWN6NTK3oPocAjIxY+/lpDka/Mv+qUIK73bbE0wk2mrJmeDZB6cdPQtjyUO6qI10STCjaLjHXacm/bmmo4523DQ3JICHiPYduwTGOilVBZU+T2S7j6XALYubOdPZciL7P5rtknw4BvbtJ9rtpzfWacqR/8/W08toOIbkyRwWmz89rQMXsCcvpRANZz3dDO+qdqLg60RV2kJaRh8P7Sij+mPsI93WWYPShZU7YZmy5bzJXDqyFEQix8QXHO6XyOtRQkp3zwyxvyWUHI9x7ETqaJdvtlYW7qqEVIzERLaB7UiCVlpWzDdX/jzESg2b1pIcE6iGRH5zJ7bzC82O6UWrcIMbdmG8Pmq9UmFgm1v1sQJkogKN4LXQMLZ9lxzEzHPa5mMS6QNj8sqpnUNvTS6axP1H3DYVSyfJnes57zAB7/5P6kH3iCgDR4i9BZwdDsNXt/vp4YdElFjZ5V2C/0caK1GF1KS5hWvENfD9nUqy76aZ5RZcgBVR/EsMDb+Hugu7/TIblw3A9X0mfopZeSRs2WzSQRV/3PXRGnd/g2YKYpI82B2PC9hYO4ZiZVeya730
 9sM8Oa5N
 IZ0wNG8mufzqbi1nrhD5e17gYCwMw59Alh1cyVIyoKfLmQYH9/vfv4Z5HLzqEFPGumnAr2ziY3shhfwh8ZiqNJMVAzF62s4Y+RKIEpFmx57/UDfqTl0uv2Tu/VVHYqUKUifgzPat+JJdpN4oiaQnC5X2CWHepxptgFSOuWaxvsNiqA3wo8ATFMT0mQySmrNJbhSBrNGXc14vunuFnps+p/TyD2GyEZ+8TY6i7ZH/sU5PHzDjEe2clEbPMH186js64LvRVO+Nq89mG3TB0sKItmB3Q6K36MOE7ZLF58q/VCbL45CsWVd6VyukqNZdMemsTSI7AIfu7cKNP1E02oaprIvIzB5XTcOajuAJm5oCDIsdgJiXns8+4W0FshSKfq8pfHsCd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, 02 Sep 2026 15:31:14 +0800, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> Mark non-dumpable reserved-memory regions with MEMBLOCK_NODUMP so
> kdump can omit them from the vmcore.
> 
> The marking is guarded by CONFIG_CRASH_DUMP so non-kdump kernels do not
> pay the cost of splitting memblock.memory entries at NODUMP boundaries.
> 
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
> ---
>  drivers/of/fdt.c             |  1 +
>  drivers/of/of_private.h      |  1 +
>  drivers/of/of_reserved_mem.c | 15 +++++++++++++++
>  3 files changed, 17 insertions(+)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>


