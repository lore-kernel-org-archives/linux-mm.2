Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3FB8C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 23:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95A56B0088; Mon, 27 Jul 2026 19:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67016B008A; Mon, 27 Jul 2026 19:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97CC06B008C; Mon, 27 Jul 2026 19:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 571106B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:07:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6D68A0233
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:07:44 +0000 (UTC)
X-FDA: 85036095648.30.7B81183
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2290220009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:07:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Coo62tiQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785193663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=cO4H7SyXSWmzmogiLuNgyZmjdPhXBVrqySf37gDJpto=;
	b=Y+w4uOBCBez7xZd1+53/ROpUNK64pgvRjAbzBQsfpkiZuBCacYidfr0X0Fg5BCu7xoVPCz
	OuP0ySAShcrE9dMDHWI6QTH7GZnzidppcPHRICpnomfzXDuoLPhqBhXheI8W6s7d3JTca7
	JCVZrL0+RuSPoc0J3UPm0/qFkLuGSPA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Coo62tiQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785193663;
	b=6dq6mgg0+3Hrs1wZvxNRiWQO9Zjhf6EGbfLsASaymJkv6YaS5QtC1Y+yBKX7EywVlUa1Oe
	0/64GEsrIFv1gah+g+q/5HwJTvzq3cy+gRcufYj7rIMWuQ++oqv59Nra3R38V88dws/GpB
	m600qNP/Ym0/dXPExXHg9rEdJJVFZsw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0258241663;
	Mon, 27 Jul 2026 23:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEFBC1F000E9;
	Mon, 27 Jul 2026 23:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785193661;
	bh=cO4H7SyXSWmzmogiLuNgyZmjdPhXBVrqySf37gDJpto=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=Coo62tiQSLxOgaR7E2ulvwDVRvU7+la4nlWtaK9yFuompvjuKQFQB69D297yCiQQP
	 0HempbVTUtNTmH75yoMWOjNmH1+NS/8xr9RqwwN3f7sHhU1MKikde/8HV53MswvEly
	 lYWZ+4kC4dg7uiJZPXaCTCHXNl+zggFmWhS8GKIoEFsgtHgzRafJ665TrYgp61ty9U
	 VfY9XfPPVqptR22QibTbmAN4DP8RfYo7g5yVu7kup3xq/DoLjswMA3QOCrjPxgwqLT
	 YUv+1/HNQGHbwmRgzadmr5ol3ZhHxukLy2P2+dJ57hW7De2u72BapdsmDPgV7j8mJR
	 kUMNfVLw8mkNw==
Date: Mon, 27 Jul 2026 18:07:40 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v7 09/12] PCI: liveupdate: Inherit ARI Forwarding Enable
 on preserved bridges
Message-ID: <20260727230740.GA1273350@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710212616.1351130-10-dmatlack@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2290220009
X-Rspam-User: 
X-Stat-Signature: c918ypqax537btedhneorp6n4whwgtob
X-HE-Tag: 1785193663-634871
X-HE-Meta: U2FsdGVkX1/JSo/ArfvM96Ioz8G8E0QqHfdFnzWVy8/+zgIY7+vIK8e0mFFr9zt4cYO6FRbIhIptiz00+Z7y1ifFQY2grvX5Ly0R3ZMMHN7EWSfNFy1Oyb79hP2pPSgBjdGc6sDvz0SF96JXu5zLUgFVbE3ktjoxwmuNMOTddF5g0uMnfs2fjDfv80ZK0L/IwI2nRTCzEeCeTtFv7QSTNBTXDsg+4G7bPiwadW4EDfft9yMCGKWiQ4j5wZgfwBAkdLA2k2Xf4OfYf9x3bGwpuLcfqjMovQTsY8Wca4G//WMZxmfiX7xLNhIbWd/ZxebGziMa6/KNRFOIC+YZhdiV2frxtw7BbbPzjKsUWgO8UvTKXe50bxEq7TvHppaw4QNLGCOwe4tbfch+KDCEnk6kO5zrkrOiR1ahQGOI4kGOC7T+4AEwosxaB5XsulvC3qV4bfplsxm2yginNb24RUn+Tx/eNkceb7WOIY6X0LljOy5MdAqDJDx7fAs2PgM6mwm2fQWCcY0w5sB9hrxMGNxb/3yPPS5o82WYAzNorbLYZz4Nnbc7/MTgWl4IlsoO/iLuk/9BhKLMBUzglCPD/Cc9D8jivXmw+gyB6uP9IRsgG3rsgLnr1XiedZzUgUuLEqM2EULcYsi4tY9iZ9qr9zF9RWBcPe11AfcxWFSM0WPHZhpdMfM3ItJgajVYKxzj9/d6jrStzg3uu1W7tqHosO5+axwj4uXrg49O1ZjZSHInxb5wbXiNXziwZIs2Na64EB2tMJkU4L94PU6iKX7QeqdEMZIpQ4PvnI8og0L1uPPrdY6rbNoA4HwTpXq/8KhLKnmqgLfmr32ELgxLa+SFHjRQFOBQBPKRbjqCkLkgI6FlOIOVweu1TleGoxy1idmY59BlIbHmnaUNCv0xk30tuRs3Rft6o7ox3K7TJicbRK5uNhf3wtk1lFI1UXMlOC/x9MuqIpX2sZFzLmBXKW65sJg
 hpgYM7of
 m1oBXCInCe0PoKDAYH00WC0cqQdDwzha0kIGkJB7hgG1pjPgr/TxlHD/czUscz6Uhfp0er5ym0zFMjyIEAkxsTQZO5wZJRQ81lCCFteOx4hGcpwhvygweGn1pqRulHuErad9l/WnPfgEMxxzmDhKI1V3I36zAsvL/EsQ1spqxYzwiAK8OIrkapb5oZ61phfeFmESqSeAW9dFW/xUgU5sgxa5MruUtLj88Ar7BmUX4G2nCex6bOzW8hR0+AO6glzduARFFquBzfSBjUlo4lSbLSoUK4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:26:12PM +0000, David Matlack wrote:
