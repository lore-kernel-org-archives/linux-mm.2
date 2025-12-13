Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A55DD59F7A
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 08:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 702E16B0005; Sat, 13 Dec 2025 03:00:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68CC76B0007; Sat, 13 Dec 2025 03:00:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E4E6B0008; Sat, 13 Dec 2025 03:00:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0C56B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 03:00:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE9DF1A055A
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 08:00:13 +0000 (UTC)
X-FDA: 84213699906.28.9DFAC55
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8341A180016
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 08:00:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=PD7k7SrW;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="d b5hIDJ";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf24.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.150 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765612811; a=rsa-sha256;
	cv=none;
	b=BokS1dxUcImi7UZSR6iocCQWerRN84s7Kq1fc+7U6qqyuf3zQ5T2TfHcaF3eQ6GT/lW8yo
	xfLSPVX9TFnV8WTmRcvcNYpB8XmGWrqerxwjvidcC7tV2TOrFO6msB1zgafEL5bUTEWQaP
	HFlQCRbN2DLrosvlZ+jAf+hArkrZzqA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=PD7k7SrW;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="d b5hIDJ";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf24.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.150 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765612811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cKpV/fyfVbQhCD31q9uz0Vr0824m5w2xINKUH++CfU=;
	b=WgwzsI9AbbZWOESOf1lKmggH4GtXS3+havp266U2Q8i1zHuHxSvCOltxsYiD4HC/VIdc+p
	jS5coM6KgQgFyOQE4xAkFFJSfKjoNGstLfBVDUmeFY1NCCERMJKoNSdE+o3sNdFsl20SsQ
	74sPPXK7Oexba+HR/LHVg06b8Y22e/E=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.phl.internal (Postfix) with ESMTP id 9E74EEC0571;
	Sat, 13 Dec 2025 03:00:10 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Sat, 13 Dec 2025 03:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1765612810;
	 x=1765699210; bh=4cKpV/fyfVbQhCD31q9uz0Vr0824m5w2xINKUH++CfU=; b=
	PD7k7SrW+VLJLCwifJ5cLDKSHOPAtI3Nq6ft0mZE/r7pGm0YRIjjxRMUA//oqvUR
	N2XYY8qETgbHaPH46U1og3bwYSjQt+tr7PmDmFhWtZYkR09XHl1s0vNyGhxNFUU9
	fHWj6w7v9XvOJKYC9k5UHhUkFAPUwdrKN5KWHwPMBJmqskNuAMlord9myRNCV2bB
	hcp/Kc4JF6Jj6JAr2w0xtmcMgAFeAddfk7DtGSI2weHhNekGkxxVZHp6lEdUoDeo
	Fdd4RTw84fYPjeuidCq8QHKERicP5/B2+kVdRmTIfF8QyPRtlTcVM5KSJq+7HxbG
	OduxX7EQqP97kOhI5tPaQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1765612810; x=
	1765699210; bh=4cKpV/fyfVbQhCD31q9uz0Vr0824m5w2xINKUH++CfU=; b=d
	b5hIDJicNFH3b9OB0jJB2phHJ3qewHZuZCoujThWEntl1lDuDeAgS73te5jhO4EF
	9Q/yOTYFtUIXtfJNNnZ1CP64XhMGEqWo6pCMRY+E1aPGOLcARoPBNxwkXBPV/zC6
	ITN8RksTZFprefNBs+MxJp3vh74/q4k3Qbu/KzwqaIfXPFBDolTgqNGFKwwznyfS
	uy/Ph95RTFkgBqKoh+k5KizLhDQKwB6XIn7KvAJXX7CHryeFE5F2MsUx2LnS4jkm
	4iCZJOCN7Gd4n89Lt0UzuMTtNM6vPE+xDSf9wlO349ObeyP6C87a/iWIzX4hGv3R
	SIyS1jdQqEZGGUMgMANqA==
