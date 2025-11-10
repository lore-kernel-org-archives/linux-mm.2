Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 517F1CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 20:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CCA38E000A; Mon, 10 Nov 2025 15:05:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87CF58E0002; Mon, 10 Nov 2025 15:05:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745718E000A; Mon, 10 Nov 2025 15:05:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60A778E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:05:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D85054B6C2
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:05:49 +0000 (UTC)
X-FDA: 84095778018.06.E2C2015
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf16.hostedemail.com (Postfix) with ESMTP id 026C7180011
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:05:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=P44njGbF;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="S NeUHhP";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf16.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.158 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762805148; a=rsa-sha256;
	cv=none;
	b=4cNv58CPa8WQBpV5RcV5RniR7lyHL3/3dxD0dRPvdb1OSxXkbYB2WcvCFLhP0FXDNdvs1t
	tqEKz8+kGESf4wnIWXwVkeulheWduNWamEZpJixJarjkbu4wLuff9K/rVwBFBc8LOOhOii
	i5lirEI15WwCVKqhsiTwOFgybPaOKMY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=P44njGbF;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="S NeUHhP";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf16.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.158 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762805148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QWavr1Y4jetO7CpzWCAeEensv2XOEaKTErTM/rpJMIg=;
	b=xNk063kfn3PXsTY/TnZEhOHVQzZDQXwR57BH9wr4ktLZvV8hHY5b6d32c6uj4/vn8MLZH/
	NoUrQcj11iCUOYxmAL9v00DJHWp2lmDQ99HxfzXnhazCK9nwheTkCTOPLDpd1+e/0Fvzwd
	Z+dKSgaZ1lCl4ajjyNCvabavuAmz9P0=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 75B2F7A0140;
	Mon, 10 Nov 2025 15:05:46 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Mon, 10 Nov 2025 15:05:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762805146;
	 x=1762891546; bh=QWavr1Y4jetO7CpzWCAeEensv2XOEaKTErTM/rpJMIg=; b=
	P44njGbFkl3pOTaDtIZBVRumI3etEDzgSsJYEJ8FvFVsFvwvVLXMDMsvn6aUehvD
	tX23j4ZkuYzzNKblPl5eoRtBEwnsSMAgClGzI595rx7rUTrPQrccQGCdhtWJhilp
	DFNty4cB/vIdK2tbepFMl7R/oTdPaRpKD4aNfVR+Xglecv1lvs4o0i2y6hWz2K1k
	hjQOHjtCIZX9JmdHtiVpZ3ytfYqE4fFhMOL2BauRmP34rlF8J3bLqEyyVgUd1Wxf
	uivNmBy88n3BAYyUQvOeYyEMuRLR6HK6JD6EBQGVAM0wM0LqzVwMMkgCnjKZLOQg
	DgK238GhJfZEC29HeBHAiw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762805146; x=
	1762891546; bh=QWavr1Y4jetO7CpzWCAeEensv2XOEaKTErTM/rpJMIg=; b=S
	NeUHhP4zFIIIq8T0qOoLspDmGo3aV7LstNjwQx/zOpqRPdikfwAhxZr1Vjza2V2E
	XW/K9QSUwZMXVc1cpd8LZrXLMFISDLbA0gMT9DzEKhBjwLHv5lFAfjRT83KCvDG0
	x+VbyV+GmrJlh9dG/d80U9KO5LcHh9ZfYF+WKaE8l/l8mwyerixOC3CYxhpxK7QT
	utY6WevmBVi4E+itP3599pH3VYKeulT8r4BhTOEtO8xRecVlR3ctKNC4jSXmtxvC
	2h7nADaicKEmXWPbqEmkAL4m9KLPQNtUHOf/1R6e0gVSWAnSSl3UOnKMj0isFnwa
	eNkSbkIGUulICAJOtYeAw==
X-ME-Sender: <xms:mUUSaaaK5cwS-xhU9OVo403uDM8aHpHjvUOkJEga3bQfJI6eFJYotw>
    <xme:mUUSaUOSdeHiAs0fTeiXjMbzaJmVlggDHFik_3fnmUbem9yoBi-ZjsckApbF86-U7
    ynkRiGLLEv74esQKOBTOEMDauyHwyQ0Mj3pKmcyAmMMdjGtG08YaQ>
X-ME-Received: <xmr:mUUSad4OyW2iSq-SNa365c0LP2qomzGAB1q2q49mc7CXAe2Fugl7AT7Z>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduleelvddvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeefgedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheplhgvohhnsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopegshhgvlhhgrggrshesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhoghgrnhhg
    seguvghlthgrthgvvgdrtghomhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrug
    hkpdhrtghpthhtoheprhhosghinhdrmhhurhhphhihsegrrhhmrdgtohhmpdhrtghpthht
    ohepjhhorhhoseeksgihthgvshdrohhrghdprhgtphhtthhopeifihhllheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepmhdrshiihihprhhofihskhhisehsrghmshhunhhgrdgt
    ohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggr
X-ME-Proxy: <xmx:mUUSafeToLKTsQbuLZM6kEmGdnK__q1ufNj_7mjY6TPn4Cb2l9HtQA>
    <xmx:mUUSaZ5tswyqdbZYVqwJwNXvGQKkUU-n3FXTHXWCfaR3FD8zq7k_Gw>
    <xmx:mUUSaYwIeBG_38H1jrw5nP_NkQ8U-7_BWcif5aZgNIXiDaOxcE8Rgg>
    <xmx:mUUSaVGomZsS1WpLMnPVYNXNtmHmLgLExnf6bot2yiXh6XuqFT7b2Q>
    <xmx:mkUSad78fRNbEVrZWG_CzNExS_1JTTFN64vZAtv96-z5USrKjNrkIkun>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 10 Nov 2025 15:05:43 -0500 (EST)
Date: Mon, 10 Nov 2025 13:05:34 -0700
From: Alex Williamson <alex@shazbot.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Krishnakant Jaju <kjaju@nvidia.com>,
 Matt Ochs <mochs@nvidia.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 linux-hardening@vger.kernel.org, Alex Mastro <amastro@fb.com>,
 Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH v7 11/11] vfio/nvgrace: Support get_dmabuf_phys
Message-ID: <20251110130534.4d4b17ad.alex@shazbot.org>
In-Reply-To: <20251106-dmabuf-vfio-v7-11-2503bf390699@nvidia.com>
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
	<20251106-dmabuf-vfio-v7-11-2503bf390699@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 026C7180011
X-Stat-Signature: 4jhk4qq4bpqo84eku5a3oec78j43edqb
X-Rspam-User: 
X-HE-Tag: 1762805147-830157
X-HE-Meta: U2FsdGVkX18Mp/FA5+R0YzArJ5JpanZ9CZLeVjNtHhuRvGteqN/uHggCoiBeyB2tTBl4Xe96GIIcT8pNe75tJ5PPYw2rLInPaTPm8mPovf79G5TNxu7OSEPwb5MkuStZ5LI2K0j5cJkUOHD6CvKppQW0doSLsc7uIsRcikr/9d7Vd30NJjv6N2eK0JuQi0Hh5wjZPiJA+8I3HQbAxkdWKJMdI2cnNRRqi0PAVzcWmj2i/XJqPKv99NdvCb9yxQV3AwgmZhCSRMD2HAYica5W+mB3Bhn4bu6vajrSwcf0iIMRXCvZVfBD6+Fuzj8e+l8M8eEOfgxRqYznphDB9cqqzj2tee5N8URKRYRMoy2dmaHp0DfsoMt1WXXOUC15M1SBvfuJ0gTnToefkcH8oKBqx33EAfp6Ymj8cfVXME2kKt5D9SdYpHb6vwOAv4U/Zt51bRJgObUAdMatsA+qCyuvM6m1zt/+cYep44BKDg+Pxh+tyNhWh5CNmYuKP4FlEKgrmb+byfCjvaZ08i3R9YWDWXNhxlKg19hWDL3zBtFydixxEdDyx/fAEnIWGHfXqVuRz3hWaTaoTNFggGcQ0AamgNvD0KbEbDz0c6A8DfrrAMQo90HeX/vUxFNLHr4e2GPAZCjre6JU70qtnqg8nf7MxI1pPNmyBrwlXm2SttxGz8YNsQBGJhaWONbPVWtSCcSlOru78mXmvrmJd6OVr2YU8QTMCbO7Deh1wz2xnE5D9BWn+6ISPUh1su+F9n0+aGSuceGT0mcUz8G72cuYvpI7hOviOZ9uCY7YgyTz5rbjw2EPUxhTHUl/GUDFle1rriu3JwVeR0VF1ukTE+2mt82Ad0TkZM9bjlZBm2rWg8nkRKT3SVTeOq/W9PPuA3qMXX5BaVrJy76i/v9k9cIA/ZM2aUyScZ5Slx5nV7q9jolkscElVnJXvPRMY5EaCOzHNehVx91oBiY5QBADus1sQxm
 QCh2o0Kt
 six/hKPjTp9FfHS5Jl0dQwabfkwmPg3INtoupxxd++JX3ouK/q08U4iTq6KX0FC5ZKfh0hXIGUJ1zBx+30qvn9m5ylf9RlXXkgU975MSX38qW1FpCDO1ISTSDcg+6EE9C3SI6yc7spzIGHe8vHuaUidxHHokNxUN/DdTHQLNWDqZeysCoP/fE8eYRRwjAxftauq3jkg5CJ7uut4aOo2hwfa54MsLL0gBTzbkO6drpQkN0+o1kD2nW/7N2MdVdrHMejpiRdSkD9H9jzgccnqG7GyVow/isO0O6D82HaYJB57uBGyHZRyxkR2Spq1/JpFyzKTtsUuzxqBZFiJLhe/m6P9ebHO2pZ+6wFW59sLjaxfUeyukdIBoTnD69esg/jnFce3GyqZjcJ6Y0n3JXHqPDMg3eEUQCL925IOIBJ2XwBx7NFDBRXEkw/O/nVOfcNqzP4yO0Ii7Nwb9Z/miOdu7lbEGMVanscaPoJiUO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  6 Nov 2025 16:16:56 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> Call vfio_pci_core_fill_phys_vec() with the proper physical ranges for the
