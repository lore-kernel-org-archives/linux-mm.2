Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C40ACCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 15:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C558E0009; Sun,  2 Nov 2025 10:01:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A042A8E0002; Sun,  2 Nov 2025 10:01:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919958E0009; Sun,  2 Nov 2025 10:01:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8B98E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 10:01:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3391D16086A
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 15:01:49 +0000 (UTC)
X-FDA: 84065981538.20.5D5188F
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2742040016
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 15:01:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=TDBBXL62;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="1 LVX56y";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf12.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.150 as permitted sender) smtp.mailfrom=alex@shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762095707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0d6OEFnYJ2V3XAULn/TZmZlWcybfhiFmQJo6mbyVvXM=;
	b=g09/qBsiq2oYX+wVUy6vexx8yLSkGePcc0yy0S/LNwSUVME3PIAiqiRw707cVXhdgZRgbd
	0ID2+2qMWV7Wcbc9pqaXNReS+//vZMsJIPg6ShmOJRmWHhtjXcc4xmR6Z9fjzM0zpnbX0i
	AuaKdUaxsC4FGOPCn3Sqp814OUWSzYU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762095707; a=rsa-sha256;
	cv=none;
	b=lrymon908cpdnHgSSpEbF4Hoc4CO+MvIMFSTUrrMCcvdAqX0ZuEKkita9ioivngD01Py4t
	/oD+v7BTzq+N2XmDnPu3dAEm/0XBw2x12YU27oJeYiR4HQBiZ7jJL7wdGzx250OGAspWcO
	wRbRObhIX5xR43QF4JKavxDIz+SGTUU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b=TDBBXL62;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="1 LVX56y";
	dmarc=pass (policy=none) header.from=shazbot.org;
	spf=pass (imf12.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.150 as permitted sender) smtp.mailfrom=alex@shazbot.org
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 5A52EEC00FA;
	Sun,  2 Nov 2025 10:01:46 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Sun, 02 Nov 2025 10:01:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762095706;
	 x=1762182106; bh=0d6OEFnYJ2V3XAULn/TZmZlWcybfhiFmQJo6mbyVvXM=; b=
	TDBBXL627U62EbSvE9rFypOnDsF59crhLTr4X2QKEvliSdqCxPjUyGG2gU1rfyy6
	KFAxwA1gTIMopje4193uHXPRW+ufV9dJZdKqHBRfwc/N4IBiaOR98b4eAXEH0znN
	TGEm6RPZFvDOWz2t1+XG+tu8SlR7C3lIquO0xndqYyPCLJ47ZApUOwrZ+fL1v05Y
	UO6kQ6QwKw94v0SpG2cVHhgdcGhgAbGr8yyVtoD/NNB4QwWq9iuTPgKYtfwDhnMp
	zc4DNh9MkV7/Al+RIrs1DZduD58Ug0u+UsN5KgH6wUZEtxvKc9YwIHTm4hVd6tSs
	0CyeiKlKqOJyqaNciuiXOQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762095706; x=
	1762182106; bh=0d6OEFnYJ2V3XAULn/TZmZlWcybfhiFmQJo6mbyVvXM=; b=1
	LVX56yfNDSpIjbdRvoJO/pVaXhalPLO9zDUW46RhJ+NIFwjTzsxKz0U4lLijuDiE
	/J3coBRe5aiRdAgOPuppxezWF1Kn0vGtaRJ50DbviHDspFXvN4/CsZxDPYFdrTQE
	rQTnMDPaU17wxuuSeRSLCIFoTsQyLhm25SgJgE5MCtd6olWZ3wnfxKjXIlHhXu8w
	AAt1cjfsRLEfHZrrZDRyeCx3bzQMm2DgNgFc3x8D1rq3/SGQUf0gVyKY6ZUAHtAk
	GMrN0tWn0OhqQOH1gi2ycbisP7rKgjkeGTT6oLypSJHXOoGRXO+1vl0LQkXCAw2d
	qLCgYO+qQmzuvtppNv+Cw==
X-ME-Sender: <xms:V3IHacICu8ulgNi7o_gOHA7n7OIXpJl_EkrwhFpTuoWMNbSElXRs6g>
    <xme:V3IHaS_eEi56epCAR71Ow3AZO5YiCeI-oW6OtskAXSaFLFE3lJ3Znpd7T6hKXX39l
    jB_EqBTEDIfpaRz-GdwttQNDa_LzOaDIwPhNt2bHOF7kJ6YFJwVHA>
X-ME-Received: <xmr:V3IHaVpqiAR7FIyLA4s1kUh8xeOXyBaoUionVfff_VNmwkaMImllMw6SCTs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddujeehheeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeefgedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheplhgvohhnsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopegshhgvlhhgrggrshesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhoghgrnhhg
    seguvghlthgrthgvvgdrtghomhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrug
    hkpdhrtghpthhtoheprhhosghinhdrmhhurhhphhihsegrrhhmrdgtohhmpdhrtghpthht
    ohepjhhorhhoseeksgihthgvshdrohhrghdprhgtphhtthhopeifihhllheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepmhdrshiihihprhhofihskhhisehsrghmshhunhhgrdgt
    ohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggr
X-ME-Proxy: <xmx:V3IHacPvm6yYAGFkJOoCwJMSLlRkDxe2mP1wwPGKFs_yQdMVw0EBhA>
    <xmx:V3IHaXrLQtlZj7fWGRlOfeH0EMNmKki9CCwP4XF51mbUGiN7MdHcbQ>
    <xmx:V3IHaTinpkeptwnvtlt4p2ISS1nkQs5QM83RIoLIlJ1Tl7W2DA4-lA>
    <xmx:V3IHaY2_kf5P8v7ucB2Tj-fdZ8lmkzXzEpiEchjKzUpwizU-U37EHw>
    <xmx:WnIHaYlbGcSJfLIFOTNM9Y5mg_T2bF-aTHDN-65hDt2_atGb1QiAIi8U>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Nov 2025 10:01:41 -0500 (EST)
Date: Sun, 2 Nov 2025 08:01:37 -0700
From: Alex Williamson <alex@shazbot.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Krishnakant Jaju <kjaju@nvidia.com>,
 Matt Ochs <mochs@nvidia.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 linux-hardening@vger.kernel.org,
 Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v6 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251102080137.209aa567@shazbot.org>
In-Reply-To: <20251102-dmabuf-vfio-v6-10-d773cff0db9f@nvidia.com>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
	<20251102-dmabuf-vfio-v6-10-d773cff0db9f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: g9wzukpzccy7dss8rzkiimmrhhi36ds3
X-Rspam-User: 
X-Rspamd-Queue-Id: 2742040016
X-HE-Tag: 1762095706-520163
X-HE-Meta: U2FsdGVkX1+Q52Uxw/mEgPJJCYVHme+k4vXEBTNKzzSZNo/FpYLgw25NTBk786DgKb5YcQA5T9StWeDj6YQuc+8KNvIakfpl/R6uraTWNThkAL+w0xcKdQEBv8TNl/85NHMItDa3dXkKRaoFekJE5ErIYf/MhpWaHQ5ZWslCuJrYkzIF+SJ97YvehssxmS/5wqwPUoKUUDurdRYyAcO2MFId+farE8glKXKFmBvvGQ4PGpPuRPSHLOAc4gWTYydhdtB235XcULE8vvs09igieb2PFlzRe4fPI7hr4OeApW+1UfMXWmyslA7YnaVVZS94I3dm04O+1e3QwWYeKt05TD3Nts3ExaxctGgF60rJMAMLDa//9FQMXIKUSxKZzJ3/CLvaUixXQxmM0gvBR3pzr+XonB6bVN9d30DJwlPFYVjvl+qqOcyXFy1neyBvllRSrot6H/0uTVak2jfX6KJVJFUCe99iwmiHn88ebQRQF1g/PFWRy/RErLcM0k4y1CI3RqhQd2+f9+3eub6+zWzubQJcmTzb7CCxiNKwOd/BEiL/xPT1WWuAW1qpknPafrAp8/OT2q7d9ViPxnwkobeVGiQ7k0uE3qeuXb3XZs0KCjOizd6jcKYaPYcxFcuoIE+HikG1GDTzU3lgtCIO7JeF8YN/5TItFpwCV0QE2YHqOe73gI4ZlVU0VCuu+BWh5ZpQ2+DFned+V0cmH/idPLEhb9Wh+dtJhSGdnXVRBG8BqWS88rcgn7llBMW2xGA4belw3OxdjtUQ+dMxuqnu6OqenpRQDorAInoGhzMb6KalLaSNrvnuVNThxA2Ek07w17j6x7N32SyCaVdNRY6O1PtpPE89tJ9Xg3X0y42nbRTmJ2kSYwl0cJDPolM4zTPbVMbVs+mI4hQnMetThSv1hBUiWMsDg6egWcV4XRAX+XtQbUQVhIW1ANTOkGnRYGuEv3tToxA3sgMjKnK56DRwBfj
 Fa5yzrUn
 ggL5OCgHlC11buQJxosfYdnMy9k6TrMWwOOQESXSMkkK51Upu0Uf2riE3TIOroFnDAG6U9SMlqs3jKNc2TLdxBXDD2CPMmMotNjvtKu74tYLZxWYepR2vaLNN3YrETKsvtChcJyJ4BZZU5uHwOMHP2WDxswveo9AUklE6/q06fo6wWM3N1ApUTz0G5RJUkgs1ePb+ohqSTrwms+ozpVHImJiIAJKdI13PvpiBGP0IsPJz09ntK7T2WCt+/0mpLFK0EVtFFGCDp2zcPeZLDPISrVyxD4DjXDMtt4vWe5NqXW5P3hGGp3l9qqkmoAYjkuhBMeFN1MzvvDfHVfsWngAxQEzeGpqooNuLZZnTKSKaqPoDSayiSBj4RGextZiWxCvEhUFCbCYWvQPwp0s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  2 Nov 2025 10:00:58 +0200
Leon Romanovsky <leon@kernel.org> wrote:
> @@ -2391,6 +2403,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  				      struct iommufd_ctx *iommufd_ctx)
>  {
>  	struct vfio_pci_core_device *vdev;
> +	bool restore_revoke = false;
>  	struct pci_dev *pdev;
>  	int ret;
>  
> @@ -2459,6 +2472,8 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  			break;
>  		}
>  
> +		vfio_pci_dma_buf_move(vdev, true);
> +		restore_revoke = true;
>  		vfio_pci_zap_bars(vdev);
>  	}
>  
> @@ -2486,6 +2501,12 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  			       struct vfio_pci_core_device, vdev.dev_set_list);
>  
>  err_undo:
> +	if (restore_revoke) {
> +		list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
> +			if (__vfio_pci_memory_enabled(vdev))
> +				vfio_pci_dma_buf_move(vdev, false);
> +	}
> +
>  	list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
>  					 vdev.dev_set_list)

We don't need the separate loop or flag, and adding it breaks the
existing reverse list walk.  Thanks,

Alex

