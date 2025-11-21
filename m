Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0017CFA477
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C1D6B0005; Fri, 21 Nov 2025 02:42:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473876B002F; Fri, 21 Nov 2025 02:42:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0176B007B; Fri, 21 Nov 2025 02:42:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D76F6B0005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:42:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DDB689724
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:42:11 +0000 (UTC)
X-FDA: 84133820862.29.98A90F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id DF1A34000F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:42:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OCp8Vjg5;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763710930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/KEycfDU5dbemzTmvPoWI+dqub2SV+Wew6jjaLEtds=;
	b=NHBWX1h3sfCYdRaQc0/3Eb31Mf0z2EB0buU4rj/mcEoVc8YELkqTyINpZfcR+2GWWm3Npj
	B0p7Wbq/ybxrz/GHSG1Jc3IgYgUtmhoyorMoltbNPnzUjTTT4HcidvmYGye5EfW39A3Tdv
	oLEmXBoSckhVH0EXDSXfJ2eaIcPi5d4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763710930; a=rsa-sha256;
	cv=none;
	b=j6Y12/hMUnJdm/iRduHplH8Ct71YD0A/HxVHewIHLxqwqhX1JGVxVEiJHKWBPx5Qd2V8XO
	4qCqlvdjt9727t0uALqrxaw8v9R73plGmu8l3+go/qxMhufR4gar8U/Bl/u16ubzem61rr
	THWvfKra+ysrjUOEGL9aICA+lZEJP0Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OCp8Vjg5;
	spf=pass (imf01.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD73D440E4;
	Fri, 21 Nov 2025 07:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F4DC4CEF1;
	Fri, 21 Nov 2025 07:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763710928;
	bh=O/owrQ7LTAA9ZbRZu64BC64XoYmRo+uhZTzeo+Ew2jc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OCp8Vjg5oImfKWfN4GXv7kmUMrNS5krBORtVRTmwcB4DOZvoX+/g/t4vr9ZWu6UJl
	 1Vj7sFNlUll1T9YUQc4xpzO6PKziNve8YmQzv8+oTDniJ8ihFor/4t6HDeETH7XPnh
	 0qzUx+skWQwrxymzZd4yqSdRZyo5Qm9O91YykG/j5f61W+s9sbvi1j4nNmvR6DSrSr
	 IkeXOC0kXEpJjmiSHsc4BSNizwXT4L6AL6eRN87ViuHkHSr6r++BESWVogPdAjx1dI
	 qCWxiIBByOU5w/PZ6VKwrk97r6+SckIe4Pi/3ecdSozDC1fXrYtDiogYDbOS5uXIBj
	 XbOkJYPROPYqA==
Date: Fri, 21 Nov 2025 09:42:03 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex@shazbot.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v9 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251121074203.GX18335@unreal>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
 <20251120-dmabuf-vfio-v9-10-d7f71607f371@nvidia.com>
 <20251120170413.050ccbb5.alex@shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120170413.050ccbb5.alex@shazbot.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DF1A34000F
X-Stat-Signature: ui5gon9b48pzpedkg1mzhogym1ajudip
X-Rspam-User: 
X-HE-Tag: 1763710929-256945
X-HE-Meta: U2FsdGVkX1/Hksk70DK/DlnjCtb0W326R3JTarrdbgQ2/lrDM17kw5e3UucGZDUWn9OLrSw6JhIf8JaFffq0kuD1rhtEo2HbDi+UPZY5AYYgMJQ0JBTQ5fkt19IfLthm55KL6SJK8ZSN82OPu9TaBsVZTokXESgcH7GBzmeN4SYFob4yH21BWSZ3pedvUa9OpDqsI20V6mWQmk57zp0Xcl3kKkenYEajfIM5uFvf6Iv6cOMA2bqKLOEoLhlEm9gVXsxt2sdFnLJSMQUAwZJtJ2d4giAifJYwsM04oWHp7faNqo6dBVtbLfSy5l5e9HpEdJ7AUC9wV7e9m5yb2hnOi7X08FNXvRvq0AJ4+Mt0/YcdqR3+fZ43D3wNX8FnZVmMkIs2ATDjaPy2MVlYMIlgT5CTUJxaxUh23wFnIEl4J/XXUVs/7RaqwXXQUtdx5RrqeWbrR8yjwCGuWYPkYZlFgeDvz3RUfYURmafsViZHJTzUjSjWlgfj+Zrn5000opxjhoAXBL7y+EfezndjU6K9Riuwo27HZREtWMUP+URjDn5UAnHLEihBkqxrTPzQ+3hdfGzqfcCUjxuKUup1jsGpc7nnWBRLE74dLo6CFanorNxyQju4kzN0+pMq7CdFHixvCAgEI0VLWvzTkj1tDnNm2kapcgb2/+LJibcXgRjLqvveURSV0wOq5VkvAT2moLPoKCYCfSmRnsg6kGu2WaG7zOZLX/xsO2hrt72V189DWene5uCWxOmvG4zNeHKQ1kZZzKwse+PefYIbDTUoChEY26ysE7J/MIJIUX6AvpPM36tVfBG8w+j0eBrtYvVerY74TnXiJBCjaYmczMhYy1lNthrMoTtW8kPCCLAfJOXSny6nZSeHrH0UNDld5g0qePJUzlR+F5jdDc2AJWlsdEvU9EJEPq9LsxeSMUtfVw/zrqQPvRfPMw5/25XEZKNbY6SDlPL3JTT8PLy0QVFqi5Z
 +b6WI4Tl
 4XVVEZNvwMPhQRX4DKosBTWPVzkVMj2QbedGf8EbtzqBKJ4wkE87cT/3iZHAauxiEG09Uc/X/SodoNmlTX8TlcItTFB9V/R2bSq1K8nxA1b3KUiURqnPYm/mpCAVS8h3usCaZYcBe7sjD2JwnKqy/iSUUeSV6G+jPPPDPAQ4amVAJR9FwhsjePR0VxaQHnQpwN7i/ptSK6Vsev6ZZygTFUdTrL8Ai9HcNVL/mlxgGiYQ42wVfS5xcyvukdXZs8OuEH+41ENS2uUDcX1pKvFGrI0Qaag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 05:04:13PM -0700, Alex Williamson wrote:
> On Thu, 20 Nov 2025 11:28:29 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index 142b84b3f225..51a3bcc26f8b 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> ...
> > @@ -2487,8 +2500,11 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> >  
> >  err_undo:
> >  	list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
> > -					 vdev.dev_set_list)
> > +					 vdev.dev_set_list) {
> > +		if (__vfio_pci_memory_enabled(vdev))
> > +			vfio_pci_dma_buf_move(vdev, false);
> >  		up_write(&vdev->memory_lock);
> > +	}
> 
> I ran into a bug here.  In the hot reset path we can have dev_sets
> where one or more devices are not opened by the user.  The vconfig
> buffer for the device is established on open.  However:
> 
> bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev)
> {
>         struct pci_dev *pdev = vdev->pdev;
>         u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
> 	...
> 
> Leads to a NULL pointer dereference.
> 
> I think the most straightforward fix is simply to test the open_count
> on the vfio_device, which is also protected by the dev_set->lock that
> we already hold here:
> 
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2501,7 +2501,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  err_undo:
>         list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
>                                          vdev.dev_set_list) {
> -               if (__vfio_pci_memory_enabled(vdev))
> +               if (vdev->vdev.open_count && __vfio_pci_memory_enabled(vdev))
>                         vfio_pci_dma_buf_move(vdev, false);
>                 up_write(&vdev->memory_lock);
>         }
> 
> Any other suggestions?  This should be the only reset path with this
> nuance of affecting non-opened devices.  Thanks,

It seems right to me.

Thanks

> 
> Alex

