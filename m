Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6ECC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 08:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60596B008A; Tue, 29 Jul 2025 04:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35A86B0092; Tue, 29 Jul 2025 04:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A727F6B0093; Tue, 29 Jul 2025 04:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 987AC6B008A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 04:40:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 44BF71D9234
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:40:02 +0000 (UTC)
X-FDA: 83716654644.08.2AC823C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id AE2511C0009
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:40:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M5F0RFaA;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753778400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6zU2eAU20NxxNc2u7uKj/gmIeCNNp+9/97JxBndC/Q=;
	b=25y4HOnz0Do4qAH9jv/jkTTYw8CYvLD75X2bKYzRcFttzVD56M8gO/5v5+A0WwXczl3RuH
	oOOl3PmtVI/tNaMEkAao93hDl9/X9PsjMAIb0qT2Z0OmOxy/WynSkvlWFBezQpdHZZmGMv
	MjoSWVnCc6TBKQuJARlpKfvA5ip0/RM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M5F0RFaA;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753778400; a=rsa-sha256;
	cv=none;
	b=oHIvLK520FrxD8fwTICs2uXId3BJoAJAgw+UGyyVW7YqS4dJ7l2jnsebWCmunJ+CrIYGzD
	zPNxA+vCwj0MQL9XvXO6PDAILvmTddqrvB2loxGroj8EKhjskd7Wtsq2HcFh3jnWAOC/+R
	Ecp9wP9ATot2LFOqSfXpUDkUVLf1Kl4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F0ABD601EC;
	Tue, 29 Jul 2025 08:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8928C4CEEF;
	Tue, 29 Jul 2025 08:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753778399;
	bh=OwIYfsDVT+NrTf9pe9SqTHnHnwWkQ93t/xB2WubT90E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M5F0RFaAnIV1InpC5Z2ni72wX3Gt2VxXzbhksr3xOJ1TeTRCWQ0u8eCBRDawTegSU
	 9WeyNAVLruaM4v0e5fxxVTwWe3R75xM9uuxh2YRgjFTScwkMi8pG+5t6Mg20IKrxGB
	 NGcLT9dJY0mpUgWIP5dXln1PJIrr26Ba2JLQhTz2o4sB6ZuU1tih414TMIIriKtVb8
	 oEvkOHh7OxqhOGrJbvZiu70ODXucDPABU9psK1pm3OKH5psLmA6+IVsT7RRXq5S+Ju
	 8oo9d4NqyKlt/4eREWPutcfL1Jy1y7Tg38lMaB21tJigLyzQrhrUCKCq9BrO4s6YFz
	 3z5QK7qlk7Drw==
Date: Tue, 29 Jul 2025 11:39:54 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
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
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 09/10] vfio/pci: Share the core device pointer while
 invoking feature functions
Message-ID: <20250729083954.GE402218@unreal>
References: <cover.1753274085.git.leonro@nvidia.com>
 <19f71a0f4d1a5db8c712cb4d094ccf2f10dc22c5.1753274085.git.leonro@nvidia.com>
 <20250728145553.53e94d49.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728145553.53e94d49.alex.williamson@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: AE2511C0009
