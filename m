Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 657C5CF34A1
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB726B0012; Wed, 19 Nov 2025 08:30:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAB836B0030; Wed, 19 Nov 2025 08:30:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A966B009E; Wed, 19 Nov 2025 08:30:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 96DCC6B0012
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:30:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4425258F9C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:30:08 +0000 (UTC)
X-FDA: 84127440096.03.AB1D647
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id AFA43C0014
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:30:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CJmkRcmE;
	spf=pass (imf10.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763559006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulGpNYQnSvgmpTjzN1a5zt6/Vo1Htjymkdyk0Lii2iw=;
	b=IpWj34ZRV0lwwt/Rvv6t/Bn/CkIbH6SUnp02Ph2eB5/BIaRFGs1MpHMI2kMKNDXrmpFqRf
	2GuIu+DMKb2xnw9bamsreCSGwN9ZNG6/Zm4AVkq0U6jck5RSu3whHPo2nMwxSirOr+IDfi
	QRT4+i1dkMLjhO+S9xepUDcyjmtRKv4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763559006; a=rsa-sha256;
	cv=none;
	b=vFXei+ZTtffy2Fv8asyDqTudtruDgXzukg9L9Khsiy0bfVO24orpSOuHFpiTe58b20pTjW
	UQDBZfH6oinHFm6nrNr1t/XfCNySAyx1+LGqNq+0rE5PBOHnOJ+bzAXJ/8c0FHMU0Douep
	5R0cvYWDobpjZomcWpiWKlvDYkitwDY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CJmkRcmE;
	spf=pass (imf10.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 26D4560123;
	Wed, 19 Nov 2025 13:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B920DC19425;
	Wed, 19 Nov 2025 13:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763559005;
	bh=T77xD4ouQwJfrrfoYJul3nkxhRgI6f45RqfVLeuXla0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CJmkRcmExDwPt0NuCANFi896HuCFEIGU3LYAoLvhl8S3uU9mfBypEzVSr32GsqZy0
	 9/i6r19RZmZ62wtupphqnAO8hbyri/wPrlx+2egmQAVVAfXzAjAQg9//PYFGan5bni
	 pk0qcg+vRudcykukDUhBBIgqjiqJBtVsRDmSGRqW0pz5Gglk6LGSk41HQnN10/vOll
	 y837YDb/TkXoHX8I8N3jo+MHBgeNPV8Cz170FjUyldCJaY8TGh2bFXWSLULpw+FO6d
	 eb4+355odBMqKRZiIPwYiwF+iwiQXKJMUxv42Leegovr8lnDq2Mv1Ats+WCCrLVsSJ
	 k/AyOs5u/QaIA==
Date: Wed, 19 Nov 2025 15:30:00 +0200
From: Leon Romanovsky <leon@kernel.org>
To: "Tian, Kevin" <kevin.tian@intel.com>
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
	Alex Mastro <amastro@fb.com>, Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH v8 06/11] dma-buf: provide phys_vec to scatter-gather
 mapping routine
Message-ID: <20251119133000.GB18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <BN9PR11MB5276BC3C0BDA85F0259A35058CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276BC3C0BDA85F0259A35058CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AFA43C0014
X-Stat-Signature: o1m4h5uaioeezhfy7cfducf4nqzam8ee
X-Rspam-User: 
X-HE-Tag: 1763559006-965523
X-HE-Meta: U2FsdGVkX1+16J1r/skBNdq5+k00hAJK1jfVskTo2IiMbFgcG6H1QtbbBslnE8pTrqdADmpEvtP2lnUzsTyWYt4yJ4NzotV8ylptKJoYY5nYfFCTmD2rAfRkH1TlA8Byj/73XYoYD3TfH9JmGpc0AsxJ67wyiCf0ej66Zy2Zcj0dJj2yt5m20Hdjam7Aze2CoMIXWVtzrFd1T1pw5GYI+ws9UwnWj4cW1BnZtTJ0N6QXhNy8+/nnn52JypzMwSsCD8jrCh5v3Uo98PYWJPS7eWK0YqvrkuqIp7K8Q9zM5xnQ8P0KEnpyuEdJJd8k51lZjd96AZyIRQgSZfxyN8Qx154pzmzrjcW2iFD7TiKzop//4UtfFIJna976lhMN1U95/aUWwOK4jztprqGvwM4ky/AUIZSbwJp39E/uPXq+rZDgfg9w2EYK6yMjcOt+58SWoaGiTdp5nVQbFR1tMl17YaMe6TfWbbAJil+2bIePniz+n9zoo0wZPxEcpk48XI+Sbnya5pzdsrv/ydF7bMhP0rVeEDBz3VvCoTDzyImF8zbNrINL0waXLXvrbICgHuibhTdQcL1C+Gg9Ue3PURBziP2Bn1oaDEf5i+JCcv/aX9NQNY/XQFdZl9i/M+9KgF1WMuaIpsBcaj713ljEsvlyAaxuauNW4p/rGhk1RRA2PTmxvPtIJJtvJMXuSx/1cvJYB0WJpFznpX2RiiABvfY+HQRg3fP/wG/0AS72Pnth4Z/ELl1kwsjsg6+6v1N7So8nfuiBhR/NZg/RD7GoCH/aW6EcsWG5Z+IQ/20ciOmg/Ygf1ag9bFGz8RmnEMD41L4ELn+UWdyBc1Q4IfiC6Bn+6KvQNhOuGkqsV1cjtzpFT9dU2f69dYhzhhaBeKP3eon6m7X3+0hzKsqXLvHAWmBCowvxiv7pN3jFrxuuElTjXs9hlSsRx2uhfacsDquFrM0Dy1MvQTxpfwn+VE/9xyN
 5fXr/Qxq
 567tjuRw1mM1NfzJGBMzz2cM3X4l0X5Fb6wl5VEErp4uncFwF7DCN88fyQxERlT86AnUR0hTK5qBAbifDBlJvtL13Y+2jbeT+nea8epYnJcbap+RxT9Id80WG7YWvhlxVtQEHGsabNlpERME++KYgSugeoFcBqVip/yatvzb7nYYJ0Nd6v0dPglPNQ0OSg6V7ZToFvzZ1o0Dmiq24HIlYcfDuK12XZlZjZv1vlyk0GG8gBWw5oqeX4wwiiHFbm/b/yTG+HlBxdmgFbPLy9VYFWb6NueSoGTzeLGmt5HFdhXoXPOhl6iTT+0cKmwxTEeTL6QxZPFXz7HDlrpmHuMKdh7Vbde8RUtkdlhddd1SlG3xKcOyuTzQiCGUn2Yj23OaPVDF9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 05:54:55AM +0000, Tian, Kevin wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Tuesday, November 11, 2025 5:58 PM
> > +
> > +	if (dma->state && dma_use_iova(dma->state)) {
> > +		WARN_ON_ONCE(mapped_len != size);
> 
> then "goto err_unmap_dma".

It never should happen, there is no need to provide error unwind to
something that you won't get.

> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Thanks

