Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E2DC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 20:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6A96B0088; Mon, 28 Jul 2025 16:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97596B0089; Mon, 28 Jul 2025 16:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85EB6B008A; Mon, 28 Jul 2025 16:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C8C156B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:56:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B51B160437
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:56:03 +0000 (UTC)
X-FDA: 83714880606.10.F294E2B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 877E38000A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:56:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BksYy3et;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753736160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lAhpTjpbvFQu27uIQ7LZXIQUIKIfZHhU7pyfNlOjpc=;
	b=SSFDTWKKKYJxlFvhYcO2qacB8P3Z97nJyYdP6+K9L+GWlC5L6EOPK9ht5dfCEKOqD+GTU7
	5SlcwoRGQIbPu9wzIOqBjG6ipnM44u/20PhVsrDiATPA70haNuhpug7++TFeMY/NbvBqmF
	mb64IWGobOC/jE/Tgpx4KVOfOQ8C2Is=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753736160; a=rsa-sha256;
	cv=none;
	b=gkUBUd8CK6+RarKlGHnlttzkTwerF2F+g0UnWSGfqI1Gpk4wXeSVYfbpHmvekKsOMaFo9Y
	gFmHZDhXjLKhIjVvzUCWEsb1/sQQ89f3n89lNmYyHP4/pwsCwrhn11H5322EId04piK0Vy
	i+3ceaYEYU7f0XGYN1w6miJ2Jdw5tSI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BksYy3et;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753736159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3lAhpTjpbvFQu27uIQ7LZXIQUIKIfZHhU7pyfNlOjpc=;
	b=BksYy3etYjW8K7sUTxLeFPie7KXRx9gJQ/sRIXOQjL/L9ALBu5I2yr4R5f4NiDCtD5+PvE
	CKuTKYDC+hk1I9vxXzZZqsl4FgjlHMko4Uu8bw/QIZZlBIvxkvkHi/jV1nMNHpPmujxv/e
	Tuu4KvgWYUSB2iogdIyG/pXMEShBn8M=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-SVEQbD4gN5CSweWlwVZkMQ-1; Mon, 28 Jul 2025 16:55:58 -0400
X-MC-Unique: SVEQbD4gN5CSweWlwVZkMQ-1
X-Mimecast-MFC-AGG-ID: SVEQbD4gN5CSweWlwVZkMQ_1753736158
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3df57df1eb3so7487525ab.2
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:55:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753736158; x=1754340958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3lAhpTjpbvFQu27uIQ7LZXIQUIKIfZHhU7pyfNlOjpc=;
        b=O2Bcku236Tinv4t/yyzRWtKFtCjiApXPCrZ3JcXnNbPGnZHdvcpdJKth0bYGTVCAwn
         /EhtM4j0pZry+z9b1Id56C7qB2SLexTxt8iqYurmpD2Xz2uHgdQfpLxVS0th6updadUT
         HIuVJiHb/ODUhVO3BCCmvRYuJ4ctGrmy7EAdnNvs8wTw40i9eDA+LIoTJcXTUxtdNCdP
         HLU8tm2QrZqT84+AH3egP+j5Z+N5UF9yh4Botlcl5So+XUMKmkXQeNj85Jmk3blYfc2b
         P+NGt3MtiIm646+oakFxzMxnLeW6Mq9gryJqdyHsf2tuxN6XqIiGNAAxVfQF0qDnM4FZ
         nTWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZJEiO6qvFtuPrZegRGKQXd44Gj+8TCtWrtRar4PIT51+I9tmEaj/38ztZ6XetrGFJwtuefPEyxQ==@kvack.org
X-Gm-Message-State: AOJu0YzaFXSAv6Qzpw+b03rJnSrAriCzfxA2Bxm3oqZ6O9lZ9wvDDvVZ
	FhYcL/NzgNoQZeE9jxsL7a2ZP9gM8X1pMeQPdpBRvTrCyyyBb266KTJuhsfamexznu4ZFYJTXPO
	QRXX4NdsGGpI5Vdr8Wa/sJlAK4w8TwEX6ex9IhFCkLuvQZlo2taxM
X-Gm-Gg: ASbGncs2JQmeFFPstwgnqtFtfN5HG0Hgvw0IpuAUgoF5Q3Kn0dEqNZzZYockYDlDs7G
	dK4rdrgKtAud/p597nstMb+OtL8JBzByuh3IhlWVYHVQrFGLD0MT5etZCTO/CjH2sWsdmRMcJvc
	T7UGI+UT4CcXzcjVXHrrlmMGgSKllM3UW5ELc8hrIZN7VAluaE2iX0Hu+BHdD1iriqXOAm+/KMc
	xSNUXSwjTothtT1CLdqnaloygCWJ4i76DjeYctvdi8iZqTG6C3NjlSSyaUSt4rywM7SNVFJOSIG
	51FIYEgoE6tuOVgtVx64EfofA18erOABX/+IoxxHC70=
