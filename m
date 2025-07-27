Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E243BC87FCE
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 06:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A0236B007B; Sun, 27 Jul 2025 02:02:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3511E6B0088; Sun, 27 Jul 2025 02:02:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2648B6B0089; Sun, 27 Jul 2025 02:02:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 188516B007B
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 02:02:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A098B80B7E
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 06:02:04 +0000 (UTC)
X-FDA: 83708998968.03.E5CBE4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 039BBC0008
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 06:02:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V6ve41Za;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753596123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8DA36BHF/YB++Ap5z0xEFF5Xn+TnvFqFaSK7QeSvxo=;
	b=EFdjY8So3sGyvAcTDK8+osCiS2cQhLdpujr9/60UhSGtI3YzALUcVEcaW7hkNST/G1cs9O
	eFmUv2g6CH9qxWyXAJdTWSbHSHlFLzUhqfH0h7BhE0PcR7n5SREqTaTizIUVN08/e3VrEb
	7UKAub51dVXWc/SAHQF1IUcM3nlUklA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V6ve41Za;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753596123; a=rsa-sha256;
	cv=none;
	b=MntDbA5BvXp8brlDlebH1O9VnlmV/Zp8IXurC4LwhN4WowsWuDLzun7Tk5I5NwiSRfY7Hr
	2AlGJR4OzGyDI34/bMsAnTteyELh78jXm2DTAsu1c45EiD3HzBKu7ZMcdRPKF1p28Q3+QY
	O4WfBVUPLV3C16x4DT8VnMtExgPkZj0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 18BF9600AA;
	Sun, 27 Jul 2025 06:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD49FC4CEEB;
	Sun, 27 Jul 2025 06:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753596121;
	bh=WWhFp00ABgRKsC2uOYcHpFSsCkih5U8N9S1/bm3HEt0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V6ve41Zak6FqYGIRPWdvNdwMfPpQHLnn/G1OPBuETwI5ItOPWDUXA170k7wALPl9R
	 LV5UmgOfKcIWXOXmXNXDvg2oKFa+MPKmb44xV1RXo7qlaGXjb5InY7RkNyHDuLXjqv
	 v7oaji5OpdebPV9NK4boMVjMbo8R5vodWngmOQReq+LAf/Pk1twkeVnZKn4GwEkpsz
	 PkdhJo7R927PwoGPB1NoHxVC+twjz6EsFo0Rd7txaywXaV0GllSt+nRFydY1QMhg/W
	 vOdJPaGwLvhMTWNq0jeRRpeR4GCWuudwZ02zlGFMIBWl0C4X6O3koj2oIy0WdW1VQb
	 dL4srFTzXh3fw==
Date: Sun, 27 Jul 2025 09:01:57 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <20250727060157.GV402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de>
 <20250724081321.GT402218@unreal>
 <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
 <20250725185402.GU402218@unreal>
 <a749c502-7794-42f0-8f86-163efd4640b2@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a749c502-7794-42f0-8f86-163efd4640b2@deltatee.com>