> synthetic BAR 2 and BAR 4 regions. Otherwise use the normal flow based on
> the PCI bar.
> 
> This demonstrates a DMABUF that follows the region info report to only
> allow mapping parts of the region that are mmapable. Since the BAR is
> power of two sized and the "CXL" region is just page aligned the there can
> be a padding region at the end that is not mmaped or passed into the
> DMABUF.
> 
> The "CXL" ranges that are remapped into BAR 2 and BAR 4 areas are not PCI
> MMIO, they actually run over the CXL-like coherent interconnect and for
> the purposes of DMA behave identically to DRAM. We don't try to model this
> distinction between true PCI BAR memory that takes a real PCI path and the
> "CXL" memory that takes a different path in the p2p framework for now.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Alex Mastro <amastro@fb.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 56 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index e346392b72f6..7d7ab2c84018 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -7,6 +7,7 @@
>  #include <linux/vfio_pci_core.h>
>  #include <linux/delay.h>
>  #include <linux/jiffies.h>
> +#include <linux/pci-p2pdma.h>
>  
>  /*
>   * The device memory usable to the workloads running in the VM is cached
> @@ -683,6 +684,54 @@ nvgrace_gpu_write(struct vfio_device *core_vdev,
>  	return vfio_pci_core_write(core_vdev, buf, count, ppos);
>  }
>  
> +static int nvgrace_get_dmabuf_phys(struct vfio_pci_core_device *core_vdev,
> +				   struct p2pdma_provider **provider,
> +				   unsigned int region_index,
> +				   struct dma_buf_phys_vec *phys_vec,
> +				   struct vfio_region_dma_range *dma_ranges,
> +				   size_t nr_ranges)
> +{
> +	struct nvgrace_gpu_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_pci_core_device, core_device);
> +	struct pci_dev *pdev = core_vdev->pdev;
> +
> +	if (nvdev->resmem.memlength && region_index == RESMEM_REGION_INDEX) {
> +		/*
> +		 * The P2P properties of the non-BAR memory is the same as the
> +		 * BAR memory, so just use the provider for index 0. Someday
> +		 * when CXL gets P2P support we could create CXLish providers
> +		 * for the non-BAR memory.
> +		 */
> +		*provider = pcim_p2pdma_provider(pdev, 0);
> +		if (!*provider)
> +			return -EINVAL;
> +		return vfio_pci_core_fill_phys_vec(phys_vec, dma_ranges,
> +						   nr_ranges,
> +						   nvdev->resmem.memphys,
> +						   nvdev->resmem.memlength);
> +	} else if (region_index == USEMEM_REGION_INDEX) {
> +		/*
> +		 * This is actually cachable memory and isn't treated as P2P in
> +		 * the chip. For now we have no way to push cachable memory
> +		 * through everything and the Grace HW doesn't care what caching
> +		 * attribute is programmed into the SMMU. So use BAR 0.
> +		 */
> +		*provider = pcim_p2pdma_provider(pdev, 0);
> +		if (!*provider)
> +			return -EINVAL;
> +		return vfio_pci_core_fill_phys_vec(phys_vec, dma_ranges,
> +						   nr_ranges,
> +						   nvdev->usemem.memphys,
> +						   nvdev->usemem.memlength);
> +	}
> +	return vfio_pci_core_get_dmabuf_phys(core_vdev, provider, region_index,
> +					     phys_vec, dma_ranges, nr_ranges);
> +}


Unless my eyes deceive, we could reduce the redundancy a bit:

	struct mem_region *mem_region = NULL;

	if (nvdev->resmem.memlength && region_index == RESMEM_REGION_INDEX) {
		/*
		 * The P2P properties of the non-BAR memory is the same as the
		 * BAR memory, so just use the provider for index 0. Someday
		 * when CXL gets P2P support we could create CXLish providers
		 * for the non-BAR memory.
		 */
		mem_region = &nvdev->resmem;
	} else if (region_index == USEMEM_REGION_INDEX) {
		/*
		 * This is actually cachable memory and isn't treated as P2P in
		 * the chip. For now we have no way to push cachable memory
		 * through everything and the Grace HW doesn't care what caching
		 * attribute is programmed into the SMMU. So use BAR 0.
		 */
		mem_region = &nvdev->usemem;
	}

	if (mem_region) {
		*provider = pcim_p2pdma_provider(pdev, 0);
		if (!*provider)
			return -EINVAL;
		return vfio_pci_core_fill_phys_vec(phys_vec, dma_ranges,
						   nr_ranges,
						   mem_region->memphys,
						   mem_region->memlength);
	}

	return vfio_pci_core_get_dmabuf_phys(core_vdev, provider, region_index,
					     phys_vec, dma_ranges, nr_ranges);
		
Thanks,
Alex

