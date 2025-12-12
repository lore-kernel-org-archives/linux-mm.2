Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E118D59F53
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 23:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352406B0005; Fri, 12 Dec 2025 18:48:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304136B0007; Fri, 12 Dec 2025 18:48:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1616B0008; Fri, 12 Dec 2025 18:48:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C3056B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 18:48:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98EABB89FF
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 23:48:07 +0000 (UTC)
X-FDA: 84212459814.23.4F174D4
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9FF4640003
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 23:48:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=1DZrOSHE;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="C LT5ut7";
	spf=pass (imf12.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.154 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765583285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9TXVWpHLXJtDlvpLHB65RP0R7uQG8nC3Fdf5xQm6B8=;
	b=bt3Xz8tKXTh/BKM/EsuYqkHQGaE4aejxkYuJrfdxXAYAa8P/p6XRsYD2P+6zR7IVCfSe3/
	GKTLcSt2SoY+uAV0rMWIJrdbCo8yaZ9PmGT3Iz2pfFUIxVCMeIwyqup4k84w1vPU0eUO6R
	PfTx/O1i3kAlp9RWAhcfrDKRy2vFSrw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=1DZrOSHE;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="C LT5ut7";
	spf=pass (imf12.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.154 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765583285; a=rsa-sha256;
	cv=none;
	b=oye4BFMhvy6f9EpWgWQ3rTHGvkbn+9fS9OFxSHEzcq+XImE6tkluPVyrKpkpWhKBtzFRCb
	ykR9unPjM2Oo76FwGwQOXhHHHmpgCU6IcAl6uH6p2cnkPPW2XoJYLsBPRv26/QSMy4PcLW
	CxOZQjJehmj/IvrCiI2JGXQm8jRa6DE=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E6FF114001FC;
	Fri, 12 Dec 2025 18:48:04 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 12 Dec 2025 18:48:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1765583284;
	 x=1765669684; bh=W9TXVWpHLXJtDlvpLHB65RP0R7uQG8nC3Fdf5xQm6B8=; b=
	1DZrOSHEWSaX3XkP88w8X+/lMkOOHcZEZB940z2Ofk5NpYAbkuxFSy00o79V3ZV4
	Xc3IEI1Gx6mRdESMYo4VqZ20Mrd+U4NCGzWncUdFaBP3Fi5FElaxj6snPDFE0MU2
	lj1fs4U9k4SggxzuQDtUVSpn6G80fCIETEgtUwk0rM1bvS9ul0tN3DsghMEruLQV
	M4CVZnPZ7AJvnJSTAH/W9swOU3EBSkz5cRGij0IBGMi365cZ4n2lk561X19PNzDW
	uFdBOY9a+8Uns3oPGjHE3Ys/VdnacyImiS3wt86ITVWb9jDpcAMFzrCOdpWVSJ0Z
	fx7LnZSBtmQ3hQicAWpr/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1765583284; x=
	1765669684; bh=W9TXVWpHLXJtDlvpLHB65RP0R7uQG8nC3Fdf5xQm6B8=; b=C
	LT5ut7GZaCtq8BU02crDWkE24z2UscNkCREB+vs/1u12Tce92HTAdBwJ8f2LvG0f
	F0ku0rBYVjHRlnZS4JsyEuJI0TgmWCMABdDB4gOs2jltU4g31uwzkBTrOy+B9yo8
	zKiqxZYtPhVl+uOf2tdVy26bemNvP9HB4+reKEtdaDDS3+1BmNfLiZs3MGe+pTRF
	K5g/71scGJ1sWWWZkZORhp+0E8VTp+JntUMJYEH9u9sq4pU+A3mjbRaOD1gPY73A
	ih6fsPTlXy+6/er/cd9OqBHHsvBQ+XmzxDndhAGu6ZfARYEfX63TytyLeITmnFsJ
	ZeBofGbv117E95fGD34hA==
X-ME-Sender: <xms:tKk8aQX6cp5HO_gokUSEOFam63oerwI3eO-Wn-i6ePHOYbzWf_lYAA>
    <xme:tKk8afwvMGZyTVrHjT-nvVORRSlvWd3pmvCxzDMRHwHrOeoe0qv_UuziakTDKA0Zf
    zW_8PcdNdY6wWECX5nEp_KlTejivc3U7E_0IavCgqgkEYMfqQCr4A>
X-ME-Received: <xmr:tKk8aYNUKc5qUa_SVNgYBvscPpsYApi--brKofNa6841tVK2HIjjkdJb>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvleehgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkjghfgggtgfesthejredttd
    dtvdenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhhrgii
    sghothdrohhrgheqnecuggftrfgrthhtvghrnhephedvtdeuveejudffjeefudfhueefje
    dvtefgffdtieeiudfhjeejhffhfeeuvedunecuffhomhgrihhnpehkvghrnhgvlhdrohhr
    ghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlh
    gvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepudejpdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopegrnhhkihhtrgesnhhvihguihgrrdgtohhmpdhrtghpth
    htohepvhhsvghthhhisehnvhhiughirgdrtghomhdprhgtphhtthhopehjghhgsehnvhhi
    ughirgdrtghomhdprhgtphhtthhopehmohgthhhssehnvhhiughirgdrtghomhdprhgtph
    htthhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopehskhholhhothhhuhhmthhh
    ohesnhhvihguihgrrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunh
    gurghtihhonhdrohhrghdprhgtphhtthhopehlihhnmhhirghohhgvsehhuhgrfigvihdr
    tghomhdprhgtphhtthhopehnrghordhhohhrihhguhgthhhisehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:tKk8aZqz90rPtd-LBFImpOT3VRDxAAWLD22Le4uK9e71EHEtn_q99A>
    <xmx:tKk8aX-eTUKtMHd33mXZoboaaeShWwxvHNPWhkKiybM7C1E_ca__7w>
    <xmx:tKk8aX04fPDhgBFtbmrP8Ehr7IZmC7J9vi1gJ7d7AswTm01hh7fZnw>
    <xmx:tKk8aSAaJcIcj2JAXOegFPF28IaJpUv7ht6UFI5bdW0sdSR_nmfQFw>
    <xmx:tKk8aWywaqytJhxzbTZBoJ4YftNYW1tgIyETuBZ9xUK2o6AQb3zsU3ZG>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Dec 2025 18:48:00 -0500 (EST)
Date: Sat, 13 Dec 2025 08:47:57 +0900
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <akpm@linux-foundation.org>,
 <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v1 3/3] vfio/nvgrace-gpu: register device memory for
 poison handling
Message-ID: <20251213084757.0e6089f7.alex@shazbot.org>
In-Reply-To: <20251211070603.338701-4-ankita@nvidia.com>
References: <20251211070603.338701-1-ankita@nvidia.com>
	<20251211070603.338701-4-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: dcd19jjedap3jyrfdrhqinmiz6efq6ar
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FF4640003
X-HE-Tag: 1765583285-430243
X-HE-Meta: U2FsdGVkX19NxZOKYTyWV+wzDEqpGWJuZLP5zsNeLHa4DAR7nKOmI+yCO0EBXw9eLNnVM0WuyUpEeLirnVlHjeKmVelMzysiHz2hQkbSiVOpEdG6Vp+pGMJHEUFcwl5Yik7Egnt3AYKWvN8PhleNlLY4bxZG0Y42Z9gYgbJuRBmuR1lmW6wnHt4Fwv6PogvWfK8tU6qdt7IUWav+0xGIFPsBSo3EJ4hjVjG7c41E0lbqao9EDOVOvTiZSIlWGfKS3b9hX/dfSMxziCZES78+z6OzO9vdhzATEepWwOVQU3Xv+74RS+cXbPq2JwsPdsF1rzNGjZE9AN6qZjYYidl4SlL8VfrVZZSWtKLMOb/Um/+foKJRKoaXoyOw8y40X9L1ruqymCG+rz4bwvavEgQqKW4xb/YztY0GKpNI9LTwi0H5ojauuM6imoxqIaBA7gJ+gH638qSzUadcIQz+Imi05biJ2j7vfJCtbqiMBu647Udk5KSPd8y6fyhI4fRRJTs3HOmYS7dtg/LkadbM6wRjSSpGzxxO54aloljvFKrXjlbzcZVNP2xnwGxFtbzoZFJ/3buAooYn3GzSECKg2T3zEI7j4VsRQ/0Yh7GVmY43cCIhrqOBbJIJ/U4hemKhsvjnKYECfqkqE2CQvm4QjNvP7D0ogpENmjoem+4xbKgevNkAhGGfIF8lalTWbnfIsVgQG10IzwSIeSbpzhcNz+xjEkMdWlhK6SbnR8CBcA7vEMvlAABxojKl6jCt77fri4fffmb7JTAahgEm7dpYIQhC/kFLQ9lFjN9Z08eOGJxaRFr8fe97kNIpmvJZVQYnH5XMi0LiB1ZzIJw4LZvaRHZTdt1Uf2nPXSAK35EQUVcv1THeohOBQpSYCV3M86slnJLh260f4nfcBZ1Kb0sP0L+/jLd9k09NKcB2XL/cuJtDyASe5LzRz0ZYL7Ouo4IsycxeCoqC+Dy5/7kwV6/0V20
 h3Tss+oG
 twkIM2qlva/SdiuIahl0GDS0z4dJWkaA0iZkVNi1JRR/7n/OdifmhWoNIvhlCbx26E7xssEmkfiS8NYVlzx1tDiHdfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 07:06:03 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The nvgrace-gpu module [1] maps the device memory to the user VA (Qemu)
> without adding the memory to the kernel. The device memory pages are PFNMAP
> and not backed by struct page. The module can thus utilize the MM's PFNMAP
> memory_failure mechanism that handles ECC/poison on regions with no struct
> pages.
> 
> The kernel MM code exposes register/unregister APIs allowing modules to
> register the device memory for memory_failure handling. Make nvgrace-gpu
> register the GPU memory with the MM on open.
> 
> The module registers its memory region, the address_space with the
> kernel MM for ECC handling and implements a callback function to convert
> the PFN to the file page offset. The callback functions checks if the
> PFN belongs to the device memory region and is also contained in the
> VMA range, an error is returned otherwise.
> 
> Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [1]
> 
> Suggested-by: Alex Williamson <alex@shazbot.org>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 116 +++++++++++++++++++++++++++-
>  1 file changed, 112 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 84d142a47ec6..fdfb961a6972 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -9,6 +9,7 @@
>  #include <linux/jiffies.h>
>  #include <linux/pci-p2pdma.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/memory-failure.h>
>  
>  /*
>   * The device memory usable to the workloads running in the VM is cached
> @@ -49,6 +50,7 @@ struct mem_region {
>  		void *memaddr;
>  		void __iomem *ioaddr;
>  	};                      /* Base virtual address of the region */
> +	struct pfn_address_space pfn_address_space;
>  };
>  
>  struct nvgrace_gpu_pci_core_device {
> @@ -88,6 +90,83 @@ nvgrace_gpu_memregion(int index,
>  	return NULL;
>  }
>  
> +static inline int pfn_memregion_offset(struct nvgrace_gpu_pci_core_device *nvdev,

Per Documentation/process/coding-style.rst this doesn't meet the
guidelines for being declared inline.

> +				       unsigned int index,
> +				       unsigned long pfn,
> +				       u64 *pfn_offset_in_region)

Is a pgoff_t more appropriate here?

> +{
> +	struct mem_region *region;
> +	unsigned long start_pfn, num_pages;
> +
> +	region = nvgrace_gpu_memregion(index, nvdev);
> +	if (!region)
> +		return -ENOENT;
> +
> +	start_pfn = PHYS_PFN(region->memphys);
> +	num_pages = region->memlength >> PAGE_SHIFT;
> +
> +	if (pfn < start_pfn || pfn >= start_pfn + num_pages)
> +		return -EINVAL;
> +
> +	*pfn_offset_in_region = pfn - start_pfn;
> +
> +	return 0;
> +}
> +
> +static inline struct nvgrace_gpu_pci_core_device *
> +vma_to_nvdev(struct vm_area_struct *vma);

Ugly line wrapping, try:

static inline
struct nvgrace_gpu_pci_core_device *vma_to_nvdev(...

> +
> +static int nvgrace_gpu_pfn_to_vma_pgoff(struct vm_area_struct *vma,
> +					unsigned long pfn,
> +					pgoff_t *pgoff)
> +{
> +	struct nvgrace_gpu_pci_core_device *nvdev;
> +	unsigned int index =
> +		vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +	u64 vma_offset_in_region = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);

It's still a pgoff_t

> +	u64 pfn_offset_in_region;

As is this.

> +	int ret;
> +
> +	nvdev = vma_to_nvdev(vma);
> +	if (!nvdev)
> +		return -EPERM;

More of a nit, but the errnos seem like they could use a little more
thought.  The above is more of a "not my vma", ie. ENOENT.  Failing to
get a mem_region associated with a vma that is confirmed ours is more
of an invalid arg, EINVAL.  Ultimately the question though is does this
pfn land in this vma and if so provide the pgoff_t relative to the vma.
So maybe a pfn unassociated to the vma is more of a bad address, EFAULT.

> +
> +	ret = pfn_memregion_offset(nvdev, index, pfn, &pfn_offset_in_region);
> +	if (ret)
> +		return ret;
> +
> +	/* Ensure PFN is not before VMA's start within the region */
> +	if (pfn_offset_in_region < vma_offset_in_region)
> +		return -EINVAL;

This is really just another version of the pfn is not associated to the
vma, the only difference is the pfn lands on the device, but still
probably -EFAULT.

> +
> +	/* Calculate offset from VMA start */
> +	*pgoff = vma->vm_pgoff +
> +		 (pfn_offset_in_region - vma_offset_in_region);
> +
> +	return 0;
> +}
> +
> +static int
> +nvgrace_gpu_vfio_pci_register_pfn_range(struct vfio_device *core_vdev,
> +					struct mem_region *region)
> +{
> +	int ret;
> +	unsigned long pfn, nr_pages;
> +
> +	pfn = PHYS_PFN(region->memphys);
> +	nr_pages = region->memlength >> PAGE_SHIFT;
> +
> +	region->pfn_address_space.node.start = pfn;
> +	region->pfn_address_space.node.last = pfn + nr_pages - 1;
> +	region->pfn_address_space.mapping = core_vdev->inode->i_mapping;
> +	region->pfn_address_space.pfn_to_vma_pgoff = nvgrace_gpu_pfn_to_vma_pgoff;
> +
> +	ret = register_pfn_address_space(&region->pfn_address_space);
> +
> +	return ret;
> +}
> +
>  static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
>  {
>  	struct vfio_pci_core_device *vdev =
> @@ -114,14 +193,28 @@ static int nvgrace_gpu_open_device(struct vfio_device *core_vdev)
>  	 * memory mapping.
>  	 */
>  	ret = vfio_pci_core_setup_barmap(vdev, 0);
> -	if (ret) {
> -		vfio_pci_core_disable(vdev);
> -		return ret;
> +	if (ret)
> +		goto error_exit;
> +
> +	if (nvdev->resmem.memlength) {
> +		ret = nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev, &nvdev->resmem);
> +		if (ret && ret != -EOPNOTSUPP)
> +			goto error_exit;
>  	}
>  
> -	vfio_pci_core_finish_enable(vdev);
> +	ret = nvgrace_gpu_vfio_pci_register_pfn_range(core_vdev, &nvdev->usemem);
> +	if (ret && ret != -EOPNOTSUPP)
> +		goto register_mem_failed;
>  
> +	vfio_pci_core_finish_enable(vdev);
>  	return 0;
> +
> +register_mem_failed:
> +	if (nvdev->resmem.memlength)
> +		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
> +error_exit:
> +	vfio_pci_core_disable(vdev);
> +	return ret;
>  }
>  
>  static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
> @@ -130,6 +223,11 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
>  		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
>  			     core_device.vdev);
>  
> +	if (nvdev->resmem.memlength)
> +		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
> +
> +	unregister_pfn_address_space(&nvdev->usemem.pfn_address_space);
> +
>  	/* Unmap the mapping to the device memory cached region */
>  	if (nvdev->usemem.memaddr) {
>  		memunmap(nvdev->usemem.memaddr);
> @@ -247,6 +345,16 @@ static const struct vm_operations_struct nvgrace_gpu_vfio_pci_mmap_ops = {
>  #endif
>  };
>  
> +static inline struct nvgrace_gpu_pci_core_device *
> +vma_to_nvdev(struct vm_area_struct *vma)

Same wrapping suggestion as above.  Thanks,

Alex

> +{
> +	/* Check if this VMA belongs to us */
> +	if (vma->vm_ops != &nvgrace_gpu_vfio_pci_mmap_ops)
> +		return NULL;
> +
> +	return vma->vm_private_data;
> +}
> +
>  static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>  			    struct vm_area_struct *vma)
>  {


