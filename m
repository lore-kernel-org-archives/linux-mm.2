Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E1FEEFD207
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44F026B008A; Wed, 25 Feb 2026 03:38:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430546B009F; Wed, 25 Feb 2026 03:38:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3332A6B00A1; Wed, 25 Feb 2026 03:38:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F67A6B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:38:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C0FBA58613
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:38:16 +0000 (UTC)
X-FDA: 84482326992.24.0636EE1
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id DA29940009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:38:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kwBBPtyp;
	spf=pass (imf12.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772008694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=euz76pxATmJYev+UEaMjSj8YYGXQ5aYbA3uegrgN/Es=;
	b=VGmhfjW5OvnVobfi47QNv6CQEEUO/nVS6NRpN5gCOQJWBzn3n3/vUsWJJRNW+1NQVOPRxL
	SrJ7gai4ZzxzoNlQR2le6qsaBHgcQ0MpOezvtNiEV4/2Wkv72UppmB6Qb+nOJyjECgx4T9
	oQRdUD1k5Vw4w++Tmxvpry1UjgyuO/8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kwBBPtyp;
	spf=pass (imf12.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772008695; a=rsa-sha256;
	cv=none;
	b=qUBrvCKiMP9/ddhbtnF8hbRvpCG/TDYzSdojZV4lXPufS28eyhczha+XlZgzZiplxe4hDo
	CH/CNKhP2mPWNkXZMTwrbTgGxtOqrNer/1vV8fmccPcmKIl6HK9mHasyxkITPp+xWA9Ck7
	uDONaOj1mt8Rtcp37GdYXm0XjLTzuew=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2aad8123335so61815ad.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772008694; x=1772613494; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=euz76pxATmJYev+UEaMjSj8YYGXQ5aYbA3uegrgN/Es=;
        b=kwBBPtyp6SRTYLmObsRb4H+UIBOM1XLiXk0E2Q1ZTD6hwuXDT2/Q1uIUJcPeyJgKV4
         uREmMQfTFKU8Kao67cbIfEf36eYkWTi593WmrkkXqhMppfabWw6eEIn0XQW39XAuFDh+
         O2/2x+QbPj6rJzUOQ1Cw2okYG0g/Y2gwxIdyavsQreoFZgjdajojRG0ZX0Wst5prsMBi
         buzI2HAdUXGgWySUWUezgjB3rws8AKiCZhhCy47PshvB35/HP51LdTLT5xKHgfUGSyKx
         0aiU2ApKqRon5jtiatHpwR3dUpHMBxV03Y+b6FOmUV9CggO1bO9zqTI3/W/wARToONIx
         Dr2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772008694; x=1772613494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=euz76pxATmJYev+UEaMjSj8YYGXQ5aYbA3uegrgN/Es=;
        b=HrFtANxEcU/OJ/ERhcX0NjnV+TBFRKAW+k5ZAGQfxQh9DJ8qqOhb3ciJtJbd94jP4c
         9vAv8mvgc4UH/2dvnSbchJGf/PeUwF/lbQeC2vtpSjxfwcLtSIGklMP1NzRHMu0vEY6Z
         GOiwZPBAaWvOS1y4FJIQO5A7CUFmxVGSXBI0U5VfvlIjyXa+pB/nr4mLsF1dVUMLDJPX
         p9c++FgHVf+Jxu+q3H8gCQjcvWbxV6VSq/ka85OfzcJXE1+ym7wXPleYLkDrPT3B2QJr
         XHykpuxC8MR427GagPBUDlrYEPbWMlGNxi67HvIFbfp2LVi5xk8smO5E0W+l+bmjm3lc
         kCTg==
X-Forwarded-Encrypted: i=1; AJvYcCU1UpHAu2aRIcJQkLFvWLPcJD38cX1NIVzJEBwTymjioDQkycT9pfuDsqsk/eZI+/XrC+c76qM29Q==@kvack.org
X-Gm-Message-State: AOJu0YyFkP2+j/z9aTirQKIHZyMbAuVPBJ4iyDKNLeeWSdvV2rIwFVJQ
	ux7tJb6wUGEJQVz4FVqTHpT4VGPVzbrODOES128ushZK/WGbEcNtUC5/j0va1irgZg==
X-Gm-Gg: ATEYQzxuWJhtK8UZn2goYJCn0qR75cLDY/UJZGYbYMqbLLVXlAof8QZTbt/B7VQRB3c
	Wt2d/t6334eqeT1Ty8jqWS55FU+t/zExxCUAU3GZTUzuFIPFDlTTEl+g7QbY6BHY6DbzSSNocfF
	jjNerRzh6SUCMB3GSqS8RrQ7+LIy2qG6jcp9SUO4RJJPSZnrIxBFZt5GcDf7HATfnN+fnM2i9Sk
	bgWBMMPVpJBWhHvCoHt4KwTrucTHkaePbZoi6aY+vzemXWSxRh1KA4AQwXX/lmYcmEMHLjpw2cx
	AAGTNW5E3yRnJkMIP0+vP36pjl2IQN+ynk4uSYOKRhGnABmCbGRh76Ixp0CnbhUrgmAcLGiBvRh
	EEz0QrDG0o2tgHlyUlllF1rjJmTnR7NojsntO70QXAP/vovs8lzdg8c4ktdO8aVH/roQ1BQP/qc
	aApdYUCEqeRl5EkHvpRN9+8cVRgCizvoiUO9UKoIbfGxh+A57/dZvaqTwko019
X-Received: by 2002:a17:902:ea02:b0:291:6858:ee60 with SMTP id d9443c01a7336-2adca6c8a9fmr1402215ad.4.1772008693092;
        Wed, 25 Feb 2026 00:38:13 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd6c30dfsm13034861b3a.27.2026.02.25.00.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 00:38:12 -0800 (PST)
Date: Wed, 25 Feb 2026 08:38:02 +0000
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
Subject: Re: [PATCH v2 09/22] vfio/pci: Store incoming Live Update state in
 struct vfio_pci_core_device
Message-ID: <aZ606sDJxtfNF6qW@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-10-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-10-dmatlack@google.com>
X-Stat-Signature: je7qecnjnxg6x9gw35urdbojfj1dc9um
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: DA29940009
X-HE-Tag: 1772008694-664385
X-HE-Meta: U2FsdGVkX19ArbkGabP+E/Pzrgs9R5zNYQoHxz/E22Ae8BUMKgi6+rZQ5NJTjYXNDqc541EJfileKkB6AgoHUSg0d6AxCwxciitibPT5o9UfpzPpYNeyqQMnr86nEcxYx0p7TQHXw4aooclsevUXZ+32VGDamyI4/c48JRdtbS0F+MAD4bVkOfGpsKMS7HPQfjJhXR1GRmz3fpL9y71xxgZL4q8Wo+xKLzo73y4JwIP9SmurfMJnuPT8dFrpL9QG+ti2dUNO80M+Vg5yDdqxWgAJE2/c7MzkQqFPxl+KUnZ8PevcTG6rVv+N1MMa3P0CifAqovUfTyVRy2vwfDnq7hnu7a2duIIYjAi2FW9CkdpzL8mHdHFPUBpKUPHYSNe/+Oc+jsP87CIyCMomdJQAVfThcGK5vUNlZwclOSV4IPXvoN+DmpAQPodtCbZ7aA612hYtx5Ar8vtYpOYig1UqBBtdxXRqr0wMzi4O4PSXarW/NckdHcVpYOanosZHsMrV1dgI2rShRyaRaiv2jwAYMtzmn5tAC3lrw0LsA5IrwcUWLBprQzTKgNoEWKIBDhq4mrJg8jFrGK1hWmmiKX6qiVPOxEof9Yn4DzvTNFxjCNUxKHPYZYv1XWiZb69zBXRvoaf9cODNGnBNu68iXYWdmOWBdN3bEOc6lth8C9OkM8KsgL/Kb19EQUaRd5HpRVBlA/8L0Gnowb362BmwGuZ+kHss0lhp0o1n441jYPNvA4G6aI1WQ8sCL0adWpMf+EUTuE1NZuX5VVeyVU/E758eAYd/Rtn0wfgrFb4T79BHGmKfix4iSsQo/P2+Cz0o0C7Oa3/ZSzH5NX5iW9loZJv5/sjl7GmeJyyceHUAQVwSWeY8Hwfh6Et2Lm0DTqIMgswcSWYSVFXUvsmIuYFdwIE0MaYUbQOD/xjp1pKZ1LLPMnWZDJnj0u1U09Ov5xv5z+P3FKU8Vs6WTk2yEmzSQJr
 n7VuFQQD
 rFQdwDut8OfrDVkz+81Zz3trQr0KEyaksrw63zMPjCMflWWQy2KqnYmIfBpLobRpaGOaBuviWvslIm8uKMatORBozQebvjhI/VHBlwOlH/KkMEwZoKTz5cyrql8YYW1JXySvwbzFaX4UbNwCFNIsczYbVbSvXSBTKf+YTdOCMJU5QU+YnPToJ/NT5JUADW4l8UvBJZBWs/Cl68s4lfwPzy3EuHIC/YoPFdxIIFvueKeX3+WJVXiYBKyBuzgZGQ8dLIYoH03LtbdWrVC/FGHY5ECyefi/ErHQlp3CIguUTT7YbHU/GgLUGgy/wLs+U6Wn6cw5kYhe7HXErsz5iDxekaPA54Y4Y0gNu5Ncx8xNbWR0n9F68o0jJ3Mw/+DA4cDmMiEXjdbATTH1zBbO/AJTgDzItjHoU2Kqbh2w0J09djkE0jZG7+jPpNHt6Igxg+s2Y8CKTn7/A02lbPE86ZThjxDwIVBYOLpdKWa5PcRnIcgROWtw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:24:56PM +0000, David Matlack wrote:
> Stash a pointer to a device's incoming Live Updated state in struct
> vfio_pci_core_device. This will enable subsequent commits to use the
> preserved state when initializing the device.
> 
> To enable VFIO to safely access this pointer during device enablement,
> require that the device is fully enabled before returning true from
> can_finish(). This is synchronized by vfio_pci_core.c setting
> vdev->liveupdate_incoming_state to NULL under dev_set lock once it's
> done using it.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c       |  2 +-
>  drivers/vfio/pci/vfio_pci_liveupdate.c | 17 ++++++++++++++++-
>  include/linux/vfio_pci_core.h          |  1 +
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 3a11e6f450f7..b01b94d81e28 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -569,7 +569,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
>  		vdev->has_vga = true;
>  
> -
> +	vdev->liveupdate_incoming_state = NULL;
>  	return 0;
>  
>  out_free_zdev:
> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> index ad915352303f..1ad7379c70c4 100644
> --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> @@ -131,6 +131,7 @@ static int match_device(struct device *dev, const void *arg)
>  static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
>  {
>  	struct vfio_pci_core_device_ser *ser;
> +	struct vfio_pci_core_device *vdev;
>  	struct vfio_device *device;
>  	struct file *file;
>  	int ret;
> @@ -160,6 +161,9 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
>  		goto out;
>  	}
>  
> +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> +	vdev->liveupdate_incoming_state = ser;
> +
>  	args->file = file;
>  
>  out:
> @@ -171,7 +175,18 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
>  
>  static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
>  {
> -	return args->retrieved;
> +	struct vfio_pci_core_device *vdev;
> +	struct vfio_device *device;
> +
> +	if (!args->retrieved)
> +		return false;
> +
> +	device = vfio_device_from_file(args->file);
> +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> +
> +	/* Check that vdev->liveupdate_incoming_state is no longer in use. */
> +	guard(mutex)(&device->dev_set->lock);
> +	return !vdev->liveupdate_incoming_state;

Since we set this to NULL in the success path of vfio_pci_core_enable()
I'm wondering if a failure in vfio_pci_core_enable could cause a
resource leak? Because vfio_pci_liveupdate_can_finish() returns false
as long as that pointer is valid, a single device failure will 
perpetually block the LIVEUPDATE_SESSION_FINISH IOCTL for the entire 
session preventing the LUO from reclaiming KHO memory.

Shall we also set vdev->liveupdate_incoming_state = NULL on the error
paths of vfio_pci_core_enable() ?

Thanks,
Praan

