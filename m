Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C571CCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 15:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2FB8E000A; Sun,  2 Nov 2025 10:13:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B618E0002; Sun,  2 Nov 2025 10:13:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7B18E000A; Sun,  2 Nov 2025 10:13:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA71C8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 10:13:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8386387A47
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 15:13:03 +0000 (UTC)
X-FDA: 84066009846.11.468B2D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id CBD3340004
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 15:13:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CT9wGfoA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762096382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TzhNSQLHMrhomX4cv9hvuB//gXnDDJ/9AMt9tCjprds=;
	b=wJBMNnsQPdDylxAs3drLgd6vcyPR3kPrdn5GoTiIoKSuigBUhNSTpiZVmuQ+WcWBsixErm
	7y0AU4QpR8dVh6YApwSNu0Um0mFk6GO36Tk4xmIopCxVhp3Zgsf+07K4gPdruqn0vyoTgr
	BnIkuWHiEYXe7bY8/QpSuOkxPE6/yFY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762096382; a=rsa-sha256;
	cv=none;
	b=3Jt3z+pO7Wd+A6nRagPScElmZJ6oPTv5yw3nQUaMgbfcSq+i3KODA+ucaIOEsjBClvWQBE
	kBgd59zdQwha/8E3o7yUjIqstWDgnjvqJA+3RHWD11PUZ3EaVNwTo3Tkp9ICQ3yL8nAPaI
	jCyYBxUqbQqP2Lb22txh40pAZGzLUeM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CT9wGfoA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3ADB438F0;
	Sun,  2 Nov 2025 15:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAABBC4CEF7;
	Sun,  2 Nov 2025 15:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762096380;
	bh=tizBF6oQAn/Y3qWcygtT9HOK6tA8tcWjX6+eHwzztHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CT9wGfoAiCv2vOtEIQkZsX5as/tdAoLN3LndZfBArHXUFA/Zw6aiiZ8s7L1ItFwnS
	 J44TfxOhI/HBSPQzjPfDdOnuTocQGDHYR0rQS/QWk/RFyc2i6YnIcrq0bR37G55zSN
	 cRUJYZHLWZuU9uME66gb8xkP50ARR5vellQ8rh2cps+8y1z5a6FXx1Bm7+UKl4xykw
	 BKzX1CHLdgL5P2L7bHPJvSRCjuzG6pnNETHYekFTtAy6gY2hQ8xQ2LYlmtydkaNOmU
	 IDJqI0JxojL60OTRm80nOQSmOqRXrUZh51uEpe4MhDqcBvu3YYEuSQHoFo9Sv5xLDN
	 7aBCzDPV1VG1g==