X-ME-Sender: <xms:CR09aZ0se5d3fy_spLds3LVWykP23hi5QJ_eccTKLMMaT2yakXNTEw>
    <xme:CR09aZdYqUErkr3zt0uuDzHNmoy5bH0Q8A7iugKAOQG7ZGxHf98FfWT343M3rveIW
    360q_eOPk2tYN3JGbXQ1UWkTEFSIKg2ezIkc3hg62vQbrJxBdnbUQ>
X-ME-Received: <xmr:CR09aSag5YeKcHmQCnWMWnKF6g3erPdMltjQi4jA1YVdZW2pcNlqKwcl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdehvdcutefuodetggdotefrod
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
X-ME-Proxy: <xmx:CR09aWXS5_16LGB8Zv-_B0guUAGOluib79melqLDniY5OlYEwDI3jg>
    <xmx:CR09adRYhMy-CWM-TT_seE_oFA2Bk7s7FFFGh988PjaW2-8cjwRW5A>
    <xmx:CR09aTEUGmVjFZuiM6tjs9PJv1_a7j10QHjI_kTDcTnLLGmL0LeLNA>
    <xmx:CR09aUdBYE-UU5jPFlusESAWcmhzir2Gv4JT7HUM7dfRQxq4KivpMA>
    <xmx:Ch09aS6qUcggBsvuf3RJTQtwZHXzdMqLHkGhpRpB3Dqw8-TVvl6jGrgq>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 13 Dec 2025 03:00:05 -0500 (EST)
Date: Sat, 13 Dec 2025 17:00:02 +0900
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <akpm@linux-foundation.org>,
 <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v2 3/3] vfio/nvgrace-gpu: register device memory for
 poison handling
Message-ID: <20251213170002.5babbf70.alex@shazbot.org>
In-Reply-To: <20251213044708.3610-4-ankita@nvidia.com>
References: <20251213044708.3610-1-ankita@nvidia.com>
	<20251213044708.3610-4-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8341A180016
X-Stat-Signature: a83tqkg5zrw81nqt5ocxynxn8ai4e5mt
X-HE-Tag: 1765612811-609087
X-HE-Meta: U2FsdGVkX1+wtjzuXkKdAaGMbLa38XmeXG33yUBKckjP3/21B7+gJ/R9lAFd+bG0nkJKyCzYwkYFM3p+imAcFRou2itDDhjbIwt8nsrbZgaSCIP2dqiF7pnYyFRnVYHJbxavVdK6m3cEFZKCp3eQoin0G2vHANnx6RvF3fP0R7U3+vScS5ciNobbBZzw/KdRMfxp84yRNJeYGxute7VxneLwt6xP195VTbRDx8Ilu21H2JaGiJ+GJ7zVuWhuaDRXWcDgqbSNPIDxlq1OKrMy3RW0h5AdICZgDbXX1MVzmuntsIB+aiU8m6T3IrOy3HkRMbfxcdTU4iDytyl2+Vq0PtbQUHUxia/iZwTSPdliozpTxpgDUA0SrlErD1Dyw1YyVQa6TT1T6NKv32SapkpMsgbSJjeBYEtChn/ucENXhFbI16IiPFfN9g0uHV4ixXZgH9X0hU0yI6rgkN15CixYXdVoXGwI6WsiB8dNQ+RL9KJrkJfCfS40Txns9Mp4npUGlrkeCw9PIXyK8BnHTIyBVusNMd2aE4vYRrp4yuVtS75huYb0Fouu1kcqsKDpd1yfWXzA6t1CBkHH++r+b7rEPrwEWdnC3W0gYgIDbijvt5Aw1emtYpWwq86WEhLebRyHyVCoPdPRw7u6Hu2oMsiRPvEVSlxQZRndGPoam81TJfdpNLWsrh/m1ki1zqam9KBd3UfuBTfTLMyAwOaKYmuClZWzKwKkCFAkddX9K4fFY0cINMUU9qDRk2iouQzjaN1giRxuQGHc8HJhuNK8Q1/ZMSVVUsQ6RNkEwmvdTKWJdCuuXFeA1ok8fKluepKSFBdhXjno6UQj2SsdyNa9oTbIAN+u0he8jCu3V1X+qrvKrNMqXWXqX1TUPQ909YdtfkMLd62n15Le5fIjOYtf2nEJ6kr0r2S6ROxdFUCXjpBHCD/hmlmS6DEwz3GVBjqBcF+Ewtiz9V/UFwtIR1xQV3S
 arzPKu6t
 ZPl7bep598nazRbEa5VPUjwyW7wYquPrmU+yPGyODOkn5xrOeKLrPDAa8G11eraq2QO4ZhLZgpb6WWnTphHdKVxJD5hZavFsaz71yhkUQaPNLQo9xXmGv6UMna6I/8Sg3fg5vQtst+6mNDZJjXL1JNqRXb4HSUbI6btDr9lcT4Q4o+Eg4hhmLWyS1hyPeTdiQhfUWdjLgyN+gvuLz/xh6eSVg34SBQCqH+jcwka/wd1t/vJ9zu4BtE6Sl+kj8bTW4LL9ukffgyhoI7QMab9UcMlfQWfccaIV0joCX53o+MSR/UXbqa99gcxNNfnSri4W3CNo3UqesN7H6U1TEXnTQesiOPkLJ0FP5wsXG3krWdU3ORAKKrJt7OlL1ThCZRIHjoA4QfBZr0FCERCFHlMv7nQekL/rP9dzLuTJYoVg6S+LfKLDjgysD8SzCnaJEws/LjgEGfOG+iSBvmGHFwg7TS8TxQJhk/8e2GgApJpLNr0nhgaancKeEq/BV6gTUMyZfsm9zTu3o2mP2KLhBEiOqec3Y81+xSsEp+f+z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Dec 2025 04:47:08 +0000
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

