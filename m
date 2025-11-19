Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6211CCF58F5
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 20:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5F66B000A; Wed, 19 Nov 2025 15:54:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86516B00A2; Wed, 19 Nov 2025 15:54:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975376B00A9; Wed, 19 Nov 2025 15:54:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 837296B000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:54:27 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5043CC05F2
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:54:27 +0000 (UTC)
X-FDA: 84128559774.17.52994DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D56144000E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:54:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIjVDXdy;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763585665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwbqNvwrxL30F0hMKoNOTqnADhQUlj+4wIXlkWHn4Hs=;
	b=AKHNyhkeswzBk+eoMmblD+0IHetFOWVGdce7AjpXFxiTRfPwWtPZwSGeLnmpZECdibgZsv
	mQBDIoTC42P54aotJ/nc147TguPH6JMjAnjRh5ZCbgrpR4QkPc72iZrC3u7P++bZTBHwxj
	rNvi82t804DPvn5hJjSt8sEsJwCmivI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763585665; a=rsa-sha256;
	cv=none;
	b=FYeDY4lwI3+KkO3ERiTaqdtRhfQGoIEpXCMjBt+rtiYgRYejDzGWJYXj2luBtViHv7y0ED
	zOSquAfryJu9KgGLyw3NKneSBnpXV4idaRxastu/fGNO8sMj8vUCQMeipYpL6pkLK/282K
	8Djg72HejhxMIfVMqjZrUVR8z9hXKnE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIjVDXdy;
	spf=pass (imf27.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B41D6000A;
	Wed, 19 Nov 2025 20:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01C5C116C6;
	Wed, 19 Nov 2025 20:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763585664;
	bh=mwbqNvwrxL30F0hMKoNOTqnADhQUlj+4wIXlkWHn4Hs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VIjVDXdygEdThL6V5YLCW0xD9Bt9YdcnAcPcnfKFzoBPmHe9+VFePoeh5FMXypqGq
	 V+S+LcEu8/NG3zTr4t6hmJUDNKfHgpg/5fKTjiz9WLK0hEzuCyuIhBVoCD4x4HGrUR
	 PKeUcvq5/isvXCO/hBigGUthi/F5yOtPdPUa5qTDD1B7rl5YtLMNm+5eCtnIx/tYkK
	 azw8wd+f0pUiG5a3AU2PQZjKxBRPnRZSceZC56Fjq2xd1k9ZVCcY0CJsQX1cbjmlTN
	 ZYssUYKWJAULk3czXXwVxGWnbZ5TaxSbT8lqrNnJ8A9uIgw3EwVlIC7JZfCZdOkKHp
	 VrP+1F9ywf3WQ==
Date: Wed, 19 Nov 2025 22:54:21 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
	Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
Message-ID: <20251119205421.GP18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119132511.GK17968@ziepe.ca>
 <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
 <20251119193114.GP17968@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251119193114.GP17968@ziepe.ca>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: D56144000E
X-Stat-Signature: mqdddh1r1okne8am4iifxm3e4w46bigh
X-HE-Tag: 1763585665-833303
X-HE-Meta: U2FsdGVkX19QWL4qJJI+1IJk6Up/hh2P6A0zvni2+pRetXD8GUKNHtqZ71TWW6U4iwRLRsSszY9D4PJ3tWISjTZYHA37MeG4eKuYvuQGTb93OftErUucryoF3n1TFK+4eZH6vjFPfA7rBEjb6AiqfUNmUASAbMVLLP3nz+RcV9sA9qmJjNnrWU9BEAUoOVOeS/2Fcn0d+GSH9JTsQt+OmmbUQdyoiCq+601MNsar8Ecp0fFzfzxPw+S/t0EEEinsq4CpQkqeTJRRjLbc2/a/Uj8ht35nQwDXJ0vbyMXCONiSiSOvkGt7la05z6scJPIWE7jg0lC2Og5crCGAktUTzd3bV9hxEZ0+LKOaq76k8/wwpKC8aq4Wa5Qb+tKJpH5jS6d0oIw63fV03NdyjsZN9h09gE4tYlUhURdPBX76aJLnwv2LTLSYG0cNtImvPj+FRBBPP4jSSDPDjMoh8unogVhmR7JprwCUEBjOsYhFypppVLNsPYuPH8QaUayLEulDIpJkmGBhhV0j0XxdV7tDvOtpky524MOeb3hNWKYxTXB+D/sWrQEBkCdt9cb23ngzTcBaZHhwq2en6Z5vvwOTxVm6Ixo/yirmFSd4lqRYBpAYO6eaj9MFf2kMJhE3BAsMzXczNsgLi7uiKd0SnaTbYGDRgsFldTTnq23jwMj5iLIavjDw2ZIwrmiAaXX4BzvWr4AuCqZwL+keWibU5rgAeOgsp7qx9gorNL0Um+0z1FlarKPpMRkzry6p5OrxMNzVZk8FraiJznswgemPHoKAS7UpdhrEO8HMbR/zfgilGcYoEE1Pz75ykJqJDpBxLzm692REPdpnAzfiH9apS44iZB2QQIsikj+ZQv70nhRY70bHE6RbaXEVPygJQZhAKlRgsxtV3aeeRLx8we9xDOYx8JnXX4LQAqmHJpZ0sdPai9uRyr6em4q9XV8G/OcDj4BkZ5BrOMXUKbk25XFgh9c
 nQL8MP9o
 iXgyY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 03:31:14PM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 19, 2025 at 02:42:18PM +0100, Christian König wrote:

<...>

> So thanks, we can take the Acked-by and progress here. Interested
> parties can pick it up from this point when time allows.

Christian,

Can you please provide explicit Acked-by?

Thanks