Date: Sun, 2 Nov 2025 17:12:53 +0200
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
	Alex Williamson <alex.williamson@redhat.com>,
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
Subject: Re: [PATCH v6 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251102151253.GA50752@unreal>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
 <20251102-dmabuf-vfio-v6-10-d773cff0db9f@nvidia.com>
 <20251102080137.209aa567@shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251102080137.209aa567@shazbot.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: CBD3340004
X-Rspamd-Server: rspam02
X-Stat-Signature: k6wigjceba11kwaip19wgpkpbj56oy6n
X-HE-Tag: 1762096381-158353
X-HE-Meta: U2FsdGVkX1+rT4HYSsuVGOsbyFRxZdIhuI85FkSCHmGgljrrpqjU5rO5eXyE3P9HRqZplKoatyDLt+qz2thovai762mRC7mrWezLgj0uJSFQPTec/n95P8ia/W53AzWAPC/8XCXqFZPXDT5ncfrrX+NYJ6BOOb8g/j32MGFwXLVF3VNN00KNit2gfornnisH7c6vt7i9UOk5i4yKU+rgz8kdrm0W38p+rYb8Rlqxsy3eCCr1jaA9NsbEpYEsdv7ryVyWgbcktQP1h6QtN8SgYRZ3Vehv7aRKyLpBv89H6BJGVYneYa23/As72K17TPQoooD5Q6Ldbk9FaSLS/jGOZUE1acaS5ZAEAOYzSDEqIRrTgxO1VM+ZhgZN92nMQlKua7x3oXL192H1zQPLEKgytM7coJfg7Gc+vg+Z5dLhUjbMp8/rpGkgbj7CXd2M5l6gF3oQT0jr89Jk6iRjPl9eeS6SX5abAXdZ6hiuTmsNVc/v6jc/4oQrTxD5ND9zlHBeBIp118V6evzmh/cbJBy4K4D+aPP+guIz6qZrto59QUzz+ect8DNBqshQCFY85C9pa1EMYAx0tTMLGY1TuyjPOGbAWSlr/kVsiYYpvqmD9o5JEpP13rg9q79zfj4ywYWBUG1MQZJmL7dOyM3M/FYuqtvq0PGrBCt+Nijred6HMf4+Zbx4H2S3KBf9PbpL0xdhJ/V0f2VXJxpECe+mOZrWw6YLDDXY6lwyDQ8o03yEB0VSninwuDTNS876C1fwZxnSRE+8rB5KttlQu4ZjPXdpZwAi0zoT2YRT6UxKCYMF/+MNOhF6uEZ1TIcASMN0vqpZxhCb84g1AXcnbUM9/HFfrxVQ5bRd+7FTpGPOfEo3wV/wnZWVk3KFXesgF41WRx+skqs6G0f1+/eyFvaFMIGaF/yhNbqJd+goCX73wNl/YeZMtaxzmtdYwEYL9LTRKb7G/cixw8Gj5CpfT6xPBXA
 l/70Fmvd
 YtR0EXSV3a27SXMgXooCSDHfdXKv2fXdRUiRSpcaw7HmDT+JXhplLxwLkRNJTP/SWKHlZFsKvPOCrc7RkX/Fat5J7CjxjcQXWFCoOv7fIdXpJ8usD6oJ+/vc638hfddbjqQm0A9gwEAfBPm1lrnztHt5eSe/dWCVWXC9ZJV2vr/xj06bQDxDUCAVjKjjT+MClyFXTAKeuYaFGitvhwbbuwiRxm9kE7o+WVKB68VumQJGJ0QCqSTHibxD6lnhU8EsUha1f8cKNDKLXKYofbxVD7uZeqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 02, 2025 at 08:01:37AM -0700, Alex Williamson wrote:
> On Sun,  2 Nov 2025 10:00:58 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
> > @@ -2391,6 +2403,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> >  				      struct iommufd_ctx *iommufd_ctx)
> >  {
> >  	struct vfio_pci_core_device *vdev;
> > +	bool restore_revoke = false;
> >  	struct pci_dev *pdev;
> >  	int ret;
> >  
> > @@ -2459,6 +2472,8 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> >  			break;
> >  		}
> >  
> > +		vfio_pci_dma_buf_move(vdev, true);
> > +		restore_revoke = true;
> >  		vfio_pci_zap_bars(vdev);
> >  	}
> >  
> > @@ -2486,6 +2501,12 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> >  			       struct vfio_pci_core_device, vdev.dev_set_list);
> >  
> >  err_undo:
> > +	if (restore_revoke) {
> > +		list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
> > +			if (__vfio_pci_memory_enabled(vdev))
> > +				vfio_pci_dma_buf_move(vdev, false);
> > +	}
> > +
> >  	list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
> >  					 vdev.dev_set_list)
> 
> We don't need the separate loop or flag, and adding it breaks the
> existing reverse list walk.  Thanks,

Do you want me to send v7? I have a feeling that v6 is good to be merged.

Thanks

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 24204893e221..51a3bcc26f8b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2403,7 +2403,6 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
                                      struct iommufd_ctx *iommufd_ctx)
 {
        struct vfio_pci_core_device *vdev;
-       bool restore_revoke = false;
        struct pci_dev *pdev;
        int ret;
 
@@ -2473,7 +2472,6 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
                }
 
                vfio_pci_dma_buf_move(vdev, true);
-               restore_revoke = true;
                vfio_pci_zap_bars(vdev);
        }
 
@@ -2501,15 +2499,12 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
                               struct vfio_pci_core_device, vdev.dev_set_list);
 
 err_undo:
-       if (restore_revoke) {
-               list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
-                       if (__vfio_pci_memory_enabled(vdev))
-                               vfio_pci_dma_buf_move(vdev, false);
-       }
-
        list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
-                                        vdev.dev_set_list)
+                                        vdev.dev_set_list) {
+               if (__vfio_pci_memory_enabled(vdev))
+                       vfio_pci_dma_buf_move(vdev, false);
                up_write(&vdev->memory_lock);
+       }
 
        list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
                pm_runtime_put(&vdev->pdev->dev);


> 
> Alex
> 

