Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05F69E67495
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 17:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CF9C6B0088; Mon, 22 Dec 2025 12:04:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A7356B0089; Mon, 22 Dec 2025 12:04:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3A26B008A; Mon, 22 Dec 2025 12:04:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F1C856B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 12:04:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BAADCC02BC
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:04:31 +0000 (UTC)
X-FDA: 84247730742.19.26E144F
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6F72210001D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:04:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=Z8RW9LHX;
	dmarc=pass (policy=quarantine) header.from=deltatee.com;
	spf=pass (imf05.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766423069; a=rsa-sha256;
	cv=none;
	b=aWYv5ZqoT6vgxsZGSD5efugwIxufnqrnjnAQYb+7xzaqqZhuGdAe64K1x+fxFZDlSCU2zu
	8ZH+CGeHEOfaDL21mL0sjCH20JH3+xsI7q1WxlonzGFpXLDUZh2sY+TD7AYM8BQx4vo4l6
	CI77DopRA6I/Ao6swfGSCo1RbS1aTSU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=Z8RW9LHX;
	dmarc=pass (policy=quarantine) header.from=deltatee.com;
	spf=pass (imf05.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766423069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhEdYDLpAvxS3FC6ZENa/gvzH1E2CyhCMJEO+Kd10VA=;
	b=yU9wy1oOlk9BxsG94X3gGFxyPHfOiDAmLDCHZNrt3Xg0iuMo1WoCF6wi4/1jrAlPDFXE4t
	UuZuBK6LkMjiI7afcwNE4cm0QpABFBUsUXlDuJXjAy70Bs7me3weh+U/Mi3cZ1wKOqtltc
	UAL+eqaebgA2REGt/vJzTkZn30Uipn4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=UhEdYDLpAvxS3FC6ZENa/gvzH1E2CyhCMJEO+Kd10VA=; b=Z8RW9LHXz3jTEXW9CLMsrh9IU4
	L2CbiFl6A0PCVnrkPJGCRBSosZD2qPXxEA/95JHxyPYkBZLwjg2XYOMPfLvxe3HFAsJdnV3do7YpB
	/cxaiCMuRMNy3uU4JX7Z/PT9n9mH8nWhSImLNeM8+6Dbb1+ydFsuBp/V0+B7poTx9tXF3XwQ3rEyF
	XsPAPTy8qkc4hxELW92MXPQNxnIJqeupxf6EyiRBHMGG/+vYl9m8pcFWHAsCtDglAH4lcWW02m8SA
	3O4a2K1yKGiuzaKL7C7raxEjbjGKaDdhIIFAaCaGRumg9i8t4ZTDW/P16HPVwA+5MRlZnir7/OUeZ
	OBVdU8aQ==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <logang@deltatee.com>)
	id 1vXjKd-00000008JyE-3VcS;
	Mon, 22 Dec 2025 10:04:28 -0700
Message-ID: <07a785e5-5d2e-4c81-a834-1237c79fdd51@deltatee.com>
Date: Mon, 22 Dec 2025 10:04:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Hou Tao <houtao@huaweicloud.com>, linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, linux-mm@kvack.org,
 linux-nvme@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>,
 Alistair Popple <apopple@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Keith Busch
 <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 houtao1@huawei.com
References: <20251220040446.274991-1-houtao@huaweicloud.com>
 <20251220040446.274991-11-houtao@huaweicloud.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20251220040446.274991-11-houtao@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: houtao@huaweicloud.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-mm@kvack.org, linux-nvme@lists.infradead.org, bhelgaas@google.com, apopple@nvidia.com, leonro@nvidia.com, gregkh@linuxfoundation.org, tj@kernel.org, rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, houtao1@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 10/13] PCI/P2PDMA: support compound page in
 p2pmem_alloc_mmap()