X-Rspamd-Server: rspam06
X-Stat-Signature: wdjgmf9eesf7f9opkgrxswr3g43akr66
X-HE-Tag: 1753778400-650571
X-HE-Meta: U2FsdGVkX18AxTkVFZ+zjsLj5cfEfdvtBJ27E/vHZ9t2EfI7dUI1ijQFTA9CmKNYrnODeyoQ5a0f/ZhPxLN4hPXZd75T6jG4MkmrS/Q1663hNOMJKZiBJD5TT3PIOIcwhyzhMjwpj+d57KfklSuuVo9+MZD5kSpsSG8Lg5GEF27XipkNZlUFJiib0ZfKIlnAJu2PuDAIX/5WwMiCtWn3v7qrXkwKluy4s4AbVEdOrag1HD0mKuGpSWYHQgEmMnfSJAgqUJx/NzrvSDa97kHn4fk3PsJ2HUa+UT+EfbN6AJJOVpkTeQT9u2/TKDtNv0+1MTEPOKO0cD8+7n1YUiZIPxphxq1DGdorIjPp1w6Y+kxXsi7B0n6/iLXQfTttq2NiLfQF0/AJ1EaIOM91sMidOEGFHxcyU7ypHIFriD76pNnAfjvXic1AOpeMEqzNh0iluo1ovE2ArAe+rl95H5+vc8GMvXcop3YNDckTRn2J51luPpkdp77jOn32zqhxhd0hCJA+sULpx0BOM2c+3Aq6t6A2qok9jC/VkTm1eFbLfEp3poIqHykncc6nxqFaKTtSUDQrgoXJEq9Fo/e/0J3EGDotC5pmzBhYGP/3xCC7pKhhnGwy26d0LNPjEheAl3p78MIaJK2BFpIQBnlOW6m+24b/PitrGk20H05tt9Wve1M0D86y9eDacWsLq59nbkgE5XBjNj5jsjOO4OaWqVu8WV0AogOZCk8iiKqelfIaexThjElOYM78xHy3bHYjYF01vVIZnqvWPrqi0kPQWUb0kZB2kA8qstk0loy1zaEuGLF3qViLolQzyfMFNTIdFuG9arfufiJpIGDsMTHjyo9v2HkcF7h5oj5VbVO7ZqnnJCzQuTgnF4dJHKmj212wTwoXl5GWt8lxPfh5XxaK8Ot7nj8JrE/36vFQxpZYmFykNPZYfkfDHzxjULynYm0nX5QUyXCxWG2gJxM9OSIGFWk
 rqBYnvqP
 fEtaLavkdr5vizFssxG0fvI5TYTskaHKU4CwRYeXBoaljA+ArX5a+3ba04niczBfQj+7CjvfxYaSn4QlJCdEdA5w08HYymu4RsJ4Q9ZidBCvjVc9+cXcR2uuntr1hkVFGfFPUGHOIuJnaUU6drSieil3nE63UCDHBBHrPyGcPwm/zUML1/C1EiGaTMuwQ9CQ2ILk0wFKjcVlDyDoEMI7lccWXr+IjQCYwMh0LIRWk5yw5stB4PgdiimlgSVEwfVzECRmCgTuxmc/zoGS8IBLgQfvUqbp2R/1dP1ruyqffmTipCxBPPnQ7F5Dyo5PpBbuxNQ7D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 02:55:53PM -0600, Alex Williamson wrote:
> On Wed, 23 Jul 2025 16:00:10 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > From: Vivek Kasireddy <vivek.kasireddy@intel.com>
> > 
> > There is no need to share the main device pointer (struct vfio_device *)
> > with all the feature functions as they only need the core device
> > pointer. Therefore, extract the core device pointer once in the
> > caller (vfio_pci_core_ioctl_feature) and share it instead.
> > 
> > Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 30 +++++++++++++-----------------
> >  1 file changed, 13 insertions(+), 17 deletions(-)

<...>

> >  static int vfio_pci_core_pm_entry_with_wakeup(
> > -	struct vfio_device *device, u32 flags,
> > +	struct vfio_pci_core_device *vdev, u32 flags,
> >  	struct vfio_device_low_power_entry_with_wakeup __user *arg,
> >  	size_t argsz)
> 
> I'm tempted to fix the line wrapping here, but I think this patch
> stands on its own.  Even if it's rather trivial, it makes sense to
> consolidate and standardize on the vfio_pci_core_device getting passed
> around within vfio_pci_core.c.  Any reason not to split this off?

No problem, I will send it separately after merge window ends.

Thanks

> Thanks,
> 
> Alex