X-Received: by 2002:a05:6e02:3389:b0:3e3:e461:4617 with SMTP id e9e14a558f8ab-3e3e4614777mr12699175ab.2.1753736157530;
        Mon, 28 Jul 2025 13:55:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaMLNGgu4ToITqnk/t+y4I2RkNZuq3J6YSgL+Stwkf8Y5Ta3HhAl493hrL7HwiUxfbSIOjGA==
X-Received: by 2002:a05:6e02:3389:b0:3e3:e461:4617 with SMTP id e9e14a558f8ab-3e3e4614777mr12698925ab.2.1753736157034;
        Mon, 28 Jul 2025 13:55:57 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-508c9341e4csm2109194173.76.2025.07.28.13.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:55:55 -0700 (PDT)
Date: Mon, 28 Jul 2025 14:55:53 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>, Christoph Hellwig
 <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>, Christian
 =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, Jens Axboe
 <axboe@kernel.dk>, =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
 Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Logan Gunthorpe
 <logang@deltatee.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin
 Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, Will
 Deacon <will@kernel.org>
Subject: Re: [PATCH 09/10] vfio/pci: Share the core device pointer while
 invoking feature functions
Message-ID: <20250728145553.53e94d49.alex.williamson@redhat.com>
In-Reply-To: <19f71a0f4d1a5db8c712cb4d094ccf2f10dc22c5.1753274085.git.leonro@nvidia.com>
References: <cover.1753274085.git.leonro@nvidia.com>
	<19f71a0f4d1a5db8c712cb4d094ccf2f10dc22c5.1753274085.git.leonro@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9RAT6MILGwdtP9wmKfdHdsF1AAbVNLIAsqZhrlY-ulg_1753736158
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: orxmry4khopk5ahjs4bb9yrapxws5syy
X-Rspamd-Queue-Id: 877E38000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753736160-370768
X-HE-Meta: U2FsdGVkX18TBRn2ur2AMUWjbXnjuscntjS1UucANHS574lSn++LT2avocBJj5v/HK6UVYuoM5zEDvhL4O1oCrLi14eV34Xyw2FudDFYPdH1L0IR1itbBKwHqpU/bHyhKgbqmXa+5rziXCa7pEXURgp2BBoVHeXFcmQRziGNGS34PuyijjYTjVC9WhqocJoxObDWSw9dsuLLgMHqhTrfWUpcdzBc+B5YTnG2AzmQH7qCf87s6BANQnvTiCbQZ9pw0ra6eEpFAT8Fq6UmfRaBkfMG36BvvmXIwh++4Agw/Eijsg4MnmhXKxoyIWmPwG2D+OB7XLWike4meT5nAK4voJvoQVORR7rlB/5vW1uaLAWX6rLxGRHu/XH/FkySpCSYS4UFNZUBnBe7Kk7naGCF3uXEOdk+Hhv6eu0lZCgaTSEfYVdA9f008kHr1HEr91Vknj29ZyzLIvVoiZzCos6Cb50YA9eBkW+igCjrUiATQMwaHbhVN/ZRbWlJYaxZtuwW2o9BHqkiULDQn+E0FXnwR1o51HVad+Hx1w94105hn1pktAVcrfetsdEIonqMcV6LRB+bdbA7Vx2jNp4ZEWwUcsqd1xzFcw+/zQFK2/CZw0vgQxGOVHju+B3l8R5nOnUg6IZ00hXAMdR9ZHoXSlZ4cWJ0R3LJvUPkeMm7tramzYfSbcYV2x6kMEBU9LVyln7FtplXnOzMPh4nWUbmdCGiEt0cZNP+VeQZ+oy24nyo3v0dpndGnVMzpzDOr90v69/ziwlzPbLwtkc+RniLZcSQxqTwdFnQj3pcI7rINHE4SK/oFqYhfIYNQCF+OU1LXMOlg+7vuGYQ43BeNUn9FC8fOr1JLIf1tjS+0DspN+QDen/MBApOsBNR0im/e0jdNXz3voTMHCP/cYr0hqwW19zSaQuPtg7YEL1bAvgBBerKhOx/nJKx0b4R3c8gU6nvqHQXpkmm46YJ38TzH7Z4OXH
 YjgHFfcm
 PzYFBVzb9DI07pPfYDwqxsGZ1klUNjyMj6u3Ynnwstwc4N2XipAsZyj2Fu8Xh4USxc1uxKfk8QzXCSJZ/wg/bcT8939/BWYgycU5zNqcuwqG7TKsqMryorVTwAaUT87HhfQZvq8jIBmlf8QQLmyRRTaow+M9/o+Oz4lRvWPL+pac+DLTQAqigXPyA3/fbwNpg03coiGf93O0PUBHnvuNjQRhduV1s9VEuIs7QhbQPIduMbpepo0M0/yEOBfK2SFTGKxT4T6T/QNK2QwzrMxBNiGe/uPqsChfvc7PWusYmLWMZfLJtMmF4mmFH18uBivpHnOP5SPtohA7fvm3LS73eWrbXOk+lh9LHhZ3FAdxTQ+ZPDpgQJBxobs/szAxvUoH3cjmIGntfXabJ2JOiFLzJmE6CaIRlo61WoYgPV9SXKfzDZQgMFVKrknOzFYqI7E+omn3l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Jul 2025 16:00:10 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Vivek Kasireddy <vivek.kasireddy@intel.com>