X-SA-Exim-Version: 4.2.1 (built Sun, 23 Feb 2025 07:57:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F72210001D
X-Rspamd-Server: rspam10
X-Stat-Signature: 1ghxh87jzro4p4o8mkpu6bwm7ekf7rsg
X-HE-Tag: 1766423069-563242
X-HE-Meta: U2FsdGVkX1/2iDQWd02ecOK9txZ2M5CE8mT/hIQVTvAoX9q7Z05mYm7HG5tOGDOcgj2rhCGtNN7kLo8+24eC0/a2vMWxV6dMnnzUUWUaXlYUEbwe14ujni3/zG9pQ0PwAQpy/0ZBEwAoHnPjP5u7V6HVs4X9kkyZzajJJhvbRfCCQK3Zqt4cvmvB+gvEl6drzAa3dBxlG5Tsz+V94mr8g32WRFU1JPpThjCs2Eqrs1BYaV276Q+MuG3YeNRlIDm2ncQj5UZ0qAY2vWY+FXF1Vg+ocpK/K1dYHJDkcAto7WxzVFIeMZx2SiAWTanDGtzZZLMzmqU7QxklGk05vpyJGdYgU2Hh9mTxJQqukqT38yzKsxk/xMSk+fgAaIu+5/BHQT1lcsZafqtvZNoPzYzpC2XagiL3MytBe4zZWzF46hCYzZtuVa37VzJmt6UsA/8nnOXzM5PEAzafnaBYDCwOGMYMF5UVjiGS+555h9Di6+MQQc5gXabAmdVnjApNCoUCcmlSChySEqPGPEkw1gDYYZ5a71arjdxHaPkub8/DblN8Xcw4FWLNFf0ScLs9uZuKIyZC/5eGlUKSgjSoqBiFTU1+cn75c64CSyPer+Il0otCr/bhZzmi9mhh/RcPpPTObxAr9B+1c6ur4lJ57WFbIYoLkKZnQ2ee7pMvL9VQi2+ipTybJhlgoYEgM5kzw4g26XYzttP2/S/iVcgi30Xpnv6Qbs4vYQ82pd4mAI+6cABPjpm3BgpV/6CFvzAgq4nUTrSOkJvNyRaMBppzgH79GmnhSKUYcA7GwyqqxcqnRvYQISnUlg5TIrca+FyY7tUVfjptw3ruWnEOURDFk5epgMP2KpRzHtX52XkqztNX6LPlbKgqF6x8TnpxgdiUWIGV+MMPsNdmdEJbwsRCvJXYMSM/Geex6aWFKCoWcaKtJ/6sHa1fXhpxFCBGF3Lzvan/49m/A97l8klajBw45NK
 o7It4kSm
 ywRRt2Ew10uicMRRJg/3E0p8/vlapegy5AdqcopESm4VyeXmEheVO6DA+BvKbCMsY3h4sOyMsfP1xurg1dOUTuW76v0GBB1Iyf8zUz7IcQytCjPLc0UKPddjy6mR7wDCkrKEt5u2vrO8bL0XrBlqTiDU44A1dVizAL+DRyfmvaZJamdN1NG1jtmorNWEkM938zLANQwOj1L3SiIbCIn7aoE7e42fOqoaGN5ykfpmnz+cfMfWzUaiqzImASyBuAirvqYu74YTxpm0Ci5ATB7AxJwnzxwVbSZsw53T6LWuGbKwCBX1cJbiAvpF2izAuTSy27k2wEAug5P+2m9UDPE/q1laZp/8FNb6f4v9+mUxOlMka1LKvPwJmGQo2eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025-12-19 21:04, Hou Tao wrote:
> From: Hou Tao <houtao1@huawei.com>
> 
> P2PDMA memory has already supported compound page and the helpers which
> support inserting compound page into vma is also ready, therefore, add
> support for compound page in p2pmem_alloc_mmap() as well. It will reduce
> the overhead of mmap() and get_user_pages() a lot when compound page is
> enabled for p2pdma memory.
> 
> The use of vm_private_data to save the alignment of p2pdma memory needs
> explanation. The normal way to get the alignment is through pci_dev. It
> can be achieved by either invoking kernfs_of() and sysfs_file_kobj() or
> defining a new struct kernfs_vm_ops to pass the kobject to the
> may_split() and ->pagesize() callbacks. The former approach depends too
> much on kernfs implementation details, and the latter would lead to
> excessive churn. Therefore, choose the simpler way of saving alignment
> in vm_private_data instead.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  drivers/pci/p2pdma.c | 48 ++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index e97f5da73458..4a133219ac43 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -128,6 +128,25 @@ static unsigned long p2pmem_get_unmapped_area(struct file *filp, struct kobject
>  	return mm_get_unmapped_area(filp, uaddr, len, pgoff, flags);
>  }
>  
> +static int p2pmem_may_split(struct vm_area_struct *vma, unsigned long addr)
> +{
> +	size_t align = (uintptr_t)vma->vm_private_data;
> +
> +	if (!IS_ALIGNED(addr, align))
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static unsigned long p2pmem_pagesize(struct vm_area_struct *vma)
> +{
> +	return (uintptr_t)vma->vm_private_data;
> +}
> +
> +static const struct vm_operations_struct p2pmem_vm_ops = {
> +	.may_split = p2pmem_may_split,
> +	.pagesize = p2pmem_pagesize,
> +};
> +
>  static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>  		const struct bin_attribute *attr, struct vm_area_struct *vma)
>  {
> @@ -136,6 +155,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>  	struct pci_p2pdma *p2pdma;
>  	struct percpu_ref *ref;
>  	unsigned long vaddr;
> +	size_t align;
>  	void *kaddr;
>  	int ret;
>  
> @@ -161,6 +181,16 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
>  		goto out;
>  	}
>  
> +	align = p2pdma->align;
> +	if (vma->vm_start & (align - 1) || vma->vm_end & (align - 1)) {
> +		pci_info_ratelimited(pdev,
> +				     "%s: unaligned vma (%#lx~%#lx, %#lx)\n",
> +				     current->comm, vma->vm_start, vma->vm_end,
> +				     align);
> +		ret = -EINVAL;
> +		goto out;
> +	}

I'm a bit confused by some aspects of these changes. Why does the
alignment become a property of the PCI device? It appears that if the
CPU supports different sized huge pages then the size and alignment
restrictions on P2PDMA memory become greater. So if someone is only
allocating a few KB these changes will break their code and refuse to
allocate single pages.

I would have expected this code to allocate an appropriately aligned
block of the p2p memory based on the requirements of the current
mapping, not based on alignment requirements established when the device
is probed.

Logan




