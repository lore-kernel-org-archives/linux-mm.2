Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDB88CF34B0
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B296B0006; Wed, 19 Nov 2025 08:45:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543CE6B002B; Wed, 19 Nov 2025 08:45:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458F06B002C; Wed, 19 Nov 2025 08:45:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33C896B0006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:45:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC18B59157
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:45:34 +0000 (UTC)
X-FDA: 84127478988.04.F2555A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E8D71140006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:45:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t75TnyXa;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763559933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/NZI204oFTJcibyNFu8kuo/gp+s0LbmGQAfwS/N/QY=;
	b=Vjy7iEbPFZKqg9aU3SrqUCqvpKPfqJLSz1j+nzkXPqxs6hG+R1Lz0tTMST7PXaTIYjAOUG
	nCqZ2PDO5Nt+F+PQh53TMT58yOqaFgug6AeiwWZCO04PkSuLOUn8W7b5hBajEEnsPfpANG
	Rp1btAFi/e5a2dOQ4F5O94WAByZA9mk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763559933; a=rsa-sha256;
	cv=none;
	b=7cNYaH3hH9QSv9GskRJCo11+Tue7xgk0cGD7kBu+rzdOsd7KwoS3sF2xdfhSTur2MFnXnM
	zCgy1GMY1ju2cufAiF2g7q6VJDV0HA7GkvpbM7JwYzXyj6p1kCckU2QxiMUtjZgG2Flawv
	gRinL769GuoVIoDKLbxtKUGZh4Kgf1w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t75TnyXa;
	spf=pass (imf09.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EACF7439C7;
	Wed, 19 Nov 2025 13:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7BBC16AAE;
	Wed, 19 Nov 2025 13:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763559931;
	bh=P3o8RHvDAEnUuERCe1BMnR1YwR+dMea/ZoAi5ZBXv90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t75TnyXaIaLVKA8TVdFOIbUfmeHo4/btOI2oLFyTwx1lCjsveSchI1EBPOOc8OfEU
	 7QixraT3KFGSPUvnTVnRthbFaGMDxNTZWUo5Tcxjf6aH53rpaqGFLVSFMNLDizUd3A
	 QwSiZmvD//HgnssiilLrKxRM4vZ6cmc99aE4Coipe6CFlk1vQCZdASthF5vaDcQnkL
	 MZ/cNswguYwRmgNRRMqMXz+l4ErdZVCb5X7Kve7bjXyjaAi9nArERygQ5n0D8BaTA5
	 3+fmL+QNcnPUcs4ADrhIjk+gdWlLU2nzJQQ5TGivxfxYWknTlcOCS90Tp/YEkddNL6
	 Jp9XI6WLvWISQ==
Date: Wed, 19 Nov 2025 15:45:26 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
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
Message-ID: <20251119134526.GE18335@unreal>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <BN9PR11MB5276BC3C0BDA85F0259A35058CD7A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20251119133000.GB18335@unreal>
 <20251119133708.GM17968@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251119133708.GM17968@ziepe.ca>
X-Stat-Signature: iojt8p3ynifk5514d85o83njw3z5mfsh
X-Rspam-User: 
X-Rspamd-Queue-Id: E8D71140006
X-Rspamd-Server: rspam01
X-HE-Tag: 1763559932-591649
X-HE-Meta: U2FsdGVkX1/s9eC+jKylTWwj/Ys2wtkbqpVtW3y4P7YJ1qsxcH+n2VL3j8OQ4UY0fX2XBjEa3xN5CtpKW29cX6FdkIHLZYfW1ESSx4sPpPY1a4LPWph9LiDuXVmT9OSmWZU3aMsSDH8l7eF4wAYtD1zJ+T6eM/QhUOTAhshpQw6YX+wxunEFuQ3rQ6LiLss1GOkXi2zX49oMWR0PI5dQ5fsjnORETZpweevsl0kCGtj492dtFyjwHoivHEHqiorugGJjaYB84m29PLOSgwuLrP/09LRF1GUf2ITxaHoKje1wZNNrglF9krrTBEfk6nx0PdueYAOlkJ5B9RCSxFV5ZtziRIPAkqmpElQY7z26/FmBYx6ZX3Y2zaUDHbkohAwPojp42ykl8ApQNPXsvUSiLSqFsnUFmEhZ+xZqzwPSrIkNbeu0FIzU4EHMrB7JZSigTtVBCY79mhXRR5+JiVmq7gAzCnWC51EFsWMQBJSuW77+cfPEJXa7zj89ZfslehEyVFz2RN7rbYQL+6qh82R7+xiNnuoMssx3FEm74e4MogBVk7PHlsL6OVnwWxmukG75Tg7lFn/YzEDhOxGLKidNdq0W/5ldUwwCoTXVU/3jU2NynFvqO9a4e3CVR0gHEPY/ld/ztNeWq3QvBTr/nubzevQKLuSbQCHGqiyyCP45TBXmqlEdbKmARhg11X3n699vqD8ZChPPWwTBweabVzKB0zrhdnVAYYSQSLAjkeRwdMYTQ94koZZDHUlSpY+enajLrjhvMMC5d1oC3wIBsJKO4vpdGP3fkfL23DK321UybntNTzzQf4Ylau5J4xBdgBbu0bultuMgQ8/wZTNsGCmuk1S/401KB8aK0jTdI9//aSDWu1gvwyVBdTNc5eQtWoUrIX3VvZrlFZAtaJ+vDcLmUoWNGKIKC+7yoR2mOAC6m8TSx3wwDKf2WKMSq6Pnb+TWELRZRafKJGV2/8++U3B
 5mgF3MqA
 x6knoZPSTPU6J+m/L+GUOyj8Ce2snZyeDxRVp1j5I6IKYudOZhyPe+AVExck+zNwFhqOvUC3g3wC3W2FYw7LvzacQBVkuPemlXsqoMZ3ZbdlftG5nEo3Xh6LPsMwpfNj9b1/E1rYZtwXE00wuYo44YzKCaCq+5eUvVRUcRJwpUp6zwcd7GPCyDq3f8hZgeN5GkimxptTHJGMw/BwksyB2YjmoTw0T7tKFfyfdqlIPVY4MROp9wD0l3tdeNaSu0Wt/+PPHt8nTLFuTViabuOAz298qbM4gMv9vSiqM90q+Jr04iqcO5y5VV9ks2tQiOJiaJ6rmmlca5KD5YzRRz5dILQrqHMLPbInXCVu++gc0T2z+dZMbkSbzi4sbvIjP8bKLugbqQ+xtalyOLF8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 09:37:08AM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 19, 2025 at 03:30:00PM +0200, Leon Romanovsky wrote:
> > On Wed, Nov 19, 2025 at 05:54:55AM +0000, Tian, Kevin wrote:
> > > > From: Leon Romanovsky <leon@kernel.org>
> > > > Sent: Tuesday, November 11, 2025 5:58 PM
> > > > +
> > > > +	if (dma->state && dma_use_iova(dma->state)) {
> > > > +		WARN_ON_ONCE(mapped_len != size);
> > > 
> > > then "goto err_unmap_dma".
> > 
> > It never should happen, there is no need to provide error unwind to
> > something that you won't get.
> 
> It is expected that WARN_ON has recovery code, if it is possible and
> not burdensome.

It’s not necessary, but since I’m calculating mapped_len again, it’s natural—and completely
harmless—to double-check the arithmetic.

Thanks

> 
> Jason

