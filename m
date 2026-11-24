Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F17E606A323
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y8zCkc0+
Received: by kanga.kvack.org (Postfix)
	id 766D56B07F5; Tue, 24 Nov 2026 12:26:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73E896B07F7; Tue, 24 Nov 2026 12:26:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630916B07F8; Tue, 24 Nov 2026 12:26:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 358AD6B07F5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:26:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC085A8392
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:26:08 +0000 (UTC)
X-FDA: 85470690816.09.23A87DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 08C46140009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:26:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y8zCkc0+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795541167;
	b=6yxuQfwFvf5jRohPt9M4kQWmw1D85wxJEgzBi2QPyDg8/4KZE028pyowe1NVeqHr16x3Dt
	zQyW2o32RwvWCfCPWeLXoNtiDbHiMurh0qhOMmysPioOIX8bn01mtHEYNInsb9DLlc6jor
	hG+1TXJ3aZCc4qAZvsXiYFmyDrNcGPs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795541167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pB0hPyMKD+vhgJUDCKouLHukFV8UEhyvi3gGX1fNKGI=;
	b=Ujs02v7v6kE3xMsTPEi78jHnqt2YTKAKqoaUZfagElvh3dGRUosgvc+s8AL4Jqk4phzP3D
	9u9A1YB/59EgRjxGRwG2Lhx4jO1CdpTCUSsGKIdD8HCwuggGj+KWvTKAIYBDbemDcnm9nb
	/blwfxHAvMwRDOYWOfBqhQgr9RT48nI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y8zCkc0+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2EE794369D;
	Tue, 24 Nov 2026 17:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5031F000C0;
	Tue, 24 Nov 2026 17:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795541166;
	bh=pB0hPyMKD+vhgJUDCKouLHukFV8UEhyvi3gGX1fNKGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y8zCkc0+9DGyKOLaZmgiI/zvuJpIqGArGooiio8dDQ8y0ZQMzzF6+WSFDgEvoEi/I
	 tvKFVBR+9P8UZLZuzz4+PON5jL1tUEB8UgA8ZMNtbJ9XdZPS20a/JVrIaSRIPRH7r/
	 aQqS7FXBR36BwXPAQrkI9plVuB0zVwYPqzzEOUCAZBWSZVCSVrsarp0Fy4v/x39AJk
	 ci7/IOPmZZKkP8haGJfpEEQ97Agfnqu9KDDpVR3M8DOVqJ2Ec5eLTjhunyxtWyPQGf
	 Ci7JHCiz3jniJf95hTT1gd1WWx69Pcq2Gy/BPjo0fn0X8qvFzARV0AA2YdhURM5Nqa
	 9CDmXB4t+yAxQ==
Date: Tue, 24 Nov 2026 17:25:59 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Guanghui Feng <guanghuifeng@linux.alibaba.com>, linux-mm@kvack.org, 
	alex@shazbot.org, alifm@linux.ibm.com, ankita@nvidia.com, dakr@kernel.org, 
	fengchengwen@huawei.com, kevin.tian@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mattev@meta.com, ritesh.list@gmail.com, xinmengs@nvidia.com
Subject: Re: [PATCH v2 2/2] vfio/pci: Align BAR mappings for huge page support
Message-ID: <awXIcSgV_YOke9yW@gremlin>
References: <20261124073048.268988-1-guanghuifeng@linux.alibaba.com>
 <20261124124004.457441-1-guanghuifeng@linux.alibaba.com>
 <20261124124004.457441-3-guanghuifeng@linux.alibaba.com>
 <20261124135258.GK9566@ziepe.ca>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124135258.GK9566@ziepe.ca>
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 08C46140009
X-Stat-Signature: mscp6w4ym3uc34o3nyeh9m34h3rzdsez
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795541166-156637
X-HE-Meta: U2FsdGVkX1/mWuwSIQDutqmhlWHl2TJGI8BBtJPZZGg5jNWGsorNbvnb3j0YixHcoMVJ3THnaOkl2pLekDW6RNbQdU9DDc40eb9iXZyeaKuC+na3Ddf6N0NPKB9+gxIyaqtRLq2N5Zr4Du/PsZpw8M7gHGwKPWi3KEXaPVjD733VbNsorH5XdJy0h/8ppI4W5FLKaRptnJBqW2ZnlHWHrRtW1JN3vq7ved2LfW/9LbRCfIkEMZpmbzXUtsIBEoooHYZouF2yQriYXD7Vih8SbqdZCYAbF0lbdwIG4suPQtXi6psq3YFnSigcyvDlxFv7iGVzSGKh9N7UIQDCS363ArhaivlBraCenhDU351nbG6ebXSqT3VNGuOj61Z33SGBcvxx+0Teiyayfp8SiWLvC3Xn6rRHz8cjr7dCMts+10/TwKELBaNK488rNxGq1RRZ0HF/EApwOEA+bntvSDLnnUOSLwjMKe3iwp4Jn30N2EeU8emAfpQf197NjVkawD3n4D6GkHzMYYQU+Lo+ijS1hF/47fROwoiF0t7any9RSX3ecKFqyugNj1JSMUgx3RPXp0Er1qdbS8VvMwMPv7TYif0wpNeRRMS/JduH6YViwrEzoV1Sq/2iyMK5Iga/k4hLyW86dDBUxrVuhfnupcxJ7IyywUXznUq80C4WcjsbB27NfRBXLPu5D17nvsk2LJynpsYIW50JAvzcApSBjTXADGiPG5/d3qE1PXsKkGMbqxKeK9wa5syS2OslJ2Ua4HaV367C9BYDB5ysFBpUrNVE/u8besmayawaALv2vMgwkZ6wq6sGNnYtcAklSVXi2N1DuGygIGwfBpeMjSsYeuIRcL3GwCl3dIYUwGAXWXtVL724uX/XKE7esjxB5mTdP2wrBU9za+xkEs0QMXttJUsLXl+yZcXkkXK8XwfXLR9omtJc2g7s0G/4nnHrW91gA2+a9xMb0BU5wy0lfbzieEt
 4Lq1lIFo
 vTX0fmVVQz949wDxq4nzj0kXHuigrhcVMdq+Q88bsC3tAmNkIw6ZWEVnYOVqKQF9iJ/eGGfMMk7BkEkH22CsN8Xq2p6OD/3OLEnqyKw0BOYRG+lbcrmC3te0kpzhLwirRJ/7fMOD6doua83Xkw1zqna67IE5LIpKumer4G+CRoDXMhUNXHHHuW7OQ1E7jOdNfU05CAszCA87NSTLKNVYhgJ7o7NMjfGZDQRfhWFJLbquaE3LYBSg3lAyi0FLemjF6HB05zF+FRKm9wGpjaQRtVfdpaNymYDccYfALGXOEP5cBjz6vm1GiyrhfQF9LKTziw1hfvZaGL2NxcbbYtMHYhaPVrk2B1Ft5mejYWwoytmUYdKVfkl+logtCZyl3pVvlSgdwBt0FFtpWczO/f7AS0M1l1DLG3PvNHaVOXFzl+q+zCHcYZRAlycUki9FmuDdtElvFpuPGc4m/E+dMkTbtOqsEV4E11Trq9LToGAIUeEcYDhHwVMkzWvs1HZDuYiaVZ7zEi546TKy8Ck/LLLkspkY6w444Hy8aw53EZXH8vwIMHi7X4rQUwwR4lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 09:52:58AM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 24, 2026 at 08:40:04PM +0800, Guanghui Feng wrote:
> > +unsigned long vfio_pci_core_get_unmapped_area(struct vfio_device *core_vdev,
> > +					      struct file *filp,
> > +					      unsigned long addr,
> > +					      unsigned long len,
> > +					      unsigned long pgoff,
> > +					      unsigned long flags)
> > +{
> > +	struct vfio_pci_core_device *vdev =
> > +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	unsigned long align, off, off_end, off_align, len_align, addr_align;
> > +	unsigned int index;
> > +	u64 bar_len;
> > +
> > +	/* Don't interfere with explicit address requests or fixed mappings */
> > +	if (addr || (flags & (MAP_FIXED | MAP_FIXED_NOREPLACE)))
> > +		goto out;
> > +
> > +	index = pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> > +	if (index >= VFIO_PCI_ROM_REGION_INDEX || !vdev->bar_mmap_supported[index])
> > +		goto out;
> > +
> > +	bar_len = pci_resource_len(pdev, index);
> > +	if (!bar_len)
> > +		goto out;
> > +
> > +	/*
> > +	 * Select the largest huge page size that the BAR physical alignment,
> > +	 * mapping length, and arch support can all satisfy.  Only PMD and PUD
> > +	 * orders are supported by vfio_pci_vmf_insert_pfn().
> > +	 */
> > +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) &&
> > +	    bar_len >= PUD_SIZE && len >= PUD_SIZE)
> > +		align = PUD_SIZE;
> > +	else if (bar_len >= PMD_SIZE && len >= PMD_SIZE)
> > +		align = PMD_SIZE;
> > +	else
> > +		goto out;
> > +
> > +	off = pgoff << PAGE_SHIFT;
> > +	off_end = off + len;
> > +	if (off_end < off)
> > +		goto out;
> > +	off_align = round_up(off, align);
> > +
> > +	/* The mapping has to span at least one fully aligned huge page */
> > +	if (off_end <= off_align || off_end - off_align < align)
> > +		goto out;
> > +
> > +	len_align = len + align;
> > +	if (len_align < len)
> > +		goto out;
> > +
> > +	/*
> > +	 * Find an area that can hold the mapping plus the slack needed to
> > +	 * shift it up to the next aligned address, then apply that shift.
> > +	 * The shift preserves the relative alignment of the file offset,
> > +	 * which is what makes the pfn alignment work out.
> > +	 */
> > +	addr_align = mm_get_unmapped_area(filp, addr, len_align, pgoff, flags);
> > +	if (!IS_ERR_VALUE(addr_align)) {
> > +		addr_align += (off - addr_align) & (align - 1);
> > +		return addr_align;
>
>
> PeterX was working on this previously and last time I was not excited
> to see all this mm logic open coded in drivers.
>
> I was hoping to see that the core mm could provide some helper scheme
> for drivers that already know what they want to map to get a vma
> alignment that is optimal for the architecutre.
>
> Peter had a design that seemed like a good exploration at least..

Well you and Matthew and I were discussing something similar previously also?

The AI fixgeddon is delaying any nice-to-haves of late, but in spirit yes, it's
appalling to have this mm code duplicated and it clearly shows a gap in the API.

>
> Jason

--
Cheers, Lorenzo

