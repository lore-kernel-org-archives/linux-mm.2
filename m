Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A262CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 21:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5F0E8E0005; Thu,  6 Nov 2025 16:56:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36D28E0003; Thu,  6 Nov 2025 16:56:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4CBA8E0005; Thu,  6 Nov 2025 16:56:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 955578E0003
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:56:33 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B53B1DF4E7
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:56:33 +0000 (UTC)
X-FDA: 84081541866.21.6320782
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3C61B1A0005
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:56:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=REjd7ea4;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="T EBqBx0";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf19.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.156 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762466191; a=rsa-sha256;
	cv=none;
	b=0EKziS+rnJo9teUKOcsIFQ0E4WjTNFxtYuD6GLWlU6jQ9PR9/BXRVRZ+YXnYJS0DfSuAhV
	yT9m7dkRQhqaTQ8kLtt4vKxwpLOOiH38U6RglXf3e3AwJj93c9NUEUSn/JGYY/GCHUJlbg
	CVXYaoFEFl7nGZwdcOcuThBT/yuxtvE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=REjd7ea4;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="T EBqBx0";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf19.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.156 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762466191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPfsiLN1n3oCXH0bYb9sc+hEU45g8Wrq4al92DnOXSw=;
	b=IzoefCBes46VBqa/bvdLQwqgRLxwCX56FddeN9/QQwXq3ikumCtamRXx6vgg6QuvixOzzz
	wacftmKX/wMElM6jMnMyckTPX8lqq7W8OCANqn8hzzySvUxL0MlD4lJa2ZKsAEuv2Cumty
	LWlVuQEH9jS0I5oxAPjb16Eym4q9UFc=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 33E637A009A;
	Thu,  6 Nov 2025 16:56:29 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 06 Nov 2025 16:56:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762466189;
	 x=1762552589; bh=qPfsiLN1n3oCXH0bYb9sc+hEU45g8Wrq4al92DnOXSw=; b=
	REjd7ea48BU9x1rmydQeYrwoKcgxNX8+mUmzTKMSvlEpUs8m9K9hlcK0GbU1LEeA
	NVYPwD98/nmhIhUIkLFGqEMkZ0zcb0UQhKmGw+p9ULpJ6tfK3soxbmxm7mpK1sID
	0KVYWCJWDNk6s3a4BLoCx0SUO8J1WUcG40XOMjtQAlKGZEmb3YXWXyZUcr1PFtHv
	9lrTfMGzUTYcWiQFC9b1lvoBBt+S0AC9DYVLwU3vGQBdD5rpksjiEq8ERDMLzQh2
	TCKP8oE1oMim/s7wzlN+v5BhFYNDZ88Y+Q85D3JXd4I889RtES83LnojVTX7vIhz
	gcPNtHt1r9nbutpmtX3g/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762466189; x=
	1762552589; bh=qPfsiLN1n3oCXH0bYb9sc+hEU45g8Wrq4al92DnOXSw=; b=T
	EBqBx0vGyrD+M7zHDdEiypWw2aHj44F4s+KKGiS6E7bbBqutRUYGGdUXJDCJOPAP
	cH8T4NgtQFCrRZMfvh5JdrYimP+Atx9vaYclPTYIVED5Zl30HjeD0vqfv//7lsem
	/80j4lM4I85ZsZf0Cexk0ZY5LuzcuBze1x76Fgl5QNEJd3cNydWw5o4PC+u4vOPl
	DSgosf/FvJe/Rjs8EJdluO5i2unn6u8QIJUwn8NCw1dqdWDjpaXDTLxAdmRlbRc4
	s33o+DwUb34GVfaw0ww0pKuJ0GAxUvtYopgP56lHjoNF1Y29qJLrQ39QmyWuzt9e
	Cm0zXNNMk0OliQDNcZyzg==
X-ME-Sender: <xms:ihkNaZyuoNPb30d6i4X9m4a5JDlaVzyKERQvPEE3jNzHt2CQQ3PhSA>
    <xme:ihkNaRjbfos2rb-YOcRfsfkOJQcqWFRmF26uvJe4fv47K1yA6hxkEVdV0jWjhsjfB
    RHMgljin4t4oRzgzZD1sERWcnEn2PiyrV8uRKsfUZE0tqtIN9JI>
X-ME-Received: <xmr:ihkNaRI8Za-W-t78sM2q5XqiH2yb-clOLLraA92U79VBmkvuUWTNPmp8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeejledvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhggtgfgsehtjeertd
    dttddvnecuhfhrohhmpeetlhgvgicuhghilhhlihgrmhhsohhnuceorghlvgigsehshhgr
    iigsohhtrdhorhhgqeenucggtffrrghtthgvrhhnpeehvddtueevjeduffejfeduhfeufe
    ejvdetgffftdeiieduhfejjefhhfefueevudenucffohhmrghinhepkhgvrhhnvghlrdho
    rhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeefledpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheprghnkhhithgrsehnvhhiughirgdrtghomhdprhgtph
    htthhopegrnhhikhgvthgrsehnvhhiughirgdrtghomhdprhgtphhtthhopehvshgvthhh
    ihesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesnhhvihguihgrrdgtohhmpd
    hrtghpthhtohepmhhotghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohepshhkohhl
    ohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphhtthhopehlihhnmhhirghohh
    gvsehhuhgrfigvihdrtghomhdprhgtphhtthhopehnrghordhhohhrihhguhgthhhisehg
    mhgrihhlrdgtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtih
    honhdrohhrgh
