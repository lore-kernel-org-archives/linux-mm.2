Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF8B710F287C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 23:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2332C6B008C; Fri, 27 Mar 2026 19:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20AC66B0095; Fri, 27 Mar 2026 19:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 120E66B0096; Fri, 27 Mar 2026 19:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1D756B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 19:40:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 906111413CA
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 23:40:01 +0000 (UTC)
X-FDA: 84593463402.25.E80AA12
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8BD510000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 23:39:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=deYm0Ete;
	spf=pass (imf05.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774654799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJh+fSdSH5NQ/gboRRLrSOUWnglDImWXDS4hyVsChMM=;
	b=kpBa+e6e6ZQ7hPbdKYcVPb7SFNxzU+JpPIjUmpybPbd+L1bf473eVkLuT0AGzVOXs3jq9b
	cAruW5yoKzOnhKPaR2nNlrKm/KICtILoccdRejjKA11GhS7neeS3gvB9hBu0xUG2UFMhB/
	wdJDRp4pigikcYwWeGNe9GBe7u1TiQo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774654799; a=rsa-sha256;
	cv=none;
	b=gliU03mok1WoaKmZ4vEMWz/CrlsmCCprU9L1Brs/XCCNl0K3nzy+w+nnT9GMZxz58e6Cbo
	TB9RzvEtBCkEzWGcKtTgbjhLCgldXYEGmayRKOTwSyuRJZfIvwqW8KHLIh+K64CP4S+1gO
	UhEMSavDmUcAsfpArYo8/0IYHLKbxLo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=deYm0Ete;
	spf=pass (imf05.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b0c12be0ecso36695ad.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774654798; x=1775259598; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KJh+fSdSH5NQ/gboRRLrSOUWnglDImWXDS4hyVsChMM=;
        b=deYm0EtexfFoTsjsGqgm4xgksjfMxlIvBgq8+o75nce/t+rR8scyV06Afb6TH0rUiu
         FGpH05ddw1qAzz0+2cRUFvSAacqWwyBwHedCn1UsvMVWHXemvjSQn4lkGIw2O3CeA8Lb
         T7FmgZoitA3uELO7Xb13JOebLKsy+r1EN8iBedTQqwTrtnmkCAVkwPihIlf2YL4msAZe
         feEK6wnKEVpv1TThgBuPpc1PbVOPfD7/dzTFj58+hoIq4MQXgTi4w2ZoJ7FXX/nxBiRE
         kQPpUo4V6kCVwmbl67NYzbesQptHE6czUaRrfUrC20swRCkclqWNv8+koO3ecG5wuRSe
         yCaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774654798; x=1775259598;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KJh+fSdSH5NQ/gboRRLrSOUWnglDImWXDS4hyVsChMM=;
        b=Y7ErA+it2vb1RzOEsAHsiFYDhW7cr4VHCXqXJvnfoVrBnlhI2yfc7S/qLLebCj5r2g
         9HjvvobQtbMz6KXTSdyzjdmPhJpmcVHXj9bUPxt7/aT8+ltkGSSmVXWkw/i3n431i5O8
         zPCASY0KI3RcpzsmVsQRFOLEH4/ERnzjwipfXXEJapaP6mPk5K3oMofguDp8KHgl/X73
         OKZOgvJCkF8F6s8hRqZ6cY7wxVXrtutRgc0NSkNnvukf7Cr33WgAMdszm0q+nF9aQsdL
         wpT5A9HaGLMy4pxe3MGe6e0sTAU8Bg7K/klxwikr10LSUPZCliMPyM8ea8gRaRuGzZi9
         //Vw==
X-Forwarded-Encrypted: i=1; AJvYcCV1bKQSJzY1cd8oz61abtB5bFOd2VQ1+7ECvQTc9bu1kj8qpp4Z9JF45UHi5DoyG+pfs+9j2YMpSw==@kvack.org
X-Gm-Message-State: AOJu0Yw33ejCEvT/8HWaDRkn0Xbt/mWTp5IhksArhBP6HkL6ajwv1fiL
	d81+fboq4EXGRls87CampYeAgT6/CeehrbgqKFY/pNxiinBAU9zLlvxgfCHTlmc3Jg==
X-Gm-Gg: ATEYQzwamyc9ndxY1L7ZTydD0f9HTwD2ey/HEUCVPOdrFvrL//Jl/Vk344LF75/aZu0
	9jlE6rsq+j1IE1nBqIoWIvW6yqZ6ThTx1kRFxgE3n2M0IPl7dktlnid3koNygykI90ljrqfsUG0
	JpvitM1MrZXKHNMx84p6zK3g07kdOIp+BGamnAZ9e35ZwZI51nBVw2GoE8Jz8FLOlO/cl72dwcL
	OC4b+8WcwJQIfj6hbOJxtMFEyYAQonpZOzI1m3XYwwbMD0rRhJpdOW8eRGWZvDzDo4kQy6mTjCv
	LgoeuJnTNVAvjKwEUHVtk/xxZ+oCN0Cct7fFSKv7Yj4LFNI9bit63DMObhkhpZYLcAWT87/uY+E
	UK06Wjeb4zcdy3ZV6bz1ks67S1Oy0xPRPsL5XxaqcFWNqp7TLz7QIilG3FCU0jPL6ezOL05+Unw
	wDWdnw+JU5SgNJ50RsAnfcEi0Yg4Jubj4Ucx2HjMvUpPXUVUYgHP+u/7P6IYWY/g==
X-Received: by 2002:a17:902:e84c:b0:2ae:6755:a24f with SMTP id d9443c01a7336-2b241ba1a2amr1512495ad.0.1774654797569;
        Fri, 27 Mar 2026 16:39:57 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242642b43sm5138615ad.9.2026.03.27.16.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 16:39:56 -0700 (PDT)
Date: Fri, 27 Mar 2026 23:39:53 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, 
	Askar Safin <safinaskar@gmail.com>, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Rientjes <rientjes@google.com>, Feng Tang <feng.tang@linux.alibaba.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Li RongQing <lirongqing@baidu.com>, 
	Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v3 07/24] vfio/pci: Preserve vfio-pci device files across
 Live Update
Message-ID: <accS5UUyP8Qw1bUW@google.com>
References: <20260323235817.1960573-1-dmatlack@google.com>
 <20260323235817.1960573-8-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260323235817.1960573-8-dmatlack@google.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: m6b5xockgbjgcj55tntpo4pdek8m5fww
X-Rspamd-Queue-Id: A8BD510000B
X-Rspam-User: 
X-HE-Tag: 1774654799-163734
X-HE-Meta: U2FsdGVkX1/Zht5IeKq2F9KZkE5Yl+J0b6V2YmGTbQouX8q/X/0ejXzZo6SO9nn53/vS8snAZrA+O1wUBKO1sT7thPzFTi0oKOh+97YA9GvFnCFw2ae3OEf159eSv3ZZs4GQRRuBF0Ib5MSDFYXTzr9iyfr93AnCFy+pzcj9xIxjdyI7KjIFuya5p1UFeFlLqMj6tmxxQ0c0OsjacLefgvw2sRoExCpfvaPkrbn3abN228goshTdK6sPoAr6A3dbQRV4WQEzNXx28Tne1GtUVCgfXiEPYc+opmf6/zp9EGQeT2SV2Hd7BheNbdc9abKQZyxN99cxc/TdG23oPcxoQbjnRBBV2QuFMaDZUPcGLadc3NU6SyJ3Ei6Jtwx1t80u14wmiSydcuGVra/S+NXUSk0XQN2pE2YzkRXiIeAG/kcPtPBdqyp5IWFalBRsr2NL9CzP8j1HIHwp52W0t26UuvIQe1SehsjtJUFKB9foRyLSsVVgpw0XH3pAID8LHlDmx55yqIhNX/WR8k7aPYU0FDgYy/BtCm1pWi1vbWXasejSZK80fv9eM7+ZROuQ0VV/u3D5obhAww3umAj9yOlGIKjq46qrrREerSVRM9t7w6/6tBeoj0Sb68ZETe7EVbAkt0lm639IOhlqbq31cx/427CwssVN6n6uqYJk51Kjd7Y+XJ/InD4CYDcInoPpr/HgGzyDuXsz0/XphJ3taDo2idq8jl8ZHT3nc4CTDC/hyo5v/MND5oUoUb2SuzYA7OARMIm4QRNOg56aCSI8cNnI7mf7RMc5wdHFNfOVXfNDbZP1dgJ6QdEW+hxPFxzznxNtnxuVn87t8B8PypmF2CLcq88ONpPn0wxqcfHukizZKZOphgrOMIMz9ULyc3Ngr/a+NJD5OaERv11NqpDU2ZhYs/mRneR6GV7M7FMdN3nXVNdTxOZhE1Fk+k8A9kIuu9xpUQ1rm/IcbPHsX2cdoxg
 g2nWBOcx
 EoiY+ubfAk4Wf+mwzXhuaT8NwgMjtCxnHWgkJ/jXY3Chh8k7A1sXbQI3OTkvLJtab4GP0QVpWI5Tqdf4VS8/F0ThK1HiG8vJ+2Cjlw3/HJFpJKpUtOyWMdZ+Vy/wXoh+Hyq6FLvdHwXlsjXkowzizoAfPnzrAUdJUWYKdLBqWwfG30FpJ3e2KILQNhC8R79xIjappmaykhRj3TlcyFdaVLuggMjJ1/n/WhFPWblLNeN+XbbuRME+ACq4RssiJ77Mng9GSkiRjNYkUaAbDjJQS5txeN3cyut2koDF4eTNJkif6Z6nfpRJorga8duecg0HVfu99ChkL/K/GufmmYrB93uPppFIV8wAA+7Gb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 11:57:59PM +0000, David Matlack wrote:
>From: Vipin Sharma <vipinsh@google.com>
>
>Implement the live update file handler callbacks to preserve a vfio-pci
>device across a Live Update. Subsequent commits will enable userspace to
>then retrieve this file after the Live Update.
>
>Live Update support is scoped only to cdev files (i.e. not
>VFIO_GROUP_GET_DEVICE_FD files).
>
>State about each device is serialized into a new ABI struct
>vfio_pci_core_device_ser. The contents of this struct are preserved
>across the Live Update to the next kernel using a combination of
>Kexec-Handover (KHO) to preserve the page(s) holding the struct and the
>Live Update Orchestrator (LUO) to preserve the physical address of the
>struct.
>
>For now the only contents of struct vfio_pci_core_device_ser the
>device's PCI segment number and BDF, so that the device can be uniquely
>identified after the Live Update.
>
>Require that userspace disables interrupts on the device prior to
>freeze() so that the device does not send any interrupts until new
>interrupt handlers have been set up by the next kernel.
>
>Reset the device and restore its state in the freeze() callback. This
>ensures the device can be received by the next kernel in a consistent
>state. Eventually this will be dropped and the device can be preserved
>across in a running state, but that requires further work in VFIO and
>the core PCI layer.
>
>Note that LUO holds a reference to this file when it is preserved. So
>VFIO is guaranteed that vfio_df_device_last_close() will not be called
>on this device no matter what userspace does.

LUO session holding the reference is also in userspace. Just to be
accurate, maybe say something like that the LUO will hold a reference
until the FD is preserved and vfio_df_device_last_close() will not be
called until file is unpreserved.
>
>Signed-off-by: Vipin Sharma <vipinsh@google.com>
>Co-developed-by: David Matlack <dmatlack@google.com>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> drivers/vfio/pci/vfio_pci.c            |   2 +-
> drivers/vfio/pci/vfio_pci_core.c       |  57 +++++----
> drivers/vfio/pci/vfio_pci_liveupdate.c | 156 ++++++++++++++++++++++++-
> drivers/vfio/pci/vfio_pci_priv.h       |   4 +
> drivers/vfio/vfio_main.c               |   3 +-
> include/linux/kho/abi/vfio_pci.h       |  15 +++
> include/linux/vfio.h                   |   2 +
> 7 files changed, 213 insertions(+), 26 deletions(-)
>
>diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>index 41dcbe4ace67..351480d13f6e 100644
>--- a/drivers/vfio/pci/vfio_pci.c
>+++ b/drivers/vfio/pci/vfio_pci.c
>@@ -125,7 +125,7 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
> 	return 0;
> }
>
>-static const struct vfio_device_ops vfio_pci_ops = {
>+const struct vfio_device_ops vfio_pci_ops = {
> 	.name		= "vfio-pci",
> 	.init		= vfio_pci_core_init_dev,
> 	.release	= vfio_pci_core_release_dev,
>diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>index d43745fe4c84..81f941323641 100644
>--- a/drivers/vfio/pci/vfio_pci_core.c
>+++ b/drivers/vfio/pci/vfio_pci_core.c
>@@ -585,9 +585,42 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
> }
> EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
>
>+void vfio_pci_core_try_reset(struct vfio_pci_core_device *vdev)
>+{
>+	struct pci_dev *pdev = vdev->pdev;
>+	struct pci_dev *bridge = pci_upstream_bridge(pdev);
>+
>+	lockdep_assert_held(&vdev->vdev.dev_set->lock);
>+
>+	if (!vdev->reset_works)
>+		return;
>+
>+	/*
>+	 * Try to get the locks ourselves to prevent a deadlock. The
>+	 * success of this is dependent on being able to lock the device,
>+	 * which is not always possible.
>+	 *
>+	 * We cannot use the "try" reset interface here, since that will
>+	 * overwrite the previously restored configuration information.
>+	 */
>+	if (bridge && !pci_dev_trylock(bridge))
>+		return;
>+
>+	if (!pci_dev_trylock(pdev))
>+		goto out;
>+
>+	if (!__pci_reset_function_locked(pdev))
>+		vdev->needs_reset = false;
>+
>+	pci_dev_unlock(pdev);
>+out:
>+	if (bridge)
>+		pci_dev_unlock(bridge);
>+}
>+EXPORT_SYMBOL_GPL(vfio_pci_core_try_reset);
>+
> void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
> {
>-	struct pci_dev *bridge;
> 	struct pci_dev *pdev = vdev->pdev;
> 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
> 	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
>@@ -687,27 +720,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
> 	 */
> 	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
>
>-	/*
>-	 * Try to get the locks ourselves to prevent a deadlock. The
>-	 * success of this is dependent on being able to lock the device,
>-	 * which is not always possible.
>-	 * We can not use the "try" reset interface here, which will
>-	 * overwrite the previously restored configuration information.
>-	 */
>-	if (vdev->reset_works) {
>-		bridge = pci_upstream_bridge(pdev);
>-		if (bridge && !pci_dev_trylock(bridge))
>-			goto out_restore_state;
>-		if (pci_dev_trylock(pdev)) {
>-			if (!__pci_reset_function_locked(pdev))
>-				vdev->needs_reset = false;
>-			pci_dev_unlock(pdev);
>-		}
>-		if (bridge)
>-			pci_dev_unlock(bridge);
>-	}
>-
>-out_restore_state:
>+	vfio_pci_core_try_reset(vdev);
> 	pci_restore_state(pdev);
> out:
> 	pci_disable_device(pdev);
>diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
>index 5ea5af46b159..c4ebc7c486e5 100644
>--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
>+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
>@@ -6,27 +6,178 @@
>  * David Matlack <dmatlack@google.com>
>  */
>
>+/**
>+ * DOC: VFIO PCI Preservation via LUO
>+ *
>+ * VFIO PCI devices can be preserved over a kexec using the Live Update
>+ * Orchestrator (LUO) file preservation. This allows userspace (such as a VMM)
>+ * to transfer an in-use device to the next kernel.
>+ *
>+ * .. note::
>+ *    The support for preserving VFIO PCI devices is currently *partial* and
>+ *    should be considered *experimental*. It should only be used by developers
>+ *    working on expanding the support for the time being.
>+ *
>+ *    To avoid accidental usage while the support is still experimental, this
>+ *    support is hidden behind a default-disable config option
>+ *    ``CONFIG_VFIO_PCI_LIVEUPDATE``. Once the kernel support has stabilized and
>+ *    become complete, this option will be enabled by default when
>+ *    ``CONFIG_VFIO_PCI`` and ``CONFIG_LIVEUPDATE`` are enabled.
>+ *
>+ * Usage Example
>+ * =============
>+ *
>+ * VFIO PCI devices can be preserved across a kexec by preserving the file
>+ * associated with the device in a LUO session::
>+ *
>+ *   device_fd = open("/dev/vfio/devices/X");
>+ *   ...
>+ *   ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, { ..., device_fd, ...});
>+ *
>+ * .. note::
>+ *    LUO will hold an extra reference to the device file for as long as it is
>+ *    preserved, so there is no way for the file to be destroyed or the device
>+ *    to be unbound from the vfio-pci driver while it is preserved.
>+ *
>+ * Retrieving the file after kexec is not yet supported.
>+ *
>+ * Restrictions
>+ * ============
>+ *
>+ * The kernel imposes the following restrictions when preserving VFIO devices:
>+ *
>+ *  * The device must be bound to the ``vfio-pci`` driver.
>+ *
>+ *  * ``CONFIG_VFIO_PCI_ZDEV_KVM`` must not be enabled. This may be relaxed in
>+ *    the future.
>+ *
>+ *  * The device not be an Intel display device. This may be relaxed in the
>+ *    future.

Seems there is a typo. The device "may"/"must" not be?
>+ *
>+ *  * The device file must have been acquired from the VFIO character device,
>+ *    not ``VFIO_GROUP_GET_DEVICE_FD``.
>+ *
>+ *  * The device must have interrupt disable prior to kexec. Failure to disable
>+ *    interrupts on the device will cause the ``reboot(LINUX_REBOOT_CMD_KEXEC)``
>+ *    syscall (to initiate the kexec) to fail.
>+ *
>+ * Preservation Behavior
>+ * =====================
>+ *
>+ * The eventual goal of this support is to avoid disrupting the workload, state,
>+ * or configuration of each preserved device during a Live Update. This would
>+ * include allowing the device to perform DMA to preserved memory buffers and
>+ * perform P2P DMA to other preserved devices. However, there are many pieces
>+ * that still need to land in the kernel.
>+ *
>+ * For now, VFIO only preserves the following state for for devices:
>+ *
>+ *  * The PCI Segment, Bus, Device, and Function numbers of the device. The
>+ *    kernel guarantees the these will not change across a kexec when a device
>+ *    is preserved.
>+ *
>+ * Since the kernel is not yet prepared to preserve all parts of the device and
>+ * its dependencies (such as DMA mappings), VFIO currently resets and restores
>+ * preserved devices back into an idle state during kexec, before handing off
>+ * control to the next kernel. This will be relaxed in future versions of the
>+ * kernel once it is safe to allow the device to keep running across kexec.
>+ */
>+
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
>+#include <linux/kexec_handover.h>
> #include <linux/kho/abi/vfio_pci.h>
> #include <linux/liveupdate.h>
> #include <linux/errno.h>
>+#include <linux/vfio.h>
>
> #include "vfio_pci_priv.h"
>
> static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
> 					     struct file *file)
> {
>-	return false;
>+	struct vfio_device *device = vfio_device_from_file(file);
>+	struct vfio_pci_core_device *vdev;
>+	struct pci_dev *pdev;
>+
>+	if (!device)
>+		return false;
>+
>+	/* Live Update support is limited to cdev files. */
>+	if (!vfio_device_cdev_opened(device))
>+		return false;
>+
>+	if (device->ops != &vfio_pci_ops)
>+		return false;
>+
>+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
>+	pdev = vdev->pdev;
>+
>+	/*
>+	 * Don't support specialized vfio-pci devices for now since they haven't
>+	 * been tested.
>+	 */
>+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM) || vfio_pci_is_intel_display(pdev))
>+		return false;
>+
>+	return true;
> }
>
> static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
> {
>-	return -EOPNOTSUPP;
>+	struct vfio_device *device = vfio_device_from_file(args->file);
>+	struct vfio_pci_core_device_ser *ser;
>+	struct vfio_pci_core_device *vdev;
>+	struct pci_dev *pdev;
>+
>+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
>+	pdev = vdev->pdev;
>+
>+	ser = kho_alloc_preserve(sizeof(*ser));
>+	if (IS_ERR(ser))
>+		return PTR_ERR(ser);
>+
>+	ser->bdf = pci_dev_id(pdev);
>+	ser->domain = pci_domain_nr(pdev->bus);
>+
>+	args->serialized_data = virt_to_phys(ser);
>+	return 0;
> }
>
> static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
> {
>+	kho_unpreserve_free(phys_to_virt(args->serialized_data));
>+}
>+
>+static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
>+{
>+	struct vfio_device *device = vfio_device_from_file(args->file);
>+	struct vfio_pci_core_device *vdev;
>+	struct pci_dev *pdev;
>+	int ret;
>+
>+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
>+	pdev = vdev->pdev;
>+
>+	guard(mutex)(&device->dev_set->lock);
>+
>+	/*
>+	 * Userspace must disable interrupts on the device prior to freeze so
>+	 * that the device does not send any interrupts until new interrupt
>+	 * handlers have been established by the next kernel.
>+	 */
>+	if (vdev->irq_type != VFIO_PCI_NUM_IRQS) {
>+		pci_err(pdev, "Freeze failed! Interrupts are still enabled.\n");
>+		return -EINVAL;
>+	}
>+
>+	ret = pci_load_saved_state(pdev, vdev->pci_saved_state);
>+	if (ret)
>+		return ret;
>+
>+	vfio_pci_core_try_reset(vdev);

nit: I see you have already added a comment earlier saying that device will
be reset to a clean state as all the of the dependencies to preserve the
state for continous DMA are not there. Maybe we can add a comment here
to specify that this will go away once we have full preservation
support.
>+	pci_restore_state(pdev);
>+	return 0;
> }
>
> static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
>@@ -42,6 +193,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> 	.can_preserve = vfio_pci_liveupdate_can_preserve,
> 	.preserve = vfio_pci_liveupdate_preserve,
> 	.unpreserve = vfio_pci_liveupdate_unpreserve,
>+	.freeze = vfio_pci_liveupdate_freeze,
> 	.retrieve = vfio_pci_liveupdate_retrieve,
> 	.finish = vfio_pci_liveupdate_finish,
> 	.owner = THIS_MODULE,
>diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
>index cbf46e09da30..fa5c7f544f8a 100644
>--- a/drivers/vfio/pci/vfio_pci_priv.h
>+++ b/drivers/vfio/pci/vfio_pci_priv.h
>@@ -11,6 +11,10 @@
> /* Cap maximum number of ioeventfds per device (arbitrary) */
> #define VFIO_PCI_IOEVENTFD_MAX		1000
>
>+extern const struct vfio_device_ops vfio_pci_ops;
>+
>+void vfio_pci_core_try_reset(struct vfio_pci_core_device *vdev);
>+
> struct vfio_pci_ioeventfd {
> 	struct list_head	next;
> 	struct vfio_pci_core_device	*vdev;
>diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>index 742477546b15..8b222f71bbab 100644
>--- a/drivers/vfio/vfio_main.c
>+++ b/drivers/vfio/vfio_main.c
>@@ -1436,7 +1436,7 @@ const struct file_operations vfio_device_fops = {
> #endif
> };
>
>-static struct vfio_device *vfio_device_from_file(struct file *file)
>+struct vfio_device *vfio_device_from_file(struct file *file)
> {
> 	struct vfio_device_file *df = file->private_data;
>
>@@ -1444,6 +1444,7 @@ static struct vfio_device *vfio_device_from_file(struct file *file)
> 		return NULL;
> 	return df->device;
> }
>+EXPORT_SYMBOL_GPL(vfio_device_from_file);
>
> /**
>  * vfio_file_is_valid - True if the file is valid vfio file
>diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
>index e2412b455e61..876aaf81dd92 100644
>--- a/include/linux/kho/abi/vfio_pci.h
>+++ b/include/linux/kho/abi/vfio_pci.h
>@@ -9,6 +9,9 @@
> #ifndef _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
> #define _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
>
>+#include <linux/compiler.h>
>+#include <linux/types.h>
>+
> /**
>  * DOC: VFIO PCI Live Update ABI
>  *
>@@ -25,4 +28,16 @@
>
> #define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
>
>+/**
>+ * struct vfio_pci_core_device_ser - Serialized state of a single VFIO PCI
>+ * device.
>+ *
>+ * @domain: The device's PCI domain number (segment).
>+ * @bdf: The device's PCI bus, device, and function number.
>+ */
>+struct vfio_pci_core_device_ser {
>+	u32 domain;
>+	u16 bdf;
>+} __packed;
>+
> #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
>diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>index e90859956514..e9d3ddb715c5 100644
>--- a/include/linux/vfio.h
>+++ b/include/linux/vfio.h
>@@ -81,6 +81,8 @@ struct vfio_device {
> #endif
> };
>
>+struct vfio_device *vfio_device_from_file(struct file *file);
>+
> /**
>  * struct vfio_device_ops - VFIO bus driver device callbacks
>  *
>-- 
>2.53.0.983.g0bb29b3bc5-goog
>

