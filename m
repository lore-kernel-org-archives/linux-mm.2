Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DDB6CEDD97
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 14:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C309E6B0093; Tue, 18 Nov 2025 09:28:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE02B6B0095; Tue, 18 Nov 2025 09:28:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81186B0096; Tue, 18 Nov 2025 09:28:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7F36B0093
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:28:54 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38E1F140594
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:28:54 +0000 (UTC)
X-FDA: 84123959388.22.7F6BF92
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2F1DB140016
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:28:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="M52/zYpW";
	spf=pass (imf26.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763476132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35WpspOv1fAWFINmOzi0AcgEQL1oV2/QEYSJcrH4aSg=;
	b=a5RrDg34ccCP1f7//WmR7oGtr/ccTrt7VuTJ6ZzTI4N6mwEmgdFZQwE355LNZgsigG0X/8
	vbJXb/++FSKaeD7x/tE6RuEtiTPK6LnuINQZ5i5WrfhEDZ946PvysrErEZCvG/YC7PjwXn
	wUGjqG1HNL4smiYnLOefKo1c06LBf+I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763476132; a=rsa-sha256;
	cv=none;
	b=pvKJXH9zRtqqRnSbxIMEqRhUl1v0Fda50RlV0Dk/raEDPfc3gQJAKFjCe9F+3E8Nsk7xw/
	uRZfY32CoOaWwX4ZK1ppNtVupFeNsDq8xRf862hnUQ2iClE2EnBXZtAFI/gbi7EXWHHtmF
	rV5HdIC1+fOJL+cR4piIm7bEO7IczrU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="M52/zYpW";
	spf=pass (imf26.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88051279e87so59456796d6.3
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763476131; x=1764080931; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=35WpspOv1fAWFINmOzi0AcgEQL1oV2/QEYSJcrH4aSg=;
        b=M52/zYpWVGlq0Lwd50XR9sNV41UhGGVCUcp9bVfISnaPPLpKYxKeK4t7SBK3ehhLgl
         86y6E/m70HnkgGYyfPebUQD6sAZ3svR2HuYTJ2CmsLYacZl74wmjhvJPv61cMh+VtzxG
         BoWh2Qf6IXlHUJofoQS5eUr+junCRvm0YBUeZ03Lp/Oo/vmPXNwwXGYzxky15B7qrldV
         BzGl9w/4Zyz8+yTa0v3l0NxKI476w4KlSgr+09zbaeLW0FJPPzsWYwYwmUkAqtAYwAsT
         XCjhOk6Cx1fi8XoT4jBPjz+jPoVJ2hnKs3dx2K45cUje7fa80rD3b9GmZ6PR3OaJgaLh
         hvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763476131; x=1764080931;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=35WpspOv1fAWFINmOzi0AcgEQL1oV2/QEYSJcrH4aSg=;
        b=EAEwEDPsAGXuhhnlG3mfWpxUoR8w+zh/DHDXkJebq4LsTKvHBsj+C3SKj93DcUqqW9
         O126bhcBY3kd7pLXUY+BMkL0T/CsWF0WRR9I91UALTCZ9ppls0dqGfxmRiqsieiwHqya
         q+DZ/GqdAIzqb0giKwohEVAh4yINgl0eDAMmRpJSnStyuF4qMajn4Ouv8rbI8w9yI/NN
         TEhuNm9YDZrG6e3n8ZJipxZ7XNbe99sabWedwgmBSKVDdyzYACKhv7O7At+pEkXvbis9
         5UX1/fs+buD1s1tuRApqD55Gx20w+jXiIjACi6wgK2cGFQfI/BnHl7i6Q7BKpT+7fK0r
         9bQw==
X-Forwarded-Encrypted: i=1; AJvYcCWOtAPIAO3dBvw2pc2hi7BwjK62FZw1lKLf5SM3S3Gg8Fd7V6f9/ImdzrbBpLiuh+yEv5jSjCAmLA==@kvack.org
X-Gm-Message-State: AOJu0YxcNO7EAdvDIUY8/ERJhTzfD4eVIPQ9FzwwQ7c5+ePWfEzMwoRT
	8q4wfF7WPS9/HgprFkvtuR1nMkeTvgDsP276pWrVzXFVOutUoKpnoIVZv1wyx3KdWsc=
X-Gm-Gg: ASbGncu2fMrIcQ44D5K2lMkh9kTLakOaId1XoTn/v1AkBnS/LKJ0YDShnJ3GvTpgLZ9
	7s/VjGpRVkln0Bz9/FX88+am3Hhb8fCJJIJ/PfQkPwSqyLPtLU0VvdVRXYWUekByk9Gn/cplJe9
	Bd1bO80OwwTmK8aBGgt5DxIXYs4Q6WTWwjN3nEqUn39IZ1CCMbq98qsTWztmiicgBdMwdRlGZY2
	2a7TWASes8IaKCdb52t2gjC08PX5RdnI/zkjgNJgUUFTuFr0EsXWJdf4+j2US2JrX1IrRRCVAuR
	goELC8IlliK3LAophsEYJ8W7GfYXIyaXS5QebiV+9Zr3IRXnH3kQ+nCRJet/Vm1aoJTbEeiUbmq
	gYE6SZDEnS7MkqxLREozkuB+zPjVJL6kjMTWsRebpPMshQyHND91aBdaS4AIopAWP/Su0WIsj1y
	HazGqiGhai0UsmispO/xAc7+5tHG77SgUjIP7JfH9jYPP73vP9NU08JF5MFddkOyJCX8o=
X-Google-Smtp-Source: AGHT+IF+NrfSbYwvwiNh+CC3YngHFJHpwzxC37jBlKkv0sHaTL3i1cld4gWS47y25QRA75BxBaWSvQ==
X-Received: by 2002:a05:6214:62a:b0:81b:bf92:8df9 with SMTP id 6a1803df08f44-8829269e086mr234228876d6.43.1763476131063;
        Tue, 18 Nov 2025 06:28:51 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8828652efa4sm114860276d6.39.2025.11.18.06.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 06:28:50 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vLMhN-00000000NEc-3Dxs;
	Tue, 18 Nov 2025 10:28:49 -0400
Date: Tue, 18 Nov 2025 10:28:49 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	"Kasireddy, Vivek" <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v8 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251118142849.GG17968@ziepe.ca>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-10-fd9aa5df478f@nvidia.com>
 <BN9PR11MB527610F3240E677BE9720C2B8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527610F3240E677BE9720C2B8CD6A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Stat-Signature: wa4t1r8xypqj35abpdgc6rakgypejd5d
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F1DB140016
X-Rspamd-Server: rspam01
X-HE-Tag: 1763476132-865075
X-HE-Meta: U2FsdGVkX1/LC0KTJARohzITbPpp2HynP5pj8t6KPic0w/q7GzAOlSVMxYWkoyN3m16Goy/MkemkFzOYSWR01SKOhjZGLIHw/fDXxa9dKHwrDWUF1yI4pZ2VtkY4DVXBuL59ZJVUni/t9eGXXBKgz1YG4onctc1SUWFQKTNN2thJpL8BRiqkB1GnRcgsP+fnUSiXI8BcACCojm2TZ6j1U+x9dTzTE5gqOcZ29VS4TTTe2jkmEMJt6Awy7ZRPUCj/yuAsp1b5MjgphCc5XY6bYTX7N7Sb8CBb8QIrFbvJh+UvsAG5DirPy1Viyn0Z0AejzBnjQU2HPxmlqMiR/u5OPYfDj+apyJM4a01FX+FzVJEBzpHHvVsmHYjxYxsnYCe9AJBu6tJwunZ1EH2kPhPXBI7D6MiUHtxSouAcNMmuu3Oz1TUR+hJWjptV+Iffhg2L6SVuljk71/CQAP8pLLTUbIXiIPzW4eozgO8L+yYY4ZZQF/Dve+jHmN8UjOdDqQTejKIPDDNAo7SNR3a8NF4w/eUFK+9dN3OD4vPd16HZlhzObFwO/Uj1MTGXWNQi+RwWkutp6N09vVIfLBaxRjkaZoD8GFND9KV6Whrrv2eBteA+8exEb1epDC2ciKemvfmhB90uydsAkYG3lXSoQwYSFN3iEihqVwQaDZ0Va8HHZts58I2lRLFay4PyBx3gC4x1/uGLjh5rBeHRxJ2jKLU/R95sTNDfEn9z8uBd6gJn3ZBj80TZ1eRp1M9uZy/rIk2J/zzUG6lvqyuV9VaYmO9M6A0R3iQANAGR44HS05mAAuN05qXYAuI99uKxalZaicTW0o38d+7ybtG1HDbMUHSjRO3/OFUYtEt+7PUPsAh3Hg2h1QxAkoGaFfy5tHkQ5LdJEcDGV+CqovcXXUgny4yd3jhVdpUBIsYXAiwuZE9j6Y+rscYmp1VRWfT8Dm7fA241SK3ZrguTH10uRoGhXnO
 kCsK5+rK
 /i4IRu3+fuiy9UQSNNOb7bcvnfus6rzFsC7HuDCMk2hZc9Q844nBe0qcG6yhEtQNv6rXK8NWpWsQZbzoYipAZSrz98OC2mogyVp/9h6/+KTh9cMyJq7PC0OIxCLk70eRtzrwVVZt1I8OFYCVFTatZHtjAXtLPe8elO/V25Ole1R3Ypgs2B3IZuQui0q4oWYiP4VQ2YBLHz1BLwv6znd/Hn3jpifZpj/Xg2bFOTcfYb12/8k0DaLQGjqQF1PDUxfvZV5i7ZWswGCgNsymBpFcvhLaHFcHkjcbb2WhKnr9fDNxRFyqowOEPbv34GZ7MSvhlk+WrwoiqnnlkQH5ILBTzC4rHw8drCXfT+zT5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 07:33:23AM +0000, Tian, Kevin wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Tuesday, November 11, 2025 5:58 PM
> > 
> > -		if (!new_mem)
> > +		if (!new_mem) {
> >  			vfio_pci_zap_and_down_write_memory_lock(vdev);
> > -		else
> > +			vfio_pci_dma_buf_move(vdev, true);
> > +		} else {
> >  			down_write(&vdev->memory_lock);
> > +		}
> 
> shouldn't we notify move before zapping the bars? otherwise there is
> still a small window in between where the exporter already has the
> mapping cleared while the importer still keeps it...

zapping the VMA and moving/revoking the DMABUF are independent
operations that can happen in any order. They effect different kinds
of users. The VMA zap prevents CPU access from userspace, the DMABUF
move prevents DMA access from devices.

The order has to be like the above because vfio_pci_dma_buf_move()
must be called under the memory lock and
vfio_pci_zap_and_down_write_memory_lock() gets the memory lock..

> > +static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
> > +{
> > +	struct vfio_pci_dma_buf *priv = dmabuf->priv;
> > +
> > +	/*
> > +	 * Either this or vfio_pci_dma_buf_cleanup() will remove from the list.
> > +	 * The refcount prevents both.
> 
> which refcount? I thought it's vdev->memory_lock preventing the race...

Refcount on the dmabuf

> > +int vfio_pci_core_fill_phys_vec(struct dma_buf_phys_vec *phys_vec,
> > +				struct vfio_region_dma_range *dma_ranges,
> > +				size_t nr_ranges, phys_addr_t start,
> > +				phys_addr_t len)
> > +{
> > +	phys_addr_t max_addr;
> > +	unsigned int i;
> > +
> > +	max_addr = start + len;
> > +	for (i = 0; i < nr_ranges; i++) {
> > +		phys_addr_t end;
> > +
> > +		if (!dma_ranges[i].length)
> > +			return -EINVAL;
> 
> Looks redundant as there is already a check in validate_dmabuf_input().

Agree

> > +int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32
> > flags,
> > +				  struct vfio_device_feature_dma_buf __user
> > *arg,
> > +				  size_t argsz)
> > +{
> > +	struct vfio_device_feature_dma_buf get_dma_buf = {};
> > +	struct vfio_region_dma_range *dma_ranges;
> > +	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
> > +	struct vfio_pci_dma_buf *priv;
> > +	size_t length;
> > +	int ret;
> > +
> > +	if (!vdev->pci_ops || !vdev->pci_ops->get_dmabuf_phys)
> > +		return -EOPNOTSUPP;
> > +
> > +	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
> > +				 sizeof(get_dma_buf));
> > +	if (ret != 1)
> > +		return ret;
> > +
> > +	if (copy_from_user(&get_dma_buf, arg, sizeof(get_dma_buf)))
> > +		return -EFAULT;
> > +
> > +	if (!get_dma_buf.nr_ranges || get_dma_buf.flags)
> > +		return -EINVAL;
> 
> unknown flag bits get -EOPNOTSUPP.

Agree

> > +
> > +void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev)
> > +{
> > +	struct vfio_pci_dma_buf *priv;
> > +	struct vfio_pci_dma_buf *tmp;
> > +
> > +	down_write(&vdev->memory_lock);
> > +	list_for_each_entry_safe(priv, tmp, &vdev->dmabufs, dmabufs_elm)
> > {
> > +		if (!get_file_active(&priv->dmabuf->file))
> > +			continue;
> > +
> > +		dma_resv_lock(priv->dmabuf->resv, NULL);
> > +		list_del_init(&priv->dmabufs_elm);
> > +		priv->vdev = NULL;
> > +		priv->revoked = true;
> > +		dma_buf_move_notify(priv->dmabuf);
> > +		dma_resv_unlock(priv->dmabuf->resv);
> > +		vfio_device_put_registration(&vdev->vdev);
> > +		fput(priv->dmabuf->file);
> 
> dma_buf_put(priv->dmabuf), consistent with other places.

Someone else said this, I don't agree, the above got the get via

get_file_active() instead of a dma_buf version..

So we should pair with get_file_active() vs fput().

Christian rejected the idea of adding a dmabuf wrapper for
get_file_active(), oh well.

> > +struct vfio_device_feature_dma_buf {
> > +	__u32	region_index;
> > +	__u32	open_flags;
> > +	__u32   flags;
> 
> Usually the 'flags' field is put in the start (following argsz if existing).

Yeah, but doesn't really matter.

Thanks,
Jason