> 
> There is no need to share the main device pointer (struct vfio_device *)
> with all the feature functions as they only need the core device
> pointer. Therefore, extract the core device pointer once in the
> caller (vfio_pci_core_ioctl_feature) and share it instead.
> 
> Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1e675daab5753..5512d13bb8899 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -301,11 +301,9 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
>  	return 0;
>  }
>  
> -static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
> +static int vfio_pci_core_pm_entry(struct vfio_pci_core_device *vdev, u32 flags,
>  				  void __user *arg, size_t argsz)
>  {
> -	struct vfio_pci_core_device *vdev =
> -		container_of(device, struct vfio_pci_core_device, vdev);
>  	int ret;
>  
>  	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);
> @@ -322,12 +320,10 @@ static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
>  }
>  
>  static int vfio_pci_core_pm_entry_with_wakeup(
> -	struct vfio_device *device, u32 flags,
> +	struct vfio_pci_core_device *vdev, u32 flags,
>  	struct vfio_device_low_power_entry_with_wakeup __user *arg,
>  	size_t argsz)

I'm tempted to fix the line wrapping here, but I think this patch
stands on its own.  Even if it's rather trivial, it makes sense to
consolidate and standardize on the vfio_pci_core_device getting passed
around within vfio_pci_core.c.  Any reason not to split this off?
Thanks,

Alex

>  {
> -	struct vfio_pci_core_device *vdev =
> -		container_of(device, struct vfio_pci_core_device, vdev);
>  	struct vfio_device_low_power_entry_with_wakeup entry;
>  	struct eventfd_ctx *efdctx;
>  	int ret;
> @@ -378,11 +374,9 @@ static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
>  	up_write(&vdev->memory_lock);
>  }
>  
> -static int vfio_pci_core_pm_exit(struct vfio_device *device, u32 flags,
> +static int vfio_pci_core_pm_exit(struct vfio_pci_core_device *vdev, u32 flags,
>  				 void __user *arg, size_t argsz)
>  {
> -	struct vfio_pci_core_device *vdev =
> -		container_of(device, struct vfio_pci_core_device, vdev);
>  	int ret;
>  
>  	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET, 0);
> @@ -1475,11 +1469,10 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
>  
> -static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
> -				       uuid_t __user *arg, size_t argsz)
> +static int vfio_pci_core_feature_token(struct vfio_pci_core_device *vdev,
> +				       u32 flags, uuid_t __user *arg,
> +				       size_t argsz)
>  {
> -	struct vfio_pci_core_device *vdev =
> -		container_of(device, struct vfio_pci_core_device, vdev);
>  	uuid_t uuid;
>  	int ret;
>  
> @@ -1506,16 +1499,19 @@ static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
>  int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>  				void __user *arg, size_t argsz)
>  {
> +	struct vfio_pci_core_device *vdev =
> +		container_of(device, struct vfio_pci_core_device, vdev);
> +
>  	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
>  	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY:
> -		return vfio_pci_core_pm_entry(device, flags, arg, argsz);
> +		return vfio_pci_core_pm_entry(vdev, flags, arg, argsz);
>  	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP:
> -		return vfio_pci_core_pm_entry_with_wakeup(device, flags,
> +		return vfio_pci_core_pm_entry_with_wakeup(vdev, flags,
>  							  arg, argsz);
>  	case VFIO_DEVICE_FEATURE_LOW_POWER_EXIT:
> -		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
> +		return vfio_pci_core_pm_exit(vdev, flags, arg, argsz);
>  	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
> -		return vfio_pci_core_feature_token(device, flags, arg, argsz);
> +		return vfio_pci_core_feature_token(vdev, flags, arg, argsz);
>  	default:
>  		return -ENOTTY;
>  	}