X-Stat-Signature: ybwzwzd3nzyj1nusa3wmkmpbyqfh1ws5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 039BBC0008
X-Rspam-User: 
X-HE-Tag: 1753596122-724862
X-HE-Meta: U2FsdGVkX1/20l3QSzCcHgCUbpuA6IcwKy40CJ550gZZACVd0dAROfPER9WPbM7o0Yet//4/nEnFXzhNu/GqC5c4YZ3cIOrt4y5lk2hUbN9/bhuk3rUesNa2VJIKx6ITkB6wjdvMuF/88FitkQB2UjLVIInhnO1hF14Oh9anfdsAUvdWga8Ewn6UESgw8LYzyxxiuAkg2rgYKqZLuQrp0Bg2irmrgCRJhP+0FYDPY2Y0lQhkbpYS+lisR+PSNGuSGRI2x9NJ6LbsA6HAnwLMuDky0xCelOPU6Kr2vKLhm7DTqbHPKR2xVcz401c1iotemCXKn6leqaEfxkC5yS5v/ue/7mT2XUXL3LsdKkFQp002TFoBpaoIUcsPTFYo0y6N1e+SmqgD8pS1saqA/B+lR8SPRs7j5RECeIHCMgAjx04oqEs9lh3i9+Ox/DdrMgu4zlZAgGm/R9WJlbCp8QsRrY6g0HJRDzC75oMMseopWogCCDLpirVIsIngeeL2MLGCONVKzA49vcazENCjzGGZZiy+Aru0UBrEtVwNZgIAta3JFCqX7Era8XvMRatvYUUmxeTEa/mU2p36UCIas5w4jMPFPGqG4UrZia6SE2GBDjUYWahZgYR197mpWqLDVSydLK6SavYHJmb6q7mOqT/R8v5T7CpQgVYTsEqqETkehYGcai6Ljyi32J4hY4VXfadxyOeQcSLAHeQ3+DflSBcVmsvf9VbqzHPCsWnWPmdoIy9+FfVlIhe+YfggFKpy7ZfoTSa3ysMS24fmV88dOd0LRFr6WLFYma9ZNqpeRjm1JfBAhzEBoTeCMCH3k+VKn3XMGBYEpNYM8JRNXNxLXjr6Y12+RIaW6UEpZhCvbRQ8GVETBMkNTxECxWuwJPBnBZQefSNfY/9c4C6GYvI9GHO7AeyNYk23ZxBVPi8tFL2wVXP1IEcDSD4/V5T9KygSjmcO0V+kTxKyvLMxmCE2Yvy
 /24y2uY5
 tNirc+/Bb8V7R3Rtju0g/3GcTwUoWmtA83Jc7XvMniJ/4r6Y/n7bl4i6jVdmHq/WmQfC86iPvPdaDx5JLWFXLJHZN8FK4LSeawfrAqIWNZaid39ltr9vUckHo77HmB4mlM6pbtYDr4u3kESKIHsyTN+r4Gx0J7bIhUWMPzTO81JjCogw3SQPh+kIwjCZKC1bnEf9NuZxBhuE9y2XbT2v6nfIeA6hXsqktlb5nqc1PrvsgREYwb4CNgxFqcFnwFUKU6sZ1G8bMXHGctwfcLdEgnb6G4j0IFXdmSbItEay80nDHlU4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 01:12:35PM -0600, Logan Gunthorpe wrote:
> 
> 
> On 2025-07-25 12:54, Leon Romanovsky wrote:
> >> The solution that would make more sense to me would be for either
> >> dma_iova_try_alloc() or another helper in dma-iommu.c to handle the
> >> P2PDMA case. dma-iommu.c already uses those same interfaces and thus
> >> there would be no need to export the low level helpers from the p2pdma code.
> > 
> > I had same idea in early versions of DMA phys API discussion and it was
> > pointed (absolutely right) that this is layering violation.
> 
> Respectfully, I have to disagree with this. Having the layer (ie.
> dma-iommu) that normally checks how to handle a P2PDMA request now check
>  how to handle these DMA requests is the exact opposite of a layering
> violation. 

I'm aware of your implementation and have feeling that it was very
influenced by NVMe requirements, so the end result is very tailored
for it. Other users have very different paths if p2p is taken. Just
see last VFIO patch in this series, it skips all DMA logic.

> Expecting every driver that wants to do P2PDMA to have to
> figure out for themselves how to map the memory before calling into the
> DMA API doesn't seem like a good design choice to me.

We had this discussion earlier too on previous versions. The summary is
that p2p capable devices are very special anyway. They need to work with
p2p natively. BTW, the implementation is not supposed to be in the
drivers, but in their respective subsystems.

> 
> > So unfortunately, I think that dma*.c|h is not right place for p2p
> > type check.
> 
> dma*.c is already where those checks are done. I'm not sure patches to
> remove the code from that layer and put it into the NVMe driver would
> make a lot of sense (and then, of course, we'd have to put it into every
> other driver that wants to participate in p2p transactions).

I don't have plans to remove existing checks right now, but NVMe was already
converted to new DMA phys API.

Thanks

> 
> Logan
> 
> 

