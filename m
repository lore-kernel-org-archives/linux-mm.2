Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B00C2F4BB80
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 19:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEF6D6B0088; Tue, 24 Feb 2026 14:19:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73076B0089; Tue, 24 Feb 2026 14:19:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D545E6B008A; Tue, 24 Feb 2026 14:19:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFDA16B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:19:44 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4EC078AE40
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:19:44 +0000 (UTC)
X-FDA: 84480314688.10.52D2992
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6E14C160003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:19:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=j0kJaJWA;
	spf=pass (imf08.hostedemail.com: domain of praan@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771960782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gr8G2sJEnb4CcsPQ1rrAHuOyQl/uEocyHUTrMBlTuWs=;
	b=TOgnlih41cXlKDrofWL6WTjjzrLVyZvIZQW7QDlTW6g0OR55rVqxZ3cXfrWd32+QZrpvWV
	H5lZA0Zljxf22Tdta3c6G/4q+Q6dJtO1kC03ymn7+HceG7bh4R24BnhyFxB8c1puTIfC2e
	0A91N76cYH449/FMP4HMRMrB1fewgqc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=j0kJaJWA;
	spf=pass (imf08.hostedemail.com: domain of praan@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771960782; a=rsa-sha256;
	cv=none;
	b=t13zgQvFv+r/MXVBLtw4w0TDRlfgimdTUJmuVcAL0BM3idzZn0eUseSJiiVhAQ/Vdsuxny
	Khj9X8iFPoiVAVZqM018CrpC6pXdwgKu35oHR6CRlPAJ0bu13rSiifB5Q3Tp1uOqUxkGgY
	koDEMcm4B2KS4c6D6HyDeHDzOJJjcMc=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ada9e4ea32so10375ad.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771960781; x=1772565581; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gr8G2sJEnb4CcsPQ1rrAHuOyQl/uEocyHUTrMBlTuWs=;
        b=j0kJaJWAc+BbkdiSJ00Blf6VWenZriE846RmemXPmtsdkS+K3ChD6LgVun3iGOAyE4
         zuAuWG7U+V7bjcvnvEdP0DFWWkz/OCL8BEGUZ1zxKPl6CkB6Ws21fBhrLcB1SEb8j1mT
         uivYO95QZRPnSeMKFuaZaVTYZZ2iDHSQB/uMJuGvUl9sLQqao4yQUDPduj9QZvCpSAvK
         wbaETwAQ06H87skVQB8eo6j0BDz5s2CdJVoetFPMVUicNDWjRsVuINlqLqEaBIas8DwS
         SpwzDZzepUXMSQ/56/0qf9HAKvv4ee8FF6hCBfgxg+NbLgBD+f7xj/vpC2B4n1uf3iO+
         J+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771960781; x=1772565581;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gr8G2sJEnb4CcsPQ1rrAHuOyQl/uEocyHUTrMBlTuWs=;
        b=LL2Jil2fhCUQf2LIMM9I2HrKsGQFlsk1gniiaudBD+ZVlKoRxBFBgZtXUIC+p8xK2l
         YLzWk/1igz6zPiJMJ2xTltqggYhjeQ7lV8FHzWwMyS9AC0y/HgHKNM+6hAojdXHQs+7q
         GYzvyRqREDu06EMLkJRVfqnEeKsJMWgTN/5MoTas7XRPkM1lt3gDG37RJ6aSTr4qen4B
         irPSXP/zi/XiS0YsTPt2RMPhXfgQMGp9bMo1q02CyH/X4c4oAKR/n4+D3ZIMngQ5Ir+6
         mV3O3aY4JDrDSep4iIg1kR2ep6Ga0QIDnmENbI56pwnFd9miJkFPe91eaZDZZehWWi4A
         PLlw==
X-Forwarded-Encrypted: i=1; AJvYcCUHiJ6NuHzhYLxfjL0tiwkrF6vHPJ5osdCff49vuikhUDXbR1igpLyz3JntPV7fCbiDTJLSj2lZgw==@kvack.org
X-Gm-Message-State: AOJu0YwdbTogL4MkekSvg3RAFfDHRMMbMw3YgxSxzI0El7d85IJejmyb
	k3/DfLkRs0MlPXzyKXP97iVZVp7arOLSQceCWUsroLfCyIQ3ovN9LjF2F+BnY6EqLA==
X-Gm-Gg: ATEYQzxXIYwMEOAq1dBafU/+CklWZQdr0HH1507dGDY8+YuX/VaOzO0DvVQ689ODEIW
	uM4XqV2Kink5rui4YNvbbl/NwB8uxcqM+iYUyMbMyypeIaNuGn5L0X1wI9lTNraMbIZwMpVaIRy
	zvSfwrADZ00tHunb353gZDSiuWl3uGe0/SwlJA2jBHwStazZqQEgcR8CBeu0Ly5fTN0Ly7AYUA5
	VRaeDKTjHCoQZJBZjtz3raUxRAwgskEcuYytNXzGRr1Egtf43MU2moaL0TlgXcddaGtzSKQ4WSr
	eVi8jBz2U1AP56E6ME34SmsYybhkIo/f3l4I6KoHF1MxAN0aAXHLJ5vCRnXnYBHQYGOg0IGCXYC
	SsYU32kIRHXrXYB1VzO2Lm44ulUnGHNmoDTa4SOSWjzaiRPpY5LxkAzo7riCX/rApuz2dg0R2bq
	247B+3RL1d29Jd63lBGQ7jYrceI/Kn0XPL3S+1IxWJvcQUSZQ2LDRiSude1JXb
X-Received: by 2002:a17:902:f64a:b0:2aa:d604:62f3 with SMTP id d9443c01a7336-2adca6c8c34mr298805ad.10.1771960780478;
        Tue, 24 Feb 2026 11:19:40 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd64367bsm11607309b3a.4.2026.02.24.11.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 11:19:39 -0800 (PST)
Date: Tue, 24 Feb 2026 19:19:30 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
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
Subject: Re: [PATCH v2 06/22] vfio/pci: Retrieve preserved device files after
 Live Update
Message-ID: <aZ35wv5CKUtVoYII@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-7-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-7-dmatlack@google.com>
X-Stat-Signature: 6n97x3gf69wsbq6odk57w5os4gsycdp3
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E14C160003
X-HE-Tag: 1771960782-710920
X-HE-Meta: U2FsdGVkX1/SwORtqr1rL5HboXxJ1hIcJZtjrqqoBxvRsBpbnFtnW9tGAEMH3qe4WBzr4Ap+FhisGOGB7kIbh97oeYZVE2+40/XxHhoCPDWHl+bfsAH67D319XF+PXxoYJHu7rTqR/vBbtrdW/c1OtWI+sSqLacfPjQ6AJYznm+hVtLVs9/qyN1A1rAEdwwWVjypJ6TBQzVwb7TBuNKFxg4W53OzJGLeL5oksuI3NvaSwKqLm/EWMvr6jtvQOweMSznR/3RoNiP+ZZkZTv0Vxf2NNIPHWWJ7iJgS+pr5QyXadBl1xjH0xcsYWpBx0Nt2EdcPwe9sa2qJvH6Qg4XteOuHsvQedDinQ7aLVQQZ7awJtghLmfW3n6FU/uZimj7fS0CWRnnJqpNTRVAoi8fQUroqU4pv7TUefH3Ph9GUFoRUGLaReufJrGZiQBEatQeAMHMpJ1oXj3qFyeO8/4h8gWA03VbpnZLLtmeSdXBpDrMAoOr94w9/BKeWJdt1GOzzcGRSplE+JIBn5E6DH/JjalNj6HsDUKrekGSNi/l2RxYBYuYAgVKJjWSPVYnOQ7fvaC2xd8elcem7FxLyInBb5ZY2U8rGIcX8vHxeOKAKrc3zyh1X256TSVKFscOKDxkhDpuOfEgA7WY3/y/ekfyqOI4rzxCLwl4LkicLocheh7Mw9y3cGmAOmylxoWAUDnWaIvB+oZTdeqaoIMZhPo0SgzbC3JEbBfp/3+ZDtNLHNzH5wm9FynyjrkjF4IsDkVGSBeC7WT1CYzMaexVnd/Gor1lvA5WNrHSpVVALZH9ZfxFqlg4rig5q0oU9UKObUCV1MpCOvlZJGztH0Lkv06CY8y1vxAuennxJYxrjHP3ytVtFURn87Q/ULlijSbCHTGy9ZwfAwUtReiEeYhI0NgrWjCzxa4aG+EPdvTmBW9lJqqMfdCwAhUKT0UNEOBNRh/XlZOR9zYbn8ISnkfJWRZj
 JpPUPYy1
 nar2HCxYf+hSa2at27BSXOHvOyzLrlbrZ9sjyqbGDTDrF81eUKBHLkRKA7padvn3b4IiRN7YctY7GJLeCaZelrqDqRbpq5371N0enQPAGwjWSU0h8zst++T3AJv1SgwWMaXOb8ej+kUrqjYcxD1oRNGkVcVI0eN+/7nuqAJ5b+QgLvgtNjmCQiiLHTvw5ubyAUkaY5/dW+BnxJhbt/wBLRAoWI5yE2TDvx2Zig3IU3jgxZZg1j9Vavo++aUXBoeJ9pIYLbccQMhhr6q8h7btDpI08VGjTnmBVMkw91DoooEsD6cqRKQIDuPdXsCu416hxZUzNxqLPI+n396M3hCmPDONVtTGIRyDfZKjy3oaeC+ySOI6Mjfgo1waGyyqWQHZq/NUZMTx2c19H5fwEiCyhrRznWCRPRiN01whdHZG1Mdbx2CHNj5RvnEwruw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:24:53PM +0000, David Matlack wrote:
> From: Vipin Sharma <vipinsh@google.com>
> 
> Enable userspace to retrieve preserved VFIO device files from VFIO after
> a Live Update by implementing the retrieve() and finish() file handler
> callbacks.
> 
> Use an anonymous inode when creating the file, since the retrieved
> device file is not opened through any particular cdev inode, and the
> cdev inode does not matter in practice.
> 
> For now the retrieved file is functionally equivalent a opening the
> corresponding VFIO cdev file. Subsequent commits will leverage the
> preserved state associated with the retrieved file to preserve bits of
> the device across Live Update.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Co-developed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/device_cdev.c             | 21 ++++++---
>  drivers/vfio/pci/vfio_pci_liveupdate.c | 60 +++++++++++++++++++++++++-
>  drivers/vfio/vfio_main.c               | 13 ++++++
>  include/linux/vfio.h                   | 12 ++++++
>  4 files changed, 98 insertions(+), 8 deletions(-)
> 

The use of anon_inode_getfile_fmode() is clever! The abstraction is
clean as well. 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks!
Praan

> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 8ceca24ac136..935f84a35875 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -16,14 +16,8 @@ void vfio_init_device_cdev(struct vfio_device *device)
>  	device->cdev.owner = THIS_MODULE;
>  }
>  
> -/*
> - * device access via the fd opened by this function is blocked until
> - * .open_device() is called successfully during BIND_IOMMUFD.
> - */
> -int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
> +int __vfio_device_fops_cdev_open(struct vfio_device *device, struct file *filep)
>  {
> -	struct vfio_device *device = container_of(inode->i_cdev,
> -						  struct vfio_device, cdev);
>  	struct vfio_device_file *df;
>  	int ret;
>  
> @@ -52,6 +46,19 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>  	vfio_device_put_registration(device);
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(__vfio_device_fops_cdev_open);
> +
> +/*
> + * device access via the fd opened by this function is blocked until
> + * .open_device() is called successfully during BIND_IOMMUFD.
> + */
> +int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
> +{
> +	struct vfio_device *device = container_of(inode->i_cdev,
> +						  struct vfio_device, cdev);
> +
> +	return __vfio_device_fops_cdev_open(device, filep);
> +}
>  
>  static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
>  {
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> index f01de98f1b75..7f4117181fd0 100644
> --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -8,6 +8,8 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> +#include <linux/anon_inodes.h>
> +#include <linux/file.h>
>  #include <linux/kexec_handover.h>
>  #include <linux/kho/abi/vfio_pci.h>
>  #include <linux/liveupdate.h>
> @@ -108,13 +110,68 @@ static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
>  	return ret;
>  }
>  
> +static int match_device(struct device *dev, const void *arg)
> +{
> +	struct vfio_device *device = container_of(dev, struct vfio_device, device);
> +	const struct vfio_pci_core_device_ser *ser = arg;
> +	struct pci_dev *pdev;
> +
> +	pdev = dev_is_pci(device->dev) ? to_pci_dev(device->dev) : NULL;
> +	if (!pdev)
> +		return false;
> +
> +	return ser->bdf == pci_dev_id(pdev) && ser->domain == pci_domain_nr(pdev->bus);
> +}
> +
>  static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
>  {
> -	return -EOPNOTSUPP;
> +	struct vfio_pci_core_device_ser *ser;
> +	struct vfio_device *device;
> +	struct file *file;
> +	int ret;
> +
> +	ser = phys_to_virt(args->serialized_data);
> +
> +	device = vfio_find_device(ser, match_device);
> +	if (!device)
> +		return -ENODEV;
> +
> +	/*
> +	 * Simulate opening the character device using an anonymous inode. The
> +	 * returned file has the same properties as a cdev file (e.g. operations
> +	 * are blocked until BIND_IOMMUFD is called).
> +	 */
> +	file = anon_inode_getfile_fmode("[vfio-device-liveupdate]",
> +					&vfio_device_fops, NULL,
> +					O_RDWR, FMODE_PREAD | FMODE_PWRITE);
> +	if (IS_ERR(file)) {
> +		ret = PTR_ERR(file);
> +		goto out;
> +	}
> +
> +	ret = __vfio_device_fops_cdev_open(device, file);
> +	if (ret) {
> +		fput(file);
> +		goto out;
> +	}
> +
> +	args->file = file;
> +
> +out:
> +	/* Drop the reference from vfio_find_device() */
> +	put_device(&device->device);
> +
> +	return ret;
> +}
> +
> +static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
> +{
> +	return args->retrieved;
>  }
>  
>  static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
>  {
> +	kho_restore_free(phys_to_virt(args->serialized_data));
>  }
>  
>  static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> @@ -123,6 +180,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
>  	.unpreserve = vfio_pci_liveupdate_unpreserve,
>  	.freeze = vfio_pci_liveupdate_freeze,
>  	.retrieve = vfio_pci_liveupdate_retrieve,
> +	.can_finish = vfio_pci_liveupdate_can_finish,
>  	.finish = vfio_pci_liveupdate_finish,
>  	.owner = THIS_MODULE,
>  };
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 276f615f0c28..89c5feef75d5 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -13,6 +13,7 @@
>  #include <linux/cdev.h>
>  #include <linux/compat.h>
>  #include <linux/device.h>
> +#include <linux/device/class.h>
>  #include <linux/fs.h>
>  #include <linux/idr.h>
>  #include <linux/iommu.h>
> @@ -1758,6 +1759,18 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
>  }
>  EXPORT_SYMBOL(vfio_dma_rw);
>  
> +struct vfio_device *vfio_find_device(const void *data, device_match_t match)
> +{
> +	struct device *device;
> +
> +	device = class_find_device(vfio.device_class, NULL, data, match);
> +	if (!device)
> +		return NULL;
> +
> +	return container_of(device, struct vfio_device, device);
> +}
> +EXPORT_SYMBOL_GPL(vfio_find_device);
> +
>  /*
>   * Module/class support
>   */
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 9aa1587fea19..dc592dc00f89 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -419,4 +419,16 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
>  void vfio_virqfd_disable(struct virqfd **pvirqfd);
>  void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
>  
> +#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
> +int __vfio_device_fops_cdev_open(struct vfio_device *device, struct file *filep);
> +#else
> +static inline int __vfio_device_fops_cdev_open(struct vfio_device *device,
> +					       struct file *filep)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif /* IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV) */
> +
> +struct vfio_device *vfio_find_device(const void *data, device_match_t match);
> +
>  #endif /* VFIO_H */
> -- 
> 2.53.0.rc1.225.gd81095ad13-goog
> 

