Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6CC5FD45F9
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9E416B0088; Wed, 25 Feb 2026 18:41:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55526B0089; Wed, 25 Feb 2026 18:41:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58856B008A; Wed, 25 Feb 2026 18:41:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADCC76B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:41:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4300E13B9AC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:41:13 +0000 (UTC)
X-FDA: 84484602426.23.0A6D05F
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 441454000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:41:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SVlfCKx2;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772062871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CK8Xw2Z8/jwhJKdKy0esOogFCKRH5zkiTBeIKoVGlM=;
	b=iw/OPYav5Sdz1Vxax01cqRrK4B6yjyEj8scT9OqYWndD21iKA7YNo4w2IusI4YTtO2TA/R
	nNvaPonGP1EBlZzBd4/2gkS1vlRstyPhl59zAWT4u8k5KBAcouv9dVEt7sAfRN5TfRWERL
	Kfl6OwzZJIgpJq6Vx0t10dGXBwEd9Pk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772062871; a=rsa-sha256;
	cv=none;
	b=M24n5zOD0Z3rX4WufJpncGXUnrNAB9BJanTkhJSCU5eSIXGZBYwLbPYxiFn0Ut9HTEsQhu
	fJIE1+pEgywrUoMS2rbXgX97LKxhWIoBi/BnjlIhoFOqUl3w0pRlXUhPYZhn4035tR2VPG
	p9tnIDrpM3kn7gs9yGQASZN2hLyvZ/I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SVlfCKx2;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2add623cb27so1274475ad.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772062870; x=1772667670; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/CK8Xw2Z8/jwhJKdKy0esOogFCKRH5zkiTBeIKoVGlM=;
        b=SVlfCKx2e04+mipyYLrwFKj66j0aXaLylZohDpTFBKrYdR+ENNok/3UfhP+h2DVjXi
         7HKg2tEN2rc1gDt+/Z+e0XYAlJDmeYRFjLVIDYEuYHH2nM0J030xMhesvpJBEY+2b/z8
         OfKb0ku+9nEkcI1WCar4RjeY93xRIcxe2OCXEtIb1sYkeBLLcFknGXcBOCifYbb9JcFw
         E0objhXbeQPQAn49dpk6XZOCr4gjhixK+1/3ejmygUtHJKvdvoTB05ASwocKaBPbNS62
         IzLeliNGWH3jmW3xd35EphApTQFKD486RKKsUTGSqHTMK21RXJ12Sm4SCNsAC9ONAX9R
         uW9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772062870; x=1772667670;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/CK8Xw2Z8/jwhJKdKy0esOogFCKRH5zkiTBeIKoVGlM=;
        b=HSlOU2lJ5X+TfdSvr+tYLU7gKhJ3nFNFyU4zWdS+IdECg/B/Yqf0MtvoiWI+WPiUb0
         Y0MDGOuTdZ0q8qLXypIzHy/oRrvP0uCwuK31kgc0rV+41YSfNX+8/v+L34wrybOljEtp
         YLkCnxQau8NvaO9uY3og5/dN4NpBbQB1n5jJ80R3R4S739QyjhlyDUl2J3TMMCLxgRoG
         YzXS+rp84fXLx1nJapy4dw2qOe9+pAue1d4/ahBuaNG1ngmv1FaN6Nz/Wehs6XK8dbt8
         r7TluT3Dp/iDSRXExmHVfyfSho/eOe8LIxDxXhvQNCqmGfVRp/BgKDtXJ7CHUmqYphh6
         0K2g==
X-Forwarded-Encrypted: i=1; AJvYcCW1hhtEBd4N1CLzW1XiKKpFinE2yDG5d6eCQHgjx+NTRaziWFCBrGBYVjiRd1SWgd3uG5ALxUpL3w==@kvack.org
X-Gm-Message-State: AOJu0YwAdAVBElHkQCDNcz+xxOLXxLX+hiVz3konbDYDwjPyLkYZx//e
	JVhckDaaydQlHsv6QbSBcp3TxJXjmF3WGVQL9BoJffREuYJmlNUwAo7ZSHEmw3G2og==