> Inherit the ARI Forwarding Enable on preserved bridges and update
> pci_dev->ari_enabled accordingly during a Live Update. This ensures that
> the preserved devices on the bridge's secondary bus can be identified
> with the same expanded 8-bit function number after a Live Update.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/liveupdate.c | 18 ++++++++++++++++++
>  drivers/pci/liveupdate.h |  6 ++++++
>  drivers/pci/pci.c        |  8 +++++++-
>  3 files changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index a95bfe5eff77..74a11e520f0d 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -128,6 +128,10 @@
>   *    way after Live Update and ensures that IOMMU groups do not change. Note
>   *    that a device will use its inherited ACS flags for the lifetime of its
>   *    struct pci_dev (i.e. even after pci_liveupdate_finish()).
> + *
> + *  * The PCI core inherits ARI Forwarding Enable on all bridges with downstream
> + *    preserved devices to ensure that all preserved devices on the bridge's
> + *    secondary bus are addressable after the Live Update.
>   */
>  
>  #define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt
> @@ -816,6 +820,20 @@ int pci_liveupdate_enable_acs(struct pci_dev *dev)
>  	return 0;
>  }
>  
> +int pci_liveupdate_configure_ari(struct pci_dev *dev)
> +{
> +	u16 val;
> +
> +	guard(rwsem_read)(&pci_liveupdate.rwsem);
> +
> +	if (!dev->liveupdate.incoming)
> +		return -EINVAL;
> +
> +	pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &val);
> +	dev->ari_enabled = !!(val & PCI_EXP_DEVCTL2_ARI);
> +	return 0;
> +}

I'm guessing we're going to see a lot of this pattern, so it will
eventually become familiar, but it's not familiar yet ;)  This doesn't
"configure" anything (I do understand that avoiding configuration in
the new kernel is really the main point of liveupdate).

Maybe a comment is the solution.  Or maybe a rename to
"pci_liveupdate_ari_preserved" or something?  That would have to
reverse the sense of return values, but I think something like this in
the callers would read better:

  if (pci_liveupdate_ari_preserved(dev))
    return;

or maybe:

  if (pci_liveupdate_preserve_ari(dev))
    return;

>  /**
>   * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
>   * @dev: The PCI device to check
> diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
> index 4e8a01bcb4bb..6f21ec50927b 100644
> --- a/drivers/pci/liveupdate.h
> +++ b/drivers/pci/liveupdate.h
> @@ -18,6 +18,7 @@ bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus, struct pci_dev *dev,
>  void pci_liveupdate_scan_bridge_end(struct pci_dev *dev, int pass);
>  void pci_liveupdate_init_acs(struct pci_dev *dev);
>  int pci_liveupdate_enable_acs(struct pci_dev *dev);
> +int pci_liveupdate_configure_ari(struct pci_dev *dev);
>  #else
>  static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
>  {
> @@ -46,6 +47,11 @@ static inline int pci_liveupdate_enable_acs(struct pci_dev *dev)
>  {
>  	return -EINVAL;
>  }
> +
> +static inline int pci_liveupdate_configure_ari(struct pci_dev *dev)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #endif /* DRIVERS_PCI_LIVEUPDATE_H */
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 739ecaab2e76..e0c133b66a35 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3528,7 +3528,7 @@ void pci_configure_ari(struct pci_dev *dev)
>  	u32 cap;
>  	struct pci_dev *bridge;
>  
> -	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
> +	if (!pci_is_pcie(dev) || dev->devfn)
>  		return;
>  
>  	bridge = dev->bus->self;
> @@ -3539,6 +3539,12 @@ void pci_configure_ari(struct pci_dev *dev)
>  	if (!(cap & PCI_EXP_DEVCAP2_ARI))
>  		return;
>  
> +	if (!pci_liveupdate_configure_ari(bridge))
> +		return;
> +
> +	if (pcie_ari_disabled)
> +		return;
> +
>  	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI)) {
>  		pcie_capability_set_word(bridge, PCI_EXP_DEVCTL2,
>  					 PCI_EXP_DEVCTL2_ARI);
> -- 
> 2.55.0.795.g602f6c329a-goog
> 