I'm not sure where Andrew stands with this series going into v6.19-rc
via mm as an alternate fix to Linus' revert, but in case it's on the
table for that to happen:

Reviewed-by: Alex Williamson <alex@shazbot.org>

Otherwise let's get some mm buy-in for the front of the series and
maybe it should go in through vfio since nvgrace is the only user of
these interfaces currently.  Thanks,

Alex

> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index 84d142a47ec6..91b4a3a135cf 100644
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
> +static int pfn_memregion_offset(struct nvgrace_gpu_pci_core_device *nvdev,
> +				unsigned int index,
> +				unsigned long pfn,
> +				pgoff_t *pfn_offset_in_region)
> +{
> +	struct mem_region *region;
> +	unsigned long start_pfn, num_pages;
> +
> +	region = nvgrace_gpu_memregion(index, nvdev);
> +	if (!region)
> +		return -EINVAL;
> +
> +	start_pfn = PHYS_PFN(region->memphys);
> +	num_pages = region->memlength >> PAGE_SHIFT;
> +
> +	if (pfn < start_pfn || pfn >= start_pfn + num_pages)
> +		return -EFAULT;
> +
> +	*pfn_offset_in_region = pfn - start_pfn;
> +
> +	return 0;
> +}
> +
> +static inline
> +struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct *vma);
> +
> +static int nvgrace_gpu_pfn_to_vma_pgoff(struct vm_area_struct *vma,
> +					unsigned long pfn,
> +					pgoff_t *pgoff)
> +{
> +	struct nvgrace_gpu_pci_core_device *nvdev;
> +	unsigned int index =
> +		vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +	pgoff_t vma_offset_in_region = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +	pgoff_t pfn_offset_in_region;
> +	int ret;
> +
> +	nvdev = vma_to_nvdev(vma);
> +	if (!nvdev)
> +		return -ENOENT;
> +
> +	ret = pfn_memregion_offset(nvdev, index, pfn, &pfn_offset_in_region);
> +	if (ret)
> +		return ret;
> +
> +	/* Ensure PFN is not before VMA's start within the region */
> +	if (pfn_offset_in_region < vma_offset_in_region)
> +		return -EFAULT;
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
> +static inline
> +struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct *vma)
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