X-ME-Proxy: <xmx:ihkNaQcEhPMq-qSqBVkoefCb_0FrAK5mvbl7mJTt0zHmSaNo0LROJw>
    <xmx:ixkNaVjv2QmUxlYiv9iqoyIZtqTYLtXDPfE3w3ztagX3NOq5dIUI3g>
    <xmx:ixkNaVmiKwJPbNlzenf75TxYAt9k9HqaWn0xSxG0NfO9US_s1_J6uw>
    <xmx:ixkNacVfSy0qbaJ67wFSS92CC5LBEmjQeDgZ49X0naGjhg6gxdpY9w>
    <xmx:jRkNaWE7ZC2BhJZqjFONk0ddcg7naexkNkaf5fTZrI7LB8RMAz3li4ND>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 6 Nov 2025 16:56:24 -0500 (EST)
Date: Thu, 6 Nov 2025 14:56:22 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <aniketa@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
 <mochs@nvidia.com>, <skolothumtho@nvidia.com>, <linmiaohe@huawei.com>,
 <nao.horiguchi@gmail.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
 <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
 <guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
 <kevin.tian@intel.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <zhiw@nvidia.com>, <dnigam@nvidia.com>,
 <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-edac@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
 <ira.weiny@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
 <u.kleine-koenig@baylibre.com>, <peterz@infradead.org>,
 <linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] vfio/nvgrace-gpu: register device memory for
 poison handling
Message-ID: <20251106145622.1610d306.alex@shazbot.org>
In-Reply-To: <20251102184434.2406-4-ankita@nvidia.com>
References: <20251102184434.2406-1-ankita@nvidia.com>
	<20251102184434.2406-4-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3C61B1A0005
X-Stat-Signature: k1c1ibo6dagud5zcjqzjkejekfyq89tr
X-Rspam-User: 
X-HE-Tag: 1762466191-493043
X-HE-Meta: U2FsdGVkX1+qsirYxJ9WaBt9l/1fG4Ngf2gkun+IHJC36Rx0YOEkoaVx0VSa0dTUEncLpMY34X++RyuPR1E/+1chIo5lbHbM5+2Sjrew5s0d12zm5It9pQ1+V0cy6DfgCAN/AfzK1SN8bN555zz5pSKYqYTPiWOy8FUOBsZi6csG19HQ/9npzAtPOIO1r24KY9jAN/v+ugVH3AJ7dxIBMhC/NBJox9TewvrHBMMh9lxi+MyqsUiDVPs/BpspDE3VU8JbXrWwKAsYlO/T1noipxQHk6hkn1difF0cdisGAs5dZsJTe9MLFBL0DlNB7Y9Y3QiQ1Ytjn3Vmpcn6fe9cb6u3BbAsXn8ROe9AdfDIzkX8CWPRtCx5G044npMw+HfUGeJHw4g2eI4T2akLYEmRb4HTCvNvkE8jKqQUl29MRmXbnipXcbXr2eNNOk45g5K5biL1CwTCKSVN0XGQROyyLCOS6YJzx3HHiwPbRisKXo005muIeSWqgLn2Dxb2S4zMW1cMTHRDFa47efeZbd8CB76UrrxjMxJEJQCt038k+d3SZko44KT0YHnhqV+g52iSrRrbSN2/agyzJ09UQIGijMscBwD2/Dvlvimor7FKNAOjfDeOAvASpuwveK3twVGBbzyPeuJalVJ3PIbIGYVd06jZdtbzXKcc0AXm1ty6atb0UBPx0jsaTwB7KF0mR7xLYZYSNCSWSKDq+bu00fN338jkRe29EIcvqwxatr2K8wbkAalu5mCNYodJGwzxuzqPZrk+W7gOCaHC+4JAY4AZuoyPAhZQVq/Q3MNb/GPCFSg7tcnScFj451/o0CA/ltk8HEFs2AtoiiY3svk6w8bQ/kNEIDb4EgnnOq5ItZBnq61sUke6pqzR7KSJodeHxo6ycGegzqGju+ucrN1hcOhPFpIvO/jRO7HiZ5ibgHL+7UzLMC/EIWe245WKjiO6DzJiqFMAogJqyx1y2UaCYtf
 W0fhplx6
 3lcrKfaoR/NHQj6D6D3ZWs3UDCMmd+Kx+a2jKx2Gme/i7YQBsUG2pc25qNHKwX0CTBNVbyJGmw+tAxdF9/NPFk2bi52XqF4KT5ZvNu2FK4h8VYdcutYJiRTquiN88iK0LMOKFLNxZ7qra06HoP0+UZFOSGmYfX2KEQFr6eNKESQj9oTTNGo3y+44iTiiccuJAmeQEfD9b6r+j8I6NO+yHEVgCkoyRhMtb7GxhboKzewcxZCgBV+L1BCxB6e945qtko0FHpIGqdIaNNRcoicrDAbvDF2BUjoUICNBzWv1kFN55uZN5qUFkuOoYQ7QUQr2Cv7N7285c0a7eZp8U+HR0lBmgObBt/6lK1L/p/ewiR9KroDGSPY0SJIoIPpUqk6gMAC+yHIaSG+00L0myLmRhLE7Ly/AAoQDEhgws+P4RLyxiP3XklhJZCIfM0+qSl57pZhyeq+X5/x5sCQsQtKj/jeK+xSQ3yQx6x3YvPxZlWvsIxxgopXCR7EDDsgBJ6dpoY4yPkfTg/SfriVuUv2wWTUZjZEZQAb28J4K9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2 Nov 2025 18:44:34 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The nvgrace-gpu-vfio-pci module [1] maps the device memory to the user VA
