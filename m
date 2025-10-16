Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22C27CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 06:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8C08E000B; Thu, 16 Oct 2025 02:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7794B8E0002; Thu, 16 Oct 2025 02:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668538E000B; Thu, 16 Oct 2025 02:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED888E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:10:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0E008567D
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:10:32 +0000 (UTC)
X-FDA: 84002953104.20.505D07B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 417AEC000B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:10:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BG3eEDCS;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760595031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNC+Pv8wPGSzgriynq2jKZkAbPBm2TP2bwWbzPM384U=;
	b=x8eiVotrkAHnzoHs3UVO8tja04ZO23gXwzqAdKwh7JK5ncB9Rhs9ap73m1wcAAtYmgjw0n
	aF0b2Bm1IiEyv2ZNcF9pKeZoWm/P0Pwe+vpQ3MHMDnR5tkC74JtP4leAzJmVXTRol5hgH2
	tJdENDxlEtMMMaRcruKCnLDq14YO03g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BG3eEDCS;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760595031; a=rsa-sha256;
	cv=none;
	b=rty+2j0MJF6Lp0yAguH3uZSROS7vehApeczfBo5pEaLYbuUifqX+MMzN0I9Yf0y7cnBZxw
	t4tuwyolQkh1uwpJbcgQjzhkTlyqKNKdBw+X0/O/bVo7XQ6bEXVb7gBN2chllUAGT6ZqfC
	lo0ctfa5WMus2vD3JJe4PSw9r3SPiXk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E092F490D6;
	Thu, 16 Oct 2025 06:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39906C4CEF1;
	Thu, 16 Oct 2025 06:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760595029;
	bh=tT6N7q0N+tYnpCuKuxnxGLzsNtDaUUpQ+9IuABIG9g0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BG3eEDCSI/HeqTCyC/0LCNKBgZ3zo6ECD9ngmXBKIPPl5NBH22Bn7mghAB8et/H6G
	 Mk66piiBKnfchNsu3YfuJzNnwCXFrqb8msDY8Om7bdz82Hkljjp7CPmpHtnH9rNGgs
	 KlMJt91fqlCWGDLVdc6FP/YNLaLQ7lPh9mflRMeup/0Wzsexbxj6A0mkigA65Vzw0x
	 gbAD3ImrXMKJVAfq/R2QbmWKCY7eNvtD8O8jYdRtYFKQ5Hq1PrhccrO90mG8ylxJEA
	 UlVJ3lTR+OmS5SyBhCnebiq7W+a6V2pL6QQLerxSwT6B4ZcH42Z/KxX0dqJOEZ6gTV
	 xAaHdT8g/V/0w==
Date: Thu, 16 Oct 2025 09:10:25 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 8/9] vfio/pci: Enable peer-to-peer DMA transactions by
 default
Message-ID: <20251016061025.GA6199@unreal>
References: <cover.1760368250.git.leon@kernel.org>
 <a04c44aa4625a6edfadaf9c9e2c2afb460ad1857.1760368250.git.leon@kernel.org>
 <aPBwEVJSzezdii1V@Asurada-Nvidia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPBwEVJSzezdii1V@Asurada-Nvidia>
X-Stat-Signature: xfwn7g9aokk5ke76nznowdbu83f3zsia
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 417AEC000B
X-HE-Tag: 1760595031-727609
X-HE-Meta: U2FsdGVkX18fIFIWEyDgZBb9SzdH2I2SqJTOhCXQ+znD2Dqoi0GibSL3D/f/ETn3YX4N806WfJzm3i4zOso+8MaIvjXzH0ReU2dJvHw7Dk2PSnFjQUOsF8KkbaVHZ+x57lb5J3nrdcmy/nZN+Vn7TEQMCBj2RcmAtuMOMov4peabZBviKLrINuNz7+jGdnbC2XBjApEPjFETSpri1Ommm4YeA11rmS5M/r//vcA9vtoeYow8vebmGP6faKeGpnohYx5DzxTcgpUQOMHo4z9FdHvE6moyHoXFC7vjWtWJAsvvnMJ+JOlFu1OH1nhJlUIHkqYhQC9qDS/wxgRIzKOD2h+81marb02sSDUwSnjmKjUvj82R1HUB5/5Hw+gW85N637ysWRVCn+WZrRNj+SxwKwq2UQYTTqYyaGB42VApFnQjsAg5h4vfIlhiTRKCtsRTInNd5fdo/291elYLxKZcSc4OisJqd3SMWzMqTwHzZ9hRWEvUEVwscN3IGLHfe1nn5LvRJ+VfMBKknFpQIOn1uMgHlY1R4N4q73KQhj6xkvEsAVhh1XrrxKGTomvxodHZo3Cs4uA6lHU9FtoEa0kwIpnkj2mU1rb+CFpKu4qi2ZnEss9YysmAI+aYde1HppytMJsuBT59iryWL2cUNicZenN1Athdw3tg9loaz89+d9tyClDHlftgOEWYzvBETiyyc4LMQTX+xbgHIiIGuvpmJOXliExsR3S6vupxpP/A1HOJe7MsRfCpsg9RBZVwl+weL2yeyiNtotcbH3j8yXqWmXo6gwhc6629x0LKr0DQAN0AS+b5I19IIr7BsKvxV1KiwfhYjY6Nr+Y2WUHRQjbCDl+d0MrNBb7JlY+jT04yWZOR/E99HuzavP6+Dwp56Y3D/SWEtlzvlr7RKywFgFUdIXcoMptC2+ANN15+OzgOidk+k8ExT0k1N2KrzjHBuJse9Q8ZKUcSd2jTLMZnz/8
 alMT+SCB
 KaE2DpVNXs7qse0ZGi7FpjSfJaDJRMMQpg+JrD4uWJqrIiqieu7zzHV1GoA/F+BCP50Jwkj/MMuTZT9A4iFcfYzHkAx8CfUycjnukoCANfZ/gB55P/qNsUKGKyJI33KA5bdJ9zG28vQksCOPw5O7WLg5/yTyjDuc6yHeCEtXO3DoHho7rxtnr3vBTN+jEqJYoL8SLj0QLbOxyUc/mc6hD2+vQofzMAdNERHD1K/6UisHofi9s8i7w5L/P5A52T79zmXHt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 09:09:53PM -0700, Nicolin Chen wrote:
> Hi Leon,
> 
> On Mon, Oct 13, 2025 at 06:26:10PM +0300, Leon Romanovsky wrote:
> > @@ -2090,6 +2092,9 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
> >  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
> >  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> >  	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> > +	ret = pcim_p2pdma_init(vdev->pdev);
> > +	if (ret != -EOPNOTSUPP)
> > +		return ret;
> >  	init_rwsem(&vdev->memory_lock);
> >  	xa_init(&vdev->ctx);
> 
> I think this should be:
> 	if (ret && ret != -EOPNOTSUPP)
> 		return ret;
> 
> Otherwise, init_rwsem() and xa_init() would be missed if ret==0.

You absolutely right.

Thanks

> 
> Thanks
> Nicolin
> 

