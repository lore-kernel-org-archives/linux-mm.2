Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B1EEFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFB9A6B00C6; Wed, 25 Feb 2026 02:56:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE496B00C8; Wed, 25 Feb 2026 02:56:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC096B00C9; Wed, 25 Feb 2026 02:56:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8ABD6B00C6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:56:05 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85296C1D37
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:56:05 +0000 (UTC)
X-FDA: 84482220690.01.26A085B
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf28.hostedemail.com (Postfix) with ESMTP id DD8E8C0006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:56:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ht+ktL2i;
	spf=pass (imf28.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sT2VtKh2V5oEus0jIgTdEjDE+//UyVLRT7BohuHzzWw=;
	b=XVWOhtTOBBZ9ZMJSel2mtQ4WJGNO9esN3V4DEVerHC7H0p55E+vlQ8kQafYh3RnwdEG+C+
	ItjV4RqlZ2qLi0tzA4rFfI9XFrJoD9SC4kiaKn5NuZk5EeW1jX2HCGQWcYCF2j9imlXMyg
	Cmo3gqzRr5dpRCx4hTPpUuUSszr8JUw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ht+ktL2i;
	spf=pass (imf28.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006164; a=rsa-sha256;
	cv=none;
	b=gj0RjGmjIZLqLY5ZhemdczyOsq60BbJ0tQgrUISwsQJ/SsjMbWAj7DKdN+a89H6oyThPIP
	Uz+XFCuTHbECfdaLzzjcOBDimrEAaKnJd5RYt0jxPjBNE+mSvz8Z349wSFyEMtJ5URPxFI
	ANWYjP3eMvsp0FnOSklOim2j8mflDPI=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a964077671so71285ad.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 23:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772006163; x=1772610963; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sT2VtKh2V5oEus0jIgTdEjDE+//UyVLRT7BohuHzzWw=;
        b=ht+ktL2ig+4K8mHdUtNTbkcXN2txKjsvxO/WPhBA9O9Hl0pd1MQEsnd3xgmKZP25SU
         xcu8HjVYNToSjGdE0UfgiqM0yywtayJvUNz+2vZIyVM6wAqjYRAwqcdDRjM0G0CaQ6ne
         /fkBBNd/+ntNaSZqFCpNmSlK5ejZH/Vr6nbYSsUrI6cu7VCSxG7fUZovYBK2sFy24CKD
         f2NxSkhq3i53g8JLDWf3btBsV4ZzWtVc0hW1ihcoT6S6gfTWIcpc4zUwMJ8Sn68XTSc3
         hsz8KJNVemewZMVuQW0EUvWS+PMMjUaSkYrm9wm00svxY05db3xmx8VVTVA5waqYtPEx
         41yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772006163; x=1772610963;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sT2VtKh2V5oEus0jIgTdEjDE+//UyVLRT7BohuHzzWw=;
        b=VwugNIr93JS2t2RaLG58oR1g45rOrX5zmA5o/GA6K5UgTjimg4Idn/yHXbvf9J6ivg
         ZLmylcGeq6XCQ4vAkRc+rkgsqiKSHA73geg5evyMInIW3bTQCW6qumGipX5cOWXf+OUo
         HNrHtfMpEgugOVlooVU2vRWQLC9svFkBrUw0QWhKFFHXDijCylUBYzHXaTw1RiT9zEgi
         yGsqg9MjndnFwbg1ED8/giDuNZQpG1RgLkhIREPprachV67MVEpi34fJg7HGY8IE9S+A
         YrJ7BFRjUsOvKOCUM5msw0PHMdkmSl9Yp/LqzwClrMIVQBpKkXAoILlH7i9r2Rx2WlpX
         UGfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZg+JjtvtNla14r7VSP/JDAvECDRvtkK2u9rZuS4JTohl4JDphOn6bG4EBcwkOvHQrPuN9UyCn/A==@kvack.org
X-Gm-Message-State: AOJu0YxUfrRVV7rwqfzqqVYpnGwKF421qgAliIj7PPGeAmPpuoYTmcYC
	9+eZt0U7UkoxQZO3cB9ruA8D3bdO8/8XKcduk7OwWruj0uH4NqakBG9G/XhrXwgCUg==
X-Gm-Gg: ATEYQzwEGcRK5ovlTRwenUPtu7aPm+C9R7dqA1PQMOhSwseQwBWaaST5m3GyM2gnMIM
	Lx7+FPmLpFiCOAvFXleuM89t7QAfkQ113XAa1K5GBtJp8DU2d3prA3Jk2RgZ1JygNKz52oy5HxF
	lkoTeQkHD66CV+4tsMvAMWkNI9ePBQ2k936uwDkgpgaBs8+RRa9Ecd8vVNlX9PRoEk+Klu1rHWs
	Mb91OMIO+sVa8BWf7Hh+eBT9xgplu7PjUrgWrWf120zpZVaH+6IVue1xTQEfXiJvLcdP+3l7V2m
	wW9roTjPYvaaiy8UDArzQRvswFUdHP9Cv0jwTzpDYZj+hzdasM/DoHYJr9dBKnUpMTILQXiuWUT
	PMEbs/cJb6AzfK4sCOCrDHfACNIpIjtdLmHWZEN7NXOB2NumcqhBaVGK1k1b7sXguQtk3Hy99Ks
	cH9DCg+SXg873Qc8vaJkMWvQdMe4ByIQCa8j1V4ICc8cGqjn8YKzPCyalOgPpM
X-Received: by 2002:a17:902:d592:b0:2a7:6c4e:5924 with SMTP id d9443c01a7336-2adca6e950fmr1322615ad.12.1772006162194;
        Tue, 24 Feb 2026 23:56:02 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7500e2b2sm124024035ad.52.2026.02.24.23.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 23:56:01 -0800 (PST)
Date: Wed, 25 Feb 2026 07:55:51 +0000
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
Subject: Re: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
Message-ID: <aZ6rB-zmpaR3RLB_@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-8-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-8-dmatlack@google.com>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: DD8E8C0006
X-Stat-Signature: ritmwa64u6hixakaaegn6h43ph9ym9sk
X-HE-Tag: 1772006163-383496
X-HE-Meta: U2FsdGVkX1+w01+DhVzZhE97XiJErdYKDfV4hbp+N+zf8K41vr6JJe+qdXkLYKrPaytLxHrm+aaFDJkgtYY9KXhJwV9mhJXHsEQkK2UwhNlc0Q9k4wEAUOegY5o2M8a0t+nPqRoDQt8sxoLVKBth2NSOU4y7Hjpj4DccvVPYcFrT7JnYDUmWlbj32Vy0DPjsjXl3R5IXnJNVCkNh1dH2AJ4N35N1xKGol6+rV7mfwNNpko14RlI7tuTkF2h6ZLjq2FgIA0anr3IlTiGt8NJJV01fFzkOpfnDvYd5grL82kX1+C95P8gvLR+Sd2pIeL6pLK2kpbPjT+7/79QokqayWYFUDM4PsVh3EHLWca4pJhESJ46vcQC7Dk43P1YoMWiC0fUYKjl4EMq39xHJcz/KVSuvmLcgp0OTSeb6tmoy/PTLfd28Zmi8ELdil9wstgO4TpP6XwqYq9TeWQXgT6eaU/XRe3XQDKftnmM5AmGGQyRCCUdt2E3zbBdOPM9Oza2T5OCtel0SZpGFBNC9z137+CZdRjwjB4bUBN0BCQnAMsfQsopOY3GPvfAV4fp5m8mMXRx2I3SqQA2vkJmqhT8+Oqp1W4Qw8XBzlF+h5YIVYOBnNUAU43fFHuD803jvj+rMUG7syJzlVlshoHAP0O9BshVFHGIGjdbJ69PbbgJSBSBMz8+cjfWBzs3hp2x04LSmj24Sigiv5lxD9mWjAgoznPyPzQeeZ7aZ7Uo2vQYPl7yyCuBrwV7AYVk/peIPlrNlsptgqH65pTKTWZPop7i4eXfBQFlLbu7w+aYg7wFoUdqaKnGP1Z6RBcUHZ+fGGhXG9kX7Z2Pzh1hJim5mmZwZZpSHk/0ZtXZNvKnYzY+ylKyGx83Nwi9n7e8nIPH14pE9f+B+MbkzLVto5bWL1OOZx02P70fd8nHtEUwKUEXP5RCQ+jGw6SZE5F8dbdacgRXOQY4m+Y/dgf8OybRtxZ2
 2DFgBkfc
 eupZFTezLJvgj2mneaXJpooNjJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:24:54PM +0000, David Matlack wrote:
> Notify the PCI subsystem about devices vfio-pci is preserving across
> Live Update by registering the vfio-pci liveupdate file handler with the
> PCI subsystem's FLB handler.
> 
> Notably this will ensure that devices preserved through vfio-pci will
> have their PCI bus numbers preserved across Live Update, allowing VFIO
> to use BDF as a key to identify the device across the Live Update and
> (in the future) allow the device to continue DMA operations across
> the Live Update.
> 
> This also enables VFIO to detect that a device was preserved before
> userspace first retrieves the file from it, which will be used in
> subsequent commits.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/pci/vfio_pci_liveupdate.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> index 7f4117181fd0..ad915352303f 100644
> --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -53,6 +53,8 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>  	if (IS_ERR(ser))
>  		return PTR_ERR(ser);
>  
> +	pci_liveupdate_outgoing_preserve(pdev);
> +
>  	ser->bdf = pci_dev_id(pdev);
>  	ser->domain = pci_domain_nr(pdev->bus);
>  
> @@ -62,6 +64,9 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>  
>  static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
>  {
> +	struct vfio_device *device = vfio_device_from_file(args->file);
> +
> +	pci_liveupdate_outgoing_unpreserve(to_pci_dev(device->dev));
>  	kho_unpreserve_free(phys_to_virt(args->serialized_data));
>  }
>  
> @@ -171,6 +176,9 @@ static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
>  
>  static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
>  {
> +	struct vfio_device *device = vfio_device_from_file(args->file);
> +
> +	pci_liveupdate_incoming_finish(to_pci_dev(device->dev));
>  	kho_restore_free(phys_to_virt(args->serialized_data));
>  }
>  
> @@ -192,10 +200,24 @@ static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
>  
>  int __init vfio_pci_liveupdate_init(void)
>  {
> +	int ret;
> +
>  	if (!liveupdate_enabled())
>  		return 0;
> 
> -	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> +	ret = liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> +	if (ret)
> +		return ret;

Nit: We might need to handle the retval here if we remove the
liveupdate_enabled() check above (as discussed in patch 2).

> +
> +	ret = pci_liveupdate_register_fh(&vfio_pci_liveupdate_fh);
> +	if (ret)
> +		goto error;
> +
> +	return 0;
> +
> +error:
> +	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
> +	return ret;
>  }
>  
>  void vfio_pci_liveupdate_cleanup(void)
> @@ -203,5 +225,6 @@ void vfio_pci_liveupdate_cleanup(void)
>  	if (!liveupdate_enabled())
>  		return;
>  
> +	WARN_ON_ONCE(pci_liveupdate_unregister_fh(&vfio_pci_liveupdate_fh));

same here.

>  	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
>  }

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Thanks,
Praan