> (Qemu) using remap_pfn_range() without adding the memory to the kernel.
> The device memory pages are not backed by struct page. The previous
> patch implements the mechanism to handle ECC/poison on memory page without
> struct page. This new mechanism is being used here.
> 
> The module registers its memory region and the address_space with the
> kernel MM for ECC handling using the register_pfn_address_space()
> registration API exposed by the kernel.
> 
> Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [1]
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 45 ++++++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)

LGTM.  I see Andrew has already picked this up in mm-new, if he
refreshes, here's another ack.

Acked-by: Alex Williamson <alex@shazbot.org>

Thanks,
Alex

> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index d95761dcdd58..80b3ed63c682 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -8,6 +8,10 @@
>  #include <linux/delay.h>
>  #include <linux/jiffies.h>
>  
> +#ifdef CONFIG_MEMORY_FAILURE
> +#include <linux/memory-failure.h>
> +#endif
> +
>  /*
>   * The device memory usable to the workloads running in the VM is cached
>   * and showcased as a 64b device BAR (comprising of BAR4 and BAR5 region)
> @@ -47,6 +51,9 @@ struct mem_region {
>  		void *memaddr;
>  		void __iomem *ioaddr;
>  	};                      /* Base virtual address of the region */
> +#ifdef CONFIG_MEMORY_FAILURE
> +	struct pfn_address_space pfn_address_space;
> +#endif
>  };
>  
>  struct nvgrace_gpu_pci_core_device {
> @@ -60,6 +67,28 @@ struct nvgrace_gpu_pci_core_device {
>  	bool has_mig_hw_bug;
>  };
>  
> +#ifdef CONFIG_MEMORY_FAILURE
> +
> +static int
> +nvgrace_gpu_vfio_pci_register_pfn_range(struct mem_region *region,
> +					struct vm_area_struct *vma)
> +{
> +	unsigned long nr_pages;
> +	int ret = 0;
> +
> +	nr_pages = region->memlength >> PAGE_SHIFT;
> +
> +	region->pfn_address_space.node.start = vma->vm_pgoff;
> +	region->pfn_address_space.node.last = vma->vm_pgoff + nr_pages - 1;
> +	region->pfn_address_space.mapping = vma->vm_file->f_mapping;
> +
> +	ret = register_pfn_address_space(&region->pfn_address_space);
> +
> +	return ret;
> +}
> +
> +#endif
> +
>  static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
>  {
>  	struct nvgrace_gpu_pci_core_device *nvdev =
> @@ -127,6 +156,13 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
>  
>  	mutex_destroy(&nvdev->remap_lock);
>  
> +#ifdef CONFIG_MEMORY_FAILURE
> +	if (nvdev->resmem.memlength)
> +		unregister_pfn_address_space(&nvdev->resmem.pfn_address_space);
> +
> +	unregister_pfn_address_space(&nvdev->usemem.pfn_address_space);
> +#endif
> +
>  	vfio_pci_core_close_device(core_vdev);
>  }
>  
> @@ -202,7 +238,14 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>  
>  	vma->vm_pgoff = start_pfn;
>  
> -	return 0;
> +#ifdef CONFIG_MEMORY_FAILURE
> +	if (nvdev->resmem.memlength && index == VFIO_PCI_BAR2_REGION_INDEX)
> +		ret = nvgrace_gpu_vfio_pci_register_pfn_range(&nvdev->resmem, vma);
> +	else if (index == VFIO_PCI_BAR4_REGION_INDEX)
> +		ret = nvgrace_gpu_vfio_pci_register_pfn_range(&nvdev->usemem, vma);
> +#endif
> +
> +	return ret;
>  }
>  
>  static long