X-Gm-Gg: ATEYQzxPJ9zSh0bLynPUhIqQom8jiPj+rqZ4jjKCm0OBqIv5hFhI+sjnWJGWUstP2Zu
	gHvfC9qGtI+c70Q92KXOPBBN7aytckLqJUosObZipoIzE3Qujwf0ZDC/nTabvFjyq7TcXsWbkRf
	Cj/5JN2Sh1ewKRPO+QW1lNTpQokwa/9PCQEwZV2d5ipN4HSZlZN0OAN3WOMmwYIPNNjFamYOxTV
	Ax7Oy/sARu+FSX4zPezQS/fAl5rzgrKDl2UNutz0gePhfmxr9lbg+nNIa69BpdwmOKLOk+7h61t
	Ox+aWjU+napCJnIz+t+sKJJgDNWRSvSq5IvYvh7jB2w58AD/00/Ih7CzwWQ6BzA6doyYlUxyPkh
	SlbqFabuFv4pFpo7/7Wu9YdtLjRobTBf3L1bAFrCA5FBf0+qIQn/ACFrLRO6FO4Nw24illZ7JJe
	R/1u0MvBmiau/H6P/YjzfMFdVb4M2SCeeAJ4/1Em4K8rVuku9n9JIUv4zCPRTIvw==
X-Received: by 2002:a17:902:cccf:b0:2a1:e19:ff0 with SMTP id d9443c01a7336-2ae035d235dmr1928845ad.39.1772062869584;
        Wed, 25 Feb 2026 15:41:09 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6b5813sm3778175ad.63.2026.02.25.15.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:41:08 -0800 (PST)
Date: Wed, 25 Feb 2026 23:41:04 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	 =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 05/22] vfio/pci: Preserve vfio-pci device files across
 Live Update
Message-ID: <aZ-IkNFOLJUff1hC@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-6-dmatlack@google.com>
 <20260225154124.78e18fa4@shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225154124.78e18fa4@shazbot.org>
X-Rspamd-Queue-Id: 441454000A
X-Stat-Signature: 6kn9b576gotdk1o5w1bq81339mqxwnw4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772062871-992628
X-HE-Meta: U2FsdGVkX1+t8ydo/3fGpVFubMFxpbPqrSaOZTTCGZwKE6uMFQlvnWP7t/FQ8qyWVerOro3pQ1AHjBPrJEMfnsRt0mSOVsWmJUYZuSMiu825Hg3HBaNW93UzHOZJlhoMDFB1ndd2Tto1QIDE9vCkDOVYg9HfdXKi7MQqGO3AY2iUIDi3GxWEwry1LIigpZGraI8+9bAcKk38+n+WictvDNnZ34SLRZ86hEzbm26K/1rNqFhHtVl4i2VoHeYCsrgxdyMp/h3TzuKR2RpUEUw4HQxLvGNeac3Q4X5TTr4kY9+xA7J1EL6Bgb1KGlMDRYwYOHaKpxCkOUn5SErnmn8o6hpQo6H+2E8iqKgalKnhCX0EWgb/M+0bU8okDd3MufYkj6sGym/iyovoJVumZojeHfMPYp0z6XMpCfPdk9wZ93bgsXCn/H5SFpPpOP2WXcozP97elaq4z60+hjJbBqFM4s3PnEjkj2BewAg9XRfhnJ6SwZLMeDgGrMjMEvWBjAL8St1B7dFB/wMogXNeBDiHQET4JMQytzK5N6LyB1tbXtuM6+3H6WXy1anegeg8SViTzO+MpmE6SGWUcsX1yjbPhjs9P7DSo3/Psh1CitOX2A/OqmiFko5j3FxBnJJDDpWnLZyHGU/p7mG3Z0IUtqO+R7zD0Oz6iRUvLLD4IBW6O7M/6kU8dpA24qVjhRVEUGVTSW0kwKY0e5zmwdJqNZ6NFlY8sGbxcx5TQOOP0y/MAs23EJXmuVjHaAf9ibRKUxc4EVTPmnXOrf+Nfeam+wzvgR/Pe4odJulVq+6Flb1YhT1kK7h/10eZyM3GfpF6R16Y1ezEqGQsqySdbLWQRJFtkrTyl/sYGLOULfXnGJ8A0v4TB5EFK7DbAdSPzll85DrjuQ1InLE3GkXA/IZ6Q2MeJ8tzMUJRyIBznVxxxfIyi0QDR8fqSjMWwcZ7+OXSOtftqpSKjqIC2wU92AamLhj
 85+aWcab
 YH6scgxLFIu/gQz6u8j4QoAXxmVXxzRSPcHD+IOVzqHUaUF8VacuHu+9HmORU3b8ZgOxZ5a0ebvqgoPQoT/9aQakTms/pK1Yg8BlEpqcLnmtLcJvOlmcNKjqcpWIMIoSizOuaV0S9uxEjDzBDLs3vBQjBHjv0ir2ZoMGWr3yl+dSP0h+uJgm4EeUnqD4Chup2wd07VWcFEwfFq1UVPljlAYM+t7diqW/GpyhwpHDLei7/Z9iCd9dI5xkahDIExP4BaKAMfXgguR7FQebSpEdEu/JiUGBmmAig3iRp0tbPlpDYAud5Ch4nI7jxgIdIFnBTShLTO0EIDAZDRsuHgu9/aSxy4yvbNJs7HxiLlAESxzTfj37L0rETToN+2xC0N9P4M50f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-25 03:41 PM, Alex Williamson wrote:
> On Thu, 29 Jan 2026 21:24:52 +0000 David Matlack <dmatlack@google.com> wrote:

> >  static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
> >  					     struct file *file)
> >  {
> > -	return false;
> > +	struct vfio_device_file *df = to_vfio_device_file(file);
> > +
> > +	if (!df)
> > +		return false;
> > +
> > +	/* Live Update support is limited to cdev files. */
> > +	if (df->group)
> > +		return false;
> > +
> > +	return df->device->ops == &vfio_pci_ops;
> >  }
> 
> Why can't we use vfio_device_cdev_opened() here and avoid all the new
> exposure in public headers?

I thought I explored using vfio_device_cdev_opened() but I can't
remember now why I went with df->group. Maybe there wasn't a good
reason. I'll switch to vfio_device_cdev_opened() in the next version.

> >  
> >  static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
> >  {
> > -	return -EOPNOTSUPP;
> > +	struct vfio_device *device = vfio_device_from_file(args->file);
> > +	struct vfio_pci_core_device_ser *ser;
> > +	struct vfio_pci_core_device *vdev;
> > +	struct pci_dev *pdev;
> > +
> > +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> > +	pdev = vdev->pdev;
> > +
> > +	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
> > +		return -EINVAL;
> > +
> > +	if (vfio_pci_is_intel_display(pdev))
> > +		return -EINVAL;
> 
> Some comments describing what's missing, if these are TODO or DONTCARE
> would be useful.

Will do.

> > +static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
> > +{
> > +	struct vfio_device *device = vfio_device_from_file(args->file);
> > +	struct vfio_pci_core_device *vdev;
> > +	struct pci_dev *pdev;
> > +	int ret;
> > +
> > +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> > +	pdev = vdev->pdev;
> > +
> > +	guard(mutex)(&device->dev_set->lock);
> > +
> > +	/*
> > +	 * Userspace must disable interrupts on the device prior to freeze so
> > +	 * that the device does not send any interrupts until new interrupt
> > +	 * handlers have been established by the next kernel.
> > +	 */
> > +	if (vdev->irq_type != VFIO_PCI_NUM_IRQS) {
> > +		pci_err(pdev, "Freeze failed! Interrupts are still enabled.\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	pci_dev_lock(pdev);
> 
> device_lock() is a dangerous source of deadlocks, for instance how can
> we know the freeze isn't occurring with an outstanding driver unbind?

I can change this to a try-lock and return an error if taking the lock
fails. The freeze() callbacks are triggered by liveupdate_reboot() which
is called from kernel_kexec(). So returning an error to userspace is
possible.

My only concern is whether using try-lock would make kexec flaky, or if
it would only fail if userspace is misbehavior (e.g. unbinding drivers
while kexecing).

> > -static struct vfio_device *vfio_device_from_file(struct file *file)
> > -{
> > -	struct vfio_device_file *df = file->private_data;
> > -
> > -	if (file->f_op != &vfio_device_fops)
> > -		return NULL;
> > -	return df->device;
> > -}
> > +EXPORT_SYMBOL_GPL(vfio_device_fops);
> 
> Seems we just need to export vfio_device_from_file().  Thanks,

Will do.

